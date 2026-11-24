/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento , manipulação de dados para realizar o CRUD de campanha
 * Data: 09/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

//Import de configurações do arquivo de mensagens do projeto
const configMessages = require("../module/configMessage.js")

const campanhaDAO = require("../../model/DAO/campanha.js")



const validarDados = async function (campanha) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    const regexData = /^\d{4}-\d{2}-\d{2}$/

    if (campanha == undefined || campanha == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[CAMPANHA] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.titulo == undefined || campanha.titulo == "" || campanha.titulo == null || campanha.titulo.length > 100) {
        customMessage.ERROR_BAD_REQUEST.field = "[TITULO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.descricao == undefined || campanha.descricao == "" || campanha.descricao == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[DESCRICAO] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.foto != undefined && campanha.foto != null && campanha.foto != "" && campanha.foto.length > 255) {
        // Foto é opcional: só valida se vier preenchida
        customMessage.ERROR_BAD_REQUEST.field = "[FOTO] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.data_inicio == undefined || campanha.data_inicio == "" || campanha.data_inicio == null || !regexData.test(campanha.data_inicio) || isNaN(new Date(campanha.data_inicio))) {
        customMessage.ERROR_BAD_REQUEST.field = "[DATA_INICIO] INVÁLIDA (formato AAAA-MM-DD)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.data_fim == undefined || campanha.data_fim == "" || campanha.data_fim == null || !regexData.test(campanha.data_fim) || isNaN(new Date(campanha.data_fim))) {
        customMessage.ERROR_BAD_REQUEST.field = "[DATA_FIM] INVÁLIDA (formato AAAA-MM-DD)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.data_fim < campanha.data_inicio) {
        customMessage.ERROR_BAD_REQUEST.field = "[DATA_FIM] DEVE SER IGUAL OU POSTERIOR À DATA_INICIO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.is_ativo == undefined || campanha.is_ativo == null || typeof campanha.is_ativo != "boolean") {
        customMessage.ERROR_BAD_REQUEST.field = "[IS_ATIVO] INVÁLIDO (deve ser true ou false)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.id_instituicao == undefined || campanha.id_instituicao == "" || campanha.id_instituicao == null || isNaN(campanha.id_instituicao) || campanha.id_instituicao <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (campanha.id_funcionario == undefined || campanha.id_funcionario == "" || campanha.id_funcionario == null || isNaN(campanha.id_funcionario) || campanha.id_funcionario <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_FUNCIONARIO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}


const inserirNovaCampanha = async function(campanha, contentType){
    
    let customMessage = JSON.parse(JSON.stringify(configMessages))
    try {
    
        if(String(contentType).toUpperCase() == "APPLICATION/JSON"){
            let validarDadosCampanha = await validarDados(campanha)
            if(!validarDadosCampanha){

                let result = await campanhaDAO.insertCampanha(await tratarDados(campanha))
                if(result){

                    campanha.id = result

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = campanha

                    return customMessage.DEFAULT_MESSAGE

                }else{
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL_CAMPANHA
                }
                
            }else{
                return validarDadosCampanha
            }
        }else{
            return customMessage.ERROR_CONTENT_TYPE
        }
        
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
    
}

const listarCampanha = async function() {
        // Cria uma cópia dos JSON do arquivo de configuração de mensagens 
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        // Chama a função do DAO para retornar a lista de campanhas do banco de dados
        let result = await campanhaDAO.selectAllCampanhas()
        //Validação para verificar se o DAO conseguiu processar o script do BD
        if(result){
            console.log(result)

            //Validação para verificar se o conteúdo do array tem dados de retorno
            // ou se esta vazio
            if(result.length > 0){

                //Manipulação dos dados da classificação
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.campanha = result

                return customMessage.DEFAULT_MESSAGE
            }else{
                return customMessage.ERROR_NOT_FOUND
            }
        }else{
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER 
    }
}

const buscarCampanhaById = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (id == undefined || id == "" || id == null || isNaN(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        } else {
            let result = await campanhaDAO.selectByIdCampanha(id)

            if (result) {
                if (result.length > 0) {
                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                    customMessage.DEFAULT_MESSAGE.response.campanha = result

                    return customMessage.DEFAULT_MESSAGE
                } else {
                    return customMessage.ERROR_NOT_FOUND
                }
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_CAMPANHA
            }
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarCampanha = async function (campanha, id, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {
            let resultBuscarCampanha = await buscarCampanhaById(id)

            if (resultBuscarCampanha.status) {
                let validar = await validarDados(campanha)

                if (!validar) {
                    campanha.id = Number(id)

                    let result = await campanhaDAO.updateCampanha(await tratarDados(campanha))

                    if (result) {
                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
                        customMessage.DEFAULT_MESSAGE.response = campanha

                        return customMessage.DEFAULT_MESSAGE
                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL_CAMPANHA
                    }
                } else {
                    return validar
                }
            } else {
                return resultBuscarCampanha
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const deletarCampanha = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let resultBuscarCampanha = await buscarCampanhaById(id)

        if (resultBuscarCampanha.status) {
            let result = await campanhaDAO.deleteCampanha(id)

            if (result) {
                return customMessage.SUCCESS_DELETED_ITEM
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_CAMPANHA
            }
        } else {
            return resultBuscarCampanha
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const tratarDados = async function (campanha) {

    campanha.titulo = campanha.titulo.replaceAll("'", "")

    campanha.descricao = campanha.descricao.replaceAll("'", "")

    campanha.foto = campanha.foto ? campanha.foto.replaceAll("'", "") : null

    return campanha
}

module.exports = {
    inserirNovaCampanha,
    listarCampanha,
    buscarCampanhaById,
    atualizarCampanha,
    deletarCampanha
}