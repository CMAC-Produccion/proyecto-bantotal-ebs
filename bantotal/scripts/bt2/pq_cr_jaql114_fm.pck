create or replace package pq_cr_jaql114_fm is
 Procedure sp_job_jaql114_datos (pd_fecpro in varchar2 );
 Procedure sp_jaql114_datos (pn_numsuc in number, pd_fecpro in varchar2 );
 function fn_instancia_credito(v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number) return number;
 function fn_analista_credito(v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number) return varchar2;
                               
 function fn_promotor_credito(v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number) return varchar2; 
  function fn_tipo_cliente_credito(v_Scmod  in number,
                                   v_Scsuc  in number,
                                   v_Scmda  in number,
                                   v_Scpap  in number,
                                   v_Sccta  in number,
                                   v_Scoper in number,
                                   v_Scsbop in number,
                                   v_Sctope in number) return varchar2;                              
end pq_cr_jaql114_fm;
/

create or replace package body pq_cr_jaql114_fm is
Procedure sp_job_jaql114_datos (pd_fecpro in varchar2 ) is
-- 2020.11.29 dcastro se comento update
  
  ln_ini number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
  --deshabilitar guia cov19 2020.04.17 dcastro
  update fst198 f set f.tp1nro1 = 0  
     where f.tp1cod = 1
       and f.tp1cod1 = 10872
       and f.tp1corr1 = 100
       and f.tp1corr2 = 1
       and f.tp1corr3 = 1;
  --

     --execute immediate ('truncate table migra2.jaql114');
     delete jaql114 a where a.jaql114fech = to_date(pd_fecpro,'yyyymmdd');
     commit;
     delete Tab_jobs where  c_Codage = 'ASE';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_cr_jaql114_fm.sp_jaql114_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));

--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      --instance => 2,  01/01/2024
                      instance => 1,
                      force => false
                      );
else
           DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('ASE',ln_ini,lc_variable);
        COMMIT;
      end loop; 

/*  2020.11.29 dcastro se comento  
--habilitar guia cov19 2020.04.17 dcastro
  update fst198 f set f.tp1nro1 = 1 
     where f.tp1cod = 1
       and f.tp1cod1 = 10872
       and f.tp1corr1 = 100
       and f.tp1corr2 = 1
       and f.tp1corr3 = 1;
  --
  comentar update
  */

  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'JAQL114',lc_variable||'-'||lc_coderr, SYSDATE);
           COMMIT;
--          p_c_error:=  lc_variable;


  end;
Procedure sp_jaql114_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
select rubro  
 from fsd014 
where pcnivc in (select modulo from fst111 where dscod = 50 and modulo not in (29,/*33,200,*/120,144)/*union all select 117 from dual*/)
  and pcimpu = 'S'
  /*and substr(rubro,1,1) <> 9*/ ;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ASE';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in rubro loop
     begin 
       insert into jaql114 (jaql114fech,jaql114emp,jaql114mod,jaql114suc,
                            jaql114mda,jaql114pap,jaql114cta,jaql114oper,
                            jaql114sbop,jaql114top,jaql114inst,jaql114ase,
                            jaql114rubr,jaql114sdmn,jaql114sdmo,jaql114datr,
                            jaql114fval,jaql114fvto,jaql114pais,jaql114tdoc,
                            jaql114ndoc,jaql114tcrd,JAQL114SECT,jaql114stat,
                            JAQL114PROM,jaql114tpcl,jaql114ttas,jaql114tasa,
                            jaql114atrc
       
       ) 
       select/*+all_rows parallel(sal,2,1)*/
             SAL.BCFECH jaql114fech,
             sal.BCEMP jaql114emp,
             sal.bcmod jaql114mod,
             sal.bcsuc jaql114suc,
             sal.bcmda jaql114mda,
             sal.bcpap jaql114pap,
             sal.bccta jaql114cta,
             sal.bcoper jaql114oper,
             sal.bcsbop jaql114sbop,
             sal.bctop jaql114top,
             pq_cr_jaql114_fm.fn_instancia_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop) jaql114inst,
             pq_cr_jaql114_fm.fn_analista_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop) jaql114ase,
             sal.bcrubr jaql114rubr,
             abs(sal.bcsdmn) jaql114sdmn,
             abs(sal.bcsdmo) jaql114sdmo,
             fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,sal.bcprod,sal.bcfvto) jaql114datr,
             sal.bcfval jaql114fval,
             sal.bcfvto jaql114fvto,
             cta.pepais jaql114pais,
             cta.petdoc jaql114tdoc,
             cta.pendoc jaql114ndoc,
             Case When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '02' then 'MICRO EMPRESA'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '03' then 'CONSUMO'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '09' then 'CORPORATIVO E.I.F.'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '11' then 'GRANDES EMPRESAS'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(sal.bcrubr, 1, 2) = '14' and
                             Substr(sal.bcrubr, 5, 2) = '13' then 'PEQUEÑA EMPRESA'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '02' then 'MICRO EMPRESA'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '03' then 'CONSUMO'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '12' then 'MEDIANA EMPRESA'
                        When Substr(sal.bcrubr,1,2) in ('71','72') and
                             Substr(sal.bcrubr,7,2) = '13' then 'PEQUEÑA EMPRESA'
                        Else ''
                   End jaql114tcrd,
                   pq_datos_fin_mes.fn_cod_interno_pqn (sal.bcmod,sal.bcsuc,sal.bcmda,
                                                        sal.bcpap,sal.bccta,sal.bcoper,
                                                        sal.bcsbop,sal.bctop,ld_fecpro) jalq114sect,
                   sal.bcprod jaql114stat,
                   pq_cr_jaql114_fm.fn_promotor_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop) jaql114prom,
             Pq_cr_jaql114_fm.fn_tipo_cliente_credito(sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop) jaql114tpcl ,
             sal.bcttasa, sal.bctasa,
             pq_cr_diasatraso_cov19.fn_cr_diasatraso_mes(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,sal.bcprod,sal.bcfvto) jaql114atrc--obtener dias atraso  COV19 2020.04.17 dcastro                                    
        from fsh012 sal, fsr008 cta
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech = ld_fecpro
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro (+)
         and cta.pgcod (+) = 1 
         and cta.cttfir (+) = 'T' 
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'JAQL114',pn_numsuc||'-'||i.rubro||'-'||lc_coderr, SYSDATE);
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'ASE';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ASE';
    commit;
    return;

end sp_jaql114_datos;  

function fn_instancia_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return number is

    ln_instancia sng001.sng001inst%type;

  begin

       If v_Scmod = 116 THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join  operador.XWF700_findemes xw2 on xw2.xwfempresa   = rel.r2cod  
                                                  and xw2.xwfmodulo    = rel.r2mod  
                                                  and xw2.xwfsucursal  = rel.r2suc  
                                                  and xw2.xwfmoneda    = rel.r2mda  
                                                  and xw2.xwfpapel     = rel.r2pap  
                                                  and xw2.xwfcuenta    = rel.r2cta  
                                                  and xw2.xwfoperacion = rel.r2oper  
                                                  and xw2.xwfsubope    = rel.r2sbop  
                                                  and xw2.xwftipope    = rel.r2tope 
                                                  and rel.relcod       = 46     
                                                  and xw2.xwfcar3      = '1'
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper= v_Scoper
                   and rel.r1sbop= v_Scsbop
                   and rel.r1tope= v_Sctope;
          
              If ln_instancia is null Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join  operador.XWF700_findemes xw2 on xw2.xwfempresa   = rel.r2cod  
                                                          and xw2.xwfmodulo    = rel.r2mod  
                                                          and xw2.xwfsucursal  = rel.r2suc  
                                                          and xw2.xwfmoneda    = rel.r2mda  
                                                          and xw2.xwfpapel     = rel.r2pap  
                                                          and xw2.xwfcuenta    = rel.r2cta  
                                                          and xw2.xwfoperacion = rel.r2oper  
                                                          and xw2.xwfsubope    = rel.r2sbop  
                                                          and xw2.xwftipope    = rel.r2tope 
                                                          and rel.relcod       = 46     
                         where rel.r1cod = 1
                           and rel.r1mod = v_Scmod
                           and rel.r1suc = v_Scsuc
                           and rel.r1mda = v_Scmda
                           and rel.r1pap = v_Scpap
                           and rel.r1cta = v_Sccta
                           and rel.r1oper= v_Scoper
                           and rel.r1tope= v_Sctope;
                    End;   
              End If;  
          End;         
                     
       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from  operador.XWF700_findemes xw2
                where xw2.xwfempresa   = 1
                  and xw2.xwfsucursal  = v_Scsuc
                  and xw2.xwfmodulo    = v_Scmod
                  and xw2.xwfmoneda    = v_Scmda
                  and xw2.xwfpapel     = v_Scpap
                  and xw2.xwfcuenta    = v_Sccta
                  and xw2.xwfoperacion = v_Scoper
                  and xw2.xwfsubope    = v_Scsbop
                  and xw2.xwftipope    = v_Sctope
                  and xw2.xwfcar3      = '1';
           Exception When Others Then
                      If v_Scmod in (200,33) or  v_Sctope = 550  Then
                         Begin
                                 select max(xw2.xwfprcins)
                                   into ln_instancia
                                   from  operador.XWF700_findemes xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper;
                           end;
                      Else
                      
                           Begin
                                 select xw2.xwfprcins
                                   into ln_instancia
                                   from  operador.XWF700_findemes xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmodulo    = v_Scmod
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper
                                    and xw2.xwftipope    = v_Sctope
                                    and xw2.xwfcar3      = '1';
                           Exception When Others Then
                                  begin
                                       select max(xw2.xwfprcins)
                                         into ln_instancia
                                         from  operador.XWF700_findemes xw2
                                        where xw2.xwfempresa   = 1
                                          and xw2.xwfsucursal  = v_Scsuc
                                          and xw2.xwfmodulo    = v_Scmod
                                          and xw2.xwfmoneda    = v_Scmda
                                          and xw2.xwfpapel     = v_Scpap
                                          and xw2.xwfcuenta    = v_Sccta
                                          and xw2.xwfoperacion = v_Scoper
                                          and xw2.xwftipope    = v_Sctope
                                          and xw2.xwfcar3      = '1';
                                    end;
                           End;         
                           End IF;                           
           End ;
       End IF;
       if nvl(ln_instancia,0) = 0 then 
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from  operador.XWF700_findemes xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;
  return ln_instancia;
  end;
  
  function fn_analista_credito(
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number
                                             ) return varchar2 is

    lc_analista fst046.ubuser%type;
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;    
  begin
   if (v_Scmod = 108) then 
     begin
      SELECT max(pp174cod) 
             into ln_lote
      FROM fpp175 d
      where 
           d.pp175suc  = v_Scsuc
       and d.pp175mda  = v_Scmda
       and d.pp175pap  = v_Scpap
       and d.pp175cta  = v_Sccta
       and d.pp175oper = v_Scoper
       and d.pp175sbop = v_Scsbop
       and d.pp175mod  = v_Scmod
       and d.pp175tope = v_Sctope;
    exception
      when no_data_found then
           ln_lote := null;       
     end;  
       
      begin
       select max(substr(pp178dtext,1,10)) 
              into lc_analista
       from fpp178 
       where 
            pp174cod = ln_lote 
        and pp177codd = 7;
      exception
        when no_data_found then
             lc_analista := null;
      end;        
   else
       If v_Scmod in (116) THEN
          Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel  join  operador.XWF700_findemes xw2 on xw2.xwfempresa   = rel.r2cod  
                                                  and xw2.xwfmodulo    = rel.r2mod  
                                                  and xw2.xwfsucursal  = rel.r2suc  
                                                  and xw2.xwfmoneda    = rel.r2mda  
                                                  and xw2.xwfpapel     = rel.r2pap  
                                                  and xw2.xwfcuenta    = rel.r2cta  
                                                  and xw2.xwfoperacion = rel.r2oper  
                                                  and xw2.xwfsubope    = rel.r2sbop  
                                                  and xw2.xwftipope    = rel.r2tope 
                                                  and rel.relcod       = 46     
                                                  and xw2.xwfcar3      = '1'
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper= v_Scoper
                   and rel.r1sbop= v_Scsbop
                   and rel.r1tope= v_Sctope;
          
              If ln_instancia is null Then
                    Begin
                        select max(xw2.xwfprcins)
                          into ln_instancia
                          From Fsr011 rel  join  operador.XWF700_findemes xw2 on xw2.xwfempresa   = rel.r2cod  
                                                          and xw2.xwfmodulo    = rel.r2mod  
                                                          and xw2.xwfsucursal  = rel.r2suc  
                                                          and xw2.xwfmoneda    = rel.r2mda  
                                                          and xw2.xwfpapel     = rel.r2pap  
                                                          and xw2.xwfcuenta    = rel.r2cta  
                                                          and xw2.xwfoperacion = rel.r2oper  
                                                          and xw2.xwfsubope    = rel.r2sbop  
                                                          and xw2.xwftipope    = rel.r2tope 
                                                          and rel.relcod       = 46     
                         where rel.r1cod = 1
                           and rel.r1mod = v_Scmod
                           and rel.r1suc = v_Scsuc
                           and rel.r1mda = v_Scmda
                           and rel.r1pap = v_Scpap
                           and rel.r1cta = v_Sccta
                           and rel.r1oper= v_Scoper
                           and rel.r1tope= v_Sctope;
                    End;   
              End If;  
          End;         
                     
       Else
           Begin
               select xw2.xwfprcins
                 into ln_instancia
                 from  operador.XWF700_findemes xw2
                where xw2.xwfempresa   = 1
                  and xw2.xwfsucursal  = v_Scsuc
                  and xw2.xwfmodulo    = v_Scmod
                  and xw2.xwfmoneda    = v_Scmda
                  and xw2.xwfpapel     = v_Scpap
                  and xw2.xwfcuenta    = v_Sccta
                  and xw2.xwfoperacion = v_Scoper
                  and xw2.xwfsubope    = v_Scsbop
                  and xw2.xwftipope    = v_Sctope
                  and xw2.xwfcar3      = '1';
           Exception When Others Then
                      If v_Scmod in (200,33) or  v_Sctope = 550  Then
                         Begin
                                 select max(xw2.xwfprcins)
                                   into ln_instancia
                                   from  operador.XWF700_findemes xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper;
                           end;
                      Else
                      
                           Begin
                                 select xw2.xwfprcins
                                   into ln_instancia
                                   from  operador.XWF700_findemes xw2
                                  where xw2.xwfempresa   = 1
                                    and xw2.xwfsucursal  = v_Scsuc
                                    and xw2.xwfmodulo    = v_Scmod
                                    and xw2.xwfmoneda    = v_Scmda
                                    and xw2.xwfpapel     = v_Scpap
                                    and xw2.xwfcuenta    = v_Sccta
                                    and xw2.xwfoperacion = v_Scoper
                                    and xw2.xwftipope    = v_Sctope
                                    and xw2.xwfcar3      = '1';
                           Exception When Others Then
                                  begin
                                       select max(xw2.xwfprcins)
                                         into ln_instancia
                                         from  operador.XWF700_findemes xw2
                                        where xw2.xwfempresa   = 1
                                          and xw2.xwfsucursal  = v_Scsuc
                                          and xw2.xwfmodulo    = v_Scmod
                                          and xw2.xwfmoneda    = v_Scmda
                                          and xw2.xwfpapel     = v_Scpap
                                          and xw2.xwfcuenta    = v_Sccta
                                          and xw2.xwfoperacion = v_Scoper
                                          and xw2.xwftipope    = v_Sctope
                                          and xw2.xwfcar3      = '1';
                                    end;
                           End;         
                           End IF;                           
           End ;
       End IF;
       if nvl(ln_instancia,0) = 0 then 
          Begin
            select max(xw2.xwfprcins)
              into ln_instancia
              from  operador.XWF700_findemes xw2
             where xw2.xwfempresa   = 1
               and xw2.xwfsucursal  = v_Scsuc
               and xw2.xwfmoneda    = v_Scmda
               and xw2.xwfpapel     = v_Scpap
               and xw2.xwfcuenta    = v_Sccta
               and xw2.xwfoperacion = v_Scoper;
           end;
       end if;
     end if;    
        If ln_instancia is not null then
           Begin
                 select sng001ase
                   into lc_analista
                   from operador.SNG001_findemes  --Cambiar la tabla para producción
                  where sng001inst =  ln_instancia;
           Exception when no_data_found then
                      lc_analista := null;
           end;
       End If; 
       
       
       
  return lc_analista;
  end;
  
  function fn_promotor_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return varchar2 is

    lc_promotor varchar2(50);
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;
    begin
      ln_instancia := fn_instancia_credito(v_Scmod ,
                                           v_Scsuc ,
                                           v_Scmda ,
                                           v_Scpap ,
                                           v_Sccta ,
                                           v_Scoper,
                                           v_Scsbop,
                                           v_Sctope);
      begin
        select sng001usc
          into lc_promotor
         from  operador.SNG001_findemes
        where  sng001inst =  ln_instancia
           and sng015cod  =  1;
        exception
          when no_data_found then
               lc_promotor := null;
      end;
      return lc_promotor;
    end;
    function fn_tipo_cliente_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return varchar2 is

    ln_tipocli number;
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;
    begin
      ln_instancia := fn_instancia_credito(v_Scmod ,
                                           v_Scsuc ,
                                           v_Scmda ,
                                           v_Scpap ,
                                           v_Sccta ,
                                           v_Scoper,
                                           v_Scsbop,
                                           v_Sctope);
      begin
        select SNG001TPCR 
          into ln_tipocli
         from  operador.SNG001_findemes
        where  sng001inst =  ln_instancia
           and sng015cod  =  1;
        exception
          when no_data_found then
               ln_tipocli := null;
      end;
      return ln_tipocli;
    end;
end pq_cr_jaql114_fm;
/

