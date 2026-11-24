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
