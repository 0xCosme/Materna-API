/**
 * Objetivo: Arquivo responsável pelo CRUD de campanha do Materna
 * MYSQL
 * Data: 09/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

// Faz o import da biblioteca para manipular dados no banco de dados MySQL
const knex = require("knex");

// Import do arquivo de configuração para acesso ao banco de dados
const knexDatabaseConfig = require("../database_config/knexConfig.js");

// Criar a conexão com o BD MySQL conforme o arquivo de configuração
const knexConection = knex(knexDatabaseConfig.development);




// Função para inserir uma nova campanha no banco de dados
 

const insertCampanha = async function (campanha) {

    try {

        const sql = `
            CALL proccadastrarcampanha(
                ?, ?, ?, ?, ?, ?, ?, ?
            )
        `;

        const valores = [
            campanha.titulo,
            campanha.descricao,
            campanha.foto ?? null,
            campanha.data_inicio,
            campanha.data_fim,
            campanha.is_ativo,
            campanha.id_instituicao,
            campanha.id_funcionario
        ];

        const [resultado] = await knexConection.raw(sql, valores);

        return resultado[0][0].id_campanha;

    } catch (error) {

        console.error('Erro ao inserir campanha:', error);

        return false;

    }
};

const selectAllCampanhas = async function () {
    try {
        // Script SQL para listar todos as campanhas cadastradas
        let sql = "select * from tbl_campanha order by id desc"

        //Executa no banco de dados o script e guarda o retorno do banco

        //Pode ser um erro (false) ou um array com os dados
        let result = await knexConection.raw(sql)

        // Validação para verificar se o retorno do BD é um Array ou boolean (false)
        if(Array.isArray(result)){
            return result[0] // retorna somente o indice com a lista de usuários
        } else{
            // Return false do banco de dados
            return false
        }
    } catch (error) {
        // return false do JavaScritp
       return false 
    }
}

const selectByIdCampanha = async function (id) {
    try {
        
        let sql = `SELECT * FROM tbl_campanha
        WHERE id = ${id};`

        let result = await knexConection.raw(sql)


        if(Array.isArray(result))
            return result[0]
        else
            return false

    } catch (error) {

        return false

    }
}


const updateCampanha = async function (campanha) {
    try {
        let sql = `update tbl_campanha set 
    titulo = '${campanha.titulo}',
    descricao = '${campanha.descricao}',
    foto = '${campanha.foto}',
    data_inicio = '${campanha.data_inicio}',
    data_fim = '${campanha.data_fim}',
    is_ativo = ${campanha.is_ativo},
    id_instituicao = ${campanha.id_instituicao},
    id_funcionario = ${campanha.id_funcionario}
    where id = ${campanha.id};`

    let result = await knexConection.raw(sql)

    if(result)
        return true
    else
        return false

    } catch (error) {
       
        return false
    }
}

const deleteCampanha = async function(id){
    try {
        let sql = `DELETE FROM tbl_campanha WHERE id=${id};`

        let result = await knexConection.raw(sql)
        if(result)
            return true
        else 
            return false
    } catch (error) {
            return false
    }
}


module.exports = {
    insertCampanha,
    selectAllCampanhas,
    selectByIdCampanha,
    updateCampanha,
    deleteCampanha
}