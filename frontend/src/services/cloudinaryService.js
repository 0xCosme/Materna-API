const CLOUD_NAME = import.meta.env.VITE_CLOUDINARY_CLOUD_NAME
const UPLOAD_PRESET = import.meta.env.VITE_CLOUDINARY_UPLOAD_PRESET

export async function enviarImagemCloudinary(arquivo) {

    if (!CLOUD_NAME || !UPLOAD_PRESET) {
        throw new Error('As configurações do Cloudinary não foram encontradas.')
    }

    if (!arquivo) {
        throw new Error('Nenhuma imagem foi selecionada.')
    }

    const formulario = new FormData()

    formulario.append('file', arquivo)
    formulario.append('upload_preset', UPLOAD_PRESET)

    const resposta = await fetch(
        `https://api.cloudinary.com/v1_1/${CLOUD_NAME}/image/upload`,
        {
            method: 'POST',
            body: formulario
        }
    )

    if (!resposta.ok) {
        throw new Error('Não foi possível enviar a imagem para o Cloudinary.')
    }

    const dados = await resposta.json()

    return dados.secure_url
}

export async function enviarDocumentoCloudinary(documento) {
    if (!CLOUD_NAME || !UPLOAD_PRESET) {
        throw new Error('As configurações do Cloudinary não foram encontradas.')
    }

    if (!documento) {
        throw new Error('Nenhum documento foi selecionado.')
    }

    const formulario = new FormData()

    formulario.append('file', documento)
    formulario.append('upload_preset', UPLOAD_PRESET)

    const resposta = await fetch(
        `https://api.cloudinary.com/v1_1/${CLOUD_NAME}/raw/upload`,
        {
            method: 'POST',
            body: formulario
        }
    )

    if (!resposta.ok) {
        throw new Error('Não foi possível enviar o documento para o Cloudinary.')
    }

    const dados = await resposta.json()

    return dados.secure_url
}