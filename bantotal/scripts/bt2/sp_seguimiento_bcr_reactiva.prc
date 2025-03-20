CREATE OR REPLACE PROCEDURE SP_SEGUIMIENTO_BCR_REACTIVA(
FECHAHOY IN DATE,
FECHAAYER IN DATE,
TIMETOTAL OUT VARCHAR2
)
IS

v_d1 TIMESTAMP ;
v_d2 TIMESTAMP ;
v_n  INTERVAL DAY TO SECOND ;
tiempo VARCHAR2(255) := '';
FECHAINGRESO DATE;
-- *****************************************************************
   -- Nombre                     : SP_SEGUIMIENTO_BCR_REACTIVA
   -- Sistema                    : BANTOTAL
   -- Módulo                     : Créditos - Activas- Módulo de BCR Reactiva
   -- Versión                    : 1.3
   -- Fecha de Creación          : 2023
   -- Autor de Creación          : DLYA Richard - lo pasó Karen
   -- Uso                        : 
   -- Estado                     : Activo
   -- Acceso                     : Público
   -- Parámetros de Entrada      : 
   --
   -- Retorno                    : 
   -- Fecha de Modificación      : 24/11/2023
   -- Autor de la Modificación   : DLYA Richard Ojeda
   -- Descripción de Modificación: Módulo de Reactiva BCR
   --
   -- Retorno                    : 
   -- Fecha de Modificación      : 05/04/2024
   -- Autor de la Modificación   : DLYA Julio Vicente
   -- Descripción de Modificación: Módulo de Reactiva BCR
   --
   -- Retorno                    : 
   -- Fecha de Modificación      : 09/04/2024
   -- Autor de la Modificación   : DLYA Julio Vicente
   -- Descripción de Modificación: Nueva forma de obtención de la tasa actual
   --
   -- Retorno                    : 
   -- Fecha de Modificación      : 17/04/2024
   -- Autor de la Modificación   : DLYA Julio Vicente
   -- Descripción de Modificación: Modificación a tablas a Bantotal
   --
   -- Retorno                    : 
   -- Fecha de Modificación      : 26/07/2024
   -- Autor de la Modificación   : DLYA Julio Vicente
   -- Descripción de Modificación: Optimziación de SP 
-- *****************************************************************
BEGIN
   v_d1 := SYSTIMESTAMP ;

   IF FECHAHOY IS  NULL AND FECHAAYER IS NULL THEN
      --FECHAINGRESO := TO_DATE('12-AUG-20', 'dd-mm-yy'); 
      FECHAINGRESO :=TRUNC(SYSDATE-1);
   ELSE
      FECHAINGRESO:=FECHAAYER;
   END IF;

   DBMS_OUTPUT.PUT_LINE ('ingresa: '||v_d1||' FECHA INGRESO '||FECHAINGRESO ||' FECHA AYER '|| FECHAAYER);

   /*JAQNS1*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS1;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS1';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS1 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS1(JAQNS1EMPR,JAQNS1SUCU,JAQNS1RUBR,JAQNS1MONE,JAQNS1PAPE,JAQNS1CUEN,JAQNS1OPER,JAQNS1SBOP,JAQNS1TOPE,JAQNS1FECH,JAQNS1TITU,JAQNS1CAPI,JAQNS1PLZO,JAQNS1SIST,JAQNS1MODU,JAQNS1FVTO,JAQNS1FVAL,JAQNS1PLAZ,JAQNS1TTAS,JAQNS1TASA,JAQNS1CLTA,JAQNS1TDIA,JAQNS1TANO,JAQNS1RESI,JAQNS1CATE,JAQNS1ACTI,JAQNS1PROD,JAQNS1TICU,JAQNS1TIPP,JAQNS1FATR,JAQNS1SDOR,JAQNS1SDMN,JAQNS1SDUS,JAQNS1SDMO,JAQNS1INTE,JAQNS1PREV,JAQNS1GCUE)
   SELECT T.BCEMP,T.BCSUC,T.BCRUBR,T.BCMDA,T.BCPAP,T.BCCTA,T.BCOPER,T.BCSBOP,T.BCTOP,T.BCFECH,T.BCTIT,T.BCCAP,T.BCPZO,T.BCSIST,T.BCMOD,T.BCFVTO,T.BCFVAL,T.BCPLAZ,T.BCTTASA,T.BCTASA,T.BCCLTA,T.BCTDIA,T.BCTANO,T.BCRESI,T.BCCATE,T.BCACTI,T.BCPROD,T.BCTICU,T.BCTIPP,T.BCFATR,T.BCSDOR,T.BCSDMN,T.BCSDUS,T.BCSDMO,T.BCINT,T.BCPREV,T.BCGPO
   FROM FSH012 T
   WHERE T.BCEMP = 1
   AND T.BCFECH = FECHAINGRESO
   AND T.BCPROD <> 99
   AND T.BCMOD = 70
   AND (T.BCRUBR LIKE '84_4%' OR T.BCRUBR = '9999999990080');
   /*JAQNS1 - FIN*/


   /*JAQNS2*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS2;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS2';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS2 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS2(JAQNS2EMPR,JAQNS2SUCU,JAQNS2RUBR,JAQNS2MONE,JAQNS2PAPE,JAQNS2CUEN,JAQNS2OPER,JAQNS2SBOP,JAQNS2TOPE,JAQNS2FECH,JAQNS2TITU,JAQNS2CAPI,JAQNS2PLZO,JAQNS2SIST,JAQNS2MODU,JAQNS2FVTO,JAQNS2FVAL,JAQNS2PLAZ,JAQNS2TTAS,JAQNS2TASA,JAQNS2CLTA,JAQNS2TDIA,JAQNS2TANO,JAQNS2RESI,JAQNS2CATE,JAQNS2ACTI,JAQNS2PROD,JAQNS2TICU,JAQNS2TIPP,JAQNS2FATR,JAQNS2SDOR,JAQNS2SDMN,JAQNS2SDUS,JAQNS2SDMO,JAQNS2INTE,JAQNS2PREV,JAQNS2GCUE,JAQNS2ROID)
   SELECT F.BCEMP,F.BCSUC,F.BCRUBR,F.BCMDA,F.BCPAP,F.BCCTA,F.BCOPER,F.BCSBOP,F.BCTOP,F.BCFECH,F.BCTIT,F.BCCAP,F.BCPZO,F.BCSIST,F.BCMOD,F.BCFVTO,F.BCFVAL,F.BCPLAZ,F.BCTTASA,F.BCTASA,F.BCCLTA,F.BCTDIA,F.BCTANO,F.BCRESI,F.BCCATE,F.BCACTI,F.BCPROD,F.BCTICU,F.BCTIPP,F.BCFATR,F.BCSDOR,F.BCSDMN,F.BCSDUS,F.BCSDMO,F.BCINT,F.BCPREV,F.BCGPO,F.ROWID
   FROM FSH012 F
   WHERE REGEXP_LIKE(F.BCRUBR,'^14.[1-6]')
   AND F.BCPROD <> 99
   AND F.BCFECH =FECHAINGRESO;
   /*JAQNS2 - FIN*/

   /*JAQNS3*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS3;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS3';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS3 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS3(JAQNS3EMPR,JAQNS3SUCU,JAQNS3MONE,JAQNS3PAPE,JAQNS3CUEN,JAQNS3OPER,JAQNS3SBOP,JAQNS3TOPE,JAQNS3MODU,JAQNS3SDMN,JAQNS3ROID)
   SELECT H.JAQNS2EMPR,H.JAQNS2SUCU,H.JAQNS2MONE,H.JAQNS2PAPE,H.JAQNS2CUEN,H.JAQNS2OPER,H.JAQNS2SBOP,H.JAQNS2TOPE,H.JAQNS2MODU,SUM(-H.JAQNS2SDMN),MAX(H.JAQNS2ROID) 
   FROM JAQNS2 H
   GROUP BY H.JAQNS2EMPR,
            H.JAQNS2SUCU,
            H.JAQNS2MONE,
            H.JAQNS2PAPE,
            H.JAQNS2CUEN,
            H.JAQNS2OPER,
            H.JAQNS2SBOP,
            H.JAQNS2TOPE,
            H.JAQNS2MODU; 

   /*JAQNS3 - FIN*/              


   /*JAQNS4*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS4;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS4';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS4 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS4 (JAQNS4EMPR,JAQNS4SUCU,JAQNS4MONE,JAQNS4PAPE,JAQNS4CUEN,JAQNS4OPER,JAQNS4SBOP,JAQNS4TOPE,JAQNS4MODU,JAQNS4RCOD,JAQNS4R2MD,JAQNS4R2CT,JAQNS4R2OP,JAQNS4R2SB,JAQNS4FECH,JAQNS4RUBR,JAQNS4SDMN,JAQNS4ROID,JAQNS4CGAR,JAQNS4TGAR)
   SELECT 
      T.JAQNS3EMPR,T.JAQNS3SUCU,T.JAQNS3MONE,T.JAQNS3PAPE,T.JAQNS3CUEN,T.JAQNS3OPER,T.JAQNS3SBOP,T.JAQNS3TOPE,T.JAQNS3MODU,
      R.RELCOD,R.R2MOD,R.R2CTA,R.R2OPER,R.R2SBOP,
      H.JAQNS1FECH,H.JAQNS1RUBR,
      T.JAQNS3SDMN, T.JAQNS3ROID,
      H.JAQNS1CUEN||'-'||H.JAQNS1OPER||'-'||H.JAQNS1SBOP||'-'||H.JAQNS1TOPE,
      PQ_BI_PAR.CRE_FN_TIP_OPERACION(H.JAQNS1MODU,H.JAQNS1TOPE)
   FROM JAQNS3 T
   JOIN FSR011 R
      ON R.R1COD  = T.JAQNS3EMPR
      AND R.R1MOD  = T.JAQNS3MODU
      AND R.R1CTA  = T.JAQNS3CUEN
      AND R.R1OPER = T.JAQNS3OPER
      AND R.R1SBOP = T.JAQNS3SBOP
      AND R.R2MOD  = 70
      AND R.RELCOD = 50
      AND R.R011CO = 'S'
   JOIN JAQNS1 H
      ON H.JAQNS1EMPR  = R.R2COD
      AND H.JAQNS1CUEN  = R.R2CTA
      AND H.JAQNS1OPER = R.R2OPER
      AND H.JAQNS1SBOP = R.R2SBOP
      AND H.JAQNS1MODU  = R.R2MOD; 
   /*JAQNS4 - FIN*/




/*    lv_create_table_tem_tot:= 'CREATE TABLE TMP_GAR_TOT_0 PARALLEL(DEGREE 4) COMPRESS AS
                              SELECT 
                                     T.*,
                                     H.BCCTA||''-''||H.BCOPER||''-''||H.BCSBOP||''-''||H.BCTOP CODIGO_GRNT,
                                     PQ_BI_PAR.CRE_FN_TIP_OPERACION(H.BCMOD,H.BCTOP) TIPO_GARANTIA
                                FROM TMP_CART_AYER T
                                JOIN FSR011 R
                                  ON R.R1COD  = T.BCEMP
                                 AND R.R1MOD  = T.BCMOD
                                 AND R.R1CTA  = T.BCCTA
                                 AND R.R1OPER = T.BCOPER
                                 AND R.R1SBOP = T.BCSBOP
                                 AND R.R2MOD  = 70
                                 AND R.RELCOD = 50
                                 AND R.R011CO = ''S''
                                JOIN FSH012_GAR_TOT H
                                  ON H.BCEMP  = R.R2COD
                                 AND H.BCCTA  = R.R2CTA
                                 AND H.BCOPER = R.R2OPER
                                 AND H.BCSBOP = R.R2SBOP
                                 AND H.BCMOD  = R.R2MOD'; 
    */       

   /*JAQNS5*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS5;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS5';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS5 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS5 (JAQNS5SUCU,JAQNS5SUNO,JAQNS5DIRE)
   SELECT   RS.SUCURS, 
            UPPER(RS.SCNOM) SCNOM, 
            TRIM(RS.DPTO)||','||TRIM(RS.PROV)||','||TRIM(DIST)||','||(SELECT UPPER(TRIM(S.SCCALL))FROM FST001 S WHERE S.SUCURS = RS.SUCURS) DIR 
   FROM REGSUC RS WHERE SUCURS <800; 

   /*JAQNS5 - FIN*/

   /*JAQNS6*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS6;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS6';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS6 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS6 (JAQNS6PAIS, JAQNS6TDOC, JAQNS6NDOC, JAQNS6EMPR, JAQNS6MODU, JAQNS6SUCU, JAQNS6PAPE, JAQNS6MONE, JAQNS6CUEN, JAQNS6OPER, JAQNS6SBOP, JAQNS6TOPE, JAQNS6IMPO,JAQNS6SDMN, JAQNS6FVAL, JAQNS6FVTO, JAQNS6TASA, JAQNS6TACT, JAQNS6PERI, JAQNS6FPAG, JAQNS6ESPE, JAQNS6GENE, JAQNS6LAGE)
   SELECT 
      R8.PEPAIS,
      R8.PETDOC,
      R8.PENDOC,
      D10.PGCOD,
      D10.AOMOD,
      D10.AOSUC,
      D10.AOPAP,
      D10.AOMDA,
      D10.AOCTA,
      D10.AOOPER,
      D10.AOSBOP,                               
      D10.AOTOPE, 
      D10.AOIMP,
     (SELECT 
         SUM(H12.JAQNS2SDMN) 
      FROM JAQNS2 H12
      WHERE H12.JAQNS2EMPR= D10.PGCOD 
      --AND H12.JAQNS2SUCU= D10.AOSUC 
      AND H12.JAQNS2MONE= D10.AOMDA 
      AND H12.JAQNS2PAPE= D10.AOPAP 
      AND H12.JAQNS2CUEN= D10.AOCTA 
      AND H12.JAQNS2OPER= D10.AOOPER
      AND H12.JAQNS2SBOP= D10.AOSBOP
      AND H12.JAQNS2TOPE= D10.AOTOPE
      AND H12.JAQNS2FECH= FECHAINGRESO
      --AND REGEXP_LIKE(H12.JAQNS2RUBR,'^14.[1-6]')      AND H12.JAQNS2PROD<>99
      ) SALCAPMN,
      D10.AOFVAL FECDES, 
      D10.AOFVTO FECVTO,
      D10.AOTASA TASAORI,
      /*(SELECT 
         H12.BCTasa
      FROM FSH012 H12
      WHERE H12.BCEMP = D10.PGCOD 
      --AND H12.BCSUC = D10.AOSUC 
      AND H12.BCMDA = D10.AOMDA 
      AND H12.BCPAP = D10.AOPAP 
      AND H12.BCCTA = D10.AOCTA 
      AND H12.BCOPER= D10.AOOPER
      AND H12.BCSBOP= D10.AOSBOP
      AND H12.BCTOP = D10.AOTOPE
      AND H12.BCFECH= FECHAINGRESO
      AND REGEXP_LIKE(H12.BCRUBR,'^14.[1-6]')
      AND H12.BCPROD<>99) TASAACT,*/
      NVL((SELECT Evtasa  FROM FSD012 F12
            WHERE F12.PGCOD =D10.PGCOD
            AND F12.AOMOD =D10.AOMOD
            AND F12.AOSUC =D10.AOSUC
            AND F12.AOMDA =D10.AOMDA
            AND F12.AOPAP =D10.AOPAP
            AND F12.AOCTA =D10.AOCTA
            AND F12.AOOPER=D10.AOOPER
            AND F12.AOSBOP=D10.AOSBOP
            AND F12.AOTOPE=D10.AOTOPE
            AND F12.Evtipo = 3
            AND F12.D012CO = 'S' ORDER BY EVCORR DESC
FETCH FIRST 1 ROW ONLY )                                      
         ,D10.Aotasa)  TASAACT, 
      D10.AOPERIOD FRECUENCIA,
      (SELECT
         MIN(D.PPFPAG)
      FROM FSD601 D
      WHERE D.PGCOD =D10.PGCOD
      AND D.PPMOD =D10.AOMOD
      AND D.PPSUC =D10.AOSUC
      AND D.PPMDA =D10.AOMDA
      AND D.PPPAP =D10.AOPAP
      AND D.PPCTA =D10.AOCTA
      AND D.PPOPER=D10.AOOPER
      AND D.PPSBOP=D10.AOSBOP
      AND D.PPTOPE=D10.AOTOPE
      AND D.D601CO='S') FEC_PRI_CUOCAL,
      NVL((SELECT distinct
            CASE 
               WHEN EXISTS (  SELECT 1
                              FROM BNJ096 BNJ
                              WHERE BNJ.BNJ096CTA = T.JAQNS4CUEN
                              AND BNJ.BNJ096OPE = T.JAQNS4OPER 
                              AND BNJ.BNJ096CPE = '159') THEN 1 
            END
         FROM JAQNS4 T
         WHERE T.JAQNS4CUEN =D10.AOCTA
         AND T.JAQNS4OPER = D10.AOOPER
         AND T.JAQNS4SBOP=D10.AOSBOP),0) ESPECIFICA, 
      NVL((SELECT distinct
            CASE 
               WHEN NOT EXISTS ( SELECT 1
                                 FROM BNJ096 BNJ
                                 WHERE BNJ.BNJ096CTA = T.JAQNS4CUEN
                                 AND BNJ.BNJ096OPE = T.JAQNS4OPER
                                 AND BNJ.BNJ096CPE = '159') THEN 1 END
         FROM JAQNS4 T
         WHERE T.JAQNS4CUEN =D10.AOCTA
         AND T.JAQNS4OPER=D10.AOOPER
         AND T.JAQNS4SBOP=D10.AOSBOP),0) GENERICA,
      (SELECT 
         T.JAQNS5DIRE
      FROM JAQNS5 T
      WHERE T.JAQNS5SUCU = D10.AOSUC) LOC_AGENCIA  

   FROM FSD010 D10
   LEFT JOIN FSR008 R8 ON R8.CTNRO = D10.AOCTA and R8.TTCOD = 1 AND R8.CTTFIR = 'T'
   WHERE D10.AOMOD || '-' || D10.AOTOPE IN ('101-353')
   AND D10.AOFVAL <= FECHAINGRESO;

   /*JAQNS6 - FIN*/


  /*JAQNS7*/
   --DELETE/*+ PARALLEL(DEGREE 4) */ FROM JAQNS7;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE JAQNS7';
   DBMS_OUTPUT.PUT_LINE('Tabla JAQNS7 truncada exitosamente.');
   INSERT/*+ PARALLEL(DEGREE 4) */ INTO JAQNS7 (JAQNS7PAIS, JAQNS7TDOC, JAQNS7NDOC, JAQNS7MONE, JAQNS7CUEN, JAQNS7OPER, JAQNS7SBOP, JAQNS7SDMN, JAQNS7FVAL,JAQNS7FVTO, JAQNS7TASA, JAQNS7TACT, JAQNS7PERI, JAQNS7FPAG, JAQNS7ESPE, JAQNS7GENE, JAQNS7LAGE)
   SELECT 
      T.JAQNS6PAIS,
      T.JAQNS6TDOC,
      T.JAQNS6NDOC,
      MAX(T.JAQNS6MONE) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) AOMDA,
      MAX(T.JAQNS6CUEN) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) AOCTA,
      MAX(T.JAQNS6OPER) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) AOOPER,
      MAX(T.JAQNS6SBOP) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) AOSBOP,
      SUM(T.JAQNS6SDMN) SALCAPMN,
      MAX(T.JAQNS6FVAL) FECDES,
      MAX(T.JAQNS6FVTO) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) FECVTO,
      MAX(T.JAQNS6TASA) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) TASAORI,
      MAX(T.JAQNS6TACT) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) TASAACT,
      MAX(T.JAQNS6PERI) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) FRECUENCIA,
      MAX(T.JAQNS6FPAG) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) FEC_PRI_CUOCAL,
      MAX(T.JAQNS6ESPE) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) ESPECIFICA,
      MAX(T.JAQNS6GENE) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) GENERICA,
      MAX(T.JAQNS6LAGE) KEEP(DENSE_RANK LAST ORDER BY T.JAQNS6FVAL) LOC_AGENCIA
   FROM JAQNS6 T 
   GROUP BY T.JAQNS6PAIS, T.JAQNS6TDOC,T.JAQNS6NDOC;
   /*JAQNS7 - FIN*/


   /*INSERT JAQN571 */  
   DELETE /*+ PARALLEL(DEGREE 4) */ FROM JAQN571 WHERE JAQN571FEC = FECHAINGRESO ; 
   INSERT /*+ PARALLEL(DEGREE 4) */ INTO JAQN571 (JAQN571FEC, JAQN571EMP, JAQN571MOD, JAQN571SUC, JAQN571MON, JAQN571PAP, JAQN571CTA, JAQN571OPE, JAQN571SBO, JAQN571TOP, JAQN571COD, JAQN571NRO, JAQN571TAS,JAQN571AI1,
                           JAQN571TRA, JAQN571SEC, JAQN571CON, JAQN571TVA, JAQN571COF, JAQN571FED,JAQN571FEV, JAQN571PPA, JAQN571PTD, JAQN571PND, JAQN571PRZ, JAQN571TEM, JAQN571NMO,
                           JAQN571MDE, JAQN571MPE, JANQ571POR, JAQN571PER, JAQN571GGL, JAQN571GGN, JAQN571LOC,JAQN571TTI,JAQN571AC1)
                           SELECT FECHAINGRESO,
                                    (SELECT MAX(T.JAQNS6EMPR)
                                    FROM JAQNS6 T
                                    WHERE T.JAQNS6MONE =REA.JAQNS7MONE
                                    AND  T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),

                                    (SELECT MAX(T.JAQNS6MODU)
                                    FROM JAQNS6 T
                                    WHERE  T.JAQNS6MONE =REA.JAQNS7MONE 
                                    AND T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),

                                    (SELECT MAX(T.JAQNS6SUCU)
                                    FROM JAQNS6 T
                                    WHERE T.JAQNS6MONE =REA.JAQNS7MONE 
                                    AND T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),

                                    REA.JAQNS7MONE,

                                    (SELECT MAX(T.JAQNS6PAPE)
                                    FROM JAQNS6 T
                                    WHERE T.JAQNS6MONE =REA.JAQNS7MONE 
                                    AND T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),

                                    REA.JAQNS7CUEN,
                                    REA.JAQNS7OPER,
                                    REA.JAQNS7SBOP,

                                    (SELECT MAX(T.JAQNS6TOPE)
                                    FROM JAQNS6 T
                                    WHERE T.JAQNS6MONE =REA.JAQNS7MONE 
                                    AND T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),

                                    803,
                                    (SELECT JAQN572NRO
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER) NROOPERACION,
                                    REA.JAQNS7TASA,
                                    REA.JAQNS7TACT,

                                    (SELECT JAQN572TRA
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER) 
                                    TRAMO,NULL,NULL,LPAD(REA.JAQNS7CUEN,9,'0')||LPAD(REA.JAQNS7MONE,3,'0')||LPAD(REA.JAQNS7OPER,9,'0'),
                                    (SELECT JAQN572COF
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER) 
                                    CERTIFICADOCOF,
                                    REA.JAQNS7FVAL,
                                    REA.JAQNS7FVTO,
                                    REA.JAQNS7PAIS,
                                    REA.JAQNS7TDOC,
                                    REA.JAQNS7NDOC,
                                    (SELECT JAQN572RAZ
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER) 
                                    RAZONSOCIAL,
                                    (SELECT JAQN572TEM
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER) 
                                    TAMANOEMPRE,
                                    'PEN',
                                    --REA.AOIMP,
                                    (SELECT max(T.JAQNS6IMPO )
                                    FROM JAQNS6 T
                                    WHERE T.JAQNS6MONE =REA.JAQNS7MONE 
                                    AND T.JAQNS6CUEN =REA.JAQNS7CUEN
                                    AND T.JAQNS6OPER =REA.JAQNS7OPER),
                                    ABS(REA.JAQNS7SDMN),
                                    (SELECT JAQN572POR
                                    FROM jaqn572 D
                                    WHERE D.JAQN572CTA =REA.JAQNS7CUEN
                                    AND D.JAQN572MON =REA.JAQNS7MONE
                                    AND D.JAQN572OPE =REA.JAQNS7OPER),
                                    ROUND(GREATEST(REA.JAQNS7FPAG - (REA.JAQNS7FVAL+REA.JAQNS7PERI), 0)/30),
                                    REA.JAQNS7ESPE,
                                    REA.JAQNS7GENE,
                                    REA.JAQNS7LAGE,
                                    'Pagaré'
                                    ,(SELECT JAQN573AC1 FROM JAQN573  WHERE JAQN573NUM =  REA.JAQNS7NDOC)
                           FROM JAQNS7 REA;                                                                         
   /*INSER JAQN571 - FIN*/

 /*  UPDATE JAQN571 SET JAQN571AC1= (SELECT  JAQN573AC1   FROM JAQN573 
                              --WHERE JAQN573.JAQN573FEC=JAQN571.JAQN571FEC 
                              --AND to_number(JAQN573.JAQN573CEN)=JAQN571.JAQN571COD
                              --AND to_number(JAQN573.JAQN573NOR)=JAQN571.JAQN571NRO
                              --AND JAQN573.JAQN573TAN=JAQN571.JAQN571TAS
                              --AND to_number(JAQN573.JAQN573NTR)=JAQN571.JAQN571TRA
                              --AND JAQN573.JAQN573PAI=JAQN571.JAQN571PPA
                              --AND JAQN573.JAQN573TDO=JAQN571.JAQN571PTD
                              WHERE JAQN573.JAQN573NUM=JAQN571.JAQN571PND);*/


    v_d2 := SYSTIMESTAMP ;
    v_n := v_d2-v_d1 ;
    tiempo:=to_char( v_n, 'YYYYMMDDHH24MISS' );
    DBMS_OUTPUT.PUT_LINE ('Tiempo total: '||v_n||tiempo);
    TIMETOTAL:=tiempo;


   -- EXCEPTION WHEN OTHERS THEN
   --             IF SQLCODE != -942 THEN
   --                  RAISE;
   --             END IF;


END SP_SEGUIMIENTO_BCR_REACTIVA;
/

