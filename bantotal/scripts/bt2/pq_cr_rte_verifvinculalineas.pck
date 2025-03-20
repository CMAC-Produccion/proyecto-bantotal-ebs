create or replace package PQ_CR_RTE_VERIFVINCULALINEAS is

  -- Author  : MPOSTIGOC
  -- Created : 19/12/2018 5:45:06 p. m.
  -- Purpose : 

  procedure sp_cr_verfvinclinea(ln_pgcodt  in number,
                                ln_suct    in number,
                                ln_modt    in number,
                                ln_ttran   in number,
                                ln_relt    in number,
                                ln_ordt    in number,
                                ln_sbort   in number,
                                lc_pcancel out varchar2);

end PQ_CR_RTE_VERIFVINCULALINEAS;
/

create or replace package body PQ_CR_RTE_VERIFVINCULALINEAS is

  procedure sp_cr_verfvinclinea(ln_pgcodt  in number,
                                ln_suct    in number,
                                ln_modt    in number,
                                ln_ttran   in number,
                                ln_relt    in number,
                                ln_ordt    in number,
                                ln_sbort   in number,
                                lc_pcancel out varchar2) is
  
    cursor lista_vinculados(ln_pgcod117     in number,
                            ln_modulo117    in number,
                            ln_cuenta117    in number,
                            ln_operacion117 in number,
                            ln_suboper117   in number,
                            ln_sucursal117  in number,
                            ln_moneda117    in number,
                            ln_papel117     in number,
                            ln_tipoper117   in number) is
    
      select jaqy800ins ln_Instancia
        from jaqy800
       where JAQY800PGCD = ln_pgcod117
         and JAQY800MOD = ln_modulo117
         and JAQY800SUC = ln_sucursal117
         and JAQY800MDA = ln_moneda117
         and JAQY800PAP = ln_papel117
         and JAQY800CTA = ln_cuenta117
         and JAQY800OPE = ln_operacion117
         and JAQY800SBOP = ln_suboper117
         and JAQY800TOPE = ln_tipoper117
         and jaqy800vinc = 'S';
  
    ln_pgcod        number;
    ln_modulo       number;
    ln_tipoper      number;
    ln_sucursal     number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboper      number;
    ln_pgcod117     number;
    ln_modulo117    number;
    ln_cuenta117    number;
    ln_operacion117 number;
    ln_suboper117   number;
    ln_sucursal117  number;
    ln_moneda117    number;
    ln_papel117     number;
    ln_tipoper117   number;
    lc_EstVinculado varchar2(2) := 'N';
    ld_fchsist      date;
  
  begin
  
    lc_pcancel := 'N';
  
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    end;
  
    begin
      -- Sacamos la clave del credito de la transaccion
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod,
             ln_modulo,
             ln_tipoper,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt
         and f.itsbor = ln_sbort
         and f.itfval = ld_fchsist;
    exception
      when others then
        null;
    end;
  
    if ln_modulo = 116 then
      -- Sacamos la clave de la linea principal
      begin
        select f.r2cod,
               f.r2mod,
               f.r2cta,
               f.r2oper,
               f.r2sbop,
               f.r2suc,
               f.r2mda,
               f.r2pap,
               f.r2tope
          into ln_pgcod117,
               ln_modulo117,
               ln_cuenta117,
               ln_operacion117,
               ln_suboper117,
               ln_sucursal117,
               ln_moneda117,
               ln_papel117,
               ln_tipoper117
          from fsr011 f
         where f.r1cod = ln_pgcod
           and f.r1mod = ln_modulo
           and f.r1suc = ln_sucursal
           and f.r1mda = ln_moneda
           and f.r1pap = ln_papel
           and f.r1cta = ln_cuenta
           and f.r1oper = ln_operacion
           and f.r1sbop = ln_suboper
           and f.r1tope = ln_tipoper
           and f.relcod = 46;
      exception
        when others then
          null;
      end;
    else
      ln_pgcod117     := ln_pgcod;
      ln_modulo117    := ln_modulo;
      ln_cuenta117    := ln_cuenta;
      ln_operacion117 := ln_operacion;
      ln_suboper117   := ln_suboper;
      ln_sucursal117  := ln_sucursal;
      ln_moneda117    := ln_moneda;
      ln_papel117     := ln_papel;
      ln_tipoper117   := ln_tipoper;
    
    end if;
  
    if ln_cuenta117 is not null then
      -- con la linea principal verificamos todos los vinculados que podria tener la linea de credito
      for v in lista_vinculados(ln_pgcod117,
                                ln_modulo117,
                                ln_cuenta117,
                                ln_operacion117,
                                ln_suboper117,
                                ln_sucursal117,
                                ln_moneda117,
                                ln_papel117,
                                ln_tipoper117) loop
      
        begin
          -- verificamos que la instancia este activa
          select 'S'
            into lc_EstVinculado
            from wfwrkitems w
           where w.wfinsprcid = v.ln_Instancia
             and w.wfitemstsact = 1;
        exception
          when others then
            lc_EstVinculado := 'N';
        end;
      
        if lc_EstVinculado = 'S' then
          lc_pcancel := 'S';
          exit;
        else
          lc_pcancel := 'N';
        end if;
      end loop;
    else
      lc_pcancel := 'N';
    end if;
  end sp_cr_verfvinclinea;

end PQ_CR_RTE_VERIFVINCULALINEAS;
/

