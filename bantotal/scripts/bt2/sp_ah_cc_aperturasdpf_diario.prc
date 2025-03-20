CREATE OR REPLACE PROCEDURE SP_AH_CC_APERTURASDPF_DIARIO (P_USER IN VARCHAR,
                                                       P_horaActual IN VARCHAR,
                                                       P_horaAnterior IN VARCHAR,
                                                       P_ERRCOD OUT VARCHAR,
                                                       P_ERRMSG OUT VARCHAR) IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_CC_APERTURASDPF_DIARIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 30/01/2024
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
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

  v_CTNRO  NUMBER(9);
  v_Ittope NUMBER(3);
BEGIN
	---***
	  DBMS_OUTPUT.DISABLE;

	  SELECT PGFAPE INTO ld_FECAPE FROM FST017 WHERE PGCOD = 1 AND ROWNUM = 1;
	  v_PGFAPE :=  to_char(ld_FECAPE, 'yyyy-mm-dd');
	  ---***
	  P_ERRCOD := '000';
	  P_ERRMSG := 'OK';

	  ---********* DPF INI
		--nota: Para moviles agregar en fsd015 modulo y transacción de moviles.
	   FOR rowM IN 
	  (  SELECT f15.* FROM FSD015 f15 WHERE f15.PGCOD = 1 
		 AND f15.ITMOD = 22
		 AND f15.ITTRAN IN (600,800)
	     AND f15.ITFCON = TO_DATE(v_PGFAPE, 'yyyy-mm-dd')   
		 AND f15.ITHORA > P_horaAnterior and f15.ITHORA <= P_horaActual 		 
		 AND f15.ITCONT = 'S'  

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

	   v_CTNRO  := 0; 
	   v_ITTOPE := 0;
	   --***

	   BEGIN

	   SELECT CTNRO,ITTOPE INTO v_CTNRO,v_ITTOPE FROM FSD016 f16
	   WHERE f16.PGCOD = rowM.PGCOD
	   AND f16.ITSUC  = rowM.ITSUC
	   AND f16.ITMOD  = rowM.ITMOD
	   AND f16.ITTRAN = rowM.ITTRAN
	   AND f16.ITNREL = rowM.ITNREL
	   AND f16.ITFVAL = rowM.ITFCON
	   AND f16.MODULO IN (22, 122)
	   AND f16.ITSUBO = 0;
	   EXCEPTION
		WHEN OTHERS THEN
		  v_CTNRO := 0;
	   END;


	   IF(v_CTNRO <> 0) THEN
			  --**
		   BEGIN
		   SELECT PEPAIS, PETDOC, PENDOC INTO ln_PEPAIS, ln_PETDOC, lc_DOCNRO
		   FROM FSR008
		   WHERE PGCOD = rowM.PGCOD AND CTNRO = v_CTNRO AND CTTFIR = 'T' AND ROWNUM = 1;
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
		   lc_CLSEGM := PQ_ENC_CALIDAD.fn_segcre_cliente(v_CTNRO);
		   --GENERO
		   lc_CLSEXO := PQ_ENC_CALIDAD.fn_sexo_cliente(v_CTNRO);
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

		   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_cre(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTCRE FROM dual;
		   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTCRE) INTO ln_ANTCRE FROM dual;
		   --***
		   SELECT PQ_ENC_CALIDAD.fn_ah_antiguedad_aho(ld_FECAPE, ln_PEPAIS, ln_PETDOC, lc_DOCNRO) INTO ld_ANTAHO FROM dual;
		   SELECT MONTHS_BETWEEN(ld_FECAPE, ld_ANTAHO) INTO ln_ANTAHO FROM dual;
		   --***
		   SELECT TRIM(SCNOM) INTO lc_APESUD FROM FST001 WHERE PGCOD = rowM.PGCOD AND SUCURS = rowM.ITSUC;
		   lc_APEREG := PQ_ENC_CALIDAD.fn_obtener_region(rowM.ITSUC);
		   lc_APEZON := PQ_ENC_CALIDAD.fn_obtener_zona(rowM.ITSUC);
		   --***
		   SELECT TRIM(SCDEPT), LPAD(TRIM(SCCIUD), 4,'0') INTO lc_DEPCOD, lc_UBICOD FROM FST001 WHERE SUCURS = rowM.ITSUC;
		   SELECT DEPNOM INTO lc_APEDEP FROM FST068 WHERE PAIS = 604 AND DEPCOD = TO_NUMBER(lc_DEPCOD, '9999');
		   SELECT LOCNOM INTO lc_APEPRO FROM FST070 WHERE PAIS = 604 AND LOCCOD = TO_NUMBER(lc_UBICOD, '99999');

		   lc_OPEDES := PQ_ENC_CALIDAD.fn_descripcion_operacion(rowM.ITMOD, rowM.ITTRAN);
		   SELECT TRIM(TONOM) INTO lc_PRODES FROM FST004 WHERE MODULO = rowM.ITMOD AND TOTOPE = v_ITTOPE;
		   --***
		   BEGIN
		   SELECT TRIM(UBNOM) INTO lc_COLNOM FROM FST746 WHERE UBUSER = rowM.Ituing;
		   EXCEPTION
				WHEN OTHERS THEN
				  lc_COLNOM := '-';
		   END;
		   --***
		   lc_COLCAR := PQ_ENC_CALIDAD.fn_cargo_usuario2(rowM.Ituing);
		   lc_COLDNI := PQ_ENC_CALIDAD.fn_docide_codusu(rowM.Ituing );
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
		   , rowM.ITFCON, rowM.ITHORA, v_CTNRO, rowM.ITMOD, v_ITTOPE
		   , ln_PEPAIS, ln_PETDOC, lc_DOCNRO, lc_CLNOMB, lc_TIPSBS
		   , lc_CLSEGM, lc_CLSEXO, ln_CLEDAD, lc_CLTEL1, lc_CLTEL2, lc_CLTEL3
		   , ln_ANTCRE, ln_ANTAHO, rowM.ITSUC, lc_APESUD
		   , lc_APEREG, lc_APEZON, lc_APEDEP, lc_APEPRO
		   , lc_OPEDES, lc_PRODES
		   , rowM.Ituing, lc_COLNOM, lc_COLCAR, lc_COLDNI);

		   ---***
		   COMMIT;
		   ---***
		   ---********* DPF FIN

	   END IF;
    END LOOP;

EXCEPTION
WHEN OTHERS THEN
      P_ERRCOD := '001';
      P_ERRMSG := 'OCURRIO UN ERROR AL GENERAR EL REPORTE';
      raise_application_error(-20001,'OCURRIO UN ERROR AL GENERAR EL REPORTE - '||SQLCODE||' -ERROR- '||SQLERRM||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, true);
      --ROLLBACK;

END SP_AH_CC_APERTURASDPF_DIARIO;
/

