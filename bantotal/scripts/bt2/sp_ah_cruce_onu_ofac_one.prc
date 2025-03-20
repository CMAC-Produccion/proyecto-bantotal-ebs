CREATE OR REPLACE PROCEDURE SP_AH_CRUCE_ONU_OFAC_ONE
(P_APE1 IN CHAR, P_APE2 IN CHAR, P_NOM1 IN CHAR, P_NOM2 IN CHAR
, P_PAIS IN NUMBER, P_TDOC IN NUMBER, P_NDOC CHAR
, P_RESULT OUT VARCHAR, P_RESMSG OUT VARCHAR, P_ERRCOD OUT VARCHAR, P_ERRMSG OUT VARCHAR) IS

  ---***
  ---*** CON QUE REGISTRO DE LA AQPB511 SE DIO LA COINCIDENCIA
  lc_carcod VARCHAR(16);
  lc_cartip VARCHAR(3);
  lc_carnum NUMBER(9);
  ---***
  lc_APE1 VARCHAR(30);
  lc_APE2 VARCHAR(30);
  lc_NOM1 VARCHAR(25);
  lc_NOM2 VARCHAR(25);

  ln_APE1 NUMBER(2);
  ln_APE2 NUMBER(2);
  ln_NOM1 NUMBER(2);
  ln_NOM2 NUMBER(2);
  ln_MATCH NUMBER(2);
  ln_MATCH_TOP NUMBER(2);
  ln_INFLN NUMBER(2);
  ---***
  lc_NomApe VARCHAR(240);
  lc_NomApe_Eval VARCHAR(240);
  ---***
  ln_lstblanca NUMBER(2);
  ---***

BEGIN
---***
P_RESULT := 'NINI';
---***
SELECT COUNT(*) INTO ln_lstblanca FROM AQPB512
WHERE AQPB512PAIS = P_PAIS AND AQPB512TDOC = P_TDOC AND AQPB512NDOC = P_NDOC AND AQPB512EST = 'A';

IF(ln_lstblanca > 0) THEN
  P_RESULT := 'NNLB';
  P_RESMSG := 'CLIENTE EN LISTA BLANCA';
ELSE
FOR ROWAQPB IN (SELECT * FROM AQPB511)
  LOOP
  ---***
  IF(ROWAQPB.AQPB511CARTIP = 'ONU') THEN

  --SELECT COUNT(*) FROM DUAL WHERE 'JUAN' IN ('JUAN', 'LUCAS', 'JUAN', '');

    ---***
    ln_APE1 := 0;
    ln_APE2 := 0;
    ln_NOM1 := 0;
    ln_NOM2 := 0;
    ln_MATCH := 0;

    lc_APE1 := TRIM(P_APE1);
    lc_APE2 := TRIM(P_APE2);
    lc_NOM1 := TRIM(P_NOM1);
    lc_NOM2 := TRIM(P_NOM2);
    ---***
    SELECT COUNT(*) INTO ln_APE1 FROM DUAL WHERE lc_APE1
    IN (ROWAQPB.AQPB511NOM, ROWAQPB.AQPB511NOM2, ROWAQPB.AQPB511NOM3, ROWAQPB.AQPB511NOM4, ROWAQPB.AQPB511NOM5
    , ROWAQPB.AQPB511NOM6, ROWAQPB.AQPB511NOM7, ROWAQPB.AQPB511NOM8, ROWAQPB.AQPB511NOM9, ROWAQPB.AQPB511NOM10);

    SELECT COUNT(*) INTO ln_APE2 FROM DUAL WHERE lc_APE2
    IN (ROWAQPB.AQPB511NOM, ROWAQPB.AQPB511NOM2, ROWAQPB.AQPB511NOM3, ROWAQPB.AQPB511NOM4, ROWAQPB.AQPB511NOM5
    , ROWAQPB.AQPB511NOM6, ROWAQPB.AQPB511NOM7, ROWAQPB.AQPB511NOM8, ROWAQPB.AQPB511NOM9, ROWAQPB.AQPB511NOM10);

    SELECT COUNT(*) INTO ln_NOM1 FROM DUAL WHERE lc_NOM1
    IN (ROWAQPB.AQPB511NOM, ROWAQPB.AQPB511NOM2, ROWAQPB.AQPB511NOM3, ROWAQPB.AQPB511NOM4, ROWAQPB.AQPB511NOM5
    , ROWAQPB.AQPB511NOM6, ROWAQPB.AQPB511NOM7, ROWAQPB.AQPB511NOM8, ROWAQPB.AQPB511NOM9, ROWAQPB.AQPB511NOM10);

    SELECT COUNT(*) INTO ln_NOM2 FROM DUAL WHERE lc_NOM2
    IN (ROWAQPB.AQPB511NOM, ROWAQPB.AQPB511NOM2, ROWAQPB.AQPB511NOM3, ROWAQPB.AQPB511NOM4, ROWAQPB.AQPB511NOM5
    , ROWAQPB.AQPB511NOM6, ROWAQPB.AQPB511NOM7, ROWAQPB.AQPB511NOM8, ROWAQPB.AQPB511NOM9, ROWAQPB.AQPB511NOM10);

    ---***
    ln_MATCH := ln_APE1 + ln_APE2 + ln_NOM1 + ln_NOM2;
    ---***
    ln_MATCH_TOP := 2; --Min Cantidad de MATCHES (Si lista Negra solo ofrece un Dato EJ. NOM2 = SAENZ, se Ignora)
    IF(lc_APE1 = lc_APE2) THEN
      ln_MATCH_TOP := 3;
    END IF;
    ---***
    IF(ln_MATCH = ln_MATCH_TOP) THEN
      lc_carcod := ROWAQPB.AQPB511CARCOD;
      lc_cartip := ROWAQPB.AQPB511CARTIP;
      lc_carnum := ROWAQPB.AQPB511NUM;
      ln_INFLN := 0;
      ---*** PARECE ALERTA, PERO CUANTOS DATOS ME DA LA LISTA NEGRA
      IF(TRIM(ROWAQPB.AQPB511NOM) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM2) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM3) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM4) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM5) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM6) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM7) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM8) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM9) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      IF(TRIM(ROWAQPB.AQPB511NOM10) IS NOT NULL) THEN
        ln_INFLN := ln_INFLN + 1;
      END IF;
      ---***
      IF(ln_INFLN > 2) THEN
        P_RESULT := 'NNCO';
        P_RESMSG := 'NO MATCH (La Información en Lista Negra es Suficiente para Descartar MATCH)';
        --dbms_output.put_line('NO MATCH ... La Información en Lista Negra es Suficiente (Min 3) para Descartar MATCH...');
        --dbms_output.put_line('ln_MATCH:: '||ln_MATCH);
        --dbms_output.put_line('ln_INFLN:: '||ln_INFLN);

        --dbms_output.put_line('DATOS de Persona en Lista Negra ...');
        --dbms_output.put_line('lc_carcod:: '||lc_carcod);
        --dbms_output.put_line('lc_cartip:: '||lc_cartip);
        --dbms_output.put_line('lc_carnum:: '||lc_carnum);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM:: '||ROWAQPB.AQPB511NOM);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM2:: '||ROWAQPB.AQPB511NOM2);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM3:: '||ROWAQPB.AQPB511NOM3);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM4:: '||ROWAQPB.AQPB511NOM4);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM5:: '||ROWAQPB.AQPB511NOM5);

        --dbms_output.put_line('DATOS de Persona EVALUADA ...');
        --dbms_output.put_line('lc_NOM1:: '||lc_NOM1);
        --dbms_output.put_line('lc_NOM2:: '||lc_NOM2);
        --dbms_output.put_line('lc_APE1:: '||lc_APE1);
        --dbms_output.put_line('lc_APE2:: '||lc_APE2);
        --dbms_output.put_line('P_PAIS:: '||P_PAIS);
        --dbms_output.put_line('P_TDOC:: '||P_TDOC);
        --dbms_output.put_line('P_NDOC:: '||P_NDOC);

      ELSE
        P_RESULT := 'ONUA';
        P_RESMSG := 'MATCH DE ALERTA ...';
        --dbms_output.put_line('MATCH DE ALERTA ...');
        --dbms_output.put_line('ln_MATCH:: '||ln_MATCH);

        --dbms_output.put_line('DATOS de Persona en Lista Negra ...');
        --dbms_output.put_line('lc_carcod:: '||lc_carcod);
        --dbms_output.put_line('lc_cartip:: '||lc_cartip);
        --dbms_output.put_line('lc_carnum:: '||lc_carnum);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM:: '||ROWAQPB.AQPB511NOM);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM2:: '||ROWAQPB.AQPB511NOM2);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM3:: '||ROWAQPB.AQPB511NOM3);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM4:: '||ROWAQPB.AQPB511NOM4);
        --dbms_output.put_line('ROWAQPB.AQPB511NOM5:: '||ROWAQPB.AQPB511NOM5);

        --dbms_output.put_line('DATOS de Persona EVALUADA ...');
        --dbms_output.put_line('lc_NOM1:: '||lc_NOM1);
        --dbms_output.put_line('lc_NOM2:: '||lc_NOM2);
        --dbms_output.put_line('lc_APE1:: '||lc_APE1);
        --dbms_output.put_line('lc_APE2:: '||lc_APE2);
        --dbms_output.put_line('P_PAIS:: '||P_PAIS);
        --dbms_output.put_line('P_TDOC:: '||P_TDOC);
        --dbms_output.put_line('P_NDOC:: '||P_NDOC);

      END IF;

    ELSIF(ln_MATCH > ln_MATCH_TOP) THEN
      P_RESULT := 'ONUB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
      lc_carcod := ROWAQPB.AQPB511CARCOD;
      lc_cartip := ROWAQPB.AQPB511CARTIP;
      lc_carnum := ROWAQPB.AQPB511NUM;

      --dbms_output.put_line('MATCH DE BLOQUEO ...');
      --dbms_output.put_line('ln_MATCH:: '||ln_MATCH);
      --dbms_output.put_line('DATOS de Persona en Lista Negra ...');
      --dbms_output.put_line('lc_carcod:: '||lc_carcod);
      --dbms_output.put_line('lc_cartip:: '||lc_cartip);
      --dbms_output.put_line('lc_carnum:: '||lc_carnum);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM:: '||ROWAQPB.AQPB511NOM);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM2:: '||ROWAQPB.AQPB511NOM2);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM3:: '||ROWAQPB.AQPB511NOM3);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM4:: '||ROWAQPB.AQPB511NOM4);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM5:: '||ROWAQPB.AQPB511NOM5);

      --dbms_output.put_line('DATOS de Persona EVALUADA ...');
      --dbms_output.put_line('lc_NOM1:: '||lc_NOM1);
      --dbms_output.put_line('lc_NOM2:: '||lc_NOM2);
      --dbms_output.put_line('lc_APE1:: '||lc_APE1);
      --dbms_output.put_line('lc_APE2:: '||lc_APE2);
      --dbms_output.put_line('P_PAIS:: '||P_PAIS);
      --dbms_output.put_line('P_TDOC:: '||P_TDOC);
      --dbms_output.put_line('P_NDOC:: '||P_NDOC);

    END IF;

    IF(P_RESULT = 'ONUB') THEN
      --EXIT;
      RETURN;
    END IF;
  ---***
  ELSIF(ROWAQPB.AQPB511CARTIP = 'OFA') THEN
    lc_APE1 := TRIM(P_APE1);
    lc_APE2 := TRIM(P_APE2);
    lc_NOM1 := TRIM(P_NOM1);
    lc_NOM2 := TRIM(P_NOM2);
    --&vNomApe = Concat(Trim(&JAQZ757NOM6),Trim(&JAQZ757NOM),' ')
    ---***
    lc_NomApe_Eval := lc_APE1||' '||lc_APE2||' '||lc_NOM1||' '||lc_NOM2;
    lc_NomApe_Eval := TRIM(lc_NomApe_Eval);
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM6||' '||ROWAQPB.AQPB511NOM;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM7||' '||ROWAQPB.AQPB511NOM2;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM8||' '||ROWAQPB.AQPB511NOM3;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM9||' '||ROWAQPB.AQPB511NOM4;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM10||' '||ROWAQPB.AQPB511NOM5;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM2;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM3;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM4;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM5;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM6;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM7;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM8;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM9;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;
    ---***
    lc_NomApe := ROWAQPB.AQPB511NOM10;
    lc_NomApe := TRIM(lc_NomApe);
    IF(lc_NomApe_Eval = lc_NomApe) THEN
      P_RESULT := 'OFAB';
      P_RESMSG := 'MATCH DE BLOQUEO ...';
    END IF;


    ---***
    IF(P_RESULT = 'OFAB') THEN
      --dbms_output.put_line('MATCH DE BLOQUEO OFA ...');
      --dbms_output.put_line('ln_MATCH:: '||ln_MATCH);
      --dbms_output.put_line('DATOS de Persona en Lista Negra ...');
      --dbms_output.put_line('lc_carcod:: '||lc_carcod);
      --dbms_output.put_line('lc_cartip:: '||lc_cartip);
      --dbms_output.put_line('lc_carnum:: '||lc_carnum);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM:: '||ROWAQPB.AQPB511NOM);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM2:: '||ROWAQPB.AQPB511NOM2);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM3:: '||ROWAQPB.AQPB511NOM3);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM4:: '||ROWAQPB.AQPB511NOM4);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM5:: '||ROWAQPB.AQPB511NOM5);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM6:: '||ROWAQPB.AQPB511NOM6);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM7:: '||ROWAQPB.AQPB511NOM7);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM8:: '||ROWAQPB.AQPB511NOM8);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM9:: '||ROWAQPB.AQPB511NOM9);
      --dbms_output.put_line('ROWAQPB.AQPB511NOM10:: '||ROWAQPB.AQPB511NOM10);

      --dbms_output.put_line('DATOS de Persona EVALUADA ...');
      --dbms_output.put_line('lc_NOM1:: '||lc_NOM1);
      --dbms_output.put_line('lc_NOM2:: '||lc_NOM2);
      --dbms_output.put_line('lc_APE1:: '||lc_APE1);
      --dbms_output.put_line('lc_APE2:: '||lc_APE2);
      --dbms_output.put_line('P_PAIS:: '||P_PAIS);
      --dbms_output.put_line('P_TDOC:: '||P_TDOC);
      --dbms_output.put_line('P_NDOC:: '||P_NDOC);
      --EXIT;
      RETURN;
    END IF;

  END IF;
  ---***
  END LOOP;
END IF;
END SP_AH_CRUCE_ONU_OFAC_ONE;
/

