
/* ============================================================
   ESTADOS
   ============================================================ */

INSERT INTO tbl_estado (sigla)
VALUES
('SP'),
('RJ'),
('MG');


/* ============================================================
   CIDADES
   ============================================================ */

INSERT INTO tbl_cidade (nome, id_estado)
VALUES
('São Paulo', 1),
('Campinas', 1),
('Rio de Janeiro', 2),
('Belo Horizonte', 3);


/* ============================================================
   ENDEREÇOS
   ============================================================ */

INSERT INTO tbl_endereco
(
    logradouro,
    cep,
    bairro,
    numero,
    complemento,
    latitude,
    longitude,
    id_cidade
)
VALUES
(
    'Rua das Flores',
    '01000-000',
    'Centro',
    '100',
    'Prédio A',
    -23.55052000,
    -46.63330800,
    1
),
(
    'Avenida Brasil',
    '13000-000',
    'Jardim Central',
    '500',
    'Bloco B',
    -22.90993800,
    -47.06263300,
    2
),
(
    'Rua da Saúde',
    '20000-000',
    'Centro',
    '250',
    'Prédio Principal',
    -22.90684700,
    -43.17289600,
    3
),
(
    'Avenida da Esperança',
    '30000-000',
    'Funcionários',
    '800',
    'Sala 10',
    -19.92450000,
    -43.93500000,
    4
);


/* ============================================================
   TELEFONES
   ============================================================ */

INSERT INTO tbl_telefone (numero)
VALUES
('(11) 3000-1000'),
('(19) 3000-2000'),
('(21) 3000-3000'),
('(31) 3000-4000'),

-- Telefones das doadoras
('(11) 99111-1111'),
('(19) 99222-2222'),
('(21) 99333-3333'),
('(31) 99444-4444'),
('(11) 99555-5555'),

-- Telefones adicionais
('(11) 98888-1111'),
('(19) 98888-2222'),
('(21) 98888-3333');


/* ============================================================
   TIPO DE COLETA
   ============================================================ */

INSERT INTO tbl_tipo_coleta (tipo)
VALUES
('Coleta no banco de leite'),
('Coleta domiciliar'),
('Coleta agendada');


/* ============================================================
   INSTITUIÇÕES
   ============================================================ */

INSERT INTO tbl_instituicao
(
    nome,
    cnpj,
    email,
    foto,
    id_coleta,
    id_endereco
)
VALUES
(
    'Banco de Leite Materno Central',
    '11.111.111/0001-11',
    'contato@blcentral.com.br',
    'banco-central.jpg',
    1,
    1
),
(
    'Banco de Leite Materno Vida',
    '22.222.222/0001-22',
    'contato@blvida.com.br',
    'banco-vida.jpg',
    2,
    2
),
(
    'Banco de Leite Materno Esperança',
    '33.333.333/0001-33',
    'contato@blesperanca.com.br',
    'banco-esperanca.jpg',
    3,
    3
);


/* ============================================================
   TELEFONES DAS INSTITUIÇÕES
   ============================================================ */

INSERT INTO tbl_telefone_instituicao
(
    id_instituicao,
    id_telefone
)
VALUES
(1, 1),
(2, 2),
(3, 3);


/* ============================================================
   DOADORAS
   ============================================================ */

INSERT INTO tbl_doadora
(
    nome,
    cpf,
    foto,
    data_nascimento,
    email,
    senha,
    sal,
    id_endereco,
    id_telefone
)
VALUES
(
    'Maria Silva',
    '111.111.111-11',
    'maria.jpg',
    '1992-05-10',
    'maria@email.com',
    'senha_hash_maria',
    'salt_maria',
    1,
    5
),
(
    'Ana Souza',
    '222.222.222-22',
    'ana.jpg',
    '1995-08-20',
    'ana@email.com',
    'senha_hash_ana',
    'salt_ana',
    2,
    6
),
(
    'Carla Oliveira',
    '333.333.333-33',
    'carla.jpg',
    '1990-03-15',
    'carla@email.com',
    'senha_hash_carla',
    'salt_carla',
    3,
    7
),
(
    'Juliana Santos',
    '444.444.444-44',
    'juliana.jpg',
    '1998-11-02',
    'juliana@email.com',
    'senha_hash_juliana',
    'salt_juliana',
    4,
    8
),
(
    'Fernanda Costa',
    '555.555.555-55',
    'fernanda.jpg',
    '1993-01-25',
    'fernanda@email.com',
    'senha_hash_fernanda',
    'salt_fernanda',
    1,
    9
);


/* ============================================================
   FUNCIONÁRIOS
   ============================================================ */

INSERT INTO tbl_funcionario
(
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
VALUES
(
    'Roberto Almeida',
    '101.101.101-01',
    '1985-04-10',
    'roberto@blcentral.com.br',
    true,
    'senha_hash_roberto',
    'salt_roberto',
    10,
    1
),
(
    'Patricia Lima',
    '202.202.202-02',
    '1988-07-20',
    'patricia@blvida.com.br',
    true,
    'senha_hash_patricia',
    'salt_patricia',
    11,
    2
),
(
    'Marcos Ferreira',
    '303.303.303-03',
    '1982-09-12',
    'marcos@blesperanca.com.br',
    false,
    'senha_hash_marcos',
    'salt_marcos',
    12,
    3
);


/* ============================================================
   JORNADAS
   ============================================================ */

INSERT INTO tbl_jornada
(
    is_ativo,
    nome,
    descricao,
    id_instituicao
)
VALUES
(
    true,
    'Jornada de Doação de Leite Materno',
    'Processo completo para cadastro, avaliação, preparação e doação de leite materno.',
    1
),
(
    true,
    'Jornada de Doação de Leite Materno',
    'Processo de acompanhamento de doadoras e realização de doações de leite materno.',
    2
),
(
    true,
    'Jornada de Doação de Leite Materno',
    'Jornada de atendimento e acompanhamento de doadoras de leite materno.',
    3
);


/* ============================================================
   ETAPAS DA JORNADA 1
   ============================================================ */

INSERT INTO tbl_etapa
(
    titulo,
    descricao,
    ordem,
    is_repetivel,
    is_agendavel,
    is_obrigatorio,
    is_solicita_arquivo,
    is_precisa_aprovacao,
    id_jornada
)
VALUES
(
    'Cadastro',
    'Cadastro inicial da doadora.',
    1,
    false,
    false,
    true,
    false,
    false,
    1
),
(
    'Triagem',
    'Avaliação inicial da doadora.',
    2,
    false,
    true,
    true,
    false,
    true,
    1
),
(
    'Conversa',
    'Conversa inicial com a equipe do banco de leite.',
    3,
    false,
    true,
    true,
    false,
    false,
    1
),
(
    'Exames',
    'Realização dos exames necessários.',
    4,
    false,
    true,
    true,
    true,
    true,
    1
),
(
    'Avaliação dos exames',
    'Avaliação dos resultados dos exames.',
    5,
    false,
    false,
    true,
    false,
    true,
    1
),
(
    'Orientação',
    'Orientações sobre ordenha, higiene, armazenamento e transporte.',
    6,
    false,
    true,
    true,
    false,
    false,
    1
),
(
    'Doação de leite',
    'Realização da doação de leite materno.',
    7,
    true,
    true,
    true,
    false,
    false,
    1
);


/* ============================================================
   ETAPAS DA JORNADA 2
   ============================================================ */

INSERT INTO tbl_etapa
(
    titulo,
    descricao,
    ordem,
    is_repetivel,
    is_agendavel,
    is_obrigatorio,
    is_solicita_arquivo,
    is_precisa_aprovacao,
    id_jornada
)
VALUES
(
    'Cadastro',
    'Cadastro inicial da doadora.',
    1,
    false,
    false,
    true,
    false,
    false,
    2
),
(
    'Triagem',
    'Avaliação inicial da doadora.',
    2,
    false,
    true,
    true,
    false,
    true,
    2
),
(
    'Conversa',
    'Conversa inicial com a equipe do banco de leite.',
    3,
    false,
    true,
    true,
    false,
    false,
    2
),
(
    'Exames',
    'Realização dos exames necessários.',
    4,
    false,
    true,
    true,
    true,
    true,
    2
),
(
    'Avaliação dos exames',
    'Avaliação dos resultados dos exames.',
    5,
    false,
    false,
    true,
    false,
    true,
    2
),
(
    'Orientação',
    'Orientações para a doadora.',
    6,
    false,
    true,
    true,
    false,
    false,
    2
),
(
    'Doação de leite',
    'Realização da doação de leite materno.',
    7,
    true,
    true,
    true,
    false,
    false,
    2
);


/* ============================================================
   ETAPAS DA JORNADA 3
   ============================================================ */

INSERT INTO tbl_etapa
(
    titulo,
    descricao,
    ordem,
    is_repetivel,
    is_agendavel,
    is_obrigatorio,
    is_solicita_arquivo,
    is_precisa_aprovacao,
    id_jornada
)
VALUES
(
    'Cadastro',
    'Cadastro inicial da doadora.',
    1,
    false,
    false,
    true,
    false,
    false,
    3
),
(
    'Triagem',
    'Avaliação inicial da doadora.',
    2,
    false,
    true,
    true,
    false,
    true,
    3
),
(
    'Conversa',
    'Conversa inicial com a equipe do banco de leite.',
    3,
    false,
    true,
    true,
    false,
    false,
    3
),
(
    'Exames',
    'Realização dos exames necessários.',
    4,
    false,
    true,
    true,
    true,
    true,
    3
),
(
    'Avaliação dos exames',
    'Avaliação dos resultados dos exames.',
    5,
    false,
    false,
    true,
    false,
    true,
    3
),
(
    'Orientação',
    'Orientações para a doadora.',
    6,
    false,
    true,
    true,
    false,
    false,
    3
),
(
    'Doação de leite',
    'Realização da doação de leite materno.',
    7,
    true,
    true,
    true,
    false,
    false,
    3
);


/* ============================================================
   HORÁRIOS DE FUNCIONAMENTO
   dia:
   1 = Domingo
   2 = Segunda
   3 = Terça
   4 = Quarta
   5 = Quinta
   6 = Sexta
   7 = Sábado
   ============================================================ */

INSERT INTO tbl_horario_funcionamento
(
    dia,
    hora_inicio,
    hora_fim,
    id_instituicao
)
VALUES
(2, '08:00:00', '17:00:00', 1),
(3, '08:00:00', '17:00:00', 1),
(4, '08:00:00', '17:00:00', 1),
(5, '08:00:00', '17:00:00', 1),
(6, '08:00:00', '17:00:00', 1),

(2, '08:00:00', '17:00:00', 2),
(3, '08:00:00', '17:00:00', 2),
(4, '08:00:00', '17:00:00', 2),
(5, '08:00:00', '17:00:00', 2),
(6, '08:00:00', '17:00:00', 2),

(2, '08:00:00', '17:00:00', 3),
(3, '08:00:00', '17:00:00', 3),
(4, '08:00:00', '17:00:00', 3),
(5, '08:00:00', '17:00:00', 3),
(6, '08:00:00', '17:00:00', 3);


/* ============================================================
   DOCUMENTOS EXIGIDOS PELAS INSTITUIÇÕES
   ============================================================ */

INSERT INTO tbl_documento_instituicao
(documento, id_etapa)
VALUES
('Documento de identificação', 1),
('Carteira de vacinação', 2),
('Exame de sangue', 4),
('Exame sorológico', 4),

('Documento de identificação', 8),
('Carteira de vacinação', 9),
('Exame de sangue', 11),
('Exame sorológico', 11),

('Documento de identificação', 15),
('Carteira de vacinação', 16),
('Exame de sangue', 18),
('Exame sorológico', 18);


/* ============================================================
   CICLOS DAS DOADORAS
   ============================================================

   JORNADA 1:
   Maria = 4 ciclos
       Ciclo 1 = doação concluída
       Ciclo 2 = doação concluída
       Ciclo 3 = doação concluída
       Ciclo 4 = doação atual/agendada

   Ana = 1 ciclo
       Ciclo 1 = primeira doação agendada

   JORNADA 2:
   Carla = ciclo 1, ainda em Orientação

   JORNADA 3:
   Juliana = ciclo 1, Cadastro ainda não concluído

   Fernanda = jornada 2, processo completo até Orientação
   ============================================================ */


/* Maria - 4 ciclos */
INSERT INTO tbl_ciclo
(numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES
(1, true,  1, 1),
(2, true,  1, 1),
(3, true,  1, 1),
(4, false, 1, 1);


/* Ana - primeiro ciclo */
INSERT INTO tbl_ciclo
(numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES
(1, false, 1, 2);


/* Carla - está antes da doação */
INSERT INTO tbl_ciclo
(numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES
(1, false, 2, 3);


/* Juliana - não fez nenhuma etapa */
INSERT INTO tbl_ciclo
(numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES
(1, false, 3, 4);


/* Fernanda - processo avançado */
INSERT INTO tbl_ciclo
(numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES
(1, false, 2, 5);


/* ============================================================
   ETAPAS DOS CICLOS
   ============================================================

   MARIA
   Os três primeiros ciclos são somente a etapa repetível:
   DOAÇÃO.

   No ciclo 4, a doação ainda não foi concluída.
   ============================================================ */


/* Maria - Ciclo 1 - Doação concluída */
INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
('2026-08-05', 7, 1);


/* Maria - Ciclo 2 - Doação concluída */
INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
('2026-08-19', 7, 2);


/* Maria - Ciclo 3 - Doação concluída */
INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
('2026-09-02', 7, 3);


/* Maria - Ciclo 4 - Doação agendada, ainda não concluída */
INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
(NULL, 7, 4);


/* ============================================================
   ANA
   Acabou de agendar sua primeira doação.
   ============================================================ */

INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
(NULL, 14, 5);


/* ============================================================
   CARLA
   Está na etapa anterior à doação:
   ORIENTAÇÃO = etapa 13 da jornada 2
   ============================================================ */

INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
('2026-09-20', 8, 6),   -- Cadastro
('2026-09-22', 9, 6),   -- Triagem
('2026-09-24', 10, 6),  -- Conversa
('2026-09-26', 11, 6),  -- Exames
('2026-09-29', 12, 6),  -- Avaliação
(NULL,         13, 6);  -- Orientação atual


/* ============================================================
   JULIANA
   Não fez nenhuma etapa.
   Cadastro é a primeira etapa e ainda está pendente.
   ============================================================ */

INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
(NULL, 15, 7);


/* ============================================================
   FERNANDA
   Está na etapa de orientação.
   ============================================================ */

INSERT INTO tbl_etapa_ciclo
(data_conclusao, id_etapa, id_ciclo)
VALUES
('2026-09-10', 8, 8),
('2026-09-11', 9, 8),
('2026-09-12', 10, 8),
('2026-09-15', 11, 8),
('2026-09-18', 12, 8),
('2026-09-20', 13, 8);


/* ============================================================
   HORÁRIOS DISPONÍVEIS
   ============================================================

   Maria:
   Ciclo 4 -> Doação -> 2026-10-15 09:00

   Ana:
   Ciclo 1 -> Doação -> 2026-10-16 10:00
   ============================================================ */


/* Maria - horários para DOAÇÃO */
INSERT INTO tbl_cadastro_horario
(dia, horario, id_etapa)
VALUES
('2026-10-15', '08:00:00', 7),
('2026-10-15', '09:00:00', 7),
('2026-10-15', '10:00:00', 7),
('2026-10-15', '11:00:00', 7);


/* Ana - horários para DOAÇÃO */
INSERT INTO tbl_cadastro_horario
(dia, horario, id_etapa)
VALUES
('2026-10-16', '08:00:00', 14),
('2026-10-16', '09:00:00', 14),
('2026-10-16', '10:00:00', 14),
('2026-10-16', '11:00:00', 14);


/* Horários para outras etapas */
INSERT INTO tbl_cadastro_horario
(dia, horario, id_etapa)
VALUES
('2026-10-13', '09:00:00', 9),
('2026-10-13', '10:00:00', 9),

('2026-10-14', '09:00:00', 10),
('2026-10-14', '10:00:00', 10),

('2026-10-15', '09:00:00', 13),
('2026-10-15', '10:00:00', 13);


/* ============================================================
   STATUS DOS AGENDAMENTOS
   ============================================================ */

INSERT INTO tbl_status_agendamento
(status)
VALUES
('Pendente'),
('Confirmado'),
('Cancelado'),
('Concluído'),
('Não compareceu');


/* ============================================================
   AGENDAMENTOS
   ============================================================

   ID DOS HORÁRIOS:

   1  = Maria - 08:00
   2  = Maria - 09:00
   3  = Maria - 10:00
   4  = Maria - 11:00

   5  = Ana - 08:00
   6  = Ana - 09:00
   7  = Ana - 10:00
   8  = Ana - 11:00

   9  = Triagem
   10 = Triagem
   11 = Conversa
   12 = Conversa
   13 = Orientação
   14 = Orientação
   ============================================================ */


/* Maria - próxima doação */
INSERT INTO tbl_agendamento
(
    id_ciclo,
    id_cadastro_horario,
    id_status_agendamento
)
VALUES
(
    4,
    2,
    2
);


/* Ana - acabou de agendar */
INSERT INTO tbl_agendamento
(
    id_ciclo,
    id_cadastro_horario,
    id_status_agendamento
)
VALUES
(
    5,
    7,
    1
);


/* ============================================================
   DOCUMENTOS DAS DOADORAS
   ============================================================ */


/* Maria */
INSERT INTO tbl_documento_doadora
(
    documento,
    motivo_recusa,
    id_etapa_ciclo,
    id_doadora
)
VALUES
(
    'documentos/maria-documento.pdf',
    '',
    1,
    1
),
(
    'documentos/maria-exame.pdf',
    '',
    1,
    1
);


/* Ana */
INSERT INTO tbl_documento_doadora
(
    documento,
    motivo_recusa,
    id_etapa_ciclo,
    id_doadora
)
VALUES
(
    'documentos/ana-documento.pdf',
    '',
    5,
    2
);


/* Carla */
INSERT INTO tbl_documento_doadora
(
    documento,
    motivo_recusa,
    id_etapa_ciclo,
    id_doadora
)
VALUES
(
    'documentos/carla-documento.pdf',
    '',
    9,
    3
),
(
    'documentos/carla-exame.pdf',
    '',
    11,
    3
);


/* Juliana */
INSERT INTO tbl_documento_doadora
(
    documento,
    motivo_recusa,
    id_etapa_ciclo,
    id_doadora
)
VALUES
(
    'documentos/juliana-documento.pdf',
    '',
    15,
    4
);


/* Fernanda */
INSERT INTO tbl_documento_doadora
(
    documento,
    motivo_recusa,
    id_etapa_ciclo,
    id_doadora
)
VALUES
(
    'documentos/fernanda-documento.pdf',
    '',
    8,
    5
);
