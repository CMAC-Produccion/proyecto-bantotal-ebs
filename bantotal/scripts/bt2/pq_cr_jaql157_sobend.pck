create or replace package PQ_CR_JAQL157_SOBEND is

  function fn_cr_cuota_sf(p_d_fectra in date,
                          p_c_tippas in varchar2,
                          p_n_valcuo in number) return number;

  function fn_cr_clasif_sbs(p_n_calif0 in number,
                            p_n_calif1 in number,
                            p_n_calif2 in number,
                            p_n_calif3 in number,
                            p_n_calif4 in number) return number;

  procedure sp_cr_calc_ratio(p_c_tipcli  in varchar2,
                            p_c_tippas  in varchar2,
                            p_n_resntf  in number,
                            p_n_resnts  in number,
                            p_n_perccm3 in number,
                            p_n_perccm5 in number,
                            p_n_perccm2 in number,
                            p_n_perccm7 in number,
                            p_n_perccm4 in number,
                            p_n_percsf3 in number,
                            p_n_percsf5 in number,
                            p_n_percsf2 in number,
                            p_n_percsf7 in number,
                            p_n_percsf4 in number,
                            p_n_percff3 in number,
                            p_n_percff5 in number,
                            p_n_percff2 in number,
                            p_n_percff7 in number,
                            p_n_percff4 in number,
                            p_n_percfc3 in number,
                            p_n_percfc5 in number,
                            p_n_percfc2 in number,
                            p_n_percfc7 in number,
                            p_n_percfc4 in number,
                            p_n_conccm3 in number,
                            p_n_conccm5 in number,
                            p_n_conccm2 in number,
                            p_n_conccm7 in number,
                            p_n_conccm4 in number,
                            p_n_concsf3 in number,
                            p_n_concsf5 in number,
                            p_n_concsf2 in number,
                            p_n_concsf7 in number,
                            p_n_concsf4 in number,
                            p_n_concff3 in number,
                            p_n_concff5 in number,
                            p_n_concff2 in number,
                            p_n_concff7 in number,
                            p_n_concff4 in number,
                            p_n_concfc3 in number,
                            p_n_concfc5 in number,
                            p_n_concfc2 in number,
                            p_n_concfc7 in number,
                            p_n_concfc4 in number,
                            ln_val01 out number);

  procedure sp_cr_ult_evaluacion_cre(p_in_pgcod in number,
                              p_in_sucur in number,
                              p_in_mda in number,
                              p_in_pap in number,
                              p_in_cta in number,
                              p_in_oper in number,
                              p_in_mod in number,
                              p_in_fecha in date,
                              p_on_eva out number,
                              p_on_sol out number,
                              p_on_tpa out number);

  procedure sp_cr_ult_evaluacion_cli(p_n_pais in number,
                                    p_n_tipdoc in number,
                                    p_c_numdoc in varchar2,                              
                                    p_in_fecha in date,
                                    p_in_tipcli in char,                                    
                                    p_on_eva out number,
                                    p_on_sol out number,
                                    p_on_tpa out number);

  function fn_cr_cliente_registrado(p_d_fectra in date,
                                    p_n_pais in number,
                                    p_n_tipdoc in number,
                                    p_n_numdoc in number) return char;

  function fn_cr_tipdoc_sbs(p_c_tipdoc in number,
                           p_c_numdoc in varchar2) return varchar;

  function fn_cr_cred_no_desem(p_n_pais in number,
                               p_n_tipdoc in number,
                               p_n_numdoc in number,
                               p_in_fecha in date,
                               p_n_tipcam in number) return number;

  function fn_cr_existe_datos(p_n_anopro number, p_n_mespro number) return char;

  function fn_cr_mtocon(p_c_numins in varchar2,
                        p_n_tipcam in number) return number;

  function fn_cr_numref(p_in_pgcod in number,
                        p_in_sucur in number,
                        p_in_mda in number,
                        p_in_pap in number,
                        p_in_cta in number,
                        p_in_oper in number,
                        p_in_sbop in number,
                        p_in_tope in number,
                        p_in_mod in number) return number deterministic;

  function fn_cr_cuota_imp(p_in_pgcod in number,
                           p_in_sucur in number,
                           p_in_mda in number,
                           p_in_pap in number,
                           p_in_cta in number,
                           p_in_oper in number,
                           p_in_tope in number,
                           p_in_mod in number,
                           P_D_FECHA in date) return number;

  function fn_cr_valdat(p_c_tipval in varchar2,
                        p_c_anopro in varchar2,
                        p_c_mespro in varchar2,
                        p_c_codpas in varchar2) return number;

  function fn_cr_crit_pyme(p_c_tipval in varchar2,
                           p_c_anopro in varchar2,
                           p_c_mespro in varchar2,
                           p_c_codpas in varchar2,
                           p_c_codsec in varchar2,
                           p_c_codact in varchar2,
                           p_c_clasbs in varchar2) return number;

  function fn_cr_crit_cons(p_c_tipval in varchar2,
                          p_c_anopro in varchar2,
                          p_c_mespro in varchar2,
                          p_c_codpas in varchar2,
                          p_c_codsec in varchar2,
                          p_n_ingnet in number) return number;


  procedure sp_cr_dias_mora(p_d_fecha in date,
                            p_in_pgcod in number,
                            p_in_scsuc in number,
                            p_in_scmda in number,
                            p_in_scpap in number,
                            p_in_sccta in number,
                            p_in_scoper in number,
                            p_in_scsbop in number,
                            p_in_sctope in number,
                            p_in_scmod in number,
                            p_in_diamora out number);

  procedure sp_cr_conyuge(p_n_pais   in number,
                          p_n_tipdoc in number,
                          p_c_numdoc in char,
                          p_n_pais_c   out varchar2,
                          p_n_tipdoc_c out varchar2,
                          p_c_numdoc_c out varchar2);

  procedure sp_cr_tipo_cliente(p_n_cuosf3 in number,
                              p_n_cuosf5 in number,
                              p_n_cuosf2 in number,
                              p_n_cuosf7 in number,
                              p_n_cuosf4 in number,
                              p_n_cuocm3 in number,
                              p_n_cuocm5 in number,
                              p_n_cuocm2 in number,
                              p_n_cuocm7 in number,
                              p_n_cuocm4 in number,
                              p_n_tipmod in number,
                              p_c_tipcli out varchar2,
                              p_c_tippas out varchar2);

  function fn_cr_tipo_cliente_cmac(p_n_salcap3 in number,
                                           p_n_salcap5 in number,
                                           p_n_salcap2 in number,
                                           p_n_salcap7 in number,
                                           p_n_salcap4 in number
                                           ) return char;

  procedure sp_cr_datos_sistema_financiero(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_camemp out number,
                                           p_n_credir out number,
                                           p_n_intdev out number,
                                           p_n_avaoto out number,
                                           p_n_carfia out number,
                                           p_n_carcre out number,
                                           p_n_aceban out number,
                                           p_n_linuti out number,
                                           p_n_hipote out number,
                                           p_n_calif0 out number,
                                           p_n_calif1 out number,
                                           p_n_calif2 out number,
                                           p_n_calif3 out number,
                                           p_n_calif4 out number,
                                           p_n_cuosf3 out number,
                                           p_n_cuosf5 out number,
                                           p_n_cuosf2 out number,
                                           p_n_cuosf7 out number,
                                           p_n_cuosf4 out number,
                                           p_n_cuoff3 out number,
                                           p_n_cuoff5 out number,
                                           p_n_cuoff2 out number,
                                           p_n_cuoff7 out number,
                                           p_n_cuoff4 out number);

  function fn_cr_calificacion_sbs(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_modulo in number
                                           ) return number;
                                           
  function fn_cr_tipo_credito(p_n_rub in number,
                                           p_c_tippas in varchar2  
                                           ) return char;

  function fn_cr_tipo_credito_sbs(p_c_tipdoc in varchar2,
                                           p_c_numdoc in varchar2,
                                           p_c_tippas in varchar2
                                           ) return char;

  function fn_cr_tipo_credito_cmac(p_n_salcap3 in number,
                                           p_n_salcap5 in number,
                                           p_n_salcap2 in number,
                                           p_n_salcap7 in number,
                                           p_n_salcap4 in number
                                           ) return char;

  function fn_cr_nivel_sobend_ant(p_n_ratdet in number,
                                           p_n_nument in number,
                                           p_n_calsbs in number,
                                           p_c_tippro in char,
                                           p_n_deutot in number,
                                           p_n_patrim in number,
                                           p_n_monmax in number,
                                           p_n_ingnet in number
                                           ) return char;

  function fn_cr_nivel_sobend(p_n_ratdet in number,
                                           p_n_nument in number,
                                           p_n_calsbs in number,
                                           p_c_tippro in char,
                                           p_n_deutot in number,
                                           p_n_patrim in number,
                                           p_n_monmax in number,
                                           p_n_ingnet in number,
                                           p_c_tipsbs in char,
                                           p_c_sececo in char,
                                           p_n_subpeq in char
                                           ) return char;

  function fn_cr_criterio_sobend(p_n_ratdet in number,
                                           p_n_nument in number,
                                           p_n_calsbs in number,
                                           p_c_tippro in char,
                                           p_n_deutot in number,
                                           p_n_patrim in number,
                                           p_n_monmax in number,
                                           p_n_ingnet in number,
                                           p_c_tipsbs in char,
                                           p_c_sececo in char,
                                           p_n_subpeq in char,
                                           p_n_criapl in char
                                           ) return char;

  function fn_cr_ratio_end(p_n_deutot in number,
                                           p_n_patrim in number,
                                           p_n_monmax in number,
                                           p_n_ingnet in number,
                                           p_c_tippas in varchar                                           
                                           ) return number;

  function fn_cr_ultimo_resnet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number,
                                           p_n_tipcam in number
                                           ) return number;

  function fn_cr_ultimo_ratdet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number
                                           ) return number;

  function fn_cr_ultimo_ingnet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number,
                                           p_n_tipcam in number
                                           ) return number;

  function fn_cr_tipocambio(p_in_fecha date) return number;

  procedure sp_cr_datos_evaluaciones(p_n_pais   in number,
                                     p_n_tipdoc in number,
                                     p_c_numdoc in char,
                                     p_c_tipcli in char,
                                     p_n_soles out number,
                                     p_n_dolares out number,
                                     p_n_egfsol out number,
                                     p_n_egfdol out number,
                                     p_n_patsol out number,
                                     p_n_patdol out number,
                                     p_n_patsol1 out number,
                                     p_n_patdol1 out number,
                                     p_n_vensol out number,
                                     p_n_vendol out number,
                                     p_n_resnsol out number,
                                     p_n_resndol out number,
                                     P_D_FECHA in date);

  procedure sp_cr_ultimo(p_c_tipval in varchar2,
                        p_d_fectra in date,
                        p_c_mespro out varchar2,
                        p_c_anopro out varchar2);

  procedure sp_cr_datos_cmac1(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac2(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac3(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac4(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac5(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac6(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac7(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac8(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac9(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac10(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac11(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_datos_cmac12(p_n_pais in number,
                             p_n_tipdoc in number,
                             p_c_numdoc in varchar2,
                             p_n_tipcam in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date);

  procedure sp_cr_intdeveng(p_n_rubro in number,
                             p_n_pgcod in number,
                             p_n_scsuc in number,
                             p_n_scmda in number,
                             p_n_scpap in number,
                             p_n_sccta in number,
                             p_n_scoper in number,
                             p_n_scsbop in number,
                             p_n_intdev out number);

  function fn_cr_codsbs(p_c_tipdoc in number,
                        p_c_numdoc in char) return varchar;

  function fn_cr_nument(p_c_tipdoc in number,
                        p_c_numdoc in char,
                        p_n_anio in number,
                        p_n_mes in number) return number;

  procedure sp_cr_sobreend_jaql154(p_d_fecha in date,
                                   p_n_regini in number,
                                   p_n_regfin in number);

  procedure sp_cr_sobreend_jaql157(p_fecpre in date,
                                   p_n_regini in number,
                                   p_n_regfin in number);

end PQ_CR_JAQL157_SOBEND;
/

create or replace package body PQ_CR_JAQL157_SOBEND is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------
  -- SOBREENDEUDAMIENTO --
  ---------------------------------------
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_cuota_sf(P_D_FECTRA in date,
                          P_C_TIPPAS in varchar2,
                          P_N_VALCUO in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CUOTA_SF
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Calcular cuota del sistema financiero
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Retorno                    : Monto de cuota sistema financiero
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    lc_mespro varchar2(2);
    lc_anopro varchar2(4);
    ln_valdur jaql664.jaql664vdat%type;
    ln_valTEA jaql664.jaql664vdat%type;
    ln_valTEM jaql664.jaql664vdat%type;

  begin

    if nvl(P_N_VALCUO, 0) <> 0 then
      --obtener duración sistema financiero
      PQ_CR_JAQL157_SOBEND.sp_cr_ultimo(p_c_tipval => 'DUR',
                                 p_d_fectra => P_D_FECTRA,
                                 p_c_mespro => lc_mespro,
                                 p_c_anopro => lc_anopro);

      ln_valdur := PQ_CR_JAQL157_SOBEND.fn_cr_valdat(p_c_tipval => 'DUR',
                                              p_c_anopro => lc_anopro,
                                              p_c_mespro => lc_mespro,
                                              p_c_codpas => P_C_TIPPAS);

      --obtener TEA sistema finaciero
      PQ_CR_JAQL157_SOBEND.sp_cr_ultimo(p_c_tipval => 'TEA',
                                 p_d_fectra => P_D_FECTRA,
                                 p_c_mespro => lc_mespro,
                                 p_c_anopro => lc_anopro);

      ln_valTEA := PQ_CR_JAQL157_SOBEND.fn_cr_valdat(p_c_tipval => 'TEA',
                                              p_c_anopro => lc_anopro,
                                              p_c_mespro => lc_mespro,
                                              p_c_codpas => P_C_TIPPAS);

      ln_valTEM := (power(1 + ln_valTEA, 1 / 12) - 1);

      return P_N_VALCUO *((power(1 + ln_valTEM, ln_valdur) * ln_valTEM) /
                          (power(1 + ln_valTEM, ln_valdur) - 1));
    else
      return 0;
    end if;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_clasif_SBS(P_N_CALIF0 in number,
                            P_N_CALIF1 in number,
                            P_N_CALIF2 in number,
                            P_N_CALIF3 in number,
                            P_N_CALIF4 in number) return number
  -- ****************************************************************
    -- Nombre                     : FN_CR_CLASIF_SBS
    -- Módulo                     : Creditos
    -- Sistema                    : BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Clasificacion SBS de cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CALIF0 (CALIFICACION 0)
    --                              P_N_CALIF1 (CALIFICACION 1)
    --                              P_N_CALIF2 (CALIFICACION 2)
    --                              P_N_CALIF3 (CALIFICACION 3)
    --                              P_N_CALIF4 (CALIFICACION 4)
    -- Retorno                    : Clasificación SBS
    -- Fecha de Modificación      :
    -- Autor de Modificación      :
    -- Descripción de Modificación:
    -- ****************************************************************
  is
    ln_clasbs number(10);
  begin
    ln_clasbs := 0;
    if P_N_CALIF0 >= 20 then
      ln_clasbs := 0;
    end if;
    if P_N_CALIF1 >= 20 then
      ln_clasbs := 1;
    end if;
    if P_N_CALIF2 >= 20 then
      ln_clasbs := 2;
    end if;
    if P_N_CALIF3 >= 20 then
      ln_clasbs := 3;
    end if;
    if P_N_CALIF4 >= 20 then
      ln_clasbs := 4;
    end if;

    return ln_clasbs;

  end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_calc_ratio(P_C_TIPCLI  in varchar2,
                            P_C_TIPPAS  in varchar2,
                            P_N_RESNTF  in number,
                            P_N_RESNTS  in number,
                            P_N_PERCCM3 in number,
                            P_N_PERCCM5 in number,
                            P_N_PERCCM2 in number,
                            P_N_PERCCM7 in number,
                            P_N_PERCCM4 in number,
                            P_N_PERCSF3 in number,
                            P_N_PERCSF5 in number,
                            P_N_PERCSF2 in number,
                            P_N_PERCSF7 in number,
                            P_N_PERCSF4 in number,
                            P_N_PERCFF3 in number,
                            P_N_PERCFF5 in number,
                            P_N_PERCFF2 in number,
                            P_N_PERCFF7 in number,
                            P_N_PERCFF4 in number,
                            P_N_PERCFC3 in number,
                            P_N_PERCFC5 in number,
                            P_N_PERCFC2 in number,
                            P_N_PERCFC7 in number,
                            P_N_PERCFC4 in number,
                            P_N_CONCCM3 in number,
                            P_N_CONCCM5 in number,
                            P_N_CONCCM2 in number,
                            P_N_CONCCM7 in number,
                            P_N_CONCCM4 in number,
                            P_N_CONCSF3 in number,
                            P_N_CONCSF5 in number,
                            P_N_CONCSF2 in number,
                            P_N_CONCSF7 in number,
                            P_N_CONCSF4 in number,
                            P_N_CONCFF3 in number,
                            P_N_CONCFF5 in number,
                            P_N_CONCFF2 in number,
                            P_N_CONCFF7 in number,
                            P_N_CONCFF4 in number,
                            P_N_CONCFC3 in number,
                            P_N_CONCFC5 in number,
                            P_N_CONCFC2 in number,
                            P_N_CONCFC7 in number,
                            P_N_CONCFC4 in number,
                            ln_val01 out number)  is
    -- *****************************************************************
    -- Nombre                     : SP_CR_RATIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Calcular ratio determinante
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

  ln_val02 number(17, 2);

  begin

    -- cálculo por tipo de cliente
    case
      when P_C_TIPCLI = 'P' then
        -- PYMES

        ln_val01 := nvl(P_N_PERCCM3, 0) + nvl(P_N_PERCCM5, 0) +
                    nvl(P_N_PERCSF3, 0) + nvl(P_N_PERCSF5, 0) +
                    nvl(P_N_PERCFF3, 0) + nvl(P_N_PERCFF5, 0) +
                    nvl(P_N_PERCFC3, 0) + nvl(P_N_PERCFC5, 0) +
                    nvl(P_N_CONCCM3, 0) + nvl(P_N_CONCCM5, 0) +
                    nvl(P_N_CONCSF3, 0) + nvl(P_N_CONCSF5, 0) +
                    nvl(P_N_CONCFF3, 0) + nvl(P_N_CONCFF5, 0) +
                    nvl(P_N_CONCFC3, 0) + nvl(P_N_CONCFC5, 0);

        ln_val02 := ln_val01 - (nvl(P_N_PERCCM3, 0) + nvl(P_N_PERCCM5, 0) +
                    nvl(P_N_PERCFC3, 0) + nvl(P_N_PERCFC5, 0) +
                    nvl(P_N_CONCCM3, 0) + nvl(P_N_CONCCM5, 0) +
                    nvl(P_N_CONCFC3, 0) + nvl(P_N_CONCFC5, 0));

        if nvl(P_N_RESNTF, 0) + ln_val02 <> 0 then
         ln_val01 := ln_val01 /(nvl(P_N_RESNTF, 0) + ln_val02);
        else
         ln_val01 := 0;
        end if;

      when P_C_TIPCLI = 'C' then
        -- Consumo
        ln_val01 := nvl(P_N_PERCCM2, 0) + nvl(P_N_PERCCM7, 0) +
                    nvl(P_N_PERCSF2, 0) + nvl(P_N_PERCSF7, 0) +
                    nvl(P_N_PERCFC2, 0) + nvl(P_N_PERCFC7, 0) +
                    nvl(P_N_PERCFF2, 0) + nvl(P_N_PERCFF7, 0) +
                    nvl(P_N_CONCCM2, 0) + nvl(P_N_CONCCM7, 0) +
                    nvl(P_N_CONCSF2, 0) + nvl(P_N_CONCSF7, 0) +
                    nvl(P_N_CONCFC2, 0) + nvl(P_N_CONCFC7, 0) +
                    nvl(P_N_CONCFF2, 0) + nvl(P_N_CONCFF7, 0);

        if nvl(P_N_RESNTS, 0) + ln_val01 <> 0 then
         ln_val01 := ln_val01 /(nvl(P_N_RESNTS, 0) + ln_val01);
        else
          ln_val01 := 0;
        end if;

      when P_C_TIPCLI = 'M' then
        -- Mixto

        if P_C_TIPPAS = 'P' then
          -- PYME

          ln_val01 := nvl(P_N_PERCCM3, 0) + nvl(P_N_PERCCM5, 0) +
                      nvl(P_N_PERCCM2, 0) + nvl(P_N_PERCCM7, 0) +
                      nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCSF3, 0) +
                      nvl(P_N_PERCSF5, 0) + nvl(P_N_PERCSF2, 0) +
                      nvl(P_N_PERCSF7, 0) + nvl(P_N_PERCSF4, 0) +
                      nvl(P_N_PERCFF3, 0) + nvl(P_N_PERCFF5, 0) +
                      nvl(P_N_PERCFF2, 0) + nvl(P_N_PERCFF7, 0) +
                      nvl(P_N_PERCFF4, 0) + nvl(P_N_PERCFC3, 0) +
                      nvl(P_N_PERCFC5, 0) + nvl(P_N_PERCFC2, 0) +
                      nvl(P_N_PERCFC7, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM3, 0) + nvl(P_N_CONCCM5, 0) +
                      nvl(P_N_CONCCM2, 0) + nvl(P_N_CONCCM7, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCSF3, 0) +
                      nvl(P_N_CONCSF5, 0) + nvl(P_N_CONCSF2, 0) +
                      nvl(P_N_CONCSF7, 0) + nvl(P_N_CONCSF4, 0) +
                      nvl(P_N_CONCFF3, 0) + nvl(P_N_CONCFF5, 0) +
                      nvl(P_N_CONCFF2, 0) + nvl(P_N_CONCFF7, 0) +
                      nvl(P_N_CONCFF4, 0) + nvl(P_N_CONCFC3, 0) +
                      nvl(P_N_CONCFC5, 0) + nvl(P_N_CONCFC2, 0) +
                      nvl(P_N_CONCFC7, 0) + nvl(P_N_CONCFC4, 0);

          ln_val02 := ln_val01 - (nvl(P_N_PERCCM3, 0) + nvl(P_N_PERCCM5, 0) +
                      nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCFC3, 0) +
                      nvl(P_N_PERCFC5, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM3, 0) + nvl(P_N_CONCCM5, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCFC3, 0) +
                      nvl(P_N_CONCFC5, 0) + nvl(P_N_CONCFC4, 0));

          if nvl(P_N_RESNTF, 0) + ln_val02 <> 0 then
            ln_val01 := ln_val01 /(nvl(P_N_RESNTF, 0) + ln_val02);
          else
            ln_val01 := 0;
          end if;

        elsif P_C_TIPPAS = 'C' then
          -- Consumo

          ln_val01 := nvl(P_N_PERCCM3, 0) + nvl(P_N_PERCCM5, 0) +
                      nvl(P_N_PERCCM2, 0) + nvl(P_N_PERCCM7, 0) +
                      nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCSF3, 0) +
                      nvl(P_N_PERCSF5, 0) + nvl(P_N_PERCSF2, 0) +
                      nvl(P_N_PERCSF7, 0) + nvl(P_N_PERCSF4, 0) +
                      nvl(P_N_PERCFF3, 0) + nvl(P_N_PERCFF5, 0) +
                      nvl(P_N_PERCFF2, 0) + nvl(P_N_PERCFF7, 0) +
                      nvl(P_N_PERCFF4, 0) + nvl(P_N_PERCFC3, 0) +
                      nvl(P_N_PERCFC5, 0) + nvl(P_N_PERCFC2, 0) +
                      nvl(P_N_PERCFC7, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM3, 0) + nvl(P_N_CONCCM5, 0) +
                      nvl(P_N_CONCCM2, 0) + nvl(P_N_CONCCM7, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCSF3, 0) +
                      nvl(P_N_CONCSF5, 0) + nvl(P_N_CONCSF2, 0) +
                      nvl(P_N_CONCSF7, 0) + nvl(P_N_CONCSF4, 0) +
                      nvl(P_N_CONCFF3, 0) + nvl(P_N_CONCFF5, 0) +
                      nvl(P_N_CONCFF2, 0) + nvl(P_N_CONCFF7, 0) +
                      nvl(P_N_CONCFF4, 0) + nvl(P_N_CONCFC3, 0) +
                      nvl(P_N_CONCFC5, 0) + nvl(P_N_CONCFC2, 0) +
                      nvl(P_N_CONCFC7, 0) + nvl(P_N_CONCFC4, 0);

          if nvl(P_N_RESNTS, 0) + ln_val01 <> 0 then
            ln_val01 := ln_val01 /(nvl(P_N_RESNTS, 0) + ln_val01);
          else
            ln_val01 := 0;
          end if;

        else
         ln_val01 := 0;

        end if;

      when P_C_TIPCLI = 'H' then
        -- Hipotecario

        if P_C_TIPPAS = 'P' then
          -- PYME

          ln_val01 := nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCSF4, 0) +
                      nvl(P_N_PERCFF4, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCSF4, 0) +
                      nvl(P_N_CONCFF4, 0) + nvl(P_N_CONCFC4, 0);

          ln_val02 := ln_val01 - (nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCFC4, 0));

          if nvl(P_N_RESNTF, 0) + ln_val02 <> 0 then
            ln_val01 := ln_val01 /(nvl(P_N_RESNTF, 0) + ln_val02);
          else
            ln_val01 := 0;
          end if;

        elsif P_C_TIPPAS = 'C' then
          -- Consumo

          ln_val01 := nvl(P_N_PERCCM4, 0) + nvl(P_N_PERCSF4, 0) +
                      nvl(P_N_PERCFF4, 0) + nvl(P_N_PERCFC4, 0) +
                      nvl(P_N_CONCCM4, 0) + nvl(P_N_CONCSF4, 0) +
                      nvl(P_N_CONCFF4, 0) + nvl(P_N_CONCFC4, 0);

          if nvl(P_N_RESNTS, 0) + ln_val01 <> 0 then
            ln_val01 := ln_val01 /(nvl(P_N_RESNTS, 0) + ln_val01);
          else
            ln_val01 := 0;
          end if;
        else
           ln_val01 := 0;

        end if;

      else
        ln_val01 := 0;

    end case;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_ult_evaluacion_cre( p_in_pgcod in number,
                              p_in_sucur in number,
                              p_in_mda in number,
                              p_in_pap in number,
                              p_in_cta in number,
                              p_in_oper in number,
                              p_in_mod in number,
                              p_in_fecha in date,
                              p_on_eva out number,
                              p_on_sol out number,                              
                              p_on_tpa out number) is
    -- ********************************************************************
    -- Nombre                     : sp_cr_ult_evaluacion_cre
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Fecha de Creación          : 2014.01.15
    -- Autor de Creación          : DRODRIGUEE
    -- Uso                        : Última número de evaluación de crédito
    -- Proyecto                   : 3303
    --
    -- ********************************************************************
  begin
  
    select sng021eval
    into p_on_eva
    from
    (
        select h.sng021eval, h.sng021fec
        from sng021 h, xwf700 x
        where x.xwfprcins = h.sng021sol
          and x.xwfempresa = p_in_pgcod
          and x.xwfsucursal = p_in_sucur       
          and x.xwfmoneda = p_in_mda         
          and x.xwfpapel = p_in_pap        
          and x.xwfcuenta = p_in_cta
          and x.xwfoperacion = p_in_oper
    --      and x.xwfsubope = p_in_sbop
    --      and x.xwftipope = p_in_tope
          and x.xwfmodulo = p_in_mod
          and h.sng021fec <= p_in_fecha       
          and x.xwfcar3 = '1'
          and x.xwfprcins <> 0 --drc PRY3303 (2)
          order by h.sng021fec desc    
    )
    where rownum = 1;

    select h1.sng021tmod, h1.sng021sol
    into p_on_tpa, p_on_sol
    from sng021 h1 
    where h1.sng021eval = p_on_eva;
    
  exception when others then
    p_on_eva := 0;
    p_on_sol := 0;
    p_on_tpa := 0;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_ult_evaluacion_cli( p_n_pais in number,
                                      p_n_tipdoc in number,
                                      p_c_numdoc in varchar2,                                      
                                      p_in_fecha in date,
                                      p_in_tipcli in char,
                                      p_on_eva out number,
                                      p_on_sol out number,                              
                                      p_on_tpa out number) is
    -- ********************************************************************
    -- Nombre                     : sp_cr_ult_evaluacion_cli
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Fecha de Creación          : 2014.01.15
    -- Autor de Creación          : DRODRIGUEE
    -- Uso                        : Última número de evaluación de cliente
    -- Proyecto                   : 3303
    --
    -- ********************************************************************                              
    
    ln_anio number := to_number(EXTRACT(YEAR FROM p_in_fecha));
    ln_mes number := to_number(EXTRACT(MONTH FROM p_in_fecha));
    
  begin

    --pyme
    if p_in_tipcli = 'P' then

      select sng021eval
      into p_on_eva
      from
      (
        select h.sng021eval, h.sng021fec
        from fsh014 f
        inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                    and f.hasuc = x.XWFSUCURSAL
                    and f.hamda = x.XWFMONEDA
                    and f.hapap = x.XWFPAPEL
                    and f.hacta = x.XWFCUENTA
                    and f.haoper = x.XWFOPERACION
    --                and f.hasbop = x.XWFSUBOPE
    --                and f.hatope = x.XWFTIPOPE
                    and f.hamod = x.XWFMODULO
        inner join sng021 h on x.xwfprcins = h.sng021sol
        where 
        f.pgcod = 1
        and r.cttfir = 'T'
        and x.xwfcar3 = '1'
        and f.haanio = ln_anio
        and ( f.hamod in (select /*+ PUSH_SUBQ */ modulo from fst111 where dscod = 50) or f.hamod  = 117 )
        and 
        (
          ( ln_mes = 1 and f.hasd01 <> 0 ) or 
          ( ln_mes = 2 and f.hasd02 <> 0 ) or 
          ( ln_mes = 3 and f.hasd03 <> 0 ) or
          ( ln_mes = 4 and f.hasd04 <> 0 ) or
          ( ln_mes = 5 and f.hasd05 <> 0 ) or
          ( ln_mes = 6 and f.hasd06 <> 0 ) or
          ( ln_mes = 7 and f.hasd07 <> 0 ) or
          ( ln_mes = 8 and f.hasd08 <> 0 ) or
          ( ln_mes = 9 and f.hasd09 <> 0 ) or
          ( ln_mes = 10 and f.hasd10 <> 0 ) or
          ( ln_mes = 11 and f.hasd11 <> 0 ) or
          ( ln_mes = 12 and f.hasd12 <> 0 )
        )
        and x.xwfprcins <> 0 --drc PRY3303 (2) 
        and r.pepais = p_n_pais
        and r.petdoc = p_n_tipdoc    
        and r.pendoc = p_c_numdoc
        and h.sng021tmod = 13
        order by h.sng021fec desc      
      )
      where rownum = 1;
    
    end if;


    --consumo
    if p_in_tipcli = 'C' then

      select sng021eval
      into p_on_eva
      from
      (
        select h.sng021eval, h.sng021fec
        from fsh014 f
        inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                    and f.hasuc = x.XWFSUCURSAL
                    and f.hamda = x.XWFMONEDA
                    and f.hapap = x.XWFPAPEL
                    and f.hacta = x.XWFCUENTA
                    and f.haoper = x.XWFOPERACION
    --                and f.hasbop = x.XWFSUBOPE
    --                and f.hatope = x.XWFTIPOPE
                    and f.hamod = x.XWFMODULO
        inner join sng021 h on x.xwfprcins = h.sng021sol
        where 
        f.pgcod = 1
        and r.cttfir = 'T'
        and x.xwfcar3 = '1'
        and f.haanio = ln_anio
        and ( f.hamod in (select /*+ PUSH_SUBQ */ modulo from fst111 where dscod = 50) or f.hamod  = 117 )
        and 
        (
          ( ln_mes = 1 and f.hasd01 <> 0 ) or 
          ( ln_mes = 2 and f.hasd02 <> 0 ) or 
          ( ln_mes = 3 and f.hasd03 <> 0 ) or
          ( ln_mes = 4 and f.hasd04 <> 0 ) or
          ( ln_mes = 5 and f.hasd05 <> 0 ) or
          ( ln_mes = 6 and f.hasd06 <> 0 ) or
          ( ln_mes = 7 and f.hasd07 <> 0 ) or
          ( ln_mes = 8 and f.hasd08 <> 0 ) or
          ( ln_mes = 9 and f.hasd09 <> 0 ) or
          ( ln_mes = 10 and f.hasd10 <> 0 ) or
          ( ln_mes = 11 and f.hasd11 <> 0 ) or
          ( ln_mes = 12 and f.hasd12 <> 0 )
        )
        and x.xwfprcins <> 0 --drc PRY3303 (2) 
        and r.pepais = p_n_pais
        and r.petdoc = p_n_tipdoc    
        and r.pendoc = p_c_numdoc
        and h.sng021tmod = 14
        order by h.sng021fec desc
      )
      where rownum = 1;
    
    end if;

    --hipotecario o mixto
    if p_in_tipcli <> 'P' and p_in_tipcli <> 'C' then
    
      select sng021eval
      into p_on_eva
      from
      (
        select h.sng021eval, h.sng021fec
        from fsh014 f
        inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                    and f.hasuc = x.XWFSUCURSAL
                    and f.hamda = x.XWFMONEDA
                    and f.hapap = x.XWFPAPEL
                    and f.hacta = x.XWFCUENTA
                    and f.haoper = x.XWFOPERACION
    --                and f.hasbop = x.XWFSUBOPE
    --                and f.hatope = x.XWFTIPOPE
                    and f.hamod = x.XWFMODULO
        inner join sng021 h on x.xwfprcins = h.sng021sol
        where 
        f.pgcod = 1
        and r.cttfir = 'T'
        and x.xwfcar3 = '1'
        and f.haanio = ln_anio
        and ( f.hamod in (select /*+ PUSH_SUBQ */ modulo from fst111 where dscod = 50) or f.hamod  = 117 )
        and 
        (
          ( ln_mes = 1 and f.hasd01 <> 0 ) or 
          ( ln_mes = 2 and f.hasd02 <> 0 ) or 
          ( ln_mes = 3 and f.hasd03 <> 0 ) or
          ( ln_mes = 4 and f.hasd04 <> 0 ) or
          ( ln_mes = 5 and f.hasd05 <> 0 ) or
          ( ln_mes = 6 and f.hasd06 <> 0 ) or
          ( ln_mes = 7 and f.hasd07 <> 0 ) or
          ( ln_mes = 8 and f.hasd08 <> 0 ) or
          ( ln_mes = 9 and f.hasd09 <> 0 ) or
          ( ln_mes = 10 and f.hasd10 <> 0 ) or
          ( ln_mes = 11 and f.hasd11 <> 0 ) or
          ( ln_mes = 12 and f.hasd12 <> 0 )
        )
        and x.xwfprcins <> 0 --drc PRY3303 (2) 
        and r.pepais = p_n_pais
        and r.petdoc = p_n_tipdoc    
        and r.pendoc = p_c_numdoc
        order by h.sng021fec desc      
      )
      where rownum = 1;    
    
    end if;
  
    select h1.sng021tmod, h1.sng021sol
    into p_on_tpa, p_on_sol
    from sng021 h1 
    where h1.sng021eval = p_on_eva;
    
  exception when others then
    p_on_eva := 0;
    p_on_sol := 0;
    p_on_tpa := 0;
  end;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_cliente_registrado(P_D_FECTRA in date,
                                    P_N_PAIS in Number,
                                    P_N_TIPDOC in Number,
                                    P_N_NUMDOC in Number) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_REGISTRADO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Credito - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Verifica si cliente se encuentra ya registrado en cabecera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Retiorno                   : S=SI/N=NO
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_existe char(1);
  begin

    select case
             when count(*) > 0 then
              'S'
             else
              'N'
           end
    into lc_existe
    from jaql157 j
    where j.jaql157pai = P_N_PAIS and
           j.jaql157tdo = P_N_TIPDOC and
           j.jaql157ndo = P_N_NUMDOC and
           j.jaql157fch = P_D_FECTRA;

    return lc_existe;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_tipdoc_sbs(P_C_TIPDOC in number,
                           P_C_NUMDOC in varchar2
                           ) return varchar is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TIPDOC_SBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos - Riesgo
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEE
    -- Uso                        : Obtener tipo de documento SBS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_TIPDOC (TIPO DE DOCUMENTO)
    --                              P_C_NUMDOC (NUMERO DE DOCUMENTO)
    -- Retorno                    : Tipo de documento SBS
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
  BEGIN
    IF P_C_TIPDOC IN (21) THEN
      RETURN '1';
    ELSIF P_C_TIPDOC IN (9) THEN
      IF LENGTH(P_C_NUMDOC) < 11 THEN
        RETURN '2';
      ELSE
        RETURN '3';
      end IF;
    ELSIF P_C_TIPDOC = 2 THEN
      RETURN '2';
    ELSIF P_C_TIPDOC = 4 THEN
      RETURN '3';
    ELSIF P_C_TIPDOC = 15 THEN
      RETURN '4';
    ELSIF P_C_TIPDOC = 5 THEN
      RETURN '5';
    ELSIF P_C_TIPDOC = 6 THEN
      RETURN '8';
    ELSE
      RETURN NULL;
    END IF;

  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_cred_no_desem(P_N_PAIS in Number,
                               P_N_TIPDOC in Number,
                               P_N_NUMDOC in Number,
                               P_IN_FECHA in date,
                               P_N_TIPCAM in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CRED_NO_DESEM
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Calcular monto de créditos no desembolsados vigentes 30 días
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_PAIS (PAIS DE PERSONA)
    --                              P_N_TIPDOC (TIPO DE DOCUMENTO DE PERSONA)
    --                              P_N_NUMDOC (NUMERO DE DOCUMENTO DE PERSONA)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Retorno                    : Monto de créditos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_monto number;
    ln_dias  number := 30;

  begin

    select (decode(f.SCMDA, 101, f.SCSDO * P_N_TIPCAM, f.SCSDO) * -1)
    into ln_monto
    from fsd011 f
    inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and s.sng001pais = P_N_PAIS
         and s.sng001tdoc = P_N_TIPDOC
         and s.sng001ndoc = P_N_NUMDOC
         and f.SCFVAL Between P_IN_FECHA - ln_dias and P_IN_FECHA;

    return(ln_monto);
  exception
    when others then
      return(0);
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_existe_datos(P_N_ANOPRO NUMBER, P_N_MESPRO NUMBER) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_EXISTE_DATOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Verificar la existencia de datos en JAQL157
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_ANOPRO (ANHO DE PROCESO)
    --                              P_N_MESPRO (MES DE PROCESO)
    -- Retorno                    : Existencia de datos (S,N)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************

    lc_existe char(1);
    ld_fectra date;

  begin

    ld_fectra := last_day(to_date(P_N_ANOPRO || '.' || P_N_MESPRO || '.01','yyyy.mm..dd'));

    select 'S'
      into lc_existe
      from jaql157 j
      where j.jaql157fch = ld_fectra
      and rownum = 1;

    return(lc_existe);
  exception
    when others then
      return('N');
  end;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_mtocon(P_C_NUMINS IN varchar2,
                        P_N_TIPCAM in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_MTOCON
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Garantias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener monto de constitución de las garantías
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Retorno                    : Monto de constitucion de la solicitud
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
  ln_mtosol number(17, 2);
  begin

  select distinct (decode(f.SCMDA, 101, f.SCSDO * P_N_TIPCAM, f.SCSDO) * -1)
  into ln_mtosol
  from fsd011 f
  inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                  and f.SCSUC = x.XWFSUCURSAL
                  and f.SCMDA = x.XWFMONEDA
                  and f.SCPAP = x.XWFPAPEL
                  and f.SCCTA = x.XWFCUENTA
                  and f.SCOPER = x.XWFOPERACION
                  and f.SCSBOP = x.XWFSUBOPE
                  and f.SCTOPE = x.XWFTIPOPE
                  and f.SCMOD = x.XWFMODULO
  inner join sng001 s on x.xwfprcins = s.sng001inst
  inner join fst111 c on f.SCMOD = c.modulo
  inner join fsr011 k on x.xwfempresa = k.r1cod
                    and x.xwfsucursal = k.r1suc
                    and x.xwfmodulo = k.r1mod
                    and x.xwfmoneda = k.r1mda
                    and x.xwfpapel = k.r1pap
                    and x.xwfcuenta = k.r1cta
                    and x.xwfoperacion = k.r1oper
                    and x.xwfsubope = k.r1sbop
  where x.xwfcar3 = '1'
  and f.SCSTAT <> 99
  and c.dscod = 50
  and k.r011co = 'S'
  and x.xwfprcins = P_C_NUMINS;

  return(ln_mtosol);

  exception
    when no_data_found then
      return(null);
  end;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_numref(P_IN_PGCOD in Number,
                        P_IN_SUCUR in Number,
                        P_IN_MDA in Number,
                        P_IN_PAP in Number,
                        P_IN_CTA in Number,
                        P_IN_OPER in Number,
                        P_IN_SBOP in Number,
                        P_IN_TOPE in Number,
                        P_IN_MOD in Number) RETURN number deterministic
 -- *****************************************************************
    -- Nombre                     : FN_CR_NUMREF
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos - Riesgo
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener numero de refinanciaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
  IS

    ln_numref number(3);

  BEGIN
    select count(*)
    into  ln_numref
    from fsd011 f
    inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                  and f.SCSUC = x.XWFSUCURSAL
                  and f.SCMDA = x.XWFMONEDA
                  and f.SCPAP = x.XWFPAPEL
                  and f.SCCTA = x.XWFCUENTA
                  and f.SCOPER = x.XWFOPERACION
                  and f.SCSBOP = x.XWFSUBOPE
                  and f.SCTOPE = x.XWFTIPOPE
                  and f.SCMOD = x.XWFMODULO
    inner join sng001 s on x.xwfprcins = s.sng001inst
    inner join fst111 c on f.SCMOD = c.modulo
    inner join fsr011 k on x.xwfempresa = k.r1cod
                    and x.xwfsucursal = k.r1suc
                    and x.xwfmodulo = k.r1mod
                    and x.xwfmoneda = k.r1mda
                    and x.xwfpapel = k.r1pap
                    and x.xwfcuenta = k.r1cta
                    and x.xwfoperacion = k.r1oper
                    and x.xwfsubope = k.r1sbop
    where x.xwfcar3 = '1'
    and f.SCSTAT <> 99
    and c.dscod = 50
    and k.r011co = 'S'
    and k.relcod = 120
    and f.PGCOD  = P_IN_PGCOD
    and f.SCSUC  = P_IN_SUCUR
    and f.SCMDA  = P_IN_MDA
    and f.SCPAP  = P_IN_PAP
    and f.SCCTA  = P_IN_CTA
    and f.SCOPER = P_IN_OPER
    and f.SCSBOP = P_IN_SBOP
    and f.SCTOPE = P_IN_TOPE
    and f.SCMOD  = P_IN_MOD;

    RETURN ln_numref;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_cuota_imp(P_IN_PGCOD in Number,
                           P_IN_SUCUR in Number,
                           P_IN_MDA in Number,
                           P_IN_PAP in Number,
                           P_IN_CTA in Number,
                           P_IN_OPER in Number,
                           P_IN_TOPE in Number,
                           P_IN_MOD in Number,
                           P_D_FECHA in date) return number is
    -- ****************************************************************
    -- Nombre                     : FN_CR_CUOTA_IMP
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Proceso retorna el monto de la 1era. cuota impaga
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.07.07
    -- Autor de Modificación      : DRODRIGUEE
    -- Descripción de Modificación: Considerar líneas de crédito paralelas
    -- ****************************************************************
  ln_moncuo number;
  ld_ppfpag date;
  ln_pppzo fsd601.pppzo%type;

  Begin

      select min(c.ppfpag)
      into ld_ppfpag
      from fsd601 c
      left outer join fsd602 d on
      c.pgcod = d.pgcod
      and c.ppmod = d.ppmod
      and c.ppsuc = d.ppsuc
      and c.ppmda = d.ppmda
      and c.pppap = d.pppap
      and c.ppcta = d.ppcta
      and c.ppoper = d.ppoper
      and c.ppsbop = d.ppsbop
      and c.pptope = d.pptope
      and c.ppfpag = d.ppfpag
      where c.ppcta = P_IN_CTA
      and c.ppmod = P_IN_MOD
      and c.PGCOD = P_IN_PGCOD
      and c.PPSUC = P_IN_SUCUR
      and c.PPMDA = P_IN_MDA
      and c.PPPAP = P_IN_PAP
      and c.PPOPER = P_IN_OPER
      and c.PPTOPE = P_IN_TOPE
      and c.d601co = 'S'
      and ( d.pgcod is null or d.PP1Fech > P_D_FECHA );

      select ppcap + ppint + ppintmex + ppicap + ppiint
      into ln_moncuo
      from fsd601 c
      where c.ppcta = P_IN_CTA
      and c.ppmod = P_IN_MOD
      and c.PGCOD = P_IN_PGCOD
      and c.PPSUC = P_IN_SUCUR
      and c.PPMDA = P_IN_MDA
      and c.PPPAP = P_IN_PAP
      and c.PPOPER = P_IN_OPER
      and c.PPTOPE = P_IN_TOPE
      and c.d601co = 'S'
      and c.ppfpag = ld_ppfpag;

      select max(o.aoperiod)
      into ln_pppzo
      from fsd010 o
      where o.pgcod = P_IN_PGCOD
      and o.aosuc = P_IN_SUCUR
      and o.aomda = P_IN_MDA
      and o.aopap = P_IN_PAP
      and o.aocta = P_IN_CTA
      and o.aooper = P_IN_OPER
      and o.aotope = P_IN_TOPE
      and o.aomod = P_IN_MOD
      and o.aostat <> 99;

--      if ln_ppmod = 116 and ln_pptope in (2,4,6) then
      if ln_pppzo is not null and ln_pppzo <> 0 then --drc PRY3303
         ln_moncuo := ln_moncuo/(ln_pppzo/30);
      end if; --drc PRY3303         
--      end if;

      return ln_moncuo;

      exception when others then
        return 0;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_valdat(P_C_TIPVAL in varchar2,
                        P_C_ANOPRO in varchar2,
                        P_C_MESPRO in varchar2,
                        P_C_CODPAS in varchar2) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_VALDAT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener valor de parámetro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_TIPVAL (TIPO DE PARAMETRO)
    --                              P_C_ANOPRO (AÑO DE PROCESO)
    --                              P_C_MESPRO (MES DE PROCESO)
    --                              P_C_CODPAS (TIPO DE PRODUCTO ACTIVO SBS)
    -- Retorno                    : Valor de parámetro
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_valdat jaql664.jaql664vdat%type;
  begin

    select j.jaql664vdat
      into ln_valdat
      from jaql664 j
     where j.jaql664ano  = P_C_ANOPRO
       and j.jaql664mes  = P_C_MESPRO
       and j.jaql664tval = P_C_TIPVAL
       and j.jaql664csbs = P_C_CODPAS
       and j.jaql664est  = 'S';

    return ln_valdat;

  exception
    when others then
      return null;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_crit_pyme(P_C_TIPVAL in varchar2,
                           P_C_ANOPRO in varchar2,
                           P_C_MESPRO in varchar2,
                           P_C_CODPAS in varchar2,
                           P_C_CODSEC in varchar2,
                           P_C_CODACT in varchar2,
                           P_C_CLASBS in varchar2) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_VALDAT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener valor de parametro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_TIPVAL (TIPO DE PARAMETRO)
    --                              P_C_ANOPRO (AÑO DE PROCESO)
    --                              P_C_MESPRO (MES DE PROCESO)
    --                              P_C_TIPPAS (TIPO DE PRODUCTO ACTIVO SBS)
    --                              P_C_CODSEC (CODIGO SECTOR ECONOMICO)
    --                              P_C_CODACT (CODIGO DE ACTIVIDAD ECONOMICA)
    --                              P_C_CLASBS (CLASIFICACION SBS)
    -- Retorno                    : Valor de parámetro
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_valdat jaql664.jaql664tval%type;
  begin

    select jaql664tval
      into ln_valdat
      from jaql664 k
     where k.jaql664ano  = P_C_ANOPRO
       and k.jaql664mes  = P_C_MESPRO
       and k.jaql664tval = P_C_TIPVAL
       and k.jaql664csbs = P_C_CODPAS
       and k.jaql664csec = P_C_CODSEC
       and k.jaql664cr01 = P_C_CODACT
       and k.jaql664cr02 = P_C_CLASBS
       and k.jaql664est  = 'S';

    return ln_valdat;

  exception
    when others then
      return null;
  end;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_crit_cons(P_C_TIPVAL in varchar2,
                           P_C_ANOPRO in varchar2,
                           P_C_MESPRO in varchar2,
                           P_C_CODPAS in varchar2,
                           P_C_CODSEC in varchar2,
                           P_N_INGNET in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_VALDAT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener valor de parametro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_valdat jaql664.jaql664tval%type;
  begin

    select t.jaql664tval
      into ln_valdat
      from jaql664 t
     where t.jaql664ano  = P_C_ANOPRO
       and t.jaql664mes  = P_C_MESPRO
       and t.jaql664tval = P_C_TIPVAL
       and t.jaql664csbs = P_C_CODPAS
       and t.jaql664csec = P_C_CODSEC
       and t.jaql664cr03 <= P_N_INGNET
       and t.jaql664cr04 >= P_N_INGNET
       and t.jaql664est = 'S';

    return ln_valdat;

  exception
    when others then
      return null;
  end;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_dias_mora
  (
    P_D_fecha in date,
    P_IN_PGCOD in number,
    P_IN_SCSUC in number,
    P_IN_SCMDA in number,
    P_IN_SCPAP in number,
    P_IN_SCCTA in number,
    P_IN_SCOPER in number,
    P_IN_SCSBOP in number,
    P_IN_SCTOPE in number,
    P_IN_SCMOD in number,
    P_IN_DIAMORA out number
  ) is
    -- *****************************************************************
    -- Nombre                     : FN_CR_DIAS_MORA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Devuelve el número de días de mora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_fecha: fecha de proceso,
    --                              P_IN_PGCOD: código de empresa,
    --                              P_IN_SCSUC: sucursal,
    --                              P_IN_SCMDA: moneda,
    --                              P_IN_SCPAP: papel,
    --                              P_IN_SCCTA: cuenta,
    --                              P_IN_SCOPER: operación,
    --                              P_IN_SCSBOP: sub-operación,
    --                              P_IN_SCTOPE: tipo de operación,
    --                              P_IN_SCMOD: módulo
    -- Parámetros de Salida       : P_N_diamora: número de días mora del crédito
    -- Fecha de Modif icación     :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************


  Begin
    Begin
      select P_D_fecha - min(f.ppfpag)
        into P_IN_DIAMORA
        from fsd601 f
       where not exists (select 1
                from fsd602 t
               where t.PGCOD = f.PGCOD
                 and t.PPMOD = f.PPMOD
                 and t.PPSUC = f.PPSUC
                 and t.PPMDA = f.PPMDA
                 and t.PPPAP = f.PPPAP
                 and t.PPCTA = f.PPCTA
                 and t.PPOPER = f.PPOPER
                 and t.PPSBOP = f.PPSBOP
                 and t.PPTOPE = f.PPTOPE
                 and t.PPFPAG = f.PPFPAG
                 and t.pp1stat = 'T'
                 and t.d602co = 'S')
         and  f.PGCOD = P_IN_PGCOD
         and  f.PPSUC = P_IN_SCSUC
         and  f.PPMDA = P_IN_SCMDA
         and  f.PPPAP = P_IN_SCPAP
         and  f.PPCTA = P_IN_SCCTA
         and  f.PPOPER = P_IN_SCOPER
         and  f.PPSBOP = P_IN_SCSBOP
         and  f.PPTOPE = P_IN_SCTOPE
         and  f.PPMOD = P_IN_SCMOD
         and f.ppfpag <= P_D_fecha
         and f.d601co = 'S';
    exception
      when no_data_found then
        P_IN_DIAMORA := 0;
      when self_is_null then
        P_IN_DIAMORA := 0;
      when others then
        P_IN_DIAMORA := 0;
    end;

    If P_IN_DIAMORA is null
    then
      P_IN_DIAMORA := 0;
    end If;

  end sp_cr_dias_mora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_conyuge(P_N_PAIS   in Number,
                          P_N_TIPDOC in Number,
                          P_C_NUMDOC in Char,
                          p_n_Pais_c   out varchar2,
                          p_n_Tipdoc_c out varchar2,
                          p_c_Numdoc_c out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_CONYUGE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Credito - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener datos del conyuge
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    p_n_pais1 fsr008.pepais%type;
    p_n_tipdoc1 fsr008.petdoc%type;
    p_c_numdoc1 fsr008.pendoc%type;

begin

    Begin
    --obtener conyugue de último crédito vigente
    select R.RPPAIS, R.RPTDOC, R.RPNDOC
    into p_n_pais1, p_n_tipdoc1, p_c_numdoc1
    from fsr002 R
    where R.pepais = P_N_PAIS
    and   R.petdoc = P_N_TIPDOC
    and   R.pendoc = P_C_NUMDOC
    and   rpccyg = 66;
    exception when no_data_found then
      p_n_pais1 := null;
      p_n_tipdoc1 := null;
      p_c_numdoc1 := null;
    end;

    Begin
      --obtener conyugue de último crédito vigente
      select t.pepais, t.petdoc, t.pendoc
        into p_n_pais_c, p_n_tipdoc_c, p_c_numdoc_c
        from fsr008 t
        where pepais = p_n_pais1
        and   petdoc = p_n_tipdoc1
        and   pendoc = p_c_numdoc1;
    exception when no_data_found then
      p_n_pais_c := null;
      p_n_tipdoc_c := null;
      p_c_numdoc_c := null;
    end;


 end;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_tipo_cliente(P_N_CUOSF3 in number,
                               P_N_CUOSF5 in number,
                               P_N_CUOSF2 in number,
                               P_N_CUOSF7 in number,
                               P_N_CUOSF4 in number,
                               P_N_CUOCM3 in number,
                               P_N_CUOCM5 in number,
                               P_N_CUOCM2 in number,
                               P_N_CUOCM7 in number,
                               P_N_CUOCM4 in number,
                               P_N_TIPMOD in number, --drc PRY3303
                               p_c_tipcli out varchar2,
                               p_c_tippas out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_TIPO_CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener tipo de cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CUOSF3 (Cuota SF - Microempresa)
    --                              P_N_CUOSF5 (Cuota SF - Pequeña empresa)
    --                              P_N_CUOSF2 (Cuota SF - Consumo no revolvente)
    --                              P_N_CUOSF7 (Cuota SF - Consumo Revolvente)
    --                              P_N_CUOSF4 (Cuota SF - Hipotecario)
    --                              P_N_CUOCM3 (Cuota CMAC - Microempresa)
    --                              P_N_CUOCM5 (Cuota CMAC - Pequeña empresa)
    --                              P_N_CUOCM2 (Cuota CMAC - Consumo no revolvente)
    --                              P_N_CUOCM7 (Cuota CMAC - Consumo Revolvente)
    --                              P_N_CUOCM4 (Cuota CMAC - Hipotecario)
    --                              P_N_TIPMOD (Tipo de Modelo - Código Tipo Producto SBS)
    -- Parámetros de Salida       : p_c_tipcli (Tipo de cliente PYME, CONSUMO, MIXTO, HIPOTECARIO)
    --                              p_c_tippas (Tipo de producto SBS PYME o CONSUMO)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    ln_valpym number(18, 2);
    ln_valcon number(18, 2);
    ln_valhip number(18, 2);
  begin

    ln_valpym := nvl(P_N_CUOSF3,0) + nvl(P_N_CUOSF5,0) + nvl(P_N_CUOCM3,0) + nvl(P_N_CUOCM5,0);
    ln_valcon := nvl(P_N_CUOSF2,0) + nvl(P_N_CUOSF7,0) + nvl(P_N_CUOCM2,0) + nvl(P_N_CUOCM7,0);
    ln_valhip := nvl(P_N_CUOSF4,0) + nvl(P_N_CUOCM4,0);

    if ln_valpym > 0 and ln_valcon = 0 and ln_valhip = 0 then
      p_c_tipcli := 'P';
      p_c_tippas := 'P';
    elsif ln_valpym = 0 and ln_valcon > 0 and ln_valhip = 0 then
      p_c_tipcli := 'C';
      p_c_tippas := 'C';
    elsif ln_valpym = 0 and ln_valcon = 0 and ln_valhip > 0 then
      p_c_tipcli := 'H';
      if P_N_TIPMOD = 13 then --drc PRY3303
        p_c_tippas := 'P';
      else
        p_c_tippas := 'C';
      end if;
    else
      p_c_tipcli := 'M';
      if P_N_TIPMOD = 13 then --drc PRY3303
        p_c_tippas := 'P';
      else
        p_c_tippas := 'C';
      end if;
    end if;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_tipo_cliente_cmac(p_n_salcap3 in number,
                                           p_n_salcap5 in number,
                                           p_n_salcap2 in number,
                                           p_n_salcap7 in number,
                                           p_n_salcap4 in number
                                  ) return char is
    lc_tipcli char;
    ln_valpym number(17, 2);
    ln_valcon number(17, 2);
    ln_valhip number(17, 2);
  begin

    ln_valpym := nvl(p_n_salcap3,0) + nvl(p_n_salcap5,0);
    ln_valcon := nvl(p_n_salcap2,0) + nvl(p_n_salcap7,0);
    ln_valhip := nvl(p_n_salcap4,0);

    if ln_valpym > 0 and ln_valcon = 0 and ln_valhip = 0 then
      lc_tipcli := 'P';
    elsif ln_valpym = 0 and ln_valcon > 0 and ln_valhip = 0 then
      lc_tipcli := 'C';
    elsif ln_valpym = 0 and ln_valcon = 0 and ln_valhip > 0 then
      lc_tipcli := 'H';
    else
      lc_tipcli := 'M';
    end if;

    return lc_tipcli;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_sistema_financiero(P_C_TIPDOC in number, --1
                                           P_C_NUMDOC in varchar2, --2
                                           p_n_camemp out number, --4
                                           p_n_credir out number, --5
                                           p_n_intdev out number, --6
                                           p_n_avaoto out number, --7
                                           p_n_carfia out number, --8
                                           p_n_carcre out number, --9
                                           p_n_aceban out number, --10
                                           p_n_linuti out number, --11
                                           p_n_hipote out number, --12
                                           p_n_calif0 out number, --13
                                           p_n_calif1 out number, --14
                                           p_n_calif2 out number, --15
                                           p_n_calif3 out number, --16
                                           p_n_calif4 out number, --17
                                           p_n_cuosf3 out number, --18
                                           p_n_cuosf5 out number, --19
                                           p_n_cuosf2 out number, --20
                                           p_n_cuosf7 out number, --21
                                           p_n_cuosf4 out number, --22
                                           p_n_cuoff3 out number, --23
                                           p_n_cuoff5 out number, --24
                                           p_n_cuoff2 out number, --25
                                           p_n_cuoff7 out number, --26
                                           p_n_cuoff4 out number) IS --27
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_SISTEMA_FINANCIERO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos - Riesgo
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Datos en el sistema financiero RCC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_TIPDOC (TIPO DE DOCUMENTO)
    --                              P_C_NUMDOC (NUMERO DE DOCUMENTO)
    -- Parámetros de Salida       : p_n_camemp (Cantidad inst. financieras)
    --                              p_n_credir (Créditos directos)
    --                              p_n_intdev (Interes devengado)
    --                              p_n_avaoto (Avales otorgados)
    --                              p_n_carfia (Cartas Fianza)
    --                              p_n_carcre (Cartas Credito)
    --                              p_n_aceban (Aceptaciones bancarias)
    --                              p_n_linuti (Linea no utilizada)
    --                              p_n_hipote (Credito hipotecario)
    --                              p_n_calif0 (Calificación 0 RCC)
    --                              p_n_calif1 (Calificación 1 RCC)
    --                              p_n_calif2 (Calificación 2 RCC)
    --                              p_n_calif3 (Calificación 3 RCC)
    --                              p_n_calif4 (Calificación 4 RCC)
    --                              p_n_cuosf3 (Cuota SF - Microempresa)
    --                              p_n_cuosf5 (Cuota SF - Peqequeña empresa)
    --                              p_n_cuosf2 (Cuota SF - Consumo no revolvente)
    --                              p_n_cuosf7 (Cuota SF - Consumo revolvente)
    --                              p_n_cuosf4 (Cuota SF - Hipotecario)
    --                              p_n_cuoff3 (Cuota FF - Microempresa)
    --                              p_n_cuoff5 (Cuota FF - Peqequeña empresa)
    --                              p_n_cuoff2 (Cuota FF - Consumo no revolvente)
    --                              p_n_cuoff7 (Cuota FF - Consumo revolvente)
    --                              p_n_cuoff4 (Cuota FF - Hipotecario)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_camemp_rcc number(2);
    ln_credir_rcc number(17, 2);
    ln_intdev_rcc number(17, 2);
    ln_avaoto_rcc number(17, 2);
    ln_carfia_rcc number(17, 2);
    ln_carcre_rcc number(17, 2);
    ln_aceban_rcc number(17, 2);
    ln_linuti_rcc number(17, 2);
    ln_hipote_rcc number(17, 2);

    ln_camemp_rcd number(2);
    ln_credir_rcd number(17, 2);
    ln_intdev_rcd number(17, 2);
    ln_avaoto_rcd number(17, 2);
    ln_carfia_rcd number(17, 2);
    ln_carcre_rcd number(17, 2);
    ln_aceban_rcd number(17, 2);
    ln_linuti_rcd number(17, 2);
    ln_hipote_rcd number(17, 2);

    ln_calif0 number(5, 2);
    ln_calif1 number(5, 2);
    ln_calif2 number(5, 2);
    ln_calif3 number(5, 2);
    ln_calif4 number(5, 2);

    ln_cuosf3 number(17, 2);
    ln_cuosf5 number(17, 2);
    ln_cuosf2 number(17, 2);
    ln_cuosf7 number(17, 2);
    ln_cuosf4 number(17, 2);
    ln_cuoff3 number(17, 2);
    ln_cuoff5 number(17, 2);
    ln_cuoff2 number(17, 2);
    ln_cuoff7 number(17, 2);
    ln_cuoff4 number(17, 2);

    type typ_cursor is ref cursor;
    cur_hrcc typ_cursor;

    lv_query_rcc varchar2(7000);
    lv_query_rcc2 varchar2(7000);
    lv_query_rcc3 varchar2(7000);
    lv_query_rcc4 varchar2(7000);

    begin

    lv_query_rcc := 'select COUNT(DISTINCT a.c_codemp), ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''1401'',a.N_SALCAP ' ||
                                   ',''1403'',a.N_SALCAP ' ||
                                   ',''1404'',a.N_SALCAP ' ||
                                   ',''1405'',a.N_SALCAP ' ||
                                   ',''1406'',a.N_SALCAP ' ||
                                   ',DECODE(SUBSTR(d.jaql665cod,1,6),''810302'',a.N_SALCAP,0) ' || ') ' ||
                                   ') N_CREDIR, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''1408'',a.N_SALCAP,0)) N_INTDEV, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''7101'',a.N_SALCAP,0)) N_AVAOTO, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''7102'',a.N_SALCAP,0)) N_CARFIA, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''7103'',a.N_SALCAP,0)) N_CARCRE, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod,1,4),''7104'',a.N_SALCAP,0)) N_ACEBAN, ' ||
                                   'SUM(DECODE(SUBSTR(d.jaql665cod, 1, 10), ' ||
                                   '''7205010200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205020200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205030200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205040200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205050200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205060200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205070200'', ' || 'a.N_SALCAP, ' ||
                                   '''7205011300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205021300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205031300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205041300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205051300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205061300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205071300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205010202'', ' || 'a.N_SALCAP, ' ||
                                   '''7205010302'', ' || 'a.N_SALCAP, ' ||
                                   '''7205020202'', ' || 'a.N_SALCAP, ' ||
                                   '''7205030202'', ' || 'a.N_SALCAP, ' ||
                                   '''7205030302'', ' || 'a.N_SALCAP, ' ||
                                   '''7205040202'', ' || 'a.N_SALCAP, ' ||
                                   '''7205040302'', ' || 'a.N_SALCAP, ' ||
                                   '''7205050202'', ' || 'a.N_SALCAP, ' ||
                                   '''7205010201'', ' || 'a.N_SALCAP, ' ||
                                   '''7205010301'', ' || 'a.N_SALCAP, ' ||
                                   '''7205020201'', ' || 'a.N_SALCAP, ' ||
                                   '''7205030201'', ' || 'a.N_SALCAP, ' ||
                                   '''7205030301'', ' || 'a.N_SALCAP, ' ||
                                   '''7205040201'', ' || 'a.N_SALCAP, ' ||
                                   '''7205040301'', ' || 'a.N_SALCAP, ' ||
                                   '''7205050201'', ' || 'a.N_SALCAP, ' ||
                                   '''7205060300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205070300'', ' || 'a.N_SALCAP, ' ||
                                   '''7205070400'', ' || 'a.N_SALCAP, ' ||
                                   '0)) N_LINUTI, ' ||
                                   'SUM(DECODE(a.c_cretip,''4'',DECODE(SUBSTR(d.jaql665cod,1,4),''13'',DECODE(SUBSTR(d.jaql665cod,1,4) ' ||
                                   ',''1401'',a.N_SALCAP ' ||
                                   ',''1403'',a.N_SALCAP ' ||
                                   ',''1404'',a.N_SALCAP ' ||
                                   ',''1405'',a.N_SALCAP ' ||
                                   ',''1406'',a.N_SALCAP ' ||
                                   ',DECODE(SUBSTR(d.jaql665cod,1,6),''810302'',a.N_SALCAP ' ||
                                   ',0 ' || ') ' || ') ' || ',0) ' ||
                                   ')) N_HIPOTE ' ||
                                   'from cldrccs A, ' ||
                                   'cldrcci B, ' || 'jaql665 d, ' || 'fst098 k ' ||
                                   'WHERE a.c_codemp<>''00104'' and '||
                                   'a.c_codsbs = b.c_codsbs and ' ||
                                   'a.d_fecpre = b.d_fecpre and ' ||
                                   'k.pgcod    = d.jaql665pcg and ' ||
                                   'k.tpcod = ''7647'' and ' ||
                                   'k.tpcorr = ''12'' and ' ||
                                   'a.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') and ' ||
                                   'b.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') and ' ||
                                   'substr(a.c_cuenta,1,2) = substr(d.jaql665cod,1,2) and ' ||
                                   'substr(a.c_cuenta,4,11) = substr(d.jaql665cod,4,11) ' ||
                                   'and a.c_cretip in (''12'', ''10'', ''13'', ''09'', ''11'', ''99'') ';

    lv_query_rcc2 := 'select b.n_calif0, ' || 'b.n_calif1, ' ||
                                    'b.n_calif2, ' || 'b.n_calif3, ' ||
                                    'b.n_calif4 ' ||
                                    'from cldrcci b, ' || 'fst098 k ' ||
                                    'where k.tpcod = ''7647'' and ' ||
                                    'k.tpcorr = ''12'' and ' ||
                                    'b.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'')';

    lv_query_rcc3 := 'select sum(decode(a.c_cretip, ' ||
                                    '''10'', ' || 'a.N_SALCAP, ' ||
                                    '''99'', ' ||
                                    'decode(substr(d.jaql665cod, 1, 10), ' ||
                                    '''7205010200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205020200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205030200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205040200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205050200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205060200'', ' || 'a.N_SALCAP, ' ||
                                    '''7205070200'', ' || 'a.N_SALCAP, ' ||
                                    '0), ' || '0)) c_salca3, ' ||
                                    'sum(decode(a.c_cretip, ' || '''09'', ' ||
                                    'a.N_SALCAP, ' || '''99'', ' ||
                                    'decode(substr(d.jaql665cod, 1, 10), ' ||
                                    '''7205011300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205021300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205031300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205041300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205051300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205061300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205071300'', ' || 'a.N_SALCAP, ' ||
                                    '0), ' || '0)) c_salca5, ' ||
                                    'sum(decode(a.c_cretip, ' || '''12'', ' ||
                                    'a.N_SALCAP, ' || '''99'', ' ||
                                    'decode(substr(d.jaql665cod, 1, 10), ' ||
                                    '''7205010202'', ' || 'a.N_SALCAP, ' ||
                                    '''7205010302'', ' || 'a.N_SALCAP, ' ||
                                    '''7205020202'', ' || 'a.N_SALCAP, ' ||
                                    '''7205030202'', ' || 'a.N_SALCAP, ' ||
                                    '''7205030302'', ' || 'a.N_SALCAP, ' ||
                                    '''7205040202'', ' || 'a.N_SALCAP, ' ||
                                    '''7205040302'', ' || 'a.N_SALCAP, ' ||
                                    '''7205050202'', ' || 'a.N_SALCAP, ' ||
                                    '0), ' || '0)) c_salca2, ' ||
                                    'sum(decode(a.c_cretip, ' || '''11'', ' ||
                                    'a.N_SALCAP, ' || '''99'', ' ||
                                    'decode(substr(d.jaql665cod, 1, 10), ' ||
                                    '''7205010201'', ' || 'a.N_SALCAP, ' ||
                                    '''7205010301'', ' || 'a.N_SALCAP, ' ||
                                    '''7205020201'', ' || 'a.N_SALCAP, ' ||
                                    '''7205030201'', ' || 'a.N_SALCAP, ' ||
                                    '''7205030301'', ' || 'a.N_SALCAP, ' ||
                                    '''7205040201'', ' || 'a.N_SALCAP, ' ||
                                    '''7205040301'', ' || 'a.N_SALCAP, ' ||
                                    '''7205050201'', ' || 'a.N_SALCAP, ' ||
                                    '''7205060300'', ' || 'a.N_SALCAP, ' ||
                                    '''7205070300'', ' || 'a.N_SALCAP, ' ||
                                    '0), ' || '0)) c_salca7, ' ||
                                    'sum(decode(a.c_cretip, ' || '''13'', ' ||
                                    'a.N_SALCAP, ' || '''99'', ' ||
                                    'decode(substr(d.jaql665cod, 1, 10), ''7205070400'', a.N_SALCAP, 0), ' ||
                                    '0)) c_salca4 ' ||
                                    'from cldrccs A, cldrcci B, jaql665 d, fst098 k '||
                                    'WHERE a.c_codemp<>''00104'' and '||
                                    'a.c_codsbs = b.c_codsbs ' ||
                                    'and a.d_fecpre = b.d_fecpre ' ||
                                    'and k.tpcod = ''7647''  ' ||
                                    'and k.tpcorr = ''12''  ' ||
                                    'and k.pgcod    = d.jaql665pcg ' ||
                                    'and a.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') ' ||
                                    'and b.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') ' ||
                                    'and substr(a.c_cuenta, 1, 2) = substr(d.jaql665cod, 1, 2) ' ||
                                    'and substr(a.c_cuenta, 4, 11) = substr(d.jaql665cod, 4, 11)  ' ||
                                    'and (SUBSTR(d.jaql665cod, 1, 4) in (''7101'', ''7102'', ''7103'', ''7104'') or ' ||
                                    'SUBSTR(d.jaql665cod, 1, 6) in (''720501'', ''720502'', ''720503'', ''720504'', ' ||
                                    '''720505'', ''720506'', ''720507'')) ' ||
                                    'and a.c_cretip in (''12'', ''10'', ''13'', ''09'', ''11'', ''99'') ';

    lv_query_rcc4 := 'select sum(decode(a.c_cretip,''10'', a.N_SALCAP, 0)) c_salca3, ' ||
                                    'sum(decode(a.c_cretip,''09'', a.N_SALCAP, 0)) c_salca5, ' ||
                                    'sum(decode(a.c_cretip,''12'', a.N_SALCAP, 0)) c_salca2, ' ||
                                    'sum(decode(a.c_cretip,''11'', a.N_SALCAP, 0)) c_salca7, ' ||
                                    'sum(decode(a.c_cretip,''13'', a.N_SALCAP, 0)) c_salca4 ' ||
                                    'from cldrccs A, cldrcci B, jaql665 d, fst098 k ' ||
                                    'WHERE a.c_codemp<>''00104'' and '||
                                    'a.c_codsbs = b.c_codsbs ' ||
                                    'and k.pgcod    = d.jaql665pcg ' ||
                                    'and k.tpcod = ''7647''  ' ||
                                    'and k.tpcorr = ''12''  ' ||
                                    'and a.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') ' ||
                                    'and b.d_fecpre = to_date(k.tpnro,''DD/MM/RRRR'') ' ||
                                    'and substr(a.c_cuenta, 1, 2) = substr(d.jaql665cod, 1, 2) ' ||
                                    'and substr(a.c_cuenta, 4, 11) = substr(d.jaql665cod, 4, 11) ' ||
                                    'and (SUBSTR(d.jaql665cod, 1, 4) in ' ||
                                    '(''1401'', ''1403'', ''1404'', ''1405'', ''1406'', ''1408'') or ' ||
                                    'SUBSTR(d.jaql665cod, 1, 6) = ''810302'') ';

    if p_c_tipdoc = '3' then

      open cur_hrcc for lv_query_rcc || ' AND B.C_DOCTRI=''' || TRIM(P_C_NUMDOC) || ''' AND B.C_TDOCTR=''' || P_C_TIPDOC || '''';
      fetch cur_hrcc
        into ln_camemp_rcc, ln_credir_rcc, ln_intdev_rcc, ln_avaoto_rcc, ln_carfia_rcc, ln_carcre_rcc, ln_aceban_rcc, ln_linuti_rcc, ln_hipote_rcc;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc2 || ' AND B.C_DOCTRI=''' || TRIM(P_C_NUMDOC) || ''' AND B.C_TDOCTR=''' || P_C_TIPDOC || '''';
      fetch cur_hrcc
        into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc3 || ' AND B.C_DOCTRI=''' || TRIM(P_C_NUMDOC) || ''' AND B.C_TDOCTR=''' || P_C_TIPDOC || '''';
      fetch cur_hrcc
        into ln_cuoff3, ln_cuoff5, ln_cuoff2, ln_cuoff7, ln_cuoff4;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc4 || ' AND B.C_DOCTRI=''' || TRIM(P_C_NUMDOC) || ''' AND B.C_TDOCTR=''' || P_C_TIPDOC || '''';
      fetch cur_hrcc
        into ln_cuosf3, ln_cuosf5, ln_cuosf2, ln_cuosf7, ln_cuosf4;
      close cur_hrcc;

    else

      open cur_hrcc for lv_query_rcc || ' AND B.C_DOCIDE=''' || TRIM(P_C_NUMDOC) || '''';
      fetch cur_hrcc
        into ln_camemp_rcc, ln_credir_rcc, ln_intdev_rcc, ln_avaoto_rcc, ln_carfia_rcc, ln_carcre_rcc, ln_aceban_rcc, ln_linuti_rcc, ln_hipote_rcc;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc2 || ' AND B.C_DOCIDE=''' || TRIM(P_C_NUMDOC) || '''';
      fetch cur_hrcc
        into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc3 || ' AND B.C_DOCIDE=''' || TRIM(P_C_NUMDOC) || '''';
      fetch cur_hrcc
        into ln_cuoff3, ln_cuoff5, ln_cuoff2, ln_cuoff7, ln_cuoff4;
      close cur_hrcc;

      open cur_hrcc for lv_query_rcc4 || ' AND B.C_DOCIDE=''' || TRIM(P_C_NUMDOC) || '''';
      fetch cur_hrcc
        into ln_cuosf3, ln_cuosf5, ln_cuosf2, ln_cuosf7, ln_cuosf4;
      close cur_hrcc;

    end if;

    ln_camemp_rcd := 1;

    p_n_camemp := nvl(ln_camemp_rcc, 0) + nvl(ln_camemp_rcd, 0);
    p_n_credir := nvl(ln_credir_rcc, 0) + nvl(ln_credir_rcd, 0);
    p_n_intdev := nvl(ln_intdev_rcc, 0) + nvl(ln_intdev_rcd, 0);
    p_n_avaoto := nvl(ln_avaoto_rcc, 0) + nvl(ln_avaoto_rcd, 0);
    p_n_carfia := nvl(ln_carfia_rcc, 0) + nvl(ln_carfia_rcd, 0);
    p_n_carcre := nvl(ln_carcre_rcc, 0) + nvl(ln_carcre_rcd, 0);
    p_n_aceban := nvl(ln_aceban_rcc, 0) + nvl(ln_aceban_rcd, 0);
    p_n_linuti := nvl(ln_linuti_rcc, 0) + nvl(ln_linuti_rcd, 0);
    p_n_hipote := nvl(ln_hipote_rcc, 0) + nvl(ln_hipote_rcd, 0);

    p_n_calif0 := nvl(ln_calif0, 0);
    p_n_calif1 := nvl(ln_calif1, 0);
    p_n_calif2 := nvl(ln_calif2, 0);
    p_n_calif3 := nvl(ln_calif3, 0);
    p_n_calif4 := nvl(ln_calif4, 0);

    p_n_cuosf3 := nvl(ln_cuosf3, 0);
    p_n_cuosf5 := nvl(ln_cuosf5, 0);
    p_n_cuosf2 := nvl(ln_cuosf2, 0);
    p_n_cuosf7 := nvl(ln_cuosf7, 0);
    p_n_cuosf4 := nvl(ln_cuosf4, 0);

    p_n_cuoff3 := nvl(ln_cuoff3, 0);
    p_n_cuoff5 := nvl(ln_cuoff5, 0);
    p_n_cuoff2 := nvl(ln_cuoff2, 0);
    p_n_cuoff7 := nvl(ln_cuoff7, 0);
    p_n_cuoff4 := nvl(ln_cuoff4, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_calificacion_sbs(P_C_TIPDOC in number,
                                           P_C_NUMDOC in varchar2,
                                           P_N_MODULO in number
                                           ) return number is

    ln_calif0 number(5, 2);
    ln_calif1 number(5, 2);
    ln_calif2 number(5, 2);
    ln_calif3 number(5, 2);
    ln_calif4 number(5, 2);

  lc_tipdoc varchar2(1);

  begin

    --excepción castigados para cálculo de nivel de sobreendeudamiento
    if P_N_MODULO = 33 then
       return 4;
    end if;

    lc_tipdoc := PQ_CR_JAQL157_SOBEND.fn_cr_tipdoc_sbs(P_C_TIPDOC, P_C_NUMDOC);

    --obtener calificación sbs
    if lc_tipdoc = '3' then
      begin
        select b.n_calif0, b.n_calif1, b.n_calif2, b.n_calif3, b.n_calif4
        into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
        from cldrcci b, fst098 k
        where k.tpcod = '7647'
        and k.tpcorr = '12'
        and b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
        and b.c_tdoctr = trim(lc_tipdoc) and b.c_doctri = trim(P_C_NUMDOC)
        and rownum = 1;
      exception when no_data_found then
        return 0;
      end;
    else
      begin
        select b.n_calif0, b.n_calif1, b.n_calif2, b.n_calif3, b.n_calif4
        into ln_calif0, ln_calif1, ln_calif2, ln_calif3, ln_calif4
        from cldrcci b, fst098 k
        where k.tpcod = '7647'
        and k.tpcorr = '12'
        and b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
        and b.c_docide = trim(P_C_NUMDOC)
        and rownum = 1;
      exception when no_data_found then
        return 0;
      end;
    end if;

    if ln_calif4 >= 20 then
       return 4;
    elsif ln_calif3 >= 20 then
       return 3;
    elsif ln_calif2 >= 20 then
       return 2;
    elsif ln_calif1 >= 20 then
       return 1;
    elsif ln_calif0 >= 20 then
       return 0;
    end if;

    return 0;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_tipo_credito(P_N_RUB in number,
                                   P_C_TIPPAS in varchar2
                                  ) return char is

    lc_tipcre char;
    lc_cuenta jaql154.jaql154rub%type;

  begin
  
    lc_cuenta := P_N_RUB;
    lc_tipcre := '-';

    --TIPO DE CRÉDITO CMAC
    begin

      if ( SubStr(lc_cuenta,5,2) = '03' and SubStr(lc_cuenta,11,3) = '015' ) then
         lc_tipcre := 'R';
      end if;

      if ( SubStr(lc_cuenta,5,2) = '03' and SubStr(lc_cuenta,11,3) <> '015' ) then
         lc_tipcre := 'N';
      end if;
      if (SubStr(lc_cuenta,1,2) = '81' and P_C_TIPPAS = 'C') then
         lc_tipcre := 'N';
      end if;

      if SubStr(lc_cuenta,5,2) = '04' then
         lc_tipcre := 'H';
      end if;

      if SubStr(lc_cuenta,5,2) = '02' then
         lc_tipcre := 'M';
      end if;
      if (SubStr(lc_cuenta,1,2) = '81' And P_C_TIPPAS = 'P') then
         lc_tipcre := 'M';
      end if;
      
      if SubStr(lc_cuenta,5,2) = '13' then
         lc_tipcre := 'P';
      end if;

    exception when no_data_found then
      lc_tipcre := '-';
    end;

    return lc_tipcre;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_tipo_credito_sbs(P_C_TIPDOC in varchar2,
                                           P_C_NUMDOC in varchar2,
                                           P_C_TIPPAS in varchar2
                                           ) return char is
    lc_codsbs cldrccs.c_codsbs%type;
    lc_cuenta cldrccs.c_cuenta%type;
    lc_tipcre char;

  begin

    --determinar código sbs
    if p_c_tipdoc = '3' then
      begin
        select b.c_codsbs
        into lc_codsbs
        from cldrcci b inner join fst098 k
        on b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
        where k.tpcod = 7647
        and k.tpcorr = 12
        and b.c_tdoctr = trim(P_C_TIPDOC) and b.c_doctri = trim(P_C_NUMDOC)
        and rownum = 1;
      exception when no_data_found then
        return '-';
      end;
    else
      begin
        select b.c_codsbs
        into lc_codsbs
        from cldrcci b inner join fst098 k
        on b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
        where k.tpcod = 7647
        and k.tpcorr = 12
        and b.c_docide = trim(P_C_NUMDOC)
        and rownum = 1;
      exception when no_data_found then
        return '-';
      end;
    end if;

    begin
      select c_cuenta
      into lc_cuenta
      from
      (
        select a.c_cuenta, sum(a.n_salcap)
        from cldrccs a, fst098 k
        where a.c_codsbs = lc_codsbs
        and k.tpcod = '7647'
        and k.tpcorr = '12'
        and a.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
        and ( a.c_cuenta like '14_1%' or c_cuenta like '14_3%' or c_cuenta like '14_4%' or c_cuenta like '14_5%' or c_cuenta like '14_6%' or c_cuenta like '81%' )
        group by a.c_cuenta
        order by sum(a.n_salcap) desc
      )
      where rownum = 1;

      --TIPO DE CRÉDITO SBS
      lc_tipcre := '-';
      if (SubStr(lc_cuenta,5,2) = '03' and SubStr(lc_cuenta,9,2) in ('01','06') ) then
         lc_tipcre := 'R';
      end if;

      if (SubStr(lc_cuenta,5,2) = '03' and SubStr(lc_cuenta,9,2) in ('02','03','04','05','09') ) then
         lc_tipcre := 'N';
      end if;
      if (SubStr(lc_cuenta,1,2) = '81' and P_C_TIPPAS = 'C') then
         lc_tipcre := 'N';
      end if;

      if SubStr(lc_cuenta,5,2) = '04' then
         lc_tipcre := 'H';
      end if;

      if SubStr(lc_cuenta,5,2) = '02' then
         lc_tipcre := 'M';
      end if;
      if (SubStr(lc_cuenta,1,2) = '81' And P_C_TIPPAS = 'P') then
         lc_tipcre := 'M';
      end if;
      
      if SubStr(lc_cuenta,5,2) = '13' then
         lc_tipcre := 'P';
      end if;

    exception when no_data_found then
      lc_tipcre := '-';
    end;

    return lc_tipcre;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_tipo_credito_cmac(p_n_salcap3 in number,
                                           p_n_salcap5 in number,
                                           p_n_salcap2 in number,
                                           p_n_salcap7 in number,
                                           p_n_salcap4 in number
                                  ) return char is
    lc_tipcre char;
    ln_saltmp number(17, 2);
  begin
  
    lc_tipcre := '-';
    ln_saltmp := 0;
    
    if ( p_n_salcap3 > 0 ) then
       lc_tipcre := 'M';
       ln_saltmp := p_n_salcap3;
    end if;
    
    if ( p_n_salcap5 > ln_saltmp and p_n_salcap5 > 0 ) then
       lc_tipcre := 'P';
       ln_saltmp := p_n_salcap5;
    end if;
    
    if ( p_n_salcap2 > ln_saltmp and p_n_salcap2 > 0 ) then
       lc_tipcre := 'N';
       ln_saltmp := p_n_salcap2;
    end if;
    
    if ( p_n_salcap7 > ln_saltmp and p_n_salcap7 > 0 ) then
       lc_tipcre := 'R';
       ln_saltmp := p_n_salcap7;
    end if;
    
    if ( p_n_salcap4 > ln_saltmp and p_n_salcap4 > 0 ) then
       lc_tipcre := 'H';
    end if;
    
    return lc_tipcre;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_nivel_sobend_ant(P_N_RATDET in number,
                                           P_N_NUMENT in number,
                                           P_N_CALSBS in number,
                                           P_C_TIPPRO in char,
                                           P_N_DEUTOT in number,
                                           P_N_PATRIM in number,
                                           P_N_MONMAX in number,
                                           P_N_INGNET in number
                                           ) return char is
  ln_cont number(1);
  begin

    --'N' Sin evidencia de sobreendeudamiento
    if ( P_N_RATDET <= 0.8 ) then
       return 'N';
    end if;
    if ( P_N_NUMENT >= 1 and P_N_NUMENT <= 4 ) and
       ( P_N_CALSBS in (0, 1) ) then
       -- pyme
       if ( P_C_TIPPRO = 'P' ) then
          if ( P_N_PATRIM <> 0 ) then
            if ( P_N_DEUTOT/P_N_PATRIM <= 1 ) then
               return 'N';
            end if;
          end if;
       end if;
       -- consumo
       if ( P_C_TIPPRO = 'C' ) then
          if ( P_N_INGNET <= 1999 ) then
             if ( P_N_MONMAX <= P_N_INGNET*10  ) then
                return 'N';
             end if;
          end if;
          if ( P_N_INGNET <= 4999 ) then
             if ( P_N_MONMAX <= P_N_INGNET*11  ) then
                return 'N';
             end if;
          end if;
          if ( P_N_INGNET >= 5000 ) then
             if ( P_N_MONMAX <= P_N_INGNET*12  ) then
                return 'N';
             end if;
          end if;
       end if;
    end if;

    --'E' Posiblemente sobreendeudado
    if ( P_C_TIPPRO = 'P' and ( P_N_RATDET > 0.8 and P_N_RATDET <= 1.0 ) ) or
       ( P_C_TIPPRO = 'C' and ( P_N_RATDET > 0.9 and P_N_RATDET <= 1.0 ) ) then

       if ( P_N_NUMENT = 5 ) then
          return 'E';
       end if;
       if ( P_N_CALSBS in (2, 3, 4) ) then
          return 'E';
       end if;
       -- pyme
       if ( P_C_TIPPRO = 'P' ) then
          if ( P_N_PATRIM <> 0 ) then
            if ( P_N_DEUTOT/P_N_PATRIM > 1 ) then
               return 'E';
            end if;
          end if;
       end if;
       -- consumo
       if ( P_C_TIPPRO = 'C' ) then
          if ( P_N_INGNET <= 1999 ) then
             if ( P_N_MONMAX > P_N_INGNET*10  ) then
                return 'E';
             end if;
          end if;
          if ( P_N_INGNET <= 4999 ) then
             if ( P_N_MONMAX > P_N_INGNET*11  ) then
                return 'E';
             end if;
          end if;
          if ( P_N_INGNET >= 5000 ) then
             if ( P_N_MONMAX > P_N_INGNET*12  ) then
                return 'E';
             end if;
          end if;
       end if;
    end if;

    --'S' Sobreendeudado
    if ( P_N_RATDET > 1.0 ) then
       ln_cont := 0;
       if ( P_N_NUMENT >= 5 ) then
          ln_cont := ln_cont + 1;
       end if;
       if ( P_N_CALSBS in (3, 4) ) then
          ln_cont := ln_cont + 1;
       end if;
       -- pyme
       if ( P_C_TIPPRO = 'P' ) then
          if ( P_N_PATRIM <> 0 ) then
            if ( P_N_DEUTOT/P_N_PATRIM > 1 ) then
               ln_cont := ln_cont + 1;
            end if;
          end if;
       end if;
       -- consumo
       if ( P_C_TIPPRO = 'C' ) then
          if ( P_N_INGNET <= 1999 ) then
             if ( P_N_MONMAX > P_N_INGNET*10  ) then
                ln_cont := ln_cont + 1;
             end if;
          end if;
          if ( P_N_INGNET <= 4999 ) then
             if ( P_N_MONMAX > P_N_INGNET*11  ) then
                ln_cont := ln_cont + 1;
             end if;
          end if;
          if ( P_N_INGNET >= 5000 ) then
             if ( P_N_MONMAX > P_N_INGNET*12  ) then
                ln_cont := ln_cont + 1;
             end if;
          end if;
       end if;

       if ( ln_cont = 1 ) then
          return 'E';
       end if;
       if ( ln_cont >= 2 ) then
          return 'S';
       end if;

    end if;

    return 'I';
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_nivel_sobend(P_N_RATDET in number,
                                           P_N_NUMENT in number,
                                           P_N_CALSBS in number,
                                           P_C_TIPPRO in char,
                                           P_N_DEUTOT in number,
                                           P_N_PATRIM in number,
                                           P_N_MONMAX in number,
                                           P_N_INGNET in number,
                                           P_C_TIPSBS in char,
                                           P_C_SECECO in char,
                                           P_N_SUBPEQ in char
                                           ) return char is
  --complementarios
  ln_numcom number(1);
  ln_csbsE number(1);
  ln_csbsS number(1);
  ln_ratend number(18,2);
  ln_ratend_div number(18,2);
  --ratio determinante
  lc_rdt100 char(1);
  lc_rdt80 char(1);

  begin

    ln_numcom := 0;
    ln_csbsE := 0;
    ln_csbsS := 0;
    lc_rdt100 := 'N';
    lc_rdt80 := 'N';

    if (P_N_RATDET = 2) and (P_N_NUMENT = 20) then --drc PRY3303 (2)
       return 'S';
    end if;

    if (P_C_TIPSBS = '-') then
       return null;
    end if;

    --* ratio de endeudamiento (guardar en guía de proceso)
    ln_ratend := 0.9;
    if (P_C_TIPSBS = 'M') or (P_N_SUBPEQ = '3') or (P_C_TIPSBS = 'H' and P_C_TIPPRO = 'P') then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
    end if;

    if (P_N_SUBPEQ = 2) then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
    end if;

    if (P_N_SUBPEQ = 1) then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
    end if;

    --verificar infracciones complementarias
    --calificación sbs
    if ( P_N_CALSBS in (2, 3, 4) ) then
      ln_csbsE := 1;
    end if;
    if ( P_N_CALSBS in (3, 4) ) then
      ln_csbsS := 1;
    end if;
    
    --nro. entidades - S
    if P_N_NUMENT > 5 then
        ln_numcom := ln_numcom + 1;
    end if;
    
    --ratio de endeudamiento pyme
    if ( P_C_TIPPRO = 'P' ) then
       if ( P_N_PATRIM <> 0 ) then
         ln_ratend_div := P_N_DEUTOT/P_N_PATRIM;
         if ( ln_ratend_div > ln_ratend ) then
            ln_numcom := ln_numcom + 1;
         end if;
       end if;
    end if;    
    if ( P_N_PATRIM <> 0 ) then
      --ln_ratend_div := P_N_DEUTOT/P_N_PATRIM;    
      if ( P_N_DEUTOT/P_N_PATRIM < 0 ) then
        ln_numcom := ln_numcom + 1;
      end if;
    end if;    
    --ratio de endeudamiento consumo
    if ( P_C_TIPPRO = 'C' ) then
       if ( P_N_INGNET <= 1999 ) then
          if ( P_N_MONMAX > P_N_INGNET*10  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
       if ( P_N_INGNET >= 2000 and P_N_INGNET <= 4999 ) then
          if ( P_N_MONMAX > P_N_INGNET*11  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
       if ( P_N_INGNET >= 5000 ) then
          if ( P_N_MONMAX > P_N_INGNET*12  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
    end if;
    
    --ratio determinante 100
    if P_N_RATDET > 1 or P_N_RATDET < 0 then
       lc_rdt100 := 'S';
    end if;
    --ratio determinante 80
    if ( P_C_TIPPRO = 'P' and ( P_N_RATDET > 0.8 /*-- and P_N_RATDET <= 1.0 --*/ ) ) or
       ( P_C_TIPPRO = 'C' and ( P_N_RATDET > 0.9 /*-- and P_N_RATDET <= 1.0 --*/ ) ) then
       lc_rdt80 := 'S';
    end if;

    --
    --S Sobreendeudado    
    if (lc_rdt100 = 'S') and ((ln_numcom + ln_csbsS) >= 2) then
       return 'S';
    end if;

    --
    --E Posiblemente Sobreendeudado
    
    --nro. entidades - E
    if P_N_NUMENT = 5 then
        ln_numcom := ln_numcom + 1;
    end if;

    if (lc_rdt100 = 'S') and ((ln_numcom + ln_csbsE) = 1) then
       return 'E';
    end if;

    if (lc_rdt80 = 'S') and ((ln_numcom + ln_csbsE) >= 1) then
       return 'E';
    end if;

    if (P_C_TIPSBS = 'R') or (P_C_TIPSBS = 'N') or (P_C_TIPSBS = 'H') or (P_C_TIPSBS = 'M') or (P_C_TIPSBS = 'P') then
       return 'N';
    end if;

    --
    --I Sin identificaci+on
    return 'I';

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_criterio_sobend(P_N_RATDET in number,
                                           P_N_NUMENT in number,
                                           P_N_CALSBS in number,
                                           P_C_TIPPRO in char,
                                           P_N_DEUTOT in number,
                                           P_N_PATRIM in number,
                                           P_N_MONMAX in number,
                                           P_N_INGNET in number,
                                           P_C_TIPSBS in char,
                                           P_C_SECECO in char,
                                           P_N_SUBPEQ in char,
                                           P_N_CRIAPL in char
                                           ) return char is
  --complementarios
  ln_numcom number(1);
  ln_csbsE number(1);
  ln_csbsS number(1);
  ln_ratend number(18,2);
  --ratio determinante
  lc_rdt100 char(1);
  lc_rdt80 char(1);

  begin

    --'1' criterio ratio determinante
    --'2' criterio ratio deuda/patrimonio
    --'3' criterio número de entidades
    --'4' criterio calificación sbs dudoso/perdida

    ln_numcom := 0;
    ln_csbsE := 0;
    ln_csbsS := 0;
    lc_rdt100 := 'N';
    lc_rdt80 := 'N';

    --* ratio de endeudamiento (guardar en guía de proceso)
    ln_ratend := 0.8;
    if (P_C_TIPSBS = 'M') or (P_N_SUBPEQ = '3') or (P_C_TIPSBS = 'H' and P_C_TIPPRO = 'P') then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.6;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
    end if;

    if (P_N_SUBPEQ = 2) then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.4;
          end if;
       end if;
    end if;

    if (P_N_SUBPEQ = 1) then
       if P_C_SECECO = 'C' then
          if P_N_CALSBS = 0 then
             ln_ratend := 1;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
       if P_C_SECECO = 'P' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
       if P_C_SECECO = 'S' then
          if P_N_CALSBS = 0 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 1 then
             ln_ratend := 0.9;
          end if;
          if P_N_CALSBS = 2 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 3 then
             ln_ratend := 0.7;
          end if;
          if P_N_CALSBS = 4 then
             ln_ratend := 0.5;
          end if;
       end if;
    end if;

    --*

    --verificar infracciones complementarias
    --calificación sbs
    if ( P_N_CALSBS in (2, 3, 4) ) then
      ln_csbsE := 1;
    end if;
    if ( P_N_CALSBS in (3, 4) ) then
      ln_csbsS := 1;
       if (P_N_CRIAPL = '4' or P_N_CRIAPL = '8') then --criterio calificación sbs dudoso/pérdida
         return 'S';          
       end if;      
    end if;
    
    --nro. entidades - S
    if P_N_NUMENT > 5 then
       ln_numcom := ln_numcom + 1;
       if (P_N_CRIAPL = '3' or P_N_CRIAPL = '7') then --criterio número de entidades
         return 'S';          
       end if;        
    end if;
    
    --ratio de endeudamiento pyme
    if ( P_C_TIPPRO = 'P' ) then
       if ( P_N_PATRIM <> 0 ) then
         if ( P_N_DEUTOT/P_N_PATRIM > ln_ratend ) then
             ln_numcom := ln_numcom + 1;
             if (P_N_CRIAPL = '2' or P_N_CRIAPL = '6') then --criterio ratio deuda/patrimonio
               return 'S';          
             end if;            
         end if;
       end if;
    end if;    
    if ( P_N_PATRIM <> 0 ) then
      if ( P_N_DEUTOT/P_N_PATRIM < 1 ) then
           ln_numcom := ln_numcom + 1;
           if (P_N_CRIAPL = '2' or P_N_CRIAPL = '6') then --criterio ratio deuda/patrimonio
             return 'S';          
           end if;        
      end if;
    end if;    
    --ratio de endeudamiento consumo
    if ( P_C_TIPPRO = 'C' ) then
       if ( P_N_INGNET <= 1999 ) then
          if ( P_N_MONMAX > P_N_INGNET*10  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
       if ( P_N_INGNET <= 4999 ) then
          if ( P_N_MONMAX > P_N_INGNET*11  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
       if ( P_N_INGNET >= 5000 ) then
          if ( P_N_MONMAX > P_N_INGNET*12  ) then
             ln_numcom := ln_numcom + 1;
          end if;
       end if;
    end if;
    
    --ratio determinante 100
    if P_N_RATDET > 1 Or P_N_RATDET < 0 then
       lc_rdt100 := 'S';
    end if;
    --ratio determinante 80
    if ( P_C_TIPPRO = 'P' and ( P_N_RATDET > 0.8 /*-- and P_N_RATDET <= 1.0 --*/ ) ) or
       ( P_C_TIPPRO = 'C' and ( P_N_RATDET > 0.9 /*-- and P_N_RATDET <= 1.0 --*/ ) ) then
       lc_rdt80 := 'S';
    end if;

    --
    --S Sobreendeudado
    if (lc_rdt100 = 'S') and ((ln_numcom + ln_csbsS) >= 2) then
       if (P_N_CRIAPL = '1') then --criterio ratio determinante
         return 'S';          
       end if;
    end if;

    --
    --E Posiblemente Sobreendeudado
    
    --nro. entidades - E
    if P_N_NUMENT = 5 then
       ln_numcom := ln_numcom + 1;
       if (P_N_CRIAPL = '7') then --criterio número de entidades
         return 'S';          
       end if;        
    end if;
    if (lc_rdt100 = 'S') and ((ln_numcom + ln_csbsE) = 1) then
       if (P_N_CRIAPL = '5') then --criterio ratio determinante
         return 'S';          
       end if;
    end if;
    if (lc_rdt80 = 'S') and ((ln_numcom + ln_csbsE) >= 1) then
       if (P_N_CRIAPL = '5') then --criterio ratio determinante
         return 'S';          
       end if;
    end if;

    return 'N';

  end;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_ratio_end(P_N_DEUTOT in number,
                                           P_N_PATRIM in number,
                                           P_N_MONMAX in number,
                                           P_N_INGNET in number,
                                           P_C_TIPPAS in varchar
                                           ) return number is
  ln_ratio number(18,4);
  begin
  
    ln_ratio := 0;

    if trim(P_C_TIPPAS) = 'P' then
       if ( P_N_PATRIM <> 0 ) then
          ln_ratio := P_N_DEUTOT / P_N_PATRIM;
       end if;    
    end if;
    if trim(P_C_TIPPAS) = 'C' then
       if ( P_N_INGNET <= 1999 and P_N_INGNET <> 0 ) then
          ln_ratio := P_N_MONMAX / (P_N_INGNET*10);
       end if;
       if ( P_N_INGNET >= 2000 and P_N_INGNET <= 4999 and P_N_INGNET <> 0 ) then
          ln_ratio := P_N_MONMAX / (P_N_INGNET*11);
       end if;
       if ( P_N_INGNET >= 5000 and P_N_INGNET <> 0 ) then
          ln_ratio := P_N_MONMAX / (P_N_INGNET*12);      
       end if;   
    end if;    
    
    return ln_ratio * 100;
    
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_ultimo_resnet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number,
                                           p_n_tipcam in number
                                           ) return number is
  ln_numeva jaql154.jaql154nev%type;
  ln_jaql154rns jaql154.jaql154rns%type;
  ln_jaql154rnd jaql154.jaql154rnd%type;

  begin

    begin
      select max(jaql154nev)
      into ln_numeva
      from jaql154
      where jaql154tdo = p_c_tipdoc
      and jaql154ndo = p_c_numdoc
      and jaql154ani = p_n_anio
      and jaql154mes = p_n_mes
      order by jaql154nev desc;
    exception when no_data_found then
      ln_numeva := 0;
    end;

    begin
      select jaql154rns, jaql154rnd
      into ln_jaql154rns, ln_jaql154rnd
      from jaql154
      where jaql154.jaql154tdo = p_c_tipdoc
      and jaql154.jaql154ndo = p_c_numdoc
      and jaql154.jaql154ani = p_n_anio
      and jaql154.jaql154mes = p_n_mes
      and jaql154nev = ln_numeva
      and rownum = 1;
    exception when no_data_found then
      ln_jaql154rns := 0;
      ln_jaql154rnd := 0;
    end;

      return ln_jaql154rns + ln_jaql154rnd*p_n_tipcam;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_ultimo_ratdet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number
                                           ) return number is
  ln_numeva jaql154.jaql154nev%type;
  ln_jaql154rdt jaql154.jaql154rdt%type;

  begin

    begin
      select max(jaql154nev)
      into ln_numeva
      from jaql154
      where jaql154tdo = p_c_tipdoc
      and jaql154ndo = p_c_numdoc
      and jaql154ani = p_n_anio
      and jaql154mes = p_n_mes
      order by jaql154nev desc;
    exception when no_data_found then
      ln_numeva := 0;
    end;

    begin
      select jaql154rdt
      into ln_jaql154rdt
      from jaql154
      where jaql154.jaql154tdo = p_c_tipdoc
      and jaql154.jaql154ndo = p_c_numdoc
      and jaql154.jaql154ani = p_n_anio
      and jaql154.jaql154mes = p_n_mes
      and jaql154nev = ln_numeva
      and rownum = 1;
    exception when no_data_found then
      ln_jaql154rdt := 0;
    end;

      return ln_jaql154rdt;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_ultimo_ingnet(p_c_tipdoc in number,
                                           p_c_numdoc in varchar2,
                                           p_n_anio in number,
                                           p_n_mes in number,
                                           p_n_tipcam in number
                                           ) return number is
  ln_numeva jaql154.jaql154nev%type;
  ln_jaql154ins jaql154.jaql154ins%type;
  ln_jaql154ind jaql154.jaql154ind%type;

  begin

    begin
      select max(jaql154nev)
      into ln_numeva
      from jaql154
      where jaql154tdo = p_c_tipdoc
      and jaql154ndo = p_c_numdoc
      and jaql154ani = p_n_anio
      and jaql154mes = p_n_mes
      order by jaql154nev desc;
    exception when no_data_found then
      ln_numeva := 0;
    end;

    begin
      select jaql154ins, jaql154ind
      into ln_jaql154ins, ln_jaql154ind
      from jaql154
      where jaql154.jaql154tdo = p_c_tipdoc
      and jaql154.jaql154ndo = p_c_numdoc
      and jaql154.jaql154ani = p_n_anio
      and jaql154.jaql154mes = p_n_mes
      and jaql154nev = ln_numeva
      and rownum = 1;
    exception when no_data_found then
      ln_jaql154ins := 0;
      ln_jaql154ind := 0;
    end;

      return ln_jaql154ins + ln_jaql154ind*p_n_tipcam;

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_tipocambio(p_in_fecha in date) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TIPOCAMBIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Autor de Creación          : drodriguezd
    -- Uso                        : Devuelve del tipo de cambio actual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_tipcam: tipo de cambio actual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam fsh005.COTCBI%type;

  begin

    select cotcbi
      into ln_tipcam
      from fsh005
     where moneda = 101
       and rownum = 1
       and cofdes <= p_in_fecha
     order by cofdes desc;

    return ln_tipcam;

  exception
    when no_data_found then
      ln_tipcam := 0;
      return ln_tipcam;

  end fn_cr_tipocambio;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_datos_evaluaciones(P_N_PAIS   in Number,
                                     P_N_TIPDOC in Number,
                                     P_C_NUMDOC in Char,
                                     P_C_TIPCLI in char,
                                     p_n_soles out number,
                                     p_n_dolares out number,
                                     p_n_egfsol out number,
                                     p_n_egfdol out number,
                                     p_n_patsol out number,
                                     p_n_patdol out number,
                                     p_n_patsol1 out number,
                                     p_n_patdol1 out number,
                                     p_n_vensol out number,
                                     p_n_vendol out number,
                                     p_n_resnsol out number,
                                     p_n_resndol out number,
                                     P_D_FECHA in date) IS
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_EVALUACIONES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos - Riesgo
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEE
    -- Uso                        : Evaluación financiera y socioeconomica
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_PAIS   (codigo pais)
    --                              P_N_TIPDOC (Tipo de documento)
    --                              P_C_NUMDOC (Numero de documento)
    -- Parámetros de Salida       : p_n_soles (Neto Financiero Soles)
    --                              p_n_dolares (Neto Financiero Dolares)
    --                              p_n_brfsol (Bruto Financiero Soles)
    --                              p_n_brfdol (Bruto Financiero Dolares)
    --                              p_n_rsfnet (Resultado neto financiero)
    --                              p_n_patsol (Patrimoniio soles)
    --                              p_n_patdol (Patrimonio dolares)
    --                              p_n_egfsol (Egreso financiero soles)
    --                              p_n_egfdol (Egreso financiero dolares)
    --                              p_n_ntssol (Neto socioeconomico soles)
    --                              p_n_ntsdol (Neto socioeconomico dolares)
    --                              p_n_brssol (Bruto socioeconomico soles)
    --                              p_n_brsdol (Bruto socioeconomico dolares)
    --                              p_n_rssnet (Resultado neto socioeconomico)
    --                              p_n_egfsol (Egreso socioeconomico soles)
    --                              p_n_egsdol (Egreso socioeconomico dolares)
    --                              p_n_camfjs (Cambio fijo socioeconomico)
    --                              p_n_camfjf (Cambio fijo financiero)
    --                              p_n_vensol (Ventas soles)
    --                              p_n_vendol (Ventas dolares)
    --                              p_d_fecevf (Fecha evalaución financiera)
    --                              p_d_fecevs (Fecha evaluación socioeconomica)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
  ln_numeva sng021.sng021eval%type;
  ln_anio number := to_number(EXTRACT(YEAR FROM P_D_FECHA));
  ln_mes number := to_number(EXTRACT(MONTH FROM P_D_FECHA));
  ln_tipprd number;

  BEGIN

    if P_C_TIPCLI = 'P' then
       ln_tipprd := 13;
    end if;
    if P_C_TIPCLI = 'C' then
       ln_tipprd := 14;    
    end if;

    begin
    
      select sng021eval
      into ln_numeva
      from
      (
        select h.sng021eval, h.sng021fec
        from fsh014 f
        inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                    and f.hasuc = x.XWFSUCURSAL
                    and f.hamda = x.XWFMONEDA
                    and f.hapap = x.XWFPAPEL
                    and f.hacta = x.XWFCUENTA
                    and f.haoper = x.XWFOPERACION
  --                  and f.hasbop = x.XWFSUBOPE
  --                  and f.hatope = x.XWFTIPOPE
                    and f.hamod = x.XWFMODULO
        inner join sng021 h on x.xwfprcins = h.sng021sol
        where 
        f.pgcod = 1
        and r.cttfir = 'T'
        and x.xwfcar3 = '1'
        and f.haanio = ln_anio
        and ( f.hamod in (select /*+ PUSH_SUBQ */ modulo from fst111 where dscod = 50) or f.hamod  = 117 )
        and 
        (
          ( ln_mes = 1 and f.hasd01 <> 0 ) or 
          ( ln_mes = 2 and f.hasd02 <> 0 ) or 
          ( ln_mes = 3 and f.hasd03 <> 0 ) or
          ( ln_mes = 4 and f.hasd04 <> 0 ) or
          ( ln_mes = 5 and f.hasd05 <> 0 ) or
          ( ln_mes = 6 and f.hasd06 <> 0 ) or
          ( ln_mes = 7 and f.hasd07 <> 0 ) or
          ( ln_mes = 8 and f.hasd08 <> 0 ) or
          ( ln_mes = 9 and f.hasd09 <> 0 ) or
          ( ln_mes = 10 and f.hasd10 <> 0 ) or
          ( ln_mes = 11 and f.hasd11 <> 0 ) or
          ( ln_mes = 12 and f.hasd12 <> 0 )
        )
        and x.xwfprcins <> 0 --drc PRY3303 (2)
        and r.pepais = p_n_pais
        and r.petdoc = p_n_tipdoc    
        and r.pendoc = p_c_numdoc
        and h.sng021tmod = ln_tipprd --drc PRY3303 (2)
        order by h.sng021fec desc
      )
      where rownum = 1;    
        
    exception when others then
      ln_numeva := null;
    end;

    BEGIN

      -- Evaluación Financiera Pyme
      if P_C_TIPCLI = 'P' then

        select
        SUM(nvl(n_brfsol, 0)) +
        SUM(nvl(n_brfsol1, 0))+
        SUM(nvl(n_brfsol2, 0))+
        SUM(nvl(n_brfsol3, 0)) n_soles,
        SUM(nvl(n_brfdol, 0)) +
        SUM(nvl(n_brfdol1, 0))+
        SUM(nvl(n_brfdol2, 0))+
        SUM(nvl(n_brfdol3, 0)) n_dolares,
        SUM(nvl(n_egfsol, 0)),
        SUM(nvl(n_egfdol, 0)),
        SUM(nvl(n_patsol, 0)),
        SUM(nvl(n_patdol, 0)),
        SUM(nvl(n_patsol1, 0)),
        SUM(nvl(n_patdol1, 0)),
        SUM(nvl(n_vensol, 0)),
        SUM(nvl(n_vendol, 0)),
        SUM(nvl(n_resnsol, 0)),
        SUM(nvl(n_resndol, 0))
        into
        p_n_soles,
        p_n_dolares,
        p_n_egfsol,
        p_n_egfdol,
        p_n_patsol,
        p_n_patdol,
        p_n_patsol1,
        p_n_patdol1,
        p_n_vensol,
        p_n_vendol,
        p_n_resnsol,
        p_n_resndol
        from (select distinct
        Case when g.sng026cod = 1 Then NVL(g.sng023mto, 0) end n_brfsol,
        Case when g.sng026cod = 501 Then NVL(g.sng023mto, 0) end n_brfdol,
        Case when g.sng026cod = 2 Then NVL(g.sng023mto, 0) end n_brfsol1,
        Case when g.sng026cod = 502 Then NVL(g.sng023mto, 0) end n_brfdol1,
        Case when g.sng026cod = 3 Then NVL(g.sng023mto, 0) end n_brfsol2,
        Case when g.sng026cod = 503 Then NVL(g.sng023mto, 0) end n_brfdol2,
        Case when g.sng026cod = 4 Then NVL(g.sng023mto, 0) end n_brfsol3,
        Case when g.sng026cod = 504 Then NVL(g.sng023mto, 0) end n_brfdol3,
        Case when g.sng026cod = 21 Then NVL(g.sng023mto, 0) end n_egfsol,
        Case when g.sng026cod = 521 Then NVL(g.sng023mto, 0) end n_egfdol,
        Case when g.sng026cod = 25 Then NVL(g.sng023mto, 0) end n_patsol1,
        Case when g.sng026cod = 525 Then NVL(g.sng023mto, 0) end n_patdol1,
        Case when g.sng026cod = 70 Then NVL(g.sng023mto, 0) end n_patsol,
        Case when g.sng026cod = 570 Then NVL(g.sng023mto, 0) end n_patdol,
        Case when g.sng026cod = 73 Then NVL(g.sng023mto, 0) end n_vensol,
        Case when g.sng026cod = 573 Then NVL(g.sng023mto, 0) end n_vendol,
        Case when g.sng026cod = 40 Then NVL(g.sng023mto, 0) end n_resnsol,
        Case when g.sng026cod = 540 Then NVL(g.sng023mto, 0) end n_resndol
        from sng023 g , sng021 h, xwf700 x
        where x.xwfprcins = h.sng021sol
        and g.sng021eval = h.sng021eval
        and h.sng021pdoc = P_N_PAIS
        and h.sng021tdoc = P_N_TIPDOC
        and h.sng021ndoc = P_C_NUMDOC
        and h.sng021eval = ln_numeva);

      end if;

      -- Evaluación Financiera Consumo
      if P_C_TIPCLI = 'C' then
        select
        SUM(nvl(n_brfsol, 0)) +
        SUM(nvl(n_brfsol1, 0))+
        SUM(nvl(n_brfsol2, 0))+
        SUM(nvl(n_brfsol3, 0)) n_soles,
        SUM(nvl(n_brfdol, 0)) +
        SUM(nvl(n_brfdol1, 0))+
        SUM(nvl(n_brfdol2, 0))+
        SUM(nvl(n_brfdol3, 0)) n_dolares,
        SUM(nvl(n_egfsol, 0)),
        SUM(nvl(n_egfdol, 0)),
        SUM(nvl(n_patsol, 0)),
        SUM(nvl(n_patdol, 0)),
        SUM(nvl(n_patsol1, 0)),
        SUM(nvl(n_patdol1, 0)),
        SUM(nvl(n_vensol, 0)),
        SUM(nvl(n_vendol, 0)),
        SUM(nvl(n_resnsol, 0)),
        SUM(nvl(n_resndol, 0))
        into
        p_n_soles,
        p_n_dolares,
        p_n_egfsol,
        p_n_egfdol,
        p_n_patsol,
        p_n_patdol,
        p_n_patsol1,
        p_n_patdol1,
        p_n_vensol,
        p_n_vendol,
        p_n_resnsol,
        p_n_resndol
        from (select distinct
        Case when g.sng026cod = 1 Then NVL(g.sng023mto, 0) end n_brfsol,
        Case when g.sng026cod = 501 Then NVL(g.sng023mto, 0) end n_brfdol,
        Case when g.sng026cod = 2 Then NVL(g.sng023mto, 0) end n_brfsol1,
        Case when g.sng026cod = 502 Then NVL(g.sng023mto, 0) end n_brfdol1,
        Case when g.sng026cod = 3 Then NVL(g.sng023mto, 0) end n_brfsol2,
        Case when g.sng026cod = 503 Then NVL(g.sng023mto, 0) end n_brfdol2,
        Case when g.sng026cod = 4 Then NVL(g.sng023mto, 0) end n_brfsol3,
        Case when g.sng026cod = 504 Then NVL(g.sng023mto, 0) end n_brfdol3,
        Case when g.sng026cod = 21 Then NVL(g.sng023mto, 0) end n_egfsol,
        Case when g.sng026cod = 521 Then NVL(g.sng023mto, 0) end n_egfdol,
        Case when g.sng026cod = 25 Then NVL(g.sng023mto, 0) end n_patsol1,
        Case when g.sng026cod = 525 Then NVL(g.sng023mto, 0) end n_patdol1,
        Case when g.sng026cod = 70 Then NVL(g.sng023mto, 0) end n_patsol,
        Case when g.sng026cod = 570 Then NVL(g.sng023mto, 0) end n_patdol,
        Case when g.sng026cod = 73 Then NVL(g.sng023mto, 0) end n_vensol,
        Case when g.sng026cod = 573 Then NVL(g.sng023mto, 0) end n_vendol,
        Case when g.sng026cod = 27 Then NVL(g.sng023mto, 0) end n_resnsol,
        Case when g.sng026cod = 527 Then NVL(g.sng023mto, 0) end n_resndol
        from sng023 g , sng021 h, xwf700 x
        where x.xwfprcins = h.sng021sol
        and g.sng021eval = h.sng021eval
        and h.sng021pdoc = P_N_PAIS
        and h.sng021tdoc = P_N_TIPDOC
        and h.sng021ndoc = P_C_NUMDOC
        and h.sng021eval = ln_numeva);

        end If;

      EXCEPTION
        WHEN OTHERS THEN
        p_n_soles   := 0;
        p_n_dolares := 0;
        p_n_egfsol  := 0;
        p_n_egfdol  := 0;
        p_n_patsol  := 0;
        p_n_patdol  := 0;
        p_n_patsol1 := 0;
        p_n_patdol1 := 0;
        p_n_vensol  := 0;
        p_n_vendol  := 0;
      END;

  end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_ultimo(P_C_TIPVAL in varchar2,
                        P_D_FECTRA in date,
                        p_c_mespro out varchar2,
                        p_c_anopro out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_ULTIMO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener mes y año de ultimo parametro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_TIPVAL (TIPO DE PARAMETRO)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    -- Parámetros de Salida       : p_c_mespro (Mes de proceso)
    --                            : p_c_anopro (Año de proceso)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
  begin

    select to_char(max(to_date(h.jaql664ano || h.jaql664mes || '01', 'yyyymmdd')),
                   'MM'),
           to_char(max(to_date(h.jaql664ano || h.jaql664mes || '01', 'yyyymmdd')),
                   'YYYY')
      into p_c_mespro, p_c_anopro
      from jaql664 h
     where last_day(to_date(h.jaql664ano || h.jaql664mes || '01', 'yyyymmdd')) <=
           P_D_FECTRA
       and h.jaql664tval = P_C_TIPVAL
       and h.jaql664est = 'S';

  exception
    when others then
      p_c_mespro := null;
      p_c_anopro := null;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac1(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_datos_cmac1
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);    
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);    


--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,
      -- determinar cartas fianza
             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd01 dsalmn,
        f.hasd01 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd01 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;        
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd01 dsalmn,
                f.hasd01 dsalmo,
                l.hasd01 dsalmo2,
                f.hamod dmodul,
                l.hasd01 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd01 <> 0
                and l.hasd01 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   f.hasd01,
                                   f.hasd01 * P_N_TIPCAM),
                            0),
                     0))*-1 n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd01 + f.hasd01,
                        (l.hasd01 + f.hasd01) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd01 + f.hasd01,
                               (l.hasd01 + f.hasd01) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd01 + f.hasd01,
                               (l.hasd01 + f.hasd01) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd01 + f.hasd01,
                             (l.hasd01 + f.hasd01) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd01 + f.hasd01,
                             (l.hasd01 + f.hasd01) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd01 + f.hasd01,
                             (l.hasd01 + f.hasd01) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd01 + f.hasd01)*-1,
                               (n.hasd01 + f.hasd01)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd01 + f.hasd01)*-1,
                               (n.hasd01 + f.hasd01)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd01 + f.hasd01)*-1,
                               (n.hasd01 + f.hasd01)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd01 + f.hasd01)*-1,
                               (n.hasd01 + f.hasd01)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd01 + f.hasd01)*-1,
                               (n.hasd01 + f.hasd01)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd01 + f.hasd01,
                                         (l.hasd01 + f.hasd01) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud
                                  
        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd01 <> 0
                and l.hasd01 <> 0 --
                and n.hasd01 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd01 + l.hasd01,
                               (f.hasd01 + l.hasd01) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd01 + l.hasd01,
                               (f.hasd01 + l.hasd01) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01 + l.hasd01,
                               (f.hasd01 + l.hasd01) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd01 + l.hasd01,
                               (f.hasd01 + l.hasd01) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01 + l.hasd01,
                               (f.hasd01 + l.hasd01) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd01 <> 0
                and l.hasd01 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd01)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd01 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd01 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd01 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

    --************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac2(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_datos_cmac2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);    


--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd02 dsalmn,
        f.hasd02 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd02 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd02 dsalmn,
                f.hasd02 dsalmo,
                l.hasd02 dsalmo2,
                f.hamod dmodul,
                l.hasd02 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd02 <> 0
                and l.hasd02 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd02,
                                   l.hasd02 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd02 + f.hasd02,
                        (l.hasd02 + f.hasd02) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd02 + f.hasd02,
                               (l.hasd02 + f.hasd02) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd02 + f.hasd02,
                               (l.hasd02 + f.hasd02) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd02 + f.hasd02,
                             (l.hasd02 + f.hasd02) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd02 + f.hasd02,
                             (l.hasd02 + f.hasd02) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd02 + f.hasd02,
                             (l.hasd02 + f.hasd02) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd02 + f.hasd02)*-1,
                               (n.hasd02 + f.hasd02)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd02 + f.hasd02)*-1,
                               (n.hasd02 + f.hasd02)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd02 + f.hasd02)*-1,
                               (n.hasd02 + f.hasd02)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd02 + f.hasd02)*-1,
                               (n.hasd02 + f.hasd02)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd02 + f.hasd02)*-1,
                               (n.hasd02 + f.hasd02)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd02 + f.hasd02,
                                         (l.hasd02 + f.hasd02) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd02 <> 0
                and l.hasd02 <> 0 --
                and n.hasd02 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;                
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd02 + l.hasd02,
                               (f.hasd02 + l.hasd02) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd02 + l.hasd02,
                               (f.hasd02 + l.hasd02) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd02 + l.hasd02,
                               (f.hasd02 + l.hasd02) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd02 + l.hasd02,
                               (f.hasd02 + l.hasd02) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd02 + l.hasd02,
                               (f.hasd02 + l.hasd02) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd02 <> 0
                and l.hasd02 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd02)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd02 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd02 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd02 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac3(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);   

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd03 dsalmn,
        f.hasd03 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd03 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd03 dsalmn,
                f.hasd03 dsalmo,
                l.hasd03 dsalmo2,
                f.hamod dmodul,
                l.hasd03 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd03 <> 0
                and l.hasd03 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd03,
                                   l.hasd03 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd03 + f.hasd03,
                        (l.hasd03 + f.hasd03) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd03 + f.hasd03,
                               (l.hasd03 + f.hasd03) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd03 + f.hasd03,
                               (l.hasd03 + f.hasd03) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd03 + f.hasd03,
                             (l.hasd03 + f.hasd03) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd03 + f.hasd03,
                             (l.hasd03 + f.hasd03) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd03 + f.hasd03,
                             (l.hasd03 + f.hasd03) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd03 + f.hasd03)*-1,
                               (n.hasd03 + f.hasd03)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd03 + f.hasd03)*-1,
                               (n.hasd03 + f.hasd03)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd03 + f.hasd03)*-1,
                               (n.hasd03 + f.hasd03)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd03 + f.hasd03)*-1,
                               (n.hasd03 + f.hasd03)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd03 + f.hasd03)*-1,
                               (n.hasd03 + f.hasd03)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd03 + f.hasd03,
                                         (l.hasd03 + f.hasd03) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd03 <> 0
                and l.hasd03 <> 0 --
                and n.hasd03 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd03 + l.hasd03,
                               (f.hasd03 + l.hasd03) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd03 + l.hasd03,
                               (f.hasd03 + l.hasd03) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd03 + l.hasd03,
                               (f.hasd03 + l.hasd03) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd03 + l.hasd03,
                               (f.hasd03 + l.hasd03) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd03 + l.hasd03,
                               (f.hasd03 + l.hasd03) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd03 <> 0
                and l.hasd03 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd03)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd03 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd03 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd03 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac4(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

            
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd04 dsalmn,
        f.hasd04 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd04 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd04 dsalmn,
                f.hasd04 dsalmo,
                l.hasd04 dsalmo2,
                f.hamod dmodul,
                l.hasd04 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd04 <> 0
                and l.hasd04 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd04,
                                   l.hasd04 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd04 + f.hasd04,
                        (l.hasd04 + f.hasd04) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd04 + f.hasd04,
                               (l.hasd04 + f.hasd04) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd04 + f.hasd04,
                               (l.hasd04 + f.hasd04) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd04 + f.hasd04,
                             (l.hasd04 + f.hasd04) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd04 + f.hasd04,
                             (l.hasd04 + f.hasd04) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd04 + f.hasd04,
                             (l.hasd04 + f.hasd04) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd04 + f.hasd04)*-1,
                               (n.hasd04 + f.hasd04)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd04 + f.hasd04)*-1,
                               (n.hasd04 + f.hasd04)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd04 + f.hasd04)*-1,
                               (n.hasd04 + f.hasd04)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd04 + f.hasd04)*-1,
                               (n.hasd04 + f.hasd04)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd04 + f.hasd04)*-1,
                               (n.hasd04 + f.hasd04)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd04 + f.hasd04,
                                         (l.hasd04 + f.hasd04) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd04 <> 0
                and l.hasd04 <> 0 --
                and n.hasd04 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd04 + l.hasd04,
                               (f.hasd04 + l.hasd04) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd04 + l.hasd04,
                               (f.hasd04 + l.hasd04) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd04 + l.hasd04,
                               (f.hasd04 + l.hasd04) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd04 + l.hasd04,
                               (f.hasd04 + l.hasd04) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd04 + l.hasd04,
                               (f.hasd04 + l.hasd04) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd04 <> 0
                and l.hasd04 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd04)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd04 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd04 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd04 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac5(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd05 dsalmn,
        f.hasd05 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd05 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd05 dsalmn,
                f.hasd05 dsalmo,
                l.hasd05 dsalmo2,
                f.hamod dmodul,
                l.hasd05 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd05 <> 0
                and l.hasd05 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd05,
                                   l.hasd05 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd05 + f.hasd05,
                        (l.hasd05 + f.hasd05) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd05 + f.hasd05,
                               (l.hasd05 + f.hasd05) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd05 + f.hasd05,
                               (l.hasd05 + f.hasd05) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd05 + f.hasd05,
                             (l.hasd05 + f.hasd05) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd05 + f.hasd05,
                             (l.hasd05 + f.hasd05) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd05 + f.hasd05,
                             (l.hasd05 + f.hasd05) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd05 + f.hasd05)*-1,
                               (n.hasd05 + f.hasd05)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd05 + f.hasd05)*-1,
                               (n.hasd05 + f.hasd05)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd05 + f.hasd05)*-1,
                               (n.hasd05 + f.hasd05)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd05 + f.hasd05)*-1,
                               (n.hasd05 + f.hasd05)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd05 + f.hasd05)*-1,
                               (n.hasd05 + f.hasd05)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd05 + f.hasd05,
                                         (l.hasd05 + f.hasd05) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc
                and n.hamda = f.hamda
                and n.hapap = f.hapap
                and n.hacta = f.hacta
                and n.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd05 <> 0
                and l.hasd05 <> 0 --
                and n.hasd05 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd05 + l.hasd05,
                               (f.hasd05 + l.hasd05) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd05 + l.hasd05,
                               (f.hasd05 + l.hasd05) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd05 + l.hasd05,
                               (f.hasd05 + l.hasd05) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd05 + l.hasd05,
                               (f.hasd05 + l.hasd05) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd05 + l.hasd05,
                               (f.hasd05 + l.hasd05) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd05 <> 0
                and l.hasd05 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd05)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd05 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd05 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd05 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac6(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd06 dsalmn,
        f.hasd06 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd06 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd06 dsalmn,
                f.hasd06 dsalmo,
                l.hasd06 dsalmo2,
                f.hamod dmodul,
                l.hasd06 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd06 <> 0
                and l.hasd06 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd06,
                                   l.hasd06 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd06 + f.hasd06,
                        (l.hasd06 + f.hasd06) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd06 + f.hasd06,
                               (l.hasd06 + f.hasd06) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd06 + f.hasd06,
                               (l.hasd06 + f.hasd06) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd06 + f.hasd06,
                             (l.hasd06 + f.hasd06) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd06 + f.hasd06,
                             (l.hasd06 + f.hasd06) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd06 + f.hasd06,
                             (l.hasd06 + f.hasd06) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd06 + f.hasd06)*-1,
                               (n.hasd06 + f.hasd06)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd06 + f.hasd06)*-1,
                               (n.hasd06 + f.hasd06)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd06 + f.hasd06)*-1,
                               (n.hasd06 + f.hasd06)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd06 + f.hasd06)*-1,
                               (n.hasd06 + f.hasd06)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd06 + f.hasd06)*-1,
                               (n.hasd06 + f.hasd06)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd06 + f.hasd06,
                                         (l.hasd06 + f.hasd06) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd06 <> 0
                and l.hasd06 <> 0 --
                and n.hasd06 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd06 + l.hasd06,
                               (f.hasd06 + l.hasd06) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd06 + l.hasd06,
                               (f.hasd06 + l.hasd06) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd06 + l.hasd06,
                               (f.hasd06 + l.hasd06) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd06 + l.hasd06,
                               (f.hasd06 + l.hasd06) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd06 + l.hasd06,
                               (f.hasd06 + l.hasd06) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd06 <> 0
                and l.hasd06 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd06)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd06 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd06 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd06 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac7(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);

    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd07 dsalmn,
        f.hasd07 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd07 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd07 dsalmn,
                f.hasd07 dsalmo,
                l.hasd07 dsalmo2,
                f.hamod dmodul,
                l.hasd07 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd07 <> 0
                and l.hasd07 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd07,
                                   l.hasd07 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd07 + f.hasd07,
                        (l.hasd07 + f.hasd07) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd07 + f.hasd07,
                               (l.hasd07 + f.hasd07) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd07 + f.hasd07,
                               (l.hasd07 + f.hasd07) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd07 + f.hasd07,
                             (l.hasd07 + f.hasd07) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd07 + f.hasd07,
                             (l.hasd07 + f.hasd07) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd07 + f.hasd07,
                             (l.hasd07 + f.hasd07) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd07 + f.hasd07)*-1,
                               (n.hasd07 + f.hasd07)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd07 + f.hasd07)*-1,
                               (n.hasd07 + f.hasd07)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd07 + f.hasd07)*-1,
                               (n.hasd07 + f.hasd07)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd07 + f.hasd07)*-1,
                               (n.hasd07 + f.hasd07)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd07 + f.hasd07)*-1,
                               (n.hasd07 + f.hasd07)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd07 + f.hasd07,
                                         (l.hasd07 + f.hasd07) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd07 <> 0
                and l.hasd07 <> 0 --
                and n.hasd07 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd07 + l.hasd07,
                               (f.hasd07 + l.hasd07) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd07 + l.hasd07,
                               (f.hasd07 + l.hasd07) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd07 + l.hasd07,
                               (f.hasd07 + l.hasd07) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd07 + l.hasd07,
                               (f.hasd07 + l.hasd07) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd07 + l.hasd07,
                               (f.hasd07 + l.hasd07) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd07 <> 0
                and l.hasd07 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd07)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd07 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd07 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd07 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac8(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd08 dsalmn,
        f.hasd08 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd08 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd08 dsalmn,
                f.hasd08 dsalmo,
                l.hasd08 dsalmo2,
                f.hamod dmodul,
                l.hasd08 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd08 <> 0
                and l.hasd08 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd08,
                                   l.hasd08 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd08 + f.hasd08,
                        (l.hasd08 + f.hasd08) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd08 + f.hasd08,
                               (l.hasd08 + f.hasd08) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd08 + f.hasd08,
                               (l.hasd08 + f.hasd08) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd08 + f.hasd08,
                             (l.hasd08 + f.hasd08) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd08 + f.hasd08,
                             (l.hasd08 + f.hasd08) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd08 + f.hasd08,
                             (l.hasd08 + f.hasd08) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd08 + f.hasd08)*-1,
                               (n.hasd08 + f.hasd08)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd08 + f.hasd08)*-1,
                               (n.hasd08 + f.hasd08)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd08 + f.hasd08)*-1,
                               (n.hasd08 + f.hasd08)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd08 + f.hasd08)*-1,
                               (n.hasd08 + f.hasd08)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd08 + f.hasd08)*-1,
                               (n.hasd08 + f.hasd08)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd08 + f.hasd08,
                                         (l.hasd08 + f.hasd08) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd08 <> 0
                and l.hasd08 <> 0 --
                and n.hasd08 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd08 + l.hasd08,
                               (f.hasd08 + l.hasd08) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd08 + l.hasd08,
                               (f.hasd08 + l.hasd08) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd08 + l.hasd08,
                               (f.hasd08 + l.hasd08) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd08 + l.hasd08,
                               (f.hasd08 + l.hasd08) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd08 + l.hasd08,
                               (f.hasd08 + l.hasd08) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd08 <> 0
                and l.hasd08 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd08)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd08 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd08 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd08 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac9(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);       

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd09 dsalmn,
        f.hasd09 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd09 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd09 dsalmn,
                f.hasd09 dsalmo,
                l.hasd09 dsalmo2,
                f.hamod dmodul,
                l.hasd09 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd09 <> 0
                and l.hasd09 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd09,
                                   l.hasd09 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd09 + f.hasd09,
                        (l.hasd09 + f.hasd09) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd09 + f.hasd09,
                               (l.hasd09 + f.hasd09) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd09 + f.hasd09,
                               (l.hasd09 + f.hasd09) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd09 + f.hasd09,
                             (l.hasd09 + f.hasd09) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd09 + f.hasd09,
                             (l.hasd09 + f.hasd09) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd09 + f.hasd09,
                             (l.hasd09 + f.hasd09) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd09 + f.hasd09)*-1,
                               (n.hasd09 + f.hasd09)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd09 + f.hasd09)*-1,
                               (n.hasd09 + f.hasd09)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd09 + f.hasd09)*-1,
                               (n.hasd09 + f.hasd09)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd09 + f.hasd09)*-1,
                               (n.hasd09 + f.hasd09)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd09 + f.hasd09)*-1,
                               (n.hasd09 + f.hasd09)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd09 + f.hasd09,
                                         (l.hasd09 + f.hasd09) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd09 <> 0
                and l.hasd09 <> 0 --
                and n.hasd09 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd09 + l.hasd09,
                               (f.hasd09 + l.hasd09) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd09 + l.hasd09,
                               (f.hasd09 + l.hasd09) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd09 + l.hasd09,
                               (f.hasd09 + l.hasd09) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd09 + l.hasd09,
                               (f.hasd09 + l.hasd09) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd09 + l.hasd09,
                               (f.hasd09 + l.hasd09) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd09 <> 0
                and l.hasd09 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd09)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd09 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd09 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd09 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac10(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd10 dsalmn,
        f.hasd10 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd10 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd10 dsalmn,
                f.hasd10 dsalmo,
                l.hasd10 dsalmo2,
                f.hamod dmodul,
                l.hasd10 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd10 <> 0
                and l.hasd10 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd10,
                                   l.hasd10 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd10 + f.hasd10,
                        (l.hasd10 + f.hasd10) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd10 + f.hasd10,
                               (l.hasd10 + f.hasd10) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd10 + f.hasd10,
                               (l.hasd10 + f.hasd10) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd10 + f.hasd10,
                             (l.hasd10 + f.hasd10) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd10 + f.hasd10,
                             (l.hasd10 + f.hasd10) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd10 + f.hasd10,
                             (l.hasd10 + f.hasd10) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd10 + f.hasd10)*-1,
                               (n.hasd10 + f.hasd10)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd10 + f.hasd10)*-1,
                               (n.hasd10 + f.hasd10)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd10 + f.hasd10)*-1,
                               (n.hasd10 + f.hasd10)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd10 + f.hasd10)*-1,
                               (n.hasd10 + f.hasd10)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd10 + f.hasd10)*-1,
                               (n.hasd10 + f.hasd10)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd10 + f.hasd10,
                                         (l.hasd10 + f.hasd10) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd10 <> 0
                and l.hasd10 <> 0 --
                and n.hasd10 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd10 + l.hasd10,
                               (f.hasd10 + l.hasd10) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd10 + l.hasd10,
                               (f.hasd10 + l.hasd10) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd10 + l.hasd10,
                               (f.hasd10 + l.hasd10) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd10 + l.hasd10,
                               (f.hasd10 + l.hasd10) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd10 + l.hasd10,
                               (f.hasd10 + l.hasd10) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd10 <> 0
                and l.hasd10 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd10)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd10 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd10 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd10 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac11(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);    
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd11 dsalmn,
        f.hasd11 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd11 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd11 dsalmn,
                f.hasd11 dsalmo,
                l.hasd11 dsalmo2,
                f.hamod dmodul,
                l.hasd11 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd11 <> 0
                and l.hasd11 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd11,
                                   l.hasd11 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd11 + f.hasd11,
                        (l.hasd11 + f.hasd11) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd11 + f.hasd11,
                               (l.hasd11 + f.hasd11) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd11 + f.hasd11,
                               (l.hasd11 + f.hasd11) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd11 + f.hasd11,
                             (l.hasd11 + f.hasd11) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd11 + f.hasd11,
                             (l.hasd11 + f.hasd11) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd11 + f.hasd11,
                             (l.hasd11 + f.hasd11) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd11 + f.hasd11)*-1,
                               (n.hasd11 + f.hasd11)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd11 + f.hasd11)*-1,
                               (n.hasd11 + f.hasd11)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd11 + f.hasd11)*-1,
                               (n.hasd11 + f.hasd11)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd11 + f.hasd11)*-1,
                               (n.hasd11 + f.hasd11)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd11 + f.hasd11)*-1,
                               (n.hasd11 + f.hasd11)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd11 + f.hasd11,
                                         (l.hasd11 + f.hasd11) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd11 <> 0
                and l.hasd11 <> 0 --
                and n.hasd11 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd11 + l.hasd11,
                               (f.hasd11 + l.hasd11) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd11 + l.hasd11,
                               (f.hasd11 + l.hasd11) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd11 + l.hasd11,
                               (f.hasd11 + l.hasd11) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd11 + l.hasd11,
                               (f.hasd11 + l.hasd11) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd11 + l.hasd11,
                               (f.hasd11 + l.hasd11) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd11 <> 0
                and l.hasd11 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd11)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd11 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd11 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd11 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_datos_cmac12(P_N_Pais in number,
                             P_N_TIPDOC in number,
                             P_C_NUMDOC in Varchar2,
                             P_N_TIPCAM in number,
                             p_n_cuocm3 out number,
                             p_n_cuocm5 out number,
                             p_n_cuocm2 out number,
                             p_n_cuocm7 out number,
                             p_n_cuocm4 out number,
                             p_n_cucff3 out number,
                             p_n_cucff5 out number,
                             p_n_cucff2 out number,
                             p_n_cucff7 out number,
                             p_n_cucff4 out number,
                             p_n_salff3 out number,
                             p_n_salff5 out number,
                             p_n_salff2 out number,
                             p_n_salff7 out number,
                             p_n_salff4 out number,
                             p_n_lnucma out number,
                             p_n_cafcma out number,
                             p_n_salcap out number,
                             p_n_intdev out number,
                             p_n_mtolin out number,
                             p_n_linrev out number,
                             p_n_salhip out number,
                             p_n_salcap3 out number,
                             p_n_salcap5 out number,
                             p_n_salcap2 out number,
                             p_n_salcap7 out number,
                             p_n_salcap4 out number,
                             P_D_FECHA in date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_DATOS_CMAC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Riesgos
    -- Versión                    : 1.1
    -- Fecha de Creación          : 2013.05.30
    -- Autor de Creación          : DRODRIGUEZD
    -- Uso                        : Obtener cuotas, linea no utilizada y cartas fianza de CMAC
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : PAIS (Pais de la persona)
    --                              TIPO DOCUMENTO (Tipo de documento de la persona)
    --                              NUMERO DE DOCUMENTO (Numero documento)
    --                              P_D_FECTRA (FECHA DE PROCESO)
    --                              P_N_TIPCAM (TIPO DE CAMBIO)
    -- Parámetros de Salida       : p_n_cuocm3 (Cuota CMAC - Microempresa)
    --                              p_n_cuocm5 (Cuota CMAC - Pequeña empresa)
    --                              p_n_cuocm2 (Cuota CMAC - Consumo no revolvente)
    --                              p_n_cuocm7 (Cuota CMAC - Consumo revolvente)
    --                              p_n_cuocm4 (Cuota CMAC - Hipotecario)
    --                              p_n_cucff3 (Cuota CMAC FF - Microempresa)
    --                              p_n_cucff5 (Cuota CMAC FF - Pequeña empresa)
    --                              p_n_cucff2 (Cuota CMAC FF - Consumo no revolvente)
    --                              p_n_cucff7 (Cuota CMAC FF - Consumo revolvente)
    --                              p_n_cucff4 (Cuota CMAC FF - Hipotecario)
    --                              p_n_salff3 (Saldo CMAC FF - Microempresa)
    --                              p_n_salff5 (Saldo CMAC FF - Pequeña empresa)
    --                              p_n_salff2 (Saldo CMAC FF - Consumo no revolvente)
    --                              p_n_salff7 (Saldo CMAC FF - Consumo revolvente)
    --                              p_n_salff4 (Saldo CMAC FF - Hipotecario)
    --                              p_n_lnucma (Linea no utilizada CMAC)
    --                              p_n_cafcma (Cartas fianza CMAC)
    --                              p_n_salcap (Saldo capital CMAC)
    --                              p_n_intdev (interes devengado CMAC)
    --                              p_n_mtolin (Monto de lineas CMAC)
    --                              p_n_linrev (Monto de lineas revolventes CMAC)
    --                              p_n_salhip (Saldo creditos hipotecarios CMAC)
    -- Fecha de Modificación      : 2014.04.29
    -- Autor de la Modificación   : DRODRIGUEE
    -- Descripción de Modificación: En créditos normales considerar sólo si es titular
    --
    -- *****************************************************************

    ln_lnucma number(17, 2);
    ln_cuoln3 number(17, 2);
    ln_cuoln5 number(17, 2);
    ln_cuoln2 number(17, 2);
    ln_cuoln7 number(17, 2);
    ln_cuoln4 number(17, 2);
    ln_salln3 number(17, 2);
    ln_salln5 number(17, 2);
    ln_salln2 number(17, 2);
    ln_salln7 number(17, 2);
    ln_salln4 number(17, 2);

    ln_cafcma number(17, 2);
    ln_cuocf3 number(17, 2);
    ln_cuocf5 number(17, 2);
    ln_cuocf2 number(17, 2);
    ln_cuocf7 number(17, 2);
    ln_cuocf4 number(17, 2);
    ln_salcf3 number(17, 2);
    ln_salcf5 number(17, 2);
    ln_salcf2 number(17, 2);
    ln_salcf7 number(17, 2);
    ln_salcf4 number(17, 2);

    ln_pais jaql154.jaql154pai%type;
    ln_tipdoc jaql154.jaql154tdo%type;
    lc_numdoc jaql154.jaql154ndo%type;

--******************************************************************
    p_n_cuocm3_lin number(17, 2);
    p_n_cuocm5_lin number(17, 2);
    p_n_cuocm2_lin number(17, 2);
    p_n_cuocm7_lin number(17, 2);
    p_n_cuocm4_lin number(17, 2);
    p_n_salcap_lin number(17, 2);
    p_n_intdev_lin number(17, 2);
    p_n_mtolin_lin number(17, 2);
    p_n_linrev_lin number(17, 2);
    p_n_salhip_lin number(17, 2);

    ln_lnucma_lin number(17, 2);
    ln_salln3_lin number(17, 2);
    ln_salln5_lin number(17, 2);
    ln_salln2_lin number(17, 2);
    ln_salln7_lin number(17, 2);
    ln_salln4_lin number(17, 2);
    ln_cuoln3_lin number(17, 2);
    ln_cuoln5_lin number(17, 2);
    ln_cuoln2_lin number(17, 2);
    ln_cuoln7_lin number(17, 2);
    ln_cuoln4_lin number(17, 2);

    ln_cafcma_lin number(17, 2);
    ln_salcf3_lin number(17, 2);
    ln_salcf5_lin number(17, 2);
    ln_salcf2_lin number(17, 2);
    ln_salcf7_lin number(17, 2);
    ln_salcf4_lin number(17, 2);
    ln_cuocf3_lin number(17, 2);
    ln_cuocf5_lin number(17, 2);
    ln_cuocf2_lin number(17, 2);
    ln_cuocf7_lin number(17, 2);
    ln_cuocf4_lin number(17, 2);

    p_n_cuocm3_jud number(17, 2);
    p_n_cuocm5_jud number(17, 2);
    p_n_cuocm2_jud number(17, 2);
    p_n_cuocm7_jud number(17, 2);
    p_n_cuocm4_jud number(17, 2);
    p_n_mtolin_jud number(17, 2);
    p_n_lnucma_jud number(17, 2);
    p_n_salcm3_jud number(17, 2);
    p_n_salcm5_jud number(17, 2);
    p_n_salcm2_jud number(17, 2);
    p_n_salcm7_jud number(17, 2);
    p_n_salcm4_jud number(17, 2);
    p_n_cuoln3_jud number(17, 2);
    p_n_cuoln5_jud number(17, 2);
    p_n_cuoln2_jud number(17, 2);
    p_n_cuoln7_jud number(17, 2);
    p_n_cuoln4_jud number(17, 2);
    p_n_linrev_jud number(17, 2);

    p_n_mtolin_nde number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_lin number(17, 2);
    ln_salcap5_lin number(17, 2);
    ln_salcap2_lin number(17, 2);
    ln_salcap7_lin number(17, 2);
    ln_salcap4_lin number(17, 2);
    ln_salcap3_jud number(17, 2);
    ln_salcap5_jud number(17, 2);
    ln_salcap2_jud number(17, 2);
    ln_salcap7_jud number(17, 2);
    ln_salcap4_jud number(17, 2);        

        
--******************************************************************

  begin

    ln_pais := P_N_PAIS;
    ln_tipdoc := P_N_TIPDOC;
    lc_numdoc := P_C_NUMDOC;

    --CRÉDITOS NORMALES

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap,
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev,

      -- determinar cartas fianza

             sum(nvl(decode(dmodul,
                            142,decode(dmnda,
                        0,
                        dsalmn,
                        dsalmo * P_N_TIPCAM),0),0)) n_cafcma,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm3,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm5,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM))),0),0)) n_salcm2,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn,
                             dsalmo * P_N_TIPCAM),
                      0),0),0)) n_salcm7,
             sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0),0),0)) n_salcm4,
             --
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              2,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm3,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              13,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm5,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3, decode(substr(drubro,11,3),015,
              0,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              3,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm7,
              sum(nvl(decode(dmodul,
                            142,decode(dgrpg,
              4,
              decode(dmnda,
              0,
              dcuoim,
              dcuoim * P_N_TIPCAM),
              0),0),0)) n_cuocm4,

      -- determinar saldos capital 
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4

        into p_n_cuocm3, p_n_cuocm5, p_n_cuocm2, p_n_cuocm7, p_n_cuocm4,
             p_n_salcap, p_n_salhip, p_n_intdev,

             ln_cafcma,
             ln_salcf3,
             ln_salcf5,
             ln_salcf2,
             ln_salcf7,
             ln_salcf4,
             ln_cuocf3,
             ln_cuocf5,
             ln_cuocf2,
             ln_cuocf7,
             ln_cuocf4,
             
             ln_salcap3,
             ln_salcap5,
             ln_salcap2,
             ln_salcap7,
             ln_salcap4
        from
        (
        select distinct --drc PRY3303
        f.hagru dgrpg,
        f.hamda dmnda,
        PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                             P_IN_SUCUR => f.hasuc,
                                                             P_IN_MDA => f.hamda,
                                                             P_IN_PAP => f.hapap,
                                                             P_IN_CTA => f.hacta,
                                                             P_IN_OPER => f.haoper,
                                                             P_IN_TOPE => f.hatope,
                                                             P_IN_MOD => f.hamod,
                                                             P_D_FECHA => P_D_FECHA) dcuoim,
        f.harub drubro,
        f.hasd12 dsalmn,
        f.hasd12 dsalmo,
        f.hamod dmodul
        from fsh014 f
        inner join fst111 g on f.hamod = g.modulo
        inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                          and f.hasuc = x.XWFSUCURSAL
                          and f.hamda = x.XWFMONEDA
                          and f.hapap = x.XWFPAPEL
                          and f.hacta = x.XWFCUENTA
                          and f.haoper = x.XWFOPERACION
                          and f.hasbop = x.XWFSUBOPE
                          and f.hatope = x.XWFTIPOPE
                          and f.hamod = x.XWFMODULO
       inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
                          and r.cttfir = 'T'
       where f.hasd12 <> 0
         and f.hamod <> 33
         and f.hamod <> 117
         and f.hamod <> 116
         and x.xwfcar3 = '1'
         and r.pepais = ln_pais
         and r.petdoc = ln_tipdoc
         and r.pendoc = lc_numdoc
         and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
        );

    exception
      when others then
        p_n_cuocm3 := 0;
        p_n_cuocm5 := 0;
        p_n_cuocm2 := 0;
        p_n_cuocm7 := 0;
        p_n_cuocm4 := 0;

        p_n_salcap := 0;
        p_n_salhip := 0;
        p_n_intdev := 0;

        ln_cafcma := 0;
        ln_cuocf3 := 0;
        ln_cuocf5 := 0;
        ln_cuocf2 := 0;
        ln_cuocf7 := 0;
        ln_cuocf4 := 0;
        ln_salcf3 := 0;
        ln_salcf5 := 0;
        ln_salcf2 := 0;
        ln_salcf7 := 0;
        ln_salcf4 := 0;
        
        ln_salcap3 := 0;
        ln_salcap5 := 0;
        ln_salcap2 := 0;
        ln_salcap7 := 0;
        ln_salcap4 := 0;
    end;

--************************************************************
    --LINEAS DE CRÉDITO 117 - 116

    begin
      select
      -- determinar cuotas CMAC
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM)))) n_cuocm2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0))) n_cuocm7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0)) n_cuocm4_lin,
      -- saldos cmac
             sum(nvl(decode(dmnda,
                            0,
                            dsalmn,
                            dsalmo * P_N_TIPCAM),
                     0)) *-1 n_salcap_lin,
             sum(nvl(decode(dmodul,
                            116,
                            decode(dmnda,
                                   0,
                                   dsalmn2,
                                   dsalmo2 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_lin,--*
             sum(nvl(decode(dgrpg,
                            4,
                            decode(dmnda,
                                   0,
                                   dsalmn,
                                   dsalmo * P_N_TIPCAM),
                            0),
                     0)) *-1 n_salhip_lin,
      --intereses devengados
             sum(nvl(decode(dmodul,403,
                            decode(substr(drubro,1,2),14,
                                          decode(substr(drubro,4,1),8,
                                                        decode(dmnda,
                                                               0,
                                                               dsalmn,
                                                               dsalmo * P_N_TIPCAM)
                                                        ,0)
                                          ,0)
                            ,0)
                 ,0)) n_intdev_lin,

      -- determinar linea no utilizada CMAC

           sum(nvl(decode(dmodul,
                            116,decode(dmnda,
                        0,
                        dsalmn2 + dsalmn,
                        (dsalmn2 + dsalmo) * P_N_TIPCAM),0),0)) n_lnucma_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn2 + dsalmn,
                               (dsalmn2 + dsalmo) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3, decode(substr(drubro,11,3),015,
                      0,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM))),0),0)) n_salcm2_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      3,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                      4,
                      decode(dmnda,
                             0,
                             dsalmn2 + dsalmn,
                             (dsalmn2 + dsalmo) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_lin,
           sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm3_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm5_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM))),0),0)) n_cuocm2_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        3,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm7_lin,
             sum(nvl(decode(dmodul,
                            116,decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dcuoim,
                               dcuoim * P_N_TIPCAM),
                        0),0),0)) n_cuocm4_lin,
             sum(nvl(decode(dmodul,
                            116,decode(substr(drubro,11,3),015,
                                  decode(dmnda,
                                         0,
                                         dsalmn2 + dsalmn,
                                         (dsalmn2 + dsalmo) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_lin,
                     
      -- determinar saldos capital línea
             sum(decode(dgrpg,
                        2,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap3_lin,
             sum(decode(dgrpg,
                        13,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap5_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        0,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM))))*-1 n_salcap2_lin,
             sum(decode(dgrpg,
                        3, decode(substr(drubro,11,3),015,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0)))*-1 n_salcap7_lin,
             sum(decode(dgrpg,
                        4,
                        decode(dmnda,
                               0,
                               dsalmn,
                               dsalmo * P_N_TIPCAM),
                        0))*-1 n_salcap4_lin

        into p_n_cuocm3_lin, p_n_cuocm5_lin, p_n_cuocm2_lin, p_n_cuocm7_lin, p_n_cuocm4_lin,
             p_n_salcap_lin, p_n_mtolin_lin, p_n_salhip_lin,
             p_n_intdev_lin,

             ln_lnucma_lin,
             ln_salln3_lin,
             ln_salln5_lin,
             ln_salln2_lin,
             ln_salln7_lin,
             ln_salln4_lin,
             ln_cuoln3_lin,
             ln_cuoln5_lin,
             ln_cuoln2_lin,
             ln_cuoln7_lin,
             ln_cuoln4_lin,
             p_n_linrev_lin,
             
             ln_salcap3_lin,
             ln_salcap5_lin,
             ln_salcap2_lin,
             ln_salcap7_lin,
             ln_salcap4_lin

             from
             (
                select
                f.hagru dgrpg,
                f.hamda dmnda,
                PQ_CR_JAQL157_SOBEND.fn_cr_cuota_imp(P_IN_PGCOD => f.pgcod,
                                                                     P_IN_SUCUR => f.hasuc,
                                                                     P_IN_MDA => f.hamda,
                                                                     P_IN_PAP => f.hapap,
                                                                     P_IN_CTA => f.hacta,
                                                                     P_IN_OPER => f.haoper,
                                                                     P_IN_TOPE => f.hatope,
                                                                     P_IN_MOD => f.hamod,
                                                                     P_D_FECHA => P_D_FECHA) dcuoim,
                f.harub drubro,
                f.hasd12 dsalmn,
                f.hasd12 dsalmo,
                l.hasd12 dsalmo2,
                f.hamod dmodul,
                l.hasd12 dsalmn2
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod

                inner join fsr011 r11 --/*
                on r11.r1cod = f.pgcod
                and r11.r1mod = f.hamod
                and r11.r1suc = f.hasuc
                and r11.r1mda = f.hamda
                and r11.r1pap = f.hapap
                and r11.r1cta = f.hacta
                and r11.r1oper = f.haoper
                and r11.r1sbop = f.hasbop
                and r11.r1tope = f.hatope
                and r11.r2cod = l.pgcod
                and r11.r2mod = l.hamod
                and r11.r2suc = l.hasuc
                and r11.r2mda = l.hamda
                and r11.r2pap = l.hapap
                and r11.r2cta = l.hacta
                and r11.r2oper = l.haoper
                and r11.r2sbop = l.hasbop
                and r11.r2tope = l.hatope
                and r11.relcod = 46 --*/

                where l.hamod = 117
                and f.hasd12 <> 0
                and l.hasd12 <> 0
                and f.hamod <> 33
                and l.hamod <> 33
                and f.hamod = 116
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
             );

    exception
      when others then
        p_n_cuocm3_lin := 0;
        p_n_cuocm5_lin := 0;
        p_n_cuocm2_lin := 0;
        p_n_cuocm7_lin := 0;
        p_n_cuocm4_lin := 0;

        p_n_salcap_lin := 0;
        p_n_mtolin_lin := 0;
        p_n_salhip_lin := 0;

        p_n_intdev_lin := 0;

        ln_lnucma_lin := 0;
        ln_cuoln3_lin := 0;
        ln_cuoln5_lin := 0;
        ln_cuoln2_lin := 0;
        ln_cuoln7_lin := 0;
        ln_cuoln4_lin := 0;
        ln_salln3_lin := 0;
        ln_salln5_lin := 0;
        ln_salln2_lin := 0;
        ln_salln7_lin := 0;
        ln_salln4_lin := 0;
        p_n_linrev_lin := 0;

        ln_salcap3_lin := 0;
        ln_salcap5_lin := 0;
        ln_salcap2_lin := 0;
        ln_salcap7_lin := 0;
        ln_salcap4_lin := 0;

    end;

--************************************************************
    --LINEAS DE CRÉDITO EN JUDICIAL 117(línea) - 200(judicial) - 455(intereses)

    begin
      select
      -- saldos cmac
             sum(nvl(decode(l.hamod,
                            117,
                            decode(f.hamda,
                                   0,
                                   l.hasd12,
                                   l.hasd12 * P_N_TIPCAM),
                            0),
                     0)) n_mtolin_jud,
      -- determinar linea no utilizada CMAC
           sum(nvl(decode(l.hamod,
                            117,decode(f.hamda,
                        0,
                        l.hasd12 + f.hasd12,
                        (l.hasd12 + f.hasd12) * P_N_TIPCAM),0),0)) n_lnucma_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               l.hasd12 + f.hasd12,
                               (l.hasd12 + f.hasd12) * P_N_TIPCAM),
                        0),0),0)) n_salcm3_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               l.hasd12 + f.hasd12,
                               (l.hasd12 + f.hasd12) * P_N_TIPCAM),
                        0),0),0)) n_salcm5_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3, decode(substr(f.harub,11,3),015,
                      0,
                      decode(f.hamda,
                             0,
                             l.hasd12 + f.hasd12,
                             (l.hasd12 + f.hasd12) * P_N_TIPCAM))),0),0)) n_salcm2_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      3,
                      decode(f.hamda,
                             0,
                             l.hasd12 + f.hasd12,
                             (l.hasd12 + f.hasd12) * P_N_TIPCAM),
                      0),0),0)) n_salcm7_jud,
           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                      4,
                      decode(f.hamda,
                             0,
                             l.hasd12 + f.hasd12,
                             (l.hasd12 + f.hasd12) * P_N_TIPCAM),
                      0),0),0)) n_salcm4_jud,

           sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               (n.hasd12 + f.hasd12)*-1,
                               (n.hasd12 + f.hasd12)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln3_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               (n.hasd12 + f.hasd12)*-1,
                               (n.hasd12 + f.hasd12)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln5_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               (n.hasd12 + f.hasd12)*-1,
                               (n.hasd12 + f.hasd12)*-1 * P_N_TIPCAM))),0),0)) n_cuoln2_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               (n.hasd12 + f.hasd12)*-1,
                               (n.hasd12 + f.hasd12)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln7_jud,
             sum(nvl(decode(l.hamod,
                            117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               (n.hasd12 + f.hasd12)*-1,
                               (n.hasd12 + f.hasd12)*-1 * P_N_TIPCAM),
                        0),0),0)) n_cuoln4_jud,

             sum(nvl(decode(l.hamod,
                            117,decode(substr(f.harub,11,3),015,
                                  decode(f.hamda,
                                         0,
                                         l.hasd12 + f.hasd12,
                                         (l.hasd12 + f.hasd12) * P_N_TIPCAM),
                                  0),0),0)) n_linrev_jud,
                                  
             --saldos línea judicial                    
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          2,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap3_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                          13,
                          decode(f.hamda,
                                 0,
                                 f.hasd01,
                                 f.hasd01 * P_N_TIPCAM),
                          0),0),0))*-1 n_salcap5_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM))),0),0))*-1 n_salcap2_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        3,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap7_jud,
             sum(nvl(decode(l.hamod,
                              117,decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd01,
                               f.hasd01 * P_N_TIPCAM),
                        0),0),0))*-1 n_salcap4_jud

        into
        p_n_mtolin_jud,
        p_n_lnucma_jud,
        p_n_salcm3_jud,
        p_n_salcm5_jud,
        p_n_salcm2_jud,
        p_n_salcm7_jud,
        p_n_salcm4_jud,
        p_n_cuoln3_jud,
        p_n_cuoln5_jud,
        p_n_cuoln2_jud,
        p_n_cuoln7_jud,
        p_n_cuoln4_jud,
        p_n_linrev_jud,
        ln_salcap3_jud,
        ln_salcap5_jud,
        ln_salcap2_jud,
        ln_salcap7_jud,
        ln_salcap4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsh014 n on n.pgcod = f.pgcod
                and n.hasuc = f.hasuc --
                and n.hamda = f.hamda --
                and n.hapap = f.hapap --
                and n.hacta = f.hacta --
                and n.haoper = f.haoper --

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                                       and r.ctnro = n.hacta
                                       and r.pgcod = n.pgcod
                where l.hamod = 117
                and f.hasd12 <> 0
                and l.hasd12 <> 0 --
                and n.hasd12 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and n.hamod = 455
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'

                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and n.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));
    exception
      when others then
        p_n_mtolin_jud := 0;
        p_n_lnucma_jud := 0;
        p_n_salcm3_jud := 0;
        p_n_salcm5_jud := 0;
        p_n_salcm2_jud := 0;
        p_n_salcm7_jud := 0;
        p_n_salcm4_jud := 0;
        p_n_cuoln3_jud := 0;
        p_n_cuoln5_jud := 0;
        p_n_cuoln2_jud := 0;
        p_n_cuoln7_jud := 0;
        p_n_cuoln4_jud := 0;
        p_n_linrev_jud := 0;
        ln_salcap3_jud := 0;
        ln_salcap5_jud := 0;
        ln_salcap2_jud := 0;
        ln_salcap7_jud := 0;
        ln_salcap4_jud := 0;        
    end;

--**************************************************************************
    --CUOTAS PARA JUDICIALES

    begin
       select
             sum(decode(f.hagru,
                        2,
                        decode(f.hamda,
                               0,
                               f.hasd12 + l.hasd12,
                               (f.hasd12 + l.hasd12) * P_N_TIPCAM),
                        0)) *-1 n_cuocm3_jud,
             sum(decode(f.hagru,
                        13,
                        decode(f.hamda,
                               0,
                               f.hasd12 + l.hasd12,
                               (f.hasd12 + l.hasd12) * P_N_TIPCAM),
                        0)) *-1 n_cuocm5_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        0,
                        decode(f.hamda,
                               0,
                               f.hasd12 + l.hasd12,
                               (f.hasd12 + l.hasd12) * P_N_TIPCAM)))) *-1 n_cuocm2_jud,
             sum(decode(f.hagru,
                        3, decode(substr(f.harub,11,3),015,
                        decode(f.hamda,
                               0,
                               f.hasd12 + l.hasd12,
                               (f.hasd12 + l.hasd12) * P_N_TIPCAM),
                        0))) *-1 n_cuocm7_jud,
             sum(decode(f.hagru,
                        4,
                        decode(f.hamda,
                               0,
                               f.hasd12 + l.hasd12,
                               (f.hasd12 + l.hasd12) * P_N_TIPCAM),
                        0)) *-1 n_cuocm4_jud
                into p_n_cuocm3_jud, p_n_cuocm5_jud, p_n_cuocm2_jud, p_n_cuocm7_jud, p_n_cuocm4_jud
                from fsh014 l
                inner join fsh014 f on l.pgcod = f.pgcod
                and l.hasuc = f.hasuc
                and l.hamda = f.hamda
                and l.hapap = f.hapap
                and l.hacta = f.hacta
                and l.haoper = f.haoper

                inner join fsr008 r on r.ctnro = f.hacta
                                       and r.pgcod = f.pgcod
                                       and r.ctnro = l.hacta
                                       and r.pgcod = l.pgcod
                where l.hamod = 455
                and f.hasd12 <> 0
                and l.hasd12 <> 0 --
                and f.hamod <> 33
                and f.hamod = 200
                and r.pgcod = 1
                and r.pepais = ln_pais
                and r.petdoc = ln_tipdoc
                and r.pendoc = lc_numdoc
                and r.cttfir = 'T'
                and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA));

    exception
      when others then
        p_n_cuocm3_jud := 0;
        p_n_cuocm5_jud := 0;
        p_n_cuocm2_jud := 0;
        p_n_cuocm7_jud := 0;
        p_n_cuocm4_jud := 0;
    end;

--**************************************************************************
    --LINEAS NO DESEMBOLSADAS

    begin
      select sum(l.hasd12)
      into p_n_mtolin_nde
      from fsh014 l
      inner join fsr008 r on r.ctnro = l.hacta
                             and r.pgcod = l.pgcod
      where l.hasd12 <> 0
      and l.hamod = 117
      and r.pgcod = 1
      and r.pepais = ln_pais
      and r.petdoc = ln_tipdoc
      and r.pendoc = lc_numdoc
      and r.cttfir = 'T'

      and l.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 116
          and f.hasd12 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      )
      and not exists
      (
          select f.hamod from fsh014 f
          where l.pgcod = f.pgcod
          and l.hasuc = f.hasuc
          and l.hamda = f.hamda
          and l.hapap = f.hapap
          and l.hacta = f.hacta
          and l.haoper = f.haoper
          and f.hamod = 200
          and f.hasd12 <> 0

          and f.haanio = to_number(EXTRACT(YEAR FROM P_D_FECHA))
      );
    exception when others then
      p_n_mtolin_nde := 0;
    end;

--************************************************************


    p_n_cuocm3 := nvl(p_n_cuocm3,0) + nvl(p_n_cuocm3_lin,0) + nvl(p_n_cuocm3_jud,0);
    p_n_cuocm5 := nvl(p_n_cuocm5,0) + nvl(p_n_cuocm5_lin,0) + nvl(p_n_cuocm5_jud,0);
    p_n_cuocm2 := nvl(p_n_cuocm2,0) + nvl(p_n_cuocm2_lin,0) + nvl(p_n_cuocm2_jud,0);
    p_n_cuocm7 := nvl(p_n_cuocm7,0) + nvl(p_n_cuocm7_lin,0) + nvl(p_n_cuocm7_jud,0);
    p_n_cuocm4 := nvl(p_n_cuocm4,0) + nvl(p_n_cuocm4_lin,0) + nvl(p_n_cuocm4_jud,0);
    p_n_salcap := nvl(p_n_salcap,0) + nvl(p_n_salcap_lin,0);
    p_n_mtolin := nvl(p_n_mtolin,0) + nvl(p_n_mtolin_lin,0) + nvl(p_n_mtolin_jud,0) + nvl(p_n_mtolin_nde,0);
    p_n_salhip := nvl(p_n_salhip,0) + nvl(p_n_salhip_lin,0);
    p_n_intdev := nvl(p_n_intdev,0) + nvl(p_n_intdev_lin,0);
    ln_lnucma := nvl(ln_lnucma,0) + nvl(ln_lnucma_lin,0) + nvl(p_n_lnucma_jud,0);
    ln_salln3 := nvl(ln_salln3,0) + nvl(ln_salln3_lin,0) + nvl(p_n_salcm3_jud,0);
    ln_salln5 := nvl(ln_salln5,0) + nvl(ln_salln5_lin,0) + nvl(p_n_salcm5_jud,0);
    ln_salln2 := nvl(ln_salln2,0) + nvl(ln_salln2_lin,0) + nvl(p_n_salcm2_jud,0);
    ln_salln7 := nvl(ln_salln7,0) + nvl(ln_salln7_lin,0) + nvl(p_n_salcm7_jud,0);
    ln_salln4 := nvl(ln_salln4,0) + nvl(ln_salln4_lin,0) + nvl(p_n_salcm4_jud,0);
    ln_cuoln3 := nvl(ln_cuoln3,0) + nvl(ln_cuoln3_lin,0) + nvl(p_n_cuoln3_jud,0);
    ln_cuoln5 := nvl(ln_cuoln5,0) + nvl(ln_cuoln5_lin,0) + nvl(p_n_cuoln5_jud,0);
    ln_cuoln2 := nvl(ln_cuoln2,0) + nvl(ln_cuoln2_lin,0) + nvl(p_n_cuoln2_jud,0);
    ln_cuoln7 := nvl(ln_cuoln7,0) + nvl(ln_cuoln7_lin,0) + nvl(p_n_cuoln7_jud,0);
    ln_cuoln4 := nvl(ln_cuoln4,0) + nvl(ln_cuoln4_lin,0) + nvl(p_n_cuoln4_jud,0);
    p_n_linrev := nvl(p_n_linrev,0) + nvl(p_n_linrev_lin,0) + nvl(p_n_linrev_jud,0);
    ln_cafcma := nvl(ln_cafcma,0) + nvl(ln_cafcma_lin,0);
    ln_salcf3 := nvl(ln_salcf3,0) + nvl(ln_salcf3_lin,0);
    ln_salcf5 := nvl(ln_salcf5,0) + nvl(ln_salcf5_lin,0);
    ln_salcf2 := nvl(ln_salcf2,0) + nvl(ln_salcf2_lin,0);
    ln_salcf7 := nvl(ln_salcf7,0) + nvl(ln_salcf7_lin,0);
    ln_salcf4 := nvl(ln_salcf4,0) + nvl(ln_salcf4_lin,0);
    ln_cuocf3 := nvl(ln_cuocf3,0) + nvl(ln_cuocf3_lin,0);
    ln_cuocf5 := nvl(ln_cuocf5,0) + nvl(ln_cuocf5_lin,0);
    ln_cuocf2 := nvl(ln_cuocf2,0) + nvl(ln_cuocf2_lin,0);
    ln_cuocf7 := nvl(ln_cuocf7,0) + nvl(ln_cuocf7_lin,0);
    ln_cuocf4 := nvl(ln_cuocf4,0) + nvl(ln_cuocf4_lin,0);

--************************************************************

    p_n_cucff3 := nvl(ln_cuoln3, 0) + nvl(ln_cuocf3, 0);
    p_n_cucff5 := nvl(ln_cuoln5, 0) + nvl(ln_cuocf5, 0);
    p_n_cucff2 := nvl(ln_cuoln2, 0) + nvl(ln_cuocf2, 0);
    p_n_cucff7 := nvl(ln_cuoln7, 0) + nvl(ln_cuocf7, 0);
    p_n_cucff4 := nvl(ln_cuoln4, 0) + nvl(ln_cuocf4, 0);

    p_n_salff3 := nvl(ln_salln3, 0) + nvl(ln_salcf3, 0);
    p_n_salff5 := nvl(ln_salln5, 0) + nvl(ln_salcf5, 0);
    p_n_salff2 := nvl(ln_salln2, 0) + nvl(ln_salcf2, 0);
    p_n_salff7 := nvl(ln_salln7, 0) + nvl(ln_salcf7, 0);
    p_n_salff4 := nvl(ln_salln4, 0) + nvl(ln_salcf4, 0);

    p_n_lnucma := nvl(ln_lnucma, 0);
    p_n_cafcma := nvl(ln_cafcma, 0);

    --************************************************************
    
    p_n_salcap3 := nvl(ln_salcap3, 0) + nvl(ln_salcap3_lin, 0) + nvl(ln_salcap3_jud, 0);
    p_n_salcap5 := nvl(ln_salcap5, 0) + nvl(ln_salcap5_lin, 0) + nvl(ln_salcap5_jud, 0);
    p_n_salcap2 := nvl(ln_salcap2, 0) + nvl(ln_salcap2_lin, 0) + nvl(ln_salcap2_jud, 0);
    p_n_salcap7 := nvl(ln_salcap7, 0) + nvl(ln_salcap7_lin, 0) + nvl(ln_salcap7_jud, 0);
    p_n_salcap4 := nvl(ln_salcap4, 0) + nvl(ln_salcap4_lin, 0) + nvl(ln_salcap4_jud, 0);

  end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_intdeveng(P_N_RUBRO in number,
                           P_N_Pgcod in number,
                           P_N_Scsuc in number,
                           P_N_Scmda in number,
                           P_N_Scpap in number,
                           P_N_Sccta in number,
                           P_N_Scoper in number,
                           P_N_Scsbop in number,
                           P_N_intdev out number) is

  ln_rubintdev fsr014.rrrubr%type;


  begin

    begin
      select rrrubr
      into ln_rubintdev
      from fsr014
      where Rubro = P_N_RUBRO;
    exception when others then
        ln_rubintdev := 0;
  
    end;

    begin
      select scsdo
      into P_N_intdev
      from fsd011
      Where Pgcod  = P_N_Pgcod
      and Scsuc    = P_N_Scsuc
      and Scrub    = ln_rubintdev
      and Scmda    = P_N_Scmda
      and Scpap    = P_N_Scpap
      and Sccta    = P_N_Sccta
      and Scoper   = P_N_Scoper
      and Scsbop   = P_N_Scsbop;
  
    exception when others then
        P_N_intdev := 0;
    end;


  end sp_cr_intdeveng;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_cr_codsbs(P_C_TIPDOC in number,
                          P_C_NUMDOC in char) return varchar is
  
    P_C_codsbs cldrcci.c_codsbs%type;
  begin
  
      P_C_codsbs := '0';
  
      if P_C_TIPDOC = '21' then
      begin
          select b.c_codsbs
          into P_C_codsbs
          from cldrcci b inner join fst098 k
          on b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
          where k.tpcod = 7647
          and k.tpcorr = 12
          and b.c_docide = trim(P_C_NUMDOC)
          and rownum = 1;
  
      exception when others then
         P_C_codsbs := '0';
      end;
  
      end If;
  
      if P_C_TIPDOC <> '21' then
      begin
          select b.c_codsbs
          into P_C_codsbs
          from cldrcci b inner join fst098 k
          on b.d_fecpre = to_date(k.tpnro,'DD/MM/RRRR')
          where k.tpcod = 7647
          and k.tpcorr = 12
          and b.c_tdoctr = trim(P_C_TIPDOC) and b.c_doctri = trim(P_C_NUMDOC)
          and rownum = 1;
  
      exception when others then
        P_C_codsbs := '0';
      end;
  
      end If;
  
      return P_C_codsbs;
  
  end fn_cr_codsbs;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_nument(P_C_TIPDOC in number,
                        P_C_NUMDOC in char,
                        P_N_ANIO in number,
                        P_N_MES in number) return number is
  
  p_n_nument jaql155.jaql155ent%type;
  p_n_numcon jaql155.jaql155ent%type;
  p_c_doccon fsr002.rpndoc%type;
  
  begin
      p_n_nument := 0;
      p_n_numcon := 0;
  
      begin
  
        select fsr002.rpndoc
        into p_c_doccon
        from fsr002
        where fsr002.rpccyg = 66 -- relación
        and fsr002.petdoc = P_C_TIPDOC
        and fsr002.pendoc = P_C_NUMDOC
        and rownum = 1;
  
        select jaql154.jaql154csf
        into p_n_numcon
        from jaql154
        where jaql154.jaql154ndo = p_c_doccon
        and jaql154.jaql154ani = P_N_ANIO
        and jaql154.jaql154mes = P_N_MES
        and rownum = 1;
  
      exception when others then
        p_n_numcon := 0;
      end;
  
      begin
  
        select jaql154.jaql154csf
        into p_n_nument
        from jaql154
        where jaql154.jaql154ndo = P_C_NUMDOC
        and jaql154.jaql154ani = P_N_ANIO
        and jaql154.jaql154mes = P_N_MES
        and rownum = 1;
  
      exception when others then
        p_n_nument := 0;
      end;
  
      return p_n_nument + p_n_numcon;
  
  end fn_cr_nument;

--------------------------------------------------------------------------------------------------
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sobreend_jaql154(P_D_FECHA in date,
                                   P_N_REGINI in number,
                                   P_N_REGFIN in number) IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_sobreend_jaql154
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos - Riesgos
  -- Versión                    : 1.1
  -- Fecha de Creación          : 2013.05.30
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : Procesar datos de sobreendeudamiento
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_D_FECHA (FECHA DE PROCESO)
  --                              P_N_REGINI (REGISTRO DE INICIO)
  --                              P_N_REGINI (REGISTRO DE FIN)
  -- Fecha de Modificación      : 2014.04.29
  -- Autor de la Modificación   : DRODRIGUEE
  -- Descripción de Modificación: Convertir a cuotas saldos ff del SF
  -- *****************************************************************
   
    n_count number(17);
    n_count2 number(17);

    c_jaql154tcs char(1);

    c_jaql154sec char(1);
    c_jaql154spy char(1);
    d_JAQL101fch jaql101.JAQL101fch%type;
    n_JAQL101cor jaql101.JAQL101cor%type;
    n_tipact number(15);
    c_jaql154anl char(30);

    lc_ulteva jaql154.jaql154des%type;
   
    n_tot_deudir number(17, 2);
    n_tit_dcmdir number(17, 2);
    n_tit_dsfdir number(17, 2);
    n_con_dcmdir number(17, 2);
    n_con_dsfdir number(17, 2);

    n_tit_dcmpot number(17, 2);
    n_tit_dsfpot number(17, 2);
    n_tot_deupot number(17, 2);
    n_con_dcmpot number(17, 2);
    n_con_dsfpot number(17, 2);

    n_crercc number(17, 2);
    n_devrcc number(17, 2);

    n_crercc_c number(17, 2);
    n_devrcc_c number(17, 2);

    ln_credir_rcc number(17, 2);
    ln_credir_rcd number(17, 2);
    ln_intdev_rcc number(17, 2);
    ln_intdev_rcd number(17, 2);

    ln_credir_rcc_c number(17, 2);
    ln_credir_rcd_c number(17, 2);
    ln_intdev_rcc_c number(17, 2);
    ln_intdev_rcd_c number(17, 2);


    p_n_pais1 fsr008.pepais%type;
    p_n_tipdoc1 fsr008.petdoc%type;
    p_c_numdoc1 fsr008.pendoc%type;

    n_tit_cuosf3 jaql664.jaql664vdat%type;
    n_tit_cuosf5 jaql664.jaql664vdat%type;
    n_tit_cuosf2 jaql664.jaql664vdat%type;
    n_tit_cuosf7 jaql664.jaql664vdat%type;
    n_tit_cuosf4 jaql664.jaql664vdat%type;

    n_con_cuosf3 jaql664.jaql664vdat%type;
    n_con_cuosf5 jaql664.jaql664vdat%type;
    n_con_cuosf2 jaql664.jaql664vdat%type;
    n_con_cuosf7 jaql664.jaql664vdat%type;
    n_con_cuosf4 jaql664.jaql664vdat%type;

    n_tit_cusff3 number(17, 2);
    n_tit_cusff5 number(17, 2);
    n_tit_cusff2 number(17, 2);
    n_tit_cusff7 number(17, 2);
    n_tit_cusff4 number(17, 2);

    n_tit_cucff3 number(17, 2);
    n_tit_cucff5 number(17, 2);
    n_tit_cucff2 number(17, 2);
    n_tit_cucff7 number(17, 2);
    n_tit_cucff4 number(17, 2);

    n_con_cusff3 number(17, 2);
    n_con_cusff5 number(17, 2);
    n_con_cusff2 number(17, 2);
    n_con_cusff7 number(17, 2);
    n_con_cusff4 number(17, 2);

    ln_salcap3 number(17, 2);
    ln_salcap5 number(17, 2);
    ln_salcap2 number(17, 2);
    ln_salcap7 number(17, 2);
    ln_salcap4 number(17, 2);
    ln_salcap3_c number(17, 2);
    ln_salcap5_c number(17, 2);
    ln_salcap2_c number(17, 2);
    ln_salcap7_c number(17, 2);
    ln_salcap4_c number(17, 2);    

    ln_evacre sng021.sng021eval%type;
    ln_solcre sng021.sng021sol%type;
    ln_tpacre sng021.sng021tmod%type;

    ln_evacli sng021.sng021eval%type;
    ln_solcli sng021.sng021sol%type;
    ln_tpacli sng021.sng021tmod%type;

    lc_mixsev char(1);
    
    ln_tipcam fsh005.COTCBI%type;
    
    ln_anio number := to_number(EXTRACT(YEAR FROM P_D_FECHA));
    ln_mes number := to_number(EXTRACT(MONTH FROM P_D_FECHA));

    type cur_rec is record(
    p_jaql154ani jaql154.jaql154ani%type, --1
    p_jaql154mes jaql154.jaql154mes%type, --2
    p_jaql154emp jaql154.jaql154emp%type, --3
    p_jaql154mod jaql154.jaql154mod%type, --4
    p_jaql154suc jaql154.jaql154suc%type, --5
    p_jaql154mda jaql154.jaql154mda%type, --6
    p_jaql154pap jaql154.jaql154pap%type, --7
    p_jaql154ope jaql154.jaql154ope%type, --8
    p_jaql154sbo jaql154.jaql154sbo%type, --9
    p_jaql154top jaql154.jaql154top%type, --10
    p_jaql154sdo jaql154.jaql154sdo%type, --11
    p_jaql154rub jaql154.jaql154rub%type, --12
    p_jaql154cta jaql154.jaql154cta%type, --13
    p_jaql154pai jaql154.jaql154pai%type, --14
    p_jaql154tdo jaql154.jaql154tdo%type, --15
    p_jaql154ndo jaql154.jaql154ndo%type, --16
    p_jaql154tpe jaql154.jaql154tpe%type, --17
    p_jaql154tac jaql154.jaql154tac%type, --18
    p_jaql154dac jaql154.jaql154dac%type, --19
    p_jaql154nsu jaql154.jaql154nsu%type, --20
    p_jaql154drb jaql154.jaql154drb%type, --21
    p_jaql154seg jaql154.jaql154seg%type, --23
    p_jaql154nev jaql154.jaql154nev%type, --24
    p_jaql154rbn jaql154.jaql154rbn%type, --25
    p_jaql154tcr jaql154.jaql154tcr%type); --26

    TYPE cur_01 IS TABLE OF cur_rec;

    lv_cur_01 cur_01;

    cursor cur_sob is
--              select /*+parallel(f,2,1) (x,2,1)*/distinct
              select distinct
                         ln_anio jaql154ani,
                         ln_mes jaql154mes,
                         f.pgcod jaql154emp,
                         f.hamod jaql154mod,
                         f.hasuc jaql154suc,
                         f.hamda jaql154mda,
                         f.hapap jaql154pap,
                         f.haoper jaql154ope,
                         f.hasbop jaql154sbo,
                         f.hatope jaql154top,
                         0 jaql154sdo,
                         f.harub jaql154rub,
                         f.hacta jaql154cta,
                         r.pepais jaql154pai,
                         r.petdoc jaql154tdoc,
                         r.pendoc jaql154ndoc,
                         '' jaql154tpe,
                         0 jaql154tac,
                         '' jaql154dac,
                         '' jaql154nsu,
                         '' jaql154drb,
                         '' jaql154seg,
                         0/*x.xwfprcins*/  jaql154nev, --drc PRY3303
                         '' jaql154rbn,
                         (Case
                         when hamod = 116 then 1  -- Lineas de credito
                         when hagru = 3 then 1 --
                         else 2
                         end) jaql154tcr
                          from fsh014 f
                          inner join fsr008 r on f.hacta = r.ctnro
                                              and f.pgcod = r.pgcod + 0
                          inner join xwf700 x on f.pgcod = x.XWFEMPRESA + 0
                                        and f.hasuc = x.XWFSUCURSAL
                                        and f.hamda = x.XWFMONEDA  + 0
                                        and f.hapap = x.XWFPAPEL + 0
                                        and f.hacta = x.XWFCUENTA
                                        and f.haoper = x.XWFOPERACION
                                        and f.hasbop = x.XWFSUBOPE
                                        and f.hatope = x.XWFTIPOPE
                                        and f.hamod = x.XWFMODULO + 0
                          where 
                          f.pgcod = 1
                          and r.cttfir = 'T'
                          and x.xwfcar3 = '1'
                          and f.haanio = ln_anio
                          and ( f.hamod in (select /*+ PUSH_SUBQ */ modulo from fst111 where dscod = 50) or f.hamod  = 117 )
                          and 
                          (
                              ( ln_mes = 1 and f.hasd01 <> 0 ) or 
                              ( ln_mes = 2 and f.hasd02 <> 0 ) or 
                              ( ln_mes = 3 and f.hasd03 <> 0 ) or
                              ( ln_mes = 4 and f.hasd04 <> 0 ) or
                              ( ln_mes = 5 and f.hasd05 <> 0 ) or
                              ( ln_mes = 6 and f.hasd06 <> 0 ) or
                              ( ln_mes = 7 and f.hasd07 <> 0 ) or
                              ( ln_mes = 8 and f.hasd08 <> 0 ) or
                              ( ln_mes = 9 and f.hasd09 <> 0 ) or
                              ( ln_mes = 10 and f.hasd10 <> 0 ) or
                              ( ln_mes = 11 and f.hasd11 <> 0 ) or
                              ( ln_mes = 12 and f.hasd12 <> 0 )                                                                                                                                                                                                                                                                                                            
                          )                          
                         order by r.pepais, r.petdoc, r.pendoc;     

  --datos sistema financiero
  ln_camemp number(2);
  ln_credir number(18, 2);
  ln_intdev number(18, 2);
  ln_avaoto number(17, 2);
  ln_carfia number(17, 2);
  ln_carcre number(17, 2);
  ln_aceban number(17, 2);
  ln_linuti number(17, 2);
  ln_hipote number(17, 2);

  ln_calif0 number(5, 2);
  ln_calif1 number(5, 2);
  ln_calif2 number(5, 2);
  ln_calif3 number(5, 2);
  ln_calif4 number(5, 2);

  ln_cuosf3 number(17, 2);
  ln_cuosf5 number(17, 2);
  ln_cuosf2 number(17, 2);
  ln_cuosf7 number(17, 2);
  ln_cuosf4 number(17, 2);
  ln_cuoff3 number(17, 2);
  ln_cuoff5 number(17, 2);
  ln_cuoff2 number(17, 2);
  ln_cuoff7 number(17, 2);
  ln_cuoff4 number(17, 2);

  ln_camemp_c number(2);
  ln_credir_c number(18, 2);
  ln_intdev_c number(18, 2);
  ln_avaoto_c number(17, 2);
  ln_carfia_c number(17, 2);
  ln_carcre_c number(17, 2);
  ln_aceban_c number(17, 2);
  ln_linuti_c number(17, 2);
  ln_hipote_c number(17, 2);

  ln_calif0_c number(5, 2);
  ln_calif1_c number(5, 2);
  ln_calif2_c number(5, 2);
  ln_calif3_c number(5, 2);
  ln_calif4_c number(5, 2);

  ln_cuosf3_c number(17, 2);
  ln_cuosf5_c number(17, 2);
  ln_cuosf2_c number(17, 2);
  ln_cuosf7_c number(17, 2);
  ln_cuosf4_c number(17, 2);
  ln_cuoff3_c number(17, 2);
  ln_cuoff5_c number(17, 2);
  ln_cuoff2_c number(17, 2);
  ln_cuoff7_c number(17, 2);
  ln_cuoff4_c number(17, 2);

  n_con_cucff3 number(17, 2);
  n_con_cucff5 number(17, 2);
  n_con_cucff2 number(17, 2);
  n_con_cucff7 number(17, 2);
  n_con_cucff4 number(17, 2);

  -- variables datos evaluaciones
  p_jaql154nev jaql154.jaql154nev%type;
  ln_brfsol number(18, 2);
  ln_brfdol number(18, 2);
  ln_ntfsol number(18, 2);
  ln_ntfdol number(18, 2);
  ln_patsol number(18, 2);
  ln_patdol number(18, 2);
  ln_egfsol number(18, 2);
  ln_egfdol number(18, 2);
  ln_vensol number(18, 2);
  ln_vendol number(18, 2);
  ln_resnsol number(18, 2);
  ln_resndol number(18, 2);
  ln_cuocm3 number(17, 2);
  ln_cuocm5 number(17, 2);
  ln_cuocm2 number(17, 2);
  ln_cuocm7 number(17, 2);
  ln_cuocm4 number(17, 2);
  ln_cucff3 number(17, 2);
  ln_cucff5 number(17, 2);
  ln_cucff2 number(17, 2);
  ln_cucff7 number(17, 2);
  ln_cucff4 number(17, 2);
  ln_salff3 number(17, 2);
  ln_salff5 number(17, 2);
  ln_salff2 number(17, 2);
  ln_salff7 number(17, 2);
  ln_salff4 number(17, 2);
  ln_lnucma number(17, 2);
  ln_cafcma number(17, 2);
  ln_salcma number(17, 2);
  ln_indcma number(17, 2);
  ln_mlicma number(17, 2);
  ln_lrecma number(17, 2);
  ln_hipcma number(17, 2);

  ln_cuocm3_c number(17, 2);
  ln_cuocm5_c number(17, 2);
  ln_cuocm2_c number(17, 2);
  ln_cuocm7_c number(17, 2);
  ln_cuocm4_c number(17, 2);
  ln_cucff3_c number(17, 2);
  ln_cucff5_c number(17, 2);
  ln_cucff2_c number(17, 2);
  ln_cucff7_c number(17, 2);
  ln_cucff4_c number(17, 2);
  ln_salff3_c number(17, 2);
  ln_salff5_c number(17, 2);
  ln_salff2_c number(17, 2);
  ln_salff7_c number(17, 2);
  ln_salff4_c number(17, 2);
  ln_lnucma_c number(17, 2);
  ln_cafcma_c number(17, 2);
  ln_salcma_c number(17, 2);
  ln_indcma_c number(17, 2);
  ln_mlicma_c number(17, 2);
  ln_lrecma_c number(17, 2);
  ln_hipcma_c number(17, 2);

  ln_ratdet number(18,4);
  ln_ratio number(18,2);

  lc_tipcli char(1);
  lc_tippas char(1);

  ld_JAQL410HRI DATE;
  ln_JAQL410PAI NUMBER(3);
  ln_JAQL410TDI NUMBER(2);
  lc_JAQL410NDI CHAR(12);
  ln_JAQL410PAF NUMBER(3);
  ln_JAQL410TDF NUMBER(2);
  lc_JAQL410NDF CHAR(12);

  begin
  
  execute immediate ('ALTER SESSION SET OPTIMIZER_DYNAMIC_SAMPLING=0');
  execute immediate 'ALTER session SET commit_wait=''NOWAIT''';
  execute immediate 'ALTER session SET commit_logging=''BATCH''';
  execute immediate 'ALTER session SET optimizer_mode=''ALL_ROWS''';

  ln_tipcam := PQ_CR_JAQL157_SOBEND.fn_cr_tipocambio(P_D_FECHA);

  n_count := 0;
  n_count2 := 0;
    
  ld_JAQL410HRI := sysdate;  

  OPEN cur_sob;
    LOOP

      FETCH cur_sob BULK COLLECT
      INTO lv_cur_01 LIMIT 100;
      EXIT WHEN lv_cur_01.COUNT = 0;

        FOR i IN 1 .. lv_cur_01.COUNT LOOP

          n_count := n_count + 1;

          IF ( n_count >= P_N_REGINI ) AND ( n_count <= P_N_REGFIN ) THEN

            if ( n_count = P_N_REGINI ) then
              ln_JAQL410PAI := lv_cur_01(i).p_jaql154pai;
              ln_JAQL410TDI := lv_cur_01(i).p_jaql154tdo;
              lc_JAQL410NDI := lv_cur_01(i).p_jaql154ndo;
            end if;

            if ( n_count <= P_N_REGFIN ) then
              ln_JAQL410PAF := lv_cur_01(i).p_jaql154pai;
              ln_JAQL410TDF := lv_cur_01(i).p_jaql154tdo;
              lc_JAQL410NDF := lv_cur_01(i).p_jaql154ndo;
            end if;

  --CÁLCULO DE DATOS------------------------------------------------------------------
  ------------------------------------------------------------------------------------

            -- obtener conyuge de último credito vigente
            begin
              select R.RPPAIS, R.RPTDOC, R.RPNDOC
              into p_n_pais1, p_n_tipdoc1, p_c_numdoc1
              from fsr002 R
              where R.pepais = lv_cur_01(i).p_jaql154pai
              and R.petdoc = lv_cur_01(i).p_jaql154tdo
              and R.pendoc = lv_cur_01(i).p_jaql154ndo
              and rpccyg = 66
              and rownum = 1;
            exception when no_data_found then
                p_n_pais1 := null;
                p_n_tipdoc1 := null;
                p_c_numdoc1 := null;
            end;

            --drc PRY3303
            --evaluación y tipo de producto pyme o consumo por crédito
            PQ_CR_JAQL157_SOBEND.sp_cr_ult_evaluacion_cre( p_in_pgcod => lv_cur_01(i).p_jaql154emp,
                                                    p_in_sucur => lv_cur_01(i).p_jaql154suc,
                                                    p_in_mda => lv_cur_01(i).p_jaql154mda,
                                                    p_in_pap => lv_cur_01(i).p_jaql154pap,
                                                    p_in_cta => lv_cur_01(i).p_jaql154cta,
                                                    p_in_oper => lv_cur_01(i).p_jaql154ope,
                                                    p_in_mod => lv_cur_01(i).p_jaql154mod,
                                                    p_in_fecha => P_D_FECHA,
                                                    p_on_eva => ln_evacre,
                                                    p_on_sol => ln_solcre,
                                                    p_on_tpa => ln_tpacre);
            lv_cur_01(i).p_jaql154nev := ln_evacre; --drc PRY3303
            
            -- obtener nombre de analista
            begin
              select fst746.ubnom
              into c_jaql154anl
              from sng001, fst746
              where sng001.sng001ase = fst746.ubuser
              and sng001.sng001inst = ln_solcre /*lv_cur_01(i).p_jaql154nev*/ --drc PRY3303
              and rownum = 1;

            exception when others then
                c_jaql154anl := null;
            end;

            -- datos sistema financiero
            -- cliente
            PQ_CR_JAQL157_SOBEND.sp_cr_datos_sistema_financiero(p_c_tipdoc => PQ_CR_JAQL157_SOBEND.fn_cr_tipdoc_sbs(lv_cur_01(i).p_jaql154tdo,
                                                                                                      lv_cur_01(i).p_jaql154ndo),
                                                         p_c_numdoc => lv_cur_01(i).p_jaql154ndo,
                                                         p_n_camemp => ln_camemp, --2
                                                         p_n_credir => ln_credir, --3
                                                         p_n_intdev => ln_intdev, --4
                                                         p_n_avaoto => ln_avaoto, --5
                                                         p_n_carfia => ln_carfia, --6
                                                         p_n_carcre => ln_carcre, --7
                                                         p_n_aceban => ln_aceban, --8
                                                         p_n_linuti => ln_linuti, --9
                                                         p_n_hipote => ln_hipote, --10
                                                         p_n_calif0 => ln_calif0, --11
                                                         p_n_calif1 => ln_calif1, --12
                                                         p_n_calif2 => ln_calif2, --13
                                                         p_n_calif3 => ln_calif3, --14
                                                         p_n_calif4 => ln_calif4, --15
                                                         p_n_cuosf3 => ln_cuosf3, --16
                                                         p_n_cuosf5 => ln_cuosf5, --17
                                                         p_n_cuosf2 => ln_cuosf2, --18
                                                         p_n_cuosf7 => ln_cuosf7, --19
                                                         p_n_cuosf4 => ln_cuosf4, --20
                                                         p_n_cuoff3 => ln_cuoff3, --21
                                                         p_n_cuoff5 => ln_cuoff5, --22
                                                         p_n_cuoff2 => ln_cuoff2, --23
                                                         p_n_cuoff7 => ln_cuoff7, --24
                                                         p_n_cuoff4 => ln_cuoff4); --25

            -- conyugue
            PQ_CR_JAQL157_SOBEND.sp_cr_datos_sistema_financiero(p_c_tipdoc => p_n_tipdoc1,
                                                         p_c_numdoc => p_c_numdoc1,
                                                         p_n_camemp => ln_camemp_c, --2
                                                         p_n_credir => ln_credir_c, --3
                                                         p_n_intdev => ln_intdev_c, --4
                                                         p_n_avaoto => ln_avaoto_c, --5
                                                         p_n_carfia => ln_carfia_c, --6
                                                         p_n_carcre => ln_carcre_c, --7
                                                         p_n_aceban => ln_aceban_c, --8
                                                         p_n_linuti => ln_linuti_c, --9
                                                         p_n_hipote => ln_hipote_c, --10
                                                         p_n_calif0 => ln_calif0_c, --11
                                                         p_n_calif1 => ln_calif1_c, --12
                                                         p_n_calif2 => ln_calif2_c, --13
                                                         p_n_calif3 => ln_calif3_c, --14
                                                         p_n_calif4 => ln_calif4_c, --15
                                                         p_n_cuosf3 => ln_cuosf3_c, --16
                                                         p_n_cuosf5 => ln_cuosf5_c, --17
                                                         p_n_cuosf2 => ln_cuosf2_c, --18
                                                         p_n_cuosf7 => ln_cuosf7_c, --19
                                                         p_n_cuosf4 => ln_cuosf4_c, --20
                                                         p_n_cuoff3 => ln_cuoff3_c, --21
                                                         p_n_cuoff5 => ln_cuoff5_c, --22
                                                         p_n_cuoff2 => ln_cuoff2_c, --23
                                                         p_n_cuoff7 => ln_cuoff7_c, --24
                                                         p_n_cuoff4 => ln_cuoff4_c); --25

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 1 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac1(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac1(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 2 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac2(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac2(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 3 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac3(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac3(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 4 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac4(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac4(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 5 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac5(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac5(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 6 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac6(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac6(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 7 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac7(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac7(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 8 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac8(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac8(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 9 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac9(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac9(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 10 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac10(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac10(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 11 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac11(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac11(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            if ( to_number(EXTRACT(MONTH FROM P_D_FECHA)) = 12 ) then
              -- datos cmac
              -- cliente
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac12(P_N_Pais => lv_cur_01(i).p_jaql154pai,
                                           P_N_TIPDOC => lv_cur_01(i).p_jaql154tdo,
                                           P_C_NUMDOC => lv_cur_01(i).p_jaql154ndo,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3,
                                           p_n_cuocm5 => ln_cuocm5,
                                           p_n_cuocm2 => ln_cuocm2,
                                           p_n_cuocm7 => ln_cuocm7,
                                           p_n_cuocm4 => ln_cuocm4,
                                           p_n_cucff3 => ln_cucff3,
                                           p_n_cucff5 => ln_cucff5,
                                           p_n_cucff2 => ln_cucff2,
                                           p_n_cucff7 => ln_cucff7,
                                           p_n_cucff4 => ln_cucff4,
                                           p_n_salff3 => ln_salff3,
                                           p_n_salff5 => ln_salff5,
                                           p_n_salff2 => ln_salff2,
                                           p_n_salff7 => ln_salff7,
                                           p_n_salff4 => ln_salff4,
                                           p_n_lnucma => ln_lnucma,
                                           p_n_cafcma => ln_cafcma,
                                           p_n_salcap => ln_salcma,
                                           p_n_intdev => ln_indcma,
                                           p_n_mtolin => ln_mlicma,
                                           p_n_linrev => ln_lrecma,
                                           p_n_salhip => ln_hipcma,
                                           p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4,
                                           P_D_FECHA => P_D_FECHA);

              -- conyugue
              PQ_CR_JAQL157_SOBEND.sp_cr_datos_cmac12(P_N_Pais => p_n_pais1,
                                           P_N_TIPDOC => p_n_tipdoc1,
                                           P_C_NUMDOC => p_c_numdoc1,
                                           P_N_TIPCAM => ln_tipcam,
                                           p_n_cuocm3 => ln_cuocm3_c,
                                           p_n_cuocm5 => ln_cuocm5_c,
                                           p_n_cuocm2 => ln_cuocm2_c,
                                           p_n_cuocm7 => ln_cuocm7_c,
                                           p_n_cuocm4 => ln_cuocm4_c,
                                           p_n_cucff3 => ln_cucff3_c,
                                           p_n_cucff5 => ln_cucff5_c,
                                           p_n_cucff2 => ln_cucff2_c,
                                           p_n_cucff7 => ln_cucff7_c,
                                           p_n_cucff4 => ln_cucff4_c,
                                           p_n_salff3 => ln_salff3_c,
                                           p_n_salff5 => ln_salff5_c,
                                           p_n_salff2 => ln_salff2_c,
                                           p_n_salff7 => ln_salff7_c,
                                           p_n_salff4 => ln_salff4_c,
                                           p_n_lnucma => ln_lnucma_c,
                                           p_n_cafcma => ln_cafcma_c,
                                           p_n_salcap => ln_salcma_c,
                                           p_n_intdev => ln_indcma_c,
                                           p_n_mtolin => ln_mlicma_c,
                                           p_n_linrev => ln_lrecma_c,
                                           p_n_salhip => ln_hipcma_c,
                                           p_n_salcap3 => ln_salcap3_c,
                                           p_n_salcap5 => ln_salcap5_c,
                                           p_n_salcap2 => ln_salcap2_c,
                                           p_n_salcap7 => ln_salcap7_c,
                                           p_n_salcap4 => ln_salcap4_c,
                                           P_D_FECHA => P_D_FECHA);            
            end if;

            /*drc PRY3303
            --tipo de Cliente
            PQ_CR_JAQL157_SOBEND.sp_cr_tipo_cliente(P_N_CUOSF3 => ln_cuosf3,
                                             P_N_CUOSF5 => ln_cuosf5,
                                             P_N_CUOSF2 => ln_cuosf2,
                                             P_N_CUOSF7 => ln_cuosf7,
                                             P_N_CUOSF4 => ln_cuosf4,
                                             P_N_CUOCM3 => ln_cuocm3,
                                             P_N_CUOCM5 => ln_cuocm5,
                                             P_N_CUOCM2 => ln_cuocm2,
                                             P_N_CUOCM7 => ln_cuocm7,
                                             P_N_CUOCM4 => ln_cuocm4,
                                             P_N_TIPMOD => ln_tpacli,
                                             p_c_tipcli => lc_tipcli,
                                             p_c_tippas => lc_tippas);
                                             */
            --drc PRY3303 --tipo de cliente
            lc_tipcli := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_cliente_cmac(p_n_salcap3 => ln_salcap3,
                                           p_n_salcap5 => ln_salcap5,
                                           p_n_salcap2 => ln_salcap2,
                                           p_n_salcap7 => ln_salcap7,
                                           p_n_salcap4 => ln_salcap4);

            --drc PRY3303 (2) evaluación y tipo de producto por cliente
            PQ_CR_JAQL157_SOBEND.sp_cr_ult_evaluacion_cli(p_n_pais => lv_cur_01(i).p_jaql154pai,
                                                          p_n_tipdoc => lv_cur_01(i).p_jaql154tdo,
                                                          p_c_numdoc => lv_cur_01(i).p_jaql154ndo,
                                                          p_in_fecha => P_D_FECHA,
                                                          p_in_tipcli => lc_tipcli,
                                                          p_on_eva => ln_evacli,
                                                          p_on_sol => ln_solcli,
                                                          p_on_tpa => ln_tpacli);

            lc_ulteva := 'N';
            if ln_evacre = ln_evacli then
              lc_ulteva := 'S';
            end if;

            --drc PRY3303 --tipo de producto
            lc_tippas := '-';
            lc_mixsev := 'N';
            if lc_tipcli = 'P' or lc_tipcli = 'C' then
               lc_tippas := lc_tipcli;
            else            
              if ln_tpacli = 13 then
                 lc_tippas := 'P';
              elsif ln_tpacli = 14 then
                 lc_tippas := 'C';
              elsif ln_tpacli = 0 then
                 if ( ln_salcap3 + ln_salcap5 ) >= ( ln_salcap2 + ln_salcap7 + ln_salcap4 ) then
                    lc_tippas := 'P';
                 else
                    lc_tippas := 'C';
                 end if;
                 
                 lc_mixsev := 'S';
                                  
              end if;
              
            end if;

            --datos de evaluaciones finaciera y socioeconomica
            PQ_CR_JAQL157_SOBEND.sp_cr_datos_evaluaciones(P_N_PAIS => lv_cur_01(i).p_jaql154pai,
                                                   P_N_TIPDOC  => lv_cur_01(i).p_jaql154tdo,
                                                   P_C_NUMDOC  => lv_cur_01(i).p_jaql154ndo,
                                                   P_C_TIPCLI  => lc_tippas,
                                                   p_n_soles   => ln_ntfsol,
                                                   p_n_dolares => ln_ntfdol,
                                                   p_n_egfsol  => ln_egfsol,
                                                   p_n_egfdol  => ln_egfdol,
                                                   p_n_patsol  => ln_patsol,
                                                   p_n_patdol  => ln_patdol,
                                                   p_n_patsol1 => ln_brfsol,
                                                   p_n_patdol1 => ln_brfdol,
                                                   p_n_vensol  => ln_vensol,
                                                   p_n_vendol  => ln_vendol,
                                                   p_n_resnsol => ln_resnsol,
                                                   p_n_resndol => ln_resndol,
                                                   P_D_FECHA => P_D_FECHA);

            -- Calculo del ratio determinante
            -- Cliente
            n_tit_cuosf3 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_cuosf3);
            n_tit_cuosf5 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_cuosf5);
            n_tit_cuosf2 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_cuosf2);
            n_tit_cuosf7 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_cuosf7);
            n_tit_cuosf4 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_cuosf4);
            
            n_tit_cusff3 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_cuoff3*0.3), 0);--drc PRY3303
            n_tit_cusff5 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_cuoff5*0.3), 0);--drc PRY3303
            n_tit_cusff2 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_cuoff2*0.5), 0);--drc PRY3303
            n_tit_cusff7 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_cuoff7*0.5), 0);--drc PRY3303
            n_tit_cusff4 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_cuoff4*0.5), 0);--drc PRY3303

            n_tit_cucff3 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_salff3*0.3), 0);--drc PRY3303
            n_tit_cucff5 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_salff5*0.3), 0);--drc PRY3303
            n_tit_cucff2 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_salff2*0.5), 0);--drc PRY3303
            n_tit_cucff7 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_salff7*0.5), 0);--drc PRY3303
            n_tit_cucff4 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_salff4*0.5), 0);--drc PRY3303

            -- Conyugue
            n_con_cuosf3 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_cuosf3_c);
            n_con_cuosf5 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_cuosf5_c);
            n_con_cuosf2 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_cuosf2_c);
            n_con_cuosf7 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_cuosf7_c);
            n_con_cuosf4 := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_cuosf4_c);

            n_con_cusff3 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_cuoff3_c*0.3), 0);--drc PRY3303
            n_con_cusff5 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_cuoff5_c*0.3), 0);--drc PRY3303
            n_con_cusff2 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_cuoff2_c*0.5), 0);--drc PRY3303
            n_con_cusff7 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_cuoff7_c*0.5), 0);--drc PRY3303
            n_con_cusff4 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_cuoff4_c*0.5), 0);--drc PRY3303

            n_con_cucff3 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '3', ln_salff3_c*0.3), 0);--drc PRY3303
            n_con_cucff5 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '5', ln_salff5_c*0.3), 0);--drc PRY3303
            n_con_cucff2 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '2', ln_salff2_c*0.5), 0);--drc PRY3303
            n_con_cucff7 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '7', ln_salff7_c*0.5), 0);--drc PRY3303
            n_con_cucff4 := nvl(PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(P_D_FECHA, '4', ln_salff4_c*0.5), 0);--drc PRY3303

            PQ_CR_JAQL157_SOBEND.sp_cr_calc_ratio( P_C_TIPCLI  => lc_tipcli,
                                           P_C_TIPPAS => lc_tippas,
                                           P_N_RESNTF => nvl(ln_resnsol,0) + nvl(ln_resndol,0) * ln_tipcam,
                                           P_N_RESNTS => nvl(ln_resnsol,0) + nvl(ln_resndol,0) * ln_tipcam,
                                           P_N_PERCCM3 => ln_cuocm3,
                                           P_N_PERCCM5 => ln_cuocm5,
                                           P_N_PERCCM2 => ln_cuocm2,
                                           P_N_PERCCM7 => ln_cuocm7,
                                           P_N_PERCCM4 => ln_cuocm4,
                                           P_N_PERCSF3 => n_tit_cuosf3,
                                           P_N_PERCSF5 => n_tit_cuosf5,
                                           P_N_PERCSF2 => n_tit_cuosf2,
                                           P_N_PERCSF7 => n_tit_cuosf7,
                                           P_N_PERCSF4 => n_tit_cuosf4,
                                           P_N_PERCFF3 => n_tit_cusff3,
                                           P_N_PERCFF5 => n_tit_cusff5,
                                           P_N_PERCFF2 => n_tit_cusff2,
                                           P_N_PERCFF7 => n_tit_cusff7,
                                           P_N_PERCFF4 => n_tit_cusff4,
                                           P_N_PERCFC3 => n_tit_cucff3,
                                           P_N_PERCFC5 => n_tit_cucff5,
                                           P_N_PERCFC2 => n_tit_cucff2,
                                           P_N_PERCFC7 => n_tit_cucff7,
                                           P_N_PERCFC4 => n_tit_cucff4,
                                           P_N_CONCCM3 => ln_cuocm3_c,
                                           P_N_CONCCM5 => ln_cuocm5_c,
                                           P_N_CONCCM2 => ln_cuocm2_c,
                                           P_N_CONCCM7 => ln_cuocm7_c,
                                           P_N_CONCCM4 => ln_cuocm4_c,
                                           P_N_CONCSF3 => n_con_cuosf3,
                                           P_N_CONCSF5 => n_con_cuosf5,
                                           P_N_CONCSF2 => n_con_cuosf2,
                                           P_N_CONCSF7 => n_con_cuosf7,
                                           P_N_CONCSF4 => n_con_cuosf4,
                                           P_N_CONCFF3 => n_con_cusff3,
                                           P_N_CONCFF5 => n_con_cusff5,
                                           P_N_CONCFF2 => n_con_cusff2,
                                           P_N_CONCFF7 => n_con_cusff7,
                                           P_N_CONCFF4 => n_con_cusff4,
                                           P_N_CONCFC3 => n_con_cucff3,
                                           P_N_CONCFC5 => n_con_cucff5,
                                           P_N_CONCFC2 => n_con_cucff2,
                                           P_N_CONCFC7 => n_con_cucff7,
                                           P_N_CONCFC4 => n_con_cucff4,
                                           ln_val01 => ln_ratdet);
            ln_ratio := ln_ratdet * 100;

            -- Excepcion Castigados
            if lv_cur_01(i).p_jaql154mod = 33 then
              ln_ratio := 200;
              ln_camemp := 20;
            end if;
            
            --drc PRY3303 (2) Excepción Judiciales
            if (ln_evacli = 0 or ln_evacli is null) and lv_cur_01(i).p_jaql154mod = 200 then
              ln_ratio := 200;
              ln_camemp := 20;
            end if;
            --drc PRY3303 (2) Excepción Judiciales no coincidencia de tipcli y ult evaluación
            if ( lc_tipcli = 'P' or lc_tipcli = 'C' ) and ( lv_cur_01(i).p_jaql154mod = 200 ) then
              if (lc_tipcli = 'P' and ln_tpacli = 14) or (lc_tipcli = 'C' and ln_tpacli = 13) then
                ln_ratio := 200;
                ln_camemp := 20;                 
              end if;
            end if;               
            
            -- CÁLCULO DE DEUDA
            -- Deuda Potencial
            n_tit_dcmpot := ((nvl(ln_salff2, 0) + nvl(ln_salff7, 0)) * 0.5/*ln_faccon*/) +
                               ((nvl(ln_salff4, 0)) * 0.5/*ln_fachip*/) +
                               ((nvl(ln_salff3, 0) + nvl(ln_salff5, 0)) * 0.3/*ln_facpym*/);

            n_tit_dsfpot := ((nvl(ln_cuoff2, 0) + nvl(ln_cuoff7, 0)) * 0.5/*ln_faccon*/) +
                               ((nvl(ln_cuoff4, 0)) * 0.5/*ln_fachip*/) +
                               ((nvl(ln_cuoff3, 0) + nvl(ln_cuoff5, 0)) * 0.3/*ln_facpym*/);

            n_con_dcmpot := ((nvl(ln_salff2_c, 0) + nvl(ln_salff7_c, 0)) * 0.5/*ln_faccon*/) +
                               ((nvl(ln_salff4_c, 0)) * 0.5/*ln_fachip*/) +
                               ((nvl(ln_salff3_c, 0) + nvl(ln_salff5_c, 0)) * 0.3/*ln_facpym*/);

            n_con_dsfpot := ((nvl(ln_cuoff2_c, 0) + nvl(ln_cuoff7_c, 0)) * 0.5/*ln_faccon*/) +
                               ((nvl(ln_cuoff4_c, 0)) * 0.5/*ln_fachip*/) +
                               ((nvl(ln_cuoff3_c, 0) + nvl(ln_cuoff5_c, 0)) * 0.3/*ln_facpym*/);

            n_tot_deupot := nvl(n_tit_dcmpot, 0) + nvl(n_tit_dsfpot, 0) +
                            nvl(n_con_dcmpot, 0) + nvl(n_con_dsfpot, 0);

            -- Deuda Directa
            n_tit_dcmdir := ( nvl(ln_salcma, 0) + nvl(ln_indcma, 0) + nvl(ln_cuocm4, 0) ) ;
            n_con_dcmdir := ( nvl(ln_salcma_c, 0) + nvl(ln_indcma_c, 0) + nvl(ln_cuocm4_c, 0) ) ;

            ln_credir_rcc := ln_credir;
            ln_intdev_rcc := ln_intdev;
            n_crercc := nvl(ln_credir_rcc, 0) + nvl(ln_credir_rcd, 0);
            n_devrcc := nvl(ln_intdev_rcc, 0) + nvl(ln_intdev_rcd, 0);

            ln_credir_rcc_c := ln_credir_c;
            ln_intdev_rcc_c := ln_intdev_c;
            n_crercc_c := nvl(ln_credir_rcc_c, 0) + nvl(ln_credir_rcd_c, 0);
            n_devrcc_c := nvl(ln_intdev_rcc_c, 0) + nvl(ln_intdev_rcd_c, 0);

            n_tit_dsfdir := nvl(n_crercc, 0) + nvl(n_devrcc, 0) + nvl(n_tit_cuosf4, 0);--drc PRY3303
            n_con_dsfdir := nvl(n_crercc_c, 0) + nvl(n_devrcc_c, 0) + nvl(n_con_cuosf4, 0);--drc PRY3303

            n_tot_deudir := nvl(n_tit_dcmdir, 0) + nvl(n_tit_dsfdir, 0) +
                            nvl(n_con_dcmdir, 0) + nvl(n_con_dsfdir, 0);

            -- TIPO DE CRÉDITO SBS
            --drc PRY3303
            c_jaql154tcs := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_credito_cmac(p_n_salcap3 => ln_salcap3,
                                                                         p_n_salcap5 => ln_salcap5,
                                                                         p_n_salcap2 => ln_salcap2,
                                                                         p_n_salcap7 => ln_salcap7,
                                                                         p_n_salcap4 => ln_salcap4);

            if c_jaql154tcs = '-' then
              c_jaql154tcs := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_credito_sbs(p_c_tipdoc => PQ_CR_JAQL157_SOBEND.fn_cr_tipdoc_sbs(lv_cur_01(i).p_jaql154tdo,
                                                                          lv_cur_01(i).p_jaql154ndo),
                                                                          p_c_numdoc => lv_cur_01(i).p_jaql154ndo,
                                                                          p_c_tippas => lc_tippas);
            end if;

            -- EXCEPCIÓN CASTIGADOS MICROEMPRESA
            if c_jaql154tcs = '-' and lv_cur_01(i).p_jaql154mod = 33 then
              c_jaql154tcs := 'M';
            end if;
                        
            -- SECTOR ECONÓMICO
            c_jaql154sec := null;
            if c_jaql154tcs in ('P','M') then
              if lv_cur_01(i).p_jaql154tdo = 21 then
                 begin
                   select SNGC60Tipa
                   into n_tipact
                   from SNGC60
                   where 
                   SNGC60PAIS = lv_cur_01(i).p_jaql154pai
                   and SNGC60Tdoc = lv_cur_01(i).p_jaql154tdo
                   and SNGC60Ndoc = lv_cur_01(i).p_jaql154ndo
                   and SNGC60Corr = 0;
                 exception when no_data_found then
                   n_tipact := 0;
                 end;
              end If;
              if lv_cur_01(i).p_jaql154tdo = 9 then
                 begin
                   select sngc11TpA2
                   into n_tipact
                   from SNGC11
                   where 
                   SNGC11PAIS = lv_cur_01(i).p_jaql154pai
                   and sngc11Tdoc = lv_cur_01(i).p_jaql154tdo
                   and sngc11Ndoc = lv_cur_01(i).p_jaql154ndo;
                 exception when no_data_found then
                   n_tipact := 0;
                 end;
              end If;
              -- Equivalencias Sector Económico 4, 5, 6
              if n_tipact in (8, 9) then --Comercio
                c_jaql154sec := 'C';
              end If;
              if n_tipact in (1, 2, 3, 10) then --Producción
                c_jaql154sec := 'P';
              end If;
              if n_tipact in (4, 5, 6, 7) then --Servicio
                c_jaql154sec := 'S';
              end If;
            end If;

            -- SECTOR PYME
            c_jaql154spy := null;
            if c_jaql154tcs in ('P') then
              begin
              
                select max(JAQL101fch)
                into d_JAQL101fch
                from JAQL101
                where JAQL101Pgc = lv_cur_01(i).p_jaql154emp
                and JAQL101Mod = lv_cur_01(i).p_jaql154mod
                and JAQL101Suc = lv_cur_01(i).p_jaql154suc
                and JAQL101Mon = lv_cur_01(i).p_jaql154mda
                and JAQL101Pap = lv_cur_01(i).p_jaql154pap
                and JAQL101Cta = lv_cur_01(i).p_jaql154cta
                and JAQL101Ope = lv_cur_01(i).p_jaql154ope
                and JAQL101Sop = lv_cur_01(i).p_jaql154sbo
                and JAQL101Top = lv_cur_01(i).p_jaql154top
                and JAQL101fch <= P_D_FECHA;
              
                select max(JAQL101cor)
                into n_JAQL101cor
                from JAQL101
                where JAQL101Pgc = lv_cur_01(i).p_jaql154emp
                and JAQL101Mod = lv_cur_01(i).p_jaql154mod
                and JAQL101Suc = lv_cur_01(i).p_jaql154suc
                and JAQL101Mon = lv_cur_01(i).p_jaql154mda
                and JAQL101Pap = lv_cur_01(i).p_jaql154pap
                and JAQL101Cta = lv_cur_01(i).p_jaql154cta
                and JAQL101Ope = lv_cur_01(i).p_jaql154ope
                and JAQL101Sop = lv_cur_01(i).p_jaql154sbo
                and JAQL101Top = lv_cur_01(i).p_jaql154top
                and JAQL101fch = d_JAQL101fch;
              
                select JAQL101Scl
                into c_jaql154spy
                from JAQL101
                where JAQL101Pgc = lv_cur_01(i).p_jaql154emp
                and JAQL101Mod = lv_cur_01(i).p_jaql154mod
                and JAQL101Suc = lv_cur_01(i).p_jaql154suc
                and JAQL101Mon = lv_cur_01(i).p_jaql154mda
                and JAQL101Pap = lv_cur_01(i).p_jaql154pap
                and JAQL101Cta = lv_cur_01(i).p_jaql154cta
                and JAQL101Ope = lv_cur_01(i).p_jaql154ope
                and JAQL101Sop = lv_cur_01(i).p_jaql154sbo
                and JAQL101Top = lv_cur_01(i).p_jaql154top
                and JAQL101fch = d_JAQL101fch
                and JAQL101cor = n_JAQL101cor;
              exception when no_data_found then
                c_jaql154spy := null;
              end;
            end if;

            p_jaql154nev := lv_cur_01(i).p_jaql154nev;

            -----------------------------------------
            -- registra detalle de sobreendeudamiento
            begin
              insert into jaql154
                (jaql154ani, --1
                 jaql154mes, --2
                 jaql154emp, --3
                 jaql154mod, --4
                 jaql154suc, --5
                 jaql154mda, --6
                 jaql154pap, --7
                 jaql154ope, --8
                 jaql154sbo, --9
                 jaql154top, --10
                 jaql154rub, --11
                 jaql154cta, --12
                 jaql154sdo, --13
                 jaql154pai, --15
                 jaql154tdo, --16
                 jaql154ndo, --17
                 jaql154tpe, --18
                 jaql154seg, --19
                 jaql154tac, --20
                 jaql154dac, --21
                 jaql154nsu, --22
                 jaql154rbn, --23
                 jaql154drb, --24
                 jaql154rns, --26
                 jaql154rnd, --27
                 jaql154pas, --28
                 jaql154pad, --29
                 jaql154ins, --30
                 jaql154ind, --31
                 jaql154tcf, --32
                 jaql154nev, --34
                 jaql154des, --36
                 jaql154tcr, --37
                 jaql154tip, -- 38
                 jaql154tpa, --39
                 jaql154rdt, --40
                 jaql154cma, --41
                 jaql154csf, --42
                 jaql154cme,
                 jaql154cpe,
                 jaql154cnr,
                 jaql154ccr,
                 jaql154chp,
                 JAQL154SME,
                 JAQL154SPE,
                 JAQL154SNR,
                 JAQL154SCR,
                 JAQL154SHP,
                 jaql154fcm,
                 jaql154fcp,
                 jaql154fcn,
                 jaql154fcr,
                 jaql154fch,
                 jaql154fsm,
                 jaql154fsp,
                 jaql154fsn,
                 jaql154fsr,
                 jaql154fsh,
                 jaql154cal,
                 JAQL154SCM,
                 JAQL154CDR,
                 JAQL154IDC,
                 JAQL154IDR,
                 JAQL154DPT,
                 JAQL154TCS,
                 JAQL154SEC,
                 JAQL154SPY,
                 JAQL154MMO,
                 JAQL154CCC,
                 JAQL154CCS,
                 JAQL154FCC,
                 JAQL154FCS,
                 JAQL154DCC,
                 JAQL154DCS,
                 JAQL154DPC,
                 JAQL154ANL
                 )
              values
                (lv_cur_01(i).p_jaql154ani, --1
                 lv_cur_01(i).p_jaql154mes, --2
                 lv_cur_01(i).p_jaql154emp, --3
                 lv_cur_01(i).p_jaql154mod, --4
                 lv_cur_01(i).p_jaql154suc, --5
                 lv_cur_01(i).p_jaql154mda, --6
                 lv_cur_01(i).p_jaql154pap, --7
                 lv_cur_01(i).p_jaql154ope, --8
                 lv_cur_01(i).p_jaql154sbo, --9
                 lv_cur_01(i).p_jaql154top, --10
                 lv_cur_01(i).p_jaql154rub, --11
                 lv_cur_01(i).p_jaql154cta, --12
                 lv_cur_01(i).p_jaql154sdo, --13
                 lv_cur_01(i).p_jaql154pai, --15
                 lv_cur_01(i).p_jaql154tdo, --16
                 lv_cur_01(i).p_jaql154ndo, --17
                 lv_cur_01(i).p_jaql154tpe, --18
                 lv_cur_01(i).p_jaql154seg, --19
                 lv_cur_01(i).p_jaql154tac, --20
                 lv_cur_01(i).p_jaql154dac, --21
                 lv_cur_01(i).p_jaql154nsu, --22
                 lv_cur_01(i).p_jaql154rbn, --23
                 lv_cur_01(i).p_jaql154drb, --24
                 ln_resnsol, --26
                 ln_resndol, --27
                 ln_patsol, --28
                 ln_patdol, --29
                 ln_egfsol, --30
                 ln_egfdol, --31
                 ln_tipcam, --32
                 p_jaql154nev, --34
                 lc_ulteva, --36
                 lv_cur_01(i).p_jaql154tcr, --37
                 lc_tipcli, --38
                 lc_tippas, --39
                 ln_ratio, --40
                 -5, --41
                 ln_camemp, --42
                 nvl(ln_cuocm3,0), --jaql154cme
                 nvl(ln_cuocm5,0), --jaql154cpe
                 nvl(ln_cuocm2,0), --jaql154cnr
                 nvl(ln_cuocm7,0), --jaql154ccr
                 nvl(ln_cuocm4,0), --jaql154chp
                 nvl(n_tit_cuosf3,0), --JAQL154SME
                 nvl(n_tit_cuosf5,0), --JAQL154SPE
                 nvl(n_tit_cuosf2,0), --JAQL154SNR
                 nvl(n_tit_cuosf7,0), --JAQL154SCR
                 nvl(n_tit_cuosf4,0),--JAQL154SHP
                 nvl(n_tit_cucff3,0), --jaql154fcm,
                 nvl(n_tit_cucff5,0),--jaql154fcp,
                 nvl(n_tit_cucff2,0),--jaql154fcn,
                 nvl(n_tit_cucff7,0),--jaql154fcr,
                 nvl(n_tit_cucff4,0),--jaql154fch,
                 nvl(n_tit_cusff3,0),--jaql154fsm,
                 nvl(n_tit_cusff5,0),--jaql154fsp,
                 nvl(n_tit_cusff2,0),--jaql154fsn,
                 nvl(n_tit_cusff7,0),--jaql154fsr,
                 nvl(n_tit_cusff4,0),--jaql154fsh)
                 PQ_CR_JAQL157_SOBEND.fn_cr_calificacion_sbs(lv_cur_01(i).p_jaql154tdo, lv_cur_01(i).p_jaql154ndo, lv_cur_01(i).p_jaql154mod),--JAQL154CAL
                 nvl(ln_salcma, 0),--JAQL154SCM
                 nvl(n_crercc, 0),--JAQL154CDR
                 nvl(ln_indcma, 0),--JAQL154IDC
                 nvl(n_devrcc, 0),--JAQL154IDR
                 nvl(n_tit_dcmpot, 0) + nvl(n_tit_dsfpot, 0),--JAQL154DPT
                 c_jaql154tcs,--JAQL154TCS
                 c_jaql154sec,--JAQL154SEC,
                 c_jaql154spy,--JAQL154SPY
                 decode(lc_tippas,'C',nvl(n_tit_dcmdir,0) + nvl(n_tit_dcmpot,0),0),--JAQL154MMO
                 nvl(ln_cuocm3_c,0) + nvl(ln_cuocm5_c,0) + nvl(ln_cuocm2_c,0) + nvl(ln_cuocm7_c,0) + nvl(ln_cuocm4_c,0), --JAQL154CCC
                 nvl(n_con_cuosf3,0) + nvl(n_con_cuosf5,0) + nvl(n_con_cuosf2,0) + nvl(n_con_cuosf7,0) + nvl(n_con_cuosf4,0), --JAQL154CCS
                 nvl(n_con_cucff3,0) + nvl(n_con_cucff5,0) + nvl(n_con_cucff2,0) + nvl(n_con_cucff7,0) + nvl(n_con_cucff4,0), --JAQL154FCC
                 nvl(n_con_cusff3,0) + nvl(n_con_cusff5,0) + nvl(n_con_cusff2,0) + nvl(n_con_cusff7,0) + nvl(n_con_cusff4,0), --JAQL154FCS
                 nvl(n_con_dcmdir, 0), --JAQL154DCC
                 nvl(n_con_dsfdir, 0), --JAQL154DCS
                 nvl(n_con_dcmpot, 0) + nvl(n_con_dsfpot, 0), --JAQL154DPC
                 c_jaql154anl);--JAQL154ANL
             end;

------------------------------------------------------------------------------------
--FIN CÁLCULO DE DATOS--------------------------------------------------------------

            n_count2 := n_count2 + 1;

          END IF;

        EXIT WHEN n_count >= P_N_REGFIN;
        END LOOP;

    EXIT WHEN n_count >= P_N_REGFIN;
    END LOOP;

    COMMIT;
    
    begin
      insert into JAQL410
      (
        JAQL410FCH,
        JAQL410RGI,
        JAQL410RGF,
        JAQL410PAI,
        JAQL410TDI,
        JAQL410NDI,
        JAQL410PAF,
        JAQL410TDF,
        JAQL410NDF,
        JAQL410HRI,
        JAQL410HRF,
        JAQL410REG
      )    
      values
      (
        P_D_FECHA,
        P_N_REGINI,
        P_N_REGFIN,
        ln_JAQL410PAI,
        ln_JAQL410TDI,
        lc_JAQL410NDI,
        ln_JAQL410PAF,
        ln_JAQL410TDF,
        lc_JAQL410NDF,
        ld_JAQL410HRI,
        sysdate,
        n_count2
      );
      COMMIT;
      
      begin
        select count(*)
        into n_count
        from jaql410
        where jaql410fch = P_D_FECHA
        and jaql410rgi <> 0;

        select jaql410rgf
        into n_count2
        from jaql410
        where jaql410fch = P_D_FECHA
        and jaql410rgi = 0;

        if ( n_count = n_count2 ) then
          update jaql410 
          set
          JAQL410HRF = sysdate, 
          JAQL410REG = 0
          where jaql410fch = P_D_FECHA
          and jaql410rgi = 0;          
          COMMIT;
        end if;
        
      exception when others then
        DBMS_OUTPUT.put_line('Error Actualización JAQL410');
      end;      
      
    exception when others then
      DBMS_OUTPUT.put_line('Error Inserción JAQL410');        
    end;

end;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_sobreend_jaql157(P_FECPRE in date,
                                   P_N_REGINI in number,
                                   P_N_REGFIN in number) IS
  -- *****************************************************************
  -- Nombre                     : sp_cr_sobreend_jaql157
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos - Riesgos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2013.05.30
  -- Autor de Creación          : DRODRIGUEZD
  -- Uso                        : Consolidar datos de sobreendeudamiento
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : P_FECPRE (FECHA DE PROCESO)
  --                              P_N_REGINI (REGISTRO DE INICIO)
  --                              P_N_REGINI (REGISTRO DE FIN)
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  ln_tipcam fsh005.COTCBI%type := PQ_CR_JAQL157_SOBEND.fn_cr_tipocambio(P_FECPRE);

  n_count number(17);
  n_count2 number(17);

  type sobend_rec is record
  (
    P_jaql154ani jaql154.jaql154ani%type,
    P_JAQL154CAL jaql154.JAQL154CAL%type,
    P_JAQL154CCC jaql154.JAQL154CCC%type,
    P_JAQL154CCR jaql154.JAQL154CCR%type,
    P_JAQL154CCS jaql154.JAQL154CCS%type,
    P_JAQL154CDR jaql154.JAQL154CDR%type,
    P_JAQL154CHP jaql154.JAQL154CHP%type,
    P_JAQL154CME jaql154.JAQL154CME%type,
    P_JAQL154CNR jaql154.JAQL154CNR%type,
    P_JAQL154CPE jaql154.JAQL154CPE%type,
    P_jaql154csf jaql154.jaql154csf%type,
    P_JAQL154DCC jaql154.JAQL154DCC%type,
    P_JAQL154DCS jaql154.JAQL154DCS%type,
    P_JAQL154DPC jaql154.JAQL154DPC%type,
    P_JAQL154DPT jaql154.JAQL154DPT%type,
    P_JAQL154FCC jaql154.JAQL154FCC%type,
    P_JAQL154FCH jaql154.JAQL154FCH%type,
    P_JAQL154FCM jaql154.JAQL154FCM%type,
    P_JAQL154FCN jaql154.JAQL154FCN%type,
    P_JAQL154FCP jaql154.JAQL154FCP%type,
    P_JAQL154FCR jaql154.JAQL154FCR%type,
    P_JAQL154FCS jaql154.JAQL154FCS%type,
    P_JAQL154FSH jaql154.JAQL154FSH%type,
    P_JAQL154FSM jaql154.JAQL154FSM%type,
    P_JAQL154FSN jaql154.JAQL154FSN%type,
    P_JAQL154FSP jaql154.JAQL154FSP%type,
    P_JAQL154FSR jaql154.JAQL154FSR%type,
    P_JAQL154IDC jaql154.JAQL154IDC%type,
    P_JAQL154IDR jaql154.JAQL154IDR%type,
    P_jaql154ind jaql154.jaql154ind%type,
    P_jaql154ins jaql154.jaql154ins%type,
    P_jaql154mes jaql154.jaql154mes%type,
    P_jaql154mmo jaql154.jaql154mmo%type,
    P_jaql154ndo jaql154.jaql154ndo%type,
    P_jaql154pad jaql154.jaql154pad%type,
    P_jaql154pai jaql154.jaql154pai%type,
    P_jaql154pas jaql154.jaql154pas%type,
    P_JAQL154SCM jaql154.JAQL154SCM%type,
    P_JAQL154SCR jaql154.JAQL154SCR%type,
    P_jaql154sec jaql154.jaql154sec%type,
    P_jaql154seg jaql154.jaql154seg%type,
    P_JAQL154SHP jaql154.JAQL154SHP%type,
    P_JAQL154SME jaql154.JAQL154SME%type,
    P_JAQL154SNR jaql154.JAQL154SNR%type,
    P_JAQL154SPE jaql154.JAQL154SPE%type,
    P_jaql154spy jaql154.jaql154spy%type,
    P_jaql154tcf jaql154.jaql154tcf%type,
    P_jaql154tcs jaql154.jaql154tcs%type,
    P_jaql154tdo jaql154.jaql154tdo%type,
    P_jaql154tpa jaql154.jaql154tpa%type,
    P_jaql154tpe jaql154.jaql154tpe%type
  );

  TYPE sobend_cur IS TABLE OF sobend_rec;

  lv_sobend sobend_cur;

  cursor cur_sobend is
--            select /*+ PARALLEL(JAQL154, 2) ALL_ROWS */ distinct JAQL154ANI, 
            select distinct JAQL154ANI, 
                   JAQL154CAL, 
                   JAQL154CCC, 
                   JAQL154CCR, 
                   JAQL154CCS, 
                   JAQL154CDR, 
                   JAQL154CHP, 
                   JAQL154CME, 
                   JAQL154CNR, 
                   JAQL154CPE, 
                   jaql154csf, 
                   JAQL154DCC, 
                   JAQL154DCS, 
                   JAQL154DPC, 
                   JAQL154DPT, 
                   JAQL154FCC, 
                   JAQL154FCH, 
                   JAQL154FCM, 
                   JAQL154FCN, 
                   JAQL154FCP, 
                   JAQL154FCR, 
                   JAQL154FCS, 
                   JAQL154FSH, 
                   JAQL154FSM, 
                   JAQL154FSN, 
                   JAQL154FSP, 
                   JAQL154FSR, 
                   JAQL154IDC, 
                   JAQL154IDR, 
                   0 jaql154ind, 
                   0 jaql154ins, 
                   jaql154mes, 
                   jaql154mmo, 
                   jaql154ndo, 
                   0 jaql154pad, 
                   jaql154pai, 
                   0 jaql154pas, 
                   JAQL154SCM, 
                   JAQL154SCR, 
                   jaql154sec, 
                   jaql154seg, 
                   JAQL154SHP, 
                   JAQL154SME, 
                   JAQL154SNR, 
                   JAQL154SPE, 
                   0 jaql154spy, 
                   jaql154tcf, 
                   jaql154tcs, 
                   jaql154tdo, 
                   jaql154tpa, 
                   jaql154tpe 
              from JAQL154 
             where jaql154ani = to_number(EXTRACT(YEAR FROM P_FECPRE))
                   and jaql154mes = to_number(EXTRACT(MONTH FROM P_FECPRE))
                   order by JAQL154PAI, JAQL154TDO, JAQL154NDO;

  -- datos sistema financiero
  ld_JAQL411HRI DATE;
  ln_JAQL411PAI NUMBER(3);
  ln_JAQL411TDI NUMBER(2);
  lc_JAQL411NDI CHAR(12);
  ln_JAQL411PAF NUMBER(3);
  ln_JAQL411TDF NUMBER(2);
  lc_JAQL411NDF CHAR(12);

  begin

  n_count := 0;
  n_count2 := 0;

  ld_JAQL411HRI := sysdate;  

  OPEN cur_sobend;
    LOOP

      FETCH cur_sobend BULK COLLECT
      INTO lv_sobend LIMIT 100;
      EXIT WHEN lv_sobend.COUNT = 0;

        FOR i IN 1 .. lv_sobend.COUNT LOOP

          n_count := n_count + 1;

          IF ( n_count >= P_N_REGINI ) AND ( n_count <= P_N_REGFIN ) THEN

            if ( n_count = P_N_REGINI ) then
              ln_JAQL411PAI := lv_sobend(i).p_jaql154pai;
              ln_JAQL411TDI := lv_sobend(i).p_jaql154tdo;
              lc_JAQL411NDI := lv_sobend(i).p_jaql154ndo;
            end if;

            if ( n_count <= P_N_REGFIN ) then
              ln_JAQL411PAF := lv_sobend(i).p_jaql154pai;
              ln_JAQL411TDF := lv_sobend(i).p_jaql154tdo;
              lc_JAQL411NDF := lv_sobend(i).p_jaql154ndo;
            end if;

          -- CÁLCULO DE DATOS ----------------------------------------------------------------
          ------------------------------------------------------------------------------------

            begin

              begin
                select max(jaql154ind), max(jaql154ins), max(jaql154pad), max(jaql154pas), max(jaql154spy)
                into lv_sobend(i).p_jaql154ind,
                     lv_sobend(i).p_jaql154ins,
                     lv_sobend(i).p_jaql154pad,
                     lv_sobend(i).p_jaql154pas,
                     lv_sobend(i).p_jaql154spy
                from jaql154
                where jaql154pai = lv_sobend(i).p_JAQL154PAI
                and jaql154tdo = lv_sobend(i).p_JAQL154TDO
                and jaql154ndo = lv_sobend(i).p_JAQL154NDO
                and jaql154ani = lv_sobend(i).p_JAQL154ANI
                and jaql154mes = lv_sobend(i).p_JAQL154MES;
              exception when others then
                lv_sobend(i).p_jaql154ind := null;
                lv_sobend(i).p_jaql154ins := null;
                lv_sobend(i).p_jaql154pad := null;
                lv_sobend(i).p_jaql154pas := null;
                lv_sobend(i).p_jaql154spy := null;
              end;
  
              begin
                insert into JAQL157
                  (
                    JAQL157ANI,
                    JAQL157MES,
                    JAQL157PAI,
                    JAQL157TDO,
                    JAQL157NDO,
                    JAQL157FCH,
                    JAQL157TAC,
                    JAQL157SUC,
                    JALQ157TPE,
                    JAQL157SBS,
                    JAQL157SEG,
                    JAQL157CAL,
                    JAQL157INT,
                    JAQL157PAT,
                    JAQL157RES,
                    JAQL157SAL,
                    JAQL157DEV,
                    JAQL157REV,
                    JAQL157CAF,
                    JAQL157NRV,
                    JAQL157EXR,
                    JAQL157CDI,
                    JAQL157IDV,
                    JAQL157CFI,
                    JAQL157LNU,
                    JAQL157CCR,
                    JAQL157AVO,
                    JAQL157ACB,
                    JAQL157ENT,
                    JAQL157HIP,
                    JAQL157APR,
                    JAQL157DTH,
                    JAQL157DTS,
                    JAQL157DP0,
                    JAQL157DGC,
                    JAQL157DGH,
                    JAQL157DGS,
                    JAQL157DPH,
                    JAQL157DPS,
                    JAQL157DIA,
                    JAQL157SOB,
                    JAQL157PAR,
                    JAQL157ANP,
                    JAQL157MEP,
                    JAQL157TVL,
                    jaql157csf,
                    jaql157cma,
                    jaql157rat,
                    jaql157ren
                  )
                  values
                  (
                    lv_sobend(i).p_jaql154ani, --JAQL157ANI
                    lv_sobend(i).p_jaql154mes, --JAQL157MES
                    lv_sobend(i).p_jaql154pai, --JAQL157PAI
                    lv_sobend(i).p_jaql154tdo, --JAQL157TDO
                    lv_sobend(i).p_jaql154ndo, --JAQL157NDO
                    P_FECPRE, --JAQL157FCH
                    null,--JAQL157TAC
                    0, --JAQL157SUC
                    lv_sobend(i).p_jaql154tpe, --JALQ157TPE
                    '-', --k.jaql155sbs,--JAQL157SBS
                    lv_sobend(i).p_jaql154seg,--JAQL157SEG
                    lv_sobend(i).p_JAQL154CAL, --JAQL157CAL
                    nvl(PQ_CR_JAQL157_SOBEND.fn_cr_ultimo_ingnet(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo,lv_sobend(i).p_jaql154ani,lv_sobend(i).p_jaql154mes,ln_tipcam),0), --JAQL157INT
                    (nvl(lv_sobend(i).p_jaql154pas,0) + nvl(lv_sobend(i).p_jaql154pad,0) * ln_tipcam), --JAQL157PAT
                    nvl(PQ_CR_JAQL157_SOBEND.fn_cr_ultimo_resnet(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo,lv_sobend(i).p_jaql154ani,lv_sobend(i).p_jaql154mes,ln_tipcam),0), --JAQL157RES
                    0, --JAQL157SAL
                    0, --k.jaql155ind, --JAQL157DEV
                    0, --lv_sobend(i).p_jaql154lnu, --JAQL157REV
                    0, --k.jaql155caf, --JAQL157CAF
                    0, --k.jaql155lnn, --JAQL157NRV
                    NVL(lv_sobend(i).p_JAQL154FCM,0) + NVL(lv_sobend(i).p_JAQL154FCP,0) + NVL(lv_sobend(i).p_JAQL154FCN,0) + NVL(lv_sobend(i).p_JAQL154FCR,0) + NVL(lv_sobend(i).p_JAQL154FCH,0) + NVL(lv_sobend(i).p_JAQL154FSM,0) + NVL(lv_sobend(i).p_JAQL154FSP,0) + NVL(lv_sobend(i).p_JAQL154FSN,0) + NVL(lv_sobend(i).p_JAQL154FSR,0) + NVL(lv_sobend(i).p_JAQL154FSH,0) + NVL(lv_sobend(i).p_JAQL154FCC,0) + NVL(lv_sobend(i).p_JAQL154FCS,0), --JAQL157EXR
                    0, --k.jaql155crd, --JAQL157CDI
                    0, --lv_sobend(i).p_jaql154idv, --JAQL157IDV
                    0, --k.jaql155caf, --JAQL157CFI
                    0, --k.jaql155lnn, --JAQL157LNU
                    0, --k.jaql155cac, --JAQL157CCR
                    0, --k.jaql155avo, --JAQL157AVO
                    0, --k.jaql155acb, --JAQL157ACB
                    PQ_CR_JAQL157_SOBEND.fn_cr_nument(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo, lv_sobend(i).p_jaql154ani, lv_sobend(i).p_jaql154mes),--k.jaql155ent, --JAQL157ENT
                    0, --JAQL157HIP
                    0, --JAQL157APR
                    NVL(lv_sobend(i).p_JAQL154SCM,0) + NVL(lv_sobend(i).p_JAQL154CDR,0) + NVL(lv_sobend(i).p_JAQL154IDC,0) + NVL(lv_sobend(i).p_JAQL154IDR,0) + NVL(lv_sobend(i).p_JAQL154DCC,0) + NVL(lv_sobend(i).p_JAQL154DCS,0) + NVL(lv_sobend(i).p_JAQL154DPT,0) + NVL(lv_sobend(i).p_JAQL154DPC,0), --JAQL157DTH -- DEUDA TOTAL
                    NVL(lv_sobend(i).p_JAQL154SCM,0) + NVL(lv_sobend(i).p_JAQL154CDR,0) + NVL(lv_sobend(i).p_JAQL154IDC,0) + NVL(lv_sobend(i).p_JAQL154IDR,0) + NVL(lv_sobend(i).p_JAQL154DCC,0) + NVL(lv_sobend(i).p_JAQL154DCS,0) + NVL(lv_sobend(i).p_JAQL154SHP,0), --JAQL157DTS -- DEUDA DIRECTA
                    NVL(lv_sobend(i).p_JAQL154DPT,0) + NVL(lv_sobend(i).p_JAQL154DPC,0), --JAQL157DP0 -- DEUDA POTENCIAL
                    0, --NVL((lv_sobend(i).p_jaql154tcf + k.jaql155caf + k.jaql155avo + k.jaql155crd + k.jaql155acb + lv_sobend(i).p_jaql154nev),0) + (lv_sobend(i).p_jaql154lnu + k.jaql155lnn),--JAQL157DGC
                    0, --JAQL157DGH
                    0, --JAQL157DGS
                    0, --JAQL157DPH
                    0, --JAQL157DPS
                    0, --JAQL157DIA
                    PQ_CR_JAQL157_SOBEND.fn_cr_nivel_sobend(nvl(PQ_CR_JAQL157_SOBEND.fn_cr_ultimo_ratdet(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo,lv_sobend(i).p_jaql154ani,lv_sobend(i).p_jaql154mes),0)/100,
                                                            lv_sobend(i).p_jaql154csf, lv_sobend(i).p_jaql154cal, lv_sobend(i).p_jaql154tpa, (NVL(lv_sobend(i).p_JAQL154SCM,0) + NVL(lv_sobend(i).p_JAQL154CDR,0) + NVL(lv_sobend(i).p_JAQL154IDC,0) + NVL(lv_sobend(i).p_JAQL154IDR,0) + NVL(lv_sobend(i).p_JAQL154DCC,0) + NVL(lv_sobend(i).p_JAQL154DCS,0) + NVL(lv_sobend(i).p_JAQL154DPT,0) + NVL(lv_sobend(i).p_JAQL154DPC,0)), ((nvl(lv_sobend(i).p_jaql154pas,0) + nvl(lv_sobend(i).p_jaql154pad,0) * ln_tipcam)), lv_sobend(i).p_jaql154mmo, ((nvl(lv_sobend(i).p_jaql154ins,0) + nvl(lv_sobend(i).p_jaql154ind,0) * ln_tipcam)), lv_sobend(i).p_jaql154tcs, lv_sobend(i).p_jaql154sec, lv_sobend(i).p_jaql154spy), --JAQL157SOB
                    lv_sobend(i).p_jaql154tcf, --JAQL157PAR
                    lv_sobend(i).p_jaql154ani, --JAQL157ANP
                    lv_sobend(i).p_jaql154mes, --JAQL157MEP
                    'S', --JAQL157TVL
                    NVL(lv_sobend(i).P_JAQL154SME,0) + NVL(lv_sobend(i).P_JAQL154SPE,0) + NVL(lv_sobend(i).P_JAQL154SNR,0) + NVL(lv_sobend(i).P_JAQL154SCR,0) + NVL(lv_sobend(i).P_JAQL154SHP,0) + NVL(lv_sobend(i).P_JAQL154CCS,0), --jaql157csf
                    NVL(lv_sobend(i).P_JAQL154CME,0) + NVL(lv_sobend(i).P_JAQL154CPE,0) + NVL(lv_sobend(i).P_JAQL154CNR,0) + NVL(lv_sobend(i).P_JAQL154CCR,0) + NVL(lv_sobend(i).P_JAQL154CHP,0) + NVL(lv_sobend(i).P_JAQL154CCC,0), --jaql157cma
                    NVL(PQ_CR_JAQL157_SOBEND.fn_cr_ultimo_ratdet(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo,lv_sobend(i).p_jaql154ani,lv_sobend(i).p_jaql154mes),0),--jaql157rat
                    PQ_CR_JAQL157_SOBEND.fn_cr_ratio_end( (NVL(lv_sobend(i).p_JAQL154SCM,0) + NVL(lv_sobend(i).p_JAQL154CDR,0) + NVL(lv_sobend(i).p_JAQL154IDC,0) + NVL(lv_sobend(i).p_JAQL154IDR,0) + NVL(lv_sobend(i).p_JAQL154DCC,0) + NVL(lv_sobend(i).p_JAQL154DCS,0) + NVL(lv_sobend(i).p_JAQL154DPT,0) + NVL(lv_sobend(i).p_JAQL154DPC,0)) , ((nvl(lv_sobend(i).p_jaql154pas,0) + nvl(lv_sobend(i).p_jaql154pad,0) * ln_tipcam)), nvl(lv_sobend(i).p_jaql154mmo,0), ( nvl(PQ_CR_JAQL157_SOBEND.fn_cr_ultimo_ingnet(lv_sobend(i).p_jaql154tdo, lv_sobend(i).p_jaql154ndo,lv_sobend(i).p_jaql154ani,lv_sobend(i).p_jaql154mes,ln_tipcam),0) ), lv_sobend(i).p_jaql154tpa ) --jaql157ren
                  );
              exception when DUP_VAL_ON_INDEX then
                n_count2 := n_count2;
              end;
            end;

          ------------------------------------------------------------------------------------
          --FIN CÁLCULO DE DATOS--------------------------------------------------------------

            n_count2 := n_count2 + 1;

          END IF;

       EXIT WHEN n_count >= P_N_REGFIN;
       END LOOP;

    EXIT WHEN n_count >= P_N_REGFIN;
    END LOOP;

    COMMIT;

    begin
      insert into JAQL411
      (
        JAQL411FCH,
        JAQL411RGI,
        JAQL411RGF,
        JAQL411PAI,
        JAQL411TDI,
        JAQL411NDI,
        JAQL411PAF,
        JAQL411TDF,
        JAQL411NDF,
        JAQL411HRI,
        JAQL411HRF,
        JAQL411REG
      )    
      values
      (
        P_FECPRE,
        P_N_REGINI,
        P_N_REGFIN,
        ln_JAQL411PAI,
        ln_JAQL411TDI,
        lc_JAQL411NDI,
        ln_JAQL411PAF,
        ln_JAQL411TDF,
        lc_JAQL411NDF,
        ld_JAQL411HRI,
        sysdate,
        n_count2
      );
      COMMIT;
      
      begin
        select count(*)
        into n_count
        from jaql411
        where jaql411fch = P_FECPRE
        and jaql411rgi <> 0;

        select jaql411rgf
        into n_count2
        from jaql411
        where jaql411fch = P_FECPRE
        and jaql411rgi = 0;

        if ( n_count = n_count2 ) then
          update jaql411
          set
          JAQL411HRF = sysdate, 
          JAQL411REG = 0
          where jaql411fch = P_FECPRE
          and jaql411rgi = 0;          
          COMMIT;
        end if;
        
      exception when others then
        DBMS_OUTPUT.put_line('Error Actualización JAQL411');
      end;      
      
    exception when others then
      DBMS_OUTPUT.put_line('Error Inserción JAQL411');
    end;

end;

---------------------------------------------------------------------------------------------
end PQ_CR_JAQL157_SOBEND;
/

