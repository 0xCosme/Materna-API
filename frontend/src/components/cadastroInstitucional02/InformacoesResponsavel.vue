<script setup>
import { ref } from 'vue';

const processo = ref(true)
const etapaAtual = ref(2)

const etapa = [
    'Instituicao',
    'Responsável',
    'Local&Horário',
    'Acesso'
]
</script>

<template>
    <div class="mb-7 w-full text-left px-20">

<div class="w-full flex items-center justify-between">

    <!-- Etapas -->
    <div class="h-8 w-28 rounded-lg flex mt-29"
    style="background-color:#F5E6E9;">
    
    <span class="font-normal rounded-full text-xs 
        text-[13px] items-center px-4 mt-2" 
        style="color: #DE6B72;">
        ETAPA 2 DE 4
        </span>

    <!-- Dados -->
    </div>
            <span class="text-[14px] text-[#94A3B8] mt-9">
                Dados do Responsável
            </span>

        </div>


        <h1 class="text-[30px] font-bold text-black text- mt-3">
            Criar conta institucional
        </h1>

        <p class="text-sm text-gray-600 text-[17px] mb-10">
            Preencha os dados do responsável legal ou técnico pela unidade.
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

                <p class="mt-2 whitespace-nowrap text-[12px] text-[#DE6B72] font-bold mb-4">
                    {{ etapa }}
                </p>

            </div>
        </div>

            <!--Informacoes-->
        <div class="items-center px-20 mb-4">
            <h1 class="text-[18px] font-bold text-black">
                2. Informações do Responsável
            </h1>
            <p class="text-[14px] text-[#64748B]">
                Dados da pessoa física gestora ou técnica responsável pela conta da unidade.</p>
        </div>

            <!--Responsavel/ Nome-->
            <div class="w-full min-w-[520px] text-left px-20 mb-4">
                <div class="flex flex-col gap-1">

                    <label class="text-[17px] font-medium text-gray-700">
                        Nome completo do responsável                    
                    </label>

                    <input 
                    type="text"
                    placeholder="Ex: Dra. Mariana Vasconcelos Silva"
                    class="h-[47px] w-190 rounded-md border border-gray-300 
                    bg-white px-3 text-[14px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!-- Formulário/CPF -->
            <div class="w-full space-y-4 text-left px-20 mb-4 justify-between">
                <div class="flex flex-col gap-1">
                    <label class="text-[17px] font-medium text-gray-700">
                        CPF
                    </label>

                    <input 
                    type="text"
                    placeholder="000.000.000-00"
                    class="h-[47px] w-90 rounded-md border border-gray-300 
                    bg-white px-3 text-[14px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!--Formulário/Data de Nascimento-->
            <div class="w-full space-y-4 text-left px-20 mb-4">
                <div class="flex flex-col gap-1">
                    <label class="text-[17px] font-medium text-gray-700">
                        Data de Nascimento
                    </label>

                    <input 
                    type="text"
                    placeholder="DD/MM/AAAA"
                    class="h-[47px] w-90 rounded-md border border-gray-300 
                    bg-white px-3 text-[14px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!-- Formulário/Telefone -->
            <div class="w-full whitespace-nowrap space-y-4 px-20 mb-4">
                <div class="flex flex-col gap-1">
                    <label class="text-[17px] font-medium text-gray-700">
                        Telefone / WhatsApp
                    </label>

                    <input 
                    type="text"
                    placeholder="(11) 98765-4321"
                    class="h-[47px] w-190 rounded-md border border-gray-300 
                    bg-white px-3 text-[14px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

            <!-- Email/Telefone -->
            <div class="w-full whitespace-nowrap space-y-4 px-20 mb-4">
                <div class="flex flex-col gap-1">
                    <label class="text-[17px] font-medium text-gray-700">
                        E-mail do responsável
                    </label>

                    <input 
                    type="text"
                    placeholder="mariana.silva@bancodeleite.org.br"
                    class="h-[47px] w-190 rounded-md border border-gray-300 
                    bg-white px-3 text-[14px] text-gray-700
                    outline-none border-gray-300 focus:border-[#D1D5DB]">
                </div>
            </div>

        <div class="w-full px-20 mt-8">
            <div class="h-px w-190 bg-gray-100 mb-7 "></div>
        </div>

            <!-- Botão -->
            <div class="text-left px-170 flex-col">
                <button class="relative w-40 h-[49px] rounded-md 
                bg-[#DE6B72] justify-center flex items-center 
                text-sm font-medium text-white hover:opacity-30 transition">

                <span class="text-white text-[18px] top-1/2 -translate-y-1/2 mt-6 gap-4">
                    Avançar
                </span>
                
                <img 
                src="/src/assets/cadastro/Seta2.svg" 
                alt="Seta2" 
                class="w-4 h-4 object-contain shrink-0 object-contain gap-3">
                
                </button>
            </div>

            <div class="w-full flex items- justify-center gap-1 mt-6">
                <p class="whitespace-nowrap text-xs text-black/60 text-[17px]">
                    Já possui uma conta institucional? 
                </p>

                <a href="#" class="text-[16px] text-[#DE6B72] 
                            font-semibold hover:underline">
                    Entrar
                </a>

            </div>

</template>