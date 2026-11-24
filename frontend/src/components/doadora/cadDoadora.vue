<script setup>

</script>

<template>
    <article class="p-[24px] w-full max-w-[347px] h-[266px] bg-[#FFFFFF] border-2 border-borda rounded-[12px]">
        <header class="flex mb-[20px] gap-3">
            <div class="w-[48px] h-[48px] bg-[#F2F4F5] flex justify-center items-center rounded-full">
                <span>aa</span>
            </div>
            <div class="flex flex-col gap-1">
                <h1 class="text-[15px] font-semibold">nome {{ nome }}</h1>

                <span class="text-[#6b7280] text-[12px]">Desde 12/12/12</span>
            </div>
            <div>
                status
            </div>
        </header>

        <main class="mb-[32px] flex flex-col gap-2 text-[13px] text-[#4B5563]">
            <div class="flex gap-2">
                <img class="w-[13px]" src="@/assets/doadora/e-mail.svg" alt="Icon de uma carta que representa gmail">
                <p>E-mail ou Telefone ou CIdade</p>
            </div>

            <div class="flex gap-2">
                <img class="w-[13px]" src="@/assets/doadora/telefone.svg" alt="Icon de telefone">
                <p>E-mail ou Telefone ou CIdade</p>
            </div>

            <div class="flex gap-2">
                <img class="w-[13px]" src="@/assets/doadora/localizador.svg" alt="Icon de local">
                <p>E-mail ou Telefone ou CIdade</p>
            </div>
        </main>

        <footer class="mt-[9px]">
            <div class="flex justify-between">
                <span class="text-[13px] font-medium">Jornada</span>
                <span class="text-[13px] text-[#6b7280]">Percentual</span>
            </div>
            <div> A porcentagem</div>
        </footer>
    </article>
</template>