<script setup>
    const jornadaDoadoras =[
        {nome:"Maria Silva",progresso: 80},
        {nome:"Ana Souza",progresso: 40},
        {nome:"Carla Nunes",progresso: 100},
        {nome:"João Ribeiro",progresso: 20}
    ]

    function validarPorcentagem(progresso){
        if(!Number.isFinite(progresso))
            return 'Erro'
        else if(progresso <0)
            return 0
        else if(progresso >100)
            return 100
        else
            return progresso
    }
</script>

<template>
    <div class="w-full flex flex-col justify-around min-h-[352px] box-border rounded-[16px] bg-white p-[24px] border border-gray-200">
       <h3 class="text-[18px] font-bold mb-[5px]">Doadoras em jornada</h3>
       <div class="flex items-center gap-[8px]">
            <p class="text-[30px] font-bold">{{ jornadaDoadoras.length }}</p> 
            <span class="text-[12px] text-texto-claro">Jornadas em andamento</span>
        </div>
        

        <div v-for="doadoras in jornadaDoadoras" class="pb-[16px]">
            <div class="flex justify-between pb-[6px] text-[14px]">
                <p>{{ doadoras.nome }}</p>
                <span class="text-texto-claro">{{validarPorcentagem(doadoras.progresso) }}%</span>
            </div>

            <div class="w-full h-[6px] bg-[#E2E8F0] rounded-full ">
                <div class="h-full bg-[#D96572] rounded-full"
                    :style="{width: `${validarPorcentagem(doadoras.progresso)}%`}"></div>
            </div>
        </div>
        <RouterLink
            to="doadora"
            class="text-materna hover:underline">
                Ver todas ↗
        </RouterLink>
    </div>
</template>