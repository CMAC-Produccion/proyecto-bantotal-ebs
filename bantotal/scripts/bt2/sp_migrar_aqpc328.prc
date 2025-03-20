CREATE OR REPLACE PROCEDURE SP_MIGRAR_AQPC328(
  p_c_coderr OUT VARCHAR2,
  p_c_msjerr OUT VARCHAR2
) IS
  -- ---------------------------------------------------------------------------
  -- Nombre                   : SP_MIGRAR_AQPC328
  -- Sistema                  : BANTOTAL
  -- Módulo                   : BANTOTAL
  -- Versión                  : 1.0
  -- Fecha de Creación        : 2024.08.26
  -- Autor de Creación        : Renzo Cuadros Salazar
  -- Uso                      : migrar relación de clientes tarjeta platinum
  -- Estado                   : Activo
  -- Acceso                   : Público
  -- Fecha de Modificación    : 
  -- Autor de Modificación    : 
  -- Descripción Modificación : 
  -- ---------------------------------------------------------------------------

  CURSOR c_AQPC328 IS SELECT * FROM AQPC328;

BEGIN

  p_c_coderr := '00000';
  p_c_msjerr := '';

    FOR i IN c_AQPC328 LOOP

      BEGIN

        INSERT INTO AQPC328H (
          AQPC328FCGH,
          AQPC328NDOH,
          AQPC328AP1H,
          AQPC328AP2H,
          AQPC328NO1H,
          AQPC328NO2H
        )
        VALUES (
          i.AQPC328FCG,
          i.AQPC328NDO,
          i.AQPC328AP1,
          i.AQPC328AP2,
          i.AQPC328NO1,
          i.AQPC328NO2
         );
        COMMIT;

      EXCEPTION
        WHEN OTHERS THEN
          p_c_coderr := '32801';
          p_c_msjerr := 'ERROR : ' || SQLERRM;
       END;

    END LOOP;

    DELETE FROM AQPC328;
    COMMIT;
END SP_MIGRAR_AQPC328;
/

