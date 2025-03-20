create or replace package PQ_CR_MORAREPROGRAMADOS is

  -- Author  : MPOSTIGOC
  -- Created : 07/12/2017 01:08:38 p.m.
  -- Purpose : 

  procedure sp_cr_MoraMaxReprog(ln_Instancia    in number,
                                ln_MoraMaxRepro out number);
  procedure sp_cr_MoraMaxCuoPen(ln_Instancia     in number,
                                ln_MoraMaxCuoPen out number);
  procedure sp_cr_NroCuoPenMora(ln_Instancia     in number,
                                ln_NroCuoPenMora out number);

end PQ_CR_MORAREPROGRAMADOS;
/

create or replace package body PQ_CR_MORAREPROGRAMADOS is

  procedure sp_cr_MoraMaxReprog(ln_Instancia    in number,
                                ln_MoraMaxRepro out number) is
  
    cursor calendario(ln_pgcod number, ln_sucursal number, ln_modulo number, ln_moneda number, ln_papel number, ln_cuenta number, ln_operacion number, ln_subopera number, ln_tipopera number, ld_FchSist date) is
      select f.pgcod  ln_pgcod,
             f.ppsuc  ln_sucursal,
             f.ppmod  ln_modulo,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subopera,
             f.pptope ln_tipopera,
             f.ppfpag ld_FchCalendario
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppsuc = ln_sucursal
         and f.ppmod = ln_modulo
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_subopera
         and f.pptope = ln_tipopera
         and f.ppfpag <= ld_FchSist;
  
    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_subopera     number;
    ln_tipopera     number;
    ld_FchSist      date;
    ln_MoraCuota    number := 0;
    ln_MoraCuotaAux number := 0;
  
  begin
  
    begin
    
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
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    for c in calendario(ln_pgcod,
                        ln_sucursal,
                        ln_modulo,
                        ln_moneda,
                        ln_papel,
                        ln_cuenta,
                        ln_operacion,
                        ln_subopera,
                        ln_tipopera,
                        ld_FchSist) loop
    
      begin
        select max(pp1fech - ppfpag)
          into ln_MoraCuota
          from fsd602
         where pgcod = C.LN_PGCOD
           and ppsuc = c.ln_sucursal
           and ppmod = c.ln_modulo
           and ppmda = c.ln_moneda
           and pppap = c.ln_papel
           and ppcta = c.ln_cuenta
           and ppoper = c.ln_operacion
           and ppsbop = c.ln_subopera
           and pptope = c.ln_tipopera
           and pp1stat = 'T'
           and ppfpag = c.ld_fchcalendario;
      exception
        when no_Data_found then
          ln_MoraCuota := ld_FchSist - c.ld_fchcalendario;
      end;
    
      if ln_MoraCuota > ln_MoraCuotaAux then
        ln_MoraCuotaAux := ln_MoraCuota;
      end if;
    
    end loop;
    ln_MoraMaxRepro := ln_MoraCuotaAux;
  
  end sp_cr_MoraMaxReprog;
  --------------------------------------------------------------
  procedure sp_cr_MoraMaxCuoPen(ln_Instancia     in number,
                                ln_MoraMaxCuoPen out number) is
  
    ln_pgcod      number;
    ln_sucursal   number;
    ln_modulo     number;
    ln_moneda     number;
    ln_papel      number;
    ln_cuenta     number;
    ln_operacion  number;
    ln_subopera   number;
    ln_tipopera   number;
    ld_FchSist    date;
    ld_UltFchPago date;
    ld_FchPrxCuot date;
  begin
  
    begin
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
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(ppfpag)
        into ld_UltFchPago
        from fsd602
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag <= ld_FchSist
         and pp1stat = 'T'
         /*and rownum = 1*/;
    exception
      when others then
        null;
    end;
  
    begin
      select min(ppfpag)
        into ld_FchPrxCuot
        from fsd601
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag > ld_UltFchPago;
    exception
      when others then
        null;
      
    end;
  
    if ld_FchPrxCuot is not null then
      ln_MoraMaxCuoPen := ld_FchSist - ld_FchPrxCuot;
    end if;
  
  end sp_cr_MoraMaxCuoPen;
  ------------------------------------------------------------
  procedure sp_cr_NroCuoPenMora(ln_Instancia     in number,
                                ln_NroCuoPenMora out number) is
  
    ln_pgcod      number;
    ln_sucursal   number;
    ln_modulo     number;
    ln_moneda     number;
    ln_papel      number;
    ln_cuenta     number;
    ln_operacion  number;
    ln_subopera   number;
    ln_tipopera   number;
    ld_FchSist    date;
    ld_UltFchPago date;
  
  begin
  
    begin
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
             ln_subopera,
             ln_tipopera
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(ppfpag)
        into ld_UltFchPago
        from fsd602
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag <= ld_FchSist
         and pp1stat = 'T'
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_NroCuoPenMora
        from fsd601
       where pgcod = ln_pgcod
         and ppsuc = ln_sucursal
         and ppmod = ln_modulo
         and ppmda = ln_moneda
         and pppap = ln_papel
         and ppcta = ln_cuenta
         and ppoper = ln_operacion
         and ppsbop = ln_subopera
         and pptope = ln_tipopera
         and ppfpag > ld_UltFchPago
         and ppfpag < ld_FchSist;
    exception
      when others then
        null;
    end;
  
  end sp_cr_NroCuoPenMora;
  --------------------------------------------------------------  
end PQ_CR_MORAREPROGRAMADOS;
/

