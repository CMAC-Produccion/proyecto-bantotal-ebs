create or replace trigger TG_JAQY660_AI_01
  after insert
  on jaqy660 
  for each row
   -- *****************************************************************
    -- Nombre                     : TG_JAQY660_AI_01
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
                            when :new.jaqy660tme ='M' then
                              'AFILIACION A SOLO MAIL'  
                            when :new.jaqy660tme ='A' then
                              'AFILIACION A CELULAR Y MAIL'                              
                            when :new.jaqy660tme ='S' then
                              'AFILIACION A CELULAR'                                                         
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
                          NULL,
                          :new.JAQY660AUX1,
                          NULL,
                          :new.JAQY660AFI
                          );
exception
when others then  
 Null; 
end TG_JAQY660_AI_01;
/

