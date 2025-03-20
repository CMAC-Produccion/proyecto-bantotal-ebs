create or replace package PQ_CR_ENDEUDAMIENTO_RCC_FIC is

  -- Author  : CHERNANDEZ
  -- Created : 07/01/2020
  -- Modificación : chernandez 18/02/2020

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2,
                                  ln_cuenta    in number);

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2,
                           ln_cuenta    in number);

  Procedure sp_cr_CalculaFactor(lc_rubro     in varchar2,
                                ln_instancia in number,
                                ln_factor    out number);

  Procedure sp_cr_ActualizaCuota(ln_instancia  in number,
                                 ln_evaluacion in number,
                                 pn_cuenta     numeric,
                                 pn_pais       numeric,
                                 pn_tipdoc     numeric,
                                 pn_numdoc     character);

  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number,
                                        pn_cuenta     numeric,
                                        pn_pais       numeric,
                                        pn_tipdoc     numeric,
                                        pn_numdoc     varchar2);
  --chernandez 17/02/2020 1
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro     in varchar2,
                                ln_Grupo    out number);
  Procedure sp_cr_copiarData_FlujoExpress(pn_eval  numeric,
                                          pn_error out numeric);
  procedure sp_obtiene_instancia(pn_evaluacion numeric,
                                 pn_instancia  out numeric);
  procedure sp_verifica_rcc(pn_evaluacion numeric, pn_rpta out varchar2);
  procedure sp_actualiza_ingreso(pn_evaluacion numeric,
                                 pn_rpta       out varchar2);
end PQ_CR_ENDEUDAMIENTO_RCC_FIC;
/

create or replace package body PQ_CR_ENDEUDAMIENTO_RCC_FIC is

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2,
                                  ln_cuenta    in number) is
  
    ln_cont number(10);
  
    cursor documentos is
    
      select distinct (trim(f.pendoc)) lc_doc,
                      f.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.ctnro = ln_cuenta
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
       where f.ctnro = ln_cuenta
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
       where f.ctnro = ln_cuenta
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
        from (select sum(case  --chernandez 17/02/2020 2
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
    
      select AQPA027inst,
             AQPA027moda,
             AQPA027tipo,
             AQPA027user,
             AQPA027csbs,
             AQPA027frcc,
             AQPA027fpro,
             AQPA027enti,
             AQPA027cent,
             AQPA027ndoc,
             p.tipocredito,
             nvl((select jj.AQPA027rubro
                   from AQPA027 jj
                  where jj.AQPA027inst = p.AQPA027inst
                    and jj.AQPA027moda = p.AQPA027moda
                    and jj.AQPA027tipo = p.AQPA027tipo
                    and jj.AQPA027cent = p.AQPA027cent
                    and jj.AQPA027ndoc = p.AQPA027ndoc
                    and jj.AQPA027user = p.AQPA027user
                    and trim(substr(jj.AQPA027rubro, 1, 2)) = '14'
                    and rownum = 1),
                 (select jj.AQPA027rubro
                    from AQPA027 jj
                   where jj.AQPA027inst = p.AQPA027inst
                     and jj.AQPA027moda = p.AQPA027moda
                     and jj.AQPA027tipo = p.AQPA027tipo
                     and jj.AQPA027cent = p.AQPA027cent
                     and jj.AQPA027ndoc = p.AQPA027ndoc
                     and jj.AQPA027user = p.AQPA027user
                     and substr(jj.AQPA027rubro, 1, 2) = '72'
                     and rownum = 1)) rubro,
             (select jj.AQPA027rubro
                from AQPA027 jj
               where jj.AQPA027inst = p.AQPA027inst
                 and jj.AQPA027moda = p.AQPA027moda
                 and jj.AQPA027tipo = p.AQPA027tipo
                 and jj.AQPA027cent = p.AQPA027cent
                 and jj.AQPA027ndoc = p.AQPA027ndoc
                 and jj.AQPA027user = p.AQPA027user
                 and substr(jj.AQPA027rubro, 1, 2) = '72'
                 and rownum = 1) rubro_72,
             uso,
             nouso
        from (select AQPA027inst,
                     AQPA027moda,
                     AQPA027tipo,
                     AQPA027user,
                     AQPA027csbs,
                     AQPA027frcc,
                     AQPA027fpro,
                     AQPA027enti,
                     AQPA027cent,
                     AQPA027ndoc,
                     MAX(AQPA027AUX1) tipocredito,
                     sum(uso) uso,
                     sum(nouso) nouso
                from (select j.AQPA027inst,
                             j.AQPA027moda,
                             j.AQPA027tipo,
                             j.AQPA027user,
                             j.AQPA027csbs,
                             j.AQPA027frcc,
                             j.AQPA027fpro,
                             j.AQPA027enti,
                             j.AQPA027cent,
                             j.AQPA027ndoc,
                             j.AQPA027AUX1,
                             case
                               when substr(AQPA027rubro, 1, 2) = '14' then
                                AQPA027gast
                             end uso,
                             case
                               when substr(AQPA027rubro, 1, 2) = '72' then
                                AQPA027gast
                             end nouso
                        from AQPA027 j
                       where j.AQPA027user = lc_Usuario
                         and j.AQPA027inst = ln_instancia)
               group by AQPA027inst,
                        AQPA027moda,
                        AQPA027tipo,
                        AQPA027user,
                        AQPA027csbs,
                        AQPA027frcc,
                        AQPA027fpro,
                        AQPA027enti,
                        AQPA027cent,
                        AQPA027ndoc) p;
  
  begin
    begin
      delete from AQPA027 a where a.AQPA027inst = ln_instancia;
      -- and a.AQPA027user = lc_Usuario;
      delete from AQPA028 a where a.AQPA028inst = ln_instancia;
      --  and a.AQPA028user = lc_Usuario;
    end;
    ln_cont := 1;
  
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into AQPA027
              (AQPA027corr,
               AQPA027inst,
               AQPA027user,
               AQPA027csbs,
               AQPA027ndoc,
               AQPA027frcc,
               AQPA027fpro,
               AQPA027rubro,
               AQPA027enti,
               AQPA027cent,
               AQPA027gast,
               AQPA027moda,
               AQPA027tipo,
               AQPA027AUX1,
               AQPA027AUX4)
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
    
      insert into AQPA028
        (AQPA028corr,
         AQPA028inst,
         AQPA028moda,
         AQPA028tipo,
         AQPA028user,
         AQPA028csbs,
         AQPA028frcc,
         AQPA028fpro,
         AQPA028rubro,
         AQPA028rub72,
         AQPA028enti,
         AQPA028cent,
         AQPA028util,
         AQPA028nout,
         AQPA028tipc,
         AQPA028ndoc)
      values
        (ln_cont,
         k.AQPA027inst,
         k.AQPA027moda,
         k.AQPA027tipo,
         k.AQPA027user,
         k.AQPA027csbs,
         k.AQPA027frcc,
         k.AQPA027fpro,
         k.rubro,
         k.rubro_72,
         k.AQPA027enti,
         k.AQPA027cent,
         k.uso,
         k.nouso,
         k.tipocredito,
         k.AQPA027ndoc);
      commit;
      ln_cont := ln_cont + 1;
    end loop;
  
  end sp_cr_TarjetasCredito;

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2,
                           ln_cuenta    in number) is
  
    ln_cont number(10);
  
    cursor documentos is
    
      select distinct (trim(f.pendoc)) lc_doc,
                      f.petdoc ln_tdoc,
                      ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.ctnro = ln_cuenta
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
       where f.ctnro = ln_cuenta
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
       where f.ctnro = ln_cuenta
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
      delete from AQPA029 a where a.AQPA029inst = ln_instancia;
    end;
  
    ln_cont := 1;
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into AQPA029
              (AQPA029corr,
               AQPA029inst,
               AQPA029moda,
               AQPA029tipo,
               AQPA029user,
               AQPA029csbs,
               AQPA029frcc,
               AQPA029fpro,
               AQPA029rubro,
               AQPA029enti,
               AQPA029cent,
               AQPA029tipc,
               AQPA029ndoc,
               AQPA029SDEU)
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
      select a.AQPA030fact
        into ln_factor
        from AQPA030 a
       Where a.AQPA030inst = ln_instancia
         and a.AQPA030grup = ln_Grupo;
    exception
      when no_data_found then
        ln_factor := 0.00;
    end;
  
  end sp_cr_CalculaFactor;

  Procedure sp_cr_ActualizaCuota(ln_instancia  in number,
                                 ln_evaluacion in number,
                                 pn_cuenta     numeric,
                                 pn_pais       numeric,
                                 pn_tipdoc     numeric,
                                 pn_numdoc     character) is
  
    ln_Grupo         number(10);
    ln_factor2       number(10, 6);
    ln_cuotPotencial number(17, 2);
    lc_rubro         varchar2(14);
    ln_factor1       number(10, 6);
    ln_cuota         number(17, 2);
    ln_cuotacalc     number(17, 2);
    ln_cuotRedon     number(17, 2);
  
    cursor AQPA031 is
      select *
        from AQPA031
       where AQPA031inst = ln_instancia
         and AQPA031esta = 'S'
         and AQPA031chek = '1';
  
  begin
  
    PQ_CR_CALC_METSOBREEND_FIC.SP_INICIO(ln_instancia,
                                         ln_evaluacion,
                                         pn_cuenta,
                                         pn_pais,
                                         pn_tipdoc,
                                         pn_numdoc);
  
    for i in AQPA031 loop
    
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
    
      if i.AQPA031dori = '1' then
      
        if i.AQPA031flin = 'L' then
        
          --ln_Grupo := 8;
          --chernandez 18/02/2020 1
          sp_cr_ObtieneGrupoLinea(i.AQPA031rubr,ln_Grupo);
        
          begin
            select AQPA030fact
              into ln_factor2 --0.000880             
              from AQPA030
             where AQPA030inst = ln_instancia
               and AQPA030grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuotPotencial := i.AQPA031aux8 * ln_factor2;
          lc_rubro         := substr(i.AQPA031rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            PQ_CR_ENDEUDAMIENTO_RCC_FIC.sp_cr_calculafactor(i.AQPA031rubr,
                                                            ln_instancia,
                                                            ln_factor1);
          
            ln_cuota := i.AQPA031util * ln_factor1;
          
          end if;
        
          ln_cuotacalc := ln_cuotPotencial + ln_cuota;
        
          if round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;
        
          update AQPA031
             set AQPA031cptn  = ln_cuotPotencial,
                 AQPA031fac1  = ln_factor1,
                 AQPA031fac2  = ln_factor2,
                 AQPA031ccalc = ln_cuotacalc
           where AQPA031inst = i.AQPA031inst
             and AQPA031esta = i.AQPA031esta
             and AQPA031dori = i.AQPA031dori
             and AQPA031flin = i.AQPA031flin
             and AQPA031corr = i.AQPA031corr;
          commit;
        
        else
        
          PQ_CR_ENDEUDAMIENTO_RCC_FIC.sp_cr_calculafactor(i.AQPA031rubr,
                                                          ln_instancia,
                                                          ln_factor1);
        
          ln_cuota := i.AQPA031sdeu * ln_factor1;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update AQPA031
             set AQPA031fac3 = ln_factor1, AQPA031ccalc = ln_cuota
           where AQPA031inst = i.AQPA031inst
             and AQPA031esta = i.AQPA031esta
             and AQPA031dori = i.AQPA031dori
             and AQPA031flin = i.AQPA031flin
             and AQPA031corr = i.AQPA031corr;
          commit;
        
        end if;
      else
        if i.AQPA031dori = '2' then
        
          ln_Grupo := 13;
        
          begin
            select AQPA030fact
              into ln_factor2
              from AQPA030
             where AQPA030inst = ln_instancia
               and AQPA030grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuota := i.AQPA031sdeu * ln_factor2;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update AQPA031
             set AQPA031fac3 = ln_factor2, AQPA031ccalc = ln_cuota
           where AQPA031inst = i.AQPA031inst
             and AQPA031esta = i.AQPA031esta
             and AQPA031dori = i.AQPA031dori
             and AQPA031flin = i.AQPA031flin
             and AQPA031corr = i.AQPA031corr;
          commit;
        
        else
          if i.AQPA031dori = '3' then
          
            if i.AQPA031flin = 'L' then
            
              ln_Grupo := 8;
            
              begin
                select AQPA030fact
                  into ln_factor2
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select AQPA030fact
                      into ln_factor2
                      from AQPA030
                     where AQPA030inst = ln_instancia
                       and AQPA030grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.AQPA031aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select AQPA030fact
                  into ln_factor1
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
            
              ln_cuota     := i.AQPA031util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update AQPA031
                 set AQPA031cptn  = ln_cuotPotencial,
                     AQPA031fac1  = ln_factor1,
                     AQPA031fac2  = ln_factor2,
                     AQPA031ccalc = ln_cuotacalc
               where AQPA031inst = i.AQPA031inst
                 and AQPA031esta = i.AQPA031esta
                 and AQPA031dori = i.AQPA031dori
                 and AQPA031flin = i.AQPA031flin
                 and AQPA031corr = i.AQPA031corr;
              commit;
            
            else
            
              ln_Grupo := 11;
            
              begin
                select AQPA030fact
                  into ln_factor1
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
              ln_cuotacalc := i.AQPA031sdeu * ln_factor1;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update AQPA031
                 set AQPA031fac3 = ln_factor1, AQPA031ccalc = ln_cuotacalc
               where AQPA031inst = i.AQPA031inst
                 and AQPA031esta = i.AQPA031esta
                 and AQPA031dori = i.AQPA031dori
                 and AQPA031flin = i.AQPA031flin
                 and AQPA031corr = i.AQPA031corr;
              commit;
            
            end if;
          end if;
        end if;
      end if;
    end loop;
  
  end sp_cr_ActualizaCuota;

  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number,
                                        pn_cuenta     numeric,
                                        pn_pais       numeric,
                                        pn_tipdoc     numeric,
                                        pn_numdoc     varchar2) is
  
    ln_Grupo         number(10);
    ln_factor2       number(10, 6);
    ln_cuotPotencial number(17, 2);
    lc_rubro         varchar2(14);
    ln_factor1       number(10, 6);
    ln_cuota         number(17, 2);
    ln_cuotacalc     number(17, 2);
    ln_cuotRedon     number(17, 2);
  
    cursor AQPA032 is
      select *
        from AQPA032
       where AQPA032inst = ln_instancia
         and AQPA032esta = 'S'
         and AQPA032chek = '1';
  
  begin
  
    PQ_CR_CALC_METSOBREEND_FIC.SP_INICIO(ln_instancia,
                                         ln_evaluacion,
                                         pn_cuenta,
                                         pn_pais,
                                         pn_tipdoc,
                                         pn_numdoc);
  
    for i in AQPA032 loop
    
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
    
      if i.AQPA032dori = '1' then
      
        if i.AQPA032flin = 'L' then
        
          --ln_Grupo := 8;
          
          --chernandez 18/02/2020
          sp_cr_ObtieneGrupoLinea(i.AQPA032rubr,ln_Grupo);
        
          begin
            select AQPA030fact
              into ln_factor2 --0.000880             
              from AQPA030
             where AQPA030inst = ln_instancia
               and AQPA030grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuotPotencial := i.AQPA032aux8 * ln_factor2;
          lc_rubro         := substr(i.AQPA032rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            PQ_CR_ENDEUDAMIENTO_RCC_FIC.sp_cr_calculafactor(i.AQPA032rubr,
                                                            ln_instancia,
                                                            ln_factor1);
          
            ln_cuota := i.AQPA032util * ln_factor1;
          end if;
        
          ln_cuotacalc := ln_cuotPotencial + ln_cuota;
        
          if Round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;
        
          update AQPA032
             set AQPA032cptn  = ln_cuotPotencial,
                 AQPA032fac1  = ln_factor1,
                 AQPA032fac2  = ln_factor2,
                 AQPA032ccalc = ln_cuotacalc
           where AQPA032inst = i.AQPA032inst
             and AQPA032esta = i.AQPA032esta
             and AQPA032dori = i.AQPA032dori
             and AQPA032flin = i.AQPA032flin
             and AQPA032corr = i.AQPA032corr;
          commit;
        
        else
        
          PQ_CR_ENDEUDAMIENTO_RCC_FIC.sp_cr_calculafactor(i.AQPA032rubr,
                                                          ln_instancia,
                                                          ln_factor1);
        
          ln_cuota := i.AQPA032sdeu * ln_factor1;
        
          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update AQPA032
             set AQPA032fac3 = ln_factor1, AQPA032ccalc = ln_cuota
           where AQPA032inst = i.AQPA032inst
             and AQPA032esta = i.AQPA032esta
             and AQPA032dori = i.AQPA032dori
             and AQPA032flin = i.AQPA032flin
             and AQPA032corr = i.AQPA032corr;
          commit;
        
        end if;
      else
        if i.AQPA032dori = '2' then
        
          ln_Grupo := 13;
        
          begin
            select AQPA030fact
              into ln_factor2
              from AQPA030
             where AQPA030inst = ln_instancia
               and AQPA030grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuota := i.AQPA032sdeu * ln_factor2;
        
          if Round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update AQPA032
             set AQPA032fac3 = ln_factor2, AQPA032ccalc = ln_cuota
           where AQPA032inst = i.AQPA032inst
             and AQPA032esta = i.AQPA032esta
             and AQPA032dori = i.AQPA032dori
             and AQPA032flin = i.AQPA032flin
             and AQPA032corr = i.AQPA032corr;
          commit;
        
        else
          if i.AQPA032dori = '3' then
          
            if i.AQPA032flin = 'L' then
            
              ln_Grupo := 8;
            
              begin
                select AQPA030fact
                  into ln_factor2
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select AQPA030fact
                      into ln_factor2
                      from AQPA030
                     where AQPA030inst = ln_instancia
                       and AQPA030grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.AQPA032aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select AQPA030fact
                  into ln_factor1
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
            
              ln_cuota     := i.AQPA032util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;
            
              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update AQPA032
                 set AQPA032cptn  = ln_cuotPotencial,
                     AQPA032fac1  = ln_factor1,
                     AQPA032fac2  = ln_factor2,
                     AQPA032ccalc = ln_cuotacalc
               where AQPA032inst = i.AQPA032inst
                 and AQPA032esta = i.AQPA032esta
                 and AQPA032dori = i.AQPA032dori
                 and AQPA032flin = i.AQPA032flin
                 and AQPA032corr = i.AQPA032corr;
              commit;
            
            else
            
              ln_Grupo := 11;
            
              begin
                select AQPA030fact
                  into ln_factor1
                  from AQPA030
                 where AQPA030inst = ln_instancia
                   and AQPA030grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
              ln_cuotacalc := i.AQPA032sdeu * ln_factor1;
            
              if Round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update AQPA032
                 set AQPA032fac3 = ln_factor1, AQPA032ccalc = ln_cuotacalc
               where AQPA032inst = i.AQPA032inst
                 and AQPA032esta = i.AQPA032esta
                 and AQPA032dori = i.AQPA032dori
                 and AQPA032flin = i.AQPA032flin
                 and AQPA032corr = i.AQPA032corr;
              commit;
            
            end if;
          end if;
        end if;
      end if;
    end loop;
  
  end sp_cr_ActualizaCuotaConsumo;
  
  --chernandez 18/02/2020
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

  Procedure sp_cr_copiarData_FlujoExpress(pn_eval  numeric,
                                          pn_error out numeric) is
    ld_fecha       date;
    ln_instancia   numeric(10);
    ln_pasivoSol   numeric(17, 2);
    ln_pasivoDola  numeric(17, 2);
    ln_cuotaSol    numeric(17, 2);
    ln_cuotaDola   numeric(17, 2);
    ln_ingresoSol  numeric(17, 2);
    ln_ingresoDola numeric(17, 2);
    ln_egresoSol   numeric(17, 2);
    ln_egresoDola  numeric(17, 2);
    ln_activoSol   numeric(17, 2);
    ln_activoDola  numeric(17, 2);
    ln_excedenSol  numeric(17, 2);
    ln_excedenDola numeric(17, 2);
    ln_patriSol    numeric(17, 2);
    ln_patriDola   numeric(17, 2);
    ln_tipocambio  numeric(14, 8);
  begin
    select pgfape into ld_fecha from fst017 where pgcod = 1;
    pn_error := 0;
    pq_cr_modulo_campanias.sp_cr_tipocambio(ld_fecha, ln_tipocambio);
    begin
      --elimino excedente mensual 27, total pasivos 24, total patrimonio 25.
      delete from aqpa190b
       where AQPA190BEVAL = pn_eval
         and AQPA190BCOD in (24, 25, 27, 524, 525, 527);
    
      --obtengo ingreso en soles 21
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_ingresoSol
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 21;
    
      --obtengo ingreso en dolares 521
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_ingresoDola
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 521;
    
      --obtengo egreso en soles 22
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_egresoSol
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 22;
    
      --obtengo egreso en dolares 522
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_egresoDola
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 522;
    
      --obtengo activo en soles 23
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_activoSol
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 23;
    
      --obtengo activo en dolares 523
      select nvl(sum(a.aqpa190bmto), 0)
        into ln_activoDola
        from aqpa190b a
       where a.aqpa190beval = pn_eval
         and a.aqpa190bcod = 523;
    
      --obtengo pasivo en soles de aqpa036 panel saldo deudor
      select nvl(sum(a.aqpa036mto1), 0)
        into ln_pasivoSol
        from aqpa036 a
       where a.aqpa036eval = pn_eval
         and a.aqpa036cod = 36
         and a.aqpa036con3 = 'Soles     ';
    
      --obtengo pasivo en dolares de aqpa036 panel saldo deudor
      select nvl(sum(a.aqpa036mto1), 0)
        into ln_pasivoDola
        from aqpa036 a
       where a.aqpa036eval = pn_eval
         and a.aqpa036cod = 36
         and a.aqpa036con3 = 'Dólares   ';
    
      --obtengo cuotas en soles de aqpa036 panel saldo deudor
      select nvl(sum(a.aqpa036mto2), 0)
        into ln_cuotaSol
        from aqpa036 a
       where a.aqpa036eval = pn_eval
         and a.aqpa036cod = 36
         and a.aqpa036con3 = 'Soles     ';
    
      --obtengo cuotas en dolares de aqpa036 panel saldo deudor
      select nvl(sum(a.aqpa036mto2), 0)
        into ln_cuotaDola --está en soles
        from aqpa036 a
       where a.aqpa036eval = pn_eval
         and a.aqpa036cod = 36
         and a.aqpa036con3 = 'Dólares   ';
      --
      ln_cuotaDola  := ln_cuotaDola / ln_tipocambio;
      ln_pasivoDola := ln_pasivoDola / ln_tipocambio;
    
      ln_excedenSol  := ln_ingresoSol - ln_egresoSol - ln_cuotaSol;
      ln_excedenDola := ln_ingresoDola - ln_egresoDola - ln_cuotaDola;
    
      ln_patriSol  := ln_activoSol - ln_pasivoSol;
      ln_patriDola := ln_activoDola - ln_pasivoDola;
    
      --inserto excedente soles
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 27, ln_excedenSol);
    
      --inserto excedente en dolares
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 527, ln_excedenDola);
    
      --inserto pasivo soles
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 24, ln_pasivoSol);
    
      --inserto pasivo en dolares
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 524, ln_pasivoDola);
    
      --inserto patrimonio soles
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 25, ln_patriSol);
    
      --inserto patrimonio dolares
      insert into aqpa190b
        (aqpa190beval, aqpa190bcod, aqpa190bmto)
      values
        (pn_eval, 525, ln_patriDola);
    
    exception
      when others then
        pn_error := 1;
    end;
  
    select nvl(max(aqpa190dinst), 0) + 1
      into ln_instancia
      from AQPA190d
     where AQPA190dFech = ld_fecha;
  
    begin
      delete from aqpa190d where aqpa190dneva = pn_eval;
      insert into aqpa190d
        (aqpa190dcorr,
         aqpa190dfech,
         aqpa190dhora,
         aqpa190dinst,
         aqpa190dneva,
         aqpa190dpais,
         aqpa190dtdoc,
         aqpa190dndoc,
         aqpa190drubr,
         aqpa190desta,
         aqpa190denti,
         aqpa190dtcre,
         aqpa190dsdeu,
         aqpa190dplaz,
         aqpa190dtaza,
         aqpa190dccalc,
         aqpa190dgfin,
         aqpa190dfrcc,
         aqpa190ddori,
         aqpa190dchek,
         aqpa190dpers,
         aqpa190drela,
         aqpa190dline,
         aqpa190daux1,
         aqpa190daux2,
         aqpa190daux3,
         aqpa190daux4,
         aqpa190daux5,
         aqpa190daux6,
         aqpa190daux7,
         aqpa190daux8,
         aqpa190daux9,
         aqpa190dmda,
         aqpa190dtlin,
         aqpa190dutil,
         aqpa190dflin,
         aqpa190dflguso,
         aqpa190dcptn,
         aqpa190dfac1,
         aqpa190dfac2,
         aqpa190dfac3,
         aqpa190dcent)
        select (select nvl(max(AQPA190dCorr), 0) + 1
                  from AQPA190d
                 where AQPA190dFech = ld_fecha) + rownum,
               ld_fecha,
               to_char(sysdate, 'hh24:mi:ss'),
               ln_instancia,
               aqpa032neva,
               aqpa032pais,
               aqpa032tdoc,
               aqpa032ndoc,
               aqpa032rubr,
               aqpa032esta,
               aqpa032enti,
               aqpa032tcre,
               aqpa032sdeu,
               aqpa032plaz,
               aqpa032taza,
               aqpa032ccalc,
               aqpa032gfin,
               aqpa032frcc,
               aqpa032dori,
               aqpa032chek,
               aqpa032pers,
               aqpa032rela,
               aqpa032line,
               aqpa032aux1,
               aqpa032aux2,
               aqpa032aux3,
               aqpa032aux4,
               aqpa032aux5,
               aqpa032aux6,
               aqpa032aux7,
               aqpa032aux8,
               aqpa032aux9,
               aqpa032mda,
               aqpa032tlin,
               aqpa032util,
               aqpa032flin,
               'N',
               aqpa032cptn,
               aqpa032fac1,
               aqpa032fac2,
               aqpa032fac3,
               aqpa032cent
          from aqpa032
         where aqpa032neva = pn_eval
           and aqpa032esta = 'S';
    exception
      when others then
        pn_error := 1;
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
    end;
  
    begin
      delete from aqpa190c a
       where aqpa190ceval = pn_eval
         and a.aqpa190ccod = 36;
      insert into aqpa190c
        (aqpa190ceval,
         aqpa190ccod,
         aqpa190clin,
         aqpa190cmto1,
         aqpa190cmto2,
         aqpa190cmto3,
         aqpa190cmto4,
         aqpa190cmda1,
         aqpa190cmda2,
         aqpa190cmda3,
         aqpa190cmda4,
         aqpa190ctxt1,
         aqpa190ctxt2,
         aqpa190ctxt3,
         aqpa190ccon1,
         aqpa190ccon2,
         aqpa190ccon3,
         aqpa190ccan1,
         aqpa190ccan2,
         aqpa190ccan3,
         aqpa190ccan4,
         aqpa190ctxl1,
         aqpa190ctxl2,
         aqpa190ctxl3)
        select aqpa036eval,
               aqpa036cod,
               aqpa036lin,
               aqpa036mto1,
               aqpa036mto2,
               aqpa036mto3,
               aqpa036mto4,
               aqpa036mda1,
               aqpa036mda2,
               aqpa036mda3,
               aqpa036mda4,
               aqpa036txt1,
               aqpa036txt2,
               aqpa036txt3,
               aqpa036con1,
               aqpa036con2,
               aqpa036con3,
               aqpa036can1,
               aqpa036can2,
               aqpa036can3,
               aqpa036can4,
               aqpa036txl1,
               aqpa036txl2,
               aqpa036txl3
          from aqpa036
         where aqpa036eval = pn_eval;
    exception
      when others then
        pn_error := 1;
    end;
    if pn_error = 0 then
      commit;
    else
      rollback;
    end if;
  end sp_cr_copiarData_FlujoExpress;

  procedure sp_obtiene_instancia(pn_evaluacion numeric,
                                 pn_instancia  out numeric) is
  begin
    begin
      select AQPA038inst
        into pn_instancia
        from AQPA038
       where aqpa038eval = pn_evaluacion;
    exception
      when others then
        pn_instancia := SQ_CR_INSTANCIA_FICTICIA.NEXTVAL();
        insert into AQPA038
          (AQPA038inst, aqpa038eval, aqpa038ingr)
        values
          (pn_instancia, pn_evaluacion, 0);
    end;
  
  end sp_obtiene_instancia;

  procedure sp_verifica_rcc(pn_evaluacion numeric, pn_rpta out varchar2) is
    cursor busq is
      select *
        from AQPA038
       where aqpa038eval = pn_evaluacion
         and aqpa038ingr = 1;
  begin
    pn_rpta := 'N';
    for i in busq loop
      pn_rpta := 'S';
    end loop;
  
  end sp_verifica_rcc;

  procedure sp_actualiza_ingreso(pn_evaluacion numeric,
                                 pn_rpta       out varchar2) is
  begin
    pn_rpta := 'S';
    begin
      update AQPA038 set aqpa038ingr = 1 where aqpa038eval = pn_evaluacion;
      commit;
    exception
      when others then
        pn_rpta := 'N';
    end;
  end sp_actualiza_ingreso;

end PQ_CR_ENDEUDAMIENTO_RCC_FIC;
/

