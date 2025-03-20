CREATE OR REPLACE TRIGGER TG_FSR005_AU_02
  after update on FSR005
  for each row
  
DECLARE
BEGIN
  if :new.pepais > 0 then 
     BEGIN                          
         UPDATE ichannelalert.CLIENTES_AFILIADOS
            SET celular_cliente = trim(:new.dotelfp)
          WHERE celular_cliente = trim(:old.dotelfp);
     EXCEPTION
     WHEN OTHERS THEN
       null;
     END;           
  end if;                                             
Exception
When others then
    null;
END TG_FSR005_AU_02;
/

