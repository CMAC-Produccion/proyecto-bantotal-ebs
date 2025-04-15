CREATE OR REPLACE PROCEDURE SP_CR_DOCUMENTOS_POST_DESEMB(INSTANCIA NUMBER) IS
    N_CONT        NUMBER;
    N_CONT2       NUMBER;
    D_WFINSPRCEND DATE;
    N_WFITEMID    NUMBER;
    N_CONTINS     NUMBER;
    N_CONTUPD1    NUMBER;
    N_CONTUPD2    NUMBER;
    -- *****************************************************************
    -- Nombre                     : SP_CR_DOCUMENTOS_POST_DESEMB
    -- Sistema                    : BANTOTAL
    -- Módulo                     : MESA DE AYUDA
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2025
    -- Autor de Creación          : EHIDALGOM/LCARPIO
    -- Uso                        : Corrección documentos que no se ven post desembolso
    -- Estado                     : Activo
    -- Acceso                     : Mesa de ayuda
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1)
    INTO N_CONT
    FROM FSD015 A, FSD016 B
   WHERE A.PGCOD = 1
     AND A.PGCOD = B.PGCOD
     AND A.ITSUC = B.ITSUC
     AND A.ITMOD = B.ITMOD
     AND A.ITTRAN = B.ITTRAN
     AND A.ITNREL = B.ITNREL
     AND B.ITAFGT = 'C'
     AND (B.MODULO, B.CTNRO, B.ITOPER, B.ITSUBO) IN
         (SELECT XWFMODULO, XWFCUENTA, XWFOPERACION, XWFSUBOPE
            FROM XWF700 P
           WHERE P.XWFPRCINS = INSTANCIA
             AND P.XWFCAR3 = '1');

  SELECT COUNT(1)
    INTO N_CONT2
    FROM WFWRKITEMS O
   WHERE O.WFINSPRCID = INSTANCIA;

  IF N_CONT > 0 AND N_CONT2 > 0 THEN
    SELECT TO_DATE(TO_CHAR(A.ITFCON, 'DD/MM/YYYY') || ' ' || A.ITHORA,
                   'DD/MM/YYYY HH24:MI:SS') WFINSPRCEND
      INTO D_WFINSPRCEND
      FROM FSD015 A, FSD016 B
     WHERE A.PGCOD = 1
       AND A.PGCOD = B.PGCOD
       AND A.ITSUC = B.ITSUC
       AND A.ITMOD = B.ITMOD
       AND A.ITTRAN = B.ITTRAN
       AND A.ITNREL = B.ITNREL
       AND B.ITAFGT = 'C'
       AND (B.MODULO, B.CTNRO, B.ITOPER, B.ITSUBO) IN
           (SELECT XWFMODULO, XWFCUENTA, XWFOPERACION, XWFSUBOPE
              FROM XWF700 P
             WHERE P.XWFPRCINS = INSTANCIA
               AND P.XWFCAR3 = '1');

    SELECT MAX(WFITEMID)
      INTO N_WFITEMID
      FROM WFWRKITEMS O
     WHERE O.WFINSPRCID = INSTANCIA;

    EXECUTE IMMEDIATE 'create table operador.WFINSTPRC_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from WFINSTPRC where WFINSPRCID = ' ||
                      INSTANCIA;

    EXECUTE IMMEDIATE 'create table operador.WFWRKITEMS_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from WFWRKITEMS where WFINSPRCID = ' ||
                      INSTANCIA || ' AND WFITEMID = ' || N_WFITEMID;

    UPDATE WFINSTPRC A
       SET A.WFINSPRCOSTA = 0,
           A.WFINSPRCSTA  = 'C',
           A.WFINSPRCEND  = D_WFINSPRCEND
     WHERE A.WFINSPRCID = INSTANCIA;
    N_CONTUPD1 := SQL%ROWCOUNT;

    UPDATE WFWRKITEMS O
       SET O.WFITEMEND    = D_WFINSPRCEND,
           O.WFSTSCOD     = 'C',
           O.WFITEMSTSACT = 0
     WHERE O.WFINSPRCID = INSTANCIA
       AND O.WFITEMID = N_WFITEMID;
    N_CONTUPD2 := SQL%ROWCOUNT;

    INSERT INTO XWF070
      SELECT N_WFITEMID,
             A.PGCOD,
             A.ITMOD,
             A.ITSUC,
             A.ITTRAN,
             A.ITNREL,
             TRUNC(SYSDATE),
             INSTANCIA,
             0,
             'S'
        FROM FSD015 A, FSD016 B
       WHERE A.PGCOD = 1
         AND A.PGCOD = B.PGCOD
         AND A.ITSUC = B.ITSUC
         AND A.ITMOD = B.ITMOD
         AND A.ITTRAN = B.ITTRAN
         AND A.ITNREL = B.ITNREL
         AND B.ITAFGT = 'C'
         AND (B.MODULO, B.CTNRO, B.ITOPER, B.ITSUBO) IN
             (SELECT XWFMODULO, XWFCUENTA, XWFOPERACION, XWFSUBOPE
                FROM XWF700 P
               WHERE P.XWFPRCINS = INSTANCIA
                 AND P.XWFCAR3 = '1');
    N_CONTINS := SQL%ROWCOUNT;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('En XWF070 se insertó ' || N_CONTINS ||
                         ' registro(s), en WFINSTPRC se actualizó ' ||
                         N_CONTUPD1 ||
                         ' registro(s) y en WFWRKITEMS se actualizó ' ||
                         N_CONTUPD2 || ' registro(s).');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en las tablas FSD015, FSD016 y/o WFWRKITEMS para la instancia = ' ||
                         INSTANCIA);
  END IF;
  INSERT INTO AQPB876
  VALUES
    (USER, SYSDATE, 'SP_CR_DOCUMENTOS_POST_DESEMB', INSTANCIA);
  COMMIT;
END SP_CR_DOCUMENTOS_POST_DESEMB;
/
