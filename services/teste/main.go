package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/smtp"
	"strconv"
	"time"

	_ "github.com/go-sql-driver/mysql" // driver (o "_" registra o driver)
)

type CodigoEmail struct {
	ID          int
	Codigo      int
	Email       string
	Enviado     bool
	DataCriacao time.Time
}

func pegardados() []CodigoEmail {
	host := "localhost"
	porta := "3306"
	usuario := "root"
	senha := "12345678"
	banco := "db_tech_bridge_materna"

	// parseTime=true é necessário para o driver converter DATETIME em time.Time
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true",
		usuario, senha, host, porta, banco,
	)

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Consulta
	rows, err := db.Query("SELECT id, codigo, email, enviado, data_criacao FROM tbl_codigo_envio")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	//cria um slice vazio
	var codigos []CodigoEmail

	//coloca os coisa dentro do slice codigoemail
	for rows.Next() {
		var c CodigoEmail
		err := rows.Scan(&c.ID, &c.Codigo, &c.Email, &c.Enviado, &c.DataCriacao)
		if err != nil {
			log.Fatal(err)
		}
		codigos = append(codigos, c)
	}
	return codigos
}

func enviacodigo(destinatario, cod string) {
	fmt.Println("codigo sendo enviado")

	servidorSMTP := "smtp.gmail.com"
	portaSMTP := "587"
	usuarioSMTP := "gsdgfdsfsdfg@gmail.com"
	senhaSMTP := "gsdgsgrgfsd"
	emailDestino := destinatario
	assuntoEmail := "Codigo de Validacao"
	textoemail := "codigo de validacao" + cod

	conteudo := []byte(
		"From: " + usuarioSMTP + "\r\n" +
			"To: " + emailDestino + "\r\n" +
			"Subject: " + assuntoEmail + "\r\n\r\n" +
			textoemail,
	)

	autenticacao := smtp.PlainAuth(
		"",
		usuarioSMTP,
		senhaSMTP,
		servidorSMTP,
	)

	//enviar

	err := smtp.SendMail(
		servidorSMTP+":"+portaSMTP,
		autenticacao,
		usuarioSMTP,
		[]string{emailDestino},
		conteudo,
	)

	if err != nil {
		fmt.Println("deu erro pra enviar", err)
	}

}

func main() {

	codigos := pegardados()
	for _, c := range codigos {

		enviacodigo(c.Email, strconv.Itoa(c.Codigo))
		fmt.Printf("%+v\n", c)
	}
}
