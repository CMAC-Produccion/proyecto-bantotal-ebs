create or replace package PQ_CR_ENDEUDAMIENTO_RCC is

  -- Author  : MCANDIA
  -- Created : 25/06/2019 03:20:00 p.m.
  -- Purpose : chernandez 17/02/2020
  -- Fecha de Modificación      : 05/12/2023
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se creo un procedimiento que devuelve el consolidado por tipo de credito la cuota potencial
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se agrego el procedimiento sp_cr_actualizCuotPoten 
  -- Fecha de Modificación      : 11/12/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se modifico el procedimiento sp_cr_actualizCuotPoten 
  -- Fecha de Modificación      : 13/03/2025
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se modifico el sp_Cr_TarjetasCredito para identificar el tipo de documento del conyuge  
  -- *****************************************************************

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2);

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2);

  Procedure sp_cr_CalculaFactor(lc_rubro     in varchar2,
                                ln_instancia in number,
                                ln_factor    out number);

  Procedure sp_cr_ActualizaCuota(ln_instancia  in number,
                                 ln_evaluacion in number);

  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number);
  --chernandez 17/02/2020 1
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro in varchar2,
                                    ln_Grupo out number);

  -----------------------------------------------------------------
  procedure sp_Cr_TotalCuotPotenc(ln_instancia in number,
                                  ln_CPPymeSol out number,
                                  ln_CPConsSol out number,
                                  ln_CPHiptSol out number,
                                  ln_CPPymeDol out number,
                                  ln_CPConsDol out number,
                                  ln_CPHiptDol out number);

  -----------------------------------------------------------------
  procedure sp_cr_actualizCuotPoten(ln_instancia in number,
                                    ln_nevaluaci in number);
end PQ_CR_ENDEUDAMIENTO_RCC;
/

create or replace package body PQ_CR_ENDEUDAMIENTO_RCC is

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2) is
  
    ln_cont      number(10);
    ln_FlagCony  number(5);
    ln_EsSupEmpr number(5);
  
    cursor documentos(ln_FlagCony number) is
    
      select distinct (trim(f.pendoc)) lc_doc,
                      f.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.pgcod = 1
         and f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct (trim(g.rpndoc)) lc_doc,
                      g.rptdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.pgcod = 1
         and f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and 1 = ln_FlagCony
         and g.rptdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct (trim(g.pendoc)) lc_doc,
                      g.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.pgcod = 1
         and f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and 1 = ln_FlagCony
         and g.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5;
  
    cursor cod_sbs(lc_doc in character, ln_tdocid in number) is
    
      select cldrcci.c_codsbs lc_CodSbs
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC
         and cldrcci.c_tdocid = ln_tdocid
         and cldrcci.c_docide = lc_doc
      union
      select cldrcci.c_codsbs lc_CodSbs
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC
         and cldrcci.C_TDOCTR = ln_tdocid
         and cldrcci.C_DOCTRI = lc_doc;
  
    cursor entidad(lc_CodSbs in varchar2) is
    
      select distinct C_CODEMP lc_emp
        from CLDRCCS
       Where C_CODSBS = lc_CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = ld_FecRCC;
  
    cursor deu_cre(lc_emp in varchar2, lc_CodSbs in varchar2) is
      select x.Gasto,
             (select y.c_desefi
                from ahtbanc y
               where y.c_codefi = x.c_codemp
                 and rownum = 1) desefi,
             (select y.c_codefi
                from ahtbanc y
               where y.c_codefi = x.c_codemp
                 and rownum = 1) codefi,
             substr(x.c_cuenta, 3, 1) moneda,
             case
             --chernandez 17/02/2020 2
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then --chernandez 17/02/2020 2
                substr(x.c_cuenta, 5, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72.5') then
                substr(x.c_cuenta, 7, 2)
             end tipo,
             x.c_cuenta,
             x.c_cretip tipcre,
             case
               when REGEXP_LIKE(x.c_cuenta, '^14') then
                substr(x.c_cuenta, 1, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72') then
                substr(x.c_cuenta, 1, 2)
             end cod_r
        from (select sum(case --chernandez 17/02/2020 2
                           when REGEXP_LIKE(c_cuenta,
                                            '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') then
                            a.n_salcap --chernandez 09/03/2020
                           when REGEXP_LIKE(c_cuenta,
                                            '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601') then
                            a.n_salcap
                         --when REGEXP_LIKE(c_cuenta, '^14.[1-6]0306|^14.[1-6]0303') then a.n_salcap /*efuentes*/
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]0303') then
                            a.n_salcap /*efuentes*/
                           when REGEXP_LIKE(c_cuenta, '^72.506') then
                            a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^72.503') and
                                not
                                 REGEXP_LIKE(c_cuenta, '^72.5030202|^72.5030302') then
                            a.n_salcap
                           else
                            0
                         end) Gasto,
                     c_CodEmp,
                     c_cuenta,
                     SUM(a.n_salcap) capital,
                     a.c_cretip
                from cldrccs a
               where c_codsbs = lc_CodSbs
                 and d_fecpre = ld_FecRCC
                 and C_CODEMP <> '00104'
                 and C_CODEMP = lc_emp
               group by c_CodEmp, c_cuenta, c_cretip) x
       where x.gasto <> 0;
  
    cursor deuda is
      select aqpa412inst,
             aqpa412moda,
             aqpa412tipo,
             aqpa412user,
             aqpa412csbs,
             aqpa412frcc,
             aqpa412fpro,
             aqpa412enti,
             aqpa412cent,
             aqpa412ndoc,
             p.tipocredito,
             nvl((select jj.aqpa412rubro
                   from aqpa412 jj
                  where jj.aqpa412inst = p.aqpa412inst
                    and jj.aqpa412moda = p.aqpa412moda
                    and jj.aqpa412tipo = p.aqpa412tipo
                    and jj.aqpa412cent = p.aqpa412cent
                    and jj.aqpa412ndoc = p.aqpa412ndoc
                    and jj.aqpa412user = p.aqpa412user
                    and trim(substr(jj.aqpa412rubro, 1, 2)) = '14'
                    and rownum = 1),
                 (select jj.aqpa412rubro
                    from aqpa412 jj
                   where jj.aqpa412inst = p.aqpa412inst
                     and jj.aqpa412moda = p.aqpa412moda
                     and jj.aqpa412tipo = p.aqpa412tipo
                     and jj.aqpa412cent = p.aqpa412cent
                     and jj.aqpa412ndoc = p.aqpa412ndoc
                     and jj.aqpa412user = p.aqpa412user
                     and substr(jj.aqpa412rubro, 1, 2) = '72'
                     and rownum = 1)) rubro,
             (select jj.aqpa412rubro
                from aqpa412 jj
               where jj.aqpa412inst = p.aqpa412inst
                 and jj.aqpa412moda = p.aqpa412moda
                 and jj.aqpa412tipo = p.aqpa412tipo
                 and jj.aqpa412cent = p.aqpa412cent
                 and jj.aqpa412ndoc = p.aqpa412ndoc
                 and jj.aqpa412user = p.aqpa412user
                 and substr(jj.aqpa412rubro, 1, 2) = '72'
                 and rownum = 1) rubro_72,
             uso,
             nouso
        from (select aqpa412inst,
                     aqpa412moda,
                     aqpa412tipo,
                     aqpa412user,
                     aqpa412csbs,
                     aqpa412frcc,
                     aqpa412fpro,
                     aqpa412enti,
                     aqpa412cent,
                     aqpa412ndoc,
                     MAX(AQPA412AUX1) tipocredito,
                     sum(uso) uso,
                     sum(nouso) nouso
                from (select j.aqpa412inst,
                             j.aqpa412moda,
                             j.aqpa412tipo,
                             j.aqpa412user,
                             j.aqpa412csbs,
                             j.aqpa412frcc,
                             j.aqpa412fpro,
                             j.aqpa412enti,
                             j.aqpa412cent,
                             j.aqpa412ndoc,
                             j.AQPA412AUX1,
                             case
                               when substr(aqpa412rubro, 1, 2) = '14' then
                                aqpa412gast
                             end uso,
                             case
                               when substr(aqpa412rubro, 1, 2) = '72' then
                                aqpa412gast
                             end nouso
                        from aqpa412 j
                       where j.aqpa412user = lc_Usuario
                         and j.aqpa412inst = ln_instancia)
               group by aqpa412inst,
                        aqpa412moda,
                        aqpa412tipo,
                        aqpa412user,
                        aqpa412csbs,
                        aqpa412frcc,
                        aqpa412fpro,
                        aqpa412enti,
                        aqpa412cent,
                        aqpa412ndoc) p;
  
  begin
    begin
      delete from aqpa412 a where a.aqpa412inst = ln_instancia;
      -- and a.aqpa412user = lc_Usuario;
      delete from aqpa413 a where a.aqpa413inst = ln_instancia;
      --  and a.aqpa413user = lc_Usuario;
    end;
    ln_cont     := 1;
    ln_FlagCony := 1;
    -- PRY6415 Mpostigoc 21.08.2023
    begin
      select count(*)
        into ln_EsSupEmpr
        from fst004 f
       where (f.modulo, f.totope) in
             (select x.xwfmodulo, x.xwftipope
                from xwf700 x
               where x.xwfprcins = ln_instancia
                 and x.xwfcar3 = '1')
         and f.modulo = 103
         and (f.tonom like '%Sup%' or f.tonom like '%Emp%');
    exception
      when others then
        null;
    end;
  
    if ln_EsSupEmpr > 0 then
      ln_FlagCony := 2;
    else
      ln_FlagCony := 1;
    end if;
  
    for a in documentos(ln_FlagCony) loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into aqpa412
              (aqpa412corr,
               aqpa412inst,
               aqpa412user,
               aqpa412csbs,
               aqpa412ndoc,
               aqpa412frcc,
               aqpa412fpro,
               aqpa412rubro,
               aqpa412enti,
               aqpa412cent,
               aqpa412gast,
               aqpa412moda,
               aqpa412tipo,
               AQPA412AUX1,
               AQPA412AUX4)
            values
              (ln_cont,
               ln_instancia,
               lc_Usuario,
               b.lc_codsbs,
               a.lc_doc,
               ld_FecRCC,
               ld_FecPro,
               j.c_cuenta,
               j.desefi,
               j.codefi,
               j.gasto,
               j.moneda,
               j.tipo,
               j.tipcre,
               j.cod_r);
            commit;
            ln_cont := ln_cont + 1;
          end loop;
        end loop;
      end loop;
    end loop;
  
    ln_cont := 1;
    for k in deuda loop
      insert into aqpa413
        (aqpa413corr,
         aqpa413inst,
         aqpa413moda,
         aqpa413tipo,
         aqpa413user,
         aqpa413csbs,
         aqpa413frcc,
         aqpa413fpro,
         aqpa413rubro,
         aqpa413rub72,
         aqpa413enti,
         aqpa413cent,
         aqpa413util,
         aqpa413nout,
         aqpa413tipc,
         aqpa413ndoc)
      values
        (ln_cont,
         k.aqpa412inst,
         k.aqpa412moda,
         k.aqpa412tipo,
         k.aqpa412user,
         k.aqpa412csbs,
         k.aqpa412frcc,
         k.aqpa412fpro,
         k.rubro,
         k.rubro_72,
         k.aqpa412enti,
         k.aqpa412cent,
         k.uso,
         k.nouso,
         k.tipocredito,
         k.aqpa412ndoc);
      commit;
      ln_cont := ln_cont + 1;
    end loop;
  
  end sp_cr_TarjetasCredito;

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2) is
  
    ln_cont      number(10);
    ln_FlagCony  number(5);
    ln_EsSupEmpr number(5);
  
    cursor documentos(ln_FlagCony number) is
    
      select distinct (trim(f.pendoc)) lc_doc,
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
      select distinct (trim(g.rpndoc)) lc_doc,
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
         and 1 = ln_FlagCony
         and g.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5
      union
      select distinct (trim(g.pendoc)) lc_doc,
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
         and 1 = ln_FlagCony
         and g.rptdoc = ff.tp1nro1
         and ff.Tp1cod = 1
         and ff.Tp1cod1 = 11111
         and ff.Tp1corr1 = 1
         and ff.Tp1corr2 = 5;
  
    cursor cod_sbs(lc_doc in character, ln_tdocid in number) is
    
      select cldrcci.c_codsbs lc_CodSbs
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC
         and cldrcci.c_tdocid = trim(ln_tdocid)
         and cldrcci.c_docide = lc_doc
      union
      select cldrcci.c_codsbs lc_CodSbs
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC
         and cldrcci.C_TDOCTR = Trim(ln_tdocid)
         and cldrcci.C_DOCTRI = lc_doc;
  
    cursor entidad(lc_CodSbs in varchar2) is
    
      select distinct C_CODEMP lc_emp
        from CLDRCCS
       Where C_CODSBS = lc_CodSbs
         and C_CODEMP <> '00104'
         and D_FECPRE = ld_FecRCC;
  
    cursor deu_cre(lc_emp in varchar2, lc_CodSbs in varchar2) is
    
      select x.Gasto,
             (select y.c_desefi
                from ahtbanc y
               where y.c_codefi = x.c_codemp
                 and rownum = 1) desefi,
             (select y.c_codefi
                from ahtbanc y
               where y.c_codefi = x.c_codemp
                 and rownum = 1) codefi,
             substr(x.c_cuenta, 3, 1) moneda,
             case
             --chernandez 17/02/2020 2
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then --chernandez 09/03/2020 2
                substr(x.c_cuenta, 5, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72.5') then
                substr(x.c_cuenta, 7, 2)
             end tipo,
             x.c_cuenta,
             x.c_cretip tipcre
        from (select sum(case
                         --chernandez 17/02/2020 2
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]') and not
                                 REGEXP_LIKE(c_cuenta,
                                                                                    '^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601') then
                            a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^71.[1-4]') then
                            a.n_salcap
                           else
                            0
                         end) Gasto,
                     c_CodEmp,
                     c_cuenta,
                     SUM(a.n_salcap) capital,
                     a.c_cretip
                from cldrccs a
               where c_codsbs = lc_CodSbs
                 and d_fecpre = ld_FecRCC
                 and C_CODEMP <> '00104'
                 and C_CODEMP = lc_emp
               group by c_CodEmp, c_cuenta, c_cretip) x
       where x.gasto <> 0;
  
  begin
  
    begin
      delete from aqpa414 a where a.aqpa414inst = ln_instancia;
    end;
  
    ln_cont     := 1;
    ln_FlagCony := 1;
    -- PRY6415 Mpostigoc 21.08.2023
    begin
      select count(*)
        into ln_EsSupEmpr
        from fst004 f
       where (f.modulo, f.totope) in
             (select x.xwfmodulo, x.xwftipope
                from xwf700 x
               where x.xwfprcins = ln_instancia
                 and x.xwfcar3 = '1')
         and f.modulo = 103
         and (f.tonom like '%Sup%' or f.tonom like '%Emp%');
    exception
      when others then
        null;
    end;
  
    if ln_EsSupEmpr > 0 then
      ln_FlagCony := 2;
    else
      ln_FlagCony := 1;
    end if;
  
    for a in documentos(ln_FlagCony) loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into aqpa414
              (aqpa414corr,
               aqpa414inst,
               aqpa414moda,
               aqpa414tipo,
               aqpa414user,
               aqpa414csbs,
               aqpa414frcc,
               aqpa414fpro,
               aqpa414rubro,
               aqpa414enti,
               aqpa414cent,
               aqpa414tipc,
               aqpa414ndoc,
               AQPA414SDEU)
            values
              (ln_cont,
               ln_instancia,
               j.moneda,
               j.tipo,
               lc_Usuario,
               b.lc_codsbs,
               ld_FecRCC,
               ld_FecPro,
               j.c_cuenta,
               j.desefi,
               j.codefi,
               j.tipcre,
               a.lc_doc,
               J.GASTO);
            commit;
            ln_cont := ln_cont + 1;
          
          end loop;
        
        end loop;
      end loop;
    
    end loop;
  
  end sp_cr_Prestamo;

  Procedure sp_cr_CalculaFactor(lc_rubro     in varchar2,
                                ln_instancia in number,
                                ln_factor    out number) is
  
    ln_Grupo number;
  
  begin
  
    begin
    
      select tp1corr2
        into ln_Grupo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11105
         and a.tp1corr1 = 19
         and REGEXP_LIKE(lc_rubro, '^' || trim(tp1desc))
         and (case
               when a.tp1corr2 = 4 then
                case
                  when substr(lc_rubro, 9, 2) not in ('02', '11', '12') then
                   1
                  else
                   0
                end
               when a.tp1corr2 = 7 then
                case
                  when substr(lc_rubro, 7, 2) not in ('02', '06', '99') then
                   1
                  else
                   case
                     when substr(lc_rubro, 7, 4) not in ('0601', '9901') and
                          substr(lc_rubro, 7, 2) <> '02' then
                      1
                     else
                      0
                   end
                end
               when a.tp1corr2 = 15 then
                case
                  when substr(lc_rubro, 7, 4) in ('0202', '0302') then
                   0
                  else
                   1
                end
               else
                1
             end) = 1
         and rownum = 1;
    
    exception
      when no_data_found then
        ln_Grupo := 0;
    end;
  
    begin
      select a.aqpa024fact
        into ln_factor
        from aqpa024 a
       Where a.aqpa024inst = ln_instancia
         and a.aqpa024grup = ln_Grupo;
    exception
      when no_data_found then
        ln_factor := 0.00;
    end;
  
  end sp_cr_CalculaFactor;

  Procedure sp_cr_ActualizaCuota(ln_instancia  in number,
                                 ln_evaluacion in number) is
  
    ln_Grupo         number(10);
    ln_factor2       number(10, 6);
    ln_cuotPotencial number(17, 2);
    lc_rubro         varchar2(14);
    ln_factor1       number(10, 6);
    ln_cuota         number(17, 2);
    ln_cuotacalc     number(17, 2);
    ln_cuotRedon     number(17, 2);
  
    cursor jaqy327 is
      select *
        from jaqy327
       where jaqy327inst = ln_instancia
         and jaqy327esta = 'S'
         and jaqy327chek = '1';
  
  begin
  
    pQ_CR_CALC_METSOBREEND.SP_INICIO(ln_instancia, ln_evaluacion);
  
    for i in jaqy327 loop
    
      begin
        select tp1imp1
          into ln_cuotRedon
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11132
           and tp1corr1 = 1
           and tp1corr2 = 1;
      exception
        when no_data_found then
          ln_cuotRedon := 0.01;
      end;
    
      ln_Grupo         := 0;
      ln_factor2       := 0.00;
      ln_cuotPotencial := 0.00;
      ln_factor1       := 0.00;
      ln_cuota         := 0.00;
      ln_cuotacalc     := 0.00;
    
      if i.jaqy327dori = '1' then
      
        if i.jaqy327flin = 'L' then
        
          --ln_Grupo := 8;
        
          --chernandez 17/02/2020 1
          sp_cr_ObtieneGrupoLinea(i.jaqy327rubr, ln_Grupo);
        
          begin
            select aqpa024fact
              into ln_factor2 --0.000880             
              from aqpa024
             where aqpa024inst = ln_instancia
               and aqpa024grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          if ln_factor2 = 0 and ln_Grupo = 15 then
            -- mpostigoc 16.06.2023
          
            begin
              select aqpa024fact
                into ln_factor2
                from aqpa024
               where aqpa024inst = ln_instancia
                 and aqpa024grup = 2;
            exception
              when no_data_found then
                ln_factor2 := 0.00;
            end;
          end if;
        
          ln_cuotPotencial := i.jaqy327aux8 * ln_factor2;
          lc_rubro         := substr(i.jaqy327rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.jaqy327rubr,
                                                        ln_instancia,
                                                        ln_factor1);
          
            ln_cuota := i.jaqy327util * ln_factor1;
          
          end if;
        
          ln_cuotacalc := ln_cuotPotencial + ln_cuota;
        
          if round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;
        
          update jaqy327
             set jaqy327cptn  = ln_cuotPotencial,
                 jaqy327fac1  = ln_factor1,
                 jaqy327fac2  = ln_factor2,
                 jaqy327ccalc = ln_cuotacalc
           where jaqy327inst = i.jaqy327inst
             and jaqy327esta = i.jaqy327esta
             and jaqy327dori = i.jaqy327dori
             and jaqy327flin = i.jaqy327flin
             and jaqy327corr = i.jaqy327corr;
          commit;
        
        else
        
          pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.jaqy327rubr,
                                                      ln_instancia,
                                                      ln_factor1);
        
          ln_cuota := i.jaqy327sdeu * ln_factor1;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update jaqy327
             set jaqy327fac3 = ln_factor1, jaqy327ccalc = ln_cuota
           where jaqy327inst = i.jaqy327inst
             and jaqy327esta = i.jaqy327esta
             and jaqy327dori = i.jaqy327dori
             and jaqy327flin = i.jaqy327flin
             and jaqy327corr = i.jaqy327corr;
          commit;
        
        end if;
      else
        if i.jaqy327dori = '2' then
        
          ln_Grupo := 13;
        
          begin
            select aqpa024fact
              into ln_factor2
              from aqpa024
             where aqpa024inst = ln_instancia
               and aqpa024grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuota := i.jaqy327sdeu * ln_factor2;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update jaqy327
             set jaqy327fac3 = ln_factor2, jaqy327ccalc = ln_cuota
           where jaqy327inst = i.jaqy327inst
             and jaqy327esta = i.jaqy327esta
             and jaqy327dori = i.jaqy327dori
             and jaqy327flin = i.jaqy327flin
             and jaqy327corr = i.jaqy327corr;
          commit;
        
        else
          if i.jaqy327dori = '3' then
          
            if i.jaqy327flin = 'L' then
            
              ln_Grupo := 8;
            
              begin
                select aqpa024fact
                  into ln_factor2
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select aqpa024fact
                      into ln_factor2
                      from aqpa024
                     where aqpa024inst = ln_instancia
                       and aqpa024grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.jaqy327aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select aqpa024fact
                  into ln_factor1
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
            
              ln_cuota     := i.jaqy327util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update jaqy327
                 set jaqy327cptn  = ln_cuotPotencial,
                     jaqy327fac1  = ln_factor1,
                     jaqy327fac2  = ln_factor2,
                     jaqy327ccalc = ln_cuotacalc
               where jaqy327inst = i.jaqy327inst
                 and jaqy327esta = i.jaqy327esta
                 and jaqy327dori = i.jaqy327dori
                 and jaqy327flin = i.jaqy327flin
                 and jaqy327corr = i.jaqy327corr;
              commit;
            
            else
            
              ln_Grupo := 11;
            
              begin
                select aqpa024fact
                  into ln_factor1
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
              ln_cuotacalc := i.jaqy327sdeu * ln_factor1;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update jaqy327
                 set jaqy327fac3 = ln_factor1, jaqy327ccalc = ln_cuotacalc
               where jaqy327inst = i.jaqy327inst
                 and jaqy327esta = i.jaqy327esta
                 and jaqy327dori = i.jaqy327dori
                 and jaqy327flin = i.jaqy327flin
                 and jaqy327corr = i.jaqy327corr;
              commit;
            
            end if;
          end if;
        end if;
      end if;
    end loop;
  
  end sp_cr_ActualizaCuota;

  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number) is
  
    ln_Grupo         number(10);
    ln_factor2       number(10, 6);
    ln_cuotPotencial number(17, 2);
    lc_rubro         varchar2(14);
    ln_factor1       number(10, 6);
    ln_cuota         number(17, 2);
    ln_cuotacalc     number(17, 2);
    ln_cuotRedon     number(17, 2);
  
    cursor jaqz862 is
      select *
        from jaqz862
       where jaqz862inst = ln_instancia
         and jaqz862esta = 'S'
         and jaqz862chek = '1';
  
  begin
  
    pQ_CR_CALC_METSOBREEND.SP_INICIO(ln_instancia, ln_evaluacion);
  
    for i in jaqz862 loop
    
      begin
        select tp1imp1
          into ln_cuotRedon
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11132
           and tp1corr1 = 1
           and tp1corr2 = 1;
      exception
        when no_data_found then
          ln_cuotRedon := 0.01;
      end;
    
      ln_Grupo         := 0;
      ln_factor2       := 0.00;
      ln_cuotPotencial := 0.00;
      ln_factor1       := 0.00;
      ln_cuota         := 0.00;
      ln_cuotacalc     := 0.00;
    
      if i.jaqz862dori = '1' then
      
        if i.jaqz862flin = 'L' then
        
          --ln_Grupo := 8;
        
          --chernandez 17/02/2020 1
          sp_cr_ObtieneGrupoLinea(i.jaqz862rubr, ln_Grupo);
        
          begin
            select aqpa024fact
              into ln_factor2 --0.000880             
              from aqpa024
             where aqpa024inst = ln_instancia
               and aqpa024grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuotPotencial := i.jaqz862aux8 * ln_factor2;
          lc_rubro         := substr(i.jaqz862rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.jaqz862rubr,
                                                        ln_instancia,
                                                        ln_factor1);
          
            ln_cuota := i.jaqz862util * ln_factor1;
          end if;
        
          ln_cuotacalc := ln_cuotPotencial + ln_cuota;
        
          if Round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;
        
          update jaqz862
             set jaqz862cptn  = ln_cuotPotencial,
                 jaqz862fac1  = ln_factor1,
                 jaqz862fac2  = ln_factor2,
                 jaqz862ccalc = ln_cuotacalc
           where jaqz862inst = i.jaqz862inst
             and jaqz862esta = i.jaqz862esta
             and jaqz862dori = i.jaqz862dori
             and jaqz862flin = i.jaqz862flin
             and jaqz862corr = i.jaqz862corr;
          commit;
        
        else
        
          pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.jaqz862rubr,
                                                      ln_instancia,
                                                      ln_factor1);
        
          ln_cuota := i.jaqz862sdeu * ln_factor1;
        
          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update jaqz862
             set jaqz862fac3 = ln_factor1, jaqz862ccalc = ln_cuota
           where jaqz862inst = i.jaqz862inst
             and jaqz862esta = i.jaqz862esta
             and jaqz862dori = i.jaqz862dori
             and jaqz862flin = i.jaqz862flin
             and jaqz862corr = i.jaqz862corr;
          commit;
        
        end if;
      else
        if i.jaqz862dori = '2' then
        
          ln_Grupo := 13;
        
          begin
            select aqpa024fact
              into ln_factor2
              from aqpa024
             where aqpa024inst = ln_instancia
               and aqpa024grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuota := i.jaqz862sdeu * ln_factor2;
        
          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update jaqz862
             set jaqz862fac3 = ln_factor2, jaqz862ccalc = ln_cuota
           where jaqz862inst = i.jaqz862inst
             and jaqz862esta = i.jaqz862esta
             and jaqz862dori = i.jaqz862dori
             and jaqz862flin = i.jaqz862flin
             and jaqz862corr = i.jaqz862corr;
          commit;
        
        else
          if i.jaqz862dori = '3' then
          
            if i.jaqz862flin = 'L' then
            
              ln_Grupo := 8;
            
              begin
                select aqpa024fact
                  into ln_factor2
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select aqpa024fact
                      into ln_factor2
                      from aqpa024
                     where aqpa024inst = ln_instancia
                       and aqpa024grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.jaqz862aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select aqpa024fact
                  into ln_factor1
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
            
              ln_cuota     := i.jaqz862util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;
            
              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update jaqz862
                 set jaqz862cptn  = ln_cuotPotencial,
                     jaqz862fac1  = ln_factor1,
                     jaqz862fac2  = ln_factor2,
                     jaqz862ccalc = ln_cuotacalc
               where jaqz862inst = i.jaqz862inst
                 and jaqz862esta = i.jaqz862esta
                 and jaqz862dori = i.jaqz862dori
                 and jaqz862flin = i.jaqz862flin
                 and jaqz862corr = i.jaqz862corr;
              commit;
            
            else
            
              ln_Grupo := 11;
            
              begin
                select aqpa024fact
                  into ln_factor1
                  from aqpa024
                 where aqpa024inst = ln_instancia
                   and aqpa024grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
              ln_cuotacalc := i.jaqz862sdeu * ln_factor1;
            
              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update jaqz862
                 set jaqz862fac3 = ln_factor1, jaqz862ccalc = ln_cuotacalc
               where jaqz862inst = i.jaqz862inst
                 and jaqz862esta = i.jaqz862esta
                 and jaqz862dori = i.jaqz862dori
                 and jaqz862flin = i.jaqz862flin
                 and jaqz862corr = i.jaqz862corr;
              commit;
            
            end if;
          end if;
        end if;
      end if;
    end loop;
  
  end sp_cr_ActualizaCuotaConsumo;
  --chernandez 17/02/2020 1
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro in varchar2,
                                    ln_Grupo out number) is
  
    lv_FlagExcep varchar(2);
  begin
  
    begin
    
      select tp1corr2
        into ln_Grupo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11105
         and a.tp1corr1 = 19
         and REGEXP_LIKE(lc_rubro, '^' || trim(tp1desc))
         and (case
               when a.tp1corr2 = 15 then
                case
                  when substr(lc_rubro, 7, 4) in ('0202', '0302') then
                   0 --chernandez 17/02/2020
                  else
                   1
                end
               else
                1
             end) = 1
         and rownum = 1;
    exception
      when no_data_found then
        ln_Grupo := 0;
    end;
    if ln_Grupo = 1 then
      ln_Grupo := 8;
    end if;
    if ln_Grupo = 2 then
      ln_Grupo := 15;
    end if;
  
  end sp_cr_ObtieneGrupoLinea;
  ----------------------------------------------------------------------
  procedure sp_Cr_TotalCuotPotenc(ln_instancia in number,
                                  ln_CPPymeSol out number,
                                  ln_CPConsSol out number,
                                  ln_CPHiptSol out number,
                                  ln_CPPymeDol out number,
                                  ln_CPConsDol out number,
                                  ln_CPHiptDol out number) is
  
  begin
    begin
      select sum(j.jaqy327cptn)
        into ln_CPPymeSol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre in ('Pymes S/.', 'Pymes US$')
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPPymeSol := 0;
    end;
  
    ln_CPPymeSol := nvl(ln_CPPymeSol, 0);
  
    begin
      select sum(j.jaqy327cptn)
        into ln_CPConsSol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre in ('Consumo S/.', 'Consumo US$')
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPConsSol := 0;
    end;
    ln_CPConsSol := nvl(ln_CPConsSol, 0);
  
    begin
      select sum(j.jaqy327cptn)
        into ln_CPHiptSol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre in ('Hipotecario S/.', 'Hipotecario US$')
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPHiptSol := 0;
    end;
    ln_CPHiptSol := nvl(ln_CPHiptSol, 0);
  
    /*begin
      select sum(j.jaqy327cptn)
        into ln_CPPymeDol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre = 'Pymes US$'
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPPymeDol := 0;
    end;*/
  
    ln_CPPymeDol := nvl(ln_CPPymeDol, 0);
  
    /*begin
      select sum(j.jaqy327cptn)
        into ln_CPConsDol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre = 'Consumo US$'
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPConsDol := 0;
    end;*/
    ln_CPConsDol := nvl(ln_CPConsDol, 0);
  
    /*begin
      select sum(j.jaqy327cptn)
        into ln_CPHiptDol
        from jaqy327 j
       where j.jaqy327inst = ln_instancia
         and j.jaqy327esta = 'S'
         and j.jaqy327tcre = 'Hipotecario US$'
         and j.jaqy327chek = '1';
    exception
      when others then
        ln_CPHiptDol := 0;
    end;*/
    ln_CPHiptDol := nvl(ln_CPHiptDol, 0);
  
  end sp_Cr_TotalCuotPotenc;
  -------------------------------------------------------------------

  procedure sp_cr_actualizCuotPoten(ln_instancia in number,
                                    ln_nevaluaci in number) is
  
    CodFin_Soles   number(4);
    CodFin_Dolares number(4);
    CodFam_Soles   number(4);
    CodFam_Dolares number(4);
  
    ln_cppymesol number(17, 2);
    ln_cpconssol number(17, 2);
    ln_cphiptsol number(17, 2);
    ln_cppymedol number(17, 2);
    ln_cpconsdol number(17, 2);
    ln_cphiptdol number(17, 2);
    X_instancia  number(10);
    xPymm        number(17, 2);
    x_nevaluaci  number(10);
  
  begin
    CodFin_Soles   := 79; --> Gastos financieros Pyme soles
    CodFin_Dolares := 579; --> Gastos financieros Pyme dolares
    CodFam_Soles   := 19; --> Gastos familiares Consumo / Hipotecario
    CodFam_Dolares := 519; --> Gastos familiares Consumo / Hipotecario
  
    /*ln_instancia := 20578793;
    x_nevaluaci := 7256182;
    X_instancia := 20578793;*/
    x_nevaluaci := ln_nevaluaci;
  
    BEGIN
      pq_cr_endeudamiento_rcc.sp_Cr_TotalCuotPotenc(ln_instancia,
                                                    ln_cppymesol,
                                                    ln_cpconssol,
                                                    ln_cphiptsol,
                                                    ln_cppymedol,
                                                    ln_cpconsdol,
                                                    ln_cphiptdol);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      Update sng023
         set SNG023Mto = SNG023Mto + ln_cppymesol
       where SNG021Eval = x_nevaluaci
         AND SNG026Cod = CodFin_Soles;
      COMMIT;
    exception
      when others then
        NULL;
    end;
  
    begin
      Update sng023
         set SNG023Mto = SNG023Mto + ln_cppymedol
       where SNG021Eval = x_nevaluaci
         AND SNG026Cod = CodFin_Dolares;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      Update sng023
         set SNG023Mto = SNG023Mto + ln_cpconssol + ln_cphiptsol
       where SNG021Eval = x_nevaluaci
         AND SNG026Cod = CodFam_Soles;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      Update sng023
         set SNG023Mto = SNG023Mto + ln_cpconsdol + ln_cphiptdol
       where SNG021Eval = x_nevaluaci
         AND SNG026Cod = CodFam_Dolares;
      commit;
    exception
      when others then
        null;
    end;
  
  end;

end PQ_CR_ENDEUDAMIENTO_RCC;
/

