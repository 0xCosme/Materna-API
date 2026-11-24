/**
 * Objetivo: Arquivo responsável pelo CRUD de agendamento do Materna
 * MYSQL
 * Data: 30/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

const knex = require("knex");
const knexDatabaseConfig = require("../database_config/knexConfig.js");
const knexConection = knex(knexDatabaseConfig.development);

const insertAgendamento = async function (agendamento) {
    try {

        const idAgendamento = await knexConection.transaction(async trx => {

            await trx.raw("CALL procagendar(?, ?, ?, @id)", [
                agendamento.id_cadastro_horario,
                agendamento.id_jornada_doacao,
                agendamento.id_status_agendamento
            ])

            const [rows] = await trx.raw("SELECT @id AS id_agendamento")

            return rows[0].id_agendamento
        })

        return idAgendamento

    } catch (error) {
        console.error('Erro ao inserir agendamento:', error)

        return {
            erro: true,
            sqlState: error.sqlState,
            mensagem: error.sqlMessage || error.message
        }
    }
}

const updateAgendamento = async function (idAgendamento, idStatus, idDoadora = null) {
    try {
        await knexConection.raw("CALL procatualizaragendamento(?, ?, ?)", [
            idAgendamento,
            idStatus,
            idDoadora
        ])

        return true

    } catch (error) {
        console.error('Erro ao atualizar agendamento:', error)

        return {
            erro: true,
            sqlState: error.sqlState,
            mensagem: error.sqlMessage || error.message
        }
    }
}

const selectAllAgendamentos = async function (idInstituicao = null) {
    try {

        const sql = `
            SELECT
                ag.id AS id_agendamento,
                ch.dia AS data_agendamento,
                ch.horario,
                d.nome AS nome_doadora,
                et.titulo AS tipo_atendimento,
                sa.status AS status_agendamento,
                inst.id AS id_instituicao,
                inst.nome AS nome_instituicao,
                endereco.logradouro,
                endereco.numero,
                endereco.complemento,
                endereco.bairro,
                endereco.cep,
                cidade.nome AS cidade,
                estado.sigla AS sigla_estado,
                endereco.latitude,
                endereco.longitude,
                (
                    SELECT tel.numero
                    FROM tbl_telefone_instituicao AS relacao_telefone
                    INNER JOIN tbl_telefone AS tel
                        ON relacao_telefone.id_telefone = tel.id
                    WHERE relacao_telefone.id_instituicao = inst.id
                    LIMIT 1
                ) AS telefone_instituicao

            FROM tbl_agendamento AS ag

            INNER JOIN tbl_cadastro_horario AS ch
                ON ag.id_cadastro_horario = ch.id

            INNER JOIN tbl_jornada_doacao AS jd
                ON ag.id_jornada_doacao = jd.id

            INNER JOIN tbl_doadora AS d
                ON jd.id_doadora = d.id

            INNER JOIN tbl_etapa AS et
                ON jd.id_etapa = et.id

            INNER JOIN tbl_jornada AS j
                ON et.id_jornada = j.id

            INNER JOIN tbl_instituicao AS inst
                ON j.id_instituicao = inst.id

            INNER JOIN tbl_endereco AS endereco
                ON inst.id_endereco = endereco.id

            INNER JOIN tbl_cidade AS cidade
                ON endereco.id_cidade = cidade.id

            INNER JOIN tbl_estado AS estado
                ON cidade.id_estado = estado.id

            INNER JOIN tbl_status_agendamento AS sa
                ON ag.id_status_agendamento = sa.id

            ${idInstituicao === null ? "" : "WHERE j.id_instituicao = ?"}
            ORDER BY ch.dia ASC, ch.horario ASC;
        `;

        const [resultado] = await knexConection.raw(
            sql,
            idInstituicao === null ? [] : [idInstituicao]
        );

        return resultado;

    } catch (error) {
        console.error('Erro ao buscar agendamentos:', error);
        return false;
    }
};

const selectAgendamentosPorDoadora = async function (idDoadora) {
    try {
        let sql = `
            SELECT
                ag.id AS id_agendamento,
                ch.dia AS data_agendamento,
                ch.horario,
                d.nome AS nome_doadora,
                et.titulo AS tipo_atendimento,
                sa.status AS status_agendamento,
                inst.id AS id_instituicao,
                inst.nome AS nome_instituicao,
                endereco.logradouro,
                endereco.numero,
                endereco.complemento,
                endereco.bairro,
                endereco.cep,
                cidade.nome AS cidade,
                estado.sigla AS sigla_estado,
                endereco.latitude,
                endereco.longitude,
                (
                    SELECT tel.numero
                    FROM tbl_telefone_instituicao AS relacao_telefone
                    INNER JOIN tbl_telefone AS tel
                        ON relacao_telefone.id_telefone = tel.id
                    WHERE relacao_telefone.id_instituicao = inst.id
                    LIMIT 1
                ) AS telefone_instituicao
            FROM tbl_agendamento AS ag
            INNER JOIN tbl_cadastro_horario AS ch
                ON ag.id_cadastro_horario = ch.id
            INNER JOIN tbl_jornada_doacao AS jd
                ON ag.id_jornada_doacao = jd.id
            INNER JOIN tbl_doadora AS d
                ON jd.id_doadora = d.id
            INNER JOIN tbl_etapa AS et
                ON jd.id_etapa = et.id
            INNER JOIN tbl_jornada AS j
                ON et.id_jornada = j.id
            INNER JOIN tbl_instituicao AS inst
                ON j.id_instituicao = inst.id
            INNER JOIN tbl_endereco AS endereco
                ON inst.id_endereco = endereco.id
            INNER JOIN tbl_cidade AS cidade
                ON endereco.id_cidade = cidade.id
            INNER JOIN tbl_estado AS estado
                ON cidade.id_estado = estado.id
            INNER JOIN tbl_status_agendamento AS sa
                ON ag.id_status_agendamento = sa.id
            WHERE d.id = ?
            ORDER BY ch.dia ASC, ch.horario ASC
        `

        let result = await knexConection.raw(sql, [idDoadora])

        if (Array.isArray(result)) {
            return result[0]
        } else {
            return false
        }
    } catch (error) {
        return false
    }
}


module.exports = {
    insertAgendamento,
    updateAgendamento,
    selectAllAgendamentos,
    selectAgendamentosPorDoadora
}
