create or replace package pq_cr_reporte_utilitarios is
  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_utilitarios
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 30/11/2021
  -- Autor de Creación            : rmontesr
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete con funciones para reportes de fondos
  -- Fecha de Modificación        : 14/11/2023
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : optimizacion de funciones  
  --                              : 2024/07/11 dcastro se agrego funcion fn_get_cuota_pagoT
  --                              : 2024/08/15 dcastro se agrego funcion fn_get_distribuc_pago_imp, fn_get_mprepago_imp, fn_get_cuota_pago_imp, fn_get_dias_atraso_imp
  --                              : 2024/09/03 dcastro se agrego consulta sucursal en fn_get_cuota_pago_IMP,fn_get_cuota_pago_imp
  --                              : 2024/09/13 dcastro se modificó función fn_get_fcamb_estado, fn_get_cuota_pagoT,fn_get_cuota_pago_IMP
  --                              : 2024/09/20 dcastro se agrego condicion fn_get_saldo_insoluto_imp
  --                              : 2024.10.03 dcastro se modifico para saldos honrados de capital fn_get_saldo_insoluto_imp, fn_get_mprepago_IMP, fn_get_mprepago_acum_IMP
  --                              : 2024.10.14 dcastro se descomento cambio 2024.10.03  para saldos honrados de capital fn_get_saldo_insoluto_imp, fn_get_mprepago_IMP, fn_get_mprepago_acum_IMP
  --                              : 2025.06.11 calarconap se corrige calculo de saldo insoluto fn_get_saldo_insoluto y fn_get_saldo_insoluto_imp (se ajusta Where en calculo de capital )
  --                              : 2025.06.24 dcastro se modificó fn_get_saldo_insoluto_imp
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Funcion obtener saldo actual
  function fn_get_saldo_actual(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_saldo_actual;
  ----------------------------------------------------------------
  -- Funcion obtener monto desembolsado
  function fn_get_monto_desembolsado(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_saldo_actual;
  ----------------------------------------------------------------
  -- Funcion obtener saldo honrado
  function fn_get_saldo_honrado(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_rubr  in number,
                                pd_fecha in date)
    return type_table_saldo_honrado;
  -----------------------------------------------------------------
  -- Funcion obtener saldo insoluto
  function fn_get_saldo_insoluto(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date,
                                 pn_indi  in number,
                                 pn_stat  in number)
    return type_table_saldo_insoluto;
   -----------------------------------------------------------------
  -- Funcion obtener saldo insoluto impulso
  function fn_get_saldo_insoluto_imp(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date,
                                 pn_indi  in number,
                                 pn_stat  in number,
                                 pd_fe99  in date)
    return type_table_saldo_insoluto;
  ------------------------------------------------------------------
  -- Funcion obtener monto prepago
  function fn_get_mprepago(pn_cod   in number,
                           pn_mod   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_top   in number,
                           pd_fecha in date) return type_table_monto_prepago;
  ------------------------------------------------------------------
  -- Funcion obtener monto prepago acumulado
  function fn_get_mprepago_acum(pn_cod   in number,
                                pn_mod   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_top   in number,
                                pd_fecha in date)
    return type_table_monto_prepago;
  ------------------------------------------------------------------
  -- Funcion obtener fechas pago
  function fn_get_fechas_pago(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pd_fecha in date) return type_table_fecha_pago;
  ----------------------------------------------------------------------
  -- Funcion obtener cuota pago
  function fn_get_cuota_pago(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) return type_table_cuota_pago;
  ----------------------------------------------------------------------
  -- Funcion obtener cuota impaga
  function fn_get_fvcuo_impaga(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_fvcuo_impaga;
  ----------------------------------------------------------------------
  -- Funcion obtener dias atraso
  function fn_get_dias_atraso(v_Pgfape in date, --fecha de proceso
                              v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecven in date) return type_table_dias_atraso;
  ----------------------------------------------------------------------
  -- Funcion obtener calif sbs
  function fn_get_calif_sbs(pn_tdoc in number,
                            pc_ndoc in char,
                            pd_fech in date) return type_table_calif_sbs;
  ----------------------------------------------------------------------
  -- Funcion obtener actividad economica
  function fn_get_acti_eco(P_PAIS   in number,
                           P_PETDOC in number,
                           P_PENDOC in char) return type_table_acti_eco;
  ----------------------------------------------------------------------
  -- Funcion obtener credito sbs vigente
  function fn_get_tipo_credito_sbs_vig(pn_cod   in number,
                                       pn_mod   in number,
                                       pn_suc   in number,
                                       pn_mda   in number,
                                       pn_pap   in number,
                                       pn_cta   in number,
                                       pn_ope   in number,
                                       pn_sbo   in number,
                                       pn_top   in number,
                                       pd_fecha in date)
    return type_table_tcred_sbs;
   ----------------------------------------------------------------------
  -- Funcion obtener rubro
  function fn_get_rubro(pn_cod   in number,
                                       pn_mod   in number,
                                       pn_suc   in number,
                                       pn_mda   in number,
                                       pn_pap   in number,
                                       pn_cta   in number,
                                       pn_ope   in number,
                                       pn_sbo   in number,
                                       pn_top   in number,
                                       pd_fecha in date)
    return type_table_tcred_sbs; 
   
  ------------------------------------------------------------------------
  -- Funcion obtener dsitribucion pago
  function fn_get_distribuc_pago(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago;
  ------------------------------------------------------------------------
  -- Funcion obtener pagos acumulados
  function fn_get_distribuc_pago_acum(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago;

  ------------------------------------------------------------------------
  -- Funcion obtener calificacion caja
  function fn_get_calf_caja(pn_cta in number, pd_fecha in date)
    return type_table_calif_caja;

  ----------------------------------------------------------------
  -- Funcion obtener datos reprogramacion
  function fn_get_repro_dato1(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pd_fecha in date) return type_table_repro_datos;
  -----------------------------------------------------------------
  -- Funcion obtener analista
  function fn_get_analista_credito(v_Scmod  in number,
                                   v_Scsuc  in number,
                                   v_Scmda  in number,
                                   v_Scpap  in number,
                                   v_Sccta  in number,
                                   v_Scoper in number,
                                   v_Scsbop in number,
                                   v_Sctope in number)
    return type_table_analista;
  ----------------------------------------------------------------
  -- Funcion obtener cambio estado
  function fn_get_fcamb_estado(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date) return type_table_tfcest;
  ----------------------------------------------------------------
  -- Funcion obtener tea
  function fn_get_tea_repro(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_tea_rep;
  ----------------------------------------------------------------
  -- Funcion obtener saldos
  function fn_get_saldos(pn_cod   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecha in date) return type_table_saldos;
  ----------------------------------------------------------------
  -- Funcion obtener periodo gracia
  function fn_get_pergracia(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_per_gr;
  ----------------------------------------------------------------
  -- Funcion obtener periodo gracia impulso
  function fn_get_pergracia_imp(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_per_gr;
  ----------------------------------------------------------------
  -- Funcion obtener otros
  function fn_get_otros_repfondos(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pd_fecha in date,
                                  pn_indi  in number)
    return type_table_otros_repfondos;
  ----------------------------------------------------------------
  -- Funcion obtener fechas origen
  function fn_get_fec_creorigen(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number)
    return type_table_fec_crorigen;
  ----------------------------------------------------------------
  -- Funcion obtener fechas origen
  function fn_get_fec_creorigen2(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number)
    return type_table_fec_crorigen;
  -----------------------------------------------------------------                       
 --------------------------------------------------------------------
  function fn_get_cuota_pagoT(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) 
  return type_table_cuota_pago;

 -----------------------------------------------------------------                       
 --------------------------------------------------------------------
function fn_get_calif_sbs_IMP(pn_tdoc in number,
                            pc_ndoc in char,
                            pd_fech in date) 
  return type_table_calif_sbs; 

 ------------------------------------------------------------------------
  function fn_get_distribuc_pago_IMP(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago;
    
------------------------------------------------------------------------
function fn_get_mprepago_IMP(pn_cod   in number,
                           pn_mod   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_top   in number,
                           pd_fecha in date) 
return type_table_monto_prepago;

--------------------------------------------------------------------------
function fn_get_cuota_pago_IMP(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) 
return type_table_cuota_pago;
--------------------------------------------------------  
 function fn_get_dias_atraso_IMP(v_Pgfape in date, --fecha de proceso
                              v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecven in date) 
return type_table_dias_atraso;                           
--------------------------------------------------------  

  function fn_get_otros_repfondos_IMP(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pd_fecha in date,
                                  pn_indi  in number)
return type_table_otros_repfondos;                               

  -------------------------------------------------------------------------
  function fn_get_mprepago_acum_IMP(pn_cod   in number,
                                pn_mod   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_top   in number,
                                pd_fecha in date)
    return type_table_monto_prepago;
-------------------------------------------------------------------------                                                                    
end pq_cr_reporte_utilitarios;
/
create or replace package body pq_cr_reporte_utilitarios is
  -------------------------------------------------------------------------
  function fn_get_saldo_actual(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_saldo_actual is
    t_resp   type_table_saldo_actual;
    ln_saldo number(17, 2);
    ld_fecha date;
  
  begin
    ln_saldo := 0;
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
  
    if ld_fecha <> pd_fecha then
    
      begin
      
        select /*+index(t FSH01204)*/(t.bcsdmn * -1)--08.11.2023
          into ln_saldo
          from fsh012 t
         where t.bcemp = pn_cod
           --and t.bcsuc = pn_suc
           and t.bcmda = pn_mda
           and t.bcpap = pn_pap
           and t.bccta = pn_cta
           and t.bcoper = pn_ope
           and t.bctop = pn_top
           and t.bcmod = pn_mod
              --and t.bcsbop = pn_sbo           
           and t.bcfech = pd_fecha;
      
      exception
        when others then
          ln_saldo := 0;
      end;
    
    else
      begin
      
        select sum(t.scsdo) * -1
          into ln_saldo
          from fsd011 t
         where t.pgcod = pn_cod
           and t.scmod = pn_mod
           and t.scsuc = pn_suc
           and t.scmda = pn_mda
           and t.scpap = pn_pap
           and t.sccta = pn_cta
           and t.scoper = pn_ope
           and t.scsbop = pn_sbo
           and t.sctope = pn_top;
      exception
        when others then
          ln_saldo := 0;
      end;
    
    end if;
  
    if ln_saldo < 0 or ln_saldo is null then
      ln_saldo := 0;
    end if;
    begin
      select type_saldo_actual(ln_saldo)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_monto_desembolsado(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_saldo_actual is
    t_resp   type_table_saldo_actual;
    ln_monto number(17, 2);
    ld_fecha date;
  
  begin
    ln_monto := 0;
    --select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    
    
      begin
      
        select t.aoimp
          into ln_monto
          from fsd010 t
         where t.pgcod = pn_cod
           --and t.bcsuc = pn_suc 
           and t.aosuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and t.aomda = pn_mda
           and t.aopap = pn_pap
           and t.aocta = pn_cta
           and t.aooper = pn_ope
           
           and t.aosbop = 0           
           and rownum = 1;
      
      exception
        when others then
          ln_monto := 0;
      end;
    
    
  
    
    begin
      select type_saldo_actual(ln_monto)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_saldo_honrado(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_rubr  in number,
                                pd_fecha in date)
    return type_table_saldo_honrado is
    t_resp   type_table_saldo_honrado;
    ln_saldo number(17, 2);
    ld_fecha date;
  
  begin
    ln_saldo := 0;
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
  
    if ld_fecha <> pd_fecha then
      begin
        select /*+index(F FSH01204)*/sum(f.BCSDMN)
          into ln_saldo
          from fsh012 f
         where f.BCEMP = pn_cod
           and f.BCRUBR in (select /*+index(FSI006 SYS_C0080890)*/ rubro from fsi006 where cicpo = 'MHONRAM')
           and f.BCCTA = pn_cta
           and f.BCOPER = pn_ope
           and f.BCFECH = pd_fecha;
      exception
        when others then
         ln_saldo := 0;
      end;
    else
      begin
        select sum(a2.SCSDO)
          into ln_saldo
          from fsd011 a2
         where a2.pgcod = pn_cod
           and a2.sccta = pn_cta
           and a2.scoper = pn_ope
           and a2.scrub in (select rubro from fsi006 where cicpo = 'MHONRAM');
      exception
        when others then
          ln_saldo := 0;
      end;
    end if;
  
    if ln_saldo < 0 or ln_saldo is null then
      ln_saldo := 0;
    end if;
    begin
      select type_saldo_honrado(ln_saldo)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_saldo_insoluto(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date,
                                 pn_indi  in number,
                                 pn_stat  in number)
    return type_table_saldo_insoluto is
    t_resp      type_table_saldo_insoluto;
    ln_saldo    number(17, 2);
    ln_mcof     number(10, 2);
    ln_scap     number(17, 2);
    ld_fdes     date;
    ln_mext     number(17, 2);
    ld_fdia     date;
    lc_canc     char(1);
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);
  
  begin
    ln_saldo := 0;
    ln_mcof  := 0;
    ln_scap  := 0;
    ln_mext  := 0;
    -- Verificación de estado del crédito
    --if pn_stat = 99 then
    --  ln_saldo := 0;
    --else
      select x.pgfape into ld_fdia from fst017 x where x.pgcod = 1;
    
      --validar estado de credito y trx para determinar si es 30/360
      lc_canc := 'N';
    
      begin
      
        select /*+index(T SYS_C00978743)*/'S'
          into lc_canc
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
              --and t.ppsuc = pn_suc 
           and t.ppsuc in (select p.sucurs
                             from fst001 p
                            where p.pgcod = 1
                              and p.sucurs < 800)
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
              -- and t.ppsbop = pn_sbo
              -- and t.pptope = pn_top
           and t.pp1stat in ('P', 'T')
           and t.pp1cap > 0
           and (t.d602mo, t.d602tr) in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 4 --flag determina si trx se pertenece a cancelacion
                   and x.tp1corr3 > 0)
           and t.d602fc >= ld_fdia
           and t.d602fc <= pd_fecha
           and t.d602co = 'S';
      
      exception
        when others then
          lc_canc := 'N';
      end;
    
      if lc_canc = 'S' then
        ln_saldo := 0;
      
      else
        -- a) monto COFIDE
        case
          when pn_indi = 1 then
            -- FAE_TURISMO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpb762bmnco, x.aqpb762bfdes
                into ln_mcof, ld_fdes
                from aqpb762b x
               where x.aqpb762bcod = pn_cod
                 and x.aqpb762bccta = pn_cta
                 and x.aqpb762boper = pn_ope
                    
                 and x.aqpb762bfec <= pd_fecha
                 and x.aqpb762best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpb762bmnco, f.aqpb762bfdes
                    into ln_mcof, ld_fdes
                    from (select x.aqpb762bmnco, x.aqpb762bfdes
                            from aqpb762b x
                           where x.aqpb762bcod = pn_cod
                             and x.aqpb762bccta = pn_cta
                             and x.aqpb762boper = pn_ope
                                
                             and x.aqpb762bfec <= pd_fecha
                             and x.aqpb762best <> 'D'
                           order by x.aqpb762bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 2 then
            -- PAE MYPE
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpb394bmoncof, x.aqpb394bfinc
                into ln_mcof, ld_fdes
                from aqpb394b x
               where x.aqpb394bcod = pn_cod
                 and x.aqpb394bcta = pn_cta
                 and x.aqpb394bope = pn_ope
                    
                 and x.aqpb394bfec <= pd_fecha
                 and x.aqpb394best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpb394bmoncof, f.aqpb394bfinc
                    into ln_mcof, ld_fdes
                    from (select x.aqpb394bmoncof, x.aqpb394bfinc
                            from aqpb394b x
                           where x.aqpb394bcod = pn_cod
                             and x.aqpb394bcta = pn_cta
                             and x.aqpb394bope = pn_ope
                                
                             and x.aqpb394bfec <= pd_fecha
                             and x.aqpb394best <> 'D'
                           order by x.aqpb394bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 3 then
            -- Reactiva repro
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc351bmoncof, x.aqpc351bfinire
                into ln_mcof, ld_fdes
                from aqpc351b x
               where x.aqpc351bcod = pn_cod
                 and x.aqpc351bcta = pn_cta
                 and x.aqpc351bope = pn_ope
                    
                    --and x.aqpc351bfec <= pd_fecha
                 and x.aqpc351best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc351bmoncof, f.aqpc351bfinire
                    into ln_mcof, ld_fdes
                    from (select x.aqpc351bmoncof, x.aqpc351bfinire
                            from aqpc351b x
                           where x.aqpc351bcod = pn_cod
                             and x.aqpc351bcta = pn_cta
                             and x.aqpc351bope = pn_ope
                                
                             and x.aqpc351bfec <= pd_fecha
                             and x.aqpc351best <> 'D'
                           order by x.aqpc351bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 4 then
            -- FAE TEXCO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc360bmoncof, x.aqpc360bfinc
                into ln_mcof, ld_fdes
                from aqpc360b x
               where x.aqpc360bcod = pn_cod
                 and x.aqpc360bcta = pn_cta
                 and x.aqpc360bope = pn_ope
                    
                    --and x.aqpc351bfec <= pd_fecha
                 and x.aqpc360best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc360bmoncof, f.aqpc360bfinC
                    into ln_mcof, ld_fdes
                    from (select x.aqpc360bmoncof, x.aqpc360bfinC
                            from aqpc360b x
                           where x.aqpc360bcod = pn_cod
                             and x.aqpc360bcta = pn_cta
                             and x.aqpc360bope = pn_ope
                                
                             and x.aqpc360bfec <= pd_fecha
                             and x.aqpc360best <> 'D'
                           order by x.aqpc360bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
            when pn_indi = 5 then
            -- IMPULSO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc366bmoncof, x.aqpc366bfdes
                into ln_mcof, ld_fdes
                from aqpc366b x
               where x.aqpc366bcod = pn_cod
                 and x.aqpc366bcta = pn_cta
                 and x.aqpc366bope = pn_ope
                    
                    --and x.aqpc366bfec <= pd_fecha
                 and x.aqpc366best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc366bmoncof, f.aqpc366bfdes
                    into ln_mcof, ld_fdes
                    from (select x.aqpc366bmoncof, x.aqpc366bfdes
                            from aqpc366b x
                           where x.aqpc366bcod = pn_cod
                             and x.aqpc366bcta = pn_cta
                             and x.aqpc366bope = pn_ope
                                
                             and x.aqpc366bfec <= pd_fecha
                             and x.aqpc366best <> 'D'
                           order by x.aqpc366bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
        end case;
      
        --- b) Sumatoria de pagos
        --- Capital
        if ln_mcof <> 0 and pd_fecha >= ld_fdes then
          begin
          
            select /*+index(t SYS_C00978743)*/nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
              into ln_scap
            
              from fsd602 t
             where t.pgcod = pn_cod
                 and t.ppmod in ( select MODULO from fst111 a where a.dscod = 50 )
               --and t.ppmod = pn_mod
                  --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
               and t.ppsuc in (select p.sucurs
                                 from fst001 p
                                where p.pgcod = 1
                                  and p.sucurs < 800)
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
                  -- and t.ppsbop = pn_sbo
                  -- and t.pptope = pn_top
               and t.pp1stat in ('P', 'T')
               and t.pp1cap > 0
               and (t.d602mo, t.d602tr) in
                   (select x.tp1nro1, x.tp1nro2
                      from fst198 x
                     where x.TP1COD = 1
                       and x.TP1COD1 = 11144
                       and x.TP1CORR1 = 1
                       and x.tp1corr2 = 3
                       and x.tp1corr3 > 0)
               and t.d602fc >= ld_fdes
               and t.d602fc <= pd_fecha
               and t.d602co = 'S';
          
          exception
            when others then
              ln_scap := 0;
          end;
        
          if ld_fdia <> pd_fecha then
          
            begin
              select nvl(x.HCIMP1, 0) --,  x.* 
                into ln_mext
                from fsh016 x, fsh015 t
               where x.PGCOD = t.pgcod
                 and x.HCMOD = t.hcmod
                 and x.HSUCOR = t.hsucor
                 and x.HTRAN = t.htran
                 and x.HNREL = t.hnrel
                 and x.HFCON = t.hfcon
                 and x.PGCOD = pn_cod
                 and x.HMODUL = pn_mod
                 and x.HSUCUR = pn_suc
                 and x.HMDA = pn_mda
                 and x.HPAP = pn_pap
                 and x.HCTA = pn_cta
                 and x.HOPER = pn_ope
                 and x.HSUBOP = pn_sbo
                 and x.HTOPER = pn_top
                 and --- HRUBRO: 1411, 1421, 1414, 1424, 1415,1425,1416, 1426
                     substr(x.HRUBRO, 1, 4) in
                     (1411, 1421, 1414, 1424, 1415, 1425, 1416, 1426)
                 and x.HFCON > pd_fecha
                 and x.HFVAL <= pd_fecha
                 and (x.HCMOD, x.HTRAN) in
                     (select f.tp1nro1 + 500, f.tp1nro2 --obtener trx extornos
                        from fst198 f
                       where f.TP1COD = 1
                         and f.TP1COD1 = 11144
                         and f.TP1CORR1 = 1
                         and f.tp1corr2 = 3
                         and f.tp1corr3 > 0);
            exception
              when others then
                ln_mext := 0;
            end;
          
          else
            ln_mext := 0;
          end if;
        
          ln_scap := ln_scap + ln_mext;
        
        else
          ln_scap := 0;
        end if;
      
        if ln_mcof is null then
          ln_mcof := 0;
        end if;
        -- pagos honrados
        begin
          select nvl(sum(x.HCIMP1), 0)
            into lx_shon
            from fsh016 x, fsh015 t
           where x.PGCOD = t.pgcod
             and x.HCMOD = t.hcmod
             and x.HSUCOR = t.hsucor
             and x.HTRAN = t.htran
             and x.HNREL = t.hnrel
             and x.HFCON = t.hfcon
             and x.PGCOD = pn_cod
                --and x.HMODUL = 
                --and x.HSUCUR = 
             and x.HMDA = pn_mda
             and x.HPAP = pn_pap
             and x.HCTA = pn_cta
             and x.HOPER = pn_ope
                --and x.HSUBOP = 
                --and x.HTOPER = 
                
                --and x.HFCON >= lc_fini
             and x.HFCON <= pd_fecha
             and x.HFVAL <= pd_fecha
             and (x.HCMOD, x.HTRAN, x.hcord) in
                 (select tp1nro1, tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 11164
                     and tp1corr1 = 4
                     and tp1corr2 = 1
                     and tp1corr3 > 0);
        exception
          when others then
            lx_shon := 0;
        end;
      
        -- extornos honrados
        begin
          select nvl(sum(x.HCIMP1), 0)
            into lx_shon_ext
            from fsh016 x, fsh015 t
           where x.PGCOD = t.pgcod
             and x.HCMOD = t.hcmod
             and x.HSUCOR = t.hsucor
             and x.HTRAN = t.htran
             and x.HNREL = t.hnrel
             and x.HFCON = t.hfcon
             and x.PGCOD = pn_cod
                --and x.HMODUL = 
                --and x.HSUCUR = 
             and x.HMDA = pn_mda
             and x.HPAP = pn_pap
             and x.HCTA = pn_cta
             and x.HOPER = pn_ope
                --and x.HSUBOP = 
                --and x.HTOPER = 
                
                --and x.HFCON >= lc_fini
             and x.HFCON <= pd_fecha
             and x.HFVAL <= pd_fecha
             and (x.HCMOD, x.HTRAN, x.hcord) in
                 (select tp1nro1, tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 11164
                     and tp1corr1 = 4
                     and tp1corr2 = 2
                     and tp1corr3 > 0);
        exception
          when others then
            lx_shon_ext := 0;
        end;
        --- c) Resultado
        ln_saldo := ln_mcof - (ln_scap + lx_shon - lx_shon_ext);
      
        if ln_saldo < 0 then
          ln_saldo := 0;
        end if;
      end if; -- fin lc_canc       
    
    --end if;
    begin
      select type_saldo_inso(ln_saldo) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_saldo_insoluto_imp(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date,
                                 pn_indi  in number,
                                 pn_stat  in number,
                                 pd_fe99  in date)
    -- 2024.09.20 dcastro se agrego condicion para estado cancelado    
    -- 2024.10.04 dcastro Se agregó guia 10876 para obtener ordinales de capital en trxs honrados
    -- 2025.06.24 dcastro dcastro se comentó de acuerdo a lo indicado por negocio, si es cancelado saldo insoluto = 0
                             
    return type_table_saldo_insoluto is
    t_resp      type_table_saldo_insoluto;
    ln_saldo    number(17, 2);
    ln_mcof     number(10, 2);
    ln_scap     number(17, 2);
    ld_fdes     date;
    ln_mext     number(17, 2);
    ld_fdia     date;
    lc_canc     char(1);
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);
    ld_fe99     date;
  
  begin
    ln_saldo := 0;
    ln_mcof  := 0;
    ln_scap  := 0;
    ln_mext  := 0;
    if pd_fe99 is null then
      ld_fe99 := '01/01/0001';
    else
      ld_fe99 := pd_fe99;
    end if;

      select x.pgfape into ld_fdia from fst017 x where x.pgcod = 1;
    
      --validar estado de credito y trx para determinar si es 30/360
      lc_canc := 'N';
    
      begin
      
        select 'S'
          into lc_canc
          from AQPC366D/*fsd602*/ t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
              --and t.ppsuc = pn_suc 
           and t.ppsuc in (select p.sucurs
                             from fst001 p
                            where p.pgcod = 1
                              and p.sucurs < 800)
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
              -- and t.ppsbop = pn_sbo
              -- and t.pptope = pn_top
           and t.pp1stat in ('P', 'T')
           and t.pp1cap > 0
           and (t.d602mo, t.d602tr) in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 4 --flag determina si trx se pertenece a cancelacion
                   and x.tp1corr3 > 0)
           and t.d602fc >= ld_fdia
           and t.d602fc <= pd_fecha
           and t.d602co = 'S';
      
      exception
        when others then
          lc_canc := 'N';
      end;
    
      if lc_canc = 'S' then
        ln_saldo := 0;
      
      else
        -- a) monto COFIDE
        case
          when pn_indi = 1 then
            -- FAE_TURISMO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpb762bmnco, x.aqpb762bfdes
                into ln_mcof, ld_fdes
                from aqpb762b x
               where x.aqpb762bcod = pn_cod
                 and x.aqpb762bccta = pn_cta
                 and x.aqpb762boper = pn_ope
                    
                 and x.aqpb762bfec <= pd_fecha
                 and x.aqpb762best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpb762bmnco, f.aqpb762bfdes
                    into ln_mcof, ld_fdes
                    from (select x.aqpb762bmnco, x.aqpb762bfdes
                            from aqpb762b x
                           where x.aqpb762bcod = pn_cod
                             and x.aqpb762bccta = pn_cta
                             and x.aqpb762boper = pn_ope
                                
                             and x.aqpb762bfec <= pd_fecha
                             and x.aqpb762best <> 'D'
                           order by x.aqpb762bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 2 then
            -- PAE MYPE
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpb394bmoncof, x.aqpb394bfinc
                into ln_mcof, ld_fdes
                from aqpb394b x
               where x.aqpb394bcod = pn_cod
                 and x.aqpb394bcta = pn_cta
                 and x.aqpb394bope = pn_ope
                    
                 and x.aqpb394bfec <= pd_fecha
                 and x.aqpb394best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpb394bmoncof, f.aqpb394bfinc
                    into ln_mcof, ld_fdes
                    from (select x.aqpb394bmoncof, x.aqpb394bfinc
                            from aqpb394b x
                           where x.aqpb394bcod = pn_cod
                             and x.aqpb394bcta = pn_cta
                             and x.aqpb394bope = pn_ope
                                
                             and x.aqpb394bfec <= pd_fecha
                             and x.aqpb394best <> 'D'
                           order by x.aqpb394bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 3 then
            -- Reactiva repro
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc351bmoncof, x.aqpc351bfinire
                into ln_mcof, ld_fdes
                from aqpc351b x
               where x.aqpc351bcod = pn_cod
                 and x.aqpc351bcta = pn_cta
                 and x.aqpc351bope = pn_ope
                    
                    --and x.aqpc351bfec <= pd_fecha
                 and x.aqpc351best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc351bmoncof, f.aqpc351bfinire
                    into ln_mcof, ld_fdes
                    from (select x.aqpc351bmoncof, x.aqpc351bfinire
                            from aqpc351b x
                           where x.aqpc351bcod = pn_cod
                             and x.aqpc351bcta = pn_cta
                             and x.aqpc351bope = pn_ope
                                
                             and x.aqpc351bfec <= pd_fecha
                             and x.aqpc351best <> 'D'
                           order by x.aqpc351bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
          
          when pn_indi = 4 then
            -- FAE TEXCO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc360bmoncof, x.aqpc360bfinc
                into ln_mcof, ld_fdes
                from aqpc360b x
               where x.aqpc360bcod = pn_cod
                 and x.aqpc360bcta = pn_cta
                 and x.aqpc360bope = pn_ope
                    
                    --and x.aqpc351bfec <= pd_fecha
                 and x.aqpc360best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc360bmoncof, f.aqpc360bfinC
                    into ln_mcof, ld_fdes
                    from (select x.aqpc360bmoncof, x.aqpc360bfinC
                            from aqpc360b x
                           where x.aqpc360bcod = pn_cod
                             and x.aqpc360bcta = pn_cta
                             and x.aqpc360bope = pn_ope
                                
                             and x.aqpc360bfec <= pd_fecha
                             and x.aqpc360best <> 'D'
                           order by x.aqpc360bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
            when pn_indi = 5 then
            -- IMPULSO
            ln_mcof := 0;
            ld_fdes := null;
          
            begin
            
              select x.aqpc366bmoncof, x.aqpc366bfdes
                into ln_mcof, ld_fdes
                from aqpc366b x
               where x.aqpc366bcod = pn_cod
                 and x.aqpc366bcta = pn_cta
                 and x.aqpc366bope = pn_ope
                    
                    --and x.aqpc366bfec <= pd_fecha
                 and x.aqpc366best <> 'D';
            
            exception
              when too_many_rows then
              
                begin
                
                  select f.aqpc366bmoncof, f.aqpc366bfdes
                    into ln_mcof, ld_fdes
                    from (select x.aqpc366bmoncof, x.aqpc366bfdes
                            from aqpc366b x
                           where x.aqpc366bcod = pn_cod
                             and x.aqpc366bcta = pn_cta
                             and x.aqpc366bope = pn_ope
                                
                             and x.aqpc366bfec <= pd_fecha
                             and x.aqpc366best <> 'D'
                           order by x.aqpc366bfec desc) f
                   where rownum = 1;
                
                exception
                  when others then
                  
                    ln_mcof := 0;
                    ld_fdes := null;
                  
                end;
              
              when others then
              
                ln_mcof := 0;
                ld_fdes := null;
              
            end;
        end case;
      
        --- b) Sumatoria de pagos
        --- Capital
        if ln_mcof <> 0 and pd_fecha >= ld_fdes then
          begin
          
            select /*+index(t SYS_C00978743)*/ nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
              into ln_scap
            
              from AQPC366D/*fsd602*/ t
             where t.pgcod = pn_cod
             --and t.ppmod = pn_mod --(calarconaap: 11/06/2025 )
                  and t.ppmod in (select MODULO from fst111 a where a.dscod = 50) 
                  --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
               and t.ppsuc in (select p.sucurs
                                 from fst001 p
                                where p.pgcod = 1
                                  and p.sucurs < 800)
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
                  -- and t.ppsbop = pn_sbo
                  -- and t.pptope = pn_top
               and t.pp1stat in ('P', 'T')
               and t.pp1cap > 0
               and (t.d602mo, t.d602tr) in
                   (select x.tp1nro1, x.tp1nro2
                      from fst198 x
                     where x.TP1COD = 1
                       and x.TP1COD1 = 11144
                       and x.TP1CORR1 = 1
                       and x.tp1corr2 = 3
                       and x.tp1corr3 > 0
                    )
               and t.d602fc >= ld_fdes
               and t.d602fc <= pd_fecha
               and t.d602co = 'S';
          
          exception
            when others then
              ln_scap := 0;
          end;
        
          if ld_fdia <> pd_fecha then
          
            begin
              select nvl(x.HCIMP1, 0) --,  x.* 
                into ln_mext
                from fsh016 x, fsh015 t
               where x.PGCOD = t.pgcod
                 and x.HCMOD = t.hcmod
                 and x.HSUCOR = t.hsucor
                 and x.HTRAN = t.htran
                 and x.HNREL = t.hnrel
                 and x.HFCON = t.hfcon
                 and x.PGCOD = pn_cod
                 and x.HMODUL = pn_mod
                 and x.HSUCUR = pn_suc
                 and x.HMDA = pn_mda
                 and x.HPAP = pn_pap
                 and x.HCTA = pn_cta
                 and x.HOPER = pn_ope
                 and x.HSUBOP = pn_sbo
                 and x.HTOPER = pn_top
                 and --- HRUBRO: 1411, 1421, 1414, 1424, 1415,1425,1416, 1426
                     substr(x.HRUBRO, 1, 4) in
                     (1411, 1421, 1414, 1424, 1415, 1425, 1416, 1426)
                 and x.HFCON > pd_fecha
                 and x.HFVAL <= pd_fecha
                 and (x.HCMOD, x.HTRAN) in
                     (select f.tp1nro1 + 500, f.tp1nro2 --obtener trx extornos
                        from fst198 f
                       where f.TP1COD = 1
                         and f.TP1COD1 = 11144
                         and f.TP1CORR1 = 1
                         and f.tp1corr2 = 3
                         and f.tp1corr3 > 0);
            exception
              when others then
                ln_mext := 0;
            end;
          
          else
            ln_mext := 0;
          end if;
        
          ln_scap := ln_scap + ln_mext;
        
        else
          ln_scap := 0;
        end if;
      
        if ln_mcof is null then
          ln_mcof := 0;
        end if;
        -- pagos honrados
        begin
          select nvl(sum(x.HCIMP1), 0)
            into lx_shon
            from fsh016 x, fsh015 t
           where x.PGCOD = t.pgcod
             and x.HCMOD = t.hcmod
             and x.HSUCOR = t.hsucor
             and x.HTRAN = t.htran
             and x.HNREL = t.hnrel
             and x.HFCON = t.hfcon
             and x.PGCOD = pn_cod
                --and x.HMODUL = 
                --and x.HSUCUR = 
             and x.HMDA = pn_mda
             and x.HPAP = pn_pap
             and x.HCTA = pn_cta
             and x.HOPER = pn_ope
                --and x.HSUBOP = 
                --and x.HTOPER = 
                
                --and x.HFCON >= lc_fini
             and x.HFCON <= pd_fecha
             and x.HFVAL <= pd_fecha
             and (x.HCMOD, x.HTRAN, x.hcord) in
                 (select tp1nro1, tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 11164
                     and tp1corr1 = 4
                     and tp1corr2 = 1
                     and tp1corr3 > 0
                  ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
                  union
                     select distinct f.TP1CORR1, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                     where g.tp1cod = f.tp1cod
                     and g.tp1cod1 = 11164
                     and g.tp1corr1 = 4
                     and g.tp1corr2 = 1
                     and g.tp1corr3 > 0
                     and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                     and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
                     ---2024.10.03  dcastro 
                     
                     );
        exception
          when others then
            lx_shon := 0;
        end;
      
        -- extornos honrados
        begin
          select nvl(sum(x.HCIMP1), 0)
            into lx_shon_ext
            from fsh016 x, fsh015 t
           where x.PGCOD = t.pgcod
             and x.HCMOD = t.hcmod
             and x.HSUCOR = t.hsucor
             and x.HTRAN = t.htran
             and x.HNREL = t.hnrel
             and x.HFCON = t.hfcon
             and x.PGCOD = pn_cod
                --and x.HMODUL = 
                --and x.HSUCUR = 
             and x.HMDA = pn_mda
             and x.HPAP = pn_pap
             and x.HCTA = pn_cta
             and x.HOPER = pn_ope
                --and x.HSUBOP = 
                --and x.HTOPER = 
                
                --and x.HFCON >= lc_fini
             and x.HFCON <= pd_fecha
             and x.HFVAL <= pd_fecha
             and (x.HCMOD, x.HTRAN, x.hcord) in
                 (select tp1nro1, tp1nro2, tp1nro3
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 11164
                     and tp1corr1 = 4
                     and tp1corr2 = 2
                     and tp1corr3 > 0
                  ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
                  union
                     select distinct f.TP1CORR1+500, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                     where g.tp1cod = f.tp1cod
                     and g.tp1cod1 = 11164
                     and g.tp1corr1 = 4
                     and g.tp1corr2 = 1
                     and g.tp1corr3 > 0
                     and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                     and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
                    ---2024.10.03  dcastro 
                     );
        exception
          when others then
            lx_shon_ext := 0;
        end;

        --- c) Resultado
        ln_saldo := ln_mcof - (ln_scap + lx_shon - lx_shon_ext);
      
        if ln_saldo < 0 then
          ln_saldo := 0;
        end if;
      end if; -- fin lc_canc       
  
/* 2025.06.24 dcastro se comentó de acuerdo a lo indicado por negocio
     -- Verificación de estado del crédito
    if pn_stat = 99 and ld_fe99 <= pd_fecha and ld_fe99 != '01/01/0001' then
      ln_saldo := 0;
    end if;-- 2024.09.20 dcastro se agrego validacion por estado, si es cancelado saldo insoluto = 0.
*/   
    begin
      select type_saldo_inso(ln_saldo) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ------------------------------------------------------------------
  function fn_get_mprepago(pn_cod   in number,
                           pn_mod   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_top   in number,
                           pd_fecha in date) return type_table_monto_prepago is
    t_resp      type_table_monto_prepago;
    lx_cd       number(3);
    lx_mo       number(3);
    lx_su       number(3);
    lx_tr       number(3);
    lx_re       number(4);
    lx_fc       date;
    lx_fecha    date;
    ln_monto    number(17, 2);
    ln_int      number(17, 2);
    lc_fini     date;
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
    ln_monto := 0;
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
    -- 2. Obtención pago mes
    begin
      select /*+index(T SYS_C00978743)*/ nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
        into ln_monto, ln_int
      
        from fsd602 t
       where t.pgcod = pn_cod
            --and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 3
                 and x.tp1corr3 > 0)
         and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        ln_monto := 0;
        ln_int   := 0;
    end;
  
    -- pagos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
         and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 1
                 and tp1corr3 > 0);
    exception
      when others then
        lx_shon := 0;
    end;
  
    -- extornos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon_ext
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
         and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 2
                 and tp1corr3 > 0);
    exception
      when others then
        lx_shon_ext := 0;
    end;
  
    begin
      select type_monto_prepago(ln_monto + lx_shon - lx_shon_ext)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_mprepago_acum(pn_cod   in number,
                                pn_mod   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_top   in number,
                                pd_fecha in date)
    return type_table_monto_prepago is
    t_resp      type_table_monto_prepago;
    lx_cd       number(3);
    lx_mo       number(3);
    lx_su       number(3);
    lx_tr       number(3);
    lx_re       number(4);
    lx_fc       date;
    lx_fecha    date;
    ln_monto    number(17, 2);
    ln_int      number(17, 2);
    lc_fini     date;
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
    ln_monto := 0;
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
    -- 2. Obtención pago mes
    begin
      select /*+index(T SYS_C00978743)*/nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
        into ln_monto, ln_int
      
        from fsd602 t
       where t.pgcod = pn_cod
            --and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 3
                 and x.tp1corr3 > 0)
            --and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        ln_monto := 0;
        ln_int   := 0;
    end;
  
    -- pagos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
            --and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 1
                 and tp1corr3 > 0);
    exception
      when others then
        lx_shon := 0;
    end;
  
    -- extornos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon_ext
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
            --and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 2
                 and tp1corr3 > 0);
    exception
      when others then
        lx_shon_ext := 0;
    end;
  
    begin
      select type_monto_prepago(ln_monto + lx_shon - lx_shon_ext)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_fechas_pago(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pd_fecha in date) return type_table_fecha_pago is
    t_resp   type_table_fecha_pago;
    ld_fpagu date;
    ld_fpaguc date;
    ld_fvenu date;
    ln_diatr number;
    lx_diff  number;
    lx_fcdo  date;
    lx_fpago date;
  
  begin
    ln_diatr := 0;
    lx_diff  := 0;
    begin
    
      -- Obtener última fecha de pago
      SELECT
      
      --max(t.d602fc)
       max(t.pp1fech)
        into ld_fpagu
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pd_fecha;
    exception
      when others then
        ld_fpagu := null;
    end;
    
    begin
    
      -- Obtener última fecha de pago
      SELECT
      
      --max(t.d602fc)
       max(t.ppfpag)
        into ld_fpaguc
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pd_fecha;
    exception
      when others then
        ld_fpaguc := null;
    end;
  
    if ld_fpagu is null then
      --no se ha hecho ningún pago
      ld_fvenu := null;
      /*
      begin
        select
         f.ppfvto
          into
               lx_fvenu
          from (select t.ppfvto
                  from fsd601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                      --and t.ppfpag = lx_fpago
                   and (t.ppcap + t.ppint) <> 0
                 order by t.ppfpag asc) f
         where rownum = 1;
      exception
        when others then
          lx_fvenu := null;
      end;
      */
    
    else
      --- se realizó un pago
      begin
        select ppfvto
          into ld_fvenu
          from
        (select *
          from fsd601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.ppfpag = ld_fpaguc
           and (t.ppcap + t.ppint) <> 0
         order by t.ppfpag asc)
         where rownum = 1;
      exception
        when others then
          ld_fvenu := null;
      end;
    end if;
    begin
      select t.d602fc
        into lx_fcdo
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.ppfpag = ld_fpagu;
    
      -- Verificar si hay cuotas pendientes de pago
      select x.ppfpag
        into lx_fpago
        from fsd601 x
       where x.pgcod = pn_cod
         and x.ppmod = pn_mod
         and x.ppsuc = pn_suc
         and x.ppmda = pn_mda
         and x.pppap = pn_pap
         and x.ppcta = pn_cta
         and x.ppoper = pn_ope
         and x.ppsbop = pn_sbo
         and x.pptope = pn_top
         and x.ppfpag = ld_fpagu;
    
      lx_diff := lx_fcdo - lx_fpago;
    
      if lx_diff > 0 then
        ln_diatr := lx_diff;
      else
        ln_diatr := 0;
      end if;
    exception
      when others then
        ln_diatr := 0;
    end;
    begin
      select type_fecha_pago(ld_fpagu, ld_fvenu, ln_diatr)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  --------------------------------------------------------------------
  function fn_get_cuota_pago(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) return type_table_cuota_pago is
    t_resp   type_table_cuota_pago;
    ln_cuopp number(10);
    ln_cuopa number(10);
  begin
    ln_cuopp := 0;
    ln_cuopa := 0;
    -- Cuotas pendientes de pago
    if pd_fec is null then
    
      begin
      
        SELECT
        
         count(*)
          into ln_cuopp
          FROM FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.d601co = 'S';
      exception
        when others then
          ln_cuopp := 0;
      end;
      ln_cuopa := 0;
    else
    
      -- Cuotas pendientes de pago
      begin
      
        SELECT
        
         count(*)
          into ln_cuopp
          FROM FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.ppfpag > pd_fec
           and t.d601co = 'S';
      exception
        when others then
          ln_cuopp := 0;
      end;
      ln_cuopa := 0;
      -- Cuotas ya pagadas
      begin
      
        SELECT
        
         count(*)
          into ln_cuopa
          FROM FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.ppfpag <= pd_fec
           and t.d601co = 'S';
      exception
        when others then
          ln_cuopa := 0;
      end;
    
    end if;
    begin
      select type_cuota_pago(ln_cuopp, ln_cuopa)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_fvcuo_impaga(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date)
    return type_table_fvcuo_impaga is
    t_resp    type_table_fvcuo_impaga;
    ld_fmax   date;
    ln_ind1   number;
    ld_fvenuc date;
  begin
  
    begin
    
      ln_ind1 := 1;
    
      select max(t.ppfpag)
        into ld_fmax
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('T', 'S')
         and t.d602fc <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        ln_ind1 := 0;
    end;
  
    if ld_fmax is NULL then
      ln_ind1 := 0;
    else
      ln_ind1 := 1;
    end if;
  
    if ln_ind1 = 1 then
      ----Si se pagó
      begin
        select --nvl(f.ppcap, 0), nvl(f.ppint, 0),
         f.ppfpag
          into ld_fvenuc
          from (select t.ppcap, t.ppint, t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.ppfpag > ld_fmax
                   and (t.ppcap + t.ppint) <> 0
                   and t.ppfvto <= pd_fecha
                   and t.ppfpag > ld_fmax
                 order by t.ppfpag ASC) f
         where rownum = 1;
      
      exception
        when others then
          ld_fvenuc := null;
      end;
    
    else
      --No se pagó nada
      begin
        select --nvl(f.ppcap, 0), nvl(f.ppint, 0),
         f.ppfpag
          into ld_fvenuc
          from (select t.ppcap, t.ppint, t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and (t.ppcap + t.ppint) <> 0
                   and t.ppfvto <= pd_fecha
                 order by t.ppfpag asc) f
         where rownum = 1;
      exception
        when others then
          ld_fvenuc := null;
      end;
    
    end if;
    begin
      select type_fvcuo_impaga(ld_fvenuc)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------------
  function fn_get_dias_atraso(v_Pgfape in date, --fecha de proceso
                              v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecven in date) return type_table_dias_atraso is
    t_resp         type_table_dias_atraso;
    ln_diatr       number;
    ATR_FEB        number;
    ln_cov19       number;
    ln_cant        number;
    LN_DIATR_CNGLD number; --2020.04.07
    lc_cancelado   number;
  begin
    ln_diatr       := 0;
    ATR_FEB        := 0;
    ln_cov19       := 0;
    ln_cant        := 0;
    LN_DIATR_CNGLD := 0;
    If v_Scmod in (200, 33, 141) Then
      --se agrego carta fianza
    
      ln_diatr := v_Pgfape - v_fecven;
    
      If ln_diatr < 0 then
        ln_diatr := 0;
      End if;
    
    Else
      begin
        SELECT (v_Pgfape - min(a.Ppfpag))
          into ln_diatr
          FROM FSD601 a
          left join FSD602 b
            on b.Pgcod = a.Pgcod
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
              ln_diatr := 0;
          End;
      end;
    End IF;
  
    ln_diatr := nvl(ln_diatr, 0);
   
  /* 2024.08.15 DCASTRO se comento calculo dias atraso 
  ---2020.04.04 dcastro  Modificacion por emergencia covid19 
    LN_DIATR_CNGLD := -1;
  
    begin
      select f.tp1nro1
        into ln_cov19
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10872
         and f.tp1corr1 = 100
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception
      when others then
        ln_cov19 := 0;
    end;
  
    if ln_cov19 = 1 then
      --si flag esta habilitado
    
      IF v_Scmod = 33 then
        -- si es castigo
        ATR_FEB := -1;
      ELSE
      
        BEGIN
        
          SELECT NVL(X.AQPB003DATR, -1)
            INTO ATR_FEB
            FROM AQPB003 X
           WHERE X.AQPB003HCTA = v_Sccta
             AND X.AQPB003HOPER = v_Scoper
             AND X.AQPB003FECH = TO_DATE('20200229', 'YYYYMMDD')
             and rownum = 1;
        
        EXCEPTION
          WHEN OTHERS THEN
            ATR_FEB := -1;
        END;
      
        IF (ATR_FEB > 15) THEN
        
          --valida si credito fue reprogramado
          begin
            select count(*)
              into ln_cant
              from aqpb090 a
             where a.aqpb090cta = v_Sccta
               and a.aqpb090oper = v_Scoper
               and a.aqpb090ext = 'NO';
          exception
            when others then
              ln_cant := 0;
          end;
        
          if ln_cant = 0 then
            --no fue reprogramado
            LN_DIATR_CNGLD := ATR_FEB;
          else
            LN_DIATR_CNGLD := -1;
          end if;
        
        ELSE
          LN_DIATR_CNGLD := -1;
        
        END IF;
      
      END IF; --fin castigos
    
    end if;
  
    IF (LN_DIATR_CNGLD < LN_DIATR) and LN_DIATR_CNGLD <> -1 THEN
      LN_DIATR := LN_DIATR_CNGLD;
    END IF;*/
  
    begin
      select type_dias_atraso(ln_diatr) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------------
  function fn_get_calif_sbs(pn_tdoc in number,
                            pc_ndoc in char,
                            pd_fech in date) return type_table_calif_sbs is
    t_resp       type_table_calif_sbs;
    ld_fecha_pro date;
    ld_fecha_rcc date;
    ln_nro_mes   number(3);
    lc_csbs      char(11);
    ln_calif0    number(5, 2);
    ln_calif1    number(5, 2);
    ln_calif2    number(5, 2);
    ln_calif3    number(5, 2);
    ln_calif4    number(5, 2);
  
  begin
  
    --select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into ln_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        ln_nro_mes := 1;
    end;
  
    -- 2. Fecha RCC
    select to_date(t.tpnro, 'DDMMYY')
      into ld_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    if pd_fech <= ld_fecha_rcc then
      ld_fecha_pro := last_day(add_months(trunc(pd_fech), -1 * ln_nro_mes));
    else
      ld_fecha_pro := ld_fecha_rcc;
    end if;
  
    -- Verificar tipo de documento
    if pn_tdoc = 21 then
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into lc_csbs,
               ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4
          from cldrcci t
         where t.d_fecpre = ld_fecha_pro
           and t.c_tdocid = (select tp1nro2
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 11111
                                and tp1corr1 = 1
                                and tp1corr2 = 5
                                and tp1nro1 = pn_tdoc
                                and rownum = 1)
           and t.c_docide = trim(pc_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into lc_csbs,
                   ln_calif0,
                   ln_calif1,
                   ln_calif2,
                   ln_calif3,
                   ln_calif4
              from cldrcci t
             where t.d_fecpre = ld_fecha_pro
               and t.c_tdocid = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
               and t.c_docide = trim(pc_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              lc_csbs   := '0';
              ln_calif0 := 100;
              ln_calif1 := 0;
              ln_calif2 := 0;
              ln_calif3 := 0;
              ln_calif4 := 0;
          end;
        when no_data_found then
          lc_csbs   := '0';
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
          begin
            for i in 1 .. 18 loop
              begin
                select trim(t.c_codsbs)
                  into lc_csbs
                  from cldrcci t
                 where t.d_fecpre = add_months(ld_fecha_pro, -i)
                   and t.c_tdocid = (select tp1nro2
                                       from fst198
                                      where tp1cod = 1
                                        and tp1cod1 = 11111
                                        and tp1corr1 = 1
                                        and tp1corr2 = 5
                                        and tp1nro1 = pn_tdoc
                                        and rownum = 1)
                   and t.c_docide = trim(pc_ndoc)
                   and t.c_person = 1
                   and rownum = 1;
              exception
                when others then
                  lc_csbs := '0';
              end;
              EXIT WHEN lc_csbs <> '0';
            end loop;
          exception
            when others then
              lc_csbs := '0';
          end;
          --exception
        when others then
          lc_csbs   := '0';
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    
    else
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into lc_csbs,
               ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4
          from cldrcci t
         where t.d_fecpre = ld_fecha_pro
           and t.c_tdoctr = (select tp1nro2
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 11111
                                and tp1corr1 = 1
                                and tp1corr2 = 5
                                and tp1nro1 = pn_tdoc
                                and rownum = 1)
           and t.c_doctri = trim(pc_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into lc_csbs,
                   ln_calif0,
                   ln_calif1,
                   ln_calif2,
                   ln_calif3,
                   ln_calif4
              from cldrcci t
             where t.d_fecpre = ld_fecha_pro
               and t.c_tdoctr = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
               and t.c_doctri = trim(pc_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              lc_csbs   := 0;
              ln_calif0 := 100;
              ln_calif1 := 0;
              ln_calif2 := 0;
              ln_calif3 := 0;
              ln_calif4 := 0;
          end;
        
        --exception
        when others then
          lc_csbs   := 0;
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    
    end if;
    begin
      select type_calif_sbs(lc_csbs,
                            ln_calif0,
                            ln_calif1,
                            ln_calif2,
                            ln_calif3,
                            ln_calif4)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------------
  function fn_get_acti_eco(P_PAIS   in number,
                           P_PETDOC in number,
                           P_PENDOC in char) return type_table_acti_eco is
    t_resp     type_table_acti_eco;
    ln_codciiu NUMBER;
    lv_petipo  varchar2(1);
    p_ciuu4    number(12);
    p_ciuu6    number(12);
  Begin
    lv_petipo := '';
    Begin
      Select u.petipo
        Into lv_petipo
        from fsd001 u
       where u.pepais = P_PAIS
         and u.petdoc = P_PETDOC
         and u.pendoc = P_PENDOC;
    
    Exception
      When Others Then
        lv_petipo := '';
    end;
  
    If lv_petipo = 'F' Then
      Begin
        Select c60.sngc60acte --
          Into ln_codciiu
          From sngc60 c60
         Where c60.sngc60pais = P_PAIS
           And c60.sngc60tdoc = P_PETDOC
           And c60.sngc60ndoc = P_PENDOC
           And c60.sngc60corr = 0;
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select e001.expnins --
          Into ln_codciiu
          From fse001 e001
         Where e001.d511pais = P_PAIS
           And e001.d511tdoc = P_PETDOC
           And e001.d511ndoc = P_PENDOC;
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    begin
      select f.actcod2, f.actcod1
        into p_ciuu4, p_ciuu6
        from fst750 f
       where f.actcod1 = ln_codciiu;
    exception
      when others then
        --- 15.01.2021 jrodriguej
        begin
          if ln_codciiu <> 0 then
            p_ciuu4 := 0;
            p_ciuu6 := ln_codciiu;
          end if;
        
        exception
          when others then
            p_ciuu4 := 0;
            p_ciuu6 := 0;
          
        end;
    end;
    begin
      select type_acti_eco(p_ciuu4, p_ciuu6)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------------
  function fn_get_tipo_credito_sbs_vig(pn_cod   in number,
                                       pn_mod   in number,
                                       pn_suc   in number,
                                       pn_mda   in number,
                                       pn_pap   in number,
                                       pn_cta   in number,
                                       pn_ope   in number,
                                       pn_sbo   in number,
                                       pn_top   in number,
                                       pd_fecha in date)
    return type_table_tcred_sbs is
    t_resp   type_table_tcred_sbs;
    ld_fecha date;
  
    ld_fecha_ant date;
    ld_ufech     date;
    ln_anio      number(5);
    ln_ntipo     number(5);
    lc_nconc     char(25);
    lx_fini      date;
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
    
      SELECT
      
       max(t.ppfpag)
        into ld_ufech
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pd_fecha;
    exception
      when others then
        ld_ufech := null;
      
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if ld_ufech is not null then
      ld_fecha_ant := last_day(add_months(trunc(ld_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if ld_fecha <> pd_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select /*+index(t FSH01204)*/t.bcgpo tipo,
                 case
                   when t.bcgpo = 2 then
                    'MICROEMPRESAS'
                   when t.bcgpo = 3 and substr(t.bcrubr, 11, 3) = '015' then
                    'CONSUMO REVOLVENTE'
                   when t.bcgpo = 3 and substr(t.bcrubr, 11, 3) <> '015' then
                    'CONSUMO NO REVOLVENTE'
                   when t.bcgpo = 4 then
                    'HIPOTECARIO'
                   when t.bcgpo = 12 then
                    'MEDIANA EMPRESA'
                   when t.bcgpo = 13 then
                    'PEQUEÑA EMPRESA'
                   when t.bcgpo = 11 then
                    'GRANDES EMPRESAS'
                   when t.bcgpo in (5, 6, 7, 8, 9, 10) then
                    'CORPORATIVO'
                   else
                    ' '
                 END nconcepto
            into ln_ntipo, lc_nconc
            from fsh012 t --- fsd011
           where t.bcemp = pn_cod
             and t.bcmod = pn_mod
                -- and t.bcsuc = pn_suc --  jrodriguej 28.06.2021
                           and t.bcsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
             and t.bcmda = pn_mda
             and t.bcpap = pn_pap
             and t.bccta = pn_cta
             and t.bcoper = pn_ope
                --and t.bcsbop = pn_sbo
             and t.bctop = pn_top
             and t.bcfech = pd_fecha
             and t.bcsdmn <> 0
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from ld_fecha_ant) as anio
                into ln_anio
                from dual;
            
              select substr(f.harub, 5, 2) scgru,
                     case
                       when substr(f.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(f.harub, 5, 2) = 3 and
                            substr(f.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(f.harub, 5, 2) = 3 and
                            substr(f.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(f.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(f.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(f.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(f.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into ln_ntipo, lc_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = ln_anio;
            
            exception
              when others then
              
                ln_ntipo := 0;
                lc_nconc := null;
              
            end;
          
        end;
      
      else
        begin
          -- 1ro. Buscar en la tabla fsd011
          select distinct t.scgru,
                          case
                            when t.scgru = 2 then
                             'MICROEMPRESAS'
                            when t.scgru = 3 and
                                 substr(t.scrub, 11, 3) = '015' then
                             'CONSUMO REVOLVENTE'
                            when t.scgru = 3 and
                                 substr(t.scrub, 11, 3) <> '015' then
                             'CONSUMO NO REVOLVENTE'
                            when t.scgru = 4 then
                             'HIPOTECARIO'
                            when t.scgru = 12 then
                             'MEDIANA EMPRESA'
                            when t.scgru = 13 then
                             'PEQUEÑA EMPRESA'
                            when t.scgru = 11 then
                             'GRANDES EMPRESAS'
                            when t.scgru in (5, 6, 7, 8, 9, 10) then
                             'CORPORATIVO'
                            else
                             ' '
                          END
            into ln_ntipo, lc_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
                --and t.scsuc = pn_suc --  jrodriguej 28.06.2021
                           and t.scsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
                --and t.scsbop = pn_sbo
             and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from ld_fecha_ant) as anio
                into ln_anio
                from dual;
            
              select substr(f.harub, 5, 2) scgru,
                     case
                       when substr(f.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(f.harub, 5, 2) = 3 and
                            substr(f.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(f.harub, 5, 2) = 3 and
                            substr(f.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(f.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(f.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(f.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(f.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into ln_ntipo, lc_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = ln_anio;
            
            exception
              when others then
              
                ln_ntipo := 0;
                lc_nconc := null;
              
            end;
          
        end;
      
      end if;
    
    exception
      when others then
        ln_ntipo := 0;
        lc_nconc := null;
      
    end;
    begin
       SELECT
      
       max(t.ppfpag)
        into ld_ufech
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pd_fecha
         and t.pp1cap >0;
    exception
      when others then
        ld_ufech := null;
    end;
    /*if lx_fini >pd_fecha then 
      ld_ufech := null;
    end if;*/
    begin
      select type_tcred_sbs(ln_ntipo, lc_nconc, ld_ufech)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  
  end;
  ----------------------------------------------------------------------
  function fn_get_rubro(pn_cod   in number,
                                       pn_mod   in number,
                                       pn_suc   in number,
                                       pn_mda   in number,
                                       pn_pap   in number,
                                       pn_cta   in number,
                                       pn_ope   in number,
                                       pn_sbo   in number,
                                       pn_top   in number,
                                       pd_fecha in date)
    return type_table_tcred_sbs is
    t_resp   type_table_tcred_sbs;
    ld_fecha date;
  
    ld_fecha_ant date;
    ld_ufech     date;
    ln_anio      number(5);
    ln_ntipo     number(5);
    lc_nconc     char(25);
    lx_fini      date;
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
     
  
    -- 4. Obtención rubro
    begin
    
      if ld_fecha <> pd_fecha then
      
        begin
          
          select /*+index(t FSH01204)*/to_number(substr(t.bcrubr,1,4))  --08.11.2023
            into ln_ntipo
            from fsh012 t --- fsd011
           where t.bcemp = pn_cod
             and t.bcmod = pn_mod
                -- and t.bcsuc = pn_suc 
                           and t.bcsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
             and t.bcmda = pn_mda
             and t.bcpap = pn_pap
             and t.bccta = pn_cta
             and t.bcoper = pn_ope
                --and t.bcsbop = pn_sbo
             and t.bctop = pn_top
             and t.bcfech = pd_fecha
             and t.bcsdmn <> 0
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              --select extract(year from ld_fecha_ant) as anio  --2024.07.31 dcastro
              select extract(year from ld_fecha) as anio  --2024.07.31 dcastro
               
                into ln_anio
                from dual;
            
              select to_number(substr(f.harub,1,4))
                into ln_ntipo
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = ln_anio;
            
            exception
              when others then
              
                ln_ntipo := 0;
                lc_nconc := null;
              
            end;
          
        end;
      
      else
        begin
          
          select to_number(substr(t.scrub,1,4))
            into ln_ntipo
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
                --and t.scsuc = pn_suc --  jrodriguej 28.06.2021
                           and t.scsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
                --and t.scsbop = pn_sbo
             and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              --select extract(year from ld_fecha_ant) as anio  --2024.07.31 dcastro
              select extract(year from ld_fecha) as anio  --2024.07.31 dcastro
                into ln_anio
                from dual;
            
              select to_number(substr(f.harub,1,4))
                into ln_ntipo
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = ln_anio;
            
            exception
              when others then
              
                ln_ntipo := 0;
                lc_nconc := null;
              
            end;
          
        end;
      
      end if;
    
    exception
      when others then
        ln_ntipo := 0;
        
      
    end;
   
    begin
      select type_tcred_sbs(ln_ntipo, lc_nconc, ld_ufech)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  
  end;
  ------------------------------------------------------------------------
  function fn_get_distribuc_pago(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago is
    t_resp  type_table_distrib_pago;
    ln_tsum number(17, 2);
    ln_gas  number(17, 2); -- seguridad
    ln_mor  number(17, 2); -- moratoria
    ln_int  number(17, 2); -- interés
    ln_cuo  number(17, 2); -- capital
    ln_icv  number(17, 2); -- interés compensatorio (icv)
    ln_pen  number(17, 2); -- penalidad
  
    ld_ppfpag  date;
    ln_pp1nump number(9);
    lc_fmant   date;
  
  begin
    -- clave
    ln_tsum := 0;
    ln_gas  := 0;
    ln_mor  := 0;
    ln_int  := 0;
    ln_cuo  := 0;
    ln_icv  := 0;
    ln_pen  := 0;
    --fecha mes anterior
    lc_fmant := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')));
    begin
    
      select f.ppfpag, f.pp1nump
        into ld_ppfpag, ln_pp1nump
        from (select t.ppfpag, t.pp1nump
                from fsd602 t
               where t.pgcod = pn_cod
                 and t.ppmod = pn_mod
                 and t.ppsuc = pn_suc
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 and t.ppsbop = pn_sbo
                 and t.pptope = pn_top
                 and t.pp1stat in ('P', 'T')
                 and t.d602fc <= pd_fecha
                 and t.d602co = 'S'
               order by t.pp1nump desc) f
       where rownum = 1;
    exception
      when others then
        ld_ppfpag  := null;
        ln_pp1nump := null;
    end;
  
    --if ld_ppfpag is not null then
    
      -- Interés y capital
      begin
      
        select /*+index(t SYS_C00978743)*/sum(case when t.pp1cap >0 then nvl(t.pp1cap, 0) else 0 end), 
        sum(nvl(t.pp1int, 0))
          into ln_cuo, ln_int
        
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           --and t.ppsuc = pn_suc
           and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           --and t.ppfpag = ld_ppfpag
           and t.pp1stat in ('P', 'T')
           --and t.pp1cap > 0
           and t.d602fc > lc_fmant
           and t.d602fc <= pd_fecha
           and t.d602co = 'S';
      
      exception
        when others then
          ln_cuo := 0;
          ln_int := 0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into ln_mor, ln_icv, ln_gas
          from fsd612 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp1nump <= lc_pp1nump;
           --and x.pp1nump = ln_pp1nump
           and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          ln_mor := 0;
          ln_icv := 0;
          ln_gas := 0;
      end;
    
      --- Penalidad
      begin
        select sum(nvl(x.pp003imp, 0))
          into ln_pen
          from fpp003 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp003nump <= lc_pp1nump;
           --and x.pp003nump = ln_pp1nump
           and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          ln_pen := 0;
      end;
    
    --else
    --  ln_gas := 0;
    --  ln_mor := 0;
    --  ln_int := 0;
    --  ln_cuo := 0;
    --  ln_icv := 0;
    --  ln_pen := 0;
    --end if;
  
    ln_tsum := (nvl(ln_gas,0) + nvl(ln_mor,0) + nvl(ln_int,0) + nvl(ln_cuo,0) + nvl(ln_icv,0) + nvl(ln_pen,0));
    begin
      select type_distrib_pago(ln_tsum,
                               ln_gas,
                               ln_mor,
                               ln_int,
                               ln_cuo,
                               ln_icv,
                               ln_pen)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ------------------------------------------------------------------------
  function fn_get_distribuc_pago_acum(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago is
    t_resp  type_table_distrib_pago;
    lc_cont number;
    ln_tsum number(17, 2);
    ln_gas  number(17, 2); -- seguridad
    ln_mor  number(17, 2); -- moratoria
    ln_int  number(17, 2); -- interés
    ln_cuo  number(17, 2); -- capital
    ln_icv  number(17, 2); -- interés compensatorio (icv)
    ln_pen  number(17, 2); -- penalidad
  
    ld_ppfpag  date;
    ln_pp1nump number(9);
  
  begin
    -- clave
    ln_tsum := 0;
    ln_gas  := 0;
    ln_mor  := 0;
    ln_int  := 0;
    ln_cuo  := 0;
    ln_icv  := 0;
    ln_pen  := 0;
    begin
    
      select count(*)
        into lc_cont
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
            -- and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            --and t.ppsbop = pn_sbo
            --and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and (t.d602mo, t.d602tr) not in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 2
                 and x.tp1corr3 > 0)
         and t.d602fc <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        lc_cont := 0;
    end;
    if lc_cont > 0 then
    
      -- Interés y capital
      begin
      
        select /*+index(T SYS_C00978743)*/nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into ln_cuo, ln_int
        
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
              -- and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
           and t.ppsuc in (select p.sucurs
                             from fst001 p
                            where p.pgcod = 1
                              and p.sucurs < 800)
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
              --and t.ppsbop = pn_sbo
              --and t.pptope = pn_top
           and t.pp1stat in ('P', 'T')
           and (t.d602mo, t.d602tr) not in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 2
                   and x.tp1corr3 > 0)
           and t.d602fc <= pd_fecha
           and t.d602co = 'S';
      
      exception
        when others then
          ln_cuo := 0;
          ln_int := 0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into ln_mor, ln_icv, ln_gas
          from fsd612 x, FSD602 t
         where x.pgcod = t.pgcod
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp1nump = t.pp1nump
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
              -- and x.ppsuc = pn_suc --  jrodriguej 28.06.2021
           and x.ppsuc in (select p.sucurs
                             from fst001 p
                            where p.pgcod = 1
                              and p.sucurs < 800)
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
              --and x.ppsbop = pn_sbo
              --and x.pptope = pn_top
              
           and t.pp1stat in ('P', 'T')
           and (t.d602mo, t.d602tr) not in
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and t.d602fc <= pd_fecha
           and t.d602co = 'S'
        
        ;
      exception
        when others then
          ln_mor := 0;
          ln_icv := 0;
          ln_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into ln_pen
          from fpp003 x, FSD602 t
         where x.pgcod = t.pgcod
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp003nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
              --and x.ppsuc = pn_suc --  jrodriguej 28.06.2021
           and x.ppsuc in (select p.sucurs
                             from fst001 p
                            where p.pgcod = 1
                              and p.sucurs < 800)
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
              --and x.ppsbop = pn_sbo
              --and x.pptope = pn_top
              
           and t.pp1stat in ('P', 'T')
           and (t.d602mo, t.d602tr) not in
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and t.d602fc <= pd_fecha
           and t.d602co = 'S'
        
        ;
      exception
        when others then
          ln_pen := 0;
      end;
    
    else
      ln_gas := 0;
      ln_mor := 0;
      ln_int := 0;
      ln_cuo := 0;
      ln_icv := 0;
      ln_pen := 0;
    end if;
  
    ln_tsum := (ln_gas + ln_mor + ln_int + ln_cuo + ln_icv + ln_pen);
    
    
    begin
      select type_distrib_pago(ln_tsum,
                               ln_gas,
                               ln_mor,
                               ln_int,
                               ln_cuo,
                               ln_icv,
                               ln_pen)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ------------------------------------------------------------------------
  function fn_get_calf_caja(pn_cta in number, pd_fecha in date)
    return type_table_calif_caja is
    t_resp     type_table_calif_caja;
    ln_calif0a number(5, 2);
    ln_calif1a number(5, 2);
    ln_calif2a number(5, 2);
    ln_calif3a number(5, 2);
    ln_calif4a number(5, 2);
    ld_deccaj  date;
  
    lc_tcla number(4);
  
    lc_distrib char(15);
  
    lc_fecha_pro date;
  
  begin
  
    begin
    
      -- 0: NORMAL
      -- 1: CPP
      -- 2: DEFICIENTE
      -- 3: DUDOSO
      -- 4: PÉRDIDA
    
      lc_fecha_pro := last_day(add_months(trunc(pd_fecha), -1));
    
      select f.catcateg
        into lc_distrib
        from fsd212 f
       where f.catcta = pn_cta
         and f.catfchdes = lc_fecha_pro
         and f.catcod = 4;
    
      lc_tcla := to_number(substr(lc_distrib, 1, 1));
    
      case
        when lc_tcla = 0 then
          -- 0: Normal
          --lc_ncla := 'NORMAL';
          ln_calif0a := 100;
          ln_calif1a := 0;
          ln_calif2a := 0;
          ln_calif3a := 0;
          ln_calif4a := 0;
        
        when lc_tcla = 1 then
          -- 1: CPP
          --lc_ncla := 'CPP';
          ln_calif0a := 0;
          ln_calif1a := 100;
          ln_calif2a := 0;
          ln_calif3a := 0;
          ln_calif4a := 0;
        when lc_tcla = 2 then
          -- 2: Deficiente
          --lc_ncla := 'Deficiente';
          ln_calif0a := 0;
          ln_calif1a := 0;
          ln_calif2a := 100;
          ln_calif3a := 0;
          ln_calif4a := 0;
        when lc_tcla = 3 then
          -- 3: Dudoso
          --lc_ncla := 'Dudoso';
          ln_calif0a := 0;
          ln_calif1a := 0;
          ln_calif2a := 0;
          ln_calif3a := 100;
          ln_calif4a := 0;
        when lc_tcla = 4 then
          -- 4: Pérdida
          --lc_ncla := 'PÉRDIDA';
          ln_calif0a := 0;
          ln_calif1a := 0;
          ln_calif2a := 0;
          ln_calif3a := 0;
          ln_calif4a := 100;
      end case;
    
    exception
      when others then
      
        ln_calif0a := 100;
        ln_calif1a := 0;
        ln_calif2a := 0;
        ln_calif3a := 0;
        ln_calif4a := 0;
      
    end;
  
    ld_deccaj := lc_fecha_pro;
    begin
      select type_calif_caja(ln_calif0a,
                             ln_calif1a,
                             ln_calif2a,
                             ln_calif3a,
                             ln_calif4a,
                             ld_deccaj)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_repro_dato1(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pd_fecha in date) return type_table_repro_datos is
    t_resp   type_table_repro_datos;
    ln_flag  char(2);
    ln_nrep  number(6);
    ln_fech  date;
    ln_tabla varchar2(50);
    ln_peri  number(6);
    ln_ncuo  number(6);
    ln_fpri  date;
    ln_fult  date;
  
    lx_cont number;
    lx_exis number;
    lx_vali number;
    lx_suc  number;
    lx_sbop number;
    lx_tope number;
    lc_frep date;
    lc_corr number;
  
    lx_sbop1 number;
    lx_suc1  number;
    lx_tope1 number;
  
    lc_frep2 date;
    lc_corr2 number;
    lx_sbop2 number;
    lx_suc2  number;
    lx_tope2 number;
  
    lc_frep3 date;
    lc_corr3 number;
    lx_sbop3 number;
    lx_suc3  number;
    lx_tope3 number;
  
    lx_sbop4 number;
    lx_suc4  number;
    lx_tope4 number;
  
    ln_exis number;
  
    lc_frep5 date;
    lc_corr5 number;
  
    ld_fecha1 date;
    ld_fecha2 date;
  
    ln_pgcod  number;
    ln_aomod  number;
    ln_aosuc  number;
    ln_aomda  number;
    ln_aopap  number;
    ln_aocta  number;
    ln_aooper number;
    ln_aosbop number;
    ln_aotope number;
  begin
    lx_cont := 0;
    select count(*), max(x.jaqa400fec)
      into lx_cont, ln_fech
      from jaqa400 x
     where x.jaqa400emp = pn_cod
       and x.jaqa400cta = pn_cta
       and x.jaqa400ope = pn_ope
       and x.jaqa400est in ('C')
       and x.jaqa400fec <= pd_fecha;
    if lx_cont > 0 then
      ln_tabla := 'JAQA400';
      ln_flag  := 'SI';
      ln_nrep  := lx_cont;
      --periodod gracia
      begin
        begin          
        select a.xllfprimpa
          into ld_fecha2
          from x054023 a
         where a.xllpgcod = pn_cod
           and a.xllaocta = pn_cta
           and a.xllaooper = pn_ope
           and a.xllaosbop = 609
           and rownum = 1;
        exception when others then null;
        end;
        begin
        select max(a.xllfprimpa)
          into ld_fecha1
          from x054023 a
         where a.xllpgcod = pn_cod
           and a.xllaocta = pn_cta
           and a.xllaooper = pn_ope
           and a.xllaosbop <> 609
           and a.xllfprimpa < ld_fecha2;
        exception when others then null;
        end;
        if ld_fecha2 is null then
          ln_peri := 0;
        else
          if ld_fecha1 is null then
            ln_peri := 0;
          else
            select round((ld_fecha2 - ld_fecha1) / 30)
              into ln_peri
              from dual;
          end if;
        end if;
      
      exception
        when others then
          ln_peri := 0;
      end;
      if ln_peri < 0 then
        ln_peri := 0;
      end if;
      begin
        begin
        select max(t.aosbop)
          into lx_sbop
          from fsd010 t
         where t.pgcod = pn_cod
           and t.aocta = pn_cta
           and t.aooper = pn_ope
           and t.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144));
        exception when others then null;
        end;
        begin
        select t.pgcod,
               t.aomod,
               t.aosuc,
               t.aomda,
               t.aopap,
               t.aocta,
               t.aooper,
               t.aosbop,
               t.aotope
          into ln_pgcod,
               ln_aomod,
               ln_aosuc,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          from fsd010 t
         where t.pgcod = pn_cod
           and t.aocta = pn_cta
           and t.aooper = pn_ope
           and t.aosbop = lx_sbop
           and t.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
           and rownum = 1;
        exception when others then null;
        end;
        -- Obter número de cuotas
        begin
        select count(*)
          into ln_ncuo
          from fsd601 t
         where t.pgcod = ln_pgcod
           and t.ppmod = ln_aomod
           and t.ppsuc = ln_aosuc
           and t.ppmda = ln_aomda
           and t.pppap = ln_aopap
           and t.ppcta = ln_aocta
           and t.ppoper = ln_aooper
           and t.ppsbop = ln_aosbop
           and t.pptope = ln_aotope;
        exception when others then null;
        end;
        -- Obtener primera fecha del crédito reprogramado
        begin
        select g.ppfpag
          into ln_fpri
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = ln_pgcod
                   and t.ppmod = ln_aomod
                   and t.ppsuc = ln_aosuc
                   and t.ppmda = ln_aomda
                   and t.pppap = ln_aopap
                   and t.ppcta = ln_aocta
                   and t.ppoper = ln_aooper
                   and t.ppsbop = ln_aosbop
                   and t.pptope = ln_aotope
                 order by t.ppfpag asc) g
         where rownum = 1;
        exception when others then null;
        end;
        -- Obtener fecha de fin del crédito reprogramado
        begin
        select g.ppfpag
          into ln_fult
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = ln_pgcod
                   and t.ppmod = ln_aomod
                   and t.ppsuc = ln_aosuc
                   and t.ppmda = ln_aomda
                   and t.pppap = ln_aopap
                   and t.ppcta = ln_aocta
                   and t.ppoper = ln_aooper
                   and t.ppsbop = ln_aosbop
                   and t.pptope = ln_aotope
                 order by t.ppfpag desc) g
         where rownum = 1;
         exception when others then null;
        end;
      exception
        when others then
        
          ln_ncuo := 0;
          ln_fpri := null;
          ln_fult := null;
      end;
    else
      select count(*)
        into lx_cont
        from aqpb090 x
       where x.aqpb090fec <= pd_fecha
         and x.aqpb090cta = pn_cta
         and x.aqpb090oper = pn_ope
         and x.aqpb090ext = 'NO';
    
      if lx_cont > 0 then
      
        ln_flag := 'SI';
        ln_nrep := lx_cont;
      
        select y.aqpb090fec, y.aqpb090tabla
          into ln_fech, ln_tabla
          from (select x.aqpb090fec, x.aqpb090tabla
                  from aqpb090 x
                 where x.aqpb090fec <= pd_fecha
                   and x.aqpb090cta = pn_cta
                   and x.aqpb090oper = pn_ope
                   and x.aqpb090ext = 'NO'
                 order by x.aqpb090fec desc) y
         where rownum = 1;
      
        -- Obtención de datos adicionales
        if ln_tabla = 'AQPB002' or ln_tabla = 'JAQZ698' then
          lx_vali := 1;
          -- Obtención de la fecha de la primera cuota de reprogramación
          case
            when ln_tabla = 'AQPB002' then
            
              select count(*)
                into lx_exis
                from aqpb002 x
               where x.aqpb002emp = pn_cod
                 and x.aqpb002mod = pn_mod
                 and x.aqpb002mda = pn_mda
                 and x.aqpb002pap = pn_pap
                 and x.aqpb002cta = pn_cta
                 and x.aqpb002ope = pn_ope
                 and x.aqpb002est = 'C'
                 and x.aqpb002fep > ln_fech;
            
              -- captura de datos
              begin
                select g.aqpb002fep,
                       g.aqpb002cor,
                       g.aqpb002suc,
                       g.aqpb002sbo,
                       g.aqpb002top
                  into lc_frep, lc_corr, lx_suc, lx_sbop, lx_tope
                  from (select x.aqpb002fep,
                               x.aqpb002cor,
                               x.aqpb002suc,
                               x.aqpb002sbo,
                               x.aqpb002top
                        
                          from aqpb002 x
                         where x.aqpb002emp = pn_cod
                           and x.aqpb002mod = pn_mod
                           and x.aqpb002mda = pn_mda
                           and x.aqpb002pap = pn_pap
                           and x.aqpb002cta = pn_cta
                           and x.aqpb002ope = pn_ope
                           and x.aqpb002est = 'C'
                           and x.aqpb002fep >= ln_fech
                         order by x.aqpb002fep asc) g
                 where rownum = 1;
              
              exception
                when others then
                  lx_vali := 0;
              end;
            
              --- si no existe una posterior
              if lx_exis = 0 and lx_vali = 1 then
              
                --lx_exis := 1;
                begin
                  -- Obtener máxima suboperación
                  begin
                  select max(t.aosbop)
                    into lx_sbop1
                    from fsd010 t
                   where t.pgcod = pn_cod
                     and t.aomod = pn_mod
                     and t.aomda = pn_mda
                     and t.aopap = pn_pap
                     and t.aocta = pn_cta
                     and t.aooper = pn_ope
                        --and t.aomod <> 419 --  jrodriguej 28.06.2021
                     and t.aomod in
                         (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144));
                  exception when others then null;
                  end;
                  -- Comparar
                  if lx_sbop1 <> lx_sbop then
                    begin
                    select t.aosuc, t.aotope
                      into lx_suc1, lx_tope1
                      from fsd010 t
                     where t.pgcod = pn_cod
                       and t.aomod = pn_mod
                       and t.aomda = pn_mda
                       and t.aopap = pn_pap
                       and t.aocta = pn_cta
                       and t.aooper = pn_ope
                       and t.aosbop = lx_sbop1
                          --and t.aomod <> 419 --  jrodriguej 28.06.2021
                       and t.aomod in
                           (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 120, 144));
                    exception when others then null;
                    end;
                    begin
                    
                      -- Obter número de cuotas
                      begin
                      select count(*)
                        into ln_ncuo
                        from fsd601 t
                       where t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc1
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop1
                         and t.pptope = lx_tope1;
                      exception when others then null;
                      end;
                      -- Obtener primera fecha del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc1
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop1
                                 and t.pptope = lx_tope1
                               order by t.ppfpag asc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                      -- Obtener fecha de fin del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc1
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop1
                                 and t.pptope = lx_tope1
                               order by t.ppfpag desc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                    exception
                     when others then null;
                    end;
                  else
                    begin
                    
                      -- Obter número de cuotas
                      begin
                      select count(*)
                        into ln_ncuo
                        from fsd601 t
                       where t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop
                         and t.pptope = lx_tope;
                      exception when others then null;
                      end;
                      -- Obtener primera fecha del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag asc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                      -- Obtener fecha de fin del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag desc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                    exception
                     when others then null;
                    end;
                  end if;
                
                  -- Obtener periodo de gracia
                  begin
                  select (x.aqpb002pdi * 30)
                    into ln_peri
                    from aqpb002 x
                   where x.aqpb002fep = lc_frep
                     and x.aqpb002cor = lc_corr
                     and x.aqpb002emp = pn_cod
                     and x.aqpb002mod = pn_mod
                     and x.aqpb002suc = lx_suc
                     and x.aqpb002mda = pn_mda
                     and x.aqpb002pap = pn_pap
                     and x.aqpb002cta = pn_cta
                     and x.aqpb002ope = pn_ope
                     and x.aqpb002sbo = lx_sbop
                     and x.aqpb002top = lx_tope;
                   exception when others then null;
                   end;
                exception
                     when others then null;
                end;
              
              elsif lx_exis = 1 and lx_vali = 1 then
                --lx_exis := 1;
                begin
                
                  -- Obtener periodo de gracia
                  begin
                  select (x.aqpb002pdi * 30)
                    into ln_peri
                    from aqpb002 x
                   where x.aqpb002fep = lc_frep
                     and x.aqpb002cor = lc_corr
                     and x.aqpb002emp = pn_cod
                     and x.aqpb002mod = pn_mod
                     and x.aqpb002suc = lx_suc
                     and x.aqpb002mda = pn_mda
                     and x.aqpb002pap = pn_pap
                     and x.aqpb002cta = pn_cta
                     and x.aqpb002ope = pn_ope
                     and x.aqpb002sbo = lx_sbop
                     and x.aqpb002top = lx_tope;
                  exception when others then null;
                  end;
                  -- Obtener información de la siguiente reprogramación
                  begin
                  select g.aqpb002fep,
                         g.aqpb002cor,
                         g.aqpb002suc,
                         g.aqpb002sbo,
                         g.aqpb002top
                    into lc_frep2, lc_corr2, lx_suc2, lx_sbop2, lx_tope2
                    from (select t.aqpb002fep,
                                 t.aqpb002cor,
                                 t.aqpb002suc,
                                 t.aqpb002sbo,
                                 t.aqpb002top
                            from aqpb002 t
                           where t.aqpb002emp = pn_cod
                             and t.aqpb002mod = pn_mod
                             and t.aqpb002mda = pn_mda
                             and t.aqpb002pap = pn_pap
                             and t.aqpb002cta = pn_cta
                             and t.aqpb002ope = pn_ope
                             and t.aqpb002fep >= lc_frep
                             and t.aqpb002est = 'C'
                           order by t.aqpb002fep asc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                  -- Obter número de cuotas
                  begin
                  select count(*)
                    into ln_ncuo
                    from jaqz520_601 t
                   where t.pgcod = pn_cod
                     and t.ppmod = pn_mod
                     and t.ppsuc = lx_suc2
                     and t.ppmda = pn_mda
                     and t.pppap = pn_pap
                     and t.ppcta = pn_cta
                     and t.ppoper = pn_ope
                     and t.ppsbop = lx_sbop2
                     and t.pptope = lx_tope2;
                  exception when others then null;
                  end;
                  -- Obtener primera fecha del crédito reprogramado
                  begin
                  select g.ppfpag
                    into ln_fpri
                    from (select t.ppfpag
                            from jaqz520_601 t
                           where t.pgcod = pn_cod
                             and t.ppmod = pn_mod
                             and t.ppsuc = lx_suc2
                             and t.ppmda = pn_mda
                             and t.pppap = pn_pap
                             and t.ppcta = pn_cta
                             and t.ppoper = pn_ope
                             and t.ppsbop = lx_sbop2
                             and t.pptope = lx_tope2
                           order by t.ppfpag asc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                  -- Obtener fecha de fin del crédito reprogramado
                  begin
                  select g.ppfpag
                    into ln_fult
                    from (select t.ppfpag
                            from jaqz520_601 t
                           where t.pgcod = pn_cod
                             and t.ppmod = pn_mod
                             and t.ppsuc = lx_suc2
                             and t.ppmda = pn_mda
                             and t.pppap = pn_pap
                             and t.ppcta = pn_cta
                             and t.ppoper = pn_ope
                             and t.ppsbop = lx_sbop2
                             and t.pptope = lx_tope2
                           order by t.ppfpag desc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                exception
                   when others then null;
                end;
              
              elsif lx_exis >= 2 and lx_vali = 1 then
                --lx_exis := 1;
                begin
                  -- Obtener periodo de gracia
                  begin
                  select (x.aqpb002pdi * 30)
                    into ln_peri
                    from aqpb002 x
                   where x.aqpb002fep = lc_frep
                     and x.aqpb002cor = lc_corr
                     and x.aqpb002emp = pn_cod
                     and x.aqpb002mod = pn_mod
                     and x.aqpb002suc = lx_suc
                     and x.aqpb002mda = pn_mda
                     and x.aqpb002pap = pn_pap
                     and x.aqpb002cta = pn_cta
                     and x.aqpb002ope = pn_ope
                     and x.aqpb002sbo = lx_sbop
                     and x.aqpb002top = lx_tope;
                  exception when others then null;
                  end;
                  -- Obtener información de la siguiente reprogramación
                  begin
                  select g.aqpb002fep,
                         g.aqpb002cor,
                         g.aqpb002suc,
                         g.aqpb002sbo,
                         g.aqpb002top
                    into lc_frep3, lc_corr3, lx_suc3, lx_sbop3, lx_tope3
                    from (select t.aqpb002fep,
                                 t.aqpb002cor,
                                 t.aqpb002suc,
                                 t.aqpb002sbo,
                                 t.aqpb002top
                            from aqpb002 t
                           where t.aqpb002emp = pn_cod
                             and t.aqpb002mod = pn_mod
                             and t.aqpb002mda = pn_mda
                             and t.aqpb002pap = pn_pap
                             and t.aqpb002cta = pn_cta
                             and t.aqpb002ope = pn_ope
                             and t.aqpb002fep >= lc_frep
                             and t.aqpb002est = 'C'
                           order by t.aqpb002fep asc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                  -- Obter número de cuotas
                  begin
                  select count(*)
                    into ln_ncuo
                    from aqpa006 t
                   where t.aqpa006fecpro = lc_frep3
                     and t.aqpa006cor = lc_corr3
                     and t.aqpa006cod = pn_cod
                     and t.aqpa006mod = pn_mod
                     and t.aqpa006suc = lx_suc3
                     and t.aqpa006mda = pn_mda
                     and t.aqpa006pap = pn_pap
                     and t.aqpa006cta = pn_cta
                     and t.aqpa006oper = pn_ope
                     and t.aqpa006sbop = lx_sbop3
                     and t.aqpa006tope = lx_tope3;
                  exception when others then null;
                  end;
                  -- Obtener primera fecha del crédito reprogramado
                  begin
                  select g.aqpa006fpag
                    into ln_fpri
                    from (select t.aqpa006fpag
                            from aqpa006 t
                           where t.aqpa006fecpro = lc_frep3
                             and t.aqpa006cor = lc_corr3
                             and t.aqpa006cod = pn_cod
                             and t.aqpa006mod = pn_mod
                             and t.aqpa006suc = lx_suc3
                             and t.aqpa006mda = pn_mda
                             and t.aqpa006pap = pn_pap
                             and t.aqpa006cta = pn_cta
                             and t.aqpa006oper = pn_ope
                             and t.aqpa006sbop = lx_sbop3
                             and t.aqpa006tope = lx_tope3
                           order by t.aqpa006fpag asc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                  -- Obtener fecha de fin del crédito reprogramado
                  begin
                  select g.aqpa006fpag
                    into ln_fult
                    from (select t.aqpa006fpag
                            from aqpa006 t
                           where t.aqpa006fecpro = lc_frep3
                             and t.aqpa006cor = lc_corr3
                             and t.aqpa006cod = pn_cod
                             and t.aqpa006mod = pn_mod
                             and t.aqpa006suc = lx_suc3
                             and t.aqpa006mda = pn_mda
                             and t.aqpa006pap = pn_pap
                             and t.aqpa006cta = pn_cta
                             and t.aqpa006oper = pn_ope
                             and t.aqpa006sbop = lx_sbop3
                             and t.aqpa006tope = lx_tope3
                           order by t.aqpa006fpag desc) g
                   where rownum = 1;
                  exception when others then null;
                  end;
                exception
                   when others then null;
                end;
              end if;
            
            when ln_tabla = 'JAQZ698' then
              begin
              select count(*)
                into lx_exis
                from jaqz698 x
               where x.jaqz698emp = pn_cod
                 and x.jaqz698mod = pn_mod
                 and x.jaqz698mda = pn_mda
                 and x.jaqz698pap = pn_pap
                 and x.jaqz698cta = pn_cta
                 and x.jaqz698ope = pn_ope
                 and x.jaqz698est in ('C', 'V')
                 and x.jaqz698fep > ln_fech;
              exception when others then null;
              end;
              -- captura de datos
              begin
                select g.jaqz698fep,
                       g.jaqz698cor,
                       g.jaqz698suc,
                       g.jaqz698sbo,
                       g.jaqz698top
                  into lc_frep, lc_corr, lx_suc, lx_sbop, lx_tope
                  from (select x.jaqz698fep,
                               x.jaqz698cor,
                               x.jaqz698suc,
                               x.jaqz698sbo,
                               x.jaqz698top
                        
                          from jaqz698 x
                         where x.jaqz698emp = pn_cod
                           and x.jaqz698mod = pn_mod
                           and x.jaqz698mda = pn_mda
                           and x.jaqz698pap = pn_pap
                           and x.jaqz698cta = pn_cta
                           and x.jaqz698ope = pn_ope
                           and x.jaqz698est in ('C', 'V')
                           and x.jaqz698fep >= ln_fech
                         order by x.jaqz698fep asc) g
                 where rownum = 1;
              
              exception
                when others then
                  lx_vali := 0;
              end;
            
              --- si no existe una posterior
              if lx_exis = 0 and lx_vali = 1 then
              
                --lx_exis := 1;
                begin
                  -- Obtener máxima suboperación
                  begin
                  select max(t.aosbop)
                    into lx_sbop4
                    from fsd010 t
                   where t.pgcod = pn_cod
                     and t.aomod = pn_mod
                     and t.aomda = pn_mda
                     and t.aopap = pn_pap
                     and t.aocta = pn_cta
                     and t.aooper = pn_ope
                        --and t.aomod <> 419 --  jrodriguej 28.06.2021
                     and t.aomod in
                         (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144));
                  exception when others then null;
                  end;
                  -- Comparar
                  if lx_sbop4 <> lx_sbop then
                    begin
                    select t.aosuc, t.aotope
                      into lx_suc4, lx_tope4
                      from fsd010 t
                     where t.pgcod = pn_cod
                       and t.aomod = pn_mod
                       and t.aomda = pn_mda
                       and t.aopap = pn_pap
                       and t.aocta = pn_cta
                       and t.aooper = pn_ope
                       and t.aosbop = lx_sbop
                          --and t.aomod <> 419 --  jrodriguej 28.06.2021
                       and t.aomod in
                           (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 120, 144));
                    exception when others then null;
                    end;
                    begin
                    
                      -- Obter número de cuotas
                      begin
                      select count(*)
                        into ln_ncuo
                        from fsd601 t
                       where t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc4
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop4
                         and t.pptope = lx_tope4;
                      exception when others then null;
                      end;
                      -- Obtener primera fecha del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc4
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop4
                                 and t.pptope = lx_tope4
                               order by t.ppfpag asc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                      -- Obtener fecha de fin del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc4
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop4
                                 and t.pptope = lx_tope4
                               order by t.ppfpag desc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                    exception
                       when others then null;
                    end;
                  else
                    begin
                    
                      -- Obter número de cuotas
                      begin
                      select count(*)
                        into ln_ncuo
                        from fsd601 t
                       where t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop
                         and t.pptope = lx_tope;
                      exception when others then null;
                      end;
                      -- Obtener primera fecha del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag asc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                      -- Obtener fecha de fin del crédito reprogramado
                      begin
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from fsd601 t
                               where t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag desc) g
                       where rownum = 1;
                      exception when others then null;
                      end;
                    exception
                       when others then null;
                    end;
                  
                  end if;
                
                  -- Obtener periodo de gracia
                  begin
                  select x.jaqz698per
                    into ln_peri
                    from jaqz698 x
                   where x.jaqz698fep = lc_frep
                     and x.jaqz698cor = lc_corr
                     and x.jaqz698emp = pn_cod
                     and x.jaqz698mod = pn_mod
                     and x.jaqz698suc = lx_suc
                     and x.jaqz698mda = pn_mda
                     and x.jaqz698pap = pn_pap
                     and x.jaqz698cta = pn_cta
                     and x.jaqz698ope = pn_ope
                     and x.jaqz698sbo = lx_sbop
                     and x.jaqz698top = lx_tope;
                   exception when others then null;
                   end;
                exception
                     when others then null;
                end;
              
              elsif lx_exis >= 1 and lx_vali = 1 then
                --lx_exis := 1;
                begin
                
                  -- Obtener periodo de gracia
                  begin
                  select x.jaqz698per
                    into ln_peri
                    from jaqz698 x
                   where x.jaqz698fep = lc_frep
                     and x.jaqz698cor = lc_corr
                     and x.jaqz698emp = pn_cod
                     and x.jaqz698mod = pn_mod
                     and x.jaqz698suc = lx_suc
                     and x.jaqz698mda = pn_mda
                     and x.jaqz698pap = pn_pap
                     and x.jaqz698cta = pn_cta
                     and x.jaqz698ope = pn_ope
                     and x.jaqz698sbo = lx_sbop
                     and x.jaqz698top = lx_tope;
                  exception when others then null;
                  end;
                  -- Obtener datos del crédito vigente a ese entonces
                  -- Obtener información de la siguiente reprogramación
                  ln_exis := 1;
                  begin
                    select g.jaqz698fep, g.jaqz698cor
                      into lc_frep5, lc_corr5
                      from (select t.jaqz698fep, t.jaqz698cor
                              from jaqz698 t
                             where t.jaqz698emp = pn_cod
                               and t.jaqz698mod = pn_mod
                               and t.jaqz698suc = lx_suc
                               and t.jaqz698mda = pn_mda
                               and t.jaqz698pap = pn_pap
                               and t.jaqz698cta = pn_cta
                               and t.jaqz698ope = pn_ope
                               and t.jaqz698sbo = lx_sbop
                               and t.jaqz698top = lx_tope
                               and t.jaqz698fep > lc_frep
                               and t.jaqz698est in ('C', 'V')
                             order by t.jaqz698fep asc) g
                     where rownum = 1;
                  exception
                    when others then
                      ln_exis := 0;
                  end;
                
                  if ln_exis = 0 then
                    begin
                      -- Obter número de cuotas
                      select count(*)
                        into ln_ncuo
                        from jaqz520_601c t
                       where t.fec = lc_frep
                         and t.cor = lc_corr
                         and t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop
                         and t.pptope = lx_tope;
                    
                      -- Obtener primera fecha del crédito reprogramado
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from jaqz520_601c t
                               where t.fec = lc_frep
                                 and t.cor = lc_corr
                                 and t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag asc) g
                       where rownum = 1;
                    
                      -- Obtener fecha de fin del crédito reprogramado
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from jaqz520_601c t
                               where t.fec = lc_frep
                                 and t.cor = lc_corr
                                 and t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag desc) g
                       where rownum = 1;
                    exception
                       when others then null;
                    end;
                  else
                    begin
                    
                      -- Obter número de cuotas
                      select count(*)
                        into ln_ncuo
                        from jaqz520_601c t
                       where t.fec = lc_frep5
                         and t.cor = lc_corr5
                         and t.pgcod = pn_cod
                         and t.ppmod = pn_mod
                         and t.ppsuc = lx_suc
                         and t.ppmda = pn_mda
                         and t.pppap = pn_pap
                         and t.ppcta = pn_cta
                         and t.ppoper = pn_ope
                         and t.ppsbop = lx_sbop
                         and t.pptope = lx_tope;
                    
                      -- Obtener primera fecha del crédito reprogramado
                      select g.ppfpag
                        into ln_fpri
                        from (select t.ppfpag
                                from jaqz520_601c t
                               where t.fec = lc_frep5
                                 and t.cor = lc_corr5
                                 and t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag asc) g
                       where rownum = 1;
                    
                      -- Obtener fecha de fin del crédito reprogramado
                      select g.ppfpag
                        into ln_fult
                        from (select t.ppfpag
                                from jaqz520_601c t
                               where t.fec = lc_frep5
                                 and t.cor = lc_corr5
                                 and t.pgcod = pn_cod
                                 and t.ppmod = pn_mod
                                 and t.ppsuc = lx_suc
                                 and t.ppmda = pn_mda
                                 and t.pppap = pn_pap
                                 and t.ppcta = pn_cta
                                 and t.ppoper = pn_ope
                                 and t.ppsbop = lx_sbop
                                 and t.pptope = lx_tope
                               order by t.ppfpag desc) g
                       where rownum = 1;
                    exception
                       when others then null;
                    end;
                  end if;
                exception
                  when others then null;
                end;
              
              end if;
            
          --when pn_tabla = 'JAQZ255' then
          --  lx_exis := 1;
          end case;
        
          --********---
        else
          ln_peri := 0;
          ln_ncuo := 0;
          ln_fpri := null;
          ln_fult := null;
        end if;
      
      else
        ln_flag  := 'NO';
        ln_nrep  := 0;
        ln_fech  := null;
        ln_tabla := null;
        ln_peri  := 0;
        ln_ncuo  := 0;
        ln_fpri  := null;
        ln_fult  := null;
      end if;
    end if;
    begin
      select type_repro_datos(ln_flag,
                              ln_nrep,
                              ln_fech,
                              substr(ln_tabla, 1, 20),
                              ln_peri,
                              ln_ncuo,
                              ln_fpri,
                              ln_fult)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -----------------------------------------------------------------
  function fn_get_analista_credito(v_Scmod  in number,
                                   v_Scsuc  in number,
                                   v_Scmda  in number,
                                   v_Scpap  in number,
                                   v_Sccta  in number,
                                   v_Scoper in number,
                                   v_Scsbop in number,
                                   v_Sctope in number)
    return type_table_analista is
    t_resp       type_table_analista;
    lc_analista  char(10);
    ln_instancia number(10);
    ln_lote      fpp175.pp174cod%type;
  
  begin
  
    --para prendario nombre del tasador
    if (v_Scmod = 108) then
      begin
        SELECT max(pp174cod)
          into ln_lote
          FROM fpp175 d
         where
        --d.pp173cod = 1
         d.pp175suc = v_Scsuc
         and d.pp175mda = v_Scmda
         and d.pp175pap = v_Scpap
         and d.pp175cta = v_Sccta
         and d.pp175oper = v_Scoper
         and d.pp175sbop = v_Scsbop
         and d.pp175mod = v_Scmod
         and d.pp175tope = v_Sctope;
      exception
        when no_data_found then
          ln_lote := null;
      end;
    
      begin
        select max(substr(pp178dtext, 1, 10))
          into lc_analista
          from fpp178
         where pp174cod = ln_lote
           and pp177codd = 7;
      exception
        when no_data_found then
          lc_analista := null;
      end;
    else
      If v_Scmod = 116 THEN
        Begin
          select max(xw2.xwfprcins)
            into ln_instancia
            From Fsr011 rel
            join xwf700 xw2
              on xw2.xwfempresa = rel.r2cod
             and xw2.xwfmodulo = rel.r2mod
             and xw2.xwfsucursal = rel.r2suc
             and xw2.xwfmoneda = rel.r2mda
             and xw2.xwfpapel = rel.r2pap
             and xw2.xwfcuenta = rel.r2cta
             and xw2.xwfoperacion = rel.r2oper
             and xw2.xwfsubope = rel.r2sbop
             and xw2.xwftipope = rel.r2tope
             and rel.relcod = 46
             and xw2.xwfcar3 = '1'
           where rel.r1cod = 1
             and rel.r1mod = v_Scmod
             and rel.r1suc = v_Scsuc
             and rel.r1mda = v_Scmda
             and rel.r1pap = v_Scpap
             and rel.r1cta = v_Sccta
             and rel.r1oper = v_Scoper
             and rel.r1sbop = v_Scsbop
             and rel.r1tope = v_Sctope;
          If nvl(ln_instancia, 0) = 0 Then
            Begin
              select max(xw2.xwfprcins)
                into ln_instancia
                From Fsr011 rel
                join xwf700 xw2
                  on xw2.xwfempresa = rel.r2cod
                 and xw2.xwfmodulo = rel.r2mod
                 and xw2.xwfsucursal = rel.r2suc
                 and xw2.xwfmoneda = rel.r2mda
                 and xw2.xwfpapel = rel.r2pap
                 and xw2.xwfcuenta = rel.r2cta
                 and xw2.xwfoperacion = rel.r2oper
                 and xw2.xwfsubope = rel.r2sbop
                 and xw2.xwftipope = rel.r2tope
                 and rel.relcod = 46
               where rel.r1cod = 1
                 and rel.r1mod = v_Scmod
                 and rel.r1suc = v_Scsuc
                 and rel.r1mda = v_Scmda
                 and rel.r1pap = v_Scpap
                 and rel.r1cta = v_Sccta
                 and rel.r1oper = v_Scoper
                 and rel.r1tope = v_Sctope;
            exception
                 when others then null;
            End;
          End IF;
        exception
          when others then null;
        End;
      
      Else
        Begin
          select xw2.xwfprcins
            into ln_instancia
            from xwf700 xw2
           where xw2.xwfempresa = 1
             and xw2.xwfsucursal = v_Scsuc
             and xw2.xwfmodulo = v_Scmod
             and xw2.xwfmoneda = v_Scmda
             and xw2.xwfpapel = v_Scpap
             and xw2.xwfcuenta = v_Sccta
             and xw2.xwfoperacion = v_Scoper
             and xw2.xwfsubope = v_Scsbop
             and xw2.xwftipope = v_Sctope
             and xw2.xwfcar3 = '1';
        Exception
          When Others Then
            If v_Scmod in (200, 33) or v_Sctope = 550 Then
              Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  from xwf700 xw2
                 where xw2.xwfempresa = 1
                   and xw2.xwfsucursal = v_Scsuc
                   and xw2.xwfmoneda = v_Scmda
                   and xw2.xwfpapel = v_Scpap
                   and xw2.xwfcuenta = v_Sccta
                   and xw2.xwfoperacion = v_Scoper;
              exception
                    when others then null;
              end;
            Else
            
              Begin
                select xw2.xwfprcins
                  into ln_instancia
                  from xwf700 xw2
                 where xw2.xwfempresa = 1
                   and xw2.xwfsucursal = v_Scsuc
                   and xw2.xwfmodulo = v_Scmod
                   and xw2.xwfmoneda = v_Scmda
                   and xw2.xwfpapel = v_Scpap
                   and xw2.xwfcuenta = v_Sccta
                   and xw2.xwfoperacion = v_Scoper
                   and xw2.xwftipope = v_Sctope
                   and xw2.xwfcar3 = '1';
              Exception
                When Others Then
                  begin
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      from xwf700 xw2
                     where xw2.xwfempresa = 1
                       and xw2.xwfsucursal = v_Scsuc
                       and xw2.xwfmodulo = v_Scmod
                       and xw2.xwfmoneda = v_Scmda
                       and xw2.xwfpapel = v_Scpap
                       and xw2.xwfcuenta = v_Sccta
                       and xw2.xwfoperacion = v_Scoper
                       and xw2.xwftipope = v_Sctope
                       and xw2.xwfcar3 = '1';
                  exception
                       when others then null;
                  end;
              End;
            End IF;
        End;
      
        --2015.11.23 cuando instancia es 0 verificar si es judicial
        if nvl(ln_instancia, 0) = 0 and v_Scmod in (200, 33) then
          begin
            select max(xw2.xwfprcins)
              into ln_instancia
              From Fsr011 rel
              join xwf700 xw2
                on xw2.xwfempresa = rel.r2cod
               and xw2.xwfmodulo = rel.r2mod
               and xw2.xwfsucursal = rel.r2suc
               and xw2.xwfmoneda = rel.r2mda
               and xw2.xwfpapel = rel.r2pap
               and xw2.xwfcuenta = rel.r2cta
               and xw2.xwfoperacion = rel.r2oper
               and xw2.xwfsubope = rel.r2sbop
               and xw2.xwftipope = rel.r2tope
               and rel.relcod = 46
               and xw2.xwfcar3 = '1'
             where rel.r1cod = 1
               and rel.r1mod = v_Scmod
               and rel.r1suc = v_Scsuc
               and rel.r1mda = v_Scmda
               and rel.r1pap = v_Scpap
               and rel.r1cta = v_Sccta
               and rel.r1oper = v_Scoper
               and rel.r1sbop = v_Scsbop
               and rel.r1tope = v_Sctope;
            --2016.08.09        
            if nvl(ln_instancia, 0) = 0 then
              begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel
                  join xwf700 xw2
                    on xw2.xwfempresa = rel.r2cod
                   and xw2.xwfmodulo = rel.r2mod
                   and xw2.xwfsucursal = rel.r2suc
                   and xw2.xwfmoneda = rel.r2mda
                   and xw2.xwfpapel = rel.r2pap
                   and xw2.xwfcuenta = rel.r2cta
                   and xw2.xwfoperacion = rel.r2oper
                   and xw2.xwfsubope = rel.r2sbop
                   and xw2.xwftipope = rel.r2tope
                   and rel.relcod = 46
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper = v_Scoper
                   and rel.r1sbop = v_Scsbop
                   and rel.r1tope = v_Sctope;
              exception
                when no_Data_found then
                  ln_instancia := 0;
              end;
            end if;
          exception
            when others then null;
          end;
          --2016.08.09   
        
        end if;
        --2015.11.23
      
      End IF;
      if nvl(ln_instancia, 0) = 0 then
        Begin
          select max(xw2.xwfprcins)
            into ln_instancia
            from xwf700 xw2
           where xw2.xwfempresa = 1
             and xw2.xwfsucursal = v_Scsuc
             and xw2.xwfmoneda = v_Scmda
             and xw2.xwfpapel = v_Scpap
             and xw2.xwfcuenta = v_Sccta
             and xw2.xwfoperacion = v_Scoper;
        exception
            when others then null;
        end;
      end if;
    
      If ln_instancia is not null then
        Begin
          select sng001ase
            into lc_analista
            from sng001 --Cambiar la tabla para producción
           where sng001inst = ln_instancia;
        Exception
          when no_data_found then
            lc_analista := null;
        end;
      End If;
    
    end if;
    begin
      select type_analista(lc_analista) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_fcamb_estado(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pd_fecha in date) return type_table_tfcest is
    t_resp          type_table_tfcest;
    ld_fechenvjudic date;
    ld_firl         date;
    ld_fcas         date;
    pd_fcest        date;
    pn_tasa         number;
    ln_estado       number;
    lc_ABOGADO      varchar2(50);
    
  begin
    pn_tasa := 0;
    begin
      BEGIN
        select max(g4.sng410fecg) -- 2015.07
          into ld_firl
          from sng410 g4
         where g4.sng410mda = pn_mda
           and g4.sng410pap = 0
           and g4.sng410cta = pn_cta
           and g4.sng410op = pn_ope
           and g4.sng400evto in (1101, 1100)
           and g4.sng410its <> 999;
      exception
        when others then
          NULL;
      end;
    
      if ld_firl is null then
        BEGIN
          select y514.jaqy514fec
            into ld_firl
            from jaqy514 Y514
           where y514.jaqy514pgc = 1
             and y514.jaqy514pap = 0
             and y514.jaqy514mda = pn_mda
             and y514.jaqy514suc = pn_suc
             and y514.jaqy514cta = pn_cta
             and y514.jaqy514ope = pn_ope
             and y514.jaqy514evt in (1101, 1100)
             and y514.jaqy514its <> 999;
        exception
          when others then
            ld_firl := to_date('01/01/0001', 'DD/MM/YYYY');
          
        end;
      end if;
    exception
        when others then null;
    end;
    
    if ld_firl is null or ld_firl = to_date('01/01/0001', 'DD/MM/YYYY') then  ---2024.09.13 dcastro
      
        begin
          select f.aostat
            into ln_estado
            from fsd010 f
           where f.pgcod = pn_cod
             and f.aomod = pn_mod
             and f.aosuc = pn_suc
             and f.aomda = pn_mda
             and f.aopap = 0
             and f.aocta = pn_cta
             and f.aooper = pn_ope
             and f.aosbop = pn_sbo
             and f.aotope = pn_top ;
        exception when others then
                  ln_estado := 0;
        end;  
    
        begin
          PQ_CR_jaql964_cartera.sp_cr_abogado(P_N_PGCOD => pn_cod,
                                             P_N_MONEDA => pn_mda,
                                             P_N_PAPEL =>  pn_pap,
                                             P_N_CUENTA => pn_cta,
                                             P_N_OPERACION => pn_ope,
                                             P_N_MODULO => pn_mod,
                                             P_N_SUCURSAL => pn_suc,
                                             P_N_SUBOPER => pn_sbo,
                                             P_N_TIPOPER => pn_top,
                                             P_N_ESTADO => ln_ESTADO,
                                             P_C_ABOGADO => lc_ABOGADO,
                                             pf_asig => ld_firl);
        end;
      
    end if;

    
    begin
      select j.JAQL166SCFVL
       into ld_fechenvjudic
       from jaql166 j 
        Where jaql166scope = pn_cta
        and jaql166sccta = pn_ope
        and d166mo = 300 and d166tr = 400 ; 
      exception when others then
        ld_fechenvjudic := to_date('01/01/0001', 'DD/MM/YYYY');
     end;
    
    
    begin
      select t1.jaql175fca
        into ld_fcas
        from jaql175 t1
       where t1.jaql175emp = 1
         and t1.jaql175cta = pn_cta
         and t1.jaql175ope = pn_ope
         and rownum <= 1;
    exception
      when others then
        ld_fcas := to_date('01/01/0001', 'DD/MM/YYYY');
    end;
    if ld_fechenvjudic > ld_firl then
      if ld_fechenvjudic > ld_fcas then
        pd_fcest := ld_fechenvjudic;
      else
        pd_fcest := ld_fcas;
      end if;
    else
      if ld_firl > ld_fcas then
        pd_fcest := ld_firl;
      else
        pd_fcest := ld_fcas;
      end if;
    end if;
    begin
    
      select f1.evtasa
        into pn_tasa
        from fsd012 f1
       where f1.pgcod = pn_cod
         and f1.aomod = pn_mod
         and f1.aosuc = pn_suc
         and f1.aomda = pn_mda
         and f1.aopap = pn_pap
         and f1.aocta = pn_cta
         and f1.aooper = pn_ope
         and f1.aosbop = pn_sbo
         and f1.aotope = pn_top
         and f1.evtipo = 4
         and f1.d012co = 'S'
         and f1.evcorr in (select max(f2.evcorr)
                             from fsd012 f2
                            where f2.pgcod = f1.pgcod
                              and f2.aomod = f1.aomod
                              and f2.aosuc = f1.aosuc
                              and f2.aomda = f1.aomda
                              and f2.aopap = f1.aopap
                              and f2.aocta = f1.aocta
                              and f2.aooper = f1.aooper
                              and f2.aosbop = f1.aosbop
                              and f2.aotope = f1.aotope
                              and f2.evtipo = 4
                              and f2.d012co = 'S'
                           --and f2.evfval < pd_fecha
                           );
    
    exception
      when others then
        ---lx_fdes := null;
      
        begin
        
          SELECT t.aotasa
            into pn_tasa
            FROM fsd010 t
           where t.pgcod = pn_cod
             and t.aomod = pn_mod
             and t.aosuc = pn_suc
             and t.aomda = pn_mda
             and t.aopap = pn_pap
             and t.aocta = pn_cta
             and t.aooper = pn_ope
             and t.aosbop = pn_sbo
             and t.aotope = pn_top;
        
        exception
          when others then
            pn_tasa := 0;
        end;
      
    end;
    begin
      select type_tfcest(pd_fcest, pn_tasa)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_tea_repro(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_tea_rep is
    ln_tear number;
    t_resp  type_table_tea_rep;
  begin
    begin
    
      select f1.evtasa
        into ln_tear
        from fsd012 f1
       where f1.pgcod = pn_cod
         and f1.aomod = pn_mod
         and f1.aosuc = pn_suc
         and f1.aomda = pn_mda
         and f1.aopap = pn_pap
         and f1.aocta = pn_cta
         and f1.aooper = pn_ope
         and f1.aosbop = pn_sbo
         and f1.aotope = pn_top
         and f1.evtipo = 3
         and f1.evttas = 1
         and f1.d012co = 'S'
         and f1.evcorr in (select max(f2.evcorr)
                             from fsd012 f2
                            where f2.pgcod = f1.pgcod
                              and f2.aomod = f1.aomod
                              and f2.aosuc = f1.aosuc
                              and f2.aomda = f1.aomda
                              and f2.aopap = f1.aopap
                              and f2.aocta = f1.aocta
                              and f2.aooper = f1.aooper
                              and f2.aosbop = f1.aosbop
                              and f2.aotope = f1.aotope
                              and f2.evtipo = 3
                              and f1.evttas = 1
                              and f2.d012co = 'S'
                           --and f2.evfval < pn_fecha
                           );
    
    exception
      when others then
        ---lx_fdes := null;
      
        begin
        
          SELECT t.aotasa
            into ln_tear
            FROM fsd010 t
           where t.pgcod = pn_cod
             and t.aomod = pn_mod
             and t.aosuc = pn_suc
             and t.aomda = pn_mda
             and t.aopap = pn_pap
             and t.aocta = pn_cta
             and t.aooper = pn_ope
             and t.aosbop = pn_sbo
             and t.aotope = pn_top;
        
        exception
          when others then
            ln_tear := 0;
        end;
      
    end;
    begin
      select type_tea_rep(ln_tear) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_saldos(pn_cod   in number,
                         pn_mod   in number,
                         pn_suc   in number,
                         pn_mda   in number,
                         pn_pap   in number,
                         pn_cta   in number,
                         pn_ope   in number,
                         pn_sbo   in number,
                         pn_top   in number,
                         pd_fecha in date) return type_table_saldos is
    t_resp     type_table_saldos;
    ln_saldo   number(17, 2);
    ln_saldo_c number(17, 2);
    lx_imp     number(17, 2);
    ld_fecha   date;
  
  begin
    ln_saldo   := 0;
    ln_saldo_c := 0;
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
  
    if ld_fecha <> pd_fecha then
    
      begin
      
        select (t.bcsdmn * -1)
          into ln_saldo
          from fsh012 t
         where t.bcemp = pn_cod
           and t.bcsuc = pn_suc
           and t.bcmda = pn_mda
           and t.bcpap = pn_pap
           and t.bccta = pn_cta
           and t.bcoper = pn_ope
           and t.bctop = pn_top
           and t.bcmod = pn_mod
              --and t.bcsbop = pn_sbo           
           and t.bcfech = pd_fecha;
      
      exception
        when others then
          ln_saldo := 0;
      end;
    
    else
      begin
      
        select sum(t.scsdo) * -1
          into ln_saldo
          from fsd011 t
         where t.pgcod = pn_cod
           and t.scmod = pn_mod
           and t.scsuc = pn_suc
           and t.scmda = pn_mda
           and t.scpap = pn_pap
           and t.sccta = pn_cta
           and t.scoper = pn_ope
           and t.scsbop = pn_sbo
           and t.sctope = pn_top;
      exception
        when others then
          ln_saldo := 0;
      end;
    
    end if;
  
    if ln_saldo < 0 or ln_saldo is null then
      ln_saldo := 0;
    end if;
    -- 1. Obtención de AOIMP
    begin
      select t.aoimp
        into lx_imp
        from fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
         and t.aosuc = pn_suc
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
         and t.aosbop = pn_sbo
         and t.aotope = pn_top
            
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
    exception
      when others then
        lx_imp := 0;
    end;
    ln_saldo_c := lx_imp - ln_saldo; --- ES RESTA!!!
  
    if ln_saldo_c < 0 then
      ln_saldo_c := 0;
    end if;
    begin
      select type_saldos(ln_saldo, ln_saldo_c)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_pergracia(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_per_gr is
    t_resp type_table_per_gr;
  
    lx_resp  number(8);
    lx_fpri  date;
    lx_fvlor date;
    lx_peri  number(5);
  
  begin
    --Fórmula:X054032(XLLAOCNTP) * X054023(xllperiodo)
  
    begin
    
      begin
        select min(x.ppfpag)
          into lx_fpri
          from fsd601 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.d601co = 'S'
           and not exists (select 'X'
                  from fsd012 y
                 where y.pgcod = x.pgcod
                   and y.aomod = x.ppmod
                   and y.aosuc = x.ppsuc
                   and y.aomda = x.ppmda
                   and y.aopap = x.pppap
                   and y.aocta = x.ppcta
                   and y.aooper = x.ppoper
                   and y.aosbop = x.ppsbop
                   and y.aotope = x.pptope
                   and y.d012mo = x.d601mo
                   and y.d012su = x.d601su
                   and y.d012tr = x.d601tr
                   and y.d012re = x.d601re
                   and y.d012fc = x.d601fc
                   and y.evtipo = 50
                   and y.d012co = 'S'); ---se agrego CONDICION PARA EXCLUIR CUOTA AMORTIZABLE
      
      exception
        when others then
          lx_fpri := null;
      end;
    
      lx_resp := 0;
    
      if lx_fpri is not null then
      
        begin
          select t.xllfvalor, t.xllperiodo
            into lx_fvlor, lx_peri
            from X054023 t
           where t.xllpgcod = pn_cod
             and t.xllaomod = pn_mod
             and t.xllaosuc = pn_suc
             and t.xllaomda = pn_mda
             and t.xllaopap = pn_pap
             and t.xllaocta = pn_cta
             and t.xllaooper = pn_ope
             and t.xllaosbop = pn_sbo
             and t.xllaotop = pn_top;
        exception
          when others then
            lx_fvlor := null;
            lx_peri  := 0;
        end;
      
        if lx_peri = 0 then
          lx_resp := 0;
        else
          lx_resp := (lx_fpri - lx_fvlor) - lx_peri;
        end if;
      
        if lx_resp <= 0 then
          lx_resp := 0;
        end if;
      
      end if;
    
    exception
      when others then
        lx_resp := 0;
    end;
  
    begin
      select type_per_gr(lx_resp) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_pergracia_imp(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pd_fecha in date) return type_table_per_gr is
    t_resp type_table_per_gr;
  
    lx_resp  number(8);
    lx_fpri  date;
    lx_fvlor date;
    lx_peri  number(5);
  
  begin
    --Fórmula:X054032(XLLAOCNTP) * X054023(xllperiodo)
  
    begin
    
      begin
        select min(x.ppfpag)
          into lx_fpri
          from fsd601 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.d601co = 'S'
           and x.ppcap > 0
           and not exists (select 'X'
                  from fsd012 y
                 where y.pgcod = x.pgcod
                   and y.aomod = x.ppmod
                   and y.aosuc = x.ppsuc
                   and y.aomda = x.ppmda
                   and y.aopap = x.pppap
                   and y.aocta = x.ppcta
                   and y.aooper = x.ppoper
                   and y.aosbop = x.ppsbop
                   and y.aotope = x.pptope
                   and y.d012mo = x.d601mo
                   and y.d012su = x.d601su
                   and y.d012tr = x.d601tr
                   and y.d012re = x.d601re
                   and y.d012fc = x.d601fc
                   and y.evtipo = 50
                   and y.d012co = 'S'); ---se agrego CONDICION PARA EXCLUIR CUOTA AMORTIZABLE
      
      exception
        when others then
          lx_fpri := null;
      end;
    
      lx_resp := 0;
    
      if lx_fpri is not null then
      
        begin
          select t.xllfvalor, t.xllperiodo
            into lx_fvlor, lx_peri
            from X054023 t
           where t.xllpgcod = pn_cod
             and t.xllaomod = pn_mod
             and t.xllaosuc = pn_suc
             and t.xllaomda = pn_mda
             and t.xllaopap = pn_pap
             and t.xllaocta = pn_cta
             and t.xllaooper = pn_ope
             and t.xllaosbop = pn_sbo
             and t.xllaotop = pn_top;
        exception
          when others then
            lx_fvlor := null;
            lx_peri  := 0;
        end;
      
        if lx_peri = 0 then
          lx_resp := 0;
        else
          lx_resp := (lx_fpri - lx_fvlor) - lx_peri;
        end if;
      
        if lx_resp <= 0 then
          lx_resp := 0;
        end if;
      
      end if;
    
    exception
      when others then
        lx_resp := 0;
    end;
  
    begin
      select type_per_gr(lx_resp) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  -------------------------------------------------------------------------
  function fn_get_otros_repfondos(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pd_fecha in date,
                                  pn_indi  in number)
    return type_table_otros_repfondos is
    /* procedimiento para calcular 
            'Saldo Insoluto antes del prepago';
            'Prepago(Total/Parcial)(Total=cancelacion, Parcial=amortizacion)';
            'Pago realizado (Pago total)';
            'Principal amortizado';
            'Numero de cuotas del cronograma original enviado a COFIDE';
            'Numero de cuotas de cronograma actual';
            'Valor de la ultima cuota pagada';
            'Valor de cuota proximo vencimiento';
            'Nueva fecha de la ultima cuota luego del prepago';
            'Interes compensatorios';
            'Intereses compensatorios vencidos';
            'Interes moratorio';
            'Penalidad';
            'Ruc de Certificacion';
            'Monto Reprogramado';
            'Tasa de interes de la reprogramacion';
    */
    t_resp type_table_otros_repfondos;
  
    lc_cuo_n       number;
    lc_cuo_o       number;
    lc_fmant       date;
    lc_sdoins_mant number(17, 2);
    lc_prpago      number(17, 2);
    lc_pagrea      number(17, 2);
    lc_pramrt      number(17, 2);
    lc_vulcpa      number(17, 2);
    lc_vcprve      number(17, 2);
    lc_fuclpr      date;
    lc_intcom      number(17, 2);
    lc_intcov      number(17, 2);
    lc_intmor      number(17, 2);
    lc_penali      number(17, 2);
    lc_gasm        number(17, 2);
    lc_morm        number(17, 2);
    lc_intm        number(17, 2);
    lc_icvm        number(17, 2);
    lc_penm        number(17, 2);
    lc_tsumm       number(17, 2);
    lc_capm        number(17, 2);
    lc_rucc        char(12);
    lc_monrep      number(17, 2);
    lc_tintre      number(10, 4);
  
    lx_sbop  number;
    lc_flag  number;
    lx_imp   number(17, 2);
    lx_cd    number(3);
    lx_mo    number(3);
    lx_su    number(3);
    lx_tr    number(3);
    lx_re    number(4);
    lx_fc    date;
    lx_fecha date;
  
    lc_ppfpag     date;
    lc_pp1nump    number(9);
    lc_pp1nump_mx number(9);
    lc_pp1nump_mn number(9);
    lc_fini       date;
    lc_gas        number;
    lc_mor        number;
    lc_icv        number;
    lc_cuo        number;
    lc_int        number;
    lc_pen        number;
    ld_fecha_ucuo date;
    ld_fecham_456 date;
    
    lx_fecha2     date;
    ld_fPAg1      DATE;
    ld_ppfpag     date;
    ln_pp1nump    number;
  
  begin
    -- nro cuotas origen
    begin
    
      select /*+index(t FSD60103)*/count(*)
        into lc_cuo_o
        from FSD601 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S';
    
    exception
      when others then
        lc_cuo_o := 0;
    end;
    --nro cuotas actual cronograma
    begin
      begin
      select x.tp1nro1
        into lc_flag
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 1;
      exception when others then null;
        end;
      begin
      select max(t.aosbop)
        into lx_sbop
        from fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
            --and t.aomod <> 419 --  jrodriguej 28.06.2021
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
      exception when others then null;
        end;
      if lc_flag = 0 then
      
        select count(*)
          into lc_cuo_n
          from FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = lx_sbop
              --and t.pptope = m.aotope
           and t.d601Co = 'S'
           and t.ppcap >0;
      
        -----
      else
        select count(*)
          into lc_cuo_n
          from FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = lx_sbop
              --and t.pptope = m.aotope
           and t.d601Co = 'S'
           and (t.pgcod, t.ppmod, t.ppsuc, t.ppmda, t.pppap, t.ppcta,
                t.ppoper, t.ppsbop, t.pptope, t.ppfpag) not in
               (SELECT u.pgcod,
                       u.aomod,
                       u.aosuc,
                       u.aomda,
                       u.aopap,
                       u.aocta,
                       u.aooper,
                       u.aosbop,
                       u.aotope,
                       u.evfval
                  FROM FSD012 u
                 where u.pgcod = pn_cod
                   and u.aomod = pn_mod
                   and u.aosuc = pn_suc
                   and u.aomda = pn_mda
                   and u.aopap = pn_pap
                   and u.aocta = pn_cta
                   and u.aooper = pn_ope
                   and u.aosbop = lx_sbop
                   and u.aotope = pn_top
                   and u.d012co = 'S'
                   and u.evtipo = 50);
      end if;
    exception
      when others then
        lc_cuo_n := 0;
    end;
    --- m preppago
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
    begin
      begin
      select f.d012cd, f.d012mo, f.d012su, f.d012tr, f.d012re, f.d012fc
        into lx_cd, lx_mo, lx_su, lx_tr, lx_re, lx_fc
        from (select t.d012cd,
                     t.d012mo,
                     t.d012su,
                     t.d012tr,
                     t.d012re,
                     t.d012fc
              
                from fsd012 t
               where t.pgcod = pn_cod
                 and t.aomod = pn_mod
                    --and t.aosuc = pn_suc --  jrodriguej 28.06.2021
                         and t.aosuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
                 and t.aomda = pn_mda
                 and t.aopap = pn_pap
                 and t.aocta = pn_cta
                 and t.aooper = pn_ope
                    --and t.aosbop = pn_sbo
                    --and t.aotope = pn_top   dcastro 24.09.2021
                 and t.evtipo = 50
                 and t.d012co = 'S'
                 and t.d012fc <= pd_fecha
               order by t.d012fc desc) f
       where rownum = 1;
      exception when others then null;
      end;
      --if lx_fecha <> pn_fecha then
      if lx_fc <> pd_fecha then
        begin
        select t.hcimp1
          into lc_prpago
          from fsh016 t
         where t.pgcod = lx_cd
           and t.hcmod = lx_mo
           and t.hsucor = lx_su
           and t.htran = lx_tr
           and t.hnrel = lx_re
           and t.hfcon = lx_fc
           and t.hcord = 83;
        exception when others then null;
        end;
      else
        begin
        select t.itimp1
          into lc_prpago
          from fsd016 t
         where t.pgcod = lx_cd
           and t.itmod = lx_mo
           and t.itsuc = lx_su
           and t.ittran = lx_tr
           and t.itnrel = lx_re
              --and t.itfval = lx_fc
           and t.itord = 83;
        exception when others then null;
        end;
      end if;
    
    exception
      when others then
        lc_prpago := 0;
    end;
    -- pago realizado y amortizacion
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
  
    begin
    
      select /*+index(t SYS_C00978743)*/ max(t.pp1nump), min(t.pp1nump)
        into lc_pp1nump_mx, lc_pp1nump_mn
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha
         and t.pp1cap > 0
         and t.d602co = 'S';
    exception
      when others then
        lc_pp1nump_mx := null;
        lc_pp1nump_mn := null;
    end;
  
    if lc_pp1nump_mx is not null then
    
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0),nvl(sum(case when t.pp1cap > 0 then t.pp1cap else 0 end), 0)
          into lc_cuo, lc_int,lc_pramrt
        
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S';
      
      exception
        when others then
          lc_cuo := 0;
          lc_int := 0;
          lc_pramrt :=0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd612 x, FSD602 t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp1nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp1nump >= lc_pp1nump_mn
           and x.pp1nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into lc_pen
          from fpp003 x, FSD602 t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp003nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp003nump >= lc_pp1nump_mn
           and x.pp003nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          lc_pen := 0;
      end;
    
    else
      lc_gas := 0;
      lc_mor := 0;
      lc_int := 0;
      lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
    end if;
  
    lc_pagrea := (lc_gas + lc_mor + lc_int + lc_cuo + lc_icv + lc_pen);
    --lc_pramrt := lc_cuo;
    -- valor cuotas ultima y proxima y fecha ultimo
    begin
      select pp1fech, pp1int + pp1cap,ppfpag
        into ld_fecha_ucuo, lc_vulcpa,ld_fpag1
        from (select pp1fech, pp1int, case when pp1cap > 0  then pp1cap else 0 end pp1cap,ppfpag
                from fsd602 a
               where a.pgcod = pn_cod
                 and a.ppmod = pn_mod
                 and a.ppsuc = pn_suc
                 and a.ppmda = pn_mda
                 and a.pppap = pn_pap
                 and a.ppcta = pn_cta
                 and a.ppoper = pn_ope
                 and a.ppsbop = pn_sbo
                 and a.pptope = pn_top
                 and a.pp1stat = 'T'
                 and a.d602co = 'S'
                 and a.d602fc <= pd_fecha
               order by pp1fech desc,pp1nump desc)
       where rownum = 1;
    exception
      when others then
        ld_fecha_ucuo := null;
        lc_vulcpa     := 0;
    end;
      lc_gas := 0;
      lc_mor := 0;
      --lc_int := 0;
      --lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
      begin
    
        select f.ppfpag, f.pp1nump
          into ld_ppfpag, ln_pp1nump
          from (select t.ppfpag, t.pp1nump
                  from fsd602 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.pp1stat in ('P', 'T')
                   and t.d602fc <= pd_fecha
                   and t.d602co = 'S'
                 order by t.pp1nump desc) f
         where rownum = 1;
      exception
        when others then
          ld_ppfpag  := null;
          ln_pp1nump := null;
      end;
    -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd612 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp1nump <= lc_pp1nump;
           and x.pp1nump = ln_pp1nump
           and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
    
      --- Penalidad
      begin
        select sum(nvl(x.pp003imp, 0))
          into lc_pen
          from fpp003 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp003nump <= lc_pp1nump;
           and x.pp003nump = ln_pp1nump
           --and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          lc_pen := 0;
      end;
    lc_vulcpa := nvl(lc_vulcpa,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0) + nvl(lc_pen,0); 
    
    lc_vcprve := 0;
    lc_gas := 0;
      lc_mor := 0;
      --lc_int := 0;
      --lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
      
    if ld_fecha_ucuo is not null then
      begin
        select ppfpag, ppcap + ppint
          into lc_fuclpr, lc_vcprve
          from (select ppfpag, ppcap, ppint
                  from FSD601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.d601co = 'S'
                   and t.ppcap >0
                   and t.ppfpag > ld_fecha_ucuo
                   AND t.ppfpag > ld_fpag1
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          lc_vcprve := 0;
          lc_fuclpr := null;
      end;
      begin
       select /*+index(x SYS_C00980155)*/nvl(sum(x.ppimp2), 0), --- mora
               nvl(sum(x.ppimp3), 0), --- icv
               nvl(sum(x.ppimp11 + x.ppimp12 + x.ppimp13 + x.ppimp14 +
                       x.ppimp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd611 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              
           and x.ppfpag =  lc_fuclpr;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
      lc_vcprve := nvl(lc_vcprve,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0);
          
    else 
      begin
        select ppfpag, ppcap + ppint
          into lc_fuclpr, lc_vcprve
          from (select ppfpag, ppcap, ppint
                  from FSD601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.d601co = 'S'
                   and t.ppcap > 0
                   --and t.ppfpag > ld_fecha_ucuo
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          lc_vcprve := 0;
          lc_fuclpr := null;
      end;
      begin
       select /*+index(x SYS_C00980155)*/ nvl(sum(x.ppimp2), 0), --- mora
               nvl(sum(x.ppimp3), 0), --- icv
               nvl(sum(x.ppimp11 + x.ppimp12 + x.ppimp13 + x.ppimp14 +
                       x.ppimp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd611 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              
           and x.ppfpag =  lc_fuclpr;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
      lc_vcprve := nvl(lc_vcprve,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0);
    end if;
  
    -- intereses compensatorio moratotio icv penalidad
    /*begin
      select max(a.jaql964hfeh)
        into lx_fecha2
        from jaql964h a
       where a.jaql964hcta = pn_cta
         and a.jaql964hope = pn_ope;
    exception
      when others then
        lx_fecha2 := pd_fecha;
    end;*/
    lx_fecha2 := pd_fecha -1;
    begin
      select a.jaql964int, a.jaql964mor, a.jaql964icv, a.jaql964pen
        into lc_intcom, lc_intmor, lc_intcov, lc_penali
        from jaql964 a
       where a.jaql964cta = pn_cta
         and a.jaql964ope = pn_ope
         and rownum = 1;
    exception
      when others then
        begin
          select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
            into lc_intcom, lc_intmor, lc_intcov, lc_penali
            from jaql964h a
           where a.jaql964hfeh = lx_fecha2
             and a.jaql964hcta = pn_cta
             and a.jaql964hope = pn_ope;
        exception
          when others then
          begin
            select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
              into lc_intcom, lc_intmor, lc_intcov, lc_penali
              from jaql964h a
             where a.jaql964hfeh = lx_fecha2 -1
               and a.jaql964hcta = pn_cta
               and a.jaql964hope = pn_ope;
          exception
            when others then
              begin
                select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
                  into lc_intcom, lc_intmor, lc_intcov, lc_penali
                  from jaql964h a
                 where a.jaql964hfeh = lx_fecha2 -2
                   and a.jaql964hcta = pn_cta
                   and a.jaql964hope = pn_ope;
              exception
                when others then
                  lc_intcom := 0;
                  lc_intmor := 0;
                  lc_intcov := 0;
                  lc_penali := 0;
              end;
          end;
        end;
    end;
  
    -- ruc certificacion
    if (pn_indi = 1) then
      begin
        select aqpb456ndoc
          into lc_rucc
          from (select aqpb456fcar, aqpb456ndoc
                  from aqpb456
                 where aqpb456cta1 = pn_cta
                   --and aqpb456ind in ('FT1', 'FT2')
                 order by aqpb456fcar desc)
         where rownum = 1;
      exception
        when others then
          lc_rucc := '';
      end;
    else
      lc_rucc := '';
    end if;
    begin
      select type_otros_repfondos(lc_sdoins_mant,
                                  lc_prpago,
                                  lc_pagrea,
                                  lc_pramrt,
                                  lc_cuo_o,
                                  lc_cuo_n,
                                  lc_vulcpa,
                                  lc_vcprve,
                                  lc_fuclpr,
                                  lc_intcom,
                                  lc_intcov,
                                  lc_intmor,
                                  lc_penali,
                                  lc_rucc,
                                  0,
                                  0)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_fec_creorigen(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number) return type_table_fec_crorigen is
    t_resp type_table_fec_crorigen;
  
    lx_fini  date;
    lx_ffin  date;
  
  begin    
  
    begin
    
      select min(t.ppfval)  into lx_fini
        from FSD601 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S';
    
    exception
      when others then
        lx_fini := null;
    end;
    
    begin
    
      select max(t.ppfvTO)  into lx_ffin
        from FSD601 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S';
    
    exception
      when others then
        lx_ffin := null;
    end;
  
    begin
      select type_fec_crorigen(lx_fini,lx_ffin) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ----------------------------------------------------------------
  function fn_get_fec_creorigen2(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number) return type_table_fec_crorigen is
    t_resp type_table_fec_crorigen;
  
    lx_fini  date;
    lx_ffin  date;
  
  begin    
  
    begin
    
      select min(t.ppfvto)  into lx_fini
        from FSD601 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S'
         and t.ppcap > 0;
    
    exception
      when others then
        lx_fini := null;
    end;
    
    begin
    
      select max(t.ppfvTO)  into lx_ffin
        from FSD601 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S';
    
    exception
      when others then
        lx_ffin := null;
    end;
  
    begin
      select type_fec_crorigen(lx_fini,lx_ffin) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;
  ------------------------------------------------------------------------------       

 --------------------------------------------------------------------
  function fn_get_cuota_pagoT(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) return type_table_cuota_pago is
/* ************************************************************************************************************
    -- Nombre                     : fn_get_cuota_pagoT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna Total Cuotas Pagadas de Capital
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/07/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/
                            
    t_resp   type_table_cuota_pago;
    ln_cuopp number(10);
    ln_cuopa number(10);
    ld_fecha  date;
  begin
    ln_cuopp := 0;
    ln_cuopa := 0;

/*    -- numero total de cuotas pagadas totalmente
      begin
        select count(*)
          into ln_cuopp
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1stat = 'T'
           --and t.d602fc <= pd_fec
           and t.pp1fech <= pd_fec
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) in
               (select tp1nro2, tp1nro3
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10871
                   and tp1corr1 = 7
                   and tp1corr2 = 10
                   and tp1corr3 > 0);

      exception
        when others then
          ln_cuopp := 0;
      end;
      
    -- ultima fecha de cuota pagada totalmente
      begin
        select max(t.ppfpag)
          into ld_fecha
          from fsd602 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1stat = 'T'
           --and t.d602fc <= pd_fec
           and t.pp1fech <= pd_fec
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) in
               (select tp1nro2, tp1nro3
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10871
                   and tp1corr1 = 7
                   and tp1corr2 = 10
                   and tp1corr3 > 0);

      exception
        when others then
          ld_fecha := null;
      end;*/

    -- numero total de cuotas pagadas totalmente  2024.09.03
      begin
        select count(distinct t.ppfpag), max(t.ppfpag)   --- 2024.09.13 dcastro
          into ln_cuopp, ld_fecha
          from AQPC366D/*fsd602*/ t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1stat = 'T'
           --and t.d602fc <= pd_fec
           and t.pp1fech <= pd_fec
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) in
               (select tp1nro2, tp1nro3
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10871
                   and tp1corr1 = 7
                   and tp1corr2 = 10
                   and tp1corr3 > 0);

      exception
        when others then
          ln_cuopp := 0;
          ld_fecha := null;
      end;
      

      
      if ld_fecha is null then
         ln_cuopa := 0;
      else 
        -- Cuotas pagadas con capital
            begin
              select count(distinct t.ppfpag)
                    into ln_cuopa
                    from fsd601 t
                   where t.pgcod = pn_cod
                     and t.ppmod = pn_mod
                     and t.ppsuc = pn_suc
                     and t.ppmda = pn_mda
                     and t.pppap = pn_pap
                     and t.ppcta = pn_cta
                     and t.ppoper = pn_ope
                     and t.ppsbop = pn_sbo
                     and t.pptope = pn_top
                     and t.ppfpag <= pd_fec
                     and t.ppcap > 0;
            exception
              when others then
                ln_cuopa := 0;
            end; 
      end if;

    begin
      select type_cuota_pago(ln_cuopp, ln_cuopa )
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end  fn_get_cuota_pagoT;
  ----------------------------------------------------------------
function fn_get_calif_sbs_IMP(pn_tdoc in number,
                            pc_ndoc in char,
                            pd_fech in date) return type_table_calif_sbs is

/* ************************************************************************************************************
    -- Nombre                     : fn_get_calif_sbs_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna Calificacion SBS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/07/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/

                            
    t_resp       type_table_calif_sbs;
    ld_fecha_pro date;
    ld_fecha_rcc date;
    ln_nro_mes   number(3);
    lc_csbs      char(11);
    ln_calif0    number(5, 2);
    ln_calif1    number(5, 2);
    ln_calif2    number(5, 2);
    ln_calif3    number(5, 2);
    ln_calif4    number(5, 2);
    ln_dif       number(5, 2);
    
  begin
  
    --select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into ln_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        ln_nro_mes := 1;
    end;
  
    -- 2. Fecha RCC
    select to_date(t.tpnro, 'DDMMYY')
      into ld_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    if pd_fech <= ld_fecha_rcc then
      ld_fecha_pro := last_day(add_months(trunc(pd_fech), -1 * ln_nro_mes));
    else
      ld_fecha_pro := ld_fecha_rcc;
    end if;
  
    -- Verificar tipo de documento
    if pn_tdoc = 21 then
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into lc_csbs,
               ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4
          from cldrcci t
         where t.d_fecpre = ld_fecha_pro
           and t.c_tdocid = (select tp1nro2
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 11111
                                and tp1corr1 = 1
                                and tp1corr2 = 5
                                and tp1nro1 = pn_tdoc
                                and rownum = 1)
           and t.c_docide = trim(pc_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into lc_csbs,
                   ln_calif0,
                   ln_calif1,
                   ln_calif2,
                   ln_calif3,
                   ln_calif4
              from cldrcci t
             where t.d_fecpre = ld_fecha_pro
               and t.c_tdocid = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
               and t.c_docide = trim(pc_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              lc_csbs   := '0';
              ln_calif0 := 100;
              ln_calif1 := 0;
              ln_calif2 := 0;
              ln_calif3 := 0;
              ln_calif4 := 0;
          end;
        when no_data_found then
          lc_csbs   := '0';
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
          begin
            for i in 1 .. 18 loop
              begin
                select trim(t.c_codsbs)
                  into lc_csbs
                  from cldrcci t
                 where t.d_fecpre = add_months(ld_fecha_pro, -i)
                   and t.c_tdocid = (select tp1nro2
                                       from fst198
                                      where tp1cod = 1
                                        and tp1cod1 = 11111
                                        and tp1corr1 = 1
                                        and tp1corr2 = 5
                                        and tp1nro1 = pn_tdoc
                                        and rownum = 1)
                   and t.c_docide = trim(pc_ndoc)
                   and t.c_person = 1
                   and rownum = 1;
              exception
                when others then
                  lc_csbs := '0';
              end;
              EXIT WHEN lc_csbs <> '0';
            end loop;
          exception
            when others then
              lc_csbs := '0';
          end;
          --exception
        when others then
          lc_csbs   := '0';
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    
    else
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into lc_csbs,
               ln_calif0,
               ln_calif1,
               ln_calif2,
               ln_calif3,
               ln_calif4
          from cldrcci t
         where t.d_fecpre = ld_fecha_pro
           and t.c_tdoctr = (select tp1nro2
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 11111
                                and tp1corr1 = 1
                                and tp1corr2 = 5
                                and tp1nro1 = pn_tdoc
                                and rownum = 1)
           and t.c_doctri = trim(pc_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into lc_csbs,
                   ln_calif0,
                   ln_calif1,
                   ln_calif2,
                   ln_calif3,
                   ln_calif4
              from cldrcci t
             where t.d_fecpre = ld_fecha_pro
               and t.c_tdoctr = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
               and t.c_doctri = trim(pc_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              lc_csbs   := 0;
              ln_calif0 := 100;
              ln_calif1 := 0;
              ln_calif2 := 0;
              ln_calif3 := 0;
              ln_calif4 := 0;
          end;
        
        --exception
        when others then
          lc_csbs   := 0;
          ln_calif0 := 100;
          ln_calif1 := 0;
          ln_calif2 := 0;
          ln_calif3 := 0;
          ln_calif4 := 0;
      end;
    
    end if;
    
    --2024.07.19 dcastro validar porcentaje
    ln_dif := 100 - (ln_calif0 + ln_calif1 + ln_calif2 + ln_calif3 + ln_calif4); 
    if ln_dif <> 0 then --99 es menor al 100%
       if  ln_calif4 > 0 then ln_calif4 := ln_calif4 + ln_dif; 
         elsif  ln_calif3 > 0 then ln_calif3 := ln_calif3 + ln_dif; 
         elsif  ln_calif2 > 0 then ln_calif2 := ln_calif2 + ln_dif; 
         elsif  ln_calif1 > 0 then ln_calif1 := ln_calif1 + ln_dif; 
         elsif  ln_calif0 > 0 then ln_calif0 := ln_calif0 + ln_dif;               
       end if;
    end if;
    ---2024.07.19
    
    begin
      select type_calif_sbs(lc_csbs,
                            ln_calif0,
                            ln_calif1,
                            ln_calif2,
                            ln_calif3,
                            ln_calif4)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end;

 ------------------------------------------------------------------------
  function fn_get_distribuc_pago_IMP(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pd_fecha in date)
    return type_table_distrib_pago is                                 
/* ************************************************************************************************************
    -- Nombre                     : fn_get_distribuc_pago_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna Montos pagados de cuotas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/07/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/
                            

    t_resp  type_table_distrib_pago;
    ln_tsum number(17, 2);
    ln_gas  number(17, 2); -- seguridad
    ln_mor  number(17, 2); -- moratoria
    ln_int  number(17, 2); -- interés
    ln_cuo  number(17, 2); -- capital
    ln_icv  number(17, 2); -- interés compensatorio (icv)
    ln_pen  number(17, 2); -- penalidad
  
    ld_ppfpag  date;
    ln_pp1nump number(9);
    lc_fmant   date;
    lc_fini    date;
    lc_ppfpag     date;
    lc_pp1nump    number(9);
    lc_pp1nump_mx number(9);
    lc_pp1nump_mn number(9); 
       
  
  begin
    -- clave
    ln_tsum := 0;
    ln_gas  := 0;
    ln_mor  := 0;
    ln_int  := 0;
    ln_cuo  := 0;
    ln_icv  := 0;
    ln_pen  := 0;
    --fecha mes anterior
    lc_fmant := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')));
 
----/*---montos */
  -- pago realizado y amortizacion
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
  
    begin
    
      select /*+index(t SYS_C00978743)*/ max(t.pp1nump), min(t.pp1nump)
        into lc_pp1nump_mx, lc_pp1nump_mn
        from AQPC366D/*fsd602*/ t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
       --  and t.ppsuc = pn_suc
        and t.ppsuc in (select p.sucurs
                   from fst001 p
                  where p.pgcod = 1
                    and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         /*and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha*/
         and t.pp1fech >= lc_fini
         and t.pp1fech <= pd_fecha
         and t.pp1cap > 0
         and t.d602co = 'S';
    exception
      when others then
        lc_pp1nump_mx := null;
        lc_pp1nump_mn := null;
    end;
  
    if lc_pp1nump_mx is not null then
    
      -- Interés y capital
      begin
      
        select nvl(sum(case when t.pp1cap > 0 then t.pp1cap else 0 end), 0), nvl(sum(t.pp1int), 0)
          into ln_cuo, ln_int
        
          from AQPC366D/*fsd602*/ t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
       --    and t.ppsuc = pn_suc
          and t.ppsuc in (select p.sucurs
                     from fst001 p
                    where p.pgcod = 1
                      and p.sucurs < 800)
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S';
      
      exception
        when others then
          ln_cuo := 0;
          ln_int := 0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into ln_mor, ln_icv, ln_gas
          from fsd612 x, AQPC366D/*FSD602*/ t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp1nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
        --   and x.ppsuc = pn_suc
           and x.ppsuc in (select p.sucurs
                     from fst001 p
                    where p.pgcod = 1
                      and p.sucurs < 800)
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp1nump >= lc_pp1nump_mn
           and x.pp1nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          ln_mor := 0;
          ln_icv := 0;
          ln_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into ln_pen
          from fpp003 x, AQPC366D/*FSD602*/ t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp003nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
       --    and x.ppsuc = pn_suc
           and x.ppsuc in (select p.sucurs
                     from fst001 p
                    where p.pgcod = 1
                      and p.sucurs < 800)       
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp003nump >= lc_pp1nump_mn
           and x.pp003nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          ln_pen := 0;
      end;
    
    else
      ln_gas := 0;
      ln_mor := 0;
      ln_int := 0;
      ln_cuo := 0;
      ln_icv := 0;
      ln_pen := 0;
    end if;
  
    ln_tsum := (nvl(ln_gas,0) + nvl(ln_mor,0) + nvl(ln_int,0) + nvl(ln_cuo,0) + nvl(ln_icv,0) + nvl(ln_pen,0));
 
---/*---fin montos */


   begin
      select type_distrib_pago(ln_tsum,
                               ln_gas,
                               ln_mor,
                               ln_int,
                               ln_cuo,
                               ln_icv,
                               ln_pen)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end fn_get_distribuc_pago_IMP;
  ------------------------------------------------------------------------
function fn_get_mprepago_IMP(pn_cod   in number,
                           pn_mod   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_top   in number,
                           pd_fecha in date) return type_table_monto_prepago is
                           
/* ************************************************************************************************************
    -- Nombre                     : fn_get_mprepago_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna Monto prepago, capital pagado en el mes
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/07/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2024.10.03
    -- Autor de Modificación      : DCASTRO
    -- Descripción Modificación   : Se agregó guia 10876 para obtener ordinales de capital en trxs honrados

* *************************************************************************************************************/
                            
                           
    t_resp      type_table_monto_prepago;
    lx_cd       number(3);
    lx_mo       number(3);
    lx_su       number(3);
    lx_tr       number(3);
    lx_re       number(4);
    lx_fc       date;
    lx_fecha    date;
    ln_monto    number(17, 2);
    ln_int      number(17, 2);
    lc_fini     date;
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
    ln_monto := 0;
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
    -- 2. Obtención pago mes
    begin
      select /*+index(T SYS_C00978743)*/nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
        into ln_monto, ln_int
      
        from AQPC366D/*fsd602*/ t
       where t.pgcod = pn_cod
            --and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 3
                 and x.tp1corr3 > 0)
         /*and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha*/
         and t.pp1fech >= lc_fini
         and t.pp1fech <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        ln_monto := 0;
        ln_int   := 0;
    end;
  
    -- pagos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
         and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 1
                 and tp1corr3 > 0
              ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
              union
                 select distinct f.TP1CORR1, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                 where g.tp1cod = f.tp1cod
                 and g.tp1cod1 = 11164
                 and g.tp1corr1 = 4
                 and g.tp1corr2 = 1
                 and g.tp1corr3 > 0
                 and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                 and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
                 ---2024.10.03  dcastro 
                  );
    exception
      when others then
        lx_shon := 0;
    end;
  
    -- extornos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon_ext
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
         and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 2
                 and tp1corr3 > 0
              ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
              union
                 select distinct f.TP1CORR1+500, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                 where g.tp1cod = f.tp1cod
                 and g.tp1cod1 = 11164
                 and g.tp1corr1 = 4
                 and g.tp1corr2 = 1
                 and g.tp1corr3 > 0
                 and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                 and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
              ---2024.10.03  dcastro 
              );

    exception
      when others then
        lx_shon_ext := 0;
    end;
  
    begin
      select type_monto_prepago(ln_monto + lx_shon - lx_shon_ext)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end fn_get_mprepago_IMP;
--------------------------------------------------------------------------  

function fn_get_cuota_pago_IMP(pn_cod in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pd_fec in date) return type_table_cuota_pago is

/* ************************************************************************************************************
    -- Nombre                     : fn_get_cuota_pago_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna Monto prepago, capital pagado en el mes
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/07/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/
 
    t_resp   type_table_cuota_pago;
    ln_cuopp number(10);
    ln_cuopa number(10);
    ld_fecha date;

  begin
    ln_cuopp := 0;
    ln_cuopa := 0;
    
        -- ultima fecha de cuota pagada totalmente
      begin
        select max(t.ppfpag)
          into ld_fecha
          from AQPC366D/*fsd602*/ t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and  x.sucurs < 800) ---2024.09.03
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1stat = 'T'
           /*and t.d602fc <= pd_fec*/
           and t.pp1fech <= pd_fec
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) in
               (select tp1nro2, tp1nro3
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 10871
                   and tp1corr1 = 7
                   and tp1corr2 = 10
                   and tp1corr3 > 0);

      exception
        when others then
          ld_fecha := null;
      end;

      if ld_fecha is null then
         ln_cuopa := 0;  --cuotas pagadas
         --cuotas pendientes de pago son todas las cuotas
          begin
              SELECT /*+index(t FSD60103)*/
               count(*)
                into ln_cuopp
                FROM FSD601 t
               where t.pgcod = pn_cod
                 and t.ppmod = pn_mod
                 and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and  x.sucurs < 800) ---2024.09.03
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 and t.ppsbop = pn_sbo
                 and t.pptope = pn_top
                 and t.d601co = 'S';
          exception
            when others then
              ln_cuopp := null;
          end;

      
      else ---determinar cuotas pagadas  
        begin
            select --count(*)
                   count(distinct t.ppfpag) --- 2024.09.13 dcastro
              into ln_cuopa
              from AQPC366D/*fsd602*/ t
             where t.pgcod = pn_cod
               and t.ppmod = pn_mod
               and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and  x.sucurs < 800) ---2024.09.03
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               and t.ppsbop = pn_sbo
               and t.pptope = pn_top
               and t.pp1stat = 'T'
               and t.pp1fech <= pd_fec
               and t.d602co = 'S'
               and (t.d602mo, t.d602tr) in
                   (select tp1nro2, tp1nro3
                      from fst198
                     where tp1cod = 1
                       and tp1cod1 = 10871
                       and tp1corr1 = 7
                       and tp1corr2 = 10
                       and tp1corr3 > 0);

        exception
        when others then
             ln_cuopa := 0;
        end;
        
        --cuota pendientes de pago
          begin
                  SELECT
                   count(*)
                    into ln_cuopp
                    FROM FSD601 t
                   where t.pgcod = pn_cod
                     and t.ppmod = pn_mod
                     and t.ppsuc in (select x.sucurs from fst001 x where x.sucurs < 800) ---2024.09.03
                     and t.ppmda = pn_mda
                     and t.pppap = pn_pap
                     and t.ppcta = pn_cta
                     and t.ppoper = pn_ope
                     and t.ppsbop = pn_sbo
                     and t.pptope = pn_top
                     and t.ppfpag > ld_fecha
                     and t.d601co = 'S';
                exception
                  when others then
                    ln_cuopp := null;
                end;

      end if;
      
    begin
      select type_cuota_pago(ln_cuopp, ln_cuopa)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end fn_get_cuota_pago_IMP;
--------------------------------------------------------  
 function fn_get_dias_atraso_IMP(v_Pgfape in date, --fecha de proceso
                              v_Pgcod  in number,
                              v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              v_fecven in date) return type_table_dias_atraso is
 /* ************************************************************************************************************
    -- Nombre                     : fn_get_dias_atraso_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Retorna dias de atraso
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/08/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/

 
    t_resp         type_table_dias_atraso;
    ln_diatr       number;
    ATR_FEB        number;
    ln_cov19       number;
    ln_cant        number;
    LN_DIATR_CNGLD number; --2020.04.07
    lc_cancelado   char(1);
  begin
    ln_diatr       := 0;
    ATR_FEB        := 0;
    ln_cov19       := 0;
    ln_cant        := 0;
    LN_DIATR_CNGLD := 0;
    If v_Scmod in (200, 33, 141) Then
      --se agrego carta fianza
    
      ln_diatr := v_Pgfape - v_fecven;
    
      If ln_diatr < 0 then
        ln_diatr := 0;
      End if;
    
    Else
      begin
        SELECT (v_Pgfape - min(a.Ppfpag))
          into ln_diatr
          FROM FSD601 a
          left join AQPC366D/*FSD602*/ b
            on b.Pgcod = a.Pgcod
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
  
   --2024.08.15 DCASTRO si credito fue cancelado, dias de atraso es 0
    Begin
      select 'S'
        into lc_cancelado
        from fsd010 d
       where d.pgcod = v_Pgcod
         and d.aomod = v_Scmod
         and d.aosuc = v_Scsuc
         and d.aomda = v_Scmda
         and d.aopap = v_Scpap
         and d.aocta = v_Sccta
         and d.aooper = v_Scoper
         and d.aosbop = v_Scsbop
         and d.aotope = v_Sctope
         and d.aostat = 99
         and d.aofe99 <= v_Pgfape;

    exception
      when no_data_found then
        lc_cancelado := 'N';
    End;
    if lc_cancelado = 'S' then
        LN_DIATR := 0;
    end if;
   
  /* 2024.08.15 DCASTRO se comento calculo dias atraso 
  ---2020.04.04 dcastro  Modificacion por emergencia covid19 
    LN_DIATR_CNGLD := -1;
  
    begin
      select f.tp1nro1
        into ln_cov19
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10872
         and f.tp1corr1 = 100
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception
      when others then
        ln_cov19 := 0;
    end;
  
    if ln_cov19 = 1 then
      --si flag esta habilitado
    
      IF v_Scmod = 33 then
        -- si es castigo
        ATR_FEB := -1;
      ELSE
      
        BEGIN
        
          SELECT NVL(X.AQPB003DATR, -1)
            INTO ATR_FEB
            FROM AQPB003 X
           WHERE X.AQPB003HCTA = v_Sccta
             AND X.AQPB003HOPER = v_Scoper
             AND X.AQPB003FECH = TO_DATE('20200229', 'YYYYMMDD')
             and rownum = 1;
        
        EXCEPTION
          WHEN OTHERS THEN
            ATR_FEB := -1;
        END;
      
        IF (ATR_FEB > 15) THEN
        
          --valida si credito fue reprogramado
          begin
            select count(*)
              into ln_cant
              from aqpb090 a
             where a.aqpb090cta = v_Sccta
               and a.aqpb090oper = v_Scoper
               and a.aqpb090ext = 'NO';
          exception
            when others then
              ln_cant := 0;
          end;
        
          if ln_cant = 0 then
            --no fue reprogramado
            LN_DIATR_CNGLD := ATR_FEB;
          else
            LN_DIATR_CNGLD := -1;
          end if;
        
        ELSE
          LN_DIATR_CNGLD := -1;
        
        END IF;
      
      END IF; --fin castigos
    
    end if;
  
    IF (LN_DIATR_CNGLD < LN_DIATR) and LN_DIATR_CNGLD <> -1 THEN
      LN_DIATR := LN_DIATR_CNGLD;
    END IF;*/
  
    begin
      select type_dias_atraso(ln_diatr) bulk collect into t_resp from dual;
    exception
        when others then null;
    end;
    return t_resp;
  exception when others then
    null;  
  end fn_get_dias_atraso_IMP;
  ----------------------------------------------------------------------
 -------------------------------------------------------------------------
  function fn_get_otros_repfondos_IMP(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pd_fecha in date,
                                  pn_indi  in number)
    return type_table_otros_repfondos is
/* ************************************************************************************************************
    -- Nombre                     : fn_get_otros_repfondos_IMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : retorna variables para reporte fondos impulsa
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/08/2024
    -- Autor de Creación          : DCASTRO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de Modificación      : -
    -- Descripción Modificación   : -

* *************************************************************************************************************/
    
    /* procedimiento para calcular 
            'Saldo Insoluto antes del prepago';
            'Prepago(Total/Parcial)(Total=cancelacion, Parcial=amortizacion)';
            'Pago realizado (Pago total)';
            'Principal amortizado';
            'Numero de cuotas del cronograma original enviado a COFIDE';
            'Numero de cuotas de cronograma actual';
            'Valor de la ultima cuota pagada';
            'Valor de cuota proximo vencimiento';
            'Nueva fecha de la ultima cuota luego del prepago';
            'Interes compensatorios';
            'Intereses compensatorios vencidos';
            'Interes moratorio';
            'Penalidad';
            'Ruc de Certificacion';
            'Monto Reprogramado';
            'Tasa de interes de la reprogramacion';
    */
    t_resp type_table_otros_repfondos;
  
    lc_cuo_n       number;
    lc_cuo_o       number;
    lc_fmant       date;
    lc_sdoins_mant number(17, 2);
    lc_prpago      number(17, 2);
    lc_pagrea      number(17, 2);
    lc_pramrt      number(17, 2);
    lc_vulcpa      number(17, 2);
    lc_vcprve      number(17, 2);
    lc_fuclpr      date;
    lc_intcom      number(17, 2);
    lc_intcov      number(17, 2);
    lc_intmor      number(17, 2);
    lc_penali      number(17, 2);
    lc_gasm        number(17, 2);
    lc_morm        number(17, 2);
    lc_intm        number(17, 2);
    lc_icvm        number(17, 2);
    lc_penm        number(17, 2);
    lc_tsumm       number(17, 2);
    lc_capm        number(17, 2);
    lc_rucc        char(12);
    lc_monrep      number(17, 2);
    lc_tintre      number(10, 4);
  
    lx_sbop  number;
    lc_flag  number;
    lx_imp   number(17, 2);
    lx_cd    number(3);
    lx_mo    number(3);
    lx_su    number(3);
    lx_tr    number(3);
    lx_re    number(4);
    lx_fc    date;
    lx_fecha date;
  
    lc_ppfpag     date;
    lc_pp1nump    number(9);
    lc_pp1nump_mx number(9);
    lc_pp1nump_mn number(9);
    lc_fini       date;
    lc_gas        number;
    lc_mor        number;
    lc_icv        number;
    lc_cuo        number;
    lc_int        number;
    lc_pen        number;
    ld_fecha_ucuo date;
    ld_fecham_456 date;
    
    lx_fecha2     date;
    ld_fPAg1      DATE;
    ld_ppfpag     date;
    ln_pp1nump    number;
  
  begin
    -- nro cuotas origen
    begin
    
      select /*+index(t FSD60103)*/count(*)
        into lc_cuo_o
        from FSD601 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and  x.sucurs < 800) ---2024.09.03
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = 0
            --and t.pptope = m.aotope
         and t.d601co = 'S';
    
    exception
      when others then
        lc_cuo_o := 0;
    end;
    --nro cuotas actual cronograma
    begin
      begin
      select x.tp1nro1
        into lc_flag
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 1;
      exception when others then null;
        end;
      begin
      select max(t.aosbop)
        into lx_sbop
        from fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
            --and t.aomod <> 419 --  jrodriguej 28.06.2021
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
      exception when others then null;
        end;
      if lc_flag = 0 then
      
        select count(*)
          into lc_cuo_n
          from FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and  x.sucurs < 800) ---2024.09.03
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = lx_sbop
              --and t.pptope = m.aotope
           and t.d601Co = 'S'
           and t.ppcap >0;
      
        -----
      else
        select /*+index(t FSD60103)*/ count(*)
          into lc_cuo_n
          from FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc in (select x.sucurs from fst001 x where x.pgcod = 1 and x.sucurs < 800) ---2024.09.03
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = lx_sbop
              --and t.pptope = m.aotope
           and t.d601Co = 'S'
           /*se comento para impulsa 2024.08.22
           and (t.pgcod, t.ppmod, t.ppsuc, t.ppmda, t.pppap, t.ppcta,
                t.ppoper, t.ppsbop, t.pptope, t.ppfpag) not in
               (SELECT u.pgcod,
                       u.aomod,
                       u.aosuc,
                       u.aomda,
                       u.aopap,
                       u.aocta,
                       u.aooper,
                       u.aosbop,
                       u.aotope,
                       u.evfval
                  FROM FSD012 u
                 where u.pgcod = pn_cod
                   and u.aomod = pn_mod
                   and u.aosuc = pn_suc
                   and u.aomda = pn_mda
                   and u.aopap = pn_pap
                   and u.aocta = pn_cta
                   and u.aooper = pn_ope
                   and u.aosbop = lx_sbop
                   and u.aotope = pn_top
                   and u.d012co = 'S'
                   and u.evtipo = 50)*/;
      end if;
    exception
      when others then
        lc_cuo_n := 0;
    end;
    --- m preppago
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
    begin
      begin
      select f.d012cd, f.d012mo, f.d012su, f.d012tr, f.d012re, f.d012fc
        into lx_cd, lx_mo, lx_su, lx_tr, lx_re, lx_fc
        from (select t.d012cd,
                     t.d012mo,
                     t.d012su,
                     t.d012tr,
                     t.d012re,
                     t.d012fc
              
                from fsd012 t
               where t.pgcod = pn_cod
                 and t.aomod = pn_mod
                    --and t.aosuc = pn_suc --  jrodriguej 28.06.2021
                         and t.aosuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
                 and t.aomda = pn_mda
                 and t.aopap = pn_pap
                 and t.aocta = pn_cta
                 and t.aooper = pn_ope
                    --and t.aosbop = pn_sbo
                    --and t.aotope = pn_top   dcastro 24.09.2021
                 and t.evtipo = 50
                 and t.d012co = 'S'
                 and t.d012fc <= pd_fecha
               order by t.d012fc desc) f
       where rownum = 1;
      exception when others then null;
      end;
      --if lx_fecha <> pn_fecha then
      if lx_fc <> pd_fecha then
        begin
        select t.hcimp1
          into lc_prpago
          from fsh016 t
         where t.pgcod = lx_cd
           and t.hcmod = lx_mo
           and t.hsucor = lx_su
           and t.htran = lx_tr
           and t.hnrel = lx_re
           and t.hfcon = lx_fc
           and t.hcord = 83;
        exception when others then null;
        end;
      else
        begin
        select t.itimp1
          into lc_prpago
          from fsd016 t
         where t.pgcod = lx_cd
           and t.itmod = lx_mo
           and t.itsuc = lx_su
           and t.ittran = lx_tr
           and t.itnrel = lx_re
              --and t.itfval = lx_fc
           and t.itord = 83;
        exception when others then null;
        end;
      end if;
    
    exception
      when others then
        lc_prpago := 0;
    end;
    -- pago realizado y amortizacion
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
  
    begin
    
      select /*+index(t SYS_C00978743)*/max(t.pp1nump), min(t.pp1nump)
        into lc_pp1nump_mx, lc_pp1nump_mn
        from AQPC366D/*fsd602*/ t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha
         and t.pp1cap > 0
         and t.d602co = 'S';
    exception
      when others then
        lc_pp1nump_mx := null;
        lc_pp1nump_mn := null;
    end;
  
    if lc_pp1nump_mx is not null then
    
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0),nvl(sum(case when t.pp1cap > 0 then t.pp1cap else 0 end), 0)
          into lc_cuo, lc_int,lc_pramrt
        
          from AQPC366D/*fsd602*/ t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S';
      
      exception
        when others then
          lc_cuo := 0;
          lc_int := 0;
          lc_pramrt :=0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd612 x, AQPC366D/*FSD602*/ t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp1nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp1nump >= lc_pp1nump_mn
           and x.pp1nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into lc_pen
          from fpp003 x, AQPC366D/*FSD602*/ t
         where x.pgcod = t.pgcod --- jrodriguej 12.08.2021
           and x.ppmod = t.ppmod
           and x.ppsuc = t.ppsuc
           and x.ppmda = t.ppmda
           and x.pppap = t.pppap
           and x.ppcta = t.ppcta
           and x.ppoper = t.ppoper
           and x.ppsbop = t.ppsbop
           and x.pptope = t.pptope
           and x.ppfpag = t.ppfpag
           and x.pp003nump = t.pp1nump
              
           and x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.pp003nump >= lc_pp1nump_mn
           and x.pp003nump <= lc_pp1nump_mx
           and t.d602co = 'S';
      exception
        when others then
          lc_pen := 0;
      end;
    
    else
      lc_gas := 0;
      lc_mor := 0;
      lc_int := 0;
      lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
    end if;
  
    lc_pagrea := (lc_gas + lc_mor + lc_int + lc_cuo + lc_icv + lc_pen);
    --lc_pramrt := lc_cuo;
    -- valor cuotas ultima y proxima y fecha ultimo
    begin
      select pp1fech, pp1int + pp1cap,ppfpag
        into ld_fecha_ucuo, lc_vulcpa,ld_fpag1
        from (select pp1fech, pp1int, case when pp1cap > 0  then pp1cap else 0 end pp1cap,ppfpag
                from AQPC366D/*fsd602*/ a
               where a.pgcod = pn_cod
                 and a.ppmod = pn_mod
                 and a.ppsuc = pn_suc
                 and a.ppmda = pn_mda
                 and a.pppap = pn_pap
                 and a.ppcta = pn_cta
                 and a.ppoper = pn_ope
                 and a.ppsbop = pn_sbo
                 and a.pptope = pn_top
                 and a.pp1stat = 'T'
                 and a.d602co = 'S'
                 and a.d602fc <= pd_fecha
               order by pp1fech desc,pp1nump desc)
       where rownum = 1;
    exception
      when others then
        ld_fecha_ucuo := null;
        lc_vulcpa     := 0;
    end;
      lc_gas := 0;
      lc_mor := 0;
      --lc_int := 0;
      --lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
      begin
    
        select f.ppfpag, f.pp1nump
          into ld_ppfpag, ln_pp1nump
          from (select t.ppfpag, t.pp1nump
                  from AQPC366D/*fsd602*/ t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.pp1stat in ('P', 'T')
                   and t.d602fc <= pd_fecha
                   and t.d602co = 'S'
                 order by t.pp1nump desc) f
         where rownum = 1;
      exception
        when others then
          ld_ppfpag  := null;
          ln_pp1nump := null;
      end;
    -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from fsd612 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp1nump <= lc_pp1nump;
           and x.pp1nump = ln_pp1nump
           and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
    
      --- Penalidad
      begin
        select sum(nvl(x.pp003imp, 0))
          into lc_pen
          from fpp003 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              --and x.pp003nump <= lc_pp1nump;
           and x.pp003nump = ln_pp1nump
           --and x.ppfpag > lc_fmant
           and x.ppfpag <= pd_fecha;
      exception
        when others then
          lc_pen := 0;
      end;
    lc_vulcpa := nvl(lc_vulcpa,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0) + nvl(lc_pen,0); 
    
    lc_vcprve := 0;
    lc_gas := 0;
      lc_mor := 0;
      --lc_int := 0;
      --lc_cuo := 0;
      lc_icv := 0;
      lc_pen := 0;
      
    if ld_fecha_ucuo is not null then
      begin
        select ppfpag, ppcap + ppint
          into lc_fuclpr, lc_vcprve
          from (select ppfpag, ppcap, ppint
                  from FSD601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.d601co = 'S'
                   and t.ppcap >0
                   and t.ppfpag > ld_fecha_ucuo
                   AND t.ppfpag > ld_fpag1
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          lc_vcprve := 0;
          lc_fuclpr := null;
      end;
      begin
       select /*+index(x SYS_C00977248)*/nvl(sum(x.ppimp2), 0), --- mora
               nvl(sum(x.ppimp3), 0), --- icv
               nvl(sum(x.ppimp11 + x.ppimp12 + x.ppimp13 + x.ppimp14 +
                       x.ppimp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from AQPC366E/*fsd611*/ x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              
           and x.ppfpag =  lc_fuclpr;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
      lc_vcprve := nvl(lc_vcprve,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0);
          
    else 
      begin
        select ppfpag, ppcap + ppint
          into lc_fuclpr, lc_vcprve
          from (select ppfpag, ppcap, ppint
                  from FSD601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppsuc = pn_suc
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = pn_sbo
                   and t.pptope = pn_top
                   and t.d601co = 'S'
                   and t.ppcap > 0
                   --and t.ppfpag > ld_fecha_ucuo
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          lc_vcprve := 0;
          lc_fuclpr := null;
      end;
      begin
       select /*+index(x SYS_C00977248)*/nvl(sum(x.ppimp2), 0), --- mora
               nvl(sum(x.ppimp3), 0), --- icv
               nvl(sum(x.ppimp11 + x.ppimp12 + x.ppimp13 + x.ppimp14 +
                       x.ppimp15),
                   0) --seg
          into lc_mor, lc_icv, lc_gas
          from AQPC366E/*fsd611*/ x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
                      and x.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.04 dcastro se agrego sucursales
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              
           and x.ppfpag =  lc_fuclpr;
      exception
        when others then
          lc_mor := 0;
          lc_icv := 0;
          lc_gas := 0;
      end;
      lc_vcprve := nvl(lc_vcprve,0) + nvl(lc_mor,0) +nvl(lc_icv,0) + nvl(lc_gas,0);
    end if;
  
    -- intereses compensatorio moratotio icv penalidad
    /*begin
      select max(a.jaql964hfeh)
        into lx_fecha2
        from jaql964h a
       where a.jaql964hcta = pn_cta
         and a.jaql964hope = pn_ope;
    exception
      when others then
        lx_fecha2 := pd_fecha;
    end;*/
    lx_fecha2 := pd_fecha -1;
    begin
      select a.jaql964int, a.jaql964mor, a.jaql964icv, a.jaql964pen
        into lc_intcom, lc_intmor, lc_intcov, lc_penali
        from jaql964 a
       where a.jaql964cta = pn_cta
         and a.jaql964ope = pn_ope
         and rownum = 1;
    exception
      when others then
        begin
          select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
            into lc_intcom, lc_intmor, lc_intcov, lc_penali
            from jaql964h a
           where a.jaql964hfeh = lx_fecha2
             and a.jaql964hcta = pn_cta
             and a.jaql964hope = pn_ope;
        exception
          when others then
          begin
            select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
              into lc_intcom, lc_intmor, lc_intcov, lc_penali
              from jaql964h a
             where a.jaql964hfeh = lx_fecha2 -1
               and a.jaql964hcta = pn_cta
               and a.jaql964hope = pn_ope;
          exception
            when others then
              begin
                select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
                  into lc_intcom, lc_intmor, lc_intcov, lc_penali
                  from jaql964h a
                 where a.jaql964hfeh = lx_fecha2 -2
                   and a.jaql964hcta = pn_cta
                   and a.jaql964hope = pn_ope;
              exception
                when others then
                  lc_intcom := 0;
                  lc_intmor := 0;
                  lc_intcov := 0;
                  lc_penali := 0;
              end;
          end;
        end;
    end;
  
    -- ruc certificacion
    if (pn_indi = 1) then
      begin
        select aqpb456ndoc
          into lc_rucc
          from (select aqpb456fcar, aqpb456ndoc
                  from aqpb456
                 where aqpb456cta1 = pn_cta
                   --and aqpb456ind in ('FT1', 'FT2')
                 order by aqpb456fcar desc)
         where rownum = 1;
      exception
        when others then
          lc_rucc := '';
      end;
    else
      lc_rucc := '';
    end if;
    begin
      select type_otros_repfondos(lc_sdoins_mant,
                                  lc_prpago,
                                  lc_pagrea,
                                  lc_pramrt,
                                  lc_cuo_o,
                                  lc_cuo_n,
                                  lc_vulcpa,
                                  lc_vcprve,
                                  lc_fuclpr,
                                  lc_intcom,
                                  lc_intcov,
                                  lc_intmor,
                                  lc_penali,
                                  lc_rucc,
                                  0,
                                  0)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end fn_get_otros_repfondos_IMP;
  ----------------------------------------------------------------
  -------------------------------------------------------------------------
  function fn_get_mprepago_acum_IMP(pn_cod   in number,
                                pn_mod   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_top   in number,
                                pd_fecha in date)
    return type_table_monto_prepago is
    t_resp      type_table_monto_prepago;
    lx_cd       number(3);
    lx_mo       number(3);
    lx_su       number(3);
    lx_tr       number(3);
    lx_re       number(4);
    lx_fc       date;
    lx_fecha    date;
    ln_monto    number(17, 2);
    ln_int      number(17, 2);
    lc_fini     date;
    lx_shon     number(17, 2);
    lx_shon_ext number(17, 2);

    -- Fecha de Modificación      : 2024.10.03
    -- Autor de Modificación      : DCASTRO
    -- Descripción Modificación   : Se agregó guia 10876 para obtener ordinales de capital en trxs honrados

  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
    ln_monto := 0;
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    lc_fini := trunc(pd_fecha) - (to_number(to_char(pd_fecha, 'DD')) - 1);
    -- 2. Obtención pago mes
    begin
      select /*+index(T SYS_C00978743)*/nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
        into ln_monto, ln_int
      
        from AQPC366D/*fsd602*/ t
       where t.pgcod = pn_cod
            --and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 3
                 and x.tp1corr3 > 0)
            --and t.d602fc >= lc_fini
         and t.d602fc <= pd_fecha
         and t.d602co = 'S';
    exception
      when others then
        ln_monto := 0;
        ln_int   := 0;
    end;
  
    -- pagos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
            --and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 1
                 and tp1corr3 > 0
              ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
              union
                 select distinct f.TP1CORR1, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                 where g.tp1cod = f.tp1cod
                 and g.tp1cod1 = 11164
                 and g.tp1corr1 = 4
                 and g.tp1corr2 = 1
                 and g.tp1corr3 > 0
                 and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                 and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
                 ---2024.10.03  dcastro     
                 );
    exception
      when others then
        lx_shon := 0;
    end;
  
    -- extornos honrados
    begin
      select nvl(sum(x.HCIMP1), 0)
        into lx_shon_ext
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
            --and x.HMODUL = 
            --and x.HSUCUR = 
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta
         and x.HOPER = pn_ope
            --and x.HSUBOP = 
            --and x.HTOPER = 
            
            --and x.HFCON >= lc_fini
         and x.HFCON <= pd_fecha
         and x.HFVAL <= pd_fecha
         and (x.HCMOD, x.HTRAN, x.hcord) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11164
                 and tp1corr1 = 4
                 and tp1corr2 = 2
                 and tp1corr3 > 0
              ---2024.10.03  dcastro agregar la guia para capital en transacciones honradas   
              union
                 select distinct f.TP1CORR1+500, f.TP1CORR2, f.tp1imp1 from  fst198 f, fst198 g
                 where g.tp1cod = f.tp1cod
                 and g.tp1cod1 = 11164
                 and g.tp1corr1 = 4
                 and g.tp1corr2 = 1
                 and g.tp1corr3 > 0
                 and f.tp1cod = 1 and f.tp1cod1 = 10876 --and tp1corr1 = 1
                 and f.tp1corr1 = g.tp1nro1 and f.tp1corr2 = g.tp1nro2 and f.tp1nro1 = 1 
                 ---2024.10.03  dcastro    
                 );
    exception
      when others then
        lx_shon_ext := 0;
    end;
  
    begin
      select type_monto_prepago(ln_monto + lx_shon - lx_shon_ext)
        bulk collect
        into t_resp
        from dual;
    exception
        when others then null;
    end;
    return t_resp;
  end fn_get_mprepago_acum_IMP;
  -------------------------------------------------------------------------

  
end pq_cr_reporte_utilitarios;
/
