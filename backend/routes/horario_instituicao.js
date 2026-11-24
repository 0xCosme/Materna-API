const express = require('express')

// Criando um objeto de rota para os Endpoints
const router = express.Router()

const bodyParser = require('body-parser')

// Permitindo a utilização de JSON no body da requisição
const bodyParserJson = bodyParser.json()

// Import da controller do horário
const controllerHorario = require('../controller/horario/controller_horario.js')

// Inserir um novo horário
router.post('/', bodyParserJson, async function(request, response) {

    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerHorario.inserirHorario(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

// Listar todos os horários
router.get('/', async function(request, response) {

    let result = await controllerHorario.buscarHorarioPorInstituicao(request.instituicao)

    response.status(result.status_code)
    response.json(result)
})

// Listar os horários de uma instituição
router.get('/instituicao/me', async function(request, response) {

    let result = await controllerHorario.buscarHorarioPorInstituicao(request.instituicao)

    response.status(result.status_code)
    response.json(result)
})

router.get('/instituicao/:id', async function(request, response) {

    let idInstituicao = request.instituicao
    let result = await controllerHorario.buscarHorarioPorInstituicao(idInstituicao)

    response.status(result.status_code)
    response.json(result)
})

// Listar os horários da agenda
router.get('/agenda', async function(request, response) {

    let result = await controllerHorario.listarHorariosAgenda({
        ...request.query,
        id_instituicao: request.instituicao
    })

    response.status(result.status_code)
    response.json(result)
})

// Buscar um horário pelo ID
router.get('/:id', async function(request, response) {

    let id = request.params.id
    let result = await controllerHorario.buscarHorarioById(id)

    response.status(result.status_code)
    response.json(result)
})

// Atualizar um horário
router.put('/:id', bodyParserJson, async function(request, response) {

    let id = request.params.id
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerHorario.atualizarHorario(dados, id, contentType)

    response.status(result.status_code)
    response.json(result)
})

// Excluir um horário
router.delete('/:id', async function(request, response) {

    let id = request.params.id
    let result = await controllerHorario.deletarHorario(id)

    response.status(result.status_code)
    response.json(result)
})

module.exports = router