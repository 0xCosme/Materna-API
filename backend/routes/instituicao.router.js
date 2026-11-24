const express = require('express')

// Criando um objeto de rota para os Endpoints de Ator
const router = express.Router()

const bodyParser = require('body-parser')

// Permitindo a utilização de JSON no body da requisição
const bodyParserJson = bodyParser.json()

// Import da controller da doadora
const controllerInstituicao = require('../controller/instituicao/controller_instituicao.js')

router.get('/me', async function(request, response) {
    let result = await controllerInstituicao.buscarInstituicaoById(request.instituicao)
    response.status(result.status_code)
    response.json(result)
})

router.get('/', async function(request, response) {
    let result = await controllerInstituicao.listarInstituicao()

    response.status(result.status_code)
    response.json(result)
})

router.put('/:id', bodyParserJson, async function(request, response) {
    let id = request.instituicao
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerInstituicao.atualizarInstituicao(dados, id, contentType)

    response.status(result.status_code)
    response.json(result)
})

// GET /v1/materna/instituicao/proximas?cep=01246-000
router.get("/proximas", async function (request, response) {
    let cep = request.query.cep

    let instituicao = await controllerInstituicao.buscarInstituicoesProximasByCep(cep)

    response.status(instituicao.status_code)
    response.json(instituicao)
})

router.get('/:id/doadoras', async function(request, response) {
    let result = await controllerInstituicao.listarDoadorasPorInstituicao(request.instituicao)

    response.status(result.status_code)
    response.json(result)
})

router.get('/:id', async function(request, response) {
    let id = request.params.id
    let result = await controllerInstituicao.buscarInstituicaoById(id)

    response.status(result.status_code)
    response.json(result)
})



router.post('/', bodyParserJson, async function(request, response) {
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerInstituicao.inserirNovaInstituicao(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

module.exports = router