import { enviarImagemCloudinary } from '@/services/cloudinaryService'
import { ref } from 'vue'

export function urlDaImagem() {
    const campoArquivo = ref(null)
    const arquivoImagem = ref(null)
    const previewImagem = ref('')

    function abrirSeletorImagem() {
        campoArquivo.value.click()
    }

    function receberImagem(imagem) {
        if (!imagem) return

        arquivoImagem.value = imagem
        previewImagem.value = URL.createObjectURL(imagem)
    }

    function soltarImagem(evento) {
        const imagem = evento.dataTransfer.files[0]

        receberImagem(imagem)
    }

    async function enviarImagem() {
        const foto = await enviarImagemCloudinary(arquivoImagem.value)
    
        return foto
    }

    return {
        campoArquivo,
        arquivoImagem,
        previewImagem,
        abrirSeletorImagem,
        receberImagem,
        soltarImagem,
        enviarImagem
    }
}