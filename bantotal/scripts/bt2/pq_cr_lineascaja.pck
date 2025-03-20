create or replace package PQ_CR_LINEASCAJA is

  -- Author  : EFUENTES
  -- Created : 23/01/2022 12:20:38
  -- Purpose : 
  
  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2);

  Procedure sp_cr_Prestamo(ln_instancia in number,
                           ld_FecRCC    in date,
                           ld_FecPro    in date,
                           lc_Usuario   in varchar2);
  /*
  Procedure sp_cr_CalculaFactor(lc_rubro     in varchar2,
                                ln_instancia in number,
                                ln_factor    out number);

  Procedure sp_cr_ActualizaCuota(ln_instancia  in number,
                                 ln_evaluacion in number);

  Procedure sp_cr_ActualizaCuotaConsumo(ln_instancia  in number,
                                        ln_evaluacion in number);
                                        
  Procedure sp_cr_ObtieneGrupoLinea(lc_rubro     in varchar2,
                                ln_Grupo    out number);
  */
end PQ_CR_LINEASCAJA;
/

create or replace package body PQ_CR_LINEASCAJA is

  Procedure sp_cr_TarjetasCredito(ln_instancia in number,
                                  ld_FecRCC    in date,
                                  ld_FecPro    in date,
                                  lc_Usuario   in varchar2) is
  
    ln_cont number(10);
  
    cursor documentos is 
      select distinct (trim(f.pendoc)) lc_doc, f.petdoc ln_tdoc, ff.tp1nro2 ln_tdocid
      from fsr008 f, fst198 ff
      where f.ctnro in (select xwfcuenta from xwf700 where xwfprcins = ln_instancia and xwfcar3 = '1') and cttfir = 'T'
      and f.petdoc = ff.tp1nro1 and ff.Tp1cod = 1 and ff.Tp1cod1 = 11111 and ff.Tp1corr1 = 1 and ff.Tp1corr2 = 5;
      /*select distinct (trim(f.pendoc)) lc_doc, f.petdoc ln_tdoc, ff.tp1nro2 ln_tdocid
        from fsr008 f, fst198 ff
       where f.ctnro in (select s.sng001cta from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1 and ff.Tp1cod1 = 11111 and ff.Tp1corr1 = 1 and ff.Tp1corr2 = 5
      union
      select distinct (trim(g.rpndoc)) lc_doc, g.rptdoc ln_tdoc, ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.pepais and f.petdoc = g.petdoc and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and g.petdoc = ff.tp1nro1
         and ff.Tp1cod = 1 and ff.Tp1cod1 = 11111 and ff.Tp1corr1 = 1 and ff.Tp1corr2 = 5
      union
      select distinct (trim(g.pendoc)) lc_doc, g.petdoc ln_tdoc, ff.tp1nro2 ln_tdocid
        from fsr008 f, fsr002 g, fst198 ff
       where f.ctnro in (select s.sng001cta from sng001 s
                          where s.sng001inst = ln_instancia)
         and f.pepais = g.rppais and f.petdoc = g.rptdoc and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and g.rptdoc = ff.tp1nro1
         and ff.Tp1cod = 1 and ff.Tp1cod1 = 11111 and ff.Tp1corr1 = 1 and ff.Tp1corr2 = 5;
      */
  
    cursor cod_sbs(lc_doc in character, ln_tdocid in number) is
      select cldrcci.c_codsbs lc_CodSbs 
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC and cldrcci.c_tdocid = trim(ln_tdocid) and cldrcci.c_docide = lc_doc
      union
      select cldrcci.c_codsbs lc_CodSbs
        from cldrcci
       where cldrcci.d_fecpre = ld_FecRCC and cldrcci.C_TDOCTR = Trim(ln_tdocid) and cldrcci.C_DOCTRI = lc_doc;
  
    cursor entidad(lc_CodSbs in varchar2) is
      select distinct C_CODEMP lc_emp
        from CLDRCCS
       Where C_CODSBS = lc_CodSbs and C_CODEMP <> '00104' and D_FECPRE = ld_FecRCC;
  
    --cursor deu_cre(lc_emp in varchar2, lc_CodSbs in varchar2) is
    cursor deu_cre(n_instancia in number, c_estado in varchar2, d_fecha in date) is
      select x.Gasto,
             substr(x.c_cuenta, 3, 1) moneda,
             case when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then substr(x.c_cuenta, 5, 2)
                  when REGEXP_LIKE(x.c_cuenta, '^72.5')     then substr(x.c_cuenta, 7, 2)
             end tipo,
             x.c_cuenta, x.c_cretip tipcre,
             case when REGEXP_LIKE(x.c_cuenta, '^14') then substr(x.c_cuenta, 1, 2)
                  when REGEXP_LIKE(x.c_cuenta, '^72') then substr(x.c_cuenta, 1, 2)
             end cod_r
        from 
            (select sum(case when REGEXP_LIKE(j.jaqy142lrubro, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') then j.jaqy142lusado --VERIFICAR
                            when REGEXP_LIKE(j.jaqy142lrubro, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601') or
                                 --REGEXP_LIKE(j.jaqy142lrubro, '^14.[1-6]0306|^14.[1-6]0303') then j.jaqy142lusado
                                 REGEXP_LIKE(j.jaqy142lrubro, '^14.[1-6]0303') then j.jaqy142lusado
                            when REGEXP_LIKE(j.jaqy142lrubro, '^72.506') then j.Jaqy142ldispb
                            when REGEXP_LIKE(j.jaqy142lrubro, '^72.503') and not 
                                 REGEXP_LIKE(j.jaqy142lrubro, '^72.5030202|^72.5030302') then j.Jaqy142ldispb
                            else 0
                       end) Gasto,
                   j.jaqy142lrubro C_CUENTA, sum(j.jaqy142lmntcr) capital, j.jaqy142ltope C_CRETIP --VERIFICAR c_CodEmp y c_cretip y a.n_salcap
            from jaqy142l j
            where j.jaqy142linst = n_instancia--7784322
              and j.jaqy142lest = c_estado--'H' --c_codsbs = lc_CodSbs 
              and j.jaqy142lfech = d_fecha--'18/11/2021'--ld_FecRCC VERIFICAR
            group by j.jaqy142lrubro, j.jaqy142ltope) x
      where x.gasto <> 0;
      /*
      select x.Gasto,
             (select y.c_desefi from ahtbanc y
               where y.c_codefi = x.c_codemp and rownum = 1) desefi,
             (select y.c_codefi from ahtbanc y
               where y.c_codefi = x.c_codemp and rownum = 1) codefi,
             substr(x.c_cuenta, 3, 1) moneda,
             case
               when REGEXP_LIKE(x.c_cuenta, '^14.[1-6]') then substr(x.c_cuenta, 5, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72.5')     then substr(x.c_cuenta, 7, 2)
             end tipo,
             x.c_cuenta, x.c_cretip tipcre,
             case
               when REGEXP_LIKE(x.c_cuenta, '^14') then substr(x.c_cuenta, 1, 2)
               when REGEXP_LIKE(x.c_cuenta, '^72') then substr(x.c_cuenta, 1, 2)
             end cod_r
        from (select sum(case
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]0302|^14.[1-6]0202|^14.[1-6]1202|^14.[1-6]1302') then a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^14.[1-6]020601|^14.[1-6]130601|^14.[1-6]120601')         then a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^72.506') then a.n_salcap
                           when REGEXP_LIKE(c_cuenta, '^72.503') and not 
                                REGEXP_LIKE(c_cuenta, '^72.5030202|^72.5030302') then a.n_salcap
                           else 0
                         end) Gasto,
                     c_CodEmp, c_cuenta, SUM(a.n_salcap) capital, a.c_cretip
                from cldrccs a
               where c_codsbs = lc_CodSbs and d_fecpre = ld_FecRCC
                 and C_CODEMP <> '00104'  and C_CODEMP = lc_emp
               group by c_CodEmp, c_cuenta, c_cretip) x
       where x.gasto <> 0;
       */
  
    cursor deuda (n_corrI in NUMBER, n_corr number) is
      select aqpa412inst, aqpa412moda, aqpa412tipo, aqpa412user, aqpa412csbs, aqpa412frcc, 
             aqpa412fpro, aqpa412enti, aqpa412cent, aqpa412ndoc, p.tipocredito,
             nvl((select jj.aqpa412rubro
                   from aqpa412 jj
                  where jj.aqpa412inst = p.aqpa412inst and jj.aqpa412moda = p.aqpa412moda
                    and jj.aqpa412tipo = p.aqpa412tipo and jj.aqpa412cent = p.aqpa412cent
                    and jj.aqpa412ndoc = p.aqpa412ndoc and jj.aqpa412user = p.aqpa412user
                    and trim(substr(jj.aqpa412rubro, 1, 2)) = '14'
                    and rownum = 1),
                 (select jj.aqpa412rubro
                    from aqpa412 jj
                   where jj.aqpa412inst = p.aqpa412inst and jj.aqpa412moda = p.aqpa412moda
                     and jj.aqpa412tipo = p.aqpa412tipo and jj.aqpa412cent = p.aqpa412cent
                     and jj.aqpa412ndoc = p.aqpa412ndoc and jj.aqpa412user = p.aqpa412user
                     and substr(jj.aqpa412rubro, 1, 2) = '72'
                     and rownum = 1)
                 ) rubro,
             (select jj.aqpa412rubro
                from aqpa412 jj
               where jj.aqpa412inst = p.aqpa412inst and jj.aqpa412moda = p.aqpa412moda
                 and jj.aqpa412tipo = p.aqpa412tipo and jj.aqpa412cent = p.aqpa412cent
                 and jj.aqpa412ndoc = p.aqpa412ndoc and jj.aqpa412user = p.aqpa412user
                 and substr(jj.aqpa412rubro, 1, 2) = '72'
                 and rownum = 1) rubro_72,
             uso, nouso
        from (select aqpa412inst, aqpa412moda, aqpa412tipo, aqpa412user, aqpa412csbs,
                     aqpa412frcc, aqpa412fpro, aqpa412enti, aqpa412cent, aqpa412ndoc,
                     MAX(AQPA412AUX1) tipocredito, sum(uso) uso, sum(nouso) nouso
                from (select j.aqpa412inst, j.aqpa412moda, j.aqpa412tipo, j.aqpa412user, j.aqpa412csbs, j.aqpa412frcc, 
                             j.aqpa412fpro, j.aqpa412enti, j.aqpa412cent, j.aqpa412ndoc, j.AQPA412AUX1,
                             case
                               when substr(aqpa412rubro, 1, 2) = '14' then aqpa412gast
                             end uso,
                             case
                               when substr(aqpa412rubro, 1, 2) = '72' then aqpa412gast
                             end nouso
                        from aqpa412 j
                       where j.aqpa412user = lc_Usuario
                         and j.aqpa412inst = ln_instancia
                         and j.aqpa412corr between n_corrI and n_corr )
               group by aqpa412inst, aqpa412moda, aqpa412tipo, aqpa412user, aqpa412csbs,
                        aqpa412frcc, aqpa412fpro, aqpa412enti, aqpa412cent, aqpa412ndoc) p;
  
    ln_estado varchar2(1);
    lc_codefi VARCHAR2(5);
    lc_desefi VARCHAR2(200);
    ln_corr   NUMBER(10);
    ln_corrI  NUMBER(10);
    
    ln_corr3   NUMBER(10);
    
    lv_RubroT  VARCHAR2(20);
    ln_CodRub  NUMBER(5);
    lv_TipCre  VARCHAR2(2);
  begin
    /*begin
      delete from aqpa412 a where a.aqpa412inst = ln_instancia;
      delete from aqpa413 a where a.aqpa413inst = ln_instancia;
    end;*/
    ln_cont := 1;
    ln_estado := 'H';
    lc_codefi := '00104';
    lC_desefi := 'CAJA MUNICIPAL DE AHORRO Y CREDITO DE AREQUIPA';
    
    select nvl(max(q.aqpa412corr),0) + 1
    into ln_corr
    from aqpa412 q
    where q.aqpa412inst = ln_instancia;
    
    ln_corrI := ln_corr;
    
    for a in documentos loop
      --a.lc_doc
      --a.ln_tdoc
      --a.ln_tdocid
      --for b in cod_sbs(a.lc_doc, a.ln_tdocid) loop
        --b.lc_CodSbs 
        --for i in entidad(b.lc_codsbs) loop
          --i.lc_emp
          --for j in deu_cre(i.lc_emp, b.lc_codsbs) loop
          for j in deu_cre(ln_instancia, ln_estado, ld_FecPro) loop
          --for j in deu_cre(ln_instancia, ln_estado, TO_DATE('18/11/2021','DD/MM/YYYY')) loop
            --j.Gasto j.desefi j.codefi j.moneda j.tipo j.c_cuenta j.tipcre j.cod_r
            insert into aqpa412
              (aqpa412corr, aqpa412inst, aqpa412user,  aqpa412csbs, aqpa412ndoc,
               aqpa412frcc, aqpa412fpro, aqpa412rubro, aqpa412enti, aqpa412cent,
               aqpa412gast, aqpa412moda, aqpa412tipo,  AQPA412AUX1, AQPA412AUX4)
            values
              (ln_corr,   ln_instancia, lc_Usuario, NULL, a.lc_doc,
               ld_FecRCC, ld_FecPro,    j.c_cuenta, lC_desefi,   lc_codefi,
               j.gasto,   j.moneda,     j.tipo,     j.tipcre,    j.cod_r);
            ln_corr := ln_corr + 1;
            commit;
          end loop;
        --end loop;
      --end loop;
    end loop;
  
    select nvl(max(r.aqpa413corr),0) + 1
    into ln_corr3
    from aqpa413 r
    where r.aqpa413inst = ln_instancia;

    for k in deuda (ln_corrI, ln_corr) loop
      lv_RubroT := k.rubro;
      ln_CodRub := SUBSTR(lv_RubroT, 5, 2);
      /* ** TIPO DE CREDITO **
      01: CREDITOS SOBERANOS
      02: CREDITOS A ENTIDADES DEL SECTOR PUBLICO
      03: CREDITOS A BANCOS MULTILATERALES DE DESARROLLO
      04: CREDITOS A EMPRESAS DEL SISTEMA
      05: CREDITOS A EMPRESAS DE VALORES
      06: CREDITOS CORPORATIVOS
      07: CREDITOS A GRANDES EMPRESAS
      08: CREDITOS A MEDIANAS EMPRESAS
      09: CREDITOS A PEQUEÑAS EMPRESAS
      10: CREDITOS A MICROEMPRESAS
      11: CREDITOS DE CONSUMO REVOLVENTES
      12: CREDITOS DE CONSUMO NO REVOLVENTES
      13: CREDITOS HIPOTECARIOS PARA VIVIENDA*/
      lv_TipCre := case 
                    when ln_CodRub = 2  then '10' --'MICROEMPRESAS'
                    when ln_CodRub = 3  and  substr(lv_RubroT, 11, 3) = '015'  then '11' --'CONSUMO REVOLVENTE'
                    when ln_CodRub = 3  and  substr(lv_RubroT, 11, 3) <> '015' then '12' --'CONSUMO NO REVOLVENTE'
                    when ln_CodRub = 4  then '13' --'HIPOTECARIO' 
                    when ln_CodRub = 12 then '08' --'MEDIANAS EMPRESA'
                    when ln_CodRub = 13 then '09' --'PEQUEÑAS EMPRESA'
                    else '99'
                   end;      
      
      insert into aqpa413
        (aqpa413corr, aqpa413inst, aqpa413moda, aqpa413tipo,  aqpa413user,
         aqpa413csbs, aqpa413frcc, aqpa413fpro, aqpa413rubro, aqpa413rub72,
         aqpa413enti, aqpa413cent, aqpa413util, aqpa413nout,  aqpa413tipc,
         aqpa413ndoc)
      values
        (ln_corr3, k.aqpa412inst, k.aqpa412moda, k.aqpa412tipo, k.aqpa412user,
         k.aqpa412csbs, k.aqpa412frcc, k.aqpa412fpro, k.rubro, k.rubro_72,
         k.aqpa412enti, k.aqpa412cent, k.uso, k.nouso, lv_TipCre, --'11',
         k.aqpa412ndoc);
      commit;
      ln_corr3 := ln_corr3 + 1;
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
      delete from aqpa414 a where a.aqpa414inst = ln_instancia;
    end;
  
    ln_cont := 1;
    for a in documentos loop
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
  /*
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
          sp_cr_ObtieneGrupoLinea(i.jaqy327rubr,ln_Grupo);
        
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
          sp_cr_ObtieneGrupoLinea(i.jaqz862rubr,ln_Grupo);
        
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
  */
end PQ_CR_LINEASCAJA;
/

