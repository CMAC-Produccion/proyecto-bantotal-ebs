CREATE OR REPLACE PROCEDURE SP_CR_BAJA_SOLIC_FM_JAQZ697(FECHA DATE) is
  CURSOR CREDITOS IS
    SELECT I.JAQZ697FEP FECHA, I.JAQZ697NDO NRO_DOC, S.XWFPRCINS LN_INS
      FROM JAQZ697 I, XWF700 S
     WHERE I.JAQZ697FEP >= FECHA
       AND S.XWFEMPRESA = 1
       AND S.XWFSUCURSAL = I.JAQZ697SUC
       AND S.XWFMODULO = I.JAQZ697MOD
       AND S.XWFMONEDA = I.JAQZ697MDA
       AND S.XWFCUENTA = I.JAQZ697CTA
       AND S.XWFTIPOPE = I.JAQZ697TOP
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
     GROUP BY I.JAQZ697FEP, I.JAQZ697NDO, S.XWFPRCINS;

  LN_ID NUMBER(10);
BEGIN
  DELETE CRDTCAP;
  COMMIT;
  INSERT INTO CRDTCAP
    (D_FECHA, C_DESCRI1, N_MONTO1)
    SELECT I.JAQZ697FEP FECHA, I.JAQZ697NDO NRO_DOC, S.XWFPRCINS LN_INS
      FROM JAQZ697 I, XWF700 S
     WHERE I.JAQZ697FEP >= FECHA
       AND S.XWFEMPRESA = 1
       AND S.XWFSUCURSAL = I.JAQZ697SUC
       AND S.XWFMODULO = I.JAQZ697MOD
       AND S.XWFMONEDA = I.JAQZ697MDA
       AND S.XWFCUENTA = I.JAQZ697CTA
       AND S.XWFTIPOPE = I.JAQZ697TOP
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
     GROUP BY I.JAQZ697FEP, I.JAQZ697NDO, S.XWFPRCINS;
  COMMIT;

  EXECUTE IMMEDIATE 'create table operador.wfworklist_' ||
                    TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                    SUBSTR(USER, 1, 3) ||
                    ' as select * from wfworklist where wfwrklstitemid in ( SELECT A.WFITEMID
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
insert into AQPB876 values (user,sysdate,'SP_CR_BAJA_SOLIC_FM_JAQZ697', to_char(FECHA,'DD/MM/RRRR'));
commit;
END SP_CR_BAJA_SOLIC_FM_JAQZ697;
/

