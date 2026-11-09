/*****************************************************************************************
 * Objetivo:    implementacao do JWT
 * Data:        06/11/2026
 * Autor:       Cosme Ribeiro
 * Versão:      1.0
 *****************************************************************************************/

// import da biblioteca
const jwt = require("jsonwebtoken")

//chave que vai dentro da geracao do token ideal ser chave longa 
const SECRET = "charvi"

//tempo que ficar valido o token em segundos
const EXPIRES = 6000;

//cria jwt retorna um token
async function createJWT(payload) {

        //payload  - identificacao do usuario autenticado
        //SECRET   - a chave secreta
        //expiresIn - tempo de expiracao do token
        const token = jwt.sign({userID:payload}, SECRET,{expiresIn:EXPIRES})
        
        return token
}

//valida jwt recebe token pra ser validado
async function validaJWT(token) {
        let status = false;

        //valida autenticacao do token
        jwt.verify(token,SECRET,async function(err, decode) {
                if (!err) {
                        status = true;
                }
        })
        return status
        
}

module.exports ={
        createJWT,
        validaJWT
}




