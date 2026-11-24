<script setup>
import { ref } from 'vue';
import { atualizarStatusJornada } from '@/services/jornadaService'
    const props = defineProps({
        jornada:{
            type: Object,
            required:true
        }
    })

    const ficaAtivo = ref(Number(props.jornada.is_ativo) ===1)

   async function alterarStatus() {
    const statusAnterior = ficaAtivo.value
    const novoStatus = !statusAnterior

    // Atualiza o visual imediatamente
    ficaAtivo.value = novoStatus

    try {
        const resposta = await atualizarStatusJornada(
            props.jornada.id,
            novoStatus
        )
        
        if (!resposta || !resposta.status) {
            throw new Error('Não foi possível atualizar a jornada.')
        }

    } catch (error) {
        // Se a API falhar, restaura o estado anterior
        ficaAtivo.value = statusAnterior

        console.error('Erro ao atualizar o status:', error)
    }
}
</script>

<template>
    <article 
    class="w-full max-w-[491px] h-[502px] flex flex-col bg-[#FFFFFF] border-2 border-borda rounded-[12px] p-[24px]">
        <nav class="flex flex-row justify-between mb-[16px] bg-blac">
            <div>
                <h2 class="text-[18px] font-bold">{{ jornada.nome }}</h2>
                <span class="text-[14px] font-regular">{{ jornada.descricao }}</span>
            </div>
            <div>
                <div class="flex flex-col items-end gap-2">
                    <span class="h-[26px] flex items-center justify-center gap-[6px] py-[4px] px-[10px] rounded-full"
                    :class="ficaAtivo
                    ? 'bg-materna/10 text-materna border border-materna'
                    : 'bg-[#ECEEEF] text-[#404849] border-2 border-[#C1C7C8]'">

                        <span
                            class="w-[6px] h-[6px] rounded-full shrink-0"
                            :class="ficaAtivo
                                ? 'bg-materna'
                                : 'bg-[#C1C7C8]'"
                        ></span>
                        {{ ficaAtivo ? 'Ativa' : 'Inativa' }}
                    </span>

                    <button
                    type="button"
                    role="switch"
                    :aria-checked="ficaAtivo"
                    @click="alterarStatus"
                    class="w-[42px] h-[23px] rounded-full flex items-center px-[3px] transition-colors"
                    :class="ficaAtivo ? 'bg-materna' : 'bg-[#D1D5DB]'">
                        <span
                        class="w-[17px] h-[17px] rounded-full bg-white transition-transform"
                        :class="ficaAtivo ? 'translate-x-[19px]' : 'translate-x-0'"
                        ></span>
                    </button>
                </div>
            </div>
        </nav>

        <main class="flex flex-col gap-[24px] min-h-0 overflow-y-auto">
            <div class="flex flex-row items-center gap-[16px]">
                <div class="w-[32px] h-[32px] shrink-0 bg-[#F0F9F8] flex justify-center items-center rounded-full">
                    <img class="w-[15px]" src="@/assets/jornada/livro.svg" alt="Um Icon de um livro aberto">
                </div>
                <div class="flex flex-col">
                    <span class="text-[14px] font-medium">Conheça a doação</span>
                    <p class="text-[12px] text-[#6F797A]">O que é, e por que a doação de leite humano é importante.</p>
                </div>
            </div>

            <div class="flex flex-row items-center gap-[16px]">
                <div class="w-[32px] h-[32px] shrink-0 bg-[#ECEEEF] flex justify-center items-center rounded-full">
                    <img class="w-[15px]" src="@/assets/jornada/orientacoes.svg" alt="Um icon de prancheta">
                </div>
                <div class="flex flex-col">
                    <span class="text-[14px] font-medium">Orientações</span>
                    <p class="text-[12px] text-[#6F797A]">Higiene, coleta, armazenamento, transporte e entrega.</p>
                </div>
            </div>

            <div class="flex flex-row items-center gap-[16px]">
                <div class="w-[32px] h-[32px] shrink-0 bg-[#FFF7ED] flex justify-center items-center rounded-full">
                    <img class="w-[15px]" src="@/assets/jornada/arquivo.svg" alt="Um icon que representa os arquivos">
                </div>
                <div class="flex flex-col">
                    <span class="text-[14px] font-medium">Questionário inicial</span>
                    <p class="text-[12px] text-[#6F797A]">Triagem informativa sobre o processo.</p>
                </div>
            </div>

            <div
            v-for="etapas in jornada.etapas"
            class="flex flex-row items-center gap-[16px]">
                <div class="w-[32px] h-[32px] shrink-0 bg-[#FEF2F2] flex justify-center items-center rounded-full">
                    <img class="w-[15px]" src="@/assets/jornada/bandeira.svg" alt="Um icon que representa os arquivos">
                </div>
                <div class="flex flex-col">
                    <span class="text-[14px] font-medium">{{ etapas.titulo }}</span>
                    <p class="text-[12px] text-[#6F797A]">{{ etapas.descricao }}</p>
                </div>
            </div>
        </main>
    </article>
</template>