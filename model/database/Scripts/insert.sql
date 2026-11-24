#ARQUIVO RESPONSAVEL POR FAZER CADASTRO
use db_tech_bridge_materna;

-- ============================================================
-- STATUS
-- ============================================================

INSERT INTO tbl_status_agendamento (id, status) VALUES
(1, 'Pendente'),
(2, 'Aceito'),
(3, 'Recusado'),
(4, 'Cancelado');

INSERT INTO tbl_status_documento_doadora (id, status) VALUES
(1, 'Pendente'),
(2, 'Aceito'),
(3, 'Recusado');


-- ============================================================
-- ESTADOS
-- ============================================================

INSERT INTO tbl_estado (id, sigla) VALUES
(1, 'SP'),
(2, 'RJ'),
(3, 'MG');


-- ============================================================
-- CIDADES
-- ============================================================

INSERT INTO tbl_cidade (id, nome, id_estado) VALUES
(1, 'São Paulo', 1),
(2, 'Campinas', 1),
(3, 'Rio de Janeiro', 2);


-- ============================================================
-- ENDEREÇOS
-- ============================================================

INSERT INTO tbl_endereco
(id, logradouro, cep, bairro, numero, complemento, latitude, longitude, id_cidade)
VALUES
(1, 'Av. Paulista', '01310-100', 'Bela Vista', '1000', 'Bloco A', -23.56168400, -46.65598100, 1),
(2, 'Rua das Flores', '13010-000', 'Centro', '250', 'Sala 1', -22.90556000, -47.06083000, 2),
(3, 'Av. Atlântica', '22021-001', 'Copacabana', '500', 'Bloco B', -22.97196400, -43.18223500, 3),
(4, 'Rua das Acácias', '01311-000', 'Jardins', '150', 'Casa', -23.56500000, -46.66000000, 1),
(5, 'Rua das Palmeiras', '13015-000', 'Centro', '300', 'Apto 21', -22.91000000, -47.06200000, 2),
(6, 'Rua do Sol', '22030-000', 'Botafogo', '450', 'Casa', -22.95000000, -43.18500000, 3),
(7, 'Rua das Rosas', '01312-000', 'Paraíso', '200', 'Apto 10', -23.57000000, -46.65000000, 1),
(8, 'Rua das Oliveiras', '13020-000', 'Taquaral', '500', 'Casa', -22.89500000, -47.04000000, 2),
(9, 'Rua Primavera', '22040-000', 'Laranjeiras', '700', 'Apto 30', -22.93500000, -43.19000000, 3);


-- ============================================================
-- TELEFONES
-- ============================================================

INSERT INTO tbl_telefone (id, numero) VALUES
(1, '(11) 3000-0001'),
(2, '(11) 3000-0002'),
(3, '(11) 3000-0003'),
(4, '(21) 3000-0004'),
(5, '(21) 3000-0005'),
(6, '(21) 3000-0006'),
(7, '(11) 3000-0007'),
(8, '(11) 3000-0008'),
(9, '(21) 3000-0009'),
(10, '(11) 4000-0001'),
(11, '(21) 4000-0002'),
(12, '(21) 4000-0003');


-- ============================================================
-- TIPO DE COLETA
-- ============================================================

INSERT INTO tbl_tipo_coleta (id, tipo) VALUES
(1, 'Coleta domiciliar'),
(2, 'Coleta no banco de leite'),
(3, 'Coleta domiciliar e no banco de leite');


-- ============================================================
-- INSTITUIÇÕES / BANCOS DE LEITE
-- ============================================================

INSERT INTO tbl_instituicao
(id, nome, cnpj, email, foto, id_coleta, id_endereco)
VALUES
(1, 'Banco de Leite Central de São Paulo', '11.111.111/0001-11', 'contato@bancosp.com.br', 'banco-sp.jpg', 3, 1),
(2, 'Banco de Leite Materno de Campinas', '22.222.222/0001-22', 'contato@bancocampinas.com.br', 'banco-campinas.jpg', 2, 2),
(3, 'Banco de Leite Vida Nova', '33.333.333/0001-33', 'contato@bancovidanova.com.br', 'banco-vida-nova.jpg', 1, 3);


-- ============================================================
-- HORÁRIO DE FUNCIONAMENTO
-- ============================================================

INSERT INTO tbl_horario_funcionamento
(id, dia, hora_inicio, hora_fim, id_instituicao)
VALUES
(1, 1, '08:00:00', '17:00:00', 1),
(2, 2, '08:00:00', '17:00:00', 1),
(3, 3, '08:00:00', '17:00:00', 1),
(4, 4, '08:00:00', '17:00:00', 1),
(5, 5, '08:00:00', '17:00:00', 1),

(6, 1, '08:00:00', '16:00:00', 2),
(7, 2, '08:00:00', '16:00:00', 2),
(8, 3, '08:00:00', '16:00:00', 2),
(9, 4, '08:00:00', '16:00:00', 2),
(10, 5, '08:00:00', '16:00:00', 2),

(11, 1, '07:00:00', '18:00:00', 3),
(12, 2, '07:00:00', '18:00:00', 3),
(13, 3, '07:00:00', '18:00:00', 3),
(14, 4, '07:00:00', '18:00:00', 3),
(15, 5, '07:00:00', '18:00:00', 3);


-- ============================================================
-- TELEFONES DAS INSTITUIÇÕES
-- ============================================================

INSERT INTO tbl_telefone_instituicao
(id, id_instituicao, id_telefone)
VALUES
(1, 1, 10),
(2, 2, 11),
(3, 3, 12);


-- ============================================================
-- JORNADAS
-- ============================================================

INSERT INTO tbl_jornada
(id, is_ativo, nome, descricao, id_instituicao)
VALUES
(1, true, 'Jornada de Doação de Leite Materno - São Paulo',
 'Processo completo para cadastro, avaliação e doação de leite materno.', 1),
(2, true, 'Jornada de Doação de Leite Materno - Campinas',
 'Processo completo para cadastro, avaliação e doação de leite materno.', 2),
(3, true, 'Jornada de Doação de Leite Materno - Vida Nova',
 'Processo completo para cadastro, avaliação e doação de leite materno.', 3);


-- ============================================================
-- ETAPAS (JORNADAS 1, 2 E 3)
-- ============================================================

INSERT INTO tbl_etapa
(id, titulo, descricao, ordem, is_repetivel, is_agendavel,
 is_obrigatorio, is_solicita_arquivo, is_precisa_aprovacao, id_jornada)
VALUES
-- JORNADA 1
(1, 'Cadastro', 'Cadastro inicial da doadora.', 1, false, false, true, false, false, 1),
(2, 'Triagem', 'Avaliação inicial da doadora.', 2, false, true, true, false, false, 1),
(3, 'Conversa', 'Conversa com profissional do banco de leite.', 3, false, true, true, false, false, 1),
(4, 'Exames', 'Realização e análise dos exames necessários.', 4, false, true, true, true, true, 1),
(5, 'Avaliação', 'Avaliação dos resultados dos exames.', 5, false, true, true, true, true, 1),
(6, 'Orientação', 'Orientações para ordenha e armazenamento.', 6, false, true, true, false, false, 1),
(7, 'Doação de leite', 'Realização da doação de leite materno.', 7, true, true, true, false, false, 1),

-- JORNADA 2
(8, 'Cadastro', 'Cadastro inicial da doadora.', 1, false, false, true, false, false, 2),
(9, 'Triagem', 'Avaliação inicial da doadora.', 2, false, true, true, false, false, 2),
(10, 'Conversa', 'Conversa com profissional do banco de leite.', 3, false, true, true, false, false, 2),
(11, 'Exames', 'Realização e análise dos exames necessários.', 4, false, true, true, true, true, 2),
(12, 'Avaliação', 'Avaliação dos resultados dos exames.', 5, false, true, true, true, true, 2),
(13, 'Orientação', 'Orientações para ordenha e armazenamento.', 6, false, true, true, false, false, 2),
(14, 'Doação de leite', 'Realização da doação de leite materno.', 7, true, true, true, false, false, 2),

-- JORNADA 3
(15, 'Cadastro', 'Cadastro inicial da doadora.', 1, false, false, true, false, false, 3),
(16, 'Triagem', 'Avaliação inicial da doadora.', 2, false, true, true, false, false, 3),
(17, 'Conversa', 'Conversa com profissional do banco de leite.', 3, false, true, true, false, false, 3),
(18, 'Exames', 'Realização e análise dos exames necessários.', 4, false, true, true, true, true, 3),
(19, 'Avaliação', 'Avaliação dos resultados dos exames.', 5, false, true, true, true, true, 3),
(20, 'Orientação', 'Orientações para ordenha e armazenamento.', 6, false, true, true, false, false, 3),
(21, 'Doação de leite', 'Realização da doação de leite materno.', 7, true, true, true, false, false, 3);


-- ============================================================
-- DOADORAS
-- ============================================================

INSERT INTO tbl_doadora
(id, nome, cpf, foto, data_nascimento, email, senha, sal, is_validado,
 id_endereco, id_telefone)
VALUES
-- BANCO 1
(1, 'Maria Silva',     '111.111.111-11', 'maria.jpg',     '1992-05-10', 'maria@email.com',     '123456', 'salt-maria',     true, 4, 1),
(2, 'Ana Oliveira',    '222.222.222-22', 'ana.jpg',       '1995-08-15', 'ana@email.com',       '123456', 'salt-ana',       true, 7, 2),
(3, 'Carla Santos',    '333.333.333-33', 'carla.jpg',     '1998-02-20', 'carla@email.com',     '123456', 'salt-carla',     true, 1, 3),

-- BANCO 2
(4, 'Juliana Costa',   '444.444.444-44', 'juliana.jpg',   '1991-03-12', 'juliana@email.com',   '123456', 'salt-juliana',   true, 5, 4),
(5, 'Fernanda Lima',   '555.555.555-55', 'fernanda.jpg',  '1996-06-18', 'fernanda@email.com',  '123456', 'salt-fernanda',  true, 8, 5),
(6, 'Beatriz Souza',   '666.666.666-66', 'beatriz.jpg',   '1999-11-25', 'beatriz@email.com',   '123456', 'salt-beatriz',   true, 2, 6),

-- BANCO 3
(7, 'Camila Rodrigues','777.777.777-77', 'camila.jpg',    '1993-01-30', 'camila@email.com',    '123456', 'salt-camila',    true, 6, 7),
(8, 'Daniela Martins', '888.888.888-88', 'daniela.jpg',   '1997-09-09', 'daniela@email.com',   '123456', 'salt-daniela',   true, 9, 8),
(9, 'Larissa Almeida', '999.999.999-99', 'larissa.jpg',   '2000-12-01', 'larissa@email.com',   '123456', 'salt-larissa',   true, 3, 9);


-- ============================================================
-- JORNADA DOAÇÃO (substitui tbl_ciclo + tbl_etapa_ciclo)
-- uma linha por etapa; "ciclo" = número do ciclo da doadora
-- encerrado = true nos ciclos já concluídos
-- ============================================================

INSERT INTO tbl_jornada_doacao
(id, ciclo, data_conclusao, encerrado, id_etapa, id_doadora, id_instituicao, id_jornada)
VALUES

-- MARIA (doadora 1 / instituição 1 / jornada 1)
-- Ciclos 1, 2 e 3: doações realizadas
(1,  1, '2026-04-10', true,  7, 1, 1, 1),
(2,  2, '2026-05-15', true,  7, 1, 1, 1),
(3,  3, '2026-06-20', true,  7, 1, 1, 1),
-- Ciclo 4: atual
(4,  4, '2026-09-01', false, 1, 1, 1, 1),
(5,  4, '2026-09-03', false, 2, 1, 1, 1),
(6,  4, '2026-09-05', false, 3, 1, 1, 1),
(7,  4, '2026-09-10', false, 4, 1, 1, 1),
(8,  4, '2026-09-12', false, 5, 1, 1, 1),
(9,  4, '2026-09-15', false, 6, 1, 1, 1),
(10, 4, NULL,         false, 7, 1, 1, 1),

-- ANA (doadora 2 / instituição 1 / jornada 1) - em Orientação
(11, 1, '2026-09-20', false, 1, 2, 1, 1),
(12, 1, '2026-09-22', false, 2, 2, 1, 1),
(13, 1, '2026-09-24', false, 3, 2, 1, 1),
(14, 1, '2026-09-26', false, 4, 2, 1, 1),
(15, 1, '2026-09-28', false, 5, 2, 1, 1),
(16, 1, NULL,         false, 6, 2, 1, 1),

-- JULIANA (doadora 4 / instituição 2 / jornada 2)
-- Ciclos 1, 2 e 3: doações realizadas
(17, 1, '2026-04-12', true,  14, 4, 2, 2),
(18, 2, '2026-05-17', true,  14, 4, 2, 2),
(19, 3, '2026-06-22', true,  14, 4, 2, 2),
-- Ciclo 4: atual
(20, 4, '2026-08-01', false, 8,  4, 2, 2),
(21, 4, '2026-08-03', false, 9,  4, 2, 2),
(22, 4, '2026-08-05', false, 10, 4, 2, 2),
(23, 4, '2026-08-08', false, 11, 4, 2, 2),
(24, 4, '2026-08-10', false, 12, 4, 2, 2),
(25, 4, '2026-08-12', false, 13, 4, 2, 2),
(26, 4, NULL,         false, 14, 4, 2, 2),

-- FERNANDA (doadora 5 / instituição 2 / jornada 2) - na Doação, com agendamento
(27, 1, '2026-09-01', false, 8,  5, 2, 2),
(28, 1, '2026-09-03', false, 9,  5, 2, 2),
(29, 1, '2026-09-05', false, 10, 5, 2, 2),
(30, 1, '2026-09-08', false, 11, 5, 2, 2),
(31, 1, '2026-09-10', false, 12, 5, 2, 2),
(32, 1, '2026-09-12', false, 13, 5, 2, 2),
(33, 1, NULL,         false, 14, 5, 2, 2),

-- CAMILA (doadora 7 / instituição 3 / jornada 3)
-- Ciclos 1, 2 e 3: doações realizadas
(34, 1, '2026-04-15', true,  21, 7, 3, 3),
(35, 2, '2026-05-20', true,  21, 7, 3, 3),
(36, 3, '2026-06-25', true,  21, 7, 3, 3),
-- Ciclo 4: atual
(37, 4, '2026-08-15', false, 15, 7, 3, 3),
(38, 4, '2026-08-17', false, 16, 7, 3, 3),
(39, 4, '2026-08-19', false, 17, 7, 3, 3),
(40, 4, '2026-08-22', false, 18, 7, 3, 3),
(41, 4, '2026-08-24', false, 19, 7, 3, 3),
(42, 4, '2026-08-26', false, 20, 7, 3, 3),
(43, 4, NULL,         false, 21, 7, 3, 3),

-- DANIELA (doadora 8 / instituição 3 / jornada 3) - em Exames
(44, 1, '2026-09-15', false, 15, 8, 3, 3),
(45, 1, '2026-09-17', false, 16, 8, 3, 3),
(46, 1, '2026-09-19', false, 17, 8, 3, 3),
(47, 1, NULL,         false, 18, 8, 3, 3);

-- Carla, Beatriz e Larissa não possuem registro em tbl_jornada_doacao
-- pois ainda não iniciaram a jornada.


-- ============================================================
-- HORÁRIOS DISPONÍVEIS PARA DOAÇÃO
-- ============================================================

INSERT INTO tbl_cadastro_horario
(id, dia, horario, disponivel, id_etapa)
VALUES
(1, '2026-10-08', '09:00:00', true,  7),
(2, '2026-10-08', '10:00:00', true,  7),
(3, '2026-10-08', '14:00:00', true,  7),

(4, '2026-10-09', '09:00:00', false, 14),  -- ocupado pela Fernanda
(5, '2026-10-09', '10:00:00', true,  14),
(6, '2026-10-09', '14:00:00', true,  14),

(7, '2026-10-10', '09:00:00', true,  21),
(8, '2026-10-10', '10:00:00', true,  21);


-- ============================================================
-- AGENDAMENTO DA FERNANDA
-- jornada_doacao 33 = Fernanda / etapa Doação / ciclo 1
-- ============================================================

INSERT INTO tbl_agendamento
(id, id_jornada_doacao, id_cadastro_horario, id_status_agendamento)
VALUES
(1, 33, 4, 1);