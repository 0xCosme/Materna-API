import { enviarDocumentoCloudinary} from '@/services/cloudinaryService'
import { ref } from 'vue'

export function urlDocumento(){
    const campoDocumento = ref(null)
    const arquivoDocumento = ref(null)

    function receberDocumento(documento) {
        if (!documento) return

        arquivoDocumento.value = documento
    }

    async function enviarDocumento(arquivo) {
        if (!arquivo) return null
    
        const documento = await enviarDocumentoCloudinary(arquivo)
    
        return documento
    }

    return {
        campoDocumento,
        arquivoDocumento,
        receberDocumento,
        enviarDocumento
    }
}