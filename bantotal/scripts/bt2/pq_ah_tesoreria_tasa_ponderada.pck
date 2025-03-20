CREATE OR REPLACE PACKAGE PQ_AH_TESORERIA_TASA_PONDERADA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_TESORERIA_TASA_PONDERADA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.09.04
  -- Autor de Creación          : CVILLON
  -- Uso                        : Reporte de Tesoreria - Tasa Ponderada
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.09.04
  -- Modificación               : Saldo a la Fecha de Corte
  -- ***************************************************************************************

  PROCEDURE SP_AH_CTA_TESORERIA(P_PGCOD  IN NUMBER,
                                P_AOSUC  IN NUMBER,
                                P_AOMOD  IN NUMBER,
                                P_AOPAP  IN NUMBER,
                                P_AOMDA  IN NUMBER,
                                P_AOCTA  IN NUMBER,
                                P_AOOPE  IN NUMBER,
                                P_AOSBO  IN NUMBER,
                                P_AOTOP  IN NUMBER,
                                P_CTATES OUT NUMBER,
                                P_ERRCOD OUT VARCHAR,
                                P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_TESORERIA_TASA_PONDERADA_DPF(P_CREUSU IN VARCHAR,
                                                   P_FECCOR IN DATE,
                                                   P_ERRCOD OUT VARCHAR,
                                                   P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_TESORERIA_TASA_PONDERADA_AHO(P_CREUSU IN VARCHAR,
                                                   P_FECCOR IN DATE,
                                                   P_ERRCOD OUT VARCHAR,
                                                   P_ERRMSG OUT VARCHAR);

---***
END PQ_AH_TESORERIA_TASA_PONDERADA;
---***
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_TESORERIA_TASA_PONDERADA IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_TESORERIA_TASA_PONDERADA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.10.07
  -- Autor de Creación          : CVILLON
  -- Uso                        : Reporte de Tesoreria - Tasa Ponderada
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.10.07
  -- Modificación               : DPF - Pre Cancelación 
  -- ***************************************************************************************
  PROCEDURE SP_AH_CTA_TESORERIA(P_PGCOD  IN NUMBER,
                                P_AOSUC  IN NUMBER,
                                P_AOMOD  IN NUMBER,
                                P_AOPAP  IN NUMBER,
                                P_AOMDA  IN NUMBER,
                                P_AOCTA  IN NUMBER,
                                P_AOOPE  IN NUMBER,
                                P_AOSBO  IN NUMBER,
                                P_AOTOP  IN NUMBER,
                                P_CTATES OUT NUMBER,
                                P_ERRCOD OUT VARCHAR,
                                P_ERRMSG OUT VARCHAR) IS
  
    ln_TOTTES NUMBER(10);
    ln_CTATES NUMBER(1);
  
  BEGIN
  
    ---***
    ln_TOTTES := 0;
    ln_CTATES := 0;
    ---***
  
    IF P_AOMOD = 22 THEN
      SELECT COUNT(*)
        INTO ln_TOTTES
        FROM JAQL478
       WHERE JAQL478PGC = P_PGCOD
         AND JAQL478MOD = P_AOMOD
         AND JAQL478SUC = P_AOSUC
         AND JAQL478MDA = P_AOMDA
         AND JAQL478PAP = P_AOPAP
         AND JAQL478CTA = P_AOCTA
         AND JAQL478OPE = P_AOOPE
         AND JAQL478TOP = P_AOTOP
         AND JAQL478EST = 'A';
    
      IF ln_TOTTES <= 0 AND P_AOSUC = 904 THEN
        ln_TOTTES := 1;
      END IF;
    
    ELSE
      SELECT COUNT(*)
        INTO ln_TOTTES
        FROM JAQL478
       WHERE JAQL478PGC = P_PGCOD
         AND JAQL478MOD = P_AOMOD
         AND JAQL478SUC = P_AOSUC
         AND JAQL478MDA = P_AOMDA
         AND JAQL478PAP = P_AOPAP
         AND JAQL478CTA = P_AOCTA
         AND JAQL478OPE = P_AOOPE
         AND JAQL478SUB = P_AOSBO
         AND JAQL478TOP = P_AOTOP
         AND JAQL478EST = 'A';
    END IF;
  
    ---*********
    IF ln_TOTTES > 0 THEN
      ln_CTATES := 1;
    END IF;
    ---*********
    P_CTATES := ln_CTATES;
    ---*********
  EXCEPTION
    when others then
      P_CTATES := 0;
      P_ERRCOD := 'GE1';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
    
  END SP_AH_CTA_TESORERIA;

  PROCEDURE SP_AH_REP_TESORERIA_TASA_PONDERADA_DPF(P_CREUSU IN VARCHAR,
                                                   P_FECCOR IN DATE,
                                                   P_ERRCOD OUT VARCHAR,
                                                   P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_ROWNRO NUMBER(3);
    ---***
    lv_MOSIGN VARCHAR(4);
    ---***
    ln_PEPAIS NUMBER(3);
    ln_PETDOC NUMBER(2);
    lc_PENDOC CHAR(12);
    lv_PENOM  VARCHAR(90);
    lv_OFINOM VARCHAR(30);
    ---***
    ln_REGNOM NUMBER(9);
    lv_REGNOM VARCHAR(30);
    ---***
    ln_TASA   NUMBER(10, 6);
    ln_IMPINT NUMBER(17, 2);
    ---***
    lc_PETIPO CHAR(1);
    ---***
    lc_CTIFIN CHAR(1);
    ---***
    ld_PGFAPE DATE;
    ---***
    ln_CTATES NUMBER(3);
    lv_ERRCOD VARCHAR(3);
    lv_ERRMSG VARCHAR(600);
    ---***
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    ln_CTATES := 0;
    lv_ERRCOD := '000';
    lv_ERRMSG := '';
  
    ---***
    SELECT PGFAPE INTO ld_PGFAPE FROM FST017 WHERE PGCOD = 1;
    ---***
    DELETE FROM AQPD316 WHERE AQPD316CREUSR = P_CREUSU;
    COMMIT;
    ---***
    ---***
    ln_ROWNRO := 0;
    --***
    FOR XROW IN (SELECT *
                   FROM FSD010
                  WHERE PGCOD = 1
                    AND AOMOD = 22
                       ---*** TEST
                       --AND AOCTA IN (8537, 8535, 518607, 1051892, 748859)
                       ---***
                       ---*** NEW
                    AND (P_FECCOR >= AOFVAL AND P_FECCOR < AOFVTO)
                    AND (AOFE99 = TO_DATE('01/01/0001', 'dd/MM/yyyy') OR
                        (AOFE99 > P_FECCOR))) LOOP
      ---*** OLD
      --AND (P_FECCOR BETWEEN AOFVAL AND AOFVTO)
      --AND (AOFE99 = TO_DATE('01/01/0001', 'dd/MM/yyyy') OR
      --    (AOFE99 >= P_FECCOR))) LOOP
      ---***     
    
      ---*** Es una cuenta de Tesoreria?
      SP_AH_CTA_TESORERIA(XROW.PGCOD,
                          XROW.AOSUC,
                          XROW.AOMOD,
                          XROW.AOPAP,
                          XROW.AOMDA,
                          XROW.AOCTA,
                          XROW.AOOPER,
                          XROW.AOSBOP,
                          XROW.AOTOPE,
                          ln_CTATES,
                          lv_ERRCOD,
                          lv_ERRMSG);
      ---*** Si No es de Tesoreria pasamos a la siguiente
      IF (ln_CTATES = 0) THEN
        CONTINUE;
      END IF;
      ---*** 
      ---***
      ln_ROWNRO := ln_ROWNRO + 1;
      ---***
      ---*** DETRMINAR SI ES IFI
      lc_CTIFIN := 'N';
      ---***
      BEGIN
        SELECT CTIFIN
          INTO lc_CTIFIN
          FROM FSD008
         WHERE PGCOD = 1
           AND CTNRO = XROW.AOCTA;
      EXCEPTION
        WHEN OTHERS THEN
          lc_CTIFIN := 'N';
      END;
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_PEPAIS, ln_PETDOC, lc_PENDOC
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = XROW.AOCTA
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      BEGIN
        SELECT TRIM(PENOM), PETIPO
          INTO lv_PENOM, lc_PETIPO
          FROM FSD001
         WHERE PEPAIS = ln_PEPAIS
           AND PETDOC = ln_PETDOC
           AND PENDOC = lc_PENDOC;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      ---***
      ---*** ???
      --IF (lc_PETIPO <> 'J') THEN
      --  CONTINUE;
      --END IF;
      ---***
      ---***
      BEGIN
        IF (lc_PETIPO = 'J') THEN
          SELECT TRIM(PJRAZS)
            INTO lv_PENOM
            FROM FSD003
           WHERE PJPAIS = ln_PEPAIS
             AND PJTDOC = ln_PETDOC
             AND PJNDOC = lc_PENDOC;
        END IF;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      ---***
      BEGIN
        SELECT TRIM(SCNOM)
          INTO lv_OFINOM
          FROM FST001
         WHERE PGCOD = 1
           AND SUCURS = XROW.AOSUC;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      lv_REGNOM := 'Tesoreria';
      ---***
      BEGIN
        SELECT MOSIGN INTO lv_MOSIGN FROM FST005 WHERE MONEDA = XROW.AOMDA;
      exception
        when others then
          lv_MOSIGN := '-';
      END;
      ---***
      ---********* TASA
      BEGIN
        -- Call the procedure
        PQ_AH_PRODUCTIVIDAD.Tasa(XROW.PGCOD,
                                 XROW.AOSUC,
                                 XROW.AOCTA,
                                 XROW.AOMDA,
                                 XROW.AOPAP,
                                 XROW.AOOPER,
                                 XROW.AOSBOP,
                                 XROW.AOTOPE,
                                 XROW.AOMOD,
                                 ld_PGFAPE,
                                 XROW.AOIMP,
                                 XROW.AOPZO,
                                 ln_TASA);
      END;
      ---*********
      ---***
      INSERT INTO AQPD316
        (AQPD316CREUSR,
         AQPD316NROREG,
         AQPD316CRETIM,
         AQPD316FECAPE,
         AQPD316CLICTA,
         AQPD316CLINOM,
         AQPD316MONCOD,
         AQPD316MONDES,
         AQPD316DMONAP,
         AQPD316DPLAZO,
         AQPD316FECVEN,
         AQPD316DPTASA,
         AQPD316OFICOD,
         AQPD316DRECOD,
         AQPD316DREDES,
         AQPD316CESIFI)
      VALUES
        (P_CREUSU,
         ln_ROWNRO,
         SYSDATE,
         XROW.AOFVAL,
         XROW.AOCTA,
         lv_PENOM,
         XROW.AOMDA,
         lv_MOSIGN,
         XROW.AOIMP,
         XROW.AOPZO,
         XROW.AOFVTO,
         ln_TASA,
         XROW.AOSUC,
         XROW.AOSUC,
         lv_REGNOM,
         lc_CTIFIN);
    
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := 'GE1';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_REP_TESORERIA_TASA_PONDERADA_DPF;

  PROCEDURE SP_AH_REP_TESORERIA_TASA_PONDERADA_AHO(P_CREUSU IN VARCHAR,
                                                   P_FECCOR IN DATE,
                                                   P_ERRCOD OUT VARCHAR,
                                                   P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_ROWNRO NUMBER(3);
    ---***
    lv_MOSIGN VARCHAR(4);
    ---***
    ln_PEPAIS NUMBER(3);
    ln_PETDOC NUMBER(2);
    lc_PENDOC CHAR(12);
    lv_PENOM  VARCHAR(90);
    lv_OFINOM VARCHAR(30);
    ---***
    ln_REGNOM NUMBER(9);
    lv_REGNOM VARCHAR(30);
    ---***
    ln_TASA   NUMBER(10, 6);
    ln_IMPINT NUMBER(17, 2);
    ---***
    lc_PETIPO CHAR(1);
    ---***
    lc_CTIFIN CHAR(1);
    ---***
    ld_PGFAPE DATE;
    ---***
    ln_BCSDMO NUMBER(17, 2);
    ---***
    lv_ERRCOD VARCHAR(3);
    lv_ERRMSG VARCHAR(600);
    ---***
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    lv_ERRCOD := '000';
    lv_ERRMSG := '';
    ---***
    --SELECT PGFAPE INTO ld_PGFAPE FROM FST017 WHERE PGCOD = 1;
    ---***
    DELETE FROM AQPD316A WHERE AQPD316ACREUSR = P_CREUSU;
    COMMIT;
    ---***
    ---***
    ln_ROWNRO := 0;
    --***
    FOR XROW IN (SELECT f.*
                   FROM FSD011 f
                   JOIN JAQL478 j
                     ON (f.PGCOD = j.JAQL478PGC AND f.SCSUC = j.JAQL478SUC AND
                        f.SCMOD = j.JAQL478MOD AND f.SCPAP = j.JAQL478PAP AND
                        f.SCMDA = j.JAQL478MDA AND f.SCCTA = j.JAQL478CTA AND
                        f.SCOPER = j.JAQL478OPE AND f.SCSBOP = j.JAQL478SUB AND
                        f.SCTOPE = j.JAQL478TOP)
                  WHERE f.PGCOD = 1
                    AND f.SCMOD = 21
                    AND f.SCSTAT <> 99) LOOP
      ---***              
      ln_ROWNRO := ln_ROWNRO + 1;
      --***
      ---*** DETRMINAR SI ES IFI
      lc_CTIFIN := 'N';
      ---***
      BEGIN
        SELECT CTIFIN
          INTO lc_CTIFIN
          FROM FSD008
         WHERE PGCOD = 1
           AND CTNRO = XROW.SCCTA;
      EXCEPTION
        WHEN OTHERS THEN
          lc_CTIFIN := 'N';
      END;
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_PEPAIS, ln_PETDOC, lc_PENDOC
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = XROW.SCCTA
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      BEGIN
        SELECT TRIM(PENOM), PETIPO
          INTO lv_PENOM, lc_PETIPO
          FROM FSD001
         WHERE PEPAIS = ln_PEPAIS
           AND PETDOC = ln_PETDOC
           AND PENDOC = lc_PENDOC;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      ---***
      ---*** ???
      --IF (lc_PETIPO <> 'J') THEN
      --  CONTINUE;
      --END IF;
      ---***
      ---***
      BEGIN
        IF (lc_PETIPO = 'J') THEN
          SELECT TRIM(PJRAZS)
            INTO lv_PENOM
            FROM FSD003
           WHERE PJPAIS = ln_PEPAIS
             AND PJTDOC = ln_PETDOC
             AND PJNDOC = lc_PENDOC;
        END IF;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      BEGIN
        SELECT TRIM(SCNOM)
          INTO lv_OFINOM
          FROM FST001
         WHERE PGCOD = 1
           AND SUCURS = XROW.SCSUC;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      lv_REGNOM := 'Tesoreria';
      ---***
      BEGIN
        SELECT MOSIGN INTO lv_MOSIGN FROM FST005 WHERE MONEDA = XROW.SCMDA;
      exception
        when others then
          lv_MOSIGN := '-';
      END;
      ---********* SALDO AL CORTE
      BEGIN
        SELECT BCSDMO
          INTO ln_BCSDMO
          FROM FSH012
         WHERE BCEMP = XROW.PGCOD
           AND BCSUC = XROW.SCSUC
           AND BCRUBR = XROW.SCRUB
           AND BCMDA = XROW.SCMDA
           AND BCPAP = XROW.SCPAP
           AND BCCTA = XROW.SCCTA
           AND BCOPER = XROW.SCOPER
           AND BCSBOP = XROW.SCSBOP
           AND BCTOP = XROW.SCTOPE
           AND BCFECH = P_FECCOR;
      EXCEPTION
        WHEN OTHERS THEN
          ln_BCSDMO := XROW.SCSDO;
      END;
      ---*********
      ---*********
      ---********* TASA
      ln_TASA := 0;
      ---*********
      BEGIN
        -- Call the procedure
        PQ_AH_PRODUCTIVIDAD.Tasa(XROW.PGCOD,
                                 XROW.SCSUC,
                                 XROW.SCCTA,
                                 XROW.SCMDA,
                                 XROW.SCPAP,
                                 XROW.SCOPER,
                                 XROW.SCSBOP,
                                 XROW.SCTOPE,
                                 XROW.SCMOD,
                                 P_FECCOR,
                                 ln_BCSDMO,
                                 0,
                                 ln_TASA);
      END;
      ---*********
      --DBMS_OUTPUT.PUT_LINE('XROW.PGCOD = ' || XROW.PGCOD);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCSUC = ' || XROW.SCSUC);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCCTA = ' || XROW.SCCTA);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCMDA = ' || XROW.SCMDA);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCPAP = ' || XROW.SCPAP);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCOPER = ' || XROW.SCOPER);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCSBOP = ' || XROW.SCSBOP);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCTOPE = ' || XROW.SCTOPE);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCMOD = ' || XROW.SCMOD);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCFVAL = ' || XROW.SCFVAL);
      --DBMS_OUTPUT.PUT_LINE('XROW.SCSDO = ' || XROW.SCSDO);
      --DBMS_OUTPUT.PUT_LINE('ln_TASA = ' || ln_TASA);
      ---*********
    
      INSERT INTO AQPD316A
        (AQPD316ACREUSR,
         AQPD316ANROREG,
         AQPD316ACRETIM,
         AQPD316AFECAPE,
         AQPD316ACLICTA,
         AQPD316ACLINOM,
         AQPD316AMONCOD,
         AQPD316AMONDES,
         AQPD316AASALDO,
         AQPD316AAPTASA,
         AQPD316AOFICOD,
         AQPD316AARECOD,
         AQPD316AAREDES,
         AQPD316ACESIFI)
      VALUES
        (P_CREUSU,
         ln_ROWNRO,
         SYSDATE,
         XROW.SCFCON,
         XROW.SCCTA,
         lv_PENOM,
         XROW.SCMDA,
         lv_MOSIGN,
         ln_BCSDMO,
         ln_TASA,
         XROW.SCSUC,
         XROW.SCSUC,
         lv_REGNOM,
         lc_CTIFIN);
    
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := 'GE1';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_REP_TESORERIA_TASA_PONDERADA_AHO;

END PQ_AH_TESORERIA_TASA_PONDERADA;
/

