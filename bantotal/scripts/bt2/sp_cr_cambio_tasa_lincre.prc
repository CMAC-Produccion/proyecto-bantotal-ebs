CREATE OR REPLACE PROCEDURE SP_CR_CAMBIO_TASA_LINCRE(INSTANCIA NUMBER,
                                                       MONTO     NUMBER,
                                                       TASA      NUMBER) IS

    N_CONT1  NUMBER := 0;
    N_CONT2  NUMBER := 0;
    N_CONT3  NUMBER := 0;
    N_FECINV NUMBER := 0;
  BEGIN
    --LUIS CARPIO/ERIKA HIDALGO
    --27/07/2020
    --LA FECHA INVERSA, ES RESULTADO DE 99999999 - AÑO * 10000 - MES* 100 - DIA.
    N_FECINV := 99999999 - ( EXTRACT(YEAR FROM SYSDATE) * 10000) -
                (EXTRACT(MONTH FROM SYSDATE) * 100) - EXTRACT(DAY FROM SYSDATE);
    dbms_output.put_line(N_FECINV);
    SELECT COUNT(*)
      INTO N_CONT1
      FROM (SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               MONTO,
               1,
               N_FECINV /*79799390*/,--79799278
               'S'
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1');

    SELECT COUNT(*)
      INTO N_CONT2
      FROM (SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               MONTO,
               99999,
               TASA
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1');

    SELECT COUNT(*)
      INTO N_CONT3
      FROM (SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               TRUNC(SYSDATE) + 2
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1');



    IF (N_CONT1 = 1 AND N_CONT2 = 1 AND N_CONT3 = 1) THEN
      INSERT INTO FSD027
        SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               MONTO,
               1,
               N_FECINV /*79799390*/,
               'S'
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1';
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE INSERTÓ FSD027, ' || N_CONT2 ||
                           ' registro.');
      INSERT INTO FSR027
        SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               MONTO,
               99999,
               TASA
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1';
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE INSERTÓ FSR027, ' || N_CONT2 ||
                           ' registro.');
      INSERT INTO FSD327
        SELECT A.PP028EMP,
               A.PP028MOD,
               A.PP028DEFN,
               B.XWFCUENTA,
               A.PP028MDA,
               A.PP028PAP,
               TRUNC(SYSDATE),
               TRUNC(SYSDATE) + 2
          FROM FPP028 A, XWF700 B
         WHERE A.PP028EMP = B.XWFEMPRESA
           AND A.PP028MOD = B.XWFMODULO
           AND A.PP028TOP = B.XWFTIPOPE
           AND A.PP028MDA = B.XWFMONEDA
           AND A.PP028PAP = B.XWFPAPEL
           AND A.PP017PAR = 17
           AND B.XWFPRCINS = INSTANCIA
           AND B.XWFCAR3 = '1';
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE INSERTÓ FSD327, ' || N_CONT2 ||
                           ' registro.');
    ELSE
      IF N_CONT1 <> 1 THEN
        DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || INSTANCIA ||
                             ' considera ' || N_CONT1 ||
                             ' registro(s) para el insert a FSD027.' ||
                             CHR(13) || 'No se realizó el Insert.');
      END IF;
      IF N_CONT2 <> 1 THEN
        DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || INSTANCIA ||
                             ' considera ' || N_CONT2 ||
                             ' registro(s) para el insert a FSR027.' ||
                             CHR(13) || 'No se realizó el Insert.');
      END IF;
      IF N_CONT3 <> 1 THEN
        DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || INSTANCIA ||
                             ' considera ' || N_CONT3 ||
                             ' registro(s) para el insert a FSD327.' ||
                             CHR(13) || 'No se realizó el Insert.');
      END IF;
    END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CAMBIO_TASA_LINCRE', INSTANCIA||'-'||MONTO||'-'||TASA);
commit;
  END SP_CR_CAMBIO_TASA_LINCRE;
/

