CREATE OR REPLACE TRIGGER TG_SNGC17_AI_01
	AFTER INSERT ON SNGC17
		FOR EACH ROW
		 WHEN (NEW.SNGC17TDOC <> 0 AND NEW.SNGC17PAIS <> 0) DECLARE
				lc_usuario char(10) := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
				lc_hora char(8) := to_char(SYSDATE, 'hh24:mi:ss');
				lc_fecha DATE := SYSDATE;
				lc_accion char(15) := 'INSERCIÓN';
				ln_tiptel number(2) := 0;
				ln_pai number(3) := :NEW.SNGC17PAIS;
				ln_tdo number(2) := :NEW.SNGC17TDOC;
				lc_ndo char(12) := :NEW.SNGC17NDOC;
				lc_tel char(20) := '';
				lc_con char (35);
				lc_canal char(30) := '';
			BEGIN
				
				SP_USUARIOS_CANALES(lc_usuario, lc_canal);
				
				BEGIN 
					SELECT DOTELFP
					INTO lc_tel
					FROM FSR005 F
					WHERE F.PEPAIS = :NEW.SNGC17PAIS 
					AND F.PENDOC = :NEW.SNGC17NDOC
					AND F.PETDOC = :NEW.SNGC17TDOC
					AND F.DOCOD = :NEW.SNGC17DCOD
					AND F.DOORDP = :NEW.SNGC17CORR;
					EXCEPTION
					WHEN NO_DATA_FOUND THEN 
						NULL;
					WHEN OTHERS THEN
						NULL;
				END;

			
				IF :NEW.SNGC16TTEL = 2 OR :NEW.SNGC16TTEL = 6 THEN
				
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
					lc_con,
					'',
					lc_tel,
					'',
					'',
					lc_usuario,
					lc_canal);
				ELSE
					
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
					lc_con,
					lc_tel,
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

