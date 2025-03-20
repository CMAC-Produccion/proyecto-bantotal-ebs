CREATE OR REPLACE TRIGGER TG_FSR005_AU_03
	AFTER UPDATE ON FSR005
		FOR EACH ROW
		 WHEN (OLD.PETDOC <> 0 AND OLD.PEPAIS <> 0 AND OLD.DOTELFP <> NEW.DOTELFP) DECLARE
				lc_usuario char(10) := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
				lc_hora char(8) := to_char(SYSDATE, 'hh24:mi:ss');
				lc_fecha DATE := SYSDATE;
				lc_accion char(15) := 'MODIFICACIÓN';
				ln_tiptel number(2) := 0;
				ln_pai number(3) := :OLD.PEPAIS;
				ln_tdo number(2) := :OLD.PETDOC;
				lc_ndo char(12) := :OLD.PENDOC;
				lc_tel_o char(50) := '';
				lc_tel_n char(50) := '';
				ln_ttel number(2) := 0;
				lc_canal char(30) := '';
			BEGIN
				
				SP_USUARIOS_CANALES(lc_usuario, lc_canal);
				
				BEGIN
					SELECT SNGC16TTEL 
					INTO ln_ttel
					FROM SNGC17 F
					WHERE F.SNGC17PAIS = :OLD.PEPAIS 
					AND F.SNGC17NDOC = :OLD.PENDOC
					AND F.SNGC17TDOC = :OLD.PETDOC
					AND F.SNGC17DCOD = :OLD.DOCOD
					AND F.SNGC17CORR = :OLD.DOORDP;
					EXCEPTION
					WHEN NO_DATA_FOUND THEN 
						NULL;
					WHEN OTHERS THEN
						NULL;
				END;
			
				IF ln_ttel = 2 OR ln_ttel = 6
				THEN
					IF :OLD.DOTELFP IS NOT NULL THEN 
						lc_tel_o :=  '<TELÉFONO>' || TRIM(:OLD.DOTELFP) || '</TELÉFONO>';
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
					'FSR005',
					lc_accion,
					lc_tel_o,
					'',
					:NEW.DOTELFP,
					'',
					'',
					lc_usuario,
					lc_canal);
				ELSE
					IF :OLD.DOTELFP IS NOT NULL THEN 
						lc_tel_o :=  '<CELULAR>' || TRIM(:OLD.DOTELFP) || '</CELULAR>';
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
					'FSR005',
					lc_accion,
					lc_tel_o,
					:NEW.DOTELFP,
					'',
					'',
					'',
					lc_usuario,
					lc_canal);
				END IF;
			
			EXCEPTION
			WHEN OTHERS THEN
				NULL;
			END;
/

