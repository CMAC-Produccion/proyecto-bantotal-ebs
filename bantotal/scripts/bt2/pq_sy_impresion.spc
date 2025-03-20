create or replace package pq_sy_impresion is
  -- ***********************************************************************************************
  -- Nombre                       : PQ_SY_IMPRESION
  -- Sistema                      : SORFY
  -- Módulo                       : Créditos / Depósitos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 2012.04.30
  -- Autor de Creación            : NPALZA
  -- Uso                          : Impresión de Formularios Contractuales
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        :
  -- Autor de Modificación        :
  -- Descripción de Modificación  : 2012.05.11 NPALZA -> Se añadió la función fn_fecdia_semana.
  --                                2012.05.29 NPALZA -> Se añadió la función fn_cl_existe_tasa.
  --                                2012.05.29 NPALZA -> Se añadió la función sp_cl_insertar_tasa.
  --                                2012.05.29 NPALZA -> Se añadió la función sp_cl_actualizar_tasa.
  -- ***********************************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_formato_cuenta(P_C_NUMCTA varchar2
                            )return varchar2; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_nombre_mes(P_D_FECPRO in date  
                        )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecdia_semana(P_D_FECPRO in date  
                           )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_titulares(P_C_NUMCTA varchar2,
                           P_N_NUMORP varchar2
                          )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_montot(P_C_NUMCRE varchar2
                       )return varchar2; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_descon(P_C_NUMCRE varchar2
                       )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_numpol(P_C_NUMCRE varchar2
                       )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  function fn_cr_nomase(P_C_NUMCRE varchar2
                       )return varchar2;                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_codper(P_C_NUMCRE varchar2
                       )return varchar2;                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_mtoint(P_C_NUMCRE varchar2
                       )return number;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cl_existe_tasa(P_C_NUMSOL in varchar2
                            ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                       
  procedure sp_cl_insertar_tasa(P_C_NUMSOL in varchar2,
                                P_N_TASINT in number,
                                P_N_TASMOR in number,
                                P_N_TASGAR in number, 
                                P_C_CODFUF in varchar2,
                                P_C_CODLFI in varchar2,
                                P_C_CODLCR in varchar2,
                                P_C_CODSLI in varchar2,
                                P_C_CODERR out varchar2,
                                P_C_MSGERR out varchar2);      
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cl_actualizar_tasa(P_C_NUMSOL in varchar2,
                                  P_N_TASINT in number,
                                  P_N_TASMOR in number,
                                  P_N_TASGAR in number,
                                  P_C_CODFUF in varchar2,
                                  P_C_CODLFI in varchar2,
                                  P_C_CODLCR in varchar2,
                                  P_C_CODSLI in varchar2);      
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  /**/
  procedure sp_cr_prestatario(P_C_NUMCRE in varchar2,  
                              P_C_CODERR out varchar2,
                              P_C_MSGERR out varchar2
                             );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_cliper(P_C_NUMCRE in varchar2,
                        P_N_NUMCOR in number
                       )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_nomper(P_C_NUMCRE in varchar2,
                        P_N_NUMCOR in number
                       )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_docnum(P_C_NUMCRE in varchar2,
                        P_N_NUMCOR in number
                       )return varchar2;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cr_dirper(P_C_NUMCRE in varchar2,
                        P_N_NUMCOR in number
                       )return varchar2;    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_repleg(P_C_NUMCRE in varchar2,
                        P_N_NUMCOR in number  
                        )return varchar2;                       
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_monto_letras(P_N_MTOAPR in number,
                           P_C_CODMON in varchar2
                          )return varchar2;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --           
  function fn_convierte_nom_tea_cred(P_C_CODPAC in varchar2,
                                     P_C_TIPOTS in varchar2,
                                     P_N_TASNOM in number
                                    )return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                          
  function fn_fecha_letras(P_D_FECPRO in date  
                          )return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  /*procedure sp_cr_monicr(P_C_NUMCRE in varchar2,
                         P_N_MTOINT out number,
                         P_N_MTONET out number
                        );   */                     
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                       
  /**/  
  function fn_cr_monicr(P_C_NUMCRE in varchar2
                       )return number;                        
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                         
  function fn_cr_mtonet(P_C_NUMCRE in varchar2
                       )return number;                                   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  function fn_cr_codtra(P_C_NUMCRE in varchar2,
                        P_D_FECDES in varchar2
                       )return number;                                   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_cr_mtored(P_C_NUMCRE in varchar2
                       )return number;                                   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end pq_sy_impresion;
/

