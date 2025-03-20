CREATE OR REPLACE PACKAGE PQ_AH_OPE_HORARIOS_INUSUALES IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_OPE_HORARIOS_INUSUALES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.3
  -- Fecha de Creación          : 2024.09.18
  -- Autor de Creación          : CVILLON
  -- Uso                        : Reporte de Operaciones - Horarios Inusuales
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.09.18
  -- Modificación               : Solo Perfiles de Operaciones
  -- ***************************************************************************************

  PROCEDURE SP_AH_OPE_HORARIOS_INUSUALES_AGE(P_USER   IN VARCHAR,
                                             P_PGCOD  IN NUMBER,
                                             P_HSUCOR IN NUMBER,
                                             P_FECINI IN DATE,
                                             P_FECFIN IN DATE,
                                             P_ETAPA  IN VARCHAR,
                                             P_ERRCOD OUT VARCHAR,
                                             P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_OPE_HORARIOS_INUSUALES(P_USER   IN VARCHAR,
                                         P_PGCOD  IN NUMBER,
                                         P_HSUCOR IN NUMBER,
                                         P_FECINI IN DATE,
                                         P_FECFIN IN DATE,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR);

---***
END PQ_AH_OPE_HORARIOS_INUSUALES;
---***
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_OPE_HORARIOS_INUSUALES IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_OPE_HORARIOS_INUSUALES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.3
  -- Fecha de Creación          : 2024.09.18
  -- Autor de Creación          : CVILLON
  -- Uso                        : Reporte de Operaciones - Horarios Inusuales
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.09.18
  -- Modificación               : Solo Perfiles de Operaciones
  -- ***************************************************************************************

  PROCEDURE SP_AH_OPE_HORARIOS_INUSUALES_AGE(P_USER   IN VARCHAR,
                                             P_PGCOD  IN NUMBER,
                                             P_HSUCOR IN NUMBER,
                                             P_FECINI IN DATE,
                                             P_FECFIN IN DATE,
                                             P_ETAPA  IN VARCHAR,
                                             P_ERRCOD OUT VARCHAR,
                                             P_ERRMSG OUT VARCHAR) IS
  
    ---*********
    lv_OPERACION  VARCHAR(30);
    ln_TRX_GUIA   NUMBER(3);
    lc_TRX_HORA_1 CHAR(8); -- Inicio Hora Mañana
    lc_TRX_HORA_2 CHAR(8); -- Fin Hora Mañana
    lc_TRX_HORA_3 CHAR(8); -- Inicio Hora Noche
    lc_TRX_HORA_4 CHAR(8); -- Fin Hora Noche
  
    ln_QtyMax      NUMBER(3);
    ln_QtyPri      NUMBER(3);
    ln_QtyUlt      NUMBER(3);
    ln_PERFIL_GUIA NUMBER(3);
    ---*********
  
  BEGIN
    ---*********
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---*********
    ln_QtyPri := 1;
    ln_QtyUlt := 1;
    ---*********
  
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lc_TRX_HORA_1
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 76
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        lc_TRX_HORA_1 := '00:00:00';
    END;
  
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lc_TRX_HORA_2
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 76
         AND TP1CORR3 = 2;
    EXCEPTION
      WHEN OTHERS THEN
        lc_TRX_HORA_2 := '08:20:00';
    END;
  
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lc_TRX_HORA_3
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 76
         AND TP1CORR3 = 3;
    EXCEPTION
      WHEN OTHERS THEN
        lc_TRX_HORA_3 := '20:00:00';
    END;
  
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lc_TRX_HORA_4
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 76
         AND TP1CORR3 = 4;
    EXCEPTION
      WHEN OTHERS THEN
        lc_TRX_HORA_4 := '23:59:59';
    END;
  
    BEGIN
      SELECT TP1NRO1
        INTO ln_QtyMax
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 76
         AND TP1CORR3 = 5;
    EXCEPTION
      WHEN OTHERS THEN
        ln_QtyMax := 10;
    END;
  
    ---*********
    IF (P_ETAPA = 'P') THEN
      -- (ln_QtyMax) Primeros
      FOR XROW IN (SELECT f15.*
                     FROM FSH015 f15
                    WHERE f15.PGCOD = P_PGCOD
                      AND f15.HSUCOR = P_HSUCOR
                         ---*** OPERACIONES EN AGENCIA
                      AND f15.HSUCOR BETWEEN 0 AND 300
                         ---***
                      AND f15.HFCON BETWEEN P_FECINI AND P_FECFIN
                      AND f15.HHORA BETWEEN lc_TRX_HORA_1 AND lc_TRX_HORA_2
                    ORDER BY f15.HFCON, f15.HHORA)
      
       LOOP
        --- GUIA de TRX a Ignorar
        SELECT COUNT(*)
          INTO ln_TRX_GUIA
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 75
           AND TP1CORR3 > 0
           AND TP1NRO1 = XROW.HCMOD
           AND TP1NRO2 = XROW.HTRAN;
      
        IF (ln_TRX_GUIA = 0 AND ln_QtyPri <= ln_QtyMax) THEN
          ---***
          ---********* SOLO PERFILES DE OPERACIONES
          SELECT COUNT(*)
            INTO ln_PERFIL_GUIA
            FROM PRFU00
           WHERE UBUSER = XROW.HUSING
             AND PRFGCOD IN (SELECT TP1DESC
                               FROM FST198
                              WHERE TP1COD = 1
                                AND TP1COD1 = 11146
                                AND TP1CORR1 = 1
                                AND TP1CORR2 = 79
                                AND TP1CORR3 > 0);
          ---*** 
          IF (ln_PERFIL_GUIA = 0) THEN
            CONTINUE;
          END IF;
          ---***
          ---*********
        
          SELECT TRIM(TRNOM)
            INTO lv_OPERACION
            FROM FST034
           WHERE PGCOD = XROW.PGCOD
             AND TRMOD = XROW.HCMOD
             AND TRNRO = XROW.HTRAN;
        
          INSERT INTO AQPD317
            (AQPD317CREUSR,
             AQPD317ETAPA,
             AQPD317CRETIM,
             AQPD317PGCOD,
             AQPD317HSUCOR,
             AQPD317HCMOD,
             AQPD317HTRAN,
             AQPD317HNREL,
             AQPD317HFCON,
             AQPD317HFVC,
             AQPD317HCCORR,
             AQPD317HUSING,
             AQPD317HWSING,
             AQPD317HUSCNF,
             AQPD317HWSCNF,
             AQPD317HHORA,
             AQPD317HCCAJA)
          VALUES
            (P_USER,
             P_ETAPA,
             SYSDATE,
             XROW.PGCOD,
             XROW.HSUCOR,
             XROW.HCMOD,
             XROW.HTRAN,
             XROW.HNREL,
             XROW.HFCON,
             XROW.HFVC,
             XROW.HCCORR,
             XROW.HUSING,
             XROW.HWSING,
             XROW.HUSCNF,
             XROW.HWSCNF,
             XROW.HHORA,
             XROW.HCCAJA);
          ---***
          COMMIT;
          ---***
          ln_QtyPri := ln_QtyPri + 1;
          ---***
          --DBMS_OUTPUT.PUT_LINE('Primeros = ' || ln_QtyPri);
          --DBMS_OUTPUT.PUT_LINE('XROW.HHORA = ' || XROW.HHORA);
          --DBMS_OUTPUT.PUT_LINE('lv_OPERACION = ' || lv_OPERACION);
        END IF;
        ---*** 
      END LOOP;
    END IF;
    ---*********
    ---*********
    IF (P_ETAPA = 'U') THEN
      -- (ln_QtyMax) Ultimos
      FOR XROW IN (SELECT f15.*
                     FROM FSH015 f15
                    WHERE f15.PGCOD = P_PGCOD
                      AND f15.HSUCOR = P_HSUCOR
                         ---*** OPERACIONES EN AGENCIA
                      AND f15.HSUCOR BETWEEN 0 AND 300
                         ---***
                      AND f15.HFCON BETWEEN P_FECINI AND P_FECFIN
                      AND f15.HHORA BETWEEN lc_TRX_HORA_3 AND lc_TRX_HORA_4
                    ORDER BY f15.HFCON, f15.HHORA DESC)
      
       LOOP
        --- GUIA de TRX a Ignorar
        SELECT COUNT(*)
          INTO ln_TRX_GUIA
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 75
           AND TP1CORR3 > 0
           AND TP1NRO1 = XROW.HCMOD
           AND TP1NRO2 = XROW.HTRAN;
      
        IF (ln_TRX_GUIA = 0 AND ln_QtyUlt <= ln_QtyMax) THEN
        
          ---***
          ---********* SOLO PERFILES DE OPERACIONES
          SELECT COUNT(*)
            INTO ln_PERFIL_GUIA
            FROM PRFU00
           WHERE UBUSER = XROW.HUSING
             AND PRFGCOD IN (SELECT TP1DESC
                               FROM FST198
                              WHERE TP1COD = 1
                                AND TP1COD1 = 11146
                                AND TP1CORR1 = 1
                                AND TP1CORR2 = 79
                                AND TP1CORR3 > 0);
          ---*** 
          IF (ln_PERFIL_GUIA = 0) THEN
            CONTINUE;
          END IF;
          ---***
          ---*********
        
          SELECT TRIM(TRNOM)
            INTO lv_OPERACION
            FROM FST034
           WHERE PGCOD = XROW.PGCOD
             AND TRMOD = XROW.HCMOD
             AND TRNRO = XROW.HTRAN;
        
          INSERT INTO AQPD317
            (AQPD317CREUSR,
             AQPD317ETAPA,
             AQPD317CRETIM,
             AQPD317PGCOD,
             AQPD317HSUCOR,
             AQPD317HCMOD,
             AQPD317HTRAN,
             AQPD317HNREL,
             AQPD317HFCON,
             AQPD317HFVC,
             AQPD317HCCORR,
             AQPD317HUSING,
             AQPD317HWSING,
             AQPD317HUSCNF,
             AQPD317HWSCNF,
             AQPD317HHORA,
             AQPD317HCCAJA)
          VALUES
            (P_USER,
             P_ETAPA,
             SYSDATE,
             XROW.PGCOD,
             XROW.HSUCOR,
             XROW.HCMOD,
             XROW.HTRAN,
             XROW.HNREL,
             XROW.HFCON,
             XROW.HFVC,
             XROW.HCCORR,
             XROW.HUSING,
             XROW.HWSING,
             XROW.HUSCNF,
             XROW.HWSCNF,
             XROW.HHORA,
             XROW.HCCAJA);
          ---***
          COMMIT;
          ---***
          ln_QtyUlt := ln_QtyUlt + 1;
          ---***
          --DBMS_OUTPUT.PUT_LINE('Ultimos = ' || ln_QtyUlt);
          --DBMS_OUTPUT.PUT_LINE('XROW.HHORA = ' || XROW.HHORA);
          --DBMS_OUTPUT.PUT_LINE('lv_OPERACION = ' || lv_OPERACION);
        END IF;
        ---*** 
      END LOOP;
    END IF;
    ---*********
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
    
  END SP_AH_OPE_HORARIOS_INUSUALES_AGE;

  PROCEDURE SP_AH_OPE_HORARIOS_INUSUALES(P_USER   IN VARCHAR,
                                         P_PGCOD  IN NUMBER,
                                         P_HSUCOR IN NUMBER,
                                         P_FECINI IN DATE,
                                         P_FECFIN IN DATE,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR) IS
  
    ---*********
    ln_HSUCOR_INI NUMBER(3);
    ln_HSUCOR_FIN NUMBER(3);
    ln_Orden      NUMBER(9);
    lv_AGEDES     VARCHAR(30);
    lv_DEPT       VARCHAR(15);
    ln_DEPT       NUMBER(3);
    lv_DEPNOM     VARCHAR(20);
    lv_OPETIP     VARCHAR(30);
    ln_ORDINAL    NUMBER(2);
    ln_CTACLI     NUMBER(9);
    ln_OPEMON     NUMBER(17, 2);
    lv_BOVCIE     VARCHAR(8);
    ---*********
  
  BEGIN
    ---*********
    DELETE FROM AQPD317 WHERE AQPD317CREUSR = P_USER;
    COMMIT;
    ---***
    DELETE FROM AQPD317A WHERE AQPD317ACREUSR = P_USER;
    COMMIT;
    ---*********
    ln_Orden := 1;
    ---*********
    ---*** Solo Sucursales de Contabilizacion en Agencia
    IF (P_HSUCOR = 0) THEN
      ln_HSUCOR_INI := 0;
      ln_HSUCOR_FIN := 300;
    ELSE
      ln_HSUCOR_INI := P_HSUCOR;
      ln_HSUCOR_FIN := P_HSUCOR;
    END IF;
    ---***
  
    FOR AROW IN (SELECT *
                   FROM FST001
                  WHERE PGCOD = P_PGCOD
                    AND SUCURS BETWEEN ln_HSUCOR_INI AND ln_HSUCOR_FIN
                  ORDER BY SUCURS) LOOP
      ---*********
      SP_AH_OPE_HORARIOS_INUSUALES_AGE(P_USER,
                                       P_PGCOD,
                                       AROW.SUCURS,
                                       P_FECINI,
                                       P_FECFIN,
                                       'P',
                                       P_ERRCOD,
                                       P_ERRMSG);
      ---*********
      SP_AH_OPE_HORARIOS_INUSUALES_AGE(P_USER,
                                       P_PGCOD,
                                       AROW.SUCURS,
                                       P_FECINI,
                                       P_FECFIN,
                                       'U',
                                       P_ERRCOD,
                                       P_ERRMSG);
      ---*********
    END LOOP;
    ---*********
    ---***
    --SELECT COUNT(*) INTO ln_NROREG
    --FROM AQPD317 WHERE AQPD317CREUSR = 'CVILLON';
  
    FOR TROW IN (SELECT *
                   FROM AQPD317
                  WHERE AQPD317CREUSR = P_USER
                  ORDER BY AQPD317HHORA) LOOP
    
      BEGIN
        SELECT TRIM(SCNOM), TRIM(SCDEPT)
          INTO lv_AGEDES, lv_DEPT
          FROM FST001
         WHERE PGCOD = P_PGCOD
           AND SUCURS = TROW.AQPD317HSUCOR;
      EXCEPTION
        WHEN OTHERS THEN
          lv_AGEDES := '-';
          lv_DEPT   := '0';
      END;
      ---***
      --DBMS_OUTPUT.PUT_LINE('lv_AGEDES = ' || lv_AGEDES);
      ---***
      BEGIN
        ln_DEPT := TO_NUMBER(lv_DEPT, '999');
        SELECT TRIM(DEPNOM)
          INTO lv_DEPNOM
          FROM FST068
         WHERE PAIS = 604
           AND DEPCOD = ln_DEPT;
      EXCEPTION
        WHEN OTHERS THEN
          lv_DEPNOM := '-';
      END;
      ---***
    
      BEGIN
        SELECT TRIM(TRNOM)
          INTO lv_OPETIP
          FROM FST034
         WHERE PGCOD = P_PGCOD
           AND TRMOD = TROW.AQPD317HCMOD
           AND TRNRO = TROW.AQPD317HTRAN;
      EXCEPTION
        WHEN OTHERS THEN
          lv_OPETIP := '-';
      END;
      ---***
      --DBMS_OUTPUT.PUT_LINE('lv_OPETIP = ' || lv_OPETIP);
      ---***
      ---***
      /*
      BEGIN
        SELECT TP1NRO3
          INTO ln_ORDINAL
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 75
           AND TP1CORR3 > 0
           AND TP1NRO1 = TROW.AQPD317HCMOD
           AND TP1NRO2 = TROW.AQPD317HTRAN;
      EXCEPTION
        WHEN OTHERS THEN
          ln_ORDINAL := 0;
      END;
      */
      ---***
      --DBMS_OUTPUT.PUT_LINE('ln_ORDINAL = ' || ln_ORDINAL);
      ---***
    
      --IF (ln_ORDINAL = 0) THEN
      --  CONTINUE;
      --END IF;
    
      BEGIN
        SELECT HCTA, HCIMP1
          INTO ln_CTACLI, ln_OPEMON
          FROM (SELECT *
                  FROM FSH016
                 WHERE PGCOD = TROW.AQPD317PGCOD
                   AND HSUCOR = TROW.AQPD317HSUCOR
                   AND HCMOD = TROW.AQPD317HCMOD
                   AND HTRAN = TROW.AQPD317HTRAN
                   AND HNREL = TROW.AQPD317HNREL
                   AND HFCON = TROW.AQPD317HFCON
                   AND HCTA > 0
                 ORDER BY HCORD)
         WHERE ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          CONTINUE;
      END;
      ---***
      ---********* HORA DE CIERRE DE BOVEDA
      BEGIN
        SELECT TRIM(MBCCHRA)
          INTO lv_BOVCIE
          FROM MBC004
         WHERE MBCCEMP = TROW.AQPD317PGCOD
           AND MBCCSUC = TROW.AQPD317HSUCOR
           AND MBCCCAJ = 0
           AND MBCCFCH = TROW.AQPD317HFCON
           AND MBCCEST = 'C';
      EXCEPTION
        WHEN OTHERS THEN
          lv_BOVCIE := '00:00:00';
      END;
      ---*********
    
      INSERT INTO AQPD317A
        (AQPD317ACREUSR,
         AQPD317ANROREG,
         AQPD317ACRETIM,
         AQPD317AOPEFEC,
         AQPD317AOPEREG,
         AQPD317AAGECOD,
         AQPD317AAGEDES,
         AQPD317AOPEHOR,
         AQPD317AOPETIP,
         AQPD317ACTACLI,
         AQPD317AOPEMON,
         AQPD317ABOVHOR,
         AQPD317AUSUING,
         AQPD317APRINTU)
      VALUES
        (P_USER,
         ln_Orden,
         SYSDATE,
         TROW.AQPD317HFCON,
         lv_DEPNOM,
         TROW.AQPD317HSUCOR,
         lv_AGEDES,
         TROW.AQPD317HHORA,
         lv_OPETIP,
         ln_CTACLI,
         ln_OPEMON,
         lv_BOVCIE,
         TRIM(TROW.AQPD317HUSING),
         TRIM(TROW.AQPD317HUSCNF));
      ---***
      COMMIT;
      ---***
      ln_Orden := ln_Orden + 1;
      ---***
    
    END LOOP;
  
    ---*********
  
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
    
  END SP_AH_OPE_HORARIOS_INUSUALES;

---***
END PQ_AH_OPE_HORARIOS_INUSUALES;
---***
/

