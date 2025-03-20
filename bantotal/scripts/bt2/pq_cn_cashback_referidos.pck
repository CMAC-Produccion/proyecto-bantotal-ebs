CREATE OR REPLACE PACKAGE PQ_CN_CASHBACK_REFERIDOS IS

  -- *****************************************************************
  -- Nombre                     : PQ_CN_CASHBACK_REFERIDOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.06.27
  -- Autor de Creación          : Renzo Cuadros Salazar
  -- Uso                        : Proceso de cashback de referidos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.08.16
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se modifica los subines permitios
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción Modificación   : 
  -- *****************************************************************

  PROCEDURE sp_obtener_compras(pd_fecpro IN DATE,
                               pn_idcamp IN NUMBER,
                               pc_coderr OUT VARCHAR2,
                               pc_msgerr OUT VARCHAR2
                              );

  PROCEDURE sp_contar_compras(pd_fecini IN DATE,
                              pd_fecfin IN DATE,
                              pn_cuenta IN NUMBER,
                              pn_conteo OUT NUMBER,
                              pc_coderr OUT VARCHAR2,
                              pc_msgerr OUT VARCHAR2
                             );
END PQ_CN_CASHBACK_REFERIDOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CN_CASHBACK_REFERIDOS IS

  PROCEDURE sp_obtener_compras(
      pd_fecpro IN DATE,
      pn_idcamp IN NUMBER,
      pc_coderr OUT VARCHAR2,
      pc_msgerr OUT VARCHAR2
  ) IS

      lc_bin01 VARCHAR2(9);
      lc_bin02 VARCHAR2(9);
  BEGIN
      pc_coderr := '00000';
      pc_msgerr := '';
      
      -- Bines de la campaña que aplican cashback
      SELECT AQPC323LOTE01, AQPC323LOTE02
        INTO lc_bin01, lc_bin02
        FROM AQPC323
       WHERE AQPC323IDCAMP = pn_idcamp
         AND AQPC323ESTADO = 'S';

      DELETE FROM AQPC324;
      COMMIT;

      INSERT INTO AQPC324 (
        AQPC324NUMERA,
        AQPC324PGCOD,
        AQPC324HCMOD,
        AQPC324HSUCOR,
        AQPC324HTRAN,
        AQPC324HNREL,
        AQPC324HFCON,
        AQPC324HCORD,
        AQPC324HCSUBO,
        AQPC324HMODUL,
        AQPC324HTOPER,
        AQPC324HSUCUR,
        AQPC324HMDA,
        AQPC324HPAP,
        AQPC324HCTA,
        AQPC324HOPER,
        AQPC324HSUBOP,
        AQPC324HFVAL,
        AQPC324HCIMP1,
        AQPC324HCREF,
        AQPC324MOTIVO
      )
      SELECT
        ROWNUM,
        PGCOD,
        HCMOD,
        HSUCOR,
        HTRAN,
        HNREL,
        HFCON,
        HCORD,
        HCSUBO,
        HMODUL,
        HTOPER,
        HSUCUR,
        HMDA,
        HPAP,
        HCTA,
        HOPER,
        HSUBOP,
        HFVAL,
        HCIMP1,
        HCREF,
        NULL
      FROM FSH016 a
      JOIN FST198 b
      ON a.HCMOD = b.TP1NRO1
      AND a.HTRAN = b.TP1NRO2
      WHERE b.TP1COD = 1
        AND b.TP1COD1 = 11159
        AND b.TP1CORR1 = 6
        AND b.TP1CORR2 = 1
        AND b.TP1CORR3 > 0
        AND a.PGCOD = 1 + UID * 0
        AND a.HSUCOR = 903
        AND a.HFCON = pd_fecpro
        AND a.HMODUL = 21
        AND a.HCORD = 10
        AND a.HTOPER <> 2
        AND a.HMDA = 0
        AND a.HPAP = 0
        AND a.HCSUBO = 1
        AND (
            (lc_bin01 IS NOT NULL AND SUBSTR(a.HCREF, 1, 9) = lc_bin01)
            OR
            (lc_bin02 IS NOT NULL AND SUBSTR(a.HCREF, 1, 9) = lc_bin02)
        ); -- rcuadros 2024.08.16

      COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error en sp_obtener_compras: ' || SQLERRM);
      pc_coderr := '33309';
      pc_msgerr := SQLERRM;
  END sp_obtener_compras;

  PROCEDURE sp_contar_compras(
      pd_fecini IN DATE,
      pd_fecfin IN DATE,
      pn_cuenta IN NUMBER,
      pn_conteo OUT NUMBER,
      pc_coderr OUT VARCHAR2,
      pc_msgerr OUT VARCHAR2
  ) IS

  BEGIN
      pc_coderr := '00000';
      pc_msgerr := '';
      pn_conteo := 0;

      SELECT COUNT(1) INTO pn_conteo
      FROM FSH016 a
      JOIN FST198 b
      ON a.HCMOD = b.TP1NRO1
      AND a.HTRAN = b.TP1NRO2
      WHERE b.TP1COD = 1
        AND b.TP1COD1 = 11159
        AND b.TP1CORR1 = 6
        AND b.TP1CORR2 = 1
        AND b.TP1CORR3 > 0
        AND a.PGCOD = 1 + UID * 0
        AND a.HSUCOR = 903
        AND a.HFCON >= pd_fecini
        AND a.HFCON <= pd_fecfin
        AND a.HMODUL = 21
        AND a.HCORD = 10
        AND a.HTOPER <> 2
        AND a.HMDA = 0
        AND a.HPAP = 0
        AND a.HCSUBO = 1
        AND a.HCTA = pn_cuenta;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en sp_contar_compras: ' || SQLERRM);
      pc_coderr := '33308';
      pc_msgerr := SQLERRM;

  END sp_contar_compras;
END PQ_CN_CASHBACK_REFERIDOS;
/

