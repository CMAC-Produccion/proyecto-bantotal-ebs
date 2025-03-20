create or replace package pq_cr_reporte_fondofaeagro is

  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondofaeagro
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/06/2021 10:12:34
  -- Autor de Creación            : RMONTESR
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Procedimientos para carga de plantilla fondos fae agro
  -- Fecha de Modificación        : 03/08/2021
  -- Autor de Modificación        : JRODRIGUEJ
  -- Descripción de Modificación  : Actualización de procedimientos para la generación del reporte
  -- Fecha de Modificación        : 14/11/2023
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Optimizacion de procedimientos
  -- Fecha de Modificación        : 08/01/2024
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Modificacion saldo insoluto reporta el valor asi sea cancelado
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  --AQPB379
  procedure sp_reporte_fagro_r1(   pn_fini    in date,
                                   pn_ffin    in date,
                                   pc_sucurs  in number,
                                   pn_usuario in char);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Registro de históricos
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_ind     number,
                                 pn_fcorte  date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  --AQPB379
  procedure sp_cr_sch_fagro(pd_fini in date, 
                            pd_fecpro  in date,
                            pn_usuario in varchar2
                            );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  -- FAE AGRO: Obtener información adicional
  procedure sp_plantilla_faeagro_r1(pn_cod   in number,
                                    --pn_mod   in number,
                                    --pn_suc   in number,
                                    --pn_mda   in number,
                                    --pn_pap   in number,
                                    pn_cta   in number,
                                    --pn_ope   in number,
                                    --pn_sbo   in number,
                                    --pn_top   in number,
                                    pn_fecha in date,
                                    
                                    pn_csol out aqpb379b.aqpb379bcsol%type,
                                    pn_ofon out aqpb379b.aqpb379bofon%type,
                                    pn_ncer out aqpb379b.aqpb379bncer%type,
                                    pn_idlin out aqpb379b.aqpb379bidlin%type,
                                    pn_fecof out aqpb379b.aqpb379bfecof%type,
                                    pn_moncof out aqpb379b.aqpb379bmoncof%type,
                                    pn_ciiu out aqpb379b.aqpb379bciiu%type,
                                    pn_aeco out aqpb379b.aqpb379baeco%type,
                                    pn_finc out aqpb379b.aqpb379bfinc%type,
                                    pn_ffic out aqpb379b.aqpb379bffic%type,
                                    pn_pcob   out aqpb379b.aqpb379bpcob%type
                                    ); -- return number;  
                                    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  -- FAE AGRO: Obtener información adicional
  procedure sp_plantilla_faeagro_v2(pn_cod   in number,
                                    pn_cta   in number,
                                    pn_fecha in date,
                                    
                                    pn_csol out aqpb379b.aqpb379bcsol%type,
                                    pn_ofon out aqpb379b.aqpb379bofon%type,
                                    pn_ncer out aqpb379b.aqpb379bncer%type,
                                    pn_idlin out aqpb379b.aqpb379bidlin%type,
                                    pn_fecof out aqpb379b.aqpb379bfecof%type,
                                    pn_moncof out aqpb379b.aqpb379bmoncof%type,
                                    pn_ciiu out aqpb379b.aqpb379bciiu%type,
                                    pn_aeco out aqpb379b.aqpb379baeco%type,
                                    pn_finc out aqpb379b.aqpb379bfinc%type,
                                    pn_ffic out aqpb379b.aqpb379bffic%type,
                                    pn_pcob   out aqpb379b.aqpb379bpcob%type,
                                    pn_ccob out aqpb379b.aqpb379bccob%type,
                                    pn_cren out aqpb379b.aqpb379bcren%type,
                                    pn_chon out aqpb379b.aqpb379bchon%type
                                    ); -- return number;  
                                    
  procedure sp_sch_aqpb070a_carga(pd_fecpro in date, pn_usuario in char, pn_indi in number);                          
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_carga_temp_fagro(pc_usuario in varchar2, 
                                     pc_sucurs in varchar2,
                                     pc_fecpro in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                 
  -- Registro de información en plantilla
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Actualización de información en plantilla
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                   
  
  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                  
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2,
                                pn_paquete in varchar2,
                                pn_proceso in varchar2,
                                pn_usuario in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                    
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2);  
  -- ===== PROCEDIMIENTOS Y FUNCIONES PARA LOS REPORTES=====================
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_obtener_sdocap(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fecha   in date,
                             pn_usuario in char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_sald_insol2(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_nombre(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig2(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_upago(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                    
  -- Obtener cod. SBS y clasificación SBS: NORMAL, CPP, DEFICIENTE, DUDOSO, PERDIDA
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,

                            pn_calif0 out aqpb379.aqpb379canom%type,
                            pn_calif1 out aqpb379.aqpb379cacpp%type,
                            pn_calif2 out aqpb379.aqpb379cadef%type,
                            pn_calif3 out aqpb379.aqpb379cadud%type,
                            pn_calif4 out aqpb379.aqpb379caper%type,
                            pn_csbs   out aqpb379.aqpb379csbs%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_calf_caja(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_est   in number,
                                 pn_fecha in date,
                                 
                                 pn_calif0a out aqpb379.aqpb379clnom%type,
                                 pn_calif1a out aqpb379.aqpb379clcpp%type,
                                 pn_calif2a out aqpb379.aqpb379cldef%type,
                                 pn_calif3a out aqpb379.aqpb379cldud%type,
                                 pn_calif4a out aqpb379.aqpb379clper%type,
                                 pn_deccaj  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_scond_c(pn_cod   in number,
                            pn_mod   in number,
                            pn_suc   in number,
                            pn_mda   in number,
                            pn_pap   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_sbo   in number,
                            pn_top   in number,
                            pn_fecha in date,
                            --pn_dcon in char,
                            pn_est   in number,
                            pn_usuario in char,

                            pn_rubr out char,
                            pn_resp out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_pgracia2(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_sucs(pn_sucs in number,
                            pn_regi out number,
                            pn_zona out number,
                            pn_nsuc out aqpb065.aqpb065nsuc%type,
                            pn_nzon out aqpb065.aqpb065nzon%type,
                            pn_nreg out aqpb065.aqpb065nreg%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  --  Distribución de pago realizado: acumulado
  procedure sp_distribuc_pago_acum(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tsum  out number,
                                   pn_gas   out number,
                                   pn_mor   out number,
                                   pn_int   out number,
                                   pn_cuo   out number,
                                   pn_icv   out number,
                                   pn_pen   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_ncuotas_pagadas(pn_cod      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_fecha    in date,
                                   pn_ncuo_tot out number,
                                   pn_ncuo_pag out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_datraso_uimp(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_diat  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_estado_desc(pd_stat in number) return aqpb379.aqpb379nestcre%type;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_flag_amrtzn(pn_cod   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_sbo   in number,
                           pn_top   in number,
                           pn_fecha in date,
                           pn_flarm out aqpb379.aqpb379amort%type,
                           pn_fecrm out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_cap_amort(pn_cod    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_ope    in number,
                                  pn_sbo    in number,
                                  pn_top    in number,
                                  pn_ord    in number,
                                  pn_fcorte in date,
                                  
                                  pn_impl out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                    
  procedure sp_obtener_datos_ufecha(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    
                                    pn_fpagu out date, -- Fecha de la última cuota pagada: ppfpag
                                    pn_fvenu out date); -- Fecha de vencimiento de la última cuota pagada
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_reprog_datos(pn_cod   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_fecha in date,
                           
                           pn_flag  out char,
                           pn_frep  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
  procedure sp_obtener_fsd010(pn_cod     in number,
                                 pn_mod     in number,
                                 pn_suc     in number,
                                 pn_mda     in number,
                                 pn_pap     in number,
                                 pn_cta     in number,
                                 pn_ope     in number,
                                 pn_sbo     in number,
                                 pn_top     in number,
                                 pn_mdes out number,
                                 pn_fval out date,
                                 pn_fven out date); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --  Distribución de pago realizado: acumulado  
  procedure sp_distribuc_pago_mes(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tsum  out number,
                                   pn_gas   out number,
                                   pn_mor   out number,
                                   pn_int   out number,
                                   pn_cuo   out number,
                                   pn_icv   out number,
                                   pn_pen   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  function fn_fecha_upago_mes(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                               
  procedure sp_monto_disposicion(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fini in date,
                                  pn_ffin in date,                                  
                                  pn_mont   out number,
                                  pn_fec_dis out date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                 
  -- Equivalencia del tipo de documento para obtener el cod. SBS
  function fn_equivalenciadoc(p_tdoc number) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  -- Obtener nro cuotas actual
  function fn_fecha_ncuoa(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_monto_disposicion2(pn_cod  in number,
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 pn_ffin in date,
                                 pn_mont out number,
                                 pn_fec_dis out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig_117(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                   
end pq_cr_reporte_fondofaeagro;
/

create or replace package body pq_cr_reporte_fondofaeagro is

  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondofaeagro
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/06/2021 10:12:34
  -- Autor de Creación            : RMONTESR
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Procedimientos para carga de plantilla fondos fae agro
  -- Fecha de Modificación        : 03/08/2021
  -- Autor de Modificación        : JRODRIGUEJ
  -- Descripción de Modificación  : Actualización de procedimientos para la generación del reporte
  -- Fecha de Modificación        : 08/01/2024
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Modificacion saldo insoluto reporta el valor asi sea cancelado
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  --TABLA AQPB379
  procedure sp_reporte_fagro_r1(pn_fini    in date,
                                pn_ffin    in date,
                                pc_sucurs  in number,
                                pn_usuario in char) is
  
    lc_razon     char(100);
    lc_ncre      char(50);
    lc_pcre      number;
    lc_pcren     char(3);
    lc_pcre_c    char(3);
    lc_fecha_rcc date;
    lc_csbs      char(11);
    lc_fecha     DATE;
    lc_coderr    char(100);
    lc_msgerr    char(1000);
  
    --lc_ciiu number;
    lc_acti    char(60);
    lc_inst    number(10);
    lc_mda     char(10);
    lc_sdo_cap number(17, 2);
    lc_pgra    number(5);
  
    lc_calif0 number(5, 2);
    lc_calif1 number(5, 2);
    lc_calif2 number(5, 2);
    lc_calif3 number(5, 2);
    lc_calif4 number(5, 2);
  
    lc_calif0a   aqpb379.aqpb379clnom%type;
    lc_calif1a   aqpb379.aqpb379clcpp%type;
    lc_calif2a   aqpb379.aqpb379cldef%type;
    lc_calif3a   aqpb379.aqpb379cldud%type;
    lc_calif4a   aqpb379.aqpb379clper%type;
    lc_fecha_caj date;
  
    lc_statd char(30);
    lc_lamr  char(2);
    lc_fupag date;
    lc_diat  number;
    lc_regi  number(9);
    lc_zona  number(9);
    lc_ases  char(10);
    lc_nsuc  char(30);
    lc_nzon  char(40);
    lc_nreg  char(30);
  
    lc_mtoc  number(17, 2);
    lc_scapc number(17, 2);
  
    lc_tabla varchar2(50);
    lc_peri2 number;
    lc_ncuo2 number;
    lc_fpri  date;
    lc_fult  date;
  
    lc_ufpag1 date;
    --lc_fupag date;
    lc_fvenup date;
    lc_fvenuc date;
    lc_ncuop  number;
    lc_ncuopg number;
  
    lc_gas  number(16, 2);
    lc_mor  number(16, 2);
    lc_int  number(16, 2);
    lc_cuo  number(16, 2);
    lc_icv  number(16, 2);
    lc_pen  number(16, 2);
    lc_tsum number(16, 2);
    
    lc_gas1  number(16, 2);
    lc_mor1  number(16, 2);
    lc_int1  number(16, 2);
    lc_cuo1  number(16, 2);
    lc_icv1 number(16, 2);
    lc_pen1  number(16, 2);
    lc_tsum1 number(16, 2);
  
    lc_gas_mes  number(16, 2);
    lc_mor_mes  number(16, 2);
    lc_int_mes  number(16, 2);
    lc_cuo_mes  number(16, 2);
    lc_icv_mes  number(16, 2);
    lc_pen_mes  number(16, 2);
    lc_tsum_mes number(16, 2);
  
    lc_feccan date;
    --lc_ciiu4   char(5);
    lc_nro_pre char(20);
    lc_mda_pre char(2);
  
    lx_pepais NUMBER(3);
    lx_petdoc NUMBER(2);
    lx_pendoc CHAR(12);
  
    lc_ciiu6   number(9);
    lc_ciiu4   number(12);
    lc_nro_cuo number(9);
    lc_tea     number(10, 6);
  
    ln_cta number(9);
    ln_ope number(9);
    ln_cta116 number(9);
    ln_ope116 number(9);
    
    lb_ccob varchar2(50);
    lb_cren varchar2(50);
    lb_chon varchar2(50);
      
  
    lb_flag_vig  char(1);
    lb_fmax_anu  date;
    lb_flag_back number(3);
    lc_sdoins    number(17, 2);
    lc_nro_mes   number(3);
  
    lb_csol   aqpb379b.aqpb379bcsol%type;
    lb_ofon   aqpb379b.aqpb379bofon%type;
    lb_ncer   aqpb379b.aqpb379bncer%type;
    lb_idlin  aqpb379b.aqpb379bidlin%type;
    lb_fecof  aqpb379b.aqpb379bfecof%type;
    lb_moncof aqpb379b.aqpb379bmoncof%type;
    lb_ciiu   aqpb379b.aqpb379bciiu%type;
    lb_aeco   aqpb379b.aqpb379baeco%type;
    lb_finc   aqpb379b.aqpb379bfinc%type;
    lb_ffic   aqpb379b.aqpb379bffic%type;
    lb_pcob   aqpb379b.aqpb379bpcob%type;
  
    lx_fini_cre date;
    lx_ffin_cre date;
    lx_ncuopa   number(5);
    lx_ncuopp   number(5);
    lx_moneda   char(3);
    lx_tip      char(3);
    lx_por_err  number(10, 6);
    lx_tas_ini  number(10, 6);
    lx_sdo_cap  number(17, 2);
    lx_mon_117  number(17, 2);
    lx_fval_117 date;
    lx_fven_117 date;
    lx_mon_dis  number(17, 2);
  
    lc_dcon       char(4); -- 11. Situación contable
    lc_scon       char(20);
    lx_anio       char(4);
    lx_mes        char(2);
    lx_esf        char(11);
    lx_ncuo_tot   number(5);
    lx_ncuo_pag   number(5);
    lc_diatimp    number(5);
    lc_fecha_amot date;
    lc_cap_amort  number(17, 2);
  
    lc_lrep       char(2);
    lc_frep       date;
    lc_fulti_pago date;
    lc_fech_disp  date;
    --lx_mon_fecha  date;
    
    lc_eshonr char(1);
    ln_mhonr number(17,2);
    ld_fhonr date;
    ln_sdohon number(17,2);
    
    ln_tmor number;
    ld_fcest date;
    
    lc_cuo_n number;
    lc_cuo_o number;
    lc_fmant date;
    lc_sdoins_mant number(17,2);
    lc_prpago number(17,2);
    lc_pagrea number(17,2);
    lc_pramrt number(17,2);
    lc_pramrtx number(17,2);
    lc_vulcpa number(17,2);
    lc_vcprve number(17,2);
    lc_fuclpr date;
    lc_intcom number(17,2);
    lc_intcov number(17,2);
    lc_intmor number(17,2);
    lc_penali number(17,2);
    lc_gasm   number(17,2);
    lc_morm   number(17,2);
    lc_intm   number(17,2);
    lc_icvm   number(17,2);
    lc_penm   number(17,2);
    lc_tsumm  number(17,2);
    lc_capm   number(17,2); 
       
    cursor reporte_fagro is
    --- FAE AGRO VIGENTES
    
      select /*+index(P FSR011_IDX_20) index(T FSD01009) index(S SYS_C00982110)*/ t.pgcod, --- Clase 116: Empresa
             t.aomod, --- Clase 116: Módulo
             t.aosuc, --- Clase 116: Sucursal
             t.aomda, --- Clase 116: Moneda
             t.aopap, --- Clase 116: Papel
             t.aocta, --- Clase 116: Cuenta
             t.aooper, --- Clase 116: Operación
             t.aosbop, --- Clase 116: Suboperación
             t.aotope, --- Clase 116: Tipo de operación
             s.pepais,
             s.petdoc,
             s.pendoc,
             t.aoimp    monto,
             t.aotasa   tasa,
             t.aopzo    plazo,
             t.aofval,
             t.aofvto,
             t.aostat,
             t.aofe99,
             t.aoperiod,
             
             p.r2cod, --- Clase 117: Empresa
             p.r2mod, --- Clase 117: Módulo
             p.r2suc, --- Clase 117: Sucursal
             p.r2mda, --- Clase 117: Moneda
             p.r2pap, --- Clase 117: Papel
             p.r2cta, --- Clase 117: Cuenta
             p.r2oper, --- Clase 117: Operación
             p.r2sbop, --- Clase 117: Suboperación
             p.r2tope --- Clase 117: Tipo de operación
      
        from aqpb379b g 
        inner join fsr011 p on g.aqpb379bcod = p.r1cod and g.aqpb379bcta = p.r2cta
        inner join fsd010 t on t.pgcod  = p.r1cod 
         and t.aomod = p.r1mod
         --and t.aosuc = p.r1suc
         and t.aomda = p.r1mda
         and t.aopap = p.r1pap
         and t.aocta = p.r1cta
         and t.aooper = p.r1oper
         and t.aosbop = p.r1sbop
         and t.aotope = p.r1tope 
          inner join fsr008 s on s.pgcod = t.pgcod and  s.ctnro = t.aocta 
         
         where
      
      
       g.aqpb379bfec <= pn_ffin
       and g.aqpb379best ='I'-- <> 'D'
       
       --and p.r1mod = 116
       and p.r1tope in (1,20,550)
       --and p.r2mod = 117
       and p.r2tope in (1,20,550)
       and p.relcod = 46
       
       and t.aosuc = pc_sucurs
      
       and t.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
       and t.aofval <= pn_ffin
       --and t.aocta = 297143
      
       and (t.aostat <> 99 or (t.aostat = 99 and t.aofe99 > pn_ffin))
       and s.ttcod = 1
       and s.cttfir = 'T'
      
      union all
      
      --- FAE AGRO CANCELADO
      
      select /*+index(P FSR011_IDX_20) index(T SYS_C00977166) index(S SYS_C00982110)*/t.pgcod,
             t.aomod,
             t.aosuc,
             t.aomda,
             t.aopap,
             t.aocta,
             t.aooper,
             t.aosbop,
             t.aotope,
             s.pepais,
             s.petdoc,
             s.pendoc,
             t.aoimp    monto,
             t.aotasa   tasa,
             t.aopzo    plazo,
             t.aofval,
             t.aofvto,
             t.aostat,
             t.aofe99,
             t.aoperiod,
             
             p.r2cod,
             p.r2mod,
             p.r2suc,
             p.r2mda,
             p.r2pap,
             p.r2cta,
             p.r2oper,
             p.r2sbop,
             p.r2tope
      
        from aqpb379b g 
        inner join fsr011 p on g.aqpb379bcod = p.r1cod and g.aqpb379bcta = p.r2cta
        inner join fsd010 t on t.pgcod  = p.r1cod 
         and t.aomod = p.r1mod
         --and t.aosuc = p.r1suc
         and t.aomda = p.r1mda
         and t.aopap = p.r1pap
         and t.aocta = p.r1cta
         and t.aooper = p.r1oper
         and t.aosbop = p.r1sbop
         and t.aotope = p.r1tope 
          inner join fsr008 s on s.pgcod = t.pgcod and  s.ctnro = t.aocta 
         
       where
      
       g.aqpb379bfec <= pn_ffin
       and g.aqpb379best = 'I'--<> 'D'
       and p.r1mod = 116
       and p.r1tope in (1,20,550)
       and p.r2mod = 117
       and p.r2tope in (1,20,550)
       and p.relcod = 46
       
       and t.aosuc = pc_sucurs
             
       and t.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
       and t.aofval <= pn_ffin
       and t.aostat = 99
       and s.ttcod = 1
       and s.cttfir = 'T'
      
       and not exists
       (select 'x'
           from aqpb379b g
           inner join fsr011 p on p.r1cod = g.aqpb379bcod  and p.r2cta = g.aqpb379bcta 
                 and p.relcod = 46 and p.r1tope in (1,20,550) and p.r2tope in (1,20,550)
           inner join fsd010 l on p.r1cod = l.pgcod
             and p.r1mod = l.aomod
             --and p.r1suc = l.aosuc
             and p.r1mda = l.aomda
             and p.r1pap = l.aopap
             and p.r1cta = l.aocta
             and p.r1oper = l.aooper
             and p.r1sbop = l.aosbop
             and p.r1tope = l.aotope             
             where 1=1     
             and g.aqpb379bfec <= pn_ffin
             and g.aqpb379best ='I'    
             and l.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
             and l.aofval <= pn_ffin    
             and (l.aostat <> 99 or (l.aostat = 99 and l.aofe99 > pn_ffin))
             
               and l.pgcod = t.pgcod
                 --and l.aomod = t.aomod
                 and l.aomda = t.aomda
                 and l.aopap = t.aopap
                 and l.aocta = t.aocta
                 --and l.aooper = t.aooper
                 and l.aomod in (select modulo
                                   from fst111
                                  where dscod = 50
                                    and modulo not in (29, 120, 144))
                 and l.aostat <> 99)
       /*(select 'x'
          from fsd010 l
         where l.pgcod = t.pgcod
           and l.aomod = t.aomod
           and l.aomda = t.aomda
           and l.aopap = t.aopap
           and l.aocta = t.aocta
           and l.aooper = t.aooper
           and l.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
           and l.aostat <> 99)*/
      
       and (t.aofe99,t.AOSBOP) in
       (select  max(h.aofe99),max(h.AOSBOP)
          from fsd010 h
         where h.pgcod = t.pgcod
           and h.aomod = t.aomod
              --and h.aosuc = t.aosuc
           and h.aomda = t.aomda
           and h.aopap = t.aopap
           and h.aocta = t.aocta
           and h.aooper = t.aooper
              --and r.scsbop = t.aosbop
           --and h.aotope = t.aotope
           and h.aofe99 <= pn_ffin
           and h.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144)))
      
      ;
    
    cursor reporte_fagro_117 is
    
    --- FAE AGRO 117 VIGENTE
      select /*+index(T SYS_C00977166) index(S SYS_C00982110)*/
      --0       pgcod, --- Clase 116: Empresa
      --0       aomod, --- Clase 116: Módulo
      --0       aosuc, --- Clase 116: Sucursal
      --0       aomda, --- Clase 116: Moneda
      --0       aopap, --- Clase 116: Papel
      --0       aocta, --- Clase 116: Cuenta
      --0       aooper, --- Clase 116: Operación
      --0       aosbop, --- Clase 116: Suboperación
      --0       aotope, --- Clase 116: Tipo de operación
       s.pepais,
       s.petdoc,
       s.pendoc,
       t.aoimp    monto,
       t.aotasa   tasa,
       t.aopzo    plazo,
       t.aofval,
       t.aofvto,
       t.aostat,
       t.aofe99,
       t.aoperiod,
       
       t.pgcod  r2cod, --- Clase 117: Empresa
       t.aomod  r2mod, --- Clase 117: Módulo
       t.aosuc  r2suc, --- Clase 117: Sucursal
       t.aomda  r2mda, --- Clase 117: Moneda
       t.aopap  r2pap, --- Clase 117: Papel
       t.aocta  r2cta, --- Clase 117: Cuenta
       t.aooper r2oper, --- Clase 117: Operación
       t.aosbop r2sbop, --- Clase 117: Suboperación
       t.aotope r2tope --- Clase 117: Tipo de operación
      
        from fsr008 s,
             fsd010 t,
             --fsr011 p,
             aqpb379b g
             /*(select distinct u.aqpb379bcod, u.aqpb379bcta
                from aqpb379b u
               where u.aqpb379bcod = 1
                 and u.aqpb379bfec <= pn_ffin
                 and u.aqpb379best <> 'D') g*/
       where
      
      --- FSD010 // AQPB379B
       t.pgcod = g.aqpb379bcod
       and t.aocta = g.aqpb379bcta
       and g.aqpb379bfec <= pn_ffin
       and g.aqpb379best = 'I'--<> 'D'
       and t.pgcod = 1
       and t.aomod = 117
       and t.aotope in (20,550)
      
      --  FSD010 // FSR008
       and t.pgcod = s.pgcod
       and t.aosuc = pc_sucurs
       and t.aocta = s.ctnro
       --and t.aocta = 297143
       and t.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
       and t.aofval <= pn_ffin
      
       and (t.aostat <> 99 or (t.aostat = 99 and t.aofe99 > pn_ffin))
       and s.ttcod = 1
       and s.cttfir = 'T'
       
       and not exists (select /*+index(h FSR011_IDX_20)*/ 'x'
          from fsr011 h
         where h.r1cod = 1
           and h.r1cod = t.pgcod
           and h.r2mod = t.aomod
           and h.r2suc = t.aosuc
           and h.r2mda = t.aomda
           and h.r2pap = t.aopap
           and h.r2cta = t.aocta
           and h.r2oper = t.aooper  
           --and h.aosbop = t.aosbop -- jrodriguej 27.07.2021
           and h.r2tope = t.aotope
           
           and h.relcod = 46
           and h.r2mod = 117
           and h.r2tope in (20,550)
           
           )
 
     union all
      
      --- FAE AGRO 117 CANCELADO
      
      select /*+index(T SYS_C00977166) index(S SYS_C00982110)*/--null       pgcod,
      --null       aomod,
      --null       aosuc,
      --null       aomda,
      --null       aopap,
      --null       aocta,
      --null       aooper,
      --null       aosbop,
      --null       aotope,
       s.pepais,
       s.petdoc,
       s.pendoc,
       t.aoimp    monto,
       t.aotasa   tasa,
       t.aopzo    plazo,
       t.aofval,
       t.aofvto,
       t.aostat,
       t.aofe99,
       t.aoperiod,
       
       t.pgcod  r2cod,
       t.aomod  r2mod,
       t.aosuc  r2suc,
       t.aomda  r2mda,
       t.aopap  r2pap,
       t.aocta  r2cta,
       t.aooper r2oper,
       t.aosbop r2sbop,
       t.aotope r2tope
      
        from fsr008 s,
             fsd010 t,
             --fsr011 p,
             aqpb379b g
             /*(select distinct u.aqpb379bcod, u.aqpb379bcta
                from aqpb379b u
               where u.aqpb379bcod = 1
                 and u.aqpb379bfec <= pn_ffin
                 and u.aqpb379best <> 'D') g*/
       where
      
      --- FSR010 // AQPB379B
       t.pgcod = g.aqpb379bcod
       and t.aocta = g.aqpb379bcta
       and g.aqpb379bfec <= pn_ffin
       and g.aqpb379best ='I'--<> 'D'
       and t.pgcod = 1
       and t.aomod = 117
       and t.aotope in (20,550)
      
      --  FSD010 // FSR008
       and t.pgcod = s.pgcod
       and t.aosuc = pc_sucurs
       and t.aocta = s.ctnro
       --and t.aocta = 297143
       and t.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
       and t.aofval <= pn_ffin
       and t.aostat = 99
       and s.ttcod = 1
       and s.cttfir = 'T'
      
       and not exists (
         select /*+index(h FSR011_IDX_20)*/'x'
          from fsr011 h
         where h.r1cod = 1
           and h.r1cod = t.pgcod
           and h.r2mod = t.aomod
           and h.r2suc = t.aosuc
           and h.r2mda = t.aomda
           and h.r2pap = t.aopap
           and h.r2cta = t.aocta
           and h.r2oper = t.aooper  
           --and h.aosbop = t.aosbop -- jrodriguej 27.07.2021
           and h.r2tope = t.aotope
           
           and h.relcod = 46
           and h.r2mod = 117
           and h.r2tope in (20,550)
           
           )
      
       and not exists (select 'x'
          from fsd010 l
         where l.pgcod = t.pgcod
           and l.aomod = t.aomod --- 117
           and l.aomda = t.aomda
           and l.aopap = t.aopap
           and l.aocta = t.aocta
           and l.aooper = t.aooper
           and l.aotope = t.aotope ---20
              --and l.aomod = 117
              --and l.aotope = 20
           and l.aostat <> 99)
      
       and t.aofe99 = (select max(h.aofe99)
                     from fsd010 h
                    where h.pgcod = t.pgcod
                      and h.aomod = t.aomod -- 117
                         --and h.aosuc = t.aosuc
                      and h.aomda = t.aomda
                      and h.aopap = t.aopap
                      and h.aocta = t.aocta
                      and h.aooper = t.aooper
                         --and r.scsbop = t.aosbop
                      and h.aotope = t.aotope -- 20
                      and h.aofe99 <= pn_ffin)
      
      union all
      select /*+index(T SYS_C00977166) index(S SYS_C00982110)*/
       s.pepais,
       s.petdoc,
       s.pendoc,
       t.aoimp    monto,
       t.aotasa   tasa,
       t.aopzo    plazo,
       t.aofval,
       t.aofvto,
       t.aostat,
       t.aofe99,
       t.aoperiod,
       
       t.pgcod  r2cod, --- Clase 117: Empresa
       t.aomod  r2mod, --- Clase 117: Módulo
       t.aosuc  r2suc, --- Clase 117: Sucursal
       t.aomda  r2mda, --- Clase 117: Moneda
       t.aopap  r2pap, --- Clase 117: Papel
       t.aocta  r2cta, --- Clase 117: Cuenta
       t.aooper r2oper, --- Clase 117: Operación
       t.aosbop r2sbop, --- Clase 117: Suboperación
       t.aotope r2tope --- Clase 117: Tipo de operación
       
        from fsr008 s,
             fsd010 t,
             --fsr011 p,
             aqpb379b g
            
       where
      
      --- FSD010 // AQPB379B
       t.pgcod = g.aqpb379bcod
       and t.aocta = g.aqpb379bcta
       and g.aqpb379bfec <= pn_ffin
       and g.aqpb379best = 'I'--<> 'D'
       and t.pgcod = 1
       and t.aomod = 117
       and t.aotope in (20,550)
      
      --  FSD010 // FSR008
       and t.pgcod = s.pgcod
       and t.aosuc = pc_sucurs
       and t.aocta = s.ctnro       
       and t.aofval >= to_date('2021.01.01', 'yyyy.mm.dd') --'01/01/2021'
       and t.aofval <= pn_ffin
      
       and t.aostat IN (90,64)
       and s.ttcod = 1
       and s.cttfir = 'T'
      ;    
  
  
    cursor verificar_fae_agro is
      select x.aqpb379usur usur,
             x.aqpb379suc suc,
             x.aqpb379cta cta,
             x.aqpb379ope oper,
             x.aqpb379r1cta cta116,
             x.aqpb379r1ope oper116,
             count(*) total
        from aqpb379 x
       where x.aqpb379usur = pn_usuario
         and x.aqpb379suc = pc_sucurs
       group by x.aqpb379usur, x.aqpb379suc, x.aqpb379cta, x.aqpb379ope, x.aqpb379r1cta, x.aqpb379r1ope
      having count(*) > 1;
  
  begin
  
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into lc_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        lc_nro_mes := 1;
    end;
  
    -- 23. Fecha clasificación SBS 
    select to_date(t.tpnro, 'DDMMYY')
      into lc_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    -- 1. ESF RUC CAJA
    lx_esf := '20100209641';
    
    --fecha mes anterior
    lc_fmant := trunc(pn_ffin) - (to_number(to_char(pn_ffin, 'DD')));
  
    if pn_ffin <= lc_fecha_rcc then
      lc_fecha_rcc := last_day(add_months(trunc(pn_ffin), -1 * lc_nro_mes));
    end if;
  
    -- Fecha actual
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for j in reporte_fagro() loop
    
      ln_cta := j.aocta;
      ln_ope := j.aooper;
    
      -- 1. Información de Plantilla
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_plantilla_faeagro_v2(pn_cod => j.pgcod,
                                                           --pn_mod   => j.aomod,
                                                           --pn_suc   => j.aosuc,
                                                           --pn_mda   => j.aomda,
                                                           --pn_pap   => j.aopap,
                                                           pn_cta => j.aocta,
                                                           --pn_ope   => j.aooper,
                                                           --pn_sbo   => j.aosbop,
                                                           --pn_top   => j.aotope,
                                                           pn_fecha => pn_ffin,
                                                           
                                                           pn_csol   => lb_csol,
                                                           pn_ofon   => lb_ofon,
                                                           pn_ncer   => lb_ncer,
                                                           pn_idlin  => lb_idlin,
                                                           pn_fecof  => lb_fecof,
                                                           pn_moncof => lb_moncof,
                                                           pn_ciiu   => lb_ciiu,
                                                           pn_aeco   => lb_aeco,
                                                           pn_finc   => lb_finc,
                                                           pn_ffic   => lb_ffic,
                                                           pn_pcob   => lb_pcob,
                                                           pn_ccob   => lb_ccob,
                                                           pn_cren   => lb_cren,
                                                           pn_chon   => lb_chon);
      
      exception
        when others then
          lb_csol   := null;
          lb_ofon   := null;
          lb_ncer   := null;
          lb_idlin  := null;
          lb_fecof  := null;
          lb_moncof := null;
          lb_ciiu   := null;
          lb_aeco   := null;
          lb_finc   := null;
          lb_ffic   := null;
          lb_pcob   := null;
          lb_ccob   := null;
          lb_cren   := null;
          lb_chon   := null;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
    
      lx_anio := lpad(to_char(extract(year from pn_ffin)), 4, '0');
      lx_mes  := lpad(to_char(extract(month from pn_ffin)), 2, '0');
    
      -- 2. Moneda                      
      begin
        if j.aomda = 0 then
          lc_mda := 'PEN';
        else
          lc_mda := 'USD';
        end if;
      exception when others then null;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
      -- 3. Saldo Capital
    
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200  then
        begin
          -- Call the function
          lc_sdo_cap := pq_cr_reporte_fondofaeagro.fn_obtener_sdocap(pn_cod     => j.pgcod,
                                                                     pn_mod     => j.aomod,
                                                                     pn_suc     => j.aosuc,
                                                                     pn_mda     => j.aomda,
                                                                     pn_pap     => j.aopap,
                                                                     pn_cta     => j.aocta,
                                                                     pn_ope     => j.aooper,
                                                                     pn_sbo     => j.aosbop,
                                                                     pn_top     => j.aotope,
                                                                     pn_fecha   => pn_ffin,
                                                                     pn_usuario => pn_usuario);
        exception
          when others then
            lc_sdo_cap := 0;
        end;
      else
        lc_sdo_cap := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 16. Saldo insoluto
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_obtener_sald_insol2(pn_cod   => j.pgcod,
                                                            pn_mod   => j.aomod,
                                                            pn_suc   => j.aosuc,
                                                            pn_mda   => j.aomda,
                                                            pn_pap   => j.aopap,
                                                            pn_cta   => j.aocta,
                                                            pn_ope   => j.aooper,
                                                            pn_sbo   => j.aosbop,
                                                            pn_top   => j.aotope,
                                                            pn_fecha => pn_ffin,
                                                            pn_indi  => 1, -- FAE AGRO
                                                            pn_stat  => j.aostat,
                                                            pn_sald  => lc_sdoins);
        exception
          when others then
            lc_sdoins := 0;
        end;
      else
        lc_sdoins := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 16. Saldo insoluto anterior
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_obtener_sald_insol2(pn_cod   => j.pgcod,
                                                            pn_mod   => j.aomod,
                                                            pn_suc   => j.aosuc,
                                                            pn_mda   => j.aomda,
                                                            pn_pap   => j.aopap,
                                                            pn_cta   => j.aocta,
                                                            pn_ope   => j.aooper,
                                                            pn_sbo   => j.aosbop,
                                                            pn_top   => j.aotope,
                                                            pn_fecha => lc_fmant,
                                                            pn_indi  => 1, -- FAE AGRO
                                                            pn_stat  => j.aostat,
                                                            pn_sald  => lc_sdoins_mant);
        exception
          when others then
            lc_sdoins_mant := 0;
        end;
      else
        lc_sdoins_mant := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 38. Razon social
      lx_pepais := j.pepais;
      lx_petdoc := j.petdoc;
      lx_pendoc := j.pendoc;
    
      begin
        lc_razon := pq_cr_reporte_fondofaeagro.fn_obtener_nombre(lx_pepais,
                                                                 lx_petdoc,
                                                                 lx_pendoc);
      exception
        when others then
          lc_razon := '';
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
      -- 18. Tipo de credito SBS
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_tipo_credito_sbs_vig2( pn_cod   => j.pgcod,
                                                            pn_mod   => j.aomod,
                                                            pn_suc   => j.aosuc,
                                                            pn_mda   => j.aomda,
                                                            pn_pap   => j.aopap,
                                                            pn_cta   => j.aocta,
                                                            pn_ope   => j.aooper,
                                                            pn_sbo   => j.aosbop,
                                                            pn_top   => j.aotope,
                                                           pn_fecha   => pn_ffin,
                                                           pn_usuario => pn_usuario,
                                                           pn_ntipo   => lc_pcre_c,
                                                           pn_nconc   => lc_ncre);
      
        --- CASE
        --6=Corporativo;  10
        --7=Grande Emp;   11
        --8=Mediana Emp;  12
        --9=Pequeña Emp;  13
        --10=Microempresa  2
      
        case lc_pcre_c
          when 2 then
            lc_pcre := 10; --Microempresa
          when 10 then
            lc_pcre := 6; --Corporativo       
          when 11 then
            lc_pcre := 7; --Grande Emp   
          when 12 then
            lc_pcre := 8; --Mediana Emp 
          when 13 then
            lc_pcre := 9; --Pequeña Emp  
          else
            lc_pcre := 0;
        end case;
      
      exception
        when others then
          lc_pcre_c := '';
          lc_ncre   := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_calf(pn_tdoc   => lx_petdoc, --j.petdoc,
                                                   pn_ndoc   => lx_pendoc, --j.pendoc,
                                                   pn_fech   => pn_ffin,
                                                   pn_calif0 => lc_calif0,
                                                   pn_calif1 => lc_calif1,
                                                   pn_calif2 => lc_calif2,
                                                   pn_calif3 => lc_calif3,
                                                   pn_calif4 => lc_calif4,
                                                   pn_csbs   => lc_csbs);
      
      exception
        when others then
          lc_calif0 := 100;
          lc_calif1 := 0;
          lc_calif2 := 0;
          lc_calif3 := 0;
          lc_calif4 := 0;
          lc_csbs   := 0;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --              
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_calf_caja(pn_cod   => j.pgcod,
                                                        pn_mod   => j.aomod,
                                                        pn_suc   => j.aosuc,
                                                        pn_mda   => j.aomda,
                                                        pn_pap   => j.aopap,
                                                        pn_cta   => j.aocta,
                                                        pn_ope   => j.aooper,
                                                        pn_sbo   => j.aosbop,
                                                        pn_top   => j.aotope,
                                                        pn_est   => j.aostat,
                                                        pn_fecha => pn_ffin,
                                                        
                                                        pn_calif0a => lc_calif0a,
                                                        pn_calif1a => lc_calif1a,
                                                        pn_calif2a => lc_calif2a,
                                                        pn_calif3a => lc_calif3a,
                                                        pn_calif4a => lc_calif4a,
                                                        pn_deccaj  => lc_fecha_caj);
      exception
        when others then
          lc_calif0a   := 100;
          lc_calif1a   := 0;
          lc_calif2a   := 0;
          lc_calif3a   := 0;
          lc_calif4a   := 0;
          lc_fecha_caj := null;
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
      -- 33. Situacion contable
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_scond_c(pn_cod     => j.pgcod,
                                                      pn_mod     => j.aomod,
                                                      pn_suc     => j.aosuc,
                                                      pn_mda     => j.aomda,
                                                      pn_pap     => j.aopap,
                                                      pn_cta     => j.aocta,
                                                      pn_ope     => j.aooper,
                                                      pn_sbo     => j.aosbop,
                                                      pn_top     => j.aotope,
                                                      pn_fecha   => pn_ffin,
                                                      pn_est     => j.aostat,
                                                      pn_usuario => pn_usuario,
                                                      pn_rubr    => lc_dcon,
                                                      pn_resp    => lc_scon);
      exception
        when others then
          lc_dcon := '';
          lc_scon := '';
      end;
      
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
      --  monto prepago
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondos_p200.sp_distribuc_pago_mes(pn_cod => j.pgcod,
                                                          pn_mod => j.aomod,
                                                          pn_suc => j.aosuc,
                                                          pn_mda => j.aomda,
                                                          pn_pap => j.aopap,
                                                          pn_cta => j.aocta,
                                                          pn_ope => j.aooper,
                                                          pn_sbo => j.aosbop,
                                                          pn_top => j.aotope,
                                                          pn_fecha => pn_ffin,
                                                          pn_tsum => lc_tsum1,
                                                          pn_gas => lc_gas1,
                                                          pn_mor => lc_mor1,
                                                          pn_int => lc_int1,
                                                          pn_cuo => lc_prpago,
                                                          pn_icv => lc_icv1,
                                                          pn_pen => lc_pen1);
       /* pq_cr_reporte_fondos_p3.sp_obtener_mprepago(pn_cod     => j.pgcod,
                                                      pn_mod     => j.aomod,
                                                      pn_suc     => j.aosuc,
                                                      pn_mda     => j.aomda,
                                                      pn_pap     => j.aopap,
                                                      pn_cta     => j.aocta,
                                                      pn_ope     => j.aooper,
                                                      pn_sbo     => j.aosbop,
                                                      pn_top     => j.aotope,
                                                      pn_fecha   => pn_ffin,
                                                      pn_monto   => lc_prpago);
            */                                          
      exception
        when others then
          lc_prpago := 0;
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                        
      -- 41. Numero de prestamo
      if j.aomda = 0 then
        lc_mda_pre := '00';
      else
        lc_mda_pre := '01';
      end if;
    
      begin
        lc_nro_pre := concat(lpad(to_char(j.aocta), 9, '0'),
                             concat(lc_mda_pre,
                                    lpad(to_char(j.aooper), 9, '0')));
      exception
        when others then
          lc_nro_pre := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 10. Periodo de gracia
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          lc_pgra := pq_cr_reporte_fondofaeagro.fn_obtener_pgracia2(j.pgcod,
                                                                    j.aomod,
                                                                    j.aosuc,
                                                                    j.aomda,
                                                                    j.aopap,
                                                                    j.aocta,
                                                                    j.aooper,
                                                                    j.aosbop,
                                                                    j.aotope);
        exception
          when others then
            lc_pgra := 0;
        end;
      else
        lc_pgra := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_sucs(pn_sucs => j.aosuc,
                                                   pn_regi => lc_regi,
                                                   pn_zona => lc_zona,
                                                   pn_nsuc => lc_nsuc,
                                                   pn_nzon => lc_nzon,
                                                   pn_nreg => lc_nreg);
      exception
        when others then
          lc_regi := 0;
          lc_zona := 0;
          lc_nsuc := '';
          lc_nzon := '';
          lc_nreg := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
      -- 52. Analista
      begin
        lc_ases := fn_analista_credito(j.aomod,
                                       j.aosuc,
                                       j.aomda,
                                       j.aopap,
                                       j.aocta,
                                       j.aooper,
                                       j.aosbop,
                                       j.aotope);
      exception
        when others then
          lc_ases := '';
      end;      
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_distribuc_pago_acum(pn_cod   => j.pgcod,
                                                            pn_mod   => j.aomod,
                                                            pn_suc   => j.aosuc,
                                                            pn_mda   => j.aomda,
                                                            pn_pap   => j.aopap,
                                                            pn_cta   => j.aocta,
                                                            pn_ope   => j.aooper,
                                                            pn_sbo   => j.aosbop,
                                                            pn_top   => j.aotope,
                                                            pn_fecha => pn_ffin,
                                                            pn_tsum  => lc_tsum,
                                                            pn_gas   => lc_gas,
                                                            pn_mor   => lc_mor,
                                                            pn_int   => lc_int,
                                                            pn_cuo   => lc_cuo,
                                                            pn_icv   => lc_icv,
                                                            pn_pen   => lc_pen);
        
        exception
          when others then
          
            lc_tsum := 0;
            lc_gas  := 0;
            lc_mor  := 0;
            lc_int  := 0;
            lc_cuo  := 0;
            lc_icv  := 0;
            lc_pen  := 0;
        end;
      else
      
        lc_tsum := 0;
        lc_gas  := 0;
        lc_mor  := 0;
        lc_int  := 0;
        lc_cuo  := 0;
        lc_icv  := 0;
        lc_pen  := 0;
      end if;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 43. Numero de cuotas totales
      -- 44. Numero de cuotas pagadas
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_ncuotas_pagadas(pn_cod      => j.pgcod,
                                                        pn_mod      => j.aomod,
                                                        pn_suc      => j.aosuc,
                                                        pn_mda      => j.aomda,
                                                        pn_pap      => j.aopap,
                                                        pn_cta      => j.aocta,
                                                        pn_ope      => j.aooper,
                                                        pn_sbo      => j.aosbop,
                                                        pn_top      => j.aotope,
                                                        pn_fecha    => pn_ffin,
                                                        pn_ncuo_tot => lx_ncuo_tot,
                                                        pn_ncuo_pag => lx_ncuo_pag);
        
        exception
          when others then
            lx_ncuo_tot := 0;
            lx_ncuo_pag := 0;
        end;
      else
        lx_ncuo_tot := 0;
        lx_ncuo_pag := 0;
      end if;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 35. Dias atraso pago cuota
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_obtener_datraso_uimp(pn_cod   => j.pgcod,
                                                             pn_mod   => j.aomod,
                                                             pn_suc   => j.aosuc,
                                                             pn_mda   => j.aomda,
                                                             pn_pap   => j.aopap,
                                                             pn_cta   => j.aocta,
                                                             pn_ope   => j.aooper,
                                                             pn_sbo   => j.aosbop,
                                                             pn_top   => j.aotope,
                                                             pn_fecha => pn_ffin,
                                                             pn_diat  => lc_diatimp);
        exception
          when others then
            lc_diatimp := 0;
        end;
      else
        lc_diatimp := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 58. Estado credito descripcion
      begin
        lc_statd := pq_cr_reporte_fondofaeagro.fn_estado_desc(j.aostat);
      exception
        when others then
          lc_statd := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --              
      -- 55. Amortizacion
      -- 56. Fecha de Amortizacion
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_flag_amrtzn(pn_cod   => j.pgcod,
                                                    pn_mod   => j.aomod,
                                                    pn_suc   => j.aosuc,
                                                    pn_mda   => j.aomda,
                                                    pn_pap   => j.aopap,
                                                    pn_cta   => j.aocta,
                                                    pn_ope   => j.aooper,
                                                    pn_sbo   => j.aosbop,
                                                    pn_top   => j.aotope,
                                                    pn_fecha => pn_ffin,
                                                    pn_flarm => lc_lamr,
                                                    pn_fecrm => lc_fecha_amot);
        exception
          when others then
            lc_lamr       := 'NO';
            lc_fecha_amot := null;
        end;
      else
        lc_lamr       := 'NO';
        lc_fecha_amot := null;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 57. Monto amortizacion
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          pq_cr_reporte_fondofaeagro.sp_obtener_cap_amort(pn_cod    => j.pgcod,
                                                          pn_mod    => j.aomod,
                                                          pn_suc    => j.aosuc,
                                                          pn_mda    => j.aomda,
                                                          pn_pap    => j.aopap,
                                                          pn_cta    => j.aocta,
                                                          pn_ope    => j.aooper,
                                                          pn_sbo    => j.aosbop,
                                                          pn_top    => j.aotope,
                                                          pn_ord    => 10,
                                                          pn_fcorte => pn_ffin,
                                                          pn_impl   => lc_cap_amort);
        exception
          when others then
            lc_cap_amort := 0;
        end;
      else
        lc_cap_amort := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                    
      -- 59. Fecha ultimo pago realizado    
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
        
          pq_cr_reporte_fondofaeagro.sp_obtener_datos_ufecha(pn_cod   => j.pgcod,
                                                             pn_mod   => j.aomod,
                                                             pn_suc   => j.aosuc,
                                                             pn_mda   => j.aomda,
                                                             pn_pap   => j.aopap,
                                                             pn_cta   => j.aocta,
                                                             pn_ope   => j.aooper,
                                                             pn_sbo   => j.aosbop,
                                                             pn_top   => j.aotope,
                                                             pn_fecha => pn_ffin,
                                                             
                                                             pn_fpagu => lc_fupag, -- Fecha de la última cuota pagada: ppfpag
                                                             pn_fvenu => lc_fvenup); -- Fecha de vencimiento de la última cuota pagada
        exception
          when others then
            lc_fupag  := null;
            lc_fvenup := null;
        end;
      else
        lc_fupag  := null;
        lc_fvenup := null;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 53. Reprogramacion
      -- 54. Fecha de Reprogramacion    
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_reprog_datos(pn_cod   => j.pgcod,
                                                     pn_cta   => j.aocta,
                                                     pn_ope   => j.aooper,
                                                     pn_fecha => pn_ffin,
                                                     pn_flag  => lc_lrep,
                                                     pn_frep  => lc_frep);
        exception
          when others then
            lc_lrep := 'NO';
            lc_frep := null;
        end;
      else
        lc_lrep := 'NO';
        lc_frep := null;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 8.1 Monto desembolsado disposición   módulo: 117
      -- 45. Fecha Inicio de Linea
      -- 46. Fecha Fin de linea   
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_fsd010(pn_cod => j.r2cod,
                                                     pn_mod => j.r2mod,
                                                     pn_suc => j.r2suc,
                                                     pn_mda => j.r2mda,
                                                     pn_pap => j.r2pap,
                                                     pn_cta => j.r2cta,
                                                     pn_ope => j.r2oper,
                                                     pn_sbo => j.r2sbop,
                                                     pn_top => j.r2tope,
                                                     
                                                     pn_mdes => lx_mon_117,
                                                     pn_fval => lx_fval_117,
                                                     pn_fven => lx_fven_117);
      
      exception
        when others then
        
          lx_mon_117  := 0;
          lx_fval_117 := null;
          lx_fven_117 := null;
        
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Distribución de pago
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p200.sp_distribuc_pago_mes(pn_cod   => j.pgcod,
                                                           pn_mod   => j.aomod,
                                                           pn_suc   => j.aosuc,
                                                           pn_mda   => j.aomda,
                                                           pn_pap   => j.aopap,
                                                           pn_cta   => j.aocta,
                                                           pn_ope   => j.aooper,
                                                           pn_sbo   => j.aosbop,
                                                           pn_top   => j.aotope,
                                                           pn_fecha => pn_ffin,
                                                           pn_tsum  => lc_tsum_mes,
                                                           pn_gas   => lc_gas_mes,
                                                           pn_mor   => lc_mor_mes,
                                                           pn_int   => lc_int_mes,
                                                           pn_cuo   => lc_cuo_mes,
                                                           pn_icv   => lc_icv_mes,
                                                           pn_pen   => lc_pen_mes);
        
        exception
          when others then
          
            lc_tsum_mes := 0;
            lc_gas_mes  := 0;
            lc_mor_mes  := 0;
            lc_int_mes  := 0;
            lc_cuo_mes  := 0;
            lc_icv_mes  := 0;
            lc_pen_mes  := 0;
        end;
      else
        lc_tsum_mes := 0;
        lc_gas_mes  := 0;
        lc_mor_mes  := 0;
        lc_int_mes  := 0;
        lc_cuo_mes  := 0;
        lc_icv_mes  := 0;
        lc_pen_mes  := 0;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the function
          lc_fulti_pago := pq_cr_reporte_fondofaeagro.fn_fecha_upago(pn_cod   => j.pgcod,
                                                                     pn_mod   => j.aomod,
                                                                     pn_suc   => j.aosuc,
                                                                     pn_mda   => j.aomda,
                                                                     pn_pap   => j.aopap,
                                                                     pn_cta   => j.aocta,
                                                                     pn_ope   => j.aooper,
                                                                     pn_sbo   => j.aosbop,
                                                                     pn_top   => j.aotope,
                                                                     pn_fecha => pn_ffin);
        exception
          when others then
            lc_fulti_pago := null;
        end;
      else
        lc_fulti_pago := null;
      end if;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --             
      --8.1 Monto desembolsado disposición
      if j.aomod = 116 OR j.aomod = 33 OR j.aomod = 200 then
        begin
          -- Call the procedure
          pq_cr_reporte_fondofaeagro.sp_monto_disposicion(pn_cod     => j.pgcod,
                                                          pn_mod     => j.aomod,
                                                          pn_suc     => j.aosuc,
                                                          pn_mda     => j.aomda,
                                                          pn_pap     => j.aopap,
                                                          pn_cta     => j.aocta,
                                                          pn_ope     => j.aooper,
                                                          pn_sbo     => j.aosbop,
                                                          pn_top     => j.aotope,
                                                          pn_fini    => pn_fini,
                                                          pn_ffin    => pn_ffin,
                                                          pn_mont    => lx_mon_dis,
                                                          pn_fec_dis => lc_fech_disp);
        exception
          when others then
            lx_mon_dis   := 0;
            lc_fech_disp := null;
        end;
      else
        lx_mon_dis := 0;
      end if;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      
    
      begin
        lc_nro_cuo := j.plazo / 30;
      exception
        when others then
          lc_nro_cuo := 0;
      end;     
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
           begin
            -- Call the procedure 
            pq_cr_reporte_fondos_p3.sp_obtener_datoshonrado(pn_cod   => j.pgcod,
                                                           pn_mod   => j.aomod,
                                                           pn_suc   => j.aosuc,
                                                           pn_mda   => j.aomda,
                                                           pn_pap   => j.aopap,
                                                           pn_cta   => j.aocta,
                                                           pn_ope   => j.aooper,
                                                           pn_sbo   => j.aosbop,
                                                           pn_top   => j.aotope,
                                                           pn_rubr  => 9300082060000,
                                                           pd_fecha => pn_ffin,
                                                           pc_eshonr => lc_eshonr,
                                                           pn_mhonr => ln_mhonr,
                                                           pd_fhonr => ld_fhonr,
                                                           pn_sdohon => ln_sdohon);
          exception
            when others then
              lc_eshonr := '';
              ln_mhonr := 0;
              ld_fhonr := null;
              ln_sdohon := 0;
          end; 
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      begin
        pq_cr_reporte_fondos_p3.sp_obtener_tasa_moractual(pn_cod   => j.pgcod,
                                                           pn_mod   => j.aomod,
                                                           pn_suc   => j.aosuc,
                                                           pn_mda   => j.aomda,
                                                           pn_pap   => j.aopap,
                                                           pn_cta   => j.aocta,
                                                           pn_ope   => j.aooper,
                                                           pn_sbo   => j.aosbop,
                                                           pn_top   => j.aotope,                                                           
                                                           pn_fecha => pn_ffin,
                                                           pn_tasa => ln_tmor);
      exception
        when others then
          ln_tmor := 0;
      end;
      --------------------------------------------------------------------------
       begin
        pq_cr_reporte_fondos_p3.sp_obtener_fcamb_estado(pn_cod   => j.pgcod,
                                                           pn_mod   => j.aomod,
                                                           pn_suc   => j.aosuc,
                                                           pn_mda   => j.aomda,
                                                           pn_pap   => j.aopap,
                                                           pn_cta   => j.aocta,
                                                           pn_ope   => j.aooper,
                                                           pn_sbo   => j.aosbop,
                                                           pn_top   => j.aotope,                                                           
                                                           pd_fecha => pn_ffin,
                                                           pd_fcest => ld_fcest);
      exception
        when others then
          ld_fcest := null;
      end;
      --------------------------------------------------------------------------
      --  Número de cuotas crono actual
            begin
              lc_cuo_n := pq_cr_reporte_fondos_p3.fn_fecha_ncuoa(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope);
            exception
              when others then
                lc_cuo_n := 0;
            end;
      --------------------------------------------------------------------------
      --  Número de cuotas crono original
            begin
              lc_cuo_o := pq_cr_reporte_fondos_p3.fn_fecha_ncuoi(pn_cod => j.pgcod,

                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope);
            exception
              when others then
                lc_cuo_o := 0;
            end;
      --------------------------------------------------------------------------
      --  Pago realizado y principal amortizado
            begin
              pq_cr_reporte_fondos_p3.sp_distribuc_pago_mes_pa(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_tsum => lc_pagrea,
                                                                 pn_gas => lc_gasm,
                                                                 pn_mor => lc_morm,
                                                                 pn_int => lc_intm,
                                                                 pn_cuo => lc_pramrtx,
                                                                 pn_icv => lc_icvm,
                                                                 pn_pen => lc_penm,
                                                                 pn_pamr =>lc_pramrt);
            exception
              when others then
                lc_pagrea := 0;
                lc_pramrt := 0;
            end;
      --------------------------------------------------------------------------
      --  Valores cuota pagada y proxima
            begin
              pq_cr_reporte_fondos_p3.sp_obtener_valorcuotas(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_vulcpa => lc_vulcpa,
                                                                 pn_vcprve => lc_vcprve,
                                                                 pn_fuclpa => lc_fuclpr);
            exception
              when others then
                lc_vulcpa := 0;
                lc_vcprve := 0;
                lc_fuclpr := null;
            end;
      --------------------------------------------------------------------------
      --  Pago intereses compe,mora, penalidad acumulDO
            begin
              pq_cr_reporte_fondos_p3.sp_obtener_montos_rmora(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_int => lc_intm,
                                                                 pn_mor => lc_morm,
                                                                 pn_icv => lc_icvm,
                                                                 pn_pen => lc_penm);
            exception
              when others then
                lc_intm := 0;
                lc_icvm := 0;
                lc_morm := 0;
                lc_penm := 0;
            end;
      --------------------------------------------------------------------------
      begin
        insert into aqpb379
          (aqpb379usur, -- Usuario
           aqpb379pgcod, -- Código de empresa
           aqpb379mod, -- Módulo
           aqpb379suc, -- Sucursal
           aqpb379mda, -- Moneda 
           aqpb379pap, -- Papel 
           aqpb379cta, -- Cuenta 
           aqpb379ope, -- Operación
           aqpb379sbo, -- Suboperación
           aqpb379top, -- Tipo de operación
           
           aqpb379anio, -- 1. Año
           aqpb379mes, -- 2. Mes
           aqpb379tdoc, -- 3. Tipo de documento
           aqpb379ndoc, -- 4. Numero de documento
           aqpb379csol, -- 5. Codigo solicitud
           aqpb379esfco, -- 6. ESF/COOPAC
           aqpb379ofon, -- 7. Origen fondos
           aqpb379mondes, -- 8. Monto desembolsado cupo principal
           aqpb379mondis, -- 8.1 Monto desembolsado disposición
           aqpb379pzo, -- 9. Plazo
           aqpb379pgra, -- 10. Periodo de gracia
           aqpb379ncer, -- 11. Numero certificado
           aqpb379idlin, -- 12. Id Linea
           aqpb379fdesp, -- 13. Fecha de desembolso prestamo
           aqpb379moned, -- 14. Moneda
           aqpb379sdocap, -- 15. Saldo Capital Pendiente
           aqpb379sdoins, -- 16. Saldo insoluto
           aqpb379monpre, -- 17. Monto prepago
           aqpb379tcre, -- 18. Tipo de credito SBS
           aqpb379ncre, -- 19. Tipo de credito SBS concepto
           aqpb379csbs, -- 20. Codigo de cliente SBS
           aqpb379fcal, -- 21. Fecha de Calificacion actualizada
           aqpb379canom, -- 22. Calificacion normal
           aqpb379cacpp, -- 23. Calificacion CPP
           aqpb379cadef, -- 24. Calificacion Deficiente
           aqpb379cadud, -- 25. Calificacion dudosa
           aqpb379caper, -- 26. Calificacion perdida
           aqpb379fcla, -- 27. Fecha de clasificacion interna caja
           aqpb379clnom, -- 28. Clasificacion Normal
           aqpb379clcpp, -- 29. Clasificacion CPP
           aqpb379cldef, -- 30. Clasificacion deficiente
           aqpb379cldud, -- 31. Clasificacion dudosa
           aqpb379clper, -- 32. Clasificacion perdida
           aqpb379sitcon, -- 33. Situacion contable
           aqpb379sitconc, -- 34. Situacion contable concepto
           aqpb379datrcuo, -- 35. Dias atraso pago cuota
           aqpb379fprepa, -- 36. fecha prepago
           aqpb379tspre, -- 37. Tasa subprestamo
           aqpb379razn, -- 38. Razon social
           aqpb379ciiu, -- 39. CIIU
           aqpb379aeco, -- 40. Actividad Economica
           aqpb379npre, -- 41. Numero de prestamo
           aqpb379frepa, -- 42. frecuencia de pago
           aqpb379ncuot, -- 43. Numero de cuotas totales
           aqpb379ncuop, -- 44. Numero de cuotas pagadas
           aqpb379finl, -- 45. Fecha Inicio de Linea
           aqpb379ffil, -- 46. Fecha Fin de linea
           aqpb379finc, -- 47. Fecha Inicio de Certificado
           aqpb379ffic, -- 48. Fecha Fin de Certificado
           aqpb379reg, -- 49. Region
           aqpb379nreg, -- 49.1. Region Nombre
           aqpb379zon, -- 50 Zona
           aqpb379nzon, -- 50.1. Zona Nombre
           aqpb379nsuc, -- 51.1. Agencia Sucursal Nombre
           aqpb379ase, -- 52. Analista
           aqpb379repro, -- 53. Reprogramacion
           aqpb379frepro, -- 54. Fecha de Reprogramacion
           aqpb379amort, -- 55. Amortizacion
           aqpb379famor, -- 56. Fecha de Amortizacion
           aqpb379mamor, -- 57. Monto amortizacion
           aqpb379nestcre, -- 58. Estado credito descripcion
           aqpb379fulpa, -- 59. Fecha ultimo pago realizado
           aqpb379monpag, -- 60. Monto pagado
           aqpb379cappag, -- 61. Capital pagado
           aqpb379incomp, -- 62. Interes compensatorio pagado
           aqpb379inmora, -- 63. Interes moratorio pagado
           aqpb379inte, -- 64. Interes
           aqpb379segu, -- 65. Seguros
           aqpb379pena, -- 66. Penalidades
           aqpb379pcob, -- 67. % de Cobertura
           
           aqpb379r1cod, --- Clave 117: Empresa
           aqpb379r1mod, --- Clave 117: Módulo
           aqpb379r1suc, --- Clave 117: Sucursal
           aqpb379r1mda, --- Clave 117: Moneda
           aqpb379r1pap, --- Clave 117: Papel
           aqpb379r1cta, --- Clave 117: Cuenta
           aqpb379r1ope, --- Clave 117: Operación
           aqpb379r1sbo, --- Clave 117: Suboperación
           aqpb379r1top, --- Clave 117: Tipo de operación             sdocaph
           
           aqpb379stat, -- Estado de Credito
           aqpb379fe99, -- Fecha de Cancelacion
           aqpb379fproc, -- Fecha de Proceso
           aqpb379fcrea, -- Fecha de Creacion
           aqpb379hcrea, -- Hora de creacion
           aqpb379mhonr,
               aqpb379fhonr,
               aqpb379chonr,
               aqpb379sdocaph,
               aqpb379sdohon,
               aqpb379crehon,
               aqpb379tmor,
               aqpb379moncob,  
               aqpb379fcest,
               aqpb379ccob,
               aqpb379cren,
               aqpb379chon,
               aqpb379sinsap,
              aqpb379prpago,
              aqpb379pagrea,
              aqpb379pramrt,
              aqpb379nrccor,
              aqpb379nrccac,
              aqpb379vulcpa,
              aqpb379vcprve,
              aqpb379fuclpr,
              aqpb379intcom,
              aqpb379intcov,
              aqpb379intmor,
              aqpb379penali 
           )
        
        values
          (pn_usuario,
           
           j.r2cod,
           j.r2mod,
           j.r2suc,
           j.r2mda,
           j.r2pap,
           j.r2cta,
           j.r2oper,
           j.r2sbop,
           j.r2tope,
           
           lx_anio, -- 1. Año
           lx_mes, -- 2. Mes
           j.petdoc, -- 3. Tipo de documento
           j.pendoc, -- 4. Numero de documento
           lb_csol, -- 5. Codigo solicitud
           lx_esf, -- 6. ESF/COOPAC
           lb_ofon, -- 7. Origen fondos
           lx_mon_117, -- 8. Monto desembolsado cupo principal, módulo 117
           lx_mon_dis, --j.monto, -- 8.1 Monto desembolsado disposición, módulo 116
           lc_nro_cuo, --j.plazo, -- 9. Plazo, módulo 116
           lc_pgra, -- 10. Periodo de gracia, módulo 116
           lb_ncer, -- 11. Numero certificado
           lb_idlin, -- 12. Id Linea
           lc_fech_disp, --j.aofval, -- 13. Fecha de desembolso prestamo, módulo 116
           lc_mda, -- 14. Moneda
           lc_sdo_cap, -- 15. Saldo Capital Pendiente, módulo 116
           lc_sdoins, -- 16. Saldo insoluto, módulo 116
           lc_cuo_mes, -- 17. Monto prepago, capital cancelado en el mes actual, módulo 116
           lc_pcre, -- 18. Tipo de credito SBS
           substr(trim(lc_ncre), 1, 50), -- 19. Tipo de credito SBS concepto
           lc_csbs, -- 20. Codigo de cliente SBS
           lc_fecha_rcc, -- 21. Fecha de Calificacion actualizada           
           lc_calif0, -- 22. Calificacion normal
           lc_calif1, -- 23. Calificacion CPP
           lc_calif2, -- 24. Calificacion Deficiente
           lc_calif3, -- 25. Calificacion dudosa
           lc_calif4, -- 26. Calificacion perdida           
           lc_fecha_caj, -- 27. Fecha de clasificacion interna caja
           lc_calif0a, -- 28. Clasificacion Normal
           lc_calif1a, -- 29. Clasificacion CPP
           lc_calif2a, -- 30. Clasificacion deficiente
           lc_calif3a, -- 31. Clasificacion dudosa
           lc_calif4a, -- 32. Clasificacion perdida
           substr(trim(lc_dcon), 1, 4), -- 33. Situacion contable
           substr(trim(lc_scon), 1, 20), -- 34. Situacion contable concepto
           lc_diatimp, -- 35. Dias atraso pago cuota impaga, módulo 116
           lc_fulti_pago, -- 36. fecha prepago, módulo 116
           j.tasa, -- 37. Tasa subprestamo, módulo 116
           lc_razon, -- 38. Razon social
           lb_ciiu, -- 39. CIIU
           lb_aeco, -- 40. Actividad Economica
           lc_nro_pre, -- 41. Numero de prestamo
           j.aoperiod, -- 42. frecuencia de pago, módulo 116
           lx_ncuo_tot, -- 43. Numero de cuotas totales, módulo 116
           lx_ncuo_pag, -- 44. Numero de cuotas pagadas, módulo 116          
           lx_fval_117, -- 45. Fecha Inicio de Linea, módulo 117
           lx_fven_117, -- 46. Fecha Fin de linea, módulo 117
           lb_finc, -- 47. Fecha Inicio de Certificado
           lb_ffic, -- 48. Fecha Fin de Certificado
           lc_regi, -- 49. Region
           substr(trim(lc_nreg), 1, 30), -- 49.1. Region Nombre
           lc_zona, -- 50. Zona
           substr(trim(lc_nzon), 1, 40), -- 50.1 Zona Nombre
           substr(trim(lc_nsuc), 1, 30), -- 51.1 Agencia Sucursal Nombre
           lc_ases, -- 52. Analista
           lc_lrep, -- 53. Reprogramacion, módulo 116
           lc_frep, -- 54. Fecha de Reprogramacion, módulo 116
           lc_lamr, -- 55. Amortizacion, módulo 116
           lc_fecha_amot, -- 56. Fecha de Amortizacion, módulo 116
           lc_cap_amort, -- 57. Monto amortizacion, módulo 116
           lc_statd, -- 58. Estado credito descripcion
           lc_fupag, -- 59. Fecha ultimo pago realizado, módulo 116
           lc_tsum, -- 60. Monto pagado, módulo 116
           lc_cuo, -- 61. Capital pagado, módulo 116
           lc_icv, -- 62. Interes compensatorio pagado, módulo 116
           lc_mor, -- 63. Interes moratorio pagado, módulo 116
           lc_int, -- 64. Interes, módulo 116
           lc_gas, -- 65. Seguros, módulo 116
           lc_pen, -- 66. Penalidades, módulo 116  
           lb_pcob, -- 67. % de Cobertura
           
           j.pgcod,
           j.aomod,
           j.aosuc, -- Agencia (Sucursal)
           j.aomda,
           j.aopap,
           j.aocta, -- Nro. de Cuenta
           j.aooper, -- Nro. de Operación  
           j.aosbop,
           j.aotope,
           
           j.aostat, -- Estado de Credito
           j.aofe99, -- Fecha de Cancelacion
           pn_ffin, -- Fecha de Proceso
           to_char(sysdate, 'DD/MM/YYYY'), -- Fecha de Creacion
           to_char(sysdate, 'HH24:MI:SS'), -- Hora de creacion
           ln_mhonr, --monto honrado
               ld_fhonr,--fecha honramiento
               lc_eshonr,--es honrado
               lc_sdo_cap,
               nvl(ln_sdohon,0),
               lc_sdo_cap + nvl(ln_sdohon,0),
               ln_tmor, --tasa interes moratorio
               case when j.aostat = 99 and pn_ffin >= j.aofe99 then 0 else lc_sdoins*lb_pcob/100 end, --monto coberturado
               case when ld_fcest > nvl(j.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                 (case when ld_fcest > nvl(lc_frep,to_date('01/01/0001','DD/MM/YYYY')) then ld_fcest else lc_frep end )
                 else (case when nvl(lc_frep,to_date('01/01/0001','DD/MM/YYYY')) > nvl(j.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then lc_frep else j.aofe99 end )end, --fecha de cambio de estado
               lb_ccob,
               lb_cren,
               lb_chon,
               lc_sdoins_mant, --saldo insoluto antes del prepago 
            lc_prpago, --prepago
            lc_pagrea, -- pago realizado
            lc_pramrt, --principal amortizado
            lc_cuo_o, --numero de cuotas creditos original
            lc_cuo_n, --numero ce cuotas credito actual
            lc_vulcpa, --valor ultima cuota pagada
            lc_vcprve, --valor cuota proximo vencimiento
            lc_fuclpr, -- Nueva fecha de la ultima cuota luego del prepago,
            lc_intm, --interes compensatorio
            lc_icvm, --interes compensatorio vencido
            lc_morm, --interes moratorio
            lc_penm --penalidad
           );
      
        commit;
      
      exception
        when others then
        
          lc_coderr := substr(trim(sqlcode), 1, 100);
          lc_msgerr := substr(trim(sqlerrm), 1, 1000);
        
          begin
            insert into AQPB070E
              (aqpb070etab,
               aqpb070efec,
               aqpb070esuc,
               aqpb070eusr,
               aqpb070ecoe,
               aqpb070emsge,
               aqpb070efcr,
               aqpb070ehcr,
               aqpb070ecta,
               aqpb070eope)
            values
              ('AQPB379',
               pn_ffin,
               pc_sucurs,
               substr(trim(pn_usuario), 1, 10),
               lc_coderr,
               lc_msgerr,
               to_char(sysdate, 'DD/MM/YYYY'),
               to_char(sysdate, 'HH24:MI:SS'),
               ln_cta,
               ln_ope);
            commit;
          exception
            when others then
              null;
          end;
        
      end;
    
    end loop;
  
    for k in reporte_fagro_117() loop
    
      ln_cta := k.r2cta;
      --ln_ope := k.aooper;
    
      -- 1. Información de Plantilla
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_plantilla_faeagro_v2(pn_cod   => k.r2cod,
                                                           pn_cta   => k.r2cta,
                                                           pn_fecha => pn_ffin,
                                                           
                                                           pn_csol   => lb_csol,
                                                           pn_ofon   => lb_ofon,
                                                           pn_ncer   => lb_ncer,
                                                           pn_idlin  => lb_idlin,
                                                           pn_fecof  => lb_fecof,
                                                           pn_moncof => lb_moncof,
                                                           pn_ciiu   => lb_ciiu,
                                                           pn_aeco   => lb_aeco,
                                                           pn_finc   => lb_finc,
                                                           pn_ffic   => lb_ffic,
                                                           pn_pcob   => lb_pcob,
                                                           pn_ccob   => lb_ccob,
                                                           pn_cren   => lb_cren,
                                                           pn_chon   => lb_chon);
      
      exception
        when others then
          lb_csol   := null;
          lb_ofon   := null;
          lb_ncer   := null;
          lb_idlin  := null;
          lb_fecof  := null;
          lb_moncof := null;
          lb_ciiu   := null;
          lb_aeco   := null;
          lb_finc   := null;
          lb_ffic   := null;
          lb_pcob   := null;
          lb_ccob   := null;
          lb_cren   := null;
          lb_chon   := null;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
    
      lx_anio := lpad(to_char(extract(year from pn_ffin)), 4, '0');
      lx_mes  := lpad(to_char(extract(month from pn_ffin)), 2, '0');
    
      -- 2. Moneda                      
      begin
        if k.r2mda = 0 then
          lc_mda := 'PEN';
        else
          lc_mda := 'USD';
        end if;
      exception when others then null;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
      -- 3. Saldo Capital, solo 116
      lc_sdo_cap := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 16. Saldo insoluto, solo 116
      lc_sdoins := 0;
      lc_sdoins_mant := 0;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 38. Razon social
      lx_pepais := k.pepais;
      lx_petdoc := k.petdoc;
      lx_pendoc := k.pendoc;
    
      begin
        lc_razon := pq_cr_reporte_fondofaeagro.fn_obtener_nombre(lx_pepais,
                                                                 lx_petdoc,
                                                                 lx_pendoc);
      exception
        when others then
          lc_razon := '';
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
      
      --if k.r2cta = 2386815 and k.r2oper = 11348185 then
      --  null;
      --end if;
      
      -- 18. Tipo de credito SBS
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_tipo_credito_sbs_vig_117(pn_cod     => k.r2cod,
                                                           pn_mod     => k.r2mod,
                                                           pn_suc     => k.r2suc,
                                                           pn_mda     => k.r2mda,
                                                           pn_pap     => k.r2pap,
                                                           pn_cta     => k.r2cta,
                                                           pn_ope     => k.r2oper,
                                                           pn_sbo     => k.r2sbop,
                                                           pn_top     => k.r2tope,
                                                           pn_fecha   => pn_ffin,
                                                           pn_usuario => pn_usuario,
                                                           pn_ntipo   => lc_pcre_c,
                                                           pn_nconc   => lc_ncre);
      
        --- CASE
        --6=Corporativo;  10
        --7=Grande Emp;   11
        --8=Mediana Emp;  12
        --9=Pequeña Emp;  13
        --10=Microempresa  2
      
        case lc_pcre_c
          when 2 then
            lc_pcre := 10; --Microempresa
          when 10 then
            lc_pcre := 6; --Corporativo       
          when 11 then
            lc_pcre := 7; --Grande Emp   
          when 12 then
            lc_pcre := 8; --Mediana Emp 
          when 13 then
            lc_pcre := 9; --Pequeña Emp  
          else
            lc_pcre := 0;
        end case;
      
      exception
        when others then
          lc_pcre_c := '';
          lc_ncre   := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_calf(pn_tdoc   => lx_petdoc, --j.petdoc,
                                                   pn_ndoc   => lx_pendoc, --j.pendoc,
                                                   pn_fech   => pn_ffin,
                                                   pn_calif0 => lc_calif0,
                                                   pn_calif1 => lc_calif1,
                                                   pn_calif2 => lc_calif2,
                                                   pn_calif3 => lc_calif3,
                                                   pn_calif4 => lc_calif4,
                                                   pn_csbs   => lc_csbs);
      
      exception
        when others then
          lc_calif0 := 100;
          lc_calif1 := 0;
          lc_calif2 := 0;
          lc_calif3 := 0;
          lc_calif4 := 0;
          lc_csbs   := 0;
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --              
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_calf_caja(pn_cod   => k.r2cod,
                                                        pn_mod   => k.r2mod,
                                                        pn_suc   => k.r2suc,
                                                        pn_mda   => k.r2mda,
                                                        pn_pap   => k.r2pap,
                                                        pn_cta   => k.r2cta,
                                                        pn_ope   => k.r2oper,
                                                        pn_sbo   => k.r2sbop,
                                                        pn_top   => k.r2tope,
                                                        pn_est   => k.aostat,
                                                        pn_fecha => pn_ffin,
                                                        
                                                        pn_calif0a => lc_calif0a,
                                                        pn_calif1a => lc_calif1a,
                                                        pn_calif2a => lc_calif2a,
                                                        pn_calif3a => lc_calif3a,
                                                        pn_calif4a => lc_calif4a,
                                                        pn_deccaj  => lc_fecha_caj);
      exception
        when others then
          lc_calif0a   := 100;
          lc_calif1a   := 0;
          lc_calif2a   := 0;
          lc_calif3a   := 0;
          lc_calif4a   := 0;
          lc_fecha_caj := null;
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
      -- 33. Situacion contable
      /*
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_scond_c(pn_cod     => k.r2cod,
                                                      pn_mod     => k.r2mod,
                                                      pn_suc     => k.r2suc,
                                                      pn_mda     => k.r2mda,
                                                      pn_pap     => k.r2pap,
                                                      pn_cta     => k.r2cta,
                                                      pn_ope     => k.r2oper,
                                                      pn_sbo     => k.r2sbop,
                                                      pn_top     => k.r2tope,
                                                      pn_fecha   => pn_ffin,
                                                      pn_est     => k.aostat,
                                                      pn_usuario => pn_usuario,
                                                      pn_rubr    => lc_dcon,
                                                      pn_resp    => lc_scon);
      exception
        when others then
          lc_dcon := '';
          lc_scon := '';
      end;
      */
    
      if k.aostat <> 99 then
        lc_dcon := '1411';
        lc_scon := 'VGT';
      else
        lc_dcon := '';
        lc_scon := '';
      end if;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                        
      -- 41. Numero de prestamo
      if k.r2mda = 0 then
        lc_mda_pre := '00';
      else
        lc_mda_pre := '01';
      end if;
    
      begin
        lc_nro_pre := concat(lpad(to_char(k.r2cta), 9, '0'),
                             concat(lc_mda_pre,
                                    lpad(to_char(k.r2oper), 9, '0')));
      exception
        when others then
          lc_nro_pre := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 10. Periodo de gracia, solo 116
      lc_pgra := 0;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_sucs(pn_sucs => k.r2suc,
                                                   pn_regi => lc_regi,
                                                   pn_zona => lc_zona,
                                                   pn_nsuc => lc_nsuc,
                                                   pn_nzon => lc_nzon,
                                                   pn_nreg => lc_nreg);
      exception
        when others then
          lc_regi := 0;
          lc_zona := 0;
          lc_nsuc := '';
          lc_nzon := '';
          lc_nreg := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
      -- 52. Analista
      begin
        lc_ases := fn_analista_credito(k.r2mod,
                                       k.r2suc,
                                       k.r2mda,
                                       k.r2pap,
                                       k.r2cta,
                                       k.r2oper,
                                       k.r2sbop,
                                       k.r2tope);
      exception
        when others then
          lc_ases := '';
      end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 
      -- Pagos acumulados, solo 116
      lc_tsum := 0;
      lc_gas  := 0;
      lc_mor  := 0;
      lc_int  := 0;
      lc_cuo  := 0;
      lc_icv  := 0;
      lc_pen  := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 43. Numero de cuotas totales, solo 116
      -- 44. Numero de cuotas pagadas, solo 116
      lx_ncuo_tot := 0;
      lx_ncuo_pag := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 35. Dias atraso pago cuota, solo 116
      lc_diatimp := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 58. Estado credito descripcion
      begin
        lc_statd := pq_cr_reporte_fondofaeagro.fn_estado_desc(k.aostat);
      exception
        when others then
          lc_statd := '';
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --              
      -- 55. Amortizacion, solo 116
      -- 56. Fecha de Amortizacion, solo 116
      lc_lamr       := 'NO';
      lc_fecha_amot := null;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 57. Monto amortizacion, solo 116
      lc_cap_amort := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                    
      -- 59. Fecha ultimo pago realizado, solo 116
      lc_fupag  := null;
      lc_fvenup := null;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- 53. Reprogramacion, solo 116
      -- 54. Fecha de Reprogramacion, solo 116
      lc_lrep := 'NO';
      lc_frep := null;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
      -- 8.1 Monto desembolsado disposición   módulo: 117
      -- 45. Fecha Inicio de Linea
      -- 46. Fecha Fin de linea   
      begin
        -- Call the procedure
        pq_cr_reporte_fondofaeagro.sp_obtener_fsd010(pn_cod => k.r2cod,
                                                     pn_mod => k.r2mod,
                                                     pn_suc => k.r2suc,
                                                     pn_mda => k.r2mda,
                                                     pn_pap => k.r2pap,
                                                     pn_cta => k.r2cta,
                                                     pn_ope => k.r2oper,
                                                     pn_sbo => k.r2sbop,
                                                     pn_top => k.r2tope,
                                                     
                                                     pn_mdes => lx_mon_117,
                                                     pn_fval => lx_fval_117,
                                                     pn_fven => lx_fven_117);
      
      exception
        when others then
        
          lx_mon_117  := 0;
          lx_fval_117 := null;
          lx_fven_117 := null;
        
      end;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- Distribución de pago, solo 116
      lc_tsum_mes := 0;
      lc_gas_mes  := 0;
      lc_mor_mes  := 0;
      lc_int_mes  := 0;
      lc_cuo_mes  := 0;
      lc_icv_mes  := 0;
      lc_pen_mes  := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
      -- Ultimo Pago, solo 116
      lc_fulti_pago := null;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --             
      --8.1 Monto desembolsado disposición, solo 116
      lx_mon_dis := 0;
    
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --             
      --9. Plazo, módulo 116 
      lc_nro_cuo := 0;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
           begin
            -- Call the procedure 
            pq_cr_reporte_fondos_p3.sp_obtener_datoshonrado(pn_cod   => k.r2cod,
                                                           pn_mod   => k.r2mod,
                                                           pn_suc   => k.r2suc,
                                                           pn_mda   => k.r2mda,
                                                           pn_pap   => k.r2pap,
                                                           pn_cta   => k.r2cta,
                                                           pn_ope   => k.r2oper,
                                                           pn_sbo   => k.r2sbop,
                                                           pn_top   => k.r2tope,
                                                           pn_rubr  => 9300082060000,
                                                           pd_fecha => pn_ffin,
                                                           pc_eshonr => lc_eshonr,
                                                           pn_mhonr => ln_mhonr,
                                                           pd_fhonr => ld_fhonr,
                                                           pn_sdohon => ln_sdohon);
          exception
            when others then
              lc_eshonr := '';
              ln_mhonr := 0;
              ld_fhonr := null;
              ln_sdohon := 0;
          end; 
       -- solo 116
       /*ln_mhonr := 0;
       
       ln_sdohon := 0;   */
          
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                   
      begin
        pq_cr_reporte_fondos_p3.sp_obtener_tasa_moractual(pn_cod   => k.r2cod,
                                                           pn_mod   => k.r2mod,
                                                           pn_suc   => k.r2suc,
                                                           pn_mda   => k.r2mda,
                                                           pn_pap   => k.r2pap,
                                                           pn_cta   => k.r2cta,
                                                           pn_ope   => k.r2oper,
                                                           pn_sbo   => k.r2sbop,
                                                           pn_top   => k.r2tope,                                                         
                                                           pn_fecha => pn_ffin,
                                                           pn_tasa => ln_tmor);
      exception
        when others then
          ln_tmor := 0;
      end;
      --------------------------------------------------------------------------
       begin
        pq_cr_reporte_fondos_p3.sp_obtener_fcamb_estado(pn_cod   => k.r2cod,
                                                           pn_mod   => k.r2mod,
                                                           pn_suc   => k.r2suc,
                                                           pn_mda   => k.r2mda,
                                                           pn_pap   => k.r2pap,
                                                           pn_cta   => k.r2cta,
                                                           pn_ope   => k.r2oper,
                                                           pn_sbo   => k.r2sbop,
                                                           pn_top   => k.r2tope,                                                           
                                                           pd_fecha => pn_ffin,
                                                           pd_fcest => ld_fcest);
      exception
        when others then
          ld_fcest := null;
      end;
      --------------------------------------------------------------------------
      --  Número de cuotas crono actual
            begin
              lc_cuo_n := pq_cr_reporte_fondos_p3.fn_fecha_ncuoa(pn_cod => k.r2cod,
                                                                 pn_mod => k.r2mod,
                                                                 pn_suc => k.r2suc,
                                                                 pn_mda => k.r2mda,
                                                                 pn_pap => k.r2pap,
                                                                 pn_cta => k.r2cta,
                                                                 pn_ope => k.r2oper,
                                                                 pn_sbo => k.r2sbop,
                                                                 pn_top => k.r2tope);
            exception
              when others then
                lc_cuo_n := 0;
            end;
      --------------------------------------------------------------------------
      --  Número de cuotas crono original
            begin
              lc_cuo_o := pq_cr_reporte_fondos_p3.fn_fecha_ncuoi(pn_cod => k.r2cod,
                                                                 pn_mod => k.r2mod,
                                                                 pn_suc => k.r2suc,
                                                                 pn_mda => k.r2mda,
                                                                 pn_pap => k.r2pap,
                                                                 pn_cta => k.r2cta,
                                                                 pn_ope => k.r2oper,
                                                                 pn_sbo => k.r2sbop,
                                                                 pn_top => k.r2tope);
            exception
              when others then
                lc_cuo_o := 0;
            end;
      --------------------------------------------------------------------------
      begin
        insert into aqpb379
          (aqpb379usur, -- Usuario
           aqpb379pgcod, -- Código de empresa
           aqpb379mod, -- Módulo
           aqpb379suc, -- Sucursal
           aqpb379mda, -- Moneda 
           aqpb379pap, -- Papel 
           aqpb379cta, -- Cuenta 
           aqpb379ope, -- Operación
           aqpb379sbo, -- Suboperación
           aqpb379top, -- Tipo de operación
           
           aqpb379anio, -- 1. Año
           aqpb379mes, -- 2. Mes
           aqpb379tdoc, -- 3. Tipo de documento
           aqpb379ndoc, -- 4. Numero de documento
           aqpb379csol, -- 5. Codigo solicitud
           aqpb379esfco, -- 6. ESF/COOPAC
           aqpb379ofon, -- 7. Origen fondos
           aqpb379mondes, -- 8. Monto desembolsado cupo principal
           aqpb379mondis, -- 8.1 Monto desembolsado disposición
           aqpb379pzo, -- 9. Plazo
           aqpb379pgra, -- 10. Periodo de gracia
           aqpb379ncer, -- 11. Numero certificado
           aqpb379idlin, -- 12. Id Linea
           aqpb379fdesp, -- 13. Fecha de desembolso prestamo
           aqpb379moned, -- 14. Moneda
           aqpb379sdocap, -- 15. Saldo Capital Pendiente
           aqpb379sdoins, -- 16. Saldo insoluto
           aqpb379monpre, -- 17. Monto prepago
           aqpb379tcre, -- 18. Tipo de credito SBS
           aqpb379ncre, -- 19. Tipo de credito SBS concepto
           aqpb379csbs, -- 20. Codigo de cliente SBS
           aqpb379fcal, -- 21. Fecha de Calificacion actualizada
           aqpb379canom, -- 22. Calificacion normal
           aqpb379cacpp, -- 23. Calificacion CPP
           aqpb379cadef, -- 24. Calificacion Deficiente
           aqpb379cadud, -- 25. Calificacion dudosa
           aqpb379caper, -- 26. Calificacion perdida
           aqpb379fcla, -- 27. Fecha de clasificacion interna caja
           aqpb379clnom, -- 28. Clasificacion Normal
           aqpb379clcpp, -- 29. Clasificacion CPP
           aqpb379cldef, -- 30. Clasificacion deficiente
           aqpb379cldud, -- 31. Clasificacion dudosa
           aqpb379clper, -- 32. Clasificacion perdida
           aqpb379sitcon, -- 33. Situacion contable
           aqpb379sitconc, -- 34. Situacion contable concepto
           aqpb379datrcuo, -- 35. Dias atraso pago cuota
           aqpb379fprepa, -- 36. fecha prepago
           aqpb379tspre, -- 37. Tasa subprestamo
           aqpb379razn, -- 38. Razon social
           aqpb379ciiu, -- 39. CIIU
           aqpb379aeco, -- 40. Actividad Economica
           aqpb379npre, -- 41. Numero de prestamo
           aqpb379frepa, -- 42. frecuencia de pago
           aqpb379ncuot, -- 43. Numero de cuotas totales
           aqpb379ncuop, -- 44. Numero de cuotas pagadas
           aqpb379finl, -- 45. Fecha Inicio de Linea
           aqpb379ffil, -- 46. Fecha Fin de linea
           aqpb379finc, -- 47. Fecha Inicio de Certificado
           aqpb379ffic, -- 48. Fecha Fin de Certificado
           aqpb379reg, -- 49. Region
           aqpb379nreg, -- 49.1. Region Nombre
           aqpb379zon, -- 50 Zona
           aqpb379nzon, -- 50.1. Zona Nombre
           aqpb379nsuc, -- 51.1. Agencia Sucursal Nombre
           aqpb379ase, -- 52. Analista
           aqpb379repro, -- 53. Reprogramacion
           aqpb379frepro, -- 54. Fecha de Reprogramacion
           aqpb379amort, -- 55. Amortizacion
           aqpb379famor, -- 56. Fecha de Amortizacion
           aqpb379mamor, -- 57. Monto amortizacion
           aqpb379nestcre, -- 58. Estado credito descripcion
           aqpb379fulpa, -- 59. Fecha ultimo pago realizado
           aqpb379monpag, -- 60. Monto pagado
           aqpb379cappag, -- 61. Capital pagado
           aqpb379incomp, -- 62. Interes compensatorio pagado
           aqpb379inmora, -- 63. Interes moratorio pagado
           aqpb379inte, -- 64. Interes
           aqpb379segu, -- 65. Seguros
           aqpb379pena, -- 66. Penalidades
           aqpb379pcob, -- 67. % de Cobertura
           
           aqpb379r1cod, --- Clave 117: Empresa
           aqpb379r1mod, --- Clave 117: Módulo
           aqpb379r1suc, --- Clave 117: Sucursal
           aqpb379r1mda, --- Clave 117: Moneda
           aqpb379r1pap, --- Clave 117: Papel
           aqpb379r1cta, --- Clave 117: Cuenta
           aqpb379r1ope, --- Clave 117: Operación
           aqpb379r1sbo, --- Clave 117: Suboperación
           aqpb379r1top, --- Clave 117: Tipo de operación             
           
           aqpb379stat, -- Estado de Credito
           aqpb379fe99, -- Fecha de Cancelacion
           aqpb379fproc, -- Fecha de Proceso
           aqpb379fcrea, -- Fecha de Creacion
           aqpb379hcrea, -- Hora de creacion
           aqpb379mhonr,
               aqpb379fhonr,
               aqpb379chonr,
               aqpb379sdocaph,
               aqpb379sdohon,
               aqpb379crehon,
               aqpb379tmor,
               aqpb379moncob,
               aqpb379fcest,
               aqpb379ccob,
               aqpb379cren,
               aqpb379chon,
               aqpb379sinsap,
              aqpb379prpago,
              aqpb379pagrea,
              aqpb379pramrt,
              aqpb379nrccor,
              aqpb379nrccac,
              aqpb379vulcpa,
              aqpb379vcprve,
              aqpb379fuclpr,
              aqpb379intcom,
              aqpb379intcov,
              aqpb379intmor,
              aqpb379penali 
           )
        
        values
          (pn_usuario,
           
           k.r2cod,
           k.r2mod,
           k.r2suc,
           k.r2mda,
           k.r2pap,
           k.r2cta,
           k.r2oper,
           k.r2sbop,
           k.r2tope,
           
           lx_anio, -- 1. Año
           lx_mes, -- 2. Mes
           k.petdoc, -- 3. Tipo de documento
           k.pendoc, -- 4. Numero de documento
           lb_csol, -- 5. Codigo solicitud
           lx_esf, -- 6. ESF/COOPAC
           lb_ofon, -- 7. Origen fondos
           lx_mon_117, -- 8. Monto desembolsado cupo principal, módulo 117
           lx_mon_dis, --j.monto, -- 8.1 Monto desembolsado disposición, módulo 116
           lc_nro_cuo, --k.plazo, -- 9. Plazo, módulo 116
           lc_pgra, -- 10. Periodo de gracia, módulo 116
           lb_ncer, -- 11. Numero certificado
           lb_idlin, -- 12. Id Linea
           null, --k.aofval, -- 13. Fecha de desembolso prestamo, módulo 116
           lc_mda, -- 14. Moneda
           lc_sdo_cap, -- 15. Saldo Capital Pendiente, módulo 116
           lc_sdoins, -- 16. Saldo insoluto, módulo 116
           lc_cuo_mes, -- 17. Monto prepago, capital cancelado en el mes actual, módulo 116
           lc_pcre, -- 18. Tipo de credito SBS
           substr(trim(lc_ncre), 1, 50), -- 19. Tipo de credito SBS concepto
           lc_csbs, -- 20. Codigo de cliente SBS
           lc_fecha_rcc, -- 21. Fecha de Calificacion actualizada           
           lc_calif0, -- 22. Calificacion normal
           lc_calif1, -- 23. Calificacion CPP
           lc_calif2, -- 24. Calificacion Deficiente
           lc_calif3, -- 25. Calificacion dudosa
           lc_calif4, -- 26. Calificacion perdida           
           lc_fecha_caj, -- 27. Fecha de clasificacion interna caja
           lc_calif0a, -- 28. Clasificacion Normal
           lc_calif1a, -- 29. Clasificacion CPP
           lc_calif2a, -- 30. Clasificacion deficiente
           lc_calif3a, -- 31. Clasificacion dudosa
           lc_calif4a, -- 32. Clasificacion perdida
           substr(trim(lc_dcon), 1, 4), -- 33. Situacion contable
           substr(trim(lc_scon), 1, 20), -- 34. Situacion contable concepto
           lc_diatimp, -- 35. Dias atraso pago cuota impaga, módulo 116
           lc_fulti_pago, -- 36. fecha prepago, módulo 116
           0, --k.tasa, -- 37. Tasa subprestamo, módulo 116
           lc_razon, -- 38. Razon social
           lb_ciiu, -- 39. CIIU
           lb_aeco, -- 40. Actividad Economica
           lc_nro_pre, -- 41. Numero de prestamo
           0, --k.aoperiod, -- 42. frecuencia de pago, módulo 116
           lx_ncuo_tot, -- 43. Numero de cuotas totales, módulo 116
           lx_ncuo_pag, -- 44. Numero de cuotas pagadas, módulo 116          
           lx_fval_117, -- 45. Fecha Inicio de Linea, módulo 117
           lx_fven_117, -- 46. Fecha Fin de linea, módulo 117
           lb_finc, -- 47. Fecha Inicio de Certificado
           lb_ffic, -- 48. Fecha Fin de Certificado
           lc_regi, -- 49. Region
           substr(trim(lc_nreg), 1, 30), -- 49.1. Region Nombre
           lc_zona, -- 50. Zona
           substr(trim(lc_nzon), 1, 40), -- 50.1 Zona Nombre
           substr(trim(lc_nsuc), 1, 30), -- 51.1 Agencia Sucursal Nombre
           lc_ases, -- 52. Analista
           lc_lrep, -- 53. Reprogramacion, módulo 116
           lc_frep, -- 54. Fecha de Reprogramacion, módulo 116
           lc_lamr, -- 55. Amortizacion, módulo 116
           lc_fecha_amot, -- 56. Fecha de Amortizacion, módulo 116
           lc_cap_amort, -- 57. Monto amortizacion, módulo 116
           lc_statd, -- 58. Estado credito descripcion
           lc_fupag, -- 59. Fecha ultimo pago realizado, módulo 116
           lc_tsum, -- 60. Monto pagado, módulo 116
           lc_cuo, -- 61. Capital pagado, módulo 116
           lc_icv, -- 62. Interes compensatorio pagado, módulo 116
           lc_mor, -- 63. Interes moratorio pagado, módulo 116
           lc_int, -- 64. Interes, módulo 116
           lc_gas, -- 65. Seguros, módulo 116
           lc_pen, -- 66. Penalidades, módulo 116  
           lb_pcob, -- 67. % de Cobertura
           
           0, -- k.r2cod,--j.pgcod,
           0, -- k.r2mod,--j.aomod,
           0, -- k.r2suc,--j.aosuc, -- Agencia (Sucursal)
           0, -- k.r2mda,--j.aomda,
           0, -- k.r2pap,--j.aopap,
           0, -- k.r2cta,--j.aocta, -- Nro. de Cuenta
           0, -- k.r2oper,--j.aooper, -- Nro. de Operación  
           0, -- k.r2sbop,--j.aosbop,
           0, -- k.r2tope,--j.aotope,
           
           k.aostat, -- Estado de Credito, módulo 116
           k.aofe99, -- Fecha de Cancelacion, módulo 116
           pn_ffin, -- Fecha de Proceso
           to_char(sysdate, 'DD/MM/YYYY'), -- Fecha de Creacion
           to_char(sysdate, 'HH24:MI:SS'), -- Hora de creacion
           ln_mhonr, --monto honrado
               ld_fhonr,--fecha honramiento
               lc_eshonr,--es honrado
               lc_sdo_cap,
               nvl(ln_sdohon,0),
               lc_sdo_cap + nvl(ln_sdohon,0),
               ln_tmor, --tasa interes moratorio
               case when k.aostat = 99 and pn_ffin >= k.aofe99 then 0 else lc_sdoins*lb_pcob/100 end, --monto coberturado
               case when ld_fcest > nvl(k.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                 (case when ld_fcest > nvl(lc_frep,to_date('01/01/0001','DD/MM/YYYY')) then ld_fcest else lc_frep end )
                 else (case when nvl(lc_frep,to_date('01/01/0001','DD/MM/YYYY')) > nvl(k.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then lc_frep else k.aofe99 end )end, --fecha de cambio de estado
               lb_ccob,
               lb_cren,
               lb_chon,
               0, --saldo insoluto antes del prepago 
            0, --prepago
            0, -- pago realizado
            0, --principal amortizado
            lc_cuo_o, --numero de cuotas creditos original
            lc_cuo_n, --numero ce cuotas credito actual
            0, --valor ultima cuota pagada
            0, --valor cuota proximo vencimiento
            null, -- Nueva fecha de la ultima cuota luego del prepago,
            0, --interes compensatorio
            0, --interes compensatorio vencido
            0, --interes moratorio
            0 --penalidad

           );
      
        commit;
      
      exception
        when others then
        
          lc_coderr := substr(trim(sqlcode), 1, 100);
          lc_msgerr := substr(trim(sqlerrm), 1, 1000);
        
          begin
            insert into AQPB070E
              (aqpb070etab,
               aqpb070efec,
               aqpb070esuc,
               aqpb070eusr,
               aqpb070ecoe,
               aqpb070emsge,
               aqpb070efcr,
               aqpb070ehcr,
               aqpb070ecta,
               aqpb070eope)
            values
              ('AQPB379',
               pn_ffin,
               pc_sucurs,
               substr(trim(pn_usuario), 1, 10),
               lc_coderr,
               lc_msgerr,
               to_char(sysdate, 'DD/MM/YYYY'),
               to_char(sysdate, 'HH24:MI:SS'),
               ln_cta,
               ln_ope);
            commit;
          exception
            when others then
              null;
          end;
        
      end;
    
    end loop;
  
    for z in verificar_fae_agro() loop
    
      ln_cta := z.cta;
      ln_ope := z.oper;
      ln_cta116 := z.cta116;
      ln_ope116 := z.oper116;
    
      begin
        select 'S'
          into lb_flag_vig
          from aqpb379 x
         where x.aqpb379usur = pn_usuario
           and x.aqpb379suc = pc_sucurs
           and x.aqpb379cta = z.cta
           and x.aqpb379ope = z.oper
           and x.aqpb379r1cta = z.cta116
           and x.aqpb379r1ope = z.oper116
           and x.aqpb379stat <> 99;
      exception
        when others then
          lb_flag_vig := 'N';
      end;
    
      begin
        if lb_flag_vig = 'S' then
          --- Hay vigente, borrar los no vigentes
        
          delete from aqpb379 x
           where x.aqpb379usur = pn_usuario
             and x.aqpb379suc = pc_sucurs
             and x.aqpb379cta = z.cta
             and x.aqpb379ope = z.oper
             and x.aqpb379r1cta = z.cta116
             and x.aqpb379r1ope = z.oper116             
             and x.aqpb379stat = 99;
          commit;
        
        else
          --- Solo hay cancelados, dejar el crédito con máxima fecha de cancelación
          select max(x.aqpb379fe99)
            into lb_fmax_anu
            from aqpb379 x
           where x.aqpb379usur = pn_usuario
             and x.aqpb379suc = pc_sucurs
             and x.aqpb379cta = z.cta
             and x.aqpb379ope = z.oper
             and x.aqpb379r1cta = z.cta116
             and x.aqpb379r1ope = z.oper116             
             and x.aqpb379stat = 99;
        
          delete from aqpb379 x
           where x.aqpb379usur = pn_usuario
             and x.aqpb379suc = pc_sucurs
             and x.aqpb379cta = z.cta
             and x.aqpb379ope = z.oper
             and x.aqpb379r1cta = z.cta116
             and x.aqpb379r1ope = z.oper116             
             and x.aqpb379fe99 <> lb_fmax_anu
             and x.aqpb379stat = 99;
          commit;
        
        end if;
      
      exception
        when others then
        
          lc_coderr := substr(trim(sqlcode), 1, 100);
          lc_msgerr := substr(trim(sqlerrm), 1, 1000);
        
          begin
            insert into AQPB070E
              (aqpb070etab,
               aqpb070efec,
               aqpb070esuc,
               aqpb070eusr,
               aqpb070ecoe,
               aqpb070emsge,
               aqpb070efcr,
               aqpb070ehcr,
               aqpb070ecta,
               aqpb070eope)
            values
              ('AQPB379',
               pn_ffin,
               pc_sucurs,
               substr(trim(pn_usuario), 1, 10),
               lc_coderr,
               lc_msgerr,
               to_char(sysdate, 'DD/MM/YYYY'),
               to_char(sysdate, 'HH24:MI:SS'),
               ln_cta,
               ln_ope);
            commit;
          exception
            when others then
              null;
          end;
        
      end;
    
    end loop;
  
  exception
    when others then
    
      lc_coderr := substr(trim(sqlcode), 1, 100);
      lc_msgerr := substr(trim(sqlerrm), 1, 1000);
    
      begin
        insert into AQPB070E
          (aqpb070etab,
           aqpb070efec,
           aqpb070esuc,
           aqpb070eusr,
           aqpb070ecoe,
           aqpb070emsge,
           aqpb070efcr,
           aqpb070ehcr,
           aqpb070ecta,
           aqpb070eope)
        values
          ('AQPB379',
           pn_ffin,
           pc_sucurs,
           substr(trim(pn_usuario), 1, 10),
           lc_coderr,
           lc_msgerr,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'),
           ln_cta,
           ln_ope);
        commit;
      exception
        when others then
          null;
      end;
    
  end sp_reporte_fagro_r1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_ind     number,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    --begin
    case
      when pn_ind = 1 then
        -- FAE AGRO
      
        delete from aqpb379h t
         where t.aqpb379husur = pn_usuario
           and t.aqpb379hfproc = pn_fcorte;
        commit;
      
        begin
        
          insert into aqpb379h
            (aqpb379husur,
             aqpb379hpgcod,
             aqpb379hmod,
             aqpb379hsuc,
             aqpb379hmda,
             aqpb379hpap,
             aqpb379hcta,
             aqpb379hope,
             aqpb379hsbo,
             aqpb379htop,
             aqpb379hanio,
             aqpb379hmes,
             aqpb379htdoc,
             aqpb379hndoc,
             aqpb379hcsol,
             aqpb379hesfco,
             aqpb379hofon,
             aqpb379hmondes,
             aqpb379hmondis,
             aqpb379hpzo,
             aqpb379hpgra,
             aqpb379hncer,
             aqpb379hidlin,
             aqpb379hfdesp,
             aqpb379hmoned,
             aqpb379hsdocap,
             aqpb379hsdoins,
             aqpb379hmonpre,
             aqpb379htcre,
             aqpb379hncre,
             aqpb379hcsbs,
             aqpb379hfcal,
             aqpb379hcanom,
             aqpb379hcacpp,
             aqpb379hcadef,
             aqpb379hcadud,
             aqpb379hcaper,
             aqpb379hfcla,
             aqpb379hclnom,
             aqpb379hclcpp,
             aqpb379hcldef,
             aqpb379hcldud,
             aqpb379hclper,
             aqpb379hsitcon,
             aqpb379hsitconc,
             aqpb379hdatrcuo,
             aqpb379hfprepa,
             aqpb379htspre,
             aqpb379hrazn,
             aqpb379hciiu,
             aqpb379haeco,
             aqpb379hnpre,
             aqpb379hfrepa,
             aqpb379hncuot,
             aqpb379hncuop,
             aqpb379hfinl,
             aqpb379hffil,
             aqpb379hfinc,
             aqpb379hffic,
             aqpb379hreg,
             aqpb379hnreg,
             aqpb379hzon,
             aqpb379hnzon,
             aqpb379hnsuc,
             aqpb379hase,
             aqpb379hrepro,
             aqpb379hfrepro,
             aqpb379hamort,
             aqpb379hfamor,
             aqpb379hmamor,
             aqpb379hnestcre,
             aqpb379hfulpa,
             aqpb379hmonpag,
             aqpb379hcappag,
             aqpb379hincomp,
             aqpb379hinmora,
             aqpb379hinte,
             aqpb379hsegu,
             aqpb379hpena,
             aqpb379hpcob,
             aqpb379hr1cod, --- Clave 116: Empresa
             aqpb379hr1mod, --- Clave 116: Módulo
             aqpb379hr1suc, --- Clave 116: Sucursal
             aqpb379hr1mda, --- Clave 116: Moneda
             aqpb379hr1pap, --- Clave 116: Papel
             aqpb379hr1cta, --- Clave 116: Cuenta
             aqpb379hr1ope, --- Clave 116: Operación
             aqpb379hr1sbo, --- Clave 116: Suboperación
             aqpb379hr1top, --- Clave 116: Tipo de operación               
             aqpb379hstat,
             aqpb379hfe99,
             aqpb379hfproc,
             aqpb379hfcrea,
             aqpb379hhcrea,
             aqpb379hmhonr,
             aqpb379hfhonr,
             aqpb379hchonr,
             aqpb379hsdocaph,
             aqpb379hsdohon,
             aqpb379hcrehon,
             aqpb379htmor,
             aqpb379hmoncob,
             aqpb379hfcest,
             aqpb379hccob,
             aqpb379hcren,
             aqpb379hchon,
             aqpb379hsinsap,
            aqpb379hprpago,
            aqpb379hpagrea,
            aqpb379hpramrt,
            aqpb379hnrccor,
            aqpb379hnrccac,
            aqpb379hvulcpa,
            aqpb379hvcprve,
            aqpb379hfuclpr,
            aqpb379hintcom,
            aqpb379hintcov,
            aqpb379hintmor,
            aqpb379hpenali )
          
            select x.aqpb379usur,
                   x.aqpb379pgcod,
                   x.aqpb379mod,
                   x.aqpb379suc,
                   x.aqpb379mda,
                   x.aqpb379pap,
                   x.aqpb379cta,
                   x.aqpb379ope,
                   x.aqpb379sbo,
                   x.aqpb379top,
                   x.aqpb379anio,
                   x.aqpb379mes,
                   x.aqpb379tdoc,
                   x.aqpb379ndoc,
                   x.aqpb379csol,
                   x.aqpb379esfco,
                   x.aqpb379ofon,
                   x.aqpb379mondes,
                   x.aqpb379mondis,
                   x.aqpb379pzo,
                   x.aqpb379pgra,
                   x.aqpb379ncer,
                   x.aqpb379idlin,
                   x.aqpb379fdesp,
                   x.aqpb379moned,
                   x.aqpb379sdocap,
                   x.aqpb379sdoins,
                   x.aqpb379monpre,
                   x.aqpb379tcre,
                   x.aqpb379ncre,
                   x.aqpb379csbs,
                   x.aqpb379fcal,
                   x.aqpb379canom,
                   x.aqpb379cacpp,
                   x.aqpb379cadef,
                   x.aqpb379cadud,
                   x.aqpb379caper,
                   x.aqpb379fcla,
                   x.aqpb379clnom,
                   x.aqpb379clcpp,
                   x.aqpb379cldef,
                   x.aqpb379cldud,
                   x.aqpb379clper,
                   x.aqpb379sitcon,
                   x.aqpb379sitconc,
                   x.aqpb379datrcuo,
                   x.aqpb379fprepa,
                   x.aqpb379tspre,
                   x.aqpb379razn,
                   x.aqpb379ciiu,
                   x.aqpb379aeco,
                   x.aqpb379npre,
                   x.aqpb379frepa,
                   x.aqpb379ncuot,
                   x.aqpb379ncuop,
                   x.aqpb379finl,
                   x.aqpb379ffil,
                   x.aqpb379finc,
                   x.aqpb379ffic,
                   x.aqpb379reg,
                   x.aqpb379nreg,
                   x.aqpb379zon,
                   x.aqpb379nzon,
                   x.aqpb379nsuc,
                   x.aqpb379ase,
                   x.aqpb379repro,
                   x.aqpb379frepro,
                   x.aqpb379amort,
                   x.aqpb379famor,
                   x.aqpb379mamor,
                   x.aqpb379nestcre,
                   x.aqpb379fulpa,
                   x.aqpb379monpag,
                   x.aqpb379cappag,
                   x.aqpb379incomp,
                   x.aqpb379inmora,
                   x.aqpb379inte,
                   x.aqpb379segu,
                   x.aqpb379pena,
                   x.aqpb379pcob,
                   x.aqpb379r1cod,
                   x.aqpb379r1mod,
                   x.aqpb379r1suc,
                   x.aqpb379r1mda,
                   x.aqpb379r1pap,
                   x.aqpb379r1cta,
                   x.aqpb379r1ope,
                   x.aqpb379r1sbo,
                   x.aqpb379r1top,
                   x.aqpb379stat,
                   x.aqpb379fe99,
                   x.aqpb379fproc,
                   x.aqpb379fcrea,
                   x.aqpb379hcrea,
                   x.aqpb379mhonr,
                   x.aqpb379fhonr,
                   x.aqpb379chonr,
                   x.aqpb379sdocaph,
                   x.aqpb379sdohon,
                   x.aqpb379crehon,
                   x.aqpb379tmor,
                   x.aqpb379moncob,
                   x.aqpb379fcest,
                   x.aqpb379ccob,
                   x.aqpb379cren,
                   x.aqpb379chon,
                   x.aqpb379sinsap,
                  x.aqpb379prpago,
                  x.aqpb379pagrea,
                  x.aqpb379pramrt,
                  x.aqpb379nrccor,
                  x.aqpb379nrccac,
                  x.aqpb379vulcpa,
                  x.aqpb379vcprve,
                  x.aqpb379fuclpr,
                  x.aqpb379intcom,
                  x.aqpb379intcov,
                  x.aqpb379intmor,
                  x.aqpb379penali 
              from aqpb379 x
             where x.aqpb379usur = pn_usuario;
          commit;
        
        --exception
        --  when others then
          
         --   lc_coderr := sqlcode;
         --   lc_msgerr := trim(sqlerrm);
        exception when others then null;
        end;
      
      when pn_ind = 2 then
        -- XXX
        null;
      
    end case;
  
  end sp_guardar_historico;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_fagro(pd_fini    in date,
                            pd_fecpro  in date,
                            pn_usuario in varchar2) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    lc_fini     char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
    lc_flag       varchar2(1);
    x             number;
    lc_fecha      date;
    lb_njobs      number(3);
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
    tx_fini   date;
    tx_fecpro date;
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1 --and sucurs =12
         and sucurs < 800
      --or sucurs >= 900
      ;
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
  
    select x.tp1nro1
      into lb_njobs
      from fst198 x
     where x.TP1COD = 1
       and x.TP1COD1 = 11144
       and x.TP1CORR1 = 10
       and x.tp1corr2 = 2
       and x.tp1corr3 = 3;
  
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then null;
    end;
  
    --pn_flag := 'N';
  
    -- Eliminación del registro por usuario
    delete from aqpb379 t where trim(t.aqpb379usur) = pn_usuario;
    commit;
  
    -- 2. Carga de tabla  
    /*begin
      -- Call the procedure
      pq_cr_reporte_fondofaeagro.sp_sch_aqpb070a_carga(pd_fecpro  => pd_fecpro,
                                                       pn_usuario => pn_usuario,
                                                       pn_indi    => 1); --- FAE AGRO
    exception when others then null;                                                  
    end;*/
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'FAGRO' || lc_user;
    lc_paquete    := 'pq_cr_reporte_fondofaeagro';
    lc_proceso    := 'sp_reporte_fagro_r1';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    --tx_fini   := to_date('01/03/2021', 'dd/mm/yyyy');
    --tx_fecpro := to_date('12/05/2021', 'dd/mm/yyyy');
  
    lc_fini   := to_char(pd_fini, 'RRRR.MM.DD');
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini := i.sucurs;
      ln_job := ln_job + 1;
      --lc_prefjob    := 'REA_REP_1';
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_reporte_fondofaeagro.sp_reporte_fagro_r1( TO_DATE(''' ||
                       lc_fini || ''',''RRRR.MM.DD''),TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        --instance  => 2,
                        instance  => 1,
                        force     => false);
      
      Else
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      End If;
      commit;
    
      SELECT count(*)
        INTO x
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
      while x = lb_njobs loop
        --- Parametrizar              BANTPROD
        SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
           AND x.what LIKE '%' || trim(pn_usuario) || '%';
      
      end loop;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob) --VARCHAR(10),NUMBER,VARCHAR(500)
      VALUES
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_reporte_fondofaeagro.fn_cr_verifica_tarea2(lc_prefjob,
                                                                  lc_hostname,
                                                                  lc_paquete,
                                                                  lc_proceso,
                                                                  pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_reporte_fondofaeagro.fn_cr_verifica_tarea2(lc_prefjob,
                                                                    lc_hostname,
                                                                    lc_paquete,
                                                                    lc_proceso,
                                                                    pn_usuario);
    End loop;
  
    -- Registro de histórico   
    pq_cr_reporte_fondofaeagro.sp_guardar_historico(pn_usuario,
                                                    1, --pn_tip_rep,
                                                    pd_fecpro);
  
    --pn_flag := 'S';
  
    --exception
    --  when others then
    --pn_flag := 'N';
  end sp_cr_sch_fagro;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  procedure sp_plantilla_faeagro_r1(pn_cod in number,
                                    --pn_mod   in number,
                                    --pn_suc   in number,
                                    --pn_mda   in number,
                                    --pn_pap   in number,
                                    pn_cta in number,
                                    --pn_ope   in number,
                                    --pn_sbo   in number,
                                    --pn_top   in number,
                                    pn_fecha in date,
                                    
                                    pn_csol   out aqpb379b.aqpb379bcsol%type,
                                    pn_ofon   out aqpb379b.aqpb379bofon%type,
                                    pn_ncer   out aqpb379b.aqpb379bncer%type,
                                    pn_idlin  out aqpb379b.aqpb379bidlin%type,
                                    pn_fecof  out aqpb379b.aqpb379bfecof%type,
                                    pn_moncof out aqpb379b.aqpb379bmoncof%type,
                                    pn_ciiu   out aqpb379b.aqpb379bciiu%type,
                                    pn_aeco   out aqpb379b.aqpb379baeco%type,
                                    pn_finc   out aqpb379b.aqpb379bfinc%type,
                                    pn_ffic   out aqpb379b.aqpb379bffic%type,
                                    pn_pcob   out aqpb379b.aqpb379bpcob%type) is
  
  begin
  
    begin
    
      select g.aqpb379bcsol,
             g.aqpb379bofon,
             g.aqpb379bncer,
             g.aqpb379bidlin,
             g.aqpb379bfecof,
             g.aqpb379bmoncof,
             g.aqpb379bciiu,
             g.aqpb379baeco,
             g.aqpb379bfinc,
             g.aqpb379bffic,
             g.aqpb379bpcob
        into pn_csol,
             pn_ofon,
             pn_ncer,
             pn_idlin,
             pn_fecof,
             pn_moncof,
             pn_ciiu,
             pn_aeco,
             pn_finc,
             pn_ffic,
             pn_pcob
        from (select t.aqpb379bcsol,
                     t.aqpb379bofon,
                     t.aqpb379bncer,
                     t.aqpb379bidlin,
                     t.aqpb379bfecof,
                     t.aqpb379bmoncof,
                     t.aqpb379bciiu,
                     t.aqpb379baeco,
                     t.aqpb379bfinc,
                     t.aqpb379bffic,
                     t.aqpb379bpcob
                from aqpb379b t
               where t.aqpb379bcod = pn_cod
                    --and t.aqpb379bmod = pn_mod
                    --and t.aqpb379bsuc = pn_suc
                    --and t.aqpb379bmda = pn_mda
                    --and t.aqpb379bpap = pn_pap
                 and t.aqpb379bcta = pn_cta
                    ---and t.aqpb379bope = pn_ope
                    --and t.aqpb067bsbo = pn_sbo
                    --and t.aqpb067btop = pn_top
                 and t.aqpb379bfec <= pn_fecha
                 and t.aqpb379best <> 'D'
               order by t.aqpb379bfec desc, t.aqpb379bcor desc) g
       where rownum = 1;
    
    exception
      when others then
      
        pn_csol   := null;
        pn_ofon   := null;
        pn_ncer   := null;
        pn_idlin  := null;
        pn_fecof  := null;
        pn_moncof := null;
        pn_ciiu   := null;
        pn_aeco   := null;
        pn_finc   := null;
        pn_ffic   := null;
        pn_pcob   := null;
      
    end;
  
  end sp_plantilla_faeagro_r1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_plantilla_faeagro_v2(pn_cod in number,
                                    pn_cta in number,
                                    pn_fecha in date,
                                    
                                    pn_csol   out aqpb379b.aqpb379bcsol%type,
                                    pn_ofon   out aqpb379b.aqpb379bofon%type,
                                    pn_ncer   out aqpb379b.aqpb379bncer%type,
                                    pn_idlin  out aqpb379b.aqpb379bidlin%type,
                                    pn_fecof  out aqpb379b.aqpb379bfecof%type,
                                    pn_moncof out aqpb379b.aqpb379bmoncof%type,
                                    pn_ciiu   out aqpb379b.aqpb379bciiu%type,
                                    pn_aeco   out aqpb379b.aqpb379baeco%type,
                                    pn_finc   out aqpb379b.aqpb379bfinc%type,
                                    pn_ffic   out aqpb379b.aqpb379bffic%type,
                                    pn_pcob   out aqpb379b.aqpb379bpcob%type,
                                    pn_ccob out aqpb379b.aqpb379bccob%type,
                                    pn_cren out aqpb379b.aqpb379bcren%type,
                                    pn_chon out aqpb379b.aqpb379bchon%type) is
  
  begin
  
    begin
    
      select g.aqpb379bcsol,
             g.aqpb379bofon,
             g.aqpb379bncer,
             g.aqpb379bidlin,
             g.aqpb379bfecof,
             g.aqpb379bmoncof,
             g.aqpb379bciiu,
             g.aqpb379baeco,
             g.aqpb379bfinc,
             g.aqpb379bffic,
             g.aqpb379bpcob,
             g.aqpb379bccob,
             g.aqpb379bcren,
             g.aqpb379bchon
        into pn_csol,
             pn_ofon,
             pn_ncer,
             pn_idlin,
             pn_fecof,
             pn_moncof,
             pn_ciiu,
             pn_aeco,
             pn_finc,
             pn_ffic,
             pn_pcob,
             pn_ccob,
             pn_cren,
             pn_chon
        from (select t.aqpb379bcsol,
                     t.aqpb379bofon,
                     t.aqpb379bncer,
                     t.aqpb379bidlin,
                     t.aqpb379bfecof,
                     t.aqpb379bmoncof,
                     t.aqpb379bciiu,
                     t.aqpb379baeco,
                     t.aqpb379bfinc,
                     t.aqpb379bffic,
                     t.aqpb379bpcob,
                     t.aqpb379bccob,
                     t.aqpb379bcren,
                     t.aqpb379bchon
                from aqpb379b t
               where t.aqpb379bcod = pn_cod
                 and t.aqpb379bcta = pn_cta
                 and t.aqpb379bfec <= pn_fecha
                 and t.aqpb379best <> 'D'
               order by t.aqpb379bfec desc, t.aqpb379bcor desc) g
       where rownum = 1;
    
    exception
      when others then
      
        pn_csol   := null;
        pn_ofon   := null;
        pn_ncer   := null;
        pn_idlin  := null;
        pn_fecof  := null;
        pn_moncof := null;
        pn_ciiu   := null;
        pn_aeco   := null;
        pn_finc   := null;
        pn_ffic   := null;
        pn_pcob   := null;
        pn_ccob   := null;
        pn_cren   := null;
        pn_chon   := null;
      
    end;
  
  end sp_plantilla_faeagro_v2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_sch_aqpb070a_carga(pd_fecpro  in date,
                                  pn_usuario in char,
                                  pn_indi    in number) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini      number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_fecha_sis  date;
    lc_prefijo    varchar(10);
    lc_user       varchar(5);
    job_id        number;
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    lc_nomusr     varchar2(50);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
  
    begin
      select host_name into lc_hostname from v$instance;
    exception when others then null;
    end;
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --ld_finmes := last_Day(pd_fecpro);
  
    select x.pgfape into lc_fecha_sis from fst017 x where x.pgcod = 1;
  
    if pd_fecpro <> lc_fecha_sis then
    
      delete from aqpb070a x where trim(x.aqpb070ausur) = trim(pn_usuario);
      commit;
    
      case pn_indi
        when 1 then
          --- FAE AGRO
        
          lc_user    := substr(pn_usuario, 1, 5);
          lc_prefijo := 'FAGRT' || lc_user;
          lc_paquete := 'pq_cr_reporte_fondofaeagro';
          lc_proceso := 'sp_cr_carga_temp_fagro';
        
          for i in sucursal loop
            ln_ini        := i.sucurs;
            ln_job        := ln_job + 1;
            lc_prefjob    := lc_prefijo;
            pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                             lpad(ln_ini, 3, '0'); ---ln_job
          
            lc_variable := 'begin ' ||
                           '  pq_cr_reporte_fondofaeagro.sp_cr_carga_temp_fagro(''' ||
                           pn_usuario || ''',
                       ' || ln_ini ||
                           ',TO_DATE(''' || lc_fecpro ||
                           ''',''RRRR.MM.DD'') );' || ' End;';
          
            IF SYS.FN_BD_ISRAC = 'TRUE' THEN
            
              dbms_job.submit(job_id,
                              what      => lc_variable,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                             -- instance  => 2,
                              instance  => 1,
                              force     => false);
            
            Else
            
              dbms_job.submit(job_id,
                              what      => lc_variable,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);
            
            End If;
            commit;
          
            INSERT INTO Tab_jobs
              (c_codage, n_Numer1, c_detjob)
            VALUES
              ('TEMP_379', ln_ini, lc_variable);
            COMMIT;
          
          end loop;
        
      end case;
    
      ln_numjob := pq_cr_reporte_fondofaeagro.fn_cr_verifica_tarea2(lc_prefjob,
                                                                    lc_hostname,
                                                                    lc_paquete,
                                                                    lc_proceso,
                                                                    pn_usuario);
    
      While ln_numjob > 0 loop
        ln_numjob := pq_cr_reporte_fondofaeagro.fn_cr_verifica_tarea2(lc_prefjob,
                                                                      lc_hostname,
                                                                      lc_paquete,
                                                                      lc_proceso,
                                                                      pn_usuario);
      End loop;
    
      -- 3. Aplicar estadisticas
      BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'DESA021118',--'BANTPROD',
                                      TABNAME          => 'AQPB070A',
                                      DEGREE           => 8,
                                      GRANULARITY      => 'ALL',
                                      ESTIMATE_PERCENT => 100,
                                      CASCADE          => TRUE);
      exception when others then null;
      END;
    
    end if;
  
  end sp_sch_aqpb070a_carga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_carga_temp_fagro(pc_usuario in varchar2,
                                   pc_sucurs  in varchar2,
                                   pc_fecpro  in date) is
  
  begin
  
    insert into aqpb070a
      (aqpb070ausur,
       --aqpb070atabla,
       aqpb070aemp,
       aqpb070asuc,
       aqpb070arubr,
       aqpb070amda,
       aqpb070apap,
       aqpb070acta,
       aqpb070aoper,
       aqpb070asbop,
       aqpb070atop,
       aqpb070afech,
       aqpb070atit,
       aqpb070acap,
       aqpb070apzo,
       aqpb070asist,
       aqpb070amod,
       aqpb070afvto,
       aqpb070afval,
       aqpb070aplaz,
       aqpb070attasa,
       aqpb070atasa,
       aqpb070aclta,
       aqpb070atdia,
       aqpb070atano,
       aqpb070aresi,
       aqpb070acate,
       aqpb070aacti,
       aqpb070aprod,
       aqpb070aticu,
       aqpb070atipp,
       aqpb070afatr,
       aqpb070asdor,
       aqpb070asdmn,
       aqpb070asdus,
       aqpb070asdmo,
       aqpb070aint,
       aqpb070aprev,
       aqpb070agpo,
       AQPB070Afcr,
       AQPB070Ahcr)
      select pc_usuario,
             j.bcemp,
             j.bcsuc,
             j.bcrubr,
             j.bcmda,
             j.bcpap,
             j.bccta,
             j.bcoper,
             j.bcsbop,
             j.bctop,
             j.bcfech,
             j.bctit,
             j.bccap,
             j.bcpzo,
             j.bcsist,
             j.bcmod,
             j.bcfvto,
             j.bcfval,
             j.bcplaz,
             j.bcttasa,
             j.bctasa,
             j.bcclta,
             j.bctdia,
             j.bctano,
             j.bcresi,
             j.bccate,
             j.bcacti,
             j.bcprod,
             j.bcticu,
             j.bctipp,
             j.bcfatr,
             j.bcsdor,
             j.bcsdmn,
             j.bcsdus,
             j.bcsdmo,
             j.bcint,
             j.bcprev,
             j.bcgpo,
             to_char(sysdate, 'DD/MM/YYYY'),
             to_char(sysdate, 'HH24:MI:SS')
        from fsh012 j,
             (select distinct u.aqpb379bcod,
                              --u.aqpb379bmod,
                              --u.aqpb379bsuc,
                              --u.aqpb379bmda,
                              --u.aqpb379bpap,
                              u.aqpb379bcta
              --u.aqpb379bope,
              --u.aqpb379bsbo,
              --u.aqpb379btop
                from aqpb379b u
               where u.aqpb379bcod = 1
                 and u.aqpb379bfec <= pc_fecpro
                 and u.aqpb379best <> 'D') g,
             fsr011 p,
             fsd014 h
       where j.bcemp = 1
         and j.bcsuc = pc_sucurs
         and j.bcfech = pc_fecpro
            --and p.r1cta = pc_cta
            
            --- FSR011 // AQPB379B
         and p.r1cod = g.aqpb379bcod
         and p.r2cta = g.aqpb379bcta
         and p.r1mod = 116
         and p.r1tope = 20
         and p.r2mod = 117
         and p.r2tope = 20
         and p.relcod = 46
            
            -- FSR011 // FSD010 
         and j.bcemp = p.r1cod
         and j.bcrubr = h.rubro
         and j.bcmod = p.r1mod
         and j.bcsuc = p.r1suc
         and j.bcmda = p.r1mda
         and j.bcpap = p.r1pap
         and j.bccta = p.r1cta
         and j.bcoper = p.r1oper
            --and j.bcsbop = p.r1sbop
         --and j.bctop = p.r1tope
            
         and h.pcnivc in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144)) -- jrodriguej 28.06.2021
         and h.pcimpu = 'S';
    commit;
  
  end sp_cr_carga_temp_fagro;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2) is
  
    --lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- FAE AGRO
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpb379acor), 0) + 1 into pn_corr from aqpb379a t;
      
        --- Reporte FAE AGRO
        insert into aqpb379a
          (aqpb379acod,
           aqpb379afec,
           aqpb379acor,
           aqpb379aest,
           aqpb379ausr,
           aqpb379afcr,
           aqpb379ahcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2) is
  
    --pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---FAE AGRO
      
        pn_flag := 'S';
      
        --Actualización del detalle de la plantilla
        update aqpb379b t
           set t.aqpb379best  = pn_estado,
               t.aqpb379busu  = pn_usuario,
               t.aqpb379bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb379bhedi = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb379bcod = pn_pgcod
           and t.aqpb379bfec = pn_fecha
           and t.aqpb379bcor = pn_corr
           and t.aqpb379best <> 'D';
        commit;
      
        update aqpb379a t
           set t.aqpb379aest = pn_estado,
               t.aqpb379ausd = pn_usuario,
               t.aqpb379afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb379ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb379acod = pn_pgcod
           and t.aqpb379afec = pn_fecha
           and t.aqpb379acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2) is
  
    -- lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- FAE AGRO
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpb379acor), 0) + 1 into pn_corr from aqpb379a t;
      
        --- Reporte FAE
        insert into aqpb379a
          (aqpb379acod,
           aqpb379afec,
           aqpb379acor,
           aqpb379aest,
           aqpb379ausr,
           aqpb379afcr,
           aqpb379ahcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---fae agro
      
        pn_flag := 'S';
      
        update AQPB379a t
           set t.aqpb379aest = pn_estado,
               t.aqpb379ausd = pn_usuario,
               t.aqpb379afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb379ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb379acod = pn_pgcod
           and t.aqpb379afec = pn_fecha
           and t.aqpb379acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2,
                                 pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
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
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
  
    begin
    
      lc_pac_nombre := trim(pn_paquete) || '.' || trim(pn_proceso);
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    exception when others then null;
    end;
  
    return ln_numjob;
  
  end fn_cr_verifica_tarea2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
    pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---FAE AGRO
        pn_flag := 'S';
      
        --Actualización de la cabecera principal
        update aqpb379a t
           set t.aqpb379aest = pn_estado,
               t.aqpb379ausd = pn_usuario,
               t.aqpb379afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb379ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb379acod = pn_pgcod
           and t.aqpb379afec = pn_fecha
           and t.aqpb379acor = pn_corr;
        commit;
      
    end case;
  
  end sp_anulacion_individual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2) is
  
    lc_user    varchar(5);
    lc_prefijo varchar(10);
    lc_cont    number;
    lc_nomusr  varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
    end;
  
    lc_user := substr(pn_user, 1, 5);
  
    --case
    --  when pn_tipo = 1 then
    ---fae agro
    lc_prefijo := 'FAGRO' || lc_user;
    --end case;
  
    SELECT count(*)
      into lc_cont
      FROM dba_scheduler_jobs x
     where x.owner = lc_nomusr
       and x.job_name like lc_prefijo || '%';
  
    if lc_cont > 0 then
      pn_flag := 'S';
    else
      pn_flag := 'N';
    end if;
  
  end sp_verificar_genrep;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- ===== PROCEDIMIENTOS Y FUNCIONES PARA LOS REPORTES=====================
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_obtener_sdocap(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fecha   in date,
                             pn_usuario in char) return number is
    --- Obtener saldo capital
  
    lc_sdo_cap number(17, 2);
    lx_fecha   date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
    if lx_fecha = pn_fecha then
      begin
      
        select (sum(t.scsdo)) * -1
          into lc_sdo_cap
          from FSD011 t
         where t.pgcod = pn_cod
           and t.scmod = pn_mod
           and t.scsuc = pn_suc
           and t.scmda = pn_mda
           and t.scpap = pn_pap
           and t.sccta = pn_cta
           and t.scoper = pn_ope
           and t.scsbop = pn_sbo
           and t.sctope = pn_top
           ;
      exception
        when others then
          begin
      
            select (sum(t.scsdo)) * -1
              into lc_sdo_cap
              from FSD011 t
             where t.pgcod = pn_cod
               and t.scmod = pn_mod
               --and t.scsuc = pn_suc
               and t.scmda = pn_mda
               and t.scpap = pn_pap
               and t.sccta = pn_cta
               and t.scoper = pn_ope
               and t.scsbop = pn_sbo
               and t.sctope = pn_top
               ;
          exception
            when others then
              lc_sdo_cap := 0;
          end;
      end;
    else
    
      begin
      
        select /*+index(t FSH01204)*/(t.bcsdmn * -1)
          into lc_sdo_cap
          from FSH012 t -- FSH012
         where t.bcemp = pn_cod
           and t.bcmod = pn_mod
           and t.bcsuc = pn_suc
           and t.bcmda = pn_mda
           and t.bcpap = pn_pap
           and t.bccta = pn_cta
           and t.bcoper = pn_ope
           and t.bcsbop = pn_sbo
           and t.bctop = pn_top
           and t.bcfech = pn_fecha;
      
      exception
        when others then
          begin
      
            select /*+index(t FSH01204)*/(t.bcsdmn * -1)
              into lc_sdo_cap
              from FSH012 t -- FSH012
             where t.bcemp = pn_cod
               and t.bcmod = pn_mod
               --and t.bcsuc = pn_suc
               and t.bcmda = pn_mda
               and t.bcpap = pn_pap
               and t.bccta = pn_cta
               and t.bcoper = pn_ope
               and t.bcsbop = pn_sbo
               and t.bctop = pn_top
               and t.bcfech = pn_fecha;
          
          exception
            when others then
              lc_sdo_cap := 0;
          end;
      end;
    
    end if;
  
    if lc_sdo_cap < 0 then
      lc_sdo_cap := 0;
    end if;
  
    return lc_sdo_cap;
  
  end fn_obtener_sdocap;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_obtener_sald_insol2(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number) -- saldo insoluto
   is
    -- Saldo insoluto = monto_cofide - sumatorio de pagos
    -- pn_indi = 1 -----> FAE AGRO
  
    lx_mcof number(10, 2);
    lx_scap number(17, 2);
    lx_fdes date;
    lx_mext number(17, 2);
    lx_fdia date;
    lc_canc char(1);
    lx_stat number(2);
    lx_shon number(17,2);
    lx_shon_ext number(17,2);
  
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
  
    --validar estado de credito y trx para determinar si es 30/360
    lc_canc := 'N';
  
    begin -- se comento 26/11/2021 para que este igual a los demas fondos
    
      select 'S'
        into lc_canc
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800) ---2024.04.12 dcastro se agrego sucursales
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
            --and t.d602fc >= lx_fdes
         and t.d602fc <= pn_fecha
         and t.d602co = 'S'
      
      ;
    
    exception
      when others then
        lc_canc := 'N';
    end;
  
    if lc_canc = 'S' then
      pn_sald := 0;
    
    else
      -- a) monto COFIDE, fecha COFIDE
      case
        when pn_indi = 1 then
          -- FAE AGRO
          /*
          begin
          
            select x.aqpb379bmoncof, x.aqpb379bfecof
              into lx_mcof, lx_fdes
              from aqpb379b x
             where x.aqpb379bcod = pn_cod
               and x.aqpb379bcta = pn_cta
               and x.aqpb379bfec <= pn_fecha
               and x.aqpb379best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb379bmoncof, f.aqpb379bfecof
                  into lx_mcof, lx_fdes
                  from (select x.aqpb379bmoncof, x.aqpb379bfecof
                          from aqpb379b x
                         where x.aqpb379bcod = pn_cod
                           and x.aqpb379bcta = pn_cta
                           and x.aqpb379bfec <= pn_fecha
                           and x.aqpb379best <> 'D'
                         order by x.aqpb379bfec desc) f
                 where rownum = 1;
              
              exception
                when others then
                
                  lx_mcof := 0;
                  lx_fdes := null;
                
              end;
            
            when others then
            
              lx_mcof := 0;
              lx_fdes := null;
            
          end;
          */
        
          begin
            -- Call the procedure
            pq_cr_reporte_fondofaeagro.sp_monto_disposicion2(pn_cod     => pn_cod,
                                                             pn_mod     => pn_mod,
                                                             pn_suc     => pn_suc,
                                                             pn_mda     => pn_mda,
                                                             pn_pap     => pn_pap,
                                                             pn_cta     => pn_cta,
                                                             pn_ope     => pn_ope,
                                                             pn_sbo     => pn_sbo,
                                                             pn_top     => pn_top,
                                                             pn_ffin    => pn_fecha,
                                                             pn_mont    => lx_mcof,
                                                             pn_fec_dis => lx_fdes);
          exception
            when others then
              lx_mcof := 0;
              lx_fdes := null;
          end;
        
      end case;
    
      --- b) Sumatoria de pagos
      --- Capital
      if lx_mcof <> 0 and pn_fecha >= lx_fdes then
        begin
        
          select nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
            into lx_scap
          
            from fsd602 t
           where t.pgcod = pn_cod
             --and t.ppmod = pn_mod
                --and t.ppsuc = pn_suc
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
             and t.d602fc >= lx_fdes
             and t.d602fc <= pn_fecha
             and t.d602co = 'S';
        
        exception
          when others then
            lx_scap := 0;           
        end;
      
        if lx_fdia <> pn_fecha then
        
          begin
            select nvl(x.HCIMP1, 0) --,  x.* 
              into lx_mext
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
               and x.HFCON > pn_fecha
               and x.HFVAL <= pn_fecha
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
              lx_mext := 0;
          end;
        
        else
          lx_mext := 0;
        end if;
        --pagos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon
          from   fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = 103
               --and x.HSUCUR = 20
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap               
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = 3
               --and x.HTOPER = 109
               --and x.HFCON > '01/01/2022'
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN,x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 1 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon := 0;
        end;
        --extornos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon_ext
          from   fsh016 x, fsh015 t
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
               --and x.HFCON > 
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN,x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 2 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon_ext := 0;
        end;
      
        lx_scap := lx_scap + lx_mext + nvl(lx_shon,0)- nvl(lx_shon_ext,0);
      
      else
        lx_scap := 0;
      end if;
    
      if lx_mcof is null then
        lx_mcof := 0;
      end if;
    
      --- c) Resultado
      pn_sald := lx_mcof - (lx_scap);
    
      if pn_sald < 0 then
        pn_sald := 0;
      end if;
    end if; -- fin lc_canc       
  
    -- Verificación de estado del crédito
    /*if pn_stat = 99 then
      pn_sald := 0;
    end if;*/
  
  end sp_obtener_sald_insol2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_nombre(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char is
  
    lc_razon char(100);
    respc    char(100);
  
  begin
    begin
    
      if p_tdoc = 21 then
        -- -- -- -- -- -- -- -- -- --
        begin
          select concat(trim(s.pfape1),
                        concat(' ',
                               concat(trim(s.pfape2),
                                      concat(' ',
                                             concat(trim(s.pfnom1),
                                                    concat(' ', s.pfnom2))))))
            into lc_razon
            from fsd002 s
           where s.pfpais = p_pais
             and s.pftdoc = p_tdoc
             and s.pfndoc = p_ndoc;
        exception
          when others then
            lc_razon := '';
        end;
        -- -- -- -- -- -- -- -- -- --
      else
        -- -- -- -- -- -- -- -- -- --
        begin
          select trim(y.pjrazs)
            into lc_razon
            from fsd003 y
           where y.pjpais = p_pais
             and y.pjtdoc = p_tdoc
             and y.pjndoc = p_ndoc;
        exception
          when others then
            lc_razon := '';
        end;
        -- -- -- -- -- -- -- -- -- --
      end if;
    
      respc := lc_razon;
    
    exception
      when others then
      
        respc := '';
      
    end;
  
    return respc;
  
  end fn_obtener_nombre;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig(pn_cod     in number,
                                    pn_mod     in number,
                                    pn_suc     in number,
                                    pn_mda     in number,
                                    pn_pap     in number,
                                    pn_cta     in number,
                                    pn_ope     in number,
                                    pn_sbo     in number,
                                    pn_top     in number,
                                    pn_fecha   in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    ) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
    lx_nconc     char(50);
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fondofaeagro.fn_fecha_upago(pn_cod   => pn_cod,
                                                            pn_mod   => pn_mod,
                                                            pn_suc   => pn_suc,
                                                            pn_mda   => pn_mda,
                                                            pn_pap   => pn_pap,
                                                            pn_cta   => pn_cta,
                                                            pn_ope   => pn_ope,
                                                            pn_sbo   => pn_sbo,
                                                            pn_top   => pn_top,
                                                            pn_fecha => pn_fecha);
    exception
      when others then
        pn_ufech := null;
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if pn_mod = 117 then
         lx_fecha_ant := last_day(add_months(trunc(lx_fecha), -1));
      else
        if pn_ufech is not null then
          lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
        end if;
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if lx_fecha <> pn_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, lx_nconc
          
            from (select distinct t.aqpb070agpo tipo,
                                  case
                                    when t.aqpb070agpo = 2 then
                                     'MICROEMPRESAS'
                                    when t.aqpb070agpo = 3 and
                                         substr(t.aqpb070arubr, 11, 3) =
                                         '015' then
                                     'CONSUMO REVOLVENTE'
                                    when t.aqpb070agpo = 3 and
                                         substr(t.aqpb070arubr, 11, 3) <>
                                         '015' then
                                     'CONSUMO NO REVOLVENTE'
                                    when t.aqpb070agpo = 4 then
                                     'HIPOTECARIO'
                                    when t.aqpb070agpo = 12 then
                                     'MEDIANA EMPRESA'
                                    when t.aqpb070agpo = 13 then
                                     'PEQUEÑA EMPRESA'
                                    when t.aqpb070agpo = 11 then
                                     'GRANDES EMPRESAS'
                                    when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                                     'CORPORATIVO'
                                    else
                                     ' '
                                  END nconcepto
                  
                    from aqpb070a t --- fsd011
                   where t.aqpb070ausur = pn_usuario
                     and t.aqpb070aemp = pn_cod
                     --and t.aqpb070amod = pn_mod
                        --and t.aqpb070asuc = pn_suc
                     and t.aqpb070amda = pn_mda
                     and t.aqpb070apap = pn_pap
                     and t.aqpb070acta = pn_cta
                     and t.aqpb070aoper = pn_ope
                        --and t.bcsbop = pn_sbo
                     --and t.aqpb070atop = pn_top
                     and t.aqpb070afech = pn_fecha
                     and t.aqpb070asdmn <> 0
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select to_number(substr(g.harub, 5, 2)) scgru,
                     case
                       when substr(g.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(g.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(g.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(g.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(g.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into pn_ntipo, lx_nconc
                from
                (select * 
                from fsh014 f
               where f.pgcod = pn_cod
                 --and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 --and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 --and f.HASBOP = pn_sbo
                 --and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio
                 order by f.hasd12,
                 f.hasd11,
                 f.hasd10
                 ,f.hasd09,
                 f.hasd08,
                 f.hasd07,
                 f.hasd06,
                 f.hasd05,
                 f.hasd04,
                 f.hasd03,
                 f.hasd02,
                 f.hasd01) g
                 where rownum <=1;
            
            exception
              when others then
              
                pn_ntipo := 0;
                lx_nconc := null;
              
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
            into pn_ntipo, lx_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             --and t.scmod = pn_mod
                --and t.scsuc = pn_suc
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
                --and t.scsbop = pn_sbo
             --and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select to_number(substr(g.harub, 5, 2)) scgru,
                     case
                       when substr(g.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(g.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(g.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(g.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(g.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into pn_ntipo, lx_nconc
                from(
                select * from fsh014 f
               where f.pgcod = pn_cod
                 --and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 --and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 --and f.HASBOP = pn_sbo
                 --and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio
                 order by f.hasd12,
                 f.hasd11,
                 f.hasd10
                 ,f.hasd09,
                 f.hasd08,
                 f.hasd07,
                 f.hasd06,
                 f.hasd05,
                 f.hasd04,
                 f.hasd03,
                 f.hasd02,
                 f.hasd01) g
                 where rownum<=1;
            
            exception
              when others then
              
                pn_ntipo := 0;
                lx_nconc := null;
              
            end;
          
        end;
      
      end if;
    
      pn_nconc := trim(lx_nconc) ;
    exception
      when others then
        pn_ntipo := 0;
        lx_nconc := null;
        pn_nconc := lx_nconc;
      
    end;
  
  end sp_tipo_credito_sbs_vig;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig2(pn_cod     in number,
                                    pn_mod     in number,
                                    pn_suc     in number,
                                    pn_mda     in number,
                                    pn_pap     in number,
                                    pn_cta     in number,
                                    pn_ope     in number,
                                    pn_sbo     in number,
                                    pn_top     in number,
                                    pn_fecha   in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    ) is
  
    ld_fecha date;
    --lx_conce     char(25);
    ld_fecha_ant date;
    pn_ufech     date;
    ln_anio      number(5);
    ld_nconc     char(50);
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
    
      SELECT
      
       max(t.ppfpag)
        into pn_ufech
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
         and t.d602fc <= pn_fecha;
    exception
      when others then
        pn_ufech := null;
      
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if pn_ufech is not null then
      ld_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if ld_fecha <> pn_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select /*+index(t FSH01204)*/ t.bcgpo tipo,
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
            into pn_ntipo, pn_nconc
            from fsh012 t --- fsd011
           where t.bcemp = pn_cod
             and t.bcmod = pn_mod
             and t.bcsuc = pn_suc --  jrodriguej 28.06.2021
             and t.bcmda = pn_mda
             and t.bcpap = pn_pap
             and t.bccta = pn_cta
             and t.bcoper = pn_ope
             and t.bcsbop = pn_sbo
             and t.bctop = pn_top
             and t.bcfech = pn_fecha
             and t.bcsdmn <> 0
             and rownum = 1;
        
        exception
          when others then
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
            into pn_ntipo, pn_nconc
            from fsh012 t --- fsd011
           where t.bcemp = pn_cod
             and t.bcmod = pn_mod
                -- and t.bcsuc = pn_suc --  jrodriguej 28.06.2021
             and t.bcmda = pn_mda
             and t.bcpap = pn_pap
             and t.bccta = pn_cta
             and t.bcoper = pn_ope
                --and t.bcsbop = pn_sbo
             and t.bctop = pn_top
             and t.bcfech = pn_fecha
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
                into pn_ntipo, pn_nconc
              
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
              
                pn_ntipo := 0;
                pn_nconc := null;
              
            end;
          
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
            into pn_ntipo, pn_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
                --and t.scsuc = pn_suc --  jrodriguej 28.06.2021
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
                into pn_ntipo, pn_nconc
              
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
              
                pn_ntipo := 0;
                pn_nconc := null;
              
            end;
          
        end;
      
      end if;
    
    exception
      when others then
        pn_ntipo := 0;
        pn_nconc := null;
      
    end;
  
  end sp_tipo_credito_sbs_vig2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_upago(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date is
  
    lx_fpago date;
  
  begin
  
    begin
    
      SELECT
      
       max(t.d602fc)
        into lx_fpago
        FROM FSD602 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         --and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         --and t.ppsbop = pn_sbo
         --and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pn_fecha
            
         and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
             (select j.tp1nro1, j.tp1nro2
                from fst198 j
               where j.TP1COD = 1
                 and j.TP1COD1 = 11144
                 and j.TP1CORR1 = 1
                 and j.tp1corr2 = 2
                 and j.tp1corr3 > 0)
         and (t.d602mo, t.d602tr) not in
             ( --- Transacciones de incremento línea
              select h.tp1nro1, h.tp1nro2
                from fst198 h
               where h.TP1COD = 1
                 and h.TP1COD1 = 11144
                 and h.TP1CORR1 = 1
                 and h.tp1corr2 = 8
                 and h.tp1corr3 > 0);
    exception
      when others then
        lx_fpago := null;
    end;
  
    return lx_fpago;
  
  end fn_fecha_upago;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,
                            
                            pn_calif0 out aqpb379.aqpb379canom%type,
                            pn_calif1 out aqpb379.aqpb379cacpp%type,
                            pn_calif2 out aqpb379.aqpb379cadef%type,
                            pn_calif3 out aqpb379.aqpb379cadud%type,
                            pn_calif4 out aqpb379.aqpb379caper%type,
                            pn_csbs   out aqpb379.aqpb379csbs%type) is
    -- Obtener Calificación SBS
    lc_fecha     date;
    lc_fecha_pro date;
    lc_fecha_rcc date;
    lc_nro_mes   number(3);
  
  begin
  
    --select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into lc_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        lc_nro_mes := 1;
    end;
  
    -- 2. Fecha RCC
    select to_date(t.tpnro, 'DDMMYY')
      into lc_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    if pn_fech <= lc_fecha_rcc then
      lc_fecha_pro := last_day(add_months(trunc(pn_fech), -1 * lc_nro_mes));
    else
      lc_fecha_pro := lc_fecha_rcc;
    end if;
  
    -- Código de cliente SBS (dato del BT)
    -- Verificar tipo de documento
    if pn_tdoc = 21 then
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into pn_csbs,
               pn_calif0,
               pn_calif1,
               pn_calif2,
               pn_calif3,
               pn_calif4
          from cldrcci t
         where t.d_fecpre = lc_fecha_pro
           and t.c_tdocid =
               pq_cr_reporte_fondofaeagro.FN_EQUIVALENCIADOC(pn_tdoc)
           and t.c_docide = lpad(trim(to_char(pn_ndoc)), 8, '0');
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into pn_csbs,
                   pn_calif0,
                   pn_calif1,
                   pn_calif2,
                   pn_calif3,
                   pn_calif4
              from cldrcci t
             where t.d_fecpre = lc_fecha_pro
               and t.c_tdocid =
                   pq_cr_reporte_fondofaeagro.FN_EQUIVALENCIADOC(pn_tdoc)
               and t.c_docide = lpad(trim(to_char(pn_ndoc)), 8, '0')
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              pn_csbs   := 0;
              pn_calif0 := 100;
              pn_calif1 := 0;
              pn_calif2 := 0;
              pn_calif3 := 0;
              pn_calif4 := 0;
          end;
        
        --exception
        when others then
          pn_csbs   := 0;
          pn_calif0 := 100;
          pn_calif1 := 0;
          pn_calif2 := 0;
          pn_calif3 := 0;
          pn_calif4 := 0;
      end;
    
    else
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into pn_csbs,
               pn_calif0,
               pn_calif1,
               pn_calif2,
               pn_calif3,
               pn_calif4
          from cldrcci t
         where t.d_fecpre = lc_fecha_pro
           and t.c_tdoctr =
               pq_cr_reporte_fondofaeagro.FN_EQUIVALENCIADOC(pn_tdoc)
           and t.c_doctri = trim(pn_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into pn_csbs,
                   pn_calif0,
                   pn_calif1,
                   pn_calif2,
                   pn_calif3,
                   pn_calif4
              from cldrcci t
             where t.d_fecpre = lc_fecha_pro
               and t.c_tdoctr =
                   pq_cr_reporte_fondofaeagro.FN_EQUIVALENCIADOC(pn_tdoc)
               and t.c_doctri = trim(pn_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              pn_csbs   := 0;
              pn_calif0 := 100;
              pn_calif1 := 0;
              pn_calif2 := 0;
              pn_calif3 := 0;
              pn_calif4 := 0;
          end;
        
        --exception
        when others then
          pn_csbs   := 0;
          pn_calif0 := 100;
          pn_calif1 := 0;
          pn_calif2 := 0;
          pn_calif3 := 0;
          pn_calif4 := 0;
      end;
    
    end if;
  
  end sp_obtener_calf;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_calf_caja(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_est   in number,
                                 pn_fecha in date,
                                 
                                 pn_calif0a out aqpb379.aqpb379clnom%type,
                                 pn_calif1a out aqpb379.aqpb379clcpp%type,
                                 pn_calif2a out aqpb379.aqpb379cldef%type,
                                 pn_calif3a out aqpb379.aqpb379cldud%type,
                                 pn_calif4a out aqpb379.aqpb379clper%type,
                                 pn_deccaj  out date) is
  
    lc_dcla number(14, 2);
    lc_tcla number(4);
    lc_ncla varchar2(10);
  
    lc_distrib   char(15);
    lc_fecha_fin date;
    lc_fecha_pro date;
  
  begin
  
    begin
    
      -- 0: NORMAL
      -- 1: CPP
      -- 2: DEFICIENTE
      -- 3: DUDOSO
      -- 4: PÉRDIDA
    
      lc_fecha_pro := last_day(add_months(trunc(pn_fecha), -1));
    
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
          pn_calif0a := 100;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 0;
        
        when lc_tcla = 1 then
          -- 1: CPP
          --lc_ncla := 'CPP';
          pn_calif0a := 0;
          pn_calif1a := 100;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 0;
        when lc_tcla = 2 then
          -- 2: Deficiente
          --lc_ncla := 'Deficiente';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 100;
          pn_calif3a := 0;
          pn_calif4a := 0;
        when lc_tcla = 3 then
          -- 3: Dudoso
          --lc_ncla := 'Dudoso';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 100;
          pn_calif4a := 0;
        when lc_tcla = 4 then
          -- 4: Pérdida
          --lc_ncla := 'PÉRDIDA';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 100;
      end case;
    
    exception
      when others then
      
        pn_calif0a := 100;
        pn_calif1a := 0;
        pn_calif2a := 0;
        pn_calif3a := 0;
        pn_calif4a := 0;
      
    end;
  
    pn_deccaj := lc_fecha_pro;
    --pn_dcla := lc_dcla;
    --pn_ncla := lc_ncla;
  
  end sp_obtener_calf_caja;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_scond_c(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pn_fecha in date,
                               --pn_dcon  in char,
                               pn_est     in number,
                               pn_usuario in char,
                               
                               pn_rubr out char,
                               pn_resp out char) is
    --- Situación Conable  
    lx_rubro     char(4);
    lx_fecha_ant date;
    lx_fecha     date;
    lx_rubro_c   char(4);
  
  begin
  
    --- Fecha
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    if lx_fecha = pn_fecha then
      begin
        select substr(x.scrub, 1, 4)
          into lx_rubro_c
          from fsd011 x
         where x.pgcod = pn_cod
           and x.scmod = pn_mod
           and x.scsuc = pn_suc
           and x.scmda = pn_mda
           and x.scpap = pn_pap
           and x.sccta = pn_cta
           and x.scoper = pn_ope
           and x.scsbop = pn_sbo
           and x.sctope = pn_top
           ;
      
      exception
        when others then
          begin
            select substr(x.scrub, 1, 4)
              into lx_rubro_c
              from fsd011 x
             where x.pgcod = pn_cod
               and x.scmod = pn_mod
               --and x.scsuc = pn_suc
               and x.scmda = pn_mda
               and x.scpap = pn_pap
               and x.sccta = pn_cta
               and x.scoper = pn_ope
               --and x.scsbop = pn_sbo
               --and x.sctope = pn_top
               ;
          
          exception
            when others then
              lx_rubro_c := null;
          end;
      end;
    
    else
      begin
      
        select substr(x.bcrubr, 1, 4)
          into lx_rubro_c
          from fsh012 x
         where x.bcemp = pn_cod
           and x.bcmod = pn_mod
           and x.bcsuc = pn_suc
           and x.bcmda = pn_mda
           and x.bcpap = pn_pap
           and x.bccta = pn_cta
           and x.bcoper = pn_ope
           and x.bcsbop = pn_sbo 
           and x.bctop = pn_top
           and x.bcfech = pn_fecha;
      
      exception
        when others then
          /*begin
      
            select substr(x.bcrubr, 1, 4)
              into lx_rubro_c
              from fsh012 x
             where x.bcemp = pn_cod
               and x.bcmod = pn_mod
               and x.bcsuc = pn_suc
               and x.bcmda = pn_mda
               and x.bcpap = pn_pap
               and x.bccta = pn_cta
               and x.bcoper = pn_ope
               and x.bcsbop = pn_sbo 
               and x.bctop = pn_top
               and x.bcfech = pn_fecha;
          
          exception
            when others then*/
              lx_rubro_c := null;
          --end;
      end;
    
    end if;
  
    if pn_est = 99 and lx_rubro_c is null then
    
      lx_rubro := '';
    
    elsif pn_est = 61 then
      ---refinanciado
      -- REFINANCIADO
      pn_resp := 'RFN';
      pn_rubr := lx_rubro;
      return;
    else
      begin
        lx_rubro := substr(lx_rubro_c, 1, 4);
      exception
        when others then
          lx_rubro := null;
      end;
    end if;
  
    begin
    
      pn_rubr := lx_rubro;
    
      case
        when lx_rubro = '1411' then
          -- NORMAL
          pn_resp := 'VGT';
        when lx_rubro = '1421' then
          -- NORMAL
          pn_resp := 'VGT';
        when lx_rubro = '1414' then
          -- REFINANCIADO
          pn_resp := 'RFN';
        when lx_rubro = '1424' then
          -- REFINANCIADO
          pn_resp := 'RFN';
        when lx_rubro = '1415' then
          -- VENCIDO
          pn_resp := 'VCD';
        when lx_rubro = '1425' then
          -- VENCIDO
          pn_resp := 'VCD';
        when lx_rubro = '1416' then
          -- JUDICIAL
          pn_resp := 'JDC';
        when lx_rubro = '1426' then
          -- JUDICIAL
          pn_resp := 'JDC';
        when lx_rubro = '81' then
          -- CASTIGADO
          pn_resp := 'CTG';
        when lx_rubro = '1413' then
          -- REESTRUCUTRADO
          pn_resp := 'RTR';
        when lx_rubro = '1423' then
          -- REESTRUCUTRADO
          pn_resp := 'RTR';
        else
          pn_resp := '';
      end case;
    exception
      when others then
        pn_rubr := '';
        pn_resp := '';
    end;
    if substr(lx_rubro, 1, 2) = '81' then
       pn_resp := 'CTG';
    end if;
  
  end sp_obtener_scond_c;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_pgracia2(pn_cod in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number) return number is
  
    lx_ope1  number(3);
    lx_ope2  number(5);
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
           --and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           --and x.pptope = pn_top
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
      
        --select ((t.xllfprimpa - t.xllfvalor) - t.xllperiodo)
        --  into lx_resp
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
             and t.xllaotop = pn_top
             ;
        exception
          when others then
             begin
              select t.xllfvalor, t.xllperiodo
                into lx_fvlor, lx_peri
                from X054023 t
               where t.xllpgcod = pn_cod
                 --and t.xllaomod = pn_mod
                 --and t.xllaosuc = pn_suc
                 and t.xllaomda = pn_mda
                 and t.xllaopap = pn_pap
                 and t.xllaocta = pn_cta
                 and t.xllaooper = pn_ope
                 --and t.xllaosbop = pn_sbo
                 --and t.xllaotop = pn_top
                 ;
            exception
              when others then
                lx_fvlor := null;
                lx_peri  := 0;
            end;
        end;
      
        if lx_peri = 0 then
          lx_resp := 0;
        else
          lx_resp := (lx_fpri - lx_fvlor) / 30;
          --lx_resp := (lx_fpri - lx_fvlor) - lx_peri;
          --lx_resp := (lx_fpri - lx_fvlor - lx_peri)/lx_peri;
        end if;
      
        --- jrodriguej 16.05.2021
        if lx_resp <= 0 then
          lx_resp := 0;
        end if;
      
      end if;
    
    exception
      when others then
        lx_resp := 0;
    end;
  
    return lx_resp;
  
  end fn_obtener_pgracia2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_obtener_sucs(pn_sucs in number,
                            pn_regi out number,
                            pn_zona out number,
                            pn_nsuc out aqpb065.aqpb065nsuc%type,
                            pn_nzon out aqpb065.aqpb065nzon%type,
                            pn_nreg out aqpb065.aqpb065nreg%type) is
  
    --  pn_nsuc char(30);
    --  pn_nzon char(40);
    --  pn_nreg char(30);
  
  begin
  
    -- Nombre de la sucursal
    select t.scnom into pn_nsuc from fst001 t where t.sucurs = pn_sucs;
  
    -- Región
  
    select t.regcod
      into pn_zona
      from fst811 t
     where t.pgcod = 1
       and t.oficod = pn_sucs
       and t.regcod < 100
       and t.regcod <> 0;
  
    select t.regnom
      into pn_nzon
      from fst810 t
     where t.pgcod = 1
       and t.regcod = pn_zona;
  
    -- Zona
    select t.tp1nro1, t.tp1desc ---tp1desc(zona) char(30)
      into pn_regi, pn_nreg
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 10872
       and t.tp1corr1 = 11
       and t.tp1nro2 = pn_zona;
  
  end sp_obtener_sucs;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_distribuc_pago_acum(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tsum  out number,
                                   pn_gas   out number, -- seguridad
                                   pn_mor   out number, -- moratoria
                                   pn_int   out number, -- interés
                                   pn_cuo   out number, -- capital
                                   pn_icv   out number, -- interés compensatorio (icv)
                                   pn_pen   out number) -- penalidad
   is
    -- Considera los pagos acumulados del crédito vigente con respecto a la fecha de corte
    lc_ppfpag  date;
    lc_pp1nump number(9);
  
  begin
    -- clave
  
    begin
    
      select f.ppfpag, f.pp1nump
        into lc_ppfpag, lc_pp1nump
        from (select t.ppfpag, t.pp1nump
                from fsd602 t
               where t.pgcod = pn_cod
                 --and t.ppmod = pn_mod
                 and t.ppsuc = pn_suc
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 --and t.ppsbop = pn_sbo
                 --and t.pptope = pn_top
                 and t.pp1stat in ('P', 'T')
                 and t.d602fc <= pn_fecha
                 and t.d602co = 'S'
                 and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
                     (select j.tp1nro1, j.tp1nro2
                        from fst198 j
                       where j.TP1COD = 1
                         and j.TP1COD1 = 11144
                         and j.TP1CORR1 = 1
                         and j.tp1corr2 = 2
                         and j.tp1corr3 > 0)
                 and (t.d602mo, t.d602tr) not in
                     (select x.tp1nro1, x.tp1nro2
                        from fst198 x
                       where x.TP1COD = 1
                         and x.TP1COD1 = 11144
                         and x.TP1CORR1 = 1
                         and x.tp1corr2 = 8
                         and x.tp1corr3 > 0)
               order by t.pp1nump desc) f
       where rownum = 1;
    exception
      when others then
        lc_ppfpag  := null;
        lc_pp1nump := null;
    end;
  
    if lc_ppfpag is not null then
    
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
        
          from fsd602 t
         where t.pgcod = pn_cod
           --and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           --and t.ppsbop = pn_sbo
           --and t.pptope = pn_top
           and t.ppfpag <= lc_ppfpag
           and t.pp1nump <= lc_pp1nump
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      
      exception
        when others then
          pn_cuo := 0;
          pn_int := 0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into pn_mor, pn_icv, pn_gas
          from fsd612 x, fsd602 t
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
           --and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           --and x.pptope = pn_top
           and x.pp1nump <= lc_pp1nump
              
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      
      exception
        when others then
          pn_mor := 0;
          pn_icv := 0;
          pn_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into pn_pen
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
           --and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           --and x.pptope = pn_top
           and x.pp003nump <= lc_pp1nump
              
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      exception
        when others then
          pn_pen := 0;
      end;
    
    else
      pn_gas := 0;
      pn_mor := 0;
      pn_int := 0;
      pn_cuo := 0;
      pn_icv := 0;
      pn_pen := 0;
    end if;
  
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago_acum;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Número de cuotas pendientes de pago
  procedure sp_ncuotas_pagadas(pn_cod      in number,
                               pn_mod      in number,
                               pn_suc      in number,
                               pn_mda      in number,
                               pn_pap      in number,
                               pn_cta      in number,
                               pn_ope      in number,
                               pn_sbo      in number,
                               pn_top      in number,
                               pn_fecha    in date,
                               pn_ncuo_tot out number,
                               pn_ncuo_pag out number)
  ---- Número de cuotas totales, número cuotas pagadas
   is
  
    lc_conta number(3);
    lc_sbop  number(3);
  
  begin
    --- Nro cuotas totales
    begin
    
      select count(*)
        into pn_ncuo_tot
        from fsd601 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         --and t.ppsbop = pn_sbo
         --and t.pptope = pn_top
         and t.d601co = 'S';
    
    exception
      when others then
        pn_ncuo_tot := 0;
    end;
  
    --- Nro cuotas pagadas
    begin
    
      select count(*)
        into pn_ncuo_pag
        from fsd602 t
       where t.pgcod = pn_cod
        -- and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            --and t.ppsbop = pn_sbo
            --and t.pptope = pn_top
         and t.pp1stat in ('T') ---- P: PARCIAL, T: TOTAL, solo considerar pagos totales  01.02.2021 jrodriguej
         and (t.d602mo, t.d602tr) not in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 2
                 and x.tp1corr3 > 0)
         and (t.d602mo, t.d602tr) not in
             ( --- Transacciones de incremento línea
              select h.tp1nro1, h.tp1nro2
                from fst198 h
               where h.TP1COD = 1
                 and h.TP1COD1 = 11144
                 and h.TP1CORR1 = 1
                 and h.tp1corr2 = 8
                 and h.tp1corr3 > 0)
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    exception
      when others then
        pn_ncuo_pag := 0;
    end;
  
  end sp_ncuotas_pagadas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener días de atraso de última cuota impaga
  procedure sp_obtener_datraso_uimp(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_diat  out number) is
  
    --lx_fmax date;
    --lx_ind1 number;
  
    lx_fpag  date;
    lx_fmin  date;
    lx_fdia  date;
    lx_diff  number(5);
    lx_cont  number(3);
    lx_pgcod number(3);
  
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
  
    -- ================================
    begin
    
      begin
        select count(*)
          into lx_cont
          from fsd602 t
         where t.pgcod = pn_cod
           --and t.ppmod = pn_mod
           --and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           --and t.ppsbop = pn_sbo
           --and t.pptope = pn_top
           and t.pp1stat = 'T'
           and T.D602CO = 'S'
           and T.D602FC <= pn_fecha
              
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           /*and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0)*/
                   ;
      exception
        when others then
          lx_cont := 0;
      end;
    
      if lx_cont = 0 then
        --dbms_output.put_line('1: ');
      
        begin
          select count(*)
            into lx_cont
            from fsd601 t
           where t.pgcod = pn_cod
             --and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             --and t.pptope = pn_top
                ---and t.ppfpag > lx_fpag
             and t.d601co = 'S';
        exception
          when others then
            lx_cont := 0;
        end;
      
        if lx_cont > 0 then
        
          begin
            select min(t.ppfpag), t.pgcod
              into lx_fmin, lx_pgcod
              from fsd601 t
             where t.pgcod = pn_cod
               --and t.ppmod = pn_mod
               --and t.ppsuc = pn_suc
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               --and t.ppsbop = pn_sbo
               --and t.pptope = pn_top
                  ---and t.ppfpag > lx_fpag
               and t.d601co = 'S'
             group by t.pgcod;
          exception
            when others then
              lx_fmin := null;
          end;
        
        else
        
          lx_fmin := null;
        
        end if;
      
      else
        --dbms_output.put_line('2: ');
      
        -- Obtención de la máxima fecha pagada
        begin
          select max(t.ppfpag)
            into lx_fpag
            from fsd602 t
           where t.pgcod = pn_cod
             --and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             --and t.pptope = pn_top
             and t.pp1stat = 'T'
             and T.D602CO = 'S'
             and T.D602FC <= pn_fecha
                
             and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
                 (select j.tp1nro1, j.tp1nro2
                    from fst198 j
                   where j.TP1COD = 1
                     and j.TP1COD1 = 11144
                     and j.TP1CORR1 = 1
                     and j.tp1corr2 = 2
                     and j.tp1corr3 > 0)
             /*and (t.d602mo, t.d602tr) not in
                 ( --- Transacciones de incremento línea
                  select h.tp1nro1, h.tp1nro2
                    from fst198 h
                   where h.TP1COD = 1
                     and h.TP1COD1 = 11144
                     and h.TP1CORR1 = 1
                     and h.tp1corr2 = 8
                     and h.tp1corr3 > 0)*/;
        exception
          when others then
            lx_fpag := null;
        end;
        if pn_top = 550 then
          begin
          select min(t.ppfpag)
            into lx_fmin
            from fsd601 t
           where t.pgcod = pn_cod
             --and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             --and t.pptope = pn_top
             and t.ppfpag >= lx_fpag
             and t.d601co = 'S';
          exception
            when others then
              lx_fmin := null;
            
          end;
        else
        begin
          select min(t.ppfpag)
            into lx_fmin
            from fsd601 t
           where t.pgcod = pn_cod
             --and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             --and t.pptope = pn_top
             and t.ppfpag > lx_fpag
             and t.d601co = 'S';
        exception
          when others then
            lx_fmin := null;
          
        end;
        end if;
      
      end if;
      -- Verificar si hay cuotas pendientes de pago
      if lx_fmin is not null then
        if lx_fdia = pn_fecha then
        
          lx_diff := lx_fdia - lx_fmin;
        
        else
        
          lx_diff := pn_fecha - lx_fmin;
        
        end if;
      else
        lx_diff := 0;
      end if;
    
      if lx_diff < 0 then
        lx_diff := 0;
      end if;
    
      pn_diat := lx_diff;
    
    exception
      when others then
        pn_diat := 0;
      
    end;
    -- ================================
  
  end sp_obtener_datraso_uimp;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_estado_desc(pd_stat in number)
    return aqpb379.aqpb379nestcre%type is
  
    lx_desc char(30);
  
  begin
    --Fórmula:X054032(XLLAOCNTP) * X054023(xllperiodo)
  
    -- 1. X054032(XLLAOCNTP)
    begin
      select t.cenom into lx_desc from fst026 t where t.cecod = pd_stat;
    exception
      when others then
        lx_desc := '';
    end;
  
    return lx_desc;
  
  end fn_estado_desc;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_flag_amrtzn(pn_cod   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_sbo   in number,
                           pn_top   in number,
                           pn_fecha in date,
                           pn_flarm out aqpb379.aqpb379amort%type,
                           pn_fecrm out date) is
  
    lx_cont number;
  
  begin
  
    begin
    
      SELECT count(*)
        into lx_cont
        FROM fsd012 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
            --and t.aosuc = pn_suc
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
            --and t.aosbop = pn_sbo
         and t.aotope = pn_top
         and t.evtipo = 50
         and t.d012co = 'S'
         and t.d012fc <= pn_fecha;
    
      if lx_cont > 0 then
        pn_flarm := 'SI';
      
        SELECT max(t.d012fc)
          into pn_fecrm
          FROM fsd012 t
         where t.pgcod = pn_cod
           and t.aomod = pn_mod
              --and t.aosuc = pn_suc
           and t.aomda = pn_mda
           and t.aopap = pn_pap
           and t.aocta = pn_cta
           and t.aooper = pn_ope
              --and t.aosbop = pn_sbo
           and t.aotope = pn_top
           and t.evtipo = 50
           and t.d012co = 'S'
           and t.d012fc <= pn_fecha;
      
      else
        pn_flarm := 'NO';
        pn_fecrm := null;
      end if;
    
    exception
      when others then
      
        pn_flarm := 'NO';
        pn_fecrm := null;
      
    end;
  end sp_flag_amrtzn;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener monto capital amortizado
  procedure sp_obtener_cap_amort(pn_cod    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_ope    in number,
                                 pn_sbo    in number,
                                 pn_top    in number,
                                 pn_ord    in number,
                                 pn_fcorte in date,
                                 
                                 pn_impl out number) --return number
   is
  
    --lx_imp  number(17, 2);
    lx_cd number(3);
    lx_mo number(3);
    lx_su number(3);
    lx_tr number(3);
    lx_re number(4);
    lx_fc date;
    --lx_imp1 number(17, 2);
    --lx_sdoi number(17, 2);
  
    lx_fecha date;
    lx_cont  number;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
    -- Amortización o negociación
    begin
    
      lx_cont := 0;
      if nvl(lx_cont, 0) = 0 then
      
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
                      --and t.aosuc = pn_suc
                   and t.aomda = pn_mda
                   and t.aopap = pn_pap
                   and t.aocta = pn_cta
                   and t.aooper = pn_ope
                      --and t.aosbop = pn_sbo
                   and t.aotope = pn_top
                   and t.evtipo = 50
                   and t.d012co = 'S'
                   and t.d012fc <= pn_fcorte
                 order by t.d012fc desc) f
         where rownum = 1;
      
      end if;
    
      --if lx_fecha <> pn_fcorte then
      if lx_fc <> pn_fcorte then
        begin
          ---si es la actual que busque en la fsd016
          ---compara con la fecha del sistema
          select t.hcimp1 --, t.hfcon
            into pn_impl --, pn_fech
            from fsh016 t, fsh015 x
           where t.pgcod = x.pgcod
             and t.hcmod = x.hcmod
             and t.hsucor = x.hsucor
             and t.htran = x.htran
             and t.hnrel = x.hnrel
             and t.hfcon = x.hfcon
                
             and t.pgcod = lx_cd
             and t.hcmod = lx_mo
             and t.hsucor = lx_su
             and t.htran = lx_tr
             and t.hnrel = lx_re
             and t.hfcon = lx_fc
             and t.hcord = pn_ord
             and substr(to_char(t.hrubro), 1, 2) not in ('42')
                
             and x.hccorr = 0; ---83
        exception
          when others then
          
            if pn_ord = 83 then
              begin
                select t.hcimp1 --, t.hfcon
                  into pn_impl --, pn_fech
                  from fsh016 t, fsh015 x
                 where t.pgcod = x.pgcod
                   and t.hcmod = x.hcmod
                   and t.hsucor = x.hsucor
                   and t.htran = x.htran
                   and t.hnrel = x.hnrel
                   and t.hfcon = x.hfcon
                      
                   and t.pgcod = lx_cd
                   and t.hcmod = lx_mo
                   and t.hsucor = lx_su
                   and t.htran = lx_tr
                   and t.hnrel = lx_re
                   and t.hfcon = lx_fc
                   and t.hcord = 82
                   and substr(to_char(t.hrubro), 1, 2) not in ('42')
                   and x.hccorr = 0; ---83   
              exception
                when others then
                
                  begin
                  
                    select t.hcimp1 --, t.hfcon
                      into pn_impl --, pn_fech
                      from fsh016 t, fsh015 x
                     where t.pgcod = x.pgcod
                       and t.hcmod = x.hcmod
                       and t.hsucor = x.hsucor
                       and t.htran = x.htran
                       and t.hnrel = x.hnrel
                       and t.hfcon = x.hfcon
                          
                       and t.pgcod = lx_cd
                       and t.hcmod = lx_mo
                       and t.hsucor = lx_su
                       and t.htran = lx_tr
                       and t.hnrel = lx_re
                       and t.hfcon = lx_fc
                       and t.hcord = 84
                       and substr(to_char(t.hrubro), 1, 2) not in ('42')
                       and x.hccorr = 0; ---83 
                  
                  exception
                    when others then
                    
                      begin
                      
                        select t.hcimp1 --, t.hfcon
                          into pn_impl --, pn_fech
                          from fsh016 t, fsh015 x
                         where t.pgcod = x.pgcod
                           and t.hcmod = x.hcmod
                           and t.hsucor = x.hsucor
                           and t.htran = x.htran
                           and t.hnrel = x.hnrel
                           and t.hfcon = x.hfcon
                              
                           and t.pgcod = lx_cd
                           and t.hcmod = lx_mo
                           and t.hsucor = lx_su
                           and t.htran = lx_tr
                           and t.hnrel = lx_re
                           and t.hfcon = lx_fc
                           and t.hcord = 81
                           and substr(to_char(t.hrubro), 1, 2) not in
                               ('42')
                           and x.hccorr = 0; ---83                       
                      
                      exception when others then null;
                      end;
                    
                  end;
                
              end;
            end if;
          
        end;
      else
        begin
        
          select t.itimp1 --, t.itfval
            into pn_impl --, pn_fech
            from fsd016 t, fsd015 x
           where t.pgcod = x.pgcod
             and t.itsuc = x.itsuc
             and t.itmod = x.itmod
             and t.ittran = x.ittran
             and t.itnrel = x.itnrel
                
             and t.pgcod = lx_cd
             and t.itmod = lx_mo
             and t.itsuc = lx_su
             and t.ittran = lx_tr
             and t.itnrel = lx_re
                --and t.hfcon = lx_fc
             and t.itord = pn_ord
             and x.itcont = 'S'
             and substr(to_char(t.rubro), 1, 2) not in ('42')
             and x.itcorr = 0
          
          ; ---83
        exception
          when others then
            if pn_ord = 83 then
              begin
              
                select t.itimp1 --, t.itfval
                  into pn_impl --, pn_fech
                  from fsd016 t, fsd015 x
                 where t.pgcod = x.pgcod
                   and t.itsuc = x.itsuc
                   and t.itmod = x.itmod
                   and t.ittran = x.ittran
                   and t.itnrel = x.itnrel
                      
                   and t.pgcod = lx_cd
                   and t.itmod = lx_mo
                   and t.itsuc = lx_su
                   and t.ittran = lx_tr
                   and t.itnrel = lx_re
                      --and t.hfcon = lx_fc
                   and t.itord = 82
                   and x.itcont = 'S'
                   and substr(to_char(t.rubro), 1, 2) not in ('42')
                   and x.itcorr = 0;
              
              exception
                when others then
                
                  begin
                  
                    select t.itimp1 --, t.itfval
                      into pn_impl --, pn_fech
                      from fsd016 t, fsd015 x
                     where t.pgcod = x.pgcod
                       and t.itsuc = x.itsuc
                       and t.itmod = x.itmod
                       and t.ittran = x.ittran
                       and t.itnrel = x.itnrel
                          
                       and t.pgcod = lx_cd
                       and t.itmod = lx_mo
                       and t.itsuc = lx_su
                       and t.ittran = lx_tr
                       and t.itnrel = lx_re
                          --and t.hfcon = lx_fc
                       and t.itord = 84
                       and x.itcont = 'S'
                       and substr(to_char(t.rubro), 1, 2) not in ('42')
                       and x.itcorr = 0;
                  
                  exception
                    when others then
                    
                      begin
                      
                        select t.itimp1 --, t.itfval
                          into pn_impl --, pn_fech
                          from fsd016 t, fsd015 x
                         where t.pgcod = x.pgcod
                           and t.itsuc = x.itsuc
                           and t.itmod = x.itmod
                           and t.ittran = x.ittran
                           and t.itnrel = x.itnrel
                              
                           and t.pgcod = lx_cd
                           and t.itmod = lx_mo
                           and t.itsuc = lx_su
                           and t.ittran = lx_tr
                           and t.itnrel = lx_re
                              --and t.hfcon = lx_fc
                           and t.itord = 81
                           and x.itcont = 'S'
                           and substr(to_char(t.rubro), 1, 2) not in ('42')
                           and x.itcorr = 0;
                      
                      end;
                    
                  end;
                
              end;
            end if;
          
        end;
      end if;
    exception
      when others then
        pn_impl := 0;
        --pn_fech := null;
    end;
  
    --return lx_imp1;
  
  end sp_obtener_cap_amort;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener fecha de pago y de vencimiento de última cuota pagada
  procedure sp_obtener_datos_ufecha(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_fpagu out date, -- Fecha de la última cuota pagada: ppfpag
                                    pn_fvenu out date) is
    -- Fecha de vencimiento de la última cuota pagada
  
    lx_fpagu date;
    lx_fvenu date;
  
  begin
  
    begin
    
      -- Obtener última fecha de pago
      SELECT
      
      --max(t.d602fc)
       max(t.ppfpag)
        into lx_fpagu
        FROM FSD602 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         --and t.ppsbop = pn_sbo
         --and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.d602co = 'S'
         and t.d602fc <= pn_fecha
            
         and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
             (select j.tp1nro1, j.tp1nro2
                from fst198 j
               where j.TP1COD = 1
                 and j.TP1COD1 = 11144
                 and j.TP1CORR1 = 1
                 and j.tp1corr2 = 2
                 and j.tp1corr3 > 0)
         and (t.d602mo, t.d602tr) not in
             ( --- Transacciones de incremento línea
              select h.tp1nro1, h.tp1nro2
                from fst198 h
               where h.TP1COD = 1
                 and h.TP1COD1 = 11144
                 and h.TP1CORR1 = 1
                 and h.tp1corr2 = 8
                 and h.tp1corr3 > 0);
    exception
      when others then
        lx_fpagu := null;
    end;
  
    if lx_fpagu is null then
      --no se ha hecho ningún pago
      lx_fvenu := null;
    
    else
      --- se realizó un pago
      begin
        select t.ppfvto
          into lx_fvenu
          from fsd601 t
         where t.pgcod = pn_cod
           --and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           --and t.ppsbop = pn_sbo
           --and t.pptope = pn_top
           and t.ppfpag = lx_fpagu
           and (t.ppcap + t.ppint) <> 0
         order by t.ppfpag asc;
      exception
        when others then
          lx_fvenu := null;
      end;
    end if;
  
    pn_fpagu := lx_fpagu;
    pn_fvenu := lx_fvenu;
  
  end sp_obtener_datos_ufecha;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_reprog_datos(pn_cod   in number,
                            pn_cta   in number,
                            pn_ope   in number,
                            pn_fecha in date,
                            
                            pn_flag out char,
                            pn_frep out date) is
  
    lx_cont number;
  
  begin
  
    select count(*)
      into lx_cont
      from aqpb090 x
     where x.aqpb090fec <= pn_fecha
       and x.aqpb090cta = pn_cta
       and x.aqpb090oper = pn_ope
       and x.aqpb090ext = 'NO';
  
    if lx_cont > 0 then
    
      pn_flag := 'SI';
    
      select y.aqpb090fec --, y.aqpb090tabla
        into pn_frep --, pn_tabla
        from (select x.aqpb090fec, x.aqpb090tabla
                from aqpb090 x
               where x.aqpb090fec <= pn_fecha
                 and x.aqpb090cta = pn_cta
                 and x.aqpb090oper = pn_ope
                 and x.aqpb090ext = 'NO'
                 and x.aqpb090tabla in ('AQPB002', 'JAQZ698', 'JAQA400')
               order by x.aqpb090fec desc) y
       where rownum = 1;
    
    else
      pn_flag := 'NO';
      pn_frep := null;
    end if;
  
  end sp_reprog_datos;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_fsd010(pn_cod  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pn_mdes out number,
                              pn_fval out date,
                              pn_fven out date) is
  
    --lx_fdes date;
  
  begin
  
    begin
    
      SELECT t.aoimp, t.aofval, t.aofvto
        into pn_mdes, pn_fval, pn_fven
        FROM fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
         and t.aosuc = pn_suc
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
         and t.aosbop = pn_sbo
         --and t.aotope = pn_top
         ;
    
    exception
      when others then
      
        pn_mdes := 0;
        pn_fval := null;
        pn_fven := null;
      
    end;
  
  end sp_obtener_fsd010;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_distribuc_pago_mes(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fecha in date,
                                  pn_tsum  out number,
                                  pn_gas   out number, -- seguridad
                                  pn_mor   out number, -- moratoria
                                  pn_int   out number, -- interés
                                  pn_cuo   out number, -- capital
                                  pn_icv   out number, -- interés compensatorio (icv)
                                  pn_pen   out number) -- penalidad
   is
    -- Considera los pagos acumulados del crédito vigente con respecto a la fecha de corte
    lc_ppfpag     date;
    lc_pp1nump_mx number(9);
    lc_pp1nump_mn number(9);
    lc_fini       date;
    lx_mext       number(17,2);
    lx_shon       number(17,2);
    lx_shon_ext       number(17,2);
  
  begin
    -- clave
  
    lc_fini := trunc(pn_fecha) - (to_number(to_char(pn_fecha, 'DD')) - 1);
  
    begin
    
      select max(t.pp1nump), min(t.pp1nump)
        into lc_pp1nump_mx, lc_pp1nump_mn
        from fsd602 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
         --and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         --and t.ppsbop = pn_sbo
         --and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.d602fc >= lc_fini
         and t.d602fc <= pn_fecha
         and t.d602co = 'S'
            
         and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
             (select j.tp1nro1, j.tp1nro2
                from fst198 j
               where j.TP1COD = 1
                 and j.TP1COD1 = 11144
                 and j.TP1CORR1 = 1
                 and j.tp1corr2 = 2
                 and j.tp1corr3 > 0)
         and (t.d602mo, t.d602tr) not in
             ( --- Transacciones de incremento línea
              select h.tp1nro1, h.tp1nro2
                from fst198 h
               where h.TP1COD = 1
                 and h.TP1COD1 = 11144
                 and h.TP1CORR1 = 1
                 and h.tp1corr2 = 8
                 and h.tp1corr3 > 0);
    exception
      when others then
        lc_pp1nump_mx := null;
        lc_pp1nump_mn := null;
    end;
  
    if lc_pp1nump_mx is not null then
    
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
        
          from fsd602 t
         where t.pgcod = pn_cod
           --and t.ppmod = pn_mod
           --and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           --and t.ppsbop = pn_sbo
           --and t.pptope = pn_top
              --and t.ppfpag <= lc_ppfpag
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
              
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      
      exception
        when others then
          pn_cuo := 0;
          pn_int := 0;
      end;
      --calculo de acuerdo al calculo realizado en saldo insoluto
      begin
          select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
          
           from fsd602 t
       where t.pgcod = pn_cod
         --and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc
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
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
      exception
        when others then
          pn_cuo := 0;
          pn_int := 0;
      end;
      
          begin
            select nvl(x.HCIMP1, 0) --,  x.* 
              into lx_mext
              from fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = pn_mod
               --and x.HSUCUR = pn_suc
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = pn_sbo
               --and x.HTOPER = pn_top
               and --- HRUBRO: 1411, 1421, 1414, 1424, 1415,1425,1416, 1426
                   substr(x.HRUBRO, 1, 4) in
                   (1411, 1421, 1414, 1424, 1415, 1425, 1416, 1426)
               and x.HFCON > pn_fecha
               and x.hfval >= lc_fini
               and x.HFVAL <= pn_fecha
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
              lx_mext := 0;
          end;
        
        --pagos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon
          from   fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = 103
               --and x.HSUCUR = 20
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap               
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = 3
               --and x.HTOPER = 109
               --and x.HFCON > '01/01/2022'
               and x.hfval >= lc_fini
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN, x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 1 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon := 0;
        end;
        
        --extornos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon_ext
          from   fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = 103
               --and x.HSUCUR = 20
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap               
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = 3
               --and x.HTOPER = 109
               --and x.HFCON > '01/01/2022'
               and x.hfval >= lc_fini
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN, x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 2 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon_ext := 0;
        end;
      pn_cuo := pn_cuo + nvl(lx_mext,0) + nvl(lx_shon,0) - nvl(lx_shon_ext,0);
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into pn_mor, pn_icv, pn_gas
          from fsd612 x, fsd602 t
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
           --and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           --and x.pptope = pn_top
           and x.pp1nump >= lc_pp1nump_mn
           and x.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
              
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      exception
        when others then
          pn_mor := 0;
          pn_icv := 0;
          pn_gas := 0;
      end;
    
      --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into pn_pen
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
           --and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
          -- and x.pptope = pn_top
           and x.pp003nump >= lc_pp1nump_mn
           and x.pp003nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
              
           and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
           and (t.d602mo, t.d602tr) not in
               ( --- Transacciones de incremento línea
                select h.tp1nro1, h.tp1nro2
                  from fst198 h
                 where h.TP1COD = 1
                   and h.TP1COD1 = 11144
                   and h.TP1CORR1 = 1
                   and h.tp1corr2 = 8
                   and h.tp1corr3 > 0);
      exception
        when others then
          pn_pen := 0;
      end;
    
    else
      pn_gas := 0;
      pn_mor := 0;
      pn_int := 0;
      pn_cuo := 0;
      pn_icv := 0;
      pn_pen := 0;
    end if;
  
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago_mes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_fecha_upago_mes(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_fecha in date) return date is
  
    lx_fpago date;
    lc_fini  date;
  
  begin
  
    lc_fini := trunc(pn_fecha) - (to_number(to_char(pn_fecha, 'DD')) - 1);
  
    begin
    
      SELECT
      
       max(t.d602fc)
        into lx_fpago
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
         and t.d602fc >= lc_fini
         and t.d602fc <= pn_fecha
            
         and (t.d602mo, t.d602tr) not in -- Transacciones de reprogramaciones
             (select j.tp1nro1, j.tp1nro2
                from fst198 j
               where j.TP1COD = 1
                 and j.TP1COD1 = 11144
                 and j.TP1CORR1 = 1
                 and j.tp1corr2 = 2
                 and j.tp1corr3 > 0)
         and (t.d602mo, t.d602tr) not in
             ( --- Transacciones de incremento línea
              select h.tp1nro1, h.tp1nro2
                from fst198 h
               where h.TP1COD = 1
                 and h.TP1COD1 = 11144
                 and h.TP1CORR1 = 1
                 and h.tp1corr2 = 8
                 and h.tp1corr3 > 0);
    exception
      when others then
        lx_fpago := null;
    end;
  
    return lx_fpago;
  
  end fn_fecha_upago_mes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_monto_disposicion(pn_cod     in number,
                                 pn_mod     in number,
                                 pn_suc     in number,
                                 pn_mda     in number,
                                 pn_pap     in number,
                                 pn_cta     in number,
                                 pn_ope     in number,
                                 pn_sbo     in number,
                                 pn_top     in number,
                                 pn_fini    in date,
                                 pn_ffin    in date,
                                 pn_mont    out number,
                                 pn_fec_dis out date) is
  
    lx_fecha   date;
    lx_fec_his date;
    lx_fec_dia date;
    lx_imp_his number(17, 2);
    lx_imp_dia number(17, 2);
  
  begin
  
    -- clave
    select x.pgfape into lx_fecha from fst017 x where x.pgcod = 1;
  
    begin
    
      select sum(x.hcimp1), max(x.hfcon) --, x.hfcon
        into lx_imp_his, lx_fec_his --, lx_fec_his
        from fsh016 x, fsh015 t
       where x.pgcod = pn_cod
         and x.hmodul = pn_mod
         --and x.hsucur = pn_suc
         and x.hmda = pn_mda
         and x.hpap = pn_pap
         and x.hcta = pn_cta
         and x.hoper = pn_ope
         and x.hsubop = pn_sbo
         and x.htoper = pn_top
         and
            
             x.pgcod = t.pgcod
         and x.hcmod = t.hcmod
         and x.hsucor = t.hsucor
         and x.htran = t.htran
         and x.hnrel = t.hnrel
         and x.hfcon = t.hfcon
         and x.hfcon >= pn_fini
         and x.hfcon <= pn_ffin
         and t.hccorr <> 99
         and
            
             x.hcmod = 116
         and x.htran in (50, 60)
         and x.hcord = 10;
    
    exception
      when others then
        lx_imp_his := 0;
        lx_fec_his := null;
    end;
  
    lx_imp_dia := 0;
  
    if pn_fini = lx_fecha or pn_ffin = lx_fecha then
    
      begin
      
        select sum(x.itimp1)
          into lx_imp_dia
          from fsd016 x, fsd015 t
         where x.pgcod = pn_cod
           and x.modulo = pn_mod
           --and x.itsucd = pn_suc
           and x.moneda = pn_mda
           and x.papel = pn_pap
           and x.ctnro = pn_cta
           and x.itoper = pn_ope
           and x.itsubo = pn_sbo
           and x.ittope = pn_top
           and
              
               x.pgcod = t.pgcod
           and x.itsuc = t.itsuc
           and x.itmod = t.itmod
           and x.ittran = t.ittran
           and x.itnrel = t.itnrel
           and t.itcorr <> 99
           and
              
               x.itmod = 116
           and x.ittran in (50, 60)
           and x.itord = 10;
      
      exception
        when others then
          lx_imp_dia := 0;
      end;
    
    end if;
  
    if lx_imp_dia <> 0 then
      lx_fec_his := pn_ffin;
    end if;
  
    pn_fec_dis := lx_fec_his;
    pn_mont    := lx_imp_his + lx_imp_dia;
  
  end sp_monto_disposicion;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  function fn_equivalenciadoc(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
  
    resp  number(5);
    respc varchar2(1);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end FN_EQUIVALENCIADOC;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  -- Número de cuotas del cronograma actual
  function fn_fecha_ncuoa(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number is
  
    lx_sbop  number;
    lx_cuo_n number;
    lc_flag  number(3);
  
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
    
      if lc_flag = 0 then
      
        select count(*)
          into lx_cuo_n
          from FSD601 t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = lx_sbop
              --and t.pptope = m.aotope
           and t.d601Co = 'S';
      
        -----
      else
        select count(*)
          into lx_cuo_n
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
        lx_cuo_n := 0;
    end;
  
    return lx_cuo_n;
  
  end fn_fecha_ncuoa;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_monto_disposicion2(pn_cod     in number,
                                  pn_mod     in number,
                                  pn_suc     in number,
                                  pn_mda     in number,
                                  pn_pap     in number,
                                  pn_cta     in number,
                                  pn_ope     in number,
                                  pn_sbo     in number,
                                  pn_top     in number,
                                  pn_ffin    in date,
                                  pn_mont    out number,
                                  pn_fec_dis out date) is
  
    lx_fecha   date;
    lx_fec_his date;
    lx_fec_dia date;
    lx_imp_his number(17, 2);
    lx_imp_dia number(17, 2);
  
  begin
  
    -- clave
    select x.pgfape into lx_fecha from fst017 x where x.pgcod = 1;
  
    begin
    
      select sum(x.hcimp1), min(x.hfcon) --, x.hfcon
        into lx_imp_his, lx_fec_his --, lx_fec_his
        from fsh016 x, fsh015 t
       where x.pgcod = pn_cod
         --and x.hmodul = pn_mod
         --and x.hsucur = pn_suc
         and x.hmda = pn_mda
         and x.hpap = pn_pap
         and x.hcta = pn_cta
         and x.hoper = pn_ope
         --and x.hsubop = pn_sbo
         --and x.htoper = pn_top
         and
            
             x.pgcod = t.pgcod
         and x.hcmod = t.hcmod
         and x.hsucor = t.hsucor
         and x.htran = t.htran
         and x.hnrel = t.hnrel
         and x.hfcon = t.hfcon
            --and x.hfcon >= pn_fini
         and x.hfcon <= pn_ffin
         and t.hccorr <> 99
         and
            
             x.hcmod = 116
         and x.htran in (50, 60)
         and x.hcord = 10;
    
    exception
      when others then
        lx_imp_his := 0;
        lx_fec_his := null;
    end;
  
    lx_imp_dia := 0;
  
    if pn_ffin = lx_fecha then
    
      begin
      
        select sum(x.itimp1)
          into lx_imp_dia
          from fsd016 x, fsd015 t
         where x.pgcod = pn_cod
           and x.modulo = pn_mod
           --and x.itsucd = pn_suc
           and x.moneda = pn_mda
           and x.papel = pn_pap
           and x.ctnro = pn_cta
           and x.itoper = pn_ope
           --and x.itsubo = pn_sbo
           --and x.ittope = pn_top
           and
              
               x.pgcod = t.pgcod
           and x.itsuc = t.itsuc
           and x.itmod = t.itmod
           and x.ittran = t.ittran
           and x.itnrel = t.itnrel
           and t.itcorr <> 99
           and
              
               x.itmod = 116
           and x.ittran in (50, 60)
           and x.itord = 10;
      
      exception
        when others then
          lx_imp_dia := 0;
      end;
    
    end if;
  
    if lx_imp_dia <> 0 then
      lx_fec_his := pn_ffin;
    end if;
  
    pn_fec_dis := lx_fec_his;
    pn_mont    := lx_imp_his + lx_imp_dia;
  
  end sp_monto_disposicion2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig_117(pn_cod     in number,
                                    pn_mod     in number,
                                    pn_suc     in number,
                                    pn_mda     in number,
                                    pn_pap     in number,
                                    pn_cta     in number,
                                    pn_ope     in number,
                                    pn_sbo     in number,
                                    pn_top     in number,
                                    pn_fecha   in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out char --AQPB379.AQPB379NCRE%type
                                    ) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
    lx_nconc     char(50);
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fondofaeagro.fn_fecha_upago(pn_cod   => pn_cod,
                                                            pn_mod   => pn_mod,
                                                            pn_suc   => pn_suc,
                                                            pn_mda   => pn_mda,
                                                            pn_pap   => pn_pap,
                                                            pn_cta   => pn_cta,
                                                            pn_ope   => pn_ope,
                                                            pn_sbo   => pn_sbo,
                                                            pn_top   => pn_top,
                                                            pn_fecha => pn_fecha);
    exception
      when others then
        pn_ufech := null;
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if pn_mod = 117 then
         lx_fecha_ant := last_day(add_months(trunc(lx_fecha), -1));
      else
        if pn_ufech is not null then
          lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
        end if;
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if lx_fecha <> pn_fecha then
        begin
          -- 1ro. Buscar con la fecha de corte 116
          select g.tipo, g.nconcepto
            into pn_ntipo, lx_nconc
          
            from (select /*+index(t FSH01204)*/distinct t.bcgpo tipo,
                                  case
                                    when t.bcgpo = 2 then
                                     'MICROEMPRESAS'
                                    when t.bcgpo = 3 and
                                         substr(t.bcrubr, 11, 3) =
                                         '015' then
                                     'CONSUMO REVOLVENTE'
                                    when t.bcgpo = 3 and
                                         substr(t.bcrubr, 11, 3) <>
                                         '015' then
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
                  
                    from fsh012 t --- fsd011
                   where t.bcemp = pn_cod
                     and t.bcmod = 116
                     and t.bcsuc = pn_suc  
                     and t.bcmda = pn_mda
                     and t.bcpap = pn_pap
                     and t.bccta = pn_cta
                     and t.bcoper = pn_ope
                        
                     and t.bctop = pn_top
                     and t.bcfech = pn_fecha
                     and t.bcsdmn <> 0
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
        begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, lx_nconc
          
            from (select distinct t.aqpb070agpo tipo,
                                  case
                                    when t.aqpb070agpo = 2 then
                                     'MICROEMPRESAS'
                                    when t.aqpb070agpo = 3 and
                                         substr(t.aqpb070arubr, 11, 3) =
                                         '015' then
                                     'CONSUMO REVOLVENTE'
                                    when t.aqpb070agpo = 3 and
                                         substr(t.aqpb070arubr, 11, 3) <>
                                         '015' then
                                     'CONSUMO NO REVOLVENTE'
                                    when t.aqpb070agpo = 4 then
                                     'HIPOTECARIO'
                                    when t.aqpb070agpo = 12 then
                                     'MEDIANA EMPRESA'
                                    when t.aqpb070agpo = 13 then
                                     'PEQUEÑA EMPRESA'
                                    when t.aqpb070agpo = 11 then
                                     'GRANDES EMPRESAS'
                                    when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                                     'CORPORATIVO'
                                    else
                                     ' '
                                  END nconcepto
                  
                    from aqpb070a t --- fsd011
                   where t.aqpb070ausur = pn_usuario
                     and t.aqpb070aemp = pn_cod
                     and t.aqpb070amod = pn_mod
                        --and t.aqpb070asuc = pn_suc
                     and t.aqpb070amda = pn_mda
                     and t.aqpb070apap = pn_pap
                     and t.aqpb070acta = pn_cta
                     and t.aqpb070aoper = pn_ope
                        --and t.bcsbop = pn_sbo
                     and t.aqpb070atop = pn_top
                     and t.aqpb070afech = pn_fecha
                     and t.aqpb070asdmn <> 0
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select to_number(substr(g.harub, 5, 2)) scgru,
                     case
                       when substr(g.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(g.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(g.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(g.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(g.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into pn_ntipo, lx_nconc
                from
                (select * 
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
                 and f.HAANIO = lx_anio
                 order by f.hasd12,
                 f.hasd11,
                 f.hasd10
                 ,f.hasd09,
                 f.hasd08,
                 f.hasd07,
                 f.hasd06,
                 f.hasd05,
                 f.hasd04,
                 f.hasd03,
                 f.hasd02,
                 f.hasd01) g
                 where rownum <=1;
            
            exception
              when others then
              
                pn_ntipo := 0;
                lx_nconc := null;
              
            end;
          
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
            into pn_ntipo, lx_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = 116 --solo para 117
                --and t.scsuc = pn_suc
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             --and t.scoper = pn_ope
                --and t.scsbop = pn_sbo
             --and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
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
            into pn_ntipo, lx_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
                --and t.scsuc = pn_suc
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
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select to_number(substr(g.harub, 5, 2)) scgru,
                     case
                       when substr(g.harub, 5, 2) = 2 then
                        'MICROEMPRESAS'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) = '015' then
                        'CONSUMO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 3 and
                            substr(g.harub, 11, 3) <> '015' then
                        'CONSUMO NO REVOLVENTE'
                       when substr(g.harub, 5, 2) = 4 then
                        'HIPOTECARIO'
                       when substr(g.harub, 5, 2) = 12 then
                        'MEDIANA EMPRESA'
                       when substr(g.harub, 5, 2) = 13 then
                        'PEQUEÑA EMPRESA'
                       when substr(g.harub, 5, 2) = 11 then
                        'GRANDES EMPRESAS'
                       when substr(g.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
                        'CORPORATIVO'
                       else
                        ' '
                     END
                into pn_ntipo, lx_nconc
                from(
                select * from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio
                 order by f.hasd12,
                 f.hasd11,
                 f.hasd10
                 ,f.hasd09,
                 f.hasd08,
                 f.hasd07,
                 f.hasd06,
                 f.hasd05,
                 f.hasd04,
                 f.hasd03,
                 f.hasd02,
                 f.hasd01) g
                 where rownum<=1;
            
            exception
              when others then
              
                pn_ntipo := 0;
                lx_nconc := null;
              
            end;
          
        end;
        end;
      end if;
    
      pn_nconc := trim(lx_nconc) ;
    exception
      when others then
        pn_ntipo := 0;
        lx_nconc := null;
        pn_nconc := lx_nconc;
      
    end;
  
  end sp_tipo_credito_sbs_vig_117;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  
end pq_cr_reporte_fondofaeagro;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/

