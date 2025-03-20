CREATE OR REPLACE PACKAGE PQ_AH_EXTRACTOS_TMP IS
  PROCEDURE SP_AH_REGISTRA_AFILIACION_TMP(P_N_JAQL460PGO IN NUMBER,
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
                                          P_C_ERROR      OUT VARCHAR2);

END PQ_AH_EXTRACTOS_TMP;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_EXTRACTOS_TMP IS
  PROCEDURE SP_AH_REGISTRA_AFILIACION_TMP(P_N_JAQL460PGO IN NUMBER,
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
                                          P_C_ERROR      OUT VARCHAR2) IS
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
      INSERT INTO JAQL460_TMP
        (JAQL460PGO,
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
         JAQL460AX5)
      VALUES
        (P_N_JAQL460PGO,
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
         to_char(sysdate, 'HH24:MI:SS'));
      COMMIT;
    end if;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      BEGIN
        IF P_C_JAQL460TME = 'N' THEN
          UPDATE JAQL460_TMP
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
                 JAQL460AX6 = to_char(sysdate, 'HH24:MI:SS')
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
          UPDATE JAQL460_TMP
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
                 JAQL460AX5 = to_char(sysdate, 'HH24:MI:SS')
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
          UPDATE JAQL460_TMP
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
                 JAQL460AX5 = to_char(sysdate, 'HH24:MI:SS')
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
  END SP_AH_REGISTRA_AFILIACION_TMP;
end PQ_AH_EXTRACTOS_TMP;
/

