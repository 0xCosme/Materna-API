
const express = require('express');
const knex = require('knex');
const knexConfig = require('./knexFile.js');

const app = express();

app.use(express.json());

const db = knex(knexConfig.development);
const PORT = 3000;

// Rota para cadastrar jornada
app.post('/jornadas', async (req, res) => {
    let conexao;

    try {
        const {
            is_ativo = true,
            nome,
            descricao = null,
            id_instituicao,
            etapas
        } = req.body;

        // Validação dos dados recebidos
        if (!nome || !Array.isArray(etapas) || etapas.length === 0) {
            return res.status(400).json({
                codigo: 400,
                mensagem: 'Informe o nome e ao menos uma etapa.'
            });
        }

        if (!id_instituicao) {
            return res.status(400).json({
                codigo: 400,
                mensagem: 'Informe o id_instituicao.'
            });
        }

        // Obtém uma conexão física do pool
        conexao = await db.client.acquireConnection();

        // Executa SQL na mesma conexão
        const query = (sql, params = []) =>
            new Promise((resolve, reject) => {
                conexao.query(sql, params, (erro, resultado) => {
                    if (erro) {
                        return reject(erro);
                    }

                    resolve(resultado);
                });
            });

        // Inicializa o parâmetro de saída
        await query('SET @codigo = NULL');

        // Executa a procedure
        const resultadoSQL = await query(
            `CALL sp_cadastrar_jornada(?, ?, ?, ?, ?, @codigo)`,
            [
                is_ativo,
                nome,
                descricao,
                id_instituicao,
                JSON.stringify(etapas)
            ]
        );

        // Obtém o parâmetro OUT
        const resultadoCodigo = await query(
            'SELECT @codigo AS codigo'
        );

        const codigo = resultadoCodigo[0].codigo;

        // Imprime o retorno SQL no terminal
        console.log('\n========== RETORNO SQL ==========');
        console.log('Código:', codigo);
        console.dir(resultadoSQL, { depth: null });
        console.log('=================================\n');

        // Retorna o resultado para o cliente
        return res.status(codigo === 200 ? 201 : 400).json({
            codigo,
            resultado_sql: resultadoSQL
        });

    } catch (erro) {
        console.error('\nErro ao executar a procedure:');
        console.error(erro);

        return res.status(500).json({
            codigo: 500,
            mensagem: 'Erro ao executar a procedure.',
            erro: erro.message,
            codigo_sql: erro.code || null
        });

    } finally {
        // Devolve a conexão ao pool
        if (conexao) {
            db.client.releaseConnection(conexao);
        }
    }
});

// Rota simples para verificar se a API está funcionando
app.get('/', (req, res) => {
    res.json({
        mensagem: 'API de jornadas funcionando!',
        endpoint: 'POST /jornadas'
    });
});

// Inicializa o servidor
const server = app.listen(PORT, () => {
    console.log(`API rodando em http://localhost:${PORT}`);
});

// Encerramento seguro
async function encerrar() {
    console.log('\nEncerrando API...');

    server.close(async () => {
        await db.destroy();
        process.exit(0);
    });
}

process.on('SIGINT', encerrar);
process.on('SIGTERM', encerrar);
