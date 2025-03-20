create or replace package PQ_CR_CUOTACOMODIN is

  -- Author  : MPOSTIGOC
  -- Created : 20/11/2018 7:19:40 p. m.
  -- Purpose : 

  procedure sp_cr_MesesUltCuotaCom(ln_Instancia   in number,
                                   ld_NroMesUltCC out number);
  -----------------------------------------------------
  procedure sp_cr_NroVcsCuoComd(ln_Instancia    in number,
                                ln_NroVcsCuoCom out number);
  -----------------------------------------------------                                
end PQ_CR_CUOTACOMODIN;
/

create or replace package body PQ_CR_CUOTACOMODIN is

  procedure sp_cr_MesesUltCuotaCom(ln_Instancia   in number,
                                   ld_NroMesUltCC out number) is
  
    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
    ld_FchUltCuoCom date;
    ld_FchSist      date;
  
  begin
  
    begin
      -- Extraemos la clave del credito
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
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      -- Extraemos la ultima fecha de Cuota Comodin
      select max(f.d602fc)
        into ld_FchUltCuoCom
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_modulo
         and f.ppsuc = ln_sucursal
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_suboperacion
         and f.pptope = ln_tipoper
         and f.d602cd = 1
         and f.d602mo = 99
         and f.d602tr = 703
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      -- Extraemos la Fecha del Sistema
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    if ld_FchUltCuoCom is not null then
      -- Ingresamos solo si la fecha de la ultima cuota Comodin
      -- no es nula.
      begin
        select MONTHS_BETWEEN(ld_FchSist, ld_FchUltCuoCom)
          into ld_NroMesUltCC
          from DUAL;
      exception
        when others then
          ld_NroMesUltCC := 0;
      end;
    else
      ld_NroMesUltCC := 0;
    end if;
  
  end sp_cr_MesesUltCuotaCom;
  ----------------------------------------------------------------------
  procedure sp_cr_NroVcsCuoComd(ln_Instancia    in number,
                                ln_NroVcsCuoCom out number) is
  
    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboperacion number;
    ln_tipoper      number;
  
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
             ln_suboperacion,
             ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_NroVcsCuoCom
        from (select distinct f.d602cd,
                              f.d602mo,
                              f.d602su,
                              f.d602tr,
                              f.d602re,
                              f.d602fc,
                              f.d602or,
                              f.d602sb,
                              f.d602co
                from fsd602 f
               where f.pgcod = ln_pgcod
                 and f.ppmod = ln_modulo
                 and f.ppsuc = ln_sucursal
                 and f.ppmda = ln_moneda
                 and f.pppap = ln_papel
                 and f.ppcta = ln_cuenta
                 and f.ppoper = ln_operacion
                 and f.ppsbop = ln_suboperacion
                 and f.pptope = ln_tipoper
                 and f.d602cd = 1
                 and f.d602mo = 99
                 and f.d602tr = 703
                 and f.d602co = 'S') t;
    exception
      when others then
        ln_NroVcsCuoCom := 0;
    end;
  
  end sp_cr_NroVcsCuoComd;
  ----------------------------------------------------------------------
end PQ_CR_CUOTACOMODIN;
/

