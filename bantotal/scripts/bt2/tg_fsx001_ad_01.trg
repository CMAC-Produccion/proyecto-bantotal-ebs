CREATE OR REPLACE TRIGGER TG_FSX001_AD_01
	AFTER DELETE ON FSX001
		FOR EACH ROW
		 WHEN (OLD.PETDOC <> 0 OR OLD.PEPAIS <> 0) DECLARE
				lc_usuario char(10) := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
				lc_hora char(8) := to_char(SYSDATE, 'hh24:mi:ss');
				lc_fecha DATE := SYSDATE;
				lc_accion char(15) := 'ELIMINACIÓN';
				ln_pai number(3) := :OLD.PEPAIS;
				ln_tdo number(2) := :OLD.PETDOC;
				lc_ndo char(12) := :OLD.PENDOC;
				lc_canal char(30) := '';
				lc_con char(500);
			BEGIN
				
				SP_USUARIOS_CANALES(lc_usuario, lc_canal);
				lc_con := '<CORREO>' || TRIM(regexp_replace(:OLD.PEXTXT,'[\]','')) || '</CORREO>';

				INSERT INTO JAQN82(
				JAQN82FEC,
				JAQN82HOR,
				JAQN82PAI,
				JAQN82TDO,
				JAQN82NDO,
				JAQN82TBL,
				JAQN82ACC,
				JAQN82VAL,
				JAQN82CEL,
				JAQN82TEL,
				JAQN82CRR,
				JAQN82DIR,
				JAQN82USU,
				JAQN82CAN
				)
				VALUES (
				lc_fecha,
				lc_hora,
				ln_pai,
				ln_tdo,
				lc_ndo,
				'FSX001',
				lc_accion,
				lc_con,
				'',
				'',
				regexp_replace(:NEW.PEXTXT,'[\]',''),
				'',
				lc_usuario,
				lc_canal);
			
			EXCEPTION
			WHEN OTHERS THEN
				NULL;
			END;
/

