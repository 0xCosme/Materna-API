/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento , manipulação de dados para realizar o CRUD de doadoras
 * Data: 07/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

//Import de configurações do arquivo de mensagens do projeto
const configMessages = require("../module/configMessage.js")

const doadoraDAO = require("../../model/DAO/doadora.js")

const coordenadas = require("../../service/coordenadasService.js")

const bcrypt = require("bcrypt")
const otpService = require("../../service/otpService.js")
const { createJWT } = require("../../middleware/MiddlewareJWT.js")

const validarDados = async function (doadora) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    // Regex auxiliares
    const regexCpf = /^\d{3}\.\d{3}\.\d{3}-\d{2}$/
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    const regexData = /^\d{4}-\d{2}-\d{2}$/
    const regexCep = /^\d{5}-?\d{3}$/
    const regexTelefone = /^\d{10,11}$/

    if (doadora == undefined || doadora == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[DOADORA] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.nome == undefined || doadora.nome == "" || doadora.nome == null || doadora.nome.length > 100) {
        customMessage.ERROR_BAD_REQUEST.field = "[NOME] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.cpf == undefined || doadora.cpf == "" || doadora.cpf == null || !regexCpf.test(doadora.cpf)) {
        customMessage.ERROR_BAD_REQUEST.field = "[CPF] INVÁLIDO (formato 000.000.000-00)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.foto != undefined && doadora.foto != null && doadora.foto != "" && doadora.foto.length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[FOTO] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.data_nascimento == undefined || doadora.data_nascimento == "" || doadora.data_nascimento == null || !regexData.test(doadora.data_nascimento) || isNaN(new Date(doadora.data_nascimento))) {
        customMessage.ERROR_BAD_REQUEST.field = "[DATA_NASCIMENTO] INVÁLIDA (formato AAAA-MM-DD)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.email == undefined || doadora.email == "" || doadora.email == null || !regexEmail.test(doadora.email) || doadora.email.length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[EMAIL] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.senha == undefined || doadora.senha == "" || doadora.senha == null || doadora.senha.length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[SENHA] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.telefone == undefined || doadora.telefone == "" || doadora.telefone == null || !regexTelefone.test(doadora.telefone)) {
        customMessage.ERROR_BAD_REQUEST.field = "[TELEFONE] INVÁLIDO (somente números, com DDD)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.cep == undefined || doadora.cep == "" || doadora.cep == null || !regexCep.test(doadora.cep)) {
        customMessage.ERROR_BAD_REQUEST.field = "[CEP] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.sigla_estado == undefined || doadora.sigla_estado == "" || doadora.sigla_estado == null || doadora.sigla_estado.length > 3) {
        customMessage.ERROR_BAD_REQUEST.field = "[SIGLA_ESTADO] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.cidade == undefined || doadora.cidade == "" || doadora.cidade == null || doadora.cidade.length > 100) {
        customMessage.ERROR_BAD_REQUEST.field = "[CIDADE] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.logradouro == undefined || doadora.logradouro == "" || doadora.logradouro == null || doadora.logradouro.length > 100) {
        customMessage.ERROR_BAD_REQUEST.field = "[LOGRADOURO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.bairro == undefined || doadora.bairro == "" || doadora.bairro == null || doadora.bairro.length > 50) {
        customMessage.ERROR_BAD_REQUEST.field = "[BAIRRO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.numero == undefined || doadora.numero == "" || doadora.numero == null || isNaN(doadora.numero) || doadora.numero <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[NUMERO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (doadora.complemento != undefined && doadora.complemento != "" && doadora.complemento != null && doadora.complemento.length > 50) {
        // complemento é opcional: só valida se vier preenchido
        customMessage.ERROR_BAD_REQUEST.field = "[COMPLEMENTO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}

const validarDadosOtp = async function (dados) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (dados == undefined || dados == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[DADOS] INVÁLIDOS"
        return customMessage.ERROR_BAD_REQUEST

    } else if (dados.id_doadora == undefined || dados.id_doadora === "" || dados.id_doadora == null || isNaN(dados.id_doadora) || dados.id_doadora < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (dados.codigo == undefined || dados.codigo === "" || dados.codigo == null || !/^\d{6}$/.test(String(dados.codigo))) {
        customMessage.ERROR_BAD_REQUEST.field = "[CODIGO] INVÁLIDO (6 dígitos numéricos)"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}

const login = async function (dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() !== "APPLICATION/JSON" ||
            !dados || !dados.email || !dados.senha) {
            return customMessage.ERROR_BAD_REQUEST
        }

        const resultado = await doadoraDAO.selectByEmail(dados.email)
        const doadora = resultado && resultado[0]
        const senhaValida = doadora && await bcrypt.compare(dados.senha, doadora.senha)

        if (!doadora || !senhaValida) {
            return customMessage.ERROR_UNAUTHORIZED
        }

        const token = await createJWT(doadora.id)

        customMessage.DEFAULT_MESSAGE.status = true
        customMessage.DEFAULT_MESSAGE.status_code = 200
        customMessage.DEFAULT_MESSAGE.response = {
            token,
            doadora: {
                id: doadora.id,
                nome: doadora.nome,
                email: doadora.email,
                is_validado: doadora.is_validado
            }
        }
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarSenhaPorEmail = async function (dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() != "APPLICATION/JSON") {
            return customMessage.ERROR_CONTENT_TYPE
        }

        if (dados == undefined || dados == null ||
            typeof dados.email != "string" ||
            dados.email.trim() == "" ||
            typeof dados.senha != "string" ||
            dados.senha.length < 6) {
            customMessage.ERROR_BAD_REQUEST.field =
                "[EMAIL] E [SENHA] INVÁLIDOS"
            return customMessage.ERROR_BAD_REQUEST
        }

        const resultado = await doadoraDAO.selectByEmail(dados.email)

        if (!resultado || resultado.length == 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        const sal = await bcrypt.genSalt(10)
        const senha = await bcrypt.hash(dados.senha, sal)
        const result = await doadoraDAO.updateSenhaPorEmail(dados.email, senha, sal)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_DOADORA
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
        customMessage.DEFAULT_MESSAGE.response = {
            email: dados.email
        }

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const inserirNovaDoadora = async function (doadora, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let validar = await validarDados(doadora)

            if (validar) {
                return validar
            } else {

                let resultCoordenadas = await coordenadas.definirLatitudeLongitudePorCEP(doadora.cep)

                if (resultCoordenadas) {
                    doadora.latitude = Number(resultCoordenadas.latitude)
                    doadora.longitude = Number(resultCoordenadas.longitude)
                } else {
                    customMessage.ERROR_BAD_REQUEST.field = "[CEP] NÃO FOI POSSÍVEL LOCALIZAR AS COORDENADAS"
                    return customMessage.ERROR_BAD_REQUEST
                }

                doadora.sal = await bcrypt.genSalt(10)
                doadora.senha = await bcrypt.hash(doadora.senha, doadora.sal)
                

                const codigoOtp = otpService.generateOtp()
                let result = await doadoraDAO.insertDoadora(
                    await tratarDados(doadora),
                    codigoOtp
                )


                if (result) {

                    doadora.id = result
                    
                    delete doadora.sal
                    delete doadora.senha

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = doadora

                    return customMessage.DEFAULT_MESSAGE

                } else {
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL
                }
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const listarDoadora = async function () {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let result = await doadoraDAO.selectAllDoadora()

        if (result) {

            if (result.length > 0) {

                // Remove a senha de todas as doadoras antes de retornar
                for (let doadora of result) {
                    delete doadora.senha
                    delete doadora.sal
                }

                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.doadora = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_NOT_FOUND
            }
        } else {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER //500 (controller)
    }
}

const atualizarDoadora = async function (doadora, id, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let resultBuscarDoadora = await buscarDoadoraById(id)

            if (resultBuscarDoadora.status) {
                let validar = await validarDados(doadora)

                if (!validar) {
                    let resultCoordenadas = await coordenadas.definirLatitudeLongitudePorCEP(doadora.cep)

                    if (!resultCoordenadas) {
                        customMessage.ERROR_BAD_REQUEST.field = "[CEP] NÃO FOI POSSÍVEL LOCALIZAR AS COORDENADAS"
                        return customMessage.ERROR_BAD_REQUEST
                    }

                    doadora.latitude = Number(resultCoordenadas.latitude)
                    doadora.longitude = Number(resultCoordenadas.longitude)
                    doadora.id = Number(id)
                    doadora.sal = await bcrypt.genSalt(10)
                    doadora.senha = await bcrypt.hash(doadora.senha, doadora.sal)
                    let result = await doadoraDAO.updateDoadora(await tratarDados(doadora))

                    if (result) {

                        delete doadora.senha
                        delete doadora.sal

                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
                        customMessage.DEFAULT_MESSAGE.response = doadora

                        return customMessage.DEFAULT_MESSAGE
                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL
                    }

                } else {
                    return validar
                }
            } else {
                return resultBuscarDoadora 
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarFotoDoadora = async function (id, dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() != "APPLICATION/JSON") {
            return customMessage.ERROR_CONTENT_TYPE
        }

        id = Number(id)

        if (!Number.isInteger(id) || id <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        if (dados == undefined || dados == null ||
            typeof dados.foto != "string" ||
            dados.foto.length == 0 ||
            dados.foto.length > 255) {
            customMessage.ERROR_BAD_REQUEST.field = "[FOTO] INVÁLIDA (obrigatória, até 255 caracteres)"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await doadoraDAO.updateFotoDoadora(id, dados.foto)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
        customMessage.DEFAULT_MESSAGE.response = { id, foto: dados.foto }

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarNomeDoadora = async function (nome) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (nome == undefined || nome == "" || nome == null || !isNaN(nome)) {
            customMessage.ERROR_BAD_REQUEST.field = "[NOME] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST //400

        } else {

            let result = await doadoraDAO.selectDoadoraByName(nome)

            if (result) {

                if (result.length > 0) {

                    for (let doadora of result) {
                        delete doadora.senha
                        delete doadora.sal
                    }

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                    customMessage.DEFAULT_MESSAGE.response.doadora = result

                    return customMessage.DEFAULT_MESSAGE 

                } else {
                    return customMessage.ERROR_NOT_FOUND 
                }
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL 
            }
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarDoadoraById = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (id == undefined || id == "" || id == null || isNaN(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST 

        } else {

            let result = await doadoraDAO.selectByIdDoadora(id)

            if (result) {

                if (result.length > 0) {

                    for (let doadora of result) {
                        delete doadora.senha
                        delete doadora.sal
                    }

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                    customMessage.DEFAULT_MESSAGE.response.doadora = result

                    return customMessage.DEFAULT_MESSAGE //200

                } else {
                    return customMessage.ERROR_NOT_FOUND //404
                }
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL //500(model)
            }
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}



const verificarOtp = async function (dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let validar = await validarDadosOtp(dados)

            if (validar) {
                return validar
            } else {

                let resultBuscarDoadora = await buscarDoadoraById(dados.id_doadora)

                if (resultBuscarDoadora.status) {

                    let resultOtp = await doadoraDAO.selectUltimoCodigoByDoadora(Number(dados.id_doadora))

                    if (resultOtp) {

                        if (resultOtp.length > 0) {

                            let otp = resultOtp[0]

                            if (Number(dados.codigo) !== Number(otp.codigo)) {
                                customMessage.ERROR_BAD_REQUEST.field = "[CODIGO] INCORRETO"
                                return customMessage.ERROR_BAD_REQUEST

                            } else {

                                let result = await doadoraDAO.validarDoadoraOtp(Number(dados.id_doadora))

                                if (result) {
                                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                                    customMessage.DEFAULT_MESSAGE.message = "Conta validada com sucesso"
                                    customMessage.DEFAULT_MESSAGE.response = { id_doadora: Number(dados.id_doadora), is_validado: true }

                                    return customMessage.DEFAULT_MESSAGE
                                } else {
                                    return customMessage.ERROR_INTERNAL_SERVER_MODEL
                                }

                            }

                        } else {
                            return customMessage.ERROR_NOT_FOUND 
                        }
                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL
                    }

                } else {
                    return resultBuscarDoadora 
                }
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const excluirDoadora = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        let resultBuscarDoadora = await buscarDoadoraById(id)

        if (resultBuscarDoadora.status) {

            let result = await doadoraDAO.deleteDoadora(id)

            if (result) {
                return customMessage.SUCCESS_DELETED_ITEM
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL
            }
        } else {
            return resultBuscarDoadora //400 e 404
        }

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER // 500
    }
}

//Função para tratar os dados a serem inseridos
const tratarDados = async function (doadora) {

    doadora.nome = doadora.nome.replaceAll("'", "")
    doadora.foto = doadora.foto ? doadora.foto.replaceAll("'", "") : null
    doadora.email = doadora.email.replaceAll("'", "")
    doadora.cidade = doadora.cidade.replaceAll("'", "")
    doadora.logradouro = doadora.logradouro.replaceAll("'", "")
    doadora.bairro = doadora.bairro.replaceAll("'", "")
    doadora.numero = String(doadora.numero).replaceAll("'", "")
    doadora.complemento = doadora.complemento ? doadora.complemento.replaceAll("'", "") : ""

    return doadora
}

module.exports = {
    inserirNovaDoadora,
    atualizarDoadora,
    listarDoadora,
    verificarOtp,
    atualizarFotoDoadora,
    atualizarSenhaPorEmail,
    buscarDoadoraById,
    buscarNomeDoadora,
    excluirDoadora,
    login
}