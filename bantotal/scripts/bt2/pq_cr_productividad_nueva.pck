create or replace package PQ_CR_PRODUCTIVIDAD_NUEVA is

  -- *****************************************************************
  -- Nombre                     : PRODUCTIVIDAD DE ANALISTAS DE CREDITO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.15
  -- Autor de Creación          : DCASTRO 
  -- Uso                        : OBTENER PRODUCTIVIDAD DE ANALISTAS DE CREDITOS - OCTUBRE 2016
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.11.13 dcastro
  -- Autor de la Modificación   : dcastro 
  -- Descripción de Modificación: se modifico procedimientos sp_cr_carga_datos_diario,sp_cr_carga_datos, sp_cr_cumplimiento,sp_cr_tipana_NA,sp_cr_job_recategoriza
  --                            : 2023.11.21 dcastro sp_cr_inserta_desembolsos_recategorizacion se agregó condición de fecha de proceso.
  --                            : 2023.11.22 dcastro se optimizo consulta a variable analista, se reemplazo trim por rpad, se optimizo job sp_cr_job_cartera_mes,sp_cr_inserta_cartera, fn_pa_Sal_recibidoNew, fn_pa_Cli_recibidoNew,fn_pa_Sal_OtorgadoNew,fn_pa_Cli_OtorgadoNew.
  --                              2023.12.05 dcastro sp_cr_cumplimiento, no aplica contencion si es nuevo y menor o igual a 6 meses
  --                              2024.02.16 dcastro sp_cr_cumplimiento, se agrego condición si la base contencion1 = 0 el pago de contencion1 es igual a 0
  --                              2024.03.22 dcastro sp_cr_inserta_desembolsos, sp_cr_inserta_desembolsos_recategorizacion se agregó condicion por sucursal
  --                              2024.04.24 dcastro sp_cr_meses_age, se modifico conteo de meses por calculo diario
  --                              2024.07.11 dcastro sp_cr_inserta_traslados se modificó condición para cancelados y creditos de otra agencia
  --                              2025.01.15 dcastro se modificaron procesos para control de jobs
  --                              2025.04.30 dcastro se modificó sp_cr_inserta_cartera_diario - dias atraso diario y sp_cr_SaldosTraslados
  --                              2025.05.08 dcastro se modifico sp_cr_inserta_cartera_finmes y sp_cr_inserta_cartera_diario 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_cartera(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  Procedure sp_cr_inserta_cartera_finmes(pn_codsuc in number,
                                         pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_job_cartera_diario(pd_fecpro in date);
  ---------------------------------------------------------------------
  --Procedure sp_cr_inserta_cartera_diario( pd_fecpro in date);
  Procedure sp_cr_inserta_cartera_diario(pn_codzon in number,
                                         pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_carga(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_agencia(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_carga_datos_diario(pc_sucurs in varchar2,
                                     pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_sucurs in varchar2, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Sal_recibidoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Sal_OtorgadoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Cli_OtorgadoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Cli_RecibidoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contmes_anterior(Pc_analista IN varchar2,
                                  pd_fecpro   in date,
                                  pc_codsuc   in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Sal_Judicial(pc_analista IN varchar2,
                              pd_fecpro   in date,
                              pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_Sal_Castigado(pc_analista IN varchar2,
                               pd_fecpro   in date,
                               pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_saldo_mora(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_pa_saldo_legal(pc_analista IN varchar2,
                             pd_fecpro   in date,
                             pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_num_saldo_legal(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior(pc_analista IN char,
                                pd_fecpro   IN date,
                                pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior(pc_analista IN char,
                                 pd_fecpro   IN date,
                                 pc_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_nueva_mora(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pc_codsuc   in varchar2,
                            pn_salmor   in number,
                            pn_saljud   in number,
                            pn_saldo    in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_CategoriaRRHH(pc_JAQY830codana in char,
                                pd_fecpro        in date,
                                pn_jaqY830codcat out number,
                                pc_jaqy830tipase out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia_metas(P_IN_agen  in number,
                                    P_IN_Fecha in date) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_Traslados_JAQZ455(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_traslados(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_indicadores(pd_fecpro   in date,
                              pc_analista in varchar2,
                              pc_sucurs   in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_desembolsos(pd_fecpro     in date,
                              pc_analista   in varchar2,
                              pn_saldo      out number,
                              pn_porpago    out number,
                              pn_porcentaje out number,
                              pn_saldotot   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                        
  procedure sp_cr_metas(pn_codcat in number,
                        pc_tipase in char,
                        pn_cresal out number,
                        pn_crecli out number,
                        pn_mincom out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_pago_metas(pn_codcat in number,
                             pc_tipase in char,
                             pn_mtosal out number,
                             pn_mtocli out number,
                             pn_mtoret out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_cumplimiento_ini(pd_fecpro   in date,
                               pc_analista in varchar2,
                               pc_codage   in number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_cumplimiento(pd_fecpro   in date,
                               pc_analista in varchar2,
                               pc_codage   in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_variacion_mora(pc_analista IN char,
                                 pd_fecpro   IN date,
                                 pc_tipase   in char,
                                 pn_pormor   IN number,
                                 pn_pormoa   out number,
                                 pn_varmor   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_metamora(pc_tipase in char,
                          pn_pormor in number,
                          pn_varmor in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_nuevosaldo_anterior(pc_analista IN char,
                                      pd_fecpro   IN date,
                                      pc_codage   in number,
                                      pn_salant   out number,
                                      pn_cliant   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_agencia_anterior(pc_analista IN char, pd_fecpro IN date)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_continuidad_mora(pc_analista IN varchar2,
                                  pd_fecpro   in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_bonoTrimestral(pd_fecpro   in date,
                                 pc_analista in varchar2,
                                 pc_codage   in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_contencion(pn_basecon in number, pn_porcon in number)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nuevamora_anterior(pc_analista IN varchar2,
                                    pd_fecpro   in date,
                                    pd_fechoy   in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_indicadores(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_cumplimiento(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_desembolsos(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_cli_Castigado(pc_analista IN varchar2,
                               pd_fecpro   in date,
                               pn_codage   in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_SaldosTraslados(pc_analista IN varchar2,
                                  pd_fecpro   in date,
                                  pd_feccal   in date,                                  
                                  pn_saltot   out number,
                                  pn_salmor   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cartera_Vendida(pc_analista IN varchar2,
                                  pn_sucurs   in number,
                                  pd_fecpro   in date,
                                  pn_salven   out number,
                                  pn_cliven   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Calculo_Senior(pd_fecpro   in date,
                                 pc_analista IN varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_Calculo_Senior(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_val_continuidad(pd_fecpro   in date,
                                  pc_analista in varchar2,
                                  pc_codage   in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_pa_mora_comite(pc_comite IN varchar2, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_continuidad_mora_comite(pc_comite IN varchar2,
                                         pd_fecpro in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cumplimiento_senior(pd_fecpro in date,
                                      pc_codage in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_Cumplimiento_Senior(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_bonoTrimestral_senior(pd_fecpro in date,
                                        pc_comite in varchar2,
                                        pc_codage in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_agencia(pc_analista IN char, pd_fecpro IN date)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cartera_recibida(pc_analista IN char, pd_fecpro IN date)
    return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_mora_traslado(pc_analista IN char,
                             pd_fecpro   IN date,
                             pn_salrec   in number,
                             pn_salmor   out number,
                             pn_pormor   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_inserta_cartera_diarioI(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_sch_indicadores(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_cumplimiento(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_Calculo_Senior(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_Cumplimiento_Senior(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_Calculo_Mensual(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_instancia_asesor(pd_fecpro in date);
  -------------------------------------------------------------------------------------------------
  procedure sp_sch_job_carga(pd_fecpro in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_meses_ana(pc_analista IN char,
                              pn_codcat in number,            
                              pd_fecpro   IN date,
                              pc_numdoc in char,                              
                              pn_meses   out number,
                              pd_fecin   out date
                              );

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_meses_age(pc_analista IN char,
                            pn_codcat in number,            
                            pd_fecpro IN date,
                            pn_codage in number,
                            pn_meses  out number);                              
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_tipana_NA(pc_analista IN char,
                            pd_fecpro   IN date,
                            pn_meses    in number,
                            pc_tipana   out char,
                            pn_saldo    out number
                            );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_desembolsos_new(pd_fecpro     in date,
                              pc_analista   in varchar2,
                              pc_codcat     in number,                              
                              pc_tipo       in varchar2,
                              pc_tipana     in varchar2,                              
                              pn_saldo      out number,
                              pn_porpago    out number,
                              pn_bonpago    out number,
                              pn_saldotot   out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_indicadores_new(pd_fecpro   in date,
                              pc_analista in varchar2,
                              pc_sucurs   in number) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_metas_new(pn_codcat in number,
                        pc_tipase in char,
                        pc_tipona in char,                        
                        pn_cresal out number,
                        pn_crecli out number,
                        pn_valse1 out number,
                        pn_valse2 out number,
                        pn_valce1 out number,
                        pn_valce2 out number
                        );
 -------------------------------------------------------------------------------------------------
  Function fn_cr_nivel_excedente(PN_PORCENTAJE IN NUMBER,
                                 PN_TIPO IN NUMBER ) 
                                return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                              
procedure sp_cr_pago_metas_new(pn_codcat in number,
                               pc_tipase in char,
                               pc_tipona in char,   
                               pn_mtosal out number,
                               pn_mtocli out number,
                               pn_mtoret out number);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_retencion(pd_fecpro   in date,
                           pc_analista in varchar2,
                           pc_codage   in number,
                           pc_codcat   in number,
                           pc_tipo     in varchar2,
                           pn_pagotot  out number,
                           pn_pagoret  out number,
                           pn_pagoadi  out number,
                           pn_base1    out number,
                           pn_reten1   out number,
                           pn_porcen1  out number,
                           pn_base2    out number,
                           pn_reten2   out number,
                           pn_porcen2  out number                           
                           );
                               
procedure sp_cr_metamora_new(pc_tipase in char,
                            pn_varmor in number,  
                            pn_pormor in number,
                            pn_facmor out number,
                            pn_mtomor out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_contencion(pd_fecpro   in date,
                           pc_analista in varchar2,
                           pc_codage   in number,
                           pn_pago1    out number,                           
                           pn_factor1  out number,
                           pn_basecon1 out number,
                           pn_conteni1 out number,
                           pn_pago2    out number,                           
                           pn_factor2  out number,
                           pn_basecon2 out number,
                           pn_conteni2 out number,
                           pn_porcon1  out number,                            
                           pn_porcon2  out number                                                      
                           ) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_IAnalista(pd_fecpro   in date,
                           pc_codage   in number   
                           );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_sch_IAnalista(pd_fecpro in date);
 ------------------------------------------------------------------------------
procedure sp_cr_sch_indicadores_new(pd_fecpro in date);
 ------------------------------------------------------------------------------
  Procedure sp_cr_numdoc(pc_analista IN char,
                         pc_numdoc out char);
------------------------------------------------------------------------------                                                                                   
Function fn_cr_Sal_alDIA(pc_analista IN varchar2,
                        pd_fecpro   in date,
                        pn_codage   in number) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_metas_cardia(pn_codcat in number,
                        pn_porcar in number,
                        pn_pagcar out number
                        );
------------------------------------------------------------------------------                                                                                   
procedure sp_cr_TipoAnalista(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pn_codage   in number,
                            pn_sdotot   in number,
                            pn_porsdo   out number,
                            pc_tipoana  out char) ;
------------------------------------------------------------------------------                                                                                                           
 PROCEDURE SP_CR_OBTIENE_PRO_ANALISTAS (
                  USUARIO IN varchar2,
                  FECHAPROCESO IN DATE,
                  ESTADO IN varchar2,
                  PARAMETRO1 OUT VARCHAR2,
                  PARAMETRO2 OUT VARCHAR2,
                  PARAMETRO3 OUT VARCHAR2,
                  PARAMETRO4 OUT VARCHAR2,
                  PARAMETRO5 OUT VARCHAR2,
                  PARAMETRO6 OUT VARCHAR2,
                  PARAMETRO7 OUT VARCHAR2,
                  PARAMETRO8 OUT VARCHAR2,
                  PARAMETRO9 OUT VARCHAR2,
                  PARAMETRO10 OUT VARCHAR2,
                  PARAMETRO11 OUT VARCHAR2,
                  PARAMETRO12 OUT VARCHAR2,
                  PARAMETRO13 OUT VARCHAR2,
                  PARAMETRO14 OUT VARCHAR2,
                  PARAMETRO15 OUT VARCHAR2,
                  PARAMETRO16 OUT VARCHAR2,
                  PARAMETRO17 OUT VARCHAR2,
                  PARAMETRO18 OUT VARCHAR2,
                  PARAMETRO19 OUT VARCHAR2,
                  PARAMETRO20 OUT VARCHAR2,
                  PARAMETRO21 OUT VARCHAR2,
                  PARAMETRO22 OUT VARCHAR2,
                  PARAMETRO23 OUT VARCHAR2,
                  PARAMETRO24 OUT VARCHAR2,
                  PARAMETRO25 OUT VARCHAR2,
                  PARAMETRO26 OUT VARCHAR2,
                  PARAMETRO27 OUT VARCHAR2,
                  PARAMETRO28 OUT VARCHAR2,
                  PARAMETRO29 OUT VARCHAR2,
                  PARAMETRO30 OUT VARCHAR2);
-----------------------------------------------------------------------------------
     procedure sp_cr_inserta_desembolsos_recategorizacion(pd_fecpro in date);             
-----------------------------------------------------------------------------------
     Function fn_cr_analista_desembolso(ve_modulo1 in number, --ecollado 18/01/2023
      ve_sucursal1 in number,
      ve_moneda1 in number,
      ve_papel1 in number,
      ve_cuenta1 in number,
      ve_operacion1 in number,
      ve_subope1 in number,
      ve_tipope1 in number,
      ve_fechaproceso in date) return varchar2;
----------------------------------------------------------------     
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  Procedure sp_cr_inserta_cartera_finmes_I( pd_fecpro in date);

 ---------------------------------------------------------------------

  procedure sp_cr_job_cartera_mes(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_carga_datos_ana(pc_sucurs in varchar2, pd_fecpro in date, pc_usuario in varchar2);

  procedure sp_cr_job_recategoriza;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_consolida(pd_fecpro in date) ;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_inserta_desembolsos_SUC(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                               
  Function fn_cr_verifica_tarea2(pn_paquete in varchar2,
                                 pn_proceso in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_Calculo_Mensual_O(pd_fecpro in date);
 
end PQ_CR_PRODUCTIVIDAD_NUEVA;
/
create or replace package body PQ_CR_PRODUCTIVIDAD_NUEVA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_PRODUCTIVIDAD_NUEVA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.15
  -- Autor de Creación          : DCASTRO
  -- Uso                        : OBTENER PRODUCTIVIDAD DE ANALISTAS DE CREDITOS - OCTUBRE 2016
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2017.07.13
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: sp_cr_cumplimiento
  --                              2017.10.04 DCASTRO modificar continuidad 
  --                              2018.01.15 DCASTRO habilitar productividad diaria
  --                              2018.01.17 DCASTRO se modifico sp_cr_inserta_desembolsos
  --                              2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  --                              2019.09.04 DCASTRO se modifico sp_cr_Calculo_Mensual
  --                            : 2023.11.21 dcastro sp_cr_inserta_desembolsos_recategorizacion se agregó condición de fecha de proceso.
  --                            : 2023.11.22 dcastro se optimizo consulta a variable analista, se reemplazo trim por rpad, se optimizo job sp_cr_job_cartera_mes,sp_cr_inserta_cartera, fn_pa_Sal_recibidoNew, fn_pa_Cli_recibidoNew,fn_pa_Sal_OtorgadoNew,fn_pa_Cli_OtorgadoNew.
  --                              2023.12.05 dcastro sp_cr_cumplimiento, no aplica contencion si es nuevo y menor o igual a 6 meses
  --                              2024.02.16 dcastro sp_cr_cumplimiento, se agrego condición si la base contencion1 = 0 el pago de contencion1 es igual a 0  
  --                              2024.04.24 dcastro sp_cr_meses_age, se modifico conteo de meses por calculo diario
  --                              2024.05.21 dcastro sp_cr_carga_datos_ana, se modificó procedimiento
  --                              2024.09.09 dcastro se agregó excepcion en llamada a dbms_scheduler.set_attribute
  --                              2025.01.15 dcastro se modificaron procesos para control de jobs
  --                              2025.04.30 dcastro se modificó sp_cr_inserta_cartera_diario - dias atraso diario
  --                              2025.05.08 dcastro se modifico sp_cr_inserta_cartera_finmes y sp_cr_inserta_cartera_diario
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_cartera( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_cartera
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_finmes date;
  
  begin
  
    --si existe la fecha deberia eliminarse y despues insertar. REVISAR
    /*delete from jaql965 where jaql965fech = pd_fecpro;
    commit; --2023.11.22 se comento porque ya se encuentra en jobs*/
  
    ld_finmes := last_Day(pd_fecpro);
    if pd_fecpro = ld_finmes then
      --PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_cartera_finmes(pd_fecpro);  --2023.11.22
      begin 
        pq_cr_productividad_nueva.sp_cr_job_cartera_mes(pd_fecpro => pd_fecpro); --2023.11.22 se agrego jobs
      end;

      
    else
      --PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_cartera_diario( pd_fecpro);
    
      begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cartera_diario(pd_fecpro => pd_fecpro);
      end;
    
    end if;
    commit;
  
   /* se comento 2024.04.24 se agrego a procedimiento sp_cr_Carga_job
   --actualiza tralsados
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_traslados_JAQZ455(pd_fecpro);
    end;
  
    ---inserta desembolsos
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_desembolsos(pd_fecpro);
    end;
    --*/
  
  end sp_cr_inserta_cartera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_inserta_cartera_finmes(pn_codsuc in number,
                                         pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_cartera_finmes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA FIN DE MES A JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2025.05.08
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego validacion si modulo es 200 e instancia es 0 para obtener instancia
    -- *****************************************************************
  
    TYPE tp_JAQL114FECH IS TABLE OF JAQL114.JAQL114FECH%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114EMP IS TABLE OF JAQL114.JAQL114EMP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114MOD IS TABLE OF JAQL114.JAQL114MOD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SUC IS TABLE OF JAQL114.JAQL114SUC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114MDA IS TABLE OF JAQL114.JAQL114MDA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PAP IS TABLE OF JAQL114.JAQL114PAP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114CTA IS TABLE OF JAQL114.JAQL114CTA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114OPER IS TABLE OF JAQL114.JAQL114OPER%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SBOP IS TABLE OF JAQL114.JAQL114SBOP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TOP IS TABLE OF JAQL114.JAQL114TOP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114INST IS TABLE OF JAQL114.JAQL114INST%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114ASE IS TABLE OF JAQL114.JAQL114ASE%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114RUBR IS TABLE OF JAQL114.JAQL114RUBR%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SDMN IS TABLE OF JAQL114.JAQL114SDMN%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SDMO IS TABLE OF JAQL114.JAQL114SDMO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114DATR IS TABLE OF JAQL114.JAQL114DATR%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114FVAL IS TABLE OF JAQL114.JAQL114FVAL%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114FVTO IS TABLE OF JAQL114.JAQL114FVTO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PAIS IS TABLE OF JAQL114.JAQL114PAIS%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TDOC IS TABLE OF JAQL114.JAQL114TDOC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114NDOC IS TABLE OF JAQL114.JAQL114NDOC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TCRD IS TABLE OF JAQL114.JAQL114TCRD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SECT IS TABLE OF JAQL114.JAQL114SECT%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114STAT IS TABLE OF JAQL114.JAQL114STAT%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PROM IS TABLE OF JAQL114.JAQL114PROM%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TPCL IS TABLE OF JAQL114.JAQL114TPCL%type INDEX BY PLS_INTEGER;
  
    V_JAQL114FECH tp_JAQL114FECH;
    V_JAQL114EMP  tp_JAQL114EMP;
    V_JAQL114MOD  tp_JAQL114MOD;
    V_JAQL114SUC  tp_JAQL114SUC;
    V_JAQL114MDA  tp_JAQL114MDA;
    V_JAQL114PAP  tp_JAQL114PAP;
    V_JAQL114CTA  tp_JAQL114CTA;
    V_JAQL114OPER tp_JAQL114OPER;
    V_JAQL114SBOP tp_JAQL114SBOP;
    V_JAQL114TOP  tp_JAQL114TOP;
    V_JAQL114INST tp_JAQL114INST;
    V_JAQL114ASE  tp_JAQL114ASE;
    V_JAQL114RUBR tp_JAQL114RUBR;
    V_JAQL114SDMN tp_JAQL114SDMN;
    V_JAQL114SDMO tp_JAQL114SDMO;
    V_JAQL114DATR tp_JAQL114DATR;
    V_JAQL114FVAL tp_JAQL114FVAL;
    V_JAQL114FVTO tp_JAQL114FVTO;
    V_JAQL114PAIS tp_JAQL114PAIS;
    V_JAQL114TDOC tp_JAQL114TDOC;
    V_JAQL114NDOC tp_JAQL114NDOC;
    V_JAQL114TCRD tp_JAQL114TCRD;
    V_JAQL114SECT tp_JAQL114SECT;
    V_JAQL114STAT tp_JAQL114STAT;
    V_JAQL114PROM tp_JAQL114PROM;
    V_JAQL114TPCL tp_JAQL114TPCL;
  
    ln_numreg  number;
    ln_indins  number := 0;
    ln_saldore number;
    ln_saldove number;
    
    ln_instancia number;
    lc_asesor    char(10);
  
  begin
  
    select count(*)
      into ln_numreg
      from JAQL114
     where JAQL114FECH = pd_fecpro -- CONSIDERAR LA CARTERA POR SUCURSAL
     and JAQL114SUC  = pn_codsuc;
    
     --and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);
  
    select JAQL114FECH,
           JAQL114EMP,
           JAQL114MOD,
           JAQL114SUC,
           JAQL114MDA,
           JAQL114PAP,
           JAQL114CTA,
           JAQL114OPER,
           JAQL114SBOP,
           JAQL114TOP,
           JAQL114INST,
           JAQL114ASE,
           JAQL114RUBR,
           JAQL114SDMN,
           JAQL114SDMO,
           JAQL114DATR,
           JAQL114FVAL,
           JAQL114FVTO,
           JAQL114PAIS,
           JAQL114TDOC,
           JAQL114NDOC,
           JAQL114TCRD,
           JAQL114SECT,
           JAQL114STAT,
           JAQL114PROM,
           JAQL114TPCL
      bulk collect
      into V_JAQL114FECH,
           V_JAQL114EMP,
           V_JAQL114MOD,
           V_JAQL114SUC,
           V_JAQL114MDA,
           V_JAQL114PAP,
           V_JAQL114CTA,
           V_JAQL114OPER,
           V_JAQL114SBOP,
           V_JAQL114TOP,
           V_JAQL114INST,
           V_JAQL114ASE,
           V_JAQL114RUBR,
           V_JAQL114SDMN,
           V_JAQL114SDMO,
           V_JAQL114DATR,
           V_JAQL114FVAL,
           V_JAQL114FVTO,
           V_JAQL114PAIS,
           V_JAQL114TDOC,
           V_JAQL114NDOC,
           V_JAQL114TCRD,
           V_JAQL114SECT,
           V_JAQL114STAT,
           V_JAQL114PROM,
           V_JAQL114TPCL
      from JAQL114
     where JAQL114FECH = pd_fecpro
       and JAQL114SUC  = pn_codsuc; -- CONSIDERAR LA CARTERA POR SUCURSAL
       
    --and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);
  
    --Elimina registros de historico del dia actual
    begin
      --insertar diario en historico
      FOR i IN 1 .. ln_numreg loop
        ln_saldore := 0;
        ln_saldove := 0;
      
        if V_JAQL114RUBR(i) is not null then
          if substr(V_JAQL114RUBR(i), 1, 4) in ('1414', '1424') AND
             V_JAQL114STAT(i) <> 33 then
            ln_saldore := V_JAQL114SDMN(i);
          elsif substr(V_JAQL114RUBR(i), 1, 4) in ('1415', '1425') then
            ln_saldove := V_JAQL114SDMN(i);
          else
            ln_saldore := 0;
            ln_saldove := 0;
          end if;
        end if;

        --2025.05.08  
        ln_instancia := V_JAQL114INST(i);
        lc_asesor := V_JAQL114ASE(i); 

        --si modulo es 200 y no existe instancia
        if V_JAQL114MOD(i) = 200 and ln_instancia = 0 then
              begin        
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa = rel.r2cod  
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
                       and rel.r1mod = V_JAQL114MOD(i)
                       and rel.r1suc = V_JAQL114SUC(i)
                       and rel.r1mda = V_JAQL114MDA(i)
                       and rel.r1pap = V_JAQL114PAP(i)
                       and rel.r1cta = V_JAQL114CTA(i)
                       and rel.r1oper= V_JAQL114OPER(i)
                       and rel.r1sbop= V_JAQL114SBOP(i)
                       and rel.r1tope= V_JAQL114TOP(i);
                  --2016.08.09        
                   if nvl(ln_instancia,0) = 0 then 
                       begin        
                            select max(xw2.xwfprcins)
                              into ln_instancia
                              From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
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
                               and rel.r1mod = V_JAQL114MOD(i)
                               and rel.r1suc = V_JAQL114SUC(i)
                               and rel.r1mda = V_JAQL114MDA(i)
                               and rel.r1pap = V_JAQL114PAP(i)
                               and rel.r1cta = V_JAQL114CTA(i)
                               and rel.r1oper= V_JAQL114OPER(i)
                               and rel.r1sbop= V_JAQL114SBOP(i)
                               and rel.r1tope= V_JAQL114TOP(i);
           
                      exception when no_Data_found then
                         ln_instancia := 0;       
                       end;        
                     end if;  
               end; 
               begin
                 select s.sng001ase
                     into lc_asesor
                     from sng001 s
                     where s.sng001inst = ln_instancia;
                exception when others then
                      lc_asesor := ''; 
                end;
                
                

        end if;
       --2025.05.08
      
        
        --IF  V_JAQL114MOD(i)= 33 or ( substr(V_JAQL114TCRD(i),1,11) <> 'CORPORATIVO' ) then  --CONSIDERAR CARTERA DIFERENTE DE CORPORATIVOS
        IF (V_JAQL114MOD(i) = 200 and V_JAQL114SDMN(i) = 0) or
           (V_JAQL114MOD(i) = 33 and V_JAQL114STAT(i) = 99) then
          --si credito es judicial y tiene capital 0 no considerar, castigado cancelado tampoco considerar
          null;
        else
          --insertar diario
          begin
            insert into JAQL965
              (JAQL965FECH,
               JAQL965EMP,
               JAQL965MOD,
               JAQL965SUC,
               JAQL965MDA,
               JAQL965PAP,
               JAQL965CTA,
               JAQL965OPER,
               JAQL965SBOP,
               JAQL965TOP,
               JAQL965INST,
               JAQL965ASE,
               JAQL965RUBR,
               JAQL965SDMN,
               JAQL965SDMO,
               JAQL965DATR,
               JAQL965FVAL,
               JAQL965FVTO,
               JAQL965PAIS,
               JAQL965TDOC,
               JAQL965NDOC,
               JAQL965TCRD,
               JAQL965SECT,
               JAQL965STAT,
               JAQL965PROM,
               JAQL965TPCL,
               JAQL965SDVE,
               JAQL965SDRE)
            VALUES
              (V_JAQL114FECH(i),
               V_JAQL114EMP(i),
               V_JAQL114MOD(i),
               V_JAQL114SUC(i),
               V_JAQL114MDA(i),
               V_JAQL114PAP(i),
               V_JAQL114CTA(i),
               V_JAQL114OPER(i),
               V_JAQL114SBOP(i),
               V_JAQL114TOP(i),
               ln_instancia,--2025.05.08 V_JAQL114INST(i),
               lc_asesor,--2025.05.08 V_JAQL114ASE(i),
               V_JAQL114RUBR(i),
               V_JAQL114SDMN(i),
               V_JAQL114SDMO(i),
               V_JAQL114DATR(i),
               V_JAQL114FVAL(i),
               V_JAQL114FVTO(i),
               V_JAQL114PAIS(i),
               V_JAQL114TDOC(i),
               V_JAQL114NDOC(i),
               V_JAQL114TCRD(i),
               V_JAQL114SECT(i),
               V_JAQL114STAT(i),
               V_JAQL114PROM(i),
               V_JAQL114TPCL(i),
               ln_saldove,
               ln_saldore);
          exception
            when no_data_found then
              null;
            
          end;
          ln_indins := ln_indins + 1;
          if ln_indins >= 5000 then
            ln_indins := 0;
            commit;
          end if;
        
          --END IF; --DIFERENTE COORPORATIVOS      
        END IF;
      end loop;
      commit;
    
    end;
  
    /*delete from SNG057_201X  where sng057fpro = pd_fecpro;
    
    INSERT INTO SNG057_201X  
     SELECT sng055emp, sng057usr, sng055car, sng057aut, sng057sup, sng057ini, sng057fin, sng057jef, 
     sng057wkf, sng057prc, sng057tsk, pd_fecpro FROM SNG057; 
    commit; */
  
  end sp_cr_inserta_cartera_finmes;
  ---------------------------------------------------------------------

  procedure sp_cr_job_cartera_diario(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    lc_hostname varchar2(64);
 

    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
   
    
    cursor zona is
      select regcod, regnom from fst810 where regcod < 100;
  
  begin
    
 
    lc_paquete    := 'PQ_CR_PRODUCTIVIDAD_NUEVA';
    lc_proceso    := 'sp_cr_inserta_cartera_diario';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  


 
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
      end;   
 
   --2025.01.15 determina numero de jobs
   begin
     select x.tp1nro1
      into lb_njobs
      from fst198 x
     where x.TP1COD = 1
       and x.TP1COD1 = 11144
       and x.TP1CORR1 = 10 
       and x.tp1corr2 = 3
       and x.tp1corr3 = 1;
   exception when others then
     lb_njobs := 50;
   end;
   
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
            null;  
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --antes de la carga eliminar DATA
    delete from JAQL965 where JAQL965FECH = pd_fecpro;
    commit;
  
    ---carga diaria
    for i in zona loop
      ln_ini      := i.regcod;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_cartera_diario(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
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
            
    
      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr 
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr 
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


    
    end loop;

    --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs  
  
  end sp_cr_job_cartera_diario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_inserta_cartera_diario(pn_codzon in number,
                                         pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_cartera_diario
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA DIARIA A JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.05.29
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico ld_Fecpro = pd_fecpro + 1
    --                              se modifico busqueda en FSD010  
    --                              2014.06.03 DCASTRO - Se comentó llamada a proceso sp_cr_inserta_castigados.
    --                              2014.06.04 DCASTRO - Se descomento modulo 33 para carga de jaql964           
    --                              2014.06.25 DCASTRO - se comento jaql965sec para agrupamiento.    
    --                              2018.01.09 DCASTRO - se habilito carga diaria
    --                              2025.04.30 DCASTRO - se agrego -1 porque considera 1 dias mas en diario
    --                              2025.08.08 DCASTRO -  Se agrego validacion si modulo es 200 e instancia es 0 para obtener instancia
    -- *****************************************************************
  
    cursor creditos(ld_fecpro in date) is
      select JAQL964FEC - 1 JAQL964FEC,
             JAQL964PGCOD,
             JAQL964MOD,
             JAQL964SUC,
             JAQL964MDA,
             JAQL964CTA,
             JAQL964OPE,
             JAQL964SOB,
             JAQL964TOP,
             JAQL964INS,
             JAQL964USU,
             sum(JAQL964SAC * -1) JAQL964SAC,
             sum(JAQL964SAO * -1) JAQL964SAO,
             JAQL964DIA,
             JAQL964PAI,
             JAQL964TID,
             JAQL964DOC,
             sum(JAQL964SDVE * -1) JAQL964SDVE,
             sum(JAQL964SDRE * -1) JAQL964SDRE,
             JAQL964EST,
             JAQL964PRO
        from JAQL964
       where JAQL964FEC = ld_fecpro --CONSIDERAR TODA LA CARTERA
         and JAQL964MOD not in (117)
         and JAQL964reg = pn_codzon
      -- and JAQL964MOD not in (108, /*33,*/ 117) and (JAQL964MOD <> 106 Or JAQL964TOP <> 30)
       group by JAQL964FEC,
                JAQL964PGCOD,
                JAQL964MOD,
                JAQL964SUC,
                JAQL964MDA,
                JAQL964CTA,
                JAQL964OPE,
                JAQL964SOB,
                JAQL964TOP,
                JAQL964INS,
                JAQL964USU,
                JAQL964DIA,
                JAQL964PAI,
                JAQL964TID,
                JAQL964DOC,
                JAQL964EST,
                JAQL964PRO /*,
            JAQL964SEC*/
      ;
  
    ln_indins number := 0;
    ld_fecval date;
    ld_fecvto date;
    ld_Fecpro date;
    
    ln_instancia number;
    lc_asesor    char(10); 
    lc_coderr    varchar2(100);   
    lc_msgerr    varchar2(1000);  

  begin
  
    ld_fecpro := pd_fecpro + 1;
  
    --Elimina registros de historico del dia actual
    begin
    
      --insertar diario en historico
      FOR i IN creditos(ld_fecpro) loop
      
        IF (i.JAQL964MOD = 200 and i.JAQL964SAC = 0) or
           (i.JAQL964MOD = 33 and i.JAQL964EST = 99) or
           (i.JAQL964MOD = 200 and i.JAQL964EST = 99) then
          --si credito es judicial y tiene capital 0 no considerar , castigado cancelado tampoco considerar
          null;
        else
          begin
            select f.aofval, f.aofvto
              into ld_fecval, ld_fecvto
              from FSD010 f
             where f.PGCOD = 1
               and f.AOMOD = i.JAQL964MOD
               and f.AOMDA = i.JAQL964MDA
               and f.AOPAP = 0
               and f.AOCTA = i.JAQL964CTA
               and f.AOSUC = i.JAQL964SUC
               and f.AOOPER = i.JAQL964OPE
               and f.AOSBOP = i.JAQL964SOB
               and f.aostat = i.JAQL964EST --0   --2016.02.08 se agrego variable estado
               and rownum < 2;
          exception
            when no_data_found then
              ld_fecval := null;
              ld_fecvto := null;
          end;

        --2025.05.08  
        ln_instancia := i.JAQL964INS;
        lc_asesor    := i.JAQL964USU; 

        --si modulo es 200 y no existe instancia
        if i.JAQL964MOD = 200 and ln_instancia = 0 then
              begin        
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa = rel.r2cod  
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
                     and rel.r1mod = i.JAQL964MOD
                     and rel.r1suc = i.JAQL964SUC
                     and rel.r1mda = i.JAQL964MDA
                     and rel.r1pap = 0
                     and rel.r1cta = i.JAQL964CTA
                     and rel.r1oper= i.JAQL964OPE
                     and rel.r1sbop= i.JAQL964SOB
                     and rel.r1tope= i.JAQL964TOP;
                  --2016.08.09        
                   if nvl(ln_instancia,0) = 0 then 
                       begin        
                            select max(xw2.xwfprcins)
                              into ln_instancia
                              From Fsr011 rel  join   xwf700 xw2 on xw2.xwfempresa   = rel.r2cod  
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
                               and rel.r1mod = i.JAQL964MOD
                               and rel.r1suc = i.JAQL964SUC
                               and rel.r1mda = i.JAQL964MDA
                               and rel.r1pap = 0
                               and rel.r1cta = i.JAQL964CTA
                               and rel.r1oper= i.JAQL964OPE
                               and rel.r1sbop= i.JAQL964SOB
                               and rel.r1tope= i.JAQL964TOP;
           
                       exception when no_Data_found then
                         ln_instancia := 0;       
                       end;        
                     end if;  
               end; 
               begin
                 select s.sng001ase
                     into lc_asesor
                     from sng001 s
                     where s.sng001inst = ln_instancia;
                exception when others then
                      lc_asesor := ''; 
                end;
                

        end if;
       --2025.05.08        
        
          begin
            --insertar diario
            insert into JAQL965
              (JAQL965FECH,
               JAQL965EMP,
               JAQL965MOD,
               JAQL965SUC,
               JAQL965MDA,
               JAQL965PAP,
               JAQL965CTA,
               JAQL965OPER,
               JAQL965SBOP,
               JAQL965TOP,
               JAQL965INST,
               JAQL965ASE,
               JAQL965RUBR,
               JAQL965SDMN,
               JAQL965SDMO,
               JAQL965DATR,
               JAQL965FVAL,
               JAQL965FVTO,
               JAQL965PAIS,
               JAQL965TDOC,
               JAQL965NDOC,
               JAQL965SDRE,
               JAQL965SDVE,
               JAQL965STAT,
               JAQL965TCRD)
            VALUES
              (i.JAQL964FEC,
               i.jaql964pgcod,
               i.JAQL964MOD,
               i.JAQL964SUC,
               i.JAQL964MDA,
               0,
               i.JAQL964CTA,
               i.JAQL964OPE,
               i.JAQL964SOB,
               i.JAQL964TOP,
               ln_instancia,  --2025.05.08 dcastro    i.JAQL964INS,
               lc_asesor,     --2025.05.08 dcastro    i.JAQL964USU,
               1, --V_JAQL964RUBR(i),
               i.JAQL964SAC,
               i.JAQL964SAO,
               i.JAQL964DIA - 1,   --2025.04.30 se agrego -1 porque considera 1 dias mas en diario
               ld_fecval,
               ld_fecvto,
               i.JAQL964PAI,
               i.JAQL964TID,
               i.JAQL964DOC,
               i.JAQL964SDRE,
               i.JAQL964SDVE,
               i.JAQL964EST,
               substr(i.JAQL964PRO, 1, 20));
            commit;
          exception
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
          end;
          ln_indins := ln_indins + 1;
          if ln_indins >= 5000 then
            ln_indins := 0;
            commit;
          end if;
        
        END IF;
      
      end loop;
      commit;
    end;
  
    --inserta SNG
    --2018.01.09  
    delete from SNG057_201X where sng057fpro = pd_fecpro;
  
    INSERT INTO SNG057_201X
      SELECT sng055emp,
             sng057usr,
             sng055car,
             sng057aut,
             sng057sup,
             sng057ini,
             sng057fin,
             sng057jef,
             sng057wkf,
             sng057prc,
             sng057tsk,
             pd_fecpro
        FROM SNG057;
  
    commit;
    ---
  
  end sp_cr_inserta_cartera_diario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_carga(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
    
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);

    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
 
    
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    

    lc_paquete    := 'PQ_CR_PRODUCTIVIDAD_NUEVA';
    lc_proceso    := 'sp_cr_carga_datos';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  
    
  
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
       null;  
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ld_finmes := last_Day(pd_fecpro);
 

    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
    
     
    --2025.01.15 determina numero de jobs
    begin
       select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10 
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
     exception when others then
       lb_njobs := 50;
     end;
 
   --2024.04.24 INICIO se agrego procedimientos
   --actualiza traslados
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_traslados_JAQZ455(pd_fecpro);
    end;
  
    ---inserta desembolsos
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_desembolsos(pd_fecpro);
    end;
    --2024.04.24 FIN se agrego procedimientos
  
  
    --antes de la carga eliminar DATA
    delete from JAQL600 where JAQL600FPRO = pd_fecpro;
    commit;

  
    if pd_fecpro <> ld_finmes then
    
      begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
      end;
    
      ---carga diaria
      for i in sucursal loop
        ln_ini      := i.sucurs;
        lc_variable := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_carga_datos_diario(' ||
                       ln_ini || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD'') );' || ' End;';
        ln_job      := ln_job + 1;
      
        --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          --2019.07.22 cambio              
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 2,
                          force     => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
        INSERT INTO Tab_jobs
          (c_Codage, n_Numer1, c_detjob)
        VALUES
          ('PRD', ln_ini, lc_variable);
        COMMIT;
      
        
      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


      
      end loop;
    
    else

/* 2023.08.29 descomentar    
      begin
        -- Call the procedure
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
      end;
*/    
      ---carga mensual
      for i in sucursal loop
        ln_ini      := i.sucurs;
        lc_variable := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_carga_datos(' ||
                       ln_ini || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD'') );' || ' End;';
        ln_job      := ln_job + 1;
      
        --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          --2019.07.22 cambio
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          instance  => 2,
                          force     => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
        INSERT INTO Tab_jobs
          (c_Codage, n_Numer1, c_detjob)
        VALUES
          ('PRD', ln_ini, lc_variable);
        COMMIT;
      
      
      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


      
      end loop;
    
    end if;
    
    --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs      
  
  end sp_cr_job_carga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_agencia(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_agencia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.13
    -- Autor de Creación          : 
    -- Uso                        : INSERTA AGENCIa JAQL966
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.07.16
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico insercion mensual
    -- *****************************************************************
    ld_fecfin date;
    ld_fecini date;
    ld_finmes date;
  
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    ld_fecfin := pd_fecpro; --last_Day(pd_fecpro);
  
    delete from jaql966
     where JAQL966FEC >= ld_fecini
       and JAQL966FEC <= ld_fecfin;
  
    ld_finmes := last_Day(pd_fecpro);
    if pd_fecpro <> ld_finmes then
    
      --diario
      insert into jaql966
        (JAQL966FEC,
         JAQL966COD,
         JAQL966NOM,
         JAQL966CAR,
         JAQL966TIP,
         JAQL966SUC,
         JAQL966STS,
         JAQL966USR)
        select ld_fecfin,
               AGTECOD,
               AGTENOM,
               CARGOCOD,
               AGTETIP,
               AGTESUC,
               AGTESTS,
               AGTEUSR
          from fst156;
    else
      --mensual
      insert into jaql966
        (JAQL966FEC,
         JAQL966COD,
         JAQL966NOM,
         JAQL966CAR,
         JAQL966TIP,
         JAQL966SUC,
         JAQL966STS,
         JAQL966USR)
      --select ld_fecfin, AGTECOD,AGTENOM,CARGOCOD,AGTETIP,AGTESUC,AGTESTS,AGTEUSR from fst156_201X;
        select ld_fecfin,
               j.jaqy830codid,
               substr(j.jaqy830ana, 1, 30),
               null,
               null,
               904 /*j.jaqy830codage*/,
               'S',
               trim(j.jaqy830codana)
          from jaqy830 j
         where j.jaqy830est = 'S';
    end if;
  
    commit;
  
  end sp_cr_inserta_agencia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos_diario(pc_sucurs in varchar2,
                                     pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL600
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.11.27
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico llamada a calculo saldo maximo
    --                            : 2023.11.13 DCASTRO se agrego control de excepcion para carga 
    -- *****************************************************************
  
    cursor creditos(lc_sucurs varchar2, ld_fecpro date) is
    
      select /*+index_ss(a) */
       a.jaql965ase, -- cod_analista, 
       a.jaql965suc agencia,
       sum(a.jaql965sdmn) Saldo_cartera,
       count(distinct a.jaql965ndoc) Nro_clientes --,
        from JAQL965 a
       where a.jaql965fech = ld_fecpro
         and a.jaql965suc = lc_sucurs --QUITAR COMENTARIO
         and a.jaql965mod not in (108, 33 /*, 200*/)
         and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
            --AND TRIM(a.jaql965ase) in ('EMACHADO')--,'DCASTILLOM','JCAMPOSP','AREYES','LMEZAA','NALTAMIRAN')-- in ( 'PLAGOS','SSOTOMAYOR'  )--in ('JGALVEZ' , 'CPALOMINOD')  --COMENTAR --08Jul2015
         and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j) --excluir a tabla de EXCEPCIONEs
         and (a.jaql965cta, a.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
       group by a.jaql965ase, a.jaql965suc;
  
    lc_Tipo_analista    jaql577.jaql577tipo%type;
    ln_nummes           number := 0;
    ln_Saldo_Otorgado   number;
    ln_Saldo_Recibido   number;
    ln_Cliente_Otorgado number;
    ln_Cliente_recibido number;
    ln_Por_Mora         number;
    ln_sal_mes_anterior number;
    ln_cli_mes_anterior number;
    lc_Tipo_ana         char(1);

  
    ln_saltot           number;
    ln_clitot           number;
    ln_salmor           number;
    ln_saljud           number;

    ln_salcas           number;
    ln_salrec           number;
    ln_numrec           number;
    ln_nuevo_sal        number;
    ln_nuevo_cli        number;
    ln_agencia          number; --2016.05.12
    lc_tipo_NEO         char(1);
    ln_agencia_analista number;
    ln_clicas           number;
    ln_salven           number;
    ln_cliven           number;
    ln_numage           number; --2017.05.05
    ln_agencia_MESA     number;
    ln_porconvenio      number;
    lc_desagencia       varchar2(50);
    lc_descategoria     varchar2(50); 
    ln_saldia           number;

    lc_coderr varchar2(1000);  --2023.11.13
    lc_deserr varchar2(1000);  
 
  begin
  
    for i in creditos(pc_sucurs, pd_fecpro) loop
    
      --2017.03.21 obtiene agencia de mayor numero de desembolsos o agencia en la que posee mas creditos
      ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,
                                                                    pd_fecpro   => pd_fecpro);
    
      ---analista cesado considera agencia del mes anterior
      /*       if ln_agencia_analista = 904 then
         --agencia del mes anterior       
          ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior( i.jaql965ase,pd_fecpro);
      end if;*/
      ln_agencia := i.agencia;
      ---
    
      --validando si solo tiene una agencia y desembolsos no corresponden a la agencia
      if ln_agencia <> ln_agencia_analista then
      
        begin
        
          select count(distinct a.jaql965suc) agencia
            into ln_numage
            from JAQL965 a
           where a.jaql965fech = pd_fecpro
             and a.jaql965mod not in (108, 33 /*, 200*/)
             and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
             AND a.jaql965ase = i.jaql965ase
             and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
                 (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                    from jaql970 j) --excluir a tabla de EXCEPCIONEs
             and (a.jaql965cta, a.jaql965oper) not in
                 (select bccta, bcoper from jaqz498); --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
        
        exception
          when others then
            ln_numage := 0;
        end;
      
        if ln_numage = 1 then
          ln_agencia_analista := i.agencia;
        end if;
      
      end if;
    
      if ln_agencia = ln_agencia_analista then
        -- si las agencias son iguales, corresponde a agencia vigente del analista
        --
      
        ln_Saldo_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_otorgadoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
        ln_Saldo_Recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_recibidoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
      
        ln_Cliente_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_otorgadoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
        ln_Cliente_recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_recibidoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
      
        --compara la agencia del mes anterior, si son de la misma agencia considera otorgados sino NO 
        ln_agencia_MESA :=  --PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,last_day(add_months(trunc(pd_fecpro), -1))); 
         PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior(i.jaql965ase,
                                                                           pd_fecpro);
      
        if ln_agencia_MESA <> ln_agencia then
          ln_Saldo_Otorgado   := 0;
          ln_Cliente_Otorgado := 0;
          ln_nummes           := 1;
        else
          ln_nummes := 2;
        end if;
  
        ln_saldia := pq_cr_productividad_nueva.fn_cr_sal_aldia(i.jaql965ase,
                                                                        pd_fecpro,
                                                                        ln_agencia);

        ln_saljud := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_judicial(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia);
        ln_salmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_mora(i.jaql965ase,
                                                               pd_fecpro,
                                                               ln_agencia); --saldo mora  > 15 dias
        ln_salcas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
        ln_clicas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_cli_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cartera_vendida(i.jaql965ase,
                                                         ln_agencia,
                                                         pd_fecpro,
                                                         ln_salven,
                                                         ln_cliven);
        end;
      
        ln_salrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_legal(i.jaql965ase,
                                                                pd_fecpro,
                                                                ln_agencia); --saldo de creditos en recuperacion legal
        ln_numrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_num_saldo_legal(i.jaql965ase,
                                                                    pd_fecpro,
                                                                    ln_agencia); --saldo de creditos en recuperacion legal
      
        ln_saltot    := i.Saldo_cartera + ln_Saldo_Otorgado -
                        ln_Saldo_Recibido;
        ln_clitot    := i.Nro_clientes + ln_Cliente_Otorgado -
                        ln_Cliente_recibido;
        ln_nuevo_sal := i.Saldo_cartera + ln_salcas + ln_salven;
        ln_nuevo_cli := i.Nro_clientes + ln_clicas + ln_cliven;
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => i.jaql965ase,
                                                             pd_fecpro   => last_day(add_months(trunc(pd_fecpro),
                                                                                                -1)),
                                                             pc_codage   => ln_agencia,
                                                             pn_salant   => ln_sal_mes_anterior,
                                                             pn_cliant   => ln_cli_mes_anterior);
        end;
      
        ln_Por_Mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_nueva_mora(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia /*i.agencia*/,
                                                                 ln_salmor,
                                                                 ln_saljud,
                                                                 ln_nuevo_sal);
      
        --2016
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_categoriarrhh(pc_jaqy830codana => i.jaql965ase,
                                                       pd_fecpro        => pd_fecpro,
                                                       pn_jaqy830codcat => lc_Tipo_analista,
                                                       pc_jaqy830tipase => lc_Tipo_ana);
        end;

        --2023
        --obtener tipo analista Pyme/Convenio nuevo calculo
        begin
                  pq_cr_productividad_nueva.sp_cr_tipoanalista(pc_analista => i.jaql965ase,
                                                                  pd_fecpro => pd_fecpro,
                                                                  pn_codage => ln_agencia,
                                                                  --pn_sdotot => ln_saltot,
                                                                  pn_sdotot => i.Saldo_cartera,
                                                                  pn_porsdo => ln_porconvenio,
                                                                  pc_tipoana => lc_Tipo_ana);
        end;

        
        --tipo agencia NEO
        --lc_tipo_NEO := trim(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_tipo_agencia_metas(ln_agencia /*i.agencia*/,
        -- pd_fecpro));
        begin 
          select f.scnom
            into lc_desagencia
            from fst001 f
           where f.pgcod = 1
             and f.sucurs = ln_agencia;                                                                    
        exception when others then
            lc_desagencia    := null;
        end;     

 
        begin
           select j.jaqy830catana
             into lc_descategoria 
             from jaqy830 j
            where j.jaqy830codana = i.jaql965ase
              and j.jaqy830est = 'S'; 
        exception when others then
            lc_descategoria  := null;
        end;     
          
     
        lc_tipo_NEO := null;
  
        --2023.11.13
        if ln_Por_Mora >999 then
           ln_Por_Mora := 999;
        end if;
        if ln_porconvenio > 999 then
           ln_porconvenio := 999;        
        end if;
        --2023.11.13
  
        
        begin     --2023.11.13
          insert into JAQL600
            (JAQL600FPRO,
             JAQL600USU,
             JAQL600AGE,
             JAQL600MANT,
             JAQL600CODCAT,
             JAQL600TASE,
             JAQL600SDO,
             JAQL600NCL,
             JAQL600SDM,
             JAQL600PMRA,
             JAQL600SOTO,
             JAQL600SREC,
             JAQL600COTO,
             JAQL600CREC,
             JAQL600SRL,
             JAQL600NRL,
             JAQL600SANT,
             JAQL600CANT,
             JAQL600SDCA,
             JAQL600SDJU, /*JAQL600CRSA,JAQL600CRCL,JAQL600IDES,JAQL600PDES,*/
             JAQL600CLTOT,
             JAQL600SDTOT,
             JAQL600NEO,
             JAQL600EST,
             jaql600crsa,
             jaql600crcl,
             jaql600ides,
             jaql600pdes,
             jaql600mtsa,
             jaql600mtcl,
             jaql600mtre,
             jaql600mtmr,
             jaql600psal,
             jaql600pcli,
             jaql600pret,
             jaql600pmor,
             jaql600pvar,
             jaql600pjca,
             jaql600pjcas,
             jaql600cmra,
             jaql600bsal,
             jaql600bcli,
             jaql600bmra,
             jaql600btri,
             jaql600totpa,
             jaql600ccam,
             jaql600vcam,
             jaql600tcam,
             jaql600aux1,
             jaql600aux2,
             jaql600aux3,
             jaql600aux4,
             jaql600aux5,
             jaql600aux6,
             jaql600pcam,
             jaql600pord,
             jaql600mtod,
             jaql600vmor,
             jaql600csal,
             jaql600esal,
             jaql600ccli,
             jaql600ecli,
             jaql600cret,
             jaql600eret,
             jaql600posa,
             jaql600pocl,
             jaql600exsa,
             jaql600excl,
             jaql600exre,
             jaql600pore,
             jaql600bare,
             jaql600more,
             jaql600pmoa,
             JAQL600CAVE,
             JAQL600CLVE,
             jaql600sdodi,
             jaql600pordi,
             jaql600pagdi,
             jaql600porco,
             jaql600desag,
             jaql600desca
             )
          values
            (pd_fecpro,
             i.jaql965ase,
             ln_agencia,
             ln_nummes,
             lc_Tipo_analista,
             lc_Tipo_ana,
             ln_nuevo_sal,
             ln_nuevo_cli,
             ln_salmor,
             ln_Por_Mora,
             ln_Saldo_Otorgado,
             ln_Saldo_Recibido,
             ln_Cliente_Otorgado,
             ln_Cliente_recibido,
             ln_salrec,
             ln_numrec,
             ln_sal_mes_anterior,
             ln_cli_mes_anterior,
             ln_Salcas,
             ln_saljud,
             ln_clitot,
             ln_saltot,
             lc_tipo_NEO,
             'S',
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             ln_salven,
             ln_cliven,
             ln_saldia,
             0,
             0,
             ln_porconvenio,
             lc_desagencia,
             lc_descategoria
             
             );
        
          commit;
        exception when others then -- 2023.11.13 se agrego excepcion
           lc_coderr := sqlcode;
           lc_deserr := sqlerrm;
        end;           ---- 2023.11.13 
      
      end if; --fiN de validacion de agencia del credito con agencia actual del analista
    
    end loop;
  
  end sp_cr_carga_datos_diario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_sucurs in varchar2, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL600
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 2023.11.13 DCASTRO se agrego control de excepcion para carga 
    -- *****************************************************************
  
    cursor creditos(lc_sucurs varchar2, ld_fecpro date) is
    
      select /*+index_ss(a) */
       a.jaql965ase, -- cod_analista, 
       a.jaql965suc agencia,
       sum(a.jaql965sdmn) Saldo_cartera,
       count(distinct a.jaql965ndoc) Nro_clientes --,
        from JAQL965 a
       where a.jaql965fech = ld_fecpro
         and a.jaql965suc = lc_sucurs --QUITAR COMENTARIO
         and a.jaql965mod not in (108, 33 /*, 200*/)
         and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
      -----AND TRIM(a.jaql965ase) in ('HAPAZAAG')--('SBALABARCA')--'ABERROCAL')--,'DCASTILLOM','JCAMPOSP','AREYES','LMEZAA','NALTAMIRAN')-- in ( 'PLAGOS','SSOTOMAYOR'  )--in ('JGALVEZ' , 'CPALOMINOD')  --COMENTAR --08Jul2015
         and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j) --excluir a tabla de EXCEPCIONEs
         and (a.jaql965cta, a.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
       group by a.jaql965ase, a.jaql965suc;
  
    lc_Tipo_analista    jaql577.jaql577tipo%type;
    ln_nummes           number := 0;
    ln_Saldo_Otorgado   number;
    ln_Saldo_Recibido   number;
    ln_Cliente_Otorgado number;
    ln_Cliente_recibido number;
    ln_Por_Mora         number;

    ln_sal_mes_anterior number;
    ln_cli_mes_anterior number;

    lc_Tipo_ana         char(1);

  
    ln_saltot           number;
    ln_clitot           number;
    ln_salmor           number;
    ln_saljud           number;

    ln_salcas           number;
    ln_salrec           number;
    ln_numrec           number;
    ln_nuevo_sal        number;
    ln_nuevo_cli        number;
    ln_agencia          number; --2016.05.12
    lc_tipo_NEO         char(1);
    ln_agencia_analista number;
    ln_clicas           number;
    ln_salven           number;
    ln_cliven           number;
    ln_numage           number; --2017.05.05
    ln_agencia_MESA     number;
    ln_saldia           number;
    ln_porconvenio      number;
    lc_desagencia       varchar2(50);
    lc_descategoria     varchar2(50);
  
    lc_coderr varchar2(1000);
    lc_deserr varchar2(1000); 
  
  begin
  
    for i in creditos(pc_sucurs, pd_fecpro) loop
    
      --2017.03.21 obtiene agencia de mayor numero de desembolsos o agencia en la que posee mas creditos
      ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,
                                                                    pd_fecpro   => pd_fecpro);
    
      ---analista cesado considera agencia del mes anterior
      /*       if ln_agencia_analista = 904 then
         --agencia del mes anterior       
          ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior( i.jaql965ase,pd_fecpro);
      end if;*/
      ln_agencia := i.agencia;
      ---
    
      --validando si solo tiene una agencia y desembolsos no corresponden a la agencia
      if ln_agencia <> ln_agencia_analista then
      
        begin
        
          select count(distinct a.jaql965suc) agencia
            into ln_numage
            from JAQL965 a
           where a.jaql965fech = pd_fecpro
             and a.jaql965mod not in (108, 33 /*, 200*/)
             and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
             AND a.jaql965ase = i.jaql965ase
             and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
                 (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                    from jaql970 j) --excluir a tabla de EXCEPCIONEs
             and (a.jaql965cta, a.jaql965oper) not in
                 (select bccta, bcoper from jaqz498); --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
        
        exception
          when others then
            ln_numage := 0;
        end;
      
        if ln_numage = 1 then
          ln_agencia_analista := i.agencia;
        end if;
      
      end if;
    
      if ln_agencia = ln_agencia_analista then
        -- si las agencias son iguales, corresponde a agencia vigente del analista
        --
      
        ln_Saldo_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_otorgadoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
        ln_Saldo_Recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_recibidoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
      
        ln_Cliente_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_otorgadoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
        ln_Cliente_recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_recibidoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
                                   
      
        --compara la agencia del mes anterior, si son de la misma agencia considera otorgados sino NO 
        ln_agencia_MESA :=  --PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,last_day(add_months(trunc(pd_fecpro), -1))); 
         PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior(i.jaql965ase,
                                                                           pd_fecpro);
      
        if ln_agencia_MESA <> ln_agencia then
          ln_Saldo_Otorgado   := 0;
          ln_Cliente_Otorgado := 0;
          ln_nummes           := 1;
        else
          ln_nummes := 2;
        end if;
      
        ln_saldia := pq_cr_productividad_nueva.fn_cr_sal_aldia(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);

      
        ln_saljud := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_judicial(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia);
        ln_salmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_mora(i.jaql965ase,
                                                               pd_fecpro,
                                                               ln_agencia); --saldo mora  > 15 dias
        ln_salcas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
        ln_clicas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_cli_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cartera_vendida(i.jaql965ase,
                                                         ln_agencia,
                                                         pd_fecpro,
                                                         ln_salven,
                                                         ln_cliven);
        end;
      
        ln_salrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_legal(i.jaql965ase,
                                                                pd_fecpro,
                                                                ln_agencia); --saldo de creditos en recuperacion legal
        ln_numrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_num_saldo_legal(i.jaql965ase,
                                                                    pd_fecpro,
                                                                    ln_agencia); --saldo de creditos en recuperacion legal
      
        ln_saltot    := i.Saldo_cartera + ln_Saldo_Otorgado -
                        ln_Saldo_Recibido;
        ln_clitot    := i.Nro_clientes + ln_Cliente_Otorgado -
                        ln_Cliente_recibido;
        ln_nuevo_sal := i.Saldo_cartera + ln_salcas + ln_salven;
        ln_nuevo_cli := i.Nro_clientes + ln_clicas + ln_cliven;
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => i.jaql965ase,
                                                             pd_fecpro   => last_day(add_months(trunc(pd_fecpro),
                                                                                                -1)),
                                                             pc_codage   => ln_agencia,
                                                             pn_salant   => ln_sal_mes_anterior,
                                                             pn_cliant   => ln_cli_mes_anterior);
        end;
      
        ln_Por_Mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_nueva_mora(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia /*i.agencia*/,
                                                                 ln_salmor,
                                                                 ln_saljud,
                                                                 ln_nuevo_sal);
      
        --2016
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_categoriarrhh(pc_jaqy830codana => i.jaql965ase,
                                                       pd_fecpro        => pd_fecpro,
                                                       pn_jaqy830codcat => lc_Tipo_analista,
                                                       pc_jaqy830tipase => lc_Tipo_ana);
        end;
        
        --obtener tipo analista Pyme/Convenio nuevo calculo
        begin
                  pq_cr_productividad_nueva.sp_cr_tipoanalista(pc_analista => i.jaql965ase,
                                                                  pd_fecpro => pd_fecpro,
                                                                  pn_codage => ln_agencia,
                                                                  --pn_sdotot => ln_saltot, 2025.01.04
                                                                  pn_sdotot => i.Saldo_cartera, --2025.01.04
                                                                  pn_porsdo => ln_porconvenio,
                                                                  pc_tipoana => lc_Tipo_ana);
        end;

        
        --tipo agencia NEO
        --lc_tipo_NEO := trim(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_tipo_agencia_metas(ln_agencia /*i.agencia*/,
        -- pd_fecpro));
        begin 
          select f.scnom
            into lc_desagencia
            from fst001 f
           where f.pgcod = 1
             and f.sucurs = ln_agencia;                                                                    
        exception when others then
            lc_desagencia    := null;
        end;     

 
        begin
           select j.jaqy830catana
             into lc_descategoria 
             from jaqy830 j
            where j.jaqy830codana = i.jaql965ase
              and j.jaqy830est = 'S'; 
        exception when others then
            lc_descategoria  := null;
        end;     
          
     
        lc_tipo_NEO := null;
        
        --2023.11.13
        if ln_Por_Mora >999 then
           ln_Por_Mora := 999;
        end if;
        if ln_porconvenio > 999 then
           ln_porconvenio := 999;        
        end if;
        --2023.11.13
        
       begin ---2023.11.13 se agrego excepcion
            insert into JAQL600
              (JAQL600FPRO,
               JAQL600USU,
               JAQL600AGE,
               JAQL600MANT,
               JAQL600CODCAT,
               JAQL600TASE,
               JAQL600SDO,
               JAQL600NCL,
               JAQL600SDM,
               JAQL600PMRA,
               JAQL600SOTO,
               JAQL600SREC,
               JAQL600COTO,
               JAQL600CREC,
               JAQL600SRL,
               JAQL600NRL,
               JAQL600SANT,
               JAQL600CANT,
               JAQL600SDCA,
               JAQL600SDJU, /*JAQL600CRSA,JAQL600CRCL,JAQL600IDES,JAQL600PDES,*/
               JAQL600CLTOT,
               JAQL600SDTOT,
               JAQL600NEO,
               JAQL600EST,
               jaql600crsa,
               jaql600crcl,
               jaql600ides,
               jaql600pdes,
               jaql600mtsa,
               jaql600mtcl,
               jaql600mtre,
               jaql600mtmr,
               jaql600psal,
               jaql600pcli,
               jaql600pret,
               jaql600pmor,
               jaql600pvar,
               jaql600pjca,
               jaql600pjcas,
               jaql600cmra,
               jaql600bsal,
               jaql600bcli,
               jaql600bmra,
               jaql600btri,
               jaql600totpa,
               jaql600ccam,
               jaql600vcam,
               jaql600tcam,
               jaql600aux1,
               jaql600aux2,
               jaql600aux3,
               jaql600aux4,
               jaql600aux5,
               jaql600aux6,
               jaql600pcam,
               jaql600pord,
               jaql600mtod,
               jaql600vmor,
               jaql600csal,
               jaql600esal,
               jaql600ccli,
               jaql600ecli,
               jaql600cret,
               jaql600eret,
               jaql600posa,
               jaql600pocl,
               jaql600exsa,
               jaql600excl,
               jaql600exre,
               jaql600pore,
               jaql600bare,
               jaql600more,
               jaql600pmoa,
               JAQL600CAVE,
               JAQL600CLVE,
               jaql600sdodi,
               jaql600pordi,
               jaql600pagdi,
               jaql600porco,
               jaql600desag,
               jaql600desca  
               )
            values
              (pd_fecpro,
               i.jaql965ase,
               ln_agencia,
               ln_nummes,
               lc_Tipo_analista,
               lc_Tipo_ana,
               ln_nuevo_sal,
               ln_nuevo_cli,
               ln_salmor,
               ln_Por_Mora,
               ln_Saldo_Otorgado,
               ln_Saldo_Recibido,
               ln_Cliente_Otorgado,
               ln_Cliente_recibido,
               ln_salrec,
               ln_numrec,
               ln_sal_mes_anterior,
               ln_cli_mes_anterior,
               ln_Salcas,
               ln_saljud,
               ln_clitot,
               ln_saltot,
               lc_tipo_NEO,
               'S', --2023.08.29 se restauro a S----'S' , 2017.03.15 cambiar a S
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               ln_salven,
               ln_cliven,
               ln_saldia,
               0,
               0,
               ln_porconvenio,
               lc_desagencia,
               lc_descategoria
               );
          
            commit;
        
        exception when others then -- 2023.11.13 se agrego excepcion
           lc_coderr := sqlcode;
           lc_deserr := sqlerrm;
        end;           ---- 2023.11.13
      end if; --fiN de validacion de agencia del credito con agencia actual del analista
    
    end loop;
  
  end sp_cr_carga_datos;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_pa_Sal_recibidoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO RECIBIDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --                              2023.11.22 se cambio trim por rpad en variable analista
    -- *****************************************************************
  
    ln_saltot    number := 0;
    ld_fecini    date;


    lc_analista  char(10); --2016.02.08
  
  begin
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    begin
      select sum(decode(JAQZ455mod, 117, JAQZ455sdmnl, JAQZ455sdmn))
        into ln_saltot
        from JAQZ455 a
       where JAQZ455FECH between ld_fecini and pd_fecpro
         and a.JAQZ455ASED = lc_analista ;--rpad(pc_analista, 10, ' ')
        -- and a.jaqz455suor <> pc_codage;-- 2023.09.20 recibido
      
    exception
      when others then
        ln_saltot := 0;
    end;
  
    return NVL(ln_saltot, 0) * -1;
  
  end fn_pa_Sal_recibidoNew;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_pa_Sal_OtorgadoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO RECIBIDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --                              2023.11.22 se cambio trim por rpad en variable analista
    -- *****************************************************************
  
    ln_saltot    number := 0;
    ld_fecini    date;

    lc_analista  char(10); --2016.02.08
  begin
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(pc_analista, 10, ' ');
    --
  
    begin
      select sum(decode(JAQZ455mod, 117, JAQZ455sdmnl, JAQZ455sdmn))
        into ln_saltot
        from JAQZ455 a
       where JAQZ455FECH between ld_fecini and pd_fecpro
         --and a.JAQZ455ASEO = lc_analista --rpad(pc_analista, 10, ' ') 
         and a.JAQZ455ASEO = lc_analista
        ;-- se comento and a.JAQZ455ASEO <> a.jaqz455ased;-- 2023.09.20 recibido     ;

      
    exception
      when others then
        ln_saltot := 0;
    end;
  
    return NVL(ln_saltot, 0) * -1;
  
  end fn_pa_Sal_OtorgadoNew;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Cli_OtorgadoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO OTORGADO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 2015.04.14 Se modifico calculo de clientes por numdoc
    --                              2023.11.22 se cambio trim por rpad en variable analista    
    -- *****************************************************************
    ln_clioto number := 0;
    ld_fecini date;
    ld_fecha  date;
  

    lc_analista char(10); --2016.02.08
  
  begin
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(trim(pc_analista), 10, ' ');
    --
  
    ld_fecha := add_months(pd_fecpro, -1);
  
    select count(distinct cliente)
      into ln_clioto
      from (select --/*+parallel(a,2) */
            distinct f.pendoc cliente
              from JAQZ455 a, fsr008 f
             where f.pgcod = 1
               and f.ctnro = a.JAQZ455cta
               and JAQZ455FECH between ld_fecini and pd_fecpro
               --and trim(a.JAQZ455aseo) = trim(pc_analista)  2023.11.22
               and a.JAQZ455aseo = lc_analista ---2023.11.11 se modifico por optimizacion
               and f.ttcod = 1
               and f.cttfir = 'T'
               and JAQZ455sdmnl is not null
              ---se comento  and a.JAQZ455ASEO <> a.jaqz455ased-- 2023.09.20 recibido     ;
            --solo considera los clientes que se otorgaron
            /*and f.pendoc not in -- validando que clientes no existan en los recibidos
                  (select \*+all_rows *\
                     distinct a.jaql965ndoc Nro_clientes --,
                     from JAQL965 a
                    where a.jaql965fech = ld_fecha --20170321
                      and a.jaql965ase = lc_analista
                      and a.jaql965suc = pc_codage
                      and a.jaql965mod not in (108, 33 ,200)
                      and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO')
            */
            );
  
    return ln_clioto;
  
  end fn_pa_Cli_otorgadoNew;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_Cli_RecibidoNew(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO OTORGADO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 2015.04.14 Se modifico calculo de clientes por numdoc
    --                              2023.11.22 se cambio trim por rpad en variable analista
    -- *****************************************************************
    ln_clioto number := 0;
    ld_fecini date;
    ld_fecha  date;
  

    lc_analista char(10); --2016.02.08
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(trim(pc_analista), 10, ' ');
    --2016.02.08       
  
    ld_fecha := add_months(pd_fecpro, -1);
  
    select count(distinct cliente)
      into ln_clioto
      from (select --/*+parallel(a,2) */
             f.pendoc cliente
              from JAQZ455 a, fsr008 f
             where f.pgcod = 1
               and f.ctnro = a.JAQZ455cta
               and JAQZ455FECH between ld_fecini and pd_fecpro
               --and trim(a.JAQZ455ased) = trim(pc_analista)  2023.11.22
                 and a.JAQZ455ased = lc_analista ---2023.11.11 se modifico por optimizacion
               and f.ttcod = 1
               and f.cttfir = 'T'
               and JAQZ455sdmnl is not null
               -- and a.jaqz455suor <> pc_codage-- 2023.09.20 recibido     
                  
               and f.pendoc not in -- validando que clientes no existan en los recibidos
                   (select /*+all_rows */
                    distinct a.jaql965ndoc Nro_clientes --,
                      from JAQL965 a
                     where a.jaql965fech = ld_fecha --20170321
                       and a.jaql965ase = lc_analista
                       and a.jaql965suc = pc_codage
                       and a.jaql965mod not in (108, 33, 200)
                       and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO'));
               
  
    return ln_clioto;
  
  end fn_pa_Cli_RecibidoNew;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contmes_anterior(Pc_analista IN varchar2,
                                  pd_fecpro   in date,
                                  pc_codsuc   in varchar2) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CONTMES_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Consulta los meses de antiguedad del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_USER: Codigo de asesor
    -- Parámetros de Salida       : ln_mesant: Devuelve la cantidad de meses
    --                              de antiguedad
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    cursor usuarios(pc_analista char, pc_codsuc char) is
      select jaql966fec,
             jaql966cod,
             jaql966nom,
             jaql966car,
             jaql966tip,
             jaql966suc,
             jaql966sts,
             jaql966usr
        from jaql966
       where jaql966usr = pc_analista
         and jaql966suc = pc_codsuc
         AND jaql966fec <= pd_fecpro --SE AGREGO PARA CONSIDERAR MENORES O IGUALES A FECHA DE PROCESO
       order by jaql966fec desc;
  
    ln_cont   number := 1;
    ld_fecha  date;

    ln_Salant number := 0;
    ln_cliant number := 0;
  
  begin
  
    /* ld_fecha := add_months(pd_fecpro,-6);
    
    for i in usuarios(pc_analista, pc_codsuc) loop
    
       if i.jaql966fec >= ld_fecha then
        ln_cont := ln_cont + 1;
       else
           exit;
       end if; 
    end loop;*/
  
    ld_fecha := pd_fecpro;
  
    for x in 1 .. 2 loop
    
      --ld_fecha := add_months(pd_fecpro,-1);
      ld_fecha := add_months(ld_fecha, -1);
    
      begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => pc_analista,
                                                           pd_fecpro   => ld_fecha,
                                                           pc_codage   => pc_codsuc, --ln_codage,
                                                           pn_salant   => ln_Salant,
                                                           pn_cliant   => ln_cliant);
      end;
      if ln_salant <> 0 then
        ln_cont := ln_cont + 1;
      else
        ln_cont := 1;
        exit;
      end if;
    
    end loop;
  
    return ln_cont;
  
  end fn_cr_contmes_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_Sal_Judicial(pc_analista IN varchar2,
                              pd_fecpro   in date,
                              pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el saldo Judicial  para el calculo % de mora.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saljud number := 0;

  begin
  
    begin
      select nvl(sum(c.Jaql965sdmn), 0) --, count(distinct bccta),sng095_201404asnu 
        into ln_saljud
        from JAQL965 c
       where c.jaql965fech = pd_fecpro
            --and c.jaql965ase = pc_analista
         and TRIM(c.jaql965ase) = TRIM(pc_analista)
         AND C.JAQL965SUC = pn_codage
         and c.jaql965mod = 200
         and (c.jaql965cta, c.jaql965oper, c.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j)
         and (c.jaql965cta, c.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs       
      ;
    exception
      when no_data_found then
        ln_saljud := 0;
    end;
  
    return nvl(ln_saljud, 0);
  
  end fn_cr_Sal_Judicial;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_Sal_Castigado(pc_analista IN varchar2,
                               pd_fecpro   in date,
                               pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el saldo Castigado para el calculo % de mora del ULTIMO MES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saljud   number := 0;
    ld_fecini   date;
    ln_dias     number := 31; --20161028 ----ultimo año 365;
    ln_salcas   number := 0;
    lc_analista char(10);
  begin
  
    lc_analista := rpad(pc_analista, 10, ' ');
    ld_fecini   := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    begin
    
      select sum(Jaql965sdmn)
        into ln_salcas
        from (select /*+parallel (c,2) (j,2)*/
              distinct c.Jaql965sdmn,
                       c.jaql965cta,
                       c.jaql965oper,
                       j.jaql166scfvl
              
                from jaql965 c, JAQL166 /*_20140731*/ J --QUITAR COMENTARIO jaql166 j
               where c.jaql965fech = pd_fecpro
                 and c.jaql965ase = lc_analista --pc_analista
                 and c.jaql965mod = 33
                 and c.jaql965mod = j.jaql166scmod
                 and c.jaql965cta = j.jaql166sccta
                 and c.jaql965oper = j.jaql166scope
                 and c.jaql965suc = j.jaql166scsuc
                 and c.jaql965mda = j.jaql166scmda
                 and c.jaql965pap = j.jaql166scpap
                 and c.jaql965sbop = j.jaql166scsbo
                 and j.jaql166est = 90
                 and j.JAQL166NRPAG = 0
                 AND C.jaql965suc = pn_codage
                 and (c.jaql965cta, c.jaql965oper, c.jaql965ase) not in
                     (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                        from jaql970 j)
                 and (c.jaql965cta, c.jaql965oper) not in
                     (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
                 and jaql166scfvl >= ld_fecini /*pd_fecpro - ln_dias*/
                 and jaql166scfvl <= pd_fecpro) a;
    
    exception
      when no_data_found then
        ln_salcas := 0;
    end;
  
    return nvl(ln_salcas, 0);
  
  end fn_cr_Sal_Castigado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_saldo_mora(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_pa_saldo_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Calcula el saldo Mora ( cartera > 15 dias atraso)
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --                              2023.11.22 dcastro se cambio trim por rpad en variable analista
        
    -- *****************************************************************
  
    ln_salmor number := 0;
  
  begin
  
    begin
      select /*+parallel(j,2) */
       sum(case
             when j.JAQL965DATR  > 8  ---15  2023.03.20 se actualizo saldo mora para dias ATraso >8
             and j.JAQL965MOD not in (200, 33) then
              j.JAQL965SDMN
             else
              0
           end)
        into ln_salmor
        from JAQL965 j
       where j.jaql965fech = pd_fecpro
         --and trim(j.JAQL965ASE) = trim(pc_analista) 2023.11.22
         and j.JAQL965ASE = rpad(trim(pc_analista),10, ' ') -- 2023.11.22 se cambio validacion por optimizacion
         and j.JAQL965MOD not in (108, 200, 33)
         and j.jaql965suc = pn_codage
            --and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1
         and (j.jaql965cta, j.jaql965oper, j.jaql965ase) not in
             (select c.jaql970cta, c.jaql970oper, c.jaql970ase
                from jaql970 c)
         and (j.jaql965cta, j.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs       
      ;
    
    exception
      when others then
        ln_salmor := 0;
    end;
  
    return nvl(ln_salmor, 0);
  
  end fn_pa_saldo_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_saldo_legal(pc_analista IN varchar2,
                             pd_fecpro   in date,
                             pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_pa_saldo_legal
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Calcula el saldo de creditos en recuperacion legal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      : 2015.05.12
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego creditos REfinanciadoJudicial Estado 33
    --                              2023.11.22 dcastro se cambio trim por rpad para variable analista   
    -- *****************************************************************
  
    ln_salmor number;
  
  begin
  
    begin
      select /*+parallel(j,2) */
       sum(case
             when j.JAQL965DATR > 8  --15 2023.03.20  se actualizo dias 8
               and j.JAQL965MOD not in (200, 33) then
              j.JAQL965SDMN
             else
              0
           end)
        into ln_salmor
        from JAQL965 j
       where j.jaql965fech = pd_fecpro
         --and trim(j.JAQL965ASE) = trim(pc_analista) 2023.11.22
         and j.JAQL965ASE = rpad(trim(pc_analista),10, ' ') -- 2023.11.22 se cambio validacion por optimizacion
         and j.JAQL965MOD not in (108, 200, 33)
         AND J.JAQL965STAT IN (21, 22, 23, 25, 33, 34) --agrego estado refinanciado judicial --34-08Jul2015
         and (j.jaql965cta, j.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
         and j.jaql965suc = pn_codage; --and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
    
    exception
      when others then
        ln_salmor := 0;
    end;
  
    return nvl(ln_salmor, 0);
  
  end fn_pa_saldo_legal;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_num_saldo_legal(pc_analista IN varchar2,
                                 pd_fecpro   in date,
                                 pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_pa_saldo_legal
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Calcula el saldo de creditos en recuperacion legal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      : 2014.11.26
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico contador por numero de documento.
    --                              2023.11.22 dcastro se cambio trim por rpad para variable analista       
    -- *****************************************************************
  
    ln_salmor number;
  
  begin
  
    begin
      select /*+parallel(j,2) */ --count(j.jaql965cta)  
       count(distinct j.jaql965ndoc) --
        into ln_salmor
        from JAQL965 j
       where j.jaql965fech = pd_fecpro
          --and trim(j.JAQL965ASE) = trim(pc_analista) 2023.11.22
         and j.JAQL965ASE = rpad(trim(pc_analista),10, ' ') -- 2023.11.22 se cambio validacion por optimizacion
         and j.JAQL965MOD not in (108, 200, 33)
         AND J.JAQL965STAT IN (21, 22, 23, 25, 33, 34) ------08Jul2015 ---se añadió  33 y 34
         and (j.jaql965cta, j.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
         and j.jaql965suc = pn_codage; --and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
    
    exception
      when others then
        ln_salmor := 0;
    end;
  
    return nvl(ln_salmor, 0);
  
  end fn_pa_num_saldo_legal;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior(pc_analista IN char,
                                pd_fecpro   IN date,
                                pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : ln_salant: saldo anterior del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_salant number(18, 2);
    ln_cliant number;
    ld_fecfin date;
  
    ln_codage number; --2016.02.08
  begin
  
    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;
  
    ln_codage := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior(pc_analista => pc_analista,
                                                                 pd_fecpro   => pd_fecpro);
  
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => pc_analista,
                                                         pd_fecpro   => ld_fecfin,
                                                         pc_codage   => /*pc_codage,*/ ln_codage,
                                                         pn_salant   => ln_Salant,
                                                         pn_cliant   => ln_cliant);
    end;
  
    return ln_salant;
  
  end fn_cr_saldo_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior(pc_analista IN char,
                                 pd_fecpro   IN date,
                                 pc_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_NROCLI_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: Codigo de asesor
    --                              P_IN_Fecha: fecha del proceso
    -- Parámetros de Salida       : ln_nrocli: numero de clientes.
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_nrocli number;
    ln_salant number(18, 2);
    ld_fecfin date;
    ln_codage number;
  
  Begin
  
    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;
  
    ln_codage := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior(pc_analista => pc_analista,
                                                                 pd_fecpro   => pd_fecpro);
  
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => pc_analista,
                                                         pd_fecpro   => ld_fecfin,
                                                         pc_codage   => /*pc_codage,*/ ln_codage,
                                                         pn_salant   => ln_Salant,
                                                         pn_cliant   => ln_nrocli);
    end;
  
    return ln_nrocli;
  
  end fn_cr_nrocli_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_nueva_mora(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pc_codsuc   in varchar2,
                            pn_salmor   in number,
                            pn_saljud   in number,
                            pn_saldo    in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_pormor    number;
    ln_saljud    number := 0;
    ln_nummes    number := 0;
    ln_cont      number := 0;
    ln_saldo     number := 0;
    ln_salcas    number := 0;
    ln_dias      number := 365;
    ln_salrec    number := 0;
    ln_nuevamora number := 0;
    ln_monto     number := 0;
    ln_salven    number := 0;
  
  begin
  
    ln_saljud := pn_saljud;
  
    ---calcular mora 
    /*if (pn_saldo + ln_saljud +ln_salcas) > 0 then
          ln_pormor := round( (pn_salmor  + ln_saljud + ln_salcas ) / (pn_saldo  +ln_salcas ) * 100,2);
          --no suma ln_saljud porque en pn_saldo ya esta incluido el saldo judicial
    else
          ln_pormor := 0;
    end if; */
    begin
      select jaql600sdca, jaql600cave
        into ln_salcas, ln_salven
        from jaql600
       where jaql600fpro = pd_fecpro
         and jaql600usu = pc_analista
         and jaql600age = pc_codsuc;
    exception
      when no_Data_found then
        ln_salcas := 0;
    end;
  
    if (pn_saldo + ln_salcas + ln_saljud + ln_salven) > 0 then
      ln_pormor := round((pn_salmor + ln_saljud + ln_salcas + ln_salven) /
                         (pn_saldo) * 100,
                         2);
      --DENOMINADOR :no suma ln_saljud porque en pn_saldo ya esta incluido el saldo judicial
      --no suma ln_salcas porque en pn_saldo ya esta incluido saldo castigado
    else
      ln_pormor := 0;
    end if;
  
    return ln_pormor;
  
  end fn_pa_nueva_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_CategoriaRRHH(pc_JAQY830codana in char,
                                pd_fecpro        in date,
                                pn_jaqY830codcat out number,
                                pc_jaqy830tipase out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_CategoriaRRHH
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/02/2016
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA CATEGORIA DE ANALISTA 2016, SEGUN RRHH
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL587CODANA
    -- Parámetros de Salida       : CATEGORIA DE ANALISTA 2016, SEGUN RRHH 
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2016.04.05
    -- *****************************************************************
  
  begin
  
    begin
      ---1
    
      select jaqY830codcat, JAQY830TIPASE
        into pn_jaqY830codcat, pc_jaqy830tipase
        from jaqy830
       where JAQY830codana = pc_JAQY830codana
         and jaqY830est = 'S'; --2016.04.05 se agrego estado 
    
    exception
      when no_data_found then
        --2
        pn_jaqY830codcat := 0;
        pc_jaqy830tipase := null;
    end; --3
  
  
  end sp_cr_CategoriaRRHH;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia_metas(P_IN_agen  in number,
                                    P_IN_Fecha in date) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_AGENCIA_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Tipo de agencias por plus de metas
    --                              E=especifica
    --                              N=nuevas
    --                              O=otras
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_agen: Codigo de Agencia
    --                              P_IN_Fecha: fecha del proceso
    -- Parámetros de Salida       : lc_tipage: devuelve el tipo de agencia
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_tipage char(2) := 'X';
    ln_conage number(3);
    ln_conmes number(10);
  
  begin
  
    begin
      select substr(tpdesc, 1, 1)
        into lc_tipage
        from fst098
       where pgcod = 1
         and tpcod = 7662
         and tpnro = P_IN_agen; ---buscar si existen excepciones
    exception
      when no_data_found then
        lc_tipage := 'X';
    end;
  
    If lc_tipage = 'X' then
    
      begin
        -- agencia especifica
        select count(*)
          into ln_conage
          from fst001
         where SCCIUD in (401, 2101, 1803, 1801, 2111)
           and sucurs = P_IN_agen;
      exception
        when no_data_found then
          lc_tipage := 'X';
      End;
    
      If ln_conage > 0 then
        lc_tipage := 'E';
      End If;
    
    End If;
  
    -- otras
    If lc_tipage = 'X' then
      lc_tipage := 'O';
    End If;
  
    return lc_tipage;
  
  end fn_cr_tipo_agencia_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_Traslados_JAQZ455(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_traslados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQZ455
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.06.03
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: DCASTRO
    --                              2014.06.04 se modifico cursor se comento sdmol = 0         
    -- *****************************************************************
  
    cursor traslados(ld_fecini in date, ld_fecfin in date) is
      select *
        from JAQZ455
       where JAQZ455fech >= ld_fecini
         and JAQZ455fech <= ld_fecfin;
    --and JAQZ455sdmol = 0;
  
    ln_mtomn  number;
    ln_mtomo  number;
    ln_tipcam number(14, 8);
    ln_modulo number(3);
    ln_opera  number(9);
    ld_fecini date;
    ld_fecfin date;
    sql_stmt  varchar2(100);
    --pd_fecpro date := to_Date('2014.04.30','yyyy.mm.dd');
  
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    ld_fecfin := pd_fecpro;
  
    sql_stmt := 'delete from JAQZ455 where JAQZ455fech >= :1 and JAQZ455fech <= :2 ';
    EXECUTE IMMEDIATE sql_stmt
      USING ld_fecini, ld_fecfin;
  
    commit;
  
    --inserta en JAQZ455
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_traslados(pd_fecpro => pd_fecpro);
    end;
  
  end sp_cr_Traslados_JAQZ455;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_traslados(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_traslados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQZ455
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2024.07.11
    -- Autor de la Modificación   : dcastro
    -- Descripción de Modificación: se agrego condición para no considerar cancelados anteriores a la fecha de traslado
    -- *****************************************************************
  
    cursor vigentes(ld_fecmes in date) is
    --detallado vigentes analistas diferentes
      select /*+all_rows */ --a.jaql965cta, a.jaql965oper , a.jaql965suc,a.jaql965ase, b.jaql965suc,b.jaql965ase, b.jaql965sdmn
      distinct b.jaql965fech,
               a.jaql965ase aseo,
               b.jaql965ase ased,
               a.jaql965emp,
               a.jaql965mod,
               a.jaql965suc,
               a.jaql965mda,
               a.jaql965pap,
               a.jaql965cta,
               a.jaql965oper,
               a.jaql965sbop,
               a.jaql965top,
               a.jaql965inst,
               a.jaql965sdmn * -1 SALDOMN,
               a.jaql965tdoc,
               a.jaql965ndoc,
               a.jaql965suc SUORI,
               b.jaql965suc SUDES,
               a.jaql965sdmn * -1 SDOMNL
        from JAQL965 a, jaql965 b
       where a.jaql965fech = ld_fecmes
         and a.jaql965mod not in (108, 33 /*, 200*/)
         and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO'
         and b.jaql965fech = pd_fecpro
         and b.jaql965emp = a.jaql965emp
         and b.jaql965mod = a.jaql965mod
            --and b.jaql965suc = a.jaql965suc
         and b.jaql965mda = a.jaql965mda
         and b.jaql965pap = a.jaql965pap
         and b.jaql965cta = a.jaql965cta
         and b.jaql965oper = a.jaql965oper
         and b.jaql965ase <> a.jaql965ase --- 2023.09.20 
         and (b.jaql965cta, b.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
      
           UNION       
          --detallado vigentes analistas iguales y sucursal diferente, creditos del mismo analista transferidos a la nueva agencia del mismo analista 2024.07.11
          select /*+all_rows */ --a.jaql965cta, a.jaql965oper , a.jaql965suc,a.jaql965ase, b.jaql965suc,b.jaql965ase, b.jaql965sdmn
          distinct b.jaql965fech,
                   a.jaql965ase aseo,
                   b.jaql965ase ased,
                   a.jaql965emp,
                   a.jaql965mod,
                   a.jaql965suc,
                   a.jaql965mda,
                   a.jaql965pap,
                   a.jaql965cta,
                   a.jaql965oper,
                   a.jaql965sbop,
                   a.jaql965top,
                   a.jaql965inst,
                   a.jaql965sdmn * -1 SALDOMN,
                   a.jaql965tdoc,
                   a.jaql965ndoc,
                   a.jaql965suc SUORI,
                   b.jaql965suc SUDES,
                   a.jaql965sdmn * -1 SDOMNL
            from JAQL965 a, jaql965 b
           where a.jaql965fech = ld_fecmes
             and a.jaql965mod not in (108, 33 /*, 200*/)
             and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO'
             and b.jaql965fech = pd_fecpro
             and b.jaql965emp = a.jaql965emp
             and b.jaql965mod = a.jaql965mod
             and b.jaql965suc <> a.jaql965suc
             and b.jaql965mda = a.jaql965mda
             and b.jaql965pap = a.jaql965pap
             and b.jaql965cta = a.jaql965cta
             and b.jaql965oper = a.jaql965oper
             and b.jaql965ase = a.jaql965ase --- 2023.09.20 
              and (b.jaql965cta, b.jaql965oper) not in
                 (select bccta, bcoper from jaqz498);
      
  
    ld_fecini date;
    ld_fecfin date;
    ld_fecmes date;
  
    ln_num      number := 0;
    ln_contador number := 0;
  
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    ld_fecfin := last_Day(pd_fecpro);
    ld_fecmes := add_months(ld_fecfin, -1);
    
    begin
      delete from JAQZ455 j
       where JAQZ455fech >= ld_fecini
         and JAQZ455fech <= pd_fecpro; -- 2023.09.20 para reprocesa
      
      commit;   
    exception when others then
       null;  
    end;    
    
    begin
      insert into JAQZ455
        (JAQZ455fech,
         JAQZ455aseo,
         JAQZ455ased,
         JAQZ455emp,
         JAQZ455mod,
         JAQZ455suc,
         JAQZ455mda,
         JAQZ455pap,
         JAQZ455cta,
         JAQZ455oper,
         JAQZ455sbop,
         JAQZ455top,
         JAQZ455inst,
         JAQZ455sdmn,
         JAQZ455tdoc,
         JAQZ455ndoc,
         JAQZ455suor, /*JAQZ455suds,*/
         JAQZ455sdmnl)
      
      ---detallado cancelados
          select pd_fecpro, aseo, ased, jaql965emp, jaql965mod, jaql965suc, jaql965mda, jaql965pap, jaql965cta, jaql965oper, jaql965sbop,
            jaql965top, jaql965inst, SDMN, jaql965tdoc,  jaql965ndoc, SUORI, SDOMNL
            from 
              (  select /*+all_rows */
                 pd_fecpro,
                 a.jaql965ase aseo,
                 (select s.sng001ase from sng001 s where s.sng001inst = a.jaql965inst) ased,
                 a.jaql965emp,
                 a.jaql965mod,
                 a.jaql965suc,
                 a.jaql965mda,
                 a.jaql965pap,
                 a.jaql965cta,
                 a.jaql965oper,
                 a.jaql965sbop,
                 a.jaql965top,
                 a.jaql965inst,
                 a.jaql965sdmn * -1 SDMN,
                 a.jaql965tdoc,
                 a.jaql965ndoc,
                 a.jaql965suc SUORI,
                 a.jaql965sdmn * -1 SDOMNL ,
                 b.aofe99 FCAN,
                  (select   max(t.sng130fape) from sng130 t, sng131 u where u.sng130cor = t.sng130cor and t.sng130fape > ld_fecmes and t.sng130fape <= pd_fecpro 
                  and u.sng131cta = a.jaql965cta and u.sng131ope = a.jaql965oper ) FTRAS --2024.07.11
                  from JAQL965 a, fsd010 b
                 where a.jaql965fech = ld_fecmes
                   and a.jaql965mod not in (108, 33 /*, 200*/)
                   and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO'
                   and b.pgcod = a.jaql965emp
                   and b.aomod = a.jaql965mod
                   and b.aosuc = a.jaql965suc
                   and b.aomda = a.jaql965mda
                   and b.aopap = a.jaql965pap
                   and b.aocta = a.jaql965cta
                   and b.aooper = a.jaql965oper
                   and b.aotope = a.jaql965top
                   and b.aostat = 99
                   and b.aofe99 > a.jaql965fech
                   and b.aofe99 <= pd_fecpro
                   and (a.jaql965cta, a.jaql965oper) not in
                       (select bccta, bcoper from jaqz498) 
                ) Z
             where  Z.FCAN > Z.FTRAS   ;
     
        commit;
    exception when others then
       null;  
    end;        
  
    for i in vigentes(ld_fecmes) loop
    
      --buscar si existe
      begin
        select count(*)
          into ln_contador
          from jaqz455 j
         where j.jaqz455fech = pd_fecpro
           and j.jaqz455cta = i.jaql965cta
           and j.jaqz455oper = i.jaql965oper
           and j.jaqz455sdmn = i.SALDOMN;
      exception
        when no_Data_found then
          ln_contador := 0;
      end;
    
      if ln_contador = 0 then
        --no existe, insertar
        begin
          insert into JAQZ455
            (JAQZ455fech,
             JAQZ455aseo,
             JAQZ455ased,
             JAQZ455emp,
             JAQZ455mod,
             JAQZ455suc,
             JAQZ455mda,
             JAQZ455pap,
             JAQZ455cta,
             JAQZ455oper,
             JAQZ455sbop,
             JAQZ455top,
             JAQZ455inst,
             JAQZ455sdmn,
             JAQZ455tdoc,
             JAQZ455ndoc,
             JAQZ455suor,
             JAQZ455suds,
             JAQZ455sdmnl)
          
          values
            (i.jaql965fech,
             i.aseo,
             i.ased,
             i.jaql965emp,
             i.jaql965mod,
             i.jaql965suc,
             i.jaql965mda,
             i.jaql965pap,
             i.jaql965cta,
             i.jaql965oper,
             i.jaql965sbop,
             i.jaql965top,
             i.jaql965inst,
             i.SALDOMN,
             i.jaql965tdoc,
             i.jaql965ndoc,
             i.SUORI,
             i.SUDES,
             i.SDOMNL);
             commit;
        exception when others then
           null;  
        end;              
      end if;
    end loop;
  

   begin
      delete from JAQZ455 j
           where JAQZ455fech >= ld_fecini
             and JAQZ455fech <= pd_fecpro
             and (j.JAQZ455aseo = j.JAQZ455ased and  j.jaqz455suor = j.jaqz455suds); 
        
    commit;
    exception when others then
       null;  
    end;     
  
  end sp_cr_inserta_traslados;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_indicadores(pd_fecpro   in date,
                              pc_analista in varchar2,
                              pc_sucurs   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_indicadores
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE INDICADORES PARA CALCULO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
    --obtener crecimientos SALDO -CLIENTES
      select j.jaql600usu,
             j.jaql600sant,
             j.jaql600cant,
             j.jaql600sdo,
             j.jaql600ncl,
             j.jaql600codcat,
             j.jaql600tase,
             j.jaql600age,
             j.jaql600sdm,
             j.jaql600sdju,
             (nvl(jaql600sdo, 0) + nvl(jaql600soto, 0) -
             nvl(jaql600srec, 0)) jaql600saldo,
             (nvl(jaql600ncl, 0) + nvl(jaql600coto, 0) -
             nvl(jaql600crec, 0)) jaql600cliente
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%'
         and j.jaql600age = pc_sucurs;
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_saldodesT       number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_cresal          number;
    ln_mtosal          number;
    ln_crecli          number;
    ln_mtocli          number;
    ln_mincom          number;
    ln_mtoret          number;
    ln_Por_Mora        number;
  
    lc_analista varchar2(10) := null;
  
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista := pc_analista;
    end if;
  
    for i in analistas(lc_analista) loop
    
      ln_salant  := i.jaql600sant;
      ln_cliant  := i.jaql600cant;
      ln_saldo   := i.jaql600saldo;
      ln_numcli  := i.jaql600cliente;
      ln_codcat  := i.jaql600codcat;
      lc_tipoase := i.jaql600tase;
    
      ln_crecimiento_sal := ln_saldo - ln_salant;
      ln_crecimiento_cli := ln_numcli - ln_cliant;
    
      if lc_tipoase = 'P' then
        --aplica para PYMES
        --INDICADORES DESEMBOLSOS
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_desembolsos(pd_fecpro     => pd_fecpro,
                                                     pc_analista   => i.jaql600usu, --pc_analista,
                                                     pn_saldo      => ln_saldodes,
                                                     pn_porpago    => ln_porpago,
                                                     pn_porcentaje => ln_porcentaje,
                                                     pn_saldotot   => ln_saldodesT);
        end;
      
      else
        --para CONSUMO
        ln_saldodes   := 0;
        ln_porpago    := 0;
        ln_porcentaje := 100; --se pagara el 100% de la meta
        ln_saldodesT  := 0;
      
      end if;
    
      --METAS      
      begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_metas(pn_codcat => ln_codcat,
                                             pc_tipase => lc_tipoase,
                                             pn_cresal => ln_cresal,
                                             pn_crecli => ln_crecli,
                                             pn_mincom => ln_mincom);
      end;
    
      ln_Por_Mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_nueva_mora(i.jaql600usu,
                                                               pd_fecpro,
                                                               i.jaql600age,
                                                               i.jaql600sdm,
                                                               i.jaql600sdju,
                                                               i.jaql600sdo);
    
      update JAQL600 j
         set JAQL600CRSA = ln_crecimiento_sal,
             JAQL600CRCL = ln_crecimiento_cli,
             JAQL600PORD = ln_porcentaje,
             JAQL600MTOD = ln_saldodesT,
             JAQL600IDES = ln_saldodes,
             JAQL600PDES = ln_porpago,
             JAQL600MTSA = ln_cresal, --ln_mtosal,
             JAQL600MTCL = ln_crecli, --ln_mtocli,
             JAQL600MTRE = ln_mincom, --ln_mtoret
             JAQL600PMRA = ln_Por_Mora
      
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu = i.jaql600usu;
    
    end loop;
  
    commit;
  
  end sp_cr_indicadores;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_desembolsos(pd_fecpro     in date,
                              pc_analista   in varchar2,
                              pn_saldo      out number,
                              pn_porpago    out number,
                              pn_porcentaje out number,
                              pn_saldotot   out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_desembolsos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE TOTAL Y PORCENTAJE DE DESEMBOLSOS DEL MES MICRO Y PEQUEÑA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecini   date;
    ln_saldotot number := 0;
    ln_saldo    number := 0;
    ln_pordes   number;
    ln_porpagT  number;
    ln_porpagP  number;
    lc_analista char(10);
  
    cursor creditos(lc_analista in char) is
    /*     select J.JAQL965CTA, J.JAQL965OPER, substr(jaql965tcrd,1,2) PRODUCTO
            from JAQL965 J
           WHERE JAQL965FECH = pd_fecpro
             and JAQL965ASE = lc_analista;*/
      select *
        from jaqz454 j
       where j.jaqz454fpro = pd_fecpro
         and j.jaqz454ase = lc_analista;
  
    ln_monto  number;
    ln_codsuc number;
    ln_cta    number;
    ln_oper   number;
    ln_moneda number;
  
  begin
  
    ld_fecini   := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    --porcentaje de desembolsos permitido
    begin
      select tp1nro1, tp1nro2, tp1nro3
        into ln_pordes, ln_porpagT, ln_porpagP
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 12;
    exception
      when others then
        ln_pordes := 0;
    end;
  
    for i in creditos(lc_analista) loop
    
      begin
        select j.jaqz454mda, j.jaqz454imp1
          into ln_moneda, ln_monto
          from jaqz454 j
         where j.jaqz454cta = i.jaqz454cta --i.jaql965cta
           and j.jaqz454oper = i.jaqz454oper --i.jaql965oper
           and j.jaqz454fcon = i.jaqz454fcon
           and j.jaqz454fpro = pd_fecpro;
      exception
        when others then
          ln_moneda := 0;
          ln_monto  := 0;
      end;
    
      if ln_moneda <> 0 then
        ln_monto := ln_monto * fn_tipo_cambio_fijo(pd_fecpro);
      end if;
    
      --if i.producto in ('MI','PE') then
      if i.jaqz454pro in ('MI', 'PE') then  
        ln_saldo := ln_saldo + ln_monto;
      end if;
    
      ln_saldotot := ln_saldotot + ln_monto;
    
    end loop;
  
    if ln_saldotot <> 0 then
    
      pn_porcentaje := round(ln_saldo * 100 / ln_saldotot, 2);
      pn_saldo      := ln_saldo;
      pn_saldotot   := ln_saldotot;
    
    else
    
      pn_porpago    := 0;
      pn_saldo      := ln_saldo;
      pn_saldotot   := 0;
      pn_porcentaje := 0;
    
    end if;
  
    if pn_porcentaje >= ln_pordes then
    
      pn_porpago := ln_porpagT;
    else
    
      pn_porpago := ln_porpagP;
    end if;
  
  end sp_cr_desembolsos;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_metas(pn_codcat in number,
                        pc_tipase in char,
                        pn_cresal out number,
                        pn_crecli out number,
                        pn_mincom out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_metas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE METAS POR CRECIMIENTO Y SALDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_cresal number;
    ln_mtosal number;
    ln_crecli number;
    ln_mtocli number;
    ln_mincom number;
    ln_mtoret number;
  
  begin
  
    begin
      select jaql596csal,
             jaql596msal,
             jaql596ccli,
             jaql596mcli,
             jaql596ret,
             jaql596mret
        into ln_cresal,
             ln_mtosal,
             ln_crecli,
             ln_mtocli,
             ln_mincom,
             ln_mtoret
        from jaql596 j
       where j.jaql596cat = pn_codcat
         and j.jaql596tip = pc_tipase;
    exception
      when others then
        ln_cresal := 0;
        ln_mtosal := 0;
        ln_crecli := 0;
        ln_mtocli := 0;
        ln_mincom := 0;
        ln_mtoret := 0;
    end;
  
    pn_cresal := ln_cresal;
    pn_crecli := ln_crecli;
    pn_mincom := ln_mincom;
  
  end sp_cr_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_pago_metas(pn_codcat in number,
                             pc_tipase in char,
                             pn_mtosal out number,
                             pn_mtocli out number,
                             pn_mtoret out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_metas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE METAS POR CRECIMIENTO Y SALDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_cresal number;
    ln_mtosal number;
    ln_crecli number;
    ln_mtocli number;
    ln_mincom number;
    ln_mtoret number;
  
  begin
  
    begin
      select jaql596csal,
             jaql596msal,
             jaql596ccli,
             jaql596mcli,
             jaql596ret,
             jaql596mret
        into ln_cresal,
             ln_mtosal,
             ln_crecli,
             ln_mtocli,
             ln_mincom,
             ln_mtoret
        from jaql596 j
       where j.jaql596cat = pn_codcat
         and j.jaql596tip = pc_tipase;
    exception
      when others then
        ln_cresal := 0;
        ln_mtosal := 0;
        ln_crecli := 0;
        ln_mtocli := 0;
        ln_mincom := 0;
        ln_mtoret := 0;
    end;
  
    pn_mtosal := ln_mtosal;
    pn_mtocli := ln_mtocli;
    pn_mtoret := ln_mtoret;
  
  end sp_cr_pago_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_cumplimiento_ini(pd_fecpro   in date,
                               pc_analista in varchar2,
                               pc_codage   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cumplimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 2017.07.13
    -- Descripción de Modificación: Se agrego condicion solo califica para contencion si tipo es PYMES - P
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
      select *
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%'
         and j.jaql600age = pc_codage;
    --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_metsal          number;
    ln_metcli          number;
    ln_metret          number;
    ln_metmor          number;
  
    ln_mtosal       number;
    ln_mtocli       number;
    ln_mtoret       number;
    ln_pagsal       number;
    ln_salexcedente number;
    ln_pagsal_adi   number;
    ln_pagsal_tot   number;
    ln_pagcli       number;
    ln_cliexcedente number;
    ln_pagcli_adi   number;
    ln_pagcli_tot   number;
  
    ln_exccli    number;
    ln_excsal    number;
    ln_porcum    number;
    ln_porcumsal number;
    ln_porcumcli number;
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_totalpagovariable number;
    ln_subpagovariable   number;
    ln_retexcedente      number;
    ln_pagret            number;
    ln_pagret_adi        number;
    ln_pagret_tot        number;
    ln_excret            number;
    ln_numret            number;
  
    ln_pagmora number;
    ln_TOTAL   number;
  
    ln_pagocontencion number;
    ln_basecon        number;
    ln_porcontencion  number;
    ln_codcam         number;
  
    lc_analista varchar2(10) := null;
    ld_fechacon date;
  
    ln_baseret      number;
    ln_retenidos    number;
    ln_porretencion number;
  
    ln_INDMORA number;
    ln_facmor  number;
    ln_pormoa  number;
  
    ln_cascontinuidad number;
    lc_cartera_rec    char(1);
    lc_excluir_cont   char(1);
    ln_nummes         number;
  
    ln_salmorT number;
    ln_pormorT number;
  
    ln_contenidos number;
  
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista := pc_analista;
    end if;
  
    for i in analistas(lc_analista) loop
    
      --      i.jaql600usu
    
      ln_metsal := i.jaql600mtsa;
      ln_metcli := i.jaql600mtcl;
      ln_metret := i.jaql600mtre;
      ln_metmor := i.jaql600mtmr;
    
      ln_cresal  := i.jaql600crsa;
      ln_crecli  := i.jaql600crcl;
      ln_codcat  := i.jaql600codcat;
      lc_tipoase := i.jaql600tase;
      --     ln_mincom := i.
    
      --OBTIENE GUIAS PROCESO
      if lc_tipoase = 'P' then
      
        --excedente cartera PYMES
        begin
          select (tp1nro1 / tp1nro2)
            into ln_excsal
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 13
             and tp1corr2 = 1;
        exception when others then
           null;             
        end;
      
        --excedente clientes PYMES
        begin
          select (tp1nro1 / tp1nro2)
            into ln_exccli
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 13
             and tp1corr2 = 2;
        exception when others then
           null;             
        end;
      
        ln_INDMORA := 1;
      else
      
        ln_INDMORA := 0.5;
      
        --excedente cartera CONSUMO
        begin
          select (tp1nro1 / tp1nro2)
            into ln_excsal
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 13
             and tp1corr2 = 3;
        exception when others then
           null;             
        end;
      
        --excedente clientes CONSUMO
        begin
          select (tp1nro1 / tp1nro2)
            into ln_exccli
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 13
             and tp1corr2 = 4;
        exception when others then
           null;     
        end;
      end if;
    
      --retencion
      begin
        select tp1nro1, tp1nro2
          into ln_numret, ln_excret
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 14
           and tp1corr2 = 1;
        exception when others then
           null;           
      end;
    
      --Aplicar CONTINUIDAD de mora a partir de diciembre para analistas, Marzo para senior
      if ln_codcat < 7 then
        --ANALISTAS
      
        begin
          select to_Date(tp1desc, 'YYYYMMDD')
            into ld_fechacon
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 16
             and tp1corr2 = 1;
        exception when others then
           null;             
        end;
      else
        --Categoria Mayor o igual a 7 corresponde a ANALSITAS SENIOR
        begin
          select to_Date(tp1desc, 'YYYYMMDD')
            into ld_fechacon
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 16
             and tp1corr2 = 2;
        exception when others then
           null;             
        end;
      
      end if;
    
      --FIN GUIAS PROCESO 
    
      if ln_metsal = 0 or ln_metcli = 0 then
        ln_pagsal_tot := 0;
        ln_pagcli_tot := 0;
      else
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_pago_metas(pn_codcat => ln_codcat,
                                                    pc_tipase => lc_tipoase,
                                                    pn_mtosal => ln_mtosal,
                                                    pn_mtocli => ln_mtocli,
                                                    pn_mtoret => ln_mtoret);
        end;
      
        --valida crecimiento cartera
        if ln_cresal >= ln_metsal then
          --ln_pagsal := ln_mtosal * i.JAQL600PDES/100;
          ln_pagsal := ln_mtosal;
        
          --crecimiento supera el 100%
          ln_porcumsal := round((ln_cresal * 100) / ln_metsal, 2);
          if ln_porcumsal > 100 then
          
            --aplicar porcentaje al excedente
            ln_salexcedente := ln_cresal - ln_metsal;
            ln_pagsal_adi   := nvl(round(ln_salexcedente * ln_excsal / 100, 2),0);
          else
            ln_pagsal_adi   := 0;
            ln_salexcedente := 0;
          end if;
        
          --pago total saldo 
          --ln_pagsal_tot :=  ln_pagsal + ln_pagsal_adi;            
          if lc_tipoase = 'P' then
            --se aplica porcentaje desembolso al monto total ganado
            ln_pagsal_tot := round((ln_pagsal + ln_pagsal_adi) *
                                   i.JAQL600PDES / 100,
                                   2);
          else
            --si es consumo no se aplica %desembolso
            ln_pagsal_tot := round((ln_pagsal + ln_pagsal_adi), 2);
          end if;
        
        else
          ln_pagsal_tot   := 0;
          ln_pagsal       := 0;
          ln_pagsal_adi   := 0;
          ln_porcumsal    := 0;
          ln_salexcedente := 0;
        
        end if;
      
        --valida crecimiento clientes
        if ln_crecli >= ln_metcli then
          ln_pagcli := ln_mtocli;
        
          --crecimiento supera el 100%
          ln_porcumcli := round((ln_crecli * 100) / ln_metcli, 2);
          if ln_porcumcli > 100 then
          
            --aplicar porcentaje al excedente
            ln_cliexcedente := ln_crecli - ln_metcli;
            ln_pagcli_adi   := round(ln_cliexcedente * ln_exccli, 2);
          else
            ln_pagcli_adi   := 0;
            ln_cliexcedente := 0;
          
          end if;
        
          --pago total clientes
          ln_pagcli_tot := ln_pagcli + ln_pagcli_adi;
        
        else
          ln_pagcli_tot   := 0;
          ln_pagcli       := 0;
          ln_pagcli_adi   := 0;
          ln_porcumcli    := 0;
          ln_cliexcedente := 0;
        
          ln_totalpagovariable := 0;
        
        end if;
      
        --SI TIENE CRECIMIENTO EN CLIENTE NO ES NECESARIO QUE SUPERE LA META se paga en retencion
        if ln_crecli > 0 then
        
          --SI TIENE CRECIMIENTO PUEDE COMISIONAR POR RETENCION
          --obtiene valor RETENCION
        
          /* begin
            pq_cr_contencion.sp_cr_valor_retencion(pd_fecpro => pd_fecpro,
                                                   pc_analista => i.jaql600usu,
                                                   pn_sucurs => i.jaql600age,
                                                   pn_baseret => ln_baseret,
                                                   pn_retenidos => ln_retenidos,
                                                   pn_porcentaje => ln_porretencion);
          end;*/
        
          --2017.03.15
          begin
            select j.jaqz451base,
                   j.jaqz451ret,
                   case
                     when j.jaqz451base = 0 then
                      0
                     else
                      round(j.jaqz451ret * 100 / j.jaqz451base, 2)
                   end porcentaje
              into ln_baseret, ln_retenidos, ln_porretencion
              from jaqz451 j
             where j.jaqz451fpro = pd_fecpro
               and j.jaqz451ana = trim(i.jaql600usu) --lc_analista
               and j.jaqz451age = i.jaql600age;
          
          exception
            when no_data_found then
              ln_porretencion := 0;
              ln_baseret      := 0;
              ln_retenidos    := 0;
          end;
          --2017.03.15
        
          if ln_baseret > ln_numret then
          
            if ln_porretencion >= ln_metret then
              ln_pagret := ln_mtoret;
            
              --aplicar porcentaje al excedente
              ln_retexcedente := ln_porretencion - ln_metret;
              if ln_retexcedente > 0 then
                ln_pagret_adi := round(ln_retexcedente * ln_excret, 2);
              else
                ln_pagret_adi := 0;
              end if;
            
            else
              ln_pagret       := 0;
              ln_pagret_adi   := 0;
              ln_retexcedente := 0;
            end if;
          
          else
            ln_pagret       := 0;
            ln_pagret_adi   := 0;
            ln_retenidos    := nvl(ln_retenidos, 0);
            ln_porretencion := nvl(ln_porretencion, 0);
            ln_baseret      := nvl(ln_baseret, 0);
          end if;
        
          ln_pagret_tot := ln_pagret + ln_pagret_adi;
          ---
        else
          ln_retexcedente := 0;
          ln_pagret       := 0;
          ln_pagret_adi   := 0;
          ln_pagret_tot   := 0;
          ln_retenidos    := 0;
          ln_porretencion := 0;
          ln_baseret      := 0;
          ln_excret       := 0;
        end if;
      
        ln_subpagovariable := ln_pagsal_tot + ln_pagcli_tot + ln_pagret_tot;
      
        ---obtiene MORA
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_variacion_mora(pc_analista => i.jaql600usu,
                                                        pd_fecpro   => pd_fecpro,
                                                        pc_tipase   => lc_tipoase,
                                                        pn_pormor   => i.jaql600pmra,
                                                        pn_pormoa   => ln_pormoa,
                                                        pn_varmor   => ln_varmor);
        end;
      
        ---
        begin
          ln_mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_metamora(pc_tipase => lc_tipoase,
                                                             pn_pormor => ln_pormoa /*i.jaql600pmra*/,
                                                             pn_varmor => ln_varmor);
          --se envia la mora del mes anterior
        end;
      
        --aplica %mora a 
        if ln_mora = 100 then
          ln_pagmora := 0;
        else
          ln_pagmora := round(ln_subpagovariable * (ln_mora - 100) / 100, 2);
        end if;
      
        --2017.10.04
        if i.jaql600srec > 0 then
          --si tuvo cartera recibida en el mes excluir de descuento por MORA
          if ln_pagmora < 0 then
            ln_pagmora := 0;
          end if;
        end if;
        ---2017.10.04
      
        ln_totalpagovariable := ln_subpagovariable + ln_pagmora;
      
        /*actualiza mora antes de calcular continuidad*/
        begin
          update JAQL600 j
             set JAQL600PMOA = ln_pormoa
           where j.jaql600fpro = pd_fecpro
             and j.jaql600usu = i.jaql600usu;
        exception
          when others then
            null;
        end;
      
        /*2017.10.04 calcula saldo en MORA y porcentaje de cartera en mora */
        /*           begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_mora_traslado(pc_analista => i.jaql600usu,
                                                    pd_fecpro => pd_fecpro,
                                                    pn_salrec => i.jaql600srec,
                                                    pn_salmor => ln_salmorT,
                                                    pn_pormor => ln_pormorT);
        end;*/
        /*2017.10.04*/
      
        ln_cascontinuidad := 0;
      
        lc_cartera_rec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_cartera_recibida(i.jaql600usu,
                                                                          pd_fecpro);
      
        ln_nummes := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_contmes_anterior(i.jaql600usu,
                                                                     pd_fecpro,
                                                                     i.jaql600age);
      
        lc_excluir_cont := 'N';
      
        ln_incmor         := 0;
        ln_pjcas          := 0;
        ln_cascontinuidad := 0;
      
        if pd_fecpro >= ld_fechacon then
        
          -- 2017.10.04 aplica continuidad si no tuvo traslados o fue cambiado y cumple 3 meses 
          if lc_excluir_cont = 'N' then
          
            --valida continuidad se multiplica por negativo 
            -- ln_incmor  := (-1)* PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora(i.jaql600usu,pd_fecpro);
            ln_incmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora(i.jaql600usu,
                                                                         pd_fecpro);
          
            if ln_incmor > ln_INDMORA then
              -- si incrementa supera 1% en los 3 meses no se paga por incentivo variable (Cartera, Clientes y Retencion)
            
              /*2017.10.04*/
              if ln_nummes < 3 or lc_cartera_rec = 'S' then
                lc_excluir_cont := 'S';
              else
                lc_excluir_cont := 'N';
              end if;
            
              if lc_excluir_cont = 'N' then
                /*2017.10.04*/
              
                ln_pjcas             := -100;
                ln_cascontinuidad    := (ln_totalpagovariable * ln_pjcas / 100);
                ln_totalpagovariable := ln_totalpagovariable +
                                        ln_cascontinuidad;
              
              end if; /*2017.10.04*/
            
            else
              ln_pjcas          := 0;
              ln_cascontinuidad := 0;
            end if;
          
          end if;
        
          /* else
          ln_incmor := 0;
          ln_pjcas := 0;
          ln_cascontinuidad :=0;*/
        end if;
        --
      
        --OBTIENE CONTENCION
        ln_TOTAL          := 0;
        ln_pagocontencion := 0;
        ln_codcam         := 1; --contencion
      
        if lc_tipoase = 'P' then
        
          /*           begin
            pq_cr_contencion.sp_cr_valor_contencion(pd_fecpro => pd_fecpro,
                                                    pc_analista => i.jaql600usu,
                                                    pn_sucurs => i.jaql600age,
                                                    pn_basecon => ln_basecon,
                                                    pn_porcentaje => ln_porcontencion);
          end;*/
        
          --2017.03.15
          begin
            select j.jaqz452base,
                   j.jaqz452con,
                   case
                     when j.jaqz452base = 0 then
                      0
                     else
                      round(j.jaqz452con * 100 / j.jaqz452base, 2)
                   end porcentaje
              into ln_basecon, ln_contenidos, ln_porcontencion
              from jaqz452 j
             where j.jaqz452fpro = pd_fecpro
               and j.jaqz452ana = trim(i.jaql600usu) --lc_analista
               and j.jaqz452age = i.jaql600age;
          exception
            when no_data_found then
              ln_basecon       := 0;
              ln_porcontencion := 0;
              ln_contenidos    := 0;
          end;
          --2017.03.15
        
          begin
            ln_pagocontencion := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_contencion(pn_basecon => ln_basecon,
                                                                           pn_porcon  => ln_porcontencion);
          end;
        else
          --SI es CONVENIO no APLICA CONTENCION 2017.07.13
          ln_basecon        := 0;
          ln_porcontencion  := 0;
          ln_pagocontencion := 0;
          ln_codcam         := 0;
          ln_contenidos     := 0;
        end if;
      
        /*NOTA*/
        ---APLICAR PORCENTAJE DE CASTIGO A 
        --TOTAL DE PAGO POR CARTERA, CLIENTES Y RETENCION
        ln_TOTAL := ln_totalpagovariable + ln_pagocontencion;
      
        update JAQL600 j
           set JAQL600PSAL  = ln_pagsal_tot,
               JAQL600PCLI  = ln_pagcli_tot,
               JAQL600CSAL  = ln_pagsal,
               JAQL600ESAL  = ln_pagsal_adi,
               JAQL600CCLI  = ln_pagcli,
               JAQL600ECLI  = ln_pagcli_adi,
               JAQL600VMOR  = ln_varmor,
               JAQL600PMOR  = ln_pagmora,
               JAQL600POSA  = ln_porcumsal,
               JAQL600POCL  = ln_porcumcli,
               JAQL600EXSA  = ln_salexcedente,
               JAQL600EXCL  = ln_cliexcedente,
               JAQL600EXRE  = ln_retexcedente,
               JAQL600PRET  = ln_pagret_tot,
               JAQL600CRET  = ln_pagret,
               JAQL600ERET  = ln_pagret_adi,
               JAQL600CCAM  = ln_codcam,
               JAQL600VCAM  = ln_basecon,
               JAQL600TCAM  = ln_pagocontencion,
               JAQL600PCAM  = ln_porcontencion,
               JAQL600AUX1  = ln_contenidos,
               JAQL600MTMR  = ln_mora,
               JAQL600PJCA  = ln_incmor,
               JAQL600PJCAS = ln_pjcas,
               JAQL600PVAR  = ln_totalpagovariable,
               JAQL600BARE  = ln_baseret,
               JAQL600MORE  = ln_retenidos,
               JAQL600PORE  = ln_porretencion,
               JAQL600PMOA  = ln_pormoa,
               JAQL600CMRA  = ln_cascontinuidad,
               JAQL600INCO  = lc_excluir_cont,
               JAQL600NMES  = ln_nummes, /*
                               JAQL600SMORT = ln_salmorT,
                               JAQL600PMORT = ln_pormorT,*/
               JAQL600TOTPA = ln_TOTAL -- + CONTENCION
         where j.jaql600fpro = pd_fecpro
           and j.jaql600usu = i.jaql600usu;
      
        --inicializa variables  
        ln_excsal       := 0;
        ln_pagsal       := 0;
        ln_pagsal_adi   := 0;
        ln_pagsal_tot   := 0;
        ln_salexcedente := 0;
        ln_cresal       := 0;
        ln_metsal       := 0;
      
        ln_exccli       := 0;
        ln_pagcli       := 0;
        ln_pagcli_adi   := 0;
        ln_pagcli_tot   := 0;
        ln_cliexcedente := 0;
        ln_crecli       := 0;
        ln_metcli       := 0;
        ln_porcum       := 0;
      
        ln_metsal := 0;
        ln_metcli := 0;
        ln_metret := 0;
        ln_metmor := 0;
      
        ln_retexcedente := 0;
        ln_pagret       := 0;
        ln_pagret_adi   := 0;
        ln_pagret_tot   := 0;
        ln_retenidos    := 0;
        ln_porretencion := 0;
        ln_baseret      := 0;
        ln_excret       := 0;
      
        ln_salmorT := 0;
        ln_pormorT := 0;
      end if;
    end loop;
  
    commit;
  
  end sp_cr_cumplimiento_ini;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_variacion_mora(pc_analista IN char,
                                 pd_fecpro   IN date,
                                 pc_tipase   in char,
                                 pn_pormor   IN number,
                                 pn_pormoa   out number,
                                 pn_varmor   out number) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_mora_mesanterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.20
    -- Autor de Creación          : 
    -- Uso                        : Retorna Mora del Mes anterior o Menor Mora entre Rango de Meses
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : Porcentaje de Mora
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_pormoa jaql600.jaql600pmra%type;
    ld_fecfin date;
    ln_varmor number;
  
  begin
  
    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;
  
    --    if  pd_fecpro in ( to_Date('2016.10.31','yyyy.mm.dd'), to_Date('2016.05.31','yyyy.mm.dd') ) then
  
    --obtiene mora del mes anterior
    ---calcular nuevamente mora con castigos del ultimo mes, sin corporativos, con RL - CARTERA BRUTA
  
    ln_pormoa := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_nuevamora_anterior(pc_analista => pc_analista,
                                                                   pd_fecpro   => ld_fecfin,
                                                                   pd_fechoy   => pd_fecpro);
    /*        
         else
         
            Begin
              select JAQL600PMOA --mora del mes anterior
                into ln_pormoa
                from jaql600
               where jaql600usu = pc_analista
                 and jaql600fpro = ld_fecfin;
            exception
              when others then
                ln_pormoa := 0;
            end;
         end if;   
       
    */
    if nvl(ln_pormoa, 0) = 0 then
      --si no tiene mora el mes anterior variacion es la mora actual
      ln_varmor := nvl(pn_pormor, 0);
    else
        ln_varmor := nvl(pn_pormor, 0) - nvl(ln_pormoa, 0); ---2023.08.23

      --Determinar variacion de mora
       /* 2023.08.23 SE COMENTO PARA NUEVA PRODUCTIVAD
      if pc_tipase = 'C' then
      
        ln_varmor := nvl(pn_pormor, 0) - nvl(ln_pormoa, 0);
      else
       
        if ln_pormoa 
           > 5 then
          --Se evalua en base a la mora Inicial o del mes anterior
          ln_varmor := round(((nvl(pn_pormor, 0) / nvl(ln_pormoa, 0)) - 1) * 100,
                             2);
        else
          ln_varmor := nvl(pn_pormor, 0) - nvl(ln_pormoa, 0);
        end if;
      end if;
      */
    end if;
    pn_varmor := ln_varmor;
    pn_pormoa := ln_pormoa;
  
  end sp_cr_variacion_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_metamora(pc_tipase in char,
                          pn_pormor in number,
                          pn_varmor in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_metamora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          :  
    -- Uso                        : RETORNA EL Porcentaje de MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL587CODANA
    -- Parámetros de Salida       : PORCENTAJE CASTIGO
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
  
    lc_indmor char(1);
    ln_int1   number;
    ln_int2   number;
    ln_int3   number;
    ln_int4   number;
    ln_int5   number;
    ln_int6   number;
    ln_int7   number;
    ln_int8   number;
    ln_int9   number;
    ln_int10  number;
    ln_facmor number;
    ln_varmin number;
    ln_varmax number;
  
  begin
  
    if pn_pormor <= 5 then
      lc_indmor := 'M'; --menor a 5
    else
      --MAYOR O IGUAL A 5
      lc_indmor := 'S'; --superior
    end if;
  
    if pc_tipase = 'C' then
      lc_indmor := 'M';
    end if;
  
    begin
      select max(j.jaql597min), min(j.jaql597max)
        into ln_varmin, ln_varmax
        from jaql597 j
       where j.jaql597tip = pc_tipase
         and j.jaql597mor = lc_indmor
         and j.jaql597min <= pn_varmor
         and pn_varmor <= j.jaql597max;
    exception
      when no_Data_found then
        ln_varmin := 0;
        ln_varmax := 0;
    end;
  
    /*if pn_varmor > 0 then --si variacon es positiva
        begin
         select max(j.jaql597min),min( j.jaql597max) 
           into ln_varmin, ln_varmax
           from jaql597 j
          where j.jaql597tip = pc_tipase
            and j.jaql597mor = lc_indmor
            and j.jaql597min <= pn_varmor
            and pn_varmor <= j.jaql597max;
        exception when no_Data_found then
            ln_varmin := 0; 
            ln_varmax := 0; 
        end;
    else --si variacion es negativa
        begin
         select min(j.jaql597min),max( j.jaql597max) 
           into ln_varmin, ln_varmax
           from jaql597 j
          where j.jaql597tip = pc_tipase
            and j.jaql597mor = lc_indmor
            and j.jaql597min >= pn_varmor
            and pn_varmor >= j.jaql597max;
        exception when no_Data_found then
            ln_varmin := 0; 
            ln_varmax := 0; 
        end;
    
    end if;*/
  
    -- if ln_varmin > 0 then
    begin
      select j.jaql597i1,
             j.jaql597i2,
             j.jaql597i3,
             j.jaql597i4,
             j.jaql597i5,
             j.jaql597i6,
             j.jaql597i7,
             j.jaql597i8,
             j.jaql597i9,
             j.jaql597i10
        into ln_int1,
             ln_int2,
             ln_int3,
             ln_int4,
             ln_int5,
             ln_int6,
             ln_int7,
             ln_int8,
             ln_int9,
             ln_int10
        from jaql597 j
       where j.jaql597tip = pc_tipase
         and j.jaql597mor = lc_indmor
         and j.jaql597min = ln_varmin
         and j.jaql597max = ln_varmax;
    exception
      when no_Data_found then
        ln_int1  := 0;
        ln_int2  := 0;
        ln_int3  := 0;
        ln_int4  := 0;
        ln_int5  := 0;
        ln_int6  := 0;
        ln_int7  := 0;
        ln_int8  := 0;
        ln_int9  := 0;
        ln_int10 := 0;
    end;
  
    --end if;
  
    --si es pymes
    if pc_tipase = 'P' then
    
      if pn_pormor <= 5 then
        case
          when pn_pormor >= 0 and pn_pormor <= 0.5 then
            ln_facmor := ln_int1;
          when pn_pormor > 0.5 and pn_pormor <= 1 then
            ln_facmor := ln_int2;
          when pn_pormor > 1 and pn_pormor <= 1.5 then
            ln_facmor := ln_int3;
          when pn_pormor > 1.5 and pn_pormor <= 2 then
            ln_facmor := ln_int4;
          when pn_pormor > 2 and pn_pormor <= 2.5 then
            ln_facmor := ln_int5;
          when pn_pormor > 2.5 and pn_pormor <= 3.0 then
            ln_facmor := ln_int6;
          when pn_pormor > 3.0 and pn_pormor <= 3.5 then
            ln_facmor := ln_int7;
          when pn_pormor > 3.5 and pn_pormor <= 4 then
            ln_facmor := ln_int8;
          when pn_pormor > 4 and pn_pormor <= 4.5 then
            ln_facmor := ln_int9;
          when pn_pormor > 4.5 and pn_pormor <= 5 then
            ln_facmor := ln_int10;
          else
            ln_facmor := 0;
        end case;
      
      else
        --Mora Mayor a 5
      
        case
          when pn_pormor >= 5.01 and pn_pormor <= 7.5 then
            ln_facmor := ln_int1;
          when pn_pormor >= 7.51 and pn_pormor <= 10 then
            ln_facmor := ln_int2;
          when pn_pormor >= 10.01 then
            ln_facmor := ln_int3;
          else
            ln_facmor := 0;
        end case;
      
      end if;
    
    else
      --para consumo
    
      case
        when pn_pormor >= 0 and pn_pormor <= 1 then
          ln_facmor := ln_int1;
        when pn_pormor >= 1.01 and pn_pormor <= 2 then
          ln_facmor := ln_int2;
        when pn_pormor >= 2.01 and pn_pormor <= 3 then
          ln_facmor := ln_int3;
        when pn_pormor >= 3.01 and pn_pormor <= 4 then
          ln_facmor := ln_int3;
        when pn_pormor >= 4.01 and pn_pormor <= 5 then
          ln_facmor := ln_int4;
        when pn_pormor >= 5 then
          ln_facmor := ln_int5;
        else
          ln_facmor := 0;
      end case;
    
    end if;
    return nvl(ln_facmor, 0);
  
  end fn_cr_metamora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_nuevosaldo_anterior(pc_analista IN char,
                                      pd_fecpro   IN date,
                                      pc_codage   in number,
                                      pn_salant   out number,
                                      pn_cliant   out number) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_nuevosaldo_anterior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.28
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve el saldo anterior, excluye corporativos judiciales y castigos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : ln_salant: saldo anterior del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_salant   number(18, 2);
    ln_cliant   number;
    lc_analista char(10);
  
  begin
  
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    begin
      select /*+all_rows */
       sum(a.jaql965sdmn) Saldo_cartera,
       count(distinct a.jaql965ndoc) Nro_clientes --,
        into ln_salant, ln_cliant
        from JAQL965 a
       where a.jaql965fech = pd_fecpro
         and a.jaql965ase = lc_analista
         and a.jaql965suc = pc_codage
         and a.jaql965mod not in (108, 33 /*, 200*/)
         and substr(a.jaql965tcrd, 1, 11) <> 'CORPORATIVO'
         and (a.jaql965cta, a.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
       group by a.jaql965ase, a.jaql965suc;
    exception
      when no_data_found then
        ln_salant := 0;
        ln_cliant := 0;
    end;
  
    pn_salant := ln_salant;
    pn_cliant := ln_cliant;
  
  end sp_cr_nuevosaldo_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_agencia_anterior(pc_analista IN char, pd_fecpro IN date)
    return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_AGENCIA_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna el codigo de sucursal del mes anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : ln_codsuc: saldo anterior del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codsuc   number;
    ld_fecfin   date;
    lc_analista char(10);
  
  begin
  
    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;
  
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    if pd_fecpro in (to_date('2016.10.31', 'yyyy.mm.dd'),
                     to_date('2016.05.31', 'yyyy.mm.dd')) then
    
      begin
        select j.jaql583age
          into ln_codsuc
          from jaql583 j
         where j.jaql583fpro = ld_fecfin
           and j.jaql583usu = lc_analista;
      exception
        when no_data_found then
          ln_codsuc := 0;
      end;
    
    else
    
      Begin
        select j.jaql600age
          into ln_codsuc
          from jaql600 j
         where jaql600usu = pc_analista
           and jaql600fpro = ld_fecfin;
      exception
        when others then
          --  ln_codsuc := 0;
          begin
          
            ln_codsuc := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => lc_analista,
                                                                pd_fecpro   => ld_fecfin);
          exception
            when others then
              ln_codsuc := 0;
          end;
      end;
    
    end if;
  
    return ln_codsuc;
  
  end fn_cr_agencia_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_continuidad_mora(pc_analista IN varchar2,
                                  pd_fecpro   in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_continuidad_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Evalua 3 meses consecutivos la mora y si el ratio se ha incrementado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    lc_analista char(10);
    ln_varmor   number := 0;
    ln_morini   number := 0;
    ln_mora     number := 0;
    ln_moraFin  number := 0;
    ln_moraIni  number := 0;
    ld_fecfin   date;
  
  begin
  
    --obtener mora de los 3 ultimos meses
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    for x in 0 .. 2 loop
      ln_morini := ln_mora;
    
      if x = 0 then
        ld_fecfin := pd_fecpro;
      else
        ld_fecfin := last_day(add_months(trunc(pd_fecpro), -x));
      end if;
    
      begin
        select j.JAQL600PMOA, j.jaql600pmra
          into ln_moraIni, ln_moraFin
          from jaql600 j
         where j.jaql600fpro = ld_fecfin
           and j.jaql600usu = lc_analista
           and j.jaql600codcat <> 0; --2017.10.04
      exception
        when no_Data_found then
          ln_moraFin := 0;
          ln_moraIni := 0;
          ln_varmor  := 0;
          exit; --sino cumple 3 meses seguidosno hay continuidad        
      end;
    
      ln_mora := ln_moraFin - ln_moraIni;
      --if x > 0 then
      ln_varmor := ln_varmor + ln_mora;
      --end if;
    
    end loop;
  
    return nvl(ln_varmor, 0);
  
  end fn_cr_continuidad_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_bonoTrimestral(pd_fecpro   in date,
                                 pc_analista in varchar2,
                                 pc_codage   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_bonoTrimestral
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE BONO TRIMESTRAL POR CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
      select *
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%';
    --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );
  

    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_metsal          number;
    ln_metcli          number;
    ln_metret          number;
    ln_metmor          number;
  
    ln_mtoret       number;
    ln_pagsal       number;
    ln_salexcedente number;
    ln_pagsal_adi   number;
    ln_pagsal_tot   number;
    ln_pagcli       number;
    ln_cliexcedente number;
    ln_pagcli_adi   number;
    ln_pagcli_tot   number;
  
    ln_exccli number;
    ln_excsal number;
    ln_porcum number;
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_mto_cartera  number := 0;
    ln_mto_clientes number := 0;
    ln_monto_mora   number := 0;
    ln_pago         number;
    ln_pagmor       number := 0;
    ln_incmora      number;
    ln_porsal       number;
    ln_porcli       number;
    ln_prom_sal     number := 0;
    ln_prom_cli     number := 0;
    lc_indicar      char(1) := 'N';
    ln_sal          number := 0;
    ln_cli          number := 0;
    ln_nummes       number;
    ld_fecfin       date;
    ln_mtosal       number;
    ln_mtocli       number;
    ln_minsal       number;
    ln_mincli       number;
    ln_prominsal    number := 0;
    ln_promincli    number := 0;
  
    lc_analista varchar2(10) := null;
  
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista := pc_analista;
    end if;
    ln_nummes := to_number(to_char(pd_fecpro, 'mm'));
  
    IF ln_nummes in (3, 6, 9, 12) then
      -- pd_fecpro SI MES ES 3,6 ,9,12 PAGAR BONOT TRIMESTRAL.
    
      for i in analistas(lc_analista) loop
      
        if i.jaql600mtsa <> 0 then
        
          lc_indicar := 'N';
        
          ln_sal := 0;
          ln_cli := 0;
        
          for x in 0 .. 2 loop
          
            ld_fecfin := last_day(add_months(trunc(pd_fecpro), -x));
          
            /*               begin
                 select nvl(j.JAQL600POSA,0), nvl(j.jaql600pocl,0)
                   into ln_porsal, ln_porcli
                   from jaql600 j
                  where j.jaql600fpro = ld_fecfin
                    and j.jaql600usu = i.jaql600usu;
            exception 
              when no_Data_found then
                ln_porsal := 0;
                ln_porcli := 0;
              when others then
                ln_porsal := 0;
                ln_porcli := 0;  
            end;
            
            if ln_porsal > 100 then
                   ln_prom_sal := ln_prom_sal + ln_porsal;
                   ln_sal := ln_sal + 1;
            end if;
            if ln_porcli > 100 then
                   ln_prom_cli := ln_prom_cli + ln_porcli;
                   ln_cli := ln_cli + 1;                
            end if;*/
          
            --MODIFICAR VALIDANDO CRECIIENTOS
          
            begin
              select JAQL600CRSA, JAQL600CRCL, JAQL600MTSA, JAQL600MTCL
                into ln_mtosal, ln_mtocli, ln_minsal, ln_mincli
                from jaql600 j
               where j.jaql600fpro = ld_fecfin
                 and j.jaql600usu = i.jaql600usu
                 and j.jaql600codcat <> 0; --2017.10.04
            exception
              when no_Data_found then
                ln_mtosal := 0;
                ln_mtocli := 0;
                ln_minsal := 0;
                ln_mincli := 0;
              when others then
                ln_mtosal := 0;
                ln_mtocli := 0;
                ln_minsal := 0;
                ln_mincli := 0;
            end;
          
            if (ln_mtosal - ln_minsal) >= 0 AND ln_mtosal > 0 then
              ln_prom_sal  := ln_prom_sal + ln_mtosal;
              ln_prominsal := ln_prominsal + ln_minsal;
              ln_sal       := ln_sal + 1;
            end if;
            if (ln_mtocli - ln_mincli) >= 0 AND ln_mtocli > 0 then
              ln_prom_cli  := ln_prom_cli + ln_mtocli;
              ln_promincli := ln_promincli + ln_mincli;
              ln_cli       := ln_cli + 1;
            end if;
          
          end loop;
        
          if ln_sal = 3 then
            --cumplio 3 meses en cartera
            --comisiona
            --ln_prom_sal := round(ln_prom_sal/3,2);
            if ln_prominsal <> 0 then
              ln_prom_sal := round(ln_prom_sal / ln_prominsal, 2) * 100;
            else
              ln_prom_sal := 0;
            end if;
          
            --bono cartera 
            begin
              SELECT JAQZ453MTO
                into ln_mto_cartera
                FROM JAQZ453
               WHERE ln_prom_sal >= JAQZ453MIN
                 AND ln_prom_sal < JAQZ453MAX
                 AND JAQZ453CAT = i.jaql600codcat
                 AND JAQZ453TIP = 'S';
            exception
              when no_Data_found then
                ln_mto_cartera := 0;
            end;
          
          end if;
        
          if ln_cli = 3 then
            --cumplio 3 meses en clientes 
            --ln_prom_cli := round(ln_prom_cli/3,2);
            if ln_promincli <> 0 then
              ln_prom_cli := round(ln_prom_cli / ln_promincli, 2) * 100;
            else
              ln_prom_cli := 0;
            end if;
          
            --bono clientes 
            begin
              SELECT JAQZ453MTO
                into ln_mto_clientes
                FROM JAQZ453
               WHERE ln_prom_cli >= JAQZ453MIN
                 AND ln_prom_cli < JAQZ453MAX
                 AND JAQZ453CAT = i.jaql600codcat
                 AND JAQZ453TIP = 'C';
            exception
              when no_Data_found then
                ln_mto_clientes := 0;
            end;
          
          end if;
        
          --ln_incmora := i.JAQL600PJCA;
          --valida continuidad se multiplica por negativo 
          ln_incmora :=  /*(-1)**/
           PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora(i.jaql600usu,
                                                                        pd_fecpro);
        
          if ln_incmora < 1 then
            --- puede comisionar
            case
              when ln_incmora > 0 and ln_incmora <= 0.9 then
                ln_pagmor := 50;
              when ln_incmora = 0 then
                ln_pagmor := 100;
              when ln_incmora <= -0.01 and ln_incmora >= -1 then
                ln_pagmor := 115;
              when ln_incmora <= -1.01 then
                ln_pagmor := 130;
              else
                ln_pagmor := 0;
            end case;
            ln_pago := (ln_mto_cartera + ln_mto_clientes) * ln_pagmor / 100;
          else
            ln_pago := 0;
          end if;
        
          --ln_pago := ln_mto_cartera + ln_mto_clientes + ln_monto_mora;
        
          update JAQL600 j
             set JAQL600BSAL  = ln_mto_cartera,
                 JAQL600BCLI  = ln_mto_clientes,
                 JAQL600BMRA  = ln_pagmor / 100,
                 JAQL600BTRI  = ln_pago,
                 JAQL600TOTPA = JAQL600PVAR + JAQL600TCAM + ln_pago
           where j.jaql600fpro = pd_fecpro
             and j.jaql600usu = i.jaql600usu;
        
          ln_pago         := 0;
          ln_mto_cartera  := 0;
          ln_mto_clientes := 0;
          ln_pagmor       := 0;
          ln_incmora      := 0;
          ln_monto_mora   := 0;
          ln_prom_sal     := 0;
          ln_prom_cli     := 0;
          ln_prominsal    := 0;
          ln_promincli    := 0;
        
        end if;
      
      end loop;
    
      commit;
    
    END IF;
  
  end sp_cr_bonoTrimestral;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_contencion(pn_basecon in number, pn_porcon in number)
    return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          :  
    -- Uso                        : RETORNA EL BONO por CONTENCION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : MONTO CONTENCION
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_int1    number;
    ln_int2    number;
    ln_int3    number;
    ln_int4    number;
    ln_pagocon number;
  
  begin
  
    begin
      select j.jaql598i1, j.jaql598i2, j.jaql598i3, j.jaql598i4
        into ln_int1, ln_int2, ln_int3, ln_int4
        from jaql598 j
       where pn_porcon >= jaql598min
         and pn_porcon < jaql598max;
    exception
      when no_Data_found then
        ln_int1 := 0;
        ln_int2 := 0;
        ln_int3 := 0;
        ln_int4 := 0;
    end;
  
    case
      when pn_basecon >= 0 and pn_basecon <= 50000 then
        ln_pagocon := ln_int1;
      when pn_basecon > 50000 and pn_basecon <= 150000 then
        ln_pagocon := ln_int2;
      when pn_basecon > 150000 and pn_basecon <= 300000 then
        ln_pagocon := ln_int3;
      when pn_basecon > 300000 then
        ln_pagocon := ln_int4;
      else
        ln_pagocon := 0;
    end case;
  
    return nvl(ln_pagocon, 0);
  
  end fn_cr_contencion;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nuevamora_anterior(pc_analista IN varchar2,
                                    pd_fecpro   in date,
                                    pd_fechoy   in date) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_pormor    number := 0;
    ln_saljud    number := 0;
    ln_nummes    number := 0;
    ln_cont      number := 0;
    ln_saldo     number := 0;
    ln_salmor    number := 0;
    ln_dias      number := 365;
    ln_salrec    number := 0;
    ln_nuevamora number := 0;
    ln_monto     number := 0;
    ln_cliant    number := 0;
    ln_codage    number := 0;
    lc_analista  char(10);
    ln_saltoT    number := 0;
    ln_salmorT   number := 0;
    ln_ageact    number := 0;
    ld_fecact    date;
  
  begin
  
    --obtener mora de los 3 ultimos meses
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    if pd_fecpro in (to_Date('2016.09.30', 'yyyy.mm.dd')) then
      ---lc_codage ..agencia en la que estuvo mes anterior
      Begin
        select jaql583age
          into ln_codage
          from jaql583
         where jaql583usu = lc_analista --pc_analista
           and jaql583fpro = pd_fecpro;
      exception
        when others then
          ln_codage := 0;
      end;
      --
    else
      -- /*2017.03.21
      Begin
        select jaql600age
          into ln_codage
          from jaql600
         where jaql600usu = lc_analista --pc_analista
           and jaql600fpro = pd_fecpro;
      exception
        when others then
          -- ln_codage := 0;
          ln_codage := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => pc_analista,
                                                              pd_fecpro   => pd_fecpro);
        
      end;
      --20170321
    
    end if;
  
    /*if ln_codage <> 0 then */
  
    --Obtener saldo de traslado al cierre de mes anterior ln_saltot, ln_salmorT
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_saldostraslados(pc_analista,
                                                     pd_fecpro,
                                                     pd_fechoy,
                                                     ln_saltoT,
                                                     ln_salmorT);
    end;
  
    ld_fecact := pd_fechoy; --add_months( pd_fecpro, 1); 2018.01.12
  
    --agencia actual
    begin
      select jaql600age
        into ln_ageact
        from jaql600
       where jaql600fpro = ld_fecact
         and jaql600usu = pc_analista;
    exception
      when no_Data_found then
        ln_ageact := 0;
    end;
    ---   
    if ln_ageact = ln_codage then
    
      ln_saljud := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_judicial(pc_analista,
                                                               pd_fecpro,
                                                               ln_codage);
      --no considerar castigos del mes 2016.11.24
      ln_salmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_mora(pc_analista,
                                                             pd_fecpro,
                                                             ln_codage);
    
      begin
      
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => pc_analista,
                                                           pd_fecpro   => pd_fecpro,
                                                           pc_codage   => ln_codage,
                                                           pn_salant   => ln_saldo,
                                                           pn_cliant   => ln_cliant);
      end;
    else
      ln_saldo  := 0;
      ln_cliant := 0;
      ln_saljud := 0;
      ln_salmor := 0;
    end if;
  
    ---calcular mora 
    if (ln_saldo + ln_saljud + ln_salmorT + ln_saltoT) > 0 then
      ln_pormor := round((ln_salmor + ln_saljud + ln_salmorT) /
                         (ln_saldo + ln_saltoT) * 100,
                         2);
      --no suma ln_saljud porque en ln_saldo ya esta incluido el saldo judicial
    else
      ln_pormor := 0;
    end if;
    /*else 
         ln_pormor := 0;    --  NUEVO ANALISTA
    end if; */
  
    return nvl(ln_pormor, 0);
  
  end fn_cr_nuevamora_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_indicadores(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
    
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
    
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50);     
   
    
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
 

    lc_paquete    := 'PQ_CR_PRODUCTIVIDAD_NUEVA';
    lc_proceso    := 'sp_cr_indicadores_new';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  

    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
    
     
    --2025.01.15 determina numero de jobs
    begin
       select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10 
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
     exception when others then
       lb_njobs := 25;
     end;    
   
    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_indicadores_new( TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                     ' );' || ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRD', ln_ini, lc_variable);
      COMMIT;
    
    
      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


    end loop;

    --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs  
     
  
  end sp_cr_job_indicadores;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_cumplimiento(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
    
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
 
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50);     
    
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
 

    lc_paquete    := 'PQ_CR_PRODUCTIVIDAD_NUEVA';
    lc_proceso    := 'sp_cr_cumplimiento';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  
    
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
    
     
    --2025.01.15 determina numero de jobs
    begin
       select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10 
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
     exception when others then
       lb_njobs := 25;
     end; 
  
    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cumplimiento( TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                     ' );' || ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRD', ln_ini, lc_variable);
      COMMIT;


      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


    
    end loop;
 
    --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs   
 
 
  end sp_cr_job_cumplimiento;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_desembolsos_ini(pd_fecpro     in date,
                                  pc_analista   in varchar2,
                                  pn_saldo      out number,
                                  pn_porpago    out number,
                                  pn_porcentaje out number,
                                  pn_saldotot   out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_desembolsos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE TOTAL Y PORCENTAJE DE DESEMBOLSOS DEL MES MICRO Y PEQUEÑA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecini   date;
    ln_saldotot number;
    ln_saldo    number;
    ln_pordes   number;
    ln_porpagT  number;
    ln_porpagP  number;
    lc_analista char(10);
  
  begin
  
    ld_fecini   := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    lc_analista := rpad(pc_analista, 10, ' ');
  
    --     pn_saldo out number, pn_porcentaje out number, pc_indicador out char
  
    --desembolsos Micro y Pequeña Empresa
    begin
      select sum(JAQL965sdmn) -- 
        into ln_saldo
        from JAQL965
       WHERE JAQL965FECH = pd_fecpro
         and JAQL965ASE = lc_analista
         AND JAQL965Fval >= ld_fecini
         AND JAQL965Fval <= pd_fecpro
         AND substr(jaql965tcrd, 1, 2) in ('MI', 'PE');
    exception
      when others then
        ln_saldo := 0;
    end;
  
    --total desembolsos
    begin
      select sum(JAQL965sdmn) --
        into ln_saldotot
        from JAQL965
       WHERE JAQL965FECH = pd_fecpro
         and JAQL965ASE = lc_analista
         AND JAQL965Fval >= ld_fecini
         AND JAQL965Fval <= pd_fecpro;
    exception
      when others then
        ln_saldotot := 0;
    end;
  
    if ln_saldotot is null then
      ln_saldotot := 0;
    end if;
    if ln_saldo is null then
      ln_saldo := 0;
    end if;
  
    --porcentaje de desembolsos permitido
    begin
      select tp1nro1, tp1nro2, tp1nro3
        into ln_pordes, ln_porpagT, ln_porpagP
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 12;
    exception
      when others then
        ln_pordes := 0;
    end;
  
    if ln_saldotot <> 0 then
    
      pn_porcentaje := round(ln_saldo * 100 / ln_saldotot, 2);
      pn_saldo      := ln_saldo;
      pn_saldotot   := ln_saldotot;
    
      /*if pn_porcentaje >= ln_pordes then
         
         pn_porpago := ln_porpagT;
      else
         
         pn_porpago := ln_porpagP;
      end if;*/
    else
    
      pn_porpago    := 0;
      pn_saldo      := ln_saldo;
      pn_saldotot   := 0;
      pn_porcentaje := 0;
    
    end if;
  
    if pn_porcentaje >= ln_pordes then
    
      pn_porpago := ln_porpagT;
    else
    
      pn_porpago := ln_porpagP;
    end if;
  
  end sp_cr_desembolsos_ini;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_inserta_desembolsos(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_desembolsos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQZ455
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecini   date;
    ld_fecfin   date;
    ld_feccan   date;
    ln_num      number := 0;
    lc_producto char(2);
    ln_bcgpo    number;
    lc_analista char(10);
  
    cursor creditos is
      select distinct f.jaqz454cta, f.jaqz454oper, f.jaqz454fpro
        from JAQZ454 f, fsd011 g
       where f.jaqz454fpro = pd_fecpro
         and g.pgcod = 1
         and g.sccta = f.jaqz454cta
         and g.scoper = f.jaqz454oper
         and REGEXP_LIKE(g.scrub, '^14.[1-6]')
         and g.scgru in (5, 6, 7, 8, 9, 10);
  
    cursor maestro is
      select /*+PARALLEL(f,4) +PARALLEL(j,4) */
      --   fn_analista_credito(f.aomod,f.aosuc, f.aomda,f.aopap, f.aocta,f.aooper, f.aosbop,f.aotope) analista,
       f.*, j.*
        from fsd010 f, jaqz454 j, fst111 k
       where f.pgcod = 1
         and f.aocta = j.jaqz454cta
         and f.aomod = k.modulo
         and f.aooper = j.jaqz454oper
         and k.dscod = 50
         and j.jaqz454fpro = pd_fecpro;
  
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    ld_fecfin := last_Day(pd_fecpro);
  
    begin
      delete from JAQZ454 where JAQZ454FPRO = pd_fecpro;
      commit;
    exception when others then
      null;  
    end;      
    /*efuentes 2021.11.09*/  --2024.03.22 dcastro se comento porque no invoca a recategoriza
   /* delete from AQPB617A where AQPB617AFPRO = pd_fecpro;
    commit;*/
    /*efuentes 2021.11.09*/
    begin
      
      insert into JAQZ454
        (JAQZ454CTA,
         JAQZ454OPER,
         jaqz454fpro,
         JAQZ454FCON,
         JAQZ454MDA,
         JAQZ454IMP1,
         JAQZ454SUCU,
         JAQZ454COD,
         JAQZ454MOD,
         JAQZ454SUCOR,
         JAQZ454TRAN,
         JAQZ454NREL,
         JAQZ454RUBRO)    
        SELECT /*+PARALLEL(H15,16) PARALLEL(H16,16)*/
         H16.HCTA,
         H16.hoper,
         pd_fecpro,
         H16.HFCON,
         H16.HMDA,
         H16.HCIMP1,
         H16.HSUCUR,
         H16.PGCOD,
         H16.HCMOD,
         H16.HSUCOR,
         H16.HTRAN,
         H16.HNREL,
         H16.HRUBRO
          FROM FSH015 H15, FSH016 H16
         WHERE H16.PGCOD = H15.PGCOD
           AND H16.HCMOD = H15.HCMOD
           AND H16.HSUCOR = H15.HSUCOR
           AND H16.HTRAN = H15.HTRAN
           AND H16.HNREL = H15.HNREL
           AND H16.HFCON = H15.HFCON
           AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
           AND H16.HFVCO = H15.HFCON
           AND H15.PGCOD = 1
           AND H15.HCCORR <> 99
           AND H16.HCODMO = 1
           AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
           and h16.HSUCOR in (select f.sucurs from fst001 f) ---2024.03.22 dcastro se agrego para optimizar
          /* AND ((H16.HCMOD = 116 AND H16.HTRAN IN (50, 60, 200)) OR
               (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
               (H16.HCMOD = 30 AND H16.HTRAN IN (360, 951)));
           */
           --2023.10.10 se agrego transacciones BI
           AND ( H16.HCMOD,H16.HTRAN) IN (select tp1nro1, tp1nro2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 10847
                         and tp1corr1 = 33 
                         and tp1imp1 = 0)
                 ;
         commit;
    exception when others then
      null;  
    end;              

      /*efuentes 2021.11.09*/
      /*insert into AQPB617A
        (AQPB617ACTA,
         AQPB617AOPER,
         AQPB617AFPRO,
         AQPB617AFCON,
         AQPB617AMDA,
         AQPB617AIMP1,
         AQPB617ASUCU,
         AQPB617ACOD,
         AQPB617AMOD,
         AQPB617ASUCOR,
         AQPB617ATRAN,
         AQPB617ANREL,
         AQPB617ARUBRO)*/
        --SELECT /*+PARALLEL(H15,16) PARALLEL(H16,16)*/
        /*H16.HCTA,
         H16.hoper,
         pd_fecpro,
         H16.HFCON,
         H16.HMDA,
         H16.HCIMP1,
         H16.HSUCUR,
         H16.PGCOD,
         H16.HCMOD,
         H16.HSUCOR,
         H16.HTRAN,
         H16.HNREL,
         H16.HRUBRO
          FROM FSH015 H15, FSH016 H16
         WHERE H16.PGCOD = H15.PGCOD
           AND H16.HCMOD = H15.HCMOD
           AND H16.HSUCOR = H15.HSUCOR
           AND H16.HTRAN = H15.HTRAN
           AND H16.HNREL = H15.HNREL
           AND H16.HFCON = H15.HFCON
           AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
           AND H16.HFVCO = H15.HFCON
           AND H15.PGCOD = 1
           AND H15.HCCORR <> 99
           AND H16.HCODMO = 1
           AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
           AND ((H16.HCMOD = 116 AND H16.HTRAN IN (50, 200)) OR
               (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
               (H16.HCMOD = 30 AND H16.HTRAN IN (360, 951)));
      --efuentes 2021.11.09
      commit;
       */
      --eliminar corporativos
      /*for i in creditos loop
          delete from jaqz454 j where j.jaqz454cta  = i.jaqz454cta and j.jaqz454oper = i.jaqz454oper and j.jaqz454fpro = i.jaqz454fpro;
          commit;  
      end loop;*/
      ---
  
    for i in maestro loop
      --busca el codigo de analista a fin de mes, en caso no exista el credito se cancelo, buscar el analista con el que quedo
      begin
        select j.jaql965ase
          into lc_analista
          from jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = 1
           and j.jaql965mod = i.aomod
           and j.jaql965suc = i.aosuc
           and j.jaql965mda = i.aomda
           and j.jaql965pap = i.aopap
           and j.jaql965cta = i.aocta
           and j.jaql965oper = i.aooper
           and j.jaql965sbop = i.aosbop;
      exception
        when no_data_found then
          lc_analista := fn_analista_credito(i.aomod,
                                             i.aosuc,
                                             i.aomda,
                                             i.aopap,
                                             i.aocta,
                                             i.aooper,
                                             i.aosbop,
                                             i.aotope);
      end;
    
      CASE
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]02') THEN
          ln_bcgpo := 2; --LC_PROD := 'MICROEMPRESA';
      --WHEN REGEXP_LIKE(i.jaqz454rub,'^14.[1-6]03....015') THEN LC_PROD := 'CONSUMO REVOLVENTE';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]03') THEN
          ln_bcgpo := 3; --LC_PROD := 'CONSUMO NO REVOLVENTE';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]04') THEN
          ln_bcgpo := 4; --LC_PROD := 'HIPOTECARIO';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]11') THEN
          ln_bcgpo := 11; --LC_PROD := 'GRANDES EMPRESAS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]12') THEN
          ln_bcgpo := 12; --LC_PROD := 'MEDIANAS EMPRESAS';           
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]13') THEN
          ln_bcgpo := 13; --LC_PROD := 'PEQUEÑAS EMPRESAS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]05') THEN
          ln_bcgpo := 5; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]06') THEN
          ln_bcgpo := 6; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]07') THEN
          ln_bcgpo := 7; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]08') THEN
          ln_bcgpo := 8; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]09') THEN
          ln_bcgpo := 9; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]10') THEN
          ln_bcgpo := 10; --LC_PROD := 'CORPORATIVOS';
      END CASE;
    
      case
        when ln_bcgpo = 2 then
          lc_producto := 'MI';
        when ln_bcgpo = 3 then
          lc_producto := 'CN';
        when ln_bcgpo = 4 then
          lc_producto := 'HI';
        when ln_bcgpo = 11 then
          lc_producto := 'GR';
        when ln_bcgpo = 12 then
          lc_producto := 'ME';
        when ln_bcgpo = 13 then
          lc_producto := 'PE';
        when ln_bcgpo in (5, 6, 7, 8, 9, 10) then
          lc_producto := 'CO';
        else
          lc_producto := null;
      end case;
    
      if lc_producto = 'CO' then
        delete from jaqz454 j
         where j.jaqz454cta = i.jaqz454cta
           and j.jaqz454oper = i.jaqz454oper
           and j.jaqz454fpro = i.jaqz454fpro;
      else
        update jaqz454
           set jaqz454ase = lc_analista, jaqz454pro = lc_producto
         where jaqz454cta = i.jaqz454cta
           and jaqz454oper = i.jaqz454oper
           and jaqz454fpro = pd_fecpro;
           
        /*efuentes 2021.11.09*/
        /*update AQPB617A A
           set A.AQPB617AASE = lc_analista, A.AQPB617APRO = lc_producto
         where A.AQPB617ACTA  = i.jaqz454cta
           and A.AQPB617AOPER = i.jaqz454oper
           and A.AQPB617AFPRO = pd_fecpro;*/
        /*efuentes 2021.11.09*/
      end if;
    
      commit;
      lc_analista := null;
    
    end loop;
  
    --eliminando creditos de tesoreria
    delete from jaqz454 j
     where (j.jaqz454cta, j.jaqz454oper) in
           (select bccta, bcoper from jaqz498)
       and j.jaqz454fpro = pd_fecpro;
    
    /*efuentes 2021.11.09*/
    /*delete from aqpb617a a
     where (a.aqpb617acta, a.aqpb617aoper) in
           (select bccta, bcoper from jaqz498)
       and a.aqpb617afpro = pd_fecpro;*/       
    /*efuentes 2021.11.09*/
           
    --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs  
    --commit;
    
    
/*    --2024.03.22 dcastro se comento porque ya existe en job
    begin
        pq_cr_productividad_nueva.sp_cr_inserta_desembolsos_recategorizacion(pd_fecpro);
    exception
      when others then
        null;
     end;
     */
  end sp_cr_inserta_desembolsos;
  
  procedure sp_cr_inserta_desembolsos_recategorizacion(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_desembolsos_recategorizacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          :
    -- Uso                        : INSERTA TRASLADOS JAQZ455
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : Ecollado
    -- Descripción de Modificación:
    --                            :  2023.11.21 se agregó condicion de fecha de proceso i.aqpb617afpro    
    --                            :  2024.03.22 se agrego condicion sucursal en FSH016 para optimizacion 
    -- *****************************************************************
     ld_fecini   date;
    ld_fecfin   date;
    ld_feccan   date;
    ln_num      number := 0;
    lc_producto char(2);
    ln_bcgpo    number;
    lc_analista char(10);
    lc_analista_varchar2 varchar2(100);
    
    /*=== INI - MAYCOL - 23/10/2023 - IGS - NEW ===*/
    V_CLIENTE_INACTIVO VARCHAR2(1);
    V_ORIGEN_CAPTACION NUMBER(4);
    V_NOMBRE_ORIGEN_CAPTACION VARCHAR2(30);
    V_USUARIO_CAPTACION VARCHAR2(10);
    /*=== FIN - MAYCOL - 23/10/2023 - IGS - NEW ===*/ 
  
    cursor maestro is
      select /*+PARALLEL(f,4) +PARALLEL(j,4) */
      --   fn_analista_credito(f.aomod,f.aosuc, f.aomda,f.aopap, f.aocta,f.aooper, f.aosbop,f.aotope) analista,
       f.*,a.*
        from fsd010 f, aqpb617a a,--jaqz454 j,
         fst111 k
       where f.pgcod = 1
         and f.aocta = a.aqpb617acta
         and f.aomod = k.modulo
        and f.aooper = a.aqpb617aoper
         and k.dscod = 50
         and a.aqpb617afpro = pd_fecpro;
        --and f.aocta = 2924335 and f.aooper= 13937571;

  begin

    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    ld_fecfin := last_Day(pd_fecpro);

    /*efuentes 2021.11.09 tabla para recategorización*/
    delete from AQPB617A where AQPB617AFPRO = pd_fecpro;
    commit;

    /*efuentes 2021.11.09*/
    insert into AQPB617A
      (AQPB617ACTA,
       AQPB617AOPER,
       AQPB617AFPRO,
       AQPB617AFCON,
       AQPB617AMDA,
       AQPB617AIMP1,
       AQPB617ASUCU,
       AQPB617ACOD,
       AQPB617AMOD,
       AQPB617ASUCOR,
       AQPB617ATRAN,
       AQPB617ANREL,
       AQPB617ARUBRO)
      /*SELECT
       H16.HCTA,
       H16.hoper,
       pd_fecpro,
       H16.HFCON,
       H16.HMDA,
       H16.HCIMP1,
       H16.HSUCUR,
       H16.PGCOD,
       H16.HCMOD,
       H16.HSUCOR,
       H16.HTRAN,
       H16.HNREL,
       H16.HRUBRO
        FROM FSH015 H15, FSH016 H16
       WHERE H16.PGCOD = H15.PGCOD
         AND H16.HCMOD = H15.HCMOD
         AND H16.HSUCOR = H15.HSUCOR
         AND H16.HTRAN = H15.HTRAN
         AND H16.HNREL = H15.HNREL
         AND H16.HFCON = H15.HFCON
         AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
         AND H16.HFVCO = H15.HFCON
         AND H15.PGCOD = 1
         AND H15.HCCORR <> 99
         AND H16.HCODMO = 1
         AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
        AND 
             ((H16.HCMOD = 116 AND H16.HTRAN IN (50)) OR
                 (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
                 (H16.HCMOD = 30 AND H16.HTRAN IN (8,360, 951,954,965)) or
                 (H16.HCMOD = (489) AND H16.HTRAN IN (360, 951,59))); --ecollado 16/01/2023*/
select HCTA,
       hoper,
       pd_fecpro,
       HFCON,
       HMDA,
       HCIMP1,
       HSUCUR,
       PGCOD,
       HCMOD,
       HSUCOR,
       HTRAN,
       HNREL,
       HRUBRO
  from (select (case
                 when (hoper = operacion_comparacion or
                      operacion_comparacion is null) then
                  'Cumple'
               
                 else
                  'No Cumple'
               end) as validacion,
               tabla_comparacion.*
        
          from (select (select min(r1oper)
                          from fsr011
                         where r2cod = 1
                           and r2mod = modulo_original
                           and r2suc = sucursal_original
                           and r2mda = moneda_original
                           and r2pap = papel_original
                           and r2cta = cuenta_original
                           and r2oper = operacion_original
                           and r2sbop = suboperacion_original
                           and r2tope = tipooperacion_original) as operacion_comparacion,
                       tabla_actual.*
                
                  from (SELECT H16.HCTA,
                               H16.hoper,
                               pd_fecpro,
                               H16.HFCON,
                               H16.HMDA,
                               H16.HCIMP1,
                               H16.HSUCUR,
                               H16.PGCOD,
                               H16.HCMOD,
                               H16.HSUCOR,
                               H16.HTRAN,
                               H16.HNREL,
                               H16.HRUBRO,
                               (select r2mod
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as modulo_original,
                               (select r2suc
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as sucursal_original,
                               (select r2mda
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as moneda_original,
                               (select r2pap
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as papel_original,
                               (select r2cta
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as cuenta_original,
                               (select r2oper
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as operacion_original,
                               (select r2sbop
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as suboperacion_original,
                               (select r2tope
                                  from fsr011 f
                                 where f.r1cod = 1
                                   and f.r1mod = h16.hcmod
                                   and f.r1suc = h16.HSUCUR
                                   and f.r1mda = h16.hmda
                                   and f.r1pap = h16.hpap
                                   and f.r1cta = h16.hcta
                                   and f.r1oper = h16.hoper
                                   and f.r1sbop = h16.hsubop
                                   and f.r1tope = h16.htoper
                                   and f.relcod = 46) as tipooperacion_original
                        
                          FROM FSH015 H15, FSH016 H16
                         WHERE H16.PGCOD = H15.PGCOD
                           AND H16.HCMOD = H15.HCMOD
                           AND H16.HSUCOR = H15.HSUCOR
                           AND H16.HTRAN = H15.HTRAN
                           AND H16.HNREL = H15.HNREL
                           AND H16.HFCON = H15.HFCON
                           AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
                           AND H16.HFVCO = H15.HFCON
                           AND H15.PGCOD = 1
                           AND H15.HCCORR <> 99
                           AND H16.HCODMO = 1
                           AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
                           and h16.HSUCOR in (select f.sucurs from fst001 f) ---2024.03.22 dcastro se agrego para optimizar                           
                           AND ((H16.HCMOD = 116 AND H16.HTRAN IN (50)) OR
                               (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
                               (H16.HCMOD = 30 AND
                               H16.HTRAN IN (8, 360, 951, 954, 965)) or
                               (H16.HCMOD = (489) AND
                               H16.HTRAN IN (360, 951, 59)))
                        
                        ) tabla_actual) tabla_comparacion)
 where validacion != 'No Cumple';

    /*efuentes 2021.11.09*/
    commit;

    --eliminar corporativos
    /*for i in creditos loop
        delete from jaqz454 j where j.jaqz454cta  = i.jaqz454cta and j.jaqz454oper = i.jaqz454oper and j.jaqz454fpro = i.jaqz454fpro;
        commit;
    end loop;*/
    ---

    for i in maestro loop
      --busca el codigo de analista a fin de mes, en caso no exista el credito se cancelo, buscar el analista con el que quedo
      /*begin
        select j.jaql965ase
          into lc_analista
          from jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = 1
           and j.jaql965mod = i.aomod
           and j.jaql965suc = i.aosuc
           and j.jaql965mda = i.aomda
           and j.jaql965pap = i.aopap
           and j.jaql965cta = i.aocta
           and j.jaql965oper = i.aooper
           and j.jaql965sbop = i.aosbop;
      exception
        when no_data_found then
          lc_analista := fn_analista_credito(i.aomod,
                                             i.aosuc,
                                             i.aomda,
                                             i.aopap,
                                             i.aocta,
                                             i.aooper,
                                             i.aosbop,
                                             i.aotope);
      end;*/
      
         /*i.aomod:=111;
         i.aosuc:=4;
         i.aomda:=0;
         i.aopap:=0;
         i.aocta:=2924335;
         i.aooper:=13937571;
         i.aosbop:=0;
         i.aotope:=10;
           */                               
      begin
        lc_analista_varchar2 := fn_cr_analista_desembolso (i.aomod,
                                             i.aosuc,
                                             i.aomda,
                                             i.aopap,
                                             i.aocta,
                                             i.aooper,
                                             i.aosbop,
                                             i.aotope,
                                             pd_fecpro
                                             );
                                             
       lc_analista := trim(lc_analista_varchar2);
      exception
       when others then
         null;
       end;

      CASE
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]02') THEN
          ln_bcgpo := 2; --LC_PROD := 'MICROEMPRESA';
      --WHEN REGEXP_LIKE(i.jaqz454rub,'^14.[1-6]03....015') THEN LC_PROD := 'CONSUMO REVOLVENTE';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]03') THEN
          ln_bcgpo := 3; --LC_PROD := 'CONSUMO NO REVOLVENTE';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]04') THEN
          ln_bcgpo := 4; --LC_PROD := 'HIPOTECARIO';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]11') THEN
          ln_bcgpo := 11; --LC_PROD := 'GRANDES EMPRESAS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]12') THEN
          ln_bcgpo := 12; --LC_PROD := 'MEDIANAS EMPRESAS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]13') THEN
          ln_bcgpo := 13; --LC_PROD := 'PEQUEÑAS EMPRESAS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]05') THEN
          ln_bcgpo := 5; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]06') THEN
          ln_bcgpo := 6; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]07') THEN
          ln_bcgpo := 7; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]08') THEN
          ln_bcgpo := 8; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]09') THEN
          ln_bcgpo := 9; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.aqpb617arubro, '^14.[1-6]10') THEN
          ln_bcgpo := 10; --LC_PROD := 'CORPORATIVOS';
      END CASE;

      case
        when ln_bcgpo = 2 then
          lc_producto := 'MI';
        when ln_bcgpo = 3 then
          lc_producto := 'CN';
        when ln_bcgpo = 4 then
          lc_producto := 'HI';
        when ln_bcgpo = 11 then
          lc_producto := 'GR';
        when ln_bcgpo = 12 then
          lc_producto := 'ME';
        when ln_bcgpo = 13 then
          lc_producto := 'PE';
        when ln_bcgpo in (5, 6, 7, 8, 9, 10) then
          lc_producto := 'CO';
        else
          lc_producto := null;
      end case;

      if lc_producto != 'CO' then

        /*efuentes 2021.11.09*/
        update AQPB617A A
           set A.AQPB617AASE  = lc_analista,
               A.AQPB617APRO  = lc_producto
         where A.AQPB617ACTA  = i.aqpb617acta
           and A.AQPB617AOPER = i.aqpb617aoper
           and A.AQPB617AFPRO = pd_fecpro;
        /*efuentes 2021.11.09*/
      end if;

      commit;
      lc_analista := null;
      /*=== INI - MAYCOL - 23/10/2023 - IGS - NEW ===*/
      PQ_CR_RECATEGORIZACION_CAPTACION.SP_CR_DATOS_CAPTACION(P_CUENTA                  => I.AQPB617ACTA, 
                                                             P_OPERACION               => I.AQPB617AOPER, 
                                                             P_MONEDA                  => I.AQPB617AMDA, 
                                                             P_SUCURSAL                => I.AQPB617ASUCU, 
                                                             P_FECHA_PROCESO           => NULL, 
                                                             P_FECHA_CONTABLE          => I.AQPB617AFCON,
                                                             O_CLIENTE_INACTIVO        => V_CLIENTE_INACTIVO,
                                                             O_ORIGEN_CAPTACION        => V_ORIGEN_CAPTACION,
                                                             O_NOMBRE_ORIGEN_CAPTACION => V_NOMBRE_ORIGEN_CAPTACION,
                                                             O_USUARIO_CAPTACION       => V_USUARIO_CAPTACION);
      BEGIN
         UPDATE AQPB617A
            SET AQPB617ACINA = V_CLIENTE_INACTIVO,
                AQPB617AOCAP = V_ORIGEN_CAPTACION,
                AQPB617ANOCP = V_NOMBRE_ORIGEN_CAPTACION,
                AQPB617AUCAP = V_USUARIO_CAPTACION
          WHERE aqpb617afpro = i.aqpb617afpro  --- 2023.11.21 se agregó condicion de fecha de proceso
            AND AQPB617ACTA  = I.AQPB617ACTA
            AND AQPB617AOPER = I.AQPB617AOPER
            AND AQPB617AMDA  = I.AQPB617AMDA
            AND AQPB617ASUCU = I.AQPB617ASUCU;
            COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      /*=== FIN - MAYCOL - 23/10/2023 - IGS - NEW ===*/
    end loop;

    --eliminando creditos de tesoreria
    /*efuentes 2021.11.09*/
    delete from aqpb617a a
     where (a.aqpb617acta, a.aqpb617aoper) in
           (select bccta, bcoper from jaqz498)
       and a.aqpb617afpro = pd_fecpro;
    /*efuentes 2021.11.09*/

    --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs
    commit;

  end sp_cr_inserta_desembolsos_recategorizacion;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_analista_desembolso(ve_modulo1 in number, --ecollado 18/01/2023
                                      ve_sucursal1 in number,
                                      ve_moneda1 in number,
                                      ve_papel1 in number,
                                      ve_cuenta1 in number,
                                      ve_operacion1 in number,
                                      ve_subope1 in number,
                                      ve_tipope1 in number,
                                      ve_fechaproceso in date) return varchar2 is

    ve_modulo   number;
    ve_sucursal number;
    ve_moneda   number;
    ve_papel   number;
    ve_cuenta  number;
    ve_operacion number;
    ve_subope   number;
    ve_tipope   number;
    ----
    ve_instancia number;
    ----
    ve_operacion2 number;
    ve_cuenta2 number;
    ve_modulo2   number;
    ve_sucursal2 number;
    ve_moneda2   number;
    ve_papel2   number;
    ve_subope2   number;
    ve_tipope2  number;
    ve_instancia2 number;

    lc_analista            char(10);
    ve_analista_desembolso varchar2(100);
    ve_analista_sng130 varchar(100);

  begin

    lc_analista:= '';
    ve_analista_sng130:= '';
    ve_analista_desembolso:= '';

    ve_modulo := 0;
    ve_sucursal:= 0;
    ve_moneda := 0;
    ve_papel  := 0;
    ve_subope := 0;
    ve_tipope := 0;
    ve_instancia := 0;

    ve_modulo := ve_modulo1;
    ve_sucursal := ve_sucursal1;
    ve_moneda:= ve_moneda1;
    ve_papel := ve_papel1;
    ve_cuenta := ve_cuenta1;
    ve_operacion := ve_operacion1;
    ve_subope := ve_subope1;
    ve_tipope := ve_tipope1;

    ve_operacion2 := 0;
    ve_cuenta2 := 0;
    ve_modulo2  := 0;
    ve_sucursal2 := 0;
    ve_moneda2 := 0;
    ve_papel2  := 0;
    ve_subope2 := 0;
    ve_tipope2  := 0;
    ve_instancia2 := 0;

     begin
             select jaql965inst into ve_instancia
             from jaql965
              where jaql965fech = ve_fechaproceso and jaql965emp = 1
              and jaql965mod = ve_modulo and jaql965suc = ve_sucursal and jaql965mda = ve_moneda
              and jaql965pap = ve_papel and jaql965cta = ve_cuenta and jaql965oper = ve_operacion
              and jaql965sbop = ve_subope and jaql965top = ve_tipope;

          exception
             when others then
               begin
                  select xw.xwfprcins into ve_instancia from xwf700 xw where xw.xwfempresa = 1 and xw.xwfcar3 = '1'
                     and xw.xwfmodulo = ve_modulo and xw.xwfsucursal = ve_sucursal
                     and xw.xwfmoneda = ve_moneda and xw.xwfpapel = ve_papel and xw.xwfcuenta = ve_cuenta
                     and xw.xwfoperacion = ve_operacion
                     and xw.xwfsubope = ve_subope and xw.xwftipope = ve_tipope
                     and rownum = 1 order by xwfprcins asc ;

                 exception
                   when others then
                       begin
                        select f.r2mod, f.r2suc, f.r2mda, f.r2pap, f.r2cta, f.r2oper, f.r2sbop, f.r2tope
                         into ve_modulo,ve_sucursal, ve_moneda, ve_papel, ve_cuenta2, ve_operacion2, ve_subope, ve_tipope
                          from fsr011 f where f.r1cod = 1 and f.r1mod = ve_modulo and f.r1suc = ve_sucursal
                           and f.r1mda = ve_moneda
                           and f.r1pap = ve_papel and f.r1cta = ve_cuenta and f.r1oper = ve_operacion
                           and f.r1sbop = ve_subope
                           and f.r1tope = ve_tipope and f.relcod = 46;

                              select j.jaql965inst into ve_instancia from jaql965 j
                                where jaql965fech = ve_fechaproceso and jaql965emp = 1
                                and jaql965mod = ve_modulo and jaql965suc = ve_sucursal and jaql965mda = ve_moneda
                                and jaql965pap = ve_papel
                                and jaql965cta = ve_cuenta2 and jaql965oper = ve_operacion2
                                and jaql965sbop = ve_subope and jaql965top = ve_tipope;

                             exception
                               when others then
                                 begin
                                   select xwf.xwfprcins into ve_instancia
                                    from xwf700 xwf where xwf.xwfempresa = 1 and xwf.xwfmodulo = ve_modulo
                                    and xwf.xwfsucursal = ve_sucursal and xwf.xwfmoneda = ve_moneda
                                    and xwf.xwfpapel = ve_papel
                                    and xwf.xwfcuenta = ve_cuenta2 and xwf.xwfoperacion = ve_operacion2
                                    and xwf.xwfsubope = ve_subope and xwf.xwftipope = ve_tipope
                                     and rownum = 1 order by xwfprcins asc;
                                   exception
                                     when others then
                                       null;
                                   end;
                              end;
                   end;
        end;

      if ve_instancia != 0 then
         begin
           select trim(s.sng130asor)
            into ve_analista_sng130 --, s.*, t.*
            from sng130 s, sng131 t
           where t.sng130cor = s.sng130cor
             and SNG131CERR = 0
             and SNG131PGC = 1
             and SNG131MOD = ve_modulo
             and SNG131MDA = ve_moneda
             and SNG131PAP = ve_papel
             and SNG131CTA = ve_cuenta
             and SNG131OPE = ve_operacion
             and s.SNG130cor =
                 (select min(s.SNG130cor)
                    from sng130 s, sng131 t
                   where t.sng130cor = s.sng130cor
                     and SNG131CERR = 0
                     and SNG131PGC = 1
                     and SNG131MOD = ve_modulo
                     and SNG131MDA = ve_moneda
                     and SNG131PAP = ve_papel
                     and SNG131CTA = ve_cuenta
                     and SNG131OPE = ve_operacion);
           exception
             when others then
                null;
             end;
         end if;

      begin

        SELECT
          u.wfitemusrcod into ve_analista_desembolso
           FROM
                 wfwrkitems u
           where
                 u.wftaskcod = 7
             and u.wfitemid = (select max(s.wfitemid) from wfwrkitems s where s.wfinsprcid=u.wfinsprcid
             and s.wftaskcod = 7)
             and u.wfinsprcid=ve_instancia;


       exception
         when others then
           null;
       end;

        if trim(ve_analista_desembolso) is null and  trim(ve_analista_sng130) is not null then
          ve_analista_desembolso:=ve_analista_sng130;
       end if;


    return ve_analista_desembolso;
  end fn_cr_analista_desembolso;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_cr_cli_Castigado(pc_analista IN varchar2,
                               pd_fecpro   in date,
                               pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_cli_Castigado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el NUMERO DE CLIENTES Castigado para el calculo % de mora del ULTIMO MES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saljud   number := 0;
    ld_fecini   date;
    ln_dias     number := 31; --20161028 ----ultimo año 365;
    ln_clicas   number := 0;
    lc_analista char(10);
  begin
  
    lc_analista := rpad(pc_analista, 10, ' ');
    ld_fecini   := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    begin
    
      select /*+parallel (c,2) (j,2)*/
       count(distinct c.jaql965ndoc)
        into ln_clicas
        from jaql965 c, JAQL166 /*_20140731*/ J --QUITAR COMENTARIO jaql166 j
       where c.jaql965fech = pd_fecpro
         and c.jaql965ase = lc_analista --pc_analista
         and c.jaql965mod = 33
         and c.jaql965mod = j.jaql166scmod
         and c.jaql965cta = j.jaql166sccta
         and c.jaql965oper = j.jaql166scope
         and c.jaql965suc = j.jaql166scsuc
         and c.jaql965mda = j.jaql166scmda
         and c.jaql965pap = j.jaql166scpap
         and c.jaql965sbop = j.jaql166scsbo
         and j.JAQL166NRPAG = 0
         and j.jaql166est = 90
         AND C.jaql965suc = pn_codage
         and (c.jaql965cta, c.jaql965oper, c.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j)
         and (c.jaql965cta, c.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs        
         and jaql166scfvl >= ld_fecini
         and jaql166scfvl <= pd_fecpro; --pd_fecpro - ln_dias;
    
    exception
      when no_data_found then
        ln_clicas := 0;
    end;
  
    return nvl(ln_clicas, 0);
  
  end fn_cr_cli_Castigado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_SaldosTraslados(pc_analista IN varchar2,
                                  pd_fecpro   in date,
                                  pd_feccal   in date,
                                  pn_saltot   out number,
                                  pn_salmor   out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_SaldosTraslados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna SaldoTotal y SaldoMora de creditos trasladados a cierre de mes anterior.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : pn_saltot, pn_salmor
    -- Fecha de Modificación      : 2017.06.05
    -- Autor de la Modificación   : Dcastro
    -- Descripción de Modificación: Para saldos otorgados se debe restar los saldos al porcentaje de mora (*-1)
    -- *****************************************************************
    ln_saljud   number := 0;
    ld_fecini   date;
    ld_fecact   date;
    ln_clicas   number := 0;
    lc_analista varchar2(10);
    ln_nummes   number := 0;
  
  begin
  
    lc_analista := rpad(pc_analista, 10, ' ');
  
    ld_fecact := last_day(add_months(trunc(pd_fecpro), 1));
    ld_fecini := to_date(to_char(ld_fecact, 'yyyymm') || '01', 'yyyymmdd');
  
    ---obtener meses de antiguedad en agencia
    if  pd_feccal = ld_fecact then 
        begin
          select j.jaql600mant
            into ln_nummes
            from jaql600 j
           where jaql600fpro = ld_fecact
             and jaql600usu = pc_analista; --lc_analista; --
        exception
          when no_Data_found then
            ln_nummes := 0;
        end;
    else --si no es fin de mes considerar fecha de proceso de productividad pd_feccal
         begin
          select j.jaql600mant
            into ln_nummes
            from jaql600 j
           where jaql600fpro = pd_feccal
             and jaql600usu = pc_analista; --lc_analista; --
        exception
          when no_Data_found then
            ln_nummes := 0;
        end;          
    end if;    
    --
    --si es = 1 entonces no considerar OTORGADO
    if ln_nummes <> 1 then
    
      begin
      
        select sum(jaql965sdmn) total,
               sum(case
                     when jaql965datr  > 8 --15 2023.03.20 se actualizo dias atraso 
                       then
                      jaql965sdmn
                     else
                      0
                   end)
          into pn_saltot, pn_salmor
          from (select distinct jaql965cta,
                                jaql965oper,
                                jaql965datr,
                                jaql965sdmn
                  from ---recibido       
                        (select /* +all_rows */--jaql965sdmn, jaql965datr 
                          b.jaql965cta,
                          b.jaql965oper,
                          b.jaql965datr,
                          b.jaql965sdmn
                           from JAQZ455 a, jaql965 b
                          where b.jaql965fech = pd_fecpro
                            and b.jaql965emp = a.JAQZ455emp
                            and b.jaql965mod = a.JAQZ455mod
                            and b.jaql965suc = a.JAQZ455suc
                            and b.jaql965mda = a.JAQZ455mda
                            and b.jaql965pap = a.JAQZ455pap
                            and b.jaql965cta = a.JAQZ455cta
                            and b.jaql965oper = a.JAQZ455oper
                            and b.jaql965sbop = a.JAQZ455sbop
                            and JAQZ455FECH between ld_fecini and ld_fecact
                            and a.JAQZ455ASED = lc_analista --pc_analista
                         union
                         ---otorgado
                         select /* +all_rows */--jaql965sdmn, jaql965datr 
                          b.jaql965cta,
                          b.jaql965oper,
                          b.jaql965datr,
                          b.jaql965sdmn * -1 --2017.06.05
                           from JAQZ455 a, jaql965 b
                          where b.jaql965fech = pd_fecpro
                            and b.jaql965emp = a.JAQZ455emp
                            and b.jaql965mod = a.JAQZ455mod
                            and b.jaql965suc = a.JAQZ455suc
                            and b.jaql965mda = a.JAQZ455mda
                            and b.jaql965pap = a.JAQZ455pap
                            and b.jaql965cta = a.JAQZ455cta
                            and b.jaql965oper = a.JAQZ455oper
                            and b.jaql965sbop = a.JAQZ455sbop
                            and JAQZ455FECH between ld_fecini and ld_fecact
                            and a.JAQZ455ASEO = lc_analista --pc_analista
                         ) f);
      
      exception
        when no_data_found then
          pn_saltot := 0;
          pn_salmor := 0;
      end;
    
    else
      --no considerar OTORGADO
    
      begin
      
        select sum(jaql965sdmn) total,
               sum(case
                     when jaql965datr  > 8--15  2023.03.20 se actualizo dias atraso
                        then
                      jaql965sdmn
                     else
                      0
                   end)
          into pn_saltot, pn_salmor
          from (select distinct jaql965cta,
                                jaql965oper,
                                jaql965datr,
                                jaql965sdmn
                  from ---recibido       
                        (select /* +all_rows */--jaql965sdmn, jaql965datr 
                          b.jaql965cta,
                          b.jaql965oper,
                          b.jaql965datr,
                          b.jaql965sdmn
                           from JAQZ455 a, jaql965 b
                          where b.jaql965fech = pd_fecpro
                            and b.jaql965emp = a.JAQZ455emp
                            and b.jaql965mod = a.JAQZ455mod
                            and b.jaql965suc = a.JAQZ455suc
                            and b.jaql965mda = a.JAQZ455mda
                            and b.jaql965pap = a.JAQZ455pap
                            and b.jaql965cta = a.JAQZ455cta
                            and b.jaql965oper = a.JAQZ455oper
                            and b.jaql965sbop = a.JAQZ455sbop
                            and JAQZ455FECH between ld_fecini and ld_fecact
                            and a.JAQZ455ASED = lc_analista --pc_analista
                         ) f);
      
      exception
        when no_data_found then
          pn_saltot := 0;
          pn_salmor := 0;
      end;
    
    end if;
   
    if pn_saltot < 0 then -- 2025.05.07 dcasro si saldo traslado o saldo mora es negativo el valor se considera como o.
       pn_saltot := 0;
    end if;   
    if pn_salmor < 0 then
          pn_salmor := 0;       
    end if;   
  
    pn_saltot := nvl(pn_saltot, 0);
    pn_salmor := nvl(pn_salmor, 0);
  
  end sp_cr_SaldosTraslados;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cartera_Vendida(pc_analista IN varchar2,
                                  pn_sucurs   in number,
                                  pd_fecpro   in date,
                                  pn_salven   out number,
                                  pn_cliven   out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Cartera_Vendida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna saldo y clientes venido
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : pn_saldo , pn_cantidad
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ld_fecini   date;
    lc_analista varchar2(10);
    ln_cantidad number := 0;
    ln_saldo    number := 0;
  
  begin
  
    lc_analista := rpad(pc_analista, 10, ' ');
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
  
    begin
    
      select count(distinct jaqz064ndo) cantidad, sum(SALDO) saldo
        into ln_cantidad, ln_saldo
        from (select distinct jaqz064pgc,
                              jaqz064mod,
                              jaqz064suc,
                              jaqz064mda,
                              jaqz064pap,
                              jaqz064cta,
                              jaqz064ope,
                              jaqz064sbo,
                              jaqz064top,
                              /*jaqz064cap,*/
                              DECODE(jaqz064mda,
                                     101,
                                     ROUND((select cotcbi
                                              from fsh005 f
                                             where cofdes in
                                                   (select max(cofdes)
                                                      from fsh005 g
                                                     where g.cofdes <=
                                                           pd_fecpro /*TO_DATE('2016.12.31','YYYY.MM.DD')*/ --
                                                       and moneda = 101)
                                               and moneda = 101) * jaqz064cap,
                                           2),
                                     jaqz064cap) SALDO,
                              jaqz064tdo,
                              jaqz064ndo,
                              fn_analista_credito(jaqz064mod,
                                                  jaqz064suc,
                                                  jaqz064mda,
                                                  jaqz064pap,
                                                  jaqz064cta,
                                                  jaqz064ope,
                                                  jaqz064sbo,
                                                  jaqz064top) analista
                from jaqz064 j, jaqy952 k
               where j.jaqz064GRU = k.jaqy952gru
                 and k.jaqy952fec >= ld_fecini
                 and k.jaqy952fec <= pd_fecpro
                 and j.jaqz064suc = pn_sucurs
                 and j.jaqz064mod <> 33) a
       where analista = lc_analista
       group by analista;
    exception
      when no_data_found then
        ln_cantidad := 0;
        ln_saldo    := 0;
    end;
  
    pn_salven := nvl(ln_saldo, 0);
    pn_cliven := nvl(ln_cantidad, 0);
  
  end sp_cr_Cartera_Vendida;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Calculo_Senior(pd_fecpro   in date,
                                 pc_analista IN varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Calculo_Senior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Calcula Pago Senior por cumplimiento Comite
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : pn_saldo , pn_cantidad
    -- Fecha de Modificación      : 2023.08.22 
    -- Autor de la Modificación   : dcastro
    -- Descripción de Modificación: modificacion a nueva productividad
    -- *****************************************************************
  
  
    cursor senior(lcc_senior in varchar2) is
      select s.jaqy830codana, 201, '', s.jaqy830codana senior
        from jaqy830 s
       where s.jaqy830codcat in (7, 8, 9)
         and s.jaqy830est = 'S'
         and s.jaqy830codana like '%' || lcc_senior || '%';
  
    cursor comite(lc_anasenior in char) is
      select *
        from (select sng057usr Analista,
                     sng055car Cargo,
                     sng057sup Sup,
                     sng057jef Senior
                from sng057_201X s
               where sng057fpro = pd_fecpro --20171005
                 and s.sng055car = 200
                 and s.sng057jef in
                     (select s.jaqy830codana
                        from jaqy830 s
                       where s.jaqy830codcat in (7, 8, 9)
                         and s.jaqy830est = 'S')
              union all
              select s.jaqy830codana Analista,
                     201 Cargo,
                     '' Sup,
                     s.jaqy830codana Senior
                from jaqy830 s
               where s.jaqy830codcat in (7, 8, 9)
                 and s.jaqy830est = 'S') a
       where a.Senior = lc_anasenior;
  
    lc_senior       varchar2(10);
    ln_mtosal       number := 0;
    ln_mtocli       number := 0;
    ln_minsal       number := 0;
    ln_mincli       number := 0;
    ln_porcar       number := 0;
    ln_porcli       number := 0;
    ln_prominsal    number := 0;
    ln_promincli    number := 0;
    ln_prom_sal     number := 0;
    ln_prom_cli     number := 0;
    ln_promedio_sal number := 0;
    ln_promedio_cli number := 0;
    lc_analista     varchar2(20);
    lc_anali        char(20);
    ln_agesenior    number(3);
    ln_ageana       number(3);
    ln_basecon      number := 0;
    ln_mtoconte     number := 0;
    
    ln_promedio_con number := 0;
    ln_prom_mto     number := 0; 
    ln_prom_bas     number := 0;
    ln_porvar       number := 0;
    
  
  begin
  
    if pc_analista is null then
      lc_senior := '%';
    else
      lc_senior := pc_analista;
    end if;
  
    delete from JAQL600S
     where jaql600Sfpro = pd_fecpro
       and jaql600susu like '%' || lc_senior || '%';
  
    for y in senior(lc_senior) loop
      -- dbms_output.put_line(' senior '||y.sng057jef);
      BEGIN
        select j.jaql600age
          into ln_agesenior
          from jaql600 j
         where j.jaql600fpro = pd_fecpro
           and j.jaql600usu = y.Senior;
      exception
        when others then
          ln_agesenior := null;
      END;
    
      for i in comite(y.Senior) loop
      
        lc_anali := rpad(i.Analista, 20, ' ');

      
        begin
          select j.jaql600crsa,
                 j.jaql600crcl,
                 j.jaql600mtsa,
                 j.jaql600mtcl,
                 j.jaql600age,
                 nvl(j.JAQL600BACO1,0), --base contencion 0-30
                 nvl(j.jaql600mtco1,0)  --monto contenido 0-30
            into ln_mtosal, ln_mtocli, ln_minsal, ln_mincli, ln_ageana, ln_basecon, ln_mtoconte
            from jaql600 j
           where j.jaql600fpro = pd_fecpro --fechaproceso
             and j.jaql600usu = lc_anali; --i.Analista;
        exception
          when no_data_found then
            ln_mtosal := 0;
            ln_mtocli := 0;
            ln_minsal := 0;
            ln_mincli := 0;
            ln_ageana := 0;
            ln_basecon := 0;
            ln_mtoconte := 0;
        end;
      
        IF ln_agesenior = ln_ageana then

          -- SI PERTENECEN A LA MISMA AGENCIA
        
          ln_prom_sal  := ln_prom_sal + ln_mtosal;
          ln_prominsal := ln_prominsal + ln_minsal;
          ln_prom_cli  := ln_prom_cli + ln_mtocli;
          ln_promincli := ln_promincli + ln_mincli;
          
          ln_prom_bas  := ln_prom_bas + ln_basecon;
          ln_prom_mto  := ln_prom_mto + ln_mtoconte;
        
          --dbms_output.put_line(' lc_analista ' ||i.sng057usr|| ' mtosal '||ln_mtosal||' mtocli '||ln_mtocli||' minsal ' ||ln_minsal||' mincli '|| ln_mincli);
        
          --actualiza tabla de analistas con el usuario del jefe de comite
          begin
            update JAQL600
               set JAQL600COMI = y.Senior
             where jaql600fpro = pd_fecpro
               and jaql600usu = lc_anali; --i.Analista;
          exception
            when others then
              null;
          end;
        
        End if;
      
      end loop;
      --dbms_output.put_line('1--'||lc_analista||' saldo '||ln_prom_sal|| ' clientes '||ln_prom_cli||' minsal '||ln_prominsal||' mincli '||ln_promincli);
    
      lc_analista := y.Senior;
    
      if ln_prominsal <> 0 then
        ln_promedio_sal := round(ln_prom_sal / ln_prominsal, 2) * 100;
      else
        ln_promedio_sal := 0;
      end if;
      if ln_promincli <> 0 then
        ln_promedio_cli := round(ln_prom_cli / ln_promincli, 2) * 100;
      else
        ln_promedio_cli := 0;
      end if;
 
      if ln_prom_bas <> 0 then
        ln_promedio_con := round(ln_prom_mto / ln_prom_bas, 2) * 100;
      else
        ln_promedio_con := 100; --- si no tiene base contencion se aplcia factor 100  2023.09.20
      end if;

   
      begin
        select f.tp1imp1
          into ln_porcar
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 19
           and ln_promedio_sal >= f.tp1nro1
           and ln_promedio_sal <= f.tp1nro2;
      exception
        when others then
          ln_porcar := 0;
      end;
    
      begin
        select f.tp1imp2
          into ln_porcli
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 19
           and ln_promedio_cli >= f.tp1nro1
           and ln_promedio_cli <= f.tp1nro2;
      exception
        when others then
          ln_porcli := 0;
      end;
    
      begin
         select f.tp1imp1
          into ln_porvar
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 31
           and ln_promedio_con >= TP1NRO1 
           and ln_promedio_con < TP1NRO2 ;
        exception when others then
          ln_porvar := 0;
      end;
    
      --dbms_output.put_line(lc_analista||' saldo '||ln_prom_sal|| ' clientes '||ln_prom_cli|| ' %SAL '||ln_porcar||' %CLI'||ln_porcli);
    
      insert into JAQL600S
        (JAQL600SFPRO,
         JAQL600SUSU,
         JAQL600STSA,
         JAQL600STCL,
         JAQL600STMI,
         JAQL600STMF,
         JAQL600SMSA,
         JAQL600SMCL,
         JAQL600SVMO,
         JAQL600SMMO,
         JAQL600SPSA,
         JAQL600SPCL,
         JAQL600SPOSA,
         JAQL600SPOCL,
         JAQL600SEST,
         ---agregar campos contencion
         jaql600sbaco,-- ln_prom_bas,  --datos contencion senior
         jaql600sproc,-- ln_promedio_con,
         jaql600smtco,-- ln_prom_mto
         jaql600spvar-- procentaje de contencion
         )
      values
        (pd_fecpro,
         y.Senior,
         ln_prom_sal,
         ln_prom_cli,
         0,
         0,
         ln_prominsal,
         ln_promincli,
         0,
         0,
         ln_promedio_sal,
         ln_promedio_cli,
         ln_porcar,
         ln_porcli,
         'S',
         ln_prom_bas,  --datos contencion senior
         ln_promedio_con,
         ln_prom_mto,
         ln_porvar --porcentaje contencion
         
         );
    
      commit;
    
      ln_mtosal := 0;
      ln_mtocli := 0;
      ln_minsal := 0;
      ln_mincli := 0;
    
      ln_prom_sal  := 0;
      ln_prominsal := 0;
      ln_prom_cli  := 0;
      ln_promincli := 0;
    
      ln_promedio_cli := 0;
      ln_promedio_sal := 0;

       ln_prom_bas := 0;
       ln_promedio_con  := 0;
       ln_prom_mto   := 0;    
    
    end loop;
  
  end sp_cr_Calculo_Senior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_Calculo_Senior(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
    
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);     
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50);     
    
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
 
    lc_user       := substr('BANTPROD', 1, 5);
    lc_paquete    := 'pq_cr_productividad_nueva';
    lc_proceso    := 'sp_cr_job_cartera_mes';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  
 
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
    
     
    --2025.01.15 determina numero de jobs
    begin
       select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10 
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
     exception when others then
       lb_njobs := 50;
     end;    
   
    delete from JAQL600S where jaql600Sfpro = pd_fecpro;
    commit;
  
    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_Calculo_senior( TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                     ' );' || ' End;';
      ln_job      := ln_job + 1;
    
      --          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRD', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
 
 
     --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs  
    
     
  end sp_cr_job_Calculo_Senior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_val_continuidad(pd_fecpro   in date,
                                  pc_analista in varchar2,
                                  pc_codage   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cumplimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
      select *
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%'; -- and j.jaql600age = pc_codage;
    --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
  
    ln_incmor number;
    ln_pjcas  number;
  
    ln_totalpagovariable number;
    ln_TOTAL             number;
    ln_cascontinuidad    number;
    ln_INDMORA           number;
    lc_analista          varchar2(10) := null;
    ld_fechacon          date;
  
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista := pc_analista;
    end if;
  
    for i in analistas(lc_analista) loop
    
      lc_tipoase := i.jaql600tase;
      --     ln_mincom := i.
    
      if lc_tipoase = 'P' then
      
        ln_INDMORA := 1;
      else
      
        ln_INDMORA := 0.5;
      end if;
    
      --Aplicar CONTINUIDAD de mora a partir de diciembre
      begin
        select to_Date(tp1desc, 'YYYYMMDD')
          into ld_fechacon
          from fst198 f
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 16
           and tp1corr2 = 1;
      exception when others then
           null;     
      end;
    
      --FIN GUIAS PROCESO 
    
      ln_totalpagovariable := i.JAQL600PVAR;
    
      ln_cascontinuidad := 0;
    
      if pd_fecpro >= ld_fechacon then
      
        --valida continuidad se multiplica por negativo 
        -- ln_incmor  := (-1)* PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora(i.jaql600usu,pd_fecpro);
        ln_incmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora(i.jaql600usu,
                                                                     pd_fecpro);
      
        if ln_incmor > ln_INDMORA then
          -- si incrementa supera 1% en los 3 meses no se paga por incentivo variable (Cartera, Clientes y Retencion)
          ln_pjcas             := -100;
          ln_cascontinuidad    := (ln_totalpagovariable * ln_pjcas / 100);
          ln_totalpagovariable := ln_totalpagovariable + ln_cascontinuidad;
        else
          ln_pjcas          := 0;
          ln_cascontinuidad := 0;
        end if;
      else
        ln_incmor         := 0;
        ln_pjcas          := 0;
        ln_cascontinuidad := 0;
      end if;
      --
    
      update JAQL600 j
         set jaql600aux1  = i.JAQL600PJCA,
             jaql600aux2  = i.JAQL600PJCAS,
             jaql600aux3  = i.JAQL600PVAR,
             JAQL600PJCA  = ln_incmor,
             JAQL600PJCAS = ln_pjcas,
             JAQL600PVAR  = ln_totalpagovariable,
             JAQL600CMRA  = ln_cascontinuidad
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu = i.jaql600usu;
    
      --inicializa variables  
    
      ln_incmor            := 0;
      ln_pjcas             := 0;
      ln_totalpagovariable := 0;
      ln_cascontinuidad    := 0;
    
    end loop;
  
    commit;
  
  end sp_cr_val_continuidad;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_pa_mora_comite(pc_comite IN varchar2, pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    cursor comite(lc_comite in varchar2) is
      select *
        from jaql600s
       where jaql600sfpro = pd_fecpro
         and jaql600susu like '%' || lc_comite || '%';
  
    cursor analistas(lc_comite in varchar2) is
      select *
        from jaql600
       where jaql600fpro = pd_fecpro
         and jaql600comi like '%' || lc_comite || '%';
  
    ln_pormorI number; --mora inicial - Mes anterior
    ln_pormorF number; --mora final - Mora cierre de mes Fecha Proceso  
  
    ln_saldoI  number := 0;
    ln_saldoF  number := 0;
    ln_salcas  number := 0;
    ln_saljud  number := 0;
    ln_salven  number := 0;
    ln_salmor  number := 0;
    ln_saltoT  number := 0;
    ln_salmorT number := 0;
    ln_salmorI number := 0;
    ln_salmorF number := 0;
    ln_varmor  number := 0;
    ln_mora    number := 0;
    ln_incmor  number := 0;
  
    ln_salmorTotI number := 0;
    ln_saldoTotI  number := 0;
  
    ln_cliant number;
    ln_codage number;
    ln_ageact number;
    ln_monto  number := 0;
    ld_fecIni date;
    ld_fecAct date;
  
    lc_comite varchar2(20) := null;

    ln_pagmora number := 0;
      
  begin
  
    if pc_comite is null then
      lc_comite := '%';
    else
      lc_comite := pc_comite;
    end if;
  
    for i in comite(lc_comite) loop
    
      --1--Calculando MORA FINAL
      begin
        select Sum(j.jaql600sdca),
               sum(j.jaql600cave),
               sum(j.jaql600sdo),
               sum(j.jaql600sdm),
               sum(j.jaql600sdju)
          into ln_salcas, ln_salven, ln_saldoF, ln_salmor, ln_saljud
          from jaql600 j
         where j.jaql600fpro = pd_fecpro
           and j.jaql600comi = i.jaql600susu;
      exception
        when no_Data_found then
          ln_salcas := 0;
          ln_salven := 0;
          ln_saldoF := 0;
          ln_salmor := 0;
          ln_saljud := 0;
      end;
    
      ln_salmorF := ln_salmor + ln_saljud + ln_salcas + ln_salven; --saldo mora final
    
      if (ln_saldoF + ln_salcas + ln_saljud + ln_salven + ln_salmor) > 0 then
        ln_pormorF := round((ln_salmor + ln_saljud + ln_salcas + ln_salven) /
                            (ln_saldoF) * 100,
                            2);
        --DENOMINADOR :no suma ln_saljud porque en pn_saldo ya esta incluido el saldo judicial
        --no suma ln_salcas porque en pn_saldo ya esta incluido saldo castigado
      else
        ln_pormorF := 0;
      end if;
    
      --2--Calculando MORA INICIAL (MORA MES ANTERIOR)
      ld_fecIni := add_months(last_day(pd_fecpro), -1);
    
      Begin
        select jaql600age
          into ln_codage
          from jaql600
         where jaql600usu = i.jaql600susu --pc_analista
           and jaql600fpro = pd_fecpro;
      exception
        when others then
          ln_codage := 0;
      end;
    
      for x in analistas(lc_comite) loop
      
      
        --Obtener saldo de traslado al cierre de mes anterior ln_saltot, ln_salmorT
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_saldostraslados(x.jaql600usu,
                                                         ld_fecIni,
                                                         pd_fecpro, 
                                                         ln_saltoT,
                                                         ln_salmorT);
        end;
      
        --ld_fecact := add_months( pd_fecpro, 1);
      
        ln_ageact := x.jaql600age;
        ---   
        if ln_ageact = ln_codage then
        
          ln_saljud := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_judicial(x.jaql600usu,
                                                                   ld_fecIni,
                                                                   ln_codage);
          --no considerar castigos del mes
          ln_salmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_mora(x.jaql600usu,
                                                                 ld_fecIni,
                                                                 ln_codage);
        
          begin
          
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => x.jaql600usu,
                                                               pd_fecpro   => ld_fecIni,
                                                               pc_codage   => ln_codage,
                                                               pn_salant   => ln_saldoI,
                                                               pn_cliant   => ln_cliant);
          end;
        else
          ln_saldoI := 0;
          ln_cliant := 0;
          ln_saljud := 0;
          ln_salmor := 0;
        end if;
      
        ---calcular mora 
        ln_salmorI := ln_salmor + ln_saljud + ln_salmorT; --saldo mora inicial              
      
        --sumatoria de saldos   
        ln_salmorTotI := ln_salmorTotI + ln_salmorI;
        ln_saldoTotI  := ln_saldoTotI + (ln_saldoI + ln_saltoT);
      
      end loop;
    
      --obtiene TOTAL de MORA INICIAL    
      --if (ln_saldoI + ln_saljud + ln_salmorT + ln_saltoT) > 0 then
      --       ln_pormorI := round( (ln_salmor  + ln_saljud  + ln_salmorT) / (ln_saldoI  + ln_saltoT ) * 100,2);
      --no suma ln_saljud porque en ln_saldo ya esta incluido el saldo judicial
      if ln_saldoTotI > 0 then
        ln_pormorI := round((ln_salmorTotI / ln_saldoTotI) * 100, 2);
      else
        ln_pormorI := 0;
      end if;
      -----          
    
      ---Variacion MORA
      if nvl(ln_pormorI, 0) = 0 then
        --si no tiene mora el mes anterior variacion es la mora actual
        ln_varmor := nvl(ln_pormorI, 0);
      else
        --Determinar variacion de mora
        --No hace diferencia entre consumo/pymes
      
        if ln_pormorI /*pn_pormor*/
           > 5 then
          --Se evalua en base a la mora Inicial o del mes anterior
          ln_varmor := round(((nvl(ln_pormorF, 0) / nvl(ln_pormorI, 0)) - 1) * 100,
                             2);
        else
          ln_varmor := nvl(ln_pormorF, 0) - nvl(ln_pormorI, 0);
        end if;
      
      end if;
    
      --Obtener monto MORA
      ---
      begin
        ln_mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_metamora(pc_tipase => 'P', --lc_tipoase,
                                                           pn_pormor => ln_pormorI,
                                                           pn_varmor => ln_varmor);
        --se envia la mora del mes anterior
      end;
  
  ----2023
  
      begin
        pq_cr_productividad_nueva.sp_cr_metamora_new(pc_tipase => 'P', --lc_tipoase,
                                                     pn_varmor =>  ln_varmor,       
                                                     pn_pormor => ln_pormorI,
                                                     pn_facmor => ln_mora,
                                                     pn_mtomor => ln_pagmora);
      end;

  
  ----2023 fin
  
    
    
      update JAQL600S j
         set j.jaql600stmi = ln_salmorTotI, --total mora inicial comite
             j.jaql600stmf = ln_salmorF, --total mora final comite
             j.jaql600svmo = ln_varmor, --variacion mora comite
             j.jaql600smmo = ln_mora, --monto mora comite
             j.jaql600sdoi = ln_saldoTotI, --  saldo total inicial comite
             j.jaql600sdof = ln_saldoF, -- saldo total final comite
             j.jaql600spmi = ln_pormorI, --porcentaje mora inicial
             j.jaql600spmf = ln_pormorF,  --porcentaje mora final
             j.jaql600spamo = ln_pagmora --PAGO MORA --2023
       where j.jaql600sfpro = pd_fecpro
         and j.jaql600susu = i.jaql600susu;
    
      ln_salmorI := 0;
      ln_salmorF := 0;
      ln_varmor  := 0;
      ln_mora    := 0;
      ln_saldoF  := 0;
      ln_pormorI := 0;
      ln_pormorF := 0;
    
      ln_salmorTotI := 0;
      ln_saldoTotI  := 0;
    
      commit;
    end loop;
  
  end sp_pa_mora_comite;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_continuidad_mora_comite(pc_comite IN varchar2,
                                         pd_fecpro in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_continuidad_mora_comite
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Evalua 3 meses consecutivos la mora y si el ratio se ha incrementado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_comite: analista senior - representa comite
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    lc_analista char(10);
    ln_varmor   number := 0;
    ln_morini   number := 0;
    ln_mora     number := 0;
    ln_moraFin  number := 0;
    ln_moraIni  number := 0;
    ld_fecfin   date;
  
  begin
  
    --obtener mora de los 3 ultimos meses
    lc_analista := rpad(pc_comite, 10, ' '); --2016.02.08 obtiene codigo de analista
  
    for x in 0 .. 2 loop
      ln_morini := ln_mora;
      --ld_fecfin :=  last_day(add_months(trunc(pd_fecpro), -x));
    
      if x = 0 then
        ld_fecfin := pd_fecpro;
      else
        ld_fecfin := last_day(add_months(trunc(pd_fecpro), -x));
      end if;
    
      begin
        select j.JAQL600SPMI, j.jaql600SPMF
          into ln_moraIni, ln_moraFin
          from jaql600s j
         where j.jaql600sfpro = ld_fecfin
           and j.jaql600susu = lc_analista;
      exception
        when no_Data_found then
          ln_moraFin := 0;
          ln_moraIni := 0;
          ln_varmor  := 0;
          exit; --sino cumple 3 meses seguidosno hay continuidad        
      end;
    
      ln_mora   := ln_moraFin - ln_moraIni;
      ln_varmor := ln_varmor + ln_mora;
    
    end loop;
  
    return nvl(ln_varmor, 0);
  
  end fn_cr_continuidad_mora_comite;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_cumplimiento_senior(pd_fecpro in date,
                                      pc_codage in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cumplimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analista is
      select distinct j.jaql600comi
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600age = pc_codage
         and j.jaql600comi is not null;
  
    cursor comite(lc_comite char) is
      select *
        from jaql600s
       where jaql600sfpro = pd_fecpro
         and jaql600susu like '%' || lc_comite || '%';
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_totalpagovariable number;
  
    lc_analista varchar2(10) := null;
    ld_fechacon date;
  
    ln_INDMORA number;
    ln_facmor  number;
    ln_pormoa  number;
  
    ln_cascontinuidad number;
  
    lc_comite varchar2(20) := null;
  
  begin
  
    begin
      select to_Date(tp1desc, 'YYYYMMDD')
        into ld_fechacon
        from fst198 f
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 16
         and tp1corr2 = 2;
    exception when others then
           null;     
    end;
  
    for i in analista loop
    
      for x in comite(i.jaql600comi) loop
      
        begin
        
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_pa_mora_comite(pc_comite => x.jaql600susu,
                                                     pd_fecpro => pd_fecpro);
        end;
      
        ln_INDMORA := 1;
      
      
      --inicializa variables  
      
      end loop;
      commit;
    
    end loop;
  
  end sp_cr_cumplimiento_senior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_Cumplimiento_Senior(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
    
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);     
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50);     
    
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cumplimiento_senior( TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini || ' );' ||
                     ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PRD', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
  end sp_cr_job_Cumplimiento_Senior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_bonoTrimestral_senior(pd_fecpro in date,
                                        pc_comite in varchar2,
                                        pc_codage in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_bonoTrimestral_senior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE BONO TRIMESTRAL SENIOR  POR CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
      select *
        from jaql600s j
       where j.jaql600sfpro = pd_fecpro
         and j.jaql600susu like '%' || lc_analista || '%';
    --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_metsal          number;
    ln_metcli          number;
    ln_metret          number;
    ln_metmor          number;
  
    ln_mtoret       number;
    ln_pagsal       number;
    ln_salexcedente number;
    ln_pagsal_adi   number;
    ln_pagsal_tot   number;
    ln_pagcli       number;
    ln_cliexcedente number;
    ln_pagcli_adi   number;
    ln_pagcli_tot   number;
  
    ln_exccli number;
    ln_excsal number;
    ln_porcum number;
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_mto_cartera  number := 0;
    ln_mto_clientes number := 0;
    ln_monto_mora   number := 0;
    ln_pago         number;
    ln_pagmor       number := 0;
    ln_incmora      number;
    ln_porsal       number;
    ln_porcli       number;
    ln_prom_sal     number := 0;
    ln_prom_cli     number := 0;
    lc_indicar      char(1) := 'N';
    ln_sal          number := 0;
    ln_cli          number := 0;
    ln_nummes       number;
    ld_fecfin       date;
    ln_mtosal       number;
    ln_mtocli       number;
    ln_minsal       number;
    ln_mincli       number;
    ln_prominsal    number := 0;
    ln_promincli    number := 0;
  
    lc_analista varchar2(10) := null;
  
  begin
  
    if pc_comite is null then
      lc_analista := '%';
    else
      lc_analista := pc_comite;
    end if;
    ln_nummes := to_number(to_char(pd_fecpro, 'mm'));
  
    IF ln_nummes in (3, 6, 9, 12) then
      -- pd_fecpro SI MES ES 3,6 ,9,12 PAGAR BONOT TRIMESTRAL.
    
      for i in analistas(lc_analista) loop
      
        if i.jaql600smsa <> 0 then
        
          lc_indicar := 'N';
        
          ln_sal := 0;
          ln_cli := 0;
        
          for x in 0 .. 2 loop
          
            ld_fecfin := last_day(add_months(trunc(pd_fecpro), -x));
          
            --MODIFICAR VALIDANDO CRECIIENTOS
          
            begin
              select JAQL600STSA, JAQL600STCL, JAQL600SMSA, JAQL600SMCL
                into ln_mtosal, ln_mtocli, ln_minsal, ln_mincli
                from jaql600s j
               where j.jaql600sfpro = ld_fecfin
                 and j.jaql600susu = i.jaql600susu;
            exception
              when no_Data_found then
                ln_mtosal := 0;
                ln_mtocli := 0;
                ln_minsal := 0;
                ln_mincli := 0;
              when others then
                ln_mtosal := 0;
                ln_mtocli := 0;
                ln_minsal := 0;
                ln_mincli := 0;
            end;
          
            if (ln_mtosal - ln_minsal) >= 0 AND ln_mtosal > 0 then
              ln_prom_sal  := ln_prom_sal + ln_mtosal;
              ln_prominsal := ln_prominsal + ln_minsal;
              ln_sal       := ln_sal + 1;
            end if;
            if (ln_mtocli - ln_mincli) >= 0 AND ln_mtocli > 0 then
              ln_prom_cli  := ln_prom_cli + ln_mtocli;
              ln_promincli := ln_promincli + ln_mincli;
              ln_cli       := ln_cli + 1;
            end if;
          
          end loop;
        
          if ln_sal = 3 then
            --cumplio 3 meses en cartera
            --comisiona
            --ln_prom_sal := round(ln_prom_sal/3,2);
            if ln_prominsal <> 0 then
              ln_prom_sal := round(ln_prom_sal / ln_prominsal, 2) * 100;
            else
              ln_prom_sal := 0;
            end if;
          
            --bono cartera 
            begin
              SELECT JAQZ453MTO
                into ln_mto_cartera
                FROM JAQZ453
               WHERE ln_prom_sal >= JAQZ453MIN
                 AND ln_prom_sal < JAQZ453MAX
                 AND JAQZ453CAT = 7
                 AND JAQZ453TIP = 'S';
            exception
              when no_Data_found then
                ln_mto_cartera := 0;
            end;
          
          end if;
        
          if ln_cli = 3 then
            --cumplio 3 meses en clientes 
            --ln_prom_cli := round(ln_prom_cli/3,2);
            if ln_promincli <> 0 then
              ln_prom_cli := round(ln_prom_cli / ln_promincli, 2) * 100;
            else
              ln_prom_cli := 0;
            end if;
          
            --bono clientes 
            begin
              SELECT JAQZ453MTO
                into ln_mto_clientes
                FROM JAQZ453
               WHERE ln_prom_cli >= JAQZ453MIN
                 AND ln_prom_cli < JAQZ453MAX
                 AND JAQZ453CAT = 7
                 AND JAQZ453TIP = 'C';
            exception
              when no_Data_found then
                ln_mto_clientes := 0;
            end;
          
          end if;
        
          --ln_incmora := i.JAQL600PJCA;
          --valida continuidad se multiplica por negativo 
          ln_incmora :=  /*(-1)**/
           PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora_comite(i.jaql600susu,
                                                                               pd_fecpro);
        
          if ln_incmora < 1 then
            --- puede comisionar
            case
              when ln_incmora > 0 and ln_incmora <= 0.9 then
                ln_pagmor := 50;
              when ln_incmora = 0 then
                ln_pagmor := 100;
              when ln_incmora <= -0.01 and ln_incmora >= -1 then
                ln_pagmor := 115;
              when ln_incmora <= -1.01 then
                ln_pagmor := 130;
              else
                ln_pagmor := 0;
            end case;
            ln_pago := (ln_mto_cartera + ln_mto_clientes) * ln_pagmor / 100;
          else
            ln_pago := 0;
          end if;
        
          --ln_pago := ln_mto_cartera + ln_mto_clientes + ln_monto_mora;
        
          update JAQL600S j
             set JAQL600SBSAL = ln_mto_cartera,
                 JAQL600SBCLI = ln_mto_clientes,
                 JAQL600SBMRA = ln_pagmor / 100,
                 JAQL600SBTRI = ln_pago,
                 JAQL600STOT  = nvl(JAQL600SPVAR, 0) + ln_pago
           where j.jaql600sfpro = pd_fecpro
             and j.jaql600susu = i.jaql600susu;
        
          ln_pago         := 0;
          ln_mto_cartera  := 0;
          ln_mto_clientes := 0;
          ln_pagmor       := 0;
          ln_incmora      := 0;
          ln_monto_mora   := 0;
          ln_prom_sal     := 0;
          ln_prom_cli     := 0;
          ln_prominsal    := 0;
          ln_promincli    := 0;
        
        end if;
      
      end loop;
    
      commit;
    
    END IF;
  
  end sp_cr_bonoTrimestral_senior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_agencia(pc_analista IN char, pd_fecpro IN date)
    return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_AGENCIA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna el codigo de sucursal del mes anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : ln_codsuc: saldo anterior del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    cursor desembolsos(lc_analista in char) is
      select j.jaqz454sucu, j.jaqz454ase, count(*) cantidad
        from jaqz454 j
       where j.jaqz454fpro = pd_fecpro
         and j.jaqz454ase = lc_analista
       group by j.jaqz454sucu, j.jaqz454ase; --1606
  
    cursor creditos(lc_analista in char) is
      select j.jaql965suc, j.jaql965ase, count(*) cantidad
        from jaql965 j
       where j.jaql965fech = pd_fecpro
         and j.jaql965ase = lc_analista
         and j.jaql965mod not in (33, 200)
       group by j.jaql965suc, j.jaql965ase; --1606
  
    ln_cantidad number := 0;
    ln_codage   number := 0;
    --pc_analista varchar2(10) := 'FMAMANICR';
    lc_analista char(10);
    ln_contador number := 1;
  
  begin
  
    lc_analista := rpad(pc_analista, 10, ' ');
  
    for i in desembolsos(lc_analista) loop
      if ln_contador = 1 then
        ln_contador := ln_contador + 1;
        ln_cantidad := i.cantidad;
      end if;
    
      if ln_cantidad <= i.cantidad then
        ln_cantidad := i.cantidad;
        ln_codage   := i.jaqz454sucu;
      
        --dbms_output.put_line('ln_cantidad 1 '||ln_cantidad||' ln_codage '||ln_codage);
      
      end if;
    end loop;
  
    if ln_codage = 0 then
      ln_contador := 1;
      for x in creditos(lc_analista) loop
      
        if ln_contador = 1 then
          ln_contador := ln_contador + 1;
          ln_cantidad := x.cantidad;
        end if;
      
        if ln_cantidad <= x.cantidad then
          ln_cantidad := x.cantidad;
          ln_codage   := x.jaql965suc;
        
          --dbms_output.put_line('ln_cantidad 2 '||ln_cantidad||' ln_codage '||ln_codage);
        
        end if;
      end loop;
    
    end if;
  
    return ln_codage;
  
  end fn_cr_agencia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cartera_recibida(pc_analista IN char, pd_fecpro IN date)
    return char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_cartera_recibida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Verificar 2 meses hacia atras, debe excluir continuidad.
    -- Estado                     : 
    -- Acceso                     : 
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_cantidad number := 0;
    ln_codage   number := 0;
    lc_analista char(10);
    ln_contador number := 1;
  
    lc_indicador char(1) := 'N';
    ld_fecant    date;
  
  begin
  
    begin
      select 'S'
        into lc_indicador
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu = pc_analista
         and j.jaql600srec > 0;
    exception
      when no_data_found then
        lc_indicador := 'N';
    end;
  
    ld_fecant := pd_fecpro;
  
    if lc_indicador = 'N' then
      --si no hubo traslado cartera recibida, verificar si mes anterior si hubo traslado
    
      for x in 1 .. 2 loop
      
        ld_fecant := add_months(last_day(ld_fecant), -1);
      
        begin
          select 'S'
            into lc_indicador
            from jaql600 j
           where j.jaql600fpro = ld_fecant
             and j.jaql600usu = pc_analista
             and j.jaql600srec > 0;
        exception
          when no_data_found then
            lc_indicador := 'N';
        end;
      
        if lc_indicador = 'S' then
          exit;
        end if;
      
      end loop;
    
    end if;
  
    return lc_indicador; --si retorna S no aplicar continuidad
  
  end fn_cr_cartera_recibida;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_mora_traslado(pc_analista IN char,
                             pd_fecpro   IN date,
                             pn_salrec   in number,
                             pn_salmor   out number,
                             pn_pormor   out number) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_cartera_recibida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : 
    -- Acceso                     : 
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_saldomor number := 0;
    ln_pormor   number := 0;
    /*
    select jaqz455ased, 
    sum(k.jaql965sdmn) SALDOTOT,
    sum(case when k.jaql965datr > 15 then k.jaql965sdmn else 0 end) SALDO_MOR
    from jaqz455 j, jaql965 k 
    where k.jaql965fech = j.jaqz455fech 
    and j.jaqz455fech = '30/06/2017'
    and k.jaql965ase = j.jaqz455ased 
    and k.jaql965emp = j.jaqz455emp
    and k.jaql965mod = j.jaqz455mod
    and k.jaql965suc = j.jaqz455suc
    and k.jaql965mda = j.jaqz455mda
    and k.jaql965cta = j.jaqz455cta
    and k.jaql965oper = j.jaqz455oper
    and k.jaql965sbop = j.jaqz455sbop
    and j.jaqz455ased is not null
    group by jaqz455ased
    */
  
  begin
  
    begin
      select sum(case
                   when k.jaql965datr  > 8 --15 2023.03.20 se actualizo dias atraso
                     then
                    k.jaql965sdmn
                   else
                    0
                 end) SALDO_MOR
        into ln_saldomor
        from jaqz455 j, jaql965 k
       where k.jaql965fech = j.jaqz455fech
         and j.jaqz455fech = pd_fecpro
         and k.jaql965ase = j.jaqz455ased
         and k.jaql965emp = j.jaqz455emp
         and k.jaql965mod = j.jaqz455mod
         and k.jaql965suc = j.jaqz455suc
         and k.jaql965mda = j.jaqz455mda
         and k.jaql965cta = j.jaqz455cta
         and k.jaql965oper = j.jaqz455oper
         and k.jaql965sbop = j.jaqz455sbop
         and j.jaqz455ased = pc_analista;
    
    exception
      when no_data_found then
        ln_saldomor := 0;
    end;
  
    ln_saldomor := nvl(ln_saldomor, 0);
  
    --obtener porcentaje
    if pn_salrec > 0 then
    
      ln_pormor := round((ln_saldomor * 100) / pn_salrec, 2);
    else
      ln_pormor := 0;
    end if;
  
    pn_salmor := ln_saldomor;
    pn_pormor := ln_pormor;
  
  end sp_mora_traslado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_inserta_cartera_diarioI(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_cartera_diario_ini
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA DIARIA A JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.05.29
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico ld_Fecpro = pd_fecpro + 1
    --                              se modifico busqueda en FSD010  
    --                              2014.06.03 DCASTRO - Se comentó llamada a proceso sp_cr_inserta_castigados.
    --                              2014.06.04 DCASTRO - Se descomento modulo 33 para carga de jaql964           
    --                              2014.06.25 DCASTRO - se comento jaql965sec para agrupamiento.    
    --                              2018.01.09 DCASTRO - se habilito carga diaria
    -- *****************************************************************
  
    TYPE tp_JAQL964FEC IS TABLE OF JAQL964.JAQL964FEC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964PGCOD IS TABLE OF JAQL964.JAQL964PGCOD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964MOD IS TABLE OF JAQL964.JAQL964MOD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SUC IS TABLE OF JAQL964.JAQL964SUC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964MDA IS TABLE OF JAQL964.JAQL964MDA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964CTA IS TABLE OF JAQL964.JAQL964CTA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964OPE IS TABLE OF JAQL964.JAQL964OPE%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SOB IS TABLE OF JAQL964.JAQL964SOB%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964TOP IS TABLE OF JAQL964.JAQL964TOP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964INS IS TABLE OF JAQL964.JAQL964INS%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964USU IS TABLE OF JAQL964.JAQL964USU%type INDEX BY PLS_INTEGER;
    -- TYPE tp_JAQL964RUBR IS TABLE OF JAQL964.JAQL964RUBR%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SAC IS TABLE OF JAQL964.JAQL964SAC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SAO IS TABLE OF JAQL964.JAQL964SAO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964DIA IS TABLE OF JAQL964.JAQL964DIA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964PAI IS TABLE OF JAQL964.JAQL964PAI%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964TID IS TABLE OF JAQL964.JAQL964TID%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964DOC IS TABLE OF JAQL964.JAQL964DOC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964PRO IS TABLE OF JAQL964.JAQL964PRO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SEC IS TABLE OF JAQL964.JAQL964SEC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SDVE IS TABLE OF JAQL964.JAQL964SDVE%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964SDRE IS TABLE OF JAQL964.JAQL964SDRE%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL964STAT IS TABLE OF JAQL964.JAQL964EST%type INDEX BY PLS_INTEGER;
    --TYPE tp_JAQL964PROM IS TABLE OF JAQL964.JAQL964PROM%type INDEX BY PLS_INTEGER;
    --TYPE tp_JAQL964TPCL IS TABLE OF JAQL964.JAQL964TPCL%type INDEX BY PLS_INTEGER;
  
    V_JAQL964FEC   tp_JAQL964FEC;
    V_JAQL964PGCOD tp_JAQL964PGCOD;
    V_JAQL964MOD   tp_JAQL964MOD;
    V_JAQL964SUC   tp_JAQL964SUC;
    V_JAQL964MDA   tp_JAQL964MDA;
    V_JAQL964CTA   tp_JAQL964CTA;
    V_JAQL964OPE   tp_JAQL964OPE;
    V_JAQL964SOB   tp_JAQL964SOB;
    V_JAQL964TOP   tp_JAQL964TOP;
    V_JAQL964INS   tp_JAQL964INS;
    V_JAQL964USU   tp_JAQL964USU;
    -- V_JAQL964RUBR tp_JAQL964RUBR; 
    V_JAQL964SAC  tp_JAQL964SAC;
    V_JAQL964SAO  tp_JAQL964SAO;
    V_JAQL964DIA  tp_JAQL964DIA;
    V_JAQL964PAI  tp_JAQL964PAI;
    V_JAQL964TID  tp_JAQL964TID;
    V_JAQL964DOC  tp_JAQL964DOC;
    V_JAQL964PRO  tp_JAQL964PRO;
    V_JAQL964SEC  tp_JAQL964SEC;
    V_JAQL964SDVE tp_JAQL964SDVE;
    V_JAQL964SDRE tp_JAQL964SDRE;
    V_JAQL964STAT tp_JAQL964STAT;
  
    --V_JAQL964PROM tp_JAQL964PROM;  
    --V_JAQL964TPCL tp_JAQL964TPCL;   
  
    ln_numreg number;
    ln_indins number := 0;
    ld_fecval date;
    ld_fecvto date;
    ld_Fecpro date;
  
  begin
  
    ld_fecpro := pd_fecpro + 1;
  
    begin
      select count(*)
        into ln_numreg
        from (select JAQL964FEC,
                     JAQL964PGCOD,
                     JAQL964MOD,
                     JAQL964SUC,
                     JAQL964MDA,
                     JAQL964CTA,
                     JAQL964OPE,
                     JAQL964SOB,
                     JAQL964TOP,
                     JAQL964INS,
                     JAQL964USU,
                     JAQL964DIA,
                     JAQL964PAI,
                     JAQL964TID,
                     JAQL964DOC,
                     JAQL964EST,
                     JAQL964PRO
                from JAQL964
               where JAQL964FEC = ld_fecpro --CONSIDERAR TODA LA CARTERA
                 and JAQL964MOD not in (117)
               group by JAQL964FEC,
                        JAQL964PGCOD,
                        JAQL964MOD,
                        JAQL964SUC,
                        JAQL964MDA,
                        JAQL964CTA,
                        JAQL964OPE,
                        JAQL964SOB,
                        JAQL964TOP,
                        JAQL964INS,
                        JAQL964USU,
                        JAQL964DIA,
                        JAQL964PAI,
                        JAQL964TID,
                        JAQL964DOC,
                        JAQL964EST,
                        JAQL964PRO);
    end;
  
    select --distinct
     JAQL964FEC - 1,
     JAQL964PGCOD,
     JAQL964MOD,
     JAQL964SUC,
     JAQL964MDA,
     JAQL964CTA,
     JAQL964OPE,
     JAQL964SOB,
     JAQL964TOP,
     JAQL964INS,
     JAQL964USU,
     -- JAQL964RUBR,
     sum(JAQL964SAC * -1),
     sum(JAQL964SAO * -1),
     JAQL964DIA,
     JAQL964PAI,
     JAQL964TID,
     JAQL964DOC,
     sum(JAQL964SDVE * -1),
     sum(JAQL964SDRE * -1),
     --substr(JAQL964PRO,1,20), --
     /*JAQL964SEC/*,
     JAQL964STAT,
     JAQL964PROM,
     JAQL964TPCL*/
     JAQL964EST,
     JAQL964PRO
      bulk collect
      into V_JAQL964FEC,
           V_JAQL964PGCOD,
           V_JAQL964MOD,
           V_JAQL964SUC,
           V_JAQL964MDA,
           V_JAQL964CTA,
           V_JAQL964OPE,
           V_JAQL964SOB,
           V_JAQL964TOP,
           V_JAQL964INS,
           V_JAQL964USU,
           --V_JAQL964RUBR,
           V_JAQL964SAC,
           V_JAQL964SAO,
           V_JAQL964DIA,
           V_JAQL964PAI,
           V_JAQL964TID,
           V_JAQL964DOC,
           V_JAQL964SDVE,
           V_JAQL964SDRE,
           --V_JAQL964PRO,
           /*V_JAQL964SEC/*,
           V_JAQL964STAT,
           V_JAQL964PROM,
           V_JAQL964TPCL */
           V_JAQL964STAT,
           V_JAQL964PRO
      from JAQL964
     where JAQL964FEC = ld_fecpro --CONSIDERAR TODA LA CARTERA
       and JAQL964MOD not in (117)
    -- and JAQL964MOD not in (108, /*33,*/ 117) and (JAQL964MOD <> 106 Or JAQL964TOP <> 30)
     group by JAQL964FEC,
              JAQL964PGCOD,
              JAQL964MOD,
              JAQL964SUC,
              JAQL964MDA,
              JAQL964CTA,
              JAQL964OPE,
              JAQL964SOB,
              JAQL964TOP,
              JAQL964INS,
              JAQL964USU,
              --JAQL964RUBR,
              JAQL964DIA,
              JAQL964PAI,
              JAQL964TID,
              JAQL964DOC,
              JAQL964EST,
              JAQL964PRO /*,
          JAQL964SEC*/
    ;
  
    --Elimina registros de historico del dia actual
    begin
    
      --insertar diario en historico
      FOR i IN 1 .. ln_numreg loop
      
        --IF V_JAQL964MOD(i)= 33 or substr(V_JAQL964PRO(i),1,11) <> 'CORPORATIVO' then  --CONSIDERAR CARTERA DIFERENTE DE CORPORATIVOS
      
        IF (V_JAQL964MOD(i) = 200 and V_JAQL964SAC(i) = 0) or
           (V_JAQL964MOD(i) = 33 and V_JAQL964STAT(i) = 99) then
          --si credito es judicial y tiene capital 0 no considerar , castigado cancelado tampoco considerar
          null;
        else
          begin
            select f.aofval, f.aofvto
              into ld_fecval, ld_fecvto
              from FSD010 f
             where f.PGCOD = 1
               and f.AOMOD = V_JAQL964MOD(i)
               and f.AOMDA = V_JAQL964MDA(i)
               and f.AOPAP = 0
               and f.AOCTA = V_JAQL964CTA(i)
               and f.AOSUC = V_JAQL964SUC(i)
               and f.AOOPER = V_JAQL964OPE(i)
               and f.AOSBOP = V_JAQL964SOB(i)
               and f.aostat = V_JAQL964STAT(i) --0   --2016.02.08 se agrego variable estado
               and rownum < 2;
          exception
            when no_data_found then
              ld_fecval := null;
              ld_fecvto := null;
          end;
        
          begin
            --insertar diario
            insert into JAQL965
              (JAQL965FECH,
               JAQL965EMP,
               JAQL965MOD,
               JAQL965SUC,
               JAQL965MDA,
               JAQL965PAP,
               JAQL965CTA,
               JAQL965OPER,
               JAQL965SBOP,
               JAQL965TOP,
               JAQL965INST,
               JAQL965ASE,
               JAQL965RUBR,
               JAQL965SDMN,
               JAQL965SDMO,
               JAQL965DATR,
               JAQL965FVAL,
               JAQL965FVTO,
               JAQL965PAIS,
               JAQL965TDOC,
               JAQL965NDOC,
               JAQL965SDRE,
               JAQL965SDVE,
               --JAQL965TCRD,
               /*JAQL965SECT/*,
               JAQL965STAT,
               JAQL965PROM,
               JAQL965TPCL*/
               JAQL965STAT,
               JAQL965TCRD)
            VALUES
              (V_JAQL964FEC(i),
               1,
               V_JAQL964MOD(i),
               V_JAQL964SUC(i),
               V_JAQL964MDA(i),
               0,
               V_JAQL964CTA(i),
               V_JAQL964OPE(i),
               V_JAQL964SOB(i),
               V_JAQL964TOP(i),
               V_JAQL964INS(i),
               V_JAQL964USU(i),
               1, --V_JAQL964RUBR(i),
               V_JAQL964SAC(i),
               V_JAQL964SAO(i),
               V_JAQL964DIA(i),
               ld_fecval,
               ld_fecvto,
               V_JAQL964PAI(i),
               V_JAQL964TID(i),
               V_JAQL964DOC(i),
               V_JAQL964SDRE(i),
               V_JAQL964SDVE(i),
               -- V_JAQL964PRO(i),
               /*V_JAQL964SEC(i)/*,
               V_JAQL964STAT(i),
               V_JAQL964PROM(i),
               V_JAQL964TPCL(i)*/
               V_JAQL964STAT(i),
               substr(V_JAQL964PRO(i), 1, 20));
            commit;
          exception
            when others then
              null;
          end;
          ln_indins := ln_indins + 1;
          if ln_indins >= 5000 then
            ln_indins := 0;
            commit;
          end if;
        
        END IF;
        -- END IF;     
      end loop;
      commit;
    end;
  
    --inserta SNG
    --2018.01.09  
    delete from SNG057_201X where sng057fpro = pd_fecpro;
  
    INSERT INTO SNG057_201X
      SELECT sng055emp,
             sng057usr,
             sng055car,
             sng057aut,
             sng057sup,
             sng057ini,
             sng057fin,
             sng057jef,
             sng057wkf,
             sng057prc,
             sng057tsk,
             pd_fecpro
        FROM SNG057;
  
    commit;
    ---
  
  end sp_cr_inserta_cartera_diarioI;

  ------------------------------------------------------------------------------------------------
  procedure sp_cr_sch_indicadores(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_IND';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_indicadores( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_IND', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_indicadores;
  -------------------------------------------------------------------------------------------------
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number is
                                --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    ln_numjob number(9) := 0;
    lc_nomusr varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then
           null;
    end;
  
    begin
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
    exception when others then
           null;         
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_Calculo_Senior(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini        number;
    lc_variable   varchar2(1000);
    ln_job        number := 0;
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;

    lb_njobs      number(3);    
    lc_user       varchar(5);
    lc_prefijo    varchar(10);     
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50); 
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;      
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    delete from JAQL600S where jaql600Sfpro = pd_fecpro;
    commit;
  
    ---carga diaria
    for i in sucursal loop
    
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_CS1';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_Calculo_senior( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_CS1', ln_ini, lc_variable);
      COMMIT;
    
    
      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


    
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_Calculo_Senior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_cumplimiento(pd_fecpro in date) is
  --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;

    lb_njobs      number(3);    
    lc_user       varchar(5);
    lc_prefijo    varchar(10);     
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50); 
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;      
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_CUM';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cumplimiento( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
--          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_CUM', ln_ini, lc_variable);
      COMMIT;
 

    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_cumplimiento;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sch_Cumplimiento_Senior(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini        number;
    lc_variable   varchar2(1000);
    ln_job        number := 0;
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;

    lb_njobs      number(3);    
    lc_user       varchar(5);
    lc_prefijo    varchar(10);     
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50); 
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;      
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_CS2';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cumplimiento_senior( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
--          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_CS2', ln_ini, lc_variable);
      COMMIT;

   
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_Cumplimiento_Senior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_Calculo_Mensual(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    --2019.09.04 DCASTRO se agrego sentencia execute inmediate en lc_sql
    --2023.03.09 DCASTRO se modifico procesos
    --2025.01.15 DCASTRO se modificó procesos para calculo mensual
    lc_fecpro char(10);
    lc_tabla  varchar2(30);
    lc_sql    varchar2(4000);
  
  begin
 
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';

 
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
    lc_tabla  := 'operador.sng057_' || to_char(pd_fecpro, 'RRRRMM');

    delete  from jaql600i where JAQL600Ifpro = pd_fecpro;
    commit;

  
    --0 eLIMINA
    DELETE FROM SNG057_201X S WHERE S.SNG057FPRO = pd_fecpro;
    commit;
  
    --1  GENERAR BACKUP
 
    lc_sql := 'INSERT INTO SNG057_201X (sng055emp, sng057usr, sng055car, sng057aut, 
                sng057sup, sng057ini, sng057fin, sng057jef, sng057wkf, sng057prc, sng057tsk, SNG057FPRO ) 
                SELECT sng055emp, sng057usr, sng055car, sng057aut, sng057sup, sng057ini, sng057fin, sng057jef, 
                sng057wkf, sng057prc, sng057tsk,
                ''' || pd_fecpro || ''' from ' || lc_tabla;

 
    EXECUTE IMMEDIATE lc_sql;
    commit;
    
 
    --0 inserta tabla log
    insert into jaql600i(JAQL600Ifpro, JAQL600IC1I)  
    values(pd_fecpro, sysdate);
       
    
   --1 actualiza traslados
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_traslados_JAQZ455(pd_fecpro);
    end;
    update jaql600i set JAQL600IC1F = sysdate, JAQL600IC2I = sysdate where JAQL600Ifpro = pd_fecpro;
 
    --2 -inserta desembolsos
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_desembolsos(pd_fecpro);
    end;
    update jaql600i set JAQL600IC2F = sysdate, JAQL600IC3I = sysdate where JAQL600Ifpro = pd_fecpro;

    --3  INSERTA CARTERA EN TABLA BASE JAQL965, DESEMBOLSOS, 
     --  inserta data de cartera en jaql965, toma como base data de jaqll964
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cartera_mes(pd_fecpro);
    end;

    update jaql600i set JAQL600IC3F = sysdate, JAQL600IC4I = sysdate where JAQL600Ifpro = pd_fecpro;

  
    --4 - CARGA INFORMACION PARA PRODUCTIVIDAD JAQL600  
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_sch_job_carga(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC4F = sysdate, JAQL600IC5I = sysdate where JAQL600Ifpro = pd_fecpro;  
   

    --5 -INDICADORES - OBTIENE VARIABLES E INDICADORES PARA CALCULO PRODUCTIVIDAD
    --C2
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_indicadores(pd_fecpro);
    end;
    update jaql600i set JAQL600IC5F = sysdate, JAQL600IC6I = sysdate where JAQL600Ifpro = pd_fecpro;  
  
    --6 - CUMPLIMIENTO - VALIDA CUMPLIMIENTO EN CARTERA, CLIENTES, RETENCION, CONTENCION, MORA, CONTINUIDAD MORA
    --C3
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cumplimiento(pd_fecpro);
    end;
    update jaql600i set JAQL600IC6F = sysdate, JAQL600IC7I = sysdate where JAQL600Ifpro = pd_fecpro;  

    --7 calculo senior
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_calculo_senior(pd_fecpro   => pd_fecpro,
                                                    pc_analista => '');
    end;

    update jaql600i set JAQL600IC7F = sysdate, JAQL600IC8I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --8--Cumplimiento SENIOR
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_Cumplimiento_Senior(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC8F = sysdate where JAQL600Ifpro = pd_fecpro;  
    commit;
 


  end sp_cr_Calculo_Mensual;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_Calculo_Mensual_ini(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    --2019.09.04 DCASTRO se agrego sentencia execute inmediate en lc_sql
    --2025.01.24 DCASTRO se actualizo procedimiento para calculo mensual
    
    lc_fecpro char(10);
    lc_tabla  varchar2(30);
    lc_sql    varchar2(4000);
  
  begin
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
    lc_tabla  := 'operador.sng057_' || to_char(pd_fecpro, 'RRRRMM');

    delete  from jaql600i where JAQL600Ifpro = pd_fecpro;
    commit;

  
    --0 eLIMINA
    DELETE FROM SNG057_201X S WHERE S.SNG057FPRO = pd_fecpro;
    commit;
  
    --1  GENERAR BACKUP
 
    lc_sql := 'INSERT INTO SNG057_201X (sng055emp, sng057usr, sng055car, sng057aut, 
                sng057sup, sng057ini, sng057fin, sng057jef, sng057wkf, sng057prc, sng057tsk, SNG057FPRO ) 
                SELECT sng055emp, sng057usr, sng055car, sng057aut, sng057sup, sng057ini, sng057fin, sng057jef, 
                sng057wkf, sng057prc, sng057tsk,
                ''' || pd_fecpro || ''' from ' || lc_tabla;

 
    EXECUTE IMMEDIATE lc_sql;
    commit;
    
    --2  INSERTA CARTERA EN TABLA BASE JAQL965, DESEMBOLSOS, 
        --EJECUTAR SEPARADO  LANZA JOBS
        /*      begin
                   PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_cartera(pd_fecpro => pd_fecpro);
                End;
        */
  
  
    --3 - CARGA INFORMACION PARA PRODUCTIVIDAD JAQL600    2025.01.24
    
    insert into jaql600i(JAQL600Ifpro, JAQL600IC1I)  
    values(pd_fecpro, sysdate);

    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_sch_job_carga(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC1F = sysdate, JAQL600IC2I = sysdate where JAQL600Ifpro = pd_fecpro;
   

    --4 -INDICADORES - OBTIENE VARIABLES E INDICADORES PARA CALCULO PRODUCTIVIDAD
    --C2
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_indicadores(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC2F = sysdate, JAQL600IC3I = sysdate where JAQL600Ifpro = pd_fecpro;
  
    --5 - CUMPLIMIENTO - VALIDA CUMPLIMIENTO EN CARTERA, CLIENTES, RETENCION, CONTENCION, MORA, CONTINUIDAD MORA
    --C3
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_cumplimiento(pd_fecpro => pd_fecpro);
    end;
  
    update jaql600i set JAQL600IC3F = sysdate, JAQL600IC4I = sysdate where JAQL600Ifpro = pd_fecpro;
    
    --6 BONO TRIMESTRAL y CARGA SENIOR
    --C4  
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_bonotrimestral(pd_fecpro   => pd_fecpro,
                                                    pc_analista => '',
                                                    pc_codage   => '');
    end;

    update jaql600i set JAQL600IC4F = sysdate, JAQL600IC5I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --C5
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_calculo_senior(pd_fecpro   => pd_fecpro,
                                                    pc_analista => '');
    end;

    update jaql600i set JAQL600IC5F = sysdate, JAQL600IC6I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --7--Cumplimiento SENIOR
    --C6
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_cumplimiento_senior(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC6F = sysdate, JAQL600IC7I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --8--BONO TRIMESTRAL SENIOR
    --C7
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_bonotrimestral_senior(pd_fecpro => pd_fecpro,
                                                           pc_comite => '',
                                                           pc_codage => '');
    end;

    update jaql600i set JAQL600IC7F = sysdate where JAQL600Ifpro = pd_fecpro;  
    commit;
    
  end sp_cr_Calculo_Mensual_INI;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_instancia_asesor(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    cursor analistas is
      select *
        from jaql114
       where jaql114fech = pd_fecpro
         and jaql114ase is null
         and jaql114sdmn <> 0;
  
    ln_instancia number;
    lc_analista  varchar2(10);
  
  begin
  
    for i in analistas loop
    
      begin
        ln_instancia := fn_instancia_credito(v_scmod  => i.jaql114mod,
                                             v_scsuc  => i.jaql114suc,
                                             v_scmda  => i.jaql114mda,
                                             v_scpap  => i.jaql114pap,
                                             v_sccta  => i.jaql114cta,
                                             v_scoper => i.jaql114oper,
                                             v_scsbop => i.jaql114sbop,
                                             v_sctope => i.jaql114top);
      end;
    
      begin
        lc_analista := fn_analista_credito(v_scmod  => i.jaql114mod,
                                           v_scsuc  => i.jaql114suc,
                                           v_scmda  => i.jaql114mda,
                                           v_scpap  => i.jaql114pap,
                                           v_sccta  => i.jaql114cta,
                                           v_scoper => i.jaql114oper,
                                           v_scsbop => i.jaql114sbop,
                                           v_sctope => i.jaql114top);
      end;
    
      --dbms_output.put_line(i.jaql114cta||' '||i.jaql114oper||' '||ln_instancia||' '||lc_analista);
      update jaql114 k
         set k.jaql114inst = ln_instancia, k.jaql114ase = lc_analista
       where k.jaql114fech = i.jaql114fech
         and k.jaql114emp = i.jaql114emp
         and k.jaql114mod = i.jaql114mod
         and k.jaql114suc = i.jaql114suc
         and k.jaql114pap = i.jaql114pap
         and k.jaql114cta = i.jaql114cta
         and k.jaql114oper = i.jaql114oper
         and k.jaql114sbop = i.jaql114sbop
         and k.jaql114top = i.jaql114top;
      commit;
    end loop;
  
  end sp_cr_instancia_asesor;
  -------------------------------------------------------------------------------------------------
  procedure sp_sch_job_carga(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini        number;
    lc_variable   varchar2(1000);
    ln_job        number := 0;
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
 
    lb_njobs      number(3);    
    ln_numjob     number(9) := 0;

    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50);     

 
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;      
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ld_finmes := last_Day(pd_fecpro);
  
    --antes de la carga eliminar DATA
    begin
      delete from JAQL600 where JAQL600FPRO = pd_fecpro;
      commit;
    exception when others then
           null;
    end;          
  
    if pd_fecpro <> ld_finmes then
    
      begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
      end;
    
      ---carga diaria
      for i in sucursal loop
        ln_ini      := i.sucurs;
        ln_job        := ln_job + 1;
        lc_prefjob    := 'PRODU_CAD';
        pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
        
        
        lc_variable := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_carga_datos_diario(' ||
                       ln_ini || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD'') );' || ' End;';

      
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Productividad_Cre');
          begin
--            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
          end;
        Else
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Productividad_Cre');
          begin
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
          end;
        End If;
        commit;
      
        INSERT INTO Tab_jobs
          (c_codage, n_Numer1, c_detjob)
        VALUES
          ('PRODU_CAD', ln_ini, lc_variable);
        COMMIT;

    
      end loop;
    
       ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
       While ln_numjob > 0 loop
          ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
       End loop;
    
    else
    
      begin
        -- Call the procedure
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
      end;
    
      ---carga mensual
      for i in sucursal loop
        ln_ini      := i.sucurs;
        ln_job        := ln_job + 1;
        lc_prefjob    := 'PRODU_CAM';
        pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
                               
        lc_variable := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_carga_datos(' ||
                       ln_ini || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD'') );' || ' End;';

      
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Productividad_Cre');
          begin
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
          end;
        Else
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Productividad_Cre');
          begin
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
          end;
        End If;
        commit;
      
        INSERT INTO Tab_jobs
          (c_codage, n_Numer1, c_detjob)
        VALUES
          ('PRODU_CAM', ln_ini, lc_variable);
        COMMIT;
      
      end loop;
      
       ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
       While ln_numjob > 0 loop
          ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
       End loop;
    
    end if;
  
  end sp_sch_job_carga;
  -------------------------------------------------
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_meses_ana(pc_analista IN char,
                            pn_codcat in number,            
                            pd_fecpro   IN date,
                            pc_numdoc in char,
                            pn_meses   out number,
                            pd_fecin   out date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_meses_ana
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve tipo anaista Nuevo/Antiguo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : pc_tipana
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_meses number(5);
    ld_fecin date;
    lc_analista varchar2(20);
    lc_numdoc varchar2(12);    
    
  begin
  
    lc_analista := rpad(pc_analista, 20, ' '); --
    lc_numdoc   := rpad(pc_numdoc, 12, ' '); --
    begin
         select  round((pd_fecpro - j.jaqy830faux)/31 , 0) ,j.jaqy830faux
           into ln_meses, ld_fecin
           from jaqy830 j
          where j.jaqy830codana = lc_analista--like  trim(lc_analista) || '%'
            and j.jaqy830ndoc = lc_numdoc
            and j.jaqy830est    = 'S';

    exception when others then
      begin
         select  round((pd_fecpro - j.jaqy830faux)/31 , 0) , j.jaqy830faux
           into ln_meses, ld_fecin
           from jaqy830 j
          where j.jaqy830codana = lc_analista--like  trim(lc_analista) || '%'
            and j.jaqy830codcat = pn_codcat
            and j.jaqy830ndoc = lc_numdoc
            and j.jaqy830est    = 'S'
            and rownum = 1;
     exception 
      when no_data_found then
        ln_meses := 0;
        ld_fecin := null;
     end;   
    end;
      
    pn_meses := ln_meses;
    pd_fecin := ld_fecin;
    
  end sp_cr_meses_ana;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_meses_age(pc_analista IN char,
                            pn_codcat in number,            
                            pd_fecpro IN date,
                            pn_codage in number,
                            pn_meses  out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_meses_age
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve los meses de antiguedad en la agencia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : pc_tipana
    -- Fecha de Modificación      : 2024.04.24
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modificó conteo de meses para calculo diario
    -- *****************************************************************
    ln_meses number(5);
    ln_mes number(5);    
    ld_fecin date;
    lc_analista varchar2(20);
    lc_numdoc varchar2(12);    

    
  begin
  
    lc_analista := rpad(pc_analista, 20, ' '); --

    ln_meses := 1;
    
     For f in 1 .. 18 loop

       --ld_fecin := ADD_MONTHS(pd_fecpro, -f); DCASTRO 2024.04.24 SE COMENTO
        ld_fecin := ADD_MONTHS(LAST_DAY(pd_fecpro), -f); --DCASTRO 2024.04.23 SE AGREGO A FECHA LAST_DAY
        
       begin   
           select /* +all_rows*/count(*)
            into ln_mes 
            from jaql600 j 
           where j.jaql600fpro = ld_fecin
           and j.jaql600usu = lc_analista
           and j.jaql600age = pn_codage;
       exception when others then
             ln_mes := 0;  
       end;      
       ln_meses := ln_meses + ln_mes;

      end loop;
  
     pn_meses := ln_meses;
    
  end sp_cr_meses_age;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_tipana_NA(pc_analista IN char,
                            pd_fecpro   IN date,
                            pn_meses    in number,
                            pc_tipana   out char,
                            pn_saldo    out number
                            ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_tipanalista_NA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve tipo anaista Nuevo/Antiguo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : pc_tipana
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --                            : 2023.11.13 se modificó guia de proceso para control de meses
    -- *****************************************************************
    ln_meses number(5);
    ln_saldo number(18,2):=0;
    lc_analista char(10);
    ld_fecha date;
    ln_mest number;
    ln_monto number(17,2);
    ln_saldoacu number(17,2);
    ln_mestot number;
  
  begin
  
    lc_analista := rpad(pc_analista, 10, ' '); --
  
    ld_fecha := pd_fecpro;
    ln_saldoacu := 0;
    ln_saldo := 0;
    
    begin

      select f.TP1NRO1, f.TP1IMP1, f.TP1NRO3
        into ln_mest, ln_monto, ln_mestot
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10847
         and f.TP1CORR1 = 22
         and TP1CORR2 = 1
         and TP1CORR3 = 0;
    exception
      when others then
        ln_mest := 0;
        ln_monto := 0;
    end;
      
    if pn_meses <= 12 then
  
        --for z in  1..ln_mest loop
        for z in  1..ln_mestot loop --2023.11.13 se cambio a 18 meses segun guia 
          begin
            select sum(nvl(j.jaql600srec,0)) -sum(nvl(j.jaql600soto,0)) ---SALDO RECIBIDO
             into ln_saldo
             from jaql600 j 
             where j.jaql600fpro = ld_fecha /* j.jaql600fpro >= add_months(pd_fecpro, -12) 
              and j.jaql600fpro <= pd_fecpro*/
              and j.jaql600usu = lc_analista;
          exception
            when OTHERS then
              ln_saldo := 0;
          end;
          ln_saldoacu := ln_saldoacu + nvl(ln_saldo,0);
          ld_fecha := add_months(last_day(pd_fecpro), -z);
          
          if nvl(ln_saldoacu,0) >= ln_monto then --2023.11.13
                exit;
          end if;

       end loop; 
       
       if nvl(ln_saldoacu,0) > ln_monto /*175000 soles*/ then
          pc_tipana := 'A'; --analista antiguo
       else
          pc_tipana := 'N'; --analista nuevo
       end if;
       
    else
          pc_tipana := 'A'; --analista antiguo      
    end if;
    
    pn_saldo := nvl(ln_saldoacu, 0);
  end sp_cr_tipana_NA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_desembolsos_new(pd_fecpro     in date,
                              pc_analista   in varchar2,
                              pc_codcat     in number,
                              pc_tipo       in varchar2,
                              pc_tipana     in varchar2,                              
                              pn_saldo      out number,
                              pn_porpago    out number,
                              pn_bonpago    out number,
                              pn_saldotot   out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_desembolsos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09
    -- Autor de Creación          : DCASTRO
    -- Uso                        : OBTIENE TOTAL Y PORCENTAJE DE DESEMBOLSOS DEL MES MICRO 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecini   date;
    ln_saldotot number := 0;
    ln_saldo    number := 0;
    ln_pordes   number;
    ln_porpagT  number;
    ln_porpagP  number;
    lc_analista char(10);
  
    cursor creditos(lc_analista in char) is
      select *
        from jaqz454 j
       where j.jaqz454fpro = pd_fecpro
         and j.jaqz454ase = lc_analista;
  
    ln_monto  number;
    ln_codsuc number;
    ln_cta    number;
    ln_oper   number;
    ln_moneda number;
  
  begin
  
    ld_fecini   := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    lc_analista := rpad(pc_analista, 10, ' '); --2016.02.08 obtiene codigo de analista
  
   
    for i in creditos(lc_analista) loop
    
      begin
        select j.jaqz454mda, j.jaqz454imp1
          into ln_moneda, ln_monto
          from jaqz454 j
         where j.jaqz454cta = i.jaqz454cta --i.jaql965cta
           and j.jaqz454oper = i.jaqz454oper --i.jaql965oper
           and j.jaqz454fcon = i.jaqz454fcon
           and j.jaqz454fpro = pd_fecpro;
      exception
        when others then
          ln_moneda := 0;
          ln_monto  := 0;
      end;
    
      if ln_moneda <> 0 then
        ln_monto := ln_monto * fn_tipo_cambio_fijo(pd_fecpro);
      end if;
    
      if i.jaqz454pro in ('MI') then  ---DESEMBOLSO MICRO PARA CALCULO ENFOQUE MICRO
        ln_saldo := ln_saldo + ln_monto;
      end if;
    
      ln_saldotot := ln_saldotot + ln_monto;
    
    end loop;
  
    if ln_saldotot <> 0 then
    
      pn_porpago := round(ln_saldo * 100 / ln_saldotot, 2);
      pn_saldo      := ln_saldo;
      pn_saldotot   := ln_saldotot;
    
    else
    
      pn_porpago    := 0;
      pn_saldo      := ln_saldo;
      pn_saldotot   := 0;
    
    end if;
 

   --porcentaje de desembolsos permitido
    begin
      --select tp1nro1, tp1nro2, tp1nro3
      --  into ln_pordes, ln_porpagT, ln_porpagP
       SELECT J.JAQL596ABON 
         into ln_porpagT
        FROM JAQL596A J
       WHERE J.JAQL596ACAT = pc_codcat
         AND J.JAQL596ATIP = pc_tipo
         AND J.JAQL596ATIPA = pc_tipana
         AND pn_porpago >= J.JAQL596AMN0 
         AND pn_porpago <= J.JAQL596AMN1 
         AND J.JAQL596AEST = 'S';
  
    exception
      when others then
        ln_porpagT := 0;
    end;
    pn_bonpago := ln_porpagT;
 
  end sp_cr_desembolsos_new;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_indicadores_new(pd_fecpro   in date,
                              pc_analista in varchar2,
                              pc_sucurs   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_indicadores_new
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09 -2023
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE INDICADORES PARA CALCULO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2023.09.21 
    -- Autor de la Modificación   : dcastro 
    -- Descripción de Modificación: se modifico campo Saldo cartera al cierre j.jaql600sdo
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
    --obtener crecimientos SALDO -CLIENTES
      select j.jaql600usu,
             j.jaql600sant,
             j.jaql600cant,
             j.jaql600sdo,
             j.jaql600ncl,
             j.jaql600codcat,
             j.jaql600tase,
             j.jaql600age,
             j.jaql600sdm,
             j.jaql600sdju,
             j.jaql600sdodi, ---cartera al dia
             (nvl(jaql600sdo, 0) + nvl(jaql600soto, 0) -
             nvl(jaql600srec, 0)) jaql600saldo,
             (nvl(jaql600ncl, 0) + nvl(jaql600coto, 0) -
             nvl(jaql600crec, 0)) jaql600cliente
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%'
         and j.jaql600age = pc_sucurs;
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_saldodesT       number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_cresal          number;
    ln_mtosal          number;
    ln_crecli          number;
    ln_mtocli          number;
    ln_mincom          number;
    ln_mtoret          number;
    ln_Por_Mora        number;
    ld_fecingreso      date;
  
    lc_analista varchar2(10) := null;
    
    ln_meses          number;
    lc_tipana         char(1);
    ln_bonpago        number;
    ln_valse1         number;
    ln_valse2         number;
    ln_valce1         number;
    ln_valce2         number;
    ln_saldoacu       number;
    lc_numdoc         char(12);
    ln_pordia         number;
    ln_pagdia         number;
    ln_cardia         number;

    
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista := trim(pc_analista);
    end if;
  
    for i in analistas(lc_analista) loop
    
      ln_salant  := i.jaql600sant;
      ln_cliant  := i.jaql600cant;
      ln_saldo   := i.jaql600saldo;
      ln_numcli  := i.jaql600cliente;
      ln_codcat  := i.jaql600codcat;
      lc_tipoase := i.jaql600tase;
      ln_cardia  := i.jaql600sdodi;
    
      ln_crecimiento_sal := ln_saldo - ln_salant;
      ln_crecimiento_cli := ln_numcli - ln_cliant;
      
      ln_meses  := 0;
      ln_porcentaje := 0;
      
      lc_tipana := null;
  
      ---porcentaje cartera al dia
      ln_pordia := round( ( ln_cardia * 100) / i.jaql600sdo ,2 );  ---2023.09.21 dcastro Saldo cartera al cierre
      if ln_pordia > 1000 then
         ln_pordia := 1000;
      end if;
  
      begin
        pq_cr_productividad_nueva.sp_cr_numdoc(pc_analista => i.jaql600usu,
                                               pc_numdoc => lc_numdoc);
      end;

     /* begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_meses_ana(pc_analista => i.jaql600usu,
                                                 pn_codcat => i.jaql600codcat,             
                                                 pd_fecpro => pd_fecpro,
                                                 pc_numdoc => lc_numdoc,
                                                 pn_meses => ln_meses,
                                                 pd_fecin => ld_fecingreso);
      end;
      */
      --meses de permanencia en agencia
     begin
      pq_cr_productividad_nueva.sp_cr_meses_age(pc_analista => i.jaql600usu,
                                                           pn_codcat => i.jaql600codcat,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_codage => i.jaql600age,
                                                           pn_meses => ln_meses);
    end;
    
      if lc_tipoase = 'P' then
        --aplica para PYMES
        --INDICADORES DESEMBOLSOS
        
          begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_tipana_na(pc_analista => i.jaql600usu,
                                                     pd_fecpro => pd_fecpro,
                                                     pn_meses =>  ln_meses,
                                                     pc_tipana => lc_tipana,
                                                     pn_saldo => ln_saldoacu);
          end;

          begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_desembolsos_new(pd_fecpro => pd_fecpro,
                                                           pc_analista => i.jaql600usu,
                                                           pc_codcat => i.jaql600codcat,
                                                           pc_tipo => 'P',
                                                           pc_tipana => lc_tipana,
                                                           pn_saldo => ln_saldoDES,
                                                           pn_porpago => ln_porpago,
                                                           pn_bonpago => ln_bonpago,
                                                           pn_saldotot => ln_saldodesT);
          end;
        
          /*
          2023-08.23 agregar cartera al DIA
          obtener porcentaje y monto de pago
          agregar cambios a carga diaria
          aplica si analista es antiguo
         */ if lc_tipana = 'A' then
               begin
                pq_cr_productividad_nueva.sp_cr_metas_cardia(pn_codcat => i.jaql600codcat,
                                                            pn_porcar => ln_pordia,
                                                            pn_pagcar => ln_pagdia);
              end;
            else
                ln_pagdia := 0;
                ln_pordia := 0;
            end if;

      else
        --para CONSUMO
        ln_saldodes   := 0;
        ln_porpago    := 0;
        ln_porcentaje := 100; --se pagara el 100% de la meta
        ln_saldodesT  := 0;
        ln_saldoacu   := 0;
        ln_pagdia     := 0;      
        ln_pordia     := 0;        
        
      end if;
       --METAS 
        begin
          pq_cr_productividad_nueva.sp_cr_metas_new(pn_codcat => ln_codcat,
                                                    pc_tipase => lc_tipoase,
                                                    pc_tipona => NVL(lc_tipana, 'C'),
                                                    pn_cresal => ln_cresal,
                                                    pn_crecli => ln_crecli,
                                                    pn_valse1 => ln_valse1,
                                                    pn_valse2 => ln_valse2,
                                                    pn_valce1 => ln_valce1,
                                                    pn_valce2 => ln_valce2);
        end;  
    
      --METAS      
     /* begin
        PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_metas(pn_codcat => ln_codcat,
                                             pc_tipase => lc_tipoase,
                                             pn_cresal => ln_cresal,
                                             pn_crecli => ln_crecli,
                                             pn_mincom => ln_mincom);
      end;
    */
      ln_Por_Mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_nueva_mora(i.jaql600usu,
                                                               pd_fecpro,
                                                               i.jaql600age,
                                                               i.jaql600sdm,
                                                               i.jaql600sdju,
                                                               i.jaql600sdo);
    
    
--      pn_porpago => ln_porpago,
--     pn_bonpago => ln_bonpago,
--     pn_saldotot => ln_saldodesT)
    
      update JAQL600 j
         set JAQL600CRSA = ln_crecimiento_sal,
             JAQL600CRCL = ln_crecimiento_cli,
             JAQL600PORD = ln_porcentaje,
             JAQL600MTOD = ln_saldodesT,
             JAQL600IDES = ln_saldodes,
             JAQL600PDES = ln_porpago,
             JAQL600MTSA = ln_cresal, --ln_mtosal,
             JAQL600MTCL = ln_crecli, --ln_mtocli,
             JAQL600NMES = ln_meses,
             --JAQL600MTRE = ln_mincom, --ln_mtoret
             JAQL600PMRA = ln_Por_Mora,
             jaql600tant = lc_tipana ,
             jaql600pexs1 = ln_valse1,
             jaql600pexs2 = ln_valse2,
             jaql600pexc1 = ln_valce1,
             jaql600pexc2 = ln_valce2,
             jaql600bomi  = ln_bonpago,
             jaql600sdacu  = nvl(ln_saldoacu,0),
             jaql600fecin = ld_fecingreso,
             jaql600ndoc  = lc_numdoc,
             jaql600pordi = ln_pordia,
             jaql600pagdi = ln_pagdia
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu = i.jaql600usu;
    
       commit;  
    end loop;
  
    commit;
  
  end sp_cr_indicadores_new;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_cumplimiento(pd_fecpro   in date,
                               pc_analista in varchar2,
                               pc_codage   in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cumplimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 2017.07.13
    -- Descripción de Modificación: Se agrego condicion solo califica para contencion si tipo es PYMES - P
    --                              2023.11.13 dcastro se modificó condición para contencion  
    --                              2023.12.05 dcastro no aplica contencion si es nuevo y menor o igual a 6 meses
    --                              2024.02.16 dcastro se agrego condición si la base contencion1 = 0 el pago de contencion1 es igual a 0
    -- *****************************************************************
  
    cursor analistas(lc_analista char) is
      select *
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600usu like '%' || lc_analista || '%'
         and j.jaql600age = pc_codage;
    --and j.jaql600usu in ('JDIAZC','RFLORES','OCRUZP' );
  
    ln_codcat          number;
    ln_saldo           number;
    ln_numcli          number;
    ln_salant          number;
    ln_cliant          number;
    ln_crecimiento_sal number;
    ln_crecimiento_cli number;
    ln_saldodes        number;
    ln_porpago         number;
    ln_porcentaje      number;
    lc_indicador       char(1);
    lc_tipoase         char(1);
    ln_metsal          number;
    ln_metcli          number;
    ln_metret          number;
    ln_metmor          number;
  
    ln_mtosal       number;
    ln_mtocli       number;
    ln_mtoret       number;
    ln_pagsal       number;
    ln_salexcedente number;
    ln_pagsal_adi   number;
    ln_pagsal_tot   number;
    ln_pagcli       number;
    ln_cliexcedente number;
    ln_pagcli_adi   number;
    ln_pagcli_tot   number;
  
    ln_exccli    number;
    ln_excsal    number;
    ln_porcum    number;
    ln_porcumsal number;
    ln_porcumcli number;
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_totalpagovariable number;
    ln_subpagovariable   number;
    ln_retexcedente      number;
    ln_pagret            number;
    ln_pagret_adi        number;
    ln_pagret_tot        number;
    ln_excret            number;
    ln_numret            number;
  
    ln_pagmora number;
    ln_TOTAL   number;
  
    ln_pagocontencion number;
    ln_basecon        number;
    ln_porcontencion  number;
    ln_codcam         number;
  
    lc_analista varchar2(10) := null;
    ld_fechacon date;
  
    ln_baseret      number;
    ln_retenidos    number;
    ln_porretencion number;
  
    ln_INDMORA number;
    ln_facmor  number;
    ln_pormoa  number;
  
    ln_cascontinuidad number;
    lc_cartera_rec    char(1);
    lc_excluir_cont   char(1);
    ln_nummes         number;
  
    ln_salmorT number;
    ln_pormorT number;
  
    ln_contenidos number;
    --nueva productividad 2023
    ln_nivexc number; 
    ln_valce1 number;
    ln_valce2 number;
    ln_pagsol_mic number;
    ln_pagocontencion1 number;
    ln_porcontencion1 number;
    ln_basecon1 number;
    ln_pagocontencion2 number;
    ln_porcontencion2 number;
    ln_basecon2 number;
    ln_totcontencion number;
    ln_base1  number;
    ln_reten1 number;
    ln_porcen1 number;
    ln_base2 number;
    ln_reten2 number;
    ln_porcen2 number;
    
    ln_conteni1 number;
    ln_conteni2 number;    
 
    ln_pagdia number;    
    ln_topebono number;   
    ln_pago_carterab number;   
    ln_pago_cartera number;   
    ln_porcon1 number;    
    ln_porcon2 number;   
    
     
  begin
  
    if pc_analista is null then
      lc_analista := '%';
    else
      lc_analista :=TRIM( pc_analista);
    end if;
  
    for i in analistas(lc_analista) loop
    
      --      i.jaql600usu
    
      ln_metsal := i.jaql600mtsa;
      ln_metcli := i.jaql600mtcl;
      ln_metret := i.jaql600mtre;
      ln_metmor := i.jaql600mtmr;
    
      ln_cresal  := i.jaql600crsa;
      ln_crecli  := i.jaql600crcl;
      ln_codcat  := i.jaql600codcat;
      lc_tipoase := i.jaql600tase;
    
      ln_pagdia  := i.jaql600pagdi;
      
      
      if ln_metsal = 0 or ln_metcli = 0 then
        ln_pagsal_tot := 0;
        ln_pagcli_tot := 0;
      else
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_pago_metas_new(pn_codcat => ln_codcat,
                                                    pc_tipase => lc_tipoase,
                                                    pc_tipona => nvl(i.jaql600tant,'C'),
                                                    pn_mtosal => ln_mtosal,
                                                    pn_mtocli => ln_mtocli,
                                                    pn_mtoret => ln_mtoret);
        end;
      
        --obtiene tope bono      
          begin
            select (TP1NRO1 * TP1NRO2 / 100)
              into ln_topebono
              from fst198 f
             where f.tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 30
               and tp1nro3 = ln_codcat;
          exception
            when others then
              ln_topebono := 0;
          end;
         --    
      
        --valida crecimiento cartera
        if ln_cresal >= ln_metsal then
          --ln_pagsal := ln_mtosal * i.JAQL600PDES/100;
          ln_pagsal := ln_mtosal;
        
          --crecimiento supera el 100%
          ln_porcumsal := round((ln_cresal * 100) / ln_metsal, 2);
          if lc_tipoase = 'P' then
          --PYMES retorna nivel de excedente 1 hasta 200, 2 mayor a 200
          ln_nivexc := pq_cr_productividad_nueva.fn_cr_nivel_excedente(pn_porcentaje => ln_porcumsal,
                                                             pn_tipo => 1);
          elsif lc_tipoase = 'C' then
          --CONSUMO retorna nivel de excedente 1 hasta 200, 2 mayor a 200
           ln_nivexc := pq_cr_productividad_nueva.fn_cr_nivel_excedente(pn_porcentaje => ln_porcumsal,
                                                   pn_tipo => 3);

          end if;
                                                                                 
           IF  ln_nivexc = 1 THEN ln_excsal := i.jaql600pexs1; END IF;
           IF  ln_nivexc = 2 THEN ln_excsal := i.jaql600pexs2; END IF;
           
           ln_excsal := nvl(ln_excsal,0); -- 2023.11.13
           
           --2023 OBTENER EXCEDENTE SALDO
          
                                                   
          if ln_porcumsal > 100 then
          
            --aplicar porcentaje al excedente
            ln_salexcedente := ln_cresal - ln_metsal;
            ln_pagsal_adi   := round(ln_salexcedente * ln_excsal / 100, 2);
          else
            ln_pagsal_adi   := 0;
            ln_salexcedente := 0;
          end if;
        
          --pago total saldo 
          --ln_pagsal_tot :=  ln_pagsal + ln_pagsal_adi;  
          ln_pagsal_tot := 0;          
          if lc_tipoase = 'P' then
              
              ln_pagsol_mic := nvl( i.jaql600bomi,0); --PAGO POR DESEMBOLSO MICRO
              
              ln_pago_carterab := ln_pagsal + ln_pagsal_adi;
              if ln_pago_carterab > ln_topebono then
                 ln_pago_cartera := ln_topebono;
              else
                 ln_pago_cartera := ln_pago_carterab;  
              end if;
              
              ln_pagsal_tot :=  ln_pagsal_tot + ln_pago_cartera + ln_pagsol_mic ; 
          else
            --si es consumo no se aplica %desembolso
            ln_pagsal_tot := round((ln_pagsal + ln_pagsal_adi), 2);
          end if;
        
        else
          ln_pagsal_tot   := 0;
          ln_pagsal       := 0;
          ln_pagsal_adi   := 0;
          ln_porcumsal    := 0;
          ln_salexcedente := 0;
          ---ACTUALIZAR BONO MICRO = 0
          ln_pagsol_mic      := 0;

        
        end if;
      
        --valida crecimiento clientes
        if ln_crecli >= ln_metcli then
          ln_pagcli := ln_mtocli;
        
          --crecimiento supera el 100%
          ln_porcumcli := round((ln_crecli * 100) / ln_metcli, 2);
          if ln_porcumcli > 100 then
          
            --aplicar porcentaje al excedente
            ln_cliexcedente := ln_crecli - ln_metcli;
            
          if lc_tipoase = 'P' then
            --PYMES retorna nivel de excedente 1 hasta 200, 2 mayor a 200
            ln_nivexc := pq_cr_productividad_nueva.fn_cr_nivel_excedente(pn_porcentaje => ln_porcumcli,
                                                             pn_tipo => 3);
          elsif lc_tipoase = 'C' then
            --CONSUMO retorna nivel de excedente 1 hasta 150, 2 mayor a 150
            ln_nivexc := pq_cr_productividad_nueva.fn_cr_nivel_excedente(pn_porcentaje => ln_porcumcli,
                                                             pn_tipo => 4);
          end if;

             --2023 OBTENER EXCEDENTE CLIENTES                                                
           IF ln_nivexc  = 1 THEN ln_exccli := I.jaql600pexc1; END IF;
           IF ln_nivexc  = 2 THEN ln_exccli := I.jaql600pexc2; END IF;
           
            ln_pagcli_adi   := round(ln_cliexcedente * ln_exccli, 2);
          else
            ln_pagcli_adi   := 0;
            ln_cliexcedente := 0;
          
          end if;
        
          --pago total clientes
          ln_pagcli_tot := ln_pagcli + ln_pagcli_adi;
        
        else
          ln_pagcli_tot   := 0;
          ln_pagcli       := 0;
          ln_pagcli_adi   := 0;
          ln_porcumcli    := 0;
          ln_cliexcedente := 0;
        
          ln_totalpagovariable := 0;
        
        end if;

        --SI TIENE CRECIMIENTO EN CLIENTE NO ES NECESARIO QUE SUPERE LA META se paga en retencion
        if ln_crecli > 0 then
        
          --SI TIENE CRECIMIENTO PUEDE COMISIONAR POR RETENCION
          --obtiene valor RETENCION
          ---
          begin
            pq_cr_productividad_nueva.sp_cr_retencion(pd_fecpro => pd_fecpro,
                                                      pc_analista => i.jaql600usu,
                                                      pc_codage => i.jaql600age,
                                                      pc_codcat => ln_codcat,
                                                      pc_tipo => lc_tipoase,
                                                      pn_pagotot => ln_pagret_tot,
                                                      pn_pagoret => ln_pagret,
                                                      pn_pagoadi => ln_pagret_adi,
                                                      pn_base1   => ln_base1,
                                                      pn_reten1  => ln_reten1,
                                                      pn_porcen1 => ln_porcen1,
                                                      pn_base2   => ln_base2,
                                                      pn_reten2  => ln_reten2,
                                                      pn_porcen2 => ln_porcen2
                                                      );
          end;
  
        else
          ln_retexcedente := 0;
          ln_pagret       := 0;
          ln_pagret_adi   := 0;
          ln_pagret_tot   := 0;
          ln_retenidos    := 0;
          ln_porretencion := 0;
          ln_baseret      := 0;
          ln_excret       := 0;
          ln_base1        := 0;
          ln_reten1       := 0;
          ln_porcen1      := 0;
          ln_base2        := 0;
          ln_reten2       := 0;
          ln_porcen2      := 0;
          
        end if;
  
        ln_subpagovariable := ln_pagsal_tot + ln_pagcli_tot + ln_pagret_tot + ln_pagdia; --mas cartera por pago cartera al dia
      
        ---obtiene MORA
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_variacion_mora(pc_analista => i.jaql600usu,
                                                        pd_fecpro   => pd_fecpro,
                                                        pc_tipase   => lc_tipoase,
                                                        pn_pormor   => i.jaql600pmra,
                                                        pn_pormoa   => ln_pormoa,
                                                        pn_varmor   => ln_varmor);
        end;
      
        ---
        /* 2023.08.23 dcastro se comento por nueva productividad
        begin
          ln_mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_metamora(pc_tipase => lc_tipoase,
                                                             pn_pormor => ln_pormoa, --i.jaql600pmra,
                                                             pn_varmor => ln_varmor);
          --se envia la mora del mes anterior
        end;*/

      begin
        pq_cr_productividad_nueva.sp_cr_metamora_new(pc_tipase => lc_tipoase,
                                                     pn_varmor => ln_varmor,
                                                     pn_pormor => ln_pormoa,--i.jaql600pmra,
                                                     pn_facmor => ln_mora,
                                                     pn_mtomor => ln_pagmora);
      end;


        
      if ln_pagmora = 0 AND LN_VARMOR > 0 then --SI FACTOR DE MORA >0 DEBE APLICAR PAGO, SI FACTOR Y VARIACION MORA SON 0 NO APLICA CASTIGO
        ln_pagmora := round(ln_subpagovariable * (ln_mora - 100) / 100, 2);
      end if;

        --si ES NUEVO Y tiene menor o igual a 6 meses de antiguedad NO SE LE PREMIA (MORA MAYOR A 8, CONTENCION 0-30, >30)
        if I.JAQL600TANT = 'N' AND i.JAQL600NMES <= 6 and ln_pagmora > 0 then
          ln_pagmora := 0; --no se premia
        end if;

      
       /* --aplica %mora a 
        if ln_mora = 100 then
          ln_pagmora := 0;
        else
          ln_pagmora := round(ln_subpagovariable * (ln_mora - 100) / 100, 2);
        end if;
      */
      
      /* 2023.09.27 se comento porque no aplica para nueva productividad 
        --2017.10.04
        if i.jaql600srec > 0 then
          --si tuvo cartera recibida en el mes excluir de descuento por MORA
          if ln_pagmora < 0 then
            ln_pagmora := 0;
          end if;
        end if;
        ---2017.10.04
      
      2023.09.27 */
      
        ln_pagdia := nvl(ln_pagdia,0);
        ln_totalpagovariable := ln_subpagovariable + ln_pagmora ;
      
       /* lc_cartera_rec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_cartera_recibida(i.jaql600usu,
                                                                          pd_fecpro);
      
     */
        --OBTIENE CONTENCION
        ln_TOTAL          := 0;
        ln_pagocontencion := 0;
        ln_codcam         := 1; --contencion
      
        --si tienes menor o igual a 6 meses de antiguedad NO SE LE PREMIA (MORA MAYOR A 8, CONTENCION 0-30, >30)
        if (i.JAQL600NMES <= 6 and nvl(ln_pagmora,0) > 0 AND I.JAQL600TANT = 'N')
          or   
           (i.JAQL600NMES <= 6 and I.JAQL600TANT = 'N') -- 2023.12.05 no aplica contencion si es nuevo y menor o igual a 6 meses
         then -- Y ES NUEVO
                --no se le premia       
            ln_basecon1        := 0;
            ln_porcontencion1  := 0;
            ln_pagocontencion1 := 0;
            ln_basecon2        := 0;
            ln_porcontencion2  := 0;
            ln_pagocontencion2 := 0;
            ln_codcam         := 0;
            ln_contenidos     := 0;
        
        else
            if lc_tipoase = 'P' then
      
              begin
                  pq_cr_productividad_nueva.sp_cr_contencion(pd_fecpro =>  pd_fecpro,
                                                             pc_analista => i.jaql600usu,
                                                             pc_codage => i.jaql600age,
                                                             pn_pago1 => ln_pagocontencion1,
                                                             pn_factor1 => ln_porcontencion1,
                                                             pn_basecon1 => ln_basecon1,
                                                             pn_conteni1 => ln_conteni1,                                                             
                                                             pn_pago2 => ln_pagocontencion2,
                                                             pn_factor2 => ln_porcontencion2,
                                                             pn_basecon2 => ln_basecon2,
                                                             pn_conteni2 => ln_conteni2,
                                                             pn_porcon1  => ln_porcon1,                        
                                                             pn_porcon2  => ln_porcon2
                                                             );
                                                             
              end;
              
              --ln_totcontencion := ln_totalpagovariable;
              if ln_porcontencion1 > 0 AND ln_pagocontencion1 = 0 then
                --20223.11.11 ln_pagocontencion1 := ln_totalpagovariable * ln_porcontencion1/100 * -1;
                
                --2023.11.13 ln_porcontencion1 factor obtenido de matriz
                if ln_porcontencion1 <= 90 then
                  ln_pagocontencion1 :=  ln_totalpagovariable * (( 100 -  ln_porcontencion1)/100)*-1 ;
                else
                  ln_pagocontencion1 :=  ln_totalpagovariable *  ln_porcontencion1/100 ;
               end if;   
              --2023.11.13  REVISAR Y MODIFICACION PAGOS CONTENCION2 , MODIFICAR GUIA PARA 18 MESES
              
              end if;  
              /* 2023.11.13
              if ln_porcontencion2 > 0 AND ln_pagocontencion2 = 0 then
                ln_pagocontencion2 := (ln_totalpagovariable + nvl(ln_pagocontencion1,0)) * ln_porcontencion2/100 * -1;
              end if;*/
              
              --2024.02.16 dcastro se agrego condición si la base contencion1 = 0 el pago de contencion1 es igual a 0
              IF ln_basecon1 = 0 THEN   --si la base de contencion es 0 no se aplica bono por contencion
                ln_pagocontencion1 := 0;
              end if;
              --2024.02.16 dcastro 
              
              if ln_porcontencion2 > 0 AND ln_pagocontencion2 = 0 then
                --2023.11.13 ln_porcontencion1 factor obtenido de matriz
                --ln_pagocontencion2 := (ln_totalpagovariable + nvl(ln_pagocontencion1,0)) * ln_porcontencion2/100 * -1;
                if ln_porcontencion2 <= 90 then  --2023.11.13 ln_porcontencion2 factor obtenido de matriz
                  ln_pagocontencion2 :=  (ln_totalpagovariable + nvl(ln_pagocontencion1,0)) * (( 100 -  ln_porcontencion2)/100)*-1 ;
                else
                  ln_pagocontencion2 :=  ln_totalpagovariable *  ln_porcontencion2/100 ;
               end if;
              
              end if;              
              
              /*2024.02.16 se comento
               IF ln_basecon1 = 0 THEN   --si la base de contencion es 0 no se aplica bono por contencion
                ln_pagocontencion1 := 0;
              end if;
              */
               IF ln_basecon2 = 0 THEN   --si la base de contencion es 0 no se aplica bono por contencion
                ln_pagocontencion2 := 0;
              end if;
            else
            --SI es CONVENIO no APLICA CONTENCION 2017.07.13
            ln_basecon1        := 0;
            ln_porcontencion1  := 0;
            ln_pagocontencion1 := 0;
            ln_basecon2        := 0;
            ln_porcontencion2  := 0;
            ln_pagocontencion2 := 0;
            ln_codcam         := 0;
            ln_contenidos     := 0;
            
             end if;
               
        end if; ---fin valida antiguedad de analistas
      
        /*NOTA*/
        ---APLICAR PORCENTAJE DE CASTIGO A 
        --TOTAL DE PAGO POR CARTERA, CLIENTES Y RETENCION
        ln_TOTAL := ln_totalpagovariable + nvl(ln_pagocontencion1, 0) + nvl(ln_pagocontencion2, 0) ;
      
        update JAQL600 j
           set JAQL600PSAL  = ln_pagsal_tot,
               JAQL600PCLI  = ln_pagcli_tot,
               JAQL600CSAL  = ln_pagsal,
               JAQL600ESAL  = ln_pagsal_adi,
               JAQL600CCLI  = ln_pagcli,
               JAQL600ECLI  = ln_pagcli_adi,
               JAQL600VMOR  = ln_varmor,
               JAQL600PMOR  = ln_pagmora,
               JAQL600POSA  = ln_porcumsal,
               JAQL600POCL  = ln_porcumcli,
               JAQL600EXSA  = ln_salexcedente,
               JAQL600EXCL  = ln_cliexcedente,
               JAQL600EXRE  = ln_retexcedente,
               JAQL600PRET  = ln_pagret_tot,
               JAQL600CRET  = ln_pagret,
               JAQL600ERET  = ln_pagret_adi,
               JAQL600CCAM  = ln_codcam,
               JAQL600VCAM  = ln_basecon,
               JAQL600TCAM  = ln_pagocontencion1 + ln_pagocontencion2,
               JAQL600PCAM  = ln_porcontencion1 + ln_porcontencion2,
               JAQL600AUX1  = ln_contenidos,
               JAQL600MTMR  = ln_mora,
               JAQL600PJCA  = ln_incmor,
               JAQL600PJCAS = ln_pjcas,
               JAQL600PVAR  = ln_totalpagovariable,
               JAQL600BARE  = ln_base1,--ln_baseret,
               JAQL600MORE  = ln_reten1,--ln_retenidos,
               JAQL600PORE  = ln_porcen1,--ln_porretencion,
               JAQL600PMOA  = ln_pormoa,
               JAQL600CMRA  = ln_cascontinuidad,
               JAQL600INCO  = lc_excluir_cont,
               jaql600baco1 = ln_basecon1,
               jaql600poco1 = ln_porcontencion1,
               jaql600paco1 = ln_pagocontencion1,
               JAQL600mtco1 = ln_conteni1,
               JAQL600mtco2 = ln_conteni2,               
               jaql600baco2 = ln_basecon2,
               jaql600poco2 = ln_porcontencion2,
               jaql600paco2 = ln_pagocontencion2,
               JAQL600BARE2 = ln_base2,
               JAQL600MORE2 = ln_reten2,
               JAQL600PORE2 = ln_porcen2,
               JAQL600AUX2  = ln_pago_carterab, --total ln_pagsal+ln_pagsal_adi
               JAQL600AUX3  = ln_topebono, --tope cartera
               JAQL600AUX4  = ln_pago_cartera, --total cartera incluye tope              
               JAQL600TOTPA = ln_TOTAL, -- + CONTENCION
               JAQL600AUX5	= ln_porcon1,
               JAQL600AUX6  = ln_porcon2,
               jaql600bomi  = ln_pagsol_mic --se agrego bono
          where j.jaql600fpro = pd_fecpro
           and j.jaql600usu = i.jaql600usu;
      
        --inicializa variables  
        ln_excsal       := 0;
        ln_pagsal       := 0;
        ln_pagsal_adi   := 0;
        ln_pagsal_tot   := 0;
        ln_salexcedente := 0;
        ln_cresal       := 0;
        ln_metsal       := 0;
      
        ln_exccli       := 0;
        ln_pagcli       := 0;
        ln_pagcli_adi   := 0;
        ln_pagcli_tot   := 0;
        ln_cliexcedente := 0;
        ln_crecli       := 0;
        ln_metcli       := 0;
        ln_porcum       := 0;
      
        ln_metsal := 0;
        ln_metcli := 0;
        ln_metret := 0;
        ln_metmor := 0;
      
        ln_retexcedente := 0;
        ln_pagret       := 0;
        ln_pagret_adi   := 0;
        ln_pagret_tot   := 0;
        ln_retenidos    := 0;
        ln_porretencion := 0;
        ln_baseret      := 0;
        ln_excret       := 0;
      
        ln_salmorT := 0;
        ln_pormorT := 0;
        ln_pagsal_tot   := 0;
        ln_pagsal       := 0;
        ln_pagsal_adi   := 0;
        ln_porcumsal    := 0;
        ln_salexcedente := 0;

        ln_basecon1        := 0;
        ln_porcontencion1  := 0;
        ln_pagocontencion1 := 0;
        ln_basecon2        := 0;
        ln_porcontencion2  := 0;
        ln_pagocontencion2 := 0;
        ln_codcam         := 0;
        ln_contenidos     := 0;
        
        ln_topebono      := 0;   
        ln_pago_carterab := 0;   
        ln_topebono      := 0; 
        ln_pago_cartera  := 0;
        
        ln_conteni1      := 0;
        ln_conteni2      := 0;
        
        ln_base2         := 0;
        ln_reten2        := 0;
        ln_porcen2       := 0;
        ln_base2         := 0;
        ln_reten2        := 0;
        ln_porcen2       := 0;
        commit;
      end if;
    end loop;
  
    commit;
  
  end sp_cr_cumplimiento;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_metas_new(pn_codcat in number,
                        pc_tipase in char,
                        pc_tipona in char,                        
                        pn_cresal out number,
                        pn_crecli out number,
                        pn_valse1 out number,
                        pn_valse2 out number,
                        pn_valce1 out number,
                        pn_valce2 out number
                        ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_metas_new
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.15
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE METAS POR CRECIMIENTO Y SALDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_cresal number;
    ln_mtosal number;
    ln_crecli number;
    ln_mtocli number;
    ln_mincom number;
    ln_mtoret number;
    ln_valse1 number;
    ln_valse2 number;
    ln_valce1 number;
    ln_valce2 number;                         

  begin
  
    begin
      select jaql596csal,
             jaql596msal,
             jaql596ccli,
             jaql596mcli,
             jaql596se1,
             jaql596se2,
             jaql596ce1,
             jaql596ce2    
        into ln_cresal,
             ln_mtosal,
             ln_crecli,
             ln_mtocli,
             ln_valse1,
             ln_valse2,
             ln_valce1,
             ln_valce2                          
        from jaql596 j
       where j.jaql596cat = pn_codcat
         and j.jaql596tip = pc_tipase
         and j.jaql596ant = pc_tipona
         and j.jaql596est = 'S';
    exception
      when others then
        ln_cresal := 0;
        ln_mtosal := 0;
        ln_crecli := 0;
        ln_mtocli := 0;
        ln_valse1 := 0;
        ln_valse2 := 0;
        ln_valce1 := 0;
        ln_valce2 := 0;                          

    end;
  
    pn_cresal := ln_cresal;
    pn_crecli := ln_crecli;
    pn_valse1 := ln_valse1;
    pn_valse2 := ln_valse2;
    pn_valce1 := ln_valce1;
    pn_valce2 := ln_valce2;                          

  
  end sp_cr_metas_new;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -------------------------------------------------------------------------------------------------
  Function fn_cr_nivel_excedente(PN_PORCENTAJE IN NUMBER,
                                 PN_TIPO IN NUMBER ) 
                                return number is
                                --2023.03.09 DCASTRO retorna nivel de excedente por saldos y clientes
    ln_nivel number(9) := 0;
  
  begin
  
        begin
          select tp1nro3
            into ln_nivel
            from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847
             and tp1corr1 = 13
             and tp1corr2 = PN_TIPO
             and tp1corr3 > 0  ---
             and PN_PORCENTAJE > tp1nro1  --
             and PN_PORCENTAJE <= tp1nro2; --
        exception when others then
           ln_nivel := 0;
        end;
  
    return ln_nivel;
    
  end fn_cr_nivel_excedente;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_pago_metas_new(pn_codcat in number,
                               pc_tipase in char,
                               pc_tipona in char,   
                               pn_mtosal out number,
                               pn_mtocli out number,
                               pn_mtoret out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_metas_new
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE METAS POR CRECIMIENTO Y SALDO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_cresal number;
    ln_mtosal number;
    ln_crecli number;
    ln_mtocli number;
    ln_mincom number;
    ln_mtoret number;
  
  begin
  
    begin
      select jaql596csal,
             jaql596msal,
             jaql596ccli,
             jaql596mcli,
             jaql596ret,
             jaql596mret
        into ln_cresal,
             ln_mtosal,
             ln_crecli,
             ln_mtocli,
             ln_mincom,
             ln_mtoret
        from jaql596 j
       where j.jaql596cat = pn_codcat
         and j.jaql596tip = pc_tipase
         and j.jaql596ant = pc_tipona
         and j.jaql596est = 'S';
    exception
      when others then
        ln_cresal := 0;
        ln_mtosal := 0;
        ln_crecli := 0;
        ln_mtocli := 0;
        ln_mincom := 0;
        ln_mtoret := 0;
    end;
  
    pn_mtosal := ln_mtosal;
    pn_mtocli := ln_mtocli;
    pn_mtoret := ln_mtoret;
  
  end sp_cr_pago_metas_new;   

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_retencion(pd_fecpro   in date,
                           pc_analista in varchar2,
                           pc_codage   in number,
                           pc_codcat   in number,
                           pc_tipo     in varchar2,
                           pn_pagotot  out number,                           
                           pn_pagoret  out number,
                           pn_pagoadi  out number,
                           pn_base1    out number,
                           pn_reten1   out number,
                           pn_porcen1  out number,
                           pn_base2    out number,
                           pn_reten2   out number,
                           pn_porcen2  out number
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_retencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023
    -- Autor de Creación          : 
    -- Uso                        : RETORNA VALORES DE RETENCION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_baseret1      number;
ln_retenidos1    number;
ln_porretencion1 number;
ln_baseret2      number;
ln_retenidos2    number;
ln_porretencion2 number;
ln_mtoret        number;
ln_metret        number;
ln_numret        number;
ln_excret        number;
ln_BONO          number;
ln_pagret_adi    number := 0;
ln_pagret        number := 0;
ln_retexcedente  number := 0;
ln_porcentaje    number := 0;

BEGIN
   
      --retencion
  begin
    select tp1nro1, tp1nro2
      into ln_numret, ln_excret
      from fst198 f
     where tp1cod = 1
       and tp1cod1 = 10847
       and tp1corr1 = 14
       and tp1corr2 = 1
       and tp1corr3 = 1;
  exception when others then
       ln_numret := 0;
       ln_excret := 0;
  end;



  begin  
/*      select j.jaqz451base, j.jaqz451ret,
                       case
                         when j.jaqz451base = 0 then  0
                         else
                          round(j.jaqz451ret * 100 / j.jaqz451base, 2)
                       end porcentaje
                  into ln_baseret1, ln_retenidos1, ln_porretencion1
                  from jaqz451 j
                 where j.jaqz451fpro = pd_fecpro
                   and j.jaqz451ana = trim(pc_analista) --lc_analista
                   and j.jaqz451age = pc_codage
                   and j.jaqz451dif = 1; -- retencion total
                   */
        select j.jaqz451ibase, j.jaqz451iret,
                       case
                         when j.jaqz451ibase = 0 then  0
                         else
                          round(j.jaqz451iret * 100 / j.jaqz451ibase, 2)
                       end porcentaje
                  into ln_baseret1, ln_retenidos1, ln_porretencion1
                  from jaqz451i j
                 where j.jaqz451ifpro = pd_fecpro
                   and j.jaqz451iana = trim(pc_analista) --lc_analista
                   and j.jaqz451iage = pc_codage
                   and j.jaqz451iind = 1; -- retencion total
                 
                   
  exception when others then
      ln_baseret1       := 0;
      ln_retenidos1     := 0;
      ln_porretencion1  := 0;              
  end;                      

  begin          
    select j.jaqz451ibase, j.jaqz451iret,
             case
                   when j.jaqz451ibase = 0 then  0
                   else
                    round(j.jaqz451iret * 100 / j.jaqz451ibase, 2)
                 end porcentaje
              into ln_baseret2, ln_retenidos2, ln_porretencion2
              from jaqz451i j
              where j.jaqz451ifpro = pd_fecpro
                 and j.jaqz451iana = trim(pc_analista) --lc_analista
                 and j.jaqz451iage = pc_codage
                 and j.jaqz451iind = 2; -- retencion CAV

  exception when others then
      ln_porretencion2 := 0;
      ln_baseret2      := 0;
      ln_retenidos2    := 0;
  end;

  IF  pc_tipo = 'C'     then -- INICIO PYMEs/CONVENIO
  
     begin
        select j.jaql596bbon, j.jaql596bmn0
          into ln_mtoret , ln_metret
          FROM JAQL596b j 
        where j.jaql596btip = pc_tipo 
        and j.JAQL596BCAT = pc_codcat 
        and ln_porretencion1 between j.jaql596bmn0 and  j.jaql596bmn1 
        and j.jaql596best = 'S';
    exception when others then
        ln_mtoret := 0;
     end;
        
     --excedente
     if ln_porretencion1 >= ln_metret then
              ln_pagret := ln_mtoret;
              
              ---si ln_porretencion1 > 100 cambiar porcentaje a 100
              if ln_porretencion1 > 100 then
                ln_porretencion1 := 100;
              end if;
              ---si ln_porretencion2 > 100 cambiar porcentaje a 100
              if ln_porretencion2 > 100 then
                ln_porretencion2 := 100;
              end if;      

                
              --aplicar porcentaje al excedente
              ln_retexcedente := ln_porretencion1 - ln_metret;
              if ln_retexcedente > 0 then
                ln_pagret_adi := round(ln_retexcedente * ln_excret, 2);
              else
                ln_pagret_adi := 0;
              end if;
      else
        ln_pagret       := 0;
        ln_pagret_adi   := 0;
        ln_retexcedente := 0;
      end if;
     
  ELSIF pc_tipo = 'P'   then -- INICIO PYMEs/CONVENIO
    
      ---si ln_porretencion1 > 100 cambiar porcentaje a 100
      if ln_porretencion1 > 100 then
        ln_porretencion1 := 100;
      end if;
      ---si ln_porretencion2 > 100 cambiar porcentaje a 100
      if ln_porretencion2 > 100 then
        ln_porretencion2 := 100;
      end if;      
  
      if ln_baseret1 >= ln_numret then  --si la base de retencion >=8 (guia)
         
        /*IF ln_porretencion2 <= 65 then
           ln_porcentaje := 64.99;
        else
           ln_porcentaje := 65;
        end if; 
        */ 
        ln_porcentaje := 64.99;
          
        ---retencion
        begin
          select JAQL596BBON
           into ln_mtoret 
           FROM JAQL596b j 
          where j.jaql596btip = 'P'  
          and j.JAQL596BCAT = pc_codcat 
          and jaql596bcav = ln_porcentaje
          --and j.jaql596bmn0 > ln_porretencion1 
          and ln_porretencion1 > j.jaql596bmn0
          and ln_porretencion1 <= j.jaql596bmn1 
          and j.jaql596best = 'S';      
       exception when no_data_found then
               ln_mtoret := 0;               
       end;
                 
       ln_pagret := nvl(ln_mtoret,0);
       
       IF ln_porretencion2 > 65 then --si % CAV >65 bono se duplica.
          ln_pagret := ln_pagret * 2;
       end if;
                     
     end if;
     
   END IF;  -- fin TIPO PYMEs/CONVENIO     

   pn_pagotot := ln_pagret + ln_pagret_adi;   
   pn_pagoret := ln_pagret ;
   pn_pagoadi := ln_pagret_adi;
   pn_base1   := nvl(ln_baseret1,0);
   pn_reten1  := nvl(ln_retenidos1,0);
   pn_porcen1 := nvl(ln_porretencion1,0);              
   pn_base2   := nvl(ln_baseret2,0);
   pn_reten2  := nvl(ln_retenidos2,0);
   pn_porcen2 := nvl(ln_porretencion2,0);              

      
END sp_cr_retencion;

procedure sp_cr_metamora_new(pc_tipase in char,
                          pn_varmor in number,  
                          pn_pormor in number,
                          pn_facmor out number,
                          pn_mtomor out number) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_metamora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.03.01
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : RETORNA EL Porcentaje de MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL587CODANA
    -- Parámetros de Salida       : PORCENTAJE CASTIGO
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
  
    lc_indmor char(1);
    ln_int1   number;
    ln_int2   number;
    ln_int3   number;
    ln_int4   number;
    ln_int5   number;
    ln_int6   number;
    ln_int7   number;
    ln_int8   number;
    ln_int9   number;
    ln_int10  number;
    ln_facmor number;
    ln_varmin number;
    ln_varmax number;
  
  begin
    lc_indmor := 'N';
  /*
    begin
      select max(j.jaql597min), min(j.jaql597max)
        into ln_varmin, ln_varmax
        from jaql597 j
       where j.jaql597tip = pc_tipase
         and j.jaql597mor = lc_indmor--NUEVA MORA
         and j.jaql597min <= pn_pormor
         and pn_pormor <= j.jaql597max;
    exception
      when no_Data_found then
        ln_varmin := 0;
        ln_varmax := 0;
    end;
  */
    if pn_varmor > 0 then --si variacon es positiva
        begin
         select max(j.jaql597min),min( j.jaql597max) 
           into ln_varmin, ln_varmax
           from jaql597 j
          where j.jaql597tip = pc_tipase
            and j.jaql597mor = lc_indmor
            and j.jaql597min <= pn_varmor
            and pn_varmor <= j.jaql597max;
        exception when no_Data_found then
            ln_varmin := 0; 
            ln_varmax := 0; 
        end;
    else --si variacion es negativa
        begin
         select min(j.jaql597min),max( j.jaql597max) 
           into ln_varmin, ln_varmax
           from jaql597 j
          where j.jaql597tip = pc_tipase
            and j.jaql597mor = lc_indmor
            and j.jaql597min <=  pn_varmor
            and  j.jaql597max >= pn_varmor;
            
        exception when no_Data_found then
            ln_varmin := 0; 
            ln_varmax := 0; 
        end;
    
    end if;
  
    -- if ln_varmin > 0 then
    begin
      select j.jaql597i1,
             j.jaql597i2,
             j.jaql597i3,
             j.jaql597i4,
             j.jaql597i5,
             j.jaql597i6,
             j.jaql597i7,
             j.jaql597i8,
             j.jaql597i9,
             j.jaql597i10
        into ln_int1,
             ln_int2,
             ln_int3,
             ln_int4,
             ln_int5,
             ln_int6,
             ln_int7,
             ln_int8,
             ln_int9,
             ln_int10
        from jaql597 j
       where j.jaql597tip = pc_tipase
         and j.jaql597mor = lc_indmor
         and j.jaql597min = ln_varmin
         and j.jaql597max = ln_varmax;
    exception
      when no_Data_found then
        ln_int1  := 0;
        ln_int2  := 0;
        ln_int3  := 0;
        ln_int4  := 0;
        ln_int5  := 0;
        ln_int6  := 0;
        ln_int7  := 0;
        ln_int8  := 0;
        ln_int9  := 0;
        ln_int10 := 0;
    end;
  
    --end if;
  
    --si es pymes
    if pc_tipase = 'P' then
    
       if pn_varmor < 0 then -- si la variacion es negativa 
          pn_mtomor := ln_int7;
       else
            
          case
            when pn_pormor >= 0 and pn_pormor <= 3.50 then
              ln_facmor := ln_int1;
            when pn_pormor > 3.50 and pn_pormor <= 5.50 then
              ln_facmor := ln_int2;
            when pn_pormor > 5.50 and pn_pormor <= 7.50 then
              ln_facmor := ln_int3;
            when pn_pormor > 7.50 and pn_pormor <= 10 then
              ln_facmor := ln_int4;
            when pn_pormor > 10.00 and pn_pormor <= 12.5 then
              ln_facmor := ln_int5;
            when pn_pormor > 12.50 and pn_pormor <= 999 then
              ln_facmor := ln_int6;
            else
              ln_facmor := 0;
          end case;
        
        end if;
    
    else
      --para consumo
    
      case
        when pn_pormor >= 0 and pn_pormor <= 0.50 then
          ln_facmor := ln_int1;
        when pn_pormor > 0.50 and pn_pormor <= 1.50 then
          ln_facmor := ln_int2;
        when pn_pormor > 1.50 and pn_pormor <= 2.50 then
          ln_facmor := ln_int3;
        when pn_pormor > 2.50 and pn_pormor <= 3.50 then
          ln_facmor := ln_int4;
        when pn_pormor > 3.50 and pn_pormor <= 4.50 then
          ln_facmor := ln_int5;
        when pn_pormor > 4.50 then
          ln_facmor := ln_int6;
        else
          ln_facmor := 0;
       end case;
    
    end if;
    pn_facmor := nvl(ln_facmor, 0);
    pn_mtomor := nvl(pn_mtomor, 0);
  
end sp_cr_metamora_new;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_contencion(pd_fecpro   in date,
                           pc_analista in varchar2,
                           pc_codage   in number,
                           pn_pago1    out number,                           
                           pn_factor1  out number,
                           pn_basecon1 out number,
                           pn_conteni1 out number,
                           pn_pago2    out number,                           
                           pn_factor2  out number,
                           pn_basecon2 out number,
                           pn_conteni2 out number,
                           pn_porcon1  out number,                            
                           pn_porcon2  out number
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023
    -- Autor de Creación          : 
    -- Uso                        : RETORNA VALORES DE RETENCION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
ln_basecon1       number;
ln_contenidos1    number;
ln_porcon1        number;
ln_basecon2       number;
ln_contenidos2    number;
ln_porcon2        number;
ln_factor1        number;
ln_factor2       number;
ln_numret        number;
ln_excret        number;
ln_BONO          number;
ln_pagocon1      number := 0;
ln_pagocon2      number := 0;
ln_int1          number;
ln_int2          number; 
ln_int3          number;
ln_int4          number;

BEGIN

--CONTENCION  0 A 30   1  JAQZ452IND  JAQZ452

    begin
      select j.jaqz452bbase,
             j.jaqz452bcon,
             case
               when j.jaqz452bbase = 0 then
                0
               else
                round(j.jaqz452bcon * 100 / j.jaqz452bbase, 2)
             end porcentaje
        into ln_basecon1, ln_contenidos1, ln_porcon1
        from JAQZ452B j
       where j.jaqz452bfpro = pd_fecpro
         and j.jaqz452bana = TRIM( pc_analista) --lc_analista
         and j.jaqz452bage = pc_codage --2023.09.20
         and j.jaqz452bind = 1; --contencion 0-30
    exception
      when no_data_found then
        ln_basecon1       := 0;
        ln_porcon1        := 0;
        ln_contenidos1    := 0;
    end;

    begin
     select j.jaql598i1, j.jaql598i2, j.jaql598i3, j.jaql598i4
        into ln_int1, ln_int2, ln_int3, ln_int4
        from jaql598 j
       where ln_porcon1 >= jaql598min
         and ln_porcon1 < jaql598max
         and jaql598ind = 1;
    exception
      when no_Data_found then
        ln_int1 := 0;
        ln_int2 := 0;
        ln_int3 := 0;
        ln_int4 := 0;
    end;

    if  ln_porcon1 < 94 then
          ln_factor1 := ln_int1;
    else 
      case
        when ln_basecon1 >= 0 and ln_basecon1 <= 100000 then
          ln_pagocon1 := ln_int1;
        when ln_basecon1 > 100000 and ln_basecon1 <= 200000 then
          ln_pagocon1 := ln_int2;
        when ln_basecon1 > 200000 and ln_basecon1 <= 300000 then
          ln_pagocon1 := ln_int3;
        when ln_basecon1 > 300000 then
          ln_pagocon1 := ln_int4;
        else
          ln_pagocon1 := 0;
      end case;
      
    end if;           
    
--CONTENCION  31 A 60  2 JAQZ452IND  JAQZ452
   begin
      select j.jaqz452bbase,
             j.jaqz452bcon,
             case
               when j.jaqz452bbase = 0 then
                0
               else
                round(j.jaqz452bcon * 100 / j.jaqz452bbase, 2)
             end porcentaje
        into ln_basecon2, ln_contenidos2, ln_porcon2
        from JAQZ452B j
       where j.jaqz452bfpro = pd_fecpro
         and j.jaqz452bana = TRIM(pc_analista) --lc_analista
         and j.jaqz452bage = pc_codage
         and j.jaqz452bind = 2; --contencion >30
    exception
      when no_data_found then
        ln_basecon2       := 0;
        ln_porcon2        := 0;
        ln_contenidos2    := 0;

    end;

    begin
     select j.jaql598i1, j.jaql598i2, j.jaql598i3, j.jaql598i4
        into ln_int1, ln_int2, ln_int3, ln_int4
        from jaql598 j
       where ln_porcon2 >= jaql598min
         and ln_porcon2 < jaql598max
         and jaql598ind = 2;
    exception
      when no_Data_found then
        ln_int1 := 0;
        ln_int2 := 0;
        ln_int3 := 0;
        ln_int4 := 0;
    end;

    if  ln_porcon2 < 35 then
          ln_factor2 := ln_int1;
    else 
      case
        when ln_basecon2 >= 0 and ln_basecon2 <= 20000 then
          ln_pagocon2 := ln_int1;
        when ln_basecon2 > 20000 then
          ln_pagocon2 := ln_int2;
        else
          ln_pagocon2 := 0;
      end case;
      
    end if;           

     pn_pago1    :=  nvl(ln_pagocon1,0);                          
     pn_factor1  :=  nvl(ln_factor1,0);--ln_factor1,0);
     pn_basecon1 :=  nvl(ln_basecon1,0);
     pn_conteni1 :=  nvl(ln_contenidos1,0);     
     pn_pago2    :=  nvl(ln_pagocon2,0);                         
     pn_factor2  :=  nvl(ln_factor2,0);--ln_factor2,0);
     pn_basecon2 :=  nvl(ln_basecon2,0);   
     pn_conteni2 :=  nvl(ln_contenidos2,0);
     pn_porcon1  :=  nvl(ln_porcon1,0);
     pn_porcon2  :=  nvl(ln_porcon2,0);
          
END sp_cr_contencion;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_IAnalista(pd_fecpro   in date,
                           pc_codage in number
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_IAnalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023
    -- Autor de Creación          : 
    -- Uso                        : actualiza instancia analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

    cursor listado is
    select jaql965fech,jaql965emp, jaql965mod, jaql965suc, jaql965mda, jaql965pap,jaql965cta, jaql965oper,jaql965sbop, 
           jaql965top, jaql965inst, jaql965ase
    from jaql965 j where j.jaql965fech = PD_FECPRO;

    LN_RPTA NUMBER;
    LC_MOD NUMBER;
    LC_TOP NUMBER;
    lc_analista char(10);
    ln_instancia number;
  BEGIN
    for i in listado loop
      LN_RPTA := NULL;
        
      LC_MOD :=  i.jaql965mod;
      LC_TOP :=  i.jaql965top;
            
          IF LC_MOD = 116 THEN
            BEGIN
              SELECT /* +ALL_ROWS */ 
                     MAX(XW2.XWFPRCINS)
                INTO LN_RPTA
                FROM FSH012 H12,
                     FSR011 REL
                JOIN XWF700 XW2
                  ON XW2.XWFEMPRESA = REL.R2COD
                 AND XW2.XWFMODULO = REL.R2MOD
                 AND XW2.XWFSUCURSAL = REL.R2SUC
                 AND XW2.XWFMONEDA = REL.R2MDA
                 AND XW2.XWFPAPEL = REL.R2PAP
                 AND XW2.XWFCUENTA = REL.R2CTA
                 AND XW2.XWFOPERACION = REL.R2OPER
                 AND XW2.XWFSUBOPE = REL.R2SBOP
                 AND XW2.XWFTIPOPE = REL.R2TOPE
                 AND REL.RELCOD = 46
                 AND XW2.XWFCAR3 = '1'
                JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
               WHERE --H12.ROWID = PC_ROWID
                   H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                 and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                 and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                 and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                 and H12.BCFECH = i.jaql965fech
                 AND REL.R1COD = 1
                 AND REL.R1MOD = H12.BCMOD
                 AND REL.R1SUC = H12.BCSUC
                 AND REL.R1MDA = H12.BCMDA
                 AND REL.R1PAP = H12.BCPAP
                 AND REL.R1CTA = H12.BCCTA
                 AND REL.R1OPER = H12.BCOPER
                 AND REL.R1SBOP = H12.BCSBOP
                 AND REL.R1TOPE = H12.BCTOP;

                 --dbms_output.put_line('1 '||LN_RPTA);
                 
              IF LN_RPTA IS NULL THEN
                BEGIN
                  SELECT /* +ALL_ROWS */ 
                         MAX(XW2.XWFPRCINS)
                    INTO LN_RPTA
                    FROM FSH012 H12,
                         FSR011 REL
                    JOIN XWF700 XW2
                      ON XW2.XWFEMPRESA = REL.R2COD
                     AND XW2.XWFMODULO = REL.R2MOD
                     AND XW2.XWFSUCURSAL = REL.R2SUC
                     AND XW2.XWFMONEDA = REL.R2MDA
                     AND XW2.XWFPAPEL = REL.R2PAP
                     AND XW2.XWFCUENTA = REL.R2CTA
                     AND XW2.XWFOPERACION = REL.R2OPER
                     AND XW2.XWFSUBOPE = REL.R2SBOP
                     AND XW2.XWFTIPOPE = REL.R2TOPE
                     AND REL.RELCOD = 46
                    JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                   WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech
                     AND REL.R1COD = 1
                     AND REL.R1MOD = H12.BCMOD
                     AND REL.R1SUC = H12.BCSUC
                     AND REL.R1MDA = H12.BCMDA
                     AND REL.R1PAP = H12.BCPAP
                     AND REL.R1CTA = H12.BCCTA
                     AND REL.R1OPER = H12.BCOPER
                     AND REL.R1TOPE = H12.BCTOP;
                     --dbms_output.put_line('2 '||LN_RPTA);
                exception when others then
                               null;     
                END;
              END IF;
            END;
          ELSE
            BEGIN
              SELECT /* +ALL_ROWS */ 
                     MAX(XW2.XWFPRCINS)
                INTO LN_RPTA
                FROM FSH012 H12,
                     XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
               WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech                 
                 AND XW2.XWFEMPRESA = 1
                 AND XW2.XWFSUCURSAL = H12.BCSUC
                 AND XW2.XWFMODULO = H12.BCMOD
                 AND XW2.XWFMONEDA = H12.BCMDA
                 AND XW2.XWFPAPEL = H12.BCPAP
                 AND XW2.XWFCUENTA = H12.BCCTA
                 AND XW2.XWFOPERACION = H12.BCOPER
                 AND XW2.XWFSUBOPE = H12.BCSBOP
                 AND XW2.XWFTIPOPE = H12.BCTOP
                 AND XW2.XWFCAR3 = '1';
                 --dbms_output.put_line('3 '||LN_RPTA);             
            EXCEPTION
              WHEN OTHERS THEN
                IF LC_MOD IN (200, 33) OR LC_TOP = 550 THEN
                  BEGIN
                    SELECT /* +ALL_ROWS */ 
                           MAX(XW2.XWFPRCINS)
                      INTO LN_RPTA
                      FROM FSH012 H12,
                           XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                     WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech
                       AND XW2.XWFEMPRESA = 1
                       AND XW2.XWFSUCURSAL = H12.BCSUC
                       AND XW2.XWFMONEDA = H12.BCMDA
                       AND XW2.XWFPAPEL = H12.BCPAP
                       AND XW2.XWFCUENTA = H12.BCCTA
                       AND XW2.XWFOPERACION = H12.BCOPER;
                                       -- dbms_output.put_line('4 '||LN_RPTA);
                  exception when others then
                                 null;
                  END;
                ELSE
                  BEGIN
                    SELECT /* +ALL_ROWS */ 
                           MAX(XW2.XWFPRCINS)
                      INTO LN_RPTA
                      FROM FSH012 H12,
                           XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                     WHERE --H12.ROWID = PC_ROWID
                           H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                       and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                       and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                       and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                       and H12.BCFECH = i.jaql965fech  
                       AND XW2.XWFEMPRESA = 1
                       AND XW2.XWFSUCURSAL = H12.BCSUC
                       AND XW2.XWFMODULO = H12.BCMOD
                       AND XW2.XWFMONEDA = H12.BCMDA
                       AND XW2.XWFPAPEL = H12.BCPAP
                       AND XW2.XWFCUENTA = H12.BCCTA
                       AND XW2.XWFOPERACION = H12.BCOPER
                       AND XW2.XWFTIPOPE = H12.BCTOP
                       AND XW2.XWFCAR3 = '1';
                                        --dbms_output.put_line('5 '||LN_RPTA);
                  EXCEPTION
                    WHEN OTHERS THEN
                      BEGIN
                        SELECT/* +ALL_ROWS */ 
                               MAX(XW2.XWFPRCINS)
                          INTO LN_RPTA
                          FROM FSH012 H12,
                               XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
                         WHERE --H12.ROWID = PC_ROWID
                             H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                           and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                           and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                           and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                           and H12.BCFECH = i.jaql965fech
                           AND XW2.XWFEMPRESA = 1
                           AND XW2.XWFSUCURSAL = H12.BCSUC
                           AND XW2.XWFMODULO = H12.BCMOD
                           AND XW2.XWFMONEDA = H12.BCMDA
                           AND XW2.XWFPAPEL = H12.BCPAP
                           AND XW2.XWFCUENTA = H12.BCCTA
                           AND XW2.XWFOPERACION = H12.BCOPER
                           AND XW2.XWFTIPOPE = H12.BCTOP
                           AND XW2.XWFCAR3 = '1';
                                            --dbms_output.put_line('6 '||LN_RPTA);
                      END;
                  END;
                END IF;
            END;
           IF NVL(LN_RPTA, 0) = 0 AND LC_MOD IN (200, 33) THEN
             begin
              SELECT /* +ALL_ROWS */ 
                     MAX(XW2.XWFPRCINS)
                INTO LN_RPTA
                FROM FSH012 H12,
                     FSR011 REL
                JOIN XWF700 XW2
                  ON XW2.XWFEMPRESA = REL.R2COD
                 AND XW2.XWFMODULO = REL.R2MOD
                 AND XW2.XWFSUCURSAL = REL.R2SUC
                 AND XW2.XWFMONEDA = REL.R2MDA
                 AND XW2.XWFPAPEL = REL.R2PAP
                 AND XW2.XWFCUENTA = REL.R2CTA
                 AND XW2.XWFOPERACION = REL.R2OPER
                 AND XW2.XWFSUBOPE = REL.R2SBOP
                 AND XW2.XWFTIPOPE = REL.R2TOPE
                AND REL.RELCOD = 46
                 AND XW2.XWFCAR3 = '1'
                JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
               WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech
                 AND REL.R1COD = 1
                 AND REL.R1MOD = H12.BCMOD
                 AND REL.R1SUC = H12.BCSUC
                 AND REL.R1MDA = H12.BCMDA
                 AND REL.R1PAP = H12.BCPAP
                 AND REL.R1CTA = H12.BCCTA
                 AND REL.R1OPER = H12.BCOPER
                 AND REL.R1SBOP = H12.BCSBOP
                 AND REL.R1TOPE = H12.BCTOP;
             exception when others then
                null;     
             end;   
                                  --dbms_output.put_line('7 '||LN_RPTA);
            END IF;
         END IF;
          IF NVL(LN_RPTA, 0) = 0 THEN
            BEGIN
              SELECT /* +ALL_ROWS */ 
                     MAX(XW2.XWFPRCINS)
                INTO LN_RPTA
                FROM FSH012 H12,
                     XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS
               WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech
                 AND XW2.XWFEMPRESA = 1
                 AND XW2.XWFSUCURSAL = H12.BCSUC
                 AND XW2.XWFMONEDA = H12.BCMDA
                 AND XW2.XWFPAPEL = H12.BCPAP
                 AND XW2.XWFCUENTA = H12.BCCTA
                 AND XW2.XWFOPERACION = H12.BCOPER;
            exception when others then
                     null;     
                                 -- dbms_output.put_line('8 '||LN_RPTA);
            END;
          END IF;
          IF NVL(LN_RPTA, 0) = 0 THEN
            BEGIN
              SELECT /* +ALL_ROWS */ 
                     MAX(XW2.XWFPRCINS)
              INTO LN_RPTA
              FROM XWF700 XW2 JOIN SNG001 GG ON GG.SNG001INST = XW2.XWFPRCINS,
                   FSH012 H12
              WHERE --H12.ROWID = PC_ROWID
                       H12.bcemp = i.jaql965emp and H12.bcmod = i.jaql965mod and H12.BCSUC = i.jaql965suc 
                     and H12.BCMDA = i.jaql965mda  and H12.BCPAP = i.jaql965pap
                     and H12.BCCTA = i.jaql965cta  and H12.BCOPER = i.jaql965oper  
                     and H12.BCSBOP = i.jaql965sbop  and H12.BCTOP = i.jaql965top 
                     and H12.BCFECH = i.jaql965fech
                AND XW2.XWFEMPRESA = 1
                AND XW2.XWFMONEDA = H12.BCMDA
                AND XW2.XWFPAPEL = H12.BCPAP
                AND XW2.XWFCUENTA = H12.BCCTA
                AND XW2.XWFOPERACION = H12.BCOPER;
                                 --dbms_output.put_line('9 '||LN_RPTA);
           exception when others then
               null;
            
            END;
          END IF;
      --RETURN LN_RPTA;
    
       --si instancia es <> nula
       ln_instancia := LN_RPTA;
        if ln_instancia is not null then
           begin
             select sng001ase
                     into lc_analista
                     from sng001  --Cambiar la tabla para producción
                    where sng001inst =  ln_instancia;
           Exception when no_data_found then
                      lc_analista := null;
           end;
 
             begin
                 update jaql965 J
                    set jaql965inst = ln_instancia ,      
                        jaql965ase  = lc_analista,
                        jaql965ind  = 'A' --se actualizo analista e instancia
                       where j.JAQL965FECH = i.jaql965fech  
                         and JAQL965EMP = i.JAQL965EMP
                         and JAQL965MOD = i.JAQL965MOD
                         and JAQL965SUC = i.JAQL965SUC
                         and JAQL965MDA = i.JAQL965MDA 
                         and JAQL965PAP = i.JAQL965PAP 
                         and JAQL965CTA = i.JAQL965CTA
                         and JAQL965OPER = i.JAQL965OPER
                         and JAQL965SBOP = i.JAQL965SBOP
                         and JAQL965TOP  = i.JAQL965TOP
                         and jaql965inst <> ln_instancia;
                         COMMIT;
             exception when others then
                       null;
             end;
        
        end if;     
    end loop;
   

end sp_cr_IAnalista;

procedure sp_cr_sch_IAnalista(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini        number;
    lc_variable   varchar2(1000);
    ln_job        number := 0;
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;      
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
 
    ---carga diaria
    for i in sucursal loop
    
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_CS1';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_IAnalista( TO_DATE(''' ||
                     --  lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_CS1', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_IAnalista;

  procedure sp_cr_sch_indicadores_new(pd_fecpro in date) is
    --2023.03. DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
           null;  
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'PRODU_IND';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_indicadores_new( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),'''',' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
--          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Productividad_Cre');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception when others then --2024.09.09 dcastro se agrego excepcion
           null;
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('PRODU_IND', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_indicadores_new;
  -------------------------------------------------------------------------------------------------
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_numdoc(pc_analista IN char,
                         pc_numdoc out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_numdoc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.09.09
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve numdoc
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                              
    -- Parámetros de Salida       : pc_numdoc
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  lc_analista char(10);
  begin
  
    lc_analista :=  rpad(pc_analista, 10, ' ');  
    begin
      select j.jaqn002ndo
        into pc_numdoc
        from jaqn002 j
       where j.jaqn002usr = lc_analista;
    exception when others then
       pc_numdoc := null;  
    end;
  
  
end sp_cr_numdoc;
 -----------------------------------------------------------------------
procedure sp_cr_cumplimiento_senior_ini(pd_fecpro in date,
                                      pc_codage in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cumplimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor analista is
      select distinct j.jaql600comi
        from jaql600 j
       where j.jaql600fpro = pd_fecpro
         and j.jaql600age = pc_codage
         and j.jaql600comi is not null;
  
    cursor comite(lc_comite char) is
      select *
        from jaql600s
       where jaql600sfpro = pd_fecpro
         and jaql600susu like '%' || lc_comite || '%';
  
    ln_cresal number;
    ln_crecli number;
    ln_mincom number;
    ln_varmor number;
    ln_mora   number;
    ln_incmor number;
    ln_pjcas  number;
  
    ln_totalpagovariable number;
  
    lc_analista varchar2(10) := null;
    ld_fechacon date;
  
    ln_INDMORA number;
    ln_facmor  number;
    ln_pormoa  number;
  
    ln_cascontinuidad number;
  
    lc_comite varchar2(20) := null;
  
  begin
  
    begin
      select to_Date(tp1desc, 'YYYYMMDD')
        into ld_fechacon
        from fst198 f
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 16
         and tp1corr2 = 2;
    exception when others then
           null;     
    end;
  
    for i in analista loop
    
      for x in comite(i.jaql600comi) loop
      
        begin
        
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_pa_mora_comite(pc_comite => x.jaql600susu,
                                                     pd_fecpro => pd_fecpro);
        end;
      
        ln_INDMORA := 1;
      
        ln_cascontinuidad := 0;
      
        /*definir continuidad mora equipo*/
        if pd_fecpro >= ld_fechacon then
          begin
            ln_incmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_continuidad_mora_comite(pc_comite => x.jaql600susu,
                                                                                pd_fecpro => pd_fecpro);
          
          end;
        
          if ln_incmor > ln_INDMORA then
            -- si incrementa supera 1% en los 3 meses no se paga por incentivo variable (Cartera, Clientes y Retencion)
            ln_pjcas          := -100;
            ln_cascontinuidad := (1 /*ln_totalpagovariable*/
                                 * ln_pjcas / 100);
            --ln_totalpagovariable := ln_totalpagovariable + ln_cascontinuidad;
          else
            ln_pjcas          := 0;
            ln_cascontinuidad := 0;
          end if;
        else
          ln_incmor         := 0;
          ln_pjcas          := 0;
          ln_cascontinuidad := 0;
        end if;
      
      --
      
      --inicializa variables  
      
      end loop;
      commit;
    
    end loop;
  
  end sp_cr_cumplimiento_senior_ini; 

------------------------------------------------------------------------------                                                                                   
Function fn_cr_Sal_alDIA(pc_analista IN varchar2,
                        pd_fecpro   in date,
                        pn_codage   in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el saldo de la cartera al dia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saldo number := 0;
    ld_fecini date;
    ln_salcas number := 0;
    lc_analista char(10);
    
  begin
    lc_analista := rpad(trim(pc_analista),10,' ');
    
    begin
      select nvl(sum(c.Jaql965sdmn), 0) --, count(distinct bccta),sng095_201404asnu 
        into ln_saldo
        from JAQL965 c
       where c.jaql965fech = pd_fecpro
         and c.jaql965ase = lc_analista
         AND C.JAQL965SUC = pn_codage
         and c.jaql965mod not in ( 200,33)
         and c.jaql965datr = 0
         and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
         and (c.jaql965cta, c.jaql965oper, c.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j)
         and (c.jaql965cta, c.jaql965oper) not in
             (select bccta, bcoper from jaqz498); --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs       

    exception
      when no_data_found then
        ln_saldo := 0;
    end;
  
    return nvl(ln_saldo, 0);
  
  end fn_cr_Sal_alDIA;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_metas_cardia(pn_codcat in number,
                        pn_porcar in number,
                        pn_pagcar out number
                        ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_metas_cardia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.08.24
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE METAS CARTERA AL DIA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
  ln_pagcar number;

  begin
  
    begin
       select JAQL597I1
         into ln_pagcar
         from jaql597 j
        where j.JAQL597MOR = 'D'
          and j.jaql597i10 = pn_codcat --categoria
          and pn_porcar >  j.jaql597min 
          and pn_porcar <= j.jaql597max; --porcentaje
     exception
      when others then
        ln_pagcar := 0;
     end;
  
    pn_pagcar := ln_pagcar;
  
  end sp_cr_metas_cardia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
------------------------------------------------------------------------------                                                                                   
procedure sp_cr_TipoAnalista(pc_analista IN varchar2,
                            pd_fecpro   in date,
                            pn_codage   in number,
                            pn_sdotot   in number,
                            pn_porsdo   out number,
                            pc_tipoana  out char)  is
    -- *****************************************************************
    -- Nombre                     : fn_cr_TipoAnalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna tipo de analista si más del 70% es cartera de producto convenio
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saldo number := 0;
    ld_fecini date;
    ln_salcas number := 0;
    lc_analista char(10);
    lc_tipanalista char(1);
    ln_porcentaje number;
    
  begin
    lc_analista := rpad(trim(pc_analista),10,' ');
    
    begin
      select nvl(sum(c.Jaql965sdmn), 0) --, count(distinct bccta),sng095_201404asnu 
        into ln_saldo
        from JAQL965 c
       where c.jaql965fech = pd_fecpro
         and c.jaql965ase = lc_analista
         AND C.JAQL965SUC = pn_codage
         and c.jaql965mod = 107
         and (c.jaql965cta, c.jaql965oper, c.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j)
         and (c.jaql965cta, c.jaql965oper) not in
             (select bccta, bcoper from jaqz498); --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs       

    exception
      when no_data_found then
        ln_saldo := 0;
    end;
  
  
    if ln_saldo > 0 and pn_sdotot > 0 then
       ln_porcentaje := round(ln_saldo * 100 / pn_sdotot, 2);
    else
       ln_porcentaje := 0;  
    end if;
    
    if ln_porcentaje > 70 then
       lc_tipanalista := 'C';
    else
       lc_tipanalista := 'P';        
    end if;

    pn_porsdo   := ln_porcentaje;
    pc_tipoana  := lc_tipanalista;
    
  end sp_cr_TipoAnalista;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
------------------------------------------------------------------------------                                                                                   
procedure sp_cr_listaAnalista(pd_fecpro   in date
                             )  is
    -- *****************************************************************
    -- Nombre                     : sp_cr_listaAnalista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : carga data de analistas de vista ofiplan
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro: 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saldo number := 0;
    ld_fecini date;
    ln_salcas number := 0;
    lc_analista char(10);
    lc_tipanalista char(1);
    ln_porcentaje number;
    
  begin

    /*
 select * from datos_empl@ofiplan where "co_pues_trab" in 
(select lpad(TP1NRO1,10, '0') from fst198 where TP1COD = 1 and TP1COD1=10847 and TP1CORR1 = 32 and TP1NRO1 > 0)
  
  */
  null;
  --insertar en tabla jaqy830 por dia
    
  end sp_cr_listaAnalista; 
------------------------------------------------------------------

PROCEDURE SP_CR_OBTIENE_PRO_ANALISTAS (
                  USUARIO IN varchar2,
                  FECHAPROCESO IN DATE,
                  ESTADO IN varchar2,
                  PARAMETRO1 OUT VARCHAR2,
                  PARAMETRO2 OUT VARCHAR2,
                  PARAMETRO3 OUT VARCHAR2,
                  PARAMETRO4 OUT VARCHAR2,
                  PARAMETRO5 OUT VARCHAR2,
                  PARAMETRO6 OUT VARCHAR2,
                  PARAMETRO7 OUT VARCHAR2,
                  PARAMETRO8 OUT VARCHAR2,
                  PARAMETRO9 OUT VARCHAR2,
                  PARAMETRO10 OUT VARCHAR2,
                  PARAMETRO11 OUT VARCHAR2,
                  PARAMETRO12 OUT VARCHAR2,
                  PARAMETRO13 OUT VARCHAR2,
                  PARAMETRO14 OUT VARCHAR2,
                  PARAMETRO15 OUT VARCHAR2,
                  PARAMETRO16 OUT VARCHAR2,
                  PARAMETRO17 OUT VARCHAR2,
                  PARAMETRO18 OUT VARCHAR2,
                  PARAMETRO19 OUT VARCHAR2,
                  PARAMETRO20 OUT VARCHAR2,
                  PARAMETRO21 OUT VARCHAR2,
                  PARAMETRO22 OUT VARCHAR2,
                  PARAMETRO23 OUT VARCHAR2,
                  PARAMETRO24 OUT VARCHAR2,
                  PARAMETRO25 OUT VARCHAR2,
                  PARAMETRO26 OUT VARCHAR2,
                  PARAMETRO27 OUT VARCHAR2,
                  PARAMETRO28 OUT VARCHAR2,
                  PARAMETRO29 OUT VARCHAR2,
                  PARAMETRO30 OUT VARCHAR2)
AS
   -- *****************************************************************
    -- Nombre                     : SP_CR_OBTIENE_PRO_ANALISTAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.09.18
    -- Autor de Creación          : Milton Cordova - IGS
    -- Uso                        : OBTIENE CUMPLIMIENTO POR CARTERA, CLIENTES, RETENCION Y MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************



BEGIN
/*
01 - JAQL600PORCO - Porcentaje Cartera - convenio
02 - JAQL600TANT - Tipo Antiguedad A- Antiguo / N - Nuevo
03 - JAQL600BACO1 - Base contencion 0-30
04 - JAQL600POCO1 - Porcentaje contencion 0-30
05 - JAQL600PACO1 - Pago contencion 0-30
06 - JAQL600BACO2 - Base contencion Mayor-30
07 - JAQL600POCO2 - Porcentaje contencion Mayor-30
08 - JAQL600PACO2 - Pago contencion Mayor-30
09 - JAQL600NMES  - Numero de Meses de analista en agencia
10 - JAQL600PORDI - Porcentaje Cartera al dia - sin mora
11 - JAQL600PAGDI - Pago Cartera al dia - sin mora
12 - JAQL600PEXS1 SIN USO
13 - JAQL600PEXS2 SIN USO 
14 - JAQL600PDES
15 - JAQL600BOMI
16 - JAQL600POCL
17 - JAQL600AUX4
18 - JAQL600MTCO1
19 - JAQL600MTCO2
20 - JAQL600SPROC
21 - JAQL600SBACO 
22 - JAQL600SMTCO  
23 - JAQL600SPVAR
24 - JAQL600SDODI       
*/
   begin
      SELECT NVL(to_char(JAQL600PORCO), 'VACIO'),
             case
               when trim(JAQL600TANT) = 'N' then
                nvl('Nuevo', '')
               else
                'Antiguo'
             end,
             NVL(to_char(JAQL600BACO1), ''),
             NVL(to_char(JAQL600POCO1), ''),
             NVL(to_char(JAQL600PACO1), ''),
             NVL(to_char(JAQL600BACO2), ''),
             NVL(to_char(JAQL600POCO2), ''),
             NVL(to_char(JAQL600PACO2), ''),
             NVL(to_char(JAQL600NMES), ''),
             NVL(to_char(JAQL600PORDI), ''),
             NVL(to_char(JAQL600PAGDI), ''),
             NVL(to_char(JAQL600PEXS1), ''),
             NVL(to_char(JAQL600PEXS2), ''),
             NVL(to_char(JAQL600PDES), ''),
             NVL(to_char(JAQL600BOMI), ''),
             NVL(to_char(JAQL600POCL), ''),
             NVL(TO_CHAR(JAQL600AUX4), ''),
             NVL(TO_CHAR(JAQL600MTCO1), ''),
             NVL(TO_CHAR(JAQL600MTCO2), ''),
             NVL(TO_CHAR(JAQL600SDODI), '')

        INTO PARAMETRO1,
             PARAMETRO2,
             PARAMETRO3,
             PARAMETRO4,
             PARAMETRO5,
             PARAMETRO6,
             PARAMETRO7,
             PARAMETRO8,
             PARAMETRO9,
             PARAMETRO10,
             PARAMETRO11,
             PARAMETRO12,
             PARAMETRO13,
             PARAMETRO14,
             PARAMETRO15,
             PARAMETRO16,
             PARAMETRO17,
             PARAMETRO18,
             PARAMETRO19,
             PARAMETRO24
        FROM JAQL600
       WHERE JAQL600USU = RPAD(USUARIO, 20, ' ')
         AND JAQL600FPRO = FECHAPROCESO
         AND JAQL600EST = ESTADO;
    exception when others then     
         PARAMETRO1 := null;     
    end;     

    begin
      SELECT NVL(TO_CHAR(JAQL600SPROC), ''),
             NVL(TO_CHAR(JAQL600SBACO), ''),
             NVL(TO_CHAR(JAQL600SMTCO), ''),
             NVL(TO_CHAR(JAQL600SPVAR), '')
        INTO PARAMETRO20, PARAMETRO21, PARAMETRO22, PARAMETRO23
        FROM JAQL600S
       WHERE JAQL600SUSU = RPAD(USUARIO, 20, ' ')
         AND JAQL600SFPRO = FECHAPROCESO;
    exception when others then     
         PARAMETRO20 := null;     
    end;     

EXCEPTION
  WHEN OTHERS THEN NULL;
END SP_CR_OBTIENE_PRO_ANALISTAS;

----------------------------------------------------------------     

procedure sp_cr_job_recategoriza  is
    -- *****************************************************************
    -- Nombre                     : sp_cr_job_recategoriza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.13
    -- Autor de Creación          : DCASTRO
    -- Uso                        : job para ejecutar recategorizacion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro: 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  ld_fecha date := trunc(sysdate) - 1;
  lc_flag char(1);

BEGIN

  begin
      pq_cr_productividad_nueva.sp_cr_inserta_desembolsos_recategorizacion(pd_fecpro => ld_fecha);
  
  exception
    when others then
      null;
  end;

  begin
       pq_cr_recategorizacion.sp_generar_recate(pd_fpro     => ld_fecha,
                                                pn_analista => null,
                                                pn_flag     => lc_flag);
  exception
    when others then
      null;
  end;


end sp_cr_job_recategoriza;
----------------------------------------------------------------
Procedure sp_cr_inserta_cartera_finmes_I(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_cartera_finmes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA FIN DE MES A JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    TYPE tp_JAQL114FECH IS TABLE OF JAQL114.JAQL114FECH%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114EMP IS TABLE OF JAQL114.JAQL114EMP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114MOD IS TABLE OF JAQL114.JAQL114MOD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SUC IS TABLE OF JAQL114.JAQL114SUC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114MDA IS TABLE OF JAQL114.JAQL114MDA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PAP IS TABLE OF JAQL114.JAQL114PAP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114CTA IS TABLE OF JAQL114.JAQL114CTA%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114OPER IS TABLE OF JAQL114.JAQL114OPER%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SBOP IS TABLE OF JAQL114.JAQL114SBOP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TOP IS TABLE OF JAQL114.JAQL114TOP%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114INST IS TABLE OF JAQL114.JAQL114INST%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114ASE IS TABLE OF JAQL114.JAQL114ASE%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114RUBR IS TABLE OF JAQL114.JAQL114RUBR%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SDMN IS TABLE OF JAQL114.JAQL114SDMN%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SDMO IS TABLE OF JAQL114.JAQL114SDMO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114DATR IS TABLE OF JAQL114.JAQL114DATR%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114FVAL IS TABLE OF JAQL114.JAQL114FVAL%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114FVTO IS TABLE OF JAQL114.JAQL114FVTO%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PAIS IS TABLE OF JAQL114.JAQL114PAIS%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TDOC IS TABLE OF JAQL114.JAQL114TDOC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114NDOC IS TABLE OF JAQL114.JAQL114NDOC%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TCRD IS TABLE OF JAQL114.JAQL114TCRD%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114SECT IS TABLE OF JAQL114.JAQL114SECT%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114STAT IS TABLE OF JAQL114.JAQL114STAT%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114PROM IS TABLE OF JAQL114.JAQL114PROM%type INDEX BY PLS_INTEGER;
    TYPE tp_JAQL114TPCL IS TABLE OF JAQL114.JAQL114TPCL%type INDEX BY PLS_INTEGER;
  
    V_JAQL114FECH tp_JAQL114FECH;
    V_JAQL114EMP  tp_JAQL114EMP;
    V_JAQL114MOD  tp_JAQL114MOD;
    V_JAQL114SUC  tp_JAQL114SUC;
    V_JAQL114MDA  tp_JAQL114MDA;
    V_JAQL114PAP  tp_JAQL114PAP;
    V_JAQL114CTA  tp_JAQL114CTA;
    V_JAQL114OPER tp_JAQL114OPER;
    V_JAQL114SBOP tp_JAQL114SBOP;
    V_JAQL114TOP  tp_JAQL114TOP;
    V_JAQL114INST tp_JAQL114INST;
    V_JAQL114ASE  tp_JAQL114ASE;
    V_JAQL114RUBR tp_JAQL114RUBR;
    V_JAQL114SDMN tp_JAQL114SDMN;
    V_JAQL114SDMO tp_JAQL114SDMO;
    V_JAQL114DATR tp_JAQL114DATR;
    V_JAQL114FVAL tp_JAQL114FVAL;
    V_JAQL114FVTO tp_JAQL114FVTO;
    V_JAQL114PAIS tp_JAQL114PAIS;
    V_JAQL114TDOC tp_JAQL114TDOC;
    V_JAQL114NDOC tp_JAQL114NDOC;
    V_JAQL114TCRD tp_JAQL114TCRD;
    V_JAQL114SECT tp_JAQL114SECT;
    V_JAQL114STAT tp_JAQL114STAT;
    V_JAQL114PROM tp_JAQL114PROM;
    V_JAQL114TPCL tp_JAQL114TPCL;
  
    ln_numreg  number;
    ln_indins  number := 0;
    ln_saldore number;
    ln_saldove number;
  
  begin
  
    select count(*)
      into ln_numreg
      from JAQL114
     where JAQL114FECH = pd_fecpro; -- CONSIDERAR TODA LA CARTERA
    --and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);
  
    select JAQL114FECH,
           JAQL114EMP,
           JAQL114MOD,
           JAQL114SUC,
           JAQL114MDA,
           JAQL114PAP,
           JAQL114CTA,
           JAQL114OPER,
           JAQL114SBOP,
           JAQL114TOP,
           JAQL114INST,
           JAQL114ASE,
           JAQL114RUBR,
           JAQL114SDMN,
           JAQL114SDMO,
           JAQL114DATR,
           JAQL114FVAL,
           JAQL114FVTO,
           JAQL114PAIS,
           JAQL114TDOC,
           JAQL114NDOC,
           JAQL114TCRD,
           JAQL114SECT,
           JAQL114STAT,
           JAQL114PROM,
           JAQL114TPCL
      bulk collect
      into V_JAQL114FECH,
           V_JAQL114EMP,
           V_JAQL114MOD,
           V_JAQL114SUC,
           V_JAQL114MDA,
           V_JAQL114PAP,
           V_JAQL114CTA,
           V_JAQL114OPER,
           V_JAQL114SBOP,
           V_JAQL114TOP,
           V_JAQL114INST,
           V_JAQL114ASE,
           V_JAQL114RUBR,
           V_JAQL114SDMN,
           V_JAQL114SDMO,
           V_JAQL114DATR,
           V_JAQL114FVAL,
           V_JAQL114FVTO,
           V_JAQL114PAIS,
           V_JAQL114TDOC,
           V_JAQL114NDOC,
           V_JAQL114TCRD,
           V_JAQL114SECT,
           V_JAQL114STAT,
           V_JAQL114PROM,
           V_JAQL114TPCL
      from JAQL114
     where JAQL114FECH = pd_fecpro; -- CONSIDERAR TODA LA CARTERA
    --and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);
  
    --Elimina registros de historico del dia actual
    begin
      --insertar diario en historico
      FOR i IN 1 .. ln_numreg loop
        ln_saldore := 0;
        ln_saldove := 0;
      
        if V_JAQL114RUBR(i) is not null then
          if substr(V_JAQL114RUBR(i), 1, 4) in ('1414', '1424') AND
             V_JAQL114STAT(i) <> 33 then
            ln_saldore := V_JAQL114SDMN(i);
          elsif substr(V_JAQL114RUBR(i), 1, 4) in ('1415', '1425') then
            ln_saldove := V_JAQL114SDMN(i);
          else
            ln_saldore := 0;
            ln_saldove := 0;
          end if;
        end if;
      
        --IF  V_JAQL114MOD(i)= 33 or ( substr(V_JAQL114TCRD(i),1,11) <> 'CORPORATIVO' ) then  --CONSIDERAR CARTERA DIFERENTE DE CORPORATIVOS
        IF (V_JAQL114MOD(i) = 200 and V_JAQL114SDMN(i) = 0) or
           (V_JAQL114MOD(i) = 33 and V_JAQL114STAT(i) = 99) then
          --si credito es judicial y tiene capital 0 no considerar, castigado cancelado tampoco considerar
          null;
        else
          --insertar diario
          begin
            insert into JAQL965
              (JAQL965FECH,
               JAQL965EMP,
               JAQL965MOD,
               JAQL965SUC,
               JAQL965MDA,
               JAQL965PAP,
               JAQL965CTA,
               JAQL965OPER,
               JAQL965SBOP,
               JAQL965TOP,
               JAQL965INST,
               JAQL965ASE,
               JAQL965RUBR,
               JAQL965SDMN,
               JAQL965SDMO,
               JAQL965DATR,
               JAQL965FVAL,
               JAQL965FVTO,
               JAQL965PAIS,
               JAQL965TDOC,
               JAQL965NDOC,
               JAQL965TCRD,
               JAQL965SECT,
               JAQL965STAT,
               JAQL965PROM,
               JAQL965TPCL,
               JAQL965SDVE,
               JAQL965SDRE)
            VALUES
              (V_JAQL114FECH(i),
               V_JAQL114EMP(i),
               V_JAQL114MOD(i),
               V_JAQL114SUC(i),
               V_JAQL114MDA(i),
               V_JAQL114PAP(i),
               V_JAQL114CTA(i),
               V_JAQL114OPER(i),
               V_JAQL114SBOP(i),
               V_JAQL114TOP(i),
               V_JAQL114INST(i),
               V_JAQL114ASE(i),
               V_JAQL114RUBR(i),
               V_JAQL114SDMN(i),
               V_JAQL114SDMO(i),
               V_JAQL114DATR(i),
               V_JAQL114FVAL(i),
               V_JAQL114FVTO(i),
               V_JAQL114PAIS(i),
               V_JAQL114TDOC(i),
               V_JAQL114NDOC(i),
               V_JAQL114TCRD(i),
               V_JAQL114SECT(i),
               V_JAQL114STAT(i),
               V_JAQL114PROM(i),
               V_JAQL114TPCL(i),
               ln_saldove,
               ln_saldore);
          exception
            when no_data_found then
              null;
            
          end;
          ln_indins := ln_indins + 1;
          if ln_indins >= 5000 then
            ln_indins := 0;
            commit;
          end if;
        
          --END IF; --DIFERENTE COORPORATIVOS      
        END IF;
      end loop;
      commit;
    
    end;
  
    /*delete from SNG057_201X  where sng057fpro = pd_fecpro;
    
    INSERT INTO SNG057_201X  
     SELECT sng055emp, sng057usr, sng055car, sng057aut, sng057sup, sng057ini, sng057fin, sng057jef, 
     sng057wkf, sng057prc, sng057tsk, pd_fecpro FROM SNG057; 
    commit; */
  
  end sp_cr_inserta_cartera_finmes_I;  
----------------------------------------------------------------     
 ---------------------------------------------------------------------

  procedure sp_cr_job_cartera_mes(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lb_njobs      number(3);    
    lc_fecpro   char(10);
    lc_hostname varchar2(64);
    
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);   
    
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100); 
    x             number;   
    pn_usuario    varchar2(50); 

    cursor sucursal is
    select sucurs, scnom from fst001 where sucurs < 800;
    
  
  
  begin
    

    lc_paquete    := 'PQ_CR_PRODUCTIVIDAD_NUEVA';
    lc_proceso    := 'sp_cr_inserta_cartera_finmes';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);  
    
      
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then
            null;  
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --antes de la carga eliminar DATA
    delete from JAQL965 where JAQL965FECH = pd_fecpro;
    commit;

    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
    
     
    --2025.01.15 determina numero de jobs
    begin
       select x.tp1nro1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10 
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
     exception when others then
       lb_njobs := 50;
     end;
 
  
    ---carga diaria
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := 'begin ' ||
                     '  PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_cartera_finmes(' ||
                     ln_ini || ',TO_DATE(''' || lc_fecpro ||
                     ''',''RRRR.MM.DD'') );' || ' End;';
      ln_job      := ln_job + 1;
    
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        --2019.07.22 cambio
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1, ---2 2025.01.15 se cambio similar a fondos
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

      --2025.01.15 dcastro se agrego para optimizar jobs
       SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
        while x = lb_njobs loop
          --- Parametrizar              BANTPROD
          SELECT count(*)
            INTO x
            FROM dba_jobs x
           WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
             AND x.what LIKE '%' || trim(lc_pac_nombre) || '%';
      
         end loop;
       --2025.01.15 dcastro se agrego para optimizar jobs  


    
    end loop;

    --2025.01.15 dcastro se agrego para optimizar jobs  
     ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_paquete,lc_proceso);
      End loop;
    --2025.01.15 dcastro se agrego para optimizar jobs   
  
 end sp_cr_job_cartera_mes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_carga_datos_ana(pc_sucurs in varchar2, pd_fecpro in date, pc_usuario in varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL600
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 2024.05.21 DCASTRO se modifico procedimiento para carga por analista
    -- *****************************************************************
  
    cursor creditos(lc_sucurs varchar2, ld_fecpro date, lc_usuario char) is
    
      select /*+index_ss(a) */
       a.jaql965ase, -- cod_analista, 
       a.jaql965suc agencia,
       sum(a.jaql965sdmn) Saldo_cartera,
       count(distinct a.jaql965ndoc) Nro_clientes --,
        from JAQL965 a
       where a.jaql965fech = ld_fecpro
         and a.jaql965suc = lc_sucurs --QUITAR COMENTARIO
         and a.jaql965mod not in (108, 33 /*, 200*/)
         and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
         AND a.jaql965ase =  lc_usuario 
         and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
             (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                from jaql970 j) --excluir a tabla de EXCEPCIONEs
         and (a.jaql965cta, a.jaql965oper) not in
             (select bccta, bcoper from jaqz498) --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
       group by a.jaql965ase, a.jaql965suc;
  
    lc_Tipo_analista    jaql577.jaql577tipo%type;
    ln_nummes           number := 0;
    ln_Saldo_Otorgado   number;
    ln_Saldo_Recibido   number;
    ln_Cliente_Otorgado number;
    ln_Cliente_recibido number;
    ln_Por_Mora         number;
    ln_Clientes_Nuevos  number;
    ln_sal_mes_anterior number;
    ln_cli_mes_anterior number;
    ln_Sal_maximo       number;
    ln_Cli_maximo       number;
    ln_Fec_CliMax       date;
    ln_Fec_SalMax       date;
    lc_Tipo_ana         char(1);
    lc_Tipo_agencia     varchar2(4);
  
    ln_saltot           number;
    ln_clitot           number;
    ln_salmor           number;
    ln_saljud           number;
    ln_cont             NUMBER;
    ln_salcas           number;
    ln_salrec           number;
    ln_numrec           number;
    ln_nuevo_sal        number;
    ln_nuevo_cli        number;
    ln_agencia          number; --2016.05.12
    lc_tipo_NEO         char(1);
    ln_agencia_analista number;
    ln_clicas           number;
    ln_salven           number;
    ln_cliven           number;
    ln_numage           number; --2017.05.05
    ln_agencia_MESA     number;
    ln_saldia           number;
    ln_porconvenio      number;
    lc_desagencia       varchar2(50);
    lc_descategoria     varchar2(50);
    lc_asesor           char(10);
  
    lc_coderr varchar2(1000);
    lc_deserr varchar2(1000); 
  
  begin
  
    lc_asesor := rpad(pc_usuario, 10, ' ');
    
    begin
      delete from JAQL600 j where j.jaql600fpro = pd_fecpro and j.jaql600usu = lc_asesor;
      commit;
    exception when others then
      null;  
    end;  
  
    for i in creditos(pc_sucurs, pd_fecpro, lc_asesor ) loop
    
      --2017.03.21 obtiene agencia de mayor numero de desembolsos o agencia en la que posee mas creditos
      ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,
                                                                    pd_fecpro   => pd_fecpro);
    
      ---analista cesado considera agencia del mes anterior
      /*       if ln_agencia_analista = 904 then
         --agencia del mes anterior       
          ln_agencia_analista := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior( i.jaql965ase,pd_fecpro);
      end if;*/
      ln_agencia := i.agencia;
      ---
    
      --validando si solo tiene una agencia y desembolsos no corresponden a la agencia
      if ln_agencia <> ln_agencia_analista then
      
        begin
        
          select count(distinct a.jaql965suc) agencia
            into ln_numage
            from JAQL965 a
           where a.jaql965fech = pd_fecpro
             and a.jaql965mod not in (108, 33 /*, 200*/)
             and substr(jaql965tcrd, 1, 11) <> 'CORPORATIVO'
             AND a.jaql965ase = i.jaql965ase
             and (a.jaql965cta, a.jaql965oper, a.jaql965ase) not in
                 (select j.jaql970cta, j.jaql970oper, j.jaql970ase
                    from jaql970 j) --excluir a tabla de EXCEPCIONEs
             and (a.jaql965cta, a.jaql965oper) not in
                 (select bccta, bcoper from jaqz498); --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs   
        
        exception
          when others then
            ln_numage := 0;
        end;
      
        if ln_numage = 1 then
          ln_agencia_analista := i.agencia;
        end if;
      
      end if;
    
      if ln_agencia = ln_agencia_analista then
        -- si las agencias son iguales, corresponde a agencia vigente del analista
        --
      
        ln_Saldo_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_otorgadoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
        ln_Saldo_Recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Sal_recibidoNew(i.jaql965ase,
                                                                                pd_fecpro,
                                                                                ln_agencia /*i.agencia*/),
                                 0);
      
        ln_Cliente_Otorgado := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_otorgadoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
        ln_Cliente_recibido := nvl(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_Cli_recibidoNew(i.jaql965ase,
                                                                                  pd_fecpro,
                                                                                  ln_agencia /*i.agencia*/),
                                   0);
                                   
      
        --compara la agencia del mes anterior, si son de la misma agencia considera otorgados sino NO 
        ln_agencia_MESA :=  --PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia(pc_analista => i.jaql965ase,last_day(add_months(trunc(pd_fecpro), -1))); 
         PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_agencia_anterior(i.jaql965ase,
                                                                           pd_fecpro);
      
        if ln_agencia_MESA <> ln_agencia then
          ln_Saldo_Otorgado   := 0;
          ln_Cliente_Otorgado := 0;
          ln_nummes           := 1;
        else
          ln_nummes := 2;
        end if;
      
        ln_saldia := pq_cr_productividad_nueva.fn_cr_sal_aldia(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);

      
        ln_saljud := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_judicial(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia);
        ln_salmor := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_mora(i.jaql965ase,
                                                               pd_fecpro,
                                                               ln_agencia); --saldo mora  > 15 dias
        ln_salcas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_sal_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
        ln_clicas := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_cli_castigado(i.jaql965ase,
                                                                  pd_fecpro,
                                                                  ln_agencia);
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_cartera_vendida(i.jaql965ase,
                                                         ln_agencia,
                                                         pd_fecpro,
                                                         ln_salven,
                                                         ln_cliven);
        end;
      
        ln_salrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_saldo_legal(i.jaql965ase,
                                                                pd_fecpro,
                                                                ln_agencia); --saldo de creditos en recuperacion legal
        ln_numrec := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_num_saldo_legal(i.jaql965ase,
                                                                    pd_fecpro,
                                                                    ln_agencia); --saldo de creditos en recuperacion legal
      
        ln_saltot    := i.Saldo_cartera + ln_Saldo_Otorgado -
                        ln_Saldo_Recibido;
        ln_clitot    := i.Nro_clientes + ln_Cliente_Otorgado -
                        ln_Cliente_recibido;
        ln_nuevo_sal := i.Saldo_cartera + ln_salcas + ln_salven;
        ln_nuevo_cli := i.Nro_clientes + ln_clicas + ln_cliven;
      
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_nuevosaldo_anterior(pc_analista => i.jaql965ase,
                                                             pd_fecpro   => last_day(add_months(trunc(pd_fecpro),
                                                                                                -1)),
                                                             pc_codage   => ln_agencia,
                                                             pn_salant   => ln_sal_mes_anterior,
                                                             pn_cliant   => ln_cli_mes_anterior);
        end;
      
        ln_Por_Mora := PQ_CR_PRODUCTIVIDAD_NUEVA.fn_pa_nueva_mora(i.jaql965ase,
                                                                 pd_fecpro,
                                                                 ln_agencia /*i.agencia*/,
                                                                 ln_salmor,
                                                                 ln_saljud,
                                                                 ln_nuevo_sal);
      
        --2016
        begin
          PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_categoriarrhh(pc_jaqy830codana => i.jaql965ase,
                                                       pd_fecpro        => pd_fecpro,
                                                       pn_jaqy830codcat => lc_Tipo_analista,
                                                       pc_jaqy830tipase => lc_Tipo_ana);
        end;
        
        --obtener tipo analista Pyme/Convenio nuevo calculo
        begin
                  pq_cr_productividad_nueva.sp_cr_tipoanalista(pc_analista => i.jaql965ase,
                                                                  pd_fecpro => pd_fecpro,
                                                                  pn_codage => ln_agencia,
                                                                  --pn_sdotot => ln_saltot,  2025.01.04
                                                                  pn_sdotot => i.Saldo_cartera, --2025.01.04
                                                                  pn_porsdo => ln_porconvenio,
                                                                  pc_tipoana => lc_Tipo_ana);
        end;

        
        --tipo agencia NEO
        --lc_tipo_NEO := trim(PQ_CR_PRODUCTIVIDAD_NUEVA.fn_cr_tipo_agencia_metas(ln_agencia /*i.agencia*/,
        -- pd_fecpro));
        begin 
          select f.scnom
            into lc_desagencia
            from fst001 f
           where f.pgcod = 1
             and f.sucurs = ln_agencia;                                                                    
        exception when others then
            lc_desagencia    := null;
        end;     

 
        begin
           select j.jaqy830catana
             into lc_descategoria 
             from jaqy830 j
            where j.jaqy830codana = i.jaql965ase
              and j.jaqy830est = 'S'; 
        exception when others then
            lc_descategoria  := null;
        end;     
          
     
        lc_tipo_NEO := null;
        
        --2023.11.13
        if ln_Por_Mora >999 then
           ln_Por_Mora := 999;
        end if;
        if ln_porconvenio > 999 then
           ln_porconvenio := 999;        
        end if;
        --2023.11.13
        
       begin ---2023.11.13 se agrego excepcion
            insert into JAQL600
              (JAQL600FPRO,
               JAQL600USU,
               JAQL600AGE,
               JAQL600MANT,
               JAQL600CODCAT,
               JAQL600TASE,
               JAQL600SDO,
               JAQL600NCL,
               JAQL600SDM,
               JAQL600PMRA,
               JAQL600SOTO,
               JAQL600SREC,
               JAQL600COTO,
               JAQL600CREC,
               JAQL600SRL,
               JAQL600NRL,
               JAQL600SANT,
               JAQL600CANT,
               JAQL600SDCA,
               JAQL600SDJU, /*JAQL600CRSA,JAQL600CRCL,JAQL600IDES,JAQL600PDES,*/
               JAQL600CLTOT,
               JAQL600SDTOT,
               JAQL600NEO,
               JAQL600EST,
               jaql600crsa,
               jaql600crcl,
               jaql600ides,
               jaql600pdes,
               jaql600mtsa,
               jaql600mtcl,
               jaql600mtre,
               jaql600mtmr,
               jaql600psal,
               jaql600pcli,
               jaql600pret,
               jaql600pmor,
               jaql600pvar,
               jaql600pjca,
               jaql600pjcas,
               jaql600cmra,
               jaql600bsal,
               jaql600bcli,
               jaql600bmra,
               jaql600btri,
               jaql600totpa,
               jaql600ccam,
               jaql600vcam,
               jaql600tcam,
               jaql600aux1,
               jaql600aux2,
               jaql600aux3,
               jaql600aux4,
               jaql600aux5,
               jaql600aux6,
               jaql600pcam,
               jaql600pord,
               jaql600mtod,
               jaql600vmor,
               jaql600csal,
               jaql600esal,
               jaql600ccli,
               jaql600ecli,
               jaql600cret,
               jaql600eret,
               jaql600posa,
               jaql600pocl,
               jaql600exsa,
               jaql600excl,
               jaql600exre,
               jaql600pore,
               jaql600bare,
               jaql600more,
               jaql600pmoa,
               JAQL600CAVE,
               JAQL600CLVE,
               jaql600sdodi,
               jaql600pordi,
               jaql600pagdi,
               jaql600porco,
               jaql600desag,
               jaql600desca  
               )
            values
              (pd_fecpro,
               i.jaql965ase,
               ln_agencia,
               ln_nummes,
               lc_Tipo_analista,
               lc_Tipo_ana,
               ln_nuevo_sal,
               ln_nuevo_cli,
               ln_salmor,
               ln_Por_Mora,
               ln_Saldo_Otorgado,
               ln_Saldo_Recibido,
               ln_Cliente_Otorgado,
               ln_Cliente_recibido,
               ln_salrec,
               ln_numrec,
               ln_sal_mes_anterior,
               ln_cli_mes_anterior,
               ln_Salcas,
               ln_saljud,
               ln_clitot,
               ln_saltot,
               lc_tipo_NEO,
               'S', --2023.08.29 se restauro a S----'S' , 2017.03.15 cambiar a S
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               ln_salven,
               ln_cliven,
               ln_saldia,
               0,
               0,
               ln_porconvenio,
               lc_desagencia,
               lc_descategoria
               );
          
            commit;
        
        exception when others then -- 2023.11.13 se agrego excepcion
           lc_coderr := sqlcode;
           lc_deserr := sqlerrm;
        end;           ---- 2023.11.13
      end if; --fiN de validacion de agencia del credito con agencia actual del analista
    
    end loop;
  
  end sp_cr_carga_datos_ana; 

procedure sp_cr_consolida(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_consolida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2025.01.15
    -- Autor de Creación          : 
    -- Uso                        : CONSOLIDA PROCESOS DE CARGA PRODUCTIVIDAD 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************


begin
  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    
    delete from jaql600i j where j.jaql600ifpro = pd_fecpro;
    commit;
    

    insert into jaql600i(JAQL600Ifpro, JAQL600IC1I)  
    values(pd_fecpro, sysdate);
    commit;

    --1 inserta data de cartera en jaql965, toma como base data de jaqll964
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cartera_diario(pd_fecpro);
    end;
    update jaql600i set JAQL600IC1F = sysdate, JAQL600IC2I = sysdate where JAQL600Ifpro = pd_fecpro;
    -- 2 carga cartera en jaql600
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_carga(pd_fecpro);
    end;
    update jaql600i set JAQL600IC2F = sysdate, JAQL600IC3I = sysdate where JAQL600Ifpro = pd_fecpro;

    -- 3 calcula indicadores 
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_indicadores(pd_fecpro);
    end;
    update jaql600i set JAQL600IC3F = sysdate, JAQL600IC4I = sysdate where JAQL600Ifpro = pd_fecpro;

    -- 4  calcula productividad analistas
    begin
            PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cumplimiento(pd_fecpro);
    end;
    update jaql600i set JAQL600IC4F = sysdate, JAQL600IC5I = sysdate where JAQL600Ifpro = pd_fecpro;  

    -- 5 carga data seniors jaql600s
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_calculo_senior(pd_fecpro   => pd_fecpro,
                                                    pc_analista => '');
    end;
    update jaql600i set JAQL600IC5F = sysdate, JAQL600IC6I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --6--calcula productividad Cumplimiento SENIOR
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_Cumplimiento_Senior(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC6F = sysdate, JAQL600IC7I = sysdate where JAQL600Ifpro = pd_fecpro;  
    commit;
    
    
    
end sp_cr_consolida;
---------------------------------------------------------------------
procedure sp_cr_inserta_desembolsos_SUC(pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_desembolsos_SUC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQZ455
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecini   date;
    ld_fecfin   date;
    ld_feccan   date;
    ln_num      number := 0;
    lc_producto char(2);
    ln_bcgpo    number;
    lc_analista char(10);
  
    cursor creditos is
      select distinct f.jaqz454cta, f.jaqz454oper, f.jaqz454fpro
        from JAQZ454 f, fsd011 g
       where f.jaqz454fpro = pd_fecpro
         and g.pgcod = 1
         and g.sccta = f.jaqz454cta
         and g.scoper = f.jaqz454oper
         and REGEXP_LIKE(g.scrub, '^14.[1-6]')
         and g.scgru in (5, 6, 7, 8, 9, 10);
  
    cursor maestro is
      select /*+PARALLEL(f,4) +PARALLEL(j,4) */
      --   fn_analista_credito(f.aomod,f.aosuc, f.aomda,f.aopap, f.aocta,f.aooper, f.aosbop,f.aotope) analista,
       f.*, j.*
        from fsd010 f, jaqz454 j, fst111 k
       where f.pgcod = 1
         and f.aocta = j.jaqz454cta
         and f.aomod = k.modulo
         and f.aooper = j.jaqz454oper
         and k.dscod = 50
         and j.jaqz454fpro = pd_fecpro;
  
  begin
  
    ld_fecini := to_date(to_char(pd_fecpro, 'yyyymm') || '01', 'yyyymmdd');
    ld_fecfin := last_Day(pd_fecpro);
  
    begin
      delete from JAQZ454 where JAQZ454FPRO = pd_fecpro;
      commit;
    exception when others then
      null;  
    end;      
    /*efuentes 2021.11.09*/  --2024.03.22 dcastro se comento porque no invoca a recategoriza
   /* delete from AQPB617A where AQPB617AFPRO = pd_fecpro;
    commit;*/
    /*efuentes 2021.11.09*/
    begin
      
      insert into JAQZ454
        (JAQZ454CTA,
         JAQZ454OPER,
         jaqz454fpro,
         JAQZ454FCON,
         JAQZ454MDA,
         JAQZ454IMP1,
         JAQZ454SUCU,
         JAQZ454COD,
         JAQZ454MOD,
         JAQZ454SUCOR,
         JAQZ454TRAN,
         JAQZ454NREL,
         JAQZ454RUBRO)    
        SELECT /*+PARALLEL(H15,16) PARALLEL(H16,16)*/
         H16.HCTA,
         H16.hoper,
         pd_fecpro,
         H16.HFCON,
         H16.HMDA,
         H16.HCIMP1,
         H16.HSUCUR,
         H16.PGCOD,
         H16.HCMOD,
         H16.HSUCOR,
         H16.HTRAN,
         H16.HNREL,
         H16.HRUBRO
          FROM FSH015 H15, FSH016 H16
         WHERE H16.PGCOD = H15.PGCOD
           AND H16.HCMOD = H15.HCMOD
           AND H16.HSUCOR = H15.HSUCOR
           AND H16.HTRAN = H15.HTRAN
           AND H16.HNREL = H15.HNREL
           AND H16.HFCON = H15.HFCON
           AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
           AND H16.HFVCO = H15.HFCON
           AND H15.PGCOD = 1
           AND H15.HCCORR <> 99
           AND H16.HCODMO = 1
           AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
           and h16.HSUCOR in (select f.sucurs from fst001 f) ---2024.03.22 dcastro se agrego para optimizar
          /* AND ((H16.HCMOD = 116 AND H16.HTRAN IN (50, 60, 200)) OR
               (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
               (H16.HCMOD = 30 AND H16.HTRAN IN (360, 951)));
           */
           --2023.10.10 se agrego transacciones BI
           AND ( H16.HCMOD,H16.HTRAN) IN (select tp1nro1, tp1nro2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 10847
                         and tp1corr1 = 33 
                         and tp1imp1 = 0)
                 ;
         commit;
    exception when others then
      null;  
    end;              

      /*efuentes 2021.11.09*/
      /*insert into AQPB617A
        (AQPB617ACTA,
         AQPB617AOPER,
         AQPB617AFPRO,
         AQPB617AFCON,
         AQPB617AMDA,
         AQPB617AIMP1,
         AQPB617ASUCU,
         AQPB617ACOD,
         AQPB617AMOD,
         AQPB617ASUCOR,
         AQPB617ATRAN,
         AQPB617ANREL,
         AQPB617ARUBRO)*/
        --SELECT /*+PARALLEL(H15,16) PARALLEL(H16,16)*/
        /*H16.HCTA,
         H16.hoper,
         pd_fecpro,
         H16.HFCON,
         H16.HMDA,
         H16.HCIMP1,
         H16.HSUCUR,
         H16.PGCOD,
         H16.HCMOD,
         H16.HSUCOR,
         H16.HTRAN,
         H16.HNREL,
         H16.HRUBRO
          FROM FSH015 H15, FSH016 H16
         WHERE H16.PGCOD = H15.PGCOD
           AND H16.HCMOD = H15.HCMOD
           AND H16.HSUCOR = H15.HSUCOR
           AND H16.HTRAN = H15.HTRAN
           AND H16.HNREL = H15.HNREL
           AND H16.HFCON = H15.HFCON
           AND REGEXP_LIKE(H16.HRUBRO, '^14.[1-6]')
           AND H16.HFVCO = H15.HFCON
           AND H15.PGCOD = 1
           AND H15.HCCORR <> 99
           AND H16.HCODMO = 1
           AND H15.HFCON BETWEEN ld_fecini AND pd_fecpro
           AND ((H16.HCMOD = 116 AND H16.HTRAN IN (50, 200)) OR
               (H16.HCMOD = 183 AND H16.HTRAN = 10) OR
               (H16.HCMOD = 30 AND H16.HTRAN IN (360, 951)));
      --efuentes 2021.11.09
      commit;
       */
      --eliminar corporativos
      /*for i in creditos loop
          delete from jaqz454 j where j.jaqz454cta  = i.jaqz454cta and j.jaqz454oper = i.jaqz454oper and j.jaqz454fpro = i.jaqz454fpro;
          commit;  
      end loop;*/
      ---
  
    for i in maestro loop
      --busca el codigo de analista a fin de mes, en caso no exista el credito se cancelo, buscar el analista con el que quedo
      begin
        select j.jaql965ase
          into lc_analista
          from jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = 1
           and j.jaql965mod = i.aomod
           and j.jaql965suc = i.aosuc
           and j.jaql965mda = i.aomda
           and j.jaql965pap = i.aopap
           and j.jaql965cta = i.aocta
           and j.jaql965oper = i.aooper
           and j.jaql965sbop = i.aosbop;
      exception
        when no_data_found then
          lc_analista := fn_analista_credito(i.aomod,
                                             i.aosuc,
                                             i.aomda,
                                             i.aopap,
                                             i.aocta,
                                             i.aooper,
                                             i.aosbop,
                                             i.aotope);
      end;
    
      CASE
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]02') THEN
          ln_bcgpo := 2; --LC_PROD := 'MICROEMPRESA';
      --WHEN REGEXP_LIKE(i.jaqz454rub,'^14.[1-6]03....015') THEN LC_PROD := 'CONSUMO REVOLVENTE';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]03') THEN
          ln_bcgpo := 3; --LC_PROD := 'CONSUMO NO REVOLVENTE';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]04') THEN
          ln_bcgpo := 4; --LC_PROD := 'HIPOTECARIO';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]11') THEN
          ln_bcgpo := 11; --LC_PROD := 'GRANDES EMPRESAS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]12') THEN
          ln_bcgpo := 12; --LC_PROD := 'MEDIANAS EMPRESAS';           
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]13') THEN
          ln_bcgpo := 13; --LC_PROD := 'PEQUEÑAS EMPRESAS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]05') THEN
          ln_bcgpo := 5; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]06') THEN
          ln_bcgpo := 6; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]07') THEN
          ln_bcgpo := 7; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]08') THEN
          ln_bcgpo := 8; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]09') THEN
          ln_bcgpo := 9; --LC_PROD := 'CORPORATIVOS';
        WHEN REGEXP_LIKE(i.jaqz454rubro, '^14.[1-6]10') THEN
          ln_bcgpo := 10; --LC_PROD := 'CORPORATIVOS';
      END CASE;
    
      case
        when ln_bcgpo = 2 then
          lc_producto := 'MI';
        when ln_bcgpo = 3 then
          lc_producto := 'CN';
        when ln_bcgpo = 4 then
          lc_producto := 'HI';
        when ln_bcgpo = 11 then
          lc_producto := 'GR';
        when ln_bcgpo = 12 then
          lc_producto := 'ME';
        when ln_bcgpo = 13 then
          lc_producto := 'PE';
        when ln_bcgpo in (5, 6, 7, 8, 9, 10) then
          lc_producto := 'CO';
        else
          lc_producto := null;
      end case;
    
      if lc_producto = 'CO' then
        delete from jaqz454 j
         where j.jaqz454cta = i.jaqz454cta
           and j.jaqz454oper = i.jaqz454oper
           and j.jaqz454fpro = i.jaqz454fpro;
      else
        update jaqz454
           set jaqz454ase = lc_analista, jaqz454pro = lc_producto
         where jaqz454cta = i.jaqz454cta
           and jaqz454oper = i.jaqz454oper
           and jaqz454fpro = pd_fecpro;
           
        /*efuentes 2021.11.09*/
        /*update AQPB617A A
           set A.AQPB617AASE = lc_analista, A.AQPB617APRO = lc_producto
         where A.AQPB617ACTA  = i.jaqz454cta
           and A.AQPB617AOPER = i.jaqz454oper
           and A.AQPB617AFPRO = pd_fecpro;*/
        /*efuentes 2021.11.09*/
      end if;
    
      commit;
      lc_analista := null;
    
    end loop;
  
    --eliminando creditos de tesoreria
    delete from jaqz454 j
     where (j.jaqz454cta, j.jaqz454oper) in
           (select bccta, bcoper from jaqz498)
       and j.jaqz454fpro = pd_fecpro;
    
    /*efuentes 2021.11.09*/
    /*delete from aqpb617a a
     where (a.aqpb617acta, a.aqpb617aoper) in
           (select bccta, bcoper from jaqz498)
       and a.aqpb617afpro = pd_fecpro;*/       
    /*efuentes 2021.11.09*/
           
    --tabla de creditos generados por TESOERIA - GRANDES y PEQUEÑAs  
    --commit;
    
    
/*    --2024.03.22 dcastro se comento porque ya existe en job
    begin
        pq_cr_productividad_nueva.sp_cr_inserta_desembolsos_recategorizacion(pd_fecpro);
    exception
      when others then
        null;
     end;
     */
  end sp_cr_inserta_desembolsos_SUC;
 ---------------------------------------
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 

  Function fn_cr_verifica_tarea2(pn_paquete in varchar2,
                                 pn_proceso in varchar2) return number is
 
    -- *****************************************************************
    -- Nombre                     : fn_cr_verifica_tarea2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2025.01.15
    -- Autor de Creación          : 
    -- Uso                        : verifica si ejecución de jobs culminó
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : DCASTRO
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    --  
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; 
    end;
  
    begin

    
      lc_pac_nombre := upper(trim(pn_paquete) || '.' || trim(pn_proceso));
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND upper(x.what) LIKE '%' || trim(lc_pac_nombre) || '%';
    
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_Calculo_Mensual_O(pd_fecpro in date) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    --2019.09.04 DCASTRO se agrego sentencia execute inmediate en lc_sql
    --2023.03.09 DCASTRO se modifico procesos
    lc_fecpro char(10);
    lc_tabla  varchar2(30);
    lc_sql    varchar2(4000);
  
  begin
 
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';

 
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
    lc_tabla  := 'operador.sng057_' || to_char(pd_fecpro, 'RRRRMM');

    delete  from jaql600i where JAQL600Ifpro = pd_fecpro;
    commit;

  
    --0 eLIMINA
    DELETE FROM SNG057_201X S WHERE S.SNG057FPRO = pd_fecpro;
    commit;
  
    --1  GENERAR BACKUP
 
    lc_sql := 'INSERT INTO SNG057_201X (sng055emp, sng057usr, sng055car, sng057aut, 
                sng057sup, sng057ini, sng057fin, sng057jef, sng057wkf, sng057prc, sng057tsk, SNG057FPRO ) 
                SELECT sng055emp, sng057usr, sng055car, sng057aut, sng057sup, sng057ini, sng057fin, sng057jef, 
                sng057wkf, sng057prc, sng057tsk,
                ''' || pd_fecpro || ''' from ' || lc_tabla;

 
    EXECUTE IMMEDIATE lc_sql;
    commit;
    
 
    --0 inserta tabla log
    insert into jaql600i(JAQL600Ifpro, JAQL600IC1I)  
    values(pd_fecpro, sysdate);
       
    
   --1 actualiza traslados
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_traslados_JAQZ455(pd_fecpro);
    end;
    update jaql600i set JAQL600IC1F = sysdate, JAQL600IC2I = sysdate where JAQL600Ifpro = pd_fecpro;
 
    --2 -inserta desembolsos
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_inserta_desembolsos(pd_fecpro);
    end;
    update jaql600i set JAQL600IC2F = sysdate, JAQL600IC3I = sysdate where JAQL600Ifpro = pd_fecpro;

    --3  INSERTA CARTERA EN TABLA BASE JAQL965, DESEMBOLSOS, 
     --  inserta data de cartera en jaql965, toma como base data de jaqll964
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_job_cartera_mes(pd_fecpro);
    end;

    update jaql600i set JAQL600IC3F = sysdate, JAQL600IC4I = sysdate where JAQL600Ifpro = pd_fecpro;

  
    --4 - CARGA INFORMACION PARA PRODUCTIVIDAD JAQL600  
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_sch_job_carga(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC4F = sysdate, JAQL600IC5I = sysdate where JAQL600Ifpro = pd_fecpro;  
   

    --5 -INDICADORES - OBTIENE VARIABLES E INDICADORES PARA CALCULO PRODUCTIVIDAD
    --C2
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_indicadores_NEW(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC5F = sysdate, JAQL600IC6I = sysdate where JAQL600Ifpro = pd_fecpro;  
  
    --6 - CUMPLIMIENTO - VALIDA CUMPLIMIENTO EN CARTERA, CLIENTES, RETENCION, CONTENCION, MORA, CONTINUIDAD MORA
    --C3
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_cumplimiento(pd_fecpro => pd_fecpro);
    end;
  
    update jaql600i set JAQL600IC6F = sysdate, JAQL600IC7I = sysdate where JAQL600Ifpro = pd_fecpro;  

    --7 calculo senior
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_calculo_senior(pd_fecpro   => pd_fecpro,
                                                    pc_analista => '');
    end;

    update jaql600i set JAQL600IC7F = sysdate, JAQL600IC8I = sysdate where JAQL600Ifpro = pd_fecpro;  
    
    --8--Cumplimiento SENIOR
    begin
      PQ_CR_PRODUCTIVIDAD_NUEVA.sp_cr_sch_cumplimiento_senior(pd_fecpro => pd_fecpro);
    end;

    update jaql600i set JAQL600IC8F = sysdate where JAQL600Ifpro = pd_fecpro;  
    commit;
 
  end sp_cr_Calculo_Mensual_O;  
end PQ_CR_PRODUCTIVIDAD_NUEVA;
/
