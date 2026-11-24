import { requisicaoApi } from "./api";

export async function listarCampanha(){

    const resposta = await requisicaoApi('campanha')

    if (!resposta) {
        return []
    }

    return resposta.response.campanha
}

export async function cadastrarCampanha(dados){

    const resposta = await requisicaoApi('campanha',{
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(dados),
    })

    return resposta
}

export async function atualizarCampanha(id,dados) {
    const resposta = await requisicaoApi(`campanha/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(dados),
    })

    return resposta
}

export async function deletarCampanha(id) {
    const resposta = await requisicaoApi(`campanha/${id}`, {
        method: 'DELETE'
    })

    return resposta
}