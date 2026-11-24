<script setup>
import { ref } from 'vue'

const instituicaoEditando = ref(false)
const responsavelEditando = ref(false)

const instituicao = ref({
    nome: 'Banco de Leite Humano A',
    cnpj: '12.345.678/0001-90',
    telefone: '(11) 91234-5678',
    email: 'contato@bancoleite.org.br',
})

const responsavel = ref({
    nome: 'Dra. Renata Vasconcellos',
    cargo: 'Coordenadora Geral',
    cpf: '138.578.432-51',
    telefone: '(11) 98765-4321',
    email: 'renata.vasconcellos@bancoleite.org.br',
    nascimento: '14/08/1982',
})

const endereco = ref({
    cep: '01230-100',
    logradouro: 'Av. Paulista',
    numero: '1000',
    complemento: 'Bloco B',
    bairro: 'Bela Vista',
    cidade: 'São Paulo',
    uf: 'SP',
})
const enderecoRascunho = ref({ ...endereco.value })

const modalInstituicao = ref(false)
const modalResponsavel = ref(false)
const modalUsuario = ref(false)
const usuarioIndiceEdicao = ref(null)
const usuarioFormulario = ref({
    nome: '',
    email: '',
    cpf: '',
    telefone: '',
    senha: '',
    confirmarSenha: '',
    tipo: 'Operador',
})
const mostrarSenha = ref(false)
const mostrarConfirmarSenha = ref(false)

const usuarios = ref([
    { iniciais: 'RV', nome: 'Dra. Renata Vasconcellos', email: 'renata.vasconcellos@bancoleite.org.br', tipo: 'Administrador', ativo: true },
    { iniciais: 'CM', nome: 'Carlos Eduardo Mendes', email: 'carlos.mendes@bancoleite.org.br', tipo: 'Ativo', ativo: true },
    { iniciais: 'JR', nome: 'Juliana Ribeiro', email: 'juliana.ribeiro@bancoleite.org.br', tipo: 'Operador', ativo: true },
])
const usuariosRascunho = ref(usuarios.value.map(usuario => ({ ...usuario })))

const instituicaoRascunho = ref({ ...instituicao.value })
const responsavelRascunho = ref({ ...responsavel.value })
const fotoInstituicao = ref('')
const fotoInstituicaoRascunho = ref('')
const seletorFoto = ref(null)

function salvar() {
    instituicaoEditando.value = false
    responsavelEditando.value = false
    instituicao.value = { ...instituicaoRascunho.value }
    fotoInstituicao.value = fotoInstituicaoRascunho.value
    responsavel.value = { ...responsavelRascunho.value }
    endereco.value = { ...enderecoRascunho.value }
    usuarios.value = usuariosRascunho.value.map(usuario => ({ ...usuario }))
}

function removerUsuario(indice) {
    usuariosRascunho.value.splice(indice, 1)
}

function abrirEditarInstituicao() {
    instituicaoRascunho.value = { ...instituicao.value }
    modalInstituicao.value = true
}

function abrirEditarResponsavel() {
    responsavelRascunho.value = { ...responsavel.value }
    modalResponsavel.value = true
}

function confirmarInstituicao() {
    instituicao.value = { ...instituicaoRascunho.value }
    modalInstituicao.value = false
}

function cancelarInstituicao() {
    instituicaoRascunho.value = { ...instituicao.value }
    modalInstituicao.value = false
}

function confirmarResponsavel() {
    responsavel.value = { ...responsavelRascunho.value }
    modalResponsavel.value = false
}

function cancelarResponsavel() {
    responsavelRascunho.value = { ...responsavel.value }
    modalResponsavel.value = false
}

function selecionarFoto(event) {
    const arquivo = event.target.files?.[0]
    if (!arquivo) return

    if (!['image/png', 'image/jpeg'].includes(arquivo.type)) {
        event.target.value = ''
        return
    }

    const leitor = new FileReader()
    leitor.onload = () => {
        fotoInstituicaoRascunho.value = String(leitor.result)
    }
    leitor.readAsDataURL(arquivo)
}

function removerFoto() {
    fotoInstituicaoRascunho.value = ''
    if (seletorFoto.value) seletorFoto.value.value = ''
}

function abrirAdicionarUsuario() {
    usuarioIndiceEdicao.value = null
    usuarioFormulario.value = { nome: '', email: '', cpf: '', telefone: '', senha: '', confirmarSenha: '', tipo: 'Operador' }
    mostrarSenha.value = false
    mostrarConfirmarSenha.value = false
    modalUsuario.value = true
}

function abrirEditarUsuario(usuario, indice) {
    usuarioIndiceEdicao.value = indice
    usuarioFormulario.value = { nome: usuario.nome, email: usuario.email, tipo: usuario.tipo }
    modalUsuario.value = true
}

function salvarUsuario() {
    const nome = usuarioFormulario.value.nome.trim()
    const email = usuarioFormulario.value.email.trim()
    if (!nome || !email) return

    const iniciais = nome
        .split(/\s+/)
        .slice(0, 2)
        .map(parte => parte[0])
        .join('')
        .toUpperCase()

    if (usuarioIndiceEdicao.value === null) {
        usuariosRascunho.value.push({
            iniciais,
            nome,
            email,
            tipo: usuarioFormulario.value.tipo,
            ativo: true,
        })
    } else {
        const usuario = usuariosRascunho.value[usuarioIndiceEdicao.value]
        usuario.iniciais = iniciais
        usuario.nome = nome
        usuario.email = email
        usuario.tipo = usuarioFormulario.value.tipo
    }

    modalUsuario.value = false
}
</script>

<template>
    <main class="min-h-full w-full bg-[#F8FAFC] p-[30px]">
        <section class="flex flex-col gap-[16px]">
            <article class="rounded-[10px] border border-[#E4E7EC] bg-white p-[20px]">
                <header class="flex items-center justify-between pb-[14px]">
                    <div class="flex items-center gap-[8px] text-[13px] font-semibold text-[#475569]">
                        <span class="flex h-[16px] w-[16px] items-center justify-center rounded-[4px] bg-[#FFF0F2] text-materna">
                            <svg viewBox="0 0 16 16" class="h-[11px] w-[11px]" fill="none" stroke="currentColor" stroke-width="1.4">
                                <path d="M3 14V4h10v10M5 14V7h6v7M1.5 14h13M6 10h1M9 10h1M6 12h1M9 12h1M5 4V2h6v2"/>
                            </svg>
                        </span>
                        Dados da instituição
                    </div>
                    <button type="button" @click="abrirEditarInstituicao"
                        class="flex h-[30px] items-center gap-[6px] rounded-[7px] border border-[#F0D1D5] bg-[#FFF7F8] px-[10px] text-[11px] font-medium text-materna">
                        <span class="text-[14px]">✎</span>
                        Editar
                    </button>
                </header>

                <div class="flex items-center gap-[10px] rounded-[8px] border border-[#E8EBEF] p-[10px]">
                    <div class="flex h-[48px] w-[48px] shrink-0 items-center justify-center rounded-[8px] bg-[#F1F4F5]">
                        <img v-if="fotoInstituicaoRascunho" :src="fotoInstituicaoRascunho" alt="Logotipo da instituição" class="h-full w-full rounded-[8px] object-cover" />
                        <span v-else class="h-[18px] w-[18px] rotate-45 rounded-[3px] bg-materna"></span>
                    </div>
                    <div class="min-w-0">
                        <p class="text-[11px] font-semibold text-[#475569]">Logotipo ou foto da instituição</p>
                        <p class="mt-[2px] text-[9px] text-[#94A3B8]">PNG, JPG ou PDF. Comprimento recomendado: 500x500px.</p>
                        <input ref="seletorFoto" type="file" accept="image/png,image/jpeg" class="hidden" @change="selecionarFoto" />
                        <button type="button" @click="seletorFoto?.click()" class="mt-[5px] flex h-[20px] items-center gap-[5px] rounded-[5px] border border-[#F0D1D5] px-[7px] text-[9px] text-materna">
                            <span>⌁</span> Alterar foto
                        </button>
                    </div>
                    <button type="button" @click="removerFoto" class="ml-[40px] h-[20px] rounded-[5px] border border-[#E8EBEF] px-[7px] text-[9px] text-[#64748B]">Remover</button>
                </div>

                <div class="mt-[16px] grid gap-x-[20px] gap-y-[12px]">
                    <label class="text-[10px] text-[#94A3B8]">Nome da instituição
                        <input v-model="instituicao.nome" :readonly="!instituicaoEditando"
                            class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <div class="grid grid-cols-1 gap-[16px] md:grid-cols-2">
                        <label class="text-[10px] text-[#94A3B8]">CNPJ
                            <input v-model="instituicao.cnpj" :readonly="!instituicaoEditando"
                                class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                        </label>
                        <label class="text-[10px] text-[#94A3B8]">Telefone
                            <input v-model="instituicao.telefone" :readonly="!instituicaoEditando"
                                class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                        </label>
                    </div>
                    <label class="text-[10px] text-[#94A3B8]">E-mail da instituição
                        <input v-model="instituicao.email" :readonly="!instituicaoEditando"
                            class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                </div>
            </article>

            <article class="rounded-[10px] border border-[#E4E7EC] bg-white p-[20px]">
                <header class="flex items-center justify-between">
                    <div class="flex items-center gap-[8px] text-[12px] font-semibold text-[#475569]">
                        <span class="text-materna">♙</span>
                        Dados do responsável
                    </div>
                    <button type="button" @click="abrirEditarResponsavel"
                        class="flex h-[30px] items-center gap-[6px] rounded-[7px] border border-[#F0D1D5] bg-[#FFF7F8] px-[10px] text-[11px] font-medium text-materna">
                        <span>✎</span> Editar responsável
                    </button>
                </header>

                <div class="mt-[12px] rounded-[7px] border border-[#E5E7EB] p-[14px]">
                <div class="grid grid-cols-1 items-center gap-[12px] md:grid-cols-[70px_minmax(0,1fr)_minmax(0,1fr)]">
                    <div class="flex h-[48px] w-[48px] items-center justify-center rounded-full bg-[#FFE7EA] text-[13px] font-semibold text-materna">RV</div>
                    <label class="min-w-0 text-[9px] text-[#94A3B8]">Nome completo
                        <input v-model="responsavel.nome" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="min-w-0 text-[9px] text-[#94A3B8]">Telefone direto
                        <input v-model="responsavel.telefone" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                </div>

                <div class="mt-[10px] grid grid-cols-1 gap-x-[16px] gap-y-[10px] md:grid-cols-2">
                    <label class="text-[9px] text-[#94A3B8]">CPF
                        <input v-model="responsavel.cpf" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[9px] text-[#94A3B8]">Data de nascimento
                        <input v-model="responsavel.nascimento" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[9px] text-[#94A3B8]">Cargo
                        <input v-model="responsavel.cargo" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[9px] text-[#94A3B8]">E-mail corporativo
                        <input v-model="responsavel.email" :readonly="!responsavelEditando"
                            class="mt-[4px] block h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    </div>
                </div>
            </article>

            <article class="rounded-[10px] border border-[#E4E7EC] bg-white p-[20px]">
                <header class="flex items-center gap-[8px] pb-[12px] text-[12px] font-semibold text-[#475569]">
                    <span class="text-materna">●</span> Endereço
                </header>
                <div class="grid grid-cols-1 gap-x-[16px] gap-y-[12px] md:grid-cols-2">
                    <label class="text-[10px] text-[#94A3B8]">CEP
                        <input v-model="enderecoRascunho.cep" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Logradouro
                        <input v-model="enderecoRascunho.logradouro" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Número
                        <input v-model="enderecoRascunho.numero" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Complemento
                        <input v-model="enderecoRascunho.complemento" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Bairro
                        <input v-model="enderecoRascunho.bairro" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                    </label>
                    <div class="grid grid-cols-[minmax(0,1fr)_70px] gap-[12px]">
                        <label class="text-[10px] text-[#94A3B8]">Cidade
                            <input v-model="enderecoRascunho.cidade" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                        </label>
                        <label class="text-[10px] text-[#94A3B8]">UF
                            <input v-model="enderecoRascunho.uf" class="mt-[4px] h-[36px] w-full rounded-[7px] border border-[#EEF0F3] px-[10px] text-[11px] text-[#475569] outline-none" />
                        </label>
                    </div>
                </div>
            </article>

            <article class="rounded-[10px] border border-[#E4E7EC] bg-white p-[20px]">
                <header class="flex items-center gap-[8px] text-[12px] font-semibold text-[#475569]">
                    <span class="text-materna">◷</span> Horário de atendimento
                </header>
                <div class="mt-[10px]">
                    <p class="text-[10px] text-[#94A3B8]">Horário</p>
                    <p class="mt-[5px] text-[11px] text-[#475569]">Seg - Sex, 08:00 - 17:00</p>
                </div>
            </article>

            <article class="rounded-[10px] border border-[#E4E7EC] bg-white p-[20px]">
                <header class="flex items-center justify-between">
                    <div>
                        <div class="flex items-center gap-[8px] text-[12px] font-semibold text-[#475569]">
                            <span class="text-materna">♙</span> Usuários com Acesso ao Sistema
                        </div>
                        <p class="mt-[2px] text-[9px] text-[#94A3B8]">Gerencie os usuários que possuem acesso ao painel institucional.</p>
                    </div>
                    <button type="button" @click="abrirAdicionarUsuario" class="h-[32px] rounded-[7px] bg-materna px-[12px] text-[11px] font-medium text-white">+ Adicionar Usuário</button>
                </header>

                <div class="mt-[14px] overflow-hidden rounded-[8px] border border-[#E8EBEF]">
                    <div v-for="(usuario, indice) in usuariosRascunho" :key="usuario.email"
                        class="grid h-[48px] grid-cols-[52px_1fr_1fr_100px_50px] items-center border-b border-[#EEF0F3] px-[12px] last:border-b-0">
                        <div class="flex h-[32px] w-[32px] items-center justify-center rounded-full bg-[#FFE7EA] text-[10px] font-semibold text-materna">{{ usuario.iniciais }}</div>
                        <div class="text-[10px] font-semibold text-[#475569]">{{ usuario.nome }}</div>
                        <div class="text-[9px] text-[#94A3B8]">{{ usuario.email }}</div>
                        <div>
                            <span class="rounded-full bg-[#E8F7F3] px-[8px] py-[3px] text-[9px] text-[#4A9A84]">{{ usuario.tipo }}</span>
                        </div>
                        <div class="flex justify-end gap-[8px] text-[#94A3B8]">
                            <button type="button" title="Editar" @click="abrirEditarUsuario(usuario, indice)" class="text-[13px]">✎</button>
                            <button type="button" title="Remover funcionário" aria-label="Remover funcionário" @click="removerUsuario(indice)" class="flex h-[24px] w-[24px] items-center justify-center rounded-[6px] text-[#94A3B8] transition-colors hover:bg-[#FFF1F2] hover:text-materna">
                                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-hidden="true">
                                    <path d="M2.5 3.5H11.5M5 3.5V2.5H9V3.5M3.5 3.5L4 11.5H10L10.5 3.5M5.5 6V9M8.5 6V9" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </article>
        </section>

        <div class="flex justify-end pt-[16px]">
            <button type="button" @click="salvar"
                class="h-[38px] w-[74px] rounded-[7px] bg-materna text-[12px] font-semibold text-white">
                Salvar
            </button>
        </div>

        <div v-if="modalInstituicao" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/30 p-[20px]">
            <section class="w-full max-w-[560px] rounded-[12px] bg-white shadow-xl">
                <header class="flex items-center justify-between border-b border-borda px-[20px] py-[16px]">
                    <h2 class="text-[15px] font-semibold text-[#475569]">Editar dados da instituição</h2>
                    <button type="button" @click="modalInstituicao = false" class="grid h-[30px] w-[30px] place-items-center rounded-full text-[18px] text-[#94A3B8] hover:bg-slate-50">×</button>
                </header>
                <div class="grid grid-cols-1 gap-[12px] p-[20px] md:grid-cols-2">
                    <label class="text-[10px] text-[#94A3B8] md:col-span-2">Nome da instituição
                        <input v-model="instituicaoRascunho.nome" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">CNPJ
                        <input v-model="instituicaoRascunho.cnpj" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Telefone
                        <input v-model="instituicaoRascunho.telefone" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8] md:col-span-2">E-mail da instituição
                        <input v-model="instituicaoRascunho.email" type="email" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                </div>
                <footer class="flex justify-end gap-[8px] border-t border-borda px-[20px] py-[14px]">
                    <button type="button" @click="cancelarInstituicao" class="h-[36px] rounded-[7px] border border-borda px-[14px] text-[12px] text-[#64748B]">Cancelar</button>
                    <button type="button" @click="confirmarInstituicao" class="h-[36px] rounded-[7px] bg-materna px-[14px] text-[12px] font-semibold text-white">Confirmar</button>
                </footer>
            </section>
        </div>

        <div v-if="modalResponsavel" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/30 p-[20px]">
            <section class="w-full max-w-[560px] rounded-[12px] bg-white shadow-xl">
                <header class="flex items-center justify-between border-b border-borda px-[20px] py-[16px]">
                    <h2 class="text-[15px] font-semibold text-[#475569]">Editar responsável</h2>
                    <button type="button" @click="modalResponsavel = false" class="grid h-[30px] w-[30px] place-items-center rounded-full text-[18px] text-[#94A3B8] hover:bg-slate-50">×</button>
                </header>
                <div class="grid grid-cols-1 gap-[12px] p-[20px] md:grid-cols-2">
                    <label class="text-[10px] text-[#94A3B8] md:col-span-2">Nome completo
                        <input v-model="responsavelRascunho.nome" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">CPF
                        <input v-model="responsavelRascunho.cpf" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Data de nascimento
                        <input v-model="responsavelRascunho.nascimento" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Telefone direto
                        <input v-model="responsavelRascunho.telefone" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8]">Cargo
                        <input v-model="responsavelRascunho.cargo" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                    <label class="text-[10px] text-[#94A3B8] md:col-span-2">E-mail corporativo
                        <input v-model="responsavelRascunho.email" type="email" class="mt-[4px] h-[40px] w-full rounded-[7px] border border-borda px-[10px] text-[12px] text-[#475569] outline-none focus:border-materna" />
                    </label>
                </div>
                <footer class="flex justify-end gap-[8px] border-t border-borda px-[20px] py-[14px]">
                    <button type="button" @click="cancelarResponsavel" class="h-[36px] rounded-[7px] border border-borda px-[14px] text-[12px] text-[#64748B]">Cancelar</button>
                    <button type="button" @click="confirmarResponsavel" class="h-[36px] rounded-[7px] bg-materna px-[14px] text-[12px] font-semibold text-white">Confirmar</button>
                </footer>
            </section>
        </div>

        <div v-if="modalUsuario" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/30 p-[20px]" @click.self="modalUsuario = false">
            <section class="w-full max-w-[640px] rounded-[14px] bg-white shadow-xl">
                <header class="flex items-start justify-between px-[34px] pb-[24px] pt-[26px]">
                    <div class="flex gap-[14px]">
                        <div class="flex h-[48px] w-[48px] shrink-0 items-center justify-center rounded-full bg-[#FFF1F2] text-materna">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                <circle cx="9" cy="8" r="3" stroke="currentColor" stroke-width="1.7"/>
                                <path d="M3.5 18V16.5C3.5 13.74 5.74 11.5 8.5 11.5H9.5C12.26 11.5 14.5 13.74 14.5 16.5V18" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                                <path d="M17 8V14M14 11H20" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <h2 class="text-[20px] font-bold text-[#1F2937]">
                                {{ usuarioIndiceEdicao === null ? 'Adicionar Novo Usuário' : 'Editar Usuário' }}
                            </h2>
                            <p class="mt-[6px] max-w-[430px] text-[13px] leading-[20px] text-[#64748B]">
                                Cadastre um novo colaborador para gerenciar e acessar o painel institucional
                            </p>
                        </div>
                    </div>
                    <button type="button" @click="modalUsuario = false" class="grid h-[36px] w-[36px] place-items-center rounded-full text-[28px] leading-none text-[#9CA3AF] hover:bg-slate-50">×</button>
                </header>

                <form class="px-[34px] pb-[26px]" @submit.prevent="salvarUsuario">
                    <div class="grid grid-cols-1 gap-[14px]">
                        <label class="text-[13px] font-semibold text-[#374151]">Nome Completo *
                            <input v-model="usuarioFormulario.nome" required placeholder="Ex: Mariana Silveira"
                                class="mt-[8px] h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] text-[13px] font-normal text-[#475569] outline-none placeholder:text-[#94A3B8] focus:border-materna" />
                        </label>

                        <label class="text-[13px] font-semibold text-[#374151]">E-mail Corporativo de Acesso *
                            <input v-model="usuarioFormulario.email" type="email" required placeholder="mariana.silveira@bancoleite-a.org.br"
                                class="mt-[8px] h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] text-[13px] font-normal text-[#475569] outline-none placeholder:text-[#94A3B8] focus:border-materna" />
                        </label>

                        <div class="grid grid-cols-1 gap-[14px] md:grid-cols-2">
                            <label class="text-[13px] font-semibold text-[#374151]">CPF *
                                <input v-model="usuarioFormulario.cpf" required placeholder="000.000.000-00"
                                    class="mt-[8px] h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] text-[13px] font-normal text-[#475569] outline-none placeholder:text-[#94A3B8] focus:border-materna" />
                            </label>
                            <label class="text-[13px] font-semibold text-[#374151]">Telefone / WhatsApp
                                <input v-model="usuarioFormulario.telefone" placeholder="(11) 90000-0000"
                                    class="mt-[8px] h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] text-[13px] font-normal text-[#475569] outline-none placeholder:text-[#94A3B8] focus:border-materna" />
                            </label>
                        </div>

                        <template v-if="usuarioIndiceEdicao === null">
                            <div class="grid grid-cols-1 gap-[14px] md:grid-cols-2">
                                <label class="text-[13px] font-semibold text-[#374151]">Senha Provisória *
                                    <div class="relative mt-[8px]">
                                        <input v-model="usuarioFormulario.senha" :type="mostrarSenha ? 'text' : 'password'" required
                                            class="h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] pr-[44px] text-[13px] font-normal text-[#475569] outline-none focus:border-materna" />
                                        <button type="button" @click="mostrarSenha = !mostrarSenha" class="absolute right-[14px] top-1/2 -translate-y-1/2 text-[#94A3B8]" aria-label="Mostrar senha">
                                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
                                                <path d="M1.5 9C3.33 5.67 6 4 9 4C12 4 14.67 5.67 16.5 9C14.67 12.33 12 14 9 14C6 14 3.33 12.33 1.5 9Z" stroke="currentColor" stroke-width="1.3"/>
                                                <circle cx="9" cy="9" r="2" stroke="currentColor" stroke-width="1.3"/>
                                            </svg>
                                        </button>
                                    </div>
                                </label>
                                <label class="text-[13px] font-semibold text-[#374151]">Confirmar Senha *
                                    <div class="relative mt-[8px]">
                                        <input v-model="usuarioFormulario.confirmarSenha" :type="mostrarConfirmarSenha ? 'text' : 'password'" required
                                            class="h-[50px] w-full rounded-[10px] border border-[#DCE2E8] px-[14px] pr-[44px] text-[13px] font-normal text-[#475569] outline-none focus:border-materna" />
                                        <button type="button" @click="mostrarConfirmarSenha = !mostrarConfirmarSenha" class="absolute right-[14px] top-1/2 -translate-y-1/2 text-[#94A3B8]" aria-label="Mostrar confirmação de senha">
                                            <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
                                                <path d="M1.5 9C3.33 5.67 6 4 9 4C12 4 14.67 5.67 16.5 9C14.67 12.33 12 14 9 14C6 14 3.33 12.33 1.5 9Z" stroke="currentColor" stroke-width="1.3"/>
                                                <circle cx="9" cy="9" r="2" stroke="currentColor" stroke-width="1.3"/>
                                            </svg>
                                        </button>
                                    </div>
                                </label>
                            </div>
                        </template>

                        <label v-if="usuarioIndiceEdicao !== null" class="text-[13px] font-semibold text-[#374151]">Perfil de acesso
                            <select v-model="usuarioFormulario.tipo" class="mt-[8px] h-[50px] w-full rounded-[10px] border border-[#DCE2E8] bg-white px-[14px] text-[13px] font-normal text-[#475569] outline-none focus:border-materna">
                                <option>Administrador</option>
                                <option>Operador</option>
                                <option>Ativo</option>
                            </select>
                        </label>
                    </div>

                    <footer class="mt-[24px] flex justify-end gap-[12px]">
                        <button type="button" @click="modalUsuario = false" class="h-[44px] rounded-[8px] border border-borda px-[24px] text-[13px] font-medium text-[#64748B]">Cancelar</button>
                        <button type="submit" class="flex h-[44px] items-center gap-[8px] rounded-[8px] bg-materna px-[22px] text-[13px] font-semibold text-white">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                                <path d="M8 14L2.5 3.5L5.5 5.5L8 1.5L10.5 5.5L13.5 3.5L8 14Z" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>
                                <path d="M8 6V11" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>
                            </svg>
                            Salvar e Enviar Acesso
                        </button>
                    </footer>
                </form>
            </section>
        </div>
    </main>
</template>