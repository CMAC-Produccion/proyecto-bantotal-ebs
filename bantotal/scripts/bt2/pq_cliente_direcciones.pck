create or replace package PQ_CLIENTE_DIRECCIONES is

-- *****************************************************************
-- Nombre                     : PQ_CR_EXPERIAN
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos
-- Versión                    : 1.0
-- Fecha de Creación          : 2014.11.24
-- Autor de Creación          : CMAC-SFERNANDEM
-- Uso                        : Migracion de bd evaluacion a bantotal
-- Estado                     : Activo
-- Acceso                     : Público
-- Fecha de Modificación      :
-- Autor de Modificación      :
-- Descripción de Modificación:
--
--  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
procedure sp_migra_localizacion (P_RESULT out number, P_ERROR out varchar2);

end PQ_CLIENTE_DIRECCIONES;
/

create or replace package body PQ_CLIENTE_DIRECCIONES is

procedure sp_migra_localizacion( P_RESULT out number, P_ERROR out varchar2)
is 
  cursor c_localizaciones is  --Localizaciones a migrar
  SELECT SNGC13ID, SNGC13PAIS, SNGC13TDOC, SNGC13NDOC, SNGC13REF,
  SNGC13REF1, SNGC13DIR, SNGC13FGPRO
  FROM SNGC13_AUX WHERE SNGC13FGPRO=0 AND SNGC13CLI <> 'UBIGEO'
  AND SNGC13REF<>'0';
ln_existe number;
ln_valido number(18);
ln_fgpro number;

begin   
     begin         
     P_RESULT := 0;
     for f in c_localizaciones loop
         --09022017
         --Verifica si es una coordenada Válida (Diferente de las registradas en UBIGEO)       
         /*select count(1) into ln_valido from sngc13_aux b 
         where b.sngc13cli='UBIGEO' and b.sngc13ref=f.sngc13ref and b.sngc13ref1=f.sngc13ref1;    
         if ln_valido = 0 then 
           ln_fgpro := 1; --Valido
         Else
           ln_fgpro := 3; --Coordenadas pertenecen al centro de la ciudad
         End if;
         */  
           
           --Verifica si el cliente no tenga una direccion con coordenada registrada.
           select count (1) into  ln_existe from sngc13 where
           SNGC13PAIS = f.sngc13pais and SNGC13TDOC = f.sngc13tdoc and SNGC13NDOC=f.sngc13ndoc and 
           DOCOD =1 and SNGC13CORR = 500 and SNGC13EST='I';
         
           If  ln_existe = 0 then
              insert into SNGC13
              (SNGC13PAIS, SNGC13TDOC, SNGC13NDOC, DOCOD, SNGC13CORR, SNGC13PDOC, SNGC13REF,SNGC13REF1, SNGC13EST)    
              values(f.sngc13pais, f.sngc13tdoc, f.sngc13ndoc,1, 500, 0, f.sngc13ref, f.sngc13ref1,'I');                           
              P_RESULT := P_RESULT +1;
  
              update SNGC13_AUX
              set SNGC13FGPRO = 1 --Procesado Correctamente
              where SNGC13ID = f.sngc13id;                               
           Else
              update SNGC13_AUX
              set SNGC13FGPRO = 2
              where SNGC13ID = f.sngc13id; --Cliente YA cuenta con coordenadas              
           End if;  
           commit;
     end loop;
                                 
  end; 
exception
  WHEN others THEN
    P_ERROR := sqlerrm;
  
end sp_migra_localizacion;
  
end PQ_CLIENTE_DIRECCIONES;
/

