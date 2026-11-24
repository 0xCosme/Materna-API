<script setup>


import CadDoadora from '@/components/doadora/cadDoadora.vue';
import { ref } from 'vue';

const filtros = [
    'Todas',
    'Iniciadas',
    'Em andamento',
    'Ativas',
    'Finalizadas',
]

const filtroSelecionado = ref('Todas')
</script>

<template>
    <main class="bg-[#F8FAFC] p-[30px] w-full min-h-full">
        <header class="flex justify-center">
            <section class="flex-wrap bg-white flex justify-between px-[4px] items-center w-full max-w-[524px] min-w-0 min-h-[43px] border border-borda rounded-[22px] ">
                <button
                v-for="itemFiltro in filtros"
                :key="itemFiltro"
                @click="filtroSelecionado = itemFiltro"
                :class="[
                    'whitespace-nowrap h-[33px] px-[20px] py-[6px] text-[14px] rounded-full transition-colors duration-200',
                    filtroSelecionado === itemFiltro
                        ? 'bg-materna text-white'
                        : 'bg-transparent text-slate-600'
                ]"
                >
                {{ itemFiltro }}
                </button>
            </section>
        </header>
        <div class="mt-[30px]">
            <CadDoadora/>
        </div>
    </main>
</template>