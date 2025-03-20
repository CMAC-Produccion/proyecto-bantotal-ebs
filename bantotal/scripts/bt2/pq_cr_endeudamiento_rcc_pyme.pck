create or replace package PQ_CR_ENDEUDAMIENTO_RCC_PYME is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_ENDEUDAMIENTO_RCC_PYME
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 
  -- Uso                        : Paquete proveniente PQ_CR_ENDEUDAMIENTO_RCC
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 07.02.2021
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Se hizo el cambio de aqpb081 por AQPB081
  -- Fecha de Modificaci�n      : 15/03/2024
  -- Autor de la Modificaci�n   :  Maria Postigo
  -- Descripci�n de Modificaci�n: Se agrego el procedimiento sp_cr_actualizCuotPoten 
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
  /*
  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number);
  */
  --chernandez 17/02/2020 1
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro in varchar2,
                                    ln_Grupo out number);
  -------------------------------------------------------------------------------------
  procedure sp_Cr_TotalCuoPotRep(ln_instancia in number,
                                 ln_CPPymeSol out number,
                                 ln_CPConsSol out number,
                                 ln_CPHiptSol out number,
                                 ln_CPPymeDol out number,
                                 ln_CPConsDol out number,
                                 ln_CPHiptDol out number);
  -------------------------------------------------------------------------------------                                 
  procedure sp_cr_actualizCuotPoten(ln_instancia in number,
                                    ln_nevaluaci in number);

end PQ_CR_ENDEUDAMIENTO_RCC_PYME;
/

create or replace package body PQ_CR_ENDEUDAMIENTO_RCC_PYME is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_ENDEUDAMIENTO_RCC_PYME
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 
  -- Uso                        : Paquete proveniente PQ_CR_ENDEUDAMIENTO_RCC
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 07.02.2021
  -- Autor de la Modificaci�n   : JRODRIGUEJ
  -- Descripci�n de Modificaci�n: Se hizo el cambio de aqpb081 por AQPB081
  -- *****************************************************************

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
        from (select sum(case
                         --chernandez 17/02/2020 2
                           when REGEXP_LIKE(c_cuenta,
                                            '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') then
                            a.n_salcap
                         --chernandez 09/03/2020
                           when REGEXP_LIKE(c_cuenta,
                                            '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601') then
                            a.n_salcap
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
    
      select AQPB085Ainst,
             AQPB085Amoda,
             AQPB085Atipo,
             AQPB085Auser,
             AQPB085Acsbs,
             AQPB085Afrcc,
             AQPB085Afpro,
             AQPB085Aenti,
             AQPB085Acent,
             AQPB085Andoc,
             p.tipocredito,
             nvl((select jj.AQPB085Arubro
                   from AQPB085A jj
                  where jj.AQPB085Ainst = p.AQPB085Ainst
                    and jj.AQPB085Amoda = p.AQPB085Amoda
                    and jj.AQPB085Atipo = p.AQPB085Atipo
                    and jj.AQPB085Acent = p.AQPB085Acent
                    and jj.AQPB085Andoc = p.AQPB085Andoc
                    and jj.AQPB085Auser = p.AQPB085Auser
                    and trim(substr(jj.AQPB085Arubro, 1, 2)) = '14'
                    and rownum = 1),
                 (select jj.AQPB085Arubro
                    from AQPB085A jj
                   where jj.AQPB085Ainst = p.AQPB085Ainst
                     and jj.AQPB085Amoda = p.AQPB085Amoda
                     and jj.AQPB085Atipo = p.AQPB085Atipo
                     and jj.AQPB085Acent = p.AQPB085Acent
                     and jj.AQPB085Andoc = p.AQPB085Andoc
                     and jj.AQPB085Auser = p.AQPB085Auser
                     and substr(jj.AQPB085Arubro, 1, 2) = '72'
                     and rownum = 1)) rubro,
             (select jj.AQPB085Arubro
                from AQPB085A jj
               where jj.AQPB085Ainst = p.AQPB085Ainst
                 and jj.AQPB085Amoda = p.AQPB085Amoda
                 and jj.AQPB085Atipo = p.AQPB085Atipo
                 and jj.AQPB085Acent = p.AQPB085Acent
                 and jj.AQPB085Andoc = p.AQPB085Andoc
                 and jj.AQPB085Auser = p.AQPB085Auser
                 and substr(jj.AQPB085Arubro, 1, 2) = '72'
                 and rownum = 1) rubro_72,
             uso,
             nouso
        from (select AQPB085Ainst,
                     AQPB085Amoda,
                     AQPB085Atipo,
                     AQPB085Auser,
                     AQPB085Acsbs,
                     AQPB085Afrcc,
                     AQPB085Afpro,
                     AQPB085Aenti,
                     AQPB085Acent,
                     AQPB085Andoc,
                     MAX(AQPB085AAUX1) tipocredito,
                     sum(uso) uso,
                     sum(nouso) nouso
                from (select j.AQPB085Ainst,
                             j.AQPB085Amoda,
                             j.AQPB085Atipo,
                             j.AQPB085Auser,
                             j.AQPB085Acsbs,
                             j.AQPB085Afrcc,
                             j.AQPB085Afpro,
                             j.AQPB085Aenti,
                             j.AQPB085Acent,
                             j.AQPB085Andoc,
                             j.AQPB085AAUX1,
                             case
                               when substr(AQPB085Arubro, 1, 2) = '14' then
                                AQPB085Agast
                             end uso,
                             case
                               when substr(AQPB085Arubro, 1, 2) = '72' then
                                AQPB085Agast
                             end nouso
                        from AQPB085A j
                       where j.AQPB085Auser = lc_Usuario
                         and j.AQPB085Ainst = ln_instancia)
               group by AQPB085Ainst,
                        AQPB085Amoda,
                        AQPB085Atipo,
                        AQPB085Auser,
                        AQPB085Acsbs,
                        AQPB085Afrcc,
                        AQPB085Afpro,
                        AQPB085Aenti,
                        AQPB085Acent,
                        AQPB085Andoc) p;
  
  begin
    begin
      delete from AQPB085A a where a.AQPB085Ainst = ln_instancia;
      -- and a.AQPB085Auser = lc_Usuario;
      delete from AQPB085B a where a.AQPB085Binst = ln_instancia;
      --  and a.AQPB085Buser = lc_Usuario;
    end;
    ln_cont := 1;
  
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into AQPB085A
              (AQPB085Acorr,
               AQPB085Ainst,
               AQPB085Auser,
               AQPB085Acsbs,
               AQPB085Andoc,
               AQPB085Afrcc,
               AQPB085Afpro,
               AQPB085Arubro,
               AQPB085Aenti,
               AQPB085Acent,
               AQPB085Agast,
               AQPB085Amoda,
               AQPB085Atipo,
               AQPB085AAUX1,
               AQPB085AAUX4)
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
    
      insert into AQPB085B
        (AQPB085Bcorr,
         AQPB085Binst,
         AQPB085Bmoda,
         AQPB085Btipo,
         AQPB085Buser,
         AQPB085Bcsbs,
         AQPB085Bfrcc,
         AQPB085Bfpro,
         AQPB085Brubro,
         AQPB085Brub72,
         AQPB085Benti,
         AQPB085Bcent,
         AQPB085Butil,
         AQPB085Bnout,
         AQPB085Btipc,
         AQPB085Bndoc)
      values
        (ln_cont,
         k.AQPB085Ainst,
         k.AQPB085Amoda,
         k.AQPB085Atipo,
         k.AQPB085Auser,
         k.AQPB085Acsbs,
         k.AQPB085Afrcc,
         k.AQPB085Afpro,
         k.rubro,
         k.rubro_72,
         k.AQPB085Aenti,
         k.AQPB085Acent,
         k.uso,
         k.nouso,
         k.tipocredito,
         k.AQPB085Andoc);
      commit;
      ln_cont := ln_cont + 1;
    end loop;
  
  end sp_cr_TarjetasCredito;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
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
      delete from AQPB085C a where a.AQPB085Cinst = ln_instancia;
    end;
  
    ln_cont := 1;
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            insert into AQPB085C
              (AQPB085Ccorr,
               AQPB085Cinst,
               AQPB085Cmoda,
               AQPB085Ctipo,
               AQPB085Cuser,
               AQPB085Ccsbs,
               AQPB085Cfrcc,
               AQPB085Cfpro,
               AQPB085Crubro,
               AQPB085Centi,
               AQPB085Ccent,
               AQPB085Ctipc,
               AQPB085Cndoc,
               AQPB085CSDEU)
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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
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
      select a.AQPB084fact
        into ln_factor
        from AQPB084 a
       Where a.AQPB084inst = ln_instancia
         and a.AQPB084grup = ln_Grupo;
    exception
      when no_data_found then
        ln_factor := 0.00;
    end;
  
  end sp_cr_CalculaFactor;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
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
  
    cursor aqpb081 is
      select *
        from aqpb081
       where aqpb081inst = ln_instancia
         and aqpb081esta = 'S'
         and aqpb081chek = '1';
  
  begin
  
    pQ_CR_CALC_METSOBREEND_PYME.SP_INICIO(ln_instancia, ln_evaluacion);
  
    for i in aqpb081 loop
    
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
    
      if i.aqpb081dori = '1' then
      
        if i.aqpb081flin = 'L' then
        
          --ln_Grupo := 8;
        
          --chernandez 17/02/2020 1
          PQ_CR_ENDEUDAMIENTO_RCC_PYME.sp_cr_ObtieneGrupoLinea(i.aqpb081rubr,
                                                               ln_Grupo);
        
          begin
            select AQPB084fact
              into ln_factor2 --0.000880             
              from AQPB084
             where AQPB084inst = ln_instancia
               and AQPB084grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuotPotencial := i.aqpb081aux8 * ln_factor2;
          lc_rubro         := substr(i.aqpb081rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            pq_cr_endeudamiento_rcc_pyme.sp_cr_calculafactor(i.aqpb081rubr,
                                                             ln_instancia,
                                                             ln_factor1);
          
            ln_cuota := i.aqpb081util * ln_factor1;
          
          end if;
        
          ln_cuotacalc := ln_cuotPotencial + ln_cuota;
        
          if round(ln_cuotacalc, 2) = 0.00 then
            ln_cuotacalc := ln_cuotRedon;
          end if;
        
          update aqpb081
             set aqpb081cptn  = ln_cuotPotencial,
                 aqpb081fac1  = ln_factor1,
                 aqpb081fac2  = ln_factor2,
                 aqpb081ccalc = ln_cuotacalc
           where aqpb081inst = i.aqpb081inst
             and aqpb081esta = i.aqpb081esta
             and aqpb081dori = i.aqpb081dori
             and aqpb081flin = i.aqpb081flin
             and aqpb081corr = i.aqpb081corr;
          commit;
        
        else
        
          pq_cr_endeudamiento_rcc_pyme.sp_cr_calculafactor(i.aqpb081rubr,
                                                           ln_instancia,
                                                           ln_factor1);
        
          ln_cuota := i.aqpb081sdeu * ln_factor1;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update aqpb081
             set aqpb081fac3 = ln_factor1, aqpb081ccalc = ln_cuota
           where aqpb081inst = i.aqpb081inst
             and aqpb081esta = i.aqpb081esta
             and aqpb081dori = i.aqpb081dori
             and aqpb081flin = i.aqpb081flin
             and aqpb081corr = i.aqpb081corr;
          commit;
        
        end if;
      else
        if i.aqpb081dori = '2' then
        
          ln_Grupo := 13;
        
          begin
            select AQPB084fact
              into ln_factor2
              from AQPB084
             where AQPB084inst = ln_instancia
               and AQPB084grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuota := i.aqpb081sdeu * ln_factor2;
        
          if round(ln_cuota, 2) = 0.00 then
            ln_cuota := ln_cuotRedon;
          end if;
        
          update aqpb081
             set aqpb081fac3 = ln_factor2, aqpb081ccalc = ln_cuota
           where aqpb081inst = i.aqpb081inst
             and aqpb081esta = i.aqpb081esta
             and aqpb081dori = i.aqpb081dori
             and aqpb081flin = i.aqpb081flin
             and aqpb081corr = i.aqpb081corr;
          commit;
        
        else
          if i.aqpb081dori = '3' then
          
            if i.aqpb081flin = 'L' then
            
              ln_Grupo := 8;
            
              begin
                select AQPB084fact
                  into ln_factor2
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select AQPB084fact
                      into ln_factor2
                      from AQPB084
                     where AQPB084inst = ln_instancia
                       and AQPB084grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.aqpb081aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select AQPB084fact
                  into ln_factor1
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
            
              ln_cuota     := i.aqpb081util * ln_factor1;
              ln_cuotacalc := ln_cuotPotencial + ln_cuota;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update aqpb081
                 set aqpb081cptn  = ln_cuotPotencial,
                     aqpb081fac1  = ln_factor1,
                     aqpb081fac2  = ln_factor2,
                     aqpb081ccalc = ln_cuotacalc
               where aqpb081inst = i.aqpb081inst
                 and aqpb081esta = i.aqpb081esta
                 and aqpb081dori = i.aqpb081dori
                 and aqpb081flin = i.aqpb081flin
                 and aqpb081corr = i.aqpb081corr;
              commit;
            
            else
            
              ln_Grupo := 11;
            
              begin
                select AQPB084fact
                  into ln_factor1
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
              exception
                when no_data_found then
                  ln_factor1 := 0.00;
                
              end;
              ln_cuotacalc := i.aqpb081sdeu * ln_factor1;
            
              if round(ln_cuotacalc, 2) = 0.00 then
                ln_cuotacalc := ln_cuotRedon;
              end if;
            
              update aqpb081
                 set aqpb081fac3 = ln_factor1, aqpb081ccalc = ln_cuotacalc
               where aqpb081inst = i.aqpb081inst
                 and aqpb081esta = i.aqpb081esta
                 and aqpb081dori = i.aqpb081dori
                 and aqpb081flin = i.aqpb081flin
                 and aqpb081corr = i.aqpb081corr;
              commit;
            
            end if;
          end if;
        end if;
      end if;
    end loop;
  
  end sp_cr_ActualizaCuota;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  /*
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
  
    pQ_CR_CALC_METSOBREEND_PYME.SP_INICIO(ln_instancia, ln_evaluacion);
  
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
          sp_cr_ObtieneGrupoLinea(i.jaqz862rubr,ln_Grupo);
        
          begin
            select AQPB084fact
              into ln_factor2 --0.000880             
              from AQPB084
             where AQPB084inst = ln_instancia
               and AQPB084grup = ln_Grupo;
          exception
            when no_data_found then
              ln_factor2 := 0.00;
          end;
        
          ln_cuotPotencial := i.jaqz862aux8 * ln_factor2;
          lc_rubro         := substr(i.jaqz862rubr, 1, 2);
        
          if lc_rubro = '14' then
          
            pq_cr_endeudamiento_rcc_pyme.sp_cr_calculafactor(i.jaqz862rubr,
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
        
          pq_cr_endeudamiento_rcc_pyme.sp_cr_calculafactor(i.jaqz862rubr,
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
            select AQPB084fact
              into ln_factor2
              from AQPB084
             where AQPB084inst = ln_instancia
               and AQPB084grup = ln_Grupo;
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
                select AQPB084fact
                  into ln_factor2
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
              exception
                when no_data_found then
                  begin
                    ln_Grupo := 14;
                    select AQPB084fact
                      into ln_factor2
                      from AQPB084
                     where AQPB084inst = ln_instancia
                       and AQPB084grup = ln_Grupo;
                  exception
                    when no_data_found then
                      ln_factor2 := 0.00;
                  end;
              end;
            
              ln_cuotPotencial := i.jaqz862aux8 * ln_factor2;
            
              ln_Grupo := 12;
            
              begin
                select AQPB084fact
                  into ln_factor1
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
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
                select AQPB084fact
                  into ln_factor1
                  from AQPB084
                 where AQPB084inst = ln_instancia
                   and AQPB084grup = ln_Grupo;
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
  */
  --chernandez 17/02/2020 1
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro in varchar2,
                                    ln_Grupo out number) is
  
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
                  when substr(lc_rubro, 7, 4) in ('0202', '0302') then --chernandez 17/02/2020
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
  ----------------------------------------------------------------------
  procedure sp_Cr_TotalCuoPotRep(ln_instancia in number,
                                 ln_CPPymeSol out number,
                                 ln_CPConsSol out number,
                                 ln_CPHiptSol out number,
                                 ln_CPPymeDol out number,
                                 ln_CPConsDol out number,
                                 ln_CPHiptDol out number) is
  
  begin
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPPymeSol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Pymes S/.'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPPymeSol := 0;
    end;
  
    ln_CPPymeSol := nvl(ln_CPPymeSol, 0);
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPConsSol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Consumo S/.'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPConsSol := 0;
    end;
    ln_CPConsSol := nvl(ln_CPConsSol, 0);
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPHiptSol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Hipotecario S/.'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPHiptSol := 0;
    end;
    ln_CPHiptSol := nvl(ln_CPHiptSol, 0);
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPPymeDol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Pymes US$'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPPymeDol := 0;
    end;
  
    ln_CPPymeDol := nvl(ln_CPPymeDol, 0);
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPConsDol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Consumo US$'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPConsDol := 0;
    end;
    ln_CPConsDol := nvl(ln_CPConsDol, 0);
  
    begin
      select sum(j.AQPB081cptn)
        into ln_CPHiptDol
        from AQPB081 j
       where j.AQPB081inst = ln_instancia
         and j.AQPB081esta = 'S'
         and j.AQPB081tcre = 'Hipotecario US$'
         and j.AQPB081chek = '1';
    exception
      when others then
        ln_CPHiptDol := 0;
    end;
  
    ln_CPHiptDol := nvl(ln_CPHiptDol, 0);
  
  end sp_Cr_TotalCuoPotRep;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

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
    CodFam_Soles   := 54; --> Gastos familiares Consumo / Hipotecario
    CodFam_Dolares := 554; --> Gastos familiares Consumo / Hipotecario
  
    /*ln_instancia := 20578793;
    x_nevaluaci := 7256182;
    X_instancia := 20578793;*/
    x_nevaluaci := ln_nevaluaci;
  
    BEGIN
      PQ_CR_ENDEUDAMIENTO_RCC_PYME.sp_Cr_TotalCuoPotRep(ln_instancia,
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
    --ln_cppymesol := 111;
    begin
      Update jaqz517 --sng023
         set jaqz517Mto = jaqz517Mto + ln_cppymesol
       where jaqz517Eval = x_nevaluaci
         AND jaqz517Cod = CodFin_Soles;
      COMMIT;
    exception
      when others then
        NULL;
    end;
  
    begin
      Update jaqz517
         set jaqz517Mto = jaqz517Mto + ln_cppymedol
       where jaqz517Eval = x_nevaluaci
         AND jaqz517Cod = CodFin_Dolares;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      Update jaqz517
         set jaqz517Mto = jaqz517Mto + ln_cpconssol + ln_cphiptsol
       where jaqz517Eval = x_nevaluaci
         AND jaqz517Cod = CodFam_Soles;
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      Update jaqz517
         set jaqz517Mto = jaqz517Mto + ln_cpconsdol + ln_cphiptdol
       where jaqz517Eval = x_nevaluaci
         AND jaqz517Cod = CodFam_Dolares;
      commit;
    exception
      when others then
        null;
    end;
  
  end;

end PQ_CR_ENDEUDAMIENTO_RCC_PYME;
/

