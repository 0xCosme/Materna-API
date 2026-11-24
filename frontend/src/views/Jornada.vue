<script setup>
import CadastroJornada from '@/components/jornada/CadastroJornada.vue';
import CardJornada from '@/components/jornada/CardJornada.vue';
import { listarJornada } from '@/services/jornadaService';
import { onMounted, ref } from 'vue';

const mostrarCadastroJornada = ref(false)

const jornada = ref([])
    onMounted(async () => {
        try {
            jornada.value = await listarJornada(1)
        } catch (error) {
            console.error(error)
        }
    })

</script>

<template>
    <main class="bg-[#F8FAFC] p-[30px] w-full min-h-full">
        <nav class="flex justify-between gap-[10px]"
            v-if="!mostrarCadastroJornada">
            <span class="text-[16px] text-texto-claro">Monte as etapas que a doadora percorre no aplicativo até o atendimento.</span>
            
            <button 
            @click="mostrarCadastroJornada = true"
            class="group bg-materna px-[16px] py-[8px] flex justify-center items-center rounded-[8px] gap-[8px] hover:bg-pink-50 hover:text-slate-600 transition-colors">
                <img class="h-[16px] w-[14px] transition-all group-hover:brightness-0 group-hover:opacity-60" src="@/assets/campanha/+.svg" alt="Icon de +">
                <p class="text-white group-hover:text-slate-600 font-medium text-[14px]">Nova jornada</p>
            </button>
        </nav>
        
        <Transition 
        enter-active-class="transition-all duration-300 ease-out"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0">
            <CadastroJornada
            v-if="mostrarCadastroJornada"
            @fechar="mostrarCadastroJornada = false"/>
        </Transition>
        
        <div class="flex flex-wrap gap-[25px] justify-center mt-[30px]">
            <CardJornada
            v-for="itensJornada in jornada"
            :key="itensJornada.id"
            :jornada="itensJornada"/>
        </div>
        
    </main>
</template>