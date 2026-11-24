const express = require("express")
const cors = require("cors")
const app = express()
const { authenticateJWT } = require("./middleware/MiddlewareJWT.js")


const corsOptions = {
    origin: "*", // Configuração de origem da requisição (IP ou Dominio)
    methods: "GET, POST, PUT, PATCH, DELETE, OPTIONS",  // Configuração dos verbos que serão utilizados na API
    allowedHeaders: ['Content-type', "Authorization"]
}

const doadoraRouter = require("./routes/doadora.router.js")
const funcionarioRouter = require("./routes/funcionario.router.js")
const campanhaRouter = require("./routes/campanha.router.js")
const instituicaoRouter = require("./routes/instituicao.router.js")
const jornadaRouter = require("./routes/jornada.router.js")
const horarioRouter = require("./routes/horario_instituicao.js")
const jornadaDoacao = require("./routes/jornadaDoacao.router.js")
const documentoRouter = require("./routes/documento.router.js")
const agendamento = require("./routes/agendamento.router.js")



app.use(cors(corsOptions))

app.use(function(request, response, next) {
    const originalPath = request.originalUrl.split("?")[0]
    const publicRoute =
        (request.method === "GET" &&
         /^\/v1\/materna\/instituicao(?:\/\d+)?\/?$/.test(originalPath)) ||
        (request.method === "POST" &&
        (/^\/v1\/materna\/doadora\/?$/.test(request.path) ||
         request.path === "/v1/materna/doadora/login" ||
         request.path === "/v1/materna/funcionario/login" ||
         request.path === "/v1/materna/doadora/otp/verificar" ||
         request.path === "/v1/materna/instituicao")) ||
        (request.method === "PATCH" &&
         request.path === "/v1/materna/doadora/senha")

    if (publicRoute) {
        return next()
    }

    return authenticateJWT(request, response, next)
})

app.use("/v1/materna/doadora", doadoraRouter)
app.use("/v1/materna/funcionario", funcionarioRouter )
app.use("/v1/materna/campanha", campanhaRouter)
app.use("/v1/materna/instituicao", instituicaoRouter)
app.use("/v1/materna/jornada", jornadaRouter)
app.use("/v1/materna/horario", horarioRouter)
app.use("/v1/materna/vinculo-etapa-doadora", jornadaDoacao)
app.use("/v1/materna/documento", documentoRouter)
app.use("/v1/materna/agendamento", agendamento)


app.listen(9090, function(){
    console.log("API aguardando novas requisições..............")
})
