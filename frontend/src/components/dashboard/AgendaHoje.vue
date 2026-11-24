<script setup>
import { computed } from 'vue'

    const agenda =[
        {
            id: 1,
            data: "2026-11-25",
            horario: "10:00:00",
            nome: "Maria Silva",
            tipo: "Doação de leite humano",
            status: "Confirmado"
        },
        {
            id: 2,
            data: "2026-11-25",
            horario: "11:00:00",
            nome: "Sofia Michele",
            tipo: "Orientação inicial",
            status: "Pendente"
        },
        {
            id: 3,
            data: "2026-11-25",
            horario: "14:00:00",
            nome: "Carla Nunes",
            tipo: "Doação de leite humano",
            status: "Confirmado"
        }
    ]

    const hoje =new Date()
    const dataHoje = [
        hoje.getFullYear(),
        String(hoje.getMonth() + 1).padStart(2, '0'),
        String(hoje.getDate()).padStart(2,'0')
    ].join('-')

    const agendaDehoje =computed(()=>{
        return agenda.filter(item => item.data === dataHoje)
    })
    
    function formatarData(data) {
        const [ano, mes, dia] = data.split('-')

        const dataFormatada = new Date(
            Number(ano),
            Number(mes) - 1,
            Number(dia)
        )

        return {
            dia,
            mes: dataFormatada.toLocaleDateString('pt-BR', {
                month: 'short'
            }).replace('.', '').toUpperCase()
        }
    }

    
    function classesStatus(status) {
        const cores = {
            Confirmado: 'bg-[#F0FDF4] text-[#78DE6B] border-1 border-[#78DE6B]',
            Pendente: 'bg-[#FFF7ED] text-[#C2410C] border-1 border-[#FED7AA]',
            Cancelado: 'bg-red-50 text-red-600 border border-red-300'
        }

        return cores[status] || 'bg-gray-50 text-gray-600 border-gray-300'
    }

    function corBolinha(status) {
        const cores = {
            Confirmado: 'bg-[#78DE6B]',
            Pendente: 'bg-[#F97316]',
            Cancelado: 'bg-red-500'
        }
        return cores[status] || 'bg-gray-500'
    }
</script>
 <template>
    <footer class="w-full rounded-[16px] bg-white border border-gray-200">
        <div class="p-[20px]">
            <h2 class="text-[18px] font-bold">Agenda de hoje</h2>
            <RouterLink
                to="agenda"
                class="text-[#D96572] hover:underline">
                    Abrir agenda ↗
            </RouterLink>
        </div>
        <hr class="border-1 border-gray-100 ">
        <div>
            <div 
                v-for="item in agendaDehoje" 
                :key="item.id"
                class="flex p-[16px]  border-y border-gray-100">

                <div class="flex flex-col justify-center items-center w-[48px] h-[48px] rounded-[16px] bg-[#F1F5F9] mr-[16px] ">
                    <span class="text-[14px] font-bold">
                        {{ formatarData(item.data).dia }}
                    </span>
                    <span class="text-[10px] text-[#64748B] font-bold">
                        {{ formatarData(item.data).mes }}
                    </span>
                </div>

                <div class="flex w-full items-center justify-between">
                    <div class="">
                        <div class="flex text-[16px] font-bold ">
                            <p>{{ item.horario.slice(0, 5) }}</p>
                            <p class="pl-[12px]">{{ item.nome }}</p>
                        </div>
                        <p class="text-texto-claro text-[14px]">{{ item.tipo }}</p>
                    </div>
                    <span 
                    class="flex items-center justify-center gap-[6px] w-full max-w-[120px] py-[4px] px-[10px] rounded-full"
                    :class="classesStatus(item.status)" >
                        <div 
                        class="w-[6px] h-[6px] rounded-full shrink-0"
                        :class="corBolinha(item.status)"></div>
                        {{ item.status }}
                    </span>
                </div>
            </div>
            
        </div>
    </footer>
 </template>