/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento , manipulação de dados para realizar o CRUD do cadastro de horário
 * Data: 23/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

const configMessages = require("../module/configMessage.js")

const horarioDAO = require("../../model/DAO/cadastro_horario.js")

// {
//     "dia": "2026-11-10",
//     "horario": "14:30:00",
//     "id_etapa": 1
// }



const validarDados = async function (horario) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    // Regex auxiliares
    const regexData = /^\d{4}-\d{2}-\d{2}$/
    //"2026-11-10"
    const regexHorario = /^([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?$/

//     //regexHorario.test("14:30:00")  // true
// regexHorario.test("14:30")     // true  (segundos são opcionais)
// regexHorario.test("00:00")     // true
// regexHorario.test("23:59:59")  // true
// regexHorario.test("24:00")     // false (hora acima de 23)
// regexHorario.test("14:60")     // false (minuto acima de 59)
// regexHorario.test("9:30")      // false (hora precisa de 2 dígitos)
// regexHorario.test("14:30:00.000") // false (milissegundos não são aceitos)

    if (horario == undefined || horario == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[HORARIO] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (horario.dia == undefined || horario.dia == "" || horario.dia == null || !regexData.test(horario.dia) || isNaN(new Date(horario.dia))) {
        customMessage.ERROR_BAD_REQUEST.field = "[DIA] INVÁLIDO (formato AAAA-MM-DD)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (horario.horario == undefined || horario.horario == "" || horario.horario == null || !regexHorario.test(horario.horario)) {
        customMessage.ERROR_BAD_REQUEST.field = "[HORARIO] INVÁLIDO (formato HH:MM ou HH:MM:SS)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (horario.id_etapa == undefined || horario.id_etapa == "" || horario.id_etapa == null || isNaN(horario.id_etapa) || horario.id_etapa < 1) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_ETAPA] INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}



const inserirHorario = async function (horario, contentType) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {

        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let validarDadosHorario = await validarDados(horario)

            if (!validarDadosHorario) {

                let result = await horarioDAO.insertHorario(await tratarDados(horario))

                if (result && result.erro) {
                    customMessage.ERROR_BAD_REQUEST.message = result.mensagem
                    return customMessage.ERROR_BAD_REQUEST
                }

                if (result) {

                    horario.id = result

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = horario

                    return customMessage.DEFAULT_MESSAGE

                } else {
                    return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
                }

            } else {
                return validarDadosHorario
            }

        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }

    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }

}



const listarHorario = async function () {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let result = await horarioDAO.selectAllHorarios()

        if (result) {
            if (result.length > 0) {

                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.horario = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_NOT_FOUND
            }
        } else {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}


const listarHorariosAgenda = async function (filtros) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (filtros.id_instituicao !== undefined) {
            const idInstituicao = Number(filtros.id_instituicao)
            if (!Number.isInteger(idInstituicao) || idInstituicao <= 0) {
                customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO (deve ser um número inteiro maior que 0)"
                return customMessage.ERROR_BAD_REQUEST
            }
            filtros.id_instituicao = idInstituicao
        }

        let result = await horarioDAO.selectHorariosAgenda(filtros)

        if (result) {
            if (result.length > 0) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.horario = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_NOT_FOUND
            }
        } else {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}



const buscarHorarioById = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (id == undefined || id == "" || id == null || isNaN(id) || id < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        } else {
            let result = await horarioDAO.selectByIdHorario(id)

            if (result) {
                if (result.length > 0) {

                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                    customMessage.DEFAULT_MESSAGE.response.horario = result

                    return customMessage.DEFAULT_MESSAGE
                } else {
                    return customMessage.ERROR_NOT_FOUND
                }
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
            }
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}


const buscarHorarioPorEtapa = async function (idEtapa) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (idEtapa == undefined || idEtapa == "" || idEtapa == null || isNaN(idEtapa) || idEtapa < 1) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_ETAPA] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await horarioDAO.selectHorariosByEtapa(idEtapa)
        if (result) {
            if (result.length > 0) {

                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.horario = result

                return customMessage.DEFAULT_MESSAGE
            }

            return customMessage.ERROR_NOT_FOUND
        }

        return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}



const atualizarHorario = async function (horario, id, contentType) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {

            let resultBuscarHorario = await buscarHorarioById(id)

            if (resultBuscarHorario.status) {

                let validar = await validarDados(horario)

                if (!validar) {

                    horario.id = Number(id)

                    let result = await horarioDAO.updateHorario(await tratarDados(horario))

                    if (result) {

                        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
                        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
                        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
                        customMessage.DEFAULT_MESSAGE.response = horario

                        return customMessage.DEFAULT_MESSAGE
                    } else {
                        return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
                    }
                } else {
                    return validar
                }
            } else {
                return resultBuscarHorario
            }
        } else {
            return customMessage.ERROR_CONTENT_TYPE
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}



const buscarHorarioPorInstituicao = async function (idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (
            idInstituicao == undefined ||
            idInstituicao == "" ||
            idInstituicao == null ||
            isNaN(idInstituicao) ||
            idInstituicao < 1
        ) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await horarioDAO.selectHorariosByInstituicao(idInstituicao)

        if (result) {
            if (result.length > 0) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.horario = result

                return customMessage.DEFAULT_MESSAGE
            }

            return customMessage.ERROR_NOT_FOUND
        }

        return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO

    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}




const deletarHorario = async function (id) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        let resultBuscarHorario = await buscarHorarioById(id)

        if (resultBuscarHorario.status) {

            let result = await horarioDAO.deleteHorario(id)

            if (result) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_DELETED_ITEM.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_DELETED_ITEM.status_code
                customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_DELETED_ITEM.message
                customMessage.DEFAULT_MESSAGE.response = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_INTERNAL_SERVER_MODEL_HORARIO
            }
        } else {
            return resultBuscarHorario
        }
    } catch (error) {
        console.log(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}



const tratarDados = async function (horario) {

    horario.dia = String(horario.dia).replaceAll("'", "")

    horario.horario = String(horario.horario).replaceAll("'", "")

    return horario
}


module.exports = {
    inserirHorario,
    listarHorario,
    listarHorariosAgenda,
    buscarHorarioPorInstituicao,
    buscarHorarioById,
    buscarHorarioPorEtapa,
    atualizarHorario,
    deletarHorario
}