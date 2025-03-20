create or replace package "PQ_CR_TRAMDESGRA" is

  --------------------------------------------------

-- Autor   : Silvia MArquez
-- Fecha   : 27/02/2020
-- Proyecto; cuadratura de cuentas de DESGRAVAMEN
-- Modifica: Silvia Marquez
-- Modificacion: Adicion de validaciones para el montoprima a pagar
-- Fecha : 18/06/2020
-- Fecha : 20/10/2020
-- Modificacion: SP_CARGA para evitar duplicados
-- Fecha : 26/10/2020
-- Fecha : 09/11/2020 adicion de septiembre
-- Modificacion : Adición de Octubre, cambio Valida_tasa-- adicion de tabla jaqz085tram
-- Fecha : 03/12/2020
-- Modificacion :Cambio tabla operadores por estructura JAQZ085tram
--               Cambio de Proceso para hallar la tasa
-- Fecha : 06/01/2021
-- Modificacion : de las primas segun correccion BI
-- fecha :31/01/2021
-- Modificacion : Cambio de tabla USRREPBI.REP_TOT_REPRO_2020 por Aqpa833
-- fecha :05/03/2021
-- Autor cambio : Silvia Marquez
-- fecha :16/05/2022
-- Modificacion : Ajuste para reportar monto correcto que se transfiere al gasto por reprogramaciones
-- Autor cambio : Silvia Marquez
-- fecha :17/08/2022
-- Modificacion : Se elimina el proceso que realizaba el pago mes a mes de los creditos reprogramandos
-- Autor cambio : Silvia Marquez
-- fecha :25/10/2022
-- Modificacion : MODIFICA EL PROCESO DE COBROS
-- Autor cambio : Silvia Marquez
-- fecha :24/10/2023
-- Modificacion : OPTIMIZACION DE REPORTES DE DESEMBOLSOS
-- Autor cambio : Silvia Marquez
-- fecha :07/12/2023
-- Modificacion : validacion de too many rows en lina 6758
-- Modificacion : SMARQUEZ 11/09/2024 Optimizacion proceso de tramas desgravamen
-- Modificacion : SMARQUEZ 03/10/2024 Cambio Proceso DESEMBOLSO
--------------------------------------------------
  Procedure Sp_carga(pd_fecpro in date);
  procedure sp_cr_cargaII_job1(pd_fecpro IN date);
  Procedure Sp_carga_II(P_C_DIGITO in varchar2, pd_fecpro in date);
  Procedure Sp_dataFSH012(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fecpro in date,
                          pn_sca    out number,
                          pn_gpo    out number);
  Function Fn_montoAprobado(pn_ins in number) return number;
  procedure sp_cr_cargaII_job(pd_fecini in date, pd_fecfin in date);
  Procedure Sp_Carga_Desem(P_C_DIGITO in varchar2,
                           pd_fecini  in date,
                           pd_fecfin  in date);
  Procedure Sp_dataFSH012_pag(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pd_pago   in date,
                              pn_sca    out number,
                              pn_gpo    out number);
  FUNCTION fn_MONTO_PRIMA_CUO(pa_pgcod  number,
                              pa_ppmod  number,
                              pa_ppsuc  number,
                              pa_ppmda  number,
                              pa_pppap  number,
                              pa_ppcta  number,
                              pa_ppoper number,
                              pa_ppsbop number,
                              pa_pptope number) return number;
  function fn_dias_gracia(pn_emp  in number,
                          pn_mod  in number,
                          pn_suc  in number,
                          pn_mda  in number,
                          pn_pap  in number,
                          pn_cta  in number,
                          pn_oper in number,
                          pn_sbop in number,
                          pn_top  in number) return number;
  Procedure Sp_monto_calendario(pn_emp      in number,
                                pn_mod      in number,
                                pn_suc      in number,
                                pn_mda      in number,
                                pn_pap      in number,
                                pn_cta      in number,
                                pn_ope      in number,
                                pn_sbo      in number,
                                pn_top      in number,
                                pn_tip      in number,
                                pd_fecpro   in date,
                                ln_mtoprima out number,
                                lc_tip      out varchar2);
  Function Fn_scap_calendario(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pd_fpago  in date) return number;
  Function Fn_tipoSBS(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number) return number;

  procedure sp_tipoSBS(pn_emp  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number,
                       ln_grup out number);

  Function fn_prima_calculada(pn_mda in number,
                              pn_mto in number,
                              pn_tas in number,
                              pn_emp in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number;
  Function Fn_montoDes(pn_emp    in number,
                       pn_mod    in number,
                       pn_suc    in number,
                       pn_mda    in number,
                       pn_pap    in number,
                       pn_cta    in number,
                       pn_ope    in number,
                       pn_sbo    in number,
                       pn_top    in number,
                       pd_fecpro in date) return number;
  Procedure Sp_Cuota_Vencer(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pd_fec    out date);
  Function Fn_tipoSBS_2(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number) return char;
  procedure sp_tipoSBS_2(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         lc_tip out char);
  Procedure Sp_TipPago(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec in date);
  Function Fn_tipoSBS_Des(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number;

  Function Fn_montoPag_calendario(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_ope    in number,
                                  pn_sbo    in number,
                                  pn_top    in number,
                                  pd_Fecpro in date,
                                  pn_mto    in number,
                                  pn_ord    in number) return varchar2;

  Procedure Sp_Primera_Cuota(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pd_fec    out date);

  Function Fn_cr_estado(pn_emp    in number,
                        pn_mod    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fecpro in date) return char;

  Function Fn_cr_SegPlus(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number) return number;
  Function fn_dias_atraso( v_Pgfape in date, --fecha de proceso
                           v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                         --  v_Scstat in number,
                           v_fecven in date) return number;

 Procedure sp_LOGS ( v_Pgfape in date) ;
 Procedure valida_Tasa (v_Pgcod  in number,
                        v_Scmod  in number,
                        v_Scsuc  in number,
                        v_Scmda  in number,
                        v_Scpap  in number,
                        v_Sccta  in number,
                        v_Scoper in number,
                        v_Scsbop in number,
                        v_Sctope in number,
                        v_segcod in number,
                        v_mtoapr in number,
                        v_tasa   in number,
                        v_mtodes in number,
                        v_plan   in CHAR,
                        v_fecha  in date,
                        v_desem  in date,
                        v_fpago  in date,          
                        tasa     out number);


 Procedure sp_LOGS_2(v_Pgfape in date) ;
 Procedure ReprogramacionCovid(v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecha  in date,
                              v_instancia in number,
                              v_dato out varchar2,
                              lc_ajuste out varchar2);-- return char;

 Procedure Actualiza_ln_mtoCalen(v_Pgcod  in number,
                                 v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number,
                                 v_tipo   in varchar2,
                                 v_monto  in number,
                                 v_fecha  in date,
                                 v_cuotauno in date,
                                 ln_mtoCalen out number,
                                 v_fproxpag  out date,
                                 ln_montoNew out number);
function Actualiza_MontoCalen(v_Pgcod  in number,
                                 v_Scmod  in number,
                                 v_Scsuc  in number,
                                 v_Scmda  in number,
                                 v_Scpap  in number,
                                 v_Sccta  in number,
                                 v_Scoper in number,
                                 v_Scsbop in number,
                                 v_Sctope in number,
                                 v_tipo   in varchar2,
                                 v_monto  in number,
                                 v_fecha  in date) return number;
procedure Valida_Adicionales(v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             v_fecha  in date,
                             v_instancia in number,
                             v_seguro in number,
                             v_tipago in varchar2,
                             v_mtoSA  in number,
                             v_tasa   in number,
                             v_fecpag in date,
                             v_mtompa in number,
                             v_mtomca in number,
                             v_fproxpag in date,
                             v_vencido out varchar2,
                             v_reprog  out varchar2,
                             v_modo    out varchar2,
                             v_situa   out varchar2,
                             v_proceso out varchar2,
                             v_mtosol  out number,
                             v_pagoprima out number,
                             v_registro out char,
                             v_monto17  out number,
                             v_flag22   out number);-- return char;

 procedure Limpia_trama ;

 Procedure Reprogramacion2022(v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecha  in date,
                              v_seguro in number, --v_instancia in number,
                              v_fechapago in date, -- sma 070723
                              v_tipago in varchar2,
                              v_montomca in number,
                              v_salcap in out number,
                              v_tasa   in number,
                              v_fvencer in date,
                              v_TipoRepro out varchar2,
                              v_Cartera   out varchar2,
                              v_Declarar  out varchar2,
                              v_flagrepro out varchar2,
                              v_frepro_uno out date,
                              v_fecha_repro out date,-- sma 070723
                              v_situa     out varchar2,
                              v_proceso   out varchar2,
                              v_monto17  out number,
                              v_flagau8 out number);-- return char;

  Procedure Valida_Repro(v_Pgcod  in number,
                          v_Scmod  in number,
                          v_Scsuc  in number,
                          v_Scmda  in number,
                          v_Scpap  in number,
                          v_Sccta  in number,
                          v_Scoper in number,
                          v_Scsbop in number,
                          v_Sctope in number,
                          v_fecha  in date,
                          V_flag   out varchar2,
                          v_fechaPagoUno out date
                          );-- return char;
  -- nuevo proceso optimizado para la paralelización  de  proceso de cuentas
  Procedure Sp_carga_III(pn_desde in number,
                         pn_hasta in number,
                         pd_fecpro in date);

  Procedure Sp_Carga_Desem_I(pn_desde in number,
                             pn_hasta in number,
                             pd_fecini  in date,
                             pd_fecfin  in date);

end PQ_CR_TRAMDESGRA;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_TRAMDESGRA" is
--------------------------------------------------
-- Proyecto; cuadratura de cuentas de DESGRAVAMEN
-- Autor   : Silvia MArquez
-- Fecha   : 27/02/2020
-- Modifica: Silvia Marquez
-- Modificacion: Adicion de validaciones para el montoprima a pagar
-- Fecha : 18/06/2020
-- Fecha : 20/10/2020
-- Modificacion: SP_CARGA para evitar duplicados
-- Fecha : 26/10/2020
-- Fecha : 09/11/2020 adicion de septiembre
-- Modificacion : Adición de Octubre, cambio Valida_tasa-- adicion de tabla jaqz085tram
-- Fecha : 03/12/2020
-- Modificacion :Cambio tabla operadores por estructura JAQZ085tram
--               Cambio de Proceso para hallar la tasa
-- Fecha : 06/01/2021
-- Modificacion : de las primas segun correccion BI
-- fecha :31/01/2021
-- Modificacion : Cambio de tabla USRREPBI.REP_TOT_REPRO_2020 por Aqpa833
-- fecha :05/03/2021
-- Autor cambio : Silvia Marquez
-- fecha :16/05/2022
-- Modificacion : Ajuste para reportar monto correcto que se transfiere al gasto por reprogramaciones
-- Autor cambio : Silvia Marquez
-- fecha :17/08/2022
-- Modificacion : Se elimina el proceso que realizaba el pago mes a mes de los creditos reprogramandos
-- Autor cambio : Silvia Marquez
-- fecha :25/10/2022
-- Modificacion : MODIFICA EL PROCESO DE COBROS
-- Autor cambio : Silvia Marquez
-- fecha :24/10/2023
-- Modificacion : OPTIMIZACION DE REPORTES DE DESEMBOLSOS
-- Autor cambio : Silvia Marquez
-- fecha :07/12/2023
-- Modificacion : validacion de too many rows en lina 6758
-- Modificacion : SMARQUEZ 11/09/2024 Optimizacion proceso de tramas desgravamen
-- Modificacion : SMARQUEZ 03/10/2024 Cambio Proceso DESEMBOLSO
-- Modificacion : SMARQUEZ 10/12/2024 nuevas condiciones en las tasas
---------------------------------------------------------------------------------
  Procedure Sp_carga(pd_fecpro in date) is

    ld_fecini date;
  begin

    Execute immediate ('truncate table jaqz085_aux');
    Execute immediate ('truncate table jaqz085');
    Execute immediate ('truncate table jaqz097_error');

    ld_fecini := TRUNC(pd_fecpro, 'MM'); --mod@abr 20181107

    begin
      insert into jaqz085_aux
        (JAQZ085EMP,
         JAQZ085MOD,
         JAQZ085SUC,
         JAQZ085MDA,
         JAQZ085PAP,
         JAQZ085CTA,
         JAQZ085OPE,
         JAQZ085SBO,
         JAQZ085TOP,
         JAQZ085FEC,
         JAQZ085MPA,
         JAQZ085Fval,-- SMA 20170922
         jaqz085seg, -- SMA 20191111
         jaqz085aux3)-- SMA 20200227

        select distinct a.jaql986emp,
                        a.jaql986mod,
                        a.jaql986suc,
                        a.jaql986mda,
                        a.jaql986pap,
                        a.jaql986cta,
                        a.jaql986ope,
                        a.jaql986sbo,
                        a.jaql986top,
                        a.jaql986fec,
                        a.jaql986imp mto_pago, --sum(a.jaql986imp) mto_pago, SMA
                        a.jaql986fpa,
                        a.jaql986seg, -- SMA 20191111
                        a.jaql986tip -- SMA 20200227
          from JAQL986 a
         where a.JAQL986EMP = 1
           and a.jaql986fec = pd_fecpro
           and a.JAQL986CIA in (723189,723198)
           and a.JAQL986TSE =5
           AND A.JAQL986SEG IN (SELECT SGCOD FROM FST300 WHERE SGSN02 =5)
-----------and a.jaql986cta  = 1600999--- solo pruebas
           and a.jaql986fpa between ld_fecini and pd_fecpro
        union
        select a.jaql986emp,
               a.jaql986mod,
               a.jaql986suc,
               a.jaql986mda,
               a.jaql986pap,
               a.jaql986cta,
               a.jaql986ope,
               a.jaql986sbo,
               a.jaql986top,
               a.jaql986fec,
               a.jaql986imp mto_pago,  --sum(a.jaql986imp) mto_pago, SMA
               a.jaql986fpa,
               a.jaql986seg, -- SMA 20191111
               a.jaql986tip -- SMA 20200227
          from JAQL986 a
         where a.JAQL986EMP = 1
           and a.JAQL986CIA in (723189,723198)
           and a.JAQL986TSE = 5
           AND A.JAQL986SEG IN (SELECT SGCOD FROM FST300 WHERE SGSN02 =5 )
           and a.jaql986fpa between ld_fecini and pd_fecpro
           and a.jaql986au7 <> '01/01/0001'
---------- and a.jaql986cta = 1600999-- solo pruebas
           and not exists (select 1 ---26/10/2020
                             from jaql986 b
                            where b.jaql986emp = a.jaql986emp
                              and b.jaql986cia = a.jaql986cia
                              and b.jaql986tse = a.jaql986tse
                              and b.jaql986seg = a.jaql986seg
                              and b.jaql986mod = a.jaql986mod
                              and b.jaql986suc = a.jaql986suc
                              and b.jaql986mda = a.jaql986mda
                              and b.jaql986pap = a.jaql986pap
                              and b.jaql986cta = a.jaql986cta
                              and b.jaql986ope = a.jaql986ope
                              and b.jaql986sbo = a.jaql986sbo
                              and b.jaql986top = a.jaql986top
                              and b.jaql986fpa = a.jaql986fpa
                              and b.jaql986tip = a.jaql986tip
                          );
      commit;
    end;

  end Sp_carga;

  procedure sp_cr_cargaII_job1(pd_fecpro IN date) is

  /*  cursor c_clientes_job is
      select to_char(substr(trim(j.jaqz085cta), -1, 1)) digito
        from jaqz085_aux j
       group by to_char(substr(trim(j.jaqz085cta), -1, 1));*/

    cursor c_clientes_job is
      select * from fst198
       where tp1cod = 1 and tp1cod1 = 10884
         and tp1corr1 = 80
       ORDER BY TP1CORR3;

    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_cont     number(3) := 0;
    ln_inst     number(1) := 1;

    lc_hostname varchar2(64);
    ln_limit      number(3) := 20;
    ln_numjob     number(5);
    running_jobs  number:=0 ;
  BEGIN


    --Obtener hostname
    begin
      select host_name into lc_hostname from v$instance;
    end;
    -- Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10884
         and tp1corr1 = 83
         and tp1corr2 = 0
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    --------------------------
    
    for job in c_clientes_job loop
     ln_cont     := ln_cont + 1;
    
       LOOP
            SELECT COUNT(*)
            INTO running_jobs           
            FROM dba_jobs
            where  what like '%PQ_cR_TRAMDESGRA%';
                
            EXIT WHEN running_jobs < ln_limit;-- max_concurrent;
            DBMS_LOCK.SLEEP(2); -- Pausa de 1 segundo antes de volver a comprobar
        END LOOP;
    
      lc_variable := ' begin ' || ' PQ_cR_TRAMDESGRA.Sp_carga_III(''' ||
                     job.tp1nro1 || ''',''' || job.tp1nro2 || ''',''' || pd_fecpro|| ''');' ||
                     ' End; ';


        
        ln_job := ln_job + 1;

        IF SYS.FN_BD_ISRAC='TRUE' THEN
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 1,
                          --instance  => 2, --ln_inst,--instance => 1,--Solo por hoy 01.07.2015 hmev new01/01/2024
                          force     => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
        commit;
     
    end loop;


  end sp_cr_cargaII_job1;

  Procedure Sp_carga_II(P_C_DIGITO in varchar2, pd_fecpro in date) is

   cursor creditos is
    select a.*,b.pp001aux2 -- sma 15/04/2020 verificamos que  los seguros existan
        from jaqz085_aux a,
             fpp001 b
       where b.pgcod = a.jaqz085emp
         and b.aomod = a.jaqz085mod
         and b.aosuc = a.jaqz085suc
         and b.aomda = a.jaqz085mda
         and b.aopap = a.jaqz085pap
         and b.aocta = a.jaqz085cta
         and b.aooper = a.jaqz085ope
         and b.aosbop = a.jaqz085sbo
         and b.aotope = a.jaqz085top
         and b.sgcod  = a.jaqz085seg
         and to_char(substr(trim(a.jaqZ085cta), -1, 1)) = P_C_DIGITO
         ;

    cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';

    ln_numpol    number(10);
    ld_fecvini   date;
    ld_fecvfin   date;
    ln_tasa      number(17, 6);
    ln_monto     number(17, 6);
  --  ln_salcap    number(17, 2);
    ln_grupo     number(2);
    lc_plan      char(30);
    ln_instancia number(10);
    ln_mtoapr    number(17, 2):= 0;
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    lc_petipo    char(1);
    lc_apepat    char(30);
    lc_apemat    char(30);
    lc_nombre    char(50);
    lc_razsoc    char(70);
    lc_sexo      char(1);
    ld_fecnac    date;
    ln_paij      number(3);
    ln_tdoj      number(2);
    lc_ndoj      char(12);
    ld_fecant    date;
    lc_numcre    char(25);
    ln_aoimp     number(17, 2);
    ln_sucAct    number(3);

    ln_mtoCalen   number(17, 2);
    ln_salcal     number(17, 2);
    ld_Fec        date;
    lc_tip        char(1);
    ln_periodo    number(5);
    ln_estado     number(2);
    ln_gracia     number(1);
    ld_primcuo    date;
    ln_parcial    number;
    ln_montoPar   number;
    ln_montoxtasa number;
    lc_flgJud     char(1) := 'N';
    lc_telefono   char(100);
    lc_correo     char(100);
    ln_cont       number := 0;
    ln_cont1      number := 0;
    ln_diasAtraso number:= 0;
    lc_hora       char(8);
    TipoRepro     char(2);

    ln_mtoCalen1 number(17,2);
    ld_fproxpag  date;
    lc_ajuste    varchar2(20);
    lc_vencido   varchar2(20);
    lc_reprog    varchar2(20);
    lc_modo      varchar2(20);
    lc_situa     varchar2(20);
    lc_proceso   varchar2(20);
    lc_mtosol    number (17,2):=0;
    ln_montomca  number (17,2):=0;
    ln_pagoprima number (17,2):=0;
    lc_registra  char(1);
    ln_monto17   number  (17,2):=0;
    ln_Tasa1     number(17,6):=0;
    ld_fecpago   date;
    ln_prima     number(17,2):=0;
    ln_flag22    number:=0;

    lc_TipoRepro varchar2(20);
    lc_Cartera   varchar2(20);
    lc_Declarar  varchar2(20);
    lc_flagRepro varchar2(1);
    ld_frep_uno  date;
    v_desembolso varchar2(20);
    fechainicial date;
    ln_aux8     number;

    montoSolidario number(17,2);
    importe80 number(17,2);
    ln_monto15 number(17,2);

    ld_fecha_repro date;
    ln_mtodes number(17,2);
  begin
    begin

      --ld_fecant := last_day(add_months(pd_fecpro,-1));
      for i in creditos loop
        lc_tip    := null;
        ln_grupo  := null;
        lc_plan   := null;
        ln_gracia := 0;
        ld_fecpago := i.jaqz085fval;
        ln_prima  := i.jaqz085mpa;
        ln_pagoprima := i.jaqz085mpa;
        --mod@abr 20181107
        lc_flgJud := Pq_Cr_Tramdesgra.Fn_cr_estado(pn_emp    => i.jaqz085emp,
                                                   pn_mod    => i.JAQZ085MOD,
                                                   pn_mda    => i.jaqz085mda,
                                                   pn_pap    => i.jaqz085pap,
                                                   pn_cta    => i.jaqz085cta,
                                                   pn_ope    => i.jaqz085ope,
                                                   pn_sbo    => i.jaqz085sbo,
                                                   pn_top    => i.jaqz085top,
                                                   pd_fecpro => pd_fecpro);
        if lc_flgJud = 'N' then
          --instancia
          ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                               i.JAQZ085SUC,
                                               i.JAQZ085MDA,
                                               i.JAQZ085PAP,
                                               i.JAQZ085CTA,
                                               i.JAQZ085OPE,
                                               i.JAQZ085SBO,
                                               i.JAQZ085TOP);
          if nvl(ln_instancia, 0) = 0 then
            begin
              select a.aosuc
                into ln_sucAct
                from fsd010 a
               where a.pgcod = i.JAQZ085EMP
                 and a.aomod = i.JAQZ085MOD
                 and a.aomda = i.JAQZ085MDA
                 and a.aopap = i.JAQZ085PAP
                 and a.aocta = i.JAQZ085CTA
                 and a.aooper = i.JAQZ085OPE
                 and a.aosbop = i.JAQZ085SBO
                 and a.aotope = i.JAQZ085TOP;
            exception
              when others then
                null;
            end;
            ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                                 ln_sucAct,
                                                 i.JAQZ085MDA,
                                                 i.JAQZ085PAP,
                                                 i.JAQZ085CTA,
                                                 i.JAQZ085OPE,
                                                 i.JAQZ085SBO,
                                                 i.JAQZ085TOP);

          else
            ln_sucAct := i.JAQZ085SUC;
          end if;

          --fecha de desembolso,monto desembolsado,periodo
          begin
            select aofval, aoimp, aoperiod, aostat
              into ld_fecant, ln_aoimp, ln_periodo, ln_estado
              from fsd010 a
             where a.pgcod = i.JAQZ085EMP
               and a.aomod = i.JAQZ085MOD
               and a.aosuc = ln_sucAct --i.JAQZ085SUC
               and a.aomda = i.JAQZ085MDA
               and a.aopap = i.JAQZ085PAP
               and a.aocta = i.JAQZ085CTA
               and a.aooper = i.JAQZ085OPE
               and a.aosbop = i.JAQZ085SBO
               and a.aotope = i.JAQZ085TOP;

          exception
            when no_data_found then
              begin
                select aofval, aoimp, aoperiod, aostat
                  into ld_fecant, ln_aoimp, ln_periodo, ln_estado
                  from fsd010 a
                 where a.pgcod = i.JAQZ085EMP
                   and a.aomod = i.JAQZ085MOD
                      --and a.aosuc  = i.JAQZ085SUC
                   and a.aomda = i.JAQZ085MDA
                   and a.aopap = i.JAQZ085PAP
                   and a.aocta = i.JAQZ085CTA
                   and a.aooper = i.JAQZ085OPE
                   and a.aosbop = i.JAQZ085SBO
                   and a.aotope = i.JAQZ085TOP;

              exception
                when no_data_found then
                  ld_fecant  := null;
                  ln_aoimp   := null;
                  ln_periodo := null;
                  ln_estado  := null;
              end;

          end;

          -- Numero de poliza
          if i.jaqz085mda = 0 then
            ln_numpol := 235901;
          else
            ln_numpol := 235899;
          end if;
          --fecha de vigencia inicial
          ld_fecvini :=  TRUNC(pd_fecpro,'MM');

          --fecha de vigencia final
          ld_fecvfin := pd_fecpro; --i.jaqz085fec;

          --monto de la prima
          ln_monto := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.JAQZ085EMP,
                                                              i.JAQZ085MOD,
                                                              ln_sucAct,
                                                              i.JAQZ085MDA,
                                                              i.JAQZ085PAP,
                                                              i.JAQZ085CTA,
                                                              i.JAQZ085OPE,
                                                              i.JAQZ085SBO,
                                                              i.JAQZ085TOP);
          --saldo capital y grupo

          --grupo
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.JAQZ085EMP,
                                                  i.JAQZ085MOD,
                                                  ln_sucAct,
                                                  i.JAQZ085MDA,
                                                  i.JAQZ085PAP,
                                                  i.JAQZ085CTA,
                                                  i.JAQZ085OPE,
                                                  i.JAQZ085SBO,
                                                  i.JAQZ085TOP);
          --monto calendario de pago
          pq_cr_tramdesgra.Sp_monto_calendario(i.JAQZ085EMP,
                                               i.JAQZ085MOD,
                                               ln_sucAct,
                                               i.JAQZ085MDA,
                                               i.JAQZ085PAP,
                                               i.JAQZ085CTA,
                                               i.JAQZ085OPE,
                                               i.JAQZ085SBO,
                                               i.JAQZ085TOP,
                                               2,
                                               i.jaqz085fval, --pd_fecpro, fecha pago
                                               ln_mtoCalen,
                                               lc_tip);
          ln_montomca := ln_mtoCalen;--18/06/2020 SMA
          --saldo capital calendario de pagos
          ln_salcal := pq_cr_tramdesgra.Fn_scap_calendario(i.JAQZ085EMP,
                                                           i.JAQZ085MOD,
                                                           ln_sucAct,
                                                           i.JAQZ085MDA,
                                                           i.JAQZ085PAP,
                                                           i.JAQZ085CTA,
                                                           i.JAQZ085OPE,
                                                           i.JAQZ085SBO,
                                                           i.JAQZ085TOP,
                                                           pd_fecpro,
                                                           i.jaqz085fval);

          --tipo SBS RCC si es nulo

          if ln_grupo is null then
            ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz085EMP,
                                                        i.jaqz085MOD,
                                                        ln_sucAct,
                                                        i.jaqz085MDA,
                                                        i.jaqz085PAP,
                                                        i.jaqz085CTA,
                                                        i.jaqz085OPE,
                                                        i.jaqz085SBO,
                                                        i.jaqz085TOP);
          end if;

          --plan
          case
            when ln_grupo in (2, 12, 13) then
              lc_plan := 'PYME';
            when ln_grupo = 3 then
              lc_plan := 'CONSUMO';
            when ln_grupo = 4 then
              lc_plan := 'HIPOTECARIO';
            else
              null;
          end case;

          --monto aprobado
          ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);

          ---verificar si es desembolso parcial sma04/10/2018
          begin
            select 1, sum(sng017mto)
              into ln_parcial, ln_montopar
              from sng001
             Where SNG001Inst = ln_instancia
               and sng001ori = 7;
          exception
            when no_data_found then
              ln_parcial := 0;
          end;
          if ln_parcial = 1 and
             ((ln_montopar is not null) and ln_montopar <> 0) then
            ln_montoxtasa := ln_montopar;
          else
            if ln_mtoapr <> 0 or ln_mtoapr is not null then
               ln_montoxtasa := ln_mtoapr;
            ELSE
              ln_mtoapr := ln_aoimp;
               ln_montoxtasa := ln_mtoapr;
            END IF;
          end if;
          --tasa

          ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.JAQZ085EMP,
                                                                  i.JAQZ085MOD,
                                                                  ln_sucAct,
                                                                  i.JAQZ085MDA,
                                                                  i.JAQZ085PAP,
                                                                  i.JAQZ085CTA,
                                                                  i.JAQZ085OPE,
                                                                  i.JAQZ085SBO,
                                                                  i.JAQZ085TOP,
                                                                  ln_montoxtasa);

            ln_Tasa1 := ln_tasa;
          --numero de credito
          lc_numcre := to_char(LPAD(i.JAQZ085CTA, 9, '0') ||
                               LPAD(i.JAQZ085OPE, 9, '0') ||
                               LPAD(i.JAQZ085SBO, 3, '0'));

          --datos persona
          begin
            select a.pepais, a.petdoc, a.pendoc
              into ln_pai, ln_tdo, lc_ndo
              from fsr008 a
             where a.ctnro = i.jaqz085cta
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
              lc_petipo := null;
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
            select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

          --if lc_petipo <> 'F' then

          --end if;

          begin
            select a.pfpai1, a.pftdo1, a.pfndo1
              into ln_paij, ln_tdoj, lc_ndoj
              from fsr003 a
             where a.pjpais = ln_pai
               and a.pjtdoc = ln_tdo
               and a.pjndoc = lc_ndo;
          exception
            when too_many_rows then
              begin
                select a.pfpai1, a.pftdo1, a.pfndo1
                  into ln_paij, ln_tdoj, lc_ndoj
                  from fsr003 a
                 where a.pjpais = ln_pai
                   and a.pjtdoc = ln_tdo
                   and a.pjndoc = lc_ndo
                   and a.vicod <> 1
                   and rownum = 1;
              exception
                when no_data_found then
                  null;

              end;
            when no_data_found then
              null;
          end;
          --fecha de nacimiento
          if lc_petipo = 'F' then
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
              select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

          end if;
          -- telefono y correo smarquez 17102019
          lc_telefono := null;
          lc_correo := null;
          For t in telefono(ln_pai,ln_tdo,lc_ndo)loop
            if ln_cont = 0 then
              lc_telefono := trim(t.fono);
            else
              lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
            end if;
             ln_cont := ln_cont + 1;
          end loop;

           For c in correo(ln_pai,ln_tdo,lc_ndo)loop
            if ln_cont1 = 0 then
              lc_correo := trim(c.mail);
            else
              lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
            end if;
             ln_cont1 := ln_cont1 + 1;
          end loop;
          --fecha de la cuota por vencer
          ld_Fec := null;
          pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz085EMP,
                                           i.jaqz085MOD,
                                           ln_sucAct,
                                           i.jaqz085MDA,
                                           i.jaqz085PAP,
                                           i.jaqz085CTA,
                                           i.jaqz085OPE,
                                           i.jaqz085SBO,
                                           i.jaqz085TOP,
                                           pd_fecpro,
                                           ld_Fec);
          --dias de gracia

          ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.jaqz085EMP,
                                                       i.jaqz085MOD,
                                                       ln_sucAct,
                                                       i.jaqz085MDA,
                                                       i.jaqz085PAP,
                                                       i.jaqz085CTA,
                                                       i.jaqz085OPE,
                                                       i.jaqz085SBO,
                                                       i.jaqz085TOP);
          --fecha de la primera cuota
          ld_primcuo := null;
          pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz085EMP,
                                            i.jaqz085MOD,
                                            ln_sucAct,
                                            i.jaqz085MDA,
                                            i.jaqz085PAP,
                                            i.jaqz085CTA,
                                            i.jaqz085OPE,
                                            i.jaqz085SBO,
                                            i.jaqz085TOP,
                                            pd_fecpro,
                                            ld_primcuo);

         ln_diasAtraso := pq_cr_tramdesgra.fn_dias_atraso(pd_fecpro,
                                                       i.jaqz085EMP,
                                                       i.jaqz085MOD,
                                                       ln_sucAct,
                                                       i.jaqz085MDA,
                                                       i.jaqz085PAP,
                                                       i.jaqz085CTA,
                                                       i.jaqz085OPE,
                                                       i.jaqz085SBO,
                                                       i.jaqz085TOP,
                                                     --  ln_estado,
                                                       ld_Fec);
        --- if ln_tasa = 0 then

            pq_cr_tramdesgra.valida_tasa(i.jaqz085EMP,
                                         i.jaqz085MOD,
                                         ln_sucAct,
                                         i.jaqz085MDA,
                                         i.jaqz085PAP,
                                         i.jaqz085CTA,
                                         i.jaqz085OPE,
                                         i.jaqz085SBO,
                                         i.jaqz085TOP,
                                         i.jaqz085seg,
                                         ln_mtoapr, --ln_prima
                                         ln_Tasa1,
                                         ln_mtodes,
                                         lc_plan,
                                         pd_fecpro,
                                         ld_fecant, ---sma 28122020
                                         i.jaqz085fval,--ld_fecpago,
                                         ln_tasa);
       --  end if;
       --  if pd_fecpro > to_date('01/03/2020') then
          lc_TipoRepro := null; -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
          lc_Cartera := null;   --'null' ,'Desembolsado'
          lc_Declarar := null;   --'Declarar', 'No Declarar'
          lc_flagRepro := null;
          ld_frep_uno := null;
          ld_fecha_repro:= null;
          lc_situa := null;
          lc_proceso := null;
          ln_monto17 := 0;
          ln_aux8 := 0;

          Reprogramacion2022(i.jaqz085EMP,
                               i.jaqz085MOD,
                               ln_sucAct,
                               i.jaqz085MDA,
                               i.jaqz085PAP,
                               i.jaqz085CTA,
                               i.jaqz085OPE,
                               i.jaqz085SBO,
                               i.jaqz085TOP,
                               pd_fecpro,
                               i.jaqz085seg,
                               i.jaqz085fval, --sma 07/07/2023
                               lc_tip, --tipo pago 'P' o 'C'
                               ln_mtoCalen,
                               ln_salcal,
                               ln_tasa,
                               ld_Fec,
                               lc_TipoRepro, -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
                               lc_Cartera,   --'null' ,'Desembolsado'
                               lc_Declarar,  --'Declarar', 'No Declarar'
                               lc_flagRepro,
                               ld_frep_uno,
                               ld_fecha_repro, --sma 07/07/2023
                               lc_situa,
                               lc_proceso,
                               ln_monto17,
                               ln_aux8 );


       --  end if;
            ln_mtoCalen1:= 0;
            ld_fproxpag := null;
            fechainicial := TRUNC(pd_fecpro,'MM');

            if ld_fecant >=  fechainicial and ld_fecant <= pd_fecpro then
                -----Verifica Digital---
                Begin
                  Select 'Digital'
                    into v_desembolso
                    from fsh016
                   where pgcod = 1
                     and hcmod = 489
                     and hsucor =907
                     and htran = 951
                     and hfcon = ld_fecant
                     and hcord = 10
                     and hmodul = i.jaqz085mod
                     and htoper = i.jaqz085top
                     and hsucur = i.jaqz085suc
                     and hcta = i.JAQZ085CTA
                     and hoper = i.JAQZ085OPE
                     and hsubop = i.jaqz085sbo;
                     lc_Cartera :='Desembolsado';
                exception
                  when no_data_found then
                    begin
                      Select 'Digital'
                        into v_desembolso
                        from fsh016
                       where pgcod = 1
                         and hcmod = 489
                         and hsucor =907
                         and htran = 360
                         and hfcon = ld_fecant
                         and hcord = 10
                         and hmodul = i.jaqz085mod
                         and htoper = i.jaqz085top
                         and hsucur = i.jaqz085suc
                         and hcta = i.JAQZ085CTA
                         and hoper = i.JAQZ085OPE;
                        -- and hsubop = i.jaqz085sub;
                         lc_Cartera :='Desembolsado';
                    exception
                      when no_data_found then
                        v_desembolso := 'Ventanilla';
                    end;
                end;
          end if;

           --- VALIDACIONES POR REPROGRAMACIONES
          ln_flag22 := 0;

          if  i.jaqz085seg >= 250 and i.jaqz085seg <= 338 then
              lc_ajuste := 'Codigo Anterior';
          else
             if i.jaqz085seg >= 351 and i.jaqz085seg <= 408 then
               lc_ajuste := 'Basico';
             else
               if i.jaqz085seg >= 411 and i.jaqz085seg <= 498 then
                 lc_ajuste := 'Devolucion';
               else
                 lc_ajuste := null;
               end if;
             end if;
           end if;
           BEgin
            montoSolidario := 0;
            importe80 := 0;
            select fpp080au4 , fpp080imp
              into montoSolidario, importe80
              from fpp080
            where FPP080EMP = i.JAQZ085EMP
              and FPP080TSE = 5
              and FPP080SEG = i.jaqz085seg
              and FPP080SUC = i.JAQZ085SUC
              and FPP080MOD = i.JAQZ085MOD
              and FPP080CTA = i.JAQZ085CTA
              and FPP080MDA = i.JAQZ085MDA
              and FPP080PAP = i.JAQZ085PAP
              and FPP080OPE = i.JAQZ085OPE
              and FPP080SBO = i.JAQZ085SBO
              and FPP080TOP = i.JAQZ085TOP
              and FPP080FEC = i.JAQZ085FEC
              and FPP080FPA = i.jaqz085fval
              and fpp080a11 <>'S';
          exception
            when no_data_found then
              montoSolidario := 0;
              importe80 := 0;
            when too_many_rows then
               select fpp080au4 , fpp080imp
              into montoSolidario, importe80
              from fpp080
            where FPP080EMP = i.JAQZ085EMP
              and FPP080TSE = 5
              and FPP080SEG = i.jaqz085seg
              and FPP080SUC = i.JAQZ085SUC
              and FPP080MOD = i.JAQZ085MOD
              and FPP080CTA = i.JAQZ085CTA
              and FPP080MDA = i.JAQZ085MDA
              and FPP080PAP = i.JAQZ085PAP
              and FPP080OPE = i.JAQZ085OPE
              and FPP080SBO = i.JAQZ085SBO
              and FPP080TOP = i.JAQZ085TOP
              and FPP080FEC = i.JAQZ085FEC
              and FPP080FPA = i.jaqz085fval
              and fpp080a11 <>'S'
              and rownum = 1 ;
          end;
          if montoSolidario <> 0 then
            ln_monto15 := montoSolidario;
          else
            ln_monto15 := importe80;
          end if;

              begin
                insert into JAQZ085
                  (JAQZ085EMP,
                   JAQZ085MOD,
                   JAQZ085SUC,
                   JAQZ085MDA,
                   JAQZ085PAP,
                   JAQZ085CTA,
                   JAQZ085OPE,
                   JAQZ085SBO,
                   JAQZ085TOP,
                   JAQZ085FEC,
                   JAQZ085MPA,
                   JAQZ085MAP,
                   JAQZ085FEI,
                   JAQZ085FEF,
                   JAQZ085NUM,
                   JAQZ085TAS,
                   JAQZ085MPR, /*JAQZ085SCA,*/
                   JAQZ085GRU,
                   JAQZ085PLA,
                   JAQZ085PAI,
                   JAQZ085TDO,
                   JAQZ085NDO,
                   JAQZ085TPE,
                   JAQZ085SEX,
                   JAQZ085FNA,
                   JAQZ085APT,
                   JAQZ085APM,
                   JAQZ085NOM,
                   JAQZ085RZO,
                   JAQZ085NUC,
                   JAQZ085IMP,
                   JAQZ085SUA,
                   JAQZ085MCA,
                   JAQZ085SCL,
                   JAQZ085FVE,
                   JAQZ085TIP,
                   JAQZ085PER,
                   JAQZ085EST,
                   JAQZ085FDE,
                   JAQZ085DGA,
                   JAQZ085FPR,
                   JAQZ085TLF,
                   JAQZ085MAIL,
                   jaqz085aux1,
                   jaqz085aux3,
                   jaqz085aux5,
                   jaqz085aux2,
                   jaqz085aux7,
                   jaqz085aux9,
                   jaqz085aux6,
                   jaqz085aux10,
                   jaqz085mail1,
                   jaqz085aux12,
                   jaqz085aux13,
                   jaqz085aux14,
                   jaqz085aux15,
                   jaqz085aux18,
                   jaqz085aux19,
                   jaqz085aux17,
                   jaqz085aux4,
                   jaqz085aux8,
                   jaqz085aux20, -- sma 07/07/23
                   jaqz085aux21 -- sma 07/07/23
                   )
                Values
                  (i.JAQZ085EMP,
                   i.JAQZ085MOD,
                   i.JAQZ085SUC,
                   i.JAQZ085MDA,
                   i.JAQZ085PAP,
                   i.JAQZ085CTA,
                   i.JAQZ085OPE,
                   i.JAQZ085SBO,
                   i.JAQZ085TOP,
                   i.JAQZ085FEC,
                   i.JAQZ085MPA,
                   ln_mtoapr,
                   ld_fecvini,
                   ld_fecvfin,
                   ln_numpol,
                   ln_tasa,
                   ln_monto, /*ln_salcap,*/
                   ln_grupo,
                   lc_plan,
                   ln_pai,
                   ln_tdo,
                   lc_ndo,
                   lc_petipo,
                   lc_sexo,
                   ld_fecnac,
                   lc_apepat,
                   lc_apemat,
                   lc_nombre,
                   lc_razsoc,
                   lc_numcre,
                   ln_aoimp,
                   ln_sucAct,
                   ln_mtoCalen,
                   ln_salcal,
                   ld_Fec,
                   lc_tip,
                   ln_periodo,
                   ln_estado,
                   ld_fecant,
                   ln_gracia,
                   ld_primcuo,
                   lc_telefono,
                   lc_correo,
                   i.jaqz085seg,
                   lc_Cartera,
                   i.jaqz085fval,
                   lc_TipoRepro, -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
                   ln_mtoCalen1,
                   ld_fproxpag,
                   lc_ajuste,
                   v_desembolso,--lc_vencido,
                   lc_reprog,
                   lc_modo,
                   lc_situa,
                   lc_proceso,
                   ln_monto15, --montosolidario,---lc_mtosol,
                   ln_pagoprima,
                   ln_diasAtraso,
                   ln_monto17,
                   lc_declarar,
                   ln_aux8,
                   ld_frep_uno,  --fecha primer pago
                   ld_fecha_repro); -- fecha reprogramacion
              exception
                when dup_val_on_index then
                  null;
              end;
              commit;
          end if;

          Begin
            insert into JAQZ085H
              (JAQZ085HEMP,
               JAQZ085HMOD,
               JAQZ085HSUC,
               JAQZ085HMDA,
               JAQZ085HPAP,
               JAQZ085HCTA,
               JAQZ085HOPE,
               JAQZ085HSBO,
               JAQZ085HTOP,
               JAQZ085HFEC,
               JAQZ085HMPA,
               JAQZ085HMAP,
               JAQZ085HFEI,
               JAQZ085HFEF,
               JAQZ085HNUM,
               JAQZ085HTAS,
               JAQZ085HMPR, /*JAQZ085HSCA,*/
               JAQZ085HGRU,
               JAQZ085HPLA,
               JAQZ085HPAI,
               JAQZ085HTDO,
               JAQZ085HNDO,
               JAQZ085HTPE,
               JAQZ085HSEX,
               JAQZ085HFNA,
               JAQZ085HAPT,
               JAQZ085HAPM,
               JAQZ085HNOM,
               JAQZ085HRZO,
               JAQZ085HNUC,
               JAQZ085HIMP,
               JAQZ085HSUA,
               JAQZ085HMCA,
               JAQZ085HSCL,
               JAQZ085HFVE,
               JAQZ085HTIP,
               JAQZ085HPER,
               JAQZ085HEST,
               JAQZ085HFDE,
               JAQZ085HDGA,
               JAQZ085HFPR,
               JAQZ085HTLF,
               JAQZ085HMAIL,
               jaqz085haux1,
               jaqz085haux3,
               jaqz085haux5,
               jaqz085haux2,
               jaqz085haux7,
               jaqz085haux9,
               jaqz085haux6)
            Values
              (i.JAQZ085EMP,
               i.JAQZ085MOD,
               i.JAQZ085SUC,
               i.JAQZ085MDA,
               i.JAQZ085PAP,
               i.JAQZ085CTA,
               i.JAQZ085OPE,
               i.JAQZ085SBO,
               i.JAQZ085TOP,
               i.JAQZ085FEC,
               i.JAQZ085MPA,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               lc_numcre,
               ln_aoimp,
               ln_sucAct,
               ln_mtoCalen,
               ln_salcal,
               ld_Fec,
               lc_tip,
               ln_periodo,
               ln_estado,
               ld_fecant,
               ln_gracia,
               ld_primcuo,
               lc_telefono,
               lc_correo,
               i.jaqz085seg,
               ln_diasAtraso,
               i.jaqz085fval,
               TipoRepro,
               ln_mtoCalen1,
               ld_fproxpag,
               lc_ajuste);
          exception
            when dup_val_on_index then
              null;
          end;

          commit;

      end loop;

    end;
  end Sp_carga_II;

  Procedure Sp_dataFSH012(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fecpro in date,
                          pn_sca    out number,
                          pn_gpo    out number) is
    ld_fec    date;
    ln_mtoDes number(17, 2);

  begin

    begin
      select /*+index(b FSH01204)*/ b.bcsdmo, b.bcgpo
        into pn_sca, pn_gpo
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
                                 /*or pcnivc in (141, 117)*/
                                 )
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
        select a.aofe99, aoimp
          into ld_fec, ln_mtoDes
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      exception
        when no_data_found then
          ld_fec    := null;
          ln_mtoDes := null;
      end;

      if ld_fec is not null then
        begin
          select /*+index(b FSH01204)*/ b.bcsdmo, b.bcgpo
            into pn_sca, pn_gpo
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
                                     /*or pcnivc in (141, 117)*/
                                     )
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

    ln_mto number(17, 2);
  begin
    begin
      begin
        select case
                 when (C.SNG001ORI = 7 AND A.XWFMODULO = 184) THEN
                  A.XWFMONTO1
                 when (C.SNG001ORI = 7 AND A.XWFMODULO <> 184) THEN
                  A.XWFMONTO1
                 when C.SNG001ORI <> 7 THEN
                  (SELECT Y.XLLOAOIMP
                     FROM XWF700 W, X054007 Y
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
                      AND W.XWFCAR3 = '1')
               end
          into ln_mto
          from XWF700 a, sng001 c
         where a.xwfprcins = c.sng001inst
           and a.xwfprcins = pn_ins
           and rownum = 1;
      exception
        when others then
          ln_mto := null;

      end;
      return ln_mto;
    end;

  end Fn_montoAprobado;

  procedure sp_cr_cargaII_job(pd_fecini in date, pd_fecfin in date) is

    cursor c_clientes_job is
      select to_char(substr(trim(j.jaqz097cta), -1, 1)) digito
        from jaqz097_aux j
       group by to_char(substr(trim(j.jaqz097cta), -1, 1));

    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_cont     number(2) := 0;
    ln_inst     number(1) := 1;
    lc_hostname varchar2(64);
  BEGIN
    --Obtener hostname
    begin
      select host_name into lc_hostname from v$instance;
    end;

    execute immediate ('truncate table jaqz097_aux');
    execute immediate ('truncate table jaqz097');
    begin
      insert into jaqz097_aux
        (JAQZ097EMP,
         JAQZ097MOD,
         JAQZ097SUC,
         JAQZ097MDA,
         JAQZ097PAP,
         JAQZ097CTA,
         JAQZ097OPE,
         JAQZ097SBO,
         JAQZ097TOP,
         JAQZ097FVA,
         JAQZ097EST,
         JAQZ097F99,
         jaqz097imp,
         jaqz097per)

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
          from fsd010 a, FPP001 b
         where a.aofval between pd_fecini and pd_fecfin
           and a.aomod in (select modulo from fst111 where dscod = 50)
           and a.pgcod = b.pgcod
           and a.aomod = b.aomod
           and a.aosuc = b.aosuc
           and a.aomda = b.aomda
           and a.aopap = b.aopap
           and a.aocta = b.aocta
           and a.aooper = b.aooper
           and a.aosbop = b.aosbop
           and a.aotope = b.aotope
           and b.SGCOD in (select tp1imp1
                             from fst198
                            where tp1cod = 1
                              and tp1cod1 = 10898
                              and tp1corr1 = 8);

      commit;

    end;

    for job in c_clientes_job loop
      lc_variable := ' begin ' || ' PQ_cR_TRAMDESGRA.Sp_Carga_Desem(''' ||
                     job.digito || ''',''' || pd_fecini || ''',''' ||
                     pd_fecfin || ''');' || ' End; ';
      ln_cont     := ln_cont + 1;

      if (ln_cont >= 50) then
        ln_inst := 2;
      end if;

      ln_job := ln_job + 1;


     IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1, --ln_inst,
                        --instance  => 2, 01/01/2024
                        --instance => 1,--Solo por hoy 01.07.2015 hmev
                        force => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;

      commit;

    end loop;

  end sp_cr_cargaII_job;

  Procedure Sp_Carga_Desem(P_C_DIGITO in varchar2,
                           pd_fecini  in date,
                           pd_fecfin  in date) is

    cursor creditos is
      select *
        from jaqz097_aux
       where to_char(substr(trim(jaqZ097cta), -1, 1)) = P_C_DIGITO;

    cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';

    ln_numpol    number(10);
    ld_fecvini   date;
    ld_fecvfin   date;
    ln_tasa      number(17, 6);
    ln_monto     number(17, 6);
    ln_monto_tot number(17, 6);
    --ln_salcap    number(17, 2);
    ln_grupo     number(2);
    lc_plan      char(30);
    ln_instancia number(10);
    ln_mtoapr    number(17, 2);
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    lc_petipo    char(1);
    lc_apepat    char(30);
    lc_apemat    char(30);
    lc_nombre    char(50);
    lc_razsoc    char(70);
    lc_sexo      char(1);
    ld_fecnac    date;
    ln_paij      number(3);
    ln_tdoj      number(2);
    lc_ndoj      char(12);
    lc_numcre    number(25);
    ln_gracia    number(1);

    ln_mtoCalen NUMBER(17, 2);
    ln_mtoFin number(17, 2);
    ld_Fec    date;
    lc_tip    char(1);
    ld_Fecpri date;
    lc_telefono   char(100);
    lc_correo     char(100);
    ln_cont       number := 0;
    ln_cont1      number := 0;
    fechalinea    date;
    ln_tip        char(30);
  begin

    begin

      for i in creditos loop
        lc_tip    := null;
        ln_grupo  := null;
        lc_plan   := null;
        ln_gracia := 0;
        -- Numero de poliza
        if i.jaqz097mda = 0 then
          ln_numpol := 235901;
        else
          ln_numpol := 235899;
        end if;
        --fecha de vigencia inicial
        ld_fecvini := to_date('01' || to_char(i.jaqz097fva, 'mmyyyy'),
                              'dd/mm/yyyy');
        --fecha de vigencia final
        ld_fecvfin := pd_fecfin;

        --monto de la prima
        ln_monto := pq_cr_tramdesgra.fn_monto_prima_cuo(i.jaqz097emp,
                                                        i.jaqz097mod,
                                                        i.jaqz097suc,
                                                        i.jaqz097mda,
                                                        i.jaqz097pap,
                                                        i.jaqz097cta,
                                                        i.jaqz097ope,
                                                        i.jaqz097sbo,
                                                        i.jaqz097top);

        --monto de la prima total
        ln_monto_tot := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.jaqz097emp,
                                                                i.jaqz097mod,
                                                                i.jaqz097suc,
                                                                i.jaqz097mda,
                                                                i.jaqz097pap,
                                                                i.jaqz097cta,
                                                                i.jaqz097ope,
                                                                i.jaqz097sbo,
                                                                i.jaqz097top);

        --saldo capital y grupo

        --grupo
        ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.jaqz097emp,
                                                i.jaqz097mod,
                                                i.jaqz097suc,
                                                i.jaqz097mda,
                                                i.jaqz097pap,
                                                i.jaqz097cta,
                                                i.jaqz097ope,
                                                i.jaqz097sbo,
                                                i.jaqz097top);

        --tipo SBS RCC si es nulo



        --instancia
        ln_instancia := fn_instancia_credito(i.jaqz097mod,
                                             i.jaqz097SUC,
                                             i.jaqz097MDA,
                                             i.jaqz097PAP,
                                             i.jaqz097CTA,
                                             i.jaqz097OPE,
                                             i.jaqz097SBO,
                                             i.jaqz097TOP);
        --- grupo
        if ln_grupo is null then
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz097emp,
                                                      i.jaqz097MOD,
                                                      i.jaqz097SUC,
                                                      i.jaqz097MDA,
                                                      i.jaqz097PAP,
                                                      i.jaqz097CTA,
                                                      i.jaqz097OPE,
                                                      i.jaqz097SBO,
                                                      i.jaqz097TOP);
        end if;

        --plan
        begin
           select trim(substr(wfattsval, instr(wfattsval, ';', 1) + 1, 25))
             into ln_tip
             from wfattsvalues
            where wfattsid = 'TIPO_CREDITO'
              and wfinsprcid = ln_instancia
              and substr(wfattsval, 1, instr(wfattsval, ';', 1) - 1) = ln_grupo;
        exception
          when no_data_found then
            ln_tip := ' ';
        end;
        case
          when ln_grupo in (2, 12, 13) then

            lc_plan := 'PYME'||' '||substr(ln_tip,1,25); ---ln_tip;
          when ln_grupo = 3 then

            lc_plan := 'CONSUMO'||' '||substr(ln_tip,1,22);
          when ln_grupo = 4 then

            lc_plan := 'HIPOTECARIO'||' '||substr(ln_tip,1,18); ---ln_tip;
          else
            null;
        end case;

        --monto aprobado
        ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);
        --tasa
        ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.jaqz097emp,
                                                                i.jaqz097MOD,
                                                                i.jaqz097SUC,
                                                                i.jaqz097MDA,
                                                                i.jaqz097PAP,
                                                                i.jaqz097CTA,
                                                                i.jaqz097OPE,
                                                                i.jaqz097SBO,
                                                                i.jaqz097TOP,
                                                                ln_mtoapr);

        --monto calendario de pago
        pq_cr_tramdesgra.Sp_monto_calendario(i.jaqz097emp,
                                             i.jaqz097MOD,
                                             i.jaqz097SUC,
                                             i.jaqz097MDA,
                                             i.jaqz097PAP,
                                             i.jaqz097CTA,
                                             i.jaqz097OPE,
                                             i.jaqz097SBO,
                                             i.jaqz097TOP,
                                             1,
                                             pd_fecfin,
                                             ln_mtoCalen,
                                             lc_tip);

        --numero de credito
        lc_numcre := to_char(LPAD(i.JAQZ097CTA, 9, '0') ||
                             LPAD(i.JAQZ097OPE, 9, '0') ||
                             LPAD(i.JAQZ097SBO, 3, '0'));

        --datos persona
        begin
          select a.pepais, a.petdoc, a.pendoc
            into ln_pai, ln_tdo, lc_ndo
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
            lc_petipo := null;
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
          select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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
          select a.pfpai1, a.pftdo1, a.pfndo1
            into ln_paij, ln_tdoj, lc_ndoj
            from fsr003 a
           where a.pjpais = ln_pai
             and a.pjtdoc = ln_tdo
             and a.pjndoc = lc_ndo;
        exception
          when too_many_rows then
            begin
              select a.pfpai1, a.pftdo1, a.pfndo1
                into ln_paij, ln_tdoj, lc_ndoj
                from fsr003 a
               where a.pjpais = ln_pai
                 and a.pjtdoc = ln_tdo
                 and a.pjndoc = lc_ndo
                 and a.vicod <> 1
                 and rownum = 1;
            exception
              when no_data_found then
                null;

            end;
          when no_data_found then
            null;
        end;
        --fecha de nacimiento
        if lc_petipo = 'F' then
          --mod 2016.04.14
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
            select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

        end if; --mod 2016.04.14

        ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.JAQZ097EMP,
                                                     i.JAQZ097MOD,
                                                     i.JAQZ097SUC,
                                                     i.JAQZ097MDA,
                                                     i.JAQZ097PAP,
                                                     i.JAQZ097CTA,
                                                     i.JAQZ097OPE,
                                                     i.JAQZ097SBO,
                                                     i.JAQZ097TOP);

        --suma asegurada
        ln_mtoFin := null;
        ln_mtoFin := pq_cr_tramdesgra.Fn_montoDes(i.jaqz097emp,
                                                  i.jaqz097MOD,
                                                  i.jaqz097SUC,
                                                  i.jaqz097MDA,
                                                  i.jaqz097PAP,
                                                  i.jaqz097CTA,
                                                  i.jaqz097OPE,
                                                  i.jaqz097SBO,
                                                  i.jaqz097TOP,
                                                  pd_fecfin);

        --fecha de la cuota por vencer
        ld_Fec := null;
        pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz097emp,
                                         i.jaqz097MOD,
                                         i.jaqz097SUC,
                                         i.jaqz097MDA,
                                         i.jaqz097PAP,
                                         i.jaqz097CTA,
                                         i.jaqz097OPE,
                                         i.jaqz097SBO,
                                         i.jaqz097TOP,
                                         pd_fecfin,
                                         ld_Fec);

        --fecha de primera cuota
        ld_Fecpri := null;
        pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz097emp,
                                          i.jaqz097MOD,
                                          i.jaqz097SUC,
                                          i.jaqz097MDA,
                                          i.jaqz097PAP,
                                          i.jaqz097CTA,
                                          i.jaqz097OPE,
                                          i.jaqz097SBO,
                                          i.jaqz097TOP,
                                          pd_fecfin,
                                          ld_Fecpri);
        -- telefono y correo smarquez 17102019
        lc_telefono := null;
        lc_correo := null;
        For t in telefono(ln_pai,ln_tdo,lc_ndo)loop
          if ln_cont = 0 then
            lc_telefono := trim(t.fono);
          else
            lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
          end if;
           ln_cont := ln_cont + 1;
        end loop;

         For c in correo(ln_pai,ln_tdo,lc_ndo)loop
          if ln_cont1 = 0 then
            lc_correo := trim(c.mail);
          else
            lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
          end if;
           ln_cont1 := ln_cont1 + 1;
        end loop;
        fechalinea := null;
        if i.jaqz097MOD= 116 then

          BEgin
           select (select aofval
                     from fsd010
                    where pgcod = 1
                      and aomod = x.xwfmodulo
                      and aocta = x.xwfcuenta
                      and aooper = x.xwfoperacion
                      and aosbop = x.xwfsubope
                      and aotope = x.xwftipope)
             into fechalinea
             from xwf700 x, fsr011 y
            where y.r1cod = 1
              and y.r1mod = 116
              and y.r1cta = i.jaqz097cta
              and y.r1oper = i.jaqz097ope
              and y.relcod = 46
              and x.xwfempresa = 1
              and x.xwfsucursal = y.r2suc
              and x.xwfmodulo = y.r2mod
              and x.xwfcuenta = y.r2cta
              and x.xwfoperacion = y.r2oper
              and x.xwfcar3 = '1';
           exception
             when no_data_found then
               fechalinea:= null;
           end;
        end if;
        Begin
            insert into JAQZ097
              (JAQZ097EMP,
               JAQZ097MOD,
               JAQZ097SUC,
               JAQZ097MDA,
               JAQZ097PAP,
               JAQZ097CTA,
               JAQZ097OPE,
               JAQZ097SBO,
               JAQZ097TOP,
               JAQZ097FEC,
               JAQZ097MAP,
               JAQZ097FEI,
               JAQZ097FEF,
               JAQZ097NUM,
               JAQZ097TAS,
               JAQZ097MPR, /*JAQZ097SCA,*/
               JAQZ097GRU,
               JAQZ097PLA,
               JAQZ097PAI,
               JAQZ097TDO,
               JAQZ097NDO,
               JAQZ097TPE,
               JAQZ097SEX,
               JAQZ097FNA,
               JAQZ097APT,
               JAQZ097APM,
               JAQZ097NOM,
               JAQZ097RZO,
               JAQZ097MPA,
               JAQZ097NUC,
               JAQZ097IMP,
               JAQZ097FVA,
               JAQZ097DGA,
               JAQZ097PER,
               JAQZ097MCA,
               JAQZ097FVE,
               JAQZ097EST,
               JAQZ097FPR,
               JAQZ097TLF,
               JAQZ097MAIL,
               jaqz097aux5 )
            Values
              (i.JAQZ097EMP,
               i.JAQZ097MOD,
               i.JAQZ097SUC,
               i.JAQZ097MDA,
               i.JAQZ097PAP,
               i.JAQZ097CTA,
               i.JAQZ097OPE,
               i.JAQZ097SBO,
               i.JAQZ097TOP,
               pd_fecfin,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               ln_monto_tot,
               lc_numcre, /*I.JAQZ097IMP*/
               ln_mtoFin,
               I.JAQZ097FVA,
               ln_gracia,
               i.jaqz097per,
               ln_mtoCalen,
               ld_Fec,
               I.JAQZ097EST,
               ld_Fecpri,
               lc_telefono,
               lc_correo,
               fechalinea);
        exception
          when dup_val_on_index then
            null;
        end ;
        Begin
            insert into Jaqz097H
              (Jaqz097HEMP,
               Jaqz097HMOD,
               Jaqz097HSUC,
               Jaqz097HMDA,
               Jaqz097HPAP,
               Jaqz097HCTA,
               Jaqz097HOPE,
               Jaqz097HSBO,
               Jaqz097HTOP,
               Jaqz097HFEC,
               Jaqz097HMAP,
               Jaqz097HFEI,
               Jaqz097HFEF,
               Jaqz097HNUM,
               Jaqz097HTAS,
               Jaqz097HMPR, /*Jaqz097HSCA,*/
               Jaqz097HGRU,
               Jaqz097HPLA,
               Jaqz097HPAI,
               Jaqz097HTDO,
               Jaqz097HNDO,
               Jaqz097HTPE,
               Jaqz097HSEX,
               Jaqz097HFNA,
               Jaqz097HAPT,
               Jaqz097HAPM,
               Jaqz097HNOM,
               Jaqz097HRZO,
               Jaqz097HMPA,
               Jaqz097HNUC,
               Jaqz097HIMP,
               Jaqz097HFVA,
               Jaqz097HDGA,
               Jaqz097HPER,
               Jaqz097HMCA,
               Jaqz097HFVE,
               Jaqz097HEST,
               Jaqz097HFPR,
               Jaqz097HTLF,
               Jaqz097HMAIL,
               jaqz097haux5 )
            Values
              (i.JAQZ097EMP,
               i.JAQZ097MOD,
               i.JAQZ097SUC,
               i.JAQZ097MDA,
               i.JAQZ097PAP,
               i.JAQZ097CTA,
               i.JAQZ097OPE,
               i.JAQZ097SBO,
               i.JAQZ097TOP,
               pd_fecfin,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               ln_monto_tot,
               lc_numcre, /*I.JAQZ097IMP*/
               ln_mtoFin,
               I.JAQZ097FVA,
               ln_gracia,
               i.jaqz097per,
               ln_mtoCalen,
               ld_Fec,
               I.JAQZ097EST,
               ld_Fecpri,
               lc_telefono,
               lc_correo,
               fechalinea);
        exception
          when dup_val_on_index then
            null;
        end ;
      end loop;
    end;
  end Sp_Carga_Desem;

  Procedure Sp_dataFSH012_pag(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pd_pago   in date,
                              pn_sca    out number,
                              pn_gpo    out number) is
    ld_fec date;

    ld_fecmax  date;
    ln_mesAct  number(2);
    ln_mesPag  number(2);
    ld_fecpago date;

  begin
    ln_mesAct := to_number(to_char(pd_fecpro, 'mm'));
    ld_fecmax := pd_pago;

    ln_mesPag := to_number(to_char(ld_fecmax, 'mm'));

    if ld_fecmax is null then
      begin
        select aoimp, aofval
          into pn_sca, ld_fec
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
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
         where pgcod = pn_emp
           and scmod = pn_mod
           and scsuc = pn_suc
           and scmda = pn_mda
           and scpap = pn_pap
           and sccta = pn_cta
           and scoper = pn_ope
           and scsbop = pn_sbo
           and sctope = pn_top;
      exception
        when no_data_found then
          pn_gpo := null;
      end;

      if pn_gpo is null then
        begin
          select /*+index(b FSH01204)*/ b.bcgpo
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
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_fecmax
              --and a.pp1stat = 'T'
           and pp1fech <= pd_fecpro
           and a.d602co = 'S';

      exception
        when no_data_found then
          ld_fecpago := null;
      end;

      if ln_mesAct = ln_mesPag then
        begin
          select /*+index(b FSH01204)*/b.bcsdmo, b.bcgpo
            into pn_sca, pn_gpo
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
            select aoimp, aofval
              into pn_sca, ld_fec
              from fsd010 a
             where a.pgcod = pn_emp
               and a.aomod = pn_mod
               and a.aosuc = pn_suc
               and a.aomda = pn_mda
               and a.aopap = pn_pap
               and a.aocta = pn_cta
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
             where pgcod = pn_emp
               and scmod = pn_mod
               and scsuc = pn_suc
               and scmda = pn_mda
               and scpap = pn_pap
               and sccta = pn_cta
               and scoper = pn_ope
               and scsbop = pn_sbo
               and sctope = pn_top;
          exception
            when no_data_found then
              pn_gpo := null;
          end;
          if pn_gpo is null then
            begin
              select /*+index(b FSH01204)*/b.bcgpo
                into pn_gpo
                from fsh012 b
               where b.bcemp = pn_emp
                 and b.bcsuc = pn_suc
                 and b.bcrubr in
                     (select rubro
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
          select /*+index(b FSH01204)*/b.bcsdmo, b.bcgpo
            into pn_sca, pn_gpo
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
            select aoimp, aofval
              into pn_sca, ld_fec
              from fsd010 a
             where a.pgcod = pn_emp
               and a.aomod = pn_mod
               and a.aosuc = pn_suc
               and a.aomda = pn_mda
               and a.aopap = pn_pap
               and a.aocta = pn_cta
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
             where pgcod = pn_emp
               and scmod = pn_mod
               and scsuc = pn_suc
               and scmda = pn_mda
               and scpap = pn_pap
               and sccta = pn_cta
               and scoper = pn_ope
               and scsbop = pn_sbo
               and sctope = pn_top;
          exception
            when no_data_found then
              pn_gpo := null;
          end;
          if pn_gpo is null then
            begin
              select /*+index(b FSH01204)*/b.bcgpo
                into pn_gpo
                from fsh012 b
               where b.bcemp = pn_emp
                 and b.bcsuc = pn_suc
                 and b.bcrubr in
                     (select rubro
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
        select aoimp, aofval
          into pn_sca, ld_fec
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
              --and a.aosuc  = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
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
         where pgcod = pn_emp
           and scmod = pn_mod
              --and scsuc  = pn_suc
           and scmda = pn_mda
           and scpap = pn_pap
           and sccta = pn_cta
           and scoper = pn_ope
           and scsbop = pn_sbo
           and sctope = pn_top;
      exception
        when no_data_found then
          pn_gpo := null;
      end;
      if pn_gpo is null then
        begin
          select /*+index(b FSH01204)*/b.bcgpo
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

  FUNCTION fn_MONTO_PRIMA_CUO(pa_pgcod  number,
                              pa_ppmod  number,
                              pa_ppsuc  number,
                              pa_ppmda  number,
                              pa_pppap  number,
                              pa_ppcta  number,
                              pa_ppoper number,
                              pa_ppsbop number,
                              pa_pptope number) return number IS

    cursor cronograma is
      select *
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

    ln_mtodes   number := 0;
    ln_monto    number := 0;
    --ln_montoI   number := 0;
    ln_salcap   number := 0;
    ln_tasa     number;
    ln_mda      number;
    ln_periodo  number;
    ln_tipper   number;
    ln_contador number := 0;
    ln_factor   number;
    ln_cuota    number;

    ln_num    number;
    ln_valor  number := 0;
    ln_pergra number := 0;
    ld_fecval date;
    ld_feccuo date;

  --  ln_cont number;

  BEGIN
    --ln_cont := 0;
    begin
      select aoimp, f.aomda, f.aoperiod, f.aofval
        into ln_mtodes, ln_mda, ln_periodo, ld_fecval
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
    exception
      when others then
        ln_mtodes := 0;
    end;

    --obtiene tasa
    ln_tasa := pq_cr_seguro_desgravamen.fn_tasa_desgravamen(pa_pgcod  => pa_pgcod,
                                                            pa_aomod  => pa_ppmod,
                                                            pa_aosuc  => pa_ppsuc,
                                                            pa_aomda  => pa_ppmda,
                                                            pa_aopap  => pa_pppap,
                                                            pa_aocta  => pa_ppcta,
                                                            pa_aooper => pa_ppoper,
                                                            pa_aosbop => pa_ppsbop,
                                                            pa_aotope => pa_pptope,
                                                            pa_monto  => ln_mtodes);
    ln_tasa := ln_tasa / 100;

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
    exception
      when others then
        ld_feccuo := null;
    end;

    case
      when ln_tipper = 1 then
        ln_cuota  := 30;
        ln_pergra := 1;
        ln_factor := 1;
      when ln_tipper = 2 then
        ln_cuota  := 4;
        ln_pergra := 7;
        ln_factor := 1;
      when ln_tipper = 3 then
        ln_cuota  := 2;
        ln_pergra := 15;
        ln_factor := 1;
      when ln_tipper = 4 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 30;
        ln_factor := 1;

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
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 45;
        ln_factor := 1;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;

      when ln_tipper = 6 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 60;
        ln_factor := 2;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 7 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 90;
        ln_factor := 3;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 8 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 120;
        ln_factor := 4;
      when ln_tipper = 9 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 180;
        ln_factor := 6;
    end case;

    ---------------;

    Case
      when ln_tipper in (4) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2) * ln_valor;
        ln_salcap := ln_mtodes;
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);

      when ln_tipper in (6, 7, 8, 9) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * (ln_factor + ln_valor);
        ln_salcap := ln_mtodes;

      when ln_tipper in (1, 2, 3) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;

        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;
        ln_num    := ln_contador + ln_cuota;

      when ln_tipper in (5) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;
        if ln_contador = 1 then
          ln_factor := 2;
        end if;
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;

    End case;

    return ln_monto;

  EXCEPTION
    WHEN OTHERS THEN
      return 0;

  END fn_MONTO_PRIMA_CUO;

  function fn_dias_gracia(pn_emp  in number,
                          pn_mod  in number,
                          pn_suc  in number,
                          pn_mda  in number,
                          pn_pap  in number,
                          pn_cta  in number,
                          pn_oper in number,
                          pn_sbop in number,
                          pn_top  in number) return number is
    ln_diagra  number;
    ln_flg     number(1);
  --  ln_periodo number;
  begin
    begin
      if pn_TOP = 550 or pn_mod in (200, 33) then
        ln_diagra := 0;
      else
        select NVL( ((select min(n.ppfpag)
                   from fsd601 n
                  where m.xllaocta = n.ppcta
                    and m.xllaooper = n.ppoper
                    and m.xllaosbop = n.ppsbop
                    and m.xllaotop = n.pptope
                    and m.xllaomod = n.ppmod
                    and m.xllaosuc = n.ppsuc
                    and m.xllaomda = n.ppmda
                    and m.xllaopap = n.pppap
                    and (n.ppcap + n.ppint) <> 0
                    and n.d601co = 'S') - m.xllfvalor) - m.xllperiodo,0)
          into ln_diagra
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
        ln_diagra := null;
      when too_many_rows then
        ln_diagra := null;
    end;
    begin

      if ln_diagra < 0 then
        ln_diagra := 0;
      end if;
    end;

    begin
      if ln_diagra > 2 then
        ln_flg := 1;
      else
        ln_flg := 0;
      end if;
    end;
    return ln_flg;
  end fn_dias_gracia;

  Procedure Sp_monto_calendario(pn_emp      in number,
                                pn_mod      in number,
                                pn_suc      in number,
                                pn_mda      in number,
                                pn_pap      in number,
                                pn_cta      in number,
                                pn_ope      in number,
                                pn_sbo      in number,
                                pn_top      in number,
                                pn_tip      in number,
                                pd_fecpro   in date,
                                ln_mtoprima out number,
                                lc_tip      out varchar2) is

    cursor Calendario(fecha1 date, fecha2 date) is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag between fecha1 and fecha2;

    cursor seguros is
      select tp1imp1 tp1nro1
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10898
         and tp1corr1 = 8;



    cursor seguros_ii is
      select *
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;

    cursor calendario_vida is
      select *
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top;

    cursor monto_prima is
      select tp1imp1
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10898
         and tp1corr1 = 18
         and tp1corr2 in (3, 10, 11);

    ln_canSeg number(2);
    ln_codVar number(2);
    ld_fecan  date;

    ld_fecini date;
    ld_fecfin date;
    --ln_mtoprima number(17,2) ;
    ln_mto11 number(17, 2);
    ln_mto12 number(17, 2);
    ln_mto13 number(17, 2);
    ln_mto14 number(17, 2);
    ln_mto15 number(17, 2);

    lc_flag   char(1);
    ln_impAux number(17, 2);

    lc_flag11   char(1);
    ln_impAux11 number(17, 2);

    lc_flag13   char(1);
    ln_impAux13 number(17, 2);

    ld_pago date;
    --lc_tip char(1);

    --mod@abr 2018
    ld_fecpxv date;
    ld_fecaux date;
    lc_flg    char(1);
    ld_feccaj date;
    --mod@abr 2018

    ln_contad number(5) := 0; --mod@abr 20181102

  begin

    ld_fecaux := pd_fecpro;
    ld_fecini :=  TRUNC(pd_fecpro, 'MM');---to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');
    ld_fecfin := ld_fecaux;
    lc_tip    := null;

    begin
                for i in seguros loop
                  ln_canSeg := 0;
                  ln_codVar := 0;
                  for j in seguros_ii loop
                    ln_canSeg := ln_canSeg + 1;
                    if i.tp1nro1 = j.SgCod then
                      ln_codVar := ln_canSeg;
                      exit;
                    end if;
                  end loop;

                  if ln_codVar <> 0 then

                    begin
                      if pn_tip = 1 then
                        --desembolsos
                        lc_tip := null;
                        begin
                          select min(a.ppfpag)
                            into ld_fecan
                            from fsd611 a
                           where a.pgcod = pn_emp
                             and a.ppmod = pn_mod
                             and a.ppsuc = pn_suc
                             and a.ppmda = pn_mda
                             and a.pppap = pn_pap
                             and a.ppcta = pn_cta
                             and a.ppoper = pn_ope
                             and a.ppsbop = pn_sbo
                             and a.pptope = pn_top;
                        exception
                          when others then
                            insert into jaqz097_error
                            values
                              (pn_cta, pn_ope, 1, SYSDATE);
                            commit;
                        end;

                        begin
                          select ppimp11, ppimp12, ppimp13, ppimp14, ppimp15
                            into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                            from fsd611 a
                           where a.pgcod = pn_emp
                             and a.ppmod = pn_mod
                             and a.ppsuc = pn_suc
                             and a.ppmda = pn_mda
                             and a.pppap = pn_pap
                             and a.ppcta = pn_cta
                             and a.ppoper = pn_ope
                             and a.ppsbop = pn_sbo
                             and a.pptope = pn_top
                             and a.ppfpag = ld_fecan;
                        exception
                          when others then
                            insert into jaqz097_error
                            values
                              (pn_cta, pn_ope, 2, SYSDATE);
                            commit;
                        end;

                        case
                          when ln_codVar = 1 then
                            ln_mtoprima := ln_mto11;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                              if ln_mtoprima = prima.tp1imp1 then ---2.5 then
                                ln_impAux := prima.tp1imp1; --- 2.5;
                                for h in calendario_vida loop
                                  if ln_impAux = h.ppimp11 then

                                    lc_flag   := 'S';
                                    ln_contad := ln_contad + 1; --mod@abr 20181102
                                  else
                                    lc_flag := 'N';
                                    exit;
                                  end if;
                                  ln_impAux := h.ppimp11;
                                end loop;

                                if lc_flag = 'S' then
                                  ln_mtoprima := ln_mto12;
                                end if;

                                if ln_contad > 1 and ln_mto12 <> 0 then
                                  ln_mtoprima := ln_mto12; --mod@abr 20181102
                                end if;
                              end if;
                            end loop;
                          when ln_codVar = 2 then
                            ln_mtoprima := ln_mto12;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                              if ln_mtoprima = prima.tp1imp1 then --2.5 then
                                ln_impAux := prima.tp1imp1; ---2.5;
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
                                  ln_impAux11 := prima.tp1imp1;--2.5;
                                  for h in calendario_vida loop
                                    if ln_impAux11 = h.ppimp11 then

                                      lc_flag11 := 'S';
                                    else
                                      lc_flag11 := 'N';
                                      exit;
                                    end if;
                                    ln_impAux11 := h.ppimp11;
                                  end loop;

                                  ln_impAux13 := prima.tp1imp1; -- 2.5;
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
                            end loop;
                          when ln_codVar = 3 then
                            ln_mtoprima := ln_mto13;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                              if ln_mtoprima = prima.tp1imp1 then --2.5 then
                                ln_impAux := prima.tp1imp1; --2.5;
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
                            end loop;
                          when ln_codVar = 4 then
                            ln_mtoprima := ln_mto14;
                          when ln_codVar = 5 then
                            ln_mtoprima := ln_mto15;
                          else
                            ln_mtoprima := 0;

                        end case;

                      else
                        ------
                        --verifica caja solidario
                        begin
                          select /*+ parallel(n,2,1)*/
                           min(n.ppfpag)
                            into ld_fecpxv
                            from fsd601 n
                           where n.pgcod = pn_emp
                             and n.ppcta = pn_cta
                             and n.ppmda = pn_mda
                             and n.ppsuc = pn_suc
                             and n.pppap = pn_pap
                             and n.ppoper = pn_ope
                             and n.ppsbop = pn_sbo
                             and n.pptope = pn_top
                             and n.ppmod = pn_mod
                             and n.d601co = 'S'
                             and (n.ppcap + n.ppint) <> 0
                             and not exists
                           (select /*+ parallel(o,2,1)*/
                                   ppmod, ppcta, ppoper, pptope, ppfpag
                                    from fsd602 o
                                   where o.pgcod = n.pgcod
                                     and o.ppmod = n.ppmod
                                     and o.ppsuc = n.ppsuc
                                     and o.ppmda = n.ppmda
                                     and o.pppap = n.pppap
                                     and o.ppcta = n.ppcta
                                     and o.ppoper = n.ppoper
                                     and o.ppsbop = n.ppsbop
                                     and o.pptope = n.pptope
                                     and o.ppfpag = n.ppfpag
                                     and o.pp1fech <= ld_fecaux
                                     and o.pp1stat = 'T'
                                     and o.d602co = 'S'
                                     and (o.pp1cap + o.pp1int) <> 0);
                        exception
                          when others then
                            null;
                        end;

                        if ld_fecpxv <= ld_fecaux then
                          lc_flg := 'S';
                        else
                          lc_flg := 'N';
                        end if;

                        --                          ld_feccaj := to_date('01'||to_char(ld_fecpxv,'mmyyyy'),'ddmmyyyy');
                        --ld_feccaj := ld_fecpxv;
                        ld_feccaj := TRUNC(ld_fecpxv, 'MM'); --mod@abr 20181107

                        if lc_flg = 'N' then
                          --no caja solidario

                          begin
                            select sum(ppimp11),
                                   sum(ppimp12),
                                   sum(ppimp13),
                                   sum(ppimp14),
                                   sum(ppimp15)
                              into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                              from fsd611 a
                             where a.pgcod = pn_emp
                               and a.ppmod = pn_mod
                               and a.ppsuc = pn_suc
                               and a.ppmda = pn_mda
                               and a.pppap = pn_pap
                               and a.ppcta = pn_cta
                               and a.ppoper = pn_ope
                               and a.ppsbop = pn_sbo
                               and a.pptope = pn_top
                               and a.ppfpag = pd_fecpro; -- ld_fecpago; --between ld_fecini and pd_fecpro;
                          exception
                            when others then

                              null;
                          end;

                        else
                          --si caja solidario

                          begin
                            select sum(ppimp11),
                                   sum(ppimp12),
                                   sum(ppimp13),
                                   sum(ppimp14),
                                   sum(ppimp15)
                              into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                              from fsd611 a
                             where a.pgcod = pn_emp
                               and a.ppmod = pn_mod
                               and a.ppsuc = pn_suc
                               and a.ppmda = pn_mda
                               and a.pppap = pn_pap
                               and a.ppcta = pn_cta
                               and a.ppoper = pn_ope
                               and a.ppsbop = pn_sbo
                               and a.pptope = pn_top
                               and a.ppfpag between ld_feccaj and ld_fecpxv;
                          exception
                            when others then
                              null;
                          end;
                        end if; -- fin mod@abr 2018

                        begin
                          select ppfpag
                            into ld_pago
                            from fsd611 a
                           where a.pgcod = pn_emp
                             and a.ppmod = pn_mod
                             and a.ppsuc = pn_suc
                             and a.ppmda = pn_mda
                             and a.pppap = pn_pap
                             and a.ppcta = pn_cta
                             and a.ppoper = pn_ope
                             and a.ppsbop = pn_sbo
                             and a.pptope = pn_top
                             and a.ppfpag = pd_fecpro; ---ld_fecpago; --between ld_fecini and pd_fecpro;
                        exception
                          when too_many_rows then
                            insert into jaqz097_error
                            values
                              (pn_cta, pn_ope, 55, SYSDATE);
                            commit;

                            begin
                              select max(ppfpag)
                                into ld_pago
                                from fsd611 a
                               where a.pgcod = pn_emp
                                 and a.ppmod = pn_mod
                                 and a.ppsuc = pn_suc
                                 and a.ppmda = pn_mda
                                 and a.pppap = pn_pap
                                 and a.ppcta = pn_cta
                                 and a.ppoper = pn_ope
                                 and a.ppsbop = pn_sbo
                                 and a.pptope = pn_top
                                 and a.ppfpag = pd_fecpro --ld_fecpago --between ld_fecini and pd_fecpro
                                 and rownum = 1;
                            exception
                              when others then
                                null;

                            end;
                          when others then
                            null;

                        end;

                        case
                          when ln_codVar = 1 then
                            ln_mtoprima := ln_mto11;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                              if ln_mtoprima = prima.tp1imp1 then ---2.5 then
                                ln_impAux := prima.tp1imp1; --2.5;
                                for h in calendario_vida loop
                                  if ln_impAux = h.ppimp11 then

                                    lc_flag   := 'S';
                                    ln_contad := ln_contad + 1; --mod@abr 20181102
                                  else
                                    lc_flag := 'N';
                                    exit;
                                  end if;
                                  ln_impAux := h.ppimp11;
                                end loop;

                                if lc_flag = 'S' then
                                  ln_mtoprima := ln_mto12;
                                  ln_codVar   := 2;
                                end if;

                                if ln_contad > 1 and ln_mto12 <> 0 then
                                  ln_mtoprima := ln_mto12; --mod@abr 20181102
                                end if;
                              end if;
                            end loop;
                          when ln_codVar = 2 then
                            ln_mtoprima := ln_mto12;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                              if ln_mtoprima = prima.tp1imp1 then -- 2.5 then
                                ln_impAux := prima.tp1imp1; --2.5;
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
                                  ln_impAux11 := prima.tp1imp1; ---2.5;
                                  for h in calendario_vida loop
                                    if ln_impAux11 = h.ppimp11 then

                                      lc_flag11 := 'S';
                                    else
                                      lc_flag11 := 'N';
                                      exit;
                                    end if;
                                    ln_impAux11 := h.ppimp11;
                                  end loop;

                                  ln_impAux13 :=prima.tp1imp1;--- 2.5;
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
                                    ln_codVar   := 3;
                                  else
                                    ln_mtoprima := ln_mto11;
                                    ln_codVar   := 1;
                                  end if;
                                end if;
                              end if;
                            end loop;
                          when ln_codVar = 3 then
                            ln_mtoprima := ln_mto13;
                            for prima in monto_prima loop --14/10/2019 .sma adicion de for para valorees de seg Vida Caja
                                if ln_mtoprima = prima.tp1imp1 then --2.5 then
                                  ln_impAux := prima.tp1imp1 ; ---2.5;
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
                                    ln_codVar   := 2;
                                  end if;

                                end if;
                            end loop;
                          when ln_codVar = 4 then
                            ln_mtoprima := ln_mto14;
                          when ln_codVar = 5 then
                            ln_mtoprima := ln_mto15;
                          else
                            ln_mtoprima := 0;
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

    end ;
  end Sp_monto_calendario;

  Function Fn_scap_calendario(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pd_fecpro in date,
                              pd_fpago  in date) return number is

    ln_montocal number(17, 2);
    ln_mtodes   number(17, 2);
    ln_mtodesC  number(17, 2);
    ln_salcap   number(17, 2);
    ld_fecpxv   date; --mod@abr 20170705
    lc_flg      char(1); --mod@abr 20170705
    --ln_amortiza number(17, 2) := 0;
    ln_credpar  number(17, 2) := 0;
    instancia   number(10);
    segplus     number := 0;
  begin
    begin
      select aoimp
        into ln_mtodes
        from fsd010
       where pgcod = pn_emp
         and aomod = pn_mod
         and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
    exception
      when too_many_rows then
        begin
          select aoimp
            into ln_mtodes
            from fsd010
           where pgcod = pn_emp
             and aomod = pn_mod
             and aosuc = pn_suc
             and aomda = pn_mda
             and aopap = pn_pap
             and aocta = pn_cta
             and aooper = pn_ope
             and aosbop = pn_sbo
             and aotope = pn_top
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
    ln_mtodesC := ln_mtodes;
    --mod@abr 20170705
    --verifica caja solidario
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppmod = pn_mod
         and n.ppsuc = pn_suc
         and n.ppmda = pn_mda
         and n.pppap = pn_pap
         and n.ppcta = pn_cta
         and n.ppoper = pn_ope
         and n.ppsbop = pn_sbo
         and n.pptope = pn_top
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    EXCEPTION
      WHEN OTHERS THEN
       ld_fecpxv:= '01/01/0001';
    end;

    if ld_fecpxv <= pd_fecpro then
      lc_flg := 'S';
    else
      lc_flg := 'N';
    end if;

    if lc_flg = 'S' then

      begin
        select sum(a.ppcap)
          into ln_montocal
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag <= add_months(last_day(ld_fecpxv), -1) --mod@abr 2018
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
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag < pd_fpago --add_months(pd_fecpro,-1)
        ;
      exception
        when others then
          ln_montocal := null;
      end;
    end if;

    -- Verifica Desembolsos Parciales SMS 20/09/2017
    instancia := fn_instancia_credito(pn_mod,
                                      pn_suc,
                                      pn_mda,
                                      pn_pap,
                                      pn_cta,
                                      pn_ope,
                                      pn_sbo,
                                      pn_top);
    select NVL((sum(f.pp1cap) * (-1)), 0)
      into ln_credpar
      from fsd602 f
     where f.pgcod = pn_emp
       and f.ppmod = pn_mod
       and f.ppsuc = pn_suc
       and f.ppmda = pn_mda
       and f.pppap = pn_pap
       and f.ppcta = pn_cta
       and f.ppoper = pn_ope
       and f.ppsbop = pn_sbo
       and f.pptope = pn_top
       and f.d602co = 'S'
       and f. d602fc <= pd_fpago --sma 29/09/2018
       and f.pp1cap < 0
       and exists (Select 1
              from sng001
             where sng001ori = 7
               and sng001inst = instancia
               and sng001cta = f.ppcta);
    if ln_credpar > 0 then
      ln_mtodes := ln_mtodes + ln_credpar;
    end if;
    -- fin
    if ln_montocal is null then
      ln_salcap := ln_mtodes;
    else
      ln_salcap := ln_mtodes - ln_montocal;
    end if;
    --- sma 20191126 Verificacion de tipo de seguro de desgravamen
    segplus := Fn_cr_Segplus(pn_emp,
                             pn_mod,
                             pn_suc,
                             pn_mda,
                             pn_pap,
                             pn_cta,
                             pn_ope,
                             pn_sbo,
                             pn_top);
    if segplus = 1 then
          ln_salcap := ln_mtodesC;
    end if;
    return ln_salcap;

  end Fn_scap_calendario;

  Function Fn_tipoSBS(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number) return number is

    ln_grup   number(2);
    ld_aofe   date;
    ld_aofval date;
    ld_fecsbs date;
    ld_fecant date;
  begin
    begin
      select a.scgru
        into ln_grup
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.scmod = pn_mod
         and rownum = 1; --HSUAREZ 2016.08.18 - MODIFICACION PARA SOLO ACEPTAR UNA FILA.
    exception
      when no_data_found then
        ln_grup := null;
    end;

    if ln_grup is null then
      begin
        select aofe99, aofval
          into ld_aofe, ld_aofval
          from fsd010
         where pgcod = pn_emp
           and aomod = pn_mod
           and aosuc = pn_suc
           and aomda = pn_mda
           and aopap = pn_pap
           and aocta = pn_cta
           and aooper = pn_ope
           and aosbop = pn_sbo
           and aotope = pn_top;
      exception
        when no_data_found then
          begin
            select aofe99, aofval
              into ld_aofe, ld_aofval
              from fsd010
             where pgcod = pn_emp
               and aomod = pn_mod
                  --and aosuc  = pn_suc
               and aomda = pn_mda
               and aopap = pn_pap
               and aocta = pn_cta
               and aooper = pn_ope
               and aosbop = pn_sbo
               and aotope = pn_top;
          exception
            when no_data_found then
              insert into jaqz097_error
              values
                (pn_cta, pn_ope, 9, SYSDATE);
              commit;
          end;
      end;

      ld_fecsbs := last_day(ld_aofval);
      ld_fecant := ld_aofe - 1;
      begin
        select /*+index(a FSH01204)*/
               a.bcgpo
          into ln_grup
          from fsh012 a
         where a.bcemp = pn_emp
           and a.bcsuc = pn_suc
           and a.bcrubr in
               (select rubro from fsd014 a where pcnivc = pn_mod)
           and a.bcmda = pn_mda
           and a.bcpap = pn_pap
           and a.bccta = pn_cta
           and a.bcoper = pn_ope
           and a.bcsbop = pn_sbo
           and a.bctop = pn_top
           and a.bcfech = ld_fecant
           and a.bcmod = pn_mod
           and rownum = 1;
      exception
        when no_data_found then

          begin
            select /*+index(a FSH01204)*/
                   a.bcgpo
              into ln_grup
              from fsh012 a
             where a.bcemp = pn_emp
               and a.bcsuc = pn_suc
               and a.bcrubr in
                   (select rubro from fsd014 a where pcnivc = pn_mod)
               and a.bcmda = pn_mda
               and a.bcpap = pn_pap
               and a.bccta = pn_cta
               and a.bcoper = pn_ope
               and a.bcsbop = pn_sbo
               and a.bctop = pn_top
               and a.bcfech = ld_fecsbs
               and a.bcmod = pn_mod
               and rownum = 1;
          exception
            when no_data_found then
              ln_grup := null;
            when others then
              null;

          end;
        when others then
          null;
      end;
    end if;

    return ln_grup;

  end Fn_tipoSBS;
  ------------------------------------------------------------------------------------
  procedure sp_tipoSBS(pn_emp  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_ope  in number,
                       pn_sbo  in number,
                       pn_top  in number,
                       ln_grup out number) is

  begin
    ln_grup := pq_cr_tramdesgra.Fn_tipoSBS(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top);

    null;
  end sp_tipoSBS;

  -------------------------------------------------------------------------------

  Function fn_prima_calculada(pn_mda in number,
                              pn_mto in number,
                              pn_tas in number,
                              pn_emp in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number is
    ln_mto     number(17, 2);
    ln_periodo number(5);
    ln_mul     number(3);
  begin
    begin
      select aoperiod
        into ln_periodo
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    exception
      when no_data_found then
        null;
    end;

    begin
      if pn_mda = 0 then
        ln_mto := (pn_mto * pn_tas) / 100;
        if ln_mto < 1 then
          ln_mto := 1;
        end if;

      else
        ln_mto := (pn_mto * pn_tas) / 100;
        if ln_mto < 0.35 then
          ln_mto := 0.35;
        end if;
      end if;
    end;

    case
      when ln_periodo between 60 and 89 then
        ln_mul := round(ln_periodo / 30, 0);
      when ln_periodo between 90 and 119 then
        ln_mul := round(ln_periodo / 30, 0);
      when ln_periodo >= 120 then
        ln_mul := round(ln_periodo / 30, 0);
      else
        ln_mul := 1;
    end case;
    ln_mto := ln_mto * ln_mul;

    return ln_mto;
  end fn_prima_calculada;

  Function Fn_montoDes(pn_emp    in number,
                       pn_mod    in number,
                       pn_suc    in number,
                       pn_mda    in number,
                       pn_pap    in number,
                       pn_cta    in number,
                       pn_ope    in number,
                       pn_sbo    in number,
                       pn_top    in number,
                       pd_fecpro in date) return number is

    ld_evento date;
    ln_mtoPag number(17, 2);
    ln_mtoFin number(17, 2);
    ln_mtodes number(17, 2);
    ld_fecaux date;
    ln_mtoAux number(17, 2);
    lc_flag   char(1);
    segplus   number:=0;
    montodes  number(17,2):=0;

    cursor transacciones is
      select n.tp1nro1, tp1nro2
        from fst198 n
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 7
         and tp1corr2 = 1;

  begin
    begin
      select a.aoimp
        into ln_mtodes
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    exception
      when no_data_found then
        ln_mtodes := null;
    end;

    -----------------------------------------------------------
    begin
      select a.evfval
        into ld_evento
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
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
        insert into jaqz097_error values (pn_cta, pn_ope, 78, SYSDATE);
        commit;
    end;

    if ld_evento is not null then

      begin
        select a.pp1cap
          into ln_mtoAux
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
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
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.d602fc = ld_evento
               and a.d602co = 'S'
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
      begin
        select min(a.ppfpag)
          into ld_fecaux
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag > ld_evento
           and a.d601co = 'S';

      exception
        when too_many_rows then
          begin
            select min(a.ppfpag)
              into ld_fecaux
              from fsd601 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.ppfpag > ld_evento
               and a.d601co = 'S'
               and rownum = 1;

          exception
            when others then
              null;

          end;
        when others then
          null;

      end;

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
    if segplus = 1 then
      ln_mtoFin := montoDes;
    end if ;

    return ln_mtoFin;
  end Fn_montoDes;

  Procedure Sp_Cuota_Vencer(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pd_fec    out date) is

  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into pd_fec
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_ope
         and n.ppsbop = pn_sbo
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when too_many_rows then
        begin
          select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
            into pd_fec
            from fsd601 n
           where n.pgcod = pn_emp
             and n.ppcta = pn_cta
             and n.ppmda = pn_mda
             and n.ppsuc = pn_suc
             and n.pppap = pn_pap
             and n.ppoper = pn_ope
             and n.ppsbop = pn_sbo
             and n.pptope = pn_top
             and n.ppmod = pn_mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and not exists (select /*+ parallel(o,2,1)*/
                   ppmod, ppcta, ppoper, pptope, ppfpag
                    from fsd602 o
                   where o.pgcod = n.pgcod
                     and o.ppmod = n.ppmod
                     and o.ppsuc = n.ppsuc
                     and o.ppmda = n.ppmda
                     and o.pppap = n.pppap
                     and o.ppcta = n.ppcta
                     and o.ppoper = n.ppoper
                     and o.ppsbop = n.ppsbop
                     and o.pptope = n.pptope
                     and o.ppfpag = n.ppfpag
                        --and o.ppfpag  <= pd_fecpro
                     and o.pp1fech <= pd_fecpro
                     and o.pp1stat = 'T'
                     and o.d602co = 'S'
                     and (o.pp1cap + o.pp1int) <> 0)
             and rownum = 1;
        exception
          when others then
            null;

        end;
      when others then
        null;
    end;

  end Sp_Cuota_Vencer;

  Function Fn_tipoSBS_2(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number) return char is

    ln_ins    number(10);
    lc_tip    char(30);
    ln_sucAct number(3);
  begin
    ln_ins := fn_instancia_credito(pn_mod,
                                   pn_suc,
                                   pn_mda,
                                   pn_pap,
                                   pn_cta,
                                   pn_ope,
                                   pn_sbo,
                                   pn_top);
    if nvl(ln_ins, 0) = 0 then
      begin
        select a.aosuc
          into ln_sucAct
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      exception
        when others then
          null;
      end;
      ln_ins := fn_instancia_credito(pn_mod,
                                     ln_sucAct,
                                     pn_mda,
                                     pn_pap,
                                     pn_cta,
                                     pn_ope,
                                     pn_sbo,
                                     pn_top);

    else
      ln_sucAct := pn_suc;
    end if;
    begin
      select upper(substr(wfattsval,
                          instr(wfattsval, ';', 1) + 1,
                          length(trim(wfattsval)))) --a.wfattsval
        into lc_tip
        from wfattsvalues a
       where a.wfinsprcid = ln_ins
         and a.wfattsid = 'TIPO_CREDITO';
    exception
      when too_many_rows then
        begin
          select upper(substr(wfattsval,
                              instr(wfattsval, ';', 1) + 1,
                              length(trim(wfattsval)))) --a.wfattsval
            into lc_tip
            from wfattsvalues a
           where a.wfinsprcid = ln_ins
             and a.wfattsid = 'TIPO_CREDITO'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;

    return lc_tip;

  end Fn_tipoSBS_2;

  ------------------------------------------------------------------------------------------

  procedure sp_tipoSBS_2(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         lc_tip out char) is

  begin
    lc_tip := pq_cr_tramdesgra.Fn_tipoSBS_2(pn_emp,
                                            pn_mod,
                                            pn_suc,
                                            pn_mda,
                                            pn_pap,
                                            pn_cta,
                                            pn_ope,
                                            pn_sbo,
                                            pn_top);

    null;

  end sp_tipoSBS_2;

  ------------------------------------------------------------------------

  Procedure Sp_TipPago(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec in date) is

    lv_flag varchar2(1);
  begin
    lv_flag := 'C';
    begin
      select 'P'
        into lv_flag
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec;
    exception
      when others then
        insert into jaqz097_error values (pn_cta, pn_ope, 3, SYSDATE);
        commit;
    end;

  end Sp_TipPago;

  -------------------------------------------------------------------------------
  Function Fn_tipoSBS_Des(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number is

    ln_ins    number(10);
    ln_tip    number(5);
    ln_sucAct number(3);
  begin
    ln_ins := fn_instancia_credito(pn_mod,
                                   pn_suc,
                                   pn_mda,
                                   pn_pap,
                                   pn_cta,
                                   pn_ope,
                                   pn_sbo,
                                   pn_top);
    if nvl(ln_ins, 0) = 0 then
      begin
        select a.aosuc
          into ln_sucAct
          from fsd010 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      exception
        when others then
          null;
      end;
      ln_ins := fn_instancia_credito(pn_mod,
                                     ln_sucAct,
                                     pn_mda,
                                     pn_pap,
                                     pn_cta,
                                     pn_ope,
                                     pn_sbo,
                                     pn_top);

    else
      ln_sucAct := pn_suc;
    end if;
    begin
      select substr(wfattsval, 1, instr(wfattsval, ';', 1) - 1) --a.wfattsval
        into ln_tip
        from wfattsvalues a
       where a.wfinsprcid = ln_ins
         and a.wfattsid = 'TIPO_CREDITO';
    exception
      when too_many_rows then
        begin
          select substr(wfattsval, 1, instr(wfattsval, ';', 1) - 1) --a.wfattsval
            into ln_tip
            from wfattsvalues a
           where a.wfinsprcid = ln_ins
             and a.wfattsid = 'TIPO_CREDITO'
             and rownum = 1;
        exception
          when others then
            null;

        end;
      when others then
        null;
    end;

    return ln_tip;

  end Fn_tipoSBS_Des;
  ----------------------------------------------------------------------------------------------
  Function Fn_montoPag_calendario(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_ope    in number,
                                  pn_sbo    in number,
                                  pn_top    in number,
                                  pd_Fecpro in date,
                                  pn_mto    in number,
                                  pn_ord    in number) return varchar2 is

    ld_fecini date;

    ln_mtopag number(17, 2);
    ln_mto11  number(17, 2);
    ln_mto12  number(17, 2);
    ln_mto13  number(17, 2);
    ln_mto14  number(17, 2);
    ln_mto15  number(17, 2);
    lc_ind    varchar2(1);

  begin

    ld_fecini := TRUNC(pd_fecpro, 'MM');--- to_date('01' || to_char(pd_fecpro, 'mmyyyy'), 'ddmmyyyy');

    begin

      begin
        select sum(a.pp1imp11),
               sum(a.pp1imp12),
               sum(a.pp1imp13),
               sum(a.pp1imp14),
               sum(a.pp1imp15)
          into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
          from fsd612 a, fsd602 b
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.pgcod = b.pgcod
           and a.ppmod = b.ppmod
           and a.ppsuc = b.ppsuc
           and a.ppmda = b.ppmda
           and a.pppap = b.pppap
           and a.ppcta = b.ppcta
           and a.ppoper = b.ppoper
           and a.ppsbop = b.ppsbop
           and a.pptope = b.pptope
           and a.ppfpag = b.ppfpag
           and a.pp1nump = b.pp1nump
           and b.d602co = 'S'
           and a.ppfpag =  pd_fecpro; ---between ld_fecini and pd_fecpro; sma.14/10/2019
      exception
        when others then
          null;
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
          else
            ln_mtopag := 0;
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

  Procedure Sp_Primera_Cuota(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pd_fec    out date) is

  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into pd_fec
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_ope
         and n.ppsbop = pn_sbo
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0;
    exception
      when too_many_rows then
        begin
          select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
            into pd_fec
            from fsd601 n
           where n.pgcod = pn_emp
             and n.ppcta = pn_cta
             and n.ppmda = pn_mda
             and n.ppsuc = pn_suc
             and n.pppap = pn_pap
             and n.ppoper = pn_ope
             and n.ppsbop = pn_sbo
             and n.pptope = pn_top
             and n.ppmod = pn_mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and rownum = 1;
        exception
          when others then
            null;

        end;
      when others then
        null;
    end;

  end Sp_Primera_Cuota;

  Function Fn_cr_estado(pn_emp    in number,
                        pn_mod    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fecpro in date) return char is

    lc_flg  char(1) := 'N';
    lc_flg1 char(1) := 'N';
    lc_flg2 char(1) := 'N';

  begin

    begin
      select 'S'
        into lc_flg1
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aomod in (select modulo from fst111 where dscod = 50)
         and a.aostat in (23, 25, 64, 90)
         and rownum = 1;
    exception
      when others then
        lc_flg1 := 'N';
    end;

    begin
      select 'S'
        into lc_flg2
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.aostat = 99
         and a.aofe99 <= pd_fecpro
         and rownum = 1;
    exception
      when others then
        lc_flg2 := 'N';
    end;

    if lc_flg1 = 'S' and lc_flg2 = 'S' then
      lc_flg := 'S';
    end if;

    return lc_flg;

  end Fn_cr_estado;
  --************SMARQUEZ Seguro Plus***********************
  Function Fn_cr_SegPlus (pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number) return number is
 segplus number:= 0;
  Begin

    Begin
      select 1
        into segplus
        from fpp001 p
       where p.pgcod = pn_emp
         and p.aomod = pn_mod
         and p.aosuc = pn_suc
         and p.aomda = pn_mda
         and p.aopap = pn_pap
         and p.aocta = pn_cta
         and p.aooper = pn_ope
         and p.aosbop = pn_sbo
         and p.aotope = pn_top
         and p.sgcod in (SELECT sgcod
                           FROM FST300
                          WHERE SGSN02 = 5
                            and sgcod between 330 and 338);

    exception
      when no_data_found then segplus := 0;
      when others then segplus := 0;
    end;
     return segplus ;
  end Fn_cr_SegPlus;
  -- Adicion de funcion de LLLOSA sma 20200227
  function fn_dias_atraso(v_Pgfape in date, --fecha de proceso
                           v_Pgcod  in number,
                           v_Scmod  in number,
                           v_Scsuc  in number,
                           v_Scmda  in number,
                           v_Scpap  in number,
                           v_Sccta  in number,
                           v_Scoper in number,
                           v_Scsbop in number,
                           v_Sctope in number,
                       --    v_Scstat in number,
                           v_fecven in date) return number is

    ln_diatr number;
   -- ln_scstat fsd010.aostat%type;
  begin

     --If v_Scstat in (64,90) Then
    If v_Scmod in (200,33,141) Then   --se agrego carta fianza

       ln_diatr := v_Pgfape - v_fecven;

       If ln_diatr < 0 then
          ln_diatr := 0 ;
       End if;

    Else
        begin
          --vigente y refinanciado
          SELECT (v_Pgfape - min(a.Ppfpag))
            into ln_diatr
            FROM FSD601 a
            left join FSD602 b on b.Pgcod = a.Pgcod
                              and b.Ppmod = a.Ppmod
                              and b.Ppsuc = a.Ppsuc
                              and b.Ppmda = a.Ppmda
                              and b.Pppap = a.Pppap
                              and b.Ppcta = a.Ppcta
                              and b.Ppoper = a.Ppoper
                              and b.Ppsbop = a.Ppsbop
                              and b.Pptope = a.Pptope
                              and b.Ppfpag = a.Ppfpag
                              and b.Pptipo = a.Pptipo
                              and b.Pp1stat = 'T'
                              and b.D602co = 'S'
                                 --and b.pptipo  <> 'K'
                              and b.pp1fech <= v_Pgfape
           where a.Pgcod = v_Pgcod
             and a.Ppmod = v_Scmod
             and a.Ppsuc = v_Scsuc
             and a.Ppmda = v_Scmda
             and a.Pppap = v_Scpap
             and a.Ppcta = v_Sccta
             and a.Ppoper = v_Scoper
             and a.Ppsbop = v_Scsbop
             and a.Pptope = v_Sctope
             and a.Ppfpag <= v_Pgfape
             and a.D601co = 'S'
             and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
             and b.D602co is null;
        exception
          when no_data_found then

            Begin
              select (v_Pgfape - min(d.Ppfpag))
                into ln_diatr
                from fsd601 d
               where d.Pgcod = v_Pgcod
                 and d.Ppmod = v_Scmod
                 and d.Ppsuc = v_Scsuc
                 and d.Ppmda = v_Scmda
                 and d.Pppap = v_Scpap
                 and d.Ppcta = v_Sccta
                 and d.Ppoper = v_Scoper
                 and d.Ppsbop = v_Scsbop
                 and d.Pptope = v_Sctope
                 and d.Ppfpag <= v_Pgfape
                 and (d.ppcap + d.ppint) > 0;
            exception
                when no_data_found then
                     ln_diatr := null;
            End;
        end;
    End IF;
  return(NVL(ln_diatr,0));
end fn_dias_atraso;
-- sma 15/04/2020 registro de datos erroneos
procedure SP_Logs(v_Pgfape in date )is
  cursor logs is
    select *
        from jaqz085_aux
    minus
    select a.*
        from jaqz085_aux a,
             fpp001 b
       where b.pgcod = a.jaqz085emp
         and b.aomod = a.jaqz085mod
         and b.aosuc = a.jaqz085suc
         and b.aomda = a.jaqz085mda
         and b.aopap = a.jaqz085pap
         and b.aocta = a.jaqz085cta
         and b.aooper = a.jaqz085ope
         and b.aosbop = a.jaqz085sbo
         and b.aotope = a.jaqz085top
         and b.sgcod  = a.jaqz085seg;
  cursor duplicados is
    select count(*),jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top
      from  Jaqz085
      group by jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top
      having count(*)>1;

hora char(8);
ld_fecha date;
Begin

  ld_fecha := v_Pgfape;
  For r in logs loop
    begin
      hora := TO_CHAR(sysdate,'HH24:MI:SS');
      insert into jaqz589(jaqz589cod,
                           jaqz589mod,
                           jaqz589suc,
                           jaqz589mda,
                           jaqz589pap,
                           jaqz589cta,
                           jaqz589oper,
                           jaqz589sbo,
                           jaqz589top,
                           jaqz589seg,
                           jaqz589motivo,
                           jaqz589fec,
                           jaqz589hora,
                           jaqz589usr,
                           jaqz589au1,
                           jaqz589au5 )
                  values (r.jaqz085emp,
                          r.jaqz085mod,
                          r.jaqz085suc,
                          r.jaqz085mda,
                          r.jaqz085pap,
                          r.jaqz085cta,
                          r.jaqz085ope,
                          r.jaqz085sbo,
                          r.jaqz085sbo,
                          r.jaqz085seg,
                          '1.No corresponde',
                          trunc(sysdate),
                          hora,
                          'prueba',
                          1,
                          ld_fecha);
                          commit;
    exception
      when dup_val_on_index then
        null;

    end;
  end loop;

end SP_Logs;

Procedure valida_Tasa(v_Pgcod  in number,
                      v_Scmod  in number,
                      v_Scsuc  in number,
                      v_Scmda  in number,
                      v_Scpap  in number,
                      v_Sccta  in number,
                      v_Scoper in number,
                      v_Scsbop in number,
                      v_Sctope in number,
                      v_segcod in number,
                      v_mtoapr in number, -- monto prima
                      v_tasa   in number,
                      v_mtodes in number,
                      v_plan   in CHAR,
                      v_fecha  in date,
                      v_desem  in date,--fechapago
                      v_fpago  in date,
                      tasa     out number) is

ln_saldo number(17,2):=0;
sobreprima number(10,6);
ld_fechanew date;
prima15 number(17,2);
prima14 number(17,2);
prima13 number(17,2);
prima12 number(17,2);
prima11 number(17,2);
prima number(17,2);
prima01 number (17,2);
prima05 number (17,2);
faofval date;
periodo number;

Begin
  --- verificacion de sobreprima/tasa 0 sma 15/04/2020

         Select min(ppfpag)
           into ld_fechanew
           from fsd601
          where pgcod = v_Pgcod
            and ppmod = v_Scmod
            and ppsuc = v_Scsuc
            and ppmda = v_Scmda
            and pppap = v_Scpap
            and ppcta = v_Sccta
            and ppoper = v_Scoper
            and ppsbop = v_Scsbop
            and pptope = v_Sctope
            and ppfpag > v_fpago;

            Begin --periodo
              select aofval, aoperiod
               into faofval, periodo
               from fsd010
               where pgcod =  v_Pgcod
                 and aomod =  v_Scmod
                 and aosuc =  v_Scsuc
                 and aomda =  v_Scmda
                 and aopap =  v_Scpap
                 and aocta =  v_Sccta
                 and aooper =  v_Scoper
                 and aosbop =  v_Scsbop
                 and aotope =  v_Sctope;
            exception
              when no_data_found then
                faofval := null;
                periodo :=0;
            end;


           prima15 := 0;
           prima14 := 0;
           prima13 := 0;
           prima12 := 0;
           prima11 := 0;
           prima := 0;
       if  ld_fechanew   is not null then
          Select sum(ppcap)--min(ppfpag)
           into ln_saldo --ld_fechanew
           from fsd601
          where pgcod = v_Pgcod
            and ppmod = v_Scmod
            and ppsuc = v_Scsuc
            and ppmda = v_Scmda
            and pppap = v_Scpap
            and ppcta = v_Sccta
            and ppoper = v_Scoper
            and ppsbop = v_Scsbop
            and pptope = v_Sctope
            and ppfpag >= ld_fechanew ;

         begin
           Select ppimp15, ppimp14, ppimp13, ppimp12, ppimp11
             into prima15, prima14, prima13, prima12, prima11
             from fsd611
            where pgcod = v_Pgcod
              and ppmod = v_Scmod
              and ppsuc = v_Scsuc
              and ppmda = v_Scmda
              and pppap = v_Scpap
              and ppcta = v_Sccta
              and ppoper = v_Scoper
              and ppsbop = v_Scsbop
              and pptope = v_Sctope
              and ppfpag = ld_fechanew
              and rownum = 1;
         exception
           when no_data_found then
                Select min(ppfpag)
                 into ld_fechanew
                 from fsd601
                where pgcod = v_Pgcod
                  and ppmod = v_Scmod
                  and ppsuc = v_Scsuc
                  and ppmda = v_Scmda
                  and pppap = v_Scpap
                  and ppcta = v_Sccta
                  and ppoper = v_Scoper
                  and ppsbop = v_Scsbop
                  and pptope = v_Sctope
                  and ppfpag > ld_fechanew;

               Select sum(ppcap)--min(ppfpag)
                 into ln_saldo-- ld_fechanew
                 from fsd601
                where pgcod = v_Pgcod
                  and ppmod = v_Scmod
                  and ppsuc = v_Scsuc
                  and ppmda = v_Scmda
                  and pppap = v_Scpap
                  and ppcta = v_Sccta
                  and ppoper = v_Scoper
                  and ppsbop = v_Scsbop
                  and pptope = v_Sctope
                  and ppfpag >= ld_fechanew ;

               begin
                 Select ppimp15, ppimp14, ppimp13, ppimp12, ppimp11
                   into prima15, prima14, prima13, prima12, prima11
                   from fsd611
                  where pgcod = v_Pgcod
                    and ppmod = v_Scmod
                    and ppsuc = v_Scsuc
                    and ppmda = v_Scmda
                    and pppap = v_Scpap
                    and ppcta = v_Sccta
                    and ppoper = v_Scoper
                    and ppsbop = v_Scsbop
                    and pptope = v_Sctope
                    and ppfpag = ld_fechanew
                    and rownum = 1;
               exception
                 when no_data_found then
                    null;
               end;
             end;
       else
         Select sum(ppcap)--min(ppfpag)
           into ln_saldo-- ld_fechanew
           from fsd601
          where pgcod = v_Pgcod
            and ppmod = v_Scmod
            and ppsuc = v_Scsuc
            and ppmda = v_Scmda
            and pppap = v_Scpap
            and ppcta = v_Sccta
            and ppoper = v_Scoper
            and ppsbop = v_Scsbop
            and pptope = v_Sctope
            and ppfpag = v_fpago ;
         begin
           Select ppimp15, ppimp14, ppimp13, ppimp12, ppimp11
             into prima15, prima14, prima13, prima12, prima11
             from fsd611
            where pgcod = v_Pgcod
              and ppmod = v_Scmod
              and ppsuc = v_Scsuc
              and ppmda = v_Scmda
              and pppap = v_Scpap
              and ppcta = v_Sccta
              and ppoper = v_Scoper
              and ppsbop = v_Scsbop
              and pptope = v_Sctope
              and ppfpag = v_fpago
              and rownum = 1;
           exception
           when no_data_found then
             null;
         end;
        end if;
        --------------nuevas tasas sma 10/12/2024------------------------------------
        if v_desem < '17/10/2024' then
            if prima15 <> 0 then
              prima := prima15;
            elsif prima14 <> 0 then
              prima := prima14;
            elsif prima13 <> 0 then
              prima := prima13;
            elsif prima12 <> 0 then
              prima := prima12;
            elsif prima11 <> 0 then
              prima := prima11;
            end if;

            if v_segcod between 330 and 338 then
              ln_saldo := v_mtoapr;
            end if;

            prima01 := round(((ln_saldo * 0.1)/100),2);
            if prima01 >0 and prima01 < 1 then
                Prima01 := 1;
            end if;

            prima05 := round(((ln_saldo * 0.05)/100),2);
            if prima05 > 0 and prima05 < 1 then
                Prima05 := 1;
            end if;

            if prima01 = prima then
              tasa := 0.1;
            else
              if prima05 = prima then
                 tasa := 0.05;
              else
        --        if periodo <> 30  then -- controlar
                   if mod(prima, prima01) = 0 then
                     tasa := 0.1;
                   else
                      if mod(prima, prima05) = 0 then
                         tasa := 0.05;
                      else
                      Begin

                          select cotasap
                            into sobreprima
                            from fsp026
                           where Pgcod = v_Pgcod
                             and Comod = v_Scmod
                             and Cocod = (select sgcd03 from fst300 where sgcod = v_segcod)
                             and Cocta = v_Sccta
                             and Copap = v_Scpap
                             and Comda = v_Scmda
                             and cofech >= ( select max(aofval)  from fsd010
                                               where pgcod =  v_Pgcod
                                                 and aomod =  v_Scmod
                                                 and aosuc =  v_Scsuc
                                                 and aomda =  v_Scmda
                                                 and aopap =  v_Scpap
                                                 and aocta =  v_Sccta
                                                 and aooper =  v_Scoper
                                                 and aosbop =  v_Scsbop
                                                 and aotope =  v_Sctope) ;
                              tasa := sobreprima;
                        exception
                          when no_Data_Found then
                            if v_tasa is not null and (v_tasa <> 0) then
                               tasa:= v_tasa;
                            else
                                tasa:= 0.1;
                            end if;

                          when too_many_rows then
                             Begin
                               select cotasap
                                  into sobreprima
                                  from fsp026
                                 where Pgcod = v_Pgcod
                                   and Comod = v_Scmod
                                   and Cocod = (select sgcd03 from fst300 where sgcod = v_segcod)
                                   and Cocta = v_Sccta
                                   and Copap = v_Scpap
                                   and Comda = v_Scmda
                                   and cofech = (select Max(cofech)
                                                    from fsp026
                                                   where Pgcod = v_Pgcod
                                                     and Comod = v_Scmod
                                                     and Cocod = (select sgcd03 from fst300 where sgcod = v_segcod)
                                                     and Cocta = v_Sccta
                                                     and Copap = v_Scpap
                                                     and Comda = v_Scmda)
                                   and rownum = 1;

                                   tasa := sobreprima;
                              exception
                                when others then
                                  if v_tasa is not null and (v_tasa <> 0) then
                                     tasa:= v_tasa;
                                  else
                                      tasa:= 0.1;
                                  end if;
                              end;
                        end;
                     end if;
                  end if;
           --    end if;

              end if;
            end if;
      else --inicio cambi
        PQ_CR_SEGURO_DESGRAVAMEN.sp_TASA_DESGRAVAMEN(v_Pgcod,v_Scmod,v_Scsuc,v_scmda,v_Scpap,v_Sccta, v_Scoper,v_Scsbop,v_Sctope,v_mtodes,tasa);
      end if;

end valida_tasa;

procedure SP_Logs_2( v_Pgfape in date) is
  cursor duplicados is
    select count(*),jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top
      from  Jaqz085
      group by jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top
      having count(*)>1;

   cursor verificacion (pemp in number, pmod in number,psuc in number, pmda in number,
    ppap in number, pcta in number, pope in number, psbo in number, ptop in number) is
     select jaqz085aux1
       from jaqz085
      where jaqz085emp = pemp
        and jaqz085mod = pmod
        and jaqz085suc = psuc
        and jaqz085mda = pmda
        and jaqz085pap = ppap
        and jaqz085cta = pcta
        and jaqz085ope = pope
        and jaqz085sbo = psbo
        and jaqz085top = ptop;

hora char(8);
seguro number := 0;
cont number;
flag char(1);
ld_fecha date;
Begin

  ld_fecha := v_Pgfape;
  For r in duplicados loop
    cont := 0;
    flag := 'N' ;
    For s in verificacion(r.jaqz085emp,r.jaqz085mod,r.jaqz085suc,
      r.jaqz085mda,r.jaqz085pap,r.jaqz085cta,r.jaqz085ope,r.jaqz085sbo,r.jaqz085top) loop
      if cont= 0 then
       seguro := s.jaqz085aux1;
      else
        if seguro <> s.jaqz085aux1 then
          flag := 'S';
          exit;
        end if;
      end if ;
      cont := cont + 1;
    End loop;
    if flag = 'S' then
      begin
        hora := TO_CHAR(sysdate,'HH24:MI:SS');
        insert into jaqz589(jaqz589cod,
                             jaqz589mod,
                             jaqz589suc,
                             jaqz589mda,
                             jaqz589pap,
                             jaqz589cta,
                             jaqz589oper,
                             jaqz589sbo,
                             jaqz589top,
                             jaqz589seg,
                             jaqz589motivo,
                             jaqz589fec,
                             jaqz589hora,
                             jaqz589usr,
                             jaqz589au1,
                             jaqz589au5 )
                    values (r.jaqz085emp,
                            r.jaqz085mod,
                            r.jaqz085suc,
                            r.jaqz085mda,
                            r.jaqz085pap,
                            r.jaqz085cta,
                            r.jaqz085ope,
                            r.jaqz085sbo,
                            r.jaqz085sbo,
                            500,
                            '5.Duplicados/2 seg.',
                            trunc(sysdate),
                            hora,
                            'prueba',
                            5,
                            ld_fecha);
                            commit;
      exception
        when dup_val_on_index then
          null;
      end;
    end if;
  end loop;
end SP_Logs_2;
Procedure ReprogramacionCovid(v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             v_fecha  in date,
                             v_instancia in number,
                             v_dato   out varchar2,
                             lc_ajuste out varchar2)is
tipoRE char(2);
fechaini date;
fechafin date;
descripcion varchar2(10);
tipo1 number:= 0;
Begin
  fechaini := TRUNC(v_fecha,'MM');
  fechafin := v_fecha;
  Begin
    select 'RM', 1
      into tipoRE,tipo1
      from aqpb002 a
     where aqpb002fep > to_date('30/03/2020','dd/mm/yyyy') --and fechafin
       and a.aqpb002emp = v_Pgcod
       and a.aqpb002mod = v_Scmod
       and a.aqpb002suc = v_Scsuc
       and a.aqpb002mda = v_Scmda
       and a.aqpb002pap = v_Scpap
       and a.aqpb002cta = v_Sccta
       and a.aqpb002ope = v_Scoper
       and a.aqpb002sbo = v_Scsbop
       and a.aqpb002top = v_Sctope
       and a.aqpb002est = 'C'
       and nvl(a.aqpb002revr, 'N')  <> 'S'
       and rownum = 1;-- reprogramacion masiva
  exception
    when no_data_found then
      tipo1 := 0;
      Begin
        select 'RF',2
          into tipoRE,tipo1
          from sng001 s
         where s.sng001inst = v_instancia
           and s.sng014cod = 4
           and s.sng001fin > to_Date('01/01/2020','dd/mm/yyyy')
           and s.sng001ori =14
           and rownum = 1; --reprogramacion por el flujo
      exception
        when no_data_found then
          begin
             select 'RM',3
               into tipoRE, tipo1
               from jaqz698
              where jaqz698fep > to_Date('23/03/2020','dd/mm/yyyy')
                and jaqz698emp = v_Pgcod
                AND jaqz698mod = v_Scmod
                and jaqz698suc = v_Scsuc
                and jaqz698mda = v_Scmda
                and jaqz698pap = v_Scpap
                and jaqz698cta = v_Sccta
                and jaqz698ope = v_Scoper
                and jaqz698sbo = v_Scsbop
                and jaqz698top = v_Sctope
                AND jaqz698est in ('X','C')
                and rownum = 1;
          exception
            when no_data_found then
              Begin
                 select 'RM',4
                   into tipoRE, tipo1
                   from aqpa833
                  where bccta  = v_Sccta
                    and bcoper  = v_Scoper
                    and bcsbop  = v_Scsbop
                    and extorno ='NO';
              exception
                when no_data_found then
                tipoRE:= 'NO'; -- no reprogramado
             end;
          end;

      End;
  End;

  Begin
    select 'C/Ajuste'
      into lc_ajuste
      from jaqa250
     where jaqa250emp = v_Pgcod
       and jaqa250mod = v_Scmod
       and jaqa250suc = v_Scsuc
       and jaqa250mda = v_Scmda
       and jaqa250pap = v_Scpap
       and jaqa250cta = v_Sccta
       and jaqa250ope = v_Scoper
       and jaqa250sbo = v_Scsbop
       and jaqa250tpo = v_Sctope
       and jaqa250est = 'S'
       and rownum = 1;
  exception
    when no_data_found then
      if Tipo1 = 1 then
        lc_ajuste := 'Congelado';
      end if;
      if tipo1 = 2 then
        lc_ajuste := 'Flujo';
      end if;
      if Tipo1 = 3 then
        lc_ajuste := 'Capitalizacion';
      end if;
       if Tipo1 = 4 then
        lc_ajuste := 'Sin Capitalizacion';
      end if;
  end;

  v_dato:= tipoRE;

end ReprogramacionCovid;
Procedure Actualiza_ln_mtoCalen(v_Pgcod  in number,
                                v_Scmod  in number,
                                v_Scsuc  in number,
                                v_Scmda  in number,
                                v_Scpap  in number,
                                v_Sccta  in number,
                                v_Scoper in number,
                                v_Scsbop in number,
                                v_Sctope in number,
                                v_tipo   in varchar2,
                                v_monto  in number,
                                v_fecha  in date,
                                v_cuotauno in date,
                                ln_mtoCalen out number,
                                v_fproxpag  out date,
                                ln_montoNew out number)is

ld_fecha date;
ld_fecha1 date;
ln_mto11 number(17,2) := 0;
ln_mto12 number(17,2) := 0;
ln_mto13 number(17,2) := 0;
ln_mto14 number(17,2) := 0;
ln_mto15 number(17,2) := 0;
fechaini date;
fechafin date;
existe   number:= 0;
begin
 ln_mtoCalen := 0;
 v_fproxpag := null;
 fechaini := TRUNC(v_fecha,'MM');
 fechafin := v_fecha;
 Begin
    select 1
      into existe
      from fsd611
     where PGCOD = v_Pgcod
       and PPMOD = v_Scmod
       and PPSUC = v_Scsuc
       and PPMDA = v_Scmda
       and PPPAP = v_Scpap
       and PPCTA = v_Sccta
       and PPOPER = v_Scoper
       and PPSBOP = v_Scsbop
       and PPTOPE = v_Sctope
       and ppfpag between fechaini and fechafin
       AND rownum = 1;
 Exception
   when no_data_found then
     existe := 0;
 end;

 if v_tipo ='P' then
   if  existe = 1 then
     ln_montoNew := v_monto;
   else
     ln_montoNew := 0;
   end if;
 else  ---vtipo 'C' solidario

   select max(ppfpag)
      into ld_fecha
      from fsd612
     where PGCOD = v_Pgcod
       and PPMOD = v_Scmod
       and PPSUC = v_Scsuc
       and PPMDA = v_Scmda
       and PPPAP = v_Scpap
       and PPCTA = v_Sccta
       and PPOPER = v_Scoper
       and PPSBOP = v_Scsbop
       and PPTOPE = v_Sctope
       and ppfpag between  fechaini and fechafin ; -- existe
    if ld_fecha is null then --no existe
       ln_montoNew := 0;
        select max(ppfpag)
          into ld_fecha
          from fsd612
         where PGCOD = v_Pgcod
           and PPMOD = v_Scmod
           and PPSUC = v_Scsuc
           and PPMDA = v_Scmda
           and PPPAP = v_Scpap
           and PPCTA = v_Sccta
           and PPOPER = v_Scoper
           and PPSBOP = v_Scsbop
           and PPTOPE = v_Sctope;
        if ld_fecha is null then
            select min(ppfpag)
            into ld_fecha1
            from fsd611
           where PGCOD = v_Pgcod
             and PPMOD = v_Scmod
             and PPSUC = v_Scsuc
             and PPMDA = v_Scmda
             and PPPAP = v_Scpap
             and PPCTA = v_Sccta
             and PPOPER = v_Scoper
             and PPSBOP = v_Scsbop
             and PPTOPE = v_Sctope;

             v_fproxpag := ld_fecha1;

             if ld_fecha1 = v_cuotauno then --sma16052022
                select min(ppfpag)
                  into ld_fecha1
                  from fsd611
                 where PGCOD = v_Pgcod
                   and PPMOD = v_Scmod
                   and PPSUC = v_Scsuc
                   and PPMDA = v_Scmda
                   and PPPAP = v_Scpap
                   and PPCTA = v_Sccta
                   and PPOPER = v_Scoper
                   and PPSBOP = v_Scsbop
                   and PPTOPE = v_sctope
                   and ppfpag > ld_fecha1;
                   v_fproxpag := ld_fecha1;
             end if;

             select sum(ppimp11),
                   sum(ppimp12),
                   sum(ppimp13),
                   sum(ppimp14),
                   sum(ppimp15)
              into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
              from fsd611 a
              where PGCOD = v_Pgcod
                and PPMOD = v_Scmod
                and PPSUC = v_Scsuc
                and PPMDA = v_Scmda
                and PPPAP = v_Scpap
                and PPCTA = v_Sccta
                and PPOPER = v_Scoper
                and PPSBOP = v_Scsbop
                and PPTOPE = v_Sctope
                and ppfpag = ld_fecha1;

               if ln_mto15 <> 0 then
                  ln_mtoCalen := ln_mto15;
               else
                 if ln_mto14 <> 0 then
                   ln_mtoCalen := ln_mto14;
                 else
                   if ln_mto13 <> 0 then
                     ln_mtoCalen := ln_mto13;
                   else
                     if ln_mto12 <> 0 then
                       ln_mtoCalen := ln_mto12;
                     else
                       if ln_mto11 <> 0 then
                         ln_mtoCalen := ln_mto11;
                       end if;
                     end if;
                   end if;
                 end if;
               end if;
        else
          select min(ppfpag)
            into ld_fecha1
            from fsd611
           where PGCOD = v_Pgcod
             and PPMOD = v_Scmod
             and PPSUC = v_Scsuc
             and PPMDA = v_Scmda
             and PPPAP = v_Scpap
             and PPCTA = v_Sccta
             and PPOPER = v_Scoper
             and PPSBOP = v_Scsbop
             and PPTOPE = v_Sctope
             and ppfpag > ld_fecha;

             v_fproxpag := ld_fecha1;

          select sum(ppimp11),
                 sum(ppimp12),
                 sum(ppimp13),
                 sum(ppimp14),
                 sum(ppimp15)
            into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
            from fsd611 a
            where a.pgcod = v_Pgcod
             and a.ppmod = v_Scmod
             and a.ppsuc = v_Scsuc
             and a.ppmda = v_Scmda
             and a.pppap = v_Scpap
             and a.ppcta = v_Sccta
             and a.ppoper = v_Scoper
             and a.ppsbop = v_Scsbop
             and a.pptope = v_Sctope
             and a.ppfpag = ld_fecha1;

             if ln_mto15 <> 0 then
                ln_mtoCalen := ln_mto15;
             else
               if ln_mto14 <> 0 then
                 ln_mtoCalen := ln_mto14;
               else
                 if ln_mto13 <> 0 then
                   ln_mtoCalen := ln_mto13;
                 else
                   if ln_mto12 <> 0 then
                     ln_mtoCalen := ln_mto12;
                   else
                     if ln_mto11 <> 0 then
                       ln_mtoCalen := ln_mto11;
                     end if;
                   end if;
                 end if;
               end if;
             end if;
        end if;
   else
      select sum(ppimp11),
               sum(ppimp12),
               sum(ppimp13),
               sum(ppimp14),
               sum(ppimp15)
          into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
          from fsd611 a
          where a.pgcod = v_Pgcod
           and a.ppmod = v_Scmod
           and a.ppsuc = v_Scsuc
           and a.ppmda = v_Scmda
           and a.pppap = v_Scpap
           and a.ppcta = v_Sccta
           and a.ppoper = v_Scoper
           and a.ppsbop = v_Scsbop
           and a.pptope = v_Sctope
           and a.ppfpag = ld_fecha;

           v_fproxpag := ld_fecha;
           if ln_mto15 <> 0 then
              ln_mtoCalen := ln_mto15;
           else
             if ln_mto14 <> 0 then
               ln_mtoCalen := ln_mto14;
             else
               if ln_mto13 <> 0 then
                 ln_mtoCalen := ln_mto13;
               else
                 if ln_mto12 <> 0 then
                   ln_mtoCalen := ln_mto12;
                 else
                   if ln_mto11 <> 0 then
                     ln_mtoCalen := ln_mto11;
                   end if;
                 end if;
               end if;
             end if;
           end if;
          ln_montoNew := ln_mtoCalen;
     end if;

   end if;
end  Actualiza_ln_mtoCalen;
function Actualiza_MontoCalen(v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               v_tipo   in varchar2,
                               v_monto  in number,
                               v_fecha  in date) return number is
ld_fecha date;
ld_fecha1 date;
ln_mto11 number(17,2) := 0;
ln_mto12 number(17,2) := 0;
ln_mto13 number(17,2) := 0;
ln_mto14 number(17,2) := 0;
ln_mto15 number(17,2) := 0;
fechaini date;
fechafin date;
ln_mtoCalen number(17,2) := 0;
begin
 ln_mtoCalen := 0;
 --v_fproxpag := null;
 fechaini := TRUNC(v_fecha,'MM');
 fechafin := v_fecha;

 if v_tipo ='P' then
   ln_mtoCalen := v_monto;
 else
   select min(ppfpag)
      into ld_fecha
      from fsd612
     where PGCOD = v_Pgcod
       and PPMOD = v_Scmod
       and PPSUC = v_Scsuc
       and PPMDA = v_Scmda
       and PPPAP = v_Scpap
       and PPCTA = v_Sccta
       and PPOPER = v_Scoper
       and PPSBOP = v_Scsbop
       and PPTOPE = v_Sctope
       and ppfpag between  fechaini and fechafin;
    if ld_fecha is null then
        select max(ppfpag)
          into ld_fecha
          from fsd612
         where PGCOD = v_Pgcod
           and PPMOD = v_Scmod
           and PPSUC = v_Scsuc
           and PPMDA = v_Scmda
           and PPPAP = v_Scpap
           and PPCTA = v_Sccta
           and PPOPER = v_Scoper
           and PPSBOP = v_Scsbop
           and PPTOPE = v_Sctope;

        select min(ppfpag)
          into ld_fecha1
          from fsd611
         where PGCOD = v_Pgcod
           and PPMOD = v_Scmod
           and PPSUC = v_Scsuc
           and PPMDA = v_Scmda
           and PPPAP = v_Scpap
           and PPCTA = v_Sccta
           and PPOPER = v_Scoper
           and PPSBOP = v_Scsbop
           and PPTOPE = v_Sctope
           and ppfpag >= ld_fecha;

           --v_fproxpag := ld_fecha1;

        select sum(ppimp11),
               sum(ppimp12),
               sum(ppimp13),
               sum(ppimp14),
               sum(ppimp15)
          into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
          from fsd611 a
          where a.pgcod = v_Pgcod
           and a.ppmod = v_Scmod
           and a.ppsuc = v_Scsuc
           and a.ppmda = v_Scmda
           and a.pppap = v_Scpap
           and a.ppcta = v_Sccta
           and a.ppoper = v_Scoper
           and a.ppsbop = v_Scsbop
           and a.pptope = v_Sctope
           and a.ppfpag = ld_fecha1;

           if ln_mto15 <> 0 then
              ln_mtoCalen := ln_mto15;
           else
             if ln_mto14 <> 0 then
               ln_mtoCalen := ln_mto14;
             else
               if ln_mto13 <> 0 then
                 ln_mtoCalen := ln_mto13;
               else
                 if ln_mto12 <> 0 then
                   ln_mtoCalen := ln_mto12;
                 else
                   if ln_mto11 <> 0 then
                     ln_mtoCalen := ln_mto11;
                   end if;
                 end if;
               end if;
             end if;
           end if;
   else
      select sum(ppimp11),
               sum(ppimp12),
               sum(ppimp13),
               sum(ppimp14),
               sum(ppimp15)
          into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
          from fsd611 a
          where a.pgcod = v_Pgcod
           and a.ppmod = v_Scmod
           and a.ppsuc = v_Scsuc
           and a.ppmda = v_Scmda
           and a.pppap = v_Scpap
           and a.ppcta = v_Sccta
           and a.ppoper = v_Scoper
           and a.ppsbop = v_Scsbop
           and a.pptope = v_Sctope
           and a.ppfpag = ld_fecha;

           --v_fproxpag := ld_fecha;
           if ln_mto15 <> 0 then
              ln_mtoCalen := ln_mto15;
           else
             if ln_mto14 <> 0 then
               ln_mtoCalen := ln_mto14;
             else
               if ln_mto13 <> 0 then
                 ln_mtoCalen := ln_mto13;
               else
                 if ln_mto12 <> 0 then
                   ln_mtoCalen := ln_mto12;
                 else
                   if ln_mto11 <> 0 then
                     ln_mtoCalen := ln_mto11;
                   end if;
                 end if;
               end if;
             end if;
           end if;
     end if;
   end if;
   return  ln_mtoCalen;
end Actualiza_MontoCalen;
procedure Valida_Adicionales(v_Pgcod  in number,
                             v_Scmod  in number,
                             v_Scsuc  in number,
                             v_Scmda  in number,
                             v_Scpap  in number,
                             v_Sccta  in number,
                             v_Scoper in number,
                             v_Scsbop in number,
                             v_Sctope in number,
                             v_fecha  in date,
                             v_instancia in number,
                             v_seguro in number,
                             v_tipago in varchar2,
                             v_mtoSA  in number,
                             v_tasa   in number,
                             v_fecpag in date,
                             v_mtompa in number,
                             v_mtomca in number,
                             v_fproxpag in date,--sma 16052022
                             v_vencido out varchar2,
                             v_reprog  out varchar2,
                             v_modo    out varchar2,
                             v_situa   out varchar2,
                             v_proceso out varchar2,
                             v_mtosol  out number,
                             v_pagoprima out number,
                             v_registro out char,
                             v_monto17  out number,
                             v_flag22   out number) is
ld_fecha date;
ld_fecha1 date;
ln_mto11 number(17,2);
ln_mto12 number(17,2);
ln_mto13 number;
ln_mto14 number;
ln_mto15 number;
ln_mtoCalen number;
ld_fechaini date;
ld_fechafin date;
ld_fecpxv date;
tipoRE char(2):='NO';
tipo1 number := 0;
lc_ajuste char(20);
fpagoven date:= null;
importepago number(17,2):=0;
existe  number :=0;
montopago number(17,2):=0;
ln_suboper number;
ln_monto1 number;
tabla varchar2(20);
fechrepro date;
montosol number(17,2);
primapago number(17,2);
primamayo number(17,2):= 0;
primaabril number(17,2):= 0;
primamarzo number(17,2):= 0;
primapagada number(17,2):= 0;
mes number;
montoprima number(17,2):= 0;
primajun number(17,2):= 0;
primajul number(17,2):= 0;
primaAGO number(17,2):= 0;
primaSep number(17,2):= 0;
primaOct number(17,2):= 0;
fechaProceso date;
ln_mtocrono number(17,2):= 0;
flag22 number:= 0;
begin
 ld_fechaini := TRUNC(v_fecha,'MM');
 ld_fechafin := v_fecha;
 v_mtosol := 0;
 ln_mtoCalen :=0;
 montopago := 0;
 Begin
    select 1
      into existe
      from fsd611
     where PGCOD = v_Pgcod
       and PPMOD = v_Scmod
       and PPSUC = v_Scsuc
       and PPMDA = v_Scmda
       and PPPAP = v_Scpap
       and PPCTA = v_Sccta
       and PPOPER = v_Scoper
       and PPSBOP = v_Scsbop
       and PPTOPE = v_Sctope
       and ppfpag between ld_fechaini and ld_fechafin
       AND rownum = 1;
 Exception
   when no_data_found then
     existe := 0;
 end;
 if existe = 1 then
   v_vencido :='S';
 else
   v_vencido :='N';


         select /*+ parallel(n,2,1)*/
           min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod = v_pgcod
           and n.ppmod = v_Scmod
           and n.ppsuc = v_Scsuc
           and n.ppmda = v_Scmda
           and n.pppap = v_Scpap
           and n.ppcta = v_Sccta
           and n.ppoper = v_Scoper
           and n.ppsbop = v_Scsbop
           and n.pptope = v_Sctope
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and not exists (select /*+ parallel(o,2,1)*/
                 ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                   and o.pp1fech <= ld_fechafin
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
    --se puede eliminar este paso
            select min(ppfpag)
              into ld_fecha1
              from fsd611
             where PGCOD = v_pgcod
               and PPMOD = v_Scmod
               and PPSUC = v_Scsuc
               and PPMDA = v_Scmda
               and PPPAP = v_Scpap
               and PPCTA = v_Sccta
               and PPOPER = v_Scoper
               and PPSBOP = v_Scsbop
               and PPTOPE =  v_Sctope
               and ppfpag = ld_fecpxv;  --> ld_fecha;

              select sum(ppimp11),
                     sum(ppimp12),
                     sum(ppimp13),
                     sum(ppimp14),
                     sum(ppimp15)
                into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                from fsd611 b
                where b.pgcod = v_pgcod
                 and b.ppmod = v_Scmod
                 and b.ppsuc = v_Scsuc
                 and b.ppmda = v_Scmda
                 and b.pppap = v_Scpap
                 and b.ppcta = v_Sccta
                 and b.ppoper = v_Scoper
                 and b.ppsbop = v_Scsbop
                 and b.pptope =  v_Sctope
                 and b.ppfpag = ld_fecha1;

                 if ln_mto15 <> 0 then
                    ln_mtoCalen := ln_mto15;
                 else
                   if ln_mto14 <> 0 then
                     ln_mtoCalen := ln_mto14;
                   else
                     if ln_mto13 <> 0 then
                       ln_mtoCalen := ln_mto13;
                     else
                       if ln_mto12 <> 0 then
                         ln_mtoCalen := ln_mto12;
                       else
                         if ln_mto11 <> 0 then
                           ln_mtoCalen := ln_mto11;
                         end if;
                       end if;
                     end if;
                   end if;
                 end if;
--         if ld_fecha1 >= ld_fechaini and ld_fecha1 <= ld_fechafin then
       if ld_fecha1 is not null then
         if ld_fecha1 > ld_fechafin then
           v_mtosol := round(((v_mtoSA * v_tasa)/100),2) ;
           if v_mtosol < 1 and v_mtosol > 0 then
             v_mtosol := 1;
           end if;
         else
           v_mtosol := ln_mtoCalen;
         end if;
       else
         v_mtosol := round(((v_mtoSA * v_tasa)/100),2) ;
           if v_mtosol < 1 and v_mtosol > 0 then
             v_mtosol := 1;
           end if;
       end if;
     end if;
     -- Verifica meses anteriores

     if ld_fechafin >='01/03/2020' then

         --- verifica reprogramaciones

         Begin
          select 'SI', 1
            into tipoRE,tipo1
            from aqpb002 b
           where aqpb002fep > to_date('30/03/2020','dd/mm/yyyy') --and ld_fechafin
             and b.aqpb002emp = v_pgcod
             and b.aqpb002mod = v_Scmod
             and b.aqpb002suc = v_Scsuc
             and b.aqpb002mda = v_Scmda
             and b.aqpb002pap = v_Scpap
             and b.aqpb002cta = v_Sccta
             and b.aqpb002ope = v_Scoper
             and b.aqpb002sbo = v_Scsbop
             and b.aqpb002top = v_Sctope
             and b.aqpb002est = 'C'
             and nvl(b.aqpb002revr, 'N')  <> 'S'
             and rownum = 1;-- reprogramacion masiva
        exception
          when no_data_found then
            tipo1 := 0;
            Begin
              select 'SI',2
                into tipoRE,tipo1
                from sng001 s
               where s.sng001inst = v_instancia
                 and s.sng014cod = 4
                 and s.sng001fin > to_Date('01/01/2020','dd/mm/yyyy')
                 and s.sng001ori =14
                 and rownum = 1; --reprogramacion por el flujo
            exception
              when no_data_found then
                begin
                   select 'SI',3
                     into tipoRE,tipo1
                     from jaqz698
                    where jaqz698fep > to_Date('23/03/2020','dd/mm/yyyy')
                      and jaqz698emp = v_pgcod
                      AND jaqz698mod = v_Scmod
                      and jaqz698suc = v_Scsuc
                      and jaqz698mda = v_Scmda
                      and jaqz698pap = v_Scpap
                      and jaqz698cta = v_Sccta
                      and jaqz698ope = v_Scoper
                      and jaqz698sbo = v_Scsbop
                      and jaqz698top = v_Sctope
                      AND jaqz698est in ('X','C')
                      and rownum = 1;
                exception
                  when no_data_found then
                    tipoRE:= 'NO'; -- no reprogramado
                end;
            End;
        End;
        v_reprog := tipoRE;
      END if;

  ---------------- situacion de pago ---------------------------------------
     Begin
       Select fpp080fpa,  fpp080imp
         into fpagoven , importepago
         from fpp080
        where fpp080emp = v_pgcod
          and fpp080cia in (723189,723198)
          and fpp080tse = 5
          and fpp080seg = v_seguro
          and fpp080mod = v_Scmod
          and fpp080suc = v_Scsuc
          and fpp080mda = v_Scmda
          and fpp080pap = v_Scpap
          and fpp080cta = v_Sccta
          and fpp080ope = v_Scoper
          and fpp080sbo = v_Scsbop
          and fpp080top = v_Sctope
          and fpp080fec = ld_fechafin
          AND ROWNUM = 1;

     exception
       when no_data_found then
         fpagoven := null;
         importepago := 0;
     end;
     if fpagoven is null THEN
       v_situa :='No Pago';
     ELSE
       v_situa := 'Pago Cuota';
       if v_tipago ='C' then
         v_proceso := 'Sobregiro';
       ELSE
         v_proceso := 'Normal';
       end if;
     END IF;
----------------------------------------------------------------------------------------
     IF tipoRE = 'SI' THEN --- modalidad de reprogramacion
        Begin
          select 'Ajuste'
            into lc_ajuste
            from jaqa250
           where jaqa250emp = v_pgcod
             and jaqa250mod = v_Scmod
             and jaqa250suc = v_Scsuc
             and jaqa250mda = v_Scmda
             and jaqa250pap = v_Scpap
             and jaqa250cta = v_Sccta
             and jaqa250ope = v_Scoper
             and jaqa250sbo = v_Scsbop
             and jaqa250tpo = v_Sctope
             and jaqa250est = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            if Tipo1 = 1 then
              lc_ajuste := 'Congelado';
            end if;
            if tipo1 = 2 then
              lc_ajuste := 'Flujo';
            end if;
            if tipo1 = 3 then
              lc_ajuste := 'Capitalizacion';
            end if;
        end;
        -------------------------------v_registro--------------------------------------------------

        Begin ---FECHA_REPROGRAMACION, BCCTA, BCOPER, BCSBOP, EXTORNO, TABLA_ORIGEN

          select bcsbop ,monto,tabla_origen, fecha_reprogramacion
            into ln_suboper, ln_monto1,tabla, fechrepro
            from AQPA833 --USRREPBI.REP_TOT_REPRO_2020
           where FECHA_REPROGRAMACION = (select mAX(FECHA_REPROGRAMACION)
                                          from AQPA833 --USRREPBI.REP_TOT_REPRO_2020
                                         where FECHA_REPROGRAMACION <= ld_fechafin
                                           AND bccta =v_Sccta
                                           AND bcoper = v_Scoper
                                           and extorno ='NO' )
             AND bccta = v_Sccta
             AND bcoper = v_Scoper
             and extorno ='NO'
             and rownum = (select max(rownum)
                            from AQPA833 --USRREPBI.REP_TOT_REPRO_2020
                           where FECHA_REPROGRAMACION = (select mAX(FECHA_REPROGRAMACION)
                                                          from AQPA833--USRREPBI.REP_TOT_REPRO_2020
                                                         where FECHA_REPROGRAMACION <= ld_fechafin
                                                           AND bccta =v_Sccta
                                                           AND bcoper = v_Scoper
                                                           AND extorno ='NO')
                             AND bccta = v_Sccta
                             AND bcoper = v_Scoper
                             and extorno ='NO');

            v_registro :='S';
--          end if;
             if v_tipago = 'P' then
               --- fecha reprog
               if fechrepro < ld_fechafin then
                  montosol := round(((v_mtoSA * v_tasa)/100),2) ;
                   if montosol < 1 and montosol > 0 then
                     montosol := 1;
                   end if;
                   montoprima :=  v_mtompa;
                   ----- prueba jaqz085tram
                   if trunc(montoprima) > trunc(montosol) then
                     fechaProceso := add_months(ld_fechafin, -1);
                   --  While ( trunc(montoprima) > trunc(montosol)) and (fechaProceso >= to_date('31/03/2020','dd/mm/yyyy')) loop
                      While ( trunc(montoprima) > trunc(montosol)) and (fechaProceso >= fechrepro) loop
                         Begin
                            Select NVL(sum(jaqz085pri1 ),0)
                              into primajul
                              from jaqz085tram  --junio
                             where jaqz085fec1 = fechaProceso
                               and jaqz085cta1  = v_Sccta
                               and jaqz085ope1  = v_Scoper
                               and jaqz085sbo1  = v_Scsbop
                               AND jaqz085tip1  ='C' ;
                         exception
                           when no_data_found then
                             primajul := 0;

                         end;
                         montoprima :=  montoprima - primajul; --sma 06082020
                         fechaProceso := add_months(fechaProceso, -1);
                    end loop;
                    flag22 := 1;
                  end if;

                   if montoprima > 0 then
                      if v_Scmda = 0 then
                        if montoprima > 0 and montoprima < 1 then
                          montosol := 1;
                        else
                           montosol := montoprima;
                        end if;
                      else
                        if montoprima > 0 and montoprima < 1 then
                          montosol := 0.35;
                        else
                           montosol := montoprima;
                        end if;
                      end if;
                   else
                       montosol := 0;
                   end if;
                else
                    montosol := v_mtompa;
                end if;
             else
               ---------------sma 17/05/2022-------------------
                select sum(ppimp11),
                     sum(ppimp12),
                     sum(ppimp13),
                     sum(ppimp14),
                     sum(ppimp15)
                into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                from fsd611 b
                where b.pgcod = v_pgcod
                 and b.ppmod = v_Scmod
                 and b.ppsuc = v_Scsuc
                 and b.ppmda = v_Scmda
                 and b.pppap = v_Scpap
                 and b.ppcta = v_Sccta
                 and b.ppoper = v_Scoper
                 and b.ppsbop = v_Scsbop
                 and b.pptope =  v_Sctope
                 and b.ppfpag = v_fproxpag;

                if ln_mto15 <> 0 then
                    ln_mtocrono := ln_mto15;
                 else
                   if ln_mto14 <> 0 then
                     ln_mtocrono := ln_mto14;
                   else
                     if ln_mto13 <> 0 then
                       ln_mtocrono := ln_mto13;
                     else
                       if ln_mto12 <> 0 then
                         ln_mtocrono := ln_mto12;
                       else
                         if ln_mto11 <> 0 then
                           ln_mtocrono := ln_mto11;
                         end if;
                       end if;
                     end if;
                   end if;
                 end if;
               ------------------------------------------------
               if ln_mtocrono = 0 then
                  flag22 := 0;
                 montosol := round(((v_mtoSA * v_tasa)/100),2) ;
                 if montosol < 1 and montosol > 0 then
                   if v_Scmda = 0 then
                      montosol := 1;
                   else
                      montosol := 0.35;
                   end if;
                 end if;
               else
                 flag22 := 1;
                 montosol := ln_mtocrono;
               end if;
            end if;

            v_monto17 := montosol;

       --   end if;

        exception
          when no_data_found then
         -- if lc_ajuste := 'Flujo' then


            v_registro :='S';
            if v_tipago ='P' then
               v_monto17 := v_mtompa;
            else

              v_monto17 := round(((v_mtoSA * v_tasa)/100),2) ;
              if v_monto17 < 1 and v_monto17 > 0 then
                v_monto17 := 1;
              end if;
            end if;
        end;
        ---------------------------------------------------------------------------------
     ELSE
        lc_ajuste := 'NORMAL ';
        v_registro :='S';
        -----verificacion si fue reprog por flujo--------
        Begin
          select bcsbop ,monto,tabla_origen, fecha_reprogramacion
            into ln_suboper, ln_monto1,tabla, fechrepro
            from Aqpa833 --USRREPBI.REP_TOT_REPRO_2020
           where FECHA_REPROGRAMACION = (select mAX(FECHA_REPROGRAMACION)
                                          from Aqpa833--USRREPBI.REP_TOT_REPRO_2020
                                         where FECHA_REPROGRAMACION <= ld_fechafin
                                           AND bccta =v_Sccta
                                           and bcoper = v_Scoper
                                           AND extorno ='NO'
                                           and tabla_origen ='FSH016')
             AND bccta = v_Sccta
             AND bcoper = v_Scoper
             AND extorno ='NO'
             and tabla_origen ='FSH016'
             and rownum = (select max(rownum)
                            from Aqpa833 --USRREPBI.REP_TOT_REPRO_2020
                           where FECHA_REPROGRAMACION = (select mAX(FECHA_REPROGRAMACION)
                                                          from Aqpa833 --USRREPBI.REP_TOT_REPRO_2020
                                                         where FECHA_REPROGRAMACION < ld_fechafin
                                                           AND bccta =v_Sccta
                                                           AND bcoper = v_Scoper
                                                           AND extorno ='NO'
                                                           and tabla_origen ='FSH016')

                             AND bccta = v_Sccta
                             AND bcoper = v_Scoper
                             AND extorno ='NO'
                             and tabla_origen ='FSH016');

       exception
         when no_data_found then
          v_registro :='S';
       end;
        --------------------------------------------------
        if v_tipago ='P' then
           v_monto17 := v_mtompa;
           flag22 := 1;
        else
          v_monto17 := round(((v_mtoSA * v_tasa)/100),2) ;
          if v_monto17 < 1 and v_monto17 > 0 then
             if v_Scmda = 0 then
                v_monto17 := 1;
             else
                v_monto17 := 0.35;
             end if;
          end if;
        end if;
     END IF;

     v_modo := lc_ajuste;


-----------------OBTENEMOS MONTO PRIMAS -----------------------------------------
     if v_tipago ='P'  and existe = 1 then
              select sum(ppimp11),
                     sum(ppimp12),
                     sum(ppimp13),
                     sum(ppimp14),
                     sum(ppimp15)
                into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                from fsd611 b
                where b.pgcod = v_pgcod
                 and b.ppmod = v_Scmod
                 and b.ppsuc = v_Scsuc
                 and b.ppmda = v_Scmda
                 and b.pppap = v_Scpap
                 and b.ppcta = v_Sccta
                 and b.ppoper = v_Scoper
                 and b.ppsbop = v_Scsbop
                 and b.pptope =  v_Sctope
                 and b.ppfpag = v_fecpag;--

                 if ln_mto15 <> 0 then
                    ln_mtoCalen := ln_mto15;
                 else
                   if ln_mto14 <> 0 then
                     ln_mtoCalen := ln_mto14;
                   else
                     if ln_mto13 <> 0 then
                       ln_mtoCalen := ln_mto13;
                     else
                       if ln_mto12 <> 0 then
                         ln_mtoCalen := ln_mto12;
                       else
                         if ln_mto11 <> 0 then
                           ln_mtoCalen := ln_mto11;
                         end if;
                       end if;
                     end if;
                   end if;
                 end if;
          if ln_mtoCalen <> v_mtompa then
            montopago := ln_mtoCalen ;
          else
            montopago := v_mtompa;
          end if;
      else ---tipo_pago = 'C' solidario
         if  v_tipago ='C'  and existe = 1 then
           select sum(ppimp11),
                     sum(ppimp12),
                     sum(ppimp13),
                     sum(ppimp14),
                     sum(ppimp15)
                into ln_mto11, ln_mto12, ln_mto13, ln_mto14, ln_mto15
                from fsd611 b
                where b.pgcod = v_pgcod
                 and b.ppmod = v_Scmod
                 and b.ppsuc = v_Scsuc
                 and b.ppmda = v_Scmda
                 and b.pppap = v_Scpap
                 and b.ppcta = v_Sccta
                 and b.ppoper = v_Scoper
                 and b.ppsbop = v_Scsbop
                 and b.pptope =  v_Sctope
                 and b.ppfpag = v_fecpag;--

                 if ln_mto15 <> 0 then
                    ln_mtoCalen := ln_mto15;
                 else
                   if ln_mto14 <> 0 then
                     ln_mtoCalen := ln_mto14;
                   else
                     if ln_mto13 <> 0 then
                       ln_mtoCalen := ln_mto13;
                     else
                       if ln_mto12 <> 0 then
                         ln_mtoCalen := ln_mto12;
                       else
                         if ln_mto11 <> 0 then
                           ln_mtoCalen := ln_mto11;
                         end if;
                       end if;
                     end if;
                   end if;
                 end if;
          if ln_mtoCalen <> v_mtompa then
            montopago := ln_mtoCalen ;
          else
            montopago := v_mtompa;
          end if;
         else
           if  v_tipago ='C' then --- and existe = 1 then
              if nvl(v_mtomca,0) <> v_mtosol then
                 montopago := v_mtosol;
              else
                 if v_mtomca is not null then
                    montopago := v_mtomca;
                 else
                    montopago := round(((v_mtoSA * v_tasa)/100),2) ;
                    if montopago < 1 and montopago > 0 then
                      montopago := 1;
                    end if;
                 end if;
              end if;

            end if;
         end if;
      end if;
     v_pagoprima := montopago;
     v_flag22 := flag22;

end Valida_Adicionales;
------0610/2021 sma
procedure Limpia_trama is
  cursor actualiza is
  select jaqz085emp, jaqz085suc, jaqz085mda, jaqz085pap ,jaqz085cta, jaqz085ope ,jaqz085sbo ,jaqz085top ,jaqz085scl,jaqz085tas, round(jaqz085scl * (jaqz085tas/100),2) , jaqz085aux17,jaqz085aux18, jaqz085aux5
    from jaqz085
   where jaqz085aux16 is null
     and jaqz085aux17 <> jaqz085aux18
     and round(jaqz085scl * (jaqz085tas/100),2) <>jaqz085aux17
     and round(jaqz085scl * (jaqz085tas/100),2) >= 1
     and jaqz085aux8 = 2;

  cursor CERO is
  select jaqz085emp, jaqz085suc, jaqz085mda, jaqz085pap ,jaqz085cta, jaqz085ope ,jaqz085sbo ,jaqz085top ,jaqz085scl,jaqz085tas, round(jaqz085scl * (jaqz085tas/100),2) , jaqz085aux17,jaqz085aux18, jaqz085aux5
    from jaqz085
   where jaqz085aux16 is null
     and jaqz085aux17 = 0;

  cursor VidaCaja is
   select jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top, jaqz085aux17,jaqz085aux18, round((jaqz085scl *(jaqz085tas/100)),2)prima , jaqz085aux5
     from Jaqz085
    where jaqz085aux17 = 2.5
      and jaqz085aux17 <> jaqz085aux18
      and mod(jaqz085aux18,2.5)<>0
  union
   select jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top, jaqz085aux17,jaqz085aux18,   round((jaqz085scl *(jaqz085tas/100)),2)prima, jaqz085aux5
     from Jaqz085
    where jaqz085aux17 = 5
      and jaqz085aux17 <> jaqz085aux18
      and mod(jaqz085aux18,5)<> 0
  union
   select jaqz085emp, jaqz085mod, jaqz085suc, jaqz085mda ,jaqz085pap ,jaqz085cta ,jaqz085ope ,jaqz085sbo ,jaqz085top, jaqz085aux17,jaqz085aux18,   round((jaqz085scl *(jaqz085tas/100)),2)prima , jaqz085aux5
     from Jaqz085
    where jaqz085aux17 = 6.5
      and jaqz085aux17 <> jaqz085aux18
      and mod(jaqz085aux18,6.5)<> 0;

  valor number(17,2):=0;

Begin
  for a in actualiza loop

     update jaqz085
        set jaqz085aux17 = round(a.jaqz085scl * (a.jaqz085tas/100),2)
      where jaqz085emp = a.jaqz085emp
        and jaqz085suc = a.jaqz085suc
        and jaqz085mda = a.jaqz085mda
        and jaqz085pap = a.jaqz085pap
        and jaqz085cta = a.jaqz085cta
        and jaqz085ope = a.jaqz085ope
        and jaqz085sbo = a.jaqz085sbo
        and jaqz085top = a.jaqz085top
        and jaqz085aux5 = a.jaqz085aux5;
      commit;
  end loop;

   for a in cero loop
     valor := round(a.jaqz085scl * (a.jaqz085tas/100),2);
     if valor < 1 then
       valor := 1;
     end if;


     update jaqz085
        set jaqz085aux17 = valor
      where jaqz085emp = a.jaqz085emp
        and jaqz085suc = a.jaqz085suc
        and jaqz085mda = a.jaqz085mda
        and jaqz085pap = a.jaqz085pap
        and jaqz085cta = a.jaqz085cta
        and jaqz085ope = a.jaqz085ope
        and jaqz085sbo = a.jaqz085sbo
        and jaqz085top = a.jaqz085top
        and jaqz085aux5 = a.jaqz085aux5;
      commit;
   end loop;

   for a in VidaCaja loop
     update jaqz085
        set jaqz085aux17 = a.jaqz085aux18
      where jaqz085emp = a.jaqz085emp
        and jaqz085suc = a.jaqz085suc
        and jaqz085mda = a.jaqz085mda
        and jaqz085pap = a.jaqz085pap
        and jaqz085cta = a.jaqz085cta
        and jaqz085ope = a.jaqz085ope
        and jaqz085sbo = a.jaqz085sbo
        and jaqz085top = a.jaqz085top
        and jaqz085aux5 = a.jaqz085aux5;
        commit;
    end loop;



  end Limpia_trama;

  Procedure Reprogramacion2022(v_Pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               v_fecha  in date,
                               v_seguro in number, --v_instancia in number,
                               v_fechapago in date, -- sma 070723
                               v_tipago in varchar2,
                               v_montomca in number,
                               v_salcap in out number,
                               v_tasa   in number,
                               v_fvencer in date,
                               v_TipoRepro out varchar2,
                               v_Cartera   out varchar2,
                               v_Declarar  out varchar2,
                               v_flagrepro out varchar2,
                               v_frepro_uno out date,
                               v_fecha_repro out date,-- sma 070723
                               v_situa    out varchar2,
                               v_proceso  out varchar2,
                               v_monto17  out number,
                               v_flagau8 out number) is
desRepro char(15);
fechaini date;
fechafin date;
v_Freprog date;
descripcion varchar2(10);
tipo1 number:= 0;
fpagoven  date;
importepago number(17,2):= 0;
ln_montorepro number(17,2):= 0;
ld_fecpxv date;
ln_mtopagado number(17,2):= 0;
CuotaDos date;
flaguno character(1);
once number(17,2):= 0;
doce number(17,2):= 0;
trece number(17,2):= 0;
nrocuota number:= 0;
existe number:= 0;
nropagos number:= 0;

Begin
  fechaini := TRUNC(v_fecha,'MM');
  fechafin := v_fecha;
 ---fpp080
    Begin

       fpagoven := null;
       importepago := 0;
       Select fpp080fpa,  fpp080imp
         into fpagoven , importepago
         from fpp080
        where fpp080emp = v_pgcod
          and fpp080cia in (723189,723198)
          and fpp080tse = 5
          and fpp080seg = v_seguro
          and fpp080mod = v_Scmod
          and fpp080suc = v_Scsuc
          and fpp080mda = v_Scmda
          and fpp080pap = v_Scpap
          and fpp080cta = v_Sccta
          and fpp080ope = v_Scoper
          and fpp080sbo = v_Scsbop
          and fpp080top = v_Sctope
          and fpp080fpa = v_fechapago
          and fpp080fec = fechafin
          and fpp080a11 <> 'S';

     exception
       when no_data_found then
         fpagoven := null;
         importepago := 0;
       when too_many_rows then

       fpagoven := null;
       importepago := 0;
       Select fpp080fpa,  fpp080imp
         into fpagoven , importepago
         from fpp080
        where fpp080emp = v_pgcod
          and fpp080cia in (723189,723198)
          and fpp080tse = 5
          and fpp080seg = v_seguro
          and fpp080mod = v_Scmod
          and fpp080suc = v_Scsuc
          and fpp080mda = v_Scmda
          and fpp080pap = v_Scpap
          and fpp080cta = v_Sccta
          and fpp080ope = v_Scoper
          and fpp080sbo = v_Scsbop
          and fpp080top = v_Sctope
          and fpp080fpa = v_fechapago
          and fpp080fec = fechafin
          and fpp080a11 <> 'S'
          and rownum = 1;
     end;

--- Tablas Reprogramaciones
  Begin
      v_freprog := null;
      v_TipoRepro := ' ';
      v_Declarar := ' ';
      v_flagrepro := 'N';
      ln_montorepro := 0;
     select 'R.Sin Capitalizacion','Declarar','S', fecha_reprogramacion,
             monto
       into v_TipoRepro, v_Declarar, v_flagrepro, v_Freprog, ln_montorepro
       from aqpa833
      where fecha_reprogramacion = (select max(fecha_reprogramacion)
                                     from aqpa833
                                    where fecha_reprogramacion <= fechafin
                                      and bccta  = v_Sccta
                                      and bcoper  = v_Scoper
                                      and bcsbop  = v_Scsbop
                                      and extorno ='NO')
        and bccta  = v_Sccta
        and bcoper  = v_Scoper
        and bcsbop  = v_Scsbop
        and extorno = 'NO';
  exception
    when no_data_found then
      Begin
          v_freprog := null;
          v_TipoRepro := ' ';
          v_Declarar := ' ';
          v_flagrepro := 'N';
          ln_montorepro := 0;
        select 'R.Con Capitalizacion'--,' '
               ,'Declarar', 'S', fecha_reprogramacion, monto
          into v_TipoRepro,-- v_Cartera
               v_Declarar, v_flagrepro, v_Freprog, ln_montorepro
          from USRREPBI.REP_TOT_REPRO_2020
         where fecha_reprogramacion = ( select max(fecha_reprogramacion)
                                            from USRREPBI.REP_TOT_REPRO_2020
                                           where fecha_reprogramacion <= fechafin
                                             and bccta  = v_Sccta
                                             and bcoper  = v_Scoper
                                             and bcsbop  = v_Scsbop
                                             and extorno <> 'SI')
                                             --and con_cptlzcn = '-')
           and bccta  = v_Sccta
           and bcoper  = v_Scoper
           and bcsbop  = v_Scsbop
           and extorno <> 'SI';

      exception
         when no_data_found then
           v_Freprog := null;
           v_TipoRepro := null;
           v_Cartera := null;
           v_Declarar := 'Declarar';
           v_flagrepro:= 'N'; -- no reprogramado
         when too_many_rows then
           select 'R.Con Capitalizacion'--,' '
               ,'Declarar', 'S', fecha_reprogramacion, monto
            into v_TipoRepro,-- v_Cartera
                 v_Declarar, v_flagrepro, v_Freprog, ln_montorepro
            from USRREPBI.REP_TOT_REPRO_2020
           where  fecha_reprogramacion = ( select max(fecha_reprogramacion)
                                              from USRREPBI.REP_TOT_REPRO_2020
                                             where fecha_reprogramacion <= fechafin
                                               and bccta  = v_Sccta
                                               and bcoper  = v_Scoper
                                               and bcsbop  = v_Scsbop
                                               and extorno <> 'SI')
                                               --and con_cptlzcn = '-')
             and bccta  = v_Sccta
             and bcoper  = v_Scoper
             and bcsbop  = v_Scsbop
             and extorno <> 'SI'
             and rownum = 1;
      end;
     WHEN TOO_MANY_ROWS THEN
      v_freprog := null;
      v_TipoRepro := ' ';
      v_Declarar := ' ';
      v_flagrepro := 'N';
      ln_montorepro := 0;
      select 'R.Con Capitalizacion'--,' '
               ,'Declarar', 'S', fecha_reprogramacion, monto
        into v_TipoRepro,-- v_Cartera
             v_Declarar, v_flagrepro, v_Freprog, ln_montorepro
        from USRREPBI.REP_TOT_REPRO_2020
       where  fecha_reprogramacion = ( select max(fecha_reprogramacion)
                                          from USRREPBI.REP_TOT_REPRO_2020
                                         where fecha_reprogramacion <= fechafin
                                           and bccta  = v_Sccta
                                           and bcoper  = v_Scoper
                                           and bcsbop  = v_Scsbop
                                           and extorno <> 'SI')
                                           --and con_cptlzcn = '-')
         and bccta  = v_Sccta
         and bcoper  = v_Scoper
         and bcsbop  = v_Scsbop
         and extorno <> 'SI'
         and rownum = 1;

  end;
  v_fecha_repro := v_Freprog;
  if v_flagrepro = 'S' then
    v_flagau8 := 1;
      if v_Freprog is not null then --- Verifica Pagos
         v_frepro_uno := null;

           select /*+ parallel(n,2,1)*/
             min(n.ppfpag)
            into v_frepro_uno--fecha_ultima cuota pagada
            from fsd601 n
           where n.pgcod = v_Pgcod
             and n.ppmod = v_Scmod
             and n.ppsuc = v_Scsuc
             and n.ppmda = v_Scmda
             and n.pppap = v_Scpap
             and n.ppcta = v_Sccta
             and n.ppoper = v_Scoper
             and n.ppsbop = v_Scsbop
             and n.pptope = v_Sctope
             and n.ppfpag >= v_Freprog
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and not exists (select /*+ parallel(o,2,1)*/
                             ppmod, ppcta, ppoper, pptope, ppfpag
                              from fsd602 o
                             where o.pgcod = n.pgcod
                               and o.ppmod = n.ppmod
                               and o.ppsuc = n.ppsuc
                               and o.ppmda = n.ppmda
                               and o.pppap = n.pppap
                               and o.ppcta = n.ppcta
                               and o.ppoper = n.ppoper
                               and o.ppsbop = n.ppsbop
                               and o.pptope = n.pptope
                               and o.ppfpag = n.ppfpag
                               and o.pp1fech <= fechafin
                               and o.pp1stat = 'T'
                               and o.d602co = 'S'
                               and (o.pp1cap + o.pp1int) <> 0);

           if v_frepro_uno is not null then -- Hay Pagos
            ---------------2da cuota-----------------
               select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
                into Cuotados
               from fsd601 n
              where n.pgcod = v_Pgcod
                and n.ppmod = v_scmod
                and n.ppsuc = v_Scsuc
                and n.ppmda = v_scmda
                and n.pppap = v_scpap
                and n.ppcta = v_sccta
                and n.ppoper = v_scoper
                and n.ppsbop = v_Scsbop
                and n.pptope = v_Sctope
                and n.d601co = 'S'
                and n.ppfpag > v_Frepro_uno;
              ---------------------------------------------
             if v_frepro_uno >= fechaini  and v_frepro_uno <=fechafin THEN
               --verificar v_situa
               v_monto17 := importepago;
               FlagUno := 'S'; -- Reprogramacion en el mes
               if v_tipago ='P' then
                 v_proceso := 'Normal';
                 v_situa := 'Pago Cuota';
               else
                 v_proceso := 'Sobregiro';
                 v_situa := 'No Pago';
               end if;
             else
                if v_frepro_uno > fechafin then
                    FlagUno := 'S';--- pago adelantado
                    v_monto17 := importepago;
                   if v_tipago ='P' then
                     v_proceso := 'Normal';
                     v_situa := 'Pago Cuota';
                   else
                     v_proceso := 'Sobregiro';
                     v_situa := 'No Pago';
                   end if;
                else
                   FlagUno := 'N';
                   nrocuota := 0;
                     select count(*)
                       into nrocuota
                       from fsd611 f2,
                            fsd612 f3
                       where f2.pgcod = v_PGCOD
                         and f2.ppmod = v_scmod
                         and f2.ppsuc = v_scsuc
                         and f2.ppmda = v_scmda
                         and f2.pppap = v_scpap
                         and f2.ppcta = v_sccta
                         and f2.ppoper = v_scoper
                         and f2.ppsbop = v_scsbop
                         and f2.pptope = v_sctope
                         and f2.ppfpag >= v_Freprog
                         and f2.ppfpag <= fechafin
                         and f3.pgcod = f2.pgcod
                         and f3.ppmod = f2.ppmod
                         and f3.ppsuc = f2.ppsuc
                         and f3.ppmda = f2.ppmda
                         and f3.pppap = f2.pppap
                         and f3.ppcta = f2.ppcta
                         and f3.ppoper = f2.ppoper
                         and f3.ppsbop = f2.ppsbop
                         and f3.pptope = f2.pptope
                         and f3.ppfpag = f2.ppfpag;
                end if;
             end if;
             if flagUno = 'N' then
               if nrocuota = 1  then --- pago una cuota
                 Begin
                  select /*+ parallel(n,2,1)*/
                        ppimp11, ppimp12, ppimp13
                    into once, doce, trece
                    from fsd611 n
                   where n.pgcod = v_pgcod
                     and n.ppmod = v_scMOD
                     and n.ppsuc = v_scSUC
                     and n.ppmda = v_scMDA
                     and n.pppap = v_scPAP
                     and n.ppcta = v_scCTA
                     and n.ppoper = v_scOPER
                     and n.ppsbop = v_scSBOP
                     and n.pptope = v_scTOPE
                     and n.ppfpag = cuotados
                     and rownum = 1;
                 exception
                   when no_data_found then
                     once:=0;
                     doce:=0;
                     trece:=0;
                   when too_many_rows then
                     select /*+ parallel(n,2,1)*/
                        ppimp11, ppimp12, ppimp13
                    into once, doce, trece
                    from fsd611 n
                   where n.pgcod = v_pgcod
                     and n.ppmod = v_scMOD
                     and n.ppsuc = v_scSUC
                     and n.ppmda = v_scMDA
                     and n.pppap = v_scPAP
                     and n.ppcta = v_scCTA
                     and n.ppoper = v_scOPER
                     and n.ppsbop = v_scSBOP
                     and n.pptope = v_scTOPE
                     and n.ppfpag = cuotados
                     and rownum = 1;
                 end;
                 if trece <> 0  then
                    v_monto17 := trece;
                  elsif doce <> 0 then
                    v_monto17 := doce;
                  else
                    v_monto17 := once;
                  end if;
                  if v_tipago ='P' then
                     v_proceso := 'Normal';
                     v_situa := 'Pago Cuota';
                   else
                     v_proceso := 'Sobregiro';
                     v_situa := 'No Pago';
                   end if;
               elsif  nrocuota = 0 then
                 begin
                   once:=0;
                   doce:=0;
                   trece:=0;
                  select /*+ parallel(n,2,1)*/
                      ppimp11, ppimp12, ppimp13
                  into once, doce, trece
                  from fsd611 n
                 where n.pgcod = v_pgcod
                   and n.ppmod = v_scMOD
                   and n.ppsuc = v_scSUC
                   and n.ppmda = v_scMDA
                   and n.pppap = v_scPAP
                   and n.ppcta = v_scCTA
                   and n.ppoper = v_scOPER
                   and n.ppsbop = v_scSBOP
                   and n.pptope = v_scTOPE
                   and n.ppfpag = cuotados
                   and rownum = 1;
                 exception
                   when no_data_found then
                     once:=0;
                     doce:=0;
                     trece:=0;
                  end;
                  if trece <> 0  then
                    v_monto17 := trece;
                  elsif doce <> 0 then
                    v_monto17 := doce;
                  else
                    v_monto17 := once;
                  end if;
                  if v_tipago ='P' then
                     v_proceso := 'Normal';
                     v_situa := 'Pago Cuota';
                   else
                     v_proceso := 'Sobregiro';
                     v_situa := 'No Pago';
                   end if;

                elsif nrocuota > 1 then  --tomar una anterior
                  begin
                     once:=0;
                     doce:=0;
                     trece:=0;
                     select /*+ parallel(n,2,1)*/
                          ppimp11, ppimp12, ppimp13
                      into once, doce, trece
                      from fsd611 n
                     where n.pgcod = v_pgcod
                       and n.ppmod = v_scMOD
                       and n.ppsuc = v_scSUC
                       and n.ppmda = v_scMDA
                       and n.pppap = v_scPAP
                       and n.ppcta = v_scCTA
                       and n.ppoper = v_scOPER
                       and n.ppsbop = v_scSBOP
                       and n.pptope = v_scTOPE
                       and n.ppfpag = Cuotados
                       and rownum = 1;
                  exception
                    when no_data_found then
                      once := 0;
                      doce := 0;
                      trece := 0;
                    when too_many_rows then
                      select /*+ parallel(n,2,1)*/
                          ppimp11, ppimp12, ppimp13
                      into once, doce, trece
                      from fsd611 n
                     where n.pgcod = v_pgcod
                       and n.ppmod = v_scMOD
                       and n.ppsuc = v_scSUC
                       and n.ppmda = v_scMDA
                       and n.pppap = v_scPAP
                       and n.ppcta = v_scCTA
                       and n.ppoper = v_scOPER
                       and n.ppsbop = v_scSBOP
                       and n.pptope = v_scTOPE
                       and n.ppfpag = Cuotados
                       and rownum= 1;
                  end;
                      if trece <> 0  then
                        v_monto17 := trece;
                      elsif doce <> 0 then
                        v_monto17 := doce;
                      else
                        v_monto17 := once;
                      end if;
                      if v_tipago ='P' then
                       v_proceso := 'Normal';
                       v_situa := 'Pago Cuota';
                     else
                       v_proceso := 'Sobregiro';
                       v_situa := 'No Pago';
                     end if;
               end if;
             end if;
           else

             select /*+ parallel(n,2,1)*/
               max(n.ppfpag)
              into v_frepro_uno ---v_fechaPagoUno --fecha_pricuota
              from fsd602 n
             where n.pgcod = 1
               and n.ppmod = v_Scmod
               and n.ppsuc = v_Scsuc
               and n.ppmda = v_Scmda
               and n.pppap = v_Scpap
               and n.ppcta = v_sccta
               and n.ppoper = v_scoper
               and n.ppsbop = v_Scsbop
               and n.pptope = v_Sctope
               and n.ppfpag >= v_Freprog
               and n.d602co = 'S';
            if v_frepro_uno  is null then
              select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
                into v_frepro_uno--v_fechaPagoUno --fecha_pricuota
                from fsd601 n
               where n.pgcod = 1
                 and n.ppmod = v_Scmod
                 and n.ppsuc = v_Scsuc
                 and n.ppmda = v_Scmda
                 and n.pppap = v_Scpap
                 and n.ppcta = v_sccta
                 and n.ppoper = v_scoper
                 and n.ppsbop = v_Scsbop
                 and n.pptope = v_Sctope
                 and n.ppfpag >= v_Freprog
                 and n.d601co = 'S'
                 and (n.ppcap + n.ppint) <> 0;
              end if;
               begin
                 once:=0;
                 doce:=0;
                 trece:=0;
                     select /*+ parallel(n,2,1)*/
                          ppimp11, ppimp12, ppimp13
                      into once, doce, trece
                      from fsd611 n
                     where n.pgcod = v_pgcod
                       and n.ppmod = v_scMOD
                       and n.ppsuc = v_scSUC
                       and n.ppmda = v_scMDA
                       and n.pppap = v_scPAP
                       and n.ppcta = v_scCTA
                       and n.ppoper = v_scOPER
                       and n.ppsbop = v_scSBOP
                       and n.pptope = v_scTOPE
                       and n.ppfpag = v_frepro_uno
                       and rownum = 1;
                  exception
                    when no_data_found then
                      once := 0;
                      doce := 0;
                      trece := 0;
                    when too_many_rows then
                     select /*+ parallel(n,2,1)*/
                          ppimp11, ppimp12, ppimp13
                      into once, doce, trece
                      from fsd611 n
                     where n.pgcod = v_pgcod
                       and n.ppmod = v_scMOD
                       and n.ppsuc = v_scSUC
                       and n.ppmda = v_scMDA
                       and n.pppap = v_scPAP
                       and n.ppcta = v_scCTA
                       and n.ppoper = v_scOPER
                       and n.ppsbop = v_scSBOP
                       and n.pptope = v_scTOPE
                       and n.ppfpag = v_frepro_uno
                       and rownum = 1 ;
                  end;
                  if trece <> 0  then
                      v_monto17 := trece;
                    elsif doce <> 0 then
                      v_monto17 := doce;
                    else
                      v_monto17 := once;
                    end if;
                    if v_tipago ='P' then
                     v_proceso := 'Normal';
                     v_situa := 'Pago Cuota';
                   else
                     v_proceso := 'Sobregiro';
                     v_situa := 'No Pago';
                   end if;
           end if;
         END IF;
     else
       --aqui si no es reprogramado
       Select count(*)
         into nropagos
         from fpp080
        where fpp080emp = v_pgcod
          and fpp080cia in (723189,723198)
          and fpp080tse = 5
          and fpp080seg = v_seguro
          and fpp080mod = v_Scmod
          and fpp080suc = v_Scsuc
          and fpp080mda = v_Scmda
          and fpp080pap = v_Scpap
          and fpp080cta = v_Sccta
          and fpp080ope = v_Scoper
          and fpp080sbo = v_Scsbop
          and fpp080top = v_Sctope
          and fpp080fpa = v_fechapago
          and fpp080fec = fechafin
          and fpp080a11 <> 'S';
        v_flagau8 := 2 ;
        if v_tipago ='P' then
           v_monto17 := importepago ;
           v_proceso := 'Normal';
           v_situa := 'Pago Cuota';
        else
           v_proceso := 'Sobregiro';
           v_situa :='No Pago';
          if v_fvencer = fpagoven then
            v_monto17 := v_montomca;
           else
              v_monto17 := round(((v_salcap * v_tasa)/100),2) ;
            /*  if v_monto17 < 1 and v_monto17 > 0 then
                v_monto17 := 1;
              end if;*/ --14122022 sma
           end if;
        end if;
     end if;

end Reprogramacion2022;
Procedure Valida_Repro(v_Pgcod  in number,
                       v_Scmod  in number,
                       v_Scsuc  in number,
                       v_Scmda  in number,
                       v_Scpap  in number,
                       v_Sccta  in number,
                       v_Scoper in number,
                       v_Scsbop in number,
                       v_Sctope in number,
                       v_fecha  in date,
                       V_flag out varchar2,
                       v_fechaPagoUno out date
                       )is

desRepro char(15);
fechaini date;
fechafin date;
v_Freprog date;
descripcion varchar2(10);
tipo1 number:= 0;
fpagoven  date;

v_fcuotauno date;
ln_mtopagado number(17,2);
ln_salcap number(17,2);
importepago number(17,2);
Cuotados date;
FlagUno character(1);
nrocuota number;
Begin
  fechaini := TRUNC(v_fecha,'MM');
  fechafin := v_fecha;

  ---Verifica Reprogramado
  Begin
     select fecha_reprogramacion, 'S'
       into  v_Freprog, V_flag
       from aqpa833
      where fecha_reprogramacion = (select max(fecha_reprogramacion)
                                     from aqpa833
                                    where fecha_reprogramacion <= fechafin
                                      and bccta  = v_Sccta
                                      and bcoper  = v_Scoper
                                      and bcsbop  = v_Scsbop
                                      and extorno ='NO')
        and bccta  = v_Sccta
        and bcoper  = v_Scoper
        and bcsbop  = v_Scsbop
        and extorno ='NO';
  exception
    when too_many_rows  then
         select fecha_reprogramacion, 'S'
       into  v_Freprog, V_flag
       from aqpa833
      where fecha_reprogramacion = (select max(fecha_reprogramacion)
                                     from aqpa833
                                    where fecha_reprogramacion <= fechafin
                                      and bccta  = v_Sccta
                                      and bcoper  = v_Scoper
                                      and bcsbop  = v_Scsbop
                                      and extorno ='NO')
        and bccta  = v_Sccta
        and bcoper  = v_Scoper
        and bcsbop  = v_Scsbop
        and extorno ='NO'
        and rownum = 1;
    when no_data_found then
      Begin
        select fecha_reprogramacion, 'S'
          into v_Freprog, V_flag
          from USRREPBI.REP_TOT_REPRO_2020
         where bccta  = v_Sccta
           and bcoper  = v_Scoper
           and fecha_reprogramacion = ( select max(fecha_reprogramacion)
                                            from USRREPBI.REP_TOT_REPRO_2020
                                           where bccta  = v_Sccta
                                             and bcoper  = v_Scoper
                                             and fecha_reprogramacion <= fechafin
                                             and bcsbop  = v_Scsbop
                                             and extorno <> 'SI')
                                        --     and con_cptlzcn = '-')
           and bccta  = v_Sccta
           and bcoper  = v_Scoper
           and bcsbop  = v_Scsbop
           and extorno <> 'SI';
       --    and con_cptlzcn = '-'  ;
      exception
         when no_data_found then
           v_Freprog := null;
           v_flag:= 'N'; -- no reprogramado
           v_fechaPagoUno := null;
         when too_many_rows then
            select fecha_reprogramacion, 'S'
          into v_Freprog, V_flag
          from USRREPBI.REP_TOT_REPRO_2020
         where bccta  = v_Sccta
           and bcoper  = v_Scoper
           and fecha_reprogramacion = ( select max(fecha_reprogramacion)
                                            from USRREPBI.REP_TOT_REPRO_2020
                                           where bccta  = v_Sccta
                                             and bcoper  = v_Scoper
                                             and fecha_reprogramacion <= fechafin
                                             and bcsbop  = v_Scsbop
                                             and extorno <> 'SI')
                                        --     and con_cptlzcn = '-')
           and bccta  = v_Sccta
           and bcoper  = v_Scoper
           and bcsbop  = v_Scsbop
           and extorno <> 'SI'
           and rownum = 1;
      end;
  end;
  if v_Freprog is not null then -- Es Reprogramado
     v_fcuotauno := null;
      select /*+ parallel(n,2,1)*/
         min(n.ppfpag)
        into v_fcuotauno --fecha_pricuota
        from fsd601 n
       where n.pgcod = v_Pgcod
         and n.ppmod = v_Scmod
         and n.ppsuc = v_Scsuc
         and n.ppmda = v_Scmda
         and n.pppap = v_Scpap
         and n.ppcta = v_Sccta
         and n.ppoper = v_Scoper
         and n.ppsbop = v_Scsbop
         and n.pptope = v_Sctope
         and n.ppfpag >= v_Freprog
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
                           ppmod, ppcta, ppoper, pptope, ppfpag
                            from fsd602 o
                           where o.pgcod = n.pgcod
                             and o.ppmod = n.ppmod
                             and o.ppsuc = n.ppsuc
                             and o.ppmda = n.ppmda
                             and o.pppap = n.pppap
                             and o.ppcta = n.ppcta
                             and o.ppoper = n.ppoper
                             and o.ppsbop = n.ppsbop
                             and o.pptope = n.pptope
                             and o.ppfpag = n.ppfpag
                             and o.pp1fech <= fechafin
                             and o.pp1stat = 'T'
                             and o.d602co = 'S'
                             and (o.pp1cap + o.pp1int) <> 0);
     if v_fcuotauno is not null then -- Hay Pagos
        ---------------2da cuota-----------------
             select /*+ parallel(n,2,1)*/
                min(n.ppfpag)
               into Cuotados
               from fsd601 n
              where n.pgcod = v_Pgcod
                and n.ppmod = v_scmod
                and n.ppsuc = v_Scsuc
                and n.ppmda = v_scmda
                and n.pppap = v_scpap
                and n.ppcta = v_sccta
                and n.ppoper = v_scoper
                and n.ppsbop = v_Scsbop
                and n.pptope = v_Sctope
                and n.d601co = 'S'
                and n.ppfpag > v_fcuotauno;
              ---------------------------------------------
             if v_fcuotauno >= fechaini  and v_fcuotauno <=fechafin THEN
               --verificar v_situa
               v_fechaPagoUno := v_fcuotauno;
            --   v_monto17 := importepago;
               FlagUno := 'S'; -- Reprogramacion en el mes

             else
                if v_fcuotauno > fechafin then
                    FlagUno := 'S';--- pago adelantado
                --    v_monto17 := importepago;
                    v_fechaPagoUno := v_fcuotauno;

                else
                   FlagUno := 'N';
                     select count(*)
                       into nrocuota
                       from fsd611 f2,
                            fsd612 f3
                       where f2.pgcod = v_PGCOD
                         and f2.ppmod = v_scmod
                         and f2.ppsuc = v_scsuc
                         and f2.ppmda = v_scmda
                         and f2.pppap = v_scpap
                         and f2.ppcta = v_sccta
                         and f2.ppoper = v_scoper
                         and f2.ppsbop = v_scsbop
                         and f2.pptope = v_sctope
                         and f2.ppfpag >= v_Freprog
                         and f2.ppfpag <= fechafin
                         and f3.pgcod = f2.pgcod
                         and f3.ppmod = f2.ppmod
                         and f3.ppsuc = f2.ppsuc
                         and f3.ppmda = f2.ppmda
                         and f3.pppap = f2.pppap
                         and f3.ppcta = f2.ppcta
                         and f3.ppoper = f2.ppoper
                         and f3.ppsbop = f2.ppsbop
                         and f3.pptope = f2.pptope
                         and f3.ppfpag = f2.ppfpag;
                end if;
             end if;
             if flagUno = 'N' then
               if nrocuota = 1  then --- pago una cuota
                 v_fechaPagoUno := cuotados;


               elsif  nrocuota = 0 then
                 v_fechaPagoUno := cuotados;


                elsif nrocuota > 1 then  --tomar una anterior
                  v_fechaPagoUno := cuotados;

               end if;
             end if;
          else
             select /*+ parallel(n,2,1)*/
               max(n.ppfpag)
              into v_fechaPagoUno --fecha_pricuota
              from fsd602 n
             where n.pgcod =  v_Pgcod
               and n.ppmod = v_Scmod
               and n.ppsuc = v_Scsuc
               and n.ppmda = v_Scmda
               and n.pppap = v_Scpap
               and n.ppcta = v_sccta
               and n.ppoper = v_scoper
               and n.ppsbop = v_Scsbop
               and n.pptope = v_Sctope
               and n.ppfpag >= v_Freprog
               and n.d602co = 'S';
           if v_fechaPagoUno is null then
              select /*+ parallel(n,2,1)*/
                 min(n.ppfpag)
                into v_fechaPagoUno --fecha_pricuota
                from fsd601 n
               where n.pgcod = v_Pgcod
                 and n.ppmod = v_Scmod
                 and n.ppsuc = v_Scsuc
                 and n.ppmda = v_Scmda
                 and n.pppap = v_Scpap
                 and n.ppcta = v_sccta
                 and n.ppoper = v_scoper
                 and n.ppsbop = v_Scsbop
                 and n.pptope = v_Sctope
                 and n.ppfpag >= v_Freprog
                 and n.d601co = 'S'
                 and (n.ppcap + n.ppint) <> 0;
            end if;
           end if;
     else

        select min(f2.ppfpag)
                       into v_fechaPagoUno
                       from fsd611 f2--,
--                            fsd612 f3
                       where f2.pgcod = 1
                         and f2.ppmod = v_scmod
                         and f2.ppsuc = v_scsuc
                         and f2.ppmda = v_scmda
                         and f2.pppap = v_scpap
                         and f2.ppcta = v_sccta
                         and f2.ppoper = v_scoper
                         and f2.ppsbop = v_scsbop
                         and f2.pptope = v_sctope
                         and f2.ppfpag not in (select distinct f3.ppfpag
                                                 from fsd612 f3
                                                 where f3.pgcod = f2.pgcod
                                                   and f3.ppmod = f2.ppmod
                                                   and f3.ppsuc = f2.ppsuc
                                                   and f3.ppmda = f2.ppmda
                                                   and f3.pppap = f2.pppap
                                                   and f3.ppcta = f2.ppcta
                                                   and f3.ppoper = f2.ppoper
                                                   and f3.ppsbop = f2.ppsbop
                                                   and f3.pptope = f2.pptope
                                                   and f3.ppfpag = f2.ppfpag);


     end if;

end Valida_Repro;
---nuevo proceso optimizado para correr con mas jobs
Procedure Sp_carga_III(pn_desde in number,
                       pn_hasta in number,
                       pd_fecpro in date) is

   cursor creditos is
    select a.*,b.pp001aux2 -- sma 15/04/2020 verificamos que  los seguros existan
        from jaqz085_aux a,
             fpp001 b
       where b.pgcod = a.jaqz085emp
         and b.aomod = a.jaqz085mod
         and b.aosuc = a.jaqz085suc
         and b.aomda = a.jaqz085mda
         and b.aopap = a.jaqz085pap
         and b.aocta = a.jaqz085cta
         and b.aooper = a.jaqz085ope
         and b.aosbop = a.jaqz085sbo
         and b.aotope = a.jaqz085top
         and b.sgcod  = a.jaqz085seg
         and a.jaqZ085cta between pn_desde and pn_hasta
         ;

    cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';

    ln_numpol    number(10);
    ld_fecvini   date;
    ld_fecvfin   date;
    ln_tasa      number(17, 6);
    ln_monto     number(17, 6);
  --  ln_salcap    number(17, 2);
    ln_grupo     number(2);
    lc_plan      char(30);
    ln_instancia number(10);
    ln_mtoapr    number(17, 2):= 0;
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    lc_petipo    char(1);
    lc_apepat    char(30);
    lc_apemat    char(30);
    lc_nombre    char(50);
    lc_razsoc    char(70);
    lc_sexo      char(1);
    ld_fecnac    date;
    ln_paij      number(3);
    ln_tdoj      number(2);
    lc_ndoj      char(12);
    ld_fecant    date;
    lc_numcre    char(25);
    ln_aoimp     number(17, 2);
    ln_sucAct    number(3);

    ln_mtoCalen   number(17, 2);
    ln_salcal     number(17, 2);
    ld_Fec        date;
    lc_tip        char(1);
    ln_periodo    number(5);
    ln_estado     number(2);
    ln_gracia     number(1);
    ld_primcuo    date;
    ln_parcial    number;
    ln_montoPar   number;
    ln_montoxtasa number;
    lc_flgJud     char(1) := 'N';
    lc_telefono   char(100);
    lc_correo     char(100);
    ln_cont       number := 0;
    ln_cont1      number := 0;
    ln_diasAtraso number:= 0;
    lc_hora       char(8);
    TipoRepro     char(2);

    ln_mtoCalen1 number(17,2);
    ld_fproxpag  date;
    lc_ajuste    varchar2(20);
    lc_vencido   varchar2(20);
    lc_reprog    varchar2(20);
    lc_modo      varchar2(20);
    lc_situa     varchar2(20);
    lc_proceso   varchar2(20);
    lc_mtosol    number (17,2):=0;
    ln_montomca  number (17,2):=0;
    ln_pagoprima number (17,2):=0;
    lc_registra  char(1);
    ln_monto17   number  (17,2):=0;
    ln_Tasa1     number(17,6):=0;
    ld_fecpago   date;
    ln_prima     number(17,2):=0;
    ln_flag22    number:=0;

    lc_TipoRepro varchar2(20);
    lc_Cartera   varchar2(20);
    lc_Declarar  varchar2(20);
    lc_flagRepro varchar2(1);
    ld_frep_uno  date;
    v_desembolso varchar2(20);
    fechainicial date;
    ln_aux8     number;

    montoSolidario number(17,2);
    importe80 number(17,2);
    ln_monto15 number(17,2);

    ld_fecha_repro date;
    ln_mtodesem number(17,2);
  begin
    begin

      --ld_fecant := last_day(add_months(pd_fecpro,-1));
      for i in creditos loop
        lc_tip    := null;
        ln_grupo  := null;
        lc_plan   := null;
        ln_gracia := 0;
        ld_fecpago := i.jaqz085fval;
        ln_prima  := i.jaqz085mpa;
        ln_pagoprima := i.jaqz085mpa;
        --mod@abr 20181107
        lc_flgJud := Pq_Cr_Tramdesgra.Fn_cr_estado(pn_emp    => i.jaqz085emp,
                                                   pn_mod    => i.JAQZ085MOD,
                                                   pn_mda    => i.jaqz085mda,
                                                   pn_pap    => i.jaqz085pap,
                                                   pn_cta    => i.jaqz085cta,
                                                   pn_ope    => i.jaqz085ope,
                                                   pn_sbo    => i.jaqz085sbo,
                                                   pn_top    => i.jaqz085top,
                                                   pd_fecpro => pd_fecpro);
        if lc_flgJud = 'N' then
          --instancia
          ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                               i.JAQZ085SUC,
                                               i.JAQZ085MDA,
                                               i.JAQZ085PAP,
                                               i.JAQZ085CTA,
                                               i.JAQZ085OPE,
                                               i.JAQZ085SBO,
                                               i.JAQZ085TOP);
          if nvl(ln_instancia, 0) = 0 then
            begin
              select a.aosuc
                into ln_sucAct
                from fsd010 a
               where a.pgcod = i.JAQZ085EMP
                 and a.aomod = i.JAQZ085MOD
                 and a.aomda = i.JAQZ085MDA
                 and a.aopap = i.JAQZ085PAP
                 and a.aocta = i.JAQZ085CTA
                 and a.aooper = i.JAQZ085OPE
                 and a.aosbop = i.JAQZ085SBO
                 and a.aotope = i.JAQZ085TOP;
            exception
              when others then
                null;
            end;
            ln_instancia := fn_instancia_credito(i.JAQZ085MOD,
                                                 ln_sucAct,
                                                 i.JAQZ085MDA,
                                                 i.JAQZ085PAP,
                                                 i.JAQZ085CTA,
                                                 i.JAQZ085OPE,
                                                 i.JAQZ085SBO,
                                                 i.JAQZ085TOP);

          else
            ln_sucAct := i.JAQZ085SUC;
          end if;

          --fecha de desembolso,monto desembolsado,periodo, monto desembolsado
          begin
            select aofval, aoimp, aoperiod, aostat, aoimp
              into ld_fecant, ln_aoimp, ln_periodo, ln_estado, ln_mtodesem
              from fsd010 a
             where a.pgcod = i.JAQZ085EMP
               and a.aomod = i.JAQZ085MOD
               and a.aosuc = ln_sucAct --i.JAQZ085SUC
               and a.aomda = i.JAQZ085MDA
               and a.aopap = i.JAQZ085PAP
               and a.aocta = i.JAQZ085CTA
               and a.aooper = i.JAQZ085OPE
               and a.aosbop = i.JAQZ085SBO
               and a.aotope = i.JAQZ085TOP;

          exception
            when no_data_found then
              begin
                select aofval, aoimp, aoperiod, aostat
                  into ld_fecant, ln_aoimp, ln_periodo, ln_estado
                  from fsd010 a
                 where a.pgcod = i.JAQZ085EMP
                   and a.aomod = i.JAQZ085MOD
                      --and a.aosuc  = i.JAQZ085SUC
                   and a.aomda = i.JAQZ085MDA
                   and a.aopap = i.JAQZ085PAP
                   and a.aocta = i.JAQZ085CTA
                   and a.aooper = i.JAQZ085OPE
                   and a.aosbop = i.JAQZ085SBO
                   and a.aotope = i.JAQZ085TOP;

              exception
                when no_data_found then
                  ld_fecant  := null;
                  ln_aoimp   := null;
                  ln_periodo := null;
                  ln_estado  := null;
              end;

          end;

          -- Numero de poliza
          if i.jaqz085mda = 0 then
            ln_numpol := 235901;
          else
            ln_numpol := 235899;
          end if;
          --fecha de vigencia inicial
          ld_fecvini :=  TRUNC(pd_fecpro,'MM');

          --fecha de vigencia final
          ld_fecvfin := pd_fecpro; --i.jaqz085fec;

          --monto de la prima
          ln_monto := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.JAQZ085EMP,
                                                              i.JAQZ085MOD,
                                                              ln_sucAct,
                                                              i.JAQZ085MDA,
                                                              i.JAQZ085PAP,
                                                              i.JAQZ085CTA,
                                                              i.JAQZ085OPE,
                                                              i.JAQZ085SBO,
                                                              i.JAQZ085TOP);
          --saldo capital y grupo

          --grupo
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.JAQZ085EMP,
                                                  i.JAQZ085MOD,
                                                  ln_sucAct,
                                                  i.JAQZ085MDA,
                                                  i.JAQZ085PAP,
                                                  i.JAQZ085CTA,
                                                  i.JAQZ085OPE,
                                                  i.JAQZ085SBO,
                                                  i.JAQZ085TOP);
          --monto calendario de pago
          pq_cr_tramdesgra.Sp_monto_calendario(i.JAQZ085EMP,
                                               i.JAQZ085MOD,
                                               ln_sucAct,
                                               i.JAQZ085MDA,
                                               i.JAQZ085PAP,
                                               i.JAQZ085CTA,
                                               i.JAQZ085OPE,
                                               i.JAQZ085SBO,
                                               i.JAQZ085TOP,
                                               2,
                                               i.jaqz085fval, --pd_fecpro, fecha pago
                                               ln_mtoCalen,
                                               lc_tip);
          ln_montomca := ln_mtoCalen;--18/06/2020 SMA
          --saldo capital calendario de pagos
          ln_salcal := pq_cr_tramdesgra.Fn_scap_calendario(i.JAQZ085EMP,
                                                           i.JAQZ085MOD,
                                                           ln_sucAct,
                                                           i.JAQZ085MDA,
                                                           i.JAQZ085PAP,
                                                           i.JAQZ085CTA,
                                                           i.JAQZ085OPE,
                                                           i.JAQZ085SBO,
                                                           i.JAQZ085TOP,
                                                           pd_fecpro,
                                                           i.jaqz085fval);

          --tipo SBS RCC si es nulo

          if ln_grupo is null then
            ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz085EMP,
                                                        i.jaqz085MOD,
                                                        ln_sucAct,
                                                        i.jaqz085MDA,
                                                        i.jaqz085PAP,
                                                        i.jaqz085CTA,
                                                        i.jaqz085OPE,
                                                        i.jaqz085SBO,
                                                        i.jaqz085TOP);
          end if;

          --plan
          case
            when ln_grupo in (2, 12, 13) then
              lc_plan := 'PYME';
            when ln_grupo = 3 then
              lc_plan := 'CONSUMO';
            when ln_grupo = 4 then
              lc_plan := 'HIPOTECARIO';
            else
              null;
          end case;

          --monto aprobado
          ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);

          ---verificar si es desembolso parcial sma04/10/2018
          begin
            select 1, sum(sng017mto)
              into ln_parcial, ln_montopar
              from sng001
             Where SNG001Inst = ln_instancia
               and sng001ori = 7;
          exception
            when no_data_found then
              ln_parcial := 0;
          end;
          if ln_parcial = 1 and
             ((ln_montopar is not null) and ln_montopar <> 0) then
            ln_montoxtasa := ln_montopar;
          else
            if ln_mtoapr <> 0 or ln_mtoapr is not null then
               ln_montoxtasa := ln_mtoapr;
            ELSE
              ln_mtoapr := ln_aoimp;
               ln_montoxtasa := ln_mtoapr;
            END IF;
          end if;
          --tasa

          ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.JAQZ085EMP,
                                                                  i.JAQZ085MOD,
                                                                  ln_sucAct,
                                                                  i.JAQZ085MDA,
                                                                  i.JAQZ085PAP,
                                                                  i.JAQZ085CTA,
                                                                  i.JAQZ085OPE,
                                                                  i.JAQZ085SBO,
                                                                  i.JAQZ085TOP,
                                                                  ln_montoxtasa);

            ln_Tasa1 := ln_tasa;
          --numero de credito
          lc_numcre := to_char(LPAD(i.JAQZ085CTA, 9, '0') ||
                               LPAD(i.JAQZ085OPE, 9, '0') ||
                               LPAD(i.JAQZ085SBO, 3, '0'));

          --datos persona
          begin
            select a.pepais, a.petdoc, a.pendoc
              into ln_pai, ln_tdo, lc_ndo
              from fsr008 a
             where a.ctnro = i.jaqz085cta
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
              lc_petipo := null;
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
            select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

          --if lc_petipo <> 'F' then

          --end if;

          begin
            select a.pfpai1, a.pftdo1, a.pfndo1
              into ln_paij, ln_tdoj, lc_ndoj
              from fsr003 a
             where a.pjpais = ln_pai
               and a.pjtdoc = ln_tdo
               and a.pjndoc = lc_ndo;
          exception
            when too_many_rows then
              begin
                select a.pfpai1, a.pftdo1, a.pfndo1
                  into ln_paij, ln_tdoj, lc_ndoj
                  from fsr003 a
                 where a.pjpais = ln_pai
                   and a.pjtdoc = ln_tdo
                   and a.pjndoc = lc_ndo
                   and a.vicod <> 1
                   and rownum = 1;
              exception
                when no_data_found then
                  null;

              end;
            when no_data_found then
              null;
          end;
          --fecha de nacimiento
          if lc_petipo = 'F' then
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
              select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

          end if;
          -- telefono y correo smarquez 17102019
          lc_telefono := null;
          lc_correo := null;
          For t in telefono(ln_pai,ln_tdo,lc_ndo)loop
            if ln_cont = 0 then
              lc_telefono := trim(t.fono);
            else
              lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
            end if;
             ln_cont := ln_cont + 1;
          end loop;

           For c in correo(ln_pai,ln_tdo,lc_ndo)loop
            if ln_cont1 = 0 then
              lc_correo := trim(c.mail);
            else
              lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
            end if;
             ln_cont1 := ln_cont1 + 1;
          end loop;
          --fecha de la cuota por vencer
          ld_Fec := null;
          pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz085EMP,
                                           i.jaqz085MOD,
                                           ln_sucAct,
                                           i.jaqz085MDA,
                                           i.jaqz085PAP,
                                           i.jaqz085CTA,
                                           i.jaqz085OPE,
                                           i.jaqz085SBO,
                                           i.jaqz085TOP,
                                           pd_fecpro,
                                           ld_Fec);
          --dias de gracia

          ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.jaqz085EMP,
                                                       i.jaqz085MOD,
                                                       ln_sucAct,
                                                       i.jaqz085MDA,
                                                       i.jaqz085PAP,
                                                       i.jaqz085CTA,
                                                       i.jaqz085OPE,
                                                       i.jaqz085SBO,
                                                       i.jaqz085TOP);
          --fecha de la primera cuota
          ld_primcuo := null;
          pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz085EMP,
                                            i.jaqz085MOD,
                                            ln_sucAct,
                                            i.jaqz085MDA,
                                            i.jaqz085PAP,
                                            i.jaqz085CTA,
                                            i.jaqz085OPE,
                                            i.jaqz085SBO,
                                            i.jaqz085TOP,
                                            pd_fecpro,
                                            ld_primcuo);

         ln_diasAtraso := pq_cr_tramdesgra.fn_dias_atraso(pd_fecpro,
                                                       i.jaqz085EMP,
                                                       i.jaqz085MOD,
                                                       ln_sucAct,
                                                       i.jaqz085MDA,
                                                       i.jaqz085PAP,
                                                       i.jaqz085CTA,
                                                       i.jaqz085OPE,
                                                       i.jaqz085SBO,
                                                       i.jaqz085TOP,
                                                     --  ln_estado,
                                                       ld_Fec);
        --- if ln_tasa = 0 then

            pq_cr_tramdesgra.valida_tasa(i.jaqz085EMP,
                                         i.jaqz085MOD,
                                         ln_sucAct,
                                         i.jaqz085MDA,
                                         i.jaqz085PAP,
                                         i.jaqz085CTA,
                                         i.jaqz085OPE,
                                         i.jaqz085SBO,
                                         i.jaqz085TOP,
                                         i.jaqz085seg,
                                         ln_mtoapr, --ln_prima
                                         ln_Tasa1,
                                         ln_mtodesem, ---monto desembolsaso sma 20241210
                                         lc_plan,
                                         pd_fecpro,
                                         ld_fecant, ---sma 28122020
                                         i.jaqz085fval,--ld_fecpago,                                       
                                         ln_tasa);
       --  end if;
       --  if pd_fecpro > to_date('01/03/2020') then
          lc_TipoRepro := null; -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
          lc_Cartera := null;   --'null' ,'Desembolsado'
          lc_Declarar := null;   --'Declarar', 'No Declarar'
          lc_flagRepro := null;
          ld_frep_uno := null;
          ld_fecha_repro:= null;
          lc_situa := null;
          lc_proceso := null;
          ln_monto17 := 0;
          ln_aux8 := 0;

          Reprogramacion2022(i.jaqz085EMP,
                               i.jaqz085MOD,
                               ln_sucAct,
                               i.jaqz085MDA,
                               i.jaqz085PAP,
                               i.jaqz085CTA,
                               i.jaqz085OPE,
                               i.jaqz085SBO,
                               i.jaqz085TOP,
                               pd_fecpro,
                               i.jaqz085seg,
                               i.jaqz085fval, --sma 07/07/2023
                               lc_tip, --tipo pago 'P' o 'C'
                               ln_mtoCalen,
                               ln_salcal,
                               ln_tasa,
                               ld_Fec,
                               lc_TipoRepro, -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
                               lc_Cartera,   --'null' ,'Desembolsado'
                               lc_Declarar,  --'Declarar', 'No Declarar'
                               lc_flagRepro,
                               ld_frep_uno,
                               ld_fecha_repro, --sma 07/07/2023
                               lc_situa,
                               lc_proceso,
                               ln_monto17,
                               ln_aux8 );


       --  end if;
            ln_mtoCalen1:= 0;
            ld_fproxpag := null;
            fechainicial := TRUNC(pd_fecpro,'MM');

            if ld_fecant >=  fechainicial and ld_fecant <= pd_fecpro then
                -----Verifica Digital---
                Begin
                  Select 'Digital'
                    into v_desembolso
                    from fsh016
                   where pgcod = 1
                     and hcmod = 489
                     and hsucor =907
                     and htran = 951
                     and hfcon = ld_fecant
                     and hcord = 10
                     and hmodul = i.jaqz085mod
                     and htoper = i.jaqz085top
                     and hsucur = i.jaqz085suc
                     and hcta = i.JAQZ085CTA
                     and hoper = i.JAQZ085OPE
                     and hsubop = i.jaqz085sbo;
                     lc_Cartera :='Desembolsado';
                exception
                  when no_data_found then
                    begin
                      Select 'Digital'
                        into v_desembolso
                        from fsh016
                       where pgcod = 1
                         and hcmod = 489
                         and hsucor =907
                         and htran = 360
                         and hfcon = ld_fecant
                         and hcord = 10
                         and hmodul = i.jaqz085mod
                         and htoper = i.jaqz085top
                         and hsucur = i.jaqz085suc
                         and hcta = i.JAQZ085CTA
                         and hoper = i.JAQZ085OPE;
                        -- and hsubop = i.jaqz085sub;
                         lc_Cartera :='Desembolsado';
                    exception
                      when no_data_found then
                        v_desembolso := 'Ventanilla';
                    end;
                end;
          end if;

           --- VALIDACIONES POR REPROGRAMACIONES
          ln_flag22 := 0;

          if  i.jaqz085seg >= 250 and i.jaqz085seg <= 338 then
              lc_ajuste := 'Codigo Anterior';
          else
             if i.jaqz085seg >= 351 and i.jaqz085seg <= 408 then
               lc_ajuste := 'Basico';
             else
               if i.jaqz085seg >= 411 and i.jaqz085seg <= 498 then
                 lc_ajuste := 'Devolucion';
               else
                 lc_ajuste := null;
               end if;
             end if;
           end if;
           BEgin
            montoSolidario := 0;
            importe80 := 0;
            select fpp080au4 , fpp080imp
              into montoSolidario, importe80
              from fpp080
            where FPP080EMP = i.JAQZ085EMP
              and FPP080TSE = 5
              and FPP080SEG = i.jaqz085seg
              and FPP080SUC = i.JAQZ085SUC
              and FPP080MOD = i.JAQZ085MOD
              and FPP080CTA = i.JAQZ085CTA
              and FPP080MDA = i.JAQZ085MDA
              and FPP080PAP = i.JAQZ085PAP
              and FPP080OPE = i.JAQZ085OPE
              and FPP080SBO = i.JAQZ085SBO
              and FPP080TOP = i.JAQZ085TOP
              and FPP080FEC = i.JAQZ085FEC
              and FPP080FPA = i.jaqz085fval
              and fpp080a11 <>'S';
          exception
            when no_data_found then
              montoSolidario := 0;
              importe80 := 0;
            when too_many_rows then
               select fpp080au4 , fpp080imp
              into montoSolidario, importe80
              from fpp080
            where FPP080EMP = i.JAQZ085EMP
              and FPP080TSE = 5
              and FPP080SEG = i.jaqz085seg
              and FPP080SUC = i.JAQZ085SUC
              and FPP080MOD = i.JAQZ085MOD
              and FPP080CTA = i.JAQZ085CTA
              and FPP080MDA = i.JAQZ085MDA
              and FPP080PAP = i.JAQZ085PAP
              and FPP080OPE = i.JAQZ085OPE
              and FPP080SBO = i.JAQZ085SBO
              and FPP080TOP = i.JAQZ085TOP
              and FPP080FEC = i.JAQZ085FEC
              and FPP080FPA = i.jaqz085fval
              and fpp080a11 <>'S'
              and rownum = 1 ;
          end;
          if montoSolidario <> 0 then
            ln_monto15 := montoSolidario;
          else
            ln_monto15 := importe80;
          end if;

              begin
                insert into JAQZ085
                  (JAQZ085EMP,
                   JAQZ085MOD,
                   JAQZ085SUC,
                   JAQZ085MDA,
                   JAQZ085PAP,
                   JAQZ085CTA,
                   JAQZ085OPE,
                   JAQZ085SBO,
                   JAQZ085TOP,
                   JAQZ085FEC,
                   JAQZ085MPA,
                   JAQZ085MAP,
                   JAQZ085FEI,
                   JAQZ085FEF,
                   JAQZ085NUM,
                   JAQZ085TAS,
                   JAQZ085MPR, /*JAQZ085SCA,*/
                   JAQZ085GRU,
                   JAQZ085PLA,
                   JAQZ085PAI,
                   JAQZ085TDO,
                   JAQZ085NDO,
                   JAQZ085TPE,
                   JAQZ085SEX,
                   JAQZ085FNA,
                   JAQZ085APT,
                   JAQZ085APM,
                   JAQZ085NOM,
                   JAQZ085RZO,
                   JAQZ085NUC,
                   JAQZ085IMP,
                   JAQZ085SUA,
                   JAQZ085MCA,
                   JAQZ085SCL,
                   JAQZ085FVE,
                   JAQZ085TIP,
                   JAQZ085PER,
                   JAQZ085EST,
                   JAQZ085FDE,
                   JAQZ085DGA,
                   JAQZ085FPR,
                   JAQZ085TLF,
                   JAQZ085MAIL,
                   jaqz085aux1,
                   jaqz085aux3,
                   jaqz085aux5,
                   jaqz085aux2,
                   jaqz085aux7,
                   jaqz085aux9,
                   jaqz085aux6,
                   jaqz085aux10,
                   jaqz085mail1,
                   jaqz085aux12,
                   jaqz085aux13,
                   jaqz085aux14,
                   jaqz085aux15,
                   jaqz085aux18,
                   jaqz085aux19,
                   jaqz085aux17,
                   jaqz085aux4,
                   jaqz085aux8,
                   jaqz085aux20, -- sma 07/07/23
                   jaqz085aux21 -- sma 07/07/23
                   )
                Values
                  (i.JAQZ085EMP,
                   i.JAQZ085MOD,
                   i.JAQZ085SUC,
                   i.JAQZ085MDA,
                   i.JAQZ085PAP,
                   i.JAQZ085CTA,
                   i.JAQZ085OPE,
                   i.JAQZ085SBO,
                   i.JAQZ085TOP,
                   i.JAQZ085FEC,
                   i.JAQZ085MPA,
                   ln_mtoapr,
                   ld_fecvini,
                   ld_fecvfin,
                   ln_numpol,
                   ln_tasa,
                   ln_monto, /*ln_salcap,*/
                   ln_grupo,
                   lc_plan,
                   ln_pai,
                   ln_tdo,
                   lc_ndo,
                   lc_petipo,
                   lc_sexo,
                   ld_fecnac,
                   lc_apepat,
                   lc_apemat,
                   lc_nombre,
                   lc_razsoc,
                   lc_numcre,
                   ln_aoimp,
                   ln_sucAct,
                   ln_mtoCalen,
                   ln_salcal,
                   ld_Fec,
                   lc_tip,
                   ln_periodo,
                   ln_estado,
                   ld_fecant,
                   ln_gracia,
                   ld_primcuo,
                   lc_telefono,
                   lc_correo,
                   i.jaqz085seg,
                   lc_Cartera,
                   i.jaqz085fval,
                   lc_TipoRepro, -- 'R.Sin Capitalizacion','R.Con Capitalizacion', null
                   ln_mtoCalen1,
                   ld_fproxpag,
                   lc_ajuste,
                   v_desembolso,--lc_vencido,
                   lc_reprog,
                   lc_modo,
                   lc_situa,
                   lc_proceso,
                   ln_monto15, --montosolidario,---lc_mtosol,
                   ln_pagoprima,
                   ln_diasAtraso,
                   ln_monto17,
                   lc_declarar,
                   ln_aux8,
                   ld_frep_uno,  --fecha primer pago
                   ld_fecha_repro); -- fecha reprogramacion
              exception
                when dup_val_on_index then
                  null;
              end;
              commit;
          end if;

          Begin
            insert into JAQZ085H
              (JAQZ085HEMP,
               JAQZ085HMOD,
               JAQZ085HSUC,
               JAQZ085HMDA,
               JAQZ085HPAP,
               JAQZ085HCTA,
               JAQZ085HOPE,
               JAQZ085HSBO,
               JAQZ085HTOP,
               JAQZ085HFEC,
               JAQZ085HMPA,
               JAQZ085HMAP,
               JAQZ085HFEI,
               JAQZ085HFEF,
               JAQZ085HNUM,
               JAQZ085HTAS,
               JAQZ085HMPR, /*JAQZ085HSCA,*/
               JAQZ085HGRU,
               JAQZ085HPLA,
               JAQZ085HPAI,
               JAQZ085HTDO,
               JAQZ085HNDO,
               JAQZ085HTPE,
               JAQZ085HSEX,
               JAQZ085HFNA,
               JAQZ085HAPT,
               JAQZ085HAPM,
               JAQZ085HNOM,
               JAQZ085HRZO,
               JAQZ085HNUC,
               JAQZ085HIMP,
               JAQZ085HSUA,
               JAQZ085HMCA,
               JAQZ085HSCL,
               JAQZ085HFVE,
               JAQZ085HTIP,
               JAQZ085HPER,
               JAQZ085HEST,
               JAQZ085HFDE,
               JAQZ085HDGA,
               JAQZ085HFPR,
               JAQZ085HTLF,
               JAQZ085HMAIL,
               jaqz085haux1,
               jaqz085haux3,
               jaqz085haux5,
               jaqz085haux2,
               jaqz085haux7,
               jaqz085haux9,
               jaqz085haux6)
            Values
              (i.JAQZ085EMP,
               i.JAQZ085MOD,
               i.JAQZ085SUC,
               i.JAQZ085MDA,
               i.JAQZ085PAP,
               i.JAQZ085CTA,
               i.JAQZ085OPE,
               i.JAQZ085SBO,
               i.JAQZ085TOP,
               i.JAQZ085FEC,
               i.JAQZ085MPA,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               lc_numcre,
               ln_aoimp,
               ln_sucAct,
               ln_mtoCalen,
               ln_salcal,
               ld_Fec,
               lc_tip,
               ln_periodo,
               ln_estado,
               ld_fecant,
               ln_gracia,
               ld_primcuo,
               lc_telefono,
               lc_correo,
               i.jaqz085seg,
               ln_diasAtraso,
               i.jaqz085fval,
               TipoRepro,
               ln_mtoCalen1,
               ld_fproxpag,
               lc_ajuste);
          exception
            when dup_val_on_index then
              null;
          end;

          commit;

      end loop;

    end;
  end Sp_carga_III;
  ---Adicion de procesdimientos optimizados
  Procedure Sp_Carga_Desem_I(pn_desde in number,
                             pn_hasta in number,
                             pd_fecini  in date,
                             pd_fecfin  in date) is

    cursor creditos is
      select *
        from jaqz097_aux
       where jaqZ097cta BETWEEN pn_desde AND pn_hasta;--- ), -1, 1)) = P_C_DIGITO;

    cursor telefono (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%';

    ln_numpol    number(10);
    ld_fecvini   date;
    ld_fecvfin   date;
    ln_tasa      number(17, 6);
    ln_monto     number(17, 6);
    ln_monto_tot number(17, 6);
    --ln_salcap    number(17, 2);
    ln_grupo     number(2);
    lc_plan      char(30);
    ln_instancia number(10);
    ln_mtoapr    number(17, 2);
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    lc_petipo    char(1);
    lc_apepat    char(30);
    lc_apemat    char(30);
    lc_nombre    char(50);
    lc_razsoc    char(70);
    lc_sexo      char(1);
    ld_fecnac    date;
    ln_paij      number(3);
    ln_tdoj      number(2);
    lc_ndoj      char(12);
    lc_numcre    number(25);
    ln_gracia    number(1);

    ln_mtoCalen NUMBER(17, 2);
    ln_mtoFin number(17, 2);
    ld_Fec    date;
    lc_tip    char(1);
    ld_Fecpri date;
    lc_telefono   char(100);
    lc_correo     char(100);
    ln_cont       number := 0;
    ln_cont1      number := 0;
    fechalinea    date;
    ln_tip        char(30);
  begin

    begin

      for i in creditos loop
        lc_tip    := null;
        ln_grupo  := null;
        lc_plan   := null;
        ln_gracia := 0;
        -- Numero de poliza
        if i.jaqz097mda = 0 then
          ln_numpol := 235901;
        else
          ln_numpol := 235899;
        end if;
        --fecha de vigencia inicial
        ld_fecvini := to_date('01' || to_char(i.jaqz097fva, 'mmyyyy'),
                              'dd/mm/yyyy');
        --fecha de vigencia final
        ld_fecvfin := pd_fecfin;

        --monto de la prima
        ln_monto := pq_cr_tramdesgra.fn_monto_prima_cuo(i.jaqz097emp,
                                                        i.jaqz097mod,
                                                        i.jaqz097suc,
                                                        i.jaqz097mda,
                                                        i.jaqz097pap,
                                                        i.jaqz097cta,
                                                        i.jaqz097ope,
                                                        i.jaqz097sbo,
                                                        i.jaqz097top);

        --monto de la prima total
        ln_monto_tot := pq_cr_seguro_desgravamen.fn_MONTO_PRIMA(i.jaqz097emp,
                                                                i.jaqz097mod,
                                                                i.jaqz097suc,
                                                                i.jaqz097mda,
                                                                i.jaqz097pap,
                                                                i.jaqz097cta,
                                                                i.jaqz097ope,
                                                                i.jaqz097sbo,
                                                                i.jaqz097top);

        --saldo capital y grupo

        --grupo
        ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS(i.jaqz097emp,
                                                i.jaqz097mod,
                                                i.jaqz097suc,
                                                i.jaqz097mda,
                                                i.jaqz097pap,
                                                i.jaqz097cta,
                                                i.jaqz097ope,
                                                i.jaqz097sbo,
                                                i.jaqz097top);

        --tipo SBS RCC si es nulo



        --instancia
        ln_instancia := fn_instancia_credito(i.jaqz097mod,
                                             i.jaqz097SUC,
                                             i.jaqz097MDA,
                                             i.jaqz097PAP,
                                             i.jaqz097CTA,
                                             i.jaqz097OPE,
                                             i.jaqz097SBO,
                                             i.jaqz097TOP);
        --- grupo
        if ln_grupo is null then
          ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(i.jaqz097emp,
                                                      i.jaqz097MOD,
                                                      i.jaqz097SUC,
                                                      i.jaqz097MDA,
                                                      i.jaqz097PAP,
                                                      i.jaqz097CTA,
                                                      i.jaqz097OPE,
                                                      i.jaqz097SBO,
                                                      i.jaqz097TOP);
        end if;

        --plan
        begin
           select trim(substr(wfattsval, instr(wfattsval, ';', 1) + 1, 25))
             into ln_tip
             from wfattsvalues
            where wfattsid = 'TIPO_CREDITO'
              and wfinsprcid = ln_instancia
              and substr(wfattsval, 1, instr(wfattsval, ';', 1) - 1) = ln_grupo;
        exception
          when no_data_found then
            ln_tip := ' ';
        end;
        case
          when ln_grupo in (2, 12, 13) then

            lc_plan := 'PYME'||' '||substr(ln_tip,1,25); ---ln_tip;
          when ln_grupo = 3 then

            lc_plan := 'CONSUMO'||' '||substr(ln_tip,1,22);
          when ln_grupo = 4 then

            lc_plan := 'HIPOTECARIO'||' '||substr(ln_tip,1,18); ---ln_tip;
          else
            null;
        end case;

        --monto aprobado
        ln_mtoapr := pq_cr_tramdesgra.fn_montoAprobado(ln_instancia);
        --tasa
        ln_tasa := pq_cr_seguro_desgravamen.FN_TASA_DESGRAVAMEN(i.jaqz097emp,
                                                                i.jaqz097MOD,
                                                                i.jaqz097SUC,
                                                                i.jaqz097MDA,
                                                                i.jaqz097PAP,
                                                                i.jaqz097CTA,
                                                                i.jaqz097OPE,
                                                                i.jaqz097SBO,
                                                                i.jaqz097TOP,
                                                                ln_mtoapr);

        --monto calendario de pago
        pq_cr_tramdesgra.Sp_monto_calendario(i.jaqz097emp,
                                             i.jaqz097MOD,
                                             i.jaqz097SUC,
                                             i.jaqz097MDA,
                                             i.jaqz097PAP,
                                             i.jaqz097CTA,
                                             i.jaqz097OPE,
                                             i.jaqz097SBO,
                                             i.jaqz097TOP,
                                             1,
                                             pd_fecfin,
                                             ln_mtoCalen,
                                             lc_tip);

        --numero de credito
        lc_numcre := to_char(LPAD(i.JAQZ097CTA, 9, '0') ||
                             LPAD(i.JAQZ097OPE, 9, '0') ||
                             LPAD(i.JAQZ097SBO, 3, '0'));

        --datos persona
        begin
          select a.pepais, a.petdoc, a.pendoc
            into ln_pai, ln_tdo, lc_ndo
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
            lc_petipo := null;
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
          select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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
          select a.pfpai1, a.pftdo1, a.pfndo1
            into ln_paij, ln_tdoj, lc_ndoj
            from fsr003 a
           where a.pjpais = ln_pai
             and a.pjtdoc = ln_tdo
             and a.pjndoc = lc_ndo;
        exception
          when too_many_rows then
            begin
              select a.pfpai1, a.pftdo1, a.pfndo1
                into ln_paij, ln_tdoj, lc_ndoj
                from fsr003 a
               where a.pjpais = ln_pai
                 and a.pjtdoc = ln_tdo
                 and a.pjndoc = lc_ndo
                 and a.vicod <> 1
                 and rownum = 1;
            exception
              when no_data_found then
                null;

            end;
          when no_data_found then
            null;
        end;
        --fecha de nacimiento
        if lc_petipo = 'F' then
          --mod 2016.04.14
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
            select trim(a.pfnom1) || ' ' || trim(a.pfnom2)
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

        end if; --mod 2016.04.14

        ln_gracia := pq_cr_tramdesgra.fn_dias_gracia(i.JAQZ097EMP,
                                                     i.JAQZ097MOD,
                                                     i.JAQZ097SUC,
                                                     i.JAQZ097MDA,
                                                     i.JAQZ097PAP,
                                                     i.JAQZ097CTA,
                                                     i.JAQZ097OPE,
                                                     i.JAQZ097SBO,
                                                     i.JAQZ097TOP);

        --suma asegurada
        ln_mtoFin := null;
        ln_mtoFin := pq_cr_tramdesgra.Fn_montoDes(i.jaqz097emp,
                                                  i.jaqz097MOD,
                                                  i.jaqz097SUC,
                                                  i.jaqz097MDA,
                                                  i.jaqz097PAP,
                                                  i.jaqz097CTA,
                                                  i.jaqz097OPE,
                                                  i.jaqz097SBO,
                                                  i.jaqz097TOP,
                                                  pd_fecfin);

        --fecha de la cuota por vencer
        ld_Fec := null;
        pq_cr_tramdesgra.Sp_Cuota_Vencer(i.jaqz097emp,
                                         i.jaqz097MOD,
                                         i.jaqz097SUC,
                                         i.jaqz097MDA,
                                         i.jaqz097PAP,
                                         i.jaqz097CTA,
                                         i.jaqz097OPE,
                                         i.jaqz097SBO,
                                         i.jaqz097TOP,
                                         pd_fecfin,
                                         ld_Fec);

        --fecha de primera cuota
        ld_Fecpri := null;
        pq_cr_tramdesgra.Sp_Primera_Cuota(i.jaqz097emp,
                                          i.jaqz097MOD,
                                          i.jaqz097SUC,
                                          i.jaqz097MDA,
                                          i.jaqz097PAP,
                                          i.jaqz097CTA,
                                          i.jaqz097OPE,
                                          i.jaqz097SBO,
                                          i.jaqz097TOP,
                                          pd_fecfin,
                                          ld_Fecpri);
        -- telefono y correo smarquez 17102019
        lc_telefono := null;
        lc_correo := null;
        For t in telefono(ln_pai,ln_tdo,lc_ndo)loop
          if ln_cont = 0 then
            lc_telefono := trim(t.fono);
          else
            lc_telefono := trim(lc_telefono) ||' '||trim(t.fono);
          end if;
           ln_cont := ln_cont + 1;
        end loop;

         For c in correo(ln_pai,ln_tdo,lc_ndo)loop
          if ln_cont1 = 0 then
            lc_correo := trim(c.mail);
          else
            lc_correo := substr((trim(lc_correo) ||' '|| trim(c.mail)),1,100);
          end if;
           ln_cont1 := ln_cont1 + 1;
        end loop;
        fechalinea := null;
        if i.jaqz097MOD= 116 then

          BEgin
           select (select aofval  from fsd010 where pgcod = 1 and aomod = x.xwfmodulo
                      and aocta = x.xwfcuenta
                      and aooper = x.xwfoperacion
                      and aosbop = x.xwfsubope
                      and aotope = x.xwftipope )
             into fechalinea
             from xwf700 x, fsr011 y
            where y.r1cod = 1
              and y.r1mod = 116
              and y.r1cta = i.jaqz097cta
              and y.r1oper = i.jaqz097ope
              and y.relcod = 46
              and x.xwfempresa = 1
              and x.xwfsucursal = y.r2suc
              and x.xwfmodulo = y.r2mod
              and x.xwfcuenta = y.r2cta
              and x.xwfoperacion = y.r2oper
              and x.xwfcar3 = '1';
           exception
             when no_data_found then
               fechalinea:= null;
           end;
        end if;
        Begin
            insert into JAQZ097
              (JAQZ097EMP,
               JAQZ097MOD,
               JAQZ097SUC,
               JAQZ097MDA,
               JAQZ097PAP,
               JAQZ097CTA,
               JAQZ097OPE,
               JAQZ097SBO,
               JAQZ097TOP,
               JAQZ097FEC,
               JAQZ097MAP,
               JAQZ097FEI,
               JAQZ097FEF,
               JAQZ097NUM,
               JAQZ097TAS,
               JAQZ097MPR, /*JAQZ097SCA,*/
               JAQZ097GRU,
               JAQZ097PLA,
               JAQZ097PAI,
               JAQZ097TDO,
               JAQZ097NDO,
               JAQZ097TPE,
               JAQZ097SEX,
               JAQZ097FNA,
               JAQZ097APT,
               JAQZ097APM,
               JAQZ097NOM,
               JAQZ097RZO,
               JAQZ097MPA,
               JAQZ097NUC,
               JAQZ097IMP,
               JAQZ097FVA,
               JAQZ097DGA,
               JAQZ097PER,
               JAQZ097MCA,
               JAQZ097FVE,
               JAQZ097EST,
               JAQZ097FPR,
               JAQZ097TLF,
               JAQZ097MAIL,
               jaqz097aux5 )
            Values
              (i.JAQZ097EMP,
               i.JAQZ097MOD,
               i.JAQZ097SUC,
               i.JAQZ097MDA,
               i.JAQZ097PAP,
               i.JAQZ097CTA,
               i.JAQZ097OPE,
               i.JAQZ097SBO,
               i.JAQZ097TOP,
               pd_fecfin,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               ln_monto_tot,
               lc_numcre, /*I.JAQZ097IMP*/
               ln_mtoFin,
               I.JAQZ097FVA,
               ln_gracia,
               i.jaqz097per,
               ln_mtoCalen,
               ld_Fec,
               I.JAQZ097EST,
               ld_Fecpri,
               lc_telefono,
               lc_correo,
               fechalinea);
        exception
          when dup_val_on_index then
            null;
        end ;
        Begin
            insert into Jaqz097H
              (Jaqz097HEMP,
               Jaqz097HMOD,
               Jaqz097HSUC,
               Jaqz097HMDA,
               Jaqz097HPAP,
               Jaqz097HCTA,
               Jaqz097HOPE,
               Jaqz097HSBO,
               Jaqz097HTOP,
               Jaqz097HFEC,
               Jaqz097HMAP,
               Jaqz097HFEI,
               Jaqz097HFEF,
               Jaqz097HNUM,
               Jaqz097HTAS,
               Jaqz097HMPR, /*Jaqz097HSCA,*/
               Jaqz097HGRU,
               Jaqz097HPLA,
               Jaqz097HPAI,
               Jaqz097HTDO,
               Jaqz097HNDO,
               Jaqz097HTPE,
               Jaqz097HSEX,
               Jaqz097HFNA,
               Jaqz097HAPT,
               Jaqz097HAPM,
               Jaqz097HNOM,
               Jaqz097HRZO,
               Jaqz097HMPA,
               Jaqz097HNUC,
               Jaqz097HIMP,
               Jaqz097HFVA,
               Jaqz097HDGA,
               Jaqz097HPER,
               Jaqz097HMCA,
               Jaqz097HFVE,
               Jaqz097HEST,
               Jaqz097HFPR,
               Jaqz097HTLF,
               Jaqz097HMAIL,
               jaqz097haux5 )
            Values
              (i.JAQZ097EMP,
               i.JAQZ097MOD,
               i.JAQZ097SUC,
               i.JAQZ097MDA,
               i.JAQZ097PAP,
               i.JAQZ097CTA,
               i.JAQZ097OPE,
               i.JAQZ097SBO,
               i.JAQZ097TOP,
               pd_fecfin,
               ln_mtoapr,
               ld_fecvini,
               ld_fecvfin,
               ln_numpol,
               ln_tasa,
               ln_monto, /*ln_salcap,*/
               ln_grupo,
               lc_plan,
               ln_pai,
               ln_tdo,
               lc_ndo,
               lc_petipo,
               lc_sexo,
               ld_fecnac,
               lc_apepat,
               lc_apemat,
               lc_nombre,
               lc_razsoc,
               ln_monto_tot,
               lc_numcre, /*I.JAQZ097IMP*/
               ln_mtoFin,
               I.JAQZ097FVA,
               ln_gracia,
               i.jaqz097per,
               ln_mtoCalen,
               ld_Fec,
               I.JAQZ097EST,
               ld_Fecpri,
               lc_telefono,
               lc_correo,
               fechalinea);
        exception
          when dup_val_on_index then
            null;
        end ;
      end loop;
    end;
  end Sp_Carga_Desem_I;
  ---fin de procesos optimizados

end PQ_CR_TRAMDESGRA;
 /* GOLDENGATE_DDL_REPLICATION */
/

