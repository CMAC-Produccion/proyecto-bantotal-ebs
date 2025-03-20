create or replace package PQ_CR_CUOTAPOTEN is

  -- Author  : MCANDIA
  -- Created : 25/06/2019 03:20:00 p.m.
  -- Purpose : 

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ln_pgcod     in number,
                                  ln_itsuc     in number,
                                  ln_modulo    in number,
                                  ln_trans     in number,
                                  ln_rela      in number,
                                  ld_fcont     in date,
                                  lc_usuario   in character);

  Procedure sp_cr_TarjetasCredito_II(ln_instancia in number,
                                     ln_cuotpot   out number);

end PQ_CR_CUOTAPOTEN;
/

create or replace package body PQ_CR_CUOTAPOTEN is

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ln_pgcod     in number,
                                  ln_itsuc     in number,
                                  ln_modulo    in number,
                                  ln_trans     in number,
                                  ln_rela      in number,
                                  ld_fcont     in date,
                                  lc_Usuario   in character) is
  
    ln_cont     number(10);
    ld_FecRCC   date;
    ld_FecPro   date;
    lc_horaEjec character(8);
    ln_factor   number;
  
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
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]..02') then
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
                           when REGEXP_LIKE(c_cuenta, '^7215') and
                                not REGEXP_LIKE(c_cuenta, '^7215..02|^7215..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7215..02|^7215..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7225') and
                                not REGEXP_LIKE(c_cuenta, '^7225..02|^7225..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7225..02|^7225..13') then
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
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FecRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FecPro from FST017 Where Pgcod = 1;
    exception
      when others then
        ld_FecPro := trunc(sysdate);
    end;
  
    lc_horaEjec := TO_CHAR(SYSDATE, 'HH:MI:SS');
  
    begin
      delete aqpa416
       where aqpa416.aqpa416inst = ln_instancia
         and aqpa416.aqpa416pgcod = ln_pgcod
         and aqpa416.aqpa416itsuc = ln_itsuc
         and aqpa416.aqpa416itmod = ln_modulo
         and aqpa416.aqpa416ittra = ln_trans
         and aqpa416.aqpa416itnrel = ln_rela
         and aqpa416.aqpa416itfcon = ld_fcont;
      commit;
    end;
  
    begin
      select max(aqpa416.aqpa416corr)
        into ln_cont
        from aqpa416
       where aqpa416.aqpa416fpro = ld_FecPro;
    exception
      when others then
        ln_cont := 1;
    end;
  
    if ln_cont is null then
      ln_cont := 1;
    else
      ln_cont := ln_cont + 1;
    end if;
  
    begin
      insert into aqpa416
        (aqpa416corr,
         aqpa416fpro,
         aqpa416hora,
         aqpa416inst,
         aqpa416pgcod,
         aqpa416itsuc,
         aqpa416itmod,
         aqpa416ittra,
         aqpa416itnrel,
         aqpa416itfcon,
         aqpa416ituing)
      values
        (ln_cont,
         ld_FecPro,
         lc_horaEjec,
         ln_instancia,
         ln_pgcod,
         ln_itsuc,
         ln_modulo,
         ln_trans,
         ln_rela,
         ld_fcont,
         lc_Usuario);
      commit;
      ln_cont := ln_cont + 1;
    end;
  
    PQ_CR_CALC_METSOBREEND_LIN.SP_INICIO(ln_instancia,
                                         ln_pgcod,
                                         ln_itsuc,
                                         ln_modulo,
                                         ln_trans,
                                         ln_rela,
                                         ld_fcont,
                                         lc_Usuario);
  
    begin
      select aqpa419.aqpa419fact
        into ln_factor
        from aqpa419
       where aqpa419.aqpa419inst = ln_instancia
         and aqpa419.aqpa419grup = 8
         and aqpa419.aqpa419pgcod = ln_pgcod
         and aqpa419.aqpa419itsuc = ln_itsuc
         and aqpa419.aqpa419itmod = ln_modulo
         and aqpa419.aqpa419ittran = ln_trans
         and aqpa419.aqpa419itnrel = ln_rela
         and aqpa419.aqpa419itfcon = ld_fcont
         and aqpa419.aqpa419ituing = lc_Usuario;
    exception
      when others then
        ln_factor := 0.00;
    end;
  
    begin
      delete aqpa417
       where aqpa417.aqpa417inst = ln_instancia
         and aqpa417.aqpa417pgcod = ln_pgcod
         and aqpa417.aqpa417itsuc = ln_itsuc
         and aqpa417.aqpa417itmod = ln_modulo
         and aqpa417.aqpa417ittra = ln_trans
         and aqpa417.aqpa417itnrel = ln_rela
         and aqpa417.aqpa417itfcon = ld_fcont;
      commit;
    end;
  
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            begin
              select max(aqpa417.aqpa417corr)
                into ln_cont
                from aqpa417
               where aqpa417.aqpa417fpro = ld_FecPro;
            exception
              when others then
                ln_cont := 1;
            end;
          
            if ln_cont is null then
              ln_cont := 1;
            else
              ln_cont := ln_cont + 1;
            end if;
          
            insert into aqpa417
              (aqpa417corr,
               aqpa417inst,
               aqpa417fpro,
               aqpa417hora,
               aqpa417pgcod,
               aqpa417itsuc,
               aqpa417itmod,
               aqpa417ittra,
               aqpa417itnrel,
               aqpa417itfcon,
               aqpa417ituing,
               aqpa417csbs,
               aqpa417ndoc,
               aqpa417frcc,
               aqpa417rubro,
               aqpa417enti,
               aqpa417cent,
               aqpa417gast,
               aqpa417fact,
               aqpa417cptn,
               aqpa417moda,
               aqpa417tipo,
               aqpa417AUX1,
               aqpa417AUX4)
            values
              (ln_cont,
               ln_instancia,
               ld_FecPro,
               lc_horaEjec,
               ln_pgcod,
               ln_itsuc,
               ln_modulo,
               ln_trans,
               ln_rela,
               ld_fcont,
               lc_Usuario,
               b.lc_codsbs,
               a.lc_doc,
               ld_FecRCC,
               j.c_cuenta,
               j.desefi,
               j.codefi,
               j.gasto,
               ln_factor,
               ln_factor * j.gasto,
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
  
    begin
    
      UPDATE AQPA416
         SET AQPA416.AQPA416CPTN =
             (select SUM(AQPA417.AQPA417CPTN)
                from AQPA417
               WHERE AQPA417.AQPA417INST = ln_instancia
                 and AQPA417.AQPA417PGCOD = ln_pgcod
                 and AQPA417.AQPA417ITSUC = ln_itsuc
                 and AQPA417.AQPA417ITMOD = ln_modulo
                 and AQPA417.AQPA417ITTRA = ln_trans
                 and AQPA417.AQPA417ITNREL = ln_rela
                 and AQPA417.AQPA417ITFCON = ld_fcont)
       WHERE AQPA416.AQPA416INST = ln_instancia
         and AQPA416.AQPA416PGCOD = ln_pgcod
         and AQPA416.AQPA416ITSUC = ln_itsuc
         and AQPA416.AQPA416ITMOD = ln_modulo
         and AQPA416.AQPA416ITTRA = ln_trans
         and AQPA416.AQPA416ITNREL = ln_rela
         and AQPA416.AQPA416ITFCON = ld_fcont;
      commit;
    end;
  
  end sp_cr_TarjetasCredito;

  Procedure sp_cr_TarjetasCredito_II(ln_instancia in number,
                                     ln_cuotpot   out number) is
  
    ln_cont     number(10);
    ld_FecRCC   date;
    ld_FecPro   date;
    lc_horaEjec character(8);
    ln_factor   number;
  
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
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]..02') then
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
                           when REGEXP_LIKE(c_cuenta, '^7215') and
                                not REGEXP_LIKE(c_cuenta, '^7215..02|^7215..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7215..02|^7215..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7225') and
                                not REGEXP_LIKE(c_cuenta, '^7225..02|^7225..13') then
                            a.n_salcap
                         
                           when REGEXP_LIKE(c_cuenta, '^7225..02|^7225..13') then
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
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FecRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      select pgfape into ld_FecPro from FST017 Where Pgcod = 1;
    exception
      when others then
        ld_FecPro := trunc(sysdate);
    end;
  
    lc_horaEjec := TO_CHAR(SYSDATE, 'HH:MI:SS');
  
    begin
      delete aqpa420 where aqpa420.aqpa420inst = ln_instancia;
      commit;
    end;
  
    begin
      select max(aqpa420.aqpa420corr)
        into ln_cont
        from aqpa420
       where aqpa420.aqpa420fpro = ld_FecPro;
    exception
      when others then
        ln_cont := 1;
    end;
  
    if ln_cont is null then
      ln_cont := 1;
    else
      ln_cont := ln_cont + 1;
    end if;
  
    begin
      insert into aqpa420
        (aqpa420corr, aqpa420fpro, aqpa420hora, aqpa420inst)
      values
        (ln_cont, ld_FecPro, lc_horaEjec, ln_instancia);
      commit;
      ln_cont := ln_cont + 1;
    end;
  
    PQ_CR_CALC_METSOBREEND_LIN.SP_INICIO_II(ln_instancia);
  
    begin
      select aqpa422.aqpa422fact
        into ln_factor
        from aqpa422
       where aqpa422.aqpa422inst = ln_instancia
         and aqpa422.aqpa422grup = 8;
    exception
      when others then
        ln_factor := 0.00;
    end;
  
    begin
      delete aqpa421 where aqpa421.aqpa421inst = ln_instancia;
      commit;
    end;
  
    for a in documentos loop
      for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        for i in entidad(b.lc_codsbs) loop
          for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          
            begin
              select max(aqpa421.aqpa421corr)
                into ln_cont
                from aqpa421
               where aqpa421.aqpa421fpro = ld_FecPro;
            exception
              when others then
                ln_cont := 1;
            end;
          
            if ln_cont is null then
              ln_cont := 1;
            else
              ln_cont := ln_cont + 1;
            end if;
          
            insert into aqpa421
              (aqpa421corr,
               aqpa421inst,
               aqpa421fpro,
               aqpa421hora,
               aqpa421csbs,
               aqpa421ndoc,
               aqpa421frcc,
               aqpa421rubro,
               aqpa421enti,
               aqpa421cent,
               aqpa421gast,
               aqpa421fact,
               aqpa421cptn,
               aqpa421moda,
               aqpa421tipo,
               aqpa421AUX1,
               aqpa421AUX4)
            values
              (ln_cont,
               ln_instancia,
               ld_FecPro,
               lc_horaEjec,
               b.lc_codsbs,
               a.lc_doc,
               ld_FecRCC,
               j.c_cuenta,
               j.desefi,
               j.codefi,
               j.gasto,
               ln_factor,
               ln_factor * j.gasto,
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
  
    begin
    
      UPDATE aqpa420
         SET aqpa420.aqpa420CPTN =
             (select SUM(aqpa421.aqpa421CPTN)
                from aqpa421
               WHERE aqpa421.aqpa421INST = ln_instancia)
       WHERE aqpa420.aqpa420INST = ln_instancia;
    
      commit;
    end;
  
    begin
      select aqpa420.aqpa420cptn
        into ln_cuotpot
        from aqpa420
       where aqpa420.aqpa420inst = ln_instancia;
    exception
      when no_data_found then
        ln_cuotpot := 0.00;
      when others then
        ln_cuotpot := 0.00;
    end;
  
  end sp_cr_TarjetasCredito_II;

end PQ_CR_CUOTAPOTEN;
/

