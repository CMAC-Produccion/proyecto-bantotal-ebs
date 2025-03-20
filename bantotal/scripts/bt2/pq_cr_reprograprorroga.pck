create or replace package PQ_CR_REPROGRAPRORROGA is

  -- Author  : MPOSTIGOC
  -- Created : 10/04/2018 12:05:31 p.m.
  -- Purpose : 

  procedure sp_cr_NroCuotasPendPago(ln_Instancia       in number,
                                    ln_NroCuotPendPago out number);

end PQ_CR_REPROGRAPRORROGA;
/

create or replace package body PQ_CR_REPROGRAPRORROGA is

  procedure sp_cr_NroCuotasPendPago(ln_Instancia       in number,
                                    ln_NroCuotPendPago out number) is
  
    ln_pgcod           number;
    ln_sucursal        number;
    ln_modulo          number;
    ln_moneda          number;
    ln_papel           number;
    ln_cuenta          number;
    ln_operacion       number;
    ln_subopera        number;
    ln_tipopera        number;
    ld_FchUltPagoTotal date;
  
  begin
  
    begin
      select w.xwfempresa,
             w.xwfsucursal,
             w.xwfmodulo,
             w.xwfmoneda,
             w.xwfpapel,
             w.xwfcuenta,
             w.xwfoperacion,
             w.xwfsubope,
             w.xwftipope
        into ln_pgcod,
             ln_sucursal,
             ln_modulo,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_subopera,
             ln_tipopera
        from xwf700 w
       where w.xwfprcins = ln_Instancia
         and w.xwfcar3 <> '1';
    exception
      when others then
        ln_pgcod     := 0;
        ln_sucursal  := 0;
        ln_modulo    := 0;
        ln_moneda    := 0;
        ln_papel     := 0;
        ln_cuenta    := 0;
        ln_operacion := 0;
        ln_subopera  := 0;
        ln_tipopera  := 0;
    end;
  
    begin
      select max(f.ppfpag)
        into ld_FchUltPagoTotal
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_subopera
         and f.pptope = ln_tipopera
         and f.pp1stat = 'T'
         and f.d602co = 'S';
    exception
      when no_data_found then
        ld_FchUltPagoTotal := null;
    end;
  
    if ld_FchUltPagoTotal is not null then
      begin
        select count(*)
          into ln_NroCuotPendPago
          from fsd601 f
         where f.pgcod = ln_pgcod
           and f.ppmod = ln_modulo
           and f.ppsuc = ln_sucursal
           and f.ppmda = ln_moneda
           and f.pppap = ln_papel
           and f.ppcta = ln_cuenta
           and f.ppoper = ln_operacion
           and f.ppsbop = ln_subopera
           and f.pptope = ln_tipopera
           and f.ppfpag > ld_FchUltPagoTotal
           and f.d601co = 'S';
      end;
    else
      if ld_FchUltPagoTotal is null then      
        begin
          select count(*)
            into ln_NroCuotPendPago
            from fsd601 f
           where f.pgcod = ln_pgcod
             and f.ppmod = ln_modulo
             and f.ppsuc = ln_sucursal
             and f.ppmda = ln_moneda
             and f.pppap = ln_papel
             and f.ppcta = ln_cuenta
             and f.ppoper = ln_operacion
             and f.ppsbop = ln_subopera
             and f.pptope = ln_tipopera
             and f.d601co = 'S';
        end;
      
      end if;
    end if;
  
  end;
end PQ_CR_REPROGRAPRORROGA;
/

