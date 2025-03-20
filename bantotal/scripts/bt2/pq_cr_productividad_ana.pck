create or replace package PQ_CR_PRODUCTIVIDAD_ANA is
 
    -- *****************************************************************
    -- Nombre                     : PRODUCTIVIDAD DE ANALISTAS DE CREDITO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : DCASTRO - RLIVISI
    -- Uso                        : OBTENER PRODUCTIVIDAD DE ANALISTAS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
    
 -- Procedure sp_migra_prod_analistas(p_c_fecpro in varchar2);
  Procedure sp_job_procesa_datos (pd_fecpro in varchar2 );
 /* Procedure sp_procesa_datos (pn_numsuc in number, pd_fecpro in varchar2 );*/
  Function fn_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number) return number;
  Procedure sp_crea_VM_prodana (pd_fecpro in date, pc_coderr out varchar2 );                         
  Function fn_pa_tip_analista(pc_analista IN varchar2,pd_fecpro in date) return char;
  Function fn_pa_por_mora_ini(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2) return number ;
  Function fn_pa_por_mora(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2, pn_salmor in number, pn_saldo in number, pn_saljud in number) return number ;  
  Function fn_pa_Sal_otorgado(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Cli_otorgado(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Sal_recibido(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Cli_recibido(pc_analista IN varchar2,pd_fecpro in date ) return number ;    
  Function fn_cr_tipo_agencia_metas (P_IN_agen  in number,P_IN_Fecha in date) return char;
  --Function fn_pa_es_clte_new(pn_pais in number, pn_tdoc in number, pc_ndoc IN char, pd_fecpro in date) return number ;
  Function fn_pa_es_clte_new(pn_instancia in number,pc_ndoc IN char) return number;
  Function fn_pa_cliente_new(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r1(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r2(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r3(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r4(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r5(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r6(pc_analista IN char, pd_fecpro in date) return number;
  Function fn_pa_clte_new_r7(pc_analista IN char, pd_fecpro in date) return number;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_bono_cliente_nuevo ( pc_tipcre IN char,
                                      pc_Tipage IN char,
                                      pn_mtosal IN number
                                    ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/*  Procedure sp_job_obtiene_saldos (pd_fecpro in varchar2 );*/
Procedure sp_pa_clte_nuevo(pc_analista IN char, 
                           pd_fecpro in date,
                           pc_tipage in char,
                           pn_numcli out number,
                           /*pn_rango1 out number,
                           pn_rango2 out number,
                           pn_rango3 out number,
                           pn_rango4 out number,
                           pn_rango5 out number,*/
                           pn_mtonue out number
                           );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Function fn_cr_tipo_agencia(P_IN_agen in number) return number;
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_tipo ( pc_clasana IN char, pc_TipAge IN char, pc_Saldo IN number)return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior
  (
    pc_analista IN char,
    pd_fecpro   IN date,
    pc_codage   in number
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior
  (
    pc_analista IN char,
    pd_fecpro   IN date,
    pc_codage   in number
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mes_base
  (
    pc_analista char,
    pd_fecpro   date,
    pn_codage number
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_mes_base
  (
    pc_analista char,
    pd_fecpro   date,
    pn_codage number
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_cli_mes_base
  (
    pc_analista char,
    pd_fecpro   date
  ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_sal_mes_base
  (
    pc_analista char,
    pd_fecpro   date
  ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codase(P_IN_usuario char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_cr_cred_metas
  (
    pc_Tipase IN char,
    pc_Tipage IN char,
    pc_Tipmet IN char,
    pn_codsuc in number
  ) return Number; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_clie_metas
  (
    pc_Tipase IN char,
    pc_Tipage IN char,
    pc_Tipmet IN char,
    pn_codsuc in number
  ) return Number;
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_mora_metas
  (
    pc_Tipase IN char,
    pc_Tipage IN char,
    pc_Tipmet IN char,
    pn_codsuc in number
  ) return Number;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_cr_cliente_cali(Pn_codage in number, Pn_cliente IN Number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_credito_cali(Pn_codage in number, Pn_saldo IN Number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --Function fn_cr_contmes_anterior(Pc_analista IN varchar2) return number;
  Function fn_cr_contmes_anterior(Pc_analista IN varchar2, pd_fecpro in date, pc_codsuc in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contdias_anterior(Pc_analista IN varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_bono_mantenimiento(pd_fecpro in date, pc_analista in varchar2);   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   Function fn_cr_bono_saldo(pc_tipasesor IN char) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
   Function fn_cr_bono_cliente(pc_tipasesor IN char) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
   Function fn_cr_bono_mora(pc_tipasesor IN char) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_analista
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pn_Numcli IN number
  ) return Char;
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_excede_meta_cli
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pc_Tipcla IN char,    
    pn_numcli IN number, --clientes del mes
    pn_metanu IN number, --meta clientes base/clientes maximo
    pn_metmes IN number, --meta cliente mes   
    pn_climesa IN number,
    pn_porcla OUT number,    
    pn_porclm OUT number,        
    pn_bonanu OUT number,    
    pn_bonmen OUT number,
    pn_totanu OUT number,    
    pn_totmes OUT number,
    pn_nummes OUT number,
    pn_numanu OUT number    
  );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_pago_variable_cli
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pc_Tipcla IN char,   
    pc_claana IN char, --clasificacion agencia     
    pn_numcli IN number, --clientes del mes
    pn_metanu IN number, --meta clientes base/clientes maximo
    pn_metmes IN number, --meta cliente mes   
    pn_climesa IN number, --numero de clientes de mes anterior
    pn_porcla OUT number,    
    pn_porclm OUT number,        
    pn_bonanu OUT number,    
    pn_bonmen OUT number,
    pn_totanu OUT number,    
    pn_totmes OUT number,
    pn_nummes OUT number,
    pn_numanu OUT number,
    pc_indexa OUT char,
    pc_indexm OUT char           
  ) ;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_carga_datos_diario2015(pc_sucurs in varchar2 , pd_fecpro in date) ;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos2015(pc_sucurs in varchar2, pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_cr_inserta_cartera_finmes(pd_fecpro in date) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_cr_inserta_cartera_diario(pd_fecpro in date) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_castigados( pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_cartera(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_Sal_Judicial(pc_analista IN varchar2,pd_fecpro in date ) return number;   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_Sal_Castigado(pc_analista IN varchar2,pd_fecpro in date ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_calcula_bonos(pd_fecpro in date, pc_analista in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_bonos_productividad_ini(pd_fecpro in date, pc_analista in char) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_bonos_productividad2015(pn_sucurs in number, pd_fecpro in date, pc_analista in varchar2) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure  sp_cr_retorna_bono_mto(pc_tipasesor IN char, 
                                   pd_fecpro in date,
                                   pn_bono_sal out number,
                                   pn_bono_cli out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_saldo_mora(pc_analista IN varchar2,pd_fecpro in date)return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_nueva_mora(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2, 
                          pn_salmor in number, pn_saljud in number, pn_saldo in number) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_carga(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonomes50_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
 Function fn_cr_bonomes30_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
 Function fn_cr_bonoanu50_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
 Function fn_cr_bonoanu30_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
 Function fn_cr_bonoclia_jaql581(pc_tiagel IN char,
                                 pc_claana IN char             
                                 ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
 Function fn_cr_bonoclim_jaql581(pc_tiagel IN char,
                                 pc_claana IN char             
                                 ) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 
  Function fn_pa_Sal_otorgado_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Cli_otorgado_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Sal_recibido_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number ;
  Function fn_pa_Cli_recibido_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
/*  function fn_pa_Sal_otorgadoF(pc_analista IN varchar2,pd_fecpro in date) return number ;
  function fn_pa_Sal_recibidoF(pc_analista IN varchar2,pd_fecpro in date) return number ;*/
  
/*  Function fn_pa_Cli_otorgadoF(pc_analista IN varchar2,pd_fecpro in date )return number;
  Function fn_pa_Cli_recibidoF(pc_analista IN varchar2,pd_fecpro in date )return number;
*/  
/*  function fn_pa_Sal_otorgadoTOT(pc_analista IN varchar2,pd_fecpro in date) return number ;
  function fn_pa_Sal_recibidoTOT(pc_analista IN varchar2,pd_fecpro in date) return number ;
*/  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_saldo_legal(pc_analista IN varchar2,pd_fecpro in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pa_num_saldo_legal(pc_analista IN varchar2,pd_fecpro in date) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_recalculo( pd_fecpro in date);  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_pa_tip_analista_cal(pc_analista IN CHAR,pd_fecpro in date ) return char;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_recal_mantenimiento(pd_fecpro in date, pc_analista in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure Sp_cr_RECAL_feb_mantenimiento(pd_fecpro in date, pc_analista in varchar2); 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_RECAL_feb_product(pd_fecpro in date, pc_analista in varchar2) ; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_Traslados_jaql969( pd_fecpro in date); 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_traslados( pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_pa_Sal_recibidoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_pa_Sal_OtorgadoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_pa_Cli_OtorgadoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number )return number; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_pa_Cli_RecibidoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number )return number; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_plus_REcalculo(pd_fecpro in date, pc_analista in varchar2);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad_simu(pd_fecpro in date, pc_analista in varchar2);  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad_sim2(pd_fecpro in date, pc_analista in varchar2); 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_job_bono_produ(pd_fecpro in date);  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_agencia( pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_mora_mesbase (  pc_analista IN char, pd_fecpro IN date ) return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_pa_sal_vencido(pc_analista IN varchar2,pd_fecpro in date )return number; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_pa_sal_refinan(pc_analista IN varchar2,pd_fecpro in date )return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_mejora(/*pn_sucurs in number,*/ pd_fecpro in date, pc_analista in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_actualiza_metamora(pd_fecpro in date) ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
/* Function fn_cr_region(pn_codsuc IN number)return number;*/--06.03.2015
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 /*Function fn_cr_guiaMetas(pn_codreg IN number)return varchar2;*/--06.03.2015
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_ult_traslado(pc_analista IN varchar2,pd_fecpro in date )return date; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_AjusteSdoVdo(pc_analista IN varchar2, pd_fecpro in date,
                               pn_nsdve out  number,
                               pn_sdves out  number,
                               pn_sdcas out  number,
                               pn_sdjus out  number,
                               pn_cmdsv out  number,
                               pn_sdres out  number,
                               pn_pgosv out  number,
                               pn_tasdovdo  out  char,
                               pn_svoto out number,
                               pn_svrec out number,                                
                               pn_sroto out number,
                               pn_srrec out number                               
  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_mtopagarSdoVdo(pc_Tipase IN VARCHAR2, pn_SdoVcdo in number) return Number;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_calcula_ajuste_sdvo(pd_fecpro in date, pc_analista in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_tipo_ana_sdovdo(pc_Tipase IN VARCHAR2, pn_SdoVcdo in number) return char;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
 procedure sp_pa_Sal_OtorgadoVdoRef(pc_analista IN varchar2,
                                   pd_fecpro in date,
                                   pn_saldove out number,
                                   pn_saldore out number
                                  );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
 procedure sp_pa_Sal_RecibidoVdoRef(pc_analista IN varchar2,
                                   pd_fecpro in date,
                                   pn_saldove out number,
                                   pn_saldore out number
                                  );   
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                  
 Procedure sp_cr_MetasFeb15(pc_JAQL579TIP in char,
                           pc_JAQL579TASE in char,
                           pc_tipage in char,
                           pn_JAQL579CCLAGE in number,
                           pn_JAQL579CUBC in number,
                           pn_metasal out number,
                           pn_metacli out number,
                           pn_metamor out number                      
                           
                           );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_validaMetasFeb15(pn_agencia in number,
                               pc_jaql579tage in char,
                               pn_JAQL579CCLAGE out number,
                               pn_JAQL579CUBC out number                               
                               );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
 procedure sp_cr_retorna_metas(pc_JAQL579TIP in char, 
                              pc_JAQL579TASE in char, 
                              pc_tipage in char, 
                              pn_agencia in number,
                              pc_codusu in char,                              
                              pn_metasal out number,
                              pn_metacli out number,
                              pn_metamor out number
                              );                              
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_aseagro(pc_codase in char)  return char;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

Procedure sp_cr_MetasEne16(pn_JAQL586codage in number,
                           pn_jaql586ctipmer out number,
                           pn_jaql586cantage out number,
                           pc_jaql586caja out char 
                           );

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                           
Function fn_cr_CategoriaRRHH(pc_JAQL587codana in char, pd_fecpro in date) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_MetasFactor( pd_fecpro in date,
                                     pc_codana in char,
                                     pn_codage in number,
                                     pc_codcaj in char,
                                     pn_tipmer in number,
                                     pn_antage in number,
                                     pn_codcat in number,
                                     pc_tipusu in varchar2
                                     );                           
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_AnalistaPC(pc_analista IN varchar2,pd_fecpro in date, pc_codcaja in varchar2 ) return char;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_RetornaMeta(pc_codase in char,
                            pn_codage in number,
                            pn_mes in number,
                            pn_anio in number,           
                            pn_metsdo out number,
                            pn_metcli out number
          ); 
          
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --           
Function fn_cr_MoraMin(pc_JAQL591tase in varchar2,
                       pn_JAQL591codcat in number,
                       pn_JAQL591cantage in number )              
                               return number; 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
                               
Function fn_cr_PjeCastigo(pc_JAQL591tase in varchar2,
                       pn_JAQL591codcat in number,
                       pn_JAQL591cantage in number,
                       pn_MoraIngresada in number )              
                               return number;        
                                     
                                     
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_carga_datos_diario(pc_sucurs in varchar2 , pd_fecpro in date) ;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_carga_datos(pc_sucurs in varchar2, pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad(pn_sucurs in number, pd_fecpro in date, pc_analista in varchar2) ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_senior  ( pc_analista IN char, pd_fecpro in date  ) return number ;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_zona  ( pn_codsuc IN number  ) return number;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_MoraMinima(pc_JAQL591tase in varchar2,
                       pc_JAQL591codcat in char,
                       pc_JAQL591cantage in char )              
                               return number;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_PjeCastigoMora(pc_JAQL591tase in varchar2,
                       pc_JAQL591codcat in char,
                       pc_JAQL591cantage in char,
                       pn_MoraIngresada in number ) return number ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_valida( pd_fecpro in date);                 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
                        
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                        
end PQ_CR_PRODUCTIVIDAD_ANA;
/

create or replace package body PQ_CR_PRODUCTIVIDAD_ANA is
    -- *****************************************************************
    -- Nombre                     : sp_migra_prod_analistas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : LLLOSA
    -- Uso                        : OBTENER PRODUCTIVIDAD DE ANALISTAS DE CREDITOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.05.28
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico sp_cr_inserta_castigados, sp_inserta_cartera_diario
    -- Descripción de Modificación: Se modifico sp_inserta_cartera_diario retorno de FSD010   
    --                              2014.06.03 Se comentó llamada a proceso sp_cr_inserta_castigados. sp_cr_Traslados_jaql969
    --                              2014.06.04 Se modifico sp_traslados969, se creo job para bono_productividad.
    --                              2014.06.13 Se agrego sp_cr_inserta_agencia para insertar agencia actual.
    --                              2014.06.16 Se modifico sp_cr_inserta_agencia para eliminar registros del mes.
    --                              2014.06.25 Se modifico sp_cr_inserta_cartera_diario.
    --                              2014.07.01 Se modifico sp_cr_calcula_bonos, se creo fn_cr_mora_mesbase, sp_cr_bonos_mejora, fn_pa_sal_vencido, sp_cr_actualiza_metamora
    --                              2014.07.16 Se modifico sp_cr_inserta_agencia, traslados agencia, metas, saldo maximo           
    --                              2014.10.02 Se modifico fn_cr_saldojudicial
    --                              2014.11.17 Se modifico sp_cr_ajusteSdoVdo , fn_cr_tipo_ana_sdovdo
    --                              2014.11.27 Se modifico fn_pa_num_saldo_legal
    --                              2014.11.27 Se modifico sp_cr_carga_datos_diario
    --                              2015.02.04 Se modifico FN_CR_SALDO_MES_BASE,
    --                              2015.05.11 Se modifico saldo maximo = meta mes y clientes maximo = meta clientes para analistas con 1 mes de antiguedad.
    --                              2015.05.12 Se modifico fn_pa_saldo_legal para agregar creditos en estado RefinanciadoJducial Estado 33.
    --                              2016.04.05 Se agrego estados a tablas JAQL587. JAQL588
    --                              2016.05.12 Se agrego guia de proceso para analistas cesados , se ingresa codigo de agencia anterior a cese.
    --                              2016.07.05 Se modifico sp_cr_bonos_productividad- calculo bonificacion cuando codigo de categoria es 0, el monto a pagar se muestra en 0.
    -- *****************************************************************
    
 /*Procedure sp_migra_prod_analistas(p_c_fecpro in varchar2) is

  cursor c_data is
  select  b.user_bt c_codana,
          n_mesant,
          n_diaant,
          d_fecpro,
          n_bonsal,
          n_boncli,
          n_salcre,
          n_numcli,
          1 c_codcma,
          c.sucurs c_codage,
          c_clacli,
          c_clasal,
          n_salant,
          n_cliant,
          n_traslo,
          n_traslr,
          n_trsclr,
          n_trsclo
  from crdbmca@migra2 A,
       Prod_usuarios  B,
       tmp_sucursales C
  where a.c_codana = b.user_sf
    and a.c_codage = c.c_codage
    and a.d_fecpro  >= add_months(to_date(p_c_fecpro,'rrrr.mm.dd'),-6);     
    
  cursor c_data_1 is
  select b.user_bt C_CODANA,
         C_CODCLA,
         N_SALMAX,
         D_FECSMS,
         N_CLIMAX,
         D_FECCMX,
         D_FECPRO,
         C_CODVIG,
         N_MTOSAL,
         N_MTOCLI,
         N_PLSNCL,
         N_PLSNCR,
         N_MTOMOR,
         N_SALCRE,
         N_NUMCLI,
         N_SALJUD,
         N_SALM16,
         N_PORMOR,
         N_NUEDES,
         N_TRASLO,
         N_TRASLR,
         N_TRSCLO,
         N_TRSCLR,
         1 C_CODCMA,
         c.sucurs C_CODAGE,
         C_TIPCLA,
         N_MESANT,
         N_DIAANT,
         N_SALMAN,
         N_CLIMAN,
         N_CRESAN,
         N_CRECAN,
         N_METSAL,
         N_METCLI,
         N_METMOR,
         N_PLSSAM,
         N_PLSCLM
   from crdpana@migra2 A,
        Prod_usuarios  B,
        tmp_sucursales C
  where a.c_codana = b.user_sf
    and a.c_codage = c.c_codage
    and a.d_fecpro  >= add_months(to_date(p_c_fecpro,'rrrr.mm.dd'),-6);            
    
    
  lc_error  varchar2(300);    
  ld_fecini date;
  ln_nro    LOG_CARGA_BANDEJA.N_NRO%type;
  ln_tamano number(5, 2);
  lc_diffec varchar2(5);
  ln_contad number := 0;  
   
  begin
  
  ld_fecini := sysdate;
  
    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'JAQL572',
       'Almacena informacion productividad de Analistas',
       ld_fecini);
    commit;
  
     execute immediate ('truncate table JAQL572');
     execute immediate ('truncate table JAQL583');
  
  
    select seq_nro_ejecucion.currval into ln_nro from dual;    
      
      for i in c_data loop      
      begin
      ln_contad := ln_contad + 1;
      insert into JAQL572(
                                  JAQL572USU,
                                  JAQL572MANT,
                                  JAQL572DANT,
                                  JAQL572FPRO,
                                  JAQL572BSAL,
                                  JAQL572BCLI,
                                  JAQL572SCRE,
                                  JAQL572NCLI,
                                  JAQL572COD,
                                  JAQL572AGEN,
                                  JAQL572CCLI,
                                  JAQL572CSAL,
                                  JAQL572SANT,
                                  JAQL572NCL,
                                  JAQL572SOTO,
                                  JAQL572SREC,
                                  JAQL572CREC,
                                  JAQL572COTO
                                )
                          values( i.c_codana,
                                  i.n_mesant,
                                  i.n_diaant,
                                  i.d_fecpro,
                                  i.n_bonsal,
                                  i.n_boncli,
                                  i.n_salcre,
                                  i.n_numcli,
                                  i.c_codcma,
                                  i.c_codage,
                                  i.c_clacli,
                                  i.c_clasal,
                                  i.n_salant,
                                  i.n_cliant,
                                  i.n_traslo,
                                  i.n_traslr,
                                  i.n_trsclr,
                                  i.n_trsclo
                                 );   
      exception  
      when others then
      lc_error := sqlerrm;            
        insert into LOG_ERROR_BANDEJA
          (n_nro,c_codbdj,c_deserr,d_fecerr)
        values
          (ln_nro,'JAQL572',i.c_codana || ' : ' || lc_error,sysdate);
        commit;               
      end;   
      
      if ln_contad = 9000 then
        commit;
        ln_contad := 0;
      end if;      
      
     end loop;     
     commit;
     
 
    select (ROUND(SUM(BYTES) / 1024 / 1024 / 1024, 2))
      into ln_tamano
      from user_segments
     where segment_name = 'JAQL572';
         
    lc_diffec := substr('0' || floor((sysdate - ld_fecini) * 24), -2) || ':' ||
                 substr('0' || round((((sysdate - ld_fecini) * 24) -
                                     (floor((sysdate - ld_fecini) * 24))) * 60,
                                     0),
                        -2);
  
    update LOG_CARGA_BANDEJA
       set d_fecfin = sysdate, n_sizegb = ln_tamano, c_diffec = lc_diffec
     where n_nro = ln_nro;
    commit;   

    ld_fecini := sysdate;
  
    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'JAQL583',
       'Almacena informacion productividad de Analistas',
       ld_fecini);
    commit;

    select seq_nro_ejecucion.currval into ln_nro from dual;
    
     for i in c_data_1 loop
     begin
     ln_contad := ln_contad + 1;
     insert into JAQL583(
                                  JAQL583USU,
                                  JAQL583TAGE,
                                  JAQL583SMAX,
                                  JAQL583FSMAX,
                                  JAQL583CMAX,
                                  JAQL583FCMAX,
                                  JAQL583FPRO,
                                  JAQL583EST,
                                  JAQL583BSAL,
                                  JAQL583BCLI,
                                  JAQL583PPCM,
                                  JAQL583PPCN,
                                  JAQL583BMRA,
                                  JAQL583SDO,
                                  JAQL583NCL,
                                  JAQL583SDJU,
                                  JAQL583SDM,
                                  JAQL583PMRA,
                                  JAQL583NCN,
                                  JAQL583SOTO,
                                  JAQL583SREC,
                                  JAQL583COT,
                                  JAQL583CREC,
                                  JAQL583PCOD,
                                  JAQL583AGE,
                                  JAQL583TUSU,
                                  JAQL583MANT,
                                  JAQL583DANT,
                                  JAQL583SANT,
                                  JAQL583CANT,
                                  JAQL583CRSA,
                                  JAQL583CRCL,
                                  JAQL583MTSA,
                                  JAQL583MTCL,
                                  JAQL583MTMR,
                                  JAQL583PPLM
                                )
                          values( i.c_codana,
                                  i.c_codcla,
                                  i.n_salmax,
                                  i.d_fecsms,
                                  i.n_climax,
                                  i.d_feccmx,
                                  i.d_fecpro,
                                  i.c_codvig,
                                  i.n_mtosal,
                                  i.n_mtocli,
                                  i.n_plsncl,
                                  i.n_plsncr,
                                  i.n_mtomor,
                                  i.n_salcre,
                                  i.n_numcli,
                                  i.n_saljud,
                                  i.n_salm16,
                                  i.n_pormor,
                                  i.n_nuedes,
                                  i.n_traslo,
                                  i.n_traslr,
                                  i.n_trsclo,
                                  i.n_trsclr,
                                  i.c_codcma,
                                  i.c_codage,
                                  i.c_tipcla,
                                  i.n_mesant,
                                  i.n_diaant,
                                  i.n_salman,
                                  i.n_climan,
                                  i.n_cresan,
                                  i.n_crecan,
                                  i.n_metsal,
                                  i.n_metcli,
                                  i.n_metmor,
                                  i.n_plssam
                                 );   
      exception  
      when others then
      lc_error := sqlerrm;            
        insert into LOG_ERROR_BANDEJA
          (n_nro,c_codbdj,c_deserr,d_fecerr)
        values
          (ln_nro,'JAQL583',i.c_codana || ' : ' || lc_error,sysdate);
        commit;               
      end;   
      
      if ln_contad = 9000 then
        commit;
        ln_contad := 0;
      end if;      
      
     end loop;     
     commit;
     
      
    select (ROUND(SUM(BYTES) / 1024 / 1024 / 1024, 2))
      into ln_tamano
      from user_segments
     where segment_name = 'JAQL583';
         
    lc_diffec := substr('0' || floor((sysdate - ld_fecini) * 24), -2) || ':' ||
                 substr('0' || round((((sysdate - ld_fecini) * 24) -
                                     (floor((sysdate - ld_fecini) * 24))) * 60,
                                     0),
                        -2);
  
    update LOG_CARGA_BANDEJA
       set d_fecfin = sysdate, n_sizegb = ln_tamano, c_diffec = lc_diffec
     where n_nro = ln_nro;
    commit;                
            
  exception
  when others then
  lc_error := sqlerrm;            
    insert into LOG_ERROR_BANDEJA
      (n_nro,c_codbdj,c_deserr,d_fecerr)
    values
      (ln_nro,'JAQL583',lc_error,sysdate);
    commit;
    return;
       
    
         
   
  end sp_migra_prod_analistas;*/

Procedure sp_job_procesa_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
     execute immediate ('truncate table prodana');
     delete Tab_jobs where  c_Codage = 'PRO';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  PQ_CR_PRODUCTIVIDAD_ANA.sp_procesa_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2, ---1:DESA1    2:PRODUCCION  03.02.2015
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('PRO',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'PRODANA',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
/*Procedure sp_procesa_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 

  cursor rubro is
  select rubro  
   from  fsd014 
  where pcnivc in (select modulo from  fst111 where dscod = 50 and modulo not in (29,\*33,200,*\120,144)\*union all select 117 from dual*\)
    and pcimpu = 'S'
    \*and substr(rubro,1,1) <> 9*\ ;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'PRO';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in rubro loop
     begin 
       insert into prodana 
       select\*+all_rows *\ \*+parallel(sal,4,@2)*\
             \*PQ_CR_PRODUCTIVIDAD_ANA.*\fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
             sal.bcrubr,
             abs(sal.bcsdmn), 
             sal.BCEMP,
             sal.bcmod,
             sal.bcsuc,
             sal.bcmda,
             sal.bcpap,
             sal.bccta,
             sal.bcoper,
             sal.bcsbop,
             sal.bctop,
             fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,0,sal.bcfvto ) dias_mora,
             sal.bcfval,
             sal.bcfvto,
             cta.pepais,
             cta.petdoc,
             cta.pendoc,
             SAL.BCFECH
        from  fsh012 sal,  fsr008 cta
       where sal.bcmod not in (108) and (bcmod <> 106 Or bctop <> 30)
         and sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech = ld_fecpro
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro (+)
         and cta.pgcod (+) = 1 
         and cta.cttfir (+) = 'T' 
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'PRODANA',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'PRO';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'PRO';
    commit;
    return;

end sp_procesa_datos;  
*/
Function fn_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
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
  ln_instancia number;        
  begin
    case when pn_mod = 116 then -- lineas buscar relacion 
            begin 
               select distinct d.xwfprcins 
                 into ln_instancia
                from  fsr011 hh,  xwf700 d 
                where relcod = 46
                       and hh.r2cod  = d.xwfempresa   
                       and hh.r2mod  = d.xwfmodulo
                       and hh.r2suc  = d.xwfsucursal
                       and hh.r2mda  = d.xwfmoneda
                       and hh.r2pap  = d.xwfpapel
                       and hh.r2cta  = d.xwfcuenta
                       and hh.r2oper = d.xwfoperacion
                       and hh.r2sbop = d.xwfsubope
                       and hh.r2tope = d.xwftipope
                       and hh.r1cod  = 1
                       and hh.r1mod  = pn_mod
                       and hh.r1suc  = pn_suc
                       and hh.r1mda  = pn_mda
                       and hh.r1pap  = pn_pap
                       and hh.r1cta  = pn_cta
                       and hh.r1oper = pn_oper
                       and hh.r1sbop = pn_sbop
                       and hh.r1tope = pn_top;
             exception
                when no_data_found then
                     begin 
                           select distinct d.xwfprcins 
                             into ln_instancia
                            from  fsr011 hh,  xwf700 d 
                            where relcod = 46
                                   and hh.r2cod  = d.xwfempresa   
                                   and hh.r2mod  = d.xwfmodulo
                                   and hh.r2suc  = d.xwfsucursal
                                   and hh.r2mda  = d.xwfmoneda
                                   and hh.r2pap  = d.xwfpapel
                                   and hh.r2cta  = d.xwfcuenta
                                   and hh.r2oper = d.xwfoperacion
                                   and hh.r2sbop = d.xwfsubope
                                   and hh.r2tope = d.xwftipope
                                   and hh.r1cod  = 1
                                   and hh.r1mod  = pn_mod
                                   and hh.r1suc  = pn_suc
                                   and hh.r1mda  = pn_mda
                                   and hh.r1pap  = pn_pap
                                   and hh.r1cta  = pn_cta
                                   and hh.r1oper = pn_oper
                                   --and hh.r1sbop = pn_sbop
                                   and hh.r1tope = pn_top;
                     exception
                            when no_data_found then
                                    ln_instancia := null;
                            when too_many_rows then    
                                    ln_instancia := 0;
                     end; 
                when too_many_rows then    
                     ln_instancia := 0;
             end; 
         when pn_mod in (200,33) then -- cartera judicial, castigados
              begin
               select sol.xwfprcins 
                 into ln_instancia
                 from  xwf700 sol   
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                        from  xwf700 sol  
                       where sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                              from  xwf700 sol  
                             where sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                ln_instancia := 0;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins)
                       into ln_instancia
                       from  xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        ln_instancia := 0;
                  end;
            end;
         
         when pn_top = 550 then -- prejudicial con demanda
            begin
               select xwfprcins 
                 into ln_instancia
                from  xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                       from  xwf700 sol   
                       where sol.xwfmodulo   = pn_mod    
                         and sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                             from  xwf700 sol   
                             where sol.xwfmodulo   = pn_mod    
                               and sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                ln_instancia := 0;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from  xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        ln_instancia := 0;
                  end;
            end;
         
         else -- prestamos normales
            begin
               select xwfprcins 
                 into ln_instancia
                from  xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                  ln_instancia := null;
               when too_many_rows then    
                  begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from  xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        ln_instancia := 0;
                  end;
            end;
        end case;
     
    return ln_instancia;

  end fn_pa_instancia;

Procedure sp_crea_VM_prodana (pd_fecpro in date, pc_coderr out varchar2 ) is
ld_proant date;
begin
 ld_proant:= ADD_MONTHS(pd_fecpro,-1);
 execute immediate ('DROP materialized view VM_PRODANA');
 execute immediate ('create materialized view VM_PRODANA
                    PARALlEL   5  
                    BUILD ImMEDIATE 
                    REFRESH ON DEMAND  
                    as
                    select/*+all_rows */ /*+parallel(inst,4,@2)*/
                          /*+parallel(car,4,@2)*/ 
                          /*+parallel(age,4,@2)*/ /*+parallel(sal,4,@2)*/
                          /*+parallel(mesa,4,@2)*/ /*+parallel(maxi,4,@2)*/
                           car.cargocod,inst.sng001ase,car.agtecod, 
                           car.agtenom, car.agtesuc, age.scnom,mesa.jaql572scre, mesa.jaql572ncli,
                           maxi.jaql583smax, maxi.jaql583cmax, 
                           sal.instancia,
                           sal.bcrubr,
                           sal.bcsdmn, 
                           sal.BCEMP,
                           sal.bcmod,
                           sal.bcsuc,
                           sal.bcmda,
                           sal.bcpap,
                           sal.bccta,
                           sal.bcoper,
                           sal.bcsbop,
                           sal.bctop,
                           sal.dias_mora
                      from  sng001 inst, 
                            fst156 car,
                            fst001 age,
                           migra2.prodana sal,
                           migra2.JAQL572 mesa,
                           migra2.JAQL583 maxi
                    where sal.instancia = inst.sng001inst
                      and inst.sng001ase = car.agteusr
                      and car.agtesuc = age.sucurs
                      and mesa.jaql572usu (+) = inst.sng001ase 
                      and mesa.jaql572fpro (+) = '||ld_proant||' 
                      and maxi.jaql583usu (+) = mesa.jaql572usu
                      and maxi.jaql583fpro (+)= mesa.jaql572fpro ');
  
 execute immediate ('create index  IDX_VM_PRODANA_01 on  VM_PRODANA(sng001ase)');    
 execute immediate ('create index  IDX_VM_PRODANA_02 on  VM_PRODANA(BCEMP,bcmod,bcsuc,bcrubr,bcmda,bcpap,bccta,bcoper,bcsbop,bctop)');
 execute immediate ('create index  IDX_VM_PRODANA_03 on  VM_PRODANA(instancia)');


 EXCEPTION
    when others then
      pc_coderr := substr(sqlerrm,1,200);
    return;

end sp_crea_VM_prodana; 

Function fn_pa_tip_analista(pc_analista IN varchar2,pd_fecpro in date ) return char is
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
    -- Parámetros de Salida       : tipo Analista: Convenio /Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcli char(2);
    cursor saldo is
      select /*+all_rows */
       decode(JAQL965MOD, 107, 107, 100) modulo, sum(JAQL965SDMN) saldo
        from JAQL965
       where JAQL965FECH = pd_fecpro
         and JAQL965ASE = pc_analista
         and JAQL965MOD not in (108, 33, 200)
         and --(JAQL965MOD <> 106 Or JAQL965TOP <> 30)
         (case when JAQL965MOD = 106 and JAQL965TOP = 30 then 0 else 1 end) = 1
       group by decode(JAQL965MOD, 107, 107, 100);
       
  lc_tipana char(1);
  ln_saldo number;       
  begin
       ln_saldo := 0;
      /* for i in saldo loop
          if  i.saldo > ln_saldo  then   
             if i.modulo = 107 then
                lc_tipana := 'C';
             else
                lc_tipana := 'P';    
             end if;
          else
             if i.modulo = 107 then
                lc_tipana := 'P';
             else
                lc_tipana := 'C';    
             end if;
          end if;   
          ln_saldo := i.saldo;
       end loop;*/
       
       for i in saldo loop
          if  i.saldo > ln_saldo  then   
             if i.modulo = 107 then
                lc_tipana := 'C';
             else
                lc_tipana := 'P';    
             end if;
          /*else
             if i.modulo = 107 then
                lc_tipana := 'P';
             else
                lc_tipana := 'C';    
             end if;*/
             
             ln_saldo := i.saldo;
          end if;   
--          ln_saldo := i.saldo;
          --dbms_output.put_line(ln_saldo|| ' ' ||i.modulo||' '||i.saldo||' ' ||lc_tipana );
       end loop;
       
     if ln_saldo = 0 then --2014.03.14 si analista no tiene saldo le corresponde clasificacion PYMES
       lc_tipana := 'P'; 
    end if;     
    return lc_tipana;

  end fn_pa_tip_analista;
  
  
  
Function fn_pa_por_mora_ini(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2) return number is
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

  ln_pormor number; 
  ln_saljud number := 0;
  ln_nummes number := 0;
  ln_cont number := 0;
        
  begin
  
     begin
       select /*+parallel(j,2) */count(*)
         into ln_cont
         from jaql966 j
        where trim(jaql966usr) = trim(pc_analista) and jaql966suc = pc_codsuc;
     exception when no_data_found then
               ln_cont := 0;
     end; 
   
     if ln_cont > 0 then
        ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(pc_analista,pd_fecpro, pc_codsuc);
     else
        ln_nummes := 0;
        ln_saljud := 0;
     end if;                                                           
   
     if ln_nummes >= 6 then --considerar saldo judicial
        ln_saljud :=  pq_cr_productividad_ana.fn_cr_sal_judicial(pc_analista,pd_fecpro );     
     end if;
         
     begin      
        select /*+parallel(j,2) */round((sum(case
                            when j.JAQL965DATR > 15 and j.JAQL965MOD not in (200, 33) then
                             j.JAQL965SDMN + ln_saljud
                            else
                             0
                          end) / sum(j.JAQL965SDMN + ln_saljud)) * 100,
                     2) por_mor
                     /*,
               sum(case
                     when JAQL965DATR > 15 and JAQL965MOD not in (200, 33) then
                      JAQL965SDMN
                     else
                      0
                   end)*/
                   /*,
               sum(JAQL965SDMN)*/
          into ln_pormor             
          from JAQL965 j
         where j.jaql965fech = pd_fecpro
           and trim(j.JAQL965ASE) = trim(pc_analista)
           and j.JAQL965MOD not in (108,200,33)
           and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
              
       --AGRGAR VALIDACION DE FECHA DE ASIGNACION DE ANALISTA    
      exception 
        when others then 
         ln_pormor := 0;
      end;
  
    
    return ln_pormor;  
   
  end fn_pa_por_mora_ini;


Function fn_pa_por_mora(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2, pn_salmor in number, pn_saldo in number, pn_saljud in number) return number is
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

  ln_pormor number; 
  ln_saljud number := 0;
  ln_nummes number := 0;
  ln_cont number := 0;
  ln_saldo number := 0;
     
  begin
  
  ln_saljud := pn_saljud;
  ln_saldo := pn_saldo;
  
     begin
       select /*+parallel(j,2) */count(*)
         into ln_cont
         from jaql966 j
        where trim(jaql966usr) = trim(pc_analista) and jaql966suc = pc_codsuc;
     exception when no_data_found then
               ln_cont := 0;
     end; 
   
     if ln_cont > 0 then
        ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(pc_analista,pd_fecpro, pc_codsuc);
     else
        ln_nummes := 0;
        ln_saljud := 0;
     end if;                                                           
   
     if ln_nummes < 6 then --NO considerar saldo judicial
        ln_saljud :=  0;     
     end if;
         
     
     /*begin      
        select sum(j.JAQL965SDMN) 
          into ln_saldo             
          from JAQL965 j
         where j.jaql965fech = pd_fecpro
           and trim(j.JAQL965ASE) = trim(pc_analista)
           and j.JAQL965MOD not in (108,200,33)
           and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
      exception 
        when others then 
         ln_saldo := 0;
      end;*/
  
      ---calcular mora 
      ln_pormor := round( (pn_salmor  + ln_saljud ) / (ln_saldo + ln_saljud) * 100,2);
    
    return ln_pormor;  
   
end fn_pa_por_mora;


Function fn_pa_Sal_otorgado(pc_analista IN varchar2,pd_fecpro in date ) return number is
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
    ln_saloto number;   
    ln_saltot number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
      begin
       
        select --/*+parallel(a,2) parallel(b,2) */ 
          /*+index_ss(a)  parallel(a,2) parallel(b,2) */
          sum(c.Jaql965sdmn)--, count(distinct bccta),sng095_201404asnu 
          into ln_saloto
          from sng095 a, SNGAS2 b, JAQL965 c 
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asan
           and b.sngas2usr = pc_analista
           and a.sng095inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200;
       exception when no_data_found then
              ln_saloto := 0;           
       end;                                                   
           
         begin      
           ln_saltot := pq_cr_productividad_ana.fn_pa_sal_otorgado_tabla(pc_analista => pc_analista,
                                                                         pd_fecpro => pd_fecpro);
         exception when no_data_found then
            ln_saltot := 0;           
         end;
         ln_saloto := nvl(ln_saloto,0) + nvl(ln_saltot,0);
          /*group by sng095_201404asnu*/
    return ln_saloto;

  end fn_pa_Sal_otorgado;
  
  Function fn_pa_Cli_otorgado(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_clioto number;   
    ln_clitot number;
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');

      begin 
        select-- /*+index_ss(a) index_ss(b) parallel(c,2)*/  
        /*+index_ss(a)  parallel(a,2) parallel(b,2) */
         count(distinct C.JAQL965CTA)
          into ln_clioto
          from sng095 a, SNGAS2 b, JAQL965 c 
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asan
           and b.sngas2usr = pc_analista
           and a.sng095inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200;           
        exception when no_data_found then
              ln_clioto := 0;          
        end;
       
        begin
          ln_clitot := pq_cr_productividad_ana.fn_pa_cli_otorgado_tabla(pc_analista => pc_analista,
                                                                        pd_fecpro => pd_fecpro);
        end; 
        ln_clioto := nvl(ln_clioto,0) + nvl(ln_clitot,0);
          
    return ln_clioto;

  end fn_pa_Cli_otorgado;
  
  Function fn_pa_Sal_recibido(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saloto number;   
    ln_saltot number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_saloto := 0;
       begin
        select /*+index_ss(a) index_ss(b)*/sum(c.Jaql965sdmn)--, count(distinct bccta),sng095_201404asnu 
          into ln_saloto
          from sng095 a, SNGAS2 b, JAQL965 c 
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asnu
           and b.sngas2usr = pc_analista
           and a.sng095inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro 
           and c.jaql965mod <> 200;                     
          /*group by sng095_201404asnu*/
        exception when no_Data_found  then
            ln_saloto := 0;
          end;
         
        begin
          ln_saltot := pq_cr_productividad_ana.fn_pa_sal_recibido_tabla(pc_analista => pc_analista,
                                                                        pd_fecpro => pd_fecpro);
        end; 
        ln_saloto := nvl(ln_saloto,0) + nvl(ln_saltot,0);
          
    return ln_saloto;

  end fn_pa_Sal_recibido;
  
  
  Function fn_pa_Cli_recibido(pc_analista IN varchar2,pd_fecpro in date ) return number is
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
    ln_clioto number;
    ln_clitot number;
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clioto := 0;
       begin
        select /*+index_ss(a) index_ss(b)*/count(distinct C.JAQL965CTA)
          into ln_clioto
          from sng095 a, SNGAS2 b, JAQL965 c 
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asnu
           and b.sngas2usr = pc_analista
           and a.sng095inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200;           
          /*group by sng095_201404asnu*/
        exception when no_Data_found  then
               ln_clioto := 0;                                                           
        end;
        begin
          ln_clitot := pq_cr_productividad_ana.fn_pa_cli_recibido_tabla(pc_analista => pc_analista,
                                                                        pd_fecpro => pd_fecpro);
        end; 
        ln_clioto := nvl(ln_clioto,0) + nvl(ln_clitot,0);   
    return ln_clioto;

  end fn_pa_Cli_recibido;

Function fn_cr_tipo_agencia_metas
  (
    P_IN_agen  in number,
    P_IN_Fecha in date
  ) return char is
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
        select substr(tpdesc,1,1) 
          into lc_tipage
      from  fst098 
      where pgcod = 1 
        and tpcod = 7662
        and tpnro = P_IN_agen;  ---buscar si existen excepciones
    exception when no_data_found then
         lc_tipage := 'X';         
    end;     
    

    if lc_tipage = 'X' then
  /*
        begin

          -- Nuevas

          Select Months_between(P_IN_Fecha, scax2)
            into ln_conmes
            from fst601
           where fst601suc = P_IN_agen and nvl(SCAX1,'N') <> 'S'
             and pgcod = 1;
         exception
          when no_data_found then
            lc_tipage := 'X';
         End;

          If ln_conmes <= 12 then
            lc_tipage := 'N';
          End If;
  */
       begin 
            
          select count(*)
            into ln_conmes 
            from jaql586
           where jaql586codage =  P_IN_agen
             and jaql586cantage = 1 ; --NUEVA           
       exception when no_data_found then
            lc_tipage := 'X';
       End;

       If ln_conmes = 1 then
          lc_tipage := 'N';
       else
          lc_tipage := 'X';
       End If;
        
       
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

    end if;   

    return lc_tipage;

  end fn_cr_tipo_agencia_metas;
  
--Function fn_pa_es_clte_new(pn_pais in number, pn_tdoc in number, pc_ndoc IN char, pd_fecpro in date) return number is
Function fn_pa_es_clte_new(pn_instancia in number,pc_ndoc IN char) return number is
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
   
  --ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  
     
  begin
       --ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
           begin
              select count(*)
                into ln_cuenta
                from /*sng001_201406*/sng001 
               where sng001inst = pn_instancia
                 and sng001tpcr = 1;
           exception
             when no_data_found then
               ln_cuenta := 0;
             when others then
               null;
           end;
           if ln_cuenta > 0 then
              -- verifica que no exista en sorfy
              
              begin
               select count(*)
                 into ln_cuenta
                 from crwcred/*/@consulta/ */a, 
                      clmpers/*/@consulta/*/ b
                  where a.c_CODPER = b.c_codper
                    and a.c_numdoc = b.c_numdoc
                    and b.c_numdoc = trim(pc_ndoc);
              exception
                   when no_data_found then
                     ln_cuenta := 0;
                   when others then
                     null;  
              end;  --comentar para q se deje compilar 10Jul2014 10:53am 
              
              if ln_cuenta = 0 then
                 ln_clinew := 1;
              else
                 ln_clinew := 0;
              end if;   
           end if;      --09Julio2015-9:33am
    return ln_clinew;
  end fn_pa_es_clte_new;  


Function fn_pa_cliente_new(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
    select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst
      from jaql965 x
     where x.jaql965ase = pc_analista
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
                x.jaql965pais,
                x.jaql965tdoc,
                x.jaql965ndoc,
                x.jaql965inst;
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
           begin
              select count(*)
                into ln_cuenta
                from /*sng001_201406*/sng001 
               where sng001inst = i.jaql965inst
                 and sng001tpcr = 1; -- nuevo

           exception
             when no_data_found then
               ln_cuenta := 0;
             when others then
               null;
           end;
          /* if ln_cuenta > 0 then
              -- verifica que no exista en sorfy
              begin
               select count(*)
                 into ln_cuenta
                 from sorfy_migra.crwcred a, 
                      sorfy_migra.clmpers b
                  where a.c_CODPER = b.c_codper
                    and b.c_numdoc = trim(i.jaql965ndoc);
              exception
                   when no_data_found then
                     ln_cuenta := 0;
                   when others then
                     null;  
              end;
              if ln_cuenta = 0 then
                 ln_clinew := ln_clinew + 1;
              end if;   
           end if;   */
       end loop;
    return ln_clinew;

  end fn_pa_cliente_new;  
  
   Function fn_pa_clte_new_r1(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
     select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where x.jaql965ase = pc_analista
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
               
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
             
     --OBTENER EL TIPO DE CREDITO..... Pymes O CONSUMO
     --
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
          --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
           ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);  
          if ln_cuenta = 1 and abs(i.bcsdmn) <= 5000 then
              ln_clinew := ln_clinew + 1;
          end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r1;  
  Function fn_pa_clte_new_r2(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
    select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
            
           --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
          ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);           
          if ln_cuenta = 1 and abs(i.bcsdmn) > 5000  and abs(i.bcsdmn) <= 20000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r2;  
  
  Function fn_pa_clte_new_r3(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
     select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
            
           --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
           ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);
          if ln_cuenta = 1 and abs(i.bcsdmn) > 20000  and abs(i.bcsdmn) <= 50000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r3;  
  
  Function fn_pa_clte_new_r4(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
    select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
          --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
          ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);
          if ln_cuenta = 1 and abs(i.bcsdmn) > 50000  and abs(i.bcsdmn) <= 100000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r4; 
  
  Function fn_pa_clte_new_r5(pc_analista IN char, pd_fecpro in date) return number is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
    select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
            
           --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
           ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);
          if ln_cuenta = 1 and abs(i.bcsdmn) > 1000000 then--  and abs(i.bcsdmn) <= 200000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r5;  
  
  Function fn_pa_clte_new_r6(pc_analista IN char, pd_fecpro in date) return number is
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
 
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
   select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
            
           --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
           ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);
          if ln_cuenta = 1 and abs(i.bcsdmn) > 200000  and abs(i.bcsdmn) <= 500000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r6;  
  
  Function fn_pa_clte_new_r7(pc_analista IN char, pd_fecpro in date) return number is
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
 
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  cursor clientes (ld_fecini in date) is
   select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod, 107, 107, 100),
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where trim(x.jaql965ase) = TRIM(pc_analista)
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod, 107, 107, 100);
     
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       for i in clientes (ld_fecini) loop
            
           --ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.Jaql965pais,i.Jaql965tdoc,i.Jaql965ndoc,pd_fecpro);   
           ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);
           
          if ln_cuenta = 1 and abs(i.bcsdmn) > 500000 then
              ln_clinew := ln_clinew + 1;
           end if;   
       end loop;
    return ln_clinew;

  end fn_pa_clte_new_r7;  
   

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_bono_cliente_nuevo ( pc_tipcre IN char,
                                      pc_Tipage IN char,
                                      pn_mtosal IN number
                                    ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bono_cliente_nuevo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                             P_IN_tipcre: tipo de credito: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :Bono por numero de clientes
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_plusnuevo number;
    
  begin

    begin 
      select jaql582plus
        into ln_plusnuevo     
        from jaql582
       where jaql582tage = pc_Tipage
         and jaql582tase = pc_tipcre
         and jaql582smax = pn_mtosal   
         and jaql582est = 'S';    
     
     exception when no_data_found then 
          ln_plusnuevo := 0;                  
     end;
     
     
     return ln_plusnuevo;

  end fn_cr_bono_cliente_nuevo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/*Procedure sp_job_obtiene_saldos (pd_fecpro in varchar2 ) is  
  
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
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
  
cursor creditos is
  select\*+all_rows *\ --to_date(&ld_fecpro,'yyyymmdd') d_fecpro,
         deca.sng055dsc cargo,\*car2.cargocod ,*\ a.jaql965ase cod_analista, 
         agtenom analista, agtesuc agencia, scnom nombre_agencia,
         pq_cr_productividad_ana.fn_pa_tip_analista(a.jaql965ase) Tipo_analista ,
         sum(bcsdmn) Saldo_cartera, 
         count(distinct pendoc) Nro_clientes,
         pq_cr_productividad_ana.fn_pa_Sal_otorgado(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Saldo_Otorgado,
         pq_cr_productividad_ana.fn_pa_Sal_recibido(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Saldo_Recibido,
         pq_cr_productividad_ana.fn_pa_Cli_otorgado(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Cliente_Otorgado,
         pq_cr_productividad_ana.fn_pa_Cli_recibido(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Cliente_recibido,
         pq_cr_productividad_ana.fn_pa_por_mora (a.jaql965ase) Por_Mora ,
         pq_cr_productividad_ana.fn_pa_cliente_new (a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Clientes_Nuevos,
         jaql572scre sal_cre_mes_anterior, 
         jaql572ncli Nro_cli_mes_anterior,
         jaql583smax Sal_maximo, 
         jaql583cmax Cli_maximo,
         --substr(sal.bcrubr,1,6)rubro ,
         pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(agtesuc,to_date(pd_fecpro,'yyyymmdd')) Tipo_agencia,
         pq_cr_productividad_ana.fn_pa_clte_new_r1(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_3000 ,
         pq_cr_productividad_ana.fn_pa_clte_new_r2(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_10000,
         pq_cr_productividad_ana.fn_pa_clte_new_r3(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_50000,
         pq_cr_productividad_ana.fn_pa_clte_new_r4(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_100000,
         pq_cr_productividad_ana.fn_pa_clte_new_r5(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_200000,
         pq_cr_productividad_ana.fn_pa_clte_new_r6(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_500000,
         pq_cr_productividad_ana.fn_pa_clte_new_r7(a.jaql965ase,to_date(pd_fecpro,'yyyymmdd')) Rango_may_500000
    from JAQL965 a,  
         SNG057 car, 
         sng055 deca 
  where bcmod not in (108, 33, 200) and (bcmod <> 106 Or bctop <> 30)  --no incluye judiciales
    --and sng001ase in ('OFLORES')
    and car.sng057usr = a.jaql965ase 
    and car.sng055car = deca.sng055car 
    and car.sng055car in (200,201)
  group by deca.sng055dsc, a.jaql965ase,
         agtenom, agtesuc, scnom,--substr(sal.bcrubr,1,6)
         jaql572scre, jaql572ncli,
         jaql583smax, jaql583cmax ;

 lc_Tipo_analista jaql577.jaql577tipo%type;
         
begin

   for i in creditos loop
   
       lc_Tipo_analista := pq_cr_productividad_ana.fn_cr_asesor_tipo(i.Tipo_analista,i.Tipo_agencia,i.Saldo_cartera);
   
       insert into jaql583 (jaql583fpro,jaql583usu, jaql583age, jaql583tusu, jaql583sdo, jaql583ncl,
              jaql583soto, jaql583srec, jaql583cot, jaql583crec, jaql583ncn,
              jaql583sant, jaql583cant, jaql583smax, jaql583cmax, jaql583tage, 
              jaql583sdc1, jaql583sdc2, jaql583sdc3, jaql583sdc4, jaql583sdc5, 
              jaql583sdc6, jaql583sdc7 )
   
           
       values ( to_date(pd_fecpro,'yyyymmdd'), i.cod_analista, i.agencia, lc_Tipo_analista, i.Saldo_cartera, i.Nro_clientes, 
                i.Saldo_Otorgado, i.Saldo_Recibido, i.Cliente_Otorgado, i.Cliente_recibido, i.Clientes_Nuevos,
                i.sal_cre_mes_anterior, i.Nro_cli_mes_anterior, i.Sal_maximo, i.Cli_maximo, i.Tipo_agencia,
                i.Rango_3000 , i.Rango_10000, i.Rango_50000, i.Rango_100000, i.Rango_200000, i.Rango_500000,
                i.Rango_may_500000
              );
       
       commit; 
   
   end loop;  
   


End  sp_job_obtiene_saldos;*/
  
Procedure sp_pa_clte_nuevo(pc_analista IN char, 
                           pd_fecpro in date,
                           pc_tipage in char,
                           pn_numcli out number,
                          /* pn_rango1 out number,
                           pn_rango2 out number,
                           pn_rango3 out number,
                           pn_rango4 out number,
                           pn_rango5 out number,*/
                           pn_mtonue out number
                           )is
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
  lc_tipage char(1);  
  ld_fecini date;
  ln_clinew number;
  ln_cuenta number;
  
  cursor clientes (ld_fecini in date) is
     select /*+all_rows */(Case
             when x.jaql965fval between ld_fecini and
                  pd_fecpro then 1
             else 9 end) nuevo,
           x.jaql965pais,
           x.jaql965tdoc,
           x.jaql965ndoc,
           x.jaql965inst,
           decode(x.jaql965mod,107,107,100) modulo,
           sum(x.jaql965sdmn) bcsdmn
      from jaql965 x
     where x.jaql965ase = pc_analista
       and (Case when x.jaql965fval between ld_fecini and
             pd_fecpro then 1 else 9 end) = 1
               
     group by (Case
                when x.jaql965fval between ld_fecini and
                     pd_fecpro then 1
                else 9 end),
             x.jaql965pais,
             x.jaql965tdoc,
             x.jaql965ndoc,
             x.jaql965inst,
             decode(x.jaql965mod,107,107,100);
             
     --OBTENER EL TIPO DE CREDITO..... Pymes O CONSUMO
     --
 ln_totbono  number := 0;   
 ln_bonoini  number := 0;
 ln_monto    number := 0;
 lc_tipcre  char(1);
 
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clinew := 0;
       
       for i in clientes (ld_fecini) loop
          if i.modulo = 107 then
             lc_tipcre := 'C' ;
          else
             lc_tipcre := 'P' ;
          end if;
          ln_cuenta := PQ_CR_PRODUCTIVIDAD_ANA.fn_pa_es_clte_new(i.jaql965inst,i.jaql965ndoc);  
          ln_monto := abs(i.bcsdmn);
          if ln_cuenta = 1 then
              case
                when ln_monto <= 5000 then
                     ln_clinew := ln_clinew + 1;
                     ln_bonoini := pq_cr_productividad_ana.fn_cr_bono_cliente_nuevo(lc_tipcre,pc_tipage,5000);
                when ln_monto > 5000 and ln_monto <= 20000 then
                     ln_bonoini := pq_cr_productividad_ana.fn_cr_bono_cliente_nuevo(lc_tipcre,pc_tipage,20000);
                     ln_clinew := ln_clinew + 1;
                when ln_monto > 20000 and ln_monto <= 50000 then
                     ln_clinew := ln_clinew + 1;
                     ln_bonoini := pq_cr_productividad_ana.fn_cr_bono_cliente_nuevo(lc_tipcre,pc_tipage,50000);                     
                when ln_monto > 50000 and ln_monto <= 100000 then
                     ln_clinew := ln_clinew + 1;
                     ln_bonoini := pq_cr_productividad_ana.fn_cr_bono_cliente_nuevo(lc_tipcre,pc_tipage,100000);                     
                when ln_monto > 100000 then
                     ln_clinew := ln_clinew + 1;
                     ln_bonoini := pq_cr_productividad_ana.fn_cr_bono_cliente_nuevo(lc_tipcre,pc_tipage,999999999999.99);
              end case;
              ln_totbono := ln_totbono + ln_bonoini;
          end if;   
          
       end loop;
       pn_numcli := ln_clinew; --total de clientes nuevos
       pn_mtonue := ln_totbono; --total monto bono por clientes nuevos
       
  end sp_pa_clte_nuevo;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia(P_IN_agen in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TIPO_AGENCIA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el tipo de agencia de mantenimiento de cartera
    --                              Otras agencias / Lima metropolitana
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_agen: codigo de agencia del asesor o analista
    -- Parámetros de Salida       : lc_tipage: tipo de agencia E/N/O
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_tipage number(2);
    ln_conage number(3);

  begin
 
      begin

        -- otras agencias
        select count(*)
          into ln_conage
          from fst001 f
         where SCCIUD <> 1501
           and SUCURS = P_IN_agen;

        If ln_conage > 0
        then
          lc_tipage := 1;
        End If;

        -- lima metropolitana

        select count(*)
          into ln_conage
          from fst001 f
         where SCCIUD = 1501
           and SUCURS = P_IN_agen;

        If ln_conage > 0
        then
          lc_tipage := 2;
        End If;

      exception
        when no_data_found then
          lc_tipage := 'N';
      End;

   
    
    return lc_tipage;

  end fn_cr_tipo_agencia;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_tipo
  (
    pc_clasana IN char,
    pc_TipAge IN char,
    pc_Saldo  IN number
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_TIPO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : consulta el tipo de meta analista de acuerdo al
    --                              tipo C = consumo y P = pymes y al tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Asesor: Codigo de asesor,
    --                              P_IN_Fecha: Fecha de proceso
    -- Parámetros de Salida       : lc_tipoase: tipo de meta = I,II,III,IV,V,VI
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  lc_tipoase  jaql577.jaql577tipo%type; 
   begin
  begin
     
       Select jaql577tipo
       into lc_tipoase
       from jaql577
       where pc_Saldo >= jaql577smin
         and pc_Saldo <= jaql577smax
         and jaql577emp  = pc_clasana
         and jaql577tage = pc_TipAge;

exception
  when others then lc_tipoase:=null;
   
end;
 return lc_tipoase;
  end fn_cr_asesor_tipo;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior
  (
    pc_analista IN char,
    pd_fecpro   IN date,
    pc_codage   in number
  ) return number is
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
    ld_fecfin date;

    ln_codage number; --2016.02.08
  begin

    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;

  
    Begin
      -- Saldo del Mes Anterior

/*      select trunc(jaql572scre, 2)
        into ln_Salant
        from jaql572
       where jaql572usu = pc_analista
         and jaql572fpro = ld_fecfin;*/

       select trunc(jaql583sdo, 2)
              into ln_Salant
              from jaql583
             where jaql583usu = pc_analista
               and jaql583fpro = ld_fecfin
               and jaql583age = pc_codage; --2016.02.08 se agrego consulta por codigo de analista

    exception
      when others then
        ln_Salant := 0;
    end;

    return ln_salant;

  end fn_cr_saldo_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior
  (
    pc_analista IN char,
    pd_fecpro   IN date,
    pc_codage   in number
  ) return number is
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
    ln_nrocli number(10);
    ld_fecfin date;

  Begin

    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;
      

       
    Begin
     /* select jaql572ncli
        into ln_nrocli
        from jaql572
       where jaql572usu = pc_analista
         and jaql572fpro = ld_fecfin;*/

   select jaql583ncl
          into ln_nrocli
          from jaql583
         where jaql583usu = pc_analista
           and jaql583fpro = ld_fecfin
            and jaql583age = pc_codage; --2016.02.08 se agrego consulta por codigo de analista
    exception
      when no_data_found then
        ln_nrocli := 0;
    end;

    return ln_nrocli;

  end fn_cr_nrocli_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mes_base
  (
    pc_analista char,
    pd_fecpro date,
    pn_codage number
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_MES_BASE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_salfinal: Saldo de mes base
    -- Fecha de Modificación      : 2015.02.04
    -- Autor de la Modificación   : RLIVISI
    -- Descripción de Modificación: SE modifico fecha para mes base 2015.01.31
    -- *****************************************************************
    --ln_codase number := PQ_CR_PRODUCTIVIDAD_ANA.fn_cr_codase(pc_analista);
    ln_salfinal number(18, 2);
    ld_fecfin date;
    ld_fecini date;
    ld_fecotor date;

    ln_saldo number:=0;
    ln_saloto number:=0;
    ln_salrec number:=0;

    ln_salant number:=0; --saldo de mes anterior
    ln_salmax number(18, 2); --saldo maximo

    
  Begin
  
   
    --ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
    ld_fecfin := last_day(add_months(pd_fecpro,-1));
    
    if pd_fecpro >= to_Date('2014.07.31','yyyy.mm.dd') then
    
      ld_fecini := to_Date('2014.06.30','yyyy.mm.dd');
      --obtener saldo cierre mes anterior
      ln_salant := nvl(pq_cr_productividad_ana.fn_cr_saldo_anterior(pc_analista, pd_fecpro, pn_codage ),0);
      --obtener saldo maximo anterior a fecha de proceso
      Begin
        select max(jaql583smax)
          into ln_salmax
          from jaql583 g
         where jaql583usu = pc_analista
           --and jaql583fpro between ld_fecini and ld_fecfin
           and jaql583fpro = ld_fecfin
           and jaql583fpro = last_day(jaql583fpro)
           and jaql583age = pn_codage; --2016.02.08 se agrego consulta por codigo de analista
      exception
        when no_data_found then
          ln_salmax := 0;
      end;
      
      ln_salmax := NVL(LN_SALMAX,0);
      
      ---Se obtiene maximo entre Saldo de Cierre mes anterior y Saldo Maximo   ---Modif.03.02.2015   
      if pd_fecpro = to_Date('2016.01.31','yyyy.mm.dd') or  pd_fecpro = to_Date('2014.07.31','yyyy.mm.dd') then
         ln_salmax := ln_salant;
      else           
        if ln_salant > ln_salmax then
            ln_salmax := ln_salant;
        end if;
      end if;        
      --se resta saldo otorgado y suma saldo recibido del mes
      begin
        select JAQL583SOTO, JAQL583SREC
          into ln_saloto, ln_salrec    
          from jaql583
         where /*trim(jaql583usu) = pc_analista --quitar comentario*/ jaql583usu = pc_analista
           and jaql583fpro = pd_fecpro;
      exception
        when no_data_found then
          ln_saloto := 0; 
          ln_salrec := 0;           
      end;       
      
      --Nuevo SALDO MAXIMO
      ln_salfinal :=  ln_salmax - ln_saloto + ln_salrec ;

    else

        /*ld_fecini := pq_cr_productividad_ana.fn_cr_ult_traslado(pc_analista => pc_analista,
                                                                 pd_fecpro   => pd_fecpro);
       */
 
         --no existen traslados
          if pd_fecpro < to_Date('2014.07.31','yyyy.mm.dd') then
            ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
            
            --obtener saldo cierre mes anterior
            ln_salant := nvl(pq_cr_productividad_ana.fn_cr_saldo_anterior(pc_analista, pd_fecpro,pn_codage),0);
            --obtener saldo maximo anterior a fecha de proceso
            Begin
              select max(jaql583smax)
                into ln_salmax
                from jaql583 g
               where jaql583usu = pc_analista
                 --and jaql583fpro between ld_fecini and ld_fecfin
                 and jaql583fpro = ld_fecfin
                 and jaql583fpro = last_day(jaql583fpro)
                 and jaql583age = pn_codage; --2016.02.08 se agrego consulta por codigo de analista

            exception
              when no_data_found then
                ln_salmax := 0;
            end;
            
            ln_salmax := NVL(LN_SALMAX,0);
            
            ---Se obtiene maximo entre Saldo de Cierre mes anterior y Saldo Maximo ---Modif. 03.02.2015  
            if pd_fecpro = to_Date('2016.01.31','yyyy.mm.dd') or  pd_fecpro = to_Date('2014.07.31','yyyy.mm.dd') then
               ln_salmax := ln_salant;
            else    
              if ln_salant > ln_salmax then
                  ln_salmax := ln_salant;
              end if;
            end if;
            --se resta saldo otorgado y suma saldo recibido del mes
            begin
              select JAQL583SOTO, JAQL583SREC
                into ln_saloto, ln_salrec    
                from jaql583
               where /*trim(jaql583usu) = pc_analista --quitar comentario*/ jaql583usu = pc_analista
                 and jaql583fpro = pd_fecpro;
             exception
            when no_data_found then
              ln_saloto := 0; 
              ln_salrec := 0;          
            end;       
            
            --Nuevo SALDO MAXIMO
            ln_salfinal :=  ln_salmax - ln_saloto + ln_salrec ;
       
         end if;
      
   end if;   

    If (ln_salfinal is null or ln_salfinal <0 ) then  --08Jul2015
      ln_salfinal := 0;
    End If;

    return ln_salfinal;

  end fn_cr_saldo_mes_base;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_mes_base
  (
    pc_analista char,
    pd_fecpro   date,
    pn_codage number
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := PQ_CR_PRODUCTIVIDAD_ANA.fn_cr_codase(pc_analista);
    ln_clifinal number(18, 2);
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;
   
    ln_climax number(18, 2); 
    ln_cliant number(18, 2);    
    ln_clientes number:=0;
    ln_clioto number:=0;
    ln_clirec number:=0;

    ln_codage number; --2016.02.08    

  Begin

  
  
   -- ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
    ld_fecfin := last_day(add_months(pd_fecpro,-1));

    if pd_fecpro >= to_Date('2014.07.31','yyyy.mm.dd') then
    
       ld_fecini := to_Date('2014.06.30','yyyy.mm.dd');
       --obtener numero de clientes mes anterior
       ln_cliant := pq_cr_productividad_ana.fn_cr_nrocli_anterior(pc_analista, pd_fecpro,pn_codage);
      
       --obtener clientes maximo anterior a fecha de proceso
      Begin
        select max(JAQL583CMAX)
          into ln_climax
          from jaql583 g
         where jaql583usu = pc_analista
           --and jaql583fpro between ld_fecini and ld_fecfin
           and jaql583fpro = ld_fecfin
           and jaql583fpro = last_day(jaql583fpro)
            and jaql583age = pn_codage; --2016.02.08 se agrego consulta por codigo de analista

      exception
        when no_data_found then
          ln_climax := 0;
      end;
      
      ln_climax := NVL(ln_climax,0);
      
      ---Se obtiene maximo entre Saldo de Cierre mes anterior y Saldo Maximo  ---Modif. 03.02.2015 
      if pd_fecpro = to_Date('2016.01.31','yyyy.mm.dd') or  pd_fecpro = to_Date('2014.07.31','yyyy.mm.dd') then
         ln_climax := ln_cliant;
      else    
        if ln_cliant > ln_climax then
            ln_climax := ln_cliant;
        end if;
        
      end if;        
      --se resta saldo otorgado y suma saldo recibido del mes
       begin
          select JAQL583cot, JAQL583crec
            into ln_clioto, ln_clirec    
            from jaql583
           where /*trim(jaql583usu) = pc_analista --quitar comentario */jaql583usu = pc_analista
             and jaql583fpro = pd_fecpro;
        exception
            when no_data_found then
              ln_clioto := 0; 
              ln_clirec := 0;       
       end;       
      
      
       
      --Nuevo SALDO MAXIMO
      ln_clifinal :=  ln_climax - ln_clioto + ln_clirec ;
    
    
    else

        /*ld_fecini := pq_cr_productividad_ana.fn_cr_ult_traslado(pc_analista => pc_analista,
                                                                 pd_fecpro   => pd_fecpro);
*/
                                                                 
       /* if ld_fecini is null then */
         --no existen traslados
          if pd_fecpro < to_Date('2014.07.31','yyyy.mm.dd') then
            --obtener numero de clientes mes anterior
            ln_cliant := pq_cr_productividad_ana.fn_cr_nrocli_anterior(pc_analista, pd_fecpro,pn_codage);
          
            ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
            
            Begin
              select max(JAQL583CMAX)
                into ln_climax
                from jaql583 g
               where jaql583usu = pc_analista
                 --and jaql583fpro between ld_fecini and ld_fecfin
                 and jaql583fpro = ld_fecfin
                 and jaql583fpro = last_day(jaql583fpro)
                  and jaql583age = pn_codage; --2016.02.08 se agrego consulta por codigo de analista

            exception
              when no_data_found then
                ln_climax := 0;
            end;
          
          ln_climax := NVL(ln_climax,0);
          
          ---Se obtiene maximo entre Saldo de Cierre mes anterior y Saldo Maximo ---Modif. 03.02.2015   
          if pd_fecpro = to_Date('2016.01.31','yyyy.mm.dd') or  pd_fecpro = to_Date('2014.07.31','yyyy.mm.dd') then
             ln_climax := ln_cliant;
          else   
            if ln_cliant > ln_climax then
                ln_climax := ln_cliant;
            end if;
          end if;         
          --obtener saldo otorgado y recibido de ultimo traslado
           begin
              select JAQL583cot, JAQL583crec
                into ln_clioto, ln_clirec    
                from jaql583
               where /*trim(jaql583usu) = pc_analista --quitar comentario*/ jaql583usu = pc_analista
                 and jaql583fpro = pd_fecpro;
            exception
            when no_data_found then
              ln_clioto := 0; 
              ln_clirec := 0;        
           end;    
        
         
            ln_clifinal := ln_climax - ln_clioto + ln_clirec ;
            
        end if;    
        
   end if;

    If (ln_clifinal is null or ln_clifinal <0 )  then ---08Jul2015
      ln_clifinal := 0;
    End If;

    return ln_clifinal;


  end fn_cr_cliente_mes_base;

   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_cli_mes_base
  (
    pc_analista char,
    pd_fecpro   date
  ) return date is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := PQ_CR_PRODUCTIVIDAD_ANA.fn_cr_codase(pc_analista);
    ld_clifec date;
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;
    pd_fecpro1 date;

  Begin

    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
    Else
      if to_char(pd_fecpro,'ddmm')= '2902' then  
           pd_fecpro1 := pd_fecpro -1;
           ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro1 + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
           ld_fecfin := last_day(add_months(pd_fecpro,-1));
       else
           ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
           ld_fecfin := last_day(add_months(pd_fecpro,-1)); 
       end if;
    End if;

/*    Begin
      select max(jaql583fpro)
        into ld_clifec
        from jaql583 g
       where jaql583usu = pc_analista
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583sant = (select max(jaql583sant) from jaql583 where jaql583usu = pc_analista
         and jaql583fpro between ld_fecini and ld_fecfin);


    exception
      when no_data_found then
        ld_clifec := to_date('2012.01.01','yyyy.mm.dd');
    end;

    If ld_clifec is null
    then
      ld_clifec := to_date('2012.01.01','yyyy.mm.dd');
    End If;

    return ld_clifec;*/
    return null;

  end fn_cr_fecha_cli_mes_base;


   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_sal_mes_base
  (
    pc_analista char,
    pd_fecpro   date
  ) return date is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    ln_codase number := PQ_CR_PRODUCTIVIDAD_ANA.fn_cr_codase(pc_analista);
    ln_fecsal date;
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;
    pd_fecpro2 date;

  Begin

    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
       Else
            if to_char(pd_fecpro,'ddmm')= '2902' then  
               pd_fecpro2 := pd_fecpro -1;
               ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro2 + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
               ld_fecfin := last_day(add_months(pd_fecpro,-1));
            else
      
             ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
             ld_fecfin := last_day(add_months(pd_fecpro,-1));
             end if;
    End if;

   /* Begin
      select max(jaql583fpro)
        into ln_fecsal
        from jaql583 g
       where jaql583usu = pc_analista
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583fpro = last_day(jaql583fpro)
         and jaql583sant = (select max(jaql583sant) from jaql583 where jaql583usu = pc_analista
         and jaql583fpro between ld_fecini and ld_fecfin);

    exception
      when no_data_found then
        ln_fecsal := to_date('2012.01.01','yyyy.mm.dd');
    end;

    If ln_fecsal is null
    then
      ln_fecsal := to_date('2012.01.01','yyyy.mm.dd');
    End If;

    return ln_fecsal;*/
    
    return null;

  end fn_cr_fecha_sal_mes_base;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codase(P_IN_usuario char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CODASE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el codigo de asesor del analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de usuario
    -- Parámetros de Salida       : ln_codase: codigo de asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number(10);

  begin

    -- Verifica si el asesor tiene codigo
    begin
      select sngas2cod
        into ln_codase
        from /*sngas2_201405 s*/sngas2 s
       where s.sngas2pgc = 1 
         and sngas2usr = P_IN_usuario;

    exception
      when others then
        ln_codase := 0;

    End;

    If ln_codase is null
    then
      ln_codase := 0;
    End If;

    return ln_codase;

  end fn_cr_codase;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cred_metas
  (
    pc_Tipase IN char,--P/C
    pc_Tipage IN char,--ENO
    pc_Tipmet IN char,--I-II-III-IV-V-VI
    pn_codsuc in number
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CRED_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de creditos que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      : 11Jul2014
    -- Autor de la Modificación   :DCASTRO-RLIVISI
    -- Descripción de Modificación: Obtención de Código de Grupo de Región.
    -- *****************************************************************

  ln_mtasdo jaql583.jaql583mtsa%type;
  --ln_codReg number;
  --lc_descReg varchar2(2);
  lc_codase char;
  ln_JAQL579CCLAGE number;
  ln_JAQL579CUBC number;
  
  
  ln_metasal number;
  ln_metacli number;
  ln_metamor number;
  
  begin
  
   --ln_codReg := pq_cr_productividad_ana.fn_cr_region(pn_codsuc => pn_codsuc);
   --lc_descReg := pq_cr_productividad_ana.fn_cr_guiametas(pn_codreg => ln_codReg);
   
                                                 
    begin
/*      select jaql579sado
        into ln_mtasdo
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
         and jaql579greg = lc_descReg
         and jaql579est = 'S';*/ --06.03.2015
         
       select jaql579sado
        into ln_mtasdo
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
        
         and jaql579est = 'S';  
           
         
    exception
          when others then
            ln_mtasdo := 0;
    End;
    return ln_mtasdo;

  end fn_cr_cred_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_clie_metas
  (
    pc_Tipase IN char,
    pc_Tipage IN char,
    pc_Tipmet IN char,
    pn_codsuc in number
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIE_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de clientes que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             pc_Tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             pc_Tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtacli: meta del cliente
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_mtacli jaql583.jaql583mtcl%type;
    --ln_codReg number;
    --lc_descReg varchar2(2);
       

  Begin
   --ln_codReg := pq_cr_productividad_ana.fn_cr_region(pn_codsuc => pn_codsuc);
   --lc_descReg := pq_cr_productividad_ana.fn_cr_guiametas(pn_codreg => ln_codReg);  
  
    begin
/*      select jaql579clie
        into ln_mtacli
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
         and jaql579greg = lc_descReg
         and jaql579est = 'S';*/
         
        select jaql579clie
        into ln_mtacli
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
         
         and jaql579est = 'S';       
         
     exception
          when others then
            ln_mtacli := 0;
    End;
    return ln_mtacli;

  End fn_cr_clie_metas; 
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_mora_metas
  (
    pc_Tipase IN char,
    pc_Tipage IN char,
    pc_Tipmet IN char,
    pn_codsuc in number
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_MORA_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de mora que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtamra: meta de la mora
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_mtamra jaql583.jaql583mtmr%type;
    --ln_codReg number;
    --lc_descReg varchar2(2);

  Begin
   --ln_codReg := pq_cr_productividad_ana.fn_cr_region(pn_codsuc => pn_codsuc);
   --lc_descReg := pq_cr_productividad_ana.fn_cr_guiametas(pn_codreg => ln_codReg);  
  
    begin
   /*   select jaql579mra
        into ln_mtamra
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
         and jaql579greg = lc_descReg
         and jaql579est = 'S';*/
         
         
        select jaql579mra
        into ln_mtamra
        from jaql579
       where jaql579tage = pc_Tipage
         and jaql579tase = pc_Tipase
         and jaql579tip = pc_Tipmet
        
         and jaql579est = 'S';
     exception
          when others then
            ln_mtamra := 0;
    End;
    return ln_mtamra;

  End fn_cr_mora_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_cali(pn_codage in number,
                              pn_cliente IN Number
                              ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_CALI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta la calificacion del asesor en cuanto a clientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: Numero de clientes del asesor
    -- Parámetros de Salida       : lc_calcli: calificacion de cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcli char(2);

  begin
    begin
      select trim(t.jaql570tipo)
        into lc_calcli
        from jaql570 t
       where jaql570AGe = pn_codage
         and pn_cliente >= t.jaql570clmi
         and pn_cliente <= t.jaql570clma
         and jaql570est = 'S';

    exception
      when no_data_found then
        lc_calcli := ' ';
    end;

    return lc_calcli;

  end fn_cr_cliente_cali;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_credito_cali(pn_codage in number,
                              pn_saldo IN Number
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CREDITO_CALI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : califica el saldo que tiene el asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_monto: saldo actual del asesor
    -- Parámetros de Salida       : lc_calcre: calificacion del credito de
    --                              acuerdo al monto del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcre char(2);

  begin

    begin
      Select trim(f.jaql571tipo)
        into lc_calcre
        from jaql571 f
       where jaql571AGe = pn_codage
         and pn_saldo >= f.jaql571sdmi
         and pn_saldo <= f.jaql571sdma
         and jaql571est = 'S';

    exception
      when no_data_found then
        lc_calcre := ' ';
    end;

    return lc_calcre;

  end fn_cr_credito_cali;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contmes_anterior(Pc_analista IN varchar2, pd_fecpro in  date, pc_codsuc in varchar2) return number is
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
 /*   ln_mesant number(10);
    ld_fecha  date;

  begin

    select g.pgfape into ld_fecha from fst017 g where g.pgcod = 1;

    Begin
      select round((ld_fecha - max(prfufecalt)) / 30)
        into ln_mesant
        from prfu00
       where trim(ubuser) = trim(Pc_analista)
        and (prfgcod = 'ACRE01' or prfgcod = 'ANAPER');

    exception
      when no_data_found then
        ln_mesant := 0;
    end;

    if ln_mesant is null
    then
      ln_mesant := 0;
    end if;

    return nvl(ln_mesant,0);*/

  cursor usuarios(pc_analista char, pc_codsuc char) is 
    select jaql966fec, jaql966cod, jaql966nom, jaql966car, jaql966tip, 
           jaql966suc, jaql966sts, jaql966usr
    from jaql966 where jaql966usr = pc_analista and jaql966suc = pc_codsuc
    AND jaql966fec <= pd_fecpro --SE AGREGO PARA CONSIDERAR MENORES O IGUALES A FECHA DE PROCESO
    order by jaql966fec desc;
    
  ln_cont number := 0;
  ld_fecha date;
  lc_indjud char(1);

  begin
     
     --pd_fecpro := to_date('2014.01.31','yyyy.mm.dd');
     ld_fecha := add_months(pd_fecpro,-6);
   
      for i in usuarios(pc_analista, pc_codsuc) loop
      
         if i.jaql966fec >= ld_fecha then
          ln_cont := ln_cont + 1;
         else
             exit;
         end if; 
      end loop;
   

     /*if  ln_cont = 6 then
         lc_indjud := 'S';
     else
         lc_indjud := 'N';
     end if;
     ln_cont := 0;*/
        
     return ln_cont;
     
  end fn_cr_contmes_anterior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contdias_anterior(Pc_analista IN varchar2) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CONTDIAS_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el numero de dias de antiguedad del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_USER: Codigo de asesor
    -- Parámetros de Salida       : ln_diasant: dias de antiguedad del asesor.
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_diasant number(10);
    ld_fecha   date;

  begin
    select g.pgfape into ld_fecha from fst017 g where g.pgcod = 1;
    Begin
      select round((ld_fecha - max(prfufecalt)))
        into ln_diasant
        from prfu00
       where trim(ubuser) = trim(Pc_analista)
        -- and (prfgcod = 'ANA01' or prfgcod = 'ANASEN');
        and (prfgcod = 'ACRE01' or prfgcod = 'ANAPER');

    exception
      when no_data_found then
        ln_diasant := 0;
    End;

    If ln_diasant is null
    then
      ln_diasant := 0;
    End If;

    return nvl(ln_diasant,0);

  end fn_cr_contdias_anterior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bono_mantenimiento(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_bono_mantenimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono por saldo y cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    cursor mantenimiento(ld_fecpro date, lc_analista char) is
       select jaql572usu, jaql572fpro, jaql572csal, jaql572ccli , jaql572scre, jaql572ncli,
              jaql572cmcl, jaql572cme, jaql572tage,
              (jaql572scre -jaql572soto + jaql572srec) saldo,
              (jaql572ncli -jaql572coto + jaql572crec) clientes
        from jaql572 where jaql572fpro = ld_fecpro--;
        -- and jaql572est = 'R' ----------------------------->>>>>ojo solo para el recalculo
       and jaql572usu like '%'||lc_analista||'%';
         -- and jaql572usu like lc_analista;


  ln_bonosaldo number:= 0;
  ln_bonocli number:= 0;
  ln_salmax number:=0;
  ln_climax number:= 0;

lc_analista varchar2(10):= null;

begin

 if pc_analista is null then
    lc_analista := '%';
 else
    lc_analista := pc_analista;    
 end if;


 for i in mantenimiento(pd_fecpro, lc_analista) loop
 
 
   BEGIN
     select 
         jaql583smax,jaql583cmax
         into ln_salmax, ln_climax               
         from jaql583
        where jaql583fpro = pd_fecpro
          and jaql583usu = i.jaql572usu ;
   END;    
 
    --bono saldo  Crecimiento mensual saldo > 0
     if (i.jaql572scre/*i.saldo*/ - ln_salmax ) >= 0 
     and ln_salmax >0 then ---se modifico solicitud Karlos Malaga  
     --SALDO MAXIMO>0 2014.08.07
       begin
          select jaql571bono
            into ln_bonosaldo 
            from jaql571
           where jaql571tipo = i.jaql572csal--clasificacion saldo
             and jaql571age = i.jaql572tage--tipo agencia
             and i.jaql572scre >= jaql571sdmi
             and i.jaql572scre <= jaql571sdma
             and jaql571est = 'S';
       exception when others then 
           ln_bonosaldo := 0;
       end;
     end if; 
     
     
     --bono clientes Crecimiento mensual clientes> 0
     if  (i.jaql572ncli/*i.clientes*/ - ln_climax ) >= 0 
     and ln_climax > 0 then ---se modifico solicitud Karlos Malaga
     --CLIENTE MAXIMO>0 2014.08.07
       begin
          select jaql570bono
            into ln_bonocli 
            from jaql570
           where jaql570tipo = i.jaql572ccli--clasificacion cliente
             and jaql570age = i.jaql572tage--tipo agencia
             and i.jaql572ncli >= jaql570clmi
             and i.jaql572ncli <= jaql570clma
             and jaql570est = 'S';
             
       exception when others then 
           ln_bonocli := 0;
       end;
       
     
     end if; 
 
   
     --actualizar bonos
     update jaql572
        set jaql572bsal = ln_bonosaldo,
            jaql572bcli = ln_bonocli
      where jaql572usu  = i.jaql572usu                  
        and jaql572fpro = pd_fecpro;
            
            
     commit;
     ln_bonosaldo := 0;
     ln_bonocli := 0;
     
 end loop;
 
end sp_cr_bono_mantenimiento;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bono_saldo(pc_tipasesor IN char) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bono_saldo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonosaldo number;

  begin
        begin   
            select jaql580sdo
              into ln_bonosaldo 
              from jaql580
             where jaql580tase = pc_tipasesor
               and jaql580est = 'S';
        exception when no_data_found then 
            ln_bonosaldo := 0;
        end;
  
    return ln_bonosaldo;

 end fn_cr_bono_saldo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bono_cliente(pc_tipasesor IN char) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bono_cliente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonocliente number;

  begin
        begin   
            select jaql580cli
              into ln_bonocliente 
              from jaql580
             where jaql580tase = pc_tipasesor
               and jaql580est = 'S';
       exception when no_data_found then 
            ln_bonocliente := 0;
       end;
  
    return ln_bonocliente;

  end fn_cr_bono_cliente;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bono_mora(pc_tipasesor IN char) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bono_mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonomora number;

  begin
        begin    
            select jaql580mra
              into ln_bonomora
              from jaql580
             where jaql580tase = pc_tipasesor
               and jaql580est = 'S';
       exception when no_data_found then 
            ln_bonomora := 0;
       end;
  
    return ln_bonomora;

  end fn_cr_bono_mora;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_analista
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pn_Numcli IN number
  ) return Char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_tipo_analista
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    lc_jaql585c5030 jaql585.jaql585c5030%type;

  begin
     begin
        select jaql585c5030
          into lc_jaql585c5030
          from jaql585
         where jaql585tage = pc_tiagel
           and jaql585age = pc_Tipage
           and pn_Numcli >= jaql585min 
           and pn_Numcli <= jaql585max
           and jaql585est = 'S'  ;
     exception when no_data_found then 
          lc_jaql585c5030 := null;                  
     end;
    return lc_jaql585c5030;

  end fn_cr_tipo_analista;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_meta_anual50
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pn_Numcli IN number
  ) return Char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_meta_anual50
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    lc_jaql585c5030 jaql585.jaql585c5030%type;

  begin
     begin
        select jaql585c5030
          into lc_jaql585c5030
          from jaql585
         where jaql585tage = pc_tiagel
           and jaql585age = pc_Tipage
           and pn_Numcli >= jaql585min 
           and pn_Numcli <= jaql585max
           and jaql585est = 'S'  ;
     exception when no_data_found then 
          lc_jaql585c5030 := null;                  
     end;
    return lc_jaql585c5030;

  end fn_cr_meta_anual50;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_excede_meta_cli
  (
    pc_tiagel IN char,
    pc_Tipage IN char,
    pc_Tipcla IN char,    
    pn_numcli IN number, --clientes del mes
    pn_metanu IN number, --meta clientes base/clientes maximo
    pn_metmes IN number, --meta cliente mes   
    pn_climesa IN number, --numero de clientes de mes anterior
    pn_porcla OUT number,    
    pn_porclm OUT number,        
    pn_bonanu OUT number,    
    pn_bonmen OUT number,
    pn_totanu OUT number,    
    pn_totmes OUT number,
    pn_nummes OUT number,
    pn_numanu OUT number    
  ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_excede_meta_cli
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  lc_jaql585c5030 jaql585.jaql585c5030%type;
  ln_exc_clianual number := 0;
  ln_exc_climes number := 0;
  ln_PorCli number := 0;
  ln_bonanual number:= 0;
  ln_bonmes number := 0;  

  begin
  
  --anual
     ln_exc_clianual := (pn_numcli - pn_metanu)- pn_metmes ; --Crecimiento ANUAL CLIENTES

     if pn_metanu > 0 then --si meta anual es mayor a 0, si es igual a 0 no puede dividirse

       ln_PorCli := round(ln_exc_clianual * 100/pn_metmes/*pn_metanu*/, 1);  
     
       if ln_porcli >= 50 then
         begin
            select jaql585ma50
              into ln_bonanual
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age  = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonanual := 0;                  
         end;
         
      
       elsif ln_porcli >= 30 then

         begin
            select jaql585ma30
              into ln_bonanual
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age  = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonanual := 0;                  
         end;

       end if;
       
     end if;
     pn_porcla := ln_PorCli;   
     pn_bonanu := ln_bonanual; 
     pn_nummes := pn_numcli;--ln_exc_clianual; 
     
   --mensual
    ln_exc_climes := (pn_numcli - pn_climesa ) - pn_metmes; -- MENSUAL CLIENTES
    ln_PorCli := round(ln_exc_climes * 100/ pn_metmes,0);
  
    if ln_porcli >= 50 then
       begin
          select jaql585mm50
            into ln_bonmes
            from jaql585
           where jaql585tage = pc_tiagel --E/N/O
             and jaql585age = pc_Tipage  --1-2
             and jaql585c5030 = pc_tipcla -- U...Z
             and jaql585est = 'S'  ;
       exception when no_data_found then 
            ln_bonmes := 0;                  
       end;
    elsif ln_porcli >= 30 then
          begin
          select jaql585mm30
            into ln_bonmes
            from jaql585
           where jaql585tage = pc_tiagel --E/N/O
             and jaql585age = pc_Tipage  --1-2
             and jaql585c5030 = pc_tipcla -- U...Z
             and jaql585est = 'S'  ;
       exception when no_data_found then 
            ln_bonmes := 0;                  
       end;
       
    end if;       
    
    pn_porclm :=  ln_PorCli;  
    pn_bonmen :=  ln_bonmes; 
    pn_numanu :=  pn_numcli;--ln_exc_climes;

    --Solo se multiplica el bono por el excedente de clientes
    pn_totanu := pn_bonanu * /*pn_numcli*/ln_exc_clianual;--clientes excedentes;
    pn_totmes := pn_bonmen * /*pn_numcli*/ln_exc_climes;--clientes excedentes;

  end sp_cr_excede_meta_cli;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_pago_variable_cli
  (
    pc_tiagel IN char, --E/N/O
    pc_Tipage IN char, --1-2
    pc_Tipcla IN char, -- U...Z   
    pc_claana IN char,   --clasificacion P/C
    pn_numcli IN number, --clientes del mes
    pn_metanu IN number, --meta clientes base/clientes maximo
    pn_metmes IN number, --meta cliente mes   
    pn_climesa IN number, --numero de clientes de mes anterior
    pn_porcla OUT number,    
    pn_porclm OUT number,        
    pn_bonanu OUT number,    
    pn_bonmen OUT number,
    pn_totanu OUT number,    
    pn_totmes OUT number,
    pn_nummes OUT number,
    pn_numanu OUT number,
    pc_indexa OUT char,    
    pc_indexm OUT char    
  ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_excede_meta_cli
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  lc_jaql585c5030 jaql585.jaql585c5030%type;
  ln_exc_clianual number := 0;
  ln_exc_climes number := 0;
  ln_PorCli number := 0;
  ln_bonanual number:= 0;
  ln_bonmes number := 0;  
  ln_Monto number := 0;

  ln_porcentaje number := 0; --porcentaje

  ln_meta50 number:=0;
  ln_meta30 number:=0;


  begin
  

  ln_exc_clianual := (pn_numcli - pn_metanu)- pn_metmes ; --Crecimiento ANUAL CLIENTES
  ln_exc_climes := (pn_numcli - pn_climesa ) - pn_metmes; -- MENSUAL CLIENTES
  
  if pc_claana = 'P' then
  
    --ANUAL
 
      ln_meta50 := ceil(pn_metmes * 0.5);
      ln_meta30 := ceil(pn_metmes * 0.3);  
    
      /*ln_meta50 := ceil(pn_metanu * 0.5);
      ln_meta30 := ceil(pn_metanu * 0.3); */
    
       ln_exc_clianual := (pn_numcli - pn_metanu)- pn_metmes ; --Crecimiento ANUAL CLIENTES

       /*if ln_exc_clianual >0 
          and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
          then --ANUAL MODIFICADO
          */
       
           if pn_metanu > 0 then --si meta anual es mayor a 0, si es igual a 0 no puede dividirse

             --ln_PorCli := round(ln_exc_clianual * 100/pn_metmes/*pn_metanu*/, 1);  
           
             if ln_exc_clianual >= ln_meta50 then--if ln_porcli >= 50 then
     
               ln_bonanual := pq_cr_productividad_ana.fn_cr_bonoanu50_jaql585(pc_tiagel => pc_tiagel,
                                                             pc_tipage => pc_tipage,
                                                             pc_tipcla => pc_tipcla);
               
               pn_bonanu := ln_bonanual;
               pn_numanu := (ln_exc_clianual+ pn_metmes);    --pn_numcli;--                                             
               pn_totanu := pn_bonanu * /*pn_numanu*/(ln_exc_clianual+ pn_metmes);--clientes excedentes;
               
               
               pc_indexa := '50';
             --elsif ln_porcli >= 30 then
             elsif ln_exc_clianual >= ln_meta30 
                   and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
                   then

                ln_bonanual := pq_cr_productividad_ana.fn_cr_bonoanu30_jaql585(pc_tiagel => pc_tiagel,
                                                   pc_tipage => pc_tipage,
                                                   pc_tipcla => pc_tipcla);


               pn_bonanu := ln_bonanual;
               pn_numanu := (ln_exc_clianual+ pn_metmes);        --pn_numcli;--                             
               pn_totanu := pn_bonanu * /*pn_numanu*/(ln_exc_clianual+ pn_metmes);--clientes excedentes;
               pc_indexa := '30';
/*              --calcular bono por crecimiento anual  
             elsif  (pn_numcli - pn_metanu) > 0 and ln_exc_clianual > 0 then
               
                         ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclia_jaql581(pc_tiagel => pc_tiagel,
                                                              pc_claana => pc_claana);
                          
                        --plus crecimiento * plus /100
                        -- ln_plusclianu := (ln_cre_clienteanual - i.jaql583mtcl)* ln_porcentaje;
                        --ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
                        ln_bonanual := ( (pn_numcli- pn_metanu) - pn_metmes )* ln_Monto;
                        pn_numanu := ( (pn_numcli- pn_metanu) - pn_metmes );
                        pn_bonanu := ln_Monto;
                        pn_totanu := ln_bonanual;
                     pc_indexa := 'PL';   
             
             end if;*/
             
           ---end if;
       --pn_porcla := ln_meta50;   
       
      /*else
       --MENSUAL
        ln_meta50 := ceil(pn_metmes * 0.5);
        ln_meta30 := ceil(pn_metmes * 0.3); 
       
        ln_exc_climes := (pn_numcli - pn_climesa ) - pn_metmes; -- MENSUAL CLIENTES
        --ln_PorCli := round(ln_exc_climes * 100/ pn_metmes,0);
      */
       elsif ln_exc_climes >= ln_meta50 then--if ln_porcli >= 50 then

             ln_bonmes := pq_cr_productividad_ana.fn_cr_bonomes50_jaql585(pc_tiagel => pc_tiagel,
                                                             pc_tipage => pc_tipage,
                                                             pc_tipcla => pc_tipcla);




             pn_bonmen := ln_bonmes; 
             pn_nummes := (ln_exc_climes + pn_metmes);     --pn_numcli;--                                         
             pn_totmes := pn_bonmen * /*pn_nummes*/(ln_exc_climes + pn_metmes);--clientes excedentes;
             
             pc_indexm := '50';
        elsif ln_exc_climes >= ln_meta30 then--if ln_porcli >= 30 then

            ln_bonmes := pq_cr_productividad_ana.fn_cr_bonomes30_jaql585(pc_tiagel => pc_tiagel,
                                                           pc_tipage => pc_tipage,
                                                           pc_tipcla => pc_tipcla);
            pn_bonmen := ln_bonmes;
            pn_nummes := (ln_exc_climes + pn_metmes); -- pn_numcli;--                                                        
            pn_totmes := pn_bonmen * /*pn_nummes*/(ln_exc_climes + pn_metmes);--clientes excedentes;                                                         
           
        --calcular bono por crecimiento mensual
       /* elsif  ln_exc_clianual > 0  then--if (ln_cre_clienteanual -  i.jaql583mtcl) > 0 then 
        
              ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclim_jaql581(pc_tiagel => pc_tiagel,
                                                          pc_claana => pc_claana);

              --plus crecimiento * plus /100
              -- ln_plusclimes := (ln_cre_clientemes - ln_cre_clienteanual )* ln_porcentaje;
              -- ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
              ln_bonmes := ( (pn_numcli - pn_climesa ) - (pn_numcli - pn_metanu) )* ln_Monto;
              pn_nummes := ( (pn_numcli - pn_climesa ) - (pn_numcli - pn_metanu) );
              pn_bonmen := ln_bonmes;
              pn_totmes := pn_bonmen; */   
              pc_indexm := '30';    
        
                      --calcular bono por crecimiento anual  
       elsif  (pn_numcli - pn_metanu) > 0 and ln_exc_clianual > 0 
              and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
       then
               
                         ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclia_jaql581(pc_tiagel => pc_tiagel,
                                                              pc_claana => pc_claana);
                          
                        --plus crecimiento * plus /100
                        -- ln_plusclianu := (ln_cre_clienteanual - i.jaql583mtcl)* ln_porcentaje;
                        --ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
                        ln_bonanual := ( (pn_numcli- pn_metanu) - pn_metmes )* ln_Monto;
                        pn_numanu := ( (pn_numcli- pn_metanu) - pn_metmes );
                        pn_bonanu := ln_Monto;
                        pn_totanu := ln_bonanual;
                     pc_indexa := 'PL';   
             
                  
        elsif ln_exc_clianual <= 0  
                and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
        then
        
             ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclim_jaql581(pc_tiagel => pc_tiagel,
                                                          pc_claana => pc_claana);

              --plus crecimiento * plus /100
              -- ln_plusclimes := (ln_cre_clientemes - ln_cre_clienteanual )* ln_porcentaje;
              -- ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
              ln_bonmes := ( (pn_numcli - pn_climesa ) - pn_metmes )* ln_Monto;
              pn_nummes := ( (pn_numcli - pn_climesa ) - pn_metmes );
              pn_bonmen := ln_bonmes;
              pn_totmes := pn_bonmen;  
              pc_indexm := 'PL';
        end if;   
      --pn_porclm :=  ln_meta30;  
      --pn_nummes :=  pn_numcli;--ln_exc_climes;
      
      end if;

    --end if; --2014.08.07
      
  else  --CUANDO ES CONSUMO
       if  (pn_numcli - pn_metanu) > 0 and ln_exc_clianual > 0 
           and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
       then
           
                       
              ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclia_jaql581(pc_tiagel => pc_tiagel,
                                                    pc_claana => pc_claana);
                      
              --plus crecimiento * plus /100
              -- ln_plusclianu := (ln_cre_clienteanual - i.jaql583mtcl)* ln_porcentaje;
              --ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
              ln_bonanual := ( (pn_numcli- pn_metanu) - pn_metmes )* ln_Monto;
              pn_numanu :=   (pn_numcli- pn_metanu) - pn_metmes;
/*              pn_bonanu := ln_bonanual;
              pn_totanu := pn_bonanu;*/
              pn_bonanu := ln_Monto;
              pn_totanu := ln_bonanual;
              
              pc_indexm := 'PL';
         --end if;
         --pn_porcla := ln_PorCli;   
         --pn_bonanu := ln_bonanual; 
         
    /*    else
         if  ln_exc_clianual > 0  then--if (ln_cre_clienteanual -  i.jaql583mtcl) > 0 then 
      
                ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclim_jaql581(pc_tiagel => pc_tiagel,
                                                            pc_claana => pc_claana);

                --plus crecimiento * plus /100
                -- ln_plusclimes := (ln_cre_clientemes - ln_cre_clienteanual )* ln_porcentaje;
                -- ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
                ln_bonmes := ( (pn_numcli - pn_climesa ) - (pn_numcli - pn_metanu) )* ln_Monto;
                pn_nummes := ( (pn_numcli - pn_climesa ) - (pn_numcli - pn_metanu) );
                pn_bonmen := ln_Monto;
                pn_totmes := ln_bonmes;*/
          elsif ln_exc_clianual <= 0  
                    and pn_metanu > 0 --saldo maximo >0 -- 2014.08.07
          then
      
               ln_Monto := pq_cr_productividad_ana.fn_cr_bonoclim_jaql581(pc_tiagel => pc_tiagel,
                                                            pc_claana => pc_claana);

                --plus crecimiento * plus /100
                -- ln_plusclimes := (ln_cre_clientemes - ln_cre_clienteanual )* ln_porcentaje;
                -- ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
                ln_bonmes := ( (pn_numcli - pn_climesa ) - pn_metmes )* ln_Monto;
                pn_nummes := ( (pn_numcli - pn_climesa ) - pn_metmes );
                pn_bonmen := ln_bonmes;
                pn_totmes := pn_bonmen;  
            
                 pc_indexm := 'PL';
        end if; 
          
      --  end if; 
  end if;

  
  --pn_porcla := ln_meta50;
  --pn_porclm := ln_meta30;   
  if  pn_numanu < 0 then pn_numanu := 0; end if;
  if  pn_nummes < 0 then pn_nummes := 0; end if;
  if  pn_totmes < 0 then pn_totmes := 0; end if;
  if  pn_totanu < 0 then pn_totanu := 0; end if;
  if  pn_bonmen < 0 then pn_bonmen := 0; end if;
  if  pn_bonanu < 0 then pn_bonanu := 0; end if;
  if  pn_porclm < 0 then pn_porclm := 0; end if;
  if  pn_porcla < 0 then pn_porcla := 0; end if;
  
  pn_porcla := nvl(pn_porcla,0); 
  pn_porclm := nvl(pn_porclm,0); 
  pn_bonanu := nvl(pn_bonanu,0); 
  pn_bonmen := nvl(pn_bonmen,0); 
  pn_totanu := nvl(pn_totanu,0); 
  pn_totmes := nvl(pn_totmes,0); 
  pn_nummes := nvl(pn_nummes,0); 
  pn_numanu := nvl(pn_numanu,0); 

  end sp_cr_pago_variable_cli;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos_diario2015(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.11.27
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico llamada a calculo saldo maximo
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

   select --/*+all_rows */ 
        /*+index_ss(a) index_ss(car) index_ss(deca) index_ss(f)*/ 
          deca.sng055dsc cargo,/*car2.cargocod ,*/ jaql965ase,-- cod_analista, 
           agtesuc agencia,
           sum(a.jaql965sdmn) Saldo_cartera, 
           count(distinct a.jaql965ndoc) Nro_clientes--,
      from JAQL965 a,  
           SNG057 car, 
           sng055 deca,
           fst156 f
    where 
      deca.sng055emp = car.sng055emp
      and deca.sng055emp = 1
      and car.sng055car = deca.sng055car 
      and car.sng055car in (200,201) --analista creditos / analista senior
      and a.jaql965fech = ld_fecpro
      and a.jaql965ase = car.sng057usr
      and f.agteusr = a.jaql965ase    
      and a.jaql965mod not in (108, 33, 200) 
      and (case when a.jaql965mod = 106 and a.jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
      and agtesuc = lc_sucurs --QUITAR COMENTARIO
      --AND TRIM(a.jaql965ase) = 'WMEDINA'--'SLIZARRAGA'  08Jul2015
       and (a.jaql965cta, a.jaql965oper , a.jaql965ase) 
          not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j) --excluir a tabla de EXCEPCIONEs
    group by deca.sng055dsc,
           a.jaql965ase, 
           agtesuc;

 lc_Tipo_analista jaql577.jaql577tipo%type;
 ln_metasal number := 0;
 ln_metacli number := 0;
 ln_metamor number := 0;
 lc_tipage jaql570.jaql570age%type;
 ln_calcli jaql570.jaql570tipo%type;
 ln_calsal jaql570.jaql570tipo%type;
 ln_nummes number:=0;
 ln_numdia number:=0;
 lc_5030 char(4);
 lc_cmesal number := 0;
 lc_cmecli number := 0;      
 
 ln_Saldo_Otorgado number;
 ln_Saldo_Recibido number;
 ln_Cliente_Otorgado number;
 ln_Cliente_recibido number;
 ln_Por_Mora  number;
 ln_Clientes_Nuevos  number;
 ln_sal_cre_mes_anterior number;
 ln_Nro_cli_mes_anterior number;
 ln_Sal_maximo  number;
 ln_Cli_maximo  number;
 ln_Fec_CliMax  date;
 ln_Fec_SalMax   date;
 lc_Tipo_ana varchar2(4);
 lc_Tipo_agencia varchar2(4);
 ln_Rango_5000 number;
 ln_Rango_20000 number;
 ln_Rango_50000 number;
 ln_Rango_100000 number;
 ln_Rango_100001 number;
 ln_saltot  number;
 ln_clitot  number;
 ln_salmor number;
 ln_saljud number;
 ln_cont NUMBER;
 ln_salcas number;
 ln_salrec number; 
 ln_numrec number; 
 
 ln_nuevo_sal number ; -- para recalculo
 ln_nuevo_cli number ; -- para recalculo
 
 ln_saldo_vencido number; --saldo vencido
 ln_saldo_refinan number; --saldo refinanciado
  
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop

 
       ln_Saldo_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoNew(i.jaql965ase,pd_fecpro,i.agencia),0);
       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoNew(i.jaql965ase,pd_fecpro,i.agencia),0);

       ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgadoNew(i.jaql965ase,pd_fecpro,i.agencia),0); 
       ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibidoNew(i.jaql965ase,pd_fecpro,i.agencia),0);

       ln_saldo_vencido :=  pq_cr_productividad_ana.fn_pa_sal_vencido(i.jaql965ase,pd_fecpro);
       ln_saldo_refinan :=  pq_cr_productividad_ana.fn_pa_sal_refinan(i.jaql965ase,pd_fecpro);
  
      -- lc_tipoasv:= 
      
         begin
           select /*+parallel(j,2) */count(*)
             into ln_cont
             from jaql966 j
            where jaql966usr = i.jaql965ase and jaql966suc = i.agencia;
         exception when no_data_found then
              ln_cont := 0;
         end; 
         
         if ln_cont > 0 then
           ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(i.jaql965ase,pd_fecpro,i.agencia);
         else
            ln_nummes := 0;       
         end if;
          
         ln_saljud := pq_cr_productividad_ana.fn_cr_sal_judicial(i.jaql965ase,pd_fecpro);
         ln_salmor := pq_cr_productividad_ana.fn_pa_saldo_mora(i.jaql965ase,pd_fecpro); --saldo mora  > 15 dias
         ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(i.jaql965ase,pd_fecpro);

   
         if  ln_nummes <= 6 then
             lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista_cal(i.jaql965ase,pd_fecpro);
             ---2014.03.13 --SI ES MENOR A 6 MESES NO CONSIDERAR SALDO MORA DE RECUPERACION LEGAL
             ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_numrec := pq_cr_productividad_ana.fn_pa_num_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_salmor := ln_salmor - ln_salrec;
             ---
             ln_nuevo_sal := i.Saldo_cartera - ln_salrec;
             ln_nuevo_cli := i.Nro_clientes - ln_numrec;
             --
             
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido - ln_salrec; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido - ln_numrec;
             
         else     
             lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista(i.jaql965ase,pd_fecpro);
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido;
             ln_nuevo_sal := i.Saldo_cartera;
             ln_nuevo_cli := i.Nro_clientes;
             
         end if;
       
      
       --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora_ini (i.jaql965ase,pd_fecpro,i.agencia, ln_salmor);
       ln_Clientes_Nuevos := pq_cr_productividad_ana.fn_pa_cliente_new (i.jaql965ase,pd_fecpro); 
       ln_sal_cre_mes_anterior := pq_cr_productividad_ana.fn_cr_saldo_anterior(i.jaql965ase, pd_fecpro, i.agencia); 
       ln_Nro_cli_mes_anterior := pq_cr_productividad_ana.fn_cr_nrocli_anterior(i.jaql965ase, pd_fecpro, i.agencia);   
       --ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro);    2014.11.27
       --ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro);  
       ln_Fec_CliMax := pq_cr_productividad_ana.fn_cr_fecha_cli_mes_base(i.jaql965ase, pd_fecpro);
       ln_Fec_SalMax  := pq_cr_productividad_ana.fn_cr_fecha_sal_mes_base(i.jaql965ase, pd_fecpro);                                                  
       lc_Tipo_agencia := pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(i.agencia/*i.jaql965suc*/,pd_fecpro); 
       
      --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora (i.jaql965ase,pd_fecpro,i.agencia, ln_salmor, ln_nuevo_sal /*i.Saldo_cartera*/, ln_saljud);
       
          ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql965ase,pd_fecpro,i.agencia,ln_salmor,ln_saljud, ln_nuevo_sal);
                                                        
         lc_Tipo_analista := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,lc_Tipo_agencia,ln_nuevo_sal/*i.Saldo_cartera*/);
        
       
        /* ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista,i.agencia);
         ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista,i.agencia);
         ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista,i.agencia);
        */ --Comentado 12.03.2015

         BEGIN ---insertado 12.03.2015
          pq_cr_productividad_ana.sp_cr_retorna_metas(pc_jaql579tip => lc_Tipo_analista ,
                                              pc_jaql579tase => lc_Tipo_ana,
                                              pc_tipage => lc_Tipo_agencia,
                                              pn_agencia => i.agencia,
                                              pc_codusu => i.jaql965ase,
                                              pn_metasal => ln_metasal ,
                                              pn_metacli => ln_metacli ,
                                              pn_metamor => ln_metamor );
         EXCEPTION WHEN OTHERS THEN
               ln_metasal := NULL;                                         
               ln_metacli := NULL;
               ln_metamor := NULL;               
               
         END; ---- insertado 12.03.2015

          
        
         lc_tipage := pq_cr_productividad_ana.fn_cr_tipo_agencia(i.agencia/*i.jaql965suc*/);
         ln_calcli := pq_cr_productividad_ana.fn_cr_cliente_cali(lc_tipage, ln_nuevo_cli /*i.Nro_clientes */);
         ln_calsal := pq_cr_productividad_ana.fn_cr_credito_cali(lc_tipage, ln_nuevo_sal /*i.Saldo_cartera*/);
         
         lc_5030 := pq_cr_productividad_ana.fn_cr_tipo_analista(lc_Tipo_agencia,lc_tipage, ln_nuevo_cli /*i.Nro_clientes*/);
         
      
         
       insert into jaql583 (jaql583fpro,jaql583usu, jaql583age, jaql583tusu, jaql583sdo, jaql583ncl, jaql583pmra,
              jaql583soto, jaql583srec, jaql583cot, jaql583crec, jaql583ncn, 
              jaql583sant, jaql583cant, jaql583smax, jaql583cmax, jaql583tage, jaql583fsmax, jaql583fcmax, 
              jaql583mtsa, jaql583mtcl, jaql583mtmr,
              jaql583est, jaql583mant, jaql583dant, jaql583pcod, jaql583tase, jaql583c5030, jaql583lage,
              jaql583sdju, jaql583sdtot, jaql583cltot, jaql583sdm, jaql583sdca, jaql583sdve, jaql583sdre
               )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, i.agencia/*i.jaql965suc*/, lc_Tipo_analista, 
                ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, 
                ln_Por_Mora,
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, ln_Clientes_Nuevos,
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, ln_Sal_maximo, ln_Cli_maximo, lc_Tipo_agencia,
                ln_Fec_SalMax, ln_Fec_CliMax,
                ln_metasal, ln_metacli, ln_metamor,'S',
                ln_nummes,  ln_numdia, 1, lc_Tipo_ana, lc_5030, lc_tipage,
                ln_saljud, ln_saltot, ln_clitot, ln_salmor, ln_Salcas , ln_saldo_vencido, ln_saldo_refinan
              );
       
       commit; 
       
      
      --2014.11.27 
      
       ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro, i.agencia);    
       ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro, i.agencia);         
        
      /* if ln_Sal_maximo <= 0 then--2015.05.11 si meses de antiguedad = 1 en la agencia, saldo maximo = meta saldo, clientes maximo = meta clientes
          if ln_nummes = 1  then 
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
          end if;              
        end if;  --2015.05.11
      */
        --2016.02.08 --si tuvo otra agencia no considerar traslados
       if ln_nummes = 1  then 
         --si pertenecia a otra agencia y tuvo traslados
         if ln_Sal_maximo <= 0  then
           ln_Sal_maximo := ln_metasal;    
           ln_Cli_maximo := ln_metacli; 
         end if;  
         /*if ln_sal_cre_mes_anterior = 0 then
           ln_sal_cre_mes_anterior := ln_metasal;    
           ln_Nro_cli_mes_anterior := ln_metacli;  
         end if;*/
             
        end if;              
        --2016.02.08
      
      
       update jaql583
                set jaql583smax=ln_Sal_maximo,
                    jaql583cmax=ln_Cli_maximo
              where jaql583usu = i.jaql965ase
                and jaql583fpro = pd_fecpro;
       commit;    
       --2014.11.27
                   
        --inserta JAQL572
         
         /*dbms_output.put_line('lc_Tipo_analista '||lc_Tipo_analista);
         dbms_output.put_line('ln_metasal '||ln_metasal);
         dbms_output.put_line('ln_metacli '||ln_metacli);
         dbms_output.put_line('ln_metamor '||ln_metamor);*/
         
       
       lc_cmesal := ln_saltot - ln_sal_cre_mes_anterior; -- crecimiento mensual saldo
       lc_cmecli := ln_clitot - ln_Nro_cli_mes_anterior; --crecimiento mensual clientes 
       
       insert into jaql572 (jaql572fpro, jaql572usu, JAQL572scre, jaql572ncli, jaql572cod, jaql572agen, jaql572ccli, 
                            jaql572csal, jaql572sant, jaql572ncl, jaql572tage, jaql572soto, jaql572srec,
                            jaql572coto, jaql572crec, jaql572est, jaql572mant, jaql572dant,
                            jaql572cme,  jaql572cmcl )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, 1, 
                i.agencia/*i.jaql965suc*/,  trim(ln_calcli), trim(ln_calsal),--clasif cliente, clasif saldo
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, lc_tipage,--tipo agencia
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, 'S',
                ln_nummes,  ln_numdia, lc_cmesal, lc_cmecli
              );
       
       commit; 
   
   end loop;  
   commit; 
 
 end sp_cr_carga_datos_diario2015;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos2015(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

 select --/*+all_rows */ 
        /*+index_ss(a) index_ss(car) index_ss(deca) index_ss(f)*/ 
          deca.sng055dsc cargo,/*car2.cargocod ,*/ jaql965ase,-- cod_analista, 
         --  a.jaql965ase,
          /* agtenom analista,*/ 
           agtesuc agencia,
           --a.jaql965suc,/*scnom nombre_agencia,*/
           --pq_cr_productividad_ana.fn_pa_tip_analista(jaql965ase) Tipo_analista ,
           sum(a.jaql965sdmn) Saldo_cartera, 
           count(distinct a.jaql965ndoc) Nro_clientes--,
       from JAQL965 a,  
           /*SNG057_201405*/ sng057_201X car, 
           /*sng055_201405*/ sng055_201X deca,
           /*fst156_201405*/ fst156_201X f /*,
           fst001 f1 */
    where 
      deca.sng055emp = car.sng055emp
      and deca.sng055emp = 1
      and car.sng055car = deca.sng055car 
      and car.sng055car in (200,201) --analista creditos / analista senior
      and a.jaql965fech = ld_fecpro
      and a.jaql965ase = car.sng057usr
      and f.agteusr = a.jaql965ase    
      --and a.jaql965mod not in (108, 33, 200) and (a.jaql965mod <> 106 Or a.jaql965top <> 30)  --no incluye judiciales
      and a.jaql965mod not in (108, 33, 200) 
      and (case when a.jaql965mod = 106 and a.jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
      and agtesuc = lc_sucurs --QUITAR COMENTARIO
     -- AND TRIM(a.jaql965ase) = 'HCHUQUIHUI'--in ('JGALVEZ' , 'CPALOMINOD')  --COMENTAR --08Jul2015
       and (a.jaql965cta, a.jaql965oper , a.jaql965ase) 
          not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j) --excluir a tabla de EXCEPCIONEs
    group by deca.sng055dsc,
           a.jaql965ase, 
           agtesuc;

 lc_Tipo_analista jaql577.jaql577tipo%type;
 ln_metasal number := 0;
 ln_metacli number := 0;
 ln_metamor number := 0;
 lc_tipage jaql570.jaql570age%type;
 ln_calcli jaql570.jaql570tipo%type;
 ln_calsal jaql570.jaql570tipo%type;
 ln_nummes number:=0;
 ln_numdia number:=0;
 lc_5030 char(4);
 lc_cmesal number := 0;
 lc_cmecli number := 0;      
 
 ln_Saldo_Otorgado number;
 ln_Saldo_Recibido number;
 ln_Cliente_Otorgado number;
 ln_Cliente_recibido number;
 ln_Por_Mora  number;
 ln_Clientes_Nuevos  number;
 ln_sal_cre_mes_anterior number;
 ln_Nro_cli_mes_anterior number;
 ln_Sal_maximo  number;
 ln_Cli_maximo  number;
 ln_Fec_CliMax  date;
 ln_Fec_SalMax   date;
 lc_Tipo_ana varchar2(4);
 lc_Tipo_agencia varchar2(4);
 ln_Rango_5000 number;
 ln_Rango_20000 number;
 ln_Rango_50000 number;
 ln_Rango_100000 number;
 ln_Rango_100001 number;
 ln_saltot  number;
 ln_clitot  number;
 ln_salmor number;
 ln_saljud number;
 ln_cont NUMBER;
 ln_salcas number;
 ln_salrec number; 
 ln_numrec number; 
 
 ln_nuevo_sal number ; -- para recalculo
 ln_nuevo_cli number ; -- para recalculo

 ln_saldo_vencido number; --saldo vencido
 ln_saldo_refinan number; --saldo refinanciado
 
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop

 
       ln_Saldo_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoNew(i.jaql965ase,pd_fecpro,i.agencia),0);
       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoNew(i.jaql965ase,pd_fecpro,i.agencia),0);

       ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgadoNew(i.jaql965ase,pd_fecpro,i.agencia),0); 
       ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibidoNew(i.jaql965ase,pd_fecpro,i.agencia),0);

       ln_saldo_vencido :=  pq_cr_productividad_ana.fn_pa_sal_vencido(i.jaql965ase,pd_fecpro);
       ln_saldo_refinan :=  pq_cr_productividad_ana.fn_pa_sal_refinan(i.jaql965ase,pd_fecpro);
   
         begin
           select /*+parallel(j,2) */count(*)
             into ln_cont
             from jaql966 j
            where jaql966usr = i.jaql965ase and jaql966suc = i.agencia;
         exception when no_data_found then
              ln_cont := 0;
         end; 
         
         if ln_cont > 0 then
           ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(i.jaql965ase,pd_fecpro,i.agencia);
         else
            ln_nummes := 0;       
         end if;
          
         ln_saljud := pq_cr_productividad_ana.fn_cr_sal_judicial(i.jaql965ase,pd_fecpro);
         ln_salmor := pq_cr_productividad_ana.fn_pa_saldo_mora(i.jaql965ase,pd_fecpro); --saldo mora  > 15 dias
         ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(i.jaql965ase,pd_fecpro);

   
         if  ln_nummes <= 6 then
             lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista_cal(i.jaql965ase,pd_fecpro);
             ---2014.03.13 --SI ES MENOR A 6 MESES NO CONSIDERAR SALDO MORA DE RECUPERACION LEGAL
             ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_numrec := pq_cr_productividad_ana.fn_pa_num_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_salmor := ln_salmor - ln_salrec;
             ---
             ln_nuevo_sal := i.Saldo_cartera - ln_salrec;
             ln_nuevo_cli := i.Nro_clientes - ln_numrec;
             --
             
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido - ln_salrec; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido - ln_numrec;
             
         else     
             lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista(i.jaql965ase,pd_fecpro);
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido;
             ln_nuevo_sal := i.Saldo_cartera;
             ln_nuevo_cli := i.Nro_clientes;
             
         end if;
       
      
       --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora_ini (i.jaql965ase,pd_fecpro,i.agencia, ln_salmor);
       ln_Clientes_Nuevos := pq_cr_productividad_ana.fn_pa_cliente_new (i.jaql965ase,pd_fecpro); 
       ln_sal_cre_mes_anterior := pq_cr_productividad_ana.fn_cr_saldo_anterior(i.jaql965ase, pd_fecpro, i.agencia); 
       ln_Nro_cli_mes_anterior := pq_cr_productividad_ana.fn_cr_nrocli_anterior(i.jaql965ase, pd_fecpro, i.agencia);   
--       ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro);    
--       ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro);  
       ln_Fec_CliMax := pq_cr_productividad_ana.fn_cr_fecha_cli_mes_base(i.jaql965ase, pd_fecpro);
       ln_Fec_SalMax  := pq_cr_productividad_ana.fn_cr_fecha_sal_mes_base(i.jaql965ase, pd_fecpro);                                                  
       lc_Tipo_agencia := pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(i.agencia/*i.jaql965suc*/,pd_fecpro); 
       
      --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora (i.jaql965ase,pd_fecpro,i.agencia, ln_salmor, ln_nuevo_sal /*i.Saldo_cartera*/, ln_saljud);
       
       ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql965ase,pd_fecpro,i.agencia,ln_salmor,ln_saljud, ln_nuevo_sal);
                                                        
         lc_Tipo_analista := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,lc_Tipo_agencia,ln_nuevo_sal/*i.Saldo_cartera*/);
         
         /*ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);
         ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);
         ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);*/
         
         --Nuevas Metas-Feb2015
         /*ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);
         ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);
         ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(lc_Tipo_ana,lc_Tipo_agencia,lc_Tipo_analista, i.agencia);*/
                    
         
         
         BEGIN
          pq_cr_productividad_ana.sp_cr_retorna_metas(pc_jaql579tip => lc_Tipo_analista ,
                                              pc_jaql579tase => lc_Tipo_ana,
                                              pc_tipage => lc_Tipo_agencia,
                                              pn_agencia => i.agencia,
                                              pc_codusu => i.jaql965ase,
                                              pn_metasal => ln_metasal ,
                                              pn_metacli => ln_metacli ,
                                              pn_metamor => ln_metamor );
         EXCEPTION WHEN OTHERS THEN
               ln_metasal := NULL;                                         
               ln_metacli := NULL;
               ln_metamor := NULL;               
               
         END;                                     
                                              
        
         lc_tipage := pq_cr_productividad_ana.fn_cr_tipo_agencia(i.agencia/*i.jaql965suc*/);
         ln_calcli := pq_cr_productividad_ana.fn_cr_cliente_cali(lc_tipage, ln_nuevo_cli /*i.Nro_clientes */);
         ln_calsal := pq_cr_productividad_ana.fn_cr_credito_cali(lc_tipage, ln_nuevo_sal /*i.Saldo_cartera*/);
         
         lc_5030 := pq_cr_productividad_ana.fn_cr_tipo_analista(lc_Tipo_agencia,lc_tipage, ln_nuevo_cli /*i.Nro_clientes*/);
         
        


         
       insert into jaql583 (jaql583fpro,jaql583usu, jaql583age, jaql583tusu, jaql583sdo, jaql583ncl, jaql583pmra,
              jaql583soto, jaql583srec, jaql583cot, jaql583crec, jaql583ncn, 
              jaql583sant, jaql583cant, jaql583smax, jaql583cmax, jaql583tage, jaql583fsmax, jaql583fcmax, 
              jaql583mtsa, jaql583mtcl, jaql583mtmr,
              jaql583est, jaql583mant, jaql583dant, jaql583pcod, jaql583tase, jaql583c5030, jaql583lage,
              jaql583sdju, jaql583sdtot, jaql583cltot, jaql583sdm, jaql583sdca, jaql583sdve, jaql583sdre
               )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, i.agencia/*i.jaql965suc*/, lc_Tipo_analista, 
                ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, ln_Por_Mora,
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, ln_Clientes_Nuevos,
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, ln_Sal_maximo, ln_Cli_maximo, lc_Tipo_agencia,
                ln_Fec_SalMax, ln_Fec_CliMax,
                ln_metasal, ln_metacli, ln_metamor,'S',
                ln_nummes,  ln_numdia, 1, lc_Tipo_ana, lc_5030, lc_tipage,
                ln_saljud, ln_saltot, ln_clitot, ln_salmor, ln_Salcas , ln_saldo_vencido, ln_saldo_refinan
              );
       
       commit; 

        
       ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro, i.agencia);    
       ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro, i.agencia);         
        
       /*if ln_Sal_maximo <= 0 then--2015.05.11 si meses de antiguedad = 1 en la agencia, saldo maximo = meta saldo, clientes maximo = meta clientes
          if ln_nummes = 1  then 
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
          end if;              
        end if;  --2015.05.11
       */

        --2016.02.08 --si tuvo otra agencia no considerar traslados
         if ln_nummes = 1  then 
           --si pertenecia a otra agencia y tuvo traslados
           if ln_Sal_maximo <= 0  then
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
           end if;  
           /*if ln_sal_cre_mes_anterior = 0 then
             ln_sal_cre_mes_anterior := ln_metasal;    
             ln_Nro_cli_mes_anterior := ln_metacli;  
           end if;*/
           
             update jaql583
                set jaql583sant=jaql583mtsa,
                    jaql583cant=jaql583mtcl
              where jaql583usu = i.jaql965ase
                and jaql583fpro = pd_fecpro;
          end if;              
          --2016.02.08       
       
       update jaql583
                set jaql583smax=ln_Sal_maximo,
                    jaql583cmax=ln_Cli_maximo
              where jaql583usu = i.jaql965ase
                and jaql583fpro = pd_fecpro;
       commit; 
                      
        --inserta JAQL572
         
         /*dbms_output.put_line('lc_Tipo_analista '||lc_Tipo_analista);
         dbms_output.put_line('ln_metasal '||ln_metasal);
         dbms_output.put_line('ln_metacli '||ln_metacli);
         dbms_output.put_line('ln_metamor '||ln_metamor);*/
         
       
       lc_cmesal := ln_saltot - ln_sal_cre_mes_anterior; -- crecimiento mensual saldo
       lc_cmecli := ln_clitot - ln_Nro_cli_mes_anterior; --crecimiento mensual clientes 
       
       insert into jaql572 (jaql572fpro, jaql572usu, JAQL572scre, jaql572ncli, jaql572cod, jaql572agen, jaql572ccli, 
                            jaql572csal, jaql572sant, jaql572ncl, jaql572tage, jaql572soto, jaql572srec,
                            jaql572coto, jaql572crec, jaql572est, jaql572mant, jaql572dant,
                            jaql572cme,  jaql572cmcl )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, 1, 
                i.agencia/*i.jaql965suc*/,  trim(ln_calcli), trim(ln_calsal),--clasif cliente, clasif saldo
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, lc_tipage,--tipo agencia
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, 'S',
                ln_nummes,  ln_numdia, lc_cmesal, lc_cmecli
              );
       
       commit; 
   
   end loop;  
   commit; 
 
 end sp_cr_carga_datos2015;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_cr_inserta_cartera_finmes( pd_fecpro in date) is
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
  TYPE tp_JAQL114EMP  IS TABLE OF JAQL114.JAQL114EMP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114MOD  IS TABLE OF JAQL114.JAQL114MOD%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114SUC  IS TABLE OF JAQL114.JAQL114SUC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114MDA  IS TABLE OF JAQL114.JAQL114MDA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114PAP  IS TABLE OF JAQL114.JAQL114PAP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114CTA  IS TABLE OF JAQL114.JAQL114CTA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114OPER IS TABLE OF JAQL114.JAQL114OPER%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114SBOP IS TABLE OF JAQL114.JAQL114SBOP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114TOP  IS TABLE OF JAQL114.JAQL114TOP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114INST IS TABLE OF JAQL114.JAQL114INST%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL114ASE  IS TABLE OF JAQL114.JAQL114ASE%type INDEX BY PLS_INTEGER;
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

  ln_numreg number;
  ln_indins number := 0;
  ln_saldore number;
  ln_saldove number;
  
begin
  

    select count(*)
      into ln_numreg
      from JAQL114
     where JAQL114FECH = pd_fecpro
     and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);


  select 
      JAQL114FECH,
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
  bulk collect into
      V_JAQL114FECH,
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
     and JAQL114MOD not in (108/*, 33*/) and (JAQL114MOD <> 106 Or JAQL114TOP <> 30);
     
     
     --Elimina registros de historico del dia actual
   begin
     --insertar diario en historico
     FOR i IN 1..ln_numreg loop
        ln_saldore := 0;
        ln_saldove := 0;

        
        if V_JAQL114RUBR(i) is not null then
          if substr(V_JAQL114RUBR(i),1,4) in ('1414','1424') AND V_JAQL114STAT(i) <> 33 then
                      ln_saldore := V_JAQL114SDMN(i);
            elsif substr(V_JAQL114RUBR(i),1,4) in ('1415','1425') then
                      ln_saldove := V_JAQL114SDMN(i);          
            else
              ln_saldore := 0;
              ln_saldove := 0;
          end if;
        end if;
        
       --insertar diario
       begin
       insert into JAQL965 (
          JAQL965FECH,
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
      VALUES (
            V_JAQL114FECH(i),
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
            ln_saldore
          );  
        exception when no_data_found then   
            null;       
            
         end;
       ln_indins := ln_indins + 1;
       if ln_indins >= 5000 then
         ln_indins := 0;
         commit;
       end if;
     end loop;
     commit;
   end;
   
    
end sp_cr_inserta_cartera_finmes;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_cr_inserta_cartera_diario( pd_fecpro in date) is
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
    -- *****************************************************************
  
  TYPE tp_JAQL964FEC IS TABLE OF JAQL964.JAQL964FEC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964MOD  IS TABLE OF JAQL964.JAQL964MOD%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SUC  IS TABLE OF JAQL964.JAQL964SUC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964MDA  IS TABLE OF JAQL964.JAQL964MDA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964CTA  IS TABLE OF JAQL964.JAQL964CTA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964OPE IS TABLE OF JAQL964.JAQL964OPE%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SOB IS TABLE OF JAQL964.JAQL964SOB%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964TOP  IS TABLE OF JAQL964.JAQL964TOP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964INS IS TABLE OF JAQL964.JAQL964INS%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964USU  IS TABLE OF JAQL964.JAQL964USU%type INDEX BY PLS_INTEGER;
  --TYPE tp_JAQL964RUBR IS TABLE OF JAQL964.JAQL964RUBR%type INDEX BY PLS_INTEGER;
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
     
  V_JAQL964FEC tp_JAQL964FEC; 
  V_JAQL964MOD  tp_JAQL964MOD;  
  V_JAQL964SUC  tp_JAQL964SUC;  
  V_JAQL964MDA  tp_JAQL964MDA;  
  V_JAQL964CTA  tp_JAQL964CTA;  
  V_JAQL964OPE tp_JAQL964OPE; 
  V_JAQL964SOB tp_JAQL964SOB; 
  V_JAQL964TOP  tp_JAQL964TOP;  
  V_JAQL964INS tp_JAQL964INS; 
  V_JAQL964USU  tp_JAQL964USU;  
  --V_JAQL964RUBR tp_JAQL964RUBR; 
  V_JAQL964SAC tp_JAQL964SAC; 
  V_JAQL964SAO tp_JAQL964SAO; 
  V_JAQL964DIA tp_JAQL964DIA; 
  V_JAQL964PAI tp_JAQL964PAI;   
  V_JAQL964TID tp_JAQL964TID;   
  V_JAQL964DOC tp_JAQL964DOC;   
  V_JAQL964PRO tp_JAQL964PRO;   
  V_JAQL964SEC tp_JAQL964SEC;
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

    select count(*)
      into ln_numreg
      from JAQL964
     where JAQL964FEC = ld_fecpro;

  select --distinct
      JAQL964FEC -1,
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
      JAQL964EST
  bulk collect into
      V_JAQL964FEC,
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
      V_JAQL964STAT
   from JAQL964       
   where JAQL964FEC = ld_fecpro
     and JAQL964MOD not in (108, /*33,*/ 117) and (JAQL964MOD <> 106 Or JAQL964TOP <> 30)
   group by 
      JAQL964FEC,
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
      JAQL964EST/*,
      JAQL964SEC*/;
     
     
     --Elimina registros de historico del dia actual
   begin
   
    --insertar diario en historico
     FOR i IN 1..ln_numreg loop
     
     begin
          select f.aofval, f.aofvto
            into ld_fecval,ld_fecvto
            from FSD010 f
           where f.PGCOD = 1
             and f.AOMOD = V_JAQL964MOD(i)
             and f.AOMDA = V_JAQL964MDA(i)
             and f.AOPAP = 0
             and f.AOCTA = V_JAQL964CTA(i)
             and f.AOSUC =  V_JAQL964SUC(i)
             and f.AOOPER = V_JAQL964OPE(i)
             and f.AOSBOP = V_JAQL964SOB(i)
             and f.aostat = V_JAQL964STAT(i)--0   --2016.02.08 se agrego variable estado
             and rownum < 2;   
     exception when no_data_found then
         ld_fecval := null;
         ld_fecvto := null;      
     end;
     
     
     begin
       --insertar diario
       insert into JAQL965 (
          JAQL965FECH,
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
          --JAQL965RUBR,
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
          JAQL965STAT
          )
      VALUES (
            V_JAQL964FEC(i),
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
            --V_JAQL964RUBR(i),
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
             V_JAQL964STAT(i)
          );  
       exception when no_data_found then   
          null;       
       end;
       ln_indins := ln_indins + 1;
       if ln_indins >= 5000 then
         ln_indins := 0;
         commit;
       end if;
     end loop;
     commit;
   end;

   --inserta castigados
   
   ---DEBE insertar cartera castigados >>>>>>>>>>>>>>>>>>>se deshabilito porque se carga en proceso JAQL964
   /*begin
    -- Call the procedure
    pq_cr_productividad_ana.sp_cr_inserta_castigados(pd_fecpro => pd_fecpro\*ld_fecpro*\);
    commit;  
  end;*/
  
   --
   
 
 end sp_cr_inserta_cartera_diario;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_castigados( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_castigados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : INSERTA CARTERA CASTIGADOS JAQL965
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  TYPE tp_JAQL964FEC IS TABLE OF JAQL964.JAQL964FEC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964MOD  IS TABLE OF JAQL964.JAQL964MOD%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SUC  IS TABLE OF JAQL964.JAQL964SUC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964MDA  IS TABLE OF JAQL964.JAQL964MDA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964CTA  IS TABLE OF JAQL964.JAQL964CTA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964OPE IS TABLE OF JAQL964.JAQL964OPE%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SOB IS TABLE OF JAQL964.JAQL964SOB%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964TOP  IS TABLE OF JAQL964.JAQL964TOP%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964INS IS TABLE OF JAQL964.JAQL964INS%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964USU  IS TABLE OF JAQL964.JAQL964USU%type INDEX BY PLS_INTEGER;
  --TYPE tp_JAQL964RUBR IS TABLE OF JAQL964.JAQL964RUBR%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SAC IS TABLE OF JAQL964.JAQL964SAC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SAO IS TABLE OF JAQL964.JAQL964SAO%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964DIA IS TABLE OF JAQL964.JAQL964DIA%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964PAI IS TABLE OF JAQL964.JAQL964PAI%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964TID IS TABLE OF JAQL964.JAQL964TID%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964DOC IS TABLE OF JAQL964.JAQL964DOC%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964PRO IS TABLE OF JAQL964.JAQL964PRO%type INDEX BY PLS_INTEGER;
  TYPE tp_JAQL964SEC IS TABLE OF JAQL964.JAQL964SEC%type INDEX BY PLS_INTEGER;
  --TYPE tp_JAQL964STAT IS TABLE OF JAQL964.JAQL964STAT%type INDEX BY PLS_INTEGER;
  --TYPE tp_JAQL964PROM IS TABLE OF JAQL964.JAQL964PROM%type INDEX BY PLS_INTEGER;
  --TYPE tp_JAQL964TPCL IS TABLE OF JAQL964.JAQL964TPCL%type INDEX BY PLS_INTEGER;
     
  V_JAQL964FEC tp_JAQL964FEC; 
  V_JAQL964MOD  tp_JAQL964MOD;  
  V_JAQL964SUC  tp_JAQL964SUC;  
  V_JAQL964MDA  tp_JAQL964MDA;  
  V_JAQL964CTA  tp_JAQL964CTA;  
  V_JAQL964OPE tp_JAQL964OPE; 
  V_JAQL964SOB tp_JAQL964SOB; 
  V_JAQL964TOP  tp_JAQL964TOP;  
  V_JAQL964INS tp_JAQL964INS; 
  V_JAQL964USU  tp_JAQL964USU;  
 -- V_JAQL964RUBR tp_JAQL964RUBR; 
  V_JAQL964SAC tp_JAQL964SAC; 
  V_JAQL964SAO tp_JAQL964SAO; 
  V_JAQL964DIA tp_JAQL964DIA; 
  V_JAQL964PAI tp_JAQL964PAI;   
  V_JAQL964TID tp_JAQL964TID;   
  V_JAQL964DOC tp_JAQL964DOC;   
  V_JAQL964PRO tp_JAQL964PRO;   
  V_JAQL964SEC tp_JAQL964SEC;   
  --V_JAQL964STAT tp_JAQL964STAT;   
  --V_JAQL964PROM tp_JAQL964PROM;  
  --V_JAQL964TPCL tp_JAQL964TPCL;   

  ln_numreg number;
  ln_indins number := 0;
  ld_fecval date;
  ld_fecvto date;
  ld_Fecpro date;
    
 ld_finmes date;
 
 begin
 
 
    
  insert into JAQL965 (
            JAQL965FECH,
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
            JAQL965STAT
           /* JAQL965TCRD,
            JAQL965SECT*//*,
            JAQL965STAT,
            JAQL965PROM,
            JAQL965TPCL*/)

       
  select /*+parallel(a,4,@2) parallel(pers,4,@2)*/
         a.bcfech,
         a.bcemp, 
         A.BCMOD ,
         a.bcsuc,
         a.bcmda,
         a.bcpap,
         A.BCCTA ,
         A.BCOPER ,
         a.BCSBOP ,
         A.BCTOP,
         fn_instancia_credito(A.BCMOD,a.bcsuc, a.bcmda,a.bcpap,A.BCCTA,A.BCOPER,a.BCSBOP,A.BCTOP) instancia,
         fn_analista_credito(a.bcmod,a.bcsuc,a.bcmda,a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop)  analista,
         a.bcrubr,
         a.bcsdmn,
         a.bcsdmo,
         fn_dias_atraso(a.bcfech, a.bcemp, a.bcmod, a.bcsuc, a.bcmda, a.bcpap, a.bccta, a.bcoper,
                        a.bcsbop, a.bctop, a.bccta, a.bcfvto),
         a.bcfval,
         a.bcfvto,
         PERS.PEPAIS,
         PERS.PETDOC,
         PERS.PENDOC,
         a.bcprod
      from fsh012 a,
         fst001 b,
         FST001 age,
         fsr008 pers
  where a.bccta <> 999999999
     and substr(a.bcrubr,1,2) in (81)
     and a.bcmod   = 33
     and b.pgcod = a.bcemp
     and b.sucurs= a.bcsuc
     and a.bcfech= pd_fecpro
     and age.Pgcod  = 1 and age.Sucurs = a.bcsuc
     and pers.ctnro = a.bccta
     and pers.ttcod = 1
     and pers.CTTFIR = 'T';   
  

 end sp_cr_inserta_castigados;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

 
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
 ln_num number := 0;
 begin
 
  --execute immediate ('truncate table JAQL965');
  --buscar si fecha ya existe
  
  /*begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL965',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
    */
  
  begin 
  select count(*)
    into ln_num
    from jaql965
   where jaql965fech = pd_fecpro ;
  exception when no_Data_found then
    ln_num := 0;
  end;
   
  /*if ln_num > 0 then
     execute immediate ('delete from JAQL965');
  end if;*/
      
  ld_finmes := last_Day(pd_fecpro);
  if pd_fecpro = ld_finmes then
     pq_cr_productividad_ana.sp_cr_inserta_cartera_finmes( pd_fecpro);
  else
     pq_cr_productividad_ana.sp_cr_inserta_cartera_diario( pd_fecpro);
  end if;
  commit;

  --actualiza tralsados
  begin
  pq_cr_productividad_ana.sp_cr_traslados_jaql969(pd_fecpro);
  end;

 end sp_cr_inserta_cartera;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_Sal_Judicial(pc_analista IN varchar2,pd_fecpro in date ) return number is
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
    ln_saljud number:=0;   
    ld_fecini date;    
    ln_salcas number:=0;
  begin
     
       begin 
        select nvl(sum(c.Jaql965sdmn),0)--, count(distinct bccta),sng095_201404asnu 
          into ln_saljud
          from JAQL965 c 
         where c.jaql965fech = pd_fecpro
           --and c.jaql965ase = pc_analista
           and TRIM(c.jaql965ase) = TRIM(pc_analista)
           and c.jaql965mod = 200 
           and (c.jaql965cta, c.jaql965oper , c.jaql965ase) 
               not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j);
       exception when no_data_found then
           ln_saljud := 0;          
       end;    
       
       
    return nvl(ln_saljud,0);

  end fn_cr_Sal_Judicial;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 Function fn_cr_Sal_Castigado(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el saldo Castigado para el calculo % de mora.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saljud number:=0;   
    ld_fecini date;    
    ln_dias number:= 365;
    ln_salcas number:=0;
    lc_analista char(10);
  begin
     
   lc_analista := rpad(pc_analista, 10, ' ');
  
     begin  
       
         select sum(Jaql965sdmn)
         into ln_salcas
           from (select /*+parallel (c,2) (j,2)*/distinct c.Jaql965sdmn,
                                 c.jaql965cta,
                                 c.jaql965oper,
                                 j.jaql166scfvl
                 
                   from jaql965 c, JAQL166/*_20140731*/ J --QUITAR COMENTARIO jaql166 j
                  where c.jaql965fech = pd_fecpro
                   and c.jaql965ase =  lc_analista--pc_analista
                    and c.jaql965mod = 33
                    and c.jaql965mod = j.jaql166scmod 
                    and c.jaql965cta = j.jaql166sccta
                    and c.jaql965oper = j.jaql166scope
                    and c.jaql965suc = j.jaql166scsuc
                    and c.jaql965mda = j.jaql166scmda
                    and c.jaql965pap = j.jaql166scpap
                    and c.jaql965sbop = j.jaql166scsbo
                    and j.jaql166est = 90
                    and (c.jaql965cta, c.jaql965oper , c.jaql965ase) 
                         not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j)
                    --and TRIM(c.jaql965ase) = TRIM(pc_analista) 
                    and jaql166scfvl >= pd_fecpro - ln_dias) a;
               
      exception when no_data_found then
           ln_salcas := 0;          
      end;
        
    return nvl(ln_salcas,0);

  end fn_cr_Sal_Castigado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_cr_calcula_bonos_ini(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   
begin

    begin
      -- Call the procedure
      pq_cr_productividad_ana.sp_cr_bono_mantenimiento(pd_fecpro => pd_fecpro, pc_analista => pc_analista );
    end;

  --  commit;
/*    begin
      pq_cr_productividad_ana.sp_cr_bonos_productividad(pd_fecpro => pd_fecpro,pc_analista => pc_analista);
    end;
    commit;*/
    
    begin
      pq_cr_productividad_ana.sp_cr_job_bono_produ(pd_fecpro => pd_fecpro);
    end;
    
end sp_cr_calcula_bonos_ini;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_cr_calcula_bonos(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   
 
  cursor creditos(pd_fecpro in date)  is
     select j.* 
       from jaql583 j
      where jaql583fpro = pd_fecpro
        and jaql583tusu <> 'VI'
        and jaql583tage <> 'N'
        and jaql583tase = 'P'  ---816
        and jaql583sdve >=50000
        and jaql583pmra > jaql583mtmr; -- porcentaje mora sea mayor a meta mora; --
        
   
 
begin

  --obtiene la nueva meta mora...
  begin
    pq_cr_productividad_ana.sp_cr_actualiza_metamora(pd_fecpro => pd_fecpro);
  end;


    begin
      pq_cr_productividad_ana.sp_cr_bono_mantenimiento(pd_fecpro => pd_fecpro, pc_analista => pc_analista );
    end;


    for i in creditos(pd_fecpro) loop
        if  i.jaql583pmra <= i.jaql583pmnu then  --Mora del MES debe ser MENOR O IGUAL A NUEVA MORA CALCULADA 
        
             update jaql583
                set jaql583inca = 'N'      
              where jaql583usu = i.jaql583usu
                and jaql583fpro = i.jaql583fpro;
                 
        end if;    
    end loop;
    commit;
   
  --ACTUALIZAR
    update jaql583
       set jaql583inca = 'A'      
     where jaql583fpro = pd_fecpro
       AND jaql583inca IS NULL;
    COMMIT;
    
    begin
      pq_cr_productividad_ana.sp_cr_bonos_mejora(/*pn_sucurs => :pn_sucurs,*/
                                                 pd_fecpro => pd_fecpro,
                                                 pc_analista => pc_analista);
    end;
    

   begin
      pq_cr_productividad_ana.sp_cr_job_bono_produ(pd_fecpro => pd_fecpro);
    end;    
    
end sp_cr_calcula_bonos;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad_ini( pd_fecpro in date, pc_analista in char)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              --(nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              --(nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              (jaql583sdtot) jaql583saldo,  --saldo total
              (jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583
        where jaql583fpro = ld_fecpro
          and jaql583usu like '%'||lc_analista;
         -- and jaql583tase is not null;
               



ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 60; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
begin


 for i in metas_plus(pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
    
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if i.jaql583saldo > 0  --saldo total > 0
        and (i.jaql583saldo - i.jaql583sant)>= i.jaql583mtsa --crecimiento mensual>= metasaldo
        then
         ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
     end if;
     
     --2--obtiene bono por cumplimiento meta cliente
     if i.jaql583cliente > 0  --clientes total > 0
        and (i.jaql583cliente - i.jaql583cant)>= i.jaql583mtcl --crecimiento mensual >= metacliente
        then
         ln_bonocli := pq_cr_productividad_ana.fn_cr_bono_cliente(i.jaql583tase);
     end if;

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= i.jaql583mtmr  --porcentaje mora >= meta mora
        then
        ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + ln_bonocli + ln_bonomora; --TOTAL BONO
     if ln_totalBONO > 500 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 500; 
     end if;
     ---
     
--- ==> PAGO VARIABLE

   
     
     -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583saldo - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     if ln_por_clientes >=  ln_Por_Cliente  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
     --4--crecimiento 
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and ln_cre_saldoanual - i.jaql583mtsa > 0 then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
             ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * 0.50;
             end if;


     end if;
     
     --5--crecimiento               
     if ln_cre_clienteanual > 0 -- crecimiento mensual
        and (ln_cre_clienteanual -  i.jaql583mtcl) > 0 then 
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------*************************
         
           ---calcular PLUS
           --B-- cliente anual
              begin
                select jaql581clia
                  into ln_porcentaje --porcentaje anual
                  from jaql581
                 where jaql581cage = i.jaql583tage
                   and jaql581tase = i.jaql583tase
                   and jaql581est = 'S';
              exception
                when no_data_found then
                  ln_porcentaje := 0;
              end;
              
              --plus crecimiento * plus /100
               ln_plusclianu := (ln_cre_clienteanual - i.jaql583mtcl)* ln_porcentaje;
     end if;
     
    
    --7--crecimiento saldo mensual
     if  (ln_cre_saldoanual - i.jaql583mtsa) > 0 then 
       
         ---calcular PLUS
            --A-- saldo mensual
            begin
              select jaql581sdom
                into ln_porcentaje --porcentaje mensual saldo
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
             ln_plussdomes := (ln_cre_saldomes - ln_cre_saldoanual )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdomes := ln_plussdomes * 0.50;
             end if;
     end if;    
     
      --8--crecimiento cliente mensual               
     if (ln_cre_clienteanual -  i.jaql583mtcl) > 0 then 
        
           ---calcular PLUS
           --B-- cliente mensual
              begin
                select jaql581clim
                  into ln_porcentaje --porcentaje mensual
                  from jaql581
                 where jaql581cage = i.jaql583tage
                   and jaql581tase = i.jaql583tase
                   and jaql581est = 'S';
              exception
                when no_data_found then
                  ln_porcentaje := 0;
              end;
              
              --plus crecimiento * plus /100
               ln_plusclimes := (ln_cre_clientemes - ln_cre_clienteanual )* ln_porcentaje;
     end if;    
          
     
     --9--PLUS CLIENTES NUEVOS               
     if ln_cre_clientemes > 0 then 
        
        /* if i.jaql583sdc1 > 0 then 
               begin
                  select jaql582plus
                    into ln_plusnuevo     
                    from jaql582
                   where jaql582tage = i.jaql583tage
                     and jaql582tase = i.jaql583tase
                     and jaql582smax =  5000--3000
                     and jaql582est = 'S';  
               exception when no_data_found then
                         ln_plusnuevo := 0;    
               end;                  
               ln_bonocli1 :=  i.jaql583sdc1 * ln_plusnuevo; 
                  
          end if; 
                 
          if i.jaql583sdc2 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax =  20000--10000.00;  
                 and jaql582est = 'S';
           exception when no_data_found then
                     ln_plusnuevo := 0;  
            end;                    
            ln_bonocli2 :=  i.jaql583sdc2 * ln_plusnuevo;                   
              
         end if;
          if i.jaql583sdc3 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax = 50000.00
                 and jaql582est = 'S';  
           exception when no_data_found then
                     ln_plusnuevo := 0; 
            end;                     
            ln_bonocli3 :=  i.jaql583sdc3 * ln_plusnuevo;                   
              
         end if;    
          if i.jaql583sdc4 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax = 100000.00  
                 and jaql582est = 'S';
           exception when no_data_found then
                     ln_plusnuevo := 0;     
            end;                 
            ln_bonocli4 :=  i.jaql583sdc4 * ln_plusnuevo;                   
              
         end if;              
          if i.jaql583sdc5 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax > 100000.00--=  200000.00; 
                 and jaql582est = 'S'; 
           exception when no_data_found then
                     ln_plusnuevo := 0;            
           end;          
           ln_bonocli5 :=  i.jaql583sdc5 * ln_plusnuevo;                   
              
         end if;
          \*if i.jaql583sdc6 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax =  500000.00;  
           exception when no_data_found then
                 ln_plusnuevo := 0;            
              ln_bonocli6 :=  i.jaql583sdc6 * ln_plusnuevo;                   
           end;  
         end if; *\        
         
          \*if i.jaql583sdc7 > 0 then 
           begin
              select jaql582plus
                into ln_plusnuevo     
                from jaql582
               where jaql582tage = i.jaql583tage
                 and jaql582tase = i.jaql583tase
                 and jaql582smax >  500000.00;  
           exception when no_data_found then
                 ln_plusnuevo := 0;            
              ln_bonocli7 :=  i.jaql583sdc7 * ln_plusnuevo;                   
            end;  
         end if;  *\   
         ----    
         ln_PLUSCLINUEVO := ln_bonocli1 + ln_bonocli2 + ln_bonocli3 + ln_bonocli4 + ln_bonocli5 \*+ ln_bonocli6 + ln_bonocli7*\;
         ln_clinuevo :=  i.jaql583sdc1 + i.jaql583sdc2 + i.jaql583sdc3 + i.jaql583sdc4 + i.jaql583sdc5; --total numero de clientes.
         -----
*/    

         begin
          pq_cr_productividad_ana.sp_pa_clte_nuevo(pc_analista => i.jaql583usu,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_tipage => i.jaql583tage,
                                                   pn_numcli => ln_clinuevo,
                                                   pn_mtonue => ln_PLUSCLINUEVO);
         end;



     end if;    
     
     --10 MONTO CASTIGADO
     ----------
     begin
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = i.jaql583tase
          and jaql595tiag = i.jaql583tage
          and jaql595cla  = i.jaql583tusu
          and ln_Por_Mora/*i.jaql583pmra*/ > jaql595min
          and ln_Por_Mora/*i.jaql583pmra*/ <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;
     
     
     ----
     --11 BONO POR EXCEDENTE EN CLIENTES
     -----
     --solo aplica a PMYES
     if i.jaql583tase = 'P'  then
        
                    begin
            -- Call the procedure
            pq_cr_productividad_ana.sp_cr_excede_meta_cli(pc_tiagel => i.jaql583tage, --E/N/O
                                                          pc_tipage => i.jaql583lage, -- <> LIMA = 1 / LIMA = 2
                                                          pc_tipcla => i.jaql583c5030, -- U.....Z
                                                          pn_numcli => i.jaql583cliente, --clientes mes
                                                          pn_metanu => i.jaql583cmax, --meta anual = clientes base/maximo
                                                          pn_metmes => i.jaql583mtcl, --meta mes
                                                          pn_climesa => i.jaql583cant,   --cliente mes anterior                                                       
                                                          pn_porcla => ln_porcla,
                                                          pn_porclm => ln_porclm,
                                                          pn_bonanu => ln_bonanu,
                                                          pn_bonmen => ln_bonmen,
                                                          pn_totanu => ln_total_exc_anual,
                                                          pn_totmes => ln_total_exc_mes,
                                                          pn_nummes => ln_excmes,
                                                          pn_numanu => ln_excanu
                                                           );
          end;
        
      
         
     end if;            
     ---
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + ln_plusclianu + ln_plussdomes + ln_plusclimes ) * ln_castigo/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + ln_plusclianu + ln_plusclimes + ln_PLUSCLINUEVO +  ln_mtocastigo ;
     
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
     
     
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bcli = ln_bonocli,
            jaql583bmra = ln_bonomora,
            jaql583cran = ln_cre_saldoanual, 
            jaql583crme = ln_cre_saldomes, 
            jaql583crca = ln_cre_clienteanual, 
            jaql583crcm = ln_cre_clientemes, 
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            jaql583ppca = ln_plusclianu, 
            jaql583ppcm = ln_plusclimes, 
            jaql583ppcn = ln_PLUSCLINUEVO,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PJCA = ln_porcla,
            JAQL583PJCM = ln_porclm,
            JAQL583EXAN = ln_bonanu,
            JAQL583EXME = ln_bonmen,
            JAQL583TEXAN = ln_total_exc_anual, --total excedente anual
            JAQL583TEXME = ln_total_exc_mes, --total excedente mensual
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            ---ultimos campos actualizados
            JAQL583CRSA = ln_cre_saldomes,
            JAQL583CRCL = ln_cre_clientemes,
            JAQL583TOTPA = (ln_totalBONO + ln_totalPLUS) + ln_total_exc_anual + ln_total_exc_mes, 
            JAQL583NEXA = ln_excanu,
            JAQL583NEXM = ln_excmes,
            JAQL583NCN = ln_clinuevo,
            JAQL583PJCAS = ln_castigo --porcentaje castigo
            ---
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
                    
      --actualiza mantenimiento 2014 NO HAY CASTIGO....
      if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := (ln_bono_sal + ln_bono_cli )  * ln_castigo/100;
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) 
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ----
   
     
 end loop;


end sp_cr_bonos_productividad_ini;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad2015(pn_sucurs in number, pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ln_sucurs number,ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583 j
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
       and jaql583usu like '%'||lc_analista||'%' 
       and j.jaql583age = ln_sucurs  
       and nvl(j.jaql583inca,'A') <> 'N';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
   
ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pn_sucurs, pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
                                                            
  ---REVISAR CLIENTES Y SALDOS QUE NO SE ESTE ALTERANDO LA INFORMACION.
     
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if /*i.jaql583sdo*/i.jaql583saldo > 0  --saldo total > 0
        and (/*i.jaql583sdo*/i.jaql583saldo - i.jaql583sant)>= i.jaql583mtsa --crecimiento mensual>= metasaldo
        then
         ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
     end if;
     
     --2--obtiene bono por cumplimiento meta cliente
     if /*i.jaql583ncl*/i.jaql583cliente > 0  --clientes total > 0
        and (/*i.jaql583ncl*/i.jaql583cliente - i.jaql583cant)>= i.jaql583mtcl --crecimiento mensual >= metacliente
        then
         ln_bonocli := pq_cr_productividad_ana.fn_cr_bono_cliente(i.jaql583tase);
     end if;

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= i.jaql583mtmr  --porcentaje mora >= meta mora
        then
        ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
        
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + ln_bonocli + ln_bonomora; --TOTAL BONO
     if ln_totalBONO > 500 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 500; 
     end if;
     ---
     
--- ==> PAGO VARIABLE

   
     -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583sdo/*i.jaql583saldo*/ - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583ncl /*i.jaql583cliente*/ - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
     
     if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
     --if ln_por_clientes >=  ln_Por_Cliente  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
      --4--crecimiento saldo ANUAL
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and ln_cre_saldoanual - i.jaql583mtsa > 0 
        and i.jaql583smax > 0 --2014.08.07
        then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
            
            
               ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
            
            
            -- ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
             end if;
             if ln_plussdoanu < 0 then
                ln_plussdoanu := 0;
             end if;  

     end if;
     
     
      --7--CALCULAR PRIMERO - crecimiento saldo MENSUAL
       ---calcular PLUS
                --A-- saldo mensual
                begin
                  select jaql581sdom
                    into ln_porcentaje --porcentaje mensual saldo
                    from jaql581
                   where jaql581cage = i.jaql583tage
                     and jaql581tase = i.jaql583tase
                     and jaql581est = 'S';
                exception
                  when no_data_found then
                    ln_porcentaje := 0;
                end;
      
     if  ( ln_cre_saldoanual - i.jaql583mtsa ) > 0 then
          
         if i.jaql583smax > 0 then--2014.08.07
                 ln_plussdomes := ((ln_cre_saldomes - i.jaql583mtsa )- (ln_cre_saldoanual - i.jaql583mtsa));
                 ln_plussdomes := ln_plussdomes * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
        
        end if;         
     ELSE

        --if i.jaql583smax > 0 --2014.08.07
                 ln_plussdomes := (ln_cre_saldomes - i.jaql583mtsa ) * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 

        --end if;         
     end if;
         
   
     
     
  
    ----
     --11 BONO POR CLIENTES
     -----
     --solo aplica a PMYES
     --if i.jaql583tase = 'P'  then
        
          begin
            -- Call the procedure
            pq_cr_productividad_ana.sp_cr_pago_variable_cli(pc_tiagel => i.jaql583tage, --E/N/O
                                                          pc_tipage => i.jaql583lage, -- <> LIMA = 1 / LIMA = 2
                                                          pc_tipcla => i.jaql583c5030, -- U.....Z
                                                          pc_claana => i.jaql583tase, -- P Pymes / c consumo
                                                          pn_numcli => i.jaql583ncl/*i.jaql583cliente*/, --clientes mes  ---2014.08.07
                                                          pn_metanu => i.jaql583cmax, --meta anual = clientes base/maximo
                                                          pn_metmes => i.jaql583mtcl, --meta mes
                                                          pn_climesa => i.jaql583cant -i.jaql583cot + i.jaql583crec,   --cliente mes anterior      ---2014.08.07                                                  
                                                          pn_porcla => ln_porcla,
                                                          pn_porclm => ln_porclm,
                                                          pn_bonanu => ln_bonanu,
                                                          pn_bonmen => ln_bonmen,
                                                          pn_totanu => ln_total_exc_anual,
                                                          pn_totmes => ln_total_exc_mes,
                                                          pn_nummes => ln_excmes,
                                                          pn_numanu => ln_excanu,
                                                          pc_indexa => lc_indexa,
                                                          pc_indexm => lc_indexm
                                                           );
          end;
        
          ln_plusclianu := ln_total_exc_anual;
          ln_plusclimes := ln_total_exc_mes;
         
     --end if;            
     ---
          
     
     --9--PLUS CLIENTES NUEVOS               
     if ( ln_cre_clientemes - i.jaql583mtcl) >= 0 then 
      
       
         begin
          pq_cr_productividad_ana.sp_pa_clte_nuevo(pc_analista => i.jaql583usu,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_tipage => i.jaql583tage,
                                                   pn_numcli => ln_clinuevo,
                                                   pn_mtonue => ln_PLUSCLINUEVO);
         end;
      
      end if;
            

     
     
     --10 MONTO CASTIGADO
     ----------
    
     begin
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = i.jaql583tase
          and jaql595tiag = i.jaql583tage
          and jaql595cla  = i.jaql583tusu
          and ln_Por_Mora > jaql595min
          and ln_Por_Mora <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;
     
     
 
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + ln_plusclianu + ln_plussdomes + ln_plusclimes + ln_PLUSCLINUEVO ) * ln_castigo/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + ln_plusclianu + ln_plusclimes + ln_PLUSCLINUEVO +  ln_mtocastigo ;
     
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
    if ln_totalPlus >=0 then
        ln_totalPP := ln_totalPLUS; 
    else
        ln_totalPP := 0;
    end if;    
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bcli = ln_bonocli,
            jaql583bmra = ln_bonomora,
            jaql583cran = ln_cre_saldoanual, 
            jaql583crme = ln_cre_saldomes, 
            jaql583crca = ln_cre_clienteanual, 
            jaql583crcm = ln_cre_clientemes, 
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            jaql583ppca = ln_plusclianu, 
            jaql583ppcm = ln_plusclimes, 
            jaql583ppcn = ln_PLUSCLINUEVO,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PJCA = ln_porcla,
            JAQL583PJCM = ln_porclm,
            JAQL583EXAN = ln_bonanu,
            JAQL583EXME = ln_bonmen,
            JAQL583TEXAN = ln_total_exc_anual, --total excedente anual
            JAQL583TEXME = ln_total_exc_mes, --total excedente mensual
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            ---ultimos campos actualizados
            JAQL583CRSA = ln_cre_saldomes,
            JAQL583CRCL = ln_cre_clientemes,
            JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
            JAQL583NEXA = ln_excanu,
            JAQL583NEXM = ln_excmes,
            JAQL583NCN = ln_clinuevo,
            JAQL583PJCAS = ln_castigo, --porcentaje castigo
            ---
            --ultimos campos
            jaql583cexa = lc_indexa,
            jaql583cexm = lc_indexm,
            ---
            jaql583inca = 'A'
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
         
      --actualiza mantenimiento CASTIGO....
      --if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                 jaql572mcas =  ln_castigo_mantenimiento,
                 jaql572pjcas = ln_castigo,
                 jaql572inca = 'A'
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      --end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_bonos_productividad2015;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure  sp_cr_retorna_bono_mto(pc_tipasesor IN char, 
                                   pd_fecpro in date,
                                   pn_bono_sal out number,
                                   pn_bono_cli out number)  is
    -- *****************************************************************
    -- Nombre                     : sp_cr_retorna_bono_mto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Retorna bonos por saldo y cliente calculados en mantenimiento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************


  begin
  
        begin   
            select jaql572bsal,jaql572bcli 
              into pn_bono_sal, pn_bono_cli
              from jaql572
             where jaql572usu = pc_tipasesor
               and jaql572fpro = pd_fecpro;
        exception when no_data_found then 
            pn_bono_sal := 0;
            pn_bono_cli := 0;
        end;

 end sp_cr_retorna_bono_mto;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_saldo_mora(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- *****************************************************************

  ln_salmor number; 
        
  begin
         
     begin      
        select /*+parallel(j,2) */sum(case
                            when j.JAQL965DATR > 15 and j.JAQL965MOD not in (200, 33) then
                             j.JAQL965SDMN 
                            else
                             0
                          end)
          into ln_salmor             
          from JAQL965 j
         where j.jaql965fech = pd_fecpro
           and trim(j.JAQL965ASE) = trim(pc_analista)
           and j.JAQL965MOD not in (108,200,33)
           and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1
           and (j.jaql965cta, j.jaql965oper , j.jaql965ase) 
               not in (select c.jaql970cta, c.jaql970oper , c.jaql970ase from jaql970 c);
              
      exception 
        when others then 
         ln_salmor := 0;
      end;
  
    return ln_salmor;  
   
  end fn_pa_saldo_mora;



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_nueva_mora(pc_analista IN varchar2,pd_fecpro in date, pc_codsuc in varchar2, 
                          pn_salmor in number, pn_saljud in number, pn_saldo in number) return number is
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

  ln_pormor number; 
  ln_saljud number := 0;
  ln_nummes number := 0;
  ln_cont number := 0;
  ln_saldo number := 0; 
  ln_salcas number:= 0;      
  ln_dias number:=365;
  ln_salrec number := 0;
  ln_nuevamora number:= 0;
  ln_monto number:=0;
  
  begin
  

       ln_saljud := pn_saljud;
       begin
         select /*+parallel(j,2) */count(*)
           into ln_cont
           from jaql966 j
          where trim(jaql966usr) = trim(pc_analista) and jaql966suc = pc_codsuc;
       exception when no_data_found then
                 ln_cont := 0;
       end; 
         
       if ln_cont > 0 then
          ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(pc_analista,pd_fecpro, pc_codsuc);
       else
          ln_nummes := 0;
          ln_saljud := 0;
       end if;    
                                                                  
            
        ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(pc_analista,pd_fecpro);   
        --ln_salcas := nvl(ln_salcas,0);
            
        if ln_nummes <= 6 then --NO considerar saldo judicial
            ln_saljud :=  0;    
            --2014.03.13
            --ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(pc_analista,pd_fecpro); --saldo de creditos en recuperacion legal
            ---DESCONTAR CREDITOS EN ESTADO DE RECUPERACION LEGAL
            -- CUANDO NO SUPERA LOS 6 MESES NO CONSIDERAR EN SALDO MORA LOS ESTADOS 21,22,23,25
            ln_salcas := 0;         
              
         end if;
        
         ---calcular mora 
        if (pn_saldo + ln_saljud +ln_salcas) > 0 then
              ln_pormor := round( (pn_salmor  + ln_saljud + ln_salcas ) / (pn_saldo + ln_saljud +ln_salcas ) * 100,2);
        else
              ln_pormor := 0;
        end if; 

     
  return ln_pormor;  
   
end fn_pa_nueva_mora;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_carga(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
lc_hostname varchar2(64);
  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
  
  ld_finmes := last_Day(pd_fecpro);
 
    --2016.03.18 copiar a historico
    insert into jaql592(
      JAQL592CODANA,JAQL592MES,JAQL592METSDO,JAQL592METCLI,JAQL592ANIO,JAQL592AGE,
      JAQL592FEC,JAQL592ZON,JAQL592EST,JAQL592FPRO)
    select JAQL590CODANA,JAQL590MES,JAQL590METSDO,JAQL590METCLI,JAQL590ANIO,JAQL590AGE,
           JAQL590FEC,JAQL590ZON,JAQL590EST , trunc(sysdate)
      from jaql590;
    
    delete from jaql590;
    commit;
    


 

  if pd_fecpro <> ld_finmes then

    begin
      pq_cr_productividad_ana.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
    end;  
    

    --- 
    
    
    ---carga diaria
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_productividad_ana.sp_cr_carga_datos_diario('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
            IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
--                        instance => 2, --SE CAMBIO : 2-produccion  1-desa2  03.02.2015
                        instance => 2,
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
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          
    
  else
  
  
    begin
      -- Call the procedure
      pq_cr_productividad_ana.sp_cr_inserta_agencia(pd_fecpro => pd_fecpro);
    end;
  
  
  
    ---carga mensual
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_productividad_ana.sp_cr_carga_datos('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2, --SE CAMBIO  2:produccion   1- desa2 03.02.2015
                        force => false
                        );
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          

  end if;  


end sp_cr_job_carga;
 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonomes50_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonomes50_jaql585
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonmes number;

  begin
      begin
            select jaql585mm50 --bono mes 50
              into ln_bonmes
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonmes := 0;                  
         end;
  
    return ln_bonmes;

  end fn_cr_bonomes50_jaql585;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonomes30_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonomes30_jaql585
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonmes number;

  begin
      begin
            select jaql585mm30 --bono mes 30
              into ln_bonmes
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonmes := 0;                  
         end;
  
    return ln_bonmes;

  end fn_cr_bonomes30_jaql585;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonoanu50_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonoanu50_jaql585
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonanu number;

  begin
      begin
            select jaql585ma50 --bono anual 50
              into ln_bonanu
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonanu := 0;                  
         end;
  
    return ln_bonanu;

  end fn_cr_bonoanu50_jaql585;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonoanu30_jaql585(pc_tiagel IN char,
                             pc_Tipage IN char,
                             pc_Tipcla IN char              
                             ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonoanu30_jaql585
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_bonanu number;

  begin
      begin
            select jaql585ma30 --bono mes 30
              into ln_bonanu
              from jaql585
             where jaql585tage = pc_tiagel --E/N/O
               and jaql585age = pc_Tipage  --1-2
               and jaql585c5030 = pc_tipcla -- U...Z
               and jaql585est = 'S'  ;
         exception when no_data_found then 
              ln_bonanu := 0;                  
         end;
  
    return ln_bonanu;

  end fn_cr_bonoanu30_jaql585;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonoclia_jaql581(pc_tiagel IN char,
                                 pc_claana IN char             
                                 ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonoclia_jaql581
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_porcentaje number;

  begin
       begin
            select jaql581clia
              into ln_porcentaje --porcentaje anual
              from jaql581
             where jaql581cage = pc_tiagel
               and jaql581tase = pc_claana
               and jaql581est = 'S';
          exception
            when no_data_found then
              ln_porcentaje := 0;
          end;
  
    return ln_porcentaje;

  end fn_cr_bonoclia_jaql581;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_bonoclim_jaql581(pc_tiagel IN char,
                                 pc_claana IN char             
                                 ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_bonoclim_jaql581
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : Retorna bono mensual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_porcentaje number;

  begin
      begin
            select jaql581clim
              into ln_porcentaje --porcentaje mensual
              from jaql581
             where jaql581cage = pc_tiagel
               and jaql581tase = pc_claana
               and jaql581est = 'S';
          exception
            when no_data_found then
              ln_porcentaje := 0;
          end;
  
    return ln_porcentaje;

  end fn_cr_bonoclim_jaql581;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_Sal_otorgado_Tabla(pc_analista IN varchar2,pd_fecpro in date ) return number is
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
    ln_saloto number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
      begin
       
         select /*+parallel(a,2) parallel(c,2) */ 
        --  /*+index_ss(a)  parallel(a,2) parallel(b,2) */
          sum(c.Jaql965sdmn)--, count(distinct bccta),sng095_201404asnu 
          into ln_saloto
          from JAQL969 a,  JAQL965 c 
         where JAQL969FECH between ld_fecini and pd_fecpro
           and  trim(a.Jaql969aseo) = trim(pc_analista)
           and a.jaql969inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200
           AND c.Jaql965inst NOT IN 
               (select aa.sng095inst
              from sng095 aa, SNGAS2 bb, JAQL965 cc 
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095asan
               and bb.sngas2usr = pc_analista
               and aa.sng095inst = cc.Jaql965inst
               and cc.jaql965fech = pd_fecpro
               and cc.jaql965mod <> 200);
       exception when no_data_found then
           ln_saloto := 0;          
       end;    
          /*group by sng095_201404asnu*/
    return ln_saloto;

  end fn_pa_Sal_otorgado_tabla;
  
  Function fn_pa_Cli_otorgado_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_clioto number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');

      begin 
        select /*+parallel(a,2) parallel(c,2) */ 
--        /*+index_ss(a)  parallel(a,2) parallel(b,2) */
         count(distinct C.JAQL965CTA)
          into ln_clioto
          from JAQL969 a,  JAQL965 c 
         where JAQL969FECH between ld_fecini and pd_fecpro
           and trim(a.Jaql969aseo) = trim(pc_analista)
           and a.jaql969inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200
           AND c.Jaql965inst NOT IN 
               (select aa.sng095inst
              from sng095 aa, SNGAS2 bb, JAQL965 cc 
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095asan
               and bb.sngas2usr = pc_analista
               and aa.sng095inst = cc.Jaql965inst
               and cc.jaql965fech = pd_fecpro
               and cc.jaql965mod <> 200);         
        exception when no_data_found then
              ln_clioto := 0;          
       end;     
          
    return ln_clioto;

  end fn_pa_Cli_otorgado_tabla;
  
  Function fn_pa_Sal_recibido_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_salrec number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_salrec := 0;
       begin
        select /*+parallel(a,2) parallel(c,2) */ 
        --  /*+index_ss(a)  parallel(a,2) parallel(b,2) */
          sum(c.Jaql965sdmn)--, count(distinct bccta),sng095_201404asnu 
          into ln_salrec
          from JAQL969 a,  JAQL965 c 
         where JAQL969FECH between ld_fecini and pd_fecpro
           and trim(a.Jaql969ased) = trim(pc_analista)
           and a.jaql969inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200
            AND c.Jaql965inst NOT IN 
               (select aa.sng095inst
              from sng095 aa, SNGAS2 bb, JAQL965 cc 
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095asnu
               and bb.sngas2usr = pc_analista
               and aa.sng095inst = cc.Jaql965inst
               and cc.jaql965fech = pd_fecpro
               and cc.jaql965mod <> 200); 
         exception when no_data_found then
              ln_salrec := 0;    
       end;    
    return ln_salrec;

  end fn_pa_Sal_recibido_tabla;
  
  
  Function fn_pa_Cli_recibido_tabla(pc_analista IN varchar2,pd_fecpro in date ) return number is
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
    ln_clirec number;   
    ld_fecini date;    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       ln_clirec := 0;
       begin
        select /*+parallel(a,2) parallel(c,2) */ 
        count(distinct C.JAQL965CTA)
          into ln_clirec
           from JAQL969 a,  JAQL965 c 
         where JAQL969FECH between ld_fecini and pd_fecpro
           and trim(a.Jaql969ased) = trim(pc_analista)
           and a.jaql969inst = c.Jaql965inst
           and c.jaql965fech = pd_fecpro
           and c.jaql965mod <> 200
            AND c.Jaql965inst NOT IN 
               (select aa.sng095inst
              from sng095 aa, SNGAS2 bb, JAQL965 cc 
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095asnu
               and bb.sngas2usr = pc_analista
               and aa.sng095inst = cc.Jaql965inst
               and cc.jaql965fech = pd_fecpro
               and cc.jaql965mod <> 200); 
       exception when no_data_found then
           ln_clirec := 0;      
       end;           
          /*group by sng095_201404asnu*/
    return ln_clirec;

  end fn_pa_Cli_recibido_tabla;

/*Function fn_pa_Sal_otorgadoF(pc_analista IN varchar2,pd_fecpro in date )return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    cursor sal_otorgado(ld_fecini in date) is

      select  \*+choose*\
          --xwfempresa, xwfsucursal,  xwfmodulo, xwfmoneda, xwfpapel, xwfcuenta, xwfoperacion, xwfsubope, xwftipope,
          a.sng095inst, a.sng095fec, a.sng095saldo, a.sng095cta
          from sng095 a, SNGAS2 b
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asan
           and TRIM(b.sngas2usr) = TRIM(pc_analista)
       UNION
       select \*+parallel(a,2) *\
              a.jaql969inst, JAQL969FECH,JAQL969SDMN ,JAQL969CTA
              from JAQL969 a 
             where JAQL969FECH between ld_fecini and pd_fecpro
               and trim(a.Jaql969aseo) = trim(pc_analista);

    
 
    ln_saloto number:= 0;   
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldo  number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
    select --x.instancia, x.fecha, saldo, cuenta
     sum(saldo)
      into ln_saltot
      from (select \*+first_rows parallel(a,2,1)*\
             a.sng095inst  INSTANCIA,
             a.sng095fec   fecha,
             a.sng095saldo saldo,
             a.sng095cta   cuenta
              from sng095_201403 a, SNGAS2_201403 b
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095ASAN
               and b.sngas2usr = rpad(pc_analista, 10, ' ')
            UNION all
            select \*+parallel(a,2,1)*\
             a.jaql969inst INSTANCIA,
             JAQL969FECH   fecha,
             JAQL969SDMN   saldo,
             JAQL969CTA    cuenta
              from JAQL969 a
             where JAQL969FECH between ld_fecini and pd_fecpro
               and a.Jaql969aseO = rpad(pc_analista, 10, ' ')) x,
           
           (select instancia, max(fecha) fecha
              from (select \*+first_rows parallel(a,2,1)*\
                     a.sng095inst  INSTANCIA,
                     a.sng095fec   fecha,
                     a.sng095saldo saldo,
                     a.sng095cta   cuenta
                      from sng095_201403 a, SNGAS2_201403 b
                     where sng095fec between ld_fecini and pd_fecpro
                       and sngas2pgc = 1
                       and sngas2cod = sng095ASAN
                       and b.sngas2usr = rpad(pc_analista, 10, ' ')
                    UNION all
                    select \*+parallel(a,2,1)*\
                     a.jaql969inst INSTANCIA,
                     JAQL969FECH   fecha,
                     JAQL969SDMN   saldo,
                     JAQL969CTA    cuenta
                      from JAQL969 a
                     where JAQL969FECH between ld_fecini and pd_fecpro
                       and a.Jaql969aseO = rpad(pc_analista, 10, ' '))
             group by instancia) y
     where x.instancia = y.instancia
       and x.fecha = y.fecha;
       
       return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_OtorgadoF;
*/  

/*Function fn_pa_Sal_recibidoF(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    cursor sal_otorgado(ld_fecini in date) is
     select  \*+choose*\
              a.sng095inst INSTANCIA, a.sng095fec fecha, a.sng095saldo saldo, a.sng095cta cuenta
              from sng095_201403 a, SNGAS2_201403 b
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095ASNU
               and TRIM(b.sngas2usr) = TRIM(pc_analista)
           UNION
           select \*+parallel(a,2) *\
                  a.jaql969inst INSTANCIA, JAQL969FECH fecha ,JAQL969SDMN saldo,JAQL969CTA cuenta
                  from JAQL969 a 
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and trim(a.Jaql969aseD) = TRIM(pc_analista)
    ORDER BY instancia, fecha  ;
    
    ln_saloto number := 0;   
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldo  number;
    ln_instancia number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
   select --x.instancia, x.fecha, saldo, cuenta
     sum(saldo)
     into ln_saltot
     from (select \*+first_rows parallel(a,2,1)*\
            a.sng095inst  INSTANCIA,
            a.sng095fec   fecha,
            a.sng095saldo saldo,
            a.sng095cta   cuenta
             from sng095_201403 a, SNGAS2_201403 b
            where sng095fec between ld_fecini and pd_fecpro
              and sngas2pgc = 1
              and sngas2cod = sng095ASNU
              and b.sngas2usr = rpad(pc_analista, 10, ' ')
           UNION all
           select \*+parallel(a,2,1)*\
            a.jaql969inst INSTANCIA,
            JAQL969FECH   fecha,
            JAQL969SDMN   saldo,
            JAQL969CTA    cuenta
             from JAQL969 a
            where JAQL969FECH between ld_fecini and pd_fecpro
              and a.Jaql969aseD = rpad(pc_analista, 10, ' ')) x,
          
          (select instancia, max(fecha) fecha
             from (select \*+first_rows parallel(a,2,1)*\
                    a.sng095inst  INSTANCIA,
                    a.sng095fec   fecha,
                    a.sng095saldo saldo,
                    a.sng095cta   cuenta
                     from sng095_201403 a, SNGAS2_201403 b
                    where sng095fec between ld_fecini and pd_fecpro
                      and sngas2pgc = 1
                      and sngas2cod = sng095ASNU
                      and b.sngas2usr = rpad(pc_analista, 10, ' ')
                   UNION all
                   select \*+parallel(a,2,1)*\
                    a.jaql969inst INSTANCIA,
                    JAQL969FECH   fecha,
                    JAQL969SDMN   saldo,
                    JAQL969CTA    cuenta
                     from JAQL969 a
                    where JAQL969FECH between ld_fecini and pd_fecpro
                      and a.Jaql969aseD = rpad(pc_analista, 10, ' '))
            group by instancia) y
    where x.instancia = y.instancia
      and x.fecha = y.fecha;
      
--ORDER BY instancia, x.fecha
       
       
       return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_recibidoF;  
*//*
Function fn_pa_Cli_otorgadoF(pc_analista IN varchar2,pd_fecpro in date )return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_clioto number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
       
       select count(distinct cuenta) 
       into ln_clioto
       from (
           select  \*+choose*\a.sng095cta cuenta
            from sng095_201403 a, SNGAS2 b
           where sng095fec between ld_fecini and pd_fecpro
             and sngas2pgc = 1
             and sngas2cod = sng095asan
             and b.sngas2usr = pc_analista
          union
             select \*+parallel(a,2) *\
                     JAQL969cta cuenta
                from JAQL969 a 
               where JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969aseo) = trim(pc_analista)
              );
                 
   return ln_clioto;
 
end fn_pa_Cli_otorgadoF;
  

Function fn_pa_Cli_recibidoF(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_clioto number:= 0;   
 
    ld_fecini date; 
    ld_fecha  date;  
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
      
       select count(distinct cuenta) 
       into ln_clioto
       from (
           select  \*+choose*\a.sng095cta cuenta
            from sng095_201403 a, SNGAS2_201403 b
           where sng095fec between ld_fecini and pd_fecpro
             and sngas2pgc = 1
             and sngas2cod = sng095asnu
             and b.sngas2usr = pc_analista
          union
             select \*+parallel(a,2) *\
                     JAQL969cta cuenta
                from JAQL969 a 
               where JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969ased) = trim(pc_analista)
              );
                 
        return ln_clioto;
  
  
 
  end fn_pa_Cli_recibidoF;  
  */
/*Function fn_pa_Sal_otorgadoTOT(pc_analista IN varchar2,pd_fecpro in date )return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    cursor sal_otorgado(ld_fecini in date) is
\*      select  \*+choose*\
          xwfempresa, xwfsucursal,  xwfmodulo, xwfmoneda, xwfpapel, xwfcuenta, xwfoperacion, xwfsubope, xwftipope,
          a.sng095_201404inst, a.sng095_201404fec, f.aosuc, f.aosbop, f.aotope, b.sngas2usr
          from sng095_201404 a, SNGAS2 b,  xwf700 x, fsd010 f 
         where sng095_201404fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095_201404asnu
           and b.sngas2usr = pc_analista
           and x.xwfprcins = a.sng095_201404inst
           and x.xwfcar3 = '1'
           and xwfmoneda <> '141'
           and f.PGCOD = x.xwfempresa 
           and f.AOMOD = x.xwfmodulo 
           and f.AOMDA = x.xwfmoneda
           and f.AOPAP = x.xwfpapel
           and f.AOCTA = x.xwfcuenta
           and f.AOOPER = x.xwfoperacion;*\

      select  \*+choose*\
          --xwfempresa, xwfsucursal,  xwfmodulo, xwfmoneda, xwfpapel, xwfcuenta, xwfoperacion, xwfsubope, xwftipope,
          a.sng095inst, a.sng095fec, a.sng095saldo, a.sng095cta
          from sng095_201403 a, SNGAS2_201403 b
         where sng095fec between ld_fecini and pd_fecpro
           and sngas2pgc = 1
           and sngas2cod = sng095asan
           and TRIM(b.sngas2usr) = TRIM(pc_analista)
       UNION
       select \*+parallel(a,2) *\
              a.jaql969inst, JAQL969FECH,JAQL969SDMN ,JAQL969CTA
              from JAQL969 a 
             where JAQL969FECH between ld_fecini and pd_fecpro
               and trim(a.Jaql969aseo) = trim(pc_analista);

    
 
    ln_saloto number:= 0;   
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldo  number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
    select --x.instancia, x.fecha, saldo, cuenta
     sum(saldo)
      into ln_saltot
      from (select \*+first_rows parallel(a,2,1)*\
             a.sng095inst  INSTANCIA,
             a.sng095fec   fecha,
             a.sng095saldo saldo,
             a.sng095cta   cuenta
              from sng095_201403 a, SNGAS2_201403 b
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095ASAN
               and b.sngas2usr = rpad(pc_analista, 10, ' ')
            UNION all
            select \*+parallel(a,2,1)*\
             a.jaql969inst INSTANCIA,
             JAQL969FECH   fecha,
             JAQL969SDMN   saldo,
             JAQL969CTA    cuenta
              from JAQL969 a
             where JAQL969FECH between ld_fecini and pd_fecpro
               and a.Jaql969aseO = rpad(pc_analista, 10, ' ')) ;
           
           
       
       return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_OtorgadoTOT;
*/  

/*Function fn_pa_Sal_recibidoTOT(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    cursor sal_otorgado(ld_fecini in date) is
     select  \*+parallel(a,2) (b,2)*\
              a.sng095inst INSTANCIA, a.sng095fec fecha, a.sng095saldo saldo, a.sng095cta cuenta
              from sng095_201403 a, SNGAS2_201403 b
             where sng095fec between ld_fecini and pd_fecpro
               and sngas2pgc = 1
               and sngas2cod = sng095ASNU
               and TRIM(b.sngas2usr) = TRIM(pc_analista)
           UNION
           select \*+parallel(a,2) *\
                  a.jaql969inst INSTANCIA, JAQL969FECH fecha ,JAQL969SDMN saldo,JAQL969CTA cuenta
                  from JAQL969 a 
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and trim(a.Jaql969aseD) = TRIM(pc_analista)
    ORDER BY instancia, fecha  ;
    
    ln_saloto number := 0;   
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldo  number;
    ln_instancia number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
   select --x.instancia, x.fecha, saldo, cuenta
     sum(saldo)
     into ln_saltot
     from (select \*+first_rows parallel(a,2,1)*\
            a.sng095inst  INSTANCIA,
            a.sng095fec   fecha,
            a.sng095saldo saldo,
            a.sng095cta   cuenta
             from sng095_201403 a, SNGAS2_201403 b
            where sng095fec between ld_fecini and pd_fecpro
              and sngas2pgc = 1
              and sngas2cod = sng095ASNU
              and b.sngas2usr = rpad(pc_analista, 10, ' ')
           UNION all
           select \*+parallel(a,2,1)*\
            a.jaql969inst INSTANCIA,
            JAQL969FECH   fecha,
            JAQL969SDMN   saldo,
            JAQL969CTA    cuenta
             from JAQL969 a
            where JAQL969FECH between ld_fecini and pd_fecpro
              and a.Jaql969aseD = rpad(pc_analista, 10, ' ')) ;
      
       
       return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_recibidoTOT;    
*/  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_saldo_legal(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- *****************************************************************

  ln_salmor number; 
        
  begin
         
      begin      
        select /*+parallel(j,2) */sum(case
                            when j.JAQL965DATR > 15 and j.JAQL965MOD not in (200, 33) then
                             j.JAQL965SDMN 
                            else
                             0
                          end)
          into ln_salmor             
          from JAQL965 j
         where j.jaql965fech = pd_fecpro
           and trim(j.JAQL965ASE) = trim(pc_analista)
           and j.JAQL965MOD not in (108,200,33)
           AND J.JAQL965STAT IN (21,22,23,25,33,34) --agrego estado refinanciado judicial --34-08Jul2015
           and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
                    
    exception 
      when others then 
       ln_salmor := 0;
    end;
        
  
    return nvl(ln_salmor,0);  
   
  end fn_pa_saldo_legal;  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_num_saldo_legal(pc_analista IN varchar2,pd_fecpro in date) return number is
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
    -- *****************************************************************

  ln_salmor number; 
        
  begin
         
      begin      
        select /*+parallel(j,2) */--count(j.jaql965cta)  
         count(distinct j.jaql965ndoc) --
          into ln_salmor             
          from JAQL965 j
         where j.jaql965fech = pd_fecpro
           and trim(j.JAQL965ASE) = trim(pc_analista)
           and j.JAQL965MOD not in (108,200,33)
           AND J.JAQL965STAT IN (21,22,23,25,33,34)------08Jul2015 ---se añadió  33 y 34
           and (case when j.JAQL965MOD = 106 and j.JAQL965TOP = 30 then 0 else 1 end) = 1;
                    
    exception 
      when others then 
       ln_salmor := 0;
    end;
        
  
    return nvl(ln_salmor,0);  
   
  end fn_pa_num_saldo_legal;  

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_recalculo( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


cursor creditos( ld_fecpro date) is

select jaql583usu usuario, TRIM(jaql583usu) jaql583usu,jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
jaql583ncl,jaql583sdm,jaql583pmra,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583pcod,jaql583age,
jaql583tusu,jaql583tage,jaql583tmet,jaql583crsa,jaql583crcl,jaql583crma,jaql583cran,jaql583crme,jaql583crca,
jaql583crcm,jaql583ppla,jaql583pplm,jaql583ppca,jaql583ppcm,jaql583ppcn,jaql583sant,jaql583cant,jaql583smax,
jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,
jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,
jaql583sdc1,jaql583tase,jaql583bplu,jaql583bmet,jaql583c5030,jaql583lage,jaql583texme,jaql583texan,jaql583exme,
jaql583exan,jaql583pjcm,jaql583pjca,jaql583pjcas,jaql583cltot,jaql583sdtot,jaql583totpa,jaql583fmo,jaql583umo,
jaql583nexm,jaql583nexa,jaql583cexa,jaql583cexm
  from jaql583
 where jaql583fpro = ld_fecpro
   and jaql583mant < 6
   ;--and TRIM(jaql583usu) = 'LMOSCOSO';
 

 lc_Tipo_analista jaql577.jaql577tipo%type;
 ln_metasal number := 0;
 ln_metacli number := 0;
 ln_metamor number := 0;
 lc_tipage jaql570.jaql570age%type;
 ln_calcli jaql570.jaql570tipo%type;
 ln_calsal jaql570.jaql570tipo%type;
 ln_nummes number:=0;
 ln_numdia number:=0;
 lc_5030 char(4);
 lc_cmesal number := 0;
 lc_cmecli number := 0;      
 
 ln_Saldo_Otorgado number;
 ln_Saldo_Recibido number;
 ln_Cliente_Otorgado number;
 ln_Cliente_recibido number;
 ln_Por_Mora  number;
 ln_Clientes_Nuevos  number;
 ln_sal_cre_mes_anterior number;
 ln_Nro_cli_mes_anterior number;
 ln_Sal_maximo  number;
 ln_Cli_maximo  number;
 ln_Fec_CliMax  date;
 ln_Fec_SalMax   date;
 lc_Tipo_ana varchar2(4);
 lc_Tipo_agencia varchar2(4);
 ln_saltot  number;
 ln_clitot  number;
 ln_salmor number;
 ln_saljud number;
 ln_cont NUMBER;
 ln_salcas number;
 ln_salrec number; 
 ln_numrec number; 
 ln_saldoi number;
 ln_numcli number;
 
 
begin

   for i in creditos( pd_fecpro) loop
   
       --inserta JAQL583
       
       /*ln_Saldo_Otorgado :=  nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgado(i.jaql965ase,pd_fecpro),0); 
       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibido(i.jaql965ase,pd_fecpro),0); 
       ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgado(i.jaql965ase,pd_fecpro),0); 
       ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibido(i.jaql965ase,pd_fecpro),0); 
       */
--20140307       ln_Saldo_Otorgado :=  nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoF(i.jaql965ase,pd_fecpro),0); 
--20140307       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoF(i.jaql965ase,pd_fecpro),0); 
       --ln_Saldo_Otorgado :=  nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoTOT(i.jaql583usu,pd_fecpro),0); 
       --ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoTOT(i.jaql583usu,pd_fecpro),0); 
----revisar traslados

       --ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgadoF(i.jaql583usu,pd_fecpro),0); 
       --ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibidoF(i.jaql583usu,pd_fecpro),0);
       
       --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora_ini (i.jaql965ase,pd_fecpro,i.agencia, ln_salmor);
       --ln_Clientes_Nuevos := pq_cr_productividad_ana.fn_pa_cliente_new (i.jaql965ase,pd_fecpro); 
       --ln_sal_cre_mes_anterior := pq_cr_productividad_ana.fn_cr_saldo_anterior(i.jaql965ase, pd_fecpro); 
       --ln_Nro_cli_mes_anterior := pq_cr_productividad_ana.fn_cr_nrocli_anterior(i.jaql965ase, pd_fecpro);   
       --ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro);    
       --ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro);  
       --ln_Fec_CliMax := pq_cr_productividad_ana.fn_cr_fecha_cli_mes_base(i.jaql965ase, pd_fecpro);
       --ln_Fec_SalMax  := pq_cr_productividad_ana.fn_cr_fecha_sal_mes_base(i.jaql965ase, pd_fecpro);                                                  
       --lc_Tipo_agencia := pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(i.agencia/*i.jaql965suc*/,pd_fecpro); 

      
       lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista_cal(i.jaql583usu,pd_fecpro);
       
       
           ln_saljud := pq_cr_productividad_ana.fn_cr_sal_judicial(i.jaql583usu,pd_fecpro);
           ln_salmor := pq_cr_productividad_ana.fn_pa_saldo_mora(i.jaql583usu,pd_fecpro); --saldo mora  > 15 dias
           ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(i.jaql583usu,pd_fecpro);
           
           --ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora (i.jaql583usu,pd_fecpro,i.jaql583age, ln_salmor, i.jaql583sdo, ln_saljud);
                                                            
            
            
             --lc_tipage := pq_cr_productividad_ana.fn_cr_tipo_agencia(i.agencia/*i.jaql965suc*/);
                    
             
          /*if  ln_nummes < 6 then*/
              ---2014.03.13 --SI ES MENOR A 6 MESES NO CONSIDERAR SALDO MORA DE RECUPERACION LEGAL
               ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(i.jaql583usu,pd_fecpro); --saldo de creditos en recuperacion legal
               ln_numrec := pq_cr_productividad_ana.fn_pa_num_saldo_legal(i.jaql583usu,pd_fecpro); --saldo de creditos en recuperacion legal
               ln_salmor := ln_salmor - ln_salrec;
              ---
               ln_saltot := i.jaql583sdo + i.jaql583soto - i.jaql583srec - ln_salrec; 
               ln_clitot := i.jaql583ncl + i.jaql583cot - i.jaql583crec - ln_numrec;
          
             
               ln_saldoi := i.jaql583sdo - ln_salrec;
               ln_numcli := i.jaql583ncl - ln_numrec;
               
               ln_calcli := pq_cr_productividad_ana.fn_cr_cliente_cali(i.jaql583lage, ln_numcli );
               ln_calsal := pq_cr_productividad_ana.fn_cr_credito_cali(i.jaql583lage, ln_saldoi);
             
               lc_5030 := pq_cr_productividad_ana.fn_cr_tipo_analista(i.jaql583tage,i.jaql583lage, ln_numcli );
     
                
             --lc_Tipo_analista := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,lc_Tipo_agencia,i.Saldo_cartera);           
               lc_Tipo_analista := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,i.jaql583tage,ln_saldoi/*i.jaql583sdo*/);
               ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(lc_Tipo_ana,i.jaql583tage,lc_Tipo_analista, i.jaql583age);
               ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(lc_Tipo_ana,i.jaql583tage,lc_Tipo_analista, i.jaql583age);
               ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(lc_Tipo_ana,i.jaql583tage,lc_Tipo_analista, i.jaql583age);

            
              update jaql583
                 set jaql583sdo = ln_saldoi,--i.jaql583sdo - ln_salrec,
                     jaql583ncl = ln_numcli,--i.jaql583ncl - ln_numrec,
                     jaql583sdtot = ln_saltot,
                     jaql583cltot = ln_clitot,
                     jaql583sdm = ln_salmor,--i.jaql583sdm - ln_salrec
                     jaql583tusu = lc_Tipo_analista,
                     jaql583mtsa = ln_metasal, 
                     jaql583mtcl = ln_metacli, 
                     jaql583mtmr = ln_metamor,
                     jaql583c5030 = lc_5030,
                     /*jaql583sant = i.jaql583sant - ln_salrec,
                     jaql583cant = i.jaql583cant - ln_numrec,
                     jaql583smax = i.jaql583smax - ln_salrec,
                     jaql583cmax = i.jaql583cmax - ln_numrec,*/
                      
                     jaql583est = 'R'
               where jaql583usu = i.usuario
                and  jaql583fpro =  pd_fecpro;
             
                
           commit; 
           
            --inserta JAQL572

             
           --lc_cmesal := (i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido ) - ln_sal_cre_mes_anterior; -- crecimiento mensual saldo
           --lc_cmecli := (i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido ) - ln_Nro_cli_mes_anterior;  --crecimiento mensual clientes
            
           lc_cmesal := ln_saltot - i.jaql583sant - ln_salrec; -- crecimiento mensual saldo
           lc_cmecli := ln_clitot - i.jaql583ncl - ln_salrec; --crecimiento mensual clientes 
           
   
           
           update jaql572
                 set JAQL572scre = ln_saldoi,
                     jaql572ncli = ln_numcli,
                     jaql572cme  = lc_cmesal,
                     jaql572cmcl = lc_cmecli,
                     jaql572ccli = trim(ln_calcli),
                     jaql572csal = trim(ln_calsal),
                     jaql572sant = i.jaql583sant - ln_salrec, --solo diciembre
                     jaql572ncl = i.jaql583cant - ln_numrec,  --solo diciembre                        
                     jaql572est = 'R'             
               where jaql572usu = i.usuario
                 and jaql572fpro = pd_fecpro;
           
          
           commit; 
           
       /*else
           ln_saltot := i.jaql583sdo + i.jaql583soto - i.jaql583srec; 
           ln_clitot := i.jaql583ncl + i.jaql583cot - i.jaql583crec;

         
     end if;*/
     
     
   
   end loop;  
--   commit; 
 
 end sp_cr_recalculo;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_tip_analista_cal(pc_analista IN CHAR,pd_fecpro in date ) return char is
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
    lc_calcli char(2);
    cursor saldo is
      select /*+all_rows */
       decode(JAQL965MOD, 107, 107, 100) modulo, sum(JAQL965SDMN) saldo
        from JAQL965
       where JAQL965FECH = pd_fecpro
         and TRIM(JAQL965ASE) = /*TRIM*/(pc_analista)
         and JAQL965ASE = pc_analista
         and JAQL965MOD not in (108, 33, 200)
         and --(JAQL965MOD <> 106 Or JAQL965TOP <> 30)
         (case when JAQL965MOD = 106 and JAQL965TOP = 30 then 0 else 1 end) = 1
          AND JAQL965STAT not IN (21,22,23,25) --no considerar para menores de 6 meses
       group by decode(JAQL965MOD, 107, 107, 100);
       
  lc_tipana char(1);
  ln_saldo number;       
  begin
       ln_saldo := 0;
       for i in saldo loop
          if  i.saldo > ln_saldo  then   
             if i.modulo = 107 then
                lc_tipana := 'C';
             else
                lc_tipana := 'P';    
             end if;
          else
             if i.modulo = 107 then
                lc_tipana := 'P';
             else
                lc_tipana := 'C';    
             end if;
          end if;   
          ln_saldo := i.saldo;
       end loop;
    if ln_saldo = 0 then --2014.03.14 si analista no tiene saldo le corresponde clasificacion PYMES
       lc_tipana := 'P'; 
    end if;   
    return lc_tipana;

  end fn_pa_tip_analista_cal;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_recal_mantenimiento(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_bono_mantenimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono por saldo y cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    cursor mantenimiento(ld_fecpro date, lc_analista char) is
       select jaql572usu, jaql572fpro, jaql572csal, jaql572ccli , jaql572scre, jaql572ncli,
              jaql572cmcl, jaql572cme, jaql572tage, jaql572bsal, jaql572bcli
        from jaql572 where jaql572fpro = ld_fecpro
        -- and jaql572est = 'R' ----------------------------->>>>>ojo solo para el recalculo
         and jaql572usu like '%'||lc_analista||'%';
         -- and jaql572usu like lc_analista;
           --and jaql572usu in ('CFRANCO','WFERNANDEZ'); 
          -- and (jaql572cmcl > 0 or jaql572cme > 0);

--  ld_fecpro date := to_Date('2013.06.30','yyyy.mm.dd');
  ln_bonosaldo number:= 0;
  ln_bonocli number:= 0;

lc_analista varchar2(10):= null;
ln_Por_Mora number:=0;
ln_bono_sal number:=0; 
ln_bono_cli number:=0; 
ln_castigo_mantenimiento number:=0;
ln_castigo number:=0;
lc_tase char(3);
lc_tage char(3);
lc_tusu char(3);




begin

 if pc_analista is null then
    lc_analista := '%';
 else
    lc_analista := pc_analista;    
 end if;



--ld_fecpro := to_Date('2013.06.30','yyyy.mm.dd');

 for i in mantenimiento(pd_fecpro, lc_analista) loop
 

     --bono saldo  Crecimiento mensual saldo > 0
     if i.jaql572cme >= 0 then ---se modifico solicitud Karlos Malaga
       begin
          select jaql571bono
            into ln_bonosaldo 
            from jaql571
           where jaql571tipo = i.jaql572csal--clasificacion saldo
             and jaql571age = i.jaql572tage--tipo agencia
             and i.jaql572scre >= jaql571sdmi
             and i.jaql572scre <= jaql571sdma
             and jaql571est = 'S';
       exception when others then 
           ln_bonosaldo := 0;
       end;
     end if; 
     
     
     --bono clientes Crecimiento mensual clientes> 0
     if i.jaql572cmcl >= 0 then ---se modifico solicitud Karlos Malaga
       begin
          select jaql570bono
            into ln_bonocli 
            from jaql570
           where jaql570tipo = i.jaql572ccli--clasificacion cliente
             and jaql570age = i.jaql572tage--tipo agencia
             and i.jaql572ncli >= jaql570clmi
             and i.jaql572ncli <= jaql570clma
             and jaql570est = 'S';
             
       exception when others then 
           ln_bonocli := 0;
       end;
       
     
     end if; 
 
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
     
     begin
        select j.jaql583pmra , j.jaql583tase,j.jaql583tage, j.jaql583tusu
          into ln_Por_Mora , lc_tase, lc_tage, lc_tusu
          from jaql583 j
         where j.jaql583usu = i.jaql572usu  
           and j.jaql583fpro =  pd_fecpro;       
     end;
     
     
     begin
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = lc_tase--i.jaql583tase
          and jaql595tiag = lc_tage--i.jaql583tage
          and jaql595cla  = lc_tusu--i.jaql583tusu
          and ln_Por_Mora > jaql595min
          and ln_Por_Mora <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;
    
     
     
   /*   begin
        pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                       pd_fecpro => pd_fecpro,
                                                       pn_bono_sal => ln_bono_sal,
                                                       pn_bono_cli => ln_bono_cli);
      end;
      ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);*/
      ln_castigo_mantenimiento := nvl((ln_bonosaldo + ln_bonocli )  * ln_castigo/100, 0);
           
            
      update jaql572
         set jaql572btot = (ln_bonosaldo + ln_bonocli + ln_castigo_mantenimiento) ,
             jaql572mcas =  ln_castigo_mantenimiento,
             jaql572pjcas = ln_castigo,
             jaql572bcli = ln_bonocli,
             jaql572bsal = ln_bonosaldo
       where jaql572usu  = i.jaql572usu                 
         and jaql572fpro = pd_fecpro;
            
      commit;
  
      ln_bonosaldo := 0;
      ln_bonocli := 0;
      ln_castigo_mantenimiento := 0;
      ln_castigo := 0;
    
     
 end loop;
 
end sp_cr_recal_mantenimiento;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure Sp_cr_RECAL_feb_mantenimiento(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_bono_mantenimiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono por saldo y cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    cursor mantenimiento(ld_fecpro date, lc_analista char) is
       select jaql572usu, jaql572fpro, jaql572csal, jaql572ccli , jaql572scre, jaql572ncli,
              jaql572cmcl, jaql572cme, jaql572tage,
              (jaql572scre +jaql572soto- jaql572srec) saldo,
              (jaql572ncli +jaql572coto- jaql572crec) clientes
        from jaql572 where jaql572fpro = ld_fecpro--;
        -- and jaql572est = 'R' ----------------------------->>>>>ojo solo para el recalculo
       and JAQL572MANT > 6;

--  ld_fecpro date := to_Date('2013.06.30','yyyy.mm.dd');
  ln_bonosaldo number:= 0;
  ln_bonocli number:= 0;
  ln_salmax number:=0;
  ln_climax number:= 0;

lc_analista varchar2(10):= null;

begin

 if pc_analista is null then
    lc_analista := '%';
 else
    lc_analista := pc_analista;    
 end if;



--ld_fecpro := to_Date('2013.06.30','yyyy.mm.dd');

 for i in mantenimiento(pd_fecpro, lc_analista) loop
 
/* if SUBSTR(I.jaql572usu,1,7)= 'LVALDEZ'  then
    NULL;
 END IF;*/
 
   BEGIN
     select 
         jaql583smax,jaql583cmax
         into ln_salmax, ln_climax               
         from jaql583
        where jaql583fpro = pd_fecpro
          and jaql583usu = i.jaql572usu ;
         -- and jaql583tase is not null;
   END;    
 

 
     --bono saldo  Crecimiento mensual saldo > 0
     if (i.saldo - ln_salmax ) >= 0 then ---se modifico solicitud Karlos Malaga
       begin
          select jaql571bono
            into ln_bonosaldo 
            from jaql571
           where jaql571tipo = i.jaql572csal--clasificacion saldo
             and jaql571age = i.jaql572tage--tipo agencia
             and i.jaql572scre >= jaql571sdmi
             and i.jaql572scre <= jaql571sdma
             and jaql571est = 'S';
       exception when others then 
           ln_bonosaldo := 0;
       end;
     end if; 
     
     
     --bono clientes Crecimiento mensual clientes> 0
     if  (i.clientes - ln_climax ) >= 0 then ---se modifico solicitud Karlos Malaga
       begin
          select jaql570bono
            into ln_bonocli 
            from jaql570
           where jaql570tipo = i.jaql572ccli--clasificacion cliente
             and jaql570age = i.jaql572tage--tipo agencia
             and i.jaql572ncli >= jaql570clmi
             and i.jaql572ncli <= jaql570clma
             and jaql570est = 'S';
             
       exception when others then 
           ln_bonocli := 0;
       end;
       
     
     end if; 
 
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
     --actualizar bonos
     update jaql572
        set jaql572bsal = ln_bonosaldo,
            jaql572bcli = ln_bonocli
      where jaql572usu  = i.jaql572usu                  
        and jaql572fpro = pd_fecpro;
            
            
     commit;
     ln_bonosaldo := 0;
     ln_bonocli := 0;
     
 end loop;
 
end sp_cr_RECAL_feb_mantenimiento;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_RECAL_FEB_product(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              JAQL583PPCN, JAQL583PPCA, JAQL583PPCM,
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
        --and jaql583usu like '%'||lc_analista||'%'--;
        AND JAQL583MANT > 6;      



ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
 begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
    
    --recalcular para los que tienen menos de 6 meses
    --ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(pc_analista,pd_fecpro); --saldo de creditos en recuperacion legal
    
     
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if i.jaql583saldo > 0  --saldo total > 0
        and (i.jaql583saldo - i.jaql583sant)>= i.jaql583mtsa --crecimiento mensual>= metasaldo
        then
         ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
     end if;
     
     --2--obtiene bono por cumplimiento meta cliente
     if i.jaql583cliente > 0  --clientes total > 0
        and (i.jaql583cliente - i.jaql583cant)>= i.jaql583mtcl --crecimiento mensual >= metacliente
        then
         ln_bonocli := pq_cr_productividad_ana.fn_cr_bono_cliente(i.jaql583tase);
     end if;

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= i.jaql583mtmr  --porcentaje mora >= meta mora
        then
        ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + ln_bonocli + ln_bonomora; --TOTAL BONO
     if ln_totalBONO > 500 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 500; 
     end if;
     ---
     
--- ==> PAGO VARIABLE

   
     -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583saldo - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
     
     if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
     --if ln_por_clientes >=  ln_Por_Cliente  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
     --4--crecimiento saldo ANUAL
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and ln_cre_saldoanual - i.jaql583mtsa > 0 then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
             ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
             end if;
             if ln_plussdoanu < 0 then
                ln_plussdoanu := 0;
             end if;  

     --end if;
     else --excluyentes
         
        --7--crecimiento saldo MENSUAL
        
           ---calcular PLUS
                --A-- saldo mensual
                begin
                  select jaql581sdom
                    into ln_porcentaje --porcentaje mensual saldo
                    from jaql581
                   where jaql581cage = i.jaql583tage
                     and jaql581tase = i.jaql583tase
                     and jaql581est = 'S';
                exception
                  when no_data_found then
                    ln_porcentaje := 0;
                end;
          
         --if  (ln_cre_saldoanual - i.jaql583mtsa) > 0 then 
           /*if  ln_cre_saldoanual  > 0 then
                
                --plus crecimiento * plus /100
                 ln_plussdomes := (ln_cre_saldomes - ln_cre_saldoanual )* ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;\*0.50*\
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
           else*/
                 --plus crecimiento * plus /100
                 ln_plussdomes := (ln_cre_saldomes - i.jaql583mtsa )* ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
          --end if;    
     
    end if;    
  
    ----
     --11 BONO POR CLIENTES
     -----
     --solo aplica a PMYES
     --if i.jaql583tase = 'P'  then
        
     /*     begin
            -- Call the procedure
            pq_cr_productividad_ana.sp_cr_pago_variable_cli(pc_tiagel => i.jaql583tage, --E/N/O
                                                          pc_tipage => i.jaql583lage, -- <> LIMA = 1 / LIMA = 2
                                                          pc_tipcla => i.jaql583c5030, -- U.....Z
                                                          pc_claana => i.jaql583tase, -- P Pymes / c consumo
                                                          pn_numcli => i.jaql583cliente, --clientes mes
                                                          pn_metanu => i.jaql583cmax, --meta anual = clientes base/maximo
                                                          pn_metmes => i.jaql583mtcl, --meta mes
                                                          pn_climesa => i.jaql583cant,   --cliente mes anterior                                                       
                                                          pn_porcla => ln_porcla,
                                                          pn_porclm => ln_porclm,
                                                          pn_bonanu => ln_bonanu,
                                                          pn_bonmen => ln_bonmen,
                                                          pn_totanu => ln_total_exc_anual,
                                                          pn_totmes => ln_total_exc_mes,
                                                          pn_nummes => ln_excmes,
                                                          pn_numanu => ln_excanu,
                                                          pc_indexa => lc_indexa,
                                                          pc_indexm => lc_indexm
                                                           );
          end;
        
          ln_plusclianu := ln_total_exc_anual;
          ln_plusclimes := ln_total_exc_mes;
        */ 
     --end if;            
     ---
          
     
     --9--PLUS CLIENTES NUEVOS               
     /*if ( ln_cre_clientemes - i.jaql583mtcl) >= 0 then 
      
       
         begin
          pq_cr_productividad_ana.sp_pa_clte_nuevo(pc_analista => i.jaql583usu,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_tipage => i.jaql583tage,
                                                   pn_numcli => ln_clinuevo,
                                                   pn_mtonue => ln_PLUSCLINUEVO);
         end;
      
      end if;
         */   

     
     ln_PLUSCLINUEVO := I.JAQL583PPCN; 
     ln_plusclianu := I.JAQL583PPCA;
     ln_plusclimes := I.JAQL583PPCM;
     
     
     --10 MONTO CASTIGADO
     ----------
     begin
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = i.jaql583tase
          and jaql595tiag = i.jaql583tage
          and jaql595cla  = i.jaql583tusu
          and ln_Por_Mora/*i.jaql583pmra*/ > jaql595min
          and ln_Por_Mora/*i.jaql583pmra*/ <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;
     
     
 
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + ln_plusclianu + ln_plussdomes + ln_plusclimes + ln_PLUSCLINUEVO ) * ln_castigo/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + ln_plusclianu + ln_plusclimes + ln_PLUSCLINUEVO +  ln_mtocastigo ;
     
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
    if ln_totalPlus >=0 then
        ln_totalPP := ln_totalPLUS; 
    else
        ln_totalPP := 0;
    end if;    
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bcli = ln_bonocli,
            jaql583bmra = ln_bonomora,
            jaql583cran = ln_cre_saldoanual, 
            jaql583crme = ln_cre_saldomes, 
            jaql583crca = ln_cre_clienteanual, 
            jaql583crcm = ln_cre_clientemes, 
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            jaql583ppca = ln_plusclianu, 
            jaql583ppcm = ln_plusclimes, 
            jaql583ppcn = ln_PLUSCLINUEVO,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PJCA = ln_porcla,
            JAQL583PJCM = ln_porclm,
            JAQL583EXAN = ln_bonanu,
            JAQL583EXME = ln_bonmen,
            --JAQL583TEXAN = ln_total_exc_anual, --total excedente anual
            --JAQL583TEXME = ln_total_exc_mes, --total excedente mensual
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            ---ultimos campos actualizados
            JAQL583CRSA = ln_cre_saldomes,
            JAQL583CRCL = ln_cre_clientemes,
            JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
            JAQL583NEXA = ln_excanu,
            JAQL583NEXM = ln_excmes,
            JAQL583NCN = ln_clinuevo,
            JAQL583PJCAS = ln_castigo, --porcentaje castigo
            ---
            --ultimos campos
            jaql583cexa = lc_indexa,
            jaql583cexm = lc_indexm,
            jaql583est = 'R'
            ---
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
         
      --actualiza mantenimiento CASTIGO....
      --if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                 jaql572mcas =  ln_castigo_mantenimiento,
                 jaql572pjcas = ln_castigo
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      --end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_RECAL_FEB_product;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_Traslados_jaql969( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_traslados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQL969
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.06.03
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: DCASTRO
    --                              2014.06.04 se modifico cursor se comento sdmol = 0         
    -- *****************************************************************
   
 cursor  traslados(ld_fecini in date,ld_fecfin in date) is
  select * from jaql969 
   where jaql969fech >= ld_fecini and jaql969fech <= ld_fecfin;
    --and jaql969sdmol = 0;


ln_mtomn number;
ln_mtomo number;
ln_tipcam number(14,8);
ln_modulo number(3);
ln_opera number(9);
ld_fecini date;
ld_fecfin date;
sql_stmt varchar2(100);
--pd_fecpro date := to_Date('2014.04.30','yyyy.mm.dd');

begin

  ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');       
  ld_fecfin := pd_fecpro;
  
   sql_stmt := 'delete from JAQL969 where jaql969fech >= :1 and jaql969fech <= :2 ';
   EXECUTE IMMEDIATE sql_stmt USING ld_fecini, ld_fecfin;

   commit;
   
  --inserta en jaql969
  begin
    pq_cr_productividad_ana.sp_cr_inserta_traslados(pd_fecpro => pd_fecpro);
  end;
  
 
 /*
 
  begin
    select \*cofdes, *\cotcbi
      into ln_tipcam
      from fsh005 f
     where moneda = 101
       and cofdes in (select max(cofdes) from fsh005 g
                       where g.cofdes <= ld_fecfin --to_Date('2014.04.30', 'yyyy.mm.dd')
                         and g.moneda = 101
                      );
  end;
  

 for i in traslados(ld_fecini,ld_fecfin) loop
 
  if i.jaql969mod = 117  then
       begin
         select \*+parallel (a,2) (b,2) *\c.bcmod, c.bcoper, c.bcsdmn, c.bcsdmo
           into ln_modulo, ln_opera, ln_mtomn , ln_mtomo 
           from fsr011 a, fsd010 b, fsh012  c
           where a.relcod = 46 
            and a.R2MOD  = i.jaql969mod
            and a.R2CTA  = i.jaql969cta
            and a.R2OPER = i.jaql969oper
            and a.R2SBOP = i.jaql969sbop
            and a.R2COD   = i.jaql969emp
            and a.R2SUC   = i.jaql969suc
            and a.R2MDA   = i.jaql969mda
            and a.R2PAP   = i.jaql969pap
            and a.R2TOPE = i.jaql969top
            and a.R011CO = 'S'
            and b.pgcod = a.R1COD   
            and b.aomod = a.R1MOD   
            and b.aosuc = a.R1SUC   
            and b.aomda = a.R1MDA   
            and b.aopap = a.R1PAP   
            and b.aocta = a.R1CTA   
            and b.aooper = a.R1OPER  
            and b.aosbop = a.R1SBOP  
            and b.aotope = a.R1TOPE  
            and b.aostat <> 99 
            and c.bcemp  = b.pgcod
            and c.bcsuc  = b.aosuc
            and c.bcmda  = b.aomda
            and c.bcpap  = b.aopap
            and c.bccta  = b.aocta
            and c.bcoper = b.aooper
            and c.bcsbop = b.aosbop
            and c.bctop  = b.aotope
            and c.bcfech = i.jaql969fech
            and c.bcmod  = b.aomod;
       exception
         when others then
            ln_mtomn := 0;
            ln_mtomo := 0;
            
       end;  
       
      
       --actualiza
       update jaql969 
          set jaql969modl = ln_modulo,
              jaql969opel = ln_opera,
              jaql969sdmol = ln_mtomo,
              jaql969sdmnl = ln_mtomn
        where jaql969fech = i.jaql969fech
          and jaql969mod  = i.jaql969mod
          and jaql969cta  = i.jaql969cta
          and jaql969oper = i.jaql969oper
          and jaql969sbop = i.jaql969sbop
          and jaql969emp  = i.jaql969emp
          and jaql969suc  = i.jaql969suc
          and jaql969mda  = i.jaql969mda
          and jaql969pap  = i.jaql969pap
          and jaql969top  = i.jaql969top;
   
  else
    if  i.jaql969mda = 101 then
        ln_mtomn := i.jaql969sdmo * ln_tipcam;
        
        
        update jaql969 
          set jaql969sdmn = ln_mtomn
        where jaql969fech = i.jaql969fech
          and jaql969mod  = i.jaql969mod
          and jaql969cta  = i.jaql969cta
          and jaql969oper = i.jaql969oper
          and jaql969sbop = i.jaql969sbop
          and jaql969emp  = i.jaql969emp
          and jaql969suc  = i.jaql969suc
          and jaql969mda  = i.jaql969mda
          and jaql969pap  = i.jaql969pap
          and jaql969top  = i.jaql969top;
    
    
    end if;
      
  end if;    
  commit;

  ln_mtomn := 0;
  ln_mtomo := 0;
  ln_modulo := null;
  ln_opera := null;
  
 end loop;
 
 */

 end sp_cr_Traslados_jaql969;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

 
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_traslados( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_inserta_traslados
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.04.30
    -- Autor de Creación          : 
    -- Uso                        : INSERTA TRASLADOS JAQL969
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
 ld_fecini date;
 ld_fecfin date;
 
 ln_num number := 0;
 begin
 
  ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');       
  ld_fecfin := last_Day(pd_fecpro);
  
 insert into JAQL969 
  (jaql969fech, jaql969aseo, jaql969ased, jaql969emp, jaql969mod, jaql969suc, 
  jaql969mda, jaql969pap, jaql969cta, jaql969oper, jaql969sbop, jaql969top, jaql969inst, jaql969sdmo, 
  jaql969sdmn, jaql969suor, jaql969suds, jaql969cor, jaql969mora 
  , jaql969modl, jaql969opel, jaql969sdmol, jaql969sdmnl )
  
  
/*  (select sng130fape, sng130asor, sng130asds, sng131pgc, sng131mod, sng131suc, 
  sng131mda, sng131pap, sng131cta, sng131ope, sng131sbo, sng131top,sng131inst, sng131sdo, 
  decode(sng131mda,0,sng131sdo,0) saldosoles,
  sng130suor, sng130suds, s1.sng130cor, sng131mora
    from sng130 s1, sng131 s2
   where s2.sng130cor = s1.sng130cor
     and s2.sng131pgc = s1.sng130pgc
     and sng130fape >= ld_fecini and sng130fape <= ld_fecfin
     and ((s2.sng131con = 'S' and  s2.sng131tmod > 0 ) or (sng131tmod = 0) ) 
    );*/ --Modificado 10Jul2014 10:41am
  
  (select sng130fape, sng130asor, sng130asds, n.sng131pgc, n.sng131mod, n.sng131suc, 
  n.sng131mda, n.sng131pap, n.sng131cta, n.sng131ope, n.sng131sbo, n.sng131top, sng131inst, sng131sdo, n.jaqy167sdomn,
  --decode(sng131mda,0,sng131sdo,0) saldosoles,
  sng130suor, sng130suds, s1.sng130cor, sng131mora
  ,n.jaqy167mod, n.jaqy167ope, n.jaqy167sdo, n.jaqy167sdomn ----*
    from sng130 s1, sng131 s2, jaqy167 n
   where s2.sng130cor = s1.sng130cor
     and s2.sng131pgc = s1.sng130pgc
    and sng130fape >= ld_fecini and sng130fape <= ld_fecfin
    --and sng130fape >= to_date('01.02.2014', 'dd.mm.yyyy') and sng130fape <=  to_date('28.02.2014', 'dd.mm.yyyy')
    and ((s2.sng131con = 'S' and  s2.sng131tmod > 0 ) or (sng131tmod = 0) ) 
    and s2.sng130cor = n.sng130cor
    and s2.sng131pgc = n.sng131pgc
    and s2.sng131mod = n.sng131mod
    and s2.sng131suc = n.sng131suc
    and s2.sng131mda = n.sng131mda
    and s2.sng131pap = n.sng131pap
    and s2.sng131cta = n.sng131cta
    and s2.sng131ope = n.sng131ope
    and s2.sng131sbo = n.sng131sbo
    and s2.sng131top = n.sng131top);  
      
  commit;

 end sp_cr_inserta_traslados;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_pa_Sal_recibidoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number) return number is
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
    -- *****************************************************************
  
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_instancia number;
    ln_codage number; --2016.02.08
    lc_analista char(10);--2016.02.08
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
   
    
    lc_analista := rpad(pc_analista, 10, ' ');--2016.02.08 obtiene codigo de analista
   
  
   begin
     select 
       sum(decode(jaql969mod,117,jaql969sdmnl, jaql969sdmn))
       into ln_saltot
       from JAQL969 a
       where JAQL969FECH between ld_fecini and pd_fecpro
       and a.Jaql969ASED = lc_analista --rpad(pc_analista, 10, ' ')
       ;--and a.jaql969suds = pc_codage ; --2016.02.08 saldo recibido pertenezca a la agencia del analista.
   exception when others then
        ln_saltot := 0;  
   end;     
       
     return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_recibidoNew;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_pa_Sal_OtorgadoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number) return number is
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
    -- *****************************************************************
  
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_instancia number;
    
     ln_codage number; --2016.02.08
     lc_analista char(10);--2016.02.08
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
   
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(pc_analista, 10, ' ');
    --
  
   begin   
     select 
       sum(decode(jaql969mod,117,jaql969sdmnl, jaql969sdmn))
       into ln_saltot
       from JAQL969 a
       where JAQL969FECH between ld_fecini and pd_fecpro
       and a.Jaql969ASEO = lc_analista--rpad(pc_analista, 10, ' ') 
       ;--and a.jaql969suor = pc_codage ; --2016.02.08 saldo otorgado pertenezca a la agencia del analista.;
    exception when others then
        ln_saltot := 0;
    end;    
       
     return NVL(ln_saltot,0) * -1;
 
  end fn_pa_Sal_OtorgadoNew;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_Cli_otorgadoNew(pc_analista IN varchar2,pd_fecpro in date , pc_codage in number)return number is
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
    -- *****************************************************************
    ln_clioto number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    
    ln_codage number; --2016.02.08
    lc_analista char(10);--2016.02.08
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
    
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(pc_analista, 10, ' ');
    --
  
  
       
       
       /*select count(distinct cuenta) 
       into ln_clioto
       from (
             select \*+parallel(a,2) *\
                     JAQL969cta cuenta
                from JAQL969 a 
               where JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969aseo) = trim(pc_analista)
              );*/
              
              
       select count(distinct cliente) 
       into ln_clioto
       from (
             select /*+parallel(a,2) */
                     f.pendoc cliente
                from JAQL969 a , fsr008 f
               where f.pgcod = 1 and f.ctnro = a.jaql969cta
                 and JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969aseo) = trim(pc_analista)
                 and f.ttcod = 1
                 and f.cttfir = 'T'
                 and jaql969sdmnl is not null
                 --and a.jaql969suor = pc_codage  --2016.02.08 cliente otorgado pertenezca a la agencia del analista.;
              );       
                 
   return ln_clioto;
 
end fn_pa_Cli_otorgadoNew;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_Cli_RecibidoNew(pc_analista IN varchar2,pd_fecpro in date, pc_codage in number )return number is
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
    -- *****************************************************************
    ln_clioto number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    
    ln_codage number; --2016.02.08
    lc_analista char(10);--2016.02.08
  begin
  
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');
       
       
    --2016.02.08 obtiene codigo de analista
    lc_analista := rpad(pc_analista, 10, ' ');
    --2016.02.08       
       
       /*select count(distinct cuenta) 
       into ln_clioto
       from (
             select \*+parallel(a,2) *\
                     JAQL969cta cuenta
                from JAQL969 a 
               where JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969ased) = trim(pc_analista)
              );*/
              
              
      select count(distinct cliente) 
       into ln_clioto
       from (
             select /*+parallel(a,2) */
                     f.pendoc cliente
                from JAQL969 a , fsr008 f
               where f.pgcod = 1 and f.ctnro = a.jaql969cta
                 and JAQL969FECH between ld_fecini and pd_fecpro
                 and trim(a.Jaql969ased) = trim(pc_analista)
                 and f.ttcod = 1
                 and f.cttfir = 'T'
                 and jaql969sdmnl is not null
                 --and a.jaql969suds = pc_codage  --2016.02.08 cliente recibido pertenezca a la agencia del analista.
              );                 
                 
   return ln_clioto;
 
end fn_pa_Cli_RecibidoNew;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_plus_REcalculo(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
             ,jaql583bmet ,jaql583ppca, jaql583ppcm, jaql583ppcn , JAQL583PJCAS  ---2014.05.21
         from jaql583
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
        and jaql583usu like '%'||lc_analista||'%';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
        
         -- and jaql583tase is not null;
        /*AND jaql583usu IN (  'AAPAZAV','ACOAQUIRA','AGARCIAO','AGAVIDIA','BOLIVARES','CCHOQUE','CSANCHEZA','DBUSTINZA',
'DPARRA','DRAMOS','DTORRESPE','DVALDERRAM','EBERNAL','ECAHUANA','FMATEO','FQUISPE','GPOBLETE',
'ICORNEJO','JARANIBAR','JDELCASTIL','JFLOREZG','JHUACHACA','JPARIV','KTELLOP','LAVILAG','LCARDENAS',
'LVALDEZ','MAQUIZE','MFERNANDES','MGONZALESC','MMORAN','RARENAS','RLUQUE','RSANCA','RSEBASTIAN',
'WCERESO','WTACCA','YARENAS','YCERRON'
          );*/      



ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  if pd_fecpro < to_date('2014.04.30','yyyy.mm.dd') then --PARA RECALCULO
    ln_Por_Cliente := 60;
  end if;
  
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pd_fecpro,pc_analista) loop

     
--- ==> PAGO VARIABLE

   
     -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583saldo - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
     
     if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
    
     --4--crecimiento saldo ANUAL
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and ln_cre_saldoanual - i.jaql583mtsa > 0 then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
            
            
               ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
            
            
            -- ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
             end if;
             if ln_plussdoanu < 0 then
                ln_plussdoanu := 0;
             end if;  

     end if;
     
     
      --7--CALCULAR PRIMERO - crecimiento saldo MENSUAL
       ---calcular PLUS
                --A-- saldo mensual
                begin
                  select jaql581sdom
                    into ln_porcentaje --porcentaje mensual saldo
                    from jaql581
                   where jaql581cage = i.jaql583tage
                     and jaql581tase = i.jaql583tase
                     and jaql581est = 'S';
                exception
                  when no_data_found then
                    ln_porcentaje := 0;
                end;
      
     if  ( ln_cre_saldoanual - i.jaql583mtsa ) > 0 then
          
                 ln_plussdomes := ((ln_cre_saldomes - i.jaql583mtsa )- (ln_cre_saldoanual - i.jaql583mtsa));
                 ln_plussdomes := ln_plussdomes * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
     ELSE

                 ln_plussdomes := (ln_cre_saldomes - i.jaql583mtsa ) * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 

                 
     end if;
     ---------------
     
     --10 MONTO CASTIGADO
     ----------
     begin
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = i.jaql583tase
          and jaql595tiag = i.jaql583tage
          and jaql595cla  = i.jaql583tusu
          and i.jaql583pmra > jaql595min
          and i.jaql583pmra <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;
     
           
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + I.jaql583ppca + ln_plussdomes + I.jaql583ppcm + I.jaql583ppcn ) * I.JAQL583PJCAS/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + I.jaql583ppca + I.jaql583ppcm + I.jaql583ppcn +  ln_mtocastigo ;
     
      if ln_totalPlus >=0 then
          ln_totalPP := ln_totalPLUS; 
      else
          ln_totalPP := 0;
      end if;    
     --actualizar bonos
     update jaql583
        set 
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bplu = ln_totalPLUS,
            ---ultimos campos actualizados
            JAQL583TOTPA = (I.jaql583bmet + ln_totalPP/*ln_totalPLUS*/) 
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
         
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_PLUS_recalculo;
  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad_simu(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              jaql583bmet ,jaql583ppca, jaql583ppcm, jaql583ppcn , JAQL583PJCAS,  ---2014.05.21
              jaql583ppla , jaql583pplm, jaql583pplm
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
        and jaql583usu like '%'||lc_analista||'%';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
        
         -- and jaql583tase is not null;
        /*AND jaql583usu IN (  'AAPAZAV','ACOAQUIRA','AGARCIAO','AGAVIDIA','BOLIVARES','CCHOQUE','CSANCHEZA','DBUSTINZA',
'DPARRA','DRAMOS','DTORRESPE','DVALDERRAM','EBERNAL','ECAHUANA','FMATEO','FQUISPE','GPOBLETE',
'ICORNEJO','JARANIBAR','JDELCASTIL','JFLOREZG','JHUACHACA','JPARIV','KTELLOP','LAVILAG','LCARDENAS',
'LVALDEZ','MAQUIZE','MFERNANDES','MGONZALESC','MMORAN','RARENAS','RLUQUE','RSANCA','RSEBASTIAN',
'WCERESO','WTACCA','YARENAS','YCERRON'
          );*/      



ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;
ln_METAMORA NUMBER:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
                                                            
  
    BEGIN
        select JAQL583PMRA
          into ln_METAMORA 
          from jaql583 j
         where j.jaql583usu = i.jaql583usu--j.jaql583usu like '%'||trim(pc_analista)||'%'
           and j.jaql583fpro = to_date('2014.03.31','yyyy.mm.dd');

    exception when no_data_found then
        ln_METAMORA := 0; 
    END;    
 
     
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if i.jaql583saldo > 0  --saldo total > 0
        and (i.jaql583saldo - i.jaql583sant)>= 0 --2014.05.22 SOLO SUPERAR EL SALDO ANTERIOR--i.jaql583mtsa --crecimiento mensual>= metasaldo
        then
         ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
     end if;
     

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= ln_METAMORA ---2014.05.20/*i.jaql583mtmr*/  --porcentaje mora >= meta mora
        then
        --ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
        ln_bonomora := 300; -- PARA SIMULACION CAMBIO A 300 CONFIRMAR PARA ACTUALIZAR TABLA 2014.05.21
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + i.jaql583bcli/*ln_bonocli*/ + ln_bonomora; --TOTAL BONO
     if ln_totalBONO > 650 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 650; 
     end if;
     ---
     
    
     --10 MONTO CASTIGADO
     ----------
     ln_castigo := 0;          --no se castiga por mora
     
     
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( i.jaql583ppla + i.jaql583ppca + i.jaql583pplm + i.jaql583ppcm + i.jaql583ppcn ) * ln_castigo/100;
     
     ln_totalPLUS := i.jaql583ppla + i.jaql583pplm + i.jaql583ppca + i.jaql583ppcm + i.jaql583ppcn +  ln_mtocastigo ;
     
     
    if ln_totalPlus >=0 then
        ln_totalPP := ln_totalPLUS; 
    else
        ln_totalPP := 0;
    end if;    
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bmra = ln_bonomora,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            jaql583mtmr = ln_METAMORA,
            ---ultimos campos actualizados
            JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
            JAQL583PJCAS = ln_castigo --porcentaje castigo
            ---
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
         
      --actualiza mantenimiento CASTIGO....
      --if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                 jaql572mcas =  ln_castigo_mantenimiento,
                 jaql572pjcas = ln_castigo
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      --end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_bonos_productividad_simu;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_productividad_sim2(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              jaql583bmet ,jaql583ppca, jaql583ppcm, jaql583ppcn , JAQL583PJCAS,  ---2014.05.21
              jaql583ppla , jaql583pplm, jaql583pplm
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
        and jaql583usu like '%'||lc_analista||'%';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
        
         -- and jaql583tase is not null;
        /*AND jaql583usu IN (  'AAPAZAV','ACOAQUIRA','AGARCIAO','AGAVIDIA','BOLIVARES','CCHOQUE','CSANCHEZA','DBUSTINZA',
'DPARRA','DRAMOS','DTORRESPE','DVALDERRAM','EBERNAL','ECAHUANA','FMATEO','FQUISPE','GPOBLETE',
'ICORNEJO','JARANIBAR','JDELCASTIL','JFLOREZG','JHUACHACA','JPARIV','KTELLOP','LAVILAG','LCARDENAS',
'LVALDEZ','MAQUIZE','MFERNANDES','MGONZALESC','MMORAN','RARENAS','RLUQUE','RSANCA','RSEBASTIAN',
'WCERESO','WTACCA','YARENAS','YCERRON'
          );*/      



ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;
ln_METAMORA NUMBER:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
                                                            
  
    BEGIN
        select JAQL583PMRA
          into ln_METAMORA 
          from jaql583 j
         where j.jaql583usu = i.jaql583usu--j.jaql583usu like '%'||trim(pc_analista)||'%'
           and j.jaql583fpro = to_date('2014.03.31','yyyy.mm.dd');

    exception when no_data_found then
        ln_METAMORA := 0; 
    END;    
 
     
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if i.jaql583saldo > 0  --saldo total > 0
        and (i.jaql583saldo - i.jaql583sant)>= 0 --2014.05.22 SOLO SUPERAR EL SALDO ANTERIOR--i.jaql583mtsa --crecimiento mensual>= metasaldo
        then
         ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
     end if;
     

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= ln_METAMORA ---2014.05.20/*i.jaql583mtmr*/  --porcentaje mora >= meta mora
        then
        --ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
        ln_bonomora := 300; -- PARA SIMULACION CAMBIO A 300 CONFIRMAR PARA ACTUALIZAR TABLA 2014.05.21
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + i.jaql583bcli/*ln_bonocli*/ + ln_bonomora; --TOTAL BONO
     if ln_totalBONO > 650 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 650; 
     end if;
     ---
     
    
    -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583saldo - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583cliente - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
     
     if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
    
     --4--crecimiento saldo ANUAL
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and ln_cre_saldoanual - i.jaql583mtsa > 0 then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
            
            
               ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
            
            
            -- ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
             end if;
             if ln_plussdoanu < 0 then
                ln_plussdoanu := 0;
             end if;  

     end if;
     
     
      --7--CALCULAR PRIMERO - crecimiento saldo MENSUAL
       ---calcular PLUS
                --A-- saldo mensual
                begin
                  select jaql581sdom
                    into ln_porcentaje --porcentaje mensual saldo
                    from jaql581
                   where jaql581cage = i.jaql583tage
                     and jaql581tase = i.jaql583tase
                     and jaql581est = 'S';
                exception
                  when no_data_found then
                    ln_porcentaje := 0;
                end;
      
     if  ( ln_cre_saldoanual - i.jaql583mtsa ) > 0 then
          
                 ln_plussdomes := ((ln_cre_saldomes - i.jaql583mtsa )- (ln_cre_saldoanual - i.jaql583mtsa));
                 ln_plussdomes := ln_plussdomes * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
     ELSE

                 ln_plussdomes := (ln_cre_saldomes - i.jaql583mtsa ) * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 

                 
     end if;
     ---------------


     --10 MONTO CASTIGADO
     ----------
     ln_castigo := 0;          --no se castiga por mora
     
     
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + i.jaql583ppca + ln_plussdomes + i.jaql583ppcm + i.jaql583ppcn ) * ln_castigo/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + i.jaql583ppca + i.jaql583ppcm + i.jaql583ppcn +  ln_mtocastigo ;
     
     
    if ln_totalPlus >=0 then
        ln_totalPP := ln_totalPLUS; 
    else
        ln_totalPP := 0;
    end if;    
    
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bmra = ln_bonomora,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            
            ---ultimos campos actualizados
            JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
            JAQL583PJCAS = ln_castigo --porcentaje castigo
            ---
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
    
         
      --actualiza mantenimiento CASTIGO....
      --if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                 jaql572mcas =  ln_castigo_mantenimiento,
                 jaql572pjcas = ln_castigo
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      --end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_bonos_productividad_sim2;


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_bono_produ(pd_fecpro in date) is


  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

ln_ini number;
ln_fin number;
ln_divisor number:=5;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
ln_contador number;
ln_num number:= 1;
lc_hostname varchar2(64);
 
begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;


  begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',/*'DESA011215',*//*'BANTPROD'*/  --'DESA01022014A',--'BANTPROD',  03.02.2015
                                    tabname          => 'JAQL583',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

      lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD'); 

      ---carga mensual
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_productividad_ana.sp_cr_bonos_productividad('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD''),'''' );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
            IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
--                        instance => 2, --1,--2, ---1:DESA2  2:PRODUCCION  03.02.2015
                        instance => 2, ---restaurar 2 en produccion
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
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;     

       
end sp_cr_job_bono_produ;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure sp_cr_inserta_agencia( pd_fecpro in date) is
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
 
  ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');   
  ld_fecfin := pd_fecpro; --last_Day(pd_fecpro);
  
  delete from jaql966 where JAQL966FEC >= ld_fecini and JAQL966FEC <= ld_fecfin;

  ld_finmes := last_Day(pd_fecpro);
  if pd_fecpro <> ld_finmes then

    --diario
    insert into jaql966 (JAQL966FEC,JAQL966COD,JAQL966NOM,JAQL966CAR,JAQL966TIP,JAQL966SUC,JAQL966STS,JAQL966USR)
    select ld_fecfin, AGTECOD,AGTENOM,CARGOCOD,AGTETIP,AGTESUC,AGTESTS,AGTEUSR from fst156;
  else     
    --mensual
    insert into jaql966 (JAQL966FEC,JAQL966COD,JAQL966NOM,JAQL966CAR,JAQL966TIP,JAQL966SUC,JAQL966STS,JAQL966USR)
    select ld_fecfin, AGTECOD,AGTENOM,CARGOCOD,AGTETIP,AGTESUC,AGTESTS,AGTEUSR from fst156_201X;
  end if; 
      
  commit;

 end sp_cr_inserta_agencia;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_mora_mesbase
  (
    pc_analista IN char,
    pd_fecpro   IN date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_mora_mesbase
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
    ln_pormor jaql583.jaql583pmra%type; 
    ld_fecfin date;
    ld_fecini date;
    ln_Porcentaje number;
    ln_pornew number;
    
  begin

    begin
      select to_date(tp1desc, 'dd.mm.yyyy')
      into ld_fecini
      from fst198 
     where tp1cod =1 
       and tp1cod1 = 10847 
       and tp1corr1 = 5;
   end;


    begin
        select tpimp
         into ln_Porcentaje
         from fst098
        where pgcod = 1
          and tpcod = 7663
          and tpcorr = 4;
      end;

    select last_day(add_months(trunc(pd_fecpro), -1))
      into ld_fecfin
      from dual;

    if  pd_fecpro < to_Date('2014.06.30','yyyy.mm.dd') then
     --obtiene mora del mes anterior
        Begin
          select jaql583pmra
            into ln_pormor
            from jaql583
           where jaql583usu = pc_analista
             and jaql583fpro = ld_fecfin;
        exception
          when others then
            ln_pormor := 0;
        end;
     else
        Begin
          select min(nvl(jaql583pmra,0))
            into ln_pormor
            from jaql583
           where jaql583usu = pc_analista
             and jaql583fpro >= ld_fecini
             and jaql583fpro <= ld_fecfin;
        exception
          when others then
            ln_pormor := 0;
        end;
     end if;   
    
    --disminuir 5% ---04.02.2015
    if ln_pormor > 0 then
       ln_pornew := ln_pormor - round((ln_pormor * ln_Porcentaje/100),2);
    else 
       ln_pornew := 0;
    end if;
     
    return ln_pornew;

  end fn_cr_mora_mesbase;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_sal_vencido(pc_analista IN varchar2,pd_fecpro in date )return number is
    -- *****************************************************************
    -- Nombre                     : fn_pa_sal_vencido
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO VENCIDO POR ANALISTA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : Saldo cartera vencida
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saldo number:= 0;   
    ld_fecpro date;
    lc_analista char(10);
  begin
 
    lc_analista := rpad(pc_analista, 10, ' ');
 
   --ld_fecpro := last_day(add_months(trunc(pd_fecpro), -1));  --cartera vencida al mes anterior
   
   begin
      select sum(jaql965sdve)
        into ln_saldo
        from jaql965 c
       where jaql965fech = pd_fecpro
         and jaql965ase = lc_analista --pc_analista
         and (case when jaql965mod = 106 and jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
         and (c.jaql965cta, c.jaql965oper , c.jaql965ase) 
              not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j);

   exception when no_data_found then
       ln_saldo := 0;           
   end;              
   
   
   return NVL(ln_saldo,0);
 
end fn_pa_sal_vencido;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_pa_sal_refinan(pc_analista IN varchar2,pd_fecpro in date )return number is
    -- *****************************************************************
    -- Nombre                     : fn_pa_sal_refinan
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO REFINANCIADO POR ANALISTA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : Saldo cartera vencida
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_saldo number:= 0;   
    ld_fecpro date;
    lc_analista char(10);
  begin
 
    lc_analista := rpad(pc_analista, 10, ' ');
 
   --ld_fecpro := last_day(add_months(trunc(pd_fecpro), -1));  --cartera vencida al mes anterior
   
   begin
        select sum(jaql965sdre)
        into ln_saldo
        from jaql965 c
       where jaql965fech = pd_fecpro
         and jaql965ase = lc_analista--pc_analista
         and (case when c.jaql965mod = 106 and c.jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
         and jaql965stat <> 33 --no reestructurados
         and (c.jaql965cta, c.jaql965oper , c.jaql965ase) 
              not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j);
   exception when no_data_found then
       ln_saldo := 0;           
   end;              
   return NVL(ln_saldo,0);
 
end fn_pa_sal_refinan;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_bonos_mejora(/*pn_sucurs in number,*/ pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_bonos_mejora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(/*ln_sucurs number,*/ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, jaql583pmnu,
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm --saldo mora
         from jaql583 j
        where jaql583fpro = ld_fecpro--;
         --and jaql583est = 'R'
        and jaql583usu like '%'||lc_analista||'%'
        --and j.jaql583age = ln_sucurs
        and j.jaql583inca = 'N';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
   
ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(/*pn_sucurs,*/ pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
                                                            
  
     
---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
--I.1
     --1--obtiene bono  por cumplimiento meta saldo
     if i.jaql583saldo >= i.jaql583smax  --mayor o igual a saldo maximo
       and i.jaql583smax > 0 --2014.08.07
        then
         ln_bonosaldo := 120; --pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase); 20.06.2014
     end if;
     
     --2--obtiene bono por cumplimiento meta cliente
     if i.jaql583cliente > 0  --clientes total > 0
        and (i.jaql583cliente - i.jaql583cant)>= i.jaql583mtcl --crecimiento mensual >= metacliente
        then
         ln_bonocli := pq_cr_productividad_ana.fn_cr_bono_cliente(i.jaql583tase);
     end if;

      --3--obtiene bono por cumplimiento meta mora
     if ln_Por_Mora/*i.jaql583pmra*/ <= i.jaql583pmnu  --porcentaje mora < Nueva Mora------ojo
        then
        ln_bonomora := 300;--pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
        
     end if;

     ---
     ln_totalBONO := ln_bonosaldo + ln_bonocli + ln_bonomora; --TOTAL BONO
     /*if ln_totalBONO > 650 then --Monto Máximo de Bono  S/. 500.00
          ln_totalBONO := 650; 
     end if;*/
     ---
     
--- ==> PAGO VARIABLE

   
     -------  obtener crecimientos   
     ln_cre_saldoanual := i.jaql583sdo/*i.jaql583saldo*/ - i.jaql583smax; --Crecimiento ANUAL SALDOS
     ln_cre_clienteanual := i.jaql583ncl/*i.jaql583cliente*/ - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
     
     ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
     ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
     
     ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
     --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
     ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
     
     if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
     --if ln_por_clientes >=  ln_Por_Cliente  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
        lc_ind_castigo := 'N';
     else 
        lc_ind_castigo := 'S';
     end if;
     -----
     
      --4--crecimiento saldo ANUAL
     if ln_cre_saldoanual > 0 -- crecimiento anual
        and i.jaql583smax > 0 --2014.08.07
        /*and ln_cre_saldoanual - i.jaql583mtsa > 0 */then  ---crecimiento anual
        
        ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
         --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
         ----------************************          
         
         ---calcular PLUS
            --A-- saldo anual
            begin
              select jaql581sdoa
                into ln_porcentaje --porcentaje anual
                from jaql581
               where jaql581cage = i.jaql583tage
                 and jaql581tase = i.jaql583tase
                 and jaql581est = 'S';
            exception
              when no_data_found then
                ln_porcentaje := 0;
            end;
            
            --plus crecimiento * plus /100
            
            
               ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
            
            
            -- ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
             if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
             end if;
             if ln_plussdoanu < 0 then
                ln_plussdoanu := 0;
             end if;  

     end if;
     
     
      --7--CALCULAR PRIMERO - crecimiento saldo MENSUAL
       ---calcular PLUS
                --A-- saldo mensual
                begin
                  select jaql581sdom
                    into ln_porcentaje --porcentaje mensual saldo
                    from jaql581
                   where jaql581cage = i.jaql583tage
                     and jaql581tase = i.jaql583tase
                     and jaql581est = 'S';
                exception
                  when no_data_found then
                    ln_porcentaje := 0;
                end;
      
     --if  ( ln_cre_saldoanual - i.jaql583mtsa ) > 0 then
     if   ln_cre_saldomes   > 0  and ln_cre_saldoanual >0 
     and i.jaql583smax > 0 --2014.08.07
      then
          
                 ln_plussdomes := ((ln_cre_saldomes /*- i.jaql583mtsa*/ )- (ln_cre_saldoanual /*- i.jaql583mtsa*/));
                 ln_plussdomes := ln_plussdomes * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 
     ELSE

                 ln_plussdomes := (ln_cre_saldomes /*- i.jaql583mtsa*/ ) * ln_porcentaje/100;
                 if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                    ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                 end if;
                 if ln_plussdomes < 0 then  ---nuevo cambio
                    ln_plussdomes := 0;
                 end if; 

                 
     end if;
         
   
     
     
  
    ----
     --11 BONO POR CLIENTES
     -----
     --solo aplica a PMYES
     --if i.jaql583tase = 'P'  then
        
          begin
            -- Call the procedure
            pq_cr_productividad_ana.sp_cr_pago_variable_cli(pc_tiagel => i.jaql583tage, --E/N/O
                                                          pc_tipage => i.jaql583lage, -- <> LIMA = 1 / LIMA = 2
                                                          pc_tipcla => i.jaql583c5030, -- U.....Z
                                                          pc_claana => i.jaql583tase, -- P Pymes / c consumo
                                                          pn_numcli => i.jaql583ncl/*i.jaql583cliente*/, --clientes mes
                                                          pn_metanu => i.jaql583cmax, --meta anual = clientes base/maximo
                                                          pn_metmes => i.jaql583mtcl, --meta mes
                                                          pn_climesa => i.jaql583cant - i.jaql583cot + i.jaql583crec,   --cliente mes anterior   --2014.08.07                                                    
                                                          pn_porcla => ln_porcla,
                                                          pn_porclm => ln_porclm,
                                                          pn_bonanu => ln_bonanu,
                                                          pn_bonmen => ln_bonmen,
                                                          pn_totanu => ln_total_exc_anual,
                                                          pn_totmes => ln_total_exc_mes,
                                                          pn_nummes => ln_excmes,
                                                          pn_numanu => ln_excanu,
                                                          pc_indexa => lc_indexa,
                                                          pc_indexm => lc_indexm
                                                           );
          end;
        
          ln_plusclianu := ln_total_exc_anual;
          ln_plusclimes := ln_total_exc_mes;
         
     --end if;            
     ---
          
     
     --9--PLUS CLIENTES NUEVOS               
     if ( ln_cre_clientemes - i.jaql583mtcl) >= 0 then 
      
       
         begin
          pq_cr_productividad_ana.sp_pa_clte_nuevo(pc_analista => i.jaql583usu,
                                                   pd_fecpro => pd_fecpro,
                                                   pc_tipage => i.jaql583tage,
                                                   pn_numcli => ln_clinuevo,
                                                   pn_mtonue => ln_PLUSCLINUEVO);
         end;
      
      end if;
            

     
     
     --10 MONTO CASTIGADO
     ----------
     /*begin  --Depende de un marcador que indique que cumplio las 5 condiciones......ojo  ln_castigo := 0;
       select jaql595cas
        into ln_castigo 
        from jaql595
        where jaql595ase  = i.jaql583tase
          and jaql595tiag = i.jaql583tage
          and jaql595cla  = i.jaql583tusu
          and ln_Por_Mora\*i.jaql583pmra*\ > jaql595min
          and ln_Por_Mora\*i.jaql583pmra*\ <= jaql595max
          and jaql595vig = 'S';
       exception when no_Data_found then
           ln_castigo := 0;         
     end;*/
     ln_castigo := 0;
 
          
     --monto castigo retorna negativo
     ln_mtocastigo :=  ( ln_plussdoanu + ln_plusclianu + ln_plussdomes + ln_plusclimes + ln_PLUSCLINUEVO ) * ln_castigo/100;
     
     ln_totalPLUS := ln_plussdoanu + ln_plussdomes + ln_plusclianu + ln_plusclimes + ln_PLUSCLINUEVO +  ln_mtocastigo ;
     
     --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
     
    if ln_totalPlus >=0 then
        ln_totalPP := ln_totalPLUS; 
    else
        ln_totalPP := 0;
    end if;    
     --actualizar bonos
     update jaql583
        set jaql583bsal = ln_bonosaldo,
            jaql583bcli = ln_bonocli,
            jaql583bmra = ln_bonomora,
            jaql583cran = ln_cre_saldoanual, 
            jaql583crme = ln_cre_saldomes, 
            jaql583crca = ln_cre_clienteanual, 
            jaql583crcm = ln_cre_clientemes, 
            jaql583ppla = ln_plussdoanu, 
            jaql583pplm = ln_plussdomes, 
            jaql583ppca = ln_plusclianu, 
            jaql583ppcm = ln_plusclimes, 
            jaql583ppcn = ln_PLUSCLINUEVO,
            jaql583cmra = ln_mtocastigo, --mto castigo
            jaql583bmet = ln_totalBONO,
            jaql583bplu = ln_totalPLUS,
            JAQL583PJCA = ln_porcla,
            JAQL583PJCM = ln_porclm,
            JAQL583EXAN = ln_bonanu,
            JAQL583EXME = ln_bonmen,
            JAQL583TEXAN = ln_total_exc_anual, --total excedente anual
            JAQL583TEXME = ln_total_exc_mes, --total excedente mensual
            JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
            ---ultimos campos actualizados
            JAQL583CRSA = ln_cre_saldomes,
            JAQL583CRCL = ln_cre_clientemes,
            JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
            JAQL583NEXA = ln_excanu,
            JAQL583NEXM = ln_excmes,
            JAQL583NCN = ln_clinuevo,
            JAQL583PJCAS = ln_castigo, --porcentaje castigo
            ---
            --ultimos campos
            jaql583cexa = lc_indexa,
            jaql583cexm = lc_indexm
            ---
      where jaql583usu  = i.jaql583usu                  
        and jaql583fpro = pd_fecpro;
            
      commit;
         
      --actualiza mantenimiento CASTIGO....
      --if ln_castigo <> 0 then
          begin
            pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                           pd_fecpro => pd_fecpro,
                                                           pn_bono_sal => ln_bono_sal,
                                                           pn_bono_cli => ln_bono_cli);
          end;
          ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
          
          update jaql572
             set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                 jaql572mcas =  ln_castigo_mantenimiento,
                 jaql572pjcas = ln_castigo,
                 jaql572inca = 'N' --indicador de nuevo calculo mejora productividad
           where jaql572usu  = i.jaql583usu                
             and jaql572fpro = pd_fecpro;
          
           commit;   
      --end if; 
       
      
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_bonos_mejora;

 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_cr_actualiza_metamora(pd_fecpro in date)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   
 cursor creditos(pd_fecpro in date) is
   select * from jaql583 where jaql583fpro = pd_fecpro;
 
 ln_mora number;
 
 
begin

   for i in creditos(pd_fecpro) loop
   
       ln_mora := pq_cr_productividad_ana.fn_cr_mora_mesbase(i.jaql583usu,i.jaql583fpro); 
       update jaql583
          set jaql583pmnu =  ln_mora 
        where jaql583usu  =  i.jaql583usu     
          and jaql583fpro =  i.jaql583fpro;  
    
   end loop;
   commit;
   
    
end sp_cr_actualiza_metamora;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*Function fn_cr_region(pn_codsuc IN number)return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_region
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/07/2014
    -- Autor de Creación          : DCASTRO-RLIVISI
    -- Uso                        : RETORNA CODIGO REGION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_codsuc
    -- Parámetros de Salida       : cod region
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  ln_codreg number:= 0;   
    
begin
   
   begin
     ---1
     select r.regcod
       into ln_codreg
       from FST811 R
      where R.REGCOD < 100
        and r.oficod = pn_codsuc
        and r.ofisuc = 'S';
   exception
     when no_data_found then
       --2
       ln_codreg := 0;
   end; --3
   return NVL(ln_codreg,0);
 
end fn_cr_region;*/ --06.03.2015


 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*Function fn_cr_guiaMetas(pn_codreg IN number)return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_guiaMetas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/07/2014
    -- Autor de Creación          : DCASTRO-RLIVISI 
    -- Uso                        : RETORNA CODIGO REGION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_codreg
    -- Parámetros de Salida       : cod meta por Region : A/B
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

  lc_descreg varchar2(2);   
    
begin
   
   begin
     ---1
     select trim(tp1desc)
     into lc_descreg
       from fst198
      where tp1cod = 1
        and tp1cod1 = 10847
        and tp1corr1 = 6
        and tp1nro1 = pn_codreg;
   exception
     when no_data_found then
       --2
       lc_descreg := null;
   end; --3
   return (lc_descreg);
 
end fn_cr_guiaMetas;*/  --06.03.2015

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_ult_traslado(pc_analista IN varchar2,pd_fecpro in date )return date is
    -- *****************************************************************
    -- Nombre                     : fn_cr_ult_traslado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : RETORNA FECHA DE ULTIMO TRASLADO 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : Fecha de ultimo traslado anterior a fecha de proceso
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   
  ld_fecpro date;
  ld_fecini date;
  

 
  Begin

 
  if pd_fecpro < to_Date('2014.07.31','yyyy.mm.dd') then
    ld_fecini := last_day(to_date('12' || '/' ||to_char(pd_fecpro + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
  else
     ld_fecini := to_Date('2014.06.30','yyyy.mm.dd');
  end if;
   
   begin
    select MAX(jaql583fpro)
      into ld_fecpro    
      from jaql583
     where trim(jaql583usu) = pc_analista --quitar comentario jaql583usu = pc_analista
       and jaql583fpro >= ld_fecini
       and jaql583fpro <= pd_fecpro
       and nvl(JAQL583SOTO+JAQL583SREC,0) > 0;
     exception when no_data_found then
       ld_fecpro := NULL;           
   end;              
   return (ld_fecpro);
 
end fn_cr_ult_traslado;    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_AjusteSdoVdo(pc_analista IN varchar2, pd_fecpro in date,
                             pn_nsdve out  number,
                             pn_sdves out  number,
                             pn_sdcas out  number,
                             pn_sdjus out  number,
                             pn_cmdsv out  number,
                             pn_sdres out  number,
                             pn_pgosv out  number,
                             pn_tasdovdo out char,
                             pn_svoto out number,
                             pn_svrec out number,
                             pn_sroto out number,
                             pn_srrec out number
                                                          
) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_ajuste_mvencido
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/10/2014
    -- Autor de Creación          : RLIVISI/DCASTRO
    -- Uso                        :  
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor, pd_fecpro: fecha_procesamiento
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   ln_sdocastS number;
   ln_sdojudS number;
   ln_sdovdoS number;
   ln_sdorefiS number;
   ln_sdocast number;
   ln_sdojud number;
   ln_sdovdo number;
   ln_sdorefi number;
    
   ln_montoPagar number;
   lc_tipoana VARCHAR2(3);  
   ln_Por_vencido number;   
   ln_mtopagar number;
   ln_DifMesVsSept number;
   ln_NvoSdoVdoIncJCR number;
  
   ln_CanMinDisSV number;
   ln_NuevoSdoVdo number;   
   ln_carJuCasRefS number;
   ln_carJuCasRef number;
   ld_fecpro date;
   ld_fecproS date := to_Date('2014.09.30','yyyy.mm.dd');
   ld_fecini date;
   lc_tipoasv VARCHAR2(3);
    
   ln_sdovdoOTO number;
   ln_sdovdoREC number;
   
   ln_sdorefREC number;
   ln_sdorefOTO number;

  Begin
 

  ln_NuevoSdoVdo := 0; -- Nuevo Sdo. Vencido
  ln_sdovdoS := 0; --Sdo Vencido Setiembre 2014
  ln_sdocastS := 0;--Sdo. Castigado Setiembre 2014
  ln_sdojudS := 0; --Sdo. Judicial Setiembre 2014
  ln_CanMinDisSV := 0;--Cantidad Mínima de Disminución de Sdo.Vencido
  ln_sdorefiS := 0; --Sdo. Refinanciado Setiembre 2014
  ln_mtopagar := 0;--Monto a Pagar por Sdo. Vencido
  lc_tipoasv := 0;--Tipo analista Sdo Vdo.


/*  if pd_fecpro < to_Date('2014.09.30','yyyy.mm.dd') then
    
  else
     ld_fecini := to_Date('2014.06.30','yyyy.mm.dd');
  end if;*/
  
 ln_sdocastS := pq_cr_productividad_ana.fn_cr_sal_castigado(pc_analista => pc_analista,
                                                         pd_fecpro => ld_fecproS ); ---sdo castigado Setiembre

 ln_sdojudS := pq_cr_productividad_ana.fn_cr_sal_judicial(pc_analista => pc_analista,
                                                        pd_fecpro => ld_fecproS ); --sdo judicial Setiembre

 ln_sdovdoS := pq_cr_productividad_ana.fn_pa_sal_vencido(pc_analista => pc_analista,
                                                       pd_fecpro => ld_fecproS );  --sdo vencido Setiembre
 ln_sdorefiS := pq_cr_productividad_ana.fn_pa_sal_refinan(pc_analista => pc_analista,        
                                                pd_fecpro => ld_fecproS ); --sdo refinanciado Setiembre   
              

 


 ln_sdocast := pq_cr_productividad_ana.fn_cr_sal_castigado(pc_analista => pc_analista,
                                                         pd_fecpro => pd_fecpro); ---sdo castigado Oct/Nov/Dic  

 ln_sdojud := pq_cr_productividad_ana.fn_cr_sal_judicial(pc_analista => pc_analista,
                                                        pd_fecpro => pd_fecpro); --sdo judicial Oct/Nov/Dic

 ln_sdovdo := pq_cr_productividad_ana.fn_pa_sal_vencido(pc_analista => pc_analista,
                                                       pd_fecpro => pd_fecpro);  --sdo vencido Oct/Nov/Dic
 ln_sdorefi := pq_cr_productividad_ana.fn_pa_sal_refinan(pc_analista => pc_analista,        
                                                pd_fecpro => pd_fecpro); --sdo refinanciado Oct/Nov/Dic
  
 --lc_tipoana:= pq_cr_productividad_ana.fn_pa_tip_analista(pc_analista => pc_analista,
   --                                                     pd_fecpro => ld_fecproS); --Tipo analista Pyme/consumo
 BEGIN
  select trim(J.JAQL583TASE) --2014.11.17
    INTO lc_tipoana
    from jaql583 j
   where j.jaql583fpro = ld_fecproS
     and tRIM(j.jaql583usu) = pc_analista; ---rpad(pc_analista, 10, ' ');
  EXCEPTION WHEN NO_DATA_FOUND THEN
      lc_tipoana := NULL;         
  END;
 
 ln_mtopagar := pq_cr_productividad_ana.fn_cr_mtopagarsdovdo(pc_tipase => lc_tipoana,
                                                          pn_sdovcdo => ln_sdovdoS);--MtoPagar por Ajuste Sdo. Vencido
   
 lc_tipoasv:= pq_cr_productividad_ana.fn_cr_tipo_ana_sdovdo(pc_tipase => lc_tipoana,
                                                           pn_sdovcdo => ln_sdovdoS);                                        

  begin
      select tpimp
       into ln_Por_vencido
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 5; ---  ln_Por_vencido = 20%
  end;
  
  ---Establecer la Cantidad Mínima a disminuir, respecto a Setiembre2014
  ln_CanMinDisSV := (ln_Por_vencido)/100* ln_sdovdoS;--Porcentaje Min Disminución de SaldoVencido
  ----Paso1:Verificar si sdo vencido de Octubre/Nov/Dic es menor al sdo vencido Setiembre, sino es saltar al Paso4

  ----***---Traslados
    begin
      pq_cr_productividad_ana.sp_pa_sal_otorgadovdoref(pc_analista => pc_analista,
                                                       pd_fecpro => pd_fecpro,
                                                       pn_saldove => ln_sdovdoOTO,
                                                       pn_saldore => ln_sdorefOTO);
    end;
      
    begin
      pq_cr_productividad_ana.sp_pa_sal_recibidovdoref(pc_analista => pc_analista,
                                                       pd_fecpro => pd_fecpro,
                                                       pn_saldove => ln_sdovdoREC,
                                                       pn_saldore => ln_sdorefREC);
    end;
    ln_sdovdo := ln_sdovdo + ln_sdovdoOTO - ln_sdovdoREC;
    ln_sdorefi := ln_sdorefi + ln_sdorefOTO - ln_sdorefREC;
    if ln_sdorefi < 0 then
       ln_sdorefi := 0;
    end if;
    ----***---


  if ln_sdovdo <= ln_sdovdoS  then   --2014.11.17 saldo menor o igual a 0
      
      ln_NuevoSdoVdo := ln_sdovdoS - ln_CanMinDisSV;  --10/11/2014
      
      
      
      ----Paso2:Verificar si sdo vencido de Octubre/Nov/Dic es menor igual al Nuevo sdo vencido  
      if ln_sdovdo <= ln_NuevoSdoVdo  then  --SdoVdoOct <= NuevoSdoVdoSetiembre
      ----Paso3:   
      ----Paso3.1:Sumar cartera Judicial, Castigada y Refinanciada
          ln_carJuCasRefS:= ln_sdojudS + ln_sdocastS + ln_sdorefiS; --Suma carteraJudicial+carCastigada+carRefinaciada de Setiembre
          ln_carJuCasRef := ln_sdojud + ln_sdocast + ln_sdorefi; --Suma carteraJudicial + carCastigada + caREfinanciada de Oct/Nov/Dic      
      
      ----Paso3.2:Se compara si la Sumcartera del mes evaluado: Oct/Nov/Dic es menor que SumCarSeptiembre     
        if ln_carJuCasRef <= ln_carJuCasRefS then
           --return (ln_mtopagar);   
--             null;     
             pn_pgosv := ln_mtopagar;  
             --ln_NvoSdoVdoIncJCR:=  ln_NuevoSdoVdo ;
             ln_NuevoSdoVdo := ln_sdovdoS - ln_CanMinDisSV;--10/11/2014
             
        else   ----si ha habido un incremento en CarJud/CarCast/CarRefinanciada
           ln_DifMesVsSept:= ln_carJuCasRef - ln_carJuCasRefS;
           ln_NvoSdoVdoIncJCR:= ln_NuevoSdoVdo - ln_DifMesVsSept;  --nueva base por inc sdo jucasrefi
           ln_NuevoSdoVdo := ln_NvoSdoVdoIncJCR; --10/11/2014
           
           if ln_NuevoSdoVdo < 0 then  --si saldo es negativo, se hace 0 CONFIRMAR???????
              ln_NuevoSdoVdo := 0;
           end if;
           if ln_sdovdo <= ln_NvoSdoVdoIncJCR then
             --return (ln_mtopagar); 
--             null;
               pn_pgosv := ln_mtopagar;
           else
           ln_mtopagar:=0;  
           end if;
        end if; 
       else
           ln_mtopagar:= 0;
       end if;
  
  else
  ----Paso 4: Retornar 0, es decir no se le paga nada; puesto que no cumple la condición del Paso1.
  ln_mtopagar:= 0;
  
  end if;  

  pn_nsdve := ln_NuevoSdoVdo; -- Nuevo Sdo. Vencido
  pn_sdves := ln_sdovdoS; --Sdo Vencido Setiembre 2014
  pn_sdcas := ln_sdocastS;--Sdo. Castigado Setiembre 2014
  pn_sdjus := ln_sdojudS; --Sdo. Judicial Setiembre 2014
  pn_cmdsv := ln_CanMinDisSV;--Cantidad Mínima de Disminución de Sdo.Vencido
  pn_sdres := ln_sdorefiS; --Sdo. Refinanciado Setiembre 2014
  pn_pgosv := ln_mtopagar;--Monto a Pagar por Sdo. Vencido
  pn_tasdovdo := lc_tipoasv;--Tipo analista Sdo Vdo.
  pn_svoto := ln_sdovdoOTO; --saldo vencido otorgado.
  pn_svrec := ln_sdovdoREC; --saldo vencido recibido.
  pn_sroto := ln_sdorefOTO; --saldo refinanciado otorgado.
  pn_srrec := ln_sdorefREC; --saldo refinanciado otorgado.
 
end sp_cr_AjusteSdoVdo;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Function fn_cr_mtopagarSdoVdo(pc_Tipase IN VARCHAR2, pn_SdoVcdo in number) return Number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_mtopagarSdoVdo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/10/2014
    -- Autor de Creación          : RLIVISI/DCASTRO
    -- Uso                        : Cálculo del Monto Mensual a pagar por ajuste sdo vencido, según tabla JAQL576.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                            : pn_SdoVcdo : Sdo Vencido. 
    -- Parámetros de Salida       : ln_mtopagar : MontoMensual a Pagar por Ajuste de Sdo. Vencido.
    -- Fecha de Modificación      : 13/10/2014
    -- Autor de la Modificación   : RLIVISI/DCASTRO
    -- Descripción de Modificación: Obtención del Monto Mensual a Pagar por Ajuste de Sdo. Vencido.
    -- *****************************************************************
    
  ln_mtopagar jaql576.jaql576pgmen%type;  
  begin
    
    begin
      select JAQL576PGMEN
        into ln_mtopagar
        from jaql576
       where trim(jaql576tase) = pc_Tipase
         and JAQL576CVMIN < pn_SdoVcdo
         and JAQL576CVMAX >= pn_SdoVcdo;       
        
    exception
          when others then
            ln_mtopagar := 0;
    End;
    return ln_mtopagar;

  end fn_cr_mtopagarSdoVdo;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_cr_calcula_ajuste_sdvo(pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_ajuste_sdvo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/10/2014
    -- Autor de Creación          : DCASTRO/RLIVISI
    -- Uso                        : Procedimiento que llena los campos JAQL583NSDVE, JAQL583SDVES, JAQL583SDCAS, JAQL583SDJUS,
    --                            : JAQL583SMDSV, JAQL583SDRES, JAQL583PGOSV de la tabla JAQL583 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro, pc_analista
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
   
 
  cursor creditos(pd_fecpro in date,lc_analista in char)  is
     select j.* 
       from jaql583 j
      where jaql583fpro = pd_fecpro 
        and jaql583usu like '%'||lc_analista||'%' ; -- 
        
   
  
  ln_nsdve jaql583.jaql583nsdve%type;  
  ln_sdves jaql583.jaql583sdves%type;
  ln_sdcas jaql583.jaql583sdcas%type;
  ln_sdjus jaql583.jaql583sdjus%type;
  ln_cmdsv jaql583.jaql583cmdsv%type;
  ln_sdres jaql583.jaql583sdres%type;
  ln_pgosv jaql583.jaql583pgosv%type;
  lc_tipoasv jaql583.jaql583tasv%type;
  lc_analista char(20):= null;
  ln_svoto jaql583.jaql583svoto%type;
  ln_svrec jaql583.jaql583svrec%type;
  ln_sroto jaql583.jaql583sroto%type;
  ln_srrec jaql583.jaql583srrec%type;
  
begin

      for i in creditos(pd_fecpro, pc_analista) loop
      

        begin

          pq_cr_productividad_ana.sp_cr_ajustesdovdo(pc_analista => trim(i.jaql583usu),
                                                     pd_fecpro => i.jaql583fpro,
                                                     pn_nsdve => ln_nsdve,
                                                     pn_sdves => ln_sdves,
                                                     pn_sdcas => ln_sdcas,
                                                     pn_sdjus => ln_sdjus,
                                                     pn_cmdsv => ln_cmdsv,
                                                     pn_sdres => ln_sdres,
                                                     pn_pgosv => ln_pgosv,
                                                     pn_tasdovdo => lc_tipoasv,
                                                     pn_svoto => ln_svoto,
                                                     pn_svrec => ln_svrec,
                                                     pn_sroto => ln_sroto,
                                                     pn_srrec => ln_srrec
                                                     
                                                     );
        end;    
      
        --ACTUALIZAR
        update jaql583
           set 
           jaql583nsdve = ln_nsdve,
           jaql583sdves = ln_sdves,
           jaql583sdcas = ln_sdcas,
           jaql583sdjus = ln_sdjus,
           jaql583cmdsv = ln_cmdsv,
           jaql583sdres = ln_sdres,
           jaql583pgosv = ln_pgosv,
           jaql583tasv = lc_tipoasv,
           jaql583svoto = ln_svoto,
           jaql583svrec = ln_svrec,
           jaql583sroto = ln_sroto,
           jaql583srrec = ln_srrec
         where jaql583usu = i.jaql583usu
            and jaql583fpro = i.jaql583fpro;
         
       COMMIT;
       
      end loop;
      
   
end sp_cr_calcula_ajuste_sdvo;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Function fn_cr_tipo_ana_sdovdo(pc_Tipase IN VARCHAR2, pn_SdoVcdo in number) 
  return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_TIPO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/11/2014
    -- Autor de Creación          : 
    -- Uso                        : Establece el tipo de analista SdoVencido de acuerdo al
    --                              tipo analista C = consumo y P = pymes 
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Pc_clasana: Clasificación analista P:Pyme, C:Consumo
    --                              P_IN_Fecha: Fecha de proceso
    -- Parámetros de Salida       : lc_tipoasv: H,G,F,E,D,C,B,A
    -- Fecha de Modificación      : 10/11/2014
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  lc_tipoasv  jaql576.jaql576tiacv%type; 
   
  begin
  
    begin
       Select jaql576tiacv
       into lc_tipoasv
       from jaql576
       where pn_SdoVcdo >= jaql576cvmin
         and pn_SdoVcdo <= jaql576cvmax
         and TRIM(jaql576tase) = pc_Tipase;
       
    exception
          when others then
            lc_tipoasv := null;   
  
    end;
    
    return lc_tipoasv;
 
 end fn_cr_tipo_ana_sdovdo;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_pa_Sal_OtorgadoVdoRef(pc_analista IN varchar2,
                                   pd_fecpro in date,
                                   pn_saldove out number,
                                   pn_saldore out number
                                  )  is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO VENCIDO, REFINANCIADO POR CARTERA OTORGADA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldove number;
    ln_saldore number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');

     BEGIN  
        select sum(j.jaql965sdve)
          INTO ln_saldove                    
          from (select jaql969emp,
                       case when jaql969mod = 117 then jaql969modl else jaql969mod end modulo,
                       case when jaql969mod = 117 then jaql969opel else jaql969oper end operacion,
                       jaql969suc,
                       jaql969mda,
                       jaql969pap,
                       jaql969cta,
                       jaql969oper,
                       jaql969sbop
                  from JAQL969 a
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and a.Jaql969ASEO = rpad(pc_analista, 10, ' ')) O,
               jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = jaql969emp
           and j.jaql965mod = modulo
           and j.jaql965suc = jaql969suc
           and j.jaql965mda = jaql969mda
           and j.jaql965pap = jaql969pap
           and j.jaql965cta = jaql969cta
           and j.jaql965oper = OPERACION--jaql969oper
           and j.jaql965sbop = jaql969sbop;
     EXCEPTION WHEN NO_DATA_FOUND THEN
            ln_saldove := 0;
     END;      
      
      BEGIN  
        select sum(j.jaql965sdre) 
          INTO ln_saldore                    
          from (select jaql969emp,
                       case when jaql969mod = 117 then jaql969modl else jaql969mod end modulo,
                       case when jaql969mod = 117 then jaql969opel else jaql969oper end operacion,
                       jaql969suc,
                       jaql969mda,
                       jaql969pap,
                       jaql969cta,
                       jaql969oper,
                       jaql969sbop
                  from JAQL969 a
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and a.Jaql969ASEO = rpad(pc_analista, 10, ' ')) O,
               jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = jaql969emp
           and j.jaql965mod = modulo
           and j.jaql965suc = jaql969suc
           and j.jaql965mda = jaql969mda
           and j.jaql965pap = jaql969pap
           and j.jaql965cta = jaql969cta
           and j.jaql965oper = OPERACION--jaql969oper
           and j.jaql965sbop = jaql969sbop
           and j.jaql965stat <> 33;
     EXCEPTION WHEN NO_DATA_FOUND THEN
            ln_saldore := 0;           
     END;      
      
       
    pn_saldove := nvl(ln_saldove,0);
    pn_saldore := nvl(ln_saldore,0);
 
  end sp_pa_Sal_OtorgadoVdoRef;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_pa_Sal_RecibidoVdoRef(pc_analista IN varchar2,
                                   pd_fecpro in date,
                                   pn_saldove out number,
                                   pn_saldore out number
                                  ) is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : RETORNA SALDO VENCIDO, REFINANCIADO POR CARTERA OTORGADA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  
    ln_saltot number:= 0;   
    ld_fecini date; 
    ld_fecha  date;  
    ln_saldove number;
    ln_saldore number;
    
  begin
       ld_fecini := to_date(to_char(pd_fecpro,'yyyymm')||'01','yyyymmdd');

     BEGIN  
        select sum(j.jaql965sdve)
          INTO ln_saldove                    
          from (select jaql969emp,
                       case when jaql969mod = 117 then jaql969modl else jaql969mod end modulo,
                       case when jaql969mod = 117 then jaql969opel else jaql969oper end operacion,
                       jaql969suc,
                       jaql969mda,
                       jaql969pap,
                       jaql969cta,
                       jaql969oper,
                       jaql969sbop
                  from JAQL969 a
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and a.Jaql969ASED = rpad(pc_analista, 10, ' ')) O,
               jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = jaql969emp
           and j.jaql965mod = modulo
           and j.jaql965suc = jaql969suc
           and j.jaql965mda = jaql969mda
           and j.jaql965pap = jaql969pap
           and j.jaql965cta = jaql969cta
           and j.jaql965oper = OPERACION--jaql969oper
           and j.jaql965sbop = jaql969sbop;
     EXCEPTION WHEN NO_DATA_FOUND THEN
            ln_saldove := 0;
     END;      
     
     BEGIN  
        select sum(j.jaql965sdre) 
          INTO ln_saldore                    
          from (select jaql969emp,
                       case when jaql969mod = 117 then jaql969modl else jaql969mod end modulo,
                       case when jaql969mod = 117 then jaql969opel else jaql969oper end operacion,
                       jaql969suc,
                       jaql969mda,
                       jaql969pap,
                       jaql969cta,
                       jaql969oper,
                       jaql969sbop
                  from JAQL969 a
                 where JAQL969FECH between ld_fecini and pd_fecpro
                   and a.Jaql969ASED = rpad(pc_analista, 10, ' ')) O,
               jaql965 j
         where j.jaql965fech = pd_fecpro
           and j.jaql965emp = jaql969emp
           and j.jaql965mod = modulo
           and j.jaql965suc = jaql969suc
           and j.jaql965mda = jaql969mda
           and j.jaql965pap = jaql969pap
           and j.jaql965cta = jaql969cta
           and j.jaql965oper = OPERACION--jaql969oper
           and j.jaql965sbop = jaql969sbop
           and j.jaql965stat <> 33;
     EXCEPTION WHEN NO_DATA_FOUND THEN
            ln_saldore := 0;           
     END;  
       
     pn_saldove := nvl(ln_saldove,0);
     pn_saldore := nvl(ln_saldore,0);
 
  end sp_pa_Sal_RecibidoVdoRef;   
  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 Procedure sp_cr_MetasFeb15(pc_JAQL579TIP in char,
                           pc_JAQL579TASE in char,
                           pc_tipage IN CHAR,
                           pn_JAQL579CCLAGE in number,
                           pn_JAQL579CUBC in number,
                           pn_metasal out number,
                           pn_metacli out number,
                           pn_metamor out number                      
                           
                           ) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MetasFeb15
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 04/03/2015
    -- Autor de Creación          : RLIVISI - DCASTRO
    -- Uso                        : RETORNA METAS FEBRERO 2015
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL579TIP, JQY579TASE, JAQL579CCLAGE, JAQL579CUBC
    -- Parámetros de Salida       : METAS FEB2015 (MetaSaldo, MetaCliente y MetaMora) 
    --                            : PARA LOS QUE TIENEN LOS 4 PARÁMETROS DE ENTRADA
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
    
begin
   
   begin
     ---1
     
     select jaql579sado, jaql579clie, jaql579mra
      into pn_metasal, pn_metacli, pn_metamor
      from jaql579
      where JAQL579TIP = pc_JAQL579TIP 
      and JAQL579TASE = pc_JAQL579TASE
      and JAQL579CCLAGE = pn_JAQL579CCLAGE
     -- and JAQL579TAGE = pc_tipage 
      and JAQL579CUBC	= pn_JAQL579CUBC;
    
   exception
     when no_data_found then
       --2
       
       pn_metasal:=0;
       pn_metacli:=0;
       pn_metamor:=0;
       
       
   end; --3
   
   
 
end sp_cr_MetasFeb15;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
                                              


procedure sp_cr_validaMetasFeb15(pn_agencia in number,
                               pc_jaql579tage in char,                
                               pn_JAQL579CCLAGE out number,
                               pn_JAQL579CUBC out number                               
                               ) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MetasFeb15
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 04/03/2015
    -- Autor de Creación          : RLIVISI - DCASTRO
    -- Uso                        : RETORNA DE LA GUIA DE PROCESOS METAS:FEB-2015, 
    --                            : el CódigoClasificacionAgencia y CódigoDeUbicación.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : NUMERO DE AGENCIA 
    -- Parámetros de Salida       : Devolución de CódigoClasificaciónAgencia y CódigoDeUbicación.
    -- Fecha de Modificación      : 05/03/2015
    -- Autor de la Modificación   : RLIVISI 
    -- Descripción de Modificación: Devolución de CódigoClasificacionAgencia y CódigoDeUbicación.
    -- *****************************************************************
        
begin
    
   
  begin
     ---1
     
     select tp1corr3, tp1nro1
      into pn_JAQL579CCLAGE, pn_JAQL579CUBC                                                                   
      from fst198
      where tp1cod= 1
      and tp1cod1 = 10847
      and tp1corr1= 7
      and tp1nro3 = pn_agencia ;
    
   exception
     when no_data_found then
       --2
         pn_JAQL579CCLAGE:=0;
         pn_JAQL579CUBC:=0;   
         
                  
   end; --3  
   
    
 
       
end sp_cr_validaMetasFeb15;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_retorna_metas(pc_JAQL579TIP in char, 
                              pc_JAQL579TASE in char, 
                              pc_tipage in char, 
                              pn_agencia in number,
                              pc_codusu in char,                              
                              pn_metasal out number,
                              pn_metacli out number,
                              pn_metamor out number) is

    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_TIPO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 04/03/2015
    -- Autor de Creación          : RLIVISI - DCASTRO
    -- Uso                        : Obtener metas finales de Productividad Feb-2015
    --                             
    -- Acceso                     : Público
    -- Parámetros de Entrada      : Pc_clasana: Clasificación analista P:Pyme, C:Consumo
    --                            : Tipo analista : I, II, III, IV, V, VI
    --                              Tipo de Agencia: E/N/O
    --                            : Codigo Agencia: 1...109 
    -- Parámetros de Salida       : Meta Cliente, Meta Saldo, Meta Mora
    -- Fecha de Modificación      : 04/03/2015 
    -- Autor de la Modificación   : RLIVISI - DCASTRO
    -- Descripción de Modificación: Complementación de funciones finales
    -- *****************************************************************
     ln_metasal number;
     ln_metacli number;
     ln_metamor number;
     lc_CodAseagroGP char;
     ln_JAQL579CCLAGE number;
     ln_JAQL579CUBC number; 
      
      
     begin
  
       lc_CodAseagroGP:= pq_cr_productividad_ana.fn_cr_aseagro(pc_codusu);
        if  lc_CodAseagroGP = 'A' then    
  
                 ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(lc_CodAseagroGP,pc_tipage, pc_JAQL579TIP, pn_agencia);        
                 ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(lc_CodAseagroGP,pc_tipage, pc_JAQL579TIP, pn_agencia);
                 ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(lc_CodAseagroGP,pc_tipage, pc_JAQL579TIP, pn_agencia);
           
              
        else 
             if pc_JAQL579TASE = 'C'  then
        
                 ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);        
                 ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);
                 ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);
                 
              else
         
                   if pc_JAQL579TASE = 'P'  then     --checar 05.03.2015                
                          
                          pq_cr_productividad_ana.sp_cr_validaMetasFeb15(pn_agencia,
                                                                       pc_tipage,               
                                                                       ln_JAQL579CCLAGE,
                                                                       ln_JAQL579CUBC);                              
                                                                      
                         if nvl(ln_JAQL579CCLAGE,0) <> 0 then 
                            pq_cr_productividad_ana.sp_cr_MetasFeb15(pc_JAQL579TIP, 
                                                                     pc_JAQL579TASE, 
                                                                     pc_tipage,
                                                                     ln_JAQL579CCLAGE,
                                                                     ln_JAQL579CUBC, 
                                                                     ln_metasal, 
                                                                     ln_metacli, 
                                                                     ln_metamor); 
                            
                            ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);
                                                                     
                 
                          else
                             ln_metasal := pq_cr_productividad_ana.fn_cr_cred_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);        
                             ln_metacli := pq_cr_productividad_ana.fn_cr_clie_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);
                             ln_metamor := pq_cr_productividad_ana.fn_cr_mora_metas(pc_JAQL579TASE ,pc_tipage,pc_JAQL579TIP, pn_agencia);
                             
                         end if;                              
                   end if;               
              end if;               
        end if;  
        
       pn_metasal:= ln_metasal;
       pn_metacli:= ln_metacli;
       pn_metamor:= ln_metamor;
           
 end sp_cr_retorna_metas;
 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_aseagro(pc_codase in char) return char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MetasFeb15
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/03/2015
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA SI CODIGO ANALISTA INGRESADO ES AGROPECUARIO O NO.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : CODIGO DE ANALISTA (CHAR)
    -- Parámetros de Salida       : DEVUELVE 'A', SI ES AGROPECUARIO Y 'N' SI NO LO ES. 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
  lc_codaseagro char;
       
begin
   
   begin
     ---1
     
     select 'A'
      into lc_codaseagro
      from fst198
      where tp1cod= 1
      and tp1cod1 = 10847
      and tp1corr1= 8
      and tp1desc = pc_codase;
    
   exception
     when no_data_found then
       --2
       
       lc_codaseagro:='N';       
       
       
   end; --3  
   return lc_codaseagro;
 
end fn_cr_aseagro;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_MetasEne16(pn_JAQL586codage in number,
                           pn_jaql586ctipmer out number,
                           pn_jaql586cantage out number,
                           pc_jaql586caja out char 
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_MetasEne16
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/02/2016
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA METAS ENERO 2016
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL586CODAGE
    -- Parámetros de Salida       : METAS ENE2016 (CódigoTipoMercado, CódigoAntiguedadAgencia y CódigoCaja) 
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
    
begin
   
   begin
     ---1
     
     select jaql586ctipmer, jaql586cantage, jaql586caja
      into pn_jaql586ctipmer, pn_jaql586cantage, pc_jaql586caja
      from jaql586
      where JAQL586CODAGE = pn_JAQL586codage; 
    
   exception
     when no_data_found then
       --2
       
       pn_jaql586ctipmer:=0;
       pn_jaql586cantage:=0;
       pc_jaql586caja:=0;
       
       
   end; --3
   
   
 
end sp_cr_MetasEne16;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_CategoriaRRHH(pc_JAQL587codana in char,
                             pd_fecpro in date)              
                               return number is
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
 
pn_jaql587codcat number;  
  
begin
      --verificar cartera de analista para determinar si es senior
      pn_jaql587codcat := pq_cr_productividad_ana.fn_cr_senior(pc_analista => pc_JAQL587codana, pd_fecpro => pd_fecpro);
      ---              
      if pn_jaql587codcat = 0 then
         begin
           ---1
           
           select jaql587codcat
            into pn_jaql587codcat
            from jaql587
            where JAQL587codana = pc_JAQL587codana
            and jaql587est = 'S'; --2016.04.05 se agrego estado 
          
         exception
           when no_data_found then
             --2
             
             pn_jaql587codcat:=0;       
             
         end; --3
      end if;
         
  return   pn_jaql587codcat;
  
end fn_cr_CategoriaRRHH;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_MetasFactor( pd_fecpro in date,
                                     pc_codana in char,
                                     pn_codage in number,
                                     pc_codcaj in char,
                                     pn_tipmer in number,
                                     pn_antage in number,
                                     pn_codcat in number,
                                     pc_tipusu in varchar2
                                     ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_MetasFactor
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.02.08
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Obtiene Factor para Calcular Meta Saldo y Meta Cliente x Mes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2016.04.05 se agrego estado
    -- *****************************************************************
        

  cursor listado is
      select * from jaql587 j
       where j.jaql587codana = pc_codana
         and j.jaql587est = 'S'; --2016.04.05 se agrego estado
         
ln_codzon number;
ln_mes number;
ln_anio number;
ln_factor number;
lc_caja char(3);
lc_tipana char(1);
ln_tipmer number;
ln_antage number;
ln_codcat number;
ln_cliente number;
ln_saldo number(17,2);
ln_metcli number;
ln_metsal number(17,2);
ln_totcli number;
ln_totmet number(17,2);
lc_codusu char(10);

ln_codsuc number;
ln_contador number := 1;


begin

  ln_anio := to_char(pd_fecpro,'RRRR');
  lc_caja := pc_codcaj;
  lc_tipana := pc_tipusu;
  ln_tipmer := pn_tipmer;  
  ln_antage := pn_antage;
  ln_codcat := pn_codcat;
  lc_codusu := pc_codana;
  ln_codsuc := pn_codage;
  
 
  
 -- for i in listado loop --listado analistas
      --lc_codusu := substr(i.jaql587codana,1,10);
      
     -- ln_codcat := i.jaql587codcat;
      
      begin
         select count(*)
           into ln_contador  
           from JAQL590     
          where jaql590codana = lc_codusu
            and jaql590age = ln_codsuc
            and jaql590anio = ln_anio
            and jaql590est = 'S';
      exception when no_data_found then
           ln_contador := 0;
      end;
      
      if ln_contador = 0 then --sino existe analista insertar
            
            
         --obtiene zona - 
         ln_codzon := pq_cr_productividad_ana.fn_cr_zona(ln_codsuc);
         
            
            ln_mes := 1;
            
              --obtiene metas saldo y cliente
             begin
                  select jaql588metsal, jaql588metcli
                    into ln_saldo, ln_cliente
                    from jaql588      
                   where jaql588caja = lc_caja
                     and jaql588tase = lc_tipana
                     and jaql588ctipmer = ln_tipmer
                     and jaql588cantage = ln_antage
                     and jaql588codcat = ln_codcat
                     and jaql588est = 'S'; --2016.04.05 se agrego estado
              exception when others then
                   ln_saldo := 0 ;
                   ln_cliente := 0;
              end; 
              
             
              ln_totmet := ln_saldo;
              ln_totcli := ln_cliente;

             -- dbms_output.put_line(' TOTCLI-'||ln_totcli||' TOTSAL-'||ln_totmet );

              
            for i in 1..12 loop
              --obtiene factor
              begin
                   select jaql589fact/100
                     into ln_factor
                     from jaql589
                    where jaql589codzon = ln_codzon
                      and jaql589mes = ln_mes
                      and jaql589anio = ln_anio;
              exception when others then
                  ln_factor := 0;               
              end;



              --calcular
              --MES 1
              if ln_mes = 1 then
                ln_metcli := ceil(ln_cliente*ln_factor);
              else
                ln_metcli := round(ln_cliente*ln_factor,0);
              end if;  
              
              ln_metsal := round(ln_saldo * ln_factor,2);
              
              
              if ln_mes = 12 then
                 ln_metcli := ln_totcli;
                 ln_metsal := ln_totmet;
              else
                ln_totmet := ln_totmet - ln_metsal;
                ln_totcli := ln_totcli - ln_metcli;
              end if;

              -- dbms_output.put_line('FACTOR '||ln_factor||' mes '||ln_mes||' cli-'||ln_metcli||' sal-'||ln_metsal );
              
              --insertar en tabla JAQL590
              insert into JAQL590
              (jaql590codana,jaql590mes,jaql590metsdo,jaql590metcli,jaql590anio,jaql590age,jaql590zon,jaql590fec, jaql590est)
              values(lc_codusu,ln_mes,ln_metsal, ln_metcli,ln_anio,ln_codsuc,ln_codzon,pd_fecpro, 'S');
                 
              
              ln_mes := ln_mes + 1;
           
           end loop;  
      
        end if; --fin de valida analista
        
  --end loop; --listado analistas


end sp_cr_MetasFactor;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
Function fn_cr_AnalistaPC(pc_analista IN varchar2,pd_fecpro in date, pc_codcaja in varchar2 ) return char is
    -- *****************************************************************
    -- Nombre                     : fn_cr_AnalistaPC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.02.08
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio /Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcli char(2);
    cursor saldo is
      select /*+all_rows */
       decode(JAQL965MOD, 107, 107, 100) modulo, sum(JAQL965SDMN) saldo
        from JAQL965
       where JAQL965FECH = pd_fecpro
         and JAQL965ASE = pc_analista
         and JAQL965MOD not in (108, 33, 200)
         and --(JAQL965MOD <> 106 Or JAQL965TOP <> 30)
         (case when JAQL965MOD = 106 and JAQL965TOP = 30 then 0 else 1 end) = 1
       group by decode(JAQL965MOD, 107, 107, 100);
       
  lc_tipana char(1);
  ln_saldo number;       
  ld_fecha date;
  lc_analista char(10):= rpad(pc_analista, 10, ' ');
  
  begin
  
    ---2016.03.18 verificar si existe
    begin
        select trim(jaql583tase) 
          into lc_tipana
          from jaql583
         where jaql583usu = lc_analista 
           and jaql583fpro = to_date('2015.12.31','yyyy.mm.dd'); 
    exception when no_data_found then
              lc_tipana := null;
    end;
  
    if lc_tipana is null then
          --verificar el mes inicial que tuvo cartera
            begin
                  select min(jaql583fpro) 
                    into ld_fecha
                    from jaql583
                   where jaql583usu = lc_analista 
                     and jaql583fpro > to_date('2015.12.31','yyyy.mm.dd'); 
              exception when no_data_found then
                        ld_fecha := null;
              end;   
           --se calcula clasificacion a la fecha de proceso
            begin
                  select trim(jaql583tase) 
                    into lc_tipana
                    from jaql583
                   where jaql583usu = lc_analista 
                     and jaql583fpro = ld_fecha; 
              exception when no_data_found then
                        lc_tipana := null;
              end;

          --- si es nula es la primera vez que se calcula su clasificacion
          if lc_tipana is null then
  
  
                ---determinando clasificacion por saldo
                 if  trim(pc_codcaja) = 'A' then      

                       ln_saldo := 0;
                       
                       for i in saldo loop
                          if  i.saldo > ln_saldo  then   
                             if i.modulo = 107 then
                                lc_tipana := 'C';
                             else
                                lc_tipana := 'P';    
                             end if;
                         
                             
                             ln_saldo := i.saldo;
                          end if;   
                       end loop;
                       
                     if ln_saldo = 0 then --2014.03.14 si analista no tiene saldo le corresponde clasificacion PYMES
                       lc_tipana := 'P'; 
                    end if;     
                 else
                    lc_tipana := 'P'; --todos los q no pertenecen a Caja AQP son PYMES.
                 end if;   

          end if;        
         
    end if;      --2016.03.18

    return lc_tipana;

  end fn_cr_AnalistaPC;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Procedure sp_cr_RetornaMeta(pc_codase in char,
                            pn_codage in number,
                            pn_mes in number,
                            pn_anio in number,           
                            pn_metsdo out number,
                            pn_metcli out number
          ) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MetasFeb15
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.02.08
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : RETORNA META SALDO Y CLIENTE POR MES 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : CODIGO DE ANALISTA (CHAR)
    -- Parámetros de Salida       : META SALDO, META CLIENTE DEL MES
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
  ln_saldo number; 
  ln_cliente number;
       
begin
   
    begin
         select jaql590metsdo, jaql590metcli
           into ln_saldo, ln_cliente
           from JAQL590     
          where jaql590codana = pc_codase
            and jaql590age = pn_codage
            and jaql590mes = pn_mes
            and jaql590anio = pn_anio            
            and jaql590est = 'S';
      exception when no_data_found then
           ln_saldo := 0; 
           ln_cliente := 0;
      end;
   
 
      pn_metsdo := ln_saldo;
      pn_metcli := ln_cliente;
      
end sp_cr_RetornaMeta;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_MoraMin(pc_JAQL591tase in varchar2,
                       pn_JAQL591codcat in number,
                       pn_JAQL591cantage in number )              
                               return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MoraMin
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/02/2016
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA LA MÍNIMA MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL587CODANA
    -- Parámetros de Salida       : MÍNIMA MORA
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
pn_jaql591min number;  
lc_tase varchar(3);  



begin
  
lc_tase := trim(pc_JAQL591tase);
   
   begin
     ---1
     
     select min(jaql591min)
      into pn_jaql591min
      from jaql591
      where trim(JAQL591tase) = lc_tase --pc_JAQL591tase
      and JAQL591codcat = pn_JAQL591codcat
      and JAQL591cantage = pn_JAQL591cantage; 
    
    
    
   exception
     when no_data_found then
       --2
       
       pn_jaql591min:=0;       
       
   end; --3
  return   pn_jaql591min;
  
end fn_cr_MoraMin;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_PjeCastigo(pc_JAQL591tase in varchar2,
                       pn_JAQL591codcat in number,
                       pn_JAQL591cantage in number,
                       pn_MoraIngresada in number )              
                               return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_PjeCastigo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/02/2016
    -- Autor de Creación          : RLIVISI 
    -- Uso                        : RETORNA EL PORCENTAJE CASTIGO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : JAQL587CODANA
    -- Parámetros de Salida       : PORCENTAJE CASTIGO
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
pn_jaql591cas number;  
lc_tase varchar(3);  
begin
   
   lc_tase := trim(pc_JAQL591tase);


/* REEMPLAZAR Y VALIDAR VARIABLES
        select jaql591cas
            into ln_castigo
            from jaql591
            where trim(JAQL591tase) = lc_tipoase
            and JAQL591tusu = i.jaql583ivi --i..vi
            and JAQL591NEO =  i.jaql583neo -- neo
            and JAQL591MIN <= i.jaql583pmra
            and JAQL591MAX > i.jaql583pmra;*/
--modificar

   begin
     ---1
      select jaql591cas
      into pn_jaql591cas
      from jaql591
      where trim(JAQL591tase) = lc_tase --trim(pc_JAQL591tase)
      and JAQL591codcat = pn_JAQL591codcat
      and JAQL591cantage = pn_JAQL591cantage
      and JAQL591MIN <= pn_MoraIngresada
      and JAQL591MAX > pn_MoraIngresada;
    
   exception
     when no_data_found then
       --2
       pn_jaql591cas:=0;       
   end; --3
   
   
  return  pn_jaql591cas;
  
end fn_cr_PjeCastigo;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos_diario(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.11.27
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se modifico llamada a calculo saldo maximo
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

   select --/*+all_rows */ 
        /*+index_ss(a) index_ss(car) index_ss(deca) index_ss(f)*/ 
          deca.sng055dsc cargo,/*car2.cargocod ,*/ jaql965ase,-- cod_analista, 
           agtesuc agencia,
           sum(a.jaql965sdmn) Saldo_cartera, 
           count(distinct a.jaql965ndoc) Nro_clientes--,
      from JAQL965 a,  
           SNG057 car, 
           sng055 deca,
           fst156 f
    where 
      deca.sng055emp = car.sng055emp
      and deca.sng055emp = 1
      and car.sng055car = deca.sng055car 
      and car.sng055car in (200,201) --analista creditos / analista senior
      and a.jaql965fech = ld_fecpro
      and a.jaql965ase = car.sng057usr
      and f.agteusr = a.jaql965ase    
      and a.jaql965mod not in (108, 33, 200) 
      and (case when a.jaql965mod = 106 and a.jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
      and agtesuc = lc_sucurs --QUITAR COMENTARIO
      --AND TRIM(a.jaql965ase) = 'WMEDINA'--'SLIZARRAGA'  08Jul2015
       and (a.jaql965cta, a.jaql965oper , a.jaql965ase) 
          not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j) --excluir a tabla de EXCEPCIONEs
    group by deca.sng055dsc,
           a.jaql965ase, 
           agtesuc;

 lc_Tipo_analista jaql577.jaql577tipo%type;
 ln_metasal number := 0;
 ln_metacli number := 0;
 ln_metamor number := 0;
 lc_tipage jaql570.jaql570age%type;
 ln_calcli jaql570.jaql570tipo%type;
 ln_calsal jaql570.jaql570tipo%type;
 ln_nummes number:=0;
 ln_numdia number:=0;
 lc_5030 char(4);
 lc_cmesal number := 0;
 lc_cmecli number := 0;      
 
 ln_Saldo_Otorgado number;
 ln_Saldo_Recibido number;
 ln_Cliente_Otorgado number;
 ln_Cliente_recibido number;
 ln_Por_Mora  number;
 ln_Clientes_Nuevos  number;
 ln_sal_cre_mes_anterior number;
 ln_Nro_cli_mes_anterior number;
 ln_Sal_maximo  number;
 ln_Cli_maximo  number;
 ln_Fec_CliMax  date;
 ln_Fec_SalMax   date;
 lc_Tipo_ana varchar2(4);
 lc_Tipo_agencia varchar2(4);
 ln_Rango_5000 number;
 ln_Rango_20000 number;
 ln_Rango_50000 number;
 ln_Rango_100000 number;
 ln_Rango_100001 number;
 ln_saltot  number;
 ln_clitot  number;
 ln_salmor number;
 ln_saljud number;
 ln_cont NUMBER;
 ln_salcas number;
 ln_salrec number; 
 ln_numrec number; 
 
 ln_nuevo_sal number ; -- para recalculo
 ln_nuevo_cli number ; -- para recalculo
 
 ln_saldo_vencido number; --saldo vencido
 ln_saldo_refinan number; --saldo refinanciado
  
 
  --2016.02.08 ----16.02.2016
 ln_tipmer number;
 lc_codcaja char(3);
 --2016.02.08  ---16.02.2016
 
 lc_Tipo_IVI char(3);
 lc_tipo_NEO char(1);
 
 ln_agencia number; --2016.05.12
 
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop

       --2016.05.12 excepciones para analistas cesados -retorna agencia antes del cese.
       begin
         select tp1nro1 
           into ln_agencia
           from fst198 
          where tp1cod =1 
            and tp1cod1 = 10847 
            and tp1corr1 = 9 and tp1desc = i.jaql965ase;
       exception when no_data_found then
            ln_agencia := null;                 
       end;
       
       if ln_agencia is null then
          ln_agencia := i.agencia;
       end if;
       -----------
 
       ln_Saldo_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);
       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);

       ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgadoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0); 
       ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibidoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);

       ln_saldo_vencido :=  pq_cr_productividad_ana.fn_pa_sal_vencido(i.jaql965ase,pd_fecpro);
       ln_saldo_refinan :=  pq_cr_productividad_ana.fn_pa_sal_refinan(i.jaql965ase,pd_fecpro);
   
         begin
           select /*+parallel(j,2) */count(*)
             into ln_cont
             from jaql966 j
            where jaql966usr = i.jaql965ase and jaql966suc = ln_agencia/*i.agencia*/;
         exception when no_data_found then
              ln_cont := 0;
         end; 
         
         if ln_cont > 0 then
           ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/);
         else
            ln_nummes := 0;       
         end if;
          
         ln_saljud := pq_cr_productividad_ana.fn_cr_sal_judicial(i.jaql965ase,pd_fecpro);
         ln_salmor := pq_cr_productividad_ana.fn_pa_saldo_mora(i.jaql965ase,pd_fecpro); --saldo mora  > 15 dias
         ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(i.jaql965ase,pd_fecpro);

   
         if  ln_nummes <= 6 then
             --lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista_cal(i.jaql965ase,pd_fecpro);
             ---2014.03.13 --SI ES MENOR A 6 MESES NO CONSIDERAR SALDO MORA DE RECUPERACION LEGAL
             ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_numrec := pq_cr_productividad_ana.fn_pa_num_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_salmor := ln_salmor - ln_salrec;
             ---
             ln_nuevo_sal := i.Saldo_cartera - ln_salrec;
             ln_nuevo_cli := i.Nro_clientes - ln_numrec;
             --
             
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido - ln_salrec; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido - ln_numrec;
             
         else     
             --lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista(i.jaql965ase,pd_fecpro);
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido;
             ln_nuevo_sal := i.Saldo_cartera;
             ln_nuevo_cli := i.Nro_clientes;
             
         end if;
       
      
     
       ln_Clientes_Nuevos := pq_cr_productividad_ana.fn_pa_cliente_new (i.jaql965ase,pd_fecpro); 
       ln_sal_cre_mes_anterior := pq_cr_productividad_ana.fn_cr_saldo_anterior(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/); 
       ln_Nro_cli_mes_anterior := pq_cr_productividad_ana.fn_cr_nrocli_anterior(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/);   
       ln_Fec_CliMax := pq_cr_productividad_ana.fn_cr_fecha_cli_mes_base(i.jaql965ase, pd_fecpro);
       ln_Fec_SalMax  := pq_cr_productividad_ana.fn_cr_fecha_sal_mes_base(i.jaql965ase, pd_fecpro);                                                  
       lc_Tipo_agencia := pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(ln_agencia/*i.agencia*//*i.jaql965suc*/,pd_fecpro); 
       
       
       ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/,ln_salmor,ln_saljud, ln_nuevo_sal);
                                                        
        --2016
        lc_Tipo_analista :=  pq_cr_productividad_ana.fn_cr_categoriarrhh( i.jaql965ase , pd_fecpro);


        begin
          pq_cr_productividad_ana.sp_cr_metasene16(pn_jaql586codage => ln_agencia /*i.agencia*/,
                                                   pn_jaql586ctipmer => ln_tipmer,
                                                   pn_jaql586cantage => lc_Tipo_agencia,
                                                   pc_jaql586caja => lc_codcaja);
        end;   
        
         
        
        lc_Tipo_ana := pq_cr_productividad_ana.fn_cr_analistapc(pc_analista => i.jaql965ase,
                                                                pd_fecpro => pd_fecpro,
                                                                pc_codcaja => lc_codcaja);
        
        
        
         
        
        
        begin
          pq_cr_productividad_ana.sp_cr_metasfactor(pd_fecpro => pd_fecpro,
                                                    pc_codana => i.jaql965ase,
                                                    pn_codage => ln_agencia/*i.agencia*/,
                                                    pc_codcaj => lc_codcaja,
                                                    pn_tipmer => ln_tipmer,
                                                    pn_antage => lc_Tipo_agencia,
                                                    pn_codcat => lc_Tipo_analista,
                                                    pc_tipusu => lc_Tipo_ana);
        end;
        
        begin
          pq_cr_productividad_ana.sp_cr_retornameta(pc_codase => i.jaql965ase,
                                                    pn_codage => ln_agencia/*i.agencia*/,
                                                    pn_mes => to_char(pd_fecpro,'MM'),
                                                    pn_anio => to_char(pd_fecpro,'RRRR'),
                                                    pn_metsdo => ln_metasal,
                                                    pn_metcli => ln_metacli);
        end;
        
        

               
        /* Inicio 2016.03.28 */
        --tipo agencia NEO
        lc_tipo_NEO :=trim(pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(ln_agencia/*i.agencia*/,pd_fecpro)) ;
        --tipo asesor I_VI
        lc_Tipo_IVI := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,lc_tipo_NEO,ln_nuevo_sal/*i.Saldo_cartera*/);
        --obtener mora
        ln_metamor := pq_cr_productividad_ana.fn_cr_moraminima(pc_jaql591tase => lc_Tipo_ana,
                                                      pc_jaql591codcat => lc_Tipo_IVI,
                                                      pc_jaql591cantage => lc_tipo_NEO);  
        
         /*  se comento Meta Mora - descomentar si se mantiene calculo por Antiguedad Agencia
           ln_metamor := pq_cr_productividad_ana.fn_cr_moramin(pc_jaql591tase => lc_Tipo_ana,
                                                              pn_jaql591codcat => lc_Tipo_analista,
                                                              pn_jaql591cantage => lc_Tipo_agencia);
       
        */ 

        /* Fin 2016.03.28 */ 
        
        --2016
          
         /*
         BEGIN
          pq_cr_productividad_ana.sp_cr_retorna_metas(pc_jaql579tip => lc_Tipo_analista ,
                                              pc_jaql579tase => lc_Tipo_ana,
                                              pc_tipage => lc_Tipo_agencia,
                                              pn_agencia => i.agencia,
                                              pc_codusu => i.jaql965ase,
                                              pn_metasal => ln_metasal ,
                                              pn_metacli => ln_metacli ,
                                              pn_metamor => ln_metamor );
         EXCEPTION WHEN OTHERS THEN
               ln_metasal := NULL;                                         
               ln_metacli := NULL;
               ln_metamor := NULL;               
               
         END;                                     
         */                                     
        
         lc_tipage := pq_cr_productividad_ana.fn_cr_tipo_agencia(ln_agencia/*i.agencia*//*i.jaql965suc*/);
         ln_calcli := pq_cr_productividad_ana.fn_cr_cliente_cali(lc_tipage, ln_nuevo_cli /*i.Nro_clientes */);
         ln_calsal := pq_cr_productividad_ana.fn_cr_credito_cali(lc_tipage, ln_nuevo_sal /*i.Saldo_cartera*/);
         
         lc_5030 := pq_cr_productividad_ana.fn_cr_tipo_analista(lc_Tipo_agencia,lc_tipage, ln_nuevo_cli /*i.Nro_clientes*/);
         
        


         
       insert into jaql583 (jaql583fpro,jaql583usu, jaql583age, jaql583tusu, jaql583sdo, jaql583ncl, jaql583pmra,
              jaql583soto, jaql583srec, jaql583cot, jaql583crec, jaql583ncn, 
              jaql583sant, jaql583cant, jaql583smax, jaql583cmax, jaql583tage, jaql583fsmax, jaql583fcmax, 
              jaql583mtsa, jaql583mtcl, jaql583mtmr,
              jaql583est, jaql583mant, jaql583dant, jaql583pcod, jaql583tase, jaql583c5030, jaql583lage,
              jaql583sdju, jaql583sdtot, jaql583cltot, jaql583sdm, jaql583sdca, jaql583sdve, jaql583sdre,
              jaql583ctipmer, jaql583codcat, jaql583cantage , jaql583caja, jaql583neo, jaql583ivi
              
               )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_agencia/*i.agencia*//*i.jaql965suc*/, lc_Tipo_analista, 
                ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, ln_Por_Mora,
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, ln_Clientes_Nuevos,
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, ln_Sal_maximo, ln_Cli_maximo, lc_Tipo_agencia,
                ln_Fec_SalMax, ln_Fec_CliMax,
                ln_metasal, ln_metacli, ln_metamor,'S',
                ln_nummes,  ln_numdia, 1, lc_Tipo_ana, lc_5030, lc_tipage,
                ln_saljud, ln_saltot, ln_clitot, ln_salmor, ln_Salcas , ln_saldo_vencido, ln_saldo_refinan,
                ln_tipmer, lc_Tipo_analista, lc_Tipo_agencia, lc_codcaja, lc_tipo_NEO,lc_Tipo_IVI
                );
       
       commit; 

        
       ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/);    
       ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/);         
        
       /*if ln_Sal_maximo <= 0 then--2015.05.11 si meses de antiguedad = 1 en la agencia, saldo maximo = meta saldo, clientes maximo = meta clientes
          if ln_nummes = 1  then 
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
          end if;              
        end if;  --2015.05.11
       */

         
        -- if ln_nummes = 1  then 
           --si pertenecia a otra agencia y tuvo traslados
           if ln_Sal_maximo <= 0  then
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
           end if;  
           /*if ln_sal_cre_mes_anterior = 0 then
             ln_sal_cre_mes_anterior := ln_metasal;    
             ln_Nro_cli_mes_anterior := ln_metacli;  
           end if;*/
           
             /*update jaql583
                set jaql583sant=jaql583mtsa,
                    jaql583cant=jaql583mtcl
              where jaql583usu = i.jaql965ase
                and jaql583fpro = pd_fecpro;*/
         -- end if;   
          
          /*if ln_sal_cre_mes_anterior = 0 then
              update jaql583
                  set jaql583sant = ln_metasal,
                      jaql583cant = ln_metacli
                where jaql583usu  = i.jaql965ase
                  and jaql583fpro = pd_fecpro;  
          end if;   */         
                 
       
       update jaql583
                set jaql583smax=ln_Sal_maximo,
                    jaql583cmax=ln_Cli_maximo
              where jaql583usu = i.jaql965ase
                and jaql583fpro = pd_fecpro;
       commit; 
                      
        --inserta JAQL572
         
         /*dbms_output.put_line('lc_Tipo_analista '||lc_Tipo_analista);
         dbms_output.put_line('ln_metasal '||ln_metasal);
         dbms_output.put_line('ln_metacli '||ln_metacli);
         dbms_output.put_line('ln_metamor '||ln_metamor);*/
         
       
       lc_cmesal := ln_saltot - ln_sal_cre_mes_anterior; -- crecimiento mensual saldo
       lc_cmecli := ln_clitot - ln_Nro_cli_mes_anterior; --crecimiento mensual clientes 
       
       insert into jaql572 (jaql572fpro, jaql572usu, JAQL572scre, jaql572ncli, jaql572cod, jaql572agen, jaql572ccli, 
                            jaql572csal, jaql572sant, jaql572ncl, jaql572tage, jaql572soto, jaql572srec,
                            jaql572coto, jaql572crec, jaql572est, jaql572mant, jaql572dant,
                            jaql572cme,  jaql572cmcl )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, 1, 
                ln_agencia/*i.agencia*//*i.jaql965suc*/,  trim(ln_calcli), trim(ln_calsal),--clasif cliente, clasif saldo
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, lc_tipage,--tipo agencia
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, 'S',
                ln_nummes,  ln_numdia, lc_cmesal, lc_cmecli
              );
       
       commit; 
   
   end loop;  
   commit; 

 end sp_cr_carga_datos_diario;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(pc_sucurs in varchar2 , pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.10.25
    -- Autor de Creación          : 
    -- Uso                        : CARGA DATOS PRODUCTIVIDAD EN JAQL572 y JAQL583
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


cursor creditos(lc_sucurs varchar2, ld_fecpro date) is

 select --/*+all_rows */ 
        /*+index_ss(a) index_ss(car) index_ss(deca) index_ss(f)*/ 
          deca.sng055dsc cargo,/*car2.cargocod ,*/ jaql965ase,-- cod_analista, 
         --  a.jaql965ase,
          /* agtenom analista,*/ 
           agtesuc agencia,
           --a.jaql965suc,/*scnom nombre_agencia,*/
           --pq_cr_productividad_ana.fn_pa_tip_analista(jaql965ase) Tipo_analista ,
           sum(a.jaql965sdmn) Saldo_cartera, 
           count(distinct a.jaql965ndoc) Nro_clientes--,
       from JAQL965 a,  
           /*SNG057_201405*/ sng057_201X car, 
           /*sng055_201405*/ sng055_201X deca,
           /*fst156_201405*/ fst156_201X f /*,
           fst001 f1 */
    where 
      deca.sng055emp = car.sng055emp
      and deca.sng055emp = 1
      and car.sng055car = deca.sng055car 
      and car.sng055car in (200,201) --analista creditos / analista senior
      and a.jaql965fech = ld_fecpro
      and a.jaql965ase = car.sng057usr
      and f.agteusr = a.jaql965ase    
      --and a.jaql965mod not in (108, 33, 200) and (a.jaql965mod <> 106 Or a.jaql965top <> 30)  --no incluye judiciales
      and a.jaql965mod not in (108, 33, 200) 
      and (case when a.jaql965mod = 106 and a.jaql965top IN ( 30/*,31*/) then 0 else 1 end) = 1
      and agtesuc = lc_sucurs --QUITAR COMENTARIO
  --2017    AND TRIM(a.jaql965ase) in ('JAGUIRRE','FHERRERAP','RARIAS','FOREJON','JCANDIOTTI','RFLORESN','JLOPEZV','APOMAZ')  --COMENTAR --12012017
       and (a.jaql965cta, a.jaql965oper , a.jaql965ase) 
          not in (select j.jaql970cta, j.jaql970oper , j.jaql970ase from jaql970 j) --excluir a tabla de EXCEPCIONEs
    group by deca.sng055dsc,
           a.jaql965ase, 
           agtesuc;

 lc_Tipo_analista jaql577.jaql577tipo%type;
 ln_metasal number := 0;
 ln_metacli number := 0;
 ln_metamor number := 0;
 lc_tipage jaql570.jaql570age%type;
 ln_calcli jaql570.jaql570tipo%type;
 ln_calsal jaql570.jaql570tipo%type;
 ln_nummes number:=0;
 ln_numdia number:=0;
 lc_5030 char(4);
 lc_cmesal number := 0;
 lc_cmecli number := 0;      
 
 ln_Saldo_Otorgado number;
 ln_Saldo_Recibido number;
 ln_Cliente_Otorgado number;
 ln_Cliente_recibido number;
 ln_Por_Mora  number;
 ln_Clientes_Nuevos  number;
 ln_sal_cre_mes_anterior number;
 ln_Nro_cli_mes_anterior number;
 ln_Sal_maximo  number;
 ln_Cli_maximo  number;
 ln_Fec_CliMax  date;
 ln_Fec_SalMax   date;
 lc_Tipo_ana varchar2(4);
 lc_Tipo_agencia varchar2(4);
 ln_Rango_5000 number;
 ln_Rango_20000 number;
 ln_Rango_50000 number;
 ln_Rango_100000 number;
 ln_Rango_100001 number;
 ln_saltot  number;
 ln_clitot  number;
 ln_salmor number;
 ln_saljud number;
 ln_cont NUMBER;
 ln_salcas number;
 ln_salrec number; 
 ln_numrec number; 
 
 ln_nuevo_sal number ; -- para recalculo
 ln_nuevo_cli number ; -- para recalculo

 ln_saldo_vencido number; --saldo vencido
 ln_saldo_refinan number; --saldo refinanciado
 
 --2016.02.08
 ln_tipmer number;
 lc_codcaja char(3);
 --2016.02.08
 
 lc_Tipo_IVI char(3);
 lc_tipo_NEO char(1);
 
 ln_agencia number; --2016.05.12
 
begin

   for i in creditos(pc_sucurs, pd_fecpro) loop

       --2016.05.12 excepciones para analistas cesados -retorna agencia antes del cese.
       begin
         select tp1nro1 
           into ln_agencia
           from fst198 
          where tp1cod =1 
            and tp1cod1 = 10847 
            and tp1corr1 = 9 and tp1desc = i.jaql965ase
            and tp1nro2 = 1;
       exception when no_data_found then
            ln_agencia := null;                 
       end;
       
       if ln_agencia is null then
          ln_agencia := i.agencia;
       end if;
       ---
 
       ln_Saldo_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Sal_otorgadoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);
       ln_Saldo_Recibido := nvl(pq_cr_productividad_ana.fn_pa_Sal_recibidoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);

       ln_Cliente_Otorgado := nvl(pq_cr_productividad_ana.fn_pa_Cli_otorgadoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0); 
       ln_Cliente_recibido := nvl(pq_cr_productividad_ana.fn_pa_Cli_recibidoNew(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/),0);

       ln_saldo_vencido :=  pq_cr_productividad_ana.fn_pa_sal_vencido(i.jaql965ase,pd_fecpro);
       ln_saldo_refinan :=  pq_cr_productividad_ana.fn_pa_sal_refinan(i.jaql965ase,pd_fecpro);
   
         begin
           select /*+parallel(j,2) */count(*)
             into ln_cont
             from jaql966 j
            where jaql966usr = i.jaql965ase and jaql966suc = ln_agencia/*i.agencia*/;
         exception when no_data_found then
              ln_cont := 0;
         end; 
         
         if ln_cont > 0 then
           ln_nummes := pq_cr_productividad_ana.fn_cr_contmes_anterior(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/);
         else
            ln_nummes := 0;       
         end if;
          
         ln_saljud := pq_cr_productividad_ana.fn_cr_sal_judicial(i.jaql965ase,pd_fecpro);
         ln_salmor := pq_cr_productividad_ana.fn_pa_saldo_mora(i.jaql965ase,pd_fecpro); --saldo mora  > 15 dias
         ln_salcas := pq_cr_productividad_ana.fn_cr_sal_castigado(i.jaql965ase,pd_fecpro);

   
         if  ln_nummes <= 6 then
             --lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista_cal(i.jaql965ase,pd_fecpro);
             ---2014.03.13 --SI ES MENOR A 6 MESES NO CONSIDERAR SALDO MORA DE RECUPERACION LEGAL
             ln_salrec := pq_cr_productividad_ana.fn_pa_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_numrec := pq_cr_productividad_ana.fn_pa_num_saldo_legal(i.jaql965ase,pd_fecpro); --saldo de creditos en recuperacion legal
             ln_salmor := ln_salmor - ln_salrec;
             ---
             ln_nuevo_sal := i.Saldo_cartera - ln_salrec;
             ln_nuevo_cli := i.Nro_clientes - ln_numrec;
             --
             
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido - ln_salrec; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido - ln_numrec;
             
         else     
             --lc_Tipo_ana := pq_cr_productividad_ana.fn_pa_tip_analista(i.jaql965ase,pd_fecpro);
             ln_saltot := i.Saldo_cartera + ln_Saldo_Otorgado - ln_Saldo_Recibido; 
             ln_clitot := i.Nro_clientes + ln_Cliente_Otorgado - ln_Cliente_recibido;
             ln_nuevo_sal := i.Saldo_cartera;
             ln_nuevo_cli := i.Nro_clientes;
             
         end if;
       
      
     
       ln_Clientes_Nuevos := pq_cr_productividad_ana.fn_pa_cliente_new (i.jaql965ase,pd_fecpro); 
       ln_sal_cre_mes_anterior := pq_cr_productividad_ana.fn_cr_saldo_anterior(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/); 
       ln_Nro_cli_mes_anterior := pq_cr_productividad_ana.fn_cr_nrocli_anterior(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/);   
       ln_Fec_CliMax := pq_cr_productividad_ana.fn_cr_fecha_cli_mes_base(i.jaql965ase, pd_fecpro);
       ln_Fec_SalMax  := pq_cr_productividad_ana.fn_cr_fecha_sal_mes_base(i.jaql965ase, pd_fecpro);                                                  
       lc_Tipo_agencia := pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(ln_agencia/*i.agencia*//*i.jaql965suc*/,pd_fecpro); 
       
       
       ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql965ase,pd_fecpro,ln_agencia/*i.agencia*/,ln_salmor,ln_saljud, ln_nuevo_sal);
                                                        
        --2016
        lc_Tipo_analista :=  pq_cr_productividad_ana.fn_cr_categoriarrhh( i.jaql965ase, pd_fecpro );


        begin
          pq_cr_productividad_ana.sp_cr_metasene16(pn_jaql586codage => ln_agencia/*i.agencia*/,
                                                   pn_jaql586ctipmer => ln_tipmer,
                                                   pn_jaql586cantage => lc_Tipo_agencia,
                                                   pc_jaql586caja => lc_codcaja);
        end;   
        
         
        
        lc_Tipo_ana := pq_cr_productividad_ana.fn_cr_analistapc(pc_analista => i.jaql965ase,
                                                                pd_fecpro => pd_fecpro,
                                                                pc_codcaja => lc_codcaja);


         
        
        
        begin
          pq_cr_productividad_ana.sp_cr_metasfactor(pd_fecpro => pd_fecpro,
                                                    pc_codana => i.jaql965ase,
                                                    pn_codage => ln_agencia/*i.agencia*/,
                                                    pc_codcaj => lc_codcaja,
                                                    pn_tipmer => ln_tipmer,
                                                    pn_antage => lc_Tipo_agencia,
                                                    pn_codcat => lc_Tipo_analista,
                                                    pc_tipusu => lc_Tipo_ana);
        end;
 
        
        
        begin
          pq_cr_productividad_ana.sp_cr_retornameta(pc_codase => i.jaql965ase,
                                                    pn_codage => ln_agencia/*i.agencia*/,
                                                    pn_mes => to_char(pd_fecpro,'MM'),
                                                    pn_anio => to_char(pd_fecpro,'RRRR'),
                                                    pn_metsdo => ln_metasal,
                                                    pn_metcli => ln_metacli);
        end;
        

        
        /* Inicio 2016.03.28 */
        --tipo agencia NEO
        lc_tipo_NEO :=trim(pq_cr_productividad_ana.fn_cr_tipo_agencia_metas(ln_agencia/*i.agencia*/,pd_fecpro)) ;
        --tipo asesor I_VI
        lc_Tipo_IVI := pq_cr_productividad_ana.fn_cr_asesor_tipo(lc_Tipo_ana,lc_tipo_NEO,ln_nuevo_sal/*i.Saldo_cartera*/);
        --obtener mora
        ln_metamor := pq_cr_productividad_ana.fn_cr_moraminima(pc_jaql591tase => lc_Tipo_ana,
                                                      pc_jaql591codcat => lc_Tipo_IVI,
                                                      pc_jaql591cantage => lc_tipo_NEO);  
        
         /*  se comento Meta Mora - descomentar si se mantiene calculo por Antiguedad Agencia
           ln_metamor := pq_cr_productividad_ana.fn_cr_moramin(pc_jaql591tase => lc_Tipo_ana,
                                                              pn_jaql591codcat => lc_Tipo_analista,
                                                              pn_jaql591cantage => lc_Tipo_agencia);
       
        */ 

        /* Fin 2016.03.28 */                                                       

        
        
        --2016
          
         /*
         BEGIN
          pq_cr_productividad_ana.sp_cr_retorna_metas(pc_jaql579tip => lc_Tipo_analista ,
                                              pc_jaql579tase => lc_Tipo_ana,
                                              pc_tipage => lc_Tipo_agencia,
                                              pn_agencia => i.agencia,
                                              pc_codusu => i.jaql965ase,
                                              pn_metasal => ln_metasal ,
                                              pn_metacli => ln_metacli ,
                                              pn_metamor => ln_metamor );
         EXCEPTION WHEN OTHERS THEN
               ln_metasal := NULL;                                         
               ln_metacli := NULL;
               ln_metamor := NULL;               
               
         END;                                     
         */                                     
        
         lc_tipage := pq_cr_productividad_ana.fn_cr_tipo_agencia(ln_agencia/*i.agencia*//*i.jaql965suc*/);
         ln_calcli := pq_cr_productividad_ana.fn_cr_cliente_cali(lc_tipage, ln_nuevo_cli /*i.Nro_clientes */);
         ln_calsal := pq_cr_productividad_ana.fn_cr_credito_cali(lc_tipage, ln_nuevo_sal /*i.Saldo_cartera*/);
         
         lc_5030 := pq_cr_productividad_ana.fn_cr_tipo_analista(lc_Tipo_agencia,lc_tipage, ln_nuevo_cli /*i.Nro_clientes*/);
         
         
       insert into jaql583 (jaql583fpro,jaql583usu, jaql583age, jaql583tusu, jaql583sdo, jaql583ncl, jaql583pmra,
              jaql583soto, jaql583srec, jaql583cot, jaql583crec, jaql583ncn, 
              jaql583sant, jaql583cant, jaql583smax, jaql583cmax, jaql583tage, jaql583fsmax, jaql583fcmax, 
              jaql583mtsa, jaql583mtcl, jaql583mtmr,
              jaql583est, jaql583mant, jaql583dant, jaql583pcod, jaql583tase, jaql583c5030, jaql583lage,
              jaql583sdju, jaql583sdtot, jaql583cltot, jaql583sdm, jaql583sdca, jaql583sdve, jaql583sdre,
              jaql583ctipmer, jaql583codcat, jaql583cantage , jaql583caja, jaql583neo, jaql583ivi
               )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_agencia/*i.agencia*//*i.jaql965suc*/, lc_Tipo_analista, 
                ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, ln_Por_Mora,
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, ln_Clientes_Nuevos,
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, ln_Sal_maximo, ln_Cli_maximo, lc_Tipo_agencia,
                ln_Fec_SalMax, ln_Fec_CliMax,
                ln_metasal, ln_metacli, ln_metamor,'S',
                ln_nummes,  ln_numdia, 1, lc_Tipo_ana, lc_5030, lc_tipage,
                ln_saljud, ln_saltot, ln_clitot, ln_salmor, ln_Salcas , ln_saldo_vencido, ln_saldo_refinan,
                ln_tipmer, lc_Tipo_analista, lc_Tipo_agencia, lc_codcaja, lc_tipo_NEO,lc_Tipo_IVI
              );
       
       commit; 

        
       ln_Sal_maximo := pq_cr_productividad_ana.fn_cr_saldo_mes_base(i.jaql965ase, pd_fecpro, ln_agencia /*i.agencia*/);    
       ln_Cli_maximo := pq_cr_productividad_ana.fn_cr_cliente_mes_base(i.jaql965ase, pd_fecpro, ln_agencia/*i.agencia*/);         
        
       /*if ln_Sal_maximo <= 0 then--2015.05.11 si meses de antiguedad = 1 en la agencia, saldo maximo = meta saldo, clientes maximo = meta clientes
          if ln_nummes = 1  then 
             ln_Sal_maximo := ln_metasal;    
             ln_Cli_maximo := ln_metacli; 
          end if;              
        end if;  --2015.05.11
       */

        
        -- if ln_nummes = 1  then 
             --si pertenecia a otra agencia y tuvo traslados
             if ln_Sal_maximo <= 0  then
               ln_Sal_maximo := ln_metasal;    
               ln_Cli_maximo := ln_metacli; 
             end if;  
             /*if ln_sal_cre_mes_anterior = 0 then
               ln_sal_cre_mes_anterior := ln_metasal;    
               ln_Nro_cli_mes_anterior := ln_metacli;  
             end if;*/
             
               /*update jaql583
                  set jaql583sant=jaql583mtsa,
                      jaql583cant=jaql583mtcl
                where jaql583usu = i.jaql965ase
                  and jaql583fpro = pd_fecpro;*/
          --end if;              
                
          
          /*if ln_sal_cre_mes_anterior = 0 then
              update jaql583
                  set jaql583sant = ln_metasal,
                      jaql583cant = ln_metacli
                where jaql583usu  = i.jaql965ase
                  and jaql583fpro = pd_fecpro;  
          end if;    */  

       
       update jaql583
                set jaql583smax = ln_Sal_maximo,
                    jaql583cmax = ln_Cli_maximo
              where jaql583usu  = i.jaql965ase
                and jaql583fpro = pd_fecpro;
       commit; 
                      
        --inserta JAQL572
         
         /*dbms_output.put_line('lc_Tipo_analista '||lc_Tipo_analista);
         dbms_output.put_line('ln_metasal '||ln_metasal);
         dbms_output.put_line('ln_metacli '||ln_metacli);
         dbms_output.put_line('ln_metamor '||ln_metamor);*/
         
       
       lc_cmesal := ln_saltot - ln_sal_cre_mes_anterior; -- crecimiento mensual saldo
       lc_cmecli := ln_clitot - ln_Nro_cli_mes_anterior; --crecimiento mensual clientes 
       
       insert into jaql572 (jaql572fpro, jaql572usu, JAQL572scre, jaql572ncli, jaql572cod, jaql572agen, jaql572ccli, 
                            jaql572csal, jaql572sant, jaql572ncl, jaql572tage, jaql572soto, jaql572srec,
                            jaql572coto, jaql572crec, jaql572est, jaql572mant, jaql572dant,
                            jaql572cme,  jaql572cmcl )
   
           
       values ( pd_fecpro, i.jaql965ase/*i.cod_analista*/, ln_nuevo_sal /*i.Saldo_cartera*/, ln_nuevo_cli /*i.Nro_clientes*/, 1, 
                ln_agencia/*i.agencia*//*i.jaql965suc*/,  trim(ln_calcli), trim(ln_calsal),--clasif cliente, clasif saldo
                ln_sal_cre_mes_anterior, ln_Nro_cli_mes_anterior, lc_tipage,--tipo agencia
                ln_Saldo_Otorgado, ln_Saldo_Recibido, ln_Cliente_Otorgado, ln_Cliente_recibido, 'S',
                ln_nummes,  ln_numdia, lc_cmesal, lc_cmecli
              );
       
       commit; 
   
   end loop;  
   commit; 
 
 end sp_cr_carga_datos;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_bonos_productividad(pn_sucurs in number, pd_fecpro in date, pc_analista in varchar2)  is
     -- *****************************************************************
    -- Nombre                     : sp_cr_calcula_bonos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : calcula el bono 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

--OBTIENE bono POR METAS Y PLUS

      cursor metas_plus(ln_sucurs number,ld_fecpro date, lc_analista char) is
       select jaql583usu, jaql583fpro,jaql583mant,jaql583dant,jaql583bsal,jaql583bcli,jaql583bmra,jaql583sdo,
              jaql583ncl,jaql583soto,jaql583srec,jaql583cot,jaql583crec,jaql583age,jaql583tusu,jaql583tage,
              jaql583sant,jaql583cant,jaql583smax,jaql583cmax,jaql583mtsa,jaql583mtcl,jaql583mtmr,jaql583ncn,
              jaql583sdcn,jaql583sdca,jaql583sdju,jaql583fcmax,jaql583fsmax,jaql583est,jaql583cmra,jaql583sdc7,
              jaql583sdc6,jaql583sdc5,jaql583sdc4,jaql583sdc3,jaql583sdc2,jaql583sdc1,jaql583tase,jaql583pmra,
              (nvl(jaql583sdo,0) + nvl(jaql583soto,0) - nvl(jaql583srec,0) )jaql583saldo,
              (nvl(jaql583ncl,0) + nvl(jaql583cot,0) - nvl(jaql583crec,0) ) jaql583cliente,
              jaql583c5030, jaql583lage, 
              --(jaql583sdtot) jaql583saldo,  --saldo total
              --(jaql583cltot) jaql583cliente, --clientes totales
              jaql583sdm, --saldo mora,
              jaql583ctipmer,
              jaql583codcat,
              jaql583cantage,
              jaql583ivi, jaql583neo
         from jaql583 j
        where jaql583fpro = ld_fecpro--;
       and jaql583usu like '%'||lc_analista||'%' 
       and j.jaql583age = ln_sucurs  
       and nvl(j.jaql583inca,'A') <> 'N';
      -- ; and jaql583mant >= 7; ---QUITAR  COMENTARIO
        
   
ln_bonosaldo number:= 0;
ln_bonocli number:= 0;
ln_bonomora number := 0;
ln_saldoanual number := 0;
ln_clienteanual number :=0;
ln_poranuals number :=0; --porc. anual saldo
ln_poranualc number :=0; --porc. anual cli
ln_plussdoanu number := 0; --plus saldo anual
ln_plusclianu number := 0; --plus clientes anual
ln_plussdomes number := 0; --plus saldo mensual
ln_plusclimes number := 0; --plus clientes mensual
ln_pormens number := 0; --porc. anual saldo
ln_pormenc number := 0; --porc. anual cliente
ln_cre_saldoanual number := 0; --crecimiento saldo anual
ln_cre_clienteanual number := 0; --crecimiento cliente anual
ln_cre_saldomes number := 0; --crecimiento saldo mensual
ln_cre_clientemes number := 0; --crecimiento saldo mensual
ln_porcentaje number := 0; --porcentaje
ln_plusnuevo number := 0; --plus
ln_bonocli1  number := 0; --bono rango 1
ln_bonocli2  number := 0; --bono rango 2
ln_bonocli3  number := 0; --bono rango 3
ln_bonocli4  number := 0; --bono rango 4
ln_bonocli5  number := 0; --bono rango 5
ln_bonocli6  number := 0; --bono rango 6
ln_bonocli7  number := 0; --bono rango 7
ln_PLUSCLINUEVO  number := 0; --total PLUS clientes nuevos
ln_mtocastigo number := 0; -- monto castigo
ln_castigo number := 0; --monto castigo tabla meta
ln_totalBONO number :=0; --total bono
ln_totalPLUS number :=0; --total plus
ln_porcla number :=0; --porcentaje cliente anual excedente
ln_porclm number :=0; --porcentaje cliente mensual excedente
ln_bonanu number :=0; --bono por excedente anual
ln_bonmen number :=0; --bono por excedente mensual
ln_total_exc_anual number :=0; --TOTAL por excedente anual
ln_total_exc_mes   number :=0; --TOTAL por excedente mensual
ln_Por_Mora number:= 0; --porcentaje de mora
ln_Por_Cliente number := 0; ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
ln_por_clientes number := 0; --porcentaje calculado de numero de clientes con relacion a meta de clientes.
lc_ind_castigo char(1); --indicador castigo por incumplimiento porcentaje ln_Por_Cliente
ln_bono_sal number := 0; --bono saldo por mantenimiento
ln_bono_cli number := 0; --bono saldo por mantenimiento
ln_castigo_mantenimiento number := 0; -- monto calculado castigado por mantenimiento
lc_analista char(20):= null;
ln_excmes number := 0; --numero de clientes excedente MES
ln_excanu number := 0; --numero de clientes excedente Anual
ln_clinuevo number := 0; --total numero de clientes nuevos
ln_totalPP number := 0; --variable total PLUS
ln_Por_Castigo number := 0; --porcentaje de castigo

lc_indexa char(2);
lc_indexm char(2);
ln_salrec number:=0;

begin

--variable porcentaje clientes exigido 60 ---ABRIL CAMBIARA 100
begin
      select tpimp
       into ln_Por_Cliente
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 1;
  end;
  
  begin
      select tpimp
       into ln_Por_Castigo
       from fst098
      where pgcod = 1
        and tpcod = 7663
        and tpcorr = 2;
  end;
  

 for i in metas_plus(pn_sucurs, pd_fecpro,pc_analista) loop

    --obtiene nuevamente la mora DE JAQL965  si se desea modificar, debe ingresar el % de mora
   -- ln_Por_Mora := pq_cr_productividad_ana.fn_pa_por_mora(i.jaql583usu,pd_fecpro,i.jaql583age);
    
    ln_Por_Mora := pq_cr_productividad_ana.fn_pa_nueva_mora(i.jaql583usu,pd_fecpro,i.jaql583age,
                                                            i.jaql583sdm,i.jaql583sdju, i.jaql583sdo);
                                                            
  ---REVISAR CLIENTES Y SALDOS QUE NO SE ESTE ALTERANDO LA INFORMACION.
  
   --2016.07.05
    if i.jaql583mtsa = 0 or i.jaql583codcat = 0 then
      
               update jaql583
                  set jaql583bsal = 0,
                      jaql583bcli = 0,
                      jaql583bmra = 0,
                      jaql583ppla = 0, 
                      jaql583pplm = 0, 
                      jaql583ppca = 0, 
                      jaql583ppcm = 0, 
                      jaql583ppcn = 0,
                      jaql583bmet = 0,
                      jaql583bplu = 0,
                      JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
                      JAQL583TOTPA = 0,  
                      jaql583inca = 'A'
                where jaql583usu  = i.jaql583usu                  
                  and jaql583fpro = pd_fecpro;
                      
                commit;
                   
                  update jaql572
                     set jaql572btot = 0,
                         jaql572mcas =  0,
                         jaql572pjcas = 0,
                         jaql572inca = 'A'
                   where jaql572usu  = i.jaql583usu                
                     and jaql572fpro = pd_fecpro;
                    
                   commit; 
    
    else
   --2016.07.05 
   
          ---BONO  ==> PAGO FIJO CUMPLIMIENTO META MENSUAL
          --I.1
               --1--obtiene bono  por cumplimiento meta saldo
               if /*i.jaql583sdo*/i.jaql583saldo > 0  --saldo total > 0
                  and (/*i.jaql583sdo*/i.jaql583saldo - i.jaql583sant)>= i.jaql583mtsa --crecimiento mensual>= metasaldo
                  then
                   ln_bonosaldo := pq_cr_productividad_ana.fn_cr_bono_saldo(i.jaql583tase);
               end if;
               
               --2--obtiene bono por cumplimiento meta cliente
               if /*i.jaql583ncl*/i.jaql583cliente > 0  --clientes total > 0
                  and (/*i.jaql583ncl*/i.jaql583cliente - i.jaql583cant)>= i.jaql583mtcl --crecimiento mensual >= metacliente
                  then
                   ln_bonocli := pq_cr_productividad_ana.fn_cr_bono_cliente(i.jaql583tase);
               end if;

                --3--obtiene bono por cumplimiento meta mora
               if ln_Por_Mora/*i.jaql583pmra*/ <= i.jaql583mtmr  --porcentaje mora >= meta mora
                  then
                  ln_bonomora := pq_cr_productividad_ana.fn_cr_bono_mora(i.jaql583tase);
                  
               end if;

               ---
               ln_totalBONO := ln_bonosaldo + ln_bonocli + ln_bonomora; --TOTAL BONO
               if ln_totalBONO > 500 then --Monto Máximo de Bono  S/. 500.00
                    ln_totalBONO := 500; 
               end if;
               ---
               
          --- ==> PAGO VARIABLE

             
               -------  obtener crecimientos   
               ln_cre_saldoanual := i.jaql583sdo/*i.jaql583saldo*/ - i.jaql583smax; --Crecimiento ANUAL SALDOS
               ln_cre_clienteanual := i.jaql583ncl /*i.jaql583cliente*/ - i.jaql583cmax; --Crecimiento ANUAL CLIENTES
               
               ln_cre_saldomes := i.jaql583saldo - i.jaql583sant; -- Crecimiento MENSUAL SALDO
               ln_cre_clientemes := i.jaql583cliente - i.jaql583cant ;  --Crecimiento MENSUAL CLIENTES
               
               ---Verificar si cumple meta de clientes de acuerdo a PORCENTAJE INDICADO
               --ln_por_clientes  := round(i.jaql583cliente * 100 / i.jaql583mtcl , 0);
               ln_por_clientes  := ROUND(ln_Por_Cliente/100 * i.jaql583mtcl,0 );
               
               if ln_cre_clientemes   >=  ln_por_clientes  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
               --if ln_por_clientes >=  ln_Por_Cliente  then   ---PORCENTAJE CLIENTES EXIGIDO 60 ---ABRIL CAMBIARA 100
                  lc_ind_castigo := 'N';
               else 
                  lc_ind_castigo := 'S';
               end if;
               -----
               
                --4--crecimiento saldo ANUAL
               if ln_cre_saldoanual > 0 -- crecimiento anual
                  and ln_cre_saldoanual - i.jaql583mtsa > 0 
                  and i.jaql583smax > 0 --2014.08.07
                  then  ---crecimiento anual
                  
                  ---VERIFICAR CONDICION SI NO CUMPLE LA META DE CLIENTES 60% MINIMO NO SE CALCULA PLUS EN SALDO,
                   --CASO CONTRARIO SE CASTIGA  EL 50% DEL PLUS A COMISIONAR POR SALDO
                   ----------************************          
                   
                   ---calcular PLUS
                      --A-- saldo anual
                      begin
                        select jaql581sdoa
                          into ln_porcentaje --porcentaje anual
                          from jaql581
                         where jaql581cage = i.jaql583tage
                           and jaql581tase = i.jaql583tase
                           and jaql581est = 'S';
                      exception
                        when no_data_found then
                          ln_porcentaje := 0;
                      end;
                      
                      --plus crecimiento * plus /100
                      
                      
                         ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
                      
                      
                      -- ln_plussdoanu := (ln_cre_saldoanual - i.jaql583mtsa )* ln_porcentaje/100;
                       if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                          ln_plussdoanu := ln_plussdoanu * ln_Por_Castigo/100;/*0.50*/
                       end if;
                       if ln_plussdoanu < 0 then
                          ln_plussdoanu := 0;
                       end if;  

               end if;
               
               
                --7--CALCULAR PRIMERO - crecimiento saldo MENSUAL
                 ---calcular PLUS
                          --A-- saldo mensual
                          begin
                            select jaql581sdom
                              into ln_porcentaje --porcentaje mensual saldo
                              from jaql581
                             where jaql581cage = i.jaql583tage
                               and jaql581tase = i.jaql583tase
                               and jaql581est = 'S';
                          exception
                            when no_data_found then
                              ln_porcentaje := 0;
                          end;
                
               if  ( ln_cre_saldoanual - i.jaql583mtsa ) > 0 then
                    
                   if i.jaql583smax > 0 then--2014.08.07
                           ln_plussdomes := ((ln_cre_saldomes - i.jaql583mtsa )- (ln_cre_saldoanual - i.jaql583mtsa));
                           ln_plussdomes := ln_plussdomes * ln_porcentaje/100;
                           if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                              ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                           end if;
                           if ln_plussdomes < 0 then  ---nuevo cambio
                              ln_plussdomes := 0;
                           end if; 
                  
                  end if;         
               ELSE

                  --if i.jaql583smax > 0 --2014.08.07
                           ln_plussdomes := (ln_cre_saldomes - i.jaql583mtsa ) * ln_porcentaje/100;
                           if lc_ind_castigo = 'S' then --si no cumple la meta se debe castigar el 50% del plus por saldo
                              ln_plussdomes := ln_plussdomes * ln_Por_Castigo/100;/*0.50*/
                           end if;
                           if ln_plussdomes < 0 then  ---nuevo cambio
                              ln_plussdomes := 0;
                           end if; 

                  --end if;         
               end if;
                   
             
               
               
            
              ----
               --11 BONO POR CLIENTES
               -----
               --solo aplica a PMYES
               --if i.jaql583tase = 'P'  then
                  
                    begin
                      -- Call the procedure
                      pq_cr_productividad_ana.sp_cr_pago_variable_cli(pc_tiagel => i.jaql583tage, --E/N/O
                                                                    pc_tipage => i.jaql583lage, -- <> LIMA = 1 / LIMA = 2
                                                                    pc_tipcla => i.jaql583c5030, -- U.....Z
                                                                    pc_claana => i.jaql583tase, -- P Pymes / c consumo
                                                                    pn_numcli => i.jaql583ncl/*i.jaql583cliente*/, --clientes mes  ---2014.08.07
                                                                    pn_metanu => i.jaql583cmax, --meta anual = clientes base/maximo
                                                                    pn_metmes => i.jaql583mtcl, --meta mes
                                                                    pn_climesa => i.jaql583cant -i.jaql583cot + i.jaql583crec,   --cliente mes anterior      ---2014.08.07                                                  
                                                                    pn_porcla => ln_porcla,
                                                                    pn_porclm => ln_porclm,
                                                                    pn_bonanu => ln_bonanu,
                                                                    pn_bonmen => ln_bonmen,
                                                                    pn_totanu => ln_total_exc_anual,
                                                                    pn_totmes => ln_total_exc_mes,
                                                                    pn_nummes => ln_excmes,
                                                                    pn_numanu => ln_excanu,
                                                                    pc_indexa => lc_indexa,
                                                                    pc_indexm => lc_indexm
                                                                     );
                    end;
                  
                    ln_plusclianu := ln_total_exc_anual;
                    ln_plusclimes := ln_total_exc_mes;
                   
               --end if;            
               ---
                    
               
               --9--PLUS CLIENTES NUEVOS               
               if ( ln_cre_clientemes - i.jaql583mtcl) >= 0 then 
                
                 
                   begin
                    pq_cr_productividad_ana.sp_pa_clte_nuevo(pc_analista => i.jaql583usu,
                                                             pd_fecpro => pd_fecpro,
                                                             pc_tipage => i.jaql583cantage, --Nueva/en crecimiento/madura---i.jaql583tase,  2016.02.19
                                                             pn_numcli => ln_clinuevo,
                                                             pn_mtonue => ln_PLUSCLINUEVO);
                   end;
                
                end if;
                      

               
               
               --10 MONTO CASTIGADO
               ----------
              --2016.02.08

           /*     ln_castigo := pq_cr_productividad_ana.fn_cr_pjecastigo(pc_jaql591tase  => i.jaql583tase,
                                                                     pn_jaql591codcat  => i.jaql583codcat,
                                                                     pn_jaql591cantage => i.jaql583cantage,
                                                                     pn_moraingresada  => ln_Por_Mora);
          */
               
               ln_castigo :=  pq_cr_productividad_ana.fn_cr_pjecastigomora(pc_jaql591tase => i.jaql583tase,
                                                                    pc_jaql591codcat =>  i.jaql583ivi,
                                                                    pc_jaql591cantage => i.jaql583neo,
                                                                    pn_moraingresada => ln_Por_Mora);

           
           
              --2016.02.08
                    
               --monto castigo retorna negativo
               ln_mtocastigo :=  ( ln_plussdoanu + ln_plusclianu + ln_plussdomes + ln_plusclimes + ln_PLUSCLINUEVO ) * ln_castigo/100;
               
               ln_totalPLUS := ln_plussdoanu + ln_plussdomes + ln_plusclianu + ln_plusclimes + ln_PLUSCLINUEVO +  ln_mtocastigo ;
               
               --dbms_output.put_line(i.jaql572usu || ' saldo  '||ln_bonosaldo || ' cli ' ||ln_bonocli|| ' cresal '||i.jaql572cme || ' crecli '||i.jaql572cmcl);
               
              if ln_totalPlus >=0 then
                  ln_totalPP := ln_totalPLUS; 
              else
                  ln_totalPP := 0;
              end if;    
               --actualizar bonos
               update jaql583
                  set jaql583bsal = ln_bonosaldo,
                      jaql583bcli = ln_bonocli,
                      jaql583bmra = ln_bonomora,
                      jaql583cran = ln_cre_saldoanual, 
                      jaql583crme = ln_cre_saldomes, 
                      jaql583crca = ln_cre_clienteanual, 
                      jaql583crcm = ln_cre_clientemes, 
                      jaql583ppla = ln_plussdoanu, 
                      jaql583pplm = ln_plussdomes, 
                      jaql583ppca = ln_plusclianu, 
                      jaql583ppcm = ln_plusclimes, 
                      jaql583ppcn = ln_PLUSCLINUEVO,
                      jaql583cmra = ln_mtocastigo, --mto castigo
                      jaql583bmet = ln_totalBONO,
                      jaql583bplu = ln_totalPLUS,
                      JAQL583PJCA = ln_porcla,
                      JAQL583PJCM = ln_porclm,
                      JAQL583EXAN = ln_bonanu,
                      JAQL583EXME = ln_bonmen,
                      JAQL583TEXAN = ln_total_exc_anual, --total excedente anual
                      JAQL583TEXME = ln_total_exc_mes, --total excedente mensual
                      JAQL583PMRA = ln_Por_Mora,--calcula y actualiza la mora
                      ---ultimos campos actualizados
                      JAQL583CRSA = ln_cre_saldomes,
                      JAQL583CRCL = ln_cre_clientemes,
                      JAQL583TOTPA = (ln_totalBONO + ln_totalPP/*ln_totalPLUS*/),  
                      JAQL583NEXA = ln_excanu,
                      JAQL583NEXM = ln_excmes,
                      JAQL583NCN = ln_clinuevo,
                      JAQL583PJCAS = ln_castigo, --porcentaje castigo
                      ---
                      --ultimos campos
                      jaql583cexa = lc_indexa,
                      jaql583cexm = lc_indexm,
                      ---
                      jaql583inca = 'A'
                where jaql583usu  = i.jaql583usu                  
                  and jaql583fpro = pd_fecpro;
                      
                commit;
                   
                --actualiza mantenimiento CASTIGO....
                --if ln_castigo <> 0 then
                    begin
                      pq_cr_productividad_ana.sp_cr_retorna_bono_mto(pc_tipasesor => i.jaql583usu,
                                                                     pd_fecpro => pd_fecpro,
                                                                     pn_bono_sal => ln_bono_sal,
                                                                     pn_bono_cli => ln_bono_cli);
                    end;
                    ln_castigo_mantenimiento := nvl((ln_bono_sal + ln_bono_cli )  * ln_castigo/100, 0);
                    
                    update jaql572
                       set jaql572btot = (ln_bono_sal + ln_bono_cli + ln_castigo_mantenimiento) ,
                           jaql572mcas =  ln_castigo_mantenimiento,
                           jaql572pjcas = ln_castigo,
                           jaql572inca = 'A'
                     where jaql572usu  = i.jaql583usu                
                       and jaql572fpro = pd_fecpro;
                    
                     commit;   
                --end if; 
               
         end if; --206.07.05
    
     
     --inicializar variables
     ln_mtocastigo := 0;
     ln_plussdoanu := 0; 
     ln_plusclianu := 0;
     ln_plussdomes := 0;
     ln_plusclimes := 0; 
     ln_castigo := 0;
     ln_totalPLUS := 0;
     ln_plussdoanu := 0;
     ln_plussdomes := 0;
     ln_plusclianu := 0;
     ln_PLUSNUEVO := 0;
     ln_mtocastigo := 0;
     ln_bonocli1 := 0;
     ln_bonocli2 := 0;
     ln_bonocli3 := 0;
     ln_bonocli4 := 0;
     ln_bonocli5 := 0;
     /*ln_bonocli6 := 0;
     ln_bonocli7 := 0;*/
     ln_bonomora := 0;
     ln_bonocli := 0;
     ln_bonosaldo := 0;
     ln_totalBONO := 0;
     ln_cre_saldoanual := 0;
     ln_cre_clienteanual := 0;
     ln_cre_saldomes := 0;
     ln_cre_clientemes := 0;
     ln_porcla  :=0; 
     ln_porclm  :=0; 
     ln_bonanu  :=0; 
     ln_bonmen  :=0; 
     ln_total_exc_anual  :=0; --TOTAL por excedente anual
     ln_total_exc_mes    :=0; --TOTAL por excedente mensual
     lc_ind_castigo := 'N';
     ln_totalBONO := 0;
     ln_clinuevo := 0;
     ln_castigo_mantenimiento := 0;
     ln_PLUSCLINUEVO := 0;
     ln_bono_sal := 0;
     ln_bono_cli := 0;
     ----
     lc_indexa := null;
     lc_indexm := null;
     ----
     ln_Por_Mora := 0;
     
 end loop;


end sp_cr_bonos_productividad;
---

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_senior  ( pc_analista IN char, pd_fecpro in date  ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_senior
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.02.08
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Determina si es analista SEnior I, II, III
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 2016.05.12
    -- Descripción de Modificación: se agrego fecha de proceso y llamada a tabla JAQL593 analistas senior a enero 2016
    -- *****************************************************************
    ln_codcat number(3) := 0;
    ld_fecfin date := to_date('2015.12.31','yyyy.mm.dd');
    ln_saldo number(18,2) := 0;
    ln_cont number;
  begin

    begin 
      select count(*)
        into ln_cont
        from JAQL593-- tabla de analistas senior al 2016.01.01
             --sng057_201X --2012.06.20
      where JAQL593usr = pc_analista
        and JAQL593car = 201; --determinar cargo de analista senior
    exception when no_data_found then
         ln_cont := 0;       
    end;
  
    if ln_cont > 0 then 
      Begin
         select jaql583sdo
          into ln_Saldo
          from jaql583
         where jaql583usu = pc_analista
           and jaql583fpro = ld_fecfin;
      exception
        when others then
          ln_Saldo := 0;
      end;
      case 
        when ln_saldo > 3000000 then
         ln_codcat := 7;
        when ln_saldo > 1500000 and ln_saldo <= 3000000 then
         ln_codcat := 8;
        when ln_saldo <= 1500000 then
         ln_codcat := 9;
        else 
         ln_codcat := 0;
      end case;
    end if;
          
    if ln_saldo = 0 then --no existe en diciembre verificar en fecha de proceso cargo y saldo
        
      --cargo
      begin 
        select count(*)
          into ln_cont
          from sng057_201X --2012.06.20
        where SNG057usr = pc_analista
          and SNG055car = 201; --determinar cargo de analista senior
      exception when no_data_found then
            ln_cont := 0;       
      end;
      
      if ln_cont > 0 then --si tiene cargo analista senior
        --saldo
         Begin
             select jaql583sdo
              into ln_Saldo
              from jaql583
             where jaql583usu = pc_analista
               and jaql583fpro = pd_fecpro;
          exception
            when others then
              ln_Saldo := 0;
          end;
          
           case 
              when ln_saldo > 3000000 then
               ln_codcat := 7;
              when ln_saldo > 1500000 and ln_saldo <= 3000000 then
               ln_codcat := 8;
              when ln_saldo <= 1500000 then
               ln_codcat := 9;
              else 
               ln_codcat := 0;
          end case;
      
      
      end if;          
    
    end if;
      
    
    
    return ln_codcat;

  end fn_cr_senior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_zona  ( pn_codsuc IN number  ) return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_zona
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.03.18
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Determina zona de acuerdo a mapeo fijo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_codsuc
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    LN_CODSUC NUMBER;
    LN_CODZON NUMBER;
BEGIN
  LN_CODSUC := pn_codsuc;
    CASE
    WHEN LN_CODSUC=1 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=2 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=3 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=4 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=5 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=6 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=7 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=8 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=9 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=10 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=11 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=12 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=13 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=14 THEN LN_CODZON:=31;
    WHEN LN_CODSUC=15 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=16 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=17 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=18 THEN LN_CODZON:=2;
    WHEN LN_CODSUC=19 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=20 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=21 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=22 THEN LN_CODZON:=2;
    WHEN LN_CODSUC=23 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=24 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=25 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=26 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=27 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=28 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=29 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=30 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=31 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=32 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=33 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=34 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=35 THEN LN_CODZON:=2;
    WHEN LN_CODSUC=36 THEN LN_CODZON:=31;
    WHEN LN_CODSUC=37 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=38 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=39 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=40 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=41 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=42 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=43 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=44 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=45 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=46 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=47 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=49 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=50 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=51 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=52 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=53 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=54 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=55 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=56 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=57 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=58 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=59 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=60 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=61 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=62 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=63 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=64 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=65 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=66 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=67 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=68 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=69 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=70 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=71 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=72 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=73 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=74 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=75 THEN LN_CODZON:=12;
    WHEN LN_CODSUC=76 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=77 THEN LN_CODZON:=31;
    WHEN LN_CODSUC=79 THEN LN_CODZON:=1;
    WHEN LN_CODSUC=80 THEN LN_CODZON:=11;
    WHEN LN_CODSUC=81 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=82 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=83 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=84 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=85 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=86 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=87 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=88 THEN LN_CODZON:=23;
    WHEN LN_CODSUC=89 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=90 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=91 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=92 THEN LN_CODZON:=2;
    WHEN LN_CODSUC=93 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=94 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=95 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=96 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=97 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=98 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=99 THEN LN_CODZON:=3;
    WHEN LN_CODSUC=100 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=101 THEN LN_CODZON:=21;
    WHEN LN_CODSUC=102 THEN LN_CODZON:=5;
    WHEN LN_CODSUC=103 THEN LN_CODZON:=6;
    WHEN LN_CODSUC=104 THEN LN_CODZON:=41;
    WHEN LN_CODSUC=113 THEN LN_CODZON:=7;
    WHEN LN_CODSUC=112 THEN LN_CODZON:=7;
    WHEN LN_CODSUC=111 THEN LN_CODZON:=7;
    WHEN LN_CODSUC=118 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=110 THEN LN_CODZON:=2;
    WHEN LN_CODSUC=108 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=109 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=116 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=117 THEN LN_CODZON:=22;
    WHEN LN_CODSUC=114 THEN LN_CODZON:=4;
    WHEN LN_CODSUC=115 THEN LN_CODZON:=4;
    else
    LN_CODZON:=1;
  END CASE;



  return ln_codzon;


  end fn_cr_zona;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_MoraMinima(pc_JAQL591tase in varchar2,
                       pc_JAQL591codcat in char,
                       pc_JAQL591cantage in char )              
                               return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MoraMin
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/03/2016
    -- Autor de Creación          : DCASTRO
    -- Uso                        : RETORNA LA MORA MINIMA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : MÍNIMA MORA
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
pn_jaql591min number;  
lc_tase varchar(3);  



begin
  
lc_tase := trim(pc_JAQL591tase);
   
   begin
     ---1
     
    
     select min(jaql591min)
      into pn_jaql591min
      from jaql591
      where trim(JAQL591tase) = lc_tase --pc_JAQL591tase
      and JAQL591tusu = pc_JAQL591codcat
      and JAQL591NEO =  pc_JAQL591cantage; 
    
    
   exception
     when no_data_found then
       --2
       
       pn_jaql591min:=0;       
       
   end; --3
  return   pn_jaql591min;
  
end fn_cr_MoraMinima;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function fn_cr_PjeCastigoMora(pc_JAQL591tase in varchar2,
                       pc_JAQL591codcat in char,
                       pc_JAQL591cantage in char,
                       pn_MoraIngresada in number )              
                               return number is
    -- *****************************************************************
    -- Nombre                     : fn_cr_MoraMin
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/03/2016
    -- Autor de Creación          : DCASTRO
    -- Uso                        : RETORNA EL PORCENTAJE DE CASTIGO SEGUN MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : PORCENTAJE DE CASTIGO POR MORA
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:
    -- *****************************************************************
 
pn_jaql591por number;  
lc_tase varchar(3);  



begin
  
lc_tase := trim(pc_JAQL591tase);
   
     begin                                                      
          select jaql591cas
              into pn_jaql591por
              from jaql591
              where trim(JAQL591tase) = lc_tase
              and JAQL591tusu = pc_JAQL591codcat --i..vi
              and JAQL591NEO =  pc_JAQL591cantage -- neo
              and JAQL591MIN <= pn_MoraIngresada
              and JAQL591MAX > pn_MoraIngresada;
       exception when no_Data_found then
            pn_jaql591por := 0;            
      end;  

  return   pn_jaql591por;
  
end fn_cr_PjeCastigoMora;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_valida( pd_fecpro in date) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_valida
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.06.07
    -- Autor de Creación          : 
    -- Uso                        : VALIDA MONTOS ALTOS POR TRASLADOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


 cursor analistas is
      SELECT *
        FROM JAQL583 
       where jaql583fpro = pd_fecpro
--         and jaql583sant = jaql583mtsa
         and (jaql583soto + jaql583srec + jaql583cot + jaql583crec ) >0
         and jaql583totpa > 1000;
 
 ln_salant number;
 ln_cliant number;
 ln_salmax number;
 ln_climax number;
 lc_codana varchar2(10);
 
BEGIN

    for i in analistas loop
    
        begin
          select jaql583sant, jaql583cant, jaql583smax, jaql583cmax
            into ln_salant, ln_cliant, ln_salmax, ln_climax
            from jaql583 a
           where a.jaql583fpro = add_months(i.jaql583fpro, -1)
             and a.jaql583usu  = i.jaql583usu;
        exception when no_data_found then
            ln_salant := 0;           
        end;
    
        if ln_salant <>0 then
        
            --Nuevo SALDO MAXIMO
            ln_salmax :=  ln_salmax - i.jaql583soto + i.jaql583srec ;
            ln_climax :=  ln_climax - i.jaql583cot + i.jaql583crec ;
            if ln_salmax <= 0 then
               ln_salmax := i.jaql583smax;
               ln_climax := i.jaql583cmax;
            end if;  
        
            update JAQL583 
               set 
               jaql583sant = ln_salant,
               jaql583cant = ln_cliant,
               jaql583smax = ln_salmax,
               jaql583cmax = ln_climax,
               jaql583sdc1 = 1 --indicador de actualizacion
             where jaql583fpro = pd_fecpro
               and jaql583usu = i.jaql583usu;
          
            commit;
          
        end if;          
        
        ---calculando productividad
        lc_codana := rpad(trim(i.jaql583usu),10,' ');
        begin
          pq_cr_productividad_ana.sp_cr_bono_mantenimiento(pd_fecpro => i.jaql583fpro,
                                                           pc_analista => lc_codana);
        end;

        begin
          pq_cr_productividad_ana.sp_cr_bonos_productividad(pn_sucurs => i.jaql583age,
                                                            pd_fecpro => i.jaql583fpro,
                                                            pc_analista => lc_codana);
        end;
        
        
        
    end loop;





end sp_cr_valida;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_PRODUCTIVIDAD_ANA;
/

