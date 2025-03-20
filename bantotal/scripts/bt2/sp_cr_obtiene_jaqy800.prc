CREATE OR REPLACE PROCEDURE SP_CR_OBTIENE_JAQY800(
P_N_INS IN  NUMBER,
P_N_EMP OUT NUMBER,
P_N_MOD OUT NUMBER,
P_N_SUC OUT NUMBER,
P_N_MDA OUT NUMBER,
P_N_PAP OUT NUMBER,
P_N_CTA OUT NUMBER,
P_N_OPE OUT NUMBER,
P_N_SBO OUT NUMBER,
P_N_TOP OUT NUMBER,
P_C_MOD IN VARCHAR2,
P_C_CODERR OUT VARCHAR2,
P_C_DESERR OUT VARCHAR2)
AS
-- *****************************************************************
-- Nombre                     : SP_CR_OBTIENE_JAQY800
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : MITLON CORDOVA - IGS
-- Uso                        : OBTIENE DATOS JAQY800
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_INS, P_C_MOD
-- Retorno                    : P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP,
--                              P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP
BEGIN
  IF P_C_MOD = 'PRI' THEN
    BEGIN
      SELECT jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope
      INTO P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP
      FROM JAQY800 WHERE jaqy800ins = P_N_INS AND jaqy800tpc = 'P' AND JAQY800MOD = 117 AND JAQY800VINC = 'S';
      P_C_CODERR := '000';
      P_C_DESERR := 'JAQY800-INSTANCIA DE CRÉDITO ENCONTRADA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      P_C_CODERR := '001';
      P_C_DESERR := 'JAQY800-NO EXISTEN RESULTADOS PARA LA BÚSQUEDA';
    END;  
  ELSIF P_C_MOD = 'ADI' THEN
    BEGIN
      SELECT jaqy800pgcd, jaqy800mod, jaqy800suc, jaqy800mda, jaqy800pap, jaqy800cta, jaqy800ope, jaqy800sbop, jaqy800tope
      INTO P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP
      FROM JAQY800 WHERE jaqy800ins = P_N_INS AND jaqy800tpc = 'A' AND JAQY800MOD = 117;
      P_C_CODERR := '000';
      P_C_DESERR := 'JAQY800-INSTANCIA DE CRÉDITO ENCONTRADA';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      P_C_CODERR := '001';
      P_C_DESERR := 'JAQY800-NO EXISTEN RESULTADOS PARA LA BÚSQUEDA';
    END;  
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
  P_C_CODERR := '001';
  P_C_DESERR := 'JAQY800-NO EXISTEN RESULTADOS PARA LA BÚSQUEDA';
END SP_CR_OBTIENE_JAQY800;
/

