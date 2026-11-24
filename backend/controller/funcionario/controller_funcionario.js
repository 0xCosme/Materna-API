/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento , manipulação de dados para realizar o CRUD do responsável
 * Data: 09/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

const configMessages = require("../module/configMessage.js")

const funcionarioDAO = require("../../model/DAO/funcionario.js")

const bycript = require("bcrypt")
const { createJWT } = require("../../middleware/MiddlewareJWT.js")


// const doadoraDAO = require("../../model/DAO/doadora.js")

// {
//     "nome": "Maria Souza",
//     "cpf": "123.456.789-00",
//     "data_nascimento": "1990-05-20",
//     "email": "maria@esperanca.org",
//     "adm": true,
//     "senha": "senha_hash_aqui",
//     "sal": "sal_aleatorio_aqui",
//     "telefone": "(11) 98888-7777",
//     "id_instituicao": 1
//   }



const validarDados = async function (funcionario) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))
 
    // Regex auxiliares
    const regexCpf = /^\d{3}\.\d{3}\.\d{3}-\d{2}$/
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    const regexData = /^\d{4}-\d{2}-\d{2}$/
    const regexTelefone = /^\d{10,11}$/
 
    if (funcionario == undefined || funcionario == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[FUNCIONARIO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.nome == undefined || funcionario.nome == "" || funcionario.nome == null || funcionario.nome.length > 100) {
        customMessage.ERROR_BAD_REQUEST.field = "[NOME] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.cpf == undefined || funcionario.cpf == "" || funcionario.cpf == null || !regexCpf.test(funcionario.cpf)) {
        customMessage.ERROR_BAD_REQUEST.field = "[CPF] INVÁLIDO (formato 000.000.000-00)"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.data_nascimento == undefined || funcionario.data_nascimento == "" || funcionario.data_nascimento == null || !regexData.test(funcionario.data_nascimento) || isNaN(new Date(funcionario.data_nascimento))) {
        customMessage.ERROR_BAD_REQUEST.field = "[DATA_NASCIMENTO] INVÁLIDA (formato AAAA-MM-DD)"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.email == undefined || funcionario.email == "" || funcionario.email == null || !regexEmail.test(funcionario.email) || funcionario.email.length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[EMAIL] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (typeof funcionario.adm != "boolean") {
        customMessage.ERROR_BAD_REQUEST.field = "[ADM] INVÁLIDO (true ou false)"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.senha == undefined || funcionario.senha == "" || funcionario.senha == null || funcionario.senha.length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[SENHA] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.telefone == undefined || funcionario.telefone == "" || funcionario.telefone == null || !regexTelefone.test(funcionario.telefone)) {
        customMessage.ERROR_BAD_REQUEST.field = "[TELEFONE] INVÁLIDO (somente números, com DDD)"
        return customMessage.ERROR_BAD_REQUEST
 
    } else if (funcionario.id_instituicao == undefined || funcionario.id_instituicao == "" || funcionario.id_instituicao == null || isNaN(funcionario.id_instituicao) || funcionario.id_instituicao < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
 
    } else {
        return false
    }
}



const insertFuncionario = async function(funcionario, contentType){

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if(String(contentType).toUpperCase() == "APPLICATION/JSON"){

            let validarDadosFuncionario = await validarDados(funcionario)
            if(!validarDadosFuncionario){
                            
                funcionario.sal = await bycript.genSalt(10)
                funcionario.senha = await bycript.hash(funcionario.senha, funcionario.sal)

                let result = await funcionarioDAO.insertFuncionario(await tratarDados(funcionario))
                if(result){
                    

                    funcionario.id = result
                    
                    delete funcionario.sal
                    delete funcionario.senha

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = funcionario

                    return customMessage.DEFAULT_MESSAGE

                }else{
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
                }
                 
            }else{
                return validarDadosFuncionario
            }

        }else{
            return customMessage.ERROR_CONTENT_TYPE
        }
        
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
    
}

const login = async function (dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() != "APPLICATION/JSON" ||
            !dados || !dados.email || !dados.senha) {
            return customMessage.ERROR_BAD_REQUEST
        }

        const resultado = await funcionarioDAO.selectByEmail(dados.email)
        const funcionario = resultado && resultado[0]

        if (!funcionario || !(await bycript.compare(dados.senha, funcionario.senha))) {
            return customMessage.ERROR_UNAUTHORIZED
        }

        const token = await createJWT({
            id: funcionario.id,
            id_instituicao: funcionario.id_instituicao
        })

        customMessage.DEFAULT_MESSAGE.status = true
        customMessage.DEFAULT_MESSAGE.status_code = 200
        customMessage.DEFAULT_MESSAGE.response = { token }
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const listarFuncionario = async function () {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let result = await funcionarioDAO.selectAllFuncionarios()

        if (result) {
            if (result.length > 0) {
                for (let funcionario of result) {
                    delete funcionario.senha
                    delete funcionario.sal
                }

                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.funcionario = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_NOT_FOUND
            }
        } else {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarFuncionarioPorInstituicao = async function (idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (idInstituicao == undefined || idInstituicao == "" || idInstituicao == null || isNaN(idInstituicao) || idInstituicao < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await funcionarioDAO.selectFuncionariosByInstituicao(idInstituicao)

        if (result) {
            if (result.length > 0) {
                for (let funcionario of result) {
                    delete funcionario.senha
                    delete funcionario.sal
                }

                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.funcionario = result

                return customMessage.DEFAULT_MESSAGE
            }

            return customMessage.ERROR_NOT_FOUND
        }

        return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarFuncionarioById = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (id == undefined || id == "" || id == null || isNaN(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        } else {
            let result = await funcionarioDAO.selectByIdFuncionario(id)

            if (result) {
                if (result.length > 0) {
                    for (let funcionario of result) {
                        delete funcionario.senha
                        delete funcionario.sal
                    }

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                    customMessage.DEFAULT_MESSAGE.response.funcionario = result

                    return customMessage.DEFAULT_MESSAGE
                } else {
                    return customMessage.ERROR_NOT_FOUND
                }
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
            }
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarFuncionario = async function (funcionario, id, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {
            let resultBuscarFuncionario = await buscarFuncionarioById(id)

            if (resultBuscarFuncionario.status) {
                let validar = await validarDados(funcionario)

                if (!validar) {
                    let funcionarioAtual = resultBuscarFuncionario.response.funcionario[0]

                    funcionario.id = Number(id)
                    funcionario.id_telefone = funcionarioAtual.id_telefone

                    funcionario.sal = await bycript.genSalt(10)
                    funcionario.senha = await bycript.hash(funcionario.senha, funcionario.sal)

                    let result = await funcionarioDAO.updateFuncionario(await tratarDados(funcionario))

                    if (result) {
                        delete funcionario.senha
                        delete funcionario.sal

                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
                        customMessage.DEFAULT_MESSAGE.response = funcionario

                        return customMessage.DEFAULT_MESSAGE
                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
                    }
                } else {
                    return validar
                }
            } else {
                return resultBuscarFuncionario
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const deletarFuncionario = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let resultBuscarFuncionario = await buscarFuncionarioById(id)

        if (resultBuscarFuncionario.status) {
            let result = await funcionarioDAO.deleteFuncionario(id)

            if (result) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_DELETED_ITEM.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_DELETED_ITEM.status_code
                customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_DELETED_ITEM.message
                customMessage.DEFAULT_MESSAGE.response = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO
            }
        } else {
            return resultBuscarFuncionario
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const tratarDados = async function (funcionario) {

    funcionario.nome = funcionario.nome.replaceAll("'", "")

    funcionario.cpf = funcionario.cpf.replaceAll("'", "")

    funcionario.email = funcionario.email.replaceAll("'", "")

    funcionario.telefone = funcionario.telefone.replaceAll("'", "")

    return funcionario
}


module.exports = {
    insertFuncionario,
    listarFuncionario,
    buscarFuncionarioPorInstituicao,
    buscarFuncionarioById,
    atualizarFuncionario,
    deletarFuncionario,
    login
}