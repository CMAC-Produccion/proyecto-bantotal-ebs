create or replace package PQ_CR_DOBLECUOTA is

  -- Author  : MPOSTIGOC
  -- Created : 28/11/2018 12:05:46 p. m.
  -- Purpose : 

  procedure sp_cr_DobleCuota(ln_Instancia  in number,
                             lc_DobleCuota out varchar2);

end PQ_CR_DOBLECUOTA;
/

create or replace package body PQ_CR_DOBLECUOTA is

  procedure sp_cr_DobleCuota(ln_Instancia  in number,
                             lc_DobleCuota out varchar2) is
  
    ln_Tarea         number;
    ln_pgcod         number;
    ln_sucursal      number;
    ln_modulo        number;
    ln_moneda        number;
    ln_papel         number;
    ln_cuenta        number;
    ln_operacion     number;
    ln_suboper       number;
    ln_tipoper       number;
    ln_MontoCuoDoble number;
    ln_MaxCuoCalend  number;
  
  begin
  
    begin
      -- Codigo de Tarea Activa
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    begin
      -- Clave del Credito
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper,
             ln_tipoper
      
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_Tarea = 3 then
      -- Extraemos el monto de la cuota en la tarea actual y multiplicamos * 2
      begin
        select s.sng120vcuo * 2
          into ln_MontoCuoDoble
          from sng120 s
         where s.sng120ins = ln_Instancia
           and s.sng120tsk = 'SOLICITUD';
      exception
        when others then
          null;
      end;
    else
      if ln_Tarea = 7 then
        begin
          select s.sng120vcuo * 2
            into ln_MontoCuoDoble
            from sng120 s
           where s.sng120ins = ln_Instancia
             and s.sng120tsk = 'PROPUESTA';
        exception
          when others then
            null;
        end;
      end if;
    end if;
  
    begin
      -- extraemos la maxima cuota de capital + interes + seguros
      select max(f.ppcap + f.ppint + g.ppimp11 + g.ppimp12 + g.ppimp13 +
                 g.ppimp14 + g.ppimp15)
        into ln_MaxCuoCalend
        from fsd601 f, fsd611 g
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_suboper
         and f.pptope = ln_tipoper
         and f.pgcod = g.pgcod
         and f.ppmod = g.ppmod
         and f.ppsuc = g.ppsuc
         and f.ppmda = g.ppmda
         and f.pppap = g.pppap
         and f.ppcta = g.ppcta
         and f.ppoper = g.ppoper
         and f.ppsbop = g.ppsbop
         and f.pptope = g.pptope
         and f.ppfpag = g.ppfpag
         and f.d601co = 'X';
    exception
      when others then
        null;
    end;
  
    if ln_MaxCuoCalend > ln_MontoCuoDoble then
      --- Si tiene una cuota mas del doble permitido
      lc_DobleCuota := 'S';
    else
      -- No tiene ninguna cuota mas del doble
      lc_DobleCuota := 'N';
    end if;
  
  end sp_Cr_dobleCuota;

end PQ_CR_DOBLECUOTA;
/

