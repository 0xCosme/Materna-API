CREATE DATABASE IF NOT EXISTS db_tech_bridge_materna;

USE db_tech_bridge_materna;

SOURCE /docker-entrypoint-initdb.d/Scripts/create_tabelas.sql;
SOURCE /docker-entrypoint-initdb.d/Scripts/procidure_casdastro.sql;
SOURCE /docker-entrypoint-initdb.d/Scripts/procidure_update.sql;
SOURCE /docker-entrypoint-initdb.d/Scripts/insert.sql;