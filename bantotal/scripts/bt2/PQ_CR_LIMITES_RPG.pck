create or replace package PQ_CR_LIMITES_RPG is

-- *****************************************************************
-- Nombre   : PQ_CR_REGISTRO_ACTA_DIGITAL
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 13/06/2025
-- Autor de Creación  : MCORDOVA
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************

  PROCEDURE SP_CR_VALIDA_LIMITE_REGION(PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
end PQ_CR_LIMITES_RPG;
/
create or replace package body PQ_CR_LIMITES_RPG is

   PROCEDURE SP_CR_VALIDA_LIMITE_REGION(PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
   IS
    ESTADO VARCHAR2(1);
   BEGIN
    BEGIN
      PQ_CR_CNTRL_LIMITREPRO.sp_Cr_Inicio(PI_INSTANCIA,2,ESTADO); 
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF;
   END; 
end PQ_CR_LIMITES_RPG;


--CF_CRD_VAL_LIM_REG
/
