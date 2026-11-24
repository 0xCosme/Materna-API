FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=12345678

CMD ["--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]

# Scripts auxiliares
COPY ./Scripts /docker-entrypoint-initdb.d/Scripts

# Script principal
COPY ./main.sql /docker-entrypoint-initdb.d/01-init.sql

EXPOSE 3306