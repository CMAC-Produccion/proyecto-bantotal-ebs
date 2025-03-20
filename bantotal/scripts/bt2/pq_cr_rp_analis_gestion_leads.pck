CREATE OR REPLACE PACKAGE PQ_CR_RP_ANALIS_GESTION_LEADS IS

  /* ************************************************************************************************************
     -- NOMBRE                     : PQ_CR_LIMIT_DESEMB_DIGITAL
     -- SISTEMA                    : BANTOTAL
     -- MÓDULO                     : ACTIVAS
     -- DESCRIPCIÓN                : RP - ANALISTAS GESTIONAR LEADS Y NO CONTAR CON ATRASADOS
     -- VERSIÓN                    : 1.0
     -- FECHA DE CREACIÓN          : 27/02/2024 10:57:37
     -- AUTOR DE CREACIÓN          : IGS_RCASTRO
     -- ESTADO                     : ACTIVO
     -- ACCESO                     : PÚBLICO
     -- FECHA DE MODIFICACIÓN      : 
     -- AUTOR DE LA MODIFICACIÓN   : 
     -- DESCRIPCIÓN DE MODIFICACIÓN:    
  * *************************************************************************************************************/    

PROCEDURE SP_VALD_GESTION_LEADS(INSTANCIA NUMBER, USUARIEJEC VARCHAR2, FLGRESULT OUT VARCHAR2);
  PROCEDURE SP_GRABAR_LOG_AQPC836(INSTANCIA NUMBER,
                                  USUAEJEC  VARCHAR2,
                                  FLGRESULT VARCHAR2,
                                  NROLEADS  NUMBER,
                                  ASESOR    VARCHAR2);

END PQ_CR_RP_ANALIS_GESTION_LEADS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_RP_ANALIS_GESTION_LEADS IS

  PROCEDURE SP_VALD_GESTION_LEADS(INSTANCIA  NUMBER,
                                  USUARIEJEC VARCHAR2,
                                  FLGRESULT  OUT VARCHAR2) IS
    V_ASESOR VARCHAR2(10);
    V_COUNT  NUMBER(10);
  BEGIN
    BEGIN
      SELECT SNG001ASE
        INTO V_ASESOR
        FROM SNG001
       WHERE SNG001INST = INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    V_ASESOR := RPAD(V_ASESOR, 10, ' ');
  
    BEGIN
      SELECT COUNT(*)
        INTO V_COUNT
        FROM VIEW_RETRASO_LEADS
       WHERE RPAD(DERIVACIONCODPERSONA, 10, ' ') = V_ASESOR
         AND DIASATRASADOS > 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    V_COUNT := NVL(V_COUNT, 0);
  
    IF V_COUNT > 0 THEN
      FLGRESULT := 'S'; --BLOQUEAR
    ELSE
      FLGRESULT := 'N';
    END IF;
  
    --LOG
    BEGIN
      PQ_CR_RP_ANALIS_GESTION_LEADS.SP_GRABAR_LOG_AQPC836(INSTANCIA,
                                                          USUARIEJEC,
                                                          FLGRESULT,
                                                          V_COUNT,
                                                          V_ASESOR);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_VALD_GESTION_LEADS;

  PROCEDURE SP_GRABAR_LOG_AQPC836(INSTANCIA NUMBER,
                                  USUAEJEC  VARCHAR2,
                                  FLGRESULT VARCHAR2,
                                  NROLEADS  NUMBER,
                                  ASESOR    VARCHAR2) IS
    V_FECHAHOY DATE;
  BEGIN
    BEGIN
      SELECT W.PGFAPE INTO V_FECHAHOY FROM FST017 W WHERE W.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC836
        (AQPC836FEPRO,
         AQPC836INST,
         AQPC836ASESOR,
         AQPC836FLGBLQ,
         AQPC836CANTLE,
         AQPC836USUREJ,
         AQPC836FECR,
         AQPC836HORA)
      VALUES
        (V_FECHAHOY,
         INSTANCIA,
         ASESOR,
         FLGRESULT,
         NROLEADS,
         USUAEJEC,
         V_FECHAHOY,
         to_char(sysdate, 'HH24:MI:SS'));
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

END PQ_CR_RP_ANALIS_GESTION_LEADS;
/

