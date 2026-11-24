<script setup>
import CadastroCampanha from '@/components/campanha/CadastroCampanha.vue';
import CardCampanha from '@/components/campanha/CardCampanha.vue';
import { listarCampanha, deletarCampanha } from '@/services/campanhaService';
import { nextTick, onMounted, ref } from 'vue';

const campanha = ref([])
const errou = ref('Não foi possíivel carregar as campanhas, por favor aguarde. (ligue a API)')
const mostrarCadastroCampanha = ref(false)
const cadastroRef = ref(null)

onMounted(async () => {
    try {
        campanha.value = await listarCampanha()
    } catch (error) {
        console.log(errou)
        console.error(error)
    }
})

const campanhaSelecionada = ref(null)

async function editarCampanha(dadosCampanha) {
    campanhaSelecionada.value = dadosCampanha
    mostrarCadastroCampanha.value = true

    await nextTick()

    cadastroRef.value?.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    })
}

async function excluirCampanha(id) {
    try {
        const resposta = await deletarCampanha(id)

        console.log('Campanha excluída:', resposta)

        campanha.value = await listarCampanha()

    } catch (error) {
        console.error('Erro ao excluir campanha:', error)
    }
}
</script>

<template>
    <main class="bg-[#F8FAFC] p-[30px] w-full min-h-full">
        <nav class="flex justify-between gap-[10px]"
            v-if="!mostrarCadastroCampanha">
            <span class="text-[16px] text-texto-claro">Divulgue campanhas de incentivo à doação para as doadoras no aplicativo.</span>
            
            <button 
            @click="
                campanhaSelecionada = null;
                mostrarCadastroCampanha = true
            "
            class="group bg-materna px-[16px] py-[8px] flex justify-center items-center rounded-[8px] gap-[8px] hover:bg-pink-50 hover:text-slate-600 transition-colors">
                <img class="h-[16px] w-[14px] transition-all group-hover:brightness-0 group-hover:opacity-60" src="@/assets/campanha/+.svg" alt="Icon de +">
                <p class="text-white group-hover:text-slate-600 font-medium text-[14px]">Nova campanha</p>
            </button>
        </nav>

        <Transition 
        enter-active-class="transition-all duration-300 ease-out"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        >
            <div ref="cadastroRef">
            <CadastroCampanha
                v-if="mostrarCadastroCampanha"
                :campanha-edicao="campanhaSelecionada"
                @fechar="mostrarCadastroCampanha = false"
            />
            </div>

        </Transition>

        <div class="flex flex-wrap gap-[25px] mt-[30px]">
            <CardCampanha 
            v-for="itensCampanha in campanha"
            :key="itensCampanha.id"
            :campanha="itensCampanha"
            @deletar="excluirCampanha"
            @editar="editarCampanha"/>
        </div>
    </main>
</template>