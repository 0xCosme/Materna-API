/**
 * Objetivo: Controller do telefone (cadastro, atualização e exclusão; o telefone vem no JSON da doadora/funcionário)
 * Data: 06/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

const configMessages = require("../modulo/configMessage.js")

const telefoneDAO = require("../../model/DAO/telefone/telefone.js")


const validarDados = async function(telefone){
    let customMessage = JSON.parse(JSON.stringify(configMessages))

       if( telefone == undefined || telefone == null || telefone.numero == undefined || telefone.numero == "" || telefone.numero == null || telefone.numero.length > 25){
           customMessage.ERROR_BAD_REQUEST.field = "[NUMERO] INVÁLIDO"
           return customMessage.ERROR_BAD_REQUEST
       } else {
           return false
       }
}





const inserirTelefone = async function(telefone, contentType){

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if(String(contentType).toUpperCase() == "APPLICATION/JSON"){

            let validacao = await validarDados(telefone)

            if(validacao){
                return validacao
            }else{

                let result = await telefoneDAO.insertTelefone(await(tratarDados(telefone)))


                if(result){ // 201

                    telefone.id = result

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = telefone

                    return customMessage.DEFAULT_MESSAGE
                } else{
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL_TELEFONE
                }
            }
        }else{
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }

}

const buscarTelefone = async function(id) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if(id == undefined || id == "" || id == null || isNaN(id) || id < 1 ){
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        } else {

            let result = await telefoneDAO.selectTelefoneById(id)

            if(result){

                if(result.length > 0){
                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status

                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code

                    customMessage.DEFAULT_MESSAGE.response.telefone = result

                    return customMessage.DEFAULT_MESSAGE
                }else{
                    return customMessage.ERROR_NOT_FOUND
                }
            }else{
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_TELEFONE
            }
        }
    } catch (error) {
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}


const atualizarTelefone = async function(telefone, id , contentType){
    let customMessage = JSON.parse(JSON.stringify(configMessages))


    try {
        if(String(contentType).toUpperCase() == "APPLICATION/JSON"){

            let resultBuscarTelefone = await buscarTelefone(id)

            if(resultBuscarTelefone.status){

                let validar = await validarDados(telefone)

                if(!validar){

                    telefone.id = Number(id)

                    let result = await telefoneDAO.updateTelefone(await tratarDados(telefone))

                    if(result){
                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status

                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code

                        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message

                        customMessage.DEFAULT_MESSAGE.response = telefone

                        return customMessage.DEFAULT_MESSAGE
                    }else{

                        return customMessage.ERROR_INTERNAL_SERVER_MODEL_TELEFONE
                    }
                }else{
                    return validar
                }
            }else{
                return resultBuscarTelefone
            }
        }else{
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {

        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}


const deletarTelefone = async function(id){
    let customMessage = JSON.parse(JSON.stringify(configMessages))


    try {

        let resultBuscarTelefone = await buscarTelefone(id)

        if(resultBuscarTelefone.status){


            let result = await telefoneDAO.deleteTelefone(id)


            if(result){
                return customMessage.SUCCESS_DELETED_ITEM
            }else{
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_TELEFONE
            }

        }else{
            return resultBuscarTelefone
        }

    } catch (error) {
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}





const tratarDados = async function (telefone) {

    telefone.numero = String(telefone.numero).replaceAll("'", "")

    return telefone

}

module.exports = {
    inserirTelefone,
    atualizarTelefone,
    deletarTelefone
}