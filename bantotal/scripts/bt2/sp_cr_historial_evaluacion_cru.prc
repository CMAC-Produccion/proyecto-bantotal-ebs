CREATE OR REPLACE PROCEDURE SP_CR_HISTORIAL_EVALUACION_CRU(V_PAIS           IN NUMBER,
                                                           V_TIPO_DOCUMENTO IN NUMBER,
                                                           V_DOCUMENTO      IN VARCHAR2,
                                                           V_USUARIO        IN VARCHAR2) AS
                                                           
    -- *********************************************************************************
    -- Nombre                     : SP_CR_HISTORIAL_EVALUACION_CRU
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.10.01
    -- Autor de Creación          : MILTON CORDOVA
    -- Descripcion                : Guarda historial por cada cnsulta de evaluacion
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 16/01/2025
    -- Autor de la Modificación   : MHUAMANIA
    -- Descripción de Modificación: Se modifica consulta para optimizar coste
    -- *********************************************************************************

  CURSOR SOLICITUDES IS
    SELECT PEPAIS,
           PETDOC,
           PENDOC,
           XWFEMPRESA,
           XWFSUCURSAL,
           XWFMODULO,
           XWFMONEDA,
           XWFPAPEL,
           XWFCUENTA,
           XWFOPERACION,
           XWFSUBOPE,
           XWFTIPOPE,
           XWFPRCINS
      FROM FSR008 T1, XWF700 T2
     WHERE T2.XWFEMPRESA = 1 and T1.CTNRO = T2.XWFCUENTA              --mhuamania 16/01/2025
       AND T1.PEPAIS = V_PAIS
       AND T1.PETDOC = V_TIPO_DOCUMENTO
       AND T1.PENDOC = RPAD(V_DOCUMENTO, 12, ' ')
       AND T2.XWFCAR3 = '1';
  V_SNG001ASE  CHAR(10);
  V_UBNOM      CHAR(100);
  V_SNG120FPAG DATE;
  V_SNG031TXT  CHAR(400);
  V_FECHA      DATE;
  V_HORA       CHAR(8);
  V_SNG055DSC  CHAR(30);
BEGIN
  --  V_FECHA := TO_DATE(SYSDATE, 'DD/MM/YYYY', 'NLS_DATE_LANGUAGE = American');
  V_FECHA := TO_DATE(SYSDATE, 'DD/MM/YYYY');
  V_HORA  := TO_CHAR(SYSDATE, 'hh24:mi:ss');
  DELETE FROM AQPC229
   WHERE AQPC229PAI = V_PAIS
     AND AQPC229TIP = V_TIPO_DOCUMENTO
     AND AQPC229DOC = RPAD(V_DOCUMENTO, 12, ' ');
  COMMIT;
  FOR X IN SOLICITUDES LOOP
    BEGIN
      SELECT T1.SNG001ASE, T2.UBNOM
        INTO V_SNG001ASE, V_UBNOM
        FROM SNG001 T1, FST746 T2
       WHERE T1.SNG001ASE = T2.UBUSER
         AND SNG001INST = X.XWFPRCINS;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT SNG055DSC
        INTO V_SNG055DSC
        FROM SNG057 T1, SNG055 T2
       WHERE T1.SNG055CAR = T2.SNG055CAR
         AND SNG057USR = V_SNG001ASE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      V_SNG120FPAG := TO_DATE('01/01/0001', 'DD/MM/YYYY');
      SELECT SNG120FPAG
        INTO V_SNG120FPAG
        FROM SNG120
       WHERE SNG120INS = X.XWFPRCINS
         AND SNG120TSK = 'EVALUACION';
         
      IF V_SNG120FPAG = TO_DATE('01/01/0001', 'DD/MM/YYYY') THEN
        SELECT SNG021FEC
          INTO V_SNG120FPAG
          FROM SNG021
         WHERE SNG021SOL = X.XWFPRCINS;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT SNG031TXT
        INTO V_SNG031TXT
        FROM SNG031
       WHERE SNG001INST = X.XWFPRCINS
         AND SNG027COD = 74;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      INSERT INTO AQPC229 a
        (a.aqpc229fec,
         a.aqpc229hor,
         a.aqpc229usu,
         a.aqpc229ins,
         a.aqpc229pai,
         a.aqpc229tip,
         a.aqpc229doc,
         a.aqpc229uss,
         a.aqpc229nom,
         a.aqpc229car,
         a.aqpc229fee,
         a.aqpc229des,
         a.aqpc229au1,
         a.aqpc229au2,
         a.aqpc229au3)
      VALUES
        (V_FECHA,
         V_HORA,
         V_USUARIO,
         X.XWFPRCINS,
         V_PAIS,
         V_TIPO_DOCUMENTO,
         V_DOCUMENTO,
         V_SNG001ASE,
         V_UBNOM,
         V_SNG055DSC,
         V_SNG120FPAG,
         V_SNG031TXT,
         '',
         '',
         '');
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
END;
 /* GOLDENGATE_DDL_REPLICATION */
/

