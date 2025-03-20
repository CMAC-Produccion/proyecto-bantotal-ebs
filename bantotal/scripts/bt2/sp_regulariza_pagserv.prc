create or replace procedure SP_REGULARIZA_PAGSERV
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : SP_REGULARIZA_PAGSERV
  -- Sistema               : BANTOTAL
  -- Módulo                : CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 04/08/2021
  -- Autor de Creación     : Frank Pinto Carpio
  -- Uso                   : Regulariza Pagos de servicios
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 16/06/2024
  -- Autor de Creación     : Hernan Laqui Jimenez
  -- Descripción Modific.  : Se agrega modulo 181 - neoCaja P51
  -- ------------------------------------------------------------------------------------------------
  
as
cursor c1 is
   select jaql515pgsuc, jaql515scmod, jaql515stran, jaql515snrel
     from jaql515
    where jaql515femov = trunc(sysdate)
      and jaql515esreg = 'V'
   minus
   select itsuc, itmod, ittran, itnrel
     from fsd015
    where itcont = 'S'
      and itcorr <> 99
      and itmod in (50, 490, 140, 66, 489, 98, 487, 181) --Fpinto 04/08/2021 Se agrega 98 --Hlaqui 18/09/2023 Se agrega 487
      and ittran in (980, 982, 990, 981, 940, 942, 983, 943, 947, 984, 985, 986, 992, 955, 981); --Hlaqui 26/07/2021 Se agregan 984, 985, 986, 992 --Fpinto 04/08/2021 Se agrega 955
                                                                                            --Fpinto 22/09/2023 Se agrega 981

  cursor c2 is
   select itsuc, itmod, ittran, itnrel
     from fsd015
    where itcont = 'S'
      and itcorr <> 99
      and itmod in (50, 490, 140,66, 489, 98, 487, 181) --Fpinto 04/08/2021 Se agrega 98 -- Hlaqui 18/09/2023 Se agrega 487
      and ittran in (980, 982, 990, 981, 940, 942, 983, 943, 947, 984, 985, 986, 992, 955, 981) --Hlaqui 26/07/2021 Se agregan 984, 985, 986, 992 --Fpinto 04/08/2021 Se agrega 955
                                                                                                --Fpinto 22/09/2023 Se agrega 981
   minus
   select jaql515pgsuc, jaql515scmod, jaql515stran, jaql515snrel
     from jaql515
    where jaql515femov = trunc(sysdate)
      and jaql515esreg = 'V';

begin
   --
   update fst198
      set tp1nro1 = 1
    where tp1cod1 = 10807
      and tp1corr1 = 2
      and tp1corr2 = 1
      and tp1corr3 = 1;
   commit;
   --
   dbms_lock.sleep(30);
   --
   for i in c1
   loop
   --
     update jaql515
        set jaql515esreg = 'N'
      where jaql515femov = trunc(sysdate)
        and jaql515pgsuc = i.jaql515pgsuc--
        and jaql515scmod = i.jaql515scmod
        and jaql515stran = i.jaql515stran
        and jaql515snrel = i.jaql515snrel;
     --
   end loop;
   commit;

   for j in c2
   loop
   --
     update jaql515
        set jaql515esreg = 'V'
      where jaql515femov = trunc(sysdate)
        and jaql515pgsuc = j.itsuc--
        and jaql515scmod = j.itmod
        and jaql515stran = j.ittran
        and jaql515snrel = j.itnrel;
   end loop;
   commit;

exception
  when others then
    dbms_output.put_line(sqlerrm);--**
    
end;
/

