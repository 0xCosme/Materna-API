<script setup>
import { urlDocumento } from '@/composable/urlDocumento';
import { cadastrarJornada } from '@/services/jornadaService';
import { validarArquivoEtapa, validarDescricaoEtapa, validarDescricaoJornada, validarNomeJornada, validarTituloEtapa } from '@/validations/jornadaValidation';
import { nextTick, reactive, ref } from 'vue'

    const emit = defineEmits(['fechar'])

    const campoDescricao = ref(null)
    const campoDescricaoEtapa = ref(null)

    function textareaAlturaAjustada() {
        const campoD = campoDescricao.value
        const camposDE = campoDescricaoEtapa.value
        const alturaMaxima = 150
        const alturaMaximaE = 350

        campoD.style.height = '38px'

        const altura = Math.min(campoD.scrollHeight, alturaMaxima)
        campoD.style.height = `${altura}px`

        campoD.style.overflowY =
            campoD.scrollHeight > alturaMaxima ? 'auto' : 'hidden'

        camposDE.forEach(campo => {
            campo.style.height = '100px'

            const alturaDE = Math.min(campo.scrollHeight, alturaMaximaE)

            campo.style.height = `${alturaDE}px`

            campo.style.overflowY =
                campo.scrollHeight > alturaMaximaE ? 'auto' : 'hidden'
        })
    }


    const errosFormulario = reactive({
        nome: '',
        descricao: ''
    })


    const errosEtapa = ref([])

    const erroGeral = ref('')

    function validarEtapas() {
        errosEtapa.value = etapas.value.map(etapa => ({
            titulo: validarTituloEtapa(etapa) || '',
            descricao: validarDescricaoEtapa(etapa) || '',
            arquivo: validarArquivoEtapa(etapa) || ''
        }))

        return !errosEtapa.value.some(
            erro => erro.titulo !== '' || erro.descricao !== '' || erro.arquivo !== ''
        )
    }

    function validarFormularioAndEtapa(){
        errosFormulario.nome = validarNomeJornada(formularioApi.value) || ''
        errosFormulario.descricao = validarDescricaoJornada(formularioApi.value) || ''

        const formularioValido = Object.values(errosFormulario)
            .every(erro => erro === '')

        const etapasValidas = validarEtapas()

        return formularioValido && etapasValidas
    }

    const camposArquivo = {}
    const etapasElementos = {}

    function abrirSeletorArquivo(id) {
        camposArquivo[id]?.click()
    }

    function selecionarArquivo(event, etapa) {
        const arquivo = event.target.files[0]

        if (!arquivo) return

        etapa.arquivo = arquivo

        event.target.value = ''
    }

    function removerArquivo(etapa) {
        etapa.arquivo = null
    }

    const etapas = ref([
        {
            id: 1,
            titulo: '',
            tipo: 'Opcional',
            descricao: '',
            agendavel: false,
            precisaAprovacao: false,
            solicitaArquivo: false,
            arquivo: null
        }
    ])

    async function adicionarEtapa() {
        if (etapas.value.length >= 5) {
            return
        }

        const novaEtapa = {
            id: Date.now(),
            titulo: '',
            tipo: 'Opcional',
            descricao: '',
            agendavel: false,
            precisaAprovacao: false,
            solicitaArquivo: false,
            arquivo: null
        }

        etapas.value.push(novaEtapa)

        await nextTick()

        etapasElementos[novaEtapa.id]?.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        })
    }

    function removerEtapa() {
        if (etapas.value.length <= 1) {
            return
        }

        etapas.value.pop()
    }

    const { enviarDocumento } = urlDocumento()

    async function salvarJornada() {
        try {
            erroGeral.value = ''

            if(!validarFormularioAndEtapa()){
                erroGeral.value = 'Não foi possível salvar a jornada. Corrija os campos destacados abaixo.'
            }else{
                const etapaColeta = {
                    titulo: 'Coleta',
                    descricao: 'Dados da Coleta obrigatório',
                    ordem: 1,
                    documento: null,
                    is_repetivel: 1,
                    is_agendavel: 0,
                    is_obrigatorio: 1,
                    is_solicita_arquivo: 0,
                    is_precisa_aprovacao: 1
                }

                const etapasComDocumento = await Promise.all(
                    etapas.value.map(async (etapa, index) => {
                        const url = etapa.arquivo
                            ? await enviarDocumento(etapa.arquivo)
                            : null

                        return {
                            titulo: etapa.titulo,
                            descricao: etapa.descricao,
                            ordem: index + 2,
                            documento: url,
                            is_repetivel: 1,
                            is_agendavel: etapa.agendavel ? 1 : 0,
                            is_obrigatorio: 0,
                            is_solicita_arquivo: etapa.solicitaArquivo ? 1 : 0,
                            is_precisa_aprovacao: etapa.precisaAprovacao ? 1 : 0
                        }
                    })
                )
                
                const todasAsEtapas = [
                    etapaColeta,
                    ...etapasComDocumento
                ]

                const dadosJornada = {
                    is_ativo: true,
                    nome: formularioApi.value.nome,
                    descricao: formularioApi.value.descricao,
                    id_instituicao: 1,
                    etapas: todasAsEtapas
                }
                const resposta = await cadastrarJornada(dadosJornada)
                
                if (resposta.status) {
                    window.location.reload()
                }
            }
        } catch (error) {
            console.error('Erro ao publicar jornada:', error)

            erroGeral.value = 'Não foi possível salvar a jornada.Verifique sua conexão e tente novamente.'
        }
    }

    const formularioApi = ref({
        nome: '',
        descricao: ''
    })
</script>

<template>
    <article class="w-full mim-w-0 min-h-0 bg-white border-2 border-borda rounded-[12px] p-[24px]" >
        <header class="flex items-center justify-between mb-[16px]">
            <h1 class="text-[16px] font-bold">Nova jornada</h1>
            <button
            type="button"
            @click="emit('fechar')"
            aria-label="Fechar cadastro">
                <img src="@/assets/campanha/X.svg" alt="Icon de X">
            </button>
        </header>

        <div v-if="erroGeral" class="mb-5 flex flex-col p-[14px] rounded-[12px] border-2 border-[#FECDD3] bg-[#FFF1F2]">
            <div class="flex gap-[12px] ">
                <img class="w-[20px]" src="@/assets/campanha/erro.svg" alt="">
                    <p v-if="erroGeral" class="text-[#BE123C] text-[12px] font-medium">
                        {{ erroGeral }}
                    </p>
            </div>
        </div>

        <hr class="border-0 border-t-2 border-[#F1F5F9]">

        <nav class="flex flex-col mt-[16px]">
            <div class="w-full grid grid-cols-[repeat(auto-fit,minmax(min(100%,280px),1fr))] gap-2">
                <div class="flex flex-col">
                    <span>Nome da jornada</span>
                    <input
                    v-model="formularioApi.nome"
                    type="text"
                    maxlength="50"
                    placeholder="Ex: Jornada padrão da doadora"
                    class="w-full h-[56px] px-[14px] py-[10px] text-texto-claro border border-borda rounded-[8px] focus:border-[#D1D5DB] focus:outline-none">
                    <p v-if="errosFormulario.nome" class="text-[#E11D48] text-[12px] font-medium">
                        {{ errosFormulario.nome }}
                    </p>
                </div>

                <div class="flex flex-col">
                    <span>Descrição</span>
                    <textarea 
                    v-model="formularioApi.descricao"
                    ref="campoDescricao"
                    @input="textareaAlturaAjustada"
                    type="text"
                    placeholder="Breve resumo do objetivo"
                    class="leading-[35px] w-full h-[56px] text-texto-claro border border-borda focus:border-[#D1D5DB] focus:outline-none px-[14px] py-[10px] rounded-[8px] resize-none overflow-hidden"></textarea>
                    <p v-if="errosFormulario.descricao" class="text-[#E11D48] text-[12px] font-medium">
                        {{ errosFormulario.descricao }}
                    </p>
                </div>
            </div>

            <div class="w-full flex bg-[#F0F9FF]/20 flex-col items-center justify-center gap-1 border border-dashed border-[#7DD3FC] rounded-[8px] py-[20px] px-[16px] mt-[16px]">
                <p class="text-[#94A3B8] text-[12px] font-medium">Etapas ({{ etapas.length}})</p>
                <span class="text-[12px] text-[#64748B]">Adicione a primeira etapa abaixo.</span>
            </div>
        </nav>
        <main 
        v-for="(etapa,index) in etapas"
        :key="etapa.id"
        :ref="el => etapasElementos[etapa.id] = el"
        class="w-full flex flex-col min-w-0 mim-h-[661px] bg-[#F8FAFC]/50 border border-[#E2E8F0] p-[20px] mt-[16px] gap-[16px] rounded-[12px]">
            <p class="text-[14px] font-semibold">Adicionar etapa</p>
            <div class="flex flex-row flex-wrap gap-4">
                <div class="flex flex-col w-full max-w-[648px]">
                    <span class="text-[12px] font-medium">Título</span>
                    <input
                    v-model="etapa.titulo" 
                    type="text"
                    placeholder="Ex: Conheça a doação"
                    maxlength="100"
                    class="w-full focus:outline-none bg-white border border-[#E2E8F0] max-w-[1200px] h-[34px] px-[12px] py-[8px] rounded-[6px]">
                    <p v-if="errosEtapa[index]?.titulo" class="text-[#E11D48] text-[12px] font-medium">
                        {{ errosEtapa[index].titulo }}
                    </p>
                </div>
                <div class="flex flex-1 flex-col">
                    <span class="text-[12px] font-medium">Tipo</span>
                    <div class="bg-white border-2 border-[#E2E8F0] text-[12px] font-medium px-[12px] py-[8px] flex items-center  rounded-[6px] w-full h-[34px]">
                        <p>Opcional</p>
                    </div>
                </div>
            </div>

            <div class="flex flex-col gap-[4px] bg-white">
                <span class="text-[12px] font-medium">Descrição</span>
                <textarea
                v-model="etapa.descricao"  
                ref="campoDescricaoEtapa"
                @input="textareaAlturaAjustada"
                type="text"
                placeholder="Breve resumo do objetivo"
                class="leading-[35px] w-full h-[150px] text-texto-claro border border-borda focus:border-[#D1D5DB] focus:outline-none px-[14px] py-[10px] rounded-[8px] resize-none overflow-hidden"></textarea>
                
                <p v-if="errosEtapa[index]?.descricao" class="text-[#E11D48] text-[12px] font-medium">
                    {{ errosEtapa[index].descricao }}
                </p>
            </div>

            <div class="w-full min-w-0 min-h-[65px] bg-white border border-borda flex items-center justify-between p-[12px] rounded-[8px]">
                <div class="flex gap-[8px]">
                    <img 
                    class="w-[20px] "
                    src="@/assets/jornada/calendarioRosa.svg" alt="Icon de Calendario">
                    <div class="flex flex-col">
                        <span class="text-[12px] font-semibold">Etapa Agendável</span>
                        <p class="text-[12px] text-[#94A3B8]">Permite que a doadora agende a data para esta etapa</p>
                    </div>
                </div>
                
                <label class="relative inline-flex items-center cursor-pointer">
                    <input
                    type="checkbox"
                    v-model="etapa.agendavel"
                    class="sr-only peer">

                    <div class="w-[40px] h-[22px] bg-[#E2E8F0] rounded-full
                    peer-checked:bg-materna
                    transition-colors duration-300
                    after:content-['']
                    after:absolute after:top-[3px] after:left-[3px]
                    after:bg-white after:rounded-full
                    after:h-[16px] after:w-[16px]
                    after:transition-transform after:duration-300
                    peer-checked:after:translate-x-[18px]">
                    </div>
                </label>
            </div>

            <div class="w-full min-w-0 min-h-[65px] bg-white border border-borda flex items-center justify-between p-[12px] rounded-[8px]">
                <div class="flex gap-[8px]">
                    <img 
                    class="w-[20px] "
                    src="@/assets/jornada/calendarioRosa.svg" alt="Icon de Calendario">
                    <div class="flex flex-col">
                        <span class="text-[12px] font-semibold">Precisa de aprovação</span>
                        <p class="text-[12px] text-[#94A3B8]">Permite que o banco recusar uma etapa concluida</p>
                    </div>
                </div>
                
               <label class="relative inline-flex items-center cursor-pointer">
                    <input
                    type="checkbox"
                    v-model="etapa.precisaAprovacao"
                    class="sr-only peer">

                    <div class="w-[40px] h-[22px] bg-[#E2E8F0] rounded-full
                    peer-checked:bg-materna
                    transition-colors duration-300
                     after:content-['']
                    after:absolute after:top-[3px] after:left-[3px]
                    after:bg-white after:rounded-full
                    after:h-[16px] after:w-[16px]
                    after:transition-transform after:duration-300
                    peer-checked:after:translate-x-[18px]">
                    </div>
                </label>
            </div>

            <div class="w-full min-w-0 min-h-[65px] bg-white border border-borda flex items-center justify-between p-[12px] rounded-[8px]">
                <div class="flex gap-[8px]">
                    <img 
                    class="w-[20px] "
                    src="@/assets/jornada/calendarioRosa.svg" alt="Icon de Calendario">
                    <div class="flex flex-col">
                        <span class="text-[12px] font-semibold">Etapa com envio de arquivo</span>
                        <p class="text-[12px] text-[#94A3B8]">Permite que a doadora envie um arquivo para esta etapa.</p>
                    </div>
                </div>
                
               <label class="relative inline-flex items-center cursor-pointer">
                    <input
                    type="checkbox"
                    v-model="etapa.solicitaArquivo"
                    class="sr-only peer">

                    <div class="w-[40px] h-[22px] bg-[#E2E8F0] rounded-full
                    peer-checked:bg-materna
                    transition-colors duration-300
                     after:content-['']
                    after:absolute after:top-[3px] after:left-[3px]
                    after:bg-white after:rounded-full
                    after:h-[16px] after:w-[16px]
                    after:transition-transform after:duration-300
                    peer-checked:after:translate-x-[18px]">
                    </div>
                </label>
            </div>

            <div class="flex flex-col">
                <div class="flex flex-row items-end flex-wrap">
                    <span class="text-[14px] font-medium">Arquivo / Material da Instituição (PDF)</span>
                    <p class="text-[13px] text-[#94a3b8]">- Material complementar para leitura da doadora</p>
                </div>

                <div class="w-full min-w-0 min-h-[56px] flex-wrap p-[10px] gap-2 bg-white border-2 border-dashed border-[#E2E8F0] flex flex-row rounded-[8px] justify-between">
                    <div class="flex flex-col">
                        <span 
                        class="text-[13px] font-medium"
                        v-if="etapa.arquivo">
                            {{ etapa.arquivo.name }}
                        </span>
                        <span
                        class="text-[11px] text-[#94A3B8]"
                        v-if="etapa.arquivo">
                            {{etapa.arquivo.name.split('.').pop().toUpperCase()}} 
                            • 
                            {{ (etapa.arquivo.size / (1024**2)).toFixed(2)}} MB 
                            • Anexado
                        </span>
                    </div>

                    <div class="flex flex-row items-center gap-[15px]">
                        <input
                        :ref="el => camposArquivo[etapa.id] = el"
                        type="file"
                        accept=".pdf,.doc,.docx,.xls,.xlsx"
                        class="hidden"
                        @change="selecionarArquivo($event, etapa)">

                        <button
                        class="text-[14px] text-materna flex flex-row gap-2"
                        type="button"
                        @click="abrirSeletorArquivo(etapa.id)">
                            <img class="w-[16px]" src="@/assets/jornada/baixar.svg" alt="Icon indicando dowloand">
                            Adicionar
                        </button>

                        <button
                        v-if="etapa.arquivo"
                        type="button"
                        class="flex flex-row text-[14px] text-[#94A3B8] gap-2"
                        @click="removerArquivo(etapa)">
                            <img class="w-[16px]" src="@/assets/jornada/lixo.svg" alt="Icon que representa remover algo">
                            Remover
                        </button>
                    </div>

                </div> 
                <p v-if="errosEtapa[index]?.arquivo" class="text-red-500 text-[12px]">
                    {{ errosEtapa[index].arquivo }}
                </p>
                <hr 
                v-if="index === etapas.length - 1"
                class="my-4 border-0 border-t-2 border-gray-200 ">

                <div 
                v-if="index === etapas.length - 1"
                class="flex flex-row w-full flex-wrap justify-end gap-[10px]">
                    <button
                    type="button"
                    @click="removerEtapa" 
                    class="w-full max-w-[150px] h-[32px] bg-materna/10 rounded-[8px] flex justify-center items-center gap-[6px] px-[16px] py-[8px] text-[12px]">
                        <img class="w-[15px]" src="@/assets/jornada/remover.svg" alt="Icon de menos para revover etapa">
                        Remover etapa
                    </button>

                    <button
                    type="button"
                    @click="adicionarEtapa" 
                    class="w-full max-w-[150px] h-[32px] bg-materna rounded-[8px] flex justify-center items-center gap-[6px] px-[16px] py-[8px] text-[12px] font-semibold text-white">
                        <img class="w-[16px]" src="@/assets/jornada/+.svg" alt="Icon de mais para adicionar etapa">
                        Adicionar etapa
                    </button>
                </div>
            </div>
        </main>

        <section class=" flex flex-col w-full min-w-0 min-h-[121px] mt-[16px] mb-[16px] bg-[#F8FAFC]/50 border border-[#E2E8F0] p-[20px] gap-[12px] rounded-[12px]">
            <div class="flex gap-3 items-center">
                <h4 class="text-[12px] font-semibold">Adicionar etapa</h4>
                <span
                class="bg-[#FFFBEB] px-2 py-2 text-[#B45309] text-[10px] flex gap-2 border border-[#FDE68A] rounded-full ">
                    <img 
                    class="w-[14px]"
                    style="filter: invert(67%) sepia(91%) saturate(1000%) hue-rotate(2deg) brightness(101%) contrast(96%);"
                    src="@/assets/jornada/cadeado.svg" alt="Icon de cadeado">
                    Etapa obrigatória e fixa do fluxo institucional (não editável)
                </span>
            </div>
                
            <dl class="grid grid-cols-2 mt-[] gap-2">
                <div class="flex flex-col gap-1">
                    <dt class="text-[11px] text-[#64748B] font-medium">
                        Título
                    </dt>

                    <dd class="flex items-center justify-between rounded-[6px] bg-[#E2E8F0]/60 border border-[#E2E8F0] px-3 py-2 text-[12px] text-[#475569] font-medium">
                        <span>Coleta</span>
                        <img src="@/assets/jornada/cadeado.svg" alt="Icon de cadeado" class="w-[14px]">
                    </dd>
                </div>

                <div class="flex flex-col gap-1">
                    <dt class="text-[11px] text-[#64748B] font-medium">
                        Tipo
                    </dt>
                    <dd class="rounded-[6px]  bg-[#E2E8F0]/60 border border-[#E2E8F0] px-3 py-2 text-[12px] text-[#475569] font-medium">
                        Obrigatório
                    </dd>
                </div>
            </dl>
        </section>

        <hr class="my-4 border-0 border-t-2 border-borda ">

        <footer class="flex-wrap gap-2 flex justify-end mt-5">
            <button
            class="w-[87px] h-[36px] px-[16px] py-[8px] bg-[#DE6B72]/10 text-[#374151] text-[14px] rounded-[6px]"
            @click="emit('fechar')">Cancelar</button>
            <button
            @click="salvarJornada"
            class="h-[36px] px-[16px] py-[8px] bg-materna text-white text-[14px] rounded-[6px]"
            >Salvar jornada</button>
        </footer>
    </article>
</template>