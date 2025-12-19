CREATE OR REPLACE PROCEDURE SP_ACTIVAS_MNT_AQPC202(
P_N_EMP IN NUMBER,
P_N_MOD IN NUMBER,
P_N_SUC IN NUMBER,
P_N_MDA IN NUMBER,
P_N_PAP IN NUMBER,
P_N_CTA IN NUMBER,
P_N_OPE IN NUMBER,
P_N_SBO IN NUMBER,
P_N_TOP IN NUMBER,
P_N_INS IN NUMBER,
P_N_COR IN NUMBER,
P_C_AUT IN VARCHAR2,
P_C_CLI IN VARCHAR2,
P_C_PRO IN VARCHAR2,
P_N_SAL IN NUMBER,
P_C_EST IN VARCHAR2,
P_C_MSG IN VARCHAR2,
P_D_FEA IN DATE,
P_C_HOA IN VARCHAR2,
P_C_USA IN VARCHAR2,
P_C_AC1 IN VARCHAR2,
P_C_AC2 IN VARCHAR2,
P_N_AN1 IN NUMBER,
P_N_AN2 IN NUMBER,
P_D_AD1 IN DATE,
P_D_AD2 IN DATE,
P_D_FEC IN DATE,
P_C_HOR IN VARCHAR2,
P_C_USU IN VARCHAR2,
P_N_CO2 OUT NUMBER,
P_C_MOD IN VARCHAR2,
P_C_CODERR OUT VARCHAR2,
P_C_DESERR OUT VARCHAR2)
-- *****************************************************************
-- Nombre                     : SP_ACTIVAS_MNT_AQPC202
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : MITLON CORDOVA - IGS
-- Uso                        : MANTENIMIENTO GENERAL - AQPC202
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, 
--                              P_N_OPE, P_N_SBO, P_N_TOP, P_N_INS, P_N_COR, P_C_AUT, 
--                              P_C_CLI, P_C_PRO, P_N_SAL, P_C_EST, P_C_MSG, P_D_FEA, 
--                              P_C_HOA, P_C_USA, P_C_AC1, P_C_AC2, P_N_AN1, P_N_AN2, 
--                              P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU, P_C_MOD
--
-- Retorno                    : P_N_CO2, P_C_CODERR, P_C_DESERR                 : 
-- *****************************************************************
AS
P_N_COR_1 NUMBER(17);
P_C_FLA_1 VARCHAR(1);
P_C_FLA_2 VARCHAR2(1);
P_D_FEA_2 DATE;
P_C_HOA_2 VARCHAR2(8);
P_D_FEA_3 DATE;
P_C_HOA_3 VARCHAR2(8);
P_C_ESTADO_ENVIO VARCHAR2(1);
BEGIN
  BEGIN  
    SELECT DISTINCT NVL(MAX(AQPC202COR),0) INTO P_N_COR_1 FROM AQPC202 WHERE
    AQPC202EMP = P_N_EMP AND
    AQPC202MOD = P_N_MOD AND
    AQPC202SUC = P_N_SUC AND
    AQPC202MDA = P_N_MDA AND
    AQPC202PAP = P_N_PAP AND
    AQPC202CTA = P_N_CTA AND
    AQPC202OPE = P_N_OPE AND
    AQPC202SBO = P_N_SBO AND
    AQPC202TOP = P_N_TOP AND
    AQPC202INS = P_N_INS;
    P_C_CODERR := '000';
    P_C_DESERR := 'Correlativo obtenido.';
    P_N_CO2 := P_N_COR;
    P_N_CO2 := P_N_COR_1; 
  END;
  BEGIN
    IF P_C_MOD = 'INS' THEN
      BEGIN -- Valida si registro ya existe
        SELECT 'S', AQPC202EST INTO P_C_FLA_1, P_C_ESTADO_ENVIO FROM AQPC202 WHERE
        AQPC202EMP = P_N_EMP AND
        AQPC202MOD = P_N_MOD AND
        AQPC202SUC = P_N_SUC AND
        AQPC202MDA = P_N_MDA AND
        AQPC202PAP = P_N_PAP AND
        AQPC202CTA = P_N_CTA AND
        AQPC202OPE = P_N_OPE AND
        AQPC202SBO = P_N_SBO AND
        AQPC202TOP = P_N_TOP AND
        AQPC202INS = P_N_INS AND
        AQPC202COR = 
        (SELECT MAX(AQPC202COR) FROM AQPC202 WHERE
        AQPC202EMP = P_N_EMP AND
        AQPC202MOD = P_N_MOD AND
        AQPC202SUC = P_N_SUC AND
        AQPC202MDA = P_N_MDA AND
        AQPC202PAP = P_N_PAP AND
        AQPC202CTA = P_N_CTA AND
        AQPC202OPE = P_N_OPE AND
        AQPC202SBO = P_N_SBO AND
        AQPC202TOP = P_N_TOP AND
        AQPC202INS = P_N_INS);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_C_FLA_1 := 'N';
      END;
      
      IF P_C_FLA_1 = 'S' THEN -- Existe registro
        SELECT NVL(TRIM(AQPC202FEA), TO_DATE('01/01/0001', 'dd/mm/yyyy')), NVL(TRIM(AQPC202HOA), '00:00:00') INTO P_D_FEA_2, P_C_HOA_2
        FROM AQPC202 WHERE
        AQPC202INS = P_N_INS AND
        AQPC202COR = (SELECT MAX(AQPC202COR) FROM AQPC202 WHERE AQPC202INS = P_N_INS);

        SELECT NVL(TRIM(jaqa400fec), TO_DATE('01/01/0001', 'dd/mm/yyyy')), NVL(TRIM(jaqa400ac2), '00:00:00') INTO P_D_FEA_3, P_C_HOA_3
        FROM JAQA400 WHERE
        jaqa400ai1 = P_N_INS AND
        jaqa400est = 'E' AND
        JAQA400FEC = (SELECT MAX(JAQA400FEC)FROM JAQA400 WHERE jaqa400ai1 = P_N_INS AND jaqa400est = 'E');

        BEGIN
          IF P_D_FEA_2 <> P_D_FEA_3 OR P_C_HOA_2 <> P_C_HOA_3 THEN -- Registra si fecha y hora de tablas AQPC202 y JAQA400 son diferentes
            SELECT NVL(MAX(AQPC202COR), 0) + 1 INTO P_N_CO2 FROM AQPC202; -- Obtiene siguiente correlativo
            INSERT INTO AQPC202
            (AQPC202EMP, AQPC202MOD, AQPC202SUC, AQPC202MDA, AQPC202PAP, AQPC202CTA, AQPC202OPE, AQPC202SBO, AQPC202TOP, AQPC202INS,
            AQPC202COR, AQPC202AUT, AQPC202CLI, AQPC202PRO, AQPC202SAL, AQPC202EST, AQPC202MSG, AQPC202FEA, AQPC202HOA, AQPC202USA,
            AQPC202AC1, AQPC202AC2, AQPC202AN1, AQPC202AN2, AQPC202AD1, AQPC202AD2, AQPC202FEC, AQPC202HOR, AQPC202USU)
            VALUES(P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_N_INS,
            P_N_CO2, P_C_AUT, P_C_CLI, P_C_PRO, P_N_SAL, P_C_EST, P_C_MSG, P_D_FEA, P_C_HOA, P_C_USA, P_C_AC1,
            P_C_AC2, P_N_AN1, P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU);
            P_C_CODERR := '000';
            P_C_DESERR := 'Registro ingresado exitosamente.';
          ELSE
            If P_C_ESTADO_ENVIO = 'S' THEN
              P_C_CODERR := '001';
              P_C_DESERR := 'El registro fue enviado para autorizar, no puede agregar sustento(s).';  
            ELSE
              P_C_CODERR := '000';
              --P_C_DESERR := 'Registro existente';*/
            END IF;
          END IF;          
        END;
      ELSE -- No existe registro
        SELECT NVL(MAX(AQPC202COR), 0) + 1 INTO P_N_CO2 FROM AQPC202; -- Obtiene siguiente correlativo
        INSERT INTO AQPC202
        (AQPC202EMP, AQPC202MOD, AQPC202SUC, AQPC202MDA, AQPC202PAP, AQPC202CTA, AQPC202OPE, AQPC202SBO, AQPC202TOP, AQPC202INS,
        AQPC202COR, AQPC202AUT, AQPC202CLI, AQPC202PRO, AQPC202SAL, AQPC202EST, AQPC202MSG, AQPC202FEA, AQPC202HOA, AQPC202USA,
        AQPC202AC1, AQPC202AC2, AQPC202AN1, AQPC202AN2, AQPC202AD1, AQPC202AD2, AQPC202FEC, AQPC202HOR, AQPC202USU)
        VALUES(P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_N_INS,
        P_N_CO2, P_C_AUT, P_C_CLI, P_C_PRO, P_N_SAL, P_C_EST, P_C_MSG, P_D_FEA, P_C_HOA, P_C_USA, P_C_AC1,
        P_C_AC2, P_N_AN1, P_N_AN2, P_D_AD1, P_D_AD2, P_D_FEC, P_C_HOR, P_C_USU);
        P_C_CODERR := '000';
        P_C_DESERR := 'Registro ingresado exitosamente.'; 
      END IF;
    ELSIF P_C_MOD = 'DEL' THEN
      BEGIN
        SELECT AQPC202EST INTO P_C_FLA_2 FROM AQPC202 WHERE
        AQPC202EMP = P_N_EMP AND
        AQPC202MOD = P_N_MOD AND
        AQPC202SUC = P_N_SUC AND
        AQPC202MDA = P_N_MDA AND
        AQPC202PAP = P_N_PAP AND
        AQPC202CTA = P_N_CTA AND
        AQPC202OPE = P_N_OPE AND
        AQPC202SBO = P_N_SBO AND
        AQPC202TOP = P_N_TOP AND
        AQPC202INS = P_N_INS AND
        AQPC202COR = 
        (SELECT MAX(AQPC202COR) FROM AQPC202 WHERE
        AQPC202EMP = P_N_EMP AND
        AQPC202MOD = P_N_MOD AND
        AQPC202SUC = P_N_SUC AND
        AQPC202MDA = P_N_MDA AND
        AQPC202PAP = P_N_PAP AND
        AQPC202CTA = P_N_CTA AND
        AQPC202OPE = P_N_OPE AND
        AQPC202SBO = P_N_SBO AND
        AQPC202TOP = P_N_TOP AND
        AQPC202INS = P_N_INS);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        P_C_FLA_2 := 'X';
      END;       
      IF P_C_FLA_2 = 'P' THEN       
        P_C_CODERR := '000';
        P_C_DESERR := 'Registro eliminado exitosamente.';       
      ELSIF P_C_FLA_2 = 'S' THEN
        P_C_CODERR := '001';
        P_C_DESERR := 'El registro fue enviado para autorizar, no puede eliminar sustento(s).';                
      ELSIF P_C_FLA_2 = 'X' THEN
        P_C_CODERR := '001';
        P_C_DESERR := 'No existe sustento para eliminar.';  
      END IF;
    END IF;  
  END;
  COMMIT; 
EXCEPTION
  WHEN OTHERS THEN NULL;
  P_C_CODERR := '001';
  P_C_DESERR := 'Error, Verifique los datos ingresados.';
  P_N_CO2    := 0; 
END SP_ACTIVAS_MNT_AQPC202;
/
