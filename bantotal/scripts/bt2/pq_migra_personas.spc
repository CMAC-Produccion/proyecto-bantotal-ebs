CREATE OR REPLACE PACKAGE pq_migra_personas IS
  -- *****************************************************************
  -- Nombre                     : pq_migra_personas
  -- Sistema                    : SORFY
  -- Modulo                     : Personas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 25/04/2011
  -- Autor de Creacion          : lllosa
  -- Uso                        : PAQUETE DE MIGRACION DE DATOS CUENTAS-PERSONAS SORFY-BANDEJAS_BANTOTAL.
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Fecha de Modificacion      :
  -- Autor de Modificacion      :
  -- Descripcion de Modificacion: lllosa 2011.09.08 10:45am
  --                              lllosa 2011.09.08 12:20pm
  --                              lllosa 2011.09.08.04.10pm  
  --                              lllosa 2011.09.12 05.40pm
  --                              lllosa 2011.09.13 09.50am 
  --                              lllosa 2011.09.14 04.35pm 
  --                              ylozada 2011.09.16 05:40pm
  --                              lllosa 2011.09.16 05:58pm       
  --                              ylozada 2011.09.19 12:00pm
  --                              lllosa 2011.09.19 01:00pm
  --                              lllosa 2011.09.19 04:48pm      
  --                              ylozada 2011.09.19 04:50pm                           
  --                              ylozada 2011.09.20 08:40am   
  --                              lllosa 2011.09.20 06:20pm   
  --                              lllosa 2011.09.21 11:50am
  --                              ylozada 2011.09.21 15:56am  
  --                              ylozada 2011.09.27 12:00am
  --                              lllosa 2011.09.27 06:14pm  
  --                              ylozada 2011.09.28 08:15am  
  --                              lllosa 2011.09.28 5:15pm
  --                              ylozada 2011.09.28 17:18pm    
  --                              lllosa 2011.09.29.07:14pm
  --                              lllosa 2011.10.04 05:57pm
  --                              lllosa 2011.10.05 12:25pm
  --                              lllosa 2011.10.05.04:45pm
  --                              ylozada 2011.10.06 08:00am  
  --                              lllosa 2011.10.06 06:23pm
  --                              lllosa 2011.10.26 11:00pm  
  --                              ylozada 2011.10.26 12:00pm  
  --                              ylozada 2011.10.31 10:28am  
  --                              ylozada 2011.11.03 8:00am  
  --                              ylozada 2011.11.17 8:00am  
  --                              lllosa  2011.11.18 4:00pm  
  --                              lllosa  2011.11.28 3:54pm  
  --                              lllosa  2011.11.30 1:44pm
  --                              ylozada 2011.11.30 4:20pm  
  --                              lllosa  2011.11.30 4:37pm  
  --                              ylozada 2011.11.30 5:50pm  
  --                              ylozada 2011.12.02 12:42pm  
  --                              lllosa  2011.12.05 4:37pm
  --                              lllosa  2012.02.16 7:15pm
  --                              lllosa  2012.02.17 5.15pm
  --                              lllosa  2012.03.05 11:50am
  --                              ylozada 2012.03.09 09:42am    
  --                              ylozada 2012.03.13 12:42pm  
  --                              ylozada 2012.03.14 12:25pm  
  --                              lllosa  2012.03.20 05:24pm
  --                              lllosa  2012.03.22 12:38pm  
  --                              ylozada 2012.03.22 01:00pm
  --                              lllosa  2012.03.28 12:00pm
  --                              ylozada 2012.03.28 07:00pm  
  --                              lllosa  2012.03.29 09:20am
  --                              ylozada 2012.04.29 03:30pm  
  --                              lllosa  2012.04.09 12:30pm
  -- *****************************************************************
  
  procedure sp_cr_batch_MGMPERS (p_c_error out varchar2);

  PROCEDURE sp_MGM_validapersonas_job(P_C_DIGITO1 IN VARCHAR2,
                                      P_C_DIGITO2 IN VARCHAR2,
                                      ln_ini      in number
                                      );   
  PROCEDURE sp_bandeja_bjd001_60_11_job(P_C_ERROR OUT VARCHAR2);                                      
                                      
  PROCEDURE sp_bandeja_bjd001_60_11(P_C_DIGITO1 IN VARCHAR2,
                                    P_C_DIGITO2 IN VARCHAR2,
                                    ln_nro      in number,            
                                    ln_nro1     in number,
                                    ln_nro2     in number,                                                            
                                    ln_ini      in number
                              );                                      
                                      
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_personas_BJD002;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_personas_BJD003;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_personas_BJD004;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_direccion_personas_job(P_C_ERROR OUT VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_direccion_legal_BJD005(P_C_DIGITO1 IN VARCHAR2,
                                      P_C_DIGITO2 IN VARCHAR2,
                                      ln_nro      in number,            
                                      ln_nro1     in number,
                                      ln_nro2     in number,                                                                            
                                      ln_ini      in number
                                      );    
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_lavado_dinero_BJD201;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_lista_banco_BJD201;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_Lista_Preventiva_BJD201;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_Lista_PEP_BJD201 ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  PROCEDURE sp_Lista_Sencibles_BJD201;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_rel_personales_BJR002;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_rel_per_juridicas_BJR003;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_es_fallecido_BJX001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_MGM_ctacliente (p_n_proceso in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_bandeja_bjd008_job(P_C_ERROR OUT VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --PROCEDURE sp_cuentas_BJD008;
  PROCEDURE sp_cuentas_BJD008(P_C_DIGITO1 IN VARCHAR2,
                              P_C_DIGITO2 IN VARCHAR2,
                              ln_nro      in number,            
                              ln_ini      in number
                              );  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_direccion_cuentas_job(P_C_ERROR OUT VARCHAR2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_domicilio_legal_ctas_BJD006(P_C_DIGITO1 IN VARCHAR2,
                                           P_C_DIGITO2 IN VARCHAR2,
                                           ln_nro      in number,            
                                           ln_nro1     in number,
                                           ln_nro2     in number,                                                                            
                                           ln_ini      in number
                                           );  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_habilitaciones_ctas_BJE108;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_integracion_ctas_BJR008;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_textos_cliente_BJX008;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_mapeo_prod (p_n_ctaini in number, p_n_ctafin in number, p_c_fecpro in varchar2 );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_cr_batch_btctaprd(P_C_FECPRO in varchar2) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  PROCEDURE sp_itf_personas_BNJTI1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_migra_direccion(P_C_CODPER IN VARCHAR2,
                               P_C_TIPDIR IN VARCHAR2,    
                               P_C_TIPVIA IN VARCHAR2,                  
                               p_n_codni1 out number,
                               p_c_desnv1 out varchar2,
                               p_n_codni2 out number,
                               p_c_desnv2 out varchar2,
                               p_n_codni3 out number,
                               p_c_desnv3 out varchar2,
                               p_n_codni4 out number,
                               p_c_desnv4 out varchar2,
                               p_n_codni5 out number,
                               p_c_desnv5 out varchar2,
                               p_n_codni6 out number,
                               p_c_desnv6 out varchar2
                               );   

end pq_migra_personas;
/

