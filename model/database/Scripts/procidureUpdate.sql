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