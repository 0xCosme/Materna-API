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



const insertFuncionario = async function (funcionario) {
    try {
        const sql = `
            CALL proccadastrarfuncionario(
                ?, ?, ?, ?, ?, ?, ?, ?, ?
            )
        `;

        const valores = [
            funcionario.nome,
            funcionario.cpf,
            funcionario.data_nascimento,
            funcionario.email,
            funcionario.adm,
            funcionario.senha,
            funcionario.sal,
            funcionario.telefone,
            funcionario.id_instituicao
        ];

        const [resultado] = await knexConection.raw(sql, valores);

        return resultado[0][0].id_funcionario;

    } catch (error) {
        console.error('Erro ao inserir funcionário:', error);
        return false;
    }
};



const selectAllFuncionarios = async function () {
    try {
        let sql = `
            select func.*, tel.numero as telefone
            from tbl_funcionario as func
            inner join tbl_telefone tel on func.id_telefone = tel.id
            order by func.id desc
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

const selectFuncionariosByInstituicao = async function (idInstituicao) {
    try {
        const sql = `
            select func.*, tel.numero as telefone
            from tbl_funcionario as func
            inner join tbl_telefone as tel on func.id_telefone = tel.id
            where func.id_instituicao = ${idInstituicao}
            order by func.id desc
        `

        const resultado = await knexConection.raw(sql)
        return resultado[0]
    } catch (error) {
        console.error('Erro ao buscar funcionários por instituição:', error)
        return false
    }
}

const selectByIdFuncionario = async function (id) {
    try {
        let sql = `
            select func.*, tel.numero as telefone
            from tbl_funcionario as func
            inner join tbl_telefone tel on func.id_telefone = tel.id
            where func.id = ${id}
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

const selectByEmail = async function (email) {
    try {
        const sql = `
            select id, nome, email, senha, id_instituicao
            from tbl_funcionario
            where email = ?
            limit 1
        `
        const [resultado] = await knexConection.raw(sql, [email])
        return resultado
    } catch (error) {
        console.error('Erro ao buscar funcionário por email:', error)
        return false
    }
}

const updateFuncionario = async function (funcionario) {
    try {
        let sql = `update tbl_funcionario set 
    nome = '${funcionario.nome}',
    cpf = '${funcionario.cpf}',
    data_nascimento = '${funcionario.data_nascimento}',
    email = '${funcionario.email}',
    adm = ${funcionario.adm},
    senha = '${funcionario.senha}',
    sal = '${funcionario.sal}',
    id_instituicao = ${funcionario.id_instituicao}
    where id = ${funcionario.id};`

        let result = await knexConection.raw(sql)

        if (result) {
            let sqlTelefone = `update tbl_telefone set numero = '${funcionario.telefone}' where id = ${funcionario.id_telefone};`
            let resultTelefone = await knexConection.raw(sqlTelefone)

            if (resultTelefone)
                return true
            else
                return false
        } else {
            return false
        }
    } catch (error) {
        console.log(error)
        return false
    }
}

const deleteFuncionario = async function(id){
    try {
        let sqlBuscarTelefone = `SELECT id_telefone FROM tbl_funcionario WHERE id=${id};`
        let resultBuscarTelefone = await knexConection.raw(sqlBuscarTelefone)

        if (resultBuscarTelefone && resultBuscarTelefone[0] && resultBuscarTelefone[0].length > 0) {
            let idTelefone = resultBuscarTelefone[0][0].id_telefone

            let sqlDeleteFuncionario = ` DELETE FROM tbl_funcionario WHERE id=${id};`
            let resultDeleteFuncionario = await knexConection.raw(sqlDeleteFuncionario)

            if (resultDeleteFuncionario) {
                let sqlDeleteTelefone = `DELETE FROM tbl_telefone WHERE id=${idTelefone};`
                let resultDeleteTelefone = await knexConection.raw(sqlDeleteTelefone)

                if (resultDeleteTelefone)
                    return true
                else
                    return false
            } else {
                return false
            }
        } else {
            return false
        }
    } catch (error) {
        console.log(error)
        return false
    }
}

module.exports = {
    insertFuncionario,
    selectAllFuncionarios,
    selectFuncionariosByInstituicao,
    selectByIdFuncionario,
    selectByEmail,
    updateFuncionario,
    deleteFuncionario
}