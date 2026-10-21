#########################################################################################################
# CADASTRA DOADORA
#########################################################################################################

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
# CADASTRA INSTITUICAO (com endereço, telefone e 7 dias de horário de funcionamento e funconario)
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
    IN p_func_telefone         VARCHAR(25),

    # Retorno
    OUT p_id_instituicao  INT,
    OUT p_id_funcionario  INT
)
BEGIN
    DECLARE v_id_estado             INT;
    DECLARE v_id_cidade             INT;
    DECLARE v_id_endereco           INT;
    DECLARE v_id_telefone           INT;
    DECLARE v_id_instituicao        INT;
    DECLARE v_id_telefone_func      INT;

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
    SET p_id_funcionario = LAST_INSERT_ID();

    SET p_id_instituicao = v_id_instituicao;

    COMMIT;
END$$

DELIMITER ;

CALL proccadastrarinstituicao(
    -- Instituição
    'Banco de Leite Esperança',
    '12.345.678/0001-90', 
    'contato@esperanca.org', 
    'foto.jpg', 
    1,
    '(11) 99999-9999',
    -- Endereço
    'Rua das Flores', 
    '06000-000', 'Centro', 
    '100', 
    'Sala 2',
    -23.55052000, 
    -46.63330800,
    'Osasco', 
    'SP',
    -- Horários
    1, '00:00', '00:00',    -- domingo (fechado)
    2, '08:00', '17:00',    -- segunda
    3, '08:00', '17:00',    -- terça
    4, '08:00', '17:00',    -- quarta
    5, '08:00', '17:00',    -- quinta
    6, '08:00', '17:00',    -- sexta
    7, '08:00', '12:00',    -- sábado
    -- Funcionário
    'Maria Souza', 
    '123.456.789-00', 
    '1990-05-20', 
    'maria@esperanca.org',
    'senha_hash_aqui', 
    'sal_aleatorio_aqui', 
    '(11) 98888-7777',
    -- Retornos
    @id_instituicao, @id_funcionario
);

SELECT @id_instituicao, @id_funcionario;

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





#########################
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


 ###como usar
CALL sp_cadastrar_jornada(
    TRUE,                                   -- is_ativo
    'Jornada de Matrícula',                 -- nome
    'Passo a passo para novos alunos',      -- descricao
    1,                                      -- id_instituicao
    '[
        {
            "titulo": "Envio de documentos",
            "descricao": "Enviar RG e CPF",
            "ordem": 1,
            "documento": "contrato.pdf",
            "is_repetivel": 0,
            "is_agendavel": 0,
            "is_obrigatorio": 1,
            "is_solicita_arquivo": 1,
            "is_precisa_aprovacao": 1
        },
        {
            "titulo": "Entrevista",
            "descricao": "Agendar conversa com a coordenação",
            "ordem": 2,
            "documento": null,
            "is_repetivel": 0,
            "is_agendavel": 1,
            "is_obrigatorio": 1,
            "is_solicita_arquivo": 0,
            "is_precisa_aprovacao": 0
        },
        {
            "titulo": "Acompanhamento",
            "descricao": "Etapa final, pode se repetir",
            "ordem": 3,
            "documento": null,
            "is_repetivel": 1,
            "is_agendavel": 0,
            "is_obrigatorio": 0,
            "is_solicita_arquivo": 0,
            "is_precisa_aprovacao": 0
        }
    ]',
    @codigo
);

SELECT @codigo;









DELIMITER $$

CREATE PROCEDURE proccadastrarhorario (
    # Horário
    IN p_dia       DATE,
    IN p_horario   TIME,

    # Etapa relacionada
    IN p_id_etapa  INT,

    # Retorno
    OUT p_id_cadastro_horario INT
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

    SET p_id_cadastro_horario = LAST_INSERT_ID();

    COMMIT;
END$$

DELIMITER ;

CALL proccadastrarhorario(
    '2026-11-10',       -- Dia do agendamento
    '14:30:00',         -- Horário
    1,                  -- ID da etapa
    @id_cadastro_horario
);