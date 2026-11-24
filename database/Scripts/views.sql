CREATE OR REPLACE VIEW vw_horarios AS
SELECT
    ch.id AS id_horario,
    ch.dia AS data,
    ch.horario AS hora,
    ch.disponivel AS disponivel,
    sa.id AS id_status,
    sa.status AS status,
    e.id AS id_etapa,
    e.titulo AS etapa,
    e.id_jornada AS id_jornada,
    j.id_instituicao AS id_instituicao,
    ag.id AS id_agendamento,
    jd.id AS id_jornada_doacao,
    jd.encerrado AS encerrado,
    d.id AS id_doadora,
    d.nome AS doadora_nome,
    d.cpf AS doadora_cpf,
    d.foto AS doadora_foto,
    d.data_nascimento AS doadora_data_nascimento,
    d.email AS doadora_email,
    d.is_validado AS doadora_is_validado,
    t.numero AS doadora_telefone,
    en.logradouro AS doadora_logradouro,
    en.numero AS doadora_numero,
    en.complemento AS doadora_complemento,
    en.bairro AS doadora_bairro,
    en.cep AS doadora_cep,
    ci.nome AS doadora_cidade,
    es.sigla AS doadora_estado,
    (TIMESTAMP(ch.dia, ch.horario) >= NOW()) AS is_proximo
FROM tbl_cadastro_horario ch
INNER JOIN tbl_etapa e ON e.id = ch.id_etapa
INNER JOIN tbl_jornada j ON j.id = e.id_jornada
LEFT JOIN tbl_agendamento ag ON ag.id_cadastro_horario = ch.id
LEFT JOIN tbl_status_agendamento sa ON sa.id = ag.id_status_agendamento
LEFT JOIN tbl_jornada_doacao jd ON jd.id = ag.id_jornada_doacao
LEFT JOIN tbl_doadora d ON d.id = jd.id_doadora
LEFT JOIN tbl_telefone t ON t.id = d.id_telefone
LEFT JOIN tbl_endereco en ON en.id = d.id_endereco
LEFT JOIN tbl_cidade ci ON ci.id = en.id_cidade
LEFT JOIN tbl_estado es ON es.id = ci.id_estado
WHERE NOT EXISTS (
    SELECT 1
    FROM tbl_agendamento ag2
    INNER JOIN tbl_jornada_doacao jd2 ON jd2.id = ag2.id_jornada_doacao
    WHERE ag2.id_cadastro_horario = ch.id
      AND jd2.encerrado = TRUE
)
ORDER BY ch.dia, ch.horario;
