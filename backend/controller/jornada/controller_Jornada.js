/****************************************************************************************************************
 * Objetivo: Arquivo responsável pela validação, tratamento , manipulação de dados para realizar o CRUD de jornada
 * Data: 09/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

//Import de configurações do arquivo de mensagens do projeto
const configMessages = require("../module/configMessage.js")

const jornadaDAO = require("../../model/DAO/jornada.js")

const validarDados = async function (jornada) {

    let customMessage = JSON.parse(JSON.stringify(configMessages))

    if (jornada == undefined || jornada == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[JORNADA] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.nome == undefined || jornada.nome == "" || jornada.nome == null || jornada.nome.length > 50) {
        customMessage.ERROR_BAD_REQUEST.field = "[NOME] INVÁLIDO (obrigatório, até 50 caracteres)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.descricao == undefined || jornada.descricao == "" || jornada.descricao == null) {
        customMessage.ERROR_BAD_REQUEST.field = "[DESCRICAO] INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.is_ativo == undefined || jornada.is_ativo == null || typeof jornada.is_ativo != "boolean") {
        customMessage.ERROR_BAD_REQUEST.field = "[IS_ATIVO] INVÁLIDO (deve ser true ou false)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (!Number.isInteger(jornada.id_instituicao) || jornada.id_instituicao <= 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO (deve ser um número inteiro maior que 0)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (!Array.isArray(jornada.etapas) || jornada.etapas.length == 0) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] INVÁLIDAS (informe ao menos uma etapa)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.etapas.some(e => e == undefined || e == null || e.titulo == undefined || e.titulo == "" || e.titulo == null || e.titulo.length > 100)) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] TITULO INVÁLIDO (obrigatório, até 100 caracteres)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.etapas.some(e => e.descricao == undefined || e.descricao == "" || e.descricao == null)) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] DESCRICAO INVÁLIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.etapas.some(e => e.ordem == undefined || e.ordem == null || !Number.isInteger(e.ordem) || e.ordem <= 0)) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] ORDEM INVÁLIDA (obrigatória, número inteiro maior que 0)"
        return customMessage.ERROR_BAD_REQUEST

    } else if (new Set(jornada.etapas.map(e => e.ordem)).size != jornada.etapas.length) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] ORDEM REPETIDA"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.etapas.some(e => e.documento != undefined && e.documento != null && e.documento != "" && e.documento.length > 255)) {
        // documento é opcional: só valida se vier preenchido
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] DOCUMENTO INVÁLIDO"
        return customMessage.ERROR_BAD_REQUEST

    } else if (jornada.etapas.some(e => [e.is_repetivel, e.is_agendavel, e.is_obrigatorio, e.is_solicita_arquivo, e.is_precisa_aprovacao].some(v => v !== 0 && v !== 1))) {
        customMessage.ERROR_BAD_REQUEST.field = "[ETAPAS] CAMPOS is_* OBRIGATÓRIOS (devem ser 0 ou 1)"
        return customMessage.ERROR_BAD_REQUEST

    } else {
        return false
    }
}


const inserirNovaJornada = async function (jornada, contentType) {
 
    let customMessage = JSON.parse(JSON.stringify(configMessages))
 
    try {
 
        if (String(contentType).toUpperCase() == "APPLICATION/JSON") {
 
            let validar = await validarDados(jornada)
 
            if (validar) {
                return validar
            } else {
 
                let result = await jornadaDAO.insertJornada(await tratarDados(jornada))
 
                if (result && result.codigo == 200) {
 
                    customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_CREATED_ITEM.status
                    customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_CREATED_ITEM.status_code
                    customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_CREATED_ITEM.message
                    customMessage.DEFAULT_MESSAGE.response = {
                        ...result.jornada,
                        etapas: result.etapas
                    }
 
                    return customMessage.DEFAULT_MESSAGE
 
                } else if (result && result.codigo == 404) {
                    customMessage.ERROR_NOT_FOUND.field = "[ID_INSTITUICAO] INSTITUIÇÃO NÃO ENCONTRADA"
                    return customMessage.ERROR_NOT_FOUND
 
                } else if (result && result.codigo == 400) {
                    customMessage.ERROR_BAD_REQUEST.field = result.mensagem || "DADOS INVÁLIDOS"
                    return customMessage.ERROR_BAD_REQUEST
 
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

const listarJornadasPorInstituicao = async function (idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idInstituicao = Number(idInstituicao)

        if (!Number.isInteger(idInstituicao) || idInstituicao <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await jornadaDAO.selectJornadasPorInstituicao(idInstituicao)

        if (result) {
            if (result.length > 0) {
                customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
                customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
                customMessage.DEFAULT_MESSAGE.count = result.length
                customMessage.DEFAULT_MESSAGE.response.jornada = result

                return customMessage.DEFAULT_MESSAGE
            } else {
                return customMessage.ERROR_NOT_FOUND
            }
        } else {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_JORNADA
        }
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const buscarJornadaDoadora = async function (idDoadora) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        idDoadora = Number(idDoadora)

        if (!Number.isInteger(idDoadora) || idDoadora <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_DOADORA] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        const rows = await jornadaDAO.selectJornadaDoadoraById(idDoadora)

        if (!rows) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_JORNADA
        }

        if (rows.length === 0) {
            return customMessage.ERROR_NOT_FOUND
        }

        const primeiraLinha = rows[0]
        const doadora = {
            id: primeiraLinha.id_doadora,
            nome: primeiraLinha.nome_doadora,
            foto: primeiraLinha.foto_doadora,
            data_nascimento: primeiraLinha.data_nascimento,
            email: primeiraLinha.email,
            telefone: primeiraLinha.telefone,
            endereco: {
                logradouro: primeiraLinha.logradouro,
                cep: primeiraLinha.cep,
                bairro: primeiraLinha.bairro,
                numero: primeiraLinha.numero_endereco,
                complemento: primeiraLinha.complemento,
                cidade: primeiraLinha.cidade,
                sigla_estado: primeiraLinha.sigla_estado
            }
        }

        const jornadas = new Map()
        const etapasPorJornada = new Map()
        const atividadesPorId = new Map()
        const documentosPorAtividade = new Map()
        const agendamentosPorAtividade = new Map()

        for (const linha of rows) {
            if (linha.id_jornada === null) {
                continue
            }

            if (!jornadas.has(linha.id_jornada)) {
                jornadas.set(linha.id_jornada, {
                    id: linha.id_jornada,
                    nome: linha.nome_jornada,
                    descricao: linha.descricao_jornada,
                    is_ativo: linha.jornada_ativa,
                    id_instituicao: linha.id_instituicao,
                    instituicao: linha.nome_instituicao,
                    etapas: []
                })
                etapasPorJornada.set(linha.id_jornada, new Map())
            }

            const etapas = etapasPorJornada.get(linha.id_jornada)
            if (linha.id_etapa !== null && !etapas.has(linha.id_etapa)) {
                const etapa = {
                    id: linha.id_etapa,
                    titulo: linha.titulo_etapa,
                    descricao: linha.descricao_etapa,
                    ordem: linha.ordem_etapa,
                    documento: linha.documento_etapa,
                    is_repetivel: linha.is_repetivel,
                    is_agendavel: linha.is_agendavel,
                    is_obrigatorio: linha.is_obrigatorio,
                    is_solicita_arquivo: linha.is_solicita_arquivo,
                    is_precisa_aprovacao: linha.is_precisa_aprovacao,
                    ciclos: []
                }
                etapas.set(linha.id_etapa, etapa)
                jornadas.get(linha.id_jornada).etapas.push(etapa)
            }

            if (linha.id_jornada_doacao === null) {
                continue
            }

            if (!atividadesPorId.has(linha.id_jornada_doacao)) {
                const atividade = {
                    id: linha.id_jornada_doacao,
                    ciclo: linha.ciclo,
                    data_conclusao: linha.data_conclusao,
                    encerrado: linha.encerrado,
                    documentos: [],
                    agendamentos: []
                }
                atividadesPorId.set(linha.id_jornada_doacao, atividade)
                etapas.get(linha.id_etapa).ciclos.push(atividade)
                documentosPorAtividade.set(linha.id_jornada_doacao, new Set())
                agendamentosPorAtividade.set(linha.id_jornada_doacao, new Set())
            }

            const atividade = atividadesPorId.get(linha.id_jornada_doacao)

            if (linha.id_documento !== null) {
                const documentos = documentosPorAtividade.get(linha.id_jornada_doacao)
                if (!documentos.has(linha.id_documento)) {
                    documentos.add(linha.id_documento)
                    atividade.documentos.push({
                        id: linha.id_documento,
                        documento: linha.arquivo_documento,
                        motivo_recusa: linha.motivo_recusa,
                        id_status_documento: linha.id_status_documento,
                        status: linha.status_documento
                    })
                }
            }

            if (linha.id_agendamento !== null) {
                const agendamentos = agendamentosPorAtividade.get(linha.id_jornada_doacao)
                if (!agendamentos.has(linha.id_agendamento)) {
                    agendamentos.add(linha.id_agendamento)
                    atividade.agendamentos.push({
                        id: linha.id_agendamento,
                        dia: linha.dia_agendamento,
                        horario: linha.horario_agendamento,
                        status: linha.status_agendamento
                    })
                }
            }
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_RESPONSE.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_RESPONSE.status_code
        customMessage.DEFAULT_MESSAGE.response = {
            doadora,
            jornadas: Array.from(jornadas.values())
        }
        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const atualizarStatusJornada = async function (id, dados, contentType, idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        if (!String(contentType).toUpperCase().includes("APPLICATION/JSON")) {
            return customMessage.ERROR_CONTENT_TYPE
        }

        id = Number(id)

        if (!Number.isInteger(id) || id <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO (deve ser um número inteiro maior que 0)"
            return customMessage.ERROR_BAD_REQUEST
        }

        if (dados == undefined || dados == null || typeof dados.is_ativo != "boolean") {
            customMessage.ERROR_BAD_REQUEST.field = "[IS_ATIVO] INVÁLIDO (deve ser true ou false)"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await jornadaDAO.updateStatusJornada(id, dados.is_ativo, idInstituicao)

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_JORNADA
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_UPDATE_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_UPDATE_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_UPDATE_ITEM.message
        customMessage.DEFAULT_MESSAGE.response = { id, is_ativo: dados.is_ativo }

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const deletarJornada = async function (id, idInstituicao) {
    let customMessage = JSON.parse(JSON.stringify(configMessages))

    try {
        id = Number(id)
        idInstituicao = Number(idInstituicao)

        if (!Number.isInteger(id) || id <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        if (!Number.isInteger(idInstituicao) || idInstituicao <= 0) {
            customMessage.ERROR_BAD_REQUEST.field = "[ID_INSTITUICAO] INVÁLIDO"
            return customMessage.ERROR_BAD_REQUEST
        }

        let result = await jornadaDAO.deleteJornada(id, idInstituicao)

        if (result && result.conflito) {
            customMessage.ERROR_CONFLICT.field =
                "[JORNADA] POSSUI VÍNCULO COM DOADORA"
            return customMessage.ERROR_CONFLICT
        }

        if (result === null) {
            return customMessage.ERROR_NOT_FOUND
        }

        if (!result) {
            return customMessage.ERROR_INTERNAL_SERVER_MODEL_JORNADA
        }

        customMessage.DEFAULT_MESSAGE.status = customMessage.SUCCESS_DELETED_ITEM.status
        customMessage.DEFAULT_MESSAGE.status_code = customMessage.SUCCESS_DELETED_ITEM.status_code
        customMessage.DEFAULT_MESSAGE.message = customMessage.SUCCESS_DELETED_ITEM.message
        customMessage.DEFAULT_MESSAGE.response = result

        return customMessage.DEFAULT_MESSAGE
    } catch (error) {
        console.error(error)
        return customMessage.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const tratarDados = async function (jornada) {

    jornada.nome = jornada.nome.replaceAll("'", "")
    jornada.descricao = jornada.descricao.replaceAll("'", "")

    for (const etapa of jornada.etapas) {
        etapa.titulo = etapa.titulo.replaceAll("'", "")
        etapa.descricao = etapa.descricao.replaceAll("'", "")
        etapa.documento = etapa.documento ? etapa.documento.replaceAll("'", "") : null
    }

    return jornada
}


module.exports = {
    inserirNovaJornada,
    listarJornadasPorInstituicao,
    buscarJornadaDoadora,
    atualizarStatusJornada,
    deletarJornada
}