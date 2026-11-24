DELIMITER $$

CREATE PROCEDURE procdoadorainstituicao (
    IN p_id_instituicao INT
)
BEGIN
    # Instituicao existe?
    IF NOT EXISTS (SELECT 1 FROM tbl_instituicao WHERE id = p_id_instituicao) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: instituicao nao encontrada.';
    END IF;

    SELECT
        200 AS codigo,
        'Doadoras encontradas com sucesso' AS mensagem,
        COALESCE(JSON_ARRAYAGG(
            JSON_OBJECT(
                # DADOS COMPLETOS DA DOADORA
                'id',              d.id,
                'nome',            d.nome,
                'cpf',             d.cpf,
                'foto',            d.foto,
                'data_nascimento', d.data_nascimento,
                'email',           d.email,
                'is_validado',     d.is_validado,
                'telefone',        t.numero,
                'endereco', JSON_OBJECT(
                    'logradouro',  en.logradouro,
                    'cep',         en.cep,
                    'bairro',      en.bairro,
                    'numero',      en.numero,
                    'complemento', en.complemento,
                    'latitude',    en.latitude,
                    'longitude',   en.longitude,
                    'cidade',      c.nome,
                    'estado',      es.sigla
                ),

                # JORNADA EM QUE ELA ESTA
                'jornada', JSON_OBJECT(
                    'id',        j.id,
                    'nome',      j.nome,
                    'descricao', j.descricao,

                    # NUMERO DE ETAPAS FEITAS
                    'total_etapas_feitas', (
                        SELECT COUNT(DISTINCT jd.id_etapa)
                        FROM tbl_jornada_doacao jd
                        WHERE jd.id_doadora = dj.id_doadora
                          AND jd.id_jornada = dj.id_jornada
                          AND jd.encerrado  = FALSE
                    ),

                    # NUMERO DE ETAPAS TOTAL DA JORNADA
                    'total_etapas', (
                        SELECT COUNT(*)
                        FROM tbl_etapa et
                        WHERE et.id_jornada = dj.id_jornada
                    ),

                    # ETAPAS QUE ELA JA FEZ (com documentos e agendamentos)
                    'etapas_feitas', COALESCE((
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'id_jornada_doacao', jd.id,
                                'id_etapa',          e.id,
                                'titulo',            e.titulo,
                                'ordem',             e.ordem,
                                'ciclo',             jd.ciclo,
                                'data_conclusao',    jd.data_conclusao,

                                'documentos', COALESCE((
                                    SELECT JSON_ARRAYAGG(
                                        JSON_OBJECT(
                                            'id',            dd.id,
                                            'documento',     dd.documento,
                                            'motivo_recusa', dd.motivo_recusa
                                        )
                                    )
                                    FROM tbl_documento_doadora dd
                                    WHERE dd.id_jornada_doacao = jd.id
                                ), JSON_ARRAY()),

                                'agendamentos', COALESCE((
                                    SELECT JSON_ARRAYAGG(
                                        JSON_OBJECT(
                                            'id',      a.id,
                                            'dia',     ch.dia,
                                            'horario', ch.horario,
                                            'status',  s.status
                                        )
                                    )
                                    FROM tbl_agendamento a
                                    JOIN tbl_cadastro_horario ch ON ch.id = a.id_cadastro_horario
                                    JOIN tbl_status_agendamento s ON s.id = a.id_status_agendamento
                                    WHERE a.id_jornada_doacao = jd.id
                                ), JSON_ARRAY())
                            )
                        )
                        FROM tbl_jornada_doacao jd
                        JOIN tbl_etapa e ON e.id = jd.id_etapa
                        WHERE jd.id_doadora = dj.id_doadora
                          AND jd.id_jornada = dj.id_jornada
                          AND jd.encerrado  = FALSE
                    ), JSON_ARRAY()),

                    # ETAPAS QUE FALTAM (da jornada, sem registro da doadora)
                    'etapas_faltantes', COALESCE((
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'id_etapa',       ef.id,
                                'titulo',         ef.titulo,
                                'descricao',      ef.descricao,
                                'ordem',          ef.ordem,
                                'is_obrigatorio', ef.is_obrigatorio,
                                'is_agendavel',   ef.is_agendavel
                            )
                        )
                        FROM tbl_etapa ef
                        WHERE ef.id_jornada = dj.id_jornada
                          AND NOT EXISTS (
                              SELECT 1
                              FROM tbl_jornada_doacao jx
                              WHERE jx.id_doadora = dj.id_doadora
                                AND jx.id_etapa   = ef.id
                                AND jx.encerrado  = FALSE
                          )
                    ), JSON_ARRAY())
                )
            )
        ), JSON_ARRAY()) AS doadoras

    FROM (
        SELECT DISTINCT id_doadora, id_jornada
        FROM tbl_jornada_doacao
        WHERE id_instituicao = p_id_instituicao
          AND encerrado = FALSE
    ) dj
    JOIN tbl_doadora d   ON d.id  = dj.id_doadora
    JOIN tbl_jornada j   ON j.id  = dj.id_jornada
    JOIN tbl_telefone t  ON t.id  = d.id_telefone
    JOIN tbl_endereco en ON en.id = d.id_endereco
    JOIN tbl_cidade c    ON c.id  = en.id_cidade
    JOIN tbl_estado es   ON es.id = c.id_estado;
END$$

DELIMITER ;
