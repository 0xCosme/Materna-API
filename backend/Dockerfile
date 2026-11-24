FROM node:20-alpine

WORKDIR /app

# Copia só os arquivos de dependências primeiro (aproveita o cache do Docker)
COPY package*.json ./

# Baixa as dependências
RUN npm install

# Copia o restante do projeto
COPY . .

EXPOSE 9090

CMD ["node", "app.js"]