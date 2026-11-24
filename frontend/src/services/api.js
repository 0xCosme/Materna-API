const Api_Url = import.meta.env.VITE_API_URL

export async function requisicaoApi (endPoint, options = {}){
    try {
        const resposta = await fetch(`${Api_Url}/${endPoint}`,{
            ...options,
            headers:{
                ...options.headers,
            }
        })
        

        
        if (resposta.status ===204)
            return null
        else if(resposta.status === 404) 
            return null
        

        if(!resposta.ok){
            throw new Error(`Erro na requisição: ${resposta.status}`)
        }
        
        return resposta.json()
    } catch (error) {
        console.error('Erro na requisição da API:', error)
        throw error
    }
}