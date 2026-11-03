#drop database db_tech_bridge_materna;

#CRIA BANCO
create database db_tech_bridge_materna;

#USA BANCO
use db_tech_bridge_materna;


# Import script de criação de tabelas
SOURCE ./script/create_tabelas.sql;

# Import script de criação das procidure de cadastro
SOURCE ./script/procidure_casdastro.sql;

# Import script de criação das procidure de atualizacao
SOURCE ./script/procidure_update.sql;

