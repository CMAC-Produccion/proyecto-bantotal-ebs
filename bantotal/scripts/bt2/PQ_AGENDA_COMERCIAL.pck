create or replace package agecom."PQ_AGENDA_COMERCIAL" is

  -- Author  : EBARROS
  -- Created : 01/12/2016 04:18:32 p.m.
  -- Purpose : Procedimientos de Agenda Comercial
  -- Fecha Modificación         : 12/08/2024
  -- Autor de Modificación      : Frank Pinto Carpio
  -- Descripcion Modificacion   : Se corrige procedimiento sp_insref
  -- Fecha Modificación         : 02/09/2024
  -- Autor de Modificación      : Frank Pinto Carpio
  -- Descripcion Modificacion   : Se aumentan y corrigen procedimientos para administracion de usuarios
  -- Fecha Modificación         : 02/12/2024
  -- Autor de Modificación      : Frank Pinto Carpio
  -- Descripcion Modificacion   : Se modifican sp lisage y se añaden reacciones de referidos
  -- Fecha Modificación         : 01/09/2025
  -- Autor de Modificación      : Frank Pinto Carpio
  -- Descripcion Modificacion   : Se agrega SP para CRM
  -- Public type declarations
  TYPE lc_liscur IS REF CURSOR;
  procedure sp_lisasi(pc_codact varchar2,
                      pc_codbas varchar2,
                      pc_codsuc number,
                      pc_codusu varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_opeXsuc(ps_codsuc in string,
                       ps_codusu in varchar2,
                       lc_liscur OUT types.cursor_type);
  procedure sp_insasi(ps_coding in varchar2,
                      ps_codact in varchar2,
                      ps_codbas in varchar2,
                      ps_numdoc in varchar2,
                      ps_usureg in varchar2,
                      ps_usuasi in varchar2);
  procedure sp_resasi(pn_codsuc number,
                      ps_codusu varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_inspro(ps_nombre in varchar, ps_nomusu in varchar);
  procedure sp_actpro(ps_codest in char,
                      ps_codigo in varchar2,
                      ps_desnom in varchar2,
                      ps_codusu in varchar2);
  procedure sp_estpro(ps_nompro in varchar,
                      ps_coderr out char,
                      ps_msgerr out varchar2);
  procedure sp_updprg(ps_nompro in varchar2,
                      pd_fecini in varchar2,
                      pd_fecfin in varchar2,
                      ps_codper in char,
                      ps_codusu in varchar);
  procedure sp_estprg(ps_nompro in varchar,
                      ps_coderr out char,
                      ps_msgerr out varchar2);
  procedure sp_inscon(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_codusu varchar2);
  procedure sp_lisdep(lc_liscur out types.cursor_type);
  procedure sp_lisprov(pc_coddep varchar2, lc_liscur out types.cursor_type);
  procedure sp_lisdis(pc_coddep  varchar2,
                      pc_codprov varchar2,
                      lc_liscur  out types.cursor_type);
  procedure sp_insref(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_indcon varchar2,
                      ps_paicon varchar2,
                      ps_tipcon varchar2,
                      ps_doccon varchar2,
                      ps_sbscli varchar2,
                      ps_sbscon varchar2,
                      ps_nomcli varchar2,
                      ps_nomcon varchar2,
                      ps_clineg varchar2,
                      ps_conneg varchar2,
                      ps_estsob varchar2,
                      ps_dessob varchar2,
                      ps_estrec varchar2,
                      ps_desrec varchar2,
                      ps_nument varchar2,
                      ps_conent varchar2,
                      ps_clijud varchar2,
                      ps_conjud varchar2,
                      ps_clicas varchar2,
                      ps_concas varchar2,
                      ps_clinor varchar2,
                      ps_clicpp varchar2,
                      ps_connor varchar2,
                      ps_concpp varchar2,
                      ps_calgen varchar2,
                      ps_calcli varchar2,
                      ps_calcon varchar2,
                      ps_escosb varchar2,
                      ps_decosb varchar2,
                      ps_segcli varchar2,
                      ps_vivcli varchar2,
                      ps_negcli varchar2,
                      ps_telfij varchar2,
                      ps_telneg varchar2,
                      ps_telcel varchar2,
                      ps_depviv varchar2,
                      ps_proviv varchar2,
                      ps_disviv varchar2,
                      ps_depneg varchar2,
                      ps_proneg varchar2,
                      ps_disneg varchar2,
                      ps_codana varchar2,
                      ps_codage varchar2,
                      ps_refdom varchar2,
                      ps_refneg varchar2,
                      ps_usuing varchar2,
                      ps_tipcli varchar2,
                      ps_tipcny varchar2,
                      ps_numina varchar2,
                      ps_inacon varchar2,
                      ps_segcon varchar2,
                      ps_actcli varchar2,
                      ps_actcon varchar2,
                      ps_estcre varchar2,
                      ps_crecon varchar2,
                      ps_fecdes varchar2,
                      ps_descon varchar2,
                      ps_fecnac varchar2,
                      ps_naccon varchar2,
                      ps_nomsec varchar2,
                      ps_agepre varchar2,
                      ps_otrana varchar2,
                      ps_moneva varchar2,
                      ps_descre varchar2,
                      ps_tiping varchar2,
                      ps_zonpro varchar2,
                      ps_fecvis varchar2,
                      ps_mailcl varchar2,
                      ps_horvis varchar2,
                      ps_tipact varchar2,
                      ps_coderr out varchar2);
  procedure sp_insprg(pn_codpro in number,
                      pd_fecini in varchar2,
                      pd_fecfin in varchar2,
                      ps_codper in char,
                      ps_codusu in varchar);
  procedure sp_lissuc(ps_codsuc number, lc_liscur out types.cursor_type);
  procedure sp_lisage(ps_codana varchar2,
                      ps_codact varchar2,
                      ps_codbas varchar2,
                      ps_codubi varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_insage(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      ps_codana varchar2,
                      pd_fecage varchar2,
                      ps_horage varchar2,
                      ps_coding varchar2,
                      ps_codact varchar2,
                      ps_codbas varchar2,
                      ps_codlon varchar2,
                      ps_codlat varchar2,
                      ps_resins out varchar);
  procedure sp_numage(ps_codana varchar2, lc_liscur out types.cursor_type);
  procedure sp_liscln(ps_codana varchar2,
                      ps_fecini varchar2,
                      ps_fecfin varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_lisres(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      ps_nomrol varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_vispre(pn_codres number, lc_liscur out types.cursor_type);
  procedure sp_visres(pn_preres number, lc_liscur out types.cursor_type);
  procedure sp_insvis(ps_corage varchar2,
                      ps_codusu varchar2,
                      ps_codres varchar2,
                      ps_desobs varchar2,
                      ps_codvis varchar2,
                      ps_horvis varchar2,
                      ps_codlat varchar2,
                      ps_codlon varchar2,
                      ps_codtip varchar2,
                      ps_coderr out varchar2,
                      ps_msgerr out varchar2);
  procedure sp_resvis(ps_corage varchar2, lc_liscur out types.cursor_type);
  procedure sp_detvis(ps_codpai varchar2,
                      ps_tipdoc varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_detubi(ps_codubi varchar2, lc_liscur out types.cursor_type);
  procedure sp_lisusu(lc_liscur out types.cursor_type);
  procedure sp_estusu(ps_nomusu varchar2);
  procedure sp_prgpro(lc_liscur out types.cursor_type);
  procedure sp_lisper(lc_liscur out types.cursor_type);
  procedure sp_lisrol(lc_liscur out types.cursor_type);
  procedure sp_lispai(lc_liscur out types.cursor_type);
  procedure sp_lisdoc(pc_lisdoc out types.cursor_type);
  procedure sp_valusu(ps_codusu varchar2, pc_lisdoc out types.cursor_type);
  procedure sp_repXas(ps_codsuc varchar2, pc_lisdoc out types.cursor_type);
  procedure sp_lispei(lc_liscur OUT types.cursor_type);
  procedure sp_lispro(lc_liscur out types.cursor_type);
  procedure sp_bloref(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_codact varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_insagepro(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         ps_codana varchar2,
                         pd_fecage varchar2);
  procedure sp_listra(ls_nomusu varchar2,
                      ls_codsuc varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_lisprm(ls_nomsuc varchar2,
                      ls_nomusu varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_instra(ps_numdoc varchar2,
                      ps_anaini varchar2,
                      ps_anafin varchar2);
  procedure sp_todsuc(lc_liscur out types.cursor_type);
  procedure sp_grcli(ps_nomusu varchar2, lc_liscur out types.cursor_type);
  procedure sp_datper(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_lising(lc_liscur out types.cursor_type);
  procedure sp_lisact(lc_liscur out types.cursor_type);
  procedure sp_lisbas(pc_codact varchar2, lc_liscur out types.cursor_type);
  procedure sp_aleage(ps_nomusu varchar2, lc_liscur out types.cursor_type);
  procedure sp_estaleage(ps_nomusu varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_datgrircc(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_version(ps_numver out varchar);
  procedure sp_griubi(ps_codubi varchar, pc_desubi out varchar);
  procedure sp_lisciu(lc_liscur out types.cursor_type);
  procedure sp_liscar(lc_liscur out types.cursor_type);
  procedure sp_hiscon(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_libcli(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2);
  procedure sp_lisusutra(ps_codusu varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_tracliage(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         ps_codact number,
                         ps_codusu varchar2,
                         ps_codasi varchar2);
  procedure sp_liscliage(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_actcli(ps_codpai  varchar2,
                      ps_codtip  varchar2,
                      ps_numdoc  varchar2,
                      ps_clinom  varchar2,
                      ps_depviv  varchar2,
                      ps_proviv  varchar2,
                      ps_disviv  varchar2,
                      ps_dirfij  varchar2,
                      ps_reffij  varchar2,
                      ps_depneg  varchar2,
                      ps_proneg  varchar2,
                      ps_disneg  varchar2,
                      ps_dirneg  varchar2,
                      ps_refneg  varchar2,
                      ps_telcli  varchar2,
                      ps_telneg  varchar2,
                      ps_telmov  varchar2,
                      ps_moneva  varchar2,
                      ps_connom  varchar2,
                      ps_doccon  varchar2,
                      ps_actcli  varchar2,
                      ps_destcre varchar2,
                      ps_tiping  varchar2,
                      ps_czonpro varchar2,
                      ps_mailcl  varchar2);
  procedure sp_atrmora(lc_liscur out types.cursor_type);
  procedure sp_atrsald(lc_liscur out types.cursor_type);
  procedure sp_hiscli(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type);
  procedure sp_elibus(ps_coding varchar2,
                      ps_codact varchar2,
                      ps_codbas varchar2,
                      ps_nomusu varchar2);
  procedure sp_insexc(ps_paicli varchar2,
                      ps_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_paicon varchar2,
                      ps_tipcon varchar2,
                      ps_numcon varchar2,
                      ps_nomcli varchar2,
                      ps_zonfij varchar2,
                      ps_dirfij varchar2,
                      ps_reffij varchar2,
                      ps_zonneg varchar2,
                      ps_dirneg varchar2,
                      ps_refneg varchar2,
                      ps_telfij varchar2,
                      ps_telmov varchar2,
                      ps_nomage varchar2,
                      ps_codana varchar2,
                      ps_usuing varchar2);
  procedure sp_exctobas(ps_usuing varchar2);
  procedure sp_exctoeva;
  procedure sp_lisusuage(ps_codsuc number, lc_liscur out types.cursor_type);
  procedure sp_lisusutran(ps_codsuc varchar,
                          lc_liscur out types.cursor_type);
  procedure sp_repcliven(ps_nomusu varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_repclispro(ps_nomusu varchar2,
                          lc_liscur out types.cursor_type);
  procedure sp_repcliges(ps_nomusu varchar2,
                         ps_fecini varchar2,
                         ps_fecfin varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_indmicalendario(ps_nomusu varchar2, ps_indmen out varchar2);
  procedure sp_datosusuario(ps_nomusu varchar2,
                            ps_desusu out varchar2,
                            ps_nomage out varchar2);
  procedure sp_liscalendariov2(ps_codana varchar2,
                               ps_fecini varchar2,
                               ps_fecfin varchar2,
                               ps_numdoc varchar2,
                               ps_indpen varchar2,
                               ps_codusu varchar2,
                               lc_liscur out types.cursor_type);
  procedure sp_montosolicitado(ps_codpai varchar2,
                               ps_codtip varchar2,
                               ps_numdoc varchar2,
                               ps_monsol out varchar2);
  procedure sp_rephojaruta(ps_codusu varchar2,
                           ps_fecrep varchar2,
                           ps_codpen varchar2,
                           lc_liscur out types.cursor_type);
  procedure sp_resnoprocede(lc_liscur out types.cursor_type);
  procedure sp_repclienteasig(ps_codusu    varchar2,
                              ps_fecini    varchar2,
                              ps_fecfin    varchar2,
                              ps_codage    varchar2,
                              ps_codusuact varchar2,
                              lc_liscur    out types.cursor_type);
  procedure sp_repseguicliente(ps_codusu varchar2,
                               ps_fecini varchar2,
                               ps_fecfin varchar2,
                               ps_codage varchar2,
                               ps_codana varchar2,
                               lc_liscur out types.cursor_type);
  procedure sp_lisusuagencia(ps_codage varchar2,
                             lc_liscur out types.cursor_type);
  procedure sp_eliminarcorreo(ps_corage varchar2);
  procedure sp_misti_lisactbas(lc_liscur out types.cursor_type);
  procedure sp_misti_lisvis(ps_codact number,
                            ps_codbas number,
                            pd_fecvis varchar2,
                            pn_tiplis number,
                            ps_codusu varchar2,
                            lc_liscur out types.cursor_type);
  procedure sp_misti_lisvisv2(ps_codact number,
                              ps_codbas number,
                              pd_fecvis varchar2,
                              pn_tiplis number,
                              ps_codusu varchar2,
                              ps_codubi varchar2,
                              lc_liscur out types.cursor_type);
  procedure sp_misti_lisvisv3(ps_codact number,
                              ps_codbas number,
                              pd_fecini varchar2,
                              pd_fecfin varchar2,
                              pn_tiplis number,
                              ps_codusu varchar2,
                              ps_codubi varchar2,
                              lc_liscur out types.cursor_type);
  procedure sp_misti_cliage(pn_tipdoc number,
                            ps_numdoc varchar2,
                            lc_liscur out types.cursor_type);
  procedure sp_misti_lisres(ln_codact number,
                            lc_liscur out types.cursor_type);
  procedure sp_misti_lisresvis(pd_fecvis varchar2,
                               ps_codusu varchar2,
                               pn_cantot out number,
                               pn_caneje out number,
                               lc_liscur out types.cursor_type);
  function fn_misti_fecrep(pn_corage in number) return varchar;
  procedure sp_misti_detvis(pc_corage number,
                            lc_liscur out types.cursor_type);
  procedure sp_lisresmodal(ln_codrol number,
                           ln_codact number,
                           lc_liscur out types.cursor_type);
  procedure sp_ubibases(ls_codusu varchar2,
                        lc_liscur out types.cursor_type);
  procedure sp_retcorage(ps_codpai varchar2,
                         ps_tipdoc varchar2,
                         ps_numdoc varchar2,
                         ps_codact varchar2,
                         ps_codusu varchar2,
                         lp_corage out varchar2);
  procedure sp_retcorage(ps_codpai varchar2,
                         ps_tipdoc varchar2,
                         ps_numdoc varchar2,
                         ps_codact varchar2,
                         lp_corage out varchar2);
  procedure sp_lisagetran(ls_nomsuc varchar2,
                          ls_nomusu varchar2,
                          lc_liscur out types.cursor_type,
                          lp_corage out varchar2);
  procedure sp_lisusuagetran(ls_nomusu varchar2,
                             lc_liscur out types.cursor_type);
  procedure lisusutranpI(ls_nomsuc varchar2,
                         ls_nomusu varchar2,
                         lc_liscur out types.cursor_type);
  procedure sp_retdatcony(ps_codpai varchar2,
                          ps_tipdoc varchar2,
                          ps_numdoc varchar2,
                          ps_paicon out varchar2,
                          ps_tipcon out varchar2,
                          ps_numcon out varchar2,
                          ps_nomcon out varchar2);
  function fn_datovisitafec(ps_corage varchar2) return date;
  function fn_datovisitares(ps_corage varchar2) return varchar2;
  procedure sp_insasipromotorven(ps_codact varchar2,
                                 ps_codbas varchar2,
                                 ps_numdoc varchar2,
                                 ps_usuasi varchar2,
                                 ps_codusu varchar2);
  procedure sp_repseguiclientedet(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                ps_codest varchar2,ps_tiprep varchar2,
                                lc_liscur out types.cursor_type);
  procedure sp_repshisporDNI(ps_doccli varchar2,
                             lc_liscur out types.cursor_type);
  procedure sp_loginses(ps_codusu varchar2);
  procedure sp_lisusumicalentodos(ps_numsuc varchar2,
                                  lc_liscur out types.cursor_type);
  procedure sp_listaSucurMiCalendario(lc_liscur out types.cursor_type,
                                      ln_totage out integer);
  procedure sp_lisusumicalentodosnombre(ps_numsuc varchar2,
                                        lc_liscur out types.cursor_type);
  function fn_resusuing(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2;
  function fn_resusuing2(pn_codpai in number,
                         pn_tipdoc in number,
                         ps_numdoc in varchar2,
                         ps_corcli number,
                         ps_usuing varchar2) return varchar2;
  function fn_resusufin(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2;
  function fn_ultfecvis(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2;
  function fn_ultobsvis(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number) return varchar2;
  procedure sp_crearperpool(ps_coderr out varchar2, ps_deserr out varchar2);
  procedure sp_lisperiodo(lc_liscur out types.cursor_type);
  procedure sp_lisprioridad(pc_codper varchar2,
                            pc_codrol varchar2,
                            lc_liscur out types.cursor_type);
  procedure sp_listotalusuarios(lc_liscur out types.cursor_type);
  procedure sp_desbloquear(ps_codpai in varchar,
                           ps_tipdoc in varchar,
                           ps_numdoc in varchar,
                           ps_codact in varchar,
                           ps_nomusu in varchar,
                           ps_coderr out char,
                           ps_msgerr out varchar2);
  procedure sp_lisactualizarref(ps_codana varchar2,
                                ps_fecini varchar2,
                                ps_numdoc varchar2,
                                ps_codusu varchar2,
                                lc_liscur out types.cursor_type);
  procedure sp_nomclidesb(ps_codpai in varchar2,
                          ps_tipdoc in varchar,
                          ps_numdoc in varchar,
                          ps_codact in varchar2,
                          ls_nomcli out varchar2,
                          ls_opeing out varchar2,
                          ls_sucing out varchar2,
                          ls_roling out varchar2,
                          ls_opeasi out varchar2,
                          ls_sucasi out varchar2,
                          ls_rolasi out varchar2,
                          ls_resvis out varchar2,
                          ls_fecvis out varchar2,
                          ls_desact out varchar2,
                          ps_coderr out varchar2,
                          ps_msgerr out varchar2);
  procedure sp_modificarprioridad(ps_codper in varchar2,
                                  ps_codrol in varchar,
                                  ps_codact in varchar,
                                  ps_codtip in varchar2,
                                  ps_coderr out varchar2,
                                  ps_msgerr out varchar2);
  procedure sp_tipmon(lc_liscur out types.cursor_type);
  procedure sp_desbloquear2(ps_corcli in varchar2,
                            ps_nomusu in varchar,
                            ps_coderr out char,
                            ps_msgerr out varchar2);
  procedure sp_rolext(lc_liscur out types.cursor_type);
  procedure sp_supext(lc_liscur out types.cursor_type);
  procedure sp_lisusuext(lc_liscur out types.cursor_type);
  procedure sp_editusuario(pc_codusu varchar2,
                           pc_codage varchar2,
                           pc_codrol varchar2,
                           pc_codsup varchar2,
                           ps_codest varchar2,
                           pc_usureg varchar2,
                           pc_nomusu varchar2,
                           ps_coderr out char,
                           ps_msgerr out varchar2);
  procedure sp_crearusuario(pc_codusu varchar2,
                            pc_codage varchar2,
                            pc_codrol varchar2,
                            pc_codsup varchar2,
                            pc_usureg varchar2,
                            pc_nomusu varchar2,
                            ps_coderr out char,
                            ps_msgerr out varchar2);
  procedure sp_procie2;
  procedure sp_listactbas(lc_liscur out types.cursor_type);
  procedure sp_listaactbas(lc_liscur out types.cursor_type,
                           ln_totact out integer);

  /* procedure sp_revdesem(pc_codusu varchar2,pc_corcli varchar2, 
  ps_coderr out char,ps_msgerr out varchar2);*/
  procedure sp_misti_tracli(pc_corage varchar2,
                            pc_tiping varchar2,
                            pc_paicli varchar2,
                            pc_tipdoc varchar2,
                            pc_numdoc varchar2,
                            pc_codcod out varchar2,
                            pc_codcol out varchar2,
                            pc_codtit out varchar2,
                            lc_liscur out types.cursor_type,
                            ps_coderr out char,
                            ps_msgerr out varchar2);
  procedure sp_misti_asigotroas(pc_codpai  varchar2,
                                pc_tipdoc  varchar2,
                                pc_numdoc  varchar2,
                                pc_valcam  out varchar2,
                                pc_mensaje out varchar2,
                                ps_coderr  out char,
                                ps_msgerr  out varchar2);
  procedure sp_misti_idenuevcam(pc_codpai  varchar2,
                                pc_tipdoc  varchar2,
                                pc_numdoc  varchar2,
                                pc_idennue out varchar2,
                                pc_codcod  out varchar2,
                                pc_codcol  out varchar2,
                                pc_codtit  out varchar2,
                                lc_liscur  out types.cursor_type,
                                ps_coderr  out char,
                                ps_msgerr  out varchar2);
  procedure sp_misti_exiscam(pc_codcod out varchar2,
                             ps_coderr out char,
                             ps_msgerr out varchar2);
  function fn_ocupa_Cliente(pn_CodPai in number,
                            pn_TipDoc in number,
                            ps_NumDoc in varchar2) return number;
  procedure sp_reprclimi;
  procedure sp_prsclimi;
  procedure sp_roreprogramarmisti2;
  procedure sp_psreprogramarmisti2;
  procedure sp_misti_valcampa(pc_codpai varchar2,
                              pc_tipdoc varchar2,
                              pc_numdoc varchar2,
                              pc_codusu varchar2,
                              pc_otroas out varchar2,
                              pc_menase out varchar2,
                              pc_indrec out varchar2,
                              pc_indcam out varchar2,
                              ps_coderr out char,
                              ps_msgerr out varchar2);
  procedure sp_misti_listacampana(ps_codusu varchar2,
                                  lc_liscur out types.cursor_type,
                                  ps_coderr out char,
                                  ps_msgerr out varchar2);
  procedure sp_misti_cieges(pc_codpai varchar2,
                            pc_tipdoc varchar2,
                            pc_numdoc varchar2,
                            pc_codusu varchar2,
                            ps_coderr out char,
                            ps_msgerr out varchar2);
  procedure sp_misti_ejepro(ps_coderr out char, ps_msgerr out varchar2);
  procedure sp_lisusuagetran2(ls_nomusu varchar2,
                              lc_liscur out types.cursor_type);
  procedure sp_listipreac(ps_tipreac varchar2,
                          lc_liscur  out types.cursor_type);
  procedure SP_CerrarEnBloque;
  procedure sp_codsegmento(ps_nomseg varchar2, ps_codseg out varchar2);

--// 2018.05.29 JPINTO - INICIO
  procedure sp_obtenerCampanias(BL_DATOS  IN OUT SYS_REFCURSOR,
                                pc_coderr out char,
                                pc_msgerr out varchar2);

  procedure sp_misti_tracli2(pc_corage varchar2,
                             pc_tiping varchar2,
                             pc_paicli varchar2,
                             pc_tipdoc varchar2,
                             pc_numdoc varchar2,
                             pc_codcod out varchar2,
                             pc_codcol out varchar2,
                             pc_codtit out varchar2,
                             pn_codact number,
                             pn_codbas number,
                             lc_liscur out types.cursor_type,
                             ps_coderr out char,
                             ps_msgerr out varchar2);

  procedure sp_misti_listacampana2(ps_codusu varchar2,
                                   pn_codact number,
                                   pn_codbas number,
                                   lc_liscur out types.cursor_type,
                                   ps_coderr out char,
                                   ps_msgerr out varchar2);

  procedure sp_obtenerCalificacion(BL_DATOS  IN OUT SYS_REFCURSOR,
                                   pn_codpai number,
                                   pn_tipdoc number,
                                   pc_numdoc varchar2,
                                   pc_coderr out char,
                                   pc_msgerr out varchar2);

  procedure sp_misti_valcampa2(pc_codpai varchar2,
                               pc_tipdoc varchar2,
                               pc_numdoc varchar2,
                               pc_codusu varchar2,
                               pc_otroas out varchar2,
                               pc_menase out varchar2,
                               pc_indrec out varchar2,
                               pc_indcam out varchar2,
                               pn_codact out number,
                               pn_codbas out number,
                               ps_coderr out char,
                               ps_msgerr out varchar2);

  procedure sp_misti_idenuevcam2(pc_codpai  varchar2,
                                 pc_tipdoc  varchar2,
                                 pc_numdoc  varchar2,
                                 pn_codact  number,
                                 pn_codbas  number,
                                 pc_idennue out varchar2,
                                 pc_codcod  out varchar2,
                                 pc_codcol  out varchar2,
                                 pc_codtit  out varchar2,
                                 lc_liscur  out types.cursor_type,
                                 ps_coderr  out char,
                                 ps_msgerr  out varchar2);
--// 2018.05.29 JPINTO - FINend PQ_AGENDA_COMERCIAL;
procedure sp_inscome(ps_paicli varchar2,ps_tipdoc varchar2,ps_numdoc varchar2,
                    ps_codest varchar2,ps_descom varchar2,ps_usumod varchar2,
                    ps_coderr out varchar2,ps_msgerr out varchar2);
procedure sp_liscom(lc_liscur out types.cursor_type);
procedure sp_repcomentario(ps_codusu varchar2,ps_fecini varchar2,ps_fecfin varchar2,
                           ps_codage varchar2,ps_codana varchar2,ps_codcom varchar2,
                           lc_liscur out types.cursor_type);
procedure sp_discom(ps_paicli varchar2,ps_tipdoc varchar2,ps_numdoc varchar2,
                      ps_codest out varchar2,ps_descom out varchar2); 
function fn_valcliARCO(pc_codpai varchar2,pc_tipdoc varchar2,pc_numdoc varchar2,pn_TipCon number) return number;                          
procedure sp_valcliARCO(pc_codpai varchar2,pc_tipdoc varchar2,pc_numdoc varchar2,ps_ctlreg out varchar2);
--//fpinto 01/09/2024 fpinto nuevos procedimientos para los usuarios
procedure sp_loginlog(ps_codusu varchar2, ps_ip varchar2, ps_host varchar2, ps_rol varchar2, ps_est varchar2, ps_modo varchar2);
procedure sp_loginout(ps_codusu varchar2, ps_est varchar2, ps_modo varchar2);
procedure sp_editrol(ps_codusu varchar2, ps_rol varchar2, ps_agencia varchar2);
procedure sp_lissuc2(lc_liscur out types.cursor_type);
procedure sp_lisusu2(lc_liscur out types.cursor_type);
procedure sp_estusu2(ps_nomusu varchar2);
procedure sp_borrarusuario(pc_codusu varchar2,ps_coderr out char,ps_msgerr out varchar2);
procedure sp_repusuariosagecom(lc_liscur out types.cursor_type);
procedure sp_repusuaccesos(pc_fecini varchar2, pc_fecfin varchar2, lc_liscur out types.cursor_type);
procedure sp_listra2(ls_nomusu varchar2, ls_codsuc varchar2, lc_liscur out types.cursor_type);
procedure sp_listra3(ls_nomusu varchar2, ls_codsuc varchar2, ps_codrole varchar2, lc_liscur out types.cursor_type);

--//fpinto 02/12/2024 Nuevas funciones para correccion datos referidos
function fn_datovisitas(ps_dni varchar2) return varchar2;
function fn_obtanalista(ps_dni varchar2) return varchar2;
--//fpinto 01/09/2025 Procedimiento para CRM
procedure sp_repseguiclientedetCRM(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                lc_liscur out types.cursor_type);
--sgamero - 06/10/2025                                
procedure sp_repseguiclientedet2(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                ps_codest varchar2,ps_tiprep varchar2,
                                lc_liscur out types.cursor_type);
end PQ_AGENDA_COMERCIAL;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body agecom."PQ_AGENDA_COMERCIAL" is

  procedure sp_lisasi(pc_codact varchar2,
                      pc_codbas varchar2,
                      pc_codsuc number,
                      pc_codusu varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisasi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Lista de los clientes por Asignar
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  
   as
    ln_codrol number;
  
  begin
    select ccodcar
      into ln_codrol
      from acmoper
     where trim(ccodope) = upper(trim(pc_codusu))
       and ccodest = '1';
  
    if ln_codrol = 105 or ln_codrol = 11 or ln_codrol = 13 or
       ln_codrol = 15 or ln_codrol = 17 then
    
      open lc_liscur for
        select bas.cnomact,
               eva.cclinom,
               tip.cdesatr,
               eva.cnumdoc,
               ubi.cdesdep,
               ubi.cdespro,
               ubi.cdesdis,
               cal.cdesatr,
               eva.ccodest,
               eva.ncodpri,
               bas.cnomact || ' ' || eva.cnumdoc as cclidoc,
               bas.cnomact,
               act.cnomact
          from ((select nindcier,
                        cclinom,
                        cnumdoc,
                        ccodest,
                        ncodpri,
                        ntipdoc,
                        ccodcal,
                        ncodact,
                        ncodbas,
                        nagepre,
                        czonfij,
                        czonneg,
                        ncoding,
                        ncorcli
                   from acdeval) union
                (select nindcier,
                        cclinom,
                        cnumdoc,
                        ccodest,
                        ncodpri,
                        ntipdoc,
                        ccodcal,
                        ncodact,
                        ncodbas,
                        nagepre,
                        czonfij,
                        czonneg,
                        ncoding,
                        ncorcli
                   from acheval)) eva
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ntipdoc
          left join actugeo ubi
            on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.ccodatr = eva.ccodcal
          left join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.cestado = 'A'
           and bas.ncodact = eva.ncodact
          left join actacti act
            on act.ncodact = eva.ncodact
           and act.cestado = 'A'
          left join acdasig asi
            on asi.ncorcli = eva.ncorcli
         where bas.cnomact = pc_codbas
           and act.cnomact = pc_codact
           and asi.cestado = '1'
           and trim(asi.ccodusu) = trim(upper(pc_codusu));
    
    else
      open lc_liscur for
        select distinct bas.cnomact,
                        eva.cclinom,
                        tip.cdesatr,
                        eva.cnumdoc,
                        ubi.cdesdep,
                        ubi.cdespro,
                        ubi.cdesdis,
                        cal.cdesatr,
                        eva.ccodest,
                        eva.ncodpri,
                        bas.cnomact || ' ' || eva.cnumdoc as cclidoc
          from ((select nindcier,
                        cclinom,
                        cnumdoc,
                        ccodest,
                        ncodpri,
                        ntipdoc,
                        ccodcal,
                        ncodact,
                        ncodbas,
                        nagepre,
                        czonfij,
                        czonneg,
                        ncoding,
                        ncorcli
                   from acdeval) union
                (select nindcier,
                        cclinom,
                        cnumdoc,
                        ccodest,
                        ncodpri,
                        ntipdoc,
                        ccodcal,
                        ncodact,
                        ncodbas,
                        nagepre,
                        czonfij,
                        czonneg,
                        ncoding,
                        ncorcli
                   from acheval)) eva
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ntipdoc
          left join actugeo ubi
            on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.ccodatr = eva.ccodcal
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.cestado = 'A'
           and bas.ncodact = eva.ncodact
         inner join actacti act
            on act.ncodact = eva.ncodact
           and act.cestado = 'A'
          left join acdasig asi
            on asi.ncorcli = eva.ncorcli
         where eva.ccodest in ('1')
           and (eva.ccodcal in ('1', '2') or
               eva.ccodcal = '3' and eva.ncoding = '3')
           and bas.cnomact = pc_codbas
           and act.cnomact = pc_codact
           and eva.ccodest = '1'
           and eva.nagepre = pc_codsuc
           and asi.ncorcli is null
           and eva.nindcier = '0';
    end if;
  end sp_lisasi;

  procedure sp_opeXsuc(ps_codsuc in string,
                       ps_codusu in varchar2,
                       lc_liscur OUT types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_opeXsuc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Lista de Operadores por Sucursal
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
  begin
    declare
      ls_codrol number;
      ls_codcar number;
    begin
    
      select ccodcar
        into ls_codcar
        from acmoper
       where trim(ccodope) = upper(trim(ps_codusu))
         and ccodest = '1';
    
      select count(*)
        into ls_codrol
        from ACMOPER
       where upper(trim(ccodope)) = upper(trim(ps_codusu))
         and ccodcar = 201
         and ccodest = '1';
    
      if ls_codrol > 0 then
        open lc_liscur for
          select pue.ccodope, pers.cnomope
            from ACDAGUS pue
           inner join ACMOPER pers
              on pue.ccodope = pers.ccodope
             and pers.ccodest = '1'
           where ncodsuc = ps_codsuc
             and pers.ccodcar in (200, 201, 202)
             and upper(trim(pers.ccodjef)) = upper(trim(ps_codusu));
      else
        if ls_codcar = 105 or ls_codcar = 11 or ls_codcar = 671 or
           ls_codcar = 13 or ls_codcar = 15 or ls_codcar = 17 then
          open lc_liscur for
            select ccodope, cnomope
              from acmoper
             where ccodjef = upper(trim(ps_codusu))
               and ccodest = '1';
        
        else
          open lc_liscur for
            select pue.ccodope, pers.cnomope
              from ACDAGUS pue
             inner join ACMOPER pers
                on pue.ccodope = pers.ccodope
               and pers.ccodest = '1'
             where ncodsuc = ps_codsuc
               and pers.ccodcar in (200, 201, 202);
        end if;
      end if;
      if trim(ps_codsuc) = '0' then
        open lc_liscur for
          select pue.ccodope, pers.cnomope
            from ACDAGUS pue
           inner join ACMOPER pers
              on pue.ccodope = pers.ccodope
             and pers.ccodest = '1'
           where pers.ccodcar in (200, 201, 202);
      end if;
    
    end;
  end sp_opeXsuc;

  procedure sp_insasi(ps_coding in varchar2,
                      ps_codact in varchar2,
                      ps_codbas in varchar2,
                      ps_numdoc in varchar2,
                      ps_usureg in varchar2,
                      ps_usuasi in varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_insasi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Grabar cliente a la tabla de asignación
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
    ls_estcli number;
    ls_estasi char(1);
    ln_codact number;
    ln_codbas number;
  begin
  
    select ncodact into ln_codact from actacti where cnomact = ps_codact;
    select ncodbas
      into ln_codbas
      from actbase
     where ncodact = ln_codact
       and cnomact = ps_codbas;
  
    select count(*), min(cestado)
      into ls_estcli, ls_estasi
      from acdasig
     where trim(cnumdoc) = trim(ps_numdoc)
       and ncodact = ln_codact;
  
    ls_estcli := nvl(ls_estcli, 2);
    ls_estasi := nvl(ls_estasi, 2);
  
    --if ls_estasi <>'1' then
    if ls_estcli = 0 then
      insert into acdasig
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               to_char(sysdate, 'yyyy/mm/dd'),
               ps_usuasi,
               ps_usureg,
               to_char(sysdate, 'hh24:mi:ss'),
               ps_usureg,
               sysdate,
               0,
               ncorcli,
               SEQ_CORASI.NEXTVAL
          from (select *
                  from (select *
                          from ((select nidebas,
                                        nidepro,
                                        ncoding,
                                        ncodact,
                                        ncodbas,
                                        npaicli,
                                        ntipdoc,
                                        cnumdoc,
                                        ncorcli,
                                        dfeceva
                                   from acdeval
                                  where cnumdoc = ps_numdoc
                                    and ncodact = ln_codact
                                    and ccodest = '1') union
                                (select nidebas,
                                        nidepro,
                                        ncoding,
                                        ncodact,
                                        ncodbas,
                                        npaicli,
                                        ntipdoc,
                                        cnumdoc,
                                        ncorcli,
                                        dfeceva
                                   from acheval
                                  where cnumdoc = ps_numdoc
                                    and ncodact = ln_codact
                                    and ccodest = '1'))
                         order by dfeceva desc)
                 where ROWNUM = 1);
      commit;
    else
      insert into achasig
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               cestado,
               sysdate,
               dfecasi,
               ccodusu,
               cusuasi,
               chorasi,
               cusumod,
               dfecmod,
               nindasi,
               ncorcli,
               ncorasi
          from acdasig
         where ncodact = ln_codact
           and cnumdoc = ps_numdoc;
      commit;
    
      delete acdasig
       where ncodact = ln_codact
         and cnumdoc = ps_numdoc;
      commit;
    
      insert into acdasig
        select nidebas,
               nidepro,
               ncoding,
               ln_codact,
               ln_codbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               to_char(sysdate, 'yyyy/mm/dd'),
               ps_usuasi,
               ps_usureg,
               to_char(sysdate, 'hh24:mi:ss'),
               ps_usureg,
               sysdate,
               0,
               ncorcli,
               SEQ_CORASI.NEXTVAL
          from (select *
                  from (select *
                          from ((select nidebas,
                                        nidepro,
                                        ncoding,
                                        ncodact,
                                        ncodbas,
                                        npaicli,
                                        ntipdoc,
                                        cnumdoc,
                                        ncorcli,
                                        dfeceva
                                   from acdeval
                                  where cnumdoc = ps_numdoc
                                    and ncodact = ln_codact
                                    and ccodest = '1') union
                                (select nidebas,
                                        nidepro,
                                        ncoding,
                                        ncodact,
                                        ncodbas,
                                        npaicli,
                                        ntipdoc,
                                        cnumdoc,
                                        ncorcli,
                                        dfeceva
                                   from acheval
                                  where cnumdoc = ps_numdoc
                                    and ncodact = ln_codact
                                    and ccodest = '1'))
                         order by dfeceva desc)
                 where ROWNUM = 1);
      commit;
    end if;
  
    --else 
    update acdasig
       set ccodusu = trim(upper(ps_usuasi)),
           cusuasi = trim(upper(ps_usureg))
     where cnumdoc = trim(ps_numdoc)
       and ncodact = ln_codact
       and ncodbas = ln_codbas;
    commit;
    -- end if;
    update acdeval
       set ccodest = '2'
     where ncodact = ln_codact
       and cnumdoc = ps_numdoc;
    update acheval
       set ccodest = '2'
     where ncodact = ln_codact
       and cnumdoc = ps_numdoc;
    commit;
  
    update achasig
       set cestado = '2'
     where ncodact = ln_codact
       and cnumdoc = ps_numdoc;
  
    commit;
  end sp_insasi;

  procedure sp_resasi(pn_codsuc number,
                      ps_codusu varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_resasi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Agrupado por base, ingreso y actividad de los clientes por asignar
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  
   as
  
    ls_codrol number;
  begin
  
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = trim(upper(ps_codusu))
       and ccodest = '1';
    if ls_codrol = 105 or ls_codrol = 11 or ls_codrol = 13 or
       ls_codrol = 15 or ls_codrol = 17 then
      open lc_liscur for
        select act.cnomact, bas.cnomact, count(*)
          from acdasig asi
          left join actacti act
            on act.ncodact = asi.ncodact
           and act.cestado = 'A'
          left join actbase bas
            on bas.ncodbas = asi.ncodbas
           and bas.cestado = 'A'
           and bas.ncodact = act.ncodact
         where asi.cestado = '1'
           and asi.cestado in ('1')
           and trim(asi.ccodusu) = trim(upper(ps_codusu))
         group by act.cnomact, bas.cnomact;
    
    else
      open lc_liscur for
        select act.cnomact, bas.cnomact, count(*)
          from (select * from acdeval union select * from acheval)
               
               eva
        
          left join actacti act
            on act.ncodact = eva.ncodact
           and act.cestado = 'A'
          left join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.cestado = 'A'
           and bas.ncodact = act.ncodact
          left join acdasig asi
            on asi.ncorcli = eva.ncorcli
         where ccodest = '1'
           and nagepre = pn_codsuc
           and eva.ccodest in ('1')
           and (eva.ccodcal in ('1', '2') or
               eva.ccodcal = '3' and eva.ncoding = '3')
           and eva.nindcier = '0'
           and asi.ncorcli is null
        --and ccodcal is not null
         group by act.cnomact, bas.cnomact;
    
    end if;
  end sp_resasi;

  procedure sp_inspro(ps_nombre in varchar, ps_nomusu in varchar)
  -- *****************************************************************
    -- Nombre                     : sp_inspro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Insertar Proceso
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
  begin
    declare
      ln_codigo int;
      ln_contar int;
    begin
      select count(*)
        into ln_contar
        from acmproc
       where cnompro = ps_nombre;
      if ln_contar = 0 then
        select coalesce(max(NCODPRO), 0) + 1 into ln_codigo from acmproc;
        insert into acmproc
        values
          (ln_codigo,
           '1',
           ps_nombre,
           ps_nomusu,
           SYSDATE,
           ps_nomusu,
           SYSDATE);
        commit;
      end if;
    end;
  end sp_inspro;

  procedure sp_actpro(ps_codest in char,
                      ps_codigo in varchar2,
                      ps_desnom in varchar2,
                      ps_codusu in varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_actpro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Actualizar nombre del Proceso
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
  begin
    update acmproc
       set cestado = ps_codest,
           cnompro = trim(ps_desnom),
           cusumod = ps_codusu,
           DFECMOD = sysdate
     where trim(CNOMPRO) = trim(ps_codigo);
    commit;
  end sp_actpro;

  procedure sp_estpro(ps_nompro in varchar,
                      ps_coderr out char,
                      ps_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_estpro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Procedimiento para cambiar el estado del procedimiento
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estact char(1);
  begin
    select Cestado
      into ls_estact
      from acmproc
     where trim(cnompro) = trim(ps_nompro);
    if (ls_estact = '1') then
      update acmproc
         set cestado = '2'
       where trim(cnompro) = trim(ps_nompro);
    
    else
      update acmproc
         set cestado = '1'
       where trim(cnompro) = trim(ps_nompro);
    end if;
    commit;
  
  exception
    when no_data_found then
    
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
    
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_estpro;

  procedure sp_updprg(ps_nompro in varchar2,
                      pd_fecini in varchar2,
                      pd_fecfin in varchar2,
                      ps_codper in char,
                      ps_codusu in varchar)
  -- *****************************************************************
    -- Nombre                     : sp_updprg
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : EBDC
    -- Uso                        : Actualizar Programación
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
  begin
    declare
      ls_fecini date;
      ls_fecfin date;
      ls_codpro int;
    begin
      begin
        select to_date(pd_fecini, 'DD/MM/YYYY'),
               to_date(pd_fecfin, 'DD/MM/YYYY')
          into ls_fecini, ls_fecfin
          from dual;
        if ls_fecini > ls_fecfin then
          select to_date(pd_fecini, 'DD/MM/YYYY'),
                 to_date(pd_fecfin, 'DD/MM/YYYY')
            into ls_fecfin, ls_fecini
            from dual;
        end if;
        select ncodpro
          into ls_codpro
          from acmproc
         where cnompro = ps_nompro;
        update acdproc
           set cestado = '1',
               dfecini = ls_fecini,
               dfecfin = ls_fecfin,
               cusumod = ps_codusu,
               ccodper = ps_codper,
               dfecmod = to_date(sysdate, 'DD/MM/YYYY')
         where ncodpro = ls_codpro;
      end;
    
    end;
  end sp_updprg;

  procedure sp_estprg(ps_nompro in varchar,
                      ps_coderr out char,
                      ps_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_estprg
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Procedimiento para cambiar el estado de la programacion
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estact char(1);
    ln_codpro numeric;
  begin
    select prg.cestado, pro.ncodpro
      into ls_estact, ln_codpro
      from acdproc prg
    
     inner join acmproc pro
        on pro.ncodpro = prg.ncodpro
     where pro.cnompro = ps_nompro;
    if (ls_estact = '1') then
      update acdproc set cestado = '2' where ncodpro = ln_codpro;
    
    else
      update acdproc set cestado = '1' where ncodpro = ln_codpro;
    end if;
    commit;
  
  exception
    when no_data_found then
    
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
    
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_estprg;

  procedure sp_inscon(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_codusu varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_inscon
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Ingreso al histórico de Consulta
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************                
   as
  begin
    insert into achcons
      (npaicli, ntipdoc, cnumdoc, dfeccon, cusucon)
    values
      (pn_codpai, pn_tipdoc, ps_numdoc, sysdate, upper(trim(ps_codusu)));
    commit;
  end sp_inscon;

  procedure sp_lisdep(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisdep
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de departamentos por Ubigeo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select distinct cast(ccoddep as int) as ccoddep, cdesdep
        from actugeo
       where ccoddep > 0
       order by 1;
  end sp_lisdep;

  procedure sp_lisprov(pc_coddep varchar2, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisprov
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de provincias por Ubigeo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select distinct cast(ccodpro as int) as ccodpro, cdespro
        from actugeo
       where cast(ccoddep as int) = pc_coddep
         and cast(ccoddis as int) > 0
       order by 1;
  end sp_lisprov;

  procedure sp_lisdis(pc_coddep  varchar2,
                      pc_codprov varchar2,
                      lc_liscur  out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisdis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de distritos por Ubigeo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select distinct cast(ccoddis as int) as ccoddis, cdesdis
        from actugeo
       where cast(ccoddep as int) = pc_coddep
         and cast(ccodpro as int) = pc_codprov
         and cast(ccoddis as int) > 0
       order by 1;
  end sp_lisdis;

  procedure sp_insref(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_indcon varchar2,
                      ps_paicon varchar2,
                      ps_tipcon varchar2,
                      ps_doccon varchar2,
                      ps_sbscli varchar2,
                      ps_sbscon varchar2,
                      ps_nomcli varchar2,
                      ps_nomcon varchar2,
                      ps_clineg varchar2,
                      ps_conneg varchar2,
                      ps_estsob varchar2,
                      ps_dessob varchar2,
                      ps_estrec varchar2,
                      ps_desrec varchar2,
                      ps_nument varchar2,
                      ps_conent varchar2,
                      ps_clijud varchar2,
                      ps_conjud varchar2,
                      ps_clicas varchar2,
                      ps_concas varchar2,
                      ps_clinor varchar2,
                      ps_clicpp varchar2,
                      ps_connor varchar2,
                      ps_concpp varchar2,
                      ps_calgen varchar2,
                      ps_calcli varchar2,
                      ps_calcon varchar2,
                      ps_escosb varchar2,
                      ps_decosb varchar2,
                      ps_segcli varchar2,
                      ps_vivcli varchar2,
                      ps_negcli varchar2,
                      ps_telfij varchar2,
                      ps_telneg varchar2,
                      ps_telcel varchar2,
                      ps_depviv varchar2,
                      ps_proviv varchar2,
                      ps_disviv varchar2,
                      ps_depneg varchar2,
                      ps_proneg varchar2,
                      ps_disneg varchar2,
                      ps_codana varchar2,
                      ps_codage varchar2,
                      ps_refdom varchar2,
                      ps_refneg varchar2,
                      ps_usuing varchar2,
                      ps_tipcli varchar2,
                      ps_tipcny varchar2,
                      ps_numina varchar2,
                      ps_inacon varchar2,
                      ps_segcon varchar2,
                      ps_actcli varchar2,
                      ps_actcon varchar2,
                      ps_estcre varchar2,
                      ps_crecon varchar2,
                      ps_fecdes varchar2,
                      ps_descon varchar2,
                      ps_fecnac varchar2,
                      ps_naccon varchar2,
                      ps_nomsec varchar2,
                      ps_agepre varchar2,
                      ps_otrana varchar2,
                      ps_moneva varchar2,
                      ps_descre varchar2,
                      ps_tiping varchar2,
                      ps_zonpro varchar2,
                      ps_fecvis varchar2,
                      ps_mailcl varchar2,
                      ps_horvis varchar2,
                      ps_tipact varchar2,
                      ps_coderr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_insref
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Ingreso de referido
    -- Estado                     : Activo
    -- Fecha Modificación         : 12/08/2024
    -- Autor de Modificación      : Frank Pinto Carpio
    -- Descripcion Modificacion   : Se añade variable para Cnomsec
    -- *****************************************************************  
   as
    ls_indcon  varchar2(2);
    ls_paicon  varchar2(3);
    ls_tipcon  varchar2(2);
    ls_doccon  varchar(15);
    ls_sbscli  varchar(15);
    ls_sbscon  varchar(15);
    ls_nument  varchar(3);
    ls_conent  varchar(3);
    ls_ubiviv  varchar2(8);
    ls_ubineg  varchar2(8);
    ls_codage  varchar2(4);
    ln_indest  number;
    ls_refdom  varchar2(301);
    ls_refneg  varchar2(301);
    ls_segcli  varchar2(100);
    ls_nomcon  varchar2(100);
    ls_nomcli  varchar2(100);
    ls_conneg  varchar2(1);
    ls_conjud  varchar2(1);
    ls_decosb  varchar2(2);
    ls_codana  varchar2(10);
    ls_vivcli  varchar2(300);
    ls_negcli  varchar2(300);
    ls_concas  varchar2(1);
    ls_connor  varchar2(1);
    ls_concpp  varchar2(1);
    ls_escosb  varchar2(1);
    ls_calcon  varchar2(1);
    ls_dessob  varchar2(2);
    ls_usuing  varchar(10);
    ls_tipcny  varchar(2);
    ls_inacon  number;
    ls_segcon  varchar(100);
    ls_actcon  varchar(100);
    ls_crecon  varchar(1);
    ls_descon  varchar(10);
    ls_fecdes  varchar(10);
    ln_rolusu  number;
    ln_ageing  number;
    ls_destip  varchar2(40);
    ls_resagen varchar2(50);
    ln_codbas  number;
    ls_nombas  varchar2(50);
    ls_naccon  date;
    ls_naccli  date;
    ls_codact  number;
    ls_nomact  varchar2(100);
    ls_nomsec  varchar2(60); --se añade nueva variable fpinto 12/08/2024
  begin
  
    ps_coderr := '0000';
  
    select case
             when count(*) > 0 then
              '0001'
             else
              '0000'
           end
      into ps_coderr
      from (select ncorage, ncorasi
              from acdagen
             where cnumdoc = ps_numdoc
               and ntipdoc = pn_tipdoc
               and npaicli = pn_codpai
               and ncodact in (4, 1)
            union all
            select ncorage, ncorasi
              from achagen
             where cnumdoc = ps_numdoc
               and ntipdoc = pn_tipdoc
               and npaicli = pn_codpai
               and ncodact in (4, 1)) a
    
     where ncorasi in
           (select ncorasi
              from (select ncorasi, ncorcli
                      from acdasig
                     where cnumdoc = ps_numdoc
                       and ntipdoc = pn_tipdoc
                       and npaicli = pn_codpai
                       and ncodact in (4, 1)
                    union all
                    select ncorasi, ncorcli
                      from achasig
                     where cnumdoc = ps_numdoc
                       and ntipdoc = pn_tipdoc
                       and npaicli = pn_codpai
                       and ncodact in (4, 1)) b
            
             where ncorcli in (select ncorcli
                                 from acdeval
                                where cnumdoc = ps_numdoc
                                  and ntipdoc = pn_tipdoc
                                  and npaicli = pn_codpai
                                  and nindcier = 0
                                  and ncodact in (4, 1)
                               union all
                               select ncorcli
                                 from acheval
                                where cnumdoc = ps_numdoc
                                  and ntipdoc = pn_tipdoc
                                  and npaicli = pn_codpai
                                  and nindcier = 0
                                  and ncodact in (4, 1)));
  
    if ps_coderr = '0001' then
      return;
    end if;
  
    if ps_tipact = '0' then
      ls_codact := 1;
      select case
               when ccodcar in (52, 50, 51) then
                7
               when ccodcar in (101, 105, 102, 108) then
                5
               when ccodcar in (103, 104) then
                11
               when ccodcar in (8, 9, 17) then
                6
               when ccodcar in (107) then
                9
               when ccodcar in (12, 11) then
                12
               when ccodcar in (13, 14) then
                13
               when ccodcar in (15, 16) then
                14
               else
                10
             end
        into ln_codbas
        from acmoper
       where ccodope = upper(ps_usuing)
         and ccodest = '1';
    
    else
      ls_codact := 5;
      ln_codbas := 1;
    end if;
  
    select ncodsuc
      into ln_ageing
      from acdagus
     where rownum = 1
       and ccodope = upper(ps_usuing);
  
    select ncodrol
      into ln_rolusu
      from acdusua
     where ccodusu = upper(trim(ps_usuing))
       and ccodest = 1;
  
    if ps_inacon = ' ' then
      ls_inacon := 0;
    else
      ls_inacon := ps_inacon;
    end if;
  
    ls_tipcny := ps_tipcny;
    --ls_inacon := ps_inacon;
    ls_segcon := ps_segcon;
    ls_actcon := ps_actcon;
    ls_crecon := ps_crecon;
    ls_descon := ps_descon;
  
    if ps_descon = 'NO EXISTE 999' then
      ls_descon := null;
    else
      ls_descon := trim(ps_descon);
    end if;
  
    if ps_fecdes = 'NO EXISTE 999' then
      ls_fecdes := null;
    else
      ls_fecdes := trim(ps_fecdes);
    end if;
  
    if ps_refdom = ' ' then
      ls_refdom := null;
    else
      ls_refdom := upper(trim(ps_refdom));
    end if;
    if ps_refneg = ' ' then
      ls_refneg := null;
    else
      ls_refneg := upper(trim(ps_refneg));
    end if;
    if ps_indcon = ' ' then
      ls_indcon := 'N';
    else
      ls_indcon := ps_indcon;
    end if;
  
    if ps_paicon = ' ' then
      ls_paicon := null;
    else
      ls_paicon := ps_paicon;
    end if;
  
    if ps_tipcon = ' ' then
      ls_tipcon := null;
    else
      ls_tipcon := ps_tipcon;
    end if;
  
    if ps_doccon = ' ' then
      ls_doccon := null;
    else
      ls_doccon := ps_doccon;
    end if;
  
    if ps_sbscli = ' ' or ps_sbscli = 'N' then
      ls_sbscli := null;
    else
      ls_sbscli := ps_sbscli;
    end if;
  
    if ps_sbscon = ' ' or ps_sbscon = 'N' then
      ls_sbscon := null;
    else
      ls_sbscon := ps_sbscon;
    end if;
  
    if ps_nument = ' ' then
      ls_nument := null;
    else
      ls_nument := ps_nument;
    end if;
  
    if ps_conent = ' ' then
      ls_conent := null;
    else
      ls_conent := ps_conent;
    end if;
  
    if ps_codage = ' ' then
      ls_codage := null;
    else
      ls_codage := ps_codage;
    end if;
  
    ls_usuing := upper(trim(ps_usuing));
  
    if ps_depviv = ' ' or ps_proviv = ' ' or ps_disviv = ' ' then
      ls_ubiviv := null;
    else
      select max(cubigeo)
        into ls_ubiviv
        from actugeo
       where cdesdep = ps_depviv
         and cdespro = ps_proviv
         and cdesdis = ps_disviv;
    end if;
  
    if ps_depneg = ' ' or ps_proneg = ' ' or ps_disneg = ' ' then
      ls_ubineg := null;
    else
      select max(cubigeo)
        into ls_ubineg
        from actugeo
       where cdesdep = ps_depneg
         and cdespro = ps_proneg
         and cdesdis = ps_disneg;
    end if;
  
    ls_segcli := trim(ps_segcli);
    if ls_segcli = 'N' then
      ls_segcli := null;
    end if;
  
    if ps_nomcon <> ' ' and ps_nomcon <> 'N' then
      ls_nomcon := upper(trim(ps_nomcon));
    end if;
  
    if ps_conneg <> ' ' then
      ls_conneg := ps_conneg;
    end if;
  
    if ps_conjud <> ' ' then
      ls_conjud := ps_conjud;
    end if;
  
    if ps_concas <> ' ' then
      ls_concas := ps_concas;
    else
      ls_concas := 'N';
    end if;
  
    if ps_connor <> ' ' then
      ls_connor := ps_connor;
    else
      ls_connor := 'N';
    end if;
  
    if ps_concpp <> ' ' then
      ls_concpp := ps_concpp;
    else
      ls_concpp := 'N';
    end if;
  
    if ps_decosb = ' ' or ps_decosb is null then
      ls_decosb := 'N';
    else
      ls_decosb := ps_decosb;
    end if;
  
    if ps_escosb <> ' ' then
      ls_escosb := ps_escosb;
    end if;
  
    if ps_codana = ' ' then
      ls_codana := null;
    else
      ls_codana := upper(trim(ps_codana));
    end if;
    if ps_nomcli = ' ' or ps_nomcli = 'N' then
      ls_nomcli := ps_nomcli;
    else
      ls_nomcli := upper(trim(ps_nomcli));
    end if;
  
    if ps_dessob is null then
      ls_dessob := 'N';
    else
      ls_dessob := ps_dessob;
    end if;
  
    ls_calcon := trim(ps_calcon);
    ls_vivcli := upper(trim(ps_vivcli));
    ls_negcli := upper(trim(ps_negcli));
    if ls_indcon = 'N' then
      ls_paicon := null;
      ls_tipcon := null;
      ls_doccon := null;
      ls_sbscon := null;
      ls_nomcon := null;
      ls_conneg := null;
      ls_conent := null;
      ls_conjud := null;
      ls_concas := null;
      ls_connor := null;
      ls_concpp := null;
      ls_escosb := null;
      ls_calcon := null;
      ls_decosb := null;
      ls_tipcny := null;
      ls_inacon := null;
      ls_segcon := null;
      ls_actcon := null;
      ls_crecon := null;
      ls_descon := null;
    end if;
  
    if ps_naccon = ' ' then
      ls_naccon := null;
    else
      ls_naccon := to_date(ps_naccon, 'dd/mm/yyyy');
    end if;
    if ps_fecnac = ' ' then
      ls_naccli := null;
    else
      ls_naccli := to_date(ps_fecnac, 'dd/mm/yyyy');
    end if;
    
    ls_nomsec := substr(ps_nomsec,1,60); --se corta variable a 60 caracteres maximo fpinto 12/08/2024
    
    select count(*)
      into ln_indest
      from acdeval
     where npaicli = pn_codpai
       and ntipdoc = pn_tipdoc
       and cnumdoc = ps_numdoc;
    if ln_indest = 0 then
      insert into acdeval
        (npaicli,
         ntipdoc,
         cnumdoc,
         cindcon,
         npaicon,
         ntipcon,
         cdoccon,
         ccodsbs,
         cconsbs,
         cclinom,
         cconnom,
         clisneg,
         cnegcon,
         cindsob,
         ccodsob,
         cindrec,
         ccodrec,
         nnument,
         nentcon,
         cindjud,
         cconjud,
         cindcas,
         cconcas,
         cdifnor,
         cconnor,
         cmaycpp,
         cconcpp,
         ccodcal,
         dfeceva,
         ccalcli,
         ccalcon,
         cescosb,
         cdecosb,
         csegcli,
         cdirfij,
         cdirneg,
         ctelfij,
         ctelneg,
         ctelmov,
         czonfij,
         czonneg,
         nagecli,
         ncodana,
         ccodest,
         ncoding,
         ncodact,
         ncodbas,
         ncodpri,
         creffij,
         crefneg,
         cusuing,
         ctipcli,
         ctipcny,
         nnumina,
         ninacon,
         csegcon,
         cactcli,
         cactcon,
         cestcre,
         ccrecon,
         cfecdes,
         cdescon,
         nidebas,
         nidepro,
         dfecnac,
         dnaccon,
         cnomsec,
         ncodage,
         nagepre,
         cotrana,
         nmoneva,
         cdestcre,
         ctiping,
         czonpro,
         cmailcl,
         ncorcli,
         nindcier)
      values
        (pn_codpai,
         pn_tipdoc,
         ps_numdoc,
         ls_indcon,
         ls_paicon,
         ls_tipcon,
         ls_doccon,
         ls_sbscli,
         ls_sbscon,
         ls_nomcli,
         ls_nomcon,
         ps_clineg,
         ls_conneg,
         ps_estsob,
         ls_dessob,
         ps_estrec,
         ps_desrec,
         ls_nument,
         ls_conent,
         ps_clijud,
         ls_conjud,
         ps_clicas,
         ls_concas,
         ps_clinor,
         ls_connor,
         ps_clicpp,
         ls_concpp,
         ps_calgen,
         sysdate,
         ps_calcli,
         ls_calcon,
         ls_escosb,
         ls_decosb,
         ls_segcli,
         ls_vivcli,
         ls_negcli,
         ps_telfij,
         ps_telneg,
         ps_telcel,
         ls_ubiviv,
         ls_ubineg,
         ls_codage,
         ls_codana,
         '1',
         3,
         ls_codact,
         ln_codbas,
         1,
         ls_refdom,
         ls_refneg,
         ls_usuing,
         trim(ps_tipcli),
         trim(ls_tipcny),
         ps_numina,
         ls_inacon,
         trim(ls_segcon),
         trim(ps_actcli),
         trim(ls_actcon),
         ps_estcre,
         ls_crecon,
         trim(ls_fecdes),
         ls_descon,
         3,
         3,
         ls_naccli,
         ls_naccon,
         trim(ls_nomsec), --se cambia variable fpinto 12/08/2024
         ln_ageing,
         ps_agepre,
         ps_otrana,
         ps_moneva,
         ps_descre,
         ps_tiping,
         upper(ps_zonpro),
         ps_mailcl,
         SEQ_CORCLI.NEXTVAL,
         '0');
      commit;
    else
      insert into acheval
        select *
          from acdeval
         where npaicli = pn_codpai
           and ntipdoc = pn_tipdoc
           and cnumdoc = ps_numdoc;
      commit;
    
      update acdeval
         set nidebas  = 3,
             nidepro  = 3,
             cindcon  = ls_indcon,
             npaicon  = ls_paicon,
             ntipcon  = ls_tipcon,
             cdoccon  = ls_doccon,
             ccodsbs  = ls_sbscli,
             cconsbs  = ls_sbscon,
             cclinom  = ls_nomcli,
             cconnom  = ls_nomcon,
             clisneg  = ps_clineg,
             cnegcon  = ls_conneg,
             cindsob  = ps_estsob,
             ccodsob  = ls_dessob,
             cindrec  = ps_estrec,
             ccodrec  = ps_desrec,
             nnument  = ls_nument,
             nentcon  = ls_conent,
             cindjud  = ps_clijud,
             cconjud  = ls_conjud,
             cindcas  = ps_clicas,
             cconcas  = ls_concas,
             cdifnor  = ps_clinor,
             cconnor  = ls_connor,
             cmaycpp  = ps_clicpp,
             cconcpp  = ls_concpp,
             ccodcal  = ps_calgen,
             dfeceva  = sysdate,
             ccalcli  = ps_calcli,
             ccalcon  = ls_calcon,
             cescosb  = ls_escosb,
             cdecosb  = ls_decosb,
             csegcli  = ls_segcli,
             cdirfij  = ls_vivcli,
             cdirneg  = ls_negcli,
             ctelfij  = ps_telfij,
             ctelneg  = ps_telneg,
             ctelmov  = ps_telcel,
             czonfij  = ls_ubiviv,
             czonneg  = ls_ubineg,
             nagecli  = ls_codage,
             ncodana  = ls_codana,
             ccodest  = '1',
             ncoding  = 3,
             ncodact  = ls_codact,
             ncodbas  = ln_codbas,
             ncodpri  = 1,
             creffij  = ls_refdom,
             crefneg  = ls_refneg,
             cusuing  = ls_usuing,
             ctipcli  = trim(ps_tipcli),
             ctipcny  = trim(ls_tipcny),
             nnumina  = ps_numina,
             ninacon  = ls_inacon,
             csegcon  = trim(ls_segcon),
             cactcli  = trim(ps_actcli),
             cactcon  = trim(ls_actcon),
             cestcre  = ps_estcre,
             ccrecon  = ls_crecon,
             cfecdes  = trim(ls_fecdes),
             cdescon  = ls_descon,
             dfecnac  = ls_naccli,
             dnaccon  = ls_naccon,
             cnomsec  = trim(ls_nomsec), --se cambia variable fpinto 12/08/2024
             ncodage  = ln_ageing,
             nagepre  = ps_agepre,
             cotrana  = ps_otrana,
             nmoneva  = ps_moneva,
             cdestcre = ps_descre,
             ctiping  = ps_tiping,
             czonpro  = upper(ps_zonpro),
             cmailcl  = ps_mailcl,
             ncorcli  = SEQ_CORCLI.NEXTVAL,
             nindcier = '0'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc;
      commit;
    end if;
  
    if ls_codact = '1' or ls_codact = '4' then
      update acheval
         set nindcier = '1', ccodest = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact in (1, 4);
    
      update acdasig
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact in (1, 4);
    
      update achasig
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact in (1, 4);
    
      insert into achrevi
        select ncorage,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               168,
               'Cerrado por: ' || ls_usuing,
               '1',
               ls_usuing,
               trunc(sysdate),
               to_char(sysdate, 'HH24:Mi'),
               0,
               0
          from achagen
         where npaicli = pn_codpai
           and ntipdoc = pn_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact in (1, 4)
           and cestado = 1;
    
      insert into achrevi
        select ncorage,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               168,
               'Cerrado por ingreso de referido de: ' || ls_usuing,
               '1',
               ls_usuing,
               trunc(sysdate),
               to_char(sysdate, 'HH24:Mi'),
               0,
               0
          from acdagen
         where npaicli = pn_codpai
           and ntipdoc = pn_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact in (1, 4)
           and cestado = 1;
    
      update acdagen
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact in (1, 4);
    
      update achagen
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact in (1, 4);
    
    else
    
      update acheval
         set nindcier = '1', ccodest = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ls_codact;
    
      update acdasig
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ls_codact;
    
      update achasig
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ls_codact;
    
      insert into achrevi
        select ncorage,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               168,
               'Cerrado por: ' || ls_usuing,
               '1',
               ls_usuing,
               trunc(sysdate),
               to_char(sysdate, 'HH24:Mi'),
               0,
               0
          from achagen
         where npaicli = pn_codpai
           and ntipdoc = pn_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact = ls_codact
           and cestado = 1;
    
      insert into achrevi
        select ncorage,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               168,
               'Cerrado por ingreso de referido de: ' || ls_usuing,
               '1',
               ls_usuing,
               trunc(sysdate),
               to_char(sysdate, 'HH24:Mi'),
               0,
               0
          from acdagen
         where npaicli = pn_codpai
           and ntipdoc = pn_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact = ls_codact
           and cestado = 1;
    
      update acdagen
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ls_codact;
    
      update achagen
         set cestado = '2'
       where npaicli = pn_codpai
         and ntipdoc = pn_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ls_codact;
    end if;
  
    commit;
    --if ps_otrana = 'N' then
    select cnomact into ls_nomact from actacti where ncodact = ls_codact;
    select cnomact
      into ls_nombas
      from actbase
     where ncodact = ls_codact
       and ncodbas = ln_codbas;
    sp_insasi('REFERIDO', ls_nomact, trim(ls_nombas), ps_numdoc, ls_usuing,
              ls_usuing);
    select cdesatr
      into ls_destip
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(ccodatr) = pn_tipdoc;
  
    sp_insage(pn_codpai, trim(ls_destip), ps_numdoc, ls_usuing,
              trim(ps_fecvis), trim(ps_horvis), 3, ls_codact, ln_codbas, '0',
              '0', ls_resagen);
    --end if;
  end sp_insref;

  procedure sp_insprg(pn_codpro in number,
                      pd_fecini in varchar2,
                      pd_fecfin in varchar2,
                      ps_codper in char,
                      ps_codusu in varchar)
  -- *****************************************************************
    -- Nombre                     : sp_insprg
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/10/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Insertar programación del proceso seleccionado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    declare
      ls_codcor int;
      ls_fecini date;
      ls_fecfin date;
      ls_numpro int;
    begin
      begin
        select to_date(pd_fecini, 'DD/MM/YYYY'),
               to_date(pd_fecfin, 'DD/MM/YYYY')
          into ls_fecini, ls_fecfin
          from dual;
        if ls_fecini > ls_fecfin then
          select cast(pd_fecini as date), cast(pd_fecfin as date)
            into ls_fecfin, ls_fecini
            from dual;
        end if;
        select count(*)
          into ls_numpro
          from acdproc
         where ncodpro = pn_codpro;
        if ls_numpro > 0 then
          update acdproc
             set cestado = '1',
                 dfecini = ls_fecini,
                 dfecfin = ls_fecfin,
                 cusumod = ps_codusu,
                 ccodper = ps_codper,
                 dfecmod = to_date(sysdate, 'DD/MM/YYYY')
           where ncodpro = pn_codpro;
        else
          select coalesce(max(nidepro), 0) + 1 into ls_codcor from acdproc;
          insert into acdproc
            (nidepro,
             ncodpro,
             cestado,
             dfecini,
             dfecfin,
             ccodper,
             cusucre,
             dfeccre,
             cusumod,
             dfecmod)
          values
            (ls_codcor,
             pn_codpro,
             '1',
             ls_fecini,
             ls_fecfin,
             ps_codper,
             ps_codusu,
             to_date(sysdate, 'DD/MM/YYYY'),
             ps_codusu,
             to_date(sysdate, 'DD/MM/YYYY'));
        end if;
      end;
    
    end;
  end sp_insprg;

  procedure sp_lissuc(ps_codsuc number, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lissuc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de agencias o sucursales
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_numreg number;
  begin
    select count(*)
      into ln_numreg
      from acmsucu
     where ccodest = '1'
       and ncodsuc = ps_codsuc;
  
    if ln_numreg > 0 then
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ccodest = '1'
           and ncodsuc = ps_codsuc
         order by 2;
    else
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ccodest = '1'
           and (ncodsuc < 800 or ncodsuc = 904)
         order by 2;
    end if;
  end sp_lissuc;

  procedure sp_lisage(ps_codana varchar2,ps_codact varchar2,
                      ps_codbas varchar2,ps_codubi varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de Clientes por asignar filtrado por los analistas
    -- Estado                     : Activo
    -- Fecha Modificación         : 08/01/2020
    -- Autor de Modificación      : WCRW
    -- Descripcion Modificacion   : Adición de datos
    -- Fecha Modificación         : 02/12/2024
    -- Autor de Modificación      : fpinto
    -- Descripcion Modificacion   : Adición de datos
    -- *****************************************************************  
   as
    ls_codact number;
    ls_codbas number;
    ls_codubi char(8);
    ls_codana varchar2(10);
    ls_anacod CHAR(10);
    ls_desres varchar2(200);
  begin
    ls_codana := upper(ps_codana);
    ls_anacod := upper(ps_codana);
    if ps_codubi = '0' then
      ls_codubi := null;
    else
      ls_codubi := ps_codubi;
    end if;
  
    if ps_codact = '0' then
      ls_codact := null;
    else
      ls_codact := to_number(ps_codact);
    end if;
  
    if ps_codbas = '0' then
      ls_codbas := null;
    else
      ls_codbas := to_number(ps_codbas);
    end if;
  
    if (ls_codact = 2 or ls_codact = 3) then
      open lc_liscur for
        select *
          from ((select distinct bas.nnumpas as npaicli,doc.cdesatr,bas.cnumdoc,
                        to_char(sysdate, 'DD/MM/YYYY') as dfecasi,nbas.cnomact,
                        doc.cdesatr || ' - ' || bas.cnumdoc as numdoc,bas.cnombre as cclinom,
                        coalesce(coalesce(bas.ctelfij, bas.ctelmov),'0') as ctelcli,
                        ubd.cdespro || '-' || ubd.cdesdis as cdirpro,bas.ncodact,
                        trim(bas.ncodana) || '-' || trim(sucu.cnomsuc) as cusuage,
                        '-' as cnomres
                   from acdbase bas
                  inner join acdatri doc
                     on doc.ncodtab = 6
                    and doc.ctipatr = 'D'
                    and doc.ccodatr = bas.ntipdoc
                    and doc.cestado = '1'
                   left join actugeo ubd
                     on ubd.cubigeo = coalesce(bas.czonfij, bas.czonneg)
                   left join actbase nbas
                     on bas.ncodbas = nbas.ncodbas
                    and bas.ncodact = nbas.ncodact
                   left join acdagus agus 
                     on trim(bas.ncodana) = trim(agus.ccodope)
                   left join acmsucu sucu 
                     on sucu.ncodsuc = agus.ncodsuc
                  where bas.cestado = '3'
                    and bas.cusuing = ls_codana
                    and bas.ncodact = ls_codact
                    and bas.ncodbas = ls_codbas) union
                (select asi.npaicli,doc.cdesatr,asi.cnumdoc,
                        to_char(asi.dfecmod,'dd/mm/yyyy') as dfecasi,nbas.cnomact,
                        doc.cdesatr || ' - ' || asi.cnumdoc as numdoc,eva.cclinom as cclinom,
                        coalesce(coalesce(eva.ctelfij,eva.ctelmov), '0') as ctelcli,
                        ubd.cdespro || ' - ' || ubd.cdesdis as cdirpro, bas.ncodact,
                        trim(asi.ccodusu) || '-' || trim(sucu.cnomsuc) as cusuage,
                        trim(tip.cdesatr) || '-' || trim(fn_datovisitares(age.ncorage)) as cnomres            
                        from acdasig asi
                  inner join actingr ing
                     on ing.ncoding = asi.ncoding
                  inner join actacti act
                     on act.ncodact = asi.ncodact
                  inner join((select cclinom,ctelfij,ctelmov,ncorcli,nindcier,
                                     czonneg,czonfij,ctipcli,ncodana
                               from acdeval
                              where nindcier = '0')
                  union (select cclinom,ctelfij,ctelmov,ncorcli,nindcier,
                                czonneg,czonfij,ctipcli,ncodana
                         from acheval
                        where nindcier = '0')) eva
                     on eva.ncorcli = asi.ncorcli
                  left join acdagus agus 
                     on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                     on sucu.ncodsuc = agus.ncodsuc   
                  left join acdagen age
                     on age.ncorasi = asi.ncorasi   
                  left join acdatri tip
                     on tip.ncodtab = 9
                    and tip.ctipatr = 'D'
                    and tip.ccodatr = eva.ctipcli
                    and tip.cestado = '1'   
                 inner join actbase bas
                     on bas.ncodbas = asi.ncodbas
                    and bas.ncodact = act.ncodact
                  inner join acdatri doc
                     on doc.ncodtab = 6
                    and doc.ctipatr = 'D'
                    and doc.ccodatr = asi.ntipdoc
                    and doc.cestado = '1'
                   left join actugeo ubd
                     on ubd.cubigeo = coalesce(eva.czonfij, eva.czonneg)
                   left join actbase nbas
                     on asi.ncodbas = nbas.ncodbas
                    and asi.ncodact = nbas.ncodact
                  where asi.ccodusu = ls_anacod
                    and asi.cestado = '1'
                    and asi.ncodbas = coalesce(ls_codbas, asi.ncodbas)
                    and asi.ncodact = coalesce(ls_codact, asi.ncodact)
                 ));
    else
      open lc_liscur for
      /* select asi.npaicli,doc.cdesatr,asi.cnumdoc,to_char(asi.dfecmod,'dd/mm/yyyy') as dfecasi,
                nbas.cnomact,doc.cdesatr || ' - ' ||asi.cnumdoc as numdoc,eva.cclinom as cclinom,
                coalesce(coalesce(eva.ctelfij,eva.ctelmov),'0') as ctelcli,ubd.cdespro || ' - ' || ubd.cdesdis as cdirpro,
                asi.ncodact
           from acdasig asi
         left join actingr ing
             on ing.ncoding= asi.ncoding
         inner join actacti act
             on act.ncodact= asi.ncodact
         inner join (select * from acdeval where nindcier = 0
                     union
                     select * from acheval where nindcier = 0)eva
                     on eva.npaicli = asi.npaicli
                     and eva.ntipdoc = asi.ntipdoc
                     and eva.cnumdoc = asi.cnumdoc 
                     inner join actbase bas
                     on bas.ncodbas= asi.ncodbas and bas.ncodact = act.ncodact
                     inner join acdatri doc
                     on doc.ncodtab = 6 and doc.ctipatr='D' and doc.ccodatr=asi.ntipdoc and doc.cestado='1'
                     left join actugeo ubd 
                     on ubd.cubigeo= coalesce(eva.czonfij,eva.czonneg)
                     left join actbase nbas
                     on asi.ncodbas = nbas.ncodbas and asi.ncodact = nbas.ncodact
                     where ccodusu=ls_anacod
                     and  asi.cestado='1'
                     and  asi.ncodbas = coalesce(ls_codbas,asi.ncodbas)
                     and  asi.ncodact = coalesce(ls_codact,asi.ncodact)
                     and  (coalesce(eva.czonneg,eva.czonfij) = coalesce(ls_codubi,coalesce(eva.czonneg,eva.czonfij))or coalesce(eva.czonneg,eva.czonfij) is null);*/
        select asi.npaicli,doc.cdesatr,asi.cnumdoc,
               to_char(asi.dfecmod, 'dd/mm/yyyy') as dfecasi,nbas.cnomact,
    			     doc.cdesatr || ' - ' || asi.cnumdoc as numdoc,eva.cclinom as cclinom,
 			         coalesce(coalesce(eva.ctelfij,eva.ctelmov), '0') as ctelcli,
               ubd.cdespro || ' - ' || ubd.cdesdis as cdirpro,asi.ncodact,
               trim(asi.ccodusu) || '-' || trim(sucu.cnomsuc) as cusuage,
               coalesce(trim(tip.cdesatr),'No hay registro') || '-' || coalesce(trim(fn_datovisitas(asi.cnumdoc)),'No hay registro') as cnomres,
               coalesce(trim(fn_obtanalista(asi.cnumdoc)),'No hay registro')  as cusuage
          from acdasig asi
          left join actingr ing
            on ing.ncoding = asi.ncoding
         inner join actacti act
            on act.ncodact = asi.ncodact
         inner join (select ncorcli,czonfij,czonneg,cclinom,ctelmov,
                            ctelfij,ctipcli,ncodana
                       from acdeval
                      where nindcier in (0,1)
                     union
                     select ncorcli,czonfij,czonneg,cclinom,ctelmov,
                            ctelfij,ctipcli,ncodana
                       from acheval
                      where nindcier in (0,1)) eva
            on asi.ncorcli = eva.ncorcli
         left join acdagus agus 
            on trim(asi.ccodusu) = trim(agus.ccodope)
         left join acmsucu sucu 
            on sucu.ncodsuc = agus.ncodsuc
         left join acdagen age
            on age.ncorasi = asi.ncorasi   
         left join acdatri tip
           on tip.ncodtab = 9
          and tip.ctipatr = 'D'
          and tip.ccodatr = eva.ctipcli
          and tip.cestado = '1'    
         inner join actbase bas
            on bas.ncodbas = asi.ncodbas
           and bas.ncodact = act.ncodact
         inner join acdatri doc
            on doc.ncodtab = 6
           and doc.ctipatr = 'D'
           and doc.ccodatr = asi.ntipdoc
           and doc.cestado = '1'
          left join actugeo ubd
            on ubd.cubigeo = coalesce(eva.czonfij, eva.czonneg)
          left join actbase nbas
            on asi.ncodbas = nbas.ncodbas
           and asi.ncodact = nbas.ncodact    
         where asi.ccodusu = ls_anacod
           and asi.cestado in ('1')
           and asi.ncodbas = coalesce(ls_codbas, asi.ncodbas)
           and asi.ncodact = coalesce(ls_codact, asi.ncodact)
           and (coalesce(eva.czonneg, eva.czonfij) =
               coalesce(ls_codubi, coalesce(eva.czonneg, eva.czonfij)) or
               coalesce(eva.czonneg, eva.czonfij) is null);
    end if;
  end sp_lisage;

  procedure sp_insage(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      ps_codana varchar2,
                      pd_fecage varchar2,
                      ps_horage varchar2,
                      ps_coding varchar2,
                      ps_codact varchar2,
                      ps_codbas varchar2,
                      ps_codlon varchar2,
                      ps_codlat varchar2,
                      ps_resins out varchar)
  -- *****************************************************************
    -- Nombre                     : sp_insage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Procedimiento para agendar al cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_tipdoc     varchar(3);
    ld_fecage     date;
    ls_strfec     varchar2(10);
    ls_strhor     varchar2(5);
    ls_indbloagen number;
    ls_indblotiem number;
    ls_indeval    number;
    ln_coding     number(2);
    ls_codact     number(2);
    ls_codbas     number(2);
    ls_codpai     number(3);
    ls_numdoc     varchar2(12);
    ls_paicon     number(3);
    ls_tipcon     number(2);
    ls_doccon     varchar2(12);
    ls_nomcli     varchar2(100);
    ls_zonfij     char(8);
    ls_dirfij     varchar2(300);
    ls_reffij     varchar2(300);
    ls_zonneg     char(8);
    ls_dirneg     varchar2(300);
    ls_refneg     varchar2(300);
    ls_telfij     varchar2(50);
    ls_telmov     varchar2(50);
    ls_codage     number(3);
    ls_codana     varchar2(10);
    ls_usuing     varchar2(10);
    ls_fecing     date;
    ls_codpri     char(1);
    ls_monsol     number(10, 2);
    ls_deting     varchar2(100);
    ls_detact     varchar2(100);
    ls_detbas     varchar2(100);
    ls_idebas     number(3);
    ls_idepro     number(3);
    ls_blogen     number(1);
    ls_counvis    number;
    ls_codusu     varchar2(12);
    ls_blotiem    number;
  
    pragma autonomous_transaction;
  begin
  
    ls_numdoc := trim(ps_numdoc);
    --SELECT INSTR(pd_fecage,'T', 1, 1) into ln_numpos FROM DUAL;
    SELECT SUBSTR(pd_fecage, 1, 10), SUBSTR(pd_fecage, 12, 5)
      into ls_strfec, ls_strhor
      FROM DUAL;
  
    ls_strhor := trim(ps_horage);
    select to_date(ls_strfec, 'YYYY-MM-DD') into ld_fecage from dual;
  
    select count(*)
      into ls_counvis
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and cdesatr = ps_codtip;
  
    if (ls_counvis > 0) then
      select ccodatr
        into ls_tipdoc
        from acdatri
       where cestado = '1'
         and ctipatr = 'D'
         and ncodtab = '6'
         and cdesatr = ps_codtip;
    else
    
      ls_tipdoc := trim(ps_codtip);
    end if;
  
    ls_tipdoc := trim(ls_tipdoc);
  
    -- Agregar a ACDASIG; y ACDEVAL
    if (ps_codact = 2 or ps_codact = 3) then
      ls_indbloagen := 0;
      ls_indblotiem := 0;
      select count(*)
        into ls_indbloagen
        from acdagen
       where npaicli = ps_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = trim(ls_numdoc)
         and ncodact = ps_codact
         and cestado = '1';
    
      select count(*)
        into ls_indblotiem
        from ((select ncorcli, ncodage, cusuing
                 from acdeval
                where trim(cnumdoc) = trim(ls_numdoc)
                  and ntipdoc = ls_tipdoc
                  and npaicli = ps_codpai) union
              (select ncorcli, ncodage, cusuing
                 from acheval
                where trim(cnumdoc) = trim(ls_numdoc)
                  and ntipdoc = ls_tipdoc
                  and npaicli = ps_codpai)) eva
        left join acdasig asi
          on eva.ncorcli = asi.ncorcli
        left join acmoper opereva
          on trim(opereva.ccodope) = trim(upper(eva.cusuing))
         and opereva.ccodest = '1'
        left join acmsucu suc
          on eva.ncodage = suc.ncodsuc
        left join acmoper operasig
          on trim(operasig.ccodope) = trim(upper(asi.cusuasi))
         and operasig.ccodest = '1'
        left join acdagen age
          on age.ncorasi = asi.ncorasi
        left join actbase atb
          on atb.ncodbas = asi.ncodbas
         and atb.ncodact = asi.ncodact
        left join acdrevi rev
          on rev.ncorage = age.ncorage
       where trim(asi.cnumdoc) = trim(ls_numdoc)
         and asi.ntipdoc = ls_tipdoc
         and asi.npaicli = ps_codpai
         and ((age.cestado <> '2' and
              trunc(sysdate) - age.dfecest < atb.ntieage) or
              (rev.cestado = '1' and rev.ncorage <> age.ncorage and
              trunc(sysdate) - rev.dfecvis < atb.ntievis))
         and age.ncodact = ps_codact;
    
      if (ls_indbloagen = 0 and ls_indblotiem = 0) then
        ls_indeval := 0;
        select count(*)
          into ls_indeval
          from acdeval eva
         where eva.cnumdoc = ls_numdoc
           and eva.ntipdoc = ls_tipdoc
           and eva.npaicli = ps_codpai;
        --and eva.ncodact = ps_codact;
      
        begin
          select *
            into ls_idebas,
                 ls_idepro,
                 ln_coding,
                 ls_codact,
                 ls_codbas,
                 ls_codpai,
                 ls_tipdoc,
                 ls_numdoc,
                 ls_paicon,
                 ls_tipcon,
                 ls_doccon,
                 ls_nomcli,
                 ls_zonfij,
                 ls_dirfij,
                 ls_reffij,
                 ls_zonneg,
                 ls_dirneg,
                 ls_refneg,
                 ls_telfij,
                 ls_telmov,
                 ls_codage,
                 ls_codana,
                 ls_usuing,
                 ls_fecing,
                 ls_codpri,
                 ls_monsol
            from (select distinct nidebas,
                                  nidepro,
                                  ncoding,
                                  ncodact,
                                  ncodbas,
                                  trim(nnumpas),
                                  trim(ntipdoc),
                                  trim(cnumdoc),
                                  case
                                    when npascon = 0 then
                                     null
                                    else
                                     npascon
                                  end as npascon,
                                  case
                                    when ntipcon = 0 then
                                     null
                                    else
                                     ntipcon
                                  end as ntipcon,
                                  cdoccon,
                                  cnombre,
                                  czonfij,
                                  cdirfij,
                                  creffij,
                                  czonneg,
                                  cdirneg,
                                  crefneg,
                                  ctelfij,
                                  ctelmov,
                                  ncodage,
                                  ncodana,
                                  cusuing,
                                  dfecing,
                                  ncodpri,
                                  nmonsol
                    from acdbase
                   where nnumpas = ps_codpai
                     and ntipdoc = ls_tipdoc
                     and trim(cnumdoc) = ls_numdoc
                     and ncodact = ps_codact
                   order by dfecing desc) a
           where rownum = 1;
        exception
          when no_data_found then
            ls_idebas := 0;
        end;
      
        update acdbase
           set cestado = '2'
         where nnumpas = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc;
      
        if (ls_indeval = 0) then
          begin
            insert into acdeval
              (ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               npaicon,
               ntipcon,
               cdoccon,
               cclinom,
               czonfij,
               cdirfij,
               creffij,
               czonneg,
               cdirneg,
               crefneg,
               ctelfij,
               ctelmov,
               ncodage,
               nagepre,
               ncodana,
               cusuing,
               dfeceva,
               ncodpri,
               nmoneva,
               ccodest,
               nidebas,
               nidepro,
               ncorcli,
               nindcier)
            values
              (ln_coding,
               ls_codact,
               ls_codbas,
               ls_codpai,
               ls_tipdoc,
               ls_numdoc,
               ls_paicon,
               ls_tipcon,
               ls_doccon,
               ls_nomcli,
               ls_zonfij,
               ls_dirfij,
               ls_reffij,
               ls_zonneg,
               ls_dirneg,
               ls_refneg,
               ls_telfij,
               ls_telmov,
               ls_codage,
               ls_codage,
               ls_codana,
               ls_usuing,
               ls_fecing,
               ls_codpri,
               ls_monsol,
               '1',
               ls_idebas,
               ls_idepro,
               SEQ_CORCLI.NEXTVAL,
               '0');
            commit;
          exception
            when no_data_found then
              ls_idebas := 0;
            when others then
              ls_idebas := 0;
          end;
        
        else
          insert into acheval
            select *
              from acdeval
             where npaicli = ps_codpai
               and ntipdoc = ls_tipdoc
               and trim(cnumdoc) = ls_numdoc;
          --and ncodact = ps_codact;
          commit;
        
          update acdeval
             set ncoding  = ln_coding,
                 ncodact  = ls_codact,
                 ncodbas  = ls_codbas,
                 czonfij  = ls_zonfij,
                 cdirfij  = ls_dirfij,
                 creffij  = ls_reffij,
                 czonneg  = czonneg,
                 cdirneg  = cdirneg,
                 crefneg  = crefneg,
                 ctelfij  = ls_telfij,
                 ctelmov  = ls_telmov,
                 ncodage  = ls_codage,
                 nagepre  = ls_codage,
                 ncodana  = ls_codana,
                 cusuing  = ls_usuing,
                 dfeceva  = sysdate,
                 ncodpri  = ls_codpri,
                 nmoneva  = ls_monsol,
                 ccodest  = '1',
                 nidebas  = ls_idebas,
                 nidepro  = ls_idepro,
                 ncorcli  = SEQ_CORCLI.NEXTVAL,
                 nindcier = '0'
           where npaicli = ps_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc;
          --and ncodact = ps_codact;
        end if;
        select cnombas
          into ls_deting
          from actingr
         where ncoding = ln_coding;
        select cnomact
          into ls_detact
          from actacti
         where ncodact = ls_codact;
        select cnomact
          into ls_detbas
          from actbase
         where ncodact = ls_codact
           and ncodbas = ls_codbas;
      
        sp_insasi(trim(ls_deting), trim(ls_detact), trim(ls_detbas),
                  ls_numdoc, ls_usuing, ls_usuing);
      
      end if;
    
    end if;
    --Terminar Edicion
    ls_blogen := 0;
    if (ls_indbloagen > 0 or ls_indblotiem > 0) then
      ls_blogen := 1;
    end if;
  
    select count(*)
      into ls_blotiem
      from acdasig
     where npaicli = ps_codpai
       and ntipdoc = ls_tipdoc
       and trim(cnumdoc) = trim(ls_numdoc)
       and ncodact = ps_codact
       and cestado = '1';
  
    if (ls_blogen = 0 and ls_blotiem > 0) then
    
      insert into achagen
        select *
          from acdagen
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
    
      commit;
    
      delete acdagen
       where npaicli = ps_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ps_codact;
      commit;
      insert into acdagen
        select supplier_seq.NEXTVAL,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               trunc(sysdate),
               dfecasi,
               ld_fecage,
               ls_strhor,
               upper(ps_codana),
               upper(ps_codana),
               sysdate,
               '0',
               ncorasi,
               ps_codlon,
               ps_codlat
          from acdasig
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
      commit;
    
      if trim(ps_codact) = '1' or trim(ps_codact) = '4' then
        update acdasig
           set cestado = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact in (1, 4);
        commit;
      else
        update acdasig
           set cestado = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
        commit;
      
      end if;
    
      if trim(ps_codact) = '1' or trim(ps_codact) = '4' then
        if trim(ps_codact) = '1' then
          update acdeval
             set ccodest = '2', nindcier = '1'
           where npaicli = ps_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = 4;
          update acheval
             set ccodest = '2', nindcier = '1'
           where npaicli = ps_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = 4;
        end if;
      
        if trim(ps_codact) = '4' then
          update acdeval
             set ccodest = '2', nindcier = '1'
           where npaicli = ps_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = 1;
          update acheval
             set ccodest = '2', nindcier = '1'
           where npaicli = ps_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = 1;
        end if;
      
        update acdeval
           set ccodest = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
        update acheval
           set ccodest = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
      
      else
        update acdeval
           set ccodest = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
        update acheval
           set ccodest = '2'
         where npaicli = ps_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ps_codact;
      end if;
      ps_resins := 'Se agendo al cliente';
      commit;
    else
      ps_resins := 'No se puede agendar cuenta con una  gestion';
    end if;
  end sp_insage;

  procedure sp_numage(ps_codana varchar2, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_numage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Número de Agendados por analista los siguientes 7 días contando desde hoy
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select to_char(dfecvis, 'mm-dd-yyyy') as dfecage, count(*) as inumage
        from acdagen
       where cestado = '1'
         and upper(trim(ccodusu)) = upper(ps_codana)
       group by to_char(dfecvis, 'mm-dd-yyyy')
       order by 1;
  exception
    when no_data_found then
      open lc_liscur for
        select to_char(sysdate, 'mm-dd-yyyy') as dfecage, 0 as inumage
          from dual;
    
  end sp_numage;

  procedure sp_liscln(ps_codana varchar2,
                      ps_fecini varchar2,
                      ps_fecfin varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_liscal
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista del calendario por analista
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ld_fecini date;
    ld_fecfin date;
  begin
    ld_fecini := to_date(ps_fecini, 'YYYY-MM-DD');
    ld_fecfin := to_date(ps_fecfin, 'YYYY-MM-DD');
    open lc_liscur for
      select age.dfecasi,
             age.npaicli,
             tip.cdesatr,
             age.cnumdoc,
             eva.cclinom,
             case
               when ctelneg is null then
                case
                  when ctelfij is null then
                   nvl(ctelmov, 'SIN TELÉFONO')
                  else
                   ctelfij
                end
               else
                ctelneg
             end as ctelcli,
             case
               when eva.cdirneg is null then
                eva.cdirfij
               else
                NVL(eva.cdirneg, 'SIN DIRECCIÓN')
             end as cdircli,
             case
               when eva.cdirneg is null then
                eva.creffij
               else
                nvl(eva.crefneg, 'SIN REFERENCIA')
             end as crefcli,
             case
               when eva.cdirneg is null then
                udir.cdesdep
               else
                uneg.cdesdep
             end as cdepcli,
             case
               when eva.cdirneg is null then
                udir.cdespro
               else
                uneg.cdespro
             end as cprocli,
             case
               when eva.cdirneg is null then
                udir.cdesdis
               else
                uneg.cdesdis
             end as cdiscli,
             to_char(age.dfecvis, 'YYYY/MM/DD') as dfecagn,
             age.cestado
        from acdagen age
       inner join acdeval eva
          on eva.npaicli = age.npaicli
         and eva.ntipdoc = age.ntipdoc
         and eva.cnumdoc = age.cnumdoc
       inner join acdatri tip
          on tip.ncodtab = 6
         and ctipatr = 'D'
         and tip.ccodatr = age.ntipdoc
         and tip.cestado = '1'
        left join actugeo udir
          on udir.cubigeo = eva.czonfij
        left join actugeo uneg
          on uneg.cubigeo = eva.czonneg
       where upper(trim(ccodusu)) = upper(ps_codana)
         and age.dfecvis between ld_fecini and ld_fecfin
       order by 1, 8;
  end sp_liscln;

  procedure sp_lisres(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      ps_nomrol varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisres
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de respuestas
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_codrol number;
    ln_codact number;
    ls_tipdoc varchar(3);
  begin
    select ncodrol
      into ln_codrol
      from acdrole
     where cdesrol = upper(trim(ps_nomrol));
  
    select ccodatr
      into ls_tipdoc
      from acdatri
     where cestado = '1'
       and ctipatr = 'D'
       and ncodtab = '6'
       and trim(cdesatr) = trim(ps_codtip);
  
    select ncodact
      into ln_codact
      from acdeval
     where cnumdoc = trim(ps_numdoc)
       and ntipdoc = ls_tipdoc
       and npaicli = ps_codpai;
    open lc_liscur for
      select res.ncodres, res.cnomres
        from ACDRESU res
       inner join actrore pue
          on pue.ncodres = res.ncodres
         and pue.ccodest = '1'
       inner join actacre act
          on act.ncodres = res.ncodres
         and act.ccodest = '1'
       where res.cestado = '1'
         and pue.ncodrol = ln_codrol
         and act.ncodact = ln_codact;
  end sp_lisres;

  procedure sp_vispre(pn_codres number, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_vispre
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de las preguntas por posible tipo de resultado de visita
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select pue.npreres, prg.cnompre
        from acdprre pue
       inner join acdpreg prg
          on prg.ncodpre = pue.ncodpre
       where pue.ncodres = pn_codres
         and pue.cestado = '1'
         and prg.cestado = '1';
  end sp_vispre;

  procedure sp_visres(pn_preres in number, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_visres
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de respuestas de acuerdo a determinada pregunta
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select pue.nrespue, res.cnomres, res.nrescod
        from acdrepu pue
       inner join acdresp res
          on res.nrescod = pue.nrescod
         and res.cestado = '1'
       where pue.npreres = pn_preres
         and pue.cestado = '1';
  end sp_visres;

  procedure sp_insvis(ps_corage varchar2,
                      ps_codusu varchar2,
                      ps_codres varchar2,
                      ps_desobs varchar2,
                      ps_codvis varchar2,
                      ps_horvis varchar2,
                      ps_codlat varchar2,
                      ps_codlon varchar2,
                      ps_codtip varchar2,
                      ps_coderr out varchar2,
                      ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_insvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Insertar resultado de visita
    -- Estado                     : Activo
    -- Fecha Modificación         : 10/02/2017
    -- Autor de Modificación      : BDEG
    -- Descripcion Modificacion   : Se agregó el campo de entrada ps_codtip
    -- *****************************************************************  
   as
    ls_tipdoc  number;
    ls_tipcas  number;
    ln_indbas  number;
    ln_indpro  number;
    ln_inding  number;
    ln_indact  number;
    ln_codbas  number;
    ln_corage  number;
    ld_fecage  date;
    ln_codpre  number;
    ln_codfec  number;
    ln_codobs  number;
    ls_codana  varchar2(15);
    ls_resagen varchar2(50);
    ls_deting  varchar2(100);
    ls_detact  varchar2(100);
    ls_detbas  varchar2(100);
    ls_counvis number;
    ls_numdoc  varchar2(12);
    ls_codpai  number;
    ls_codjef  varchar2(10);
    ls_corcli  number;
    ln_codrol  number;
    pragma autonomous_transaction;
  begin
  
    select ntipdoc, cnumdoc, npaicli
      into ls_tipdoc, ls_numdoc, ls_codpai
      from acdagen
     where ncorage = ps_corage;
  
    select ncorage,nidebas,nidepro,ncoding,ncodact,ncodbas
      into ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas
      from acdagen
     where ncorage = ps_corage;
    commit;
  
    insert into ACHREVI
      select *
        from acdrevi
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = trim(ls_numdoc)
         and ncodact = ln_indact
         and cestado = '1';
    commit;
    delete ACDREVI
     where npaicli = ls_codpai
       and ntipdoc = ls_tipdoc
       and trim(cnumdoc) = trim(ls_numdoc)
       and ncodact = ln_indact
       and cestado = '1';
    commit;
  
    select nindcas into ls_tipcas from acdresu where ncodres = ps_codres;
  
    if ls_tipcas = '2' then
    
      select npreres into ln_codpre from acdprre where ncodres = ps_codres;
      select nrespue
        into ln_codobs
        from acdrepu
       where npreres = ln_codpre
         and nrescod = 4; -- Observaciones
      select nrespue
        into ln_codfec
        from acdrepu
       where npreres = ln_codpre
         and nrescod = 6; -- Fecha
    
      insert into acdrevi
      values
        (ln_corage,
         ln_indbas,
         ln_indpro,
         ln_inding,
         ln_indact,
         ln_codbas,
         ls_codpai,
         ls_tipdoc,
         trim(ls_numdoc),
         ln_codfec,
         ps_codvis,
         '1',
         upper(ps_codusu),
         trunc(sysdate),
         to_char(sysdate, 'HH24:Mi'),
         ps_codlon,
         ps_codlat);
      commit;
      insert into acdrevi
      values
        (ln_corage,
         ln_indbas,
         ln_indpro,
         ln_inding,
         ln_indact,
         ln_codbas,
         ls_codpai,
         ls_tipdoc,
         trim(ls_numdoc),
         ln_codobs,
         ps_desobs,
         '1',
         upper(ps_codusu),
         trunc(sysdate),
         to_char(sysdate, 'HH24:Mi'),
         ps_codlon,
         ps_codlat);
      commit;
      select to_date(ps_codvis, 'YYYY-MM-DD') into ld_fecage from dual;
    
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli
                from acdasig
              union
              select ncorcli
                from achasig
               where ncorasi in (select ncorasi
                                   from acdagen
                                  where ncorage = ln_corage
                                 union
                                 select ncorasi
                                   from acdagen
                                  where ncorage = ln_corage)) a;
    
      update acdeval
         set ccodest = '2', nindcier = '0'
       where cnumdoc = trim(ls_numdoc)
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and ncodact = ln_indact
         and ncorcli = ls_corcli;
      update acheval
         set ccodest = '2', nindcier = '0'
       where cnumdoc = trim(ls_numdoc)
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and ncodact = ln_indact
         and ncorcli = ls_corcli;
    
    end if;
  
    if ls_tipcas = '1' then
      select npreres into ln_codpre from acdprre where ncodres = ps_codres;
      select nrespue
        into ln_codobs
        from acdrepu
       where npreres = ln_codpre
         and nrescod = 4; -- Observaciones
    
      insert into acdrevi
      values
        (ln_corage,
         ln_indbas,
         ln_indpro,
         ln_inding,
         ln_indact,
         ln_codbas,
         ls_codpai,
         ls_tipdoc,
         trim(ls_numdoc),
         ln_codobs,
         ps_desobs,
         '1',
         upper(ps_codusu),
         trunc(sysdate),
         to_char(sysdate, 'HH24:Mi'),
         ps_codlon,
         ps_codlat);
      commit;
    
      update acdeval
         set nindcier = '1'
       where nidebas = ln_indbas
         and nidepro = ln_indpro
         and ncoding = ln_inding
         and ncodact = ln_indact
         and ncodbas = ln_codbas
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and cnumdoc = trim(ls_numdoc);
    
      update acheval
         set nindcier = '1'
       where nidebas = ln_indbas
         and nidepro = ln_indpro
         and ncoding = ln_inding
         and ncodact = ln_indact
         and ncodbas = ln_codbas
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and cnumdoc = trim(ls_numdoc);
      commit;
    
      update acdeval
         set nindcier = 1, ccodest = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
    
      update acheval
         set nindcier = 1, ccodest = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
    
      update acdasig
         set cestado = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
    
      update achasig
         set cestado = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
    
      update acdagen
         set cestado = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
    
      update achagen
         set cestado = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_codbas;
      commit;
    
    end if;
  
    /*if ls_tipcas ='4' then
      insert into acdrevi values (ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas,ls_codpai,ls_tipdoc,
         trim(ls_numdoc),8,ps_desobs,'1',upper(ps_codusu),trunc(sysdate),to_char(sysdate,'HH24:mm'),ps_codlon,ps_codlat);    
         commit;
      insert into acdrevi values (ln_corage,ln_indbas,ln_indpro,ln_inding,ln_indact,ln_codbas,ps_codpai,ls_tipdoc,
         trim(ps_numdoc),9,ps_otrres,'1',upper(ps_codusu),trunc(sysdate),to_char(sysdate,'HH24:mm'),ps_codlon,ps_codlat);  
         commit;
    end if;*/
  
    if ls_tipcas = '5' then
      select npreres into ln_codpre from acdprre where ncodres = ps_codres;
      select nrespue
        into ln_codobs
        from acdrepu
       where npreres = ln_codpre
         and nrescod = 4; -- Observaciones
      insert into acdrevi
      values
        (ln_corage,
         ln_indbas,
         ln_indpro,
         ln_inding,
         ln_indact,
         ln_codbas,
         ls_codpai,
         ls_tipdoc,
         trim(ls_numdoc),
         ln_codobs,
         ps_desobs,
         '1',
         upper(ps_codusu),
         trunc(sysdate),
         to_char(sysdate, 'HH24:Mi'),
         ps_codlon,
         ps_codlat);
      commit;
    
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli
                from acdasig
              union
              select ncorcli
                from achasig
               where ncorasi in (select ncorasi
                                   from acdagen
                                  where ncorage = ln_corage
                                 union
                                 select ncorasi
                                   from acdagen
                                  where ncorage = ln_corage)) a;
    
      update acdeval
         set ccodest = '2', nindcier = '0'
       where cnumdoc = trim(ls_numdoc)
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and ncodact = ln_indact
         and ncorcli = ls_corcli;
      update acheval
         set ccodest = '2', nindcier = '0'
       where cnumdoc = trim(ls_numdoc)
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and ncodact = ln_indact
         and ncorcli = ls_corcli;
      commit;
    
      select coalesce(to_number(trim(ccodcar),'999'),0) 
        into ln_codrol
        from acmoper where ccodope = trim(upper(ps_codusu));
      if ln_codrol = 8 then  
         ls_codjef := trim(upper(ps_codusu));
      else   
         select coalesce(ccodjef, ps_codusu)
           into ls_codjef
           from acmoper
          where ccodope = trim(upper(ps_codusu))
            and ccodest = '1';
      end if;
      insert into achasig
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               cestado,
               sysdate,
               dfecasi,
               ccodusu,
               cusuasi,
               chorasi,
               cusumod,
               dfecmod,
               nindasi,
               ncorcli,
               ncorasi
          from acdasig
         where cnumdoc = trim(ls_numdoc)
           and npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and ncodact = ln_indact;
    
      commit;
    
      delete acdasig
       where cnumdoc = trim(ls_numdoc)
         and npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and ncodact = ln_indact;
    
      insert into acdasig
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               ncodest,
               dfechai,
               ccodjef,
               ccodusu,
               dhorasi,
               ccodasi,
               dfecha,
               iestado,
               ncorcli,
               SEQ_CORASI.NEXTVAL
          from (select nidebas,
                       nidepro,
                       ncoding,
                       ncodact,
                       ncodbas,
                       npaicli,
                       ntipdoc,
                       cnumdoc,
                       '1' as ncodest,
                       to_char(sysdate, 'yyyy/mm/dd') as dfechai,
                       upper(trim(ls_codjef)) as ccodjef,
                       trim(upper(ps_codusu)) as ccodusu,
                       to_char(sysdate, 'hh24:mi:ss') as dhorasi,
                       trim(upper(ps_codusu)) as ccodasi,
                       sysdate as dfecha,
                       0 as iestado,
                       ncorcli
                  from achasig
                 where cnumdoc = trim(ls_numdoc)
                   and npaicli = ls_codpai
                   and ntipdoc = ls_tipdoc
                   and ncodact = ln_indact
                 order by dfecmod desc) a
         where ROWNUM = 1;
    
    end if;
  
    if ls_tipcas = '6' then
      select npreres into ln_codpre from acdprre where ncodres = ps_codres;
      select nrespue
        into ln_codobs
        from acdrepu
       where npreres = ln_codpre
         and nrescod = 4; -- Observaciones
    
      insert into acdrevi
      values
        (ln_corage,
         ln_indbas,
         ln_indpro,
         ln_inding,
         ln_indact,
         ln_codbas,
         ls_codpai,
         ls_tipdoc,
         trim(ls_numdoc),
         ln_codobs,
         ps_desobs,
         '1',
         upper(ps_codusu),
         trunc(sysdate),
         to_char(sysdate, 'HH24:Mi'),
         ps_codlon,
         ps_codlat);
      commit;
      update acdagen set cestado = '3' where ncorage = ps_corage;
      commit;
    end if;
    if ls_tipcas <> 2 then
      update acdagen set cestado = '2' where ncorage = ps_corage;
      commit;
    else
      update acdagen
         set dfecmod = sysdate,
             cusumod = upper(trim(ps_codusu)),
             cestado = '2'
       where ncorage = ps_corage;
      commit;
    
      insert into achagen
        select * from acdagen where ncorage = ps_corage;
    
      commit;
    
      delete acdagen where ncorage = ps_corage;
      commit;
      insert into acdagen
        select supplier_seq.NEXTVAL,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               trunc(sysdate),
               dfecasi,
               ld_fecage,
               ps_horvis,
               trim(upper(ps_codusu)),
               trim(upper(ps_codusu)),
               sysdate,
               '0',
               ncorasi,
               ps_codlon,
               ps_codlat
          from acdasig
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ln_indact;
      commit;
    
      update acdasig
         set cestado = '2'
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ln_indact;
      commit;
    
    end if;
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_insvis;

  procedure sp_resvis(ps_corage varchar2, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_resvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Resultado de la visita de un cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  
  begin
  
    open lc_liscur for
      select rep.nrescod,
             res.cnomres,
             rev.cobserv,
             resu.nindcas,
             resu.cnomres as respuesta
        from (select ncorage, cobserv, nrespue
                from acdrevi
              union
              select ncorage, cobserv, nrespue
                from achrevi) rev
       inner join acdrepu rep
          on rep.nrespue = rev.nrespue
         and rep.cestado = '1'
       inner join acdresp res
          on res.nrescod = rep.nrescod
         and res.cestado = '1'
       inner join acdprre pre
          on pre.npreres = rep.npreres
         and pre.cestado = '1'
       inner join acdresu resu
          on resu.ncodres = pre.ncodres
         and resu.cestado = '1'
       where rev.ncorage = ps_corage
         and rep.nrescod = 4;
  end sp_resvis;

  procedure sp_detvis(ps_codpai varchar2,
                      ps_tipdoc varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_detvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Detalle de la visita al cliente en cuestionario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_tipdoc varchar(3);
  begin
  
    select ccodatr
      into ls_tipdoc
      from acdatri
     where cestado = '1'
       and ctipatr = 'D'
       and ncodtab = '6'
       and cdesatr = ps_tipdoc;
  
    open lc_liscur for
      select prg.cnompre,
             resp.cnomres,
             case
               when (select count(*)
                       from acdrepu
                      where nrescod = 4
                        and cestado = '1'
                        and npreres = prr.ncodres) > 0 then
                1
               else
                0
             end nindobs,
             res.cobserv
        from acdrevi res
       inner join acdrepu prp
          on prp.nrespue = res.nrespue
         and prp.cestado = '1'
       inner join acdprre prr
          on prr.npreres = prp.npreres
         and prr.cestado = '1'
       inner join acdresu resu
          on resu.ncodres = prr.ncodres
         and resu.cestado = '1'
       inner join acdpreg prg
          on prg.ncodpre = prr.ncodpre
       inner join acdresp resp
          on resp.nrescod = prp.nrescod
       where npaicli = ps_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = trim(ps_numdoc);
  end sp_detvis;

  procedure sp_detubi(ps_codubi varchar2, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_detubi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Detalle de ubigeo en departamento, provincia, distrito
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select cdesdep, cdespro, cdesdis
        from actugeo
       where cast(trim(cubigeo) as int) = cast(trim(ps_codubi) as int);
  end sp_detubi;

  procedure sp_lisusu(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de usuarios
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select usu.ccodusu, rol.cdesrol, est.cdesatr
        from acdusua usu
       inner join acdrole rol
          on rol.ncodrol = usu.ncodrol
         and rol.ccodest = '1'
       inner join acdatri est
          on est.ncodtab = 1
         and est.ctipatr = 'D'
         and est.ccodatr = usu.ccodest
       where usu.ccodest = 1;
  end sp_lisusu;

  procedure sp_estusu(ps_nomusu varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_estusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Cambia el estado al usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estusu char(1);
  begin
    select ccodest
      into ls_estusu
      from acdusua
     where ccodusu = ps_nomusu
       and ccodest = 1;
    if (ls_estusu = '1') then
      update acdusua
         set ccodest = '2'
       where ccodusu = ps_nomusu
         and ccodest = 1;
    
    else
      update acdusua set ccodest = '1' where ccodusu = ps_nomusu;
    end if;
    commit;
  
  end sp_estusu;

  procedure sp_prgpro(lc_liscur out types.cursor_type) is
    -- *****************************************************************
    -- Nombre                     : sp_prgpro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Programación de los procedimientos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select prg.nidepro as codigo,
             pro.cnompro as proceso,
             est.cdesatr as estado,
             cast(prg.dfecini as date) aS fechai,
             cast(prg.dfecfin as date) aS fechaf,
             peri.cdesatr as periodo
        from acdproc prg
       inner join acmproc pro
          on prg.ncodpro = pro.ncodpro
         and pro.cestado = '1'
       inner join acdatri est
          on est.ncodtab = 1
         and est.ccodatr = prg.cestado
         and est.cestado = '1'
       inner join acdatri peri
          on peri.ncodtab = 2
         and peri.ccodatr = prg.ccodper
         and peri.cestado = '1'
       order by prg.dfecmod desc;
  end sp_prgpro;

  procedure sp_lisper(lc_liscur out types.cursor_type) is
    -- *****************************************************************
    -- Nombre                     : sp_lisper
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de periocidad
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 2
         and ctipatr = 'D'
         and cestado = 1;
  end sp_lisper;

  procedure sp_lisrol(lc_liscur out types.cursor_type) is
    -- *****************************************************************
    -- Nombre                     : sp_lisrol
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de roles
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ncodrol, cdesrol from acdrole where ccodest = '1' order by 2;
  end sp_lisrol;

  procedure sp_lispai(lc_liscur out types.cursor_type) is
    -- *****************************************************************
    -- Nombre                     : sp_lispai
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de paises dándole prioridad a Perú
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ncodpai as pais,
             nnompai as panom,
             case
               when ncodpai = 604 then
                1
               else
                2
             end as prioridad
        from actpais
       order by 3, 2;
  end sp_lispai;

  procedure sp_lisdoc(pc_lisdoc out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisdoc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de tipos de documentos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
  
    open pc_lisdoc for
      select ccodatr, cdesatr
        from acdatri
       where ctipatr = 'D'
         and cestado = '1'
         and ncodtab = 6
       order by dfeccre;
  end sp_lisdoc;

  procedure sp_valusu(ps_codusu varchar2, pc_lisdoc out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_valusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Valida si el usuario se encuentra registrado en AC
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
  
    open pc_lisdoc for
      select count(*)
        from acdusua
       where upper(ccodusu) = upper(ps_codusu)
         and ccodest = '1';
  
  end sp_valusu;

  procedure sp_repXas(ps_codsuc varchar2, pc_lisdoc out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_repXas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Reporte de usuarios que faltan asigar de su agencia
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_codsuc number;
  begin
    ls_codsuc := to_number(ps_codsuc);
    open pc_lisdoc for
      select tip.cdesatr,
             eva.cnumdoc,
             eva.cclinom,
             ubi.cdesdep,
             ubi.cdespro,
             ubi.cdesdis,
             eva.cdirfij,
             eva.ctelfij,
             cal.cdesatr
        from (select ntipdoc,
                     czonfij,
                     cnumdoc,
                     cclinom,
                     cdirfij,
                     ctelfij,
                     ccodest,
                     ncodage,
                     ccodcal
                from acdeval
               where ccodest = '1'
                 and ncodage = ls_codsuc
              union all
              select ntipdoc,
                     czonfij,
                     cnumdoc,
                     cclinom,
                     cdirfij,
                     ctelfij,
                     ccodest,
                     ncodage,
                     ccodcal
                from acheval
               where ccodest = '1'
                 and ncodage = ls_codsuc) eva
       inner join acdatri tip
          on eva.ntipdoc = tip.ccodatr
         and tip.ctipatr = 'D'
         and tip.ncodtab = 6
         and tip.cestado = '1'
       inner join acdatri cal
          on eva.ccodcal = cal.ccodatr
         and cal.ctipatr = 'D'
         and cal.ncodtab = 5
         and cal.cestado = '1'
        left join actugeo ubi
          on ubi.cubigeo = eva.czonfij
       where eva.ccodest = '1'
         and eva.ncodage = ls_codsuc; --Se comentó para prueba
  end sp_repXas;

  procedure sp_lispei(lc_liscur OUT types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lispei
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista la periocidad
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 2
         and ctipatr = 'D'
         and Cestado = 1;
  end sp_lispei;

  procedure sp_lispro(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lispro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista la procesos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ncodpro, cnompro from acmproc where cestado = '1';
    ---  order by 2;
  end sp_lispro;

  procedure sp_bloref(pn_codpai varchar2,
                      pn_tipdoc varchar2,
                      ps_numdoc varchar2,
                      ps_codact varchar2,
                      lc_liscur out types.cursor_type)
  
   is
    -- *****************************************************************
    -- Nombre                     : sp_bloref
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Bloqueo de referidos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ln_numreg    number(20);
    ln_corcli    number(20);
    ln_corasi    number(20);
    ln_corage    number(20);
    ls_numdoc    varchar2(12);
    ld_feceva    date;
    ls_nomcli    varchar2(100);
    ls_nomope    varchar2(30);
    ls_nomsuc    char(30);
    ls_desrol    varchar2(40);
    ls_usuact    varchar2(30);
    ls_sucact    char(30);
    ls_desact    varchar2(40);
    ls_nomact    varchar2(100);
    ls_basnom    varchar2(100);
    ln_contar    number(5);
    ln_conage    number(5);
    ln_corclicam number;
    ln_concam    number;
  begin
    ln_corcli := 0;
    if ps_codact = '0' then
      ls_numdoc := trim(ps_numdoc);
      begin
        select max(ncorcli)
          into ln_corclicam
          from (select ncorcli
                  from acdeval
                 where npaicli = pn_codpai
                   and ntipdoc = pn_tipdoc
                   and cnumdoc = ls_numdoc
                   and ncodact = 7
                   and nindcier = '0'
                union
                select ncorcli
                  from acheval
                 where npaicli = pn_codpai
                   and ntipdoc = pn_tipdoc
                   and cnumdoc = ls_numdoc
                   and ncodact = 7
                   and nindcier = '0') a;
      exception
        when no_data_found then
          ln_corclicam := 0;
        when others then
          ln_corclicam := 0;
      end;
      if ln_corclicam > 0 then
        begin
          select max(ncorcli)
            into ln_corcli
            from (select ncorcli
                    from acdeval
                   where ncorcli = ln_corclicam
                     and nindcier = 0
                  union
                  select ncorcli
                    from acheval
                   where ncorcli = ln_corclicam
                     and nindcier = 0);
          if (ln_corcli is null) then
            ln_concam := 0;
          else
            ln_concam := 1;
          end if;
        exception
          when no_data_found then
            ln_corcli := 0;
            ln_concam := 0;
          when others then
            ln_corcli := 0;
            ln_concam := 0;
        end;
      else
        begin
          /*    select max (ncorcli)
          into ln_corcli
          from(
            select ncorcli from acdeval where cnumdoc = ls_numdoc and ntipdoc = pn_tipdoc and npaicli = pn_codpai and nindcier = '0' and ncodact in (1,4)
            union 
            select ncorcli from acheval where cnumdoc = ls_numdoc and ntipdoc = pn_tipdoc and npaicli = pn_codpai and nindcier = '0' and ncodact in (1,4)
          );*/
          select max(eva.ncorcli) as ncorcli
            into ln_corcli
            from (select ncorcli
                    from acdeval
                   where cnumdoc = ls_numdoc
                     and ntipdoc = pn_tipdoc
                     and npaicli = pn_codpai
                     and nindcier = '0'
                     and ncodact in (1, 4)
                  union
                  select ncorcli
                    from acheval
                   where cnumdoc = ls_numdoc
                     and ntipdoc = pn_tipdoc
                     and npaicli = pn_codpai
                     and nindcier = '0'
                     and ncodact in (1, 4)) eva
           inner join (select ncorcli, ncorasi
                         from acdasig
                        where cnumdoc = ls_numdoc
                          and ntipdoc = pn_tipdoc
                          and npaicli = pn_codpai
                          and ncodact in (1, 4)
                       union
                       select ncorcli, ncorasi
                         from achasig
                        where cnumdoc = ls_numdoc
                          and ntipdoc = pn_tipdoc
                          and npaicli = pn_codpai
                          and ncodact in (1, 4)) asi
              on asi.ncorcli = eva.ncorcli
           inner join (select ncorasi, ncorage
                         from acdagen
                        where cnumdoc = ls_numdoc
                          and ntipdoc = pn_tipdoc
                          and npaicli = pn_codpai
                          and ncodact in (1, 4)
                       union
                       select ncorasi, ncorage
                         from achagen
                        where cnumdoc = ls_numdoc
                          and ntipdoc = pn_tipdoc
                          and npaicli = pn_codpai
                          and ncodact in (1, 4)) age
              on age.ncorasi = asi.ncorasi;
        
        exception
          when no_data_found then
            ln_corcli := 0;
          when others then
            ln_corcli := 0;
        end;
      end if;
    
      begin
        select max(ncorasi)
          into ln_corasi
          from acdasig
         where ncorcli = ln_corcli;
      
      exception
        when no_data_found then
          ln_corasi := 0;
        when others then
          ln_corasi := 0;
      end;
      begin
        select max(ncorage)
          into ln_corage
          from (select ncorasi, ncorage
                  from acdagen
                 where cestado = 2
                union
                select ncorasi, ncorage
                  from achagen
                 where cestado = 2)
         where ncorasi in (select ncorasi
                             from acdasig
                            where ncorcli = ln_corcli
                           union
                           select ncorasi
                             from achasig
                            where ncorcli = ln_corcli);
      exception
        when no_data_found then
          ln_corage := 0;
        when others then
          ln_corage := 0;
      end;
    
      select count(*)
        into ln_contar
        from acdasig
       where ncorcli = ln_corcli
         and ncoding = 1;
    
      select count(ncorage)
        into ln_conage
        from (select ncorasi, ncorage
                from acdagen
              union
              select ncorasi, ncorage
                from achagen)
       where ncorasi in (select ncorasi
                           from acdasig
                          where ncorcli = ln_corcli
                         union
                         select ncorasi
                           from achasig
                          where ncorcli = ln_corcli);
    
      if (ln_corcli > 0 and ln_contar = 0) or
         (ln_contar > 0 and ln_conage > 0) or
         (ln_corclicam > 0 and ln_concam > 0) then
        -- Nomcliente y Fecha 
        begin
          select trunc(dfeceva), cclinom, act.cnomact, bas.cnomact
            into ld_feceva, ls_nomcli, ls_nomact, ls_basnom
            from (select dfeceva, cclinom, ncodact, ncodbas
                    from acdeval
                   where ncorcli = ln_corcli
                  union
                  select dfeceva, cclinom, ncodact, ncodbas
                    from acheval
                   where ncorcli = ln_corcli) eva
           inner join actacti act
              on act.ncodact = eva.ncodact
           inner join actbase bas
              on bas.ncodbas = eva.ncodbas
             and bas.ncodact = eva.ncodact
           where rownum = 1;
        exception
          when no_data_found then
            ld_feceva := ' ';
            ls_nomcli := ' ';
            ls_nomact := ' ';
            ls_basnom := ' ';
          when others then
            ld_feceva := ' ';
            ls_nomcli := ' ';
            ls_nomact := ' ';
            ls_basnom := ' ';
        end;
      
        -- Nombre usuario Ingresado
        begin
          select ope.cnomope, suc.cnomsuc, rol.cdesrol
            into ls_nomope, ls_nomsuc, ls_desrol
            from (select cusuing
                    from acdeval
                   where ncorcli = ln_corcli
                  union
                  select cusuing
                    from acheval
                   where ncorcli = ln_corcli) eva
           inner join acmoper ope
              on ope.ccodope = eva.cusuing
           inner join acdagus pue
              on pue.ccodope = eva.cusuing
           inner join acmsucu suc
              on suc.ncodsuc = pue.ncodsuc
           inner join acdrole rol
              on rol.ncodrol = ope.ccodcar
           where rownum = 1;
        exception
          when no_data_found then
            ls_nomope := ' ';
            ls_nomsuc := ' ';
            ls_desrol := ' ';
          when others then
            ls_nomope := ' ';
            ls_nomsuc := ' ';
            ls_desrol := ' ';
        end;
        -- Usuario Actual
        begin
          select ope.cnomope, suc.cnomsuc, rol.cdesrol
            into ls_usuact, ls_sucact, ls_desact
            from acdasig asi
           inner join acmoper ope
              on cast(ope.ccodope as char(10)) = asi.ccodusu
           inner join acdagus pue
              on cast(pue.ccodope as char(10)) = asi.ccodusu
           inner join acmsucu suc
              on suc.ncodsuc = pue.ncodsuc
           inner join acdrole rol
              on rol.ncodrol = ope.ccodcar
           where asi.ncorasi = ln_corasi
             and rownum = 1;
        exception
          when no_data_found then
            ls_usuact := ' ';
            ls_sucact := ' ';
            ls_desact := ' ';
          when others then
            ls_usuact := ' ';
            ls_sucact := ' ';
            ls_desact := ' ';
        end;
        -----------------------
      
        open lc_liscur for
          select coalesce(ls_nomcli, ' ') as nomcli,
                 coalesce(ls_numdoc, ' ') as numdoc,
                 coalesce(ls_nomope, ' ') as usucap,
                 coalesce(ls_nomsuc, ' ') as agecap,
                 coalesce(ls_desrol, ' ') as rolcap,
                 coalesce(ls_usuact, ' ') as usuact,
                 coalesce(ls_sucact, ' ') as ageasi,
                 coalesce(ls_desact, ' ') as rolact,
                 coalesce(fn_datovisitares(ln_corage), ' ') as resvis,
                 to_char(trunc(coalesce(fn_datovisitafec(ln_corage),
                                        ld_feceva)), 'dd/mm/yyyy') as fecvis,
                 ls_nomact || ' - ' || ls_basnom as actividad
            from dual;
      else
        open lc_liscur for
          select ' ' as nomcli,
                 ' ' as numdoc,
                 ' ' as usucap,
                 ' ' as agecap,
                 ' ' as rolcap,
                 '0' as usuact,
                 ' ' as ageasi,
                 ' ' as rolact,
                 ' ' as resvis,
                 ' ' as fecvis,
                 ' ' as actividad
            from dual;
      
      end if;
    
    else
    
      select count(*)
        into ln_numreg
        from (select *
                from acdeval
               where nindcier = '0'
                 and ncodact in (5)
              union
              select *
                from acheval
               where nindcier = '0'
                 and ncodact in (5)) eva
        left join acdasig asi
          on eva.cnumdoc = asi.cnumdoc
         and eva.ntipdoc = asi.ntipdoc
         and eva.npaicli = asi.npaicli
         and eva.ncoding = asi.ncoding
         and eva.ncodact = asi.ncodact
        left join acdagen age
          on eva.cnumdoc = age.cnumdoc
         and eva.ntipdoc = age.ntipdoc
         and eva.npaicli = age.npaicli
         and eva.ncoding = age.ncoding
         and eva.ncodact = age.ncodact
      
        left join acmoper opereva
          on trim(opereva.ccodope) = trim(upper(eva.cusuing))
         and opereva.ccodest = '1'
        left join acmoper descap
          on descap.ccodope = opereva.ccodope
        left join acdrole descap1
          on descap1.ncodrol = descap.ccodcar
        left join acdagus actsuc
          on actsuc.ccodope = trim(upper(eva.cusuing))
        left join acmsucu suc
          on actsuc.ncodsuc = suc.ncodsuc
        left join acmoper operasig
          on trim(operasig.ccodope) = trim(upper(asi.ccodusu))
         and operasig.ccodest = '1'
        left join acmoper desact
          on desact.ccodope = operasig.ccodope
         and desact.ccodest = '1'
        left join acdrole desact1
          on desact1.ncodrol = desact.ccodcar
        left join acdagus actsuc1
          on actsuc1.ccodope = trim(upper(asi.ccodusu))
        left join acmsucu suc1
          on actsuc1.ncodsuc = suc1.ncodsuc
      
        left join actbase atb
          on atb.ncodbas = eva.ncodbas
         and atb.ncodact = eva.ncodact
        left join acdrevi rev
          on rev.npaicli = eva.npaicli
         and rev.ntipdoc = eva.ntipdoc
         and rev.cnumdoc = eva.cnumdoc
         and rev.ncodact = eva.ncodact
        left join actbase basd
          on basd.ncodbas = eva.ncodbas
         and basd.ncodact = eva.ncodact
        left join actacti actd
          on actd.ncodact = eva.ncodact
       where eva.cnumdoc = ps_numdoc
         and eva.ntipdoc = pn_tipdoc
         and eva.npaicli = pn_codpai
         and eva.nindcier = '0'
         and eva.ncodact in (5)
            /*and opereva.ccodest = '1' */
         and operasig.ccodest = '1';
    
      if ln_numreg > 0 then
        open lc_liscur for
          select *
            from (select coalesce(eva.cclinom, ' ') as nomcli,
                         coalesce(eva.cnumdoc, ' ') as numdoc,
                         coalesce(opereva.cnomope, ' ') as usucap,
                         coalesce(suc.cnomsuc, ' ') as agecap,
                         coalesce(descap1.cdesrol, ' ') as rolcap,
                         coalesce(operasig.cnomope, ' ') as usuact,
                         coalesce(suc1.cnomsuc, ' ') as ageasi,
                         coalesce(desact1.cdesrol, ' ') as rolact,
                         coalesce(fn_datovisitares(rev.ncorage), ' ') as resvis,
                         to_char(trunc(coalesce(fn_datovisitafec(rev.ncorage),
                                                eva.dfeceva)), 'dd/mm/yyyy') as fecvis,
                         actd.cnomact || ' - ' || basd.cnomact as actividad
                    from (select *
                            from acdeval
                           where nindcier = '0'
                             and ncodact in (5)
                          union
                          select *
                            from acheval
                           where nindcier = '0'
                             and ncodact in (5)) eva
                    left join acdasig asi
                      on eva.cnumdoc = asi.cnumdoc
                     and eva.ntipdoc = asi.ntipdoc
                     and eva.npaicli = asi.npaicli
                     and eva.ncoding = asi.ncoding
                     and eva.ncodact = asi.ncodact
                    left join acdagen age
                      on eva.cnumdoc = age.cnumdoc
                     and eva.ntipdoc = age.ntipdoc
                     and eva.npaicli = age.npaicli
                     and eva.ncoding = age.ncoding
                     and eva.ncodact = age.ncodact
                  
                    left join acmoper opereva
                      on trim(opereva.ccodope) = trim(upper(eva.cusuing))
                     and opereva.ccodest = '1'
                    left join acmoper descap
                      on descap.ccodope = opereva.ccodope
                    left join acdrole descap1
                      on descap1.ncodrol = descap.ccodcar
                    left join acdagus actsuc
                      on actsuc.ccodope = trim(upper(eva.cusuing))
                    left join acmsucu suc
                      on actsuc.ncodsuc = suc.ncodsuc
                    left join acmoper operasig
                      on trim(operasig.ccodope) = trim(upper(asi.ccodusu))
                     and operasig.ccodest = '1'
                    left join acmoper desact
                      on desact.ccodope = operasig.ccodope
                     and desact.ccodest = '1'
                    left join acdrole desact1
                      on desact1.ncodrol = desact.ccodcar
                    left join acdagus actsuc1
                      on actsuc1.ccodope = trim(upper(asi.ccodusu))
                    left join acmsucu suc1
                      on actsuc1.ncodsuc = suc1.ncodsuc
                  
                    left join actbase atb
                      on atb.ncodbas = eva.ncodbas
                     and atb.ncodact = eva.ncodact
                    left join acdrevi rev
                      on rev.npaicli = eva.npaicli
                     and rev.ntipdoc = eva.ntipdoc
                     and rev.cnumdoc = eva.cnumdoc
                     and rev.ncodact = eva.ncodact
                    left join actbase basd
                      on basd.ncodbas = eva.ncodbas
                     and basd.ncodact = eva.ncodact
                    left join actacti actd
                      on actd.ncodact = eva.ncodact
                   where eva.cnumdoc = ps_numdoc
                     and eva.ntipdoc = pn_tipdoc
                     and eva.npaicli = pn_codpai
                     and eva.nindcier = '0'
                     and eva.ncodact in (5)
                        /*and opereva.ccodest = '1' */
                     and operasig.ccodest = '1') tabla
           where rownum = 1;
      else
        open lc_liscur for
          select ' ' as nomcli,
                 ' ' as numdoc,
                 ' ' as usucap,
                 ' ' as agecap,
                 ' ' as rolcap,
                 '0' as usuact,
                 ' ' as ageasi,
                 ' ' as rolact,
                 ' ' as resvis,
                 ' ' as fecvis,
                 ' ' as actividad
            from dual;
      
      end if;
    end if;
  
  end sp_bloref;

  procedure sp_insagepro(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         ps_codana varchar2,
                         pd_fecage varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_insagepro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Procedimiento para agendar al cliente para Promotores
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_tipdoc varchar(3);
    ld_fecage date;
    --ln_numpos number;
    ls_strfec varchar2(10);
    ls_strhor varchar2(5);
  begin
  
    --SELECT INSTR(pd_fecage,'T', 1, 1) into ln_numpos FROM DUAL;
    SELECT SUBSTR(pd_fecage, 1, 10), SUBSTR(pd_fecage, 12, 5)
      into ls_strfec, ls_strhor
      FROM DUAL;
  
    select to_date(ls_strfec, 'YYYY-MM-DD') into ld_fecage from dual;
  
    select ccodatr
      into ls_tipdoc
      from acdatri
     where cestado = '1'
       and ctipatr = 'D'
       and ncodtab = '6'
       and trim(cdesatr) = trim(ps_codtip);
  
    ls_tipdoc := trim(ls_tipdoc);
  
    insert into achagen
      select *
        from acdagen
       where npaicli = ps_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ps_numdoc;
    commit;
  
    delete acdagen
     where npaicli = ps_codpai
       and ntipdoc = ls_tipdoc
       and trim(cnumdoc) = ps_numdoc;
    commit;
    insert into acdagen
      select supplier_seq.NEXTVAL,
             nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             '1',
             to_char(sysdate, 'DD/MM/YYYY'),
             trunc(dfeceva),
             ld_fecage,
             ls_strhor,
             ps_codana,
             ps_codana,
             sysdate,
             '0',
             ncorcli,
             '0',
             '0'
        from acdeval
       where npaicli = ps_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ps_numdoc;
    commit;
  
    update acdasig
       set cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ls_tipdoc
       and trim(cnumdoc) = ps_numdoc;
    commit;
  
  end sp_insagepro;

  procedure sp_listra(ls_nomusu varchar2,
                      ls_codsuc varchar2,
                      lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_listra
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista para la transferencia
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ln_codage  number;
    ls_usuario varchar2(12);
  begin
  
    if ls_nomusu = 'elige Usuario...' then
      ls_usuario := null;
    end if;
  
    if ls_codsuc = 'NO' then
      ln_codage  := null;
      ls_usuario := null;
    else
      if ls_nomusu = 'elige Usuario...' then
        ls_usuario := null;
      else
        ln_codage  := ls_codsuc;
        ls_usuario := upper(trim(ls_nomusu));
      
      end if;
    
    end if;
  
    open lc_liscur for
    --select tip.cdesatr,
    --       eva.cnumdoc,
    --       eva.cclinom,
    --       ubi.cdesdep,
    --       ubi.cdespro,
    --       ubi.cdesdis,
    --       cal.cdesatr
    --       from acdeval eva
    --      inner join acdatri tip
    --         on tip.ncodtab=6 and tip.ctipatr = 'D' and tip.ccodatr= eva.ntipdoc
    --       left join actugeo ubi
    --         on ubi.cubigeo= eva.czonfij
    --      inner join acdatri cal
    --         on cal.ncodtab=5 and cal.ctipatr = 'D' and cal.ccodatr= eva.ccodcal
    --     inner join actingr ing
    --         on ing.ncoding = eva.ncoding and ing.cestado='A'
    --      inner join actbase bas
    --         on bas.ncodbas = eva.ncodbas and bas.cestado='A' and bas.ncodact = eva.ncodact
    --      inner join actacti act
    --         on act.ncodact = eva.ncodact and act.cestado ='A'   
    --      where eva.ccodest in ('1','2')
    --        and eva.ccodest='1'
    --        and eva.nagepre in (select ncodsuc from acdagus where ccodope =upper(trim(ls_nomusu)));
    
      select act.cnomact,bas.cnomact,eva.cusuing,tip.cdesatr || ' - ' || asi.cnumdoc as cnumdoc,
             eva.cclinom,ubi.cdespro || ' - ' || ubi.cdesdis as cdesdis,cal.cdesatr || ' - ' || to_char(trunc(eva.dfeceva),'DD/MM/YYYY'),
             act.cnomact || ' ' || asi.cnumdoc as resdni
        from acdasig asi
       inner join acdatri tip
          on tip.ncodtab = 6
         and tip.ctipatr = 'D'
         and tip.ccodatr = asi.ntipdoc
       inner join actbase bas
          on asi.ncodact = bas.ncodact
         and asi.ncodbas = bas.ncodbas
         and bas.cestado = 'A'
       inner join (select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acdeval
                    where nindcier = '0'
                   union
                   select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acheval
                    where nindcier = '0') eva
          on eva.ncorcli = asi.ncorcli
        left join actugeo ubi
          on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
        left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.ccodatr = coalesce(eva.ccodcal, '1')
        left join actacti act
          on act.ncodact = asi.ncodact
         and act.cestado = 'A'
        left join acdagus suc
          on trim(suc.ccodope) = trim(asi.ccodusu)
       where eva.nindcier = '0'
         and trim(asi.ccodusu) = coalesce(ls_usuario, trim(asi.ccodusu))
         and suc.ncodsuc = coalesce(ln_codage, suc.ncodsuc);
  
  end sp_listra;

  procedure sp_lisprm(ls_nomsuc varchar2,
                      ls_nomusu varchar2,
                      lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisprm
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de posibles usuarios a transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_codrol number;
  begin
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = upper(ls_nomusu)
       and ccodest = '1';
  
    if ls_codrol in (6) then
      open lc_liscur for
        select p.ccodope, ope.cnomope
          from acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = '1'
         order by 2;
    
    end if;
    if ls_codrol in (50, 51, 52, 200, 201, 104, 103) then
      open lc_liscur for
        select p.ccodope, ope.cnomope
          from acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = '1'
         where ncodsuc = ls_nomsuc
           and ope.ccodcar in (201, 200)
         order by 2;
    end if;
  
    if ls_codrol in (202, 101, 8, 105, 107, 11, 12, 671, 13, 14, 15, 16,17) then
      open lc_liscur for
        select p.ccodope, ope.cnomope
          from acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = '1'
         where ope.ccodcar in (201, 200, 202)
         order by 2;
    end if;
  
    if ls_codrol in (102, 7, 10, 9, 108) then
      open lc_liscur for
        select p.ccodope, ope.cnomope
          from acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = '1'
         where ope.ccodcar in (201, 200, 202, 102, 108)
         order by 2;
    end if;
  end sp_lisprm;

  procedure sp_instra(ps_numdoc varchar2,
                      ps_anaini varchar2,
                      ps_anafin varchar2) as
    ls_codsuc number;
    -- *****************************************************************
    -- Nombre                     : sp_instra
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 30/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Inserta la transferecia de CLiente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  
    ln_codact number;
    ls_numdoc varchar2(12);
  begin
  
    select substr(ps_numdoc, INSTR(ps_numdoc, ' '), length(ps_numdoc)),
           act.ncodact
      into ls_numdoc, ln_codact
      from dual
     inner join actacti act
        on cnomact = substr(ps_numdoc, 0, INSTR(ps_numdoc, ' ') - 1);
  
    select ncodsuc
      into ls_codsuc
      from acdagus
     where ccodope = upper(ps_anafin)
       and rownum = 1;
  
    insert into acdtran
      select nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             upper(ps_anaini),
             upper(ps_anafin),
             dfeceva,
             sysdate
        from acdeval
       where cnumdoc = trim(ls_numdoc)
         and ncodact = ln_codact
         and nindcier = '0';
    commit;
  
    -- Pasar a Producción 2018/02/05 en el siguiente pase
    /*insert into acdtran
    select nidebas,
           nidepro,
           ncoding,
           ncodact,
           ncodbas,
           npaicli,
           ntipdoc,
           cnumdoc,
           upper(ps_anaini),
           upper(ps_anafin),
           dfeceva,
           sysdate
            from acdeval
    where cnumdoc=trim(ls_numdoc)
      and ncodact = ln_codact
      and nindcier ='0';
    commit;*/
  
    insert into achasig
      select nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             cestado,
             sysdate,
             dfecasi,
             ccodusu,
             cusuasi,
             chorasi,
             cusumod,
             dfecmod,
             nindasi,
             ncorcli,
             ncorasi
        from acdasig
       where cnumdoc = trim(ls_numdoc)
         and ncodact = ln_codact;
    commit;
  
    update acdasig
    -- Se actualiza usumod y fecha de modificación
       set cestado = '1', ccodusu = ps_anafin,ncorasi = seq_corasi.nextval,
           cusumod = upper(ps_anaini),dfecmod = sysdate
     where cnumdoc = trim(ls_numdoc)
       and ncodact = ln_codact;
    commit;
  
    -- Pasar a Producción 2018/02/05 en el siguiente pase
    /*insert into achagen
    select * from acdagen
    where cnumdoc = trim(ls_numdoc)
      and ncodact = ln_codact;
    commit;*/
  
    update acdagen
       set Cestado = '2'
     where cnumdoc = trim(ls_numdoc)
       and ncodact = ln_codact;
    commit;
  
    update achagen
       set Cestado = '2'
     where cnumdoc = trim(ls_numdoc)
       and ncodact = ln_codact;
    commit;
  
  end sp_instra;

  procedure sp_todsuc(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra todas las sucursales
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ncodsuc, cnomsuc
        from acmsucu
       where ccodest = '1'
         and ncodsuc < 800
       order by 2;
  end sp_todsuc;

  procedure sp_grcli(ps_nomusu varchar2, lc_liscur out types.cursor_type) as
  
    -- *****************************************************************
    -- Nombre                     : sp_lisgri
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 30/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista para grilla
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_nomusu char(10);
  begin
    ls_nomusu := upper(trim(ps_nomusu));
    open lc_liscur for
      select *
        from (
             
              (select asi.npaicli,
                      tipdoc.cdesatr as ctipdoc,
                      asi.cnumdoc,
                      eva.cclinom,
                      ubi.cdesdis,
                      case
                        when czonfij is null then
                         cdirneg
                        else
                         cdirfij
                      end as cdircli,
                      cal.cdesatr
                 from acdasig asi
                inner join acdeval eva
                   on asi.npaicli = eva.npaicli
                  and asi.ntipdoc = eva.ntipdoc
                  and asi.cnumdoc = eva.cnumdoc
                 left join acdatri tipdoc
                   on tipdoc.ncodtab = 6
                  and tipdoc.ctipatr = 'D'
                  and tipdoc.ccodatr = asi.ntipdoc
                 left join actugeo ubi
                   on ubi.cubigeo = coalesce(eva.czonfij, eva.czonneg)
                 left join acdatri cal
                   on cal.ncodtab = 5
                  and cal.ctipatr = 'D'
                  and cal.ccodatr = eva.ccodcal
                where asi.cestado = '1'
                  and upper(asi.ccodusu) = ls_nomusu
               
               ) union
             
              (select age.npaicli,
                      tipdoc.cdesatr as ctipdoc,
                      age.cnumdoc,
                      eva.cclinom,
                      ubi.cdesdis,
                      case
                        when czonfij is null then
                         cdirneg
                        else
                         cdirfij
                      end as cdircli,
                      cal.cdesatr
                 from acdagen age
                inner join acdeval eva
                   on age.npaicli = eva.npaicli
                  and age.ntipdoc = eva.ntipdoc
                  and age.cnumdoc = eva.cnumdoc
                 left join acdatri tipdoc
                   on tipdoc.ncodtab = 6
                  and tipdoc.ctipatr = 'D'
                  and tipdoc.ccodatr = age.ntipdoc
                 left join actugeo ubi
                   on ubi.cubigeo = coalesce(eva.czonfij, eva.czonneg)
                 left join acdatri cal
                   on cal.ncodtab = 5
                  and cal.ctipatr = 'D'
                  and cal.ccodatr = eva.ccodcal
                where age.cestado = '1'
                  and upper(age.ccodusu) = ls_nomusu)) a
       order by 4;
  
  end sp_grcli;

  procedure sp_datper(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_datper
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra los datos de perfil de un cliente
    -- Estado                     : Activo
    -- Fecha Modificación         : 24/05/2018
    -- Autor de Modificación      : WCRW
    -- Descripcion Modificacion   : Mostrar datos de acheval
    -- *****************************************************************  
   as
    ln_tipdoc number;
    ln_buseva number;
    ln_bushis number;
    ld_feceva date;
    ld_fechis date;
    ln_tipbus number;
    ln_evacli number;
    ln_hiscli number;
  
  begin
    ln_buseva := 0;
    ln_bushis := 0;
    ln_tipbus := 0;
    ln_evacli := 0;
    ln_hiscli := 0;
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    begin
      select 1, trunc(dfeceva), ncorcli
        into ln_buseva, ld_feceva, ln_evacli
        from acdeval eva
       where eva.cnumdoc = trim(ps_numdoc)
         and eva.ntipdoc = ln_tipdoc
         and eva.npaicli = ps_codpai;
    exception
      when no_data_found then
        ln_buseva := 0;
    end;
    begin
      select 1, max(ncorcli)
        into ln_bushis, ln_hiscli
        from acheval
       where cnumdoc = trim(ps_numdoc)
         and ntipdoc = ln_tipdoc
         and npaicli = ps_codpai;
    exception
      when no_data_found then
        ln_bushis := 0;
    end;
  
    if ln_buseva = 1 and ln_bushis = 1 and ln_evacli > ln_hiscli then
      ln_tipbus := 1;
    end if;
    if ln_buseva = 1 and ln_bushis = 1 and ln_evacli < ln_hiscli and
       ln_tipbus = 0 then
      ln_tipbus := 2;
    end if;
    if ln_buseva = 1 and ln_bushis = 0 and ln_tipbus = 0 then
      ln_tipbus := 1;
    end if;
    if ln_buseva = 0 and ln_bushis = 1 and ln_tipbus = 0 then
      ln_tipbus := 2;
    end if;
  
    if ln_tipbus = 2 then
      open lc_liscur for
        select tip.cdesatr as tipdoc,
               eva.cnumdoc,
               eva.cclinom,
               coalesce(floor(floor(MONTHS_BETWEEN(trunc(sysdate),
                                                   eva.dfecnac)) / 12), 0) as iedad,
               eva.csegcli,
               coalesce(suc.cnomsuc, ' ') as agepre,
               case
                 when eva.cotrana = 'S' then
                  'Si'
                 else
                  'No'
               end as otrana,
               coalesce(eva.cnomsec, ' ') as cnomsec,
               eva.cactcli,
               coalesce(tico.cdesatr, ' ') as doccon,
               coalesce(eva.cdoccon, ' ') as numcon,
               coalesce(eva.cconnom, ' ') as nomcon,
               case
                 when eva.cestcre = 'S' then
                  'Si'
                 else
                  'No'
               end as estcre,
               coalesce(eva.cfecdes, ' ') as fecdes,
               coalesce(to_char(eva.nagecli), ' ') as agecre,
               coalesce(to_char(eva.nnument), '0') as nnument,
               coalesce(eva.cdirfij, ' ') as dirfij,
               coalesce(eva.creffij, ' ') as reffij,
               case
                 when fubi.cdespro is null and fubi.cdesdis is null then
                  ' '
                 else
                  fubi.cdespro || '/' || fubi.cdesdis
               end as ubidom,
               coalesce(eva.cdirneg, ' ') as dirneg,
               coalesce(eva.crefneg, ' ') as refneg,
               case
                 when fneg.cdespro is null and fneg.cdesdis is null then
                  ' '
                 else
                  fneg.cdespro || '/' || fneg.cdesdis
               end as ubineg,
               coalesce(eva.nnument, 0) as nnument,
               coalesce(ctelneg, ' ') as ctelneg,
               coalesce(coalesce(ctelfij, ctelmov), ' ') as ctelfij
          from acheval eva
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ntipdoc
          left join acdatri tico
            on tico.ncodtab = 6
           and tico.ctipatr = 'D'
           and tico.ccodatr = eva.ntipcon
          left join acmsucu suc
            on suc.ncodsuc = eva.nagepre
           and suc.ccodest = '1'
          left join actugeo fubi
            on fubi.cubigeo = eva.czonfij
          left join actugeo fneg
            on fneg.cubigeo = eva.czonneg
         where eva.cnumdoc = trim(ps_numdoc)
           and eva.ntipdoc = ln_tipdoc
           and eva.npaicli = ps_codpai
           and eva.ncorcli = ln_hiscli;
    else
      open lc_liscur for
        select tip.cdesatr as tipdoc,
               eva.cnumdoc,
               eva.cclinom,
               coalesce(floor(floor(MONTHS_BETWEEN(trunc(sysdate),
                                                   eva.dfecnac)) / 12), 0) as iedad,
               eva.csegcli,
               coalesce(suc.cnomsuc, ' ') as agepre,
               case
                 when eva.cotrana = 'S' then
                  'Si'
                 else
                  'No'
               end as otrana,
               coalesce(eva.cnomsec, ' ') as cnomsec,
               eva.cactcli,
               coalesce(tico.cdesatr, ' ') as doccon,
               coalesce(eva.cdoccon, ' ') as numcon,
               coalesce(eva.cconnom, ' ') as nomcon,
               case
                 when eva.cestcre = 'S' then
                  'Si'
                 else
                  'No'
               end as estcre,
               coalesce(eva.cfecdes, ' ') as fecdes,
               coalesce(to_char(eva.nagecli), ' ') as agecre,
               coalesce(to_char(eva.nnument), '0') as nnument,
               coalesce(eva.cdirfij, ' ') as dirfij,
               coalesce(eva.creffij, ' ') as reffij,
               case
                 when fubi.cdespro is null and fubi.cdesdis is null then
                  ' '
                 else
                  fubi.cdespro || '/' || fubi.cdesdis
               end as ubidom,
               coalesce(eva.cdirneg, ' ') as dirneg,
               coalesce(eva.crefneg, ' ') as refneg,
               case
                 when fneg.cdespro is null and fneg.cdesdis is null then
                  ' '
                 else
                  fneg.cdespro || '/' || fneg.cdesdis
               end as ubineg,
               coalesce(eva.nnument, 0) as nnument,
               coalesce(ctelneg, ' ') as ctelneg,
               coalesce(coalesce(ctelfij, ctelmov), ' ') as ctelfij
          from acdeval eva
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ntipdoc
          left join acdatri tico
            on tico.ncodtab = 6
           and tico.ctipatr = 'D'
           and tico.ccodatr = eva.ntipcon
          left join acmsucu suc
            on suc.ncodsuc = eva.nagepre
           and suc.ccodest = '1'
          left join actugeo fubi
            on fubi.cubigeo = eva.czonfij
          left join actugeo fneg
            on fneg.cubigeo = eva.czonneg
         where eva.cnumdoc = trim(ps_numdoc)
           and eva.ntipdoc = ln_tipdoc
           and eva.npaicli = ps_codpai;
    end if;
  end sp_datper;

  procedure sp_lising(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lising
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Ingresos -- Misti 
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  begin
    open lc_liscur for
      select ncoding, cnombas from actingr;
  end sp_lising;

  procedure sp_lisact(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisact
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Actividades
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    open lc_liscur for
      select ncodact, cnomact from actacti order by 1;
  end sp_lisact;

  procedure sp_lisbas(pc_codact varchar2, lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisbas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Bases
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    open lc_liscur for
      select ncodbas, cnomact
        from actbase
       where cestado = 'A'
         and ncodact = pc_codact
       order by 1;
  end sp_lisbas;

  procedure sp_aleage(ps_nomusu varchar2, lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_aleage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de alerta de agendados
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codusu char(10);
  begin
    ls_codusu := upper(trim(ps_nomusu));
  
    open lc_liscur for
    
    /*select to_char(to_date(asi.dfecasi,'YYYY/MM/DD'),'DD/MM/YYYY') as dfecvis,
                                                                                                                                                                                                                                                                                                act.cnomact as acti,
                                                                                                                                                                                                                                                                                                bas.cnomact as base,
                                                                                                                                                                                                                                                                                                count(*) as contar
                                                                                                                                                                                                                                                                                     from acdasig asi
                                                                                                                                                                                                                                                                                          inner join actingr ing
                                                                                                                                                                                                                                                                                             on ing.ncoding= asi.ncoding
                                                                                                                                                                                                                                                                                          inner join actacti act
                                                                                                                                                                                                                                                                                             on act.ncodact= asi.ncodact
                                                                                                                                                                                                                                                                                          inner join acdeval
                                                                                                                                                                                                                                                                                          eva
                                                                                                                                                                                                                                                                                             on eva.npaicli = asi.npaicli
                                                                                                                                                                                                                                                                                           and eva.ntipdoc = asi.ntipdoc
                                                                                                                                                                                                                                                                                           and eva.cnumdoc = asi.cnumdoc 
                                                                                                                                                                                                                                                                                           inner join actbase bas
                                                                                                                                                                                                                                                                                             on bas.ncodbas= asi.ncodbas and bas.ncodact = act.ncodact
                                                                                                                                                                                                                                                                                          inner join acdatri doc
                                                                                                                                                                                                                                                                                             on doc.ncodtab = 6 and doc.ctipatr='D' and doc.ccodatr=asi.ntipdoc and doc.cestado='1'
                                                                                                                                                                                                                                                                                           left join actugeo ubd 
                                                                                                                                                                                                                                                                                           on ubd.cubigeo= coalesce(eva.czonfij,eva.czonneg)
                                                                                                                                                                                                                                                                                           left join actbase nbas
                                                                                                                                                                                                                                                                                           on asi.ncodbas = nbas.ncodbas and asi.ncodact = nbas.ncodact
                                                                                                                                                                                                                                                                                    inner join actacti act
                                                                                                                                                                                                                                                                                       on act.ncodact = asi.ncodact and act.cestado='A'
                                                                                                                                                                                                                                                                                    inner join actbase bas
                                                                                                                                                                                                                                                                                       on bas.ncodbas = asi.ncodbas and bas.ncodact = asi.ncodact and bas.cestado='A'
                                                                                                                                                                                                                                                                                    where asi.cestado = '1'
                                                                                                                                                                                                                                                                                     and upper(trim(asi.ccodusu)) = upper(trim(ps_nomusu))
                                                                                                                                                                                                                                                                                          group by to_date(asi.dfecasi,'YYYY/MM/DD'),
                                                                                                                                                                                                                                                                                                   act.cnomact,
                                                                                                                                                                                                                                                                                                   bas.cnomact
                                                                                                                                                                                                                                                                                          order by 1 desc;*/
    
      select to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'), 'DD/MM/YYYY') as dfecvis,
             act.cnomact as acti,
             bas.cnomact as base,
             count(*) as contar
        from (select ncorcli
                from acdeval
               where nindcier = 0
              union all
              select ncorcli
                from acheval
               where nindcier = 0) eva
       inner join acdasig asi
          on asi.ncorcli = eva.ncorcli
         and asi.ccodusu = ls_codusu
         and asi.cestado = 1
       inner join actacti act
          on act.ncodact = asi.ncodact
         and act.cestado = 'A'
       inner join actbase bas
          on bas.ncodbas = asi.ncodbas
         and bas.ncodact = asi.ncodact
         and bas.cestado = 'A'
       group by to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'), 'DD/MM/YYYY'),
                act.cnomact,
                bas.cnomact;
  end sp_aleage;

  procedure sp_estaleage(ps_nomusu varchar2,
                         lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisbas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/01/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Bases
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    open lc_liscur for
      select count(*) as numreg
        from acdasig asi
       inner join actacti act
          on act.ncodact = asi.ncodact
         and act.cestado = 'A'
       inner join actbase bas
          on bas.ncodbas = asi.ncodbas
         and bas.ncodact = asi.ncodact
         and bas.cestado = 'A'
       where asi.cestado = '1'
         and upper(trim(asi.ccodusu)) = upper(trim(ps_nomusu));
  exception
    when no_data_found then
      open lc_liscur for
        select 0 as numreg from dual;
  end sp_estaleage;

  procedure sp_datgrircc(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_datgrircc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Datos de RCC para la Grilla de Clientes
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    open lc_liscur for
      select coalesce(cclinom, ' ') as cclinom,
             coalesce(cdoccon, 'NO') as cdoccon,
             coalesce(cconnom, ' ') as cconnom
        from acdeval
       where cnumdoc = ps_numdoc
         and npaicli = ps_codpai
         and ntipdoc = ps_codtip;
  
  end sp_datgrircc;

  procedure sp_version(ps_numver out varchar) as
    -- *****************************************************************
    -- Nombre                     : sp_version
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Datos de RCC para la Grilla de Clientes
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    select cdesatr
      into ps_numver
      from acdatri
     where ncodtab = 10
       and ctipatr = 'D'
       and ccodatr = '1';
  
  end sp_version;

  procedure sp_griubi(ps_codubi varchar, pc_desubi out varchar) as
    -- *****************************************************************
    -- Nombre                     : sp_griubi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Detalle ubigeo para grilla cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    select cdesdep || '-' || cdespro || '-' || cdesdis
      into pc_desubi
      from actugeo
     where cast(trim(cubigeo) as int) = cast(trim(ps_codubi) as int);
  
  exception
    when no_data_found then
      pc_desubi := ' ';
    
  end sp_griubi;

  procedure sp_lisciu(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisciu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 08/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista los ciiu o actividad económica
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    open lc_liscur for
      select * from actciiu order by 2;
  
  end sp_lisciu;

  procedure sp_liscar(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_liscar
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de cartas
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 11
         and ctipatr = 'D';
  end sp_liscar;

  procedure sp_hiscon(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_hiscon
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra el historico de consultas de un cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ope.ccodope as codope,
             ope.cnomope as nomope,
             eva.cclinom as nomcli,
             to_char(his.dfeccon, 'DD/MM/YYYY') as feccon,
             to_char(his.dfeccon, 'HH:MI:SS AM') as horcon
        from achcons his
       inner join acmoper ope
          on his.cusucon = ope.ccodope
         and ope.ccodest = '1'
        left join acdeval eva
          on eva.cnumdoc = his.cnumdoc
         and eva.npaicli = his.npaicli
         and eva.ntipdoc = his.ntipdoc
       where his.cnumdoc = ps_numdoc
         and his.npaicli = ps_codpai
         and his.ntipdoc = ps_codtip
       order by his.dfeccon desc;
  end sp_hiscon;

  procedure sp_libcli(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_libcli
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Liberar Cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ln_tipdoc number;
  begin
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    update acdasig
       set cestado = '2'
     where cnumdoc = ps_numdoc
       and npaicli = ps_codpai
       and ntipdoc = ln_tipdoc;
  
    commit;
  
    update acdeval
       set nindcier = '1'
     where npaicli = ps_codpai
       and ntipdoc = ln_tipdoc
       and cnumdoc = ps_numdoc;
    commit;
  end sp_libcli;

  procedure sp_lisusutra(ps_codusu varchar2,
                         lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : ps_codusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de usuarios para transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ope.ccodope, ope.cnomope
        from acdagus age
       inner join acmoper ope
          on ope.ccodope = age.ccodope
         and ope.ccodest = '1'
       where age.ncodsuc in
             (select ncodsuc from acdagus where ccodope = ps_codusu)
       order by 2;
  end sp_lisusutra;

  procedure sp_tracliage(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         ps_codact number,
                         ps_codusu varchar2,
                         ps_codasi varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_tracliage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Transferir cliente cuando este agendado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
    ln_tipdoc number;
  begin
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    insert into acdtran
      select *
        from (select nidebas,
                     nidepro,
                     ncoding,
                     ncodact,
                     ncodbas,
                     npaicli,
                     ntipdoc,
                     cnumdoc,
                     upper(ps_codasi),
                     upper(ps_codusu),
                     dfeceva,
                     sysdate
                from (select *
                        from acdeval
                       where nindcier = 0
                      union
                      select *
                        from acheval
                       where nindcier = 0)
               where cnumdoc = ps_numdoc
                 and npaicli = ps_codpai
                 and ntipdoc = ln_tipdoc
                 and ncodact = trim(ps_codact))
       where rownum = 1;
  
    insert into achasig
      select nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             cestado,
             sysdate,
             dfecasi,
             ccodusu,
             cusuasi,
             chorasi,
             cusumod,
             dfecmod,
             nindasi,
             ncorcli,
             ncorasi
        from acdasig
       where cnumdoc = ps_numdoc
         and npaicli = ps_codpai
         and ntipdoc = ln_tipdoc
         and ncodact = ps_codact;
    commit;
    update acdasig
       set dfecasi = to_char(sysdate, 'YYYY/MM/DD'),
           ccodusu = ps_codusu,
           cusuasi = ps_codasi,
           chorasi = to_char(sysdate, 'hh24:mi:ss'),
           cusumod = ps_codasi,
           dfecmod = sysdate,
           cestado = '1'
     where cnumdoc = ps_numdoc
       and npaicli = ps_codpai
       and ntipdoc = ln_tipdoc
       and ncodact = ps_codact;
    commit;
  
    update acdagen
       set cestado = '2'
     where cnumdoc = ps_numdoc
       and npaicli = ps_codpai
       and ntipdoc = ln_tipdoc
       and ncodact = ps_codact;
    commit;
    update achagen
       set cestado = '2'
     where cnumdoc = ps_numdoc
       and npaicli = ps_codpai
       and ntipdoc = ln_tipdoc
       and ncodact = ps_codact;
    commit;
  
  end sp_tracliage;

  procedure sp_liscliage(ps_codpai varchar2,
                         ps_codtip varchar2,
                         ps_numdoc varchar2,
                         lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : ps_codusu
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de usuarios para transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_tipdoc number;
  begin
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
    open lc_liscur for
      select coalesce(cclinom, ' ') as cclinom,
             coalesce(czonfij, ' ') as czonfij,
             coalesce(cdirfij, ' ') as cdirfij,
             coalesce(creffij, ' ') as creffij,
             coalesce(czonneg, ' ') as czonneg,
             coalesce(cdirneg, ' ') as cdirneg,
             coalesce(crefneg, ' ') as crefneg,
             coalesce(ctelfij, ' ') as ctelfij,
             coalesce(ctelneg, ' ') as ctelneg,
             coalesce(ctelmov, ' ') as ctelmov,
             coalesce(to_char(nmoneva), ' ') as nmoneva,
             coalesce(cconnom, ' ') as cconnom,
             coalesce(cdoccon, ' ') as cdoccon,
             coalesce(cactcli, ' ') as cactcli,
             coalesce(cdestcre, ' ') as cdestcre,
             coalesce(ctiping, ' ') as ctiping,
             coalesce(czonpro, ' ') as czonpro,
             coalesce(cmailcl, ' ') as cmailcl
        from acdeval
       where cnumdoc = ps_numdoc
         and npaicli = ps_codpai
         and ntipdoc = ln_tipdoc;
  end sp_liscliage;

  procedure sp_actcli(ps_codpai  varchar2,
                      ps_codtip  varchar2,
                      ps_numdoc  varchar2,
                      ps_clinom  varchar2,
                      ps_depviv  varchar2,
                      ps_proviv  varchar2,
                      ps_disviv  varchar2,
                      ps_dirfij  varchar2,
                      ps_reffij  varchar2,
                      ps_depneg  varchar2,
                      ps_proneg  varchar2,
                      ps_disneg  varchar2,
                      ps_dirneg  varchar2,
                      ps_refneg  varchar2,
                      ps_telcli  varchar2,
                      ps_telneg  varchar2,
                      ps_telmov  varchar2,
                      ps_moneva  varchar2,
                      ps_connom  varchar2,
                      ps_doccon  varchar2,
                      ps_actcli  varchar2,
                      ps_destcre varchar2,
                      ps_tiping  varchar2,
                      ps_czonpro varchar2,
                      ps_mailcl  varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_actcli
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Actualizar cliente del modulo de cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_tipdoc  number;
    ls_ubiviv  varchar2(8);
    ls_ubineg  varchar2(8);
    ls_indeval number;
  begin
  
    if ps_depviv = ' ' or ps_proviv = ' ' or ps_disviv = ' ' then
      ls_ubiviv := null;
    else
      select cubigeo
        into ls_ubiviv
        from actugeo
       where cdesdep = ps_depviv
         and cdespro = ps_proviv
         and cdesdis = ps_disviv;
    end if;
  
    if ps_depneg = ' ' or ps_proneg = ' ' or ps_disneg = ' ' then
      ls_ubineg := null;
    else
      select cubigeo
        into ls_ubineg
        from actugeo
       where cdesdep = ps_depneg
         and cdespro = ps_proneg
         and cdesdis = ps_disneg;
    end if;
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    select count(*)
      into ls_indeval
      from acdeval eva
     where eva.cnumdoc = trim(ps_numdoc)
       and eva.ntipdoc = ln_tipdoc
       and eva.npaicli = ps_codpai;
  
    if (ls_indeval > 0) then
      update acdeval
         set cclinom  = ps_clinom,
             czonfij  = ls_ubiviv,
             cdirfij  = ps_dirfij,
             creffij  = ps_reffij,
             czonneg  = ls_ubineg,
             cdirneg  = ps_dirneg,
             crefneg  = ps_refneg,
             ctelfij  = ps_telcli,
             ctelneg  = ps_telneg,
             ctelmov  = ps_telmov,
             nmoneva  = coalesce(Trim(ps_moneva), '0'),
             cconnom  = ps_connom,
             cdoccon  = ps_doccon,
             cactcli  = ps_actcli,
             cdestcre = ps_destcre,
             ctiping  = ps_tiping,
             czonpro  = ps_czonpro,
             cmailcl  = ps_mailcl
      
       where cnumdoc = trim(ps_numdoc)
         and npaicli = ps_codpai
         and ntipdoc = ln_tipdoc;
      commit;
    else
      insert into acdeval
        (cclinom,
         czonfij,
         cdirfij,
         creffij,
         czonneg,
         cdirneg,
         crefneg,
         ctelfij,
         ctelneg,
         ctelmov,
         nmoneva,
         cconnom,
         cdoccon,
         cactcli,
         cdestcre,
         ctiping,
         czonpro,
         cmailcl,
         cnumdoc,
         npaicli,
         ntipdoc,
         ncorcli)
      values
        (ps_clinom,
         ls_ubiviv,
         ps_dirfij,
         ps_reffij,
         ls_ubineg,
         ps_dirneg,
         ps_refneg,
         ps_telcli,
         ps_telneg,
         ps_telmov,
         coalesce(Trim(ps_moneva), '0'),
         ps_connom,
         ps_doccon,
         ps_actcli,
         ps_destcre,
         ps_tiping,
         ps_czonpro,
         ps_mailcl,
         trim(ps_numdoc),
         ps_codpai,
         ln_tipdoc,
         SEQ_CORCLI.NEXTVAL);
      commit;
    
    end if;
  end sp_actcli;

  procedure sp_atrmora(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_atrmora
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de atributos para mora.
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 12
         and ctipatr = 'D'
         and cestado = '1';
  end sp_atrmora;

  procedure sp_atrsald(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_atrsald
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de atributos para Saldo.
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 13
         and ctipatr = 'D'
         and cestado = '1';
  end sp_atrsald;

  procedure sp_hiscli(ps_codpai varchar2,
                      ps_codtip varchar2,
                      ps_numdoc varchar2,
                      lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_hiscli
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista del historico de visitas del cliente
    -- Estado                     : Activo
    -- Fecha Modificación         : 02/12/2024
    -- Autor de Modificación      : FPINTO
    -- Descripcion Modificacion   : Se reduce el costo de la consulta
    -- *****************************************************************  
   as
    ln_tipdoc number;
    ld_fecini date;
    ld_fecfin date;
  begin
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    open lc_liscur for
      select rownum,
             to_char(rev.dfecvis),
             usu.cnomope,
             resu.cnomres,
             coalesce(rev.cobserv, ' ') as cobserv
        from ((select * from acdeval) union all (select * from acheval)) eva
       inner join((select ncorcli, ncorasi, cnumdoc from acdasig)
      union all (select ncorcli, ncorasi, cnumdoc from achasig)) asi
          on eva.ncorcli = asi.ncorcli and eva.cnumdoc=asi.cnumdoc
       inner join((select ncorage, dfecmod, ncorasi, dfecest, cnumdoc from acdagen)
      union all (select ncorage, dfecmod, ncorasi, dfecest, cnumdoc from achagen)) age
          on asi.ncorasi = age.ncorasi and asi.cnumdoc=age.cnumdoc
       inner join((select ncorage, nrespue, cusucre, cobserv, dfecvis, cnumdoc
                     from achrevi)
      union all (select ncorage, nrespue, cusucre, cobserv, dfecvis, cnumdoc
                   from acdrevi)) rev
          on rev.ncorage = age.ncorage and rev.cnumdoc=age.cnumdoc
       inner join acdrepu repu
          on repu.nrespue = rev.nrespue
         and repu.cestado = '1'
       inner join acdprre prre
          on prre.npreres = repu.npreres
         and prre.cestado = '1'
       inner join acdresu resu
          on resu.ncodres = prre.ncodres
         and resu.cestado = '1'
       inner join acmoper usu
          on usu.ccodope = rev.cusucre
       where eva.cnumdoc = trim(ps_numdoc)
         and eva.ntipdoc = ln_tipdoc
         and eva.npaicli = ps_codpai
         and repu.nrescod = 4
       order by rev.dfecvis desc;
  end sp_hiscli;

  procedure sp_elibus(ps_coding varchar2,
                      ps_codact varchar2,
                      ps_codbas varchar2,
                      ps_nomusu varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_elibus
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Elimina las busquedas de agendar que tengan estado 3
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    delete acdbase
     where cusuing = ps_nomusu
       and nidebas = 2
       and nidepro = 9
       and ncoding = ps_coding
       and ncodact = ps_codact
       and ncodbas = ps_codbas
       and cestado = 3;
    commit;
  end sp_elibus;

  procedure sp_insexc(ps_paicli varchar2,ps_tipdoc varchar2,ps_numdoc varchar2,ps_paicon varchar2,
                      ps_tipcon varchar2,ps_numcon varchar2,ps_nomcli varchar2,ps_zonfij varchar2,
                      ps_dirfij varchar2,ps_reffij varchar2,ps_zonneg varchar2,ps_dirneg varchar2,
                      ps_refneg varchar2,ps_telfij varchar2,ps_telmov varchar2,ps_nomage varchar2,
                      ps_codana varchar2,ps_usuing varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_insexc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Inserta los datos en bruto del excel.
    -- Estado                     : Activo
    -- Fecha Modificación         : 17/02/2021
    -- Autor de Modificación      : WCRW
    -- Descripcion Modificacion   : Validación función clientes ARCO
    -- ***************************************************************** 
   ln_ctlcli number;
  begin
    ln_ctlcli := fn_valcliARCO(trim(ps_paicli),trim(ps_tipdoc),trim(ps_numdoc),1);
    if ln_ctlcli = 1 then
       insert into actexce (npaicli,ntipdoc,cnumdoc,npaicon,ntipcon,cnumcon,cnomcli,czonfij,cdirfij,
                            creffij,czonneg,cdirneg,crefneg,ctelfij,ctelmov,cnomage,ccodana,nindpas,
                            cusuing,dfeccar)
       values
       (trim(ps_paicli),trim(ps_tipdoc),trim(ps_numdoc),trim(ps_paicon),trim(ps_tipcon),trim(ps_numcon),
        trim(ps_nomcli),trim(ps_zonfij),trim(ps_dirfij),trim(ps_reffij),trim(ps_zonneg),trim(ps_dirneg),
        trim(ps_refneg),trim(ps_telfij),trim(ps_telmov),trim(ps_nomage),trim(ps_codana),'0',
        trim(ps_usuing),sysdate);
       commit;
    end if;   
  end sp_insexc;

  procedure sp_exctobas(ps_usuing varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_insexc
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 23/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Inserta los datos precargados de excel a la ACDBASE
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    insert into acdbase
      (nidebas,
       nidepro,
       ncoding,
       ncodact,
       ncodbas,
       cestado,
       nnumpas,
       ntipdoc,
       cnumdoc,
       npascon,
       ntipcon,
       cdoccon,
       cnombre,
       czonfij,
       cdirfij,
       creffij,
       czonneg,
       cdirneg,
       crefneg,
       ctelfij,
       ctelmov,
       ncodage,
       ncodana,
       cusuing,
       dfecing,
       ncodpri)
    
      select 3,
             9,
             5,
             4,
             4,
             '1',
             paicli.ncodpai,
             doccli.ccodatr,
             exc.cnumdoc,
             paicon.ncodpai,
             doccon.ccodatr,
             exc.cnumcon,
             exc.cnomcli,
             exc.czonfij,
             exc.cdirfij,
             exc.creffij,
             exc.czonneg,
             exc.cdirneg,
             exc.crefneg,
             exc.ctelfij,
             exc.ctelmov,
             suc.ncodsuc,
             exc.ccodana,
             exc.cusuing,
             sysdate,
             '1'
        from actexce exc
        left join actpais paicli
          on trim(paicli.nnompai) = exc.npaicli
        left join acdatri doccli
          on doccli.ncodtab = 6
         and doccli.ctipatr = 'D'
         and doccli.cdesatr = exc.ntipdoc
        left join actpais paicon
          on trim(paicon.nnompai) = exc.npaicon
        left join acdatri doccon
          on doccon.ncodtab = 6
         and doccon.ctipatr = 'D'
         and doccon.cdesatr = exc.ntipcon
        left join acmsucu suc
          on trim(suc.cnomsuc) = exc.cnomage
         and suc.ccodest = '1'
       where exc.nindpas = 0
         and exc.cusuing = ps_usuing;
    commit;
  
    update actexce
       set nindpas = '1'
     where nindpas = 0
       and cusuing = ps_usuing;
    commit;
  
    update acdbase
       set cestado = '2'
     where cnumdoc in (select cnumdoc
                         from acdeval
                        where ncodact = 4
                          and ncodbas = 4
                          and NINDCIER = '0');
  
    update acdbase
       set cestado = '2'
     where cnumdoc in (select cnumdoc
                         from acheval
                        where ncodact = 4
                          and ncodbas = 4
                          and NINDCIER = '0');
  
    commit;
    sp_exctoeva;
  end sp_exctobas;

  procedure sp_exctoeva as
    -- *****************************************************************
    -- Nombre                     : sp_exctoeva
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 23/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Inserta los datos de la base del excel a la acdeval
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
  
    declare
      ls_codana VARCHAR2(10);
      cursor lc_liscur is
        select bas.nidebas as a1,
               bas.nidepro as a2,
               bas.ncoding as a3,
               bas.ncodact as a4,
               bas.ncodbas as a5,
               bas.nnumpas as a6,
               bas.ntipdoc as a7,
               bas.cnumdoc as a8,
               bas.npascon as a9,
               bas.ntipcon as a10,
               bas.cdoccon as a11,
               bas.cnombre as a12,
               bas.czonfij as a13,
               bas.cdirfij as a14,
               bas.creffij as a15,
               bas.czonneg as a16,
               bas.cdirneg as a17,
               bas.crefneg as a18,
               bas.ctelfij as a19,
               bas.ctelmov as a20,
               bas.ncodage as a21,
               bas.ncodage as a22,
               bas.ncodana as a23,
               bas.cusuing as a24,
               sysdate     as a25
          from acdbase bas
         where bas.nidebas = 3
           and bas.nidepro = 9
           and bas.ncoding = 5
           and bas.ncodact = 4
           and bas.ncodbas = '4'
           and bas.cestado = '1';
    begin
      for v_reg in lc_liscur loop
        insert into acheval
          select *
            from acdeval eva
           where eva.npaicli = v_reg.a6
             and eva.ntipdoc = v_reg.a7
             and eva.cnumdoc = v_reg.a8;
        commit;
      
        delete acdeval eva
         where eva.npaicli = v_reg.a6
           and eva.ntipdoc = v_reg.a7
           and eva.cnumdoc = v_reg.a8;
        commit;
        ls_codana := v_reg.a23;
        if (ls_codana is null or ls_codana = '') then
          insert into acdeval
            (nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             npaicon,
             ntipcon,
             cdoccon,
             cclinom,
             czonfij,
             cdirfij,
             creffij,
             czonneg,
             cdirneg,
             crefneg,
             ctelfij,
             ctelmov,
             ncodage,
             nagepre,
             cusuing,
             dfeceva,
             ccodest,
             ncorcli,
             ncodpri,
             ccodcal,
             nindcier)
          values
            (v_reg.a1,
             v_reg.a2,
             v_reg.a3,
             v_reg.a4,
             v_reg.a5,
             v_reg.a6,
             v_reg.a7,
             v_reg.a8,
             v_reg.a9,
             v_reg.a10,
             v_reg.a11,
             v_reg.a12,
             v_reg.a13,
             v_reg.a14,
             v_reg.a15,
             v_reg.a16,
             v_reg.a17,
             v_reg.a18,
             v_reg.a19,
             v_reg.a20,
             v_reg.a21,
             v_reg.a22,
             v_reg.a24,
             v_reg.a25,
             '1',
             SEQ_CORCLI.NEXTVAL,
             1,
             '1',
             0);
          commit;
        else
        
          insert into acdeval
            (nidebas,
             nidepro,
             ncoding,
             ncodact,
             ncodbas,
             npaicli,
             ntipdoc,
             cnumdoc,
             npaicon,
             ntipcon,
             cdoccon,
             cclinom,
             czonfij,
             cdirfij,
             creffij,
             czonneg,
             cdirneg,
             crefneg,
             ctelfij,
             ctelmov,
             ncodage,
             nagepre,
             cusuing,
             dfeceva,
             ccodest,
             ncorcli,
             ncodpri,
             ccodcal,
             nindcier)
          values
            (v_reg.a1,
             v_reg.a2,
             v_reg.a3,
             v_reg.a4,
             v_reg.a5,
             v_reg.a6,
             v_reg.a7,
             v_reg.a8,
             v_reg.a9,
             v_reg.a10,
             v_reg.a11,
             v_reg.a12,
             v_reg.a13,
             v_reg.a14,
             v_reg.a15,
             v_reg.a16,
             v_reg.a17,
             v_reg.a18,
             v_reg.a19,
             v_reg.a20,
             v_reg.a21,
             v_reg.a22,
             v_reg.a24,
             v_reg.a25,
             '2',
             SEQ_CORCLI.NEXTVAL,
             1,
             '1',
             0);
          commit;
          insert into achasig
            select nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   cestado,
                   sysdate,
                   dfecasi,
                   ccodusu,
                   cusuasi,
                   chorasi,
                   cusumod,
                   dfecmod,
                   nindasi,
                   ncorcli,
                   ncorasi
              from acdasig
             where ncodact = v_reg.a4
               and npaicli = v_reg.a6
               and ntipdoc = v_reg.a7
               and cnumdoc = v_reg.a8;
          commit;
        
          delete acdasig
           where ncodact = v_reg.a4
             and npaicli = v_reg.a6
             and ntipdoc = v_reg.a7
             and cnumdoc = v_reg.a8;
          commit;
          insert into acdasig
            select nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   to_char(sysdate, 'yyyy/mm/dd'),
                   v_reg.a23,
                   v_reg.a24,
                   to_char(sysdate, 'hh24:mi:ss'),
                   v_reg.a24,
                   sysdate,
                   0,
                   ncorcli,
                   SEQ_CORASI.NEXTVAL
              from acdeval
             where ncodact = v_reg.a4
               and npaicli = v_reg.a6
               and ntipdoc = v_reg.a7
               and cnumdoc = v_reg.a8;
          commit;
        
        end if;
      end LOOP;
    end;
  
    update acdbase
       set cestado = '2'
     where nidebas = 3
       and nidepro = 9
       and ncoding = 5
       and ncodact = 4
       and ncodbas = 4
       and cestado = '1';
    commit;
  
  end sp_exctoeva;

  procedure sp_lisusuage(ps_codsuc number, lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusuage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/13/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de usuarios separado por comas
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_numreg number;
  begin
    select count(*)
      into ln_numreg
      from acmsucu
     where ccodest = '1'
       and ncodsuc = ps_codsuc;
  
    if ln_numreg > 0 then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and p.ccodest = '1'
         where c.ncodsuc = p.ncodsuc
           and c.ncodsuc = ps_codsuc
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    else
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = '1'
         where c.ncodsuc = p.ncodsuc
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    end if;
  end sp_lisusuage;

  procedure sp_lisusutran(ps_codsuc varchar,
                          lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusutran
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/13/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Lista de usuarios para transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  
  begin
  
    open lc_liscur for
    /*\*    select ope.ccodope,cnomope 
              from acmoper ope
            left join acdagus pue
                on pue.ccodope = ope.ccodope
               and pue.ccodest = '1'
             where ope.ccodjef = upper(ps_codsuc)
                or ope.ccodsup =  upper(ps_codsuc)
                or ope.ccodope = upper(ps_codsuc)*\
            select * from (select ccodope,cnomope from acmoper 
             where ccodope=upper(ps_codsuc) and ccodest = '1'
             union 
            SELECT ccodope,cnomope
              FROM acmoper 
            START WITH ccodjef =upper(ps_codsuc) or ccodsup = upper(ps_codsuc)
            CONNECT BY PRIOR ccodope = ccodjef
          ) order by 2;*/
      select *
        from (select ccodope, cnomope
                from acmoper
               where ccodope = upper(ps_codsuc)
                 and ccodest = '1'
              union
              SELECT ccodope, cnomope
                FROM acmoper
               START WITH ccodjef = upper(ps_codsuc)
                       or ccodope in
                          (select ccodope
                             from acmoper
                            where ccodsup = upper(ps_codsuc))
              CONNECT BY PRIOR ccodope = ccodjef)
       order by 2;
  
  end sp_lisusutran;

  procedure sp_repcliven(ps_nomusu varchar2,
                         lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_repcliven
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/03/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Reporte de clientes vencidos Excel
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  
  begin
    open lc_liscur for
      select tip.cdesatr as Tipo,
             age.cnumdoc,
             eva.cclinom,
             coalesce(eva.cdirneg, eva.cdirfij) as cdirfij,
             coalesce(eva.ctelneg, eva.ctelfij, eva.ctelmov) as fono,
             age.dfecvis as fecage
        from acdagen age
       inner join acdeval eva
          on eva.cnumdoc = age.cnumdoc
         and eva.ntipdoc = age.ntipdoc
         and eva.npaicli = age.npaicli
       inner join acdatri tip
          on tip.ncodtab = 6
         and tip.ccodatr = eva.ntipdoc
       where upper(trim(ccodusu)) = upper(ps_nomusu)
         and dfecvis < sysdate
         and age.cestado = '1'
       order by age.dfecvis;
  
  end sp_repcliven;

  procedure sp_repclispro(ps_nomusu varchar2,
                          lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_repclispro
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/03/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Reporte de clientes sin programacion excel
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  
  begin
    open lc_liscur for
      select asi.cnumdoc,
             eva.cclinom,
             coalesce(eva.cdirneg, eva.cdirfij) as cdirfij,
             coalesce(eva.ctelneg, eva.ctelfij, eva.ctelmov) as fono,
             asi.dfecasi as fecasi,
             cal.cdesatr as cali
        from acdasig asi
       inner join acdeval eva
          on eva.cnumdoc = asi.cnumdoc
         and eva.ntipdoc = asi.ntipdoc
         and eva.npaicli = asi.npaicli
       inner join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.ccodatr = eva.ccodcal
         and cal.cestado = '1'
       where trim(upper(cusuasi)) = trim(ps_nomusu)
         and asi.cestado = '1'
       order by asi.dfecasi;
  end sp_repclispro;

  procedure sp_repcliges(ps_nomusu varchar2,
                         ps_fecini varchar2,
                         ps_fecfin varchar2,
                         lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_repcliges
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/03/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Reporte de clientes sin programacion excel
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select distinct eva.cnumdoc,
                      eva.cclinom as nomcli,
                      asi.dfecasi,
                      eva.cdestcre,
                      eva.nmoneva,
                      tipeva.cdesatr as calificacion,
                      case
                        when asi.cestado = '1' then
                         'Usuario Asignado'
                        when asi.cestado = '2' and age.cestado = '1' then
                         'Usuario Agendado'
                        when asi.cestado = '2' and age.cestado = '2' then
                         'Usuario por Visitar'
                        when age.cestado = '3' then
                         'Cliente para desembolsar'
                        else
                         '0'
                      end as desblo
        from acdeval eva
       inner join acdatri tipeva
          on tipeva.ncodtab = 5
         and tipeva.ctipatr = 'D'
         and tipeva.ccodatr = eva.ccodcal
        left join acdasig asi
          on eva.cnumdoc = asi.cnumdoc
         and eva.ntipdoc = asi.ntipdoc
         and eva.npaicli = asi.npaicli
         and eva.ncoding = asi.ncoding
         and eva.ncodact = asi.ncodact
         and eva.ncodbas = asi.ncodbas
        left join acdagen age
          on eva.cnumdoc = age.cnumdoc
         and eva.ntipdoc = age.ntipdoc
         and eva.npaicli = age.npaicli
         and eva.ncoding = age.ncoding
         and eva.ncodact = age.ncodact
         and eva.ncodbas = age.ncodbas
        left join actbase atb
          on atb.ncodbas = eva.ncodbas
         and atb.ncodact = eva.ncodact
        left join acdrevi rev
          on rev.npaicli = eva.npaicli
         and rev.ntipdoc = eva.ntipdoc
         and rev.cnumdoc = eva.cnumdoc
         and rev.ncodact = eva.ncodact
         and rev.ncodbas = eva.ncodbas
         and rev.ncoding = eva.ncoding
       where (age.cestado = '3' or asi.cestado in ('1', '2', '3'))
         and TRIM(UPPER(asi.ccodusu)) = ps_nomusu
         and to_date(asi.dfecasi, 'yyyy/mm/dd') between
             to_date(ps_fecini, 'yyyy/mm/dd') and
             to_date(ps_fecfin, 'yyyy/mm/dd')
       order by asi.dfecasi;
  end sp_repcliges;

  procedure sp_indmicalendario(ps_nomusu varchar2, ps_indmen out varchar2)
  
    -- *****************************************************************
    -- Nombre                     : sp_indmicalendario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24/03/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Identificador si ingresa a la pantalla mi calendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ln_numcar number;
  begin
  
    select ccodcar
      into ln_numcar
      from acmoper
     where ccodope = upper(ps_nomusu)
       and ccodest = '1';
  
    select count(*)
      into ps_indmen
      from actmero
     where ccodmen = '00000026'
       and ncodrol = ln_numcar
       and ccodest = '1';
  end sp_indmicalendario;

  procedure sp_datosusuario(ps_nomusu varchar2,
                            ps_desusu out varchar2,
                            ps_nomage out varchar2)
  
    -- *****************************************************************
    -- Nombre                     : sp_datosusuario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/03/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra en texto el nombre y agencia del usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
  
    select ope.cnomope, age.cnomsuc
      into ps_desusu, ps_nomage
      from acmoper ope
     inner join acdagus pue
        on pue.ccodope = ope.ccodope
       and pue.ccodest = '1'
     inner join acmsucu age
        on age.ncodsuc = pue.ncodsuc
       and age.ccodest = '1'
     where ope.ccodope = upper(trim(ps_nomusu))
       and ope.ccodest = '1'
       and rownum = 1;
  
  end sp_datosusuario;

  procedure sp_liscalendariov2(ps_codana varchar2,
                               ps_fecini varchar2,
                               ps_fecfin varchar2,
                               ps_numdoc varchar2,
                               ps_indpen varchar2,
                               ps_codusu varchar2,
                               lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_liscalendariov2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 09/12/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista del calendario por analista version 2
    -- Estado                     : Activo
    -- Fecha Modificación         : 02/12/2024
    -- Autor de Modificación      : FPINTO
    -- Descripcion Modificacion   : Se añade campos de analista y se corrigen datos.
    -- *****************************************************************  
   as
    ld_fecini date;
    ld_fecfin date;
    ls_indpen char(1);
    ls_codana CHAR(10);
    ls_codtip char(1);
    ls_codcar number;
  begin
     if (ps_indpen = 'OFF') then
        ls_indpen := null;
     else
        ls_indpen := '1';
     end if;
     if (ps_numdoc <> 'DNI') then
        ls_codana := upper(ps_codana);
        select case when rol.ntodage = '1' and rol.ntodusu = '1' then '1' else '0' end
          into ls_codtip
          from acmoper ope
         inner join acdrole rol
            on ope.ccodcar = rol.ncodrol
         where ccodope = ps_codusu;
         if (ls_codtip = '1') then
            open lc_liscur for
            select distinct tabla.*,fn_datovisitas(tabla.cnumdoc) as cresvis,rank() over(order by fecha desc)
            --select distinct tabla.*,fn_datovisitares(tabla.ncorage) as cresvis,rank() over(order by fecha desc)
              from (select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                           age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                           eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                           ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,
                           atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                           coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                      from acdeval eva
                    inner join acdasig asi
                        on asi.ncorcli = eva.ncorcli
                    inner join acdagen age
                        on age.ncorasi = asi.ncorasi
                    inner join actbase bas
                        on bas.ncodbas = eva.ncodbas
                       and bas.ncodact = eva.ncodact
                       and bas.cestado = 'A'
                     inner join actacti act
                        on act.ncodact = eva.ncodact
                       and act.cestado = 'A'
                     left join achrevi res
                        on res.ncorage = age.ncorage
                     left join acdatri atr
                        on eva.ntipdoc = atr.ccodatr
                       and atr.cestado = '1'
                       and atr.ncodtab = 6
                     left join actugeo ubi
                        on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                     left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                     where eva.cnumdoc = ps_numdoc
                       and age.cestado = coalesce(ls_indpen, age.cestado)
                       and age.ncorasi not in (select distinct ncorasi
                                                 from achagen
                                                where ncorage in (select ncorage
                                                                    from acdrevi
                                                                   where nrespue = 148))
                    union all
                    select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                           age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                           eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                           ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,
                           atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                           coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                      from acdeval eva
                    inner join acdasig asi
                        on asi.ncorcli = eva.ncorcli
                    inner join acdagen age
                        on age.ncorasi = asi.ncorasi
                    inner join actacti act
                        on act.ncodact = eva.ncodact
                       and act.cestado = 'A'
                    inner join actbase bas
                        on bas.ncodbas = eva.ncodbas
                       and bas.ncodact = eva.ncodact
                       and bas.cestado = 'A'
                    left join acdrevi res
                        on res.ncorage = age.ncorage
                    left join acdatri atr
                        on eva.ntipdoc = atr.ccodatr
                       and atr.cestado = '1'
                       and atr.ncodtab = 6
                    left join actugeo ubi
                        on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                     where eva.cnumdoc = ps_numdoc
                       and age.cestado = coalesce(ls_indpen, age.cestado)
                       and age.ncorasi not in (select distinct ncorasi
                                                 from achagen
                                                where ncorage in (select ncorage
                                                                    from acdrevi
                                                                   where nrespue = 148))
                    union all
                    select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                           age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                           eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                           ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,'2',atr.cdesatr || ' ' || eva.cnumdoc,
                           eva.ncodact,age.ccodusu,
                           coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                      from acdeval eva
                    inner join acdasig asi
                        on asi.ncorcli = eva.ncorcli
                    inner join achagen age
                        on age.ncorasi = asi.ncorasi
                    inner join actbase bas
                        on bas.ncodbas = eva.ncodbas
                       and bas.ncodact = eva.ncodact
                       and bas.cestado = 'A'
                    inner join actacti act
                        on act.ncodact = eva.ncodact
                       and act.cestado = 'A'
                    left join achrevi res
                        on res.ncorage = age.ncorage
                    left join acdatri atr
                        on eva.ntipdoc = atr.ccodatr
                       and atr.cestado = '1'
                       and atr.ncodtab = 6
                    left join actugeo ubi
                        on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                     where eva.cnumdoc = ps_numdoc
                       and age.cestado = coalesce(ls_indpen, '2')
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,'2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc                      
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ncorasi not in (select distinct ncorasi
                                               from achagen
                                              where ncorage in (select ncorage
                                                                  from acdrevi
                                                                 where nrespue = 148))
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ncorasi not in (select distinct ncorasi
                                               from achagen
                                              where ncorage in (select ncorage
                                                                  from acdrevi
                                                                 where nrespue = 148))
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,'2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,'2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                  union all
                  select act.cnomact, bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ncorasi not in (select distinct ncorasi
                                               from achagen
                                              where ncorage in (select ncorage
                                                                  from acdrevi
                                                                 where nrespue = 148))
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,eva.cnumdoc,
                         eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' || eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ncorasi not in (select distinct ncorasi
                                               from achagen
                                              where ncorage in (select ncorage
                                                                  from acdrevi
                                                                 where nrespue = 148))
                  union all
                  select act.cnomact,bas.cnomact as cnombas,to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,age.ncorage,eva.npaicli,atr.cdesatr,
                         eva.cnumdoc,eva.cclinom,eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,--age.cestado,
                         '2', atr.cdesatr || ' ' || eva.cnumdoc,eva.ncodact,age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                  
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro') as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  ----
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                  
                  ) tabla;
      
      else
      
        select ccodcar
          into ls_codcar
          from acmoper
         where ccodope = ps_codusu;
      
        open lc_liscur for
          select distinct tabla.*,fn_datovisitares(tabla.ncorage) as cresvis,rank() over(order by fecha desc)
          --select distinct tabla.*,rank() over(order by fecha desc)
            from (select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2',
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acdeval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         --age.cestado,
                         '2',
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join acdasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro') as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join acdagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                     and age.ncorasi not in
                         (select distinct ncorasi
                            from achagen
                           where ncorage in (select ncorage
                                               from acdrevi
                                              where nrespue = 148))
                  union all
                  ----
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join achrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, '2')
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  union all
                  
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis, 'YYYY/MM/DD') || ' ' ||
                         age.chorvis as fecha,
                         age.ncorage,
                         eva.npaicli,
                         atr.cdesatr,
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' ' ||
                         eva.ctelmov,
                         ubi.cdespro || '/ ' || ubi.cdesdis as cdesdis,
                         '2', --age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact,
                         age.ccodusu,
                         coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                    from acheval eva
                   inner join achasig asi
                      on asi.ncorcli = eva.ncorcli
                   inner join achagen age
                      on age.ncorasi = asi.ncorasi
                   inner join actbase bas
                      on bas.ncodbas = eva.ncodbas
                     and bas.ncodact = eva.ncodact
                     and bas.cestado = 'A'
                   inner join actacti act
                      on act.ncodact = eva.ncodact
                     and act.cestado = 'A'
                    left join acdrevi res
                      on res.ncorage = age.ncorage
                    left join acdatri atr
                      on eva.ntipdoc = atr.ccodatr
                     and atr.cestado = '1'
                     and atr.ncodtab = 6
                    left join actugeo ubi
                      on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
                    left join acdagus agus 
                        on trim(eva.ncodana) = trim(agus.ccodope)
                     left join acmsucu sucu 
                        on sucu.ncodsuc = agus.ncodsuc
                   where eva.cnumdoc = ps_numdoc
                     and age.cestado = coalesce(ls_indpen, age.cestado)
                     and age.ccodusu in
                         ((select cast(ccodope as char(10))
                             from (select ccodope
                                     from acmoper
                                    where ccodope = ps_codusu)
                           union
                           
                           SELECT cast(ccodope as char(10))
                             FROM acmoper
                            START WITH ccodjef = ps_codusu
                                    or ccodsup = ps_codusu
                           CONNECT BY PRIOR ccodope = ccodjef) union select
                          cast(ccodope as char(10)) from acmoper where
                          ccodcar in (select ncarsub
                                        from acpcarg
                                       where ncarjef = ls_codcar))
                  
                  ) tabla;
      end if;
    else
      ld_fecini := to_date(ps_fecini, 'YYYY-MM-DD');
      ld_fecfin := to_date(ps_fecfin, 'YYYY-MM-DD');
      ls_codana := upper(ps_codana);
      open lc_liscur for
      /*select  \*+ NO_CPU_COSTING *\ distinct tabla.*,rank() over(order by fecha desc) from (
                 select act.cnomact,
                 bas.cnomact as cnombas,
                 to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                 age.ncorage, 
                  eva.npaicli,
                  atr.cdesatr,     
                  eva.cnumdoc,
                  eva.cclinom,
                  eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                  ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                  age.cestado,
                  atr.cdesatr || ' ' || eva.cnumdoc,
                  eva.ncodact
                  from (
                       select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                         union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join acdasig asi
                        on asi.ncorcli = eva.ncorcli
                  inner join acdagen age
                        on age.ncorasi = asi.ncorasi
                  inner join actbase bas
                        on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  inner join actacti act
                        on act.ncodact = eva.ncodact and act.cestado = 'A'
                  left join achrevi res
                       on res.ncorage = age.ncorage
                  left join acdatri atr
                       on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                       on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij)
                  where age.ccodusu= ls_codana
                    and age.dfecvis = ld_fecini
                    and age.cestado = coalesce(ls_indpen,age.cestado)
                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                  union all
                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  select act.cnomact,
                          bas.cnomact as cnombas,
                          to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                          age.ncorage, 
                          eva.npaicli,
                          atr.cdesatr,     
                          eva.cnumdoc,
                          eva.cclinom,
                          eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join acdasig
                   asi
                    on asi.ncorcli = eva.ncorcli
                  inner join acdagen age
                   on age.ncorasi = asi.ncorasi
                  inner join actbase bas
                   on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  inner join actacti act
                   on act.ncodact = eva.ncodact and act.cestado = 'A'
                  left join acdrevi res
                   on res.ncorage = age.ncorage
                  left join acdatri atr
                    on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                   on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij) 
                   where age.ccodusu=ls_codana
                     and age.dfecvis = ld_fecini 
                     and age.cestado = coalesce(ls_indpen,age.cestado)
                  union all
                  ----
                                                                                                                                                                                                                                                                                                                                                                                                                              
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                         age.ncorage, 
                         eva.npaicli,
                         atr.cdesatr,     
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         '2',--age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join acdasig
                   asi
                    on asi.ncorcli = eva.ncorcli
                  inner join achagen age
                   on age.ncorasi = asi.ncorasi
                  inner join actacti act
                   on act.ncodact = eva.ncodact and act.cestado = 'A'
                  inner join actbase bas
                   on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  left join achrevi res
                   on res.ncorage = age.ncorage
                  left join acdatri atr
                    on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                   on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij)
                    where age.ccodusu=ls_codana
                     and age.dfecvis = ld_fecini
                     and age.cestado = coalesce(ls_indpen,'2')
                   union all
                                                                                                                                                                                                                                                                                                                                                                                                                              
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                         age.ncorage, 
                         eva.npaicli,
                         atr.cdesatr,     
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         '2',--age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join acdasig
                   asi
                    on asi.ncorcli = eva.ncorcli
                  inner join achagen age
                   on age.ncorasi = asi.ncorasi
                  inner join actbase bas
                   on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  inner join actacti act
                   on act.ncodact = eva.ncodact and act.cestado = 'A'
                  left join acdrevi res
                   on res.ncorage = age.ncorage
                  left join acdatri atr
                    on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                   on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij) 
                   where age.ccodusu=ls_codana
                     and age.dfecvis = ld_fecini
                     and age.cestado = coalesce(ls_indpen,'2') 
                  ----------------------------------------------
                  union all
                                                                                                                                                                                                                                                                                                                                                                                                                              
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                         age.ncorage, 
                         eva.npaicli,
                         atr.cdesatr,     
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join achasig
                   asi
                    on asi.ncorcli = eva.ncorcli
                  inner join acdagen age
                   on age.ncorasi = asi.ncorasi
                  inner join actbase bas
                   on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  inner join actacti act
                   on act.ncodact = eva.ncodact and act.cestado = 'A'
                  left join achrevi res
                   on res.ncorage = age.ncorage
                  left join acdatri atr
                    on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                   on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij)
                    where age.ccodusu=ls_codana
                     and age.dfecvis = ld_fecini
                     and age.cestado = coalesce(ls_indpen,age.cestado)  
                   union all
                                                                                                                                                                                                                                                                                                                                                                                                                              
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                         age.ncorage, 
                         eva.npaicli,
                         atr.cdesatr,     
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join achasig
                   asi
                    on asi.ncorcli = eva.ncorcli
                  inner join acdagen age
                   on age.ncorasi = asi.ncorasi
                  inner join actbase bas
                   on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                  inner join actacti act
                   on act.ncodact = eva.ncodact and act.cestado = 'A'
                  left join acdrevi res
                   on res.ncorage = age.ncorage
                  left join acdatri atr
                    on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                  left join actugeo ubi
                   on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij) 
                    where age.ccodusu=ls_codana
                     and age.dfecvis = ld_fecini
                     and age.cestado = coalesce(ls_indpen,age.cestado)
                  union all
                  ----
                                                                                                                                                                                                                                                                                                                                                                                                                              
                  select act.cnomact,
                         bas.cnomact as cnombas,
                         to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                         age.ncorage, 
                         eva.npaicli,
                         atr.cdesatr,     
                         eva.cnumdoc,
                         eva.cclinom,
                         eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                         ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                         '2',--age.cestado,
                         atr.cdesatr || ' ' || eva.cnumdoc,
                         eva.ncodact
                  from (
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                        union all
                        select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                  ) eva
                  inner join achasig
                   asi
                  on asi.ncorcli = eva.ncorcli
                inner join achagen age
                 on age.ncorasi = asi.ncorasi
                inner join actacti act
                 on act.ncodact = eva.ncodact and act.cestado = 'A'
                inner join actbase bas
                 on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                left join achrevi res
                 on res.ncorage = age.ncorage
                left join acdatri atr
                  on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                left join actugeo ubi
                 on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij)
                  where age.ccodusu=ls_codana
                   and age.dfecvis = ld_fecini
                   and age.cestado = coalesce(ls_indpen,'2')  
                 union all
                                                                                                                                                                                                                                                                                                                                                                                                                              
                select act.cnomact,
                       bas.cnomact as cnombas,
                       to_char(age.dfecvis,'YYYY/MM/DD') || ' ' || age.chorvis as fecha,
                       age.ncorage, 
                       eva.npaicli,
                       atr.cdesatr,     
                       eva.cnumdoc,
                       eva.cclinom,
                       eva.ctelneg || ' ' || eva.ctelfij || ' '|| eva.ctelmov,
                       ubi.cdespro ||'/ ' ||ubi.cdesdis as cdesdis,
                       '2',--age.cestado,
                       atr.cdesatr || ' ' || eva.cnumdoc,
                       eva.ncodact
                from (
                      select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acdeval
                      union all
                      select ncorcli,ncodbas,npaicli,ntipdoc,cnumdoc,cclinom,ctelneg,ctelfij,czonneg,czonfij,ctelmov,ncodact from acheval
                ) eva
                inner join achasig
                 asi
                  on asi.ncorcli = eva.ncorcli
                inner join achagen age
                 on age.ncorasi = asi.ncorasi
                inner join actacti act
                 on act.ncodact = eva.ncodact and act.cestado = 'A'
                inner join actbase bas
                 on bas.ncodbas = eva.ncodbas and bas.ncodact = eva.ncodact and bas.cestado = 'A'
                left join acdrevi res
                 on res.ncorage = age.ncorage
                left join acdatri atr
                  on eva.ntipdoc = atr.ccodatr and atr.cestado = '1' and atr.ncodtab = 6
                left join actugeo ubi
                 on ubi.cubigeo = coalesce (eva.czonneg,eva.czonfij) 
                  where age.ccodusu=ls_codana
                   and age.dfecvis = ld_fecini
                   and age.cestado = coalesce(ls_indpen,'2')
                 ) tabla;*/
        SELECT /*+ NO_CPU_COSTING */
        DISTINCT TABLA.*,fn_datovisitas(tabla.cnumdoc) as cresvis,RANK() OVER(ORDER BY FECHA DESC)
          FROM (SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACDASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu, coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       AGE.CESTADO,
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACDAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACHREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACDEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                UNION ALL
                SELECT ACT.CNOMACT,
                       BAS.CNOMACT AS CNOMBAS,
                       TO_CHAR(AGE.DFECVIS, 'YYYY/MM/DD') || ' ' ||
                       AGE.CHORVIS AS FECHA,
                       AGE.NCORAGE,
                       EVA.NPAICLI,
                       ATR.CDESATR,
                       EVA.CNUMDOC,
                       EVA.CCLINOM,
                       EVA.CTELNEG || ' ' || EVA.CTELFIJ || ' ' ||
                       EVA.CTELMOV,
                       UBI.CDESPRO || '/ ' || UBI.CDESDIS AS CDESDIS,
                       '2',
                       ATR.CDESATR || ' ' || EVA.CNUMDOC,
                       EVA.NCODACT,
                       age.ccodusu,coalesce(trim(trim(eva.ncodana) ||' '|| trim(sucu.cnomsuc)),'No hay registro')  as cusuage
                  FROM ACHEVAL EVA
                 INNER JOIN ACHASIG ASI
                    ON ASI.NCORCLI = EVA.NCORCLI
                 INNER JOIN ACHAGEN AGE
                    ON AGE.NCORASI = ASI.NCORASI
                 INNER JOIN ACTACTI ACT
                    ON ACT.NCODACT = EVA.NCODACT
                   AND ACT.CESTADO = 'A'
                 INNER JOIN ACTBASE BAS
                    ON BAS.NCODBAS = EVA.NCODBAS
                   AND BAS.NCODACT = EVA.NCODACT
                   AND BAS.CESTADO = 'A'
                  LEFT JOIN ACDREVI RES
                    ON RES.NCORAGE = AGE.NCORAGE
                  LEFT JOIN ACDATRI ATR
                    ON EVA.NTIPDOC = ATR.CCODATR
                   AND ATR.CESTADO = '1'
                   AND ATR.NCODTAB = 6
                  LEFT JOIN ACTUGEO UBI
                    ON UBI.CUBIGEO = COALESCE(EVA.CZONNEG, EVA.CZONFIJ)
                  left join acdagus agus 
                    on trim(eva.ncodana) = trim(agus.ccodope)
                  left join acmsucu sucu 
                    on sucu.ncodsuc = agus.ncodsuc
                 WHERE AGE.CCODUSU = ls_codana
                   AND AGE.DFECVIS >= ld_fecini
                   AND AGE.DFECVIS <= ld_fecfin
                   AND AGE.CESTADO = COALESCE(ls_indpen, AGE.CESTADO)
                ) TABLA;
    end if;
  end sp_liscalendariov2;

  procedure sp_montosolicitado(ps_codpai varchar2,
                               ps_codtip varchar2,
                               ps_numdoc varchar2,
                               ps_monsol out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_montosolicitado
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Monto Solicitado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
    ln_tipdoc number;
  begin
  
    select ccodatr
      into ln_tipdoc
      from acdatri
     where ncodtab = 6
       and ctipatr = 'D'
       and trim(cdesatr) = trim(ps_codtip);
  
    select nmoneva
      into ps_monsol
      from acdeval
     where cnumdoc = ps_numdoc
       and ntipdoc = ln_tipdoc
       and npaicli = ps_codpai;
  
  end sp_montosolicitado;

  procedure sp_rephojaruta(ps_codusu varchar2,
                           ps_fecrep varchar2,
                           ps_codpen varchar2,
                           lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_rephojaruta
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 04/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Hoja de ruta de un determinado usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select asi.cnumdoc,
             eva.cclinom,
             case
               when ubin.cdespro is not null then
                'Neg: ' || ubin.cdespro || ' - ' || ubin.cdesdis
               else
                ''
             end || ' ' || case
               when ubif.cdespro is not null then
                'Dom: ' || ubif.cdespro || ' - ' || ubif.cdesdis
               else
                ''
             end as ubigeo,
             case
               when eva.cdirneg is not null then
                'Neg: ' || eva.cdirneg
               else
                ''
             end || ' ' || case
               when eva.cdirfij is not null then
                'Dom: ' || eva.cdirfij
               else
                ''
             end as direccion,
             case
               when eva.crefneg is not null then
                'Neg: ' || eva.crefneg
               else
                ''
             end || ' ' || case
               when eva.creffij is not null then
                'Dom: ' || eva.creffij
               else
                ''
             end as referencia,
             case
               when eva.ctelneg is not null then
                'Neg: ' || eva.ctelneg
               else
                ''
             end || ' ' || case
               when eva.ctelfij is not null then
                'Dom: ' || eva.ctelfij
               else
                ''
             end || ' ' || case
               when eva.ctelmov is not null then
                'Mov: ' || eva.ctelmov
               else
                ''
             end as telefono,
             eva.nnument,
             age.dfecvis,
             res.cnomres,
             rev.cobserv,
             suc.cnomsuc,
             eva.ncodana as cusuvis
        from (select cnumdoc, npaicli, ntipdoc, ncorasi
                from acdasig
              union
              select cnumdoc, npaicli, ntipdoc, ncorasi
                from achasig) asi
       inner join acdeval eva
          on eva.npaicli = asi.npaicli
         and eva.ntipdoc = asi.ntipdoc
         and eva.cnumdoc = asi.cnumdoc
       inner join((select dfecvis, ncorasi, ncorage, cestado, ccodusu
                     from acdagen
                   union
                   select dfecvis, ncorasi, ncorage, cestado, ccodusu
                     from achagen)) age
          on asi.ncorasi = age.ncorasi
        left join actugeo ubin
          on ubin.cubigeo = coalesce(eva.czonneg, ' ')
        left join actugeo ubif
          on ubif.cubigeo = eva.czonfij
        left join (select * from acdrevi union select * from achrevi) rev
          on age.ncorage = rev.ncorage
        left join acdrepu repu
          on repu.nrespue = rev.nrespue
        left join acdprre prre
          on prre.npreres = repu.npreres
        left join acdresu res
          on res.ncodres = prre.ncodres
        left join acdagus agu
          on agu.ccodope = eva.ncodana
        left join acmsucu suc
          on suc.ncodsuc = agu.ncodsuc
       where age.cestado = case
               when ps_codpen = 'ON' then
                '1'
               else
                age.cestado
             end
         and upper(trim(age.ccodusu)) = upper(trim(ps_codusu))
         and to_date(age.dfecvis) = to_date(ps_fecrep, 'YYYY-MM-DD')
         and age.cestado in ('1', '2')
         and (repu.nrescod = '4' or repu.nrescod is null);
  
  end sp_rephojaruta;

  procedure sp_resnoprocede(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_resnoprocede
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Respuestas de opcion no procede
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select ncodres, cnomres
        from acdresu
       where cestado = '1'
         and ncodres in (84, 80);
  
  end sp_resnoprocede;

  procedure sp_repclienteasig(ps_codusu    varchar2,
                              ps_fecini    varchar2,
                              ps_fecfin    varchar2,
                              ps_codage    varchar2,
                              ps_codusuact varchar2,
                              lc_liscur    out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_repclienteasig
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reporte de Clientes ASignados
    -- Estado                     : Activo
    -- Fecha Modificación         : 29/09/2023
    -- Autor de Modificación      : Frank Pinto Carpio
    -- Descripcion Modificacion   : Cambio de Comando UNION por UNION ALL
    -- ***************************************************************** 
    ls_codusu    varchar2(10);
    ls_fecini    date;
    ls_fecfin    date;
    ls_fectem    date;
    ls_codage    number;
    ls_codtip    number;
    ls_codcar    number;
    ls_codusu2   char(10);
    ls_codusuact varchar2(10);
  begin
    ls_codusuact := trim(upper(ps_codusuact));
    select case
             when rol.ntodage = '1' and rol.ntodusu = '1' then
              '1'
             else
              '0'
           end
      into ls_codtip
      from acmoper ope
     inner join acdrole rol
        on ope.ccodcar = rol.ncodrol
     where ccodope = ls_codusuact;
  
    ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
    ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
  
    if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
    end if;
    if ps_codusu = 'NO' then
      ls_codusu := null;
    else
      ls_codusu := upper(trim(ps_codusu));
    end if;
    if ps_codage = '0' then
      ls_codage := null;
      ls_codusu := null;
    else
      ls_codage := ps_codage;
    end if;
    -- Muestra Todos  29/09/2023 fpinto se cambian los UNION por UNION ALL
    if (ls_codtip = '1' and ls_codage is null) then
      open lc_liscur for
        select distinct act.cnomact,
                        bas.cnomact,
                        eva.cusuing,
                        to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'),
                                'YYYY-MM-DD') as dfecasi,
                        age.cnomsuc,
                        asi.ccodusu,
                        eva.cnumdoc,
                        eva.cclinom,
                        eva.nmoneva,
                        tip.cdesatr as tipcli,
                        cal.cdesatr as calcli,
                        to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
                        case
                          when agen.cestado = 3 then
                           'DESEMBOLSADO'
                          when rev.nrespue is null then
                           'SIN ATENCION'
                          when resu.nindcas in (1) then
                           ' DENEGADO'
                          when resu.nindcas in (2, 5) then
                           ' EN GESTION'
                        end as estado
          from (select * from acdeval union all select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join (select dfecasi, ccodusu, ncorcli, ncorasi
                       from acdasig
                     union all
                     select dfecasi, ccodusu, ncorcli, ncorasi
                       from achasig) asi
            on asi.ncorcli = eva.ncorcli
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join (select cestado, ncorasi, ncorage
                       from acdagen
                     union all
                     select cestado, ncorasi, ncorage
                       from achagen) agen
            on agen.ncorasi = asi.ncorasi
          left join (select dfecvis, nrespue, ncorage
                       from acdrevi
                     union all 
                     select dfecvis, nrespue, ncorage
                       from achrevi) rev
            on rev.ncorage = agen.ncorage
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
         where to_date(dfecasi, 'YYYY/MM/DD') between ls_fecini and
               ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  
    -- Muestra toda la agencia
    if (ls_codtip = '1' and ls_codage is not null and ls_codusu is null) then
    
      open lc_liscur for
        select distinct act.cnomact,
                        bas.cnomact,
                        eva.cusuing,
                        to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'),
                                'YYYY-MM-DD') as dfecasi,
                        age.cnomsuc,
                        asi.ccodusu,
                        eva.cnumdoc,
                        eva.cclinom,
                        eva.nmoneva,
                        tip.cdesatr as tipcli,
                        cal.cdesatr as calcli,
                        to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
                        case
                          when agen.cestado = 3 then
                           'DESEMBOLSADO'
                          when rev.nrespue is null then
                           'SIN ATENCION'
                          when resu.nindcas in (1) then
                           ' DENEGADO'
                          when resu.nindcas in (2, 5) then
                           ' EN GESTION'
                        end as estado
          from (select * from acdeval union all select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join (select dfecasi, ccodusu, ncorcli, ncorasi
                       from acdasig
                     union all
                     select dfecasi, ccodusu, ncorcli, ncorasi
                       from achasig) asi
            on asi.ncorcli = eva.ncorcli
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join (select cestado, ncorasi, ncorage
                       from acdagen
                     union all
                     select cestado, ncorasi, ncorage
                       from achagen) agen
            on agen.ncorasi = asi.ncorasi
          left join (select dfecvis, nrespue, ncorage
                       from acdrevi
                     union all
                     select dfecvis, nrespue, ncorage
                       from achrevi) rev
            on rev.ncorage = agen.ncorage
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
         where pau.ncodsuc = ls_codage
           and to_date(dfecasi, 'YYYY/MM/DD') between ls_fecini and
               ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  
    -- Muestra solo un usuario
    if (ls_codtip = '1' and ls_codage is not null and ls_codusu is not null) then
      ls_codusu2 := upper(ls_codusu);
      open lc_liscur for
        select distinct act.cnomact,
                        bas.cnomact,
                        eva.cusuing,
                        to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'),
                                'YYYY-MM-DD') as dfecasi,
                        age.cnomsuc,
                        asi.ccodusu,
                        eva.cnumdoc,
                        eva.cclinom,
                        eva.nmoneva,
                        tip.cdesatr as tipcli,
                        cal.cdesatr as calcli,
                        to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
                        case
                          when agen.cestado = 3 then
                           'DESEMBOLSADO'
                          when rev.nrespue is null then
                           'SIN ATENCION'
                          when resu.nindcas in (1) then
                           ' DENEGADO'
                          when resu.nindcas in (2, 5) then
                           ' EN GESTION'
                        end as estado
          from (select * from acdeval union all select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join (select dfecasi, ccodusu, ncorcli, ncorasi
                       from acdasig
                     union all
                     select dfecasi, ccodusu, ncorcli, ncorasi
                       from achasig) asi
            on asi.ncorcli = eva.ncorcli
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join (select cestado, ncorasi, ncorage
                       from acdagen
                     union all
                     select cestado, ncorasi, ncorage
                       from achagen) agen
            on agen.ncorasi = asi.ncorasi
          left join (select dfecvis, nrespue, ncorage
                       from acdrevi
                     union all
                     select dfecvis, nrespue, ncorage
                       from achrevi) rev
            on rev.ncorage = agen.ncorage
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
         where pau.ncodsuc = ls_codage
           and asi.ccodusu = ls_codusu2
           and to_date(dfecasi, 'YYYY/MM/DD') between ls_fecini and
               ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  
    -- Todo los usuarios subordinados
    if (ls_codtip = '0' and ls_codusu is null) then
      select ccodcar
        into ls_codcar
        from acmoper
       where ccodope = ls_codusuact;
    
      open lc_liscur for
        select distinct act.cnomact,
                        bas.cnomact,
                        eva.cusuing,
                        to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'),
                                'YYYY-MM-DD') as dfecasi,
                        age.cnomsuc,
                        asi.ccodusu,
                        eva.cnumdoc,
                        eva.cclinom,
                        eva.nmoneva,
                        tip.cdesatr as tipcli,
                        cal.cdesatr as calcli,
                        to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
                        case
                          when agen.cestado = 3 then
                           'DESEMBOLSADO'
                          when rev.nrespue is null then
                           'SIN ATENCION'
                          when resu.nindcas in (1) then
                           ' DENEGADO'
                          when resu.nindcas in (2, 5) then
                           ' EN GESTION'
                        end as estado
          from (select * from acdeval union all select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join (select dfecasi, ccodusu, ncorcli, ncorasi
                       from acdasig
                     union all
                     select dfecasi, ccodusu, ncorcli, ncorasi
                       from achasig) asi
            on asi.ncorcli = eva.ncorcli
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join (select cestado, ncorasi, ncorage
                       from acdagen
                     union all
                     select cestado, ncorasi, ncorage
                       from achagen) agen
            on agen.ncorasi = asi.ncorasi
          left join (select dfecvis, nrespue, ncorage
                       from acdrevi
                     union all
                     select dfecvis, nrespue, ncorage
                       from achrevi) rev
            on rev.ncorage = agen.ncorage
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
         where asi.ccodusu in
               ((select cast(ccodope as char(10))
                  from (select ccodope
                          from acmoper
                         where ccodope = ls_codusuact)
                union all
                SELECT cast(ccodope as char(10))
                  FROM acmoper
                 START WITH ccodjef = ls_codusuact
                         or ccodsup = ls_codusuact
                CONNECT BY PRIOR ccodope = ccodjef))
           and to_date(dfecasi, 'YYYY/MM/DD') between ls_fecini and
               ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  
    if (ls_codtip = '0' and ls_codusu is not null) then
      ls_codusu2 := upper(ls_codusu);
      open lc_liscur for
        select distinct act.cnomact,
                        bas.cnomact,
                        eva.cusuing,
                        to_char(to_date(asi.dfecasi, 'YYYY/MM/DD'),
                                'YYYY-MM-DD') as dfecasi,
                        age.cnomsuc,
                        asi.ccodusu,
                        eva.cnumdoc,
                        eva.cclinom,
                        eva.nmoneva,
                        tip.cdesatr as tipcli,
                        cal.cdesatr as calcli,
                        to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
                        case
                          when agen.cestado = 3 then
                           'DESEMBOLSADO'
                          when rev.nrespue is null then
                           'SIN ATENCION'
                          when resu.nindcas in (1) then
                           ' DENEGADO'
                          when resu.nindcas in (2, 5) then
                           ' EN GESTION'
                        end as estado
          from (select * from acdeval union all select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join (select dfecasi, ccodusu, ncorcli, ncorasi
                       from acdasig
                     union all
                     select dfecasi, ccodusu, ncorcli, ncorasi
                       from achasig) asi
            on asi.ncorcli = eva.ncorcli
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join (select cestado, ncorasi, ncorage
                       from acdagen
                     union all
                     select cestado, ncorasi, ncorage
                       from achagen) agen
            on agen.ncorasi = asi.ncorasi
          left join (select dfecvis, nrespue, ncorage
                       from acdrevi
                     union all
                     select dfecvis, nrespue, ncorage
                       from achrevi) rev
            on rev.ncorage = agen.ncorage
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
         where asi.ccodusu = ls_codusu2
           and to_date(dfecasi, 'YYYY/MM/DD') between ls_fecini and
               ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  
  end sp_repclienteasig;

  procedure sp_repseguicliente(ps_codusu varchar2,
                               ps_fecini varchar2,
                               ps_fecfin varchar2,
                               ps_codage varchar2,
                               ps_codana varchar2,
                               lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_repseguicliente
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reporte de Seguimiento de Clientes
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codusu varchar2(10);
    ls_fecini date;
    ls_fecfin date;
    ls_fectem date;
    ls_codage number;
    ls_codcar number;
  begin
    ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
    ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
    select ccodcar
      into ls_codcar
      from acmoper
     where ccodope = upper(trim(ps_codana));
  
    if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
    end if;
  
    if ps_codage = '0' then
      ls_codage := null;
      ls_codusu := null;
    else
    
      if ps_codusu = 'NO' then
        ls_codusu := null;
      else
        ls_codusu := upper(trim(ps_codusu));
        select ncodsuc
          into ls_codage
          from acdagus
         where ccodope = upper(trim(ps_codusu));
      end if;
    
    end if;
  
    if ls_codage is null or ls_codusu is null then
      open lc_liscur for
         select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
               eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
               trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
               to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
               eva.nmoneva,eva.cactcli,
               coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
               desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
               to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
               to_char(eva.dfeceva,'HH24:MI:SS') as chorreg
          from (select * from acdeval union select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join acdasig asi
            on asi.npaicli = eva.npaicli
           and asi.ntipdoc = eva.ntipdoc
           and asi.cnumdoc = eva.cnumdoc
           and asi.ncodact = eva.ncodact
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join actregi zon
            on zon.ncodsuc = pau.ncodsuc    
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join acdagen agen
            on agen.npaicli = asi.npaicli
           and agen.ntipdoc = asi.ntipdoc
           and agen.cnumdoc = asi.cnumdoc
           and agen.ncodact = asi.ncodact
          left join acdrevi rev
            on rev.npaicli = agen.npaicli
           and rev.ntipdoc = agen.ntipdoc
           and rev.cnumdoc = agen.cnumdoc
           and rev.ncodact = agen.ncodact
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
          left join ACDDESE desem
            on desem.ncorcli = eva.ncorcli
          left join acdagus usin
            on upper(trim(eva.cusuing)) = usin.ccodope
           and usin.ccodest = '1'
          left join acmsucu sucing
            on sucing.ncodsuc = eva.NCODAGE
          left join acmoper oping
            on oping.ccodope = upper(trim(eva.cusuing))
          left join acdrole rolin
            on rolin.ncodrol = oping.ccodcar
          left join actregi regi
            on regi.ncodsuc = eva.NCODAGE
          left join actregi regd
            on regd.ncodsuc = desem.naosuc
         where trim(eva.cusuing) in
               (select ccodope
                  from (select ccodope, cnomope
                          from acmoper
                         where ccodope = trim(upper(ps_codana))
                        union
                        
                        SELECT ccodope, cnomope
                          FROM acmoper
                         START WITH ccodjef = trim(upper(ps_codana))
                                 or ccodsup = trim(upper(ps_codana))
                        CONNECT BY PRIOR ccodope = ccodjef)
                union
                select ccodope
                  from acmoper
                 where ccodcar in
                       (select ncarsub from acpcarg where ncarjef = ls_codcar))
           and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    else
      open lc_liscur for
        select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
               eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
               trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
               to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
               eva.nmoneva,eva.cactcli,
               coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
               desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
               to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
               to_char(eva.dfeceva,'HH24:MI:SS') as chorreg
          from (select * from acdeval union select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join acdasig asi
            on asi.npaicli = eva.npaicli
           and asi.ntipdoc = eva.ntipdoc
           and asi.cnumdoc = eva.cnumdoc
           and asi.ncodact = eva.ncodact
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join actregi zon
            on zon.ncodsuc = pau.ncodsuc  
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join acdagen agen
            on agen.npaicli = asi.npaicli
           and agen.ntipdoc = asi.ntipdoc
           and agen.cnumdoc = asi.cnumdoc
           and agen.ncodact = asi.ncodact
          left join acdrevi rev
            on rev.npaicli = agen.npaicli
           and rev.ntipdoc = agen.ntipdoc
           and rev.cnumdoc = agen.cnumdoc
           and rev.ncodact = agen.ncodact
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
          left join ACDDESE desem
            on desem.ncorcli = eva.ncorcli
          left join acdagus usin
            on upper(trim(eva.cusuing)) = usin.ccodope
           and usin.ccodest = '1'
          left join acmsucu sucing
            on sucing.ncodsuc = eva.NCODAGE
          left join acmoper oping
            on oping.ccodope = upper(trim(eva.cusuing))
          left join acdrole rolin
            on rolin.ncodrol = oping.ccodcar
          left join actregi regi
            on regi.ncodsuc = eva.NCODAGE
          left join actregi regd
            on regd.ncodsuc = desem.naosuc
         where trim(eva.cusuing) = trim(coalesce(ls_codusu, eva.cusuing))
              --and eva.ncodage = coalesce(ls_codage,eva.ncodage)
           and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
    
    end if;
  end sp_repseguicliente;

  procedure sp_lisusuagencia(ps_codage varchar2,
                             lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisusuagencia
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de los usuarios por Agencia
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    open lc_liscur for
      select ope.ccodope, ope.cnomope
        from acmoper ope
       inner join acdagus pue
          on pue.ccodope = ope.ccodope
       where pue.ncodsuc = ps_codage
         and ope.ccodest = '1'
       order by 2;
  
  end sp_lisusuagencia;

  procedure sp_eliminarcorreo(ps_corage varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_eliminarcorreo
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Elimina Correo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
    ln_tipdoc number;
  begin
  
    update acdagen set cestmsj = '1' where ncorage = ps_corage;
  
    commit;
  
  end sp_eliminarcorreo;

  procedure sp_misti_lisactbas(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisactbas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Actividad Base
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  begin
    open lc_liscur for
      select act.ncodact, act.cnomact, bas.ncodbas, bas.cnomact as cnombas
        from actacti act
       inner join actbase bas
          on bas.ncodact = act.ncodact
       where act.cestado = 'A'
         and bas.cestado = 'A'
       order by 1, 3;
  
  end sp_misti_lisactbas;

  procedure sp_misti_lisvis(ps_codact number,
                            ps_codbas number,
                            pd_fecvis varchar2,
                            pn_tiplis number,
                            ps_codusu varchar2,
                            lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de clientes por visitar en misti por usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    if pn_tiplis = 1 then
      open lc_liscur for
        select eva.npaicli,
               tip.cdesatr  as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               age.ncorage
          from acdagen age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join acdeval eva
            on eva.cnumdoc = age.cnumdoc
           and eva.ntipdoc = age.ntipdoc
           and eva.npaicli = age.npaicli
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
         where age.ncodact = ps_codact
           and age.ncodbas = ps_codbas
           and age.cestado = '1'
           and age.dfecvis = to_date(pd_fecvis, 'DD-MM-YYYY')
           and trim(age.ccodusu) = upper(ps_codusu);
    end if;
  
    if pn_tiplis = 2 then
    
      open lc_liscur for
        select eva.npaicli,
               tip.cdesatr  as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               0            as ncorage
          from acdasig age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join (select * from acdeval union select * from acheval) eva
            on eva.ncorcli = age.ncorcli
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
         where age.ncodact = ps_codact
           and age.ncodbas = ps_codbas
           and age.cestado = '1'
           and trim(age.ccodusu) = upper(ps_codusu);
    end if;
  
  end sp_misti_lisvis;

  procedure sp_misti_lisvisv2(ps_codact number,
                              ps_codbas number,
                              pd_fecvis varchar2,
                              pn_tiplis number,
                              ps_codusu varchar2,
                              ps_codubi varchar2,
                              lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de clientes por visitar en misti por usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codubi varchar2(6);
    ls_codusu varchar2(12);
  begin
  
    if pn_tiplis = 1 then
      if ps_codubi is null then
        ls_codubi := '000000';
      else
        ls_codubi := ps_codubi;
      end if;
    
      open lc_liscur for
        select act1.ncodact,
               act1.cnomact,
               bas1.ncodbas,
               bas1.cnomact as cnombas,
               eva.npaicli,
               tip.cdesatr as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               age.ncorage,
               to_char(age.dfecvis, 'DD-MM-YYYY') as dfecvis,
               age.chorvis,
               lat.clonneg as latitud,
               lat.clatneg as longitud
          from acdagen age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join actbase bas1
            on bas1.ncodbas = age.ncodbas
           and bas1.ncodact = age.ncodact
         inner join actacti act1
            on act1.ncodact = age.ncodact
         inner join acdeval eva
            on eva.cnumdoc = age.cnumdoc
           and eva.ntipdoc = age.ntipdoc
           and eva.npaicli = age.npaicli
           and eva.ncodact = age.ncodact
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
          left join ACDCDLL lat
            on lat.npaicli = age.npaicli
           and lat.ntipdoc = age.ntipdoc
           and lat.cnumdoc = age.cnumdoc
        
         where age.ncodact = case
                 when ps_codact = '0' then
                  age.ncodact
                 else
                  ps_codact
               end
           and age.ncodbas = case
                 when ps_codbas = '0' then
                  age.ncodbas
                 else
                  ps_codbas
               end
           and age.cestado = '1'
           and age.dfecvis = to_date(pd_fecvis, 'DD-MM-YYYY')
           and trim(age.ccodusu) = upper(ls_codusu)
           and trim(coalesce(eva.czonfij, eva.czonneg)) = case
                 when ls_codubi = '000000' then
                  trim(coalesce(eva.czonfij, eva.czonneg))
                 else
                  trim(ls_codubi)
               end;
    end if;
  
    if pn_tiplis = 2 then
    
      open lc_liscur for
        select act1.ncodact,
               act1.cnomact,
               bas1.ncodbas,
               bas1.cnomact as cnombas,
               eva.npaicli,
               tip.cdesatr  as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               0            as ncorage,
               null         as dfecvis,
               null         as chorvis,
               null         as latitud,
               null         as longitud
          from acdasig age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join (select * from acdeval union select * from acheval) eva
            on eva.ncorcli = age.ncorcli
         inner join actbase bas1
            on bas1.ncodbas = age.ncodbas
           and bas1.ncodact = age.ncodact
         inner join actacti act1
            on act1.ncodact = age.ncodact
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
         where age.ncodact = ps_codact
           and age.ncodbas = ps_codbas
           and age.cestado = '1'
           and trim(age.ccodusu) = upper(ls_codusu);
    end if;
  
  end sp_misti_lisvisv2;

  procedure sp_misti_lisvisv3(ps_codact number,
                              ps_codbas number,
                              pd_fecini varchar2,
                              pd_fecfin varchar2,
                              pn_tiplis number,
                              ps_codusu varchar2,
                              ps_codubi varchar2,
                              lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de clientes por visitar en misti por usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codubi varchar2(6);
    ls_codusu varchar2(12);
    ln_canreg number;
    ld_fecing date;
  begin
  
    select sysdate into ld_fecing from dual;
    ls_codusu := ps_codusu;
    if pn_tiplis = 1 then
      if ps_codubi is null then
        ls_codubi := '000000';
      else
        ls_codubi := ps_codubi;
      end if;
    
      open lc_liscur for
        select act1.ncodact,
               act1.cnomact,
               bas1.ncodbas,
               bas1.cnomact as cnombas,
               eva.npaicli,
               tip.cdesatr as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdesdep as cdepneg,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdesdep as cdepdom,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               age.ncorage,
               to_char(age.dfecvis, 'DD-MM-YYYY') as dfecvis,
               age.chorvis,
               lat.clatneg as latitud,
               lat.clonneg as longitud
        
          from acdagen age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join actbase bas1
            on bas1.ncodbas = age.ncodbas
           and bas1.ncodact = age.ncodact
         inner join actacti act1
            on act1.ncodact = age.ncodact
         inner join (select *
                       from acdeval
                      where nindcier = 0
                     union
                     select *
                       from acheval
                      where nindcier = 0) eva
            on eva.cnumdoc = age.cnumdoc
           and eva.ntipdoc = age.ntipdoc
           and eva.npaicli = age.npaicli
           and eva.ncodact = age.ncodact
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
          left join ACDCDLL lat
            on lat.npaicli = age.npaicli
           and lat.ntipdoc = age.ntipdoc
           and lat.cnumdoc = age.cnumdoc
        
         where age.ncodact = case
                 when ps_codact = '0' then
                  age.ncodact
                 else
                  ps_codact
               end
           and age.ncodbas = case
                 when ps_codbas = '0' then
                  age.ncodbas
                 else
                  ps_codbas
               end
           and age.cestado = '1'
           and age.dfecvis between to_date(pd_fecini, 'DD-MM-YYYY') and
               to_date(pd_fecfin, 'DD-MM-YYYY')
           and trim(age.ccodusu) = upper(ls_codusu)
           and trim(coalesce(eva.czonfij, eva.czonneg)) = case
                 when ls_codubi = '000000' then
                  trim(coalesce(eva.czonfij, eva.czonneg))
                 else
                  trim(ls_codubi)
               end
           and age.ncorasi not in
               (select distinct ncorasi
                  from achagen
                 where ncorage in
                       (select ncorage from acdrevi where nrespue = 148));
    end if;
  
    if pn_tiplis = 2 then
    
      open lc_liscur for
        select act1.ncodact,
               act1.cnomact,
               bas1.ncodbas,
               bas1.cnomact as cnombas,
               eva.npaicli,
               tip.cdesatr  as ctipdoc,
               eva.ntipdoc,
               eva.cnumdoc,
               eva.cclinom,
               ubin.cdesdep as cdepneg,
               ubin.cdespro as cproneg,
               ubin.cdesdis as cdisneg,
               ubid.cdesdep as cdepdom,
               ubid.cdespro as cprodom,
               ubid.cdesdis as cdisdom,
               age.ncorasi  as ncorage,
               null         as dfecvis,
               null         as chorvis,
               null         as latitud,
               null         as longitud
          from acdasig age
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = age.ntipdoc
           and tip.cestado = '1'
         inner join (select *
                       from acdeval
                      where nindcier = 0
                     union
                     select *
                       from acheval
                      where nindcier = 0) eva
            on eva.ncorcli = age.ncorcli
         inner join actbase bas1
            on bas1.ncodbas = age.ncodbas
           and bas1.ncodact = age.ncodact
         inner join actacti act1
            on act1.ncodact = age.ncodact
          left join actugeo ubid
            on ubid.cubigeo = eva.czonfij
          left join actugeo ubin
            on ubin.cubigeo = eva.czonneg
         where age.ncodact = ps_codact
           and age.ncodbas = ps_codbas
           and age.cestado = '1'
           and trim(age.ccodusu) = upper(ls_codusu);
    
      select count(*)
        into ln_canreg
        from acdasig age
       inner join acdatri tip
          on tip.ncodtab = 6
         and tip.ccodatr = age.ntipdoc
         and tip.cestado = '1'
       inner join (select *
                     from acdeval
                    where nindcier = 0
                   union
                   select *
                     from acheval
                    where nindcier = 0) eva
          on eva.ncorcli = age.ncorcli
       inner join actbase bas1
          on bas1.ncodbas = age.ncodbas
         and bas1.ncodact = age.ncodact
       inner join actacti act1
          on act1.ncodact = age.ncodact
        left join actugeo ubid
          on ubid.cubigeo = eva.czonfij
        left join actugeo ubin
          on ubin.cubigeo = eva.czonneg
       where age.ncodact = ps_codact
         and age.ncodbas = ps_codbas
         and age.cestado = '1'
         and trim(age.ccodusu) = upper(ls_codusu);
    
    end if;
    insert into actlgmi
    values
      (ps_codact,
       ps_codbas,
       pd_fecini,
       pd_fecfin,
       pn_tiplis,
       ps_codusu,
       ps_codubi,
       ld_fecing,
       sysdate,
       ln_canreg);
    commit;
  end sp_misti_lisvisv3;

  procedure sp_misti_cliage(pn_tipdoc number,
                            ps_numdoc varchar2,
                            lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_cliage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : datos del cliente agendado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    open lc_liscur for
      select eva.cclinom,
             eva.cnumdoc,
             eva.cdirneg,
             eva.crefneg,
             eva.cdirfij,
             eva.creffij,
             replace(replace(eva.ctelfij, ',', '|'), ';', '|') as ctelfij,
             replace(replace(eva.ctelneg, ',', '|'), ';', '|') as ctelneg,
             replace(replace(eva.ctelmov, ',', '|'), ';', '|') as ctelmov,
             age.dfecvis,
             age.chorvis,
             fn_ocupa_Cliente(eva.npaicli, eva.ntipdoc, eva.cnumdoc) as cocucli
        from (select *
                from acdeval
               where nindcier = '0'
              union
              select *
                from acheval
               where nindcier = '0') eva
       inner join acdasig asi
          on eva.ncorcli = asi.ncorcli
        left join acdagen age
          on age.ncorasi = asi.ncorasi
       where eva.ntipdoc = pn_tipdoc
         and eva.cnumdoc = ps_numdoc;
  end sp_misti_cliage;

  procedure sp_misti_lisres(ln_codact number,
                            lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisres
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de Reacciones
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    open lc_liscur for
      select res.ncodres,
             replace(replace(res.cnomres, 'C- ', ''), 'R- ', '') as cnomres,
             case
               when res.ncodres = 107 then
                1
               else
                res.nindcas
             end as nindcas,
             case
               when res.ncodres = 107 then
                1
               else
                0
             end as indcam
        from ACDRESU res
       inner join actrore pue
          on pue.ncodres = res.ncodres
         and pue.ccodest = '1'
       inner join actacre act
          on act.ncodres = res.ncodres
         and act.ccodest = '1'
       where res.cestado = '1'
         and pue.ncodrol = 200
         and act.ncodact = ln_codact
       order by case
                  when res.ncodres = 107 then
                   1
                  else
                   2
                end;
  end sp_misti_lisres;

  procedure sp_misti_lisresvis(pd_fecvis varchar2,
                               ps_codusu varchar2,
                               pn_cantot out number,
                               pn_caneje out number,
                               lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisresvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Resumen de resultado visitas Totales/Ejecutadas
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codusu varchar2(12);
  begin
    ls_codusu := upper(trim(ps_codusu));
    select coalesce(count(*), 0) as ncantot,
           coalesce(sum(case
                          when rev.nrespue is not null then
                           1
                          else
                           0
                        end), 0) as ncanres
      into pn_cantot, pn_caneje
      from acdagen age
      left join acdrevi rev
        on rev.ncorage = age.ncorage
      left join acdrepu rep
        on rep.nrespue = rev.nrespue
       and rep.cestado = '1'
       and rep.nrescod = 4
     where age.dfecvis = to_Date(pd_fecvis, 'dd-mm-yyyy')
       and trim(age.ccodusu) = ls_codusu;
  
    open lc_liscur for
      select ncorage, ntipdoc, cnumdoc, cclinom, cnomres
        from (select ROW_NUMBER() OVER(PARTITION BY age.ncorage ORDER BY age.ncorage DESC) a,
                     age.ncorage,
                     eva.ntipdoc,
                     eva.cnumdoc,
                     eva.cclinom,
                     replace(replace(resu.cnomres, 'C- ', ''), 'R- ', '') as cnomres
                from acdagen age
               inner join acdrevi rev
                  on rev.ncorage = age.ncorage
               inner join acdrepu rep
                  on rep.nrespue = rev.nrespue
                 and rep.cestado = '1'
                 and rep.nrescod = 4
               inner join (select npaicli, ntipdoc, cnumdoc, cclinom
                            from acdeval
                          union
                          select npaicli, ntipdoc, cnumdoc, cclinom
                            from acheval) eva
                  on eva.npaicli = age.npaicli
                 and eva.ntipdoc = age.ntipdoc
                 and eva.cnumdoc = age.cnumdoc
               inner join acdprre pre
                  on pre.npreres = rep.npreres
                 and pre.cestado = '1'
               inner join acdresu resu
                  on resu.ncodres = pre.ncodres
                 and resu.cestado = '1'
               where age.dfecvis = to_Date(pd_fecvis, 'dd-mm-yyyy')
                 and trim(age.ccodusu) = ls_codusu) b
       where a = 1;
  
  end sp_misti_lisresvis;

  function fn_misti_fecrep(pn_corage in number) return varchar is
    -- *****************************************************************
    -- Nombre                     : fn_misti_fecrep
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Fecha de la reprogramacion de la visita
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
  
    ls_fecrep varchar2(255);
  begin
    begin
      select rev.cobserv
        into ls_fecrep
        from acdrevi rev
       inner join acdrepu rep
          on rep.nrespue = rev.nrespue
         and rep.cestado = '1'
         and rep.nrescod = 6
       inner join acdresp res
          on res.nrescod = rep.nrescod
         and res.cestado = '1'
       inner join acdprre pre
          on pre.npreres = rep.npreres
         and pre.cestado = '1'
       inner join acdresu resu
          on resu.ncodres = pre.ncodres
         and resu.cestado = '1'
       where rev.ncorage = pn_corage;
    exception
      when others then
        ls_fecrep := null;
    end;
    return ls_fecrep;
  end fn_misti_fecrep;

  procedure sp_misti_detvis(pc_corage number,
                            lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_detvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Detalle del resultado de la visita
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    open lc_liscur for
      select act.cnomact,
             bas.cnomact as cnombas,
             replace(replace(resu.cnomres, 'C- ', ''), 'R- ', '') as cdesres,
             rev.cobserv,
             case
               when resu.nindcas = 2 then
                PQ_AGENDA_COMERCIAL.fn_misti_fecrep(pc_corage)
               else
                null
             end as drepvis,
             rev.dfecvis as dfecreg,
             rev.chorvis as dhorreg,
             age.dfecvis as dfecvis,
             age.chorvis as dhorvis,
             rev.ccodlon,
             rev.ccodlat
        from acdrevi rev
       inner join acdrepu rep
          on rep.nrespue = rev.nrespue
         and rep.cestado = '1'
         and rep.nrescod = 4
       inner join acdresp res
          on res.nrescod = rep.nrescod
         and res.cestado = '1'
       inner join acdprre pre
          on pre.npreres = rep.npreres
         and pre.cestado = '1'
       inner join acdresu resu
          on resu.ncodres = pre.ncodres
         and resu.cestado = '1'
       inner join actacti act
          on act.ncodact = rev.ncodact
       inner join actbase bas
          on bas.ncodbas = rev.ncodbas
         and bas.ncodact = rev.ncodact
       inner join acdagen age
          on age.ncorage = rev.ncorage
       where rev.ncorage = pc_corage;
  end sp_misti_detvis;

  procedure sp_lisresmodal(ln_codrol number,
                           ln_codact number,
                           lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisresmodal
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de resultados para modal
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    open lc_liscur for
      select res.ncodres, res.cnomres
        from ACDRESU res
       inner join actrore pue
          on pue.ncodres = res.ncodres
         and pue.ccodest = '1'
       inner join actacre act
          on act.ncodres = res.ncodres
         and act.ccodest = '1'
       where res.cestado = '1'
         and pue.ncodrol = ln_codrol
         and act.ncodact = ln_codact;
  end sp_lisresmodal;

  procedure sp_ubibases(ls_codusu varchar2,
                        lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_ubibases
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Ubigeo para filtro de bases
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    open lc_liscur for
      select distinct coalesce(czonneg, czonfij) as ccodubi,
                      ubi.cdespro || ' - ' || ubi.cdesdis as cdesubi
        from acdasig asi
       inner join actingr ing
          on ing.ncoding = asi.ncoding
       inner join actacti act
          on act.ncodact = asi.ncodact
       inner join acdeval eva
          on eva.npaicli = asi.npaicli
         and eva.ntipdoc = asi.ntipdoc
         and eva.ncorcli = asi.ncorcli
         and eva.cnumdoc = asi.cnumdoc
         and eva.nindcier = '0'
       inner join actbase bas
          on bas.ncodbas = asi.ncodbas
         and bas.ncodact = act.ncodact
       inner join acdatri doc
          on doc.ncodtab = 6
         and doc.ctipatr = 'D'
         and doc.ccodatr = eva.ntipdoc
         and doc.cestado = '1'
        left join actugeo ubi
          on ubi.cubigeo = coalesce(czonneg, czonfij)
       where upper(trim(ccodusu)) = upper(ls_codusu)
         and asi.cestado = '1'
       order by 2;
  end sp_ubibases;

  procedure sp_retcorage(ps_codpai varchar2,
                         ps_tipdoc varchar2,
                         ps_numdoc varchar2,
                         ps_codact varchar2,
                         ps_codusu varchar2,
                         lp_corage out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_retcorage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Retorna Corage
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codusu char(10);
  begin
    --ls_codusu := upper(ps_codusu);
    select ncorage
      into lp_corage
      from acdagen
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = trim(ps_numdoc)
       and ncodact = ps_codact;
  end sp_retcorage;

  procedure sp_retcorage(ps_codpai varchar2,
                         ps_tipdoc varchar2,
                         ps_numdoc varchar2,
                         ps_codact varchar2,
                         lp_corage out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_retcorage
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Retorna Corage
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codusu char(10);
  begin
  
    select ncorage into lp_corage
      from acdagen
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = trim(ps_numdoc)
       and ncodact = ps_codact;
  end sp_retcorage;

  procedure sp_lisagetran(ls_nomsuc varchar2,
                          ls_nomusu varchar2,
                          lc_liscur out types.cursor_type,
                          lp_corage out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_lisagetran
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de sucursales a transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_codrol number;
  begin
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = upper(ls_nomusu)
       and ccodest = '1';
  
    if ls_codrol in (6, 102, 108) then
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ncodsuc in (select pue.ncodsuc
                             from acmoper ope
                            inner join acdagus pue
                               on ope.ccodope = pue.ccodope
                            where ope.ccodest = '1')
         order by 2;
    
      select ncodsuc
        into lp_corage
        from (select ncodsuc, cnomsuc
                from acmsucu
               where ncodsuc in (select pue.ncodsuc
                                   from acmoper ope
                                  inner join acdagus pue
                                     on ope.ccodope = pue.ccodope
                                  where ope.ccodest = '1')
               order by 2) a
       where rownum = 1;
    
    end if;
    if ls_codrol in (50, 51, 52, 200, 201, 104, 103) then
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ncodsuc in
               (select pue.ncodsuc
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in (50, 51, 52, 200, 201, 104, 103))
         order by 2 desc;
      select ncodsuc
        into lp_corage
        from (select ncodsuc, cnomsuc
                from acmsucu
               where ncodsuc in
                     (select pue.ncodsuc
                        from acmoper ope
                       inner join acdagus pue
                          on ope.ccodope = pue.ccodope
                       where ope.ccodest = '1'
                         and ope.ccodcar in (50, 51, 52, 200, 201, 104, 103))
               order by 2) a
       where rownum = 1;
    
    end if;
  
    if ls_codrol in
       (202, 101, 8, 105, 107, 900, 11, 12, 671, 13, 14, 15, 16,17) then
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ncodsuc in
               (select pue.ncodsuc
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in
                       (202, 101, 8, 105, 107, 12, 11, 13, 14, 15, 16,17))
         order by 2;
    
      select ncodsuc
        into lp_corage
        from (select ncodsuc, cnomsuc
                from acmsucu
               where ncodsuc in
                     (select pue.ncodsuc
                        from acmoper ope
                       inner join acdagus pue
                          on ope.ccodope = pue.ccodope
                       where ope.ccodest = '1'
                         and ope.ccodcar in
                             (202, 101, 8, 105, 107, 12, 11, 13, 14, 15, 16,17))
               order by 2) a
       where rownum = 1;
    
    end if;
  
    if ls_codrol in (7, 10, 9) then
      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ncodsuc in
               (select pue.ncodsuc
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in (102, 7, 10, 9, 108))
         order by 2;
    
      select ncodsuc
        into lp_corage
        from (select ncodsuc, cnomsuc
                from acmsucu
               where ncodsuc in
                     (select pue.ncodsuc
                        from acmoper ope
                       inner join acdagus pue
                          on ope.ccodope = pue.ccodope
                       where ope.ccodest = '1'
                         and ope.ccodcar in (102, 7, 10, 9, 108))
               order by 2) a
       where rownum = 1;
    end if;
  end sp_lisagetran;

  procedure sp_lisusuagetran(ls_nomusu varchar2,
                             lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusuagetran
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/13/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de usuarios separado por comas para transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_codrol number;
  begin
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = upper(ls_nomusu)
       and ccodest = 1;
  
    if ls_codrol in (6) then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = 1
         where c.ncodsuc = p.ncodsuc
           and p.ccodope in (select ope.ccodope
                               from acmoper ope
                              inner join acdagus pue
                                 on ope.ccodope = pue.ccodope
                              where ope.ccodest = '1'
                                and pue.ccodest = 1
                                and rownum < 1000)
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    
    end if;
    if ls_codrol in (50, 51, 52, 200, 201, 104, 103) then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = 1
         where c.ncodsuc = p.ncodsuc
           and p.ccodope in
               (select ope.ccodope
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in (50, 51, 52, 200, 201, 104, 103)
                   and ope.ccodest = 1)
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    end if;
  
    if ls_codrol in
       (202, 101, 8, 105, 107, 900, 11, 12, 671, 13, 14, 15, 16,17) then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = 1
         where c.ncodsuc = p.ncodsuc
           and p.ccodope in
               (select ope.ccodope
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in
                       (202, 101, 8, 105, 107, 12, 11, 13, 14, 15, 16,17))
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    end if;
  
    if ls_codrol in (105, 8, 13, 15) then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = 1
         where c.ncodsuc = p.ncodsuc
           and p.ccodope in (select ope.ccodope
                               from acmoper ope
                              inner join acdagus pue
                                 on ope.ccodope = pue.ccodope
                              where ope.ccodest = '1' --and ope.ccodcar in (202,101,8,105,107)
                             )
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    end if;
  
    if ls_codrol in (102, 7, 10, 9, 108) then
      open lc_liscur for
        select C.ncodsuc,
               rtrim(xmlagg(xmlelement(e, p.ccodope || ',') ORDER BY ope.cnomope)
                     .extract('//text()'), ','),
               rtrim(xmlagg(xmlelement(e, ope.cnomope || ',') ORDER BY cnomope)
                     .extract('//text()'), ',') as usuarios
          from acmsucu c, acdagus p
         inner join acmoper ope
            on ope.ccodope = p.ccodope
           and ope.ccodest = 1
         where c.ncodsuc = p.ncodsuc
           and p.ccodope in
               (select ope.ccodope
                  from acmoper ope
                 inner join acdagus pue
                    on ope.ccodope = pue.ccodope
                 where ope.ccodest = '1'
                   and ope.ccodcar in (102, 7, 10, 9, 108))
         group by C.ncodsuc, c.cnomsuc
         order by c.ncodsuc;
    
    end if;
  
  end sp_lisusuagetran;

  procedure lisusutranpI(ls_nomsuc varchar2,
                         ls_nomusu varchar2,
                         lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : lisusutranpI
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de usuarios para transferir carga inicial
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_codrol number;
  begin
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = upper(ls_nomusu)
       and ccodest = 1;
  
    if ls_codrol in (6, 102, 108) then
      open lc_liscur for
        select ope.ccodope, ope.cnomope
          from acmoper ope
         inner join acdagus pue
            on ope.ccodope = pue.ccodope
           and pue.ccodest = '1'
         where ope.ccodest = '1'
           and pue.ncodsuc = ls_nomsuc
         order by 2;
    
    end if;
    if ls_codrol in (50, 51, 52, 200, 201, 104, 103) then
      open lc_liscur for
        select ope.ccodope, ope.cnomope
          from acmoper ope
         inner join acdagus pue
            on ope.ccodope = pue.ccodope
           and pue.ccodest = '1'
         where ope.ccodest = '1'
           and ope.ccodcar in (50, 51, 52, 200, 201, 104, 103)
           and pue.ncodsuc = ls_nomsuc
         order by 2;
    
    end if;
    /*WCRW 17/05/2018 adicion de codigos 200,201*/
    if ls_codrol in
       (202, 101, 8, 105, 107, 900, 12, 11, 671, 13, 14, 15, 16,17) then
      open lc_liscur for
        select ope.ccodope, ope.cnomope
          from acmoper ope
         inner join acdagus pue
            on ope.ccodope = pue.ccodope
           and pue.ccodest = '1'
         where ope.ccodest = '1'
           and ope.ccodcar in
               (202, 201, 200, 101, 8, 105, 107, 12, 11, 13, 14, 15, 16,17)
           and pue.ncodsuc = ls_nomsuc
         order by 2;
    end if;
  
    if ls_codrol in (7, 10, 9) then
      open lc_liscur for
        select ope.ccodope, ope.cnomope
          from acmoper ope
         inner join acdagus pue
            on ope.ccodope = pue.ccodope
           and pue.ccodest = '1'
         where ope.ccodest = '1'
           and ope.ccodcar in (102, 7, 10, 9, 108)
           and pue.ncodsuc = ls_nomsuc
         order by 2;
    end if;
  end lisusutranpI;

  procedure sp_retdatcony(ps_codpai varchar2,
                          ps_tipdoc varchar2,
                          ps_numdoc varchar2,
                          ps_paicon out varchar2,
                          ps_tipcon out varchar2,
                          ps_numcon out varchar2,
                          ps_nomcon out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_retdatcony
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Retorna datos del conyuge
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
  
    select coalesce(npaicon, 0),
           coalesce(ntipcon, 0),
           coalesce(cdoccon, ' '),
           coalesce(cconnom, ' ')
      into ps_paicon, ps_tipcon, ps_numcon, ps_nomcon
      from acdeval
     where cnumdoc = ps_numdoc
       and ntipdoc = ps_tipdoc
       and npaicli = ps_codpai;
  exception
    when no_data_found then
      ps_paicon := ' ';
      ps_tipcon := ' ';
      ps_numcon := ' ';
      ps_nomcon := ' ';
    when others then
      ps_paicon := ' ';
      ps_tipcon := ' ';
      ps_numcon := ' ';
      ps_nomcon := ' ';
  end sp_retdatcony;

  function fn_datovisitafec(ps_corage varchar2) return date is
  
    -- *****************************************************************
    -- Nombre                     : fn_datovisitafec
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        :  Datos de la fecha de visita
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_fecvis date;
  begin
  
    select rev.dfecvis
    --resu.cnomres 
      into ls_fecvis
    --ps_resvis             
      from (select ncorage, cobserv, nrespue, dfecvis
              from acdrevi
            union
            select ncorage, cobserv, nrespue, dfecvis
              from achrevi) rev
     inner join acdrepu rep
        on rep.nrespue = rev.nrespue
       and rep.cestado = '1'
     inner join acdresp res
        on res.nrescod = rep.nrescod
       and res.cestado = '1'
     inner join acdprre pre
        on pre.npreres = rep.npreres
       and pre.cestado = '1'
     inner join acdresu resu
        on resu.ncodres = pre.ncodres
       and resu.cestado = '1'
     where rev.ncorage = ps_corage
       and rep.nrescod = 4
       and rownum = 1;
    return ls_fecvis;
  
  exception
    when no_data_found then
      ls_fecvis := null;
      return ls_fecvis;
    when others then
      ls_fecvis := null;
      return ls_fecvis;
    
  end fn_datovisitafec;

  function fn_datovisitares(ps_corage varchar2) return varchar2 is
  -- *****************************************************************
  -- Nombre                     : fn_datovisitares
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 02/05/2017
  -- Autor de Creación          : BDEG
  -- Uso                        :  Datos de la resultado de visita
  -- Estado                     : Activo
  -- Fecha Modificación         :
  -- Autor de Modificación      :
  -- Descripcion Modificacion   :
  -- ***************************************************************** 
    ls_resvis varchar2(100);
  begin
    select resu.cnomres into ls_resvis
      from (select ncorage, cobserv, nrespue, dfecvis
              from acdrevi
            union
            select ncorage, cobserv, nrespue, dfecvis
              from achrevi) rev
    inner join acdrepu rep
         on rep.nrespue = rev.nrespue
        and rep.cestado = '1'
    inner join acdresp res
         on res.nrescod = rep.nrescod
        and res.cestado = '1'
    inner join acdprre pre
         on pre.npreres = rep.npreres
        and pre.cestado = '1'
    inner join acdresu resu
         on resu.ncodres = pre.ncodres
        and resu.cestado = '1'
      where rev.ncorage = ps_corage
        and rep.nrescod = 4
        and rownum = 1;
    return ls_resvis;
  exception
    when no_data_found then
      ls_resvis := ' ';
      return ls_resvis;
    when others then
      ls_resvis := ' ';
      return ls_resvis;
  end fn_datovisitares;

  procedure sp_insasipromotorven(ps_codact varchar2,
                                 ps_codbas varchar2,
                                 ps_numdoc varchar2,
                                 ps_usuasi varchar2,
                                 ps_codusu varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_insasipromotorven
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/05/2017
    -- Autor de Creación          : EBDC
    -- Uso                        : Insertar Asignar promotor ventas
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
   as
    ln_codact number;
    ln_codbas number;
  begin
  
    select ncodact into ln_codact from actacti where cnomact = ps_codact;
    select ncodbas
      into ln_codbas
      from actbase
     where ncodact = ln_codact
       and cnomact = ps_codbas;
  
    update acdasig
       set ccodusu = trim(upper(ps_codusu)),
           cusuasi = trim(upper(ps_usuasi))
     where cnumdoc = trim(ps_numdoc)
       and ncodact = ln_codact
       and ncodbas = ln_codbas;
    commit;
  end sp_insasipromotorven;

procedure sp_repseguiclientedet(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                ps_codest varchar2,ps_tiprep varchar2,
                                lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repseguiclientedet
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 07/04/2017
-- Autor de Creación          : BDEG
-- Uso                        : Reporte de Seguimiento de Clientes detallado
-- Estado                     : Activo
-- Fecha Modificación         : 17/07/2019
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Diferenciar Reportes
-- Fecha Modificación         : 29/09/2023
-- Autor de Modificación      : Frank Pinto Carpio
-- Descripcion Modificacion   : Se aumenta descripcion de modulo y tipo de operacion de credito
-- ***************************************************************** 
ls_codusu varchar2(10);
ls_fecini date;
ls_fecfin date;
ls_fectem date;
ls_codbas number;
begin
   ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
   ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
   if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
   end if;
   if ps_codbas = 'elige Base...' then
      ls_codbas := null;
   else
      ls_codbas := ps_codbas;
   end if;
   if ps_tiprep='V' then
      if ps_codest = 'F' then
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli,eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             eva.cusuasi as ccodusu,resu.cnomres,to_char(eva.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(eva.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa,to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,
             eva.cfecmod,eva.chormod,eva.cnomreg,eva.cnomsuc,eva.cdeszon,eva.cfecdes,eva.czonpro,
             nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe
        from (select a.dfeceva,a.cnumdoc,a.cclinom,a.npaicli,a.ntipdoc,a.ncorcli,a.cusuing,a.ctelneg,
                     a.ctelfij,a.ctelmov,asi.ncorasi,asi.ccodusu as cusuasi,a.ncodact,a.ncodbas,a.ccodcal,
                     a.ctipcli,a.ncodage,asi.ncodbas as nasibas,rev.nrespue,rev.cobserv,rev.dfecvis,
                     to_char(asi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(asi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,a.cfecdes,a.czonpro
                 from acdeval a
              left join acdasig asi
                  on asi.ncorcli = a.ncorcli 
              left join acdagen agen
                  on agen.ncorasi = asi.ncorasi
              left join acdrevi rev
                  on rev.ncorage = agen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(asi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc         
               where a.ncodact = ps_codact
                 and a.ncodbas = coalesce(ls_codbas, a.ncodbas)
              union
              select b.dfeceva,b.cnumdoc,b.cclinom,b.npaicli,b.ntipdoc,b.ncorcli,b.cusuing,b.ctelneg,
                     b.ctelfij,b.ctelmov,hasi.ncorasi,hasi.ccodusu as cusuasi,b.ncodact,b.ncodbas,b.ccodcal,
                     b.ctipcli,b.ncodage,hasi.ncodbas as nasibas,hrev.nrespue,hrev.cobserv,hrev.dfecvis,
                     to_char(hasi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(hasi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,b.cfecdes,b.czonpro
                from acheval b
              left join achasig hasi
                  on hasi.ncorcli = b.ncorcli
              left join achagen hagen
                  on hagen.ncorasi = hasi.ncorasi
              left join achrevi hrev
                  on hrev.ncorage = hagen.ncorage
               left join acdagus pau
                  on pau.ccodope = upper(trim(hasi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc                
               where b.ncodact = ps_codact
                 and b.ncodbas = coalesce(ls_codbas, b.ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(eva.cusuasi))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdrepu repu
          on repu.nrespue = eva.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.ncodage
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.ncodage
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas,eva.nasibas)
         and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
      else
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli,eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             eva.cusuasi as ccodusu,resu.cnomres,to_char(eva.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(eva.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa,to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,
             eva.cfecmod,eva.chormod,eva.cnomreg,eva.cnomsuc,eva.cdeszon,eva.cfecdes,eva.czonpro,
             nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe
        from (select a.dfeceva,a.cnumdoc,a.cclinom,a.npaicli,a.ntipdoc,a.ncorcli,a.cusuing,a.ctelneg,
                     a.ctelfij,a.ctelmov,asi.ncorasi,asi.ccodusu as cusuasi,a.ncodact,a.ncodbas,a.ccodcal,
                     a.ctipcli,a.ncodage,asi.ncodbas as nasibas,rev.nrespue,rev.cobserv,rev.dfecvis,
                     to_char(asi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(asi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,a.cfecdes,a.czonpro
                 from acdeval a
              left join acdasig asi
                  on asi.ncorcli = a.ncorcli 
              left join acdagen agen
                  on agen.ncorasi = asi.ncorasi
              left join acdrevi rev
                  on rev.ncorage = agen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(asi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc        
               where a.ncodact = ps_codact
                 and a.ncodbas = coalesce(ls_codbas, a.ncodbas)
              union
              select b.dfeceva,b.cnumdoc,b.cclinom,b.npaicli,b.ntipdoc,b.ncorcli,b.cusuing,b.ctelneg,
                     b.ctelfij,b.ctelmov,hasi.ncorasi,hasi.ccodusu as cusuasi,b.ncodact,b.ncodbas,b.ccodcal,
                     b.ctipcli,b.ncodage,hasi.ncodbas as nasibas,hrev.nrespue,hrev.cobserv,hrev.dfecvis,
                     to_char(hasi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(hasi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,b.cfecdes,b.czonpro
                from acheval b
              left join achasig hasi
                  on hasi.ncorcli = b.ncorcli
              left join achagen hagen
                  on hagen.ncorasi = hasi.ncorasi
              left join achrevi hrev
                  on hrev.ncorage = hagen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(hasi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc               
               where b.ncodact = ps_codact
                 and b.ncodbas = coalesce(ls_codbas, b.ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(eva.cusuasi))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdrepu repu
          on repu.nrespue = eva.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.ncodage
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.ncodage
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas,eva.nasibas)
         and trunc(desem.dfecdes) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
   end if;
   else
   if ps_codest = 'F' then
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,
             upper(regi.cnomreg) as reging,upper(regi.cdeszon) as zoning,' ' as DNI,
             rolin.cdesrol,to_char(eva.dfeceva, 'YYYY-MM-DD') as dfecreg,eva.cnumdoc,
             eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,
             eva.ncorcli, eva.cusuing) as ultresing,coalesce(trim(eva.ctelneg), 
             trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             asi.ccodusu,resu.cnomres,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
             coalesce(rev.cobserv, ' ') as cobserv,coalesce(desem.ctipcli, ' ') as ctipcli,
             to_char(desem.dfecdes, 'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,
             desem.NAOCTA,desem.NAOOPER,desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa, nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe
        from (select *
                from acdeval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)
                union
              select *
                from acheval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdasig asi
          on asi.npaicli = eva.npaicli
         and asi.ntipdoc = eva.ntipdoc
         and asi.cnumdoc = eva.cnumdoc
         and asi.ncodact = eva.ncodact
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(asi.ccodusu))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdagen agen
          on agen.npaicli = asi.npaicli
         and agen.ntipdoc = asi.ntipdoc
         and agen.cnumdoc = asi.cnumdoc
         and agen.ncodact = asi.ncodact
      left join acdrevi rev
          on rev.npaicli = agen.npaicli
         and rev.ntipdoc = agen.ntipdoc
         and rev.cnumdoc = agen.cnumdoc
         and rev.ncodact = agen.ncodact
      left join acdrepu repu
          on repu.nrespue = rev.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.NCODAGE
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.NCODAGE
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas, asi.ncodbas)
         and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
   else
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva, 'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli, eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             asi.ccodusu,resu.cnomres,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes, 'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
              case
              when trim(desem.ncodmon) = '0' then 'SOLES'
              when trim(desem.ncodmon) = '101' then 'DOLARES'
              else ''
              end as cmoneda,
              desem.ncanimp,desem.cnompro,desem.aotasa, nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe
         from (select *
                 from acdeval
                where ncodact = ps_codact
                  and ncodbas = coalesce(ls_codbas, ncodbas)
                union
               select *
                 from acheval
                where ncodact = ps_codact
                  and ncodbas = coalesce(ls_codbas, ncodbas)) eva
      inner join actacti act
           on act.ncodact = eva.ncodact
      inner join actbase bas
           on bas.ncodbas = eva.ncodbas
          and bas.ncodact = eva.ncodact
      left join acdatri cal
           on cal.ncodtab = 5
          and cal.ctipatr = 'D'
          and cal.cestado = '1'
          and cal.ccodatr = eva.ccodcal
      left join acdasig asi
           on asi.npaicli = eva.npaicli
          and asi.ntipdoc = eva.ntipdoc
          and asi.cnumdoc = eva.cnumdoc
          and asi.ncodact = eva.ncodact
      left join acdagus pau1
           on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
           on pau.ccodope = upper(trim(asi.ccodusu))
      left join acmsucu age
           on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
           on tip.ncodtab = 9
          and tip.ctipatr = 'D'
          and tip.ccodatr = eva.ctipcli
          and tip.cestado = '1'
      left join acdagen agen
           on agen.npaicli = asi.npaicli
          and agen.ntipdoc = asi.ntipdoc
          and agen.cnumdoc = asi.cnumdoc
          and agen.ncodact = asi.ncodact
      left join acdrevi rev
           on rev.npaicli = agen.npaicli
          and rev.ntipdoc = agen.ntipdoc
          and rev.cnumdoc = agen.cnumdoc
          and rev.ncodact = agen.ncodact
      left join acdrepu repu
           on repu.nrespue = rev.nrespue
      left join acdprre prre
           on prre.npreres = repu.npreres
      left join acdresu resu
           on resu.ncodres = prre.ncodres
      left join ACDDESE desem
           on desem.ncorcli = eva.ncorcli
      left join acdagus usin
           on upper(trim(eva.cusuing)) = usin.ccodope
          and usin.ccodest = '1'
      left join acmsucu sucing
           on sucing.ncodsuc = eva.NCODAGE
      left join acmoper oping
           on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
           on rolin.ncodrol = oping.ccodcar
      left join actregi regi
           on regi.ncodsuc = eva.NCODAGE
      left join actregi regd
           on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
        where eva.ncodact = ps_codact
          and eva.ncodbas = coalesce(ls_codbas, asi.ncodbas)
          and trunc(desem.dfecdes) between ls_fecini and ls_fecfin
          and (repu.nrescod = 4 or repu.nrescod is null);
      end if;
   end if;
end sp_repseguiclientedet;

  procedure sp_repshisporDNI(ps_doccli varchar2,
                             lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_repshisporDNI
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reporte por DNI del cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select eva.cnumdoc,eva.ncorcli,age.ncorage,eva.cclinom,to_char(eva.dfeceva, 'YYYY-MM-DD') as dfeceva,
       eva.cusuing,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,rev.cusucre,res.cnomres,
       (select cobserv
          from (select cobserv, nrespue, ncorage
                  from acdrevi
                 union
                select cobserv, nrespue, ncorage
                  from achrevi) rev1
                inner join acdrepu repu1
                    on repu1.nrespue = rev1.nrespue
                inner join acdprre prre1
                    on prre1.npreres = repu1.npreres
                inner join acdresu res1
                    on res1.ncodres = prre1.ncodres
                   and res1.cestado = '1'
                where repu1.nrescod = '6'
                  and rev1.ncorage = age.ncorage) as fecproxvis,
       eva.nmoneva,rev.cusucre,rol.cdesrol,act.cnomact as actividad,
       bas.cnomact as base,zon.cnomreg,zon.cnomsuc
from (select * from acdeval
       where cnumdoc = ps_doccli 
       union
      select *
        from acheval
      where cnumdoc = ps_doccli ) eva
      left join (select ncorcli, ncorasi
                   from acdasig
                  where cnumdoc = ps_doccli 
                 union
                 select ncorcli, ncorasi
                   from achasig
                  where cnumdoc = ps_doccli ) asi
         on asi.ncorcli = eva.ncorcli
       left join (select ncorasi, ncorage
                    from acdagen
                   where cnumdoc = ps_doccli 
                   union
                  select ncorasi, ncorage
                    from achagen
                   where cnumdoc = ps_doccli ) age
         on age.ncorasi = asi.ncorasi
       left join (select * from acdrevi where cnumdoc = ps_doccli 
                   union
                  select * from achrevi where cnumdoc = ps_doccli ) rev
         on rev.ncorage = age.ncorage
       left join acdagus pau
         on pau.ccodope = upper(trim(rev.cusucre))
       left join actregi zon
         on zon.ncodsuc = pau.ncodsuc    
       left join acdrepu repu
         on repu.nrespue = rev.nrespue
       left join acdprre prre
         on prre.npreres = repu.npreres
       left join acdresu res
         on res.ncodres = prre.ncodres
        and res.cestado = '1'
       left join acmoper ope
         on ope.ccodope = rev.cusucre
       left join acdrole rol
         on rol.ncodrol = ope.ccodcar
       left join actacti act
         on act.ncodact = eva.ncodact
       left join actbase bas
         on bas.ncodbas = eva.ncodbas
        and bas.ncodact = eva.ncodact
      where repu.nrescod = '4'
      order by dfecvis, rev.ncorage;
  end sp_repshisporDNI;

  procedure sp_loginses(ps_codusu varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_loginses
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 23/05/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Log de Inicio de Session
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    insert into actlgin
      (ccodusu, dfecing)
    values
      (upper(trim(ps_codusu)), sysdate);
    commit;
  end sp_loginses;

  procedure sp_lisusumicalentodos(ps_numsuc varchar2,
                                  lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_repshisporDNI
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reporte por DNI del cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select op.ccodope
        from acmoper op
       inner join acdagus pu
          on pu.ccodope = op.ccodope
       where pu.ccodest = '1'
         and ncodsuc = ps_numsuc
       order by op.cnomope;
  
  end sp_lisusumicalentodos;

  procedure sp_listaSucurMiCalendario(lc_liscur out types.cursor_type,
                                      ln_totage out integer) as
    -- *****************************************************************
    -- Nombre                     : sp_listaSucurMiCalendario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista Sucursales mi calendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    select max(distinct ncodsuc)
      into ln_totage
      from acdagus
     where ccodest = '1'
       and ncodsuc is not null;
  
    open lc_liscur for
      select distinct ncodsuc
        from acdagus
       where ccodest = '1'
         and ncodsuc is not null;
  
  end sp_listaSucurMiCalendario;

  procedure sp_lisusumicalentodosnombre(ps_numsuc varchar2,
                                        lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisusumicalentodosnombre
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de nombres mi calendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select cnomope
        from acmoper op
       inner join acdagus pu
          on pu.ccodope = op.ccodope
       where pu.ccodest = '1'
         and ncodsuc = ps_numsuc
       order by op.cnomope;
  
  end sp_lisusumicalentodosnombre;

  function fn_resusuing(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_resusuing
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/07/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Respuesta del usuario de ingreso
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
    ls_nomres VARCHAR2(100);
    ls_codusu varchar2(10);
  begin
    ls_codusu := upper(trim(ps_usuing));
    begin
      select /*+ NO_CPU_COSTING */
       cnomres
        into ls_nomres
        from (select cnomres,
                     b.npaicli,
                     b.ntipdoc,
                     b.cnumdoc,
                     b.cusucre,
                     b.ncorage
                from (select a.*, resu1.cnomres
                        from (select nrespue,
                                     npaicli,
                                     ntipdoc,
                                     cnumdoc,
                                     cusucre,
                                     chorvis,
                                     dfecvis,
                                     ncorage
                                from acdrevi
                               where npaicli = pn_codpai
                                 and ntipdoc = pn_tipdoc
                                 and cnumdoc = ps_numdoc
                              union all
                              select nrespue,
                                     npaicli,
                                     ntipdoc,
                                     cnumdoc,
                                     cusucre,
                                     chorvis,
                                     dfecvis,
                                     ncorage
                                from achrevi
                               where npaicli = pn_codpai
                                 and ntipdoc = pn_tipdoc
                                 and cnumdoc = ps_numdoc) a
                      
                        left join acdrepu repu1
                          on repu1.nrespue = a.nrespue
                        left join acdprre prre1
                          on prre1.npreres = repu1.npreres
                        left join acdresu resu1
                          on resu1.ncodres = prre1.ncodres
                        left join (select ncorasi, ncorage
                                    from acdagen
                                   where npaicli = pn_codpai
                                     and ntipdoc = pn_tipdoc
                                     and cnumdoc = ps_numdoc
                                  union all
                                  select ncorasi, ncorage
                                    from achagen
                                   where npaicli = pn_codpai
                                     and ntipdoc = pn_tipdoc
                                     and cnumdoc = ps_numdoc) k
                          on k.ncorage = a.ncorage
                        left join (select ncorasi, ncorcli
                                    from acdasig
                                   where npaicli = pn_codpai
                                     and ntipdoc = pn_tipdoc
                                     and cnumdoc = ps_numdoc
                                  union all
                                  select ncorasi, ncorcli
                                    from achasig
                                   where npaicli = pn_codpai
                                     and ntipdoc = pn_tipdoc
                                     and cnumdoc = ps_numdoc) j
                          on k.ncorasi = j.ncorasi
                       where repu1.nrescod = 4
                         and a.nrespue not in
                             (select rep.nrespue
                                from acdresu res
                               inner join acdprre prre
                                  on prre.ncodres = res.ncodres
                               inner join acdrepu rep
                                  on prre.npreres = rep.npreres
                               where res.cestado = '1'
                                 and res.ncodres in
                                     (87, 88, 89, 90, 91, 92, 93, 94, 95, 87,
                                      88, 89, 90, 96))
                         and j.ncorcli = ps_corcli) b
               order by ncorage desc, b.dfecvis desc, b.chorvis desc) c
       where rownum = 1
         and c.npaicli = pn_codpai
         and c.ntipdoc = pn_tipdoc
         and c.cnumdoc = ps_numdoc
         and c.cusucre = ls_codusu;
    
    exception
      when no_data_found then
        ls_nomres := 0;
    end;
    return ls_nomres;
  end fn_resusuing;

  function fn_resusuing2(pn_codpai in number,
                         pn_tipdoc in number,
                         ps_numdoc in varchar2,
                         ps_corcli number,
                         ps_usuing varchar2) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_resusuing2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Respuesta del usuario de ingreso
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
    ls_nomres VARCHAR2(100);
    ls_codusu varchar2(10);
    ls_codres number(5);
  begin
    ls_codusu := upper(trim(ps_usuing));
    begin
    
      select cnomres
        into ls_nomres
        from (select rev.ncorage, res.cnomres
                from (select ncorcli
                        from acdeval
                       where ncorcli = ps_corcli
                      union all
                      select ncorcli
                        from acheval
                       where ncorcli = ps_corcli) eva
               inner join (select ncorasi, ncorcli
                            from acdasig
                           where ncorcli = ps_corcli
                          union all
                          select ncorasi, ncorcli
                            from achasig
                           where ncorcli = ps_corcli) asi
                  on asi.ncorcli = eva.ncorcli
               inner join (select ncorasi, ncorage
                            from acdagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorasi, ncorage
                            from achagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) age
                  on age.ncorasi = asi.ncorasi
               inner join (select ncorage, nrespue
                            from acdrevi
                           where trim(cusucre) = ls_codusu
                             and npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorage, nrespue
                            from achrevi
                           where trim(cusucre) = ls_codusu
                             and npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) rev
                  on rev.ncorage = age.ncorage
               inner join acdrepu repu
                  on repu.nrespue = rev.nrespue
               inner join acdprre prre
                  on repu.npreres = prre.npreres
               inner join acdresu res
                  on prre.ncodres = res.ncodres
                 and repu.nrescod = 4
               order by rev.ncorage desc) temporal
       where rownum = 1;
    exception
      when no_data_found then
        ls_nomres := 0;
    end;
    return ls_nomres;
  end fn_resusuing2;

  function fn_resusufin(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_resusufin
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : ultimo resultado
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
    ls_nomres VARCHAR2(100);
    ls_codres number(5);
  begin
    begin
    
      select cnomres
        into ls_nomres
        from (select rev.ncorage, res.cnomres
                from (select ncorcli
                        from acdeval
                       where ncorcli = ps_corcli
                      union all
                      select ncorcli
                        from acheval
                       where ncorcli = ps_corcli) eva
               inner join (select ncorasi, ncorcli
                            from acdasig
                           where ncorcli = ps_corcli
                          union all
                          select ncorasi, ncorcli
                            from achasig
                           where ncorcli = ps_corcli) asi
                  on asi.ncorcli = eva.ncorcli
               inner join (select ncorasi, ncorage
                            from acdagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorasi, ncorage
                            from achagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) age
                  on age.ncorasi = asi.ncorasi
               inner join (select ncorage, nrespue
                            from acdrevi
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorage, nrespue
                            from achrevi
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) rev
                  on rev.ncorage = age.ncorage
               inner join acdrepu repu
                  on repu.nrespue = rev.nrespue
               inner join acdprre prre
                  on repu.npreres = prre.npreres
               inner join acdresu res
                  on prre.ncodres = res.ncodres
                 and repu.nrescod = 4
               order by rev.ncorage desc) temporal
       where rownum = 1;
    
    exception
      when no_data_found then
        ls_nomres := 0;
    end;
    return ls_nomres;
  end fn_resusufin;

  function fn_ultfecvis(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number,
                        ps_usuing varchar2) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_resusufin
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : ultimo resultado
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
    ls_fecvis date;
  
  begin
    begin
    
      select max(dfecvis)
        into ls_fecvis
        from (select ncorasi
                from acdasig
               where ncorcli = ps_corcli
              union all
              select ncorasi
                from achasig
               where ncorcli = ps_corcli) asi
       inner join (select ncorasi, ncorage
                     from acdagen
                    where npaicli = pn_codpai
                      and ntipdoc = pn_tipdoc
                      and cnumdoc = ps_numdoc
                   union all
                   select ncorasi, ncorage
                     from achagen
                    where npaicli = pn_codpai
                      and ntipdoc = pn_tipdoc
                      and cnumdoc = ps_numdoc) age
          on asi.ncorasi = age.ncorasi
       inner join (select ncorage, dfecvis, nrespue
                     from acdrevi
                    where npaicli = pn_codpai
                      and ntipdoc = pn_tipdoc
                      and cnumdoc = ps_numdoc
                   union all
                   select ncorage, dfecvis, nrespue
                     from achrevi
                    where npaicli = pn_codpai
                      and ntipdoc = pn_tipdoc
                      and cnumdoc = ps_numdoc) rev
          on rev.ncorage = age.ncorage
         and nrespue in (select nrespue from acdrepu where nrescod = 4);
    
    exception
      when no_data_found then
        ls_fecvis := null;
    end;
    return ls_fecvis;
  end fn_ultfecvis;

  function fn_ultobsvis(pn_codpai in number,
                        pn_tipdoc in number,
                        ps_numdoc in varchar2,
                        ps_corcli number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_ultobsvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Ultima observacion de visita
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************
    ls_observacion varchar2(4000);
  
  begin
    begin
    
      select cobserv
        into ls_observacion
        from (select rev.cobserv, rev.ncorage
                from (select ncorasi
                        from acdasig
                       where ncorcli = ps_corcli
                      union all
                      select ncorasi
                        from achasig
                       where ncorcli = ps_corcli) asi
               inner join (select ncorasi, ncorage
                            from acdagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorasi, ncorage
                            from achagen
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) age
                  on asi.ncorasi = age.ncorasi
               inner join (select ncorage, cobserv, nrespue, dfecvis
                            from acdrevi
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc
                          union all
                          select ncorage, cobserv, nrespue, dfecvis
                            from achrevi
                           where npaicli = pn_codpai
                             and ntipdoc = pn_tipdoc
                             and cnumdoc = ps_numdoc) rev
                  on rev.ncorage = age.ncorage
                 and rev.nrespue in
                     (select nrespue from acdrepu where nrescod = 4)
               order by 2 desc) temp1
       where rownum = 1;
    
    exception
      when no_data_found then
        ls_observacion := '';
    end;
    return ls_observacion;
  end fn_ultobsvis;

  procedure sp_crearperpool(ps_coderr out varchar2, ps_deserr out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_crearperpool
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/20/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Crear periodos de pool
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ln_canper number;
    ln_diacre number;
    ld_diaini date;
    ld_diafin date;
    ln_diaact number;
    ln_diatot number;
    ld_fecte1 date;
    ld_fecte2 date;
    ln_conta  number;
    ln_candia number;
    ln_ideper number;
  begin
    ps_coderr := '000000';
    ps_deserr := '000000';
    ln_conta  := 1;
  
    select ncanpar
      into ln_canper
      from acdpopa
     where ncodest = '1'
       and ntippar = 1
       and ncodpar = 1;
  
    select ncanpar
      into ln_diacre
      from acdpopa
     where ncodest = '1'
       and ntippar = 2
       and ncodpar = 1;
  
    select to_number(to_char(sysdate, 'DD')) into ln_diaact from dual;
  
    if ln_diaact = ln_diacre then
    
      delete actpope;
      commit;
    
      select trunc(ADD_MONTHS(last_day(sysdate) + 1, -1)),
             trunc(last_day(sysdate))
        into ld_diaini, ld_diafin
        from dual;
    
      ld_fecte1 := ld_diaini;
    
      select ld_diafin - ld_diaini into ln_diatot from dual;
    
      ln_candia := floor(ln_diatot / ln_canper) - 1;
    
      select coalesce(max(ncodper), 0) into ln_ideper from actpope;
    
      for ln_conta IN 1 .. ln_canper loop
        ln_ideper := ln_ideper + 1;
        if ln_conta = ln_canper then
          ld_fecte2 := ld_diafin;
        else
          ld_fecte2 := ld_fecte1 + ln_candia;
        end if;
      
        insert into actpope values (ln_ideper, ld_fecte1, ld_fecte2, '1');
      
        ld_fecte1 := ld_fecte2 + 1;
      end loop;
    
      commit;
    
      delete acdpeac;
    
      insert into acdpeac
        select per.ncodper,
               act.ncodact,
               rol.ncodrol,
               sug.ncodpri as ncodpri
          from actpope per
         cross join actacti act
         cross join acdrole rol
         inner join actposg sug
            on sug.ncodact = act.ncodact
           and sug.ncodper = per.ncodper
         where act.cestado = 'A'
           and per.cestado = '1'
           and rol.ccodest = '1';
      commit;
    end if;
  
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_deserr := 'NO HAY DATOS';
      rollback;
    when others then
      ps_coderr := '00099';
      ps_deserr := SQLERRM;
      rollback;
  end sp_crearperpool;

  procedure sp_lisperiodo(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisperiodo
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/07/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de periodos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select ncodper, dfecini || ' - ' || dfecfin
        from actpope
       where cestado = '1'
       order by ncodper;
  
  end sp_lisperiodo;

  procedure sp_lisprioridad(pc_codper varchar2,
                            pc_codrol varchar2,
                            lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisprioridad
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/07/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de prioridades
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select mae.ncodpri, act.ncodact, act.cnomact, mae.ncodpri
        from acdpeac mae
       inner join actacti act
          on act.ncodact = mae.ncodact
         and act.cestado = 'A'
       where ncodrol = pc_codrol
         and ncodper = pc_codper;
  end sp_lisprioridad;

  procedure sp_listotalusuarios(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_lisusumicalentodosnombre
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de nombres mi calendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select pu.ncodsuc, op.ccodope, cnomope
        from acmoper op
       inner join acdagus pu
          on pu.ccodope = op.ccodope
       where pu.ccodest = '1'
         and pu.ncodsuc is not null
       order by pu.ncodsuc, op.cnomope;
  
  end sp_listotalusuarios;

  procedure sp_desbloquear(ps_codpai in varchar,
                           ps_tipdoc in varchar,
                           ps_numdoc in varchar,
                           ps_codact in varchar,
                           ps_nomusu in varchar,
                           ps_coderr out char,
                           ps_msgerr out varchar2)
  
   is
    -- *****************************************************************
    -- Nombre                     : sp_desbloquear
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Desbloquea Clientes
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estasi    integer;
    ln_estage    integer;
    ln_conasi    integer;
    ln_conage    integer;
    ls_corage    number;
    ls_fecha     varchar2(10);
    ls_hora      varchar2(5);
    ls_desvis    varchar2(100);
    ls_nomcli    varchar2(100);
    ln_liseva    integer;
    ls_resdesblo varchar2(3);
  begin
  
    ls_resdesblo := '122';
    select cclinom
      into ls_nomcli
      from (select cclinom
              from acdeval
             where npaicli = ps_codpai
               and ntipdoc = ps_tipdoc
               and cnumdoc = ps_numdoc
            union
            select cclinom
              from acheval
             where npaicli = ps_codpai
               and ntipdoc = ps_tipdoc
               and cnumdoc = ps_numdoc)
     where rownum = 1;
  
    ps_coderr := '00000';
    ps_msgerr := 'Se desbloqueo al cliente: ' || ls_nomcli;
    select count(*)
      into ln_conasi
      from acdasig
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and cnumdoc = ps_numdoc
       and ncodact = ps_codact;
    select count(*)
      into ln_conage
      from acdagen
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and cnumdoc = ps_numdoc
       and ncodact = ps_codact;
  
    if (ln_conasi > 0 and ln_conage > 0) then
      select cestado
        into ls_estasi
        from acdasig
       where npaicli = ps_codpai
         and ntipdoc = ps_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ps_codact;
    
      select cestado, ncorage
        into ln_estage, ls_corage
        from acdagen
       where npaicli = ps_codpai
         and ntipdoc = ps_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ps_codact;
    
      if (ls_estasi = 2 and ln_estage = 1) then
        sp_insvis(ls_corage, ps_nomusu, ls_resdesblo,
                  'Desbloqueo por: ' || ps_nomusu, '', '', '0', '0', 4,
                  ps_coderr, ps_msgerr);
      end if;
    
      if (ls_estasi = 1 and ln_estage = 1) then
      
        update acdasig
           set cestado = 2
         where npaicli = ps_codpai
           and ntipdoc = ps_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact = ps_codact;
        commit;
      
        sp_insvis(ls_corage, ps_nomusu, ls_resdesblo,
                  'Desbloqueo por: ' || ps_nomusu, '', '', '0', '0', 4,
                  ps_coderr, ps_msgerr);
      end if;
    
      if (ls_estasi = 1 and ln_estage = 2) then
        select to_char(sysdate, 'YYYY-MM-DD'), to_char(sysdate, 'HH:MM')
          into ls_fecha, ls_hora
          from dual;
        sp_insage(ps_codpai, ps_tipdoc, ps_numdoc, ps_nomusu, ls_fecha,
                  ls_hora, 3, ps_codact, 0, '0', '0', ls_desvis);
      
        select ncorage
          into ls_corage
          from acdagen
         where npaicli = ps_codpai
           and ntipdoc = ps_tipdoc
           and cnumdoc = ps_numdoc
           and ncodact = ps_codact;
      
        sp_insvis(ls_corage, ps_nomusu, ls_resdesblo,
                  'Desbloqueo por: ' || ps_nomusu, '', '', '0', '0', 4,
                  ps_coderr, ps_msgerr);
      end if;
      if (ls_estasi = 2 and ln_estage = 2) then
        ps_msgerr := 'DOCUMENTO NO SE ENCUENTRA BLOQUEADO PARA DICHA ACTIVIDAD';
        ps_coderr := '00001';
      end if;
    end if;
    if (ln_conasi > 0 and ln_conage = 0) then
      select to_char(sysdate, 'YYYY-MM-DD'), to_char(sysdate, 'HH:MM')
        into ls_fecha, ls_hora
        from dual;
      sp_insage(ps_codpai, ps_tipdoc, ps_numdoc, ps_nomusu, ls_fecha,
                ls_hora, 3, ps_codact, 0, '0', '0', ls_desvis);
    
      select ncorage
        into ls_corage
        from acdagen
       where npaicli = ps_codpai
         and ntipdoc = ps_tipdoc
         and cnumdoc = ps_numdoc
         and ncodact = ps_codact;
      sp_insvis(ls_corage, ps_nomusu, ls_resdesblo,
                'Desbloqueo por: ' || ps_nomusu, '', '', '0', '0', 4,
                ps_coderr, ps_msgerr);
    
    end if;
    if (ln_conasi = 0 and ln_conage = 0) then
      ps_msgerr := 'DOCUMENTO NO SE ENCUENTRA BLOQUEADO PARA DICHA ACTIVIDAD';
      ps_coderr := '00001';
    end if;
  
    select count(*)
      into ln_liseva
      from (select *
              from acdeval
             where npaicli = ps_codpai
               and ntipdoc = ps_tipdoc
               and cnumdoc = ps_numdoc
               and ncodact = ps_codact
               and nindcier = 0
            union
            select *
              from acheval
             where npaicli = ps_codpai
               and ntipdoc = ps_tipdoc
               and cnumdoc = ps_numdoc
               and ncodact = ps_codact
               and nindcier = 0) a;
  
    update acdeval
       set nindcier = 1, ccodest = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
  
    update acheval
       set nindcier = 1, ccodest = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
  
    update acdasig
       set cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
  
    update achasig
       set cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
  
    update acdagen
       set cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
  
    update achagen
       set cestado = '2'
     where npaicli = ps_codpai
       and ntipdoc = ps_tipdoc
       and trim(cnumdoc) = ps_numdoc
       and ncodact = ps_codact;
    commit;
  
    if (ps_coderr = '00000' or 0 < ln_liseva) then
      ps_msgerr := 'SE DESBLOQUEO AL CLIENTE: ' || ls_nomcli;
    end if;
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_desbloquear;

  procedure sp_lisactualizarref(ps_codana varchar2,
                                ps_fecini varchar2,
                                ps_numdoc varchar2,
                                ps_codusu varchar2,
                                lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisactualizarref
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista para actualziar referido
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ld_fecini date;
    ls_codana varchar2(10);
    ls_codtip char(1);
    ls_codcar number;
  begin
  
    ls_codana := trim(upper(ps_codana));
    if (ps_numdoc <> 'DNI' or ps_numdoc <> '') then
    
      select case
               when rol.ntodage = '1' and rol.ntodusu = '1' then
                '1'
               else
                '0'
             end
        into ls_codtip
        from acmoper ope
       inner join acdrole rol
          on ope.ccodcar = rol.ncodrol
       where ccodope = ps_codusu;
    
      if (ls_codtip = '1') then
        open lc_liscur for
          select eva.ncorcli,
                 eva.ncodage,
                 to_char(trunc(eva.dfeceva), 'YYYY-MM-DD'),
                 age.cnomsuc,
                 act.cnomact,
                 bas.cnomact as cnombas,
                 eva.cclinom,
                 eva.cnumdoc,
                 eva.cusuing
            from (select *
                    from acdeval
                   where cnumdoc = ps_numdoc
                  union
                  select *
                    from acheval
                   where cnumdoc = ps_numdoc) eva
            left join acmsucu age
              on age.ncodsuc = eva.ncodage
            left join actacti act
              on act.ncodact = eva.ncodact
            left join actbase bas
              on bas.ncodact = eva.ncodact
             and bas.ncodbas = eva.ncodbas;
      
      else
      
        select ccodcar
          into ls_codcar
          from acmoper
         where ccodope = ps_codusu;
      
        open lc_liscur for
          select eva.ncorcli,
                 eva.ncodage,
                 to_char(trunc(eva.dfeceva), 'YYYY-MM-DD'),
                 age.cnomsuc,
                 act.cnomact,
                 bas.cnomact as cnombas,
                 eva.cclinom,
                 eva.cnumdoc,
                 eva.cusuing
            from (select *
                    from acdeval
                   where cnumdoc = ps_numdoc
                  union
                  select *
                    from acheval
                   where cnumdoc = ps_numdoc) eva
            left join acmsucu age
              on age.ncodsuc = eva.ncodage
            left join actacti act
              on act.ncodact = eva.ncodact
            left join actbase bas
              on bas.ncodact = eva.ncodact
             and bas.ncodbas = eva.ncodbas
           where eva.cusuing in
                 ((select ccodope
                     from (select ccodope
                             from acmoper
                            where ccodope = ps_codusu)
                   union
                   SELECT ccodope
                     FROM acmoper
                    START WITH ccodjef = ps_codusu
                            or ccodsup = ps_codusu
                   CONNECT BY PRIOR ccodope = ccodjef) union select ccodope from
                  acmoper where
                  ccodcar in
                  (select ncarsub from acpcarg where ncarjef = ls_codcar));
      end if;
    else
      ld_fecini := to_date(ps_fecini, 'YYYY-MM-DD');
    
      open lc_liscur for
        select eva.ncorcli,
               eva.ncodage,
               to_char(trunc(eva.dfeceva), 'YYYY-MM-DD'),
               age.cnomsuc,
               act.cnomact,
               bas.cnomact as cnombas,
               eva.cclinom,
               eva.cnumdoc,
               eva.cusuing
          from (select *
                  from acdeval
                 where cusuing = ls_codana
                   and trunc(dfeceva) = ld_fecini
                union
                select *
                  from acheval
                 where cusuing = ls_codana
                   and trunc(dfeceva) = ld_fecini) eva
          left join acmsucu age
            on age.ncodsuc = eva.ncodage
          left join actacti act
            on act.ncodact = eva.ncodact
          left join actbase bas
            on bas.ncodact = eva.ncodact
           and bas.ncodbas = eva.ncodbas;
    end if;
  end sp_lisactualizarref;

  procedure sp_nomclidesb(ps_codpai in varchar2,
                          ps_tipdoc in varchar,
                          ps_numdoc in varchar,
                          ps_codact in varchar2,
                          ls_nomcli out varchar2,
                          ls_opeing out varchar2,
                          ls_sucing out varchar2,
                          ls_roling out varchar2,
                          ls_opeasi out varchar2,
                          ls_sucasi out varchar2,
                          ls_rolasi out varchar2,
                          ls_resvis out varchar2,
                          ls_fecvis out varchar2,
                          ls_desact out varchar2,
                          ps_coderr out varchar2,
                          ps_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_nomclidesb
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Obtiene el nombre del cliente para desbloquearlo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
  
    ln_numreg number(20);
    ln_corcli number(20);
    ln_corasi number(20);
    ln_corage number(20);
    ls_numdoc varchar2(12);
    ld_feceva date;
    ls_nomope varchar2(30);
    ls_nomsuc char(30);
    ls_desrol varchar2(40);
    ls_usuact varchar2(30);
    ls_sucact char(30);
    ls_nomact varchar2(100);
    ls_basnom varchar2(100);
  
  begin
    ls_numdoc := trim(ps_numdoc);
    begin
      select max(ncorcli)
        into ln_corcli
        from (select ncorcli
                from acdeval
               where cnumdoc = ls_numdoc
                 and ntipdoc = ps_tipdoc
                 and npaicli = ps_codpai
                 and nindcier = '0'
                 and ncodact = ps_codact
              union
              select ncorcli
                from acheval
               where cnumdoc = ls_numdoc
                 and ntipdoc = ps_tipdoc
                 and npaicli = ps_codpai
                 and nindcier = '0'
                 and ncodact = ps_codact);
      if ln_corcli is null then
        ln_corcli := 0;
      end if;
    
    exception
      when no_data_found then
        ln_corcli := 0;
      when others then
        ln_corcli := 0;
    end;
  
    if ln_corcli > 0 then
      begin
        select max(ncorasi)
          into ln_corasi
          from (select ncorasi
                  from acdasig
                 where ncorcli = ln_corcli
                union
                select ncorasi
                  from acdasig
                 where ncorcli = ln_corcli);
        if ln_corasi is null then
          ln_corasi := 0;
        end if;
      exception
        when no_data_found then
          ln_corasi := 0;
        when others then
          ln_corasi := 0;
      end;
      begin
        select max(ncorage)
          into ln_corage
          from (select ncorasi, ncorage
                  from acdagen
                 where cestado = 2
                union
                select ncorasi, ncorage
                  from achagen
                 where cestado = 2)
         where ncorasi in (select ncorasi
                             from acdasig
                            where ncorcli = ln_corcli
                           union
                           select ncorasi
                             from achasig
                            where ncorcli = ln_corcli);
        if ln_corage is null then
          ln_corage := 0;
        end if;
      exception
        when no_data_found then
          ln_corage := 0;
        when others then
          ln_corage := 0;
      end;
      -- Nomcliente y Fecha 
      begin
        select trunc(dfeceva), cclinom, act.cnomact, bas.cnomact
          into ld_feceva, ls_nomcli, ls_nomact, ls_basnom
          from (select dfeceva, cclinom, ncodact, ncodbas
                  from acdeval
                 where ncorcli = ln_corcli
                union
                select dfeceva, cclinom, ncodact, ncodbas
                  from acheval
                 where ncorcli = ln_corcli) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
         where rownum = 1;
      exception
        when no_data_found then
          ld_feceva := ' ';
          ls_nomcli := ' ';
          ls_nomact := ' ';
          ls_basnom := ' ';
        when others then
          ld_feceva := ' ';
          ls_nomcli := ' ';
          ls_nomact := ' ';
          ls_basnom := ' ';
      end;
    
      -- Nombre usuario Ingresado
      begin
        select ope.cnomope, suc.cnomsuc, rol.cdesrol
          into ls_nomope, ls_nomsuc, ls_desrol
          from (select cusuing
                  from acdeval
                 where ncorcli = ln_corcli
                union
                select cusuing
                  from acheval
                 where ncorcli = ln_corcli) eva
         inner join acmoper ope
            on ope.ccodope = eva.cusuing
         inner join acdagus pue
            on pue.ccodope = eva.cusuing
         inner join acmsucu suc
            on suc.ncodsuc = pue.ncodsuc
         inner join acdrole rol
            on rol.ncodrol = ope.ccodcar
         where rownum = 1;
      exception
        when no_data_found then
          ls_nomope := ' ';
          ls_nomsuc := ' ';
          ls_desrol := ' ';
        when others then
          ls_nomope := ' ';
          ls_nomsuc := ' ';
          ls_desrol := ' ';
      end;
      -- Usuario Actual
      begin
        select ope.cnomope, suc.cnomsuc, rol.cdesrol
          into ls_usuact, ls_sucact, ls_desact
          from acdasig asi
         inner join acmoper ope
            on cast(ope.ccodope as char(10)) = asi.ccodusu
         inner join acdagus pue
            on cast(pue.ccodope as char(10)) = asi.ccodusu
         inner join acmsucu suc
            on suc.ncodsuc = pue.ncodsuc
         inner join acdrole rol
            on rol.ncodrol = ope.ccodcar
         where asi.ncorasi = ln_corasi
           and rownum = 1;
      exception
        when no_data_found then
          ls_usuact := ' ';
          ls_sucact := ' ';
          ls_desact := ' ';
        when others then
          ls_usuact := ' ';
          ls_sucact := ' ';
          ls_desact := ' ';
      end;
      -----------------------
      ls_opeing := ls_nomope;
      ls_sucing := ls_nomsuc;
      ls_roling := ls_desrol;
      ls_opeasi := ls_usuact;
      ls_sucasi := coalesce(ls_sucact, ' ');
      ls_rolasi := coalesce(ls_desact, ' ');
      ls_resvis := coalesce(fn_datovisitares(ln_corage), ' ');
      ls_fecvis := to_char(trunc(coalesce(fn_datovisitafec(ln_corage),
                                          ld_feceva)), 'dd/mm/yyyy');
      ls_desact := ls_nomact || ' - ' || ls_basnom;
      ps_coderr := '00000';
      ps_msgerr := 'CORRECTO';
    else
      ls_nomcli := ' ';
      ls_opeing := ' ';
      ls_sucing := ' ';
      ls_roling := ' ';
      ls_opeasi := ' ';
      ls_sucasi := ' ';
      ls_rolasi := ' ';
      ls_resvis := ' ';
      ls_fecvis := ' ';
      ls_desact := ' ';
      ps_coderr := '00011';
      ps_msgerr := 'EL CLIENTE NO CUENTA CON GESTION EN LA ACTIVIDAD SELECCIONADA ';
    end if;
  
  exception
    when no_data_found then
      ls_nomcli := ' ';
      ls_opeing := ' ';
      ls_sucing := ' ';
      ls_roling := ' ';
      ls_opeasi := ' ';
      ls_sucasi := ' ';
      ls_rolasi := ' ';
      ls_resvis := ' ';
      ls_fecvis := ' ';
      ls_desact := ' ';
      ps_coderr := '00011';
      ps_msgerr := 'EL CLIENTE NO CUENTA CON GESTION EN LA ACTIVIDAD SELECCIONADA ';
    when others then
      ls_nomcli := ' ';
      ls_opeing := ' ';
      ls_sucing := ' ';
      ls_roling := ' ';
      ls_opeasi := ' ';
      ls_sucasi := ' ';
      ls_rolasi := ' ';
      ls_resvis := ' ';
      ls_fecvis := ' ';
      ls_desact := ' ';
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_nomclidesb;

  procedure sp_modificarprioridad(ps_codper in varchar2,
                                  ps_codrol in varchar,
                                  ps_codact in varchar,
                                  ps_codtip in varchar2,
                                  ps_coderr out varchar2,
                                  ps_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_modificarprioridad
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Modifica el prioridad de las actividades del periodo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_primax number;
    ls_priact number;
    ls_prinue number;
    ls_pritem number;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    select max(ncodpri)
      into ls_primax
      from acdpeac
     where ncodper = ps_codper
       and ncodrol = ps_codrol;
  
    select ncodpri
      into ls_priact
      from acdpeac
     where ncodper = ps_codper
       and ncodact = ps_codact
       and ncodrol = ps_codrol;
  
    if ps_codtip = '1' then
      -- Subir
      if ls_priact = 1 then
        return;
      else
        ls_pritem := ls_priact - 1;
      
        update acdpeac
           set ncodpri = ncodpri + 1
         where ncodper = ps_codper
           and ncodpri = ls_pritem
           and ncodrol = ps_codrol;
      
        update acdpeac
           set ncodpri = ncodpri - 1
         where ncodper = ps_codper
           and ncodact = ps_codact
           and ncodrol = ps_codrol;
      end if;
    
    end if;
  
    if ps_codtip = '2' then
      -- Bajar
    
      if ls_priact = ls_primax then
        return;
      else
        ls_pritem := ls_priact + 1;
      
        update acdpeac
           set ncodpri = ncodpri - 1
         where ncodper = ps_codper
           and ncodpri = ls_pritem
           and ncodrol = ps_codrol;
      
        update acdpeac
           set ncodpri = ncodpri + 1
         where ncodper = ps_codper
           and ncodact = ps_codact
           and ncodrol = ps_codrol;
      end if;
    
    end if;
    commit;
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
      rollback;
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
      rollback;
    
  end sp_modificarprioridad;

  procedure sp_tipmon(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_tipmon
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra los tipos de moneda
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ccodatr, cdesatr
        from acdatri
       where ncodtab = 15
         and ctipatr = 'D'
         and cestado = '1'
       order by ccodatr;
  end sp_tipmon;

  procedure sp_desbloquear2(ps_corcli in varchar2,
                            ps_nomusu in varchar,
                            ps_coderr out char,
                            ps_msgerr out varchar2)
  
   is
    -- *****************************************************************
    -- Nombre                     : sp_desbloquear
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/08/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Desbloquea Clientes
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estasi      integer;
    ln_estage      integer;
    ln_conasi      integer;
    ln_conage      integer;
    ls_corage      number;
    ls_fecha       varchar2(10);
    ls_hora        varchar2(5);
    ls_desvis      varchar2(100);
    ls_nomcli      varchar2(100);
    ln_liseva      integer;
    ls_codpai      number;
    ls_tipdoc      number;
    ls_numdoc      varchar2(12);
    ls_codact      number;
    ls_contar      number;
    ls_Desbloqueo  varchar2(3);
    ls_desbloqueo2 varchar2(3);
  begin
  
    ls_Desbloqueo  := '122';
    ls_desbloqueo2 := '168';
    ps_coderr      := '00000';
    ps_msgerr      := 'Se desbloqueo al cliente: ' || ls_nomcli;
    select npaicli, ntipdoc, cnumdoc, ncodact
      into ls_codpai, ls_tipdoc, ls_numdoc, ls_codact
      from (select npaicli, ntipdoc, cnumdoc, ncodact
              from acdeval
             where ncorcli = ps_corcli
            union
            select npaicli, ntipdoc, cnumdoc, ncodact
              from acheval
             where ncorcli = ps_corcli) a;
  
    select count(*)
      into ln_conasi
      from (select ncorasi
              from acdasig
             where ncorcli = ps_corcli
            union
            select ncorasi
              from achasig
             where ncorcli = ps_corcli) a;
  
    select count(*)
      into ln_conage
      from acdagen
     where ncorasi in
           (select ncorasi from acdasig where ncorcli = ps_corcli)
        or ncorasi in
           (select ncorasi from achasig where ncorcli = ps_corcli);
  
    if (ln_conasi > 0 and ln_conage > 0) then
      select cestado into ls_estasi from acdasig where ncorcli = ps_corcli;
    
      select cestado, ncorage
        into ln_estage, ls_corage
        from acdagen
       where ncorasi in
             (select ncorasi from acdasig where ncorcli = ps_corcli);
    
      if (ls_estasi = 2 and ln_estage = 1) then
      
        select count(*)
          into ls_contar
          from acdrevi
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and cnumdoc = ls_numdoc
           and ncodact = ls_codact;
        update acdagen set cestado = '2' where ncorage = ls_corage;
        if ls_contar > 0 then
          insert into achrevi
            select *
              from acdrevi
             where npaicli = ls_codpai
               and ntipdoc = ls_tipdoc
               and cnumdoc = ls_numdoc
               and ncodact = ls_codact;
          delete acdrevi
           where npaicli = ls_codpai
             and ntipdoc = ls_tipdoc
             and cnumdoc = ls_numdoc
             and ncodact = ls_codact;
        
          insert into acdrevi
            select ncorage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   ls_desbloqueo2,
                   'Desbloqueo por: SYSADM',
                   '1',
                   'SYSADM',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   0,
                   0
              from acdagen
             where ncorage = ls_corage;
          commit;
        else
          insert into acdrevi
            select ncorage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   ls_desbloqueo2,
                   'Desbloqueo por: SYSADM',
                   '1',
                   'SYSADM',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   0,
                   0
              from acdagen
             where ncorage = ls_corage;
          commit;
        
        end if;
      
      end if;
    
      if (ls_estasi = 1 and ln_estage = 1) then
      
        update acdasig set cestado = 2 where ncorcli = ps_corcli;
        commit;
      
        select count(*)
          into ls_contar
          from acdrevi
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and cnumdoc = ls_numdoc
           and ncodact = ls_codact;
        update acdagen set cestado = '2' where ncorage = ls_corage;
        if ls_contar > 0 then
          insert into achrevi
            select *
              from acdrevi
             where npaicli = ls_codpai
               and ntipdoc = ls_tipdoc
               and cnumdoc = ls_numdoc
               and ncodact = ls_codact;
          delete acdrevi
           where npaicli = ls_codpai
             and ntipdoc = ls_tipdoc
             and cnumdoc = ls_numdoc
             and ncodact = ls_codact;
        
          insert into acdrevi
            select ncorage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   ls_desbloqueo2,
                   'Desbloqueo por: SYSADM',
                   '1',
                   'SYSADM',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   0,
                   0
              from acdagen
             where ncorage = ls_corage;
          commit;
        else
          insert into acdrevi
            select ncorage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   ls_desbloqueo2,
                   'Desbloqueo por: SYSADM',
                   '1',
                   'SYSADM',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   0,
                   0
              from acdagen
             where ncorage = ls_corage;
          commit;
        
        end if;
      end if;
    
      if (ls_estasi = 1 and ln_estage = 2) then
        select to_char(sysdate, 'YYYY-MM-DD'), to_char(sysdate, 'HH:MM')
          into ls_fecha, ls_hora
          from dual;
      
        --sp_insage (ls_codpai,ls_tipdoc,trim(ls_numdoc),ps_nomusu,ls_fecha,ls_hora,3,ls_codact,0,'0','0',ls_desvis);
        -- Insertar Agenda
        update acdasig
           set cestado = 2
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ls_codact;
      
        insert into achagen
          select *
            from acdagen
           where npaicli = ls_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ls_codact;
      
        delete acdagen
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ls_codact;
        insert into acdagen
          select supplier_seq.NEXTVAL,
                 nidebas,
                 nidepro,
                 ncoding,
                 ncodact,
                 ncodbas,
                 npaicli,
                 ntipdoc,
                 cnumdoc,
                 '1',
                 trunc(sysdate),
                 dfecasi,
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:Mi'),
                 'SYSADM',
                 'SYSADM',
                 sysdate,
                 '0',
                 ncorasi,
                 0,
                 0
            from acdasig
           where npaicli = ls_codpai
             and ntipdoc = ls_tipdoc
             and trim(cnumdoc) = ls_numdoc
             and ncodact = ls_codact;
        --
      
        select ncorage
          into ls_corage
          from acdagen
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and cnumdoc = ls_numdoc
           and ncodact = ls_codact;
      
        sp_insvis(ls_corage, ps_nomusu, ls_Desbloqueo,
                  'Desbloqueo por: ' || ps_nomusu, '', '', '0', '0', 4,
                  ps_coderr, ps_msgerr);
      end if;
      if (ls_estasi = 2 and ln_estage = 2) then
        ps_msgerr := 'DOCUMENTO NO SE ENCUENTRA BLOQUEADO PARA DICHA ACTIVIDAD';
        ps_coderr := '00001';
      end if;
    end if;
    if (ln_conasi > 0 and ln_conage = 0) then
      select to_char(sysdate, 'YYYY-MM-DD'), to_char(sysdate, 'HH:MM')
        into ls_fecha, ls_hora
        from dual;
      --sp_insage (ls_codpai,ls_tipdoc,ls_numdoc,ps_nomusu,ls_fecha,ls_hora,3,ls_codact,0,'0','0',ls_desvis);
      -- Insertar Agenda
      update acdasig
         set cestado = 2
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ls_codact;
      insert into achagen
        select *
          from acdagen
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ls_codact;
    
      delete acdagen
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and trim(cnumdoc) = ls_numdoc
         and ncodact = ls_codact;
      insert into acdagen
        select supplier_seq.NEXTVAL,
               nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '1',
               trunc(sysdate),
               dfecasi,
               trunc(sysdate),
               to_char(sysdate, 'HH24:Mi'),
               'SYSADM',
               'SYSADM',
               sysdate,
               '0',
               ncorasi,
               0,
               0
          from acdasig
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and trim(cnumdoc) = ls_numdoc
           and ncodact = ls_codact;
      --
    
      select ncorage
        into ls_corage
        from acdagen
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and cnumdoc = ls_numdoc
         and ncodact = ls_codact;
      select count(*)
        into ls_contar
        from acdrevi
       where npaicli = ls_codpai
         and ntipdoc = ls_tipdoc
         and cnumdoc = ls_numdoc
         and ncodact = ls_codact;
      update acdagen set cestado = '2' where ncorage = ls_corage;
      if ls_contar > 0 then
        insert into achrevi
          select *
            from acdrevi
           where npaicli = ls_codpai
             and ntipdoc = ls_tipdoc
             and cnumdoc = ls_numdoc
             and ncodact = ls_codact;
        delete acdrevi
         where npaicli = ls_codpai
           and ntipdoc = ls_tipdoc
           and cnumdoc = ls_numdoc
           and ncodact = ls_codact;
      
        insert into acdrevi
          select ncorage,
                 nidebas,
                 nidepro,
                 ncoding,
                 ncodact,
                 ncodbas,
                 npaicli,
                 ntipdoc,
                 cnumdoc,
                 ls_desbloqueo2,
                 'Desbloqueo por: SYSADM',
                 '1',
                 'SYSADM',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:Mi'),
                 0,
                 0
            from acdagen
           where ncorage = ls_corage;
        commit;
      else
        insert into acdrevi
          select ncorage,
                 nidebas,
                 nidepro,
                 ncoding,
                 ncodact,
                 ncodbas,
                 npaicli,
                 ntipdoc,
                 cnumdoc,
                 ls_desbloqueo2,
                 'Desbloqueo por: SYSADM',
                 '1',
                 'SYSADM',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:Mi'),
                 0,
                 0
            from acdagen
           where ncorage = ls_corage;
        commit;
      
      end if;
    
    end if;
    if (ln_conasi = 0 and ln_conage = 0) then
      ps_msgerr := 'DOCUMENTO NO SE ENCUENTRA BLOQUEADO PARA DICHA ACTIVIDAD';
      ps_coderr := '00001';
    end if;
  
    select count(*)
      into ln_liseva
      from (select *
              from acdeval
             where ncorcli = ps_corcli
            union
            select *
              from acheval
             where ncorcli = ps_corcli) a;
  
    update acdeval
       set nindcier = 1, ccodest = '2'
     where ncorcli = ps_corcli;
  
    update acheval
       set nindcier = 1, ccodest = '2'
     where ncorcli = ps_corcli;
  
    update acdasig set cestado = '2' where ncorcli = ps_corcli;
  
    update achasig set cestado = '2' where ncorcli = ps_corcli;
  
    update acdagen
       set cestado = '2'
     where ncorasi in
           (select ncorasi from acdasig where ncorcli = ps_corcli)
        or ncorasi in
           (select ncorasi from acdasig where ncorcli = ps_corcli);
  
    update achagen
       set cestado = '2'
     where ncorasi in
           (select ncorasi from acdasig where ncorcli = ps_corcli)
        or ncorasi in
           (select ncorasi from acdasig where ncorcli = ps_corcli);
    commit;
  
    if (ps_coderr = '00000' or 0 < ln_liseva) then
      ps_msgerr := 'SE DESBLOQUEO AL CLIENTE: ' || ls_nomcli;
    end if;
  
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_desbloquear2;
  procedure sp_rolext(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_rolext
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de roles externos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ncodrol, cdesrol
        from acdrole
       where ncodrol in (select ccodatr
                           from acdatri
                          where ncodtab in (17, 18)
                            and ctipatr = 'D')
       order by 2;
  end sp_rolext;

  procedure sp_supext(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_supext
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de supervisores externos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select ccodope, cnomope
        from acmoper
       where ccodcar in (select ccodatr
                           from acdatri
                          where ncodtab in (17)
                            and ctipatr = 'D')
         and ccodest = 1
       order by 2;
  end sp_supext;

  procedure sp_lisusuext(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusuext
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de usuarios externos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select coalesce(ope.ccodope, ' '),
             coalesce(ope.cnomope, ' '),
             coalesce(rol.cdesrol, ' '),
             coalesce(suc.cnomsuc, ' '),
             coalesce(ope.ccodjef, ' ')
        from acmoper ope
       inner join acdagus pue
          on pue.ccodope = ope.ccodope
         and pue.ccodest = '1'
       inner join acmsucu suc
          on suc.ncodsuc = pue.ncodsuc
       inner join acdrole rol
          on rol.ncodrol = ope.ccodcar
       where ope.ccodest = 1
         and ope.ccodcar in (select ccodatr
                               from acdatri
                              where ncodtab in (17, 18)
                                and ctipatr = 'D');
  end sp_lisusuext;

  procedure sp_editusuario(pc_codusu varchar2,
                           pc_codage varchar2,
                           pc_codrol varchar2,
                           pc_codsup varchar2,
                           ps_codest varchar2,
                           pc_usureg varchar2,
                           pc_nomusu varchar2,
                           ps_coderr out char,
                           ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_editusuario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Editar usuarios externos
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_consup number;
    ln_connor number;
    ls_codrol char(3);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_codrol := pc_codrol;
    if ps_codest = '1' then
      update acmoper set ccodest = '0' where ccodope = pc_codusu;
    
      update acdagus set ccodest = '0' where ccodope = pc_codusu;
    
      update acdusua set ccodest = '0' where ccodusu = pc_codusu;
    end if;
  
    if ps_codest = '0' then
      select count(*)
        into ln_connor
        from acdatri
       where ncodtab in (18)
         and ctipatr = 'D'
         and ccodatr = ls_codrol;
      if ln_connor > 0 then
      
        update acmoper
           set ccodest = '1',
               cnomope = pc_nomusu,
               ccodcar = pc_codrol,
               ccodjef = pc_codsup
         where ccodope = pc_codusu;
      
        update acdagus
           set ccodest = '1', ncodsuc = pc_codage
         where ccodope = pc_codusu;
      
        update acdusua
           set ccodest = '0', ncodrol = pc_codrol
         where ccodusu = pc_codusu;
      end if;
    
      select count(*)
        into ln_consup
        from acdatri
       where ncodtab in (17)
         and ctipatr = 'D'
         and ccodatr = ls_codrol;
      if ln_consup > 0 then
        update acmoper
           set ccodest = '1',
               cnomope = pc_nomusu,
               ccodcar = pc_codrol,
               ccodjef = null
         where ccodope = pc_codusu;
      
        update acdagus
           set ccodest = '1', ncodsuc = pc_codage
         where ccodope = pc_codusu;
      
        update acdusua
           set ccodest = '0', ncodrol = pc_codrol
         where ccodusu = pc_codusu;
      end if;
    
    end if;
    commit;
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_editusuario;

  procedure sp_crearusuario(pc_codusu varchar2,
                            pc_codage varchar2,
                            pc_codrol varchar2,
                            pc_codsup varchar2,
                            pc_usureg varchar2,
                            pc_nomusu varchar2,
                            ps_coderr out char,
                            ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_crearusuario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Crear Usuario
    -- Estado                     : Activo
    -- Fecha Modificación         : 24/09/2024
    -- Autor de Modificación      : Fpinto
    -- Descripcion Modificacion   : se actualiza valres a mayusculas todos.
    -- *****************************************************************  
  
   as
    ls_contar number;
    ln_consup number;
    ls_codrol char(3);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_codrol := pc_codrol;
    select count(*) into ls_contar from acmoper where ccodope = upper(trim(pc_codusu));
  
    if ls_contar > 0 then
      update acmoper set ccodest = 1 where ccodope = upper(trim(pc_codusu));
      update acdagus set ccodest = 1 where ccodope = upper(trim(pc_codusu));
      update acdusua set ccodest = 1 where ccodusu = upper(trim(pc_codusu));
    else
      select count(*)
        into ln_consup
        from acdatri
       where ncodtab in (18)
         and ctipatr = 'D'
         and ccodatr = ls_codrol;
      if ln_consup > 0 then
        insert into acmoper
        values
          (upper(trim(pc_codusu)), upper(trim(pc_nomusu)), pc_codrol, null, upper(trim(pc_codsup)), 1);
      else
        insert into acmoper
        values
          (upper(trim(pc_codusu)), upper(trim(pc_nomusu)), pc_codrol, null, null, 1);
      end if;
    
      insert into acdagus values (upper(trim(pc_codusu)), pc_codage, 1);
      insert into acdusua values (upper(trim(pc_codusu)), pc_codrol, 1);
    end if;
  
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_crearusuario;

  procedure sp_procie2 as
  begin
    declare
      ps_msgerr   varchar2(1000);
      ps_coderr   varchar2(100);
      ls_fecdcier date;
      ln_corage   number(20);
      cursor p_base is
        select asi.ncorcli,
               asi.ncorasi,
               asi.npaicli,
               asi.ntipdoc,
               asi.cnumdoc,
               asi.ncodact
          -- Se adiciona base 6 y 12 06/01/2020
          from (select ncorcli
                  from acdeval
                 where ncoding = 3
                   and ncodact = 1
                   and ncodbas in (5,6,12)
                   and nindcier = 0
                union
                select ncorcli
                  from acheval
                 where ncoding = 3
                   and ncodact = 1
                   and ncodbas in (5,6,12)
                   and nindcier = 0) eva
         inner join acdasig asi
            on asi.ncorcli = eva.ncorcli
         inner join acmoper ope
            on ope.ccodope = trim(asi.ccodusu)
        -- adición de coordinador externo y promo externo 19/07/2019
         --where ope.ccodcar = 105
         where ope.ccodcar in (105,17,8)
           and asi.cestado = '1'
           and trunc(asi.dfecmod) <= ls_fecdcier;
    begin
      --ls_fecdcier := trunc(sysdate - 7);
      ls_fecdcier := trunc(sysdate - 2); -- se cambia a 2 día
      for v_reg in p_base loop
        begin
          update acdasig set cestado = 2 where ncorasi = v_reg.ncorasi;
        
          insert into achagen
            select *
              from acdagen
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdagen
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdagen
            select supplier_seq.NEXTVAL,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '2',
                   trunc(sysdate),
                   dfecasi,
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   'SYSADM',
                   'SYSADM',
                   sysdate,
                   '1',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = v_reg.ncorasi;
        
          select ncorage
            into ln_corage
            from acdagen
           where ncorasi = v_reg.ncorasi;
        
          insert into achrevi
            select *
              from acdrevi
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdrevi
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdrevi
            select ncorage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   168,
                   'Sin asignación de Coord. ¿ Desbloq. Sistema',
                   '1',
                   'SYSADM',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   0,
                   0
              from acdagen
             where ncorage = ln_corage;
        
          update acdeval set nindcier = 1 where ncorcli = v_reg.ncorcli;
          update acheval set nindcier = 1 where ncorcli = v_reg.ncorcli;
        
          commit;
        
        exception
          when no_data_found then
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
          when others then
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
        end;
      end LOOP;
    end;
  end sp_procie2;

  procedure sp_listactbas(lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_listactbas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista Sucursal - Base
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    open lc_liscur for
      select bas.ncodact, bas.ncodbas, bas.cnomact
        from actbase bas
       where bas.cestado = 'A';
  end sp_listactbas;

  procedure sp_listaactbas(lc_liscur out types.cursor_type,
                           ln_totact out integer) as
    -- *****************************************************************
    -- Nombre                     : sp_listaSucurMiCalendario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista Sucursales mi calendario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    select max(ncodact) into ln_totact from actacti where cestado = 'A';
    open lc_liscur for
      select ncodact into ln_totact from actacti where cestado = 'A';
  end sp_listaactbas;

  /*procedure sp_revdesem(pc_codusu varchar2,pc_corcli varchar2, pc_tipvis varchar2,
                         ps_coderr out char,ps_msgerr out varchar2)
    -- *****************************************************************
    -- Nombre                     : sp_revdesem
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Revertir desembolso
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  as
  ln_corasi number;
  ln_codact number(2);
  ln_paicli number(3);
  ln_tipdoc number(2);
  ls_numdoc varchar2(12);
  ln_corage number;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    select max(ncorasi) 
      into ln_corasi
    from (select ncorasi from acdasig where ncorcli = pc_corcli
           union
          select ncorasi from achasig where ncorcli = pc_corcli
          );
  
    select * 
      into 
    ln_codact,
    ln_paicli,
    ln_tipdoc,
    ls_numdoc
    from 
    (select ncodact,npaicli,ntipdoc,cnumdoc from acdeval where ncorcli = pc_corcli
      union
     select ncodact,npaicli,ntipdoc,cnumdoc from acheval where ncorcli = pc_corcli
    );
    
    if pc_tipvis = 100 then
      delete acddese where ncorcli = pc_corcli;
      insert into achagen
      select * 
        from acdagen
       where ncodact = ln_codact
         and npaicli = ln_paicli
         and ntipdoc = ln_tipdoc
         and cnumdoc = ls_numdoc;
         
       delete acdagen
       where ncodact = ln_codact
         and npaicli = ln_paicli
         and ntipdoc = ln_tipdoc
         and cnumdoc = ls_numdoc;
         
        insert into acdagen
        select nidebas,
               nidepro,
               ncoding,
               ncodact,
               ncodbas,
               npaicli,
               ntipdoc,
               cnumdoc,
               '2',
               trunc(sysdate),
               dfecasi,
               sysdate,
               '1',
               ncorasi,
               0,
               0
         from (
         select nidebas,nidepro,ncoding,ncodact,ncodbas,npaicli,ntipdoc,cnumdoc,dfecasi,ncorasi from acdasig where ncorasi = ln_corasi
          union
         select nidebas,nidepro,ncoding,ncodact,ncodbas,npaicli,ntipdoc,cnumdoc,dfecasi,ncorasi from acdasig where ncorasi = ln_corasi
         ) a;
         
         select max(ncorage) into ln_corage from acdagen where ncorasi = ln_corasi;
      
          insert into achrevi
          select * 
           from acdrevi
          where ncodact = ln_codact
            and npaicli = ln_paicli
            and ntipdoc = ln_tipdoc
            and cnumdoc = ls_numdoc;
        
        delete acdrevi
         where ncodact = ln_codact
           and npaicli = ln_paicli
           and ntipdoc = ln_tipdoc
           and cnumdoc = ls_numdoc;
           
        \*insert into acdrevi
        select nidebas,nidepro,
               ncoding,ncodact,
               ncodbas,npaicli,
               ntipdoc,trim(cnumdoc),
               141,'Revertir','1'
               trim(upper(pc_codusu)),trunc(sysdate),to_char(sysdate,'HH24:Mi'),0,0
               from acdagen
              where ncorage = ln_corage;
  
       insert into aclacpr values (pc_corcli,'3',null,null,null,null,pc_codusu,sysdate); *\        
    end if;
     commit;
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_revdesem;*/

  procedure sp_misti_tracli(pc_corage varchar2,
                            pc_tiping varchar2,
                            pc_paicli varchar2,
                            pc_tipdoc varchar2,
                            pc_numdoc varchar2,
                            pc_codcod out varchar2,
                            pc_codcol out varchar2,
                            pc_codtit out varchar2,
                            lc_liscur out types.cursor_type,
                            ps_coderr out char,
                            ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_tracli
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Misti trama cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ls_corcli number(20);
    ln_corcli number(20);
    ln_valpar varchar2(100);
    lc_codmon char(1);
    ln_captra varchar2(100);
    ln_valadi varchar2(100);
    ln_actfij varchar2(100);
    ln_fij12m varchar2(100);
    ln_ratcuo varchar2(100);
    ls_desseg varchar2(100);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    /*
     begin
      select t1.tp1desc
        into pc_codcod
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 2
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcod := '0';
    end;
    
    begin
      select t1.tp1desc
        into pc_codcol
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 3
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := '000000';
    end;
    
    begin
      select t1.tp1desc
        into pc_codtit
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 1
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := 'NO HAY CAMPAÑA';
    end;
    */
  
    if pc_tiping = '1' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli, ncorasi
                from acdasig
              union
              select ncorcli, ncorasi
                from achasig) a
       where ncorasi in
             (select ncorasi from acdagen where ncorage = pc_corage);
    end if;
    if pc_tiping = '2' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli, ncorasi
                from acdasig
              union
              select ncorcli, ncorasi
                from achasig) a
       where ncorasi = pc_corage;
    
    end if;
  
    if pc_tiping = '3' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli
                from acdeval
               where npaicli = pc_paicli
                 and ntipdoc = pc_tipdoc
                 and cnumdoc = pc_numdoc
                 and ncodact = 7
              union
              select ncorcli
                from acheval
               where npaicli = pc_paicli
                 and ntipdoc = pc_tipdoc
                 and cnumdoc = pc_numdoc
                 and ncodact = 7) a;
    
    end if;
  
    select NVALPAR, NVALADI, NRATCUO, csegdes, NACTFIJ, NFIJ12M, NCAPTRA
      into ln_valpar,
           ln_valadi,
           ln_ratcuo,
           ls_desseg,
           ln_actfij,
           ln_fij12m,
           ln_captra
      from actacca
     where ncorcli = ls_corcli
       and rownum = 1;
  
    open lc_liscur for
      select etiqueta, valor
        from (
              
              select 1 as num,
                      'Capital de trabajo' as etiqueta,
                      coalesce(TO_CHAR(replace(ln_captra, ',', '.'),
                                       'fm999,999,990.90'), '') as valor
                from dual
              union
              select 2 as num,
                      'Paralelo' as etiqueta,
                      coalesce(TO_CHAR(replace(ln_valpar, ',', '.'),
                                       'fm999,999,990.90'), '') as valor
                from dual
              union
              select 3 as num,
                      'Adicional' as etiqueta,
                      coalesce(TO_CHAR(replace(ln_valadi, ',', '.'),
                                       'fm999,999,990.90'), '') as valor
                from dual
              union
              select 4 as num,
                      'Activo Fijo' as etiqueta,
                      coalesce(TO_CHAR(replace(ln_actfij, ',', '.'),
                                       'fm999,999,990.90'), '') as valor
                from dual
              union
              select 5 as num,
                      'Activo Fijo 12 M' as etiqueta,
                      coalesce(TO_CHAR(replace(ln_fij12m, ',', '.'),
                                       'fm999,999,990.90'), '') as valor
                from dual
              union
              select 6 as num,
                      'Ratio Cuota / Resultado' as etiqueta,
                      coalesce(to_char(ln_ratcuo), '') || ' %' as valor
                from dual
              union
              select 7 as num,
                      'Segmento' as etiqueta,
                      coalesce(to_char(ls_desseg), '') as valor
                from dual
              
              ) a
       order by num;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_tracli;

  procedure sp_misti_asigotroas(pc_codpai  varchar2,
                                pc_tipdoc  varchar2,
                                pc_numdoc  varchar2,
                                pc_valcam  out varchar2,
                                pc_mensaje out varchar2,
                                ps_coderr  out char,
                                ps_msgerr  out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_asigotroas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Valida si esta asignado a otro asesor 
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ls_numdoc varchar2(12);
    ln_conreg number;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := trim(pc_numdoc);
  
    select count(*)
      into ln_conreg
      from (select *
              from acdeval
             where ncodact = 7
               and npaicli = pc_codpai
               and ntipdoc = pc_tipdoc
               and cnumdoc = ls_numdoc
               and nindcier = '0'
            union
            select *
              from acheval
             where ncodact = 7
               and npaicli = pc_codpai
               and ntipdoc = pc_tipdoc
               and cnumdoc = ls_numdoc
               and nindcier = '0') a;
    if ln_conreg > 0 then
      pc_valcam := 'S';
      select 'El cliente fue asignado el  ' || dfecasi || ' a: ' || ccodusu
        into pc_mensaje
        from acdasig
       where ncodact = 7
         and ncodbas = 3 --2
         and cnumdoc = ls_numdoc
         and npaicli = npaicli
         and ntipdoc = pc_tipdoc;
    else
      pc_valcam := 'N';
    end if;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_asigotroas;

  procedure sp_misti_idenuevcam(pc_codpai  varchar2,
                                pc_tipdoc  varchar2,
                                pc_numdoc  varchar2,
                                pc_idennue out varchar2,
                                pc_codcod  out varchar2,
                                pc_codcol  out varchar2,
                                pc_codtit  out varchar2,
                                lc_liscur  out types.cursor_type,
                                ps_coderr  out char,
                                ps_msgerr  out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_idenuevcam
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : ID nuevo cliente campana
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ls_corcli   number(20);
    ln_corcli   number(20);
    ln_valpar   number(12, 2);
    lc_codmon   char(1);
    ln_monto    number(12, 2);
    ln_moncom   number(12, 2);
    ln_valadi   number(12, 2);
    ln_actfij   number(12, 2);
    ln_fij12m   number(12, 2);
    ln_ratcuo   number(12, 6);
    ls_desseg   varchar2(100);
    ln_connuevo number;
    ls_numdoc   char(12);
    ls_fecha    date;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := pc_numdoc;
  
    select count(*)
      into ln_connuevo
      from JAQY346C
     where JAQY346Cpai = pc_codpai
       and Jaqy346ctdo = pc_tipdoc
       and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
  
    if ln_connuevo > 0 then
      pc_idennue := 'S';
    else
      pc_idennue := 'N';
    end if;
  
    select cdesatr
      into pc_codcod
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '1';
  
    select cdesatr
      into pc_codcol
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '2';
  
    select cdesatr
      into pc_codtit
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '3';
  
    if pc_idennue = 'S' then
    
      select jaqy346cmnto, jaqy346cfech, JAQY346CAU
        into ln_monto, ls_fecha, ln_moncom
        from JAQY346C
       where JAQY346Cpai = pc_codpai
         and Jaqy346ctdo = pc_tipdoc
         and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
    
      open lc_liscur for
        select etiqueta, valor
          from (select 1 as num,
                       'Mayor monto de endeudamiento en desembolso' as etiqueta,
                       coalesce(to_char(TO_CHAR(ln_monto, 'FM999,999,999')),
                                '') as valor
                  from dual
                union
                select 2 as num,
                       'Fecha mayor monto de endeudamiento' as etiqueta,
                       coalesce(to_char(ls_fecha, 'DD/MM/YYYY'), '') as valor
                  from dual
                union
                select 3 as num,
                       'Monto para compartir deuda' as etiqueta,
                       coalesce(to_char(TO_CHAR(ln_moncom, 'FM999,999,999')),
                                '') as valor
                  from dual
                
                ) a
         order by num;
    end if;
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_idenuevcam;

  procedure sp_misti_exiscam(pc_codcod out varchar2,
                             ps_coderr out char,
                             ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_exiscam
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Existe camapana
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    select cdesatr
      into pc_codcod
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '4';
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_exiscam;

  function fn_ocupa_Cliente(pn_CodPai in number,
                            pn_TipDoc in number,
                            ps_NumDoc in varchar2) return number is
    ln_SitLab number(2) := 0;
    ls_NumDoc varchar2(12) := '';
  begin
  
    ls_NumDoc := rpad(ps_NumDoc, 12, ' ');
  
    select c07.segcod
      into ln_SitLab
      from sngc07 c07
     where c07.sngc07cod =
           (select gc_60.sngc60ocup
              from sngc60 gc_60
             where gc_60.sngc60pais = pn_CodPai
               and gc_60.sngc60tdoc = pn_TipDoc
               and gc_60.sngc60ndoc = ls_NumDoc
               and gc_60.sngc60corr =
                   (select max(gc_60a.sngc60corr)
                      from sngc60 gc_60a
                     where gc_60a.sngc60pais = pn_CodPai
                       and gc_60a.sngc60tdoc = pn_TipDoc
                       and gc_60a.sngc60ndoc = ls_NumDoc));
    return ln_SitLab;
  end fn_ocupa_Cliente;

  procedure sp_reprclimi
  -- *****************************************************************
    -- Nombre                     : sp_reprclimi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/102017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reprogramar clientes de Misti, cuando registran oportunidad
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    declare
      ps_msgerr varchar2(1000);
      ps_coderr varchar2(100);
      ls_fecing varchar2(8);
      ln_corasi number(20);
      ln_corage number(20);
      cursor p_base is
        select asi.*, ro.jaql721feco, ro.jaql721hora
          from jaql721 ro
         inner join acdasig asi
            on asi.ntipdoc = ro.jaql721tido
           and asi.cnumdoc = ro.jaql721nudo
           and asi.ccodusu = cast(ro.jaql721user as char(10))
           and asi.cestado = '1'
           and asi.ncodact = 7
         where ro.jaql721fere >= to_date(ls_fecing, 'YYYYMMDD');
    
    begin
      select cdesatr
        into ls_fecing
        from acdatri
       where ncodtab = 20
         and ccodatr = 1
         and ctipatr = 'D';
    
      for v_reg in p_base loop
        begin
          ln_corasi := v_reg.ncorasi;
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = ln_corasi;
        
          update acdasig set cestado = '2' where ncorasi = ln_corasi;
        
          insert into achrevi
            select *
              from acdrevi
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdrevi
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdrevi
          values
            (ln_corage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             155,
             TO_CHAR(sysdate, 'DD/MM/YYYY'),
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          insert into acdrevi
          values
            (ln_corage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             156,
             'Camapana Misti',
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          update acdagen set cestado = '2' where ncorage = ln_corage;
        
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(v_reg.jaql721feco),
                   to_char(v_reg.jaql721hora),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = ln_corasi;
          commit;
        exception
          when no_data_found then
            rollback;
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
          when others then
            rollback;
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
        end;
      end LOOP;
    end;
  
  end sp_reprclimi;

  procedure sp_prsclimi
  -- *****************************************************************
    -- Nombre                     : sp_prsclimi
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/102017
    -- Autor de Creación          : BDEG
    -- Uso                        : Presolicitud de clientes campaña de navidad
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    declare
      ps_msgerr varchar2(1000);
      ps_coderr varchar2(100);
      ls_fecing varchar2(8);
      ln_corasi number(20);
      ln_corage number(20);
      cursor p_base is
        select asi.*
          from jaqm80 ps
         inner join acdasig asi
            on ps.jaqm80pa = asi.npaicli
           and ps.jaqm80td = asi.ntipdoc
           and ps.jaqm80nd = cast(asi.cnumdoc as char(12))
           and asi.ncodact = 7
           and ps.jaqm80as = asi.ccodusu
           and ps.jaqm80es = 'I'
         where ps.jaqm80fc >= to_date(ls_fecing, 'YYYYMMDD')
           and asi.cestado = 1;
    
    begin
      select cdesatr
        into ls_fecing
        from acdatri
       where ncodtab = 20
         and ccodatr = 1
         and ctipatr = 'D';
    
      for v_reg in p_base loop
        begin
          ln_corasi := v_reg.ncorasi;
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = ln_corasi;
        
          update acdasig set cestado = '2' where ncorasi = ln_corasi;
        
          insert into achrevi
            select *
              from acdrevi
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdrevi
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdrevi
          values
            (ln_corage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             148,
             TO_CHAR(sysdate, 'DD/MM/YYYY'),
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          insert into acdrevi
          values
            (ln_corage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             149,
             'Camapana Misti',
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          update acdagen set cestado = '2' where ncorage = ln_corage;
        
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = ln_corasi;
          commit;
        exception
          when no_data_found then
            rollback;
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
          when others then
            rollback;
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
        end;
      end LOOP;
    end;
  
  end sp_prsclimi;

  procedure sp_roreprogramarmisti2
  -- *****************************************************************
    -- Nombre                     : sp_roreprogramarmisti2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/102017
    -- Autor de Creación          : BDEG
    -- Uso                        : Reprogramar cliente en misti, agendado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    declare
      ps_msgerr varchar2(1000);
      ps_coderr varchar2(100);
      ls_fecing varchar2(8);
      ln_corage number(20);
      cursor p_base is
        select age.*, jaql721feco, jaql721hora
          from acdagen age
         inner join acdrevi rev
            on rev.cnumdoc = age.cnumdoc
           and rev.ntipdoc = age.ntipdoc
           and rev.npaicli = age.npaicli
           and rev.ncodact = age.ncodact
           and rev.nrespue = 155
         inner join jaql721 ro
            on ro.jaql721nudo = age.cnumdoc
           and ro.jaql721tido = age.ntipdoc
         where age.cestado = 1
           and age.dfecvis = trunc(sysdate)
           and age.ncodact = 7
           and ro.jaql721fere = trunc(sysdate)
           and rev.dfecvis <> trunc(sysdate);
    
    begin
      for v_reg in p_base loop
        begin
        
          update acdagen set cestado = '2' where ncorage = v_reg.ncorage;
        
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
        
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          insert into achrevi
            select *
              from acdrevi
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdrevi
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdrevi
          values
            (v_reg.ncorage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             155,
             TO_CHAR(sysdate, 'DD/MM/YYYY'),
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          insert into acdrevi
          values
            (v_reg.ncorage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             156,
             'Camapana Misti',
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          update acdagen set cestado = '2' where ncorage = ln_corage;
        
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(v_reg.jaql721feco),
                   to_char(v_reg.jaql721hora),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = v_reg.ncorasi;
          commit;
        exception
          when no_data_found then
            rollback;
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
          when others then
            rollback;
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
        end;
      end LOOP;
    end;
  
  end sp_roreprogramarmisti2;

  procedure sp_psreprogramarmisti2
  -- *****************************************************************
    -- Nombre                     : sp_psreprogramarmisti2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/102017
    -- Autor de Creación          : BDEG
    -- Uso                        : Presolicitud de clientes campaña de navidad reprogramado
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    declare
      ps_msgerr varchar2(1000);
      ps_coderr varchar2(100);
      ls_fecing varchar2(8);
      ln_corasi number(20);
      ln_corage number(20);
      cursor p_base is
        select age.*
          from acdagen age
         inner join acdrevi rev
            on rev.cnumdoc = age.cnumdoc
           and rev.ntipdoc = age.ntipdoc
           and rev.npaicli = age.npaicli
           and rev.ncodact = age.ncodact
           and rev.nrespue = 155
        
         inner join jaqm80 ps
            on ps.jaqm80pa = age.npaicli
           and ps.jaqm80td = age.ntipdoc
           and ps.jaqm80nd = cast(age.cnumdoc as char(12))
           and ps.jaqm80es = 'I'
         where age.cestado = 1
           and age.ncodact = 7
           and ps.jaqm80fc = trunc(sysdate);
      --and rev.dfecvis <> trunc(sysdate);
    
    begin
    
      for v_reg in p_base loop
        begin
        
          update acdagen set cestado = '2' where ncorage = v_reg.ncorage;
        
          insert into achrevi
            select *
              from acdrevi
             where cnumdoc = v_reg.cnumdoc
               and ntipdoc = v_reg.ntipdoc
               and npaicli = v_reg.npaicli
               and ncodact = v_reg.ncodact;
        
          delete acdrevi
           where cnumdoc = v_reg.cnumdoc
             and ntipdoc = v_reg.ntipdoc
             and npaicli = v_reg.npaicli
             and ncodact = v_reg.ncodact;
        
          insert into acdrevi
          values
            (v_reg.ncorage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             148,
             TO_CHAR(sysdate, 'DD/MM/YYYY'),
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          insert into acdrevi
          values
            (v_reg.ncorage,
             v_reg.nidebas,
             v_reg.nidepro,
             v_reg.ncoding,
             v_reg.ncodact,
             v_reg.ncodbas,
             v_reg.npaicli,
             v_reg.ntipdoc,
             trim(v_reg.cnumdoc),
             149,
             'Camapana Misti',
             '1',
             upper(trim(v_reg.ccodusu)),
             trunc(sysdate),
             to_char(sysdate, 'HH24:Mi'),
             0,
             0);
        
          update acdagen set cestado = '2' where ncorage = ln_corage;
        
          insert into achagen
            select *
              from acdagen age
             where age.cnumdoc = v_reg.cnumdoc
               and age.ntipdoc = v_reg.ntipdoc
               and age.npaicli = v_reg.npaicli
               and age.ncodact = v_reg.ncodact;
          delete acdagen age
           where age.cnumdoc = v_reg.cnumdoc
             and age.ntipdoc = v_reg.ntipdoc
             and age.npaicli = v_reg.npaicli
             and age.ncodact = v_reg.ncodact;
        
          ln_corage := supplier_seq.NEXTVAL;
        
          insert into acdagen
            select ln_corage,
                   nidebas,
                   nidepro,
                   ncoding,
                   ncodact,
                   ncodbas,
                   npaicli,
                   ntipdoc,
                   cnumdoc,
                   '1',
                   trunc(sysdate),
                   dfecasi,
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:Mi'),
                   upper(trim(v_reg.ccodusu)),
                   upper(trim(v_reg.ccodusu)),
                   sysdate,
                   '0',
                   ncorasi,
                   0,
                   0
              from acdasig
             where ncorasi = ln_corasi;
          commit;
        exception
          when no_data_found then
            rollback;
            ps_coderr := '00011';
            ps_msgerr := 'NO HAY DATOS';
          when others then
            rollback;
            ps_coderr := '00099';
            ps_msgerr := SQLERRM;
        end;
      end LOOP;
    end;
  
  end sp_psreprogramarmisti2;

  procedure sp_misti_valcampa(pc_codpai varchar2,
                              pc_tipdoc varchar2,
                              pc_numdoc varchar2,
                              pc_codusu varchar2,
                              pc_otroas out varchar2,
                              pc_menase out varchar2,
                              pc_indrec out varchar2,
                              pc_indcam out varchar2,
                              ps_coderr out char,
                              ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_valcampa
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/10/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Valores de la campaña
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    lc_codusu   varchar2(10);
    ln_connuevo number;
    ls_numdoc   char(12);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := pc_numdoc;
    -- retornar actividad y base a partir del documento  
  
    begin
      select upper(trim(ccodusu)) --, ncodact, ncodbas
        into lc_codusu --, pn_codact, pn_codbas
        from acdasig
       where ncodact = 7
         and ncodbas = 3 --2
         and npaicli = pc_codpai
         and ntipdoc = pc_tipdoc
         and cnumdoc = pc_numdoc;
    
      pc_indrec := 'S';
      pc_indcam := 'S';
    exception
      when no_data_found then
        lc_codusu := null;
        pc_indrec := 'N';
      when others then
        lc_codusu := null;
        pc_indrec := 'N';
    end;
  
    if (lc_codusu = upper(trim(pc_codusu))) then
      pc_otroas := 'N';
    else
      if (lc_codusu is null) then
        pc_otroas := 'N';
      else
      
        pc_otroas := 'S';
        select 'El cliente fue asignado el  ' || dfecasi || ' a: ' ||
               cnomope
          into pc_menase
          from acdasig asi
         inner join acmoper
            on ccodope = trim(ccodusu)
         where ncodact = 7
           and cnumdoc = pc_numdoc
           and npaicli = pc_codpai
           and ntipdoc = pc_tipdoc;
      end if;
    end if;
  
    if (pc_indrec = 'N') then
    
      select count(*)
        into ln_connuevo
        from JAQY346C
       where JAQY346Cpai = pc_codpai
         and Jaqy346ctdo = pc_tipdoc
         and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
    
      if ln_connuevo > 0 then
        pc_indcam := 'S';
      else
        pc_indcam := 'N';
      end if;
    
    end if;
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_misti_valcampa;

  procedure sp_misti_listacampana(ps_codusu varchar2,
                                  lc_liscur out types.cursor_type,
                                  ps_coderr out char,
                                  ps_msgerr out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de clientes por visitar en misti por usuario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
    ls_codubi varchar2(6);
    ls_codusu varchar2(12);
    ln_canreg number;
    ld_fecing date;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    select sysdate into ld_fecing from dual;
    open lc_liscur for
      select *
        from (select eva.npaicli,
                     tip.cdesatr  as ctipdoc,
                     eva.ntipdoc,
                     eva.cnumdoc,
                     eva.cclinom,
                     ubin.cdesdep as cdepneg,
                     ubin.cdespro as cproneg,
                     ubin.cdesdis as cdisneg,
                     ubid.cdesdep as cdepdom,
                     ubid.cdespro as cprodom,
                     ubid.cdesdis as cdisdom
                from acdasig age
               inner join acdatri tip
                  on tip.ncodtab = 6
                 and tip.ccodatr = age.ntipdoc
                 and tip.cestado = '1'
               inner join (select *
                            from acdeval
                           where nindcier = 0
                          union
                          select *
                            from acheval
                           where nindcier = 0) eva
                  on eva.ncorcli = age.ncorcli
                left join actugeo ubid
                  on ubid.cubigeo = eva.czonfij
                left join actugeo ubin
                  on ubin.cubigeo = eva.czonneg
               where age.ncodact = 7
                 and age.cestado = '1'
                 and trim(age.ccodusu) = upper(ps_codusu)
              union
              select eva.npaicli,
                     tip.cdesatr  as ctipdoc,
                     eva.ntipdoc,
                     eva.cnumdoc,
                     eva.cclinom,
                     ubin.cdesdep as cdepneg,
                     ubin.cdespro as cproneg,
                     ubin.cdesdis as cdisneg,
                     ubid.cdesdep as cdepdom,
                     ubid.cdespro as cprodom,
                     ubid.cdesdis as cdisdom
                from acdagen age
               inner join acdatri tip
                  on tip.ncodtab = 6
                 and tip.ccodatr = age.ntipdoc
                 and tip.cestado = '1'
               inner join acdasig asi
                  on asi.ncorasi = age.ncorasi
               inner join (select *
                            from acdeval
                           where nindcier = 0
                          union
                          select *
                            from acheval
                           where nindcier = 0) eva
                  on eva.ncorcli = asi.ncorcli
                left join actugeo ubid
                  on ubid.cubigeo = eva.czonfij
                left join actugeo ubin
                  on ubin.cubigeo = eva.czonneg
               where age.ncodact = 7
                 and age.cestado = '1'
                 and age.dfecvis = trunc(sysdate)
                 and trim(age.ccodusu) = upper(ps_codusu)
                 and age.ncorasi not in
                     (select distinct ncorasi
                        from achagen
                       where ncorage in
                             (select ncorage from acdrevi where nrespue = 148))) a;
  
    select count(*)
      into ln_canreg
      from (select eva.npaicli,
                   tip.cdesatr  as ctipdoc,
                   eva.ntipdoc,
                   eva.cnumdoc,
                   eva.cclinom,
                   ubin.cdesdep as cdepneg,
                   ubin.cdespro as cproneg,
                   ubin.cdesdis as cdisneg,
                   ubid.cdesdep as cdepdom,
                   ubid.cdespro as cprodom,
                   ubid.cdesdis as cdisdom
              from acdasig age
             inner join acdatri tip
                on tip.ncodtab = 6
               and tip.ccodatr = age.ntipdoc
               and tip.cestado = '1'
             inner join (select *
                          from acdeval
                         where nindcier = 0
                        union
                        select *
                          from acheval
                         where nindcier = 0) eva
                on eva.ncorcli = age.ncorcli
              left join actugeo ubid
                on ubid.cubigeo = eva.czonfij
              left join actugeo ubin
                on ubin.cubigeo = eva.czonneg
             where age.ncodact = 7
               and age.cestado = '1'
               and trim(age.ccodusu) = upper(ps_codusu)
            union
            select eva.npaicli,
                   tip.cdesatr  as ctipdoc,
                   eva.ntipdoc,
                   eva.cnumdoc,
                   eva.cclinom,
                   ubin.cdesdep as cdepneg,
                   ubin.cdespro as cproneg,
                   ubin.cdesdis as cdisneg,
                   ubid.cdesdep as cdepdom,
                   ubid.cdespro as cprodom,
                   ubid.cdesdis as cdisdom
              from acdagen age
             inner join acdatri tip
                on tip.ncodtab = 6
               and tip.ccodatr = age.ntipdoc
               and tip.cestado = '1'
             inner join acdasig asi
                on asi.ncorasi = age.ncorasi
             inner join (select *
                          from acdeval
                         where nindcier = 0
                        union
                        select *
                          from acheval
                         where nindcier = 0) eva
                on eva.ncorcli = asi.ncorcli
              left join actugeo ubid
                on ubid.cubigeo = eva.czonfij
              left join actugeo ubin
                on ubin.cubigeo = eva.czonneg
             where age.ncodact = 7
               and age.cestado = '1'
               and age.dfecvis = trunc(sysdate)
               and trim(age.ccodusu) = upper(ps_codusu)
               and age.ncorasi not in
                   (select distinct ncorasi
                      from achagen
                     where ncorage in
                           (select ncorage from acdrevi where nrespue = 148))) a;
  
    insert into actlgmi
    values
      (null,
       null,
       null,
       null,
       3,
       ps_codusu,
       null,
       ld_fecing,
       sysdate,
       ln_canreg);
    commit;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_listacampana;

  procedure sp_misti_cieges(pc_codpai varchar2,
                            pc_tipdoc varchar2,
                            pc_numdoc varchar2,
                            pc_codusu varchar2,
                            ps_coderr out char,
                            ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_cieges
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/10/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Cierre de gestión
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    lc_codusu   varchar2(10);
    ln_connuevo number;
    ls_numdoc   char(12);
    ln_indest   number;
    ln_corage   number(20);
    ln_corasi   number(20);
    ln_idebas   number;
    ln_idepro   number;
    ln_coding   number;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := pc_numdoc;
  
    select upper(trim(ccodusu)),
           cestado,
           ncorasi,
           nidebas,
           nidepro,
           ncoding
      into lc_codusu, ln_indest, ln_corasi, ln_idebas, ln_idepro, ln_coding
      from acdasig asi
     inner join (select ncorcli
                   from acdeval
                  where nindcier = 0
                 union
                 select ncorcli
                   from acheval
                  where nindcier = 0) eva
        on eva.ncorcli = asi.ncorcli
     where asi.ncodact = 7
       and asi.ntipdoc = pc_tipdoc
       and asi.cnumdoc = pc_numdoc
       and asi.npaicli = pc_codpai;
  
    if (lc_codusu = upper(trim(pc_codusu))) then
      if (ln_indest = '1') then
        insert into achagen
          select *
            from acdagen age
           where age.cnumdoc = pc_numdoc
             and age.ntipdoc = pc_tipdoc
             and age.npaicli = pc_codpai
             and age.ncodact = 7;
        delete acdagen age
         where age.cnumdoc = pc_numdoc
           and age.ntipdoc = pc_tipdoc
           and age.npaicli = pc_codpai
           and age.ncodact = 7;
      
        ln_corage := supplier_seq.NEXTVAL;
      
        insert into acdagen
          select ln_corage,
                 nidebas,
                 nidepro,
                 ncoding,
                 ncodact,
                 ncodbas,
                 npaicli,
                 ntipdoc,
                 cnumdoc,
                 '1',
                 trunc(sysdate),
                 dfecasi,
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:Mi'),
                 upper(trim(pc_codusu)),
                 upper(trim(pc_codusu)),
                 sysdate,
                 '0',
                 ncorasi,
                 0,
                 0
            from acdasig
           where ncorasi = ln_corasi;
      
        update acdasig set cestado = '2' where ncorasi = ln_corasi;
      
        insert into achrevi
          select *
            from acdrevi
           where cnumdoc = pc_numdoc
             and ntipdoc = pc_tipdoc
             and npaicli = pc_codpai
             and ncodact = 7;
      
        delete acdrevi
         where cnumdoc = pc_numdoc
           and ntipdoc = pc_tipdoc
           and npaicli = pc_codpai
           and ncodact = 7;
      
        insert into acdrevi
        values
          (ln_corage,
           ln_idebas,
           ln_idepro,
           ln_coding,
           7,
           1,
           pc_codpai,
           pc_tipdoc,
           trim(pc_numdoc),
           144,
           'Campana Misti',
           '1',
           upper(trim(pc_codusu)),
           trunc(sysdate),
           to_char(sysdate, 'HH24:Mi'),
           0,
           0);
      
        update acdagen set cestado = '2' where ncorage = ln_corage;
      end if;
    
      if (ln_indest = '2') then
        select ncorage
          into ln_corage
          from acdagen
         where cnumdoc = pc_numdoc
           and ntipdoc = pc_tipdoc
           and npaicli = pc_codpai
           and ncodact = 7;
        insert into achrevi
          select *
            from acdrevi
           where cnumdoc = pc_numdoc
             and ntipdoc = pc_tipdoc
             and npaicli = pc_codpai
             and ncodact = 7;
      
        delete acdrevi
         where cnumdoc = pc_numdoc
           and ntipdoc = pc_tipdoc
           and npaicli = pc_codpai
           and ncodact = 7;
      
        insert into acdrevi
        values
          (ln_corage,
           ln_idebas,
           ln_idepro,
           ln_coding,
           7,
           1,
           pc_codpai,
           pc_tipdoc,
           trim(pc_numdoc),
           144,
           'Campana Misti',
           '1',
           upper(trim(pc_codusu)),
           trunc(sysdate),
           to_char(sysdate, 'HH24:Mi'),
           0,
           0);
      
        update acdagen set cestado = '2' where ncorage = ln_corage;
      end if;
    
      update acdeval
         set nindcier = '1', ccodest = '2'
       where cnumdoc = pc_numdoc
         and ntipdoc = pc_tipdoc
         and npaicli = pc_codpai
         and ncodact = 7;
      update acheval
         set nindcier = '1', ccodest = '2'
       where cnumdoc = pc_numdoc
         and ntipdoc = pc_tipdoc
         and npaicli = pc_codpai
         and ncodact = 7;
      commit;
    else
      ps_coderr := '00012';
      ps_msgerr := 'USUARIO NO CORRESPONDE';
    end if;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_cieges;

  procedure sp_misti_ejepro(ps_coderr out char, ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_cieges
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/10/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Cierre de gestión
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    sp_prsclimi;
    sp_reprclimi;
    sp_psreprogramarmisti2;
    sp_roreprogramarmisti2;
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_ejepro;

  procedure sp_lisusuagetran2(ls_nomusu varchar2,
                              lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusuagetran2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/13/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Listado de usuarios separado por comas para transferir
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_codrol number;
  begin
    select ccodcar
      into ls_codrol
      from acmoper
     where ccodope = upper(ls_nomusu)
       and ccodest = 1;
  
    if ls_codrol in (6) then
      open lc_liscur for
        select pu.ncodsuc, op.ccodope, cnomope
          from acmoper op
         inner join acdagus pu
            on pu.ccodope = op.ccodope
         where pu.ccodest = '1'
           and pu.ncodsuc is not null
         order by pu.ncodsuc, op.cnomope;
    
    end if;
    if ls_codrol in (50, 51, 52, 200, 201, 104, 103) then
      open lc_liscur for
        select pu.ncodsuc, op.ccodope, cnomope
          from acmoper op
         inner join acdagus pu
            on pu.ccodope = op.ccodope
         where pu.ccodest = '1'
           and pu.ncodsuc is not null
           and op.ccodcar in (50, 51, 52, 200, 201, 104, 103)
           and op.ccodest = 1
         order by pu.ncodsuc, op.cnomope;
    
    end if;
    -- 2018/05/22 Adicion de 200,201 WCRW
    if ls_codrol in
       (202, 101, 8, 105, 107, 900, 11, 12, 671, 13, 14, 15, 16,17) then
      open lc_liscur for
        select pu.ncodsuc, op.ccodope, cnomope
          from acmoper op
         inner join acdagus pu
            on pu.ccodope = op.ccodope
         where pu.ccodest = '1'
           and pu.ncodsuc is not null
           and op.ccodcar in
               (202, 201, 200, 101, 8, 105, 107, 12, 11, 13, 14, 15, 16,17)
           and op.ccodest = 1
         order by pu.ncodsuc, op.cnomope;
    end if;
  
    if ls_codrol in (105, 8, 13, 15) then
      open lc_liscur for
        select pu.ncodsuc, op.ccodope, cnomope
          from acmoper op
         inner join acdagus pu
            on pu.ccodope = op.ccodope
         where pu.ccodest = '1'
           and pu.ncodsuc is not null
         order by pu.ncodsuc, op.cnomope;
    end if;
  
    if ls_codrol in (102, 7, 10, 9, 108) then
      open lc_liscur for
        select pu.ncodsuc, op.ccodope, cnomope
          from acmoper op
         inner join acdagus pu
            on pu.ccodope = op.ccodope
         where pu.ccodest = '1'
           and pu.ncodsuc is not null
           and op.ccodcar in (102, 7, 10, 9, 108)
           and op.ccodest = 1
         order by pu.ncodsuc, op.cnomope;
    
    end if;
  
  end sp_lisusuagetran2;

  procedure sp_listipreac(ps_tipreac varchar2,
                          lc_liscur  out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_listipreac
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/12/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista el tipode reacciones
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    if ps_tipreac = 'C' then
      open lc_liscur for
        select ncodres
          from acdresu
         where cestado = 1
           and nindcas in (1, 5, 6);
    else
      open lc_liscur for
        select ncodres
          from acdresu
         where cestado = 1
           and nindcas in (2);
    end if;
  
  end sp_listipreac;

  procedure SP_CerrarEnBloque as
  
    -- *****************************************************************
    -- Nombre                     : SP_CerrarEnBloque
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/02/2018
    -- Autor de Creación          : BDEG
    -- Uso                        : Procedimiento que cierra gestiones en bloque
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 
  
  begin
    declare
      ln_corcli number(20);
      ls_coderr varchar2(1000);
      ls_msgerr varchar2(2000);
      cursor p_base is
        select * from jaqz928 where jaqz928esteje = 0;
    begin
      for v_reg in p_base loop
        ln_corcli := v_reg.jaqz928corcli;
        begin
          PQ_AGENDA_COMERCIAL.sp_desbloquear2(ln_corcli, 'SYSADM',
                                              ls_coderr, ls_msgerr);
          update jaqz928
             set jaqz928feceje = sysdate, jaqz928esteje = '1'
           where jaqz928corcli = ln_corcli;
        exception
          when no_data_found then
            update jaqz928
               set jaqz928feceje = sysdate, jaqz928esteje = '2'
             where jaqz928corcli = ln_corcli;
          when others then
            update jaqz928
               set jaqz928feceje = sysdate, jaqz928esteje = '2'
             where jaqz928corcli = ln_corcli;
        end;
        commit;
      end LOOP;
    end;
  end SP_CerrarEnBloque;

  procedure sp_codsegmento(ps_nomseg varchar2, ps_codseg out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_codsegmento
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/02/2018
    -- Autor de Creación          : BDEG
    -- Uso                        : Retorna el código de segmento
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ls_nombre VARCHAR2(200);
  begin
    ps_codseg := 0;
    ls_nombre := upper(trim(ps_nomseg));
    select max(jaqy067ccal)
      into ps_codseg
      from jaqy067
     where jaqy067ncal = ls_nombre;
  
  exception
    when no_data_found then
      ps_codseg := 0;
    when others then
      ps_codseg := 0;
  end sp_codsegmento;

  --// 2018.05.29 JPINTO - FIN

  procedure sp_obtenerCampanias(BL_DATOS  IN OUT SYS_REFCURSOR,
                                pc_coderr out char,
                                pc_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_obtenerCampañas
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/02/2018
    -- Autor de Creación          : BDEG
    -- Uso                        : Retorna el código de segmento
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    --/
    pc_coderr := '00000';
    pc_msgerr := '';
    --//
    OPEN BL_DATOS for
      select t1.tp1nro1 c_codact,
             t1.tp1nro2 c_codbas,
             t1.tp1nro3 c_estado,
             t1.tp1desc c_descri
        from fst198 t1
       where tp1cod = 1
         and tp1cod1 = 10801
         and tp1corr1 = 310
         and t1.tp1corr2 > 0
         and t1.tp1corr3 = 1
         and t1.tp1nro3 = 1
       order by t1.tp1nro1, t1.tp1nro2, t1.tp1corr3;
  exception
    when others then
      pc_coderr := '00000';
      pc_msgerr := '';
  end sp_obtenerCampanias;

  procedure sp_misti_tracli2(pc_corage varchar2,
                             pc_tiping varchar2,
                             pc_paicli varchar2,
                             pc_tipdoc varchar2,
                             pc_numdoc varchar2,
                             pc_codcod out varchar2, -- codbas + 2000
                             pc_codcol out varchar2, -- codigo del color
                             pc_codtit out varchar2, -- codigo dle titulo 
                             pn_codact number,
                             pn_codbas number,
                             lc_liscur out types.cursor_type,
                             ps_coderr out char,
                             ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_tracli
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Misti trama cliente
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ls_corcli number(20);
    ln_corcli number(20);
    ln_valpar varchar2(100);
    lc_codmon char(1);
    ln_captra varchar2(100);
    ln_valadi varchar2(100);
    ln_actfij varchar2(100);
    ln_fij12m varchar2(100);
    ln_ratcuo varchar2(100);
    --//
    ls_desseg varchar2(100);
    ls_valadi varchar2(1000);
    ls_valpar varchar2(1000);
    ls_ratcuo varchar2(1000);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    /*  
    select cdesatr
      into pc_codcod
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '1';
    
    select cdesatr
      into pc_codcol
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '2';
    
    select cdesatr
      into pc_codtit
      from acdatri
     where ncodtab = 19
       and ctipatr = 'D'
       and ccodatr = '3';
    */
  
    begin
      select t1.tp1desc
        into pc_codcod
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 2
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcod := '0';
    end;
  
    begin
      select t1.tp1desc
        into pc_codcol
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 3
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := '000000';
    end;
  
    begin
      select t1.tp1desc
        into pc_codtit
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 1
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := 'NO HAY CAMPAÑA';
    end;
  
    if pc_tiping = '1' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli, ncorasi
                from acdasig
              union
              select ncorcli, ncorasi
                from achasig) a
       where ncorasi in
             (select ncorasi from acdagen where ncorage = pc_corage);
    end if;
    if pc_tiping = '2' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select ncorcli, ncorasi
                from acdasig
              union
              select ncorcli, ncorasi
                from achasig) a
       where ncorasi = pc_corage;
    
    end if;
  
    if pc_tiping = '3' then
      -- CorAGE
      select max(ncorcli)
        into ls_corcli
        from (select nvl(ncorcli, 0) ncorcli
                from acdeval
               where npaicli = pc_paicli
                 and ntipdoc = pc_tipdoc
                 and cnumdoc = pc_numdoc
                 and ncodact = pn_codact
                 and ncodbas = pn_codbas
              union
              select ncorcli
                from acheval
               where npaicli = pc_paicli
                 and ntipdoc = pc_tipdoc
                 and cnumdoc = pc_numdoc
                 and ncodact = pn_codact
                 and ncodbas = pn_codbas) a;
    
    end if;
  
    select NVALPAR, NVALADI, NRATCUO, csegdes, NACTFIJ, NFIJ12M, NCAPTRA
      into ln_valpar,
           ln_valadi,
           ln_ratcuo,
           ls_desseg,
           ln_actfij,
           ln_fij12m,
           ln_captra
      from actacca
     where ncorcli = ls_corcli
       and rownum = 1;
  
    if pn_codbas in (4, 9, 10, 11, 12, 13, 14, 15) then
      --//
      if pn_codbas = 4 then
        --// 
        select a1.NVALADI, a1.NVALPAR, a1.CSEGDES
          into ls_valadi, ls_valpar, ls_desseg
          from actacca a1
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (
                  
                  select 1 as num,
                          'Oferta : ' as etiqueta,
                          coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
        --//
      elsif pn_codbas = 15 then
        --//         
        select csegdes, nvaladi, nvalpar
          into ls_desseg, ls_valadi, ls_valpar
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Comprar Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valadi), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Compartir Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valpar), '') as valor
                    from dual
                  union
                  select 3 as num,
                         'Segmento : ' as etiqueta,
                         coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
        --//  
      elsif pn_codbas = 14 then
        --//         
        select csegdes, trim(TO_CHAR(nratcuo, '999,999,999.99'))
          into ls_desseg, ls_ratcuo
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Oferta : ' as etiqueta,
                         coalesce(TO_CHAR(ls_ratcuo), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Segmento : ' as etiqueta,
                         coalesce(TO_CHAR(ls_desseg), '') as valor
                    from dual) a
           order by num;
      
        --//  
      elsif pn_codbas = 13 then
        --//         
        select csegdes, nvaladi, nvalpar
          into ls_desseg, ls_valadi, ls_valpar
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Comprar Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valadi), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Compartir Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valpar), '') as valor
                    from dual
                  union
                  select 3 as num,
                         'Segmento Micro : ' as etiqueta,
                         coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
      
        --//  
      elsif pn_codbas = 12 then
        --//         
        select csegdes, nratcuo
          into ls_desseg, ls_ratcuo
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Oferta : ' as etiqueta,
                         coalesce(TO_CHAR(ls_ratcuo), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Segmento : ' as etiqueta,
                         coalesce(TO_CHAR(ls_desseg), '') as valor
                    from dual) a
           order by num;
      
        --//  
      elsif pn_codbas = 11 then
        --//         
        select csegdes, nvaladi, nvalpar
          into ls_desseg, ls_valadi, ls_valpar
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Comprar Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valadi), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Compartir Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valpar), '') as valor
                    from dual
                  union
                  select 3 as num,
                         'Segmento : ' as etiqueta,
                         coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
      
        --//  
      elsif pn_codbas = 10 then
        --//         
        select csegdes, nvaladi, nvalpar, nratcuo
          into ls_desseg, ls_valadi, ls_valpar, ls_ratcuo
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Comprar Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valadi), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Compartir Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valpar), '') as valor
                    from dual
                  union
                  select 3 as num,
                         'Oferta : ' as etiqueta,
                         coalesce(TO_CHAR(ls_ratcuo), '') as valor
                    from dual
                  union
                  select 4 as num,
                         'Segmento Micro : ' as etiqueta,
                         coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
        --//
      elsif pn_codbas = 9 then
        --//         
        select csegdes, nvaladi, nvalpar
          into ls_desseg, ls_valadi, ls_valpar
          from actacca
         where ncorcli = ls_corcli
           and rownum = 1;
        --//
        open lc_liscur for
          select etiqueta, valor
            from (select 1 as num,
                         'Comprar Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valadi), '') as valor
                    from dual
                  union
                  select 2 as num,
                         'Compartir Deuda : ' as etiqueta,
                         coalesce(TO_CHAR(ls_valpar), '') as valor
                    from dual
                  union
                  select 3 as num,
                         'Segmento : ' as etiqueta,
                         coalesce(to_char(ls_desseg), '') as valor
                    from dual) a
           order by num;
        --//  
      end if;
      --//
    else
      open lc_liscur for
        select etiqueta, valor
          from (
                
                select 1 as num,
                        'Capital de trabajo' as etiqueta,
                        coalesce(TO_CHAR(replace(ln_captra, ',', '.'),
                                         'fm999,999,990.90'), '') as valor
                  from dual
                union
                select 2 as num,
                        'Paralelo' as etiqueta,
                        coalesce(TO_CHAR(replace(ln_valpar, ',', '.'),
                                         'fm999,999,990.90'), '') as valor
                  from dual
                union
                select 3 as num,
                        'Adicional' as etiqueta,
                        coalesce(TO_CHAR(replace(ln_valadi, ',', '.'),
                                         'fm999,999,990.90'), '') as valor
                  from dual
                union
                select 4 as num,
                        'Activo Fijo' as etiqueta,
                        coalesce(TO_CHAR(replace(ln_actfij, ',', '.'),
                                         'fm999,999,990.90'), '') as valor
                  from dual
                union
                select 5 as num,
                        'Activo Fijo 12 M' as etiqueta,
                        coalesce(TO_CHAR(replace(ln_fij12m, ',', '.'),
                                         'fm999,999,990.90'), '') as valor
                  from dual
                union
                select 6 as num,
                        'Ratio Cuota / Resultado' as etiqueta,
                        coalesce(to_char(ln_ratcuo), '') || ' %' as valor
                  from dual
                union
                select 7 as num,
                        'Segmento' as etiqueta,
                        coalesce(to_char(ls_desseg), '') as valor
                  from dual
                
                ) a
         order by num;
    end if;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_tracli2;

  procedure sp_misti_listacampana2(ps_codusu varchar2,
                                   pn_codact number,
                                   pn_codbas number,
                                   lc_liscur out types.cursor_type,
                                   ps_coderr out char,
                                   ps_msgerr out varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_misti_lisvis
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/04/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de clientes por visitar en misti por usuario
    -- Estado                     : Activo
    -- Fecha Modificación         : 11/10/2018
    -- Autor de Modificación      : WCRW
    -- Descripcion Modificacion   : Campañas Especiales pn_codbas >= 90
    -- ***************************************************************** 
    ls_codubi varchar2(6);
    ls_codusu varchar2(12);
    ln_canreg number;
    ld_fecing date;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  
    select trunc(sysdate) into ld_fecing from dual;
  
    if pn_codbas < 90 then
      open lc_liscur for
        select *
          from (select eva.npaicli,
                       tip.cdesatr  as ctipdoc,
                       eva.ntipdoc,
                       eva.cnumdoc,
                       eva.cclinom,
                       ubin.cdesdep as cdepneg,
                       ubin.cdespro as cproneg,
                       ubin.cdesdis as cdisneg,
                       ubid.cdesdep as cdepdom,
                       ubid.cdespro as cprodom,
                       ubid.cdesdis as cdisdom
                  from acdasig age
                 inner join acdatri tip
                    on tip.ncodtab = 6
                   and tip.ccodatr = age.ntipdoc
                   and tip.cestado = '1'
                 inner join (select *
                              from acdeval
                             where nindcier = 0
                            union
                            select *
                              from acheval
                             where nindcier = 0) eva
                    on eva.ncorcli = age.ncorcli
                  left join actugeo ubid
                    on ubid.cubigeo = eva.czonfij
                  left join actugeo ubin
                    on ubin.cubigeo = eva.czonneg
                 where age.ncodact = pn_codact
                   and age.ncodbas = pn_codbas
                   and age.cestado = '1'
                   and trim(age.ccodusu) = upper(ps_codusu)
                union
                select eva.npaicli,
                       tip.cdesatr  as ctipdoc,
                       eva.ntipdoc,
                       eva.cnumdoc,
                       eva.cclinom,
                       ubin.cdesdep as cdepneg,
                       ubin.cdespro as cproneg,
                       ubin.cdesdis as cdisneg,
                       ubid.cdesdep as cdepdom,
                       ubid.cdespro as cprodom,
                       ubid.cdesdis as cdisdom
                  from acdagen age
                 inner join acdatri tip
                    on tip.ncodtab = 6
                   and tip.ccodatr = age.ntipdoc
                   and tip.cestado = '1'
                 inner join acdasig asi
                    on asi.ncorasi = age.ncorasi
                 inner join (select *
                              from acdeval
                             where nindcier = 0
                            union
                            select *
                              from acheval
                             where nindcier = 0) eva
                    on eva.ncorcli = asi.ncorcli
                  left join actugeo ubid
                    on ubid.cubigeo = eva.czonfij
                  left join actugeo ubin
                    on ubin.cubigeo = eva.czonneg
                 where age.ncodact = pn_codact
                   and age.ncodbas = pn_codbas
                   and age.cestado = '1'
                   and age.dfecvis = trunc(sysdate)
                   and trim(age.ccodusu) = upper(ps_codusu)
                   and age.ncorasi not in
                       (select distinct ncorasi
                          from achagen
                         where ncorage in (select ncorage
                                             from acdrevi
                                            where nrespue = 148))) a;
    
      select count(*)
        into ln_canreg
        from (select eva.npaicli,
                     tip.cdesatr  as ctipdoc,
                     eva.ntipdoc,
                     eva.cnumdoc,
                     eva.cclinom,
                     ubin.cdesdep as cdepneg,
                     ubin.cdespro as cproneg,
                     ubin.cdesdis as cdisneg,
                     ubid.cdesdep as cdepdom,
                     ubid.cdespro as cprodom,
                     ubid.cdesdis as cdisdom
                from acdasig age
               inner join acdatri tip
                  on tip.ncodtab = 6
                 and tip.ccodatr = age.ntipdoc
                 and tip.cestado = '1'
               inner join (select *
                            from acdeval
                           where nindcier = 0
                          union
                          select *
                            from acheval
                           where nindcier = 0) eva
                  on eva.ncorcli = age.ncorcli
                left join actugeo ubid
                  on ubid.cubigeo = eva.czonfij
                left join actugeo ubin
                  on ubin.cubigeo = eva.czonneg
               where age.ncodact = pn_codact
                 and age.ncodbas = pn_codbas
                 and age.cestado = '1'
                 and trim(age.ccodusu) = upper(ps_codusu)
              union
              select eva.npaicli,
                     tip.cdesatr  as ctipdoc,
                     eva.ntipdoc,
                     eva.cnumdoc,
                     eva.cclinom,
                     ubin.cdesdep as cdepneg,
                     ubin.cdespro as cproneg,
                     ubin.cdesdis as cdisneg,
                     ubid.cdesdep as cdepdom,
                     ubid.cdespro as cprodom,
                     ubid.cdesdis as cdisdom
                from acdagen age
               inner join acdatri tip
                  on tip.ncodtab = 6
                 and tip.ccodatr = age.ntipdoc
                 and tip.cestado = '1'
               inner join acdasig asi
                  on asi.ncorasi = age.ncorasi
               inner join (select *
                            from acdeval
                           where nindcier = 0
                          union
                          select *
                            from acheval
                           where nindcier = 0) eva
                  on eva.ncorcli = asi.ncorcli
                left join actugeo ubid
                  on ubid.cubigeo = eva.czonfij
                left join actugeo ubin
                  on ubin.cubigeo = eva.czonneg
               where age.ncodact = pn_codact
                 and age.ncodbas = pn_codbas
                 and age.cestado = '1'
                 and age.dfecvis = trunc(sysdate)
                 and trim(age.ccodusu) = upper(ps_codusu)
                 and age.ncorasi not in
                     (select distinct ncorasi
                        from achagen
                       where ncorage in
                             (select ncorage from acdrevi where nrespue = 148))) a;
    else
      open lc_liscur for
        select cam.npaicli,
               tip.cdesatr as ctipdoc,
               cam.ntipdoc,
               cam.cnumdoc,
               cam.cnomcli as cclinom,
               cam.cdepneg,
               cam.cproneg,
               cam.cdisneg,
               cam.cdepdom,
               cam.cprodom,
               cam.cdisdom
          from ACDASCA cam
         inner join acdatri tip
            on tip.ncodtab = 6
           and tip.ccodatr = cam.ntipdoc
           and tip.cestado = '1'
         where cam.ncodact = pn_codact
           and cam.ncodbas = pn_codbas
           and cam.cestado = '1'
           and trim(cam.ccodusu) = upper(ps_codusu);
      --and cam.dfecini >= ld_fecing
      --and cam.dfecfin >= ld_fecing;
      select count(*)
        into ln_canreg
        from (select cam.npaicli,
                     tip.cdesatr as ctipdoc,
                     cam.ntipdoc,
                     cam.cnumdoc,
                     cam.cnomcli,
                     cam.cdepneg,
                     cam.cproneg,
                     cam.cdisneg,
                     cam.cdepdom,
                     cam.cprodom,
                     cam.cdisdom
                from ACDASCA cam
               inner join acdatri tip
                  on tip.ncodtab = 6
                 and tip.ccodatr = cam.ntipdoc
                 and tip.cestado = '1'
               where cam.ncodact = pn_codact
                 and cam.ncodbas = pn_codbas
                 and cam.cestado = '1'
                 and trim(cam.ccodusu) = upper(ps_codusu));
      --and cam.dfecini >= ld_fecing
      --and cam.dfecfin >= ld_fecing);   
    end if;
    insert into actlgmi
    values
      (pn_codact, --null,
       pn_codbas, --null,
       null,
       null,
       3,
       ps_codusu,
       null,
       ld_fecing,
       sysdate,
       ln_canreg);
    commit;
  
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_listacampana2;

  procedure sp_obtenerCalificacion(BL_DATOS  IN OUT SYS_REFCURSOR,
                                   pn_codpai number,
                                   pn_tipdoc number,
                                   pc_numdoc varchar2,
                                   pc_coderr out char,
                                   pc_msgerr out varchar2) is
  begin
    pc_coderr := '00000';
    pc_msgerr := '';
    --//
    begin
      pq_apl_segmentacion.sp_carga_data(pd_fecpro => trunc(sysdate),
                                        --fecha del dia
                                        pn_pai => pn_codpai,
                                        --pais
                                        pn_tdo => pn_tipdoc,
                                        --tipo de documento
                                        pc_doc => pc_numdoc,
                                        --nro de documento
                                        pc_usr => 'RDSBMOBILE'); --usuario que esta ejecutando el paquete
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    end;
    open BL_DATOS for
      select *
        from (select a.jaqz086paic  n_codpai,
                     a.jaqz086tdoc  n_tipdoc,
                     a.jaqz086tndoc c_numdoc,
                     b.jaqy067ccal  n_codcal,
                     b.jaqy067ncal  c_descal
                from JAQZ086_APLINEA a, jaqy067 b
               where a.jaqz086paic = pn_codpai
                 and a.jaqz086tdoc = pn_tipdoc
                 and a.jaqz086tndoc = rpad(trim(pc_numdoc), 12, ' ')
                 and a.jaqz086usr = 'RDSBMOBILE'
                 and a.jaqz086calf = b.jaqy067ccal)
       where rownum <= 1;
  exception
    when no_data_found then
      rollback;
      pc_coderr := '00011';
      pc_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      pc_coderr := '00099';
      pc_msgerr := SQLERRM;
  end sp_obtenerCalificacion;

  procedure sp_misti_valcampa2(pc_codpai varchar2,
                               pc_tipdoc varchar2,
                               pc_numdoc varchar2,
                               pc_codusu varchar2,
                               pc_otroas out varchar2,
                               pc_menase out varchar2,
                               pc_indrec out varchar2,
                               pc_indcam out varchar2,
                               pn_codact out number,
                               pn_codbas out number,
                               ps_coderr out char,
                               ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_valcampa
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/10/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : Valores de la campaña
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    lc_codusu   varchar2(10);
    ln_connuevo number;
    ls_numdoc   char(12);
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := pc_numdoc;
    -- retornar actividad y base a partir del documento  
  
    begin
      select upper(trim(ccodusu)), ncodact, ncodbas
        into lc_codusu, pn_codact, pn_codbas
        from acdasig
       where ncodact = 7
         and npaicli = pc_codpai
         and ntipdoc = pc_tipdoc
         and cnumdoc = pc_numdoc;
    
      pc_indrec := 'S';
      pc_indcam := 'S';
    exception
      when no_data_found then
        lc_codusu := null;
        pc_indrec := 'N';
      when others then
        lc_codusu := null;
        pc_indrec := 'N';
    end;
  
    if (lc_codusu = upper(trim(pc_codusu))) then
      pc_otroas := 'N';
    else
      if (lc_codusu is null) then
        pc_otroas := 'N';
      else
      
        pc_otroas := 'S';
        select 'El cliente fue asignado el  ' || dfecasi || ' a: ' ||
               cnomope
          into pc_menase
          from acdasig asi
         inner join acmoper
            on ccodope = trim(ccodusu)
         where ncodact = 7
           and cnumdoc = pc_numdoc
           and npaicli = pc_codpai
           and ntipdoc = pc_tipdoc;
      end if;
    end if;
  
    if (pc_indrec = 'N') then
    
      /* 
      select count(*)
        into ln_connuevo
        from JAQY346C
       where JAQY346Cpai = pc_codpai
         and Jaqy346ctdo = pc_tipdoc
         and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
         */
      ln_connuevo := 0;
      if ln_connuevo > 0 then
        pc_indcam := 'S';
      else
        pc_indcam := 'N';
      end if;
    
    end if;
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
    
  end sp_misti_valcampa2;

  procedure sp_misti_idenuevcam2(pc_codpai  varchar2,
                                 pc_tipdoc  varchar2,
                                 pc_numdoc  varchar2,
                                 pn_codact  number,
                                 pn_codbas  number,
                                 pc_idennue out varchar2,
                                 pc_codcod  out varchar2,
                                 pc_codcol  out varchar2,
                                 pc_codtit  out varchar2,
                                 lc_liscur  out types.cursor_type,
                                 ps_coderr  out char,
                                 ps_msgerr  out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_misti_idenuevcam
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/09/2017
    -- Autor de Creación          : BDEG
    -- Uso                        : ID nuevo cliente campana
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
  
   as
    ls_corcli   number(20);
    ln_corcli   number(20);
    ln_valpar   number(12, 2);
    lc_codmon   char(1);
    ln_monto    number(12, 2);
    ln_moncom   number(12, 2);
    ln_valadi   number(12, 2);
    ln_actfij   number(12, 2);
    ln_fij12m   number(12, 2);
    ln_ratcuo   number(12, 6);
    ls_desseg   varchar2(100);
    ln_connuevo number;
    ls_numdoc   char(12);
    ls_fecha    date;
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    ls_numdoc := pc_numdoc;
  
    select count(*)
      into ln_connuevo
      from JAQY346C
     where JAQY346Cpai = pc_codpai
       and Jaqy346ctdo = pc_tipdoc
       and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
  
    if ln_connuevo > 0 then
      pc_idennue := 'S';
    else
      pc_idennue := 'N';
    end if;
  
    begin
      select t1.tp1desc
        into pc_codcod
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 2
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcod := '0';
    end;
  
    begin
      select t1.tp1desc
        into pc_codcol
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 3
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := '000000';
    end;
  
    begin
      select t1.tp1desc
        into pc_codtit
        from fst198 t1
       where t1.tp1cod = 1
         and t1.tp1cod1 = 10801
         and t1.tp1corr1 = 310
         and t1.tp1corr2 = pn_codbas
         and t1.tp1corr3 = 1
         and t1.tp1nro1 = pn_codact;
    exception
      when others then
        pc_codcol := 'NO HAY CAMPAÑA';
    end;
  
    if pc_idennue = 'S' then
    
      select jaqy346cmnto, jaqy346cfech, JAQY346CAU
        into ln_monto, ls_fecha, ln_moncom
        from JAQY346C
       where JAQY346Cpai = pc_codpai
         and Jaqy346ctdo = pc_tipdoc
         and rpad(JAQY346Cndo, 12, ' ') = ls_numdoc;
    
      open lc_liscur for
        select etiqueta, valor
          from (select 1 as num,
                       'Mayor monto de endeudamiento en desembolso' as etiqueta,
                       coalesce(to_char(TO_CHAR(ln_monto, 'FM999,999,999')),
                                '') as valor
                  from dual
                union
                select 2 as num,
                       'Fecha mayor monto de endeudamiento' as etiqueta,
                       coalesce(to_char(ls_fecha, 'DD/MM/YYYY'), '') as valor
                  from dual
                union
                select 3 as num,
                       'Monto para compartir deuda' as etiqueta,
                       coalesce(to_char(TO_CHAR(ln_moncom, 'FM999,999,999')),
                                '') as valor
                  from dual
                
                ) a
         order by num;
    end if;
  exception
    when no_data_found then
      rollback;
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      rollback;
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_misti_idenuevcam2;
  --// 2018.05.29 JPINTO - FIN  
procedure sp_inscome(ps_paicli varchar2,ps_tipdoc varchar2,ps_numdoc varchar2,
                      ps_codest varchar2,ps_descom varchar2,ps_usumod varchar2,
                      ps_coderr out varchar2,ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_inscom
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : COMENTARIOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 04/07/2019
    -- Autor de Creación          : BDEG
    -- Uso                        : Insertar comentario
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************  
   as
    ln_corcom number;
    ln_corage number;
    ln_paicli number;
    ln_tipdoc number;
    ld_fecmod date;
    ln_codest number;
    ln_codage number;
    ls_numdoc varchar2(12);
    ln_ctl001 number;
    ln_ctl002 number;
    ls_usumod varchar(10);
    pragma autonomous_transaction;
  begin
    ld_fecmod := sysdate();
    ln_corcom := 0;
    ln_paicli := to_number(ps_paicli);
    ln_tipdoc := to_number(ps_tipdoc);
    ln_codest := to_number(ps_codest);
    ln_codage:= 0;
    ls_numdoc := trim(ps_numdoc);
    ln_ctl001 := 0;
    ls_usumod := upper(ps_usumod);
    select ncodsuc into ln_codage
      from acdagus
     where ccodope = ls_usumod;
    begin
       select npaicli into ln_ctl002 
         from acdreco 
        where npaicli = ln_paicli
          and ntipdoc = ln_tipdoc
          and cnumdoc = ls_numdoc;
        ln_ctl001 := 1;  
    exception
    when no_data_found then
       ln_ctl001 := 0;
    end;   
    select max(ncorcom) into ln_corcom
      from achreco
     where npaicli = ln_paicli
       and ntipdoc = ln_tipdoc
       and cnumdoc = ls_numdoc;
    ln_corcom := nvl(ln_corcom,0) + 1;   
    
    if ln_ctl001 = 0 then    
       insert into acdreco (npaicli,ntipdoc,cnumdoc,ncodest,cdescom,cusumod,dfecmod,ncodage)
       values (ln_paicli,ln_tipdoc,ls_numdoc,ln_codest,ps_descom,upper(ps_usumod),ld_fecmod,ln_codage);
       commit;
    else   
       insert into achreco 
       select ln_corcom,npaicli,ntipdoc,cnumdoc,ncodest,cdescom,cusumod,dfecmod,ncodage
         from acdreco
        where npaicli = ln_paicli
          and ntipdoc = ln_tipdoc
          and cnumdoc = ls_numdoc; 
       commit;   
       update acdreco set ncodest = ln_codest,cdescom = ps_descom,cusumod = ps_usumod,
              dfecmod = ld_fecmod,ncodage = ln_codage
        where npaicli = ln_paicli
          and ntipdoc = ln_tipdoc
          and cnumdoc = ls_numdoc;     
       commit;   
    end if;   
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
  exception
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_inscome;
  
  procedure sp_liscom(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisres
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : ESTADO COMENTARIO
    -- Versión                    : 1.0
    -- Fecha de Creación          : 02/07/2019
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista de estado comentario
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
  
    open lc_liscur for
      select res.ncodest as ncodest, res.cdesest as cdesest
        from ACTESCO res
       where res.ccodest = '1';
  end sp_liscom;
  
  procedure sp_repcomentario(ps_codusu varchar2,ps_fecini varchar2,ps_fecfin varchar2,
                             ps_codage varchar2,ps_codana varchar2,ps_codcom varchar2,
                             lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repcomentario
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 01/07/2019
-- Autor de Creación          : WCRW
-- Uso                        : Reporte Comentario
-- Estado                     : Activo
-- Fecha Modificación         :
-- Autor de Modificación      :
-- Descripcion Modificacion   :
-- ***************************************************************** 
ls_codusu varchar2(10);
ls_fecini date;
ls_fecfin date;
ls_fectem date;
ls_codage number;
ls_codcar number;
ln_codcom number;
begin
   ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
   ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
   if ps_codcom = 'NO' then
      ln_codcom := 0;
   else
      ln_codcom := to_number(ps_codcom);
   end if;   
   select ccodcar into ls_codcar
     from acmoper
    where ccodope = upper(trim(ps_codana));
   if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
   end if;
   if ps_codage = '0' then
      ls_codage := null;
      ls_codusu := null;
   else
      if ps_codusu = 'NO' then
         ls_codusu := null;
      else
         ls_codusu := upper(trim(ps_codusu));
         select ncodsuc into ls_codage
           from acdagus
          where ccodope = upper(trim(ps_codusu));
      end if;
   end if;
   if ls_codage is null or ls_codusu is null then
      if ln_codcom = 0 then
         open lc_liscur for
         select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
               eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
               trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
               to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
               eva.nmoneva,eva.cactcli,
               coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
               desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
               to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
               to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,esco.cdesest,reco.cdescom,reco.cusumod as cusucom,
               to_char(reco.dfecmod,'YYYY-MM-DD') as dfeccom,
               CASE when reco.ncodest = 1 then to_char(trunc(asi.dfecmod)-trunc(sysdate),'999999999')
                    when reco.ncodest = 4 then to_char(trunc(desem.dfecdes)-trunc(asi.dfecmod),'999999999')
               else '' END as ndifdia  
          from (select * from acdeval union select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join acdasig asi
            on asi.npaicli = eva.npaicli
           and asi.ntipdoc = eva.ntipdoc
           and asi.cnumdoc = eva.cnumdoc
           and asi.ncodact = eva.ncodact
           and trim(asi.ccodusu) <> trim(asi.cusuasi)
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join actregi zon
            on zon.ncodsuc = pau.ncodsuc    
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join acdagen agen
            on agen.npaicli = asi.npaicli
           and agen.ntipdoc = asi.ntipdoc
           and agen.cnumdoc = asi.cnumdoc
           and agen.ncodact = asi.ncodact
          left join acdrevi rev
            on rev.npaicli = agen.npaicli
           and rev.ntipdoc = agen.ntipdoc
           and rev.cnumdoc = agen.cnumdoc
           and rev.ncodact = agen.ncodact
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
          left join ACDDESE desem
            on desem.ncorcli = eva.ncorcli
          left join acdagus usin
            on upper(trim(eva.cusuing)) = usin.ccodope
           and usin.ccodest = '1'
          left join acmsucu sucing
            on sucing.ncodsuc = eva.NCODAGE
          left join acmoper oping
            on oping.ccodope = upper(trim(eva.cusuing))
          left join acdrole rolin
            on rolin.ncodrol = oping.ccodcar
          left join actregi regi
            on regi.ncodsuc = eva.NCODAGE
          left join actregi regd
            on regd.ncodsuc = desem.naosuc
          left join acdreco reco
            on reco.npaicli = eva.npaicli
            and reco.ntipdoc = eva.ntipdoc
            and reco.cnumdoc = eva.cnumdoc
          left join actesco esco
            on esco.ncodest = reco.ncodest  
         where trim(eva.cusuing) in
               (select ccodope
                  from (select ccodope, cnomope
                          from acmoper
                         where ccodope = trim(upper(ps_codana))
                        union
                        
                        SELECT ccodope, cnomope
                          FROM acmoper
                         START WITH ccodjef = trim(upper(ps_codana))
                                 or ccodsup = trim(upper(ps_codana))
                        CONNECT BY PRIOR ccodope = ccodjef)
                union
                select ccodope
                  from acmoper
                 where ccodcar in
                       (select ncarsub from acpcarg where ncarjef = ls_codcar))
           and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null);
           --and ((repu.nrescod = 4 and repu.npreres = 79) or repu.nrescod is null)
       else
          open lc_liscur for
         select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
               eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
               trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
               to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
               eva.nmoneva,eva.cactcli,
               coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
               desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
               to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
               to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,esco.cdesest,reco.cdescom,reco.cusumod as cusucom,
               to_char(reco.dfecmod,'YYYY-MM-DD') as dfeccom,
               CASE when reco.ncodest = 1 then to_char(trunc(asi.dfecmod)-trunc(sysdate),'999999999')
                    when reco.ncodest = 4 then to_char(trunc(desem.dfecdes)-trunc(asi.dfecmod),'999999999')
               else '' END as ndifdia  
          from (select * from acdeval union select * from acheval) eva
         inner join actacti act
            on act.ncodact = eva.ncodact
         inner join actbase bas
            on bas.ncodbas = eva.ncodbas
           and bas.ncodact = eva.ncodact
          left join acdatri cal
            on cal.ncodtab = 5
           and cal.ctipatr = 'D'
           and cal.cestado = '1'
           and cal.ccodatr = eva.ccodcal
          left join acdasig asi
            on asi.npaicli = eva.npaicli
           and asi.ntipdoc = eva.ntipdoc
           and asi.cnumdoc = eva.cnumdoc
           and asi.ncodact = eva.ncodact
          left join acdagus pau1
            on pau1.ccodope = upper(trim(eva.cusuing))
          left join acdagus pau
            on pau.ccodope = upper(trim(asi.ccodusu))
          left join actregi zon
            on zon.ncodsuc = pau.ncodsuc    
          left join acmsucu age
            on age.ncodsuc = pau.ncodsuc
          left join acdatri tip
            on tip.ncodtab = 9
           and tip.ctipatr = 'D'
           and tip.ccodatr = eva.ctipcli
           and tip.cestado = '1'
          left join acdagen agen
            on agen.npaicli = asi.npaicli
           and agen.ntipdoc = asi.ntipdoc
           and agen.cnumdoc = asi.cnumdoc
           and agen.ncodact = asi.ncodact
           and trim(asi.ccodusu) <> trim(asi.cusuasi)
          left join acdrevi rev
            on rev.npaicli = agen.npaicli
           and rev.ntipdoc = agen.ntipdoc
           and rev.cnumdoc = agen.cnumdoc
           and rev.ncodact = agen.ncodact
          left join acdrepu repu
            on repu.nrespue = rev.nrespue
          left join acdprre prre
            on prre.npreres = repu.npreres
          left join acdresu resu
            on resu.ncodres = prre.ncodres
          left join ACDDESE desem
            on desem.ncorcli = eva.ncorcli
          left join acdagus usin
            on upper(trim(eva.cusuing)) = usin.ccodope
           and usin.ccodest = '1'
          left join acmsucu sucing
            on sucing.ncodsuc = eva.NCODAGE
          left join acmoper oping
            on oping.ccodope = upper(trim(eva.cusuing))
          left join acdrole rolin
            on rolin.ncodrol = oping.ccodcar
          left join actregi regi
            on regi.ncodsuc = eva.NCODAGE
          left join actregi regd
            on regd.ncodsuc = desem.naosuc
          left join acdreco reco
            on reco.npaicli = eva.npaicli
            and reco.ntipdoc = eva.ntipdoc
            and reco.cnumdoc = eva.cnumdoc
          left join actesco esco
            on esco.ncodest = reco.ncodest  
         where trim(eva.cusuing) in
               (select ccodope
                  from (select ccodope, cnomope
                          from acmoper
                         where ccodope = trim(upper(ps_codana))
                        union
                        SELECT ccodope, cnomope
                          FROM acmoper
                         START WITH ccodjef = trim(upper(ps_codana))
                                 or ccodsup = trim(upper(ps_codana))
                        CONNECT BY PRIOR ccodope = ccodjef)
                union
                select ccodope
                  from acmoper
                 where ccodcar in
                       (select ncarsub from acpcarg where ncarjef = ls_codcar))
           and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
           and (repu.nrescod = 4 or repu.nrescod is null)
           --and ((repu.nrescod = 4 and repu.npreres = 79) or repu.nrescod is null)
           and reco.ncodest = ln_codcom;    
      end if;     
   else
      if ln_codcom = 0 then
         open lc_liscur for
         select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
              eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
              trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
              to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
              eva.nmoneva,eva.cactcli,
              coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
              desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
              to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
              to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,esco.cdesest,reco.cdescom,reco.cusumod as cusucom,
              to_char(reco.dfecmod,'YYYY-MM-DD') as dfeccom,
              CASE when reco.ncodest = 1 then to_char(trunc(asi.dfecmod)-trunc(sysdate),'999999999')
                   when reco.ncodest = 4 then to_char(trunc(desem.dfecdes)-trunc(asi.dfecmod),'999999999')
              else '' END as ndifdia  
         from (select * from acdeval union select * from acheval) eva
        inner join actacti act
           on act.ncodact = eva.ncodact
        inner join actbase bas
           on bas.ncodbas = eva.ncodbas
          and bas.ncodact = eva.ncodact
         left join acdatri cal
           on cal.ncodtab = 5
          and cal.ctipatr = 'D'
          and cal.cestado = '1'
          and cal.ccodatr = eva.ccodcal
         left join acdasig asi
           on asi.npaicli = eva.npaicli
          and asi.ntipdoc = eva.ntipdoc
          and asi.cnumdoc = eva.cnumdoc
          and asi.ncodact = eva.ncodact
          and trim(asi.ccodusu) <> trim(asi.cusuasi)
         left join acdagus pau1
           on pau1.ccodope = upper(trim(eva.cusuing))
         left join acdagus pau
           on pau.ccodope = upper(trim(asi.ccodusu))
         left join acmsucu age
           on age.ncodsuc = pau.ncodsuc
         left join actregi zon
           on zon.ncodsuc = pau.ncodsuc  
         left join acdatri tip
           on tip.ncodtab = 9
          and tip.ctipatr = 'D'
          and tip.ccodatr = eva.ctipcli
          and tip.cestado = '1'
         left join acdagen agen
           on agen.npaicli = asi.npaicli
          and agen.ntipdoc = asi.ntipdoc
          and agen.cnumdoc = asi.cnumdoc
          and agen.ncodact = asi.ncodact
         left join acdrevi rev
           on rev.npaicli = agen.npaicli
          and rev.ntipdoc = agen.ntipdoc
          and rev.cnumdoc = agen.cnumdoc
          and rev.ncodact = agen.ncodact
         left join acdrepu repu
           on repu.nrespue = rev.nrespue
         left join acdprre prre
           on prre.npreres = repu.npreres
         left join acdresu resu
           on resu.ncodres = prre.ncodres
         left join ACDDESE desem
           on desem.ncorcli = eva.ncorcli
         left join acdagus usin
           on upper(trim(eva.cusuing)) = usin.ccodope
          and usin.ccodest = '1'
         left join acmsucu sucing
           on sucing.ncodsuc = eva.NCODAGE
         left join acmoper oping
           on oping.ccodope = upper(trim(eva.cusuing))
         left join acdrole rolin
           on rolin.ncodrol = oping.ccodcar
         left join actregi regi
           on regi.ncodsuc = eva.NCODAGE
         left join actregi regd
           on regd.ncodsuc = desem.naosuc
         left join acdreco reco
           on reco.npaicli = eva.npaicli
           and reco.ntipdoc = eva.ntipdoc
           and reco.cnumdoc = eva.cnumdoc
         left join actesco esco
           on esco.ncodest = reco.ncodest  
        where trim(eva.cusuing) = trim(coalesce(ls_codusu, eva.cusuing))
        --and eva.ncodage = coalesce(ls_codage,eva.ncodage)
          and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
        --and ((repu.nrescod = 4 and repu.npreres = 79) or repu.nrescod is null)
          and (repu.nrescod = 4 or repu.nrescod is null);
       else
          open lc_liscur for
          select distinct coalesce(eva.cusuing,' ') as cusuing,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
              eva.cnumdoc,eva.cclinom,coalesce(trim(eva.ctelneg),trim(eva.ctelfij),
              trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,asi.ccodusu,resu.cnomres,
              to_char(rev.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv,' ') as cobserv,
              eva.nmoneva,eva.cactcli,
              coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,
              desem.ncanimp,desem.cnompro,zon.cnomreg,coalesce(age.cnomsuc,' '),asi.cusumod,
              to_char(asi.dfecmod,'HH24:MI:SS') as chormod,to_char(asi.dfecmod,'YYYY-MM-DD'),
              to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,esco.cdesest,reco.cdescom,reco.cusumod as cusucom,
              to_char(reco.dfecmod,'YYYY-MM-DD') as dfeccom,
              CASE when reco.ncodest = 1 then to_char(trunc(asi.dfecmod)-trunc(sysdate),'999999999')
                   when reco.ncodest = 4 then to_char(trunc(desem.dfecdes)-trunc(asi.dfecmod),'999999999')
              else '' END as ndifdia  
         from (select * from acdeval union select * from acheval) eva
        inner join actacti act
           on act.ncodact = eva.ncodact
        inner join actbase bas
           on bas.ncodbas = eva.ncodbas
          and bas.ncodact = eva.ncodact
         left join acdatri cal
           on cal.ncodtab = 5
          and cal.ctipatr = 'D'
          and cal.cestado = '1'
          and cal.ccodatr = eva.ccodcal
         left join acdasig asi
           on asi.npaicli = eva.npaicli
          and asi.ntipdoc = eva.ntipdoc
          and asi.cnumdoc = eva.cnumdoc
          and asi.ncodact = eva.ncodact
          and trim(asi.ccodusu) <> trim(asi.cusuasi)
         left join acdagus pau1
           on pau1.ccodope = upper(trim(eva.cusuing))
         left join acdagus pau
           on pau.ccodope = upper(trim(asi.ccodusu))
         left join acmsucu age
           on age.ncodsuc = pau.ncodsuc
         left join actregi zon
           on zon.ncodsuc = pau.ncodsuc  
         left join acdatri tip
           on tip.ncodtab = 9
          and tip.ctipatr = 'D'
          and tip.ccodatr = eva.ctipcli
          and tip.cestado = '1'
         left join acdagen agen
           on agen.npaicli = asi.npaicli
          and agen.ntipdoc = asi.ntipdoc
          and agen.cnumdoc = asi.cnumdoc
          and agen.ncodact = asi.ncodact
         left join acdrevi rev
           on rev.npaicli = agen.npaicli
          and rev.ntipdoc = agen.ntipdoc
          and rev.cnumdoc = agen.cnumdoc
          and rev.ncodact = agen.ncodact
         left join acdrepu repu
           on repu.nrespue = rev.nrespue
         left join acdprre prre
           on prre.npreres = repu.npreres
         left join acdresu resu
           on resu.ncodres = prre.ncodres
         left join ACDDESE desem
           on desem.ncorcli = eva.ncorcli
         left join acdagus usin
           on upper(trim(eva.cusuing)) = usin.ccodope
          and usin.ccodest = '1'
         left join acmsucu sucing
           on sucing.ncodsuc = eva.NCODAGE
         left join acmoper oping
           on oping.ccodope = upper(trim(eva.cusuing))
         left join acdrole rolin
           on rolin.ncodrol = oping.ccodcar
         left join actregi regi
           on regi.ncodsuc = eva.NCODAGE
         left join actregi regd
           on regd.ncodsuc = desem.naosuc
         left join acdreco reco
           on reco.npaicli = eva.npaicli
           and reco.ntipdoc = eva.ntipdoc
           and reco.cnumdoc = eva.cnumdoc
         left join actesco esco
           on esco.ncodest = reco.ncodest  
        where trim(eva.cusuing) = trim(coalesce(ls_codusu, eva.cusuing))
        --and eva.ncodage = coalesce(ls_codage,eva.ncodage)
          and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
        --and ((repu.nrescod = 4 and repu.npreres = 79) or repu.nrescod is null)
          and (repu.nrescod = 4 or repu.nrescod is null)
          and reco.ncodest = ln_codcom;   
          end if;
      end if;
  end sp_repcomentario;

  procedure sp_discom(ps_paicli varchar2,ps_tipdoc varchar2,ps_numdoc varchar2,
                      ps_codest out varchar2,ps_descom out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_discom
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : COMENTARIOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/01/2020
    -- Autor de Creación          : BDEG
    -- Uso                        : Muestra último comentario
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************  
   as
    ln_paicli number;
    ln_tipdoc number;
    ld_fecmod date;
    ls_numdoc varchar2(12);
    pragma autonomous_transaction;
  begin
    ln_paicli := to_number(ps_paicli);
    ln_tipdoc := to_number(ps_tipdoc);
    ls_numdoc := trim(ps_numdoc);
    begin
       select b.cdesest,a.cdescom into ps_codest,ps_descom 
         from acdreco a,actesco b 
        where a.npaicli = ln_paicli
          and a.ntipdoc = ln_tipdoc
          and a.cnumdoc = ls_numdoc
          and b.ncodest = a.ncodest;
    exception
    when no_data_found then
       ps_codest := 'SIN REGISTRO';
       ps_descom := '';
    end;   
  end sp_discom;  
  
  function fn_valcliARCO(pc_codpai varchar2,pc_tipdoc varchar2,pc_numdoc varchar2,pn_TipCon number) return number is
    ln_ValCli number(1) := 0;
    ls_NumDoc varchar2(12) := '';
    ls_DocNum char(12) := '';
    ln_codpai number(3);
    ln_tipdoc number(2);
  begin
    if pn_TipCon = 1 then
       select ncodpai into ln_codpai from actpais where nnompai = pc_codpai;
       select to_number(ccodatr) into ln_tipdoc 
         from acdatri 
        where ncodtab = 6
          and ctipatr = 'D'
          and cdesatr = pc_tipdoc;
    else
       ln_codpai := to_number(pc_codpai);
       ln_tipdoc := to_number(pc_tipdoc);
    end if;
    ls_NumDoc := rpad(pc_NumDoc, 12, ' ');
    begin
    select AQPA106NUM into ls_DocNum     
      from AQPA106
     where AQPA106PAI = ln_codpai
       and AQPA106TPO = ln_tipdoc
       and AQPA106NUM = ls_NumDoc
       and AQPA106EST <> 'A';
    exception
    when no_data_found then
       ln_ValCli := 1;
    end;    
    return ln_ValCli;
  end fn_valcliARCO;
  
  procedure sp_valcliARCO(pc_codpai varchar2,pc_tipdoc varchar2,pc_numdoc varchar2,ps_ctlreg out varchar2)
  as
-- *****************************************************************
-- Nombre                     : sp_valcliARCO
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 18/02/2021
-- Autor de Creación          : WCRW
-- Uso                        : Valida Cliente Arco
-- Estado                     : Activo
-- Fecha Modificación         :
-- Autor de Modificación      :
-- Descripcion Modificacion   :
-- ***************************************************************** 
ls_NumDoc varchar2(12) := '';
ls_DocNum varchar2(12);
   begin
   ls_NumDoc := rpad(pc_NumDoc, 12, ' ');
   ps_ctlreg := '0';
   begin
   select '0' into ps_ctlreg     
     from AQPA106
    where AQPA106PAI = pc_codpai
      and AQPA106TPO = pc_tipdoc
      and AQPA106NUM = ls_NumDoc
      and AQPA106EST <> 'A';
   exception
   when no_data_found then
       ps_ctlreg := '1';
   end;   
   end sp_valcliARCO;

  procedure sp_loginlog(ps_codusu varchar2, ps_ip varchar2, ps_host varchar2, ps_rol varchar2, ps_est varchar2, ps_modo varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_loginlog
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/09/2024
    -- Autor de Creación          : fpinto
    -- Uso                        : Log de Inicio de Session completo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 

ln_modo number(3); 
pc_fecha date;
pc_estado char(5);
pc_to varchar2 (100);
pc_cc varchar2 (100);
pc_bcc varchar2 (100);
pc_from varchar (100);
pc_subject varchar2 (200);
pc_contenttype varchar2 (100);
pc_filepath varchar2 (100);
pc_filename varchar2 (100);
pc_body varchar2 (5000);
pc_nombreUsu varchar2 (100);
pc_coderr varchar2 (100);
pc_msjerr varchar2 (100); 
pc_fecha_login date;
  begin
    ln_modo := to_number(ps_modo);
    if ln_modo = 1 then
        begin
          select DFECING into pc_fecha_login from (select * from agecom.actaulg order by DFECING desc) where rownum <=1 and CCODUSU=upper(trim(ps_codusu)) and DESTOUT is null;
          update agecom.actaulg set DESTOUT='Cierre de Ventana de Navegador' where DFECING=pc_fecha_login;
          insert into actaulg
            (ccodusu, acdrole, dfecing, destlin, dlginip, dlghstn, destado)
          values
            (upper(trim(ps_codusu)), ps_rol, sysdate, ps_est, ps_ip, ps_host,'00000');
          commit;
        Exception
          when others then
          insert into actaulg
            (ccodusu, acdrole, dfecing, destlin, dlginip, dlghstn, destado)
          values
            (upper(trim(ps_codusu)), ps_rol, sysdate, ps_est, ps_ip, ps_host,'00000');
          commit;
        end;
    else
      insert into actaulg
          (ccodusu, acdrole, dfecing, destlin, dlginip, dlghstn, DFECOUT, DESTOUT, destado)
        values
          (upper(trim(ps_codusu)), ps_rol, sysdate, ps_est, ps_ip, ps_host, sysdate,ps_est, '00400');
        commit;
      begin
        select CNOMOPE into pc_nombreUsu from agecom.acmoper where ccodope = upper(trim(ps_codusu));
        pc_to := trim(ps_codusu)||'@cajaarequipa.pe';
        pc_cc := '';
        pc_bcc := '';
        pc_from := 'notificaciones@cajaarequipa.pe';
        pc_subject :='Caja Arequipa - Notificaciones';
        pc_contenttype := 'text/html';
        pc_filepath := '';
        pc_filename := '';
        pc_msjerr := '';
        pc_coderr := '';
        pc_body:= '<!DOCTYPE html>
                     <html>            
                     <div style="background-color:#002753; width:100%; 
                     padding: 5px 0px; margin-bottom: 5px;font-family:Calibri; font-size: 24px;
                      color:#FFFFFF; font-weight:lighter;">
                      Caja Arequipa
                      </div>
                      <b style="font-family:Calibri; font-size:14px">NOTIFICACIÓN AGENDA COMERCIAL - AGECOM</b>
                      <hr>
                      <p style="font-family:Calibri; font-size:14px">Hola '||trim(pc_nombreUsu)||'.</p>
                      <p style="font-family:Calibri; font-size:14px">Tuviste un intento fallido al loguearte a Agenda Comercial</p>   
                      <table>   
                      <tr style="font-family:Calibri; font-size:14px"><td>Motivo:</td><td> </td><td>'||ps_est||'</td></tr>
                      </table>
                      <br>
                      <p style="font-family:Calibri; font-size:14px">Acordarse que si el error es por equivocarse en usuario o password al tercer intento fallido se bloqueará su usuario.</p>
                      <br>
                      <span style="font-family:Calibri; font-size:12px">Cordialmente</span>
                      <br>
                      <span style="font-family:Calibri; font-size:12px"><strong>Caja Arequipa<strong></span>
                      </html>';
        PQ_CN_CANALES.sp_enviar_correo(pc_deststos => pc_to,
                                     pc_destsccs => pc_cc,
                                     pc_destsbcc => pc_bcc,
                                     po_msjemail => pc_body,
                                     pc_remitent => pc_from,
                                     pc_asuntoms => pc_subject,
                                     pc_tipomsje => pc_contenttype,
                                     pc_direccto => pc_filepath,
                                     pc_archadjt => pc_filename,
                                     pc_coderror => pc_coderr,
                                     pc_msjerror => pc_msjerr);
      exception
        when no_data_found then
          DBMS_OUTPUT.PUT_LINE ('No se envia Correo');
      end;
    end if;
  end sp_loginlog;

  procedure sp_loginout(ps_codusu varchar2, ps_est varchar2, ps_modo varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_loginout
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/09/2024
    -- Autor de Creación          : fpinto
    -- Uso                        : Log de Cierre de Session completo
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 

ln_modo number(3); 
pc_fecha date;
pc_fecha_login date;
pc_estado char(5);
pc_nombreUsu varchar2 (100);

  begin
    ln_modo := to_number(ps_modo);
    
    if ln_modo = 1 then
        select DFECING into pc_fecha_login from (select * from agecom.actaulg order by DFECING desc) where rownum <=1 and CCODUSU=upper(trim(ps_codusu));
        update agecom.actaulg set DFECOUT = sysdate, DESTOUT=ps_est where DFECING=pc_fecha_login;
        commit;
    else
        select DFECING into pc_fecha_login from (select * from agecom.actaulg order by DFECING desc) where rownum <=1 and DLGINIP=trim(ps_codusu);
        update agecom.actaulg set DFECOUT = sysdate, DESTOUT=ps_est where DFECING=pc_fecha_login;
        commit;
    end if;
  end sp_loginout;

  procedure sp_editrol(ps_codusu varchar2, ps_rol varchar2, ps_agencia varchar2) as
    -- *****************************************************************
    -- Nombre                     : sp_loginout
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/09/2024
    -- Autor de Creación          : fpinto
    -- Uso                        : Cambio Rol Usuario Agenda Comercial
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- ***************************************************************** 

 
pc_estado char(5);
pc_rol int;
pc_agencia int;
  begin
      pc_rol := to_number(ps_rol);
      update agecom.acdusua set NCODROL=pc_rol where ccodusu = upper(trim(ps_codusu));
      update agecom.acmoper set CCODCAR=trim(ps_rol) where ccodope = upper(trim(ps_codusu));
      
      if ps_agencia = '0' then
          DBMS_OUTPUT.PUT_LINE ('No se Actualiza Agencia');         
      else
          pc_agencia := to_number(ps_agencia);
          update agecom.acdagus set NCODSUC=pc_agencia where CCODOPE = upper(trim(ps_codusu));
      End if;
      commit;
  end sp_editrol;
  
  procedure sp_lissuc2(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lissuc2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/09/2024
    -- Autor de Creación          : Frank Pinto Carpio
    -- Uso                        : Listado de agencias o sucursales
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
    ln_numreg number;
  begin

      open lc_liscur for
        select ncodsuc, cnomsuc
          from acmsucu
         where ccodest = '1'
           and (ncodsuc < 800 or ncodsuc = 904)
         order by 2;

  end sp_lissuc2;
  procedure sp_lisusu2(lc_liscur out types.cursor_type)
  -- *****************************************************************
    -- Nombre                     : sp_lisusu2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/09/2024
    -- Autor de Creación          : Frank Pinto Carpio
    -- Uso                        : Lista de usuarios
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************  
   as
  begin
    open lc_liscur for
      select usu.ccodusu, ope.cnomope, suc.cnomsuc, rol.cdesrol, est.cdesatr
        from acdusua usu
       inner join acmoper ope
          on usu.ccodusu = ope.ccodope
       inner join acdagus agu
          on usu.ccodusu = agu.ccodope
       inner join acmsucu suc
          on agu.ncodsuc = suc.ncodsuc
       inner join acdrole rol
          on rol.ncodrol = usu.ncodrol
         and rol.ccodest = '1'
       inner join acdatri est
          on est.ncodtab = 1
         and est.ctipatr = 'D'
         and est.ccodatr = usu.ccodest;
       --where usu.ccodest = 1;
  end sp_lisusu2;
  
  procedure sp_estusu2(ps_nomusu varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_estusu2
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/09/2024
    -- Autor de Creación          : Frank Pinto Carpio
    -- Uso                        : Actualizar Estado usuarios
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ls_estusu char(1);
  begin
    select ccodest
      into ls_estusu
      from acdusua
     where ccodusu = trim(ps_nomusu);

    if (ls_estusu = '1') then
      update acdusua set ccodest = '0' where ccodusu = trim(ps_nomusu);
      update acmoper set CCODEST = '0' where ccodope = trim(ps_nomusu);
      update acdagus set CCODEST = '0' where CCODOPE = trim(ps_nomusu);     
    else
      update acdusua set ccodest = '1' where ccodusu = trim(ps_nomusu);
      update acmoper set CCODEST = '1' where ccodope = trim(ps_nomusu);
      update acdagus set CCODEST = '1' where CCODOPE = trim(ps_nomusu);
    end if;
    commit;
  
  end sp_estusu2;
  procedure sp_borrarusuario(pc_codusu varchar2,
                            ps_coderr out char,
                            ps_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : sp_borrarusuario
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24/09/2024
    -- Autor de Creación          : Fpinto
    -- Uso                        : Borrar Usuario
    -- Estado                     : Activo
    -- Fecha Modificación         : 
    -- Autor de Modificación      : 
    -- Descripcion Modificacion   : 
    -- *****************************************************************  
  as
  begin
    ps_coderr := '00000';
    ps_msgerr := 'CORRECTO';
    
    delete from acmoper where ccodope = pc_codusu;
    delete from acdagus where ccodope = pc_codusu;
    delete from acdusua where ccodusu = pc_codusu;
 
  exception
    when no_data_found then
      ps_coderr := '00011';
      ps_msgerr := 'NO HAY DATOS';
    when others then
      ps_coderr := '00099';
      ps_msgerr := SQLERRM;
  end sp_borrarusuario;
  
procedure sp_repusuariosagecom(lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repusuariosagecom
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 26/09/2024
-- Autor de Creación          : Frank Pinto Carpio
-- Uso                        : Reporte de Accesos Usuarios Agecom
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- ***************************************************************** 

begin
  open lc_liscur for
  select ope.ccodope, ope.cnomope,suc.cnomsuc,  est.cdesatr, rol.cdesrol ,
         case
         when rol.ncodrol = 999 then 'ADMINISTRADOR'
         when ope.ccodope in ('SYSADM', 'ACDIGITAL') then 'USUARIO GENERICO'
         when rol.ncodrol in (11,8,13,14,15,16,12,17) then 'EXTERNO'
         when rol.ncodrol in (6,7,10,50,51,52,54,55,101,102,103,104,105,107,108,200,201,202,260,671,900) then 'INTERNO'
         else 'TIPO SIN DESCRIPCION'
         end as Tip_Usuario
        from acmoper ope
        inner join acdagus agu
          on ope.ccodope = agu.ccodope
       inner join acmsucu suc
          on agu.ncodsuc = suc.ncodsuc
       inner join acdrole rol
          on rol.ncodrol = ope.ccodcar
       inner join acdatri est
          on est.ncodtab = 1
         and est.ctipatr = 'D'
         and est.ccodatr = ope.ccodest         
       order by ope.ccodope asc;

end sp_repusuariosagecom;

procedure sp_repusuaccesos(pc_fecini varchar2, pc_fecfin varchar2, lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repusuaccesos
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 26/09/2024
-- Autor de Creación          : Frank Pinto Carpio
-- Uso                        : Reporte de Usuarios Agecom
-- Estado                     : Activo
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- ***************************************************************** 
    ls_dia char(2);
    ls_mes char(2);
    ls_anio char(4);
    ls_fecini char(10);
    ls_fecfin char(10);
begin
  ls_dia := substr(pc_fecini,9,2);
  ls_mes := substr(pc_fecini,6,2);
  ls_anio := substr(pc_fecini,1,4);
  ls_fecini := ls_dia||'/'||ls_mes||'/'||ls_anio; --fecha inicial en formato correcto
  
  ls_dia := substr(pc_fecfin,9,2);
  ls_mes := substr(pc_fecfin,6,2);
  ls_anio := substr(pc_fecfin,1,4);
  ls_fecfin := ls_dia||'/'||ls_mes||'/'||ls_anio; --fecha final en formato correcto
  
  open lc_liscur for       
       select * from agecom.actaulg 
       where trunc(DFECING) >= to_date(ls_fecini, 'dd/MM/yyyy') 
       and trunc(DFECING)<=to_date(ls_fecfin, 'dd/MM/yyyy')  
       order by DFECING desc;

end sp_repusuaccesos;

  function fn_datovisitas(ps_dni varchar2) return varchar2 is
  -- *****************************************************************
  -- Nombre                     : fn_datovisitas
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 09/10/2024
  -- Autor de Creación          : FPINTO
  -- Uso                        :  Datos de la resultado de ultima visita
  -- Estado                     : Activo
  -- Fecha Modificación         :
  -- Autor de Modificación      :
  -- Descripcion Modificacion   :
  -- ***************************************************************** 
    ls_resvis varchar2(100);
    ls_corage number;
    ls_cnumdoc varchar2(12);
    
  begin
    
  select * into ls_corage, ls_cnumdoc from 
           (select ncorage, cnumdoc
                  from agecom.acdrevi where cnumdoc = ps_dni
                union
                select ncorage, cnumdoc
                  from agecom.achrevi where cnumdoc = ps_dni order by 1 desc)
  where rownum =1;
  
    select resu.cnomres into ls_resvis
      from (select ncorage, cobserv, nrespue, dfecvis, cnumdoc
              from agecom.acdrevi
            union
            select ncorage, cobserv, nrespue, dfecvis, cnumdoc
              from agecom.achrevi order by 1 desc) rev
    inner join agecom.acdrepu rep
         on rep.nrespue = rev.nrespue
        and rep.cestado = '1'
    inner join agecom.acdresp res
         on res.nrescod = rep.nrescod
        and res.cestado = '1'
    inner join agecom.acdprre pre
         on pre.npreres = rep.npreres
        and pre.cestado = '1'
    inner join agecom.acdresu resu
         on resu.ncodres = pre.ncodres
        and resu.cestado = '1'
      where rev.ncorage = ls_corage
        and rep.nrescod = 4 
        and rownum = 1;
      
    --ps_desres := ls_desres;    
    return ls_resvis;
  exception
    when no_data_found then
      ls_resvis := ' ';
      return ls_resvis;
    when others then
      ls_resvis := ' ';
      return ls_resvis;
  end fn_datovisitas;

  function fn_obtanalista(ps_dni varchar2) return varchar2 is
  -- *****************************************************************
  -- Nombre                     : fn_datovisitas
  -- Sistema                    : AGENDA COMERCIAL
  -- Módulo                     : CONSULTAS BANTOTAL
  -- Versión                    : 1.0
  -- Fecha de Creación          : 02/12/2024
  -- Autor de Creación          : FPINTO
  -- Uso                        :  Datos de la resultado de Analista asignado
  -- Estado                     : Activo
  -- Fecha Modificación         :
  -- Autor de Modificación      :
  -- Descripcion Modificacion   :
  -- ***************************************************************** 
    ls_anavis varchar2(100);
    ls_cobserv varchar2(200);
    ls_cobserv2 varchar2(200);
  begin
  
   select a.ccodope ||'-'||trim(sucu.cnomsuc) into ls_anavis 
   from ((select ncorage, dfecmod, ncorasi, dfecest, cnumdoc from AGECOM.acdagen)
      union all (select ncorage, dfecmod, ncorasi, dfecest, cnumdoc from AGECOM.achagen)) age
   inner join (SELECT * FROM AGECOM.ACDREVI UNION all SELECT * FROM AGECOM.ACHREVI ) R 
      on age.cnumdoc=r.cnumdoc and r.ncorage = age.ncorage
   INNER JOIN AGECOM.ACDAGUS A 
      ON INSTR(R.COBSERV,A.CCODOPE, 1, 1)>0
   INNER JOIN AGECOM.ACMOPER O 
      ON A.CCODOPE = O.CCODOPE 
   LEFT JOIN AGECOM.ACMSUCU SUCU 
      ON SUCU.NCODSUC = A.NCODSUC
   where /*a.ncodsuc=72 
   and */a.ccodope=o.ccodope 
   and o.ccodcar in (200,201) 
   and age.cnumdoc= ps_dni
   and r.nrespue=135;
    
    return ls_anavis;
  exception
    when no_data_found then
      ls_anavis := ' ';
      return ls_anavis;
    when others then
      ls_anavis := ' ';
      return ls_anavis;
  end fn_obtanalista;
  
  
  procedure sp_listra2(ls_nomusu varchar2,
                      ls_codsuc varchar2,
                      lc_liscur out types.cursor_type) as
    -- *****************************************************************
    -- Nombre                     : sp_listra
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista para la transferencia
    -- Estado                     : Activo
    -- Fecha Modificación         :
    -- Autor de Modificación      :
    -- Descripcion Modificacion   :
    -- *****************************************************************
    ln_codage  number;
    ls_usuario varchar2(12);
  begin
  
    if ls_nomusu = 'elige Usuario...' then
      ls_usuario := null;
    end if;
  
    if ls_codsuc = 'NO' then
      ln_codage  := null;
      ls_usuario := null;
    else
      if ls_nomusu = 'elige Usuario...' then
        ls_usuario := null;
      else
        ln_codage  := ls_codsuc;
        ls_usuario := upper(trim(ls_nomusu));
      
      end if;
    
    end if;
  
    open lc_liscur for
    --select tip.cdesatr,
    --       eva.cnumdoc,
    --       eva.cclinom,
    --       ubi.cdesdep,
    --       ubi.cdespro,
    --       ubi.cdesdis,
    --       cal.cdesatr
    --       from acdeval eva
    --      inner join acdatri tip
    --         on tip.ncodtab=6 and tip.ctipatr = 'D' and tip.ccodatr= eva.ntipdoc
    --       left join actugeo ubi
    --         on ubi.cubigeo= eva.czonfij
    --      inner join acdatri cal
    --         on cal.ncodtab=5 and cal.ctipatr = 'D' and cal.ccodatr= eva.ccodcal
    --     inner join actingr ing
    --         on ing.ncoding = eva.ncoding and ing.cestado='A'
    --      inner join actbase bas
    --         on bas.ncodbas = eva.ncodbas and bas.cestado='A' and bas.ncodact = eva.ncodact
    --      inner join actacti act
    --         on act.ncodact = eva.ncodact and act.cestado ='A'   
    --      where eva.ccodest in ('1','2')
    --        and eva.ccodest='1'
    --        and eva.nagepre in (select ncodsuc from acdagus where ccodope =upper(trim(ls_nomusu)));
    
      select act.cnomact,bas.cnomact,eva.cusuing,tip.cdesatr || ' - ' || asi.cnumdoc as cnumdoc,
             eva.cclinom,ubi.cdespro || ' - ' || ubi.cdesdis as cdesdis,cal.cdesatr || ' - ' || to_char(trunc(eva.dfeceva),'DD/MM/YYYY'),
             act.cnomact || ' ' || asi.cnumdoc as resdni, case when doc.cnumdoc is null then 'N' else doc.cestado end valdoc
        from acdasig asi
       inner join acdatri tip
          on tip.ncodtab = 6
         and tip.ctipatr = 'D'
         and tip.ccodatr = asi.ntipdoc
       inner join actbase bas
          on asi.ncodact = bas.ncodact
         and asi.ncodbas = bas.ncodbas
         and bas.cestado = 'A'
       inner join (select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acdeval
                    where nindcier = '0'
                   union
                   select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acheval
                    where nindcier = '0') eva
          on eva.ncorcli = asi.ncorcli
        left join actugeo ubi
          on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
        left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.ccodatr = coalesce(eva.ccodcal, '1')
        left join actacti act
          on act.ncodact = asi.ncodact
         and act.cestado = 'A'
        left join acdagus suc
          on trim(suc.ccodope) = trim(asi.ccodusu)
         left join acddoc doc
         on trim(doc.cnumdoc) = trim(asi.cnumdoc)
       where eva.nindcier = '0'
         and trim(asi.ccodusu) = coalesce(ls_usuario, trim(asi.ccodusu))
         and suc.ncodsuc = coalesce(ln_codage, suc.ncodsuc);
  
  end sp_listra2;
  
  procedure sp_listra3(ls_nomusu varchar2,
                      ls_codsuc varchar2,
                      ps_codrole varchar2,
                      lc_liscur out types.cursor_type) as               
    -- *****************************************************************
    -- Nombre                     : sp_listra3
    -- Sistema                    : AGENDA COMERCIAL
    -- Módulo                     : CONSULTAS BANTOTAL
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/01/2016
    -- Autor de Creación          : BDEG
    -- Uso                        : Lista para la transferencia
    -- Estado                     : Activo
    -- Fecha Modificación         : 24/04/2025
    -- Autor de Modificación      : SGAMERO
    -- Descripcion Modificacion   : Se añade filtro de rol
    -- Fecha Modificación         : 05/05/2025
    -- Autor de Modificación      : SGAMERO
    -- Descripcion Modificacion   : Se añade validación de sustento
    -- *****************************************************************                   
                      
    ln_codage  number;
    ls_usuario varchar2(12);
    ls_rol varchar(3);
  begin
    
    if ps_codrole = '0' then
       ls_rol := null;
    else
       ls_rol := ps_codrole;
    end if;
    
    if ls_nomusu = 'elige Usuario...' then
      ls_usuario := null; 
    else
      ls_usuario := upper(trim(ls_nomusu)); 
    end if;
  
    if ls_codsuc = '0' then
      ln_codage := null;     
    else
      ln_codage := ls_codsuc; 
    end if;    
  
    open lc_liscur for
    
      select act.cnomact, bas.cnomact, eva.cusuing, tip.cdesatr || ' - ' || asi.cnumdoc as cnumdoc,
             eva.cclinom, ubi.cdespro || ' - ' || ubi.cdesdis as cdesdis, cal.cdesatr || ' - ' || to_char(trunc(eva.dfeceva),'DD/MM/YYYY'),
             act.cnomact || ' ' || asi.cnumdoc as resdni, case when doc.cnumdoc is null or DBMS_LOB.getlength(doc.ffile1) = 0 then 'N' else doc.cestado end valdoc
        from acdasig asi
       inner join acdatri tip
          on tip.ncodtab = 6
         and tip.ctipatr = 'D'
         and tip.ccodatr = asi.ntipdoc
       inner join actbase bas
          on asi.ncodact = bas.ncodact
         and asi.ncodbas = bas.ncodbas
         and bas.cestado = 'A'
       inner join (select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acdeval
                    where nindcier = '0'
                   union
                   select czonfij,czonneg,ccodcal,cclinom,ncorcli,ncodact,
                          nindcier,cusuing,dfeceva
                     from acheval
                    where nindcier = '0') eva
          on eva.ncorcli = asi.ncorcli
        left join acmoper rol
          on rol.ccodope = eva.cusuing 
        left join actugeo ubi
          on ubi.cubigeo = coalesce(eva.czonneg, eva.czonfij)
        left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.ccodatr = coalesce(eva.ccodcal, '1')
        left join actacti act
          on act.ncodact = asi.ncodact
         and act.cestado = 'A'
        left join acdagus suc
          on trim(suc.ccodope) = trim(asi.ccodusu)
       -- left join acmoper rol
       --   on rol.ccodope = eva.cusuing 
        left join acddoc doc
          on trim(doc.cnumdoc) = trim(asi.cnumdoc)
       where eva.nindcier = '0'
         and(trim(suc.ncodsuc) = trim(ln_codage) or trim(ln_codage) is null)
         and(trim(rol.ccodcar) = trim(ls_rol) or trim(ls_rol) is null)
         and(trim(asi.ccodusu) = trim(ls_usuario) or trim(ls_usuario) is null);
        
        --and trim(asi.ccodusu) = coalesce(ls_usuario, trim(asi.ccodusu))
        --and  (trim(asi.ccodusu) = trim(ls_usuario) or trim(ls_usuario) is null)
        --and suc.ncodsuc = coalesce(ln_codage, suc.ncodsuc)
        --and rol.ccodcar = coalesce(ls_rol, rol.ccodcar);
  
  end sp_listra3;
procedure sp_repseguiclientedetCRM(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repseguiclientedetCRM
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 01/09/2025
-- Autor de Creación          : Frank Pinto Carpio
-- Uso                        : Reporte de Seguimiento de Clientes detallado para CRM, solo Valorres F/F
-- Estado                     : Activo
-- Fecha Modificación         : 20/10/2025
-- Autor de Modificación      : Sergio Gamero
-- Descripcion Modificacion   : Se agrega monto de registro, agencia de preferencia, usuario, 
--                              fecha y tipo de transferencia.
-- Fecha Modificación         : 
-- Autor de Modificación      : 
-- Descripcion Modificacion   : 
-- ***************************************************************** 
ls_codusu varchar2(10);
ls_fecini date;
ls_fecfin date;
ls_fectem date;
ls_codbas number;
begin
   ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
   ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
   if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
   end if;
   if ps_codbas = 'elige Base...' then
      ls_codbas := null;
   else
      ls_codbas := ps_codbas;
   end if;

      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,oping.ccodcar as ncodrol,
             upper(regi.cnomreg) as reging,upper(regi.cdeszon) as zoning,' ' as DNI,
             rolin.cdesrol,to_char(eva.dfeceva, 'dd/MM/yyyy HH:mi:ss') as dfecreg,eva.npaicli, eva.ntipdoc,eva.cnumdoc,
             eva.cdoccon, eva.cconnom,eva.CDIRFIJ, eva.CDIRNEG, eva.CLISNEG,
             eva.nidebas, eva.nidepro, eva.ncoding, eva.ncodact, eva.ncodbas,eva.csegcli,             
             eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,
             eva.ncorcli, eva.cusuing) as ultresing,coalesce(trim(eva.ctelneg), 
             trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,eva.cmailcl,tip.cdesatr as tipcli,
             eva.nmoneva, eva.CINDSOB, eva.CESCOSB,eva.NNUMENT,eva.CINDJUD,eva.CREFNEG,eva.CCALCLI,eva.CACTCLI,
             eva.CINDCAS,eva.CTIPCNY,eva.CCALCON,eva.CSEGCON,eva.NNUMINA,eva.CDESTCRE,eva.CFECDES,
             eva.COBSERV,eva.CZONFIJ, agen.ccodusu as acdagencodusu, to_char(agen.dfecest, 'YYYY-MM-DD')  as dfecest,
             asi.ccodusu,resu.cnomres,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
             coalesce(rev.cobserv, ' ') as cobserv,coalesce(desem.ctipcli, ' ') as ctipcli,
             to_char(desem.dfecdes, 'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,
             desem.NAOCTA,desem.NAOOPER,desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa, nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe,

             nvl(sub_tran.tiptran, '') as Tiptra, nvl(sub_tran.canaini, '') as Usutra,
             sub_tran.dfectra as Fectra, eva.nagepre as Agepre, eva.nmoneva as Monto
        from (select *
                from acdeval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)
                union
              select *
                from acheval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdasig asi
          on asi.npaicli = eva.npaicli
         and asi.ntipdoc = eva.ntipdoc
         and asi.cnumdoc = eva.cnumdoc
         and asi.ncodact = eva.ncodact
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(asi.ccodusu))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdagen agen
          on agen.npaicli = asi.npaicli
         and agen.ntipdoc = asi.ntipdoc
         and agen.cnumdoc = asi.cnumdoc
         and agen.ncodact = asi.ncodact
      left join acdrevi rev
          on rev.npaicli = agen.npaicli
         and rev.ntipdoc = agen.ntipdoc
         and rev.cnumdoc = agen.cnumdoc
         and rev.ncodact = agen.ncodact
      left join acdrepu repu
          on repu.nrespue = rev.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.NCODAGE
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.NCODAGE
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
            and f1.pgcod = 1
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
      --
      left join (
             select 
                 cnumdoc,
                 canaini,
                 canafin,
                 dfectra,
                 dfeceva,
                 case
                     when canafin is null then 'SIN TRANSFERIR'
                     when canafin = 'USRAGECOM' then 'ALEATORIA'
                     else 'EXCEPCIONAL'
                 end as tiptran
             from (
                 select
                     eva1.cnumdoc,
                     tran.canaini,
                     tran.canafin,
                     tran.dfectra,
                     tran.dfeceva,
                     row_number() over (partition by eva1.cnumdoc order by tran.dfectra desc nulls last) as rn 
                 from agecom.acdeval eva1 
                 left join agecom.acdtran tran 
                     on eva1.cnumdoc = tran.cnumdoc
                     and tran.dfeceva = eva1.dfeceva
             )
             where rn = 1
      ) sub_tran on sub_tran.cnumdoc = eva.cnumdoc
      --
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas, asi.ncodbas)
         and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);


end sp_repseguiclientedetCRM;


procedure sp_repseguiclientedet2(ps_fecini varchar2,ps_fecfin varchar2,
                                ps_codact varchar2,ps_codbas varchar2,
                                ps_codest varchar2,ps_tiprep varchar2,
                                lc_liscur out types.cursor_type) as
-- *****************************************************************
-- Nombre                     : sp_repseguiclientedet2
-- Sistema                    : AGENDA COMERCIAL
-- Módulo                     : CONSULTAS BANTOTAL
-- Versión                    : 1.0
-- Fecha de Creación          : 07/04/2017
-- Autor de Creación          : BDEG
-- Uso                        : Reporte de Seguimiento de Clientes detallado
-- Estado                     : Activo
-- Fecha Modificación         : 17/07/2019
-- Autor de Modificación      : WCRW
-- Descripcion Modificacion   : Diferenciar Reportes
-- Fecha Modificación         : 29/09/2023
-- Autor de Modificación      : Frank Pinto Carpio
-- Descripcion Modificacion   : Se aumenta descripcion de modulo y tipo de operacion de credito
-- Fecha Modificación         : 09/10/2025
-- Autor de Modificación      : Sergio Gamero
-- Descripcion Modificacion   : Se aumenta monto de registro agencia de preferencia, usuario, 
--                              fecha y tipo de transferencia.
-- Fecha Modificacion         : 20/10/2025
-- Descripcion Modificacion   : Se agrega tipo de transferencia 'SIN TRANSFERIR'
-- Autor de Modificación      : Sergio Gamero
-- Fecha Modificacion         : 23/10/2025
-- Descripcion Modificacion   : Se agrega descripcion de agencia
-- Autor de Modificación      : Sergio Gamero
-- ***************************************************************** 
ls_codusu varchar2(10);
ls_fecini date;
ls_fecfin date;
ls_fectem date;
ls_codbas number;
begin
   ls_fecini := to_date(ps_fecini, 'yyyy/mm/dd');
   ls_fecfin := to_date(ps_fecfin, 'yyyy/mm/dd');
   if ls_fecini > ls_fecfin then
      ls_fectem := ls_fecfin;
      ls_fecfin := ls_fecini;
      ls_fecini := ls_fectem;
   end if;
   if ps_codbas = 'elige Base...' then
      ls_codbas := null;
   else
      ls_codbas := ps_codbas;
   end if;
   if ps_tiprep='V' then
      if ps_codest = 'F' then
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli,eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             eva.cusuasi as ccodusu,resu.cnomres,to_char(eva.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(eva.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa,to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,
             eva.cfecmod,eva.chormod,eva.cnomreg,eva.cnomsuc,eva.cdeszon,eva.cfecdes,eva.czonpro,
             nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe,
             
             sub_tran.tiptran as Tiptra, nvl(sub_tran.canaini, ' ') as Usutra,
             sub_tran.dfectra as Fectra, sucup.cnomsuc as Agepre, eva.nmoneva as Monto
      
        from (select a.dfeceva,a.cnumdoc,a.cclinom,a.npaicli,a.ntipdoc,a.ncorcli,a.cusuing,a.ctelneg,
                     a.ctelfij,a.ctelmov,asi.ncorasi,asi.ccodusu as cusuasi,a.ncodact,a.ncodbas,a.ccodcal,
                     a.ctipcli,a.ncodage,asi.ncodbas as nasibas,rev.nrespue,rev.cobserv,rev.dfecvis,
                     to_char(asi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(asi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,a.cfecdes,a.czonpro,asi.cusumod,asi.ccodusu,asi.dfecasi,a.nagepre,a.nmoneva
                 from acdeval a
              left join acdasig asi
                  on asi.ncorcli = a.ncorcli 
              left join acdagen agen
                  on agen.ncorasi = asi.ncorasi
              left join acdrevi rev
                  on rev.ncorage = agen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(asi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc           
               where a.ncodact = ps_codact
                 and a.ncodbas = coalesce(ls_codbas, a.ncodbas)
              union
              select b.dfeceva,b.cnumdoc,b.cclinom,b.npaicli,b.ntipdoc,b.ncorcli,b.cusuing,b.ctelneg,
                     b.ctelfij,b.ctelmov,hasi.ncorasi,hasi.ccodusu as cusuasi,b.ncodact,b.ncodbas,b.ccodcal,
                     b.ctipcli,b.ncodage,hasi.ncodbas as nasibas,hrev.nrespue,hrev.cobserv,hrev.dfecvis,
                     to_char(hasi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(hasi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,b.cfecdes,b.czonpro,hasi.cusumod,hasi.ccodusu,hasi.dfecasi,b.nagepre,b.nmoneva
                from acheval b
              left join achasig hasi
                  on hasi.ncorcli = b.ncorcli
              left join achagen hagen
                  on hagen.ncorasi = hasi.ncorasi
              left join achrevi hrev
                  on hrev.ncorage = hagen.ncorage
               left join acdagus pau
                  on pau.ccodope = upper(trim(hasi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc          
               where b.ncodact = ps_codact
                 and b.ncodbas = coalesce(ls_codbas, b.ncodbas)) eva      
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      inner join acmsucu sucup
          on sucup.ncodsuc = eva.nagepre
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(eva.cusuasi))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdrepu repu
          on repu.nrespue = eva.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.ncodage
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.ncodage
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
            and f1.pgcod = 1
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope 
     --       
     left join (
             select 
                 cnumdoc,
                 canaini,
                 canafin,
                 dfectra,
                 case
                     when canafin is null then 'SIN TRANSFERIR'
                     when canafin = 'USRAGECOM' then 'ALEATORIA'
                     else 'EXCEPCIONAL'
                 end as tiptran
             from (
                 select
                     eva1.cnumdoc,
                     tran.canaini,
                     tran.canafin,
                     tran.dfectra,
                     row_number() over (partition by eva1.cnumdoc order by tran.dfectra desc nulls last) as rn 
                 from agecom.acdeval eva1 
                 left join agecom.acdtran tran 
                     on eva1.cnumdoc = tran.cnumdoc
                     and tran.dfeceva = eva1.dfeceva
             )
             where rn = 1
      ) sub_tran on sub_tran.cnumdoc = eva.cnumdoc
      --
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas,eva.nasibas)
         and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
      else
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva,'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli,eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             eva.cusuasi as ccodusu,resu.cnomres,to_char(eva.dfecvis,'YYYY-MM-DD') as dfecvis,coalesce(eva.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli,' ') as ctipcli,to_char(desem.dfecdes,'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa,to_char(eva.dfeceva,'HH24:MI:SS') as chorreg,
             eva.cfecmod,eva.chormod,eva.cnomreg,eva.cnomsuc,eva.cdeszon,eva.cfecdes,eva.czonpro,
             nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe,
             
             sub_tran.tiptran as Tiptra, nvl(sub_tran.canaini, ' ') as Usutra,
             sub_tran.dfectra as Fectra, sucup.cnomsuc as Agepre, eva.nmoneva as Monto
             
        from (select a.dfeceva,a.cnumdoc,a.cclinom,a.npaicli,a.ntipdoc,a.ncorcli,a.cusuing,a.ctelneg,
                     a.ctelfij,a.ctelmov,asi.ncorasi,asi.ccodusu as cusuasi,a.ncodact,a.ncodbas,a.ccodcal,
                     a.ctipcli,a.ncodage,asi.ncodbas as nasibas,rev.nrespue,rev.cobserv,rev.dfecvis,
                     to_char(asi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(asi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,a.cfecdes,a.czonpro,asi.cusumod,asi.ccodusu,asi.dfecasi,a.nagepre,a.nmoneva
                 from acdeval a
              left join acdasig asi
                  on asi.ncorcli = a.ncorcli 
              left join acdagen agen
                  on agen.ncorasi = asi.ncorasi
              left join acdrevi rev
                  on rev.ncorage = agen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(asi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc        
               where a.ncodact = ps_codact
                 and a.ncodbas = coalesce(ls_codbas, a.ncodbas)
              union
              select b.dfeceva,b.cnumdoc,b.cclinom,b.npaicli,b.ntipdoc,b.ncorcli,b.cusuing,b.ctelneg,
                     b.ctelfij,b.ctelmov,hasi.ncorasi,hasi.ccodusu as cusuasi,b.ncodact,b.ncodbas,b.ccodcal,
                     b.ctipcli,b.ncodage,hasi.ncodbas as nasibas,hrev.nrespue,hrev.cobserv,hrev.dfecvis,
                     to_char(hasi.dfecmod,'YYYY-MM-DD') as cfecmod,to_char(hasi.dfecmod,'HH24:MI:SS') as chormod,
                     zon.cnomreg,zon.cnomsuc,zon.cdeszon,b.cfecdes,b.czonpro,hasi.cusumod,hasi.ccodusu,hasi.dfecasi,b.nagepre,b.nmoneva
                from acheval b
              left join achasig hasi
                  on hasi.ncorcli = b.ncorcli
              left join achagen hagen
                  on hagen.ncorasi = hasi.ncorasi
              left join achrevi hrev
                  on hrev.ncorage = hagen.ncorage
              left join acdagus pau
                  on pau.ccodope = upper(trim(hasi.ccodusu))
              left join actregi zon
                  on zon.ncodsuc = pau.ncodsuc               
               where b.ncodact = ps_codact
                 and b.ncodbas = coalesce(ls_codbas, b.ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      inner join acmsucu sucup
          on sucup.ncodsuc = eva.nagepre
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(eva.cusuasi))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdrepu repu
          on repu.nrespue = eva.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.ncodage
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.ncodage
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
            and f1.pgcod = 1
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope  
      --
      left join (
           select 
                 cnumdoc,
                 canaini,
                 canafin,
                 dfectra,
                 case
                     when canafin is null then 'SIN TRANSFERIR'
                     when canafin = 'USRAGECOM' then 'ALEATORIA'
                     else 'EXCEPCIONAL'
                 end as tiptran
           from (
                 select
                     eva1.cnumdoc,
                     tran.canaini,
                     tran.canafin,
                     tran.dfectra,
                     row_number() over (partition by eva1.cnumdoc order by tran.dfectra desc nulls last) as rn 
                 from agecom.acdeval eva1 
                 left join agecom.acdtran tran 
                 on eva1.cnumdoc = tran.cnumdoc
                 and tran.dfeceva = eva1.dfeceva
             )
             where rn = 1
      ) sub_tran on sub_tran.cnumdoc = eva.cnumdoc
      --
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas,eva.nasibas)
         and trunc(desem.dfecdes) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
   end if;
   else
   if ps_codest = 'F' then
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,
             upper(regi.cnomreg) as reging,upper(regi.cdeszon) as zoning,' ' as DNI,
             rolin.cdesrol,to_char(eva.dfeceva, 'YYYY-MM-DD') as dfecreg,eva.cnumdoc,
             eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,
             eva.ncorcli, eva.cusuing) as ultresing,coalesce(trim(eva.ctelneg), 
             trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             asi.ccodusu,resu.cnomres,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,
             coalesce(rev.cobserv, ' ') as cobserv,coalesce(desem.ctipcli, ' ') as ctipcli,
             to_char(desem.dfecdes, 'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,
             desem.NAOCTA,desem.NAOOPER,desem.NNUMSOL,desem.CNOMANA,
             case
             when trim(desem.ncodmon) = '0' then 'SOLES'
             when trim(desem.ncodmon) = '101' then 'DOLARES'
             else ''
             end as cmoneda,
             desem.ncanimp,desem.cnompro,desem.aotasa, nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe,
             
             sub_tran.tiptran as Tiptra, nvl(sub_tran.canaini, ' ') as Usutra,
             sub_tran.dfectra as Fectra, sucup.cnomsuc as Agepre, eva.nmoneva as Monto

        from (select *
                from acdeval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)
                union
              select *
                from acheval
               where ncodact = ps_codact
                 and ncodbas = coalesce(ls_codbas, ncodbas)) eva
      inner join actacti act
          on act.ncodact = eva.ncodact
      inner join actbase bas
          on bas.ncodbas = eva.ncodbas
         and bas.ncodact = eva.ncodact
      inner join acmsucu sucup
          on sucup.ncodsuc = eva.nagepre
      left join acdatri cal
          on cal.ncodtab = 5
         and cal.ctipatr = 'D'
         and cal.cestado = '1'
         and cal.ccodatr = eva.ccodcal
      left join acdasig asi
          on asi.npaicli = eva.npaicli
         and asi.ntipdoc = eva.ntipdoc
         and asi.cnumdoc = eva.cnumdoc
         and asi.ncodact = eva.ncodact
      left join acdagus pau1
          on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
          on pau.ccodope = upper(trim(asi.ccodusu))
      left join acmsucu age
          on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
          on tip.ncodtab = 9
         and tip.ctipatr = 'D'
         and tip.ccodatr = eva.ctipcli
         and tip.cestado = '1'
      left join acdagen agen
          on agen.npaicli = asi.npaicli
         and agen.ntipdoc = asi.ntipdoc
         and agen.cnumdoc = asi.cnumdoc
         and agen.ncodact = asi.ncodact
      left join acdrevi rev
          on rev.npaicli = agen.npaicli
         and rev.ntipdoc = agen.ntipdoc
         and rev.cnumdoc = agen.cnumdoc
         and rev.ncodact = agen.ncodact
      left join acdrepu repu
          on repu.nrespue = rev.nrespue
      left join acdprre prre
          on prre.npreres = repu.npreres
      left join acdresu resu
          on resu.ncodres = prre.ncodres
      left join ACDDESE desem
          on desem.ncorcli = eva.ncorcli
      left join acdagus usin
          on upper(trim(eva.cusuing)) = usin.ccodope
         and usin.ccodest = '1'
      left join acmsucu sucing
          on sucing.ncodsuc = eva.NCODAGE
      left join acmoper oping
          on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
          on rolin.ncodrol = oping.ccodcar
      left join actregi regi
          on regi.ncodsuc = eva.NCODAGE
      left join actregi regd
          on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
            and f1.pgcod = 1
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
      --
      left join (
           select 
                 cnumdoc,
                 canaini,
                 canafin,
                 dfectra,
                 case
                     when canafin is null then 'SIN TRANSFERIR'
                     when canafin = 'USRAGECOM' then 'ALEATORIA'
                     else 'EXCEPCIONAL'
                 end as tiptran
           from (
                 select
                     eva1.cnumdoc,
                     tran.canaini,
                     tran.canafin,
                     tran.dfectra,
                     row_number() over (partition by eva1.cnumdoc order by tran.dfectra desc nulls last) as rn 
                 from agecom.acdeval eva1 
                 left join agecom.acdtran tran 
                 on eva1.cnumdoc = tran.cnumdoc
                 and tran.dfeceva = eva1.dfeceva
             )
             where rn = 1
      ) sub_tran on sub_tran.cnumdoc = eva.cnumdoc 
      --
       where eva.ncodact = ps_codact
         and eva.ncodbas = coalesce(ls_codbas, asi.ncodbas)
         and trunc(eva.dfeceva) between ls_fecini and ls_fecfin
         and (repu.nrescod = 4 or repu.nrescod is null);
   else
      open lc_liscur for
      select distinct sucing.cnomsuc,coalesce(eva.cusuing, ' ') as cusuing,oping.cnomope,upper(regi.cnomreg) as reging,
             upper(regi.cdeszon) as zoning,' ' as DNI,rolin.cdesrol,to_char(eva.dfeceva, 'YYYY-MM-DD') as dfecreg,
             eva.cnumdoc,eva.cclinom,fn_resusuing(eva.npaicli, eva.ntipdoc, eva.cnumdoc,eva.ncorcli, eva.cusuing) as ultresing,
             coalesce(trim(eva.ctelneg), trim(eva.ctelfij),trim(eva.ctelmov)) as telcli,tip.cdesatr as tipcli,
             asi.ccodusu,resu.cnomres,to_char(rev.dfecvis, 'YYYY-MM-DD') as dfecvis,coalesce(rev.cobserv, ' ') as cobserv,
             coalesce(desem.ctipcli, ' ') as ctipcli,to_char(desem.dfecdes, 'YYYY-MM-DD') as dfecdes,upper(regd.cnomreg) as regdes,
             upper(regd.cdeszon) as zondes,upper(regd.cnomsuc) as sucdes,desem.CNUMDOC,desem.NAOCTA,desem.NAOOPER,
             desem.NNUMSOL,desem.CNOMANA,
              case
              when trim(desem.ncodmon) = '0' then 'SOLES'
              when trim(desem.ncodmon) = '101' then 'DOLARES'
              else ''
              end as cmoneda,
              desem.ncanimp,desem.cnompro,desem.aotasa, nvl(f2.mdnom,' ') as modulo, nvl(f3.tonom,' ') as TipOpe,
             
             sub_tran.tiptran as Tiptra, nvl(sub_tran.canaini, ' ') as Usutra,
             sub_tran.dfectra as Fectra, sucup.cnomsuc as Agepre, eva.nmoneva as Monto

         from (select *
                 from acdeval
                where ncodact = ps_codact
                  and ncodbas = coalesce(ls_codbas, ncodbas)
                union
               select *
                 from acheval
                where ncodact = ps_codact
                  and ncodbas = coalesce(ls_codbas, ncodbas)) eva
      inner join actacti act
           on act.ncodact = eva.ncodact
      inner join actbase bas
           on bas.ncodbas = eva.ncodbas
          and bas.ncodact = eva.ncodact
      inner join acmsucu sucup
           on sucup.ncodsuc = eva.nagepre  
      left join acdatri cal
           on cal.ncodtab = 5
          and cal.ctipatr = 'D'
          and cal.cestado = '1'
          and cal.ccodatr = eva.ccodcal
      left join acdasig asi
           on asi.npaicli = eva.npaicli
          and asi.ntipdoc = eva.ntipdoc
          and asi.cnumdoc = eva.cnumdoc
          and asi.ncodact = eva.ncodact
      left join acdagus pau1
           on pau1.ccodope = upper(trim(eva.cusuing))
      left join acdagus pau
           on pau.ccodope = upper(trim(asi.ccodusu))
      left join acmsucu age
           on age.ncodsuc = pau.ncodsuc
      left join acdatri tip
           on tip.ncodtab = 9
          and tip.ctipatr = 'D'
          and tip.ccodatr = eva.ctipcli
          and tip.cestado = '1'
      left join acdagen agen
           on agen.npaicli = asi.npaicli
          and agen.ntipdoc = asi.ntipdoc
          and agen.cnumdoc = asi.cnumdoc
          and agen.ncodact = asi.ncodact
      left join acdrevi rev
           on rev.npaicli = agen.npaicli
          and rev.ntipdoc = agen.ntipdoc
          and rev.cnumdoc = agen.cnumdoc
          and rev.ncodact = agen.ncodact
      left join acdrepu repu
           on repu.nrespue = rev.nrespue
      left join acdprre prre
           on prre.npreres = repu.npreres
      left join acdresu resu
           on resu.ncodres = prre.ncodres
      left join ACDDESE desem
           on desem.ncorcli = eva.ncorcli
      left join acdagus usin
           on upper(trim(eva.cusuing)) = usin.ccodope
          and usin.ccodest = '1'
      left join acmsucu sucing
           on sucing.ncodsuc = eva.NCODAGE
      left join acmoper oping
           on oping.ccodope = upper(trim(eva.cusuing))
      left join acdrole rolin
           on rolin.ncodrol = oping.ccodcar
      left join actregi regi
           on regi.ncodsuc = eva.NCODAGE
      left join actregi regd
           on regd.ncodsuc = desem.naosuc
      left join fsd010 f1 
            on f1.aocta = desem.naocta
            and f1.aooper= desem.naooper
            and f1.AOPERIOD >0
            and f1.pgcod = 1
      left join fst003 f2
            on f2.modulo=f1.aomod
      left join fst004 f3
            on f3.modulo = f1.aomod
            and f3.totope = f1.aotope
      --
      left join (
           select 
                 cnumdoc,
                 canaini,
                 canafin,
                 dfectra,
                 case
                     when canafin is null then 'SIN TRANSFERIR'
                     when canafin = 'USRAGECOM' then 'ALEATORIA'
                     else 'EXCEPCIONAL'
                 end as tiptran
           from (
                 select
                     eva1.cnumdoc,
                     tran.canaini,
                     tran.canafin,
                     tran.dfectra,
                     row_number() over (partition by eva1.cnumdoc order by tran.dfectra desc nulls last) as rn 
                 from agecom.acdeval eva1 
                 left join agecom.acdtran tran 
                 on eva1.cnumdoc = tran.cnumdoc
                 and tran.dfeceva = eva1.dfeceva
             )
             where rn = 1
      ) sub_tran on sub_tran.cnumdoc = eva.cnumdoc  
      --            
        where eva.ncodact = ps_codact
          and eva.ncodbas = coalesce(ls_codbas, asi.ncodbas)
          and trunc(desem.dfecdes) between ls_fecini and ls_fecfin
          and (repu.nrescod = 4 or repu.nrescod is null);
      end if;
   end if;
end sp_repseguiclientedet2;


end PQ_AGENDA_COMERCIAL;
 /* GOLDENGATE_DDL_REPLICATION */
/
