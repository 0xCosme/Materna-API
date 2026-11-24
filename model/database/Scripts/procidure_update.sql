#ARQUIVO RESPONSAVEL PELA CRIACAO DE TODAS PROCIDURE DE ATUALIZACAO

# PROCIDURE DE ATUALIZAR DOADORA
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

############################################################################################

# PROCIDURE DE ATUALIZAR FUNCIONARIO
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
###############################################################################################3333

# PROCIDURE DE ATUALIZAR INSTITUICAO
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
############################################################################################################################3

#PROCIDURE RESPONSAVEL POR ATUALIZAR UM AGENDAMENTO PRA ACEITO OU RECUSADO
DROP PROCEDURE IF EXISTS procatualizaragendamento;

DELIMITER $$

CREATE PROCEDURE procatualizaragendamento (
    IN p_id_agendamento         INT,
    IN p_id_status_agendamento  INT,
    IN p_id_doadora             INT
)
BEGIN
    DECLARE v_id_cadastro_horario INT;
    DECLARE v_id_status_atual     INT;
    DECLARE v_id_doadora_agendamento INT;
    DECLARE v_disponivel          BOOLEAN;

    # Ids dos status (Pendente = 1, Aceito = 2, Recusado = 3)
    DECLARE v_id_status_pendente  INT DEFAULT 1;
    DECLARE v_id_status_aceito    INT DEFAULT 2;
    DECLARE v_id_status_recusado  INT DEFAULT 3;
    DECLARE v_id_status_cancelado INT DEFAULT 4;

    # Se qualquer erro acontecer, desfaz tudo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    # Aceita transições para Aceito, Recusado ou Cancelado
    IF p_id_status_agendamento NOT IN (
        v_id_status_aceito,
        v_id_status_recusado,
        v_id_status_cancelado
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: o status deve ser Aceito, Recusado ou Cancelado.';
    END IF;

    START TRANSACTION;

    # Busca o agendamento (trava a linha)
    SELECT ag.id_cadastro_horario, ag.id_status_agendamento, jd.id_doadora
    INTO   v_id_cadastro_horario, v_id_status_atual, v_id_doadora_agendamento
    FROM tbl_agendamento AS ag
    INNER JOIN tbl_jornada_doacao AS jd
        ON jd.id = ag.id_jornada_doacao
    WHERE ag.id = p_id_agendamento
    FOR UPDATE;

    IF v_id_cadastro_horario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: agendamento nao encontrado.';
    END IF;

    IF p_id_status_agendamento = v_id_status_aceito THEN

        # Aceite e recusa so podem ocorrer enquanto o agendamento estiver pendente
        IF v_id_status_atual <> v_id_status_pendente THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: so e possivel alterar agendamentos pendentes.';
        END IF;

        # Trava o horario e confere se ainda esta disponivel
        SELECT disponivel INTO v_disponivel
        FROM tbl_cadastro_horario
        WHERE id = v_id_cadastro_horario
        FOR UPDATE;

        IF v_disponivel = FALSE THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: este horario nao esta mais disponivel.';
        END IF;

        # Aceita e deixa o horario indisponivel
        UPDATE tbl_agendamento
        SET id_status_agendamento = v_id_status_aceito
        WHERE id = p_id_agendamento;

        UPDATE tbl_cadastro_horario
        SET disponivel = FALSE
        WHERE id = v_id_cadastro_horario;

    ELSEIF p_id_status_agendamento = v_id_status_recusado THEN

        IF v_id_status_atual <> v_id_status_pendente THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: so e possivel alterar agendamentos pendentes.';
        END IF;

        # Recusa (o horario continua disponivel)
        UPDATE tbl_agendamento
        SET id_status_agendamento = v_id_status_recusado
        WHERE id = p_id_agendamento;

    ELSE

        IF p_id_doadora IS NULL OR p_id_doadora <> v_id_doadora_agendamento THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: agendamento nao encontrado.';
        END IF;

        IF v_id_status_atual NOT IN (v_id_status_pendente, v_id_status_aceito) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro: somente agendamentos pendentes ou aceitos podem ser cancelados.';
        END IF;

        UPDATE tbl_agendamento
        SET id_status_agendamento = v_id_status_cancelado
        WHERE id = p_id_agendamento;

        IF v_id_status_atual = v_id_status_aceito THEN
            UPDATE tbl_cadastro_horario
            SET disponivel = TRUE
            WHERE id = v_id_cadastro_horario;
        END IF;

    END IF;

    COMMIT;

    # Retorno de sucesso
    SELECT 200 AS codigo,
           'Agendamento atualizado com sucesso' AS mensagem,
           p_id_agendamento AS id_agendamento;
END$$

DELIMITER ;
############################################################################################

DROP PROCEDURE IF EXISTS procaceitardocumentodoadora;
DROP PROCEDURE IF EXISTS procrecusardocumentodoadora;

DELIMITER $$

CREATE PROCEDURE procaceitardocumentodoadora (
    IN p_id_documento INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM tbl_documento_doadora
        WHERE id = p_id_documento
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Documento nao encontrado.';
    END IF;

    UPDATE tbl_documento_doadora
    SET id_status_documento = 2,
        motivo_recusa = ''
    WHERE id = p_id_documento;
END$$

CREATE PROCEDURE procrecusardocumentodoadora (
    IN p_id_documento INT,
    IN p_motivo_recusa VARCHAR(255)
)
BEGIN
    IF p_motivo_recusa IS NULL OR TRIM(p_motivo_recusa) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O motivo da recusa e obrigatorio.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM tbl_documento_doadora
        WHERE id = p_id_documento
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Documento nao encontrado.';
    END IF;

    UPDATE tbl_documento_doadora
    SET id_status_documento = 3,
        motivo_recusa = TRIM(p_motivo_recusa)
    WHERE id = p_id_documento;
END$$

DELIMITER ;
############################################################################################
