create or replace package pq_cr_reporte_fondos_p3 is
  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondos_p3
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 28/06/2021
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Retiro de sucursal  
  -- Fecha de Modificación        : 14/11/2023
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Optimizacion de procedimientos
  --                              : 2024.08.14 dcastro se modificó fn_ciiu_codigo4, sp_ciiu_codigo4
  --                                2024.08.21 dcastro se modificó sp_ciiu_codigo4
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Equivalencia del tipo de documento para obtener el cod. SBS
  function fn_equivalenciadoc(p_tdoc number) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nombre o razon social según tipo de documento
  function fn_obtener_nombre(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nombre de persona jurídica
  function fn_obtener_perjur(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nombre de persona natural
  function fn_obtener_pernat(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener saldo insoluto
  function fn_obtener_saldoi(pn_cod     in number,
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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener período de gracia
  function fn_obtener_pgracia(pn_cod in number,
                              pn_mod in number,
                              pn_suc in number,
                              pn_mda in number,
                              pn_pap in number,
                              pn_cta in number,
                              pn_ope in number,
                              pn_sbo in number,
                              pn_top in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener cod. SBS y clasificación SBS: NORMAL, CPP, DEFICIENTE, DUDOSO, PERDIDA
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,
                            
                            pn_calif0 out aqpb065.aqpb065cnom%type,
                            pn_calif1 out aqpb065.aqpb065ccpp%type,
                            pn_calif2 out aqpb065.aqpb065cdef%type,
                            pn_calif3 out aqpb065.aqpb065cdud%type,
                            pn_calif4 out aqpb065.aqpb065cper%type,
                            pn_csbs   out aqpb065.aqpb065csbs%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener descripción del estado del crédito
  function fn_estado_desc(pd_stat in number) return aqpb065.aqpb065ecre%type;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Verificación de AMORTIZACIÓN
  function fn_flag_amrtzn(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return aqpb065.aqpb065lamr%type;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Verificación de AMORTIZACIÓN
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
                           pn_flarm out aqpb065.aqpb065lamr%type,
                           pn_fecrm out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Fecha del último pago
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
  -- Fecha del último pago

  function fn_fecha_upago_tot_parc(pn_cod   in number,
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
  -- Obtener datos de Región, Zona y Sucursal
  procedure sp_obtener_sucs(pn_sucs in number,
                            pn_regi out number,
                            pn_zona out number,
                            pn_nsuc out aqpb065.aqpb065nsuc%type,
                            pn_nzon out aqpb065.aqpb065nzon%type,
                            pn_nreg out aqpb065.aqpb065nreg%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener la DISTRIBUCIÓN DE CLASIFICACIÓN DE RIESGO
  function fn_obtener_scond(pn_dcon in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_scond_c(pn_dcon in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_scond_c(pn_cod in number,
                               pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               
                               pn_dcon  in char,
                               pn_est   in number,
                               pn_ufech in date,
                               
                               pn_rubr out char,
                               pn_resp out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuop(pn_cod    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_fec    in date,
                           pn_ncuopp out number,
                           pn_ncuopa out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener CIUU y descripción
  /*
  procedure sp_obtener_ciuu(pn_pais in SNGC60.sngc60pais%type,
                            pn_tdoc in SNGC60.sngc60tdoc%type,
                            pn_ndoc in SNGC60.sngc60ndoc%type,
                            pn_dciu out aqpb065.aqpb065actn%type,
                            pn_cciu out aqpb065.aqpb065ciuu%type);
  */
  procedure sp_obtener_ciuu(pn_cciu in number,
                            pn_dciu out aqpb065.aqpb065actn%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener saldo capital
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
  -- Obtener nro cuotas inicial
  function fn_fecha_ncuoi(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nro cuotas inicial repro
  function fn_fecha_ncuoir(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pc_rep in char,
                          pd_fre in date) return number;
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
  -- Obtener pago total o amortizado
  procedure sp_obtener_pagoi(pn_cod    in number,
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
                             pn_impl   out number,
                             pn_fech   out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Valor de la última cuota pagada
  function fn_obtener_vucuop(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_fecha in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Valor de la próxima cuota a vencerse
  procedure sp_obtener_vpcuov(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_fecha in date,
                              pn_fpag  out date,
                              pn_fvto  out date,
                              pn_sumt  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener dirección legal y ubigeo
  procedure sp_obtener_direcc(pn_pais in SNGC13.sngc13pais%type,
                              pn_tdoc in SNGC13.sngc13tdoc%type,
                              pn_ndoc in SNGC13.sngc13ndoc%type,
                              pn_dirr out SNGC13.sngc13dir%type,
                              pn_ugeo out SNGC13.sngc13ugeo%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener tipo destino del crédito
  function fn_obtener_tdesti(pn_mod in number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener Fecha de vencimiento de última cuota impaga
  procedure sp_obtener_impaga(pn_cod    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_fecha  in date,
                              pn_fvenuc out date);
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
                                    pn_fpagu out date,
                                    pn_fvenu out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --  Distribución de pago realizado
  procedure sp_distribuc_pago(pn_cod   in number,
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
  -- Cálculo del monto prepago
  procedure sp_obtener_mprepago(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_monto out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato_jaqa400(pn_cod   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_fecha in date,
                                  pn_flag  out char,
                                  pn_nrep  out number,
                                  pn_fech  out date,
                                  pn_tabla out varchar2,
                                  pn_peri  out number,
                                  pn_ncuo  out number,
                                  pn_fpri  out date,
                                  pn_fult  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato1(pn_cod   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_fecha in date,
                           pn_flag  out char,
                           pn_nrep  out number,
                           pn_fech  out date,
                           pn_tabla out varchar2,
                           pn_peri  out number,
                           pn_ncuo  out number,
                           pn_fpri  out date,
                           pn_fult  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato2(pn_cod   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_frep  in date,
                           pn_tabla in varchar2,
                           pn_peri  out number,
                           pn_ncuo  out number,
                           pn_fpri  out date,
                           pn_fult  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener la clave del crédito
  PROCEDURE SP_CR_DATOSCRE(pn_cta in number,
                           pn_ope in number,
                           pn_emp out number,
                           pn_mod out number,
                           pn_suc out number,
                           pn_mda out number,
                           pn_pap out number,
                           pn_sbo out number,
                           pn_top out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_insertar_detalle_grupo1(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_insertar_detalle_grupo2(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_insertar_detalle_grupo3(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_repro_jaqz698_g1(pn_frep   in date,
                                pn_corr   in number,
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                
                                pn_peri out number,
                                pn_ncuo out number,
                                pn_fpri out date,
                                pn_fult out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_repro_jaqz698_g2(pn_frep   in date,
                                pn_corr   in number,
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                
                                pn_peri out number,
                                pn_ncuo out number,
                                pn_fpri out date,
                                pn_fult out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_extorno(pn_cod   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_fecha in date,
                             
                             pn_flag out char,
                             pn_fech out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_atraso_u(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                
                                pn_diat out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_obtener_nventas(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pn_fecha in date,
                               
                               pn_ventas   out number,
                               pn_inst_eva out number,
                               pn_inst_sol out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ciiu_codigo4(P_PAIS   in number,
                           P_PETDOC in number,
                           P_PENDOC in char) return varchar2;
  procedure sp_ciiu_codigo4(P_PAIS   in number,
                            P_PETDOC in number,
                            P_PENDOC in char,
                            p_ciuu4  out number,
                            p_ciuu6  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*
  procedure sp_insertar_pauxiliares(pn_pgcod   in number,
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
  */
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2);
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
  -- Anulación Individual
  procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_iniciales(pn_cod     in number,
                                 pn_mod     in number,
                                 pn_suc     in number,
                                 pn_mda     in number,
                                 pn_pap     in number,
                                 pn_cta     in number,
                                 pn_ope     in number,
                                 pn_sbo     in number,
                                 pn_top     in number,
                                 pn_fde_ini out date,
                                 pn_mon_ini out number,
                                 pn_cuo_ini out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldo_cap_cancel(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_saldo out number,
                                pn_upago out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --  Distribución de pago realizado: acumulado
  procedure sp_distribuc_pago_tot(pn_cod   in number,
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
                                  pn_pen   out number -- penalidad
                                  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuo_pagtotal(pn_cod      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_fecha    in date,
                                   pn_ncuo_pag out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener saldo actual
  function fn_obtener_saldo_actual(pn_cod     in number,
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
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out AQPB067.AQPB067NCRE%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_700(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    pc_pcre out number,
                                    pc_ncre out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_actual(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tasa  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_registro_FSH012(pn_fecha in date,
                               pn_tabla in char,
                               pn_tipo  in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldo_cap_cancel_fae(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_saldo out number,
                                    pn_upago out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_obtener_sald_insoluto(pn_cod   in number,
                                     pn_mod   in number,
                                     pn_suc   in number,
                                     pn_mda   in number,
                                     pn_pap   in number,
                                     pn_cta   in number,
                                     pn_ope   in number,
                                     pn_sbo   in number,
                                     pn_top   in number,
                                     pn_fecha in date,
                                     pn_sald  out number);

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
                                 --pn_dcla out aqpb067.aqpb067dcla%type,
                                 --pn_ncla out aqpb067.aqpb067ncla%type
                                 pn_calif0a out aqpb067.aqpb067cnoma%type,
                                 pn_calif1a out aqpb067.aqpb067ccppa%type,
                                 pn_calif2a out aqpb067.aqpb067cdefa%type,
                                 pn_calif3a out aqpb067.aqpb067cduda%type,
                                 pn_calif4a out aqpb067.aqpb067cpera%type,
                                 pn_deccaj  out date);
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
  -----------------------------------------------------------------------------------------------
   procedure sp_distribuc_pago_mes_pa(pn_cod   in number,
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
                                  pn_pen   out number,
                                  pn_pamr  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                   
  procedure sp_obtener_pagoi_crec(pn_cod    in number,
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
                                  
                                  pn_impl out number,
                                  pn_fech out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_mprepago_fae(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_tsum  out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_saldo_011012(pn_cod     in number,
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
  procedure sp_obtener_datoshonrado(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pn_rubr   in number,
                                    pd_fecha  in date,
                                    pc_eshonr out char,
                                    pn_mhonr  out number,
                                    pd_fhonr  out date,
                                    pn_sdohon out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_fcamb_estado(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pd_fecha in date,
                                    pd_fcest out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_drefinanciac(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pd_fecha  in date,
                                    pc_lrefin out char,
                                    pd_frefin out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuop_2(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fec     in date,
                             pd_fvenup  in date,
                             pn_ncuopp  out number,
                             pn_ncuopa  out number,
                             pn_ncuoimp out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_moractual(pn_cod   in number,
                                      pn_mod   in number,
                                      pn_suc   in number,
                                      pn_mda   in number,
                                      pn_pap   in number,
                                      pn_cta   in number,
                                      pn_ope   in number,
                                      pn_sbo   in number,
                                      pn_top   in number,
                                      pn_fecha in date,
                                      pn_tasa  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_REPRO(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fecha in date,
                                  pn_tasa  out number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_montos_venc(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_int   out number,
                                   pn_mor   out number,
                                   pn_icv   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_montos_rmora(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_int   out number,
                                   pn_mor   out number,
                                   pn_icv   out number,
                                   pn_pen   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_interes_acum(pn_cod   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_fecha in date,
                                    pn_intac out number);
  -----------------------------------------------------------------------------------------------
  function fn_fecha_cre_original(pn_cod in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number) return date;
  -----------------------------------------------------------------------------------------------
  function fn_fecha_cre_original_r(pn_cod in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pc_rep in char,
                                 pd_fre in date) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_valorcuotas(pn_cod    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pn_fecha  in date,
                                   pn_vulcpa out number,
                                   pn_vcprve out number,
                                   pn_fuclpa out date);
  -----------------------------------------------------------------------------------------------
end pq_cr_reporte_fondos_p3;
/

create or replace package body pq_cr_reporte_fondos_p3 is
  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondos_p3
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 28/06/2021
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Retiro de sucursal  
  -- *****************************************************************
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

  function fn_obtener_perjur(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char is
  
    lc_razon char(70);
    respc    char(70);
  
  begin
  
    begin
      if p_tdoc = 9 then
        -- -- -- -- -- -- -- -- -- --
        select trim(y.pjrazs)
          into lc_razon
          from fsd003 y
         where y.pjpais = p_pais
           and y.pjtdoc = p_tdoc
           and y.pjndoc = p_ndoc;
        -- -- -- -- -- -- -- -- -- --
      else
        lc_razon := '';
      end if;
    exception
      when others then
        lc_razon := '';
    end;
  
    respc := lc_razon;
    return respc;
  
  end fn_obtener_perjur;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_obtener_pernat(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char is
  
    lc_razon char(70);
    respc    char(70);
  
  begin
  
    begin
      if p_tdoc = 21 then
        -- -- -- -- -- -- -- -- -- --
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
        -- -- -- -- -- -- -- -- -- --
      else
        -- -- -- -- -- -- -- -- -- --
        lc_razon := '';
        -- -- -- -- -- -- -- -- -- --
      end if;
    exception
      when others then
        lc_razon := '';
    end;
  
    respc := lc_razon;
    return respc;
  
  end fn_obtener_pernat;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_saldoi(pn_cod     in number,
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
  
    lx_imp   number(17, 2);
    lx_cd    number(3);
    lx_mo    number(3);
    lx_su    number(3);
    lx_tr    number(3);
    lx_re    number(4);
    lx_fc    date;
    lx_imp1  number(17, 2);
    lx_sdoi  number(17, 2);
    lx_saldo number(17, 2);
    lx_fecha date;
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
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
            --and t.aomod <> 419
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
    exception
      when others then
        lx_imp := 0;
    end;
  
    -- 2. Obtención de la transacción
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
                    --and t.aosuc = pn_suc jrodriguej 28.06.2021
                 and t.aomda = pn_mda
                 and t.aopap = pn_pap
                 and t.aocta = pn_cta
                 and t.aooper = pn_ope
                    --and t.aosbop = pn_sbo
                 and t.aotope = pn_top
                 and t.evtipo = 50
                 and t.d012co = 'S'
                 and t.d012fc <= pn_fecha
               order by t.d012fc desc) f
       where rownum = 1;
    
      --if lx_fecha <> pn_fecha then
      if lx_fc <> pn_fecha then
      
        select t.hcimp1
          into lx_imp1
          from fsh016 t
         where t.pgcod = lx_cd
           and t.hcmod = lx_mo
           and t.hsucor = lx_su
           and t.htran = lx_tr
           and t.hnrel = lx_re
           and t.hfcon = lx_fc
           and t.hcord = 10;
      
      else
      
        select t.itimp1
          into lx_imp1
          from fsd016 t
         where t.pgcod = lx_cd
           and t.itmod = lx_mo
           and t.itsuc = lx_su
           and t.ittran = lx_tr
           and t.itnrel = lx_re
              --and t.itfval = lx_fc
           and t.itord = 10;
      
      end if;
    
    exception
      when others then
        lx_imp1 := 0;
    end;
  
    if lx_imp1 <> 0 then
      lx_sdoi := lx_imp - lx_imp1; ---FSD010(AOIMP) - FSD016(ITMP1) ORD 10
    else
    
      if lx_fecha <> pn_fecha then
      
        begin
          --select (t.aqpb070asdmn * -1) --(t.bcsdmn * -1)
          select (sum(t.aqpb070asdmn)) * -1 --(t.bcsdmn * -1)
            into lx_saldo
            from aqpb070a t
           where t.aqpb070ausur = pn_usuario
             and t.aqpb070aemp = pn_cod
             and t.aqpb070amod = pn_mod
                --and t.aqpb070asuc = pn_suc  jrodriguej 28.06.2021
             and t.aqpb070amda = pn_mda
             and t.aqpb070apap = pn_pap
             and t.aqpb070acta = pn_cta
             and t.aqpb070aoper = pn_ope
                --and t.bcsbop = pn_sbo
                --and t.aqpb070atop = pn_top   dcastro 24.09.2021
             and t.aqpb070afech = pn_fecha;
        exception
          when others then
            --lx_saldo := 0;
            lx_saldo := lx_imp;
        end;
      
      else
        begin
          --select (t.scsdo * -1)
          select (sum(t.scsdo)) * -1
            into lx_saldo
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
                --and t.scsuc = pn_suc  jrodriguej 28.06.2021
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
                --and t.scsbop = pn_sbo
             and t.sctope = pn_top;
        exception
          when others then
            --lx_saldo := 0;
            lx_saldo := lx_imp;
        end;
      
      end if;
    
      lx_sdoi := lx_saldo;
    
    end if;
  
    if lx_sdoi < 0 then
      lx_sdoi := 0;
    end if;
  
    return lx_sdoi;
  
  end fn_obtener_saldoi;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_obtener_pgracia(pn_cod in number,
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
  
  end fn_obtener_pgracia;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,
                            
                            pn_calif0 out aqpb065.aqpb065cnom%type,
                            pn_calif1 out aqpb065.aqpb065ccpp%type,
                            pn_calif2 out aqpb065.aqpb065cdef%type,
                            pn_calif3 out aqpb065.aqpb065cdud%type,
                            pn_calif4 out aqpb065.aqpb065cper%type,
                            pn_csbs   out aqpb065.aqpb065csbs%type) is
  
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
  
    /*
    if pn_fech > lc_fecha_rcc then
    
      lc_fecha_pro := lc_fecha_rcc;
    else
      lc_fecha_pro := last_day(add_months(trunc(lc_fecha_rcc), -1));
    end if;
    */
    -- 8. Código de cliente SBS (dato del BT)
  
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
               pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
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
                   pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
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
          --when no_data_found then
        --  ln_item := 0;
        --when others then
        --  null;
        --end;
      
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
               pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
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
                   pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
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
          --when no_data_found then
        --  ln_item := 0;
        --when others then
        --  null;
        --end;
      
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

  function fn_estado_desc(pd_stat in number) return aqpb065.aqpb065ecre%type is
  
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
  function fn_flag_amrtzn(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return aqpb065.aqpb065lamr%type is
  
    lx_cont number;
    lx_resp char(2);
  begin
  
    SELECT count(*)
      into lx_cont
      FROM fsd012 t
     where t.pgcod = pn_cod
       and t.aomod = pn_mod
          --and t.aosuc = pn_suc jrodriguej 28.06.2021
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
      lx_resp := 'SI';
    else
      lx_resp := 'NO';
    end if;
  
    return lx_resp;
  
  end fn_flag_amrtzn;
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
                           pn_flarm out aqpb065.aqpb065lamr%type,
                           pn_fecrm out date) is
  
    lx_cont number;
  
  begin
  
    begin
    
      SELECT count(*)
        into lx_cont
        FROM fsd012 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
            --and t.aosuc = pn_suc jrodriguej 28.06.2021
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
              --and t.aosuc = pn_suc jrodriguej 28.06.2021
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
        lx_fpago := null;
    end;
  
    return lx_fpago;
  
  end fn_fecha_upago;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_fecha_upago_tot_parc(pn_cod   in number,
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
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('T', 'P')
         and t.d602co = 'S'
         and t.d602fc <= pn_fecha;
    exception
      when others then
        lx_fpago := null;
    end;
  
    return lx_fpago;
  
  end fn_fecha_upago_tot_parc;

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
  function fn_obtener_scond(pn_dcon in char) return char is
  
    --lx_ope1 number(3);
    --lx_ope2 number(5);
    lx_resp char(20);
  
  begin
    --Fórmula:X054032(XLLAOCNTP) * X054023(xllperiodo)
  
    begin
      case
        when substr(pn_dcon, 1, 4) = '1411' then
          lx_resp := 'NORMAL';
        when substr(pn_dcon, 1, 4) = '1414' then
          lx_resp := 'REFINANCIADO';
        when substr(pn_dcon, 1, 4) = '1415' then
          lx_resp := 'VENCIDO';
        when substr(pn_dcon, 1, 4) = '1416' then
          lx_resp := 'JUDICIAL';
        when substr(pn_dcon, 1, 2) = '81' then
          lx_resp := 'CASTIGADO';
        else
          lx_resp := '';
      end case;
    
    exception
      when others then
      
        lx_resp := '';
      
    end;
  
    return lx_resp;
  
  end fn_obtener_scond;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_scond_c(pn_dcon in char) return char is
  
    lx_resp char(20);
  
  begin
  
    begin
      case
        when substr(pn_dcon, 1, 4) = '1411' then
          -- NORMAL
          lx_resp := 'VGT';
        when substr(pn_dcon, 1, 4) = '1421' then
          -- NORMAL
          lx_resp := 'VGT';
        when substr(pn_dcon, 1, 4) = '1414' then
          -- REFINANCIADO
          lx_resp := 'RFN';
        when substr(pn_dcon, 1, 4) = '1424' then
          -- REFINANCIADO
          lx_resp := 'RFN';
        when substr(pn_dcon, 1, 4) = '1415' then
          -- VENCIDO
          lx_resp := 'VCD';
        when substr(pn_dcon, 1, 4) = '1425' then
          -- VENCIDO
          lx_resp := 'VCD';
        when substr(pn_dcon, 1, 4) = '1416' then
          -- JUDICIAL
          lx_resp := 'JDC';
        when substr(pn_dcon, 1, 4) = '1426' then
          -- JUDICIAL
          lx_resp := 'JDC';
        when substr(pn_dcon, 1, 2) = '81' then
          -- CASTIGADO
          lx_resp := 'CTG';
        when substr(pn_dcon, 1, 4) = '1413' then
          -- REESTRUCUTRADO
          lx_resp := 'RTR';
        when substr(pn_dcon, 1, 4) = '1423' then
          -- REESTRUCUTRADO
          lx_resp := 'RTR';
        else
          lx_resp := '';
      end case;
    exception
      when others then
      
        lx_resp := '';
      
    end;
  
    return lx_resp;
  
  end fn_obtener_scond_c;
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
                               pn_dcon  in char,
                               pn_est   in number,
                               pn_ufech in date,
                               
                               pn_rubr out char,
                               pn_resp out char) is
  
    lx_rubro     char(4);
    lx_fecha_ant date;
  
  begin
  
    if pn_est = 99 and pn_dcon is null then
    
      -- jrodriguej 20.01.2021
      /*
      begin
      
        --- Primero buscar en la fecha encontrada
        begin
          select g.rubro
            into lx_rubro
      
            from (select substr(t.bcrubr, 1, 4) rubro
                    from fsh012 t --- fsd011
                   where t.bcemp = pn_cod
                     and t.bcmod = pn_mod
                     and t.bcsuc = pn_suc
                     and t.bcmda = pn_mda
                     and t.bcpap = pn_pap
                     and t.bccta = pn_cta
                     and t.bcoper = pn_ope
                        --- sbop
                     and t.bctop = pn_top
                     and t.bcfech = pn_ufech) g
           where rownum = 1;
      
        exception
          when others then
            --- Si no hay en la fecha encontrada, buscar en la fecha del último mes anterior de la fecha de pago
      
            lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
      
            begin
              select g.rubro
                into lx_rubro
      
                from (select substr(t.bcrubr, 1, 4) rubro
                        from fsh012 t --- fsd011
                       where t.bcemp = pn_cod
                         and t.bcmod = pn_mod
                         and t.bcsuc = pn_suc
                         and t.bcmda = pn_mda
                         and t.bcpap = pn_pap
                         and t.bccta = pn_cta
                         and t.bcoper = pn_ope
                            --- sbop
                         and t.bctop = pn_top
                         and t.bcfech = lx_fecha_ant) g
               where rownum = 1;
            exception
              when others then
                lx_rubro := null;
            end;
      
        end;
      
      exception
        when others then
          lx_rubro := null;
      
      end;
      */ ---jrodriguej 20.01.2021
    
      lx_rubro := '';
      pn_resp  := 'CNC';
    elsif pn_est = 61 then
      ---refinanciado
      -- REFINANCIADO
      pn_resp := 'RFN';
      pn_rubr := lx_rubro;
      return;
    elsif pn_est = 64 then
      ---JUDICIAL
      -- JUDICIAL
      pn_resp := 'JDC';
      pn_rubr := lx_rubro;
      return;
    elsif pn_est = 90 then
      ---CASTIGado
      -- CASTIGADO
      pn_resp := 'CTG';
      pn_rubr := lx_rubro;
      return;
    elsif pn_est = 23 then
      ---VENCIDO
      pn_resp := 'VCD';
      pn_rubr := lx_rubro;
      return;
    else
      begin
        lx_rubro := substr(pn_dcon, 1, 4);
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
          pn_resp := pn_resp;
      end case;
    exception
      when others then
        pn_rubr := '';
        pn_resp := '';
    end;
  
  end sp_obtener_scond_c;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Número de cuotas pendientes de pago
  procedure sp_fecha_ncuop(pn_cod    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_fec    in date,
                           pn_ncuopp out number, -- Cuotas pendientes de pago
                           pn_ncuopa out number) -- Cuotas ya pagadas
   is
  
    --lx_ncuop number;
    --lx_fupag date;
  
  begin
  
    -- Cuotas pendientes de pago
    if pn_fec is null then
    
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopp
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
          pn_ncuopp := 0;
      end;
    else
    
      -- Cuotas pendientes de pago
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopp
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
           and t.ppfpag > pn_fec
           and t.d601co = 'S';
      exception
        when others then
          pn_ncuopp := 0;
      end;
    
      -- Cuotas ya pagadas
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopa
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
           and t.ppfpag <= pn_fec
           and t.d601co = 'S'; -- jrodriguej 28.06.2021
      exception
        when others then
          pn_ncuopa := 0;
      end;
    
    end if;
  
  end sp_fecha_ncuop;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_obtener_ciuu(pn_cciu in number,
                            pn_dciu out aqpb065.aqpb065actn%type) is
  
  begin
  
    -- Nombre de la sucursal
    begin
    
      select nvl(x.actnom1, '') actnom1 --, x.actcod1
        into pn_dciu --, pn_cciu
        from FST750 x
       where x.actcod1 = pn_cciu;
    
    exception
      when others then
        pn_dciu := null;
        --pn_cciu := null;
    end;
  
  end sp_obtener_ciuu;

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
  
    lx_imp   number(17, 2);
    lx_sdo   number(17, 2);
    lx_sdoi  number(17, 2);
    lx_fecha date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
    --Fórmula: FSD010(AOIMP) + FSD011(SCSDO)
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
            --and t.aomod <> 419 --  jrodriguej 28.06.2021
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
    exception
      when others then
        lx_imp := 0;
    end;
  
    -- 2. Obtención de la transacción
    if lx_fecha = pn_fecha then
      begin
      
        --select (t.scsdo * -1)
        select (sum(t.scsdo)) * -1
          into lx_sdo
          from FSD011 t
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
          lx_sdo := 0;
      end;
    else
    
      begin
      
        --select (t.aqpb070asdmn * -1) --(t.bcsdmn * -1)
        select (sum(t.aqpb070asdmn)) * -1 --(t.bcsdmn * -1)
          into lx_sdo
          from aqpb070a t -- FSH012
         where t.aqpb070ausur = pn_usuario
           and t.aqpb070aemp = pn_cod
           and t.aqpb070amod = pn_mod
              --and t.aqpb070asuc = pn_suc --  jrodriguej 28.06.2021
           and t.aqpb070amda = pn_mda
           and t.aqpb070apap = pn_pap
           and t.aqpb070acta = pn_cta
           and t.aqpb070aoper = pn_ope
              --and t.aqpb070asbop = pn_sbo
              --and t.aqpb070atop = pn_top   -- dcastro 24.09.2021
           and t.aqpb070afech = pn_fecha;
        --- 31.03.2021
        /*
        select (t.bcsdmn * -1)
          into lx_sdo
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
        */
      
      exception
        when others then
          lx_sdo := 0;
      end;
    
    end if;
    lx_sdoi := lx_imp - lx_sdo; --- ES RESTA!!!
  
    if lx_sdoi < 0 then
      lx_sdoi := 0;
    end if;
  
    return lx_sdoi;
  
  end fn_obtener_sdocap;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Número de cuotas del cronograma original
  function fn_fecha_ncuoi(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number is
  
    lx_cuo_o number;
  
  begin
  
    begin
    
      select count(*)
        into lx_cuo_o
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
        lx_cuo_o := 0;
    end;
  
    return lx_cuo_o;
  
  end fn_fecha_ncuoi;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Número de cuotas del cronograma original
  function fn_fecha_ncuoir(pn_cod in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pc_rep in char,
                          pd_fre in date) return number is
  
    lx_cuo_o number;
  
  begin
    if(pc_rep = 'SI') then
      begin
      
        select count(*)
          into lx_cuo_o
          from aqpb088_601c t
         where t.pgcod = pn_cod
           and t.ppmod = pn_mod
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = 0
              --and t.pptope = m.aotope
           and t.d601co = 'S'
           and t.fec = pd_fre;
      
      exception
        when others then
          lx_cuo_o := 0;
      end;
    else
      begin
      
        select count(*)
          into lx_cuo_o
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
          lx_cuo_o := 0;
      end;
    end if;
    return lx_cuo_o;
  
  end fn_fecha_ncuoir;
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
  -- Obtener pago total o amortizado
  procedure sp_obtener_pagoi(pn_cod    in number,
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
                             
                             pn_impl out number,
                             pn_fech out date) --return number
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
    
      begin
        select x.d602cd,
               x.d602mo,
               x.d602su,
               x.d602tr,
               x.d602re,
               x.d602fc,
               count(*)
          into lx_cd, lx_mo, lx_su, lx_tr, lx_re, lx_fc, lx_cont
          from fsd602 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.d602mo = 30
           and x.d602tr = 150
           and x.d602fc <= pn_fcorte
           and x.d602co = 'S'
         group by x.d602cd,
                  x.d602mo,
                  x.d602su,
                  x.d602tr,
                  x.d602re,
                  x.d602fc
        having count(*) > 1;
      exception
        when others then
          lx_cont := 0;
      end;
    
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
                      --and t.aosuc = pn_suc --  jrodriguej 28.06.2021
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
          select t.hcimp1, t.hfcon
            into pn_impl, pn_fech
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
                select t.hcimp1, t.hfcon
                  into pn_impl, pn_fech
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
              when others then null;
              end;
            end if;
          
        end;
      else
        begin
        
          select t.itimp1, t.itfval
            into pn_impl, pn_fech
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
              
                select t.itimp1, t.itfval
                  into pn_impl, pn_fech
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
                   when others then null;
              end;
            end if;
          
        end;
      end if;
    exception
      when others then
        pn_impl := 0;
        pn_fech := null;
    end;
  
    --return lx_imp1;
  
  end sp_obtener_pagoi;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Valor de la última cuota pagada
  function fn_obtener_vucuop(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_fecha in date) return number is
  
    lx_sum1 number(17, 2);
    lx_sum2 number(17, 2);
    lx_sumt number(17, 2);
    lx_fpag date;
  
  begin
  
    begin
    
      select max(t.ppfpag)
        into lx_fpag
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
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    
      begin
        select nvl((x.ppcap + x.ppint), 0)
          into lx_sum1
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
           and x.ppfpag = lx_fpag;
      exception
        when others then
          lx_sum1 := 0;
      end;
    
      begin
        select nvl((r.ppimp11 + r.ppimp12 + r.ppimp13 + r.ppimp14 +
                   r.ppimp15 + r.ppimp16 + r.ppimp17 + r.ppimp18 +
                   r.ppimp19 + r.ppimp20),
                   0)
          into lx_sum2
          from fsd611 r
         where r.pgcod = pn_cod
           and r.ppmod = pn_mod
           and r.ppsuc = pn_suc
           and r.ppmda = pn_mda
           and r.pppap = pn_pap
           and r.ppcta = pn_cta
           and r.ppoper = pn_ope
           and r.ppsbop = pn_sbo
           and r.pptope = pn_top
           and r.ppfpag = lx_fpag;
      
      exception
        when others then
          lx_sum2 := 0;
      end;
    
      ---
    exception
      when others then
        lx_sum1 := 0;
        lx_sum2 := 0;
    end;
  
    lx_sumt := lx_sum1 + lx_sum2;
  
    return lx_sumt;
  
  end fn_obtener_vucuop;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Valor de la próxima cuota a vencerse
  procedure sp_obtener_vpcuov(pn_cod   in number,
                              pn_mod   in number,
                              pn_suc   in number,
                              pn_mda   in number,
                              pn_pap   in number,
                              pn_cta   in number,
                              pn_ope   in number,
                              pn_sbo   in number,
                              pn_top   in number,
                              pn_fecha in date,
                              
                              pn_fpag out date,
                              pn_fvto out date,
                              pn_sumt out number) --return number
   is
  
    lx_sum1 number(17, 2);
    lx_sum2 number(17, 2);
    lx_sumt number(17, 2);
  
    --pn_fvto date;
    --pn_resu number(17,2);
  
    lx_fpag  date;
    lx_fpags date;
    lx_fvto  date;
    --lx_fvto date;
    lx_cont number;
  
  begin
  
    lx_sumt  := 0;
    lx_fpags := null;
    lx_fvto  := null;
    -- Obtención de la máxima fecha pagada
  
    begin
      select max(t.ppfpag)
        into lx_fpag
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
         AND T.D602CO = 'S'
         AND T.D602FC <= pn_fecha
      
      ;
    
      -- Verificar si hay cuotas pendientes de pago
      select count(*)
        into lx_cont
      
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
         and x.ppfpag > lx_fpag;
    
    exception
      when others then
        lx_cont := 0;
    end;
  
    if lx_cont > 0 then
    
      -- Obtener la siguiente fecha de la cuota a vencerse
      select f.ppfpag, f.ppfvto
        into lx_fpags, lx_fvto
        from (select x.ppfpag, x.ppfvto
              
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
                 and x.ppfpag > lx_fpag
               order by x.ppfpag asc) f
       where rownum = 1;
    
      ---Sumatorias
      begin
      
        select nvl((x.ppcap + x.ppint), 0)
          into lx_sum1
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
           and x.ppfpag = lx_fpags;
      
      exception
        when others then
          lx_sum1 := 0;
      end;
    
      begin
        select nvl((r.ppimp11 + r.ppimp12 + r.ppimp13 + r.ppimp14 +
                   r.ppimp15 + r.ppimp16 + r.ppimp17 + r.ppimp18 +
                   r.ppimp19 + r.ppimp20),
                   0)
          into lx_sum2
          from fsd611 r
         where r.pgcod = pn_cod
           and r.ppmod = pn_mod
           and r.ppsuc = pn_suc
           and r.ppmda = pn_mda
           and r.pppap = pn_pap
           and r.ppcta = pn_cta
           and r.ppoper = pn_ope
           and r.ppsbop = pn_sbo
           and r.pptope = pn_top
           and r.ppfpag = lx_fpags;
      
      exception
        when others then
          lx_sum2 := 0;
      end;
    
      --Resultado
      lx_sumt := lx_sum1 + lx_sum2;
    
    else
      lx_fpags := null;
      lx_sumt  := 0;
      lx_fvto  := null;
    
    end if;
  
    --return lx_sumt;
    pn_fpag := lx_fpags;
    pn_sumt := lx_sumt;
    pn_fvto := lx_fvto;
  
  end sp_obtener_vpcuov;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_obtener_direcc(pn_pais in SNGC13.sngc13pais%type,
                              pn_tdoc in SNGC13.sngc13tdoc%type,
                              pn_ndoc in SNGC13.sngc13ndoc%type,
                              pn_dirr out SNGC13.sngc13dir%type,
                              pn_ugeo out SNGC13.sngc13ugeo%type) --return number
   is
  
    --lc_dirr char(140);
    --lc_ugeo char(6);
  
  begin
  
    -- 2. Obtención de dirección y ubigeo
    begin
      select t.sngc13dir, t.sngc13ugeo
        into pn_dirr, pn_ugeo
        from SNGC13 t
       where t.sngc13pais = pn_pais
         and t.sngc13tdoc = pn_tdoc
         and t.sngc13ndoc = pn_ndoc
         and t.docod = 1;
    exception
      when others then
        pn_dirr := '';
        pn_ugeo := '';
    end;
  
  end sp_obtener_direcc;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_obtener_tdesti(pn_mod in number) return char is
  
    lx_tdest char(3);
  
  begin
  
    begin
    
      case pn_mod
        when 101 then
          lx_tdest := 'CAT'; --PRÉSTAMOS CAPITAL DE TRABAJO
        when 102 then
          lx_tdest := 'ACF'; --PRÉSTAMOS ACTIVO FIJO
        when 103 then
          lx_tdest := 'MIC'; --PRÉSTAMOS MICRO
        else
          lx_tdest := '';
      end case;
    exception
      when others then
        lx_tdest := '';
    end;
  
    return lx_tdest;
  
  end fn_obtener_tdesti;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_obtener_impaga(pn_cod    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_fecha  in date,
                              pn_fvenuc out date) is
  
    lx_fmax date;
    lx_ind1 number;
  
  begin
  
    begin
    
      lx_ind1 := 1;
    
      select max(t.ppfpag)
        into lx_fmax
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
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    exception
      when others then
        lx_ind1 := 0;
    end;
  
    if lx_fmax is NULL then
      lx_ind1 := 0;
    else
      lx_ind1 := 1;
    end if;
  
    if lx_ind1 = 1 then
      ----Si se pagó
      begin
        select --nvl(f.ppcap, 0), nvl(f.ppint, 0),
         f.ppfpag
          into --lx_pcap, lx_pint,
               pn_fvenuc
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
                   and t.ppfpag > lx_fmax
                   and (t.ppcap + t.ppint) <> 0
                 order by t.ppfpag asc) f
         where rownum = 1;
      
      exception
        when others then
          pn_fvenuc := null;
      end;
    
    else
      --No se pagó nada
      begin
        select --nvl(f.ppcap, 0), nvl(f.ppint, 0),
         f.ppfpag
          into --lx_pcap, lx_pint,
               pn_fvenuc
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
                 order by t.ppfpag asc) f
         where rownum = 1;
      exception
        when others then
          pn_fvenuc := null;
      end;
    
    end if;
  
  end sp_obtener_impaga;
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
        lx_fpagu := null;
    end;
  
    if lx_fpagu is null then
      --no se ha hecho ningún pago
      lx_fvenu := null;
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
        select t.ppfvto
          into lx_fvenu
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
  procedure sp_distribuc_pago(pn_cod   in number,
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
                 and t.ppmod = pn_mod
                 and t.ppsuc = pn_suc
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 and t.ppsbop = pn_sbo
                 and t.pptope = pn_top
                 and t.pp1stat in ('P', 'T')
                    --and (t.d602mo, t.d602tr) not in --- jrodriguej 12/08.2021
                    --(select x.tp1nro1, x.tp1nro2
                    --   from fst198 x
                    --  where x.TP1COD = 1
                    --    and x.TP1COD1 = 11144
                    --    and x.TP1CORR1 = 1
                    --   and x.tp1corr2 = 2
                    --    and x.tp1corr3 > 0)
                    
                 and t.d602fc <= pn_fecha
                 and t.d602co = 'S'
              
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
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.ppfpag = lc_ppfpag
           and t.pp1stat in ('P', 'T')
              --and t.d602fc <= pn_fecha
              --and (t.d602mo, t.d602tr) not in --- jrodriguej 12/08.2021
              --(select x.tp1nro1, x.tp1nro2
              --   from fst198 x
              --  where x.TP1COD = 1
              --    and x.TP1COD1 = 11144
              --    and x.TP1CORR1 = 1
              --    and x.tp1corr2 = 2
              --    and x.tp1corr3 > 0)
              
           and t.d602co = 'S';
      
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
              --and x.pp1nump <= lc_pp1nump;
           and x.pp1nump = lc_pp1nump
              
              --and (t.d602mo, t.d602tr) not in --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S'
        
        ;
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
              --and x.pp003nump <= lc_pp1nump;
           and x.pp003nump = lc_pp1nump
              
              --and (t.d602mo, t.d602tr) not in --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S'
        
        ;
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
  
  end sp_distribuc_pago;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_mprepago(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_monto out number) is
  
    lx_imp number(17, 2);
    lx_cd  number(3);
    lx_mo  number(3);
    lx_su  number(3);
    lx_tr  number(3);
    lx_re  number(4);
    lx_fc  date;
    ---lx_imp1  number(17, 2);
    ---lx_sdoi  number(17, 2);
    lx_fecha date;
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
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
                 and t.aomda = pn_mda
                 and t.aopap = pn_pap
                 and t.aocta = pn_cta
                 and t.aooper = pn_ope
                    --and t.aosbop = pn_sbo
                    --and t.aotope = pn_top   dcastro 24.09.2021
                 and t.evtipo = 50
                 and t.d012co = 'S'
                 and t.d012fc <= pn_fecha
               order by t.d012fc desc) f
       where rownum = 1;
    
      --if lx_fecha <> pn_fecha then
      if lx_fc <> pn_fecha then
      
        select t.hcimp1
          into pn_monto
          from fsh016 t
         where t.pgcod = lx_cd
           and t.hcmod = lx_mo
           and t.hsucor = lx_su
           and t.htran = lx_tr
           and t.hnrel = lx_re
           and t.hfcon = lx_fc
           and t.hcord = 83;
      
      else
      
        select t.itimp1
          into pn_monto
          from fsd016 t
         where t.pgcod = lx_cd
           and t.itmod = lx_mo
           and t.itsuc = lx_su
           and t.ittran = lx_tr
           and t.itnrel = lx_re
              --and t.itfval = lx_fc
           and t.itord = 83;
      
      end if;
    
    exception
      when others then
        pn_monto := 0;
    end;
  
  end sp_obtener_mprepago;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato_jaqa400(pn_cod   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_fecha in date,
                                  pn_flag  out char,
                                  pn_nrep  out number,
                                  pn_fech  out date,
                                  pn_tabla out varchar2,
                                  pn_peri  out number,
                                  pn_ncuo  out number,
                                  pn_fpri  out date,
                                  pn_fult  out date) is
  
    lx_cont number;
    --lx_conce char(25);
    ld_fecha1 date;
    ld_fecha2 date;
    lx_sbop   number;
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
    pn_tabla := 'jaqa400';
    select count(*), max(x.jaqa400fec)
      into lx_cont, pn_fech
      from jaqa400 x
     where x.jaqa400emp = pn_cod
          --and x.jaqa400mod = j.aomod
          --and x.jaqa400suc = t.AOSUC
          --and x.jaqa400mda = j.aomda
          --and x.jaqa400pap = j.aopap
       and x.jaqa400cta = pn_cta
       and x.jaqa400ope = pn_ope
          --x.jaqa400sbo = t.AOSBOP and
          --and x.jaqa400top = t.AOTOPE
          --and x.jaqa400ac1 in ('U','C')
       and x.jaqa400est in ('C')
       and x.jaqa400fec <= pn_fecha;
  
    if lx_cont > 0 then
    
      pn_flag := 'SI';
      pn_nrep := lx_cont;
      --periodod gracia
      begin
        select a.xllfprimpa
          into ld_fecha2
          from x054023 a
         where a.xllpgcod = pn_cod
           and a.xllaocta = pn_cta
           and a.xllaooper = pn_ope
           and a.xllaosbop = 609
           and rownum = 1;
        select max(a.xllfprimpa)
          into ld_fecha1
          from x054023 a
         where a.xllpgcod = pn_cod
           and a.xllaocta = pn_cta
           and a.xllaooper = pn_ope
           and a.xllaosbop <> 609
           and a.xllfprimpa < ld_fecha2;
        if ld_fecha2 is null then
          pn_peri := 0;
        else
          if ld_fecha1 is null then
            pn_peri := 0;
          else
            select round((ld_fecha2 - ld_fecha1) / 30)
              into pn_peri
              from dual;
          end if;
        end if;
      
      exception
        when others then
          pn_peri := 0;
      end;
      if pn_peri < 0 then
        pn_peri := 0;
      end if;
      begin
        select max(t.aosbop)
          into lx_sbop
          from fsd010 t
         where t.pgcod = pn_cod
              --and t.aomod = pn_aomod
              --and t.aomda = pn_aomda
              --and t.aopap = pn_aopap
           and t.aocta = pn_cta
           and t.aooper = pn_ope
              --and t.aomod <> 419 --  jrodriguej 28.06.2021
           and t.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144));
      
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
              --and t.aomod = pn_aomod
              --and t.aomda = pn_aomda
              --and t.aopap = pn_aopap
           and t.aocta = pn_cta
           and t.aooper = pn_ope
           and t.aosbop = lx_sbop
              --and t.aomod <> 419 --  jrodriguej 28.06.2021
           and t.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
           and rownum = 1;
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
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
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
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
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
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
      exception
        when others then
        
          pn_ncuo := 0;
          pn_fpri := null;
          pn_fult := null;
      end;
    else
      pn_flag  := 'NO';
      pn_nrep  := 0;
      pn_fech  := null;
      pn_tabla := null;
      pn_peri  := 0;
      pn_ncuo  := 0;
      pn_fpri  := null;
      pn_fult  := null;
    end if;
  
  end sp_repro_dato_jaqa400;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato1(pn_cod   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_fecha in date,
                           pn_flag  out char,
                           pn_nrep  out number,
                           pn_fech  out date,
                           pn_tabla out varchar2,
                           pn_peri  out number,
                           pn_ncuo  out number,
                           pn_fpri  out date,
                           pn_fult  out date) is
  
    lx_cont number;
    --lx_conce char(25);
  
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
      pn_nrep := lx_cont;
    
      select y.aqpb090fec, y.aqpb090tabla
        into pn_fech, pn_tabla
        from (select x.aqpb090fec, x.aqpb090tabla
                from aqpb090 x
               where x.aqpb090fec <= pn_fecha
                 and x.aqpb090cta = pn_cta
                 and x.aqpb090oper = pn_ope
                 and x.aqpb090ext = 'NO'
               order by x.aqpb090fec desc) y
       where rownum = 1;
    
      -- Obtención de datos adicionales
      if pn_tabla = 'AQPB002' or pn_tabla = 'JAQZ698' then
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_repro_dato2(pn_cod   => pn_cod,
                                                 pn_cta   => pn_cta,
                                                 pn_ope   => pn_ope,
                                                 pn_frep  => pn_fech,
                                                 pn_tabla => pn_tabla,
                                                 pn_peri  => pn_peri,
                                                 pn_ncuo  => pn_ncuo,
                                                 pn_fpri  => pn_fpri,
                                                 pn_fult  => pn_fult);
          pn_peri := round(pn_peri / 30);
        exception
                   when others then null;
        end;
      else
        pn_peri := 0;
        pn_ncuo := 0;
        pn_fpri := null;
        pn_fult := null;
      end if;
    
    else
      pn_flag  := 'NO';
      pn_nrep  := 0;
      pn_fech  := null;
      pn_tabla := null;
      pn_peri  := 0;
      pn_ncuo  := 0;
      pn_fpri  := null;
      pn_fult  := null;
    end if;
  
  end sp_repro_dato1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_dato2(pn_cod   in number,
                           pn_cta   in number,
                           pn_ope   in number,
                           pn_frep  in date,
                           pn_tabla in varchar2,
                           
                           pn_peri out number,
                           pn_ncuo out number,
                           pn_fpri out date,
                           pn_fult out date) is
  
    lx_exis number;
    lx_vali number;
  
    ln_pgcod number;
    ln_mod   number;
    ln_suc   number;
    ln_mda   number;
    ln_pap   number;
    ln_sbop  number;
    ln_tope  number;
  
    --lx_pgcod number;
    lx_mod  number;
    lx_suc  number;
    lx_mda  number;
    lx_pap  number;
    lx_sbop number;
    lx_tope number;
    lc_frep date;
    lc_corr number;
  
    --lx_peri number;
    --lx_ncuo number;
    --lx_fpri date;
    --lx_fult date;
  
  begin
  
    lx_vali := 1;
    -- Obtención de la clave del crédito
    begin
      pq_cr_reporte_fondos_p3.sp_cr_datoscre(pn_cta => pn_cta,
                                             pn_ope => pn_ope,
                                             pn_emp => ln_pgcod,
                                             pn_mod => ln_mod,
                                             pn_suc => ln_suc,
                                             pn_mda => ln_mda,
                                             pn_pap => ln_pap,
                                             pn_sbo => ln_sbop,
                                             pn_top => ln_tope);
    exception
                   when others then null;
    end;
    -- Obtención de la fecha de la primera cuota de reprogramación
    case
      when pn_tabla = 'AQPB002' then
      
        select count(*)
          into lx_exis
          from aqpb002 x
         where x.aqpb002emp = pn_cod
           and x.aqpb002mod = ln_mod
           and x.aqpb002mda = ln_mda
           and x.aqpb002pap = ln_pap
           and x.aqpb002cta = pn_cta
           and x.aqpb002ope = pn_ope
           and x.aqpb002est = 'C'
           and x.aqpb002fep > pn_frep;
      
        -- captura de datos
        begin
          select g.aqpb002fep,
                 g.aqpb002cor,
                 g.aqpb002mod,
                 g.aqpb002suc,
                 g.aqpb002mda,
                 g.aqpb002pap,
                 g.aqpb002sbo,
                 g.aqpb002top
            into lc_frep,
                 lc_corr,
                 lx_mod,
                 lx_suc,
                 lx_mda,
                 lx_pap,
                 lx_sbop,
                 lx_tope
            from (select x.aqpb002fep,
                         x.aqpb002cor,
                         x.aqpb002mod,
                         x.aqpb002suc,
                         x.aqpb002mda,
                         x.aqpb002pap,
                         x.aqpb002sbo,
                         x.aqpb002top
                  
                    from aqpb002 x
                   where x.aqpb002emp = pn_cod
                     and x.aqpb002mod = ln_mod
                     and x.aqpb002mda = ln_mda
                     and x.aqpb002pap = ln_pap
                     and x.aqpb002cta = pn_cta
                     and x.aqpb002ope = pn_ope
                     and x.aqpb002est = 'C'
                     and x.aqpb002fep >= pn_frep
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
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_insertar_detalle_grupo1(pn_frep   => lc_frep,
                                                               pn_corr   => lc_corr,
                                                               pn_pgcod  => pn_cod,
                                                               pn_aomod  => lx_mod,
                                                               pn_aosuc  => lx_suc,
                                                               pn_aomda  => lx_mda,
                                                               pn_aopap  => lx_pap,
                                                               pn_aocta  => pn_cta,
                                                               pn_aooper => pn_ope,
                                                               pn_aosbop => lx_sbop,
                                                               pn_aotope => lx_tope,
                                                               
                                                               pn_peri => pn_peri,
                                                               pn_ncuo => pn_ncuo,
                                                               pn_fpri => pn_fpri,
                                                               pn_fult => pn_fult);
          exception
                   when others then null;
          end;
        
        elsif lx_exis = 1 and lx_vali = 1 then
          --lx_exis := 1;
          begin
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_insertar_detalle_grupo2(pn_frep   => lc_frep,
                                                               pn_corr   => lc_corr,
                                                               pn_pgcod  => pn_cod,
                                                               pn_aomod  => lx_mod,
                                                               pn_aosuc  => lx_suc,
                                                               pn_aomda  => lx_mda,
                                                               pn_aopap  => lx_pap,
                                                               pn_aocta  => pn_cta,
                                                               pn_aooper => pn_ope,
                                                               pn_aosbop => lx_sbop,
                                                               pn_aotope => lx_tope,
                                                               
                                                               pn_peri => pn_peri,
                                                               pn_ncuo => pn_ncuo,
                                                               pn_fpri => pn_fpri,
                                                               pn_fult => pn_fult);
          exception
                   when others then null;
          end;
        
        elsif lx_exis >= 2 and lx_vali = 1 then
          --lx_exis := 1;
          begin
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_insertar_detalle_grupo3(pn_frep   => lc_frep,
                                                               pn_corr   => lc_corr,
                                                               pn_pgcod  => pn_cod,
                                                               pn_aomod  => lx_mod,
                                                               pn_aosuc  => lx_suc,
                                                               pn_aomda  => lx_mda,
                                                               pn_aopap  => lx_pap,
                                                               pn_aocta  => pn_cta,
                                                               pn_aooper => pn_ope,
                                                               pn_aosbop => lx_sbop,
                                                               pn_aotope => lx_tope,
                                                               
                                                               pn_peri => pn_peri,
                                                               pn_ncuo => pn_ncuo,
                                                               pn_fpri => pn_fpri,
                                                               pn_fult => pn_fult);
          exception
                   when others then null;
          end;
        end if;
      
      when pn_tabla = 'JAQZ698' then
      
        select count(*)
          into lx_exis
          from jaqz698 x
         where x.jaqz698emp = pn_cod
           and x.jaqz698mod = ln_mod
           and x.jaqz698mda = ln_mda
           and x.jaqz698pap = ln_pap
           and x.jaqz698cta = pn_cta
           and x.jaqz698ope = pn_ope
           and x.jaqz698est in ('C', 'V')
           and x.jaqz698fep > pn_frep;
      
        -- captura de datos
        begin
          select g.jaqz698fep,
                 g.jaqz698cor,
                 g.jaqz698mod,
                 g.jaqz698suc,
                 g.jaqz698mda,
                 g.jaqz698pap,
                 g.jaqz698sbo,
                 g.jaqz698top
            into lc_frep,
                 lc_corr,
                 lx_mod,
                 lx_suc,
                 lx_mda,
                 lx_pap,
                 lx_sbop,
                 lx_tope
            from (select x.jaqz698fep,
                         x.jaqz698cor,
                         x.jaqz698mod,
                         x.jaqz698suc,
                         x.jaqz698mda,
                         x.jaqz698pap,
                         x.jaqz698sbo,
                         x.jaqz698top
                  
                    from jaqz698 x
                   where x.jaqz698emp = pn_cod
                     and x.jaqz698mod = ln_mod
                     and x.jaqz698mda = ln_mda
                     and x.jaqz698pap = ln_pap
                     and x.jaqz698cta = pn_cta
                     and x.jaqz698ope = pn_ope
                     and x.jaqz698est in ('C', 'V')
                     and x.jaqz698fep >= pn_frep
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
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_repro_jaqz698_g1(pn_frep   => lc_frep,
                                                        pn_corr   => lc_corr,
                                                        pn_pgcod  => pn_cod,
                                                        pn_aomod  => lx_mod,
                                                        pn_aosuc  => lx_suc,
                                                        pn_aomda  => lx_mda,
                                                        pn_aopap  => lx_pap,
                                                        pn_aocta  => pn_cta,
                                                        pn_aooper => pn_ope,
                                                        pn_aosbop => lx_sbop,
                                                        pn_aotope => lx_tope,
                                                        
                                                        pn_peri => pn_peri,
                                                        pn_ncuo => pn_ncuo,
                                                        pn_fpri => pn_fpri,
                                                        pn_fult => pn_fult);
          exception
                   when others then null;
          end;
        
        elsif lx_exis >= 1 and lx_vali = 1 then
          --lx_exis := 1;
          begin
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_repro_jaqz698_g2(pn_frep   => lc_frep,
                                                        pn_corr   => lc_corr,
                                                        pn_pgcod  => pn_cod,
                                                        pn_aomod  => lx_mod,
                                                        pn_aosuc  => lx_suc,
                                                        pn_aomda  => lx_mda,
                                                        pn_aopap  => lx_pap,
                                                        pn_aocta  => pn_cta,
                                                        pn_aooper => pn_ope,
                                                        pn_aosbop => lx_sbop,
                                                        pn_aotope => lx_tope,
                                                        
                                                        pn_peri => pn_peri,
                                                        pn_ncuo => pn_ncuo,
                                                        pn_fpri => pn_fpri,
                                                        pn_fult => pn_fult);
          exception
                   when others then null;
          end;
        
        end if;
      
    --when pn_tabla = 'JAQZ255' then
    --  lx_exis := 1;
    end case;
  
    --pn_fpri := null;
  
  end sp_repro_dato2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_DATOSCRE(pn_cta in number,
                           pn_ope in number,
                           pn_emp out number,
                           pn_mod out number,
                           pn_suc out number,
                           pn_mda out number,
                           pn_pap out number,
                           pn_sbo out number,
                           pn_top out number) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOSCRE
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2020.10.16
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Almacena campos de pk del credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Par¿metros de Entrada      :
    --
    -- Retorno                    :
    --
    -- *****************************************************************
  BEGIN
  
    pn_emp := 0;
  
    begin
      select f.pgcod,
             f.aomod,
             f.aosuc,
             f.aomda,
             f.aopap,
             f.aosbop,
             f.aotope
        into pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_sbo, pn_top
        from fsd010 f
       where f.aomod <> 419
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aostat <> 99;
    exception
      when no_data_found then
        begin
          select f.pgcod,
                 f.aomod,
                 f.aosuc,
                 f.aomda,
                 f.aopap,
                 f.aosbop,
                 f.aotope
            into pn_emp, pn_mod, pn_suc, pn_mda, pn_pap, pn_sbo, pn_top
            from fsd010 f
           where f.aomod <> 419
             and f.aocta = pn_cta
             and f.aooper = pn_ope
             and f.aostat = 99
             and f.aofe99 in (select max(f.aofe99)
                                from fsd010 f
                               where f.aomod <> 419
                                 and f.aocta = pn_cta
                                 and f.aooper = pn_ope
                                 and f.aostat = 99);
        exception
          when others then
            pn_emp := 0;
            pn_mod := 0;
            pn_suc := 0;
            pn_mda := 0;
            pn_pap := 0;
            pn_sbo := 0;
            pn_top := 0;
        end;
    end;
  
  END SP_CR_DATOSCRE;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Búsqueda de reprogramación en AQPB002
  -- Cuando el crédito reprogramado es el vigente
  PROCEDURE sp_insertar_detalle_grupo1(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date) is
  
    lx_sbop number;
  
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
  
    -- Obtener máxima suboperación
    select max(t.aosbop)
      into lx_sbop
      from fsd010 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
          --and t.aomod <> 419 --  jrodriguej 28.06.2021
       and t.aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (29, 120, 144));
  
    -- Comparar
    if lx_sbop <> pn_aosbop then
    
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
       where t.pgcod = pn_pgcod
         and t.aomod = pn_aomod
         and t.aomda = pn_aomda
         and t.aopap = pn_aopap
         and t.aocta = pn_aocta
         and t.aooper = pn_aooper
         and t.aosbop = lx_sbop
            --and t.aomod <> 419 --  jrodriguej 28.06.2021
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
    
    end if;
  
    -- Obtener periodo de gracia
    select (x.aqpb002pdi * 30)
      into pn_peri
      from aqpb002 x
     where x.aqpb002fep = pn_frep
       and x.aqpb002cor = pn_corr
       and x.aqpb002emp = pn_pgcod
       and x.aqpb002mod = pn_aomod
       and x.aqpb002suc = pn_aosuc
       and x.aqpb002mda = pn_aomda
       and x.aqpb002pap = pn_aopap
       and x.aqpb002cta = pn_aocta
       and x.aqpb002ope = pn_aooper
       and x.aqpb002sbo = pn_aosbop
       and x.aqpb002top = pn_aotope;
  
    if lx_sbop <> pn_aosbop then
      begin
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
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
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
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
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
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
      
      end;
    else
      begin
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
          from fsd601 t
         where t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag asc) g
         where rownum = 1;
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag desc) g
         where rownum = 1;
      exception
         when others then null;
      end;
    end if;
  
  end sp_insertar_detalle_grupo1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Búsqueda de reprogramación en AQPB002
  -- Cuando hay un crédito reprogramado después del obtenido
  PROCEDURE sp_insertar_detalle_grupo2(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date) is
  
    lx_frep   date;
    lx_corr   number;
    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
  
  begin
  
    -- Obtener periodo de gracia
    select (x.aqpb002pdi * 30)
      into pn_peri
      from aqpb002 x
     where x.aqpb002fep = pn_frep
       and x.aqpb002cor = pn_corr
       and x.aqpb002emp = pn_pgcod
       and x.aqpb002mod = pn_aomod
       and x.aqpb002suc = pn_aosuc
       and x.aqpb002mda = pn_aomda
       and x.aqpb002pap = pn_aopap
       and x.aqpb002cta = pn_aocta
       and x.aqpb002ope = pn_aooper
       and x.aqpb002sbo = pn_aosbop
       and x.aqpb002top = pn_aotope;
  
    -- Obtener información de la siguiente reprogramación
    select g.aqpb002fep,
           g.aqpb002cor,
           g.aqpb002emp,
           g.aqpb002mod,
           g.aqpb002suc,
           g.aqpb002mda,
           g.aqpb002pap,
           g.aqpb002cta,
           g.aqpb002ope,
           g.aqpb002sbo,
           g.aqpb002top
      into lx_frep,
           lx_corr,
           lx_pgcod,
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope
      from (select t.aqpb002fep,
                   t.aqpb002cor,
                   t.aqpb002emp,
                   t.aqpb002mod,
                   t.aqpb002suc,
                   t.aqpb002mda,
                   t.aqpb002pap,
                   t.aqpb002cta,
                   t.aqpb002ope,
                   t.aqpb002sbo,
                   t.aqpb002top
              from aqpb002 t
             where t.aqpb002emp = pn_pgcod
               and t.aqpb002mod = pn_aomod
               and t.aqpb002mda = pn_aomda
               and t.aqpb002pap = pn_aopap
               and t.aqpb002cta = pn_aocta
               and t.aqpb002ope = pn_aooper
               and t.aqpb002fep >= pn_frep
               and t.aqpb002est = 'C'
             order by t.aqpb002fep asc) g
     where rownum = 1;
  
    -- Obter número de cuotas
    select count(*)
      into pn_ncuo
      from jaqz520_601 t
     where t.pgcod = lx_pgcod
       and t.ppmod = lx_aomod
       and t.ppsuc = lx_aosuc
       and t.ppmda = lx_aomda
       and t.pppap = lx_aopap
       and t.ppcta = lx_aocta
       and t.ppoper = lx_aooper
       and t.ppsbop = lx_aosbop
       and t.pptope = lx_aotope;
  
    -- Obtener primera fecha del crédito reprogramado
    select g.ppfpag
      into pn_fpri
      from (select t.ppfpag
              from jaqz520_601 t
             where t.pgcod = lx_pgcod
               and t.ppmod = lx_aomod
               and t.ppsuc = lx_aosuc
               and t.ppmda = lx_aomda
               and t.pppap = lx_aopap
               and t.ppcta = lx_aocta
               and t.ppoper = lx_aooper
               and t.ppsbop = lx_aosbop
               and t.pptope = lx_aotope
             order by t.ppfpag asc) g
     where rownum = 1;
  
    -- Obtener fecha de fin del crédito reprogramado
    select g.ppfpag
      into pn_fult
      from (select t.ppfpag
              from jaqz520_601 t
             where t.pgcod = lx_pgcod
               and t.ppmod = lx_aomod
               and t.ppsuc = lx_aosuc
               and t.ppmda = lx_aomda
               and t.pppap = lx_aopap
               and t.ppcta = lx_aocta
               and t.ppoper = lx_aooper
               and t.ppsbop = lx_aosbop
               and t.pptope = lx_aotope
             order by t.ppfpag desc) g
     where rownum = 1;
  
  end sp_insertar_detalle_grupo2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Búsqueda de reprogramación en AQPB002
  -- Cuando hay más de un crédito reprogramado después del obtenido
  PROCEDURE sp_insertar_detalle_grupo3(pn_frep   in date,
                                       pn_corr   in number,
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number,
                                       
                                       pn_peri out number,
                                       pn_ncuo out number,
                                       pn_fpri out date,
                                       pn_fult out date) is
  
    lx_frep   date;
    lx_corr   number;
    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
  
  begin
  
    -- Obtener periodo de gracia
    select (x.aqpb002pdi * 30)
      into pn_peri
      from aqpb002 x
     where x.aqpb002fep = pn_frep
       and x.aqpb002cor = pn_corr
       and x.aqpb002emp = pn_pgcod
       and x.aqpb002mod = pn_aomod
       and x.aqpb002suc = pn_aosuc
       and x.aqpb002mda = pn_aomda
       and x.aqpb002pap = pn_aopap
       and x.aqpb002cta = pn_aocta
       and x.aqpb002ope = pn_aooper
       and x.aqpb002sbo = pn_aosbop
       and x.aqpb002top = pn_aotope;
  
    -- Obtener información de la siguiente reprogramación
    select g.aqpb002fep,
           g.aqpb002cor,
           g.aqpb002emp,
           g.aqpb002mod,
           g.aqpb002suc,
           g.aqpb002mda,
           g.aqpb002pap,
           g.aqpb002cta,
           g.aqpb002ope,
           g.aqpb002sbo,
           g.aqpb002top
      into lx_frep,
           lx_corr,
           lx_pgcod,
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope
      from (select t.aqpb002fep,
                   t.aqpb002cor,
                   t.aqpb002emp,
                   t.aqpb002mod,
                   t.aqpb002suc,
                   t.aqpb002mda,
                   t.aqpb002pap,
                   t.aqpb002cta,
                   t.aqpb002ope,
                   t.aqpb002sbo,
                   t.aqpb002top
              from aqpb002 t
             where t.aqpb002emp = pn_pgcod
               and t.aqpb002mod = pn_aomod
               and t.aqpb002mda = pn_aomda
               and t.aqpb002pap = pn_aopap
               and t.aqpb002cta = pn_aocta
               and t.aqpb002ope = pn_aooper
               and t.aqpb002fep >= pn_frep
               and t.aqpb002est = 'C'
             order by t.aqpb002fep asc) g
     where rownum = 1;
  
    -- Obter número de cuotas
    select count(*)
      into pn_ncuo
      from aqpa006 t
     where t.aqpa006fecpro = lx_frep
       and t.aqpa006cor = lx_corr
       and t.aqpa006cod = lx_pgcod
       and t.aqpa006mod = lx_aomod
       and t.aqpa006suc = lx_aosuc
       and t.aqpa006mda = lx_aomda
       and t.aqpa006pap = lx_aopap
       and t.aqpa006cta = lx_aocta
       and t.aqpa006oper = lx_aooper
       and t.aqpa006sbop = lx_aosbop
       and t.aqpa006tope = lx_aotope;
  
    -- Obtener primera fecha del crédito reprogramado
    select g.aqpa006fpag
      into pn_fpri
      from (select t.aqpa006fpag
              from aqpa006 t
             where t.aqpa006fecpro = lx_frep
               and t.aqpa006cor = lx_corr
               and t.aqpa006cod = lx_pgcod
               and t.aqpa006mod = lx_aomod
               and t.aqpa006suc = lx_aosuc
               and t.aqpa006mda = lx_aomda
               and t.aqpa006pap = lx_aopap
               and t.aqpa006cta = lx_aocta
               and t.aqpa006oper = lx_aooper
               and t.aqpa006sbop = lx_aosbop
               and t.aqpa006tope = lx_aotope
             order by t.aqpa006fpag asc) g
     where rownum = 1;
  
    -- Obtener fecha de fin del crédito reprogramado
    select g.aqpa006fpag
      into pn_fult
      from (select t.aqpa006fpag
              from aqpa006 t
             where t.aqpa006fecpro = lx_frep
               and t.aqpa006cor = lx_corr
               and t.aqpa006cod = lx_pgcod
               and t.aqpa006mod = lx_aomod
               and t.aqpa006suc = lx_aosuc
               and t.aqpa006mda = lx_aomda
               and t.aqpa006pap = lx_aopap
               and t.aqpa006cta = lx_aocta
               and t.aqpa006oper = lx_aooper
               and t.aqpa006sbop = lx_aosbop
               and t.aqpa006tope = lx_aotope
             order by t.aqpa006fpag desc) g
     where rownum = 1;
  
  end sp_insertar_detalle_grupo3;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Reprogramacion_JAQZ698
  -- Cuando el crédito reprogramado es el último
  PROCEDURE sp_repro_jaqz698_g1(pn_frep   in date,
                                pn_corr   in number,
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                
                                pn_peri out number,
                                pn_ncuo out number,
                                pn_fpri out date,
                                pn_fult out date) is
  
    lx_sbop number;
  
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
  
    -- Obtener máxima suboperación
    select max(t.aosbop)
      into lx_sbop
      from fsd010 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
          --and t.aomod <> 419 --  jrodriguej 28.06.2021
       and t.aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (29, 120, 144));
  
    -- Comparar
    if lx_sbop <> pn_aosbop then
    
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
       where t.pgcod = pn_pgcod
         and t.aomod = pn_aomod
         and t.aomda = pn_aomda
         and t.aopap = pn_aopap
         and t.aocta = pn_aocta
         and t.aooper = pn_aooper
         and t.aosbop = lx_sbop
            --and t.aomod <> 419 --  jrodriguej 28.06.2021
         and t.aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144));
    
    end if;
  
    -- Obtener periodo de gracia
    select x.jaqz698per
      into pn_peri
      from jaqz698 x
     where x.jaqz698fep = pn_frep
       and x.jaqz698cor = pn_corr
       and x.jaqz698emp = pn_pgcod
       and x.jaqz698mod = pn_aomod
       and x.jaqz698suc = pn_aosuc
       and x.jaqz698mda = pn_aomda
       and x.jaqz698pap = pn_aopap
       and x.jaqz698cta = pn_aocta
       and x.jaqz698ope = pn_aooper
       and x.jaqz698sbo = pn_aosbop
       and x.jaqz698top = pn_aotope;
  
    if lx_sbop <> pn_aosbop then
      begin
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
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
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
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
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
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
      
      end;
    else
      begin
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
          from fsd601 t
         where t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag asc) g
         where rownum = 1;
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
          from (select t.ppfpag
                  from fsd601 t
                 where t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag desc) g
         where rownum = 1;
      
      end;
    end if;
  
  end sp_repro_jaqz698_g1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Reprogramacion_JAQZ698
  -- Cuando el crédito reprogramado NO es el último
  PROCEDURE sp_repro_jaqz698_g2(pn_frep   in date,
                                pn_corr   in number,
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                
                                pn_peri out number,
                                pn_ncuo out number,
                                pn_fpri out date,
                                pn_fult out date) is
  
    lx_frep   date;
    lx_corr   number;
    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
  
    ln_exis number;
  
  begin
  
    -- Obtener periodo de gracia
    select x.jaqz698per
      into pn_peri
      from jaqz698 x
     where x.jaqz698fep = pn_frep
       and x.jaqz698cor = pn_corr
       and x.jaqz698emp = pn_pgcod
       and x.jaqz698mod = pn_aomod
       and x.jaqz698suc = pn_aosuc
       and x.jaqz698mda = pn_aomda
       and x.jaqz698pap = pn_aopap
       and x.jaqz698cta = pn_aocta
       and x.jaqz698ope = pn_aooper
       and x.jaqz698sbo = pn_aosbop
       and x.jaqz698top = pn_aotope;
  
    -- Obtener datos del crédito vigente a ese entonces
    -- Obtener información de la siguiente reprogramación
    ln_exis := 1;
    begin
      select g.jaqz698fep,
             g.jaqz698cor,
             g.jaqz698emp,
             g.jaqz698mod,
             g.jaqz698suc,
             g.jaqz698mda,
             g.jaqz698pap,
             g.jaqz698cta,
             g.jaqz698ope,
             g.jaqz698sbo,
             g.jaqz698top
        into lx_frep,
             lx_corr,
             lx_pgcod,
             lx_aomod,
             lx_aosuc,
             lx_aomda,
             lx_aopap,
             lx_aocta,
             lx_aooper,
             lx_aosbop,
             lx_aotope
        from (select t.jaqz698fep,
                      t.jaqz698cor,
                      t.jaqz698emp,
                      t.jaqz698mod,
                      t.jaqz698suc,
                      t.jaqz698mda,
                      t.jaqz698pap,
                      t.jaqz698cta,
                      t.jaqz698ope,
                      t.jaqz698sbo,
                      t.jaqz698top
                 from jaqz698 t
                where
               --t.jaqz698fep = pn_frep
               -- and t.jaqz698cor = pn_corr
                t.jaqz698emp = pn_pgcod
             and t.jaqz698mod = pn_aomod
             and t.jaqz698suc = pn_aosuc
             and t.jaqz698mda = pn_aomda
             and t.jaqz698pap = pn_aopap
             and t.jaqz698cta = pn_aocta
             and t.jaqz698ope = pn_aooper
             and t.jaqz698sbo = pn_aosbop
             and t.jaqz698top = pn_aotope
             and t.jaqz698fep > pn_frep
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
          into pn_ncuo
          from jaqz520_601c t
         where t.fec = pn_frep
           and t.cor = pn_corr
           and t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
          from (select t.ppfpag
                  from jaqz520_601c t
                 where t.fec = pn_frep
                   and t.cor = pn_corr
                   and t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag asc) g
         where rownum = 1;
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
          from (select t.ppfpag
                  from jaqz520_601c t
                 where t.fec = pn_frep
                   and t.cor = pn_corr
                   and t.pgcod = pn_pgcod
                   and t.ppmod = pn_aomod
                   and t.ppsuc = pn_aosuc
                   and t.ppmda = pn_aomda
                   and t.pppap = pn_aopap
                   and t.ppcta = pn_aocta
                   and t.ppoper = pn_aooper
                   and t.ppsbop = pn_aosbop
                   and t.pptope = pn_aotope
                 order by t.ppfpag desc) g
         where rownum = 1;
      
      end;
    else
      begin
      
        -- Obter número de cuotas
        select count(*)
          into pn_ncuo
          from jaqz520_601c t
         where t.fec = lx_frep
           and t.cor = lx_corr
           and t.pgcod = lx_pgcod
           and t.ppmod = lx_aomod
           and t.ppsuc = lx_aosuc
           and t.ppmda = lx_aomda
           and t.pppap = lx_aopap
           and t.ppcta = lx_aocta
           and t.ppoper = lx_aooper
           and t.ppsbop = lx_aosbop
           and t.pptope = lx_aotope;
      
        -- Obtener primera fecha del crédito reprogramado
        select g.ppfpag
          into pn_fpri
          from (select t.ppfpag
                  from jaqz520_601c t
                 where t.fec = lx_frep
                   and t.cor = lx_corr
                   and t.pgcod = lx_pgcod
                   and t.ppmod = lx_aomod
                   and t.ppsuc = lx_aosuc
                   and t.ppmda = lx_aomda
                   and t.pppap = lx_aopap
                   and t.ppcta = lx_aocta
                   and t.ppoper = lx_aooper
                   and t.ppsbop = lx_aosbop
                   and t.pptope = lx_aotope
                 order by t.ppfpag asc) g
         where rownum = 1;
      
        -- Obtener fecha de fin del crédito reprogramado
        select g.ppfpag
          into pn_fult
          from (select t.ppfpag
                  from jaqz520_601c t
                 where t.fec = lx_frep
                   and t.cor = lx_corr
                   and t.pgcod = lx_pgcod
                   and t.ppmod = lx_aomod
                   and t.ppsuc = lx_aosuc
                   and t.ppmda = lx_aomda
                   and t.pppap = lx_aopap
                   and t.ppcta = lx_aocta
                   and t.ppoper = lx_aooper
                   and t.ppsbop = lx_aosbop
                   and t.pptope = lx_aotope
                 order by t.ppfpag desc) g
         where rownum = 1;
      
      end;
    end if;
  
  end sp_repro_jaqz698_g2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_repro_extorno(pn_cod   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_fecha in date,
                             
                             pn_flag out char,
                             pn_fech out date) is
  
    lx_cont number;
    --lx_conce char(25);
  
  begin
    /*
        select count(*)
          into lx_cont
          from USRREPBI.REP_TOT_REPRO_2020 x
         where x.fecha_reprogramacion <= pn_fecha
           and x.bccta = pn_cta
           and x.bcoper = pn_ope
           and x.extorno = 'SI'
              --and x.tabla_origen in ('JAQA255', 'AQPB002', 'JAQZ698');
           and x.tabla_origen in ('AQPB002', 'JAQZ698');
    */
  
    select count(*)
      into lx_cont
      from aqpb090 x
     where x.aqpb090fec <= pn_fecha
       and x.aqpb090cta = pn_cta
       and x.aqpb090oper = pn_ope
       and x.aqpb090ext = 'SI'
       and x.aqpb090tabla in ('AQPB002', 'JAQZ698');
  
    if lx_cont > 0 then
    
      pn_flag := 'SI';
    
      /*
            select y.fecha_reprogramacion
              into pn_fech
              from (select x.fecha_reprogramacion
                      from USRREPBI.REP_TOT_REPRO_2020 x
                     where x.fecha_reprogramacion <= pn_fecha
                       and x.bccta = pn_cta
                       and x.bcoper = pn_ope
                       and x.extorno = 'SI'
                          --and x.tabla_origen in ('JAQA255', 'AQPB002', 'JAQZ698')
                       and x.tabla_origen in ('AQPB002', 'JAQZ698')
                     order by x.fecha_reprogramacion desc) y
             where rownum = 1;
      */
    
      select y.aqpb090fec
        into pn_fech
        from (select x.aqpb090fec
                from aqpb090 x
               where x.aqpb090fec <= pn_fecha
                 and x.aqpb090cta = pn_cta
                 and x.aqpb090oper = pn_ope
                 and x.aqpb090ext = 'SI'
                 and x.aqpb090tabla in ('AQPB002', 'JAQZ698')
               order by x.aqpb090fec desc) y
       where rownum = 1;
    
    else
      pn_flag := 'NO';
      pn_fech := null;
    end if;
  
  end sp_repro_extorno;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener días de atraso de la última cuota pagada
  procedure sp_obtener_atraso_u(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                
                                pn_diat out number) --return number
   is
  
    lx_fpag  date;
    lx_fcdo  date;
    lx_fpago date;
    lx_diff  number;
  
  begin
  
    begin
      -- Obtención de la máxima fecha pagada
      select max(t.ppfpag)
        into lx_fpag
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
         and T.D602CO = 'S'
         and T.D602FC <= pn_fecha
      
      ;
    
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
         and t.ppfpag = lx_fpag;
    
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
         and x.ppfpag = lx_fpag;
    
      lx_diff := lx_fcdo - lx_fpago;
    
      if lx_diff > 0 then
        pn_diat := lx_diff;
      else
        pn_diat := 0;
      end if;
    exception
      when others then
        pn_diat := 0;
      
    end;
  
  end sp_obtener_atraso_u;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nivel de ventas
  procedure sp_obtener_nventas(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pn_fecha in date,
                               
                               pn_ventas   out number,
                               pn_inst_eva out number,
                               pn_inst_sol out number) --return number
   is
  
    lx_inst     number(10);
    lx_inst_sol number(10);
    lx_sum      number(17, 2);
    lx_tci      number(14, 8);
  
    lx_cod number(3);
    lx_mod number(3);
    lx_suc number(3);
    lx_mda number(4);
    lx_pap number(4);
    lx_cta number(9);
    lx_ope number(9);
    lx_sbo number(3);
    lx_top number(3);
  
  begin
  
    begin
    
      begin
        select x.pgcod,
               x.aomod,
               x.aosuc,
               x.aomda,
               x.aopap,
               x.aocta,
               x.aooper,
               x.aosbop,
               x.aotope
          into lx_cod,
               lx_mod,
               lx_suc,
               lx_mda,
               lx_pap,
               lx_cta,
               lx_ope,
               lx_sbo,
               lx_top
          from fsd010 x
         where x.pgcod = pn_cod
           and x.aomod = pn_mod
           and x.aosuc = pn_suc
           and x.aomda = pn_mda
           and x.aopap = pn_pap
           and x.aocta = pn_cta
           and x.aooper = pn_ope
           and x.aosbop = 0
           and x.aomod <> 419
        --x.aotope =;
        ;
      exception
        when others then
          lx_mod := pn_mod;
          --lx_mod := ;
          lx_suc := pn_suc;
          lx_mda := pn_mda;
          lx_pap := pn_pap;
          lx_cta := pn_cta;
          lx_ope := pn_ope;
          lx_sbo := pn_sbo;
          lx_top := pn_top;
        
      end;
    
      lx_sbo := 0; --- instancia de minima suboperacion 20210520
    
      -- Obtener instancia del crédito
      lx_inst_sol := fn_instancia_credito(v_scmod  => lx_mod, --pn_mod,
                                          v_scsuc  => lx_suc, --pn_suc,
                                          v_scmda  => lx_mda, --pn_mda,
                                          v_scpap  => lx_pap, --pn_pap,
                                          v_sccta  => lx_cta, --pn_cta,
                                          v_scoper => lx_ope, --pn_ope,
                                          v_scsbop => lx_sbo, --pn_sbo,
                                          v_sctope => lx_top --pn_top
                                          );
    
      select max(t.sng021eval)
        into lx_inst
        from SNG021 t
       where t.sng021sol = lx_inst_sol; ---eval
    
      select u.sng120tcbi
        into lx_tci
        from sng120 u
       where u.sng120ins = lx_inst_sol
         and u.SNG120TSK = 'EVALUACION';
    
      select sum((case
                   when s.SNG026COD in (573) then
                    s.sng023mto * lx_tci
                   else
                    s.sng023mto
                 end)) * 12
        into lx_sum
        from SNG023 s --, sng120 u
       where --u.sng120ins = lx_inst_sol
       s.SNG026COD IN (73, 573)
      --and u.SNG120TSK = 'EVALUACION'
       and s.sng021eval = lx_inst;
    
    exception
      when others then
        lx_sum      := 0;
        lx_inst     := 0;
        lx_inst_sol := 0;
    end;
  
    pn_ventas   := lx_sum;
    pn_inst_eva := lx_inst;
    pn_inst_sol := lx_inst_sol;
  
  end sp_obtener_nventas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ciiu_codigo4(P_PAIS   in number,
                           P_PETDOC in number,
                           P_PENDOC in char) return varchar2 is
  -- *****************************************************************
  -- Nombre                       : fn_ciiu_codigo4
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  --                              :  2024.08.14 dcastro se modifico variable lc_codciiu por actcod1
  -- *****************************************************************
   lc_codciiu NUMBER; --varchar2(4);
    lv_petipo  varchar2(1);
  Begin
  
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS, P_PETDOC, P_PENDOC);
  
    If lv_petipo = 'F' Then
      Begin
        Select c60.sngc60acte --
          Into lc_codciiu
          From sngc60 c60
         Where c60.sngc60pais = P_PAIS
           And c60.sngc60tdoc = P_PETDOC
           And c60.sngc60ndoc = P_PENDOC
           And c60.sngc60corr = 0;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select e001.expnins --
          Into lc_codciiu
          From fse001 e001
         Where e001.d511pais = P_PAIS
           And e001.d511tdoc = P_PETDOC
           And e001.d511ndoc = P_PENDOC;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    begin
      select f.actcod1--f.actcod2 2024.08.14 se cambio por actcod1
        into lc_codciiu
        from fst750 f
       where f.actcod1 = lc_codciiu;
    exception
      when others then
        lc_codciiu := null;
    end;
  
    Return TRIM(TO_CHAR(lc_codciiu));
  
  end fn_ciiu_codigo4;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_ciiu_codigo4(P_PAIS   in number,
                            P_PETDOC in number,
                            P_PENDOC in char,
                            p_ciuu4  out number,
                            p_ciuu6  out number) is
  -- *****************************************************************
  -- Nombre                       : sp_ciiu_codigo4
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  --                              :  2024.08.14 dcastro se modifico variable p_ciuu4 por p_ciuu6 (actcod1)
  --                                 2024.08.21 dcastro se cambio p_ciuu4 por p_ciuu6 ( ACTCOD1)
  -- *****************************************************************
                           
                             
    lc_codciiu NUMBER; --varchar2(4);
    lv_petipo  varchar2(1);
  Begin
  
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS, P_PETDOC, P_PENDOC);
  
    If lv_petipo = 'F' Then
      Begin
        Select c60.sngc60acte --
          Into lc_codciiu
          From sngc60 c60
         Where c60.sngc60pais = P_PAIS
           And c60.sngc60tdoc = P_PETDOC
           And c60.sngc60ndoc = P_PENDOC
           And c60.sngc60corr = 0;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select e001.expnins --
          Into lc_codciiu
          From fse001 e001
         Where e001.d511pais = P_PAIS
           And e001.d511tdoc = P_PETDOC
           And e001.d511ndoc = P_PENDOC;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    begin
      select f.actcod2, f.actcod1
        into p_ciuu4, p_ciuu6
        from fst750 f
       where f.actcod1 = lc_codciiu;

       p_ciuu4 := p_ciuu6; --2024.08.21 dcastro se cambio p_ciuu4 por p_ciuu6 ( ACTCOD1)
    exception
      when others then
      
        --- 15.01.2021 jrodriguej
        begin
          if lc_codciiu <> 0 then
            p_ciuu4 := 0;
            p_ciuu6 := lc_codciiu;
          end if;
        
        exception
          when others then
            p_ciuu4 := 0;
            p_ciuu6 := 0;
          
        end;
        --- 15.01.2021 jrodriguej
      ---p_ciuu4 := 0;
      ---p_ciuu6 := 0;
      
      p_ciuu4 := p_ciuu6; --2024.08.14 dcastro se cambio p_ciuu4 por p_ciuu6 ( ACTCOD1)
      
    end;
  
    --Return TRIM(TO_CHAR(lc_codciiu));
  
  end sp_ciiu_codigo4;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2) is
  
    lc_user    varchar(5);
    lc_prefijo varchar(10);
    lc_cont    number;
  
  begin
  
    lc_user := substr(pn_user, 1, 5);
  
    case
      when pn_tipo = 1 then
        ---REACTIVA SBS, BCRP Y COFIDE
        lc_prefijo := 'REAC1' || lc_user;
      
      when pn_tipo = 2 then
        ---FAE ACT. DE SALDOS
        lc_prefijo := 'FAE_1' || lc_user;
      
      when pn_tipo = 3 then
        ---FAE CANCELACION Y DESISTIMIENTOS
        lc_prefijo := 'FAE_2' || lc_user;
      
      when pn_tipo = 4 then
        ---FAE PREPAGOS
        lc_prefijo := 'FAE_3' || lc_user;
      
    -- Crecer: Actualización de Saldos
      when pn_tipo = 5 then
        ---CRECER ACT. DE SALDOS
        lc_prefijo := 'CREC1' || lc_user;
      
    end case;
  
    SELECT count(*)
      into lc_cont
      FROM dba_scheduler_jobs x
     where x.owner = 'BANTPROD'
       and x.job_name like lc_prefijo || '%';
  
    if lc_cont > 0 then
      pn_flag := 'S';
    else
      pn_flag := 'N';
    end if;
  
  end sp_verificar_genrep;
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
                 and t.ppmod = pn_mod
                 and t.ppsuc = pn_suc
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 and t.ppsbop = pn_sbo
                 and t.pptope = pn_top
                 and t.pp1stat in ('P', 'T')
                    
                    --and (t.d602mo, t.d602tr) not in  --- jrodriguej 12.08.2021
                    --    (select x.tp1nro1, x.tp1nro2
                    --       from fst198 x
                    --      where x.TP1COD = 1
                    --        and x.TP1COD1 = 11144
                    --        and x.TP1CORR1 = 1
                    --        and x.tp1corr2 = 2
                    --        and x.tp1corr3 > 0)                 
                    
                 and t.d602fc <= pn_fecha
                 and t.d602co = 'S'
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
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.ppfpag <= lc_ppfpag
           and t.pp1nump <= lc_pp1nump
           and t.pp1stat in ('P', 'T')
              
              --and (t.d602mo, t.d602tr) not in  --- jrodriguej 12.08.2021
              --    (select x.tp1nro1, x.tp1nro2
              --       from fst198 x
              --      where x.TP1COD = 1
              --        and x.TP1COD1 = 11144
              --        and x.TP1CORR1 = 1
              --        and x.tp1corr2 = 2
              --        and x.tp1corr3 > 0)           
              
           and t.d602co = 'S';
      
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
           and x.pp1nump <= lc_pp1nump
              
              --and (t.d602mo, t.d602tr) not in     --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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
           and x.pp003nump <= lc_pp1nump
              
              --and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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
        ---REACTIVA
        pn_flag := 'S';
      
        select x.aqpb065aest
          into pn_est
          from aqpb065a x
         where x.aqpb065acod = pn_pgcod
           and x.aqpb065afec = pn_fecha
           and x.aqpb065acor = pn_corr;
      
        --Actualización de la cabecera principal
        if pn_est = 'G' then
        
          update aqpb065a t
             set --t.aqpb065aest = pn_estado,
                 t.aqpb065ausd = pn_usuario,
                 t.aqpb065afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb065ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb065acod = pn_pgcod
             and t.aqpb065afec = pn_fecha
             and t.aqpb065acor = pn_corr;
          commit;
        
        else
        
          update aqpb065a t
             set t.aqpb065aest = pn_estado,
                 t.aqpb065ausd = pn_usuario,
                 t.aqpb065afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb065ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb065acod = pn_pgcod
             and t.aqpb065afec = pn_fecha
             and t.aqpb065acor = pn_corr;
          commit;
        end if;
      
      when pn_tiporep = 2 then
        ---FAE
      
        pn_flag := 'S';
      
        select x.aqpb067aest
          into pn_est
          from aqpb067a x
         where x.aqpb067acod = pn_pgcod
           and x.aqpb067afec = pn_fecha
           and x.aqpb067acor = pn_corr;
      
        --Actualización de la cabecera principal
        if pn_est = 'G' then
        
          update aqpb067a t
             set --t.aqpb065aest = pn_estado,
                 t.aqpb067ausd = pn_usuario,
                 t.aqpb067afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb067ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb067acod = pn_pgcod
             and t.aqpb067afec = pn_fecha
             and t.aqpb067acor = pn_corr;
          commit;
        
        else
        
          update aqpb067a t
             set t.aqpb067aest = pn_estado,
                 t.aqpb067ausd = pn_usuario,
                 t.aqpb067afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb067ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb067acod = pn_pgcod
             and t.aqpb067afec = pn_fecha
             and t.aqpb067acor = pn_corr;
        
          commit;
        end if;
      
      when pn_tiporep = 3 then
        ---CRECER
      
        pn_flag := 'S';
      
        select x.aqpb073aest
          into pn_est
          from aqpb073a x
         where x.aqpb073acod = pn_pgcod
           and x.aqpb073afec = pn_fecha
           and x.aqpb073acor = pn_corr;
      
        --Actualización de la cabecera principal
        if pn_est = 'G' then
        
          update aqpb073a t
             set --t.aqpb065aest = pn_estado,
                 t.aqpb073ausd = pn_usuario,
                 t.aqpb073afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb073ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb073acod = pn_pgcod
             and t.aqpb073afec = pn_fecha
             and t.aqpb073acor = pn_corr;
          commit;
        
        else
        
          update aqpb073a t
             set t.aqpb073aest = pn_estado,
                 t.aqpb073ausd = pn_usuario,
                 t.aqpb073afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb073ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb073acod = pn_pgcod
             and t.aqpb073afec = pn_fecha
             and t.aqpb073acor = pn_corr;
        
          commit;
        end if;
      
        commit;
      
    end case;
  
  end sp_anulacion_individual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_iniciales(pn_cod     in number,
                                 pn_mod     in number,
                                 pn_suc     in number,
                                 pn_mda     in number,
                                 pn_pap     in number,
                                 pn_cta     in number,
                                 pn_ope     in number,
                                 pn_sbo     in number,
                                 pn_top     in number,
                                 pn_fde_ini out date,
                                 pn_mon_ini out number,
                                 pn_cuo_ini out number) is
  
    --lx_fdes date;
  
  begin
  
    begin
    
      SELECT
      
       t.aofval, t.aoimp
        into pn_fde_ini, pn_mon_ini
        FROM fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
            --and t.aosuc = pn_suc --  jrodriguej 28.06.2021
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
         and t.aosbop = 0
      --and t.aotope = pn_top
      ;
    
      select count(*)
        into pn_cuo_ini
        from fsd601 x
       where x.pgcod = pn_cod
         and x.ppmod = pn_mod
            -- and x.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and x.ppmda = pn_mda
         and x.pppap = pn_pap
         and x.ppcta = pn_cta
         and x.ppoper = pn_ope
         and x.ppsbop = 0
      --and x.pptope = pn_top
      ;
    
    exception
      when others then
        ---lx_fdes := null;
      
        begin
        
          SELECT t.aofval, t.aoimp
            into pn_fde_ini, pn_mon_ini
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
        
          select count(*)
            into pn_cuo_ini
            from fsd601 x
           where x.pgcod = pn_cod
             and x.ppmod = pn_mod
             and x.ppsuc = pn_suc
             and x.ppmda = pn_mda
             and x.pppap = pn_pap
             and x.ppcta = pn_cta
             and x.ppoper = pn_ope
             and x.ppsbop = pn_sbo
             and x.pptope = pn_top;
        
        exception
          when others then
            pn_fde_ini := null;
            pn_mon_ini := 0;
            pn_cuo_ini := 0;
        end;
      
    end;
  
  end sp_obtener_iniciales;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldo_cap_cancel(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_saldo out number, --- capital cancelado en la última transacción
                                pn_upago out number) is
    --- monto total cancelado en la última transacción
  
    lx_fecha date;
  
    lc_d602cd number(3);
    lc_d602mo number(3);
    lc_d602su number(3);
    lc_d602tr number(3);
    lc_d602re number(4);
    lc_d602fc date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    begin
      select j.d602cd, j.d602mo, j.d602su, j.d602tr, j.d602re, j.d602fc
        into lc_d602cd,
             lc_d602mo,
             lc_d602su,
             lc_d602tr,
             lc_d602re,
             lc_d602fc
        from (select distinct x.d602cd,
                              x.d602mo,
                              x.d602su,
                              x.d602tr,
                              x.d602re,
                              x.d602fc
                from fsd602 x
               where x.pgcod = pn_cod
                 and x.ppmod = pn_mod
                 and x.ppsuc = pn_suc
                 and x.ppmda = pn_mda
                 and x.pppap = pn_pap
                 and x.ppcta = pn_cta
                 and x.ppoper = pn_ope
                 and x.ppsbop = pn_sbo
                 and x.pptope = pn_top
                 and x.d602fc <= pn_fecha
                 and x.d602co = 'S'
               order by x.d602fc desc) j
       where rownum = 1;
    exception
      when others then
        lc_d602cd := 0;
        lc_d602mo := 0;
        lc_d602su := 0;
        lc_d602tr := 0;
        lc_d602re := 0;
        lc_d602fc := null;
    end;
  
    if lc_d602cd <> 0 then
      begin
      
        select nvl(sum(x.pp1cap), 0)
          into pn_saldo
          from fsd602 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and
              
               x.d602cd = lc_d602cd
           and x.d602mo = lc_d602mo
           and x.d602su = lc_d602su
           and x.d602tr = lc_d602tr
           and x.d602re = lc_d602re
           and x.d602fc = lc_d602fc
           and x.d602co = 'S'
           and x.pp1int = 0;
      
        if pn_saldo = 0 then
          begin
          
            select nvl(sum(x.pp1cap), 0)
              into pn_saldo
              from fsd602 x
             where x.pgcod = pn_cod
               and x.ppmod = pn_mod
               and x.ppsuc = pn_suc
               and x.ppmda = pn_mda
               and x.pppap = pn_pap
               and x.ppcta = pn_cta
               and x.ppoper = pn_ope
               and x.ppsbop = pn_sbo
               and x.pptope = pn_top
               and
                  
                   x.d602cd = lc_d602cd
               and x.d602mo = lc_d602mo
               and x.d602su = lc_d602su
               and x.d602tr = lc_d602tr
               and x.d602re = lc_d602re
               and x.d602fc = lc_d602fc
               and x.d602co = 'S';
          exception
            when others then
              pn_saldo := 0;
          end;
        
        end if;
      
      end;
    
      -- Obtener último pago total
      if lx_fecha <> lc_d602fc then
        begin
          ---si es la actual que busque en la fsd016
          ---compara con la fecha del sistema
          select nvl(sum(t.hcimp1), 0)
            into pn_upago
            from fsh016 t, fsh015 x
           where t.pgcod = x.pgcod
             and t.hcmod = x.hcmod
             and t.hsucor = x.hsucor
             and t.htran = x.htran
             and t.hnrel = x.hnrel
             and t.hfcon = x.hfcon
                
             and t.pgcod = lc_d602cd
             and t.hcmod = lc_d602mo
             and t.hsucor = lc_d602su
             and t.htran = lc_d602tr
             and t.hnrel = lc_d602re
             and t.hfcon = lc_d602fc
             and t.hcord = 83
             and substr(to_char(t.hrubro), 1, 2) not in ('42')
             and x.hccorr = 0;
        exception
          when others then
            pn_upago := 0;
        end;
      else
        begin
        
          select t.itimp1
            into pn_upago
            from fsd016 t, fsd015 x
           where t.pgcod = x.pgcod
             and t.itsuc = x.itsuc
             and t.itmod = x.itmod
             and t.ittran = x.ittran
             and t.itnrel = x.itnrel
                
             and t.pgcod = lc_d602cd
             and t.itmod = lc_d602mo
             and t.itsuc = lc_d602su
             and t.ittran = lc_d602tr
             and t.itnrel = lc_d602re
             and t.itord = 83
             and x.itcont = 'S'
             and substr(to_char(t.rubro), 1, 2) not in ('42')
             and x.itcorr = 0; ---83
        
        exception
          when others then
            pn_upago := 0;
        end;
      end if;
    
    else
    
      pn_saldo := 0;
      pn_upago := 0;
    
    end if;
  
  end sp_saldo_cap_cancel;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_distribuc_pago_tot(pn_cod   in number,
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
    -- Considera los pagos acumulados desde el crédito original hasta el crédito vigente
    -- con respecto a la fecha de corte
  
    lc_cont number(3);
  
  begin
    -- clave
  
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
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    exception
      when others then
        lc_cont := 0;
    end;
  
    if lc_cont > 0 then
    
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
        
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
           and t.d602fc <= pn_fecha
           and t.d602co = 'S';
      
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
           and t.d602fc <= pn_fecha
           and t.d602co = 'S'
        
        ;
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
           and t.d602fc <= pn_fecha
           and t.d602co = 'S'
        
        ;
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
  
  end sp_distribuc_pago_tot;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Número de cuotas pendientes de pago
  procedure sp_fecha_ncuo_pagtotal(pn_cod      in number,
                                   pn_mod      in number,
                                   pn_suc      in number,
                                   pn_mda      in number,
                                   pn_pap      in number,
                                   pn_cta      in number,
                                   pn_ope      in number,
                                   pn_sbo      in number,
                                   pn_top      in number,
                                   pn_fecha    in date,
                                   pn_ncuo_pag out number)
  ---- Número de cuotas pagadas considerando crédito original al vigente
   is
  
    lc_conta number(3);
    lc_sbop  number(3);
  
  begin
  
    -- Verificar si el tipo de operación es 550
    /*
    lc_conta := 0;
    if pn_top = 550 then
      lc_conta := 1
      
      select 
           max(t.aosbop) into lc_sbop 
      from 
           fsd010 t
      where
      t.pgcod = pn_cod and
             t.aomod = pn_mod and
             t.aomod in (select modulo
                       from fst111
                      where dscod = 50
                        and modulo not in (29, 120, 144))
             t.aosuc = pn_suc and
             t.aomda = pn_mda and
             t.aopap = pn_pap and
             t.aocta = pn_cta and
             t.aooper = pn_ope and
             t.aosbop = pn_sbo and
             t.aotope = pn_top and
             t.aotope <> 550
      ;
      
    end if;
    */
    begin
    
      select count(*)
        into pn_ncuo_pag
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
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
         and t.pp1stat in ('T') ---- P: PARCIAL, T: TOTAL, solo considerar pagos totales  01.02.2021 jrodriguej
         and (t.d602mo, t.d602tr) not in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 2
                 and x.tp1corr3 > 0)
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    exception
      when others then
        pn_ncuo_pag := 0;
    end;
  
  end sp_fecha_ncuo_pagtotal;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_saldo_actual(pn_cod     in number,
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
  
    lx_imp   number(17, 2);
    lx_cd    number(3);
    lx_mo    number(3);
    lx_su    number(3);
    lx_tr    number(3);
    lx_re    number(4);
    lx_fc    date;
    lx_imp1  number(17, 2);
    lx_sdoi  number(17, 2);
    lx_saldo number(17, 2);
    lx_fecha date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    if lx_fecha <> pn_fecha then
    
      begin
      
        --select distinct (t.aqpb070asdmn * -1)
        select (sum(t.aqpb070asdmn)) * -1
          into lx_saldo
          from aqpb070a t
         where t.aqpb070ausur = pn_usuario
           and t.aqpb070aemp = pn_cod
           and t.aqpb070amod = pn_mod
              --and t.aqpb070asuc = pn_suc --  jrodriguej 28.06.2021
           and t.aqpb070amda = pn_mda
           and t.aqpb070apap = pn_pap
           and t.aqpb070acta = pn_cta
           and t.aqpb070aoper = pn_ope
              --and t.aqpb070asbop = pn_sbo
              -- and t.aqpb070atop = pn_top  25092021 dcastro VERIFICAR
           and t.aqpb070afech = pn_fecha;
      
        /*
        select (t.bcsdmn * -1)
          into lx_saldo
          from fsh012 t
         where t.bcemp = pn_cod
           and t.bcmod = pn_mod
           and t.bcsuc = pn_suc
           and t.bcmda = pn_mda
           and t.bcpap = pn_pap
           and t.bccta = pn_cta
           and t.bcoper = pn_ope
              --and t.bcsbop = pn_sbo
           and t.bctop = pn_top
           and t.bcfech = pn_fecha;
         */
      exception
        when others then
          lx_saldo := 0;
      end;
    
    else
      begin
        --select distinct (t.scsdo * -1)
        select sum(t.scsdo) * -1
          into lx_saldo
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
          lx_saldo := 0;
      end;
    
    end if;
  
    lx_sdoi := lx_saldo;
  
    if lx_sdoi < 0 or lx_sdoi is null then
      lx_sdoi := 0;
    end if;
  
    return lx_sdoi;
  
  end fn_obtener_saldo_actual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
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
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out number,
                                    pn_nconc out AQPB067.AQPB067NCRE%type) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fondos_p3.fn_fecha_upago(pn_cod   => pn_cod,
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
    if pn_ufech is not null then
      lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if lx_fecha <> pn_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, pn_nconc
          
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
                        -- and t.aqpb070asuc = pn_suc --  jrodriguej 28.06.2021
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
                 and f.HAANIO = lx_anio;
            
            exception
              when others then
              
                pn_ntipo := 0;
                pn_nconc := null;
              
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
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
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
                 and f.HAANIO = lx_anio;
            
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
  
    ---pn_nconc := lx_conce;
  
  end sp_tipo_credito_sbs_vig;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*
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
                                    --pn_ufech in date,
                                    pn_usuario in char,
  
                                    pn_ntipo out number,
                                    pn_nconc out AQPB067.AQPB067NCRE%type) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fondos.fn_fecha_upago(pn_cod   => pn_cod,
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
    if pn_ufech is not null then
      lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
  
      if lx_fecha <> pn_fecha then
  
        begin
          -- 1ro. Buscar con la fecha de corte
  
          select g.tipo, g.nconcepto
            into pn_ntipo, pn_nconc
  
            from (select t.BCGpo tipo,
                         case
                           when t.BCGpo = 2 then
                            'MICROEMPRESAS'
                           when t.BCGpo = 3 and
                                substr(t.bcrubr, 11, 3) = '015' then
                            'CONSUMO REVOLVENTE'
                           when t.BCGpo = 3 and
                                substr(t.bcrubr, 11, 3) <> '015' then
                            'CONSUMO NO REVOLVENTE'
                           when t.BCGpo = 4 then
                            'HIPOTECARIO'
                           when t.BCGpo = 12 then
                            'MEDIANA EMPRESA'
                           when t.BCGpo = 13 then
                            'PEQUEÑA EMPRESA'
                           when t.BCGpo = 11 then
                            'GRANDES EMPRESAS'
                           when t.BCGpo in (5, 6, 7, 8, 9, 10) then
                            'CORPORATIVO'
                           else
                            ' '
                         END nconcepto
  
                    from fsh012 t --- fsd011
                   where t.bcemp = pn_cod
                     and t.bcmod = pn_mod
                     and t.bcsuc = pn_suc
                     and t.bcmda = pn_mda
                     and t.bcpap = pn_pap
                     and t.bccta = pn_cta
                     and t.bcoper = pn_ope
                        --and t.bcsbop = pn_sbo
                     and t.bctop = pn_top
                     and t.bcfech = pn_fecha
                  ---order by t.bcfech desc
  
                  ) g
           where rownum = 1;
  
        exception
          when others then
  
            begin
              -- 2do. Buscar con la fecha de pago
  
  
              select g.tipo, g.nconcepto
                into pn_ntipo, pn_nconc
  
                from (select t.BCGpo tipo,
                             case
                               when t.BCGpo = 2 then
                                'MICROEMPRESAS'
                               when t.BCGpo = 3 and
                                    substr(t.bcrubr, 11, 3) = '015' then
                                'CONSUMO REVOLVENTE'
                               when t.BCGpo = 3 and
                                    substr(t.bcrubr, 11, 3) <> '015' then
                                'CONSUMO NO REVOLVENTE'
                               when t.BCGpo = 4 then
                                'HIPOTECARIO'
                               when t.BCGpo = 12 then
                                'MEDIANA EMPRESA'
                               when t.BCGpo = 13 then
                                'PEQUEÑA EMPRESA'
                               when t.BCGpo = 11 then
                                'GRANDES EMPRESAS'
                               when t.BCGpo in (5, 6, 7, 8, 9, 10) then
                                'CORPORATIVO'
                               else
                                ' '
                             END nconcepto
  
                        from fsh012 t --- fsd011
                       where t.bcemp = pn_cod
                         and t.bcmod = pn_mod
                         and t.bcsuc = pn_suc
                         and t.bcmda = pn_mda
                         and t.bcpap = pn_pap
                         and t.bccta = pn_cta
                         and t.bcoper = pn_ope
                            --and t.bcsbop = pn_sbo
                         and t.bctop = pn_top
                         and t.bcfech = pn_ufech
                      ---order by t.bcfech desc
                      ) g
               where rownum = 1;
  
            exception
              when others then
  
                begin
  
                  -- 3ro. Buscar con la fecha del último fin de mes anterior a la fecha de pago
                  select g.tipo, g.nconcepto
                    into pn_ntipo, pn_nconc
  
                    from (select t.BCGpo tipo,
                                 case
                                   when t.BCGpo = 2 then
                                    'MICROEMPRESAS'
                                   when t.BCGpo = 3 and
                                        substr(t.bcrubr, 11, 3) = '015' then
                                    'CONSUMO REVOLVENTE'
                                   when t.BCGpo = 3 and
                                        substr(t.bcrubr, 11, 3) <> '015' then
                                    'CONSUMO NO REVOLVENTE'
                                   when t.BCGpo = 4 then
                                    'HIPOTECARIO'
                                   when t.BCGpo = 12 then
                                    'MEDIANA EMPRESA'
                                   when t.BCGpo = 13 then
                                    'PEQUEÑA EMPRESA'
                                   when t.BCGpo = 11 then
                                    'GRANDES EMPRESAS'
                                   when t.BCGpo in (5, 6, 7, 8, 9, 10) then
                                    'CORPORATIVO'
                                   else
                                    ' '
                                 END nconcepto
  
                            from fsh012 t --- fsd011
                           where t.bcemp = pn_cod
                             and t.bcmod = pn_mod
                             and t.bcsuc = pn_suc
                             and t.bcmda = pn_mda
                             and t.bcpap = pn_pap
                             and t.bccta = pn_cta
                             and t.bcoper = pn_ope
                                --and t.bcsbop = pn_sbo
                             and t.bctop = pn_top
                             and t.bcfech = lx_fecha_ant
                          ---order by t.bcfech desc
                          ) g
                   where rownum = 1;
  
  
                exception
                  when others then
  
                    --- 4to. Buscar en XWF700
                    begin
  
                      -- Call the procedure
                      pq_cr_reporte_fondos.sp_tipo_credito_sbs_700(pn_cod  => pn_cod,
                                                                   pn_mod  => pn_mod,
                                                                   pn_suc  => pn_suc,
                                                                   pn_mda  => pn_mda,
                                                                   pn_pap  => pn_pap,
                                                                   pn_cta  => pn_cta,
                                                                   pn_ope  => pn_ope,
                                                                   pn_sbo  => pn_sbo,
                                                                   pn_top  => pn_top,
                                                                   pc_pcre => pn_ntipo,
                                                                   pc_ncre => pn_nconc);
  
                    exception
                      when others then
                        pn_ntipo := 0;
                        pn_nconc := null;
                    end;
  
                end;
  
            end;
  
        end;
  
      else
        begin
          -- 1ro. Buscar en la tabla fsd011
          select t.scgru,
                 case
                   when t.scgru = 2 then
                    'MICROEMPRESAS'
                   when t.scgru = 3 and substr(t.scrub, 11, 3) = '015' then
                    'CONSUMO REVOLVENTE'
                   when t.scgru = 3 and substr(t.scrub, 11, 3) <> '015' then
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
             and t.scsuc = pn_suc
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
              -- 2do. Buscar con la fecha de corte
  
              select g.tipo, g.nconcepto
                into pn_ntipo, pn_nconc
  
                from (select t.BCGpo tipo,
                             case
                               when t.BCGpo = 2 then
                                'MICROEMPRESAS'
                               when t.BCGpo = 3 and
                                    substr(t.bcrubr, 11, 3) = '015' then
                                'CONSUMO REVOLVENTE'
                               when t.BCGpo = 3 and
                                    substr(t.bcrubr, 11, 3) <> '015' then
                                'CONSUMO NO REVOLVENTE'
                               when t.BCGpo = 4 then
                                'HIPOTECARIO'
                               when t.BCGpo = 12 then
                                'MEDIANA EMPRESA'
                               when t.BCGpo = 13 then
                                'PEQUEÑA EMPRESA'
                               when t.BCGpo = 11 then
                                'GRANDES EMPRESAS'
                               when t.BCGpo in (5, 6, 7, 8, 9, 10) then
                                'CORPORATIVO'
                               else
                                ' '
                             END nconcepto
  
                        from fsh012 t --- fsd011
                       where t.bcemp = pn_cod
                         and t.bcmod = pn_mod
                         and t.bcsuc = pn_suc
                         and t.bcmda = pn_mda
                         and t.bcpap = pn_pap
                         and t.bccta = pn_cta
                         and t.bcoper = pn_ope
                            --and t.bcsbop = pn_sbo
                         and t.bctop = pn_top
                         and t.bcfech = pn_ufech
                      ---order by t.bcfech desc
                      ) g
               where rownum = 1;
  
            exception
              when others then
  
  
                begin
                  -- 3ro. Buscar con la fecha del último fin de mes anterior a la fecha de pago
                  select g.tipo, g.nconcepto
                    into pn_ntipo, pn_nconc
  
                    from (select t.BCGpo tipo,
                                 case
                                   when t.BCGpo = 2 then
                                    'MICROEMPRESAS'
                                   when t.BCGpo = 3 and
                                        substr(t.bcrubr, 11, 3) = '015' then
                                    'CONSUMO REVOLVENTE'
                                   when t.BCGpo = 3 and
                                        substr(t.bcrubr, 11, 3) <> '015' then
                                    'CONSUMO NO REVOLVENTE'
                                   when t.BCGpo = 4 then
                                    'HIPOTECARIO'
                                   when t.BCGpo = 12 then
                                    'MEDIANA EMPRESA'
                                   when t.BCGpo = 13 then
                                    'PEQUEÑA EMPRESA'
                                   when t.BCGpo = 11 then
                                    'GRANDES EMPRESAS'
                                   when t.BCGpo in (5, 6, 7, 8, 9, 10) then
                                    'CORPORATIVO'
                                   else
                                    ' '
                                 END nconcepto
  
                            from fsh012 t --- fsd011
                           where t.bcemp = pn_cod
                             and t.bcmod = pn_mod
                             and t.bcsuc = pn_suc
                             and t.bcmda = pn_mda
                             and t.bcpap = pn_pap
                             and t.bccta = pn_cta
                             and t.bcoper = pn_ope
                                --and t.bcsbop = pn_sbo
                             and t.bctop = pn_top
                             and t.bcfech = lx_fecha_ant
                          ---order by t.bcfech desc
                          ) g
                   where rownum = 1;
  
                exception
                  when others then
  
                    --- 4to. Buscar en XWF700
                    begin
  
                      -- Call the procedure
                      pq_cr_reporte_fondos.sp_tipo_credito_sbs_700(pn_cod  => pn_cod,
                                                                   pn_mod  => pn_mod,
                                                                   pn_suc  => pn_suc,
                                                                   pn_mda  => pn_mda,
                                                                   pn_pap  => pn_pap,
                                                                   pn_cta  => pn_cta,
                                                                   pn_ope  => pn_ope,
                                                                   pn_sbo  => pn_sbo,
                                                                   pn_top  => pn_top,
                                                                   pc_pcre => pn_ntipo,
                                                                   pc_ncre => pn_nconc);
  
                    exception
                      when others then
                        pn_ntipo := 0;
                        pn_nconc := null;
                    end;
  
                end;
  
            end;
  
        end;
  
      end if;
  
    exception
      when others then
        pn_ntipo := 0;
        pn_nconc := null;
  
    end;
  
    ---pn_nconc := lx_conce;
  
  end sp_tipo_credito_sbs_vig;
  */
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_700(pn_cod  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    pc_pcre out number,
                                    pc_ncre out char) is
  
    lc_inst number(10);
    lc_fcre char(1);
    lc_ocre number;
  
  begin
  
    begin
      select nvl(x.xwfprcins, 0)
        into lc_inst
        from xwf700 x
       where x.xwfempresa = pn_cod
         and x.xwfmodulo = pn_mod
         and x.xwfsucursal = pn_suc
         and x.xwfmoneda = pn_mda
         and x.xwfpapel = pn_pap
         and x.xwfcuenta = pn_cta
         and x.xwfoperacion = pn_ope
         and x.xwfsubope = pn_sbo
         and x.xwftipope = pn_top
         and x.xwfcar3 = '1';
    exception
      when others then
        lc_inst := 0;
    end;
  
    lc_ocre := 1;
    lc_fcre := 'x';
  
    while lc_fcre <> ';' loop
    
      lc_ocre := lc_ocre + 1;
    
      begin
        select substr(xx.wfattsval, lc_ocre, 1)
          into lc_fcre
          from wfattsvalues xx
         where
        --xx.wfinsprcid = j.xwfprcins and
         xx.wfinsprcid = lc_inst
         and trim(xx.wfattsid) = 'TIPO_CREDITO';
      exception
        when others then
          lc_ocre := 99;
          lc_fcre := ';';
      end;
    
    end loop;
  
    if lc_ocre <> 99 then
    
      begin
        select to_number(substr(xx.wfattsval, 1, (lc_ocre - 1))),
               trim(substr(xx.wfattsval,
                           (lc_ocre + 1),
                           (length(xx.wfattsval) - (lc_ocre + 1))))
          into pc_pcre, pc_ncre
          from wfattsvalues xx
         where
        --xx.wfinsprcid = j.xwfprcins and
         xx.wfinsprcid = lc_inst
         and trim(xx.wfattsid) = 'TIPO_CREDITO';
      
      exception
        when others then
          pc_pcre := 0;
          pc_ncre := '';
      end;
    
    end if;
  
  end sp_tipo_credito_sbs_700;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_actual(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tasa  out number) is
  
  begin
  
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
         and f1.evtipo = 3
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
                              and f2.d012co = 'S'
                              and f2.evfval < pn_fecha);
    
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
  
  end sp_obtener_tasa_actual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_registro_FSH012(pn_fecha in date,
                               pn_tabla in char, --- capital cancelado en la última transacción
                               pn_tipo  in number) is
    --- monto total cancelado en la última transacción
  
    lx_fecha date;
  
    lc_d602cd number(3);
    lc_d602mo number(3);
    lc_d602su number(3);
    lc_d602tr number(3);
    lc_d602re number(4);
    lc_d602fc date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
  end sp_registro_FSH012;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldo_cap_cancel_Fae(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_saldo out number, --- capital cancelado en la última transacción
                                    pn_upago out number) is
    --- monto total cancelado en la última transacción
  
    lx_fecha date;
  
    lc_d602cd number(3);
    lc_d602mo number(3);
    lc_d602su number(3);
    lc_d602tr number(3);
    lc_d602re number(4);
    lc_d602fc date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    begin
      select j.d602cd, j.d602mo, j.d602su, j.d602tr, j.d602re, j.d602fc
        into lc_d602cd,
             lc_d602mo,
             lc_d602su,
             lc_d602tr,
             lc_d602re,
             lc_d602fc
        from (select distinct x.d602cd,
                              x.d602mo,
                              x.d602su,
                              x.d602tr,
                              x.d602re,
                              x.d602fc
                from fsd602 x
               where x.pgcod = pn_cod
                 and x.ppmod = pn_mod
                 and x.ppsuc = pn_suc
                 and x.ppmda = pn_mda
                 and x.pppap = pn_pap
                 and x.ppcta = pn_cta
                 and x.ppoper = pn_ope
                 and x.ppsbop = pn_sbo
                 and x.pptope = pn_top
                 and x.d602fc <= pn_fecha
                 and x.d602co = 'S'
               order by x.d602fc desc) j
       where rownum = 1;
    exception
      when others then
        lc_d602cd := 0;
        lc_d602mo := 0;
        lc_d602su := 0;
        lc_d602tr := 0;
        lc_d602re := 0;
        lc_d602fc := null;
    end;
  
    --- segunda parte
    if lc_d602cd <> 0 then
      begin
      
        select nvl(sum(x.pp1cap), 0)
          into pn_saldo
          from fsd602 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           and x.ppsbop = pn_sbo
           and x.pptope = pn_top
              
           and x.d602cd = lc_d602cd
           and x.d602mo = lc_d602mo
           and x.d602su = lc_d602su
           and x.d602tr = lc_d602tr
           and x.d602re = lc_d602re
           and x.d602fc = lc_d602fc
           and x.d602co = 'S'
              
           and x.pp1nump not in (
                                 
                                 select min(f.pp1nump)
                                   from fsd602 f
                                  where f.pgcod = x.pgcod
                                    and f.ppmod = x.ppmod
                                    and f.ppsuc = x.ppsuc
                                    and f.ppmda = x.ppmda
                                    and f.pppap = x.pppap
                                    and f.ppcta = x.ppcta
                                    and f.ppoper = x.ppoper
                                    and f.ppsbop = x.ppsbop
                                    and f.pptope = x.pptope
                                    and f.d602cd = x.d602cd
                                    and f.d602mo = x.d602mo
                                    and f.d602su = x.d602su
                                    and f.d602tr = x.d602tr
                                    and f.d602re = x.d602re
                                    and f.d602fc = x.d602fc
                                    and f.d602co = 'S');
      
        if pn_saldo = 0 then
          begin
          
            select nvl(sum(x.pp1cap), 0)
              into pn_saldo
              from fsd602 x
             where x.pgcod = pn_cod
               and x.ppmod = pn_mod
               and x.ppsuc = pn_suc
               and x.ppmda = pn_mda
               and x.pppap = pn_pap
               and x.ppcta = pn_cta
               and x.ppoper = pn_ope
               and x.ppsbop = pn_sbo
               and x.pptope = pn_top
               and
                  
                   x.d602cd = lc_d602cd
               and x.d602mo = lc_d602mo
               and x.d602su = lc_d602su
               and x.d602tr = lc_d602tr
               and x.d602re = lc_d602re
               and x.d602fc = lc_d602fc
               and x.d602co = 'S';
          exception
            when others then
              pn_saldo := 0;
          end;
        
        end if;
      
      end;
    
      -- Obtener último pago total
      if lx_fecha <> lc_d602fc then
        begin
          ---si es la actual que busque en la fsd016
          ---compara con la fecha del sistema
          select nvl(sum(t.hcimp1), 0)
            into pn_upago
            from fsh016 t, fsh015 x
           where t.pgcod = x.pgcod
             and t.hcmod = x.hcmod
             and t.hsucor = x.hsucor
             and t.htran = x.htran
             and t.hnrel = x.hnrel
             and t.hfcon = x.hfcon
                
             and t.pgcod = lc_d602cd
             and t.hcmod = lc_d602mo
             and t.hsucor = lc_d602su
             and t.htran = lc_d602tr
             and t.hnrel = lc_d602re
             and t.hfcon = lc_d602fc
             and t.hcord = 83
             and substr(to_char(t.hrubro), 1, 2) not in ('42')
             and x.hccorr = 0;
        exception
          when others then
            pn_upago := 0;
        end;
      else
        begin
        
          select t.itimp1
            into pn_upago
            from fsd016 t, fsd015 x
           where t.pgcod = x.pgcod
             and t.itsuc = x.itsuc
             and t.itmod = x.itmod
             and t.ittran = x.ittran
             and t.itnrel = x.itnrel
                
             and t.pgcod = lc_d602cd
             and t.itmod = lc_d602mo
             and t.itsuc = lc_d602su
             and t.ittran = lc_d602tr
             and t.itnrel = lc_d602re
             and t.itord = 83
             and x.itcont = 'S'
             and substr(to_char(t.rubro), 1, 2) not in ('42')
             and x.itcorr = 0; ---83
        
        exception
          when others then
            pn_upago := 0;
        end;
      end if;
    
    else
    
      pn_saldo := 0;
      pn_upago := 0;
    
    end if;
  
  end sp_saldo_cap_cancel_Fae;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_sald_insoluto(pn_cod   in number,
                                     pn_mod   in number,
                                     pn_suc   in number,
                                     pn_mda   in number,
                                     pn_pap   in number,
                                     pn_cta   in number,
                                     pn_ope   in number,
                                     pn_sbo   in number,
                                     pn_top   in number,
                                     pn_fecha in date,
                                     pn_sald  out number) -- saldo insoluto
   is
    -- Saldo insoluto = monto_cofide - sumatorio de pagos
  
    lx_mcof number(10, 2);
    lx_scap number(17, 2);
    lx_fdes date;
  
  begin
    -- a) monto COFIDE
    begin
    
      select x.aqpb067bmon, x.aqpb067bfdes
        into lx_mcof, lx_fdes
        from aqpb067b x
       where x.aqpb067bcod = pn_cod
         and x.aqpb067bmod = pn_mod
            --and x.aqpb067bsuc = pn_suc --  jrodriguej 28.06.2021
         and x.aqpb067bmda = pn_mda
         and x.aqpb067bpap = pn_pap
         and x.aqpb067bcta = pn_cta
         and x.aqpb067bope = pn_ope
            --and x.aqpb067bsbo = pn_sbo --  jrodriguej 28.06.2021
            --and x.aqpb067btop = pn_top --  jrodriguej 28.06.2021
         and x.aqpb067best <> 'D';
    
    exception
      when too_many_rows then
      
        select f.aqpb067bmon, f.aqpb067bfdes
          into lx_mcof, lx_fdes
          from (select x.aqpb067bmon, x.aqpb067bfdes
                  from aqpb067b x
                 where x.aqpb067bcod = pn_cod
                   and x.aqpb067bmod = pn_mod
                      -- and x.aqpb067bsuc = pn_suc --  jrodriguej 28.06.2021
                   and x.aqpb067bmda = pn_mda
                   and x.aqpb067bpap = pn_pap
                   and x.aqpb067bcta = pn_cta
                   and x.aqpb067bope = pn_ope
                      -- and x.aqpb067bsbo = pn_sbo --  jrodriguej 28.06.2021
                      -- and x.aqpb067btop = pn_top --  jrodriguej 28.06.2021
                   and x.aqpb067best <> 'D'
                 order by x.aqpb067bfec desc) f
         where rownum = 1;
      
      when others then
      
        lx_mcof := 0;
        lx_fdes := null;
      
    end;
  
    --- b) Sumatoria de pagos
    --- Capital
    if lx_mcof <> 0 and pn_fecha >= lx_fdes then
      begin
      
        select nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
          into lx_scap
        
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
           and t.pptope = pn_top
           and t.pp1stat in ('P', 'T')
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
    else
      lx_scap := 0;
    end if;
  
    --- c) Resultado
    pn_sald := lx_mcof - lx_scap;
  
    if pn_sald < 0 then
      pn_sald := 0;
    end if;
  
  end sp_obtener_sald_insoluto;
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
  
    lx_fpag date;
    lx_fmin date;
    lx_fdia date;
    lx_diff number(5);
    lx_cont number(3);
  
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
  
    -- ================================
    begin
    
      begin
        select count(*)
          into lx_cont
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
           and T.D602CO = 'S'
           and T.D602FC <= pn_fecha;
      exception
        when others then
          lx_cont := 0;
      end;
      -- Obtención de la máxima fecha pagada
      /*
      select max(t.ppfpag)
        into lx_fpag
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
         and T.D602CO = 'S'
         and T.D602FC <= pn_fecha;
      */
      /*
      begin
        select min(t.ppfpag)
          into lx_fmin
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
           and t.ppfpag > lx_fpag
           and t.d601co = 'S';
      exception
        when others then
          lx_fmin := null;
      end;
      */
    
      if lx_cont = 0 then
        --dbms_output.put_line('1: ');
        begin
          select min(t.ppfpag)
            into lx_fmin
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
                ---and t.ppfpag > lx_fpag
             and t.d601co = 'S';
        exception
          when others then
            lx_fmin := null;
        end;
      else
        dbms_output.put_line('2: ');
      
        -- Obtención de la máxima fecha pagada
        begin
          select max(t.ppfpag)
            into lx_fpag
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
             and T.D602CO = 'S'
             and T.D602FC <= pn_fecha;
        exception
          when others then
            lx_fpag := null;
        end;
      
        begin
          select min(t.ppfpag)
            into lx_fmin
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
             and t.ppfpag > lx_fpag
             and t.d601co = 'S';
        exception
          when others then
            lx_fmin := null;
          
        end;
      
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
                                 
                                 pn_calif0a out aqpb067.aqpb067cnoma%type,
                                 pn_calif1a out aqpb067.aqpb067ccppa%type,
                                 pn_calif2a out aqpb067.aqpb067cdefa%type,
                                 pn_calif3a out aqpb067.aqpb067cduda%type,
                                 pn_calif4a out aqpb067.aqpb067cpera%type,
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
    -- pn_indi = 1 -----> REACTIVA
    -- pn_indi = 2 -----> FAE
    -- pn_indi = 3 -----> CRECER
  
    lx_mcof number(10, 2);
    lx_scap number(17, 2);
    lx_fdes date;
    lx_mext number(17, 2);
    lx_fdia date;
    lc_canc char(1);
    lx_stat number(2);
  
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
  
    --validar estado de credito y trx para determinar si es 30/360
    lc_canc := 'N';
  
    begin
    
      select 'S'
        into lc_canc
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
                 and x.tp1corr2 = 4 --flag determina si trx se pertenece a cancelacion
                 and x.tp1corr3 > 0)
         and t.d602fc >= lx_fdes
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    
    exception
      when others then
        lc_canc := 'N';
    end;
  
    if lc_canc = 'S' then
      pn_sald := 0;
    
    else
      -- a) monto COFIDE
      case
        when pn_indi = 1 then
          -- REACTIVA
        
          begin
          
            select x.aqpb065bmon, x.aqpb065bfdes
              into lx_mcof, lx_fdes
              from aqpb065b x
             where x.aqpb065bcod = pn_cod
                  --and x.aqpb065bmod = pn_mod
                  -- and x.aqpb065bsuc = pn_suc --  jrodriguej 28.06.2021
               and x.aqpb065bmda = pn_mda
               and x.aqpb065bpap = pn_pap
               and x.aqpb065bcta = pn_cta
               and x.aqpb065bope = pn_ope
                  -- and x.aqpb065bsbo = pn_sbo
                  -- and x.aqpb065btop = pn_top
               and x.aqpb065bfec <= pn_fecha
               and x.aqpb065best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb065bmon, f.aqpb065bfdes
                  into lx_mcof, lx_fdes
                  from (select x.aqpb065bmon, x.aqpb065bfdes
                          from aqpb065b x
                         where x.aqpb065bcod = pn_cod
                              --and x.aqpb065bmod = pn_mod
                              -- and x.aqpb065bsuc = pn_suc --  jrodriguej 28.06.2021
                           and x.aqpb065bmda = pn_mda
                           and x.aqpb065bpap = pn_pap
                           and x.aqpb065bcta = pn_cta
                           and x.aqpb065bope = pn_ope
                              -- and x.aqpb065bsbo = pn_sbo
                              -- and x.aqpb065btop = pn_top
                           and x.aqpb065bfec <= pn_fecha
                           and x.aqpb065best <> 'D'
                         order by x.aqpb065bfec desc) f
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
        
        when pn_indi = 2 then
          -- FAE
        
          begin
          
            select x.aqpb067bmon, x.aqpb067bfdes
              into lx_mcof, lx_fdes
              from aqpb067b x
             where x.aqpb067bcod = pn_cod
                  --and x.aqpb067bmod = pn_mod
                  -- and x.aqpb067bsuc = pn_suc --  jrodriguej 28.06.2021
               and x.aqpb067bmda = pn_mda
               and x.aqpb067bpap = pn_pap
               and x.aqpb067bcta = pn_cta
               and x.aqpb067bope = pn_ope
                  -- and x.aqpb067bsbo = pn_sbo
                  -- and x.aqpb067btop = pn_top
               and x.aqpb067bfec <= pn_fecha
               and x.aqpb067best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb067bmon, f.aqpb067bfdes
                  into lx_mcof, lx_fdes
                  from (select x.aqpb067bmon, x.aqpb067bfdes
                          from aqpb067b x
                         where x.aqpb067bcod = pn_cod
                              --and x.aqpb067bmod = pn_mod
                              -- and x.aqpb067bsuc = pn_suc --  jrodriguej 28.06.2021
                           and x.aqpb067bmda = pn_mda
                           and x.aqpb067bpap = pn_pap
                           and x.aqpb067bcta = pn_cta
                           and x.aqpb067bope = pn_ope
                              -- and x.aqpb067bsbo = pn_sbo
                              -- and x.aqpb067btop = pn_top
                           and x.aqpb067bfec <= pn_fecha
                           and x.aqpb067best <> 'D'
                         order by x.aqpb067bfec desc) f
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
        
        when pn_indi = 3 then
          -- CRECER
        
          begin
          
            select x.aqpb073bmon, x.aqpb073bfdes
              into lx_mcof, lx_fdes
              from aqpb073b x
             where x.aqpb073bcod = pn_cod
                  --and x.aqpb073bmod = pn_mod
                  -- and x.aqpb073bsuc = pn_suc --  jrodriguej 28.06.2021
               and x.aqpb073bmda = pn_mda
               and x.aqpb073bpap = pn_pap
               and x.aqpb073bcta = pn_cta
               and x.aqpb073bope = pn_ope
                  -- and x.aqpb073bsbo = pn_sbo
                  -- and x.aqpb073btop = pn_top
               and x.aqpb073bfec <= pn_fecha
               and x.aqpb073best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb073bmon, f.aqpb073bfdes
                  into lx_mcof, lx_fdes
                  from (select x.aqpb073bmon, x.aqpb073bfdes
                          from aqpb073b x
                         where x.aqpb073bcod = pn_cod
                              -- and x.aqpb073bmod = pn_mod
                              -- and x.aqpb073bsuc = pn_suc --  jrodriguej 28.06.2021
                           and x.aqpb073bmda = pn_mda
                           and x.aqpb073bpap = pn_pap
                           and x.aqpb073bcta = pn_cta
                           and x.aqpb073bope = pn_ope
                              -- and x.aqpb073bsbo = pn_sbo
                              -- and x.aqpb073btop = pn_top
                           and x.aqpb073bfec <= pn_fecha
                           and x.aqpb073best <> 'D'
                         order by x.aqpb073bfec desc) f
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
      
        lx_scap := lx_scap + lx_mext;
      
      else
        lx_scap := 0;
      end if;
    
      if lx_mcof is null then
        lx_mcof := 0;
      end if;
    
      --- c) Resultado
      pn_sald := lx_mcof - lx_scap;
    
      if pn_sald < 0 then
        pn_sald := 0;
      end if;
    end if; -- fin lc_canc       
  
    -- Verificación de estado del crédito
    if pn_stat = 99 then
      pn_sald := 0;
    end if;
  
  end sp_obtener_sald_insol2;
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
  
  begin
    -- clave
  
    lc_fini := trunc(pn_fecha) - (to_number(to_char(pn_fecha, 'DD')) - 1);
  
    begin
    
      select max(t.pp1nump), min(t.pp1nump)
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
            
            --and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
            --    (select x.tp1nro1, x.tp1nro2
            --       from fst198 x
            --      where x.TP1COD = 1
            --        and x.TP1COD1 = 11144
            --        and x.TP1CORR1 = 1
            --        and x.tp1corr2 = 2
            --        and x.tp1corr3 > 0)         
            
         and t.d602fc >= lc_fini
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
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
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
              --and t.ppfpag <= lc_ppfpag
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
              
              --and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
              --    (select x.tp1nro1, x.tp1nro2
              --       from fst198 x
              --      where x.TP1COD = 1
              --        and x.TP1COD1 = 11144
              --        and x.TP1CORR1 = 1
              --        and x.tp1corr2 = 2
              --        and x.tp1corr3 > 0)            
              
           and t.d602co = 'S';
      
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
              
              --and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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
              
              --and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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

  procedure sp_distribuc_pago_mes_pa(pn_cod   in number,
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
                                  pn_pen   out number,-- penalidad
                                  pn_pamr  out number) --principal amortizado
   is
    -- Considera los pagos acumulados del crédito vigente con respecto a la fecha de corte
    lc_ppfpag     date;
    lc_pp1nump_mx number(9);
    lc_pp1nump_mn number(9);
    lc_fini       date;
  
  begin
    -- clave
  
    lc_fini := trunc(pn_fecha) - (to_number(to_char(pn_fecha, 'DD')) - 1);
  
    begin
    
      select max(t.pp1nump), min(t.pp1nump)
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
            
            --and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
            --    (select x.tp1nro1, x.tp1nro2
            --       from fst198 x
            --      where x.TP1COD = 1
            --        and x.TP1COD1 = 11144
            --        and x.TP1CORR1 = 1
            --        and x.tp1corr2 = 2
            --        and x.tp1corr3 > 0)         
            
         and t.d602fc >= lc_fini
         and t.d602fc <= pn_fecha
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
          into pn_cuo, pn_int, pn_pamr
        
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
              --and t.ppfpag <= lc_ppfpag
           and t.pp1nump >= lc_pp1nump_mn
           and t.pp1nump <= lc_pp1nump_mx
           and t.pp1stat in ('P', 'T')
              
              --and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
              --    (select x.tp1nro1, x.tp1nro2
              --       from fst198 x
              --      where x.TP1COD = 1
              --        and x.TP1COD1 = 11144
              --        and x.TP1CORR1 = 1
              --        and x.tp1corr2 = 2
              --        and x.tp1corr3 > 0)            
              
           and t.d602co = 'S';
      
      exception
        when others then
          pn_cuo := 0;
          pn_int := 0;
          pn_pamr := 0;
      end;
    
      -- Mora, Interés compensatorio, seguros
      begin
      
        select nvl(sum(x.pp1imp2), 0), --- mora
               nvl(sum(x.pp1imp3), 0), --- icv
               nvl(sum(x.pp1imp11 + x.pp1imp12 + x.pp1imp13 + x.pp1imp14 +
                       x.pp1imp15),
                   0) --seg
          into pn_mor, pn_icv, pn_gas
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
              
              --and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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
              
              --and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
              --    (select j.tp1nro1, j.tp1nro2
              --       from fst198 j
              --      where j.TP1COD = 1
              --        and j.TP1COD1 = 11144
              --        and j.TP1CORR1 = 1
              --        and j.tp1corr2 = 2
              --        and j.tp1corr3 > 0)
           and t.d602co = 'S';
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
  
  end sp_distribuc_pago_mes_pa;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener pago total o amortizado
  procedure sp_obtener_pagoi_crec(pn_cod    in number,
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
                                  
                                  pn_impl out number,
                                  pn_fech out date) --return number
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
                      -- and t.aosuc = pn_suc --  jrodriguej 28.06.2021
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
          select t.hcimp1, t.hfcon
            into pn_impl, pn_fech
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
                select t.hcimp1, t.hfcon
                  into pn_impl, pn_fech
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
                  
                    select t.hcimp1, t.hfcon
                      into pn_impl, pn_fech
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
                      
                        select t.hcimp1, t.hfcon
                          into pn_impl, pn_fech
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
                      
                      end;
                    
                  end;
                
              end;
            end if;
          
        end;
      else
        begin
        
          select t.itimp1, t.itfval
            into pn_impl, pn_fech
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
              
                select t.itimp1, t.itfval
                  into pn_impl, pn_fech
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
                  
                    select t.itimp1, t.itfval
                      into pn_impl, pn_fech
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
                      
                        select t.itimp1, t.itfval
                          into pn_impl, pn_fech
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
        pn_fech := null;
    end;
  
    --return lx_imp1;
  
  end sp_obtener_pagoi_crec;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_mprepago_fae(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_tsum  out number) is
  
    lx_imp number(17, 2);
    lx_cd  number(3);
    lx_mo  number(3);
    lx_su  number(3);
    lx_tr  number(3);
    lx_re  number(4);
    lx_fc  date;
    ---lx_imp1  number(17, 2);
    ---lx_sdoi  number(17, 2);
    lx_fecha date;
  
    pn_gas number(17, 2); -- seguridad
    pn_mor number(17, 2); -- moratoria
    pn_int number(17, 2); -- interés
    pn_cuo number(17, 2); -- capital
    pn_icv number(17, 2); -- interés compensatorio (icv)
    pn_pen number(17, 2);
  
  begin
    --Fórmula: FSD010(AOIMP) - FSH016(HCIMP1)
    -- 1. Obtención de AOIMP
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención de la transacción
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
                    -- and t.aosuc = pn_suc --  jrodriguej 28.06.2021
                 and t.aomda = pn_mda
                 and t.aopap = pn_pap
                 and t.aocta = pn_cta
                 and t.aooper = pn_ope
                    --and t.aosbop = pn_sbo
                 and t.aotope = pn_top
                 and t.evtipo = 50
                 and t.d012co = 'S'
                 and t.d012fc <= pn_fecha
               order by t.d012fc desc) f
       where rownum = 1;
    
    exception
      when others then
      
        lx_cd := null;
        lx_mo := null;
        lx_su := null;
        lx_tr := null;
        lx_re := null;
        lx_fc := null;
      
    end;
  
    -- 3. Calculos
    pn_gas := 0;
    pn_mor := 0;
    pn_int := 0;
    pn_cuo := 0;
    pn_icv := 0;
    pn_pen := 0;
  
    if lx_cd is not null then
      -- Interés y capital
      begin
      
        select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
        
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
              --and t.ppfpag <= lc_ppfpag
           and t.d602cd = lx_cd
           and t.d602mo = lx_mo
           and t.d602su = lx_su
           and t.d602tr = lx_tr
           and t.d602re = lx_re
           and t.d602fc = lx_fc
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S';
      
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
           and x.pptope = pn_top
              
           and t.d602cd = lx_cd
           and t.d602mo = lx_mo
           and t.d602su = lx_su
           and t.d602tr = lx_tr
           and t.d602re = lx_re
           and t.d602fc = lx_fc
              
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S'
        
        ;
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
           and x.pptope = pn_top
              
           and t.d602cd = lx_cd
           and t.d602mo = lx_mo
           and t.d602su = lx_su
           and t.d602tr = lx_tr
           and t.d602re = lx_re
           and t.d602fc = lx_fc
              
           and t.pp1stat in ('P', 'T')
           and t.d602co = 'S';
      exception
        when others then
          pn_pen := 0;
      end;
    end if;
  
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_obtener_mprepago_fae;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_saldo_011012(pn_cod     in number,
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
  
    lx_imp   number(17, 2);
    lx_cd    number(3);
    lx_mo    number(3);
    lx_su    number(3);
    lx_tr    number(3);
    lx_re    number(4);
    lx_fc    date;
    lx_imp1  number(17, 2);
    lx_sdoi  number(17, 2);
    lx_saldo number(17, 2);
    lx_fecha date;
  
  begin
  
    begin
      select (t.bcsdmn * -1)
        into lx_saldo
        from fsh012 t
       where t.bcemp = pn_cod
         and t.bcmod = pn_mod
         and t.bcsuc = pn_suc
         and t.bcmda = pn_mda
         and t.bcpap = pn_pap
         and t.bccta = pn_cta
         and t.bcoper = pn_ope
            --and t.bcsbop = pn_sbo
            --and t.bctop = pn_top
         and t.bcfech = pn_fecha;
    
    exception
      when others then
        lx_saldo := 0;
    end;
  
    lx_sdoi := lx_saldo;
  
    if lx_sdoi < 0 or lx_sdoi is null then
      lx_sdoi := 0;
    end if;
  
    return lx_sdoi;
  
  end fn_obtener_saldo_011012;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_datoshonrado(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pn_rubr   in number,
                                    pd_fecha  in date,
                                    pc_eshonr out char,
                                    pn_mhonr  out number,
                                    pd_fhonr  out date,
                                    pn_sdohon out number) is
    ln_rubr  number(16);
    ln_sdo11 number(17, 2);
    lx_fdia  date;
  begin
    pc_eshonr := 'N';
    pn_mhonr  := 0;
    pd_fhonr  := null;
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
    begin
      select 'S', a1.aqpb434fecr, a1.aqpb434mto
        into pc_eshonr, pd_fhonr, pn_mhonr
        from aqpb434 a1
       where a1.aqpb434cod = pn_cod
            --and a1.aqpb434mod = pn_mod
            --and a1.aqpb434mda = pn_mda
            --and a1.aqpb434pap = pn_pap
         and a1.aqpb434cta = pn_cta
         and a1.aqpb434ope = pn_ope
            --and a1.aqpb434sbo = pn_sbo
            --and a1.aqpb434top = pn_top
         and a1.aqpb434est = 'C'
         and rownum <= 1;
    exception
      when others then
        pc_eshonr := 'N';
        pn_mhonr  := 0;
        pd_fhonr  := null;
    end;
    /*
        if lx_fdia <> pd_fecha then
          if pn_rubr = 9300082010000 then 
          begin
            select sum(f.BCSDMN*-1)
              into pn_sdohon
              from fsh012 f
             where f.BCEMP = 1
               and f.BCRUBR in (9300082010000,9300082020000)
               and f.BCCTA = pn_cta
               and f.BCOPER = pn_ope
               and f.BCFECH = pd_fecha;
          exception
            when others then
              pn_sdohon := 0;
          end;
          else
            begin
            select sum(f.BCSDMN*-1)
              into pn_sdohon
              from fsh012 f
             where f.BCEMP = 1
               and f.BCRUBR = pn_rubr
               and f.BCCTA = pn_cta
               and f.BCOPER = pn_ope
               and f.BCFECH = pd_fecha;
               exception
               when others then
               pn_sdohon := 0;
              end;
          end if;
        else
          if pn_rubr = 9300082010000 then 
           begin
              select sum(a2.SCSDO*-1)
                into pn_sdohon
                from fsd011 a2
               where a2.pgcod = 1
                 and a2.sccta = pn_cta
                 and a2.scoper = pn_ope
                 and a2.scrub in (9300082010000,9300082020000);
             exception
             when others then        
                  pn_sdohon := 0;
            end;
           else
             begin
              select sum(a2.SCSDO*-1)
                into pn_sdohon
                from fsd011 a2
               where a2.pgcod = 1
                 and a2.sccta = pn_cta
                 and a2.scoper = pn_ope
                 and a2.scrub = pn_rubr;
             exception
             when others then        
                  pn_sdohon := 0;
            end;
           end if;
        end if;
      
    */
    if lx_fdia <> pd_fecha then
      begin
        select /*+index(F FSH01204)*/sum(f.BCSDMN)
          into pn_sdohon
          from fsh012 f
         where f.BCEMP = 1
           and f.BCRUBR in (select /*+index(FSI006 SYS_C0080890)*/rubro from fsi006 where cicpo = 'MHONRAM')
           and f.BCCTA = pn_cta
           and f.BCOPER = pn_ope
           and f.BCFECH = pd_fecha;
      exception
        when others then
          pn_sdohon := 0;
      end;
    else
      begin
        select sum(a2.SCSDO)
          into pn_sdohon
          from fsd011 a2
         where a2.pgcod = 1
           and a2.sccta = pn_cta
           and a2.scoper = pn_ope
           and a2.scrub in (select rubro from fsi006 where cicpo = 'MHONRAM');
      exception
        when others then
          pn_sdohon := 0;
      end;
    end if;
    if pn_sdohon < 0 then
      pn_sdohon := pn_sdohon * -1;
    end if;
  end sp_obtener_datoshonrado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_fcamb_estado(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pd_fecha in date,
                                    pd_fcest out date) is
    ld_fechenvjudic date;
    ld_firl         date;
    ld_fcas         date;
  begin
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
    
    end;
    begin
      select m33.JAQM33FDem
        into ld_fechenvjudic
        from jaqm27 m27
        left join jaqm33 m33
          on m33.jaqm33cor = m27.jaqm33cor
       where m27.jaqm27pgc = 1
         and m27.jaqm27mda = pn_mda
         and m27.jaqm27pap = 0
         and m27.jaqm27suc = pn_suc
         and m27.jaqm27cta = pn_cta
         and m27.jaqm27oper = pn_ope;
    exception
      when others then
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
  
  end sp_obtener_fcamb_estado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_drefinanciac(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pd_fecha  in date,
                                    pc_lrefin out char,
                                    pd_frefin out date) is
  begin
    begin
      select 'S'
        into pc_lrefin
        from xwf700 t2
       inner join sng001 t1
          on t2.xwfempresa = t1.sng001emp
         and t2.xwfprcins = t1.sng001inst
       where t2.xwfempresa = 1
         and t2.xwfcuenta = pn_cta
         and t2.xwfoperacion = pn_ope
         and t1.sng001ori = 3
         and rownum <= 1;
    exception
      when others then
        pc_lrefin := 'N';
    end;
    if pc_lrefin = 'S' then
      begin
        select max(hfval)
          into pd_frefin
          from fsh016 t3
         where t3.pgcod = 1
           and t3.hcta = pn_cta
           and t3.hoper = pn_ope;
      exception
        when others then
          null;
      end;
    else
      pd_frefin := null;
    end if;
  end sp_obtener_drefinanciac;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuop_2(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fec     in date,
                             pd_fvenup  in date, --fecha vencimiento ultima pago
                             pn_ncuopp  out number, -- Cuotas pendientes de pago
                             pn_ncuopa  out number, -- Cuotas ya pagadas
                             pn_ncuoimp out number) --Cuotas impagas
   is
  
    --lx_ncuop number;
    --lx_fupag date;
  
  begin
  
    -- Cuotas pendientes de pago
    if pd_fvenup is null then
    
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopp
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
          pn_ncuopp := 0;
      end;
    else
    
      -- Cuotas pendientes de pago
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopp
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
           and t.ppfpag > pd_fvenup
           and t.d601co = 'S';
      exception
        when others then
          pn_ncuopp := 0;
      end;
    
      -- Cuotas ya pagadas
      begin
      
        SELECT
        
         count(*)
          into pn_ncuopa
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
           and t.ppfpag <= pd_fvenup
           and t.d601co = 'S'; -- jrodriguej 28.06.2021
      exception
        when others then
          pn_ncuopa := 0;
      end;
    
      -- Cuotas pendientes de pago
      begin
        SELECT
        
         count(*)
          into pn_ncuoimp
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
           and t.ppfpag > pd_fvenup
           and t.ppfpag <= pn_fec
           and t.d601co = 'S';
      exception
        when others then
          pn_ncuoimp := 0;
      end;
    end if;
  
  end sp_fecha_ncuop_2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_moractual(pn_cod   in number,
                                      pn_mod   in number,
                                      pn_suc   in number,
                                      pn_mda   in number,
                                      pn_pap   in number,
                                      pn_cta   in number,
                                      pn_ope   in number,
                                      pn_sbo   in number,
                                      pn_top   in number,
                                      pn_fecha in date,
                                      pn_tasa  out number) is
  
  begin
  
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
                           --and f2.evfval < pn_fecha
                           );
    
    exception
      when others then
        ---lx_fdes := null;
      
        begin
        
          SELECT t.aotmor
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
  
  end sp_obtener_tasa_moractual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tasa_REPRO(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fecha in date,
                                  pn_tasa  out number) is
  
  begin
  
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
  
  end sp_obtener_tasa_REPRO;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_montos_venc(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_int   out number,
                                   pn_mor   out number,
                                   pn_icv   out number) is
    lx_fecha     date;
    lx_fecha_ant date;
    lx_fecha_q   date;
  begin
    /*begin
      select max(a.jaql964hfeh)
        into lx_fecha
        from jaql964h a
       where a.jaql964hcta = pn_cta
         and a.jaql964hope = pn_ope;
    exception
      when others then
        lx_fecha := pn_fecha;
    end;*/
    begin       
        select pgfape-1 into lx_fecha from fst017 where pgcod =1;
    exception
      when others then null;
    end;  
    begin
      select a.jaql964int, a.jaql964mor, a.jaql964icv
        into pn_int, pn_mor, pn_icv
        from jaql964 a
       where a.jaql964cta = pn_cta
         and a.jaql964ope = pn_ope
         and rownum = 1;
    exception
      when others then
        begin
          select a.jaql964hint, a.jaql964hmor, a.jaql964hicv
            into pn_int, pn_mor, pn_icv
            from jaql964h a
           where a.jaql964hfeh = lx_fecha
             and a.jaql964hcta = pn_cta
             and a.jaql964hope = pn_ope;
        exception
          when others then
            begin
              select a.jaql964hint, a.jaql964hmor, a.jaql964hicv
                into pn_int, pn_mor, pn_icv
                from jaql964h a
               where a.jaql964hfeh = lx_fecha - 1
                 and a.jaql964hcta = pn_cta
                 and a.jaql964hope = pn_ope;
            exception
              when others then
                begin
                  select a.jaql964hint, a.jaql964hmor, a.jaql964hicv
                    into pn_int, pn_mor, pn_icv
                    from jaql964h a
                   where a.jaql964hfeh = lx_fecha - 2
                     and a.jaql964hcta = pn_cta
                     and a.jaql964hope = pn_ope;
                exception
                  when others then
                    pn_int := 0;
                    pn_mor := 0;
                    pn_icv := 0;
                end;
            end;
        end;
    end;
  
  end sp_obtener_montos_venc;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_montos_rmora(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_int   out number,
                                   pn_mor   out number,
                                   pn_icv   out number,
                                   pn_pen   out number) is
    lx_fecha     date;
    lx_fecha_ant date;
    lx_fecha_q   date;
  begin
    /*begin
      select max(a.jaql964hfeh)
        into lx_fecha
        from jaql964h a
       where a.jaql964hcta = pn_cta
         and a.jaql964hope = pn_ope;
    exception
      when others then
        lx_fecha := pn_fecha;
    end;*/
    begin       
        select pgfape-1 into lx_fecha from fst017 where pgcod =1;
    exception
      when others then null;
    end; 
    begin
      select a.jaql964int, a.jaql964mor, a.jaql964icv, a.jaql964pen
        into pn_int, pn_mor, pn_icv, pn_pen
        from jaql964 a
       where a.jaql964cta = pn_cta
         and a.jaql964ope = pn_ope
         and rownum = 1;
    exception
      when others then
        begin
          select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
            into pn_int, pn_mor, pn_icv,pn_pen
            from jaql964h a
           where a.jaql964hfeh = lx_fecha
             and a.jaql964hcta = pn_cta
             and a.jaql964hope = pn_ope;
        exception
          when others then
            begin
              select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
                into pn_int, pn_mor, pn_icv,pn_pen
                from jaql964h a
               where a.jaql964hfeh = lx_fecha -1
                 and a.jaql964hcta = pn_cta
                 and a.jaql964hope = pn_ope;
            exception
              when others then
                begin
                  select a.jaql964hint, a.jaql964hmor, a.jaql964hicv,a.jaql964hpen
                    into pn_int, pn_mor, pn_icv,pn_pen
                    from jaql964h a
                   where a.jaql964hfeh = lx_fecha -2
                     and a.jaql964hcta = pn_cta
                     and a.jaql964hope = pn_ope;
                exception
                  when others then
                    pn_int := 0;
                    pn_mor := 0;
                    pn_icv := 0;
                    pn_pen := 0;
                end;
            end;
        end;
    end;
  
  end sp_obtener_montos_rmora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_interes_acum(pn_cod   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_fecha in date,
                                    pn_intac out number) is
  
  begin
    pn_intac := 0;
    begin
      select sum(x.HCIMP1)
        into pn_intac
        from fsh016 x, fsh015 t
       where x.PGCOD = t.pgcod
         and x.HCMOD = t.hcmod
         and x.HSUCOR = t.hsucor
         and x.HTRAN = t.htran
         and x.HNREL = t.hnrel
         and x.HFCON = t.hfcon
         and x.PGCOD = pn_cod
         and x.HMDA = pn_mda
         and x.HPAP = pn_pap
         and x.HCTA = pn_cta --cuenta
         and x.HOPER = pn_ope --operacion              
         and x.HFCON <= pn_fecha
         and x.hrubro like '14_8%'
         and t.hccorr <> 99
         and (x.hcmod, x.htran) in
             (SELECT T34.tp1nro2, T34.tp1nro3
                FROM FST198 T34
               WHERE T34.tp1cod = 1
                 and T34.tp1cod1 = 11164
                 and T34.tp1corr1 = 10
                 and T34.tp1corr2 = 1);
    exception
      when others then
        pn_intac := 0;
    end;
  
  end sp_obtener_interes_acum;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Fecha fin  credito original
  function fn_fecha_cre_original(pn_cod in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number) return date is
  
    ld_ffinco date;
  
  begin
  
    begin
    
      select ppfVTO
        into ld_ffinco
        from (select ppfVTO
                from FSD601 t
               where t.pgcod = pn_cod
                 and t.ppmod = pn_mod
                 and t.ppmda = pn_mda
                 and t.pppap = pn_pap
                 and t.ppcta = pn_cta
                 and t.ppoper = pn_ope
                 and t.ppsbop = 0
                    --and t.pptope = m.aotope
                 and t.d601co = 'S'
               order by ppfpag desc)
       where rownum = 1;
    
    exception
      when others then
        ld_ffinco := null;
    end;
  
    return ld_ffinco;
  
  end fn_fecha_cre_original;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Fecha fin  credito original
  function fn_fecha_cre_original_r(pn_cod in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pc_rep in char,
                                 pd_fre in date) return date is
  
    ld_ffinco date;
    ld_f400   date;
    ld_f698   date;
  begin
    if pc_rep = 'SI' then
      begin
        select mIN(x.jaqa400fec)
          into ld_f400
          from jaqa400 x
         where x.jaqa400emp = pn_cod
           and x.jaqa400cta = pn_cta
           and x.jaqa400ope = pn_ope
           and x.jaqa400est in ('C')
           and x.jaqa400fec <= pd_fre;
      exception when others then
        ld_f400 := sysdate;
      end;
      begin
        select mIN(x.jaqz698fep)
          into ld_f698
          from jaqz698 x
         where x.jaqz698emp = pn_cod
           and x.jaqz698cta = pn_cta
           and x.jaqz698ope = pn_ope 
           and x.jaqz698fep <= pd_fre;
      exception when others then
        ld_f698 := sysdate;
      end;
      if ld_f400 < ld_f698 then
        begin
          select ppfVTO
            into ld_ffinco
            from (select ppfVTO
                    from aqpb088_601c t
                   where t.pgcod = pn_cod
                     and t.ppmod = pn_mod
                     and t.ppmda = pn_mda
                     and t.pppap = pn_pap
                     and t.ppcta = pn_cta
                     and t.ppoper = pn_ope
                     and t.ppsbop = 0
                        --and t.pptope = m.aotope
                     and t.d601co = 'S'
                     and t.fec = ld_f400
                   order by ppfpag desc)
           where rownum = 1;
        
        exception
          when others then
            ld_ffinco := null;
        end;
      else
        begin
          select ppfVTO
            into ld_ffinco
            from (select ppfVTO
                    from jaqz520_601c t
                   where t.pgcod = pn_cod
                     and t.ppmod = pn_mod
                     and t.ppmda = pn_mda
                     and t.pppap = pn_pap
                     and t.ppcta = pn_cta
                     and t.ppoper = pn_ope
                     and t.ppsbop = 0
                        --and t.pptope = m.aotope
                     and t.d601co = 'S'
                     and t.fec = ld_f698
                   order by ppfpag desc)
           where rownum = 1;
        
        exception
          when others then
            ld_ffinco := null;
        end;
      end if;
    else
      begin
      
        select ppfVTO
          into ld_ffinco
          from (select ppfVTO
                  from FSD601 t
                 where t.pgcod = pn_cod
                   and t.ppmod = pn_mod
                   and t.ppmda = pn_mda
                   and t.pppap = pn_pap
                   and t.ppcta = pn_cta
                   and t.ppoper = pn_ope
                   and t.ppsbop = 0
                      --and t.pptope = m.aotope
                   and t.d601co = 'S'
                 order by ppfpag desc)
         where rownum = 1;
      
      exception
        when others then
          ld_ffinco := null;
      end;
    end if;
    return ld_ffinco;
  
  end fn_fecha_cre_original_r;
  ----------------------------------------------------------------------------------------------
  procedure sp_obtener_valorcuotas(pn_cod    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pn_fecha  in date,
                                   pn_vulcpa out number,
                                   pn_vcprve out number,
                                   pn_fuclpa out date) is
    ld_fecha_ucuo date;
  begin
    begin
      select pp1fech, pp1int + pp1cap
        into ld_fecha_ucuo, pn_vulcpa
        from (select pp1fech, pp1int, pp1cap
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
                 and a.d602fc <= pn_fecha
               order by pp1fech desc)
       where rownum = 1;
    exception
      when others then
        ld_fecha_ucuo := null;
        pn_vulcpa     := 0;
        pn_vcprve     := 0;
        pn_fuclpa     := null;
    end;
    if ld_fecha_ucuo is not null then
      begin
        select ppfpag, ppcap + ppint
          into pn_fuclpa, pn_vcprve
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
                   and t.ppfpag > ld_fecha_ucuo
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          pn_vcprve := 0;
          pn_fuclpa := null;
      end;
    else
      begin
        select ppfpag, ppcap + ppint
          into pn_fuclpa, pn_vcprve
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
                   --and t.ppfpag > ld_fecha_ucuo
                 order by ppfpag asc)
         where rownum = 1;
      exception
        when others then
          pn_vcprve := 0;
          pn_fuclpa := null;
      end;
    end if;
  
  end sp_obtener_valorcuotas;
  -----------------------------------------------------------------------------------------------
end pq_cr_reporte_fondos_p3;
/

