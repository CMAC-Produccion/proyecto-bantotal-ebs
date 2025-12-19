CREATE OR REPLACE PROCEDURE SP_ACTIVAS_MNT_AQPC204(
P_N_CO1 IN NUMBER,
P_C_VRE IN VARCHAR2,
P_N_CO2 IN NUMBER,
P_C_NOM IN VARCHAR2,
P_C_RUT IN VARCHAR2,
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
-- Nombre                     : SP_ACTIVAS_MNT_AQPC204
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : MITLON CORDOVA - IGS
-- Uso                        : MANTENIMIENTO GENERAL - AQPC204
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_CO1, P_C_VRE, P_N_CO2, P_C_NOM, P_C_RUT, P_C_AC1,
--                              P_C_AC2, P_N_AN1, P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC,
--                              P_C_HOR, P_C_USU, P_C_MOD
-- Retorno                    : P_C_CODERR, P_C_DESERR
-- Fecha de Modificacion      : 28/10/2025
-- Autor de Modificacion      : RCASTRO
-- Uso                        : Se modifica logica de eliminacion de reg. en aqpc203
-- *****************************************************************
AS
L_BFILE BFILE;
L_BLOB BLOB;
P_N_CO2_2 NUMBER(17);
P_C_FLAG VARCHAR2(1);
P_C_FLAG_AQPC203 VARCHAR2(1);
P_C_FLAG_AQPC204 VARCHAR2(1);
BEGIN
  BEGIN
    IF P_N_CO2 IS NULL OR P_N_CO2 = 0 THEN
      SELECT NVL(MAX(AQPC204CO2), 0) + 1 INTO P_N_CO2_2 FROM AQPC204 WHERE AQPC204CO1 = P_N_CO1 AND AQPC204VRE = P_C_VRE;
    END IF;
  END;
  BEGIN
    IF P_C_MOD = 'INS' THEN
      L_BFILE := BFILENAME(P_C_RUT, P_C_NOM);
      IF P_C_NOM IS NOT NULL THEN
        BEGIN
          SELECT 'S' INTO P_C_FLAG FROM AQPC204 WHERE AQPC204CO1 = P_N_CO1 AND AQPC204VRE = P_C_VRE AND AQPC204NOM = P_C_NOM;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN 
          P_C_FLAG   := 'N';
        END;
        IF P_C_FLAG = 'N' THEN  
          BEGIN     
          IF DBMS_LOB.FILEEXISTS(L_BFILE) = 1 THEN
            INSERT INTO AQPC204(AQPC204CO1, AQPC204VRE, AQPC204CO2, AQPC204NOM, AQPC204ARC, AQPC204AC1, AQPC204AC2,
            AQPC204AN1, AQPC204AN2, AQPC204AD1, AQPC204AD2, AQPC204FEC, AQPC204HOR, AQPC204USU)
            VALUES(P_N_CO1, P_C_VRE, P_N_CO2_2, P_C_NOM, EMPTY_BLOB(), P_C_AC1, P_C_AC2, P_N_AN1,
            P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU) RETURN AQPC204ARC INTO L_BLOB;

            DBMS_LOB.fileopen(L_BFILE, Dbms_Lob.File_Readonly);
            DBMS_LOB.loadfromfile(L_BLOB, L_BFILE, DBMS_LOB.getlength(L_BFILE));
            DBMS_LOB.fileclose(L_BFILE);
            COMMIT;
            P_C_CODERR := '000';
            --P_C_DESERR := 'Registro ingresado exitosamente.';
          ELSIF DBMS_LOB.FILEEXISTS(L_BFILE) = 0 THEN
            P_C_CODERR := '000';
            P_C_DESERR := 'Archivo no existe en directorio.';
          END IF;
          EXCEPTION
            WHEN OTHERS THEN NULL;
            P_C_CODERR := '000';
            P_C_DESERR := 'No se ingreso registro.';
          END;
        ELSE
          P_C_CODERR := '002';
          P_C_DESERR := 'El nombre del archivo ya se encuentra registrado.';               
        END IF;
      ELSE
          P_C_CODERR := '000';
          P_C_DESERR := 'No existe archivo a registrar.';  
      END IF;
    ELSIF P_C_MOD = 'DEL' THEN 
      BEGIN   
      DELETE FROM AQPC204 WHERE AQPC204CO1 = P_N_CO1 AND AQPC204VRE = P_C_VRE;
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      P_C_CODERR := '000';
      P_C_DESERR := 'Registro eliminado exitosamente.'; 
     /* BEGIN
      SELECT 'S' INTO P_C_FLAG_AQPC203 FROM AQPC203 WHERE AQPC203COR = P_N_CO1;      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_C_FLAG_AQPC203 := 'N';
      END;
      BEGIN
          SELECT 'S' INTO P_C_FLAG_AQPC204 FROM AQPC204 WHERE AQPC204CO1 = P_N_CO1; 
      EXCEPTION
          WHEN NO_DATA_FOUND THEN 
            P_C_FLAG_AQPC204 := 'N'; 
      END;
      IF P_C_FLAG_AQPC203 = 'N' AND P_C_FLAG_AQPC204 = 'N' THEN
         DELETE FROM AQPC202 WHERE AQPC202COR = P_N_CO1;
         COMMIT;
      END IF; 
      */
    END IF;
  END;
EXCEPTION
  WHEN OTHERS THEN NULL;
  P_C_CODERR := '001';
  P_C_DESERR := 'Error, Verifique los datos ingresados.';
  COMMIT;
END SP_ACTIVAS_MNT_AQPC204;
/
