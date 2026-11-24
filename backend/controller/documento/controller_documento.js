const configMessages = require("../module/configMessage.js")
const documentoDoadoraDAO = require("../../model/DAO/documentoDoadora.js")

const validarDados = async function (documentoDoadora) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (documentoDoadora == undefined || documentoDoadora == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[DOCUMENTO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
    } else if (documentoDoadora.id_jornada_doacao == undefined ||
        documentoDoadora.id_jornada_doacao == "" ||
        documentoDoadora.id_jornada_doacao == null ||
        !Number.isInteger(Number(documentoDoadora.id_jornada_doacao)) ||
        documentoDoadora.id_jornada_doacao < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_JORNADA_DOACAO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
    } else if (documentoDoadora.id_doadora == undefined ||
        documentoDoadora.id_doadora == "" ||
        documentoDoadora.id_doadora == null ||
        !Number.isInteger(Number(documentoDoadora.id_doadora)) ||
        documentoDoadora.id_doadora < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
    } else if (typeof documentoDoadora.documento != "string" ||
        documentoDoadora.documento.trim() == "" ||
        documentoDoadora.documento.trim().length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[DOCUMENTO] INVÁLIDO (envie um link de até 255 caracteres)"
        return customMessage.ERROR_BAD_REQUEST
    }

    return false
}

const validarDadosRecusa = async function (idDocumento, dados) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (idDocumento == undefined || idDocumento == "" || idDocumento == null ||
        !Number.isInteger(Number(idDocumento)) || idDocumento < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_DOCUMENTO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST
    } else if (dados == undefined || dados == null ||
        typeof dados.motivo_recusa != "string" ||
        dados.motivo_recusa.trim() == "" ||
        dados.motivo_recusa.trim().length > 255) {
        customMessage.ERROR_BAD_REQUEST.field = "[MOTIVO_RECUSA] INVÁLIDO (obrigatório, até 255 caracteres)"
        return customMessage.ERROR_BAD_REQUEST
    }

    return false
}

const enviarDocumento = async function (idJornadaDoacao, dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {
            let documentoDoadora = {
                ...dados,
                id_jornada_doacao: idJornadaDoacao
            }
            let validar = await validarDados(documentoDoadora)

            if (validar) {
                return validar
            }

            documentoDoadora.id_jornada_doacao = Number(documentoDoadora.id_jornada_doacao)
            documentoDoadora.id_doadora = Number(documentoDoadora.id_doadora)
            documentoDoadora.documento = documentoDoadora.documento.trim()

            let result = await documentoDoadoraDAO.insertDocumentoDoadora(documentoDoadora)
            if (result === null) {
                return customMessage.ERROR_NOT_FOUND
            } else if (result) {
                documentoDoadora.id_documento = result.id_documento
                documentoDoadora.id_status_documento = result.id_status_documento
                documentoDoadora.status = result.id_status_documento == 1
                    ? "Pendente"
                    : "Aceito"
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                customMessage.DEFAULT_MESSAGE.response = documentoDoadora
                return customMessage.DEFAULT_MESSAGE
            }

            return customMessage.ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_DOADORA
        }

        return customMessage.ERROR_CONTENT_TYPE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const aceitarDocumento = async function (idDocumento) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idDocumento = Number(idDocumento)
        if (!Number.isInteger(idDocumento) || idDocumento < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_DOCUMENTO] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await documentoDoadoraDAO.aceitarDocumentoDoadora(idDocumento)
        if (result === null) {
            return customMessage.ERROR_NOT_FOUND
        } else if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_DOADORA
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = "Documento aceito com sucesso"
        customMessage.DEFAULT_MESSAGE.response = {
            id_documento: idDocumento,
            id_status_documento: 2,
            status: "Aceito"
        }
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const recusarDocumento = async function (idDocumento, dados, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {
            let validar = await validarDadosRecusa(idDocumento, dados)
            if (validar) {
                return validar
            }

            idDocumento = Number(idDocumento)
            dados.motivo_recusa = dados.motivo_recusa.trim()
            let result = await documentoDoadoraDAO.recusarDocumentoDoadora(
                idDocumento,
                dados.motivo_recusa
            )

            if (result === null) {
                return customMessage.ERROR_NOT_FOUND
            } else if (result) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                customMessage.DEFAULT_MESSAGE.message = "Documento recusado com sucesso"
                customMessage.DEFAULT_MESSAGE.response = {
                    id_documento: idDocumento,
                    id_status_documento: 3,
                    status: "Recusado",
                    motivo_recusa: dados.motivo_recusa
                }
                return customMessage.DEFAULT_MESSAGE
            }

            return customMessage.ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_DOADORA
        }

        return customMessage.ERROR_CONTENT_TYPE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    enviarDocumento,
    aceitarDocumento,
    recusarDocumento
}
