create or replace force view v_anexo17a as
select a.aqpa301ndoc                                    nu_docu_iden,
         b.pfape1                                         no_apel_pate,
         b.pfape2                                         no_apel_mate,
         trim(b.pfnom1) || ' ' || trim(b.pfnom2)          no_trab,
         b.pfcant                                         st_sexo,
         to_char(c.tp1nro1)                               co_pues_trab,
         upper(c.tp1desc)                                 de_pues_trab,
         '-'                                              de_unid,
         a.aqpa301ax7                                     carg_conf,
         to_char(a.aqpa301fini, 'rrrr.mm.dd')             fe_ingr_emp,
         to_char(a.aqpa301fces, 'rrrr.mm.dd')             fe_cese_trab,
         decode(a.aqpa301est, 'S', 'ACTIVO', 'CESADO')    emp_estado,
         a.aqpa301pais                                    pais,
         a.aqpa301tdoc                                    tipodoc
    from aqpa301 a, fsd002 b, fst198 c
   where a.aqpa301pais = b.pfpais
     and a.aqpa301tdoc = b.pftdoc
     and a.aqpa301ndoc = b.pfndoc
     and a.aqpa301carg = c.tp1nro1
     and c.tp1cod = 1
     and c.tp1cod1 = 11136
     and c.tp1corr1 = 2
  union
  select distinct
       ide.nu_docu_iden, per.no_apel_pate, per.no_apel_mate, per.no_trab, per.st_sexo,
       emp.co_pues_trab, pue.de_pues_trab, uni.de_unid,
       case emp.co_cali_trab when 'CON' then 'CONFIANZA' when 'DIR' then 'DIRECCION' else '' end as carg_conf,
         to_char(emp.fe_ingr_empr,'YYYY.MM.DD') as fe_ingr_emp,
         to_char(emp.fe_cese_trab,'YYYY.MM.DD') as fe_cese_trab,
         case emp.ti_situ when 'ACT' then 'ACTIVO' when 'ANU' then 'CESADO' end as emp_estado,
          604 pais,
          21 tipodoc
    from tmtrab_pers@ofiplan per
    left outer join tdiden_trab@ofiplan ide on per.co_trab=ide.co_trab and ti_docu_iden='DNI'
    left outer join tmtrab_empr@ofiplan emp on per.co_trab=emp.co_trab
    left outer join ttpues_trab@ofiplan pue on emp.co_pues_trab=pue.co_pues_trab
    left outer join ttcali_trab@ofiplan cal on emp.co_cali_trab=cal.co_cali_trab
    left outer join ttcate_trab@ofiplan cat on emp.co_cate_trab=cat.co_cate_trab
    left outer join ttcate_plan@ofiplan pla on emp.co_plan=pla.co_cate_plan
    left outer join tmunid_empr@ofiplan uni on emp.co_unid=uni.co_unid
    where (to_char(emp.fe_cese_trab,'YYYY')>=to_char(sysdate,'YYYY')-2 or emp.fe_cese_trab is null) and emp.co_cali_trab not in ('CON','DIR')
  union
  select a.aqpa301ndoc,
         b.pfape1,
         b.pfape2,
         trim(b.pfnom1) || ' ' || trim(b.pfnom2),
         b.pfcant,
         'DIRECT',
         'DIRECTORIO',
         'DIRECTORIO',
         upper(c.tp1desc),
         to_char(a.aqpa301fini, 'rrrr.mm.dd'),
         to_char(a.aqpa301fces, 'rrrr.mm.dd'),
         decode(a.aqpa301est, 'S', 'ACTIVO', 'CESADO'),
         a.aqpa301pais,
         a.aqpa301tdoc
    from aqpa301 a, fsd002 b, fst198 c
   where a.aqpa301pais = b.pfpais
     and a.aqpa301tdoc = b.pftdoc
     and a.aqpa301ndoc = b.pfndoc
     and a.aqpa301carg = c.tp1corr2
     and c.tp1cod = 1
     and c.tp1cod1 = 11136
     and c.tp1corr1 = 1
   order by 2, 3, 4;

