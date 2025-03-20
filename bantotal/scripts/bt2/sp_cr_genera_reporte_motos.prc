CREATE OR REPLACE PROCEDURE SP_CR_GENERA_REPORTE_MOTOS(pFCHINI IN DATE,
                                                 pFCHFIN IN DATE) IS
   -- *****************************************************************************************
   -- NOMBRE                      : SP_CR_GENERA_REPORTE_MOTOS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/11/2022
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA REPORTE DE MOTOS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************************************
   
   PGCOD  NUMBER(3) := 0;
   SUC    NUMBER(3) := 0;
   MODULO NUMBER(3) := 0;
   MDA    NUMBER(4) := 0;
   PAP    NUMBER(4) := 0;
   CTA    NUMBER(9) := 0;
   OPER   NUMBER(9) := 0;
   SBOP   NUMBER(3) := 0;
   TOPE   NUMBER(3) := 0;
   INST   NUMBER(10) := 0;
   SDODEU NUMBER(17, 2) := 0;
   CARGO  NUMBER(3) := 0;
   MNTOD  NUMBER(17, 2) := 0;
   MNTOSG NUMBER(17, 2) := 0;
   CUODES NUMBER(17, 2) := 0;
   CONT   NUMBER(5) := 0;
   CUOTAS NUMBER(5) := 0;
   ASESOR VARCHAR2(10) := ' ';
   NOMCRG VARCHAR2(30) := ' ';
   DNI    VARCHAR2(12) := ' ';
   NOMCLI VARCHAR2(35) := ' ';
   PAGADA VARCHAR2(1) := ' ';
   FLGPAG VARCHAR2(1) := ' ';
   EXISTE VARCHAR2(1) := ' ';
   ESTADO VARCHAR2(15) := ' ';
   FVAL   DATE;
   FPAG   DATE;
   FAPER  DATE;
   TYPE ARRAY1 IS VARRAY(100) OF DATE;
   TYPE ARRAY2 IS VARRAY(100) OF VARCHAR2(1);
   TYPE ARRAY3 IS VARRAY(100) OF NUMBER(17, 2);
   VFCHPAG ARRAY1 := ARRAY1();
   VPAGO   ARRAY2 := ARRAY2();
   VCUODES ARRAY3 := ARRAY3();
   CURSOR LST1 IS
      SELECT TP1NRO1, TP1NRO2
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11165
         AND TP1CORR1 = 0
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0;
   CURSOR LST2 IS
      SELECT *
        FROM FSD010
       WHERE PGCOD = 1
         AND AOMOD = MODULO
         AND AOTOPE = TOPE
         AND AOSTAT <> 99;
   CURSOR LST3 IS
      SELECT *
        FROM FSD601
       WHERE PGCOD = PGCOD
         AND PPMOD = MODULO
         AND PPSUC = SUC
         AND PPMDA = MDA
         AND PPPAP = PAP
         AND PPCTA = CTA
         AND PPOPER = OPER
         AND PPSBOP = SBOP
         AND PPTOPE = TOPE;
   CURSOR LST4 IS
      SELECT *
        FROM FSD601
       WHERE PGCOD = PGCOD
         AND PPMOD = MODULO
         AND PPSUC = SUC
         AND PPMDA = MDA
         AND PPPAP = PAP
         AND PPCTA = CTA
         AND PPOPER = OPER
         AND PPSBOP = SBOP
         AND PPTOPE = TOPE
         AND PPFPAG BETWEEN pFCHINI AND pFCHFIN;
BEGIN
   BEGIN
      DELETE FROM AQPC278;
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   BEGIN
      SELECT PGFAPE INTO FAPER FROM FST017 WHERE PGCOD = 1;
   EXCEPTION
      WHEN OTHERS THEN
         FAPER := NULL;
   END;
   FOR X IN LST1 LOOP
      MODULO := 0;
      TOPE   := 0;
   
      MODULO := X.TP1NRO1;
      TOPE   := X.TP1NRO2;
      FOR I IN LST2 LOOP
         PGCOD  := 0;
         SUC    := 0;
         MODULO := 0;
         MDA    := 0;
         PAP    := 0;
         CTA    := 0;
         OPER   := 0;
         SBOP   := 0;
         TOPE   := 0;
         MNTOD  := 0;
         INST   := 0;
         CARGO  := 0;
         MNTOD  := 0;
         ASESOR := ' ';
         NOMCRG := ' ';
         DNI    := ' ';
         NOMCLI := ' ';
         FVAL   := NULL;
      
         PGCOD  := I.PGCOD;
         SUC    := I.AOSUC;
         MODULO := I.AOMOD;
         MDA    := I.AOMDA;
         PAP    := I.AOPAP;
         CTA    := I.AOCTA;
         OPER   := I.AOOPER;
         SBOP   := I.AOSBOP;
         TOPE   := I.AOTOPE;
         FVAL   := I.AOFVAL;
         MNTOD  := I.AOIMP;
         BEGIN
            SELECT XWFPRCINS
              INTO INST
              FROM XWF700
             WHERE XWFEMPRESA = PGCOD
               AND XWFSUCURSAL = SUC
               AND XWFMODULO = MODULO
               AND XWFMONEDA = MDA
               AND XWFPAPEL = PAP
               AND XWFCUENTA = CTA
               AND XWFOPERACION = OPER
               AND XWFSUBOPE = SBOP
               AND XWFTIPOPE = TOPE
               AND XWFCAR3 = '1';
            BEGIN
               SELECT SNG001ASE
                 INTO ASESOR
                 FROM SNG001
                WHERE SNG001INST = INST;
               BEGIN
                  SELECT SNG055CAR
                    INTO CARGO
                    FROM SNG057
                   WHERE SNG055EMP = PGCOD
                     AND SNG057USR = ASESOR;
                  BEGIN
                     SELECT TRIM(SNG055DSC)
                       INTO NOMCRG
                       FROM SNG055
                      WHERE SNG055EMP = PGCOD
                        AND SNG055CAR = CARGO;
                  EXCEPTION
                     WHEN OTHERS THEN
                        NOMCRG := ' ';
                  END;
               EXCEPTION
                  WHEN OTHERS THEN
                     CARGO := 0;
               END;
            EXCEPTION
               WHEN OTHERS THEN
                  ASESOR := ' ';
            END;
         EXCEPTION
            WHEN OTHERS THEN
               INST := 0;
         END;
         BEGIN
            SELECT TRIM(PENDOC)
              INTO DNI
              FROM FSR008
             WHERE PGCOD = PGCOD
               AND CTNRO = CTA
               AND CTTFIR = 'T';
         EXCEPTION
            WHEN OTHERS THEN
               DNI := ' ';
         END;
         BEGIN
            SELECT TRIM(CTNOM)
              INTO NOMCLI
              FROM FSD008
             WHERE PGCOD = PGCOD
               AND CTNRO = CTA;
         EXCEPTION
            WHEN OTHERS THEN
               NOMCLI := ' ';
         END;
         BEGIN
            SELECT SCSDO
              INTO SDODEU
              FROM FSD011
             WHERE PGCOD = PGCOD
               AND SCMOD = MODULO
               AND SCMDA = MDA
               AND SCPAP = PAP
               AND SCCTA = CTA
               AND SCSUC = SUC
               AND SCOPER = OPER
               AND SCSBOP = SBOP
               AND SCTOPE = TOPE;
         EXCEPTION
            WHEN OTHERS THEN
               SDODEU := 0;
         END;
         IF SDODEU < 0 THEN
            SDODEU := SDODEU * -1;
         END IF;
         IF (pFCHINI = TO_DATE('1/01/0001', 'DD/MM/YY') AND
            pFCHFIN = TO_DATE('1/01/0001', 'DD/MM/YY')) OR
            (pFCHINI IS NULL AND pFCHFIN IS NULL) THEN
            VFCHPAG := ARRAY1();
            VPAGO   := ARRAY2();
            VCUODES := ARRAY3();
            CONT    := 0;
            EXISTE  := 'N';
            CUODES  := 0;
            FOR J IN LST3 LOOP
               VFCHPAG.EXTEND;
               VPAGO.EXTEND;
               VCUODES.EXTEND;
               CONT   := CONT + 1;
               EXISTE := 'S';
               BEGIN
                  SELECT 'S'
                    INTO PAGADA
                    FROM FSD602
                   WHERE PGCOD = J.PGCOD
                     AND PPMOD = J.PPMOD
                     AND PPSUC = J.PPSUC
                     AND PPMDA = J.PPMDA
                     AND PPPAP = J.PPPAP
                     AND PPCTA = J.PPCTA
                     AND PPOPER = J.PPOPER
                     AND PPSBOP = J.PPSBOP
                     AND PPTOPE = J.PPTOPE
                     AND PPFPAG = J.PPFPAG
                     AND PP1STAT = 'T'
                     AND D602CO = 'S';
               EXCEPTION
                  WHEN OTHERS THEN
                     PAGADA := 'N';
               END;
               IF PAGADA = 'N' THEN
                  BEGIN
                     SELECT (PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                            PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 +
                            PPIMP19 + PPIMP20)
                       INTO MNTOSG
                       FROM FSD611
                      WHERE PGCOD = J.PGCOD
                        AND PPMOD = J.PPMOD
                        AND PPSUC = J.PPSUC
                        AND PPMDA = J.PPMDA
                        AND PPPAP = J.PPPAP
                        AND PPCTA = J.PPCTA
                        AND PPOPER = J.PPOPER
                        AND PPSBOP = J.PPSBOP
                        AND PPTOPE = J.PPTOPE
                        AND PPFPAG = J.PPFPAG;
                  EXCEPTION
                     WHEN OTHERS THEN
                        MNTOSG := 0;
                  END;
                  IF J.PPFPAG < FAPER THEN
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := PAGADA;
                     VCUODES(CONT) := (J.PPCAP + J.PPINT + MNTOSG) +
                                      TRUNC((J.PPCAP + J.PPINT + MNTOSG) / 1000) * 0.05;
                  ELSE
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := 'X';
                     VCUODES(CONT) := (J.PPCAP + J.PPINT + MNTOSG) +
                                      TRUNC((J.PPCAP + J.PPINT + MNTOSG) / 1000) * 0.05;
                  END IF;
               ELSE
                  IF PAGADA = 'S' THEN
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := PAGADA;
                     VCUODES(CONT) := 0;
                  END IF;
               END IF;
            END LOOP;
            IF EXISTE = 'S' THEN
               FPAG   := NULL;
               CUOTAS := 0;
               ESTADO := ' ';
               FOR I IN 1 .. CONT LOOP
                  IF VPAGO(I) = 'N' THEN
                     FPAG   := VFCHPAG(I);
                     ESTADO := 'VENCIDA';
                     CUODES := VCUODES(I);
                     CUOTAS := I;
                     EXIT;
                  ELSE
                     IF VPAGO(I) = 'X' THEN
                        FPAG   := VFCHPAG(I);
                        ESTADO := 'PENDIENTE';
                        CUODES := VCUODES(I);
                        CUOTAS := I;
                        EXIT;
                     END IF;
                  END IF;
               END LOOP;
               BEGIN
                  INSERT INTO AQPC278
                  VALUES
                     (INST, PGCOD, SUC, MODULO, MDA, PAP, CTA, OPER, SBOP, TOPE, DNI, NOMCRG, NOMCLI, FVAL,
                      MNTOD, SDODEU, CUODES, FPAG, CUOTAS, ESTADO);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         ELSE
            VFCHPAG := ARRAY1();
            VPAGO   := ARRAY2();
            VCUODES := ARRAY3();
            CONT    := 0;
            EXISTE  := 'N';
            CUODES  := 0;
            FOR J IN LST4 LOOP
               VFCHPAG.EXTEND;
               VPAGO.EXTEND;
               VCUODES.EXTEND;
               CONT   := CONT + 1;
               EXISTE := 'S';
               BEGIN
                  SELECT 'S'
                    INTO PAGADA
                    FROM FSD602
                   WHERE PGCOD = J.PGCOD
                     AND PPMOD = J.PPMOD
                     AND PPSUC = J.PPSUC
                     AND PPMDA = J.PPMDA
                     AND PPPAP = J.PPPAP
                     AND PPCTA = J.PPCTA
                     AND PPOPER = J.PPOPER
                     AND PPSBOP = J.PPSBOP
                     AND PPTOPE = J.PPTOPE
                     AND PPFPAG = J.PPFPAG
                     AND PP1STAT = 'T'
                     AND D602CO = 'S';
               EXCEPTION
                  WHEN OTHERS THEN
                     PAGADA := 'N';
               END;
               IF PAGADA = 'N' THEN
                  BEGIN
                     SELECT (PPIMP11 + PPIMP12 + PPIMP13 + PPIMP14 +
                            PPIMP15 + PPIMP16 + PPIMP17 + PPIMP18 +
                            PPIMP19 + PPIMP20)
                       INTO MNTOSG
                       FROM FSD611
                      WHERE PGCOD = J.PGCOD
                        AND PPMOD = J.PPMOD
                        AND PPSUC = J.PPSUC
                        AND PPMDA = J.PPMDA
                        AND PPPAP = J.PPPAP
                        AND PPCTA = J.PPCTA
                        AND PPOPER = J.PPOPER
                        AND PPSBOP = J.PPSBOP
                        AND PPTOPE = J.PPTOPE
                        AND PPFPAG = J.PPFPAG;
                  EXCEPTION
                     WHEN OTHERS THEN
                        MNTOSG := 0;
                  END;
                  IF J.PPFPAG < FAPER THEN
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := PAGADA;
                     VCUODES(CONT) := (J.PPCAP + J.PPINT + MNTOSG) +
                                      TRUNC((J.PPCAP + J.PPINT + MNTOSG) / 1000) * 0.05;
                     EXIT;
                  ELSE
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := 'X';
                     VCUODES(CONT) := (J.PPCAP + J.PPINT + MNTOSG) +
                                      TRUNC((J.PPCAP + J.PPINT + MNTOSG) / 1000) * 0.05;
                  END IF;
               ELSE
                  IF PAGADA = 'S' THEN
                     VFCHPAG(CONT) := J.PPFPAG;
                     VPAGO(CONT) := PAGADA;
                     VCUODES(CONT) := 0;
                  END IF;
               END IF;
            END LOOP;
            IF EXISTE = 'S' THEN
               FPAG   := NULL;
               FLGPAG := ' ';
               CUOTAS := 0;
               FOR I IN 1 .. CONT LOOP
                  IF VFCHPAG(I) >= pFCHINI AND VFCHPAG(I) <= pFCHFIN THEN
                     CASE
                        WHEN VPAGO(I) = 'S' THEN
                           FPAG   := VFCHPAG(I);
                           CUODES := VCUODES(I);
                           ESTADO := 'PAGADA';
                           CUOTAS := I;
                           EXIT;
                        WHEN VPAGO(I) = 'N' THEN
                           FPAG   := VFCHPAG(I);
                           CUODES := VCUODES(I);
                           ESTADO := 'VENCIDA';
                           CUOTAS := I;
                           EXIT;
                        WHEN VPAGO(I) = 'X' THEN
                           FPAG   := VFCHPAG(I);
                           CUODES := VCUODES(I);
                           ESTADO := 'PENDIENTE';
                           CUOTAS := I;
                           EXIT;
                        ELSE NULL;
                     END CASE;
                  END IF;
               END LOOP;
               BEGIN
                  INSERT INTO AQPC278
                  VALUES
                     (INST, PGCOD, SUC, MODULO, MDA, PAP, CTA, OPER, SBOP, TOPE, DNI, NOMCRG, NOMCLI, FVAL,
                      MNTOD, SDODEU, CUODES, FPAG, CUOTAS, ESTADO);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         END IF;
      END LOOP;
   END LOOP;
END SP_CR_GENERA_REPORTE_MOTOS;
/

