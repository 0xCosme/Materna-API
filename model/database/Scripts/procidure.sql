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




CALL proccadastrardoadora(
    'Maria da Silva',          # nome
    '123.456.789-00',          # cpf
    NULL,                      # foto
    '1995-04-20',              # data_nascimento
    'maria@email.com',         # email
    'hash_da_senha',           # senha
    'sal_aleatorio',           # sal
    '(11) 91234-5678',         # telefone
    'Rua das Flores',          # logradouro
    '01234-567',               # cep
    'Centro',                  # bairro
    '100',                     # numero
    'Apto 12',                 # complemento
    -23.55052000,              # latitude
    -46.63330800,              # longitude
    'São Paulo',               # cidade
    'SP',                      # sigla do estado
    
);

##########################################################################################################################################


#########################################################################################################
# CADASTRA INSTITUICAO (com endereço, telefone e 7 dias de horário de funcionamento)
#########################################################################################################

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

    # Horário de funcionamento (1 = Domingo, 2 = Segunda ... 7 = Sábado)
    IN p_hora_inicio_dom  TIME,
    IN p_hora_fim_dom     TIME,
    IN p_hora_inicio_seg  TIME,
    IN p_hora_fim_seg     TIME,
    IN p_hora_inicio_ter  TIME,
    IN p_hora_fim_ter     TIME,
    IN p_hora_inicio_qua  TIME,
    IN p_hora_fim_qua     TIME,
    IN p_hora_inicio_qui  TIME,
    IN p_hora_fim_qui     TIME,
    IN p_hora_inicio_sex  TIME,
    IN p_hora_fim_sex     TIME,
    IN p_hora_inicio_sab  TIME,
    IN p_hora_fim_sab     TIME,

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

    # HORÁRIO DE FUNCIONAMENTO: 7 dias
    INSERT INTO tbl_horario_funcionamento
        (dia, hora_inicio, hora_fim, id_instituicao)
    VALUES
        (1, p_hora_inicio_dom, p_hora_fim_dom, v_id_instituicao),
        (2, p_hora_inicio_seg, p_hora_fim_seg, v_id_instituicao),
        (3, p_hora_inicio_ter, p_hora_fim_ter, v_id_instituicao),
        (4, p_hora_inicio_qua, p_hora_fim_qua, v_id_instituicao),
        (5, p_hora_inicio_qui, p_hora_fim_qui, v_id_instituicao),
        (6, p_hora_inicio_sex, p_hora_fim_sex, v_id_instituicao),
        (7, p_hora_inicio_sab, p_hora_fim_sab, v_id_instituicao);

    SET p_id_instituicao = v_id_instituicao;

    COMMIT;
END$$

DELIMITER ;


CALL proccadastrarinstituicao(
    'Banco de Leite Esperança', 
    '12.345.678/0001-90', 
    'contato@esperanca.org', 
    'foto.jpg', 
    1,
    '(11) 99999-9999',
    'Rua das Flores', 
    '06000-000', 
    'Centro', '100', 
    'Sala 2', 
    -23.55052000, 
    -46.63330800,
    'Osasco', 
    'SP',
    1, '00:00', '00:00',    -- domingo (fechado)
    2, '08:00', '17:00',    -- segunda
    3, '08:00', '17:00',    -- terça
    4, '08:00', '17:00',    -- quarta
    5, '08:00', '17:00',    -- quinta
    6, '08:00', '17:00',    -- sexta
    7, '08:00', '12:00',    -- sábado
    
);

#############################################################################################################

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


CALL proccadastrarfuncionario(
    'Maria Souza',              -- nome
    '123.456.789-00',           -- cpf
    '1990-05-20',               -- data de nascimento
    'maria@esperanca.org',      -- email
    TRUE,                       -- adm (TRUE = administradora, FALSE = comum)
    'senha_hash_aqui',          -- senha (já criptografada)
    'sal_aleatorio_aqui',       -- sal
    '(11) 98888-7777',          -- telefone
    1,                          -- id da instituição onde trabalha
    @id_funcionario
);



##############################################################################################

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

CALL proccadastrarcampanha(
    'Campanha Julho Dourado',                                  -- titulo
    'Campanha de incentivo à doação de leite materno.',        -- descricao
    'campanha_julho.jpg',                                      -- foto
    '2026-07-01',                                              -- data de início
    '2026-07-31',                                              -- data de fim
    TRUE,                                                      -- is_ativo
    1,                                                         -- id da instituição
    1,                                           -- id do funcionário que criou
    @id_campanha                                               -- retorno
);

