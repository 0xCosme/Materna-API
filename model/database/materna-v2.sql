create database db_tech_bridge_materna;

use db_tech_bridge_materna;

#ENDERECO
########################################################################################

#CRIAÇÃO DA TABELA estado
create table tbl_estado(
	id 			          int                     not null primary key auto_increment,
    sigla 		          varchar (3)             not null
);

#CRIAÇÃO DA TABELA cidade
create table tbl_cidade(
	id 			          int                     not null primary key auto_increment,
    nome 		          varchar (100)           not null,

    id_estado             int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_ESTADO_CIDADE	          # nome do relacionamento
    foreign key			(id_estado)				      # quem sera a FK natabla FK(foren key)
    references			tbl_estado(id)			      # de onde vem a FK
);

#criacao da tabela endereco
create table tbl_endereco(
    id 		             int                    not null primary key auto_increment,
    logradouro 	         varchar(100)    	    not null,
    cep 	             varchar(20) 	        not null,
    bairro 	             varchar(50) 	        not null,
    numero               varchar(10)            not null,
    complemento 	     varchar(50) 	        not null,
    
    latitude             decimal(11,8)          not null,
    longitude            decimal(11,8)          not null,

    id_cidade            int not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_CIDADE_ENDERECO	      # nome do relacionamento
    foreign key			(id_cidade)				        # quem sera a FK natabla FK(foren key)
    references			tbl_cidade(id)			      # de onde vem a FK

);
#########################################################################################################

#CRIAÇÃO DA TABELA telefone
create table tbl_telefone(
	id 			        int                     not null primary key auto_increment,
    numero 		        varchar (25)            not null
);



#DOADORA
###########################################################################################################

#CRIAÇÃO DA TABELA doadora
create table tbl_doadora(
	id 			        int                     not null primary key auto_increment,
    nome 		        varchar (100)           not null,
    cpf 		        varchar (15)            not null,
    foto 		        varchar (255),
    data_nascimento 	date                    not null,
    email            	varchar(255)            not null,
    senha               varchar(255)            not null,
    sal                 varchar(255)            not null,

    id_endereco         int                     not null,
    id_telefone         int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_ENDERECO_DOADORA          # nome do relacionamento
    foreign key			(id_endereco)				  # quem sera a FK natabla FK(foren key)
    references			tbl_endereco(id),			  # de onde vem a FK


    #fazer relacao entre duas tabelas 
    constraint			FK_TELEFONE_DOADORA	          # nome do relacionamento
    foreign key			(id_telefone)				  # quem sera a FK natabla FK(foren key)
    references			tbl_telefone(id)			  # de onde vem a FK

);

################################################################################################################


#INSTITUICAO
###################################################################################################################

#CRIAÇÃO DA TABELA tipo coleta
create table tbl_tipo_coleta(
	id 			int                             not null primary key auto_increment,
    tipo 		varchar (50)                    not null
);

create table tbl_instituicao(
	id 			        int                     not null primary key auto_increment,
    nome 		        varchar (100)           not null,
    cnpj 		        varchar (30)            not null,
    email            	varchar(255)            not null,
    foto                varchar(255)            not null,

    id_coleta           int                     not null,
    id_endereco         int                     not null,

    
    #fazer relacao entre duas tabelas 
    constraint			FK_TIPOCOLETA_INSTITUICAO         # nome do relacionamento
    foreign key			(id_coleta)				          # quem sera a FK natabla FK(foren key)
    references			tbl_tipo_coleta(id),			      # de onde vem a FK

    #fazer relacao entre duas tabelas 
    constraint			FK_ENDERECO_INSTITUICAO          # nome do relacionamento
    foreign key			(id_endereco)				     # quem sera a FK natabla FK(foren key)
    references			tbl_endereco(id)			     # de onde vem a FK

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

##########################################################################################################################################
#CRIAÇÃO DA TABELA funcionario
create table tbl_funcionario(
	id 			        int                     not null primary key auto_increment,
    nome 		        varchar (100)           not null,
    cpf 		        varchar (15)            not null,
    data_nascimento 	date                    not null,
    email            	varchar(255)            not null,
    adm                 boolean                 not null,
    senha               varchar(255)            not null,
    sal                 varchar(255)            not null,

    id_telefone         int                     not null,
    id_instituicao      int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_TELEFONE_FUNCIONARIO	          # nome do relacionamento
    foreign key			(id_telefone)				      # quem sera a FK natabla FK(foren key)
    references			tbl_telefone(id),                 # de onde vem a FK



    #fazer relacao entre duas tabelas 
    constraint          FK_INSTITUICAO_FUNCIONARIO    # nome do relacionamento
    foreign key         (id_instituicao)              # quem sera a FK na tabela
    references          tbl_instituicao(id)           # de onde vem a FK

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
	id 			            int                         not null primary key auto_increment,
    is_ativo 	            boolean                     not null,
    nome                    varchar(50)                 not null,
    descricao	            text,	
    
    id_instituicao		    int				            not null,
    
    #fazer relacao entre duas tabelas 
    constraint			FK_INSTITUICAO_JORNADA        # nome do relacionamento
    foreign key			(id_instituicao)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_instituicao(id)		      # de onde vem a FK
    
);




#CRIAÇÃO DA TABELA etapa
create table tbl_etapa(
	id 			            int                     not null primary key auto_increment,
    titulo 		            varchar(100)            not null,
    descricao               text                    not null,
    ordem   
                    int             not null,                -- posição na jornada
    is_repetivel            boolean         not null default false,  -- true na última etapa
    is_agendavel            boolean                 not null,
    is_obrigatorio          boolean                 not null,
    is_solicita_arquivo     boolean                 not null,
    is_precisa_aprovacao    boolean                 not null,

    id_jornada              int                     not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_JORNADA_ETAPA          # nome do relacionamento
    foreign key			(id_jornada)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_jornada(id)		      # de onde vem a FK

);



#CRIAÇÃO DA TABELA ciclo
create table tbl_ciclo(
	id 			          int                      not null primary key auto_increment,
    numero_ciclo          int                      not null,
    is_concluido	      boolean                  not null,

    id_jornada            int                      not null,
    id_doadora            int                      not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_JORNADA_CICLO          # nome do relacionamento
    foreign key			(id_jornada)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_jornada(id),		  # de onde vem a FK


	#fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_CICLO       # nome do relacionamento
    foreign key			(id_doadora)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id)		  # de onde vem a FK
);


#CRIAÇÃO DA TABELA etapa ciclo
create table tbl_etapa_ciclo(
	id 			        int                     not null primary key auto_increment,
    data_conclusao 		date                    null,
    
    id_etapa            int                     not null,
    id_ciclo            int                     not null,


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
	id 			    int                     not null primary key auto_increment,
    dia 		    date                    not null,
    horario         time                    not null,

    id_etapa  		int                     not null,


    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPA_CADASTROHORARIO       # nome do relacionamento
    foreign key			(id_etapa)    		                # quem sera a FK natabla FK(foren key)
    references			tbl_etapa(id)		                # de onde vem a FK
);


#CRIAÇÃO DA TABELA statu agendamento
create table tbl_status_agendamento(
	id 			    int                     not null primary key auto_increment,
    status 		    varchar (25)            not null
);


#CRIAÇÃO DA TABELA agendamento
create table tbl_agendamento(
	id 			    int                     not null primary key auto_increment,
  
    
	id_ciclo  						  int                     not null,
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



#CRIAÇÃO DA TABELA documento instituicao
create table tbl_documento_instituicao(
	id 			    int                     not null primary key auto_increment,
    documento		varchar(255)            not null,

    id_etapa        int                     not null,

    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPA_DOCUMENTOINSTITUICAO       # nome do relacionamento
    foreign key			(id_etapa)    		                # quem sera a FK natabla FK(foren key)
    references			tbl_etapa(id)		                # de onde vem a FK

);



#CRIAÇÃO DA TABELA documento doadora
create table tbl_documento_doadora(
	id 			            int                     not null primary key auto_increment,
    documento		        varchar(255)             not null,
    motivo_recusa		    varchar(255)             not null,
    
    id_etapa_ciclo          int                     not null,
    id_doadora              int                     not null,



    #fazer relacao entre duas tabelas 
    constraint			FK_ETAPACICLO_DOCUMENTODOADORA       # nome do relacionamento
    foreign key			(id_etapa_ciclo)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_etapa_ciclo(id),		  # de onde vem a FK
    
     #fazer relacao entre duas tabelas 
    constraint			FK_DOADORA_DOCUMENTODOADORA       # nome do relacionamento
    foreign key			(id_doadora)    		  # quem sera a FK natabla FK(foren key)
    references			tbl_doadora(id)		  # de onde vem a FK

);


#########################################################################################################
#PROCIDURE
#########################################################################################################

# CADASTRA DOADORA

DELIMITER $$

CREATE PROCEDURE proccadastrardoadora (
    # Doadora
    IN p_nome             VARCHAR(100),
    IN p_cpf              VARCHAR(15),
    IN p_foto             VARCHAR(255),
    IN p_data_nascimento  DATE,
    IN p_email            VARCHAR(255),
    IN p_senha            VARCHAR(255),
    IN p_sal              VARCHAR(255),

    # Telefone
    IN p_telefone         VARCHAR(25),

    # Endereço
    IN p_logradouro       VARCHAR(100),
    IN p_cep              VARCHAR(20),
    IN p_bairro           VARCHAR(50),
    IN p_numero           VARCHAR(10),
    IN p_complemento      VARCHAR(50),
    IN p_latitude         DECIMAL(11,8),
    IN p_longitude        DECIMAL(11,8),

    # Cidade e Estado
    IN p_cidade           VARCHAR(100),
    IN p_sigla_estado     VARCHAR(3),

    # Retorno
    OUT p_id_doadora      INT
)
BEGIN
    DECLARE v_id_estado    INT;
    DECLARE v_id_cidade    INT;
    DECLARE v_id_endereco  INT;
    DECLARE v_id_telefone  INT;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    #  ESTADO: reaproveita se já existir, senão cria
    SELECT id INTO v_id_estado
    FROM tbl_estado
    WHERE sigla = p_sigla_estado
    LIMIT 1;

    IF v_id_estado IS NULL THEN
        INSERT INTO tbl_estado (sigla) VALUES (p_sigla_estado);
        SET v_id_estado = LAST_INSERT_ID();
    END IF;

    # CIDADE: reaproveita se já existir naquele estado, senão cria
    SELECT id INTO v_id_cidade
    FROM tbl_cidade
    WHERE nome = p_cidade
      AND id_estado = v_id_estado
    LIMIT 1;

    IF v_id_cidade IS NULL THEN
        INSERT INTO tbl_cidade (nome, id_estado)
        VALUES (p_cidade, v_id_estado);
        SET v_id_cidade = LAST_INSERT_ID();
    END IF;

    # ENDEREÇO
    INSERT INTO tbl_endereco
        (logradouro, cep, bairro, numero, complemento, latitude, longitude, id_cidade)
    VALUES
        (p_logradouro, p_cep, p_bairro, p_numero, p_complemento, p_latitude, p_longitude, v_id_cidade);
    SET v_id_endereco = LAST_INSERT_ID();

    # TELEFONE
    INSERT INTO tbl_telefone (numero) VALUES (p_telefone);
    SET v_id_telefone = LAST_INSERT_ID();

    # DOADORA
    INSERT INTO tbl_doadora
        (nome, cpf, foto, data_nascimento, email, senha, sal, id_endereco, id_telefone)
    VALUES
        (p_nome, p_cpf, p_foto, p_data_nascimento, p_email, p_senha, p_sal, v_id_endereco, v_id_telefone);
    SET p_id_doadora = LAST_INSERT_ID();

    COMMIT;
END$$

DELIMITER ;

#########################################################################################################
# CADASTRA INSTITUICAO 
#########################################################################################################
DROP PROCEDURE IF EXISTS proccadastrarinstituicao;

DELIMITER $$

CREATE PROCEDURE proccadastrarinstituicao (
    # Instituição
    IN p_nome             VARCHAR(100),
    IN p_cnpj             VARCHAR(30),
    IN p_email            VARCHAR(255),
    IN p_foto             VARCHAR(255),
    IN p_id_coleta        INT,

    # Telefone
    IN p_telefone         VARCHAR(25),

    # Endereço
    IN p_logradouro       VARCHAR(100),
    IN p_cep              VARCHAR(20),
    IN p_bairro           VARCHAR(50),
    IN p_numero           VARCHAR(10),
    IN p_complemento      VARCHAR(50),
    IN p_latitude         DECIMAL(11,8),
    IN p_longitude        DECIMAL(11,8),

    # Cidade e Estado
    IN p_cidade           VARCHAR(100),
    IN p_sigla_estado     VARCHAR(3),

    # Horário de funcionamento: dia + abre + fecha (7 dias)
    IN p_dia1 INT, IN p_abre1 TIME, IN p_fecha1 TIME,
    IN p_dia2 INT, IN p_abre2 TIME, IN p_fecha2 TIME,
    IN p_dia3 INT, IN p_abre3 TIME, IN p_fecha3 TIME,
    IN p_dia4 INT, IN p_abre4 TIME, IN p_fecha4 TIME,
    IN p_dia5 INT, IN p_abre5 TIME, IN p_fecha5 TIME,
    IN p_dia6 INT, IN p_abre6 TIME, IN p_fecha6 TIME,
    IN p_dia7 INT, IN p_abre7 TIME, IN p_fecha7 TIME,

    # Retorno
    OUT p_id_instituicao  INT
)
BEGIN
    DECLARE v_id_estado       INT;
    DECLARE v_id_cidade       INT;
    DECLARE v_id_endereco     INT;
    DECLARE v_id_telefone     INT;
    DECLARE v_id_instituicao  INT;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # ESTADO: reaproveita se já existir, senão cria
    SELECT id INTO v_id_estado
    FROM tbl_estado
    WHERE sigla = p_sigla_estado
    LIMIT 1;

    IF v_id_estado IS NULL THEN
        INSERT INTO tbl_estado (sigla) VALUES (p_sigla_estado);
        SET v_id_estado = LAST_INSERT_ID();
    END IF;

    # CIDADE: reaproveita se já existir naquele estado, senão cria
    SELECT id INTO v_id_cidade
    FROM tbl_cidade
    WHERE nome = p_cidade
      AND id_estado = v_id_estado
    LIMIT 1;

    IF v_id_cidade IS NULL THEN
        INSERT INTO tbl_cidade (nome, id_estado)
        VALUES (p_cidade, v_id_estado);
        SET v_id_cidade = LAST_INSERT_ID();
    END IF;

    # ENDEREÇO
    INSERT INTO tbl_endereco
        (logradouro, cep, bairro, numero, complemento, latitude, longitude, id_cidade)
    VALUES
        (p_logradouro, p_cep, p_bairro, p_numero, p_complemento, p_latitude, p_longitude, v_id_cidade);
    SET v_id_endereco = LAST_INSERT_ID();

    # INSTITUIÇÃO
    INSERT INTO tbl_instituicao
        (nome, cnpj, email, foto, id_coleta, id_endereco)
    VALUES
        (p_nome, p_cnpj, p_email, p_foto, p_id_coleta, v_id_endereco);
    SET v_id_instituicao = LAST_INSERT_ID();

    # TELEFONE
    INSERT INTO tbl_telefone (numero) VALUES (p_telefone);
    SET v_id_telefone = LAST_INSERT_ID();

    # TELEFONE x INSTITUIÇÃO
    INSERT INTO tbl_telefone_instituicao (id_instituicao, id_telefone)
    VALUES (v_id_instituicao, v_id_telefone);

    # HORÁRIO DE FUNCIONAMENTO: grava em tbl_horario_funcionamento (7 linhas)
    INSERT INTO tbl_horario_funcionamento
        (dia, hora_inicio, hora_fim, id_instituicao)
    VALUES
        (p_dia1, p_abre1, p_fecha1, v_id_instituicao),
        (p_dia2, p_abre2, p_fecha2, v_id_instituicao),
        (p_dia3, p_abre3, p_fecha3, v_id_instituicao),
        (p_dia4, p_abre4, p_fecha4, v_id_instituicao),
        (p_dia5, p_abre5, p_fecha5, v_id_instituicao),
        (p_dia6, p_abre6, p_fecha6, v_id_instituicao),
        (p_dia7, p_abre7, p_fecha7, v_id_instituicao);

    SET p_id_instituicao = v_id_instituicao;

    COMMIT;
END$$

DELIMITER ;


#########################################################################################################
# CADASTRA FUNCIONARIO
#########################################################################################################

DELIMITER $$

CREATE PROCEDURE proccadastrarfuncionario (
    # Funcionário
    IN p_nome             VARCHAR(100),
    IN p_cpf              VARCHAR(15),
    IN p_data_nascimento  DATE,
    IN p_email            VARCHAR(255),
    IN p_adm              BOOLEAN,
    IN p_senha            VARCHAR(255),
    IN p_sal              VARCHAR(255),

    # Telefone
    IN p_telefone         VARCHAR(25),

    # Instituição onde trabalha
    IN p_id_instituicao   INT,

    # Retorno
    OUT p_id_funcionario  INT
)
BEGIN
    DECLARE v_id_telefone  INT;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # TELEFONE
    INSERT INTO tbl_telefone (numero) VALUES (p_telefone);
    SET v_id_telefone = LAST_INSERT_ID();

    # FUNCIONÁRIO
    INSERT INTO tbl_funcionario
        (nome, cpf, data_nascimento, email, adm, senha, sal, id_telefone, id_instituicao)
    VALUES
        (p_nome, p_cpf, p_data_nascimento, p_email, p_adm, p_senha, p_sal, v_id_telefone, p_id_instituicao);
    SET p_id_funcionario = LAST_INSERT_ID();

    COMMIT;
END$$

DELIMITER ;


#########################################################################################################
# CADASTRA CAMPANHA
#########################################################################################################

DELIMITER $$

CREATE PROCEDURE proccadastrarcampanha (
    # Campanha
    IN p_titulo           VARCHAR(100),
    IN p_descricao        TEXT,
    IN p_foto             VARCHAR(255),
    IN p_data_inicio      DATE,
    IN p_data_fim         DATE,
    IN p_is_ativo         BOOLEAN,

    # Relacionamentos
    IN p_id_instituicao   INT,
    IN p_id_funcionario   INT,

    # Retorno
    OUT p_id_campanha     INT
)
BEGIN
    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # CAMPANHA
    INSERT INTO tbl_campanha
        (titulo, descricao, foto, data_inicio, data_fim, is_ativo, id_instituicao, id_funcionario)
    VALUES
        (p_titulo, p_descricao, p_foto, p_data_inicio, p_data_fim, p_is_ativo, p_id_instituicao, p_id_funcionario);
    SET p_id_campanha = LAST_INSERT_ID();

    COMMIT;
END$$

DELIMITER ;
























########################################
#INSERT
########################################
INSERT INTO tbl_tipo_coleta (tipo) VALUES 
('Presencial'),
('Domicílio');

#SELECT * FROM tbl_tipo_coleta;