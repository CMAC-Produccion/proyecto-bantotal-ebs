CREATE OR REPLACE PROCEDURE SP_CR_INSERTA_AQPC225(
FECHA_SISTEMA IN DATE,
HORA_SISTEMA IN VARCHAR2,
USUARIO_SISTEMA IN VARCHAR2,
FECHA_INICIO IN DATE,
FECHA_FIN IN DATE)
AS
-- *****************************************************************
-- Nombre                     	: SP_CR_INSERTA_AQPC225
-- Sistema                    	: BANTOTAL
-- Módulo                     	: Activas
-- Versión                    	: 1.0
-- Fecha de Creación          	: 07/02/2024
-- Autor de Creación          	: Milton Cordova
-- Uso                        	: Uso
-- Estado                     	: Activo
-- Acceso                     	: Público
-- Parámetros de Entrada      	: FECHA_SISTEMA, HORA_SISTEMA, USUARIO_SISTEMA, FECHA_INICIO, FECHA_FIN 
-- Retorno                    	: -
--------------------------------------------------------------------
-- Fecha de Modificación	: 
-- Autor de la Modificación	: 
-- Descripción de Modificación	: 
-- *****************************************************************
CURSOR INSERTA_AQPC225 IS
select s.sng001inst VAR_INS,
s.sng091num VAR_NRO_POL,
to_date(d.sng060now, 'DD/MM/YY') VAR_FEC_ORI,
to_char(d.sng060now, 'HH24:MI:SS') VAR_HOR_ORI,
g.sng065usr VAR_AUT,
to_date(g.sng065now, 'DD/MM/YY') VAR_FEC_AUT,
to_char(g.sng065now, 'HH24:MI:SS') VAR_HOR_AUT,
case
when g.sng065res = 'A' THEN
'Aprobado'
when g.sng065res = 'R' then
'Rechazado'
when g.sng065res = 'P' then
'Pendiente'
end VAR_RES,
g.sng065com VAR_COM,
d.SNG057USR VAR_ANA
from sng091 s, sng060 d, sng065 g
where s.sng090pqt = d.sng060pqt
and s.sng091aut = g.sng062aut
and s.sng091num = 652
AND to_date(d.sng060now, 'DD/MM/YY') >= FECHA_INICIO AND to_date(d.sng060now, 'DD/MM/YY') <= FECHA_FIN;

VAR_CUENTA NUMBER(9,0);
VAR_OPERACION NUMBER(9,0);
VAR_SUCURSAL NUMBER(3,0);
DES_REGION VARCHAR2(30);
DES_ZONA CHAR(30);
DES_AGENCIA CHAR(30);
CORRELATIVO NUMBER(17,0);
BEGIN
    
    SELECT  NVL(MAX(AQPC225COR), 0) + 1 INTO CORRELATIVO FROM AQPC225 
    WHERE  AQPC225FEC = FECHA_SISTEMA AND AQPC225HOR = HORA_SISTEMA AND AQPC225USU = USUARIO_SISTEMA;
         
    FOR X IN INSERTA_AQPC225 LOOP
      -- CUENTA, OPERACION, SUCURSAL
      BEGIN 
         SELECT XWFCUENTA, XWFOPERACION, XWFSUCURSAL INTO VAR_CUENTA, VAR_OPERACION, VAR_SUCURSAL 
         FROM XWF700 WHERE XWFPRCINS = 10216848 AND XWFCAR3 = '1';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        VAR_CUENTA := 0;
        VAR_OPERACION := 0;
        VAR_SUCURSAL := 0;
      END;
      
      -- REGION
      BEGIN
         SELECT T2.Tp1desc INTO DES_REGION FROM FST811 T1 JOIN FST198 T2 ON T1.REGCOD = T2.TP1NRO2 
         WHERE T1.OfiCod = VAR_SUCURSAL AND T1.RegCod < 100 AND T2.Tp1cod1 = 10872 AND Tp1corr1 = 11; 
      EXCEPTION
            WHEN NO_DATA_FOUND THEN  
              DES_REGION := '';
      END;
      
      -- ZONA
      BEGIN
         SELECT SUBSTR(T2.regnom,1,30) INTO DES_ZONA FROM FST811 T1 JOIN FST810 T2 ON T1.REGCOD = T2.REGCOD 
         WHERE T1.OfiCod = VAR_SUCURSAL AND T1.RegCod < 100;
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
              DES_ZONA := '';
      END;
      
      -- SUCURSAL
      BEGIN
         SELECT Scnom INTO DES_AGENCIA FROM FST001 WHERE SUCURS = VAR_SUCURSAL;  
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
         DES_AGENCIA := ''; 
      END;
      
      -- INSERTA AQPC225
      BEGIN
        INSERT INTO AQPC225(
        AQPC225FEC, AQPC225HOR, AQPC225USU, AQPC225COR, AQPC225REG,
        AQPC225ZON, AQPC225SUC, AQPC225CTA, AQPC225INS, AQPC225OPE,
        AQPC225ANE, AQPC225USA, AQPC225COM)
        VALUES (FECHA_SISTEMA, HORA_SISTEMA, USUARIO_SISTEMA, CORRELATIVO, 
        DES_REGION, DES_ZONA, DES_AGENCIA, VAR_CUENTA,X.VAR_INS,
        VAR_OPERACION, X.VAR_ANA, X.VAR_AUT, X.VAR_COM);
        COMMIT;
        CORRELATIVO := 1 + CORRELATIVO;
      EXCEPTION
         WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;
    END LOOP;
END;
/

