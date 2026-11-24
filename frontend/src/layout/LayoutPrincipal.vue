<script setup>
import Cabecario from '@/components/layoutPrincipal/Cabecario.vue'
import Sindebar from '@/components/layoutPrincipal/Sindebar.vue'
import { RouterView } from 'vue-router'
</script>

<template>
    <div class="flex h-dvh min-w-0 ">
        <Sindebar />

        <div class="flex-1 min-w-0 min-h-0 flex flex-col">
            <Cabecario />

            <div class="flex-1 min-w-0 min-h-0 overflow-y-auto">
                <RouterView />
            </div>
        </div>
    </div>
</template>