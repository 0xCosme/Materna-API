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

// Função para inserir uma nova instituição no banco de dados
const insertInstituicao = async function (instituicao) {

    try {

        const sql = `
            CALL proccadastrarinstituicao(
                ?, ?, ?, ?, ?,
                ?,
                ?, ?, ?, ?, ?, ?, ?,
                ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?, ?, ?, ?, ?
            )
        `

        const valores = [
            instituicao.nome,
            instituicao.cnpj,
            instituicao.email,
            instituicao.foto ?? null,
            instituicao.id_coleta,
            instituicao.telefone,
            instituicao.logradouro,
            instituicao.cep,
            instituicao.bairro,
            instituicao.numero,
            instituicao.complemento,
            instituicao.latitude,
            instituicao.longitude,
            instituicao.cidade,
            instituicao.sigla_estado,
            ...instituicao.horarios.flatMap(h => [h.dia, h.abre, h.fecha]),
            instituicao.funcionario.nome,
            instituicao.funcionario.cpf,
            instituicao.funcionario.data_nascimento,
            instituicao.funcionario.email,
            instituicao.funcionario.senha,
            instituicao.funcionario.sal,
            instituicao.funcionario.telefone
        ]

        const [resultado] = await knexConection.raw(sql, valores)
        return resultado[0][0]

    } catch (error) {
        console.error('Erro ao inserir instituição:', error)
        return false
    }
}


const updateInstituicao = async function (id, instituicao) {

    try {

        const sql = `
            CALL procatualizarinstituicao(
                ?,
                ?, ?, ?, ?, ?,
                ?,
                ?, ?, ?, ?, ?, ?, ?,
                ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?,
                ?, ?, ?
            )
        `

        const valores = [
            id,
            instituicao.nome,
            instituicao.cnpj,
            instituicao.email,
            instituicao.foto ?? null,
            instituicao.id_coleta,
            instituicao.telefone,
            instituicao.logradouro,
            instituicao.cep,
            instituicao.bairro,
            instituicao.numero,
            instituicao.complemento,
            instituicao.latitude,
            instituicao.longitude,
            instituicao.cidade,
            instituicao.sigla_estado,
            ...instituicao.horarios.flatMap(h => [h.dia, h.abre, h.fecha])
        ]

        await knexConection.raw(sql, valores)
        return true

    } catch (error) {
        console.error('Erro ao atualizar instituição:', error)
        return false
    }
}


const selectAllInstituicoes = async function () {
    try {
        let sql = `
            select inst.*, tipo.tipo as tipo_coleta, tel.numero as telefone,
                   endereco.logradouro, endereco.cep, endereco.bairro,
                   endereco.numero, endereco.complemento,
                   endereco.latitude, endereco.longitude,
                   cidade.nome as cidade, estado.sigla as sigla_estado
            from tbl_instituicao as inst
            inner join tbl_tipo_coleta as tipo on inst.id_coleta = tipo.id
            inner join tbl_endereco as endereco on inst.id_endereco = endereco.id
            inner join tbl_cidade as cidade on endereco.id_cidade = cidade.id
            inner join tbl_estado as estado on cidade.id_estado = estado.id
            inner join tbl_telefone_instituicao as relacao on inst.id = relacao.id_instituicao
            inner join tbl_telefone as tel on relacao.id_telefone = tel.id
            order by inst.id desc
        `

        let result = await knexConection.raw(sql)

        if (Array.isArray(result)) {
            return result[0]
        } else {
            return false
        }
    } catch (error) {
        return false
    }
}

const selectByIdInstituicao = async function (id) {
    try {
        let sql = `
            select inst.*, tipo.tipo as tipo_coleta, tel.numero as telefone,
                   endereco.logradouro, endereco.cep, endereco.bairro,
                   endereco.numero, endereco.complemento,
                   endereco.latitude, endereco.longitude,
                   cidade.nome as cidade, estado.sigla as sigla_estado,

                   (select json_arrayagg(json_object(
                               'id',        jor.id,
                               'nome',      jor.nome,
                               'descricao', jor.descricao,
                               'is_ativo',  jor.is_ativo,
                               'etapas', (select json_arrayagg(json_object(
                                                      'id',                     eta.id,
                                                      'titulo',                 eta.titulo,
                                                      'descricao',              eta.descricao,
                                                      'ordem',                  eta.ordem,
                                                      'documento',              eta.documento,
                                                      'is_repetivel',           eta.is_repetivel,
                                                      'is_agendavel',           eta.is_agendavel,
                                                      'is_obrigatorio',         eta.is_obrigatorio,
                                                      'is_solicita_arquivo',    eta.is_solicita_arquivo,
                                                      'is_precisa_aprovacao',   eta.is_precisa_aprovacao,
                                                      'id_jornada',             eta.id_jornada))
                                          from tbl_etapa as eta
                                          where eta.id_jornada = jor.id)))
                    from tbl_jornada as jor
                    where jor.id_instituicao = inst.id
                   ) as jornadas

            from tbl_instituicao as inst
            inner join tbl_tipo_coleta as tipo on inst.id_coleta = tipo.id
            inner join tbl_endereco as endereco on inst.id_endereco = endereco.id
            inner join tbl_cidade as cidade on endereco.id_cidade = cidade.id
            inner join tbl_estado as estado on cidade.id_estado = estado.id
            inner join tbl_telefone_instituicao as relacao on inst.id = relacao.id_instituicao
            inner join tbl_telefone as tel on relacao.id_telefone = tel.id
            where inst.id = ?
        `

        let result = await knexConection.raw(sql, [id])

        if (Array.isArray(result)) {
            return result[0]
        } else {
            return false
        }
    } catch (error) {
        console.log(error)
        return false
    }
}

const selectDoadorasPorInstituicao = async function (idInstituicao) {
    try {
        const [resultado] = await knexConection.raw(
            "CALL procdoadorainstituicao(?)",
            [idInstituicao]
        )

        if (Array.isArray(resultado) && resultado[0] && resultado[0][0]) {
            return resultado[0][0]
        }

        return false
    } catch (error) {
        if (error.sqlState == "45000" &&
            error.sqlMessage == "Erro: instituicao nao encontrada.") {
            return null
        }

        console.error("Erro ao buscar doadoras da instituição:", error)
        return false
    }
}

// Retorna as instituições mais próximas de uma coordenada
const selectInstituicoesProximas = async function (latitude, longitude, limite) {
    try {
        let sql = `select
                        i.id,
                        i.nome,
                        i.foto,
                        e.logradouro,
                        e.numero,
                        e.bairro,
                        e.latitude,
                        e.longitude,
                        t.tipo as tipo_coleta,
                        round(
                            st_distance_sphere(
                                point(e.longitude, e.latitude),
                                point(?, ?)
                            ) / 1000, 1
                        ) as distancia_km
                    from tbl_instituicao i
                        inner join tbl_endereco e    on e.id = i.id_endereco
                        inner join tbl_tipo_coleta t on t.id = i.id_coleta
                    order by distancia_km asc
                    limit ?`

        // a ordem dos ? é: longitude, latitude, limite
        let result = await knexConection.raw(sql, [Number(longitude), Number(latitude), Number(limite)])

        // no MySQL o knex.raw devolve [linhas, campos]
        if (Array.isArray(result[0]))
            return result[0]
        else
            return false

    } catch (error) {
        console.log(error)
        return false
    }
}

module.exports = {
    insertInstituicao,
    updateInstituicao,
    selectAllInstituicoes,
    selectByIdInstituicao,
    selectInstituicoesProximas,
    selectDoadorasPorInstituicao
}