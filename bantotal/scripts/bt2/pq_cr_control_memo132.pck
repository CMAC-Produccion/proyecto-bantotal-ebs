CREATE OR REPLACE PACKAGE PQ_CR_CONTROL_MEMO132 IS

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA CONTROLES PARA MEMO 132
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :  27/03/2024 12:34:00
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : Realiza cálculos  
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Modificacion                : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación:
  -- *****************************************************************

  PROCEDURE SP_CR_CONTROL_MEMO132(INSTANCIA     NUMBER,
                                  USUARIO       VARCHAR2,
                                  TBLAMSIVINDIV VARCHAR2,
                                  FLGRPTA       OUT VARCHAR2,
                                  CODERROR      OUT VARCHAR2,
                                  MENSAJEERROR  OUT VARCHAR2);

  PROCEDURE SP_CR_VERIF_EVALUACI(INSTANCIA    NUMBER,
                                 FECHAACTU    DATE,
                                 FLGRPTA      OUT VARCHAR2,
                                 CODERROR     OUT VARCHAR2,
                                 MENSAJEERROR OUT VARCHAR2);

  PROCEDURE SP_CR_VALID_RATIO(INSTANCIA    NUMBER,
                              USUARIO      VARCHAR2,             
                              VAL_RATIO    OUT NUMBER,
                              FLGRPTA      OUT VARCHAR2,
                              CODERROR     OUT VARCHAR2,
                              MENSAJEERROR OUT VARCHAR2);

  PROCEDURE SP_GRABR_LOG_AQPC838(P_AQPC838fepro  DATE,
                                 P_AQPC838INST   NUMBER,
                                 P_AQPC838usuar  VARCHAR2,
                                 P_AQPC838Tabla  VARCHAR2,
                                 P_AQPC838APLIC  VARCHAR2,
                                 P_AQPC838RATIO  NUMBER,
                                 P_AQPC838CODERR VARCHAR2,
                                 P_AQPC838MSGERR VARCHAR2,
                                 P_AQPC838hora   VARCHAR2);

  PROCEDURE SP_EXCEPCION_CONTROL(INSTANCIA    NUMBER,
                                 FLGEXCEPCION OUT VARCHAR2);

END PQ_CR_CONTROL_MEMO132;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CONTROL_MEMO132 IS

  PROCEDURE SP_CR_CONTROL_MEMO132(INSTANCIA     NUMBER,
                                  USUARIO       VARCHAR2,
                                  TBLAMSIVINDIV VARCHAR2,
                                  FLGRPTA       OUT VARCHAR2,
                                  CODERROR      OUT VARCHAR2,
                                  MENSAJEERROR  OUT VARCHAR2) IS
    FECHAACTU    DATE;
    VAL_RATIO    NUMBER(10, 6);
    LC_HORA      VARCHAR2(10);
    FLGEXCEPCION VARCHAR2(1);
  BEGIN
    --S CUMPLIÓ TODO
    --N NO CUMPLE BLOQUEAR
    CODERROR     := '';
    MENSAJEERROR := '';
  
    BEGIN
      SELECT PGFAPE INTO FECHAACTU FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      PQ_CR_CONTROL_MEMO132.SP_EXCEPCION_CONTROL(INSTANCIA, FLGEXCEPCION);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF FLGEXCEPCION = 'N' THEN
    
      BEGIN
        PQ_CR_CONTROL_MEMO132.SP_CR_VERIF_EVALUACI(INSTANCIA,
                                                   FECHAACTU,
                                                   FLGRPTA,
                                                   CODERROR,
                                                   MENSAJEERROR);
      
        IF FLGRPTA = 'S' THEN
          FLGRPTA := 'N';
          BEGIN
            PQ_CR_CONTROL_MEMO132.SP_CR_VALID_RATIO(INSTANCIA,
                                                    USUARIO,
                                                    VAL_RATIO,
                                                    FLGRPTA,
                                                    CODERROR,
                                                    MENSAJEERROR);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --GRABAR LOG
      BEGIN
        PQ_CR_CONTROL_MEMO132.SP_GRABR_LOG_AQPC838(FECHAACTU,
                                                   INSTANCIA,
                                                   USUARIO,
                                                   TBLAMSIVINDIV,
                                                   FLGRPTA,
                                                   VAL_RATIO,
                                                   CODERROR,
                                                   MENSAJEERROR,
                                                   LC_HORA);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END IF;
  
  END;

  PROCEDURE SP_CR_VERIF_EVALUACI(INSTANCIA    NUMBER,
                                 FECHAACTU    DATE,
                                 FLGRPTA      OUT VARCHAR2,
                                 CODERROR     OUT VARCHAR2,
                                 MENSAJEERROR OUT VARCHAR2) IS
    FLGEXIST VARCHAR2(1);
  BEGIN
    FLGRPTA      := 'S';
    CODERROR     := '';
    MENSAJEERROR := '';
  
    BEGIN
      SELECT 'S'
        INTO FLGEXIST
        FROM JAQZ515
       WHERE JAQZ515INS = INSTANCIA
         AND JAQZ515FEE = FECHAACTU
         AND ROWNUM < 2;
    EXCEPTION
      WHEN OTHERS THEN
        FLGEXIST := 'N';
    END;
  
    FLGEXIST := NVL(FLGEXIST, 'N');
  
    IF FLGEXIST = 'N' THEN
      FLGRPTA      := 'N';
      CODERROR     := '1001';
      MENSAJEERROR := 'No se ha ingresado la evaluación.';
    END IF;
  
  END;

  PROCEDURE SP_CR_VALID_RATIO(INSTANCIA    NUMBER,
                              USUARIO      VARCHAR2,
                              VAL_RATIO    OUT NUMBER,
                              FLGRPTA      OUT VARCHAR2,
                              CODERROR     OUT VARCHAR2,
                              MENSAJEERROR OUT VARCHAR2) IS
    VAL_RATIOGUIA NUMBER(10, 6);
    LN_PEPAIS     NUMBER(4);
    LN_PETDOC     NUMBER(4);
    LN_PENDOC     VARCHAR2(12);
    TIPOCAMBIO    NUMBER(14, 8) := 0;
    FECHACT       DATE;
    LN_CAPTOTCAJA NUMBER(17, 2);
    SALDO_EXTERNO NUMBER(17, 2);
    RESULTNETO    NUMBER(17, 2);
    LN_CAPTOTAL   NUMBER(10, 6);
  BEGIN
    FLGRPTA      := 'S';
    CODERROR     := '';
    MENSAJEERROR := '';
  
    --LLMAR PROCEDI DE RATIO
    BEGIN
      SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC
        INTO LN_PEPAIS, LN_PETDOC, LN_PENDOC
        FROM SNG001
       WHERE SNG001INST = INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    LN_PENDOC := TRIM(LN_PENDOC);
  
    BEGIN
      SELECT PGFAPE INTO FECHACT FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      -- CALL THE PROCEDURE
      PQ_CR_RATIOPYME_NEVAL.SP_INICIORATIO(LN_PEPAIS     => LN_PEPAIS,
                                           LN_PETDOC     => LN_PETDOC,
                                           LN_PENDOC     => LN_PENDOC,
                                           TIPOCAMBIO    => TIPOCAMBIO,
                                           INSTANCIA     => INSTANCIA,
                                           PD_FECPRO     => FECHACT,
                                           LC_USUARIO    => USUARIO,
                                           LN_CAPTOTCAJA => LN_CAPTOTCAJA,
                                           SALDO_EXTERNO => SALDO_EXTERNO,
                                           RESULTNETO    => RESULTNETO,
                                           LN_CAPTOTAL   => LN_CAPTOTAL);
    END;
  
    VAL_RATIO := LN_CAPTOTAL;
  
    BEGIN
      SELECT TP1IMP1
        INTO VAL_RATIOGUIA
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 150
         AND TP1CORR2 = 1
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    VAL_RATIOGUIA := NVL(VAL_RATIOGUIA, 0);
  
    IF VAL_RATIO > VAL_RATIOGUIA THEN
      -- SI ES MENOR
      FLGRPTA      := 'N';
      CODERROR     := '1002';
      MENSAJEERROR := 'El ratio es ' || trim(TO_CHAR(VAL_RATIO, 'fm9999999990.999999')) ||
                      ' supera el limite parametrizado de ' || trim(to_char(VAL_RATIOGUIA, 'fm99999999999999990.99'));
    END IF;
  END;

  PROCEDURE SP_GRABR_LOG_AQPC838(P_AQPC838FEPRO  DATE,
                                 P_AQPC838INST   NUMBER,
                                 P_AQPC838USUAR  VARCHAR2,
                                 P_AQPC838TABLA  VARCHAR2,
                                 P_AQPC838APLIC  VARCHAR2,
                                 P_AQPC838RATIO  NUMBER,
                                 P_AQPC838CODERR VARCHAR2,
                                 P_AQPC838MSGERR VARCHAR2,
                                 P_AQPC838HORA   VARCHAR2) IS
  BEGIN
    BEGIN
      INSERT INTO AQPC838
        (AQPC838FEPRO,
         AQPC838INST,
         AQPC838USUAR,
         AQPC838TABLA,
         AQPC838APLIC,
         AQPC838RATIO,
         AQPC838CODERR,
         AQPC838MSGERR,
         AQPC838HORA)
      VALUES
        (P_AQPC838FEPRO,
         P_AQPC838INST,
         P_AQPC838USUAR,
         P_AQPC838TABLA,
         P_AQPC838APLIC,
         P_AQPC838RATIO,
         P_AQPC838CODERR,
         P_AQPC838MSGERR,
         P_AQPC838HORA);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_EXCEPCION_CONTROL(INSTANCIA    NUMBER,
                                 FLGEXCEPCION OUT VARCHAR2) IS
  BEGIN
    BEGIN
      SELECT 'S'
        INTO FLGEXCEPCION
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 150
         AND TP1CORR2 = 2
         AND TP1CORR3 > 0
         AND TP1IMP1 = INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    FLGEXCEPCION := NVL(FLGEXCEPCION, 'N');
  
  END;

END PQ_CR_CONTROL_MEMO132;
/

