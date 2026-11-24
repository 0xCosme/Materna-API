<script setup>
import InformacoesResponsavel from '@/components/cadastroInstitucional02/InformacoesResponsavel.vue';
import CriacaoConta from '@/components/cadastroInstitucional02/InformacoesResponsavel.vue';
import LateralCadastro from '@/components/cadastroInstitucional02/LateralInformacoes.vue';

</script>

<template>

    <main class="flex min-w-0">
        <LateralCadastro
                :titulo=" `Junte-se à maior
                rede de bancos de 
                leite humano`"
                :descricao="`Cadastre sua instituição para modernizar
                agendamentos, acompanhar doadoras em tempo
                real e otimizar coletas.`"
            :informacoes="[
                'Gestão simplificada e automatizada de coletas',
                'Canal direto e seguro com mães doadoras',
                `Relatórios em conformidade com normas 
                sanitárias`,
                'Suporte dedicado para equipes e técnicos'
            ]"
                :progresso="true"
                :etapaAtual="1"
                :quantidadeEtapas="4"

                :dados-footer="['Ambiente Seguro Institucional',
                'Redes BLH Brasil'
            ]"
        />
    
        <div class="flex-1 min-w-0">
            <InformacoesResponsavel/>
        </div>
    </main>

</template>