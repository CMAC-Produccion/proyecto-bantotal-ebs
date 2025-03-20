CREATE OR REPLACE PROCEDURE SP_AH_CC_APERTURAS_DIARIO (P_USER IN VARCHAR,
                                                       P_horaActual IN VARCHAR,
                                                       P_horaAnterior IN VARCHAR,
                                                       P_ERRCOD OUT VARCHAR,
                                                       P_ERRMSG OUT VARCHAR) IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_CC_APERTURAS_DIARIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2023
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 30/01/2024
    -- Autor de la Modificación   : Tania Apaza
    -- Descripción de Modificación: Se cambiaron los filtros
    --
    -- *****************************************************************                                                        

  ld_FECAPE DATE;
  lc_APEHOR VARCHAR(8);
  ln_PEPAIS NUMBER(3);
  ln_PETDOC NUMBER(2);
  lc_DOCNRO CHAR(12);
  lc_CLNOMB VARCHAR(30);
  lc_TIPSBS VARCHAR(50);
  lc_CLTEL1 VARCHAR(20);
  lc_CLTEL2 VARCHAR(20);
  lc_CLTEL3 VARCHAR(20);
  lc_CLSEGM VARCHAR(30);
  lc_CLSEXO VARCHAR(30);
  ld_CLFNAC DATE;
  ln_CLEDAD NUMBER(3);
  ld_ANTCRE DATE;
  ld_ANTAHO DATE;
  ln_ANTCRE NUMBER(9);
  ln_ANTAHO NUMBER(9);

  lc_APESUD VARCHAR(50);
  lc_APEREG VARCHAR(50);
  lc_APEZON VARCHAR(50);
  lc_APEDEP VARCHAR(90);
  lc_APEPRO VARCHAR(90);
  lc_DEPCOD VARCHAR(20);
  lc_UBICOD VARCHAR(20);

  lc_OPEDES VARCHAR(30);
  lc_PRODES VARCHAR(30);

  lc_COLCOD CHAR(10);
  lc_COLNOM VARCHAR(120);
  lc_COLCAR VARCHAR(30);
  lc_COLDNI VARCHAR(12);
  v_PGFAPE VARCHAR(10);

   BEGIN
  ---***
  DBMS_OUTPUT.DISABLE;

  SELECT PGFAPE INTO ld_FECAPE FROM FST017 WHERE PGCOD = 1 AND ROWNUM = 1;
  v_PGFAPE :=  to_char(ld_FECAPE, 'yyyy-mm-dd');
  ---***
  P_ERRCOD := '000';
  P_ERRMSG := 'OK';
  ---***
   ---********* AHORROS INI
  FOR rowM IN
  (SELECT a.* FROM JAQY679 a 
   WHERE a.JAQY679MOD = 21 
   AND a.JAQY679FECH >= TO_TIMESTAMP(v_PGFAPE  || P_horaAnterior, 'YYYY-MM-DD HH24:MI:SS') 
   AND a.JAQY679FECH < TO_TIMESTAMP(v_PGFAPE || P_horaActual, 'YYYY-MM-DD HH24:MI:SS')
   AND a.JAQY679AUX3 IS NULL
   )

   LOOP
   --***
   lc_APEHOR := NULL;
   ln_PEPAIS := 0;
   ln_PETDOC := 0;
   lc_DOCNRO := NULL;
   lc_CLNOMB := NULL;
   lc_TIPSBS := NULL;
   lc_CLTEL1 := NULL;
   lc_CLTEL2 := NULL;
   lc_CLTEL3 := NULL;
   lc_CLSEGM := NULL;
   lc_CLSEXO := NULL;
   ld_CLFNAC := NULL;
   ln_CLEDAD := 0;
   ld_ANTCRE := NULL;
   ld_ANTAHO := NULL;
   ln_ANTCRE := 0;
   ln_ANTAHO := 0;

   lc_APESUD := NULL;
   lc_APEREG := NULL;
   lc_APEZON := NULL;
   lc_APEDEP := NULL;
   lc_APEPRO := NULL;
   lc_DEPCOD := NULL;
   lc_UBICOD := NULL;

   lc_OPEDES := NULL;
   lc_PRODES := NULL;

   lc_COLCOD := NULL;
   lc_COLNOM := NULL;
   lc_COLCAR := NULL;
   lc_COLDNI := NULL;
   --***
   --**
   BEGIN
   SELECT TRIM(TRIM(TO_CHAR(EXTRACT(HOUR FROM JAQY679FECH), '00'))||':'||TRIM(TO_CHAR(EXTRACT(MINUTE FROM JAQY679FECH), '00'))||':'||TRIM(TO_CHAR(EXTRACT(SECOND FROM JAQY679FECH), '00')))
     INTO lc_APEHOR
     FROM JAQY679 WHERE JAQY679MOD = rowM.JAQY679MOD
     AND JAQY679SUC = rowM.JAQY679SUC
     AND JAQY679MDA = rowM.JAQY679MDA
     AND JAQY679PAP = rowM.JAQY679PAP
     AND JAQY679CTA = rowM.JAQY679CTA
     AND JAQY679OPER = rowM.JAQY679OPER
     AND JAQY679SBOP = rowM.JAQY679SBOP
     AND JAQY679TOPE = rowM.JAQY679TOPE;
     EXCEPTION
        WHEN OTHERS THEN
          lc_APEHOR := '-';
   END; 
   --**
   --**
   BEGIN
   SELECT PEPAIS, PETDOC, PENDOC INTO ln_PEPAIS, ln_PETDOC, lc_DOCNRO
   FROM FSR008
   WHERE PGCOD = 1 AND CTNRO = rowM.JAQY679CTA AND CTTFIR = 'T' AND ROWNUM = 1;
   EXCEPTION
        WHEN OTHERS THEN
          CONTINUE;
   END;
   --**
   BEGIN
   SELECT TRIM(PENOM) INTO lc_CLNOMB FROM FSD001 WHERE PEPAIS = ln_PEPAIS AND PETDOC = ln_PETDOC AND PENDOC = lc_DOCNRO;
   EXCEPTION
        WHEN OTHERS THEN
          lc_CLNOMB := '-';
   END;
   --**
   lc_TIPSBS := PQ_ENC_CALIDAD.fn_prosbs(ln_PETDOC, ln_PEPAIS, lc_DOCNRO);
   --**
   --SEGMENTO
   lc_CLSEGM := PQ_ENC_CALIDAD.fn_segcre_cliente(rowM.JAQY679CTA);
   --GENERO
   lc_CLSEXO := PQ_ENC_CALIDAD.fn_sexo_cliente(rowM.JAQY679CTA);
   --EDAD
   BEGIN
   IF(ln_PETDOC = 21) THEN
     SELECT PFFNAC INTO ld_CLFNAC FROM FSD002 WHERE PFPAIS = ln_PEPAIS AND PFTDOC = ln_PETDOC AND PFNDOC = lc_DOCNRO;
   ELSIF(ln_PETDOC = 9) THEN
     SELECT PJFCON INTO ld_CLFNAC FROM FSD003 WHERE PJPAIS = ln_PEPAIS AND PJTDOC = ln_PETDOC AND PJNDOC = lc_DOCNRO;
   ELSE
     ld_CLFNAC := NULL;
   END IF;
   SELECT ROUND((ld_FECAPE - ld_CLFNAC)/365.25, 2) INTO ln_CLEDAD FROM dual;
   EXCEPTION
        WHEN OTHERS THEN
          ln_CLEDAD := 0;
   END;
   --***
   BEGIN
   SELECT COALESCE(f005.DOTELFP, '')
   INTO lc_CLTEL1
   FROM FSR005 f005
   WHERE f005.pepais = ln_PEPAIS
   AND f005.petdoc = ln_PETDOC
   AND f005.pendoc = lc_DOCNRO
   AND f005.docod = 1
   AND f005.doordp = 1;
   EXCEPTION
        WHEN OTHERS THEN
          lc_CLTEL1 := '-';
   END;
   --***
   BEGIN
   SELECT COALESCE(f005.DOTELFP, '')
   INTO lc_CLTEL2
   FROM FSR005 f005
   WHERE f005.pepais = ln_PEPAIS
   AND f005.petdoc = ln_PETDOC
   AND f005.pendoc = lc_DOCNRO
   AND f005.docod = 1
   AND f005.doordp = 2;
   EXCEPTION
        WHEN OTHERS THEN
          lc_CLTEL2 := '-';
   END;
   --***
   BEGIN
   SELECT COALESCE(f005.DOTELFP, '')
   INTO lc_CLTEL3
   FROM FSR005 f005
   WHERE f005.pepais = ln_PEPAIS
   AND f005.petdoc = ln_PETDOC
   AND f005.pendoc = lc_DOCNRO
   AND f005.docod = 1
   AND f005.doordp = 3;
   EXCEPTION
        WHEN OTHERS THEN
          lc_CLTEL3 := '-';
   END;
   --***
   --***
   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_cre(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTCRE FROM dual;
   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTCRE) INTO ln_ANTCRE FROM dual;
   --***
   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_aho(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTAHO FROM dual;
   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTAHO) INTO ln_ANTAHO FROM dual;
   --***
   SELECT TRIM(SCNOM) INTO lc_APESUD FROM FST001 WHERE PGCOD = 1 AND SUCURS = rowM.JAQY679SUC;
   lc_APEREG := PQ_ENC_CALIDAD.fn_obtener_region(rowM.JAQY679SUC);
   lc_APEZON := PQ_ENC_CALIDAD.fn_obtener_zona(rowM.JAQY679SUC);
   --***
   SELECT TRIM(SCDEPT), LPAD(TRIM(SCCIUD), 4,'0') INTO lc_DEPCOD, lc_UBICOD FROM FST001 WHERE SUCURS = rowM.JAQY679SUC;
   SELECT DEPNOM INTO lc_APEDEP FROM FST068 WHERE PAIS = 604 AND DEPCOD = TO_NUMBER(lc_DEPCOD, '9999');
   SELECT LOCNOM INTO lc_APEPRO FROM FST070 WHERE PAIS = 604 AND LOCCOD = TO_NUMBER(lc_UBICOD, '99999');
   --***
   lc_OPEDES := 'Alta AHORROS';
   SELECT TRIM(TONOM) INTO lc_PRODES FROM FST004 WHERE MODULO = rowM.JAQY679MOD AND TOTOPE = rowM.JAQY679TOPE;
   --***
   SELECT TRIM(CV1AUX6) INTO lc_COLCOD
   FROM FSE113 WHERE PGCOD = 1
   AND CV1MOD = rowM.JAQY679MOD AND CV1MDA = rowM.JAQY679MDA AND CV1PAP = rowM.JAQY679PAP AND CV1CTA = rowM.JAQY679CTA
   AND CV1SUC = rowM.JAQY679SUC AND CV1OPER = rowM.JAQY679OPER AND CV1SBOP = rowM.JAQY679SBOP AND CV1TOPE = rowM.JAQY679TOPE;
   --**
   BEGIN
   SELECT TRIM(UBNOM) INTO lc_COLNOM FROM FST746 WHERE UBUSER = lc_COLCOD;
   EXCEPTION
        WHEN OTHERS THEN
          lc_COLNOM := '-';
   END;
   --***
   lc_COLCAR := PQ_ENC_CALIDAD.fn_cargo_usuario2(lc_COLCOD);
   lc_COLDNI := PQ_ENC_CALIDAD.fn_docide_codusu(lc_COLCOD);
   --***
   INSERT INTO AQPB513 (AQPB513CREUSR, AQPB513CRETIM
   , AQPB513APEFEC, AQPB513APEHOR, AQPB513CTANRO, AQPB513CTAMOD, AQPB513CTATOP
   , AQPB513CLPAIS, AQPB513CLTDOC, AQPB513CLNDOC, AQPB513CLNOMB, AQPB513TIPSBS
   , AQPB513CLSEGM, AQPB513CLSEXO, AQPB513CLEDAD, AQPB513CLTEL1, AQPB513CLTEL2, AQPB513CLTEL3
   , AQPB513ANTCRE, AQPB513ANTAHO, AQPB513APESUC, AQPB513APESUD
   , AQPB513APEREG, AQPB513APEZON, AQPB513APEDEP, AQPB513APEPRO
   , AQPB513OPEDES, AQPB513PRODES
   , AQPB513COLCOD, AQPB513COLNOM, AQPB513COLCAR, AQPB513COLDNI)
   VALUES(TRIM(P_USER), SYSDATE
   , rowM.JAQY679FECH, lc_APEHOR, rowM.JAQY679CTA, rowM.JAQY679MOD, rowM.JAQY679TOPE
   , ln_PEPAIS, ln_PETDOC, lc_DOCNRO, lc_CLNOMB, lc_TIPSBS
   , lc_CLSEGM, lc_CLSEXO, ln_CLEDAD, lc_CLTEL1, lc_CLTEL2, lc_CLTEL3
   , ln_ANTCRE, ln_ANTAHO, rowM.JAQY679SUC, lc_APESUD
   , lc_APEREG, lc_APEZON, lc_APEDEP, lc_APEPRO
   , lc_OPEDES, lc_PRODES
   , lc_COLCOD, lc_COLNOM, lc_COLCAR, lc_COLDNI);
   END LOOP;
   ---***
   COMMIT;
   ---***
   ---********* AHORROS FIN
EXCEPTION
WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := 'OCURRIO UN ERROR AL GENERAR EL REPORTE';
      raise_application_error(-20001,'OCURRIO UN ERROR AL GENERAR EL REPORTE - '||SQLCODE||' -ERROR- '||SQLERRM||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, true);
      --ROLLBACK;
END SP_AH_CC_APERTURAS_DIARIO;
/

