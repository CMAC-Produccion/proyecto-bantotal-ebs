create or replace force view jaqy570 as
select
             t_iden.nu_docu_iden
        from tmtrab_empr@ofiplan t_trab,
             tdiden_trab@ofiplan t_iden
        where t_trab.ti_situ='ACT'--
              and t_trab.co_empr = '01'
              and t_trab.co_plan in ('EMP','PTM','EJE','PRA')---***
              and t_iden.co_trab = t_trab.co_trab
              and t_iden.ti_docu_iden = 'DNI'
         order by t_iden.nu_docu_iden
;

