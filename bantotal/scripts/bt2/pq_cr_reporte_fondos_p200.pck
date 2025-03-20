create or replace package pq_cr_reporte_fondos_p200 is
  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondos_p200
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 19/07/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar información de reportes de fondos
  --                                con módulo 200                                  
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- REACTIVA: Obtener información adicional
  procedure sp_plantilla_reactiva(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fecha in date,
                                  
                                  pn_fsub out aqpb065b.aqpb065bfsub%type,
                                  pn_nsub out aqpb065b.aqpb065bnsub%type,
                                  pn_ncer out aqpb065b.aqpb065bncer%type,
                                  pn_ccob out aqpb065b.aqpb065bccob%type,
                                  pn_nact out aqpb065b.aqpb065bnact%type,
                                  pn_tdoc out aqpb065b.aqpb065btdoc%type,
                                  pn_ndoc out aqpb065b.aqpb065bndoc%type,
                                  pn_pcob out aqpb065b.aqpb065bpcob%type,
                                  pn_vpro out aqpb065b.aqpb065bvpro%type,
                                  pn_code out aqpb065b.aqpb065bcode%type,
                                  pn_nop  out aqpb065b.aqpb065bnop%type,
                                  pn_tneg out aqpb065b.aqpb065btneg%type,
                                  pn_ntra out aqpb065b.aqpb065bntra%type,
                                  pn_nsec out aqpb065b.aqpb065bnsec%type,
                                  pn_ttit out aqpb065b.aqpb065bttit%type,
                                  pn_temp out aqpb065b.aqpb065btemp%type,
                                  pn_gesp out aqpb065b.aqpb065bgesp%type,
                                  pn_ggen out aqpb065b.aqpb065bggen%type,
                                  pn_ldoc out aqpb065b.aqpb065bldoc%type,
                                  pn_sapr out aqpb065b.aqpb065bsapr%type,
                                  pn_fbcr out aqpb065b.aqpb065bfbcr%type,
                                  pn_ppzo out aqpb065b.aqpb065bppzo%type,
                                  pn_pgrac out aqpb065b.aqpb065bpgra%type,
                                  pn_ciuu  out aqpb065b.aqpb065bciiuori%type,
                                  pn_dciu  out aqpb065b.aqpb065bactnomori%type,
                                  pn_cren  out aqpb065b.aqpb065bcren%type,
                                  pn_cobr  out aqpb065b.aqpb065bcobr%type,
                                  pn_chon  out aqpb065b.aqpb065bchon%type
                                  ); -- return number;                                                                    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  -- FAE: Obtener información adicional
  procedure sp_plantilla_faemype_r1(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_csap  out aqpb067b.aqpb067bcsap%type,
                                    pn_fdes  out aqpb067b.aqpb067bfdes%type,
                                    pn_mon   out aqpb067b.aqpb067bmon%type,
                                    pn_ncuo  out aqpb067b.aqpb067bncuo%type,
                                    pn_peri  out aqpb067b.aqpb067bperi%type,
                                    pn_pcob  out aqpb067b.aqpb067bpcob%type,
                                    pn_fini out aqpb067b.aqpb067bfini%type,
                                    pn_ffin out aqpb067b.aqpb067bffin%type,
                                    pn_ciuu  out aqpb067b.aqpb067bciiuori%type,
                                    pn_dciu  out aqpb067b.aqpb067bactnomori%type
                                    ); -- return number;                                                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_plantilla_fcrecer(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date,
                                 pn_tdoc  out aqpb073b.aqpb073btdoc%type,
                                 pn_ndoc  out aqpb073b.aqpb073bndoc%type,
                                 pn_esf   out aqpb073b.aqpb073besf%type,
                                 pn_ccob  out aqpb073b.aqpb073bccob%type,
                                 pn_tnro  out aqpb073b.aqpb073btnro%type,
                                 pn_mtoe  out aqpb073b.aqpb073bmtoe%type,
                                 pn_pcob  out aqpb073b.aqpb073bpcob%type,
                                 pn_ciuu  out aqpb073b.aqpb073bciiuori%type,
                                 pn_dciu  out aqpb073b.aqpb073bactnomori%type,
                                 pn_nven  out aqpb073b.aqpb073bnven%type
                                 );
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
  -- Obtener saldo actual
  function fn_obtener_saldo_actual(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_fecha in date,
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
                                    pn_stat in number,
                                    pn_sald  out number
                                    );
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
  -- Obtener saldo capital
  function fn_obtener_sdocap(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_fecha in date,
                             pn_usuario in char) return number;
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
  procedure sp_obtener_tasa_actual(pn_cod     in number,
                                 pn_mod     in number,
                                 pn_suc     in number,
                                 pn_mda     in number,
                                 pn_pap     in number,
                                 pn_cta     in number,
                                 pn_ope     in number,
                                 pn_sbo     in number,
                                 pn_top     in number,
                                 pn_fecha in date,
                                 pn_tasa out number);
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
                            pn_usuario in char,
                            --pn_dcon in char,
                            pn_est   in number,
                            pn_ufech in date,

                            pn_rubr out char,
                            pn_resp out char);
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
                             pn_upago out number
                             );
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
  procedure sp_obtener_iniciales(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fde_ini out date,
                                  pn_mon_ini out number,
                                  pn_cuo_ini out number
                                  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_fecha_ncuo_pagtotal(pn_cod    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_fecha    in date,
                           pn_ncuo_pag out number
                           );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_datraso_uimp(pn_cod    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_ope    in number,
                              pn_sbo    in number,
                              pn_top    in number,
                              pn_fecha  in date,
                              pn_diat out number)  ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  end pq_cr_reporte_fondos_p200;
/

create or replace package body pq_cr_reporte_fondos_p200 is
  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondos_p200
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 19/07/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar información de reportes de fondos
  --                                con módulo 200                                  
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_plantilla_reactiva(pn_cod   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_fecha in date,
                                  
                                  pn_fsub  out aqpb065b.aqpb065bfsub%type,
                                  pn_nsub  out aqpb065b.aqpb065bnsub%type,
                                  pn_ncer  out aqpb065b.aqpb065bncer%type,
                                  pn_ccob  out aqpb065b.aqpb065bccob%type,
                                  pn_nact  out aqpb065b.aqpb065bnact%type,
                                  pn_tdoc  out aqpb065b.aqpb065btdoc%type,
                                  pn_ndoc  out aqpb065b.aqpb065bndoc%type,
                                  pn_pcob  out aqpb065b.aqpb065bpcob%type,
                                  pn_vpro  out aqpb065b.aqpb065bvpro%type,
                                  pn_code  out aqpb065b.aqpb065bcode%type,
                                  pn_nop   out aqpb065b.aqpb065bnop%type,
                                  pn_tneg  out aqpb065b.aqpb065btneg%type,
                                  pn_ntra  out aqpb065b.aqpb065bntra%type,
                                  pn_nsec  out aqpb065b.aqpb065bnsec%type,
                                  pn_ttit  out aqpb065b.aqpb065bttit%type,
                                  pn_temp  out aqpb065b.aqpb065btemp%type,
                                  pn_gesp  out aqpb065b.aqpb065bgesp%type,
                                  pn_ggen  out aqpb065b.aqpb065bggen%type,
                                  pn_ldoc  out aqpb065b.aqpb065bldoc%type,
                                  pn_sapr  out aqpb065b.aqpb065bsapr%type,
                                  pn_fbcr  out aqpb065b.aqpb065bfbcr%type,
                                  pn_ppzo  out aqpb065b.aqpb065bppzo%type,
                                  pn_pgrac out aqpb065b.aqpb065bpgra%type,
                                  pn_ciuu  out aqpb065b.aqpb065bciiuori%type,
                                  pn_dciu  out aqpb065b.aqpb065bactnomori%type,
                                  pn_cren  out aqpb065b.aqpb065bcren%type,
                                  pn_cobr  out aqpb065b.aqpb065bcobr%type,
                                  pn_chon  out aqpb065b.aqpb065bchon%type) is
  
  begin
  
    begin
    
      select
      
       g.aqpb065bfsub,
       g.aqpb065bnsub,
       g.aqpb065bncer,
       g.aqpb065bccob,
       g.aqpb065bnact,
       g.aqpb065btdoc,
       g.aqpb065bndoc,
       g.aqpb065bpcob,
       g.aqpb065bvpro,
       g.aqpb065bcode,
       g.aqpb065bnop,
       g.aqpb065btneg,
       g.aqpb065bntra,
       g.aqpb065bnsec,
       g.aqpb065bttit,
       g.aqpb065btemp,
       g.aqpb065bgesp,
       g.aqpb065bggen,
       g.aqpb065bldoc,
       g.aqpb065bsapr,
       g.aqpb065bfbcr,
       g.aqpb065bppzo,
       g.aqpb065bpgra,
       g.aqpb065bciiuori,
       g.aqpb065bactnomori,
       g.aqpb065bcren,
       g.aqpb065bcobr,
       g.aqpb065bchon
        into pn_fsub,
             pn_nsub,
             pn_ncer,
             pn_ccob,
             pn_nact,
             pn_tdoc,
             pn_ndoc,
             pn_pcob,
             pn_vpro,
             pn_code,
             pn_nop,
             pn_tneg,
             pn_ntra,
             pn_nsec,
             pn_ttit,
             pn_temp,
             pn_gesp,
             pn_ggen,
             pn_ldoc,
             pn_sapr,
             pn_fbcr,
             pn_ppzo,
             pn_pgrac,
             pn_ciuu,
             pn_dciu,
             pn_cren,
             pn_cobr,
             pn_chon
      
        from (select t.aqpb065bfsub,
                     t.aqpb065bnsub,
                     t.aqpb065bncer,
                     t.aqpb065bccob,
                     t.aqpb065bnact,
                     t.aqpb065btdoc,
                     t.aqpb065bndoc,
                     t.aqpb065bpcob,
                     t.aqpb065bvpro,
                     t.aqpb065bcode,
                     t.aqpb065bnop,
                     t.aqpb065btneg,
                     t.aqpb065bntra,
                     t.aqpb065bnsec,
                     t.aqpb065bttit,
                     t.aqpb065btemp,
                     t.aqpb065bgesp,
                     t.aqpb065bggen,
                     t.aqpb065bldoc,
                     t.aqpb065bsapr,
                     t.aqpb065bfbcr,
                     t.aqpb065bppzo,
                     t.aqpb065bpgra,
                     t.aqpb065bciiuori,
                     t.aqpb065bactnomori,
                     t.aqpb065bcren,
                     t.aqpb065bcobr,
                     t.aqpb065bchon
                from aqpb065b t
               where t.aqpb065bcod = pn_cod
                    --and t.aqpb065bmod = pn_mod  -- jrodriguej 19.07.2021
                    --and t.aqpb065bsuc = pn_suc  -- jrodriguej 28.06.2021
                 and t.aqpb065bmda = pn_mda
                 and t.aqpb065bpap = pn_pap
                 and t.aqpb065bcta = pn_cta
                 and t.aqpb065bope = pn_ope
                    --and t.aqpb065bsbo = pn_sbo
                    --and t.aqpb065btop = pn_top
                 and t.aqpb065bfec <= pn_fecha
                 and t.aqpb065best <> 'D'
               order by t.aqpb065bfec desc, t.aqpb065bcor desc) g
       where rownum = 1;
    
    exception
      when others then
        pn_fsub  := null;
        pn_nsub  := null;
        pn_ncer  := null;
        pn_ccob  := null;
        pn_nact  := null;
        pn_tdoc  := null;
        pn_ndoc  := null;
        pn_pcob  := null;
        pn_vpro  := null;
        pn_code  := null;
        pn_nop   := null;
        pn_tneg  := null;
        pn_ntra  := null;
        pn_nsec  := null;
        pn_ttit  := null;
        pn_temp  := null;
        pn_gesp  := null;
        pn_ggen  := null;
        pn_ldoc  := null;
        pn_sapr  := null;
        pn_fbcr  := null;
        pn_ppzo  := null;
        pn_pgrac := null;
        pn_ciuu  := null;
        pn_dciu  := null;
        pn_cren := null;
        pn_cobr  := null;
        pn_chon  := null;
    end;
  
  end sp_plantilla_reactiva;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_plantilla_faemype_r1(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_csap  out aqpb067b.aqpb067bcsap%type,
                                    pn_fdes  out aqpb067b.aqpb067bfdes%type,
                                    pn_mon   out aqpb067b.aqpb067bmon%type,
                                    pn_ncuo  out aqpb067b.aqpb067bncuo%type,
                                    pn_peri  out aqpb067b.aqpb067bperi%type,
                                    pn_pcob  out aqpb067b.aqpb067bpcob%type,
                                    pn_fini  out aqpb067b.aqpb067bfini%type,
                                    pn_ffin  out aqpb067b.aqpb067bffin%type,
                                    pn_ciuu  out aqpb067b.aqpb067bciiuori%type,
                                    pn_dciu  out aqpb067b.aqpb067bactnomori%type) is
  
  begin
  
    begin
    
      select g.aqpb067bcsap,
             g.aqpb067bfdes,
             g.aqpb067bmon,
             g.aqpb067bncuo,
             g.aqpb067bperi,
             g.aqpb067bpcob,
             g.aqpb067bfini,
             g.aqpb067bffin,
             g.aqpb067bciiuori,
             g.aqpb067bactnomori
        into pn_csap,
             pn_fdes,
             pn_mon,
             pn_ncuo,
             pn_peri,
             pn_pcob,
             pn_fini,
             pn_ffin,
             pn_ciuu,
             pn_dciu
        from (select t.aqpb067bcsap,
                     t.aqpb067bfdes,
                     t.aqpb067bmon,
                     t.aqpb067bncuo,
                     t.aqpb067bperi,
                     t.aqpb067bpcob,
                     t.aqpb067bfini,
                     t.aqpb067bffin,
                     t.aqpb067bciiuori,
                     t.aqpb067bactnomori
                from aqpb067b t
               where t.aqpb067bcod = pn_cod
                 --and t.aqpb067bmod = pn_mod -- jrodriguej 30.07.2021
                 --and t.aqpb067bsuc = pn_suc -- jrodriguej 28.06.2021
                 and t.aqpb067bmda = pn_mda
                 and t.aqpb067bpap = pn_pap
                 and t.aqpb067bcta = pn_cta
                 and t.aqpb067bope = pn_ope
                    --and t.aqpb067bsbo = pn_sbo
                    --and t.aqpb067btop = pn_top
                 and t.aqpb067bfec <= pn_fecha
                 and t.aqpb067best <> 'D'
               order by t.aqpb067bfec desc, t.aqpb067bcor desc) g
       where rownum = 1;
    
    exception
      when others then
        pn_csap := null;
        pn_fdes := null;
        pn_mon  := null;
        pn_ncuo := null;
        pn_peri := null;
        pn_pcob := null;
        pn_fini := null;
        pn_ffin := null;
        pn_ciuu := null;
        pn_dciu := null;
      
    end;
  
  end sp_plantilla_faemype_r1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_plantilla_fcrecer(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date,
                                 pn_tdoc  out aqpb073b.aqpb073btdoc%type,
                                 pn_ndoc  out aqpb073b.aqpb073bndoc%type,
                                 pn_esf   out aqpb073b.aqpb073besf%type,
                                 pn_ccob  out aqpb073b.aqpb073bccob%type,
                                 pn_tnro  out aqpb073b.aqpb073btnro%type,
                                 pn_mtoe  out aqpb073b.aqpb073bmtoe%type,
                                 pn_pcob  out aqpb073b.aqpb073bpcob%type,
                                 pn_ciuu  out aqpb073b.aqpb073bciiuori%type,
                                 pn_dciu  out aqpb073b.aqpb073bactnomori%type,
                                 pn_nven  out aqpb073b.aqpb073bnven%type) is
  
  begin
  
    begin
    
      select g.aqpb073btdoc,
             g.aqpb073bndoc,
             g.aqpb073besf,
             g.aqpb073bccob,
             g.aqpb073btnro,
             g.aqpb073bmtoe,
             g.aqpb073bpcob,
             g.aqpb073bciiuori,
             g.aqpb073bactnomori,
             g.aqpb073bnven
        into pn_tdoc,
             pn_ndoc,
             pn_esf,
             pn_ccob,
             pn_tnro,
             pn_mtoe,
             pn_pcob,
             pn_ciuu,
             pn_dciu,
             pn_nven
        from (select t.aqpb073btdoc,
                     t.aqpb073bndoc,
                     t.aqpb073besf,
                     t.aqpb073bccob,
                     t.aqpb073btnro,
                     t.aqpb073bmtoe,
                     t.aqpb073bpcob,
                     t.aqpb073bciiuori,
                     t.aqpb073bactnomori,
                     t.aqpb073bnven
                from aqpb073b t
               where t.aqpb073bcod = pn_cod
                 --and t.aqpb073bmod = pn_mod -- jrodriguej 30.07.2021
                 --and t.aqpb073bsuc = pn_suc -- jrodriguej 28.06.2021
                 and t.aqpb073bmda = pn_mda
                 and t.aqpb073bpap = pn_pap
                 and t.aqpb073bcta = pn_cta
                 and t.aqpb073bope = pn_ope
                 --and t.aqpb073bsbo = pn_sbo
                 --and t.aqpb073btop = pn_top
                 and t.aqpb073bfec <= pn_fecha
                 and t.aqpb073best <> 'D'
               order by t.aqpb073bfec desc, t.aqpb073bcor desc) g
       where rownum = 1;
    
    exception
      when others then
        pn_tdoc := null;
        pn_ndoc := null;
        pn_esf  := null;
        pn_ccob := null;
        pn_tnro := null;
        pn_mtoe := null;
        pn_pcob := null;
        pn_ciuu := null;
        pn_dciu := null;
        pn_nven := null;
    end;
  
  end sp_plantilla_fcrecer;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
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
           --and t.aqpb070amod = pn_mod  -- jrodriguej 30/07.2021
            --and t.aqpb070asuc = pn_suc --  jrodriguej 28.06.2021
           and t.aqpb070amda = pn_mda
           and t.aqpb070apap = pn_pap
           and t.aqpb070acta = pn_cta
           and t.aqpb070aoper = pn_ope
           --and t.aqpb070asbop = pn_sbo
           --and t.aqpb070atop = pn_top  -- jrodriguej 30/07.2021
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
    
   lc_fsis date;
    
    lv_cap number(16,2); --- capital
    lv_int number(16,2); --- interés
    lv_icv number(16,2); --- interés compensatorio
    lv_mor number(16,2); --- mora / pendalidad
    lv_seg number(16,2); --- segurs
    lv_rub number(16,2); --- rubr
    lv_gas number(16,2); --- otros gastos  
    
    lr_cod  NUMBER(3);
    lr_mod  NUMBER(3);
    lr_suc  NUMBER(3);
    lr_mda  NUMBER(4);
    lr_pap  NUMBER(4);
    lr_cta  NUMBER(9);
    lr_oper NUMBER(9);
    lr_sbop NUMBER(3);
    lr_tope NUMBER(3);   
    
    
  
  begin
  
    select x.pgfape into lc_fsis from fst017 x where x.pgcod = 1;
    
    -- clave anterior al mod 200
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into lr_cod,
               lr_mod,
               lr_suc,
               lr_mda,
               lr_pap,
               lr_cta,
               lr_oper,
               lr_sbop,
               lr_tope
          from (select x.pgcod,
                       x.aomod,
                       x.aosuc,
                       x.aomda,
                       x.aopap,
                       x.aocta,
                       x.aooper,
                       x.aosbop,
                       x.aotope
                  from fsd010 x
                 where x.pgcod = pn_cod
                   and x.aomda = pn_mda
                   and x.aopap = pn_pap
                   and x.aocta = pn_cta
                   and x.aooper = pn_ope
                   and x.aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 120, 144, 200))
                 order by x.aosbop desc) f
         where rownum = 1;
      exception
        when others then
          lr_cod  := null;
          lr_mod  := null;
          lr_suc  := null;
          lr_mda  := null;
          lr_pap  := null;
          lr_cta  := null;
          lr_oper := null;
          lr_sbop := null;
          lr_tope := null;
      end;      
  
    --validar estado de credito y trx para determinar si es 30/360
    lc_canc := 'N';
  
    begin
    
      select 'S'
        into lc_canc
        from fsd602 t
       where t.pgcod = lr_cod
         and t.ppmod = lr_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = lr_mda
         and t.pppap = lr_pap
         and t.ppcta = lr_cta
         and t.ppoper = lr_oper
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
                           --and x.aqpb073bmod = pn_mod
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
           where t.pgcod = lr_cod
             --and t.ppmod = lr_mod
                --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
             and t.ppsuc in (select p.sucurs
                               from fst001 p
                              where p.pgcod = 1
                                and p.sucurs < 800)
             and t.ppmda = lr_mda
             and t.pppap = lr_pap
             and t.ppcta = lr_cta
             and t.ppoper = lr_oper
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

        -- Montos que han sido cancelados después de la fecha de corte
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
      
        --- Distribución de pago, mód 200
        lv_cap := 0;
        lv_int := 0;
        lv_icv := 0;
        lv_mor := 0;
        lv_seg := 0;
        lv_rub := 0;
        lv_gas  := 0; 
              
        begin
          -- Call the procedure
          pq_cr_movcre_fsh016.sp_cr_mov_fsh016(pn_emp => pn_cod,
                                               pn_mod => pn_mod,
                                               pn_suc => pn_suc,
                                               pn_mda => pn_mda,
                                               pn_pap => pn_pap,
                                               pn_cta => pn_cta,
                                               pn_ope => pn_ope,
                                               pn_sbo => pn_sbo,
                                               pn_top => pn_top,
                                               pd_fpp => pn_fecha, --- Fecha proceso
                                               pd_fec => lc_fsis, --- Fecha sistema
                                               pd_fei => null,    --- Fecha de inicio de cálculo
                                               pc_ind => null,       --- Indicador último pago
                                               pv_cap => lv_cap, --- capital
                                               pv_int => lv_int, --- interés
                                               pv_icv => lv_icv, --- interés compensatorio
                                               pv_mor => lv_mor, --- mora / pendalidad
                                               pv_seg => lv_seg, --- segurs
                                               pv_rub => lv_rub, --- rubr
                                               pv_gas => lv_gas); --- otros gastos
        
        lv_gas := lv_gas + lv_seg;
        
        exception
          when others then
            
          lv_cap := 0;
          lv_int := 0;
          lv_icv := 0;
          lv_mor := 0;
          lv_seg := 0;
          lv_rub := 0;
          lv_gas  := 0;     
                     
        end;

        --- Resultados totales
        lx_scap := lx_scap + lx_mext + lv_cap;
      
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
           and t.aqpb070atop = pn_top
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
          pq_cr_reporte_fondos_p200.sp_repro_dato2(pn_cod   => pn_cod,
                                                   pn_cta   => pn_cta,
                                                   pn_ope   => pn_ope,
                                                   pn_frep  => pn_fech,
                                                   pn_tabla => pn_tabla,
                                                   pn_peri  => pn_peri,
                                                   pn_ncuo  => pn_ncuo,
                                                   pn_fpri  => pn_fpri,
                                                   pn_fult  => pn_fult);
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
          end;
        
        end if;
      
    --when pn_tabla = 'JAQZ255' then
    --  lx_exis := 1;
    end case;
  
    --pn_fpri := null;
  
  end sp_repro_dato2;
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
      pn_ufech := pq_cr_reporte_fondos_p200.fn_fecha_upago(pn_cod   => pn_cod,
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
    lc_fsis date;
    
    lv_cap number(16,2); --- capital
    lv_int number(16,2); --- interés
    lv_icv number(16,2); --- interés compensatorio
    lv_mor number(16,2); --- mora / pendalidad
    lv_seg number(16,2); --- segurs
    lv_rub number(16,2); --- rubr
    lv_gas number(16,2); --- otros gastos  
    
    lr_cod  NUMBER(3);
    lr_mod  NUMBER(3);
    lr_suc  NUMBER(3);
    lr_mda  NUMBER(4);
    lr_pap  NUMBER(4);
    lr_cta  NUMBER(9);
    lr_oper NUMBER(9);
    lr_sbop NUMBER(3);
    lr_tope NUMBER(3);    
    
  
  begin
   
    --  Fecha de sistema
    select p.pgfape into lc_fsis from fst017 p where p.pgcod = 1;
    
    -- clave anterior al mod 200
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into lr_cod,
               lr_mod,
               lr_suc,
               lr_mda,
               lr_pap,
               lr_cta,
               lr_oper,
               lr_sbop,
               lr_tope
          from (select x.pgcod,
                       x.aomod,
                       x.aosuc,
                       x.aomda,
                       x.aopap,
                       x.aocta,
                       x.aooper,
                       x.aosbop,
                       x.aotope
                  from fsd010 x
                 where x.pgcod = pn_cod
                   and x.aomda = pn_mda
                   and x.aopap = pn_pap
                   and x.aocta = pn_cta
                   and x.aooper = pn_ope
                   and x.aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 120, 144, 200))
                 order by x.aosbop desc) f
         where rownum = 1;
      exception
        when others then
          lr_cod  := null;
          lr_mod  := null;
          lr_suc  := null;
          lr_mda  := null;
          lr_pap  := null;
          lr_cta  := null;
          lr_oper := null;
          lr_sbop := null;
          lr_tope := null;
      end;
          
    -- 
    begin
    
      select f.ppfpag, f.pp1nump
        into lc_ppfpag, lc_pp1nump
        from (select t.ppfpag, t.pp1nump
                from fsd602 t
               where t.pgcod = lr_cod
                 and t.ppmod = lr_mod
                 and t.ppsuc = lr_suc
                 and t.ppmda = lr_mda
                 and t.pppap = lr_pap
                 and t.ppcta = lr_cta
                 and t.ppoper = lr_oper
                 and t.ppsbop = lr_sbop
                 and t.pptope = lr_tope
                 and t.pp1stat in ('P', 'T')
                 
                 and (t.d602mo, t.d602tr) not in  --- jrodriguej 12.08.2021
                     (select x.tp1nro1, x.tp1nro2
                        from fst198 x
                       where x.TP1COD = 1
                         and x.TP1COD1 = 11144
                         and x.TP1CORR1 = 1
                         and x.tp1corr2 = 2
                         and x.tp1corr3 > 0)                    
                 
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
         where t.pgcod = lr_cod
           and t.ppmod = lr_mod
           and t.ppsuc = lr_suc
           and t.ppmda = lr_mda
           and t.pppap = lr_pap
           and t.ppcta = lr_cta
           and t.ppoper = lr_oper
           and t.ppsbop = lr_sbop
           and t.pptope = lr_tope
           and t.ppfpag <= lc_ppfpag
           and t.pp1nump <= lc_pp1nump
           and t.pp1stat in ('P', 'T')
           
           and (t.d602mo, t.d602tr) not in  --- jrodriguej 12.08.2021
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 2
                   and x.tp1corr3 > 0)            
           
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
         where 
           x.pgcod = t.pgcod      --- jrodriguej 12.08.2021
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
         
           and x.pgcod = lr_cod
           and x.ppmod = lr_mod
           and x.ppsuc = lr_suc
           and x.ppmda = lr_mda
           and x.pppap = lr_pap
           and x.ppcta = lr_cta
           and x.ppoper = lr_oper
           and x.ppsbop = lr_sbop
           and x.pptope = lr_tope
           and x.pp1nump <= lc_pp1nump
           
           and (t.d602mo, t.d602tr) not in     --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
         
           and x.pgcod = lr_cod
           and x.ppmod = lr_mod
           and x.ppsuc = lr_suc
           and x.ppmda = lr_mda
           and x.pppap = lr_pap
           and x.ppcta = lr_cta
           and x.ppoper = lr_oper
           and x.ppsbop = lr_sbop
           and x.pptope = lr_tope
           and x.pp003nump <= lc_pp1nump
           
           and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
  
    --- Distribución de pago, mód 200
    lv_cap := 0;
    lv_int := 0;
    lv_icv := 0;
    lv_mor := 0;
    lv_seg := 0;
    lv_rub := 0;
    lv_gas  := 0; 
          
    begin
      -- Call the procedure
      pq_cr_movcre_fsh016.sp_cr_mov_fsh016(pn_emp => pn_cod,
                                           pn_mod => pn_mod,
                                           pn_suc => pn_suc,
                                           pn_mda => pn_mda,
                                           pn_pap => pn_pap,
                                           pn_cta => pn_cta,
                                           pn_ope => pn_ope,
                                           pn_sbo => pn_sbo,
                                           pn_top => pn_top,
                                           pd_fpp => pn_fecha, --- Fecha proceso
                                           pd_fec => lc_fsis, --- Fecha sistema
                                           pd_fei => null,    --- Fecha de inicio de cálculo
                                           pc_ind => null,       --- Indicador último pago
                                           pv_cap => lv_cap, --- capital
                                           pv_int => lv_int, --- interés
                                           pv_icv => lv_icv, --- interés compensatorio
                                           pv_mor => lv_mor, --- mora / pendalidad
                                           pv_seg => lv_seg, --- segurs
                                           pv_rub => lv_rub, --- rubr
                                           pv_gas => lv_gas); --- otros gastos
    
    lv_gas := lv_gas + lv_seg;
    
    exception
      when others then
        
      lv_cap := 0;
      lv_int := 0;
      lv_icv := 0;
      lv_mor := 0;
      lv_seg := 0;
      lv_rub := 0;
      lv_gas  := 0;     
                 
    end;
    
    pn_gas := pn_gas + lv_gas;
    pn_mor := pn_mor + lv_mor;
    pn_int := pn_int + lv_int;
    pn_cuo := pn_cuo + lv_cap;
    pn_icv := pn_icv + lv_icv;
    pn_pen := pn_pen + lv_mor;
    
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago_acum;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
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
                 and t.aotope = pn_top
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
    lc_fsis date;    
        
    lv_cap number(16,2); --- capital
    lv_int number(16,2); --- interés
    lv_icv number(16,2); --- interés compensatorio
    lv_mor number(16,2); --- mora / pendalidad
    lv_seg number(16,2); --- segurs
    lv_rub number(16,2); --- rubr
    lv_gas number(16,2); --- otros gastos  
        
    
    lr_cod  NUMBER(3);
    lr_mod  NUMBER(3);
    lr_suc  NUMBER(3);
    lr_mda  NUMBER(4);
    lr_pap  NUMBER(4);
    lr_cta  NUMBER(9);
    lr_oper NUMBER(9);
    lr_sbop NUMBER(3);
    lr_tope NUMBER(3);      
    
  begin
    -- clave
    
    select x.pgfape into lc_fsis from fst017 x where x.pgcod = 1;    
  
    -- clave anterior al mod 200
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into lr_cod,
               lr_mod,
               lr_suc,
               lr_mda,
               lr_pap,
               lr_cta,
               lr_oper,
               lr_sbop,
               lr_tope
          from (select x.pgcod,
                       x.aomod,
                       x.aosuc,
                       x.aomda,
                       x.aopap,
                       x.aocta,
                       x.aooper,
                       x.aosbop,
                       x.aotope
                  from fsd010 x
                 where x.pgcod = pn_cod
                   and x.aomda = pn_mda
                   and x.aopap = pn_pap
                   and x.aocta = pn_cta
                   and x.aooper = pn_ope
                   and x.aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 120, 144, 200))
                 order by x.aosbop desc) f
         where rownum = 1;
      exception
        when others then
          lr_cod  := null;
          lr_mod  := null;
          lr_suc  := null;
          lr_mda  := null;
          lr_pap  := null;
          lr_cta  := null;
          lr_oper := null;
          lr_sbop := null;
          lr_tope := null;
      end;  
  
    -- Obtener ultima fecha de pago y pp1nump 
    begin
    
      select f.ppfpag, f.pp1nump
        into lc_ppfpag, lc_pp1nump
        from (select t.ppfpag, t.pp1nump
                from fsd602 t
               where t.pgcod = lr_cod
                 and t.ppmod = lr_mod
                 and t.ppsuc = lr_suc
                 and t.ppmda = lr_mda
                 and t.pppap = lr_pap
                 and t.ppcta = lr_cta
                 and t.ppoper = lr_oper
                 and t.ppsbop = lr_sbop
                 and t.pptope = lr_tope
                 and t.pp1stat in ('P', 'T')
                 and t.d602fc <= pn_fecha
                 
                 and (t.d602mo, t.d602tr) not in --- jrodriguej 12/08.2021
                 (select x.tp1nro1, x.tp1nro2
                    from fst198 x
                   where x.TP1COD = 1
                     and x.TP1COD1 = 11144
                     and x.TP1CORR1 = 1
                     and x.tp1corr2 = 2
                     and x.tp1corr3 > 0)
                 
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
         where t.pgcod = lr_cod
           and t.ppmod = lr_mod
           and t.ppsuc = lr_suc
           and t.ppmda = lr_mda
           and t.pppap = lr_pap
           and t.ppcta = lr_cta
           and t.ppoper = lr_oper
           and t.ppsbop = lr_sbop
           and t.pptope = lr_tope
           and t.ppfpag = lc_ppfpag
           and t.pp1stat in ('P', 'T')
              --and t.d602fc <= pn_fecha
           and (t.d602mo, t.d602tr) not in --- jrodriguej 12/08.2021
           (select x.tp1nro1, x.tp1nro2
              from fst198 x
             where x.TP1COD = 1
               and x.TP1COD1 = 11144
               and x.TP1CORR1 = 1
               and x.tp1corr2 = 2
               and x.tp1corr3 > 0)              
              
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
         where 
           x.pgcod = t.pgcod      --- jrodriguej 12.08.2021
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
                    
           and x.pgcod = lr_cod
           and x.ppmod = lr_mod
           and x.ppsuc = lr_suc
           and x.ppmda = lr_mda
           and x.pppap = lr_pap
           and x.ppcta = lr_cta
           and x.ppoper = lr_oper
           and x.ppsbop = lr_sbop
           and x.pptope = lr_tope
              --and x.pp1nump <= lc_pp1nump;
           and x.pp1nump = lc_pp1nump
           
           
           and (t.d602mo, t.d602tr) not in --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
                    
           and x.pgcod = lr_cod
           and x.ppmod = lr_mod
           and x.ppsuc = lr_suc
           and x.ppmda = lr_mda
           and x.pppap = lr_pap
           and x.ppcta = lr_cta
           and x.ppoper = lr_oper
           and x.ppsbop = lr_sbop
           and x.pptope = lr_tope
              --and x.pp003nump <= lc_pp1nump;
           and x.pp003nump = lc_pp1nump
           
           
           and (t.d602mo, t.d602tr) not in --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
    
    --- Distribución de pago, mód 200
    lv_cap := 0;
    lv_int := 0;
    lv_icv := 0;
    lv_mor := 0;
    lv_seg := 0;
    lv_rub := 0;
    lv_gas  := 0; 
          
    begin
      -- Call the procedure
      pq_cr_movcre_fsh016.sp_cr_mov_fsh016(pn_emp => pn_cod,
                                           pn_mod => pn_mod,
                                           pn_suc => pn_suc,
                                           pn_mda => pn_mda,
                                           pn_pap => pn_pap,
                                           pn_cta => pn_cta,
                                           pn_ope => pn_ope,
                                           pn_sbo => pn_sbo,
                                           pn_top => pn_top,
                                           pd_fpp => pn_fecha, --- Fecha proceso
                                           pd_fec => lc_fsis, --- Fecha sistema
                                           pd_fei => null,    --- Fecha de inicio de cálculo
                                           pc_ind => 'U',       --- Indicador último pago
                                           pv_cap => lv_cap, --- capital
                                           pv_int => lv_int, --- interés
                                           pv_icv => lv_icv, --- interés compensatorio
                                           pv_mor => lv_mor, --- mora / pendalidad
                                           pv_seg => lv_seg, --- segurs
                                           pv_rub => lv_rub, --- rubr
                                           pv_gas => lv_gas); --- otros gastos
    
    lv_gas := lv_gas + lv_seg;
    
    exception
      when others then
        
      lv_cap := 0;
      lv_int := 0;
      lv_icv := 0;
      lv_mor := 0;
      lv_seg := 0;
      lv_rub := 0;
      lv_gas  := 0;     
                 
    end;
    
    pn_gas := pn_gas + lv_gas;
    pn_mor := pn_mor + lv_mor;
    pn_int := pn_int + lv_int;
    pn_cuo := pn_cuo + lv_cap;
    pn_icv := pn_icv + lv_icv;
    pn_pen := pn_pen + lv_mor;    
    
    -- sumatoria
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago;
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
                               pn_usuario in char,
                               --pn_dcon  in char,
                               pn_est   in number,
                               pn_ufech in date,
                               
                               pn_rubr out char,
                               pn_resp out char) is
  
    lx_rubro     char(4);
    lx_fecha_ant date;
    lx_fecha_act date;
    lx_rub       char(4);
  
  begin
  
    select x.pgfape into lx_fecha_act from fst017 x where x.pgcod = 1;
  
    if lx_fecha_act <> pn_fecha then
    
      begin
        select substr(p.aqpb070arubr, 1, 4)
          into lx_rub
          from aqpb070a p
         where p.aqpb070ausur = pn_usuario
           and p.aqpb070aemp = pn_cod
              --and p.aqpb070amod = pn_mod  -- jrodriguej 30.07.2021
              --and p.aqpb070asuc = pn_suc  -- jrodriguej 28.06.2021
           and p.aqpb070amda = pn_mda
           and p.aqpb070apap = pn_pap
           and p.aqpb070acta = pn_cta
           and p.aqpb070aoper = pn_ope
              --and p.bcsbop = pn_sbo
              --and p.aqpb070atop = pn_top
           and p.aqpb070afech = pn_fecha;
      exception
        when others then
          lx_rub := null;
      end;
    else
    
      begin
        select substr(p.scrub, 1, 4)
          into lx_rub
          from fsd011 p
         where p.pgcod = pn_cod
           and p.scmod = pn_mod
           and p.scsuc = pn_suc
           and p.scmda = pn_mda
           and p.scpap = pn_pap
           and p.sccta = pn_cta
           and p.scoper = pn_ope
           and p.scsbop = pn_sbo
           and p.sctope = pn_top;
      exception
        when others then
          lx_rub := null;
      end;
    
    end if;
  
    if pn_est = 99 and lx_rub is null then
    
      lx_rubro := '';
      pn_resp := 'CNC';
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
    else
      begin
        lx_rubro := substr(lx_rub, 1, 4);
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
    
    lc_fsis date;    
        
    lv_cap number(16,2); --- capital
    lv_int number(16,2); --- interés
    lv_icv number(16,2); --- interés compensatorio
    lv_mor number(16,2); --- mora / pendalidad
    lv_seg number(16,2); --- segurs
    lv_rub number(16,2); --- rubr
    lv_gas number(16,2); --- otros gastos 
    
    lx_shon number(16,2); --pago honrados 
    lx_shon_ext number(16,2); --extornos honrados
        
    lr_cod  NUMBER(3);
    lr_mod  NUMBER(3);
    lr_suc  NUMBER(3);
    lr_mda  NUMBER(4);
    lr_pap  NUMBER(4);
    lr_cta  NUMBER(9);
    lr_oper NUMBER(9);
    lr_sbop NUMBER(3);
    lr_tope NUMBER(3);        
  
  begin
    
    -- Fecha del sistema
    select x.pgfape into lc_fsis from fst017 x where x.pgcod = 1;    
  
    -- clave anterior al mod 200
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into lr_cod,
               lr_mod,
               lr_suc,
               lr_mda,
               lr_pap,
               lr_cta,
               lr_oper,
               lr_sbop,
               lr_tope
          from (select x.pgcod,
                       x.aomod,
                       x.aosuc,
                       x.aomda,
                       x.aopap,
                       x.aocta,
                       x.aooper,
                       x.aosbop,
                       x.aotope
                  from fsd010 x
                 where x.pgcod = pn_cod
                   and x.aomda = pn_mda
                   and x.aopap = pn_pap
                   and x.aocta = pn_cta
                   and x.aooper = pn_ope
                   and x.aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 120, 144, 200))
                 order by x.aosbop desc) f
         where rownum = 1;
      exception
        when others then
          lr_cod  := null;
          lr_mod  := null;
          lr_suc  := null;
          lr_mda  := null;
          lr_pap  := null;
          lr_cta  := null;
          lr_oper := null;
          lr_sbop := null;
          lr_tope := null;
      end;  
      
  
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
         
         and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 2
                 and x.tp1corr3 > 0)          
         
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
           
           and (t.d602mo, t.d602tr) not in    --- jrodriguej 12.08.2021
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 2
                   and x.tp1corr3 > 0)             
           
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
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
           
           and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
           
           and (t.d602mo, t.d602tr) not in         --- jrodriguej 12.08.2021
               (select j.tp1nro1, j.tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 2
                   and j.tp1corr3 > 0)
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
    
    -- nuevo calculo de pago capital interes mora penalidad similar al saldo insoluto 29/09/2022 RMR
    --capital e interes
    begin
      select nvl(sum(t.pp1cap), 0), nvl(sum(t.pp1int), 0)
          into pn_cuo, pn_int
          
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
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
           and t.ppsuc in (select p.sucurs
                               from fst001 p
                              where p.pgcod = 1
                                and p.sucurs < 800)
           
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
          pn_mor := 0;
          pn_icv := 0;
          pn_gas := 0;
      end;
      
    --- Penalidad
      begin
        select nvl(sum(x.pp003imp), 0)
          into pn_pen
          from fpp003 x, FSD602 t
         where 
           x.pgcod = t.pgcod        --- jrodriguej 12.08.2021
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
           --and x.pptope = pn_top
           
           and t.ppsuc in (select p.sucurs
                               from fst001 p
                              where p.pgcod = 1
                                and p.sucurs < 800)
           
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
          pn_pen := 0;
      end;
    
    --- Distribución de pago, mód 200
    lv_cap := 0;
    lv_int := 0;
    lv_icv := 0;
    lv_mor := 0;
    lv_seg := 0;
    lv_rub := 0;
    lv_gas  := 0; 
          
    begin
      -- Call the procedure
      pq_cr_movcre_fsh016.sp_cr_mov_fsh016(pn_emp => pn_cod,
                                           pn_mod => pn_mod,
                                           pn_suc => pn_suc,
                                           pn_mda => pn_mda,
                                           pn_pap => pn_pap,
                                           pn_cta => pn_cta,
                                           pn_ope => pn_ope,
                                           pn_sbo => pn_sbo,
                                           pn_top => pn_top,
                                           pd_fpp => pn_fecha, --- Fecha proceso
                                           pd_fec => lc_fsis, --- Fecha sistema
                                           pd_fei => lc_fini,    --- Fecha de inicio de cálculo
                                           pc_ind => null,       --- Indicador último pago
                                           pv_cap => lv_cap, --- capital
                                           pv_int => lv_int, --- interés
                                           pv_icv => lv_icv, --- interés compensatorio
                                           pv_mor => lv_mor, --- mora / pendalidad
                                           pv_seg => lv_seg, --- segurs
                                           pv_rub => lv_rub, --- rubr
                                           pv_gas => lv_gas); --- otros gastos
    
    lv_gas := lv_gas + lv_seg;
    
    exception
      when others then
        
      lv_cap := 0;
      lv_int := 0;
      lv_icv := 0;
      lv_mor := 0;
      lv_seg := 0;
      lv_rub := 0;
      lv_gas  := 0;     
                 
    end;
    -- pagos honrados
     begin
          select nvl(sum(x.HCIMP1),0) into lx_shon
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
               
               and x.HFCON >= lc_fini
               and x.HFCON <= pn_fecha
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
    
     -- extornos honrados
     begin
          select nvl(sum(x.HCIMP1),0) into lx_shon_ext
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
               
               and x.HFCON >= lc_fini
               and x.HFCON <= pn_fecha
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
    
    pn_gas := pn_gas + lv_gas;
    pn_mor := pn_mor + lv_mor;
    pn_int := pn_int + lv_int;
    pn_cuo := pn_cuo + lv_cap + lx_shon - lx_shon_ext;
    pn_icv := pn_icv + lv_icv;
    pn_pen := pn_pen + lv_mor;   
        
    --- Sumatoria total
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago_mes;
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
    
    lc_fsis date;    
        
    lv_cap number(16,2); --- capital
    lv_int number(16,2); --- interés
    lv_icv number(16,2); --- interés compensatorio
    lv_mor number(16,2); --- mora / pendalidad
    lv_seg number(16,2); --- segurs
    lv_rub number(16,2); --- rubr
    lv_gas number(16,2); --- otros gastos  
        
    lr_cod  NUMBER(3);
    lr_mod  NUMBER(3);
    lr_suc  NUMBER(3);
    lr_mda  NUMBER(4);
    lr_pap  NUMBER(4);
    lr_cta  NUMBER(9);
    lr_oper NUMBER(9);
    lr_sbop NUMBER(3);
    lr_tope NUMBER(3);      
  
  begin

    -- Fecha del sistema
    select x.pgfape into lc_fsis from fst017 x where x.pgcod = 1;    
  
    -- clave anterior al mod 200
      begin
        select f.pgcod,
               f.aomod,
               f.aosuc,
               f.aomda,
               f.aopap,
               f.aocta,
               f.aooper,
               f.aosbop,
               f.aotope
          into lr_cod,
               lr_mod,
               lr_suc,
               lr_mda,
               lr_pap,
               lr_cta,
               lr_oper,
               lr_sbop,
               lr_tope
          from (select x.pgcod,
                       x.aomod,
                       x.aosuc,
                       x.aomda,
                       x.aopap,
                       x.aocta,
                       x.aooper,
                       x.aosbop,
                       x.aotope
                  from fsd010 x
                 where x.pgcod = pn_cod
                   and x.aomda = pn_mda
                   and x.aopap = pn_pap
                   and x.aocta = pn_cta
                   and x.aooper = pn_ope
                   and x.aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (29, 120, 144, 200))
                 order by x.aosbop desc) f
         where rownum = 1;
      exception
        when others then
          lr_cod  := null;
          lr_mod  := null;
          lr_suc  := null;
          lr_mda  := null;
          lr_pap  := null;
          lr_cta  := null;
          lr_oper := null;
          lr_sbop := null;
          lr_tope := null;
      end;  
      

  -- Inicio de procedimiento
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
    
    --- Distribución de pago, mód 200
    lv_cap := 0;
    lv_int := 0;
    lv_icv := 0;
    lv_mor := 0;
    lv_seg := 0;
    lv_rub := 0;
    lv_gas  := 0; 
          
    begin
      -- Call the procedure
      pq_cr_movcre_fsh016.sp_cr_mov_fsh016(pn_emp => pn_cod,
                                           pn_mod => pn_mod,
                                           pn_suc => pn_suc,
                                           pn_mda => pn_mda,
                                           pn_pap => pn_pap,
                                           pn_cta => pn_cta,
                                           pn_ope => pn_ope,
                                           pn_sbo => pn_sbo,
                                           pn_top => pn_top,
                                           pd_fpp => pn_fecha, --- Fecha proceso
                                           pd_fec => lc_fsis, --- Fecha sistema
                                           pd_fei => null,    --- Fecha de inicio de cálculo
                                           pc_ind => null,       --- Indicador último pago
                                           pv_cap => lv_cap, --- capital
                                           pv_int => lv_int, --- interés
                                           pv_icv => lv_icv, --- interés compensatorio
                                           pv_mor => lv_mor, --- mora / pendalidad
                                           pv_seg => lv_seg, --- segurs
                                           pv_rub => lv_rub, --- rubr
                                           pv_gas => lv_gas); --- otros gastos
    
    lv_gas := lv_gas + lv_seg;
    
    exception
      when others then
        
      lv_cap := 0;
      lv_int := 0;
      lv_icv := 0;
      lv_mor := 0;
      lv_seg := 0;
      lv_rub := 0;
      lv_gas  := 0;     
                 
    end;
    
    pn_gas := pn_gas + lv_gas;
    pn_mor := pn_mor + lv_mor;
    pn_int := pn_int + lv_int;
    pn_cuo := pn_cuo + lv_cap;
    pn_icv := pn_icv + lv_icv;
    pn_pen := pn_pen + lv_mor; 
        
    -- Sumatoria Total
    pn_tsum := (pn_gas + pn_mor + pn_int + pn_cuo + pn_icv + pn_pen);
  
  end sp_distribuc_pago_tot;
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
end pq_cr_reporte_fondos_p200;
/

