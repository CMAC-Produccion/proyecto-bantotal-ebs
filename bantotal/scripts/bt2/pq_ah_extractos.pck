CREATE OR REPLACE PACKAGE PQ_AH_EXTRACTOS IS
  PROCEDURE SP_AH_REGISTRA_AFILIACION(P_N_JAQL460PGO IN NUMBER,
                                      P_N_JAQL460SUC IN NUMBER,
                                      P_N_JAQL460MOD IN NUMBER,
                                      P_N_JAQL460MDA IN NUMBER,
                                      P_N_JAQL460CTA IN NUMBER,
                                      P_N_JAQL460PAP IN NUMBER,
                                      P_N_JAQL460OPE IN NUMBER,
                                      P_N_JAQL460SUB IN NUMBER,
                                      P_N_JAQL460TOP IN NUMBER,
                                      P_D_JAQL460FCH IN DATE,
                                      P_C_JAQL460USU IN VARCHAR2,
                                      P_N_JAQL460SAF IN NUMBER,
                                      P_N_JAQL460TAF IN NUMBER,
                                      P_C_JAQL460TPR IN VARCHAR2,
                                      P_C_JAQL460TME IN VARCHAR2,
                                      P_N_JAQL460PAI IN NUMBER,
                                      P_N_JAQL460TPO IN NUMBER,
                                      P_C_JAQL460DOC IN VARCHAR2,
                                      P_N_JAQL460CPG IN NUMBER,
                                      P_N_JAQL460CSC IN NUMBER,
                                      P_N_JAQL460CMD IN NUMBER,
                                      P_N_JAQL460CMA IN NUMBER,
                                      P_N_JAQL460CCT IN NUMBER,
                                      P_N_JAQL460CPA IN NUMBER,
                                      P_N_JAQL460COP IN NUMBER,
                                      P_N_JAQL460CSB IN NUMBER,
                                      P_N_JAQL460CTP IN NUMBER,  
                                      P_C_CODE       OUT VARCHAR2,
                                      P_C_ERROR      OUT VARCHAR2                                      
                                     );                                     
                                     
  PROCEDURE SP_AH_REG_GEN_FISICO(P_C_JAQL461USU IN VARCHAR2,
                                 P_D_JAQL461PER IN DATE, 
                                 P_N_JAQL461PGO IN NUMBER,
                                 P_N_JAQL461SUC IN NUMBER, 
                                 P_N_JAQL461MOD IN NUMBER, 
                                 P_N_JAQL461MDA IN NUMBER, 
                                 P_N_JAQL461CTA IN NUMBER, 
                                 P_N_JAQL461PAP IN NUMBER, 
                                 P_N_JAQL461OPE IN NUMBER, 
                                 P_N_JAQL461SUB IN NUMBER, 
                                 P_N_JAQL461TOP IN NUMBER,
                                 P_C_JAQL461EST IN VARCHAR2,
                                 P_N_JAQL461AUX1 IN NUMBER,
                                 P_D_FECGEN      IN DATE                                
                                 );                      
  PROCEDURE SP_AH_REG_CAR_ENTREGA(P_D_JAQL461PER IN DATE, 
                                  P_N_JAQL461PGO IN NUMBER,
                                  P_N_JAQL461SUC IN NUMBER, 
                                  P_N_JAQL461MOD IN NUMBER, 
                                  P_N_JAQL461MDA IN NUMBER, 
                                  P_N_JAQL461CTA IN NUMBER, 
                                  P_N_JAQL461PAP IN NUMBER, 
                                  P_N_JAQL461OPE IN NUMBER, 
                                  P_N_JAQL461SUB IN NUMBER, 
                                  P_N_JAQL461TOP IN NUMBER,
                                  P_D_JAQL461FEC IN DATE,                
                                  P_C_JAQL461MOT IN VARCHAR2,                                    
                                  P_C_JAQL461USE IN VARCHAR2,
                                  P_C_JAQL461EST IN VARCHAR2                                                                
                                 );  
                                 
  PROCEDURE SP_AH_REG_LOG_COBCOM(P_D_JAQL462PER IN DATE, 
                                 P_N_JAQL462FRE IN NUMBER,
                                 P_C_JAQL462MED IN VARCHAR2,
                                 P_C_JAQL462USU IN VARCHAR2,
                                 P_N_JAQL462PGO IN NUMBER,
                                 P_N_JAQL462SUC IN NUMBER, 
                                 P_N_JAQL462MOD IN NUMBER, 
                                 P_N_JAQL462MDA IN NUMBER, 
                                 P_N_JAQL462CTA IN NUMBER, 
                                 P_N_JAQL462PAP IN NUMBER, 
                                 P_N_JAQL462OPE IN NUMBER, 
                                 P_N_JAQL462SUB IN NUMBER, 
                                 P_N_JAQL462TOP IN NUMBER,
                                 P_C_JAQL462MOT IN VARCHAR2,
                                 P_N_JAQL462MTO IN NUMBER,
                                 P_N_JAQL462UBS IN NUMBER,
                                 P_D_JAQL462FVA IN DATE,
                                 P_N_JAQL462MDO IN NUMBER,
                                 P_N_JAQL462TRN IN NUMBER,                                 
                                 P_N_JAQL462REL IN NUMBER,
                                 P_D_FECGEN     IN DATE                                                                                                   
                                 );                                                                
                                             
  PROCEDURE SP_AH_GEN_EXTRACTO(p_c_usuario in VARCHAR2,
                               p_c_cuenta  in VARCHAR2,
                               p_d_fecape  in date,
                               p_c_despro  in VARCHAR2,
                               p_n_monape  in number,
                               p_n_tastea  in number,
                               p_c_tipcta  in VARCHAR2,
                               p_n_saltot  in number,
                               p_n_salint  in number,
                               p_n_saldis  in number,
                               p_c_desmon  in VARCHAR2,
                               p_c_titula  in VARCHAR2,
                               p_c_estado  in VARCHAR2,
                               p_c_desage  in VARCHAR2,
                               p_d_fecgen  in date,
                               p_c_claext  in varchar2
                               );
  
  PROCEDURE SP_AH_ENVIO_MAIL(p_c_usuario in VARCHAR2,p_d_fecgen IN DATE);                              
  PROCEDURE SP_AH_DEL_DATA(p_c_usuario in VARCHAR2,p_d_fecgen in date );
  PROCEDURE SP_AH_ENVIO_CONF(p_c_usuario in VARCHAR2, p_d_fecgen in DATE);
  PROCEDURE SP_AH_GEN_CRON_PAG(p_c_usuario in VARCHAR2,
                               p_c_cuenta  in VARCHAR2,                               
                               p_c_numcre  in VARCHAR2,
                               p_c_nomtit  in VARCHAR2,
                               p_d_fecdes  in date,
                               p_c_desmon  in VARCHAR2,
                               p_n_mondes  in number,
                               p_c_numdoc  in VARCHAR2,
                               p_c_nomana  in VARCHAR2,
                               p_n_plazos  in number,
                               p_n_moncuo  in number,
                               p_c_desage  in VARCHAR2,
                               p_n_tastea  in number,
                               p_n_numcuo  in number,
                               p_n_totcap  in number,
                               p_n_numcpe  in number,
                               p_n_tatcea  in number,
                               p_n_cancuo  in number,
                               p_d_fecgen  in date,
                               p_c_claext  in varchar2                                                                                                                                                                                          
                               );
  PROCEDURE SP_AH_VALIDAR_FECHA(P_D_FECGEN IN DATE,
                                P_N_FRECUE IN NUMBER,              
                                P_C_INDGEN OUT VARCHAR2,
                                P_D_FECINI OUT DATE,
                                P_D_FECFIN OUT DATE
                               );
PROCEDURE SP_AH_VERIFICA_GEN(P_D_FECGEN IN DATE,
                               P_C_TIPGEN IN VARCHAR2,
                               P_C_CTACLI IN VARCHAR2,
                               P_C_CODUSU IN VARCHAR2,
                               P_N_FRECUE IN NUMBER,                               
                               P_C_INDGEN OUT VARCHAR2
                               );
  
  PROCEDURE SP_AH_VAL_GEN_MAIL(P_D_FECGEN IN DATE,
                               P_C_CTACLI IN VARCHAR2,
                               P_C_CODUSU IN VARCHAR2,
                               P_C_INDGEN OUT VARCHAR2
                               );
  PROCEDURE SP_AH_VAL_GEN_COBR(P_D_FECGEN IN DATE,
                               P_C_CTACLI IN VARCHAR2,
                              -- P_C_CODUSU IN VARCHAR2,
                               P_C_INDGEN OUT VARCHAR2
                               );                               
  FUNCTION FN_AH_VER_EXISTE(P_D_FECGEN IN DATE,
                            P_C_CTACLI IN VARCHAR2,
                            P_C_MAIL   IN VARCHAR2,
                            P_C_CODUSU IN VARCHAR2
                            )RETURN VARCHAR2;         
  PROCEDURE SP_AH_REG_COM(P_D_JAQL487PER IN DATE, 
                          P_N_JAQL487FRE IN NUMBER,
                          P_C_JAQL487MED IN VARCHAR2,
                          P_C_JAQL487USU IN VARCHAR2,
                          P_N_JAQL487PGO IN NUMBER,
                          P_N_JAQL487SUC IN NUMBER, 
                          P_N_JAQL487MOD IN NUMBER, 
                          P_N_JAQL487MDA IN NUMBER, 
                          P_N_JAQL487CTA IN NUMBER, 
                          P_N_JAQL487PAP IN NUMBER, 
                          P_N_JAQL487OPE IN NUMBER, 
                          P_N_JAQL487SUB IN NUMBER, 
                          P_N_JAQL487TOP IN NUMBER,
                          P_N_JAQL487MTO IN NUMBER,
                          P_N_JAQL487UBS IN NUMBER,
                          P_N_JAQL487FVA IN DATE,
                          P_N_JAQL487MDO IN NUMBER,
                          P_N_JAQL487TRN IN NUMBER,                                 
                          P_N_JAQL487REL IN NUMBER,
                          P_D_JAQL487FGE IN DATE,
                          P_C_JAQL487CTE IN VARCHAR2
                         );                              
  PROCEDURE SP_AH_BORRA_INCIDENCIA(P_D_FECGEN IN DATE,
                                   P_C_CTACLI IN VARCHAR2,    
                                   P_C_CODUSU IN VARCHAR2
                                   );
END PQ_AH_EXTRACTOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_EXTRACTOS IS
  PROCEDURE SP_AH_REGISTRA_AFILIACION(P_N_JAQL460PGO IN NUMBER,
                                      P_N_JAQL460SUC IN NUMBER,
                                      P_N_JAQL460MOD IN NUMBER,
                                      P_N_JAQL460MDA IN NUMBER,
                                      P_N_JAQL460CTA IN NUMBER,
                                      P_N_JAQL460PAP IN NUMBER,
                                      P_N_JAQL460OPE IN NUMBER,
                                      P_N_JAQL460SUB IN NUMBER,
                                      P_N_JAQL460TOP IN NUMBER,
                                      P_D_JAQL460FCH IN DATE,
                                      P_C_JAQL460USU IN VARCHAR2,
                                      P_N_JAQL460SAF IN NUMBER,
                                      P_N_JAQL460TAF IN NUMBER,
                                      P_C_JAQL460TPR IN VARCHAR2,
                                      P_C_JAQL460TME IN VARCHAR2,
                                      P_N_JAQL460PAI IN NUMBER,
                                      P_N_JAQL460TPO IN NUMBER,
                                      P_C_JAQL460DOC IN VARCHAR2,
                                      P_N_JAQL460CPG IN NUMBER,
                                      P_N_JAQL460CSC IN NUMBER,
                                      P_N_JAQL460CMD IN NUMBER,
                                      P_N_JAQL460CMA IN NUMBER,
                                      P_N_JAQL460CCT IN NUMBER,
                                      P_N_JAQL460CPA IN NUMBER,
                                      P_N_JAQL460COP IN NUMBER,
                                      P_N_JAQL460CSB IN NUMBER,
                                      P_N_JAQL460CTP IN NUMBER,  
                                      P_C_CODE       OUT VARCHAR2,
                                      P_C_ERROR      OUT VARCHAR2                                      
                                     ) IS    
  LD_JAQL460FX1 date;
  LD_JAQL460AX4 char(20);
                                       
  BEGIN
  P_C_CODE := '0';
  
  If P_C_JAQL460TME = 'N' then
     LD_JAQL460FX1 := P_D_JAQL460FCH;
     LD_JAQL460AX4 := P_C_JAQL460USU;     
  Else   
     LD_JAQL460FX1 := null;
     LD_JAQL460AX4 := null;
  End If;
  
  if trim(P_C_JAQL460TME) is not null then
         INSERT INTO JAQL460 (JAQL460PGO,
                              JAQL460SUC,
                              JAQL460MOD,
                              JAQL460MDA,
                              JAQL460CTA,
                              JAQL460PAP,
                              JAQL460OPE,
                              JAQL460SUB,
                              JAQL460TOP,
                              JAQL460FCH,
                              JAQL460USU,
                              JAQL460SAF,
                              JAQL460TAF,
                              JAQL460TPR,
                              JAQL460TME,
                              JAQL460PAI,
                              JAQL460TPO,
                              JAQL460DOC,
                              JAQL460CPG,
                              JAQL460CSC,
                              JAQL460CMD,
                              JAQL460CMA,
                              JAQL460CCT,
                              JAQL460CPA,
                              JAQL460COP,
                              JAQL460CSB,
                              JAQL460CTP,
                              JAQL460FX1,
                              JAQL460AX4,
                              JAQL460AX5
                              )
                        VALUES(P_N_JAQL460PGO,
                               P_N_JAQL460SUC,
                               P_N_JAQL460MOD,
                               P_N_JAQL460MDA,
                               P_N_JAQL460CTA,
                               P_N_JAQL460PAP,
                               P_N_JAQL460OPE,
                               P_N_JAQL460SUB,
                               P_N_JAQL460TOP,
                               P_D_JAQL460FCH,
                               P_C_JAQL460USU,
                               P_N_JAQL460SAF,
                               P_N_JAQL460TAF,
                               P_C_JAQL460TPR,
                               P_C_JAQL460TME,
                               P_N_JAQL460PAI,
                               P_N_JAQL460TPO,
                               P_C_JAQL460DOC,
                               P_N_JAQL460CPG,
                               P_N_JAQL460CSC,
                               P_N_JAQL460CMD,
                               P_N_JAQL460CMA,
                               P_N_JAQL460CCT,
                               P_N_JAQL460CPA,
                               P_N_JAQL460COP,
                               P_N_JAQL460CSB,
                               P_N_JAQL460CTP,
                               LD_JAQL460FX1,
                               LD_JAQL460AX4,
                               to_char(sysdate,'HH24:MI:SS') 
                              );
                              COMMIT;
  end if;                              
  EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
       BEGIN
         IF P_C_JAQL460TME = 'N' THEN               
           UPDATE JAQL460
              SET JAQL460FX1 = LD_JAQL460FX1,
                  JAQL460AX4 = LD_JAQL460AX4,
                  JAQL460TAF = P_N_JAQL460TAF,
                  JAQL460TPR = P_C_JAQL460TPR,
                  JAQL460TME = P_C_JAQL460TME,                  
                  JAQL460PAI = 0,
                  JAQL460TPO = 0,
                  JAQL460DOC = 0,
                  JAQL460CPG = 0,
                  JAQL460CSC = 0,
                  JAQL460CMD = 0,
                  JAQL460CMA = 0,
                  JAQL460CCT = 0,
                  JAQL460CPA = 0,
                  JAQL460COP = 0,
                  JAQL460CSB = 0,
                  JAQL460CTP = 0,
                  JAQL460AX6 = to_char(sysdate,'HH24:MI:SS')                    
            WHERE JAQL460PGO = P_N_JAQL460PGO
              AND JAQL460SUC = P_N_JAQL460SUC
              AND JAQL460MOD = P_N_JAQL460MOD
              AND JAQL460MDA = P_N_JAQL460MDA
              AND JAQL460CTA = P_N_JAQL460CTA
              AND JAQL460PAP = P_N_JAQL460PAP
              AND JAQL460OPE = P_N_JAQL460OPE
              AND JAQL460SUB = P_N_JAQL460SUB
              AND JAQL460TOP = P_N_JAQL460TOP;
              
        ELSIF P_C_JAQL460TME = 'M' THEN
         UPDATE JAQL460
              SET /*JAQL460FCH = P_D_JAQL460FCH,
                  JAQL460USU = P_C_JAQL460USU,
                  JAQL460SAF = P_N_JAQL460SAF,*/
                  
                  JAQL460TAF = P_N_JAQL460TAF,
                  JAQL460TPR = P_C_JAQL460TPR,
                  JAQL460TME = P_C_JAQL460TME,
                  JAQL460PAI = 0,
                  JAQL460TPO = 0,
                  JAQL460DOC = 0,
                  JAQL460CPG = 0,
                  JAQL460CSC = 0,
                  JAQL460CMD = 0,
                  JAQL460CMA = 0,
                  JAQL460CCT = 0,
                  JAQL460CPA = 0,
                  JAQL460COP = 0,
                  JAQL460CSB = 0,
                  JAQL460CTP = 0,
                  JAQL460AX5 = to_char(sysdate,'HH24:MI:SS')                    
            WHERE JAQL460PGO = P_N_JAQL460PGO
              AND JAQL460SUC = P_N_JAQL460SUC
              AND JAQL460MOD = P_N_JAQL460MOD
              AND JAQL460MDA = P_N_JAQL460MDA
              AND JAQL460CTA = P_N_JAQL460CTA
              AND JAQL460PAP = P_N_JAQL460PAP
              AND JAQL460OPE = P_N_JAQL460OPE
              AND JAQL460SUB = P_N_JAQL460SUB
              AND JAQL460TOP = P_N_JAQL460TOP;         
              null;
        ELSE           
         UPDATE JAQL460
              SET JAQL460FCH = P_D_JAQL460FCH,
                  JAQL460USU = P_C_JAQL460USU,
                  JAQL460SAF = P_N_JAQL460SAF,
                  JAQL460TAF = P_N_JAQL460TAF,
                  JAQL460TPR = P_C_JAQL460TPR,
                  JAQL460TME = P_C_JAQL460TME,
                  JAQL460PAI = P_N_JAQL460PAI,
                  JAQL460TPO = P_N_JAQL460TPO,
                  JAQL460DOC = P_C_JAQL460DOC,
                  JAQL460CPG = P_N_JAQL460CPG,
                  JAQL460CSC = P_N_JAQL460CSC,
                  JAQL460CMD = P_N_JAQL460CMD,
                  JAQL460CMA = P_N_JAQL460CMA,
                  JAQL460CCT = P_N_JAQL460CCT,
                  JAQL460CPA = P_N_JAQL460CPA,
                  JAQL460COP = P_N_JAQL460COP,
                  JAQL460CSB = P_N_JAQL460CSB,
                  JAQL460CTP = P_N_JAQL460CTP,
                  JAQL460AX5 = to_char(sysdate,'HH24:MI:SS')                    
            WHERE JAQL460PGO = P_N_JAQL460PGO
              AND JAQL460SUC = P_N_JAQL460SUC
              AND JAQL460MOD = P_N_JAQL460MOD
              AND JAQL460MDA = P_N_JAQL460MDA
              AND JAQL460CTA = P_N_JAQL460CTA
              AND JAQL460PAP = P_N_JAQL460PAP
              AND JAQL460OPE = P_N_JAQL460OPE
              AND JAQL460SUB = P_N_JAQL460SUB
              AND JAQL460TOP = P_N_JAQL460TOP;        
        END IF;    
        COMMIT;    
       END;
  
  WHEN OTHERS THEN
    P_C_CODE  := sqlcode;
    P_C_ERROR := sqlerrm;  
  END SP_AH_REGISTRA_AFILIACION;
  
  PROCEDURE SP_AH_REG_GEN_FISICO(P_C_JAQL461USU IN VARCHAR2,
                                 P_D_JAQL461PER IN DATE, 
                                 P_N_JAQL461PGO IN NUMBER,
                                 P_N_JAQL461SUC IN NUMBER, 
                                 P_N_JAQL461MOD IN NUMBER, 
                                 P_N_JAQL461MDA IN NUMBER, 
                                 P_N_JAQL461CTA IN NUMBER, 
                                 P_N_JAQL461PAP IN NUMBER, 
                                 P_N_JAQL461OPE IN NUMBER, 
                                 P_N_JAQL461SUB IN NUMBER, 
                                 P_N_JAQL461TOP IN NUMBER,
                                 P_C_JAQL461EST IN VARCHAR2,
                                 P_N_JAQL461AUX1 IN NUMBER,
                                 P_D_FECGEN      IN DATE
                                 ) IS
  ln_correla number := 0;                                 
  BEGIN
  
  select nvl(max(JAQL461COR),0) into ln_correla from jaql461;   
  ln_correla := ln_correla + 1;
  
  INSERT INTO JAQL461(JAQL461COR,
                      JAQL461USU,
                      JAQL461FCH,
                      JAQL461HRG,
                      JAQL461PER,
                      JAQL461PGO,
                      JAQL461SUC,
                      JAQL461MOD,
                      JAQL461MDA,
                      JAQL461CTA,
                      JAQL461PAP,
                      JAQL461OPE,
                      JAQL461SUB,
                      JAQL461TOP,
                      JAQL461EST,
                      JAQL461AX1
                      )
               VALUES(ln_correla,
                      P_C_JAQL461USU,               
                      p_d_fecgen, 
                      to_char(sysdate,'HH24:mi:ss'),              
                      P_D_JAQL461PER,                
                      P_N_JAQL461PGO,               
                      P_N_JAQL461SUC,                
                      P_N_JAQL461MOD,                
                      P_N_JAQL461MDA,                
                      P_N_JAQL461CTA,                
                      P_N_JAQL461PAP,                
                      P_N_JAQL461OPE,                
                      P_N_JAQL461SUB,                
                      P_N_JAQL461TOP,
                      P_C_JAQL461EST,
                      P_N_JAQL461AUX1
                     );
  COMMIT; 
  END SP_AH_REG_GEN_FISICO;                                      
  
  PROCEDURE SP_AH_REG_CAR_ENTREGA(P_D_JAQL461PER IN DATE, 
                                  P_N_JAQL461PGO IN NUMBER,
                                  P_N_JAQL461SUC IN NUMBER, 
                                  P_N_JAQL461MOD IN NUMBER, 
                                  P_N_JAQL461MDA IN NUMBER, 
                                  P_N_JAQL461CTA IN NUMBER, 
                                  P_N_JAQL461PAP IN NUMBER, 
                                  P_N_JAQL461OPE IN NUMBER, 
                                  P_N_JAQL461SUB IN NUMBER, 
                                  P_N_JAQL461TOP IN NUMBER,
                                  P_D_JAQL461FEC IN DATE,                
                                  P_C_JAQL461MOT IN VARCHAR2,                                    
                                  P_C_JAQL461USE IN VARCHAR2,
                                  P_C_JAQL461EST IN VARCHAR2
                                 ) IS
  BEGIN
  
  UPDATE JAQL461
     SET JAQL461FEC = P_D_JAQL461FEC, 
         JAQL461MOT = P_C_JAQL461MOT,
         JAQL461USE = P_C_JAQL461USE,
         JAQL461EST = P_C_JAQL461EST
   WHERE JAQL461PER = P_D_JAQL461PER
     AND JAQL461PGO = P_N_JAQL461PGO
     AND JAQL461SUC = P_N_JAQL461SUC
     AND JAQL461MOD = P_N_JAQL461MOD
     AND JAQL461MDA = P_N_JAQL461MDA
     AND JAQL461CTA = P_N_JAQL461CTA
     AND JAQL461PAP = P_N_JAQL461PAP
     AND JAQL461OPE = P_N_JAQL461OPE
     AND JAQL461SUB = P_N_JAQL461SUB
     AND JAQL461TOP = P_N_JAQL461TOP;
  COMMIT;
  
  END SP_AH_REG_CAR_ENTREGA;    
                
  PROCEDURE SP_AH_REG_LOG_COBCOM(P_D_JAQL462PER IN DATE, 
                                 P_N_JAQL462FRE IN NUMBER,
                                 P_C_JAQL462MED IN VARCHAR2,
                                 P_C_JAQL462USU IN VARCHAR2,
                                 P_N_JAQL462PGO IN NUMBER,
                                 P_N_JAQL462SUC IN NUMBER, 
                                 P_N_JAQL462MOD IN NUMBER, 
                                 P_N_JAQL462MDA IN NUMBER, 
                                 P_N_JAQL462CTA IN NUMBER, 
                                 P_N_JAQL462PAP IN NUMBER, 
                                 P_N_JAQL462OPE IN NUMBER, 
                                 P_N_JAQL462SUB IN NUMBER, 
                                 P_N_JAQL462TOP IN NUMBER,
                                 P_C_JAQL462MOT IN VARCHAR2,
                                 P_N_JAQL462MTO IN NUMBER,
                                 P_N_JAQL462UBS IN NUMBER,
                                 P_D_JAQL462FVA IN DATE,
                                 P_N_JAQL462MDO IN NUMBER,
                                 P_N_JAQL462TRN IN NUMBER,                                 
                                 P_N_JAQL462REL IN NUMBER,
                                 P_D_FECGEN     IN DATE
                                 ) IS
  ln_correla number := 0;                                 
  BEGIN
  
  select nvl(max(JAQL462COR),0) into ln_correla from jaql462;   
  ln_correla := ln_correla + 1;
  
  INSERT INTO JAQL462(JAQL462COR,
                      JAQL462FCH,
                      JAQL462HRG,
                      JAQL462PER,
                      JAQL462FRE,
                      JAQL462MED,
                      JAQL462USU,
                      JAQL462PGO,
                      JAQL462SUC,
                      JAQL462MOD,
                      JAQL462MDA,
                      JAQL462CTA,
                      JAQL462PAP,
                      JAQL462OPE,
                      JAQL462SUB,
                      JAQL462TOP,
                      JAQL462MOT,
                      JAQL462MTO,
                      JAQL462UBS,
                      JAQL462FVA,
                      JAQL462MDO,
                      JAQL462TRN,                                 
                      JAQL462REL                                                                             
                      )
               VALUES(ln_correla,
                      p_d_fecgen, 
                      to_char(sysdate,'HH24:mi:ss'),              
                      P_D_JAQL462PER,              
                      P_N_JAQL462FRE,
                      P_C_JAQL462MED,
                      P_C_JAQL462USU,                               
                      P_N_JAQL462PGO,               
                      P_N_JAQL462SUC,                
                      P_N_JAQL462MOD,                
                      P_N_JAQL462MDA,                
                      P_N_JAQL462CTA,                
                      P_N_JAQL462PAP,                
                      P_N_JAQL462OPE,                
                      P_N_JAQL462SUB,                
                      P_N_JAQL462TOP,
                      P_C_JAQL462MOT,
                      P_N_JAQL462MTO,
                      P_N_JAQL462UBS,
                      P_D_JAQL462FVA,
                      P_N_JAQL462MDO,
                      P_N_JAQL462TRN,                                 
                      P_N_JAQL462REL                      
                     );
  COMMIT; 
  END SP_AH_REG_LOG_COBCOM;    
                 
  PROCEDURE SP_AH_GEN_EXTRACTO(p_c_usuario in VARCHAR2,
                               p_c_cuenta  in VARCHAR2,
                               p_d_fecape  in date,
                               p_c_despro  in VARCHAR2,
                               p_n_monape  in number,
                               p_n_tastea  in number,
                               p_c_tipcta  in VARCHAR2,
                               p_n_saltot  in number,
                               p_n_salint  in number,
                               p_n_saldis  in number,
                               p_c_desmon  in VARCHAR2,
                               p_c_titula  in VARCHAR2,
                               p_c_estado  in VARCHAR2,
                               p_c_desage  in VARCHAR2,
                               p_d_fecgen  in date,
                               p_c_claext  in varchar2
                               ) IS
    
    lc_nomtit     VARCHAR2(800);  
    ln_totret     NUMBER:=0;
    ln_totdep     NUMBER:=0;
    ln_cta        number(9);
--    ln_correla    number(10);
    ll_mensaje CLOB;
    lc_cuenta  varchar2(27);
    lc_usuario char(10);
    ln_cont    number:=0;

    cursor c_movimientos(lc_claext in varchar2) is
    select JAQY220USU,JAQY220MOV,JAQY220FMV,JAQY220CCT,
           case
           when TO_CHAR(JAQY220FVL,'RRRR.MM.DD') = '0001.01.01' then
           ''
           else
           to_char(JAQY220FMV,'DD/MM/YY')
           end JAQY220FVL,
           case
           when trim(JAQY220CH3) is not null then
           JAQY220CH3
           else
           JAQY220DSC
           end JAQY220DSC,
           JAQY220DOC,JAQY220DEP,JAQY220RET,
           JAQY220SDO,JAQY220OPE,JAQY220AGE,JAQY220HOR,JAQY220CH3,JAQY220MT1
      from jaqy220
     where JAQY220USU = lc_claext 
     order by JAQY220FMV,JAQY220HOR,JAQY220OMD,JAQY220COR  ;  
     
    cursor c_mail(ln_cta in number) is
    select distinct
           substr(ctxtxt, 1, instr(ctxtxt, '\') - 1) p_c_mailre
      from FSX008
     Where pgcod = 1
       and Txcod = 0
       and ctnro = ln_cta
  order by 1; 

  lc_error varchar2(4000);  
  ln_cadena number:= 0;
  ln_ini number:= 0;
  ln_pos number:= 0;  
  lc_valor varchar2(50);  
  lc_titpri varchar2(40);
  ln_cont2 number := 0;
  lv_mensaje    VARCHAR2(32767);
  lv_mensaje2   VARCHAR2(32767);
  ln_tope number(3);
  ln_mod  number(3);
  lc_fecha char(8);
  lc_claext char(10);
  
  lc_guardadito varchar2(20):=' ';
  lc_flag       char(1):='N';
  lc_flagx      char(1):='N';  
  ln_mda number(3):=0;       
  ln_sbo number(3):=0; 
  ln_Sdogu  number(17,2):=0; 
  ln_Sdogu1 number(17,2):=0;   
  ln_salrem number(17,2):=0; 
  ln_salter number(17,2):=0;   
  ln_suc    number(3);
  ln_monto  number(17,2):=0;
  lc_texto  varchar2(25):='';
  ld_Pgfape date;
  BEGIN
  
  commit;
  
  dbms_lob.createtemporary(ll_mensaje, TRUE);  
  
--  select nvl(max(JAQL452COR),0) into ln_correla from jaql452;   
--  ln_correla := ln_correla + 1;
    
  -- DATOS DE CABECERA DEL EXTRACTO
  lc_usuario := rpad(P_C_USUARIO,10,' ');
  lc_claext  := lpad(p_c_claext,10,'0');
  lc_cuenta  := trim(p_c_cuenta);
  ln_cta     := to_number(substr(lc_cuenta, 1, 9));
  ln_mod     := to_number(substr(lc_cuenta, 10,3));
  ln_mda     := to_number(substr(lc_cuenta, 13,3));
  ln_sbo     := to_number(substr(lc_cuenta, 16,2));
  ln_cadena  := length(p_c_titula);
  ln_ini     := 1;
  ln_pos     := 1;
  
  if ln_mod = 21 then 
     ln_tope := to_number(substr(lc_cuenta, 18,3)); 
  End If;
  
  while ln_ini <= ln_cadena loop  
     begin
       select instr(p_c_titula,'*#*',ln_ini,1)
         into ln_ini
         from dual; 
     exception
     when others then
          null;    
     end; 
          
  lc_valor := substr(p_c_titula,ln_pos,(ln_ini-ln_pos)); 
  ln_ini   := ln_ini + 3;
  ln_pos   := ln_ini;
               
  lc_nomtit := lc_nomtit||lc_valor|| '<br/>';    
           
  end loop; 
      
  If to_char(p_d_fecape,'dd/mm/yy') = '01/01/01' then
     lc_fecha := ' / / ' ;
  else
     lc_fecha := to_char(p_d_fecape,'dd/mm/yy');
  end If;   
  
  begin
  
    select a.ctnom
      into lc_titpri
      from fsd008 a
     Where a.ctnro = ln_cta;
  exception
  when no_data_found then
    lc_error:= 'CUENTA NO POSEE TITULAR';     
  when others  then
    lc_error:= sqlcode||'-'||sqlerrm;
  end;    
  
  begin  
    select a.pgfape
      into ld_Pgfape
      from fst017 a
     Where a.pgcod = 1;
  exception
  when others  then
    ld_Pgfape:= trunc(sysdate);
  end;      
 
 if ln_mod = 21 then           
 --valida guardadito
 
    begin
      select 'S' 
        into lc_flag
        from JAQZ157
       Where JAQZ157PGC = 1 
         and JAQZ157MOD = ln_mod
         --and JAQZ157SUC = &Scsuc 
         and JAQZ157MDA = ln_mda 
         and JAQZ157PAP = 0
         and JAQZ157CTA = ln_cta
         and JAQZ157OPE = 0
         and JAQZ157SUB = ln_sbo 
         and JAQZ157TOP = ln_tope 
         and JAQZ157EST = 'A'
         and trim(JAQZ157AX8) = 'T'
         and rownum =1;
    exception
    when others then
      lc_flag := 'N';
    end; 
    
 --valida extra programado
 
    begin
      select 'S' 
        into lc_flagx
        from JAQZ157
       Where JAQZ157PGC = 1 
         and JAQZ157MOD = ln_mod
         --and JAQZ157SUC = &Scsuc 
         and JAQZ157MDA = ln_mda 
         and JAQZ157PAP = 0
         and JAQZ157CTA = ln_cta
         and JAQZ157OPE = 0
         and JAQZ157SUB = ln_sbo 
         and JAQZ157TOP = ln_tope 
         and JAQZ157EST = 'A'
         and trim(JAQZ157AX8) = 'P'
         and rownum =1;
    exception
    when others then
      lc_flagx := 'N';
    end;     

   if lc_flag = 'S' OR lc_flagx = 'S' then    
      IF lc_flag = 'S' THEN
        begin
          select nvl(sum(a.Scsdo),0)
            into ln_Sdogu
            from fsd011  a,
                 jaqz157 b
           Where a.pgcod  = b.jaqz157pgg
             and a.scmod  = b.jaqz157mog
             and a.scmda  = b.jaqz157mdg 
             and a.scpap  = b.jaqz157pag
             and a.sccta  = b.jaqz157ctg
             and a.scoper = b.jaqz157opg
             and a.scsbop = b.jaqz157sbg
             and a.pgcod  = b.jaqz157pgc
             and a.scmda  = b.jaqz157mda
             and a.scpap  = b.jaqz157pap
             and a.sccta  = b.jaqz157cta
             and a.scsbop = b.jaqz157sub
             and TRIM(b.jaqz157ax8) = 'T'
             and a.PgCod  = 1
                --and Scsuc  = &Scsuc 
             and a.Scrub  = 9300071900000
             and a.Scmda  = ln_mda
             and a.Scpap  = 0
             and a.Sccta  = ln_cta
             and a.Scsbop = ln_sbo;
        exception
        when others then
          ln_Sdogu := 0;
        end;
      END IF;
      IF lc_flagx = 'S' THEN
        begin
          select nvl(sum(a.Scsdo),0)
            into ln_Sdogu1
            from fsd011  a,
                 jaqz157 b
           Where a.pgcod  = b.jaqz157pgg
             and a.scmod  = b.jaqz157mog
             and a.scmda  = b.jaqz157mdg 
             and a.scpap  = b.jaqz157pag
             and a.sccta  = b.jaqz157ctg
             and a.scoper = b.jaqz157opg
             and a.scsbop = b.jaqz157sbg
             and a.pgcod  = b.jaqz157pgc
             and a.scmda  = b.jaqz157mda
             and a.scpap  = b.jaqz157pap
             and a.sccta  = b.jaqz157cta
             and a.scsbop = b.jaqz157sub
             and TRIM(b.jaqz157ax8) = 'P'
             and a.PgCod  = 1
                --and Scsuc  = &Scsuc 
             and a.Scrub  = 9300071900000
             and a.Scmda  = ln_mda
             and a.Scpap  = 0
             and a.Sccta  = ln_cta
             and a.Scsbop = ln_sbo;
        exception
        when others then
          ln_Sdogu1 := 0;
        end;
      END IF;      
      /*
      if ln_Sdogu > 0 then
         lc_guardadito := 'Guardadito: SI';
      else
         lc_guardadito := '';
      End if;
      */
      if lc_flag = 'S' then
         lc_guardadito := 'Guardadito: SI';
      End If;
      if lc_flagx = 'S' then
         lc_guardadito := 'Extra Programado: SI';
      End If;      
   End If;  
 end if;   
          lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado(a)(s) : </p>' ||  
                        '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">'|| lc_titpri || '</p>' ||
                        '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">De acuerdo a lo solicitado adjunto se remite el extracto de la cuenta a la fecha.</p><br/>';  
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                        
          lv_mensaje := --ll_mensaje ||                                                
          '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
          '<table cellspacing=0 cellpadding=0 width=942>' ||
          '  <tr>' ||
          '    <td align="center" colspan="2">CAJA AREQUIPA - SISTEMA DE DEPOSITOS</td>' ||
          '  </tr>' ||
          '  <tr>' ||
          '    <td align="center" colspan="2">EXTRACTO DE CUENTA</td>' ||
          '  </tr>' ||
          '  <tr>' ||
          '    <td width="74" align="left">Fecha :</td>' ||
          '    <td width="724" align="left">'||to_char(ld_Pgfape, 'DD/MM/RRRR') ||'</td>' ||
          '  </tr>    ' ||
          '  <tr>    ' ||
          '    <td align="left" style="border-bottom: 1px solid black;">Hora : </td>' ||
          '    <td align="left" style="border-bottom: 1px solid black;">'||to_char(SYSDATE, 'HH24:MI:SS')||'</td>  ' ||          
          '  </tr>' ||
          '</table>' ||
          '<table cellspacing=0 cellpadding=0 width=942>' ||
          '  <tr>' ||
          '    <td width="104" align="left">Product. :</td>' ||
          '    <td width="270" align="left">'|| initcap(trim(p_c_despro)) ||'</td>' ||
          '    <td width="77" align="left">Fecha :</td>' ||
          '    <td width="162" align="left">'||lc_fecha/*to_char(p_d_fecape,'DD/MM/YY')*/ ||'</td>' ||
          '    <td width="93" align="left">Moneda :</td>' ||
          '    <td width="234" align="left">'||trim(p_c_desmon) ||'</td>        ' ||
          '  </tr>    ';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
          
          if length(lc_cuenta)= 27 then              
          lv_mensaje := --ll_mensaje ||                                                          
          
          '  <tr>' ||
          '    <td width="104" align="left">Cuenta :</td>' ||
          '    <td width="270" align="left">'||rpad(lc_cuenta,27,' ') ||'</td>' ||
          '    <td width="77" align="left">Monto :</td>' ||
          '    <td width="162" align="left">'||to_char(p_n_monape,'9,999,990.90')||'</td>' ||
          '    <td width="93" align="left">Estado :</td>' ||
          '    <td width="234" align="left">'|| initcap(p_c_estado) ||'</td>  ' ||      
          '  </tr>    '||
          '  <tr>' ||
          '    <td width="104" align="left">Agencia :</td>' ||
          '    <td width="270" align="left">'||rpad(p_c_desage,25,' ') ||'</td>' ||
          '    <td width="77" align="left">T.E.A. %:</td>' ||
          '    <td width="162" align="left">'|| to_char(p_n_tastea,'90.90') ||'</td>' ||
          '    <td width="93" align="left">Tipo Cta. :</td>' ||
          '    <td width="234" align="left">'|| trim(p_c_tipcta) ||'</td>    ' ||                        
          '  </tr>  '||
          '  <tr>' ||
          '    <td width="104" align="left">&nbsp;</td>' ||
          '    <td width="270" align="left">&nbsp;</td>' ||
          '    <td width="77" align="left">T.R.E.A%:</td>' ||
          '    <td width="162" align="left">'||to_char(p_n_tastea,'90.90')||'</td>' ||
          '    <td width="93" align="left">&nbsp;</td>' ||
          '    <td width="234" align="left">&nbsp;</td>    ' ||                        
          '  </tr>  ';              
          else
          lv_mensaje := --ll_mensaje ||                                                          
          
          '  <tr>' ||
          '    <td width="104" align="left">Cuenta :</td>' ||
          '    <td width="270" align="left">'||rpad(lc_cuenta,27,' ') ||'</td>' ||
          '    <td width="77" align="left">T.E.A. %:</td>' ||
          '    <td width="162" align="left">'|| to_char(p_n_tastea,'90.90') ||'</td>' ||
          '    <td width="93" align="left">Estado :</td>' ||
          '    <td width="234" align="left">'|| initcap(p_c_estado) ||'</td>  ' ||      
          '  </tr>    '||
          '  <tr>' ||
          '    <td width="104" align="left">Agencia :</td>' ||
          '    <td width="270" align="left">'||rpad(p_c_desage,25,' ') ||'</td>' ||
          '    <td width="77" align="left">T.R.E.A%:</td>' ||
          '    <td width="162" align="left">'||to_char(p_n_tastea,'90.90')||'</td>' ||
          '    <td width="93" align="left">Tipo Cta. :</td>' ||
          '    <td width="234" align="left">'|| trim(p_c_tipcta) ||'</td>    ' ||                        
          '  </tr>  '||
          '  <tr>' ||
          '    <td width="104" align="left">&nbsp;</td>' ||
          '    <td width="270" align="left">&nbsp;</td>' ||
          '    <td width="77" align="left">&nbsp;</td>' ||
          '    <td width="162" align="left">&nbsp;</td>' ||
          '    <td width="93" align="left">&nbsp;</td>' ||
          '    <td width="234" align="left">&nbsp;</td>    ' ||                        
          '  </tr>  ';                        
          end if;          
          
          
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                        
          lv_mensaje := --ll_mensaje ||                              
          '  <tr>' ||
          '    <td width="104" align="left" valign="top">Cliente :</td>' ||
          '    <td colspan =4 align="left">'||lc_nomtit ||'</td>' ||
          '    <td align="left" valign="top" width="104">'||lc_guardadito ||'</td>' ||          
          '  </tr>  ' ||
          '</table>' ||
          '<br/>';       
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
          
          IF ln_mod = 22 then
            lc_texto := 'Capital+Interes';
          Else
            lc_texto := 'S. Contable';
          End If;
                                                          
          lv_mensaje := --ll_mensaje ||
          '<table cellspacing=0 cellpadding=2 width=942>'||
          '  <tr>'||
          '    <td width="67" style="border-bottom: 1px solid black;"><b>Movim</b></td>'||
          '    <td width="80" style="border-bottom: 1px solid black;"><b>Fecha</b></td>'||
          '    <td width="78" style="border-bottom: 1px solid black;"><b>Hora</b></td> '||
          '    <td width="83" style="border-bottom: 1px solid black;"><b>Tipo Op.</b></td>'||
          '    <td width="80" style="border-bottom: 1px solid black;"><b>F.Val/De</b></td>'||
          '    <td width="98" style="border-bottom: 1px solid black;"><b>Descripci&oacute;n</b></td> '||
          '    <td width="99" style="border-bottom: 1px solid black;"><b>Nro. Doc.</b></td>'||
          '    <td width="105" style="border-bottom: 1px solid black;"><b>DEPOSITO</b></td>'||
          '    <td width="105" style="border-bottom: 1px solid black;"><b>RETIRO</b></td>'||
          '    <td width="105" style="border-bottom: 1px solid black;"><b>'||lc_texto||'</b></td>'||
          '    <td width="80" style="border-bottom: 1px solid black;"><b>AGENCIA</b></td>'||          
          '  </tr>          ';
          
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
                  

          for j in c_movimientos(lc_claext) loop
              ln_cont2 := ln_cont2 + 1;
              
              IF ln_mod = 22 then
                ln_monto := J.JAQY220MT1;
              Else
                ln_monto := J.JAQY220SDO;
              End If;              
              lv_mensaje := --ll_mensaje ||                                      
              '  <tr>'||
              '    <td align="right">'||rpad(ln_cont2, 8, ' ')||'</td>'||
              '    <td align="center">'||rpad(to_char(j.JAQY220FMV,'DD/MM/YY'), 12, ' ')||'</td>'||
              '    <td align="center">'||rpad(j.JAQY220HOR, 12, ' ')||'</td>    '||
              '    <td align="left">'||rpad(j.JAQY220CCT, 10, ' ')||'</td>'||
              '    <td align="center">'||rpad(j.JAQY220FVL, 10, ' ')||'</td>'||
              '    <td align="left">'||rpad(j.JAQY220DSC, 12, ' ')||'</td>        '||
              '    <td align="left">'||rpad(j.JAQY220DOC, 12, ' ')||'</td>'||
              '    <td align="right">'||to_char(j.JAQY220DEP,'99,999,990.90')||'</td>'||
              '    <td align="right">'||to_char(j.JAQY220RET,'99,999,990.90')||'</td>'||
              '    <td align="right">'||to_char(ln_monto,'99,999,990.90')||'</td>    '||                        
              '    <td align="left">'||substr(Trim(J.JAQY220AGE),1,9)||'</td>    '||                                      
              '  </tr>                ';

              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    

               ln_totdep := ln_totdep + j.JAQY220DEP;
               ln_totret := ln_totret + j.JAQY220RET;
              
          end loop;

          lv_mensaje := --ll_mensaje ||
          '  <tr>'||
          '    <td align="right">&nbsp;</td>'||
          '    <td align="center">&nbsp;</td>'||
          '    <td align="center">&nbsp;</td>  '||      
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>  '||  
          '    <td align="center">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="right" style="border-top: 1px solid black;">'||to_char(ln_totdep, '99,999,990.90')||'</td>'||
          '    <td align="right" style="border-top: 1px solid black;">'||to_char(ln_totret, '99,999,990.90')||'</td>'||          
          '    <td align="right">&nbsp;</td>                            '||
          '    <td align="left">&nbsp;</td>                            '||          
          '  </tr>            ';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              
          
          If ln_mod = 21 then
             If ln_tope = 2 then
                lv_mensaje2 :=           
                '  <tr>'||
                '    <td align="left" colspan="10">SALDO TOTAL: Saldo de la cuenta incluyendo intereses generados en el mes.</td>    '||
                '  </tr>      '||                
                '  <tr>'||
                '    <td align="left" colspan="10">SALDO DISPONIBLE: Dinero que cliente puede retirar en base a normativa vigente de CTS.</td>    '||
                '  </tr>      '||                        
                '  <tr>'||
                '    <td align="left" colspan="10">TEA: Tasa de interés efectiva anual calculado sobre la base de un año de 360 días.</td>    '||
                '  </tr>      '||                
                '  <tr>'||
                '    <td align="left" colspan="10">TREA: Tasa de rendimiento efectivo anual siendo el resultado de la TEA menos los gastos y comisiones trasladados al cliente.</td>    '||
                '  </tr>      '||                
                '  <tr>'||
                '    <td align="left" colspan="10">INTERÉS: Monto generado por el capital e intereses que el cliente mantiene en la cuenta. La capitalización es diaria.</td>    '||
                '  </tr>      ';                       
             Else
                If ln_mod = 21 and ln_tope = 6  then
                  lv_mensaje2 :=                   
                  '  <tr>'||
                  '    <td align="left" colspan="10">SALDO REMUNERACIONES: Saldo producto de los abonos del empleador.</td>    '||                
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">SALDO OTROS ABONOS: Saldo producto de abonos por terceros.</td>    '||                
                  '  </tr>      '||                     
                  '  <tr>'||
                  '    <td align="left" colspan="10">SALDO DISPONIBLE: Saldo que el cliente puede retirar, en estos no incluyen los intereses generados en lo que va transcurrido del mes así como los cheques pendientes de valorización.</td>    '||
                  '  </tr>      '||                                
                  '  <tr>'||
                  '    <td align="left" colspan="10">TEA: Tasa de interés efectiva anual calculado sobre la base de un año de 360 días.</td>    '||
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">TREA: Tasa de rendimiento efectivo anual siendo el resultado de la TEA menos los gastos y comisiones trasladados al cliente.</td>    '||
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">INTERÉS: Monto generado por el capital que el cliente mantiene en la cuenta diariamente. La capitalización es mensual.</td>    '||
                  '  </tr>      ';                     
                Else
                  lv_mensaje2 :=                   
                  '  <tr>'||
                  '    <td align="left" colspan="10">SALDO TOTAL: Saldo de la cuenta incluyendo intereses generados en el mes.</td>    '||                
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">SALDO DISPONIBLE: Saldo que el cliente puede retirar, en estos no incluyen los intereses generados en lo que va transcurrido del mes así como los cheques pendientes de valorización.</td>    '||
                  '  </tr>      '||                                
                  '  <tr>'||
                  '    <td align="left" colspan="10">TEA: Tasa de interés efectiva anual calculado sobre la base de un año de 360 días.</td>    '||
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">TREA: Tasa de rendimiento efectivo anual siendo el resultado de la TEA menos los gastos y comisiones trasladados al cliente.</td>    '||
                  '  </tr>      '||                
                  '  <tr>'||
                  '    <td align="left" colspan="10">INTERÉS: Monto generado por el capital que el cliente mantiene en la cuenta diariamente. La capitalización es mensual.</td>    '||
                  '  </tr>      ';                    
                End If;                                      
             End If;
             
          ElsIf ln_mod = 22 then
            lv_mensaje2 :=                   
            '  <tr>'||
            '    <td align="left" colspan="10">SALDO TOTAL: Saldo de la cuenta incluyendo intereses generados desde la apertura respetando tasa de interés.</td>    '||
            '  </tr>      '||                
            '  <tr>'||
            '    <td align="left" colspan="10">SALDO DISPONIBLE: Interés que el cliente puede retirar sin realizar cancelación de la cuenta.</td>    '||
            '  </tr>      '||            
            '  <tr>'||
            '    <td align="left" colspan="10">TEA: Tasa de interés efectiva anual calculado sobre la base de un año de 360 días.</td>    '||
            '  </tr>      '||                
            '  <tr>'||
            '    <td align="left" colspan="10">TREA: Tasa de rendimiento efectivo anual siendo el resultado de la TEA menos los gastos y comisiones trasladados al cliente.</td>    '||
            '  </tr>      '||                
            '  <tr>'||
            '    <td align="left" colspan="10">INTERÉS: Monto generado por el capital e intereses que el cliente mantiene en la cuenta la capitalización es diaria.</td>    '||
            '  </tr>      ';                    
          End If;
          
          
          
          lv_mensaje := --ll_mensaje || 
          '</table>'||
          '<br/>'||
          '<br/>'||
          '<table cellspacing=0 cellpadding=0 width=942>    ';--942
          If ln_mod = 21 and ln_tope = 6 then
              begin
                select x.scsuc       
                  into ln_suc 
                  from fsd011 x 
                 where x.pgcod  = 1
                   and x.scmda  = ln_mda
                   and x.scpap  = 0
                   and x.sccta  = ln_cta
                   and x.scoper = 0
                   and x.scsbop = ln_sbo
                   and x.sctope = ln_tope
                   and x.scmod  = ln_mod;
              exception
              when others then  
                ln_suc := 0;
              end;
              begin
                -- Call the procedure
                pq_ah_comision.sp_ah_saldos_remu(p_n_pgcod  => 1,
                                                 p_n_modulo => ln_mod,
                                                 p_n_ctnro  => ln_cta,
                                                 p_n_itoper => 0,
                                                 p_n_itsubo => ln_sbo,
                                                 p_n_ittope => ln_tope,
                                                 p_n_sucdes => ln_suc,
                                                 p_n_moneda => ln_mda,
                                                 p_n_papel  => 0,
                                                 p_n_saldo  => ln_salrem,
                                                 p_n_salte  => ln_salter
                                                );
              ln_salter := p_n_saltot - ln_salrem;                                  
              end;            
                              
              lv_mensaje:= lv_mensaje ||                   
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">SALDO REMUNERACIONES :</td>    '||
              '    <td width="142" align="right">'||to_char(ln_salrem, '99,999,990.90')||'</td>  '||
              '    <td width="430 "align="left">&nbsp;</td>            '||
              '  </tr>    '||
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">SALDO OTROS ABONOS :</td>    '||
              '    <td width="142" align="right">'||to_char(ln_salter, '99,999,990.90')||'</td>  '||
              '    <td width="430" align="left">&nbsp;</td>            '||
              '  </tr>    ';                              
          else
              lv_mensaje:= lv_mensaje ||                               
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">SALDO TOTAL '||to_char(ld_Pgfape,'DD/MM/RRRR')||':'||'</td>    '||
              '    <td width="142" align="right">'||to_char(p_n_saltot, '99,999,990.90')||'</td>  '||
              '    <td width="430" align="left">&nbsp;</td>            '||
              '  </tr>    ';                              
          End if;            

          If /*ln_Sdogu > 0*/ lc_flag = 'S' then
              lv_mensaje:= lv_mensaje ||                   
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">SALDO GUARDADITO :</td>    '||
              '    <td width="142" align="right">'||to_char(ln_Sdogu, '99,999,990.90')||'</td>  '||
              '    <td width="430" align="left">&nbsp;</td>    '||        
              '  </tr>';               
          End if; 
          If /*ln_Sdogu > 0*/ lc_flagx = 'S' then
              lv_mensaje:= lv_mensaje ||                   
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">EXTRA PROGRAMADO :</td>    '||
              '    <td width="142" align="right">'||to_char(ln_Sdogu1, '99,999,990.90')||'</td>  '||
              '    <td width="430" align="left">&nbsp;</td>    '||        
              '  </tr>';               
          End if;                      
          If ln_mod <> 21 or ln_tope <> 2 then
              lv_mensaje:= lv_mensaje ||                   
              '  <tr>'||
              '    <td width="70" align="left">&nbsp;</td>'||
              '    <td width="300" align="left">INTERES :</td>    '||
              '    <td width="142" align="right">'||to_char(p_n_salint, '99,999,990.90')||'</td>  '||
              '    <td width="430" align="left">&nbsp;</td>    '||        
              '  </tr>';              
          End If;
          If ln_mod = 21 and ln_tope = 6 then
            lv_mensaje:= lv_mensaje ||          
            '  <tr>'||
            '    <td width="70" align="left">&nbsp;</td>'||
            '    <td width="300" align="left">SALDO DISPONIBLE '||to_char(ld_Pgfape,'DD/MM/RRRR')||':'||'</td>    '||
            '    <td width="142" align="right">'||to_char(p_n_saldis, '99,999,990.90')||'</td>  '||
            '    <td width="430" align="left">&nbsp;</td>        '||    
            '  </tr>      ';
          Else
            lv_mensaje:= lv_mensaje ||          
            '  <tr>'||
            '    <td width="70" align="left">&nbsp;</td>'||
            '    <td width="300" align="left">SALDO DISPONIBLE :</td>    '||
            '    <td width="142" align="right">'||to_char(p_n_saldis, '99,999,990.90')||'</td>  '||
            '    <td width="430" align="left">&nbsp;</td>        '||    
            '  </tr>      ';            
          End If;
          lv_mensaje:= lv_mensaje ||            
          '  <tr>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||    
          '  </tr>      '||           
          '  <tr>'||
          '    <td align="left" colspan="10">Estimado Cliente, Caja Arequipa lo mantiene informado de sus operaciones; en caso de duda, puede obtener mayor detalle en nuestros canales virtuales y agencias a nivel nacional.</td>    '||
          '  </tr>      '||  
          '  <tr>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||
          '    <td align="left">&nbsp;</td>'||    
          '  </tr>      '|| lv_mensaje2||      
          '</table>      '||      
          '<br/>'||
          '<br/>'||         
          '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';           
                    
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              
   
  for j in c_mail(ln_cta) loop    
  ln_cont := ln_cont + 1;    
       if lc_error is null then
       insert into jaql452( JAQL452COR,   
                            JAQL452FCH,   
                            JAQL452HRG,
                            JAQL452FEN,   
                            JAQL452MAI,   
                            JAQL452CUE, 
                            JAQL452USR,  
                            JAQL452USE,  
                            JAQL452CTA,  
                            JAQL452EST,
                            JAQL452AGE   
                            )
                      values(seq_jaql452.nextval,--ln_correla,
                             p_d_fecgen,--trunc(sysdate),
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             j.p_c_mailre,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             p_c_cuenta,
                             'N',
                             p_c_desage
                            );
       --ln_correla := ln_correla + 1;                            
       else
         insert into jaql452(JAQL452COR,   
                             JAQL452FCH,   
                             JAQL452HRG,                             
                             JAQL452FEN,   
                             JAQL452MAI,   
                             JAQL452CUE, 
                             JAQL452USR,  
                             JAQL452USE,  
                             JAQL452CTA,  
                             JAQL452EST,
                             JAQL452ERR,
                             JAQL452AGE   
                             )
                      values(seq_jaql452.nextval,--ln_correla,
                             p_d_fecgen,--trunc(sysdate),
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             j.p_c_mailre,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             p_c_cuenta,
                             'N',
                             lc_error,
                             p_c_desage
                            );       
       end if;                                                 
       commit;                            
  end loop;
  
  if ln_cont = 0 then
   lc_error:= 'CUENTA NO POSEE CUENTA DE CORREO ASOCIADA';
   insert into jaql452(JAQL452COR,   
                       JAQL452FCH,   
                       JAQL452HRG,
                       JAQL452FEN,   
                       JAQL452MAI,   
                       JAQL452CUE, 
                       JAQL452USR,  
                       JAQL452USE,  
                       JAQL452CTA,  
                       JAQL452EST,
                       JAQL452ERR,
                       JAQL452AGE   
                       )
                values(seq_jaql452.nextval,--ln_correla,
                       p_d_fecgen,--trunc(sysdate),
                       to_char(sysdate,'HH24:mi:ss'),                       
                       null,
                       null,
                       ll_mensaje,
                       lc_usuario,
                       null,
                       p_c_cuenta,
                       'N',
                       lc_error,
                       p_c_desage
                      );   
  commit;                                      
  else  
    ln_cont := 0;
  end if;
  
      dbms_lob.freetemporary(ll_mensaje);  
  
  EXCEPTION
  WHEN OTHERS THEN
  lc_error:= sqlcode||'-'||sqlerrm;
  
   insert into jaql452(JAQL452COR,   
                       JAQL452FCH,   
                       JAQL452HRG,                       
                       JAQL452FEN,   
                       JAQL452MAI,   
                       JAQL452CUE, 
                       JAQL452USR,  
                       JAQL452USE,  
                       JAQL452CTA,  
                       JAQL452EST,
                       JAQL452ERR,
                       JAQL452AGE   
                       )
                values(seq_jaql452.nextval,--ln_correla,
                       p_d_fecgen,--trunc(sysdate),
                       to_char(sysdate,'HH24:mi:ss'),                       
                       null,
                       null,
                       ll_mensaje,
                       lc_usuario,
                       null,
                       p_c_cuenta,
                       'N',
                       lc_error,
                       p_c_desage
                      );
  commit;    
  END SP_AH_GEN_EXTRACTO;
  
  PROCEDURE SP_AH_ENVIO_MAIL(p_c_usuario in VARCHAR2,p_d_fecgen IN DATE) IS  
  
  cursor c_mail is
   SELECT *
     FROM JAQL452
    WHERE JAQL452ERR is null
      AND JAQL452EST = 'N'
      AND JAQL452USR = rpad(p_c_usuario,10,' ')
      AND trunc(JAQL452FCH) = p_d_fecgen;
      
  lc_error  varchar2(400);    
  lc_coderr varchar2(400);    
  lc_deserr varchar2(400);    
  BEGIN
      for i in c_mail loop
       begin
       
/*         sys.sp_sy_enviamail_html(pc_aquien => i.jaql452mai,
                                  pc_de => 'enviodeestado@cajaarequipa.pe',
                                  pc_motivo => 'Envío de Extracto de Saldo',
                                  pc_mensaje => i.jaql452cue
                                 );  */ 
                                 
          -- Call the procedure
          if pq_ah_enviodigital.fn_ah_valida_mail(trim(i.JAQL452MAI))='S' then
              lc_coderr := '000';
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(i.jaql452mai),
                                               p_destinatarioscc => '',
                                               p_destinatariosbcc => '',
                                               p_mensaje => i.jaql452cue,
                                               p_remitente => 'enviodeestado@cajaarequipa.pe',
                                               p_asunto => 'Envío de Extracto de Saldo',
                                               p_tipomensaje => 'HTML',
                                               p_directorio => '',
                                               p_archivosadjuntos => '',
                                               p_c_coderr => lc_coderr,
                                               p_c_deserr => lc_deserr
                                               );   
              if lc_coderr = '000' then                                                                                               
                 update jaql452 a
                    set a.jaql452fen = p_d_fecgen,--sysdate,
                        a.jaql452hre = to_char(sysdate,'HH24:mi:ss'),
                        a.jaql452use = p_c_usuario,
                        a.jaql452est = 'S'
                  where a.jaql452cor = i.jaql452cor;
              else
                 update jaql452 a
                    set a.jaql452est = 'N',
                        a.jaql452mot = lc_deserr 
                  where a.jaql452cor = i.jaql452cor;             
              end if; 
          else
           lc_deserr:='Cuenta de Correo no válida';
           update jaql452 a
                  set a.jaql452est = 'N',
                      a.jaql452mot = lc_deserr 
                where a.jaql452cor = i.jaql452cor;            
          end if;             
       exception
       when others then
         lc_coderr := sqlcode;   
         lc_deserr:= lc_coderr||'-'||sqlerrm;         
         update jaql452 a
            set a.jaql452est = 'N',
                a.jaql452mot = lc_deserr 
          where a.jaql452cor = i.jaql452cor;        
       end;
       commit;
      end loop;   
           
  END SP_AH_ENVIO_MAIL;                        
  
  PROCEDURE SP_AH_DEL_DATA(p_c_usuario in VARCHAR2,
                           p_d_fecgen in date               
                           ) IS  
  BEGIN
   DELETE FROM JAQL452 WHERE JAQL452USR = rpad(p_c_usuario,10,' ') AND JAQL452FCH = p_d_fecgen;--trunc(sysdate);
   commit;                           
   
   DELETE FROM JAQL461 WHERE JAQL461USU = rpad(p_c_usuario,10,' ') AND JAQL461FCH = p_d_fecgen;--trunc(sysdate);
   commit;                           
   
   DELETE FROM JAQL462 WHERE JAQL462USU = rpad(p_c_usuario,10,' ') AND JAQL462FCH = p_d_fecgen;--trunc(sysdate);
   commit;       

  END SP_AH_DEL_DATA;     
  
  PROCEDURE SP_AH_ENVIO_CONF(p_c_usuario in VARCHAR2, p_d_fecgen in DATE) IS  
  
  ll_mensaje     clob;
  ll_mensaje2    clob;
  lc_ageact      varchar2(50);
  lc_ageant      varchar2(50):='X'; 
  lc_indahr      char(1);
  lc_indacr      char(1);
  ln_correla     number;
  ln_cont        number:=0;
  lc_error       varchar2(400);
  lv_mensaje     varchar2(32767);
  
  lv_maiori      varchar2(60);
  lv_maiasi      varchar2(60);
  lv_maiej1      varchar2(60);
  lv_maiej2      varchar2(60);
  lv_motivo      varchar2(60);
  lc_usuario     char(10);
  
  cursor c_cuentas(lc_motivo in varchar2) is
  select distinct JAQL452AGE,
                  JAQL452CTA,
                  decode(JAQL452EST,
                         'S',
                         'ENVIADO CORRECTAMENTE',
                         'NO ENVIADO') JAQL452EST                         
    from jaql452
   where JAQL452USR = rpad(p_c_usuario, 10, ' ')
     AND JAQL452FCH = p_d_fecgen
     AND length(JAQL452CTA) in (20,27)
     AND jaql452mai <> lc_motivo
   ORDER BY JAQL452AGE,JAQL452CTA,
                     decode(JAQL452EST,
                         'S',
                         'ENVIADO CORRECTAMENTE',
                         'NO ENVIADO');                  

  cursor c_creditos(lc_motivo in varchar2) is
  select distinct JAQL452AGE,
                  JAQL452CTA,
                  decode(JAQL452EST,
                         'S',
                         'ENVIADO CORRECTAMENTE',
                         'NO ENVIADO') JAQL452EST                         
    from jaql452
   where JAQL452USR = rpad(p_c_usuario, 10, ' ')
     AND JAQL452FCH = p_d_fecgen
     AND length(JAQL452CTA) in (21)
     AND jaql452mai <> lc_motivo
   ORDER BY JAQL452AGE,JAQL452CTA,
                     decode(JAQL452EST,
                         'S',
                         'ENVIADO CORRECTAMENTE',
                         'NO ENVIADO');    
   
  BEGIN
  
  lc_usuario := rpad(P_C_USUARIO,10,' ');
  lv_maiori := 'enviodeestado@cajaarequipa.pe';
  lv_motivo := 'Confirmación de Envio de Estados';
    
  dbms_lob.createtemporary(ll_mensaje, TRUE);
  
    lv_mensaje:= '<p align="center">'||  
                '<table cellspacing=0 cellpadding=2 width=600> '|| 
                '<tr>'||
                '               <td align="center" colspan="2" style="font-family:''Courier New'', Courier, monospace; font-size:13px;border-bottom: 1px solid black;"><b>RESUMEN DE ENVIOS DE ESTADOS DE CUENTAS</b></td>'||
                '</tr>'||
                '<tr>'||
                '               <td colspan="2" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">&nbsp;</td>'||
                '</tr>                                    ';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
                  
  for i in c_cuentas(upper(lv_motivo)) loop
    lc_ageact := i.jaql452age;
    
      if lc_ageact != lc_ageant then
      
        lv_mensaje:= --lb_mensaje ||
                      '<tr>'||
                      '               <td width="70" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px"><b>AGENCIA:</b></td>'||
                      '               <td width="284" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px"><b>'||lc_ageact||'</b></td> '||                       
                      '</tr>     '||
                      '<tr>'||
                      '<td colspan="2" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px;border-bottom: 1px dotted black;">CUENTAS:</td>'||
                      '</tr>';                    
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                                      
        ln_cont := 0;  
      end if;             
    
    ln_cont := ln_cont + 1;
    lv_mensaje:= --lb_mensaje ||              
                  '<tr>'||
                  '               <td align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">'||ln_cont||'.'||'</td>'||
                  '               <td align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">'||i.JAQL452CTA||' - '||i.JAQL452EST||'</td>'||
                  '</tr>                     ';
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                  
    lc_ageant := lc_ageact;
    lc_indahr := 'A';    
  end loop;

  lv_mensaje:= --lb_mensaje ||
                '</table>'||        
                '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>'||                          
                '</p>  ';
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
  
  -- ARMAMOS MENSAJE PARA CONFIRMACION DE CREDITOS
  dbms_lob.createtemporary(ll_mensaje2, TRUE);
  
    lv_mensaje:= '<p align="center">'||  
                '<table cellspacing=0 cellpadding=2 width=600> '|| 
                '<tr>'||
                '               <td align="center" colspan="2" style="font-family:''Courier New'', Courier, monospace; font-size:13px;border-bottom: 1px solid black;"><b>RESUMEN DE ENVIOS DE ESTADOS DE CREDITOS</b></td>'||
                '</tr>'||
                '<tr>'||
                '               <td colspan="2" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">&nbsp;</td>'||
                '</tr>                                    ';
    dbms_lob.writeappend(ll_mensaje2, length(lv_mensaje), lv_mensaje);   
    
                
  ln_cont := 0;
  lc_ageant := 'X';
  
  for i in c_creditos(upper(lv_motivo)) loop
    lc_ageact := i.jaql452age;
    
      if lc_ageact != lc_ageant then
      
        lv_mensaje:= --lb_mensaje ||
                      '<tr>'||
                      '               <td width="70" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px"><b>AGENCIA:</b></td>'||
                      '               <td width="284" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px"><b>'||lc_ageact||'</b></td> '||                       
                      '</tr>     '||
                      '<tr>'||
                      '<td colspan="2" align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px;border-bottom: 1px dotted black;">CREDITOS:</td>'||
                      '</tr>';                    
        dbms_lob.writeappend(ll_mensaje2, length(lv_mensaje), lv_mensaje);                                      
        ln_cont := 0;  
      end if;             
    
    ln_cont := ln_cont + 1;
    lv_mensaje:= --lb_mensaje ||              
                  '<tr>'||
                  '               <td align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">'||ln_cont||'.'||'</td>'||
                  '               <td align="left" style="font-family:''Courier New'', Courier, monospace; font-size:13px">'||i.JAQL452CTA||' - '||i.JAQL452EST||'</td>'||
                  '</tr>                     ';
    dbms_lob.writeappend(ll_mensaje2, length(lv_mensaje), lv_mensaje);
                  
    lc_ageant := lc_ageact;
    lc_indacr := 'C';
  end loop;

  lv_mensaje:= --lb_mensaje ||
                '</table>'||        
                '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>'||                          
                '</p>  ';
  dbms_lob.writeappend(ll_mensaje2, length(lv_mensaje), lv_mensaje);      
            
  
  -- Asignaciones de cuentas de correo 
  if lc_indahr = 'A' then
     lv_maiasi := 'asistentesdeoperaciones@cajaarequipa.pe'; 
     lv_maiej1 := 'ejecutivosdeahorrosregioncentro@cajaarequipa.pe';
     lv_maiej2 := 'ejecutivosdeahorrosregionimperial@cajaarequipa.pe';
  end if;
    
  if lc_indacr = 'C' then
     lv_maiasi := 'asistentesdeoperaciones@cajaarequipa.pe'; 
     lv_maiej1 := 'administradoresdeagencia@cajaarequipa.pe';
     --lv_maiej2 := 'ylozada@cajaarequipa.pe';--'gerentesdeagencia@cajaarequipa.pe';
  end if;
    
  if lv_maiasi is not null and lc_indahr = 'A' then
       begin
       
       select nvl(max(JAQL452COR),0) into ln_correla from jaql452;   
       ln_correla := ln_correla + 1;
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiasi,--correo de grupo de operaciones
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje
                                 );   

                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH, 
                                JAQL452HRG,  
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiasi
                                );
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,   
                                JAQL452HRE,
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiasi, 
                                 lc_error
                                );  
       end;
       commit;   
       ln_correla := ln_correla + 1;
  end if;
   
  if lv_maiej1 is not null and lc_indahr = 'A' then  
       begin
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiej1,--correo de grupo ejecutivos de ahorros
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje
                                 );   
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,  
                                JAQL452HRG, 
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiej1 --remplazar
                                );                                                          
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,  
                                JAQL452HRG, 
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiej1, --remplazar
                                 lc_error
                                );                                  
       end;
       commit;
       ln_correla := ln_correla + 1;
  end if;
  
  if lv_maiej2 is not null and lc_indahr = 'A' then    
       begin
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiej2,--correo de grupo ejecutivos de ahorros
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje
                                 );   
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiej1 --remplazar
                                );                                                          
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiej1, --remplazar
                                 lc_error
                                );                               
       end;
       commit;   
  end if;   
  dbms_lob.freetemporary(ll_mensaje);
  
  if lv_maiasi is not null and lc_indacr = 'C' then
       begin
       
       select nvl(max(JAQL452COR),0) into ln_correla from jaql452;   
       --ln_correla := ln_correla + 1;
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiasi,--correo de grupo de operaciones
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje2
                                 );   

                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiasi
                                );
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH, 
                                JAQL452HRG,  
                                JAQL452FEN,  
                                JAQL452HRE, 
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiasi, 
                                 lc_error
                                );  
       end;
       commit;   
       --ln_correla := ln_correla + 1;
  end if;
   
  if lv_maiej1 is not null and lc_indacr = 'C' then  
       begin
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiej1,--correo de grupo ejecutivos de ahorros
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje2
                                 );   
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiej1 --remplazar
                                );                                                          
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiej1, --remplazar
                                 lc_error
                                );                                  
       end;
       commit;
       --ln_correla := ln_correla + 1;
  end if;
  
  if lv_maiej2 is not null and lc_indacr = 'C' then    
       begin
           
         sys.sp_sy_enviamail_html(pc_aquien  => lv_maiej2,--correo de grupo ejecutivos de ahorros
                                  pc_de      => lv_maiori,
                                  pc_motivo  => lv_motivo,
                                  pc_mensaje => ll_mensaje2
                                 );   
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE   
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'S',
                                 lv_maiej1 --remplazar
                                );                                                          
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
                                   
           insert into jaql452( JAQL452COR,   
                                JAQL452FCH,   
                                JAQL452HRG,
                                JAQL452FEN,
                                JAQL452HRE,   
                                JAQL452MAI,   
                                JAQL452CUE, 
                                JAQL452USR,  
                                JAQL452USE,  
                                JAQL452CTA,  
                                JAQL452EST,
                                JAQL452AGE,   
                                JAQL452ERR
                                )
                          values(seq_jaql452.nextval,--ln_correla,
                                 p_d_fecgen,
                                 to_char(sysdate,'HH24:mi:ss'),
                                 trunc(sysdate),
                                 to_char(sysdate,'HH24:mi:ss'),
                                 upper(lv_motivo),
                                 ll_mensaje2,
                                 lc_usuario,
                                 lc_usuario,
                                 null,
                                 'N',
                                 lv_maiej1, --remplazar
                                 lc_error
                                );                               
       end;
       commit;   
  end if;   
  dbms_lob.freetemporary(ll_mensaje2);
  
  EXCEPTION 
  WHEN OTHERS THEN
  lc_error:= sqlcode||'-'||sqlerrm;
                               
       insert into jaql452( JAQL452COR,   
                            JAQL452FCH,   
                            JAQL452HRG,
                            JAQL452FEN,
                            JAQL452HRE,   
                            JAQL452MAI,   
                            JAQL452CUE, 
                            JAQL452USR,  
                            JAQL452USE,  
                            JAQL452CTA,  
                            JAQL452EST,
                            JAQL452AGE,   
                            JAQL452ERR
                            )
                      values(seq_jaql452.nextval,--ln_correla,
                             p_d_fecgen,
                             to_char(sysdate,'HH24:mi:ss'),
                             trunc(sysdate),
                             to_char(sysdate,'HH24:mi:ss'),
                             upper(lv_motivo),
                             lv_mensaje,
                             lc_usuario,
                             lc_usuario,
                             null,
                             'N',
                             lv_maiori, --remplazar
                             lc_error
                            );   
   commit;      
  END SP_AH_ENVIO_CONF;  
  PROCEDURE SP_AH_GEN_CRON_PAG(p_c_usuario in VARCHAR2,
                               p_c_cuenta  in VARCHAR2,                               
                               p_c_numcre  in VARCHAR2,
                               p_c_nomtit  in VARCHAR2,
                               p_d_fecdes  in date,
                               p_c_desmon  in VARCHAR2,
                               p_n_mondes  in number,
                               p_c_numdoc  in VARCHAR2,
                               p_c_nomana  in VARCHAR2,
                               p_n_plazos  in number,
                               p_n_moncuo  in number,
                               p_c_desage  in VARCHAR2,
                               p_n_tastea  in number,
                               p_n_numcuo  in number,      
                               p_n_totcap  in number,
                               p_n_numcpe  in number,
                               p_n_tatcea  in number,
                               p_n_cancuo  in number,
                               p_d_fecgen  in date,
                               p_c_claext  in varchar2
                               ) IS

    ln_cta        number(9);
    --ln_correla    number(10);
    ll_mensaje CLOB;
    lc_cuenta  varchar2(27);
    lc_usuario char(10);
    lc_claext  char(10);
    ln_cont    number:=0;
     
     cursor c_movimientos(lc_claext in varchar2) is     
        select *
          from jaql454
         where jaql454usr = lc_claext
      order by jaql454num;     
     
     
    cursor c_mail(ln_cta in number) is
    select distinct
           substr(ctxtxt, 1, instr(ctxtxt, '\') - 1) p_c_mailre
      from FSX008
     Where pgcod = 1
       and Txcod = 0
       and ctnro = ln_cta
  order by 1;        

  lc_error varchar2(400);  
  ln_cont2 number := 0;
  lv_mensaje    VARCHAR2(32767);
  lc_blanco char(1);
  BEGIN
  
  commit;
  
  dbms_lob.createtemporary(ll_mensaje, TRUE);  
  lc_usuario := rpad(P_C_USUARIO,10,' ');
  lc_claext  := lpad(p_c_claext,10,'0');
  
--  select nvl(max(JAQL452COR),0) into ln_correla from jaql452;   
--  ln_correla := ln_correla + 1;
    
  -- DATOS DE CABECERA DEL EXTRACTO
  lc_usuario := rpad(P_C_USUARIO,10,' ');
  lc_cuenta  := trim(p_c_cuenta);  
  ln_cta     := to_number(substr(lc_cuenta, 1, 9));
  
  lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado(a)(s) : </p>' ||  
                '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">'|| p_c_nomtit || '</p>' ||
                '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">De acuerdo a lo solicitado adjunto se remite el estado de su cr&eacute;dito a la fecha.</p><br/>';  
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                                            
  lv_mensaje := '<style  type="text/css">' ||  
                'td {font-family:''Courier New'', Courier, monospace; font-size:11px}' ||  
                '</style>';
                        
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                        
  lv_mensaje := --ll_mensaje ||       
          
                '<table cellspacing=0 cellpadding=3 width=1418>' ||
                '  <tr>' ||
                '    <td colspan="2" align="center"><b>CAJA MUNICIPAL DE AHORRO Y CREDITO DE AREQUIPA</b></td>' ||
                '  </tr>' ||
                ' <tr>	' ||
                '    <td colspan="2" align="center"><b>SISTEMA DE CREDITOS</b></td>		' ||
                '  </tr>	' ||
                '  <tr>' ||
                '    <td width="134" align="left">Fecha :</td>' ||
                '    <td width="1270" align="left">'||to_char(trunc(sysdate), 'DD/MM/YY')||'</td>' ||
                '  </tr>		' ||
                '  <tr>		' ||
                '    <td align="left" style="border-bottom: 1px solid black;">Hora : </td>' ||
                '    <td align="left" style="border-bottom: 1px solid black;">'||to_char(SYSDATE, 'HH24:MI:SS')||'</td>		' ||				
                '  </tr>' ||
                '</table>';
                        
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                        
  lv_mensaje := --ll_mensaje ||                            
                '<br/>' ||
                '<table cellspacing=0 cellpadding=3 width=1418>' ||
                '  <tr>' ||
                '   <td width="133" align="left">Nro. de Cr&eacute;dito:</td>' ||
                '    <td width="413" align="left">'||p_c_numcre||'</td>		' ||
                '    <td width="80" align="left">Doc/Ide:</td>				' ||
                '    <td width="160" align="left">'||p_c_numdoc||'</td>				' ||
                '    <td width="193" align="left">Saldo Capital a la fecha:</td>				' ||
                '    <td width="147" align="left">'||to_char(p_n_totcap,'99,999,990.90')||'</td>				' ||
                '    <td width="183" align="left">Total cuotas pendientes:</td>	' ||	
                '    <td width="59" align="left">'||p_n_numcpe||'/'||p_n_cancuo||'</td>						' ||
                '  </tr>' ||
                '  <tr>' ||
                '    <td align="left">Cliente:</td>' ||
                '    <td align="left">'||p_c_nomtit||'</td>		' ||
                '    <td align="left">Analista:</td>				' ||
                '    <td align="left">'||p_c_nomana||'</td>				' ||
                '    <td align="left">TEA:</td>				' ||
                '    <td align="left">'||to_char(p_n_tastea,'990.999990')||' %</td>			' ||	
                '    <td align="left">&nbsp;</td>		' ||
                '    <td align="left">&nbsp;</td>				' ||		
                '  </tr>	' ||
                '  <tr>' ||
                '    <td align="left">Fec. Desembolso:</td>' ||
                '    <td align="left">'||to_char(p_d_fecdes,'DD/MM/YY')||'</td>		' ||
                '    <td align="left">Plazo:</td>				' ||
                '    <td align="left">'||p_n_plazos||' d&iacute;a(s)</td>	' ||			
                '    <td align="left">TCEA:</td>				' ||
                '    <td align="left">'||to_char(p_n_tatcea,'990.999990')||' %</td>				' ||
                '    <td align="left">&nbsp;</td>		' ||
                '    <td align="left">&nbsp;</td>				' ||		
                '  </tr>	' ||
                '  <tr>' ||
                '    <td align="left">Monto Desembolso:</td>' ||
                '    <td align="left">'||p_c_desmon||' '||to_char(p_n_mondes,'9,999,990.90')||'</td>		' ||
                '    <td align="left">Cuota:</td>				' ||
                '    <td align="left">'||to_char(p_n_moncuo,'9,999,990.90')||'</td>				' ||
                '    <td align="left">&nbsp;</td>				' ||
                '    <td align="left">&nbsp;</td>				' ||
                '    <td align="left">&nbsp;</td>		' ||
                '    <td align="left">&nbsp;</td>				' ||		
                '  </tr>		' ||
                '</table>' ||                        
                '<br/>' ||
                '<br/>';
                          
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                        
  lv_mensaje := --ll_mensaje ||                                                    
                  '<table cellspacing=0 cellpadding=3 width=1418>' ||
                  '  <tr>' ||
                  '    <td align="left" colspan = 10><b>'||p_n_numcuo||' '||'ULTIMAS CUOTAS POR VENCER</b></td>' ||
                  '    <td align="left" colspan = 10><b>CUOTAS PAGADAS ULTIMO PERIODO</b></td>		' ||
                  '  </tr>	' ||
                  '  <tr>' ||
                  '    <td width="44" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>TpOp</b></td>' ||
                  '    <td width="55" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>MovCal</b></td>	' ||	
                  '    <td width="64" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Fecha Venci</b></td>	' ||	
                  --'    <td width="47" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>D&iacute;as Atraso</b></td>		' ||
                  '    <td width="90" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Monto</b></td>' ||
                  '    <td width="90" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Capital</b></td>	' ||	
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Interes</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Seguro</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Comision</b></td>		' ||
                  '    <td width="50" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Est.</b></td>		' ||
                  '    <td width="55" style="border-bottom: 1px solid black;border-top: 1px solid black;border-left: 1px solid black;"><b>Nro.</b></td>		' ||
                  '    <td width="64" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Fec Pago</b></td>		' ||
                  '    <td width="90" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Monto Pagado</b></td>		' ||
                  '    <td width="90" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Capital</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Interes</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Seguros</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Comision</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Mora</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>ICV(*)</b></td>		' ||
                  '    <td width="60" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Penalidad</b></td>		' ||
                  '    <td width="47" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Día Atraso</b></td>	' ||	
                  '    <td width="90" style="border-bottom: 1px solid black;border-top: 1px solid black;"><b>Saldo Cap</b></td>		' ||
                  '  </tr> ';                     
                  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
                           
  lc_blanco := ' ';                                                
  for j in c_movimientos(lc_claext) loop
      ln_cont2 := ln_cont2 + 1;
              
      if j.jaql454DS3 = 'D' then
      lv_mensaje := 
      '<tr>'||
      '  <td align="left">'||j.jaql454DS1||'</td>'||
      '  <td align="center">'||j.jaql454NU1||'</td>'||		
      '  <td align="center">'||to_char(j.jaql454FDE,'DD/MM/YY')||'</td>	'||	
      --'  <td align="right">'||lc_blanco||'</td>	'||	
      '  <td align="right">'||to_char(j.jaql454NU2,'9,999,990.90')||'</td>'||
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="left">'||lc_blanco||'</td>	'||	
      '  <td align="center" style="border-left: 1px solid black;">'||lc_blanco||'</td>'||		
      '  <td align="center">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '  <td align="right">'||lc_blanco||'</td>'||		
      '</tr>';
      elsif j.jaql454DS3 = 'C' then
        lv_mensaje := 
        '<tr>'||
        '  <td align="left">'||j.jaql454DS1||'</td>'||
        '  <td align="center">'||j.jaql454NU1||'</td>'||		
        '  <td align="center">'||to_char(j.jaql454FPC,'DD/MM/YY')||'</td>	'||	
        --'  <td align="right">'||lc_blanco||'</td>	'||	
        '  <td align="right">'||to_char(j.jaql454NU3,'9,999,990.90')||'</td>'||
        '  <td align="right">'||to_char(j.jaql454NU4,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454NU5,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454NU6,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454NU7,'9,999,990.90')||'</td>'||		
        '  <td align="left">'||j.jaql454DS2||'</td>	'||	
        '  <td align="center" style="border-left: 1px solid black;">'||lc_blanco||'</td>'||		
        '  <td align="center">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '</tr>';
      else	 --PAGOS
        lv_mensaje := 
        '<tr>'||
        '  <td align="left">'||lc_blanco||'</td>'||
        '  <td align="center">'||lc_blanco||'</td>'||		
        '  <td align="center">'||lc_blanco||'</td>	'||	
       -- '  <td align="right">'||lc_blanco||'</td>	'||	
        '  <td align="right">'||lc_blanco||'</td>'||
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="right">'||lc_blanco||'</td>'||		
        '  <td align="left">'||lc_blanco||'</td>	'||	
        '  <td align="center" style="border-left: 1px solid black;">'||j.jaql454NU8||'</td>'||		
        '  <td align="center">'||to_char(j.jaql454FPP,'DD/MM/YY')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454NU9,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N10,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N11,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N12,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N13,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N14,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N17,'9,999,990.90')||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N18,'9,999,990.90')||'</td>'||		        
        '  <td align="right">'||j.jaql454N15||'</td>'||		
        '  <td align="right">'||to_char(j.jaql454N16,'9,999,990.90')||'</td>'||		
        '</tr>';                           
      end if;
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);    
              
  end loop;          
  lv_mensaje := --ll_mensaje ||     
       '<tr>'||
        '  <td align="left">'||lc_blanco||'</td>'||
        '</tr>'||
       '<tr>'||
        '  <td align="left">'||lc_blanco||'</td>'||
        '</tr>'||
       '<tr>'||
        '  <td colspan = 19 align="left">TEA: Tasa de interés efectiva anual calculado sobre la base de un año de 360 días.</td>'||
        '</tr>'||                
       '<tr>'||
        '  <td colspan = 19 align="left">TCEA: Tasa efectiva anual mas comisiones y gastos (incluye seguros) vinculados.</td>'||
        '</tr>'||        
       '<tr>'||
        '  <td colspan = 19 align="left">(*)ICV: Interés Compensatorio, calculado en base al número de días de atraso en el pago de la cuota.</td>'||
        '</tr>'||           
  '</table>'||
  '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';
  dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);              
   
  for j in c_mail(ln_cta) loop    
  ln_cont := ln_cont + 1;    
       if lc_error is null then
       insert into jaql452( JAQL452COR,   
                            JAQL452FCH,
                            JAQL452HRG,   
                            JAQL452FEN,   
                            JAQL452MAI,   
                            JAQL452CUE, 
                            JAQL452USR,  
                            JAQL452USE,  
                            JAQL452CTA,  
                            JAQL452EST,
                            JAQL452AGE   
                            )
                      values(seq_jaql452.nextval,--ln_correla,
                             p_d_fecgen,
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             j.p_c_mailre,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             p_c_cuenta,
                             'N',
                             p_c_desage
                            );
       else
         insert into jaql452(JAQL452COR,   
                             JAQL452FCH,   
                             JAQL452HRG,
                             JAQL452FEN,   
                             JAQL452MAI,   
                             JAQL452CUE, 
                             JAQL452USR,  
                             JAQL452USE,  
                             JAQL452CTA,  
                             JAQL452EST,
                             JAQL452ERR,
                             JAQL452AGE   
                             )
                      values(seq_jaql452.nextval,--ln_correla,
                             p_d_fecgen,
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             j.p_c_mailre,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             p_c_cuenta,
                             'N',
                             lc_error,
                             p_c_desage
                            );       
       end if;                                                 
       commit;                            
  end loop;
  
  if ln_cont = 0 then
   lc_error:= 'CUENTA NO POSEE CUENTA DE CORREO ASOCIADA';
   insert into jaql452(JAQL452COR,   
                       JAQL452FCH,   
                       JAQL452HRG,
                       JAQL452FEN,   
                       JAQL452MAI,   
                       JAQL452CUE, 
                       JAQL452USR,  
                       JAQL452USE,  
                       JAQL452CTA,  
                       JAQL452EST,
                       JAQL452ERR,
                       JAQL452AGE   
                       )
                values(seq_jaql452.nextval,--ln_correla,
                       p_d_fecgen,
                       to_char(sysdate,'HH24:mi:ss'),
                       null,
                       null,
                       ll_mensaje,
                       lc_usuario,
                       null,
                       p_c_cuenta,
                       'N',
                       lc_error,
                       p_c_desage
                      );   
  commit;                                      
  else  
    ln_cont := 0;
  end if;
  
      dbms_lob.freetemporary(ll_mensaje);  
  
  EXCEPTION
  WHEN OTHERS THEN
  lc_error:= sqlcode||'-'||sqlerrm;
  
   insert into jaql452(JAQL452COR,   
                       JAQL452FCH,   
                       JAQL452HRG,
                       JAQL452FEN,   
                       JAQL452MAI,   
                       JAQL452CUE, 
                       JAQL452USR,  
                       JAQL452USE,  
                       JAQL452CTA,  
                       JAQL452EST,
                       JAQL452ERR,
                       JAQL452AGE   
                       )
                values(seq_jaql452.nextval,--ln_correla,
                       p_d_fecgen,
                       to_char(sysdate,'HH24:mi:ss'),
                       null,
                       null,
                       ll_mensaje,
                       lc_usuario,
                       null,
                       p_c_cuenta,
                       'N',
                       lc_error,
                       p_c_desage
                      );
  commit;    

  END SP_AH_GEN_CRON_PAG;  
  
  PROCEDURE SP_AH_VALIDAR_FECHA(P_D_FECGEN IN DATE,
                                P_N_FRECUE IN NUMBER,              
                                P_C_INDGEN OUT VARCHAR2,
                                P_D_FECINI OUT DATE,
                                P_D_FECFIN OUT DATE
                               ) IS
                               
  BEGIN
  P_C_INDGEN := 'N';
  
  If P_N_FRECUE = 30 then
     P_C_INDGEN := 'S';
     P_D_FECINI := to_date('01'||substr(add_months(P_D_FECGEN,-1),3,8),'DD/MM/YY');
     P_D_FECFIN := last_day(add_months(P_D_FECGEN,-1));     
  Elsif P_N_FRECUE = 1 then   
     P_C_INDGEN := 'S';
     P_D_FECINI := P_D_FECGEN - 1;
     P_D_FECFIN := P_D_FECGEN - 1;       
  Elsif to_number(to_char(P_D_FECGEN, 'DD'))= 16 and P_N_FRECUE = 16  then
     P_C_INDGEN := 'S';
     P_D_FECINI := to_date('01'||substr(P_D_FECGEN,3,8),'DD/MM/YY');
     P_D_FECFIN := to_date('15'||substr(P_D_FECGEN,3,8),'DD/MM/YY');       
  Elsif to_number(to_char(P_D_FECGEN, 'DD'))= 1 and P_N_FRECUE = 16  then
     P_C_INDGEN := 'S';
     P_D_FECINI := to_date('16'||substr(add_months(P_D_FECGEN,-1),3,8),'DD/MM/YY');
     P_D_FECFIN := last_day(add_months(P_D_FECGEN,-1));         
  Elsif to_number(to_char(P_D_FECGEN, 'D'))= 2 and P_N_FRECUE = 8  then
     P_C_INDGEN := 'S';
     P_D_FECINI := P_D_FECGEN - 7;
     P_D_FECFIN := P_D_FECGEN - 1;    
  End If;  
  
  END SP_AH_VALIDAR_FECHA;

  PROCEDURE SP_AH_VERIFICA_GEN(P_D_FECGEN IN DATE,
                               P_C_TIPGEN IN VARCHAR2,
                               P_C_CTACLI IN VARCHAR2,
                               P_C_CODUSU IN VARCHAR2,
                               P_N_FRECUE IN NUMBER,
                               P_C_INDGEN OUT VARCHAR2
                               ) IS
  lc_null   char(1);
  ld_fecini date;
  ld_fecfin date;                               
  BEGIN
    If P_C_TIPGEN = 'M'  then
      
      pq_ah_extractos.sp_ah_val_gen_mail(p_d_fecgen => P_D_FECGEN,
                                         p_c_ctacli => P_C_CTACLI,
                                         p_c_codusu => P_C_CODUSU,
                                         p_c_indgen => P_C_INDGEN
                                         );    
    Else
      If P_C_TIPGEN = 'S' then
        
      pq_ah_extractos.sp_ah_validar_fecha(p_d_fecgen => P_D_FECGEN,
                                          p_n_frecue => P_N_FRECUE,
                                          p_c_indgen => lc_null,
                                          p_d_fecini => ld_fecini,
                                          p_d_fecfin => ld_fecfin);


      pq_ah_extractos.sp_ah_val_gen_cobr(p_d_fecgen => ld_fecfin,
                                         p_c_ctacli => P_C_CTACLI,
                                        -- p_c_codusu => P_C_CODUSU,
                                         p_c_indgen => P_C_INDGEN
                                         );   

      End If;        
    End If;
                           
                     
  END SP_AH_VERIFICA_GEN;     
  
  PROCEDURE SP_AH_VAL_GEN_MAIL(P_D_FECGEN IN DATE,
                               P_C_CTACLI IN VARCHAR2,
                               P_C_CODUSU IN VARCHAR2,
                               P_C_INDGEN OUT VARCHAR2
                               ) IS
  cursor c_mail(ln_cta in number) is
    select distinct
           substr(ctxtxt, 1, instr(ctxtxt, '\') - 1) p_c_mailre
      from FSX008
     Where pgcod = 1
       and Txcod = 0
       and ctnro = ln_cta     
  order by 1;      
  ln_cuenta number(9):=0;
  lc_indgen char(1):= 'N';
  BEGIN
    ln_cuenta := to_number(substr(P_C_CTACLI,1,9));
    For i in c_mail(ln_cuenta) loop
      lc_indgen := FN_AH_VER_EXISTE(P_D_FECGEN,P_C_CTACLI,i.p_c_mailre,P_C_CODUSU);
      
      If lc_indgen = 'N' then
         pq_ah_extractos.sp_ah_borra_incidencia(p_d_fecgen => P_D_FECGEN,
                                                p_c_ctacli => P_C_CTACLI,
                                                p_c_codusu => P_C_CODUSU
                                                );
         exit;
      End If;        
    End Loop;
  P_C_INDGEN := lc_indgen;  
    
  END SP_AH_VAL_GEN_MAIL;
  PROCEDURE SP_AH_VAL_GEN_COBR(P_D_FECGEN IN DATE,
                               P_C_CTACLI IN VARCHAR2,
                               --P_C_CODUSU IN VARCHAR2,
                               P_C_INDGEN OUT VARCHAR2
                               ) IS
  lc_indgen char(1):='N';
  BEGIN
    select 'S'
      into lc_indgen
      from JAQL487 a
     where a.jaql487per = P_D_FECGEN
       and a.jaql487cte = P_C_CTACLI;
--       and a.jaql487usu = rpad(P_C_CODUSU, 10, ' ');
       
  P_C_INDGEN := lc_indgen;
  EXCEPTION
  WHEN too_many_rows THEN
    P_C_INDGEN := 'S'; 
  when no_data_found THEN      
    P_C_INDGEN := 'N'; 
  when others THEN      
    P_C_INDGEN := 'N';     
  END SP_AH_VAL_GEN_COBR;  
                                   
  FUNCTION FN_AH_VER_EXISTE(P_D_FECGEN IN DATE,
                            P_C_CTACLI IN VARCHAR2,
                            P_C_MAIL   IN VARCHAR2,
                            P_C_CODUSU IN VARCHAR2
                            ) RETURN VARCHAR2 IS                                                            
  lc_indgen char(1) := 'N';                            
  BEGIN
    select 'S' 
      into lc_indgen
      from JAQL452 a
     where a.jaql452fch = P_D_FECGEN
       and a.jaql452cta = P_C_CTACLI
       and a.jaql452mai = P_C_MAIL
       and a.jaql452usr = RPAD(P_C_CODUSU,10,' ');
    return lc_indgen;       
  EXCEPTION
  WHEN OTHERS THEN
    lc_indgen := 'N';
    return lc_indgen;    
  END FN_AH_VER_EXISTE;
  PROCEDURE SP_AH_REG_COM(P_D_JAQL487PER IN DATE, 
                          P_N_JAQL487FRE IN NUMBER,
                          P_C_JAQL487MED IN VARCHAR2,
                          P_C_JAQL487USU IN VARCHAR2,
                          P_N_JAQL487PGO IN NUMBER,
                          P_N_JAQL487SUC IN NUMBER, 
                          P_N_JAQL487MOD IN NUMBER, 
                          P_N_JAQL487MDA IN NUMBER, 
                          P_N_JAQL487CTA IN NUMBER, 
                          P_N_JAQL487PAP IN NUMBER, 
                          P_N_JAQL487OPE IN NUMBER, 
                          P_N_JAQL487SUB IN NUMBER, 
                          P_N_JAQL487TOP IN NUMBER,
                          P_N_JAQL487MTO IN NUMBER,
                          P_N_JAQL487UBS IN NUMBER,
                          P_N_JAQL487FVA IN DATE,
                          P_N_JAQL487MDO IN NUMBER,
                          P_N_JAQL487TRN IN NUMBER,                                 
                          P_N_JAQL487REL IN NUMBER,
                          P_D_JAQL487FGE IN DATE,
                          P_C_JAQL487CTE IN VARCHAR2
                         ) IS
    ln_correla number := 0;                                 
    BEGIN
    
    select nvl(max(JAQL487COR),0) into ln_correla from jaql487;   
    ln_correla := ln_correla + 1;
    
    INSERT INTO JAQL487(JAQL487COR,
                        JAQL487FCH,
                        JAQL487HRG,
                        JAQL487PER,
                        JAQL487FRE,
                        JAQL487MED,
                        JAQL487USU,
                        JAQL487PGO,
                        JAQL487SUC,
                        JAQL487MOD,
                        JAQL487MDA,
                        JAQL487CTA,
                        JAQL487PAP,
                        JAQL487OPE,
                        JAQL487SUB,
                        JAQL487TOP,
                        JAQL487MTO,
                        JAQL487MDO,
                        JAQL487TRN,                                 
                        JAQL487REL,
                        JAQL487FVA,
                        JAQL487UBS,
                        JAQL487CTE                                                                             
                        )
                 VALUES(ln_correla,
                        P_D_JAQL487FGE, 
                        to_char(sysdate,'HH24:mi:ss'),              
                        P_D_JAQL487PER,              
                        P_N_JAQL487FRE,
                        P_C_JAQL487MED,
                        P_C_JAQL487USU,                               
                        P_N_JAQL487PGO,               
                        P_N_JAQL487SUC,                
                        P_N_JAQL487MOD,                
                        P_N_JAQL487MDA,                
                        P_N_JAQL487CTA,                
                        P_N_JAQL487PAP,                
                        P_N_JAQL487OPE,                
                        P_N_JAQL487SUB,                
                        P_N_JAQL487TOP,
                        P_N_JAQL487MTO,
                        P_N_JAQL487MDO,
                        P_N_JAQL487TRN,                                 
                        P_N_JAQL487REL,
                        P_N_JAQL487FVA,
                        P_N_JAQL487UBS,
                        P_C_JAQL487CTE                      
                       );
    COMMIT; 
  END SP_AH_REG_COM;                                                             
  PROCEDURE SP_AH_BORRA_INCIDENCIA(P_D_FECGEN IN DATE,
                                   P_C_CTACLI IN VARCHAR2,    
                                   P_C_CODUSU IN VARCHAR2
                                   ) IS           
  BEGIN
    DELETE FROM JAQL452 A
     WHERE A.JAQL452FCH = P_D_FECGEN
       AND A.JAQL452CTA = P_C_CTACLI
       AND A.JAQL452USR = RPAD(P_C_CODUSU,10,' ');
  COMMIT;      
  EXCEPTION
  WHEN OTHERS THEN
       NULL;
  END SP_AH_BORRA_INCIDENCIA;    
 
end PQ_AH_EXTRACTOS;
/

