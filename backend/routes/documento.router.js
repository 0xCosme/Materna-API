const express = require('express')
const bodyParser = require('body-parser')
const controllerDocumento = require('../controller/documento/controller_documento.js')
const router = express.Router()
const bodyParserJson = bodyParser.json()

router.post('/:id_jornada_doacao', bodyParserJson, async function(request, response) {
    let id = request.params.id_jornada_doacao
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerDocumento.enviarDocumento(id, dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

router.patch('/:id_documento/aceitar', async function(request, response) {
    let result = await controllerDocumento.aceitarDocumento(request.params.id_documento)

    response.status(result.status_code)
    response.json(result)
})

router.patch('/:id_documento/recusar', bodyParserJson, async function(request, response) {
    let id = request.params.id_documento
    let dados = request.body
    let contentType = request.headers['content-type']
    let result = await controllerDocumento.recusarDocumento(id, dados, contentType)

    response.status(result.status_code)
    response.json(result)
})

module.exports = router
