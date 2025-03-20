CREATE OR REPLACE PROCEDURE SP_CR_REPORTE_FOCMA(P_FECHA_FILTRO IN DATE,
                                                P_FECHA        IN DATE,
                                                P_HORA         IN VARCHAR2,
                                                P_USUARIO      IN VARCHAR2) IS

   -- *****************************************************************
   -- NOMBRE                      : SP_CR_REPORTE_FOCMA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 02/05/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERAR REPORTE DE SALDOS ACTUALIZADOS FOCMA
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   V_EXISTE_PAGO  VARCHAR2(1);
   V_CAPITAL      NUMBER(17, 2);
   V_INTERES      NUMBER(17, 2);
   V_MORA         NUMBER(17, 2);
   V_ICV          NUMBER(17, 2);
   V_SEGURO       NUMBER(17, 2);
   V_PENALIDAD    NUMBER(17, 2);
   V_OTROS_RUBROS NUMBER(17, 2);
   V_TOTAL_DEUDA  NUMBER(17, 2);
   V_NOM_CLI      VARCHAR2(100);
   V_PAIS         NUMBER(3);
   V_TPDOC        NUMBER(2);
   V_NDOC         VARCHAR2(12);
   V_NOM_TPDOC    VARCHAR2(20);
   V_MDA_SIGNO    VARCHAR2(4);

   CURSOR CURSOR_1 IS
      SELECT C.JAQY952GRU, D.*
        FROM FST198 A, JAQY470F B, JAQY952 C, JAQY953 D
       WHERE A.TP1COD         = 1
         AND A.TP1COD1        = 10897
         AND A.TP1CORR1       = 12
         AND A.TP1CORR2       = 12
         AND B.JAQY470FCODADQ = A.TP1CORR3
         AND C.JAQY952GRU     = B.JAQY470FCODTRA
         AND D.JAQY952NRO     = C.JAQY952NRO
         AND C.JAQY952EST     = 'V'
         AND C.JAQY952FEV    <= P_FECHA_FILTRO;
BEGIN
   BEGIN
      DELETE FROM AQPC296 WHERE AQPC296UPRC = P_USUARIO;
      COMMIT;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   FOR X IN CURSOR_1 LOOP
      V_CAPITAL      := 0;
      V_INTERES      := 0;
      V_MORA         := 0;
      V_ICV          := 0;
      V_SEGURO       := 0;
      V_PENALIDAD    := 0;
      V_OTROS_RUBROS := 0;
      V_TOTAL_DEUDA  := 0;
      BEGIN
         SELECT 'S',
                ABS((AQPC423CAPD - (AQPC423CAPP + AQPC423CAPC))),
                ABS((AQPC423INTD - (AQPC423INTP + AQPC423INTC))),
                ABS((AQPC423MORD - (AQPC423MORP + AQPC423MORC))),
                ABS((AQPC423ICVD - (AQPC423ICVP + AQPC423ICVC))),
                ABS((AQPC423SEGD - (AQPC423SEGP + AQPC423SEGC))),
                ABS((AQPC423PEND - (AQPC423PENP + AQPC423PENC))),
                ABS((AQPC423OROD - (AQPC423OROP + AQPC423OROC)))
           INTO V_EXISTE_PAGO, V_CAPITAL, V_INTERES, V_MORA, V_ICV,
                V_SEGURO, V_PENALIDAD, V_OTROS_RUBROS
           FROM AQPC423
          WHERE AQPC423CTA = X.JAQY953CTA
            AND AQPC423OPE = X.JAQY953OPE
            AND AQPC423MDA = X.JAQY953MDA
            AND AQPC423EST = 'C'
            AND AQPC423ITFCON =
                (SELECT MAX(AQPC423ITFCON)
                   FROM AQPC423
                  WHERE AQPC423CTA = X.JAQY953CTA
                    AND AQPC423OPE = X.JAQY953OPE
                    AND AQPC423MDA = X.JAQY953MDA
                    AND AQPC423EST = 'C'
                    AND AQPC423ITFCON <= P_FECHA_FILTRO)
            AND AQPC423ITHORA =
                (SELECT MAX(AQPC423ITHORA)
                   FROM AQPC423
                  WHERE AQPC423CTA = X.JAQY953CTA
                    AND AQPC423OPE = X.JAQY953OPE
                    AND AQPC423MDA = X.JAQY953MDA
                    AND AQPC423EST = 'C'
                    AND AQPC423ITFCON =
                        (SELECT MAX(AQPC423ITFCON)
                           FROM AQPC423
                          WHERE AQPC423CTA = X.JAQY953CTA
                            AND AQPC423OPE = X.JAQY953OPE
                            AND AQPC423MDA = X.JAQY953MDA
                            AND AQPC423EST = 'C'
                            AND AQPC423ITFCON <= P_FECHA_FILTRO));
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_EXISTE_PAGO := 'N';
         WHEN OTHERS THEN
            V_EXISTE_PAGO := NULL;
      END;
      BEGIN
         SELECT TRIM(CTNOM)
           INTO V_NOM_CLI
           FROM FSD008
          WHERE PGCOD = 1
            AND CTNRO = X.JAQY953CTA;
      EXCEPTION
         WHEN OTHERS THEN
            V_NOM_CLI := NULL;
      END;
      
      BEGIN
         SELECT PEPAIS, PETDOC, TRIM(PENDOC)
           INTO V_PAIS, V_TPDOC, V_NDOC
           FROM FSR008
          WHERE PGCOD  = 1
            AND CTNRO  = X.JAQY953CTA
            AND CTTFIR = 'T';
      EXCEPTION
         WHEN OTHERS THEN
            V_TPDOC := NULL;
            V_NDOC  := NULL;
      END;
      BEGIN
         SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                 TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
           INTO V_NOM_CLI
           FROM FSD002
          WHERE PFPAIS = V_PAIS
            AND PFTDOC = V_TPDOC
            AND PFNDOC = RPAD(V_NDOC, 12, ' ');
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT TRIM(PJRAZS)
                 INTO V_NOM_CLI
                 FROM FSD003
                WHERE PJPAIS = V_PAIS
                  AND PJTDOC = V_TPDOC
                  AND PJNDOC = RPAD(V_NDOC, 12, ' ');
            EXCEPTION
               WHEN OTHERS THEN
                  V_NOM_CLI := NULL;
            END;
         WHEN OTHERS THEN
            V_NOM_CLI := NULL;
      END;
      BEGIN
         SELECT TRIM(TDNOM)
           INTO V_NOM_TPDOC
           FROM FST014
          WHERE TDOCUM = V_TPDOC;
      EXCEPTION
         WHEN OTHERS THEN
            V_NOM_TPDOC := NULL;
      END;    
      BEGIN
         SELECT TRIM(MOSIGN)
           INTO V_MDA_SIGNO
           FROM FST005
          WHERE MONEDA = X.JAQY953MDA;
      EXCEPTION
         WHEN OTHERS THEN
            V_MDA_SIGNO := NULL;
      END;  
      IF V_EXISTE_PAGO = 'N' THEN
         V_CAPITAL      := X.JAQY953CAV;
         V_INTERES      := X.JAQY953INV;
         V_MORA         := X.JAQY953MOV;
         V_ICV          := X.JAQY953ICVV;
         V_SEGURO       := X.JAQY953SEGV;
         V_PENALIDAD    := X.JAQY953PENV;
         V_OTROS_RUBROS := X.JAQY953OROV;
      END IF;
      V_TOTAL_DEUDA := (V_CAPITAL + V_INTERES + V_MORA + V_ICV +
                        V_SEGURO + V_PENALIDAD + V_OTROS_RUBROS);
      
      BEGIN
         INSERT INTO AQPC296
            (AQPC296UPRC,
             AQPC296FPRC,
             AQPC296HPRC,
             AQPC296GRPVNT,
             AQPC296CTA,
             AQPC296OPE,
             AQPC296NMCLI,
             AQPC296TDOC,
             AQPC296NDOC,
             AQPC296MDA,
             AQPC296CAP,
             AQPC296INT,
             AQPC296MOR,
             AQPC296ICV,
             AQPC296SEG,
             AQPC296PEN,
             AQPC296RUB,
             AQPC296TOTD,
             AQPC296FCH)
         VALUES
            (P_USUARIO,
             P_FECHA,
             P_HORA,
             X.JAQY952GRU,
             X.JAQY953CTA,
             X.JAQY953OPE,
             V_NOM_CLI,
             V_NOM_TPDOC,
             V_NDOC,
             V_MDA_SIGNO,
             V_CAPITAL,
             V_INTERES,
             V_MORA,
             V_ICV,
             V_SEGURO,
             V_PENALIDAD,
             V_OTROS_RUBROS,
             V_TOTAL_DEUDA,
             P_FECHA_FILTRO);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END SP_CR_REPORTE_FOCMA;
/

