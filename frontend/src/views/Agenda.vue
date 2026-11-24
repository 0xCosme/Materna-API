<script setup>
import { computed, ref } from 'vue'

const dataSelecionada = ref('2026-08-25')
const mesSelecionado = ref('2026-08')
const calendarioAberto = ref(false)
const anoCalendario = ref(2026)
const mesCalendario = ref(1)

const meses = [
  { valor: '2026-01', rotulo: 'Janeiro' },
  { valor: '2026-02', rotulo: 'Fevereiro' },
  { valor: '2026-03', rotulo: 'Março' },
  { valor: '2026-04', rotulo: 'Abril' },
  { valor: '2026-05', rotulo: 'Maio' },
  { valor: '2026-06', rotulo: 'Junho' },
  { valor: '2026-07', rotulo: 'Julho' },
  { valor: '2026-08', rotulo: 'Agosto' },
  { valor: '2026-09', rotulo: 'Setembro' },
  { valor: '2026-10', rotulo: 'Outubro' },
  { valor: '2026-11', rotulo: 'Novembro' },
  { valor: '2026-12', rotulo: 'Dezembro' }
]

const mesSelecionadoTexto = computed(() => {
  return meses.find(mes => mes.valor === mesSelecionado.value)?.rotulo || ''
})

const anosCalendario = computed(() => {
  return [anoCalendario.value - 1, anoCalendario.value, anoCalendario.value + 1]
})

const diasCalendario = computed(() => {
  const primeiroDia = new Date(anoCalendario.value, mesCalendario.value - 1, 1)
  const ultimoDia = new Date(anoCalendario.value, mesCalendario.value, 0).getDate()
  const inicioVazio = (primeiroDia.getDay() + 6) % 7
  const dias = []

  for (let indice = 0; indice < inicioVazio; indice += 1) dias.push(null)
  for (let dia = 1; dia <= ultimoDia; dia += 1) dias.push(dia)

  return dias
})

const datas = computed(() => {
  const dataSelecionadaAtual = new Date(`${dataSelecionada.value}T12:00:00`)
  return [-1, 0, 1].map(deslocamento => {
    const data = new Date(dataSelecionadaAtual)
    data.setDate(data.getDate() + deslocamento)

    const ano = data.getFullYear()
    const mes = String(data.getMonth() + 1).padStart(2, '0')
    const dia = String(data.getDate()).padStart(2, '0')
    const diaSemana = data
      .toLocaleDateString('pt-BR', { weekday: 'short' })
      .replace('.', '')
      .replace(/^./, letra => letra.toUpperCase())

    return {
      diaSemana,
      dia,
      data: `${ano}-${mes}-${dia}`
    }
  })
})

const agendamentos = ref([
  {
    id: 1,
    data: '2026-01-25',
    horario: '09:00',
    nome: 'Ana Souza',
    descricao: '#1024 - Doação de leite humano',
    modalidade: 'Presencial',
    status: 'Confirmado'
  },
  {
    id: 2,
    data: '2026-01-25',
    horario: '10:00',
    nome: 'Maria Silva',
    descricao: '#1039 - Doação de leite humano',
    modalidade: 'Domicílio',
    status: 'Confirmado'
  },
  {
    id: 3,
    data: '2026-01-25',
    horario: '11:00',
    nome: 'Gabriela Ribeiro',
    descricao: '#1036 - Orientação inicial',
    modalidade: 'Domicílio',
    status: 'Pendente'
  },
  {
    id: 4,
    data: '2026-01-25',
    horario: '14:00',
    nome: 'Carla Nunes',
    descricao: '#1031 - Doação de leite humano',
    modalidade: 'Presencial',
    status: 'Confirmado'
  }
])

const novoHorario = ref({
  data: '26/01/2026',
  jornada: '',
  horario: '09:00'
})

const secaoAgenda = ref('Atendimentos do dia')
const filtroEtapa = ref('Todas')
const filtroStatus = ref('Todos')
const horariosCadastrados = ref([
  {
    id: 1,
    data: '2026-08-25',
    horario: '09:00',
    horarioFim: '09:45',
    jornada: 'Doação de leite humano',
    etapa: 'Coleta (Etapa Obrigatória)',
    agendamentos: ['Ana Souza #1028', 'Joana Prado #1035'],
    status: 'Lotado'
  },
  {
    id: 2,
    data: '2026-08-25',
    horario: '10:00',
    horarioFim: '10:45',
    jornada: 'Doação de leite humano',
    etapa: 'Coleta (Etapa Obrigatória)',
    agendamentos: ['Maria Silva #1035'],
    status: '1 vaga restante'
  },
  {
    id: 3,
    data: '2026-08-25',
    horario: '11:00',
    horarioFim: '11:45',
    jornada: 'Orientação inicial / Apoio à amamentação',
    etapa: 'Etapa Cadastrada: Orientação Inicial',
    agendamentos: ['Gabriela Ribeiro #1030'],
    status: 'Lotado'
  },
  {
    id: 4,
    data: '2026-08-25',
    horario: '14:00',
    horarioFim: '14:45',
    jornada: 'Doação de leite humano',
    etapa: 'Coleta (Etapa Obrigatória)',
    agendamentos: ['Carla Nunes #1031', 'Beatriz Costa #1032'],
    status: 'Lotado'
  },
  {
    id: 5,
    data: '2026-08-25',
    horario: '15:00',
    horarioFim: '15:45',
    jornada: 'Doação de leite humano',
    etapa: 'Coleta (Etapa Obrigatória)',
    agendamentos: [],
    status: 'Disponível (2 livres)'
  },
  {
    id: 6,
    data: '2026-08-25',
    horario: '16:00',
    horarioFim: '16:45',
    jornada: 'Doação de leite humano',
    etapa: 'Coleta (Etapa Obrigatória)',
    agendamentos: [],
    status: 'Disponível (2 livres)'
  }
])

const agendamentosFiltrados = computed(() => {
  if (secaoAgenda.value === 'Horários cadastrados') return []

  return agendamentos.value.filter(item => item.data === dataSelecionada.value)
})

const horariosFiltrados = computed(() => {
  return horariosCadastrados.value.filter(item => {
    const dataCorreta = item.data === dataSelecionada.value
    const etapaCorreta = filtroEtapa.value === 'Todas'
      || item.etapa?.includes(filtroEtapa.value)
    const statusCorreto = filtroStatus.value === 'Todos'
      || (filtroStatus.value === 'Lotado' && item.status === 'Lotado')
      || (filtroStatus.value === 'Disponível' && item.status.startsWith('Disponível'))

    return dataCorreta && etapaCorreta && statusCorreto
  })
})

function aceitarAgendamento(item) {
  item.status = 'Confirmado'
}

function recusarAgendamento(item) {
  item.status = 'Cancelado'
}

function selecionarDataCalendario(evento) {
  const data = evento.target.value
  if (!data) return

  const [ano, mes, dia] = data.split('-')
  dataSelecionada.value = data
  mesSelecionado.value = `${ano}-${mes}`
  novoHorario.value.data = `${dia}/${mes}/${ano}`
}

function alterarMes(evento) {
  mesSelecionado.value = evento.target.value

  const [ano, mes] = mesSelecionado.value.split('-')
  const dataAtual = new Date(`${dataSelecionada.value}T12:00:00`)
  const diaAtual = dataAtual.getDate()
  const ultimoDia = new Date(Number(ano), Number(mes), 0).getDate()
  const novoDia = Math.min(diaAtual, ultimoDia)

  dataSelecionada.value = `${ano}-${mes}-${String(novoDia).padStart(2, '0')}`
  novoHorario.value.data = `${String(novoDia).padStart(2, '0')}/${mes}/${ano}`
}

function abrirCalendario() {
  const [ano, mes] = dataSelecionada.value.split('-')
  anoCalendario.value = Number(ano)
  mesCalendario.value = Number(mes)
  calendarioAberto.value = !calendarioAberto.value
}

function selecionarMesCalendario(mes) {
  mesCalendario.value = mes
}

function selecionarAnoCalendario(ano) {
  anoCalendario.value = Number(ano)
}

function selecionarDiaCalendario(dia) {
  if (!dia) return

  const ano = anoCalendario.value
  const mes = String(mesCalendario.value).padStart(2, '0')
  const diaFormatado = String(dia).padStart(2, '0')

  dataSelecionada.value = `${ano}-${mes}-${diaFormatado}`
  mesSelecionado.value = `${ano}-${mes}`
  novoHorario.value.data = `${diaFormatado}/${mes}/${ano}`
  calendarioAberto.value = false
}

function selecionarDia(data) {
  dataSelecionada.value = data
  const [ano, mes, dia] = data.split('-')
  mesSelecionado.value = `${ano}-${mes}`
  novoHorario.value.data = `${dia}/${mes}/${ano}`
}

function criarHorario(formulario) {
  if (!formulario.horario) return

  const [dia, mes, ano] = formulario.data.split('/')
  horariosCadastrados.value.push({
    id: Date.now(),
    data: `${ano}-${mes}-${dia}`,
    horario: formulario.horario,
    jornada: formulario.jornada
  })

  formulario.horario = ''
  formulario.jornada = ''
}
</script>

<template>
  <main class="min-h-full w-full bg-[#F8FAFC] p-[30px]">
    <section
      v-if="secaoAgenda === 'Horários cadastrados'"
      class="mb-[16px] grid grid-cols-3 gap-[16px]"
    >
      <article class="flex h-[90px] items-center justify-between rounded-[10px] border border-borda bg-white px-[20px]">
        <div>
          <p class="text-[13px] text-[#94A3B8]">Horários na Semana</p>
          <div class="mt-[4px] flex items-end gap-[6px]">
            <strong class="text-[28px] leading-none text-slate-700">38</strong>
            <span class="pb-[2px] text-[11px] text-[#94A3B8]">slots</span>
          </div>
        </div>
        <div class="flex h-[38px] w-[38px] items-center justify-center rounded-full bg-[#F8FAFC] text-materna">
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
            <rect x="3" y="4" width="12" height="11" rx="2" stroke="currentColor" stroke-width="1.5"/>
            <path d="M6 2V5M12 2V5M3 7H15" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </div>
      </article>

      <article class="flex h-[90px] items-center justify-between rounded-[10px] border border-borda bg-white px-[20px]">
        <div>
          <p class="text-[13px] text-[#94A3B8]">Vagas Ocupadas</p>
          <div class="mt-[4px] flex items-end gap-[8px]">
            <strong class="text-[28px] leading-none text-slate-700">29</strong>
            <span class="pb-[2px] text-[11px] text-[#22A06B]">76%</span>
          </div>
        </div>
        <div class="flex h-[38px] w-[38px] items-center justify-center rounded-full bg-[#ECFDF3] text-[#22A06B]">
          <span class="text-[20px]">↗</span>
        </div>
      </article>

      <article class="flex h-[90px] items-center justify-between rounded-[10px] border border-borda bg-white px-[20px]">
        <div>
          <p class="text-[13px] text-[#94A3B8]">Vagas Disponíveis</p>
          <div class="mt-[4px] flex items-end gap-[8px]">
            <strong class="text-[28px] leading-none text-slate-700">9</strong>
            <span class="pb-[2px] text-[11px] text-[#E37A86]">livres</span>
          </div>
        </div>
        <div class="flex h-[38px] w-[38px] items-center justify-center rounded-full bg-[#FFF2F3] text-materna">
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
            <circle cx="9" cy="9" r="6.5" stroke="currentColor" stroke-width="1.4"/>
            <path d="M9 5.5V9.25L12 11" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
      </article>

    </section>

    <div class="mb-[30px] grid grid-cols-1 items-center gap-[16px] xl:grid-cols-[minmax(0,1fr)_320px]">
      <div class="flex min-w-0 items-center justify-between gap-[12px]">
        <p class="min-w-[300px] text-[14px] text-texto-claro">
          Gerencie os atendimentos e a disponibilidade de horários.
        </p>

        <div class="flex shrink-0 items-center gap-[8px]">
          <div class="relative">
            <button
              type="button"
              class="flex h-[42px] items-center gap-[8px] rounded-full border border-borda bg-white px-[12px]"
              aria-label="Abrir calendário"
              @click="abrirCalendario"
            >
              <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
                <rect x="3" y="4" width="12" height="11" rx="2" stroke="#DE6771" stroke-width="1.5"/>
                <path d="M6 2V5M12 2V5M3 7H15" stroke="#DE6771" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
              <span class="text-[12px] font-medium uppercase text-texto-claro">
                {{ mesSelecionadoTexto }}
              </span>
            </button>

            <div
              v-if="calendarioAberto"
              class="absolute right-0 top-[48px] z-20 w-[300px] rounded-[14px] border border-borda bg-white p-[14px] shadow-lg"
            >
              <div class="mb-[10px] flex items-center justify-between">
                <button type="button" class="grid h-[28px] w-[28px] place-items-center text-slate-500" @click="anoCalendario -= 1">‹</button>
                <select
                  :value="anoCalendario"
                  class="h-[32px] rounded-[6px] border border-borda px-[8px] text-[12px]"
                  @change="selecionarAnoCalendario($event.target.value)"
                >
                  <option v-for="ano in anosCalendario" :key="ano" :value="ano">{{ ano }}</option>
                </select>
                <button type="button" class="grid h-[28px] w-[28px] place-items-center text-slate-500" @click="anoCalendario += 1">›</button>
              </div>

              <div class="mb-[10px] grid grid-cols-4 gap-[4px]">
                <button
                  v-for="mes in meses"
                  :key="mes.valor"
                  type="button"
                  class="h-[30px] rounded-[6px] text-[10px]"
                  :class="mesCalendario === Number(mes.valor.slice(5))
                    ? 'bg-materna text-white'
                    : 'bg-slate-50 text-texto-claro'"
                  @click="selecionarMesCalendario(Number(mes.valor.slice(5)))"
                >
                  {{ mes.rotulo.slice(0, 3) }}
                </button>
              </div>

              <div class="grid grid-cols-7 text-center text-[10px] font-medium text-texto-claro">
                <span>Seg</span><span>Ter</span><span>Qua</span><span>Qui</span><span>Sex</span><span>Sáb</span><span>Dom</span>
              </div>
              <div class="mt-[4px] grid grid-cols-7 gap-y-[2px]">
                <button
                  v-for="(dia, indice) in diasCalendario"
                  :key="indice"
                  type="button"
                  class="h-[32px] rounded-full text-[12px]"
                  :class="dia
                    ? dataSelecionada === `${anoCalendario}-${String(mesCalendario).padStart(2, '0')}-${String(dia).padStart(2, '0')}`
                      ? 'bg-materna text-white'
                      : 'hover:bg-pink-50'
                    : 'cursor-default'"
                  :disabled="!dia"
                  @click="selecionarDiaCalendario(dia)"
                >
                  {{ dia }}
                </button>
              </div>
            </div>
          </div>

          <button
            v-for="item in datas"
            :key="item.data"
            type="button"
            class="h-[42px] rounded-full border border-borda px-[12px] text-[14px]"
            :class="dataSelecionada === item.data
              ? 'bg-materna text-white'
              : 'bg-white text-slate-700'"
            @click="selecionarDia(item.data)"
          >
            {{ item.diaSemana }} {{ item.dia }}
          </button>
        </div>
      </div>

      <div class="flex h-[42px] justify-end rounded-full border border-borda bg-[#FFF7F8] p-[4px]">
        <button
          type="button"
          class="h-[32px] rounded-full px-[12px] text-[12px] leading-[16px]"
          :class="secaoAgenda === 'Atendimentos do dia'
            ? 'bg-white border border-borda text-materna shadow-[0_1px_2px_rgba(15,23,42,0.04)]'
            : 'text-texto-claro'"
          @click="secaoAgenda = 'Atendimentos do dia'"
        >
          Atendimentos do dia
        </button>
        <button
          type="button"
          class="h-[32px] rounded-full px-[12px] text-[12px] leading-[16px]"
          :class="secaoAgenda === 'Horários cadastrados'
            ? 'bg-white border border-borda text-materna shadow-[0_1px_2px_rgba(15,23,42,0.04)]'
            : 'text-texto-claro'"
          @click="secaoAgenda = 'Horários cadastrados'"
        >
          Horários cadastrados
        </button>
      </div>
    </div>

    <div
      v-if="secaoAgenda === 'Horários cadastrados'"
      class="mb-[16px] flex w-full flex-wrap items-center gap-[8px]"
    >
      <div class="relative w-full sm:w-[190px]">
        <select
          v-model="filtroEtapa"
          class="h-[38px] w-full appearance-none rounded-[8px] border border-borda bg-white px-[14px] pr-[36px] text-[13px] text-[#64748B] outline-none focus:border-[#CBD5E1] focus:ring-0"
        >
          <option value="Todas">Todas as etapas</option>
          <option value="Coleta">Coleta</option>
          <option value="Orientação">Orientação</option>
        </select>
        <svg class="pointer-events-none absolute right-[12px] top-1/2 h-[14px] w-[14px] -translate-y-1/2 text-[#94A3B8]" viewBox="0 0 16 16" fill="none" aria-hidden="true">
          <path d="M4 6L8 10L12 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>

      <div class="relative w-full sm:w-[190px]">
        <select
          v-model="filtroStatus"
          class="h-[38px] w-full appearance-none rounded-[8px] border border-borda bg-white px-[14px] pr-[36px] text-[13px] text-[#64748B] outline-none focus:border-[#CBD5E1] focus:ring-0"
        >
          <option value="Todos">Todos os status</option>
          <option value="Lotado">Lotado</option>
          <option value="Disponível">Disponível</option>
        </select>
        <svg class="pointer-events-none absolute right-[12px] top-1/2 h-[14px] w-[14px] -translate-y-1/2 text-[#94A3B8]" viewBox="0 0 16 16" fill="none" aria-hidden="true">
          <path d="M4 6L8 10L12 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>

    <div class="grid grid-cols-1 items-stretch gap-[24px] xl:grid-cols-[minmax(0,1fr)_320px]">
      <article class="rounded-[16px] border border-borda bg-white p-[20px] shadow-[0_1px_2px_rgba(15,23,42,0.02)]">
        <h2 class="mb-[16px] text-[18px] font-bold">
          {{ secaoAgenda }}
        </h2>

        <div class="flex flex-col gap-[12px]">
          <template v-if="secaoAgenda === 'Horários cadastrados'">
            <div class="grid grid-cols-[150px_minmax(220px,1fr)_minmax(220px,1fr)_180px] border-b border-borda pb-[10px] text-[11px] font-medium uppercase text-texto-claro">
              <span>Horário</span>
              <span>Serviço &amp; etapa vinculada</span>
              <span>Agendamentos vinculados</span>
              <span>Status da vaga</span>
            </div>
            <div
              v-for="item in horariosFiltrados"
              :key="item.id"
              class="grid min-h-[78px] grid-cols-[150px_minmax(220px,1fr)_minmax(220px,1fr)_180px] items-center border-b border-borda last:border-b-0"
            >
              <div class="flex items-center gap-[8px] text-[12px] font-medium text-texto-claro">
                <span class="flex h-[20px] w-[20px] shrink-0 items-center justify-center rounded-full border border-slate-300">
                  <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true">
                    <circle cx="6" cy="6" r="4.25" stroke="currentColor" stroke-width="1"/>
                    <path d="M6 3.5V6.25L8 7.25" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </span>
                {{ item.horario }} - {{ item.horarioFim }}
              </div>
              <div class="min-w-0">
                <p class="text-[12px] font-medium text-slate-700">{{ item.jornada || 'Etapa não informada' }}</p>
                <p class="mt-[4px] w-fit rounded-full bg-[#FFF3F4] px-[8px] py-[3px] text-[9px] text-[#B46A6A]">
                  <span class="mr-[4px] text-materna">●</span>{{ item.etapa }}
                </p>
              </div>
              <div class="flex min-w-0 flex-wrap gap-[6px] pr-[12px]">
                <template v-if="item.agendamentos.length">
                  <span
                    v-for="agendamento in item.agendamentos"
                    :key="agendamento"
                    class="rounded-full border border-borda bg-slate-50 px-[8px] py-[4px] text-[9px] text-texto-claro"
                  >
                    {{ agendamento }}
                  </span>
                </template>
                <p v-else class="text-[10px] text-[#94A3B8]">Nenhuma doadora alocada</p>
              </div>
              <div>
                <span
                  class="rounded-full px-[8px] py-[4px] text-[10px]"
                  :class="item.status.startsWith('Disponível')
                    ? 'border border-[#8CD8B9] bg-[#F0FBF7] text-[#459E7E]'
                    : item.status === 'Lotado'
                      ? 'bg-[#FEECEF] text-[#D85F68]'
                      : 'bg-[#FFF1E7] text-[#D58A55]'"
                >
                  {{ item.status === 'Lotado' ? 'Lotado' : item.status }}
                </span>
              </div>
            </div>
            <p
              v-if="horariosFiltrados.length === 0"
              class="py-[30px] text-center text-[14px] text-texto-claro"
            >
              Nenhum horário cadastrado para esta data.
            </p>
          </template>

          <div
            v-if="secaoAgenda === 'Atendimentos do dia'"
            v-for="item in agendamentosFiltrados"
            :key="item.id"
            class="flex min-h-[78px] items-center rounded-[12px] border border-borda bg-white px-[16px] transition-colors hover:bg-slate-50"
          >
            <div class="mr-[16px] flex w-[70px] items-center gap-[8px] text-[13px] text-texto-claro">
              <span class="h-[8px] w-[8px] rounded-full border border-slate-400"></span>
              {{ item.horario }}
            </div>

            <div class="min-w-0 flex-1">
              <p class="text-[13px] font-bold">{{ item.nome }}</p>
              <p class="mt-[2px] text-[11px] text-texto-claro">{{ item.descricao }}</p>
            </div>

            <div v-if="item.status === 'Pendente'" class="mr-[8px] flex items-center gap-[8px]">
              <span class="flex h-[34px] items-center gap-[7px] rounded-full border border-[#FED7AA] bg-[#FFF7ED] px-[10px] text-[12px] font-medium text-[#C86A32]">
                <span class="h-[7px] w-[7px] rounded-full bg-[#F97316]"></span>
                Pendente
              </span>
              <button
                type="button"
                class="flex h-[34px] items-center gap-[5px] rounded-[7px] border border-[#BDE9C9] bg-[#ECFDF3] px-[10px] text-[12px] font-medium text-[#3BAA62] transition-colors hover:bg-[#DDF7E5]"
                @click="aceitarAgendamento(item)"
              >
                <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true">
                  <path d="M2.25 6L4.75 8.5L9.75 3.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Aceitar
              </button>
              <button
                type="button"
                class="flex h-[34px] items-center gap-[5px] rounded-[7px] border border-[#FECACA] bg-[#FEF2F2] px-[10px] text-[12px] font-medium text-[#DC2626] transition-colors hover:bg-[#FFE7E7]"
                @click="recusarAgendamento(item)"
              >
                <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true">
                  <path d="M3 3L9 9M9 3L3 9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
                </svg>
                Recusar
              </button>
            </div>

            <span
              v-else
              class="mr-[8px] flex w-[112px] items-center justify-center gap-[6px] rounded-full border px-[8px] py-[4px] text-[12px]"
              :class="item.status === 'Confirmado'
                ? 'border-[#BDE9C9] bg-[#ECFDF3] text-[#3BAA62]'
                : 'border-[#FECACA] bg-[#FEF2F2] text-[#DC2626]'"
            >
              <span
                class="h-[6px] w-[6px] rounded-full"
                :class="item.status === 'Confirmado' ? 'bg-[#55B87A]' : 'bg-[#EF4444]'"
              ></span>
              {{ item.status }}
            </span>
          </div>

          <p
            v-if="secaoAgenda === 'Atendimentos do dia' && agendamentosFiltrados.length === 0"
            class="py-[30px] text-center text-[14px] text-texto-claro"
          >
            Nenhum atendimento encontrado para esta data.
          </p>
        </div>
      </article>

      <aside class="h-full">
        <form
          class="flex h-full flex-col overflow-hidden rounded-[16px] border border-borda bg-white shadow-[0_1px_2px_rgba(15,23,42,0.02)]"
          @submit.prevent="criarHorario(novoHorario)"
        >
          <header class="border-b border-borda px-[20px] py-[16px]">
            <h2 class="flex items-center text-[16px] font-bold">
              <span class="mr-[8px] flex h-[24px] w-[24px] items-center justify-center rounded-full bg-[#FFF2F3] text-[16px] text-materna">＋</span>
              Novo horário
            </h2>
          </header>

          <div class="flex flex-1 flex-col gap-[12px] p-[20px]">
            <div>
              <label class="mb-[4px] block text-[12px]">Data</label>
              <input v-model="novoHorario.data" type="text" class="h-[40px] w-full rounded-[7px] border border-borda px-[12px] text-[12px] outline-none focus:border-materna">
            </div>

            <div>
              <label class="mb-[4px] block text-[12px]">Etapa da jornada</label>
              <select v-model="novoHorario.jornada" class="h-[40px] w-full rounded-[7px] border border-borda bg-white px-[12px] text-[12px] outline-none focus:border-materna">
                <option value="">Selecione uma etapa</option>
                <option>Triagem</option>
                <option>Coleta</option>
                <option>Orientação</option>
              </select>
            </div>

            <div>
              <label class="mb-[4px] block text-[12px]">Horário</label>
              <input v-model="novoHorario.horario" type="time" class="h-[40px] w-full rounded-[7px] border border-borda px-[12px] text-[12px] outline-none focus:border-materna">
            </div>

            <button type="submit" class="mt-[4px] h-[40px] w-full rounded-[7px] bg-materna text-[12px] font-bold text-white transition-colors hover:bg-[#C95B64]">
              Criar horário
            </button>
          </div>
        </form>
      </aside>
    </div>
  </main>
</template>