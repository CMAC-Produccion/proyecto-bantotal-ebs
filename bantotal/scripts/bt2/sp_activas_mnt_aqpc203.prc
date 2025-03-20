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
-- *****************************************************************
AS
P_C_FLA_1 VARCHAR(1);
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
      INSERT INTO AQPC203(AQPC203COR, AQPC203VRE, AQPC203DRE, AQPC203EST, AQPC203ESX, AQPC203COM, AQPC203FEX, AQPC203HEX,
      AQPC203UEX, AQPC203AC1, AQPC203AC2, AQPC203AN1, AQPC203AN2, AQPC203AD1, AQPC203AD2, AQPC203FEC, AQPC203HOR, AQPC203USU)
      VALUES(P_N_COR, P_C_VRE, P_C_DRE, P_C_EST, P_C_ESX, P_C_COM, P_D_FEX, P_C_HEX, P_C_UEX,
      P_C_AC1, P_C_AC2, P_N_AN1, P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU);
      COMMIT;
      P_C_CODERR := '000';
      P_C_DESERR := 'Registro ingresado exitosamente.';
    ELSE
      P_C_CODERR := '000';
      P_C_DESERR := 'Registro existente.';     
    END IF;   
  ELSIF P_C_MOD = 'DEL' THEN   
      DELETE FROM AQPC203 WHERE AQPC203COR = P_N_COR AND AQPC203VRE = P_C_VRE;
      COMMIT;
      P_C_CODERR := '000';
      P_C_DESERR := 'Registro eliminado exitosamente.';      
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
  P_C_CODERR := '001';
  P_C_DESERR := 'Error, Verifique los datos ingresados.';
  COMMIT;
END SP_ACTIVAS_MNT_AQPC203;
/

