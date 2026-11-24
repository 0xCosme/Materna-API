export function validarTiulo(formulario){

    if(formulario.titulo == '')
        return 'O título da campanha é obrigatório.'
    else if(formulario.titulo.length > 100)
        return 'O título da campanha deve conter no máximo 100 caracteres.'

    return ''
}

export function validarDescrição(formulario){

    if(formulario.descricao == '')
        return 'A descrição da campanha é obrigatória.'

    return ''
}

export function validarDataInicio(formulario){

    if (!formulario.dataInicio)
        return 'A data de início da campanha é obrigatória.'

    const anoAtual = new Date().getFullYear()
    const anoSelecionado = Number(formulario.dataInicio.split('-')[0])

    if(anoSelecionado < anoAtual)
        return 'A data de início não pode ser anterior ao ano atual.'

    return ''
}

export function validarDataFinal(formulario){

    if(!formulario.dataFim)
        return 'A data de término da campanha é obrigatória.'
    else if(!formulario.dataInicio)
        return 'Preencha a data de início antes de informar a data de término.'
    else if(formulario.dataFim < formulario.dataInicio)
        return 'A data de término não pode ser anterior à data de início.'

    const anoAtual = new Date().getFullYear()
    const anoMaximo = anoAtual + 2
    const ano = new Date(formulario.dataFim).getFullYear()

    if(ano > anoMaximo)
        return 'A data de término não pode ultrapassar dois anos a partir do ano atual.'

    return ''
}