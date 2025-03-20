CREATE OR REPLACE PROCEDURE SP_DISTRIBUYE_DEMONIO IS
  maxt     number;
  maxp     number;
  cantidad number;
BEGIN
  --Luis Carpio
  select max(a.jaqm750reg) + 1
    into maxp
    from jaqm750 a
   where a.jaqm750fch = trunc(sysdate)
     and a.jaqm750est in ('K', 'N', 'P', 'Q'); --maximo a partir del cual separar

  select max(a.jaqm750reg)
    into maxt
    from jaqm750 a
   where a.jaqm750fch = trunc(sysdate); --maximo de fecha

  cantidad := 0;
  if maxt - maxp > 20 then
    cantidad := trunc(((maxt - maxp) / 4),0);
  end if;
  if cantidad > 0 then
    update jaqm750 a
       set a.jaqm750est = 'P'
     where a.jaqm750fch = trunc(sysdate)
       and a.jaqm750est = 'O'
       and a.jaqm750reg > maxp + cantidad;

    update jaqm750 a
       set a.jaqm750est = 'Q'
     where a.jaqm750fch = trunc(sysdate)
       and a.jaqm750est = 'P'
       and a.jaqm750reg > maxp + cantidad * 2;

    update jaqm750 a
       set a.jaqm750est = 'N'
     where a.jaqm750fch = trunc(sysdate)
       and a.jaqm750est = 'Q'
       and a.jaqm750reg > maxp + cantidad * 3;
  commit;
  end if;
  
END SP_DISTRIBUYE_DEMONIO;
/

