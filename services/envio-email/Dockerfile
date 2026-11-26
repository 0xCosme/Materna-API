# ---------- Etapa 1: compilar ----------
FROM golang:1.24-alpine AS build

WORKDIR /src

# Dependências primeiro (aproveita o cache do Docker)
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /envio-email .

# ---------- Etapa 2: imagem final (pequena) ----------
FROM alpine:3.20

# ca-certificates: necessário para validar o TLS do servidor SMTP
# tzdata: fusos horários
RUN apk add --no-cache ca-certificates tzdata \
 && adduser -D -u 10001 app

COPY --from=build /envio-email /usr/local/bin/envio-email

USER app

CMD ["envio-email"]