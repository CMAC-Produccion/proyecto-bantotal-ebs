create or replace procedure SP_AH_TC_REFER(tran in number,tipo out number) is
    -- *****************************************************************
    -- Nombre                     : PROCESDIMIENTO QUE DEVUELVE EL TIPO DE CAMBIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2015.11.12
    -- Autor de Creación          : SILVIA MARQUEZ
    -- Uso                        : Realiza cálculos DE LA PIZARRA 5000 DE TIPO DE CAMBIO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -----------------------------------------------------------------------
    -- FEcha Modificacion         : 2025.08.28
    -- Autor Modificacion         : SILVIA MARQUEZ 
    -- Descripcion Modificacion   : Adicion de transaccion 31 ARCELY   
    -- *****************************************************************

tccpa1 number(10,6):=0;                                           
tcvta1 number(10,6):=0;                                           
begin
 Select tccpa, tcvta
   into tccpa1,tcvta1
   from fsd120
  where TCCOD = 500
    and tcfch = (select max(tcfch) from fsd120 where tccod = 500)
    and tchor =
        (select max(tchor)
           from fsd120
          where tccod = 500
            and tcfch = (select max(tcfch) from fsd120 where tccod = 500));
   if tran = 535 or tran = 131 or tran = 31 then --Compra adicion nueva tran 180220
     tipo := tccpa1;
   elsif tran = 536 or tran = 130 or tran = 31 then -- Venta adicion nueva tran 180220
     tipo := tcvta1;    
   end if;      
exception
  when others then
    null;
end SP_AH_TC_REFER;
/
