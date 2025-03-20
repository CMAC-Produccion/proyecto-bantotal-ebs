create or replace package PQ_CR_REP_VARIABLES_HISTORICO_CRU is

  -- *****************************************************************
  -- NOMBRE                     : PQ_CR_REP_VARIABLES_HISTORICO_CRU
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CRÉDITOS - ACTIVAS
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 2024.04.11
  -- AUTOR DE CREACIÓN          : APACHECOH
  -- USO                        : BUSCA DATOS HISTORICOS SEGMENTACION, POTENCIALIDAD Y SCORE
  -- ESTADO                     : ACTIVO
  -- ACCESO                     : PÚBLICO
  -- FECHA DE MODIFICACIÓN      : 2024.05.15
  -- AUTOR DE LA MODIFICACIÓN   : APACHECOH 
  -- DESCRIPCIÓN DE MODIFICACIÓN: SE AGREGO GUIA QUE APAGA Y PRENDE
  -- ***************************************************************** 

  PROCEDURE SP_CR_GRABAR_LOG_EJECUCION(P_N_PAIS IN NUMBER,
                                       P_N_TDOC IN NUMBER,
                                       P_V_NDOC IN VARCHAR2,
                                       P_V_USER IN VARCHAR2,
                                       P_D_FECH IN DATE,
                                       P_N_CORR OUT NUMBER);

  PROCEDURE SP_CR_GRABAR_TIEMPO_EJECUCION(P_N_CORR IN NUMBER);

  PROCEDURE SP_CR_CARGAR_VARIABLES(P_N_PAIS IN NUMBER,
                                   P_N_TDOC IN NUMBER,
                                   P_V_NDOC IN VARCHAR2,
                                   P_V_USER IN VARCHAR2,
                                   P_D_FECH IN DATE,
                                   P_V_RPTA OUT VARCHAR2);

  PROCEDURE SP_CR_CARGAR_HIST_PYME(P_N_PAIS IN NUMBER,
                                   P_N_TDOC IN NUMBER,
                                   P_V_NDOC IN VARCHAR2,
                                   P_V_USER IN VARCHAR2,
                                   P_D_FECH IN DATE,
                                   P_V_RPTA OUT VARCHAR2);

  PROCEDURE SP_CR_CARGAR_HIST_CONSUMO(P_N_PAIS IN NUMBER,
                                      P_N_TDOC IN NUMBER,
                                      P_V_NDOC IN VARCHAR2,
                                      P_V_USER IN VARCHAR2,
                                      P_D_FECH IN DATE,
                                      P_V_RPTA OUT VARCHAR2);

  PROCEDURE SP_CR_CARGAR_HIST_MICRO(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2);

  PROCEDURE SP_CR_CARGAR_HIST_POTEN(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2);

  PROCEDURE SP_CR_CARGAR_HIST_SCORE(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2);

end PQ_CR_REP_VARIABLES_HISTORICO_CRU;
/

create or replace package body PQ_CR_REP_VARIABLES_HISTORICO_CRU is

  PROCEDURE SP_CR_GRABAR_LOG_EJECUCION(P_N_PAIS IN NUMBER,
                                       P_N_TDOC IN NUMBER,
                                       P_V_NDOC IN VARCHAR2,
                                       P_V_USER IN VARCHAR2,
                                       P_D_FECH IN DATE,
                                       P_N_CORR OUT NUMBER) IS
  BEGIN
    --HALLAR SIGUIENTE CORRELATIVO
    BEGIN
      SELECT NVL(MAX(AQPC956ACORR),1)+1 INTO P_N_CORR FROM AQPC956A;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERCION LOG
    BEGIN
      INSERT INTO AQPC956A
        (AQPC956ACORR,
         AQPC956AFERG,
         AQPC956AHORG,
         AQPC956AUSRG,
         AQPC956APAIS,
         AQPC956ATDOC,
         AQPC956ANDOC,
         AQPC956AFECH)
      VALUES
        (P_N_CORR,
         TRUNC(SYSDATE),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_V_USER,
         P_N_PAIS,
         P_N_TDOC,
         P_V_NDOC,
         P_D_FECH);
         COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_GRABAR_LOG_EJECUCION;

  PROCEDURE SP_CR_GRABAR_TIEMPO_EJECUCION(P_N_CORR IN NUMBER) IS
    L_V_HORREG VARCHAR2(8);
    L_V_HORACT VARCHAR2(8);
    L_N_DIF    NUMBER(10);
  BEGIN
    --HALLAR LA HORA DE REGISTRO
    BEGIN
      SELECT AQPC956AHORG
        INTO L_V_HORREG
        FROM AQPC956A
       WHERE AQPC956ACORR = P_N_CORR;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    L_V_HORACT := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    --HALLA LA DIFERENCIA EN SEGUNDOS
    BEGIN
      SELECT ABS((TO_DATE(L_V_HORACT, 'HH24:MI:SS') -
                 TO_DATE(L_V_HORREG, 'HH24:MI:SS')) * 24 * 60 * 60)
        INTO L_N_DIF
        FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --ACTUALIZAR LA HORA DE FINALIZACIÓN
    BEGIN
      UPDATE AQPC956A
         SET AQPC956AHORF = L_V_HORACT, AQPC956ATIME = L_N_DIF
       WHERE AQPC956ACORR = P_N_CORR;
       COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_GRABAR_TIEMPO_EJECUCION;

  PROCEDURE SP_CR_CARGAR_VARIABLES(P_N_PAIS IN NUMBER,
                                   P_N_TDOC IN NUMBER,
                                   P_V_NDOC IN VARCHAR2,
                                   P_V_USER IN VARCHAR2,
                                   P_D_FECH IN DATE,
                                   P_V_RPTA OUT VARCHAR2) IS
    L_V_ERROR VARCHAR2(500);
  BEGIN
    --Limpieza de tabla por Usuario y Fecha
    BEGIN
      DELETE FROM AQPC956
       WHERE AQPC956FERG = TRUNC(SYSDATE)
         AND AQPC956USRG = P_V_USER;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Carga de Segmentación Pyme
    BEGIN
      PQ_CR_REP_VARIABLES_HISTORICO_CRU.SP_CR_CARGAR_HIST_PYME(P_N_PAIS,
                                                               P_N_TDOC,
                                                               P_V_NDOC,
                                                               P_V_USER,
                                                               P_D_FECH,
                                                               P_V_RPTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Carga de Segmentación Consumo
    BEGIN
      PQ_CR_REP_VARIABLES_HISTORICO_CRU.SP_CR_CARGAR_HIST_CONSUMO(P_N_PAIS,
                                                                  P_N_TDOC,
                                                                  P_V_NDOC,
                                                                  P_V_USER,
                                                                  P_D_FECH,
                                                                  P_V_RPTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Carga de Segmentación Micro
    BEGIN
      PQ_CR_REP_VARIABLES_HISTORICO_CRU.SP_CR_CARGAR_HIST_MICRO(P_N_PAIS,
                                                                P_N_TDOC,
                                                                P_V_NDOC,
                                                                P_V_USER,
                                                                P_D_FECH,
                                                                P_V_RPTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Carga de Potencilidad    
    BEGIN
      PQ_CR_REP_VARIABLES_HISTORICO_CRU.SP_CR_CARGAR_HIST_POTEN(P_N_PAIS,
                                                                P_N_TDOC,
                                                                P_V_NDOC,
                                                                P_V_USER,
                                                                P_D_FECH,
                                                                P_V_RPTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --Carga de Score
    BEGIN
      PQ_CR_REP_VARIABLES_HISTORICO_CRU.SP_CR_CARGAR_HIST_SCORE(P_N_PAIS,
                                                                P_N_TDOC,
                                                                P_V_NDOC,
                                                                P_V_USER,
                                                                P_D_FECH,
                                                                P_V_RPTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_CARGAR_VARIABLES;

  PROCEDURE SP_CR_CARGAR_HIST_PYME(P_N_PAIS IN NUMBER,
                                   P_N_TDOC IN NUMBER,
                                   P_V_NDOC IN VARCHAR2,
                                   P_V_USER IN VARCHAR2,
                                   P_D_FECH IN DATE,
                                   P_V_RPTA OUT VARCHAR2) IS
  
    TYPE MATRIZ_TIPO IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE MATRIZ_BIDIMENSIONAL IS TABLE OF MATRIZ_TIPO INDEX BY BINARY_INTEGER;
  
    MATRIZ    MATRIZ_BIDIMENSIONAL;
    MATRIZ0   MATRIZ_BIDIMENSIONAL;
    LN_TMPNUM NUMBER(10);
  
    P_N_VAR   NUMBER(10);
    D_FECCOR  DATE;
    D_FECFIN  DATE;
    L_MESES   NUMBER(10);
    L_TOPE    NUMBER(10);
    L_FLAG    VARCHAR2(2);
    L_VARIAB  VARCHAR2(30);
    LV_NOMBRE VARCHAR2(30);
    LV_VALOR  VARCHAR2(30);
    CURSOR N_VARIABLES(D_FECHA DATE) IS
      SELECT AQPC187VAR1,
             AQPC187VAR2,
             AQPC187VAR3,
             AQPC187VAR4,
             AQPC187VAR5,
             AQPC187VAR6,
             AQPC187VAR7,
             AQPC187VAR8,
             AQPC187VAR9,
             AQPC187VAR10,
             AQPC187VAR11,
             AQPC187VAR12,
             AQPC187VAR13,
             AQPC187VAR14,
             AQPC187VAR15
        FROM AQPC187 A
       WHERE A.AQPC187FECH = D_FECHA
         AND A.AQPC187PAIS = P_N_PAIS
         AND A.AQPC187TDOC = P_N_TDOC
         AND A.AQPC187NDOC = RPAD(P_V_NDOC, 12, ' ');
  
    CURSOR N_VARIABLES_2(D_FECHA DATE) IS
      SELECT JAQZ095VAR1,
             JAQZ095VAR2,
             JAQZ095VAR3,
             JAQZ095VAR4,
             JAQZ095VAR5,
             JAQZ095VAR6,
             JAQZ095VAR7,
             JAQZ095VAR8,
             JAQZ095VAR9,
             JAQZ095VAR10,
             JAQZ095VAR11,
             JAQZ095VAR12,
             JAQZ095VAR13,
             JAQZ095VAR14,
             JAQZ095VAR15
        FROM JAQZ095 A
       WHERE A.JAQZ095FECH = D_FECHA
         AND A.JAQZ095PAIS = P_N_PAIS
         AND A.JAQZ095TDOC = P_N_TDOC
         AND A.JAQZ095NDOC = RPAD(P_V_NDOC, 12, ' ');
  
    CURSOR N_CALIFICACION(D_FECHA DATE) IS
      SELECT Q.JAQY067NCAL
        FROM JAQY066 J, JAQY067 Q
       WHERE J.JAQY066CALF = Q.JAQY067CCAL
         AND J.JAQY066PAIC = P_N_PAIS
         AND J.JAQY066TDOC = P_N_TDOC
         AND J.JAQY066TNDOC = RPAD(P_V_NDOC, 12, ' ')
         AND J.JAQY066FECP = D_FECHA
         AND J.JAQY066TSE = 'N';
  
    CURSOR N_CALIFICACION_2(D_FECHA DATE) IS
      SELECT Q.JAQY067NCAL
        FROM JAQY066 J, JAQY067 Q
       WHERE J.JAQY066CALF = Q.JAQY067CCAL
         AND J.JAQY066PAIC = P_N_PAIS
         AND J.JAQY066TDOC = P_N_TDOC
         AND J.JAQY066TNDOC = RPAD(P_V_NDOC, 12, ' ')
         AND J.JAQY066FECP = D_FECHA
         AND J.JAQY066TSE = 'S';
  
    CURSOR GUIA_VARIABLES IS
      SELECT F.TP1CORR3
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 1
         AND F.TP1CORR3 > 0;
  
    CURSOR GUIA_VARIABLES_2 IS
      SELECT F.TP1CORR3, F.TP1DESC, F.TP1IMP1
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 1
         AND F.TP1CORR3 > 0
         AND F.TP1NRO3 = 1;
  
  BEGIN
    --GUÍA DE LIMITE DE MESES
    BEGIN
      SELECT F.TPNRO
        INTO L_MESES
        FROM FST098 F
       WHERE F.TPCOD = 7755
         AND F.TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --GUIA DE VARIABLES HABILITADAS
    BEGIN
      SELECT MAX(F.TP1CORR3)
        INTO L_TOPE
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    D_FECFIN := P_D_FECH;
    D_FECCOR := TO_DATE('30/09/2022', 'DD/MM/RRRR');
    P_V_RPTA := 'N';
  
    --BUCLE PARA ALMACENAR LAS VARIABLES EN UN ARRAY
    FOR K IN 1 .. L_MESES LOOP
      FOR J IN GUIA_VARIABLES LOOP

        --INSERCION DE MATRIZ DE CALIFICACIÓN
        L_FLAG := 'N';
        IF D_FECFIN >= D_FECCOR THEN
          FOR I IN N_CALIFICACION(D_FECFIN) LOOP
            MATRIZ0(1)(K) := I.JAQY067NCAL;
            L_FLAG := 'S';
          END LOOP;
        ELSE
          FOR I IN N_CALIFICACION_2(D_FECFIN) LOOP
            MATRIZ0(1)(K) := I.JAQY067NCAL;
            L_FLAG := 'S';
          END LOOP;
        END IF;
        IF L_FLAG = 'N' THEN
          MATRIZ0(1)(K) := '-';
        END IF;
        --INSERCION DE MATRIZ DE VARIABLES
        BEGIN
          SELECT TRIM(F.TP1DESC)
            INTO L_VARIAB
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 11171
             AND F.TP1CORR1 = 30
             AND F.TP1CORR2 = 1
             AND F.TP1CORR3 = J.TP1CORR3
             AND F.TP1NRO3 = 1;
        EXCEPTION
          WHEN OTHERS THEN
            L_VARIAB := '';
        END;
        L_FLAG := 'N';
        IF TRIM(L_VARIAB) IS NOT NULL THEN
          --VALIDAR SI LA FECHA ES ANTES DEL CAMBIO DE SEGMENTACIÓN
          IF D_FECFIN >= D_FECCOR THEN
            FOR I IN N_VARIABLES(D_FECFIN) LOOP
              LN_TMPNUM := INSTR(I.AQPC187VAR1, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR1, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR1, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR2, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR2, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR2, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR3, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR3, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR3, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR4, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR4, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR4, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR5, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR5, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR5, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR6, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR6, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR6, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR7, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR7, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR7, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR8, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR8, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR8, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR9, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR9, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR9, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR10, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR10, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR10, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR11, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR11, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR11, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR12, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR12, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR12, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR13, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR13, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR13, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR14, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR14, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR14, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.AQPC187VAR15, '=');
              LV_NOMBRE := SUBSTR(I.AQPC187VAR15, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.AQPC187VAR15, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            END LOOP;
          ELSE
            FOR I IN N_VARIABLES_2(D_FECFIN) LOOP
              LN_TMPNUM := INSTR(I.JAQZ095VAR1, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR1, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR1, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR2, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR2, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR2, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR3, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR3, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR3, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR4, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR4, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR4, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR5, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR5, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR5, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR6, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR6, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR6, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR7, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR7, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR7, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR8, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR8, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR8, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR9, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR9, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR9, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR10, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR10, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR10, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR11, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR11, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR11, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR12, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR12, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR12, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR13, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR13, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR13, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR14, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR14, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR14, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            
              LN_TMPNUM := INSTR(I.JAQZ095VAR15, '=');
              LV_NOMBRE := SUBSTR(I.JAQZ095VAR15, 1, LN_TMPNUM - 1);
              LV_VALOR  := SUBSTR(I.JAQZ095VAR15, LN_TMPNUM + 1);
              IF LV_NOMBRE = L_VARIAB THEN
                MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
                L_FLAG := 'S';
              END IF;
            END LOOP;
          END IF;
          IF L_FLAG = 'N' THEN
            MATRIZ(K)(J.TP1CORR3) := '-';
          END IF;
        ELSE
          MATRIZ(K)(J.TP1CORR3) := '-';
        END IF;
      END LOOP;
      D_FECFIN := ADD_MONTHS(D_FECFIN, -1);
    END LOOP;
  
    /*FOR T IN 1 .. L_MESES LOOP
      FOR A IN 1 .. L_TOPE LOOP
        DBMS_OUTPUT.PUT(matriz(T) (A) || ' ');
      END LOOP;
      DBMS_OUTPUT.NEW_LINE;
    END LOOP;*/
  
    --INSERCION DE CALIFICACION LOG
    BEGIN
      INSERT INTO AQPC956
        (AQPC956FERG,
         AQPC956HORG,
         AQPC956USRG,
         AQPC956PAIS,
         AQPC956TDOC,
         AQPC956NDOC,
         AQPC956FECH,
         AQPC956TIPO,
         AQPC956VARC,
         AQPC956VAL1,
         AQPC956VAL2,
         AQPC956VAL3,
         AQPC956VAL4,
         AQPC956VAL5,
         AQPC956VAL6,
         AQPC956VAL7,
         AQPC956VAL8,
         AQPC956VAL9,
         AQPC956VAL10,
         AQPC956VAL11,
         AQPC956VAL12,
         AQPC956VAL13,
         AQPC956VAL14,
         AQPC956VAL15,
         AQPC956VAL16,
         AQPC956VAL17,
         AQPC956VAL18,
         AQPC956VAL19,
         AQPC956VAL20,
         AQPC956VAL21,
         AQPC956VAL22,
         AQPC956VAL23,
         AQPC956VAL24,
         AQPC956VAL25,
         AQPC956VAL26,
         AQPC956VAL27,
         AQPC956VAL28,
         AQPC956VAL29,
         AQPC956VAL30,
         AQPC956VAL31,
         AQPC956VAL32,
         AQPC956VAL33,
         AQPC956VAL34,
         AQPC956VAL35,
         AQPC956VAL36,
         AQPC956AUX1)
      VALUES
        (TRUNC(SYSDATE),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_V_USER,
         P_N_PAIS,
         P_N_TDOC,
         P_V_NDOC,
         P_D_FECH,
         1,
         'SEGMENTACIÓN MYPE',
         MATRIZ0(1) (1),
         MATRIZ0(1) (2),
         MATRIZ0(1) (3),
         MATRIZ0(1) (4),
         MATRIZ0(1) (5),
         MATRIZ0(1) (6),
         MATRIZ0(1) (7),
         MATRIZ0(1) (8),
         MATRIZ0(1) (9),
         MATRIZ0(1) (10),
         MATRIZ0(1) (11),
         MATRIZ0(1) (12),
         MATRIZ0(1) (13),
         MATRIZ0(1) (14),
         MATRIZ0(1) (15),
         MATRIZ0(1) (16),
         MATRIZ0(1) (17),
         MATRIZ0(1) (18),
         MATRIZ0(1) (19),
         MATRIZ0(1) (20),
         MATRIZ0(1) (21),
         MATRIZ0(1) (22),
         MATRIZ0(1) (23),
         MATRIZ0(1) (24),
         MATRIZ0(1) (25),
         MATRIZ0(1) (26),
         MATRIZ0(1) (27),
         MATRIZ0(1) (28),
         MATRIZ0(1) (29),
         MATRIZ0(1) (30),
         MATRIZ0(1) (31),
         MATRIZ0(1) (32),
         MATRIZ0(1) (33),
         MATRIZ0(1) (34),
         MATRIZ0(1) (35),
         MATRIZ0(1) (36),
         0);
      COMMIT;
      P_V_RPTA := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERCION DE VARIABLES LOG    
    FOR H IN GUIA_VARIABLES_2 LOOP
      BEGIN
        INSERT INTO AQPC956
          (AQPC956FERG,
           AQPC956HORG,
           AQPC956USRG,
           AQPC956PAIS,
           AQPC956TDOC,
           AQPC956NDOC,
           AQPC956FECH,
           AQPC956TIPO,
           AQPC956VARC,
           AQPC956VAL1,
           AQPC956VAL2,
           AQPC956VAL3,
           AQPC956VAL4,
           AQPC956VAL5,
           AQPC956VAL6,
           AQPC956VAL7,
           AQPC956VAL8,
           AQPC956VAL9,
           AQPC956VAL10,
           AQPC956VAL11,
           AQPC956VAL12,
           AQPC956VAL13,
           AQPC956VAL14,
           AQPC956VAL15,
           AQPC956VAL16,
           AQPC956VAL17,
           AQPC956VAL18,
           AQPC956VAL19,
           AQPC956VAL20,
           AQPC956VAL21,
           AQPC956VAL22,
           AQPC956VAL23,
           AQPC956VAL24,
           AQPC956VAL25,
           AQPC956VAL26,
           AQPC956VAL27,
           AQPC956VAL28,
           AQPC956VAL29,
           AQPC956VAL30,
           AQPC956VAL31,
           AQPC956VAL32,
           AQPC956VAL33,
           AQPC956VAL34,
           AQPC956VAL35,
           AQPC956VAL36,
           AQPC956AUX1)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USER,
           P_N_PAIS,
           P_N_TDOC,
           P_V_NDOC,
           P_D_FECH,
           1,
           TRIM(H.TP1DESC),
           MATRIZ(1) (H.TP1CORR3),
           MATRIZ(2) (H.TP1CORR3),
           MATRIZ(3) (H.TP1CORR3),
           MATRIZ(4) (H.TP1CORR3),
           MATRIZ(5) (H.TP1CORR3),
           MATRIZ(6) (H.TP1CORR3),
           MATRIZ(7) (H.TP1CORR3),
           MATRIZ(8) (H.TP1CORR3),
           MATRIZ(9) (H.TP1CORR3),
           MATRIZ(10) (H.TP1CORR3),
           MATRIZ(11) (H.TP1CORR3),
           MATRIZ(12) (H.TP1CORR3),
           MATRIZ(13) (H.TP1CORR3),
           MATRIZ(14) (H.TP1CORR3),
           MATRIZ(15) (H.TP1CORR3),
           MATRIZ(16) (H.TP1CORR3),
           MATRIZ(17) (H.TP1CORR3),
           MATRIZ(18) (H.TP1CORR3),
           MATRIZ(19) (H.TP1CORR3),
           MATRIZ(20) (H.TP1CORR3),
           MATRIZ(21) (H.TP1CORR3),
           MATRIZ(22) (H.TP1CORR3),
           MATRIZ(23) (H.TP1CORR3),
           MATRIZ(24) (H.TP1CORR3),
           MATRIZ(25) (H.TP1CORR3),
           MATRIZ(26) (H.TP1CORR3),
           MATRIZ(27) (H.TP1CORR3),
           MATRIZ(28) (H.TP1CORR3),
           MATRIZ(29) (H.TP1CORR3),
           MATRIZ(30) (H.TP1CORR3),
           MATRIZ(31) (H.TP1CORR3),
           MATRIZ(32) (H.TP1CORR3),
           MATRIZ(33) (H.TP1CORR3),
           MATRIZ(34) (H.TP1CORR3),
           MATRIZ(35) (H.TP1CORR3),
           MATRIZ(36) (H.TP1CORR3),
           H.TP1IMP1);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
  END SP_CR_CARGAR_HIST_PYME;

  PROCEDURE SP_CR_CARGAR_HIST_CONSUMO(P_N_PAIS IN NUMBER,
                                      P_N_TDOC IN NUMBER,
                                      P_V_NDOC IN VARCHAR2,
                                      P_V_USER IN VARCHAR2,
                                      P_D_FECH IN DATE,
                                      P_V_RPTA OUT VARCHAR2) IS
  
    TYPE MATRIZ_TIPO IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE MATRIZ_BIDIMENSIONAL IS TABLE OF MATRIZ_TIPO INDEX BY BINARY_INTEGER;
  
    MATRIZ    MATRIZ_BIDIMENSIONAL;
    MATRIZ0   MATRIZ_BIDIMENSIONAL;
    LN_TMPNUM NUMBER(10);
  
    P_N_VAR   NUMBER(10);
    D_FECCOR  DATE;
    D_FECFIN  DATE;
    L_MESES   NUMBER(10);
    L_TOPE    NUMBER(10);
    L_FLAG    VARCHAR2(2);
    L_VARIAB  VARCHAR2(30);
    LV_NOMBRE VARCHAR2(30);
    LV_VALOR  VARCHAR2(30);
  
    CURSOR N_VARIABLES(D_FECHA DATE) IS
      SELECT JAQZ680VAR1,
             JAQZ680VAR2,
             JAQZ680VAR3,
             JAQZ680VAR4,
             JAQZ680VAR5,
             JAQZ680VAR6,
             JAQZ680VAR7,
             JAQZ680VAR8,
             JAQZ680VAR9,
             JAQZ680VAR10,
             JAQZ680VAR11,
             JAQZ680VAR12,
             JAQZ680VAR13,
             JAQZ680VAR14,
             JAQZ680VAR15
        FROM JAQZ680 A
       WHERE A.JAQZ680FECH = D_FECHA
         AND A.JAQZ680PAIS = P_N_PAIS
         AND A.JAQZ680TDOC = P_N_TDOC
         AND A.JAQZ680NDOC = RPAD(P_V_NDOC, 12, ' ');
  
    CURSOR N_CALIFICACION(D_FECHA DATE) IS
      SELECT Q.JAQZ662NCAL
        FROM JAQZ681 J, JAQZ662 Q
       WHERE J.JAQZ681CALF = Q.JAQZ662CCAL
         AND J.JAQZ681PAIC = P_N_PAIS
         AND J.JAQZ681TDOC = P_N_TDOC
         AND J.JAQZ681TNDOC = RPAD(P_V_NDOC, 12, ' ')
         AND J.JAQZ681FECP = D_FECHA;
  
    CURSOR GUIA_VARIABLES IS
      SELECT F.TP1CORR3
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 2
         AND F.TP1CORR3 > 0;
  
    CURSOR GUIA_VARIABLES_2 IS
      SELECT F.TP1CORR3, F.TP1DESC, F.TP1IMP1
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 2
         AND F.TP1CORR3 > 0
         AND F.TP1NRO3 = 1;
  
  BEGIN
    --GUÍA DE LIMITE DE MESES
    BEGIN
      SELECT F.TPNRO
        INTO L_MESES
        FROM FST098 F
       WHERE F.TPCOD = 7755
         AND F.TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --GUIA DE VARIABLES HABILITADAS
    BEGIN
      SELECT MAX(F.TP1CORR3)
        INTO L_TOPE
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    D_FECFIN := P_D_FECH;
    D_FECCOR := TO_DATE('30/09/2022', 'DD/MM/RRRR');
    P_V_RPTA := 'N';
  
    --BUCLE PARA ALMACENAR LAS VARIABLES EN UN ARRAY
    FOR K IN 1 .. L_MESES LOOP
      FOR J IN GUIA_VARIABLES LOOP
        --INSERCION DE MATRIZ DE CALIFICACIÓN
        L_FLAG := 'N';
        FOR I IN N_CALIFICACION(D_FECFIN) LOOP
          MATRIZ0(1)(K) := I.JAQZ662NCAL;
          L_FLAG := 'S';
        END LOOP;
        IF L_FLAG = 'N' THEN
          MATRIZ0(1)(K) := '-';
        END IF;
        --INSERCION DE MATRIZ DE VARIABLES
        BEGIN
          SELECT TRIM(F.TP1DESC)
            INTO L_VARIAB
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 11171
             AND F.TP1CORR1 = 30
             AND F.TP1CORR2 = 2
             AND F.TP1CORR3 = J.TP1CORR3
             AND F.TP1NRO3 = 1;
        EXCEPTION
          WHEN OTHERS THEN
            L_VARIAB := '';
        END;
        L_FLAG := 'N';
        IF TRIM(L_VARIAB) IS NOT NULL THEN
          FOR I IN N_VARIABLES(D_FECFIN) LOOP
            LN_TMPNUM := INSTR(I.JAQZ680VAR1, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR1, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR1, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR2, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR2, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR2, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR3, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR3, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR3, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR4, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR4, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR4, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR5, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR5, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR5, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR6, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR6, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR6, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR7, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR7, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR7, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR8, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR8, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR8, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR9, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR9, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR9, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR10, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR10, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR10, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR11, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR11, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR11, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR12, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR12, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR12, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR13, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR13, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR13, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR14, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR14, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR14, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ680VAR15, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ680VAR15, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ680VAR15, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          END LOOP;
          IF L_FLAG = 'N' THEN
            MATRIZ(K)(J.TP1CORR3) := '-';
          END IF;
        ELSE
          MATRIZ(K)(J.TP1CORR3) := '-';
        END IF;
      END LOOP;
      D_FECFIN := ADD_MONTHS(D_FECFIN, -1);
    END LOOP;
  
    --INSERCION DE CALIFICACION LOG
    BEGIN
      INSERT INTO AQPC956
        (AQPC956FERG,
         AQPC956HORG,
         AQPC956USRG,
         AQPC956PAIS,
         AQPC956TDOC,
         AQPC956NDOC,
         AQPC956FECH,
         AQPC956TIPO,
         AQPC956VARC,
         AQPC956VAL1,
         AQPC956VAL2,
         AQPC956VAL3,
         AQPC956VAL4,
         AQPC956VAL5,
         AQPC956VAL6,
         AQPC956VAL7,
         AQPC956VAL8,
         AQPC956VAL9,
         AQPC956VAL10,
         AQPC956VAL11,
         AQPC956VAL12,
         AQPC956VAL13,
         AQPC956VAL14,
         AQPC956VAL15,
         AQPC956VAL16,
         AQPC956VAL17,
         AQPC956VAL18,
         AQPC956VAL19,
         AQPC956VAL20,
         AQPC956VAL21,
         AQPC956VAL22,
         AQPC956VAL23,
         AQPC956VAL24,
         AQPC956VAL25,
         AQPC956VAL26,
         AQPC956VAL27,
         AQPC956VAL28,
         AQPC956VAL29,
         AQPC956VAL30,
         AQPC956VAL31,
         AQPC956VAL32,
         AQPC956VAL33,
         AQPC956VAL34,
         AQPC956VAL35,
         AQPC956VAL36,
         AQPC956AUX1)
      VALUES
        (TRUNC(SYSDATE),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_V_USER,
         P_N_PAIS,
         P_N_TDOC,
         P_V_NDOC,
         P_D_FECH,
         2,
         'SEGMENTACIÓN CONSUMO',
         MATRIZ0(1) (1),
         MATRIZ0(1) (2),
         MATRIZ0(1) (3),
         MATRIZ0(1) (4),
         MATRIZ0(1) (5),
         MATRIZ0(1) (6),
         MATRIZ0(1) (7),
         MATRIZ0(1) (8),
         MATRIZ0(1) (9),
         MATRIZ0(1) (10),
         MATRIZ0(1) (11),
         MATRIZ0(1) (12),
         MATRIZ0(1) (13),
         MATRIZ0(1) (14),
         MATRIZ0(1) (15),
         MATRIZ0(1) (16),
         MATRIZ0(1) (17),
         MATRIZ0(1) (18),
         MATRIZ0(1) (19),
         MATRIZ0(1) (20),
         MATRIZ0(1) (21),
         MATRIZ0(1) (22),
         MATRIZ0(1) (23),
         MATRIZ0(1) (24),
         MATRIZ0(1) (25),
         MATRIZ0(1) (26),
         MATRIZ0(1) (27),
         MATRIZ0(1) (28),
         MATRIZ0(1) (29),
         MATRIZ0(1) (30),
         MATRIZ0(1) (31),
         MATRIZ0(1) (32),
         MATRIZ0(1) (33),
         MATRIZ0(1) (34),
         MATRIZ0(1) (35),
         MATRIZ0(1) (36),
         0);
      COMMIT;
      P_V_RPTA := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERCION DE VARIABLES LOG    
    FOR H IN GUIA_VARIABLES_2 LOOP
      BEGIN
        INSERT INTO AQPC956
          (AQPC956FERG,
           AQPC956HORG,
           AQPC956USRG,
           AQPC956PAIS,
           AQPC956TDOC,
           AQPC956NDOC,
           AQPC956FECH,
           AQPC956TIPO,
           AQPC956VARC,
           AQPC956VAL1,
           AQPC956VAL2,
           AQPC956VAL3,
           AQPC956VAL4,
           AQPC956VAL5,
           AQPC956VAL6,
           AQPC956VAL7,
           AQPC956VAL8,
           AQPC956VAL9,
           AQPC956VAL10,
           AQPC956VAL11,
           AQPC956VAL12,
           AQPC956VAL13,
           AQPC956VAL14,
           AQPC956VAL15,
           AQPC956VAL16,
           AQPC956VAL17,
           AQPC956VAL18,
           AQPC956VAL19,
           AQPC956VAL20,
           AQPC956VAL21,
           AQPC956VAL22,
           AQPC956VAL23,
           AQPC956VAL24,
           AQPC956VAL25,
           AQPC956VAL26,
           AQPC956VAL27,
           AQPC956VAL28,
           AQPC956VAL29,
           AQPC956VAL30,
           AQPC956VAL31,
           AQPC956VAL32,
           AQPC956VAL33,
           AQPC956VAL34,
           AQPC956VAL35,
           AQPC956VAL36,
           AQPC956AUX1)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USER,
           P_N_PAIS,
           P_N_TDOC,
           P_V_NDOC,
           P_D_FECH,
           2,
           TRIM(H.TP1DESC),
           MATRIZ(1) (H.TP1CORR3),
           MATRIZ(2) (H.TP1CORR3),
           MATRIZ(3) (H.TP1CORR3),
           MATRIZ(4) (H.TP1CORR3),
           MATRIZ(5) (H.TP1CORR3),
           MATRIZ(6) (H.TP1CORR3),
           MATRIZ(7) (H.TP1CORR3),
           MATRIZ(8) (H.TP1CORR3),
           MATRIZ(9) (H.TP1CORR3),
           MATRIZ(10) (H.TP1CORR3),
           MATRIZ(11) (H.TP1CORR3),
           MATRIZ(12) (H.TP1CORR3),
           MATRIZ(13) (H.TP1CORR3),
           MATRIZ(14) (H.TP1CORR3),
           MATRIZ(15) (H.TP1CORR3),
           MATRIZ(16) (H.TP1CORR3),
           MATRIZ(17) (H.TP1CORR3),
           MATRIZ(18) (H.TP1CORR3),
           MATRIZ(19) (H.TP1CORR3),
           MATRIZ(20) (H.TP1CORR3),
           MATRIZ(21) (H.TP1CORR3),
           MATRIZ(22) (H.TP1CORR3),
           MATRIZ(23) (H.TP1CORR3),
           MATRIZ(24) (H.TP1CORR3),
           MATRIZ(25) (H.TP1CORR3),
           MATRIZ(26) (H.TP1CORR3),
           MATRIZ(27) (H.TP1CORR3),
           MATRIZ(28) (H.TP1CORR3),
           MATRIZ(29) (H.TP1CORR3),
           MATRIZ(30) (H.TP1CORR3),
           MATRIZ(31) (H.TP1CORR3),
           MATRIZ(32) (H.TP1CORR3),
           MATRIZ(33) (H.TP1CORR3),
           MATRIZ(34) (H.TP1CORR3),
           MATRIZ(35) (H.TP1CORR3),
           MATRIZ(36) (H.TP1CORR3),
           H.TP1IMP1);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
  END SP_CR_CARGAR_HIST_CONSUMO;

  PROCEDURE SP_CR_CARGAR_HIST_MICRO(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2) IS
  
    TYPE MATRIZ_TIPO IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE MATRIZ_BIDIMENSIONAL IS TABLE OF MATRIZ_TIPO INDEX BY BINARY_INTEGER;
  
    MATRIZ    MATRIZ_BIDIMENSIONAL;
    MATRIZ0   MATRIZ_BIDIMENSIONAL;
    LN_TMPNUM NUMBER(10);
  
    P_N_VAR   NUMBER(10);
    D_FECCOR  DATE;
    D_FECFIN  DATE;
    L_MESES   NUMBER(10);
    L_TOPE    NUMBER(10);
    L_FLAG    VARCHAR2(2);
    L_VARIAB  VARCHAR2(30);
    LV_NOMBRE VARCHAR2(30);
    LV_VALOR  VARCHAR2(30);
  
    CURSOR N_VARIABLES(D_FECHA DATE) IS
      SELECT JAQZ673VAR1,
             JAQZ673VAR2,
             JAQZ673VAR3,
             JAQZ673VAR4,
             JAQZ673VAR5,
             JAQZ673VAR6,
             JAQZ673VAR7,
             JAQZ673VAR8,
             JAQZ673VAR9,
             JAQZ673VAR10,
             JAQZ673VAR11,
             JAQZ673VAR12,
             JAQZ673VAR13,
             JAQZ673VAR14,
             JAQZ673VAR15
        FROM JAQZ673 A
       WHERE A.JAQZ673FECH = D_FECHA
         AND A.JAQZ673PAIS = P_N_PAIS
         AND A.JAQZ673TDOC = P_N_TDOC
         AND A.JAQZ673NDOC = RPAD(P_V_NDOC, 12, ' ');
  
    CURSOR N_CALIFICACION(D_FECHA DATE) IS
      SELECT Q.AQPB916NCAL
        FROM JAQZ674 J, AQPB916 Q
       WHERE J.JAQZ674CALF = Q.AQPB916CCAL
         AND J.JAQZ674PAIC = P_N_PAIS
         AND J.JAQZ674TDOC = P_N_TDOC
         AND J.JAQZ674TNDOC = RPAD(P_V_NDOC, 12, ' ')
         AND J.JAQZ674FECP = D_FECHA;
  
    CURSOR GUIA_VARIABLES IS
      SELECT F.TP1CORR3
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 3
         AND F.TP1CORR3 > 0;
  
    CURSOR GUIA_VARIABLES_2 IS
      SELECT F.TP1CORR3, F.TP1DESC, F.TP1IMP1
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 3
         AND F.TP1CORR3 > 0
         AND F.TP1NRO3 = 1;
  
  BEGIN
    --GUÍA DE LIMITE DE MESES
    BEGIN
      SELECT F.TPNRO
        INTO L_MESES
        FROM FST098 F
       WHERE F.TPCOD = 7755
         AND F.TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --GUIA DE VARIABLES HABILITADAS
    BEGIN
      SELECT MAX(F.TP1CORR3)
        INTO L_TOPE
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 3;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    D_FECFIN := P_D_FECH;
    D_FECCOR := TO_DATE('30/09/2022', 'DD/MM/RRRR');
    P_V_RPTA := 'N';
  
    --BUCLE PARA ALMACENAR LAS VARIABLES EN UN ARRAY
    FOR K IN 1 .. L_MESES LOOP
      FOR J IN GUIA_VARIABLES LOOP
        --INSERCION DE MATRIZ DE CALIFICACIÓN
        L_FLAG := 'N';
        FOR I IN N_CALIFICACION(D_FECFIN) LOOP
          MATRIZ0(1)(K) := I.AQPB916NCAL;
          L_FLAG := 'S';
        END LOOP;
        IF L_FLAG = 'N' THEN
          MATRIZ0(1)(K) := '-';
        END IF;
        --INSERCION DE MATRIZ DE VARIABLES
        BEGIN
          SELECT TRIM(F.TP1DESC)
            INTO L_VARIAB
            FROM FST198 F
           WHERE F.TP1COD = 1
             AND F.TP1COD1 = 11171
             AND F.TP1CORR1 = 30
             AND F.TP1CORR2 = 3
             AND F.TP1CORR3 = J.TP1CORR3
             AND F.TP1NRO3 = 1;
        EXCEPTION
          WHEN OTHERS THEN
            L_VARIAB := '';
        END;
        L_FLAG := 'N';
        IF TRIM(L_VARIAB) IS NOT NULL THEN
          FOR I IN N_VARIABLES(D_FECFIN) LOOP
            LN_TMPNUM := INSTR(I.JAQZ673VAR1, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR1, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR1, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR2, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR2, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR2, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR3, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR3, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR3, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR4, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR4, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR4, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR5, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR5, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR5, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR6, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR6, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR6, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR7, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR7, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR7, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR8, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR8, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR8, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR9, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR9, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR9, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR10, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR10, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR10, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR11, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR11, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR11, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR12, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR12, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR12, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR13, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR13, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR13, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR14, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR14, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR14, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          
            LN_TMPNUM := INSTR(I.JAQZ673VAR15, '=');
            LV_NOMBRE := SUBSTR(I.JAQZ673VAR15, 1, LN_TMPNUM - 1);
            LV_VALOR  := SUBSTR(I.JAQZ673VAR15, LN_TMPNUM + 1);
            IF LV_NOMBRE = L_VARIAB THEN
              MATRIZ(K)(J.TP1CORR3) := LV_VALOR;
              L_FLAG := 'S';
            END IF;
          END LOOP;
          IF L_FLAG = 'N' THEN
            MATRIZ(K)(J.TP1CORR3) := '-';
          END IF;
        ELSE
          MATRIZ(K)(J.TP1CORR3) := '-';
        END IF;
      END LOOP;
      D_FECFIN := ADD_MONTHS(D_FECFIN, -1);
    END LOOP;
  
    --INSERCION DE CALIFICACION LOG
    BEGIN
      INSERT INTO AQPC956
        (AQPC956FERG,
         AQPC956HORG,
         AQPC956USRG,
         AQPC956PAIS,
         AQPC956TDOC,
         AQPC956NDOC,
         AQPC956FECH,
         AQPC956TIPO,
         AQPC956VARC,
         AQPC956VAL1,
         AQPC956VAL2,
         AQPC956VAL3,
         AQPC956VAL4,
         AQPC956VAL5,
         AQPC956VAL6,
         AQPC956VAL7,
         AQPC956VAL8,
         AQPC956VAL9,
         AQPC956VAL10,
         AQPC956VAL11,
         AQPC956VAL12,
         AQPC956VAL13,
         AQPC956VAL14,
         AQPC956VAL15,
         AQPC956VAL16,
         AQPC956VAL17,
         AQPC956VAL18,
         AQPC956VAL19,
         AQPC956VAL20,
         AQPC956VAL21,
         AQPC956VAL22,
         AQPC956VAL23,
         AQPC956VAL24,
         AQPC956VAL25,
         AQPC956VAL26,
         AQPC956VAL27,
         AQPC956VAL28,
         AQPC956VAL29,
         AQPC956VAL30,
         AQPC956VAL31,
         AQPC956VAL32,
         AQPC956VAL33,
         AQPC956VAL34,
         AQPC956VAL35,
         AQPC956VAL36,
         AQPC956AUX1)
      VALUES
        (TRUNC(SYSDATE),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_V_USER,
         P_N_PAIS,
         P_N_TDOC,
         P_V_NDOC,
         P_D_FECH,
         3,
         'SEGMENTACIÓN MICRO',
         MATRIZ0(1) (1),
         MATRIZ0(1) (2),
         MATRIZ0(1) (3),
         MATRIZ0(1) (4),
         MATRIZ0(1) (5),
         MATRIZ0(1) (6),
         MATRIZ0(1) (7),
         MATRIZ0(1) (8),
         MATRIZ0(1) (9),
         MATRIZ0(1) (10),
         MATRIZ0(1) (11),
         MATRIZ0(1) (12),
         MATRIZ0(1) (13),
         MATRIZ0(1) (14),
         MATRIZ0(1) (15),
         MATRIZ0(1) (16),
         MATRIZ0(1) (17),
         MATRIZ0(1) (18),
         MATRIZ0(1) (19),
         MATRIZ0(1) (20),
         MATRIZ0(1) (21),
         MATRIZ0(1) (22),
         MATRIZ0(1) (23),
         MATRIZ0(1) (24),
         MATRIZ0(1) (25),
         MATRIZ0(1) (26),
         MATRIZ0(1) (27),
         MATRIZ0(1) (28),
         MATRIZ0(1) (29),
         MATRIZ0(1) (30),
         MATRIZ0(1) (31),
         MATRIZ0(1) (32),
         MATRIZ0(1) (33),
         MATRIZ0(1) (34),
         MATRIZ0(1) (35),
         MATRIZ0(1) (36),
         0);
      COMMIT;
      P_V_RPTA := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERCION DE VARIABLES LOG    
    FOR H IN GUIA_VARIABLES_2 LOOP
      BEGIN
        INSERT INTO AQPC956
          (AQPC956FERG,
           AQPC956HORG,
           AQPC956USRG,
           AQPC956PAIS,
           AQPC956TDOC,
           AQPC956NDOC,
           AQPC956FECH,
           AQPC956TIPO,
           AQPC956VARC,
           AQPC956VAL1,
           AQPC956VAL2,
           AQPC956VAL3,
           AQPC956VAL4,
           AQPC956VAL5,
           AQPC956VAL6,
           AQPC956VAL7,
           AQPC956VAL8,
           AQPC956VAL9,
           AQPC956VAL10,
           AQPC956VAL11,
           AQPC956VAL12,
           AQPC956VAL13,
           AQPC956VAL14,
           AQPC956VAL15,
           AQPC956VAL16,
           AQPC956VAL17,
           AQPC956VAL18,
           AQPC956VAL19,
           AQPC956VAL20,
           AQPC956VAL21,
           AQPC956VAL22,
           AQPC956VAL23,
           AQPC956VAL24,
           AQPC956VAL25,
           AQPC956VAL26,
           AQPC956VAL27,
           AQPC956VAL28,
           AQPC956VAL29,
           AQPC956VAL30,
           AQPC956VAL31,
           AQPC956VAL32,
           AQPC956VAL33,
           AQPC956VAL34,
           AQPC956VAL35,
           AQPC956VAL36,
           AQPC956AUX1)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USER,
           P_N_PAIS,
           P_N_TDOC,
           P_V_NDOC,
           P_D_FECH,
           3,
           TRIM(H.TP1DESC),
           MATRIZ(1) (H.TP1CORR3),
           MATRIZ(2) (H.TP1CORR3),
           MATRIZ(3) (H.TP1CORR3),
           MATRIZ(4) (H.TP1CORR3),
           MATRIZ(5) (H.TP1CORR3),
           MATRIZ(6) (H.TP1CORR3),
           MATRIZ(7) (H.TP1CORR3),
           MATRIZ(8) (H.TP1CORR3),
           MATRIZ(9) (H.TP1CORR3),
           MATRIZ(10) (H.TP1CORR3),
           MATRIZ(11) (H.TP1CORR3),
           MATRIZ(12) (H.TP1CORR3),
           MATRIZ(13) (H.TP1CORR3),
           MATRIZ(14) (H.TP1CORR3),
           MATRIZ(15) (H.TP1CORR3),
           MATRIZ(16) (H.TP1CORR3),
           MATRIZ(17) (H.TP1CORR3),
           MATRIZ(18) (H.TP1CORR3),
           MATRIZ(19) (H.TP1CORR3),
           MATRIZ(20) (H.TP1CORR3),
           MATRIZ(21) (H.TP1CORR3),
           MATRIZ(22) (H.TP1CORR3),
           MATRIZ(23) (H.TP1CORR3),
           MATRIZ(24) (H.TP1CORR3),
           MATRIZ(25) (H.TP1CORR3),
           MATRIZ(26) (H.TP1CORR3),
           MATRIZ(27) (H.TP1CORR3),
           MATRIZ(28) (H.TP1CORR3),
           MATRIZ(29) (H.TP1CORR3),
           MATRIZ(30) (H.TP1CORR3),
           MATRIZ(31) (H.TP1CORR3),
           MATRIZ(32) (H.TP1CORR3),
           MATRIZ(33) (H.TP1CORR3),
           MATRIZ(34) (H.TP1CORR3),
           MATRIZ(35) (H.TP1CORR3),
           MATRIZ(36) (H.TP1CORR3),
           H.TP1IMP1);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
  END SP_CR_CARGAR_HIST_MICRO;

  PROCEDURE SP_CR_CARGAR_HIST_POTEN(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2) IS
  
    TYPE MATRIZ_TIPO IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE MATRIZ_BIDIMENSIONAL IS TABLE OF MATRIZ_TIPO INDEX BY BINARY_INTEGER;
  
    MATRIZ    MATRIZ_BIDIMENSIONAL;
    MATRIZ0   MATRIZ_BIDIMENSIONAL;
    LN_TMPNUM NUMBER(10);
  
    P_N_VAR   NUMBER(10);
    D_FECCOR  DATE;
    D_FECFIN  DATE;
    L_MESES   NUMBER(10);
    L_TOPE    NUMBER(10);
    L_FLAG    VARCHAR2(2);
    L_VARIAB  VARCHAR2(30);
    LV_NOMBRE VARCHAR2(30);
    LV_VALOR  VARCHAR2(30);
    LV_DESCRI VARCHAR2(30);
  
    CURSOR N_VARIABLES(D_FECHA DATE) IS
      SELECT A.AQPB833VA1, A.AQPB833VA2, A.AQPB833VA3, A.AQPB833VA4
        FROM AQPB833 A
       WHERE A.AQPB833FEC = D_FECHA
         AND A.AQPB833PAI = P_N_PAIS
         AND A.AQPB833TDO = P_N_TDOC
         AND A.AQPB833NDO = RPAD(P_V_NDOC, 12, ' ')
         AND A.AQPB833EST = 'S';
  
    CURSOR GUIA_VARIABLES IS
      SELECT F.TP1CORR3, F.TP1DESC, F.TP1IMP1
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11171
         AND F.TP1CORR1 = 30
         AND F.TP1CORR2 = 7
         AND F.TP1CORR3 > 0;
  
  BEGIN
    --GUÍA DE LIMITE DE MESES
    BEGIN
      SELECT F.TPNRO
        INTO L_MESES
        FROM FST098 F
       WHERE F.TPCOD = 7755
         AND F.TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    D_FECFIN := P_D_FECH;
    P_V_RPTA := 'N';
  
    --BUCLE PARA ALMACENAR LAS VARIABLES EN UN ARRAY
    FOR K IN 1 .. L_MESES LOOP
      L_FLAG := 'N';
      --INSERCION DE MATRIZ DE VARIABLES
      FOR I IN N_VARIABLES(D_FECFIN) LOOP
        MATRIZ(K)(1) := I.AQPB833VA1;
        MATRIZ(K)(2) := I.AQPB833VA2;
        MATRIZ(K)(3) := I.AQPB833VA3;
        MATRIZ(K)(4) := I.AQPB833VA4;
        L_FLAG := 'S';
      END LOOP;
      IF L_FLAG = 'N' THEN
        MATRIZ(K)(1) := '-';
        MATRIZ(K)(2) := '-';
        MATRIZ(K)(3) := '-';
        MATRIZ(K)(4) := '-';
      END IF;
      D_FECFIN := ADD_MONTHS(D_FECFIN, -1);
    END LOOP;
  
    --INSERCION DE VARIABLES LOG    
    FOR H IN GUIA_VARIABLES LOOP
      BEGIN
        INSERT INTO AQPC956
          (AQPC956FERG,
           AQPC956HORG,
           AQPC956USRG,
           AQPC956PAIS,
           AQPC956TDOC,
           AQPC956NDOC,
           AQPC956FECH,
           AQPC956TIPO,
           AQPC956VARC,
           AQPC956VAL1,
           AQPC956VAL2,
           AQPC956VAL3,
           AQPC956VAL4,
           AQPC956VAL5,
           AQPC956VAL6,
           AQPC956VAL7,
           AQPC956VAL8,
           AQPC956VAL9,
           AQPC956VAL10,
           AQPC956VAL11,
           AQPC956VAL12,
           AQPC956VAL13,
           AQPC956VAL14,
           AQPC956VAL15,
           AQPC956VAL16,
           AQPC956VAL17,
           AQPC956VAL18,
           AQPC956VAL19,
           AQPC956VAL20,
           AQPC956VAL21,
           AQPC956VAL22,
           AQPC956VAL23,
           AQPC956VAL24,
           AQPC956VAL25,
           AQPC956VAL26,
           AQPC956VAL27,
           AQPC956VAL28,
           AQPC956VAL29,
           AQPC956VAL30,
           AQPC956VAL31,
           AQPC956VAL32,
           AQPC956VAL33,
           AQPC956VAL34,
           AQPC956VAL35,
           AQPC956VAL36,
           AQPC956AUX1)
        VALUES
          (TRUNC(SYSDATE),
           TO_CHAR(SYSDATE, 'HH24:MI:SS'),
           P_V_USER,
           P_N_PAIS,
           P_N_TDOC,
           P_V_NDOC,
           P_D_FECH,
           4,
           TRIM(H.TP1DESC),
           MATRIZ(1) (H.TP1CORR3),
           MATRIZ(2) (H.TP1CORR3),
           MATRIZ(3) (H.TP1CORR3),
           MATRIZ(4) (H.TP1CORR3),
           MATRIZ(5) (H.TP1CORR3),
           MATRIZ(6) (H.TP1CORR3),
           MATRIZ(7) (H.TP1CORR3),
           MATRIZ(8) (H.TP1CORR3),
           MATRIZ(9) (H.TP1CORR3),
           MATRIZ(10) (H.TP1CORR3),
           MATRIZ(11) (H.TP1CORR3),
           MATRIZ(12) (H.TP1CORR3),
           MATRIZ(13) (H.TP1CORR3),
           MATRIZ(14) (H.TP1CORR3),
           MATRIZ(15) (H.TP1CORR3),
           MATRIZ(16) (H.TP1CORR3),
           MATRIZ(17) (H.TP1CORR3),
           MATRIZ(18) (H.TP1CORR3),
           MATRIZ(19) (H.TP1CORR3),
           MATRIZ(20) (H.TP1CORR3),
           MATRIZ(21) (H.TP1CORR3),
           MATRIZ(22) (H.TP1CORR3),
           MATRIZ(23) (H.TP1CORR3),
           MATRIZ(24) (H.TP1CORR3),
           MATRIZ(25) (H.TP1CORR3),
           MATRIZ(26) (H.TP1CORR3),
           MATRIZ(27) (H.TP1CORR3),
           MATRIZ(28) (H.TP1CORR3),
           MATRIZ(29) (H.TP1CORR3),
           MATRIZ(30) (H.TP1CORR3),
           MATRIZ(31) (H.TP1CORR3),
           MATRIZ(32) (H.TP1CORR3),
           MATRIZ(33) (H.TP1CORR3),
           MATRIZ(34) (H.TP1CORR3),
           MATRIZ(35) (H.TP1CORR3),
           MATRIZ(36) (H.TP1CORR3),
           H.TP1IMP1);
        COMMIT;
        P_V_RPTA := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
  END SP_CR_CARGAR_HIST_POTEN;

  PROCEDURE SP_CR_CARGAR_HIST_SCORE(P_N_PAIS IN NUMBER,
                                    P_N_TDOC IN NUMBER,
                                    P_V_NDOC IN VARCHAR2,
                                    P_V_USER IN VARCHAR2,
                                    P_D_FECH IN DATE,
                                    P_V_RPTA OUT VARCHAR2) IS
  
    TYPE MATRIZ_TIPO IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    TYPE MATRIZ_BIDIMENSIONAL IS TABLE OF MATRIZ_TIPO INDEX BY BINARY_INTEGER;
  
    MATRIZ    MATRIZ_BIDIMENSIONAL;
    MATRIZ0   MATRIZ_BIDIMENSIONAL;
    LN_TMPNUM NUMBER(10);
  
    P_N_VAR   NUMBER(10);
    D_FECCOR  DATE;
    D_FECFIN  DATE;
    L_MESES   NUMBER(10);
    L_TOPE    NUMBER(10);
    L_FLAG    VARCHAR2(2);
    L_VARIAB  VARCHAR2(30);
    LV_NOMBRE VARCHAR2(30);
    LV_VALOR  VARCHAR2(30);
    LV_DESCRI VARCHAR2(30);
  
    V_PROGRAMA        VARCHAR2(50);
    V_PROBAL          NUMBER(9, 7);
    V_NUMERO2         NUMBER(5);
    V_TABLA           VARCHAR2(50);
    V_FECHA_SCORE     DATE;
    V_TIPO_SCORE      VARCHAR2(50);
    V_PUNTAJE         NUMBER(9, 2);
    V_RIESGO_SCORE    VARCHAR2(50);
    V_SEGMENTO_RIESGO VARCHAR2(10);
    V_SCORE_ABRV      VARCHAR2(10);
    V_NEW_SCORE       VARCHAR2(30);
  
  BEGIN
    --GUÍA DE LIMITE DE MESES
    BEGIN
      SELECT F.TPNRO
        INTO L_MESES
        FROM FST098 F
       WHERE F.TPCOD = 7755
         AND F.TPCORR = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    D_FECFIN := P_D_FECH;
    P_V_RPTA := 'N';
  
    --BUCLE PARA ALMACENAR LAS VARIABLES EN UN ARRAY
    FOR K IN 1 .. L_MESES LOOP
      L_FLAG := 'N';
      --INSERCION DE MATRIZ DE VARIABLES
      BEGIN
        V_PROGRAMA := 'REP_HIST_VAR';
        PQ_CR_SCORE_RCC.SP_CR_SCOREDNI_III(ln_inst       => 0,
                                           ln_tdoc       => P_N_TDOC,
                                           lc_ndoc       => P_V_NDOC,
                                           lc_prgm       => V_PROGRAMA,
                                           lc_user       => P_V_USER,
                                           ld_fecha      => D_FECFIN,
                                           lc_score      => V_RIESGO_SCORE,
                                           ln_probal     => V_PROBAL,
                                           lc_SegmRiesgo => V_SEGMENTO_RIESGO,
                                           ln_PDCal      => V_NUMERO2,
                                           lc_tabla      => V_TABLA,
                                           ld_fchscore   => V_FECHA_SCORE,
                                           lc_scoreabr   => V_SCORE_ABRV,
                                           lc_NewScore   => V_NEW_SCORE);
        IF V_SCORE_ABRV IS NOT NULL THEN
          MATRIZ(1)(K) := V_SCORE_ABRV;
          L_FLAG := 'S';
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          L_FLAG := 'N';
      END;
      IF L_FLAG = 'N' THEN
        MATRIZ(1)(K) := '-';
      END IF;
      D_FECFIN := ADD_MONTHS(D_FECFIN, -1);
    END LOOP;
  
    --INSERCION DE VARIABLES LOG    
    BEGIN
      INSERT INTO AQPC956
        (AQPC956FERG,
         AQPC956HORG,
         AQPC956USRG,
         AQPC956PAIS,
         AQPC956TDOC,
         AQPC956NDOC,
         AQPC956FECH,
         AQPC956TIPO,
         AQPC956VARC,
         AQPC956VAL1,
         AQPC956VAL2,
         AQPC956VAL3,
         AQPC956VAL4,
         AQPC956VAL5,
         AQPC956VAL6,
         AQPC956VAL7,
         AQPC956VAL8,
         AQPC956VAL9,
         AQPC956VAL10,
         AQPC956VAL11,
         AQPC956VAL12,
         AQPC956VAL13,
         AQPC956VAL14,
         AQPC956VAL15,
         AQPC956VAL16,
         AQPC956VAL17,
         AQPC956VAL18,
         AQPC956VAL19,
         AQPC956VAL20,
         AQPC956VAL21,
         AQPC956VAL22,
         AQPC956VAL23,
         AQPC956VAL24,
         AQPC956VAL25,
         AQPC956VAL26,
         AQPC956VAL27,
         AQPC956VAL28,
         AQPC956VAL29,
         AQPC956VAL30,
         AQPC956VAL31,
         AQPC956VAL32,
         AQPC956VAL33,
         AQPC956VAL34,
         AQPC956VAL35,
         AQPC956VAL36,
         AQPC956AUX1)
      VALUES
        (TRUNC(SYSDATE),
         TO_CHAR(SYSDATE, 'HH24:MI:SS'),
         P_V_USER,
         P_N_PAIS,
         P_N_TDOC,
         P_V_NDOC,
         P_D_FECH,
         5,
         'SCORE',
         MATRIZ(1) (1),
         MATRIZ(1) (2),
         MATRIZ(1) (3),
         MATRIZ(1) (4),
         MATRIZ(1) (5),
         MATRIZ(1) (6),
         MATRIZ(1) (7),
         MATRIZ(1) (8),
         MATRIZ(1) (9),
         MATRIZ(1) (10),
         MATRIZ(1) (11),
         MATRIZ(1) (12),
         MATRIZ(1) (13),
         MATRIZ(1) (14),
         MATRIZ(1) (15),
         MATRIZ(1) (16),
         MATRIZ(1) (17),
         MATRIZ(1) (18),
         MATRIZ(1) (19),
         MATRIZ(1) (20),
         MATRIZ(1) (21),
         MATRIZ(1) (22),
         MATRIZ(1) (23),
         MATRIZ(1) (24),
         MATRIZ(1) (25),
         MATRIZ(1) (26),
         MATRIZ(1) (27),
         MATRIZ(1) (28),
         MATRIZ(1) (29),
         MATRIZ(1) (30),
         MATRIZ(1) (31),
         MATRIZ(1) (32),
         MATRIZ(1) (33),
         MATRIZ(1) (34),
         MATRIZ(1) (35),
         MATRIZ(1) (36),
         1);
      COMMIT;
      P_V_RPTA := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_CARGAR_HIST_SCORE;

end PQ_CR_REP_VARIABLES_HISTORICO_CRU;
/

