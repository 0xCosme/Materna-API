// ajuste o require do knex igual ao que você já usa nos outros DAOs


const knex = require("knex");

// Import do arquivo de configuração para acesso ao banco de dados
const knexDatabaseConfig = require("../database_config/knexConfig.js");

// Criar a conexão com o BD MySQL conforme o arquivo de configuração
const knexConection = knex(knexDatabaseConfig.development);

const insertVinculoEtapaDoadora = async function (vinculo) {
    try {
        return await knexConection.transaction(async trx => {

            await trx.raw(
                "CALL procvincularetapadoadora(?, ?, ?, ?, @id)",
                [
                    vinculo.id_doadora,
                    vinculo.id_etapa,
                    vinculo.id_instituicao,
                    vinculo.id_jornada
                ]
            )

            const [rows] = await trx.raw(
                "SELECT @id AS id_jornada_doacao"
            )

            await trx.raw(`
                UPDATE tbl_jornada_doacao AS jd
                INNER JOIN tbl_etapa AS etapa ON etapa.id = jd.id_etapa
                SET jd.ciclo = 0
                WHERE jd.id = ?
                  AND etapa.is_repetivel = TRUE
            `, [rows[0].id_jornada_doacao])

            return {
                id_jornada_doacao: rows[0].id_jornada_doacao
            }
        })

    } catch (error) {

        if (error.sqlState == "45000") {
            return { mensagem: error.sqlMessage }
        }

        console.log(error)
        return false
    }
}

const updateDataConclusaoJornadaDoacao = async function (id, dataConclusao) {
    try {
        const [vinculos] = await knexConection.raw(`
            SELECT etapa.is_repetivel
            FROM tbl_jornada_doacao AS jd
            INNER JOIN tbl_etapa AS etapa ON etapa.id = jd.id_etapa
            WHERE jd.id = ?
        `, [id])

        if (vinculos.length === 0) {
            return { status: "nao_encontrado" }
        }
        if (vinculos[0].is_repetivel) {
            return { status: "etapa_repetivel" }
        }

        await knexConection.raw(`
            UPDATE tbl_jornada_doacao
            SET data_conclusao = ?
            WHERE id = ?
        `, [dataConclusao, id])
        return { status: "sucesso" }
    } catch (error) {
        console.error('Erro ao atualizar data de conclusão da jornada de doação:', error)
        return false
    }
}

const definirQuantidadeCiclosJornadaDoacao = async function (id, quantidadeCiclos) {
    try {
        return await knexConection.transaction(async trx => {
            const [vinculos] = await trx.raw(`
                SELECT jd.data_conclusao, jd.encerrado, etapa.is_repetivel
                FROM tbl_jornada_doacao AS jd
                INNER JOIN tbl_etapa AS etapa ON etapa.id = jd.id_etapa
                WHERE jd.id = ?
                FOR UPDATE
            `, [id])

            if (vinculos.length === 0) {
                return { status: "nao_encontrado" }
            }
            if (!vinculos[0].is_repetivel) {
                return { status: "etapa_nao_repetivel" }
            }
            if (vinculos[0].data_conclusao !== null || vinculos[0].encerrado) {
                return { status: "ja_iniciado" }
            }

            await trx.raw(`
                UPDATE tbl_jornada_doacao
                SET ciclo = ?
                WHERE id = ?
            `, [quantidadeCiclos, id])

            return { status: "sucesso", ciclo: quantidadeCiclos }
        })
    } catch (error) {
        console.error('Erro ao definir a quantidade de ciclos da jornada de doação:', error)
        return false
    }
}

const concluirCicloJornadaDoacao = async function (id) {
    try {
        const [vinculos] = await knexConection.raw(`
            SELECT jd.ciclo, jd.encerrado, etapa.is_repetivel
            FROM tbl_jornada_doacao AS jd
            INNER JOIN tbl_etapa AS etapa ON etapa.id = jd.id_etapa
            WHERE jd.id = ?
        `, [id])

        if (vinculos.length === 0) return { status: "nao_encontrado" }
        if (!vinculos[0].is_repetivel) return { status: "etapa_nao_repetivel" }
        if (vinculos[0].encerrado || Number(vinculos[0].ciclo) < 1) {
            return { status: "sem_ciclos" }
        }

        const [atualizacao] = await knexConection.raw(`
            UPDATE tbl_jornada_doacao
            SET encerrado = (ciclo = 1),
                ciclo = ciclo - 1,
                data_conclusao = CURRENT_DATE
            WHERE id = ? AND ciclo > 0 AND encerrado = FALSE
        `, [id])

        if (atualizacao.affectedRows === 0) return { status: "sem_ciclos" }

        return {
            status: "sucesso",
            id_jornada_doacao: id,
            ciclo: Number(vinculos[0].ciclo) - 1,
            encerrado: Number(vinculos[0].ciclo) === 1
        }
    } catch (error) {
        console.error("Erro ao concluir ciclo da jornada de doação:", error)
        return false
    }
}

const selectJornadasAtivasPorDoadora = async function (idDoadora) {
    try {
        const sql = `
            SELECT
                doad.id AS id_doadora,
                doad.nome AS nome_doadora,
                COALESCE((
                    SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'id', jornada.id,
                            'nome', jornada.nome,
                            'descricao', jornada.descricao,
                            'is_ativo', jornada.is_ativo,
                            'instituicao', JSON_OBJECT(
                                'id', instituicao.id,
                                'nome', instituicao.nome
                            ),
                            'etapas_iniciadas', (
                                SELECT COUNT(DISTINCT vinculo.id_etapa)
                                FROM tbl_jornada_doacao AS vinculo
                                WHERE vinculo.id_doadora = doad.id
                                  AND vinculo.id_jornada = jornada.id
                            ),
                            'total_etapas', (
                                SELECT COUNT(*)
                                FROM tbl_etapa AS total_etapa
                                WHERE total_etapa.id_jornada = jornada.id
                            ),
                            'etapas', COALESCE((
                                SELECT JSON_ARRAYAGG(
                                    JSON_OBJECT(
                                        'id', etapa.id,
                                        'titulo', etapa.titulo,
                                        'descricao', etapa.descricao,
                                        'ordem', etapa.ordem,
                                        'documento', etapa.documento,
                                        'is_repetivel', etapa.is_repetivel,
                                        'is_agendavel', etapa.is_agendavel,
                                        'is_obrigatorio', etapa.is_obrigatorio,
                                        'is_solicita_arquivo', etapa.is_solicita_arquivo,
                                        'is_precisa_aprovacao', etapa.is_precisa_aprovacao,
                                        'vinculos', COALESCE((
                                            SELECT JSON_ARRAYAGG(
                                                JSON_OBJECT(
                                                    'id', vinculo.id,
                                                    'ciclo', vinculo.ciclo,
                                                    'data_conclusao', vinculo.data_conclusao,
                                                    'encerrado', vinculo.encerrado,
                                                    'status', IF(
                                                        etapa.is_repetivel,
                                                        IF(vinculo.encerrado, 'concluida', 'em_andamento'),
                                                        IF(vinculo.data_conclusao IS NULL, 'em_andamento', 'concluida')
                                                    )
                                                )
                                            )
                                            FROM tbl_jornada_doacao AS vinculo
                                            WHERE vinculo.id_doadora = doad.id
                                              AND vinculo.id_jornada = jornada.id
                                              AND vinculo.id_etapa = etapa.id
                                        ), JSON_ARRAY())
                                    )
                                )
                                FROM tbl_etapa AS etapa
                                WHERE etapa.id_jornada = jornada.id
                            ), JSON_ARRAY())
                        )
                    )
                    FROM tbl_jornada AS jornada
                    INNER JOIN tbl_instituicao AS instituicao
                        ON instituicao.id = jornada.id_instituicao
                    WHERE EXISTS (
                        SELECT 1
                        FROM tbl_jornada_doacao AS jornada_ativa
                        WHERE jornada_ativa.id_doadora = doad.id
                          AND jornada_ativa.id_jornada = jornada.id
                          AND jornada_ativa.encerrado = FALSE
                    )
                ), JSON_ARRAY()) AS jornadas
            FROM tbl_doadora AS doad
            WHERE doad.id = ?
        `

        const [rows] = await knexConection.raw(sql, [idDoadora])
        if (rows.length === 0) {
            return []
        }

        const result = {
            id_doadora: rows[0].id_doadora,
            nome_doadora: rows[0].nome_doadora,
            jornadas: rows[0].jornadas
        }

        if (typeof result.jornadas === "string") {
            result.jornadas = JSON.parse(result.jornadas)
        }

        return result
    } catch (error) {
        console.error("Erro ao buscar jornadas ativas da doadora:", error)
        return false
    }
}

const cancelarJornadaDoacao = async function (idJornadaDoacao, idDoadora) {
    try {
        const resultado = await knexConection.transaction(async (trx) => {
            const [referencias] = await trx.raw(`
                SELECT id_jornada, id_instituicao
                FROM tbl_jornada_doacao
                WHERE id = ? AND id_doadora = ?
                FOR UPDATE
            `, [idJornadaDoacao, idDoadora]);

            if (referencias.length === 0) {
                return { status: "nao_encontrado" };
            }

            const referencia = referencias[0];

            await trx.raw(`
                UPDATE tbl_cadastro_horario AS ch
                INNER JOIN tbl_agendamento AS a
                    ON a.id_cadastro_horario = ch.id
                INNER JOIN tbl_jornada_doacao AS jd
                    ON a.id_jornada_doacao = jd.id
                SET ch.disponivel = true
                WHERE jd.id_doadora = ?
                  AND jd.id_jornada = ?
                  AND jd.id_instituicao = ?
                  AND jd.encerrado = false
            `, [idDoadora, referencia.id_jornada, referencia.id_instituicao]);

            const [atualizacao] = await trx.raw(`
                UPDATE tbl_jornada_doacao
                SET encerrado = true
                WHERE id_doadora = ?
                  AND id_jornada = ?
                  AND id_instituicao = ?
                  AND encerrado = false
            `, [idDoadora, referencia.id_jornada, referencia.id_instituicao]);

            return {
                status: "sucesso",
                registros_encerrados: atualizacao.affectedRows,
                id_jornada: referencia.id_jornada
            };
        });

        if (resultado.status !== "sucesso" || resultado.registros_encerrados === 0) {
            return false;
        }

        return {
            id_doadora: idDoadora,
            id_jornada: resultado.id_jornada,
            registros_encerrados: resultado.registros_encerrados
        };

    } catch (error) {
        console.error('Erro ao cancelar jornada:', error);
        throw error;
    }
};

module.exports = {
    insertVinculoEtapaDoadora,
    updateDataConclusaoJornadaDoacao,
    definirQuantidadeCiclosJornadaDoacao,
    concluirCicloJornadaDoacao,
    selectJornadasAtivasPorDoadora,
    cancelarJornadaDoacao
}