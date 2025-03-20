create or replace package PQ_CR_TRAMADES is

  -- Author  : smarquez
  -- Created : 03/10/2017
  -- Purpose : para registrar en la trama datos no considerados

  Procedure Sp_carga(pd_fecpro in date,pd_finicio in date,pd_ffin in date);
  procedure sp_cr_cargaII_job1(pd_fecpro IN date);
  Procedure Sp_carga_II(P_C_DIGITO in varchar2,pd_fecpro in date);
  Procedure Sp_dataFSH012(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                        pn_top in number,pd_fecpro in date,pn_sca out number,pn_gpo out number);
  Function Fn_montoAprobado(pn_ins in number) return number;
  procedure sp_cr_cargaII_job(pd_fecini in date,pd_fecfin in date);
  Procedure Sp_Carga_Desem(P_C_DIGITO in varchar2,pd_fecini in date,pd_fecfin in date) ;
  Procedure Sp_dataFSH012_pag(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                        pn_top in number,pd_fecpro in date,pd_pago in date,pn_sca out number,
                        pn_gpo out number)   ;
  FUNCTION fn_MONTO_PRIMA_CUO(pa_pgcod number, pa_ppmod number, pa_ppsuc number, pa_ppmda number,
                           pa_pppap number, pa_ppcta number, pa_ppoper number, pa_ppsbop number,
                           pa_pptope number) return number ;
  function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number;
  Procedure Sp_monto_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pn_tip in number,pd_fecpro in date,ln_mtoprima out number,
                             lc_tip out varchar2) ;
  Function Fn_scap_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_fecpro in date) return number;
  Function Fn_tipoSBS(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return number ;

  procedure sp_tipoSBS(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number, ln_grup out number);

  Function fn_prima_calculada(pn_mda in number,pn_mto in number,pn_tas in number,
                            pn_emp in number,pn_mod in number,pn_suc in number,
                            pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                            pn_top in number) return number;
  Function Fn_montoDes(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                      pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                      pn_top in number,pd_fecpro in date) return number;
  Procedure Sp_Cuota_Vencer(pn_emp in number,pn_mod in number,pn_suc in number,
                          pn_mda in number,pn_pap in number,pn_cta in number,
                          pn_ope in number,pn_sbo in number,pn_top in number,
                          pd_fecpro in date,pd_fec out date);
  Function Fn_tipoSBS_2(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return char;
  procedure sp_tipoSBS_2(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number, lc_tip out char);
  Procedure Sp_TipPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                     pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                     pn_top in number,pd_fec in date);
  Function Fn_tipoSBS_Des(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return number;

  Function Fn_montoPag_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2;

  Procedure Sp_Primera_Cuota(pn_emp in number,pn_mod in number,pn_suc in number,
                          pn_mda in number,pn_pap in number,pn_cta in number,
                          pn_ope in number,pn_sbo in number,pn_top in number,
                          pd_fecpro in date,pd_fec out date);
end PQ_CR_TRAMADES;
/

create or replace package body PQ_CR_TRAMADES is

Procedure Sp_carga(pd_fecpro in date,pd_finicio in date,pd_ffin in date)is

cursor creditos is
   select distinct a.jaqy785cod,a.jaqy785mod,a.jaqy785suc,a.jaqy785mda,a.jaqy785pap,
                  a.jaqy785cta,a.jaqy785oper,a.jaqy785sbop,a.jaqy785tope
     from jaqy785 a,fsd010 b,fpp001 c
    where a.jaqy785cod  = b.PGCOD
      and a.jaqy785mod  = b.AOMOD
      and a.jaqy785suc  = b.AOSUC
      and a.jaqy785mda  = b.AOMDA
      and a.jaqy785pap  = b.AOPAP
      and a.jaqy785cta  = b.AOCTA
      and a.jaqy785oper = b.AOOPER
      and a.jaqy785sbop = b.AOSBOP
      and a.jaqy785tope = b.AOTOPE
      and a.jaqy785est611='S'
      and b.AOSTAt <>99
      and b.PGCOD  = c.PGCOD
      and b.AOMOD  = c.AOMOD
      and b.AOSUC  = c.AOSUC
      and b.AOMDA  = c.AOMDA
      and b.AOPAP  = c.AOPAP
      and b.AOCTA  = c.AOCTA
      and b.AOOPER = c.AOOPER
      and b.AOSBOP = c.AOSBOP
      and b.AOTOPE = c.AOTOPE
      and c.sgcod in (select tp1imp1
                        from fst198
                       where tp1cod=1
                         and tp1cod1= 10898
                         and tp1corr1=8);
ld_fecini date;
contador number;
contadorjaql986 number;
contadornoexistente number :=0;
pfpago date;
imp15 number(17,2):=0;
imp14 number(17,2):=0;
imp13 number(17,2):=0;
imp12 number(17,2):=0;
imp11 number(17,2):=0;
monto number(17,2):=0;
digito varchar2(2):= 0;

begin

     Execute immediate('truncate table JAQZ553');
    -- ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
     Execute immediate('truncate table JAQZ554');
     Execute immediate('truncate table jaqz097_error');
    for i in creditos loop
        contador := 0;
        contadorjaql986:=0;
        select count(*),Max(a.ppfpag)
          into contador, pfpago
          from fsd611 a
         where A.PGCOD = i.jaqy785cod
           and a.ppmod = i.jaqy785mod
           and a.ppsuc = i.jaqy785suc
           and a.ppmda = i.jaqy785mda
           and a.pppap = i.jaqy785pap
           and a.ppcta = i.jaqy785cta
           and a.ppoper = i.jaqy785oper
           and a.ppsbop = i.jaqy785sbop
           and a.pptope = i.jaqy785tope
           and a.ppfpag >= pd_finicio --'01/04/2017'
           and a.ppfpag < pd_ffin; ---'01/05/2017';

        if  contador<>0 then
            contadorjaql986:=0;
            imp15 :=0;
            imp14 :=0;
            imp13 :=0;
            imp12 :=0;
            imp11 :=0;
            monto :=0;

              select count(*)
                into contadorjaql986
                from jaql986 j
               where j.jaql986emp = i.jaqy785cod
                 and j.jaql986mod = i.jaqy785mod
                 and j.jaql986suc = i.jaqy785suc
                 and j.jaql986mda = i.jaqy785mda
                 and j.jaql986pap = i.jaqy785pap
                 and j.jaql986cta = i.jaqy785cta
                 and j.jaql986ope = i.jaqy785oper
                 and j.jaql986sbo = i.jaqy785sbop
                 and j.jaql986top = i.jaqy785tope
                 and j.jaql986fpa >= pd_finicio --- '01/04/2017'
                 and j.jaql986fpa < pd_ffin;---'01/05/2017';
               if contadorjaql986 = 0 then
                  contadornoexistente := contadornoexistente + 1 ;
                  Select sum(pp1imp15),sum(pp1imp14),sum(pp1imp13),sum(pp1imp12),sum(pp1imp11)
                    into imp15,imp14,imp13,imp12,imp11
                    from fsd612
                   where PGCOD  = i.jaqy785cod
                     and ppmod  = i.jaqy785mod
                     and ppsuc  = i.jaqy785suc
                     and ppmda  = i.jaqy785mda
                     and pppap  = i.jaqy785pap
                     and ppcta  = i.jaqy785cta
                     and ppoper = i.jaqy785oper
                     and ppsbop = i.jaqy785sbop
                     and pptope = i.jaqy785tope
                     and ppfpag between pd_finicio and pfpago;--- '01/04/2017' and pfpago;
                  if imp15 <> 0 then
                     monto := imp15;
                  else
                    if imp14 <> 0 then
                      monto := imp14;
                    else
                      if imp13 <> 0 then
                        monto := imp13;
                      else
                        if imp12 <> 0 then
                          monto := imp12;
                        else
                          monto:= imp11;
                        end if;
                      end if;
                    end if;
                  end if;
             --    dbms_output.put_line(contadornoexistente||'  '||i.jaqy785cod||'  '||i.jaqy785mod||'  '||i.jaqy785suc||'  '||i.jaqy785mda||'  '||i.jaqy785pap||'  '||i.jaqy785cta||'  '||i.jaqy785oper||'  '||i.jaqy785sbop||'  '||i.jaqy785tope  );
                 insert into JAQZ553(jaqz553emp,jaqz553mod,jaqz553suc,jaqz553mda,jaqz553pap,jaqz553cta,jaqz553ope,jaqz553sbo,jaqz553top,jaqz553fec,jaqz553mpa)--,jaqz553fval)
                              values(i.jaqy785cod,i.jaqy785mod,i.jaqy785suc,i.jaqy785mda,i.jaqy785pap,i.jaqy785cta,i.jaqy785oper,i.jaqy785sbop,i.jaqy785tope,pd_fecpro,monto);
               end if;
          end if;
      end loop;
      commit;
      
      for i IN 1..10 LOOP
        digito := i - 1;
        pq_cr_tramades.Sp_carga_II(digito,pd_fecpro);
       -- i := i + 1;
      end loop;  

end Sp_carga;

procedure sp_cr_cargaII_job1(pd_fecpro IN date) is

     cursor c_clientes_job is
      select to_char(substr(trim(j.jaqz553cta), -1, 1)) digito
          from JAQZ553 j
         group by to_char(substr(trim(j.jaqz553cta), -1, 1));

     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;

     lc_hostname varchar2(64);
  BEGIN

     --execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
     --lc_fecpro := to_char(P_D_FECPRO,'RRRR.MM.DD');
     --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
     --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM'));

     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;


     for job in c_clientes_job loop
         lc_variable := ' begin '||
              ' PQ_cR_TRAMDESGRA.Sp_carga_II('''||job.digito||''','''||pd_fecpro||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;

              if(ln_cont>=50) then
                  ln_inst:=2;
              end if;

              ln_job := ln_job +1;

--              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
--              if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,--ln_inst,
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

     end loop;

end sp_cr_cargaII_job1;

Procedure Sp_carga_II(P_C_DIGITO in varchar2,pd_fecpro in date) is

cursor creditos is
select * from JAQZ553 a
where to_char(substr(trim(jaqZ553cta), -1, 1)) = P_C_DIGITO
--where a.jaqz085cta=1408771 and a.jaqz085ope=1990862
;

ln_numpol number(10);
ld_fecvini date;
ld_fecvfin date;
ln_tasa number(17,6);
ln_monto  number(17,6);
ln_salcap number(17,2);
ln_grupo number(2);
lc_plan char(30);
ln_instancia number(10);
ln_mtoapr number(17,2);
ln_pai number(3);
ln_tdo number(2);
lc_ndo char(12);
lc_petipo char(1);
lc_apepat char(30);
lc_apemat char(30);
lc_nombre char(50);
lc_razsoc char(70);
lc_sexo char(1);
ld_fecnac date;
ln_paij number(3);
ln_tdoj number(2);
lc_ndoj char(12);
ld_fecant date;
lc_numcre char(25);
ln_aoimp number(17,2);
ln_sucAct number(3);

ln_mtoCalen number(17,2);
ln_salcal number(17,2);
ld_Fec date;
lc_tip char(1);
ln_periodo number(5);
ln_estado number(2);

ln_gracia number(1);
ld_primcuo date;
begin
       begin

         --ld_fecant := last_day(add_months(pd_fecpro,-1));
         for i in creditos loop
             lc_tip :=null;
             ln_grupo := null;
             lc_plan := null;
             ln_gracia :=0;
             --instancia
            ln_instancia := fn_instancia_credito(i.JAQZ553MOD,i.JAQZ553SUC,i.JAQZ553MDA,i.JAQZ553PAP,
                                                 i.JAQZ553CTA,i.JAQZ553OPE,i.JAQZ553SBO,i.JAQZ553TOP);
            if nvl(ln_instancia,0) = 0 then
               begin
                     select a.aosuc
                       into ln_sucAct
                       from fsd010 a
                      where a.pgcod  = i.JAQZ553EMP
                        and a.aomod  = i.JAQZ553MOD
                        and a.aomda  = i.JAQZ553MDA
                        and a.aopap  = i.JAQZ553PAP
                        and a.aocta  = i.JAQZ553CTA
                        and a.aooper = i.JAQZ553OPE
                        and a.aosbop = i.JAQZ553SBO
                        and a.aotope = i.JAQZ553TOP;
               exception
                        when others then null;
               end;
               ln_instancia := fn_instancia_credito(i.JAQZ553MOD,ln_sucAct,i.JAQZ553MDA,i.JAQZ553PAP,
                                                 i.JAQZ553CTA,i.JAQZ553OPE,i.JAQZ553SBO,i.JAQZ553TOP);

               else
                        ln_sucAct:=i.JAQZ553SUC;
            end if;

             --fecha de desembolso,monto desembolsado,periodo
              begin
                select aofval,aoimp,aoperiod,aostat
                  into ld_fecant,ln_aoimp,ln_periodo,ln_estado
                  from fsd010 a
                 where a.pgcod  = i.JAQZ553EMP
                   and a.aomod  = i.JAQZ553MOD
                   and a.aosuc  = ln_sucAct--i.JAQZ085SUC
                   and a.aomda  = i.JAQZ553MDA
                   and a.aopap  = i.JAQZ553PAP
                   and a.aocta  = i.JAQZ553CTA
                   and a.aooper = i.JAQZ553OPE
                   and a.aosbop = i.JAQZ553SBO
                   and a.aotope = i.JAQZ553TOP;

               exception
                   when no_data_found then
                        begin
                            select aofval,aoimp,aoperiod,aostat
                              into ld_fecant,ln_aoimp,ln_periodo,ln_estado
                              from fsd010 a
                             where a.pgcod  = i.JAQZ553EMP
                               and a.aomod  = i.JAQZ553MOD
                               --and a.aosuc  = i.JAQZ085SUC
                               and a.aomda  = i.JAQZ553MDA
                               and a.aopap  = i.JAQZ553PAP
                               and a.aocta  = i.JAQZ553CTA
                               and a.aooper = i.JAQZ553OPE
                               and a.aosbop = i.JAQZ553SBO
                               and a.aotope = i.JAQZ553TOP;

                        exception
                              when no_data_found then
                                   ld_fecant := null;
                                   ln_aoimp := null;
                                   ln_periodo := null;
                                   ln_estado := null;
                        end;


               end;

            -- Numero de poliza
            if i.jaqz553mda = 0 then
               ln_numpol :=235901;
               else
                    ln_numpol :=235899;
            end if;
            --fecha de vigencia inicial
            ld_fecvini := to_date('01'||to_char(/*i.jaqz553fec*/pd_fecpro,'mmyyyy'),'dd/mm/yyyy');
            --fecha de vigencia final
            ld_fecvfin := pd_fecpro;--i.jaqz553fec;

            --monto de la prima
            ln_monto := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,
                                                                i.jaqz553MDA,i.jaqz553PAP,i.jaqz553CTA,
                                                                i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP);
             --grupo
            ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.JAQZ553EMP,i.jaqz553MOD,ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                           i.jaqz553CTA,i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP);
            --monto calendario de pago
            pq_cr_tramdesgra.Sp_monto_calendario(i.jaqz553EMP,i.jaqz553MOD,
                                                                ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                                                i.jaqz553CTA,i.jaqz553OPE,
                                                                i.jaqz553SBO,i.jaqz553TOP,2,pd_fecpro,ln_mtoCalen,
                                                                lc_tip);
            --saldo capital calendario de pagos
            ln_salcal :=pq_cr_tramades.Fn_scap_calendario(i.jaqz553EMP,i.jaqz553MOD,
                                                                ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                                                i.jaqz553CTA,i.jaqz553OPE,
                                                                i.jaqz553SBO,i.jaqz553TOP,pd_fecpro);

            --tipo SBS RCC si es nulo
            if ln_grupo is null then
               ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                           i.jaqz553CTA,i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP);
            end if;

            --plan
            case
             when ln_grupo in (2,12,13) then lc_plan := 'PYME';
             when ln_grupo = 3 then lc_plan := 'CONSUMO';
             when ln_grupo = 4 then lc_plan := 'HIPOTECARIO';
             else null;
            end case;

            --monto aprobado
            ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);
            --tasa
            ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,
                                                                    i.jaqz553MDA,i.jaqz553PAP,i.jaqz553CTA,
                                                                    i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP,
                                                                    ln_mtoapr);
            --numero de credito
            lc_numcre := to_char(LPAD(i.jaqz553CTA,9,'0')||LPAD(i.jaqz553OPE,9,'0')||LPAD(i.jaqz553SBO,3,'0'));

            --datos persona
            begin
                    select a.pepais,
                           a.petdoc,
                           a.pendoc
                      into ln_pai,
                           ln_tdo,
                           lc_ndo
                      from fsr008 a
                     where a.ctnro = i.jaqz553cta
                       and a.cttfir = 'T';
            exception
                  when no_data_found then
                       ln_pai := null;
                       ln_tdo := null;
                       lc_ndo := null;
            end;
            begin
                    select a.petipo
                      into lc_petipo
                      from fsd001 a
                     where a.pepais = ln_pai
                       and a.petdoc = ln_tdo
                       and a.pendoc = lc_ndo;
            exception
                  when no_data_found then
                       lc_petipo:=null;
            end;
            --apellido paterno  --apellido materno  --nombres --sexo
            begin
                select a.pfape1, a.pfape2, trim(a.pfnom1)||' '||trim(a.pfnom2),a.pfcant,a.pffnac
                  into lc_apepat,lc_apemat, lc_nombre, lc_sexo,ld_fecnac
                  from fsd002 a
                 where a.pfpais = ln_pai
                   and a.pftdoc = ln_tdo
                   and a.pfndoc = lc_ndo;
            exception
                   when no_data_found then
                   lc_apepat := null;
                   lc_apemat := null;
                   lc_nombre := null;
            end;

        /*    --apellido materno
            begin
                select a.pfape2
                  into lc_apemat
                  from fsd002 a
                 where a.pfpais = ln_pai
                   and a.pftdoc = ln_tdo
                   and a.pfndoc = lc_ndo;
            exception
                   when no_data_found then
                   lc_apemat := null;
            end;

            --nombres
            begin
                select trim(a.pfnom1)||' '||trim(a.pfnom2)
                  into lc_nombre
                  from fsd002 a
                 where a.pfpais = ln_pai
                   and a.pftdoc = ln_tdo
                   and a.pfndoc = lc_ndo;
            exception
                   when no_data_found then
                   lc_nombre := null;
            end;



          

            --sexo
            begin
                select a.pfcant
                  into lc_sexo
                  from fsd002 a
                 where a.pfpais = ln_pai
                   and a.pftdoc = ln_tdo
                   and a.pfndoc = lc_ndo;
            exception
                   when no_data_found then
                   lc_sexo := null; 
            end; */

   --razon social
            begin
                select trim(j.pjrazs)
                  into lc_razsoc
                  from fsd003 j
                 where j.pjpais = ln_pai
                   and j.pjtdoc = ln_tdo
                   and j.pjndoc = lc_ndo;
            exception
                   when no_data_found then
                   lc_razsoc := null;
            end;

            begin
               select a.pfpai1,
                      a.pftdo1,
                      a.pfndo1
                 into ln_paij,
                      ln_tdoj,
                      lc_ndoj
                 from fsr003 a
                where a.pjpais = ln_pai
                  and a.pjtdoc = ln_tdo
                  and a.pjndoc = lc_ndo;
           exception
                  when too_many_rows then
                       begin
                           select a.pfpai1,
                                  a.pftdo1,
                                  a.pfndo1
                             into ln_paij,
                                  ln_tdoj,
                                  lc_ndoj
                             from fsr003 a
                            where a.pjpais = ln_pai
                              and a.pjtdoc = ln_tdo
                              and a.pjndoc = lc_ndo
                              and a.vicod  <> 1
                              and rownum = 1;
                       exception
                              when no_data_found then null;

                       end;
                  when no_data_found then null;
           end;
            --fecha de nacimiento
            if lc_petipo <> 'F' then  ---= 'F' then
             /*   begin
                    select a.pffnac
                      into ld_fecnac
                      from fsd002 a
                     where a.pfpais = ln_pai
                       and a.pftdoc = ln_tdo
                       and a.pfndoc = lc_ndo;
                exception
                       when no_data_found then
                       ld_fecnac := null;
                end;
            else*/

                        begin
                            select a.pffnac , a.pfcant ,a.pfape1 ,a.pfape2 , trim(a.pfnom1)||' '||trim(a.pfnom2)                         
                              into ld_fecnac, lc_sexo ,lc_apepat, lc_apemat ,lc_nombre
                              from fsd002 a
                             where a.pfpais = ln_paij
                               and a.pftdoc = ln_tdoj
                               and a.pfndoc = lc_ndoj;
                        exception
                               when no_data_found then
                               ld_fecnac := null;
                        end;

                    /*    begin
                            select a.pfcant
                              into lc_sexo
                              from fsd002 a
                             where a.pfpais = ln_paij
                               and a.pftdoc = ln_tdoj
                               and a.pfndoc = lc_ndoj;
                        exception
                               when no_data_found then
                               lc_sexo := null;
                        end;

                        --apellido paterno
                        begin
                            select a.pfape1
                              into lc_apepat
                              from fsd002 a
                             where a.pfpais = ln_paij
                               and a.pftdoc = ln_tdoj
                               and a.pfndoc = lc_ndoj;
                        exception
                               when no_data_found then
                               lc_apepat := null;
                        end;

                        --apellido materno
                        begin
                            select a.pfape2
                              into lc_apemat
                              from fsd002 a
                             where a.pfpais = ln_paij
                               and a.pftdoc = ln_tdoj
                               and a.pfndoc = lc_ndoj;
                        exception
                               when no_data_found then
                               lc_apemat := null;
                        end;

                        --nombres
                        begin
                            select trim(a.pfnom1)||' '||trim(a.pfnom2)
                              into lc_nombre
                              from fsd002 a
                             where a.pfpais = ln_paij
                               and a.pftdoc = ln_tdoj
                               and a.pfndoc = lc_ndoj;
                        exception
                               when no_data_found then
                               lc_nombre := null;
                        end;
                      */

                            ln_pai := ln_paij;
                            ln_tdo := ln_tdoj;
                            lc_ndo := lc_ndoj;
                        

            end if;





             --fecha de la cuota por vencer
                ld_Fec := null;
                 pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                           i.jaqz553CTA,i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP,
                                                           pd_fecpro,ld_Fec);
             --dias de gracia

             ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                           i.jaqz553CTA,i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP);
             --fecha de la primera cuota
             ld_primcuo := null;
             pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz553EMP,i.jaqz553MOD,ln_sucAct,i.jaqz553MDA,i.jaqz553PAP,
                                           i.jaqz553CTA,i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP,
                                                           pd_fecpro,ld_primcuo);
            insert into JAQZ554(JAQZ554EMP,JAQZ554MOD,JAQZ554SUC,JAQZ554MDA,JAQZ554PAP,JAQZ554CTA,
                                JAQZ554OPE,JAQZ554SBO,JAQZ554TOP,JAQZ554FEC,JAQZ554MPA,JAQZ554MAP,
                                JAQZ554FEI,JAQZ554FEF,JAQZ554NUM,JAQZ554TAS,JAQZ554MPR,/*JAQZ554SCA,*/
                                JAQZ554GRU,JAQZ554PLA,JAQZ554PAI,JAQZ554TDO,JAQZ554NDO,JAQZ554TPE,
                                JAQZ554SEX,JAQZ554FNA,JAQZ554APT,JAQZ554APM,JAQZ554NOM,JAQZ554RZO,
                                JAQZ554NUC,JAQZ554IMP,JAQZ554SUA,JAQZ554MCA,JAQZ554SCL,JAQZ554FVE,
                                JAQZ554TIP,JAQZ554PER,JAQZ554EST,JAQZ554FDE,JAQZ554DGA,JAQZ554FPR)

            Values(i.jaqz553EMP,i.jaqz553MOD,i.jaqz553SUC,i.jaqz553MDA,i.jaqz553PAP,i.jaqz553CTA,
                   i.jaqz553OPE,i.jaqz553SBO,i.jaqz553TOP,i.jaqz553FEC,i.jaqz553MPA,ln_mtoapr,
                   ld_fecvini,ld_fecvfin,ln_numpol,ln_tasa,ln_monto,/*ln_salcap,*/ln_grupo,lc_plan,
                   ln_pai,ln_tdo,lc_ndo,lc_petipo,lc_sexo,ld_fecnac,lc_apepat,lc_apemat,lc_nombre,
                   lc_razsoc,lc_numcre,ln_aoimp,ln_sucAct,ln_mtoCalen,ln_salcal,ld_Fec,lc_tip,
                   ln_periodo,ln_estado,ld_fecant,ln_gracia,ld_primcuo);

            commit;





         end loop;

       end;
end Sp_carga_II;

Procedure Sp_dataFSH012(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                        pn_top in number,pd_fecpro in date,pn_sca out number,pn_gpo out number)is
ld_fec date;
ln_mtoDes number(17,2);

begin

     begin
              select b.bcsdmo,b.bcgpo
                into pn_sca,pn_gpo
                from fsh012 b
               where b.bcemp = pn_emp
                 and b.bcsuc = pn_suc
                 and b.bcrubr in (select rubro
                                    from fsd014
                                   where (pcnivc in
                                         (select modulo
                                            from fst111
                                           where dscod = 50
                                             and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                              /*or pcnivc in (141, 117)*/)
                                     and pcimpu = 'S'
                                     and pmtit <> 9)
                 and b.bcmda = pn_mda
                 and b.bcpap = pn_pap
                 and b.bccta = pn_cta
                 and b.bcoper = pn_ope
                 and b.bcsbop = pn_sbo
                 and b.bctop = pn_top
                 and b.bcfech = pd_fecpro
                 and b.bcmod = pn_mod
                 and b.bcsdmn <> 0
                 and rownum = 1;

     exception
          when others then
               pn_sca := null;
               pn_gpo := null;
     end;
     if pn_sca is null then
        begin
           select a.aofe99,aoimp
             into ld_fec,ln_mtoDes
             from fsd010 a
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top;
        exception
              when no_data_found then
                   ld_fec := null;
                   ln_mtoDes := null;
        end;

        if ld_fec is not null then
           begin
                    select b.bcsdmo,b.bcgpo
                      into pn_sca,pn_gpo
                      from fsh012 b
                     where b.bcemp = pn_emp
                       and b.bcsuc = pn_suc
                       and b.bcrubr in (select rubro
                                          from fsd014
                                         where (pcnivc in
                                               (select modulo
                                                  from fst111
                                                 where dscod = 50
                                                   and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                    /*or pcnivc in (141, 117)*/)
                                           and pcimpu = 'S'
                                           and pmtit <> 9)
                       and b.bcmda = pn_mda
                       and b.bcpap = pn_pap
                       and b.bccta = pn_cta
                       and b.bcoper = pn_ope
                       and b.bcsbop = pn_sbo
                       and b.bctop = pn_top
                       and b.bcfech = (ld_fec - 1)
                       and b.bcmod = pn_mod
                       and rownum = 1;

           exception
                when others then
                     pn_sca := null;
                     pn_gpo := null;
           end;
        end if;

        if pn_sca is null or pn_sca = 0 then
           pn_sca := ln_mtoDes;
        end if;
     end if;
end Sp_dataFSH012;

Function Fn_montoAprobado(pn_ins in number) return number is

ln_mto number(17,2);
begin
     begin
         begin
                  select case
                            when (C.SNG001ORI = 7 AND A.XWFMODULO = 184) THEN A.XWFMONTO1
                            when (C.SNG001ORI = 7 AND A.XWFMODULO <> 184) THEN A.XWFMONTO1
                            when C.SNG001ORI <> 7 THEN ( SELECT Y.XLLOAOIMP
                                                           FROM XWF700 W , X054007 Y
                                                          WHERE W.XWFPRCINS = a.XWFPRCINS
                                                            AND ROWNUM = 1
                                                            AND W.XWFEMPRESA = Y.PGCOD
                                                            AND W.XWFMODULO = Y.XLLOAOMOD
                                                            AND W.XWFSUCURSAL = Y.XLLOAOSUC
                                                            AND W.XWFMONEDA = Y.XLLOAOMDA
                                                            AND W.XWFPAPEL = Y.XLLOAOPAP
                                                            AND W.XWFCUENTA = Y.XLLOAOCTA
                                                            AND W.XWFOPERACION = Y.XLLOAOOPER
                                                            AND W.XWFSUBOPE = Y.XLLOAOSBOP
                                                            AND W.XWFTIPOPE = Y.XLLOAOTOPE
                                                            AND W.XWFCAR3 = '1' )
                          end
                     into ln_mto
                     from XWF700 a,sng001 c
                    where a.xwfprcins = c.sng001inst
                      and a.xwfprcins = pn_ins
                      and rownum=1;
         exception
                when others then
                     ln_mto := null;

         end;
         return ln_mto;
     end;

end Fn_montoAprobado;

procedure sp_cr_cargaII_job(pd_fecini in date,pd_fecfin in date) is

     cursor c_clientes_job is
      select to_char(substr(trim(j.jaqz097cta), -1, 1)) digito
          from jaqz097_aux j
         group by to_char(substr(trim(j.jaqz097cta), -1, 1));

     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
     lc_hostname varchar2(64);
  BEGIN
     --Obtener hostname
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;

     execute immediate('truncate table jaqz097_aux');
       execute immediate('truncate table jaqz097');
       begin
          insert into jaqz097_aux(JAQZ097EMP,JAQZ097MOD,JAQZ097SUC,JAQZ097MDA,JAQZ097PAP,
                                  JAQZ097CTA,JAQZ097OPE,JAQZ097SBO,JAQZ097TOP,JAQZ097FVA,
                                  JAQZ097EST,JAQZ097F99,jaqz097imp,jaqz097per)

          select a.pgcod,
                 a.aomod,
                 a.aosuc,
                 a.aomda,
                 a.aopap,
                 a.aocta,
                 a.aooper,
                 a.aosbop,
                 a.aotope,
                 a.aofval,
                 a.aostat,
                 a.aofe99,
                 a.aoimp,
                 a.aoperiod
            from fsd010 a,FPP001 b
           where a.aofval between pd_fecini and pd_fecfin
             and a.aomod in (select modulo from fst111 where dscod = 50)
             and a.pgcod  = b.pgcod
             and a.aomod  = b.aomod
             and a.aosuc  = b.aosuc
             and a.aomda  = b.aomda
             and a.aopap  = b.aopap
             and a.aocta  = b.aocta
             and a.aooper = b.aooper
             and a.aosbop = b.aosbop
             and a.aotope = b.aotope
             and b.SGCOD in (select tp1imp1
                               from fst198
                              where tp1cod=1
                                and tp1cod1= 10898
                                and tp1corr1=8);

            commit;

       end;


     for job in c_clientes_job loop
         lc_variable := ' begin '||
              ' PQ_cR_TRAMDESGRA.Sp_Carga_Desem('''||job.digito||''','''||pd_fecini||''','''||pd_fecfin||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;

              if(ln_cont>=50) then
                  ln_inst:=2;
              end if;

              ln_job := ln_job +1;

--              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));

--              if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then
--              if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => 2,--ln_inst,
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

     end loop;

end sp_cr_cargaII_job;


Procedure Sp_Carga_Desem(P_C_DIGITO in varchar2,pd_fecini in date,pd_fecfin in date) is

cursor creditos is
select * from jaqz097_aux
where to_char(substr(trim(jaqZ097cta), -1, 1)) = P_C_DIGITO;

ln_numpol number(10);
ld_fecvini date;
ld_fecvfin date;
ln_tasa number(17,6);
ln_monto  number(17,6);
ln_monto_tot  number(17,6);
ln_salcap number(17,2);
ln_grupo number(2);
lc_plan char(30);
ln_instancia number(10);
ln_mtoapr number(17,2);
ln_pai number(3);
ln_tdo number(2);
lc_ndo char(12);
lc_petipo char(1);
lc_apepat char(30);
lc_apemat char(30);
lc_nombre char(50);
lc_razsoc char(70);
lc_sexo char(1);
ld_fecnac date;
ln_paij number(3);
ln_tdoj number(2);
lc_ndoj char(12);
lc_numcre number(25);
ln_gracia number(1);

ln_mtoCalen NUMBER(17,2);

ln_paj number(3);
ln_tdj number(2);
lc_doj char(12);
ln_noj char(140);
lc_sej char(1);

ld_fecven date;
ln_mtoFin number(17,2);
ld_Fec date;
lc_tip char(1);
ld_Fecpri date;
begin


       begin

            for i in creditos loop
                lc_tip := null;
                ln_grupo := null;
                lc_plan := null;
                ln_gracia:= 0;
                -- Numero de poliza
                if i.jaqz097mda = 0 then
                   ln_numpol :=235901;
                   else
                        ln_numpol :=235899;
                end if;
                --fecha de vigencia inicial
                ld_fecvini := to_date('01'||to_char(i.jaqz097fva,'mmyyyy'),'dd/mm/yyyy');
                --fecha de vigencia final
                ld_fecvfin := pd_fecfin;

                --monto de la prima
                ln_monto := pq_cr_tramdesgra.fn_monto_prima_cuo(i.jaqz097emp,i.jaqz097mod,i.jaqz097suc,i.jaqz097mda,i.jaqz097pap,
                                           i.jaqz097cta,i.jaqz097ope,i.jaqz097sbo,i.jaqz097top);

                --monto de la prima total
            ln_monto_tot := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.jaqz097emp,i.jaqz097mod,i.jaqz097suc,i.jaqz097mda,i.jaqz097pap,
                                           i.jaqz097cta,i.jaqz097ope,i.jaqz097sbo,i.jaqz097top);


                --saldo capital y grupo
                /*begin
                     select a.scsdo,a.scgru
                       into ln_salcap,ln_grupo
                       from fsd011 a
                      where a.pgcod  = i.jaqz097emp
                        and a.scsuc  = i.jaqz097suc
                        and a.scmod  = i.jaqz097mod
                        and a.scmda  = i.jaqz097mda
                        and a.scpap  = i.jaqz097pap
                        and a.sccta  = i.jaqz097cta
                        and a.scoper = i.jaqz097ope
                        and a.scsbop = i.jaqz097sbo
                        and a.sctope = i.jaqz097top;
                exception
                        when no_data_found then
                             ln_salcap:=0;
                             ln_grupo:=null;
                end;*/
                --pq_cr_tramdesgra.sp_dataFSH012(i.jaqz097emp,i.jaqz097mod,i.jaqz097suc,i.jaqz097mda,i.jaqz097pap,
                --                           i.jaqz097cta,i.jaqz097ope,i.jaqz097sbo,i.jaqz097top,pd_fecfin,
                --                           ln_salcap,ln_grupo);

                --grupo
                ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.jaqz097emp,i.jaqz097mod,i.jaqz097suc,i.jaqz097mda,i.jaqz097pap,
                                           i.jaqz097cta,i.jaqz097ope,i.jaqz097sbo,i.jaqz097top);

                --tipo SBS RCC si es nulo

                if ln_grupo is null then
                   ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                       i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                       i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP);
                end if;

                --plan
                case
                 when ln_grupo in (2,12,13) then lc_plan := 'PYME';
                 when ln_grupo = 3 then lc_plan := 'CONSUMO';
                 when ln_grupo = 4 then lc_plan := 'HIPOTECARIO';
                 else null;
                end case;

                --instancia
                ln_instancia := fn_instancia_credito(i.jaqz097mod,i.jaqz097SUC,i.jaqz097MDA,i.jaqz097PAP,
                                                     i.jaqz097CTA,i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP);
                --monto aprobado
                ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);
                --tasa
                ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                                        i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                                        i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP,
                                                                        ln_mtoapr);

                --monto calendario de pago
            pq_cr_tramdesgra.Sp_monto_calendario(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                                        i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                                        i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP,
                                                                        1,pd_fecfin,ln_mtoCalen,
                                                                        lc_tip);


                --numero de credito
                lc_numcre := to_char(LPAD(i.JAQZ097CTA,9,'0')||LPAD(i.JAQZ097OPE,9,'0')||LPAD(i.JAQZ097SBO,3,'0'));


                --datos persona
                begin
                        select a.pepais,
                               a.petdoc,
                               a.pendoc
                          into ln_pai,
                               ln_tdo,
                               lc_ndo
                          from fsr008 a
                         where a.ctnro = i.jaqz097cta
                           and a.cttfir = 'T';
                exception
                      when no_data_found then
                           ln_pai := null;
                           ln_tdo := null;
                           lc_ndo := null;
                end;
                begin
                        select a.petipo
                          into lc_petipo
                          from fsd001 a
                         where a.pepais = ln_pai
                           and a.petdoc = ln_tdo
                           and a.pendoc = lc_ndo;
                exception
                      when no_data_found then
                           lc_petipo:=null;
                end;
                --apellido paterno
                begin
                    select a.pfape1
                      into lc_apepat
                      from fsd002 a
                     where a.pfpais = ln_pai
                       and a.pftdoc = ln_tdo
                       and a.pfndoc = lc_ndo;
                exception
                       when no_data_found then
                       lc_apepat := null;
                end;

                --apellido materno
                begin
                    select a.pfape2
                      into lc_apemat
                      from fsd002 a
                     where a.pfpais = ln_pai
                       and a.pftdoc = ln_tdo
                       and a.pfndoc = lc_ndo;
                exception
                       when no_data_found then
                       lc_apemat := null;
                end;

                --nombres
                begin
                    select trim(a.pfnom1)||' '||trim(a.pfnom2)
                      into lc_nombre
                      from fsd002 a
                     where a.pfpais = ln_pai
                       and a.pftdoc = ln_tdo
                       and a.pfndoc = lc_ndo;
                exception
                       when no_data_found then
                       lc_nombre := null;
                end;

                --razon social
                begin
                    select trim(j.pjrazs)
                      into lc_razsoc
                      from fsd003 j
                     where j.pjpais = ln_pai
                       and j.pjtdoc = ln_tdo
                       and j.pjndoc = lc_ndo;
                exception
                       when no_data_found then
                       lc_razsoc := null;
                end;

                --sexo
                begin
                    select a.pfcant
                      into lc_sexo
                      from fsd002 a
                     where a.pfpais = ln_pai
                       and a.pftdoc = ln_tdo
                       and a.pfndoc = lc_ndo;
                exception
                       when no_data_found then
                       lc_sexo := null;
                end;


                --juridica
                begin
                     select a.pfpai1,
                            a.pftdo1,
                            a.pfndo1
                       into ln_paij,
                            ln_tdoj,
                            lc_ndoj
                       from fsr003 a
                      where a.pjpais = ln_pai
                        and a.pjtdoc = ln_tdo
                        and a.pjndoc = lc_ndo;
                 exception
                        when too_many_rows then
                             begin
                                 select a.pfpai1,
                                        a.pftdo1,
                                        a.pfndo1
                                   into ln_paij,
                                        ln_tdoj,
                                        lc_ndoj
                                   from fsr003 a
                                  where a.pjpais = ln_pai
                                    and a.pjtdoc = ln_tdo
                                    and a.pjndoc = lc_ndo
                                    and a.vicod  <> 1
                                    and rownum = 1;
                             exception
                                    when no_data_found then null;

                             end;
                          when no_data_found then null;
                 end;
                --fecha de nacimiento
                if lc_petipo = 'F' then  --mod 2016.04.14
                    begin
                        select a.pffnac
                          into ld_fecnac
                          from fsd002 a
                         where a.pfpais = ln_pai
                           and a.pftdoc = ln_tdo
                           and a.pfndoc = lc_ndo;
                    exception
                           when no_data_found then
                           ld_fecnac := null;
                    end;
                    else
                           begin
                                select a.pffnac
                                  into ld_fecnac
                                  from fsd002 a
                                 where a.pfpais = ln_paij
                                   and a.pftdoc = ln_tdoj
                                   and a.pfndoc = lc_ndoj;
                            exception
                                   when no_data_found then
                                   ld_fecnac := null;
                            end;

                            begin
                                select a.pfcant
                                  into lc_sexo
                                  from fsd002 a
                                 where a.pfpais = ln_paij
                                   and a.pftdoc = ln_tdoj
                                   and a.pfndoc = lc_ndoj;
                            exception
                                   when no_data_found then
                                   lc_sexo := null;
                            end;

                            --apellido paterno
                            begin
                                select a.pfape1
                                  into lc_apepat
                                  from fsd002 a
                                 where a.pfpais = ln_paij
                                   and a.pftdoc = ln_tdoj
                                   and a.pfndoc = lc_ndoj;
                            exception
                                   when no_data_found then
                                   lc_apepat := null;
                            end;

                            --apellido materno
                            begin
                                select a.pfape2
                                  into lc_apemat
                                  from fsd002 a
                                 where a.pfpais = ln_paij
                                   and a.pftdoc = ln_tdoj
                                   and a.pfndoc = lc_ndoj;
                            exception
                                   when no_data_found then
                                   lc_apemat := null;
                            end;

                            --nombres
                            begin
                                select trim(a.pfnom1)||' '||trim(a.pfnom2)
                                  into lc_nombre
                                  from fsd002 a
                                 where a.pfpais = ln_paij
                                   and a.pftdoc = ln_tdoj
                                   and a.pfndoc = lc_ndoj;
                            exception
                                   when no_data_found then
                                   lc_nombre := null;
                            end;

                            ln_pai := ln_paij;
                            ln_tdo := ln_tdoj;
                            lc_ndo := lc_ndoj;

                end if;     --mod 2016.04.14

                ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.JAQZ097EMP,i.JAQZ097MOD,i.JAQZ097SUC,i.JAQZ097MDA,i.JAQZ097PAP,i.JAQZ097CTA,
                   i.JAQZ097OPE,i.JAQZ097SBO,i.JAQZ097TOP);


                --suma asegurada
                ln_mtoFin := null;
                ln_mtoFin := pq_cr_tramdesgra.Fn_montoDes(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                       i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                       i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP,
                                                       pd_fecfin);


                --fecha de la cuota por vencer
                ld_Fec := null;
                 pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                       i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                       i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP,
                                                           pd_fecfin,ld_Fec);

                --fecha de primera cuota
                ld_Fecpri := null;
                 pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz097emp,i.jaqz097MOD,i.jaqz097SUC,
                                                       i.jaqz097MDA,i.jaqz097PAP,i.jaqz097CTA,
                                                       i.jaqz097OPE,i.jaqz097SBO,i.jaqz097TOP,
                                                           pd_fecfin,ld_Fecpri);


                insert into JAQZ097(JAQZ097EMP,JAQZ097MOD,JAQZ097SUC,JAQZ097MDA,JAQZ097PAP,JAQZ097CTA,
                                JAQZ097OPE,JAQZ097SBO,JAQZ097TOP,JAQZ097FEC,JAQZ097MAP,
                                JAQZ097FEI,JAQZ097FEF,JAQZ097NUM,JAQZ097TAS,JAQZ097MPR,/*JAQZ097SCA,*/
                                JAQZ097GRU,JAQZ097PLA,JAQZ097PAI,JAQZ097TDO,JAQZ097NDO,JAQZ097TPE,
                                JAQZ097SEX,JAQZ097FNA,JAQZ097APT,JAQZ097APM,JAQZ097NOM,JAQZ097RZO,
                                JAQZ097MPA,JAQZ097NUC,JAQZ097IMP,JAQZ097FVA,JAQZ097DGA,JAQZ097PER,
                                JAQZ097MCA,JAQZ097FVE,JAQZ097EST,JAQZ097FPR)

            Values(i.JAQZ097EMP,i.JAQZ097MOD,i.JAQZ097SUC,i.JAQZ097MDA,i.JAQZ097PAP,i.JAQZ097CTA,
                   i.JAQZ097OPE,i.JAQZ097SBO,i.JAQZ097TOP,pd_fecfin,ln_mtoapr,
                   ld_fecvini,ld_fecvfin,ln_numpol,ln_tasa,ln_monto,/*ln_salcap,*/ln_grupo,lc_plan,
                   ln_pai,ln_tdo,lc_ndo,lc_petipo,lc_sexo,ld_fecnac,lc_apepat,lc_apemat,lc_nombre,
                   lc_razsoc,ln_monto_tot,lc_numcre,/*I.JAQZ097IMP*/ln_mtoFin,I.JAQZ097FVA,ln_gracia,i.jaqz097per,
                   ln_mtoCalen,ld_Fec,I.JAQZ097EST,ld_Fecpri);
            end loop;

       end;

end Sp_Carga_Desem;

Procedure Sp_dataFSH012_pag(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                        pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                        pn_top in number,pd_fecpro in date,pd_pago in date,pn_sca out number,pn_gpo out number)is
ld_fec date;

ld_fecmax date;
ln_mesAct number(2);
ln_mesPag number(2);
ld_fecpago date;

begin
     ln_mesAct := to_number(to_char(pd_fecpro,'mm'));
     ld_fecmax := pd_pago;

     ln_mesPag := to_number(to_char(ld_fecmax,'mm'));

     if ld_fecmax is null then
        begin
           select aoimp,aofval
             into pn_sca,ld_fec
             from fsd010 a
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top;
        exception
              when no_data_found then
                   pn_sca := null;

        end;

        begin
             select a.scgru
               into pn_gpo
               from fsd011 a
              where pgcod  = pn_emp
                and scmod  = pn_mod
                and scsuc  = pn_suc
                and scmda  = pn_mda
                and scpap  = pn_pap
                and sccta  = pn_cta
                and scoper = pn_ope
                and scsbop = pn_sbo
                and sctope = pn_top
                ;
           exception
                when no_data_found then
                     pn_gpo := null;
           end;

          if pn_gpo is null then
              begin
                    select b.bcgpo
                      into pn_gpo
                      from fsh012 b
                     where b.bcemp = pn_emp
                       and b.bcsuc = pn_suc
                       and b.bcrubr in (select rubro
                                          from fsd014
                                         where (pcnivc in
                                               (select modulo
                                                  from fst111
                                                 where dscod = 50
                                                   and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                )
                                           and pcimpu = 'S'
                                           and pmtit <> 9)
                       and b.bcmda = pn_mda
                       and b.bcpap = pn_pap
                       and b.bccta = pn_cta
                       and b.bcoper = pn_ope
                       and b.bcsbop = pn_sbo
                       and b.bctop = pn_top
                       and b.bcfech = ld_fec
                       and b.bcmod = pn_mod
                       and b.bcsdmn <> 0
                       and rownum = 1;

               exception
                    when others then
                         pn_gpo := null;
               end;
          end if;
        else
             begin
                   select min(a.pp1fech)
                     into ld_fecpago
                     from fsd602 a
                    where a.pgcod   = pn_emp
                      and a.ppmod   = pn_mod
                      and a.ppsuc   = pn_suc
                      and a.ppmda   = pn_mda
                      and a.pppap   = pn_pap
                      and a.ppcta   = pn_cta
                      and a.ppoper  = pn_ope
                      and a.ppsbop  = pn_sbo
                      and a.pptope  = pn_top
                      and a.ppfpag  = ld_fecmax
                      --and a.pp1stat = 'T'
                      and pp1fech   <= pd_fecpro
                      and a.d602co  = 'S'
                      ;

             exception
                   when no_data_found then
                        ld_fecpago := null;
             end;

             if ln_mesAct = ln_mesPag then
                 begin
                          select b.bcsdmo,b.bcgpo
                            into pn_sca,pn_gpo
                            from fsh012 b
                           where b.bcemp = pn_emp
                             and b.bcsuc = pn_suc
                             and b.bcrubr in (select rubro
                                                from fsd014
                                               where (pcnivc in
                                                     (select modulo
                                                        from fst111
                                                       where dscod = 50
                                                         and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                          )
                                                 and pcimpu = 'S'
                                                 and pmtit <> 9)
                             and b.bcmda = pn_mda
                             and b.bcpap = pn_pap
                             and b.bccta = pn_cta
                             and b.bcoper = pn_ope
                             and b.bcsbop = pn_sbo
                             and b.bctop = pn_top
                             and b.bcfech = (ld_fecpago - 1)
                             and b.bcmod = pn_mod
                             and rownum = 1;

                 exception
                      when others then
                           pn_sca := null;
                           pn_gpo := null;
                 end;

                 if pn_sca is null then
                 begin
                   select aoimp,aofval
                     into pn_sca,ld_fec
                     from fsd010 a
                    where a.pgcod  = pn_emp
                      and a.aomod  = pn_mod
                      and a.aosuc  = pn_suc
                      and a.aomda  = pn_mda
                      and a.aopap  = pn_pap
                      and a.aocta  = pn_cta
                      and a.aooper = pn_ope
                      and a.aosbop = pn_sbo
                      and a.aotope = pn_top;
                exception
                      when no_data_found then
                           pn_sca := null;

                end;

                begin
                     select a.scgru
                       into pn_gpo
                       from fsd011 a
                      where pgcod  = pn_emp
                        and scmod  = pn_mod
                        and scsuc  = pn_suc
                        and scmda  = pn_mda
                        and scpap  = pn_pap
                        and sccta  = pn_cta
                        and scoper = pn_ope
                        and scsbop = pn_sbo
                        and sctope = pn_top
                        ;
                   exception
                        when no_data_found then
                             pn_gpo := null;
                   end;
                   if pn_gpo is null then
                        begin
                              select b.bcgpo
                                into pn_gpo
                                from fsh012 b
                               where b.bcemp = pn_emp
                                 and b.bcsuc = pn_suc
                                 and b.bcrubr in (select rubro
                                                    from fsd014
                                                   where (pcnivc in
                                                         (select modulo
                                                            from fst111
                                                           where dscod = 50
                                                             and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                          )
                                                     and pcimpu = 'S'
                                                     and pmtit <> 9)
                                 and b.bcmda = pn_mda
                                 and b.bcpap = pn_pap
                                 and b.bccta = pn_cta
                                 and b.bcoper = pn_ope
                                 and b.bcsbop = pn_sbo
                                 and b.bctop = pn_top
                                 and b.bcfech = ld_fec
                                 and b.bcmod = pn_mod
                                 and b.bcsdmn <> 0
                                 and rownum = 1;

                         exception
                              when others then
                                   pn_gpo := null;
                         end;
                    end if;
                  end if;

                 else

                           begin
                                    select b.bcsdmo,b.bcgpo
                                      into pn_sca,pn_gpo
                                      from fsh012 b
                                     where b.bcemp = pn_emp
                                       and b.bcsuc = pn_suc
                                       and b.bcrubr in (select rubro
                                                          from fsd014
                                                         where (pcnivc in
                                                               (select modulo
                                                                  from fst111
                                                                 where dscod = 50
                                                                   and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                                    )
                                                           and pcimpu = 'S'
                                                           and pmtit <> 9)
                                       and b.bcmda = pn_mda
                                       and b.bcpap = pn_pap
                                       and b.bccta = pn_cta
                                       and b.bcoper = pn_ope
                                       and b.bcsbop = pn_sbo
                                       and b.bctop = pn_top
                                       and b.bcfech = (ld_fecpago + 1)
                                       and b.bcmod = pn_mod
                                       and rownum = 1;

                           exception
                                when others then
                                     pn_sca := null;
                                     pn_gpo := null;
                           end;

                           if pn_sca is null then
                           begin
                                 select aoimp,aofval
                                   into pn_sca,ld_fec
                                   from fsd010 a
                                  where a.pgcod  = pn_emp
                                    and a.aomod  = pn_mod
                                    and a.aosuc  = pn_suc
                                    and a.aomda  = pn_mda
                                    and a.aopap  = pn_pap
                                    and a.aocta  = pn_cta
                                    and a.aooper = pn_ope
                                    and a.aosbop = pn_sbo
                                    and a.aotope = pn_top;
                              exception
                                    when no_data_found then
                                         pn_sca := null;

                              end;

                              begin
                                   select a.scgru
                                     into pn_gpo
                                     from fsd011 a
                                    where pgcod  = pn_emp
                                      and scmod  = pn_mod
                                      and scsuc  = pn_suc
                                      and scmda  = pn_mda
                                      and scpap  = pn_pap
                                      and sccta  = pn_cta
                                      and scoper = pn_ope
                                      and scsbop = pn_sbo
                                      and sctope = pn_top
                                      ;
                                 exception
                                      when no_data_found then
                                           pn_gpo := null;
                                 end;
                                 if pn_gpo is null then
                                      begin
                                            select b.bcgpo
                                              into pn_gpo
                                              from fsh012 b
                                             where b.bcemp = pn_emp
                                               and b.bcsuc = pn_suc
                                               and b.bcrubr in (select rubro
                                                                  from fsd014
                                                                 where (pcnivc in
                                                                       (select modulo
                                                                          from fst111
                                                                         where dscod = 50
                                                                           and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                                        )
                                                                   and pcimpu = 'S'
                                                                   and pmtit <> 9)
                                               and b.bcmda = pn_mda
                                               and b.bcpap = pn_pap
                                               and b.bccta = pn_cta
                                               and b.bcoper = pn_ope
                                               and b.bcsbop = pn_sbo
                                               and b.bctop = pn_top
                                               and b.bcfech = ld_fec
                                               and b.bcmod = pn_mod
                                               and b.bcsdmn <> 0
                                               and rownum = 1;

                                       exception
                                            when others then
                                                 pn_gpo := null;
                                       end;
                                  end if;
                                end if;

             end if;


     end if;
     if pn_sca is null then
        begin
           select aoimp,aofval
             into pn_sca,ld_fec
             from fsd010 a
            where a.pgcod  = pn_emp
              and a.aomod  = pn_mod
              --and a.aosuc  = pn_suc
              and a.aomda  = pn_mda
              and a.aopap  = pn_pap
              and a.aocta  = pn_cta
              and a.aooper = pn_ope
              and a.aosbop = pn_sbo
              and a.aotope = pn_top;
        exception
              when no_data_found then
                   pn_sca := null;

        end;

        begin
             select a.scgru
               into pn_gpo
               from fsd011 a
              where pgcod  = pn_emp
                and scmod  = pn_mod
                --and scsuc  = pn_suc
                and scmda  = pn_mda
                and scpap  = pn_pap
                and sccta  = pn_cta
                and scoper = pn_ope
                and scsbop = pn_sbo
                and sctope = pn_top
                ;
           exception
                when no_data_found then
                     pn_gpo := null;
           end;
           if pn_gpo is null then
                begin
                      select b.bcgpo
                        into pn_gpo
                        from fsh012 b
                       where b.bcemp = pn_emp
                         --and b.bcsuc = pn_suc
                         and b.bcrubr in (select rubro
                                            from fsd014
                                           where (pcnivc in
                                                 (select modulo
                                                    from fst111
                                                   where dscod = 50
                                                     and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
                                                  )
                                             and pcimpu = 'S'
                                             and pmtit <> 9)
                         and b.bcmda = pn_mda
                         and b.bcpap = pn_pap
                         and b.bccta = pn_cta
                         and b.bcoper = pn_ope
                         and b.bcsbop = pn_sbo
                         and b.bctop = pn_top
                         and b.bcfech = ld_fec
                         and b.bcmod = pn_mod
                         and b.bcsdmn <> 0
                         and rownum = 1;

                 exception
                      when others then
                           pn_gpo := null;
                 end;
            end if;
     end if;
end Sp_dataFSH012_pag;

FUNCTION fn_MONTO_PRIMA_CUO(pa_pgcod number, pa_ppmod number, pa_ppsuc number, pa_ppmda number,
                           pa_pppap number, pa_ppcta number, pa_ppoper number, pa_ppsbop number,
                           pa_pptope number) return number  IS

   cursor cronograma is
         select * from fsd601
          where pgcod = pa_pgcod
            and ppmod = pa_ppmod
            and ppsuc = pa_ppsuc
            and ppmda = pa_ppmda
            and pppap = pa_pppap
            and ppcta = pa_ppcta
            and ppoper = pa_ppoper
            and ppsbop = pa_ppsbop
            and pptope = pa_pptope;



   ln_mtodes number := 0;
   ln_monto  number := 0;
   ln_montoI  number := 0;
   ln_salcap number := 0;
   ln_tasa number;
   ln_mda number;
   ln_periodo number;
   ln_tipper number;
   ln_contador number :=0;
   ln_factor number;
   ln_cuota number;

   ln_num number;
   ln_valor number:=0;
   ln_pergra number:=0;
   ld_fecval date;
   ld_feccuo date;

   ln_cont number;

   BEGIN
       ln_cont :=0;
       begin
            select aoimp ,f.aomda, f.aoperiod, f.aofval
              into ln_mtodes , ln_mda, ln_periodo, ld_fecval
              from FSD010 f
              where f.pgcod = pa_pgcod
                and f.aomod = pa_ppmod
                and f.aosuc = pa_ppsuc
                and f.aomda = pa_ppmda
                and f.aopap = pa_pppap
                and f.aocta = pa_ppcta
                and f.aooper = pa_ppoper
                and f.aosbop = pa_ppsbop
                and f.aotope = pa_pptope;
       exception when others then
          ln_mtodes := 0;
       end;

       --obtiene tasa
       ln_tasa := pq_cr_seguro_desgravamen.fn_tasa_desgravamen(pa_pgcod => pa_pgcod,
                                                          pa_aomod => pa_ppmod,
                                                          pa_aosuc => pa_ppsuc,
                                                          pa_aomda => pa_ppmda,
                                                          pa_aopap => pa_pppap,
                                                          pa_aocta => pa_ppcta,
                                                          pa_aooper => pa_ppoper,
                                                          pa_aosbop => pa_ppsbop,
                                                          pa_aotope => pa_pptope,
                                                          pa_monto => ln_mtodes);
       ln_tasa := ln_tasa /100;

       ln_tipper := pq_cr_seguro_desgravamen.fn_periodo(pa_aoperiod => ln_periodo);


         begin
           select min(ppfpag)
             into ld_feccuo
             from fsd601
            where pgcod = pa_pgcod
              and ppmod = pa_ppmod
              and ppsuc = pa_ppsuc
              and ppmda = pa_ppmda
              and pppap = pa_pppap
              and ppcta = pa_ppcta
              and ppoper = pa_ppoper
              and ppsbop = pa_ppsbop
              and pptope = pa_pptope;
          exception when others then
               ld_feccuo := null;
          end;


        case
         when ln_tipper = 1 then
              ln_cuota := 30;
              ln_pergra := 1;
              ln_factor :=  1;
         when ln_tipper = 2 then
              ln_cuota := 4;
              ln_pergra := 7;
              ln_factor :=  1;
         when ln_tipper = 3 then
              ln_cuota := 2;
              ln_pergra := 15;
              ln_factor :=  1;
         when ln_tipper = 4 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 30;
              ln_factor :=  1;

              --ln_valor := (ld_feccuo - ld_fecval) / ln_pergra;  2015.12.28
              ln_valor := round((ld_feccuo - ld_fecval) / ln_pergra, 0);
              case
                when ln_valor >= 2 then
                     ln_valor := 2;
                when ln_valor >= 1 then
                     ln_valor := 1;
                else
                     ln_valor := 0;
              end case;
         when ln_tipper = 5 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 45;
              ln_factor :=  1;
              ln_valor := (ld_feccuo - ld_fecval) / ln_pergra;
              if ln_valor > 1 then
                   ln_valor := 1;
              else
                   ln_valor := 0;
              end if;

         when ln_tipper = 6 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 60;
              ln_factor :=  2;
              ln_valor := (ld_feccuo - ld_fecval) / ln_pergra;
              if ln_valor > 1 then
                   ln_valor := 1;
              else
                   ln_valor := 0;
              end if;
         when ln_tipper = 7 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 90;
              ln_factor :=  3;
              ln_valor := (ld_feccuo - ld_fecval) / ln_pergra;
              if ln_valor > 1 then
                   ln_valor := 1;
              else
                   ln_valor := 0;
              end if;
         when ln_tipper = 8 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 120;
              ln_factor :=  4;
         when ln_tipper = 9 then
              ln_tasa := ln_tasa * 1 ;
              ln_pergra := 180;
              ln_factor :=  6;
         end case ;

         ---------------;

         Case
       when ln_tipper in (4)   then
         --obtiene monto tasa
         ln_monto := round(ln_mtodes * ln_tasa ,2) * ln_valor;
         ln_salcap := ln_mtodes;
         ln_monto := pq_cr_seguro_desgravamen.fn_monto(ln_monto,pa_ppmda);


       when ln_tipper in (6,7,8,9)   then
         --obtiene monto tasa
         ln_monto := round(ln_mtodes * ln_tasa ,2);
         ln_monto := pq_cr_seguro_desgravamen.fn_monto(ln_monto,pa_ppmda);
         ln_monto := ln_monto * (ln_factor + ln_valor);
         ln_salcap := ln_mtodes;



       when ln_tipper in (1,2,3)   then
            --obtiene monto tasa
            ln_contador := ln_contador + 1;

             ln_monto := round(ln_mtodes * ln_tasa ,2);
             ln_monto := pq_cr_seguro_desgravamen.fn_monto(ln_monto,pa_ppmda);
             ln_monto := ln_monto * ln_factor;
             ln_salcap := ln_mtodes;
             ln_num := ln_contador + ln_cuota;

       when ln_tipper in (5)    then
            --obtiene monto tasa
           ln_contador := ln_contador + 1;
           if ln_contador = 1 then
              ln_factor := 2;
           end if;
           ln_monto := round(ln_mtodes * ln_tasa ,2);
           ln_monto := pq_cr_seguro_desgravamen.fn_monto(ln_monto,pa_ppmda);
           ln_monto := ln_monto * ln_factor;
           ln_salcap := ln_mtodes;


       End case;


       return ln_monto;

   EXCEPTION WHEN OTHERS THEN
        return 0;

END fn_MONTO_PRIMA_CUO;



function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number is
  ln_diagra number;
  ln_flg number(1);
  ln_periodo number;
  begin
    begin
      if pn_TOP = 550 or pn_mod in (200,33) then
         ln_diagra:= 0;
      else
         select ((select min(n.ppfpag)
                    from fsd601 n
                   where m.xllaocta  = n.ppcta
                     and m.xllaooper = n.ppoper
                     and m.xllaosbop = n.ppsbop
                     and m.xllaotop  = n.pptope
                     and m.xllaomod  = n.ppmod
                     and m.xllaosuc  = n.ppsuc
                     and m.xllaomda  = n.ppmda
                     and m.xllaopap  = n.pppap
                     and (n.ppcap+n.ppint)<>0
                     and n.d601co    = 'S')-m.xllfvalor)-m.xllperiodo
           into ln_diagra
           from X054023 m
          where m.xllpgcod  = pn_emp
            and m.xllaocta  = pn_cta
            and m.xllaooper = pn_oper
            and m.xllaosbop = pn_sbop
            and m.xllaotop  = pn_top
            and m.xllaomod  = pn_mod
            and m.xllaosuc  = pn_suc
            and m.xllaomda  = pn_mda
            and m.xllaopap  = pn_pap;
       end if;
    exception
        when no_data_found then
           ln_diagra := null;
        when too_many_rows then
           ln_diagra := null;
    end;
    begin

           if ln_diagra < 0 then
              ln_diagra := 0;
           end if;
    end;
    /*begin
         select m.xllperiodo
           into ln_periodo
           from X054023 m
          where m.xllpgcod  = pn_emp
            and m.xllaocta  = pn_cta
            and m.xllaooper = pn_oper
            and m.xllaosbop = pn_sbop
            and m.xllaotop  = pn_top
            and m.xllaomod  = pn_mod
            and m.xllaosuc  = pn_suc
            and m.xllaomda  = pn_mda
            and m.xllaopap  = pn_pap;
    end;*/
    begin
         if ln_diagra > 2 then
            ln_flg := 1;
            else
                ln_flg := 0;
         end if;
    end;
     return ln_flg;
end fn_dias_gracia;

Procedure Sp_monto_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pn_tip in number,pd_fecpro in date,ln_mtoprima out number,
                             lc_tip out varchar2)  is

cursor seguros is
select tp1imp1 tp1nro1
 from fst198
where tp1cod=1
  and tp1cod1= 10898
  and tp1corr1=8;

/*select a.tp1nro1
  from fst198 a
 where a.tp1cod1=10875
   and tp1corr1=1
   and tp1corr2=1;  */

cursor seguros_ii is
select *
  from fpp001 a
 where a.pgcod  = pn_emp
   and a.aomod  = pn_mod
   and a.aosuc  = pn_suc
   and a.aomda  = pn_mda
   and a.aopap  = pn_pap
   and a.aocta  = pn_cta
   and a.aooper = pn_ope
   and a.aosbop = pn_sbo
   and a.aotope = pn_top;

cursor calendario_vida is
select *
  from fsd611 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top;

ln_canSeg number(2);
ln_codVar number(2);
ld_fecan  date;

ld_fecini date;

--ln_mtoprima number(17,2) ;
ln_mto11 number(17,2) ;
ln_mto12 number(17,2) ;
ln_mto13 number(17,2) ;
ln_mto14 number(17,2) ;
ln_mto15 number(17,2) ;

lc_flag char(1);
ln_impAux number(17,2);

lc_flag11 char(1);
ln_impAux11 number(17,2);

lc_flag13 char(1);
ln_impAux13 number(17,2);

ld_pago date;
--lc_tip char(1);
begin

     ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');
     lc_tip :=  null;


     begin

       for i in seguros loop
           ln_canSeg := 0;
           ln_codVar := 0;
           for j in seguros_ii loop
               ln_canSeg := ln_canSeg+1;
               if i.tp1nro1 = j.SgCod then
                  ln_codVar := ln_canSeg;
                  exit;
               end if;
           end loop;

           if ln_codVar <> 0 then

                 begin
                     if pn_tip = 1 then --desembolsos
                        lc_tip :=  null;
                        begin
                               select min(a.ppfpag)
                                 into ld_fecan
                                 from fsd611 a
                                where a.pgcod  = pn_emp
                                  and a.ppmod  = pn_mod
                                  and a.ppsuc  = pn_suc
                                  and a.ppmda  = pn_mda
                                  and a.pppap  = pn_pap
                                  and a.ppcta  = pn_cta
                                  and a.ppoper = pn_ope
                                  and a.ppsbop = pn_sbo
                                  and a.pptope = pn_top;
                        exception
                            when others then
                                 insert into jaqz097_error
                                 values(pn_cta,pn_ope,1,SYSDATE);
                                 commit;
                        end;

                        begin
                               select ppimp11,
                                      ppimp12,
                                      ppimp13,
                                      ppimp14,
                                      ppimp15
                                 into ln_mto11,
                                      ln_mto12,
                                      ln_mto13,
                                      ln_mto14,
                                      ln_mto15
                                 from fsd611 a
                                where a.pgcod  = pn_emp
                                  and a.ppmod  = pn_mod
                                  and a.ppsuc  = pn_suc
                                  and a.ppmda  = pn_mda
                                  and a.pppap  = pn_pap
                                  and a.ppcta  = pn_cta
                                  and a.ppoper = pn_ope
                                  and a.ppsbop = pn_sbo
                                  and a.pptope = pn_top
                                  and a.ppfpag = ld_fecan;
                        exception
                            when others then
                                 insert into jaqz097_error
                                 values(pn_cta,pn_ope,2,SYSDATE);
                                 commit;
                        end;



                        case
                            when ln_codVar = 1 then
                                 ln_mtoprima := ln_mto11;
                                 if ln_mtoprima = 2.5 then
                                   ln_impAux := 2.5;
                                   for h in calendario_vida loop
                                       if ln_impAux = h.ppimp11 then

                                          lc_flag := 'S';
                                          else
                                              lc_flag := 'N';
                                              exit;
                                       end if;
                                       ln_impAux := h.ppimp11;
                                   end loop;

                                   if lc_flag = 'S' then
                                      ln_mtoprima := ln_mto12;
                                   end if;

                                 end if;
                                  when ln_codVar = 2 then
                                       ln_mtoprima := ln_mto12;
                                       if ln_mtoprima = 2.5 then
                                             ln_impAux := 2.5;
                                             for h in calendario_vida loop
                                                 if ln_impAux = h.ppimp12 then

                                                    lc_flag := 'S';
                                                    else
                                                        lc_flag := 'N';
                                                        exit;
                                                 end if;
                                                 ln_impAux := h.ppimp12;
                                             end loop;

                                             if lc_flag = 'S' then
                                                 ln_impAux11 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux11 = h.ppimp11 then

                                                        lc_flag11 := 'S';
                                                        else
                                                            lc_flag11 := 'N';
                                                            exit;
                                                     end if;
                                                     ln_impAux11 := h.ppimp11;
                                                 end loop;

                                                 ln_impAux13 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux13 = h.ppimp13 then

                                                        lc_flag13 := 'S';
                                                        else
                                                            lc_flag13 := 'N';
                                                            exit;
                                                     end if;
                                                     ln_impAux13 := h.ppimp13;
                                                 end loop;

                                                 if lc_flag11 = 'S' then
                                                    ln_mtoprima := ln_mto13;
                                                    else
                                                         ln_mtoprima := ln_mto11;
                                                 end if;
                                             end if;

                               end if;
                            when ln_codVar = 3 then
                                 ln_mtoprima := ln_mto13;
                                 if ln_mtoprima = 2.5 then
                                   ln_impAux := 2.5;
                                   for h in calendario_vida loop
                                       if ln_impAux = h.ppimp13 then

                                          lc_flag := 'S';
                                          else
                                              lc_flag := 'N';
                                              exit;
                                       end if;
                                       ln_impAux := h.ppimp13;
                                   end loop;

                                   if lc_flag = 'S' then
                                      ln_mtoprima := ln_mto12;
                                   end if;


                                 end if;
                            when ln_codVar = 4 then
                                 ln_mtoprima := ln_mto14;
                            when ln_codVar = 5 then
                                 ln_mtoprima := ln_mto15;
                            else ln_mtoprima := 0;

                       end case;

                        else
                                  begin
                                         select sum(ppimp11),
                                                sum(ppimp12),
                                                sum(ppimp13),
                                                sum(ppimp14),
                                                sum(ppimp15)
                                           into ln_mto11,
                                                ln_mto12,
                                                ln_mto13,
                                                ln_mto14,
                                                ln_mto15
                                           from fsd611 a
                                          where a.pgcod  = pn_emp
                                            and a.ppmod  = pn_mod
                                            and a.ppsuc  = pn_suc
                                            and a.ppmda  = pn_mda
                                            and a.pppap  = pn_pap
                                            and a.ppcta  = pn_cta
                                            and a.ppoper = pn_ope
                                            and a.ppsbop = pn_sbo
                                            and a.pptope = pn_top
                                            and a.ppfpag between ld_fecini and pd_fecpro;
                                  exception
                                      when others then
                                           insert into jaqz097_error
                                           values(pn_cta,pn_ope,3,SYSDATE);
                                           commit;
                                  end;

                                  begin
                                         select ppfpag
                                           into ld_pago
                                           from fsd611 a
                                          where a.pgcod  = pn_emp
                                            and a.ppmod  = pn_mod
                                            and a.ppsuc  = pn_suc
                                            and a.ppmda  = pn_mda
                                            and a.pppap  = pn_pap
                                            and a.ppcta  = pn_cta
                                            and a.ppoper = pn_ope
                                            and a.ppsbop = pn_sbo
                                            and a.pptope = pn_top
                                            and a.ppfpag between ld_fecini and pd_fecpro;
                                  exception
                                      when too_many_rows then
                                           insert into jaqz097_error
                                           values(pn_cta,pn_ope,55,SYSDATE);
                                           commit;

                                           begin
                                                   select max(ppfpag)
                                                     into ld_pago
                                                     from fsd611 a
                                                    where a.pgcod  = pn_emp
                                                      and a.ppmod  = pn_mod
                                                      and a.ppsuc  = pn_suc
                                                      and a.ppmda  = pn_mda
                                                      and a.pppap  = pn_pap
                                                      and a.ppcta  = pn_cta
                                                      and a.ppoper = pn_ope
                                                      and a.ppsbop = pn_sbo
                                                      and a.pptope = pn_top
                                                      and a.ppfpag between ld_fecini and pd_fecpro
                                                      and rownum = 1;
                                            exception
                                                when others then
                                                     null;

                                            end;
                                       when others then null;

                                  end;

                                  case
                                      when ln_codVar = 1 then
                                           ln_mtoprima := ln_mto11;
                                           if ln_mtoprima = 2.5 then
                                               ln_impAux := 2.5;
                                               for h in calendario_vida loop
                                                   if ln_impAux = h.ppimp11 then

                                                      lc_flag := 'S';
                                                      else
                                                          lc_flag := 'N';
                                                          exit;
                                                   end if;
                                                   ln_impAux := h.ppimp11;
                                               end loop;

                                               if lc_flag = 'S' then
                                                  ln_mtoprima := ln_mto12;
                                                  ln_codVar := 2;
                                               end if;

                                             end if;
                                      when ln_codVar = 2 then
                                           ln_mtoprima := ln_mto12;
                                           if ln_mtoprima = 2.5 then
                                             ln_impAux := 2.5;
                                             for h in calendario_vida loop
                                                 if ln_impAux = h.ppimp12 then

                                                    lc_flag := 'S';
                                                    else
                                                        lc_flag := 'N';
                                                        exit;
                                                 end if;
                                                 ln_impAux := h.ppimp12;
                                             end loop;

                                             if lc_flag = 'S' then
                                                 ln_impAux11 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux11 = h.ppimp11 then

                                                        lc_flag11 := 'S';
                                                        else
                                                            lc_flag11 := 'N';
                                                            exit;
                                                     end if;
                                                     ln_impAux11 := h.ppimp11;
                                                 end loop;

                                                 ln_impAux13 := 2.5;
                                                 for h in calendario_vida loop
                                                     if ln_impAux13 = h.ppimp13 then

                                                        lc_flag13 := 'S';
                                                        else
                                                            lc_flag13 := 'N';
                                                            exit;
                                                     end if;
                                                     ln_impAux13 := h.ppimp13;
                                                 end loop;

                                                 if lc_flag11 = 'S' then
                                                    ln_mtoprima := ln_mto13;
                                                    ln_codVar := 3;
                                                    else
                                                         ln_mtoprima := ln_mto11;
                                                         ln_codVar := 1;
                                                 end if;
                                             end if;

                                       end if;
                                      when ln_codVar = 3 then
                                           ln_mtoprima := ln_mto13;
                                           if ln_mtoprima = 2.5 then
                                               ln_impAux := 2.5;
                                               for h in calendario_vida loop
                                                   if ln_impAux = h.ppimp13 then

                                                      lc_flag := 'S';
                                                      else
                                                          lc_flag := 'N';
                                                          exit;
                                                   end if;
                                                   ln_impAux := h.ppimp13;
                                               end loop;

                                               if lc_flag = 'S' then
                                                  ln_mtoprima := ln_mto12;
                                                  ln_codVar := 2;
                                               end if;


                                             end if;
                                      when ln_codVar = 4 then
                                           ln_mtoprima := ln_mto14;
                                      when ln_codVar = 5 then
                                           ln_mtoprima := ln_mto15;
                                      else ln_mtoprima := 0;
                                 end case;


                                 lc_tip := pq_cr_tramdesgra.Fn_montoPag_calendario(pn_emp,
                                                                         pn_mod,
                                                                         pn_suc,
                                                                         pn_mda,
                                                                         pn_pap,
                                                                         pn_cta,
                                                                         pn_ope,
                                                                         pn_sbo,
                                                                         pn_top,
                                                                         pd_fecpro,
                                                                         ln_mtoprima,
                                                                         ln_codVar);


                     end if;



                     end;
           end if;

       end loop;
     end;

end Sp_monto_calendario;


Function Fn_scap_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_fecpro in date) return number is

ln_montocal number(17,2);
ln_mtodes number(17,2);
ln_salcap number(17,2);
ld_fecpxv date; --mod@abr 20170705
lc_flg char(1);--mod@abr 20170705
begin


      begin
          select aoimp
            into ln_mtodes
            from fsd010
           where pgcod  = pn_emp
             and aomod  = pn_mod
             and aosuc  = pn_suc
             and aomda  = pn_mda
             and aopap  = pn_pap
             and aocta  = pn_cta
             and aooper = pn_ope
             and aosbop = pn_sbo
             and aotope = pn_top;
      exception
        when too_many_rows then
             begin
                  select aoimp
                    into ln_mtodes
                    from fsd010
                   where pgcod  = pn_emp
                     and aomod  = pn_mod
                     and aosuc  = pn_suc
                     and aomda  = pn_mda
                     and aopap  = pn_pap
                     and aocta  = pn_cta
                     and aooper = pn_ope
                     and aosbop = pn_sbo
                     and aotope = pn_top;
              exception
                when others then null;
              end;
           when others then null;
      end;

      --mod@abr 20170705
      --verifica caja solidario
      begin
        select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
            into ld_fecpxv
            from fsd601 n
           where n.pgcod  = pn_emp
             and n.ppcta  = pn_cta
             and n.ppmda  = pn_mda
             and n.ppsuc  = pn_suc
             and n.pppap  = pn_pap
             and n.ppoper = pn_ope
             and n.ppsbop = pn_sbo
             and n.pptope = pn_top
             and n.ppmod  = pn_mod
             and n.d601co = 'S'
             and (n.ppcap+n.ppint)<>0
             and not exists
                      (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                         from fsd602 o
                        where o.pgcod   = n.pgcod
                          and o.ppmod   = n.ppmod
                          and o.ppsuc   = n.ppsuc
                          and o.ppmda   = n.ppmda
                          and o.pppap   = n.pppap
                          and o.ppcta   = n.ppcta
                          and o.ppoper  = n.ppoper
                          and o.ppsbop  = n.ppsbop
                          and o.pptope  = n.pptope
                          and o.ppfpag  = n.ppfpag
                          --and o.ppfpag  <= pd_fecpro
                          and o.pp1fech  <= pd_fecpro
                          and o.pp1stat = 'T'
                          and o.d602co  = 'S'
                          and (o.pp1cap+o.pp1int)<>0);
      end;

      if ld_fecpxv <= pd_fecpro then
        lc_flg := 'S';
        else
          lc_flg := 'N';
      end if;


      if  lc_flg = 'S' then

              begin
                select sum(a.ppcap)
                  into ln_montocal
                  from fsd601 a
                 where a.pgcod  = pn_emp
                   and a.ppmod  = pn_mod
                   and a.ppsuc  = pn_suc
                   and a.ppmda  = pn_mda
                   and a.pppap  = pn_pap
                   and a.ppcta  = pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.ppfpag <= add_months(ld_fecpxv,-1)
                   ;
            exception
                   when others then
                        ln_montocal := null;
            end;

          else

              begin
                  select sum(a.ppcap)
                    into ln_montocal
                    from fsd601 a
                   where a.pgcod  = pn_emp
                     and a.ppmod  = pn_mod
                     and a.ppsuc  = pn_suc
                     and a.ppmda  = pn_mda
                     and a.pppap  = pn_pap
                     and a.ppcta  = pn_cta
                     and a.ppoper = pn_ope
                     and a.ppsbop = pn_sbo
                     and a.pptope = pn_top
                     and a.ppfpag <= add_months(pd_fecpro,-1)
                     ;
              exception
                     when others then
                          ln_montocal := null;
              end;
      end if;
      ---fin mod@abr 20170705

      if ln_montocal is null then
         ln_salcap := ln_mtodes;
         else
             ln_salcap := ln_mtodes - ln_montocal;
      end if;
      return ln_salcap;

end Fn_scap_calendario;

Function Fn_tipoSBS(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return number is

ln_grup number(2);
ld_aofe date;
ld_aofval date;
ld_fecsbs date;
ld_fecant date;
begin
     begin
           select a.scgru
             into ln_grup
             from fsd011 a
            where a.pgcod  = pn_emp
              and a.scsuc  = pn_suc
              and a.scmda  = pn_mda
              and a.scpap  = pn_pap
              and a.sccta  = pn_cta
              and a.scoper = pn_ope
              and a.scsbop = pn_sbo
              and a.sctope = pn_top
              and a.scmod  = pn_mod
							and rownum = 1; --HSUAREZ 2016.08.18 - MODIFICACION PARA SOLO ACEPTAR UNA FILA.
     exception
          when no_data_found then
              ln_grup := null;
     end;

     if ln_grup is null then
        begin
                select aofe99,aofval
                  into ld_aofe,ld_aofval
                  from fsd010
                 where pgcod  = pn_emp
                   and aomod  = pn_mod
                   and aosuc  = pn_suc
                   and aomda  = pn_mda
                   and aopap  = pn_pap
                   and aocta  = pn_cta
                   and aooper = pn_ope
                   and aosbop = pn_sbo
                   and aotope = pn_top;
        exception
             when no_data_found then
                  begin
                          select aofe99,aofval
                            into ld_aofe,ld_aofval
                            from fsd010
                           where pgcod  = pn_emp
                             and aomod  = pn_mod
                             --and aosuc  = pn_suc
                             and aomda  = pn_mda
                             and aopap  = pn_pap
                             and aocta  = pn_cta
                             and aooper = pn_ope
                             and aosbop = pn_sbo
                             and aotope = pn_top;
                  exception
                       when no_data_found then
                            insert into jaqz097_error
                            values(pn_cta,pn_ope,9,SYSDATE);
                            commit;
                  end;
        end;

        ld_fecsbs := last_day(ld_aofval);
        ld_fecant := ld_aofe - 1;
        begin
              select a.bcgpo
                into ln_grup
                from fsh012 a
               where a.bcemp  = pn_emp
                 and a.bcsuc  = pn_suc
                 and a.bcrubr in (select rubro from fsd014 a where pcnivc = pn_mod)
                 and a.bcmda  = pn_mda
                 and a.bcpap  = pn_pap
                 and a.bccta  = pn_cta
                 and a.bcoper = pn_ope
                 and a.bcsbop = pn_sbo
                 and a.bctop  = pn_top
                 and a.bcfech = ld_fecant
                 and a.bcmod  = pn_mod
                 and rownum   = 1;
        exception
              when no_data_found then
                   /*begin
                          select a.bcgpo
                            into ln_grup
                            from fsh012 a
                           where a.bcemp  = pn_emp
                             --and a.bcsuc  = pn_suc
                             and a.bcrubr in (select rubro from fsd014 a where pcnivc = pn_mod)
                             and a.bcmda  = pn_mda
                             and a.bcpap  = pn_pap
                             and a.bccta  = pn_cta
                             and a.bcoper = pn_ope
                             and a.bcsbop = pn_sbo
                             and a.bctop  = pn_top
                             and a.bcfech = ld_fecant
                             and a.bcmod  = pn_mod
                             and rownum   = 1;
                    exception
                          when no_data_found then*/
                               begin
                                      select a.bcgpo
                                        into ln_grup
                                        from fsh012 a
                                       where a.bcemp  = pn_emp
                                         and a.bcsuc  = pn_suc
                                         and a.bcrubr in (select rubro from fsd014 a where pcnivc = pn_mod)
                                         and a.bcmda  = pn_mda
                                         and a.bcpap  = pn_pap
                                         and a.bccta  = pn_cta
                                         and a.bcoper = pn_ope
                                         and a.bcsbop = pn_sbo
                                         and a.bctop  = pn_top
                                         and a.bcfech = ld_fecsbs
                                         and a.bcmod  = pn_mod
                                         and rownum   = 1;
                                exception
                                      when no_data_found then
                                           ln_grup := null;
                                      when others then null;

                    end;
           when others then null;
        end;
     end if;

     return ln_grup;

end Fn_tipoSBS;
------------------------------------------------------------------------------------
procedure sp_tipoSBS(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number, ln_grup out number) is



begin
    ln_grup := pq_cr_tramdesgra.Fn_tipoSBS(pn_emp,pn_mod,pn_suc,
                                           pn_mda,pn_pap,pn_cta,
                                           pn_ope,pn_sbo,pn_top);

null;
end sp_tipoSBS;



-------------------------------------------------------------------------------

Function fn_prima_calculada(pn_mda in number,pn_mto in number,pn_tas in number,
                            pn_emp in number,pn_mod in number,pn_suc in number,
                            pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                            pn_top in number)return number is
ln_mto number(17,2);
ln_periodo number(5);
ln_mul number(3);
begin
     begin
       select aoperiod
         into ln_periodo
         from fsd010 a
        where a.pgcod  = pn_emp
          and a.aomod  = pn_mod
          and a.aosuc  = pn_suc
          and a.aomda  = pn_mda
          and a.aopap  = pn_pap
          and a.aocta  = pn_cta
          and a.aooper = pn_ope
          and a.aosbop = pn_sbo
          and a.aotope = pn_top;
     exception
         when no_data_found then null;
     end;

     begin
         if pn_mda = 0 then
            ln_mto := (pn_mto * pn_tas)/100;
            if ln_mto < 1 then
               ln_mto :=1;
            end if;

            else
                ln_mto := (pn_mto * pn_tas)/100;
                if ln_mto < 0.35 then
                   ln_mto :=0.35;
                end if;
         end if;
     end;

     case
         when ln_periodo between 60 and 89 then
              ln_mul := round(ln_periodo/30,0);
         when ln_periodo between 90 and 119 then
              ln_mul := round(ln_periodo/30,0);
         when ln_periodo >= 120 then
              ln_mul := round(ln_periodo/30,0);
         else
              ln_mul := 1;
     end case;
     ln_mto := ln_mto *ln_mul;

     return ln_mto;
end fn_prima_calculada;

Function Fn_montoDes(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                      pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                      pn_top in number,pd_fecpro in date) return number is

ld_evento date;
ln_mtoPag number(17,2);
ln_mtoFin number(17,2);
ln_mtodes number(17,2);
ld_fecaux date;
ln_mtoAux number(17,2);
lc_flag   char(1);

cursor transacciones is
select n.tp1nro1,tp1nro2
  from fst198 n
 where tp1cod   = 1
   and tp1cod1  = 10899
   and tp1corr1 = 7
   and tp1corr2 = 1;

begin
          begin
               select a.aoimp
                 into ln_mtodes
                 from fsd010 a
                where a.pgcod  = pn_emp
                  and a.aomod  = pn_mod
                  and a.aosuc  = pn_suc
                  and a.aomda  = pn_mda
                  and a.aopap  = pn_pap
                  and a.aocta  = pn_cta
                  and a.aooper = pn_ope
                  and a.aosbop = pn_sbo
                  and a.aotope = pn_top ;
          exception
                  when no_data_found then
                   ln_mtodes := null;
          end;

          begin
               select a.evfval
                 into ld_evento
                 from fsd012 a
                where a.pgcod  = pn_emp
                  and a.aomod  = pn_mod
                  and a.aosuc  = pn_suc
                  and a.aomda  = pn_mda
                  and a.aopap  = pn_pap
                  and a.aocta  = pn_cta
                  and a.aooper = pn_ope
                  and a.aosbop = pn_sbo
                  and a.aotope = pn_top
                  and a.evtipo = 50
                  and a.evfval <= pd_fecpro
                  and a.d012co = 'S';
          exception
              when no_data_found then
                   ld_evento := null;
              when others then
                                 insert into jaqz097_error
                                 values(pn_cta,pn_ope,78,SYSDATE);
                                 commit;
          end;

          if ld_evento is not null then


             begin
                      select a.pp1cap
                        into ln_mtoAux
                        from fsd602 a
                       where a.pgcod  = pn_emp
                         and a.ppmod  = pn_mod
                         and a.ppsuc  = pn_suc
                         and a.ppmda  = pn_mda
                         and a.pppap  = pn_pap
                         and a.ppcta  = pn_cta
                         and a.ppoper = pn_ope
                         and a.ppsbop = pn_sbo
                         and a.pptope = pn_top
                         and a.d602fc = ld_evento
                         and a.d602co = 'S';
             exception
               when too_many_rows then
                    begin
                          select a.pp1cap
                            into ln_mtoAux
                            from fsd602 a
                           where a.pgcod  = pn_emp
                             and a.ppmod  = pn_mod
                             and a.ppsuc  = pn_suc
                             and a.ppmda  = pn_mda
                             and a.pppap  = pn_pap
                             and a.ppcta  = pn_cta
                             and a.ppoper = pn_ope
                             and a.ppsbop = pn_sbo
                             and a.pptope = pn_top
                             and a.d602fc = ld_evento
                             and a.d602co = 'S'
                             and rownum = 1;
                     exception
                       when others then null;
                     end;
                when others then null;
             end;
             begin
                      select min(a.ppfpag)
                        into ld_fecaux
                        from fsd601 a
                       where a.pgcod  = pn_emp
                         and a.ppmod  = pn_mod
                         and a.ppsuc  = pn_suc
                         and a.ppmda  = pn_mda
                         and a.pppap  = pn_pap
                         and a.ppcta  = pn_cta
                         and a.ppoper = pn_ope
                         and a.ppsbop = pn_sbo
                         and a.pptope = pn_top
                         and a.ppfpag > ld_evento
                         and a.d601co = 'S';
                         --and a.d602mo = i.tp1nro1
                         --and a.d602tr = i.tp1nro2;
                 exception
                       when too_many_rows then
                            begin
                                    select min(a.ppfpag)
                                      into ld_fecaux
                                      from fsd601 a
                                     where a.pgcod  = pn_emp
                                       and a.ppmod  = pn_mod
                                       and a.ppsuc  = pn_suc
                                       and a.ppmda  = pn_mda
                                       and a.pppap  = pn_pap
                                       and a.ppcta  = pn_cta
                                       and a.ppoper = pn_ope
                                       and a.ppsbop = pn_sbo
                                       and a.pptope = pn_top
                                       and a.ppfpag > ld_evento
                                       and a.d601co = 'S'
                                       and rownum = 1;
                                       --and a.d602mo = i.tp1nro1
                                       --and a.d602tr = i.tp1nro2;
                               exception
                                      when others then null;

                           end;
                        when others then null;
                                     --insert into jaqz097_error
                                     --values(pn_cta,pn_ope,77);
                                     --commit;
             end;


             /*for i in transacciones loop
                 begin
                      select 'S'
                        into lc_flag
                        from fsd601 a
                       where a.pgcod  = pn_emp
                         and a.ppmod  = pn_mod
                         and a.ppsuc  = pn_suc
                         and a.ppmda  = pn_mda
                         and a.pppap  = pn_pap
                         and a.ppcta  = pn_cta
                         and a.ppoper = pn_ope
                         and a.ppsbop = pn_sbo
                         and a.pptope = pn_top
                         and a.ppfpag = ld_fecaux
                         and a.d601co = 'S'
                         and a.d601mo = i.tp1nro1
                         and a.d601tr = i.tp1nro2;
                 exception
                         when no_data_found then
                              lc_flag := 'N';
                         when others then null;
                                     --insert into jaqz097_error
                                     --values(pn_cta,pn_ope,77);
                                     --commit;
                 end;
                 if lc_flag = 'S' then
                    exit;
                 end if;

             end loop;
             */

             if ld_fecaux = ld_evento then
                lc_flag := 'S';
             end if;

             if lc_flag = 'S' then

                ln_mtoFin := ln_mtodes - ln_mtoAux;
                else
                   ln_mtoFin := ln_mtodes;
             end if;

             else
             ln_mtoFin := ln_mtodes;

          end if;

          return ln_mtoFin;
end Fn_montoDes;

Procedure Sp_Cuota_Vencer(pn_emp in number,pn_mod in number,pn_suc in number,
                          pn_mda in number,pn_pap in number,pn_cta in number,
                          pn_ope in number,pn_sbo in number,pn_top in number,
                          pd_fecpro in date,pd_fec out date) is

begin
  begin
      select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
      into pd_fec
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_ope
       and n.ppsbop = pn_sbo
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists
                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  exception
      when too_many_rows then
           begin
                select /*+ parallel(n,2,1)*/
                     min(n.ppfpag)
                into pd_fec
                from fsd601 n
               where n.pgcod  = pn_emp
                 and n.ppcta  = pn_cta
                 and n.ppmda  = pn_mda
                 and n.ppsuc  = pn_suc
                 and n.pppap  = pn_pap
                 and n.ppoper = pn_ope
                 and n.ppsbop = pn_sbo
                 and n.pptope = pn_top
                 and n.ppmod  = pn_mod
                 and n.d601co = 'S'
                 and (n.ppcap+n.ppint)<>0
                 and not exists
                          (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                             from fsd602 o
                            where o.pgcod   = n.pgcod
                              and o.ppmod   = n.ppmod
                              and o.ppsuc   = n.ppsuc
                              and o.ppmda   = n.ppmda
                              and o.pppap   = n.pppap
                              and o.ppcta   = n.ppcta
                              and o.ppoper  = n.ppoper
                              and o.ppsbop  = n.ppsbop
                              and o.pptope  = n.pptope
                              and o.ppfpag  = n.ppfpag
                              --and o.ppfpag  <= pd_fecpro
                              and o.pp1fech  <= pd_fecpro
                              and o.pp1stat = 'T'
                              and o.d602co  = 'S'
                              and (o.pp1cap+o.pp1int)<>0)
                  and rownum = 1;
            exception
                when others then null;

            end;
     when others then null;
  end;



end Sp_Cuota_Vencer;

Function Fn_tipoSBS_2(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return char is

ln_ins number(10);
lc_tip char(30);
ln_sucAct number(3);
begin
  ln_ins := fn_instancia_credito(pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top);
  if nvl(ln_ins,0) = 0 then
               begin
                     select a.aosuc
                       into ln_sucAct
                       from fsd010 a
                      where a.pgcod  = pn_emp
                        and a.aomod  = pn_mod
                        and a.aomda  = pn_mda
                        and a.aopap  = pn_pap
                        and a.aocta  = pn_cta
                        and a.aooper = pn_ope
                        and a.aosbop = pn_sbo
                        and a.aotope = pn_top;
               exception
                        when others then null;
               end;
               ln_ins := fn_instancia_credito(pn_mod,ln_sucAct,pn_mda,pn_pap,pn_cta,
                                                    pn_ope,pn_sbo,pn_top);

               else
                        ln_sucAct:=pn_suc;
            end if;
  begin
     select  upper( substr(wfattsval,instr(wfattsval,';',1)+1 , length(trim(wfattsval))))--a.wfattsval
       into lc_tip
       from wfattsvalues a
      where a.wfinsprcid = ln_ins
        and a.wfattsid = 'TIPO_CREDITO';
  exception
    when too_many_rows then
         begin
             select  upper( substr(wfattsval,instr(wfattsval,';',1)+1 , length(trim(wfattsval))))--a.wfattsval
               into lc_tip
               from wfattsvalues a
              where a.wfinsprcid = ln_ins
                and a.wfattsid = 'TIPO_CREDITO'
                and rownum = 1;
          exception
            when others then null;
          end;
     when others then null;
  end;


     return lc_tip;

end Fn_tipoSBS_2;

------------------------------------------------------------------------------------------

procedure sp_tipoSBS_2(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number, lc_tip out char)  is


begin
  lc_tip := pq_cr_tramdesgra.Fn_tipoSBS_2(pn_emp,pn_mod,pn_suc,
                                           pn_mda,pn_pap,pn_cta,
                                           pn_ope,pn_sbo,pn_top);

null;

end sp_tipoSBS_2;

------------------------------------------------------------------------

Procedure Sp_TipPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                     pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                     pn_top in number,pd_fec in date)is

lv_flag varchar2(1);
begin
        lv_flag := 'C';
          begin
                 select 'P'
                   into lv_flag
                   from fsd612 a
                  where a.pgcod  = pn_emp
                    and a.ppmod  = pn_mod
                    and a.ppsuc  = pn_suc
                    and a.ppmda  = pn_mda
                    and a.pppap  = pn_pap
                    and a.ppcta  = pn_cta
                    and a.ppoper = pn_ope
                    and a.ppsbop = pn_sbo
                    and a.pptope = pn_top
                    and a.ppfpag = pd_fec;
          exception
              when others then
                   insert into jaqz097_error
                   values(pn_cta,pn_ope,3,SYSDATE);
                   commit;
          end;


end Sp_TipPago;

-------------------------------------------------------------------------------
Function Fn_tipoSBS_Des(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number) return number is

ln_ins number(10);
ln_tip number(5);
ln_sucAct number(3);
begin
  ln_ins := fn_instancia_credito(pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top);
  if nvl(ln_ins,0) = 0 then
               begin
                     select a.aosuc
                       into ln_sucAct
                       from fsd010 a
                      where a.pgcod  = pn_emp
                        and a.aomod  = pn_mod
                        and a.aomda  = pn_mda
                        and a.aopap  = pn_pap
                        and a.aocta  = pn_cta
                        and a.aooper = pn_ope
                        and a.aosbop = pn_sbo
                        and a.aotope = pn_top;
               exception
                        when others then null;
               end;
               ln_ins := fn_instancia_credito(pn_mod,ln_sucAct,pn_mda,pn_pap,pn_cta,
                                                    pn_ope,pn_sbo,pn_top);

               else
                        ln_sucAct:=pn_suc;
            end if;
  begin
     select  substr(wfattsval,1,instr(wfattsval,';',1)-1)--a.wfattsval
       into ln_tip
       from wfattsvalues a
      where a.wfinsprcid = ln_ins
        and a.wfattsid = 'TIPO_CREDITO';
  exception
      when too_many_rows then
           begin
               select  substr(wfattsval,1,instr(wfattsval,';',1)-1)--a.wfattsval
                 into ln_tip
                 from wfattsvalues a
                where a.wfinsprcid = ln_ins
                  and a.wfattsid = 'TIPO_CREDITO'
                  and rownum = 1;
            exception
                when others then null;

            end;
       when others then null;
  end;


     return ln_tip;

end Fn_tipoSBS_Des;
----------------------------------------------------------------------------------------------
Function Fn_montoPag_calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                             pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                             pn_top in number,pd_Fecpro in date,pn_mto in number,
                             pn_ord in number) return varchar2 is




ld_fecini date;

ln_mtopag number(17,2) ;
ln_mto11 number(17,2) ;
ln_mto12 number(17,2) ;
ln_mto13 number(17,2) ;
ln_mto14 number(17,2) ;
ln_mto15 number(17,2) ;
lc_ind varchar2(1);


begin

     ld_fecini := to_date('01'||to_char(pd_fecpro,'mmyyyy'),'ddmmyyyy');



     begin

         begin
           select sum(a.pp1imp11),
                  sum(a.pp1imp12),
                  sum(a.pp1imp13),
                  sum(a.pp1imp14),
                  sum(a.pp1imp15)
             into ln_mto11,
                  ln_mto12,
                  ln_mto13,
                  ln_mto14,
                  ln_mto15
             from fsd612 a,fsd602 b
            where a.pgcod  = pn_emp
              and a.ppmod  = pn_mod
              and a.ppsuc  = pn_suc
              and a.ppmda  = pn_mda
              and a.pppap  = pn_pap
              and a.ppcta  = pn_cta
              and a.ppoper = pn_ope
              and a.ppsbop = pn_sbo
              and a.pptope = pn_top
              and a.pgcod  = b.pgcod
              and a.ppmod  = b.ppmod
              and a.ppsuc  = b.ppsuc
              and a.ppmda  = b.ppmda
              and a.pppap  = b.pppap
              and a.ppcta  = b.ppcta
              and a.ppoper = b.ppoper
              and a.ppsbop = b.ppsbop
              and a.pptope = b.pptope
              and a.ppfpag = b.ppfpag
              and a.pp1nump = b.pp1nump
              and b.d602co = 'S'
              and a.ppfpag between ld_fecini and pd_fecpro;
           exception
             when others then null;
           end;
           if pn_ord <> 0 then
               case
                  when pn_ord = 1 then
                    ln_mtopag := ln_mto11;
                  when pn_ord = 2 then
                    ln_mtopag := ln_mto12;
                  when pn_ord = 3 then
                    ln_mtopag := ln_mto13;
                  when pn_ord = 4 then
                    ln_mtopag := ln_mto14;
                  when pn_ord = 5 then
                    ln_mtopag := ln_mto15;
                end case;
            end if;

            if ln_mtopag = pn_mto then
               lc_ind := 'P';
               else
                      lc_ind := 'C';
            end if;

     end;
     return lc_ind;
end Fn_montoPag_calendario;

Procedure Sp_Primera_Cuota(pn_emp in number,pn_mod in number,pn_suc in number,
                          pn_mda in number,pn_pap in number,pn_cta in number,
                          pn_ope in number,pn_sbo in number,pn_top in number,
                          pd_fecpro in date,pd_fec out date) is

begin
  begin
      select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
      into pd_fec
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_ope
       and n.ppsbop = pn_sbo
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0;
  exception
       when too_many_rows then
            begin
                  select /*+ parallel(n,2,1)*/
                       min(n.ppfpag)
                  into pd_fec
                  from fsd601 n
                 where n.pgcod  = pn_emp
                   and n.ppcta  = pn_cta
                   and n.ppmda  = pn_mda
                   and n.ppsuc  = pn_suc
                   and n.pppap  = pn_pap
                   and n.ppoper = pn_ope
                   and n.ppsbop = pn_sbo
                   and n.pptope = pn_top
                   and n.ppmod  = pn_mod
                   and n.d601co = 'S'
                   and (n.ppcap+n.ppint)<>0
                   and rownum = 1;
              exception
                   when others then null;

              end;
         when others then null;
  end;



end Sp_Primera_Cuota;

end PQ_CR_TRAMADES;
/

