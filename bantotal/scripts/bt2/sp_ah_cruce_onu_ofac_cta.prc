CREATE OR REPLACE PROCEDURE SP_AH_CRUCE_ONU_OFAC_CTA
(P_MOD IN NUMBER, P_SUC IN NUMBER, P_MDA IN NUMBER, P_PAP IN NUMBER
, P_CTA IN NUMBER, P_OPER IN NUMBER, P_SOPE IN NUMBER, P_TOPE IN NUMBER, P_GUITRX IN NUMBER, P_MONTRX IN NUMBER, P_FECTRX IN DATE
, P_RESULT OUT VARCHAR, P_RESMSG OUT VARCHAR, P_ERRCOD OUT VARCHAR, P_ERRMSG OUT VARCHAR) IS

lp_APE1 CHAR(30);
lp_APE2 CHAR(30);
lp_NOM1 CHAR(25);
lp_NOM2 CHAR(25);
lp_PAIS NUMBER(3);
lp_TDOC NUMBER(2);
lp_NDOC CHAR(12);
lp_RESULT VARCHAR(4);
lp_RESMSG VARCHAR(240);
lp_ERRCOD VARCHAR(3);
lp_ERRMSG VARCHAR(200);
---***
lp_mail_CLINOM VARCHAR(120);
lp_mail_NRODOC VARCHAR(20);
lp_mail_CTACLI NUMBER(9);
lp_mail_AGEOPE VARCHAR(50);
lp_mail_TIPOPE VARCHAR(30);
lp_mail_MONTO  NUMBER(18,2);
lp_mail_FECOPE VARCHAR(10);
lp_mail_TIPLIS VARCHAR(4);
lp_mail_coderr VARCHAR(1000);
lp_mail_deserr VARCHAR(1000);

---***

BEGIN

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
  BEGIN
  SELECT PFAPE1, PFAPE2, PFNOM1, PFNOM2
  INTO lp_APE1, lp_APE2, lp_NOM1, lp_NOM2
  FROM FSD002 WHERE PFPAIS = lp_PAIS AND PFTDOC = lp_TDOC AND PFNDOC = lp_NDOC;
  EXCEPTION
       WHEN OTHERS THEN
         CONTINUE;
  END;
  ---***
  SP_AH_CRUCE_ONU_OFAC_ONE(lp_APE1, lp_APE2, lp_NOM1, lp_NOM2
  , lp_PAIS, lp_TDOC, lp_NDOC
  , lp_RESULT, lp_RESMSG, lp_ERRCOD, lp_ERRMSG);
  ---***
  P_RESULT := lp_RESULT;
  P_RESMSG := lp_RESMSG;
  P_ERRCOD := lp_ERRCOD;
  P_ERRMSG := lp_ERRMSG;
  ---***
  ---*** CLIENTE EVALUADO
  --dbms_output.PUT_LINE('CLIENTE EVALUADO ... RESULTADOS ***');
  --dbms_output.PUT_LINE('lp_APE1: '||lp_APE1);
  --dbms_output.PUT_LINE('lp_APE2: '||lp_APE2);
  --dbms_output.PUT_LINE('lp_NOM1: '||lp_NOM1);
  --dbms_output.PUT_LINE('lp_NOM2: '||lp_NOM2);
  --dbms_output.PUT_LINE('P_CTA: '||P_CTA);

  --dbms_output.PUT_LINE('P_RESULT: '||P_RESULT);
  --dbms_output.PUT_LINE('P_RESMSG: '||P_RESMSG);
  --dbms_output.PUT_LINE('P_ERRCOD: '||P_ERRCOD);
  --dbms_output.PUT_LINE('P_ERRMSG: '||P_ERRMSG);
  --dbms_output.PUT_LINE('********************');
  ---***
  ---***
  IF(P_RESULT IN ('ONUA')) THEN
    --dbms_output.PUT_LINE('ALERTA: ENVIAR CORREO x Cliente Evaluado y Continuar Analizando Clientes de la CTA ***');
    ---***
    lp_mail_CLINOM := lp_APE1||' '||lp_APE2||' '||lp_NOM1||' '||lp_NOM2;
    lp_mail_NRODOC := lp_NDOC;
    lp_mail_CTACLI := P_CTA;

    IF(P_SUC > 0) THEN
      begin
        SELECT SCNOM INTO lp_mail_AGEOPE FROM FST001 WHERE PGCOD = 1 AND SUCURS = P_SUC;
      exception
      when others then
        lp_mail_AGEOPE := '';
      end;
    ELSE
      --Apertura Batch (SP_AH_GENERA_PRODUCTO_AH)
      lp_mail_AGEOPE := '';
    END IF;
    ---***
    IF(P_MOD > 0) THEN
      begin
      SELECT TRIM(TONOM) INTO lp_mail_TIPOPE FROM FST004 WHERE MODULO = P_MOD AND TOTOPE = P_TOPE;
      --lp_mail_TIPOPE := 'CREDITOS';
      --IF(P_MOD IN (21,22,122)) THEN
      --  lp_mail_TIPOPE := 'AHORROS';
      --END IF;
      ---***
      exception
        when others then
          lp_mail_TIPOPE := 'No Definida en BT';
      end;
    ELSE
      lp_mail_TIPOPE := 'Apertura Batch';
    END IF;
    IF(P_GUITRX IN (0,1,9)) THEN
      lp_mail_MONTO  := P_MONTRX;
      lp_mail_FECOPE := TO_CHAR(P_FECTRX,'DD/MM/YYYY');
    END IF;
    ---***
    lp_mail_TIPLIS := 'ONU';
    ---***
    SP_AH_CRUCE_ONU_OFAC_EMAIL(lp_mail_CLINOM, lp_mail_NRODOC, lp_mail_CTACLI
    , lp_mail_AGEOPE, lp_mail_TIPOPE, lp_mail_MONTO, lp_mail_FECOPE, lp_mail_TIPLIS
    , lp_mail_coderr, lp_mail_deserr);
    ---***
  ELSIF(P_RESULT IN ('ONUB', 'OFAB')) THEN
    --dbms_output.PUT_LINE('MATCH de Bloqueo --> Retornar Respuesta: '||P_RESULT);
    RETURN;
  --ELSE
    --dbms_output.PUT_LINE('Continuar Analizando Clientes de la CTA ***');
  END IF;
  ---***
  END LOOP;
END SP_AH_CRUCE_ONU_OFAC_CTA;
/

