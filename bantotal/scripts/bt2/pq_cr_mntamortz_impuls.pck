create or replace package PQ_CR_MNTAMORTZ_IMPULS is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_MNTAMORTZ_IMPULS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/06/2024 09:08:26
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso que calcula el monto amortizado para impulso
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 19.06.2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el proceso para obtener el monto amortizado, se considera el ordinal 83
  --
  -- *****************************************************************

  -- Public type declarations
  procedure sp_cr_mntamortz(ln_instancia   in number,
                            lc_ValidAmortz out varchar2,
                            ln_mntamortz   out number);

end PQ_CR_MNTAMORTZ_IMPULS;
/

create or replace package body PQ_CR_MNTAMORTZ_IMPULS is

  procedure sp_cr_mntamortz(ln_instancia   in number,
                            lc_ValidAmortz out varchar2,
                            ln_mntamortz   out number) is
  
    cursor creditos is
      select c.*
        from sng001 s, aqpc589 c
       where s.sng001pais = c.aqpc589pais
         and s.sng001tdoc = c.aqpc589ptdc
         and s.sng001ndoc = c.aqpc589dni
         and s.sng001inst = ln_instancia
         and c.aqpc589estpro = 'A'
         and c.aqpc589esthab = 'H';
  
    ln_CapIntPag   number(17, 2) := 0.00;
    ln_IntPagd     number(17, 2) := 0.00;
    ln_EsImplAmorz number;
    ln_pgcodtx     number;
    ln_modtx       number;
    ln_suctx       number;
    ln_tx          number;
    ln_reltx       number;
    ln_fchtx       date;
  
  begin
  
    lc_ValidAmortz := 'N';
    ln_mntamortz   := 0;
  
    begin
      select count(*)
        into ln_EsImplAmorz
        from sng001 s, aqpc363 c
       where s.sng001pais = c.aqpc363pais
         and s.sng001tdoc = c.aqpc363tdoc
         and s.sng001ndoc = c.aqpc363ndoc
         and s.sng001inst = ln_instancia
         and c.aqpc363mf2020 = 9999
         and c.aqpc363est = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_EsImplAmorz > 0 then
      lc_ValidAmortz := 'S';
    else
      lc_ValidAmortz := 'N';
    end if;
  
    if lc_ValidAmortz = 'S' then
    
      for c in creditos loop
      
        /* begin
          select f.ppcap + f.ppint
            into ln_CapIntPag
            from fsd601 f
           where f.pgcod = c.aqpc589emp
             and f.ppmod = c.aqpc589mod
             and f.ppsuc = c.aqpc589suc
             and f.ppmda = c.aqpc589mda
             and f.pppap = c.aqpc589pap
             and f.ppcta = c.aqpc589cta
             and f.ppoper = c.aqpc589oper
             and f.ppsbop = c.aqpc589sbop
             and f.pptope = c.aqpc589top
             and f.d601mo = 30
             and f.d601tr = 100
             and f.d601fc =
                 (select g.pgfape from fst017 g where g.pgcod = 1)
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
        
        begin
          select f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 + f.ppimp15
            into ln_IntPagd
            from fsd611 f
           where f.pgcod = c.aqpc589emp
             and f.ppmod = c.aqpc589mod
             and f.ppsuc = c.aqpc589suc
             and f.ppmda = c.aqpc589mda
             and f.pppap = c.aqpc589pap
             and f.ppcta = c.aqpc589cta
             and f.ppoper = c.aqpc589oper
             and f.ppsbop = c.aqpc589sbop
             and f.pptope = c.aqpc589top
             and f.ppfpag =
                 (select g.pgfape from fst017 g where g.pgcod = 1);
        exception
          when others then
            null;*/
        begin
          select f.d601cd, f.d601mo, f.d601su, f.d601tr, f.d601re, f.d601fc
            into ln_pgcodtx, ln_modtx, ln_suctx, ln_tx, ln_reltx, ln_fchtx
            from fsd601 f
           where f.pgcod = c.aqpc589emp
             and f.ppmod = c.aqpc589mod
             and f.ppsuc = c.aqpc589suc
             and f.ppmda = c.aqpc589mda
             and f.pppap = c.aqpc589pap
             and f.ppcta = c.aqpc589cta
             and f.ppoper = c.aqpc589oper
             and f.ppsbop = c.aqpc589sbop
             and f.pptope = c.aqpc589top
             and f.d601mo = 30
             and f.d601tr = 100
             and f.d601fc =
                 (select g.pgfape from fst017 g where g.pgcod = 1)
             and f.d601co = 'S';
        exception
          when others then
            null;
        end;
      
        if ln_pgcodtx > 0 then
        
          begin
            select f.itimp1
              into ln_mntamortz
              from fsd016 f, fsd015 g
             where f.pgcod = g.pgcod
               and f.itsuc = g.itsuc
               and f.itmod = g.itmod
               and f.ittran = g.ittran
               and f.itnrel = g.itnrel
               and f.pgcod = ln_pgcodtx
               and f.itsuc = ln_suctx
               and f.itmod = ln_modtx
               and f.ittran = ln_tx
               and f.itnrel = ln_reltx
               and f.itord = 83
               and g.itcorr <> 99;
          exception
            when others then
              null;
          end;
        
        end if;
      
      --  ln_mntamortz := nvl(ln_CapIntPag, 0) + nvl(ln_IntPagd, 0);
      
      end loop;
    end if;
  
    ln_mntamortz := nvl(ln_mntamortz, 0);
  
  end sp_cr_mntamortz;

end PQ_CR_MNTAMORTZ_IMPULS;
/

