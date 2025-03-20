create or replace package PQ_MIGRA_SERVICIOS is

       PROCEDURE SP_TD_BNJ040;
       PROCEDURE SP_TD_BNJ041;
       PROCEDURE SP_TD_BNJ042;
       
       PROCEDURE SP_BTCTAPRD_DATOS_OP1(P_C_CODCLI IN VARCHAR2, 
                                       P_C_NUMTAR IN VARCHAR2,
                                       P_N_SUCURS OUT NUMBER,
                                       P_N_CTABTT OUT NUMBER,
                                       P_N_SUBOPE OUT NUMBER,                                  
                                       P_N_MODULO OUT NUMBER,
                                       P_N_MONEDA OUT NUMBER,
                                       P_N_PAPEL  OUT NUMBER,
                                       P_N_TOTOPE OUT NUMBER,
                                       P_N_OPERAC OUT NUMBER,
                                       P_C_DESERR OUT VARCHAR2);

       PROCEDURE SP_BTCTAPRD_DATOS_OP2(P_C_CODCLI IN VARCHAR2, 
                                       P_C_NUMCTA IN VARCHAR2,
                                       P_N_SUCURS OUT NUMBER,
                                       P_N_CTABTT OUT NUMBER,
                                       P_N_SUBOPE OUT NUMBER,                                  
                                       P_N_MODULO OUT NUMBER,
                                       P_N_MONEDA OUT NUMBER,
                                       P_N_PAPEL  OUT NUMBER,
                                       P_N_TOTOPE OUT NUMBER,
                                       P_N_OPERAC OUT NUMBER,
                                       P_C_DESERR OUT VARCHAR2);                                       
       
       FUNCTION FN_AHHTARJ_FECTRA(P_C_NUMTAR VARCHAR2, P_C_CODEST VARCHAR2) RETURN DATE;
       FUNCTION FN_AHHTARJ_AUUSUINS(P_C_NUMTAR VARCHAR2, P_C_CODEST VARCHAR2) RETURN VARCHAR2;
       
       FUNCTION FN_TMP_SUCURSALES_SUCURS(P_C_CODAGE VARCHAR2) RETURN NUMBER;
       FUNCTION FN_TMP_TIPO_TARJETA_TIPOTD(P_C_TIPTAR VARCHAR2) RETURN VARCHAR2;
       FUNCTION FN_TMP_CARAC_TARJETA_CARATD(P_C_CODBIN VARCHAR2) RETURN VARCHAR2;
       FUNCTION FN_TMP_VIGEN_TARJETA_VIGETD(P_C_CODBIN VARCHAR2) RETURN NUMBER;
       FUNCTION FN_TMP_LIMIT_TARJETA_LIMITD(P_C_CODLIM VARCHAR2) RETURN NUMBER;
       FUNCTION FN_TMP_ESTAD_TARJETA_ESTATD(P_C_CODEST VARCHAR2) RETURN NUMBER;
       FUNCTION FN_TMP_ESTAD_PLASTICO_ESTAPL(P_C_CODEST VARCHAR2) RETURN VARCHAR2;
       
       PROCEDURE SP_MGMPERS_DATOS(P_C_CODCLI IN VARCHAR2,
                                  P_N_PAIS   OUT NUMBER,
                                  P_N_TDOCUM OUT NUMBER,
                                  P_C_NDOC   OUT VARCHAR2,
                                  P_C_NUMDOC OUT VARCHAR2,                             
                                  P_C_TIPPER OUT VARCHAR2,
                                  P_C_DESERR OUT VARCHAR2); 
    
       FUNCTION FN_BJD005_DCod ( P_N_PAIS   NUMBER,
                                 P_N_TDOCUM NUMBER,
                                 P_C_NDOC   VARCHAR2)RETURN NUMBER;  
                                 
                                 
       FUNCTION FN_AHDTACU_ESPRINCIPAL (P_C_NUMTAR IN VARCHAR2,
                                        P_C_CTACOM IN VARCHAR2) RETURN NUMBER;                                                          
   
       PROCEDURE SP_INS_LOG_CARGA_BANDEJA (P_N_NRO NUMBER, P_C_CODBDJ VARCHAR2, 
                                           P_C_CPTBDJ VARCHAR2, P_D_FECINI DATE);
                                           
       PROCEDURE SP_INS_LOG_ERROR_BANDEJA (P_N_NRO NUMBER, P_C_CODBDJ VARCHAR2, 
                                           P_C_DESERR VARCHAR2, P_D_FECERR DATE);
                                           
       PROCEDURE SP_INS_AHGTARJ(P_N_TIPINS IN NUMBER);
       
       Procedure SP_TC_JAQL068_CNL151;

end PQ_MIGRA_SERVICIOS;
/

