CREATE OR REPLACE TRIGGER TG_SNGC13_AI_01
	AFTER INSERT ON SNGC13 
	FOR EACH ROW 
	 WHEN (NEW.SNGC13TDOC <> 0 AND NEW.SNGC13PAIS <> 0) DECLARE
				lc_usuario char(10) := :NEW.SNGC13USER;
				lc_hora char(8) := to_char(SYSDATE, 'hh24:mi:ss');
				lc_fecha DATE := SYSDATE;
				lc_accion char(15) := 'INSERCIÓN';
				ln_pai number(3) := :NEW.SNGC13PAIS;
				ln_tdo number(2) := :NEW.SNGC13TDOC;
				lc_ndo char(12) := :NEW.SNGC13NDOC;
				lc_canal char(30) := '';
				lc_dir char(170) := '';
			
				ln_aux_pais number(3) := 0;
				lc_pais char(30) := '';
				lc_departamento char(20) := '';
				lc_provincia char(30) := '';
				lc_distrito char(30) := '';
				lc_concatenado char(500);
				
				ln_aux_pais_b number(3) := 0;
				lc_pais_b char(30) := '';
				lc_departamento_b char(20) := '';
				lc_provincia_b char(30) := '';
				lc_distrito_b char(30) := '';
			
				lc_con_pais char(70) := '';
				lc_con_departamento char(50) := '';
				lc_con_provincia char(60) := '';
				lc_con_distrito char(60) := '';
			
			BEGIN
				
				SP_USUARIOS_CANALES(lc_usuario, lc_canal);
			
				IF :OLD.SNGC13DIR <> :NEW.SNGC13DIR THEN 
					lc_dir := '<DIRECCIÓN>' || TRIM(:OLD.SNGC13DIR) || '</DIRECCIÓN>';
				END IF;

					BEGIN 
						SELECT PAIS, PANOM
						INTO ln_aux_pais, lc_pais
						FROM FST013 F
						WHERE :NEW.SNGC13PDOC = F.PAIS;
						EXCEPTION
						WHEN NO_DATA_FOUND THEN
							NULL;
						WHEN OTHERS THEN
							NULL;
					END;

					BEGIN
						SELECT DEPNOM
						INTO lc_departamento
						FROM FST068 F
						WHERE :NEW.SNGC13DPTO = F.DEPCOD 
						AND :NEW.SNGC13PDOC = F.PAIS;
						EXCEPTION 
						WHEN NO_DATA_FOUND THEN
							NULL;
						WHEN OTHERS THEN
							NULL;
					END;
				
					BEGIN
						SELECT LOCNOM
						INTO lc_provincia
						FROM FST070 F
						WHERE :NEW.SNGC13PROV = F.LOCCOD 
						AND :NEW.SNGC13PDOC = F.PAIS
						AND :NEW.SNGC13DPTO = F.DEPCOD;
						EXCEPTION 
						WHEN NO_DATA_FOUND THEN
							NULL;
						WHEN OTHERS THEN
							NULL;
					END;
				
					BEGIN
						SELECT FST071DSC
						INTO lc_distrito
						FROM FST071 F
						WHERE :NEW.SNGC13DIST = F.FST071COL
						AND :NEW.SNGC13DPTO = F.FST071DPT
						AND :NEW.SNGC13PROV = F.FST071LOC 
						AND :NEW.SNGC13PDOC = F.FST071PAI;
						EXCEPTION 
						WHEN NO_DATA_FOUND THEN
							NULL;
						WHEN OTHERS THEN
							NULL;
					END;
				

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
				JAQN82UPA,
				JAQN82UDE,
				JAQN82UPR,
				JAQN82UDI,
				JAQN82USU,
				JAQN82CAN
				)
				VALUES (
				lc_fecha,
				lc_hora,
				ln_pai,
				ln_tdo,
				lc_ndo,
				'SNGC13',
				lc_accion, 
				lc_concatenado,
				'',
				'',
				'',
				:NEW.SNGC13DIR,
				lc_pais,
				lc_departamento,
				lc_provincia,
				lc_distrito,
				lc_usuario,
				lc_canal);
			
			EXCEPTION
			WHEN OTHERS THEN
				NULL;
			END;
/

