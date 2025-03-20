CREATE OR REPLACE PROCEDURE SP_ACTIVAS_OBTIENE_JAQA400(
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
P_D_FEC OUT DATE,
P_C_HOR OUT VARCHAR2,
P_C_USU OUT VARCHAR2)
AS
-- *****************************************************************
-- Nombre                     : SP_ACTIVAS_OBTIENE_JAQA400
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : MITLON CORDOVA - IGS
-- Uso                        : OBTIENE DATOS JAQA400
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_INS
-- Retorno                    : P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP,
--                              P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_D_FEC,
--                              P_C_HOR, P_C_USU
-- *****************************************************************
BEGIN
   SELECT
   jaqa400emp, jaqa400mod, jaqa400suc, jaqa400mda, jaqa400pap, jaqa400cta, jaqa400ope, jaqa400sbo, jaqa400top, jaqa400fec, jaqa400ac2, jaqa400uss
   INTO P_N_EMP, P_N_MOD, P_N_SUC, P_N_MDA, P_N_PAP, P_N_CTA, P_N_OPE, P_N_SBO, P_N_TOP, P_D_FEC, P_C_HOR, P_C_USU
   FROM JAQA400
   WHERE jaqa400ai1 = P_N_INS AND jaqa400est = 'E' AND JAQA400FEC = (SELECT MAX(JAQA400FEC)FROM JAQA400 WHERE
         jaqa400ai1 = P_N_INS AND jaqa400est = 'E') AND ROWNUM = 1;
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
  WHEN OTHERS THEN NULL;
END SP_ACTIVAS_OBTIENE_JAQA400;
/

