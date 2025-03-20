create or replace package PQ_CR_CREDITOS is

-- Author  : MARAUJO
-- Created : 02/03/2011 04:23:53 p.m.
-- Purpose : OBTIENE DATOS GENERALES

/*Procedure sp_job_tipifica_datos(pd_fecpro in varchar2);

Procedure sp_tipificacion_datos(pn_numsuc in number, pd_fecpro in varchar2);*/

function fn_cuotas_pagadas(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number;

function fn_Saldo_relacion(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pn_nrorel in number,
                           pn_rubro  in number) return number;

function fn_Saldo_relacion_mo(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pn_nrorel in number,
                              pn_rubro  in number) return number;

function fn_Saldo_garantia_real(pn_instancia in number) return number;

function fn_Saldo_garantia_dpf(pn_instancia in number) return number;

function fn_Saldo_garantia_sin(pn_instancia in number) return number;

/*Procedure sp_job_caja_ahorro_datos(pd_fecpro in varchar2);*/

Procedure sp_caja_ahorro_datos(pn_numsuc in number, pd_fecpro in varchar2);

function fn_Saldo_rubro(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_oper   in number,
                        pn_sbop   in number,
                        pn_top    in number,
                        pd_fecpro in date,
                        pn_rubro  in number) return number;

function fn_monto_pagado(pn_emp    in number,
                         pn_mod    in number,
                         pn_suc    in number,
                         pn_mda    in number,
                         pn_pap    in number,
                         pn_cta    in number,
                         pn_oper   in number,
                         pc_tipo   in varchar2,
                         pn_sbop   in number,
                         pn_top    in number,
                         pd_feccuo in date,
                         pd_fecini in date,
                         pd_fecfin in date) return number;

function fn_tipo_pago(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_oper   in number,
                      pc_tipo   in varchar2,
                      pn_sbop   in number,
                      pn_top    in number,
                      pd_feccuo in date,
                      pd_fecini in date,
                      pd_fecfin in date) return varchar2;

function fn_mto_aprobado(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_oper  in number,
                         pn_sbop  in number,
                         pn_top   in number,
                         pn_aoimp in number) return number;

function fn_capital_pagado(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top  in number) return number;

function fn_cuota_atrasada(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number;

function fn_monto_atrasado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number;

function fn_saldo_relacion2(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_oper   in number,
                            pn_sbop   in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pn_nrorel in number,
                            pc_rubro  in varchar2) return number;

function fn_nro_cuota(pn_emp  in number,
                      pn_mod  in number,
                      pn_suc  in number,
                      pn_mda  in number,
                      pn_pap  in number,
                      pn_cta  in number,
                      pn_oper in number,
                      pn_sbop in number,
                      pn_top  in number) return number;

function fn_nro_cuota_pendiente(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_oper   in number,
                                pn_sbop   in number,
                                pn_top    in number,
                                pd_fecpro in date) return number;
function fn_mto_desembolsado(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pn_aoimp  in number,
                             pd_fecpro in date) return number;

/*Procedure sp_job_cartera(pd_fecpro in varchar2);

Procedure sp_cartera(pn_numsuc in number, pd_fecpro in varchar2);*/

function FN_FACULTAD_CTA(vpgcod  number,
                         vscsuc  number,
                         vscmda  number,
                         vscpap  number,
                         vsccta  number,
                         vscoper number,
                         vscsbop number,
                         vsctope number,
                         vscmod  number) return varchar2;

function fn_solo_capital_atrasado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number;
  function fn_cuota_vencida(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date
                           ) return number;                           
end PQ_CR_CREDITOS;
/

create or replace package body PQ_CR_CREDITOS is
/*
 Procedure sp_job_tipifica_datos (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
     execute immediate ('truncate table migra2.reportes');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete Tab_jobs where  c_Codage = 'ADTE';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  sp_tipificacion_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2,--jflor
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('ADTE',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AUDIT',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

Procedure sp_tipificacion_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300);
cursor rubro is
  select /*+parallel(a,4,1)*--/rubro
    from fsd014 a
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144)---, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
--ld_fecant date;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADTE';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);

  for i in rubro loop
     begin
       insert /*+parallel(migra2.reportes,4,1)* --/into migra2.reportes --jflor
              (
              BCCTA,C_CODSBS,PENOM,BCSUC,BCMOD,BCTOP,BCOPER,
              BCSBOP,BCFVAL,monto_aprobado,producto,dias_mora,bcmda,
              cate06,categoria,cate01,estado,bcsdmo,bcsdmn,importe1,
              cod_ana,importe2,importe3,importe4,numer01,numer02,
              bcfvto,numer03,valor_cuota,fecha1,n_tippeq,
              numer04,numer05,numer06,bcrubr,tipo_credito_sbs
              )
       select/*+all_rows parallel(a,4,1)*--/ --jflor
             sal.bccta,--1
             pq_datos_fin_mes.fn_codsbs(cta.pepais,cta.petdoc,cta.pendoc, sal.bccta),--2
             nom.penom,--3
             sal.bcsuc,--4
             sal.bcmod,--5
             sal.bctop,--5
             sal.bcoper,
             sal.bcsbop,
             sal.bcfval,--6
             Case when Substr(sal.bcrubr,4,1) = 4
                 or (Substr(sal.bcrubr,4,1) = 5  and Substr(sal.bcrubr,7,2) = 19)  then
                 pq_datos_fin_mes.fn_mto_aprobado(sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,pre.aoimp)
                 else pre.aoimp end,--7
             a.tonom,--8
             fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,0,sal.BCFVTO)dias_mora,--9
             sal.bcmda,--10
             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,6),--11
             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,4),--12
             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,1),--13
             (Case
                                When Substr(bcrubr,1,2) = '14' and
                                     Substr(bcrubr,4,1) = '1' then 'NORMAL'
                                When Substr(bcrubr,1,2) = '14' and
                                     Substr(bcrubr,4,1) = '3' then 'REPROGRAMADO'
                                When Substr(bcrubr,1,2) = '14' and
                                     Substr(bcrubr,4,1) = '4' then 'REFINANCIADO'
                                When Substr(bcrubr,1,2) = '14' and
                                     Substr(bcrubr,4,1) = '5' then 'VENCIDO'
                                When Substr(bcrubr,1,2) = '14' and
                                     Substr(bcrubr,4,1) = '6' then 'JUDICIAL'
                                Else                                'NORMAL'
                             End)Estado_Contable, --14
             sal.bcsdmo,--15
             sal.bcsdmn,
             Case when Substr(sal.bcrubr,4,1) = 4
                  or (Substr(sal.bcrubr,4,1) = 5  and Substr(sal.bcrubr,7,2) = 19)  then pre.aoimp
                  else 0 end, --16
             fn_analista_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),--17
             fn_Saldo_relacion (sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,
                           ld_fecpro, 1,sal.bcrubr ),--18
             fn_Saldo_relacion (sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,
                           ld_fecpro, 203,sal.bcrubr ),--19
             fn_Saldo_relacion (sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,
                           ld_fecpro, 335,sal.bcrubr ),--20
             fn_Saldo_relacion (sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,
                           ld_fecpro, 635,sal.bcrubr ),--21
             fn_Saldo_relacion (sal.bcemp, sal.bcmod,sal.bcsuc,sal.bcmda,
                           sal.bcpap, sal.bccta, sal.bcoper,sal.bcsbop,sal.bctop,
                           ld_fecpro, 35,sal.bcrubr ),--22
             sal.bcfvto,--23
             pq_datos_fin_mes.fn_nro_cuotas(sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap,
                                     sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),--24
             pq_datos_fin_mes.fn_valor_cuota_al_mes(sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap,
                                           sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop, ld_fecpro),--25
             pq_datos_fin_mes.fn_Fec_Ultimo_pago(sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap,
                                           sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),--26
             fn_cuotas_pagadas (sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,sal.bcpap,
                                           sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),--27
             fn_Saldo_garantia_real(fn_instancia_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop)),--28
             fn_Saldo_garantia_dpf(fn_instancia_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop)),--29
             fn_Saldo_garantia_sin(fn_instancia_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop)),--30
       sal.bcrubr,
       Case When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '02' then 'MICRO'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '03' then 'CONSUMO'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '12' then 'MEDIANA'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '13' then 'PEQUEÑA'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '02' then 'MICRO'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '03' then 'CONSUMO'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '12' then 'MEDIANA'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '13' then 'PEQUEÑA'
                        Else ''
                   End Tipo_Credito
        from fsh012 sal, fsr008 cta, fsd010 pre,
             fst014 tdo, fsd001 nom, fst004 a
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech = ld_fecpro
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro
         and cta.pgcod  = 1
         and cta.cttfir = 'T'
         and cta.petdoc = tdo.tdocum
         and cta.pepais = nom.pepais
         and cta.petdoc = nom.petdoc
         and cta.pendoc = nom.pendoc
         and a.modulo = sal.bcmod
         and a.totope = sal.bctop
         and sal.bcemp  = pre.pgcod (+)
         and sal.bcmod  = pre.aomod (+)
         and sal.bcsuc  = pre.aosuc (+)
         and sal.bcmda  = pre.aomda (+)
         and sal.bcpap  = pre.aopap (+)
         and sal.bccta  = pre.aocta (+)
         and sal.bcoper = pre.aooper (+)
         and sal.bcsbop = pre.aosbop (+)
         and sal.bctop  = pre.aotope (+);
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AUDIT',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;

     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'ADTE';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ADTE';
    commit;
    return;

end sp_tipificacion_datos;
*/

function fn_cuotas_pagadas(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,4,1)*/
     sum(count(*))
      into ln_numcuotas
      from fsd602 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.pp1fech <= pd_fecpro
       and o.pp1stat = 'T'
       and o.d602co = 'S'
     group by o.PGCOD,
              o.PPMOD,
              o.PPSUC,
              o.PPMDA,
              o.PPPAP,
              o.PPCTA,
              o.PPOPER,
              o.PPSBOP,
              o.PPTOPE,
              o.PPFPAG;
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return ln_numcuotas;
end fn_cuotas_pagadas;

function fn_Saldo_relacion(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pn_nrorel in number,
                           pn_rubro  in number) return number is
  ln_saldo number;
begin
  begin
    select s.bcsdmn
      into ln_saldo
      from fsr014 r, fsh012 s
     where s.bcemp = pn_emp
       and s.bcsuc = pn_suc
       and r.rubro = pn_rubro
       and r.rrrubr = s.bcrubr
       and r.rrcod = pn_nrorel
       and s.bcmda = pn_mda
       and s.bcpap = pn_pap
       and s.bccta = pn_cta
       and s.bcoper = pn_oper
       and s.bcsbop = pn_sbop
          --and s.bcmod = pn_mod
          --and s.bctop = pn_top
       and s.bcfech = pd_fecpro;
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_relacion;

function fn_Saldo_relacion_mo(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pn_nrorel in number,
                              pn_rubro  in number) return number is
  ln_saldo number;
begin
  begin
    select s.bcsdmo
      into ln_saldo
      from fsr014 r, fsh012 s
     where s.bcemp = pn_emp
       and s.bcsuc = pn_suc
       and r.rubro = pn_rubro
       and r.rrrubr = s.bcrubr
       and r.rrcod = pn_nrorel
       and s.bcmda = pn_mda
       and s.bcpap = pn_pap
       and s.bccta = pn_cta
       and s.bcoper = pn_oper
       and s.bcsbop = pn_sbop
          --and s.bcmod = pn_mod
          --and s.bctop = pn_top
       and s.bcfech = pd_fecpro;
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_relacion_mo;

function fn_Saldo_garantia_real(pn_instancia in number) return number is
  ln_saldo number;
begin
  begin
    select /*+parallel(d,4,1)*/
     sum(decode(d.sng122mda, 0, d.sng122mtou, d.sng122mtou * d.sng122tcbi))
      into ln_saldo
      from sng122 d
     where d.sng122inst = pn_instancia
       and d.sng122tope not in (5, 80, 85, 90, 91);
  
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_garantia_real;

function fn_Saldo_garantia_dpf(pn_instancia in number) return number is
  ln_saldo number;
begin
  begin
    select /*+parallel(d,4,1)*/
     sum(decode(d.sng122mda, 0, d.sng122mtou, d.sng122mtou * d.sng122tcbi))
      into ln_saldo
      from sng122 d
     where d.sng122inst = pn_instancia
       and d.sng122tope in (80, 85);
  
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_garantia_dpf;

function fn_Saldo_garantia_sin(pn_instancia in number) return number is
  ln_saldo number;
begin
  begin
    select /*+parallel(d,4,1)*/
     sum(decode(d.sng122mda, 0, d.sng122mtou, d.sng122mtou * d.sng122tcbi))
      into ln_saldo
      from sng122 d
     where d.sng122inst = pn_instancia
       and d.sng122tope in (90, 91);
  
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_garantia_sin;

/*Procedure sp_job_caja_ahorro_datos (pd_fecpro in varchar2) is
---  ln_max number;
--  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin

     execute immediate ('truncate table migra2.reportes');
     delete Tab_jobs where  c_Codage = 'ADTX';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  sp_caja_ahorro_datos('||ln_ini||','||''''||Pd_FECpro||''''||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2,
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('ADTX',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ADTX',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  */
Procedure sp_caja_ahorro_datos(pn_numsuc in number, pd_fecpro in varchar2) is

  ld_fecpro date;
  lc_coderr varchar2(300);

  cursor rubro2 is
    select rubro
      from fsd014
     where (pcnivc in (21, 22))
       and pcimpu = 'S'
       and pmtit <> 9
       and pcrub <> 281;

  cursor rubro3 is --- Obligaciones con el publico
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_1%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_2%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_3%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_5%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_6%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro like '21_7%'
       and pcimpu = 'S'
    union all
    select rubro --, pcrub,pmtit,pcnivc
      from fsd014
     where rubro = 2118030200004 --like '21_1%'
       and pcimpu = 'S';

begin

  execute immediate ('alter session set parallel_force_local=TRUE');

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADTX';
  commit;
  ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');

  --for i in rubro2  loop
  for i in rubro3 loop
    begin
      insert into reportes
        (BCRUBR,
         BCSDMN,
         BCEMP,
         BCMOD,
         BCSUC,
         BCMDA,
         BCPAP,
         BCCTA,
         BCOPER,
         BCSBOP,
         BCTOP,
         BCFVAL,
         BCFVTO, --PEPAIS,PETDOC,PENDOC,
         --TDNOM,
         fecha1,
         TEA,
         bcsdmo,
         producto,
         text01, -- agencia
         importe1, -- interes
         text02
         
         )
        select /*+all_rows index_ss(pro) parallel(tdo,2,1)*/
        
         sal.bcrubr,
         sal.bcsdmn,
         sal.BCEMP,
         sal.bcmod,
         sal.bcsuc,
         sal.bcmda,
         sal.bcpap,
         sal.bccta,
         sal.bcoper,
         sal.bcsbop,
         sal.bctop,
         sal.bcfval,
         sal.bcfvto,
         --cta.pepais,
         --cta.petdoc,
         --cta.pendoc,
         --tdo.tdnom,
         sal.bcfech,
         sal.bctasa,
         sal.bcsdmo,
         pro.tonom,
         age.scnom,
         fn_Saldo_relacion(sal.bcemp,
                           sal.bcmod,
                           sal.bcsuc,
                           sal.bcmda,
                           sal.bcpap,
                           sal.bccta,
                           sal.bcoper,
                           sal.bcsbop,
                           sal.bctop,
                           ld_fecpro,
                           1,
                           sal.bcrubr),
         m.mdnom
          from fsh012 sal, -- bantprod.fsr008 cta,
               fst004 pro,
               fst001 age,
               fst003 m
         where sal.bcemp = 1
           and sal.bcsuc = pn_numsuc
           and sal.bcsuc = age.sucurs
           and sal.bcmod = pro.modulo(+)
           and sal.bctop = pro.totope(+)
           and sal.bcfech = ld_fecpro
           and sal.bcrubr = i.rubro
           and sal.bcmod = m.modulo(+);
      --and sal.bccta  = cta.ctnro (+)
      --and cta.pgcod  = 1
      --and cta.cttfir = 'T'
      --and cta.petdoc = tdo.tdocum (+) ;
    exception
      when others then
        lc_coderr := sqlerrm;
        INSERT INTO LOG_ERROR_BANDEJA
          (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
        VALUES
          (2, 'ADTX', i.rubro || lc_coderr, TRUNC(SYSDATE));
        COMMIT;
    end;
    commit;
  end loop;
  commit;
  update tab_jobs g
     set g.d_fecfin = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADTX';
  commit;
EXCEPTION
  when others then
    lc_coderr := substr(sqlerrm, 1, 200);
    update tab_jobs g
       set g.c_inderr = 'S', g.c_deserr = lc_coderr
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'ADTX';
    commit;
    return;
  
end;
function fn_Saldo_rubro(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_oper   in number,
                        pn_sbop   in number,
                        pn_top    in number,
                        pd_fecpro in date,
                        pn_rubro  in number) return number is
  ln_saldo number;

begin
  begin
    select s.bcsdmo
      into ln_saldo
      from fsh012 s
     where s.bcemp = pn_emp
       and s.bcsuc = pn_suc
       and s.bcrubr in (select rubro
                          from fsd014
                         where pcnivc = pn_mod
                           and pcimpu = 'S'
                           and pmtit <> 9)
       and s.bcmda = pn_mda
       and s.bcpap = pn_pap
       and s.bccta = pn_cta
       and s.bcoper = pn_oper
       and s.bcsbop = pn_sbop
       and s.bcmod = pn_mod
       and s.bctop = pn_top
       and s.bcfech = pd_fecpro;
  exception
    when others then
      ln_saldo := null;
  end;
  return ln_saldo;
end fn_Saldo_rubro;

-----

function fn_monto_pagado(pn_emp    in number,
                         pn_mod    in number,
                         pn_suc    in number,
                         pn_mda    in number,
                         pn_pap    in number,
                         pn_cta    in number,
                         pn_oper   in number,
                         pc_tipo   in varchar2,
                         pn_sbop   in number,
                         pn_top    in number,
                         pd_feccuo in date,
                         pd_fecini in date,
                         pd_fecfin in date) return number is
  ln_mto_pagado number;
  ld_fecpxv     date;
begin

  begin
    select sum(c.PP1CAP + c.PP1INT)
      into ln_mto_pagado
      from fsd602 c
     where c.pgcod = pn_emp
       and c.ppsuc = pn_suc
       and c.ppmda = pn_mda
       and c.pppap = pn_pap
       and c.ppcta = pn_cta
       and c.ppoper = pn_oper
       and c.ppsbop = pn_sbop
       and c.pptope = pn_top
       and c.ppmod = pn_mod
       and c.ppfpag = pd_feccuo
       and c.PPTIPO = pc_tipo
       and c.d602co = 'S'
          --and c.pp1stat is not null
       and (c.pp1cap + c.pp1int) > 0
       and c.pp1fech between pd_fecini and pd_fecfin;
  exception
    when no_data_found then
      ln_mto_pagado := 0;
    when too_many_rows then
      ln_mto_pagado := 0;
  end;
  return nvl(ln_mto_pagado, 0);
end fn_monto_pagado;

function fn_tipo_pago(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_oper   in number,
                      pc_tipo   in varchar2,
                      pn_sbop   in number,
                      pn_top    in number,
                      pd_feccuo in date,
                      pd_fecini in date,
                      pd_fecfin in date) return varchar2 is
  lc_tippag varchar2(10);

begin

  begin
    select case
             when max(c.pp1stat) = 'T' then
              'Total'
             when max(c.pp1stat) = 'P' then
              'Parcial'
           end
      into lc_tippag
      from fsd602 c
     where c.pgcod = pn_emp
       and c.ppsuc = pn_suc
       and c.ppmda = pn_mda
       and c.pppap = pn_pap
       and c.ppcta = pn_cta
       and c.ppoper = pn_oper
       and c.ppsbop = pn_sbop
       and c.pptope = pn_top
       and c.ppmod = pn_mod
       and c.ppfpag = pd_feccuo
       and c.PPTIPO = pc_tipo
       and c.d602co = 'S'
          --and c.pp1stat is not null
       and (c.pp1cap + c.pp1int) > 0
       and c.pp1fech between pd_fecini and pd_fecfin;
  exception
    when no_data_found then
      lc_tippag := 'No Pago';
    when too_many_rows then
      lc_tippag := 'No Pago';
  end;
  return nvl(lc_tippag, 'No Pago');
end fn_tipo_pago;

function fn_mto_aprobado(pn_emp   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_oper  in number,
                         pn_sbop  in number,
                         pn_top   in number,
                         pn_aoimp in number) return number is
  ln_numcuo number;
begin
  begin
    if pn_mod = 108 then
      ln_numcuo := pn_aoimp;
    else
    
      select m.xllcapital
        into ln_numcuo
        from X054023 m
       where m.xllpgcod = pn_emp
         and m.xllaocta = pn_cta
         and m.xllaooper = pn_oper
         and m.xllaosbop = pn_sbop
         and m.xllaotop = pn_top
         and m.xllaomod = pn_mod
         and m.xllaosuc = pn_suc
         and m.xllaomda = pn_mda
         and m.xllaopap = pn_pap;
    end if;
  exception
    when no_data_found then
      begin
        select m.xllcapital
          into ln_numcuo
          from X054023 m
         where m.xllpgcod = pn_emp
           and m.xllaocta = pn_cta
           and m.xllaooper = pn_oper
              --and m.xllaosuc  = pn_suc
           and m.xllaomda = pn_mda
           and m.xllaopap = pn_pap
           and rownum = 1;
      exception
        when others then
          ln_numcuo := null;
      end;
    when too_many_rows then
      ln_numcuo := null;
  end;
  return ln_numcuo;
end fn_mto_aprobado;

function fn_capital_pagado(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top  in number) return number is
  ln_mto_pagado number;
  ld_fecpxv     date;
begin

  begin
    select sum(c.PP1CAP)
      into ln_mto_pagado
      from fsd602 c
     where c.pgcod = pn_emp
       and c.ppsuc = pn_suc
       and c.ppmda = pn_mda
       and c.pppap = pn_pap
       and c.ppcta = pn_cta
       and c.ppoper = pn_oper
       and c.ppsbop = pn_sbop
       and c.pptope = pn_top
       and c.ppmod = pn_mod
       and c.d602co = 'S'
          --and c.pp1stat is not null
       and (c.pp1cap) > 0;
  exception
    when no_data_found then
      ln_mto_pagado := 0;
    when too_many_rows then
      ln_mto_pagado := 0;
  end;
  return nvl(ln_mto_pagado, 0);
end fn_capital_pagado;
function fn_cuota_atrasada(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2)*/
     count(*)
      into ln_numcuotas
      from fsd601 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.ppfpag <= pd_fecpro
       and o.d601co = 'S'
       and not exists (select *
              from fsd602 x
             where x.pgcod = o.pgcod
               and x.ppmod = o.ppmod
               and x.ppsuc = o.ppsuc
               and x.ppmda = o.ppmda
               and x.pppap = o.pppap
               and x.ppcta = o.ppcta
               and x.ppoper = o.ppoper
               and x.ppsbop = o.ppsbop
               and x.pptope = o.pptope
               and x.pp1fech <= pd_fecpro
               and x.pp1stat = 'T'
               and x.ppfpag = o.ppfpag
               and x.d602co = 'S');
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return nvl(ln_numcuotas, 0);
end fn_cuota_atrasada;

function fn_monto_atrasado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2)*/
     sum(o.ppcap + o.ppint)
      into ln_numcuotas
      from fsd601 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.ppfpag <= pd_fecpro
       and o.d601co = 'S'
       and not exists (select *
              from fsd602 x
             where x.pgcod = o.pgcod
               and x.ppmod = o.ppmod
               and x.ppsuc = o.ppsuc
               and x.ppmda = o.ppmda
               and x.pppap = o.pppap
               and x.ppcta = o.ppcta
               and x.ppoper = o.ppoper
               and x.ppsbop = o.ppsbop
               and x.pptope = o.pptope
               and x.pp1fech <= pd_fecpro
               and x.pp1stat = 'T'
               and x.ppfpag = o.ppfpag
               and x.d602co = 'S');
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return nvl(ln_numcuotas, 0);
end fn_monto_atrasado;
function fn_saldo_relacion2(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_oper   in number,
                            pn_sbop   in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pn_nrorel in number,
                            pc_rubro  in varchar2) return number is
  ln_saldo  number;
  ln_rubro1 number;
  ln_rubro  number;
  lc_error  varchar2(300);
  ln_cuenta number := 0;
begin
  ln_rubro1 := 0;
  begin
    select sum(bcsdmn) --, max(bcrubr), count(*) 
      into ln_saldo --, ln_rubro, ln_cuenta
      from (select /*+ index(fsh012 fsh1204) */
            distinct s.bcsdmn, s.bcrubr
              from fsr014 r, fsh012 s
             where s.bcemp = pn_emp
               and s.bcsuc = pn_suc
               and r.rrrubr = s.bcrubr
               and r.rrcod = pn_nrorel
               and r.rrrubr like pc_rubro
               and s.bcrubr like pc_rubro
               and s.bcmda = pn_mda
               and s.bcpap = pn_pap
               and s.bccta = pn_cta
               and s.bcoper = pn_oper
                  --and s.bcsbop= pn_sbop
               and s.bcfech = pd_fecpro);
  exception
    when others then
      --lc_error := sqlerrm;
      ln_saldo := null;
      --          ln_rubro := null;   
  end;
  return nvl(ln_saldo, 0);

end;

function fn_nro_cuota(pn_emp  in number,
                      pn_mod  in number,
                      pn_suc  in number,
                      pn_mda  in number,
                      pn_pap  in number,
                      pn_cta  in number,
                      pn_oper in number,
                      pn_sbop in number,
                      pn_top  in number) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2)*/
     count(*)
      into ln_numcuotas
      from fsd601 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.d601co = 'S';
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return nvl(ln_numcuotas, 0);
end fn_nro_cuota;

function fn_nro_cuota_pendiente(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_oper   in number,
                                pn_sbop   in number,
                                pn_top    in number,
                                pd_fecpro in date) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2)*/
     count(*)
      into ln_numcuotas
      from fsd601 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.d601co = 'S'
       and not exists (select *
              from fsd602 x
             where x.pgcod = o.pgcod
               and x.ppmod = o.ppmod
               and x.ppsuc = o.ppsuc
               and x.ppmda = o.ppmda
               and x.pppap = o.pppap
               and x.ppcta = o.ppcta
               and x.ppoper = o.ppoper
               and x.ppsbop = o.ppsbop
               and x.pptope = o.pptope
               and x.pp1fech <= pd_fecpro
               and x.pp1stat = 'T'
               and x.ppfpag = o.ppfpag
               and x.d602co = 'S');
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return nvl(ln_numcuotas, 0);
end fn_nro_cuota_pendiente;

function fn_mto_desembolsado(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pn_aoimp  in number,
                             pd_fecpro in date) return number is
  ln_incre number;
begin
  begin
    select sum(x.pp1cap)
      into ln_incre
      from fsd602 x
     where x.pgcod = pn_emp
       and x.ppmod = pn_mod
       and x.ppsuc = pn_suc
       and x.ppmda = pn_mda
       and x.pppap = pn_pap
       and x.ppcta = pn_cta
       and x.ppoper = pn_oper
       and x.ppsbop = pn_sbop
       and x.pptope = pn_top
       and x.pp1fech <= pd_fecpro
       and x.pp1stat is null
       and x.d602co = 'S'
       and x.pp1cap < 0;
  exception
    when no_data_found then
      ln_incre := 0;
  end;
  return nvl(abs(ln_incre), 0) + pn_aoimp;
end fn_mto_desembolsado;
/*
Procedure sp_job_cartera (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
     execute immediate ('truncate table migra2.cartera_dic');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete Tab_jobs where  c_Codage = 'ADTE';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  sp_cartera('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2,--jflor
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('ADTE',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AUDIT',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

Procedure sp_cartera (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300);
cursor rubro is
  select rubro
          from fsd014
         where pcimpu = 'S'
           and pcnivc in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144))
           and pmtit <> 9;
--ld_fecant date;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADTE';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);

  for i in rubro loop
     begin
       insert /*+parallel(migra2.reportes,4,1)*--/into migra2.cartera_dic --jflor
              (BCCTA,NOMBRE,PRODUCTO,CREDITO,BCFVAL,BCFVTO,BCFATR,MTO_APROBADO,
               CAPITAL_PAGADO,CUOTA_ATRASA,DIA_ATRASO,CAPITAL_VENCIDO,SALO_CAPITAL,
               SALO_CAPITAL_MN,SALDO_INTERES,MORA,OTROS,TOTAL,CAPITAL_DESEMBOLSADO,
               BCMDA,MONEDA,BCRUBR,NOMBRE_RUBRO,SITUACION,TIPO_CREDITO_SBS,ESTADO,
               FECHA_VENCIMIENTO,GRUPO_PRODUCTO,SUCURSAL,NRO_CUOTAS,NRO_CUOTAS_PENDIENTES,
               CALIFICACION,TASA)
       
       select bccta, 
       (select cc.ctnom from fsd008 cc where cc.ctnro=bccta) nombre,
       (select tonom from fst004 where modulo = bcmod and totope = bctop) PRODUCTO,
       bcmod||'-'||bctop||'-'||bcmda||'-'||
       bccta||'-'||bcoper||'-'||
       bcsbop credito,
       a.bcfval,
       a.bcfvto,
       a.bcfatr,
       fn_mto_aprobado(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop, bctop,c.aoimp ) mto_aprobado,
       fn_capital_pagado(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop, bctop ) Capital_pagado,
       fn_cuota_atrasada(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop, bctop, bcfech ) cuota_atrasa,
       fn_dias_atraso(bcfech,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,bcprod,bcfvto) dia_atraso,
       Case when substr(a.bcrubr,1,4) in ('1415','1425') then abs(a.bcsdmn)else 0 end Capital_Vencido,
       abs(a.bcsdmo) Salo_Capital, abs(a.bcsdmn) Salo_Capital_MN,
       abs(fn_Saldo_relacion2(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,bcfech,1,'14_8%')) Saldo_interes,
       (select jaql964mor from JAQL964 j ---operador.jaql964_20141130 j
         where JAQL964CTA   = a.bccta
           and JAQL964OPE   = a.bcoper
           and JAQL964MOD   = a.bcmod
           and JAQL964MDA   = a.bcmda
           and JAQL964SUC   = a.bcsuc
           and jaql964sob  = a.bcsbop
           and jaql964top  = a.bctop )mora,
       (select jaql964gas from JAQL964 j---operador.jaql964_20141130 j
         where JAQL964CTA   = a.bccta
           and JAQL964OPE   = a.bcoper
           and JAQL964MOD   = a.bcmod
           and JAQL964MDA   = a.bcmda
           and JAQL964SUC   = a.bcsuc
           and jaql964sob  = a.bcsbop
           and jaql964top  = a.bctop )otros, 
           0 total,
           fn_mto_desembolsado(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,c.aoimp, bcfech) Capital_desembolsado, 
           BCMDA,
           decode(BCMDA,0,'Soles','Dolares') moneda,
           bcrubr,
           (select pcnomr from fsd014 where rubro = bcrubr) nombre_rubro,
           case when substr(bcrubr, 1, 4) in ('1411','1421') then 'Vigente'
                when substr(bcrubr, 1, 4) in ('1415','1425') then 'Vencido'
                when substr(bcrubr, 1, 4) in ('1414','1424') then 'Refinanciado'
                when substr(bcrubr, 1, 4) in ('1416','1426') then 'Judicial'
                when substr(bcrubr, 1, 1) = '8' then 'Castigado' end situacion,
           -- No_Desembolsado,
           --null planilla,
           case when bcgpo = 2 then 'MICRO EMPRESA'
             when bcgpo = 3 then 'CONSUMO'
             when bcgpo = 4 then 'HIPOTECARIO'
             when bcgpo = 12 then 'MEDIANA EMPRESA'
             when bcgpo = 13 then 'PEQUEÑA EMPRESA'
             when bcgpo = 9 then 'COORP. ENTIDAD FINANCIERA'
             else 'OTRO' END tipo_Credito_SBS,
      g.cenom  estado,
      bcfvto fecha_vencimiento,
      (select mdnom from fst003 where modulo = bcmod) grupo_Producto,
      b.scnom sucursal,
      fn_nro_cuota(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop)nro_cuotas,
      fn_nro_cuota_pendiente(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,bcsbop,bctop,bcfech)nro_cuotas_pendientes,       
      a.bccate calificacion,
      a.bctasa tasa
  from fsh012 a, fst001 b, fsd010 c,  fst811 g, fst810 h,  fst026 g 
 where bcemp = 1
   and bcfech = ld_fecpro --to_date('20141231', 'yyyymmdd')
   and bcrubr = i.rubro/*in
       (select rubro
          from fsd014
         where pcimpu = 'S'
           and pcnivc in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144))
           and pmtit <> 9)*--/
   and a.bcemp = b.pgcod
   and a.bcsuc = pn_numsuc
   and a.bcsuc = b.sucurs  
   and c.pgcod(+)  = bcemp 
   and aoMOD  (+)  = bcmod 
   and aoSUC  (+)  = bcsuc 
   and aoMDA  (+)  = bcmda 
   and aoPAP  (+)  = bcpap 
   and aoCTA  (+)  = bccta 
   and aoOPER (+)  = bcoper
   and aoSBOP (+)  = bcsbop
   and c.Aotope(+) = bctop 
   and g.pgcod = a.bcemp
   and g.oficod = a.bcsuc
   and g.regcod < 100
   and h.pgcod = g.pgcod
   and h.regcod= g.regcod 
   and g.cecod = a.bcprod
       ;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AUDIT',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;

     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'ADTE';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ADTE';
    commit;
    return;

end sp_cartera;*/
function FN_FACULTAD_CTA(vpgcod  number,
                         vscsuc  number,
                         vscmda  number,
                         vscpap  number,
                         vsccta  number,
                         vscoper number,
                         vscsbop number,
                         vsctope number,
                         vscmod  number) return varchar2 is
  facultad varchar2(12);
begin
  select Case R2sbop
           when 1 then
            'INDIVIDUAL'
           when 511 then
            'MANCOMUNADA'
           else
            'INDISTINTA'
         end
    into facultad
    from fsr011
   Where Relcod = 5
     and R1cod = vpgcod
     and R1mod = vscmod
     and R1suc = vscsuc
     and R1mda = vscmda
     and R1pap = vscpap
     and R1cta = vsccta
     and R1oper = vscoper
     and R1sbop = vscsbop
     and R1tope = vsctope
     and rownum = 1;

  return(facultad);
exception
  when no_data_found then
    begin
      select Case ctfaccor
               when 1 then
                'INDIVIDUAL'
               when 511 then
                'MANCOMUNADA'
               else
                'INDISTINTA'
             end
        into facultad
        from fse130
       where pgcod = vpgcod
         and ctnro = vsccta
         and rownum = 1;
    exception
      when no_data_found then
        facultad := 'NINGUNA';
    end;
    return(facultad);
end FN_FACULTAD_CTA;
function fn_solo_capital_atrasado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number is
  ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2)*/
     sum(o.ppcap)
      into ln_numcuotas
      from fsd601 o
     where o.pgcod = pn_emp
       and o.ppmod = pn_mod
       and o.ppsuc = pn_suc
       and o.ppmda = pn_mda
       and o.pppap = pn_pap
       and o.ppcta = pn_cta
       and o.ppoper = pn_oper
       and o.ppsbop = pn_sbop
       and o.pptope = pn_top
       and o.ppfpag <= pd_fecpro
       and o.d601co = 'S'
       and not exists (select *
              from fsd602 x
             where x.pgcod = o.pgcod
               and x.ppmod = o.ppmod
               and x.ppsuc = o.ppsuc
               and x.ppmda = o.ppmda
               and x.pppap = o.pppap
               and x.ppcta = o.ppcta
               and x.ppoper = o.ppoper
               and x.ppsbop = o.ppsbop
               and x.pptope = o.pptope
               and x.pp1fech <= pd_fecpro
               and x.pp1stat = 'T'
               and x.ppfpag = o.ppfpag
               and x.d602co = 'S');
  exception
    when no_data_found then
      ln_numcuotas := null;
    when too_many_rows then
      ln_numcuotas := -1;
    when others then
      ln_numcuotas := -0;
  end;
  return nvl(ln_numcuotas, 0);
  end fn_solo_capital_atrasado;
  function fn_cuota_vencida(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date
                           ) return number is
  
  cursor c_cuotas is
    select x.* 
      from (
              select o.*
                from fsd601 o
               where o.pgcod = pn_emp
                 and o.ppmod = pn_mod
                 and o.ppsuc = pn_suc
                 and o.ppmda = pn_mda
                 and o.pppap = pn_pap
                 and o.ppcta = pn_cta
                 and o.ppoper = pn_oper
                 and o.ppsbop = pn_sbop
                 and o.pptope = pn_top
                 and o.d601co = 'S'
            order by ppfpag
            ) x
      where rownum <= 3
    order by x.ppfpag desc;
  ln_cuotas number := 3;
  ln_cont   number := 0;
  ln_cuoatr number := 0;
  ln_valor  number := 0;
  ln_filas  number := 0;
  begin
  for i in c_cuotas loop
      ln_filas := ln_filas + 1;
  End loop;
  for i in c_cuotas loop
    if i.ppfpag <= pd_fecpro then                       
        begin       
          select 1 into ln_valor
            from fsd602 x
           where x.pgcod = i.pgcod
             and x.ppmod = i.ppmod
             and x.ppsuc = i.ppsuc
             and x.ppmda = i.ppmda
             and x.pppap = i.pppap
             and x.ppcta = i.ppcta
             and x.ppoper = i.ppoper
             and x.ppsbop = i.ppsbop
             and x.pptope = i.pptope
             and x.pp1fech <= pd_fecpro
             and x.pp1stat = 'T'
             and x.ppfpag = i.ppfpag
             and x.d602co = 'S'
             and rownum <= 1 ;          
        Exception
        When no_data_found then   
          Case
          When ln_filas = ln_cuotas then  
             ln_cuoatr := ln_cuotas - ln_cont;     
             return ln_cuoatr;
          When ln_filas = ln_cuotas-1 then   
             ln_cuoatr := ln_cuotas-1 - ln_cont;
             return ln_cuoatr;
          When ln_filas = ln_cuotas-2 then               
             ln_cuoatr := ln_cuotas-2 - ln_cont;
             return ln_cuoatr;
          End Case;                                     
        End;       
    End If;
    ln_cont := ln_cont + 1;
    End loop;

  return ln_cuoatr;

  Exception
  When others then
  return ln_cuoatr; 
  end fn_cuota_vencida;

end PQ_CR_CREDITOS;
/

