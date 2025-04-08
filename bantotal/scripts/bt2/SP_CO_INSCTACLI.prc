CREATE OR REPLACE PROCEDURE SP_CO_INSCTACLI(V_NROASIENTO /*IF003TEXL*/ CHAR,
                                            N_IF003RUBRO NUMBER,
                                            N_IF003CTNRO NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : SP_CO_INSCTACLI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : CONTABILIDAD
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/04/2025
    -- Autor de Creación          : EHIDALGOM
    -- Uso                        : Inserta Cuenta Cliente FIF003
    -- Estado                     : Activo
    -- Acceso                     : Carmen Sosa y Producción
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  N_CONT NUMBER;
BEGIN
  --LUZVENIA CHUMBILLA/ERIKA HIDALGO
  SELECT COUNT(1)
    INTO N_CONT
    FROM FIF003
   WHERE IF002PGCOD = 1
     AND IF002ORI >= 20
     AND IF003TEXL = V_NROASIENTO
     AND IF003RUBRO = N_IF003RUBRO;
  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.FIF003_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from FIF003 where IF002PGCOD = 1 AND IF002ORI >= 20 AND IF003TEXL=' ||
                      V_NROASIENTO || ' AND IF003RUBRO=' || N_IF003RUBRO;
    UPDATE FIF003
       SET IF003CTNRO = N_IF003CTNRO
     WHERE IF002PGCOD = 1
       AND IF002ORI >= 20
       AND IF003TEXL = V_NROASIENTO
       AND IF003RUBRO = N_IF003RUBRO;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en FIF003 para Numero Asiento:' ||
                         V_NROASIENTO || ' y Rubro:' || N_IF003RUBRO || '.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en la tabla FIF003 para Numero Asiento:' ||
                         V_NROASIENTO || ' y Rubro:' || N_IF003RUBRO || '.');
  END IF;
  INSERT INTO AQPB876
  VALUES
    (USER,
     SYSDATE,
     'SP_CO_INSCTACLI',
     V_NROASIENTO || '-' || N_IF003RUBRO || '-' || N_IF003CTNRO);
  COMMIT;
END SP_CO_INSCTACLI;
/
