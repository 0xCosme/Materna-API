const definirLatitudeLongitudePorCEP = async function (cep) {
    try {
        const cepLimpo = String(cep).replace(/\D/g, "");

        if (cepLimpo.length !== 8) {
            return false;
        }

        const resposta = await fetch(
            `https://brasilapi.com.br/api/cep/v2/${cepLimpo}`
        );

        if (!resposta.ok) {
            return false;
        }

        const dados = await resposta.json();
        const latitude = dados.location?.coordinates?.latitude;
        const longitude = dados.location?.coordinates?.longitude;

        if (latitude == null || longitude == null) {
            return false;
        }

        return {
            latitude: Number(latitude),
            longitude: Number(longitude)
        };
    } catch (error) {
        console.error("Erro ao buscar coordenadas:", error);
        return false;
    }
};

module.exports = {
    definirLatitudeLongitudePorCEP
};
