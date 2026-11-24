<script setup>
// Primeiro a Estilizacao depois autonomiza

</script>

<template>
    <nav 
    class="w-[320px] p-5 bg-white flex flex-col border-r-2 border-gray-200">
        <div class="flex items-center gap-2 py-3">
            <img 
            class="h-20"
            src="@/assets/logoMaterna.svg" 
            alt="Uma mãe segurando um bebe dormindo com chupeta, onde ambos estão com os olhos fechados">
            <div>
                <h3 class="text-[18px] font-bold text-slate-800 leading-tight">Materna</h3>
                <p class="text-[#64748B]">Painel institucional</p>
            </div>
        </div>

        <hr class="-mx-5 my-4 border-0 border-t-2 border-gray-200 ">

        <ul class="space-y-2 flex-1">

            <li class="w-full">
                <RouterLink 
                    to="/dashboard"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img 
                        class="w-[30px] h-[25px] pr-[12px] brightness-0 opacity-60 group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert group-[.router-link-exact-active]:opacity-100"
                        src="@/assets/sindebar/dashborard.svg" 
                        alt="um icon com 4 quadados meio aredondados">
                    Dashboard
                </RouterLink>
            </li>

            <li class="w-full">
                <RouterLink 
                    to="/agenda"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img 
                        class="w-[30px] h-[25px] pr-[12px] group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert"
                        src="@/assets/sindebar/agenda.svg" 
                        alt="Icon de agenda">
                    Agenda
                </RouterLink>
            </li>

            <li class="w-full">
                <RouterLink 
                    to="/doadora"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img 
                        class="w-[35px] h-[30px] pr-[12px] group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert"
                        src="@/assets/sindebar/doadora.svg" 
                        alt="icon de duas pessoas">
                    Doadoras
                </RouterLink>
            </li>            

            <li class="w-full">
                <RouterLink 
                    to="/jornada"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img 
                        class="w-[30px] h-[25px] pr-[12px] group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert"
                        src="@/assets/sindebar/jornada.svg" 
                        alt="um icone com uma tela com um gráfico subindo">
                    Jornadas
                </RouterLink>
            </li>

            <li class="w-full">
                <RouterLink 
                    to="/campanha"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img 
                        class="w-[30px] h-[25px] pr-[12px] group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert"
                        src="@/assets/sindebar/campanha.svg" 
                        alt="icon de auto-falante">
                    Campanhas
                </RouterLink>
            </li>          

            <li class="w-full">
                <RouterLink 
                    to="/instituicao"
                    class="group flex items-center space-x-3 w-full rounded-xl px-4 py-3 text-slate-600 hover:bg-pink-50 transition-colors font-medium [&.router-link-exact-active]:bg-[#DE6771] [&.router-link-exact-active]:text-white" >
                    <img  
                        class="w-[30px] h-[25px] pr-[12px] group-[.router-link-exact-active]:brightness-0 group-[.router-link-exact-active]:invert"
                        src="@/assets/sindebar/instituicao.svg" 
                        alt="icon de um prédio">
                    Instituição
                </RouterLink>
            </li>            

        </ul>

        <hr class="-mx-5 my-4 border-0 border-t-2 border-gray-200 ">
          <!-- aqui seria puxado pela api fazer depois-->
        <div class="flex flex-row items-center space-x-3">
            <img 
            class="h-20"
            src="@/assets/logoMaterna.svg" 
            alt="Uma mãe segurando um bebe dormindo com chupeta, onde ambos estão com os olhos fechados">
            <div>
                <h3 class="text-[18px] font-bold text-slate-800 leading-tight">Materna</h3>
                <p class="text-[#64748B]">Painel institucional</p>
            </div>
        </div>
    </nav>
</template>