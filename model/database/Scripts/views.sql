
#ARQUIVO ReSPONSAVEL POR CRIAR A VIEW 
#VIEW horarios
create or replace view vw_horarios as
select
    ch.id                                   as id_horario,
    ch.dia                                  as data,
    ch.horario                              as hora,
    ch.disponivel                           as disponivel,

    # status vem do status do agendamento (NULL se não houver agendamento)
    sa.id                                   as id_status,
    sa.status                               as status,

    # etapa vinculada
    e.id                                    as id_etapa,
    e.titulo                                as etapa,
    e.id_jornada                            as id_jornada,

    # agendamento / jornada
    ag.id                                   as id_agendamento,
    jd.id                                   as id_jornada_doacao,
    jd.encerrado                            as encerrado,

    # doadora (se houver)
    d.id                                    as id_doadora,
    d.nome                                  as doadora_nome,
    d.cpf                                   as doadora_cpf,
    d.foto                                  as doadora_foto,
    d.data_nascimento                       as doadora_data_nascimento,
    d.email                                 as doadora_email,
    d.is_validado                           as doadora_is_validado,
    t.numero                                as doadora_telefone,
    en.logradouro                           as doadora_logradouro,
    en.numero                               as doadora_numero,
    en.complemento                          as doadora_complemento,
    en.bairro                               as doadora_bairro,
    en.cep                                  as doadora_cep,
    ci.nome                                 as doadora_cidade,
    es.sigla                                as doadora_estado,

    # próximos horários (a partir de agora)
    (timestamp(ch.dia, ch.horario) >= now()) as is_proximo

from tbl_cadastro_horario ch
inner join tbl_etapa e                  on e.id = ch.id_etapa
left join  tbl_agendamento ag           on ag.id_cadastro_horario = ch.id
left join  tbl_status_agendamento sa    on sa.id = ag.id_status_agendamento
left join  tbl_jornada_doacao jd        on jd.id = ag.id_jornada_doacao
left join  tbl_doadora d                on d.id = jd.id_doadora
left join  tbl_telefone t               on t.id = d.id_telefone
left join  tbl_endereco en              on en.id = d.id_endereco
left join  tbl_cidade ci                on ci.id = en.id_cidade
left join  tbl_estado es                on es.id = ci.id_estado

# esconde o horário se QUALQUER agendamento dele estiver em jornada encerrada
where not exists (
    select 1
    from tbl_agendamento ag2
    inner join tbl_jornada_doacao jd2 on jd2.id = ag2.id_jornada_doacao
    where ag2.id_cadastro_horario = ch.id
      and jd2.encerrado = true
)

order by ch.dia, ch.horario;


#exemplo de uso 

#select * from vw_horarios;                            -- todos
#select * from vw_horarios where is_proximo = true;    -- só os próximos
#select * from vw_horarios where id_doadora is null;   -- só os sem doadora





