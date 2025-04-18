CREATE OR REPLACE PROCEDURE SP_AH_CC_APERTURAS(P_USER IN VARCHAR, P_FECINI IN DATE, P_FECFIN IN DATE
  , P_ERRCOD OUT VARCHAR, P_ERRMSG OUT VARCHAR) IS

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

  BEGIN
  ---***
  DBMS_OUTPUT.DISABLE;
  ---***
  DELETE FROM AQPB513 WHERE AQPB513CREUSR = P_USER;
  COMMIT;
  ---***
  SELECT PGFAPE INTO ld_FECAPE FROM FST017 WHERE PGCOD = 1 AND ROWNUM = 1;
  ---***
  P_ERRCOD := '000';
  P_ERRMSG := 'OK';
  ---***
  ---********* AHORROS INI
  FOR rowM IN
  (SELECT f11.* FROM FSD011 f11 WHERE f11.PGCOD = 1
   AND f11.SCMOD = 21
   AND f11.SCFVAL BETWEEN P_FECINI AND P_FECFIN
   --** TEST
   --AND f11.SCSUC = 2
   --**
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
     FROM JAQY679 WHERE JAQY679MOD = rowM.SCMOD
     AND JAQY679SUC = rowM.SCSUC
     AND JAQY679MDA = rowM.SCMDA
     AND JAQY679PAP = rowM.SCPAP
     AND JAQY679CTA = rowM.SCCTA
     AND JAQY679OPER = rowM.SCOPER
     AND JAQY679SBOP = rowM.SCSBOP
     AND JAQY679TOPE = rowM.SCTOPE;
     EXCEPTION
        WHEN OTHERS THEN
          lc_APEHOR := '-';
   END;
   --**
   --**
   BEGIN
   SELECT PEPAIS, PETDOC, PENDOC INTO ln_PEPAIS, ln_PETDOC, lc_DOCNRO
   FROM FSR008
   WHERE PGCOD = rowM.PGCOD AND CTNRO = rowM.SCCTA AND CTTFIR = 'T' AND ROWNUM = 1;
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
   lc_CLSEGM := PQ_ENC_CALIDAD.fn_segcre_cliente(rowM.SCCTA);
   --GENERO
   lc_CLSEXO := PQ_ENC_CALIDAD.fn_sexo_cliente(rowM.SCCTA);
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
   SELECT TRIM(SCNOM) INTO lc_APESUD FROM FST001 WHERE PGCOD = rowM.PGCOD AND SUCURS = rowM.SCSUC;
   lc_APEREG := PQ_ENC_CALIDAD.fn_obtener_region(rowM.SCSUC);
   lc_APEZON := PQ_ENC_CALIDAD.fn_obtener_zona(rowM.SCSUC);
   --***
   SELECT TRIM(SCDEPT), LPAD(TRIM(SCCIUD), 4,'0') INTO lc_DEPCOD, lc_UBICOD FROM FST001 WHERE SUCURS = rowM.SCSUC;
   SELECT DEPNOM INTO lc_APEDEP FROM FST068 WHERE PAIS = 604 AND DEPCOD = TO_NUMBER(lc_DEPCOD, '9999');
   SELECT LOCNOM INTO lc_APEPRO FROM FST070 WHERE PAIS = 604 AND LOCCOD = TO_NUMBER(lc_UBICOD, '99999');
   --***
   --select * from fsd011
   --select * from jaqy255
   --select * from fst034
   --lc_OPEDES := PQ_ENC_CALIDAD.fn_descripcion_operacion(rowM.SCMOD, rowM.SCOPER);
   lc_OPEDES := 'Alta AHORROS';
   SELECT TRIM(TONOM) INTO lc_PRODES FROM FST004 WHERE MODULO = rowM.SCMOD AND TOTOPE = rowM.SCTOPE;
   --***
   SELECT TRIM(CV1AUX6) INTO lc_COLCOD
   FROM FSE113 WHERE PGCOD = rowM.PGCOD
   AND CV1MOD = rowM.SCMOD AND CV1MDA = rowM.SCMDA AND CV1PAP = rowM.SCPAP AND CV1CTA = rowM.SCCTA
   AND CV1SUC = rowM.SCSUC AND CV1OPER = rowM.SCOPER AND CV1SBOP = rowM.SCSBOP AND CV1TOPE = rowM.SCTOPE;
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
   VALUES(P_USER, SYSDATE
   , rowM.SCFVAL, lc_APEHOR, rowM.SCCTA, rowM.SCMOD, rowM.SCTOPE
   , ln_PEPAIS, ln_PETDOC, lc_DOCNRO, lc_CLNOMB, lc_TIPSBS
   , lc_CLSEGM, lc_CLSEXO, ln_CLEDAD, lc_CLTEL1, lc_CLTEL2, lc_CLTEL3
   , ln_ANTCRE, ln_ANTAHO, rowM.SCSUC, lc_APESUD
   , lc_APEREG, lc_APEZON, lc_APEDEP, lc_APEPRO
   , lc_OPEDES, lc_PRODES
   , lc_COLCOD, lc_COLNOM, lc_COLCAR, lc_COLDNI);
   END LOOP;
   ---***
   COMMIT;
   ---***
   ---********* AHORROS FIN

   ---********* DPF INI
   --select * from FSH016
   FOR rowM IN
  (SELECT f16.* FROM FSH016 f16 WHERE f16.PGCOD = 1
   AND f16.HCMOD = 22
   AND f16.HFCON BETWEEN P_FECINI AND P_FECFIN
   AND f16.HTRAN IN (600,800)
   AND f16.HMODUL IN (22, 122)
   AND f16.HSUBOP = 0
   --** TEST
   --AND f16.HSUCOR = 2
   --**
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

   BEGIN
   SELECT HUSING, TRIM(HHORA) INTO lc_COLCOD, lc_APEHOR
   FROM FSH015 WHERE PGCOD = rowM.PGCOD
   AND HCMOD = rowM.HCMOD AND HSUCOR = rowM.HSUCOR AND HTRAN = rowM.HTRAN
   AND HNREL = rowM.HNREL AND HFCON = rowM.HFCON
   AND ROWNUM = 1;
   EXCEPTION
    WHEN OTHERS THEN
      lc_COLCOD := '-';
      lc_APEHOR := '-';
   END;
   --**
   BEGIN
   SELECT PEPAIS, PETDOC, PENDOC INTO ln_PEPAIS, ln_PETDOC, lc_DOCNRO
   FROM FSR008
   WHERE PGCOD = rowM.PGCOD AND CTNRO = rowM.HCTA AND CTTFIR = 'T' AND ROWNUM = 1;
   EXCEPTION
        WHEN OTHERS THEN
          CONTINUE;
   END;
   --**
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
   lc_CLSEGM := PQ_ENC_CALIDAD.fn_segcre_cliente(rowM.HCTA);
   --GENERO
   lc_CLSEXO := PQ_ENC_CALIDAD.fn_sexo_cliente(rowM.HCTA);
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
   --SELECT * FROM FSH016 WHERE HCMOD IN (22)
   --select * from fst034 where TRMOD IN (122)
   --***
   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_cre(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTCRE FROM dual;
   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTCRE) INTO ln_ANTCRE FROM dual;
   --***
   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_aho(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTAHO FROM dual;
   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTAHO) INTO ln_ANTAHO FROM dual;
   --***
   SELECT TRIM(SCNOM) INTO lc_APESUD FROM FST001 WHERE PGCOD = rowM.PGCOD AND SUCURS = rowM.HSUCOR;
   lc_APEREG := PQ_ENC_CALIDAD.fn_obtener_region(rowM.HSUCOR);
   lc_APEZON := PQ_ENC_CALIDAD.fn_obtener_zona(rowM.HSUCOR);
   --***
   SELECT TRIM(SCDEPT), LPAD(TRIM(SCCIUD), 4,'0') INTO lc_DEPCOD, lc_UBICOD FROM FST001 WHERE SUCURS = rowM.HSUCOR;
   SELECT DEPNOM INTO lc_APEDEP FROM FST068 WHERE PAIS = 604 AND DEPCOD = TO_NUMBER(lc_DEPCOD, '9999');
   SELECT LOCNOM INTO lc_APEPRO FROM FST070 WHERE PAIS = 604 AND LOCCOD = TO_NUMBER(lc_UBICOD, '99999');

   lc_OPEDES := PQ_ENC_CALIDAD.fn_descripcion_operacion(rowM.HCMOD, rowM.HTRAN);
   SELECT TRIM(TONOM) INTO lc_PRODES FROM FST004 WHERE MODULO = rowM.HCMOD AND TOTOPE = rowM.HTOPER;
   --***
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
   --***
   INSERT INTO AQPB513 (AQPB513CREUSR, AQPB513CRETIM
   , AQPB513APEFEC, AQPB513APEHOR, AQPB513CTANRO, AQPB513CTAMOD, AQPB513CTATOP
   , AQPB513CLPAIS, AQPB513CLTDOC, AQPB513CLNDOC, AQPB513CLNOMB, AQPB513TIPSBS
   , AQPB513CLSEGM, AQPB513CLSEXO, AQPB513CLEDAD, AQPB513CLTEL1, AQPB513CLTEL2, AQPB513CLTEL3
   , AQPB513ANTCRE, AQPB513ANTAHO, AQPB513APESUC, AQPB513APESUD
   , AQPB513APEREG, AQPB513APEZON, AQPB513APEDEP, AQPB513APEPRO
   , AQPB513OPEDES, AQPB513PRODES
   , AQPB513COLCOD, AQPB513COLNOM, AQPB513COLCAR, AQPB513COLDNI)
   VALUES(P_USER, SYSDATE
   , rowM.HFCON, lc_APEHOR, rowM.HCTA, rowM.HCMOD, rowM.HTOPER
   , ln_PEPAIS, ln_PETDOC, lc_DOCNRO, lc_CLNOMB, lc_TIPSBS
   , lc_CLSEGM, lc_CLSEXO, ln_CLEDAD, lc_CLTEL1, lc_CLTEL2, lc_CLTEL3
   , ln_ANTCRE, ln_ANTAHO, rowM.HSUCOR, lc_APESUD
   , lc_APEREG, lc_APEZON, lc_APEDEP, lc_APEPRO
   , lc_OPEDES, lc_PRODES
   , lc_COLCOD, lc_COLNOM, lc_COLCAR, lc_COLDNI);
   END LOOP;
   ---***
   COMMIT;
   ---***
   ---********* DPF FIN
  EXCEPTION
    WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := 'OCURRIO UN ERROR AL GENERAR EL REPORTE';
      raise_application_error(-20001,'OCURRIO UN ERROR AL GENERAR EL REPORTE - '||SQLCODE||' -ERROR- '||SQLERRM||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, true);
      --ROLLBACK;
END SP_AH_CC_APERTURAS;
/

