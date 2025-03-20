CREATE OR REPLACE TRIGGER TG_FSX001_AU_01
	AFTER UPDATE ON FSX001
		FOR EACH ROW
		 WHEN ((NEW.TXCOD = 0) AND (NEW.PETDOC <> 0 OR NEW.PEPAIS <> 0 AND OLD.PEXTXT <> NEW.PEXTXT)) DECLARE
				lc_usuario char(10);
				lv_usuario varchar(10) := TRIM(:NEW.PEXUSU);
				lc_hora char(8) := to_char(SYSDATE, 'hh24:mi:ss');
				lc_fecha DATE := SYSDATE;
				lc_accion char(15) := 'MODIFICACIÓN';
				ln_pai number(3) := :NEW.PEPAIS;
				ln_tdo number(2) := :NEW.PETDOC;
				lc_ndo char(12) := :NEW.PENDOC;
				lc_canal char(30) := '';
				lc_con char(500);
			BEGIN
				---***
        IF (lv_usuario IS NULL) THEN
			   		lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
				ELSE
			  		lc_usuario := lv_usuario;
				END IF;
			  ---***
				SP_USUARIOS_CANALES(lc_usuario, lc_canal);
				IF :OLD.PEXTXT IS NOT NULL THEN
					lc_con := '<CORREO>' || TRIM(regexp_replace(:OLD.PEXTXT,'[\]','')) || '</CORREO>';
				END IF;

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

