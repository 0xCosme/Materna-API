// Microserviço de envio de códigos por e-mail.
//
// Funcionamento resumido:
//  1. A cada X segundos consulta a tabela tbl_codigo_envio no MySQL.
//  2. Pega os registros com enviado = false criados há menos de 5 minutos.
//  3. Envia o código por e-mail para o endereço do registro.
//  4. Se o envio der certo, grava enviado = true na tabela.
package main

import (
	"context"      // controle de cancelamento (encerrar o serviço com segurança)
	"database/sql" // acesso genérico a bancos de dados
	"fmt"          // formatação de textos
	"log"          // logs no terminal
	"mime"         // codifica o assunto do e-mail (acentos)
	"net/smtp"     // envio de e-mail via SMTP
	"os"           // leitura de variáveis de ambiente
	"os/signal"    // captura Ctrl+C / sinais do sistema
	"syscall"      // sinal SIGTERM (usado por Docker/Kubernetes)
	"time"         // tempo, durações e timers

	// O import com "_" apenas registra o driver do MySQL no database/sql.
	// Não usamos o pacote diretamente, por isso o underscore.
	_ "github.com/go-sql-driver/mysql"
)

// configuracao guarda todas as configurações do serviço,
// lidas das variáveis de ambiente (ver .env.example).
type configuracao struct {
	dsnBanco             string        // string de conexão com o MySQL
	hostSMTP             string        // servidor SMTP (ex.: smtp.gmail.com)
	portaSMTP            string        // porta do SMTP (587 = STARTTLS)
	usuarioSMTP          string        // usuário de login no SMTP
	senhaSMTP            string        // senha (ou senha de app) do SMTP
	remetenteSMTP        string        // e-mail remetente
	intervaloVerificacao time.Duration // intervalo entre cada consulta ao banco
}

// codigoEnvio representa uma linha da tabela tbl_codigo_envio.
// (id_doadora não é necessário para o envio, então não é carregado.)
type codigoEnvio struct {
	ID          int       // coluna id
	Codigo      int       // coluna codigo (o código que vai no e-mail)
	Email       string    // coluna email (destinatário)
	Enviado     bool      // coluna enviado
	DataCriacao time.Time // coluna data_criacao
}

// obterVariavel lê uma variável de ambiente.
// Se ela não existir (ou estiver vazia), devolve o valor padrão.
func obterVariavel(chave, valorPadrao string) string {
	if valor := os.Getenv(chave); valor != "" {
		return valor
	}
	return valorPadrao
}

// carregarConfiguracao monta a configuração a partir das variáveis de ambiente.
func carregarConfiguracao() configuracao {
	// Converte textos como "10s" ou "1m" em time.Duration.
	// Se o valor for inválido, usa 10 segundos como padrão.
	intervalo, erro := time.ParseDuration(obterVariavel("INTERVALO_VERIFICACAO", "10s"))
	if erro != nil {
		intervalo = 10 * time.Second
	}

	// DSN = Data Source Name, o "endereço" do banco no formato do driver:
	//   usuario:senha@tcp(host:porta)/nome_do_banco?opcoes
	// parseTime=true faz o driver converter DATETIME em time.Time.
	// loc=Local usa o fuso horário da máquina onde o serviço roda.
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&loc=Local",
		obterVariavel("BANCO_USUARIO", "root"),
		obterVariavel("BANCO_SENHA", ""),
		obterVariavel("BANCO_HOST", "127.0.0.1"),
		obterVariavel("BANCO_PORTA", "3306"),
		obterVariavel("BANCO_NOME", "db_tech_bridge_materna"),
	)

	return configuracao{
		dsnBanco:             dsn,
		hostSMTP:             obterVariavel("SMTP_HOST", ""),
		portaSMTP:            obterVariavel("SMTP_PORTA", "587"),
		usuarioSMTP:          obterVariavel("SMTP_USUARIO", ""),
		senhaSMTP:            obterVariavel("SMTP_SENHA", ""),
		remetenteSMTP:        obterVariavel("SMTP_REMETENTE", ""),
		intervaloVerificacao: intervalo,
	}
}

// main é o ponto de entrada: conecta no banco e fica em loop
// verificando novos códigos até o serviço ser encerrado.
func main() {
	config := carregarConfiguracao()

	// sql.Open NÃO conecta de verdade; só prepara o "pool" de conexões.
	banco, erro := sql.Open("mysql", config.dsnBanco)
	if erro != nil {
		log.Fatalf("erro ao abrir conexão: %v", erro)
	}
	defer banco.Close() // fecha as conexões quando o programa terminar

	// Ajustes do pool de conexões
	banco.SetMaxOpenConns(5)                  // no máximo 5 conexões simultâneas
	banco.SetConnMaxLifetime(5 * time.Minute) // renova conexões antigas

	// Ping testa de fato se o MySQL está acessível.
	if erro := banco.Ping(); erro != nil {
		log.Fatalf("erro ao conectar no MySQL: %v", erro)
	}
	log.Println("conectado ao MySQL, monitorando tbl_codigo_envio...")

	// Cria um contexto que é cancelado quando o usuário aperta Ctrl+C
	// ou quando o sistema manda SIGTERM. Isso permite encerrar com elegância.
	contexto, parar := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer parar()

	// O temporizador dispara um evento a cada "intervaloVerificacao".
	temporizador := time.NewTicker(config.intervaloVerificacao)
	defer temporizador.Stop()

	// Faz uma verificação imediata na partida, sem esperar o primeiro disparo.
	processarPendentes(contexto, banco, config)

	// Loop principal: espera o próximo disparo ou o pedido de encerramento.
	for {
		select {
		case <-contexto.Done(): // recebeu Ctrl+C / SIGTERM
			log.Println("encerrando serviço...")
			return
		case <-temporizador.C: // chegou a hora de verificar o banco de novo
			processarPendentes(contexto, banco, config)
		}
	}
}

// processarPendentes busca os códigos ainda não enviados (criados nos últimos
// 5 minutos), envia cada um por e-mail e marca enviado = true no banco.
func processarPendentes(contexto context.Context, banco *sql.DB, config configuracao) {
	// Usamos uma transação para que o "lock" das linhas dure até o final do
	// processamento. Assim, outra instância do serviço não pega as mesmas linhas.
	transacao, erro := banco.BeginTx(contexto, nil)
	if erro != nil {
		log.Printf("erro ao iniciar transação: %v", erro)
		return
	}
	// Se algo der errado antes do Commit, o Rollback desfaz tudo.
	// (Depois de um Commit bem-sucedido, o Rollback não faz nada.)
	defer transacao.Rollback()

	// Explicação da consulta:
	//  - enviado = FALSE                       -> ainda não foi enviado
	//  - data_criacao >= NOW() - 5 MINUTE      -> criado há menos de 5 minutos
	//  - ORDER BY data_criacao                 -> os mais antigos primeiro
	//  - LIMIT 50                              -> processa no máximo 50 por ciclo
	//  - FOR UPDATE SKIP LOCKED                -> trava as linhas e ignora as que
	//                                             outra instância já travou
	//                                             (exige MySQL 8+)
	const consulta = `
		SELECT id, codigo, email, enviado, data_criacao
		FROM tbl_codigo_envio
		WHERE enviado = FALSE
		  AND data_criacao >= NOW() - INTERVAL 5 MINUTE
		ORDER BY data_criacao
		LIMIT 50
		FOR UPDATE SKIP LOCKED`

	linhas, erro := transacao.QueryContext(contexto, consulta)
	if erro != nil {
		log.Printf("erro ao consultar pendentes: %v", erro)
		return
	}

	// Lê todas as linhas para a memória antes de enviar os e-mails.
	// Isso libera o cursor do banco e deixa o código mais simples.
	var pendentes []codigoEnvio
	for linhas.Next() {
		var registro codigoEnvio
		// Scan copia as colunas, na mesma ordem do SELECT, para a struct.
		if erro := linhas.Scan(&registro.ID, &registro.Codigo, &registro.Email, &registro.Enviado, &registro.DataCriacao); erro != nil {
			log.Printf("erro ao ler linha: %v", erro)
			continue
		}
		pendentes = append(pendentes, registro)
	}
	linhas.Close()

	// Para cada código pendente: envia o e-mail e, se deu certo, atualiza o banco.
	for _, registro := range pendentes {
		if erro := enviarEmail(config, registro); erro != nil {
			// Falhou: não marcamos como enviado. Ele continua pendente e será
			// tentado de novo no próximo ciclo (enquanto tiver menos de 5 min).
			log.Printf("falha ao enviar código id=%d para %s: %v", registro.ID, registro.Email, erro)
			continue
		}

		// Sucesso no envio: grava enviado = TRUE para não enviar de novo.
		if _, erro := transacao.ExecContext(contexto, `UPDATE tbl_codigo_envio SET enviado = TRUE WHERE id = ?`, registro.ID); erro != nil {
			log.Printf("e-mail enviado, mas falhou ao atualizar id=%d: %v", registro.ID, erro)
			continue
		}
		log.Printf("código id=%d enviado para %s", registro.ID, registro.Email)
	}

	// Confirma as alterações (UPDATEs) e libera os locks das linhas.
	if erro := transacao.Commit(); erro != nil {
		log.Printf("erro ao confirmar transação: %v", erro)
	}
}

// enviarEmail monta a mensagem e envia o código para o e-mail do registro.
func enviarEmail(config configuracao, registro codigoEnvio) error {
	// Codifica o assunto para que acentos apareçam corretamente no e-mail.
	assunto := mime.QEncoding.Encode("utf-8", "Seu código de verificação")

	// Corpo da mensagem. "\r\n" é a quebra de linha exigida pelo protocolo SMTP.
	corpo := fmt.Sprintf("Olá!\r\n\r\nSeu código de verificação é: %d\r\n\r\nEle é válido por 5 minutos.\r\n", registro.Codigo)

	// Monta a mensagem completa: cabeçalhos + linha em branco + corpo.
	mensagem := []byte("From: " + config.remetenteSMTP + "\r\n" +
		"To: " + registro.Email + "\r\n" +
		"Subject: " + assunto + "\r\n" +
		"MIME-Version: 1.0\r\n" +
		"Content-Type: text/plain; charset=\"UTF-8\"\r\n" +
		"\r\n" + corpo)

	// Autenticação SMTP com usuário e senha.
	autenticacao := smtp.PlainAuth("", config.usuarioSMTP, config.senhaSMTP, config.hostSMTP)
	endereco := config.hostSMTP + ":" + config.portaSMTP

	// SendMail conecta no servidor, faz STARTTLS automaticamente (porta 587),
	// autentica e envia a mensagem.
	return smtp.SendMail(endereco, autenticacao, config.remetenteSMTP, []string{registro.Email}, mensagem)
}