CREATE OR REPLACE PROCEDURE sp_cr_ctrlextorno_cuenta(cuenta        number,
                                                     fecha_inicio  date,
                                                     fecha_sistema date,
                                                     respuesta     out number) IS
  /* declare
  cuenta       number;
   fecha_inicio date;
   respuesta    number;*/

  dia          number;
  dia_s        number;
  dia_habil    number;
  dias_habiles number;
  hoy          date;
  fecha_fin    date;
  cuenta_fst   number;

BEGIN
  /* respuesta    := 0;
  cuenta       := 2;
  fecha_inicio := '09/04/20';*/

  --dias_habiles := 3; --Asignamos los 3 dias solicitados
  BEGIN
    select f.tp1nro3
      into dias_habiles
      from fst198 f
     where f.tp1cod = 1
       and f.tp1cod1 = 11105
       and f.tp1corr1 = 37
       and f.tp1corr2 = 2
       and f.tp1corr3 = 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dias_habiles := 3;
  END;

  --Buscamos si existe la guia en la cuenta
  BEGIN
    select f.tp1nro3
      into cuenta_fst
      from fst198 f
     where f.tp1cod = 1
       and f.tp1cod1 = 11105
       and f.tp1corr1 = 37
       and f.tp1corr2 = 1
       and f.tp1nro3 = cuenta;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      cuenta_fst := 0;
  END;

  if cuenta_fst = 0 then
    dia       := 1;
    dia_habil := dias_habiles; -- variable numdias
    while dia <= dia_habil loop
      hoy := fecha_inicio + dia;
      --dbms_output.put_line('hoy ' || hoy);
    
      SELECT TO_CHAR(fecha_inicio + dia, 'D') into dia_s FROM DUAL;
      --dbms_output.put_line('dia_s ' || dia_s);
    
      if (dia_s = 7) then
        dbms_output.put_line('Un dia mas por domingo');
        -- domingo
        dia_habil := dia_habil + 1;
      end if;
    
      dia := dia + 1;
    end loop;
  
    fecha_fin := fecha_inicio + dia_habil;
    --dbms_output.put_line('fecha_fin ' || fecha_fin);
    if trunc(fecha_sistema) <= trunc(fecha_fin) then
      respuesta := 1;
      --dbms_output.put_line(1);
    else
      respuesta := 0;
      --dbms_output.put_line(0);
    end if;
  else
    respuesta := 1;
  end if;

  --dbms_output.put_line(respuesta);
END sp_cr_ctrlextorno_cuenta;
/

