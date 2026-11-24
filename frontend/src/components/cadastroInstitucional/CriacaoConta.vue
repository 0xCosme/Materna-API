<script setup>
import LateralCadastro from './LateralCadastro.vue';
import { ref } from 'vue';

const processo = ref(true)
const etapaAtual = ref(1)

const etapa = [
    'Instituicao',
    'Responsável',
    'Local&Horário',
    'Acesso'
]

</script>
<template>x
    <div class="mb-7 w-full text-left px-100">
        <div class="h-8 w-30 rounded-lg flex mt-50"
        style="background-color:#F5E6E9;">
        
        <span class="font-normal rounded-full text-xs 
        text-[14px] items-center px-4 mt-2" 
            style="color: #DE6B72;">
            ETAPA 1 DE 4
            </span>
        </div>

        <h1 class="text-[37px] font-bold text-black text-left">
            Criar conta institucional
        </h1>
        <p class="text-sm text-gray-600 text-[20px] mb-13">
            Crie sua senha de acesso seguro 
            para o painel institucional.
        </p>
    </div>

        <!--Indica de etapas-->
        <div v-if="processo" class="mb-8 flex w-full ">

            <div
                v-for="(etapa, index) in ['Instituição', 'Responsável', 'Local e Horário', 'Acesso']"
                :key="index"
                class="flex flex-1 flex-col items-center">


                <div class="flex w-full items-center">

                    <div
                        class="h-px flex-1"
                        :class="index === 0 ? 'bg-transparent' : 'bg-gray-300 '">
                    </div>

                    <div
                        class="flex h-8 w-8 items-center justify-center rounded-full text-[16px]"
                        :class="index + 1 <= etapaAtual
                            ? 'bg-[#DE6B72] text-white'
                            : 'border border-gray-300 bg-white text-gray-400'">
                        {{ index + 1 }}
                    </div>

                    <div
                        class="h-px flex-1"
                        :class="index === 3 ? 'bg-transparent' : 'bg-gray-300'">
                    </div>

                </div>

                <p class="mt-2 whitespace-nowrap text-[12px] text-[#DE6B72] font-bold mb-14">
                    {{ etapa }}
                </p>

            </div>
        </div>

            <!--Informacoes-->
        <div class="items-center px-30 mb-8">
            <h1 class="text-[18px] font-bold text-black">
                1. Informações Institucionais
            </h1>
            <p class="text-[16px] text-[#64748B]">
                Insira a razão social e dados corporativos da entidade de saúde.
            </p>
        </div>

            <!--Formulário/ Nome-->
            <div class="w-full min-w-[520px] text-left px-30 mb-6">
                <div class="flex flex-col gap-2">

                    <label class="text-[18px] text-gray-700">
                        Nome da instituição / Razão Social
                    </label>

                    <input 
                    type="text"
                    placeholder="Ex: Banco de Leite Humano Santa Clara"
                    class="h-[47px] w-250 rounded-md border border-gray-300 
                    bg-white px-3 text-[17px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!-- Formulário/CNPJ -->
            <div class="w-full space-y-4 text-left px-30 mb-6">
                <div class="flex flex-col gap-2">
                    <label class="text-[18px] text-gray-700">
                        CNPJ
                    </label>

                    <input 
                    type="text"
                    placeholder="00.000.000/0001-00"
                    class="h-[47px] w-250 rounded-md border border-gray-300 
                    bg-white px-3 text-[17px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

              <!--Formulário/E-mail-->
            <div class="w-full space-y-4 text-left px-30 mb-6">
                <div class="flex flex-col gap-2">
                    <label class="text-[18px] text-gray-700">
                        E-mail institucional oficial
                    </label>

                    <input 
                    type="text"
                    placeholder="contato@bancodeleite.org.br"
                    class="h-[47px] w-250 rounded-md border border-gray-300 
                    bg-white px-3 text-[17px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!-- Formulário/Telefone -->
            <div class="w-full whitespace-nowrap space-y-4 px-30 mb-6">
                <div class="flex flex-col gap-2">
                    <label class="text-[18px] text-gray-700">
                        Telefone fixo / Recepção E-mail institucional oficial
                    </label>

                    <input 
                    type="text"
                    placeholder="(11) 3214-5678"
                    class="h-[47px] w-250 rounded-md border border-gray-300 
                    bg-white px-3 text-[17px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

        <div class="w-full px-40 mt-20">
            <div class="h-px w-260 bg-black/20 mb-16 "></div>
        </div>

            <!-- Botão -->
             <div class="text-left px-240 flex-col mt-6">
                <button class="w-40 h-[47px] rounded-md bg-[#DE6B72] 
                text-sm font-medium text-white hover:opacity-90 transition">
                Avançar
                </button>

                 <div class="w-full flex items-center justify-end">
                <p class="whitespace-nowrap text-xs text-[#D1D5DB] mt-2 text-[16px]">
                    Já possui uma conta institucional? 
                </p>

            </div>

            </div>
            
</template>