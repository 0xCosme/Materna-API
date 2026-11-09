package main

import (
	"fmt"
	"log"
	// Importações nativas para rede e e-mail
	"net/smtp"
)

func main() {
	// 1. Configurações de autenticação e servidor
	from := "seu-email@gmail.com"
	password := "sua-senha-ou-token" // Senha de App se for Gmail/Outlook
	smtpHost := "smtp.gmail.com"
	smtpPort := "587"

	// Destinatário
	to := []string{"destinatario@email.com"}

	// 2. Estrutura básica da mensagem (Cabeçalhos RFC 822 obrigatórios)
	subject := "Assunto do Email Nativo em Go\n"
	body := "Olá! Este e-mail foi enviado utilizando o pacote nativo net/smtp do Go."
	
	// É preciso montar a string completa respeitando as quebras de linha
	message := []byte("From: " + from + "\n" +
		"To: " + to[0] + "\n" +
		"Subject: " + subject + "\n" +
		body)

	// 3. Configurando a autenticação PlainAuth
	auth := smtp.PlainAuth("", from, password, smtpHost)

	// 4. Enviando o e-mail
	fmt.Println("Enviando e-mail...")
	err := smtp.SendMail(smtpHost+":"+smtpPort, auth, from, to, message)
	if err != nil {
		log.Fatalf("Erro ao enviar o e-mail: %s", err)
	}

	fmt.Println("E-mail enviado com sucesso!")
}
