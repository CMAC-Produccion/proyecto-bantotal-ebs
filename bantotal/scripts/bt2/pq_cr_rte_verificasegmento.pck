create or replace package PQ_CR_RTE_VERIFICASEGMENTO is

  -- Author  : MPOSTIGOC
  -- Created : 17/12/2018 10:45:27 a. m.
  -- Purpose : 

  procedure sp_cr_VerifSegmnto(ln_pgcodt            in number,
                               ln_suct              in number,
                               ln_modt              in number,
                               ln_ttran             in number,
                               ln_relt              in number,
                               ln_ordt              in number,
                               ln_sbort             in number,
                               lc_SegmntoEvaluacion out number,
                               lc_SegmntoActual     out number,
                               lc_CambSegmnto       out varchar2);
  ----------------------------------------------------------------------------------------
  procedure sp_cr_VerifSegmEvaluacion(ln_Instancia         in number,
                                      lc_SegmntoEvaluacion out number);
  --------------------------------------------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number);

end PQ_CR_RTE_VERIFICASEGMENTO;
/

create or replace package body PQ_CR_RTE_VERIFICASEGMENTO is

  procedure sp_cr_VerifSegmnto(ln_pgcodt            in number,
                               ln_suct              in number,
                               ln_modt              in number,
                               ln_ttran             in number,
                               ln_relt              in number,
                               ln_ordt              in number,
                               ln_sbort             in number,
                               lc_SegmntoEvaluacion out number,
                               lc_SegmntoActual     out number,
                               lc_CambSegmnto       out varchar2) is
  
    ld_fchsist   date;
    ln_pgcod     number;
    ln_modulo    number;
    ln_tipoper   number;
    ln_sucursal  number;
    ln_moneda    number;
    ln_papel     number;
    ln_cuenta    number;
    ln_operacion number;
    ln_suboper   number;
    ln_Instancia number;
  
  begin
  
    lc_CambSegmnto := 'N';
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    end;
  
    begin
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
  
    if ln_cuenta is not null then
      begin
        ln_Instancia := fn_instancia_credito(v_Scmod  => ln_modulo,
                                             v_Scsuc  => ln_sucursal,
                                             v_Scmda  => ln_moneda,
                                             v_Scpap  => ln_papel,
                                             v_Sccta  => ln_cuenta,
                                             v_Scoper => ln_operacion,
                                             v_Scsbop => ln_suboper,
                                             v_Sctope => ln_tipoper);
      end;
    
      -- Segmento de la etapa de Evaluacion / Propuesta
      PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_VerifSegmEvaluacion(ln_Instancia,
                                                           lc_SegmntoEvaluacion);
    
      -- Segmento Actual
      PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_SegmntoActual(ln_Instancia,
                                                     lc_SegmntoActual);
    
      lc_SegmntoEvaluacion := nvl(lc_SegmntoEvaluacion, 999);
      lc_SegmntoActual     := nvl(lc_SegmntoActual, 999);
    
      if lc_SegmntoActual <> lc_SegmntoEvaluacion then
        lc_CambSegmnto := 'S';
      end if;
    
      if lc_SegmntoEvaluacion = 999 then
        lc_CambSegmnto := 'S';
      end if;
    
    else
      lc_CambSegmnto := 'N';
    end if;
  
  end sp_cr_VerifSegmnto;

  -------------------------------------------------------------------------------
  procedure sp_cr_VerifSegmEvaluacion(ln_Instancia         in number,
                                      lc_SegmntoEvaluacion out number) is
  begin
  
    begin
      select to_number(trim(g.pae71val))
        into lc_SegmntoEvaluacion
        from fpae70 f, fpae71 g
       where f.pae51eva = g.pae51eva
         and f.pae70nro = g.pae70nro
         and f.pae70ins = ln_Instancia
         and f.pae51eva in (2, 6)
         and g.pae71ite = 43;
    exception
      when too_many_rows then
        begin
          select TO_NUMBER(trim(g.pae71val))
            into lc_SegmntoEvaluacion
            from fpae70 f, fpae71 g
           where f.pae51eva = g.pae51eva
             and f.pae70nro = g.pae70nro
             and f.pae70ins = ln_Instancia
             and f.pae51eva in (2, 6)
             and g.pae71ite = 43
             and f.pae70nro = (select max(f.pae70nro)
                                 from fpae70 f
                                where f.pae70ins = ln_Instancia
                                  and f.pae51eva in (2, 6));
        end;
      when others then
        null;
    end;
  
  end sp_cr_VerifSegmEvaluacion;
  --------------------------------------------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  
  end sp_cr_SegmntoActual;

end PQ_CR_RTE_VERIFICASEGMENTO;
/

