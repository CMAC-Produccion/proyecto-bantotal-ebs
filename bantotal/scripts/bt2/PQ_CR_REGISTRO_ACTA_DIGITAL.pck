create or replace package PQ_CR_REGISTRO_ACTA_DIGITAL is

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
                                       
  PROCEDURE SP_CR_VALIDA_ACTA_CERRADA2(
                                       PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
                                      
  PROCEDURE SP_CR_VALIDA_ACTA_CERRADA(
                                       PI_ACTA IN CHAR,
                                       PI_INSTANCIA IN NUMBER,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);

  PROCEDURE SP_CR_MANTENEDOR_LOG_ACTA_DIGITAL(
                                        V_AQPC238INS IN NUMBER,
                                        V_AQPC238EMP IN NUMBER,
                                        V_AQPC238SUC IN NUMBER,
                                        V_AQPC238MOD IN NUMBER,
                                        V_AQPC238MDA IN NUMBER,
                                        V_AQPC238PAP IN NUMBER,
                                        V_AQPC238CTA IN NUMBER,
                                        V_AQPC238OPE IN NUMBER,
                                        V_AQPC238SOP IN NUMBER, 
                                        V_AQPC238TOP IN NUMBER,
                                        V_AQPC238COM IN VARCHAR,
                                        V_AQPC238CFE IN DATE,
                                        V_AQPC238CTC IN NUMBER,
                                        V_AQPC238CDC IN VARCHAR,
                                        V_AQPC238CES IN VARCHAR,
                                        V_AQPC238CNA IN VARCHAR,
                                        V_AQPC238FEC IN DATE,
                                        V_AQPC239USU IN VARCHAR,
                                        V_COD_ERROR OUT VARCHAR,
                                        V_MSG_ERROR OUT VARCHAR);
end PQ_CR_REGISTRO_ACTA_DIGITAL;
/
create or replace package body PQ_CR_REGISTRO_ACTA_DIGITAL is
-- *****************************************************************
-- Nombre                       : SP_CR_VALIDA_ACTA_CERRADA
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/07/2025
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 21/07/2025
-- Autor de la Modificación : MCORDOVA
-- Descripción de Modificación  : SE MODIFICA CONDICION DE INGRESO PARA VALIDAR ACTA DIGITAL
-- *****************************************************************

   -- VALIDA SI EXISTE ACTA, INGRESANDO POR CLAVE DE CREDITO
   PROCEDURE SP_CR_VALIDA_ACTA_CERRADA2(
                                       PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
   IS
    ESTADO VARCHAR2(1);
   BEGIN
    BEGIN     
      SELECT JAQM7CEST INTO ESTADO FROM JAQM7C T1 JOIN JAQM2D T2 ON
      T1.JAQM7CCOD = T2.JAQM2DCOD WHERE
      T1.JAQM7CTCR = 3 AND 
      T1.Jaqm7cfec = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1) AND 
      T2.JAQM2DINS = PI_INSTANCIA;  
    EXCEPTION
      WHEN OTHERS THEN NULL;   
    END;
    
    IF ESTADO IS NULL THEN
      PO_RESULTADO := 'S'; -- MUESTRA ALERTA
    ELSE
      PO_RESULTADO := 'N'; -- NO MUESTRA ALERTA
    END IF;
   END; 

-- *****************************************************************
-- Nombre                       : SP_CR_VALIDA_ACTA_CERRADA2
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/07/2025
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 21/07/2025
-- Autor de la Modificación : MCORDOVA
-- Descripción de Modificación  : SE MODIFICA CONDICION DE INGRESO PARA VALIDAR ACTA DIGITAL
-- *****************************************************************
   
   -- VALIDA SI EXISTE ACTA, INGRESANDO POR CODIGO ACTA
   PROCEDURE SP_CR_VALIDA_ACTA_CERRADA(
                                       PI_ACTA IN CHAR,
                                       PI_INSTANCIA IN NUMBER,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
   IS
    ESTADO VARCHAR2(1);
   BEGIN
    BEGIN     
      SELECT JAQM7CEST INTO ESTADO FROM JAQM7C T1 JOIN JAQM2D T2 ON
      T1.JAQM7CCOD = T2.JAQM2DCOD WHERE
      T1.JAQM7CTCR = 3 AND 
      T1.Jaqm7cfec = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1 AND ROWNUM = 1) AND
      T1.JAQM7CNAT = PI_ACTA AND
      T2.JAQM2DINS = PI_INSTANCIA AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN NULL;   
    END;
    
    IF ESTADO IS NULL THEN
      PO_RESULTADO := 'S'; -- MUESTRA ALERTA
    ELSE
      PO_RESULTADO := 'N'; -- NO MUESTRA ALERTA
    END IF;
   END; 
 
-- *****************************************************************
-- Nombre                       : SP_CR_MANTENEDOR_LOG_ACTA_DIGITAL
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/07/2025
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************  
   PROCEDURE SP_CR_MANTENEDOR_LOG_ACTA_DIGITAL(
                                      V_AQPC238INS IN NUMBER,
                                      V_AQPC238EMP IN NUMBER,
                                      V_AQPC238SUC IN NUMBER,
                                      V_AQPC238MOD IN NUMBER,
                                      V_AQPC238MDA IN NUMBER,
                                      V_AQPC238PAP IN NUMBER,
                                      V_AQPC238CTA IN NUMBER,
                                      V_AQPC238OPE IN NUMBER,
                                      V_AQPC238SOP IN NUMBER, 
                                      V_AQPC238TOP IN NUMBER,
                                      V_AQPC238COM IN VARCHAR,
                                      V_AQPC238CFE IN DATE,
                                      V_AQPC238CTC IN NUMBER,
                                      V_AQPC238CDC IN VARCHAR,
                                      V_AQPC238CES IN VARCHAR,
                                      V_AQPC238CNA IN VARCHAR,
                                      V_AQPC238FEC IN DATE,
                                      V_AQPC239USU IN VARCHAR,
                                      V_COD_ERROR OUT VARCHAR,
                                      V_MSG_ERROR OUT VARCHAR)
    IS
    V_HORA VARCHAR(8);
    BEGIN
      V_HORA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      INSERT INTO AQPC238 VALUES(V_AQPC238INS,V_AQPC238EMP,V_AQPC238SUC,V_AQPC238MOD,V_AQPC238MDA,V_AQPC238PAP,
      V_AQPC238CTA,V_AQPC238OPE,V_AQPC238SOP,V_AQPC238TOP,V_AQPC238COM,V_AQPC238CFE,V_AQPC238CTC,V_AQPC238CDC,
      V_AQPC238CES,V_AQPC238CNA,V_AQPC238FEC,V_HORA,V_AQPC239USU);
      commit;
      V_COD_ERROR := '000';
      V_MSG_ERROR := 'Ok';
    EXCEPTION
      WHEN OTHERS THEN NULL; 
      V_COD_ERROR := '001';
      V_MSG_ERROR := sqlerrm; 
    END;
end PQ_CR_REGISTRO_ACTA_DIGITAL;
/
