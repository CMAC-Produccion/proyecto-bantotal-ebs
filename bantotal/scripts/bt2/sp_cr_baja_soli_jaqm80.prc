CREATE OR REPLACE PROCEDURE SP_CR_BAJA_SOLI_JAQM80(FECHA DATE) IS
  CURSOR CREDITOS IS
    SELECT I.JAQM80FC, I.JAQM80ND, S.XWFPRCINS LN_INS
      FROM JAQM80 I, XWF700 S
     WHERE I.JAQM80FC >= FECHA
       AND S.XWFEMPRESA = 1
       AND S.XWFSUCURSAL = I.JAQM80SU
       AND S.XWFMODULO = I.JAQM80MO
       AND S.XWFMONEDA = I.JAQM80MN
       AND S.XWFCUENTA = I.JAQM80CT
       AND S.XWFTIPOPE = I.JAQM80TP
       AND S.XWFCAR3 = '1'
       AND EXISTS (SELECT 1
              FROM WFWRKITEMS W
             WHERE W.WFINSPRCID = S.XWFPRCINS
               AND W.WFITEMSTSACT = '1')
       AND NOT EXISTS (SELECT 1
              FROM XWF070 D, FSH015 C
             WHERE D.XWFPGCOD = 1
               AND D.XWFPRCIN = S.XWFPRCINS
               AND D.XWFCONT = 'S'
               AND C.PGCOD = D.XWFPGCOD
               AND C.HCMOD = D.XWFTMOD
               AND C.HSUCOR = D.XWFTSUC
               AND C.HTRAN = D.XWFTTRAN
               AND C.HNREL = D.XWFNREL
               AND C.HFCON = D.XWFFCON
               AND C.HCCORR = 0)
     GROUP BY I.JAQM80FC, I.JAQM80ND, S.XWFPRCINS;

  LN_ID NUMBER(10);
BEGIN

  DELETE CRDTCAP;
  COMMIT;
  INSERT INTO CRDTCAP
    (D_FECHA, C_DESCRI1, N_MONTO1)
    SELECT I.JAQM80FC, I.JAQM80ND, S.XWFPRCINS LN_INS
      FROM JAQM80 I, XWF700 S
     WHERE I.JAQM80FC >= FECHA
       AND S.XWFEMPRESA = 1
       AND S.XWFSUCURSAL = I.JAQM80SU
       AND S.XWFMODULO = I.JAQM80MO
       AND S.XWFMONEDA = I.JAQM80MN
       AND S.XWFCUENTA = I.JAQM80CT
       AND S.XWFTIPOPE = I.JAQM80TP
       AND S.XWFCAR3 = '1'
       AND EXISTS (SELECT 1
              FROM WFWRKITEMS W
             WHERE W.WFINSPRCID = S.XWFPRCINS
               AND W.WFITEMSTSACT = '1')
       AND NOT EXISTS (SELECT 1
              FROM XWF070 D, FSH015 C
             WHERE D.XWFPGCOD = 1
               AND D.XWFPRCIN = S.XWFPRCINS
               AND D.XWFCONT = 'S'
               AND C.PGCOD = D.XWFPGCOD
               AND C.HCMOD = D.XWFTMOD
               AND C.HSUCOR = D.XWFTSUC
               AND C.HTRAN = D.XWFTTRAN
               AND C.HNREL = D.XWFNREL
               AND C.HFCON = D.XWFFCON
               AND C.HCCORR = 0)
     GROUP BY I.JAQM80FC, I.JAQM80ND, S.XWFPRCINS;
  COMMIT;

  EXECUTE IMMEDIATE 'CREATE TABLE operador.wfworklist_' ||
                    TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                    SUBSTR(USER, 1, 3) ||
                    ' parallel (degree 4) nologging AS select a.* from wfworklist a where a.wfwrklstitemid in ( SELECT A.WFITEMID
                                                        FROM WFWRKITEMS A
                                                       WHERE A.WFINSPRCID in (select trunc(N_MONTO1) from CRDTCAP)
                                                         AND A.WFITEMSTSACT = 1)';
  EXECUTE IMMEDIATE 'create table operador.wfwrkitems_' ||
                    TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                    SUBSTR(USER, 1, 3) ||
                    ' as select * from wfwrkitems where wfitemstsact = 1 and wfinsprcid in ( select trunc(N_MONTO1) from CRDTCAP)';
  EXECUTE IMMEDIATE 'create table operador.wfinstprc_' ||
                    TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                    SUBSTR(USER, 1, 3) ||
                    ' as select * from wfinstprc where wfinsprcid in ( select trunc(N_MONTO1) from CRDTCAP)';

  FOR I IN CREDITOS LOOP
    LN_ID := NULL;
    BEGIN
      SELECT A.WFITEMID
        INTO LN_ID
        FROM WFWRKITEMS A
       WHERE A.WFINSPRCID = I.LN_INS
         AND A.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    DELETE FROM WFWORKLIST C WHERE C.WFWRKLSTITEMID = LN_ID;

    COMMIT;
    UPDATE WFWRKITEMS A
       SET WFSTSCOD = 'B', WFITEMSTSACT = 0, WFITEMEND = SYSDATE
     WHERE A.WFINSPRCID = I.LN_INS
       AND A.WFITEMSTSACT = 1;
    COMMIT;

    UPDATE WFINSTPRC B
       SET WFINSPRCSTA = 'B', WFINSPRCOSTA = 0, WFINSPRCEND = SYSDATE
     WHERE B.WFINSPRCID = I.LN_INS;
    COMMIT;

  END LOOP;
insert into AQPB876 values (user,sysdate,'SP_CR_BAJA_SOLI_JAQM80',  to_char(fecha,'DD/MM/RRRR'));
commit;
END SP_CR_BAJA_SOLI_JAQM80;
/

