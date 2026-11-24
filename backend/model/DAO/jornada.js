/**
 * Objetivo: Arquivo responsável pelo CRUD de doadora do Materna
 * MYSQL
 * Data: 15/04/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

// Faz o import da biblioteca para manipular dados no banco de dados MySQL
const knex = require("knex");

// Import do arquivo de configuração para acesso ao banco de dados
const knexDatabaseConfig = require("../database_config/knexConfig.js");

// Criar a conexão com o BD MySQL conforme o arquivo de configuração
const knexConection = knex(knexDatabaseConfig.development);


const insertJornada = async function (jornada) {

    try {

        const sql = `CALL proccadastrarjornada(?, ?, ?, ?, ?, @codigo)`

        const valores = [
            jornada.is_ativo,
            jornada.nome,
            jornada.descricao,
            jornada.id_instituicao,
            JSON.stringify(jornada.etapas)
        ]

        const [resultado] = await knexConection.raw(sql, valores)

        return {
            codigo: resultado[0][0].codigo,
            mensagem: resultado[0][0].mensagem,
            jornada: resultado[0][0],
            etapas: resultado[1]
        }

    } catch (error) {
        console.error('Erro ao inserir jornada:', error)
        return false
    }
}

const selectJornadasPorInstituicao = async function (idInstituicao) {
    try {
        let sql = `
            SELECT *
            FROM tbl_jornada
            WHERE id_instituicao = ?
            ORDER BY id DESC
        `

        let result = await knexConection.raw(sql, [idInstituicao])

        if (Array.isArray(result)) {
            return result[0]
        } else {
            return false
        }
    } catch (error) {
        return false
    }
}

const updateStatusJornada = async function (id, isAtivo, idInstituicao) {
    try {
        let sql = `
            UPDATE tbl_jornada
            SET is_ativo = ?
            WHERE id = ? AND id_instituicao = ?
        `

        const [resultado] = await knexConection.raw(sql, [isAtivo, id, idInstituicao])

        if (resultado.affectedRows === 0) {
            const [jornadas] = await knexConection.raw(
                'SELECT id FROM tbl_jornada WHERE id = ? AND id_instituicao = ?',
                [id, idInstituicao]
            )

            if (jornadas.length === 0) {
                return false
            }
        }

        if (!isAtivo) {
            await knexConection.raw(
                `UPDATE tbl_agendamento AS ag
                 INNER JOIN tbl_jornada_doacao AS jd
                     ON jd.id = ag.id_jornada_doacao
                 SET ag.id_status_agendamento = 4
                 WHERE jd.id_jornada = ?
                   AND ag.id_status_agendamento IN (1, 2)`,
                [id]
            )
        }

        await knexConection.raw(
            `UPDATE tbl_cadastro_horario AS ch
             INNER JOIN tbl_etapa AS e
                 ON e.id = ch.id_etapa
             SET ch.disponivel = ?
             WHERE e.id_jornada = ?`,
            [isAtivo, id]
        )

        return true
    } catch (error) {
        console.error('Erro ao atualizar status da jornada:', error)
        return false
    }
}

const deleteJornada = async function (id, idInstituicao) {
    try {
        const [jornadas] = await knexConection.raw(
            'SELECT id FROM tbl_jornada WHERE id = ? AND id_instituicao = ?',
            [id, idInstituicao]
        )

        if (jornadas.length === 0) {
            return null
        }

        const [vinculos] = await knexConection.raw(
            'SELECT id FROM tbl_jornada_doacao WHERE id_jornada = ? LIMIT 1',
            [id]
        )

        if (vinculos.length > 0) {
            return { conflito: true }
        }

        await knexConection.transaction(async trx => {
            await trx.raw(
                `DELETE ch
                 FROM tbl_cadastro_horario AS ch
                 INNER JOIN tbl_etapa AS e
                     ON e.id = ch.id_etapa
                 WHERE e.id_jornada = ?`,
                [id]
            )

            await trx.raw(
                'DELETE FROM tbl_etapa WHERE id_jornada = ?',
                [id]
            )

            await trx.raw(
                'DELETE FROM tbl_jornada WHERE id = ? AND id_instituicao = ?',
                [id, idInstituicao]
            )
        })

        return true
    } catch (error) {
        console.error('Erro ao excluir jornada:', error)
        return false
    }
}


module.exports = {
    insertJornada,
    selectJornadasPorInstituicao,
    updateStatusJornada,
    deleteJornada
}