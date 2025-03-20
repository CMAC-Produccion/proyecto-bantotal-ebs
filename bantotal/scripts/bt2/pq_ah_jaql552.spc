create or replace package PQ_AH_JAQL552 is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AH_AHSOMSG
  -- Sistema               : SORFY
  -- Módulo                : TODOS LOS CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 08/08/2011
  -- Autor de Creación     : Juan Andres Quintanilla Calderon
  -- Uso                   : Almacena los datos de bonificaciones de creditos y clientes del analista
  -- Estado                : Activo
  -- Acceso                : Público
  --                       : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------ 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_cuota_sf(P_D_FECTRA in date,
                          P_C_TIPPAS in varchar2,
                          P_N_VALCUO in number) return number;
                          
 function fn_cr_clasif_SBS(P_N_CALIF0 in number,
                            P_N_CALIF1 in number,
                            P_N_CALIF2 in number,
                            P_N_CALIF3 in number,
                            P_N_CALIF4 in number) return number;
                            
                            
  function fn_cr_calc_ratio(P_C_TIPCLI  in varchar2,
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
                            P_N_CONCFC4 in number) return number;                            
  
  Function fn_cr_tipocambio(P_IN_fecha in date) return number;
  
  
  Function fn_cr_cliente_registrado(P_D_FECTRA in date,
                                    P_N_PAIS in Number,
                                    P_N_TIPDOC in Number,
                                    P_N_NUMDOC in Number) return char;
                                    
  FUNCTION fn_cr_tipdoc_sbs(P_C_TIPDOC in number, P_C_NUMDOC in varchar2)
  RETURN char ;
    
  Function fn_cr_cred_no_desem(P_N_PAIS in Number,
                               P_N_TIPDOC in Number,
                               P_N_NUMDOC in Number,
                               P_IN_fecha in date,
                               P_N_TIPCAM in number) return number;
                               
  FUNCTION fn_cr_existe_datos(P_N_ANOPRO NUMBER, P_N_MESPRO NUMBER)
  return char;
  
  function fn_cr_mtocon(P_C_NUMINS IN varchar2,
                        P_N_TIPCAM in number) return number;
                        
  FUNCTION fn_cr_numref(P_IN_PGCOD in Number,
                        P_IN_SUCUR in Number,
                        P_IN_MDA in Number,
                        P_IN_PAP in Number,
                        P_IN_CTA in Number,
                        P_IN_OPER in Number,
                        P_IN_SBOP in Number,
                        P_IN_TOPE in Number,
                        P_IN_MOD in Number) RETURN number deterministic;
                        
                        
  Function fn_cr_cuota_imp(P_IN_PGCOD in Number,
                           P_IN_SUCUR in Number,
                           P_IN_MDA in Number,
                           P_IN_PAP in Number,
                           P_IN_CTA in Number,
                           P_IN_OPER in Number,
                           P_IN_TOPE in Number,
                           P_IN_MOD in Number,
                           P_IN_FECPRO in date) return number;
                           
  function fn_cr_valdat(P_C_TIPVAL in varchar2,
                        P_C_ANOPRO in varchar2,
                        P_C_MESPRO in varchar2,
                        P_C_CODPAS in varchar2) return number;
                        
  function fn_cr_crit_pyme(P_C_TIPVAL in varchar2,
                           P_C_ANOPRO in varchar2,
                           P_C_MESPRO in varchar2,
                           P_C_CODPAS in varchar2,
                           P_C_CODSEC in varchar2,
                           P_C_CODACT in varchar2,
                           P_C_CLASBS in varchar2) return number;
                           
 function fn_cr_crit_cons(P_C_TIPVAL in varchar2,
                          P_C_ANOPRO in varchar2,
                          P_C_MESPRO in varchar2,
                          P_C_CODPAS in varchar2,
                          P_C_CODSEC in varchar2,
                          P_N_INGNET in number) return number;
 /*                         
 function fn_cr_inter_deven(P_N_RUBRO in Number,
                            P_IN_PGCOD in Number,
                            P_IN_SUCUR in Number,
                            P_IN_MDA in Number,
                            P_IN_PAP in Number,
                            P_IN_CTA in Number,
                            P_IN_OPER in Number,
                            P_IN_TOPE in Number,
                            P_IN_MOD in Number,
                            P_IN_SUBOP in number) return number;                         */
                          
 procedure sp_cr_conyuge(P_N_PAIS   in Number,
                          P_N_TIPDOC in Number,
                          P_C_NUMDOC in Char,
                          p_n_Pais_c   out varchar2,
                          p_n_Tipdoc_c out varchar2,
                          p_c_Numdoc_c out varchar2);                         
                                                  
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
                              P_D_FECEVS in date,
                              P_D_FECEVF in date,
                              p_c_tipcli out varchar2,
                              p_c_tippas out varchar2);
                                                                   
  procedure sp_cr_datos_sistema_financiero(P_C_TIPDOC in number,
                                           P_C_NUMDOC in varchar2,
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
                                           
  PROCEDURE sp_cr_datos_evaluaciones(P_N_PAIS   in Number,
                                     P_N_TIPDOC in Number,
                                     P_C_NUMDOC in Char,
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
                                     p_d_fecevf out date);
                                           
 procedure sp_cr_ultimo(P_C_TIPVAL in varchar2,
                        P_D_FECTRA in date,
                        p_c_mespro out varchar2,
                        p_c_anopro out varchar2);
                        
  procedure sp_cr_sobreend(P_D_FECHA in Date) ;                    
                                        
                                                                                                                                                                                                                                                                                   
End PQ_AH_JAQL552;
/

