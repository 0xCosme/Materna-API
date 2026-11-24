/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento e manipulação de dados para o CRUD de agendamento
 * Data: 30/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

//Import de configurações do arquivo de mensagens do projeto
const configMessages = require("../module/configMessage.js")

const agendamentoDAO = require("../../model/DAO/agendamento.js")

const validarDados = async function (agendamento) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (agendamento == undefined || agendamento == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[AGENDAMENTO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (!Number.isInteger(agendamento.id_cadastro_horario) || agendamento.id_cadastro_horario <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_CADASTRO_HORARIO] INVÁLIDO (deve ser um número inteiro maior que 0)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (!Number.isInteger(agendamento.id_jornada_doacao) || agendamento.id_jornada_doacao <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_JORNADA_DOACAO] INVÁLIDO (deve ser um número inteiro maior que 0)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (!Number.isInteger(agendamento.id_status_agendamento) || agendamento.id_status_agendamento <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_STATUS_AGENDAMENTO] INVÁLIDO (deve ser um número inteiro maior que 0)"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}


const inserirNovoAgendamento = async function (agendamento, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let validar = await validarDados(agendamento)

            if (validar) {
                return validar
            } else {

                let result = await agendamentoDAO.insertAgendamento(agendamento)

                if (result && result.erro) {

                    if (result.sqlState == "45000") {

                        if (result.mensagem.includes("nao encontrado")) {
                            customMessage.ERROR_NOT_FOUND.field = result.mensagem
                            return customMessage.ERROR_NOT_FOUND
                        } else {
                            customMessage.ERROR_BAD_REQUEST.field = result.mensagem
                            return customMessage.ERROR_BAD_REQUEST
                        }

                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL
                    }

                } else if (result) {

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = { id: result, ...agendamento }

                    return customMessage.DEFAULT_MESSAGE

                } else {
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL
                }
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarAgendamento = async function (id, dados, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            id = Number(id)

            if (!Number.isInteger(id) || id <= 0) {
                customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO (deve ser um número inteiro maior que 0)"
                return customMessage.ERROR_BAD_REQUEST

            } else if (dados == undefined || dados == null ||
                !Number.isInteger(dados.id_status_agendamento) ||
                ![2, 3, 4].includes(dados.id_status_agendamento)) {
                customMessage.ERROR_BAD_REQUEST.field = "[ID_STATUS_AGENDAMENTO] INVÁLIDO (use 2 para aceitar, 3 para recusar ou 4 para cancelar)"
                return customMessage.ERROR_BAD_REQUEST

            } else if (dados.id_status_agendamento == 4 &&
                (!Number.isInteger(dados.id_doadora) || dados.id_doadora <= 0)) {
                customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO (obrigatório para cancelar o agendamento)"
                return customMessage.ERROR_BAD_REQUEST

            } else {

                let result = await agendamentoDAO.updateAgendamento(
                    id,
                    dados.id_status_agendamento,
                    dados.id_status_agendamento == 4 ? dados.id_doadora : null
                )

                if (result && result.erro) {

                    if (result.sqlState == "45000") {

                        if (result.mensagem.includes("nao encontrado")) {
                            customMessage.ERROR_NOT_FOUND.field = result.mensagem
                            return customMessage.ERROR_NOT_FOUND
                        } else {
                            customMessage.ERROR_BAD_REQUEST.field = result.mensagem
                            return customMessage.ERROR_BAD_REQUEST
                        }

                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL
                    }

                } else if (result) {

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = dados.id_status_agendamento == 4
                        ? "Agendamento cancelado com sucesso"
                        : customMessage.SUCCESS_UPDATE_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = {
                        id,
                        id_status_agendamento: dados.id_status_agendamento,
                        ...(dados.id_status_agendamento == 4 ? { id_doadora: dados.id_doadora } : {})
                    }

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

const listarAgendamentos = async function () {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let result = await agendamentoDAO.selectAllAgendamentos()

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_AGENDAMENTO
        }

        if (result.length === 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
        customMessage.DEFAULT_MESSAGE.count = result.length
        customMessage.DEFAULT_MESSAGE.response.agendamento = result

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const listarAgendamentosPorInstituicao = async function (idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idInstituicao = Number(idInstituicao)

        if (!Number.isInteger(idInstituicao) || idInstituicao <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await agendamentoDAO.selectAllAgendamentos(idInstituicao)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_AGENDAMENTO
        }

        if (result.length === 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
        customMessage.DEFAULT_MESSAGE.count = result.length
        customMessage.DEFAULT_MESSAGE.response.agendamento = result

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const listarAgendamentosPorDoadora = async function (idDoadora) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idDoadora = Number(idDoadora)

        if (!Number.isInteger(idDoadora) || idDoadora <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await agendamentoDAO.selectAgendamentosPorDoadora(idDoadora)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_AGENDAMENTO
        }

        if (result.length === 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
        customMessage.DEFAULT_MESSAGE.count = result.length
        customMessage.DEFAULT_MESSAGE.response.agendamento = result

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    inserirNovoAgendamento,
    atualizarAgendamento,
    listarAgendamentos,
    listarAgendamentosPorInstituicao,
    listarAgendamentosPorDoadora
}
