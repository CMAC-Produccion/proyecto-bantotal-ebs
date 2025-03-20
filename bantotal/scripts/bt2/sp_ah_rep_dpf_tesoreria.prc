CREATE OR REPLACE PROCEDURE SP_AH_REP_DPF_TESORERIA(P_CREUSU IN VARCHAR,
                                                    P_FECCOR IN DATE,
                                                    P_SUCCOD IN NUMBER,
                                                    P_CTACLI IN NUMBER,
                                                    P_ERRCOD OUT VARCHAR,
                                                    P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_REP_DPF_TESORERIA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.07.21
  -- Autor de Creación          : CVILLON
  -- Uso                        : Reporte DPF Tesoreria
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.01.24
  -- Modificado                 : CVILLON
  -- ***************************************************************************************
  ---***

  ---*
  ln_ROWNRO NUMBER(3);
  ---*
  ln_SUCINI NUMBER(3);
  ln_SUCFIN NUMBER(3);
  ln_CTAINI NUMBER(9);
  ln_CTAFIN NUMBER(9);
  ---***
  ln_PEPAIS NUMBER(3);
  ln_PETDOC NUMBER(2);
  lc_PENDOC CHAR(12);
  lv_PENOM  VARCHAR(30);
  lv_OFINOM VARCHAR(30);
  ---***
  ln_REGNOM NUMBER(9);
  lv_REGNOM VARCHAR(30);
  ---***
  ln_TASA   NUMBER(10, 6);
  ln_IMPINT NUMBER(17, 2);
  ln_PLAZO  NUMBER(9);
  ---***
  lc_PETIPO CHAR(1);
  ---***

BEGIN
  ---***
  DELETE FROM AQPB543 WHERE AQPB543CREUSU = P_CREUSU;
  COMMIT;
  ---***
  IF (P_SUCCOD = 0) THEN
    ln_SUCINI := 0;
    ln_SUCFIN := 999;
  ELSE
    ln_SUCINI := P_SUCCOD;
    ln_SUCFIN := P_SUCCOD;
  END IF;
  ---***
  IF (P_CTACLI = 0) THEN
    ln_CTAINI := 0;
    ln_CTAFIN := 999999999;
  ELSE
    ln_CTAINI := P_CTACLI;
    ln_CTAFIN := P_CTACLI;
  END IF;
  ---***
  ln_ROWNRO := 0;
  --***
  FOR XROW IN (SELECT *
                 FROM FSD010
                WHERE PGCOD = 1
                  AND AOMOD = 22
                  AND AOSUC BETWEEN ln_SUCINI AND ln_SUCFIN
                  AND AOCTA BETWEEN ln_CTAINI AND ln_CTAFIN
                  AND P_FECCOR BETWEEN AOFVAL AND AOFVTO
                  AND (AOFE99 = TO_DATE('01/01/0001', 'dd/MM/yyyy') OR
                      (AOFE99 >= P_FECCOR))) LOOP
    ---***
    ln_ROWNRO := ln_ROWNRO + 1;
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
    IF (lc_PETIPO <> 'J') THEN
      CONTINUE;
    END IF;
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
    lv_REGNOM := '-';
    SELECT COUNT(*)
      INTO ln_REGNOM
      FROM JAQL478
     WHERE JAQL478PGC = XROW.PGCOD
       AND JAQL478MOD = XROW.AOMOD
       AND JAQL478SUC = XROW.AOSUC
       AND JAQL478MDA = XROW.AOMDA
       AND JAQL478PAP = XROW.AOPAP
       AND JAQL478CTA = XROW.AOCTA
       AND JAQL478OPE = XROW.AOOPER
       AND JAQL478SUB = XROW.AOSBOP
       AND JAQL478TOP = XROW.AOTOPE;
  
    IF (ln_REGNOM > 0) THEN
      lv_REGNOM := 'Tesoreria';
    END IF;
    ---***
  
    -- BUSCAR CAMBIO DE TASA
    BEGIN
      SELECT EVTASA
        INTO ln_TASA
        FROM FSD012
       WHERE PGCOD = XROW.PGCOD
         AND AOMOD = XROW.AOMOD
         AND AOSUC = XROW.AOSUC
         AND AOMDA = XROW.AOMDA
         AND AOPAP = XROW.AOPAP
         AND AOCTA = XROW.AOCTA
         AND AOOPER = XROW.AOOPER
         AND AOSBOP = XROW.AOSBOP
         AND AOTOPE = XROW.AOTOPE
         AND ROWNUM = 1;
      --EVCORR
    exception
      when others then
        ln_TASA := 0;
    END;
  
    IF (ln_TASA = 0) THEN
      ln_TASA := XROW.AOTASA;
    END IF;
    ---***
    ln_PLAZO  := P_FECCOR - XROW.AOFVAL;
    ln_IMPINT := round(pq_ah_calc_dpf.fn_ah_calcint(ln_PLAZO,
                                                    ln_TASA,
                                                    XROW.AOIMP),
                       2);
    ---***
    INSERT INTO AQPB543
      (AQPB543CREUSU,
       AQPB543CODIGO,
       AQPB543CRETIM,
       AQPB543CTACOD,
       AQPB543CTAMOD,
       AQPB543CTASUC,
       AQPB543CTAMDA,
       AQPB543CTAPAP,
       AQPB543CTACLI,
       AQPB543CTAOPE,
       AQPB543CTASOP,
       AQPB543CTATOP,
       AQPB543CTAVAL,
       AQPB543CTAVTO,
       AQPB543CTAPZO,
       AQPB543CTATAS,
       AQPB543ENTNOM,
       AQPB543IMPCAP,
       AQPB543IMPINT,
       AQPB543IMPTOT,
       AQPB543OFINOM,
       AQPB543REGNOM,
       AQPB543ERRCOD,
       AQPB543ERRMSG)
    VALUES
      (P_CREUSU,
       ln_ROWNRO,
       SYSDATE,
       XROW.PGCOD,
       XROW.AOMOD,
       XROW.AOSUC,
       XROW.AOMDA,
       XROW.AOPAP,
       XROW.AOCTA,
       XROW.AOOPER,
       XROW.AOSBOP,
       XROW.AOTOPE,
       XROW.AOFVAL,
       XROW.AOFVTO,
       XROW.AOPZO,
       ln_TASA,
       lv_PENOM,
       XROW.AOIMP,
       ln_IMPINT,
       (XROW.AOIMP + ln_IMPINT),
       lv_OFINOM,
       lv_REGNOM,
       null,
       null);
  
  END LOOP;
  ---***
  COMMIT;
  ---***
EXCEPTION
  when others then
    P_ERRCOD := 'GE1';
    P_ERRMSG := sqlcode || '->' || sqlerrm;
    RETURN;
END SP_AH_REP_DPF_TESORERIA;
---*********************
/

