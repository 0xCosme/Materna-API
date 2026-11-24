/*****************************************************************************************
 * Objetivo:    implementacao do JWT
 * Data:        06/11/2026
 * Autor:       Cosme Ribeiro
 * Versão:      1.0
 *****************************************************************************************/

const jwt = require("jsonwebtoken")

//chave que vai dentro da geracao do token ideal ser chave longa
const SECRET = process.env.JWT_SECRET || "charvi"

//tempo que ficar valido o token em segundos
const EXPIRES = 6000;

//cria jwt retorna um token
async function createJWT(payload) {
        const token = jwt.sign({userID:payload}, SECRET,{expiresIn:EXPIRES})
        return token
}

//valida jwt recebe token pra ser validado
async function validaJWT(token) {
        let status = false;

        try {
                jwt.verify(token, SECRET)
                status = true
        } catch (error) {
                status = false
        }

        return status
}

async function authenticateJWT(request, response, next) {
        const authorization = request.headers.authorization
        const token = authorization && authorization.startsWith("Bearer ")
                ? authorization.slice(7)
                : null
        let payload = false

        try {
                payload = token && jwt.verify(token, SECRET)
        } catch (error) {
                payload = false
        }

        if (!payload || !payload.userID) {
                return response.status(401).json({
                        status: false,
                        status_code: 401,
                        message: "Não foi possível processar a requisição devido a credenciais inválidas ou token ausente."
                })
        }

        request.user = typeof payload.userID == "object"
                ? payload.userID.id
                : payload.userID
        request.instituicao = typeof payload.userID == "object"
                ? payload.userID.id_instituicao
                : null
        next()
}

module.exports ={
        createJWT,
        validaJWT,
        authenticateJWT
}