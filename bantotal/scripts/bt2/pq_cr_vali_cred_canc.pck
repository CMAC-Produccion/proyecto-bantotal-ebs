create or replace package PQ_CR_VALI_CRED_CANC is
  -- *****************************************************************
  -- Nombre                     : VALIDAR TITULAR DE CREDITO CANCELADO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.05.14
  -- Autor de Creación          : EFUENTES
  -- Uso                        : VALIDAR TITULAR
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2021.11.16
  -- Autor de Modificación      : EFUENTES
  -- Descripción                : Se agregaron funciones
  -- Fecha de Modificación      : 2023.11.03
  -- Autor de Modificación      : APACHECOH
  -- Descripción                : Se modificó el filtro de busqueda
  -- Fecha de Modificación      : 2024.02.19
  -- Autor de Modificación      : APACHECOH
  -- Descripción                : Se agregaron funciones para quitar judiciales/castigados/vendidos
  -- Fecha de Modificación      : 2024.03.11
  -- Autor de Modificación      : APACHECOH
  -- Descripción                : Se adiciono líneas de crédito en búsqueda
  -- Modificación               : APACHECOH 2024.07.10 Se corrigió la busqueda de la ultima fecha cancelada
  -- Autor de Modificación      : KVALENCIAC
  -- Descripción                : Se optmizó consultas
  -- Modificación               : KVALENCIAC 24/01/2025 
  -- ****************************************************************

  --** INSERTAR REGISTRO DE CREDITO CANCELADO
  procedure sp_cr_ins_cred_canc(pn_pgcodt  in number,
                                pn_suct    in number,
                                pn_modt    in number,
                                pn_trant   in number,
                                pn_itnrelt in number,
                                pn_coderr  out number,
                                pn_msgerr  out varchar2);

  -----------------------------------------------------------------------
  --** VALIDAR TITULAR DE CREDITO
  procedure sp_cr_vali_titu_cred_canc_2(pn_pgcodt  in number,
                                        pn_suct    in number,
                                        pn_modt    in number,
                                        pn_trant   in number,
                                        pn_itnrelt in number,
                                        pd_itfcont in date,
                                        pn_pais    in number,
                                        pn_tipdoc  in number,
                                        pv_dni     in varchar2,
                                        pv_flagt   out varchar2,
                                        pv_flagi   out varchar2,
                                        pn_instan  out NUMBER,
                                        pn_pgcodc  out NUMBER,
                                        pn_modc    out NUMBER,
                                        pn_succ    out NUMBER,
                                        pn_monc    out NUMBER,
                                        pn_papc    out NUMBER,
                                        pn_ctac    out NUMBER,
                                        pn_opec    out NUMBER,
                                        pn_sopec   out NUMBER,
                                        pn_topec   out NUMBER,
                                        pv_rutaI   out varchar2,
                                        pn_coderr  out number,
                                        pn_msgerr  out varchar2);

  -----------------------------------------------------------------------
  --** DATOS PARA LA CONSTANCIA
  procedure sp_cr_datos_consta_2(pn_pgcodc in number,
                                 pn_modc   in number,
                                 pn_succ   in number,
                                 pn_monc   in number,
                                 pn_papc   in number,
                                 pd_ctac   in number,
                                 pv_opec   in number,
                                 pv_sopec  in number,
                                 pv_topec  in number,
                                 pv_instan in number,
                                 pv_user   in varchar2,
                                 pv_NomCli out varchar2, --
                                 pv_FecDes out varchar2,
                                 pv_ValDes out varchar2,
                                 pv_FecAct out varchar2,
                                 pv_NunDNI out varchar2,
                                 pn_coderr out number,
                                 pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  --** VALIDAR SI ESTA IMPRESA LA CONSTANCIA
  procedure sp_cr_val_impr_cons_canc(pn_pgcodt  in number,
                                     pn_suct    in number,
                                     pn_modt    in number,
                                     pn_trant   in number,
                                     pn_itnrelt in number,
                                     pd_itfcont in date,
                                     pv_flag    out varchar2,
                                     pn_coderr  out number);

  -----------------------------------------------------------------------
  --** GENERAR REPORTE 
  procedure sp_cr_gen_rep_cre_canc(pd_fecini in date,
                                   pd_fecfin in date,
                                   pn_AgeOri in number,
                                   pv_usurep in varchar2,
                                   pn_coderr out number,
                                   pn_msgerr out varchar2);

  procedure sp_cr_gen_rep_cna(pd_fecini in date,
                              pd_fecfin in date,
                              pn_AgeOri in number,
                              pv_usurep in varchar2,
                              pn_coderr out number,
                              pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  --** VALIDAR SI ESTA CANCELADO
  procedure sp_cr_upt_flag(pn_pgcodc in number,
                           pn_modc   in number,
                           pn_succ   in number,
                           pn_monc   in number,
                           pn_papc   in number,
                           pd_ctac   in number,
                           pv_opec   in number,
                           pv_sopec  in number,
                           pv_topec  in number,
                           pv_instan in number,
                           pv_user   in varchar2,
                           pn_coderr out number,
                           pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  -- 28/06/2021                                 
  procedure sp_cr_insert_desde_609(ln_PGCODC in number,
                                   ln_MODC   in number,
                                   ln_SUCC   in number,
                                   ln_MONC   in number,
                                   ln_PAPC   in number,
                                   ln_CTAC   in number,
                                   ln_OPEC   in number,
                                   ln_SOPEC  in number,
                                   ln_TOPEC  in number,
                                   ln_usuari in varchar2,
                                   ln_pepais in NUMBER,
                                   ln_petdoc in NUMBER,
                                   pv_pendoc in varchar2,
                                   ln_INSTAN out number,
                                   pn_coderr out number,
                                   pn_msgerr out varchar2);

  procedure sp_cr_insert_desde_609B(ln_PGCODC in number,
                                    ln_MODC   in number,
                                    ln_SUCC   in number,
                                    ln_MONC   in number,
                                    ln_PAPC   in number,
                                    ln_CTAC   in number,
                                    ln_OPEC   in number,
                                    ln_SOPEC  in number,
                                    ln_TOPEC  in number,
                                    ln_usuari in varchar2,
                                    ln_pepais in NUMBER,
                                    ln_petdoc in NUMBER,
                                    pv_pendoc in varchar2,
                                    ln_INSTAN out number,
                                    pn_coderr out number,
                                    pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  -- 25/05/2022
  procedure sp_cr_insert_desde_rte608(pn_pgcodt  in number,
                                      pn_suct    in number,
                                      pn_modt    in number,
                                      pn_trant   in number,
                                      pn_itnrelt in number,
                                      pv_usuario in varchar2);

  -----------------------------------------------------------------------
  -- 02/11/2021     
  procedure sp_cr_generar_lst_crd(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2);

  -----------------------------------------------------------------------
  -- 11/11/2021     
  procedure sp_cr_generar_lst_crd_2(pn_pais  in number,
                                    pn_tdoc  in number,
                                    pn_ndoc  in varchar2,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pv_usua  in varchar2,
                                    pd_fguia in date,
                                    pd_fsys  in date,
                                    pn_cerr  out number,
                                    pv_merr  out varchar2);

  -----------------------------------------------------------------------
  -- 11/11/2021     
  procedure sp_cr_generar_lst_crd_3(pn_pais  in number,
                                    pn_tdoc  in number,
                                    pn_ndoc  in varchar2,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pv_usua  in varchar2,
                                    pd_fguia in date,
                                    pd_fsys  in date,
                                    pn_cerr  out number,
                                    pv_merr  out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_dat_credito_2(pn_pgcod  in number,
                                pn_cta    in number,
                                pv_ope    in number,
                                pn_mod    in number,
                                pn_pgcodO out number,
                                pn_sucO   out number,
                                pn_modO   out number,
                                pn_monO   out number,
                                pn_papO   out number,
                                pn_ctaO   out number,
                                pn_opeO   out number,
                                pn_sopeO  out number,
                                pn_topeO  out number);

  -----------------------------------------------------------------------
  /*procedure sp_cr_val_estado_2(pn_pgcod   in number, 
  pn_cuenta  in number,
  pn_modulo  in number,
  pn_opera   in number,
  pn_sucur   in number,
  pn_moneda  in number,
  pn_papel   in number,
  pn_tope    in number,
  pd_fecgui  in date, 
  pv_FlagSta out varchar2,
  pd_fecha99 out date,
  pv_estado  out number);*/
  procedure sp_cr_val_estado_2(pn_pgcod   in number,
                               pn_cuenta  in number,
                               pn_modulo  in number,
                               pn_opera   in number,
                               pn_sucur   in number,
                               pn_moneda  in number,
                               pn_papel   in number,
                               pn_tope    in number,
                               pd_fecgui  in date,
                               pv_Flag    out varchar2,
                               pd_fecha99 out date,
                               pn_estado  out number);

  -----------------------------------------------------------------------
  procedure sp_cr_val_contancia_2(pn_pgcod   in number,
                                  pn_suc     in number,
                                  pn_mod     in number,
                                  pn_mon     in number,
                                  pn_pap     in number,
                                  pn_cta     in number,
                                  pn_ope     in number,
                                  pn_sope    in number,
                                  pn_tope    in number,
                                  pv_Flag608 out varchar,
                                  pv_FlagImp out varchar);

  -----------------------------------------------------------------------
  procedure sp_cr_val_modulo_2(pn_modulo  in number,
                               pv_FlagMod out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_val_TipOpe_gr_2(pn_pgcodc  in NUMBER,
                                  pn_modc    in NUMBER,
                                  pn_succ    in NUMBER,
                                  pn_monc    in NUMBER,
                                  pn_papc    in NUMBER,
                                  pn_ctac    in NUMBER,
                                  pn_opec    in NUMBER,
                                  pn_sopec   in NUMBER,
                                  pn_topec   in NUMBER,
                                  pv_FlagGar out varchar2,
                                  pn_tipope  out number);

  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Crd99(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_fecpro in date,
                              pn_coderr out number,
                              lv_flgCan out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Aval99(pn_pgcod  in number,
                               pn_itsuc  in number,
                               pn_itmod  in number,
                               pn_ittran in number,
                               pn_itnrel in number,
                               pn_fecpro in date,
                               pn_coderr out number,
                               lv_flgCan out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_val_Aval(pn_pgcodc  in number,
                           pn_modc    in number,
                           pn_succ    in number,
                           pn_monc    in number,
                           pn_papc    in number,
                           pd_ctac    in number,
                           pv_opec    in number,
                           pv_sopec   in number,
                           pv_topec   in number,
                           pn_ConTot  in number,
                           pn_ConIng  in number,
                           pv_NroCre  out varchar2,
                           pv_FecDes  out varchar2,
                           pv_ValDes  out varchar2,
                           pn_ConTotS out number,
                           pn_ConIngS out number);

  -----------------------------------------------------------------------
  procedure sp_cr_datos_aval(pn_pgcodc in number,
                             pn_modc   in number,
                             pn_succ   in number,
                             pn_monc   in number,
                             pn_papc   in number,
                             pd_ctac   in number,
                             pv_opec   in number,
                             pv_sopec  in number,
                             pv_topec  in number,
                             pv_NroCre out varchar2, --
                             pv_FecDes out varchar2,
                             pv_ValDes out varchar2);

  -----------------------------------------------------------------------                             
  procedure sp_cr_val_Titular(pn_pgcodc  in number,
                              pn_modc    in number,
                              pn_succ    in number,
                              pn_monc    in number,
                              pn_papc    in number,
                              pd_ctac    in number,
                              pv_opec    in number,
                              pv_sopec   in number,
                              pv_topec   in number,
                              pn_ConTot  in number,
                              pn_ConIng  in number,
                              pv_NroCre  out varchar2,
                              pv_FecDes  out varchar2,
                              pv_ValDes  out varchar2,
                              pn_ConTotS out number,
                              pn_ConIngS out number);

  -----------------------------------------------------------------------
  procedure sp_log_rte608(pn_pgcodt  in number,
                          pn_suct    in number,
                          pn_modt    in number,
                          pn_trant   in number,
                          pn_itnrelt in number,
                          pd_fecsis  in date);

  -----------------------------------------------------------------------
  --** DATOS PARA LA CERTIFICADO DE NO ADEUDO
  procedure sp_cr_datos_CNA(pn_pgcodc in number,
                            pn_modc   in number,
                            pn_succ   in number,
                            pn_monc   in number,
                            pn_papc   in number,
                            pd_ctac   in number,
                            pv_opec   in number,
                            pv_sopec  in number,
                            pv_topec  in number,
                            pv_instan in number,
                            pv_user   in varchar2,
                            pv_NomCli out varchar2, --
                            pv_FecDes out varchar2,
                            pv_ValDes out varchar2,
                            pv_FecAct out varchar2,
                            pv_NunDNI out varchar2,
                            pn_coderr out number,
                            pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_val_Aval_2(pn_pgcodc in number,
                             pn_modc   in number,
                             pn_succ   in number,
                             pn_monc   in number,
                             pn_papc   in number,
                             pd_ctac   in number,
                             pv_opec   in number,
                             pv_sopec  in number,
                             pv_topec  in number,
                             pn_coderr out number,
                             lv_flgCan out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Crd99_2(pn_pgcodc in number,
                                pn_modc   in number,
                                pn_succ   in number,
                                pn_monc   in number,
                                pn_papc   in number,
                                pd_ctac   in number,
                                pv_opec   in number,
                                pv_sopec  in number,
                                pv_topec  in number,
                                pn_coderr out number,
                                lv_flgCan out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Aval99_2(pn_nrocta in number,
                                 pn_coderr out number,
                                 lv_flgCan out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_generar_lst_cna(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2);
  -----------------------------------------------------------------------
  --update glosa de garantia
  procedure sp_cr_upd_gl_garantia(pn_pgcodc in number,
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number,
                                  pd_ctac   in number,
                                  pv_opec   in number,
                                  pv_sopec  in number,
                                  pv_topec  in number,
                                  pv_flgglo in varchar2,
                                  pn_tipope in number,
                                  pv_progr  in varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_upd_TipCon(pn_pgcod  in number,
                             pn_itsuc  in number,
                             pn_itmod  in number,
                             pn_ittran in number,
                             pn_itnrel in number,
                             pn_fecpro in date);

  procedure sp_cr_upd_TipCon_2(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pd_ctac   in number,
                               pv_opec   in number,
                               pv_sopec  in number,
                               pv_topec  in number);

  -----------------------------------------------------------------------
  procedure sp_cr_obtener_hora(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pn_ctac   in number,
                               pn_opec   in number,
                               pn_sopec  in number,
                               pn_topec  in number,
                               pd_fecha  in date,
                               pv_hora   out varchar2,
                               pd_fecon  out date);
  -----------------------------------------------------------------------
  function fn_get_FecGuia return date;

  -----------------------------------------------------------------------  
  function fn_get_saldo_fsd011(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pd_ctac   in number,
                               pv_opec   in number,
                               pv_sopec  in number,
                               pv_topec  in number) return number;

  -----------------------------------------------------------------------  
  function fn_get_saldo_JAQL175(pn_pgcodc in number,
                                pn_modc   in number,
                                pn_succ   in number,
                                pn_monc   in number,
                                pn_papc   in number,
                                pd_ctac   in number,
                                pv_opec   in number,
                                pv_sopec  in number,
                                pv_topec  in number,
                                pv_estado in number) return number;

  -----------------------------------------------------------------------  
  function fn_verificar_estados(pn_estado in number) return number;

  -----------------------------------------------------------------------  
  procedure sp_cr_es_castigado(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pn_ctac   in number,
                               pn_opec   in number,
                               pn_sopec  in number,
                               pn_topec  in number,
                               lc_ind_t  out char);

  -----------------------------------------------------------------------  
  procedure sp_cr_es_judicial(pn_pgcodc in number,
                              pn_modc   in number,
                              pn_succ   in number,
                              pn_monc   in number,
                              pn_papc   in number,
                              pn_ctac   in number,
                              pn_opec   in number,
                              pn_sopec  in number,
                              pn_topec  in number,
                              lc_ind_t  out char);
  -----------------------------------------------------------------------  
  procedure sp_cr_insert_log_voucher(pn_pgcod  in number,
                                     pn_itsuc  in number,
                                     pn_itmod  in number,
                                     pn_ittran in number,
                                     pn_itnrel in number,
                                     pn_itord  in number,
                                     pn_itfcon in date,
                                     pv_flgcan in varchar2,
                                     pv_flgimp in varchar2,
                                     pv_observ in varchar2,
                                     pv_user   in varchar2);
  -----------------------------------------------------------------------  
  procedure sp_cr_insert_log_impresion(pn_pgcod  in number,
                                       pn_itsuc  in number,
                                       pn_itmod  in number,
                                       pn_ittran in number,
                                       pn_itnrel in number,
                                       pn_itord  in number,
                                       pn_pais   in number,
                                       pn_petdoc in number,
                                       pv_pendoc in varchar2,
                                       pv_user   in varchar2,
                                       pv_flag   out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Crd99_CNA(pn_pgcod  in number,
                                  pn_itsuc  in number,
                                  pn_itmod  in number,
                                  pn_ittran in number,
                                  pn_itnrel in number,
                                  pn_fecpro in date,
                                  pn_coderr out number,
                                  lv_flgCan out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_Todos_Aval99_CNA(pn_pgcod  in number,
                                   pn_itsuc  in number,
                                   pn_itmod  in number,
                                   pn_ittran in number,
                                   pn_itnrel in number,
                                   pn_fecpro in date,
                                   pn_coderr out number,
                                   lv_flgCan out varchar2);

  -----------------------------------------------------------------------
  --apachecoh 2023.01.19
  procedure sp_cr_anular_impr_CNA(pn_pgcodc in number,
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number,
                                  pn_ctac   in number,
                                  pn_opec   in number,
                                  pn_sopec  in number,
                                  pn_topec  in number,
                                  pv_user   in varchar2,
                                  pn_coderr out number,
                                  pn_msgerr out varchar2);

  -----------------------------------------------------------------------
  procedure sp_cr_corresponde_CNA(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_validar_credito_N(pn_modc   in number,
                                    pn_ctac   in number,
                                    pn_opec   in number,
                                    pv_cancel out varchar2,
                                    pv_estado out varchar2,
                                    pd_cancel out date,
                                    pn_estado out number);
  -----------------------------------------------------------------------
  procedure sp_cr_es_castig_judic_venta(pn_pais  in number,
                                        pn_tdoc  in number,
                                        pn_ndoc  in varchar2,
                                        pv_usua  in varchar2,
                                        pd_fecha in date,
                                        pn_cerr  out number,
                                        pv_merr  out varchar2);

end PQ_CR_VALI_CRED_CANC;
/

create or replace package body PQ_CR_VALI_CRED_CANC is
  procedure sp_cr_ins_cred_canc(pn_pgcodt  in number,
                                pn_suct    in number,
                                pn_modt    in number,
                                pn_trant   in number,
                                pn_itnrelt in number,
                                pn_coderr  out number,
                                pn_msgerr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    pd_itfcont FSD015.itfcon%type;
  
    ln_PGCODC FSD016.pgcod%type;
    ln_MODC   FSD016.modulo%type;
    ln_SUCC   FSD016.itsucd%type;
    ln_MONC   FSD016.moneda%type;
    ln_PAPC   FSD016.papel%type;
    ln_CTAC   FSD016.ctnro%type;
    ln_OPEC   FSD016.itoper%type;
    ln_SOPEC  FSD016.itsubo%type;
    ln_TOPEC  FSD016.ittope%type;
  
    ln_INSTAN xwf700.xwfprcins%type;
  
    lv_pepais fsr008.pepais%type;
    lv_petdoc fsr008.petdoc%type;
    lv_pendoc fsr008.pendoc%type;
  
    lv_penom Fsd001.penom%type;
  
    lv_corr number;
    HORA    varchar2(15);
  
    pv_rutaI varchar(500);
  
    ln_NueImp NUMBER(17);
    ln_NueSta NUMBER;
    ln_cont   NUMBER;
  
    CURSOR LST_ORDINALES(PN_MODULO IN NUMBER, PN_TRANSA IN NUMBER) IS
      select TO_NUMBER(tpimp) ORDINAL
        from fst098
       where pgcod = 1
         and tpcod = 7750
         and tpcorr >= 51
         and tpcorr <= 90
         and tpnro = PN_MODULO
         and TO_NUMBER(TRIM(tpdesc)) = PN_TRANSA;
  
    ln_Ordinal NUMBER;
    lc_FlagOrd CHARACTER(1);
  
    ln_ConEst NUMBER;
  
    ln_capital number(18, 2);
    ln_Interes number(18, 2);
    ln_Mora    number(18, 2);
    ln_Honpro  number(18, 2);
    ln_Gastos  number(18, 2);
    ln_Saldo   number(18, 2);
    ld_fecsis  date;
  
  BEGIN
    pn_coderr := 0;
    HORA      := to_char(sysdate, 'HH24:MI:SS');
    begin
      select f17.pgfape into ld_fecsis from fst017 f17 where pgcod = 1;
    EXCEPTION
      when others then
        null;
    end;
  
    begin
      select COUNT(tpimp)
        into ln_cont
        from fst098
       where pgcod = 1
         and tpcod = 7750
         and tpcorr >= 51
         and tpcorr <= 90
         and tpnro = pn_modt
         and TO_NUMBER(TRIM(tpdesc)) = pn_trant;
    EXCEPTION
      when others then
        ln_cont := 0;
        my_errm := SQLERRM;
    end;
  
    --** obtenermos la clave del credito
    if ln_cont > 0 then
      FOR i IN LST_ORDINALES(pn_modt, pn_trant) LOOP
        pn_coderr  := 0;
        lc_FlagOrd := 'N';
        ln_Ordinal := i.ORDINAL;
      
        --obtener clave del credito
        begin
          select distinct d016.pgcod,
                          d016.modulo,
                          d016.itsucd,
                          d016.moneda,
                          d016.papel,
                          d016.ctnro,
                          d016.itoper,
                          d016.itsubo,
                          d016.ittope,
                          d015.itfcon
            into ln_PGCODC,
                 ln_MODC,
                 ln_SUCC,
                 ln_MONC,
                 ln_PAPC,
                 ln_CTAC,
                 ln_OPEC,
                 ln_SOPEC,
                 ln_TOPEC,
                 pd_itfcont
            from fsd015 d015
            join FSD016 d016
              on d015.pgcod = d016.pgcod
             and d015.itsuc = d016.itsuc
             and d015.itmod = d016.itmod
             and d015.ittran = d016.ittran
             and d015.itnrel = d016.itnrel
           where d015.pgcod = pn_pgcodt
             and d015.itsuc = pn_suct
             and d015.itmod = pn_modt
             and d015.ittran = pn_trant
             and d015.itnrel = pn_itnrelt
             and d016.itord = ln_Ordinal;
        
          lc_FlagOrd := 'S';
        EXCEPTION
          when others then
            pn_coderr := 1;
            pn_msgerr := 'Error en clave de credito (ordinal)';
            my_errm   := SQLERRM;
        end;
      
        if pn_coderr = 0 then
          --obtener estado
          begin
            select d011.scsdo, d011.scstat
              into ln_NueImp, ln_NueSta
              from fsd011 d011
             where d011.pgcod = ln_PGCODC
               and d011.scmod = ln_MODC
               and d011.scsuc = ln_SUCC
               and d011.scmda = ln_MONC
               and d011.scpap = ln_PAPC
               and d011.sccta = ln_CTAC
               and d011.scoper = ln_OPEC
               and d011.scsbop = ln_SOPEC
               and d011.sctope = ln_TOPEC;
          EXCEPTION
            when others then
              pn_coderr := 2;
              pn_msgerr := 'Error estado y saldo 1';
              my_errm   := SQLERRM;
          end;
        END IF;
      
        begin
          SELECT COUNT(tpnro)
            INTO ln_ConEst
            FROM fst098
           WHERE pgcod = 1
             AND tpcod = 7750
             AND tpcorr >= 91
             AND tpcorr <= 100
             AND tpimp = 1
             AND tpnro = ln_NueSta;
        EXCEPTION
          when others then
            ln_ConEst := null;
            my_errm   := SQLERRM;
        end;
      
        PQ_CR_JAQL175.sp_saldo_credito(ln_PGCODC,
                                       ln_CTAC,
                                       ln_MONC,
                                       ln_PAPC,
                                       ln_OPEC,
                                       ln_SOPEC,
                                       ln_MODC,
                                       ln_NueSta,
                                       ln_capital,
                                       ln_Interes,
                                       ln_Mora,
                                       ln_Honpro,
                                       ln_Gastos,
                                       ln_Saldo);
      
        IF pn_coderr = 0 THEN
          --validar estado
          IF ln_NueSta = 99 THEN
            pn_coderr := 0;
          ELSIF ln_Saldo = 0 or ln_Saldo = 0.00 THEN
            pn_coderr := 0;
          ELSIF ln_ConEst > 0 AND (ln_Saldo = 0 or ln_Saldo = 0.00) THEN
            pn_coderr := 0;
          ELSE
            pn_coderr := 3;
            pn_msgerr := 'Error Credito no cancelado';
          end if;
        end if;
      
        EXIT WHEN pn_coderr = 0 AND lc_FlagOrd = 'S';
      END LOOP;
    
    else
      begin
        select d016.pgcod,
               d016.modulo,
               d016.itsucd,
               d016.moneda,
               d016.papel,
               d016.ctnro,
               d016.itoper,
               d016.itsubo,
               d016.ittope,
               d015.itfcon
          into ln_PGCODC,
               ln_MODC,
               ln_SUCC,
               ln_MONC,
               ln_PAPC,
               ln_CTAC,
               ln_OPEC,
               ln_SOPEC,
               ln_TOPEC,
               pd_itfcont
          from fsd015 d015
          join FSD016 d016
            on d015.pgcod = d016.pgcod
           and d015.itsuc = d016.itsuc
           and d015.itmod = d016.itmod
           and d015.ittran = d016.ittran
           and d015.itnrel = d016.itnrel
          join FSD010 d010
            on d010.pgcod = d016.pgcod
           and d010.aomod = d016.modulo
           and d010.aosuc = d016.itsucd
           and d010.aomda = d016.moneda
           and d010.aopap = d016.papel
           and d010.aocta = d016.ctnro
           and d010.aooper = d016.itoper
           and d010.aosbop = d016.itsubo
           and d010.aotope = d016.ittope
         where d015.pgcod = pn_pgcodt
           and d015.itsuc = pn_suct
           and d015.itmod = pn_modt
           and d015.ittran = pn_trant
           and d015.itnrel = pn_itnrelt
           and d016.itord = 10
           and d010.aostat = 99;
      EXCEPTION
        when others then
          pn_coderr := 4;
          pn_msgerr := 'Error clave credito';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --** VALIDAR MODULO
    if ln_MODC = 116 then
      pn_coderr := 5;
      pn_msgerr := 'Error modulo - 116';
      my_errm   := SQLERRM;
    end if;
  
    --** instancia
    if pn_coderr = 0 then
      begin
        select xwfprcins
          into ln_INSTAN
          from xwf700 x700
         where x700.xwfempresa = ln_PGCODC
           and x700.xwfmodulo = ln_MODC
           and x700.xwfsucursal = ln_SUCC
           and x700.xwfmoneda = ln_MONC
           and x700.xwfpapel = ln_PAPC
           and x700.xwfcuenta = ln_CTAC
           and x700.xwfoperacion = ln_OPEC
           and x700.xwfsubope = ln_SOPEC
           and x700.xwftipope = ln_TOPEC
           and x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          pn_msgerr := 'Error en instancia';
          ln_INSTAN := 0;
      end;
    end if;
  
    --** titular de la cuenta
    if pn_coderr = 0 then
      begin
        select pepais, petdoc, pendoc
          into lv_pepais, lv_petdoc, lv_pendoc
          from fsr008
         where ctnro = ln_CTAC
           and cttfir = 'T' OFFSET 0 ROWS
         FETCH NEXT 1 ROWS ONLY;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en titular de la cuenta';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --** nombre del titular
    if pn_coderr = 0 then
      begin
        select penom
          into lv_penom
          from Fsd001
         where pepais = lv_pepais
           and petdoc = lv_petdoc
           and pendoc = lv_pendoc;
      
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --** validar duplicidad 
    if pn_coderr = 0 then
      begin
        select 1
          into lv_corr
          from aqpb608 b608
         where b608.AQPB608PGCODC = ln_PGCODC
           and b608.AQPB608MODC = ln_MODC
           and b608.AQPB608SUCC = ln_SUCC
           and b608.AQPB608MONC = ln_MONC
           and b608.AQPB608PAPC = ln_PAPC
           and b608.AQPB608CTAC = ln_CTAC
           and b608.AQPB608OPEC = ln_OPEC
           and b608.AQPB608SOPEC = ln_SOPEC
           and b608.AQPB608TOPEC = ln_TOPEC;
        pn_coderr := 6;
        pn_msgerr := 'Error duplicidad en clave del credito';
      EXCEPTION
        when no_data_found then
          pn_coderr := 0;
        when others then
          pn_coderr := 7;
          pn_msgerr := 'Error duplicidad en el registro';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 0 then
      begin
        pv_rutaI := 'CNA' || to_char(ln_PGCODC) || to_char(ln_MODC) ||
                    to_char(ln_SUCC) || to_char(ln_MONC) ||
                    to_char(ln_PAPC) || to_char(ln_CTAC) ||
                    to_char(ln_OPEC) || to_char(ln_SOPEC) ||
                    to_char(ln_TOPEC) || to_char(lv_pendoc);
      EXCEPTION
        when others then
          pn_msgerr := 'Error al crear la ruta';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --** insertar en la tabla
    if pn_coderr = 0 then
      begin
        insert into aqpb608
          (AQPB608PGCODT,
           AQPB608ITSUC,
           AQPB608ITMOD,
           AQPB608ITTRAN,
           AQPB608ITNREL,
           AQPB608ITFCON,
           AQPB608HORT,
           AQPB608INSTAN,
           AQPB608PGCODC,
           AQPB608MODC,
           AQPB608SUCC,
           AQPB608MONC,
           AQPB608PAPC,
           AQPB608CTAC,
           AQPB608OPEC,
           AQPB608SOPEC,
           AQPB608TOPEC,
           AQPB608NUMDOC,
           AQPB608NOMCLI,
           --AQPB608USU,   AQPB608FEC,    AQPB608HOR,    AQPB608FIMP, 
           AQPB608NOMARC,
           AQPB608PAIS,
           AQPB608TDOC)
        values
          (pn_pgcodt,
           pn_suct,
           pn_modt,
           pn_trant,
           pn_itnrelt,
           pd_itfcont,
           HORA,
           ln_INSTAN,
           ln_PGCODC,
           ln_MODC,
           ln_SUCC,
           ln_MONC,
           ln_PAPC,
           ln_CTAC,
           ln_OPEC,
           ln_SOPEC,
           ln_TOPEC,
           lv_pendoc,
           lv_penom,
           --null, null, null, 'N',
           pv_rutaI,
           lv_pepais,
           lv_petdoc);
      
        pn_msgerr := 'Exito en el registro';
      EXCEPTION
        when others then
          pn_coderr := 8;
          pn_msgerr := 'Error en el registro';
          my_errm   := SQLERRM;
      end;
    end if;
  
  END sp_cr_ins_cred_canc;

  --**********************************************************************************************************--  
  procedure sp_cr_vali_titu_cred_canc_2(pn_pgcodt  in number,
                                        pn_suct    in number,
                                        pn_modt    in number,
                                        pn_trant   in number,
                                        pn_itnrelt in number,
                                        pd_itfcont in date,
                                        pn_pais    in number,
                                        pn_tipdoc  in number,
                                        pv_dni     in varchar2,
                                        
                                        pv_flagt  out varchar2,
                                        pv_flagi  out varchar2,
                                        pn_instan out NUMBER,
                                        pn_pgcodc out NUMBER,
                                        pn_modc   out NUMBER,
                                        pn_succ   out NUMBER,
                                        pn_monc   out NUMBER,
                                        pn_papc   out NUMBER,
                                        pn_ctac   out NUMBER,
                                        pn_opec   out NUMBER,
                                        pn_sopec  out NUMBER,
                                        pn_topec  out NUMBER,
                                        pv_rutaI  out varchar2,
                                        pn_coderr out number,
                                        pn_msgerr out varchar2) is
  
    ln_cta  NUMBER(10);
    lv_per  varchar2(15);
    my_errm VARCHAR2(32000);
    lv_dni  varchar(12);
  
  BEGIN
    pn_coderr := 0;
    pv_flagt  := 'N';
    pv_flagi  := 'N';
  
    if pn_coderr = 0 then
      --obtener la cuenta 
      begin
        select AQPB608CTAC,
               AQPB608FIMP,
               AQPB608INSTAN,
               AQPB608PGCODC,
               AQPB608MODC,
               AQPB608SUCC,
               AQPB608MONC,
               AQPB608PAPC,
               AQPB608CTAC,
               AQPB608OPEC,
               AQPB608SOPEC,
               AQPB608TOPEC,
               AQPB608NOMARC
          into ln_cta,
               pv_flagi,
               pn_instan,
               pn_pgcodc,
               pn_modc,
               pn_succ,
               pn_monc,
               pn_papc,
               pn_ctac,
               pn_opec,
               pn_sopec,
               pn_topec,
               pv_rutaI
          from aqpb608
         where AQPB608PGCODT = pn_pgcodt
           and AQPB608ITSUC = pn_suct
           and AQPB608ITMOD = pn_modt
           and AQPB608ITTRAN = pn_trant
           and AQPB608ITFCON = pd_itfcont
           and AQPB608ITNREL = pn_itnrelt;
      EXCEPTION
        when others then
          pn_coderr := 1;
          pn_msgerr := 'Error en la cuenta';
          pv_flagt  := 'N';
          pv_flagi  := 'N';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --validar titular
    /*if pn_coderr = 0 then
      begin
        lv_dni := trim(pv_DNI);
        select pendoc, 'S'
          into lv_per, pv_flagt
          from fsr008
         where cttfir = 'T'
           and ctnro = pn_ctac
           and pepais = pn_pais
           and petdoc = pn_tipdoc
           and pendoc = rpad(lv_dni, 12);
      EXCEPTION
        when others then
          pn_coderr := 2;
          pn_msgerr := 'No es titular de la cuenta';
          pv_flagt  := 'N';
          pv_flagi  := 'N';
          my_errm   := SQLERRM;
      end;
    end if;*/
  
  END sp_cr_vali_titu_cred_canc_2;

  --**********************************************************************************************************-- 

  procedure sp_cr_datos_consta_2(pn_pgcodc in number,
                                 pn_modc   in number,
                                 pn_succ   in number,
                                 pn_monc   in number,
                                 pn_papc   in number,
                                 pd_ctac   in number,
                                 pv_opec   in number,
                                 pv_sopec  in number,
                                 pv_topec  in number,
                                 pv_instan in number,
                                 pv_user   in varchar2,
                                 pv_NomCli out varchar2,
                                 pv_FecDes out varchar2,
                                 pv_ValDes out varchar2,
                                 pv_FecAct out varchar2,
                                 pv_NunDNI out varchar2,
                                 pn_coderr out number,
                                 pn_msgerr out varchar2) is
  
    my_errm VARCHAR2(32000);
  
    lv_pepais fsr008.pepais%type;
    lv_petdoc fsr008.petdoc%type;
  
    lv_FecDes     FSD010.aofval%type;
    lv_Instan     xwf700.xwfprcins%type;
    lv_tempInstan xwf700.xwfprcins%type;
    lv_MonDes     NUMBER(17, 2);
    lv_EstCan     FSD010.aostat%type;
    lv_EstPar     sng001.sng001ori%type;
  
    lv_SimMon varchar2(8);
  
    lv_anio varchar2(5);
    lv_mes  varchar2(15);
    lv_dia  varchar2(2);
  
    lv_anioA varchar2(5);
    lv_mesA  varchar2(15);
    lv_diaA  varchar2(2);
  
    HORA varchar2(15);
  
    lv_FecAct date;
  
  BEGIN
    pn_coderr := 0;
  
    --** VALIDAR MODULO
    if pn_modc = 116 then
      pn_coderr := 7;
      pn_msgerr := 'Modulo no Permitido';
      my_errm   := SQLERRM;
      DBMS_OUTPUT.put_line('7');
      DBMS_OUTPUT.put_line(my_errm);
    end if;
  
    --nombre del cliente
    if pn_coderr = 0 then
      BEGIN
        select pepais, petdoc, pendoc
          into lv_pepais, lv_petdoc, pv_NunDNI
          from fsr008
         where cttfir = 'T'
           and ctnro = pd_ctac
           and rownum = 1;
      EXCEPTION
        when others then
          pn_coderr := 2;
          pn_msgerr := 'Error en la cuenta de cliente';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
      --apachecoh 2022.10.25 cambio de tabla de consulta de nombre   
      BEGIN
        select trim(PFAPE1) || ' ' || trim(PFAPE2) || ' ' || trim(PFNOM1) || ' ' ||
               trim(PFNOM2)
          into pv_NomCli
          from Fsd002
         where pfpais = lv_pepais
           and pftdoc = lv_petdoc
           and pfndoc = rpad(pv_NunDNI, 12);
      EXCEPTION
        when others then
          BEGIN
            select penom
              into pv_NomCli
              from Fsd001
             where pepais = lv_pepais
               and petdoc = lv_petdoc
               and pendoc = rpad(pv_NunDNI, 12);
          EXCEPTION
            when others then
              pn_coderr := 2;
              pn_msgerr := 'Error en el nombre de cliente';
              my_errm   := SQLERRM;
              DBMS_OUTPUT.put_line(my_errm);
          end;
      end;
    end if;
  
    --***********************
    --fecha y valor del desembolso
    if pn_coderr = 0 then
      begin
      
        /*select min(d016.itsubo), d010.aofval, d010.aoimp, d010.aostat
        into lv_subope_min,   lv_FecDes, lv_MonDes,   lv_EstCan
        from FSD016 d016 --transaccion
        join FSD010 d010 on d010.pgcod = d016.pgcod and d010.aomod = d016.modulo and d010.aosuc  = d016.itsucd and  d010.aomda = d016.moneda --fecha y monto
                        and d010.aopap = d016.papel and d010.aocta = d016.ctnro  and d010.aooper = d016.itoper and d010.aosbop = d016.itsubo
                        and d010.aotope = d016.ittope
        where d010.pgcod = pn_pgcodc and d010.aomod = pn_modc and d010.aosuc  = pn_succ and  d010.aomda = pn_monc
              and d010.aopap = pn_papc and d010.aocta = pd_ctac  and d010.aooper = pv_opec and d010.aosbop = pv_sopec
              and d010.aotope = pv_topec
              and d010.aostat = 99
        group by d010.aofval, d010.aoimp, d010.aostat;*/
      
        select d010.aofval, d010.aoimp, d010.aostat
          into lv_FecDes, lv_MonDes, lv_EstCan
          from FSD010 d010
         where d010.pgcod = pn_pgcodc
           and d010.aomod = pn_modc
           and d010.aosuc = pn_succ
           and d010.aomda = pn_monc
           and d010.aopap = pn_papc
           and d010.aocta = pd_ctac
           and d010.aooper = pv_opec
           and d010.aosbop = 0;
      
        lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
        lv_mes  := trim(to_char(lv_FecDes,
                                'Month',
                                'nls_date_language=spanish'));
        lv_dia  := trim(to_char(lv_FecDes, 'DD'));
      
        pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
      
      EXCEPTION
        when others then
          begin
            select d010.aofval, d010.aoimp, d010.aostat
              into lv_FecDes, lv_MonDes, lv_EstCan
              from FSD010 d010
             where d010.pgcod = pn_pgcodc
               and d010.aomod = pn_modc
               and d010.aosuc = pn_succ
               and d010.aomda = pn_monc
               and d010.aopap = pn_papc
               and d010.aocta = pd_ctac
               and d010.aooper = pv_opec
               and d010.aosbop = pv_sopec
               and d010.aotope = pv_topec
               and d010.aosbop =
                   (select min(d010.aosbop)
                      from FSD010 d010
                     where d010.pgcod = pn_pgcodc
                       and d010.aomod = pn_modc
                       and d010.aosuc = pn_succ
                       and d010.aomda = pn_monc
                       and d010.aopap = pn_papc
                       and d010.aocta = pd_ctac
                       and d010.aooper = pv_opec
                       and d010.aosbop = pv_sopec
                       and d010.aotope = pv_topec);
            --and d010.aostat = 99 and d010.aosbop = 0;
          
            lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
            lv_mes  := trim(to_char(lv_FecDes,
                                    'Month',
                                    'nls_date_language=spanish'));
            lv_dia  := trim(to_char(lv_FecDes, 'DD'));
          
            pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
          
            --valor del desembolso              
            select mosign
              into lv_SimMon
              from Fst005
             where moneda = pn_MONC;
          
            pv_ValDes := lv_SimMon || ' ' ||
                         TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
          EXCEPTION
            when others then
              pn_coderr := 3;
              pn_msgerr := 'Error al obtener la fecha y monto';
              my_errm   := SQLERRM;
              DBMS_OUTPUT.put_line(my_errm);
          end;
      end;
    end if;
  
    if pn_coderr <> 0 and (pn_modc = 200 or pn_modc = 33) then
      begin
        select d010.aofval, d010.aoimp, d010.aostat
          into lv_FecDes, lv_MonDes, lv_EstCan
          from FSD010 d010
         where d010.aocta = pd_ctac
           and d010.aooper = pv_opec
           and d010.aomda = 0
           and d010.aosbop = (select min(d010.aosbop)
                                from FSD010 d010
                               where d010.aocta = pd_ctac
                                 and d010.aooper = pv_opec
                                 and d010.aomda = pn_monc);
      
        lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
        lv_mes  := trim(to_char(lv_FecDes,
                                'Month',
                                'nls_date_language=spanish'));
        lv_dia  := trim(to_char(lv_FecDes, 'DD'));
      
        pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
        pn_coderr := 0;
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al obtener la fecha y monto';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 0 then
      begin
        select x700.xwfprcins
          into lv_Instan
          from xwf700 x700
         where x700.xwfempresa = pn_pgcodc
           and x700.xwfmodulo = pn_modc
           and x700.xwfsucursal = pn_succ
           and x700.xwfmoneda = pn_monc
           and x700.xwfpapel = pn_papc
           and x700.xwfcuenta = pd_ctac
           and x700.xwfoperacion = pv_opec
           and x700.xwfsubope = pv_sopec
           and x700.xwftipope = pv_topec
           and x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al obtener la instancia';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 0 then
      begin
        select g001.sng001ori
          into lv_EstPar
          from sng001 g001
         where g001.sng001inst = lv_Instan;
      EXCEPTION
        when others then
          lv_EstPar := 0;
      end;
    end if;
  
    --si es desembolso parcial
    if pn_coderr = 0 and lv_EstPar = 7 then
      begin
        select g002.sng001inst, sum(g002.sng002mon)
          into lv_tempInstan, lv_MonDes
          from sng002 g002
         where g002.sng001inst = lv_Instan
         group by g002.sng001inst;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TO_CHAR(lv_MonDes, '99999999999999999D99');
      
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al monto (credito parcial)';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --***********************
    --fecha actual 
    begin
      select T017.PGFAPE
        INTO lv_FecAct
        from FST017 T017
       WHERE T017.PGCOD = 1;
      lv_anioA := trim(to_char(lv_FecAct, 'YYYY'));
      lv_mesA  := trim(to_char(lv_FecAct,
                               'Month',
                               'nls_date_language=spanish'));
      lv_diaA  := trim(to_char(lv_FecAct, 'DD'));
    
      pv_FecAct := lv_diaA || ' de ' || lv_mesA || ' del ' || lv_anioA;
    
    EXCEPTION
      when others then
        pn_coderr := 4;
        pn_msgerr := 'Error en fecha actual';
        my_errm   := SQLERRM;
    end;
  
    begin
    
      HORA := to_char(sysdate, 'HH24:MI:SS');
    
      update aqpb608
         set AQPB608USU  = pv_user,
             AQPB608FIMP = 'S',
             AQPB608FEC  = TO_DATE(SYSDATE),
             AQPB608HOR  = HORA
       where AQPB608PGCODC = pn_pgcodc
         and AQPB608MODC = pn_modc
         and AQPB608SUCC = pn_succ
         and AQPB608MONC = pn_monc
         and AQPB608PAPC = pn_papc
         and AQPB608CTAC = pd_ctac
         and AQPB608OPEC = pv_opec
         and AQPB608SOPEC = pv_sopec
         and AQPB608TOPEC = pv_topec;
      commit;
    EXCEPTION
      when others then
        pn_coderr := 9;
        pn_msgerr := 'Error al actualizar';
        my_errm   := SQLERRM;
    end;
  
  END sp_cr_datos_consta_2;

  --**********************************************************************************************************--  
  procedure sp_cr_val_impr_cons_canc(pn_pgcodt  in number,
                                     pn_suct    in number,
                                     pn_modt    in number,
                                     pn_trant   in number,
                                     pn_itnrelt in number,
                                     pd_itfcont in date,
                                     pv_flag    out varchar2,
                                     pn_coderr  out number) is
    my_errm VARCHAR2(32000);
  
  BEGIN
    pn_coderr := 0;
    begin
      select aqpb608fimp
        into pv_flag
        from AQPB608
       where aqpb608pgcodt = pn_pgcodt
         and aqpb608itsuc = pn_suct
         and aqpb608itmod = pn_modt
         and aqpb608ittran = pn_trant
         and aqpb608itnrel = pn_itnrelt
         and aqpb608itfcon = pd_itfcont;
    EXCEPTION
      when others then
        pn_coderr := 1;
        pv_flag   := 'N';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  END sp_cr_val_impr_cons_canc;

  --**********************************************************************************************************--  
  --CONSTANCIAS
  /*procedure sp_cr_gen_rep_cre_canc(pd_fecini  in date,
                                   pd_fecfin  in date,
                                   pn_AgeOri  in number,
                                   pv_usurep  in varchar2,
                                   pn_coderr  out number,
                                   pn_msgerr  out varchar2) is
  CURSOR Cursor_CreCan IS
    select distinct d010.aocta cuenta, d010.aomod modulo, d010.aooper operac, d010.pgcod pgcod
    from fsd010 d010
    where d010.aosuc = pn_AgeOri and d010.aofe99 >= pd_fecini and d010.aofe99 <= pd_fecfin
      and d010.aomod in (select modulo from fst111 where dscod = 50 and modulo != 116);
      
  my_errm VARCHAR2(32000);
  
  ln_aostat number(2);
  ld_aofe99 date;  
  ln_pgcod  number(3);
  ln_aosuc  number(3);
  ln_aomod  number(3);
  ln_aomda  number(4);
  ln_aopap  number(4);
  ln_aocta  number(9);
  ln_aooper number(9);
  ln_aosbop number(3);
  ln_aotope number(3);
             
  lc_nomage VARCHAR2(250);
  lc_usuimp VARCHAR2(10);
  ld_fecimp DATE;
  lc_flaimp VARCHAR2(1);
  lc_nomcli VARCHAR2(250);
  lc_numcre VARCHAR2(30);
  lc_anacar VARCHAR2(250);
  lc_agecan VARCHAR2(250);
  ld_fecrep DATE;
  
  ln_coagca number(3);
  lv_maxFec date;
  
  ln_ConEst number(3);
  
  ln_capital number(18,2);
  ln_Interes number(18,2);
  ln_Mora    number(18,2);
  ln_Honpro  number(18,2);
  ln_Gastos  number(18,2);
  ln_Saldo   number(18,2);
  
  ln_ValSal  number(2) := 0;
  
  lc_ind_t  varchar2(1);
  
  l_fecGuia date;
  lv_flagCan varchar2(1);
  
  ln_ContEst number;
  ln_sld_011 number;
  ln_sld_175 number;
  BEGIN
    pn_msgerr := '';
    l_fecGuia := fn_get_FecGuia();
    --LIMPIAR REGISTROS DE LOS REPORTES    
    begin 
      delete from AQPB609 a
      where a.AQPB609FECCAN >= pd_fecini and a.AQPB609FECCAN <= pd_fecfin and trim(a.AQPB609USUREP) = trim(pv_usurep);
      commit;
    EXCEPTION        
       when others then
         NULL;
    end;
    
    for i in Cursor_CreCan loop
      pn_coderr := 0;
      begin 
        --OPTENER ESTADO 
        sp_cr_dat_credito_2(i.pgcod, i.cuenta, i.operac, i.modulo,
                            ln_pgcod, ln_aosuc, ln_aomod,
                            ln_aomda, ln_aopap, ln_aocta, 
                            ln_aooper, ln_aosbop, ln_aotope);
      EXCEPTION
        when others then
          pn_coderr := 1;
      end;
      
      sp_cr_es_castigado(ln_pgcod, ln_aomod, ln_aosuc,
                         ln_aomda, ln_aopap, ln_aocta,
                         ln_aooper, ln_aosbop, ln_aotope,
                         lc_ind_t);
                         
      if lc_ind_t is null then
        sp_cr_es_judicial(ln_pgcod, ln_aomod, ln_aosuc,
                          ln_aomda, ln_aopap, ln_aocta,
                          ln_aooper, ln_aosbop, ln_aotope,
                          lc_ind_t);
      end if;
      
      if lc_ind_t is null then
        sp_cr_val_estado_2(ln_pgcod, ln_aocta, ln_aomod, 
                           ln_aooper, ln_aosuc, ln_aomda, 
                           ln_aopap, ln_aotope, 
                           l_fecGuia, 
                           lv_flagCan, ld_aofe99, ln_aostat);
        --if ld_aofe99 is null or ld_aofe99 = to_date('1/01/0001','d/mm/yyyy') or ld_aofe99 = to_date('01/01/0001','dd/mm/yyyy') or ld_aofe99 = '1/01/0001' or ld_aofe99 = '01/01/0001' then
        --  begin
        --    select a.aqpb608itfcon
        --      into ld_aofe99
        --      from aqpb608 a 
        --     where a.aqpb608pgcodc = ln_pgcod and a.aqpb608modc = ln_aomod and a.aqpb608succ = ln_aosuc
        --       and a.aqpb608monc = ln_aomda and a.aqpb608papc = ln_aopap and a.aqpb608ctac = ln_aocta 
        --       and a.aqpb608opec = ln_aooper and a.aqpb608sopec = 1 and a.aqpb608topec = ln_aotope
        --      offset 0 rows fetch next 1 rows only;
        --  EXCEPTION        
        --     when others then
        --       NULL;
        --  end;
        --end if;
        
        if lv_flagCan = 'S' then
          --SUCUCRSAL ORIGEN
          begin 
            select trim(t001.scnom)
              into lc_nomage 
            from Fst001 t001 
            where t001.pgcod = ln_pgcod 
              and t001.sucurs = ln_aosuc;
          EXCEPTION
            when others then
              pn_coderr := 2;
          end;
          
          if pn_coderr = 0 then           
            --NOMBRE CLIENTE
            begin 
              select trim(d001.penom)
                into lc_nomcli
              from fsr008 r008
              join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
              where r008.ctnro = ln_aocta and r008.cttfir = 'T';        
            EXCEPTION
              when too_many_rows then
                 select trim(d001.penom)
                   into lc_nomcli
                 from fsr008 r008
                 join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
                 where r008.ctnro = ln_aocta and r008.cttfir = 'T' and rownum=1;            
              when others then
                pn_coderr := 3;
            end;
          end if;
          
          if pn_coderr = 0 then           
            --NUMERO CREDITO
            begin 
              lc_numcre := lpad(ln_aocta, 9, '0') || lpad(ln_aomda, 3, '0') || lpad(ln_aooper, 9, '0');
            EXCEPTION
              when others then
                pn_coderr := 4;
            end;
          end if;
          
          if pn_coderr = 0 then           
            --ANALISTA DE LA CARTERA
            begin 
              select trim(g001.sng001ase) 
                into lc_anacar
              from xwf700 x700 
              join sng001 g001 on g001.sng001inst = x700.xwfprcins
              where x700.xwfempresa   = ln_pgcod  and x700.xwfsucursal  = ln_aosuc and x700.xwfmodulo = ln_aomod
                and x700.xwfmoneda    = ln_aomda and x700.xwfpapel  = ln_aopap   and x700.xwfcuenta    = ln_aocta
                and x700.xwfoperacion = ln_aooper and x700.xwfsubope = ln_aosbop and x700.xwftipope    = ln_aotope
                AND x700.xwfcar3 = '1';
            EXCEPTION
              when others then
                lc_anacar := '';
            end;
          end if;
          
          --FLAG DE IMPRESION
          if pn_coderr = 0 then           
            begin 
              select b608.aqpb608usu, b608.aqpb608fec, b608.aqpb608fimp 
                into lc_usuimp, ld_fecimp, lc_flaimp
              from aqpb608 b608
              where b608.AQPB608PGCODC = ln_pgcod and b608.AQPB608SUCC = ln_aosuc and b608.AQPB608MODC = ln_aomod
                and b608.AQPB608MONC = ln_aomda   and b608.AQPB608PAPC = ln_aopap  and b608.AQPB608CTAC = ln_aocta
                and b608.AQPB608OPEC = ln_aooper   and b608.AQPB608SOPEC = ln_aosbop and b608.AQPB608TOPEC = ln_aotope
                offset 0 rows fetch next 1 rows only;
            EXCEPTION
              when others then
                lc_usuimp := '';
                lc_flaimp := 'N';
            end;
          end if;
          
          if pn_coderr = 0 then 
            -- agencia de cancelacion
            begin 
              SELECT MAX(D601.PPFPAG) 
                into lv_maxFec
              FROM FSD601 D601
              WHERE D601.PGCOD = ln_pgcod AND D601.PPSUC = ln_aosuc AND D601.PPMOD = ln_aomod  
                AND D601.PPMDA = ln_aomda AND D601.PPPAP = ln_aopap AND D601.PPCTA = ln_aocta
                AND D601.PPOPER = ln_aooper AND D601.PPSBOP = ln_aosbop AND D601.PPTOPE = ln_aotope;
            EXCEPTION         
               when others then
                 NULL;
            end;
            
            begin
              SELECT D602.D602SU
                Into ln_coagca
              FROM FSD602 D602
              WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
              AND D602.PPFPAG = lv_maxFec;
            EXCEPTION
              when too_many_rows then
                SELECT D602.D602SU
                  Into ln_coagca
                FROM FSD602 D602
                WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                  AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                  AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
                  AND D602.PPFPAG = lv_maxFec AND ROWNUM = 1;
              when others then
  
                begin
                  select distinct d015.itsuc
                    into ln_coagca
                    from fsd015 d015, fsd016 d016
                   where d015.pgcod = d016.pgcod
                     and d015.itsuc = d016.itsuc
                     and d015.itmod = d016.itmod
                     and d015.ittran = d016.ittran
                     and d015.itnrel = d016.itnrel
                     and d016.ctnro = ln_aocta
                     and d016.itoper = ln_aooper
                     and d016.modulo = ln_aomod
                     and d016.pgcod = ln_pgcod
                     and d016.itsucd = ln_aosuc
                     and d016.papel = ln_aopap
                     and d016.moneda = ln_aomda
                     and d016.itsubo = ln_aosbop
                     and d016.ittope = ln_aotope;
                EXCEPTION
                  when too_many_rows then
                    select distinct d015.itsuc
                      into ln_coagca
                      from fsd015 d015, fsd016 d016
                     where d015.pgcod  = d016.pgcod
                       and d015.itsuc  = d016.itsuc
                       and d015.itmod  = d016.itmod
                       and d015.ittran = d016.ittran
                       and d015.itnrel = d016.itnrel
                       and d016.ctnro  = ln_aocta
                       and d016.itoper = ln_aooper
                       and d016.modulo = ln_aomod
                       and d016.pgcod  = ln_pgcod
                       and d016.itsucd = ln_aosuc
                       and d016.papel  = ln_aopap
                       and d016.moneda = ln_aomda
                       and d016.itsubo = ln_aosbop
                       and d016.ittope = ln_aotope
                       and d015.itfcon = lv_maxFec
                       AND ROWNUM = 1;
                  when others then
                    NULL;
                end;
                
            end;
            
            begin 
              select trim(t001.scnom)
                into lc_agecan
              from Fst001 t001 
              where t001.pgcod = ln_pgcod and t001.sucurs = ln_coagca;
            EXCEPTION
              when others then
                lc_agecan := '';
            end;
            lc_agecan := NVL(lc_agecan, '');
          end if ; 
          
          begin 
            select t017.pgfape 
              into ld_fecrep
            from fst017 t017 where pgcod = 1;
          EXCEPTION
            when others then
              ld_fecrep := '';
          end;
          
          begin 
            insert into aqpb609 (AQPB609NOMAGE,
                                 AQPB609CODAGE,
                                 AQPB609USUIMP,
                                 AQPB609FECIMP,
                                 AQPB609FLAIMP,
                                 AQPB609NOMCLI,
                                 AQPB609NUMCRE,
                                 AQPB609ANACAR,
                                 AQPB609AGECAN,
                                 AQPB609FECCAN,
                                 AQPB609PGCOD,
                                 AQPB609MODULO,
                                 AQPB609SUCURS,
                                 AQPB609MONEDA,
                                 AQPB609PAPEL,
                                 AQPB609CUENTA,
                                 AQPB609OPERAC,
                                 AQPB609SUBOPE,
                                 AQPB609TIPOPE,
                                 AQPB609FECREP,
                                 AQPB609USUREP,
                                 AQPB609TIPCON)
                         values (lc_nomage,
                                 ln_aosuc,
                                 lc_usuimp,
                                 ld_fecimp,
                                 lc_flaimp,
                                 lc_nomcli,
                                 lc_numcre,
                                 lc_anacar,
                                 lc_agecan,
                                 ld_aofe99,
                                 ln_pgcod,
                                 ln_aosuc,
                                 ln_aomod,
                                 ln_aomda,
                                 ln_aopap, 
                                 ln_aocta,
                                 ln_aooper,
                                 ln_aosbop,
                                 ln_aotope,
                                 ld_fecrep,
                                 pv_usurep,
                                 'CON');
            commit;
          EXCEPTION         
             when others then
               my_errm := SQLERRM;
               NULL;
          end;
        else
          ln_ContEst := fn_verificar_estados(ln_aostat);
          if ln_ContEst > 0 then
            ln_sld_011 := fn_get_saldo_fsd011(ln_pgcod,ln_aomod,ln_aosuc,
                                              ln_aomda,ln_aopap,ln_aocta,
                                              ln_aooper,ln_aosbop,ln_aotope);
            if ln_sld_011 = 0 then
              begin 
                select trim(t001.scnom)
                  into lc_nomage 
                from Fst001 t001 
                where t001.pgcod = ln_pgcod 
                  and t001.sucurs = ln_aosuc;
              EXCEPTION
                when others then
                  pn_coderr := 2;
              end;
              
              if pn_coderr = 0 then           
                --NOMBRE CLIENTE
                begin 
                  select trim(d001.penom)
                    into lc_nomcli
                  from fsr008 r008
                  join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
                  where r008.ctnro = ln_aocta and r008.cttfir = 'T';        
                EXCEPTION
                  when too_many_rows then
                     select trim(d001.penom)
                       into lc_nomcli
                     from fsr008 r008
                     join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
                     where r008.ctnro = ln_aocta and r008.cttfir = 'T' and rownum=1;            
                  when others then
                    pn_coderr := 3;
                end;
              end if;
              
              if pn_coderr = 0 then           
                --NUMERO CREDITO
                begin 
                  lc_numcre := lpad(ln_aocta, 9, '0') || lpad(ln_aomda, 3, '0') || lpad(ln_aooper, 9, '0');
                EXCEPTION
                  when others then
                    pn_coderr := 4;
                end;
              end if;
              
              if pn_coderr = 0 then           
                --ANALISTA DE LA CARTERA
                begin 
                  select trim(g001.sng001ase) 
                    into lc_anacar
                  from xwf700 x700 
                  join sng001 g001 on g001.sng001inst = x700.xwfprcins
                  where x700.xwfempresa   = ln_pgcod  and x700.xwfsucursal  = ln_aosuc and x700.xwfmodulo = ln_aomod
                    and x700.xwfmoneda    = ln_aomda and x700.xwfpapel  = ln_aopap   and x700.xwfcuenta    = ln_aocta
                    and x700.xwfoperacion = ln_aooper and x700.xwfsubope = ln_aosbop and x700.xwftipope    = ln_aotope
                    AND x700.xwfcar3 = '1';
                EXCEPTION
                  when others then
                    lc_anacar := '';
                end;
              end if;
              
              --FLAG DE IMPRESION
              if pn_coderr = 0 then           
                begin 
                  select b608.aqpb608usu, b608.aqpb608fec, b608.aqpb608fimp 
                    into lc_usuimp, ld_fecimp, lc_flaimp
                  from aqpb608 b608
                  where b608.AQPB608PGCODC = ln_pgcod and b608.AQPB608SUCC = ln_aosuc and b608.AQPB608MODC = ln_aomod
                    and b608.AQPB608MONC = ln_aomda   and b608.AQPB608PAPC = ln_aopap  and b608.AQPB608CTAC = ln_aocta
                    and b608.AQPB608OPEC = ln_aooper   and b608.AQPB608SOPEC = ln_aosbop and b608.AQPB608TOPEC = ln_aotope
                  offset 0 rows fetch next 1 rows only;
                EXCEPTION
                  when others then
                    lc_usuimp := '';
                    lc_flaimp := 'N';
                end;
              end if;
              
              if pn_coderr = 0 then 
                -- agencia de cancelacion
                begin 
                  SELECT MAX(D601.PPFPAG) 
                    into lv_maxFec
                  FROM FSD601 D601
                  WHERE D601.PGCOD = ln_pgcod AND D601.PPSUC = ln_aosuc AND D601.PPMOD = ln_aomod  
                    AND D601.PPMDA = ln_aomda AND D601.PPPAP = ln_aopap AND D601.PPCTA = ln_aocta
                    AND D601.PPOPER = ln_aooper AND D601.PPSBOP = ln_aosbop AND D601.PPTOPE = ln_aotope;
                EXCEPTION         
                   when others then
                     NULL;
                end;
                
                begin
                  SELECT D602.D602SU
                    Into ln_coagca
                  FROM FSD602 D602
                  WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                    AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                    AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
                  AND D602.PPFPAG = lv_maxFec;
                EXCEPTION
                  when too_many_rows then
                    SELECT D602.D602SU
                      Into ln_coagca
                    FROM FSD602 D602
                    WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                      AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                      AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
                      AND D602.PPFPAG = lv_maxFec AND ROWNUM = 1;
                  when others then
  
                    begin
                      select distinct d015.itsuc
                        into ln_coagca
                        from fsd015 d015, fsd016 d016
                       where d015.pgcod = d016.pgcod
                         and d015.itsuc = d016.itsuc
                         and d015.itmod = d016.itmod
                         and d015.ittran = d016.ittran
                         and d015.itnrel = d016.itnrel
                         and d016.ctnro = ln_aocta
                         and d016.itoper = ln_aooper
                         and d016.modulo = ln_aomod
                         and d016.pgcod = ln_pgcod
                         and d016.itsucd = ln_aosuc
                         and d016.papel = ln_aopap
                         and d016.moneda = ln_aomda
                         and d016.itsubo = ln_aosbop
                         and d016.ittope = ln_aotope;
                    EXCEPTION
                      when too_many_rows then
                        select distinct d015.itsuc
                          into ln_coagca
                          from fsd015 d015, fsd016 d016
                         where d015.pgcod  = d016.pgcod
                           and d015.itsuc  = d016.itsuc
                           and d015.itmod  = d016.itmod
                           and d015.ittran = d016.ittran
                           and d015.itnrel = d016.itnrel
                           and d016.ctnro  = ln_aocta
                           and d016.itoper = ln_aooper
                           and d016.modulo = ln_aomod
                           and d016.pgcod  = ln_pgcod
                           and d016.itsucd = ln_aosuc
                           and d016.papel  = ln_aopap
                           and d016.moneda = ln_aomda
                           and d016.itsubo = ln_aosbop
                           and d016.ittope = ln_aotope
                           and d015.itfcon = lv_maxFec
                           AND ROWNUM = 1;
                      when others then
                        NULL;
                    end;
                    
                end;
                
                begin 
                  select trim(t001.scnom)
                    into lc_agecan
                  from Fst001 t001 
                  where t001.pgcod = ln_pgcod and t001.sucurs = ln_coagca;
                EXCEPTION
                  when others then
                    lc_agecan := '';
                end;
                lc_agecan := NVL(lc_agecan, '');
              end if ; 
              
              begin 
                select t017.pgfape 
                  into ld_fecrep
                from fst017 t017 where pgcod = 1;
              EXCEPTION
                when others then
                  ld_fecrep := '';
              end;
              
              begin 
                insert into aqpb609 (AQPB609NOMAGE,
                                     AQPB609CODAGE,
                                     AQPB609USUIMP,
                                     AQPB609FECIMP,
                                     AQPB609FLAIMP,
                                     AQPB609NOMCLI,
                                     AQPB609NUMCRE,
                                     AQPB609ANACAR,
                                     AQPB609AGECAN,
                                     AQPB609FECCAN,
                                     AQPB609PGCOD,
                                     AQPB609MODULO,
                                     AQPB609SUCURS,
                                     AQPB609MONEDA,
                                     AQPB609PAPEL,
                                     AQPB609CUENTA,
                                     AQPB609OPERAC,
                                     AQPB609SUBOPE,
                                     AQPB609TIPOPE,
                                     AQPB609FECREP,
                                     AQPB609USUREP,
                                     AQPB609TIPCON)
                             values (lc_nomage,
                                     ln_aosuc,
                                     lc_usuimp,
                                     ld_fecimp,
                                     lc_flaimp,
                                     lc_nomcli,
                                     lc_numcre,
                                     lc_anacar,
                                     lc_agecan,
                                     ld_aofe99,
                                     ln_pgcod,
                                     ln_aosuc,
                                     ln_aomod,
                                     ln_aomda,
                                     ln_aopap, 
                                     ln_aocta,
                                     ln_aooper,
                                     ln_aosbop,
                                     ln_aotope,
                                     ld_fecrep,
                                     pv_usurep,
                                     'CON');
                commit;
              EXCEPTION         
                 when others then
                   my_errm := SQLERRM;
                   NULL;
              end;
            else
              ln_sld_175 := fn_get_saldo_JAQL175(ln_pgcod,ln_aomod,ln_aosuc,
                                                 ln_aomda,ln_aopap,ln_aocta,
                                                 ln_aooper,ln_aosbop,ln_aotope,
                                                 ln_aostat);
              if ln_sld_175 = 0 then
                begin 
                  select trim(t001.scnom)
                    into lc_nomage 
                  from Fst001 t001 
                  where t001.pgcod = ln_pgcod 
                    and t001.sucurs = ln_aosuc;
                EXCEPTION
                  when others then
                    pn_coderr := 2;
                end;
                
                if pn_coderr = 0 then           
                  --NOMBRE CLIENTE
                  begin 
                    select trim(d001.penom)
                      into lc_nomcli
                    from fsr008 r008
                    join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
                    where r008.ctnro = ln_aocta and r008.cttfir = 'T';        
                  EXCEPTION
                    when too_many_rows then
                       select trim(d001.penom)
                         into lc_nomcli
                       from fsr008 r008
                       join Fsd001 d001 on d001.pepais = r008.pepais and d001.petdoc = r008.petdoc and d001.pendoc = r008.pendoc
                       where r008.ctnro = ln_aocta and r008.cttfir = 'T' and rownum=1;            
                    when others then
                      pn_coderr := 3;
                  end;
                end if;
                
                if pn_coderr = 0 then           
                  --NUMERO CREDITO
                  begin 
                    lc_numcre := lpad(ln_aocta, 9, '0') || lpad(ln_aomda, 3, '0') || lpad(ln_aooper, 9, '0');
                  EXCEPTION
                    when others then
                      pn_coderr := 4;
                  end;
                end if;
                
                if pn_coderr = 0 then           
                  --ANALISTA DE LA CARTERA
                  begin 
                    select trim(g001.sng001ase) 
                      into lc_anacar
                    from xwf700 x700 
                    join sng001 g001 on g001.sng001inst = x700.xwfprcins
                    where x700.xwfempresa   = ln_pgcod  and x700.xwfsucursal  = ln_aosuc and x700.xwfmodulo = ln_aomod
                      and x700.xwfmoneda    = ln_aomda and x700.xwfpapel  = ln_aopap   and x700.xwfcuenta    = ln_aocta
                      and x700.xwfoperacion = ln_aooper and x700.xwfsubope = ln_aosbop and x700.xwftipope    = ln_aotope
                      AND x700.xwfcar3 = '1';
                  EXCEPTION
                    when others then
                      lc_anacar := '';
                  end;
                end if;
                
                --FLAG DE IMPRESION
                if pn_coderr = 0 then           
                  begin 
                    select b608.aqpb608usu, b608.aqpb608fec, b608.aqpb608fimp 
                      into lc_usuimp, ld_fecimp, lc_flaimp
                    from aqpb608 b608
                    where b608.AQPB608PGCODC = ln_pgcod and b608.AQPB608SUCC = ln_aosuc and b608.AQPB608MODC = ln_aomod
                      and b608.AQPB608MONC = ln_aomda   and b608.AQPB608PAPC = ln_aopap  and b608.AQPB608CTAC = ln_aocta
                      and b608.AQPB608OPEC = ln_aooper   and b608.AQPB608SOPEC = ln_aosbop and b608.AQPB608TOPEC = ln_aotope
                    offset 0 rows fetch next 1 rows only;
                  EXCEPTION
                    when others then
                      lc_usuimp := '';
                      lc_flaimp := 'N';
                  end;
                end if;
                
                if pn_coderr = 0 then 
                  -- agencia de cancelacion
                  begin 
                    SELECT MAX(D601.PPFPAG) 
                      into lv_maxFec
                    FROM FSD601 D601
                    WHERE D601.PGCOD = ln_pgcod AND D601.PPSUC = ln_aosuc AND D601.PPMOD = ln_aomod  
                      AND D601.PPMDA = ln_aomda AND D601.PPPAP = ln_aopap AND D601.PPCTA = ln_aocta
                      AND D601.PPOPER = ln_aooper AND D601.PPSBOP = ln_aosbop AND D601.PPTOPE = ln_aotope;
                  EXCEPTION         
                     when others then
                       NULL;
                  end;
                  
                  begin
                    SELECT D602.D602SU
                      Into ln_coagca
                    FROM FSD602 D602
                    WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                      AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                      AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
                    AND D602.PPFPAG = lv_maxFec;
                  EXCEPTION
                    when too_many_rows then
                      SELECT D602.D602SU
                        Into ln_coagca
                      FROM FSD602 D602
                      WHERE D602.PGCOD = ln_pgcod AND D602.PPSUC = ln_aosuc AND D602.PPMOD = ln_aomod
                        AND D602.PPMDA = ln_aomda AND D602.PPPAP = ln_aopap AND D602.PPCTA = ln_aocta
                        AND D602.PPOPER = ln_aooper AND D602.PPSBOP = ln_aosbop AND D602.PPTOPE = ln_aotope
                        AND D602.PPFPAG = lv_maxFec AND ROWNUM = 1;
                    when others then
  
                      begin
                        select distinct d015.itsuc
                          into ln_coagca
                          from fsd015 d015, fsd016 d016
                         where d015.pgcod = d016.pgcod
                           and d015.itsuc = d016.itsuc
                           and d015.itmod = d016.itmod
                           and d015.ittran = d016.ittran
                           and d015.itnrel = d016.itnrel
                           and d016.ctnro = ln_aocta
                           and d016.itoper = ln_aooper
                           and d016.modulo = ln_aomod
                           and d016.pgcod = ln_pgcod
                           and d016.itsucd = ln_aosuc
                           and d016.papel = ln_aopap
                           and d016.moneda = ln_aomda
                           and d016.itsubo = ln_aosbop
                           and d016.ittope = ln_aotope;
                      EXCEPTION
                        when too_many_rows then
                          select distinct d015.itsuc
                            into ln_coagca
                            from fsd015 d015, fsd016 d016
                           where d015.pgcod  = d016.pgcod
                             and d015.itsuc  = d016.itsuc
                             and d015.itmod  = d016.itmod
                             and d015.ittran = d016.ittran
                             and d015.itnrel = d016.itnrel
                             and d016.ctnro  = ln_aocta
                             and d016.itoper = ln_aooper
                             and d016.modulo = ln_aomod
                             and d016.pgcod  = ln_pgcod
                             and d016.itsucd = ln_aosuc
                             and d016.papel  = ln_aopap
                             and d016.moneda = ln_aomda
                             and d016.itsubo = ln_aosbop
                             and d016.ittope = ln_aotope
                             and d015.itfcon = lv_maxFec
                             AND ROWNUM = 1;
                        when others then
                          NULL;
                      end;
                      
                  end;
                  
                  begin 
                    select trim(t001.scnom)
                      into lc_agecan
                    from Fst001 t001 
                    where t001.pgcod = ln_pgcod and t001.sucurs = ln_coagca;
                  EXCEPTION
                    when others then
                      lc_agecan := '';
                  end;
                  lc_agecan := NVL(lc_agecan, '');
                end if ; 
                
                begin 
                  select t017.pgfape 
                    into ld_fecrep
                  from fst017 t017 where pgcod = 1;
                EXCEPTION
                  when others then
                    ld_fecrep := '';
                end;
                
                begin 
                  insert into aqpb609 (AQPB609NOMAGE,
                                       AQPB609CODAGE,
                                       AQPB609USUIMP,
                                       AQPB609FECIMP,
                                       AQPB609FLAIMP,
                                       AQPB609NOMCLI,
                                       AQPB609NUMCRE,
                                       AQPB609ANACAR,
                                       AQPB609AGECAN,
                                       AQPB609FECCAN,
                                       AQPB609PGCOD,
                                       AQPB609MODULO,
                                       AQPB609SUCURS,
                                       AQPB609MONEDA,
                                       AQPB609PAPEL,
                                       AQPB609CUENTA,
                                       AQPB609OPERAC,
                                       AQPB609SUBOPE,
                                       AQPB609TIPOPE,
                                       AQPB609FECREP,
                                       AQPB609USUREP,
                                       AQPB609TIPCON)
                               values (lc_nomage,
                                       ln_aosuc,
                                       lc_usuimp,
                                       ld_fecimp,
                                       lc_flaimp,
                                       lc_nomcli,
                                       lc_numcre,
                                       lc_anacar,
                                       lc_agecan,
                                       ld_aofe99,
                                       ln_pgcod,
                                       ln_aosuc,
                                       ln_aomod,
                                       ln_aomda,
                                       ln_aopap, 
                                       ln_aocta,
                                       ln_aooper,
                                       ln_aosbop,
                                       ln_aotope,
                                       ld_fecrep,
                                       pv_usurep,
                                       'CON');
                  commit;
                EXCEPTION         
                   when others then
                     my_errm := SQLERRM;
                     NULL;
                end;
              end if;
            end if;
          end if;
        end if;
  
      end if;      
    end loop;   
  END sp_cr_gen_rep_cre_canc;*/

  procedure sp_cr_gen_rep_cre_canc(pd_fecini in date,
                                   pd_fecfin in date,
                                   pn_AgeOri in number,
                                   pv_usurep in varchar2,
                                   pn_coderr out number,
                                   pn_msgerr out varchar2) is
    CURSOR Cursor_CreCan IS
      select distinct d010.aocta  cuenta,
                      d010.aomod  modulo,
                      d010.aooper operac,
                      d010.pgcod  pgcod
        from fsd010 d010
       where d010.aosuc = pn_AgeOri
         and d010.aofe99 >= pd_fecini
         and d010.aofe99 <= pd_fecfin
         and d010.aomod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo != 116);
  
    my_errm VARCHAR2(32000);
  
    ln_aostat number(2);
    ld_aofe99 date;
    ln_pgcod  number(3);
    ln_aosuc  number(3);
    ln_aomod  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    lc_nomage VARCHAR2(250);
    lc_usuimp VARCHAR2(10);
    ld_fecimp DATE;
    lc_flaimp VARCHAR2(1);
    lc_nomcli VARCHAR2(250);
    lc_numcre VARCHAR2(30);
    lc_anacar VARCHAR2(250);
    lc_agecan VARCHAR2(250);
    ld_fecrep DATE;
  
    ln_coagca number(3);
    lv_maxFec date;
  
    ln_ConEst number(3);
  
    ln_capital number(18, 2);
    ln_Interes number(18, 2);
    ln_Mora    number(18, 2);
    ln_Honpro  number(18, 2);
    ln_Gastos  number(18, 2);
    ln_Saldo   number(18, 2);
  
    ln_ValSal number(2) := 0;
  
  BEGIN
    pn_msgerr := '';
    --LIMPIAR REGISTROS DE LOS REPORTES    
    begin
      delete from AQPB609 a
       where a.AQPB609FECCAN >= pd_fecini
         and a.AQPB609FECCAN <= pd_fecfin
         and trim(a.AQPB609USUREP) = trim(pv_usurep);
      commit;
    EXCEPTION
      when others then
        NULL;
    end;
  
    for i in Cursor_CreCan loop
      pn_coderr := 0;
      --OPTENER ESTADO Y CLAVE DEL CREDITO
      begin
        select d010.aostat,
               d010.aofe99,
               d010.pgcod,
               d010.aosuc,
               d010.aomod,
               d010.aomda,
               d010.aopap,
               d010.aocta,
               d010.aooper,
               d010.aosbop,
               d010.aotope
          into ln_aostat,
               ld_aofe99,
               ln_pgcod,
               ln_aosuc,
               ln_aomod,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          from fsd010 d010
         where d010.pgcod = i.pgcod
           and d010.aocta = i.cuenta
           and d010.aomod = i.modulo
           and d010.aooper = i.operac
           and d010.aofe99 >= pd_fecini
           and rownum = 1
         order by Aosbop desc;
      EXCEPTION
        when others then
          pn_coderr := 1;
      end;
    
      --si no es 99
      begin
        SELECT COUNT(tpnro)
          INTO ln_ConEst
          FROM fst098
         WHERE pgcod = 1
           AND tpcod = 7750
           AND tpcorr >= 91
           AND tpcorr <= 100
           AND tpimp = 1
           AND tpnro = ln_aostat;
      EXCEPTION
        when others then
          null;
      end;
    
      if ln_ConEst > 0 then
        begin
          PQ_CR_JAQL175.sp_saldo_credito(ln_pgcod,
                                         ln_aocta,
                                         ln_aomda,
                                         ln_aopap,
                                         ln_aooper,
                                         ln_aosbop,
                                         ln_aomod,
                                         ln_aostat,
                                         ln_capital,
                                         ln_Interes,
                                         ln_Mora,
                                         ln_Honpro,
                                         ln_Gastos,
                                         ln_Saldo);
          --validar estado
          IF ln_aostat = 99 THEN
            pn_coderr := 0;
            ln_ValSal := 0;
          ELSIF ln_Saldo = 0 or ln_Saldo = 0.00 THEN
            pn_coderr := 0;
            ln_ValSal := 0;
          ELSIF ln_ConEst > 0 AND (ln_Saldo = 0 or ln_Saldo = 0.00) THEN
            pn_coderr := 0;
            ln_ValSal := 0;
          ELSE
            pn_coderr := 14;
            ln_ValSal := 1;
          end if;
        
        EXCEPTION
          when others then
            null;
        end;
      end if;
    
      -- VALIDAR ESTADO
      if ln_aostat = 99 and pn_coderr = 0 and ln_ValSal = 0 then
        --SUCUCRSAL ORIGEN
        begin
          select trim(t001.scnom)
            into lc_nomage
            from Fst001 t001
           where t001.pgcod = ln_pgcod
             and t001.sucurs = ln_aosuc;
        EXCEPTION
          when others then
            pn_coderr := 2;
        end;
      
        if pn_coderr = 0 then
          --NOMBRE CLIENTE
          begin
            select trim(d001.penom)
              into lc_nomcli
              from fsr008 r008
              join Fsd001 d001
                on d001.pepais = r008.pepais
               and d001.petdoc = r008.petdoc
               and d001.pendoc = r008.pendoc
             where r008.ctnro = ln_aocta
               and r008.cttfir = 'T';
          EXCEPTION
            when too_many_rows then
              select trim(d001.penom)
                into lc_nomcli
                from fsr008 r008
                join Fsd001 d001
                  on d001.pepais = r008.pepais
                 and d001.petdoc = r008.petdoc
                 and d001.pendoc = r008.pendoc
               where r008.ctnro = ln_aocta
                 and r008.cttfir = 'T'
                 and rownum = 1;
            when others then
              pn_coderr := 3;
          end;
        end if;
      
        if pn_coderr = 0 then
          --NUMERO CREDITO
          begin
            lc_numcre := lpad(ln_aocta, 9, '0') || lpad(ln_aomda, 3, '0') ||
                         lpad(ln_aooper, 9, '0');
          EXCEPTION
            when others then
              pn_coderr := 4;
          end;
        end if;
      
        if pn_coderr = 0 then
          --ANALISTA DE LA CARTERA
          begin
            select trim(g001.sng001ase)
              into lc_anacar
              from xwf700 x700
              join sng001 g001
                on g001.sng001inst = x700.xwfprcins
             where x700.xwfempresa = ln_pgcod
               and x700.xwfsucursal = ln_aosuc
               and x700.xwfmodulo = ln_aomod
               and x700.xwfmoneda = ln_aomda
               and x700.xwfpapel = ln_aopap
               and x700.xwfcuenta = ln_aocta
               and x700.xwfoperacion = ln_aooper
               and x700.xwfsubope = ln_aosbop
               and x700.xwftipope = ln_aotope
               AND x700.xwfcar3 = '1';
          EXCEPTION
            when others then
              lc_anacar := '';
          end;
        end if;
      
        if pn_coderr = 0 then
          --FLAG DE IMPRESION
          begin
            select b608.aqpb608usu, b608.aqpb608fec, b608.aqpb608fimp
              into lc_usuimp, ld_fecimp, lc_flaimp
              from aqpb608 b608
             where b608.AQPB608PGCODC = ln_pgcod
               and b608.AQPB608SUCC = ln_aosuc
               and b608.AQPB608MODC = ln_aomod
               and b608.AQPB608MONC = ln_aomda
               and b608.AQPB608PAPC = ln_aopap
               and b608.AQPB608CTAC = ln_aocta
               and b608.AQPB608OPEC = ln_aooper
               and b608.AQPB608SOPEC = ln_aosbop
               and b608.AQPB608TOPEC = ln_aotope;
          EXCEPTION
            when others then
              lc_usuimp := '';
              lc_flaimp := 'N';
          end;
        end if;
      
        if pn_coderr = 0 then
          -- agencia de cancelacion
          begin
            SELECT MAX(D601.PPFPAG)
              into lv_maxFec
              FROM FSD601 D601
             WHERE D601.PGCOD = ln_pgcod
               AND D601.PPSUC = ln_aosuc
               AND D601.PPMOD = ln_aomod
               AND D601.PPMDA = ln_aomda
               AND D601.PPPAP = ln_aopap
               AND D601.PPCTA = ln_aocta
               AND D601.PPOPER = ln_aooper
               AND D601.PPSBOP = ln_aosbop
               AND D601.PPTOPE = ln_aotope;
          EXCEPTION
            when others then
              NULL;
          end;
        
          begin
            SELECT D602.D602SU
              Into ln_coagca
              FROM FSD602 D602
             WHERE D602.PGCOD = ln_pgcod
               AND D602.PPSUC = ln_aosuc
               AND D602.PPMOD = ln_aomod
               AND D602.PPMDA = ln_aomda
               AND D602.PPPAP = ln_aopap
               AND D602.PPCTA = ln_aocta
               AND D602.PPOPER = ln_aooper
               AND D602.PPSBOP = ln_aosbop
               AND D602.PPTOPE = ln_aotope
               AND D602.PPFPAG = lv_maxFec;
          EXCEPTION
            when too_many_rows then
              SELECT D602.D602SU
                Into ln_coagca
                FROM FSD602 D602
               WHERE D602.PGCOD = ln_pgcod
                 AND D602.PPSUC = ln_aosuc
                 AND D602.PPMOD = ln_aomod
                 AND D602.PPMDA = ln_aomda
                 AND D602.PPPAP = ln_aopap
                 AND D602.PPCTA = ln_aocta
                 AND D602.PPOPER = ln_aooper
                 AND D602.PPSBOP = ln_aosbop
                 AND D602.PPTOPE = ln_aotope
                 AND D602.PPFPAG = lv_maxFec
                 AND ROWNUM = 1;
            when others then
            
              begin
                select distinct d015.itsuc
                  into ln_coagca
                  from fsd015 d015, fsd016 d016
                 where d015.pgcod = d016.pgcod
                   and d015.itsuc = d016.itsuc
                   and d015.itmod = d016.itmod
                   and d015.ittran = d016.ittran
                   and d015.itnrel = d016.itnrel
                   and d016.ctnro = ln_aocta
                   and d016.itoper = ln_aooper
                   and d016.modulo = ln_aomod
                   and d016.pgcod = ln_pgcod
                   and d016.itsucd = ln_aosuc
                   and d016.papel = ln_aopap
                   and d016.moneda = ln_aomda
                   and d016.itsubo = ln_aosbop
                   and d016.ittope = ln_aotope;
              EXCEPTION
                when too_many_rows then
                  select distinct d015.itsuc
                    into ln_coagca
                    from fsd015 d015, fsd016 d016
                   where d015.pgcod = d016.pgcod
                     and d015.itsuc = d016.itsuc
                     and d015.itmod = d016.itmod
                     and d015.ittran = d016.ittran
                     and d015.itnrel = d016.itnrel
                     and d016.ctnro = ln_aocta
                     and d016.itoper = ln_aooper
                     and d016.modulo = ln_aomod
                     and d016.pgcod = ln_pgcod
                     and d016.itsucd = ln_aosuc
                     and d016.papel = ln_aopap
                     and d016.moneda = ln_aomda
                     and d016.itsubo = ln_aosbop
                     and d016.ittope = ln_aotope
                     and d015.itfcon = lv_maxFec
                     AND ROWNUM = 1;
                when others then
                  NULL;
              end;
            
          end;
        
          begin
            select trim(t001.scnom)
              into lc_agecan
              from Fst001 t001
             where t001.pgcod = ln_pgcod
               and t001.sucurs = ln_coagca;
          EXCEPTION
            when others then
              lc_agecan := '';
          end;
          lc_agecan := NVL(lc_agecan, '');
        end if;
      
        begin
          select t017.pgfape
            into ld_fecrep
            from fst017 t017
           where pgcod = 1;
        EXCEPTION
          when others then
            ld_fecrep := '';
        end;
      
        begin
          insert into aqpb609
            (AQPB609NOMAGE,
             AQPB609CODAGE,
             AQPB609USUIMP,
             AQPB609FECIMP,
             AQPB609FLAIMP,
             AQPB609NOMCLI,
             AQPB609NUMCRE,
             AQPB609ANACAR,
             AQPB609AGECAN,
             AQPB609FECCAN,
             AQPB609PGCOD,
             AQPB609MODULO,
             AQPB609SUCURS,
             AQPB609MONEDA,
             AQPB609PAPEL,
             AQPB609CUENTA,
             AQPB609OPERAC,
             AQPB609SUBOPE,
             AQPB609TIPOPE,
             AQPB609FECREP,
             AQPB609USUREP,
             AQPB609TIPCON)
          values
            (lc_nomage,
             ln_aosuc,
             lc_usuimp,
             ld_fecimp,
             lc_flaimp,
             lc_nomcli,
             lc_numcre,
             lc_anacar,
             lc_agecan,
             ld_aofe99,
             ln_pgcod,
             ln_aosuc,
             ln_aomod,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope,
             ld_fecrep,
             pv_usurep,
             'CON');
          commit;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
            NULL;
        end;
      end if;
    
    end loop;
  END sp_cr_gen_rep_cre_canc;

  --**********************************************************************************************************--  
  --CERTIFICADO DE NO ADEUDO
  procedure sp_cr_gen_rep_cna(pd_fecini in date,
                              pd_fecfin in date,
                              pn_AgeOri in number,
                              pv_usurep in varchar2,
                              pn_coderr out number,
                              pn_msgerr out varchar2) is
    CURSOR Cursor_CreCan IS
      select a.aqpb608pgcodc  pgcod,
             a.aqpb608modc    modulo,
             a.aqpb608succ    sucur,
             a.aqpb608monc    moneda,
             a.aqpb608papc    papel,
             a.aqpb608ctac    cuenta,
             a.aqpb608opec    oper,
             a.aqpb608sopec   sbope,
             a.aqpb608topec   tope,
             a.aqpb608itfcon  fec99,
             a.Aqpb608usucna,
             a.aqpb608feccna,
             a.aqpb608fimpcna
        from aqpb608 a
       where a.aqpb608itfcon >= pd_fecini
         and a.aqpb608itfcon <= pd_fecfin
         and a.aqpb608tipocon = 'CNA';
  
    my_errm VARCHAR2(32000);
  
    ln_aostat number(2);
    ld_aofe99 date;
    ln_pgcod  number(3);
    ln_aosuc  number(3);
    ln_aomod  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    lc_nomage VARCHAR2(250);
    lc_usuimp VARCHAR2(10);
    ld_fecimp DATE;
    lc_flaimp VARCHAR2(1);
    lc_nomcli VARCHAR2(250);
    lc_numcre VARCHAR2(30);
    lc_anacar VARCHAR2(250);
    lc_agecan VARCHAR2(250);
    ld_fecrep DATE;
  
    ln_coagca number(3);
    lv_maxFec date;
  
    --ln_Interes number(18,2);
    --ln_Mora    number(18,2);
    --ln_Honpro  number(18,2);
    --ln_Gastos  number(18,2);
    --ln_Saldo   number(18,2);
  
    --ln_ValSal  number(2) := 0;
  
  BEGIN
    pn_msgerr := '';
    --LIMPIAR REGISTROS DE LOS REPORTES    
    begin
      delete from AQPB609 a
       where a.AQPB609FECCAN >= pd_fecini
         and a.AQPB609FECCAN <= pd_fecfin
         and trim(a.AQPB609USUREP) = trim(pv_usurep)
         and a.AQPB609TIPCON = 'CNA';
      commit;
    EXCEPTION
      when others then
        NULL;
    end;
  
    for i in Cursor_CreCan loop
      pn_coderr := 0;
      ln_pgcod  := i.pgcod;
      ln_aosuc  := i.sucur;
      ln_aomod  := i.modulo;
      ln_aomda  := i.moneda;
      ln_aopap  := i.papel;
      ln_aocta  := i.cuenta;
      ln_aooper := i.oper;
      ln_aosbop := i.sbope;
      ln_aotope := i.tope;
      ld_aofe99 := nvl(i.fec99, null);
      --FLAG DE IMPRESION
      lc_usuimp := nvl(i.aqpb608usucna, '');
      ld_fecimp := i.aqpb608feccna;
      lc_flaimp := nvl(i.aqpb608fimpcna, 'N');
    
      --OPTENER ESTADO Y CLAVE DEL CREDITO
      if ld_aofe99 is null then
        begin
          select d010.aostat, d010.aofe99
            into ln_aostat, ld_aofe99
            from fsd010 d010
           where d010.pgcod = ln_pgcod
             and d010.aosuc = ln_aosuc
             and d010.aomod = ln_aomod
             and d010.aomda = ln_aomda
             and d010.aopap = ln_aopap
             and d010.aocta = ln_aocta
             and d010.aooper = ln_aooper
             and d010.aosbop = ln_aosbop
             and d010.aotope = ln_aotope
             and d010.aofe99 >= pd_fecini
             and rownum = 1
           order by Aosbop desc;
        EXCEPTION
          when others then
            pn_coderr := 1;
        end;
      end if;
    
      --SUCUCRSAL ORIGEN
      begin
        select trim(t001.scnom)
          into lc_nomage
          from Fst001 t001
         where t001.pgcod = ln_pgcod
           and t001.sucurs = ln_aosuc;
      EXCEPTION
        when others then
          pn_coderr := 2;
      end;
    
      --NOMBRE CLIENTE
      begin
        select trim(d001.penom)
          into lc_nomcli
          from fsr008 r008
          join Fsd001 d001
            on d001.pepais = r008.pepais
           and d001.petdoc = r008.petdoc
           and d001.pendoc = r008.pendoc
         where r008.ctnro = ln_aocta
           and r008.cttfir = 'T';
      EXCEPTION
        when too_many_rows then
          select trim(d001.penom)
            into lc_nomcli
            from fsr008 r008
            join Fsd001 d001
              on d001.pepais = r008.pepais
             and d001.petdoc = r008.petdoc
             and d001.pendoc = r008.pendoc
           where r008.ctnro = ln_aocta
             and r008.cttfir = 'T'
             and rownum = 1;
        when others then
          pn_coderr := 3;
      end;
    
      --NUMERO CREDITO
      begin
        lc_numcre := lpad(ln_aocta, 9, '0') || lpad(ln_aomda, 3, '0') ||
                     lpad(ln_aooper, 9, '0');
      EXCEPTION
        when others then
          pn_coderr := 4;
      end;
    
      --ANALISTA DE LA CARTERA
      begin
        select trim(g001.sng001ase)
          into lc_anacar
          from xwf700 x700
          join sng001 g001
            on g001.sng001inst = x700.xwfprcins
         where x700.xwfempresa = ln_pgcod
           and x700.xwfsucursal = ln_aosuc
           and x700.xwfmodulo = ln_aomod
           and x700.xwfmoneda = ln_aomda
           and x700.xwfpapel = ln_aopap
           and x700.xwfcuenta = ln_aocta
           and x700.xwfoperacion = ln_aooper
           and x700.xwfsubope = ln_aosbop
           and x700.xwftipope = ln_aotope
           AND x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          lc_anacar := '';
          my_errm   := SQLERRM;
      end;
    
      -- agencia de cancelacion
      begin
        SELECT MAX(D601.PPFPAG)
          into lv_maxFec
          FROM FSD601 D601
         WHERE D601.PGCOD = ln_pgcod
           AND D601.PPSUC = ln_aosuc
           AND D601.PPMOD = ln_aomod
           AND D601.PPMDA = ln_aomda
           AND D601.PPPAP = ln_aopap
           AND D601.PPCTA = ln_aocta
           AND D601.PPOPER = ln_aooper
           AND D601.PPSBOP = ln_aosbop
           AND D601.PPTOPE = ln_aotope;
      EXCEPTION
        when others then
          NULL;
      end;
    
      begin
        SELECT D602.D602SU
          Into ln_coagca
          FROM FSD602 D602
         WHERE D602.PGCOD = ln_pgcod
           AND D602.PPSUC = ln_aosuc
           AND D602.PPMOD = ln_aomod
           AND D602.PPMDA = ln_aomda
           AND D602.PPPAP = ln_aopap
           AND D602.PPCTA = ln_aocta
           AND D602.PPOPER = ln_aooper
           AND D602.PPSBOP = ln_aosbop
           AND D602.PPTOPE = ln_aotope
           AND D602.PPFPAG = lv_maxFec;
      EXCEPTION
        when too_many_rows then
          SELECT D602.D602SU
            Into ln_coagca
            FROM FSD602 D602
           WHERE D602.PGCOD = ln_pgcod
             AND D602.PPSUC = ln_aosuc
             AND D602.PPMOD = ln_aomod
             AND D602.PPMDA = ln_aomda
             AND D602.PPPAP = ln_aopap
             AND D602.PPCTA = ln_aocta
             AND D602.PPOPER = ln_aooper
             AND D602.PPSBOP = ln_aosbop
             AND D602.PPTOPE = ln_aotope
             AND D602.PPFPAG = lv_maxFec
             AND ROWNUM = 1;
        when others then
          begin
            select distinct d015.itsuc
              into ln_coagca
              from fsd015 d015, fsd016 d016
             where d015.pgcod = d016.pgcod
               and d015.itsuc = d016.itsuc
               and d015.itmod = d016.itmod
               and d015.ittran = d016.ittran
               and d015.itnrel = d016.itnrel
               and d016.ctnro = ln_aocta
               and d016.itoper = ln_aooper
               and d016.modulo = ln_aomod
               and d016.pgcod = ln_pgcod
               and d016.itsucd = ln_aosuc
               and d016.papel = ln_aopap
               and d016.moneda = ln_aomda
               and d016.itsubo = ln_aosbop
               and d016.ittope = ln_aotope;
          EXCEPTION
            when too_many_rows then
              select distinct d015.itsuc
                into ln_coagca
                from fsd015 d015, fsd016 d016
               where d015.pgcod = d016.pgcod
                 and d015.itsuc = d016.itsuc
                 and d015.itmod = d016.itmod
                 and d015.ittran = d016.ittran
                 and d015.itnrel = d016.itnrel
                 and d016.ctnro = ln_aocta
                 and d016.itoper = ln_aooper
                 and d016.modulo = ln_aomod
                 and d016.pgcod = ln_pgcod
                 and d016.itsucd = ln_aosuc
                 and d016.papel = ln_aopap
                 and d016.moneda = ln_aomda
                 and d016.itsubo = ln_aosbop
                 and d016.ittope = ln_aotope
                 and d015.itfcon = lv_maxFec
                 AND ROWNUM = 1;
            when others then
              NULL;
          end;
      end;
    
      begin
        select trim(t001.scnom)
          into lc_agecan
          from Fst001 t001
         where t001.pgcod = ln_pgcod
           and t001.sucurs = ln_coagca;
      EXCEPTION
        when others then
          lc_agecan := '';
      end;
    
      lc_agecan := NVL(lc_agecan, '');
    
      begin
        select t017.pgfape into ld_fecrep from fst017 t017 where pgcod = 1;
      EXCEPTION
        when others then
          ld_fecrep := '';
      end;
    
      begin
        insert into aqpb609
          (AQPB609NOMAGE,
           AQPB609CODAGE,
           AQPB609USUIMP,
           AQPB609FECIMP,
           AQPB609FLAIMP,
           AQPB609NOMCLI,
           AQPB609NUMCRE,
           AQPB609ANACAR,
           AQPB609AGECAN,
           AQPB609FECCAN,
           AQPB609PGCOD,
           AQPB609MODULO,
           AQPB609SUCURS,
           AQPB609MONEDA,
           AQPB609PAPEL,
           AQPB609CUENTA,
           AQPB609OPERAC,
           AQPB609SUBOPE,
           AQPB609TIPOPE,
           AQPB609FECREP,
           AQPB609USUREP,
           AQPB609TIPCON)
        values
          (lc_nomage,
           ln_aosuc,
           lc_usuimp,
           ld_fecimp,
           lc_flaimp,
           lc_nomcli,
           lc_numcre,
           lc_anacar,
           lc_agecan,
           ld_aofe99,
           ln_pgcod,
           ln_aosuc,
           ln_aomod,
           ln_aomda,
           ln_aopap,
           ln_aocta,
           ln_aooper,
           ln_aosbop,
           ln_aotope,
           ld_fecrep,
           pv_usurep,
           'CNA');
        commit;
      EXCEPTION
        when others then
          my_errm := SQLERRM;
          NULL;
      end;
    end loop;
  
  END sp_cr_gen_rep_cna;

  --**********************************************************************************************************-- 
  procedure sp_cr_upt_flag(pn_pgcodc in number,
                           pn_modc   in number,
                           pn_succ   in number,
                           pn_monc   in number,
                           pn_papc   in number,
                           pd_ctac   in number,
                           pv_opec   in number,
                           pv_sopec  in number,
                           pv_topec  in number,
                           pv_instan in number,
                           pv_user   in varchar2,
                           pn_coderr out number,
                           pn_msgerr out varchar2) is
  
    my_errm VARCHAR2(32000);
  
    HORA varchar2(15);
  
  BEGIN
    pn_coderr := 0;
  
    if pn_coderr = 0 then
      begin
        HORA := to_char(sysdate, 'HH24:MI:SS');
        update aqpb608
           set AQPB608USU  = pv_user,
               AQPB608FIMP = 'S',
               AQPB608FEC  = TO_DATE(SYSDATE),
               AQPB608HOR  = HORA
         where AQPB608PGCODC = pn_pgcodc
           and AQPB608MODC = pn_modc
           and AQPB608SUCC = pn_succ
           and AQPB608MONC = pn_monc
           and AQPB608PAPC = pn_papc
           and AQPB608CTAC = pd_ctac
           and AQPB608OPEC = pv_opec
           and AQPB608SOPEC = pv_sopec
           and AQPB608TOPEC = pv_topec;
        commit;
      EXCEPTION
        when others then
          pn_coderr := 9;
          pn_msgerr := 'Error al actualizar';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
  END sp_cr_upt_flag;

  --**********************************************************************************************************--  
  procedure sp_cr_insert_desde_609(ln_PGCODC in number,
                                   ln_MODC   in number,
                                   ln_SUCC   in number,
                                   ln_MONC   in number,
                                   ln_PAPC   in number,
                                   ln_CTAC   in number,
                                   ln_OPEC   in number,
                                   ln_SOPEC  in number,
                                   ln_TOPEC  in number,
                                   ln_usuari in varchar2,
                                   ln_pepais in NUMBER,
                                   ln_petdoc in NUMBER,
                                   pv_pendoc in varchar2,
                                   ln_INSTAN out number,
                                   pn_coderr out number,
                                   pn_msgerr out varchar2) is
    my_errm VARCHAR2(32000);
  
    lv_penom  Fsd001.penom%type;
    lv_pendoc CHAR(12);
    lv_pais   number;
    lv_coddoc number;
  
    HORA varchar2(15);
  
    pv_rutaI varchar(500);
    --lv_state FSD010.AOSTAT%type;
    lv_maxFec FSD601.PPFPAG%type;
  
    lv_corr          NUMBER;
    lv_horat         varchar2(8);
    ld_fecgui        date;
    ld_fecchaSystema date;
    ld_fecon         date;
  
    lv_flagCan varchar(1);
    ln_estadoC number(3);
  
  BEGIN
    pn_coderr := 0;
    lv_pendoc := pv_pendoc;
  
    --fecha del sistema
    select pgfape into ld_fecchaSystema from fst017 where pgcod = 1;
  
    --ruta
    begin
      pv_rutaI := 'CNA' || to_char(ln_PGCODC) || to_char(ln_MODC) ||
                  to_char(ln_SUCC) || to_char(ln_MONC) || to_char(ln_PAPC) ||
                  to_char(ln_CTAC) || to_char(ln_OPEC) || to_char(ln_SOPEC) ||
                  to_char(ln_TOPEC) || to_char(lv_pendoc);
    
    EXCEPTION
      when others then
        --pn_coderr := 3;
        pn_msgerr := 'Error en ruta';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    ld_fecgui := fn_get_FecGuia();
  
    --SI ESTA CANCELADO
    sp_cr_val_estado_2(ln_PGCODC,
                       ln_CTAC,
                       ln_MODC,
                       ln_OPEC,
                       ln_SUCC,
                       ln_MONC,
                       ln_PAPC,
                       ln_TOPEC,
                       ld_fecgui,
                       lv_flagCan,
                       lv_maxFec,
                       ln_estadoC);
    /*begin 
      SELECT D010.AOSTAT, D010.Aofe99
        into lv_state, lv_maxFec
        FROM FSD010 D010
       WHERE D010.PGCOD = ln_PGCODC
         AND D010.AOMOD = ln_MODC
         AND D010.AOSUC = ln_SUCC
         AND D010.AOMDA = ln_MONC
         AND D010.AOPAP = ln_PAPC
         AND D010.AOCTA = ln_CTAC
         AND D010.AOOPER = ln_OPEC
         AND D010.AOSBOP = ln_SOPEC
         AND D010.AOTOPE = ln_TOPEC
         AND D010.AOSTAT = 99;
    EXCEPTION         
       when others then
        begin 
           SELECT D010.AOSTAT, D010.Aofe99
             into lv_state, lv_maxFec
             FROM FSD010 D010
            WHERE D010.PGCOD = ln_PGCODC
              AND D010.AOMOD = ln_MODC
              AND D010.AOSUC = ln_SUCC
              AND D010.AOMDA = ln_MONC
              AND D010.AOPAP = ln_PAPC
              AND D010.AOCTA = ln_CTAC
              AND D010.AOOPER = ln_OPEC
              AND D010.AOSBOP = ln_SOPEC
              AND D010.AOTOPE = ln_TOPEC
              AND D010.AOSTAT = 99
              and rownum = 1;
        EXCEPTION         
           when others then
            pn_coderr := 1;
            pn_msgerr := 'Error al ferificar cancelacion';
            my_errm := SQLERRM;
            DBMS_OUTPUT.put_line (my_errm);
        end;
    end;*/
  
    --** instancia
    if pn_coderr = 0 then
      begin
        select xwfprcins
          into ln_INSTAN
          from xwf700 x700
         where x700.xwfempresa = ln_PGCODC
           and x700.xwfmodulo = ln_MODC
           and x700.xwfsucursal = ln_SUCC -- instancia
           and x700.xwfmoneda = ln_MONC
           and x700.xwfpapel = ln_PAPC
           and x700.xwfcuenta = ln_CTAC
           and x700.xwfoperacion = ln_OPEC
           and x700.xwfsubope = ln_SOPEC
           and x700.xwftipope = ln_TOPEC
           and x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          ln_INSTAN := 0;
      end;
    end if;
  
    --** VALIDAR MODULO
    if ln_MODC = 116 then
      pn_coderr := 7;
      pn_msgerr := 'Modulo no Permitido';
      my_errm   := SQLERRM;
      DBMS_OUTPUT.put_line('7');
      DBMS_OUTPUT.put_line(my_errm);
    end if;
  
    --** nombre del titular
    if pn_coderr = 0 then
      begin
        select r.pepais, r.petdoc, r.pendoc
          into lv_pais, lv_coddoc, lv_pendoc
          from fsr008 r
         where r.ctnro = ln_CTAC
           and r.cttfir = 'T' offset 0 rows
         fetch next 1 rows only;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
      begin
        select penom
          into lv_penom
          from Fsd001
         where pepais = lv_pais
           and petdoc = lv_coddoc
           and pendoc = lv_pendoc;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
    end if;
    /*if pn_coderr = 0 then
      begin 
        select penom
          into lv_penom
          from Fsd001
         where pepais = ln_pepais
           and petdoc = ln_petdoc
           and pendoc = lv_pendoc;
      EXCEPTION          
         when others then
            begin 
              select penom
                into lv_penom
                from Fsd001
               where (pepais, petdoc, pendoc) = 
                     (select r.pepais, r.petdoc, r.pendoc
                        from fsr008 r 
                       where r.ctnro = ln_CTAC and r.cttfir = 'T'
                      offset 0 rows fetch next 1 rows only);
            EXCEPTION          
               when others then
                pn_coderr := 0;
                pn_msgerr := 'Error en nombre del titular';
                my_errm := SQLERRM;
            end;
      end;
    end if ;  */
  
    --** validar duplicidad 
    if pn_coderr = 0 then
      begin
        select 1
          into lv_corr
          from aqpb608 b608
         where b608.AQPB608PGCODC = ln_PGCODC
           and b608.AQPB608MODC = ln_MODC
           and b608.AQPB608SUCC = ln_SUCC
           and b608.AQPB608MONC = ln_MONC
           and b608.AQPB608PAPC = ln_PAPC
           and b608.AQPB608CTAC = ln_CTAC
           and b608.AQPB608OPEC = ln_OPEC
           and b608.AQPB608SOPEC = ln_SOPEC
           and b608.AQPB608TOPEC = ln_TOPEC offset 0 rows
         fetch next 1 rows only;
        pn_coderr := 999;
      EXCEPTION
        when others then
          pn_coderr := 0;
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    HORA := to_char(sysdate, 'HH24:MI:SS');
  
    if pn_coderr = 999 then
      begin
        UPDATE aqpb608
           SET AQPB608FIMP = 'S',
               AQPB608HOR  = HORA,
               AQPB608FEC  = ld_fecchaSystema,
               AQPB608USU  = ln_usuari
         where AQPB608PGCODC = ln_PGCODC
           and AQPB608MODC = ln_MODC
           and AQPB608SUCC = ln_SUCC
           and AQPB608MONC = ln_MONC
           and AQPB608PAPC = ln_PAPC
           and AQPB608CTAC = ln_CTAC
           and AQPB608OPEC = ln_OPEC
           and AQPB608SOPEC = ln_SOPEC
           and AQPB608TOPEC = ln_TOPEC;
      EXCEPTION
        when others then
          pn_coderr := 0;
      end;
    ELSIF pn_coderr = 0 then
      --** insertar en la tabla
      sp_cr_obtener_hora(ln_PGCODC,
                         ln_MODC,
                         ln_SUCC,
                         ln_MONC,
                         ln_PAPC,
                         ln_CTAC,
                         ln_OPEC,
                         ln_SOPEC,
                         ln_TOPEC,
                         ld_fecchaSystema,
                         lv_horat, --OUT
                         ld_fecon); --OUT
    
      begin
        insert into aqpb608
          (AQPB608INSTAN,
           AQPB608PGCODC,
           AQPB608MODC,
           AQPB608SUCC,
           AQPB608MONC,
           AQPB608PAPC,
           AQPB608CTAC,
           AQPB608OPEC,
           AQPB608SOPEC,
           AQPB608TOPEC,
           AQPB608USU,
           AQPB608FEC,
           AQPB608HOR,
           AQPB608FIMP,
           AQPB608TIPOCON,
           AQPB608NOMARC,
           AQPB608ITFCON,
           AQPB608HORT,
           AQPB608NOMCLI,
           AQPB608PAIS,
           AQPB608TDOC,
           AQPB608NUMDOC)
        values
          (ln_INSTAN,
           ln_PGCODC,
           ln_MODC,
           ln_SUCC,
           ln_MONC,
           ln_PAPC,
           ln_CTAC,
           ln_OPEC,
           ln_SOPEC,
           ln_TOPEC,
           ln_usuari,
           ld_fecchaSystema,
           HORA,
           'S',
           'CON',
           pv_rutaI,
           NVL(ld_fecon, lv_maxFec),
           lv_horat,
           lv_penom,
           lv_pais,
           lv_coddoc,
           lv_pendoc);
        COMMIT;
        pn_msgerr := 'Exito en el registro';
      EXCEPTION
        when others then
          pn_coderr := 5;
          pn_msgerr := 'Error al registrar la cancelacion';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  END sp_cr_insert_desde_609;

  --**********************************************************************************************************--  
  procedure sp_cr_insert_desde_609B(ln_PGCODC in number,
                                    ln_MODC   in number,
                                    ln_SUCC   in number,
                                    ln_MONC   in number,
                                    ln_PAPC   in number,
                                    ln_CTAC   in number,
                                    ln_OPEC   in number,
                                    ln_SOPEC  in number,
                                    ln_TOPEC  in number,
                                    ln_usuari in varchar2,
                                    ln_pepais in NUMBER,
                                    ln_petdoc in NUMBER,
                                    pv_pendoc in varchar2,
                                    ln_INSTAN out number,
                                    pn_coderr out number,
                                    pn_msgerr out varchar2) is
    my_errm VARCHAR2(32000);
  
    lv_penom  Fsd001.penom%type;
    lv_pendoc CHAR(12);
    lv_pais   number;
    lv_coddoc number;
  
    ld_fechaSistema date;
  
    HORA varchar2(15);
  
    pv_rutaI varchar(500);
  
    lv_maxFec FSD601.PPFPAG%type;
  
    lv_corr   NUMBER;
    lv_horat  varchar(8);
    ld_fecgui date;
    ld_fecon  date;
  
    lv_flagCan varchar(1);
    ln_estadoC number(3);
  
  BEGIN
    pn_coderr := 0;
    lv_pendoc := pv_pendoc;
  
    HORA := to_char(sysdate, 'HH24:MI:SS');
    SELECT T.PGFAPE into ld_fechaSistema FROM FST017 T WHERE T.PGCOD = 1;
  
    --ruta
    begin
      pv_rutaI := 'CNA' || to_char(ln_PGCODC) || to_char(ln_MODC) ||
                  to_char(ln_SUCC) || to_char(ln_MONC) || to_char(ln_PAPC) ||
                  to_char(ln_CTAC) || to_char(ln_OPEC) || to_char(ln_SOPEC) ||
                  to_char(ln_TOPEC) || to_char(lv_pendoc);
    
    EXCEPTION
      when others then
        --pn_coderr := 3;
        pn_msgerr := 'Error en ruta';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    ld_fecgui := fn_get_FecGuia();
  
    --SI ESTA CANCELADO
    sp_cr_val_estado_2(ln_PGCODC,
                       ln_CTAC,
                       ln_MODC,
                       ln_OPEC,
                       ln_SUCC,
                       ln_MONC,
                       ln_PAPC,
                       ln_TOPEC,
                       ld_fecgui,
                       lv_flagCan,
                       lv_maxFec,
                       ln_estadoC);
    /*
    begin 
      SELECT D010.AOSTAT, D010.Aofe99
        into lv_state, lv_maxFec
        FROM FSD010 D010
       WHERE D010.PGCOD = ln_PGCODC
         AND D010.AOMOD = ln_MODC
         AND D010.AOSUC = ln_SUCC
         AND D010.AOMDA = ln_MONC
         AND D010.AOPAP = ln_PAPC
         AND D010.AOCTA = ln_CTAC
         AND D010.AOOPER = ln_OPEC
         AND D010.AOSBOP = ln_SOPEC
         AND D010.AOTOPE = ln_TOPEC
         AND D010.AOSTAT = 99;
    EXCEPTION         
       when others then
        begin 
           SELECT D010.AOSTAT, D010.Aofe99
             into lv_state, lv_maxFec
             FROM FSD010 D010
            WHERE D010.PGCOD = ln_PGCODC
              AND D010.AOMOD = ln_MODC
              AND D010.AOSUC = ln_SUCC
              AND D010.AOMDA = ln_MONC
              AND D010.AOPAP = ln_PAPC
              AND D010.AOCTA = ln_CTAC
              AND D010.AOOPER = ln_OPEC
              AND D010.AOSBOP = ln_SOPEC
              AND D010.AOTOPE = ln_TOPEC
              AND D010.AOSTAT = 99
              and rownum = 1;
        EXCEPTION         
           when others then
            pn_coderr := 1;
            pn_msgerr := 'Error al ferificar cancelacion';
            my_errm := SQLERRM;
            DBMS_OUTPUT.put_line (my_errm);
        end;
    end;
    */
  
    --** instancia
    if pn_coderr = 0 then
      begin
        select xwfprcins
          into ln_INSTAN
          from xwf700 x700
         where x700.xwfempresa = ln_PGCODC
           and x700.xwfmodulo = ln_MODC
           and x700.xwfsucursal = ln_SUCC -- instancia
           and x700.xwfmoneda = ln_MONC
           and x700.xwfpapel = ln_PAPC
           and x700.xwfcuenta = ln_CTAC
           and x700.xwfoperacion = ln_OPEC
           and x700.xwfsubope = ln_SOPEC
           and x700.xwftipope = ln_TOPEC
           and x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          ln_INSTAN := 0;
      end;
    end if;
  
    --** VALIDAR MODULO
    if ln_MODC = 116 then
      pn_coderr := 7;
      pn_msgerr := 'Modulo no Permitido';
      my_errm   := SQLERRM;
      DBMS_OUTPUT.put_line('7');
      DBMS_OUTPUT.put_line(my_errm);
    end if;
  
    --** nombre del titular
    if pn_coderr = 0 then
      begin
        select r.pepais, r.petdoc, r.pendoc
          into lv_pais, lv_coddoc, lv_pendoc
          from fsr008 r
         where r.ctnro = ln_CTAC
           and r.cttfir = 'T' offset 0 rows
         fetch next 1 rows only;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
      begin
        select penom
          into lv_penom
          from Fsd001
         where pepais = lv_pais
           and petdoc = lv_coddoc
           and pendoc = lv_pendoc;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
    end if;
  
    /*if pn_coderr = 0 then
      begin 
        select penom
          into lv_penom
          from Fsd001
         where pepais = ln_pepais
           and petdoc = ln_petdoc
           and pendoc = lv_pendoc;
      EXCEPTION          
         when others then
            begin 
              select penom
                into lv_penom
                from Fsd001
               where (pepais, petdoc, pendoc) = 
                     (select r.pepais, r.petdoc, r.pendoc
                        from fsr008 r 
                       where r.ctnro = ln_CTAC and r.cttfir = 'T'
                      offset 0 rows fetch next 1 rows only);
            EXCEPTION          
               when others then
                pn_coderr := 0;
                pn_msgerr := 'Error en nombre del titular';
                my_errm := SQLERRM;
            end;
      end;
    end if ; */
  
    --** validar duplicidad 
    if pn_coderr = 0 then
      begin
        select 1
          into lv_corr
          from aqpb608 b608
         where b608.AQPB608PGCODC = ln_PGCODC
           and b608.AQPB608MODC = ln_MODC
           and b608.AQPB608SUCC = ln_SUCC
           and b608.AQPB608MONC = ln_MONC
           and b608.AQPB608PAPC = ln_PAPC
           and b608.AQPB608CTAC = ln_CTAC
           and b608.AQPB608OPEC = ln_OPEC
           and b608.AQPB608SOPEC = ln_SOPEC
           and b608.AQPB608TOPEC = ln_TOPEC offset 0 rows
         fetch next 1 rows only;
        pn_coderr := 999;
      EXCEPTION
        when others then
          pn_coderr := 0;
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 999 then
      begin
        UPDATE aqpb608
           SET AQPB608FIMPCNA = 'S',
               AQPB608HORCNA  = HORA,
               AQPB608FECCNA  = ld_fechaSistema,
               AQPB608USUCNA  = ln_usuari,
               AQPB608TIPOCON = 'CNA'
         where AQPB608PGCODC = ln_PGCODC
           and AQPB608MODC = ln_MODC
           and AQPB608SUCC = ln_SUCC
           and AQPB608MONC = ln_MONC
           and AQPB608PAPC = ln_PAPC
           and AQPB608CTAC = ln_CTAC
           and AQPB608OPEC = ln_OPEC
           and AQPB608SOPEC = ln_SOPEC
           and AQPB608TOPEC = ln_TOPEC;
      EXCEPTION
        when others then
          pn_coderr := 0;
      end;
    ELSIF pn_coderr = 0 then
      --** insertar en la tabla
      sp_cr_obtener_hora(ln_PGCODC,
                         ln_MODC,
                         ln_SUCC,
                         ln_MONC,
                         ln_PAPC,
                         ln_CTAC,
                         ln_OPEC,
                         ln_SOPEC,
                         ln_TOPEC,
                         ld_fechaSistema,
                         lv_horat,
                         ld_fecon);
      begin
        insert into aqpb608
          (AQPB608INSTAN,
           AQPB608PGCODC,
           AQPB608MODC,
           AQPB608SUCC,
           AQPB608MONC,
           AQPB608PAPC,
           AQPB608CTAC,
           AQPB608OPEC,
           AQPB608SOPEC,
           AQPB608TOPEC,
           
           AQPB608USUCNA,
           AQPB608FECCNA,
           AQPB608HORCNA,
           AQPB608FIMPCNA,
           AQPB608TIPOCON,
           AQPB608NOMARC,
           AQPB608ITFCON,
           AQPB608HORT,
           AQPB608NOMCLI,
           AQPB608PAIS,
           AQPB608TDOC,
           AQPB608NUMDOC)
        values
          (ln_INSTAN,
           ln_PGCODC,
           ln_MODC,
           ln_SUCC,
           ln_MONC,
           ln_PAPC,
           ln_CTAC,
           ln_OPEC,
           ln_SOPEC,
           ln_TOPEC,
           ln_usuari,
           ld_fechaSistema,
           HORA,
           'S',
           'CNA',
           pv_rutaI,
           nvl(ld_fecon, lv_maxFec),
           lv_horat,
           lv_penom,
           lv_pais,
           lv_coddoc,
           lv_pendoc);
        COMMIT;
        pn_msgerr := 'Exito en el registro';
      EXCEPTION
        when others then
          pn_coderr := 5;
          pn_msgerr := 'Error al registrar la cancelacion';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  END sp_cr_insert_desde_609B;

  --**********************************************************************************************************--  
  procedure sp_cr_insert_desde_rte608(pn_pgcodt  in number,
                                      pn_suct    in number,
                                      pn_modt    in number,
                                      pn_trant   in number,
                                      pn_itnrelt in number,
                                      pv_usuario in varchar2) is
    my_errm VARCHAR2(32000);
  
    lv_penom  Fsd001.penom%type;
    lv_pendoc CHAR(12);
    lv_pais   number;
    lv_coddoc number;
  
    HORA varchar2(15);
  
    pv_rutaI varchar(500);
    --lv_state FSD010.AOSTAT%type;
    lv_maxFec FSD601.PPFPAG%type;
  
    lv_corr          NUMBER;
    lv_horat         varchar2(8);
    ld_fecgui        date;
    ld_fecchaSystema date;
    ld_fecon         date;
  
    lv_flagCan varchar(1);
    ln_estadoC number(3);
  
    ln_PGCODC   FSD016.pgcod%type;
    ln_MODC     FSD016.modulo%type;
    ln_SUCC     FSD016.itsucd%type;
    ln_MONC     FSD016.moneda%type;
    ln_PAPC     FSD016.papel%type;
    ln_CTAC     FSD016.ctnro%type;
    ln_OPEC     FSD016.itoper%type;
    ln_SOPEC    FSD016.itsubo%type;
    ln_TOPEC    FSD016.ittope%type;
    pd_itfcont  date;
    pn_coderr   number;
    pn_msgerr   varchar2(200);
    ln_INSTAN   number;
    ln_estado   number(3);
    ln_saldo011 number;
  BEGIN
    pn_coderr := 0;
  
    --fecha del sistema
    select pgfape into ld_fecchaSystema from fst017 where pgcod = 1;
  
    --obtener clave del credito
    begin
      select distinct d016.pgcod,
                      d016.modulo,
                      d016.itsucd,
                      d016.moneda,
                      d016.papel,
                      d016.ctnro,
                      d016.itoper,
                      d016.itsubo,
                      d016.ittope,
                      d015.itfcon,
                      d010.aostat
        into ln_PGCODC,
             ln_MODC,
             ln_SUCC,
             ln_MONC,
             ln_PAPC,
             ln_CTAC,
             ln_OPEC,
             ln_SOPEC,
             ln_TOPEC,
             pd_itfcont,
             ln_estado
        from fsd015 d015
        join FSD016 d016
          on d015.pgcod = d016.pgcod
         and d015.itsuc = d016.itsuc
         and d015.itmod = d016.itmod
         and d015.ittran = d016.ittran
         and d015.itnrel = d016.itnrel
        join FSD010 d010
          on d010.pgcod = d016.pgcod
         and d010.aomod = d016.modulo
         and d010.aosuc = d016.itsucd
         and d010.aomda = d016.moneda
         and d010.aopap = d016.papel
         and d010.aocta = d016.ctnro
         and d010.aooper = d016.itoper
         and d010.aosbop = d016.itsubo
         and d010.aotope = d016.ittope
       where d015.pgcod = pn_pgcodt
         and d015.itsuc = pn_suct
         and d015.itmod = pn_modt
         and d015.ittran = pn_trant
         and d015.itnrel = pn_itnrelt;
    EXCEPTION
      when others then
        pn_coderr := 4;
        pn_msgerr := 'Error clave credito';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    --ruta
    begin
      pv_rutaI := 'CNA' || to_char(ln_PGCODC) || to_char(ln_MODC) ||
                  to_char(ln_SUCC) || to_char(ln_MONC) || to_char(ln_PAPC) ||
                  to_char(ln_CTAC) || to_char(ln_OPEC) || to_char(ln_SOPEC) ||
                  to_char(ln_TOPEC) || to_char(lv_pendoc);
    EXCEPTION
      when others then
        --pn_coderr := 3;
        pn_msgerr := 'Error en ruta';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    ld_fecgui := fn_get_FecGuia();
  
    ln_saldo011 := fn_get_saldo_fsd011(ln_PGCODC,
                                       ln_MODC,
                                       ln_SUCC,
                                       ln_MONC,
                                       ln_PAPC,
                                       ln_CTAC,
                                       ln_OPEC,
                                       ln_SOPEC,
                                       ln_TOPEC);
    ln_saldo011 := nvl(ln_saldo011, 0);
  
    IF ln_estado = 99 or ln_saldo011 = 0 THEN
      --** instancia
      if pn_coderr = 0 then
        begin
          select xwfprcins
            into ln_INSTAN
            from xwf700 x700
           where x700.xwfempresa = ln_PGCODC
             and x700.xwfmodulo = ln_MODC
             and x700.xwfsucursal = ln_SUCC -- instancia
             and x700.xwfmoneda = ln_MONC
             and x700.xwfpapel = ln_PAPC
             and x700.xwfcuenta = ln_CTAC
             and x700.xwfoperacion = ln_OPEC
             and x700.xwfsubope = ln_SOPEC
             and x700.xwftipope = ln_TOPEC
             and x700.xwfcar3 = '1';
        EXCEPTION
          when others then
            ln_INSTAN := 0;
        end;
      end if;
    
      --** VALIDAR MODULO
      if ln_MODC = 116 then
        pn_coderr := 7;
        pn_msgerr := 'Modulo no Permitido';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line('7');
        DBMS_OUTPUT.put_line(my_errm);
      end if;
    
      --** nombre del titular
      begin
        select r.pepais, r.petdoc, r.pendoc
          into lv_pais, lv_coddoc, lv_pendoc
          from fsr008 r
         where r.ctnro = ln_CTAC
           and r.cttfir = 'T' offset 0 rows
         fetch next 1 rows only;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
      begin
        select penom
          into lv_penom
          from Fsd001
         where pepais = lv_pais
           and petdoc = lv_coddoc
           and pendoc = lv_pendoc;
      EXCEPTION
        when others then
          pn_coderr := 0;
          pn_msgerr := 'Error en nombre del titular';
          my_errm   := SQLERRM;
      end;
    
      --** validar duplicidad 
      begin
        select 1
          into lv_corr
          from aqpb608 b608
         where b608.AQPB608PGCODC = ln_PGCODC
           and b608.AQPB608MODC = ln_MODC
           and b608.AQPB608SUCC = ln_SUCC
           and b608.AQPB608MONC = ln_MONC
           and b608.AQPB608PAPC = ln_PAPC
           and b608.AQPB608CTAC = ln_CTAC
           and b608.AQPB608OPEC = ln_OPEC
           and b608.AQPB608SOPEC = ln_SOPEC
           and b608.AQPB608TOPEC = ln_TOPEC offset 0 rows
         fetch next 1 rows only;
        pn_coderr := 999;
      EXCEPTION
        when others then
          pn_coderr := 0;
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    
      if lv_corr = 1 then
        pn_coderr := 999;
      else
        pn_coderr := 0;
      end if;
    
      HORA := to_char(sysdate, 'HH24:MI:SS');
    
      if pn_coderr <> 999 then
        begin
          insert into aqpb608
            (AQPB608INSTAN,
             AQPB608PGCODC,
             AQPB608MODC,
             AQPB608SUCC,
             AQPB608MONC,
             AQPB608PAPC,
             AQPB608CTAC,
             AQPB608OPEC,
             AQPB608SOPEC,
             AQPB608TOPEC,
             AQPB608USU,
             AQPB608FEC,
             AQPB608HOR,
             AQPB608FIMP,
             AQPB608TIPOCON,
             AQPB608NOMARC,
             AQPB608ITFCON,
             AQPB608HORT,
             AQPB608NOMCLI,
             AQPB608PAIS,
             AQPB608TDOC,
             AQPB608NUMDOC)
          values
            (ln_INSTAN,
             ln_PGCODC,
             ln_MODC,
             ln_SUCC,
             ln_MONC,
             ln_PAPC,
             ln_CTAC,
             ln_OPEC,
             ln_SOPEC,
             ln_TOPEC,
             pv_usuario,
             ld_fecchaSystema,
             HORA,
             'S',
             'CON',
             pv_rutaI,
             ld_fecchaSystema,
             HORA,
             lv_penom,
             lv_pais,
             lv_coddoc,
             lv_pendoc);
          COMMIT;
          pn_msgerr := 'Exito en el registro';
        EXCEPTION
          when others then
            pn_coderr := 5;
            pn_msgerr := 'Error al registrar la cancelacion';
            my_errm   := SQLERRM;
            DBMS_OUTPUT.put_line(my_errm);
        end;
      end if;
    END IF;
  END sp_cr_insert_desde_rte608;

  --**********************************************************************************************************--  
  --busqueda por documento
  procedure sp_cr_generar_lst_crd(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    cursor lst_cuentas(pais number, tdoc number, doc character) is
      select Ctnro NroCta
        from fsr008
       Where Cttfir = 'T'
         and Pepais = pais
         and Petdoc = tdoc
         and Pendoc = doc;
  
    cursor lst_aqpb608(cuenta number, operacion number, FecGuia date) is
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.hcmod, h.hsucor, h.htran, h.hnrel, h.hfcon
                from fsh015 h
                join fsh016 i
                  on h.pgcod = i.pgcod
                 and h.hcmod = i.hcmod
                 and h.hsucor = i.hsucor
                 and h.htran = i.htran
                 and h.hnrel = i.hnrel
                 and h.hfcon = i.hfcon
               where i.hcta = cuenta
                 and i.hoper = operacion
                 and h.hccorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.itmod, h.itsuc, h.ittran, h.itnrel, h.itfcon
                from fsd015 h
                join fsd016 i
                  on h.pgcod = i.pgcod
                 and h.itmod = i.itmod
                 and h.itsuc = i.itsuc
                 and h.ittran = i.ittran
                 and h.itnrel = i.itnrel
                 and h.itfcon = i.itfval
               where i.ctnro = cuenta
                 and i.itoper = operacion
                 and h.itcorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a, fsd010 b
       where a.aqpb608pgcodc = 1
         and a.aqpb608modc = b.aomod
         and a.aqpb608monc = b.aomda
         and a.aqpb608papc = b.aopap
         and a.aqpb608ctac = b.aocta
         and a.aqpb608opec = b.aooper
         and b.aostat = 99
         and b.aocta = cuenta
         and b.aooper = operacion
         and a.aqpb608modc in (33, 200)
         and b.aomod in (select modulo from fst111 where dscod = 50);
    --  and AQPB608ITFCON >= FecGuia;
  
    cursor lst_fsd010(cuenta number, ln_pgcod number, FecGuia date) is
      select distinct aomod, aocta, aooper
        from fsd010
       where pgcod = ln_pgcod
         and aocta = cuenta --and aofe99 >= fecguia
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo != 116) or aomod = 117)
         and aomod not in (200, 33, 65)
       order by pgcod, aocta;
  
    l_PGCODAC  NUMBER(3);
    l_fecGuia  DATE;
    l_flag_Mod VARCHAR2(1);
    l_PgcodC   NUMBER;
    l_SucC     NUMBER;
    l_ModC     NUMBER;
    l_MonC     NUMBER;
    l_PapC     NUMBER;
    l_NroCta   NUMBER;
    l_OpeC     NUMBER;
    l_SubopeC  NUMBER;
    l_TipOpeC  NUMBER;
    l_FlagImp  VARCHAR2(1);
    l_flag608  VARCHAR2(1);
    ld_fecha99 DATE;
    l_ndoc     CHARACTER(12);
    l_usua     CHARACTER(10);
    lv_flagCan varchar(1);
    lv_flCasti varchar(1);
    ln_estadoC number(3);
    ln_ContEst number(5);
    ln_sld_011 number;
    ln_sld_175 number;
    lc_ind_t   varchar(5);
  
    lv_flagCanN varchar2(1);
    lv_flagEstN varchar2(1);
  
    l_encontrado VARCHAR2(1);
  
  BEGIN
    pn_cerr := 0;
    l_usua  := pv_usua;
    l_ndoc  := pn_ndoc;
  
    -- ELIMINAR AQPB609L
    begin
      delete from aqpb609l a
       where a.aqpb609lflst = pd_fecha
         and a.aqpb609lulst = l_usua;
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    -- PGCOD DEL USUARIO
    begin
      select f.pgcodac into l_PgcodAc from FST746 f Where Ubuser = l_usua;
    EXCEPTION
      when others then
        l_PgcodAc := 1;
        my_errm   := SQLERRM;
        pv_merr   := 'Error_obtener_pgcodac';
    end;
  
    -- FECHA GUIA
    l_fecGuia := fn_get_FecGuia();
  
    --CURSOR DE CUENTAS
    for i in lst_cuentas(pn_pais, pn_tdoc, l_ndoc) loop
    
      for k in lst_fsd010(i.NroCta, l_PgcodAc, l_fecGuia) loop
        l_encontrado := 'N';
        --CURSOR AQPB608        
        /*for j in lst_aqpb608(k.Aocta, k.Aooper, l_fecGuia) loop
          begin
            insert into AQPB609L
              (AQPB609LPGCOD, --1
               AQPB609LMOD, --2
               AQPB609LSUC, --3
               AQPB609LMON, --4
               AQPB609LPAP, --5
               AQPB609LNCTA, --6
               AQPB609LNOPE, --7
               AQPB609LSOPE, --8
               AQPB609LTOPE, --9
               AQPB609LINS, --10
               AQPB609LFIMP, --11
               AQPB609LPGCODT, --12
               AQPB609LSUCT, --13
               AQPB609LMODT, --14
               AQPB609LTRANT, --15
               AQPB609LRELT, --16
               AQPB609LFCON, --17
               AQPB609LF608, --18           
               AQPB609LPAIS,
               AQPB609LTDOC,
               AQPB609LNDOC,
               AQPB609LFLST, --19
               AQPB609LULST, --20
               AQPB609LMERR --21
               )
            values
              (j.AQPB608PGCODC, --1
               j.AQPB608MODC, --2
               j.AQPB608SUCC, --3
               j.AQPB608MONC, --4
               j.AQPB608PAPC, --5
               j.AQPB608CTAC, --6
               j.AQPB608OPEC, --7
               j.AQPB608SOPEC, --8
               j.AQPB608TOPEC, --9
               j.AQPB608INSTAN, --10
               j.AQPB608FIMP, --11
               j.AQPB608PGCODT, --12
               j.AQPB608ITSUC, --13
               j.AQPB608ITMOD, --14
               j.AQPB608ITTRAN, --15
               j.AQPB608ITNREL, --16
               j.AQPB608ITFCON, --17
               'S', --18
               pn_pais,
               pn_tdoc,
               l_ndoc,
               pd_fecha, --19
               l_usua, --20
               '' --21
               );
            commit;
            l_encontrado := 'S';
          EXCEPTION
            when others then
              my_errm := SQLERRM;
              null;
          end;
        end loop;*/
        l_encontrado := 'N';
        if l_encontrado = 'N' then
          begin
            sp_cr_validar_credito_N(k.Aomod,
                                    k.Aocta,
                                    k.Aooper,
                                    lv_flagCanN,
                                    lv_flagEstN,
                                    ld_fecha99,
                                    ln_estadoC);
          exception
            when others then
              null;
          end;
          if lv_flagCanN = 'C' then
            sp_cr_dat_credito_2(l_PgcodAc,
                                k.Aocta,
                                k.Aooper,
                                k.Aomod,
                                l_PgcodC,
                                l_SucC,
                                l_ModC,
                                l_MonC,
                                l_PapC,
                                l_NroCta,
                                l_OpeC,
                                l_SubopeC,
                                l_TipOpeC);
          
            sp_cr_val_contancia_2(l_PgcodC,
                                  l_SucC,
                                  l_ModC,
                                  l_MonC,
                                  l_PapC,
                                  l_NroCta,
                                  l_OpeC,
                                  l_SubopeC,
                                  l_TipOpeC,
                                  l_Flag608,
                                  l_FlagImp);
          
            /*sp_cr_val_estado_2(l_PgcodC,
            k.Aocta,
            k.Aomod,
            k.Aooper,
            l_SucC,
            l_MonC,
            l_PapC,
            l_TipOpeC,
            l_fecGuia,
            lv_flagCan,
            ld_fecha99,
            ln_estadoC);*/
          
            --apachecoh 2024.02.27 No muestra castigados, judiciales o en venta 
            /*lv_flCasti := 'N';
            begin
              select 'S'
                into lv_flCasti
                from fsd010
               where aomod in (200, 33, 65)
                 and aocta = k.Aocta
                 and aooper = k.Aooper
                 and rownum = 1;
            exception
              when others then
                lv_flCasti := 'N';
            end;
            if lv_flCasti = 'N' then*/
              if ld_fecha99 >= l_fecGuia then
                begin
                  insert into AQPB609L
                    (AQPB609LPGCOD, --1
                     AQPB609LMOD, --2
                     AQPB609LSUC, --3
                     AQPB609LMON, --4
                     AQPB609LPAP, --5
                     AQPB609LNCTA, --6
                     AQPB609LNOPE, --7
                     AQPB609LSOPE, --8
                     AQPB609LTOPE, --9
                     AQPB609LINS, --10
                     AQPB609LFIMP, --11
                     AQPB609LPGCODT, --12
                     AQPB609LSUCT, --13
                     AQPB609LMODT, --14
                     AQPB609LTRANT, --15
                     AQPB609LRELT, --16
                     AQPB609LFCON, --17
                     AQPB609LF608, --18
                     AQPB609LPAIS,
                     AQPB609LTDOC,
                     AQPB609LNDOC,
                     AQPB609LFLST, --19
                     AQPB609LULST, --20
                     AQPB609LMERR --21
                     )
                  values
                    (l_PgcodC, --1
                     l_ModC, --2
                     l_SucC, --3
                     l_MonC, --4
                     l_PapC, --5
                     l_NroCta, --6
                     l_OpeC, --7
                     l_SubopeC, --8
                     l_TipOpeC, --9
                     NULL, --10
                     l_FlagImp, --11
                     NULL, --12
                     NULL, --13
                     NULL, --14
                     NULL, --15
                     NULL, --16
                     ld_fecha99, --17
                     l_Flag608, --18
                     pn_pais,
                     pn_tdoc,
                     l_ndoc,
                     pd_fecha, --19
                     l_usua, --20
                     '');
                  commit;
                EXCEPTION
                  when others then
                    my_errm := SQLERRM;
                    null;
                end;
              end if;
            --end if;
          end if;
        end if;
      end loop;
    end loop;
  
  END sp_cr_generar_lst_crd;

  /*procedure sp_cr_generar_lst_crd(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr out number,
                                  pv_merr out varchar2)is
    my_errm   VARCHAR2(32000);
  
    cursor lst_cuentas(pais number, tdoc number, doc character) is
      select Ctnro NroCta from fsr008
      Where Cttfir = 'T' and Pepais = pais and Petdoc = tdoc and Pendoc = doc;
      
    cursor lst_aqpb608(cuenta number, FecGuia date) is
      select AQPB608FIMP,
             AQPB608PGCODC,
             AQPB608MODC,
             AQPB608SUCC,
             AQPB608MONC,
             AQPB608PAPC,
             AQPB608CTAC,
             AQPB608OPEC,
             AQPB608SOPEC,
             AQPB608TOPEC,
             AQPB608PGCODT,
             AQPB608ITSUC,
             AQPB608ITMOD,
             AQPB608ITTRAN,
             AQPB608ITNREL,
             AQPB608ITFCON,
             AQPB608INSTAN
        from AQPB608
       where AQPB608CTAC = cuenta
         and AQPB608ITFCON >= FecGuia;
      
    cursor lst_fsd010 (cuenta number, ln_pgcod number, FecGuia date) is
      select distinct Aocta, Aooper, Aomod from fsd010
      Where Aocta  = cuenta and Pgcod  = ln_pgcod and Aofe99 >= FecGuia
        AND aomod IN (select t111.modulo from fst111 t111 where t111.Dscod = 50 and t111.Modulo != 116)
      order by Pgcod, Aocta;
      
    cursor cur_general(pais number, tdoc number, doc CHAR, FecGuia date) is
    select distinct d.pgcod, d.aomod, d.aosuc, d.aomda, d.aopap, d.aocta, d.aooper, d.aotope, d.aosbop, d.aostat,
    (select s.scsdo
    from FSD011 S where s.pgcod = d.pgcod and s.scsuc = d.aosuc and s.scmda = d.aomda 
                    and s.scpap = d.aopap and s.sccta = d.aocta and s.scoper = d.aooper
                    and s.scsbop = d.aosbop and s.scmod = d.aomod and s.sctope = d.aotope) saldo
    from fsd010 d 
    where d.aocta = 
          (select ctnro from fsr008 r where r.pepais = pais and r.petdoc = tdoc and r.pendoc = doc)
      and d.aomod in (select t111.modulo from fst111 t111 where t111.Dscod = 50 and t111.Modulo != 116)
      and d.aosbop = (select max(d1.AOSBOP) from fsd010 d1 where d1.PGCOD = d.pgcod and d1.AOMOD = d.aomod
                                                             and d1.AOMDA = d.aomda and d1.AOPAP = d.aopap
                                                             and d1.AOCTA = d.aocta and d1.AOSUC = d.aosuc
                                                             and d1.AOOPER = d.aooper and d1.AOTOPE = d.aotope)
      -- and d.aostat <> 99 
      --and d.aofval > FecGuia
    order by d.PGCOD, d.AOMOD, d.AOMDA, d.AOPAP, d.AOCTA, d.AOSUC, d.AOOPER, d.AOSBOP;
      
      
      
    l_PGCODAC  NUMBER(3);
    l_FecTem   VARCHAR2(20);
    l_fecGuia  DATE;
    l_flag_Mod VARCHAR2(1);
  
    l_PgcodC    NUMBER;
    l_SucC      NUMBER;
    l_ModC      NUMBER;
    l_MonC      NUMBER;
    l_PapC      NUMBER;
    l_NroCta    NUMBER;
    l_OpeC      NUMBER;
    l_SubopeC   NUMBER;
    l_TipOpeC   NUMBER;
    l_FlagImp   VARCHAR2(1);
    l_Flag_stat VARCHAR2(1);
    l_flag608   VARCHAR2(1);
    
    ln_pgcodt   number;
    ln_itsuc    number;
    ln_itmod    number;
    ln_ittran   number;
    ln_itnrel   number;
    ln_itfcon   date;
    
    ld_fecha99  DATE;
    
    l_ndoc      CHARACTER(12);
    l_usua      CHARACTER(10);
    
    BEGIN
      pn_cerr := 0;
      l_usua := pv_usua;
      l_ndoc := pn_ndoc;
      
      -- ELIMINAR AQPB609L
      begin
        delete from aqpb609l a
         where a.aqpb609lflst = pd_fecha
           and a.aqpb609lulst = l_usua;
        commit;
      EXCEPTION
        when others then
          my_errm := SQLERRM;
      end;    
      
      -- PGCOD DEL USUARIO
      begin
        select f.pgcodac
          into l_PgcodAc
          from FST746 f
         Where Ubuser = l_usua;
      EXCEPTION
        when others then
          l_PgcodAc := 1;
          my_errm := SQLERRM;
          pv_merr := 'Error_obtener_pgcodac';
      end;
      
      -- FECHA GUIA
      begin
        select trim(Tpdesc)
          into l_FecTem
          from fst098
         Where Pgcod = 1
           and Tpcod = 7750
           and Tpcorr = 1;
        
        l_fecGuia := TO_DATE(l_FecTem, 'dd/mm/yyyy');
    
      EXCEPTION
        when others then
          pn_cerr := 2;
          my_errm := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
          pv_merr := 'Error_obtenes_fecha_guia';
      end;
  
      --CURSOR DE CUENTAS
      for i in cur_general(pn_pais, pn_tdoc, l_ndoc, l_fecGuia) loop
        l_PgcodC := i.pgcod;
        l_SucC := i.aosuc;
        l_ModC := i.aomod;
        l_MonC := i.aomda;
        l_PapC := i.aopap;
        l_NroCta := i.aocta;
        l_OpeC := i.aooper;
        l_SubopeC := i.aosbop;
        l_TipOpeC := i.aotope;
        begin
          select AQPB608FIMP, 'S',
                 AQPB608PGCODT, AQPB608ITSUC, AQPB608ITMOD, AQPB608ITTRAN, AQPB608ITNREL, AQPB608ITFCON
            into l_FlagImp, l_flag608,
                 ln_pgcodt, ln_itsuc, ln_itmod,  ln_ittran, ln_itnrel, ln_itfcon
            from AQPB608
           where AQPB608PGCODC = l_PgcodC
             and AQPB608MODC = l_ModC
             and AQPB608SUCC = l_SucC
             and AQPB608MONC = l_MonC
             and AQPB608PAPC = l_PapC
             and AQPB608CTAC = l_NroCta
             and AQPB608OPEC = l_OpeC
             and AQPB608SOPEC = l_SubopeC
             and AQPB608TOPEC = l_TipOpeC
             offset 0 rows fetch next 1 rows only; 
        EXCEPTION
          when others then
            l_FlagImp := 'N';
            l_flag608 := 'N';
            my_errm := SQLERRM;
            null;
        end;
        
        if l_flag608 = 'N' then
                  --Do 'Datos_Credito'
            sp_cr_dat_credito_2(i.pgcod, 
                                i.aocta, 
                                i.aooper, 
                                i.aomod,
                                l_PgcodC, 
                                l_SucC, 
                                l_ModC,
                                l_MonC, 
                                l_PapC, 
                                l_NroCta,
                                l_OpeC, 
                                l_SubopeC, 
                                l_TipOpeC);
            --Do 'Valida_Estado'
            sp_cr_val_estado_2(l_PgcodC, 
                               l_NroCta, 
                               l_ModC, 
                               l_OpeC,
                               l_SucC, 
                               l_MonC, 
                               l_PapC, 
                               l_TipOpeC,
                               l_fecGuia,
                               l_Flag_stat,
                               ld_fecha99);
        end if;
        
        if l_flag608 = 'S' or l_Flag_stat = 'S' then 
          
          begin 
            insert into AQPB609L
              (AQPB609LPGCOD, --1
               AQPB609LMOD, --2
               AQPB609LSUC, --3
               AQPB609LMON, --4
               AQPB609LPAP, --5
               AQPB609LNCTA, --6
               AQPB609LNOPE, --7
               AQPB609LSOPE, --8
               AQPB609LTOPE, --9
               AQPB609LINS, --10
               AQPB609LFIMP, --11
               AQPB609LPGCODT, --12
               AQPB609LSUCT, --13
               AQPB609LMODT, --14
               AQPB609LTRANT, --15
               AQPB609LRELT, --16
               AQPB609LFCON, --17
               AQPB609LF608, --18           
               AQPB609LPAIS,
               AQPB609LTDOC,
               AQPB609LNDOC,  
               AQPB609LFLST, --19
               AQPB609LULST, --20
               AQPB609LMERR --21
               )
            values
              (i.pgcod, --1
               i.aomod, --2
               i.aosuc, --3
               i.aomda, --4
               i.aopap, --5
               i.aocta, --6
               i.aooper, --7
               i.aosbop, --8
               i.aotope, --9
               0, 
               l_FlagImp, --11
               ln_pgcodt, --12
               ln_itsuc, --13
               ln_itmod, --14
               ln_ittran, --15
               ln_itnrel, --16
               ln_itfcon, --17
               l_flag608, --18
               pn_pais,
               pn_tdoc, 
               l_ndoc,
               pd_fecha, --19
               l_usua,--20
               '' --21
               );
            commit;      
          EXCEPTION
            when others then
              my_errm := SQLERRM;
              null;
          end;
             
        end if;   
      end loop;
  
    END sp_cr_generar_lst_crd;
  */
  /*procedure sp_cr_generar_lst_crd(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr out number,
                                  pv_merr out varchar2)is
    my_errm   VARCHAR2(32000);
  
    cursor lst_cuentas(pais number, tdoc number, doc character) is
      select Ctnro NroCta from fsr008
      Where Cttfir = 'T' and Pepais = pais and Petdoc = tdoc and Pendoc = doc;
      
    cursor lst_aqpb608(cuenta number, FecGuia date) is
      select AQPB608FIMP,
             AQPB608PGCODC,
             AQPB608MODC,
             AQPB608SUCC,
             AQPB608MONC,
             AQPB608PAPC,
             AQPB608CTAC,
             AQPB608OPEC,
             AQPB608SOPEC,
             AQPB608TOPEC,
             AQPB608PGCODT,
             AQPB608ITSUC,
             AQPB608ITMOD,
             AQPB608ITTRAN,
             AQPB608ITNREL,
             AQPB608ITFCON,
             AQPB608INSTAN
        from AQPB608
       where AQPB608CTAC = cuenta
         and AQPB608ITFCON >= FecGuia;
      
    cursor lst_fsd010 (cuenta number, ln_pgcod number, FecGuia date) is
      select distinct Aocta, Aooper, Aomod from fsd010
      Where Aocta  = cuenta and Pgcod  = ln_pgcod and Aofe99 >= FecGuia
        AND aomod IN (select t111.modulo from fst111 t111 where t111.Dscod = 50 and t111.Modulo != 116)
      order by Pgcod, Aocta;
      
      
      
    l_PGCODAC  NUMBER(3);
    l_FecTem   VARCHAR2(20);
    l_fecGuia  DATE;
    l_flag_Mod VARCHAR2(1);
  
    l_PgcodC    NUMBER;
    l_SucC      NUMBER;
    l_ModC      NUMBER;
    l_MonC      NUMBER;
    l_PapC      NUMBER;
    l_NroCta    NUMBER;
    l_OpeC      NUMBER;
    l_SubopeC   NUMBER;
    l_TipOpeC   NUMBER;
    l_FlagImp   VARCHAR2(1);
    l_Flag_stat VARCHAR2(1);
    l_flag608   VARCHAR2(1);
    
    ld_fecha99  DATE;
    
    l_ndoc      CHARACTER(12);
    l_usua      CHARACTER(10);
    
    BEGIN
      pn_cerr := 0;
      l_usua := pv_usua;
      l_ndoc := pn_ndoc;
      
      -- ELIMINAR AQPB609L
      begin
        delete from aqpb609l a
         where a.aqpb609lflst = pd_fecha
           and a.aqpb609lulst = l_usua;
        commit;
      EXCEPTION
        when others then
          my_errm := SQLERRM;
      end;    
      
      -- PGCOD DEL USUARIO
      begin
        select f.pgcodac
          into l_PgcodAc
          from FST746 f
         Where Ubuser = l_usua;
      EXCEPTION
        when others then
          l_PgcodAc := 1;
          my_errm := SQLERRM;
          pv_merr := 'Error_obtener_pgcodac';
      end;
      
      -- FECHA GUIA
      begin
        select trim(Tpdesc)
          into l_FecTem
          from fst098
         Where Pgcod = 1
           and Tpcod = 7750
           and Tpcorr = 1;
        
        l_fecGuia := TO_DATE(l_FecTem, 'dd/mm/yyyy');
    
      EXCEPTION
        when others then
          pn_cerr := 2;
          my_errm := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
          pv_merr := 'Error_obtenes_fecha_guia';
      end;
  
      --CURSOR DE CUENTAS
      for i in lst_cuentas(pn_pais, pn_tdoc, l_ndoc) loop
        --CURSRO AQPB608
        for j in lst_aqpb608(i.NroCta, l_fecGuia) loop
          begin 
            insert into AQPB609L
              (AQPB609LPGCOD, --1
               AQPB609LMOD, --2
               AQPB609LSUC, --3
               AQPB609LMON, --4
               AQPB609LPAP, --5
               AQPB609LNCTA, --6
               AQPB609LNOPE, --7
               AQPB609LSOPE, --8
               AQPB609LTOPE, --9
               AQPB609LINS, --10
               AQPB609LFIMP, --11
               AQPB609LPGCODT, --12
               AQPB609LSUCT, --13
               AQPB609LMODT, --14
               AQPB609LTRANT, --15
               AQPB609LRELT, --16
               AQPB609LFCON, --17
               AQPB609LF608, --18           
               AQPB609LPAIS,
               AQPB609LTDOC,
               AQPB609LNDOC,  
               AQPB609LFLST, --19
               AQPB609LULST, --20
               AQPB609LMERR --21
               )
            values
              (j.AQPB608PGCODC, --1
               j.AQPB608MODC, --2
               j.AQPB608SUCC, --3
               j.AQPB608MONC, --4
               j.AQPB608PAPC, --5
               j.AQPB608CTAC, --6
               j.AQPB608OPEC, --7
               j.AQPB608SOPEC, --8
               j.AQPB608TOPEC, --9
               j.AQPB608INSTAN, --10
               j.AQPB608FIMP, --11
               j.AQPB608PGCODT, --12
               j.AQPB608ITSUC, --13
               j.AQPB608ITMOD, --14
               j.AQPB608ITTRAN, --15
               j.AQPB608ITNREL, --16
               j.AQPB608ITFCON, --17
               'S', --18
               pn_pais,
               pn_tdoc, 
               l_ndoc,
               pd_fecha, --19
               l_usua,--20
               '' --21
               );
            commit;      
          EXCEPTION
            when others then
              my_errm := SQLERRM;
              null;
          end;
        end loop;
        
        for k in lst_fsd010 (i.NroCta, l_PgcodAc, l_fecGuia) loop
  
          sp_cr_val_modulo_2(k.Aomod, l_flag_Mod);
          
          if l_flag_Mod = 'S' then
            --Do 'Datos_Credito'
            sp_cr_dat_credito_2( l_PgcodAc, 
                                k.Aocta, 
                                k.Aooper, 
                                k.Aomod,
                                l_PgcodC, 
                                l_SucC, 
                                l_ModC,
                                l_MonC, 
                                l_PapC, 
                                l_NroCta,
                                l_OpeC, 
                                l_SubopeC, 
                                l_TipOpeC);
                                                          
            --Do 'Valida_Estado'
            sp_cr_val_estado_2(l_PgcodC, 
                                k.Aocta, 
                                k.Aomod, 
                                k.Aooper,
                                l_SucC, 
                                l_MonC, 
                                l_PapC, 
                                l_TipOpeC,
                                l_fecGuia,
                                l_Flag_stat,
                                ld_fecha99);
                                
            if l_Flag_stat = 'S' then 
              --Do 'Validar_Constancia'
              sp_cr_val_contancia_2(l_PgcodC, 
                                     l_SucC, 
                                     l_ModC, 
                                     l_MonC, 
                                     l_PapC, 
                                     l_NroCta, 
                                     l_OpeC, 
                                     l_SubopeC, 
                                     l_TipOpeC,
                                     l_Flag608,
                                     l_FlagImp);
  
              if l_Flag608 = 'N' then
                begin
                  insert into AQPB609L
                    (AQPB609LPGCOD, --1
                     AQPB609LMOD, --2
                     AQPB609LSUC, --3
                     AQPB609LMON, --4
                     AQPB609LPAP, --5
                     AQPB609LNCTA, --6
                     AQPB609LNOPE, --7
                     AQPB609LSOPE, --8
                     AQPB609LTOPE, --9
                     AQPB609LINS, --10
                     AQPB609LFIMP, --11
                     AQPB609LPGCODT, --12
                     AQPB609LSUCT, --13
                     AQPB609LMODT, --14
                     AQPB609LTRANT, --15
                     AQPB609LRELT, --16
                     AQPB609LFCON, --17
                     AQPB609LF608, --18
                     AQPB609LPAIS,
                     AQPB609LTDOC,
                     AQPB609LNDOC,
                     AQPB609LFLST, --19
                     AQPB609LULST, --20
                     AQPB609LMERR --21
                     )
                  values
                    (l_PgcodC, --1
                     l_ModC, --2
                     l_SucC, --3
                     l_MonC, --4
                     l_PapC, --5
                     l_NroCta, --6
                     l_OpeC, --7
                     l_SubopeC, --8
                     l_TipOpeC, --9
                     NULL, --10
                     l_FlagImp, --11
                     NULL, --12
                     NULL, --13
                     NULL, --14
                     NULL, --15
                     NULL, --16
                     ld_fecha99, --17
                     l_Flag608, --18
                     pn_pais, 
                     pn_tdoc, 
                     l_ndoc,
                     pd_fecha, --19
                     l_usua, --20
                     '');
                  commit;
                EXCEPTION
                  when others then
                    my_errm := SQLERRM;
                    null;
                end;
              end if;
            end if;
            
          end if;
          
        end loop;
        
      end loop;
  
    END sp_cr_generar_lst_crd;
  */
  --**********************************************************************************************************--  
  --busqueda por cuenta y operacion
  procedure sp_cr_generar_lst_crd_2(pn_pais  in number,
                                    pn_tdoc  in number,
                                    pn_ndoc  in varchar2,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pv_usua  in varchar2,
                                    pd_fguia in date,
                                    pd_fsys  in date,
                                    pn_cerr  out number,
                                    pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    cursor lst_aqpb608(cuenta number, operacion number, FecGuia date) is
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.hcmod, h.hsucor, h.htran, h.hnrel, h.hfcon
                from fsh015 h
                join fsh016 i
                  on h.pgcod = i.pgcod
                 and h.hcmod = i.hcmod
                 and h.hsucor = i.hsucor
                 and h.htran = i.htran
                 and h.hnrel = i.hnrel
                 and h.hfcon = i.hfcon
               where i.hcta = cuenta
                 and i.hoper = operacion
                 and h.hccorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.itmod, h.itsuc, h.ittran, h.itnrel, h.itfcon
                from fsd015 h
                join fsd016 i
                  on h.pgcod = i.pgcod
                 and h.itmod = i.itmod
                 and h.itsuc = i.itsuc
                 and h.ittran = i.ittran
                 and h.itnrel = i.itnrel
                 and h.itfcon = i.itfval
               where i.ctnro = cuenta
                 and i.itoper = operacion
                 and h.itcorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a, fsd010 b
       where a.aqpb608pgcodc = 1
         and a.aqpb608modc = b.aomod
         and a.aqpb608monc = b.aomda
         and a.aqpb608papc = b.aopap
         and a.aqpb608ctac = b.aocta
         and a.aqpb608opec = b.aooper
         and b.aostat = 99
         and b.aocta = cuenta
         and b.aooper = operacion
         and a.aqpb608modc in (33, 200)
         and b.aomod in (select modulo from fst111 where dscod = 50);
    --and AQPB608ITFCON >= FecGuia;
  
    cursor lst_fsd010(cuenta    number,
                      operacion number,
                      ln_pgcod  number,
                      FecGuia   date) is
      select distinct aomod, aocta, aooper
        from fsd010
       where pgcod = ln_pgcod
         and aocta = cuenta
         and aooper = operacion
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo != 116) or aomod = 117)
         and aomod not in (200, 33, 65)
      --and aofe99 >= fecguia
       order by pgcod, aocta;
  
    l_PGCODAC  NUMBER(3);
    l_fecGuia  DATE;
    l_flag_Mod VARCHAR2(1);
  
    l_PgcodC  NUMBER;
    l_SucC    NUMBER;
    l_ModC    NUMBER;
    l_MonC    NUMBER;
    l_PapC    NUMBER;
    l_NroCta  NUMBER;
    l_OpeC    NUMBER;
    l_SubopeC NUMBER;
    l_TipOpeC NUMBER;
    l_FlagImp VARCHAR2(1);
    l_flag608 VARCHAR2(1);
  
    l_ndoc CHARACTER(12);
    l_usua CHARACTER(10);
  
    l_encontrado VARCHAR2(1);
  
    lv_flagCanN varchar2(1);
    lv_flagEstN varchar2(1);
    ld_fecha99  DATE;
  
    lv_flagCan varchar(1);
    lv_flCasti varchar(1);
    ln_estadoC number(3);
  
    ln_ContEst number(5);
    ln_sld_011 number;
    ln_sld_175 number;
  
    lc_ind_t varchar(5);
  
  BEGIN
    pn_cerr := 0;
    l_usua  := pv_usua;
    l_ndoc  := pn_ndoc;
  
    l_fecGuia := pd_fguia;
  
    -- ELIMINAR AQPB609L
    begin
      delete from aqpb609l a
       where a.aqpb609lflst = pd_fsys
         and a.aqpb609lulst = l_usua;
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    -- PGCOD DEL USUARIO
    begin
      select f.pgcodac into l_PgcodAc from FST746 f Where Ubuser = l_usua;
    EXCEPTION
      when others then
        l_PgcodAc := 1;
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
        pv_merr := 'Error_obtener_pgcodac';
    end;
  
    l_encontrado := 'N';
    --CURSOR AQPB608
    /*for j in lst_aqpb608(pn_cta, pn_ope, l_fecGuia) loop
      begin
        insert into AQPB609L
          (AQPB609LPGCOD, --1
           AQPB609LMOD, --2
           AQPB609LSUC, --3
           AQPB609LMON, --4
           AQPB609LPAP, --5
           AQPB609LNCTA, --6
           AQPB609LNOPE, --7
           AQPB609LSOPE, --8
           AQPB609LTOPE, --9
           AQPB609LINS, --10
           AQPB609LFIMP, --11
           AQPB609LPGCODT, --12
           AQPB609LSUCT, --13
           AQPB609LMODT, --14
           AQPB609LTRANT, --15
           AQPB609LRELT, --16
           AQPB609LFCON, --17
           AQPB609LF608, --18           
           AQPB609LPAIS,
           AQPB609LTDOC,
           AQPB609LNDOC,
           AQPB609LFLST, --19
           AQPB609LULST, --20
           AQPB609LMERR --21
           )
        values
          (j.AQPB608PGCODC, --1
           j.AQPB608MODC, --2
           j.AQPB608SUCC, --3
           j.AQPB608MONC, --4
           j.AQPB608PAPC, --5
           j.AQPB608CTAC, --6
           j.AQPB608OPEC, --7
           j.AQPB608SOPEC, --8
           j.AQPB608TOPEC, --9
           j.AQPB608INSTAN, --10
           j.AQPB608FIMP, --11
           j.AQPB608PGCODT, --12
           j.AQPB608ITSUC, --13
           j.AQPB608ITMOD, --14
           j.AQPB608ITTRAN, --15
           j.AQPB608ITNREL, --16
           j.AQPB608ITFCON, --17
           'S', --18
           pn_pais,
           pn_tdoc,
           l_ndoc,
           pd_fsys, --19
           l_usua, --20
           '' --21
           );
        commit;
        l_encontrado := 'S';
      EXCEPTION
        when others then
          my_errm := SQLERRM;
          null;
      end;
    end loop;*/
  
    if l_encontrado = 'N' then
      for k in lst_fsd010(pn_cta, pn_ope, l_PgcodAc, l_fecGuia) loop
        --sp_cr_val_modulo_2(k.Aomod, l_flag_Mod);
        l_flag_Mod := 'S'; --apachecoh 2023.07.31
        begin
          sp_cr_validar_credito_N(k.Aomod,
                                  k.Aocta,
                                  k.Aooper,
                                  lv_flagCanN,
                                  lv_flagEstN,
                                  ld_fecha99,
                                  ln_estadoC);
        exception
          when others then
            null;
        end;
        if lv_flagCanN = 'C' then
          sp_cr_dat_credito_2(l_PgcodAc,
                              k.Aocta,
                              k.Aooper,
                              k.Aomod,
                              l_PgcodC,
                              l_SucC,
                              l_ModC,
                              l_MonC,
                              l_PapC,
                              l_NroCta,
                              l_OpeC,
                              l_SubopeC,
                              l_TipOpeC);
        
          sp_cr_val_contancia_2(l_PgcodC,
                                l_SucC,
                                l_ModC,
                                l_MonC,
                                l_PapC,
                                l_NroCta,
                                l_OpeC,
                                l_SubopeC,
                                l_TipOpeC,
                                l_Flag608,
                                l_FlagImp);
        
          sp_cr_val_estado_2(l_PgcodC,
                             k.Aocta,
                             k.Aomod,
                             k.Aooper,
                             l_SucC,
                             l_MonC,
                             l_PapC,
                             l_TipOpeC,
                             l_fecGuia,
                             lv_flagCan,
                             ld_fecha99,
                             ln_estadoC);
        
          if lv_flagCan = 'S' then
          
            --apachecoh 2024.02.27 No muestra castigados, judiciales o en venta 
            /*lv_flCasti := 'N';
            begin
              select 'S'
                into lv_flCasti
                from fsd010
               where aomod in (200, 33, 65)
                 and aocta = k.Aocta
                 and aooper = k.Aooper
                 and rownum = 1;
            exception
              when others then
                lv_flCasti := 'N';
            end;
            if lv_flCasti = 'N' then*/
              if ld_fecha99 >= l_fecGuia then
                begin
                  insert into AQPB609L
                    (AQPB609LPGCOD, --1
                     AQPB609LMOD, --2
                     AQPB609LSUC, --3
                     AQPB609LMON, --4
                     AQPB609LPAP, --5
                     AQPB609LNCTA, --6
                     AQPB609LNOPE, --7
                     AQPB609LSOPE, --8
                     AQPB609LTOPE, --9
                     AQPB609LINS, --10
                     AQPB609LFIMP, --11
                     AQPB609LPGCODT, --12
                     AQPB609LSUCT, --13
                     AQPB609LMODT, --14
                     AQPB609LTRANT, --15
                     AQPB609LRELT, --16
                     AQPB609LFCON, --17
                     AQPB609LF608, --18
                     AQPB609LPAIS,
                     AQPB609LTDOC,
                     AQPB609LNDOC,
                     AQPB609LFLST, --19
                     AQPB609LULST, --20
                     AQPB609LMERR --21
                     )
                  values
                    (l_PgcodC, --1
                     l_ModC, --2
                     l_SucC, --3
                     l_MonC, --4
                     l_PapC, --5
                     l_NroCta, --6
                     l_OpeC, --7
                     l_SubopeC, --8
                     l_TipOpeC, --9
                     NULL, --10
                     l_FlagImp, --11
                     NULL, --12
                     NULL, --13
                     NULL, --14
                     NULL, --15
                     NULL, --16
                     ld_fecha99, --17
                     l_Flag608, --18
                     pn_pais,
                     pn_tdoc,
                     l_ndoc,
                     pd_fsys, --19
                     l_usua, --20
                     '');
                  commit;
                EXCEPTION
                  when others then
                    my_errm := SQLERRM;
                    null;
                end;
              end if;
            --end if;
          end if;
        
        end if;
      end loop;
    
    end if;
  
  END sp_cr_generar_lst_crd_2;

  --**********************************************************************************************************--  
  --busqueda por cuenta
  procedure sp_cr_generar_lst_crd_3(pn_pais  in number,
                                    pn_tdoc  in number,
                                    pn_ndoc  in varchar2,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pv_usua  in varchar2,
                                    pd_fguia in date,
                                    pd_fsys  in date,
                                    pn_cerr  out number,
                                    pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    cursor lst_aqpb608(cuenta number, operacion number, FecGuia date) is
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.hcmod, h.hsucor, h.htran, h.hnrel, h.hfcon
                from fsh015 h
                join fsh016 i
                  on h.pgcod = i.pgcod
                 and h.hcmod = i.hcmod
                 and h.hsucor = i.hsucor
                 and h.htran = i.htran
                 and h.hnrel = i.hnrel
                 and h.hfcon = i.hfcon
               where i.hcta = cuenta
                 and i.hoper = operacion
                 and h.hccorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a
       where a.aqpb608pgcodc = 1
         and a.aqpb608ctac = cuenta
         and a.aqpb608opec = operacion
         and a.aqpb608pgcodt IS NOT NULL
         and (a.aqpb608pgcodt, a.aqpb608itmod, a.aqpb608itsuc,
              a.aqpb608ittran, a.aqpb608itnrel, a.aqpb608itfcon) in
             (select h.pgcod, h.itmod, h.itsuc, h.ittran, h.itnrel, h.itfcon
                from fsd015 h
                join fsd016 i
                  on h.pgcod = i.pgcod
                 and h.itmod = i.itmod
                 and h.itsuc = i.itsuc
                 and h.ittran = i.ittran
                 and h.itnrel = i.itnrel
                 and h.itfcon = i.itfval
               where i.ctnro = cuenta
                 and i.itoper = operacion
                 and h.itcorr = 0)
      union
      select /*+ all_rows*/
       a.AQPB608FIMP,
       a.AQPB608PGCODC,
       a.AQPB608MODC,
       a.AQPB608SUCC,
       a.AQPB608MONC,
       a.AQPB608PAPC,
       a.AQPB608CTAC,
       a.AQPB608OPEC,
       a.AQPB608SOPEC,
       a.AQPB608TOPEC,
       a.AQPB608PGCODT,
       a.AQPB608ITSUC,
       a.AQPB608ITMOD,
       a.AQPB608ITTRAN,
       a.AQPB608ITNREL,
       a.AQPB608ITFCON,
       a.AQPB608INSTAN
        from aqpb608 a, fsd010 b
       where a.aqpb608pgcodc = 1
         and a.aqpb608modc = b.aomod
         and a.aqpb608monc = b.aomda
         and a.aqpb608papc = b.aopap
         and a.aqpb608ctac = b.aocta
         and a.aqpb608opec = b.aooper
         and b.aostat = 99
         and b.aocta = cuenta
         and b.aooper = operacion
         and a.aqpb608modc in (33, 200)
         and b.aomod in (select modulo from fst111 where dscod = 50);
    --and AQPB608ITFCON >= FecGuia;
  
    cursor lst_fsd010(cuenta number, ln_pgcod number, FecGuia date) is
      select distinct aomod, aocta, aooper
        from fsd010
       where pgcod = ln_pgcod
         and aocta = cuenta
         and (aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo != 116) or aomod = 117)
         and aomod not in (200, 33, 65)
      --and aofe99 >= fecguia
       order by pgcod, aocta;
  
    l_PGCODAC  NUMBER(3);
    l_fecGuia  DATE;
    l_flag_Mod VARCHAR2(1);
  
    l_PgcodC  NUMBER;
    l_SucC    NUMBER;
    l_ModC    NUMBER;
    l_MonC    NUMBER;
    l_PapC    NUMBER;
    l_NroCta  NUMBER;
    l_OpeC    NUMBER;
    l_SubopeC NUMBER;
    l_TipOpeC NUMBER;
    l_FlagImp VARCHAR2(1);
    l_flag608 VARCHAR2(1);
  
    lv_flagCan varchar(1);
    lv_flCasti varchar(1);
    ln_estadoC number(3);
  
    l_encontrado VARCHAR2(1);
    lv_flagCanN  varchar2(1);
    lv_flagEstN  varchar2(1);
  
    l_ndoc CHARACTER(12);
    l_usua CHARACTER(10);
  
    ld_fecha99 DATE;
  
    ln_ContEst number(5);
  
    ln_sld_011 number;
    ln_sld_175 number;
    lc_ind_t   varchar(5);
  
  BEGIN
    pn_cerr := 0;
    l_usua  := pv_usua;
    l_ndoc  := pn_ndoc;
  
    l_fecGuia := pd_fguia;
  
    -- ELIMINAR AQPB609L
    begin
      delete from aqpb609l a
       where a.aqpb609lflst = pd_fsys
         and a.aqpb609lulst = l_usua;
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
  
    -- PGCOD DEL USUARIO
    begin
      select f.pgcodac into l_PgcodAc from FST746 f Where Ubuser = l_usua;
    EXCEPTION
      when others then
        l_PgcodAc := 1;
        my_errm   := SQLERRM;
        pv_merr   := 'Error_obtener_pgcodac';
    end;
  
    --CURSOR DE CREDITOS POR CTA
    for k in lst_fsd010(pn_cta, l_PgcodAc, l_fecGuia) loop
      --CURSOR AQPB608
      l_encontrado := 'N';
      /*for j in lst_aqpb608(k.Aocta, k.Aooper, l_fecGuia) loop
        begin
          insert into AQPB609L
            (AQPB609LPGCOD, --1
             AQPB609LMOD, --2
             AQPB609LSUC, --3
             AQPB609LMON, --4
             AQPB609LPAP, --5
             AQPB609LNCTA, --6
             AQPB609LNOPE, --7
             AQPB609LSOPE, --8
             AQPB609LTOPE, --9
             AQPB609LINS, --10
             AQPB609LFIMP, --11
             AQPB609LPGCODT, --12
             AQPB609LSUCT, --13
             AQPB609LMODT, --14
             AQPB609LTRANT, --15
             AQPB609LRELT, --16
             AQPB609LFCON, --17
             AQPB609LF608, --18           
             AQPB609LPAIS,
             AQPB609LTDOC,
             AQPB609LNDOC,
             AQPB609LFLST, --19
             AQPB609LULST, --20
             AQPB609LMERR --21
             )
          values
            (j.AQPB608PGCODC, --1
             j.AQPB608MODC, --2
             j.AQPB608SUCC, --3
             j.AQPB608MONC, --4
             j.AQPB608PAPC, --5
             j.AQPB608CTAC, --6
             j.AQPB608OPEC, --7
             j.AQPB608SOPEC, --8
             j.AQPB608TOPEC, --9
             j.AQPB608INSTAN, --10
             j.AQPB608FIMP, --11
             j.AQPB608PGCODT, --12
             j.AQPB608ITSUC, --13
             j.AQPB608ITMOD, --14
             j.AQPB608ITTRAN, --15
             j.AQPB608ITNREL, --16
             j.AQPB608ITFCON, --17
             'S', --18
             pn_pais,
             pn_tdoc,
             l_ndoc,
             pd_fsys, --19
             l_usua, --20
             '' --21
             );
          commit;
          l_encontrado := 'S';
        EXCEPTION
          when others then
            my_errm := SQLERRM;
            null;
        end;
      end loop;*/
      if l_encontrado = 'N' then
        begin
          sp_cr_validar_credito_N(k.Aomod,
                                  k.Aocta,
                                  k.Aooper,
                                  lv_flagCanN,
                                  lv_flagEstN,
                                  ld_fecha99,
                                  ln_estadoC);
        exception
          when others then
            null;
        end;
        if lv_flagCanN = 'C' then
          sp_cr_dat_credito_2(l_PgcodAc,
                              k.Aocta,
                              k.Aooper,
                              k.Aomod,
                              l_PgcodC,
                              l_SucC,
                              l_ModC,
                              l_MonC,
                              l_PapC,
                              l_NroCta,
                              l_OpeC,
                              l_SubopeC,
                              l_TipOpeC);
        
          sp_cr_val_contancia_2(l_PgcodC,
                                l_SucC,
                                l_ModC,
                                l_MonC,
                                l_PapC,
                                l_NroCta,
                                l_OpeC,
                                l_SubopeC,
                                l_TipOpeC,
                                l_Flag608,
                                l_FlagImp);
        
          /*sp_cr_val_estado_2(l_PgcodC,
          k.Aocta,
          k.Aomod,
          k.Aooper,
          l_SucC,
          l_MonC,
          l_PapC,
          l_TipOpeC,
          l_fecGuia,
          lv_flagCan,
          ld_fecha99,
          ln_estadoC);*/
        
          --apachecoh 2024.02.27 No muestra castigados, judiciales o en venta 
          /*lv_flCasti := 'N';
          begin
            select 'S'
              into lv_flCasti
              from fsd010
             where aomod in (200, 33, 65)
               and aocta = k.Aocta
               and aooper = k.Aooper
               and rownum = 1;
          exception
            when others then
              lv_flCasti := 'N';
          end;
          if lv_flCasti = 'N' then*/          
            if ld_fecha99 >= l_fecGuia then
              begin
                insert into AQPB609L
                  (AQPB609LPGCOD, --1
                   AQPB609LMOD, --2
                   AQPB609LSUC, --3
                   AQPB609LMON, --4
                   AQPB609LPAP, --5
                   AQPB609LNCTA, --6
                   AQPB609LNOPE, --7
                   AQPB609LSOPE, --8
                   AQPB609LTOPE, --9
                   AQPB609LINS, --10
                   AQPB609LFIMP, --11
                   AQPB609LPGCODT, --12
                   AQPB609LSUCT, --13
                   AQPB609LMODT, --14
                   AQPB609LTRANT, --15
                   AQPB609LRELT, --16
                   AQPB609LFCON, --17
                   AQPB609LF608, --18
                   AQPB609LPAIS,
                   AQPB609LTDOC,
                   AQPB609LNDOC,
                   AQPB609LFLST, --19
                   AQPB609LULST, --20
                   AQPB609LMERR --21
                   )
                values
                  (l_PgcodC, --1
                   l_ModC, --2
                   l_SucC, --3
                   l_MonC, --4
                   l_PapC, --5
                   l_NroCta, --6
                   l_OpeC, --7
                   l_SubopeC, --8
                   l_TipOpeC, --9
                   NULL, --10
                   l_FlagImp, --11
                   NULL, --12
                   NULL, --13
                   NULL, --14
                   NULL, --15
                   NULL, --16
                   ld_fecha99, --17
                   l_Flag608, --18
                   pn_pais,
                   pn_tdoc,
                   l_ndoc,
                   pd_fsys, --19
                   l_usua, --20
                   '');
                commit;
              EXCEPTION
                when others then
                  my_errm := SQLERRM;
                  null;
              end;
            end if;
          --end if;
        end if;
      end if;
    end loop;
  
  END sp_cr_generar_lst_crd_3;
  --**********************************************************************************************************--  
  procedure sp_cr_validar_credito_N(pn_modc   in number,
                                    pn_ctac   in number,
                                    pn_opec   in number,
                                    pv_cancel out varchar2,
                                    pv_estado out varchar2,
                                    pd_cancel out date,
                                    pn_estado out number) is
    pn_flag number := 0;
    my_errm varchar2(500);
  BEGIN
    --pv_cancel (N - No Cancelado / C - Cancelado)
    --pv_estado (N - Normal, C - Castigado, J - Judicial, P - Ref.Judicial, V - Venta Cartera)
    --pd_cancel (Fecha de cancelación)
    --pn_estado (Estado Cancelacion FST026)
  
    --Validar si esta completamente CANCELADO
    begin
      select aostat, 'N'
        into pn_estado, pv_cancel
        from fsd010
       where aocta = pn_ctac
         and aooper = pn_opec
         and (aomod in (select modulo from fst111 where dscod = 50) or
             aomod = 65 or aomod = 117)
         and aostat <> 99
       order by aostat desc              
       fetch first 1 row only; --apachecoh 2024.06.26
    exception
      when others then
        pv_cancel := 'C';
        pv_estado := 'N';
        begin
          select aostat, aofe99
            into pn_estado, pd_cancel
            from fsd010
           where aocta = pn_ctac
             and aooper = pn_opec
             and (aomod in (select modulo from fst111 where dscod = 50) or
                 aomod = 65 or aomod = 117)
             and aostat = 99
           order by aofe99 desc                  
           fetch first 1 row only; --apachecoh 2024.06.26
        exception
          when others then
            my_errm   := SQLERRM;
            pn_estado := 99;
            pd_cancel := null;
        end;
    end;
    --Validar la fecha de cancelación
--cambios inicio kvalenciac 23/01/2025
--valido si es créidto vendido

     begin
        select 'V'
          into pv_estado
        from fsr011 f, fsd010 f10
       Where f.R2cod  =  f10.pgcod
         and f.R2mod  = f10.aomod
         and f.R2suc  = f10.aosuc
         and f.R2mda  = f10.aomda
         and f.R2pap  = f10.aopap
         and f.R2cta  = f10.aocta
         and f.R2oper = f10.aooper
         and f.R2sbop = f10.aosbop
         and f.R2tope = f10.aotope
         and f.Relcod = 37
         and f.r1cta = pn_ctac
         and f.r1oper= pn_opec
         and (f10.aomod in (select modulo from fst111 where dscod = 50) or
                 f10.aomod = 65)
         and f10.AOSTAT <> 99
         and rownum = 1; 
        exception
          when others then
            pv_estado := 'N';
        end;
     --si no está vendido puede estar castigado
     if pv_estado = 'N' then
      begin
        select 'C'
          into pv_estado
        from fsr011 f, fsd010 f10
       Where f.R2cod  =  f10.pgcod
         and f.R2mod  = f10.aomod
         and f.R2suc  = f10.aosuc
         and f.R2mda  = f10.aomda
         and f.R2pap  = f10.aopap
         and f.R2cta  = f10.aocta
         and f.R2oper = f10.aooper
         and f.R2sbop = f10.aosbop
         and f.R2tope = f10.aotope
         and f.Relcod = 33
         and f.r1cta = pn_ctac
         and f.r1oper= pn_opec
         and (f10.aomod in (select modulo from fst111 where dscod = 50) or
                 f10.aomod = 65)
         and f10.AOSTAT=90
         and f.r2mod=33
         and rownum = 1; 
        exception
          when others then
            pv_estado := 'N';
        end;   
      end if;
      --Validar si se encuentra en estado JUDICIAL
     if pv_estado = 'N' then
        begin
           select 'J'
            into pv_estado
          from fsr011 f, fsd010 f10
         Where f.R2cod  =  f10.pgcod
           and f.R2mod  = f10.aomod
           and f.R2suc  = f10.aosuc
           and f.R2mda  = f10.aomda
           and f.R2pap  = f10.aopap
           and f.R2cta  = f10.aocta
           and f.R2oper = f10.aooper
           and f.R2sbop = f10.aosbop
           and f.R2tope = f10.aotope
           and f.Relcod = 34
           and f.r1cta = pn_ctac
           and f.r1oper= pn_opec
           and (f10.aomod in (select modulo from fst111 where dscod = 50) or
                   f10.aomod = 65)
           and f10.AOSTAT<>99
           and f.r2mod=200
           and rownum = 1;       
        exception
          when others then
            pv_estado := 'N';
        end;
      end if;       
      --Validar si se encuentra en estado de ABOGADOS 
      if pv_estado = 'N' then
        begin
                select 'A'
                  into pv_estado
                  from fsd010 f
                 where f.pgcod = 1
                   and f.aomod = pn_modc
                   and f.aocta = pn_ctac
                   and f.aooper = pn_opec
                   and f.aotope = 550
                   and f.aostat <> 99;
         exception
            when others then
             pv_estado := 'N';
         end;   
       end if;  
--cambios fin kvalenciac 23/01/2025
/* comentado 21/01/2025   --Validar si se encuentra en estado CASTIGADO
    begin
      select 'C'
        into pv_estado
        from fsr011 f, fsd010 f10
       Where f.R1COD = 1
            --and f.R1MOD = 200
         and f.R1CTA = pn_ctac --cta
         and f.R1OPER = pn_opec -- operacion
         and f.R2MOD = 33
         and f10.PGCOD = f.R2COD
         and f10.AOMOD = f.R2MOD
         and f10.AOCTA = f.R2CTA
         and f10.AOOPER = f.R2OPER
         and f10.AOSBOP = f.R2SBOP
         and f10.AOSTAT = 90
         and f.R1SBOP = (select max(aosbop)
                           from fsd010
                          Where pgcod = 1
                            and aocta = R1CTA
                            and aooper = R1OPER)
         and relcod = 33
         and rownum = 1;
    exception
      when others then
        pv_estado := 'N';
    end;
    --Validar si se encuentra en estado JUDICIAL
    if pv_estado = 'N' then
      begin
        select 'J'
          into pv_estado
          from fsr011 f, fsd010 f10
         Where f.R1COD = 1
           and f.R1MOD = pn_modc --mod
           and f.R1CTA = pn_ctac --cta
           and f.R1OPER = pn_opec -- operacion
           and f.R2MOD = 200
           and f10.PGCOD = f.R2COD
           and f10.AOMOD = f.R2MOD
           and f10.AOCTA = f.R2CTA
           and f10.AOOPER = f.R2OPER
           and f10.AOSBOP = f.R2SBOP
           and f10.AOSTAT <> 99
           and f.R1SBOP = (select max(aosbop)
                             from fsd010
                            Where pgcod = 1
                              and aocta = R1CTA
                              and aooper = R1OPER)
           and relcod = 34
           and rownum = 1;
      exception
        when others then
          pv_estado := 'N';
      end;
      --Validar si se encuentra en estado REFINANCIADO JUDICIAL   
      if pv_estado = 'N' then
        null;
        \*begin
          select 'P'
            into pv_estado
            from fsr011 f, fsd010 f10
           Where f.R1COD = 1
             and f.R1MOD = 200
             and f.R1CTA = pn_ctac --cta
             and f.R1OPER = pn_opec -- operacion
             and f.R2MOD = pn_modc --mod
             and f10.PGCOD = f.R2COD
             and f10.AOMOD = f.R2MOD
             and f10.AOCTA = f.R2CTA
             and f10.AOOPER = f.R2OPER
             and f10.AOSBOP = f.R2SBOP
             and f10.AOSTAT <> 99
             and f.R1SBOP = (select max(aosbop)
                               from fsd010
                              Where pgcod = 1
                                and aocta = R1CTA
                                and aooper = R1OPER)
             and relcod = 35
             and rownum = 1;
        exception
          when others then
            pv_estado := 'N';
        end;*\
        --Validar si se encuentra en estado VENTA CARTERA    
        if pv_estado = 'N' then
          begin
            select 'V'
              into pv_estado
              from fsr011 f, fsd010 f10
             Where f.R1COD = 1
               and f.R1CTA = pn_ctac --cta
               and f.R1OPER = pn_opec -- operacion
               and f.R2MOD = 65
               and f10.PGCOD = f.R2COD
               and f10.AOMOD = f.R2MOD
               and f10.AOCTA = f.R2CTA
               and f10.AOOPER = f.R2OPER
               and f10.AOSBOP = f.R2SBOP
               and f10.AOSTAT <> 99
               and f.R1SBOP = (select max(aosbop)
                                 from fsd010
                                Where pgcod = 1
                                  and aocta = R1CTA
                                  and aooper = R1OPER)
               and relcod = 37
               and rownum = 1;
          exception
            when others then
              pv_estado := 'N';
          end;
          --Validar si se encuentra en estado de ABOGADOS 
          if pv_estado = 'N' then
            begin
              select 'A'
                into pv_estado
                from fsd010 f
               where f.pgcod = 1
                 and f.aomod = pn_modc
                 and f.aocta = pn_opec
                 and f.aooper = pn_opec
                 and f.aotope = 550
                 and f.aostat <> 99;
            exception
              when others then
                pv_estado := 'N';
            end;
          end if;
        end if;
      end if;
    end if;*/
  
  END sp_cr_validar_credito_N;
  --**********************************************************************************************************--  
  procedure sp_cr_dat_credito_2(pn_pgcod  in number,
                                pn_cta    in number,
                                pv_ope    in number,
                                pn_mod    in number,
                                pn_pgcodO out number,
                                pn_sucO   out number,
                                pn_modO   out number,
                                pn_monO   out number,
                                pn_papO   out number,
                                pn_ctaO   out number,
                                pn_opeO   out number,
                                pn_sopeO  out number,
                                pn_topeO  out number) is
  
    my_errm VARCHAR2(32000);
  BEGIN
    begin
      select pgcod,
             aosuc,
             aomod,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope
        into pn_pgcodo,
             pn_suco,
             pn_modo,
             pn_mono,
             pn_papo,
             pn_ctao,
             pn_opeo,
             pn_sopeo,
             pn_topeo
        from fsd010 a
       where a.pgcod = pn_pgcod
         and a.aomod = pn_mod
         and a.aocta = pn_cta
         and a.aooper = pv_ope
         and (a.aomod in (select modulo from fst111 where dscod = 50) 
             or a.aomod = 65 or a.aomod = 117)
         and a.aosbop = (select max(b.Aosbop)
                           from fsd010 b
                          where b.Pgcod = a.Pgcod
                            and b.Aosuc = a.Aosuc
                            and b.Aomod = a.Aomod
                            and b.Aomda = a.Aomda
                            and b.Aopap = a.Aopap
                            and b.Aocta = a.Aocta
                            and b.Aooper = a.Aooper
                         /*and b.Aotope = a.Aotope*/
                         )
         and rownum = 1;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
  END sp_cr_dat_credito_2;

  --**********************************************************************************************************--  
  procedure sp_cr_val_estado_2(pn_pgcod   in number,
                               pn_cuenta  in number,
                               pn_modulo  in number,
                               pn_opera   in number,
                               pn_sucur   in number,
                               pn_moneda  in number,
                               pn_papel   in number,
                               pn_tope    in number,
                               pd_fecgui  in date,
                               pv_Flag    out varchar2,
                               pd_fecha99 out date,
                               pn_estado  out number) is
    my_errm VARCHAR2(32000);
  
    ln_PGCOD  NUMBER(3);
    ln_AOMOD  NUMBER(3);
    ln_AOSUC  NUMBER(3);
    ln_AOMDA  NUMBER(4);
    ln_AOPAP  NUMBER(4);
    ln_AOCTA  NUMBER(9);
    ln_AOOPER NUMBER(9);
    ln_AOSBOP NUMBER(3);
    ln_AOTOPE NUMBER(3);
  
    ln_saldo011 number;
    ln_saldo175 number;
    ln_ConEst   number;
    pv_cancel   varchar(2);
    pv_estado   varchar(2);
  
  BEGIN
    begin
      PQ_CR_VALI_CRED_CANC.sp_cr_validar_credito_N(pn_modulo,
                                                   pn_cuenta,
                                                   pn_opera,
                                                   pv_cancel,
                                                   pv_estado,
                                                   pd_fecha99,
                                                   pv_estado);
    exception
      when others then
        null;
    end;
    if pv_cancel = 'C' then
      pv_Flag := 'S';
    else
      pv_Flag := 'N';
    end if;
  
    /*begin
      select Aostat,
             aofe99,
             PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE
        into pv_estado,
             pd_fecha99,
             ln_PGCOD,
             ln_AOMOD,
             ln_AOSUC,
             ln_AOMDA,
             ln_AOPAP,
             ln_AOCTA,
             ln_AOOPER,
             ln_AOSBOP,
             ln_AOTOPE
        from fsd010 a
       where Pgcod = pn_pgcod
         and Aocta = pn_cuenta
         and Aomod = pn_modulo
         and Aooper = pn_opera --and Aofe99 >= pd_fecgui 
            --and Aosuc = pn_sucur --apachecoh 2023.06.30
         and Aomda = pn_moneda
         and Aopap = pn_papel;
      --and Aotope = pn_tope; --apachecoh 2023.06.30
      --and rownum = 1
      --order by Aosbop desc;
    EXCEPTION
      when too_many_rows then
        begin
          select Aostat,
                 aofe99,
                 PGCOD,
                 AOMOD,
                 AOSUC,
                 AOMDA,
                 AOPAP,
                 AOCTA,
                 AOOPER,
                 AOSBOP,
                 AOTOPE
            into pv_estado,
                 pd_fecha99,
                 ln_PGCOD,
                 ln_AOMOD,
                 ln_AOSUC,
                 ln_AOMDA,
                 ln_AOPAP,
                 ln_AOCTA,
                 ln_AOOPER,
                 ln_AOSBOP,
                 ln_AOTOPE
            from fsd010 a
           where Pgcod = pn_pgcod
             and Aocta = pn_cuenta
             and Aomod = pn_modulo
             and Aooper = pn_opera
                --and Aosuc = pn_sucur
             and Aomda = pn_moneda
             and Aopap = pn_papel
                --and Aotope = pn_tope
             and aosbop = (select max(b.Aosbop)
                             from fsd010 b
                            where b.Pgcod = pn_pgcod
                                 --and b.Aosuc = pn_sucur --apachecoh 2023.06.30
                              and b.Aomod = pn_modulo
                              and b.Aomda = pn_moneda
                              and b.Aopap = pn_papel
                              and b.Aocta = pn_cuenta
                              and b.Aooper = pn_opera
                           --and b.Aotope = pn_tope --apachecoh 2023.06.30
                           );
        EXCEPTION
          when others then
            my_errm := SQLERRM;
            null;
        end;
      when others then
        my_errm := SQLERRM;
        null;
    end;*/
  
    /*begin
      SELECT 1 INTO ln_ConEst FROM DUAL WHERE pv_estado = 99;
      SELECT COUNT(tpnro)
       INTO ln_ConEst
       FROM fst098
      WHERE pgcod = 1
        AND tpcod = 7750
        AND tpcorr >= 91
        AND tpcorr <= 100
        AND tpimp = 1
        AND tpnro = pv_estado;
    EXCEPTION
      when others then
        ln_ConEst := 0;
        my_errm   := SQLERRM;
    end;*/
  
    /*if ln_ConEst > 0 then
      ln_saldo011 := fn_get_saldo_fsd011(ln_PGCOD,
                                         ln_AOMOD,
                                         ln_AOSUC,
                                         ln_AOMDA,
                                         ln_AOPAP,
                                         ln_AOCTA,
                                         ln_AOOPER,
                                         ln_AOSBOP,
                                         ln_AOTOPE);
      if ln_saldo011 > 0 or ln_saldo011 is null then
        ln_saldo175 := fn_get_saldo_JAQL175(ln_PGCOD,
                                            ln_AOMOD,
                                            ln_AOSUC,
                                            ln_AOMDA,
                                            ln_AOPAP,
                                            ln_AOCTA,
                                            ln_AOOPER,
                                            ln_AOSBOP,
                                            ln_AOTOPE,
                                            pv_estado);
      end if;
    end if;*/
  
    /*if pv_estado = 99 then
      pv_Flag := 'S';
    else
      if ln_saldo011 = 0 or ln_saldo175 = 0 then
        pv_Flag := 'S';
      else
        pv_Flag := 'N';
      end if;
    end if;*/
    --pv_Flag cancelado 'S'
    --pv_Flag pendiente 'N'
  END sp_cr_val_estado_2;

  --**********************************************************************************************************--  
  procedure sp_cr_val_contancia_2(pn_pgcod   in number,
                                  pn_suc     in number,
                                  pn_mod     in number,
                                  pn_mon     in number,
                                  pn_pap     in number,
                                  pn_cta     in number,
                                  pn_ope     in number,
                                  pn_sope    in number,
                                  pn_tope    in number,
                                  pv_Flag608 out varchar,
                                  pv_FlagImp out varchar) is
    ln_correlativo number;
  BEGIN
    pv_Flag608 := 'S';
    pv_FlagImp := 'S';
    --apachecoh 2023.10.18
    begin
      select AQPB608FIMP
        into pv_FlagImp
        from AQPB608
       Where AQPB608PGCODC = pn_pgcod
         and AQPB608MODC = pn_mod
         and AQPB608SUCC = pn_suc
         and AQPB608MONC = pn_mon
         and AQPB608PAPC = pn_pap
         and AQPB608CTAC = pn_cta
         and AQPB608OPEC = pn_ope
         and AQPB608SOPEC = pn_sope
         and AQPB608TOPEC = pn_tope
         and rownum = 1;
    exception
      when others then
        begin
          select AQPB608FIMP
            into pv_FlagImp
            from AQPB608
           Where AQPB608PGCODC = pn_pgcod
             and AQPB608MODC in (33, 200)
             and AQPB608SUCC = pn_suc
             and AQPB608MONC = pn_mon
             and AQPB608PAPC = pn_pap
             and AQPB608CTAC = pn_cta
             and AQPB608OPEC = pn_ope
             and AQPB608SOPEC = pn_sope
                --and AQPB608TOPEC = pn_tope
             and rownum = 1;
        exception
          when others then
            pv_Flag608 := 'N';
            pv_FlagImp := 'N';
        end;
    end;
  
    --apachecoh 2023.07.31
    /*begin          
      select 1, AQPB608FIMP
        INTO ln_correlativo, pv_FlagImp
        from AQPB608
       Where AQPB608PGCODC = pn_pgcod
         and AQPB608MODC = pn_mod
         and AQPB608SUCC = pn_suc
         and AQPB608MONC = pn_mon
         and AQPB608PAPC = pn_pap
         and AQPB608CTAC = pn_cta
         and AQPB608OPEC = pn_ope
         and AQPB608SOPEC = pn_sope
         and AQPB608TOPEC = pn_tope
         and (AQPB608MODC IN (33, 200) OR
             (AQPB608PGCODT IS NOT NULL AND
             (AQPB608PGCODT, AQPB608ITMOD, AQPB608ITSUC, AQPB608ITTRAN,
              AQPB608ITNREL, AQPB608ITFCON) in
             (select h.pgcod, h.hcmod, h.hsucor, h.htran, h.hnrel, h.hfcon
                  from fsh015 h
                  join fsh016 i
                    on h.pgcod = i.pgcod
                   and h.hcmod = i.hcmod
                   and h.hsucor = i.hsucor
                   and h.htran = i.htran
                   and h.hnrel = i.hnrel
                   and h.hfcon = i.hfcon
                 where i.hcta = pn_cta
                   and h.hccorr = 0)) OR
             (AQPB608PGCODT IS NOT NULL AND
             (AQPB608PGCODT, AQPB608ITMOD, AQPB608ITSUC, AQPB608ITTRAN,
              AQPB608ITNREL, AQPB608ITFCON) in
             (select h.pgcod,
                       h.itmod,
                       h.itsuc,
                       h.ittran,
                       h.itnrel,
                       h.itfcon
                  from fsd015 h
                  join fsd016 i
                    on h.pgcod = i.pgcod
                   and h.itmod = i.itmod
                   and h.itsuc = i.itsuc
                   and h.ittran = i.ittran
                   and h.itnrel = i.itnrel
                   and h.itfcon = i.itfval
                 where i.ctnro = pn_cta
                   and h.itcorr = 0)));
    
      IF ln_correlativo IS NULL OR ln_correlativo = 0 THEN
        pv_Flag608 := 'N';
        pv_FlagImp := 'N';
      END IF;
    EXCEPTION
      when others then
        pv_Flag608 := 'N';
      
        --apachecoh 2023.07.31
        begin
          select AQPB608FIMP
            INTO pv_FlagImp
            from AQPB608
           Where AQPB608PGCODC = pn_pgcod
             and AQPB608MODC = pn_mod
             and AQPB608SUCC = pn_suc
             and AQPB608MONC = pn_mon
             and AQPB608PAPC = pn_pap
             and AQPB608CTAC = pn_cta
             and AQPB608OPEC = pn_ope
             and AQPB608SOPEC = pn_sope
             and AQPB608TOPEC = pn_tope
             and rownum = 1;
        exception
          when others then
            pv_FlagImp := 'N';
        end;
      
      --pv_FlagImp := 'N';
    end;*/
  END sp_cr_val_contancia_2;

  --**********************************************************************************************************--  
  procedure sp_cr_val_modulo_2(pn_modulo  in number,
                               pv_FlagMod out varchar2) is
  
    CURSOR lst_modulos IS
      select t111.modulo Cur_Mod
        from fst111 t111
       where t111.Dscod = 50
         and t111.Modulo != 116;
  
  BEGIN
    begin
      FOR i IN lst_modulos LOOP
        if i.Cur_Mod = pn_modulo then
          pv_FlagMod := 'S';
        else
          pv_FlagMod := 'N';
        end if;
        EXIT WHEN pv_FlagMod = 'S';
      END LOOP;
    EXCEPTION
      when others then
        pv_FlagMod := 'N';
    end;
  END sp_cr_val_modulo_2;

  --**********************************************************************************************************--  
  procedure sp_cr_val_TipOpe_gr_2(pn_pgcodc  in NUMBER,
                                  pn_modc    in NUMBER,
                                  pn_succ    in NUMBER,
                                  pn_monc    in NUMBER,
                                  pn_papc    in NUMBER,
                                  pn_ctac    in NUMBER,
                                  pn_opec    in NUMBER,
                                  pn_sopec   in NUMBER,
                                  pn_topec   in NUMBER,
                                  pv_FlagGar out varchar2,
                                  pn_tipope  out number) is
  
    CURSOR LST_GARANT(LN_INSTANCIA NUMBER) IS
      select sng122pgc,
             sng122mod,
             sng122suc,
             sng122mda,
             sng122pap,
             sng122cta,
             sng122oper,
             sng122sbop,
             sng122tope
        from sng122 g
       where g.sng122inst = LN_INSTANCIA
         and g.sng122tope in (select trim(Tpdesc)
                                From fst098
                               Where Pgcod = 1
                                 And Tpcod = 7750
                                 And Tpnro = 1
                                 And Tpcorr >= 21
                                 And Tpcorr <= 50);
  
    ln_CurTO    number;
    l_instancia number;
  
    ln_PGCOD  NUMBER(3);
    ln_AOMOD  NUMBER(3);
    ln_AOSUC  NUMBER(3);
    ln_AOMDA  NUMBER(4);
    ln_AOPAP  NUMBER(4);
    ln_AOCTA  NUMBER(9);
    ln_AOOPER NUMBER(9);
    ln_AOSBOP NUMBER(3);
    ln_AOTOPE NUMBER(3);
  
    pn_flag NUMBER(4);
    --pn_tipope number;
    my_errm VARCHAR2(32000);
  BEGIN
    --OBTENEMOS INSTANCIA
    begin
      select f.xwfprcins
        into l_instancia
        from xwf700 f
       where f.xwfempresa = pn_pgcodc
         and f.xwfsucursal = pn_succ
         and f.xwfmodulo = pn_modc
         and f.xwfmoneda = pn_monc
         and f.xwfpapel = pn_papc
         and f.xwfcuenta = pn_ctac
         and f.xwfoperacion = pn_opec
         and f.xwfsubope = pn_sopec
         and f.xwftipope = pn_topec
         and f.xwfcar3 = '1';
    EXCEPTION
      when others then
        begin
          select f.xwfprcins
            into l_instancia
            from xwf700 f
           where f.xwfempresa = pn_pgcodc
             and f.xwfsucursal = pn_succ
             and f.xwfmodulo = pn_modc
             and f.xwfmoneda = pn_monc
             and f.xwfpapel = pn_papc
             and f.xwfcuenta = pn_ctac
             and f.xwfoperacion = pn_opec
             and f.xwfsubope = pn_sopec
             and f.xwftipope = pn_topec
             and f.xwfcar3 = '1'
             and rownum = 1;
        EXCEPTION
          when others then
            my_errm    := SQLERRM;
            pv_FlagGar := 'N';
        end;
    end;
  
    /*BEGIN
        select sng122pgc, 
               sng122mod, 
               sng122suc, 
               sng122mda, 
               sng122pap, 
               sng122cta, 
               sng122oper, 
               sng122sbop, 
               sng122tope  
          into  
               ln_PGCOD,
               ln_AOMOD,
               ln_AOSUC,
               ln_AOMDA,
               ln_AOPAP,
               ln_AOCTA,
               ln_AOOPER,
               ln_AOSBOP,
               ln_AOTOPE
          from sng122 g
         where g.sng122inst = l_instancia
           and g.sng122tope in 
           (select trim(Tpdesc)
                From fst098
               Where Pgcod = 1
                 And Tpcod = 7750
                 And Tpnro = 1
                 And Tpcorr >= 21
                 And Tpcorr <= 50)
          and rownum = 1;       
    EXCEPTION WHEN OTHERS THEN     
        my_errm    := SQLERRM;
        pv_FlagGar := 'N';
    END;*/
  
    pv_FlagGar := 'N';
    pn_tipope  := 0;
    --OBTENEMOS TIPO DE OPERACION DE GARANTIA
    FOR I IN LST_GARANT(l_instancia) LOOP
    
      pv_FlagGar := 'S';
      pn_tipope  := I.SNG122TOPE;
    
      pn_flag := 0;
      --
      BEGIN
        select count(*)
          into pn_flag
          from fsr011 g, fsd010 c
         where g.r2cod = I.SNG122PGC
           and g.r2mod = I.SNG122MOD
           and g.r2suc = I.SNG122SUC
           and g.r2mda = I.SNG122MOD
           and g.r2pap = I.SNG122MDA
           and g.r2cta = I.SNG122CTA
           and g.r2oper = I.SNG122OPER
           and g.r2sbop = I.SNG122SBOP
           and g.r2tope = I.SNG122TOPE
           and g.relcod = 50
           and c.pgcod = g.r1cod
           and c.aomod = g.r1mod
           and c.aosuc = g.r1suc
           and c.aomda = g.r1mda
           and c.aopap = g.r1pap
           and c.aocta = g.r1cta
           and c.aooper = g.r1oper
           and c.aosbop = g.r1sbop
           and c.aotope = g.r1tope
           and c.aostat <> 99
           and g.r1tope in (select trim(Tpdesc)
                              From fst098
                             Where Pgcod = 1
                               And Tpcod = 7750
                               And Tpnro = 1
                               And Tpcorr >= 21
                               And Tpcorr <= 50);
      EXCEPTION
        WHEN OTHERS THEN
          pv_FlagGar := 'N';
          return;
      END;
      IF pn_flag > 1 THEN
        pv_FlagGar := 'N';
        return;
      END IF;
    END LOOP;
  
    --
    /*  
    BEGIN
      select g.sng122tope
          into pn_tipope
          from sng122 g
      where g.sng122inst = l_instancia;
    EXCEPTION
      when others then
        begin
          select g.sng122tope
                 into pn_tipope
            from sng122 g
          where g.sng122inst = l_instancia
                and rownum = 1;       
        EXCEPTION
          when others then
            my_errm    := SQLERRM;
            pv_FlagGar := 'N';
        end;
    END;*/
    --OPCIONAL USAR ESTA TABLA 
    --select * from fsr011 where relcod = 50 and r011co = 'F' and r1 va la clave del credito  
    /*begin
      FOR i IN lst_tipope LOOP
        ln_CurTO := i.CodTO;
      
        if ln_CurTO = pn_tipope then
          pv_FlagGar := 'S';
        else
          pv_FlagGar := 'N';
        end if;
      
        EXIT WHEN pv_FlagGar = 'S';
      END LOOP;
    
    EXCEPTION
      when others then
        my_errm    := SQLERRM;
        pv_FlagGar := 'N';
    end;*/
  END sp_cr_val_TipOpe_gr_2;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Crd99(pn_pgcod  in number,
                              pn_itsuc  in number,
                              pn_itmod  in number,
                              pn_ittran in number,
                              pn_itnrel in number,
                              pn_fecpro in date,
                              pn_coderr out number,
                              lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd(n_nrocta number) IS
      select d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aotope,
             d.aosbop,
             d.aostat
        from fsd010 d
       where d.aocta = n_nrocta
         and d.aomod in (select t111.modulo
                           from fst111 t111
                          where t111.Dscod = 50
                            and t111.Modulo != 116)
         and d.aosbop = (select max(d1.AOSBOP)
                           from fsd010 d1
                          where d1.PGCOD = d.pgcod
                            and d1.AOMOD = d.aomod
                            and d1.AOMDA = d.aomda
                            and d1.AOPAP = d.aopap
                            and d1.AOCTA = d.aocta
                            and d1.AOSUC = d.aosuc
                            and d1.AOOPER = d.aooper
                            and d1.AOTOPE = d.aotope)
       order by d.PGCOD,
                d.AOMOD,
                d.AOMDA,
                d.AOPAP,
                d.AOCTA,
                d.AOSUC,
                d.AOOPER,
                d.AOSBOP;
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    ln_sld_011  number;
    ld_fecguia  date;
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  BEGIN
    ld_fecguia := fn_get_FecGuia();
  
    --obtenermos la clave del credito
    begin
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    /*    ln_pais := 604;
    ln_tdoc := 21; 
    ln_ndoc := rpad('29555982',12,' ');--'29278775    ';*/
  
    lv_flgCan := 'N';
  
    --Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          sp_cr_val_estado_2(T_pgcod,
                             T_aocta,
                             T_aomod,
                             T_aooper,
                             T_aosuc,
                             T_aomda,
                             T_aopap,
                             T_aotope,
                             ld_fecguia,
                             lv_flagCanc,
                             ld_fec99,
                             ln_estadoC);
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flag99 = 'N'o tiene obligaciones
    --        = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_Todos_Crd99;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Aval99(pn_pgcod  in number,
                               pn_itsuc  in number,
                               pn_itmod  in number,
                               pn_ittran in number,
                               pn_itnrel in number,
                               pn_fecpro in date,
                               pn_coderr out number,
                               lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) aosbop,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    pn_contador number;
    ln_sld_011  number;
    ld_fecguia  date;
  
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  
  BEGIN
    lv_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
  
    ld_fecguia := fn_get_FecGuia();
  
    --obtenermos la clave del credito
    begin
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        null;
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
  
    lv_flgCan := 'N';
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          sp_cr_val_estado_2(T_pgcod,
                             T_aocta,
                             T_aomod,
                             T_aooper,
                             T_aosuc,
                             T_aomda,
                             T_aopap,
                             T_aotope,
                             ld_fecguia,
                             lv_flagCanc,
                             ld_fec99,
                             ln_estadoC);
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flagAval = 'N'o tiene obligaciones
    --          = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_Todos_Aval99;

  --**********************************************************************************************************--  
  procedure sp_cr_val_Aval(pn_pgcodc  in number,
                           pn_modc    in number,
                           pn_succ    in number,
                           pn_monc    in number,
                           pn_papc    in number,
                           pd_ctac    in number,
                           pv_opec    in number,
                           pv_sopec   in number,
                           pv_topec   in number,
                           pn_ConTot  in number,
                           pn_ConIng  in number,
                           pv_NroCre  out varchar2,
                           pv_FecDes  out varchar2,
                           pv_ValDes  out varchar2,
                           pn_ConTotS out number,
                           pn_ConIngS out number) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) SBOPE,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    /*select f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, max(f.AOSBOP) SBOPE, f.AOTOPE, f.Aostat
     from fsd010 f
    where (f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER,
           f.AOTOPE) in --, f.AOSBOP
          (select x.xwfempresa, x.xwfmodulo,x.xwfsucursal, x.xwfmoneda, x.xwfpapel, x.xwfcuenta, x.xwfoperacion, x.xwftipope --, x.xwfsubope
             from xwf700 x
            where x.xwfcar3 = '1'
              and x.xwfprcins in
                  (select s.sng001inst
                     from sng003 s
                    where s.sng003cta = c_cta))
    group by f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, f.AOTOPE, f.Aostat, f.aofval
    order by f.aofval, f.AOCTA, f.AOOPER, f.AOMOD, f.AOSUC, f.AOTOPE;*/
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    ln_TmpCta number(10);
  
    lv_flgCan varchar2(2);
    lv_flgIni varchar2(2);
  
    pn_Contar number;
  BEGIN
    lv_flgIni  := 'N';
    pn_ConTotS := nvl(pn_ConTot, 0);
    pn_ConIngS := nvl(pn_ConIng, 0);
    --pn_ConIngT := nvl(pn_ConIng,0);
    if pn_ConIng > 0 then
      lv_flgIni := 'S';
    end if;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = pd_ctac OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
    if pn_ConTot = 0 and pn_ConIng = 0 then
      FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
        ln_TmpCta := i.ctnro;
        FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
          pn_ConTotS := pn_ConTotS + 1;
        END LOOP;
      END LOOP;
    end if;
  
    if pn_ConTotS = 0 and pn_ConTot = 0 then
      pn_ConTotS := -1;
    end if;
  
    if pn_ConTotS <> 0 and pn_ConTotS <> -1 then
      lv_flgCan := 'N';
      pn_Contar := 0;
      --Comprobar creditos
      FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
        ln_TmpCta := i.ctnro;
        FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
          if pn_ConIngS = pn_Contar then
            begin
              if j.Aostat <> 99 then
                sp_cr_datos_aval(j.PGCOD,
                                 j.AOMOD,
                                 j.AOSUC,
                                 j.AOMDA,
                                 j.AOPAP,
                                 j.AOCTA,
                                 j.AOOPER,
                                 j.SBOPE,
                                 j.AOTOPE,
                                 pv_NroCre,
                                 pv_FecDes,
                                 pv_ValDes);
                lv_flgCan := 'S';
              end if;
            EXCEPTION
              when others then
                my_errm := SQLERRM;
            end;
          end if;
          if lv_flgCan = 'N' and lv_flgIni = 'N' then
            pn_ConIngS := pn_ConIngS + 1;
          end if;
          pn_Contar := pn_Contar + 1;
          EXIT WHEN lv_flgCan = 'S';
        END LOOP;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      pn_ConIngS := pn_Contar;
    end if;
  
  END sp_cr_val_Aval;

  --**********************************************************************************************************-- 

  procedure sp_cr_datos_aval(pn_pgcodc in number,
                             pn_modc   in number,
                             pn_succ   in number,
                             pn_monc   in number,
                             pn_papc   in number,
                             pd_ctac   in number,
                             pv_opec   in number,
                             pv_sopec  in number,
                             pv_topec  in number,
                             pv_NroCre out varchar2,
                             pv_FecDes out varchar2,
                             pv_ValDes out varchar2) is
  
    my_errm VARCHAR2(32000);
  
    lv_FecDes     FSD010.aofval%type;
    lv_Instan     xwf700.xwfprcins%type;
    lv_tempInstan xwf700.xwfprcins%type;
    lv_MonDes     NUMBER(17, 2);
    lv_EstPar     sng001.sng001ori%type;
  
    lv_SimMon varchar2(8);
  
    lv_anio varchar2(5);
    lv_mes  varchar2(15);
    lv_dia  varchar2(2);
  
    pn_coderr number(18);
  
  BEGIN
    pn_coderr := 0;
  
    begin
      pv_NroCre := TRIM(lpad(pd_ctac, 9, '0') || lpad(pn_monc, 3, '0') ||
                        lpad(pv_opec, 9, '0'));
    EXCEPTION
      when others then
        pv_NroCre := '';
    end;
  
    --fecha y valor del desembolso
    begin
      select d010.aofval, d010.aoimp
        into lv_FecDes, lv_MonDes
        from FSD010 d010
       where d010.pgcod = pn_pgcodc
         and d010.aomod = pn_modc
         and d010.aosuc = pn_succ
         and d010.aomda = pn_monc
         and d010.aopap = pn_papc
         and d010.aocta = pd_ctac
         and d010.aooper = pv_opec
         and d010.aosbop = 0
         and d010.aotope = pv_topec;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        begin
          select d010.aofval, d010.aoimp
            into lv_FecDes, lv_MonDes
            from FSD010 d010
           where d010.pgcod = pn_pgcodc
             and d010.aocta = pd_ctac
             and d010.aooper = pv_opec
             and d010.aosbop = 0 offset 0 rows
           fetch next 1 rows only;
        EXCEPTION
          when others then
            pn_coderr := 3;
            my_errm   := SQLERRM;
        end;
    end;
  
    begin
      lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
      lv_mes  := trim(to_char(lv_FecDes,
                              'Month',
                              'nls_date_language=spanish'));
      lv_dia  := trim(to_char(lv_FecDes, 'DD'));
    
      pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
    
      --valor del desembolso              
      select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
    
      pv_ValDes := lv_SimMon || ' ' ||
                   TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
    
    EXCEPTION
      when others then
        pn_coderr := 3;
        my_errm   := SQLERRM;
    end;
  
    if pn_coderr = 0 then
      begin
        select g001.sng001ori
          into lv_EstPar
          from sng001 g001
         where g001.sng001inst = lv_Instan;
      EXCEPTION
        when others then
          lv_EstPar := 0;
      end;
    end if;
  
    --si es desembolso parcial
    if pn_coderr = 0 and lv_EstPar = 7 then
      begin
        select g002.sng001inst, sum(g002.sng002mon)
          into lv_tempInstan, lv_MonDes
          from sng002 g002
         where g002.sng001inst = lv_Instan
         group by g002.sng001inst;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TO_CHAR(lv_MonDes, '99999999999999999D99');
      
      EXCEPTION
        when others then
          pn_coderr := 3;
          my_errm   := SQLERRM;
      end;
    end if;
  
  END sp_cr_datos_aval;

  --**********************************************************************************************************--  
  procedure sp_cr_val_Titular(pn_pgcodc  in number,
                              pn_modc    in number,
                              pn_succ    in number,
                              pn_monc    in number,
                              pn_papc    in number,
                              pd_ctac    in number,
                              pv_opec    in number,
                              pv_sopec   in number,
                              pv_topec   in number,
                              pn_ConTot  in number,
                              pn_ConIng  in number,
                              pv_NroCre  out varchar2,
                              pv_FecDes  out varchar2,
                              pv_ValDes  out varchar2,
                              pn_ConTotS out number,
                              pn_ConIngS out number) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Titular(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) SBOPE,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where f.Aocta = c_cta
         and f.Aomod in (select t111.modulo
                           from fst111 t111
                          where t111.Dscod = 50
                            and t111.Modulo != 116)
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    ln_TmpCta number(10);
  
    lv_flgCan varchar2(2);
    lv_flgIni varchar2(2);
  
    pn_Contar number;
    --lc_ind_t    varchar2(5);
    ln_sld_011 number;
  BEGIN
    lv_flgIni  := 'N';
    pn_ConTotS := nvl(pn_ConTot, 0);
    pn_ConIngS := nvl(pn_ConIng, 0);
  
    if pn_ConIng > 0 then
      lv_flgIni := 'S';
    end if;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = pd_ctac OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
    if pn_ConTot = 0 and pn_ConIng = 0 then
      FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
        ln_TmpCta := i.ctnro;
        FOR j IN lst_crd_Titular(ln_TmpCta) LOOP
          pn_ConTotS := pn_ConTotS + 1;
        END LOOP;
      END LOOP;
    end if;
  
    if pn_ConTotS = 0 and pn_ConTot = 0 then
      pn_ConTotS := -1;
    end if;
  
    if pn_ConTotS <> 0 and pn_ConTotS <> -1 then
      lv_flgCan := 'N';
      pn_Contar := 0;
      --Comprobar creditos
      FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
        ln_TmpCta := i.ctnro;
        FOR j IN lst_crd_Titular(ln_TmpCta) LOOP
          if pn_ConIngS = pn_Contar then
            begin
              if j.Aostat <> 99 then
                ln_sld_011 := fn_get_saldo_fsd011(j.PGCOD,
                                                  j.AOMOD,
                                                  j.AOSUC,
                                                  j.AOMDA,
                                                  j.AOPAP,
                                                  j.AOCTA,
                                                  j.AOOPER,
                                                  j.SBOPE,
                                                  j.AOTOPE);
                if ln_sld_011 <> 0 then
                  sp_cr_datos_aval(j.PGCOD,
                                   j.AOMOD,
                                   j.AOSUC,
                                   j.AOMDA,
                                   j.AOPAP,
                                   j.AOCTA,
                                   j.AOOPER,
                                   j.SBOPE,
                                   j.AOTOPE,
                                   pv_NroCre,
                                   pv_FecDes,
                                   pv_ValDes);
                  lv_flgCan := 'S';
                end if;
              else
                if lv_flgIni = 'S' then
                  pn_ConIngS := pn_ConIngS + 1;
                end if;
              end if;
            EXCEPTION
              when others then
                my_errm := SQLERRM;
            end;
          end if;
          if lv_flgCan = 'N' and lv_flgIni = 'N' then
            pn_ConIngS := pn_ConIngS + 1;
          end if;
          pn_Contar := pn_Contar + 1;
          EXIT WHEN lv_flgCan = 'S';
        END LOOP;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      pn_ConIngS := pn_Contar;
    end if;
  END sp_cr_val_Titular;

  --*************************************************************************************************************
  procedure sp_log_rte608(pn_pgcodt  in number,
                          pn_suct    in number,
                          pn_modt    in number,
                          pn_trant   in number,
                          pn_itnrelt in number,
                          pd_fecsis  in date) is
  
    pd_itfcont FSD015.itfcon%type;
  
    ln_PGCODC FSD016.pgcod%type;
    ln_MODC   FSD016.modulo%type;
    ln_SUCC   FSD016.itsucd%type;
    ln_MONC   FSD016.moneda%type;
    ln_PAPC   FSD016.papel%type;
    ln_CTAC   FSD016.ctnro%type;
    ln_OPEC   FSD016.itoper%type;
    ln_SOPEC  FSD016.itsubo%type;
    ln_TOPEC  FSD016.ittope%type;
  
    HORA varchar2(15);
  
    ln_NueSta NUMBER;
  
    my_errm VARCHAR2(32000);
  
    ln_capital number(18, 2);
    ln_Interes number(18, 2);
    ln_Mora    number(18, 2);
    ln_Honpro  number(18, 2);
    ln_Gastos  number(18, 2);
    ln_Saldo   number(18, 2);
    ln_Saldo11 number(18, 2);
  
    ln_Instancia number(10);
  
    pn_coderr number;
    pn_msgerr varchar2(32000);
  
  BEGIN
    HORA := to_char(sysdate, 'HH24:MI:SS');
  
    --obtenermos la clave del credito
    begin
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope,
                      a.itfcon
        into ln_PGCODC,
             ln_MODC,
             ln_SUCC,
             ln_MONC,
             ln_PAPC,
             ln_CTAC,
             ln_OPEC,
             ln_SOPEC,
             ln_TOPEC,
             pd_itfcont
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcodt
         and a.itsuc = pn_suct
         and a.itmod = pn_modt
         and a.ittran = pn_trant
         and a.itnrel = pn_itnrelt;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --obtener la instancia  
    begin
      select distinct x.xwfprcins
        into ln_Instancia
        from xwf700 x
       where x.xwfempresa = ln_PGCODC
         and x.xwfmodulo = ln_MODC
         and x.xwfsucursal = ln_SUCC
         and x.xwfmoneda = ln_MONC
         and x.xwfpapel = ln_PAPC
         and x.xwfcuenta = ln_CTAC
         and x.xwfoperacion = ln_OPEC
         and x.xwfoperacion = ln_SOPEC
         and x.xwftipope = ln_TOPEC
         and x.xwfcar3 = '1';
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --obtener estado
    begin
      select d011.scstat,
             case
               when d011.scsdo < 0 then
                d011.scsdo * -1
               else
                d011.scsdo
             end
        into ln_NueSta, ln_Saldo11
        from fsd011 d011
       where d011.pgcod = ln_PGCODC
         and d011.scmod = ln_MODC
         and d011.scsuc = ln_SUCC
         and d011.scmda = ln_MONC
         and d011.scpap = ln_PAPC
         and d011.sccta = ln_CTAC
         and d011.scoper = ln_OPEC
         and d011.scsbop = ln_SOPEC
         and d011.sctope = ln_TOPEC;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    begin
      PQ_CR_JAQL175.sp_saldo_credito(ln_PGCODC,
                                     ln_CTAC,
                                     ln_MONC,
                                     ln_PAPC,
                                     ln_OPEC,
                                     ln_SOPEC,
                                     ln_MODC,
                                     ln_NueSta,
                                     ln_capital,
                                     ln_Interes,
                                     ln_Mora,
                                     ln_Honpro,
                                     ln_Gastos,
                                     ln_Saldo);
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --if ln_Saldo <= 0 or ln_Saldo is null or ln_Saldo11 <= 0 or ln_Saldo11 is null then
    --** insertar en la tabla log
    begin
      insert into aqpb608l
        (AQPB608LPGCOD,
         AQPB608LSUC,
         AQPB608LMOD,
         AQPB608LTRAN,
         AQPB608LREL,
         AQPB608LFCON,
         AQPB608LFECREG,
         AQPB608LHORREG,
         AQPB608LPGCODC,
         AQPB608LMODC,
         AQPB608LSUCC,
         AQPB608LMDAC,
         AQPB608LPAPC,
         AQPB608LCTAC,
         AQPB608LOPEC,
         AQPB608LSOPEC,
         AQPB608LTOPEC,
         AQPB608LESTC,
         AQPB608LSLDO,
         AQPB608LINST)
      values
        (pn_pgcodt,
         pn_suct,
         pn_modt,
         pn_trant,
         pn_itnrelt,
         pd_itfcont,
         pd_fecsis,
         HORA,
         ln_PGCODC,
         ln_MODC,
         ln_SUCC,
         ln_MONC,
         ln_PAPC,
         ln_CTAC,
         ln_OPEC,
         ln_SOPEC,
         ln_TOPEC,
         ln_NueSta,
         ln_Saldo,
         ln_Instancia);
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
    --end if;
  
    if ln_NueSta = 99 then
      sp_cr_ins_cred_canc(pn_pgcodt,
                          pn_suct,
                          pn_modt,
                          pn_trant,
                          pn_itnrelt,
                          pn_coderr,
                          pn_msgerr);
    end if;
  END sp_log_rte608;

  --**********************************************************************************************************-- 

  procedure sp_cr_datos_CNA(pn_pgcodc in number,
                            pn_modc   in number,
                            pn_succ   in number,
                            pn_monc   in number,
                            pn_papc   in number,
                            pd_ctac   in number,
                            pv_opec   in number,
                            pv_sopec  in number,
                            pv_topec  in number,
                            pv_instan in number,
                            pv_user   in varchar2,
                            pv_NomCli out varchar2, --
                            pv_FecDes out varchar2,
                            pv_ValDes out varchar2,
                            pv_FecAct out varchar2,
                            pv_NunDNI out varchar2,
                            pn_coderr out number,
                            pn_msgerr out varchar2) is
  
    my_errm VARCHAR2(32000);
  
    lv_pepais fsr008.pepais%type;
    lv_petdoc fsr008.petdoc%type;
  
    lv_FecDes     FSD010.aofval%type;
    lv_Instan     xwf700.xwfprcins%type;
    lv_tempInstan xwf700.xwfprcins%type;
    lv_MonDes     NUMBER(17, 2);
    lv_EstCan     FSD010.aostat%type;
    lv_EstPar     sng001.sng001ori%type;
  
    lv_SimMon varchar2(8);
  
    lv_anio varchar2(5);
    lv_mes  varchar2(15);
    lv_dia  varchar2(2);
  
    lv_anioA varchar2(5);
    lv_mesA  varchar2(15);
    lv_diaA  varchar2(2);
  
    HORA varchar2(15);
  
    lv_FecAct date;
  
  BEGIN
    pn_coderr := 0;
  
    --** VALIDAR MODULO
    if pn_modc = 116 then
      pn_coderr := 7;
      pn_msgerr := 'Modulo no Permitido';
      my_errm   := SQLERRM;
    end if;
  
    --nombre del cliente
    if pn_coderr = 0 then
      BEGIN
        select pepais, petdoc, pendoc
          into lv_pepais, lv_petdoc, pv_NunDNI
          from fsr008
         where cttfir = 'T'
           and ctnro = pd_ctac
           and rownum = 1;
      EXCEPTION
        when others then
          pn_coderr := 2;
          pn_msgerr := 'Error en la cuenta de cliente';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
      --apachecoh 2022.10.25 cambio de tabla de consulta de nombre   
      BEGIN
        select trim(PFAPE1) || ' ' || trim(PFAPE2) || ' ' || trim(PFNOM1) || ' ' ||
               trim(PFNOM2)
          into pv_NomCli
          from Fsd002
         where pfpais = lv_pepais
           and pftdoc = lv_petdoc
           and pfndoc = rpad(pv_NunDNI, 12);
      EXCEPTION
        when others then
          BEGIN
            select penom
              into pv_NomCli
              from Fsd001
             where pepais = lv_pepais
               and petdoc = lv_petdoc
               and pendoc = rpad(pv_NunDNI, 12);
          EXCEPTION
            when others then
              pn_coderr := 2;
              pn_msgerr := 'Error en el nombre de cliente';
              my_errm   := SQLERRM;
              DBMS_OUTPUT.put_line(my_errm);
          end;
      end;
    end if;
  
    --fecha y valor del desembolso
    if pn_coderr = 0 then
      begin
        select d010.aofval, d010.aoimp, d010.aostat
          into lv_FecDes, lv_MonDes, lv_EstCan
          from FSD010 d010
         where d010.pgcod = pn_pgcodc
           and d010.aomod = pn_modc
           and d010.aosuc = pn_succ
           and d010.aomda = pn_monc
           and d010.aopap = pn_papc
           and d010.aocta = pd_ctac
           and d010.aooper = pv_opec
           and d010.aosbop = 0;
      
        lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
        lv_mes  := trim(to_char(lv_FecDes,
                                'Month',
                                'nls_date_language=spanish'));
        lv_dia  := trim(to_char(lv_FecDes, 'DD'));
      
        pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
      
      EXCEPTION
        when others then
          begin
            select d010.aofval, d010.aoimp, d010.aostat
              into lv_FecDes, lv_MonDes, lv_EstCan
              from FSD010 d010
             where d010.pgcod = pn_pgcodc
               and d010.aomod = pn_modc
               and d010.aosuc = pn_succ
               and d010.aomda = pn_monc
               and d010.aopap = pn_papc
               and d010.aocta = pd_ctac
               and d010.aooper = pv_opec
               and d010.aosbop = pv_sopec
               and d010.aotope = pv_topec
               and d010.aosbop =
                   (select min(d010.aosbop)
                      from FSD010 d010
                     where d010.pgcod = pn_pgcodc
                       and d010.aomod = pn_modc
                       and d010.aosuc = pn_succ
                       and d010.aomda = pn_monc
                       and d010.aopap = pn_papc
                       and d010.aocta = pd_ctac
                       and d010.aooper = pv_opec
                       and d010.aosbop = pv_sopec
                       and d010.aotope = pv_topec);
            --and d010.aostat = 99 and d010.aosbop = 0;
          
            lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
            lv_mes  := trim(to_char(lv_FecDes,
                                    'Month',
                                    'nls_date_language=spanish'));
            lv_dia  := trim(to_char(lv_FecDes, 'DD'));
          
            pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
          
            --valor del desembolso              
            select mosign
              into lv_SimMon
              from Fst005
             where moneda = pn_MONC;
          
            pv_ValDes := lv_SimMon || ' ' ||
                         TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
          EXCEPTION
            when others then
              pn_coderr := 3;
              pn_msgerr := 'Error al obtener la fecha y monto';
              my_errm   := SQLERRM;
              DBMS_OUTPUT.put_line(my_errm);
          end;
      end;
    end if;
  
    if pn_coderr <> 0 and (pn_modc = 200 or pn_modc = 33) then
      begin
        select d010.aofval, d010.aoimp, d010.aostat
          into lv_FecDes, lv_MonDes, lv_EstCan
          from FSD010 d010
         where d010.aocta = pd_ctac
           and d010.aooper = pv_opec
           and d010.aomda = 0
           and d010.aosbop = (select min(d010.aosbop)
                                from FSD010 d010
                               where d010.aocta = pd_ctac
                                 and d010.aooper = pv_opec
                                 and d010.aomda = pn_monc);
      
        lv_anio := trim(to_char(lv_FecDes, 'YYYY'));
        lv_mes  := trim(to_char(lv_FecDes,
                                'Month',
                                'nls_date_language=spanish'));
        lv_dia  := trim(to_char(lv_FecDes, 'DD'));
      
        pv_FecDes := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TRIM(TO_CHAR(lv_MonDes, '99999999999999999D99'));
        pn_coderr := 0;
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al obtener la fecha y monto';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 0 then
      begin
        select x700.xwfprcins
          into lv_Instan
          from xwf700 x700
         where x700.xwfempresa = pn_pgcodc
           and x700.xwfmodulo = pn_modc
           and x700.xwfsucursal = pn_succ
           and x700.xwfmoneda = pn_monc
           and x700.xwfpapel = pn_papc
           and x700.xwfcuenta = pd_ctac
           and x700.xwfoperacion = pv_opec
           and x700.xwfsubope = pv_sopec
           and x700.xwftipope = pv_topec
           and x700.xwfcar3 = '1';
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al obtener la instancia';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    if pn_coderr = 0 then
      begin
        select g001.sng001ori
          into lv_EstPar
          from sng001 g001
         where g001.sng001inst = lv_Instan;
      EXCEPTION
        when others then
          lv_EstPar := 0;
      end;
    end if;
  
    --si es desembolso parcial
    if pn_coderr = 0 and lv_EstPar = 7 then
      begin
        select g002.sng001inst, sum(g002.sng002mon)
          into lv_tempInstan, lv_MonDes
          from sng002 g002
         where g002.sng001inst = lv_Instan
         group by g002.sng001inst;
      
        --valor del desembolso              
        select mosign into lv_SimMon from Fst005 where moneda = pn_MONC;
      
        pv_ValDes := lv_SimMon || ' ' ||
                     TO_CHAR(lv_MonDes, '99999999999999999D99');
      
      EXCEPTION
        when others then
          pn_coderr := 3;
          pn_msgerr := 'Error al monto (credito parcial)';
          my_errm   := SQLERRM;
          DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  
    --fecha actual 
    --if pn_coderr = 0 then
    begin
      select T017.PGFAPE
        INTO lv_FecAct
        from FST017 T017
       WHERE T017.PGCOD = 1;
      lv_anioA := trim(to_char(lv_FecAct, 'YYYY'));
      lv_mesA  := trim(to_char(lv_FecAct,
                               'Month',
                               'nls_date_language=spanish'));
      lv_diaA  := trim(to_char(lv_FecAct, 'DD'));
    
      pv_FecAct := lv_diaA || ' de ' || lv_mesA || ' del ' || lv_anioA;
    
    EXCEPTION
      when others then
        pn_coderr := 4;
        pn_msgerr := 'Error en fecha actual';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
    --end if;
  
    --if pn_coderr = 0 then
    begin
    
      HORA := to_char(sysdate, 'HH24:MI:SS');
    
      update aqpb608
         set AQPB608USUCNA  = pv_user,
             AQPB608FIMPCNA = 'S',
             AQPB608FECCNA  = TO_DATE(SYSDATE),
             AQPB608HORCNA  = HORA
       where AQPB608PGCODC = pn_pgcodc
         and AQPB608MODC = pn_modc
         and AQPB608SUCC = pn_succ
         and AQPB608MONC = pn_monc
         and AQPB608PAPC = pn_papc
         and AQPB608CTAC = pd_ctac
         and AQPB608OPEC = pv_opec
         and AQPB608SOPEC = pv_sopec
         and AQPB608TOPEC = pv_topec;
      /*and AQPB608PAIS = lv_pepais
      and AQPB608TDOC = lv_petdoc
      and AQPB608NUMDOC = pv_NunDNI;*/
      commit;
    EXCEPTION
      when others then
        pn_coderr := 9;
        pn_msgerr := 'Error al actualizar';
        my_errm   := SQLERRM;
        DBMS_OUTPUT.put_line(my_errm);
    end;
    --end if;
  
  END sp_cr_datos_CNA;

  --**********************************************************************************************************--  
  procedure sp_cr_val_Aval_2(pn_pgcodc in number,
                             pn_modc   in number,
                             pn_succ   in number,
                             pn_monc   in number,
                             pn_papc   in number,
                             pd_ctac   in number,
                             pv_opec   in number,
                             pv_sopec  in number,
                             pv_topec  in number,
                             pn_coderr out number,
                             lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) SBOPE,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    /*select f.PGCOD, f.AOMOD, f.AOSUC, 
           f.AOMDA, f.AOPAP, f.AOCTA, 
           f.AOOPER, max(f.AOSBOP) SBOPE, f.AOTOPE, 
           f.Aostat
    from fsd010 f
    where (f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, f.AOTOPE) in --, f.AOSBOP
    (select x.xwfempresa, x.xwfmodulo, x.xwfsucursal
    , x.xwfmoneda, x.xwfpapel, x.xwfcuenta
    , x.xwfoperacion, x.xwftipope--, x.xwfsubope
    from xwf700 x
    where x.xwfcar3 = '1'
    and x.xwfprcins in (select s.sng001inst from sng003 s where s.sng003cta = c_cta))
    group by f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, f.AOTOPE, f.Aostat, f.aofval
    order by f.aofval, f.AOCTA, f.AOOPER, f.AOMOD, f.AOSUC, f.AOTOPE;*/
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
  
    pn_contador number;
  BEGIN
    lv_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = pd_ctac OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        pn_coderr := 1;
        my_errm   := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
    if pn_coderr = 0 then
      FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
        ln_TmpCta := i.ctnro;
        FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
          if j.Aostat <> 99 then
            pn_contador := pn_contador + 1;
          end if;
        END LOOP;
      END LOOP;
    end if;
  
    --&flagAval = 'N'o tiene obligaciones como aval
    --          = 'S'i tiene obligaciones como aval
    if pn_contador > 0 then
      lv_flgCan := 'S';
    end if;
  END sp_cr_val_Aval_2;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Crd99_2(pn_pgcodc in number,
                                pn_modc   in number,
                                pn_succ   in number,
                                pn_monc   in number,
                                pn_papc   in number,
                                pd_ctac   in number,
                                pv_opec   in number,
                                pv_sopec  in number,
                                pv_topec  in number,
                                pn_coderr out number,
                                lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd(n_nrocta number) IS
      select distinct pgcod, aomod, aomda, aopap, aocta, aooper
        from fsd010
       where pgcod = 1
         and aocta = n_nrocta
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo != 116) or aomod = 65
              or aomod = 117) --apachecoh 2024.03.11
      --and aofe99 >= fecguia
       order by pgcod, aocta;
    /*select d.pgcod,
          d.aomod,
          d.aosuc,
          d.aomda,
          d.aopap,
          d.aocta,
          d.aooper,
          d.aotope,
          d.aosbop,
          d.aostat
     from fsd010 d
    where d.aocta = n_nrocta
      and d.aomod in (select t111.modulo
                        from fst111 t111
                       where t111.Dscod = 50
                         and t111.Modulo != 116)
      and d.aosbop = (select max(d1.AOSBOP)
                        from fsd010 d1
                       where d1.PGCOD = d.pgcod
                         and d1.AOMOD = d.aomod
                         and d1.AOMDA = d.aomda
                         and d1.AOPAP = d.aopap
                         and d1.AOCTA = d.aocta
                         and d1.AOSUC = d.aosuc
                         and d1.AOOPER = d.aooper
                         and d1.AOTOPE = d.aotope)
      order by d.PGCOD,
             d.AOMOD,
             d.AOMDA,
             d.AOPAP,
             d.AOCTA,
             d.AOSUC,
             d.AOOPER,
             d.AOSBOP;*/
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    ld_fecguia date;
    ld_fec99   date;
  
    lv_flagCanc varchar(1);
    ln_estadoC  number(3);
  
  BEGIN
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = pd_ctac OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    ld_fecguia := fn_get_FecGuia();
    /*    ln_pais := 604;
    ln_tdoc := 21; 
    ln_ndoc := rpad('29555982',12,' ');--'29278775    ';*/
  
    lv_flgCan := 'N';
    --Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          --T_aostat := j.aostat;
          T_pgcod := j.pgcod;
          T_aomod  := j.aomod;
          --T_aosuc  := j.aosuc;
          T_aomda := j.aomda;
          T_aopap := j.aopap;
          --T_aotope := j.aotope;
          --T_aosbop := j.aosbop;
        
          /*if T_aostat <> 99 then 
            lv_flgCan := 'S'; 
          end if;*/
          sp_cr_val_estado_2(T_pgcod,
                             T_aocta,
                             T_aomod,
                             T_aooper,
                             T_aosuc,
                             T_aomda,
                             T_aopap,
                             T_aotope,
                             ld_fecguia,
                             lv_flagCanc,
                             ld_fec99,
                             ln_estadoC);
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
    --CodErr = 0 - si tiene creditos pendientes
  
    --&flag99 = 'N'o tiene obligaciones
    --        = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  END sp_cr_Todos_Crd99_2;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Aval99_2(pn_nrocta in number,
                                 pn_coderr out number,
                                 lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.pgcod, f.aomod, f.aomda, f.aopap, f.aocta, f.aooper
        from fsd010 f, xwf700 x, sng003 s
       where (aomod in (select modulo from fst111 where dscod = 50) or
             aomod = 65 or aomod = 117) --apachecoh 2024.11.03
         and f.pgcod = x.xwfempresa
            --and f.aomod = x.xwfmodulo
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and x.xwfprcins = s.sng001inst
         and x.xwfcar3 = '1'
         and s.sng003cta = c_cta
       group by f.pgcod, f.aomod, f.aomda, f.aopap, f.aocta, f.aooper
       order by f.aocta, f.aooper;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    pn_contador number;
    ln_sld_011  number;
  
    ld_fecguia  date;
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  
  BEGIN
    lv_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
  
    ld_fecguia := fn_get_FecGuia();
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = pn_nrocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        null;
        my_errm := SQLERRM;
    end;
  
    --Contar creditos    
    lv_flgCan := 'N';
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          --T_aostat := j.aostat;
          T_pgcod := j.pgcod;
          --T_aomod  := j.aomod;
          --T_aosuc  := j.aosuc;
          T_aomda := j.aomda;
          T_aopap := j.aopap;
          --T_aotope := j.aotope;
          --T_aosbop := j.aosbop;
        
          sp_cr_val_estado_2(T_pgcod,
                             T_aocta,
                             T_aomod,
                             T_aooper,
                             T_aosuc,
                             T_aomda,
                             T_aopap,
                             T_aotope,
                             ld_fecguia,
                             lv_flagCanc,
                             ld_fec99,
                             ln_estadoC);
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flagAval = 'N'o tiene obligaciones
    --          = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_Todos_Aval99_2;

  --**********************************************************************************************************--  
  procedure sp_cr_generar_lst_cna(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    cursor lst_cuentas(pais number, tdoc number, doc character) is
      select Ctnro NroCta
        from fsr008
       Where Cttfir = 'T'
         and Pepais = pais
         and Petdoc = tdoc
         and Pendoc = doc;
  
    cursor lst_aqpb608(cuenta number, FecGuia date) is
      select AQPB608FIMPCNA,
             AQPB608PGCODC,
             AQPB608MODC,
             AQPB608SUCC,
             AQPB608MONC,
             AQPB608PAPC,
             AQPB608CTAC,
             AQPB608OPEC,
             AQPB608SOPEC,
             AQPB608TOPEC,
             AQPB608PGCODT,
             AQPB608ITSUC,
             AQPB608ITMOD,
             AQPB608ITTRAN,
             AQPB608ITNREL,
             AQPB608ITFCON,
             AQPB608INSTAN,
             AQPB608HORT
        from AQPB608
       where AQPB608PGCODC = 1
         and AQPB608CTAC = cuenta
         and AQPB608ITFCON >= FecGuia
         and AQPB608PGCODT is not null
       order by AQPB608ITFCON DESC, AQPB608HORT DESC offset 0 rows
       fetch next 1 rows only;
  
    cursor lst_fsd010(cuenta number, ln_pgcod number, FecGuia date) is
      select distinct pgcod, Aocta, Aooper, Aomod, aofe99
        from fsd010
       Where Pgcod = ln_pgcod
         and Aocta = cuenta
         and (aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo != 116) or aomod = 65 
             or aomod = 117) --apachecoh 2024.03.11
      --and aomod not in (200, 33, 65)
       order by aofe99 desc; --, Pgcod, Aocta;
  
    l_PGCODAC NUMBER(3);
    --l_FecTem   VARCHAR2(20);
    l_fecGuia DATE;
    --l_flag_Mod VARCHAR2(1);
  
    l_PgcodC  NUMBER;
    l_SucC    NUMBER;
    l_ModC    NUMBER;
    l_MonC    NUMBER;
    l_PapC    NUMBER;
    l_NroCta  NUMBER;
    l_OpeC    NUMBER;
    l_SubopeC NUMBER;
    l_TipOpeC NUMBER;
    l_FlagImp VARCHAR2(1);
    l_flag608 VARCHAR2(1);
  
    l_ndoc CHARACTER(12);
    l_usua CHARACTER(10);
  
    ln_coderr number;
  
    ld_Fec608 date;
    --ln_inst     char(1):='N';
    ld_fecha99 DATE;
  
    lv_hora VARCHAR2(8);
    --lv_hora10   VARCHAR2(8);
    ln_ittran   number;
    ln_contador number := 0;
  
    ld_fecon date;
  
    lv_flagCan varchar(1);
    ln_estadoC number(3);
  
    lc_ind_t   varchar(5);
    ln_ContEst number;
    ln_sld_011 number;
    ln_sld_175 number;
  
    pn_coderrAval number;
    lv_flgCanAval varchar2(5);
  
    lv_flagCanN varchar2(1);
    lv_flagEstN varchar2(1);
  BEGIN
    pn_cerr := 1;
    l_usua  := pv_usua;
    l_ndoc  := pn_ndoc;
  
    -- ELIMINAR AQPB609L
    begin
      delete from aqpb609b a
       where a.aqpb609bflst = pd_fecha
         and a.aqpb609bulst = l_usua;
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    -- PGCOD DEL USUARIO
    begin
      select f.pgcodac
        into l_PgcodAc
        from FST746 f
       Where Ubuser = l_usua offset 0 rows
       fetch next 1 rows only;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    -- FECHA GUIA
    l_fecGuia := fn_get_FecGuia();
  
    --CURSOR DE CUENTAS
    for i in lst_cuentas(pn_pais, pn_tdoc, l_ndoc) loop
      PQ_CR_VALI_CRED_CANC.sp_cr_Todos_Crd99_2(null,
                                               null,
                                               null,
                                               null,
                                               null,
                                               i.NroCta,
                                               null,
                                               null,
                                               null,
                                               ln_coderr,
                                               pv_merr);
    
      PQ_CR_VALI_CRED_CANC.sp_cr_Todos_Aval99_2(i.NroCta,
                                                pn_coderrAval,
                                                lv_flgCanAval);
    
      for k in lst_fsd010(i.NroCta, l_PgcodAc, l_fecGuia) loop
        sp_cr_dat_credito_2(l_PgcodAc,
                            k.Aocta,
                            k.Aooper,
                            k.Aomod,
                            l_PgcodC,
                            l_SucC,
                            l_ModC,
                            l_MonC,
                            l_PapC,
                            l_NroCta,
                            l_OpeC,
                            l_SubopeC,
                            l_TipOpeC);
      
        sp_cr_val_contancia_2(l_PgcodC,
                              l_SucC,
                              l_ModC,
                              l_MonC,
                              l_PapC,
                              l_NroCta,
                              l_OpeC,
                              l_SubopeC,
                              l_TipOpeC,
                              l_Flag608,
                              l_FlagImp);
      
        sp_cr_validar_credito_N(k.Aomod,
                                k.Aocta,
                                k.Aooper,
                                lv_flagCanN,
                                lv_flagEstN,
                                ld_fecha99,
                                ln_estadoC);
      
        begin
          select a.aqpb608hort,
                 a.aqpb608ittran,
                 a.aqpb608itfcon,
                 a.aqpb608hort,
                 a.aqpb608fimpcna,
                 'S'
            into lv_hora,
                 ln_ittran,
                 ld_Fec608,
                 lv_hora,
                 l_FlagImp,
                 l_Flag608
            from aqpb608 a
           where a.aqpb608pgcodc = l_PgcodC
             and a.aqpb608modc = l_ModC
             and a.aqpb608succ = l_SucC
             and a.aqpb608monc = l_MonC
             and a.aqpb608papc = l_PapC
             and a.aqpb608ctac = l_NroCta
             and a.aqpb608opec = l_OpeC
             and a.aqpb608sopec = l_SubopeC
             and a.aqpb608topec = l_TipOpeC
             and rownum = 1;
        exception
          when others then
            null;
            lv_hora   := null;
            l_FlagImp := 'N';
            l_Flag608 := 'N';
            my_errm   := SQLERRM;
        end;
        --apachecoh 2023.09.30
        if (ld_fecha99 = to_date('1/01/0001', 'dd/mm/rrrr') or
           ld_fecha99 is null) then
          sp_cr_obtener_hora(l_PgcodC,
                             l_ModC,
                             l_SucC,
                             l_MonC,
                             l_PapC,
                             l_NroCta,
                             l_OpeC,
                             l_SubopeC,
                             l_TipOpeC,
                             pd_fecha,
                             lv_hora,
                             ld_fecon);
          ld_fecha99 := ld_fecon;
        end if;
        /*if ld_fecha99 = to_date('01/01/0001','dd/mm/rrrr') or ld_fecha99 is null then
           ld_fecha99 := ld_fecon;
        end if;*/
      
        if (pv_merr = 'N' and lv_flgCanAval = 'N') or
           (l_FlagImp = 'S' and l_Flag608 = 'S') then
          begin
            insert into AQPB609B
              (AQPB609BPGCOD, --1
               AQPB609BMOD, --2
               AQPB609BSUC, --3
               AQPB609BMON, --4
               AQPB609BPAP, --5
               AQPB609BNCTA, --6
               AQPB609BNOPE, --7
               AQPB609BSOPE, --8
               AQPB609BTOPE, --9
               AQPB609BINS, --10
               AQPB609BFIMP, --11
               AQPB609BPGCODT, --12
               AQPB609BSUCT, --13
               AQPB609BMODT, --14
               AQPB609BTRANT, --15
               AQPB609BRELT, --16
               AQPB609BFCON, --17
               AQPB609BF608, --18
               AQPB609BPAIS,
               AQPB609BTDOC,
               AQPB609BNDOC,
               AQPB609BFLST, --19
               AQPB609BULST, --20
               AQPB609BHORA --21
               )
            values
              (l_PgcodC, --1
               l_ModC, --2
               l_SucC, --3
               l_MonC, --4
               l_PapC, --5
               l_NroCta, --6
               l_OpeC, --7
               l_SubopeC, --8
               l_TipOpeC, --9
               NULL, --10
               l_FlagImp, --11
               NULL, --12
               NULL, --13
               NULL, --14
               NULL, --15
               NULL, --16
               ld_fecha99, --17
               l_Flag608, --18
               pn_pais,
               pn_tdoc,
               l_ndoc,
               pd_fecha, --19
               l_usua, --20
               lv_hora);
            commit;
            ln_contador := ln_contador + 1;
            pn_cerr     := 0;
          EXCEPTION
            when others then
              pn_cerr := 1;
          end;
        end if;
        --exit when ln_contador = 2; --apachecoh 2023.09.25  
      end loop;
      --apachecoh 2024.03.11
      if (pv_merr = 'N' and lv_flgCanAval = 'N') then       
         pn_cerr := 0;
      end if;
    end loop;
  
  END sp_cr_generar_lst_cna;

  --**********************************************************************************************************--  
  --update glosa de garantia
  procedure sp_cr_upd_gl_garantia(pn_pgcodc in number,
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number,
                                  pd_ctac   in number,
                                  pv_opec   in number,
                                  pv_sopec  in number,
                                  pv_topec  in number,
                                  pv_flgglo in varchar2,
                                  pn_tipope in number,
                                  pv_progr  in varchar2) is
    my_errm VARCHAR2(32000);
  
  BEGIN
    if pv_progr = 'RAQPB608' THEN
      begin
        update aqpb608 a
           set a.aqpb608glocon = pv_flgglo, a.aqpb608tipgar1 = pn_tipope
         where a.aqpb608pgcodc = pn_pgcodc
           and a.aqpb608modc = pn_modc
           and a.aqpb608succ = pn_succ
           and a.aqpb608monc = pn_monc
           and a.aqpb608papc = pn_papc
           and a.aqpb608ctac = pd_ctac
           and a.aqpb608opec = pv_opec
           and a.aqpb608sopec = pv_sopec
           and a.aqpb608topec = pv_topec;
      EXCEPTION
        when others then
          my_errm := SQLERRM;
      end;
    ELSE
      begin
        update aqpb608 a
           set a.aqpb608glocna = pv_flgglo, a.aqpb608tipgar2 = pn_tipope
         where a.aqpb608pgcodc = pn_pgcodc
           and a.aqpb608modc = pn_modc
           and a.aqpb608succ = pn_succ
           and a.aqpb608monc = pn_monc
           and a.aqpb608papc = pn_papc
           and a.aqpb608ctac = pd_ctac
           and a.aqpb608opec = pv_opec
           and a.aqpb608sopec = pv_sopec
           and a.aqpb608topec = pv_topec;
      EXCEPTION
        when others then
          my_errm := SQLERRM;
      end;
    END IF;
    commit;
  END sp_cr_upd_gl_garantia;

  --**********************************************************************************************************--  
  --update Tipo de Constancia
  procedure sp_cr_upd_TipCon(pn_pgcod  in number,
                             pn_itsuc  in number,
                             pn_itmod  in number,
                             pn_ittran in number,
                             pn_itnrel in number,
                             pn_fecpro in date) is
    my_errm VARCHAR2(32000);
  
  BEGIN
    begin
      update aqpb608 a
         set a.AQPB608TipoCon = 'CNA'
       where a.aqpb608pgcodt = pn_pgcod
         and a.aqpb608itsuc = pn_itsuc
         and a.aqpb608itmod = pn_itmod
         and a.aqpb608ittran = pn_ittran
         and a.aqpb608itnrel = pn_itnrel
         and a.aqpb608itfcon = pn_fecpro;
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  END sp_cr_upd_TipCon;

  --update Tipo de Constancia
  procedure sp_cr_upd_TipCon_2(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pd_ctac   in number,
                               pv_opec   in number,
                               pv_sopec  in number,
                               pv_topec  in number) is
    my_errm VARCHAR2(32000);
  
  BEGIN
    begin
      update aqpb608 a
         set a.AQPB608TipoCon = 'CNA'
       where a.AQPB608PGCODC = pn_pgcodc
         and a.AQPB608MODC = pn_modc
         and a.AQPB608SUCC = pn_succ
         and a.AQPB608MONC = pn_monc
         and a.AQPB608PAPC = pn_papc
         and a.AQPB608CTAC = pd_ctac
         and a.AQPB608OPEC = pv_opec
         and a.AQPB608SOPEC = pv_sopec
         and a.AQPB608TOPEC = pv_topec;
    
      commit;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  END sp_cr_upd_TipCon_2;

  --**********************************************************************************************************--  
  procedure sp_cr_obtener_hora(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pn_ctac   in number,
                               pn_opec   in number,
                               pn_sopec  in number,
                               pn_topec  in number,
                               pd_fecha  in date,
                               pv_hora   out varchar2,
                               pd_fecon  out date) is
  
    my_errm VARCHAR2(32000);
  BEGIN
  
    begin
      select max(j.ithora)
        into pv_hora
        from fsd015 j
        join fsd016 k
          on j.pgcod = k.pgcod
         and j.itsuc = k.itsuc
         and j.itmod = k.itmod
         and j.ittran = k.ittran
         and j.itnrel = k.itnrel
       where k.pgcod = pn_pgcodc
         and k.itsucd = pn_succ
         and k.modulo = pn_modc
         and k.moneda = pn_monc
         and k.papel = pn_papc
         and k.ctnro = pn_ctac
         and k.itoper = pn_opec
         and k.itsubo = pn_sopec
         and k.ittope = pn_topec
         and j.itfcon = pd_fecha;
      pd_fecon := pd_fecha;
    
      if pv_hora is null then
        begin
          select max(i.hfcon)
            into pd_fecon
            from fsh016 i
           where i.pgcod = pn_pgcodc
             and i.hmodul = pn_modc
             and i.hsucur = pn_succ
             and i.hmda = pn_monc
             and i.hpap = pn_papc
             and i.hcta = pn_ctac
             and i.hoper = pn_opec
             and i.hsubop = pn_sopec
             and i.htoper = pn_topec;
        
          select h.hhora
            into pv_hora
            from fsh015 h
            join fsh016 i
              on h.pgcod = i.pgcod
             and h.hcmod = i.hcmod
             and h.hsucor = i.hsucor
             and h.htran = i.htran
             and h.hnrel = i.hnrel
             and h.hfcon = i.hfcon
           where i.pgcod = pn_pgcodc
             and i.hmodul = pn_modc
             and i.hsucur = pn_succ
             and i.hmda = pn_monc
             and i.hpap = pn_papc
             and i.hcta = pn_ctac
             and i.hoper = pn_opec
             and i.hsubop = pn_sopec
             and i.htoper = pn_topec
             and h.hfcon = pd_fecon;
        
        EXCEPTION
          when others then
            null;
            my_errm := SQLERRM;
        end;
      end if;
    
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        begin
          select max(i.hfcon)
            into pd_fecon
            from fsh016 i
           where i.pgcod = pn_pgcodc
             and i.hmodul = pn_modc
             and i.hsucur = pn_succ
             and i.hmda = pn_monc
             and i.hpap = pn_papc
             and i.hcta = pn_ctac
             and i.hoper = pn_opec
             and i.hsubop = pn_sopec
             and i.htoper = pn_topec;
        
          select h.hhora
            into pv_hora
            from fsh015 h
            join fsh016 i
              on h.pgcod = i.pgcod
             and h.hcmod = i.hcmod
             and h.hsucor = i.hsucor
             and h.htran = i.htran
             and h.hnrel = i.hnrel
             and h.hfcon = i.hfcon
           where i.pgcod = pn_pgcodc
             and i.hmodul = pn_modc
             and i.hsucur = pn_succ
             and i.hmda = pn_monc
             and i.hpap = pn_papc
             and i.hcta = pn_ctac
             and i.hoper = pn_opec
             and i.hsubop = pn_sopec
             and i.htoper = pn_topec
             and h.hfcon = pd_fecon;
        
        EXCEPTION
          when others then
            null;
            my_errm := SQLERRM;
        end;
    end;
  
  END sp_cr_obtener_hora;

  --**********************************************************************************************************--  
  function fn_get_FecGuia return date is
    my_errm  VARCHAR2(32000);
    l_FecTem varchar(30);
    pd_fecha date;
  BEGIN
    begin
      select trim(Tpdesc)
        into l_FecTem
        from fst098
       Where Pgcod = 1
         and Tpcod = 7750
         and Tpcorr = 1;
    
      pd_fecha := TO_DATE(l_FecTem, 'dd/mm/yyyy');
    
    EXCEPTION
      when others then
        null;
    end;
    return pd_fecha;
  END fn_get_FecGuia;

  --**********************************************************************************************************--  
  function fn_get_saldo_fsd011(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pd_ctac   in number,
                               pv_opec   in number,
                               pv_sopec  in number,
                               pv_topec  in number) return number is
  
    ln_saldo number;
    my_errm  VARCHAR2(32000);
  begin
    begin
      select s.scsdo
        into ln_saldo
        from FSD011 S
       where s.pgcod = pn_pgcodc
         and s.scsuc = pn_succ
         and s.scmda = pn_monc
         and s.scpap = pn_papc
         and s.sccta = pd_ctac
         and s.scoper = pv_opec
         and s.scsbop = pv_sopec
         and s.scmod = pn_modc
         and s.sctope = pv_topec;
    exception
      when others then
        ln_saldo := null;
        my_errm  := SQLERRM;
    end;
  
    return ln_saldo;
  end fn_get_saldo_fsd011;

  --**********************************************************************************************************--  
  function fn_get_saldo_JAQL175(pn_pgcodc in number,
                                pn_modc   in number,
                                pn_succ   in number,
                                pn_monc   in number,
                                pn_papc   in number,
                                pd_ctac   in number,
                                pv_opec   in number,
                                pv_sopec  in number,
                                pv_topec  in number,
                                pv_estado in number) return number is
    ln_saldo   number;
    my_errm    VARCHAR2(32000);
    ln_capital number;
    ln_Interes number;
    ln_Mora    number;
    ln_Honpro  number;
    ln_Gastos  number;
  begin
    begin
      PQ_CR_JAQL175.sp_saldo_credito(pn_pgcodc,
                                     pd_ctac,
                                     pn_monc,
                                     pn_papc,
                                     pv_opec,
                                     pv_sopec,
                                     pn_modc,
                                     pv_estado,
                                     ln_capital,
                                     ln_Interes,
                                     ln_Mora,
                                     ln_Honpro,
                                     ln_Gastos,
                                     ln_saldo);
    exception
      when others then
        ln_saldo := null;
        my_errm  := SQLERRM;
      
    end;
  
    return ln_saldo;
  end fn_get_saldo_JAQL175;

  --**********************************************************************************************************--  
  function fn_verificar_estados(pn_estado in number) return number is
    my_errm     VARCHAR2(32000);
    pn_contador number;
  BEGIN
    begin
      SELECT COUNT(tpnro)
        INTO pn_contador
        FROM fst098
       WHERE pgcod = 1
         AND tpcod = 7750
         AND tpcorr >= 91
         AND tpcorr <= 100
         AND tpimp = 1
         AND tpnro = pn_estado;
    EXCEPTION
      when others then
        pn_contador := 0;
        my_errm     := SQLERRM;
    end;
  
    return pn_contador;
  END fn_verificar_estados;

  --**********************************************************************************************************--  
  procedure sp_cr_es_castigado(pn_pgcodc in number,
                               pn_modc   in number,
                               pn_succ   in number,
                               pn_monc   in number,
                               pn_papc   in number,
                               pn_ctac   in number,
                               pn_opec   in number,
                               pn_sopec  in number,
                               pn_topec  in number,
                               lc_ind_t  out char) is
  
    my_errm VARCHAR2(32000);
    --lc_ind_t char(1);
  BEGIN
    begin
      select 'C'
        into lc_ind_t
        from fsr011
       Where R1COD = pn_pgcodc
         and R1MOD = pn_modc
         and R1SUC = pn_succ
         and R1MDA = pn_monc
         and R1PAP = pn_papc
         and R1CTA = pn_ctac
         and R1OPER = pn_opec
         and R1SBOP = (select max(R1SBOP)
                         from fsr011
                        Where R1COD = pn_pgcodc
                          and R1MOD = pn_modc
                          and R1SUC = pn_succ
                          and R1MDA = pn_monc
                          and R1PAP = pn_papc
                          and R1CTA = pn_ctac
                          and R1OPER = pn_opec)
            --and R1TOPE = pn_topec
         and Relcod = 33
         and rownum = 1;
    EXCEPTION
      when others then
        my_errm  := SQLERRM;
        lc_ind_t := null;
    end;
  
    /*begin 
      select 'C' into lc_ind_t
      from fsr011
       Where R2cod  = pn_pgcodc
       and R2mod  = pn_modc 
       and R2suc  = pn_succ
       and R2mda  = pn_monc
       and R2pap  = pn_papc
       and R2cta  = pn_ctac
       and R2oper = pn_opec
       and R2sbop = pn_sopec
       and R2tope = pn_topec
       and Relcod = 33;
    EXCEPTION    
       when others then
         my_errm := SQLERRM;
         lc_ind_t := null;
    end;*/
  END sp_cr_es_castigado;

  --**********************************************************************************************************--  
  procedure sp_cr_es_judicial(pn_pgcodc in number,
                              pn_modc   in number,
                              pn_succ   in number,
                              pn_monc   in number,
                              pn_papc   in number,
                              pn_ctac   in number,
                              pn_opec   in number,
                              pn_sopec  in number,
                              pn_topec  in number,
                              lc_ind_t  out char) is
  
    my_errm VARCHAR2(32000);
    --lc_ind_t char(1);
  BEGIN
    begin
      select 'J'
        into lc_ind_t
        from fsr011
       Where R1COD = pn_pgcodc
         and R1MOD = pn_modc
         and R1SUC = pn_succ
         and R1MDA = pn_monc
         and R1PAP = pn_papc
         and R1CTA = pn_ctac
         and R1OPER = pn_opec
         and R1SBOP = (select max(R1SBOP)
                         from fsr011
                        Where R1COD = pn_pgcodc
                          and R1MOD = pn_modc
                          and R1SUC = pn_succ
                          and R1MDA = pn_monc
                          and R1PAP = pn_papc
                          and R1CTA = pn_ctac
                          and R1OPER = pn_opec)
            --and R1TOPE = pn_topec
         and Relcod in (34, 35, 37, 120)
         and rownum = 1;
    EXCEPTION
      when others then
        my_errm  := SQLERRM;
        lc_ind_t := null;
    end;
    /*begin
      select 'C' into lc_ind_t
      from fsr011
       Where R2cod  = pn_pgcodc
       and R2mod  = pn_modc 
       and R2suc  = pn_succ
       and R2mda  = pn_monc
       and R2pap  = pn_papc
       and R2cta  = pn_ctac
       and R2oper = pn_opec
       and R2sbop = pn_sopec
       and R2tope = pn_topec
       and Relcod = 34;
    EXCEPTION    
       when others then
         my_errm := SQLERRM;
         lc_ind_t := null;
    end;*/
  END sp_cr_es_judicial;

  --apachecoh 2022.09.01
  --**********************************************************************************************************--  
  procedure sp_cr_insert_log_voucher(pn_pgcod  in number,
                                     pn_itsuc  in number,
                                     pn_itmod  in number,
                                     pn_ittran in number,
                                     pn_itnrel in number,
                                     pn_itord  in number,
                                     pn_itfcon in date,
                                     pv_flgcan in varchar2,
                                     pv_flgimp in varchar2,
                                     pv_observ in varchar2,
                                     pv_user   in varchar2) is
  
    my_errm VARCHAR2(300);
    lv_ndoc VARCHAR2(15);
    ln_mod  NUMBER(5);
    ln_suc  NUMBER(4);
    ln_mda  NUMBER(4);
    ln_pap  NUMBER(4);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_top  NUMBER(5);
    ln_sbo  NUMBER(4);
  begin
    --busqueda otros datos
    begin
      select AQPB608NUMDOC,
             AQPB608MODC,
             AQPB608SUCC,
             AQPB608MONC,
             AQPB608PAPC,
             AQPB608CTAC,
             AQPB608OPEC,
             AQPB608SOPEC,
             AQPB608TOPEC
        into lv_ndoc,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from aqpb608
       where AQPB608PGCODT = pn_pgcod
         and AQPB608ITSUC = pn_itsuc
         and AQPB608ITMOD = pn_itmod
         and AQPB608ITTRAN = pn_ittran
         and AQPB608ITNREL = pn_itnrel
         and AQPB608ITFCON = pn_itfcon;
    exception
      when others then
        my_errm := substr(sqlerrm, 1, 300);
        begin
          insert into aqpb923
            (AQPB923cod,
             AQPB923tsuc,
             AQPB923tmod,
             AQPB923tran,
             AQPB923nrel,
             AQPB923tord,
             AQPB923fcon,
             AQPB923flcl,
             AQPB923fimp,
             AQPB923obs,
             AQPB923fec,
             AQPB923hor,
             AQPB923usr)
          values
            (pn_pgcod,
             pn_itsuc,
             pn_itmod,
             pn_ittran,
             pn_itnrel,
             pn_itord,
             pn_itfcon,
             pv_flgcan,
             pv_flgimp,
             my_errm,
             TRUNC(SYSDATE),
             to_char(sysdate, 'HH24:MI:SS'),
             pv_user);
          commit;
        exception
          when others then
            null;
        end;
        return;
    end;
    --insercion del log 
    begin
      insert into aqpb923
        (AQPB923cod,
         AQPB923tsuc,
         AQPB923tmod,
         AQPB923tran,
         AQPB923nrel,
         AQPB923tord,
         AQPB923fcon,
         AQPB923flcl,
         AQPB923fimp,
         AQPB923doc,
         AQPB923mod,
         AQPB923suc,
         AQPB923mda,
         AQPB923pap,
         AQPB923cta,
         AQPB923ope,
         AQPB923sbo,
         AQPB923top,
         AQPB923obs,
         AQPB923fec,
         AQPB923hor,
         AQPB923usr)
      values
        (pn_pgcod,
         pn_itsuc,
         pn_itmod,
         pn_ittran,
         pn_itnrel,
         pn_itord,
         pn_itfcon,
         pv_flgcan,
         pv_flgimp,
         lv_ndoc,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbo,
         ln_top,
         pv_observ,
         TRUNC(SYSDATE),
         to_char(sysdate, 'HH24:MI:SS'),
         pv_user);
      commit;
    exception
      when others then
        my_errm := substr(sqlerrm, 1, 300);
        begin
          insert into aqpb923
            (AQPB923cod,
             AQPB923tsuc,
             AQPB923tmod,
             AQPB923tran,
             AQPB923nrel,
             AQPB923tord,
             AQPB923fcon,
             AQPB923flcl,
             AQPB923fimp,
             AQPB923doc,
             AQPB923mod,
             AQPB923suc,
             AQPB923mda,
             AQPB923pap,
             AQPB923cta,
             AQPB923ope,
             AQPB923sbo,
             AQPB923top,
             AQPB923obs,
             AQPB923fec,
             AQPB923hor,
             AQPB923usr)
          values
            (pn_pgcod,
             pn_itsuc,
             pn_itmod,
             pn_ittran,
             pn_itnrel,
             pn_itord,
             pn_itfcon,
             pv_flgcan,
             pv_flgimp,
             lv_ndoc,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             my_errm,
             TRUNC(SYSDATE),
             to_char(sysdate, 'HH24:MI:SS'),
             pv_user);
          commit;
        exception
          when others then
            null;
        end;
    end;
  end sp_cr_insert_log_voucher;

  procedure sp_cr_insert_log_impresion(pn_pgcod  in number,
                                       pn_itsuc  in number,
                                       pn_itmod  in number,
                                       pn_ittran in number,
                                       pn_itnrel in number,
                                       pn_itord  in number,
                                       pn_pais   in number,
                                       pn_petdoc in number,
                                       pv_pendoc in varchar2,
                                       pv_user   in varchar2,
                                       pv_flag   out varchar2) is
  
    my_errm VARCHAR2(300);
    ln_pais NUMBER(5);
    ln_tdoc NUMBER(5);
    lv_ndoc VARCHAR2(15);
    ln_flcl VARCHAR2(2);
    ln_fimp VARCHAR2(2);
    ln_cod  NUMBER(3);
    ln_mod  NUMBER(5);
    ln_suc  NUMBER(4);
    ln_mda  NUMBER(4);
    ln_pap  NUMBER(4);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_top  NUMBER(5);
    ln_sbo  NUMBER(4);
    ln_imp  NUMBER(17, 2);
    ld_fec  DATE;
    ln_cont NUMBER(2);
  
    ln_intcta NUMBER(2);
    ln_conyug NUMBER(2);
  
  begin
    ln_flcl := 'S';
    ln_fimp := 'S';
    --
    begin
      select pgfape into ld_fec from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
    --busqueda otros datos
    begin
      select d016.pgcod,
             d016.modulo,
             d016.itsucd,
             d016.moneda,
             d016.papel,
             d016.ctnro,
             d016.itoper,
             d016.itsubo,
             d016.ittope,
             d016.itimp8
        into ln_cod,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_imp
        from fsd015 d015
        join FSD016 d016
          on d015.pgcod = d016.pgcod
         and d015.itsuc = d016.itsuc
         and d015.itmod = d016.itmod
         and d015.ittran = d016.ittran
         and d015.itnrel = d016.itnrel
        join FSD010 d010
          on d010.pgcod = d016.pgcod
         and d010.aomod = d016.modulo
         and d010.aosuc = d016.itsucd
         and d010.aomda = d016.moneda
         and d010.aopap = d016.papel
         and d010.aocta = d016.ctnro
         and d010.aooper = d016.itoper
         and d010.aosbop = d016.itsubo
         and d010.aotope = d016.ittope
       where d015.pgcod = pn_pgcod
         and d015.itsuc = pn_itsuc
         and d015.itmod = pn_itmod
         and d015.ittran = pn_ittran
         and d015.itnrel = pn_itnrel
         and d015.itfcon = ld_fec
         and d016.itord = 10;
    EXCEPTION
      when others then
        ln_flcl := 'E';
        ln_fimp := 'N';
        my_errm := substr(sqlerrm, 1, 300);
    end;
    --** VALIDAR MODULO
    if ln_mod = 116 then
      ln_flcl := 'E';
      ln_fimp := 'N';
      my_errm := substr(sqlerrm, 1, 300);
    end if;
    --** TITULAR DE LA CUENTA
    if ln_flcl = 'S' then
      ln_flcl := 'E';
      begin
        select count(*)
          into ln_intcta
          from fsr008
         where ctnro = ln_cta
           and pepais = pn_pais
           and petdoc = pn_petdoc
           and pendoc = rpad(pv_pendoc, 12, ' ');
      EXCEPTION
        when others then
          ln_intcta := 0;
          my_errm   := substr(sqlerrm, 1, 300);
      end;
      if ln_intcta = 1 then
        ln_flcl := 'S';
      end if;
      if ln_flcl = 'E' then
        --hallamos el titular de la cuenta
        begin
          select pepais, petdoc, pendoc
            into ln_pais, ln_tdoc, lv_ndoc
            from fsr008
           where ctnro = ln_cta
             and cttfir = 'T' OFFSET 0 ROWS
           FETCH NEXT 1 ROWS ONLY;
        EXCEPTION
          when others then
            ln_flcl := 'E';
            my_errm := substr(sqlerrm, 1, 300);
        end;
        --validamos si es conyuge
        begin
          select count(*)
            into ln_conyug
            from fsr002
           where pepais = ln_pais
             and petdoc = ln_tdoc
             and pendoc = rpad(lv_ndoc, 12, ' ')
             and rpccyg = 66
             and rppais = pn_pais
             and rptdoc = pn_petdoc
             and rpndoc = rpad(pv_pendoc, 12, ' ');
        EXCEPTION
          when others then
            ln_conyug := 0;
            my_errm   := substr(sqlerrm, 1, 300);
        end;
        if ln_conyug = 1 then
          ln_flcl := 'S';
        end if;
      end if;
    end if;
    --valida si existe
    begin
      select count(*)
        into ln_cont
        from AQPB924
       where AQPB924cod = pn_pgcod
         and AQPB924tsuc = pn_itsuc
         and AQPB924tmod = pn_itmod
         and AQPB924tran = pn_ittran
         and AQPB924nrel = pn_itnrel
         and AQPB924tord = pn_itord
         and AQPB924fcon = ld_fec;
    end;
    if ln_cont > 0 then
      --actualizacion log
      update AQPB924
         set AQPB924pai  = pn_pais,
             AQPB924tdo  = pn_petdoc,
             AQPB924doc  = pv_pendoc,
             AQPB924flcl = ln_flcl,
             AQPB924fimp = ln_fimp,
             AQPB924fec  = TRUNC(SYSDATE),
             AQPB924hor  = to_char(sysdate, 'HH24:MI:SS')
       where AQPB924cod = pn_pgcod
         and AQPB924tsuc = pn_itsuc
         and AQPB924tmod = pn_itmod
         and AQPB924tran = pn_ittran
         and AQPB924nrel = pn_itnrel
         and AQPB924tord = pn_itord
         and AQPB924fcon = ld_fec;
      pv_flag := ln_flcl;
      commit;
    else
      --insercion del log 
      begin
        insert into AQPB924
          (AQPB924cod,
           AQPB924tsuc,
           AQPB924tmod,
           AQPB924tran,
           AQPB924nrel,
           AQPB924tord,
           AQPB924fcon,
           AQPB924sald,
           AQPB924flcl,
           AQPB924fimp,
           AQPB924pai,
           AQPB924tdo,
           AQPB924doc,
           AQPB924mod,
           AQPB924suc,
           AQPB924mda,
           AQPB924pap,
           AQPB924cta,
           AQPB924ope,
           AQPB924sbo,
           AQPB924top,
           AQPB924obs,
           AQPB924fec,
           AQPB924hor,
           AQPB924usr)
        values
          (pn_pgcod,
           pn_itsuc,
           pn_itmod,
           pn_ittran,
           pn_itnrel,
           pn_itord,
           ld_fec,
           ln_imp,
           ln_flcl,
           ln_fimp,
           pn_pais,
           pn_petdoc,
           pv_pendoc,
           ln_mod,
           ln_suc,
           ln_mda,
           ln_pap,
           ln_cta,
           ln_ope,
           ln_sbo,
           ln_top,
           '',
           TRUNC(SYSDATE),
           to_char(sysdate, 'HH24:MI:SS'),
           pv_user);
        pv_flag := ln_flcl;
        commit;
      exception
        when others then
          my_errm := substr(sqlerrm, 1, 300);
          begin
            insert into AQPB924
              (AQPB924cod,
               AQPB924tsuc,
               AQPB924tmod,
               AQPB924tran,
               AQPB924nrel,
               AQPB924tord,
               AQPB924fcon,
               AQPB924sald,
               AQPB924flcl,
               AQPB924fimp,
               AQPB924pai,
               AQPB924tdo,
               AQPB924doc,
               AQPB924mod,
               AQPB924suc,
               AQPB924mda,
               AQPB924pap,
               AQPB924cta,
               AQPB924ope,
               AQPB924sbo,
               AQPB924top,
               AQPB924obs,
               AQPB924fec,
               AQPB924hor,
               AQPB924usr)
            values
              (pn_pgcod,
               pn_itsuc,
               pn_itmod,
               pn_ittran,
               pn_itnrel,
               pn_itord,
               ld_fec,
               ln_imp,
               ln_flcl,
               ln_fimp,
               pn_pais,
               pn_petdoc,
               pv_pendoc,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top,
               my_errm,
               TRUNC(SYSDATE),
               to_char(sysdate, 'HH24:MI:SS'),
               pv_user);
            pv_flag := ln_flcl;
            commit;
          exception
            when others then
              null;
          end;
      end;
    end if;
  end sp_cr_insert_log_impresion;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Crd99_CNA(pn_pgcod  in number,
                                  pn_itsuc  in number,
                                  pn_itmod  in number,
                                  pn_ittran in number,
                                  pn_itnrel in number,
                                  pn_fecpro in date,
                                  pn_coderr out number,
                                  lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd(n_nrocta number) IS
      select d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aotope,
             d.aosbop,
             d.aostat
        from fsd010 d
       where d.aocta = n_nrocta
         and d.aomod in (select t111.modulo
                           from fst111 t111
                          where t111.Dscod = 50
                            and t111.Modulo != 116)
         and d.aosbop = (select max(d1.AOSBOP)
                           from fsd010 d1
                          where d1.PGCOD = d.pgcod
                            and d1.AOMOD = d.aomod
                            and d1.AOMDA = d.aomda
                            and d1.AOPAP = d.aopap
                            and d1.AOCTA = d.aocta
                            and d1.AOSUC = d.aosuc
                            and d1.AOOPER = d.aooper
                            and d1.AOTOPE = d.aotope)
       order by d.PGCOD,
                d.AOMOD,
                d.AOMDA,
                d.AOPAP,
                d.AOCTA,
                d.AOSUC,
                d.AOOPER,
                d.AOSBOP;
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    ln_sld_011  number;
    ld_fecguia  date;
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  BEGIN
    ld_fecguia := fn_get_FecGuia();
  
    --obtenermos la clave del credito
    begin
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    /*    ln_pais := 604;
    ln_tdoc := 21; 
    ln_ndoc := rpad('29555982',12,' ');--'29278775    ';*/
  
    lv_flgCan := 'N';
  
    --Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          --apachecoh 2022.09.28 modificacion
          if T_pgcod <> ln_pgcod or T_aomod <> ln_aomod or
             T_aosuc <> ln_aosuc or T_aocta <> ln_aocta or
             T_aomda <> ln_aomda or T_aopap <> ln_aopap or
             T_aooper <> ln_aooper or T_aosbop <> ln_aosbop or
             T_aotope <> ln_aotope then
            sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          else
            lv_flagCanc := 'S';
          end if;
          --apachecoh 2022.09.28 modificacion
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flag99 = 'N'o tiene obligaciones
    --        = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_Todos_Crd99_CNA;

  --**********************************************************************************************************--  
  procedure sp_cr_Todos_Aval99_CNA(pn_pgcod  in number,
                                   pn_itsuc  in number,
                                   pn_itmod  in number,
                                   pn_ittran in number,
                                   pn_itnrel in number,
                                   pn_fecpro in date,
                                   pn_coderr out number,
                                   lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) aosbop,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    pn_contador number;
    ln_sld_011  number;
    ld_fecguia  date;
  
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  
  BEGIN
    lv_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
  
    ld_fecguia := fn_get_FecGuia();
  
    --obtenermos la clave del credito
    begin
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        null;
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
  
    lv_flgCan := 'N';
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          --apachecoh 2022.09.28 modificacion
          if T_pgcod <> ln_pgcod or T_aomod <> ln_aomod or
             T_aosuc <> ln_aosuc or T_aocta <> ln_aocta or
             T_aomda <> ln_aomda or T_aopap <> ln_aopap or
             T_aooper <> ln_aooper or T_aosbop <> ln_aosbop or
             T_aotope <> ln_aotope then
            sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          else
            lv_flagCanc := 'S';
          end if;
          --apachecoh 2022.09.28 modificacion
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flagAval = 'N'o tiene obligaciones
    --          = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_Todos_Aval99_CNA;

  --**********************************************************************************************************--  
  procedure sp_cr_anular_impr_CNA(pn_pgcodc in number,
                                  pn_modc   in number,
                                  pn_succ   in number,
                                  pn_monc   in number,
                                  pn_papc   in number,
                                  pn_ctac   in number,
                                  pn_opec   in number,
                                  pn_sopec  in number,
                                  pn_topec  in number,
                                  pv_user   in varchar2,
                                  pn_coderr out number,
                                  pn_msgerr out varchar2) is
  
    my_errm VARCHAR2(32000);
    HORA    varchar2(15);
  
  BEGIN
    pn_coderr := 0;
  
    if pn_coderr = 0 then
      begin
        HORA := to_char(sysdate, 'HH24:MI:SS');
        update aqpb608
           set AQPB608PGCODC  = 9,
               AQPB608USEXCNA = pv_user,
               AQPB608FIMPCNA = 'N',
               AQPB608FCEXCNA = TO_DATE(SYSDATE),
               AQPB608HREXCNA = HORA
         where AQPB608PGCODC = pn_pgcodc
           and AQPB608MODC = pn_modc
           and AQPB608SUCC = pn_succ
           and AQPB608MONC = pn_monc
           and AQPB608PAPC = pn_papc
           and AQPB608CTAC = pn_ctac
           and AQPB608OPEC = pn_opec
           and AQPB608SOPEC = pn_sopec
           and AQPB608TOPEC = pn_topec;
        commit;
      EXCEPTION
        when others then
          pn_coderr := 9;
          pn_msgerr := 'Error al anular impresion CNA';
          my_errm   := SQLERRM;
          --DBMS_OUTPUT.put_line(my_errm);
      end;
    end if;
  END sp_cr_anular_impr_CNA;
  --**********************************************************************************************************--  
  procedure sp_cr_corresponde_CNA(pn_pais  in number,
                                  pn_tdoc  in number,
                                  pn_ndoc  in varchar2,
                                  pv_usua  in varchar2,
                                  pd_fecha in date,
                                  pn_cerr  out number,
                                  pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    l_pais number(5);
    l_tdoc number(5);
    l_ndoc character(12);
  
    ln_coderr number;
    lv_merror varchar2(5);
  
    ln_coderrAval number;
    lv_flgCanAval varchar2(5);
  
    cursor lst_cuentas(pais number, tdoc number, doc varchar2) is
      select Ctnro NroCta
        from fsr008
       Where Cttfir = 'T'
         and Pepais = pais
         and Petdoc = tdoc
         and Pendoc = rpad(doc, 12, ' ');
  begin
    --CURSOR DE CUENTAS
    for i in lst_cuentas(pn_pais, pn_tdoc, pn_ndoc) loop
      PQ_CR_VALI_CRED_CANC.sp_cr_Todos_Crd99_2(null,
                                               null,
                                               null,
                                               null,
                                               null,
                                               i.NroCta,
                                               null,
                                               null,
                                               null,
                                               ln_coderr,
                                               lv_merror);
    
      PQ_CR_VALI_CRED_CANC.sp_cr_Todos_Aval99_2(i.NroCta,
                                                ln_coderrAval,
                                                lv_flgCanAval);
    
      if lv_merror = 'N' and lv_flgCanAval = 'N' then
        pn_cerr := 1;
        pv_merr := 'S';
      else
        pn_cerr := 0;
        pv_merr := 'N';
      end if;
    
    end loop;
  END sp_cr_corresponde_CNA;
  --**********************************************************************************************************--    
  procedure sp_cr_es_castig_judic_venta(pn_pais  in number,
                                        pn_tdoc  in number,
                                        pn_ndoc  in varchar2,
                                        pv_usua  in varchar2,
                                        pd_fecha in date,
                                        pn_cerr  out number,
                                        pv_merr  out varchar2) is
    my_errm VARCHAR2(32000);
  
    l_pais number(5);
    l_tdoc number(5);
    l_ndoc character(12);
  
    ln_coderr number;
    lv_merror varchar2(5);
  
    ln_coderrAval number;
    lv_flgCanAval varchar2(5);
  
    cursor lst_cuentas(pais number, tdoc number, doc varchar2) is
      select Ctnro NroCta
        from fsr008
       Where Cttfir = 'T'
         and Pepais = pais
         and Petdoc = tdoc
         and Pendoc = rpad(doc, 12, ' ');
  begin
    --CURSOR DE CUENTAS
    for i in lst_cuentas(pn_pais, pn_tdoc, pn_ndoc) loop
      begin
        select 'S'
          into lv_merror
          from fsd010
         where aomod in (200, 33, 65)
           and aocta = i.NroCta
           and rownum = 1;
      exception
        when others then
          lv_merror := 'N';
      end;
      begin
        select 'S'
          into lv_flgCanAval
          from fsd010 f, xwf700 x, sng003 s
         where aomod in (200, 33, 65)
           and f.pgcod = x.xwfempresa
           and f.aomda = x.xwfmoneda
           and f.aopap = x.xwfpapel
           and f.aocta = x.xwfcuenta
           and f.aooper = x.xwfoperacion
           and x.xwfprcins = s.sng001inst
           and x.xwfcar3 = '1'
           and s.sng003cta = i.NroCta
           and rownum = 1;
      exception
        when others then
          lv_flgCanAval := 'N';
      end;
    
      if lv_merror = 'N' and lv_flgCanAval = 'N' then
        pn_cerr := 1;
        pv_merr := 'S';
      else
        pn_cerr := 0;
        pv_merr := 'N';
        return;
      end if;
    
    end loop;
  END sp_cr_es_castig_judic_venta;

end PQ_CR_VALI_CRED_CANC;
/

