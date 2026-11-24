<script  setup>
const emit = defineEmits(['editar','deletar'])

    const props = defineProps({
        campanha:{
            type: Object,
            required:true
        }
    })

    function formatarData(data) {
        if (!data) return ''
        const dataSemHorario = data.split('T')[0]

        const [ano, mes, dia] = dataSemHorario.split('-')
        return `${dia}/${mes}/${ano}`
    }
</script>

<template>
    <article class=" w-full max-w-[346px] h-[383px] flex flex-col bg-[#FFFFFF] border-2 border-borda rounded-[16px]">
        <div class="h-[128px] w-full flex items-center justify-center rounded-t-xl">
            <img class="h-full w-full object-cover rounded-t-xl" :src="campanha.foto" alt="">
        </div>
        
        <div class="p-[20px]">
            <header class="flex justify-between mb-[12px]">
                <h2 class="text-[16px] font-bold truncate" :title="campanha.titulo">{{ campanha.titulo }}</h2>

               <span
                class="h-[26px] flex items-center justify-center gap-[6px] py-[4px] px-[10px] rounded-full"
                :class="campanha.is_ativo
                ? 'bg-[#F0FDF4] text-green-600 border border-green-500'
                : 'bg-[#F3F4F6] text-[#4B5563] border-2 border-[#E5E7EB]'">
                
                    <span
                        class="w-[6px] h-[6px] rounded-full shrink-0"
                        :class="campanha.is_ativo
                            ? 'bg-green-500'
                            : 'bg-[#9CA3AF]'"
                    ></span>

                    {{ campanha.is_ativo ? 'Ativa' : 'Encerrada' }}
                </span>
            </header>

            <p class="text-[14px] text-texto-claro mb-[20px] truncate" :title="campanha.descricao">{{ campanha.descricao }}</p>
        </div>
        <hr class="mx-[20px] border-1 border-gray-100 ">
        <div class="p-[20px]">
            <div class="flex gap-[8px] text-texto-claro text-[13px] mb-[30px]"> 
                <img src="@/assets/sindebar/agenda.svg" alt="">

                <time :datetime="campanha.data_inicio">
                  {{ formatarData(campanha.data_inicio) }}  
                </time>
                    
                <span> - </span>

                <time :datetime="campanha.data_fim">
                    {{formatarData(campanha.data_fim)}}  
                </time>
            </div>

            <footer class="flex justify-between ">
                <button
                @click="emit('editar',props.campanha)"
                    class="p-2 flex items-center justify-center gap-2 w-[87px] h-[36px] rounded-lg bg-materna text-white text-[14px] font-medium hover:bg-pink-50 hover:text-slate-600 transition-colors">
                    <img
                        class="w-[20px] h-[20px] transition-all group-hover:brightness-0 group-hover:opacity-60"
                        src="@/assets/campanha/lapis.svg"
                        alt="">
                    Editar
                </button>

                <button
                    @click="emit('deletar',campanha.id)"
                    class="group p-2 flex items-center justify-center gap-2 w-[87px] h-[36px] rounded-lg bg-materna text-white text-[14px] font-medium hover:bg-pink-50 hover:text-slate-600 transition-colors">
                    <img
                        class="w-[20px] h-[20px] transition-all group-hover:brightness-0 group-hover:opacity-60"
                        src="@/assets/campanha/lixeira.svg"
                        alt="">
                    Deletar
                </button>
            </footer>
        </div>
    </article>
</template>