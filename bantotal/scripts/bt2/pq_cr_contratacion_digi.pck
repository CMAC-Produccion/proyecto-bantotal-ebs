create or replace package PQ_CR_CONTRATACION_DIGI is

  -- Author  : ENINAH
  -- Created : 30/06/2023 09:33:17
  -- Purpose : Paquete para extraer la informacion

  procedure sp_cr_validar_desgravamen(instancia  in number,
                                      val_desgra out character);

end PQ_CR_CONTRATACION_DIGI;
/

create or replace package body PQ_CR_CONTRATACION_DIGI is

  procedure sp_cr_validar_desgravamen(instancia  in number,
                                      val_desgra out character) is
  
    --v_pais    number(3);
    --v_tipdoc  number(2);
    --v_numdoc  char(12);
    --tipo_per  char(1);
    fecha_sis date;
    fech_naci date;
    anios     NUMBER;
    limite    number;
    --meses     NUMBER;
    --dias      NUMBER;
  
  begin
  
    begin
      select PGFAPE into fecha_sis from FST017 where pgcod = 1; -- DE AQUI SACO LA FECHA DE PROCESO
    exception
      when others then
        null;
    end;
  
    begin
      select e.pffnac
        into fech_naci
        from fsd002 e, sng001 s
       where s.sng001pais = e.pfpais
         and s.sng001tdoc = e.pftdoc
         and s.sng001ndoc = e.pfndoc
         and s.sng001inst = instancia;
    exception
      when others then
        null;
    end;
  
    BEGIN
      -- Calcular la diferencia entre las dos fechas
      SELECT floor(months_between(fecha_sis, fech_naci) / 12) --a�os
      --floor(mod(months_between(fecha_sis, fech_naci), 12)), --meses
      --floor(mod(months_between(fecha_sis, fech_naci), 7)) --d�as
        INTO anios ---, meses, dias
        FROM DUAL;
    exception
      when others then
        null;
    END;
  
    begin
      select tp1nro1
        into limite
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 4
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    if anios > limite then
      val_desgra := 'N';
    else
      val_desgra := 'S';
    end if;
  end sp_cr_validar_desgravamen;

end PQ_CR_CONTRATACION_DIGI;
/

