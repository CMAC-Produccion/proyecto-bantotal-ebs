CREATE OR REPLACE PACKAGE PQ_CR_RESOLUTOR_REFINANCADOS IS

  PROCEDURE SP_CR_VERIFICA_EVAL(P_INSTANCIA           IN NUMBER,
                                P_USUARIO             in VARCHAR2,
                                PO_ACTIVO_ANTERIOR    OUT NUMBER,
                                PO_ACTIVO_ACTUAL      OUT NUMBER,
                                PO_VENTAS_ANTERIOR    OUT NUMBER,
                                PO_VENTAS_ACTUAL      OUT NUMBER,
                                PO_UTILIDADB_ANTERIOR OUT NUMBER,
                                PO_UTILIDADB_ACTUAL   OUT NUMBER,
                                PO_RESPUESTA          OUT VARCHAR2);

END PQ_CR_RESOLUTOR_REFINANCADOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_RESOLUTOR_REFINANCADOS IS
  -- *****************************************************************
  -- NOMBRE                     : PQ_CR_RESOLUTOR_REFINANCADOS
  -- SISTEMA                    : BANTOTAL
  -- MODULO                     : CREDITOS - ACTIVAS
  -- VERSION                    : 1.0
  -- FECHA DE CREACION          : 18/11/2024 
  -- AUTOR DE CREACION          : CALARCONAP
  -- DESCRIPCION                : PAQUETE PARA RESOLUOR DE REFINANCIADOS 
  -- ESTADO                     : ACTIVO
  -- ACCESO                     : PUBLICO
  -- *****************************************************************

  PROCEDURE SP_CR_VERIFICA_EVAL(P_INSTANCIA           IN NUMBER,
                                P_USUARIO             in VARCHAR2,
                                PO_ACTIVO_ANTERIOR    OUT NUMBER,
                                PO_ACTIVO_ACTUAL      OUT NUMBER,
                                PO_VENTAS_ANTERIOR    OUT NUMBER,
                                PO_VENTAS_ACTUAL      OUT NUMBER,
                                PO_UTILIDADB_ANTERIOR OUT NUMBER,
                                PO_UTILIDADB_ACTUAL   OUT NUMBER,
                                PO_RESPUESTA          OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                     : SP_CR_VERIFICA_EVAL
    -- SISTEMA                    : BANTOTAL
    -- MODULO                     : CREDITOS - ACTIVAS
    -- VERSION                    : 1.0
    -- FECHA DE CREACION          : 18/11/2024 
    -- AUTOR DE CREACION          : CALARCONAP
    -- DESCRIPCION                : RETORNA VARIABLES DE MONTO EN SOLES DE VENTAS, ACTIVOS Y UTILIDAD BRUTA
    -- ESTADO                     : ACTIVO
    -- ACCESO                     : PUBLICO
    -- *****************************************************************
  
    VN_PAIS       NUMBER(3);
    VN_TDOCUMENTO NUMBER(2);
    VC_DNI        CHAR(12);
  
    VN_MODELO_EVA NUMBER;
    VN_EVAL       NUMBER(10);
  
    VN_INSTANCIA_ANT NUMBER(10);
    VN_EVAL_ANT      NUMBER(10);
  
    VN_ACTIVO_ANTERIOR_SOLES    NUMBER(17, 2);
    VN_VENTAS_ANTERIOR_SOLES    NUMBER(17, 2);
    VN_UTILIDADB_ANTERIOR_SOLES NUMBER(17, 2);
    VN_ACTIVO_ANTERIOR_DOLAR    NUMBER(17, 2);
    VN_VENTAS_ANTERIOR_DOLAR    NUMBER(17, 2);
    VN_UTILIDADB_ANTERIOR_DOLAR NUMBER(17, 2);
  
    VN_ACTIVO_ACTUAL_SOLES    NUMBER(17, 2);
    VN_VENTAS_ACTUAL_SOLES    NUMBER(17, 2);
    VN_UTILIDADB_ACTUAL_SOLES NUMBER(17, 2);
    VN_ACTIVO_ACTUAL_DOLAR    NUMBER(17, 2);
    VN_VENTAS_ACTUAL_DOLAR    NUMBER(17, 2);
    VN_UTILIDADB_ACTUAL_DOLAR NUMBER(17, 2);
  
    VN_TIPO_CAMBIO NUMBER(14, 8);
    -----------------------------
  
  BEGIN
    PO_RESPUESTA := 'Ok';
  
    PO_ACTIVO_ANTERIOR    := 0;
    PO_VENTAS_ANTERIOR    := 0;
    PO_UTILIDADB_ANTERIOR := 0;
  
    PO_ACTIVO_ACTUAL    := 0;
    PO_VENTAS_ACTUAL    := 0;
    PO_UTILIDADB_ACTUAL := 0;
  
    VN_ACTIVO_ANTERIOR_SOLES    := 0;
    VN_VENTAS_ANTERIOR_SOLES    := 0;
    VN_UTILIDADB_ANTERIOR_SOLES := 0;
    VN_ACTIVO_ANTERIOR_DOLAR    := 0;
    VN_VENTAS_ANTERIOR_DOLAR    := 0;
    VN_UTILIDADB_ANTERIOR_DOLAR := 0;
  
    VN_ACTIVO_ACTUAL_SOLES    := 0;
    VN_VENTAS_ACTUAL_SOLES    := 0;
    VN_UTILIDADB_ACTUAL_SOLES := 0;
    VN_ACTIVO_ACTUAL_DOLAR    := 0;
    VN_VENTAS_ACTUAL_DOLAR    := 0;
    VN_UTILIDADB_ACTUAL_DOLAR := 0;
  
    VN_INSTANCIA_ANT := 0;
  
    BEGIN
    
      select p.sng001pais, p.sng001tdoc, p.sng001ndoc
        INTO VN_PAIS, VN_TDOCUMENTO, VC_DNI
        from sng001 p
       where p.sng001inst = P_INSTANCIA;
    exception
      /*     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos.');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió otro error: ' || SQLERRM);*/
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
        --DBMS_OUTPUT.PUT_LINE('Ocurrió otro error: ' || SQLERRM);
    END;
  
    BEGIN
      select A.SNG021TMOD, A.SNG021EVAL
        INTO VN_MODELO_EVA, VN_EVAL
        from sng021 a
       where a.sng021sol = P_INSTANCIA;
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
    BEGIN
    
      select max(sng001inst)
        INTO VN_INSTANCIA_ANT
        from sng001 a, xwf070 b, sng021 c
       WHERE a.sng001inst = b.xwfprcin
         and b.xwfprcin = c.sng021sol
         and a.sng001pais = VN_PAIS
         and a.sng001tdoc = VN_TDOCUMENTO
         and a.sng001ndoc = VC_DNI
         and b.xwfcont = 'S'
         and c.sng021tmod = VN_MODELO_EVA;
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
    BEGIN
      select A.SNG021EVAL
        INTO VN_EVAL_ANT
        from sng021 a
       where a.sng021sol = VN_INSTANCIA_ANT;
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
    BEGIN
      SELECT CASE
               WHEN SNG120TCBI IS NOT NULL AND SNG120TCBI <> 0 THEN
                SNG120TCBI
               ELSE
                fn_tipo_cambio_fijo(e.PGFAPE)
             END
        INTO VN_TIPO_CAMBIO
        FROM Fst017 e
        LEFT JOIN SNG120 T
          on T.SNG120INS = P_INSTANCIA
         AND T.SNG120TSK = 'EVALUACION'
       WHERE e.pgcod = 1
         AND ROWNUM = 1;
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
    begin
      for F_R in (SELECT SNG021SOL,
                         SNG021EVAL,
                         VENTA_S,
                         VENTA_D,
                         ACTIVO_S,
                         ACTIVO_D,
                         UTILB_S,
                         UTILB_D
                    FROM (SELECT SNG021SOL,
                                 S.SNG021EVAL,
                                 S.SNG026COD,
                                 S.SNG023MTO
                            FROM sng021 I
                           inner JOIN SNG023 S
                              ON S.SNG021EVAL = I.SNG021EVAL
                           WHERE (SNG021SOL = VN_INSTANCIA_ANT or
                                 SNG021SOL = P_INSTANCIA)
                             AND S.SNG026COD IN (73, 573, 52, 552, 75, 575))
                  PIVOT(max(SNG023MTO)
                     FOR SNG026COD IN(73 AS VENTA_S,
                                     573 AS VENTA_D,
                                     52 AS ACTIVO_S,
                                     552 AS ACTIVO_D,
                                     75 AS UTILB_S,
                                     575 AS UTILB_D))) loop
      
        --INSTANCIA ANTERIOR
        IF F_R.SNG021SOL = VN_INSTANCIA_ANT THEN
        
          VN_ACTIVO_ANTERIOR_SOLES    := F_R.ACTIVO_S;
          VN_VENTAS_ANTERIOR_SOLES    := F_R.VENTA_S;
          VN_UTILIDADB_ANTERIOR_SOLES := F_R.UTILB_S;
          VN_ACTIVO_ANTERIOR_DOLAR    := F_R.ACTIVO_D;
          VN_VENTAS_ANTERIOR_DOLAR    := F_R.VENTA_D;
          VN_UTILIDADB_ANTERIOR_DOLAR := F_R.UTILB_D;
        
        ELSE
        
          VN_ACTIVO_ACTUAL_SOLES    := F_R.ACTIVO_S;
          VN_VENTAS_ACTUAL_SOLES    := F_R.VENTA_S;
          VN_UTILIDADB_ACTUAL_SOLES := F_R.UTILB_S;
          VN_ACTIVO_ACTUAL_DOLAR    := F_R.ACTIVO_D;
          VN_VENTAS_ACTUAL_DOLAR    := F_R.VENTA_D;
          VN_UTILIDADB_ACTUAL_DOLAR := F_R.UTILB_D;
        
        END IF;
      
      END LOOP;
    
      PO_ACTIVO_ANTERIOR    := VN_ACTIVO_ANTERIOR_SOLES +
                               (VN_ACTIVO_ANTERIOR_DOLAR * VN_TIPO_CAMBIO);
      PO_VENTAS_ANTERIOR    := VN_VENTAS_ANTERIOR_SOLES +
                               (VN_VENTAS_ANTERIOR_DOLAR * VN_TIPO_CAMBIO);
      PO_UTILIDADB_ANTERIOR := VN_UTILIDADB_ANTERIOR_SOLES +
                               (VN_UTILIDADB_ANTERIOR_DOLAR *
                               VN_TIPO_CAMBIO);
      PO_ACTIVO_ACTUAL      := VN_ACTIVO_ACTUAL_SOLES +
                               (VN_ACTIVO_ACTUAL_DOLAR * VN_TIPO_CAMBIO);
      PO_VENTAS_ACTUAL      := VN_VENTAS_ACTUAL_SOLES +
                               (VN_VENTAS_ACTUAL_DOLAR * VN_TIPO_CAMBIO);
      PO_UTILIDADB_ACTUAL   := VN_UTILIDADB_ACTUAL_SOLES +
                               (VN_UTILIDADB_ACTUAL_DOLAR * VN_TIPO_CAMBIO);
    
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
    BEGIN
      update AQPD855
         set aqpd855estad = 'E'
       WHERE aqpd855insta = P_INSTANCIA
         AND aqpd855estad = 'A';
    
      INSERT INTO AQPD855
        (aqpd855ident,
         aqpd855insta,
         aqpd855insan,
         aqpd855evalu,
         aqpd855evala,
         aqpd855tipoc,
         aqpd855actso,
         aqpd855actsa,
         aqpd855actdo,
         aqpd855actda,
         aqpd855venso,
         aqpd855vensa,
         aqpd855vendo,
         aqpd855venda,
         aqpd855utbso,
         aqpd855utbsa,
         aqpd855utbdo,
         aqpd855utbda,
         aqpd855actin,
         aqpd855ventn,
         aqpd855utiln,
         aqpd855actia,
         aqpd855venta,
         aqpd855utiba,
         aqpd855estad,
         aqpd855fecre,
         aqpd855usuar)
      VALUES
        (SEQ_RF_AQPD855.NEXTVAL,
         P_INSTANCIA,
         VN_INSTANCIA_ANT,
         VN_EVAL,
         VN_EVAL_ANT,
         VN_TIPO_CAMBIO,
         VN_ACTIVO_ACTUAL_SOLES,
         VN_ACTIVO_ANTERIOR_SOLES,
         VN_ACTIVO_ACTUAL_DOLAR,
         VN_ACTIVO_ANTERIOR_DOLAR,
         VN_VENTAS_ACTUAL_SOLES,
         VN_VENTAS_ANTERIOR_SOLES,
         VN_VENTAS_ACTUAL_DOLAR,
         VN_VENTAS_ANTERIOR_DOLAR,
         VN_UTILIDADB_ACTUAL_SOLES,
         VN_UTILIDADB_ANTERIOR_SOLES,
         VN_UTILIDADB_ACTUAL_DOLAR,
         VN_UTILIDADB_ANTERIOR_DOLAR,
         PO_ACTIVO_ACTUAL,
         PO_VENTAS_ACTUAL,
         PO_UTILIDADB_ACTUAL,
         PO_ACTIVO_ANTERIOR,
         PO_ACTIVO_ANTERIOR,
         PO_UTILIDADB_ANTERIOR,
         'A',
         CURRENT_TIMESTAMP,
         P_USUARIO);
    
      COMMIT;
    exception
      WHEN OTHERS THEN
        PO_RESPUESTA := SQLERRM;
    END;
  
  END SP_CR_VERIFICA_EVAL;

END PQ_CR_RESOLUTOR_REFINANCADOS;
/

