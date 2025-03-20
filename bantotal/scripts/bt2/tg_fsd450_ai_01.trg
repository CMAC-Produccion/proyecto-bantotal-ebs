CREATE OR REPLACE TRIGGER TG_FSD450_AI_01
AFTER INSERT ON FSD450
FOR EACH ROW
  
   -- *****************************************************************
    -- Nombre                     : TG_FSD450_AI_01
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 18/12/2023
    -- Autor de la Modificación   : Tania Apaza
    -- Descripción de Modificación: Registro de Log de hora
    --
    -- *****************************************************************
    
DECLARE
    v_fecha    DATE;
	v_hora     VARCHAR2(10);
    --v_usuario  VARCHAR2(20);
    v_UserName VARCHAR2(10);
BEGIN

	v_fecha := SYSDATE;
	v_hora  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
	--SELECT USER INTO v_usuario FROM DUAL;
    
    
    v_UserName := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
    
    SELECT COALESCE(v_UserName,
                 sys_context('USERENV', 'SESSION_USER'),
                 'NOTDEFINED')
    INTO v_UserName
    FROM dual;
    
    -- Insertar en JAQN1A
    INSERT INTO JAQN1A
	(JAQN1AEMP, JAQN1AMOD, JAQN1ASUC, JAQN1AMDA, JAQN1APAP, JAQN1ACTA, JAQN1AOPE, JAQN1ASUB, JAQN1ATOP, JAQN1AFEC, JAQN1AREL, JAQN1AFECI, JAQN1AHOR, JAQN1AUSU,
	 JAQN1AAN1, JAQN1AAN2, JAQN1AAN3, JAQN1AAC1, JAQN1AAC2, JAQN1AAC3, JAQN1AAI1, JAQN1AAI2, JAQN1AAI3, JAQN1AAF1, JAQN1AAF2, JAQN1AAF3)
	VALUES
		(:new.Cbieemp,
		:new.Cbiemod,
		:new.Cbiesuc,
		:new.Cbiemda,
		:new.Cbiepap,
		:new.Cbiecta,
		:new.Cbieope,
		:new.Cbiesub,
		:new.Cbietop,
		:new.Cbiefec,
		:new.Cbierel,
		 v_fecha,  
		 v_hora, 
		 v_UserName,
		 NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    EXCEPTION
	WHEN OTHERS THEN
		NULL;

END TG_FSD450_AI_01 ;
/

