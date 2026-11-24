const configMessages = require("../module/configMessage.js")
const EtapaDoadoraDAO = require("../../model/DAO/vinculoEtapaDoadora.js")
const doadoraController = require("../doadora/controller_doadora.js")


const validarDados = async function (vinculo) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (vinculo == undefined || vinculo == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[VINCULO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (vinculo.id_doadora == undefined || vinculo.id_doadora == "" || vinculo.id_doadora == null || isNaN(vinculo.id_doadora) || vinculo.id_doadora < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (vinculo.id_etapa == undefined || vinculo.id_etapa == "" || vinculo.id_etapa == null || isNaN(vinculo.id_etapa) || vinculo.id_etapa < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_ETAPA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}

const validarDadosEncerramentoJornada = async function (dados) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (dados == undefined || dados == null) {

        customMessage.ERROR_BAD_REQUEST.field = "[DADOS] INVÁLIDOS"
        return customMessage.ERROR_BAD_REQUEST

    } else if (
        dados.id_doadora == undefined ||dados.id_doadora == "" ||dados.id_doadora == null ||!Number.isInteger(Number(dados.id_doadora)) ||Number(dados.id_doadora) <= 0
    ) {

        customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}


const tratarDados = async function (vinculo) {

    vinculo.id_doadora = Number(vinculo.id_doadora)
    vinculo.id_etapa = Number(vinculo.id_etapa)

    return vinculo
}

const vincularEtapaDoadora = async function (vinculo, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (!String(contentType).toUpperCase().includes("APPLICATION/JSON")) {
            return customMessage.ERROR_CONTENT_TYPE
        }

        let validar = await validarDados(vinculo)
        if (validar) {
            return validar
        }

        let result = await EtapaDoadoraDAO.insertVinculoEtapaDoadora(await tratarDados(vinculo))

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }

        if (result.id_jornada_doacao) {
            vinculo.id = result.id_jornada_doacao

            customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
            customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
            customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
            customMessage.DEFAULT_MESSAGE.response = vinculo

            return customMessage.DEFAULT_MESSAGE
        }

        if (result.mensagem) {
            if (String(result.mensagem).toLowerCase().includes("nao encontrada")) {
                customMessage.ERROR_NOT_FOUND.field = `[VINCULO] ${result.mensagem}`
                return customMessage.ERROR_NOT_FOUND
            }

            customMessage.ERROR_BAD_REQUEST.field = `[VINCULO] ${result.mensagem}`
            return customMessage.ERROR_BAD_REQUEST
        }

        return customMessage.ERROR_INTERNAL_SERVER_MODEL

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}


const atualizarDataConclusao = async function (id, dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))
    const regexData = /^\d{4}-\d{2}-\d{2}$/

    try {
        if (String(contentType).toUpperCase() != "APPLICATION/JSON") {
            return customMessage.ERROR_CONTENT_TYPE
        }

        id = Number(id)

        if (!Number.isInteger(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        } else if (dados == undefined || dados == null || dados.data_conclusao === undefined) {
            customMessage.ERROR_BAD_REQUEST.field = "[DATA_CONCLUSAO] INVÁLIDA (use AAAA-MM-DD ou null)"
            return customMessage.ERROR_BAD_REQUEST
        } else if (dados.data_conclusao !== null &&
            (typeof dados.data_conclusao != "string" ||
                !regexData.test(dados.data_conclusao) ||
                isNaN(new Date(dados.data_conclusao)))) {
            customMessage.ERROR_BAD_REQUEST.field = "[DATA_CONCLUSAO] INVÁLIDA (use AAAA-MM-DD ou null)"
            return customMessage.ERROR_BAD_REQUEST
        }

        const dataConclusao = dados.data_conclusao
        const result = await EtapaDoadoraDAO.updateDataConclusaoJornadaDoacao(id, dataConclusao)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }
        if (result.status === "nao_encontrado") {
            return customMessage.ERROR_NOT_FOUND
        }
        if (result.status === "etapa_repetivel") {
            customMessage.ERROR_CONFLICT.field =
                "[CICLO] USE A ROTA DE CONCLUSÃO DE CICLOS PARA ETAPAS REPETÍVEIS"
            return customMessage.ERROR_CONFLICT
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
        customMessage.DEFAULT_MESSAGE.response = {
            id_jornada_doacao: id,
            data_conclusao: dataConclusao
        }

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const definirQuantidadeCiclos = async function (id, dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (!String(contentType).toUpperCase().includes("APPLICATION/JSON")) {
            return customMessage.ERROR_CONTENT_TYPE
        }

        id = Number(id)
        if (!Number.isInteger(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }
        if (dados == undefined || dados == null ||
            !Number.isInteger(dados.quantidade_ciclos) ||
            dados.quantidade_ciclos < 1) {
            customMessage.ERROR_BAD_REQUEST.field =
                "[QUANTIDADE_CICLOS] INVÁLIDA (informe um inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        const result = await EtapaDoadoraDAO.definirQuantidadeCiclosJornadaDoacao(
            id,
            dados.quantidade_ciclos
        )
        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }
        if (result.status === "nao_encontrado") {
            return customMessage.ERROR_NOT_FOUND
        }
        if (result.status === "etapa_nao_repetivel") {
            customMessage.ERROR_BAD_REQUEST.field = "[ETAPA] NÃO É REPETÍVEL"
            return customMessage.ERROR_BAD_REQUEST
        }
        if (result.status === "ja_iniciado") {
            customMessage.ERROR_CONFLICT.field =
                "[CICLO] A QUANTIDADE SÓ PODE SER DEFINIDA ANTES DA PRIMEIRA CONCLUSÃO"
            return customMessage.ERROR_CONFLICT
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = "Quantidade de ciclos definida"
        customMessage.DEFAULT_MESSAGE.response = {
            id_jornada_doacao: id,
            ciclo: result.ciclo
        }
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const concluirCiclo = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        id = Number(id)
        if (!Number.isInteger(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        const result = await EtapaDoadoraDAO.concluirCicloJornadaDoacao(id)
        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }
        if (result.status === "nao_encontrado") {
            return customMessage.ERROR_NOT_FOUND
        }
        if (result.status === "etapa_nao_repetivel") {
            customMessage.ERROR_BAD_REQUEST.field = "[ETAPA] NÃO É REPETÍVEL"
            return customMessage.ERROR_BAD_REQUEST
        }
        if (result.status === "sem_ciclos") {
            customMessage.ERROR_CONFLICT.field =
                "[CICLO] QUANTIDADE NÃO DEFINIDA OU TODOS OS CICLOS JÁ FORAM CONCLUÍDOS"
            return customMessage.ERROR_CONFLICT
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = result.encerrado
            ? "Todos os ciclos foram concluídos"
            : "Ciclo concluído"
        customMessage.DEFAULT_MESSAGE.response = result
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const listarJornadasAtivasPorDoadora = async function (idDoadora) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idDoadora = Number(idDoadora)
        if (!Number.isInteger(idDoadora) || idDoadora <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        const result = await EtapaDoadoraDAO.selectJornadasAtivasPorDoadora(idDoadora)
        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL
        }

        if (result.length === 0 || result.jornadas.length === 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
        customMessage.DEFAULT_MESSAGE.count = result.jornadas.length
        customMessage.DEFAULT_MESSAGE.response = result

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const cancelarJornadaDoacao = async function (id, dados, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase().includes("APPLICATION/JSON")) {
            id = Number(id)

            if (!Number.isInteger(id) || id <= 0) {
                customMessage.ERROR_BAD_REQUEST.field = "[ID_JORNADA_DOACAO] INVÁLIDO"
                return customMessage.ERROR_BAD_REQUEST
            }

            let validar = await validarDadosEncerramentoJornada(dados)

            if (!validar) {

                let resultBuscarDoadora = await doadoraController.buscarDoadoraById(dados.id_doadora)

                if (resultBuscarDoadora.status) {

                    let result = await EtapaDoadoraDAO.cancelarJornadaDoacao(
                        id,
                        Number(dados.id_doadora)
                    )

                    if (result) {

                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                        customMessage.DEFAULT_MESSAGE.message = "Jornada cancelada com sucesso"
                        customMessage.DEFAULT_MESSAGE.response = result

                        return customMessage.DEFAULT_MESSAGE

                    } else {
                        return customMessage.ERROR_NOT_FOUND
                    }

                } else {
                    return resultBuscarDoadora
                }

            } else {
                return validar
            }

        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    vincularEtapaDoadora,
    atualizarDataConclusao,
    definirQuantidadeCiclos,
    cancelarJornadaDoacao,
    concluirCiclo,
    listarJornadasAtivasPorDoadora
}