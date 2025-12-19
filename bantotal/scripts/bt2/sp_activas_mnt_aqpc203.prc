CREATE OR REPLACE PROCEDURE SP_ACTIVAS_MNT_AQPC203(
P_N_COR IN NUMBER,
P_C_VRE IN VARCHAR2,
P_C_DRE IN VARCHAR2,
P_C_EST IN VARCHAR2,
P_C_ESX IN VARCHAR2,
P_C_COM IN VARCHAR2,
P_D_FEX IN DATE,
P_C_HEX IN VARCHAR2,
P_C_UEX IN VARCHAR2,
P_C_AC1 IN VARCHAR2,
P_C_AC2 IN VARCHAR2,
P_N_AN1 IN NUMBER,
P_N_AN2 IN NUMBER,
P_D_AD1 IN DATE,
P_D_AD2 IN DATE,
P_D_FEC IN DATE,
P_C_HOR IN VARCHAR2,
P_C_USU IN VARCHAR2,
P_C_MOD IN VARCHAR2,
P_C_CODERR OUT VARCHAR2,
P_C_DESERR OUT VARCHAR2)
-- *****************************************************************
-- Nombre                     : SP_ACTIVAS_MNT_AQPC203
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : MITLON CORDOVA - IGS
-- Uso                        : MANTENIMIENTO GENERAL - AQPC203
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_COR, P_C_VRE, P_C_DRE, P_C_EST, P_C_ESX,
--                              P_C_COM, P_D_FEX, P_C_HEX, P_C_UEX, P_C_AC1,
--                              P_C_AC2, P_N_AN1, P_N_AN2, P_D_AD1, P_D_AD2,
--                              P_D_FEC, P_C_HOR, P_C_USU, P_C_MOD
--
-- Retorno                    : P_C_CODERR, P_C_DESERR
-- Fecha de Modificacion      : 28/10/2025
-- Autor de Modificacion      : rcastro
-- Uso                        : Se agrega campos adicionales a AQPC203
-- Fecha de Modificacion      : 04/11/2025
-- Autor de Modificacion      : rcastro
-- Uso                        : Se modifica logica de aqpc203
-- Fecha de Modificacion      : 20/11/2025
-- Autor de Modificacion      : rcastro
-- Uso                        : Se ajusta carga de aqpc203
-- *****************************************************************
AS
P_C_FLA_1 VARCHAR(1);
V_TEXT_CARGOS VARCHAR2(40);
V_TEXT_PERFILES VARCHAR2(50);
V_INSTANCIA NUMBER(10);
V_NROREGLA_ASIGN NUMBER(5);
V_TIPOREPROG NUMBER(5);
BEGIN
  IF P_C_MOD = 'INS' THEN
    BEGIN
      SELECT 'S' INTO P_C_FLA_1 FROM AQPC203 WHERE
      AQPC203COR = P_N_COR AND
      AQPC203VRE = P_C_VRE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_C_FLA_1 := 'N';
    END;      
    IF P_C_FLA_1 = 'N' THEN
      ----  28/10/2025
      BEGIN
        SELECT A.AQPC202INS INTO V_INSTANCIA FROM AQPC202 A WHERE A.AQPC202COR = P_N_COR;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;        
      END;
      
      BEGIN
        SELECT
          JAQA400AN1 -- 93,94 O 95                    
         INTO V_NROREGLA_ASIGN
         FROM JAQA400
         WHERE jaqa400ai1 = V_INSTANCIA AND jaqa400est = 'E' AND JAQA400FEC = (SELECT MAX(JAQA400FEC)FROM JAQA400 WHERE
               jaqa400ai1 = V_INSTANCIA AND jaqa400est = 'E') AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          V_NROREGLA_ASIGN := 0;
      END;
      V_NROREGLA_ASIGN := NVL(V_NROREGLA_ASIGN, 0);
      
      BEGIN
        SELECT AQPB955CCAR, AQPB955PERFI INTO V_TEXT_CARGOS, V_TEXT_PERFILES  FROM AQPB955 W WHERE W.AQPB955COD = V_INSTANCIA  AND W.AQPB955REG = P_C_VRE;
      EXCEPTION
        WHEN OTHERS THEN
          V_TEXT_CARGOS := '';
          V_TEXT_PERFILES := '';
      END;    
      
      BEGIN
        SELECT D.AQPC780TPREPR INTO V_TIPOREPROG FROM AQPC780 D WHERE  D.AQPC780NUMRGL = V_NROREGLA_ASIGN AND D.AQPC780NOMVAR = P_C_VRE;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_TIPOREPROG := NVL(V_TIPOREPROG, 0);
      --P_N_AN1 := NVL(V_TIPOREPROG, 0);
      --P_C_AC1 := TRIM(V_TEXT_CARGOS);
      --P_C_AC2 := TRIM(V_TEXT_PERFILES);
      ------
      BEGIN 
      INSERT INTO AQPC203(AQPC203COR, AQPC203VRE, AQPC203DRE, AQPC203EST, AQPC203ESX, AQPC203COM, AQPC203FEX, AQPC203HEX,
      AQPC203UEX, AQPC203AC1, AQPC203AC2, AQPC203AN1, AQPC203AN2, AQPC203AD1, AQPC203AD2, AQPC203FEC, AQPC203HOR, AQPC203USU)
      VALUES(P_N_COR, P_C_VRE, P_C_DRE, P_C_EST, P_C_ESX, P_C_COM, P_D_FEX, P_C_HEX, P_C_UEX,
      V_TEXT_CARGOS, V_TEXT_PERFILES, V_TIPOREPROG, P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU);
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;          
      END;
      P_C_CODERR := '000';
      --P_C_DESERR := 'Registro ingresado exitosamente.';
    ELSE
 
      BEGIN
        UPDATE AQPC203 
        SET AQPC203COM = P_C_COM
        WHERE 
        AQPC203COR = P_N_COR AND
        AQPC203VRE = P_C_VRE;
        COMMIT;
        P_C_CODERR := '000';        
      EXCEPTION
        WHEN OTHERS THEN
          NULL;          
      END; 
      P_C_CODERR := '000';
      --P_C_DESERR := 'Registro existente.'; 
    END IF;   
  ELSIF P_C_MOD = 'DEL' THEN  
    BEGIN 
      DELETE FROM AQPC203 WHERE AQPC203COR = P_N_COR AND AQPC203VRE = P_C_VRE;
      COMMIT;      
      P_C_CODERR := '000';
      P_C_DESERR := 'Registro eliminado exitosamente.';            
    EXCEPTION 
      WHEN OTHERS THEN
          P_C_CODERR := '000';
          P_C_DESERR := 'Hubo un error al eliminar registro.';  
    END;  
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
  P_C_CODERR := '001';
  P_C_DESERR := 'Error, Verifique los datos ingresados.';
  COMMIT;
END SP_ACTIVAS_MNT_AQPC203;
/
