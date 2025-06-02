CREATE OR REPLACE PACKAGE PQ_CN_TIPO_CAMBIO IS

  -- *****************************************************************
  -- Nombre                      : PQ_CN_TIPO_CAMBIO
  -- Sistema                     : BANTOTAL
  -- M�dulo                      : CANALES
  -- Versi�n                     : 1.0
  -- Fecha de Creaci�n           : 2025.02.10
  -- Autor de Creaci�n           : Renzo Cuadros Salazar
  -- Uso                         : Obtener / Insertar tipo de cambio por Pizarra
  -- Estado                      : Activo
  -- Acceso                      : P�blico
  -- Fecha de la Modificaci�n    :
  -- Autor de la Modificaci�n    :
  -- Descripci�n la Modificaci�n :
  -- *****************************************************************

  PROCEDURE sp_cn_obtener_tc(pn_pizarr IN NUMBER,
                             pd_pgfape IN DATE,
                             pn_tccomp OUT NUMBER,
                             pn_tcvent OUT NUMBER,
                             pc_coderr OUT VARCHAR2,
                             pc_msgerr OUT VARCHAR2
                             );

  PROCEDURE sp_cn_insertar_tc(pn_pizarr IN NUMBER,
                              pd_pgfape IN DATE,
                              pn_tccomp IN NUMBER,
                              pn_tcvent IN NUMBER,
                              pc_coderr OUT VARCHAR2,
                              pc_msgerr OUT VARCHAR2
                              );
END PQ_CN_TIPO_CAMBIO;
/
CREATE OR REPLACE PACKAGE BODY PQ_CN_TIPO_CAMBIO IS

  PROCEDURE sp_cn_obtener_tc(
      pn_pizarr IN NUMBER,
      pd_pgfape IN DATE,
      pn_tccomp OUT NUMBER,
      pn_tcvent OUT NUMBER,
      pc_coderr OUT VARCHAR2,
      pc_msgerr OUT VARCHAR2
  ) IS
  
  BEGIN
      pn_tccomp := 0;
      pn_tcvent := 0;
      
      pc_coderr := '00000';
      pc_msgerr := '';
      
      SELECT TCCPA, TCVTA
        INTO PN_TCCOMP, PN_TCVENT
        FROM (SELECT TCCPA, TCVTA
                FROM FSD120
               WHERE TCCOD = pn_pizarr
                 AND TCMDA = 101
                 AND TCFCH <= pd_pgfape
                 AND TCCPA > 0
                 AND TCVTA > 0
              ORDER BY TCFCH DESC, TCHOR DESC, TCIMP DESC)
       WHERE ROWNUM = 1;
     
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error en sp_cn_obtener_tc: ' || SQLERRM);
      pc_coderr := '31901';
      pc_msgerr := SUBSTR(SQLERRM, 1, 200);
  END sp_cn_obtener_tc;

  PROCEDURE sp_cn_insertar_tc(
      pn_pizarr IN NUMBER,
      pd_pgfape IN DATE,      
      pn_tccomp IN NUMBER,
      pn_tcvent IN NUMBER,
      pc_coderr OUT VARCHAR2,
      pc_msgerr OUT VARCHAR2
  ) IS

  BEGIN
      pc_coderr := '00000';
      pc_msgerr := '';
      
      BEGIN
        INSERT INTO FSD120 (TCCOD, TCMDA, TCFCH, TCHOR, TCIMP, TCCPA, TCVTA, TCTOLC, TCTOLV, TCARBCPA, TCARBVTA, TCARBTOL, TCARBCNT, TCFHINV)
        VALUES (
            pn_pizarr,
            101,
            pd_pgfape,
            TO_CHAR(SYSDATE, 'HH24:MI:SS'),
            9999999999999,
            pn_tccomp,
            pn_tcvent,
            0,
            0,
            1,
            1,
            0,
            0,
            99999999999999 - TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'))
        );
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          INSERT INTO FSD120 (TCCOD, TCMDA, TCFCH, TCHOR, TCIMP, TCCPA, TCVTA, TCTOLC, TCTOLV, TCARBCPA, TCARBVTA, TCARBTOL, TCARBCNT, TCFHINV)
          VALUES (
              pn_pizarr,
              101,
              pd_pgfape,
              TO_CHAR(SYSDATE + INTERVAL '1' SECOND, 'HH24:MI:SS'),
              9999999999999,
              pn_tccomp,
              pn_tcvent,
              0,
              0,
              1,
              1,
              0,
              0,
              99999999999999 - TO_NUMBER(TO_CHAR(SYSDATE + INTERVAL '1' SECOND, 'YYYYMMDDHH24MISS'))
          );
      END;
      
      COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error en sp_cn_insertar_tc: ' || SQLERRM);
      pc_coderr := '31902';
      pc_msgerr := SUBSTR(SQLERRM, 1, 200);

  END sp_cn_insertar_tc;
END PQ_CN_TIPO_CAMBIO;
/
