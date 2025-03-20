CREATE OR REPLACE PROCEDURE SP_AH_GENERA_REPORTEAPERTURA IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_GENERA_REPORTEAPERTURA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/04/2023
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 30/01/2024
    -- Autor de la Modificación   : Tania Apaza
    -- Descripción de Modificación: Se agregó SP_AH_CC_APERTURASDPF_DIARIO
    --
    -- *****************************************************************    
    v_horaActual    VARCHAR2(8);
    v_horaAnterior  VARCHAR2(8);
	P_USER             CHAR(10);
	P_ERRCOD       VARCHAR2(10);
	P_ERRMSG       VARCHAR2(50);
    v_pgcod              NUMBER;
    P_CANTREGISTROS      NUMBER;
    P_TIPO          VARCHAR2(30);
  BEGIN
    
    ---***
    DELETE FROM JAQN77;
    ---***
	
	
    v_pgcod        := 1;
    P_USER         := 'USUARIOJOB'; 
    v_horaActual   := TO_CHAR(SYSDATE, 'HH24:MI:SS');  
    v_horaAnterior := TO_CHAR(SYSDATE - INTERVAL '2' HOUR, 'HH24:MI:SS'); 
    P_TIPO         := 'NPS_APERTURACUENTA'; 

	---***
    DELETE FROM AQPB513 WHERE AQPB513CREUSR = P_USER;
	COMMIT;
    ---***
	
    SP_AH_CC_APERTURAS_DIARIO( P_USER, v_horaActual, v_horaAnterior, P_ERRCOD, P_ERRMSG); 
	  SP_AH_CC_APERTURASDPF_DIARIO( P_USER, v_horaActual, v_horaAnterior, P_ERRCOD, P_ERRMSG);
    SP_AH_DATAUBICACION_APERTURA();
    SP_AH_INSERCION_APERTURA_CTA(v_pgcod, P_USER, P_CANTREGISTROS);
    SP_AH_INSGESTORPROCESO(P_CANTREGISTROS,P_TIPO);
    
exception
when others then
         dbms_output.put_line(sqlerrm);  
    ---*** 

END SP_AH_GENERA_REPORTEAPERTURA;
/

