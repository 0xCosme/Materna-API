
import { requisicaoApi } from "./api";

export async function listarJornada(idInstituicao) {

    const resposta = await requisicaoApi(`instituicao/${idInstituicao}`)

    if (!resposta || !resposta.status) {
        return []
    }

    const dadosInstituicao = resposta.response.instituicao

    const instituicao = Array.isArray(dadosInstituicao)
        ? dadosInstituicao.find(item => item.id === idInstituicao)
        : dadosInstituicao

    return instituicao?.jornadas ?? []
}

export async function cadastrarJornada(dados) {
    return await requisicaoApi('jornada', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(dados)
    })
}

export async function atualizarStatusJornada(id, isAtivo) {
    return await requisicaoApi(`jornada/${id}`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            is_ativo: isAtivo
        })
    })
}