create or replace package PQ_CR_jaql964_cartera is
  -- *****************************************************************
  -- Nombre                     : paquete para obtener cartera de creditos
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : Cr¿ditos - Activas
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2013.09.02
  -- Autor de Creaci¿n          : DCASTRO
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
  --                              
  -- Retorno                    : 
  -- Fecha de Modificaci¿n      : 2013.10.15
  -- Autor de la Modificaci¿n   : DCASTRO
  -- Descripci¿n de Modificaci¿n: se modifico fn_Cr_analista
  --                              2014.01.03 DCASTRO - Se modifico sp_cr_actualiza_analista_bulk
  --                              2014.10.15 DCASTRO - Se modifico sp_cr_carga_datos para cartera refinanciada          
  --                              2015.03.02 DCASTRO - Se modifico fn_tipo_credito_Desem
  --                              2015.05.12 DCASTRO - Se modifico SP_CR_CARGA_AVAL
  --                              2015.08.10 DCASTRO - Se modifico sp_cr_aogado, sp_cr_saldototal.
  --                              2015.08.18 DCASTRO - Se modifico sp_cr_abogado    
  --                              2015.09.03 DCASTRO - Se modifico sp_cr_abogado.
  --                              2015.09.22 DCASTRO - Se modifico sp_cr_abogado.    
  --                              2015.09.29 DCASTRO - Se modifico sp_cr_abogado.        
  --                              2016.01.27 DCASTRO - Se modifico llamada a funcion fn_sector_credito de base.
  --                              2018.02.01 DCASTRO - Se modifico sp_cr_actualiza_analista_bulk, sp_cr_carga_aval, sp_cr_tit_representante
  --                              2021.05.02 DCASTRO - Se modifico sp_cr_analista
  --                              2024.02.14 DCASTRO - Se modifico sp_cr_actualiza_dir, sp_cr_direccion, fn_cr_telefono_valido,
  --                              2024.02.20 DCASTRO - se modifico sp_cr_direccion, se inicializo variable vtelefono.
  -- Fecha de Modificación      : 2024.10.21
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: PRY7090 - Se agrego a la tabla JAQL964 el campo del CIIU y 6 campos auxiliares, en el procedimiento 
  --                              SP_cR_CARGA_AVAL se invoca al procedimiento del CIIU para la insercion del campo.
  -- Fecha de Modificación      : 2025.01.08
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: INC9596 Se agrego al procedimiento sp_cr_carga_aval la ejecucion de la base del listado de
  --                              reconversion de lineas
  -- Fecha de Modificación      : 2025.01.20
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se agrego al procedimiento sp_cr_carga_aval la ejecucion de la base del listado de
  --                              reconversion de lineas con validacion de ejecucion. lineas 3661 a 3741
  -- Fecha de Modificación      : 2025.03.03
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego al procedimiento sp_cr_carga_aval la ejecucion del procedimiento sp_Cr_CargaReconver
  -- *****************************************************************

  procedure sp_cr_carga_datos(P_D_FECPRO in varchar2,
                              P_N_TIPCAM in number,
                              P_C_ESTADO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_calculos(P_C_ESTADO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualiza_analista(P_D_FECPRO in varchar2,
                                     P_C_ESTADO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  function fn_cr_analista(vjaql964mod in number,
                          vjaql964cta in number,
                          vjaql964ope in number,
                          vjaql964sob in number,
                          vjaql964top in number,
                          vjaql964suc in number,
                          vjaql964mda in number) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_analista(vjaql964mod  in number,
                           vjaql964cta  in number,
                           vjaql964ope  in number,
                           vjaql964sob  in number,
                           vjaql964top  in number,
                           vjaql964suc  in number,
                           vjaql964mda  in number,
                           pc_analista  out varchar2,
                           pn_instancia out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_actualiza_dir(P_D_FECPRO in varchar2,
                                P_C_ESTADO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_direccion(vjaql964cta in number,
                            vjaql964doc in char,
                            vtelefono   out varchar2,
                            vdireccion  out varchar2,
                            vdistrito   out varchar2,
                            vreferencia out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_garantia(vjaql964mod in number,
                          vjaql964cta in number,
                          vjaql964ope in number,
                          vjaql964sob in number,
                          vjaql964top in number,
                          vjaql964suc in number,
                          vjaql964mda in number) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualiza_monto(P_D_FECPRO in varchar2,
                                  P_C_ESTADO out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_monto(vjaql964mod in number,
                       vjaql964cta in number,
                       vjaql964ope in number,
                       vjaql964sob in number,
                       vjaql964top in number,
                       vjaql964suc in number,
                       vjaql964mda in number) return number;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_abogado(P_N_PGCOD     in number,
                         P_N_MONEDA    in number,
                         P_N_PAPEL     in number,
                         P_N_CUENTA    in number,
                         P_N_OPERACION in number,
                         P_N_MODULO    in number,
                         P_N_SUCURSAL  in number,
                         P_N_SUBOPER   in number,
                         P_N_TIPOPER   in number) return varchar2;
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_tipocontable(P_D_FECPRO  in date,
                               vjaql964mod in number,
                               vjaql964cta in number,
                               vjaql964ope in number,
                               vjaql964sob in number,
                               vjaql964top in number,
                               vjaql964suc in number,
                               vjaql964mda in number,
                               vtipcon     out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_cr_actualiza(P_D_FECPRO in date, P_C_ESTADO out varchar2);
  ---------------------------------------------------------------------------------------------
  function fn_cr_credito_sorfy(vjaql964cta in number,
                               vjaql964ope in number,
                               vjaql964mda in number) return varchar2;
  ---------------------------------------------------------------------------------------------

  function fn_cr_tipocredito(vjaql964mod in number,
                             vjaql964cta in number,
                             vjaql964ope in number,
                             vjaql964sob in number,
                             vjaql964top in number,
                             vjaql964suc in number,
                             vjaql964mda in number) return varchar2;
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza_analista_bulk(P_D_FECPRO in date,
                                          --P_C_ESTADO out varchar2,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER);
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza_bulk(P_D_FECPRO in date,
                                 P_C_ESTADO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
  /*function fn_sector_credito(
    v_fecpro in date,
    v_pgcod  in number,
    v_Scmod  in number,
    v_Scsuc  in number,
    v_Scmda  in number,
    v_Scpap  in number,
    v_Sccta  in number,
    v_Scoper in number,
    v_Scsbop in number,
    v_Sctope in number,
    v_instancia in number
  ) return number;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                          
  procedure sp_cr_aval(P_N_INSTANCIA in number,
                       P_N_CUENTA    in number,
                       P_N_OPERACION in number,
                       P_N_CTAAVA    out number,
                       P_C_PENOM     out varchar2,
                       P_C_TELEF     out varchar2,
                       P_C_DIREC     out varchar2);
  -------------------------------------------------------------------------------------
  /*procedure sp_cr_aval971(P_N_CUENTA    in number,
  P_N_OPERACION in number,
  P_N_MODULO    in number,
  ln_instancia in number,
  ln_correlativo in number,
  ln_cuentaaval out number,
  lc_penomaval out varchar2,
  ln_pepaisaval out number,
  ln_petdocaval out number,
  ln_pendocaval out character,
  correlativo out number);     */
  ---------------------------------------------------------------------------------------------

  function fn_cr_telefono_aval(P_N_PEPAIS in number,
                               P_N_PETDOC in number,
                               P_N_PENDOC in char) return varchar2;
  ----------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------     
  procedure sp_cr_direccion_aval(P_N_PEPAIS in number,
                                 P_N_PETDOC in number,
                                 P_N_PENDOC in char,
                                 P_C_direc  out varchar2,
                                 P_C_distr  out varchar2,
                                 P_C_refer1 out varchar2,
                                 P_C_ubigeo out char);

  ---------------------------------------------------------------------------------------------   
  procedure sp_cr_carga_aval(P_N_INI in NUMBER, P_N_FIN in NUMBER);

  -------------------------------------------------------------------------------------------------
  procedure sp_cr_inserta_aval(P_N_CORR964 NUMBER,
                               P_N_CTAAVA  in number,
                               P_C_PENOM   in varchar2,
                               P_N_PETDOC  in number,
                               P_N_PENDOC  in varchar2,
                               P_C_DIREC   in varchar2,
                               P_C_refer1  in varchar2,
                               P_C_distr   in varchar2,
                               P_C_TELEF   in varchar2,
                               P_C_DIRNEG  in varchar2,
                               P_N_PEPAIS  in number,
                               P_C_ubigeo  in char,
                               P_C_DPTO    in varchar2,
                               P_C_PROV    in varchar2);
  ---------------------------------------------------------
  procedure sp_cr_direccion_negocio(P_N_PEPAIS in number,
                                    P_N_PETDOC in number,
                                    P_N_PENDOC in char,
                                    P_C_DIRNEG out varchar2,
                                    P_C_distr  out varchar2,
                                    P_C_refer1 out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_update_aval(P_N_CORR964  number,
                              P_N_CTAAVA   in number,
                              P_C_PENOM    in varchar2,
                              P_N_PETDOC   in number,
                              P_N_PENDOC   in varchar2,
                              P_C_DIREC    in varchar2,
                              P_C_refer1   in varchar2,
                              P_C_distr    in varchar2,
                              P_C_TELEF    in varchar2,
                              P_C_DIRNEG   in varchar2,
                              P_N_PEPAIS   in number,
                              P_N_POSICION number,
                              P_C_ubigeo   in char,
                              P_C_DPTO     in varchar2,
                              P_C_PROV     in varchar2);
  -------------------------------------------------------------------
  procedure sp_cr_fecha_cancelacion(P_N_PGCOD  in number,
                                    P_N_AOMOD  in number,
                                    P_N_AOSUC  in number,
                                    P_N_AOMDA  in number,
                                    P_N_AOPAP  in number,
                                    P_N_AOCTA  in number,
                                    P_N_AOOPER in number,
                                    P_N_AOSBOP in number,
                                    P_N_AOTOPE in number,
                                    P_N_FCAN   out varchar2);
  ---------------------------------------------------------------------
  procedure sp_cr_monto_aprobado(
                                 -- P_N_AOMOD in number, 
                                 P_N_PGCOD  in number,
                                 P_N_AOSUC  in number,
                                 P_N_AOMDA  in number,
                                 P_N_AOPAP  in number,
                                 P_N_AOCTA  in number,
                                 P_N_AOOPER in number,
                                 --P_N_AOSBOP in number, 
                                 -- P_N_AOTOPE in number,
                                 P_N_MAPRO out number
                                 
                                 );
  ---------------------------------------------------------------------
  procedure sp_cr_provcali(P_N_RI105COD   in number,
                           P_N_RI105SUC   in number,
                           P_N_RI105MOD   in number,
                           P_N_RI105MDA   in number,
                           P_N_RI105PAP   in number,
                           P_N_RI105CTA   in number,
                           P_N_RI105OPER  in number,
                           P_N_RI105SBOP  in number,
                           P_N_RI105TOPE  in number,
                           P_N_JAQL964EST in number,
                           P_N_PROV       out number,
                           P_N_CALF       out number,
                           P_N_DCALF      out varchar2
                           
                           );
  ---------------------------------------------------------------------  
  /*procedure sp_cr_otrosrubros (\*otros rubros*\
                              P_N_PGCOD in number, -- fsd011
                              P_N_SCSUC in number, 
                              P_N_SCRUB in number, 
                              P_N_SCMDA in number, 
                              P_N_SCPAP in number, 
                              P_N_SCCTA in number, 
                              P_N_SCOPER in number, 
                              P_N_SCSBOP in number, 
                              P_N_SCTOPE in number,
                              P_N_ORUB out number
  );*/
  ----------------------------------------------------------------------
  procedure sp_cr_fidemanda( /*fecha ingreso de demanda*/P_N_JAQM27PGC  in number,
                            P_N_JAQM27MOD  in number,
                            P_N_JAQM27SUC  in number,
                            P_N_JAQM27MDA  in number,
                            P_N_JAQM27PAP  in number,
                            P_N_JAQM27CTA  in number,
                            P_N_JAQM27OPER in number,
                            P_N_JAQM27SBOP in number,
                            P_N_JAQM27TOPE in number,
                            P_N_JAQM33COR  in number,
                            P_N_JAQM33FDEM out varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_refinanciado( /*fecha castigo jaql166*/P_N_JAQL166PGCOD in number,
                               P_N_JAQL166SCMOD in number,
                               P_N_JAQL166SCSUC in number,
                               P_N_JAQL166SCMDA in number,
                               P_N_JAQL166SCPAP in number,
                               P_N_JAQL166SCCTA in number,
                               P_N_JAQL166SCOPE in number,
                               P_N_JAQL166SCSBO in number,
                               P_N_JAQL166SCTOP in number,
                               P_N_JAQL166EST   in number,
                               P_N_JAQL166SCFVL out varchar2
                               
                               );
  ----------------------------------------------------------------------
  procedure sp_cr_interes_compextra( ---fsd011
                                    P_N_PGCOD  in number,
                                    P_N_SCSUC  in number,
                                    P_N_SCMDA  in number,
                                    P_N_SCPAP  in number,
                                    P_N_SCCTA  in number,
                                    P_N_SCOPER in number,
                                    P_N_SCSBOP in number,
                                    P_N_SCTOPE in number,
                                    P_N_SCSDO  out number
                                    
                                    );
  ----------------------------------------------------------------------
  procedure sp_cr_castigado(P_N_JAQL166PGCOD in number,
                            P_N_JAQL166SCMOD in number,
                            P_N_JAQL166SCSUC in number,
                            P_N_JAQL166SCMDA in number,
                            P_N_JAQL166SCPAP in number,
                            P_N_JAQL166SCCTA in number,
                            P_N_JAQL166SCOPE in number,
                            P_N_JAQL166SCSBO in number,
                            P_N_JAQL166SCTOP in number,
                            P_N_JAQL166EST   in number,
                            P_N_JAQL166CAST  out char
                            
                            );
  --------------------------------------------------------------------------
  procedure sp_cr_updatejaql964(P_N_CUENTA         in number,
                                P_N_OPERACION      in number,
                                P_N_SUBOPER        in number,
                                P_N_CORRELATIVO    in number,
                                P_N_ESTADO         in number,
                                P_N_FCAN           in varchar2,
                                P_N_MAPRO          in number,
                                P_N_PROV           in number,
                                P_N_CALF           in number,
                                P_N_DCALF          in varchar2,
                                P_N_JAQM33FDEM     in varchar2,
                                P_N_JAQL166SCFVL   in varchar2,
                                P_N_SCSDO          in number,
                                P_N_JAQL166CAST    in varchar2,
                                P_N_SNG419FECT     in varchar2,
                                P_N_PGCOD          in number,
                                P_N_PAP            IN NUMBER,
                                P_N_JAQM33FINT     in varchar2,
                                P_N_JAQM33FACT     in varchar2,
                                P_N_JAQL165COM     in varchar2,
                                P_N_JAQL165DCOM    in varchar2,
                                P_N_JAQL165TEX     in varchar2,
                                P_N_NROEXP         in VARCHAR2,
                                P_N_JAQL964FIRL    in varchar2,
                                P_N_JAQL964FAABO   in varchar2,
                                P_N_JAQL964FEJUD   in varchar2,
                                P_N_JAQL964FDES    in varchar2,
                                P_N_TIPCRED        in number,
                                P_C_ABOGADO        in varchar2,
                                P_C_SOBREENDEUDADO in varchar2,
                                P_N_PLAZO          in number,
                                ln_ciiu            in number);
  ---------------------------------------------------------------------------
  procedure sp_cr_ftransabogado(P_N_SNG419PGC  in number,
                                P_N_SNG419MOD  in number,
                                P_N_SNG419SUC  in number,
                                P_N_SNG419MDA  in number,
                                P_N_SNG419PAP  in number,
                                P_N_SNG419CTA  in number,
                                P_N_SNG419OPE  in number,
                                P_N_SNG419SBO  in number,
                                P_N_SNG419TOP  in number,
                                P_N_SNG419FECT out varchar2);
  ----------------------------------------------------------------------

  procedure sp_cr_finterposicion( /*fecha ingreso de demanda*/P_N_JAQM27PGC  in number,
                                 P_N_JAQM27MOD  in number,
                                 P_N_JAQM27SUC  in number,
                                 P_N_JAQM27MDA  in number,
                                 P_N_JAQM27PAP  in number,
                                 P_N_JAQM27CTA  in number,
                                 P_N_JAQM27OPER in number,
                                 P_N_JAQM27SBOP in number,
                                 P_N_JAQM27TOPE in number,
                                 P_N_JAQM33COR  in number,
                                 P_N_JAQM33FINT out varchar2,
                                 P_N_NROEXP     out varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_faceptacion( --fecha ACEPTACION de demanda **** UNIR CON JAQM27
                              P_N_JAQM27PGC  in number,
                              P_N_JAQM27MOD  in number,
                              P_N_JAQM27SUC  in number,
                              P_N_JAQM27MDA  in number,
                              P_N_JAQM27PAP  in number,
                              P_N_JAQM27CTA  in number,
                              P_N_JAQM27OPER in number,
                              P_N_JAQM27SBOP in number,
                              P_N_JAQM27TOPE in number,
                              P_N_JAQM33COR  in number,
                              P_N_JAQM33FACT out varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_acuerdo_pago(
                               /*P_N_JAQL165CORR in number, */P_N_JAQL165EMP  in number,
                               P_N_JAQL165SUC  in number,
                               P_N_JAQL165MDA  in number,
                               P_N_JAQL165PAP  in number,
                               P_N_JAQL165CTA  in number,
                               P_N_JAQL165OPE  in number,
                               P_N_JAQL165SBO  in number,
                               P_N_JAQL165TOP  in number,
                               P_N_JAQL165MOD  in number,
                               P_N_JAQL165COM  out varchar2,
                               P_N_JAQL165DCOM out varchar2
                               
                               );
  ----------------------------------------------------------------------
  procedure sp_cr_cancelacion_esp(
                                  /*P_N_JAQL165CORR in number, */P_N_JAQL165EMP in number,
                                  P_N_JAQL165SUC in number,
                                  P_N_JAQL165MDA in number,
                                  P_N_JAQL165PAP in number,
                                  P_N_JAQL165CTA in number,
                                  P_N_JAQL165OPE in number,
                                  P_N_JAQL165SBO in number,
                                  P_N_JAQL165TOP in number,
                                  P_N_JAQL165MOD in number,
                                  P_N_JAQL165TEX out varchar2
                                  
                                  );

  ----------------------------------------------------------------------
  procedure sp_cr_carga_971(P_N_INI in NUMBER, P_N_FIN in NUMBER);
  ---------------------------------------------------------------------- 
  procedure sp_cr_job_carga;
  ----------------------------------------------------------------------
  procedure sp_cr_job_actualiza_analistab(P_D_FECPRO in date);
  ----------------------------------------------------------------------
  /*procedure sp_cr_job_carga_datos(P_D_FECPRO in date);*/
  ---------------------------------------------------------------------- 
  procedure sp_cr_job_carga_971(P_D_FECPRO in varchar2);
  ----------------------------------------------------------------------
  Procedure sp_cr_actualiza_tipocontable(P_D_FECPRO in date,
                                         --P_C_ESTADO out varchar2,
                                         P_N_INI in NUMBER,
                                         P_N_FIN in NUMBER);
  ---------------------------------------------------------------------- 
  --procedure sp_cr_job_tipocontable (P_D_FECPRO in date);
  ----------------------------------------------------------------------  

  procedure sp_cr_abogado_1(P_N_PGCOD     in number,
                            P_N_MONEDA    in number,
                            P_N_PAPEL     in number,
                            P_N_CUENTA    in number,
                            P_N_OPERACION in number,
                            P_N_MODULO    in number,
                            P_N_SUCURSAL  in number,
                            P_N_SUBOPER   in number,
                            P_N_TIPOPER   in number,
                            P_C_ABOGADO   out varchar2);
  -----------------------------------------------------------------------
  Procedure sp_cr_abog_dmda(pt_pgcod    in number,
                            pt_modu     in number,
                            pt_sucu     in number,
                            pt_moneda   in number,
                            pt_papel    in number,
                            pt_cnta     in number,
                            pt_operac   in number,
                            pt_sboper   in number,
                            pt_toper    in number,
                            pn_scstat   in number,
                            pf_asig     out date,
                            pc_abrev    out varchar2,
                            pf_deman    out date,
                            pf_pasajud  out date,
                            pf_trancart out date);
  -----------------------------------------------------------------------
  Procedure sp_cr_garantia( -- P_C_ESTADO out varchar2,
                           P_N_INI in NUMBER,
                           P_N_FIN in NUMBER);
  -----------------------------------------------------------------------   

  procedure sp_cr_job_garantia(P_D_FECPRO in date);
  -------------------------------------------------
  procedure UpdateCampos_JAQL964(P_N_INSTANCIA    in number,
                                 P_N_MONEDA       in number,
                                 P_N_CUENTA       in number,
                                 P_N_OPERACION    in number,
                                 P_N_SUCURSAL     in number,
                                 P_N_SUBOPER      in number,
                                 P_N_TIPOPER      in number,
                                 P_N_MODULO       in number,
                                 P_N_ESTADO       in number,
                                 P_N_JAQL964FIRL  out varchar2,
                                 P_N_JAQL964FAABO out varchar2,
                                 P_N_JAQL964FEJUD out varchar2,
                                 P_N_JAQL964FDES  out varchar2,
                                 P_N_MONT_APROB   out number,
                                 P_C_ABOGADO      out varchar2,
                                 P_N_PLAZO        out number);

  ---------------------------------------  
  function fn_tipo_credito_desem(P_N_JAQL964PAI in number,
                                 P_N_JAQL964TID in number,
                                 P_N_JAQL964DOC in char,
                                 P_D_JAQL964FEC in date,
                                 P_N_JAQL964CTA in number) return number;

  --------------------------------------------
  /*procedure sp_cr_saldototal(P_N_AOMOD    in number,
  P_N_PGCOD    in number,
  P_N_AOSUC    in number,
  P_N_AOMDA    in number,
  P_N_AOPAP    in number,
  P_N_AOCTA    in number,
  P_N_AOOPER   in number,
  CAPITALTOTAL out number,
  INTERESTOTAL out number,
  TOTALDEUDA out number);  */

  --------------------------------------------      
  procedure sp_cr_abogado(P_N_PGCOD     in number,
                          P_N_MONEDA    in number,
                          P_N_PAPEL     in number,
                          P_N_CUENTA    in number,
                          P_N_OPERACION in number,
                          P_N_MODULO    in number,
                          P_N_SUCURSAL  in number,
                          P_N_SUBOPER   in number,
                          P_N_TIPOPER   in number,
                          P_N_ESTADO    in number,
                          P_C_ABOGADO   out varchar2,
                          pf_asig       out date);
  ----------------------------------------------
  procedure sp_cr_sobreendeudado(ld_fecha  in date,
                                 ln_pepais in number,
                                 ln_petdoc in number,
                                 ln_pendoc in char,
                                 lc_fgsob  out varchar2);
  --------------------------------------------

  /*function UpdateCampos_JAQL964 (P_N_INSTANCIA in number,
  P_N_MONEDA in number, 
  P_N_CUENTA in number, 
  P_N_OPERACION in number, 
  P_N_SUCURSAL in number,
  P_N_SUBOPER in number,
  P_N_TIPOPER in number,
  P_N_MODULO in number
   ) return  date; */

  ------------------------------------------

  procedure sp_cr_saldototal(pa_ppmod  in number,
                             pa_pgcod  in number,
                             pa_ppsuc  in number,
                             pa_ppmda  in number,
                             pa_pppap  in number,
                             pa_ppcta  in number,
                             pa_ppoper in number,
                             pa_ppsbop in number,
                             pa_pptope in number,
                             pn_captot out number, --CAPITALTOTAL
                             pn_inttot out number, --INTERESTOTAL
                             pn_mora   out number, --MORA
                             pn_intext out number, --INTERES EXTRACON
                             pn_gastos out number, -- GASTOS
                             pn_otros  out number, --OTROS
                             pn_totdeu out number --TOTALDEUDA
                             
                             );
  ---------------------------------------------------------

  procedure sp_cr_fectransabo(pa_ppcta        in number,
                              pa_ppoper       in number,
                              FechTransfAboga out varchar2 -- Fecha Transferencia Abogado
                              
                              );

  ------------------------------------------     
  procedure sp_cr_Fec_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date,
                                  pd_fecha  out date);

  ---------------------------------------------------------
  Procedure sp_cr_tit_representante(pn_corr in number);

  ---------------------------------------------------------
  procedure sp_cr_dpto_prov(vjaql964cta   in number,
                            vjaql964doc   in char,
                            vprovincia    out varchar2,
                            vdepartamento out varchar2);

  ---------------------------------------------------------                            
  procedure sp_cr_DPTO_PROV_DIS(pc_ubigeo in char,
                                pc_dpto   out char,
                                pc_prov   out char,
                                pc_dist   out char);
  ---------------------------------------------------------
  procedure sp_cr_guardar_historico_1(pc_fecha in varchar2);
  ---------------------------------------------------------
  procedure sp_cr_guardar_historico_2(pc_fecha in varchar2);
  ---------------------------------------------------------
  procedure sp_cr_verificar_fin_mes(pc_fecha in varchar2);
  ---------------------------------------------------------
  ---------------------------------------------------------------------------------------------
  function fn_cr_telefono_valido(P_N_PEPAIS in number,
                                 P_N_PETDOC in number,
                                 P_N_PENDOC in char) return varchar2;
  -----------------------------------------------------------------------------
  procedure sp_Cr_UpdAQPB183(ld_fecha in date);
  --------------------------------------------------------------------------------
  procedure sp_Cr_CargaReconver;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
end PQ_CR_jaql964_cartera;
/

create or replace package body PQ_CR_jaql964_cartera is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------
  -- CARTERA DE CREDITOS --
  ---------------------------------------
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_datos(P_D_FECPRO in varchar2,
                              P_N_TIPCAM in number,
                              P_C_ESTADO out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga_datos
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Cargar Cartera de Creditos
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (Fecha de Proceso)
    --                              P_N_TIPCAM (Tipo de Cambio)
    -- Retorno                    : Estado de Proceso.
    -- Fecha de Modificaci¿n      : 2014.10.15
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se agrego estado bcprod <>33 para no considerar cartera refinanciada reestructuradas - judicial
    --                              DCASTRO 07092018 Se agregó condicion para excluir estado 99
    --
    -- *****************************************************************
  
    cursor creditos(fecha varchar2, tc number) is
    
    /*    select JAQL964REG,JAQL964REN,JAQL964SUC,JAQL964MOD,JAQL964MDA,
                                                                                                                                                                                                                                                                                                                                   JAQL964CTA,JAQL964OPE,JAQL964SOB,JAQL964TOP,JAQL964DOC,
                                                                                                                                                                                                                                                                                                                                   sum(JAQL964SAO) JAQL964SAO, 
                                                                                                                                                                                                                                                                                                                                   sum(JAQL964SAC) JAQL964SAC, sum(jaql964sa4) jaql964sa4
                                                                                                                                                                                                                                                                                                                            from (  */
      select /*+parallel(a,2,1) (b,2,1) (r,2,1) (age,2,1) (r2,2,1) (pers,2,1)*/ --jflor 23.01.2014
       r2.regcod JAQL964REG,
       upper(r2.RegNOM) JAQL964REN,
       a.bcsuc JAQL964SUC,
       b.scnom JAQL964NOM,
       a.bcmod JAQL964MOD,
       a.bcmda JAQL964MDA,
       a.bccta JAQL964CTA,
       a.bcoper JAQL964OPE,
       a.bcsbop JAQL964SOB,
       a.bctop JAQL964TOP,
       pers.pendoc JAQL964DOC,
       sum(a.bcsdmo) JAQL964SAO,
       --sum((decode(a.bcmda,0,a.bcsdmo,a.bcsdmo*tc))) JAQL964SAC,       
       sum(a.bcsdmn) JAQL964SAC,
       sum(case
             when substr(a.bcrubr, 1, 4) in (1416, 1426) then --decode(a.bcmda,0,a.bcsdmo,a.bcsdmo*TC)
              a.bcsdmn
           end) jaql964sa4, --judicial
       (select substr(f1.penom, 1, 30)
          from fsd001 f1
         where f1.pepais = pers.pepais
           and f1.petdoc = pers.petdoc
           and f1.pendoc = pers.pendoc) jaql964tit,
       PERS.PEPAIS jaql964pai,
       PERS.PETDOC jaql964tid,
       a.bcgpo jaql964csb,
       case
         when BCGpo = 2 then
          'MICROEMPRESAS'
         when BCGpo = 3 and substr(a.bcrubr, 11, 3) = '015' then
          'CONSUMO REVOLVENTE'
         when BCGpo = 3 and substr(a.bcrubr, 11, 3) <> '015' then
          'CONSUMO NO REVOLVENTE'
         when BCGpo = 4 then
          'HIPOTECARIO'
         when BCGpo = 12 then
          'MEDIANA EMPRESA'
         when BCGpo = 13 then
          'PEQUEÑA EMPRESA'
         when BCGpo = 11 then
          'GRANDES EMPRESAS'
         when BCGpo in (5, 6, 7, 8, 9, 10) then
          'CORPORATIVO'
         else
          ' '
       END jaql964pro,
       a.bcprod JAQL964EST, -- estado 
       sum(case
             when substr(a.bcrubr, 1, 4) in (1414, 1424) and a.bcprod <> 33 then
              a.bcsdmn
           end) jaql964sdre, --no considerar refinanciados transados
       sum(case
             when substr(a.bcrubr, 1, 4) in (1415, 1425) then
              a.bcsdmn
           end) jaql964sdve
        from fsh012 a,
             fst001 b,
             fst811 r,
             FST001 age,
             fst810 r2,
             fsr008 pers
       where a.bccta <> 999999999
         and /*(*/
             substr(a.bcrubr, 1, 4) in
             (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
            /*or substr(a.bcrubr,1,2) =81)*/
            --and a.bcmod in (33)
         and b.pgcod = a.bcemp
         and b.sucurs = a.bcsuc
         and a.bcfech = to_date(fecha, 'rrrrmmdd')
         and r.pgcod = 1
         and r.oficod = a.bcsuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = a.bcsuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         and pers.pgcod = b.pgcod
         and pers.ctnro = a.bccta
         and pers.ttcod = 1
         and pers.CTTFIR = 'T'
         and a.bcprod <> 99 --07092018 SE agrego condicion de estado        
       group by r2.regcod,
                r2.RegNOM,
                a.bcsuc,
                b.scnom,
                a.bcmod,
                a.bcmda,
                a.bccta,
                a.bcoper,
                a.bcsbop,
                a.bctop,
                pers.pendoc,
                PERS.PEPAIS,
                PERS.PETDOC,
                a.bcgpo,
                case
                  when BCGpo = 2 then
                   'MICROEMPRESAS'
                  when BCGpo = 3 and substr(a.bcrubr, 11, 3) = '015' then
                   'CONSUMO REVOLVENTE'
                  when BCGpo = 3 and substr(a.bcrubr, 11, 3) <> '015' then
                   'CONSUMO NO REVOLVENTE'
                  when BCGpo = 4 then
                   'HIPOTECARIO'
                  when BCGpo = 12 then
                   'MEDIANA EMPRESA'
                  when BCGpo = 13 then
                   'PEQUEÑA EMPRESA'
                  when BCGpo = 11 then
                   'GRANDES EMPRESAS'
                  when BCGpo in (5, 6, 7, 8, 9, 10) then
                   'CORPORATIVO'
                  else
                   ' '
                END,
                a.bcprod;
    -- );  
  
    cursor castigados(fecha varchar2, tc number) is
      select /*+parallel(a,2,1) (b,2,1) (r,2,1) (age,2,1) (r2,2,1) (pers,2,1)*/ --jflor 23.01.2014
       r2.regcod JAQL964REG,
       upper(r2.RegNOM) JAQL964REN,
       a.bcsuc JAQL964SUC,
       b.scnom JAQL964NOM,
       a.bcmod JAQL964MOD,
       a.bcmda JAQL964MDA,
       a.bccta JAQL964CTA,
       a.bcoper JAQL964OPE,
       a.bcsbop JAQL964SOB,
       a.bctop JAQL964TOP,
       pers.pendoc JAQL964DOC,
       sum(a.bcsdmo) JAQL964SAO,
       --sum((decode(a.bcmda,0,a.bcsdmo,a.bcsdmo*tc))) JAQL964SAC,       
       sum(a.bcsdmn) JAQL964SAC,
       0 jaql964sa4, --judicial
       (select substr(f1.penom, 1, 30)
          from fsd001 f1
         where f1.pepais = pers.pepais
           and f1.petdoc = pers.petdoc
           and f1.pendoc = pers.pendoc) jaql964tit,
       PERS.PEPAIS jaql964pai,
       PERS.PETDOC jaql964tid,
       a.bcgpo jaql964csb,
       case
         when BCGpo = 2 then
          'MICROEMPRESAS'
         when BCGpo = 3 and substr(a.bcrubr, 11, 3) = '015' then
          'CONSUMO REVOLVENTE'
         when BCGpo = 3 and substr(a.bcrubr, 11, 3) <> '015' then
          'CONSUMO NO REVOLVENTE'
         when BCGpo = 4 then
          'HIPOTECARIO'
         when BCGpo = 12 then
          'MEDIANA EMPRESA'
         when BCGpo = 13 then
          'PEQUEÑA EMPRESA'
         when BCGpo = 11 then
          'GRANDES EMPRESAS'
         when BCGpo in (5, 6, 7, 8, 9, 10) then
          'CORPORATIVO'
         else
          ' '
       END jaql964pro,
       a.bcprod JAQL964EST -- estado 
      
        from fsh012 a,
             fst001 b,
             fst811 r,
             FST001 age,
             fst810 r2,
             fsr008 pers
       where a.bccta <> 999999999
         and substr(a.bcrubr, 1, 2) = 81
         and a.bcmod in (33)
         and b.pgcod = a.bcemp
         and b.sucurs = a.bcsuc
         and a.bcfech = to_date(fecha, 'rrrrmmdd')
         and r.pgcod = 1
         and r.oficod = a.bcsuc
         and r.RegCod < 100
         and age.Pgcod = 1
         and age.Sucurs = a.bcsuc
         and r2.regcod = r.regcod
         and r2.regcod < 100
         and pers.pgcod = b.pgcod
         and pers.ctnro = a.bccta
         and pers.ttcod = 1
         and pers.CTTFIR = 'T'
         and a.bcprod <> 99 --07092018 SE agrego condicion de estado
       group by r2.regcod,
                r2.RegNOM,
                a.bcsuc,
                b.scnom,
                a.bcmod,
                a.bcmda,
                a.bccta,
                a.bcoper,
                a.bcsbop,
                a.bctop,
                pers.pendoc,
                PERS.PEPAIS,
                PERS.PETDOC,
                a.bcgpo,
                case
                  when BCGpo = 2 then
                   'MICROEMPRESAS'
                  when BCGpo = 3 and substr(a.bcrubr, 11, 3) = '015' then
                   'CONSUMO REVOLVENTE'
                  when BCGpo = 3 and substr(a.bcrubr, 11, 3) <> '015' then
                   'CONSUMO NO REVOLVENTE'
                  when BCGpo = 4 then
                   'HIPOTECARIO'
                  when BCGpo = 12 then
                   'MEDIANA EMPRESA'
                  when BCGpo = 13 then
                   'PEQUEÑA EMPRESA'
                  when BCGpo = 11 then
                   'GRANDES EMPRESAS'
                  when BCGpo in (5, 6, 7, 8, 9, 10) then
                   'CORPORATIVO'
                  else
                   ' '
                END,
                a.bcprod;
    -- );          
  
    cursor lineas(fecha varchar2, tc number) is
      SELECT /*+ parallel (t,2,1) (x,2,1) (s,2,1) (d,2,1)  */ --jflor 23.01.2014
      DISTINCT e.sucurs JAQL964SUC,
               e.scnom JAQL964NOM,
               S.SNG001ASE jaql964usu,
               x.scmod JAQL964MOD,
               x.sccta JAQL964CTA,
               x.scoper JAQL964OPE,
               x.sctope JAQL964TOP,
               (select substr(f1.penom, 1, 30)
                  from fsr008 f8, fsd001 f1
                 where f1.pepais = f8.pepais
                   and f1.petdoc = f8.petdoc
                   and f1.pendoc = f8.pendoc
                   and f8.ctnro = x.sccta
                   and f8.ttcod = 1
                   and f8.cttfir = 'T') jaql964tit,
               --decode (x.scmda,0,'Soles','Dolares') JAQL964MDA, 
               x.scmda JAQL964MDA,
               0 JAQL964SAO,
               0 JAQL964SAC,
               0 jaql964sa4,
               D.BNJ096SOR JAQL964CRE,
               decode(x.SCSTAT,
                      64,
                      'Judicial',
                      33,
                      'Ref.Jud.',
                      34,
                      'Ref.PJM',
                      23,
                      'PJ Abo.',
                      25,
                      'PJ Dem.',
                      21,
                      'PJM',
                      22,
                      'PJ',
                      61,
                      'Refinan.',
                      'Normal') jaql964tcc,
               s.sng001pais jaql964pai,
               s.sng001tdoc jaql964tid,
               s.sng001ndoc jaql964doc,
               x.scsbop JAQL964SOB,
               r2.regcod JAQL964REG,
               upper(r2.RegNOM) JAQL964REN,
               x.scgru jaql964csb,
               case
                 when x.scgru = 2 then
                  'MICROEMPRESAS'
                 when x.scgru = 3 and substr(x.scrub, 11, 3) = '015' then
                  'CONSUMO REVOLVENTE'
                 when x.scgru = 3 and substr(x.scrub, 11, 3) <> '015' then
                  'CONSUMO NO REVOLVENTE'
                 when x.scgru = 4 then
                  'HIPOTECARIO'
                 when x.scgru = 12 then
                  'MEDIANA EMPRESA'
                 when x.scgru = 13 then
                  'PEQUEÑA EMPRESA'
                 when x.scgru = 11 then
                  'GRANDES EMPRESAS'
                 when x.scgru in (5, 6, 7, 8, 9, 10) then
                  'CORPORATIVO'
                 else
                  ' '
               END jaql964pro,
               X.SCSTAT jaql964est --esatdo          
        FROM FSD011 X, SNG001 S, BNJ096 D, fst001 e, fst810 r2, fst811 r
       WHERE s.sng001cta = x.sccta
         AND X.SCSTAT = '0'
         AND X.SCMOD = '117' --IN (116)
         and e.pgcod = 1
         and e.sucurs = x.scsuc
         AND D.BNJ096MDA = X.SCMDA
         AND D.BNJ096CTA = X.SCCTA
         AND D.BNJ096OPE = X.SCOPER
         and (not exists (select 1
                            from fsd011 t
                           where t.SCCTA = X.SCCTA
                             and t.SCMOD = '116'))
         and r.pgcod = 1
         and r.oficod = x.scsuc
         and r.RegCod < 100
         and r2.regcod = r.regcod
         and r2.regcod < 100
         and x.scstat <> 99; --07092018 SE agrego condicion de estado;
  
    ln_numero number := 0;
    ln_corr   number := 1;
    tc        number;
    fecha     varchar2(8);
    ln_Sector number := 0;
  
  begin
    P_C_ESTADO := null;
    tc         := P_N_TIPCAM;
    fecha      := P_D_FECPRO;
  
    -----Verificar si el día es el primero del mes
    pq_cr_jaql964_cartera.sp_cr_verificar_fin_mes(fecha);
    -----Insertar Histori
    pq_cr_jaql964_cartera.sp_cr_guardar_historico_1(fecha);
    -----
  
    execute immediate 'truncate table jaql964';
  
    for i in creditos(fecha, tc) loop
    
      insert into jaql964
        (JAQL964COR,
         JAQL964REG,
         JAQL964REN,
         JAQL964SUC,
         JAQL964NOM,
         JAQL964MOD,
         JAQL964MDA,
         JAQL964CTA,
         JAQL964OPE,
         JAQL964SOB,
         JAQL964TOP,
         JAQL964DOC,
         JAQL964SAO,
         JAQL964SAC,
         jaql964sa4,
         jaql964tit,
         jaql964pai,
         jaql964tid,
         jaql964csb,
         jaql964pro,
         jaql964est,
         jaql964sdre,
         jaql964sdve /*, jaql964sec*/,
         Jaql964sdo)
      values
        (ln_corr,
         i.JAQL964REG,
         i.JAQL964REN,
         i.JAQL964SUC,
         i.JAQL964NOM,
         i.JAQL964MOD,
         i.JAQL964MDA,
         i.JAQL964CTA,
         i.JAQL964OPE,
         i.JAQL964SOB,
         i.JAQL964TOP,
         i.JAQL964DOC,
         i.JAQL964SAO,
         i.JAQL964SAC,
         i.jaql964sa4,
         i.jaql964tit,
         i.jaql964pai,
         i.jaql964tid,
         i.jaql964csb,
         i.jaql964pro,
         i.jaql964est,
         i.jaql964sdre,
         i.jaql964sdve /*, ln_sector*/,
         i.JAQL964SAC);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 10000 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(JAQL964COR) into ln_corr from jaql964;
    end;
    ln_corr := ln_corr + 1;
    ----    
    for i in lineas(fecha, tc) loop
    
      insert into jaql964
        (JAQL964COR,
         JAQL964REG,
         JAQL964REN,
         JAQL964SUC,
         JAQL964MOD,
         JAQL964MDA,
         JAQL964CTA,
         JAQL964OPE,
         JAQL964SOB,
         JAQL964TOP,
         JAQL964DOC,
         JAQL964SAO,
         JAQL964SAC,
         jaql964sa4,
         JAQL964CRE,
         JAQL964NOM,
         jaql964usu,
         jaql964tit,
         jaql964pai,
         jaql964tid,
         jaql964tcc,
         jaql964csb,
         jaql964pro,
         jaql964est /*, jaql964sec*/,
         Jaql964sdo)
      values
        (ln_corr,
         i.JAQL964REG,
         i.JAQL964REN,
         i.JAQL964SUC,
         i.JAQL964MOD,
         i.JAQL964MDA,
         i.JAQL964CTA,
         i.JAQL964OPE,
         i.JAQL964SOB,
         i.JAQL964TOP,
         i.JAQL964DOC,
         i.JAQL964SAO,
         i.JAQL964SAC,
         i.jaql964sa4,
         i.JAQL964CRE,
         i.JAQL964NOM,
         I.jaql964usu,
         i.jaql964tit,
         i.jaql964pai,
         i.jaql964tid,
         i.jaql964tcc,
         i.jaql964csb,
         i.jaql964pro,
         i.jaql964est /*, ln_sector*/,
         i.jaql964sac);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 10000 then
        commit;
        ln_numero := 0;
      end if;
    end loop;
    commit;
    ----
    begin
      select max(JAQL964COR) into ln_corr from jaql964;
    end;
    ln_corr := ln_corr + 1;
  
    ----    
    for i in castigados(fecha, tc) loop
    
      insert into jaql964
        (JAQL964COR,
         JAQL964REG,
         JAQL964REN,
         JAQL964SUC,
         JAQL964MOD,
         JAQL964MDA,
         JAQL964CTA,
         JAQL964OPE,
         JAQL964SOB,
         JAQL964TOP,
         JAQL964DOC,
         JAQL964SAO,
         JAQL964SAC,
         jaql964sa4,
         jaql964tit,
         jaql964est,
         jaql964pro,
         Jaql964sdo)
      values
        (ln_corr,
         i.JAQL964REG,
         i.JAQL964REN,
         i.JAQL964SUC,
         i.JAQL964MOD,
         i.JAQL964MDA,
         i.JAQL964CTA,
         i.JAQL964OPE,
         i.JAQL964SOB,
         i.JAQL964TOP,
         i.JAQL964DOC,
         i.JAQL964SAO,
         i.JAQL964SAC,
         i.jaql964sa4,
         i.jaql964tit,
         i.jaql964est,
         i.jaql964pro,
         i.jaql964sac);
      ln_corr   := ln_corr + 1;
      ln_numero := ln_numero + 1;
      if ln_corr = 5000 then
        commit;
        ln_numero := 0;
      end if;
    
    end loop;
    commit;
  
    /* CALCULOS EJECUTAR DESPUES DE PARALELIZACION
    begin
      pq_cr_jaql964_cartera.sp_cr_calculos(P_C_ESTADO);
    end;*/
  
  end sp_cr_carga_datos;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_calculos(P_C_ESTADO out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_calculos
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- *****************************************************************
    cursor cartera is
      select /*+choose*/
       JAQL964REG,
       JAQL964REN,
       JAQL964SUC,
       JAQL964MOD,
       JAQL964MDA,
       JAQL964CTA,
       JAQL964OPE,
       JAQL964SOB,
       JAQL964TOP,
       JAQL964DOC,
       JAQL964SAO,
       JAQL964SAC,
       jaql964sa4,
       JAQL964EST,
       JAQL964TCC,
       JAQL964DIA
        from jaql964;
  
    NumCre              number := 0;
    SaldoCap1_7         number := 0;
    NumCre1_7           number := 0;
    SaldoCap8_15        number := 0;
    NumCre8_15          number := 0;
    SaldoCap16_30       number := 0;
    NumCre16_30         number := 0;
    SaldoCap30          number := 0;
    NumCre30            number := 0;
    PorMor1_7           number := 0;
    PorMor8_15          number := 0;
    PorMor16_30         number := 0;
    PorMor30            number := 0;
    SaldoCapSinJu       number := 0;
    NumCreSinJu         number := 0;
    PorMorSinJu         number := 0;
    SaldoCapJudicialTot number := 0;
    NumCreJudicialTot   number := 0;
    PorMorJudicialTot   number := 0;
    SaldoCapTot         number := 0;
    SaldoCapTotJu       number := 0;
    SaldoCap            number := 0;
    ContCreJu           number := 0;
    SaldoCapJu          number := 0;
    ln_corr             number := 0;
  
  begin
  
    for i in cartera loop
    
      if i.JAQL964TCC <> 'Judicial' then
      
        case
          when i.JAQL964DIA >= 1 And i.JAQL964DIA < 8 then
            --ojo confirmar
            SaldoCap1_7 := SaldoCap1_7 + i.JAQL964SAC;
            NumCre1_7   := NumCre1_7 + 1;
          when i.JAQL964DIA >= 8 And i.JAQL964DIA < 16 then
            SaldoCap8_15 := SaldoCap8_15 + i.JAQL964SAC;
            NumCre8_15   := NumCre8_15 + 1;
          when i.JAQL964DIA >= 16 And i.JAQL964DIA <= 30 then
            SaldoCap16_30 := SaldoCap16_30 + i.JAQL964SAC;
            NumCre16_30   := NumCre16_30 + 1;
          when i.JAQL964DIA > 30 then
            SaldoCap30 := SaldoCap30 + i.JAQL964SAC;
            NumCre30   := NumCre30 + 1;
          else
            null;
        End Case;
        NumCre := NumCre + 1;
      else
        ContCreJu  := ContCreJu + 1;
        SaldoCapJu := SaldoCapJu + i.JAQL964SAC;
      
      end if;
    
      SaldoCapSinJu       := SaldoCapSinJu + (SaldoCap16_30 + SaldoCap30);
      NumCreSinJu         := NumCreSinJu + (NumCre16_30 + NumCre30);
      SaldoCapJudicialTot := SaldoCapJudicialTot +
                             (SaldoCapSinJu + SaldoCapJu);
      NumCreJudicialTot   := NumCreJudicialTot + (NumCreSinJu + ContCreJu);
      SaldoCapTot         := SaldoCapTot + SaldoCap;
    
      update jaql964
         set jaql964NUM = NumCre,
             JAQL964NR1 = NumCre1_7, --//NRO CREDITO 1-7
             JAQL964SA1 = SaldoCap1_7, --//MONTO SALDO 1-7
             JAQL964PO1 = 0, --//PROCENTAJE MORA 1-7
             JAQL964NR2 = NumCre8_15, --//NRO CREDITO 8-15
             JAQL964SA2 = SaldoCap8_15, --//MONTO SALDO 8-15
             JAQL964PO2 = PorMor8_15, --//PROCENTAJE MORA 8-15
             JAQL964NR3 = NumCre16_30, --//NRO CREDITO 16-30
             JAQL964SA3 = SaldoCap16_30, --//MONTO SALDO 16-30
             JAQL964PO3 = 0, --//PROCENTAJE MORA 16-30
             JAQL964NR4 = NumCreSinJu, --//NRO CREDITO SIN JUDICIALES
             JAQL964SA4 = SaldoCapSinJu, --//MONTO SALDO SIN JUDICIALES
             JAQL964PO4 = 0, --//PROCENTAJE MORA SIN JUDICIALES
             JAQL964NR5 = ContCreJu, --//NRO CREDITO JUDICIALES
             JAQL964SA5 = SaldoCapJu, --//MONTO SALDO JUDICIALES
             JAQL964PO5 = 0, --//PROCENTAJE MORA JUDICIALES
             JAQL964NR6 = NumCreJudicialTot, --//NRO CREDITO MORA + JUDICIAL   
             JAQL964SA6 = SaldoCapJudicialTot, --//MONTO SALDO MORA + JUDICIAL   
             JAQL964PO6 = 0, --//PROCENTAJE MORA MORA + JUDICIAL  
             JAQL964NR7 = NumCre30, --//NRO CREDITO 16-30
             JAQL964SA7 = SaldoCap30, --//MONTO SALDO 16-30
             JAQL964PO7 = 0 --//PROCENTAJE MORA 16-30
       where jaql964cta = i.jaql964cta
         and jaql964ope = i.jaql964ope;
    
      --actualiza variables a 0
      SaldoCap1_7         := 0;
      NumCre1_7           := 0;
      SaldoCap8_15        := 0;
      NumCre8_15          := 0;
      SaldoCap16_30       := 0;
      NumCre16_30         := 0;
      SaldoCap30          := 0;
      NumCre30            := 0;
      PorMor1_7           := 0;
      PorMor8_15          := 0;
      PorMor16_30         := 0;
      PorMor30            := 0;
      SaldoCapSinJu       := 0;
      NumCreSinJu         := 0;
      PorMorSinJu         := 0;
      SaldoCapJudicialTot := 0;
      NumCreJudicialTot   := 0;
      PorMorSinJu         := 0;
      PorMorJudicialTot   := 0;
      SaldoCapTot         := 0;
      ContCreJu           := 0;
      SaldoCapJu          := 0;
      NumCre              := 0;
    
      ln_corr := ln_corr + 1;
      if ln_corr = 5000 then
        commit;
        ln_corr := 0;
      end if;
    
    end loop;
    commit;
  
  end sp_cr_calculos;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_actualiza_analista(P_D_FECPRO in varchar2,
                                     P_C_ESTADO out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_analista
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Analista
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      : 2013.10.15
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se modifico validacion rel.r1mod por campo i.jaql964mod
    --
    -- *****************************************************************
    lc_analista varchar2(30);
    --ln_numero number := 0;
    -- ln_instancia number := 0;
    -- lc_mod varchar2(10);
  
    cursor cartera is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       jaql964mod,
       j.jaql964cta,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       jaql964suc,
       jaql964mda,
       j.jaql964usu
        from jaql964 j
       where jaql964usu is null;
  
  begin
    P_C_ESTADO := null;
    for i in cartera loop
    
      if trim(i.jaql964usu) is null then
        lc_analista := fn_analista_credito(i.jaql964mod,
                                           i.jaql964suc,
                                           i.jaql964mda,
                                           0,
                                           i.jaql964cta,
                                           i.jaql964ope,
                                           i.jaql964sob,
                                           i.jaql964top);
      
        /*if i.jaql964mod = 116 then
           lc_mod := 117;
        else
           lc_mod := i.jaql964mod;
        end if;
        
        --encontrar instancia
        select
             max(xw2.xwfprcins) xwfprcins
             into ln_instancia
        from xwf700 xw2
        where xw2.xwfempresa = 1
            and xw2.xwfsucursal  =  i.jaql964suc
            and xw2.xwfmoneda    =  i.jaql964mda
            and xw2.xwfpapel     =  0
            and xw2.xwfcuenta    =  i.jaql964cta
            and xw2.xwfoperacion =  i.jaql964ope
            and xw2.xwfsubope    =  i.jaql964sob
            and xw2.xwfmodulo    =  lc_mod--(case v_Scmod when 116 then 117 else v_Scmod end)
            and xw2.xwftipope    =  i.jaql964top;
            --and xw2.xwfcar3      = '1';
        
         if ln_instancia is null then
            select
                 max(xw2.xwfprcins) xwfprcins
                 into ln_instancia
            from xwf700 xw2,
                 Fsr011 rel
            where xw2.xwfempresa = 1
                and xw2.xwfsucursal  =  rel.r2suc
                and xw2.xwfmoneda    =  rel.r2mda
                and xw2.xwfpapel     =  rel.r2pap
                and xw2.xwfcuenta    =  rel.r2cta
                and xw2.xwfoperacion =  rel.r2oper
                and xw2.xwfsubope    =  rel.r2sbop
                and xw2.xwfmodulo    =  (case i.jaql964mod when 116 then 117 else rel.r2mod end)
                and xw2.xwftipope    =  rel.r2tope
                --and xw2.xwfcar3      = '1'
                and rel.r1cod        = 1
                and rel.r1mod        = i.jaql964mod
                and rel.r1suc        = i.jaql964suc
                and rel.r1mda        = i.jaql964mda
                and rel.r1pap        = 0
                and rel.r1cta        = i.jaql964cta
                and rel.r1oper       = i.jaql964ope
                and rel.r1sbop       = i.jaql964sob
                and rel.r1tope       = i.jaql964top;
          end if;
        
          if ln_instancia is null then
          begin
             select
                 max(xw2.xwfprcins) xwfprcins
                 into ln_instancia
            from xwf700 xw2
            where xw2.xwfempresa = 1
                and xw2.xwfmoneda    =  i.jaql964mda
                and xw2.xwfpapel     =  0
                and xw2.xwfcuenta    =  i.jaql964cta
                and xw2.xwfmodulo    =  lc_mod;
           exception when no_data_found then
                ln_instancia := null;          
           end;
                
           end if;
           
          begin
             select sng001ase
               into lc_analista
              from  sng001
             where  sng001inst =  ln_instancia;
             exception
               when no_data_found then
                    lc_analista := null;
           end;*/
      
        update jaql964
           set jaql964usu = lc_analista
         where jaql964cta = i.jaql964cta
           and jaql964ope = i.jaql964ope
           and jaql964sob = i.jaql964sob
           and jaql964top = i.jaql964top;
      
      end if;
    
    end loop;
  
  end sp_cr_actualiza_analista;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  function fn_cr_analista(vjaql964mod in number,
                          vjaql964cta in number,
                          vjaql964ope in number,
                          vjaql964sob in number,
                          vjaql964top in number,
                          vjaql964suc in number,
                          vjaql964mda in number) return varchar2 is
    -- *****************************************************************
    -- Nombre                     : fn_cr_analista
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Analista
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      :
    --                              
    -- Retorno                    : Codigo de Analista
    -- Fecha de Modificaci¿n      : 2013.10.15
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se modifico validacion rel.r1mod por campo vjaql964mod
    --
    -- *****************************************************************
    lc_analista varchar2(30);
    --ln_numero number := 0;
    -- ln_instancia number := 0;
    -- lc_mod varchar2(10);
  
  begin
  
    lc_analista := fn_analista_credito(vjaql964mod,
                                       vjaql964suc,
                                       vjaql964mda,
                                       0,
                                       vjaql964cta,
                                       vjaql964ope,
                                       vjaql964sob,
                                       vjaql964top);
  
    return(lc_analista);
  
  end fn_cr_analista;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_analista(vjaql964mod  in number,
                           vjaql964cta  in number,
                           vjaql964ope  in number,
                           vjaql964sob  in number,
                           vjaql964top  in number,
                           vjaql964suc  in number,
                           vjaql964mda  in number,
                           pc_analista  out varchar2,
                           pn_instancia out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_analista
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.10.16
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Analista
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      :
    --                              
    -- Retorno                    : Codigo de Analista y Numero de Instancia
    -- Fecha de Modificaci¿n      : 02/05/2021
    -- Autor de la Modificaci¿n   : DCASTRO 
    -- Descripci¿n de Modificaci¿n: Se modifico para obtener analista
    --
    -- *****************************************************************
    lc_analista varchar2(30);
    --ln_numero    number := 0;
    ln_instancia number := 0;
    --lc_mod       varchar2(10);
  
  begin
  
    ln_instancia := fn_instancia_credito(vjaql964mod,
                                         vjaql964suc,
                                         vjaql964mda,
                                         0,
                                         vjaql964cta,
                                         vjaql964ope,
                                         vjaql964sob,
                                         vjaql964top);
    if nvl(ln_instancia, 0) = 0 then
      --02/05/2021                                 
    
      lc_analista := fn_analista_credito(vjaql964mod,
                                         vjaql964suc,
                                         vjaql964mda,
                                         0,
                                         vjaql964cta,
                                         vjaql964ope,
                                         vjaql964sob,
                                         vjaql964top);
    
    else
      --02/05/2021
      begin
        select sng001ase
          into lc_analista
          from sng001
         where sng001inst = ln_instancia;
      exception
        when no_data_found then
          lc_analista := null;
      end;
    
    end if; --02/05/2021
  
    pc_analista  := lc_analista;
    pn_instancia := ln_instancia;
  
  end sp_cr_analista;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_actualiza_dir(P_D_FECPRO in varchar2,
                                P_C_ESTADO out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_dir
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Direccion
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      : 2024.02.12
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- *****************************************************************
    ln_numero       number := 0;
    lc_telefo       varchar2(20);
    lc_direc        varchar2(150);
    lc_distri       varchar2(50);
    lc_provincia    varchar2(50); --2018
    lc_departamento varchar2(50); --2018
    ln_pepais       number(3);
    ln_petdoc       number(2);
  
    cursor cartera is
      select distinct jaql964doc, jaql964cta from jaql964 j;
  
  begin
    P_C_ESTADO := null;
  
    for i in cartera loop
      begin
        select pepais, petdoc
          into ln_pepais, ln_petdoc
          from fsr008
         where ctnro = i.jaql964cta
           and pendoc = i.jaql964doc
           and ttcod = 1
           and rownum < 2;
      exception
        when others then
          ---2024.02.12 dcastro se agrego excepcion
          ln_petdoc := null;
      end;
    
      ---2024.02.12 dcastro se agrego busqueda a funcion 
      begin
        lc_telefo := PQ_CR_jaql964_cartera.fn_cr_telefono_valido(P_N_PEPAIS => ln_pepais,
                                                                 P_N_PETDOC => ln_petdoc,
                                                                 P_N_PENDOC => i.jaql964doc);
      end;
    
      if lc_telefo is null then
        ---2024.02.12 dcastro si variable telefono es nula realiza la bsuqeda tradicional
        begin
          select trim(dotelfp)
            into lc_telefo
            from fsr005 f
           where pepais = ln_pepais
             and petdoc = ln_petdoc
             and pendoc = i.jaql964doc
             and rownum < 2;
        exception
          when NO_DATA_FOUND then
            lc_telefo := ' ';
        end;
      
      end if; --- 2024.02.12 dcastro 
    
      --direccion
      begin
        select trim(sngc13dir), trim(f.fst071dsc)
          into lc_direc, lc_distri
          from sngc13 s, fst071 f
         where f.fst071pai = s.sngc13pais
           and f.fst071col = s.sngc13dist
           and s.sngc13pdoc = ln_pepais
           and s.sngc13tdoc = ln_petdoc
           and s.sngc13ndoc = i.jaql964doc
           and rownum < 2;
      exception
        when NO_DATA_FOUND then
          lc_direc  := ' ';
          lc_distri := ' ';
      end;
    
      --
      --actualiza telefono, direccion, distrito
      begin
        update jaql964
           set jaql964tel = lc_telefo,
               jaql964dir = lc_direc,
               jaql964dis = lc_distri
         where jaql964doc = i.jaql964doc
           and jaql964cta = i.jaql964cta;
      end;
    
      ln_numero := ln_numero + 1;
      if ln_numero = 5000 then
        ln_numero := 0;
        commit;
      end if;
    
      lc_telefo := null; ---2024.02.12 dcastro se agrego variables
      lc_direc  := null;
      lc_distri := null;
    
    end loop;
  
    commit;
  
  end sp_cr_actualiza_dir;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_direccion(vjaql964cta in number,
                            vjaql964doc in char,
                            vtelefono   out varchar2,
                            vdireccion  out varchar2,
                            vdistrito   out varchar2,
                            vreferencia out varchar2) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_direccion
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Direccion
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      : 2024.02.20 
    -- Autor de la Modificaci¿n   : dcastro
    -- Descripci¿n de Modificaci¿n: se agrego asignacion a variable
    --
    -- *****************************************************************
    -- ln_numero number :=0;
    lc_telefo varchar2(20);
    -- lc_direc  varchar2(150);
    -- lc_distri varchar2(50);
    ln_pepais number(3);
    ln_petdoc number(2);
    --lc_REFER  varchar2(200);
  
  begin
  
    begin
      select /*+choose*/
       pepais, petdoc
        into ln_pepais, ln_petdoc
        from fsr008
       where ctnro = vjaql964cta
         and pendoc = vjaql964doc
         and ttcod = 1
         and rownum < 2;
    exception
      when NO_DATA_FOUND then
        ln_pepais := null;
        ln_petdoc := null;
    end;
  
    ---2024.02.12 dcastro se agrego busqueda a funcion 
    begin
      lc_telefo := PQ_CR_jaql964_cartera.fn_cr_telefono_valido(P_N_PEPAIS => ln_pepais,
                                                               P_N_PETDOC => ln_petdoc,
                                                               P_N_PENDOC => vjaql964doc);
    end;
    vtelefono := lc_telefo; --2024.02.20 dcastro, se agrego asignacion a variable  
    if lc_telefo is null then
      ---2024.02.12 dcastro si variable telefono es nula realiza la bsuqeda tradicional
    
      begin
        select /*+choose*/
         trim(dotelfp)
          into vtelefono
          from fsr005 f
         where pepais = ln_pepais
           and petdoc = ln_petdoc
           and pendoc = vjaql964doc
           and rownum < 2;
      exception
        when NO_DATA_FOUND then
          vtelefono := ' ';
      end;
    
    end if; ---2024.02.12 dcastro 
  
    --direccion
    begin
    
      begin
        select /*+choose*/
         trim(sngc13dir), trim(f.fst071dsc), trim(sngc13ref1)
          into vdireccion, vdistrito, vreferencia
          from sngc13 s, fst071 f
         where f.fst071pai = s.sngc13pdoc
           and f.fst071col = s.sngc13dist
              /*and s.sngc13pdoc = ln_pepais*/
           and s.sngc13tdoc = ln_petdoc
           and s.sngc13ndoc = vjaql964doc
           and s.docod = 1
           and s.sngc13est = 'H'
           and s.sngc13corr = (select max(sngc13corr)
                                 from sngc13
                                where sngc13ndoc = vjaql964doc
                                  and sngc13tdoc = ln_petdoc
                                  and docod = 1
                                  and sngc13est = 'H')
           and rownum < 2;
      
      exception
        when NO_DATA_FOUND then
          vdireccion  := ' ';
          vdistrito   := ' ';
          vreferencia := ' ';
      end;
    
      if vdireccion is null then
        select /*+choose*/
         trim(s.sngc13dsc1)
          into vdireccion
          from sngc13 s, fst071 f
         where f.fst071pai = s.sngc13pdoc
           and f.fst071col = s.sngc13dist
              /*and s.sngc13pdoc = ln_pepais*/
           and s.sngc13tdoc = ln_petdoc
           and s.sngc13ndoc = vjaql964doc
           and s.docod = 1
           and s.sngc13est = 'H'
           and s.sngc13corr = (select max(sngc13corr)
                                 from sngc13
                                where sngc13ndoc = vjaql964doc
                                  and sngc13tdoc = ln_petdoc
                                  and docod = 1
                                  and sngc13est = 'H')
           and rownum < 2;
      
      end if;
    end;
  
  end sp_cr_direccion;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualiza_monto(P_D_FECPRO in varchar2,
                                  P_C_ESTADO out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_monto
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Monto Aprobado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor cartera_cre is
      select /*+choose*/
       jaql964mod,
       j.jaql964cta,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       jaql964suc,
       jaql964mda,
       j.jaql964usu
        from jaql964 j
       where jaql964usu is null;
  
    cursor garantia_jud(mod    in varchar2,
                        suc    in varchar2,
                        mon    in varchar2,
                        pap    varchar2,
                        cta    varchar2,
                        ope    varchar2,
                        subope varchar2,
                        tipope varchar2) is
      select R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope, r1mda
        from Fsr011 rel
       where rel.r2cod = 1
         and rel.r2mod = mod
         and rel.r2suc = suc
         and rel.r2mda = mon
         and rel.r2pap = pap
         and rel.r2cta = cta
         and rel.r2oper = ope
         and rel.r2sbop = subope
         and rel.r2tope = tipope
         and rel.relcod in (33, 34, 35) --garantia
         and rel.r011co = 'S';
  
    --lc_tipocontable varchar2(20);
    --lc_producto varchar(30);
    --ln_provision number(17,2);
    -- ln_codcalif number(16);
    -- lc_califica varchar2(30);
    --  ln_bcgpo number;
    ln_numero number := 0;
    --  lc_abogado varchar2(20);
  
    -- lc_garantia varchar2(300); 
    --  lc_tonom varchar2(30);
    --ln_cont number :=0;
    lc_mod   varchar2(10);
    ln_monto number := 0;
  
    /*lR1MOD  fsr011.R1MOD%TYPE;
    lR1CTA  fsr011.R1CTA%TYPE;
    lR1OPER fsr011.R1OPER%TYPE;
    lR1SBOP fsr011.R1SBOP%TYPE;
    lr1suc  fsr011.r1suc%TYPE;
    lr1pap  fsr011.r1pap%TYPE;
    lr1tope fsr011.r1tope%TYPE;
    lr2tope fsr011.r1tope%TYPE;*/
  
    --R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope ,r1mda
  
  begin
  
    for i in cartera_cre loop
    
      if i.jaql964mod in (200, 33) then
      
        for z in garantia_jud(i.jaql964mod, i.jaql964suc, i.jaql964mda, 0, i.jaql964cta, i.jaql964ope, i.jaql964sob, i.jaql964top) loop
          if z.r1mod = 116 then
            lc_mod := 117;
          else
            lc_mod := z.r1mod;
          end if;
          begin
            select /*+parallel (x,2,1)*/ --jflor 23.01.2014
             xllcapital
              into ln_monto
              from x054023 x
             where xllpgcod = 1
               and xllaomod = lc_mod
               and xllaomda = z.r1mda
               and xllaopap = 0
               and xllaocta = z.r1cta
               and xllaooper = z.r1oper;
          exception
            when no_data_found then
              ln_monto := 0;
            when too_many_rows then
              --dbms_output.put_line('1 '||z.r1cta ||' '|| z.r1oper||' '||ln_monto||' '||lc_mod ) ;       
              ln_monto := 0;
          end;
        
        end loop;
      
      else
        begin
          select /*+parallel (x,2,1)*/ --jflor 23.01.2014
           xllcapital
            into ln_monto
            from x054023 x
           where xllpgcod = 1
             and xllaomda = i.jaql964mda
             and xllaopap = 0
             and xllaocta = i.jaql964cta
             and xllaooper = i.jaql964ope;
        exception
          when no_data_found then
            ln_monto := 0;
          when too_many_rows then
            --  dbms_output.put_line('1 '||i.cuenta ||' '|| i.operacion||' '||ln_monto||' '||i.modulo ) ;       
            ln_monto := 0;
        end;
      
      end if;
    
      update jaql964
         set jaql964mta = ln_monto
       where jaql964cta = i.jaql964cta
         and jaql964ope = i.jaql964ope;
    
      ln_numero := ln_numero + 1;
      if ln_numero = 5000 then
        ln_numero := 0;
        commit;
      end if;
    
    --dbms_output.put_line(i.cuenta ||' '|| i.operacion||' '||ln_monto ) ;   
    
    end loop;
  
  end sp_cr_actualiza_monto;

  ------------------------------------------------------------- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_monto(vjaql964mod in number,
                       vjaql964cta in number,
                       vjaql964ope in number,
                       vjaql964sob in number,
                       vjaql964top in number,
                       vjaql964suc in number,
                       vjaql964mda in number) return number is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_monto 
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Monto Aprobado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : Monto Aprobado
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor garantia_jud(mod    in varchar2,
                        suc    in varchar2,
                        mon    in varchar2,
                        pap    varchar2,
                        cta    varchar2,
                        ope    varchar2,
                        subope varchar2,
                        tipope varchar2) is
      select R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope, r1mda
        from Fsr011 rel
       where rel.r2cod = 1
         and rel.r2mod = mod
         and rel.r2suc = suc
         and rel.r2mda = mon
         and rel.r2pap = pap
         and rel.r2cta = cta
         and rel.r2oper = ope
         and rel.r2sbop = subope
         and rel.r2tope = tipope
         and rel.relcod in (33, 34, 35) --garantia
         and rel.r011co = 'S';
  
    /* lc_tipocontable varchar2(20);
    lc_producto varchar(30);
      ln_provision number(17,2);
      ln_codcalif number(16);
      lc_califica varchar2(30);
      ln_bcgpo number;
      ln_numero number:=0;
      lc_abogado varchar2(20);*/
  
    --lc_garantia varchar2(300); 
    --  lc_tonom varchar2(30);
    --  ln_cont number :=0;
    lc_mod   varchar2(10);
    ln_monto number := 0;
  
    /*lR1MOD  fsr011.R1MOD%TYPE;
    lR1CTA  fsr011.R1CTA%TYPE;
    lR1OPER fsr011.R1OPER%TYPE;
    lR1SBOP fsr011.R1SBOP%TYPE;
    lr1suc  fsr011.r1suc%TYPE;
    lr1pap  fsr011.r1pap%TYPE;
    lr1tope fsr011.r1tope%TYPE;
    lr2tope fsr011.r1tope%TYPE;*/
  
    --R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope ,r1mda
  
  begin
  
    if vjaql964mod in (200, 33) then
    
      for z in garantia_jud(vjaql964mod, vjaql964suc, vjaql964mda, 0, vjaql964cta, vjaql964ope, vjaql964sob, vjaql964top) loop
        if z.r1mod = 116 then
          lc_mod := 117;
        else
          lc_mod := z.r1mod;
        end if;
        begin
          select /*+parallel (x,2,1)*/ --jflor 23.01.2014
           xllcapital
            into ln_monto
            from x054023 x
           where xllpgcod = 1
             and xllaomod = lc_mod
             and xllaomda = z.r1mda
             and xllaopap = 0
             and xllaocta = z.r1cta
             and xllaooper = z.r1oper;
        exception
          when no_data_found then
            ln_monto := 0;
          when too_many_rows then
            --dbms_output.put_line('1 '||z.r1cta ||' '|| z.r1oper||' '||ln_monto||' '||lc_mod ) ;       
            ln_monto := 0;
        end;
      
      end loop;
    
    else
      begin
        select /*+parallel (x,2,1)*/ --jflor 23.01.2014
         xllcapital
          into ln_monto
          from x054023 x
         where xllpgcod = 1
           and xllaomda = vjaql964mda
           and xllaopap = 0
           and xllaocta = vjaql964cta
           and xllaooper = vjaql964ope;
      exception
        when no_data_found then
          ln_monto := 0;
        when too_many_rows then
          --  dbms_output.put_line('1 '||i.cuenta ||' '|| i.operacion||' '||ln_monto||' '||i.modulo ) ;       
          ln_monto := 0;
      end;
    
    end if;
  
    return(ln_monto);
  end fn_cr_monto;

  ------------------------------------------------------------- 

  function fn_cr_garantia(vjaql964mod in number,
                          vjaql964cta in number,
                          vjaql964ope in number,
                          vjaql964sob in number,
                          vjaql964top in number,
                          vjaql964suc in number,
                          vjaql964mda in number) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_garantia
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Garantia
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor garantia(modulo    in number,
                    sucursal  in number,
                    moneda    in number,
                    papel     in number,
                    cta       in number,
                    operacion in number,
                    subope    in number,
                    tipope    in number) is
      select R2MOD, R2CTA, R2OPER, R2SBOP, r2suc, r2pap, r2tope
        from Fsr011 rel
       where rel.r1cod = 1
         and rel.r1mod = modulo
         and rel.r1suc = sucursal
         and rel.r1mda = moneda
         and rel.r1pap = papel
         and rel.r1cta = cta
         and rel.r1oper = operacion
            -- and rel.r1sbop       = subope
         and rel.r1tope = tipope
         and rel.relcod = 50 --garantia
         and rel.r011co = 'S';
  
    cursor garantiaI(modulo    in number,
                     sucursal  in number,
                     moneda    in number,
                     papel     in number,
                     cta       in number,
                     operacion in number,
                     subope    in number,
                     tipope    in number) is
      select /*+FIRST_ROWS*/
       R2MOD, R2CTA, R2OPER, R2SBOP, r2suc, r2pap, r2tope
        from Fsr011 rel
       where rel.r1cod = 1
            --and rel.r1mod        = modulo
         and rel.r1suc = sucursal
         and rel.r1mda = moneda
         and rel.r1pap = papel
         and rel.r1cta = cta
         and rel.r1oper = operacion
            -- and rel.r1sbop       = subope
            --and rel.r1tope       = tipope
         and rel.relcod = 50 --garantia
         and rel.r011co = 'S';
    /*
    
    cursor garantia_jud (modulo in varchar2, sucursal in varchar2, moneda in varchar2, papel varchar2, 
                        cta varchar2, operacion varchar2, subope varchar2, tipope varchar2) is
                select R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope ,r1mda
                 from Fsr011 rel
                where rel.r2cod          = 1
                  and rel.r2mod        = modulo
                  and rel.r2suc        = sucursal
                  and rel.r2mda        = moneda
                  and rel.r2pap        = papel
                  and rel.r2cta        = cta
                  and rel.r2oper       = operacion
                  --and rel.r2sbop       = subope
                  and rel.r2tope       = tipope
                  and rel.relcod        in (33,34,35) --garantia
                  and rel.r011co       = 'S';*/
  
    --lc_tipocontable varchar2(20);
    --lc_producto varchar(30);
    --ln_provision number(17,2);
    -- ln_codcalif number(16);
    -- lc_califica varchar2(30);
    -- ln_bcgpo number;
    -- ln_numero number:=0;
    -- lc_abogado varchar2(20);
  
    lc_garantia varchar2(1000);
    lc_tonom    varchar2(30);
    ln_cont     number := 0;
    lc_mod      varchar2(10);
  
    /*lR1MOD  fsr011.R1MOD%TYPE;
    lR1CTA  fsr011.R1CTA%TYPE;
    lR1OPER fsr011.R1OPER%TYPE;
    lR1SBOP fsr011.R1SBOP%TYPE;
    lr1suc  fsr011.r1suc%TYPE;
    lr1pap  fsr011.r1pap%TYPE;
    lr1tope fsr011.r1tope%TYPE;
    lr2tope fsr011.r1tope%TYPE;*/
  
  begin
    ---- 
    --garantia
    lc_garantia := null;
    ln_cont     := 0;
  
    if vjaql964mod = 116 then
      lc_mod := 117;
    else
      lc_mod := vjaql964mod;
    end if;
  
    --dbms_output.put_line(i.cuenta ||' '|| i.operacion||' '||lc_garantia ||' '||length(trim(lc_garantia))) ;
    --dbms_output.put_line(i.cuenta ||' '|| i.operacion||' '||lc_garantia ||' '||length(trim(lc_garantia))) ;
    /*if lc_mod in ( 200, 33) then
        for z in garantia_jud(vjaql964mod, vjaql964suc, vjaql964mda, 0, vjaql964cta, vjaql964ope, vjaql964sob, vjaql964top) loop
              if z.r1mod = 116 then                                                               
                 lc_mod := 117;
              else 
                 lc_mod := z.r1mod ;
              end if;
              begin
                  for y in garantia(z.r1mod, z.r1suc, z.R1mda, z.r1pap, z.R1CTA, z.R1OPER, z.R1SBOP\*,z.r1tope*\) loop
                    if y.r2tope is not null then
                      begin
                         select trim(tonom) 
                           into lc_tonom
                           from fst004 where modulo = 70 and totope = y.r2tope;
                      exception when no_data_found then
                        lc_tonom := null;             
                      end;      
                      if ln_cont < 10 then
                         lc_garantia  :=  lc_garantia || lc_tonom||',';            
                         ln_cont := ln_cont + 1;
                      end if;
                        
                    end if;
                  
                  end loop;
               end;
            
        end loop;
        -- dbms_output.put_line('2- ' ||i.cuenta ||' '|| i.operacion||' '|| lc_mod||' '||lc_garantia ||' '||length(trim(lc_garantia))) ;
    else*/
  
    begin
      for y in garantia(vjaql964mod, vjaql964suc, vjaql964mda, 0, vjaql964cta, vjaql964ope, vjaql964sob, vjaql964top) loop
        if y.r2tope is not null then
          begin
            select trim(tonom)
              into lc_tonom
              from fst004
             where modulo = 70
               and totope = y.r2tope;
          exception
            when no_data_found then
              lc_tonom := null;
          end;
          if ln_cont < 10 then
            lc_garantia := lc_garantia || lc_tonom || ',';
            ln_cont     := ln_cont + 1;
          end if;
        
        end if;
      
      end loop;
    
      if lc_garantia is null then
        for j in garantiaI(vjaql964mod, vjaql964suc, vjaql964mda, 0, vjaql964cta, vjaql964ope, vjaql964sob, vjaql964top) loop
        
          begin
            select trim(tonom)
              into lc_tonom
              from fst004
             where modulo = 70
               and totope = j.r2tope;
          exception
            when no_data_found then
              lc_tonom := null;
          end;
          if ln_cont < 10 then
            lc_garantia := lc_garantia || lc_tonom || ',';
            ln_cont     := ln_cont + 1;
          end if;
        
        end loop;
      end if;
    
    end;
    --dbms_output.put_line('1- ' ||i.cuenta ||' '|| i.operacion||' '|| lc_mod||' '||lc_garantia ||' '||length(trim(lc_garantia))) ;    
  
    -- end if;   
    lc_garantia := substr(lc_garantia, 1, 300);
  
    return(lc_garantia);
  
  end fn_cr_garantia;
  ---------------------------------------------------------------------------------------------
  function fn_cr_abogado(P_N_PGCOD     in number,
                         P_N_MONEDA    in number,
                         P_N_PAPEL     in number,
                         P_N_CUENTA    in number,
                         P_N_OPERACION in number,
                         P_N_MODULO    in number,
                         P_N_SUCURSAL  in number,
                         P_N_SUBOPER   in number,
                         P_N_TIPOPER   in number) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_abogado
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Abogado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    lc_abogado varchar2(50);
    lc_coderr  varchar2(100);
    lc_msgerr  varchar2(100);
  
  begin
    BEGIN
    
      SELECT distinct s.jaqm34nom
        into lc_abogado
        from jaqm35 t
        left join jaqm34 s
          on s.jaqm34cod = t.jaqm34cod
       where t.jaqm35pgco = P_N_PGCOD
         and t.jaqm35mda = P_N_MONEDA
         and t.jaqm35pap = P_N_PAPEL
         and t.jaqm35cta = P_N_CUENTA
         and t.jaqm35oper = P_N_OPERACION
         and t.jaqm35tcon = 'S'
         and t.jaqm35tope = 550
      /*and t.jaqm35corr = 1
      and t.jaqm35sbop = (
                select min(t.jaqm35sbop)
                from jaqm35 t
                left join jaqm34 s
                on  s.jaqm34cod = t.jaqm34cod
                where t.jaqm35pgco=P_N_PGCOD
                and t.jaqm35mda=P_N_MONEDA
                and t.jaqm35pap=P_N_PAPEL
                and t.jaqm35cta=P_N_CUENTA
                and t.jaqm35oper=P_N_OPERACION
                 and t.jaqm35tcon='S'
        );*/
      /*and (t.jaqm35corr,t.jaqm35sbop)in (
              select max(t.jaqm35corr),max(t.jaqm35sbop)
              from jaqm35 t
              left join jaqm34 s
              on  s.jaqm34cod = t.jaqm34cod
              where t.jaqm35pgco=P_N_PGCOD
              and t.jaqm35mda=P_N_MONEDA
              and t.jaqm35pap=P_N_PAPEL
              and t.jaqm35cta=P_N_CUENTA
              and t.jaqm35oper=P_N_OPERACION
               and t.jaqm35tcon='S'
      )*/
      ;
    
    exception
      WHEN TOO_MANY_ROWS THEN
        begin
          select distinct s.jaqm34nom
            into lc_abogado
            from jaqm35 t
            left join jaqm34 s
              on s.jaqm34cod = t.jaqm34cod
           inner join fsd010 f
              on t.jaqm35pgco = f.pgcod
             and t.jaqm35mod = f.aomod
             and t.jaqm35suc = f.aosuc
             and t.jaqm35mda = f.aomda
             and t.jaqm35pap = f.aopap
             and t.jaqm35cta = f.aocta
             and t.jaqm35oper = f.aooper
             and t.jaqm35sbop = f.aosbop
             and t.jaqm35tope = f.aotope
          
           where t.jaqm35pgco = P_N_PGCOD
             and t.jaqm35mda = P_N_MONEDA
             and t.jaqm35pap = P_N_PAPEL
             and t.jaqm35cta = P_N_CUENTA
             and t.jaqm35oper = P_N_OPERACION
             and t.jaqm35tcon = 'S'
             and f.aostat <> 99
             and (t.jaqm35corr, t.jaqm35sbop) in
                 (select max(t.jaqm35corr), max(t.jaqm35sbop)
                    from jaqm35 t
                    left join jaqm34 s
                      on s.jaqm34cod = t.jaqm34cod
                   where t.jaqm35pgco = P_N_PGCOD
                     and t.jaqm35mda = P_N_MONEDA
                     and t.jaqm35pap = P_N_PAPEL
                     and t.jaqm35cta = P_N_CUENTA
                     and t.jaqm35oper = P_N_OPERACION
                     and t.jaqm35tcon = 'S');
        
        exception
          when no_data_found then
            begin
            
              select distinct s.jaqm34nom
                into lc_abogado
                from jaqm35 t
                left join jaqm34 s
                  on s.jaqm34cod = t.jaqm34cod
               inner join fsr011 f
                  on t.jaqm35pgco = f.r1cod
                 and t.jaqm35mod = f.r1mod
                 and t.jaqm35suc = f.r1suc
                 and t.jaqm35mda = f.r1mda
                 and t.jaqm35pap = f.r1pap
                 and t.jaqm35cta = f.r1cta
                 and t.jaqm35oper = f.r1oper
                 and t.jaqm35sbop = f.r1sbop
                 and t.jaqm35tope = f.r1tope
                 and t.jaqm35tcon = 'S'
               where f.r1cod = P_N_PGCOD
                 and f.r2mod = P_N_MODULO
                 and f.r2suc = P_N_SUCURSAL
                 and f.r2mda = P_N_MONEDA
                 and f.r2pap = P_N_PAPEL
                 and r2cta = P_N_CUENTA
                 and r2oper = P_N_OPERACION
                 and f.r2sbop = P_N_SUBOPER
                 and f.r2tope = P_N_TIPOPER
                 and f.relcod = 33;
            exception
              when no_data_found then
                begin
                  select distinct s.jaqm34nom
                    into lc_abogado
                    from jaqm35 t
                    left join jaqm34 s
                      on s.jaqm34cod = t.jaqm34cod
                   inner join fsr011 f
                      on t.jaqm35pgco = f.r1cod
                     and t.jaqm35mod = f.r1mod
                     and t.jaqm35suc = f.r1suc
                     and t.jaqm35mda = f.r1mda
                     and t.jaqm35pap = f.r1pap
                     and t.jaqm35cta = f.r1cta
                     and t.jaqm35oper = f.r1oper
                     and t.jaqm35sbop = f.r1sbop
                     and t.jaqm35tope = f.r1tope
                     and t.jaqm35tcon = 'S'
                   where f.r1cod = P_N_PGCOD
                     and f.r2mod = P_N_MODULO
                     and f.r2suc = P_N_SUCURSAL
                     and f.r2mda = P_N_MONEDA
                     and f.r2pap = P_N_PAPEL
                     and r2cta = P_N_CUENTA
                     and r2oper = P_N_OPERACION
                     and f.r2sbop = P_N_SUBOPER
                     and f.r2tope = P_N_TIPOPER
                     and f.relcod = 36;
                
                EXCEPTION
                  when others then
                    /*lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;*/
                    null;
                  
                end;
              
              when others then
                /*lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;*/
                null;
            end;
          when others then
            /*lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;*/
            null;
        end;
      when no_data_found then
        /*lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;*/
        null;
      when others then
        /*lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;*/
        null;
    end;
  
    return(lc_abogado);
  
  end fn_cr_abogado;
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_tipocontable(P_D_FECPRO  in date,
                               vjaql964mod in number,
                               vjaql964cta in number,
                               vjaql964ope in number,
                               vjaql964sob in number,
                               vjaql964top in number,
                               vjaql964suc in number,
                               vjaql964mda in number,
                               vtipcon     out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_tipocontable
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Tipo Contable
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : Tipo Contable
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
    lc_tipocontable varchar2(20);
    ln_rubro        number;
    ln_rub          number;
    STR_SQL         varchar2(1000);
    vfecpro         varchar2(10);
  
  begin
    --' from FSH012  (FSH012_'||TO_CHAR(P_D_FECPRO,'YYYYMMDD')||') a'||
  
    --tipo contable
    vfecpro := TO_CHAR(P_D_FECPRO, 'DD/MM/RRRR');
  
    STR_SQL := ' select  ' || ' /*+ALL_ROWS */ ' || '  bcrubr  ' ||
               ' from FSH012  a' || ' where a.bcemp = 1 ' ||
               '  and a.bcsuc = ' || vjaql964suc || ' ' ||
               '  and substr(a.bcrubr, 1, 4) in (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426) ' ||
               '  and a.bcmda = ' || vjaql964mda || ' ' ||
               '  and a.bcpap = 0 ' || '  and a.bccta = ' || vjaql964cta || ' ' ||
               '  and a.bcoper = ' || vjaql964ope || ' ' ||
               '  and a.bcsbop = ' || vjaql964sob || ' ' ||
               '  and a.bctop = ' || vjaql964top || ' ' ||
               '  and a.bcfech = ''' || vfecpro || '''';
  
    --|| TO_DATE('''||TO_CHAR(P_D_FECPRO)||''','''YYYY/MM/DD''') ;
  
    --  TO_DATE('''||TO_CHAR(pd_fecape)||''',''DD/MM/RRRR'')
    BEGIN
      EXECUTE IMMEDIATE str_sql
        INTO ln_rubro;
    END;
    ln_rub := substr(ln_rubro, 4, 1);
  
    if ln_rub = '1' then
      vtipcon := 'Normal';
    elsif ln_rub = '4' then
      vtipcon := 'Refinanciado';
    elsif ln_rub = '5' then
      vtipcon := 'Vencido';
    elsif ln_rub = '6' then
      vtipcon := 'Judicial';
    end if;
  exception
    when others then
      vtipcon := ' ';
      --when others null
  
  end sp_cr_tipocontable;

  ---------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza(P_D_FECPRO in date, P_C_ESTADO out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor cartera is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       j.jaql964mod,
       j.jaql964cta,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       j.jaql964pap
        from jaql964 j;
  
    lc_tipocontable varchar2(20);
    lc_abogado      varchar2(50);
    lc_garantia     varchar2(300);
    ln_monto        number := 0;
    lc_telefo       varchar2(20);
    lc_direc        varchar2(150);
    lc_distri       varchar2(50);
    lc_analista     varchar2(30);
    ln_numero       number := 0;
    lc_tipcon       varchar2(30);
    lc_bcgpo        number(4);
    lc_produc       varchar2(30);
    lc_tipocre      varchar2(30);
    lc_credito      varchar2(20);
    lc_refer        varchar2(200);
    ln_pgcod        number := 1;
  
  begin
  
    for i in cartera loop
    
      begin
        --analista
      
        lc_analista := pq_cr_jaql964_cartera.fn_cr_analista(i.jaql964mod,
                                                            i.jaql964cta,
                                                            i.jaql964ope,
                                                            i.jaql964sob,
                                                            i.jaql964top,
                                                            i.jaql964suc,
                                                            i.jaql964mda);
      end;
    
      begin
        --abogado
        lc_abogado := pq_cr_jaql964_cartera.fn_cr_abogado(ln_pgcod,
                                                          i.jaql964mda,
                                                          i.jaql964pap,
                                                          i.jaql964cta,
                                                          i.jaql964ope,
                                                          i.jaql964mod,
                                                          i.jaql964suc,
                                                          i.jaql964sob,
                                                          i.jaql964top);
      end;
    
      begin
        --garantia
        lc_garantia := pq_cr_jaql964_cartera.fn_cr_garantia(i.jaql964mod,
                                                            i.jaql964cta,
                                                            i.jaql964ope,
                                                            i.jaql964sob,
                                                            i.jaql964top,
                                                            i.jaql964suc,
                                                            i.jaql964mda);
      end;
    
      begin
        --direccion
      
        pq_cr_jaql964_cartera.sp_cr_direccion(i.jaql964cta,
                                              i.jaql964doc,
                                              lc_telefo,
                                              lc_direc,
                                              lc_distri,
                                              lc_refer);
      end;
    
      begin
        --tipo contable
        pq_cr_jaql964_cartera.sp_cr_tipocontable(P_D_FECPRO,
                                                 i.jaql964mod,
                                                 i.jaql964cta,
                                                 i.jaql964ope,
                                                 i.jaql964sob,
                                                 i.jaql964top,
                                                 i.jaql964suc,
                                                 i.jaql964mda,
                                                 lc_tipcon);
      end;
    
      begin
        --monto aprobado
        ln_monto := pq_cr_jaql964_cartera.fn_cr_monto(i.jaql964mod,
                                                      i.jaql964cta,
                                                      i.jaql964ope,
                                                      i.jaql964sob,
                                                      i.jaql964top,
                                                      i.jaql964suc,
                                                      i.jaql964mda);
      end;
    
      begin
        --tipo credito
      
        lc_tipocre := pq_cr_jaql964_cartera.fn_cr_tipocredito(i.jaql964mod,
                                                              i.jaql964cta,
                                                              i.jaql964ope,
                                                              i.jaql964sob,
                                                              i.jaql964top,
                                                              i.jaql964suc,
                                                              i.jaql964mda);
      end;
    
      begin
        --credito sorfy
        lc_credito := pq_cr_jaql964_cartera.fn_cr_credito_sorfy(i.jaql964mod,
                                                                i.jaql964ope,
                                                                i.jaql964mda);
      end;
    
      update jaql964
         set jaql964usu = lc_analista,
             jaql964abo = lc_abogado,
             jaql964gar = lc_garantia,
             jaql964tel = lc_telefo,
             jaql964dir = lc_direc,
             jaql964dis = lc_distri,
             jaql964tco = lc_tipcon,
             jaql964csb = lc_bcgpo,
             jaql964pro = lc_produc,
             jaql964mta = ln_monto,
             jaql964tcc = lc_tipocre,
             jaql964red = lc_refer
       where jaql964cta = i.jaql964cta
         and jaql964ope = i.jaql964ope;
    
      ln_numero := ln_numero + 1;
      if ln_numero = 10000 then
        ln_numero := 0;
        commit;
      end if;
    
    ------------
    
    end loop;
    P_C_ESTADO := 'S';
    commit;
  
  end sp_cr_actualiza;
  ---------------------------------------------------------------------------------------------
  function fn_cr_credito_sorfy(vjaql964cta in number,
                               vjaql964ope in number,
                               vjaql964mda in number) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_abogado
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Abogado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    lc_bnj096sor varchar2(20);
  
  begin
    --credito sorfy
    begin
      select b.bnj096sor
        into lc_bnj096sor
        from bnj096 b
       where b.bnj096cta = vjaql964cta
         and b.bnj096ope = vjaql964ope
         and b.bnj096mda = vjaql964mda
         and b.bnj096cci is null;
    exception
      when no_data_found then
        lc_bnj096sor := ' ';
    end;
  
    return(lc_bnj096sor);
  
  end fn_cr_credito_sorfy;
  ---------------------------------------------------------------------------------------------

  function fn_cr_tipocredito(vjaql964mod in number,
                             vjaql964cta in number,
                             vjaql964ope in number,
                             vjaql964sob in number,
                             vjaql964top in number,
                             vjaql964suc in number,
                             vjaql964mda in number) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_tipocredito
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Tipo de Credito
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    lc_tipocredito varchar2(30);
  
  begin
    --tipo credito
    if vjaql964mod = 108 then
      lc_tipocredito := 'Prendar.';
    else
      begin
        select decode(x.SCSTAT,
                      64,
                      'Judicial',
                      33,
                      'Ref.Jud.',
                      34,
                      'Ref.PJM',
                      23,
                      'PJ Abo.',
                      25,
                      'PJ Dem.',
                      21,
                      'PJM',
                      22,
                      'PJ',
                      61,
                      'Refinan.',
                      'Normal')
          into lc_tipocredito
          from fsd011 x
         where x.Pgcod = 1
           and x.scmod = vjaql964mod
           and x.scmda = vjaql964mda
           and x.scpap = 0
           and x.sccta = vjaql964cta
           and x.scsuc = vjaql964suc
           and x.scoper = vjaql964ope
           and x.scsbop = vjaql964sob
           and x.sctope = vjaql964top
           and x.scstat not in (99, 90);
      exception
        when no_data_found then
          lc_tipocredito := null;
        when too_many_rows then
          lc_tipocredito := null;
      end;
    end if;
  
    return(lc_tipocredito);
  
  end fn_cr_tipocredito;
  ---------------------------------------------------------------------------------------------     

  ---------------------------------------------------------------------------------------------
  /*
  begin
    execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
    execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';
    execute immediate 'ALTER SESSION SET optimizer_mode=''FIRST_ROWS_10''';
    --PERSONAS
    OPEN c_fsd001;
    LOOP
      FETCH c_fsd001 BULK COLLECT
        INTO l_fsd001 LIMIT l_limit;
      EXIT WHEN l_fsd001.count = 0;
    
      FORALL i in l_fsd001.FIRST .. l_fsd001.LAST
        UPDATE FSD001 x
           SET Penom = (SELECT p2.Penom
                          FROM FSD001_temporal p1, FSD001_temporal p2
                         WHERE p1.pepais = x.pepais
                           and p1.petdoc = x.petdoc
                           and p1.pendoc = x.pendoc
                           and p2.seq1 = p1.seq2)
         where x.pepais = l_fsd001(i).pepais
           and x.petdoc = l_fsd001(i).petdoc
           and x.pendoc = l_fsd001(i).pendoc;
           
      COMMIT;
    END LOOP;
    CLOSE c_fsd001;
   
  
  
  */
  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza_analista_bulk(P_D_FECPRO in date,
                                          -- P_C_ESTADO out varchar2,
                                          P_N_INI in NUMBER,
                                          P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2014.01.03
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se modifico actualizacion lc_analista
    --                              2018.02.02 DCASTRO se agrego procedimiento sp_cr_dpto_prov para actualizar provincia, departamento
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in number, P_N_FIN in number) is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       jaql964csb,
       jaql964cor,
       jaql964pap,
       jaql964est
        from jaql964 j /* where j.jaql964cta=159078;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
    TYPE Tp_jaql964mod IS TABLE OF jaql964.jaql964mod%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cta IS TABLE OF jaql964.jaql964cta%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964ope IS TABLE OF jaql964.jaql964ope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964sob IS TABLE OF jaql964.jaql964sob%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964top IS TABLE OF jaql964.jaql964top%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964suc IS TABLE OF jaql964.jaql964suc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964mda IS TABLE OF jaql964.jaql964mda%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964usu IS TABLE OF jaql964.jaql964usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964doc IS TABLE OF jaql964.jaql964doc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964csb IS TABLE OF jaql964.jaql964csb%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cor IS TABLE OF jaql964.jaql964cor%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pap IS TABLE OF jaql964.jaql964pap%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964est IS TABLE OF jaql964.jaql964est%TYPE INDEX BY PLS_INTEGER;
  
    jaql964mod Tp_jaql964mod;
    jaql964cta Tp_jaql964cta;
    jaql964ope Tp_jaql964ope;
    jaql964sob Tp_jaql964sob;
    jaql964top Tp_jaql964top;
    jaql964suc Tp_jaql964suc;
    jaql964mda Tp_jaql964mda;
    jaql964usu Tp_jaql964usu;
    jaql964doc Tp_jaql964doc;
    jaql964csb Tp_jaql964csb;
    jaql964cor Tp_jaql964cor;
    jaql964pap Tp_jaql964pap;
    jaql964est Tp_jaql964est;
  
    --lc_tipocontable varchar2(20);
    lc_abogado  varchar2(50);
    lc_garantia varchar2(300);
    --ln_monto number:=0;
    lc_telefo   varchar2(20);
    lc_direc    varchar2(150);
    lc_distri   varchar2(50);
    lc_analista varchar2(30);
    -- ln_numero number:= 0;
    -- lc_tipcon varchar2(30);
    -- lc_bcgpo number(4);
    -- lc_produc varchar2(30);
    lc_tipocre   varchar2(30);
    lc_credito   varchar2(20);
    lc_refer     varchar2(200);
    ln_instancia number(10);
    ln_corr      number := 0;
    ln_sector    number := 0;
    ln_tipsbs    number := 0;
    ln_pgcod     number := 1;
  
    ln_papel number := 0;
    -- pf_asig date;
    -- pc_abrev varchar2(50);
    --  pf_deman date;
    --  pf_pasajud date;
    -- pf_trancart date;
  
    lc_telava fsr005.dotelfp%TYPE;
    ln_ctaava fsd011.sccta%TYPE;
    lc_nomava fsd001.penom%TYPE;
    lc_dirava varchar2(180);
  
    lc_provincia    varchar2(50);
    lc_departamento varchar2(50);
  begin
  
    OPEN cartera(P_N_INI, P_N_FIN);
    LOOP
      FETCH cartera BULK COLLECT
        INTO jaql964cta,
             jaql964mod,
             jaql964ope,
             jaql964sob,
             jaql964top,
             jaql964suc,
             jaql964mda,
             jaql964usu,
             jaql964doc,
             jaql964csb,
             jaql964cor,
             jaql964pap,
             jaql964est;
      IF jaql964cta.COUNT > 0 THEN
        FOR i IN jaql964cta.FIRST .. jaql964cta.LAST LOOP
        
          /*begin--analista
            lc_analista := pq_cr_jaql964_cartera.fn_cr_analista(jaql964mod(i),jaql964cta(i),
                                                 jaql964ope(i),jaql964sob(i),jaql964top(i),
                                                 jaql964suc(i),jaql964mda(i));
          end;*/
          begin
          
            pq_cr_jaql964_cartera.sp_cr_analista(jaql964mod(i),
                                                 jaql964cta(i),
                                                 jaql964ope(i),
                                                 jaql964sob(i),
                                                 jaql964top(i),
                                                 jaql964suc(i),
                                                 jaql964mda(i),
                                                 lc_analista,
                                                 ln_instancia);
          
          end;
        
          ln_tipsbs := jaql964csb(i);
          if ln_tipsbs = 13 then
            /*begin
            
            ln_sector :=  pq_cr_jaql964_cartera.fn_sector_credito(P_D_FECPRO,
                                                      1,jaql964mod(i),jaql964suc(i),
                                                      jaql964mda(i),0,jaql964cta(i),
                                                      jaql964ope(i),jaql964sob(i),
                                                      jaql964top(i),ln_instancia);
             end;*/
          
            begin
            
              ln_sector := fn_sector_credito(P_D_FECPRO,
                                             1,
                                             jaql964mod(i),
                                             jaql964suc(i),
                                             jaql964mda(i),
                                             0,
                                             jaql964cta(i),
                                             jaql964ope(i),
                                             jaql964sob(i),
                                             jaql964top(i));
            end;
          
          end if;
          begin
            --abogado
            lc_abogado := pq_cr_jaql964_cartera.fn_cr_abogado(ln_pgcod,
                                                              jaql964mda(i),
                                                              ln_papel,
                                                              jaql964cta(i),
                                                              jaql964ope(i),
                                                              jaql964mod(i),
                                                              jaql964suc(i),
                                                              jaql964sob(i),
                                                              jaql964top(i));
          end;
        
          /*    
          begin --garantia
           lc_garantia := pq_cr_jaql964_cartera.fn_cr_garantia(jaql964mod(i),jaql964cta(i),
                                                  jaql964ope(i),jaql964sob(i),jaql964top(i),
                                                  jaql964suc(i),jaql964mda(i));
          end;*/
        
          begin
            --direccion
          
            pq_cr_jaql964_cartera.sp_cr_direccion(jaql964cta(i),
                                                  jaql964doc(i),
                                                  lc_telefo,
                                                  lc_direc,
                                                  lc_distri,
                                                  lc_refer);
          end;
        
          /*begin --tipo contable
            pq_cr_jaql964_cartera.sp_cr_tipocontable(P_D_FECPRO,jaql964mod(i),jaql964cta(i),
                                                   jaql964ope(i),jaql964sob(i),jaql964top(i),
                                                   jaql964suc(i),jaql964mda(i),
                                                   lc_tipcon,
                                                   lc_bcgpo,
                                                   lc_produc);
          end;*/
        
          begin
            --tipo credito
          
            lc_tipocre := pq_cr_jaql964_cartera.fn_cr_tipocredito(jaql964mod(i),
                                                                  jaql964cta(i),
                                                                  jaql964ope(i),
                                                                  jaql964sob(i),
                                                                  jaql964top(i),
                                                                  jaql964suc(i),
                                                                  jaql964mda(i));
          end;
        
          begin
            --credito sorfy
            lc_credito := pq_cr_jaql964_cartera.fn_cr_credito_sorfy(jaql964cta(i),
                                                                    jaql964ope(i),
                                                                    jaql964mda(i));
          end;
        
          ---aval , direccion aval
          begin
            pq_cr_jaql964_cartera.sp_cr_aval(p_n_instancia => ln_instancia,
                                             P_N_CUENTA    => jaql964cta(i),
                                             P_N_OPERACION => jaql964ope(i),
                                             p_n_ctaava    => ln_ctaava,
                                             p_c_penom     => lc_nomava,
                                             p_c_telef     => lc_telava,
                                             p_c_direc     => lc_dirava);
          end;
        
          --provincia - dpto  2018.02.02
          begin
            pq_cr_jaql964_cartera.sp_cr_dpto_prov(vjaql964cta   => jaql964cta(i),
                                                  vjaql964doc   => jaql964doc(i),
                                                  vprovincia    => lc_provincia,
                                                  vdepartamento => lc_departamento);
          end;
          --
        
          update jaql964
             set jaql964usu   = trim(lc_analista),
                 jaql964tel   = lc_telefo,
                 jaql964dir   = lc_direc,
                 jaql964dis   = lc_distri,
                 jaql964tcc   = lc_tipocre,
                 jaql964cre   = lc_credito,
                 jaql964red   = lc_refer,
                 jaql964ins   = ln_instancia,
                 jaql964sec   = ln_sector,
                 jaql964ctav  = ln_ctaava,
                 jaql964noav  = lc_nomava,
                 jaql964teav  = lc_telava,
                 jaql964diav  = lc_dirava,
                 jaql964abo   = lc_abogado,
                 jaql964gar   = lc_garantia,
                 jaql964provi = lc_provincia,
                 jaql964dpto  = lc_departamento
          --jaql964tco=lc_tipcon
           where jaql964cor = jaql964cor(i);
          --and jaql964ope = jaql964ope(i);
          ln_sector := null;
          ln_corr   := ln_corr + 1;
          if ln_corr = 5000 then
            commit;
            ln_corr := 0;
          end if;
          --commit;
        
        END LOOP;
      END IF;
      EXIT WHEN cartera%NOTFOUND;
    END LOOP;
    COMMIT;
  
  end sp_cr_actualiza_analista_bulk;

  ---------------------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza_bulk(P_D_FECPRO in date,
                                 P_C_ESTADO out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor cartera is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       j.jaql964pap
        from jaql964 j /*where jaql964cta=150332 and jaql964ope=2109753*/
      ;
  
    TYPE Tp_jaql964mod IS TABLE OF jaql964.jaql964mod%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cta IS TABLE OF jaql964.jaql964cta%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964ope IS TABLE OF jaql964.jaql964ope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964sob IS TABLE OF jaql964.jaql964sob%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964top IS TABLE OF jaql964.jaql964top%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964suc IS TABLE OF jaql964.jaql964suc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964mda IS TABLE OF jaql964.jaql964mda%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964usu IS TABLE OF jaql964.jaql964usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964doc IS TABLE OF jaql964.jaql964doc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pap IS TABLE OF jaql964.jaql964pap%TYPE INDEX BY PLS_INTEGER;
  
    jaql964mod Tp_jaql964mod;
    jaql964cta Tp_jaql964cta;
    jaql964ope Tp_jaql964ope;
    jaql964sob Tp_jaql964sob;
    jaql964top Tp_jaql964top;
    jaql964suc Tp_jaql964suc;
    jaql964mda Tp_jaql964mda;
    jaql964usu Tp_jaql964usu;
    jaql964doc Tp_jaql964doc;
    jaql964pap Tp_jaql964pap;
  
    lc_tipocontable varchar2(20);
    lc_abogado      varchar2(50);
    lc_garantia     varchar2(300);
    ln_monto        number := 0;
    lc_telefo       varchar2(20);
    lc_direc        varchar2(150);
    lc_distri       varchar2(50);
    lc_analista     varchar2(30);
    ln_numero       number := 0;
    lc_tipcon       varchar2(30);
    lc_bcgpo        number(4);
    lc_produc       varchar2(30);
    lc_tipocre      varchar2(30);
    lc_credito      varchar2(20);
    lc_refer        varchar2(200);
    ln_corr         number := 0;
    ln_pgcod        number := 1;
  
  begin
  
    OPEN cartera;
    LOOP
      FETCH cartera BULK COLLECT
        INTO jaql964cta,
             jaql964mod,
             jaql964ope,
             jaql964sob,
             jaql964top,
             jaql964suc,
             jaql964mda,
             jaql964usu,
             jaql964doc,
             jaql964pap;
      IF jaql964cta.COUNT > 0 THEN
        FOR i IN jaql964cta.FIRST .. jaql964cta.LAST LOOP
        
          begin
            --analista
            lc_analista := pq_cr_jaql964_cartera.fn_cr_analista(jaql964mod(i),
                                                                jaql964cta(i),
                                                                jaql964ope(i),
                                                                jaql964sob(i),
                                                                jaql964top(i),
                                                                jaql964suc(i),
                                                                jaql964mda(i));
          end;
        
          begin
            --abogado
            lc_abogado := pq_cr_jaql964_cartera.fn_cr_abogado(ln_pgcod,
                                                              jaql964mda(i),
                                                              jaql964pap(i),
                                                              jaql964cta(i),
                                                              jaql964ope(i),
                                                              jaql964mod(i),
                                                              jaql964suc(i),
                                                              jaql964sob(i),
                                                              jaql964top(i));
          end;
        
          begin
            --garantia
            lc_garantia := pq_cr_jaql964_cartera.fn_cr_garantia(jaql964mod(i),
                                                                jaql964cta(i),
                                                                jaql964ope(i),
                                                                jaql964sob(i),
                                                                jaql964top(i),
                                                                jaql964suc(i),
                                                                jaql964mda(i));
          end;
        
          begin
            --direccion
          
            pq_cr_jaql964_cartera.sp_cr_direccion(jaql964cta(i),
                                                  jaql964doc(i),
                                                  lc_telefo,
                                                  lc_direc,
                                                  lc_distri,
                                                  lc_refer);
          end;
          /*
           begin --tipo contable
            pq_cr_jaql964_cartera.sp_cr_tipocontable(P_D_FECPRO,jaql964mod(i),jaql964cta(i),
                                                   jaql964ope(i),jaql964sob(i),jaql964top(i),
                                                   jaql964suc(i),jaql964mda(i),
                                                   lc_tipcon,
                                                   lc_bcgpo,
                                                   lc_produc);
          end;
           */
        
          begin
            --monto aprobado
            ln_monto := pq_cr_jaql964_cartera.fn_cr_monto(jaql964mod(i),
                                                          jaql964cta(i),
                                                          jaql964ope(i),
                                                          jaql964sob(i),
                                                          jaql964top(i),
                                                          jaql964suc(i),
                                                          jaql964mda(i));
          end;
        
          begin
            --tipo credito
          
            lc_tipocre := pq_cr_jaql964_cartera.fn_cr_tipocredito(jaql964mod(i),
                                                                  jaql964cta(i),
                                                                  jaql964ope(i),
                                                                  jaql964sob(i),
                                                                  jaql964top(i),
                                                                  jaql964suc(i),
                                                                  jaql964mda(i));
          end;
        
          begin
            --credito sorfy
            lc_credito := pq_cr_jaql964_cartera.fn_cr_credito_sorfy(jaql964cta(i),
                                                                    jaql964ope(i),
                                                                    jaql964mda(i));
          end;
        
          update jaql964
             set jaql964usu = lc_analista,
                 jaql964abo = lc_abogado,
                 jaql964gar = lc_garantia,
                 jaql964tel = lc_telefo,
                 jaql964dir = lc_direc,
                 jaql964dis = lc_distri,
                 jaql964tco = lc_tipcon,
                 jaql964csb = lc_bcgpo,
                 jaql964pro = lc_produc,
                 jaql964mta = ln_monto,
                 jaql964tcc = lc_tipocre,
                 jaql964cre = lc_credito,
                 jaql964red = lc_refer
           where jaql964cta = jaql964cta(i)
             and jaql964ope = jaql964ope(i);
        
          ln_corr := ln_corr + 1;
          if ln_corr = 5000 then
            commit;
            ln_corr := 0;
          end if;
        
        END LOOP;
      END IF;
      EXIT WHEN cartera%NOTFOUND;
    END LOOP;
    COMMIT;
  
  end sp_cr_actualiza_bulk;

  ---------------------------------------------------------------------------------------------
  /*function fn_sector_credito(
                               v_fecpro in date,
                               v_pgcod  in number,
                               v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               v_instancia in number
                             ) return number is
  
      ln_sector jaql101.jaql101scl%type;
      ln_instancia number(10);
      
  
  begin
  
    begin  
        select   JAQL101Scl
                 into ln_sector
        from
        (
              select   JAQL101Scl
                from   JAQL101
               where   JAQL101Pgc =  v_pgcod
                   and JAQL101Mod =  v_Scmod
                   and JAQL101Suc =  v_Scsuc
                   and JAQL101Mon =  v_Scmda
                   and JAQL101Pap =  v_Scpap
                   and JAQL101Cta =  v_Sccta
                   and JAQL101Ope =  v_Scoper
                   and JAQL101Sop =  v_Scsbop
                   and JAQL101Top =  v_Sctope
                   and JAQL101Fch <= v_fecpro
            order by JAQL101Fch desc, JAQL101COR desc
        ) where rownum = 1;
    exception
      when no_data_found then
          begin
  
             select trim(wv.WFAttSVal)
               into ln_sector
               from wfattsvalues wv
              where WFINSPRCID = v_instancia
                and WFAttSId   = 'SECTOR';
          exception     
            when others then
                 ln_sector := null;
          end;
     end;    
     
       
    return ln_sector;
  end;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_aval(P_N_INSTANCIA in number,
                       P_N_CUENTA    in number,
                       P_N_OPERACION in number,
                       P_N_CTAAVA    out number,
                       P_C_PENOM     out varchar2,
                       P_C_TELEF     out varchar2,
                       P_C_DIREC     out varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_monto
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Monto Aprobado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    lc_tonom varchar2(30);
    ln_cont  number := 0;
    lc_mod   varchar2(10);
    ln_monto number := 0;
  
    INSTANCIA number;
  
    lc_telefono fsr005.dotelfp%TYPE;
    ln_cuenta   fsd011.sccta%TYPE;
    ln_pepais   fsr008.pepais%TYPE;
    ln_petdoc   fsr008.petdoc%TYPE;
    ln_pendoc   fsr008.pendoc%TYPE;
    lc_penom    fsd001.penom%TYPE;
    lc_direc    varchar2(180);
  
    --R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope ,r1mda
  
  begin
  
    begin
      select s.sng003cta
        into ln_cuenta
        from sng003 s
       where s.sng001inst = P_N_INSTANCIA
         and rownum < 2;
    exception
      when no_data_found then
        ln_cuenta := null;
    end;
  
    begin
      select fs.penom, f8.pepais, f8.petdoc, f8.pendoc
        into lc_penom, ln_pepais, ln_petdoc, ln_pendoc
        from fsr008 f8, fsd001 fs
       where f8.pgcod = 1
         and f8.ctnro = ln_cuenta
         and fs.pepais = f8.pepais
         and fs.petdoc = f8.petdoc
         and fs.pendoc = f8.pendoc
         and f8.ttcod = 1
         and f8.cttfir = 'T';
    exception
      when no_data_found then
        lc_penom  := null;
        ln_pepais := null;
        ln_petdoc := null;
        ln_pendoc := null;
    end;
  
    ---2024.02.12 dcastro se agrego busqueda a funcion 
    begin
      lc_telefono := PQ_CR_jaql964_cartera.fn_cr_telefono_valido(P_N_PEPAIS => ln_pepais,
                                                                 P_N_PETDOC => ln_petdoc,
                                                                 P_N_PENDOC => ln_pendoc);
    end;
  
    if lc_telefono is null then
      ---2024.02.12 dcastro si variable telefono es nula realiza la bsuqeda tradicional
    
      begin
        select trim(dotelfp)
          into lc_telefono
          from fsr005 f
         where pepais = ln_pepais
           and petdoc = ln_petdoc
           and pendoc = ln_pendoc
           and rownum < 2;
      exception
        when NO_DATA_FOUND then
          lc_telefono := ' ';
      end;
    
    end if; --- ---2024.02.12 dcastro
  
    begin
      select trim(sngc13dir) || ' - ' || trim(f.fst071dsc)
        into lc_direc
        from sngc13 s, fst071 f
       where f.fst071pai = s.sngc13pais
         and f.fst071col = s.sngc13dist
         and s.sngc13pdoc = ln_pepais
         and s.sngc13tdoc = ln_petdoc
         and s.sngc13ndoc = ln_pendoc
         and s.docod = 1
         and s.sngc13est = 'H'
         and rownum < 2;
    exception
      when NO_DATA_FOUND then
        lc_direc := ' ';
    end;
  
    if ln_cuenta is null then
      begin
        select XWFPRCINS
          into INSTANCIA
          from xwf700 w
         where w.xwfcuenta = P_N_CUENTA
           and xwfoperacion = P_N_OPERACION
           and xwfcar3 = '1'
              -- and xwfmodulo = P_N_MODULO
           and xwfmodulo <> 200;
      exception
        when others then
          null;
      end;
      begin
        select s.sng003cta
          into ln_cuenta
          from sng003 s
         where s.sng001inst = INSTANCIA
           and rownum < 2;
      exception
        when no_data_found then
          ln_cuenta := null;
      end;
    
      begin
        select pepais, petdoc, pendoc
          into ln_pepais, ln_petdoc, ln_pendoc
          from fsr008
         where ctnro = ln_cuenta
           and ttcod = 1
           and cttfir = 'T';
      exception
        when others then
          null;
      end;
      begin
        select f.penom
          into lc_penom
          from fsd001 f
         where f.pepais = ln_pepais
           and f.petdoc = ln_petdoc
           and f.pendoc = ln_pendoc;
      exception
        when others then
          null;
      end;
    
      begin
        select trim(dotelfp)
          into lc_telefono
          from fsr005 f
         where pepais = ln_pepais
           and petdoc = ln_petdoc
           and pendoc = ln_pendoc
           and rownum < 2;
      exception
        when NO_DATA_FOUND then
          lc_telefono := ' ';
      end;
    
      begin
        select trim(sngc13dir) || ' - ' || trim(f.fst071dsc)
          into lc_direc
          from sngc13 s, fst071 f
         where f.fst071pai = s.sngc13pais
           and f.fst071col = s.sngc13dist
           and s.sngc13pdoc = ln_pepais
           and s.sngc13tdoc = ln_petdoc
           and s.sngc13ndoc = ln_pendoc
           and s.docod = 1
           and s.sngc13est = 'H'
           and rownum < 2;
      exception
        when NO_DATA_FOUND then
          lc_direc := ' ';
      end;
    
    end if;
  
    P_N_CTAAVA := ln_cuenta;
    P_C_PENOM  := lc_penom;
    P_C_TELEF  := lc_telefono;
    P_C_DIREC  := lc_direc;
  
  end sp_cr_aval;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*procedure sp_cr_aval971(P_N_CUENTA    in number,
                          P_N_OPERACION in number,
                          P_N_MODULO    in number,
                          ln_instancia in number,
                          ln_correlativo in number,
                          ln_cuentaaval out number,
                          lc_penomaval out varchar2,
                          ln_pepaisaval out number,
                          ln_petdocaval out number,
                          ln_pendocaval out character,
                          correlativo out number) is
  
  INSTANCIA number;
  
  begin 
  if P_N_MODULO <> 200 then
  
  cursor AVALES is
  
      select s.sng003cta, f.pendoc, f.petdoc, f.pepais, d.penom
   
        from sng003 s, fsr008 f, fsd001 d
       where s.sng001inst = ln_instancia
         and s.sng003cta = f.ctnro
         and f.cttfir = 'T'
         and f.pendoc = d.pendoc
         and f.pepais = d.pepais
         and f.petdoc = d.petdoc;
    
         begin 
             for i in AVALES loop
              pq_cr_jaql964_cartera.sp_cr_jaql971II();
              end loop;
         end;
      /*  begin 
        
        pq_cr_jaql964_cartera.sp_cr_jaql971II
        end;*/

  --  correlativo:= ln_correlativo;

  /*if ln_cuentaaval is null  and P_N_MODULO = 200 then
    begin
      select XWFPRCINS
        into INSTANCIA
        from xwf700 w
       where w.xwfcuenta = P_N_CUENTA
         and xwfoperacion = P_N_OPERACION
         and xwfcar3 = '1'
        -- and xwfmodulo = P_N_MODULO
         and xwfmodulo <> 200;
    exception
      when others then
        null;
    end;
    begin
          select s.sng003cta
            into ln_cuentaaval
            from sng003 s
          where s.sng001inst = INSTANCIA
            and rownum < 2;       
      exception when no_data_found then
          ln_cuentaaval := null;                    
      end;
  
    begin
      select pepais, petdoc, pendoc
        into ln_pepaisaval, ln_petdocaval, ln_pendocaval
        from fsr008
       where ctnro = ln_cuentaaval
         and ttcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    end;
    begin
      select f.penom
      into lc_penomaval
        from fsd001 f
       where f.pepais = ln_pepaisaval
         and f.petdoc = ln_petdocaval
         and f.pendoc = ln_pendocaval;
          exception when others then null;
      end;
      
   end if;
   end if;
  end sp_cr_aval971;*/

  ---------------------------------------------------------------------------------------------

  function fn_cr_telefono_aval(P_N_PEPAIS in number,
                               P_N_PETDOC in number,
                               P_N_PENDOC in char) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_telefono_aval
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          :
    -- Autor de Creaci¿n          : 
    -- Uso                        : Telefono aval
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    lc_telefonos varchar2(200);
  
    cursor tele is
      select trim(dotelfp) telefo
        from fsr005 f
       where pepais = P_N_PEPAIS
         and petdoc = P_N_PETDOC
         and pendoc = P_N_PENDOC;
  
  begin
  
    begin
    
      for t in tele loop
        lc_telefonos := lc_telefonos || ' / ' || t.telefo;
      end loop;
    
    exception
      when NO_DATA_FOUND then
        lc_telefonos := ' ';
    end;
  
    return(lc_telefonos);
  
  end fn_cr_telefono_aval;
  ---------------------------------------------------------------------------------------------     
  procedure sp_cr_direccion_aval(P_N_PEPAIS in number,
                                 P_N_PETDOC in number,
                                 P_N_PENDOC in char,
                                 P_C_direc  out varchar2,
                                 P_C_distr  out varchar2,
                                 P_C_refer1 out varchar2,
                                 P_C_ubigeo out char) is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_direccion_aval
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          :
    -- Autor de Creaci¿n          : 
    -- Uso                        : direccion aval
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2018.01.29
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se agrego campo y variable para ubigeo p_c_ubigeo
    --
    -- ***************************************************************** 
    lc_codmsg varchar2(100);
    lc_desmsg varchar2(1000);
  
  begin
  
    begin
      select trim(sngc13dir),
             trim(f.fst071dsc),
             sngc13ref1,
             trim(s.sngc13ugeo)
        into P_C_direc, P_C_distr, P_C_refer1, P_C_ubigeo
        from sngc13 s, fst071 f
       where f.fst071pai = s.sngc13pais
         and f.fst071col = s.sngc13dist
         and s.sngc13pdoc = P_N_PEPAIS --604
         and s.sngc13tdoc = P_N_PETDOC --21
         and s.sngc13ndoc = P_N_PENDOC -- 01305666
         and s.docod = 1
         and s.sngc13est = 'H'
         and rownum < 2;
    
    exception
      when others then
        P_C_direc  := ' ';
        P_C_distr  := ' ';
        P_C_refer1 := ' ';
        P_C_ubigeo := ' ';
        lc_codmsg  := sqlcode;
        lc_desmsg  := sqlerrm;
      
    end;
  
  end sp_cr_direccion_aval;
  ---------------------------------------------------------------------------------------------   
  procedure sp_cr_carga_aval(P_N_INI in NUMBER, P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_monto
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Monto Aprobado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in number, P_N_FIN in number) is
      select j.jaql964cor,
             j.jaql964ins,
             J.JAQL964SUC,
             j.jaql964cta,
             j.jaql964mod,
             j.jaql964mda,
             j.jaql964ope,
             j.jaql964sob,
             j.jaql964top,
             j.jaql964est,
             j.jaql964pai,
             j.jaql964tid,
             j.jaql964doc,
             j.jaql964fec
        from jaql964 j
      /* where j.jaql964cta=1545995  
      and j.jaql964ope=1268321;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
    /*cursor aval(ln_instancia in number) is
    select s.sng003cta , f.pendoc, f.petdoc, f.pepais,d.penom
             from sng003 s, fsr008 f, fsd001 d
              where s.sng001inst = ln_instancia and s.sng003cta=f.ctnro
              and f.cttfir ='T' and f.pendoc=d.pendoc and f.pepais=d.pepais and f.petdoc=d.petdoc;*/
  
    lc_tonom varchar2(30);
    ln_cont  number := 0;
    lc_mod   varchar2(10);
    --ln_monto           number := 0;
    lc_telefonos       varchar2(200);
    lc_direccion       varchar2(150);
    lc_referencia      varchar2(200);
    lc_distrito        varchar2(50);
    lc_direcneg        varchar2(150);
    lc_fcancelacion    varchar2(10);
    ln_maprobado       number;
    ln_provision       number;
    ln_calificacion    number;
    lc_frefinanciado   varchar2(10);
    lc_fcastigo        varchar2(10);
    lc_fdemanda        varchar2(10);
    ln_icextracontable number;
  
    ln_pgcod number := 1;
  
    ln_papel number := 0;
  
    lc_ftransferencia  varchar2(10);
    ln_descalificacion varchar2(15);
    lc_finterposicion  varchar2(10);
    lc_faceptacion     varchar2(10);
    lc_acuerdopago     varchar2(2);
    lc_descripacuerdo  varchar2(100);
    ln_JAQL165EMP      number := 1;
    lc_firecuplegal    varchar(10);
    lc_cancespecial    varchar(200);
    lc_nroexpediente   varchar(20);
    lc_firlegal        varchar(10);
    lc_faabo           varchar(10);
    lc_fejud           varchar(10);
    lc_fdes            varchar(10);
    lc_abogado         varchar2(100);
    lc_sobreendeudado  varchar2(50);
    ln_plazo           number(5); -- 2016.10.07 @mpca
  
    lc_telefono fsr005.dotelfp%TYPE;
    ln_cuenta   fsd011.sccta%TYPE;
    ln_pepais   fsr008.pepais%TYPE;
    ln_petdoc   fsr008.petdoc%TYPE;
    ln_pendoc   fsr008.pendoc%TYPE;
    lc_penom    fsd001.penom%TYPE;
  
    lc_direc    varchar2(180);
    ln_contador number;
    ln_num      number := 1;
    ln_tipcre   number;
    ln_ciiu     number;
    ld_FchProc  date;
  
  begin
  
    for i in cartera(P_N_INI, P_N_FIN) loop
      PQ_CR_jaql964_cartera.sp_cr_fecha_cancelacion(P_N_PGCOD  => ln_pgcod,
                                                    P_N_AOMOD  => i.jaql964mod,
                                                    P_N_AOSUC  => i.jaql964suc,
                                                    P_N_AOMDA  => i.jaql964mda,
                                                    P_N_AOPAP  => ln_papel,
                                                    P_N_AOCTA  => i.jaql964cta,
                                                    P_N_AOOPER => i.jaql964ope,
                                                    P_N_AOSBOP => i.jaql964sob,
                                                    P_N_AOTOPE => i.jaql964top,
                                                    P_N_FCAN   => lc_fcancelacion);
    
      PQ_CR_jaql964_cartera.sp_cr_provcali(P_N_RI105COD   => ln_pgcod,
                                           P_N_RI105SUC   => i.jaql964suc,
                                           P_N_RI105MOD   => i.jaql964mod,
                                           P_N_RI105MDA   => i.jaql964mda,
                                           P_N_RI105PAP   => ln_papel,
                                           P_N_RI105CTA   => i.jaql964cta,
                                           P_N_RI105OPER  => i.jaql964ope,
                                           P_N_RI105SBOP  => i.jaql964sob,
                                           P_N_RI105TOPE  => i.jaql964top,
                                           P_N_JAQL964EST => i.jaql964est,
                                           P_N_PROV       => ln_provision,
                                           P_N_CALF       => ln_calificacion,
                                           P_N_DCALF      => ln_descalificacion);
    
      PQ_CR_jaql964_cartera.sp_cr_fidemanda(P_N_JAQM27PGC  => ln_pgcod,
                                            P_N_JAQM27MOD  => i.jaql964mod,
                                            P_N_JAQM27SUC  => i.jaql964suc,
                                            P_N_JAQM27MDA  => i.jaql964mda,
                                            P_N_JAQM27PAP  => ln_papel,
                                            P_N_JAQM27CTA  => i.jaql964cta,
                                            P_N_JAQM27OPER => i.jaql964ope,
                                            P_N_JAQM27SBOP => i.jaql964sob,
                                            P_N_JAQM27TOPE => i.jaql964top,
                                            P_N_JAQM33COR  => i.jaql964cor,
                                            P_N_JAQM33FDEM => lc_fdemanda);
    
      PQ_CR_jaql964_cartera.sp_cr_refinanciado(P_N_JAQL166PGCOD => ln_pgcod,
                                               P_N_JAQL166SCMOD => i.jaql964mod,
                                               P_N_JAQL166SCSUC => i.jaql964suc,
                                               P_N_JAQL166SCMDA => i.jaql964mda,
                                               P_N_JAQL166SCPAP => ln_papel,
                                               P_N_JAQL166SCCTA => i.jaql964cta,
                                               P_N_JAQL166SCOPE => i.jaql964ope,
                                               P_N_JAQL166SCSBO => i.jaql964sob,
                                               P_N_JAQL166SCTOP => i.jaql964top,
                                               P_N_JAQL166EST   => i.jaql964est,
                                               P_N_JAQL166SCFVL => lc_frefinanciado);
    
      PQ_CR_jaql964_cartera.sp_cr_interes_compextra(P_N_PGCOD  => ln_pgcod,
                                                    P_N_SCSUC  => i.jaql964suc,
                                                    P_N_SCMDA  => i.jaql964mda,
                                                    P_N_SCPAP  => ln_papel,
                                                    P_N_SCCTA  => i.jaql964cta,
                                                    P_N_SCOPER => i.jaql964ope,
                                                    P_N_SCSBOP => i.jaql964sob,
                                                    P_N_SCTOPE => i.jaql964top,
                                                    P_N_SCSDO  => ln_icextracontable);
    
      PQ_CR_jaql964_cartera.sp_cr_castigado(P_N_JAQL166PGCOD => ln_pgcod,
                                            P_N_JAQL166SCMOD => i.jaql964mod,
                                            P_N_JAQL166SCSUC => i.jaql964suc,
                                            P_N_JAQL166SCMDA => i.jaql964mda,
                                            P_N_JAQL166SCPAP => ln_papel,
                                            P_N_JAQL166SCCTA => i.jaql964cta,
                                            P_N_JAQL166SCOPE => i.jaql964ope,
                                            P_N_JAQL166SCSBO => i.jaql964sob,
                                            P_N_JAQL166SCTOP => i.jaql964top,
                                            P_N_JAQL166EST   => i.jaql964est,
                                            P_N_JAQL166CAST  => lc_fcastigo);
    
      PQ_CR_jaql964_cartera.sp_cr_ftransabogado(P_N_SNG419PGC  => ln_pgcod,
                                                P_N_SNG419MOD  => i.jaql964mod,
                                                P_N_SNG419SUC  => i.jaql964suc,
                                                P_N_SNG419MDA  => i.jaql964mda,
                                                P_N_SNG419PAP  => ln_papel,
                                                P_N_SNG419CTA  => i.jaql964cta,
                                                P_N_SNG419OPE  => i.jaql964ope,
                                                P_N_SNG419SBO  => i.jaql964sob,
                                                P_N_SNG419TOP  => i.jaql964top,
                                                P_N_SNG419FECT => lc_ftransferencia);
    
      PQ_CR_jaql964_cartera.sp_cr_finterposicion(P_N_JAQM27PGC  => ln_pgcod,
                                                 P_N_JAQM27MOD  => i.jaql964mod,
                                                 P_N_JAQM27SUC  => i.jaql964suc,
                                                 P_N_JAQM27MDA  => i.jaql964mda,
                                                 P_N_JAQM27PAP  => ln_papel,
                                                 P_N_JAQM27CTA  => i.jaql964cta,
                                                 P_N_JAQM27OPER => i.jaql964ope,
                                                 P_N_JAQM27SBOP => i.jaql964sob,
                                                 P_N_JAQM27TOPE => i.jaql964top,
                                                 P_N_JAQM33COR  => i.jaql964cor,
                                                 P_N_JAQM33FINT => lc_finterposicion,
                                                 P_N_NROEXP     => lc_nroexpediente);
    
      PQ_CR_jaql964_cartera.sp_cr_faceptacion(P_N_JAQM27PGC  => ln_pgcod,
                                              P_N_JAQM27MOD  => i.jaql964mod,
                                              P_N_JAQM27SUC  => i.jaql964suc,
                                              P_N_JAQM27MDA  => i.jaql964mda,
                                              P_N_JAQM27PAP  => ln_papel,
                                              P_N_JAQM27CTA  => i.jaql964cta,
                                              P_N_JAQM27OPER => i.jaql964ope,
                                              P_N_JAQM27SBOP => i.jaql964sob,
                                              P_N_JAQM27TOPE => i.jaql964top,
                                              P_N_JAQM33COR  => i.jaql964cor,
                                              P_N_JAQM33FACT => lc_faceptacion);
    
      PQ_CR_jaql964_cartera.sp_cr_acuerdo_pago( /*P_N_JAQL165CORR => i.jaql964cor,*/P_N_JAQL165EMP  => ln_JAQL165EMP,
                                               P_N_JAQL165SUC  => i.jaql964suc,
                                               P_N_JAQL165MDA  => i.jaql964mda,
                                               P_N_JAQL165PAP  => ln_papel,
                                               P_N_JAQL165CTA  => i.jaql964cta,
                                               P_N_JAQL165OPE  => i.jaql964ope,
                                               P_N_JAQL165SBO  => i.jaql964sob,
                                               P_N_JAQL165TOP  => i.jaql964top,
                                               P_N_JAQL165MOD  => i.jaql964mod,
                                               P_N_JAQL165COM  => lc_acuerdopago,
                                               P_N_JAQL165DCOM => lc_descripacuerdo);
    
      PQ_CR_jaql964_cartera.sp_cr_cancelacion_esp(P_N_JAQL165EMP => ln_JAQL165EMP,
                                                  P_N_JAQL165SUC => i.jaql964suc,
                                                  P_N_JAQL165MDA => i.jaql964mda,
                                                  P_N_JAQL165PAP => ln_papel,
                                                  P_N_JAQL165CTA => i.jaql964cta,
                                                  P_N_JAQL165OPE => i.jaql964ope,
                                                  P_N_JAQL165SBO => i.jaql964sob,
                                                  P_N_JAQL165TOP => i.jaql964top,
                                                  P_N_JAQL165MOD => i.jaql964mod,
                                                  P_N_JAQL165TEX => lc_cancespecial);
    
      PQ_CR_jaql964_cartera.UpdateCampos_JAQL964(P_N_INSTANCIA    => i.jaql964ins,
                                                 P_N_MONEDA       => i.jaql964mda,
                                                 P_N_CUENTA       => i.jaql964cta,
                                                 P_N_OPERACION    => i.jaql964ope,
                                                 P_N_SUCURSAL     => i.jaql964suc,
                                                 P_N_SUBOPER      => i.jaql964sob,
                                                 P_N_TIPOPER      => i.jaql964top,
                                                 P_N_MODULO       => i.jaql964mod,
                                                 P_N_ESTADO       => i.JAQL964EST,
                                                 P_N_JAQL964FIRL  => lc_firlegal,
                                                 P_N_JAQL964FAABO => lc_faabo,
                                                 P_N_JAQL964FEJUD => lc_fejud,
                                                 P_N_JAQL964FDES  => lc_fdes,
                                                 P_N_MONT_APROB   => ln_maprobado,
                                                 P_C_ABOGADO      => lc_abogado, --2015.07.31
                                                 P_N_PLAZO        => ln_plazo --2016.10.07 @mpca
                                                 );
      pq_cr_jaql964_cartera.sp_cr_sobreendeudado(i.jaql964fec,
                                                 ln_pepais    => i.jaql964pai,
                                                 ln_petdoc    => i.jaql964tid,
                                                 ln_pendoc    => i.jaql964doc,
                                                 lc_fgsob     => lc_sobreendeudado);
    
      ln_tipcre := Pq_Cr_Jaql964_Cartera.fn_tipo_credito_desem(P_N_JAQL964PAI => i.jaql964pai,
                                                               P_N_JAQL964TID => i.jaql964tid,
                                                               P_N_JAQL964DOC => i.jaql964doc,
                                                               P_D_JAQL964FEC => to_date(lc_fdes,
                                                                                         'yyyy.mm.dd'),
                                                               P_N_JAQL964CTA => i.jaql964cta);
    
      -- MPOSTIGOC 21/10/2024 PRY7090                                                          
      PQ_CR_MODULO_CAMPANIAS.sp_cr_ciuu(ln_pais => i.jaql964pai,
                                        ln_tdoc => i.jaql964tid,
                                        lc_ndoc => i.jaql964doc,
                                        ln_ciiu => ln_ciiu);
    
      ------------------
      PQ_CR_jaql964_cartera.sp_cr_updatejaql964(P_N_CUENTA         => i.jaql964cta,
                                                P_N_OPERACION      => i.jaql964ope,
                                                P_N_SUBOPER        => i.jaql964sob,
                                                P_N_CORRELATIVO    => i.jaql964cor,
                                                P_N_ESTADO         => i.jaql964est,
                                                P_N_FCAN           => lc_fcancelacion,
                                                P_N_MAPRO          => ln_maprobado,
                                                P_N_PROV           => ln_provision,
                                                P_N_CALF           => ln_calificacion,
                                                P_N_DCALF          => ln_descalificacion,
                                                P_N_JAQM33FDEM     => lc_fdemanda,
                                                P_N_JAQL166SCFVL   => lc_frefinanciado,
                                                P_N_SCSDO          => ln_icextracontable,
                                                P_N_JAQL166CAST    => lc_fcastigo,
                                                P_N_SNG419FECT     => lc_ftransferencia,
                                                P_N_PGCOD          => ln_pgcod,
                                                P_N_PAP            => ln_papel,
                                                P_N_JAQM33FINT     => lc_finterposicion,
                                                P_N_JAQM33FACT     => lc_faceptacion,
                                                P_N_JAQL165COM     => lc_acuerdopago,
                                                P_N_JAQL165DCOM    => lc_descripacuerdo,
                                                P_N_JAQL165TEX     => lc_cancespecial,
                                                P_N_NROEXP         => lc_nroexpediente,
                                                P_N_JAQL964FIRL    => lc_firlegal,
                                                P_N_JAQL964FAABO   => lc_faabo,
                                                P_N_JAQL964FEJUD   => lc_fejud,
                                                P_N_JAQL964FDES    => lc_fdes,
                                                P_N_TIPCRED        => ln_tipcre,
                                                P_C_ABOGADO        => lc_abogado,
                                                P_C_SOBREENDEUDADO => lc_sobreendeudado,
                                                P_N_PLAZO          => ln_plazo,
                                                ln_ciiu            => ln_ciiu);
    
      ln_cont := 0;
      --commit;
    end loop;
  
    -- MPOSTIGOC
    begin
      begin
        select max(j.jaql964fec) into ld_FchProc from jaql964 j;
      exception
        when others then
          null;
      end;
    
      Pq_Cr_Jaql964_Cartera.sp_Cr_UpdAQPB183(ld_fecha => ld_FchProc);
    
    end;
  
    begin
      -- Call the procedure
      PQ_CR_jaql964_cartera.sp_Cr_CargaReconver;
    end;
  
  end sp_cr_carga_aval;
  ---------------------------------------------------------------------------------
  procedure sp_cr_inserta_aval(P_N_CORR964 NUMBER,
                               P_N_CTAAVA  in number,
                               P_C_PENOM   in varchar2,
                               P_N_PETDOC  in number,
                               P_N_PENDOC  in varchar2,
                               P_C_DIREC   in varchar2,
                               P_C_refer1  in varchar2,
                               P_C_distr   in varchar2,
                               P_C_TELEF   in varchar2,
                               P_C_DIRNEG  in varchar2,
                               P_N_PEPAIS  in number,
                               P_C_ubigeo  in char,
                               P_C_DPTO    in varchar2,
                               P_C_PROV    in varchar2) iS
    -- 2018.01.29 DCASTRO: Se agrego variable para almacenar ubigeo.
    lc_codmsg varchar2(100);
    lc_desmsg varchar2(1000);
  BEGIN
    INSERT INTO JAQL971
      (JAQL964COR,
       JAQL971COR,
       JAQL971CTA1,
       JAQL971NOM1,
       JAQL971TDOC1,
       JAQL971DOC1,
       JAQL971DIR1,
       JAQL971RED1,
       JAQL971DIS1,
       JAQL971TEL1,
       JAQL971NEG1,
       JAQL971PEPAIS1,
       JAQL971UGEO1,
       JAQL971DPTO1,
       JAQL971PROV1)
    VALUES
      (P_N_CORR964,
       1,
       P_N_CTAAVA,
       P_C_PENOM,
       P_N_PETDOC,
       P_N_PENDOC,
       P_C_DIREC,
       P_C_refer1,
       P_C_distr,
       P_C_TELEF,
       P_C_DIRNEG,
       P_N_PEPAIS,
       P_C_ubigeo,
       P_C_DPTO,
       P_C_PROV);
  exception
    when others then
      lc_codmsg := sqlcode;
      lc_desmsg := sqlerrm;
  end sp_cr_inserta_aval;
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_direccion_negocio(P_N_PEPAIS in number,
                                    P_N_PETDOC in number,
                                    P_N_PENDOC in char,
                                    P_C_DIRNEG out varchar2,
                                    P_C_distr  out varchar2,
                                    P_C_refer1 out varchar2) is
  
  begin
  
    begin
      select trim(sngc13dir), trim(f.fst071dsc), sngc13ref1
        into P_C_DIRNEG, P_C_distr, P_C_refer1
        from sngc13 s, fst071 f
       where f.fst071pai = s.sngc13pais
         and f.fst071col = s.sngc13dist
         and s.sngc13pdoc = P_N_PEPAIS --604
         and s.sngc13tdoc = P_N_PETDOC --21
         and s.sngc13ndoc = P_N_PENDOC -- 01305666
         and s.docod = 3
         and s.sngc13est = 'H'
         and rownum < 2;
    
    exception
      when NO_DATA_FOUND then
        P_C_DIRNEG := ' ';
        P_C_distr  := ' ';
        P_C_refer1 := ' ';
      
    end;
  
  end sp_cr_direccion_negocio;
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_update_aval(P_N_CORR964  number,
                              P_N_CTAAVA   in number,
                              P_C_PENOM    in varchar2,
                              P_N_PETDOC   in number,
                              P_N_PENDOC   in varchar2,
                              P_C_DIREC    in varchar2,
                              P_C_refer1   in varchar2,
                              P_C_distr    in varchar2,
                              P_C_TELEF    in varchar2,
                              P_C_DIRNEG   in varchar2,
                              P_N_PEPAIS   in number,
                              P_N_POSICION number,
                              P_C_ubigeo   in char,
                              P_C_DPTO     in varchar2,
                              P_C_PROV     in varchar2) iS
    --2018.01.29 DCASTRO : Se agrego variable P_C_UBIGEO                              
  BEGIN
  
    IF P_N_POSICION = 2 then
    
      UPDATE JAQL971
         set JAQL971CTA2    = P_N_CTAAVA,
             JAQL971NOM2    = P_C_PENOM,
             JAQL971TDOC2   = P_N_PETDOC,
             JAQL971DOC2    = P_N_PENDOC,
             JAQL971DIR2    = P_C_DIREC,
             JAQL971RED2    = P_C_refer1,
             JAQL971DIS2    = P_C_distr,
             JAQL971TEL2    = P_C_TELEF,
             JAQL971NEG2    = P_C_DIRNEG,
             JAQL971PEPAIS2 = P_N_PEPAIS,
             JAQL971ugeo2   = P_C_ubigeo,
             JAQL971DPTO2   = P_C_DPTO,
             JAQL971PROV2   = P_C_PROV
       where JAQL964COR = P_N_CORR964
         and JAQL971COR = 1;
    
    elsif P_N_POSICION = 3 then
    
      UPDATE JAQL971
         set JAQL971CTA3    = P_N_CTAAVA,
             JAQL971NOM3    = P_C_PENOM,
             JAQL971TDOC3   = P_N_PETDOC,
             JAQL971DOC3    = P_N_PENDOC,
             JAQL971DIR3    = P_C_DIREC,
             JAQL971RED3    = P_C_refer1,
             JAQL971DIS3    = P_C_distr,
             JAQL971TEL3    = P_C_TELEF,
             JAQL971NEG3    = P_C_DIRNEG,
             JAQL971PEPAIS3 = P_N_PEPAIS,
             JAQL971ugeo3   = P_C_ubigeo,
             JAQL971DPTO3   = P_C_DPTO,
             JAQL971PROV3   = P_C_PROV
       where JAQL964COR = P_N_CORR964
         and JAQL971COR = 1;
    
    elsif P_N_POSICION = 4 then
    
      UPDATE JAQL971
         set JAQL971CTA4    = P_N_CTAAVA,
             JAQL971NOM4    = P_C_PENOM,
             JAQL971TDOC4   = P_N_PETDOC,
             JAQL971DOC4    = P_N_PENDOC,
             JAQL971DIR4    = P_C_DIREC,
             JAQL971RED4    = P_C_refer1,
             JAQL971DIS4    = P_C_distr,
             JAQL971TEL4    = P_C_TELEF,
             JAQL971NEG4    = P_C_DIRNEG,
             JAQL971PEPAIS4 = P_N_PEPAIS,
             JAQL971ugeo4   = P_C_ubigeo,
             JAQL971DPTO4   = P_C_DPTO,
             JAQL971PROV4   = P_C_PROV
       where JAQL964COR = P_N_CORR964
         and JAQL971COR = 1;
    
    elsif P_N_POSICION = 5 then
    
      UPDATE JAQL971
         set JAQL971CTA5    = P_N_CTAAVA,
             JAQL971NOM5    = P_C_PENOM,
             JAQL971TDOC5   = P_N_PETDOC,
             JAQL971DOC5    = P_N_PENDOC,
             JAQL971DIR5    = P_C_DIREC,
             JAQL971RED5    = P_C_refer1,
             JAQL971DIS5    = P_C_distr,
             JAQL971TEL5    = P_C_TELEF,
             JAQL971NEG5    = P_C_DIRNEG,
             JAQL971PEPAIS5 = P_N_PEPAIS,
             JAQL971ugeo5   = P_C_ubigeo,
             JAQL971DPTO5   = P_C_DPTO,
             JAQL971PROV5   = P_C_PROV
       where JAQL964COR = P_N_CORR964
         and JAQL971COR = 1;
    
    elsif P_N_POSICION = 6 then
    
      UPDATE JAQL971
         set JAQL971CTA6    = P_N_CTAAVA,
             JAQL971NOM6    = P_C_PENOM,
             JAQL971TDOC6   = P_N_PETDOC,
             JAQL971DOC6    = P_N_PENDOC,
             JAQL971DIR6    = P_C_DIREC,
             JAQL971RED6    = P_C_refer1,
             JAQL971DIS6    = P_C_distr,
             JAQL971TEL6    = P_C_TELEF,
             JAQL971NEG6    = P_C_DIRNEG,
             JAQL971PEPAIS6 = P_N_PEPAIS,
             JAQL971ugeo6   = P_C_ubigeo,
             JAQL971DPTO6   = P_C_DPTO,
             JAQL971PROV6   = P_C_PROV
       where JAQL964COR = P_N_CORR964
         and JAQL971COR = 1;
    end if;
  
  end sp_cr_update_aval;

  ---------------------------------------------------------------------------------------------

  procedure sp_cr_fecha_cancelacion(P_N_PGCOD  in number,
                                    P_N_AOMOD  in number,
                                    P_N_AOSUC  in number,
                                    P_N_AOMDA  in number,
                                    P_N_AOPAP  in number,
                                    P_N_AOCTA  in number,
                                    P_N_AOOPER in number,
                                    P_N_AOSBOP in number,
                                    P_N_AOTOPE in number,
                                    P_N_FCAN   out varchar2
                                    
                                    ) is
    ld_fecha date;
  begin
    --fecha de cancelacion
  
    begin
      select b.aofe99
        into ld_fecha
        from FSD010 b
       where b.pgcod = P_N_PGCOD
         and b.aomod = P_N_AOMOD
         and b.aosuc = P_N_AOSUC
         and b.aomda = P_N_AOMDA
         and b.aopap = P_N_AOPAP
         and b.aocta = P_N_AOCTA
         and b.aooper = P_N_AOOPER
         and b.aosbop = P_N_AOSBOP
         and b.aotope = P_N_AOTOPE
         and b.aostat = 99;
    
    exception
      when others then
        NULL;
    end;
    P_N_FCAN := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_fecha_cancelacion;
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_monto_aprobado(
                                 -- P_N_AOMOD in number, 
                                 P_N_PGCOD  in number,
                                 P_N_AOSUC  in number,
                                 P_N_AOMDA  in number,
                                 P_N_AOPAP  in number,
                                 P_N_AOCTA  in number,
                                 P_N_AOOPER in number,
                                 -- P_N_AOSBOP in number, 
                                 -- P_N_AOTOPE in number,
                                 P_N_MAPRO out number) is
  begin
    begin
      select x.xllcapital
        into P_N_MAPRO
        from X054023 x
       Where x.xllpgcod = P_N_PGCOD -- x.XllAomod = P_N_AOMOD
         and x.XllAosuc = P_N_AOSUC
         and x.XllAomda = P_N_AOMDA
         and x.XllAopap = P_N_AOPAP
         and x.XllAocta = P_N_AOCTA
         and x.XllAooper = P_N_AOOPER
         and x.xllaosbop in (select min(y.xllaosbop)
                               from X054023 y
                              where y.xllpgcod = x.xllpgcod -- x.XllAomod = P_N_AOMOD
                                and y.XllAosuc = x.XllAosuc
                                and y.XllAomda = x.XllAomda
                                and y.XllAopap = x.XllAopap
                                and y.XllAocta = x.XllAocta
                                and y.XllAooper = x.XllAooper
                                and y.xllaotop <> 550);
    exception
      when others then
        NULL;
    end;
  end sp_cr_monto_aprobado;
  ---------------------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------------------
  procedure sp_cr_provcali(P_N_RI105COD   in number,
                           P_N_RI105SUC   in number,
                           P_N_RI105MOD   in number,
                           P_N_RI105MDA   in number,
                           P_N_RI105PAP   in number,
                           P_N_RI105CTA   in number,
                           P_N_RI105OPER  in number,
                           P_N_RI105SBOP  in number,
                           P_N_RI105TOPE  in number,
                           P_N_JAQL964EST in number,
                           P_N_PROV       out number,
                           P_N_CALF       out number,
                           P_N_DCALF      out varchar2
                           
                           ) is
  begin
  
    if P_N_JAQL964EST in (23, 25) then
      begin
      
        select f.ri105coef * 100, f.ri105cat
          into P_N_PROV, P_N_CALF
          from fri105 f
         Where f.ri105cod = P_N_RI105COD
           and f.ri105suc = P_N_RI105SUC
           and f.ri105mod = P_N_RI105MOD
           and f.ri105mda = P_N_RI105MDA
           and f.ri105pap = P_N_RI105PAP
           and f.ri105cta = P_N_RI105CTA
           and f.ri105oper = P_N_RI105OPER;
      exception
        when no_data_found then
          null;
        when others then
          NULL;
      end;
    else
      begin
      
        select f.ri105coef * 100, f.ri105cat
          into P_N_PROV, P_N_CALF
          from fri105 f
         Where f.ri105cod = P_N_RI105COD
           and f.ri105suc = P_N_RI105SUC
              -- and f.ri105mod = P_N_RI105MOD
           and f.ri105mda = P_N_RI105MDA
           and f.ri105pap = P_N_RI105PAP
           and f.ri105cta = P_N_RI105CTA
           and f.ri105oper = P_N_RI105OPER;
        --and f.ri105sbop = P_N_RI105SBOP
        --and f.ri105tope = P_N_RI105TOPE;
      exception
        when no_data_found then
          null;
        when others then
          NULL;
      end;
    end if;
  
    if P_N_CALF = 1 then
      P_N_DCALF := 'Normal';
    elsif P_N_CALF = 2 then
      P_N_DCALF := 'C.P.P';
    elsif P_N_CALF = 3 then
      P_N_DCALF := 'Deficiente';
    elsif P_N_CALF = 4 then
      P_N_DCALF := 'Dudoso';
    elsif P_N_CALF = 5 then
      P_N_DCALF := 'Perdida';
    end if;
  end sp_cr_provcali;
  ---------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------  
  /*procedure sp_cr_otrosrubros (\*otros rubros*\
                              P_N_PGCOD in number, -- fsd011
                              P_N_SCSUC in number, 
                              P_N_SCRUB in number, 
                              P_N_SCMDA in number, 
                              P_N_SCPAP in number, 
                              P_N_SCCTA in number, 
                              P_N_SCOPER in number, 
                              P_N_SCSBOP in number, 
                              P_N_SCTOPE in number,
                              P_N_ORUB out number
       )is
        begin
           begin 
             select f.scsdo into P_N_ORUB from fsd011 f
             Where f.pgcod = P_N_PGCOD
             and f.scsuc = P_N_SCSUC
             and f.scrub = 5212020000001
             and f.scmda = P_N_SCMDA
             and f.scpap = P_N_SCPAP
             and f.sccta = P_N_SCCTA
             and f.scoper = P_N_SCOPER
             and f.scsbop = P_N_SCSBOP
             and f.sctope = P_N_SCTOPE;
           end;   
   
  end sp_cr_otrosrubros;
  */
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_fidemanda( --fecha de ingreso de demanda **** UNIR CON JAQM27
                            P_N_JAQM27PGC  in number,
                            P_N_JAQM27MOD  in number,
                            P_N_JAQM27SUC  in number,
                            P_N_JAQM27MDA  in number,
                            P_N_JAQM27PAP  in number,
                            P_N_JAQM27CTA  in number,
                            P_N_JAQM27OPER in number,
                            P_N_JAQM27SBOP in number,
                            P_N_JAQM27TOPE in number,
                            P_N_JAQM33COR  in number,
                            P_N_JAQM33FDEM out varchar2) is
    ld_fecha DATE;
  begin
  
    begin
      select t.jaqm33fact
        into ld_fecha
        from jaqm33 t, jaqm27 j
       where j.jaqm27pgc = P_N_JAQM27PGC
         and j.jaqm27mod = P_N_JAQM27MOD
         and j.jaqm27suc = P_N_JAQM27SUC
         and j.jaqm27mda = P_N_JAQM27MDA
         and j.jaqm27pap = P_N_JAQM27PAP
         and j.jaqm27cta = P_N_JAQM27CTA
         and j.jaqm27oper = P_N_JAQM27OPER
         and j.jaqm27sbop = P_N_JAQM27SBOP
         and j.jaqm27tope = P_N_JAQM27TOPE
         and j.jaqm33cor = t.jaqm33cor;
    
    exception
      when others then
        NULL;
    end;
    P_N_JAQM33FDEM := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_fidemanda;
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_refinanciado( /*fecha castigo jaql166*/P_N_JAQL166PGCOD in number,
                               P_N_JAQL166SCMOD in number,
                               P_N_JAQL166SCSUC in number,
                               P_N_JAQL166SCMDA in number,
                               P_N_JAQL166SCPAP in number,
                               P_N_JAQL166SCCTA in number,
                               P_N_JAQL166SCOPE in number,
                               P_N_JAQL166SCSBO in number,
                               P_N_JAQL166SCTOP in number,
                               P_N_JAQL166EST   in number,
                               P_N_JAQL166SCFVL out varchar2) is
    ld_fecha date;
  begin
  
    begin
      /* select c.jaql166scfvl into ld_fecha from jaql166 c
      where c.jaql166pgcod= P_N_JAQL166PGCOD
      and c.jaql166scmod = P_N_JAQL166SCMOD
      and c.jaql166scsuc=  P_N_JAQL166SCSUC
      and c.jaql166scmda=  P_N_JAQL166SCMDA
      and c.jaql166scpap = P_N_JAQL166SCPAP
      and c.jaql166sccta = P_N_JAQL166SCCTA
      and c.jaql166scope = P_N_JAQL166SCOPE
      and c.jaql166sctop = P_N_JAQL166SCTOP
      and c.jaql166est = 33;*/
      select f.aofval
        into ld_fecha
        from fsd010 f
       where f.pgcod = P_N_JAQL166PGCOD
            --and f.aomod=P_N_JAQL166SCMOD
         and f.aosuc = P_N_JAQL166SCSUC
         and f.aomda = P_N_JAQL166SCMDA
         and f.aopap = P_N_JAQL166SCPAP
         and f.aocta = P_N_JAQL166SCCTA
         and f.aooper = P_N_JAQL166SCOPE
         and f.aosbop = P_N_JAQL166SCSBO
         and f.aotope = P_N_JAQL166SCTOP
         and f.aostat in (33, 34);
    
    exception
      when others then
        NULL;
    end;
    P_N_JAQL166SCFVL := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_refinanciado;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_interes_compextra( ---fsd011
                                    P_N_PGCOD  in number,
                                    P_N_SCSUC  in number,
                                    P_N_SCMDA  in number,
                                    P_N_SCPAP  in number,
                                    P_N_SCCTA  in number,
                                    P_N_SCOPER in number,
                                    P_N_SCSBOP in number,
                                    P_N_SCTOPE in number,
                                    P_N_SCSDO  out number) is
  begin
    begin
      select l.scsdo
        into P_N_SCSDO
        from fsd011 l
       where l.pgcod = P_N_PGCOD
         and l.scsuc = P_N_SCSUC
         and l.scmda = P_N_SCMDA
         and l.scpap = P_N_SCPAP
         and l.sccta = P_N_SCCTA
         and l.scrub in (9300073100000, 9300073000000)
         and l.scoper = P_N_SCOPER
         and l.scsbop = P_N_SCSBOP
         and l.sctope = P_N_SCTOPE;
    exception
      when others then
        NULL;
    end;
  
  end sp_cr_interes_compextra;
  ---------------------------------------------------------------------------------------
  procedure sp_cr_castigado(P_N_JAQL166PGCOD in number,
                            P_N_JAQL166SCMOD in number,
                            P_N_JAQL166SCSUC in number,
                            P_N_JAQL166SCMDA in number,
                            P_N_JAQL166SCPAP in number,
                            P_N_JAQL166SCCTA in number,
                            P_N_JAQL166SCOPE in number,
                            P_N_JAQL166SCSBO in number,
                            P_N_JAQL166SCTOP in number,
                            P_N_JAQL166EST   in number,
                            P_N_JAQL166CAST  out char) is
  
    ld_fecha date;
  
  begin
  
    begin
      select max(c.jaql166scfvl)
        into ld_fecha
        from jaql166 c
       where c.jaql166pgcod = P_N_JAQL166PGCOD
         and c.jaql166scmod = P_N_JAQL166SCMOD
         and c.jaql166scsuc = P_N_JAQL166SCSUC
         and c.jaql166scmda = P_N_JAQL166SCMDA
         and c.jaql166scpap = P_N_JAQL166SCPAP
         and c.jaql166sccta = P_N_JAQL166SCCTA
         and c.jaql166scope = P_N_JAQL166SCOPE
         and c.jaql166scsbo = P_N_JAQL166SCSBO
         and c.jaql166sctop = P_N_JAQL166SCTOP
         and c.jaql166est = 90;
    exception
      when others then
        NULL;
    end;
  
    P_N_JAQL166CAST := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_castigado;

  ---------------------------------------------------------------------------------------
  procedure sp_cr_updatejaql964(P_N_CUENTA         in number,
                                P_N_OPERACION      in number,
                                P_N_SUBOPER        in number,
                                P_N_CORRELATIVO    in number,
                                P_N_ESTADO         in number,
                                P_N_FCAN           in varchar2,
                                P_N_MAPRO          in number,
                                P_N_PROV           in number,
                                P_N_CALF           in number,
                                P_N_DCALF          in varchar2,
                                P_N_JAQM33FDEM     in varchar2,
                                P_N_JAQL166SCFVL   in varchar2,
                                P_N_SCSDO          in number,
                                P_N_JAQL166CAST    in varchar2,
                                P_N_SNG419FECT     in varchar2,
                                P_N_PGCOD          in number,
                                P_N_PAP            IN NUMBER,
                                P_N_JAQM33FINT     in varchar2,
                                P_N_JAQM33FACT     in varchar2,
                                P_N_JAQL165COM     in varchar2,
                                P_N_JAQL165DCOM    in varchar2,
                                P_N_JAQL165TEX     in varchar2,
                                P_N_NROEXP         in VARCHAR2,
                                P_N_JAQL964FIRL    in varchar2,
                                P_N_JAQL964FAABO   in varchar2,
                                P_N_JAQL964FEJUD   in varchar2,
                                P_N_JAQL964FDES    in varchar2,
                                P_N_TIPCRED        in number,
                                P_C_ABOGADO        in varchar2,
                                P_C_SOBREENDEUDADO in varchar2,
                                P_N_PLAZO          in number,
                                ln_ciiu            in number) is
  begin
    begin
      UPDATE JAQL964 j
         set J.JAQL964CTA   = P_N_CUENTA,
             J.JAQL964OPE   = P_N_OPERACION,
             J.JAQL964EST   = P_N_ESTADO,
             J.JAQL964FCAN  = P_N_FCAN,
             J.JAQL964MAPR  = P_N_MAPRO,
             J.JAQL964PROV  = P_N_PROV,
             J.JAQL964CALF  = P_N_CALF,
             j.jaql964dcalf = P_N_DCALF,
             J.JAQL964FDEM  = P_N_JAQM33FDEM,
             J.JAQ964FREF   = P_N_JAQL166SCFVL,
             J.JAQL964ICEX  = P_N_SCSDO,
             J.JAQL964FCAS  = P_N_JAQL166CAST,
             j.jaql964ftab  = P_N_SNG419FECT,
             j.jaql964pgcod = P_N_PGCOD,
             j.jaql964pap   = P_N_PAP,
             j.jaql964fint  = P_N_JAQM33FINT,
             j.jaql964fadem = P_N_JAQM33FACT,
             j.jaql964apago = P_N_JAQL165COM,
             j.jaql964dpago = P_N_JAQL165DCOM,
             j.jaql964cesp  = P_N_JAQL165TEX,
             J.JAQL964NEXP  = P_N_NROEXP,
             j.jaql964firl  = P_N_JAQL964FIRL,
             j.jaql964faabo = P_N_JAQL964FAABO,
             j.jaql964fejud = P_N_JAQL964FEJUD,
             j.jaql964fdes  = P_N_JAQL964FDES,
             j.jaql964tcr   = P_N_TIPCRED,
             j.jaql964abo   = P_C_ABOGADO,
             j.jaql964soben = P_C_SOBREENDEUDADO,
             j.jaql964pzo   = P_N_PLAZO,
             j.jaql964ciiu  = ln_ciiu
       WHERE J.JAQL964COR = P_N_CORRELATIVO;
    
    exception
      when others then
        NULL;
      
    end;
    commit;
  
  end sp_cr_updatejaql964;
  ----------------------------------------------------------------------------------------------
  procedure sp_cr_ftransabogado(P_N_SNG419PGC  in number,
                                P_N_SNG419MOD  in number,
                                P_N_SNG419SUC  in number,
                                P_N_SNG419MDA  in number,
                                P_N_SNG419PAP  in number,
                                P_N_SNG419CTA  in number,
                                P_N_SNG419OPE  in number,
                                P_N_SNG419SBO  in number,
                                P_N_SNG419TOP  in number,
                                P_N_SNG419FECT out varchar2) is
    ld_fecha date;
  begin
    begin
    
      select max(sng419fect)
        into ld_fecha
        from sng419 s
       where s.sng419acc = 4
         and s.sng419pgc = P_N_SNG419PGC
         and s.sng419mod = P_N_SNG419MOD
         and s.sng419suc = P_N_SNG419SUC
         and s.sng419mda = P_N_SNG419MDA
         and s.sng419pap = P_N_SNG419PAP
         and s.sng419cta = P_N_SNG419CTA
         and s.sng419ope = P_N_SNG419OPE
         and s.sng419sbo = P_N_SNG419SBO
         and s.sng419top = P_N_SNG419TOP;
    exception
      when others then
        NULL;
      
    end;
    P_N_SNG419FECT := to_char(ld_fecha, 'yyyy.mm.dd');
  end sp_cr_ftransabogado;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_acuerdo_pago(
                               /* P_N_JAQL165CORR in number, */P_N_JAQL165EMP  in number,
                               P_N_JAQL165SUC  in number,
                               P_N_JAQL165MDA  in number,
                               P_N_JAQL165PAP  in number,
                               P_N_JAQL165CTA  in number,
                               P_N_JAQL165OPE  in number,
                               P_N_JAQL165SBO  in number,
                               P_N_JAQL165TOP  in number,
                               P_N_JAQL165MOD  in number,
                               P_N_JAQL165COM  out varchar2,
                               P_N_JAQL165DCOM out varchar2
                               
                               ) is
  begin
    begin
      SELECT T.JAQL165COM
        into P_N_JAQL165COM
        FROM JAQL165 T
       where /*t.jaql165corr =P_N_JAQL165CORR
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          and */
       t.jaql165emp = P_N_JAQL165EMP
       and t.jaql165suc = P_N_JAQL165SUC
       and t.jaql165mda = P_N_JAQL165MDA
       and t.jaql165pap = P_N_JAQL165PAP
       and t.jaql165cta = P_N_JAQL165CTA
       and t.jaql165ope = P_N_JAQL165OPE
       and t.jaql165sbo = P_N_JAQL165SBO
       and t.jaql165top = P_N_JAQL165TOP
       and t.jaql165mod = P_N_JAQL165MOD;
    
    exception
      when others then
        NULL;
    end;
  
    if P_N_JAQL165COM = 'P' then
      P_N_JAQL165DCOM := 'Cancelacion Especial Parcial';
    elsif P_N_JAQL165COM = 'D' then
      P_N_JAQL165DCOM := 'De pago';
    elsif P_N_JAQL165COM = 'T' then
      P_N_JAQL165DCOM := 'Cancelacion Especial Total';
    elsif P_N_JAQL165COM = 'N' then
      P_N_JAQL165DCOM := 'Ninguna';
    end if;
  end sp_cr_acuerdo_pago;
  ----------------------------------------------------------------------
  procedure sp_cr_cancelacion_esp(
                                  /*P_N_JAQL165CORR in number, */P_N_JAQL165EMP in number,
                                  P_N_JAQL165SUC in number,
                                  P_N_JAQL165MDA in number,
                                  P_N_JAQL165PAP in number,
                                  P_N_JAQL165CTA in number,
                                  P_N_JAQL165OPE in number,
                                  P_N_JAQL165SBO in number,
                                  P_N_JAQL165TOP in number,
                                  P_N_JAQL165MOD in number,
                                  P_N_JAQL165TEX out varchar2
                                  
                                  ) is
  begin
    begin
      SELECT T.JAQL165TEX
        into P_N_JAQL165TEX
        FROM JAQL165 T
       where /*t.jaql165corr =P_N_JAQL165CORR
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          and */
       t.jaql165emp = P_N_JAQL165EMP
       and t.jaql165suc = P_N_JAQL165SUC
       and t.jaql165mda = P_N_JAQL165MDA
       and t.jaql165pap = P_N_JAQL165PAP
       and t.jaql165cta = P_N_JAQL165CTA
       and t.jaql165ope = P_N_JAQL165OPE
       and t.jaql165sbo = P_N_JAQL165SBO
       and t.jaql165top = P_N_JAQL165TOP
       and t.jaql165mod = P_N_JAQL165MOD
       and t.jaql165com in ('T', 'P');
    
    exception
      when others then
        NULL;
    end;
  
  end sp_cr_cancelacion_esp;

  ----------------------------------------------------------------------------------------
  procedure sp_cr_carga_971(P_N_INI in NUMBER, P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza_monto
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza Monto Aprobado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :03-06-2014
    -- Autor de la Modificaci¿n   : MPOSTIGOC
    -- Descripci¿n de Modificaci¿n: Se carga data en la tabla jaql971, informacion de los
    --                              avales 
    --                              2018.01.29 DCASTRO se modifico procedimiento sp_cr_aval, se agrego variable ubigeo
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in NUMBER, P_N_FIN in NUMBER) is
      select j.jaql964cor,
             j.jaql964ins,
             J.JAQL964SUC,
             j.jaql964cta,
             j.jaql964mod,
             j.jaql964mda,
             j.jaql964ope,
             j.jaql964sob,
             j.jaql964top,
             j.jaql964est
        from jaql964 j /*where j.jaql964cta=79859*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
    cursor aval(ln_instancia in number) is
      select s.sng003cta, f.pendoc, f.petdoc, f.pepais, d.penom
        from sng003 s, fsr008 f, fsd001 d
       where s.sng001inst = ln_instancia
         and s.sng003cta = f.ctnro
         and f.cttfir = 'T'
         and f.pendoc = d.pendoc
         and f.pepais = d.pepais
         and f.petdoc = d.petdoc;
  
    --lc_tonom           varchar2(30);
    ln_cont number := 0;
    --lc_mod             varchar2(10);
    --ln_monto           number := 0;
    lc_telefonos      varchar2(200);
    lc_direccion      varchar2(150);
    lc_referencia     varchar2(200);
    lc_referenciaaval varchar2(200);
    lc_distrito       varchar2(50);
    lc_distritoneg    varchar2(50);
    lc_direcneg       varchar2(150);
    lc_dpto           varchar2(50);
    lc_prov           varchar2(50);
    lc_dist           varchar2(50);
    --lc_fcancelacion    varchar2(8);
    --ln_maprobado       number;
    --ln_provision       number;
    --ln_calificacion    number;
    --lc_frefinanciado   varchar2(8);
    --lc_fcastigo        varchar2(8);
    --lc_fdemanda        varchar2(8);
    --ln_icextracontable number;
    --ln_pgcod           number := 1;
    --ln_papel           number := 0;
    --lc_ftransferencia  varchar2(10);
    --ln_descalificacion varchar2(15);
  
    --lc_telefono fsr005.dotelfp%TYPE;
    --ln_cuenta   fsd011.sccta%TYPE;
    --ln_pepais   fsr008.pepais%TYPE;
    --ln_petdoc   fsr008.petdoc%TYPE;
    --ln_pendoc   fsr008.pendoc%TYPE;
    --lc_penom    fsd001.penom%TYPE;
  
    --lc_direc varchar2(180);
  
    lc_ubigeo char(6); --2018.01.29
  
    --R1MOD, R1CTA, R1OPER, R1SBOP, r1suc, r1pap, r1tope ,r1mda
  
  begin
  
    for i in cartera(P_N_INI, P_N_FIN) loop
      ln_cont := 0;
      for y in aval(i.jaql964ins) loop
      
        PQ_CR_jaql964_cartera.sp_cr_direccion_aval(P_N_PEPAIS => y.pepais,
                                                   P_N_PETDOC => y.petdoc,
                                                   P_N_PENDOC => y.pendoc,
                                                   P_C_direc  => lc_direccion,
                                                   P_C_distr  => lc_distrito,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_ubigeo => lc_ubigeo);
      
        PQ_CR_jaql964_cartera.sp_cr_direccion_negocio(P_N_PEPAIS => y.pepais,
                                                      P_N_PETDOC => y.petdoc,
                                                      P_N_PENDOC => y.pendoc,
                                                      P_C_DIRNEG => lc_direcneg,
                                                      P_C_distr  => lc_distritoneg,
                                                      P_C_refer1 => lc_referenciaaval);
      
        lc_telefonos := PQ_CR_jaql964_cartera.fn_cr_telefono_aval(P_N_PEPAIS => y.pepais,
                                                                  P_N_PETDOC => y.petdoc,
                                                                  P_N_PENDOC => y.pendoc);
      
        --2018                                                          
        begin
          pq_cr_jaql964_cartera.sp_cr_dpto_prov_dis(pc_ubigeo => lc_ubigeo,
                                                    pc_dpto   => lc_dpto,
                                                    pc_prov   => lc_prov,
                                                    pc_dist   => lc_dist);
        end;
      
        --2018.01.29
        ln_cont := ln_cont + 1;
      
        if ln_cont = 1 then
        
          PQ_CR_jaql964_cartera.sp_cr_inserta_aval(p_n_corr964 => i.JAQL964COR,
                                                   P_N_CTAAVA  => y.sng003cta,
                                                   P_C_PENOM   => y.penom,
                                                   P_N_PETDOC  => y.petdoc,
                                                   P_N_PENDOC  => y.pendoc,
                                                   P_C_DIREC   => lc_direccion,
                                                   P_C_refer1  => lc_referencia,
                                                   P_C_distr   => lc_distrito,
                                                   P_C_TELEF   => lc_telefonos,
                                                   P_C_DIRNEG  => lc_direcneg,
                                                   P_N_PEPAIS  => y.pepais,
                                                   P_C_ubigeo  => lc_ubigeo,
                                                   P_C_DPTO    => lc_dpto,
                                                   P_C_PROV    => lc_prov);
        
        else
        
          PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                  P_N_CTAAVA   => y.sng003cta,
                                                  P_C_PENOM    => y.penom,
                                                  P_N_PETDOC   => y.petdoc,
                                                  P_N_PENDOC   => y.pendoc,
                                                  P_C_DIREC    => lc_direccion,
                                                  P_C_refer1   => lc_referencia,
                                                  P_C_distr    => lc_distrito,
                                                  P_C_TELEF    => lc_telefonos,
                                                  P_C_DIRNEG   => lc_direcneg,
                                                  P_N_PEPAIS   => y.pepais,
                                                  P_N_POSICION => ln_cont, -- se reemplazo por variable
                                                  P_C_ubigeo   => lc_ubigeo,
                                                  P_C_DPTO     => lc_dpto,
                                                  P_C_PROV     => lc_prov);
        
        end if;
      
      /*   2018.01.29
                                                                                                                                                                                                                                                                                                                                                                                                                                      ln_cont := ln_cont + 1;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 1 then
                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_inserta_aval(p_n_corr964 => i.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_N_CTAAVA  => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_PENOM   => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_N_PETDOC  => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_N_PENDOC  => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_DIREC   => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_refer1  => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_distr   => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_TELEF   => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_DIRNEG  => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_N_PEPAIS  => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 2 then
                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_CTAAVA   => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_PENOM    => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PETDOC   => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PENDOC   => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIREC    => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_refer1   => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_distr    => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_TELEF    => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIRNEG   => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PEPAIS   => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_POSICION => 2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 3 then
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_CTAAVA   => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_PENOM    => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PETDOC   => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PENDOC   => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIREC    => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_refer1   => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_distr    => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_TELEF    => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIRNEG   => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PEPAIS   => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_POSICION => 3,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 4 then
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_CTAAVA   => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_PENOM    => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PETDOC   => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PENDOC   => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIREC    => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_refer1   => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_distr    => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_TELEF    => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIRNEG   => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PEPAIS   => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_POSICION => 4,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 5 then
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_CTAAVA   => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_PENOM    => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PETDOC   => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PENDOC   => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIREC    => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_refer1   => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_distr    => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_TELEF    => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIRNEG   => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PEPAIS   => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_POSICION => 5,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                                                                                                                                      if ln_cont = 6 then
                                                                                                                                                                                                                                                                                                                                                                                                                                        PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964  => I.JAQL964COR,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_CTAAVA   => y.sng003cta,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_PENOM    => y.penom,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PETDOC   => y.petdoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PENDOC   => y.pendoc,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIREC    => lc_direccion,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_refer1   => lc_referencia,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_distr    => lc_distrito,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_TELEF    => lc_telefonos,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_DIRNEG   => lc_direcneg,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_PEPAIS   => y.pepais,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_N_POSICION => 6,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P_C_ubigeo  => lc_ubigeo);
                                                                                                                                                                                                                                                                                                                                                                                                                                      end if;
                                                                                                                                                                                                                                                                                                                                                                                                                                   */
      
      end loop;
    
      -- 2018.02.01
      begin
        pq_cr_jaql964_cartera.sp_cr_tit_representante(pn_corr => I.JAQL964COR);
      end;
      --2018.02.01
    
      commit;
    end loop;
  
  end sp_cr_carga_971;
  ----------------------------------------------------------------------

  /*procedure sp_cr_jaql971II(ln_cuentaaval in number,
                          lc_penomaval in varchar2,
                          ln_pepaisaval in number,
                          ln_petdocaval in number,
                          ln_pendocaval in character,
                          correlativo in number)is
                          
    lc_direccion varchar2(150);
    lc_referencia varchar2(200);
    lc_distrito varchar2(50);
    lc_direcneg varchar2(150);
    lc_telefonos varchar2(200);
    lc_telefono fsr005.dotelfp%TYPE;
    
    ln_cont number :=0;
    
  begin
  
        PQ_CR_jaql964_cartera.sp_cr_direccion_aval(ln_pepaisaval ,
                                                   ln_petdocaval,
                                                   ln_pendocaval,
                                                   lc_direccion,
                                                   lc_distrito,
                                                   lc_referencia) ;
            
         PQ_CR_jaql964_cartera.sp_cr_direccion_negocio(ln_pepaisaval ,
                                                        ln_petdocaval,
                                                         ln_pendocaval,
                                                       lc_direcneg,
                                                       lc_distrito,
                                                       lc_referencia) ;
  
                                                                                                                        
          lc_telefonos := PQ_CR_jaql964_cartera.fn_cr_telefono_aval(ln_pepaisaval ,
                                                        ln_petdocaval,
                                                         ln_pendocaval);                                                       
           
         
          ln_cont := ln_cont + 1;
          
          if ln_cont = 1 then 
          
  
            PQ_CR_jaql964_cartera.sp_cr_inserta_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval);
                                                    
          end if; 
          
          if ln_cont = 2 then 
           
           PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval,
                                                   P_N_POSICION => 2);
           
          end if; 
          
          if ln_cont = 3 then
            PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval,
                                                   P_N_POSICION => 3);
          end if; 
          
          if ln_cont = 4 then 
           PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval,
                                                   P_N_POSICION=> 4);
          end if; 
          
          if ln_cont = 5 then 
            PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval,
                                                   P_N_POSICION=> 5);
          end if; 
          
          if ln_cont = 6 then 
         PQ_CR_jaql964_cartera.sp_cr_update_aval(p_n_corr964 => correlativo,
                                                   P_N_CTAAVA => ln_cuentaaval,
                                                   P_C_PENOM =>  lc_penomaval,
                                                   P_N_PETDOC => ln_petdocaval,
                                                   P_N_PENDOC => ln_pendocaval,
                                                   P_C_DIREC =>  lc_direccion,
                                                   P_C_refer1 => lc_referencia,
                                                   P_C_distr =>  lc_distrito,
                                                   P_C_TELEF =>  lc_telefonos,
                                                   P_C_DIRNEG => lc_direcneg,
                                                   P_N_PEPAIS => ln_pepaisaval,
                                                   P_N_POSICION => 6);
          end if; 
  
  
  end sp_cr_jaql971II; */
  -------------------------------------------------------------------------------
  procedure sp_cr_finterposicion( --fecha interposicion de demanda 
                                 P_N_JAQM27PGC  in number,
                                 P_N_JAQM27MOD  in number,
                                 P_N_JAQM27SUC  in number,
                                 P_N_JAQM27MDA  in number,
                                 P_N_JAQM27PAP  in number,
                                 P_N_JAQM27CTA  in number,
                                 P_N_JAQM27OPER in number,
                                 P_N_JAQM27SBOP in number,
                                 P_N_JAQM27TOPE in number,
                                 P_N_JAQM33COR  in number,
                                 P_N_JAQM33FINT out varchar2,
                                 P_N_NROEXP     out varchar2) is
    ld_fecha DATE;
  begin
  
    begin
      select t.jaqm33fint, t.jaqm33nexp
        into ld_fecha, P_N_NROEXP
        from jaqm33 t, jaqm27 j
       where j.jaqm27pgc = P_N_JAQM27PGC
         and j.jaqm27mod = P_N_JAQM27MOD
         and j.jaqm27suc = P_N_JAQM27SUC
         and j.jaqm27mda = P_N_JAQM27MDA
         and j.jaqm27pap = P_N_JAQM27PAP
         and j.jaqm27cta = P_N_JAQM27CTA
         and j.jaqm27oper = P_N_JAQM27OPER
         and j.jaqm27sbop = P_N_JAQM27SBOP
         and j.jaqm27tope = P_N_JAQM27TOPE
         and j.jaqm33cor = t.jaqm33cor;
    
    exception
      when others then
        NULL;
    end;
    P_N_JAQM33FINT := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_finterposicion;
  -------------------------------------------------------------------------------
  procedure sp_cr_faceptacion( --fecha aceptacion de demanda 
                              P_N_JAQM27PGC  in number,
                              P_N_JAQM27MOD  in number,
                              P_N_JAQM27SUC  in number,
                              P_N_JAQM27MDA  in number,
                              P_N_JAQM27PAP  in number,
                              P_N_JAQM27CTA  in number,
                              P_N_JAQM27OPER in number,
                              P_N_JAQM27SBOP in number,
                              P_N_JAQM27TOPE in number,
                              P_N_JAQM33COR  in number,
                              P_N_JAQM33FACT out varchar2) is
    ld_fecha DATE;
  begin
  
    begin
      select t.jaqm33fdem
        into ld_fecha
        from jaqm33 t, jaqm27 j
       where j.jaqm27pgc = P_N_JAQM27PGC
         and j.jaqm27mod = P_N_JAQM27MOD
         and j.jaqm27suc = P_N_JAQM27SUC
         and j.jaqm27mda = P_N_JAQM27MDA
         and j.jaqm27pap = P_N_JAQM27PAP
         and j.jaqm27cta = P_N_JAQM27CTA
         and j.jaqm27oper = P_N_JAQM27OPER
         and j.jaqm27sbop = P_N_JAQM27SBOP
         and j.jaqm27tope = P_N_JAQM27TOPE
         and j.jaqm33cor = t.jaqm33cor;
    
    exception
      when others then
        NULL;
    end;
    P_N_JAQM33FACT := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_faceptacion;
  -------------------------------------------------------------------------------
  procedure sp_cr_job_carga is
    --2023.11.07 se modifico numero de jobs, se agregó guia tp1cod1 = 10847 tp1corr1 = 9999
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
    --ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
  
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    begin
      select TP1IMP1
        into ln_divisor
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 9999
         and TP1CORR2 = 1;
    exception
      when others then
        ln_divisor := 5000;
    end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => '' /*'DESA010615'*/,
                                    tabname          => 'JAQL964',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaql964;
    end;
  
    ln_ini := 1;
    ln_fin := ln_divisor; ---2023.11.07 se modifico inicial 5000
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' ||
                     '  pq_cr_jaql964_cartera.sp_cr_carga_aval(' || ln_ini || ',' ||
                     ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      --      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        --  instance  => 2, --24/10/2023
                        instance => 1,
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  
  end sp_cr_job_carga;
  ----------------------------------------------------------------------
  /*procedure sp_cr_job_carga_datos(P_D_FECPRO in date)  is 
  
     cursor c_sucursal_job is  --sucursales
      select sucurs from fst001
          where sucurs < 800 or sucurs > 900
            and pgcod = 1;
  
  
  ln_ini number;
  ln_fin number;
  ln_divisor number:=5000;
  lc_variable varchar2(4000);
  ln_job number:=0;
  lc_fecpro char(10);
  ld_finmes date;
  ln_contador number;
  ln_num number:= 1;
  
   
  begin
  
    lc_fecpro := to_char(P_D_FECPRO,'RRRRMMDD');  
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                      tabname          => 'JAQL964',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
       for job in c_sucursal_job loop
            
            lc_variable := 'begin '||'pq_cr_jaql964_cartera.sp_cr_carga_datos('||'TO_DATE('''||lc_fecpro||''',''RRRRMMDD'')'||','||job.sucurs||' );'||' End;';
            ln_job := ln_job +1;
             DBMS_JOB.SUBMIT(job => ln_job, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*60),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
                                           
  commit;
  
    END LOOP;   
    
  end sp_cr_job_carga_datos;*/

  ----------------------------------------------------------------------
  procedure sp_cr_job_actualiza_analistab(P_D_FECPRO in date) is
    --2023.11.07 se modifico numero de jobs, se agregó guia tp1cod1 = 10847 tp1corr1 = 9999
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    begin
      select TP1IMP1
        into ln_divisor
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 9999
         and TP1CORR2 = 1;
    exception
      when others then
        ln_divisor := 5000;
    end;
  
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --desa011215',
                                    tabname          => 'JAQL964',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaql964;
    end;
  
    ln_ini := 1;
    ln_fin := ln_divisor; ---2023.11.07 se modifico inicial 5000
  
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' ||
                     '  pq_cr_jaql964_cartera.sp_cr_actualiza_analista_bulk(' ||
                     'TO_DATE(''' || lc_fecpro || ''',''RRRR.MM.DD'')' || ',' ||
                     ln_ini || ',' || ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      --      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        --   instance  => 2, -- 24/10/2023
                        instance => 1,
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  
  end sp_cr_job_actualiza_analistab;
  ----------------------------------------------------------------------------------------

  procedure sp_cr_job_carga_971(P_D_FECPRO in varchar2) is
    --2023.11.07 se modifico numero de jobs, se agregó guia tp1cod1 = 10847 tp1corr1 = 9999
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
    --ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    begin
      select TP1IMP1
        into ln_divisor
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 9999
         and TP1CORR2 = 1;
    exception
      when others then
        ln_divisor := 5000;
    end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', --'BANTPROD',
                                    tabname          => 'JAQL971',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaql964;
    end;
  
    ---Insertar Historico
    pq_cr_jaql964_cartera.sp_cr_guardar_historico_2(P_D_FECPRO);
    ---
  
    execute immediate 'truncate table jaql971';
    execute immediate 'truncate table jaql964a'; --2018.01.28
  
    ln_ini := 1;
    ln_fin := ln_divisor; ---2023.11.07 se modifico inicial 5000
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' || 'pq_cr_jaql964_cartera.sp_cr_carga_971(' ||
                     ln_ini || ',' || ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      --      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        -- instance  => 2, --24/10/2023
                        instance => 1,
                        force    => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  end sp_cr_job_carga_971;
  ----------------------------------------------------------------------------------------
  Procedure sp_cr_actualiza_tipocontable(P_D_FECPRO in date,
                                         -- P_C_ESTADO out varchar2,
                                         P_N_INI in NUMBER,
                                         P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2014.01.03
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se modifico actualizacion lc_analista
    --
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in number, P_N_FIN in number) is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       jaql964csb,
       jaql964cor,
       jaql964pap
        from jaql964 j /*where j.jaql964cta=4042;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
    TYPE Tp_jaql964mod IS TABLE OF jaql964.jaql964mod%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cta IS TABLE OF jaql964.jaql964cta%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964ope IS TABLE OF jaql964.jaql964ope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964sob IS TABLE OF jaql964.jaql964sob%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964top IS TABLE OF jaql964.jaql964top%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964suc IS TABLE OF jaql964.jaql964suc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964mda IS TABLE OF jaql964.jaql964mda%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964usu IS TABLE OF jaql964.jaql964usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964doc IS TABLE OF jaql964.jaql964doc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964csb IS TABLE OF jaql964.jaql964csb%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cor IS TABLE OF jaql964.jaql964cor%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pap IS TABLE OF jaql964.jaql964pap%TYPE INDEX BY PLS_INTEGER;
  
    jaql964mod Tp_jaql964mod;
    jaql964cta Tp_jaql964cta;
    jaql964ope Tp_jaql964ope;
    jaql964sob Tp_jaql964sob;
    jaql964top Tp_jaql964top;
    jaql964suc Tp_jaql964suc;
    jaql964mda Tp_jaql964mda;
    jaql964usu Tp_jaql964usu;
    jaql964doc Tp_jaql964doc;
    jaql964csb Tp_jaql964csb;
    jaql964cor Tp_jaql964cor;
    jaql964pap Tp_jaql964pap;
  
    --lc_tipocontable varchar2(20);
    --lc_abogado      varchar2(50);
    --lc_garantia     varchar2(300);
    --ln_monto        number := 0;
    --lc_telefo       varchar2(20);
    --lc_direc        varchar2(150);
    --lc_distri       varchar2(50);
    --lc_analista     varchar2(30);
    --ln_numero       number := 0;
    lc_tipcon varchar2(30);
    --lc_bcgpo        number(4);
    --lc_produc       varchar2(30);
    --lc_tipocre      varchar2(30);
    --lc_credito      varchar2(20);
    --lc_refer        varchar2(200);
    --ln_instancia    number(10);
    ln_corr   number := 0;
    ln_sector number := 0;
    --ln_tipsbs       number := 0;
    --ln_pgcod        number := 1;
  
    --lc_telava fsr005.dotelfp%TYPE;
    --ln_ctaava fsd011.sccta%TYPE;
    --lc_nomava fsd001.penom%TYPE;
    --lc_dirava varchar2(180);
  
  begin
  
    OPEN cartera(P_N_INI, P_N_FIN);
    LOOP
      FETCH cartera BULK COLLECT
        INTO jaql964cta,
             jaql964mod,
             jaql964ope,
             jaql964sob,
             jaql964top,
             jaql964suc,
             jaql964mda,
             jaql964usu,
             jaql964doc,
             jaql964csb,
             jaql964cor,
             jaql964pap;
      IF jaql964cta.COUNT > 0 THEN
        FOR i IN jaql964cta.FIRST .. jaql964cta.LAST LOOP
        
          begin
            --tipo contable
            pq_cr_jaql964_cartera.sp_cr_tipocontable(P_D_FECPRO,
                                                     jaql964mod(i),
                                                     jaql964cta(i),
                                                     jaql964ope(i),
                                                     jaql964sob(i),
                                                     jaql964top(i),
                                                     jaql964suc(i),
                                                     jaql964mda(i),
                                                     lc_tipcon);
          end;
        
          update jaql964
             set jaql964tco = lc_tipcon
           where jaql964cor = jaql964cor(i);
          --and jaql964ope = jaql964ope(i);
          ln_sector := null;
          ln_corr   := ln_corr + 1;
          if ln_corr = 5000 then
            commit;
            ln_corr := 0;
          end if;
        
        END LOOP;
      END IF;
      EXIT WHEN cartera%NOTFOUND;
    END LOOP;
    COMMIT;
  
  end sp_cr_actualiza_tipocontable;

  ----------------------------------------------------------------------------------------
  /*procedure sp_cr_job_tipocontable(P_D_FECPRO in date)  is 
  ln_ini number;
  ln_fin number;
  ln_divisor number:=1000;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_fecpro char(10);
  ld_finmes date;
  ln_contador number;
  ln_num number:= 1;
  
   
  begin
  
    lc_fecpro := to_char(P_D_FECPRO,'RRRR.MM.DD');  
    begin
        DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                      tabname          => 'JAQL964',
                                      degree           => 4,
                                      granularity      => 'ALL',
                                      estimate_percent => dbms_stats.auto_sample_size,
                                      cascade          => TRUE);
      end;
  
       begin
         select ceil(count(*)/ln_divisor) into ln_contador from jaql964;
     end;       
  
     ln_ini := 1; 
     ln_fin := 5000;
     WHILE ln_num <= ln_contador
     LOOP
     
            
            lc_variable := 'begin '||'  pq_cr_jaql964_cartera.sp_cr_actualiza_tipocontable('||'TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'')'||','||ln_ini||','||ln_fin||' );'||' End;';
            ln_job := ln_job +1;
             DBMS_JOB.SUBMIT(job => ln_job, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*60),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
                          
  
           ln_ini := ln_fin + 1;
           ln_fin := ln_ini + ln_divisor - 1;
           
           ln_num := ln_num + 1;
           commit;
    END LOOP;   
    
  end sp_cr_job_tipocontable;*/

  ----------------------------------------------------------------------------------------
  procedure sp_cr_abogado_1(P_N_PGCOD     in number,
                            P_N_MONEDA    in number,
                            P_N_PAPEL     in number,
                            P_N_CUENTA    in number,
                            P_N_OPERACION in number,
                            P_N_MODULO    in number,
                            P_N_SUCURSAL  in number,
                            P_N_SUBOPER   in number,
                            P_N_TIPOPER   in number,
                            P_C_ABOGADO   out varchar2)
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_abogado
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Abogado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ***************************************************************** 
   is
  
    lc_abogado varchar2(50);
    lc_coderr  varchar2(100);
    lc_msgerr  varchar2(100);
  
  begin
    BEGIN
    
      SELECT distinct s.jaqm34nom
        into P_C_ABOGADO
        from jaqm35 t
        left join jaqm34 s
          on s.jaqm34cod = t.jaqm34cod
       where t.jaqm35pgco = P_N_PGCOD
         and t.jaqm35mda = P_N_MONEDA
         and t.jaqm35pap = P_N_PAPEL
         and t.jaqm35cta = P_N_CUENTA
         and t.jaqm35oper = P_N_OPERACION
         and t.jaqm35tcon = 'S'
         and t.jaqm35tope = 550
      /*and (t.jaqm35corr,t.jaqm35sbop)in (
              select max(t.jaqm35corr),max(t.jaqm35sbop)
              from jaqm35 t
              left join jaqm34 s
              on  s.jaqm34cod = t.jaqm34cod
              where t.jaqm35pgco=P_N_PGCOD
              and t.jaqm35mda=P_N_MONEDA
              and t.jaqm35pap=P_N_PAPEL
              and t.jaqm35cta=P_N_CUENTA
              and t.jaqm35oper=P_N_OPERACION
               and t.jaqm35tcon='S'
      )*/
      ;
    
    exception
      WHEN TOO_MANY_ROWS THEN
        begin
          select distinct s.jaqm34nom
            into P_C_ABOGADO
            from jaqm35 t
            left join jaqm34 s
              on s.jaqm34cod = t.jaqm34cod
           inner join fsd010 f
              on t.jaqm35pgco = f.pgcod
             and t.jaqm35mod = f.aomod
             and t.jaqm35suc = f.aosuc
             and t.jaqm35mda = f.aomda
             and t.jaqm35pap = f.aopap
             and t.jaqm35cta = f.aocta
             and t.jaqm35oper = f.aooper
             and t.jaqm35sbop = f.aosbop
             and t.jaqm35tope = f.aotope
          
           where t.jaqm35pgco = P_N_PGCOD
             and t.jaqm35mda = P_N_MONEDA
             and t.jaqm35pap = P_N_PAPEL
             and t.jaqm35cta = P_N_CUENTA
             and t.jaqm35oper = P_N_OPERACION
             and t.jaqm35tcon = 'S'
             and f.aostat <> 99
             and (t.jaqm35corr, t.jaqm35sbop) in
                 (select max(t.jaqm35corr), max(t.jaqm35sbop)
                    from jaqm35 t
                    left join jaqm34 s
                      on s.jaqm34cod = t.jaqm34cod
                   where t.jaqm35pgco = P_N_PGCOD
                     and t.jaqm35mda = P_N_MONEDA
                     and t.jaqm35pap = P_N_PAPEL
                     and t.jaqm35cta = P_N_CUENTA
                     and t.jaqm35oper = P_N_OPERACION
                     and t.jaqm35tcon = 'S');
        exception
          when no_data_found then
            begin
            
              select distinct s.jaqm34nom
                into P_C_ABOGADO
                from jaqm35 t
                left join jaqm34 s
                  on s.jaqm34cod = t.jaqm34cod
               inner join fsr011 f
                  on t.jaqm35pgco = f.r1cod
                 and t.jaqm35mod = f.r1mod
                 and t.jaqm35suc = f.r1suc
                 and t.jaqm35mda = f.r1mda
                 and t.jaqm35pap = f.r1pap
                 and t.jaqm35cta = f.r1cta
                 and t.jaqm35oper = f.r1oper
                 and t.jaqm35sbop = f.r1sbop
                 and t.jaqm35tope = f.r1tope
                 and t.jaqm35tcon = 'S'
               where f.r1cod = P_N_PGCOD
                 and f.r2mod = P_N_MODULO
                 and f.r2suc = P_N_SUCURSAL
                 and f.r2mda = P_N_MONEDA
                 and f.r2pap = P_N_PAPEL
                 and r2cta = P_N_CUENTA
                 and r2oper = P_N_OPERACION
                 and f.r2sbop = P_N_SUBOPER
                 and f.r2tope = P_N_TIPOPER
                 and f.relcod = 33;
            exception
              when no_data_found then
                begin
                  select distinct s.jaqm34nom
                    into lc_abogado
                    from jaqm35 t
                    left join jaqm34 s
                      on s.jaqm34cod = t.jaqm34cod
                   inner join fsr011 f
                      on t.jaqm35pgco = f.r1cod
                     and t.jaqm35mod = f.r1mod
                     and t.jaqm35suc = f.r1suc
                     and t.jaqm35mda = f.r1mda
                     and t.jaqm35pap = f.r1pap
                     and t.jaqm35cta = f.r1cta
                     and t.jaqm35oper = f.r1oper
                     and t.jaqm35sbop = f.r1sbop
                     and t.jaqm35tope = f.r1tope
                     and t.jaqm35tcon = 'S'
                   where f.r1cod = P_N_PGCOD
                     and f.r2mod = P_N_MODULO
                     and f.r2suc = P_N_SUCURSAL
                     and f.r2mda = P_N_MONEDA
                     and f.r2pap = P_N_PAPEL
                     and r2cta = P_N_CUENTA
                     and r2oper = P_N_OPERACION
                     and f.r2sbop = P_N_SUBOPER
                     and f.r2tope = P_N_TIPOPER
                     and f.relcod = 36;
                
                EXCEPTION
                  when others then
                    /*lc_coderr := sqlcode;
                    lc_msgerr := sqlerrm;*/
                    null;
                end;
              
              when others then
                /*lc_coderr := sqlcode;
                lc_msgerr := sqlerrm;*/
                null;
            end;
          when others then
            /*lc_coderr := sqlcode;
            lc_msgerr := sqlerrm;*/
            null;
        end;
      when no_data_found then
        /*lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;*/
        null;
      when others then
        /*lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;*/
        null;
    end;
  
  end sp_cr_abogado_1;

  --------------------------------------------------------------------------------------

  Procedure sp_cr_abog_dmda(pt_pgcod    in number,
                            pt_modu     in number,
                            pt_sucu     in number,
                            pt_moneda   in number,
                            pt_papel    in number,
                            pt_cnta     in number,
                            pt_operac   in number,
                            pt_sboper   in number,
                            pt_toper    in number,
                            pn_scstat   in number,
                            pf_asig     out date,
                            pc_abrev    out varchar2,
                            pf_deman    out date,
                            pf_pasajud  out date,
                            pf_trancart out date)
  --******************************************************************************************************
    -- Nombre                     : sp_cr_abog_dmda
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     :
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2014.03.05
    -- Autor de Creaci¿n          : SFERNANDEM
    -- Uso                        : Retorna  las iniciales del abogado y la fecha de demanda
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : pk_credito,
    -- Par¿metros de Salida       : pf_asig: fecha de asiganacion, pc_abrev: iniciales del abogado
    --                              pf_deman: fecha de demanda
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ********************************************************************************************************
   is
    lc_coderr varchar2(500);
    lc_msgerr varchar2(500);
    --JAQM35PgCo fsr011.r1cod%type;
    --JAQM35Mod  fsr011.R1mod%type;
    --JAQM35Suc  fsr011.R1suc%type;
    --JAQM35Mda  fsr011.R1mda%type;
    --JAQM35Pap  fsr011.R1pap%type;
    --JAQM35Cta  fsr011.R1cta%type;
    --JAQM35Oper fsr011.R1oper%type;
    --JAQM35Sbop fsr011.R1sbop%type;
    --JAQM35Tope fsr011.R1tope%type;
    --estado_cre fsd010.aostat%type;
  
    ln_Pgcod  fsr011.r1cod%type;
    ln_R1mod  fsr011.R1mod%type;
    ln_R1suc  fsr011.R1suc%type;
    ln_R1mda  fsr011.R1mda%type;
    ln_R1pap  fsr011.R1pap%type;
    ln_R1cta  fsr011.R1cta%type;
    ln_R1oper fsr011.R1oper%type;
    ln_R1sbop fsr011.R1sbop%type;
    ln_R1tope fsr011.R1tope%type;
  
    --ln_Pgcod2 fsr011.r2cod%type;
    --ln_R2mod  fsr011.R2mod%type;
    --ln_R2suc  fsr011.R2suc%type;
    --ln_R2mda  fsr011.R2mda%type;
    --ln_R2pap  fsr011.R2pap%type;
    --ln_R2cta  fsr011.R2cta%type;
    --ln_R2oper fsr011.R2oper%type;
    --ln_R2sbop fsr011.R2sbop%type;
    --ln_R2tope fsr011.R2tope%type;
  
    instancia xwf700.XWFPRCINS%type;
  begin
    pf_asig  := null;
    pc_abrev := null;
  
    --fecha de asignacion/ abrev de abogado
  
    /*begin 
    
       select distinct t.jaqm35tfec, s.jaqm34nom
        into pf_asig, pc_abrev
        from jaqm35 t
        left join jaqm34 s
        on  s.jaqm34cod = t.jaqm34cod
        where t.jaqm35pgco=pt_pgcod
        and t.jaqm35mda=pt_moneda
        and t.jaqm35pap=pt_papel
        and t.jaqm35cta=pt_cnta
        and t.jaqm35oper=pt_operac
        and t.jaqm35tcon='S'
        and (t.jaqm35corr,t.jaqm35sbop)in (
                  select max(t.jaqm35corr),max(t.jaqm35sbop)
                  from jaqm35 t
                  left join jaqm34 s
                  on  s.jaqm34cod = t.jaqm34cod
                  where t.jaqm35pgco=pt_pgcod
                  and t.jaqm35mda=pt_moneda
                  and t.jaqm35pap=pt_papel
                  and t.jaqm35cta=pt_cnta
                  and t.jaqm35oper=pt_operac
                   and t.jaqm35tcon='S'
          );
    
        exception
           WHEN TOO_MANY_ROWS THEN
             begin
               select t.jaqm35tfec, s.jaqm34nom
                into pf_asig, pc_abrev
                from jaqm35 t
                left join jaqm34 s
                on  s.jaqm34cod = t.jaqm34cod
                inner join fsd010 f
                    on  t.jaqm35pgco=f.pgcod
                    and t.jaqm35mod=f.aomod
                    and t.jaqm35suc=f.aosuc
                    and t.jaqm35mda=f.aomda
                    and t.jaqm35pap=f.aopap
                    and t.jaqm35cta=f.aocta
                    and t.jaqm35oper=f.aooper
                    and t.jaqm35sbop=f.aosbop
                    and t.jaqm35tope=f.aotope
    
                where t.jaqm35pgco=pt_pgcod
                and t.jaqm35mda=pt_moneda
                and t.jaqm35pap=pt_papel
                and t.jaqm35cta=pt_cnta
                and t.jaqm35oper=pt_operac
                and t.jaqm35tcon='S'
                and f.aostat<>99
                and (t.jaqm35corr,t.jaqm35sbop)in (
                          select max(t.jaqm35corr),max(t.jaqm35sbop)
                          from jaqm35 t
                          left join jaqm34 s
                          on  s.jaqm34cod = t.jaqm34cod
                          where t.jaqm35pgco=pt_pgcod
                          and t.jaqm35mda=pt_moneda
                          and t.jaqm35pap=pt_papel
                          and t.jaqm35cta=pt_cnta
                          and t.jaqm35oper=pt_operac
                           and t.jaqm35tcon='S'
                  );
                  exception
             when no_data_found then
               begin
    
                          select distinct t.jaqm35tfec, s.jaqm34nom
                            into pf_asig, pc_abrev
                              from jaqm35 t
                              left join jaqm34 s
                              on  s.jaqm34cod = t.jaqm34cod
                              inner join fsr011 f
                              on t.jaqm35pgco= f.r1cod
                              and t.jaqm35mod=f.r1mod
                              and t.jaqm35suc=f.r1suc
                              and t.jaqm35mda=f.r1mda
                              and t.jaqm35pap=f.r1pap
                              and t.jaqm35cta=f.r1cta
                              and t.jaqm35oper=f.r1oper
                              and t.jaqm35sbop=f.r1sbop
                              and t.jaqm35tope=f.r1tope
                              and t.jaqm35tcon='S'
                              where f.r1cod    =pt_pgcod
                                  and f.r2mod = pt_modu
                                 and f.r2suc  = pt_sucu
                                and f.r2mda   = pt_moneda
                                and f.r2pap   = pt_papel
                                and r2cta     = pt_cnta
                                and r2oper    = pt_operac
                                and f.r2sbop  = pt_sboper
                                and f.r2tope  = pt_toper
                                and f.relcod  =33        ;
              exception
              when no_data_found then
                     begin
                          select distinct t.jaqm35tfec, s.jaqm34nom
                            into pf_asig, pc_abrev
                              from jaqm35 t
                              left join jaqm34 s
                              on  s.jaqm34cod = t.jaqm34cod
                              inner join fsr011 f
                              on t.jaqm35pgco= f.r1cod
                              and t.jaqm35mod=f.r1mod
                              and t.jaqm35suc=f.r1suc
                              and t.jaqm35mda=f.r1mda
                              and t.jaqm35pap=f.r1pap
                              and t.jaqm35cta=f.r1cta
                              and t.jaqm35oper=f.r1oper
                              and t.jaqm35sbop=f.r1sbop
                              and t.jaqm35tope=f.r1tope
                              and t.jaqm35tcon='S'
                              where f.r1cod    =pt_pgcod
                                 and  f.r2mod  =pt_modu
                                 and f.r2suc   =pt_sucu
                                and f.r2mda    =pt_moneda
                                and f.r2pap    =pt_papel
                                and r2cta      =pt_cnta
                                and r2oper     =pt_operac
                                and f.r2sbop   =pt_sboper
                                and f.r2tope   =pt_toper
                                and f.relcod=36 ;
    
                     EXCEPTION
                        when others then
                             lc_coderr := sqlcode;
                             lc_msgerr := sqlerrm;
    
                     end;
    
               when others then
                             lc_coderr := sqlcode;
                             lc_msgerr := sqlerrm;
               end;
             when others then
               lc_coderr := sqlcode;
               lc_msgerr := sqlerrm;
             end;
           when no_data_found then
             lc_coderr := sqlcode;
             lc_msgerr := sqlerrm;
           when others then
             lc_coderr := sqlcode;
             lc_msgerr := sqlerrm;
    end;
    */
  
    --fecha demanda /pasaje a judicial
    If pt_modu <> 117 then
      BEGIN
        select m.jaqm33fint --fecha de demanda
          into pf_deman
          from jaqm27 t
         inner join jaqm33 m
            on t.jaqm33cor = m.jaqm33cor
         Where JAQM27Pgc = pt_pgcod
           and JAQM27Mod = pt_modu
           and JAQM27Suc = pt_sucu
           and JAQM27Mda = pt_moneda
           and JAQM27Pap = pt_papel
           and JAQM27Cta = pt_cnta
           and JAQM27Oper = pt_operac
           and JAQM27Sbop = pt_sboper
           and JAQM27Tope = pt_toper
           and jaqm33fint <> to_date('01/01/0001', 'dd/mm/rrrr');
      exception
        when no_data_found then
          begin
            select distinct m.jaqm33fint --fecha de demanda
              into pf_deman
              from jaqm27 t
             inner join jaqm33 m
                on t.jaqm33cor = m.jaqm33cor
             inner join fsr011 f
                on JAQM27Pgc = r1cod
               and JAQM27Mod = r2mod
               and JAQM27Suc = r2suc
               and JAQM27Mda = r2mda
               and JAQM27Pap = r2pap
               and JAQM27Cta = r2cta
               and JAQM27Oper = r2oper
               and JAQM27Sbop = r2sbop
               and JAQM27Tope = r2tope
             where relcod = 34
               and r1mod = pt_modu
               and r1suc = pt_sucu
               and r1mda = pt_moneda
               and r1pap = pt_papel
               and r1cta = pt_cnta
               and r1oper = pt_operac
               and r1sbop = pt_sboper
               and r1tope = pt_toper
               and jaqm33fint <> to_date('01/01/0001', 'dd/mm/rrrr');
          exception
            when no_data_found then
              begin
                select distinct m.jaqm33fint --fecha de demanda
                  into pf_deman
                  from jaqm27 t
                 inner join jaqm33 m
                    on t.jaqm33cor = m.jaqm33cor
                 Where JAQM27Pgc = pt_pgcod
                   and JAQM27Mda = pt_moneda
                   and JAQM27Pap = pt_papel
                   and JAQM27Cta = pt_cnta
                   and JAQM27Oper = pt_operac
                   and jaqm33fint <> to_date('01/01/0001', 'dd/mm/rrrr');
              EXCEPTION
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
                
              end;
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
          end;
        
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
      end;
    Else
    
      BEGIN
        select r1cod,
               R1mod,
               R1suc,
               R1mda,
               R1pap,
               R1cta,
               R1oper,
               R1sbop,
               R1tope
          into ln_Pgcod,
               ln_R1mod,
               ln_R1suc,
               ln_R1mda,
               ln_R1pap,
               ln_R1cta,
               ln_R1oper,
               ln_R1sbop,
               ln_R1tope
          from (select r1cod,
                       R1mod,
                       R1suc,
                       R1mda,
                       R1pap,
                       R1cta,
                       R1oper,
                       R1sbop,
                       R1tope
                  from FSR011 f
                 inner join fsd010 f10
                    on f10.Pgcod = f.r1cod
                   and f10.aomod = f.R1mod
                   and f10.aosuc = f.R1suc
                   and f10.aomda = f.R1mda
                   and f10.aopap = f.R1pap
                   and f10.aocta = f.R1cta
                   and f10.aooper = f.R1oper
                   and f10.aosbop = f.R1sbop
                   and f10.aotope = f.R1tope
                 Where f.R2cod = pt_pgcod
                   and f.R2mod = pt_modu
                   and f.R2suc = pt_sucu
                   and f.R2mda = pt_moneda
                   and f.R2pap = pt_papel
                   and f.R2cta = pt_cnta
                   and f.R2oper = pt_operac
                   and f.R2sbop = pt_sboper
                   and f.R2tope = pt_toper
                   and f.Relcod = 46
                   and f.R011co = 'S'
                   and f.r1mod = 200
                 order by R2cod,
                          R2mod,
                          R2suc,
                          R2mda,
                          R2pap,
                          R2cta,
                          R2oper,
                          R2sbop,
                          R2tope,
                          Relcod asc) ff
         where rownum = 1;
      
      exception
        when no_data_found then
          begin
            select r1cod,
                   R1mod,
                   R1suc,
                   R1mda,
                   R1pap,
                   R1cta,
                   R1oper,
                   R1sbop,
                   R1tope
              into ln_Pgcod,
                   ln_R1mod,
                   ln_R1suc,
                   ln_R1mda,
                   ln_R1pap,
                   ln_R1cta,
                   ln_R1oper,
                   ln_R1sbop,
                   ln_R1tope
              from (select r1cod,
                           R1mod,
                           R1suc,
                           R1mda,
                           R1pap,
                           R1cta,
                           R1oper,
                           R1sbop,
                           R1tope
                      from FSR011 f
                     inner join fsd010 f10
                        on f10.Pgcod = f.r1cod
                       and f10.aomod = f.R1mod
                       and f10.aosuc = f.R1suc
                       and f10.aomda = f.R1mda
                       and f10.aopap = f.R1pap
                       and f10.aocta = f.R1cta
                       and f10.aooper = f.R1oper
                       and f10.aosbop = f.R1sbop
                       and f10.aotope = f.R1tope
                     Where f.R2cod = pt_pgcod
                       and f.R2mod = pt_modu
                       and f.R2suc = pt_sucu
                       and f.R2mda = pt_moneda
                       and f.R2pap = pt_papel
                       and f.R2cta = pt_cnta
                       and f.R2oper = pt_operac
                       and f.R2sbop = pt_sboper
                       and f.R2tope = pt_toper
                       and f.Relcod = 46
                       and f.R011co = 'S'
                       and f.r1mod <> 200
                     order by R2cod,
                              R2mod,
                              R2suc,
                              R2mda,
                              R2pap,
                              R2cta,
                              R2oper,
                              R2sbop,
                              R2tope,
                              Relcod desc) ff
             where rownum = 1;
          exception
            when no_data_found then
              BEGIN
                select XWFPRCINS
                  into instancia
                  from XWF700
                 Where XWfEmpresa = pt_pgcod
                   and XWfSucursal = pt_modu
                   and XWfModulo = pt_sucu
                   and XWfMoneda = pt_moneda
                   and XWfPapel = pt_papel
                   and XWfCuenta = pt_cnta
                   and XWfOperacion = pt_operac
                   and XWfSubope = pt_sboper
                   and XWfTipOpe = pt_toper
                   and XWFCar3 = 'A';
                BEGIN
                  select R1mod,
                         R1suc,
                         R1mda,
                         R1pap,
                         R1cta,
                         R1oper,
                         R1sbop,
                         R1tope
                    into ln_R1mod,
                         ln_R1suc,
                         ln_R1mda,
                         ln_R1pap,
                         ln_R1cta,
                         ln_R1oper,
                         ln_R1sbop,
                         ln_R1tope
                    from (select R1mod,
                                 R1suc,
                                 R1mda,
                                 R1pap,
                                 R1cta,
                                 R1oper,
                                 R1sbop,
                                 R1tope
                            from XWF700 x
                           inner join FSR011 f
                              on R2cod = x.xwfempresa
                             and R2mod = XWfModulo
                             and R2suc = XWfSucursal
                             and R2mda = XWfMoneda
                             and R2pap = XWfPapel
                             and R2cta = XWfCuenta
                             and R2oper = XWfOperacion
                             and R2sbop = XWfSubope
                             and R2tope = XWfTipOpe
                           Where f.Relcod = 46
                             and f.R011co = 'S'
                             and x.XWFCar3 = '1'
                             and x.XWFPRCINS = instancia
                             and f.r1mod = 200
                           order by R2cod,
                                    R2mod,
                                    R2suc,
                                    R2mda,
                                    R2pap,
                                    R2cta,
                                    R2oper,
                                    R2sbop,
                                    R2tope,
                                    Relcod)
                   where rownum = 1;
                EXCEPTION
                  WHEN no_data_found THEN
                    BEGIN
                      select R1mod,
                             R1suc,
                             R1mda,
                             R1pap,
                             R1cta,
                             R1oper,
                             R1sbop,
                             R1tope
                        into ln_R1mod,
                             ln_R1suc,
                             ln_R1mda,
                             ln_R1pap,
                             ln_R1cta,
                             ln_R1oper,
                             ln_R1sbop,
                             ln_R1tope
                        from (select R1mod,
                                     R1suc,
                                     R1mda,
                                     R1pap,
                                     R1cta,
                                     R1oper,
                                     R1sbop,
                                     R1tope
                                from XWF700 x
                               inner join FSR011 f
                                  on R2cod = x.xwfempresa
                                 and R2mod = XWfModulo
                                 and R2suc = XWfSucursal
                                 and R2mda = XWfMoneda
                                 and R2pap = XWfPapel
                                 and R2cta = XWfCuenta
                                 and R2oper = XWfOperacion
                                 and R2sbop = XWfSubope
                                 and R2tope = XWfTipOpe
                               Where f.Relcod = 46
                                 and f.R011co = 'S'
                                 and x.XWFCar3 = '1'
                                 and x.XWFPRCINS = instancia
                                 and f.r1mod <> 200
                               order by R2cod,
                                        R2mod,
                                        R2suc,
                                        R2mda,
                                        R2pap,
                                        R2cta,
                                        R2oper,
                                        R2sbop,
                                        R2tope,
                                        Relcod desc)
                       where rownum = 1;
                    EXCEPTION
                      when others then
                        lc_coderr := sqlcode;
                        lc_msgerr := sqlerrm;
                      
                    END;
                END;
              
              EXCEPTION
                when others then
                  lc_coderr := sqlcode;
                  lc_msgerr := sqlerrm;
              END;
            when others then
              lc_coderr := sqlcode;
              lc_msgerr := sqlerrm;
            
          END;
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
      END;
    
      BEGIN
        select m.jaqm33fint --fecha de demanda
          into pf_deman
          from jaqm27 t
         inner join jaqm33 m
            on t.jaqm33cor = m.jaqm33cor
         Where JAQM27Pgc = ln_Pgcod
           and JAQM27Mod = ln_R1mod
           and JAQM27Suc = ln_R1suc
           and JAQM27Mda = ln_R1mda
           and JAQM27Pap = ln_R1pap
           and JAQM27Cta = ln_R1cta
           and JAQM27Oper = ln_R1oper;
      
      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
      end;
    End if;
    Begin
      select max(sng419fect)
        into pf_trancart
        from sng419 s
       where s.sng419acc = 4
         and s.sng419cta = pt_cnta
         and s.sng419ope = pt_operac;
    EXCEPTION
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
    End;
  end sp_cr_abog_dmda;

  ----------------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------------------
  Procedure sp_cr_garantia(P_N_INI in NUMBER, P_N_FIN in NUMBER) is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualiza
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Actualiza campos de tabla jaql964
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 2014.01.03
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: Se modifico actualizacion lc_analista
    --
    -- ***************************************************************** 
  
    cursor cartera(P_N_INI in number, P_N_FIN in number) is
      select /*+parallel (j,2,1)*/ --jflor 23.01.2014
       j.jaql964cta,
       j.jaql964mod,
       j.jaql964ope,
       j.jaql964sob,
       j.jaql964top,
       j.jaql964suc,
       j.jaql964mda,
       j.jaql964usu,
       j.jaql964doc,
       jaql964csb,
       jaql964cor,
       jaql964pap,
       jaql964est
        from jaql964 j /*where j.jaql964cta=158708;*/
       where j.jaql964cor >= P_N_INI
         and j.jaql964cor <= P_N_FIN;
  
    TYPE Tp_jaql964mod IS TABLE OF jaql964.jaql964mod%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cta IS TABLE OF jaql964.jaql964cta%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964ope IS TABLE OF jaql964.jaql964ope%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964sob IS TABLE OF jaql964.jaql964sob%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964top IS TABLE OF jaql964.jaql964top%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964suc IS TABLE OF jaql964.jaql964suc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964mda IS TABLE OF jaql964.jaql964mda%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964usu IS TABLE OF jaql964.jaql964usu%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964doc IS TABLE OF jaql964.jaql964doc%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964csb IS TABLE OF jaql964.jaql964csb%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964cor IS TABLE OF jaql964.jaql964cor%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964pap IS TABLE OF jaql964.jaql964pap%TYPE INDEX BY PLS_INTEGER;
    TYPE Tp_jaql964est IS TABLE OF jaql964.jaql964est%TYPE INDEX BY PLS_INTEGER;
  
    jaql964mod Tp_jaql964mod;
    jaql964cta Tp_jaql964cta;
    jaql964ope Tp_jaql964ope;
    jaql964sob Tp_jaql964sob;
    jaql964top Tp_jaql964top;
    jaql964suc Tp_jaql964suc;
    jaql964mda Tp_jaql964mda;
    jaql964usu Tp_jaql964usu;
    jaql964doc Tp_jaql964doc;
    jaql964csb Tp_jaql964csb;
    jaql964cor Tp_jaql964cor;
    jaql964pap Tp_jaql964pap;
    jaql964est Tp_jaql964est;
  
    --lc_tipocontable varchar2(20);
    --lc_abogado      varchar2(50);
    lc_garantia varchar2(300);
    --ln_monto        number := 0;
    --lc_telefo       varchar2(20);
    --lc_direc        varchar2(150);
    --lc_distri       varchar2(50);
    --lc_analista     varchar2(30);
    --ln_numero       number := 0;
    --lc_tipcon       varchar2(30);
    --lc_bcgpo        number(4);
    --lc_produc       varchar2(30);
    --lc_tipocre      varchar2(30);
    --lc_credito      varchar2(20);
    --lc_refer        varchar2(200);
    --ln_instancia    number(10);
    ln_corr number := 0;
    --ln_sector       number := 0;
    --ln_tipsbs       number := 0;
    --ln_pgcod        number := 1;
  
    --ln_papel    number := 0;
    --pf_asig     date;
    --pc_abrev    varchar2(50);
    --pf_deman    date;
    --pf_pasajud  date;
    --pf_trancart date;
  
    /* lc_telava fsr005.dotelfp%TYPE;
    ln_ctaava fsd011.sccta%TYPE;
    lc_nomava fsd001.penom%TYPE;
    lc_dirava varchar2(180);*/
  
  begin
  
    OPEN cartera(P_N_INI, P_N_FIN);
    LOOP
      FETCH cartera BULK COLLECT
        INTO jaql964cta,
             jaql964mod,
             jaql964ope,
             jaql964sob,
             jaql964top,
             jaql964suc,
             jaql964mda,
             jaql964usu,
             jaql964doc,
             jaql964csb,
             jaql964cor,
             jaql964pap,
             jaql964est;
      IF jaql964cta.COUNT > 0 THEN
        FOR i IN jaql964cta.FIRST .. jaql964cta.LAST LOOP
        
          begin
            --garantia
            lc_garantia := pq_cr_jaql964_cartera.fn_cr_garantia(jaql964mod(i),
                                                                jaql964cta(i),
                                                                jaql964ope(i),
                                                                jaql964sob(i),
                                                                jaql964top(i),
                                                                jaql964suc(i),
                                                                jaql964mda(i));
          
          end;
        
          update jaql964
             set jaql964gar = lc_garantia
          
           where jaql964cor = jaql964cor(i);
          --and jaql964ope = jaql964ope(i);
        
          ln_corr := ln_corr + 1;
          /*if ln_corr = 5000 then
             commit;
             ln_corr := 0;
          end if; */
          commit;
        
        END LOOP;
      END IF;
      EXIT WHEN cartera%NOTFOUND;
    END LOOP;
    COMMIT;
  
  end sp_cr_garantia;

  ----------------------------------------------------------------------

  procedure sp_cr_job_garantia(P_D_FECPRO in date) is
    --2023.11.07 se modifico numero de jobs, se agregó guia tp1cod1 = 10847 tp1corr1 = 9999  
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
    lc_hostname varchar2(64);
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    begin
      select TP1IMP1
        into ln_divisor
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 9999
         and TP1CORR2 = 1;
    exception
      when others then
        ln_divisor := 5000;
    end;
  
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL964',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaql964;
    end;
  
    ln_ini := 1;
    ln_fin := ln_divisor; ---2023.11.07 se modifico inicial 5000
  
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' || '  pq_cr_jaql964_cartera.sp_cr_garantia(' ||
                     'TO_DATE(''' || lc_fecpro || ''',''RRRR.MM.DD'')' || ',' ||
                     ln_ini || ',' || ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
      --      if UPPER(lc_hostname) in ('BTRAC2051', 'BTRAC2052') then
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
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
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  
  end sp_cr_job_garantia;

  ----------------------------------------------------------------------
  procedure UpdateCampos_JAQL964(P_N_INSTANCIA    in number,
                                 P_N_MONEDA       in number,
                                 P_N_CUENTA       in number,
                                 P_N_OPERACION    in number,
                                 P_N_SUCURSAL     in number,
                                 P_N_SUBOPER      in number,
                                 P_N_TIPOPER      in number,
                                 P_N_MODULO       in number,
                                 P_N_ESTADO       in number,
                                 P_N_JAQL964FIRL  out varchar2,
                                 P_N_JAQL964FAABO out varchar2,
                                 P_N_JAQL964FEJUD out varchar2,
                                 P_N_JAQL964FDES  out varchar2,
                                 P_N_MONT_APROB   out number,
                                 P_C_ABOGADO      out varchar2,
                                 P_N_PLAZO        out number) is
  
    ld_fechenvjudic    date;
    ld_fechasigabogado date;
    ld_firl            date;
    ld_fecha           date;
    monto_aprobado     number;
    ln_plazo           number;
  
  begin
  
    BEGIN
      select g4.sng410fecg
        into ld_firl
        from sng410 g4
       where g4.sng410inst = P_N_INSTANCIA
         AND g4.sng410mda = P_N_MONEDA
         and g4.sng410pap = 0
         and g4.sng410cta = P_N_CUENTA
         and g4.sng410op = P_N_OPERACION
         and g4.sng400evto in (1101, 1100)
         and g4.sng410its <> 999;
    exception
      when others then
        NULL;
      
        if ld_firl is null then
          BEGIN
            select max(g4.sng410fecg) -- 2015.07
              into ld_firl
              from sng410 g4
             where g4.sng410mda = P_N_MONEDA
               and g4.sng410pap = 0
               and g4.sng410cta = P_N_CUENTA
               and g4.sng410op = P_N_OPERACION
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
                 and y514.jaqy514mda = P_N_MONEDA
                 and y514.jaqy514suc = P_N_SUCURSAL
                 and y514.jaqy514cta = P_N_CUENTA
                 and y514.jaqy514ope = P_N_OPERACION
                 and y514.jaqy514evt in (1101, 1100)
                 and y514.jaqy514its <> 999;
            exception
              when others then
                NULL;
              
            end;
          end if;
        
        end if;
      
    end;
  
    --2015.07.31   
    /*Begin
       select m35.jaqm35tfec into ld_fechasigabogado from jaqm35 m35
        where m35.jaqm35pgco = 1
          and m35.jaqm35mda = P_N_MONEDA
          and m35.jaqm35pap = 0
          and m35.jaqm35cta = P_N_CUENTA
          and m35.jaqm35suc = P_N_SUCURSAL
          and m35.jaqm35oper = P_N_OPERACION
          and m35.jaqm35mod = P_N_MODULO
          AND (JAQM35TCon = 'S');
          exception when others then NULL;
    
    END; */
    begin
      pq_cr_jaql964_cartera.sp_cr_abogado(p_n_pgcod     => 1,
                                          p_n_moneda    => p_n_moneda,
                                          p_n_papel     => 0,
                                          p_n_cuenta    => p_n_cuenta,
                                          p_n_operacion => p_n_operacion,
                                          p_n_modulo    => p_n_modulo,
                                          p_n_sucursal  => p_n_sucursal,
                                          p_n_suboper   => p_n_suboper,
                                          p_n_tipoper   => p_n_tipoper,
                                          P_N_ESTADO    => P_N_ESTADO,
                                          p_c_abogado   => p_c_abogado,
                                          pf_asig       => ld_fechasigabogado);
    exception
      when others then
        NULL;
    end;
    --2015.07.31
  
    begin
      select m33.JAQM33FDem
        into ld_fechenvjudic
        from jaqm27 m27
        left join jaqm33 m33
          on m33.jaqm33cor = m27.jaqm33cor
       where m27.jaqm27pgc = 1
         and m27.jaqm27mda = P_N_MONEDA
         and m27.jaqm27pap = 0
         and m27.jaqm27suc = P_N_SUCURSAL
         and m27.jaqm27cta = P_N_CUENTA
         and m27.jaqm27oper = P_N_OPERACION;
    exception
      when others then
        NULL;
      
    end;
  
    BEGIN
      select d010.aofval, d010.aoimp, d010.aopzo
        into ld_fecha, monto_aprobado, ln_plazo
        from fsd010 d010
       inner join fst111 f
          on d010.aomod = f.modulo
       where f.dscod = 50
         and d010.pgcod = 1
         and d010.aomda = P_N_MONEDA
         and d010.aocta = P_N_CUENTA
         and d010.aooper = P_N_OPERACION
         and d010.aosuc = P_N_SUCURSAL
         and d010.aosbop = (select min(d.aosbop)
                              from fsd010 d
                             where d.pgcod = 1
                               and d.aomda = P_N_MONEDA
                               and d.aocta = P_N_CUENTA
                               and d.aooper = P_N_OPERACION
                               and d.aosuc = P_N_SUCURSAL);
    exception
      when others then
        NULL;
    END;
  
    P_N_JAQL964FIRL  := to_char(ld_firl, 'yyyy.mm.dd');
    P_N_JAQL964FAABO := to_char(ld_fechasigabogado, 'yyyy.mm.dd');
    P_N_JAQL964FEJUD := to_char(ld_fechenvjudic, 'yyyy.mm.dd');
    P_N_JAQL964FDES  := to_char(ld_fecha, 'yyyy.mm.dd');
    P_N_MONT_APROB   := monto_aprobado;
    P_N_PLAZO        := (ln_plazo / 30);
  
    --P_C_ABOGADO := p_c_abogado;
  
  end UpdateCampos_JAQL964;

  ----------------------------------------------------------------------------------------
  /*
  function UpdateCampos_JAQL964 (P_N_INSTANCIA in number,
                                  P_N_MONEDA in number, 
                                  P_N_CUENTA in number, 
                                  P_N_OPERACION in number, 
                                  P_N_SUCURSAL in number,
                                  P_N_SUBOPER in number,
                                  P_N_TIPOPER in number,
                                  P_N_MODULO in number
                                   ) return  date  is
   
    ld_fechenvjudic date;
    ld_fechasigabogado date;
    ld_firl date;
    ld_fecha date;
    monto_aprobado number;
    P_N_JAQL964FIRL date;
  
  begin
  
     BEGIN
      select g4.sng410fecg    
        into ld_firl    
        from sng410 g4
       where g4.sng410inst = P_N_INSTANCIA
         AND g4.sng410mda = P_N_MONEDA
         and g4.sng410pap = 0
         and g4.sng410cta = P_N_CUENTA
         and g4.sng410op = P_N_OPERACION
         and g4.sng400evto in (1101, 1100)
         and g4.sng410its <> 999;
         exception when others then NULL;
         
         if ld_firl is null then
         BEGIN
            select g4.sng410fecg
              into ld_firl
              from sng410 g4
             where g4.sng410mda = P_N_MONEDA
               and g4.sng410pap = 0
               and g4.sng410cta = P_N_CUENTA
               and g4.sng410op = P_N_OPERACION
               and g4.sng400evto in (1101, 1100)
               and g4.sng410its <> 999;
            exception when others then NULL;
          end;
         
         end if;
         
      end;
     
      Begin
         select m35.jaqm35tfec into ld_fechasigabogado from jaqm35 m35
          where m35.jaqm35pgco = 1
            and m35.jaqm35mda = P_N_MONEDA
            and m35.jaqm35pap = 0
            and m35.jaqm35cta = P_N_CUENTA
            and m35.jaqm35suc = P_N_SUCURSAL
            and m35.jaqm35oper = P_N_OPERACION
            and m35.jaqm35mod = P_N_MODULO
            AND (JAQM35TCon = 'S');
            exception when others then NULL;
      
      END; 
   
      begin
         select m33.JAQM33FDem
           into ld_fechenvjudic
           from jaqm27 m27
           left join jaqm33 m33 on m33.jaqm33cor = m27.jaqm33cor
          where m27.jaqm27pgc = 1
            and m27.jaqm27mda = P_N_MONEDA
            and m27.jaqm27pap = 0
            and m27.jaqm27suc = P_N_SUCURSAL
            and m27.jaqm27cta = P_N_CUENTA
            and m27.jaqm27oper = P_N_OPERACION;
         exception when others then NULL;
            
      end;
      
      BEGIN
             select d010.aofval, d010.aoimp
               into ld_fecha, monto_aprobado
               from fsd010 d010
              inner join fst111 f on d010.aomod = f.modulo
              where f.dscod = 50
                and d010.pgcod = 1
                and d010.aomda = P_N_MONEDA
                and d010.aocta = P_N_CUENTA
                and d010.aooper = P_N_OPERACION
                and d010.aosuc = P_N_SUCURSAL
                and d010.aosbop =
                    (select min(d.aosbop)
                       from fsd010 d
                      where d.pgcod = 1
                        and d.aomda = P_N_MONEDA
                        and d.aocta = P_N_CUENTA
                        and d.aooper = P_N_OPERACION
                        and d.aosuc = P_N_SUCURSAL);
             exception when others then NULL;
        END;
        
  --     P_N_JAQL964FIRL :=to_char(ld_firl,'yyyy.mm.dd');
        P_N_JAQL964FIRL :=ld_firl;
        return P_N_JAQL964FIRL;
       
    ---   P_N_JAQL964FAABO :=to_char(ld_fechasigabogado,'yyyy.mm.dd');
    ---   P_N_JAQL964FEJUD :=to_char(ld_fechenvjudic,'yyyy.mm.dd');
    ---   P_N_JAQL964FDES :=to_char(ld_fecha,'yyyy.mm.dd');
    ---   P_N_MONT_APROB := monto_aprobado;
    
  end UpdateCampos_JAQL964;
  
  */
  ----------------------------------------------------------------------------------------
  function fn_tipo_credito_desem(P_N_JAQL964PAI in number,
                                 P_N_JAQL964TID in number,
                                 P_N_JAQL964DOC in char,
                                 P_D_JAQL964FEC in date,
                                 P_N_JAQL964CTA in number) return number is
  
    ln_tipcre number;
  
    ----retorna
    --1 'CREDITO NUEVO'    
    --2 'CREDITO RECURRENTE'  
  
  begin
  
    begin
    
      select (case
               when count(*) = 0 then
                1
               else
                2
             end)
        into ln_tipcre
        from fsd010 des
       inner join fsr008 pers
          on pers.pgcod = des.pgcod
         and pers.ctnro = des.aocta
         and pers.ttcod = 1
         and pers.CTTFIR = 'T'
       where des.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120)
                           union all
                           select 117
                             from dual)
         and des.aomod <> 141
         and des.aomod <> 120 --prestamos pasivos        
         and pers.pepais = P_N_JAQL964PAI
         and pers.petdoc = P_N_JAQL964TID
         and pers.pendoc = P_N_JAQL964DOC
         and des.aofval < P_D_JAQL964FEC;
    
    exception
      when no_data_found then
        ln_tipcre := null;
    end;
  
    return ln_tipcre;
  
  end fn_tipo_credito_desem;

  ------------------------------------------

  procedure sp_cr_saldototal(pa_ppmod  in number,
                             pa_pgcod  in number,
                             pa_ppsuc  in number,
                             pa_ppmda  in number,
                             pa_pppap  in number,
                             pa_ppcta  in number,
                             pa_ppoper in number,
                             pa_ppsbop in number,
                             pa_pptope in number,
                             pn_captot out number, --CAPITALTOTAL
                             pn_inttot out number, --INTERESTOTAL
                             pn_mora   out number, --MORA
                             pn_intext out number, --INTERES EXTRACON
                             pn_gastos out number, -- GASTOS
                             pn_otros  out number, --OTROS
                             pn_totdeu out number --TOTALDEUDA
                             
                             ) is
  
    -- 2015.08.10 DCASTRO - Se modifico sp_cr_abogado, sp_cr_saldototal
    -- 2015.09.14 DCASTRO - Se modifico sp_cr_saldototal
  
    estado_602       varchar2(2);
    fecha_602        date;
    capital_601      number;
    interes_601      number;
    capital_602      number;
    interes_602      number;
    capital_estp     number;
    interes_estp     number;
    capital          number;
    interes          number;
    capital_estp_601 number;
    interes_estp_601 number;
  
    ln_gasto1     number;
    ln_gasto2     number;
    pn_otrospp003 number;
    pn_otrospp002 number;
  
  begin
  
    if pa_ppmod in (200, 33) or pa_pptope = 550 then
    
      begin
      
        SELECT
        --r.pgcod, r.scsuc, r.scmda, r.scpap, r.sccta, r.scoper, r.scsbop, r.sctope, R.SCMOD, R.SCRUB, 
         r.scsdo * -1 saldo_capital, --pn_captot
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.scmda = a.scmda
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and a.scrub in
                    (SELECT distinct /*+ parallel (b,4)*/ b.rrrubr
                       FROM fsr014 b
                      where b.rubro = r.scrub
                        and b.rrcod = 148)),
             0) * -1 interes_devengado, --pn_inttot
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and r.scsbop = a.scsbop
                and a.scrub in
                    (SELECT distinct /*+ parallel (b,4)*/ b.rrrubr
                       FROM fsr014 b
                      where b.rubro = r.scrub
                        and b.rrcod = 147)),
             0) * -1 interes_extracontable, --pn_intext
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and r.scsbop = a.scsbop
                and a.scrub in
                    (SELECT distinct /*+ parallel (b,4)*/ b.rrrubr
                       FROM fsr014 b
                      where b.rubro = r.scrub
                        and b.rrcod = 145)),
             0) * -1 mora, --pn_mora
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and r.scsbop = a.scsbop
                and a.scrub in
                    (SELECT distinct /*+ parallel (b,4)*/ b.rrrubr
                       FROM fsr014 b
                      where b.rubro = r.scrub
                        and b.rrcod = 136)),
             0) * -1 otros, --pn_otros
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and r.scsbop = a.scsbop
                and a.scrub in (SELECT /*+ parallel (b,4)*/
                                 b.rrrubr
                                  FROM fsr014 b
                                 where b.rubro = r.scrub
                                   and b.rrcod = 140)),
             0) * -1 comisiones, --ln_gasto1
         nvl((SELECT /*+parallel (a,4) */
              a.scsdo
               FROM fsd011 a
              where r.pgcod = a.pgcod
                and r.sccta = a.sccta
                and r.scoper = a.scoper
                and r.scsbop = a.scsbop
                and a.scrub in (SELECT /*+ parallel (b,4)*/
                                 b.rrrubr
                                  FROM fsr014 b
                                 where b.rubro = r.scrub
                                   and b.rrcod = 130)),
             0) * -1 Seguros -- ln_gasto2
        --r.scstat estado, t.aofvto fecha
          into pn_captot,
               pn_inttot,
               pn_intext,
               pn_mora,
               pn_otros,
               ln_gasto1,
               ln_gasto2
          FROM fsd010 t, fsd011 r
         where t.aocta = r.sccta
           and t.aooper = r.scoper
           and t.aotope = r.sctope
           and t.aomod = r.scmod
           and t.aosbop = r.scsbop
           and t.pgcod = pa_pgcod
           and t.aomod = pa_ppmod
           and t.aosuc = pa_ppsuc
           and t.aomda = pa_ppmda
           and t.aopap = pa_pppap
           and t.aocta = pa_ppcta
           and t.aooper = pa_ppoper
           and t.aosbop = pa_ppsbop
           and t.aotope = pa_pptope;
      exception
        when others then
          pn_captot := 0;
      end;
    
      if pn_captot < 0 then
        pn_captot := pn_captot * -1;
      end if;
      if pn_inttot < 0 then
        pn_inttot := pn_inttot * -1;
      end if;
      if pn_intext < 0 then
        pn_intext := pn_intext * -1;
      end if;
      if pn_mora < 0 then
        pn_mora := pn_mora * -1;
      end if;
      if pn_otros < 0 then
        pn_otros := pn_otros * -1;
      end if;
      if ln_gasto1 < 0 then
        ln_gasto1 := ln_gasto1 * -1;
      end if;
      if ln_gasto2 < 0 then
        ln_gasto2 := ln_gasto2 * -1;
      end if;
    
      pn_gastos := nvl(ln_gasto1, 0) + nvl(ln_gasto2, 0);
      pn_totdeu := nvl(pn_captot, 0) + nvl(pn_inttot, 0) +
                   nvl(pn_intext, 0) + nvl(pn_mora, 0) + nvl(pn_otros, 0) +
                   nvl(pn_gastos, 0);
    
    else
    
      --begin   
    
      begin
        select max(d602.pp1stat),
               d602.ppfpag,
               sum(d602.pp1cap),
               sum(d602.pp1int)
          into estado_602, fecha_602, capital_602, interes_602
          from fsd602 d602
         where d602.pgcod = pa_pgcod
           and d602.ppmod = pa_ppmod
           and d602.ppsuc = pa_ppsuc
           and d602.ppmda = pa_ppmda
           and d602.pppap = pa_pppap
           and d602.ppcta = pa_ppcta
           and d602.ppoper = pa_ppoper
           and d602.ppsbop = pa_ppsbop
           and d602.pptope = pa_pptope
           and d602.ppfpag = (select max(ppfpag)
                                from fsd602
                               where pgcod = pa_pgcod
                                 and ppmod = pa_ppmod
                                 and ppsuc = pa_ppsuc
                                 and ppmda = pa_ppmda
                                 and pppap = pa_pppap
                                 and ppcta = pa_ppcta
                                 and ppoper = pa_ppoper
                                 and ppsbop = pa_ppsbop
                                 and pptope = pa_pptope
                                 and d602co = 'S')
           and d602.d602co = 'S'
         group by d602.ppfpag;
      exception
        when others then
          NULL;
      end;
    
      if fecha_602 is null then
        -- 16/11/15 MPOSTIGOC
      
        begin
          select min(ppfpag)
            into fecha_602
            from fsd601 d601
           where d601.pgcod = pa_pgcod
             and d601.ppmod = pa_ppmod
             and d601.ppsuc = pa_ppsuc
             and d601.ppmda = pa_ppmda
             and d601.pppap = pa_pppap
             and d601.ppcta = pa_ppcta
             and d601.ppoper = pa_ppoper
             and d601.ppsbop = pa_ppsbop
             and d601.pptope = pa_pptope
             and d601.d601co = 'S';
        exception
          when too_many_rows then
            NULL;
          
        end;
      end if;
    
      begin
        select sum(pp002imp)
          into pn_otrospp002
          from fpp002
         where pgcod = pa_pgcod
           and ppmod = pa_ppmod
           and ppsuc = pa_ppsuc
           and ppmda = pa_ppmda
           and pppap = pa_pppap
           and ppcta = pa_ppcta
           and ppoper = pa_ppoper
           and ppsbop = pa_ppsbop
           and pptope = pa_pptope
           and ppfpag >= fecha_602; -- 09/11/15 mpostigoc
      exception
        when others then
          pn_otrospp002 := 0;
      end;
    
      begin
        -- 09/11/15 mpostigoc
        select sum(pp003imp)
          into pn_otrospp003
          from fpp003 p3
         where p3.pgcod = pa_pgcod
           and p3.ppmod = pa_ppmod
           and p3.ppsuc = pa_ppsuc
           and p3.ppmda = pa_ppmda
           and p3.pppap = pa_pppap
           and p3.ppcta = pa_ppcta
           and p3.ppoper = pa_ppoper
           and p3.ppsbop = pa_ppsbop
           and p3.pptope = pa_pptope
           and p3.prestconc <> 3 -- 3 penalidad
           and p3.ppfpag = fecha_602;
      
      exception
        when others then
          pn_otrospp003 := 0;
      end;
    
      pn_otros := nvl(pn_otrospp002, 0) - nvl(pn_otrospp003, 0); -- 09/11/15 mpostigoc
    
      if estado_602 = 'T' then
      
        begin
          select sum(d601.ppcap), sum(d601.ppint)
            into capital_601, interes_601
            from fsd601 d601
           where d601.pgcod = pa_pgcod
             and d601.ppmod = pa_ppmod
             and d601.ppsuc = pa_ppsuc
             and d601.ppmda = pa_ppmda
             and d601.pppap = pa_pppap
             and d601.ppcta = pa_ppcta
             and d601.ppoper = pa_ppoper
             and d601.ppsbop = pa_ppsbop
             and d601.pptope = pa_pptope
             and d601.ppfpag > fecha_602
             and d601.d601co = 'S';
        exception
          when others then
            capital_601 := 0;
            interes_601 := 0;
        end;
      end if;
    
      if estado_602 = 'P' then
      
        begin
          select d601.ppcap, d601.ppint
            into capital_estp, interes_estp
            from fsd601 d601
           where d601.pgcod = pa_pgcod
             and d601.ppmod = pa_ppmod
             and d601.ppsuc = pa_ppsuc
             and d601.ppmda = pa_ppmda
             and d601.pppap = pa_pppap
             and d601.ppcta = pa_ppcta
             and d601.ppoper = pa_ppoper
             and d601.ppsbop = pa_ppsbop
             and d601.pptope = pa_pptope
             and d601.ppfpag = fecha_602
             and d601.d601co = 'S';
        exception
          when others then
            capital_estp := 0;
            interes_estp := 0;
        end;
      
        capital := nvl(capital_estp, 0) - nvl(capital_602, 0);
        interes := nvl(interes_estp, 0) - nvl(interes_602, 0);
      
        begin
          select sum(d601.ppcap), sum(d601.ppint)
            into capital_estp_601, interes_estp_601
            from fsd601 d601
           where d601.pgcod = pa_pgcod
             and d601.ppmod = pa_ppmod
             and d601.ppsuc = pa_ppsuc
             and d601.ppmda = pa_ppmda
             and d601.pppap = pa_pppap
             and d601.ppcta = pa_ppcta
             and d601.ppoper = pa_ppoper
             and d601.ppsbop = pa_ppsbop
             and d601.pptope = pa_pptope
             and d601.ppfpag > fecha_602
             and d601.d601co = 'S';
        exception
          when others then
            NULL;
        end;
      
        capital_601 := nvl(capital, 0) + nvl(capital_estp_601, 0);
        interes_601 := nvl(interes, 0) + nvl(interes_estp_601, 0);
      
        if capital_estp_601 is null then
          capital_601 := capital;
          interes_601 := interes;
        end if;
      
      end if;
    
      if estado_602 is null then
      
        begin
          select sum(d601.ppcap), sum(d601.ppint)
            into capital_601, interes_601
            from fsd601 d601
           where d601.pgcod = pa_pgcod
             and d601.ppmod = pa_ppmod
             and d601.ppsuc = pa_ppsuc
             and d601.ppmda = pa_ppmda
             and d601.pppap = pa_pppap
             and d601.ppcta = pa_ppcta
             and d601.ppoper = pa_ppoper
             and d601.ppsbop = pa_ppsbop
             and d601.pptope = pa_pptope
             and d601.d601co = 'S';
        
        exception
          when others then
            capital_601 := 0;
            interes_601 := 0;
        end;
      
      end if;
    
      --mora
      begin
        select j.jaql964mor
          into pn_mora
          from jaql964 j
         where j.jaql964cta = pa_ppcta
           and j.jaql964ope = pa_ppoper
           and j.jaql964sob = pa_ppsbop
           and j.jaql964top = pa_pptope
           and rownum < 2;
      exception
        when others then
          pn_mora := 0;
        
      end;
    
      pn_captot := nvl(capital_601, 0);
      pn_inttot := nvl(interes_601, 0);
    
      pn_totdeu := nvl(capital_601, 0) + nvl(interes_601, 0) +
                   nvl(pn_otros, 0) + nvl(pn_mora, 0);
    
    end if;
  
  end sp_cr_saldototal;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_abogado(P_N_PGCOD     in number,
                          P_N_MONEDA    in number,
                          P_N_PAPEL     in number,
                          P_N_CUENTA    in number,
                          P_N_OPERACION in number,
                          P_N_MODULO    in number,
                          P_N_SUCURSAL  in number,
                          P_N_SUBOPER   in number,
                          P_N_TIPOPER   in number,
                          P_N_ESTADO    in number,
                          P_C_ABOGADO   out varchar2,
                          pf_asig       out date)
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_abogado
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2013.09.02
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Abogado
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              P_N_TIPCAM
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --                              2015.08.10 DCASTRO - Se modifico sp_cr_aogado, sp_cr_saldototal
    --                              2015.08.18 DCASTRO - Se modifico agrego exception when no_data_found en jaqm35
    --                              2015.09.22 DCASTRO - SE comento variables suboperacion, tipooperacion
    --                              2015.09.29 DCASTRO - Se agrego consulta para otener abogado por soboepracion y tipooperacion
    -- ***************************************************************** 
   is
  
    --lc_abogado varchar2(50);
    --lc_coderr  varchar2(100);
    --lc_msgerr  varchar2(100);
    ln_modulo fsr011.r1mod%type;
    ln_cuenta fsr011.r1cta%type;
    ln_opera  fsr011.r1oper%type;
    ln_pgcod  fsr011.r1cod%type;
    ln_sucur  fsr011.r1suc%type;
    ln_moneda fsr011.r1mda%type;
    ln_pap    fsr011.r1pap%type;
    ln_tipope fsr011.r1tope%type;
    ln_subope fsr011.r1sbop%type;
    --ld_fecabo  date;
  
  begin
  
    if P_N_MODULO in (200, 33) then
    
      begin
        --Inicio Begin 1
        select distinct r1cod,
                        r1mod,
                        r1suc,
                        r1mda,
                        r1pap,
                        r1cta,
                        r1oper,
                        r1sbop,
                        r1tope
          into ln_pgcod,
               ln_modulo,
               ln_sucur,
               ln_moneda,
               ln_pap,
               ln_cuenta,
               ln_opera,
               ln_subope,
               ln_tipope
          from fsr011
         where r2mod = P_N_MODULO
           and r2cta = P_N_CUENTA
           and r2oper = P_N_OPERACION
           and r2sbop = P_N_SUBOPER
           and r2cod = P_N_PGCOD
           and r2suc = P_N_SUCURSAL
           and r2mda = P_N_MONEDA
           and r2pap = P_N_PAPEL
           and r2tope = P_N_TIPOPER
           and relcod = 34;
      
      exception
        when no_data_found then
          begin
            select distinct r2cod,
                            r2mod,
                            r2suc,
                            r2mda,
                            r2pap,
                            r2cta,
                            r2oper,
                            r2sbop,
                            r2tope
              into ln_pgcod,
                   ln_modulo,
                   ln_sucur,
                   ln_moneda,
                   ln_pap,
                   ln_cuenta,
                   ln_opera,
                   ln_subope,
                   ln_tipope
              from fsr011
             where r1mod = P_N_MODULO
               and r1cta = P_N_CUENTA
               and r1oper = P_N_OPERACION
               and r1sbop = P_N_SUBOPER
               and r1cod = P_N_PGCOD
               and r1suc = P_N_SUCURSAL
               and r1mda = P_N_MONEDA
               and r1pap = P_N_PAPEL
               and r1tope = P_N_TIPOPER
               and relcod = 33;
          exception
            when no_Data_found then
              begin
                select distinct r2cod,
                                r2mod,
                                r2suc,
                                r2mda,
                                r2pap,
                                r2cta,
                                r2oper,
                                r2sbop,
                                r2tope
                  into ln_pgcod,
                       ln_modulo,
                       ln_sucur,
                       ln_moneda,
                       ln_pap,
                       ln_cuenta,
                       ln_opera,
                       ln_subope,
                       ln_tipope
                  from fsr011
                 where r1mod = P_N_MODULO
                   and r1cta = P_N_CUENTA
                   and r1oper = P_N_OPERACION
                   and r1sbop = P_N_SUBOPER
                   and r1cod = P_N_PGCOD
                   and r1suc = P_N_SUCURSAL
                   and r1mda = P_N_MONEDA
                   and r1pap = P_N_PAPEL
                   and r1tope = P_N_TIPOPER
                   and relcod = 35;
              exception
                when others then
                  ln_cuenta := null;
              end;
            when others then
              ln_cuenta := null;
          end;
        when too_many_rows then
          Begin
            select distinct r1cod,
                            r1mod,
                            r1suc,
                            r1mda,
                            r1pap,
                            r1cta,
                            r1oper --, r1sbop, r1tope  
              into ln_pgcod,
                   ln_modulo,
                   ln_sucur,
                   ln_moneda,
                   ln_pap,
                   ln_cuenta,
                   ln_opera --, ln_subope, ln_tipope
              from fsr011
             where r2mod = P_N_MODULO
               and r2cta = P_N_CUENTA
               and r2oper = P_N_OPERACION
               and r2sbop = P_N_SUBOPER
               and r2cod = P_N_PGCOD
               and r2suc = P_N_SUCURSAL
               and r2mda = P_N_MONEDA
               and r2pap = P_N_PAPEL
               and r2tope = P_N_TIPOPER
               and relcod = 34;
          exception
            when others then
              ln_cuenta := null;
          end;
        
      end; --Fin Begin 1
    
    else
      begin
        --Inicio Begin 2
        select distinct r1cod,
                        r1mod,
                        r1suc,
                        r1mda,
                        r1pap,
                        r1cta,
                        r1oper,
                        r1sbop,
                        r1tope
          into ln_pgcod,
               ln_modulo,
               ln_sucur,
               ln_moneda,
               ln_pap,
               ln_cuenta,
               ln_opera,
               ln_subope,
               ln_tipope
          from fsr011
         where r2mod = P_N_MODULO
           and r2cta = P_N_CUENTA
           and r2oper = P_N_OPERACION
           and r2sbop = P_N_SUBOPER
           and r2cod = P_N_PGCOD
           and r2suc = P_N_SUCURSAL
           and r2mda = P_N_MONEDA
           and r2pap = P_N_PAPEL
           and r2tope = P_N_TIPOPER
           and relcod in (33, 34); --= 33;
      
      exception
        when no_data_found then
          ---A
          begin
            --
            select distinct r2cod,
                            r2mod,
                            r2suc,
                            r2mda,
                            r2pap,
                            r2cta,
                            r2oper,
                            r2sbop,
                            r2tope
              into ln_pgcod,
                   ln_modulo,
                   ln_sucur,
                   ln_moneda,
                   ln_pap,
                   ln_cuenta,
                   ln_opera,
                   ln_subope,
                   ln_tipope
              from fsr011
             where r1mod = P_N_MODULO
               and r1cta = P_N_CUENTA
               and r1oper = P_N_OPERACION
               and r1sbop = P_N_SUBOPER
               and r1cod = P_N_PGCOD
               and r1suc = P_N_SUCURSAL
               and r1mda = P_N_MONEDA
               and r1pap = P_N_PAPEL
               and r1tope = P_N_TIPOPER
               and relcod = 34;
          exception
            when no_Data_found then
              begin
                select distinct r2cod,
                                r2mod,
                                r2suc,
                                r2mda,
                                r2pap,
                                r2cta,
                                r2oper,
                                r2sbop,
                                r2tope
                  into ln_pgcod,
                       ln_modulo,
                       ln_sucur,
                       ln_moneda,
                       ln_pap,
                       ln_cuenta,
                       ln_opera,
                       ln_subope,
                       ln_tipope
                  from fsr011
                 where r1mod = P_N_MODULO
                   and r1cta = P_N_CUENTA
                   and r1oper = P_N_OPERACION
                   and r1sbop = P_N_SUBOPER
                   and r1cod = P_N_PGCOD
                   and r1suc = P_N_SUCURSAL
                   and r1mda = P_N_MONEDA
                   and r1pap = P_N_PAPEL
                   and r1tope = P_N_TIPOPER
                   and relcod = 35;
              exception
                when no_data_found then
                  ln_cuenta := null;
                when others then
                  begin
                    --Inicio Begin 3
                    select distinct r1cod,
                                    r1mod,
                                    r1suc,
                                    r1mda,
                                    r1pap,
                                    r1cta,
                                    r1oper,
                                    r1sbop,
                                    r1tope
                      into ln_pgcod,
                           ln_modulo,
                           ln_sucur,
                           ln_moneda,
                           ln_pap,
                           ln_cuenta,
                           ln_opera,
                           ln_subope,
                           ln_tipope
                      from fsr011
                     where r2mod = P_N_MODULO
                       and r2cta = P_N_CUENTA
                       and r2oper = P_N_OPERACION
                       and r2sbop = P_N_SUBOPER
                       and r2cod = P_N_PGCOD
                       and r2suc = P_N_SUCURSAL
                       and r2mda = P_N_MONEDA
                       and r2pap = P_N_PAPEL
                       and relcod = 34;
                  exception
                    when too_many_rows then
                      Begin
                        select distinct r1cod,
                                        r1mod,
                                        r1suc,
                                        r1mda,
                                        r1pap,
                                        r1cta,
                                        r1oper --, r1sbop, r1tope  
                          into ln_pgcod,
                               ln_modulo,
                               ln_sucur,
                               ln_moneda,
                               ln_pap,
                               ln_cuenta,
                               ln_opera --, ln_subope, ln_tipope
                          from fsr011
                         where r2mod = P_N_MODULO
                           and r2cta = P_N_CUENTA
                           and r2oper = P_N_OPERACION
                           and r2sbop = P_N_SUBOPER
                           and r2cod = P_N_PGCOD
                           and r2suc = P_N_SUCURSAL
                           and r2mda = P_N_MONEDA
                           and r2pap = P_N_PAPEL
                           and relcod = 34;
                      exception
                        when others then
                          ln_cuenta := null;
                      end;
                  end;
              end;
            when others then
              ln_cuenta := null;
            
          end; --
      
        when too_many_rows then
          --B
          begin
            select distinct r1cod,
                            r1mod,
                            r1suc,
                            r1mda,
                            r1pap,
                            r1cta,
                            r1oper --, r1sbop, r1tope  
              into ln_pgcod,
                   ln_modulo,
                   ln_sucur,
                   ln_moneda,
                   ln_pap,
                   ln_cuenta,
                   ln_opera --, ln_subope, ln_tipope
              from fsr011
             where r2mod = P_N_MODULO
               and r2cta = P_N_CUENTA
               and r2oper = P_N_OPERACION
               and r2sbop = P_N_SUBOPER
               and r2cod = P_N_PGCOD
               and r2suc = P_N_SUCURSAL
               and r2mda = P_N_MONEDA
               and r2pap = P_N_PAPEL
               and r2tope = P_N_TIPOPER
               and relcod = 33;
          exception
            when others then
              ln_cuenta := null;
          end;
        
      end; --Fin Begin 2
    
    end if;
  
    if ln_cuenta is null then
      ln_pgcod  := P_N_PGCOD;
      ln_modulo := P_N_MODULO;
      --ln_sucur  := P_N_SUCURSAL;
      ln_moneda := P_N_MONEDA;
      ln_pap    := P_N_PAPEL;
      ln_cuenta := P_N_CUENTA;
      ln_opera  := P_N_OPERACION;
      ln_subope := P_N_SUBOPER;
      ln_tipope := P_N_TIPOPER;
    
    end if;
  
    if P_N_ESTADO = 33 then
      begin
        SELECT distinct s.jaqm34nom, t.jaqm35tfec
          into P_C_ABOGADO, pf_asig
          from jaqm35 t
          left join jaqm34 s
            on s.jaqm34cod = t.jaqm34cod
         where t.jaqm35pgco = P_N_PGCOD
           and t.jaqm35mda = P_N_MONEDA
           and t.jaqm35pap = P_N_PAPEL
           and t.jaqm35cta = P_N_CUENTA
           and t.jaqm35oper = P_N_OPERACION
           and t.jaqm35sbop = P_N_SUBOPER
           and t.jaqm35tope = P_N_TIPOPER
           and t.jaqm35mod = P_N_MODULO
           and t.jaqm35suc = P_N_SUCURSAL
           and t.jaqm35tcon = 'S';
      end;
    
    else
      Begin
      
        SELECT distinct s.jaqm34nom
          into P_C_ABOGADO
          from jaqm35 t
          left join jaqm34 s
            on s.jaqm34cod = t.jaqm34cod
         where t.jaqm35pgco = ln_pgcod
           and t.jaqm35mda = ln_moneda
           and t.jaqm35pap = ln_pap
           and t.jaqm35cta = ln_cuenta
           and t.jaqm35oper = ln_opera
           and t.jaqm35tcon = 'S';
      exception
        when too_many_rows then
          begin
            SELECT distinct s.jaqm34nom
              into P_C_ABOGADO
              from jaqm35 t
              left join jaqm34 s
                on s.jaqm34cod = t.jaqm34cod
             where t.jaqm35pgco = ln_pgcod
               and t.jaqm35mda = ln_moneda
               and t.jaqm35pap = ln_pap
               and t.jaqm35cta = ln_cuenta
               and t.jaqm35oper = ln_opera
               and t.jaqm35mod = ln_modulo
               and t.jaqm35tcon = 'S';
          exception
            when too_many_rows then
              begin
                SELECT distinct s.jaqm34nom --2015.09.28
                  into P_C_ABOGADO
                  from jaqm35 t
                  left join jaqm34 s
                    on s.jaqm34cod = t.jaqm34cod
                 where t.jaqm35pgco = ln_pgcod
                   and t.jaqm35mda = ln_moneda
                   and t.jaqm35pap = ln_pap
                   and t.jaqm35cta = ln_cuenta
                   and t.jaqm35oper = ln_opera
                   and t.jaqm35mod = ln_modulo
                   and t.jaqm35sbop = ln_subope
                   and t.jaqm35tope = ln_tipope
                   and t.jaqm35tcon = 'S';
              
              exception
                when others then
                  P_C_ABOGADO := null;
              end;
            
            WHEN others THEN
              P_C_ABOGADO := null;
            
          end;
        when no_data_found then
          P_C_ABOGADO := null;
      end;
    
      begin
        select distinct jaqm35tfec
          into pf_asig --fecha asignacion abogado
          from jaqm35
         where jaqm35pgco = ln_pgcod
           and jaqm35cta = ln_cuenta
           and jaqm35oper = ln_opera
           and jaqm35mod = ln_modulo
           and jaqm35tcon = 'S';
      exception
        when no_Data_found then
          begin
            select distinct jaqm35tfec
              into pf_asig --fecha asignacion abogado
              from jaqm35
             where jaqm35pgco = ln_pgcod
               and jaqm35cta = ln_cuenta
               and jaqm35oper = ln_opera
               and jaqm35tcon = 'S';
          exception
            when too_many_rows then
              begin
                select distinct jaqm35tfec
                  into pf_asig --fecha asignacion abogado
                  from jaqm35
                 where jaqm35pgco = ln_pgcod
                   and jaqm35cta = ln_cuenta
                   and jaqm35oper = ln_opera
                   and jaqm35tcon = 'S';
              exception
                when others then
                  pf_asig := null;
              end;
            when others then
              pf_asig := null;
          end;
        when others then
          pf_asig := null;
      end;
    end if;
  end sp_cr_abogado;

  -------------------------------------------------------------------------
  procedure sp_cr_sobreendeudado(ld_fecha  in date,
                                 ln_pepais in number,
                                 ln_petdoc in number,
                                 ln_pendoc in char,
                                 lc_fgsob  out varchar2) is
    lc_fgsobact varchar2(2);
    lc_fgsobhis varchar2(2);
    ln_sobreen  number;
    ld_primes   date;
    ld_segmes   date;
    ld_termes   date;
    --fecha_anterior date;
    --fecha_final    date;
    -- fecha_inicial  date;
    ld_jaqy490fec date;
    ld_fechas     date;
    cont          number := 0;
    --lc_mesyear     varchar2(6);
  
    /*  cursor ld_FechasHistoricas is
        select distinct (h.jaqy490fec) FechHisto
          from jaqy490h h
         where h.jaqy490fec <= ld_fecha
         order by jaqy490fec desc;
    */
  begin
    lc_fgsobact := 'N';
    lc_fgsobhis := 'N';
    lc_fgsob    := 'N';
  
    begin
    
      select max(jaqy490fec) into ld_fechas from jaqy490s s;
    exception
      when others then
        null;
      
    end;
  
    begin
      --jaqy490s 
      begin
        select jaqy490sob
          into ln_sobreen
          from jaqy490s s
         where s.Jaqy490fec <= ld_fecha --'21/07/2016' 
           and s.Jaqy490pai = ln_pepais --604
           and s.Jaqy490tdo = ln_petdoc --21
           and s.JAQY490NDO = ln_pendoc --'00006472' 
        -- and s. jaqy490sob = 1
         order by s.jaqy490fec desc;
      
      exception
        when others then
          null;
      end;
    
      if ln_sobreen = 1 then
        lc_fgsobact := 'S';
      
      else
        if (ln_sobreen = 0) or (ld_fecha >= ld_fechas) then
          lc_fgsobact := 'N';
          cont        := cont + 1;
        end if;
      end if;
    
    end;
  
    if lc_fgsobact = 'N' THEN
    
      /*for f in ld_FechasHistoricas loop
      
        if cont < 3 then
        
          begin
            select jaqy490fec Fecha, jaqy490sob sobreen
            
              into ld_jaqy490fec, ln_sobreen
              from jaqy490h h
             where h.Jaqy490fec = f.fechhisto
               and h.Jaqy490pai = ln_pepais
               and h.Jaqy490tdo = ln_petdoc
               and h.JAQY490NDO = ln_pendoc;
          
          exception
            when others then
              null;
          end;
        
          if ln_sobreen = 1 then
            lc_fgsobhis := 'S';
            exit;
          else
            if ln_sobreen = 0 or ln_sobreen is null then
              lc_fgsobhis := 'N';
              cont        := cont + 1;
            
            end if;
          end if;
        end if;
      
      end loop;*/
    
      /*if ld_fecha = last_day(ld_fecha) then
        ld_primes := ld_fecha;
        ld_segmes :=  last_day(add_months(ld_fecha, -1));
        ld_termes :=  last_day(add_months(ld_fecha, -2));
      else
        ld_primes := last_day(add_months(ld_fecha, -1));
        ld_segmes :=  last_day(add_months(ld_fecha, -2));
        ld_termes :=  last_day(add_months(ld_fecha, -3));
      end if;*/
    
      if ld_fecha = last_day(ld_fecha) and cont = 0 then
        ld_primes := ld_fecha;
        ld_segmes := last_day(add_months(ld_fecha, -1));
        ld_termes := last_day(add_months(ld_fecha, -2));
      else
        if ld_fecha <> last_day(ld_fecha) and cont = 0 then
          ld_primes := last_day(add_months(ld_fecha, -1));
          ld_segmes := last_day(add_months(ld_fecha, -2));
          ld_termes := last_day(add_months(ld_fecha, -3));
        else
          if cont = 1 then
            ld_primes := last_day(add_months(ld_fecha, -2));
            ld_segmes := last_day(add_months(ld_fecha, -3));
          end if;
        end if;
      end if;
    
      --  fecha_final    := last_day(ld_fecha);
    
      begin
        -- Primer Mes Historico
        select jaqy490fec Fecha, jaqy490sob sobreen
        
          into ld_jaqy490fec, ln_sobreen
          from jaqy490h h
         where h.Jaqy490fec = ld_primes
           and h.Jaqy490pai = ln_pepais
           and h.Jaqy490tdo = ln_petdoc
           and h.JAQY490NDO = ln_pendoc;
      
      exception
        when others then
          null;
      end;
    
      --  for s in Sobreendeudaant loop
      if ln_sobreen = 1 then
        lc_fgsobhis := 'S';
      
      else
        if ln_sobreen = 0 or ln_sobreen is null then
          lc_fgsobhis := 'N';
          cont        := cont + 1;
        
        end if;
      end if;
    
      if lc_fgsobhis = 'N' then
      
        begin
          -- Segundo Mes Historico
        
          -- ld_fecha := fecha_final;
        
          /* fecha_anterior := add_months(fecha_final, -1);
          
          fecha_final    := last_day(fecha_anterior);*/
        
          begin
          
            select jaqy490fec Fecha, jaqy490sob sobreen
            
              into ld_jaqy490fec, ln_sobreen
              from jaqy490h h
             where h.Jaqy490fec = ld_segmes
               and h.Jaqy490pai = ln_pepais
               and h.Jaqy490tdo = ln_petdoc
               and h.JAQY490NDO = ln_pendoc;
          exception
            when others then
              null;
          end;
        
          if ln_sobreen = 1 then
            lc_fgsobhis := 'S';
            --exit;
          else
            if ln_sobreen = 0 or ln_sobreen is null then
              lc_fgsobhis := 'N';
              cont        := cont + 1;
            end if;
          end if;
        
        end;
      
        if lc_fgsobhis = 'N' and cont < 3 then
        
          begin
            -- Tercer Mes Historico
          
            -- ld_fecha := fecha_final;
          
            /* fecha_anterior := add_months(fecha_final, -1);
            
            fecha_final    := last_day(fecha_anterior);*/
          
            begin
            
              select jaqy490fec Fecha, jaqy490sob sobreen
              
                into ld_jaqy490fec, ln_sobreen
                from jaqy490h h
               where h.Jaqy490fec = ld_termes
                 and h.Jaqy490pai = ln_pepais
                 and h.Jaqy490tdo = ln_petdoc
                 and h.JAQY490NDO = ln_pendoc;
            exception
              when others then
                null;
            end;
          
            if ln_sobreen = 1 then
              lc_fgsobhis := 'S';
              --exit;
            else
              if ln_sobreen = 0 or ln_sobreen is null then
                lc_fgsobhis := 'N';
                -- cont:= cont + 1;
              end if;
            end if;
          
          end;
        
        end if;
      
      end if;
    
    end if;
  
    if lc_fgsobact = 'S' or lc_fgsobhis = 'S' then
      lc_fgsob := 'S';
    else
      lc_fgsob := 'N';
    end if;
  
  end sp_cr_sobreendeudado;

  ----------------------------------------------------------------------------
  --Fecha de Transferencia de Abogado

  procedure sp_cr_fectransabo(pa_ppcta        in number,
                              pa_ppoper       in number,
                              FechTransfAboga out varchar2) is
    ld_fecha DATE;
  
  begin
  
    begin
      select s.sng419fect
        into ld_fecha
        from sng419 s
       where sng419acc = 4
         and sng419cta = pa_ppcta
         and sng419ope = pa_ppoper
         and s.sng410corr = (select max(s.sng410corr)
                               from sng419 s
                              where sng419acc = 4
                                and sng419cta = pa_ppcta
                                and sng419ope = pa_ppoper);
    
    exception
      when others then
        NULL;
      
    end;
  
    FechTransfAboga := to_char(ld_fecha, 'yyyy.mm.dd');
  
  end sp_cr_fectransabo;

  ----------------------------------------------------------------------------------------

  procedure sp_cr_Fec_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date,
                                  pd_fecha  out date) is
  
    ld_fecpxv date;
  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
    pd_fecha := ld_fecpxv;
  
  end sp_cr_Fec_Proximo_vto;

  ----------------------------------------------------------------------------------------
  Procedure sp_cr_tit_representante(pn_corr in number) is
  
    cursor creditos is
      select * from jaql964 where jaql964cor = pn_corr;
  
    cursor titular(cuenta in number) is
      select *
        from fsr008
       where ctnro = cuenta
         and cttfir <> 'T';
  
    cursor representante(pais in number, tipdoc in number, numdoc in char) is
      select * /*f.pfpai1, f.pftdo1, f.pfndo1
                                                                                                                                                                                                                                                                                                                                                                                                                                          into ln_PaisDocII, ln_TipoDocII, lc_NdocII*/
        from fsr003 f
       where f.pjpais = pais
         and f.pjtdoc = TipDoc
         and f.pjndoc = Numdoc
         and f.vicod = 7;
  
    --lc_pendoc char(12);      
    lc_nom     char(30);
    lc_tipdoc  numbeR;
    ln_cont_pn number := 0;
    ln_cont_pj number := 0;
  
    lc_titular varchar2(100);
    ln_pais    number;
    ln_tdo     number;
    ln_doc     char(12);
    lc_direc   varchar2(150);
    lc_distr   varchar2(100);
    lc_refer1  varchar2(150);
    lc_ubigeo  char(6);
    lc_dpto    varchar2(50);
    lc_prov    varchar2(50);
    lc_dist    varchar2(50);
  
  begin
  
    for i in creditos loop
    
      lc_tipdoc := i.jaql964tid;
    
      if lc_tipdoc = 9 then
      
        for z in representante(i.jaql964pai, i.jaql964tid, i.jaql964doc) loop
        
          ln_cont_pj := ln_cont_pj + 1;
        
          begin
            select penom
              into lc_nom
              from fsd001
             where pepais = z.pfpai1
               and petdoc = z.pftdo1
               and pendoc = z.pfndo1;
          exception
            when no_data_found then
              lc_nom := null;
            
          end;
        
          --dbms_output.put_line('cor PJ-'||i.jaql964cor|| ' i.jaql964doc '||i.jaql964doc||' numdoc '||z.pfndo1|| ' lc_nom '||lc_nom );
          lc_titular := lc_nom;
          ln_pais    := z.pfpai1;
          ln_tdo     := z.pftdo1;
          ln_doc     := z.pfndo1;
        
          begin
            pq_cr_jaql964_cartera.sp_cr_direccion_aval(p_n_pepais => ln_pais,
                                                       p_n_petdoc => ln_tdo,
                                                       p_n_pendoc => ln_doc,
                                                       p_c_direc  => lc_direc,
                                                       p_c_distr  => lc_distr,
                                                       p_c_refer1 => lc_refer1,
                                                       p_c_ubigeo => lc_ubigeo);
          end;
        
          begin
            pq_cr_jaql964_cartera.sp_cr_dpto_prov_dis(pc_ubigeo => lc_ubigeo,
                                                      pc_dpto   => lc_dpto,
                                                      pc_prov   => lc_prov,
                                                      pc_dist   => lc_dist);
          end;
        
          if ln_cont_pj = 1 then
            insert into JAQL964a
              (JAQL964ACOR,
               JAQL964ATIT2,
               JAQL964APAI2,
               JAQL964ATDO2,
               JAQL964ADOC2,
               JAQL964ADIR2,
               JAQL964AUBG2,
               JAQL964ADPT2,
               JAQL964APRO2,
               JAQL964ADIS2)
            values
              (pn_corr,
               lc_titular,
               ln_pais,
               ln_tdo,
               ln_doc,
               lc_direc,
               lc_ubigeo,
               lc_dpto,
               lc_prov,
               lc_dist);
          else
          
            update jaql964a
               set JAQL964ATIT3 = lc_titular,
                   JAQL964APAI3 = ln_pais,
                   JAQL964ATDO3 = ln_tdo,
                   JAQL964ADOC3 = ln_doc,
                   JAQL964ADIR3 = lc_direc,
                   JAQL964AUBG3 = lc_ubigeo,
                   JAQL964ADPT3 = lc_dpto,
                   JAQL964APRO3 = lc_prov,
                   JAQL964ADIS3 = lc_dist
             where jaql964acor = pn_corr;
          
          end if;
          commit;
        
        end loop;
      
      else
        for y in titular(i.jaql964cta) loop
          ln_cont_pn := ln_cont_pn + 1;
        
          begin
            select penom
              into lc_nom
              from fsd001
             where pepais = y.pepais
               and petdoc = y.petdoc
               and pendoc = y.pendoc;
          exception
            when no_data_found then
              lc_nom := null;
            
          end;
        
          -- dbms_output.put_line('cor PN-'||i.jaql964cor|| ' i.jaql964doc '||i.jaql964doc||' numdoc '||y.pendoc|| ' lc_nom '||lc_nom );
        
          lc_titular := lc_nom;
          ln_pais    := y.pepais;
          ln_tdo     := y.petdoc;
          ln_doc     := y.pendoc;
        
          begin
            pq_cr_jaql964_cartera.sp_cr_direccion_aval(p_n_pepais => ln_pais,
                                                       p_n_petdoc => ln_tdo,
                                                       p_n_pendoc => ln_doc,
                                                       p_c_direc  => lc_direc,
                                                       p_c_distr  => lc_distr,
                                                       p_c_refer1 => lc_refer1,
                                                       p_c_ubigeo => lc_ubigeo);
          end;
        
          begin
            pq_cr_jaql964_cartera.sp_cr_dpto_prov_dis(pc_ubigeo => lc_ubigeo,
                                                      pc_dpto   => lc_dpto,
                                                      pc_prov   => lc_prov,
                                                      pc_dist   => lc_dist);
          end;
        
          if ln_cont_pn = 1 then
            insert into JAQL964a
              (JAQL964ACOR,
               JAQL964ATIT2,
               JAQL964APAI2,
               JAQL964ATDO2,
               JAQL964ADOC2,
               JAQL964ADIR2,
               JAQL964AUBG2,
               JAQL964ADPT2,
               JAQL964APRO2,
               JAQL964ADIS2)
            values
              (pn_corr,
               lc_titular,
               ln_pais,
               ln_tdo,
               ln_doc,
               lc_direc,
               lc_ubigeo,
               lc_dpto,
               lc_prov,
               lc_dist);
          else
          
            update jaql964a
               set JAQL964ATIT3 = lc_titular,
                   JAQL964APAI3 = ln_pais,
                   JAQL964ATDO3 = ln_tdo,
                   JAQL964ADOC3 = ln_doc,
                   JAQL964ADIR3 = lc_direc,
                   JAQL964AUBG3 = lc_ubigeo,
                   JAQL964ADPT3 = lc_dpto,
                   JAQL964APRO3 = lc_prov,
                   JAQL964ADIS3 = lc_dist
             where jaql964acor = pn_corr;
          
          end if;
          commit;
        
        end loop;
      
      end if;
    
      ln_cont_pn := 0;
      ln_cont_pj := 0;
    end loop;
  
  end sp_cr_tit_representante;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_dpto_prov(vjaql964cta   in number,
                            vjaql964doc   in char,
                            vprovincia    out varchar2,
                            vdepartamento out varchar2) is
    -- *****************************************************************
    -- Nombre                     : fn_cr_dpto_prov
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2018.02.05
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Provincia-Dpto
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- *****************************************************************
    -- ln_numero number :=0;
    lc_telefo varchar2(20);
    ln_pepais number(3);
    ln_petdoc number(2);
  
    ln_coddpto      number(5);
    ln_codprov      number(5);
    lc_provincia    varchar2(50);
    lc_departamento varchar2(50);
  
  begin
  
    begin
      select /*+choose*/
       pepais, petdoc
        into ln_pepais, ln_petdoc
        from fsr008
       where ctnro = vjaql964cta
         and pendoc = vjaql964doc
         and ttcod = 1
         and cttfir = 'T';
    exception
      when NO_DATA_FOUND then
        ln_pepais := null;
        ln_petdoc := null;
    end;
  
    ---OBTENER PROVINCIA
    begin
      select sngc13dpto, sngc13prov
        into ln_coddpto, ln_codprov
        from sngc13 s
       where s.sngc13pais = ln_pepais
         and s.sngc13tdoc = ln_petdoc
         and s.sngc13ndoc = vjaql964doc
         and docod = 1
         and sngc13est = 'H'
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        ln_coddpto := null;
        ln_codprov := null;
    end;
  
    begin
      select locnom
        into lc_provincia
        from fst070 f
       where f.pais = ln_pepais
         and f.depcod = ln_coddpto
         and f.loccod = ln_codprov;
    exception
      when NO_DATA_FOUND then
        lc_provincia := ' ';
    end;
  
    --DPTO
    begin
    
      select depnom
        into lc_departamento
        from fst068 f
       where f.pais = ln_pepais
         and f.depcod = ln_coddpto;
    
    exception
      when NO_DATA_FOUND then
        lc_departamento := ' ';
    end;
  
    vprovincia    := lc_provincia;
    vdepartamento := lc_departamento;
  
  end sp_cr_dpto_prov;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_cr_DPTO_PROV_DIS(pc_ubigeo in char,
                                pc_dpto   out char,
                                pc_prov   out char,
                                pc_dist   out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_DPTO_PROV_DIS
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Cr¿ditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2018.02.13
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Retorna Distrito-Provincia-Dpto
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : ESTADO
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- *****************************************************************
    -- ln_numero number :=0;
    lc_telefo varchar2(20);
    ln_pepais number(3);
    ln_petdoc number(2);
  
    ln_coddpto      number(5);
    ln_codprov      number(5);
    lc_provincia    varchar2(50);
    lc_departamento varchar2(50);
  
  begin
  
    begin
      select depnom DPTO, locnom PROVINCIA, fst071dsc DISTRITO
        into pc_dpto, pc_prov, pc_dist
        from fst068 f, fst070 h, fst071 g
       where h.pais = f.pais
         and h.depcod = f.depcod
         and h.loccod = g.fst071loc
         and f.pais = g.fst071pai
         and f.depcod = g.fst071dpt
         and g.fst071col = pc_ubigeo;
    exception
      when others then
        pc_dpto := ' ';
        pc_prov := ' ';
        pc_dist := ' ';
    end;
  
  end sp_cr_DPTO_PROV_DIS;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_guardar_historico_1(pc_fecha in varchar2) is
  
    --Registro en la tabla JAQL964H
  begin
  
    insert into JAQL964H
      select to_date(pc_fecha, 'rrrrmmdd') - 1 jaql964hfeh,
             jaql964cor,
             jaql964suc,
             jaql964nom,
             jaql964usu,
             jaql964num,
             jaql964sal,
             jaql964cli,
             jaql964nor,
             jaql964ref,
             jaql964jud,
             jaql964nr1,
             jaql964sa1,
             jaql964po1,
             jaql964nr2,
             jaql964sa2,
             jaql964po2,
             jaql964nr3,
             jaql964sa3,
             jaql964po3,
             jaql964nr4,
             jaql964sa4,
             jaql964po4,
             jaql964nr5,
             jaql964sa5,
             jaql964po5,
             jaql964nr6,
             jaql964sa6,
             jaql964po6,
             jaql964cre,
             jaql964tit,
             jaql964doc,
             jaql964cta,
             jaql964mod,
             jaql964mda,
             jaql964ope,
             jaql964dia,
             jaql964sao,
             jaql964sac,
             jaql964pro,
             jaql964nr7,
             jaql964sa7,
             jaql964po7,
             jaql964reg,
             jaql964ren,
             jaql964sob,
             jaql964top,
             jaql964pai,
             jaql964tid,
             jaql964tel,
             jaql964dis,
             jaql964dir,
             jaql964tco,
             jaql964gar,
             jaql964pre,
             jaql964cal,
             jaql964cca,
             jaql964abo,
             jaql964mtd,
             jaql964mta,
             jaql964csb,
             jaql964fep,
             jaql964fec,
             jaql964est,
             jaql964tcc,
             jaql964red,
             jaql964gas,
             jaql964mor,
             jaql964int,
             jaql964cuo,
             jaql964sec,
             jaql964ins,
             jaql964ctav,
             jaql964noav,
             jaql964diav,
             jaql964teav,
             jaql964icex,
             jaql964orub,
             jaql964mapr,
             jaql964prov,
             jaql964calf,
             jaql964dcalf,
             jaql964fcan,
             jaq964fref,
             jaql964fcas,
             jaql964fdem,
             jaql964ftab,
             jaql964pgcod,
             jaql964pap,
             jaql964fint,
             jaql964fadem,
             jaql964apago,
             jaql964dpago,
             jaql964firl,
             jaql964cesp,
             jaql964nexp,
             jaql964sdve,
             jaql964sdre,
             jaql964faabo,
             jaql964fejud,
             jaql964fdes,
             jaql964sdo,
             jaql964tcr,
             jaql964icv,
             jaql964tcap,
             jaql964tint,
             jaql964tmor,
             jaql964tgas,
             jaql964ticv,
             jaql964seg,
             jaql964tseg,
             jaql964com,
             jaql964tcom,
             jaql964pzo,
             jaql964soben,
             jaql964dpto,
             jaql964provi,
             jaql964pen,
             jaql964tpen,
             jaql964sbbp,
             jaql964ibbp,
             jaql964spbp,
             jaql964ipbp,
             jaql964sbms,
             jaql964ibms,
             jaql964sbfh,
             jaql964ibfh,
             to_char(sysdate, 'DD/MM/YYYY'),
             to_char(sysdate, 'HH24:MI:SS')
        from JAQL964;
  
    commit;
  
  end sp_cr_guardar_historico_1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_guardar_historico_2(pc_fecha in varchar2) is
  
    --Registro en la tabla JAQL964H
  begin
  
    --Registro en la tabla JAQL964AH
    insert into jaql964ah
      select to_date(pc_fecha, 'rrrrmmdd') - 1 jaql964ahfeh,
             jaql964acor,
             jaql964atit2,
             jaql964atdo2,
             jaql964adoc2,
             jaql964adir2,
             jaql964aubg2,
             jaql964atit3,
             jaql964atdo3,
             jaql964adoc3,
             jaql964adir3,
             jaql964aubg3,
             jaql964apai2,
             jaql964apai3,
             jaql964adpt2,
             jaql964apro2,
             jaql964adpt3,
             jaql964apro3,
             jaql964adis2,
             jaql964adis3,
             to_char(sysdate, 'DD/MM/YYYY'),
             to_char(sysdate, 'HH24:MI:SS')
        from jaql964a;
  
    --Registro en la tabla JAQL971H
    insert into JAQL971H
      select to_date(pc_fecha, 'rrrrmmdd') - 1 jaql964hfeh,
             jaql964cor,
             jaql971cor,
             jaql971cta1,
             jaql971nom1,
             jaql971tdoc1,
             jaql971doc1,
             jaql971dir1,
             jaql971red1,
             jaql971dis1,
             jaql971tel1,
             jaql971neg1,
             jaql971cta2,
             jaql971nom2,
             jaql971tdoc2,
             jaql971doc2,
             jaql971dir2,
             jaql971red2,
             jaql971dis2,
             jaql971tel2,
             jaql971neg2,
             jaql971cta3,
             jaql971nom3,
             jaql971tdoc3,
             jaql971doc3,
             jaql971dir3,
             jaql971red3,
             jaql971dis3,
             jaql971tel3,
             jaql971neg3,
             jaql971cta4,
             jaql971nom4,
             jaql971tdoc4,
             jaql971doc4,
             jaql971dir4,
             jaql971red4,
             jaql971dis4,
             jaql971tel4,
             jaql971neg4,
             jaql971cta5,
             jaql971nom5,
             jaql971tdoc5,
             jaql971doc5,
             jaql971dir5,
             jaql971red5,
             jaql971dis5,
             jaql971tel5,
             jaql971neg5,
             jaql971cta6,
             jaql971nom6,
             jaql971tdoc6,
             jaql971doc6,
             jaql971dir6,
             jaql971red6,
             jaql971dis6,
             jaql971tel6,
             jaql971neg6,
             jaql971pepais1,
             jaql971pepais2,
             jaql971pepais3,
             jaql971pepais4,
             jaql971pepais5,
             jaql971pepais6,
             jaql971ugeo1,
             jaql971ugeo2,
             jaql971ugeo3,
             jaql971ugeo4,
             jaql971ugeo5,
             jaql971ugeo6,
             jaql971dpto1,
             jaql971dpto2,
             jaql971dpto3,
             jaql971dpto4,
             jaql971dpto5,
             jaql971dpto6,
             jaql971prov1,
             jaql971prov2,
             jaql971prov3,
             jaql971prov4,
             jaql971prov5,
             jaql971prov6,
             --sysdate
             to_char(sysdate, 'DD/MM/YYYY'),
             to_char(sysdate, 'HH24:MI:SS')
        from jaql971;
  
    commit;
  
  end sp_cr_guardar_historico_2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_verificar_fin_mes(pc_fecha in varchar2) is
    pe_fecha    date;
    pe_mes      number;
    pe_anio     number;
    sr_mes      char(2);
    sr_anio     char(4);
    sr_mes_sig  char(2);
    sr_anio_sig char(4);
    sr_mes_act  char(2);
    sr_anio_act char(4);
    STR_SQL     varchar2(1000);
  
  begin
  
    pe_fecha := TO_DATE(pc_fecha, 'YYYY/MM/DD HH:MI:SS') - 1;
  
    if (last_day(pe_fecha) - pe_fecha) = 0 then
    
      pe_fecha := pe_fecha - 1;
    
      ---Evaluar año y mes   
      pe_mes  := extract(month from pe_fecha);
      pe_anio := extract(year from pe_fecha);
    
      sr_mes_act  := lpad(to_char(pe_mes), 2, '0');
      sr_anio_act := to_char(pe_anio);
    
      pe_mes := pe_mes + 1;
    
      if pe_mes = 13 then
        sr_mes      := lpad(to_char(1), 2, '0');
        sr_mes_sig  := lpad(to_char(2), 2, '0');
        sr_anio     := to_char(pe_anio + 1);
        sr_anio_sig := to_char(pe_anio + 1);
      elsif pe_mes = 12 then
        sr_mes      := lpad(to_char(pe_mes), 2, '0');
        sr_mes_sig  := lpad(to_char(1), 2, '0');
        sr_anio     := to_char(pe_anio);
        sr_anio_sig := to_char(pe_anio + 1);
      else
        sr_mes      := lpad(to_char(to_char(pe_mes)), 2, '0');
        sr_mes_sig  := lpad(to_char(pe_mes + 1), 2, '0');
        sr_anio     := to_char(pe_anio);
        sr_anio_sig := to_char(pe_anio);
      end if;
    
      ---Agregar particiones
      STR_SQL := 'ALTER TABLE JAQL964H ADD PARTITION JAQL964H_' || sr_anio || '' ||
                 sr_mes || ' VALUES LESS THAN (TO_DATE(''' || sr_anio_sig || '-' ||
                 sr_mes_sig || '-01'',''YYYY-MM-DD''))';
      --dbms_output.put_line(STR_SQL);     
      EXECUTE IMMEDIATE STR_SQL;
    
      STR_SQL := 'ALTER TABLE JAQL964AH ADD PARTITION JAQL964AH_' ||
                 sr_anio || '' || sr_mes || ' VALUES LESS THAN (TO_DATE(''' ||
                 sr_anio_sig || '-' || sr_mes_sig ||
                 '-01'',''YYYY-MM-DD''))';
      --dbms_output.put_line(STR_SQL);     
      EXECUTE IMMEDIATE STR_SQL;
    
      STR_SQL := 'ALTER TABLE JAQL971H ADD PARTITION JAQL971H_' || sr_anio || '' ||
                 sr_mes || ' VALUES LESS THAN (TO_DATE(''' || sr_anio_sig || '-' ||
                 sr_mes_sig || '-01'',''YYYY-MM-DD''))';
      --dbms_output.put_line(STR_SQL);     
      EXECUTE IMMEDIATE STR_SQL;
    
      STR_SQL := 'ALTER TABLE JAQL964H TRUNCATE PARTITION (JAQL964H_' ||
                 sr_anio_act || '' || sr_mes_act || ')';
      --dbms_output.put_line(STR_SQL);  
      EXECUTE IMMEDIATE STR_SQL;
      --alter table jaql964H truncate partition JAQL964H_202002 UPDATE INDEXES;    
    
      STR_SQL := 'ALTER TABLE JAQL964AH TRUNCATE PARTITION (JAQL964AH_' ||
                 sr_anio_act || '' || sr_mes_act || ')';
      --dbms_output.put_line(STR_SQL);     
      EXECUTE IMMEDIATE STR_SQL;
    
      STR_SQL := 'ALTER TABLE JAQL971H TRUNCATE PARTITION (JAQL971H_' ||
                 sr_anio_act || '' || sr_mes_act || ')';
      --dbms_output.put_line(STR_SQL);       
      EXECUTE IMMEDIATE STR_SQL;
    
    end if;
  
  end sp_cr_verificar_fin_mes;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------------------------------------------------------------

  function fn_cr_telefono_valido(P_N_PEPAIS in number,
                                 P_N_PETDOC in number,
                                 P_N_PENDOC in char) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : fn_cr_telefono_valido
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creacion          : 2024.02.12
    -- Autor de Creacion          : DCASTRO
    -- Uso                        : Telefono valido
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Par¿metros de Entrada      : 
    --                              
    -- Retorno                    : 
    -- Fecha de Modificacion      :
    -- Autor de la Modificacion   :
    -- Descripci¿n de Modificacion:
    --
    -- ***************************************************************** 
  
    lc_telefono varchar2(20);
  
  begin
  
    --busqueda telefonos Validados  
    begin
      select ww.jaqn2atelf --telefval
        into lc_telefono
        from (select trim(x.jaqn2atelf) jaqn2atelf, y.jaqn3afvec
                from jaqn2a x, jaqn3a y
               where x.jaqn2apai = y.jaqn3apai
                 and x.jaqn2atdoc = y.jaqn3atdoc
                 and x.jaqn2andoc = y.jaqn3andoc
                 and x.jaqn2acor = y.jaqn3acor
                 and x.jaqn2afeg = y.jaqn3afeg
                 and x.jaqn2atipv = y.jaqn3atipv
                 and y.jaqn3avig = 'S'
                 and x.jaqn2apai = P_N_PEPAIS --¿ cambiar por pais
                 and x.jaqn2atdoc = P_N_PETDOC --- cambiar por tipo de documento
                 and x.jaqn2andoc = P_N_PENDOC --¿ cambiar por número de documento
                 and x.jaqn2aest = 'VALIDADO'
                 and trim(x.jaqn2atelf) is not null
                 and exists
               (select 1
                        from fsr005 z
                       where z.pepais = x.jaqn2apai
                         and z.petdoc = x.jaqn2atdoc
                         and z.pendoc = x.jaqn2andoc
                         and trim(z.dotelfp) = trim(x.jaqn2atelf))
               order by 2 desc) ww
       where rownum = 1;
    exception
      when others then
        lc_telefono := null;
      
    end;
  
    return(lc_telefono);
  
  end fn_cr_telefono_valido;
  ---------------------------------------------------------------------------------------------
  procedure sp_Cr_UpdAQPB183(ld_fecha in date) is
  
    ln_SaldCIIU number(17, 2) := 0.00;
    ln_SaldTC   number(17, 2) := 0.00;
    ln_Porctj   number(10, 6) := 0.000000;
    ln_corr     number;
    lc_hora     varchar2(8) := '00:00:00';
    ln_NroReg   number;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_NroReg
        from aqpb183 a
       where a.aqpb183fecha = ld_fecha;
    exception
      when others then
        null;
    end;
  
    if ln_NroReg > 0 then
    
      delete from aqpb183 a where a.aqpb183fecha = ld_fecha;
      commit;
    
    end if;
  
    begin
      select max(a.aqpb183cor) into ln_corr from aqpb183 a;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select sum(j.jaql964sdo) * -1 into ln_SaldTC from jaql964 j;
    exception
      when others then
        ln_SaldTC := 0.00;
    end;
  
    begin
      select sum(j.jaql964sdo) * -1
        into ln_SaldCIIU
        from jaql964 j
       where j.jaql964ciiu in (select f.tp1nro3
                                 from fst198 f
                                where f.tp1cod = 1
                                  and f.tp1cod1 = 10899
                                  and f.tp1corr1 = 138
                                  and f.tp1corr2 = 1
                                  and f.tp1corr3 > 0);
    exception
      when others then
        ln_SaldCIIU := 0.00;
    end;
  
    ln_SaldCIIU := nvl(ln_SaldCIIU, 0);
    ln_SaldTC   := nvl(ln_SaldTC, 0);
  
    if ln_SaldTC > 0 then
    
      ln_Porctj := (ln_SaldCIIU * 100) / ln_SaldTC;
    
    end if;
  
    begin
      insert into aqpb183
        (aqpb183cor,
         aqpb183fecha,
         aqpb183hora,
         aqpb183saldotc,
         aqpb183mntciiu,
         aqpb183porctj)
      values
        (ln_corr + 1, ld_fecha, lc_Hora, ln_SaldTC, ln_SaldCIIU, ln_Porctj);
      commit;
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_Cr_UpdAQPB183;
  ---------------------------------------------------------------------------------------------
  procedure sp_Cr_CargaReconver is
  
    ln_HayData     number;
    ln_HayDataMala number;
    ln_FlagEjec    number := 0;
  
  begin
  
    begin
      select count(*)
        into ln_HayData
        from aqpb297 a
       where a.aqpb297fec =
             (select f.pgfape from fst017 f where f.pgcod = 1);
    exception
      when others then
        ln_HayData := 0;
    end;
  
    begin
      select count(*)
        into ln_HayDataMala
        from aqpb297 a
       where a.aqpb297fec =
             (select f.pgfape from fst017 f where f.pgcod = 1)
         and a.aqpb297est <> 'S';
    exception
      when others then
        ln_HayDataMala := 0;
    end;
  
    if ln_HayData = 0 then
      begin
        begin
          select f.tp1nro3
            into ln_FlagEjec
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 145
             and f.tp1corr2 = 1
             and f.tp1corr3 = 1;
        exception
          when others then
            ln_FlagEjec := 0;
        end;
      
        if ln_FlagEjec = 1 then
          begin
            -- Call the procedure
            PQ_CR_LINEA_RECONVERTIDA_CUOTA.SP_CR_VALIDACION_CREDITO;
          end;
        end if;
      end;
    end if;
  
    if ln_HayDataMala > 0 then
    
      delete aqpb297 a
       where a.aqpb297fec =
             (select f.pgfape from fst017 f where f.pgcod = 1)
         and a.aqpb297est <> 'S';
      commit;
    
      begin
        begin
          select f.tp1nro3
            into ln_FlagEjec
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 145
             and f.tp1corr2 = 1
             and f.tp1corr3 = 1;
        exception
          when others then
            ln_FlagEjec := 0;
        end;
      
        if ln_FlagEjec = 1 then
          begin
            -- Call the procedure
            PQ_CR_LINEA_RECONVERTIDA_CUOTA.SP_CR_VALIDACION_CREDITO;
          end;
        end if;
      end;
    
    end if;
  
  end sp_Cr_CargaReconver;
  ---------------------------------------------------------------------------------------------     

end PQ_CR_jaql964_cartera;
/

