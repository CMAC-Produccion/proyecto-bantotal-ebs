create or replace package PQ_CR_PROCESO_CSL is

  -- Author  : SMARQUEZ
  -- Created : 19/12/2017 9:33:58
  -- Purpose : TRANSFERENCIAS RUBROS CSL SEG 123-159 DIARIA
  
--------------------------------------------------------------------
  -- Public procedures
  procedure SP_PROCESO_CSL (p_fecha in date);
  procedure SP_JOB_PROCESO (p_fecpro in date);

  -- Public function and procedure declarations
  --  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

end PQ_CR_PROCESO_CSL;
/

create or replace package body PQ_CR_PROCESO_CSL is
 procedure SP_PROCESO_CSL (p_fecha in date) is
  CURSOR DATOS (p_d_fecpro in date) IS
 /* select w.*, f.sgcod seguro
    from fpp001 f, fsd011 w
   where sgcod in (123,159)--, 159)
     and f.pgcod = w.pgcod
     and f.aomod = w.aomod
     and f.aosuc = w.scsuc
     and f.aomda = w.scmda
     and f.aopap = w.scpap
     and f.aocta = w.sccta
     and f.aooper = w.scoper
     and f.aosbop = w.scsbop
     and f.aotope = w.SCTOPE
     and w.scstat <> 99;*/

    select w.*, f.sgcod seguro
      from fpp001 f, fsd010 w
     where sgcod in (123, 159)
       and f.pgcod = w.pgcod
       and f.aomod = w.aomod
       and f.aosuc = w.aosuc
       and f.aomda = w.aomda
       and f.aopap = w.aopap
       and f.aocta = w.aocta
       and f.aooper = w.aooper
       and f.aosbop = w.aosbop
       and f.aotope = w.aotope
       and ((w.aostat <> 99) or (w.aostat = 99  and aofval > = p_d_fecpro ));


 /*  cursor rubros is
   select * from Fst198
    Where Tp1cod   = 1
      AND Tp1cod1  = 10896
      AND Tp1corr1 = 50; */


   v_tope  number;
   v_saldo number;
   v_fecha date;
   v_rubro number;

begin
  if p_fecha is not null then
    v_fecha := p_fecha;
  else
    select pgfape into v_fecha from fst017 where pgcod= 1;
  end if;

  delete jaqz558;
  commit;

  for r in datos (v_fecha) loop
    if r.seguro = 123 then
      begin
        select a.sctope, a.scsdo, a.scrub
          into v_tope, v_saldo,v_rubro
          from fsd011 a,
               fpp001 b
         where a.pgcod = r.pgcod
           and a.scsuc = r.aosuc
           and a.scrub = 2514020000008
           and a.scmda = r.aomda
           and a.scpap = r.aopap
           and a.sccta = r.aocta
           and a.scoper = r.aooper
           and a.scsbop = 0
           and a.sctope = 0
           and a.scmod  = 260
           and a.scsdo > 0
           and b.pgcod = a.PGCOD
           and b.aomod = r.aomod
           and b.aosuc = a.SCSUC
           and b.aomda = a.SCMDA
           and b.aopap = a.SCPAP
           and b.aocta = a.sccta
           and b.aooper = a.scoper
           and b.aosbop = a.SCSBOP
           and b.aotope = r.aotope
           and b.sgcod  = r.seguro;
           begin
             insert into JAQZ558 (jaqz558emp,
                                  jaqz558mod,
                                  jaqz558suc,
                                  jaqz558mda,
                                  jaqz558pap,
                                  jaqz558cta,
                                  jaqz558ope,
                                  jaqz558sbo,
                                  jaqz558top,
                                  JAQZ558SEG,
                                  jaqz558rub,
                                  jaqz558sdo,
                                  jaqz558fep)
                           values(1,
                                  r.aomod,
                                  r.aosuc,
                                  r.aomda,
                                  r.aopap,
                                  r.aocta,
                                  r.aooper,
                                  r.aosbop,
                                  v_tope,
                                  r.seguro,
                                  v_rubro,
                                  v_saldo,
                                  v_fecha);
              insert into JAQZ558H (jaqz558empH,
                                    jaqz558modH,
                                    jaqz558sucH,
                                    jaqz558mdaH,
                                    jaqz558papH,
                                    jaqz558ctaH,
                                    jaqz558opeH,
                                    jaqz558sboH,
                                    jaqz558topH,
                                    JAQZ558SEGH,
                                    jaqz558rubH,
                                    jaqz558sdoH,
                                    jaqz558fepH)
                             values(1,
                                    r.aomod,
                                    r.aosuc,
                                    r.aomda,
                                    r.aopap,
                                    r.aocta,
                                    r.aooper,
                                    r.aosbop,
                                    v_tope,
                                    r.seguro,
                                    v_rubro,
                                    v_saldo,
                                    v_fecha);
           exception
             when dup_val_on_index then
              update JAQZ558
                 set jaqz558sdo = v_saldo,
                     jaqz558fep = v_fecha
               where jaqz558emp = 1
                 and jaqz558mod = r.aomod
                 and jaqz558suc = r.aosuc
                 and jaqz558mda = r.aomda
                 and jaqz558pap = r.aopap
                 and jaqz558cta = r.aocta
                 and jaqz558ope = r.aooper
                 and jaqz558sbo = r.aosbop
                 and jaqz558top = v_tope
                 and JAQZ558SEG = r.seguro
                 and jaqz558rub = v_rubro;

              update JAQZ558h
                 set jaqz558sdoh = v_saldo,
                     jaqz558feph = v_fecha
               where jaqz558emph = 1
                 and jaqz558modh = r.aomod
                 and jaqz558such = r.aosuc
                 and jaqz558mdah = r.aomda
                 and jaqz558paph = r.aopap
                 and jaqz558ctah = r.aocta
                 and jaqz558opeh = r.aooper
                 and jaqz558sboh = r.aosbop
                 and jaqz558toph = v_tope
                 and JAQZ558SEGh = r.seguro
                 and jaqz558rubh = v_rubro;
           end;
           commit;
      exception
        when no_data_found then
          begin
            select a.sctope, a.scsdo, a.scrub
              into v_tope, v_saldo,v_rubro
              from fsd011 a,
                   fpp001 b
             where a.pgcod = r.pgcod
               and a.scsuc = r.aosuc
               and a.scrub = 2524020000008
               and a.scmda = r.aomda
               and a.scpap = r.aopap
               and a.sccta = r.aocta
               and a.scoper = r.aooper
               and a.scsbop = 0
               and a.sctope = 0
               and a.scmod  = 260
               and a.scsdo > 0
               and b.pgcod = a.PGCOD
               and b.aomod = r.aomod
               and b.aosuc = a.SCSUC
               and b.aomda = a.SCMDA
               and b.aopap = a.SCPAP
               and b.aocta = a.sccta
               and b.aooper = a.scoper
               and b.aosbop = a.SCSBOP
               and b.aotope = r.aotope
               and b.sgcod  = r.seguro;
               begin
                 insert into JAQZ558 (jaqz558emp,
                                      jaqz558mod,
                                      jaqz558suc,
                                      jaqz558mda,
                                      jaqz558pap,
                                      jaqz558cta,
                                      jaqz558ope,
                                      jaqz558sbo,
                                      jaqz558top,
                                      JAQZ558SEG,
                                      jaqz558rub,
                                      jaqz558sdo,
                                      jaqz558fep)
                               values(1,
                                      r.aomod,
                                      r.aosuc,
                                      r.aomda,
                                      r.aopap,
                                      r.aocta,
                                      r.aooper,
                                      r.aosbop,
                                      v_tope,
                                      r.seguro,
                                      v_rubro,
                                      v_saldo,
                                      v_fecha);
              insert into JAQZ558H (jaqz558empH,
                                    jaqz558modH,
                                    jaqz558sucH,
                                    jaqz558mdaH,
                                    jaqz558papH,
                                    jaqz558ctaH,
                                    jaqz558opeH,
                                    jaqz558sboH,
                                    jaqz558topH,
                                    JAQZ558SEGH,
                                    jaqz558rubH,
                                    jaqz558sdoH,
                                    jaqz558fepH)
                             values(1,
                                    r.aomod,
                                    r.aosuc,
                                    r.aomda,
                                    r.aopap,
                                    r.aocta,
                                    r.aooper,
                                    r.aosbop,
                                    v_tope,
                                    r.seguro,
                                    v_rubro,
                                    v_saldo,
                                    v_fecha);
               exception
                 when dup_val_on_index then
                    update JAQZ558
                       set jaqz558sdo = v_saldo,
                           jaqz558fep = v_fecha
                     where jaqz558emp = 1
                       and jaqz558mod = r.aomod
                       and jaqz558suc = r.aosuc
                       and jaqz558mda = r.aomda
                       and jaqz558pap = r.aopap
                       and jaqz558cta = r.aocta
                       and jaqz558ope = r.aooper
                       and jaqz558sbo = r.aosbop
                       and jaqz558top = v_tope
                       and JAQZ558SEG = r.seguro
                       and jaqz558rub = v_rubro;

                    update JAQZ558h
                       set jaqz558sdoh = v_saldo,
                           jaqz558feph = v_fecha
                     where jaqz558emph = 1
                       and jaqz558modh = r.aomod
                       and jaqz558such = r.aosuc
                       and jaqz558mdah = r.aomda
                       and jaqz558paph = r.aopap
                       and jaqz558ctah = r.aocta
                       and jaqz558opeh = r.aooper
                       and jaqz558sboh = r.aosbop
                       and jaqz558toph = v_tope
                       and JAQZ558SEGh = r.seguro
                       and jaqz558rubh = v_rubro;
                     end;
               commit;
          exception
            when no_data_found then
              null;
          end;
       end;
     else
      begin
        select a.sctope, a.scsdo, a.scrub
          into v_tope, v_saldo,v_rubro
          from fsd011 a,
               fpp001 b
         where a.pgcod = r.pgcod
           and a.scsuc = r.aosuc
           and a.scrub = 2514020000007
           and a.scmda = r.aomda
           and a.scpap = r.aopap
           and a.sccta = r.aocta
           and a.scoper = r.aooper
           and a.scsbop = 0
           and a.sctope = 0
           and a.scmod  = 260
           and a.scsdo > 0
           and b.pgcod = a.PGCOD
           and b.aomod = r.aomod
           and b.aosuc = a.SCSUC
           and b.aomda = a.SCMDA
           and b.aopap = a.SCPAP
           and b.aocta = a.sccta
           and b.aooper = a.scoper
           and b.aosbop = a.SCSBOP
           and b.aotope = r.aotope
           and b.sgcod  = r.seguro ;
           begin
               insert into JAQZ558 (jaqz558emp,
                                    jaqz558mod,
                                    jaqz558suc,
                                    jaqz558mda,
                                    jaqz558pap,
                                    jaqz558cta,
                                    jaqz558ope,
                                    jaqz558sbo,
                                    jaqz558top,
                                    JAQZ558SEG,
                                    jaqz558rub,
                                    jaqz558sdo,
                                    jaqz558fep)
                             values(1,
                                    r.aomod,
                                    r.aosuc,
                                    r.aomda,
                                    r.aopap,
                                    r.aocta,
                                    r.aooper,
                                    r.aosbop,
                                    v_tope,
                                    r.seguro,
                                    v_rubro,
                                    v_saldo,
                                    v_fecha);
              insert into JAQZ558H (jaqz558empH,
                                    jaqz558modH,
                                    jaqz558sucH,
                                    jaqz558mdaH,
                                    jaqz558papH,
                                    jaqz558ctaH,
                                    jaqz558opeH,
                                    jaqz558sboH,
                                    jaqz558topH,
                                    JAQZ558SEGH,
                                    jaqz558rubH,
                                    jaqz558sdoH,
                                    jaqz558fepH)
                             values(1,
                                    r.aomod,
                                    r.aosuc,
                                    r.aomda,
                                    r.aopap,
                                    r.aocta,
                                    r.aooper,
                                    r.aosbop,
                                    v_tope,
                                    r.seguro,
                                    v_rubro,
                                    v_saldo,
                                    v_fecha);
           exception
             when dup_val_on_index then
              update JAQZ558
                 set jaqz558sdo = v_saldo,
                     jaqz558fep = v_fecha
               where jaqz558emp = 1
                 and jaqz558mod = r.aomod
                 and jaqz558suc = r.aosuc
                 and jaqz558mda = r.aomda
                 and jaqz558pap = r.aopap
                 and jaqz558cta = r.aocta
                 and jaqz558ope = r.aooper
                 and jaqz558sbo = r.aosbop
                 and jaqz558top = v_tope
                 and JAQZ558SEG = r.seguro
                 and jaqz558rub = v_rubro;

              update JAQZ558h
                 set jaqz558sdoh = v_saldo,
                     jaqz558feph = v_fecha
               where jaqz558emph = 1
                 and jaqz558modh = r.aomod
                 and jaqz558such = r.aosuc
                 and jaqz558mdah = r.aomda
                 and jaqz558paph = r.aopap
                 and jaqz558ctah = r.aocta
                 and jaqz558opeh = r.aooper
                 and jaqz558sboh = r.aosbop
                 and jaqz558toph = v_tope
                 and JAQZ558SEGh = r.seguro
                 and jaqz558rubh = v_rubro;
           end;
           commit;
      exception
        when no_data_found then
          null;
      end;
    end if;
  end loop;
end SP_PROCESO_CSL;

procedure SP_JOB_PROCESO (p_fecpro in date)is

     lc_variable varchar2(4000);
     ln_job      number:= 0;     
     ln_cont     number(2):=0;
     ln_inst     number(1):=1;
     lc_hostname varchar2(64);
     ld_fecpro   date;
     
  BEGIN

     
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
      execute immediate ('truncate table JAQz558');

         lc_variable := ' begin '|| ' PQ_CR_PROCESO_CSL.SP_PROCESO_CSL('''||p_fecpro||''');'|| ' End; ';

             ln_job := ln_job + 1;

--              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
--              if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                IF SYS.FN_BD_ISRAC='TRUE' THEN
                  DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                     -- instance => 2,--ln_inst, --23032024
                      instance => 1,
                      --instance => 1,--Solo por hoy 01.07.2015 hmev
                      force => false
                      );
              else
                    DBMS_JOB.SUBMIT(job => ln_job,
                                    what => lc_variable,
                                    next_date => sysdate+1/(24*60),
                                    interval => null,
                                    no_parse => false,
                                    force => false
                                    );
              end if;
        commit;

  --   end loop;

end SP_JOB_PROCESO;



end PQ_CR_PROCESO_CSL;
/

