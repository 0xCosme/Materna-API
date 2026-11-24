const formatosPermitidos = [
    'image/jpeg',
    'image/png',
    'image/webp'
]

const tamanhoMaximo = 5 * 1024**2

export function validarImagem(imagem) {

    if (!imagem) 
        return 'Selecione uma imagem.'
    
    else if (!formatosPermitidos.includes(imagem.type))
        return 'Formato inválido. Utilize JPG, PNG ou WEBP.'
    
    else if (imagem.size > tamanhoMaximo) 
        return 'A imagem deve ter no máximo 5 MB.'
    
    return ''
}