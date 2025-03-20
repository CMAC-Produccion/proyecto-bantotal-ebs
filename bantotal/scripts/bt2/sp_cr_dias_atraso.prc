create or replace procedure sp_cr_dias_atraso(pn_instancia number,
                                              pn_pgfape    date,
                                              pn_dias      out number) is
  cursor xwf700 is
    select *
      from xwf700 a
     where a.xwfprcins = pn_instancia
       and a.xwfcar3 = 'S';

  ln_aostat number(2);
  ld_aofvto date;
begin
  pn_dias := 0;
  begin
    for i in xwf700 loop
      select aostat, aofvto
        into ln_aostat, ld_aofvto
        from fsd010 g
       where g.pgcod = i.xwfempresa
         and g.aomod = i.xwfmodulo
         and g.aosuc = i.xwfsucursal
         and g.aomda = i.xwfmoneda
         and g.aopap = i.xwfpapel
         and g.aocta = i.xwfcuenta
         and g.aooper = i.xwfoperacion
         and g.aosbop = i.xwfsubope
         and g.aotope = i.xwftipope
         and rownum = 1;
    
      select fn_dias_atraso(pn_pgfape,
                            i.xwfempresa,
                            i.xwfmodulo,
                            i.xwfsucursal,
                            i.xwfmoneda,
                            i.xwfpapel,
                            i.xwfcuenta,
                            i.xwfoperacion,
                            i.xwfsubope,
                            i.xwftipope,
                            ln_aostat,
                            ld_aofvto)
        into pn_dias
        from dual;
    end loop;
  exception
    WHEN OTHERS THEN
      null;
  end;
end sp_cr_dias_atraso;
/

