const knex = require("knex")
const knexDatabaseConfig = require("../database_config/knexConfig.js")

const knexConection = knex(knexDatabaseConfig.development)

const insertDocumentoDoadora = async function (documentoDoadora) {
    try {
        const sql = `
            INSERT INTO tbl_documento_doadora
                (documento, motivo_recusa, id_status_documento, id_jornada_doacao, id_doadora)
            SELECT
                ?,
                '',
                IF(etapa.is_precisa_aprovacao = 1, 1, 2),
                jornada_doacao.id,
                jornada_doacao.id_doadora
            FROM tbl_jornada_doacao AS jornada_doacao
            INNER JOIN tbl_etapa AS etapa
                ON etapa.id = jornada_doacao.id_etapa
            WHERE jornada_doacao.id = ?
              AND jornada_doacao.id_doadora = ?
        `

        const [result] = await knexConection.raw(sql, [
            documentoDoadora.documento,
            documentoDoadora.id_jornada_doacao,
            documentoDoadora.id_doadora
        ])

        if (result.affectedRows == 0) {
            return null
        }

        const [documento] = await knexConection.raw(
            "SELECT id_status_documento FROM tbl_documento_doadora WHERE id = ?",
            [result.insertId]
        )

        return {
            id_documento: result.insertId,
            id_status_documento: documento[0].id_status_documento
        }
    } catch (error) {
        console.error("Erro ao salvar documento da doadora:", error)
        return false
    }
}

const recusarDocumentoDoadora = async function (idDocumento, motivoRecusa) {
    try {
        await knexConection.raw(
            "CALL procrecusardocumentodoadora(?, ?)",
            [idDocumento, motivoRecusa]
        )

        return true
    } catch (error) {
        if (error.sqlState == "45000" &&
            error.sqlMessage == "Documento nao encontrado.") {
            return null
        }

        console.error("Erro ao recusar documento da doadora:", error)
        return false
    }
}

const aceitarDocumentoDoadora = async function (idDocumento) {
    try {
        await knexConection.raw(
            "CALL procaceitardocumentodoadora(?)",
            [idDocumento]
        )

        return true
    } catch (error) {
        if (error.sqlState == "45000" &&
            error.sqlMessage == "Documento nao encontrado.") {
            return null
        }

        console.error("Erro ao aceitar documento da doadora:", error)
        return false
    }
}

module.exports = {
    insertDocumentoDoadora,
    recusarDocumentoDoadora,
    aceitarDocumentoDoadora
}
