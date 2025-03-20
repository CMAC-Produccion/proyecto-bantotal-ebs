create or replace package PQ_CR_ENDEUDAMIENTO_RCC_CPY is

  -- Author  : RMONTES
  -- Created : 28/01/2021
  -- Purpose : COPIA DE PQ_CR_ENDEUDAMIENTO_RCC

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

  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro     in varchar2,
                                ln_Grupo    out number);
end PQ_CR_ENDEUDAMIENTO_RCC_CPY;
/

create or replace package body PQ_CR_ENDEUDAMIENTO_RCC_CPY is

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2) is

    ln_cont number(10);

    cursor documentos is

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
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then--chernandez 17/02/2020 2
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
        from (select sum(case
  --chernandez 17/02/2020 2
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') then
                             a.n_salcap
                             --chernandez 09/03/2020
                           when REGEXP_LIKE(c_cuenta,
                                      '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601') then
                             a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^72.506') then
                            a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^72.503') and
                                not REGEXP_LIKE(c_cuenta, '^72.5030202|^72.5030302') then
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

      select aqpb361inst,
             aqpb361moda,
             aqpb361tipo,
             aqpb361user,
             aqpb361csbs,
             aqpb361frcc,
             aqpb361fpro,
             aqpb361enti,
             aqpb361cent,
             aqpb361ndoc,
             p.tipocredito,
             nvl((select jj.aqpb361rubro
                   from aqpb361 jj
                  where jj.aqpb361inst = p.aqpb361inst
                    and jj.aqpb361moda = p.aqpb361moda
                    and jj.aqpb361tipo = p.aqpb361tipo
                    and jj.aqpb361cent = p.aqpb361cent
                    and jj.aqpb361ndoc = p.aqpb361ndoc
                    and jj.aqpb361user = p.aqpb361user
                    and trim(substr(jj.aqpb361rubro, 1, 2)) = '14'
                    and rownum = 1),
                 (select jj.aqpb361rubro
                    from aqpb361 jj
                   where jj.aqpb361inst = p.aqpb361inst
                     and jj.aqpb361moda = p.aqpb361moda
                     and jj.aqpb361tipo = p.aqpb361tipo
                     and jj.aqpb361cent = p.aqpb361cent
                     and jj.aqpb361ndoc = p.aqpb361ndoc
                     and jj.aqpb361user = p.aqpb361user
                     and substr(jj.aqpb361rubro, 1, 2) = '72'
                     and rownum = 1)) rubro,
             (select jj.aqpb361rubro
                from aqpb361 jj
               where jj.aqpb361inst = p.aqpb361inst
                 and jj.aqpb361moda = p.aqpb361moda
                 and jj.aqpb361tipo = p.aqpb361tipo
                 and jj.aqpb361cent = p.aqpb361cent
                 and jj.aqpb361ndoc = p.aqpb361ndoc
                 and jj.aqpb361user = p.aqpb361user
                 and substr(jj.aqpb361rubro, 1, 2) = '72'
                 and rownum = 1) rubro_72,
             uso,
             nouso
        from (select aqpb361inst,
                     aqpb361moda,
                     aqpb361tipo,
                     aqpb361user,
                     aqpb361csbs,
                     aqpb361frcc,
                     aqpb361fpro,
                     aqpb361enti,
                     aqpb361cent,
                     aqpb361ndoc,
                     MAX(aqpb361AUX1) tipocredito,
                     sum(uso) uso,
                     sum(nouso) nouso
                from (select j.aqpb361inst,
                             j.aqpb361moda,
                             j.aqpb361tipo,
                             j.aqpb361user,
                             j.aqpb361csbs,
                             j.aqpb361frcc,
                             j.aqpb361fpro,
                             j.aqpb361enti,
                             j.aqpb361cent,
                             j.aqpb361ndoc,
                             j.aqpb361AUX1,
                             case
                               when substr(aqpb361rubro, 1, 2) = '14' then
                                aqpb361gast
                             end uso,
                             case
                               when substr(aqpb361rubro, 1, 2) = '72' then
                                aqpb361gast
                             end nouso
                        from aqpb361 j
                       where j.aqpb361user = lc_Usuario
                         and j.aqpb361inst = ln_instancia)
               group by aqpb361inst,
                        aqpb361moda,
                        aqpb361tipo,
                        aqpb361user,
                        aqpb361csbs,
                        aqpb361frcc,
                        aqpb361fpro,
                        aqpb361enti,
                        aqpb361cent,
                        aqpb361ndoc) p;

  begin
    begin
      delete from aqpb361 a where a.aqpb361inst = ln_instancia;
      -- and a.aqpb361user = lc_Usuario;
      delete from aqpb362 a where a.aqpb362inst = ln_instancia;
      --  and a.aqpb362user = lc_Usuario;
    end;
    ln_cont := 1;

    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop

            insert into aqpb361
              (aqpb361corr,
               aqpb361inst,
               aqpb361user,
               aqpb361csbs,
               aqpb361ndoc,
               aqpb361frcc,
               aqpb361fpro,
               aqpb361rubro,
               aqpb361enti,
               aqpb361cent,
               aqpb361gast,
               aqpb361moda,
               aqpb361tipo,
               aqpb361AUX1,
               aqpb361AUX4)
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

      insert into aqpb362
        (aqpb362corr,
         aqpb362inst,
         aqpb362moda,
         aqpb362tipo,
         aqpb362user,
         aqpb362csbs,
         aqpb362frcc,
         aqpb362fpro,
         aqpb362rubro,
         aqpb362rub72,
         aqpb362enti,
         aqpb362cent,
         aqpb362util,
         aqpb362nout,
         aqpb362tipc,
         aqpb362ndoc)
      values
        (ln_cont,
         k.aqpb361inst,
         k.aqpb361moda,
         k.aqpb361tipo,
         k.aqpb361user,
         k.aqpb361csbs,
         k.aqpb361frcc,
         k.aqpb361fpro,
         k.rubro,
         k.rubro_72,
         k.aqpb361enti,
         k.aqpb361cent,
         k.uso,
         k.nouso,
         k.tipocredito,
         k.aqpb361ndoc);
      commit;
      ln_cont := ln_cont + 1;
    end loop;

  end sp_cr_TarjetasCredito;

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2) is

    ln_cont number(10);

    cursor documentos is

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
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then--chernandez 09/03/2020 2
                substr(x.c_cuenta, 5, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72.5') then
                substr(x.c_cuenta, 7, 2)
             end tipo,
             x.c_cuenta,
             x.c_cretip tipcre
        from (select sum(case
      --chernandez 17/02/2020 2
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]')
                             and not
                                REGEXP_LIKE(c_cuenta,'^14.[1-6]..02|^14.[1-6]020601|^141[1-6]130601|^141[1-6]120601') then
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
      delete from aqpb363 a where a.aqpb363inst = ln_instancia;
    end;

    ln_cont := 1;
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop

            insert into aqpb363
              (aqpb363corr,
               aqpb363inst,
               aqpb363moda,
               aqpb363tipo,
               aqpb363user,
               aqpb363csbs,
               aqpb363frcc,
               aqpb363fpro,
               aqpb363rubro,
               aqpb363enti,
               aqpb363cent,
               aqpb363tipc,
               aqpb363ndoc,
               aqpb363SDEU)
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
  --chernandez 17/02/2020 2
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
      select a.aqpb365fact
        into ln_factor
        from aqpb365 a
       Where a.aqpb365inst = ln_instancia
         and a.aqpb365grup = ln_Grupo;
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
          sp_cr_ObtieneGrupoLinea(i.jaqy327rubr,ln_Grupo);

          begin
            select aqpb365fact
              into ln_factor2 --0.000880
              from aqpb365
             where aqpb365inst = ln_instancia
               and aqpb365grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;

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
            select aqpb365fact
              into ln_factor2
              from aqpb365
             where aqpb365inst = ln_instancia
               and aqpb365grup = ln_Grupo;
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
                select aqpb365fact
                  into ln_factor2
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select aqpb365fact
                      into ln_factor2
                      from aqpb365
                     where aqpb365inst = ln_instancia
                       and aqpb365grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;

              ln_cuotPotencial := i.jaqy327aux8 * ln_factor2;

              ln_Grupo := 12;

              begin
                select aqpb365fact
                  into ln_factor1
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
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
                select aqpb365fact
                  into ln_factor1
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
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

    cursor AQPB357 is
      select *
        from AQPB357
       where AQPB357inst = ln_instancia
         and AQPB357esta = 'S'
         and AQPB357chek = '1';

  begin

    pQ_CR_CALC_METSOBREEND.SP_INICIO(ln_instancia, ln_evaluacion);

    for i in AQPB357 loop

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

      if i.AQPB357dori = '1' then

        if i.AQPB357flin = 'L' then

          --ln_Grupo := 8;

          --chernandez 17/02/2020 1
          sp_cr_ObtieneGrupoLinea(i.AQPB357rubr,ln_Grupo);

          begin
            select aqpb365fact
              into ln_factor2 --0.000880
              from aqpb365
             where aqpb365inst = ln_instancia
               and aqpb365grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;

          ln_cuotPotencial := i.AQPB357aux8 * ln_factor2;
          lc_rubro         := substr(i.AQPB357rubr, 1, 2);

          if lc_rubro = '14' then

            pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.AQPB357rubr,
                                                        ln_instancia,
                                                        ln_factor1);

            ln_cuota := i.AQPB357util * ln_factor1;
          end if;

          ln_cuotacalc := ln_cuotPotencial + ln_cuota;

          if Round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;

          update AQPB357
             set AQPB357cptn  = ln_cuotPotencial,
                 AQPB357fac1  = ln_factor1,
                 AQPB357fac2  = ln_factor2,
                 AQPB357ccalc = ln_cuotacalc
           where AQPB357inst = i.AQPB357inst
             and AQPB357esta = i.AQPB357esta
             and AQPB357dori = i.AQPB357dori
             and AQPB357flin = i.AQPB357flin
             and AQPB357corr = i.AQPB357corr;
          commit;

        else

          pq_cr_endeudamiento_rcc.sp_cr_calculafactor(i.AQPB357rubr,
                                                      ln_instancia,
                                                      ln_factor1);

          ln_cuota := i.AQPB357sdeu * ln_factor1;

          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;

          update AQPB357
             set AQPB357fac3 = ln_factor1, AQPB357ccalc = ln_cuota
           where AQPB357inst = i.AQPB357inst
             and AQPB357esta = i.AQPB357esta
             and AQPB357dori = i.AQPB357dori
             and AQPB357flin = i.AQPB357flin
             and AQPB357corr = i.AQPB357corr;
          commit;

        end if;
      else
        if i.AQPB357dori = '2' then

          ln_Grupo := 13;

          begin
            select aqpb365fact
              into ln_factor2
              from aqpb365
             where aqpb365inst = ln_instancia
               and aqpb365grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;

          ln_cuota := i.AQPB357sdeu * ln_factor2;

          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;

          update AQPB357
             set AQPB357fac3 = ln_factor2, AQPB357ccalc = ln_cuota
           where AQPB357inst = i.AQPB357inst
             and AQPB357esta = i.AQPB357esta
             and AQPB357dori = i.AQPB357dori
             and AQPB357flin = i.AQPB357flin
             and AQPB357corr = i.AQPB357corr;
          commit;

        else
          if i.AQPB357dori = '3' then

            if i.AQPB357flin = 'L' then

              ln_Grupo := 8;

              begin
                select aqpb365fact
                  into ln_factor2
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select aqpb365fact
                      into ln_factor2
                      from aqpb365
                     where aqpb365inst = ln_instancia
                       and aqpb365grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;

              ln_cuotPotencial := i.AQPB357aux8 * ln_factor2;

              ln_Grupo := 12;

              begin
                select aqpb365fact
                  into ln_factor1
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;

              end;

              ln_cuota     := i.AQPB357util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;

              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;

              update AQPB357
                 set AQPB357cptn  = ln_cuotPotencial,
                     AQPB357fac1  = ln_factor1,
                     AQPB357fac2  = ln_factor2,
                     AQPB357ccalc = ln_cuotacalc
               where AQPB357inst = i.AQPB357inst
                 and AQPB357esta = i.AQPB357esta
                 and AQPB357dori = i.AQPB357dori
                 and AQPB357flin = i.AQPB357flin
                 and AQPB357corr = i.AQPB357corr;
              commit;

            else

              ln_Grupo := 11;

              begin
                select aqpb365fact
                  into ln_factor1
                  from aqpb365
                 where aqpb365inst = ln_instancia
                   and aqpb365grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;

              end;
              ln_cuotacalc := i.AQPB357sdeu * ln_factor1;

              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;

              update AQPB357
                 set AQPB357fac3 = ln_factor1, AQPB357ccalc = ln_cuotacalc
               where AQPB357inst = i.AQPB357inst
                 and AQPB357esta = i.AQPB357esta
                 and AQPB357dori = i.AQPB357dori
                 and AQPB357flin = i.AQPB357flin
                 and AQPB357corr = i.AQPB357corr;
              commit;

            end if;
          end if;
        end if;
      end if;
    end loop;

  end sp_cr_ActualizaCuotaConsumo;
  --chernandez 17/02/2020 1
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro     in varchar2,
                                ln_Grupo    out number) is


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
                  when substr(lc_rubro, 7, 4) in ('0202', '0302') then--chernandez 17/02/2020
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
    if ln_Grupo = 1 then
      ln_Grupo := 8;
    end if;
    if ln_Grupo = 2 then
      ln_Grupo := 15;
    end if;

  end sp_cr_ObtieneGrupoLinea;

end PQ_CR_ENDEUDAMIENTO_RCC_CPY;
/

