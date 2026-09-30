create database db_tech_bridge_materna;

use db_tech_bridge_materna;

#ENDERECO
########################################################################################

#CRIAÇÃO DA TABELA estado
create table tbl_estado(
	id 			int                     not null primary key auto_increment,
    sigla 		varchar (3)             not null
);

#CRIAÇÃO DA TABELA cidade
create table tbl_cidade(
	id 			int                     not null primary key auto_increment,
    nome 		varchar (100)           not null,

    id_estado   int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_ESTADO_CIDADE	      # nome do relacionamento
    foreign key			(id_estado)				      # quem sera a FK natabla FK(foren key)
    references			tbl_estado(id)			      # de onde vem a FK
);

#criacao da tabela endereco
create table tbl_endereco(
    id 		             int            not null primary key auto_increment,
    logradouro 	         varchar(100) 	not null,
    cep 	             varchar(20) 	not null,
    bairro 	             varchar(50) 	not null,
    numero               varchar(10)    not null,
    complemento 	     varchar(50) 	not null,
    
    latitude             decimal(11,8)  not null,
    longitude            decimal(11,8)  not null,

    id_cidade            int not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_CIDADE_ENDERECO	      # nome do relacionamento
    foreign key			(id_cidade)				        # quem sera a FK natabla FK(foren key)
    references			tbl_cidade(id)			      # de onde vem a FK

);
#########################################################################################################

#CRIAÇÃO DA TABELA telefone
create table tbl_telefone(
	id 			int                     not null primary key auto_increment,
    numero 		varchar (25)            not null
);



#DOADORA
###########################################################################################################

#CRIAÇÃO DA TABELA doadora
create table tbl_doadora(
	id 			        int             not null primary key auto_increment,
    nome 		        varchar (100)   not null,
    cpf 		        varchar (15)    not null,
    foto 		        varchar (255),
    data_nascimento 	date            not null,
    email            	varchar(255)    not null,
    senha               varchar(255)    not null,
    sal                 varchar(255)    not null
);


create table tbl_endereco_doadora(
	id 			        int             not null primary key auto_increment,
    

    id_doadora          int             not null,

    id_endereco         int             not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_ENDERECO	          # nome do relacionamento
    foreign key			(id_doadora)				  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id),			  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_ENDERECO_DOADORA          # nome do relacionamento
    foreign key			(id_endereco)				  # quem sera a FK natabla FK(foren key)
    references			tbl_endereco(id)			  # de onde vem a FK

); 

create table tbl_telefone_doadora(
	id 			        int             not null primary key auto_increment,

    id_doadora          int             not null,
    id_telefone         int             not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_TELEFONE	          # nome do relacionamento
    foreign key			(id_doadora)				  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id),			  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_TELEFONE_DOADORA	          # nome do relacionamento
    foreign key			(id_telefone)				  # quem sera a FK natabla FK(foren key)
    references			tbl_telefone(id)			  # de onde vem a FK

); 

################################################################################################################



#FUNCIONARIO
######################################################################################################################

#CRIAÇÃO DA TABELA funcionario
create table tbl_funcionario(
	id 			        int             not null primary key auto_increment,
    nome 		        varchar (100)   not null,
    cpf 		        varchar (15)    not null,
    data_nascimento 	date            not null,
    email            	varchar(255)    not null,
    adm                 boolean         not null,
    senha               varchar(255)    not null,
    sal                 varchar(255)    not null
);

create table tbl_telefone_funcionario(
	id 			        int             not null primary key auto_increment,

    id_funcionario      int             not null,
    id_telefone         int             not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_FUNCIONARIO_TELEFONE	          # nome do relacionamento
    foreign key			(id_funcionario)				  # quem sera a FK natabla FK(foren key)
    references			tbl_funcionario(id),			  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_TELEFONE_FUNCIONARIO	          # nome do relacionamento
    foreign key			(id_telefone)				      # quem sera a FK natabla FK(foren key)
    references			tbl_telefone(id)			      # de onde vem a FK

); 

######################################################################################################################



#INSTITUICAO
###################################################################################################################

#CRIAÇÃO DA TABELA tipo coleta
create table tbl_tipo_coleta(
	id 			int                     not null primary key auto_increment,
    tipo 		varchar (50)            not null
);

create table tbl_instituicao(
	id 			        int             not null primary key auto_increment,
    nome 		        varchar (100)   not null,
    cnpj 		        varchar (30)    not null,
    email            	varchar(255)    not null,
    foto                varchar(255)    not null,

    id_coleta           int             not null,
    
    #fazer relacao entre duas tabelas 
    constraint			FK_TIPOCOLETA_INSTITUICAO         # nome do relacionamento
    foreign key			(id_coleta)				          # quem sera a FK natabla FK(foren key)
    references			tbl_tipo_coleta(id)			      # de onde vem a FK

);

create table tbl_horario_funcionamento(
	id 			        int             not null primary key auto_increment,
    dia 		        int             not null,
    hora_inicio         time            not null,
    hora_fim           	time            not null,


    id_instituicao      int             not null,
    
    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_HORARIO               # nome do relacionamento
    foreign key			(id_instituicao)				     # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id)			          # de onde vem a FK

);


create table tbl_endereco_instituicao(
	id 			        int             not null primary key auto_increment,
    

    id_instituicao      int             not null,
    id_endereco         int             not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_ENDERECO	          # nome do relacionamento
    foreign key			(id_instituicao)				  # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id),			  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_ENDERECO_INSTITUICAO          # nome do relacionamento
    foreign key			(id_endereco)				     # quem sera a FK natabla FK(foren key)
    references			tbl_endereco(id)			     # de onde vem a FK

); 

create table tbl_telefone_instituicao(
	id 			        int             not null primary key auto_increment,

    id_instituicao      int             not null,
    id_telefone         int             not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_TELEFONE       # nome do relacionamento
    foreign key			(id_instituicao)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id),		  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_TELEFONE_INSTITUICAO       # nome do relacionamento
    foreign key			(id_telefone)				  # quem sera a FK natabla FK(foren key)
    references			tbl_telefone(id)			  # de onde vem a FK

); 

#############################################################################################################################

#CRIAÇÃO DA TABELA campanha
create table tbl_campanha(
	id 			    int                     not null primary key auto_increment,
    titulo 		    varchar(100)             not null,
    descricao       text                    not null,
    foto            varchar(255)            not null,
    data_inicio     date                    not null,
    data_fim        date                    not null,
    is_ativo        boolean                 not null,

    id_instituicao  int                     not null,
    id_funcionario  int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_CAMPANHA       # nome do relacionamento
    foreign key			(id_instituicao)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id),		  # de onde vem a FK

    #fazer relacao entre duas tabelas 
    constraint			FK_FUNCIONARIO_CAMPANHA       # nome do relacionamento
    foreign key			(id_funcionario)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_funcionario(id)		      # de onde vem a FK


);

#####################################################################################################
#####################################################
#################################################
########################################
#CRIAÇÃO DA TABELA jornada
create table tbl_jornada(
	id 			int                     not null primary key auto_increment,
    is_ativo 	boolean                 not null,
    nome        varchar(50)             not null,
    descricao	text,	
    
    id_instituicao		int				not null,
    
    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_JORNADA        # nome do relacionamento
    foreign key			(id_instituicao)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id)		      # de onde vem a FK
    
);


#CRIAÇÃO DA TABELA etapa
create table tbl_etapa(
	id 			    int                     not null primary key auto_increment,
    titulo 		    varchar(100)             not null,
    descricao       text                    not null,

    is_agendavel        boolean                 not null,
    is_obrigatorio      boolean                 not null,
    is_solicita_arquivo      boolean                 not null,
    is_precisa_aprovacao      boolean                 not null,
    material_instituicao      varchar(255)                 ,
    

    id_jornada  int                     not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_JORNADA_ETAPA       # nome do relacionamento
    foreign key			(id_jornada)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_jornada(id)		  # de onde vem a FK

);


#CRIAÇÃO DA TABELA ciclo
create table tbl_ciclo(
	id 			    int                     not null primary key auto_increment,
    titulo 		    varchar(100)             not null,
    numero_ciclo    int                    not null,

    is_cocluido	      boolean                 not null,

    

    id_jornada  int                     not null,
    id_doadora  int                     not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_JORNADA_CICLO       # nome do relacionamento
    foreign key			(id_jornada)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_jornada(id),		  # de onde vem a FK


	#fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_CICLO       # nome do relacionamento
    foreign key			(id_doadora)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id)		  # de onde vem a FK
);


#CRIAÇÃO DA TABELA etapa ciclo
create table tbl_etapa_ciclo(
	id 			    int                     not null primary key auto_increment,
    data_conclusao 		date             not null,
    

    

    id_etapa  int                     not null,
    id_ciclo  int                     not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPA_ETAPACICLO       # nome do relacionamento
    foreign key			(id_etapa)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_etapa(id),		  # de onde vem a FK


	#fazer relacao entre duas tabelas 
    constraint			FK_CICLO_ETAPACICLO       # nome do relacionamento
    foreign key			(id_ciclo)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_ciclo(id)		  # de onde vem a FK
);


##############


#CRIAÇÃO DA TABELA cadastro horario
create table tbl_cadastro_horario(
	id 			int                     not null primary key auto_increment,
    dia 		date                    not null,
    horario     time                    not null
);


#CRIAÇÃO DA TABELA statu agendamento
create table tbl_statu_agendamento(
	id 			int                     not null primary key auto_increment,
    statu 		varchar (25)            not null
);


#CRIAÇÃO DA TABELA agendamento
create table tbl_agendamento(
	id 			    int                     not null primary key auto_increment,
  
    
	id_ciclo  						 int                     not null,
    id_cadastro_horario				  int                     not null,
    id_status_agendamento			  int                     not null,


	#fazer relacao entre duas tabelas 
    constraint			FK_CICLO_AGENDAMENTO      # nome do relacionamento
    foreign key			(id_ciclo)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_ciclo(id),		  # de onde vem a FK
    
    #fazer relacao entre duas tabelas 
    constraint			FK_CADASTROHORARIO_AGENDAMENTO      # nome do relacionamento
    foreign key			(id_cadastro_horario)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_cadastro_horario(id),		  # de onde vem a FK
    
    #fazer relacao entre duas tabelas 
    constraint			FK_STATUSAGENDAMENTO_AGENDAMENTO      # nome do relacionamento
    foreign key			(id_status_agendamento)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_status_agendamento(id)		  # de onde vem a FK
    
    
);



#CRIAÇÃO DA TABELA etapa ciclo
create table tbl_documento_instituicao(
	id 			    int                     not null primary key auto_increment,
    documento		varchar(255)             not null,
    
    id_etapa  int                     not null,



    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPA_DOCUMENTOINSTITUICAO       # nome do relacionamento
    foreign key			(id_etapa)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_etapa(id)		  # de onde vem a FK

);



#CRIAÇÃO DA TABELA documento doadora
create table tbl_documento_doadora(
	id 			    int                     not null primary key auto_increment,
    documento		varchar(255)             not null,
    motivo_recusa		varchar(255)             not null,
    
    id_etapa_ciclo  int                     not null,
    id_doadora  int                     not null,



    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPACICLO_DOCUMENTODOADORA       # nome do relacionamento
    foreign key			(id_etapa_ciclo)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_etapa_ciclo(id),		  # de onde vem a FK
    
     #fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_DOCUMENTODOADORA       # nome do relacionamento
    foreign key			(id_doadora)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id)		  # de onde vem a FK

);

