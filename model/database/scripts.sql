SELECT
    d.id AS id_doadora,
    d.nome AS doadora,

    i.id AS id_instituicao,
    i.nome AS banco_de_leite,

    j.id AS id_jornada,
    j.nome AS jornada,

    c.id AS id_ciclo,
    c.numero_ciclo,

    e.id AS id_etapa,
    e.titulo AS etapa,
    e.ordem,

    etc.data_conclusao,

    CASE
        WHEN etc.data_conclusao IS NOT NULL THEN 'CONCLUIDA'
        WHEN etc.data_conclusao IS NULL THEN 'ATUAL'
    END AS situacao

FROM tbl_doadora d

INNER JOIN tbl_ciclo c
    ON c.id_doadora = d.id

INNER JOIN tbl_jornada j
    ON j.id = c.id_jornada

INNER JOIN tbl_instituicao i
    ON i.id = j.id_instituicao

INNER JOIN tbl_etapa_ciclo etc
    ON etc.id_ciclo = c.id

INNER JOIN tbl_etapa e
    ON e.id = etc.id_etapa

WHERE d.id = 1

ORDER BY
    c.numero_ciclo,
    e.ordem;
