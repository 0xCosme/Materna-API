FROM node:20-alpine
WORKDIR /app

# Instala as dependências dentro do container
COPY package*.json ./
RUN npm install

# Copia o restante do projeto
COPY . .

EXPOSE 5173

# --host permite acessar o Vite de fora do container
CMD ["npm", "run", "dev", "--", "--host"]

#docker run -d --name Materna-FrontEnd -p 80:5173 -v "${PWD}:/app" -v /app/node_modules materna-frontend