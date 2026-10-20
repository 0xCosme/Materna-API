#########################################################################################################
#ATUALIZAR DOADORA
#########################################################################################################

DELIMITER $$

CREATE PROCEDURE procatualizardoadora (
    # Identificação
    IN p_id_doadora       INT,

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
    IN p_sigla_estado     VARCHAR(3)
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

    # Busca o endereço e o telefone atuais da doadora
    SELECT id_endereco, id_telefone
    INTO v_id_endereco, v_id_telefone
    FROM tbl_doadora
    WHERE id = p_id_doadora;

    # Se a doadora não existir, para com erro
    IF v_id_endereco IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doadora nao encontrada';
    END IF;

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
    UPDATE tbl_endereco
    SET logradouro  = p_logradouro,
        cep         = p_cep,
        bairro      = p_bairro,
        numero      = p_numero,
        complemento = p_complemento,
        latitude    = p_latitude,
        longitude   = p_longitude,
        id_cidade   = v_id_cidade
    WHERE id = v_id_endereco;

    # TELEFONE
    UPDATE tbl_telefone
    SET numero = p_telefone
    WHERE id = v_id_telefone;

    # DOADORA
    UPDATE tbl_doadora
    SET nome            = p_nome,
        cpf             = p_cpf,
        foto            = p_foto,
        data_nascimento = p_data_nascimento,
        email           = p_email,
        senha           = p_senha,
        sal             = p_sal
    WHERE id = p_id_doadora;

    COMMIT;
END$$

DELIMITER ;

CALL procatualizardoadora(
    1,                              -- id da doadora
    'Ana Paula Lima',               -- nome
    '987.654.321-00',               -- cpf
    'ana_nova.jpg',                 -- foto
    '1995-03-10',                   -- data de nascimento
    'ana@email.com',                -- email
    'novo_hash_aqui',               -- senha (já criptografada)
    'novo_sal_aqui',                -- sal
    '(11) 97777-6666',              -- telefone
    'Av. Brasil',                   -- logradouro
    '06100-000',                    -- cep
    'Jardim América',               -- bairro
    '250',                          -- numero
    'Apto 12',                      -- complemento
    -23.56000000,                   -- latitude
    -46.64000000,                   -- longitude
    'Osasco',                       -- cidade
    'SP'                            -- sigla do estado
);

SELECT * FROM tbl_doadora WHERE id = 1;
















//////////

DELIMITER $$

CREATE PROCEDURE procatualizarinstituicao (
    # Identificação
    IN p_id_instituicao   INT,

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
    IN p_dia7 INT, IN p_abre7 TIME, IN p_fecha7 TIME
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

    # Busca o endereço atual da instituição
    SELECT id_endereco INTO v_id_endereco
    FROM tbl_instituicao
    WHERE id = p_id_instituicao;

    # Se a instituição não existir, para com erro
    IF v_id_endereco IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Instituicao nao encontrada';
    END IF;

    # Busca o telefone atual da instituição
    SELECT id_telefone INTO v_id_telefone
    FROM tbl_telefone_instituicao
    WHERE id_instituicao = p_id_instituicao
    LIMIT 1;

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
    UPDATE tbl_endereco
    SET logradouro  = p_logradouro,
        cep         = p_cep,
        bairro      = p_bairro,
        numero      = p_numero,
        complemento = p_complemento,
        latitude    = p_latitude,
        longitude   = p_longitude,
        id_cidade   = v_id_cidade
    WHERE id = v_id_endereco;

    # TELEFONE: atualiza se já existir, senão cria e vincula
    IF v_id_telefone IS NULL THEN
        INSERT INTO tbl_telefone (numero) VALUES (p_telefone);
        SET v_id_telefone = LAST_INSERT_ID();

        INSERT INTO tbl_telefone_instituicao (id_instituicao, id_telefone)
        VALUES (p_id_instituicao, v_id_telefone);
    ELSE
        UPDATE tbl_telefone
        SET numero = p_telefone
        WHERE id = v_id_telefone;
    END IF;

    # HORÁRIO DE FUNCIONAMENTO: apaga os 7 dias antigos e grava os novos
    DELETE FROM tbl_horario_funcionamento
    WHERE id_instituicao = p_id_instituicao;

    INSERT INTO tbl_horario_funcionamento
        (dia, hora_inicio, hora_fim, id_instituicao)
    VALUES
        (p_dia1, p_abre1, p_fecha1, p_id_instituicao),
        (p_dia2, p_abre2, p_fecha2, p_id_instituicao),
        (p_dia3, p_abre3, p_fecha3, p_id_instituicao),
        (p_dia4, p_abre4, p_fecha4, p_id_instituicao),
        (p_dia5, p_abre5, p_fecha5, p_id_instituicao),
        (p_dia6, p_abre6, p_fecha6, p_id_instituicao),
        (p_dia7, p_abre7, p_fecha7, p_id_instituicao);

    # INSTITUIÇÃO
    UPDATE tbl_instituicao
    SET nome        = p_nome,
        cnpj        = p_cnpj,
        email       = p_email,
        foto        = p_foto,
        id_coleta   = p_id_coleta
    WHERE id = p_id_instituicao;

    COMMIT;
END$$

DELIMITER ;



CALL procatualizarinstituicao(
    1,                                  -- id da instituição
    -- Instituição
    'Banco de Leite Esperança Osasco',  -- nome
    '12.345.678/0001-90',               -- cnpj
    'novo@esperanca.org',               -- email
    'foto_nova.jpg',                    -- foto
    2,                                  -- id do tipo de coleta
    '(11) 97777-1111',                  -- telefone
    -- Endereço
    'Av. Brasil',                       -- logradouro
    '06100-000',                        -- cep
    'Jardim América',                   -- bairro
    '250',                              -- numero
    'Bloco B',                          -- complemento
    -23.56000000,                       -- latitude
    -46.64000000,                       -- longitude
    'Osasco',                           -- cidade
    'SP',                               -- sigla do estado
    -- Horários
    1, '00:00', '00:00',                -- domingo (fechado)
    2, '07:00', '18:00',                -- segunda
    3, '07:00', '18:00',                -- terça
    4, '07:00', '18:00',                -- quarta
    5, '07:00', '18:00',                -- quinta
    6, '07:00', '18:00',                -- sexta
    7, '08:00', '13:00'                 -- sábado
);

-- Conferindo o resultado
SELECT * FROM tbl_instituicao WHERE id = 1;
SELECT * FROM tbl_horario_funcionamento WHERE id_instituicao = 1;



/////////////////////////////////////////////
DELIMITER $$

CREATE PROCEDURE procatualizarfuncionario (
    # Identificação
    IN p_id_funcionario   INT,

    # Funcionário
    IN p_nome             VARCHAR(100),
    IN p_cpf              VARCHAR(15),
    IN p_data_nascimento  DATE,
    IN p_email            VARCHAR(255),
    IN p_adm              BOOLEAN,
    IN p_senha            VARCHAR(255),
    IN p_sal              VARCHAR(255),

    # Telefone
    IN p_telefone         VARCHAR(25)
)
BEGIN
    DECLARE v_id_telefone  INT;
    DECLARE v_existe       INT DEFAULT 0;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    # Confere se o funcionário existe e busca o telefone atual
    SELECT COUNT(*), MAX(id_telefone)
    INTO v_existe, v_id_telefone
    FROM tbl_funcionario
    WHERE id = p_id_funcionario;

    # Se o funcionário não existir, para com erro
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionario nao encontrado';
    END IF;

    START TRANSACTION;

    # TELEFONE
    UPDATE tbl_telefone
    SET numero = p_telefone
    WHERE id = v_id_telefone;

    # FUNCIONÁRIO
    UPDATE tbl_funcionario
    SET nome            = p_nome,
        cpf             = p_cpf,
        data_nascimento = p_data_nascimento,
        email           = p_email,
        adm             = p_adm,
        senha           = p_senha,
        sal             = p_sal
    WHERE id = p_id_funcionario;

    COMMIT;
END$$

DELIMITER ;



CALL procatualizarfuncionario(
    1,                              -- id do funcionário
    'Maria Souza Lima',             -- nome
    '123.456.789-00',               -- cpf
    '1990-05-20',                   -- data de nascimento
    'maria.nova@esperanca.org',     -- email
    TRUE,                           -- adm (TRUE = administrador)
    'novo_hash_aqui',               -- senha (já criptografada)
    'novo_sal_aqui',                -- sal
    '(11) 96666-5555'               -- telefone
);

-- Conferindo o resultado
SELECT * FROM tbl_funcionario WHERE id = 1;