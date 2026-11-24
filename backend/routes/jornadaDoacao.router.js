const express = require('express')

// Criando um objeto de rota para os Endpoints de vínculo etapa-doadora
const router = express.Router()

const bodyParser = require('body-parser')

// Permitindo a utilização de JSON no body da requisição
const bodyParserJson = bodyParser.json()

// Import da controller do vínculo etapa-doadora
const controllerVinculoEtapaDoadora = require('../controller/jornadaDoacao/controller_doacaoJornada.js')
router.get('/doadora/me', async function(request, response) {
    let result = await controllerVinculoEtapaDoadora.listarJornadasAtivasPorDoadora(request.user)
    response.status(result.status_code)
    response.json(result)
})

router.get('/doadora/:id', async function(request, response) {
    let result = await controllerVinculoEtapaDoadora.listarJornadasAtivasPorDoadora(request.params.id)

    response.status(result.status_code)
    response.json(result)
})

router.post('/', bodyParserJson, async function (request, response) {
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerVinculoEtapaDoadora.vincularEtapaDoadora(dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.put('/:id/cancelar', bodyParserJson, async function (request, response) {
    let id = request.params.id
    let dados = request.body
    let contentType = request.headers['content-type']

    let result = await controllerVinculoEtapaDoadora.cancelarJornadaDoacao(
        id,
        dados,
        contentType
    )

     response.status(result.status_code)
     response.json(result)
})

router.patch('/:id', bodyParserJson, async function(request, response) {
    let id = request.params.id
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerVinculoEtapaDoadora.atualizarDataConclusao(id, dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.patch('/:id/ciclos', bodyParserJson, async function(request, response) {
    let id = request.params.id
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerVinculoEtapaDoadora.definirQuantidadeCiclos(id, dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.patch('/:id/concluir', async function(request, response) {
    let result = await controllerVinculoEtapaDoadora.concluirCiclo(request.params.id)

    response.status(result.status_code)
    response.json(result)
})

module.exports = router