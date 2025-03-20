CREATE OR REPLACE TRIGGER TG_JAQN76_AI_02
  after insert on JAQN76  
  for each row
-- *******************************************************************************************************
-- Nombre                     : TG_JAQN76_AI_02
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2022.07.12
-- Autor de Creación          : Alonso Pacheco Huachaca
-- Uso                        : Inserción en tabla log
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
-- ********************************************************************************************************

declare
  -- local variables here
begin
  --insertamos en el log duplicado de la jaqn76
  INSERT INTO AQPB922(
                aqpb922fee,
                aqpb922emp,
                aqpb922sue,
                aqpb922moe,
                aqpb922tre,
                aqpb922ree,
                aqpb922fev,
                aqpb922suc,
                aqpb922ctc,
                aqpb922ope,
                aqpb922doc,
                aqpb922cta,
                aqpb922nrc,
                aqpb922noc,
                aqpb922ntr,
                aqpb922nco,
                aqpb922fve,
                aqpb922moc,
                aqpb922mon,
                aqpb922par,
                aqpb922sap,
                aqpb922usu,
                aqpb922ana,
                aqpb922sua,
                aqpb922fer,
                aqpb922hor,
                aqpb922ust ) 
         VALUES(:new.jaqn76fee,
                :new.jaqn76emp,
                :new.jaqn76sue,
                :new.jaqn76moe,
                :new.jaqn76tre,
                :new.jaqn76ree,
                :new.jaqn76fev,
                :new.jaqn76suc,
                :new.jaqn76ctc,
                :new.jaqn76ope,
                :new.jaqn76doc,
                :new.jaqn76cta,
                :new.jaqn76nrc,
                :new.jaqn76noc,
                :new.jaqn76ntr,
                :new.jaqn76nco,
                :new.jaqn76fve,
                :new.jaqn76moc,
                :new.jaqn76mon,
                :new.jaqn76par,
                :new.jaqn76sap,
                :new.jaqn76usu,
                :new.jaqn76ana,
                :new.jaqn76sua,
                :new.jaqn76fer,
                :new.jaqn76hor,
                :new.jaqn76ust );
exception
  when others then
    null;
end TG_JAQN76_AI_02;
/

