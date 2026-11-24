/**
 * Objetivo: Arquivo responsável pela padronização das mensagens e status code do projeto Materna
 * Data: 06/10/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */


//Padronização dos retornos da API (Cabeçalho)

const DEFAULT_MESSAGE = {
    api_description: "API para controlar o projeto Materna (doadoras, instituições e campanhas)",
    development: "Bruno Haddad Alves",
    version: "1.0.4.26",
    status: Boolean,
    status_code: Number,
    response: {}
}


//Mensagens de ERRO gerais do projeto Materna

const ERROR_BAD_REQUEST = {
    status: false,
    status_code: 400,
    message: "Não foi possível processar a requisição devido a erros nos dados enviados."
}

const ERROR_UNAUTHORIZED = {
    status: false,
    status_code: 401,
    message: "Não foi possível processar a requisição devido a credenciais inválidas ou token ausente."
}

const ERROR_FORBIDDEN = {
    status: false,
    status_code: 403,
    message: "Não foi possível processar a requisição pois o usuário não tem permissão para esta ação."
}

const ERROR_NOT_FOUND = {
    status: false,
    status_code: 404,
    message: "Não foram encontrados dados para retorno da requisição"
}

const ERROR_CONFLICT = {
    status: false,
    status_code: 409,
    message: "Não foi possível processar a requisição devido a um conflito (dado já cadastrado ou registro em uso por outra tabela)."
}

const ERROR_CONTENT_TYPE = {
    status: false,
    status_code: 415,
    message: "Não foi possível processar a requisição devido ao formato de dados encaminhado não ser suportado pelo servidor, apenas deve ser utilizado JSON"
}

const ERROR_INTERNAL_SERVER_CONTROLLER = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [CONTROLLER]"
}

const ERROR_INTERNAL_SERVER_MODEL = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL]"
}

const ERROR_TOKEN_CREATION = {
    status: false,
    status_code: 500,
    message: "Erro ao gerar token"
}


//Mensagens de ERRO de MODEL por tabela (fase 1)

const ERROR_INTERNAL_SERVER_MODEL_TELEFONE = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_TELEFONE]"
}

const ERROR_INTERNAL_SERVER_MODEL_ESTADO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_ESTADO]"
}

const ERROR_INTERNAL_SERVER_MODEL_CIDADE = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_CIDADE]"
}

const ERROR_INTERNAL_SERVER_MODEL_ENDERECO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_ENDERECO]"
}

const ERROR_INTERNAL_SERVER_MODEL_TIPO_COLETA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_TIPO_COLETA]"
}

const ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_FUNCIONARIO]"
}

const ERROR_INTERNAL_SERVER_MODEL_DOADORA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_DOADORA]"
}

const ERROR_INTERNAL_SERVER_MODEL_INSTITUICAO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_INSTITUICAO]"
}

const ERROR_INTERNAL_SERVER_MODEL_TELEFONE_INSTITUICAO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_TELEFONE_INSTITUICAO]"
}

const ERROR_INTERNAL_SERVER_MODEL_HORARIO_FUNCIONAMENTO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_HORARIO_FUNCIONAMENTO]"
}

const ERROR_INTERNAL_SERVER_MODEL_CAMPANHA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_CAMPANHA]"
}


const ERROR_INTERNAL_SERVER_MODEL_JORNADA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_JORNADA]"
}

const ERROR_INTERNAL_SERVER_MODEL_ETAPA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_ETAPA]"
}

const ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_INSTITUICAO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_DOCUMENTO_INSTITUICAO]"
}

const ERROR_INTERNAL_SERVER_MODEL_CADASTRO_HORARIO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_CADASTRO_HORARIO]"
}

const ERROR_INTERNAL_SERVER_MODEL_STATUS_AGENDAMENTO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_STATUS_AGENDAMENTO]"
}

const ERROR_INTERNAL_SERVER_MODEL_CICLO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_CICLO]"
}

const ERROR_INTERNAL_SERVER_MODEL_ETAPA_CICLO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_ETAPA_CICLO]"
}

const ERROR_INTERNAL_SERVER_MODEL_AGENDAMENTO = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_AGENDAMENTO]"
}

const ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_DOADORA = {
    status: false,
    status_code: 500,
    message: "Não foi possível processar a requisição devido a um erro interno no servidor [MODEL_DOCUMENTO_DOADORA]"
}



const SUCCESS_RESPONSE = {
    status: true,
    status_code: 200,
}

const SUCCESS_CREATED_ITEM = {
    status: true,
    status_code: 201,
    message: "Item inserido com sucesso"
}

const SUCCESS_CREATED_ITEM_WARNING = {
    status: true,
    status_code: 201,
    message: "Item inserido com sucesso porem alguns dados tiveram conflitos no cadastro [DADOS DE RELACIONAMENTO]"
}

const SUCCESS_UPDATE_ITEM = {
    status: true,
    status_code: 200,
    message: "Item atualizado com sucesso!"
}

const SUCCESS_DELETED_ITEM = {
    status: true,
    status_code: 200,
    message: "Item excluido com sucesso!"
}


module.exports = {
    DEFAULT_MESSAGE,
    ERROR_BAD_REQUEST,
    ERROR_UNAUTHORIZED,
    ERROR_FORBIDDEN,
    ERROR_NOT_FOUND,
    ERROR_CONFLICT,
    ERROR_CONTENT_TYPE,
    ERROR_INTERNAL_SERVER_CONTROLLER,
    ERROR_INTERNAL_SERVER_MODEL,
    ERROR_TOKEN_CREATION,
    ERROR_INTERNAL_SERVER_MODEL_TELEFONE,
    ERROR_INTERNAL_SERVER_MODEL_ESTADO,
    ERROR_INTERNAL_SERVER_MODEL_CIDADE,
    ERROR_INTERNAL_SERVER_MODEL_ENDERECO,
    ERROR_INTERNAL_SERVER_MODEL_TIPO_COLETA,
    ERROR_INTERNAL_SERVER_MODEL_FUNCIONARIO,
    ERROR_INTERNAL_SERVER_MODEL_DOADORA,
    ERROR_INTERNAL_SERVER_MODEL_INSTITUICAO,
    ERROR_INTERNAL_SERVER_MODEL_TELEFONE_INSTITUICAO,
    ERROR_INTERNAL_SERVER_MODEL_HORARIO_FUNCIONAMENTO,
    ERROR_INTERNAL_SERVER_MODEL_CAMPANHA,
    ERROR_INTERNAL_SERVER_MODEL_JORNADA,
    ERROR_INTERNAL_SERVER_MODEL_ETAPA,
    ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_INSTITUICAO,
    ERROR_INTERNAL_SERVER_MODEL_CADASTRO_HORARIO,
    ERROR_INTERNAL_SERVER_MODEL_STATUS_AGENDAMENTO,
    ERROR_INTERNAL_SERVER_MODEL_CICLO,
    ERROR_INTERNAL_SERVER_MODEL_ETAPA_CICLO,
    ERROR_INTERNAL_SERVER_MODEL_AGENDAMENTO,
    ERROR_INTERNAL_SERVER_MODEL_DOCUMENTO_DOADORA,
    SUCCESS_RESPONSE,
    SUCCESS_CREATED_ITEM,
    SUCCESS_CREATED_ITEM_WARNING,
    SUCCESS_UPDATE_ITEM,
    SUCCESS_DELETED_ITEM
}