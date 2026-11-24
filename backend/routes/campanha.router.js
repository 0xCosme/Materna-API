const express = require('express')

// Criando um objeto de rota para os Endpoints de Ator
const router = express.Router()

const bodyParser = require('body-parser')

// Permitindo a utilização de JSON no body da requisição
const bodyParserJson = bodyParser.json()

// Import da controller da campanha
const controllerCampanha = require('../controller/campanha/controller_campanha.js')

router.post('/', bodyParserJson, async function(request, response) {
    let dados = {
        ...request.body,
        id_instituicao: request.instituicao,
        id_funcionario: request.user
    }
    let contentType = request.headers['content-type']
    let result = await controllerCampanha.inserirNovaCampanha(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})


router.get('/', async function (request, response) {
    let result = await controllerCampanha.listarCampanha()

    response.status(result.status_code)
    response.json(result)
})

router.get('/:id', async function (request, response) {
    let id = request.params.id
    let result = await controllerCampanha.buscarCampanhaById(id)

    response.status(result.status_code)
    response.json(result)
})

router.put('/:id', bodyParserJson, async function (request, response) {
    let id = request.params.id
    let dados = {
        ...request.body,
        id_instituicao: request.instituicao,
        id_funcionario: request.user
    }
    let contentType = request.headers['content-type']
    let result = await controllerCampanha.atualizarCampanha(dados, id, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.delete('/:id', async function (request, response) {
    let id = request.params.id
    let result = await controllerCampanha.deletarCampanha(id)

    response.status(result.status_code)
    response.json(result)
})

module.exports = router