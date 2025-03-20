create or replace package PQ_POLITICAS_AGRO is

  -- Author  : MCANDIA
  -- Created : 17/07/2019 03:11:03 p.m.
  -- Purpose : 
  -- Fecha de Modificación      : 25/04/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego excepcion para solo considerar 1 rubro
  ---------------------------------------------------------------------------------------------------------

  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2);

  procedure sp_cr_PoltcsEvalFlj(ln_Instancia in number,
                                lc_FlujVuelo out varchar2,
                                lc_FlujVignt out varchar2,
                                lc_MensVuelo out Varchar2,
                                lc_MensVignt out varchar2);

  procedure sp_cr_PoltcsConsum(ln_Instancia in number,
                               lc_FlujConsu out varchar2);

end PQ_POLITICAS_AGRO;
/

create or replace package body PQ_POLITICAS_AGRO is

  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2) is
    ln_reg number := 0;
  begin
  
    begin
      select count(*)
        into ln_reg
        from aqpa410 a
       where a.aqpa410inst = ln_Instancia
         and a.aqpa410esta = 'S';
    exception
      when others then
        ln_reg := 0;
    end;
  
    if ln_reg > 0 then
      ln_EvalFlujo := 'S';
    elsif ln_reg <= 0 then
      ln_EvalFlujo := 'N';
    end if;
  
  end sp_cr_VerfEvalFlujo;

  procedure sp_cr_PoltcsEvalFlj(ln_Instancia in number,
                                lc_FlujVuelo out varchar2,
                                lc_FlujVignt out varchar2,
                                lc_MensVuelo out Varchar2,
                                lc_MensVignt out varchar2) is
  
    cursor documentos is
    
      select distinct f.pepais ln_pais,
                      (trim(f.pendoc)) lc_doc,
                      f.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct f.pepais ln_pais,
                      (trim(g.rpndoc)) lc_doc,
                      g.rptdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and g.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct f.pepais ln_pais,
                      (trim(g.pendoc)) lc_doc,
                      g.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and g.rptdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5;
  
    cursor lista_UltCredDeseb(ln_pais             number,
                              ln_tdoc             number,
                              lc_doc              varchar2, --lc_ndoc
                              ld_FchUltCredDesemb date) is
      select G.PGCOD  ln_pgcod,
             G.AOMOD  ln_modulo,
             G.AOSUC  ln_sucursal,
             G.AOMDA  ln_moneda,
             G.AOPAP  ln_papel,
             G.AOCTA  ln_cuenta,
             G.AOOPER ln_operacion,
             G.AOSBOP ln_suboper,
             G.AOTOPE ln_tipoper,
             G.AOSTAT LN_EstCred
        from fsd010 g
       where g.PGCOD = 1
         and (g.AOMOD in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (108, 116, 141)) or
             g.AOMOD = 117)
         and g.AOMDA in (0, 101)
         and g.AOPAP = 0
         and g.AOCTA in (select ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_doc) --> @mod mpca 03-09-2019
         and g.AOFVAL = ld_FchUltCredDesemb;
  
    ld_FchUltCredDesemb date;
    ln_NroInst          number := 0;
    ln_NroInstAux       number;
    ln_reg              number;
    ln_TipCredito       number;
    lc_numdoc           character(12);
  
  begin
    lc_FlujVuelo := 'N';
    lc_FlujVignt := 'N';
    lc_MensVuelo := 'N';
    lc_MensVignt := 'N';
  
    if lc_FlujVuelo <> 'S' then
      begin
        -- Verifica si a la instancia se le ingreso Evaluacion por Flujo
        PQ_POLITICAS_AGRO.sp_cr_VerfEvalFlujo(ln_Instancia, lc_FlujVuelo);
      end;
    end if;
    -- begin
  
    for d in documentos loop
    
      lc_numdoc := rpad(d.lc_doc, 12, ' ');
    
      begin
        select max(g.AOFVAL)
          into ld_FchUltCredDesemb
          from fsd010 g
         where g.PGCOD = 1
           and (g.AOMOD in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (108, 116, 141)) or g.AOMOD = 117)
           and g.AOMDA in (0, 101)
           and g.AOPAP = 0
           and g.AOCTA in (select ctnro
                             from fsr008 f
                            where f.pgcod = 1
                              and f.pepais = d.ln_pais --ln_pais
                              and f.petdoc = d.ln_tdoc --ln_tdoc
                              and f.pendoc = lc_numdoc); --> @mod mpca 03-09-2019
      
      exception
        when others then
          null;
      end;
    
      if ld_FchUltCredDesemb is not null then
        for l in lista_UltCredDeseb(d.ln_pais, --ln_pais,
         d.ln_tdoc, --ln_tdoc,
         lc_numdoc, --d.lc_doc, --lc_ndoc, --> @mod mpca 03-09-2019
         ld_FchUltCredDesemb) loop
        
          if l.ln_estcred <> 99 then
            -- MCPC 02/03/2020 INC2404
          
            ln_NroInstAux := fn_instancia_credito(v_Scmod  => l.ln_modulo,
                                                  v_Scsuc  => l.ln_sucursal,
                                                  v_Scmda  => l.ln_moneda,
                                                  v_Scpap  => l.ln_papel,
                                                  v_Sccta  => l.ln_cuenta,
                                                  v_Scoper => l.ln_operacion,
                                                  v_Scsbop => l.ln_suboper,
                                                  v_Sctope => l.ln_tipoper);
          
            if ln_NroInst < ln_NroInstAux then
              ln_NroInst := ln_NroInstAux;
            end if;
          
          else
            ln_NroInst := 0; -- MCPC 02/03/2020 INC2404
          end if;
        end loop;
      
      else
        ln_NroInst := 0;
      
      end if;
    
      if ln_NroInst > 0 then
      
        begin
          select count(*)
            into ln_reg
            from aqpa410 a
           where a.aqpa410inst = ln_NroInst
             and a.aqpa410esta = 'S';
        exception
          when others then
            ln_reg := 0;
        end;
      
        if lc_FlujVignt <> 'S' then
          if ln_reg > 0 then
            lc_FlujVignt := 'S';
          elsif ln_reg <= 0 then
            lc_FlujVignt := 'N';
          end if;
        end if;
      
        begin
          select s.sng001ori
            into ln_TipCredito
            from sng001 s
           where s.sng001inst = ln_Instancia;
        exception
          when others then
            ln_TipCredito := 0;
        end;
      
        if lc_FlujVignt = 'S' then
          -- Si el ultimo credito vigente ha tenido evaluacion por flujo,
          -- entonces no tuvo evaluacion mensualizada
          lc_MensVignt := 'N';
        else
          -- de lo contrario si tuvo evaluacion mensualizada
          lc_MensVignt := 'S';
        end if;
      else
        -- No posee ningun credito Vigente
        lc_MensVignt := 'X';
        lc_FlujVignt := 'X';
      end if;
    end loop;
  
    if lc_FlujVuelo = 'S' then
      -- Si el credito que se esta otorgando tiene una evaluacion por flujo, no tiene 
      -- evaluacion mensualizada
      lc_MensVuelo := 'N';
    else
      -- de lo contrario si tiene evaluacion mensualizada
      lc_MensVuelo := 'S';
    end if;
  
    --  Si la solicitud en vuelo posee un calendario con flujo y corresponde a un refinanciado o ampliado 
    --que tuvo un ratio mensualizado aplica para el cálculo por flujos.
  
    if lc_FlujVuelo = 'S' and ln_TipCredito in (3, 4, 15) then
      --Refinanciado, Ampliado, Ampliado Especial
      lc_MensVignt := 'N';
    end if;
  
  end sp_cr_PoltcsEvalFlj;
  ----------------------------------------------------------------------------
  procedure sp_cr_PoltcsConsum(ln_Instancia in number,
                               lc_FlujConsu out varchar2) is
  
    cursor documentos is
    
      select distinct f.pepais ln_pais,
                      (trim(f.pendoc)) lc_doc,
                      f.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct f.pepais ln_pais,
                      (trim(g.rpndoc)) lc_doc,
                      g.rptdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and g.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct f.pepais ln_pais,
                      (trim(g.pendoc)) lc_doc,
                      g.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and g.rptdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5;
  
    cursor lista_CredDeseb(ln_pais number, ln_tdoc number, lc_doc varchar2) is
      select G.PGCOD  ln_pgcod,
             G.AOMOD  ln_modulo,
             G.AOSUC  ln_sucursal,
             G.AOMDA  ln_moneda,
             G.AOPAP  ln_papel,
             G.AOCTA  ln_cuenta,
             G.AOOPER ln_operacion,
             G.AOSBOP ln_suboper,
             G.AOTOPE ln_tipoper
        from fsd010 g
       where g.PGCOD = 1
         and g.AOMOD in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (108, 141)) -- prendarios , cartas fianza
         and g.AOMDA in (0, 101)
         and g.AOPAP = 0
         and g.AOCTA in (select ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_doc)
         and g.aostat <> 99;
  
    ln_rubro  number(16);
    lc_numdoc character(12);
  
  begin
  
    lc_FlujConsu := 'N';
  
    for d in documentos loop
    
      lc_numdoc := rpad(d.lc_doc, 12, ' ');
    
      for l in lista_CredDeseb(d.ln_pais, d.ln_tdoc, lc_numdoc) loop
        --d.lc_doc) loop
      
        begin
          select s.scrub
            into ln_rubro
            from fsd011 s
           where s.pgcod = l.ln_pgcod
             and s.scsuc = l.ln_sucursal
             and s.scmda = l.ln_moneda
             and s.scpap = l.ln_papel
             and s.sccta = l.ln_cuenta
             and s.scoper = l.ln_operacion
             and s.scsbop = l.ln_suboper
             and s.sctope = l.ln_tipoper
             and s.scmod = l.ln_modulo
             and s.scmod <> 107
             and s.scstat <> 99
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
        if ln_rubro is not null then
          if lc_FlujConsu <> 'S' then
            case
              when REGEXP_LIKE(ln_rubro, '^14.[1-6]03....015') or
                   REGEXP_LIKE(ln_rubro, '^14.[1-6]03') THEN
                lc_FlujConsu := 'S';
              when REGEXP_LIKE(ln_rubro, '^7215..03') THEN
                lc_FlujConsu := 'S';
              ELSE
                lc_FlujConsu := 'N';
            END CASE;
          end if;
        end if;
      
      end loop;
    end loop;
  end sp_cr_PoltcsConsum;
end PQ_POLITICAS_AGRO;
/

