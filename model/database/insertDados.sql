

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
(1, 'Banco de Leite Central de São Paulo',
 '11.111.111/0001-11',
 'contato@bancosp.com.br',
 'banco-sp.jpg',
 3,
 1),

(2, 'Banco de Leite Materno de Campinas',
 '22.222.222/0001-22',
 'contato@bancocampinas.com.br',
 'banco-campinas.jpg',
 2,
 2),

(3, 'Banco de Leite Vida Nova',
 '33.333.333/0001-33',
 'contato@bancovidanova.com.br',
 'banco-vida-nova.jpg',
 1,
 3);


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
(1, true,
 'Jornada de Doação de Leite Materno - São Paulo',
 'Processo completo para cadastro, avaliação e doação de leite materno.',
 1),

(2, true,
 'Jornada de Doação de Leite Materno - Campinas',
 'Processo completo para cadastro, avaliação e doação de leite materno.',
 2),

(3, true,
 'Jornada de Doação de Leite Materno - Vida Nova',
 'Processo completo para cadastro, avaliação e doação de leite materno.',
 3);


-- ============================================================
-- ETAPAS DA JORNADA 1
-- ============================================================

INSERT INTO tbl_etapa
(id, titulo, descricao, ordem, is_repetivel, is_agendavel,
 is_obrigatorio, is_solicita_arquivo, is_precisa_aprovacao, id_jornada)
VALUES
(1, 'Cadastro',
 'Cadastro inicial da doadora.',
 1, false, false, true, false, false, 1),

(2, 'Triagem',
 'Avaliação inicial da doadora.',
 2, false, true, true, false, false, 1),

(3, 'Conversa',
 'Conversa com profissional do banco de leite.',
 3, false, true, true, false, false, 1),

(4, 'Exames',
 'Realização e análise dos exames necessários.',
 4, false, true, true, true, true, 1),

(5, 'Avaliação',
 'Avaliação dos resultados dos exames.',
 5, false, true, true, true, true, 1),

(6, 'Orientação',
 'Orientações para ordenha e armazenamento.',
 6, false, true, true, false, false, 1),

(7, 'Doação de leite',
 'Realização da doação de leite materno.',
 7, true, true, true, false, false, 1);


-- ============================================================
-- ETAPAS DA JORNADA 2
-- ============================================================

INSERT INTO tbl_etapa
(id, titulo, descricao, ordem, is_repetivel, is_agendavel,
 is_obrigatorio, is_solicita_arquivo, is_precisa_aprovacao, id_jornada)
VALUES
(8, 'Cadastro',
 'Cadastro inicial da doadora.',
 1, false, false, true, false, false, 2),

(9, 'Triagem',
 'Avaliação inicial da doadora.',
 2, false, true, true, false, false, 2),

(10, 'Conversa',
 'Conversa com profissional do banco de leite.',
 3, false, true, true, false, false, 2),

(11, 'Exames',
 'Realização e análise dos exames necessários.',
 4, false, true, true, true, true, 2),

(12, 'Avaliação',
 'Avaliação dos resultados dos exames.',
 5, false, true, true, true, true, 2),

(13, 'Orientação',
 'Orientações para ordenha e armazenamento.',
 6, false, true, true, false, false, 2),

(14, 'Doação de leite',
 'Realização da doação de leite materno.',
 7, true, true, true, false, false, 2);


-- ============================================================
-- ETAPAS DA JORNADA 3
-- ============================================================

INSERT INTO tbl_etapa
(id, titulo, descricao, ordem, is_repetivel, is_agendavel,
 is_obrigatorio, is_solicita_arquivo, is_precisa_aprovacao, id_jornada)
VALUES
(15, 'Cadastro',
 'Cadastro inicial da doadora.',
 1, false, false, true, false, false, 3),

(16, 'Triagem',
 'Avaliação inicial da doadora.',
 2, false, true, true, false, false, 3),

(17, 'Conversa',
 'Conversa com profissional do banco de leite.',
 3, false, true, true, false, false, 3),

(18, 'Exames',
 'Realização e análise dos exames necessários.',
 4, false, true, true, true, true, 3),

(19, 'Avaliação',
 'Avaliação dos resultados dos exames.',
 5, false, true, true, true, true, 3),

(20, 'Orientação',
 'Orientações para ordenha e armazenamento.',
 6, false, true, true, false, false, 3),

(21, 'Doação de leite',
 'Realização da doação de leite materno.',
 7, true, true, true, false, false, 3);


-- ============================================================
-- DOADORAS
-- ============================================================

INSERT INTO tbl_doadora
(id, nome, cpf, foto, data_nascimento, email, senha, sal,
 id_endereco, id_telefone)
VALUES

-- BANCO 1
(1, 'Maria Silva',
 '111.111.111-11',
 'maria.jpg',
 '1992-05-10',
 'maria@email.com',
 '123456',
 'salt-maria',
 4, 1),

(2, 'Ana Oliveira',
 '222.222.222-22',
 'ana.jpg',
 '1995-08-15',
 'ana@email.com',
 '123456',
 'salt-ana',
 7, 2),

(3, 'Carla Santos',
 '333.333.333-33',
 'carla.jpg',
 '1998-02-20',
 'carla@email.com',
 '123456',
 'salt-carla',
 1, 3),

-- BANCO 2
(4, 'Juliana Costa',
 '444.444.444-44',
 'juliana.jpg',
 '1991-03-12',
 'juliana@email.com',
 '123456',
 'salt-juliana',
 5, 4),

(5, 'Fernanda Lima',
 '555.555.555-55',
 'fernanda.jpg',
 '1996-06-18',
 'fernanda@email.com',
 '123456',
 'salt-fernanda',
 8, 5),

(6, 'Beatriz Souza',
 '666.666.666-66',
 'beatriz.jpg',
 '1999-11-25',
 'beatriz@email.com',
 '123456',
 'salt-beatriz',
 2, 6),

-- BANCO 3
(7, 'Camila Rodrigues',
 '777.777.777-77',
 'camila.jpg',
 '1993-01-30',
 'camila@email.com',
 '123456',
 'salt-camila',
 6, 7),

(8, 'Daniela Martins',
 '888.888.888-88',
 'daniela.jpg',
 '1997-09-09',
 'daniela@email.com',
 '123456',
 'salt-daniela',
 9, 8),

(9, 'Larissa Almeida',
 '999.999.999-99',
 'larissa.jpg',
 '2000-12-01',
 'larissa@email.com',
 '123456',
 'salt-larissa',
 3, 9);


-- ============================================================
-- CICLOS
-- ============================================================

INSERT INTO tbl_ciclo
(id, numero_ciclo, is_concluido, id_jornada, id_doadora)
VALUES

-- MARIA - BANCO 1
(1, 1, true, 1, 1),
(2, 2, true, 1, 1),
(3, 3, true, 1, 1),
(4, 4, false, 1, 1),

-- ANA - BANCO 1
(5, 1, false, 1, 2),

-- CARLA - BANCO 1
(6, 1, false, 1, 3),

-- JULIANA - BANCO 2
(7, 1, true, 2, 4),
(8, 2, true, 2, 4),
(9, 3, true, 2, 4),
(10, 4, false, 2, 4),

-- FERNANDA - BANCO 2
(11, 1, false, 2, 5),

-- BEATRIZ - BANCO 2
(12, 1, false, 2, 6),

-- CAMILA - BANCO 3
(13, 1, true, 3, 7),
(14, 2, true, 3, 7),
(15, 3, true, 3, 7),
(16, 4, false, 3, 7),

-- DANIELA - BANCO 3
(17, 1, false, 3, 8),

-- LARISSA - BANCO 3
(18, 1, false, 3, 9);


-- ============================================================
-- ETAPAS DA MARIA
-- CICLO 1, 2 E 3 = DOAÇÕES JÁ REALIZADAS
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(1, '2026-04-10', 7, 1),
(2, '2026-05-15', 7, 2),
(3, '2026-06-20', 7, 3),

-- CICLO 4 - TODAS AS ETAPAS ANTERIORES CONCLUÍDAS
(4, '2026-09-01', 1, 4),
(5, '2026-09-03', 2, 4),
(6, '2026-09-05', 3, 4),
(7, '2026-09-10', 4, 4),
(8, '2026-09-12', 5, 4),
(9, '2026-09-15', 6, 4),
(10, NULL, 7, 4);


-- ============================================================
-- ANA
-- ESTÁ NA ETAPA ANTERIOR À DOAÇÃO
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(11, '2026-09-20', 1, 5),
(12, '2026-09-22', 2, 5),
(13, '2026-09-24', 3, 5),
(14, '2026-09-26', 4, 5),
(15, '2026-09-28', 5, 5),
(16, NULL, 6, 5);


-- ============================================================
-- JULIANA
-- 3 DOAÇÕES REALIZADAS + 4ª DOAÇÃO ATUAL
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(17, '2026-04-12', 14, 7),
(18, '2026-05-17', 14, 8),
(19, '2026-06-22', 14, 9),

(20, '2026-08-01', 8, 10),
(21, '2026-08-03', 9, 10),
(22, '2026-08-05', 10, 10),
(23, '2026-08-08', 11, 10),
(24, '2026-08-10', 12, 10),
(25, '2026-08-12', 13, 10),
(26, NULL, 14, 10);


-- ============================================================
-- FERNANDA
-- JÁ PASSOU POR TODAS AS ETAPAS E AGENDOU A DOAÇÃO
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(27, '2026-09-01', 8, 11),
(28, '2026-09-03', 9, 11),
(29, '2026-09-05', 10, 11),
(30, '2026-09-08', 11, 11),
(31, '2026-09-10', 12, 11),
(32, '2026-09-12', 13, 11),
(33, NULL, 14, 11);


-- ============================================================
-- CAMILA
-- 3 DOAÇÕES REALIZADAS + 4ª DOAÇÃO ATUAL
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(34, '2026-04-15', 21, 13),
(35, '2026-05-20', 21, 14),
(36, '2026-06-25', 21, 15),

(37, '2026-08-15', 15, 16),
(38, '2026-08-17', 16, 16),
(39, '2026-08-19', 17, 16),
(40, '2026-08-22', 18, 16),
(41, '2026-08-24', 19, 16),
(42, '2026-08-26', 20, 16),
(43, NULL, 21, 16);


-- ============================================================
-- DANIELA
-- ESTÁ EM EXAMES
-- ============================================================

INSERT INTO tbl_etapa_ciclo
(id, data_conclusao, id_etapa, id_ciclo)
VALUES
(44, '2026-09-15', 15, 17),
(45, '2026-09-17', 16, 17),
(46, '2026-09-19', 17, 17),
(47, NULL, 18, 17);


-- ============================================================
-- CARLA, BEATRIZ E LARISSA
-- NÃO POSSUEM REGISTRO EM tbl_etapa_ciclo
-- POIS AINDA NÃO INICIARAM A JORNADA
-- ============================================================


-- ============================================================
-- HORÁRIOS DISPONÍVEIS PARA DOAÇÃO
-- ============================================================

INSERT INTO tbl_cadastro_horario
(id, dia, horario, id_etapa)
VALUES
(1, '2026-10-08', '09:00:00', 7),
(2, '2026-10-08', '10:00:00', 7),
(3, '2026-10-08', '14:00:00', 7),

(4, '2026-10-09', '09:00:00', 14),
(5, '2026-10-09', '10:00:00', 14),
(6, '2026-10-09', '14:00:00', 14),

(7, '2026-10-10', '09:00:00', 21),
(8, '2026-10-10', '10:00:00', 21);


-- ============================================================
-- STATUS DE AGENDAMENTO
-- ============================================================

INSERT INTO tbl_status_agendamento
(id, status)
VALUES
(1, 'Agendado'),
(2, 'Confirmado'),
(3, 'Realizado'),
(4, 'Cancelado'),
(5, 'Não compareceu');


-- ============================================================
-- AGENDAMENTO DA FERNANDA
-- ============================================================

INSERT INTO tbl_agendamento
(id, id_ciclo, id_cadastro_horario, id_status_agendamento)
VALUES
(1, 11, 4, 1);


-- ============================================================
-- RESUMO DOS DADOS
-- ============================================================

/*
BANCO 1 - SÃO PAULO

Maria:
    3 doações concluídas
    4º ciclo atual
    Todas as etapas anteriores concluídas
    Está na Doação de leite

Ana:
    Está em Orientação
    Todas as etapas anteriores concluídas
    Próxima etapa = Doação

Carla:
    Não iniciou nenhuma etapa


BANCO 2 - CAMPINAS

Juliana:
    3 doações concluídas
    4º ciclo atual
    Todas as etapas anteriores concluídas
    Está na Doação de leite

Fernanda:
    Primeira doação
    Todas as etapas anteriores concluídas
    Está na Doação
    Possui agendamento

Beatriz:
    Não iniciou nenhuma etapa


BANCO 3 - VIDA NOVA

Camila:
    3 doações concluídas
    4º ciclo atual
    Todas as etapas anteriores concluídas
    Está na Doação de leite

Daniela:
    Está em Exames

Larissa:
    Não iniciou nenhuma etapa


REGRA:

Somente "Doação de leite" possui is_repetivel = TRUE.

As demais etapas NÃO são repetidas nos novos ciclos.

Quando a doadora chega à Doação, todas as etapas
anteriores já estão concluídas.

Maria:
    Ciclo 1 -> Doação concluída
    Ciclo 2 -> Doação concluída
    Ciclo 3 -> Doação concluída
    Ciclo 4 -> Doação atual

Juliana:
    Ciclo 1 -> Doação concluída
    Ciclo 2 -> Doação concluída
    Ciclo 3 -> Doação concluída
    Ciclo 4 -> Doação atual

Camila:
    Ciclo 1 -> Doação concluída
    Ciclo 2 -> Doação concluída
    Ciclo 3 -> Doação concluída
    Ciclo 4 -> Doação atual
/*
