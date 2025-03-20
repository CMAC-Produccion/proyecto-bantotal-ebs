CREATE OR REPLACE PROCEDURE SP_INS_TRANSACCIONES_FPP157 IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1)
    INTO N_CONT
    FROM FPP157
   WHERE PP157EMP = 1
     AND PP157TOP NOT IN (550)
     AND PP157MOD NOT IN (108, 200, 33, 141);

  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.FPP157_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from FPP157 where PP157EMP=1 AND PP157TOP NOT IN (550) AND PP157MOD NOT IN (108,200,33,141)';

    DELETE FROM FPP157
     WHERE PP157EMP = 1
       AND PP157TOP NOT IN (550)
       AND PP157MOD NOT IN (108, 200, 33, 141); --23758
    INSERT INTO FPP157
      SELECT E.PGCOD,
             E.XPREMOD,
             E.XPRETOPE,
             0,
             0,
             R.AQPB893EST,
             501,
             1,
             0,
             30,
             100,
             0,
             'P',
             NULL,
             NULL
        FROM X054010 E, AQPB893 R
       WHERE XPREMOD NOT IN (29, 33, 200, 117, 141, 120, 108)
         AND XPRETOPE <> 550
         AND XPREMONEDA = 0; --13998
    INSERT INTO FPP157
      SELECT E.PGCOD,
             E.XPREMOD,
             E.XPRETOPE,
             0,
             0,
             R.AQPB893EST,
             502,
             1,
             0,
             30,
             150,
             0,
             'T',
             NULL,
             NULL
        FROM X054010 E, AQPB893 R
       WHERE XPREMOD NOT IN (29, 33, 200, 117, 141, 120, 108)
         AND XPRETOPE <> 550
         AND XPREMONEDA = 0; ---13998
    INSERT INTO FPP157
      SELECT E.PGCOD,
             E.XPREMOD,
             E.XPRETOPE,
             0,
             0,
             7,
             501,
             1,
             0,
             30,
             100,
             0,
             'P',
             NULL,
             NULL
        FROM X054010 E
       WHERE XPREMOD IN (116)
         AND XPRETOPE <> 550
         AND XPREMONEDA = 0; --112
    INSERT INTO FPP157
      SELECT E.PGCOD,
             E.XPREMOD,
             E.XPRETOPE,
             0,
             0,
             7,
             502,
             1,
             0,
             30,
             150,
             0,
             'T',
             NULL,
             NULL
        FROM X054010 E
       WHERE XPREMOD IN (116)
         AND XPRETOPE <> 550
         AND XPREMONEDA = 0; --112
    COMMIT;

  END IF;
END SP_INS_TRANSACCIONES_FPP157;
/

