create or replace procedure sp_cr_criesgos_actualizar_fechas(p_fecCarga date,
                                                             p_tabCarga varchar2) is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : sp_cr_criesgos_actualizar_fechas
  -- Sistema               : BANTOTAL
  -- Módulo                : RIESGOS
  -- Versión               : 1.0
  -- Fecha de Creación     : 03/11/2023
  -- Autor de Creación     : Alonso Pacheco
  -- Uso                   : Actualizar la guia de las tabla JAQL639 y JAQL640
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : --
  -- Autor de Modificación : --
  -- Descripción Modific.  : --
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  fecha_guia   date;
  fmax_jaql639 date;
  fmax_jaql640 date;
  fmax_jaql641 date;
  fjaql639     char(30);
  fjaql640     char(30);

begin
  --Obtiene fecha de tabla log de carga de RIESGOS
  begin
    select max(jaql641fecar)
      into fmax_jaql641
      from criesgos.jaql641
     where jaql641aradm = 'SCORE_CNS_MYPE.csv'
        or jaql641arseg = 'SCORE.txt';
  exception
    when others then
      null;
  end;
  --Obtiene fecha de la guia actual  
  /*begin
    SELECT to_date(tp1desc, 'dd/mm/rrrr')
      into fecha_guia
      FROM fst198
     where tp1cod = 1
       and tp1cod1 = 11169
       and tp1corr1 = 2
       and tp1corr2 = 1
       and tp1corr3 = 3;
  exception
    when others then
      null;
  end;*/

  --Si son diferentes actualiza la guia
  /*if (fecha_guia = fmax_jaql641) then
    return;
  else*/
  
  --Actualiza la JAQL641
  begin
    update fst198
       set tp1desc = to_char(fmax_jaql641, 'dd/mm/rrrr')
     where tp1cod = 1
       and tp1cod1 = 11169
       and tp1corr1 = 2
       and tp1corr2 = 1
       and tp1corr3 = 3;
    commit;
  exception
    when others then
      return;
  end;

  --Obtiene la fecha maxima de la JAQL639 por unica vez
  /*begin
    select max(jaql639fepre) into fmax_jaql639 from jaql639;
  exception
    when others then
      return;
  end;*/

  --Obtiene la fecha maxima de la JAQL640 por unica vez
  /*begin
    select max(jaql640fepre) into fmax_jaql640 from jaql640;
  exception
    when others then
      return;
  end;*/

  --Actualiza la JAQL639 y JAQL640
  if p_tabCarga = 'JAQL639' then
    begin
      update fst198
         set tp1desc = to_char(p_fecCarga, 'dd/mm/rrrr')
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 1;
      commit;
    exception
      when others then
        null;
    end;
  end if;
  if p_tabCarga = 'JAQL640' then
    begin
      update fst198
         set tp1desc = to_char(p_fecCarga, 'dd/mm/rrrr')
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 2;
      commit;
    exception
      when others then
        null;
    end;
  end if;
  --end if;

end sp_cr_criesgos_actualizar_fechas;
/

