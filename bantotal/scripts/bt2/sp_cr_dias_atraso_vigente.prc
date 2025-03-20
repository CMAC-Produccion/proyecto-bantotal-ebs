create or replace procedure sp_cr_dias_atraso_vigente(xwfempresa   number,
                                                      xwfmodulo    number,
                                                      xwfsucursal  number,
                                                      xwfmoneda    number,
                                                      xwfpapel     number,
                                                      xwfcuenta    number,
                                                      xwfoperacion number,
                                                      xwfsubope    number,
                                                      xwftipope    number,
                                                      pn_pgfape    date,
                                                      pn_dias      out number) is

  ln_aostat number(2);
  ld_aofvto date;
begin
  pn_dias := 0;
  begin

    select aostat, aofvto
      into ln_aostat, ld_aofvto
      from fsd010 g
     where g.pgcod = xwfempresa
       and g.aomod = xwfmodulo
       and g.aosuc = xwfsucursal
       and g.aomda = xwfmoneda
       and g.aopap = xwfpapel
       and g.aocta = xwfcuenta
       and g.aooper = xwfoperacion
       and g.aosbop = xwfsubope
       and g.aotope = xwftipope
       and rownum = 1;

    select fn_dias_atraso(pn_pgfape,
                          xwfempresa,
                          xwfmodulo,
                          xwfsucursal,
                          xwfmoneda,
                          xwfpapel,
                          xwfcuenta,
                          xwfoperacion,
                          xwfsubope,
                          xwftipope,
                          ln_aostat,
                          ld_aofvto)
      into pn_dias
      from dual;

  exception
    WHEN OTHERS THEN
      null;
  end;
end sp_cr_dias_atraso_vigente;
/

