CREATE OR REPLACE PROCEDURE SP_CR_ASIENTOS_NO_CONTAB(SUCURSAL    NUMBER,
                                                     MODULO      NUMBER,
                                                     TRANSACCION NUMBER,
                                                     RELACION    NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : SP_CR_ASIENTOS_NO_CONTAB
    -- Sistema                    : BANTOTAL
    -- Módulo                     : MESA DE AYUDA
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2025
    -- Autor de Creación          : EHIDALGOM/LCARPIO
    -- Uso                        : Corrección para asientos NO contabilizados
    -- Estado                     : Activo
    -- Acceso                     : Mesa de ayuda
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  N_CONT    NUMBER;
  N_CONTINS NUMBER;
  N_CONTUPD NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1)
    INTO N_CONT
    FROM FSD015 A
   WHERE A.ITCONT NOT IN ('S', 'P')
     AND (A.ITSUC, A.ITMOD, A.ITTRAN, A.ITNREL) IN
         (SELECT B.ITSUC, B.ITMOD, B.ITTRAN, B.ITNREL
            FROM FSD016 B
           WHERE B.ITAFGT = 'C')
     AND A.ITHORA < TO_CHAR(SYSDATE - (1 / 24 / 6), 'HH24:MI:SS')
     AND ITSUC = SUCURSAL
     AND ITMOD = MODULO
     AND ITTRAN = TRANSACCION
     AND ITNREL = RELACION;

  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.FSD015_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from FSD015 where PGCOD = 1 AND ITSUC = ' ||
                      SUCURSAL || ' AND ITMOD = ' || MODULO ||
                      ' AND ITTRAN = ' || TRANSACCION || ' AND ITNREL = ' ||
                      RELACION;
    INSERT INTO FSE015
      SELECT PGCOD,
             ITSUC,
             ITMOD,
             ITTRAN,
             ITNREL,
             ITFCON,
             ITFVC,
             ITHORA,
             ITUING,
             ITUING,
             A.ITCAJA,
             0,
             0,
             0,
             '01/01/0001'
        FROM FSD015 A
       WHERE PGCOD = 1
         AND ITSUC = SUCURSAL
         AND ITMOD = MODULO
         AND ITTRAN = TRANSACCION
         AND ITNREL = RELACION;
  
    N_CONTINS := SQL%ROWCOUNT;
  
    UPDATE FSD015 A
       SET ITUCNF = ITUING, ITWCNF = ITWING, ITCONT = 'S'
     WHERE PGCOD = 1
       AND ITSUC = SUCURSAL
       AND ITMOD = MODULO
       AND ITTRAN = TRANSACCION
       AND ITNREL = RELACION;
  
    N_CONTUPD := SQL%ROWCOUNT;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se insertó ' || N_CONTINS ||
                         ' registros y se actualizó ' || N_CONTUPD ||
                         ' registros para ITSUC = ' || SUCURSAL ||
                         ' AND ITMOD = ' || MODULO || ' AND ITTRAN = ' ||
                         TRANSACCION || ' AND ITNREL = ' || RELACION);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en la tabla FSD015 para ITSUC = ' ||
                         SUCURSAL || ' AND ITMOD = ' || MODULO ||
                         ' AND ITTRAN = ' || TRANSACCION ||
                         ' AND ITNREL = ' || RELACION);
  END IF;
  INSERT INTO AQPB876
  VALUES (USER,SYSDATE,'SP_CR_ASIENTOS_NO_CONTAB',SUCURSAL || '-' || MODULO || '-' || TRANSACCION || '-' || RELACION);
  COMMIT;
END SP_CR_ASIENTOS_NO_CONTAB;
/
