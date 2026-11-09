#ARQUIVO RESPONSAVEL PELA CRIACAO DE TODAS PROCIDURE DE CADASTRO

#CADASTRO DE DOADORA

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

    # Código de envio
    IN p_codigo           INT
)
BEGIN
    DECLARE v_id_estado    INT;
    DECLARE v_id_cidade    INT;
    DECLARE v_id_endereco  INT;
    DECLARE v_id_telefone  INT;
    DECLARE v_id_doadora   INT;

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

    # TELEFONE
    INSERT INTO tbl_telefone (numero) VALUES (p_telefone);
    SET v_id_telefone = LAST_INSERT_ID();

    # DOADORA
    INSERT INTO tbl_doadora
        (nome, cpf, foto, data_nascimento, email, senha, sal, id_endereco, id_telefone)
    VALUES
        (p_nome, p_cpf, p_foto, p_data_nascimento, p_email, p_senha, p_sal, v_id_endereco, v_id_telefone);
    SET v_id_doadora = LAST_INSERT_ID();

    # CODIGO DE ENVIO (data e hora atuais)
    INSERT INTO tbl_codigo_envio (codigo, data_criacao, id_doadora)
    VALUES (p_codigo, NOW(), v_id_doadora);

    COMMIT;

    # Devolve o id para o DAO (resultado[0][0].id_doadora)
    SELECT v_id_doadora AS id_doadora;
END$$

#CALL proccadastrardoadora(
#    'Maria', '123.456.789-00', NULL, '1995-03-10', 'maria@email.com', 'hash', 'sal',
#    '11999999999',
#    'Rua A', '01001-000', 'Centro', '100', NULL, -23.55, -46.63,
#    'São Paulo', 'SP',
#    123456
#);

DELIMITER ;
########################################################################################


#CADASTRO DE FUNCIONARIO


DELIMITER $$

CREATE PROCEDURE proccadastrarfuncionario (
    -- Funcionário
    IN p_nome             VARCHAR(100),
    IN p_cpf              VARCHAR(15),
    IN p_data_nascimento  DATE,
    IN p_email            VARCHAR(255),
    IN p_adm              BOOLEAN,
    IN p_senha            VARCHAR(255),
    IN p_sal              VARCHAR(255),

    -- Telefone
    IN p_telefone         VARCHAR(25),

    -- Instituição onde trabalha
    IN p_id_instituicao   INT
)
BEGIN
    DECLARE v_id_telefone INT;
    DECLARE v_id_funcionario INT;

    -- Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- TELEFONE
    INSERT INTO tbl_telefone (numero)
    VALUES (p_telefone);

    SET v_id_telefone = LAST_INSERT_ID();

    -- FUNCIONÁRIO
    INSERT INTO tbl_funcionario (
        nome,
        cpf,
        data_nascimento,
        email,
        adm,
        senha,
        sal,
        id_telefone,
        id_instituicao
    )
    VALUES (
        p_nome,
        p_cpf,
        p_data_nascimento,
        p_email,
        p_adm,
        p_senha,
        p_sal,
        v_id_telefone,
        p_id_instituicao
    );

    SET v_id_funcionario = LAST_INSERT_ID();

    COMMIT;

    -- Retorna o ID para o DAO, igual à procedure da doadora
    SELECT v_id_funcionario AS id_funcionario;

END$$

DELIMITER ;


# CADASTRo DE CAMPANHA
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
    IN p_id_funcionario   INT
)
BEGIN
    DECLARE v_id_campanha INT;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # CAMPANHA
    INSERT INTO tbl_campanha
        (titulo, descricao, foto, data_inicio, data_fim,
         is_ativo, id_instituicao, id_funcionario)
    VALUES
        (p_titulo, p_descricao, p_foto, p_data_inicio, p_data_fim,
         p_is_ativo, p_id_instituicao, p_id_funcionario);

    SET v_id_campanha = LAST_INSERT_ID();

    COMMIT;

    # Devolve o ID para o DAO
    SELECT v_id_campanha AS id_campanha;

END$$

DELIMITER ;
#################################################################################


#CADASTRO DE Instituicao
DELIMITER $$

CREATE PROCEDURE proccadastrarinstituicao (
    # Instituição
    IN p_nome             VARCHAR(100),
    IN p_cnpj             VARCHAR(30),
    IN p_email            VARCHAR(255),
    IN p_foto             VARCHAR(255),
    IN p_id_coleta        INT,

    # Telefone da instituição
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

    # Funcionário
    IN p_func_nome             VARCHAR(100),
    IN p_func_cpf              VARCHAR(15),
    IN p_func_data_nascimento  DATE,
    IN p_func_email            VARCHAR(255),
    IN p_func_senha            VARCHAR(255),
    IN p_func_sal              VARCHAR(255),
    IN p_func_telefone         VARCHAR(25)
)
BEGIN
    DECLARE v_id_estado             INT;
    DECLARE v_id_cidade             INT;
    DECLARE v_id_endereco           INT;
    DECLARE v_id_telefone           INT;
    DECLARE v_id_instituicao        INT;
    DECLARE v_id_telefone_func      INT;
    DECLARE v_id_funcionario        INT;

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

    # TELEFONE DA INSTITUIÇÃO
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

    # TELEFONE DO FUNCIONÁRIO
    INSERT INTO tbl_telefone (numero) VALUES (p_func_telefone);
    SET v_id_telefone_func = LAST_INSERT_ID();

    # FUNCIONÁRIO (primeiro funcionário da instituição = administrador)
    INSERT INTO tbl_funcionario
        (nome, cpf, data_nascimento, email, adm, senha, sal, id_telefone, id_instituicao)
    VALUES
        (p_func_nome, p_func_cpf, p_func_data_nascimento, p_func_email, TRUE,
         p_func_senha, p_func_sal, v_id_telefone_func, v_id_instituicao);
    SET v_id_funcionario = LAST_INSERT_ID();

    COMMIT;

    # Retorno: os ids saem num SELECT (o knex lê em resultado[0][0])
    SELECT v_id_instituicao AS id_instituicao, v_id_funcionario AS id_funcionario;
END$$

DELIMITER ;
#########################################################################################

#PROCIDURE DE CADASTRO DE Jornada
DELIMITER $$

CREATE PROCEDURE proccadastrarjornada(
    IN  p_is_ativo        BOOLEAN,
    IN  p_nome            VARCHAR(50),
    IN  p_descricao       TEXT,
    IN  p_id_instituicao  INT,
    IN  p_etapas          JSON,      -- array de etapas
    OUT p_codigo          INT        -- 200 = sucesso | 400 = dados inválidos | 404 = instituição inexistente | 500 = erro
)
BEGIN
    DECLARE v_id_jornada INT;

    -- Qualquer erro SQL: desfaz tudo e retorna 500
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_codigo = 500;
        SELECT p_codigo AS codigo, 'Erro ao cadastrar a jornada' AS mensagem;
    END;

    -- Validações básicas
    IF p_nome IS NULL OR TRIM(p_nome) = ''
       OR p_etapas IS NULL
       OR JSON_TYPE(p_etapas) <> 'ARRAY'
       OR JSON_LENGTH(p_etapas) = 0 THEN
        SET p_codigo = 400;
        SELECT p_codigo AS codigo, 'Informe o nome e ao menos uma etapa' AS mensagem;

    ELSEIF NOT EXISTS (SELECT 1 FROM tbl_instituicao WHERE id = p_id_instituicao) THEN
        SET p_codigo = 404;
        SELECT p_codigo AS codigo, 'Instituição não encontrada' AS mensagem;

    ELSE
        START TRANSACTION;

        -- 1) Jornada
        INSERT INTO tbl_jornada (is_ativo, nome, descricao, id_instituicao)
        VALUES (p_is_ativo, p_nome, p_descricao, p_id_instituicao);

        SET v_id_jornada = LAST_INSERT_ID();

        -- 2) Etapas (quantas vierem no JSON)
        INSERT INTO tbl_etapa (
            titulo, descricao, ordem, documento,
            is_repetivel, is_agendavel, is_obrigatorio,
            is_solicita_arquivo, is_precisa_aprovacao, id_jornada
        )
        SELECT
            jt.titulo,
            jt.descricao,
            COALESCE(jt.ordem, jt.seq),   -- se não vier "ordem", usa a posição no array
            jt.documento,                 -- NULL quando a etapa não tem documento
            jt.is_repetivel,
            jt.is_agendavel,
            jt.is_obrigatorio,
            jt.is_solicita_arquivo,
            jt.is_precisa_aprovacao,
            v_id_jornada
        FROM JSON_TABLE(
            p_etapas, '$[*]' COLUMNS (
                seq                  FOR ORDINALITY,
                titulo               VARCHAR(100) PATH '$.titulo',
                descricao            TEXT         PATH '$.descricao',
                ordem                INT          PATH '$.ordem'                NULL ON EMPTY,
                documento            VARCHAR(255) PATH '$.documento'            NULL ON EMPTY,
                is_repetivel         TINYINT      PATH '$.is_repetivel'         DEFAULT '0' ON EMPTY,
                is_agendavel         TINYINT      PATH '$.is_agendavel'         DEFAULT '0' ON EMPTY,
                is_obrigatorio       TINYINT      PATH '$.is_obrigatorio'       DEFAULT '0' ON EMPTY,
                is_solicita_arquivo  TINYINT      PATH '$.is_solicita_arquivo'  DEFAULT '0' ON EMPTY,
                is_precisa_aprovacao TINYINT      PATH '$.is_precisa_aprovacao' DEFAULT '0' ON EMPTY
            )
        ) AS jt;

        COMMIT;
        SET p_codigo = 200;

        -- 3) Retorno: sucesso + jornada cadastrada
        SELECT p_codigo AS codigo, 'Jornada cadastrada com sucesso' AS mensagem, j.*
        FROM tbl_jornada j
        WHERE j.id = v_id_jornada;

        -- 4) Retorno: etapas cadastradas
        SELECT e.*
        FROM tbl_etapa e
        WHERE e.id_jornada = v_id_jornada
        ORDER BY e.ordem;
    END IF;
END$$

DELIMITER ;
#############################################################################################

#PROCIDURE DE CADASTRO DE HORARIO
DELIMITER $$

CREATE PROCEDURE proccadastrarhorario (
    # Horário
    IN p_dia       DATE,
    IN p_horario   TIME,

    # Etapa relacionada
    IN p_id_etapa  INT
)
BEGIN
    DECLARE v_is_agendavel BOOLEAN;
    DECLARE v_etapa_existe INT DEFAULT 0;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # Verifica se a etapa existe
    SELECT COUNT(*)
    INTO v_etapa_existe
    FROM tbl_etapa
    WHERE id = p_id_etapa;

    IF v_etapa_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: a etapa informada nao existe.';
    END IF;

    # Verifica se a etapa permite agendamento
    SELECT is_agendavel
    INTO v_is_agendavel
    FROM tbl_etapa
    WHERE id = p_id_etapa;

    IF v_is_agendavel <> TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: esta etapa nao permite agendamento.';
    END IF;

    # Cadastra o horário se a etapa for agendável
    INSERT INTO tbl_cadastro_horario (
        dia,
        horario,
        id_etapa
    )
    VALUES (
        p_dia,
        p_horario,
        p_id_etapa
    );

    # Retorno do id cadastrado
    SELECT LAST_INSERT_ID() AS id_cadastro_horario;

    COMMIT;
END$$

DELIMITER ;
###############################################################################
 

DROP PROCEDURE IF EXISTS procvincularetapadoadora;

#PROCIDURE RESPONSAVEL POR cadastrar jornada doacao
DELIMITER $$

    CREATE PROCEDURE procvincularetapadoadora (
        IN  p_id_doadora        INT,
        IN  p_id_etapa          INT,
        IN  p_id_instituicao    INT,
        IN  p_id_jornada        INT,

        # Retorno: id da linha criada em tbl_jornada_doacao
        OUT p_id_jornada_doacao INT
    )
    BEGIN
        # Se qualquer erro acontecer, desfaz tudo
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

        # Doadora existe?
        IF NOT EXISTS (SELECT 1 FROM tbl_doadora WHERE id = p_id_doadora) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: doadora nao encontrada.';
        END IF;

        # Etapa existe?
        IF NOT EXISTS (SELECT 1 FROM tbl_etapa WHERE id = p_id_etapa) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: etapa nao encontrada.';
        END IF;

        # Instituicao existe?
        IF NOT EXISTS (SELECT 1 FROM tbl_instituicao WHERE id = p_id_instituicao) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: instituicao nao encontrada.';
        END IF;

        # Jornada existe?
        IF NOT EXISTS (SELECT 1 FROM tbl_jornada WHERE id = p_id_jornada) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: jornada nao encontrada.';
        END IF;

        START TRANSACTION;

        # Ciclo sempre 1 e sem data de conclusao
        INSERT INTO tbl_jornada_doacao
            (ciclo, data_conclusao, id_etapa, id_doadora, id_instituicao, id_jornada)
        VALUES
            (1, NULL, p_id_etapa, p_id_doadora, p_id_instituicao, p_id_jornada);

        SET p_id_jornada_doacao = LAST_INSERT_ID();

        COMMIT;
    END$$

DELIMITER ;
#########################################################################################################



# PROCIDURE RESPONSAVLE POR SOLICITAR AGENDAMENTO
DELIMITER $$

CREATE PROCEDURE procagendar (
    IN  p_id_cadastro_horario   INT,
    IN  p_id_jornada_doacao     INT,
    IN  p_id_status_agendamento INT,

    # Retorno: id do agendamento criado
    OUT p_id_agendamento        INT
)
BEGIN
    DECLARE v_is_agendavel  BOOLEAN;
    DECLARE v_disponivel    BOOLEAN;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    # A etapa da doadora e agendavel?
    SELECT e.is_agendavel
    INTO   v_is_agendavel
    FROM tbl_jornada_doacao jd
    JOIN tbl_etapa e ON e.id = jd.id_etapa
    WHERE jd.id = p_id_jornada_doacao;

    IF v_is_agendavel IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: registro da jornada nao encontrado.';
    END IF;

    IF v_is_agendavel = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: esta etapa nao permite agendamento.';
    END IF;

    # O horario existe e esta disponivel?
    SELECT disponivel
    INTO   v_disponivel
    FROM tbl_cadastro_horario
    WHERE id = p_id_cadastro_horario
    FOR UPDATE;

    IF v_disponivel IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: horario nao encontrado.';
    END IF;

    IF v_disponivel = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: este horario nao esta disponivel.';
    END IF;

    # AGENDAMENTO
    INSERT INTO tbl_agendamento
        (id_jornada_doacao, id_cadastro_horario, id_status_agendamento)
    VALUES
        (p_id_jornada_doacao, p_id_cadastro_horario, p_id_status_agendamento);

    SET p_id_agendamento = LAST_INSERT_ID();

    COMMIT;

    # Retorno de sucesso
    SELECT 200 AS codigo,
           'Agendamento realizado com sucesso' AS mensagem,
           p_id_agendamento AS id_agendamento;
END$$

DELIMITER ;
##############################################################################################################



