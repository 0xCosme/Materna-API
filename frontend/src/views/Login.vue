<script setup>
import Formulario from '@/components/login/Formulario.vue';
import LateralInformativo from '@/components/login/LateralInformativo.vue';


</script>
<template>
    <main class="flex min-w-0">
        <LateralInformativo
                :titulo=" `Gestão completa do seu 
                de leite humano`"
                :descricao="`Acompanhe a agenda, gerencie doadoras, organize 
                campanhas e visualize relatórios em um único painel, 
                pensado para o dia a dia da instituição.`"
            :informacoes="[
                'Agenda e disponibilidade em tempo real',
                'Acompanhamento da jornada das doadoras',
                'Relatórios de comparecimento e alcance'
            ]"
                :progresso="false"

                dados-footer="Materna · Plataforma de apoio à doação de leite humano"
        />
    
        <div class="flex-1 min-w-0">
            <Formulario/>
        </div>
    </main>

</template>