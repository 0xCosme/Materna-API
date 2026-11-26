// Microserviço de envio de códigos por e-mail.
//
//  1. A cada X segundos consulta tbl_codigo_envio (sem travar nada).
//  2. Para cada código pendente (enviado = false, criado há < 5 min),
//     "reserva" a linha com um UPDATE rápido.
//  3. Envia o e-mail (fora de qualquer transação).
//  4. Se o envio falhar, devolve a linha para a fila.
package main

import (
	"context"
	"crypto/tls"
	"database/sql"
	"fmt"
	"log"
	"mime"
	"net"
	"net/mail"
	"net/smtp"
	"os"
	"os/signal"
	"syscall"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

type configuracao struct {
	dsnBanco             string
	hostSMTP             string
	portaSMTP            string
	usuarioSMTP          string
	senhaSMTP            string
	remetenteSMTP        string
	intervaloVerificacao time.Duration
}

// codigoEnvio: só os campos necessários para o envio.
type codigoEnvio struct {
	ID     int
	Codigo int
	Email  string
}

func obterVariavel(chave, valorPadrao string) string {
	if valor := os.Getenv(chave); valor != "" {
		return valor
	}
	return valorPadrao
}

func carregarConfiguracao() configuracao {
	intervalo, erro := time.ParseDuration(obterVariavel("INTERVALO_VERIFICACAO", "10s"))
	if erro != nil {
		intervalo = 10 * time.Second
	}

	// Parâmetros extras do DSN:
	//  timeout / readTimeout / writeTimeout -> nunca ficar pendurado na rede
	//  innodb_lock_wait_timeout=5           -> se a outra API segurar um lock,
	//                                          desiste em 5s em vez de esperar 50s
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&loc=Local&timeout=5s&readTimeout=15s&writeTimeout=15s&innodb_lock_wait_timeout=5",
		obterVariavel("BANCO_USUARIO", "root"),
		obterVariavel("BANCO_SENHA", "12345678"),
		obterVariavel("BANCO_HOST", "127.0.0.1"),
		obterVariavel("BANCO_PORTA", "3306"),
		obterVariavel("BANCO_NOME", "db_tech_bridge_materna"),
	)

	usuario := obterVariavel("SMTP_USUARIO", "enviovalidacao@gmail.com")

	return configuracao{
		dsnBanco:             dsn,
		hostSMTP:             obterVariavel("SMTP_HOST", "smtp.gmail.com"),
		portaSMTP:            obterVariavel("SMTP_PORTA", "587"),
		usuarioSMTP:          usuario,
		senhaSMTP:            obterVariavel("SMTP_SENHA", "woqnzvgqrncwjrge"),
		remetenteSMTP:        obterVariavel("SMTP_REMETENTE", usuario), // padrão: o próprio usuário
		intervaloVerificacao: intervalo,
	}
}

func main() {
	config := carregarConfiguracao()

	if config.usuarioSMTP == "" || config.senhaSMTP == "" {
		log.Fatal("SMTP_USUARIO e SMTP_SENHA precisam ser definidos")
	}

	banco, erro := sql.Open("mysql", config.dsnBanco)
	if erro != nil {
		log.Fatalf("erro ao abrir conexão: %v", erro)
	}
	defer banco.Close()

	// Poucas conexões: o serviço faz uma operação por vez.
	banco.SetMaxOpenConns(2)
	banco.SetConnMaxLifetime(5 * time.Minute)

	ctxPing, cancelarPing := context.WithTimeout(context.Background(), 10*time.Second)
	erro = banco.PingContext(ctxPing)
	cancelarPing()
	if erro != nil {
		log.Fatalf("erro ao conectar no MySQL: %v", erro)
	}
	log.Println("conectado ao MySQL, monitorando tbl_codigo_envio...")

	contexto, parar := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer parar()

	temporizador := time.NewTicker(config.intervaloVerificacao)
	defer temporizador.Stop()

	processarPendentes(contexto, banco, config)

	for {
		select {
		case <-contexto.Done():
			log.Println("encerrando serviço...")
			return
		case <-temporizador.C:
			processarPendentes(contexto, banco, config)
		}
	}
}

func processarPendentes(contexto context.Context, banco *sql.DB, config configuracao) {
	pendentes, erro := buscarPendentes(contexto, banco)
	if erro != nil {
		log.Printf("erro ao consultar pendentes: %v", erro)
		return
	}

	for _, registro := range pendentes {
		// Se pediram para encerrar, não começa um novo envio.
		if contexto.Err() != nil {
			return
		}

		reservado, erro := reservarCodigo(contexto, banco, registro.ID)
		if erro != nil {
			log.Printf("erro ao reservar id=%d: %v", registro.ID, erro)
			continue
		}
		if !reservado {
			continue // outra instância já pegou este código
		}

		if erro := enviarEmail(config, registro); erro != nil {
			log.Printf("falha ao enviar código id=%d para %s: %v", registro.ID, registro.Email, erro)
			devolverCodigo(banco, registro.ID)
			continue
		}
		log.Printf("código id=%d enviado para %s", registro.ID, registro.Email)
	}
}

// buscarPendentes faz um SELECT comum (sem FOR UPDATE): não bloqueia ninguém.
func buscarPendentes(contexto context.Context, banco *sql.DB) ([]codigoEnvio, error) {
	ctx, cancelar := context.WithTimeout(contexto, 10*time.Second)
	defer cancelar()

	const consulta = `
		SELECT id, codigo, email
		FROM tbl_codigo_envio
		WHERE enviado = FALSE
		  AND data_criacao >= NOW() - INTERVAL 5 MINUTE
		ORDER BY data_criacao
		LIMIT 50`

	linhas, erro := banco.QueryContext(ctx, consulta)
	if erro != nil {
		return nil, erro
	}
	defer linhas.Close()

	var pendentes []codigoEnvio
	for linhas.Next() {
		var r codigoEnvio
		if erro := linhas.Scan(&r.ID, &r.Codigo, &r.Email); erro != nil {
			return nil, erro
		}
		pendentes = append(pendentes, r)
	}
	return pendentes, linhas.Err()
}

// reservarCodigo marca enviado = TRUE de forma atômica. Só devolve true para
// quem realmente mudou a linha, então duas instâncias nunca enviam o mesmo código.
// O lock dura milissegundos (UPDATE pela chave primária, em autocommit).
func reservarCodigo(contexto context.Context, banco *sql.DB, id int) (bool, error) {
	ctx, cancelar := context.WithTimeout(contexto, 5*time.Second)
	defer cancelar()

	resultado, erro := banco.ExecContext(ctx,
		`UPDATE tbl_codigo_envio SET enviado = TRUE WHERE id = ? AND enviado = FALSE`, id)
	if erro != nil {
		return false, erro
	}
	afetadas, erro := resultado.RowsAffected()
	if erro != nil {
		return false, erro
	}
	return afetadas == 1, nil
}

// devolverCodigo volta o código para a fila quando o envio falha.
// Usa um contexto próprio para funcionar mesmo durante o encerramento.
func devolverCodigo(banco *sql.DB, id int) {
	ctx, cancelar := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancelar()

	if _, erro := banco.ExecContext(ctx,
		`UPDATE tbl_codigo_envio SET enviado = FALSE WHERE id = ?`, id); erro != nil {
		log.Printf("não foi possível devolver id=%d para a fila: %v", id, erro)
	}
}

// enviarEmail fala SMTP "na mão" para poder aplicar timeouts
// (smtp.SendMail não tem nenhum).
func enviarEmail(config configuracao, registro codigoEnvio) error {
	// Valida o destinatário e usa só o endereço limpo (evita injeção de cabeçalho).
	destino, erro := mail.ParseAddress(registro.Email)
	if erro != nil {
		return fmt.Errorf("e-mail inválido: %w", erro)
	}

	assunto := mime.QEncoding.Encode("utf-8", "Seu código de verificação")
	corpo := fmt.Sprintf("Olá!\r\n\r\nSeu código de verificação é: %d\r\n\r\nEle é válido por 5 minutos.\r\n", registro.Codigo)

	mensagem := []byte("From: " + config.remetenteSMTP + "\r\n" +
		"To: " + destino.Address + "\r\n" +
		"Subject: " + assunto + "\r\n" +
		"MIME-Version: 1.0\r\n" +
		"Content-Type: text/plain; charset=\"UTF-8\"\r\n" +
		"\r\n" + corpo)

	endereco := net.JoinHostPort(config.hostSMTP, config.portaSMTP)

	conexao, erro := net.DialTimeout("tcp", endereco, 10*time.Second)
	if erro != nil {
		return erro
	}
	// Prazo total para toda a conversa SMTP.
	conexao.SetDeadline(time.Now().Add(30 * time.Second))

	cliente, erro := smtp.NewClient(conexao, config.hostSMTP)
	if erro != nil {
		return erro
	}
	defer cliente.Close()

	if erro := cliente.StartTLS(&tls.Config{ServerName: config.hostSMTP}); erro != nil {
		return erro
	}
	if erro := cliente.Auth(smtp.PlainAuth("", config.usuarioSMTP, config.senhaSMTP, config.hostSMTP)); erro != nil {
		return erro
	}
	if erro := cliente.Mail(config.remetenteSMTP); erro != nil {
		return erro
	}
	if erro := cliente.Rcpt(destino.Address); erro != nil {
		return erro
	}

	escritor, erro := cliente.Data()
	if erro != nil {
		return erro
	}
	if _, erro := escritor.Write(mensagem); erro != nil {
		escritor.Close()
		return erro
	}
	if erro := escritor.Close(); erro != nil {
		return erro
	}

	// Depois do Data() aceito o e-mail já foi entregue ao servidor.
	// Ignoramos erro no Quit para não reenviar um e-mail que já saiu.
	_ = cliente.Quit()
	return nil
}