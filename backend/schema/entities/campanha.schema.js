/**********************************************************************
 * Objetivo: Arquivo responsável pela definição de esquema da campanha.
 * Data: 07/10/2026
 * Autor: Gustavo Vidal de Abreu
 * Versão: 1.0
**********************************************************************/

const Joi = require("joi")

const campanhaSchema = Joi.object({
    titulo: Joi.string()
        .max(100)
        .required(),

    desc: Joi.string()
        .required(),

    foto: Joi.string()
        .max(255),

    data_inicio: Joi.date()
        .iso()
        .required(),

    data_fim: Joi.date()
        .iso()
        .required(),

    is_ativo: Joi.boolean()
        .required(),

    id_instituicao: Joi.number()
        .integer()
        .required(),

    tbl_funcionario_id: Joi.number()
        .integer()
        .required()
})

module.exports = campanhaSchema