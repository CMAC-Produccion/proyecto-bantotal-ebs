create or replace procedure SP_BAJA_SERVICIO_GLOBOKAS is
begin
       Update FST198 set TP1Nro1 = 1 
       where Tp1cod = 1 and Tp1cod1 = 10800 and Tp1corr1 = 1 and Tp1corr2 = 10 and Tp1corr3 = 1;
       commit;
  
end SP_BAJA_SERVICIO_GLOBOKAS;
/

