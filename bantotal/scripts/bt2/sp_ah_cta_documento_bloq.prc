CREATE OR REPLACE PROCEDURE SP_AH_CTA_DOCUMENTO_BLOQ(P_CTA IN NUMBER
, P_RESULT OUT VARCHAR
, P_RESMSG OUT VARCHAR
, P_ERRCOD OUT VARCHAR
, P_ERRMSG OUT VARCHAR) IS
---***
---***
ln_PN NUMBER(3);
ln_PJ NUMBER(3);
---***
ld_HOY DATE;
ln_AUT NUMBER(3);
---***
lp_APE1 CHAR(30);
lp_APE2 CHAR(30);
lp_NOM1 CHAR(25);
lp_NOM2 CHAR(25);
lp_PAIS NUMBER(3);
lp_TDOC NUMBER(2);
lp_NDOC CHAR(12);

lc_TDNOM VARCHAR(20);

lp_RESULT VARCHAR(4);
lp_RESMSG VARCHAR(240);
lp_ERRCOD VARCHAR(3);
lp_ERRMSG VARCHAR(200);

BEGIN
  ---***
  P_RESULT := '000';
  P_RESMSG := '';
  P_ERRCOD := '000';
  P_ERRMSG := '';
  lc_TDNOM := '';
  ---***
  SELECT PGFAPE INTO ld_HOY FROM FST017 WHERE PGCOD = 1;
  ---***
  FOR XROW IN (SELECT * FROM FSR008 WHERE PGCOD = 1 AND CTNRO = P_CTA)
  LOOP
  ---*** INIT
  lp_APE1 := NULL;
  lp_APE2 := NULL;
  lp_NOM1 := NULL;
  lp_NOM2 := NULL;
  lp_PAIS := NULL;
  lp_TDOC := NULL;
  lp_NDOC := NULL;
  lp_RESULT := NULL;
  lp_RESMSG := NULL;
  lp_ERRCOD := NULL;
  lp_ERRMSG := NULL;
  ---***
  lp_PAIS := XROW.PEPAIS;
  lp_TDOC := XROW.PETDOC;
  lp_NDOC := XROW.PENDOC;
  ---***
  ---***
  SELECT COUNT(*) INTO ln_PN
  FROM FSD002 WHERE PFPAIS = lp_PAIS AND PFTDOC = lp_TDOC AND PFNDOC = lp_NDOC;
  ---***
  IF(ln_PN = 0) THEN
    SELECT COUNT(*) INTO ln_PJ
    FROM FSD003 WHERE PJPAIS = lp_PAIS AND PJTDOC = lp_TDOC AND PJNDOC = lp_NDOC;
  END IF;
  ---***
  IF(ln_PN > 0) THEN
    BEGIN
    SELECT PFAPE1, PFAPE2, PFNOM1, PFNOM2
    INTO lp_APE1, lp_APE2, lp_NOM1, lp_NOM2
    FROM FSD002 WHERE PFPAIS = lp_PAIS AND PFTDOC = lp_TDOC AND PFNDOC = lp_NDOC;
    EXCEPTION
         WHEN OTHERS THEN
           CONTINUE;
    END;
    ---***
    ---*** TIENE AUTORIZACION?
    SELECT COUNT(*) INTO ln_AUT FROM AQPB525 WHERE AQPB525DOCPAI = XROW.PEPAIS
    AND AQPB525DOCTIP = XROW.PETDOC
    AND AQPB525DOCNUM = XROW.PENDOC
    AND AQPB525ESTADO = 'V'
    AND ld_HOY BETWEEN AQPB525AUTINI AND AQPB525AUTFIN;
    IF(ln_AUT > 0) THEN
      --dbms_output.PUT_LINE('PN CLIENTE EVALUADO ... TIENE AUTORIZACION ***');
      --dbms_output.PUT_LINE('P_CTA: '||P_CTA);
      --dbms_output.PUT_LINE('lp_APE1: '||lp_APE1);
      --dbms_output.PUT_LINE('lp_APE2: '||lp_APE2);
      --dbms_output.PUT_LINE('lp_NOM1: '||lp_NOM1);
      --dbms_output.PUT_LINE('lp_NOM2: '||lp_NOM2);

      --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
      --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
      --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
      --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
      --dbms_output.PUT_LINE('********************');
      CONTINUE;
    END IF;
    ---***
    ---***
    FOR BROW IN (SELECT TP1NRO1 FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11146 AND TP1CORR1 = 1 AND TP1CORR2 = 45)
    LOOP
    IF (lp_TDOC = BROW.TP1NRO1) THEN
      ---*** CLIENTE EVALUADO
      ---***
      SELECT TRIM(TDNOM) INTO lc_TDNOM FROM FST014 WHERE TDOCUM = lp_TDOC;
      lc_TDNOM := UPPER(lc_TDNOM);
      ---***
      P_RESULT :=  TO_CHAR(lp_TDOC);
      --P_RESMSG := 'Cuenta Cliente tiene BLOQUEO para Alta de Productos PASIVOS por Integrante con: '||lc_TDNOM;
      P_RESMSG := 'Cuenta tiene BLOQUEO por Integrante con: '||lc_TDNOM;
      P_ERRCOD := '000';
      P_ERRMSG := '';
      ---***
      --dbms_output.PUT_LINE('PN CLIENTE EVALUADO ... RESULTADOS ***');
      --dbms_output.PUT_LINE('P_CTA: '||P_CTA);
      --dbms_output.PUT_LINE('lp_APE1: '||lp_APE1);
      --dbms_output.PUT_LINE('lp_APE2: '||lp_APE2);
      --dbms_output.PUT_LINE('lp_NOM1: '||lp_NOM1);
      --dbms_output.PUT_LINE('lp_NOM2: '||lp_NOM2);

      --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
      --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
      --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
      --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
      --dbms_output.PUT_LINE('********************');
      ---*** SI TIPO DOC ES BLOQUEANTE RETORNAMOS
      RETURN;
      ---***
    ELSE
      P_RESULT := '000';
      P_RESMSG := '';
      P_ERRCOD := '000';
      P_ERRMSG := '';
    END IF;
    END LOOP;

  ELSIF (ln_PJ > 0) THEN -- PJ
      ---***
      P_RESULT := '000';
      P_RESMSG := '';
      P_ERRCOD := '000';
      P_ERRMSG := '';
      ---***
      --dbms_output.PUT_LINE('PJ CLIENTE EVALUADO ... RESULTADOS ***');
      --dbms_output.PUT_LINE('PJPAIS: '||lp_PAIS);
      --dbms_output.PUT_LINE('PJTDOC: '||lp_TDOC);
      --dbms_output.PUT_LINE('PJNDOC: '||lp_NDOC);
      --dbms_output.PUT_LINE('********************');
      ---***
      FOR XPJ IN (SELECT * FROM FSR003 WHERE VICOD = 7 AND PJPAIS = lp_PAIS AND PJTDOC = lp_TDOC AND PJNDOC = lp_NDOC)
      LOOP
        ---***
        --dbms_output.PUT_LINE('PJ REPRESENTANTE EVALUADO: '||XPJ.PFPAI1||' : '||XPJ.PFTDO1||' : '||XPJ.PFNDO1);
        ---***
        ---*** TIENE AUTORIZACION?
        SELECT COUNT(*) INTO ln_AUT FROM AQPB525 WHERE AQPB525DOCPAI = XPJ.PFPAI1
        AND AQPB525DOCTIP = XPJ.PFTDO1
        AND AQPB525DOCNUM = XPJ.PFNDO1
        AND AQPB525ESTADO = 'V'
        AND ld_HOY BETWEEN AQPB525AUTINI AND AQPB525AUTFIN;
        IF(ln_AUT > 0) THEN
          --dbms_output.PUT_LINE('PJ REPRESENTANTE EVALUADO ... TIENE AUTORIZACION ***');
          --dbms_output.PUT_LINE('P_CTA: '||P_CTA);
          --dbms_output.PUT_LINE('lp_APE1: '||lp_APE1);
          --dbms_output.PUT_LINE('lp_APE2: '||lp_APE2);
          --dbms_output.PUT_LINE('lp_NOM1: '||lp_NOM1);
          --dbms_output.PUT_LINE('lp_NOM2: '||lp_NOM2);

          --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
          --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
          --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
          --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
          --dbms_output.PUT_LINE('********************');
          CONTINUE;
        END IF;
        ---***
        FOR BROW IN (SELECT TP1NRO1 FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11146 AND TP1CORR1 = 1 AND TP1CORR2 = 45)
        LOOP
        IF(XPJ.PFTDO1 = BROW.TP1NRO1) THEN
          ---***
          SELECT TRIM(TDNOM) INTO lc_TDNOM FROM FST014 WHERE TDOCUM = XPJ.PFTDO1;
          lc_TDNOM := UPPER(lc_TDNOM);
          ---***
          P_RESULT := TO_CHAR(XPJ.PFTDO1);
          P_RESMSG := 'Cuenta tiene BLOQUEO por Representante con: '||lc_TDNOM;
          P_ERRCOD := '000';
          P_ERRMSG := '';

          --dbms_output.PUT_LINE('PJ REPRESENTANTE: '||XPJ.PFPAI1||' : '||XPJ.PFTDO1||' : '||XPJ.PFNDO1);
          --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
          --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
          --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
          --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
          --dbms_output.PUT_LINE('********************');
          ---*** SI TIPO DOC ES BLOQUEANTE RETORNAMOS
          RETURN;
          ---***
        END IF;
        END LOOP;
        ---***
      END LOOP;
      ---***
      --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
      --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
      --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
      --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
      --dbms_output.PUT_LINE('********************');
      ---***
  ELSE
      P_RESULT := '000';
      P_RESMSG := '';
      P_ERRCOD := '000';
      P_ERRMSG := '';
      ---***
      --dbms_output.PUT_LINE('TOTAL ELSE ...');
      --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
      --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
      --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
      --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
      --dbms_output.PUT_LINE('********************');
      ---***
  END IF;
  ---***
  END LOOP;
  ---***
END SP_AH_CTA_DOCUMENTO_BLOQ;
/

