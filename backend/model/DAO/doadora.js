/**
 * Objetivo: Arquivo responsável pelo CRUD de doadora do Materna
 * MYSQL
 * Data: 15/04/2026
 * Autor: Bruno Haddad Alves
 * Versão: 1.0
 */

// Faz o import da biblioteca para manipular dados no banco de dados MySQL
const knex = require("knex");

// Import do arquivo de configuração para acesso ao banco de dados
const knexDatabaseConfig = require("../database_config/knexConfig.js");

// Criar a conexão com o BD MySQL conforme o arquivo de configuração
const knexConection = knex(knexDatabaseConfig.development);




// Função para inserir uma nova doadora no banco de dados
    const insertDoadora = async function (doadora, codigoOtp) {

        try {

            const sql = `
            CALL proccadastrardoadora(
                ?, ?, ?, ?, ?, ?, ?,
                ?,
                ?, ?, ?, ?, ?, ?, ?,
                ?, ?, ?
            )
        `;

        const valores = [
            doadora.nome,
            doadora.cpf,
            doadora.foto ?? null,
            doadora.data_nascimento,
            doadora.email,
            doadora.senha,
            doadora.sal,

            doadora.telefone,

            doadora.logradouro,
            doadora.cep,
            doadora.bairro,
            doadora.numero,
            doadora.complemento,
            doadora.latitude,
            doadora.longitude,

            doadora.cidade,
            doadora.sigla_estado,
            codigoOtp
        ];

        const [resultado] = await knexConection.raw(sql, valores);

        return resultado[0][0].id_doadora;
            
        } catch (error) {
            console.error('Erro ao inserir doadora:', error)
            return false
        }
        
    };


    const selectByIdDoadora = async function (id) {
        try {
            const sql = `
                SELECT 
                    doad.*,
                    ender.logradouro,
                    ender.cep,
                    ender.bairro,
                    ender.numero,
                    ender.complemento,
                    ender.latitude,
                    ender.longitude,
                    cid.nome AS cidade,
                    est.sigla AS sigla_estado,
                    tel.numero AS telefone,
    
                    -- ETAPAS CONCLUIDAS
                    (
                        SELECT COUNT(DISTINCT jd.id_etapa)
                        FROM tbl_jornada_doacao AS jd
                        WHERE jd.id_doadora = doad.id
                        AND jd.id_jornada = (
                            SELECT jd2.id_jornada
                            FROM tbl_jornada_doacao AS jd2
                            WHERE jd2.id_doadora = doad.id
                            AND jd2.encerrado = false
                            ORDER BY jd2.id DESC
                            LIMIT 1
                        )
                        AND jd.data_conclusao IS NOT NULL
                    ) AS etapas_concluidas,
    
                    -- TOTAL DE ETAPAS
                    (
                        SELECT COUNT(*)
                        FROM tbl_etapa AS et
                        WHERE et.id_jornada = (
                            SELECT jd2.id_jornada
                            FROM tbl_jornada_doacao AS jd2
                            WHERE jd2.id_doadora = doad.id
                            AND jd2.encerrado = false
                            ORDER BY jd2.id DESC
                            LIMIT 1
                        )
                    ) AS total_etapas,
    
                    -- DOACOES REALIZADAS
                    (
                        SELECT COUNT(DISTINCT jd.ciclo)
                        FROM tbl_jornada_doacao AS jd
                        INNER JOIN tbl_etapa AS et
                            ON jd.id_etapa = et.id
                        WHERE jd.id_doadora = doad.id
                        AND jd.data_conclusao IS NOT NULL
                        AND et.is_repetivel = true
                    ) AS doacoes_realizadas,
    
                    -- AGENDAMENTOS
                    (
                        SELECT COUNT(DISTINCT ag.id)
                        FROM tbl_agendamento AS ag
                        INNER JOIN tbl_jornada_doacao AS jd
                            ON ag.id_jornada_doacao = jd.id
                        WHERE jd.id_doadora = doad.id
                    ) AS total_agendamentos
    
                FROM tbl_doadora AS doad
    
                INNER JOIN tbl_endereco AS ender
                    ON doad.id_endereco = ender.id
    
                INNER JOIN tbl_cidade AS cid
                    ON ender.id_cidade = cid.id
    
                INNER JOIN tbl_estado AS est
                    ON cid.id_estado = est.id
    
                INNER JOIN tbl_telefone AS tel
                    ON doad.id_telefone = tel.id
    
                WHERE doad.id = ?
            `;
    
            const [resultado] = await knexConection.raw(sql, [id]);
    
            return resultado;
    
        } catch (error) {
            console.error('Erro ao buscar doadora:', error);
            return false;
        }
    };
    

const selectByEmail = async function (email) {
    try {
        const sql = `
            select id, nome, email, senha, sal, is_validado
            from tbl_doadora
            where email = ?
            limit 1
        `;

        const [resultado] = await knexConection.raw(sql, [email]);
        return resultado;
    } catch (error) {
        console.error('Erro ao buscar doadora por email:', error);
        return false;
    }
};

const updateDoadora = async function (doadora) {
    try {
        const sql = `
            CALL procatualizardoadora(
                ?, ?, ?, ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?, ?, ?, ?
            )
        `;

        const valores = [
            doadora.id,
            doadora.nome,
            doadora.cpf,
            doadora.foto ?? null,
            doadora.data_nascimento,
            doadora.email,
            doadora.senha,
            doadora.sal,

            doadora.telefone,

            doadora.logradouro,
            doadora.cep,
            doadora.bairro,
            doadora.numero,
            doadora.complemento,
            doadora.latitude,
            doadora.longitude,

            doadora.cidade,
            doadora.sigla_estado
        ];

        await knexConection.raw(sql, valores);
        return true;
    } catch (error) {
        console.error('Erro ao atualizar doadora:', error);
        return false;
    }
};

const updateFotoDoadora = async function (id, foto) {
    try {
        const sql = `
            UPDATE tbl_doadora
            SET foto = ?
            WHERE id = ?
        `;

        await knexConection.raw(sql, [foto, id]);
        return true;
    } catch (error) {
        console.error('Erro ao atualizar foto da doadora:', error);
        return false;
    }
};

const updateSenhaPorEmail = async function (email, senha, sal) {
    try {
        const sql = `
            UPDATE tbl_doadora
            SET senha = ?, sal = ?
            WHERE email = ?
        `;

        await knexConection.raw(sql, [senha, sal, email]);
        return true;
    } catch (error) {
        console.error('Erro ao atualizar senha da doadora:', error);
        return false;
    }
};

const deleteDoadora = async function(id){
    try {
        let sql = `DELETE FROM tbl_doadora WHERE id=${id};`

        let result = await knexConection.raw(sql)
        if(result)
            return true
        else 
            return false
    } catch (error) {
            return false
    }
}


const selectUltimoCodigoByDoadora = async function (id_doadora) {
    try {
        const sql = `
            select codigo
            from tbl_codigo_envio
            where id_doadora = ?
            order by data_criacao desc, id desc
            limit 1
        `;

        const [resultado] = await knexConection.raw(sql, [id_doadora]);
        return resultado;
    } catch (error) {
        console.error('Erro ao buscar código OTP:', error);
        return false;
    }
};


const validarDoadoraOtp = async function (id_doadora) {
    try {
        await knexConection.transaction(async (trx) => {
            await trx.raw(`update tbl_doadora set is_validado = true where id = ?`, [id_doadora]);
            await trx.raw(`delete from tbl_codigo_envio where id_doadora = ?`, [id_doadora]);
        });

        return true;
    } catch (error) {
        console.error('Erro ao validar doadora via OTP:', error);
        return false;
    }
};

module.exports = {
    insertDoadora,
    selectByIdDoadora,
    selectByEmail,
    updateDoadora,
    updateFotoDoadora,
    updateSenhaPorEmail,
    deleteDoadora,
    selectUltimoCodigoByDoadora,
    validarDoadoraOtp
};