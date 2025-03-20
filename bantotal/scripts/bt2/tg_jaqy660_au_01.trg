create or replace trigger TG_JAQY660_AU_01
  after update
  on jaqy660 
  for each row
   -- *****************************************************************
    -- Nombre                     : TG_JAQY660_AU_01
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 25/02/2024
    -- Autor de Creación          : Yrving Lozada
    -- Uso                        : Trigger para registro log de cambios de estado afiliaciones a notificaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Modificación               : 
    -- *****************************************************************       
declare
  lc_numdoc         char(12):='';
begin
  --
  --DOCUMENTO DEL TITULAR PRINCIPAL 
  --    
  BEGIN
   select X.PENDOC 
     into lc_numdoc 
     from FSR008 X 
    WHERE X.PGCOD = 1 
      AND X.CTNRO = :new.JAQY660CTA
      AND X.TTCOD = 1 
      AND X.CTTFIR = 'T';            
  EXCEPTION
  WHEN OTHERS THEN
     lc_numdoc := null;
  END; 
  
      insert into AQPC451(aqpc451cor,
                          aqpc451doc,
                          aqpc451age,
                          aqpc451can,
                          aqpc451fec,
                          aqpc451hor,
                          aqpc451eve,
                          aqpc451pge,
                          aqpc451mod,
                          aqpc451suc,
                          aqpc451mda,
                          aqpc451pap,
                          aqpc451cta,
                          aqpc451ope,
                          aqpc451sbo,
                          aqpc451tpo,
                          aqpc451ant,
                          aqpc451new,
                          aqpc451cat,
                          aqpc451cnw,
                          aqpc451mat,
                          aqpc451mnw
                          )
                   values(SQ_AH_ID_AFILIA.NEXTVAL,
                          lc_numdoc,
                          :new.jaqy660saf,
                          decode(:new.jaqy660usu,'NSBTUSER','DIGITAL','VENTANILLA'),
                          :new.jaqy660fch,
                          :new.jaqy660hra,
                          case
                            when :old.jaqy660tme ='S' And :new.jaqy660tme ='M' then
                              'CAMBIO AFILIACION DE CELULAR A SOLO MAIL'  
                            when :old.jaqy660tme ='S' And :new.jaqy660tme ='A' then
                              'CAMBIO AFILIACION DE CELULAR A CELULAR Y MAIL'                              
                            when :old.jaqy660tme ='S' And :new.jaqy660tme ='N' then
                              'CAMBIO AFILIACION DE CELULAR A DESAFILIADO'                              
                            when :old.jaqy660tme ='A' And :new.jaqy660tme ='S' then
                              'CAMBIO AFILIACION DE CELULAR Y MAIL A SOLO CELULAR'                              
                            when :old.jaqy660tme ='A' And :new.jaqy660tme ='M' then
                              'CAMBIO AFILIACION DE CELULAR Y MAIL A SOLO MAIL'                              
                            when :old.jaqy660tme ='A' And :new.jaqy660tme ='N' then
                              'CAMBIO AFILIACION DE CELULAR Y MAIL A DESAFILIADO'                              
                            when :old.jaqy660tme ='M' And :new.jaqy660tme ='S' then
                              'CAMBIO AFILIACION DE MAIL A SOLO CELULAR'                              
                            when :old.jaqy660tme ='M' And :new.jaqy660tme ='A' then
                              'CAMBIO AFILIACION DE MAIL A CELULAR Y MAIL'                              
                            when :old.jaqy660tme ='M' And :new.jaqy660tme ='N' then
                              'CAMBIO AFILIACION DE MAIL A DESAFILIADO'                              
                            when :old.jaqy660tme ='N' And :new.jaqy660tme ='S' then
                              'CAMBIO AFILIACION DE DESAFILIADO A SOLO CELULAR'                              
                            when :old.jaqy660tme ='N' And :new.jaqy660tme ='A' then  
                              'CAMBIO AFILIACION DE DESAFILIADO A CELULAR Y MAIL'                                                          
                            when :old.jaqy660tme ='N' And :new.jaqy660tme ='M' then                              
                              'CAMBIO AFILIACION DE DESAFILIADO A SOLO MAIL'                              
                          end,                                
                          :new.jaqy660pgo,
                          :new.jaqy660mod,
                          :new.jaqy660suc,
                          :new.jaqy660mda,
                          :new.jaqy660pap,
                          :new.jaqy660cta,
                          :new.jaqy660ope,
                          :new.jaqy660sub,
                          :new.jaqy660top,
                          :old.jaqy660tme,
                          :new.jaqy660tme,
                          :old.JAQY660AUX1,
                          :new.JAQY660AUX1,
                          :old.JAQY660AFI,
                          :new.JAQY660AFI
                          );
exception
when others then  
 Null; 
end TG_JAQY660_AU_01;
/

