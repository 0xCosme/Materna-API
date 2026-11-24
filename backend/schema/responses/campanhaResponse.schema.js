/**********************************************************************************
 * Objetivo: Arquivo responsável pela definição de esquema de resposta da campanha.
 * Data: 07/10/2026
 * Autor: Gustavo Vidal de Abreu
 * Versão: 1.0
**********************************************************************************/

const Joi = require("joi")

const campanhaResponseSchema = Joi.object({
    id: Joi.number()
        .integer(),

    titulo: Joi.string()
        .max(100),

    desc: Joi.string(),

    foto: Joi.string()
        .max(255),

    data_inicio: Joi.date()
        .iso(),

    data_fim: Joi.date()
        .iso(),

    is_ativo: Joi.boolean(),

    id_instituicao: Joi.number()
        .integer(),

    tbl_funcionario_id: Joi.number()
        .integer()
})

module.exports = campanhaResponseSchema