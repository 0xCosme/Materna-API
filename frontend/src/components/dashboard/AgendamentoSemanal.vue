<script setup>
import { computed } from 'vue'

// Aqui pode mudar pela API
const totalSemanaAtual = 3
const totalSemanaAnterior = 0

const dadosValidos = computed(() => {
  return (
    Number.isFinite(totalSemanaAtual) &&
    Number.isFinite(totalSemanaAnterior) &&
    totalSemanaAtual >= 0 &&
    totalSemanaAnterior >= 0
  )
})

const percentualDaSemana = computed(() =>{

    if (!dadosValidos.value) {
    return null
  }

    if (totalSemanaAnterior ===0){
        return totalSemanaAtual === 0? 0:null
    }
    let envioPercentual = ((totalSemanaAtual- totalSemanaAnterior)/totalSemanaAnterior)*100
    return envioPercentual
})

const textoPercentual = computed(() => {
    if(percentualDaSemana.value === null)
        return 'Sem dados da semana anterior'
    else if(percentualDaSemana.value > 0)
        return  `↗ +${percentualDaSemana.value.toFixed(0)}% vs. semana anterior`
    else if(percentualDaSemana.value < 0)
        return  `↘ ${percentualDaSemana.value.toFixed(0)}% vs. semana anterior`
    else 
        return '→ 0% vs. semana anterior'
})

const corPeloPercentual = computed(() => {
    if(percentualDaSemana.value === null)
        return 'text-gray-400'
    else if(percentualDaSemana.value >0)
        return 'text-[#57BA6A]'
    else if(percentualDaSemana.value <0)
        return 'text-materna'
    else
        return 'text-gray-400'
})

const agendamento = [
    {dia: 'Seg',quantidade: 5},
    {dia: 'Ter',quantidade: 1},
    {dia: 'Qua',quantidade: 5},
    {dia: 'Qui',quantidade: 7},
    {dia: 'Sex',quantidade: 6},
    {dia: 'Sáb',quantidade: 4},
]

const maiorQuantidade = Math.max(...agendamento.map(item => item.quantidade))
</script>

<template>
    <div class="w-full min-h-[352px] rounded-[16px] bg-white p-[24px] border border-gray-200">
        <h3 class="text-[18px] font-bold">Agendamentos da semana</h3>
        <p class="text-[14px]" :class="corPeloPercentual">{{textoPercentual}}</p>
        <div class="h-[220px] flex flex-row gap-[8px]">
            <div v-for="itemAgendamento in agendamento" :key="itemAgendamento.dia"
            class=" flex-1 h-full flex flex-col items-center justify-end">
                <div class="w-full max-w-[90px] bg-materna rounded-tl-[2px] rounded-tr-[2px]" 
                :style="{
                height: `${(itemAgendamento.quantidade / maiorQuantidade) * 100}%`
                }">
                </div>
                
            </div>
        </div>
       <hr class="my-4 border-1 border-gray-100 ">

        <div class="flex flex-row gap-[8px] mt-3">
            <div
                v-for="itemAgendamento in agendamento"
                :key="itemAgendamento.dia"
                class="flex-1 text-center"
            >
                <span class="text-texto-claro">{{ itemAgendamento.dia }}</span>
            </div>
        </div>
    </div>
</template>