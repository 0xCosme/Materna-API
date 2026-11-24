export function validarNomeJornada(formulario){
    if(formulario.nome.trim() == "")
        return 'O nome da jornada é obrigatório.'
    else if(formulario.nome.length >50)
        return 'O nome da jornada deve conter no máximo 50 caracteres.'
}

export function validarDescricaoJornada(formulario){
    if(formulario.descricao.trim() == "")
        return 'A descrição da jornada é obrigatório.'
}

export function validarTituloEtapa(etapa) {
    if (etapa.titulo.trim() === '') {
        return 'O título da etapa é obrigatório.'
    }

    if (etapa.titulo.length > 100) {
        return 'O título deve conter no máximo 100 caracteres.'
    }
}

export function validarDescricaoEtapa(etapa) {
    if (etapa.descricao.trim() === '') {
        return 'A descrição da etapa é obrigatória.'
    }
}

export function validarArquivoEtapa(etapa){
    if (!etapa.arquivo) {
        return ''
    }

    const tiposPermitidos = [
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    ]

    if (!tiposPermitidos.includes(etapa.arquivo.type)) {
        return 'Envie um arquivo nos formatos PDF, DOC, DOCX, XLS e XLSX.'
    }

    const tamanhoMaximo = 15 * 1024 ** 2

    if (etapa.arquivo.size > tamanhoMaximo) {
        return 'O arquivo deve ter no máximo 15 MB.'
    }

    return ''
}