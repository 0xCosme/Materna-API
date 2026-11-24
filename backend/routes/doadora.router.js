const express = require('express')

// Criando um objeto de rota para os Endpoints de Ator
const router = express.Router()

const bodyParser = require('body-parser')

// Permitindo a utilização de JSON no body da requisição
const bodyParserJson = bodyParser.json()

// Import da controller da doadora
const controllerDoadora = require('../controller/doadora/controller_doadora.js')
router.post('/', bodyParserJson, async function(request, response) {
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerDoadora.inserirNovaDoadora(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.post('/login', bodyParserJson, async function(request, response) {
    let result = await controllerDoadora.login(request.body, request.headers['content-type'])
    response.status(result.status_code)
    response.json(result)
})

router.get('/me', async function (request, response) {
    let result = await controllerDoadora.buscarDoadoraById(request.user)
    response.status(result.status_code)
    response.json(result)
})

router.patch('/me', bodyParserJson, async function (request, response) {
    let result = await controllerDoadora.atualizarFotoDoadora(
        request.user,
        request.body,
        request.headers['content-type']
    )
    response.status(result.status_code)
    response.json(result)
})

router.get('/:id', async function (request, response) {
    let id = request.params.id
    let result = await controllerDoadora.buscarDoadoraById(id)

    response.status(result.status_code)
    response.json(result)
})

router.post('/otp/verificar', bodyParserJson, async function (request, response) {

    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerDoadora.verificarOtp(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.patch('/senha', bodyParserJson, async function (request, response) {
    let result = await controllerDoadora.atualizarSenhaPorEmail(
        request.body,
        request.headers['content-type']
    )
    response.status(result.status_code)
    response.json(result)
})

// { "id_doadora": 1, "codigo": 123456 }

router.put('/:id', bodyParserJson, async function(request, response) {
    let id = request.params.id
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerDoadora.atualizarDoadora(dados, id, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.delete('/:id', async function (request, response) {
    let id = request.params.id
    let result = await controllerDoadora.excluirDoadora(id)
    response.status(result.status_code)
    response.json(result)
})



module.exports = router