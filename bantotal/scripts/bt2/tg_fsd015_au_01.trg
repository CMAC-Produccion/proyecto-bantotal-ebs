CREATE OR REPLACE TRIGGER TG_FSD015_AU_01
  after update on fsd015  
  FOR EACH ROW  
   -- *****************************************************************
    -- Nombre                     : TG_FSD015_AU_01
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/01/2022
    -- Autor de Creación          : Silvia Marquez
    -- Uso                        : Notificaciones ejecutivos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 08/05/2025
    -- Autor de la Modificación   : Yrving Lozada  
    -- Modificación               : Se adicionó guía de transacciones
    -- *****************************************************************              
declare
  -- local variables here
  
  MODULO NUMBER;--:=22;
  TRAN   NUMBER;--:=300;
  
 cursor c_trx(MODULO IN NUMBER, tran IN NUMBER) is
    select distinct x.tp1nro1, x.tp1nro2
      from fst198 x 
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 132
       and x.tp1nro1  = MODULO
       and x.tp1nro2  = tran
       ;
    
begin
  For i in c_trx(:new.ITMOD,:new.ITTRAN) loop
    MODULO := i.tp1nro1;
    tran   := i.tp1nro2;
    if MODULO = :new.ITMOD and tran =:new.ITTRAN and :new.ITCONT = 'S' then
        update jaqz551
             set jaqz551hora = :new.ITHORA--,
             --    jaqz551a5= to_char(:new.ITMOD)||to_char(:new.ITTRAN)||to_char(:new.ITNREL)||:new.ITHORA
           where jaqz551pgc   = :new.PGCOD
             and jaqz551isuc1 = :new.ITSUC
             and jaqz551mod   = :new.ITMOD
             and jaqz551tran  = :new.ITTRAN
             and jaqz551rel   = :new.ITNREL
             and jaqz551fech  = :new.ITFCON;
    end if;
  End Loop;  
exception
  when others then
     null;    
end TG_FSD015_AU_01;
/
