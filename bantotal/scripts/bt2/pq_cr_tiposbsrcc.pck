create or replace package pq_cr_TipoSbsRCC is

  Procedure Sp_cr_proceso(pn_ins    in number,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pc_nom    in char,
                          pd_fecpro in date,
                          pc_hora   in char,
                          pc_usr    in char,
                          pc_flg    out varchar2);
  Procedure Sp_porcentaje_amort(pn_pai    in number,
                                pn_tdo    in number,
                                pc_ndo    in char,
                                pn_ins    in number,
                                pd_fecpro in date,
                                pn_porc   out number);
  Procedure SP_Lineas(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_ope    in number,
                      pn_sbo    in number,
                      pn_top    in number,
                      pn_tca    in number,
                      pn_mtoDes out number,
                      pn_mtoPag out number);
  Procedure SP_Lineas_ant(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_tca    in number,
                          pd_Fecpro in date,
                          pn_mtoDes out number,
                          pn_mtoPag out number);

end pq_cr_TipoSbsRCC;
/

create or replace package body pq_cr_TipoSbsRCC is

  Procedure Sp_cr_proceso(pn_ins    in number,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pc_nom    in char,
                          pd_fecpro in date,
                          pc_hora   in char,
                          pc_usr    in char,
                          pc_flg    out varchar2) is
  
    ln_tarea     number(4);
    lc_var       char(30) := 'PEQ_EMP_HIS';
    ld_FecRCC    date;
    lc_DocSbsTit char(1);
    lc_tiper     char(1);
    lc_CodSbs    char(10);
    ln_count     number(5);
    ld_fecRccTmp date;
    ln_i         number(5);
    ln_MesRcc    number(5);
  
  begin
  
    --fecha RCC
    begin
      select to_date(tpnro, 'dd/mm/yyyy')
        into ld_FecRCC
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ld_FecRCC := null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select Trim(to_char(a.tp1corr3))
        into lc_DocSbsTit
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        lc_DocSbsTit := null;
    end;
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
  
    case
      when lc_tiper = 'F' then
        begin
          select c_CodSbs
            into lc_CodSbs
            from cldrcci a
           where D_FECPRE = ld_FecRCC
             and C_TDOCID = lc_DocSbsTit
             and C_DOCIDE = pc_ndo
             and rownum = 1;
        exception
          when no_data_found then
            lc_CodSbs := null;
        end;
      
      when lc_tiper = 'J' then
        begin
          select c_CodSbs
            into lc_CodSbs
            from cldrcci a
           where D_FECPRE = ld_FecRCC
             and C_TDOCTR = lc_DocSbsTit
             and C_DOCTRI = pc_ndo
             and rownum = 1;
        exception
          when no_data_found then
            lc_CodSbs := null;
          
        end;
      
      else
        begin
          select c_CodSbs
            into lc_CodSbs
            from cldrcci a
           where D_FECPRE = ld_FecRCC
             and C_DOCIDE = pc_ndo
             and rownum = 1;
        exception
          when no_data_found then
            lc_CodSbs := null;
        end;
      
        if lc_CodSbs is null then
          begin
            select c_CodSbs
              into lc_CodSbs
              from cldrcci a
             where D_FECPRE = ld_FecRCC
               and C_DOCTRI = pc_ndo
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := null;
          end;
        
        end if;
      
    end case;
  
    --Meses a evaluar RCC
    begin
      select a.tp1nro1
        into ln_MesRcc
        from fst198 a
       where a.TP1COD = 1
         and a.TP1COD1 = 10899
         and a.TP1CORR1 = 7000
         AND A.TP1CORR2 = 1;
    
    exception
      when no_data_found then
        ln_MesRcc := 0;
    end;
  
    ld_fecRccTmp := ld_FecRCC;
  
    ln_i := 1;
    begin
      while ln_i <= ln_MesRcc loop
      
        begin
        
          select count(*)
            into ln_count
            from (select substr(a.c_cuenta, 1, 2) CUENTA,
                         sum(n_salcap) SALDO,
                         a.c_codemp,
                         substr(a.c_cuenta, 5, 2) TIPCRE,
                         substr(a.c_cuenta, 3, 1) MON
                    from cldrccs a
                   where c_codsbs = lc_CodSbs
                     and d_fecpre = ld_fecRccTmp
                     and (REGEXP_LIKE(a.c_cuenta, '^14.[1-6]13') or
                         REGEXP_LIKE(a.c_cuenta, '^71.[1-4]13'))
                  
                   group by substr(a.c_cuenta, 1, 2),
                            a.c_codemp,
                            substr(a.c_cuenta, 5, 2),
                            substr(a.c_cuenta, 3, 1)
                  
                  UNION ALL
                  
                  select substr(a.c_cuenta, 1, 2) CUENTA,
                         sum(n_salcap) SALDO,
                         a.c_codemp,
                         substr(a.c_cuenta, 7, 2),
                         substr(a.c_cuenta, 3, 1)
                    from cldrccs a
                   where c_codsbs = lc_CodSbs
                     and d_fecpre = ld_fecRccTmp
                     and REGEXP_LIKE(a.c_cuenta, '^72.513')
                  
                   group by substr(a.c_cuenta, 1, 2),
                            a.c_codemp,
                            substr(a.c_cuenta, 7, 2),
                            substr(a.c_cuenta, 3, 1)
                  
                  );
        
        exception
          when others then
            ln_count := 0;
        end;
      
        if nvl(ln_count, 0) >= 1 then
          exit;
        
        end if;
      
        ln_i         := ln_i + 1;
        ld_fecRccTmp := Add_months(ld_fecRccTmp, -1);
        ld_fecRccTmp := last_day(ld_fecRccTmp);
      end loop;
    end;
  
    if nvl(ln_count, 0) >= 1 then
      pc_flg := 'S';
    else
      pc_flg := 'N';
    end if;
  
    --insertar log
    begin
      select a.wftaskcod
        into ln_tarea
        from wfwrkitems a
       where a.wfinsprcid = pn_ins
         and a.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom
       and a.jaqz687var = lc_var;
    commit;
  
    insert into jaqz687
      (jaqz687prg,
       jaqz687var,
       jaqz687ins,
       jaqz687tar,
       jaqz687vc1,
       jaqz687fec,
       jaqz687hor,
       jaqz687usr)
    values
      (pc_nom,
       lc_var,
       pn_ins,
       ln_tarea,
       pc_flg,
       pd_fecpro,
       pc_hora,
       pc_usr);
  
    commit;
  
  end Sp_cr_proceso;

  Procedure Sp_porcentaje_amort(pn_pai    in number,
                                pn_tdo    in number,
                                pc_ndo    in char,
                                pn_ins    in number,
                                pd_fecpro in date,
                                pn_porc   out number) is
  
    cursor creditos is
      select b.pgcod,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope,
             b.aoimp
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.ctnro = b.aocta
         and b.pgcod = 1
         and b.aomod in (select a.tp1nro1
                           from fst198 a
                          where a.tp1cod = 1
                            and a.tp1cod1 = 10899
                            and a.tp1corr1 = 7000)
         and b.aostat <> 99;
  
    ln_cod     number(2);
    lc_flg     char(1);
    lc_lin     char(1);
    ln_sdoCap  number(17, 2) := 0;
    ln_mtoDes  number(17, 2) := 0;
    ln_tipcam  number(14, 8);
    ln_mtoPag  number(17, 2) := 0;
    ln_mtoPagT number(17, 2) := 0;
    ln_mtoDesT number(17, 2) := 0;
    ln_cont    number(10) := 0; --mod@abr 20191025 
  
  begin
    for i in creditos loop
      lc_flg  := 'S';
      ln_cont := 1;
      begin
        --excluye 110 diferente de caja construye
        select substr(a.scrub, 5, 2), a.scsdo * -1
          into ln_cod, ln_sdoCap
          from fsd011 a
         where a.pgcod = i.pgcod
           and a.scmod = i.aomod
           and a.scsuc = i.aosuc
           and a.scmda = i.aomda
           and a.scpap = i.aopap
           and a.sccta = i.aocta
           and a.scoper = i.aooper
           and a.scsbop = i.aosbop
           and a.sctope = i.aotope;
      exception
        when others then
          null;
      end;
    
      begin
        --tipo de cambio
        select a.sng120tcbi
          into ln_tipcam
          from sng120 a
         where a.sng120ins = pn_ins
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
      if i.aomda = 101 then
        ln_sdoCap := nvl(ln_sdoCap, 0) * ln_tipcam;
      end if;
    
      if i.aomod = 110 and ln_cod = 4 then
        lc_flg  := 'N';
        ln_cont := 0;
      end if;
    
      lc_lin := 'N';
    
      if i.aomod = 116 then
        begin
          --excluye lineas dp, seguros
          select 'S'
            into lc_lin
            from fst198 a
           where a.tp1cod = 1
             and a.Tp1cod1 = 10823
             and a.Tp1corr1 = 9
             and a.Tp1corr2 = 1
             and a.tp1nro1 = i.aotope;
        exception
          when others then
            lc_lin := 'N';
        end;
      
        if nvl(lc_lin, 'N') = 'S' then
          lc_flg  := 'N';
          ln_cont := 0;
        end if;
      end if;
    
      if lc_flg = 'S' then
        --calcula monto desembolsado
        if i.aomod <> 116 then
          ln_mtoDes := i.aoimp;
          ln_mtoPag := i.aoimp - nvl(ln_sdoCap, 0);
        
        else
          Pq_Cr_Tiposbsrcc.sp_lineas(i.pgcod,
                                     i.aomod,
                                     i.aosuc,
                                     i.aomda,
                                     i.aopap,
                                     i.aocta,
                                     i.aooper,
                                     i.aosbop,
                                     i.aotope,
                                     ln_tipcam,
                                     ln_mtoDes, --ln_mtoDesL,
                                     ln_mtoPag --ln_mtoPagL
                                     );
        
        end if;
      
        ln_mtoPagT := nvl(ln_mtoPagT, 0) + nvl(ln_mtoPag, 0);
        ln_mtoDesT := nvl(ln_mtoDesT, 0) + nvl(ln_mtoDes, 0);
      
      end if;
    
    end loop;
  
    if nvl(ln_mtoDesT, 0) <> 0 then
      pn_porc := nvl(ln_mtoPagT, 0) / nvl(ln_mtoDesT, 0);
    Else
      pn_porc := 0;
    end if;
  
    if ln_cont = 0 then
      pn_porc := 1;
    end if;
  
  end Sp_porcentaje_amort;

  Procedure SP_Lineas(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_ope    in number,
                      pn_sbo    in number,
                      pn_top    in number,
                      pn_tca    in number,
                      pn_mtoDes out number,
                      pn_mtoPag out number) is
  
    ln_mtoPag   number(17, 2);
    ld_fecMaxUt date;
    ln_pp1num   number(9);
    ln_mtoDes   number(17, 2);
  begin
  
    begin
      select max(a.ppfpag)
        into ld_fecMaxUt
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
         and a.d602mo = 116
         and a.d602tr in (50, 60)
         and a.pp1cap <> 0;
    exception
      when others then
        null;
    end;
  
    begin
      select a.pp1nump, a.pp1cap
        into ln_pp1num, ln_mtoDes
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
         and a.d602mo = 116
         and a.d602tr in (50, 60)
         and a.ppfpag = ld_fecMaxUt
         and a.pp1cap <> 0;
    exception
      when others then
        null;
    end;
  
    if nvl(ln_mtoDes, 0) < 0 then
      ln_mtoDes := nvl(ln_mtoDes, 0) * -1;
    end if;
  
    begin
      select sum(a.pp1cap)
        into ln_mtoPag
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
         and (a.d602mo, a.d602tr) not in (select 116, 50 from dual)
         and (a.d602mo, a.d602tr) not in (select 116, 60 from dual)
         and a.ppfpag >= ld_fecMaxUt
         and a.pp1nump > ln_pp1num;
    exception
      when others then
        null;
    end;
  
    if ld_fecMaxUt is null then
      begin
        select sum(a.ppcap)
          into ln_mtoDes
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select sum(a.pp1cap)
          into ln_mtoPag
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
    end if;
  
    if pn_mda = 101 then
      ln_mtoDes := nvl(ln_mtoDes, 0) * pn_tca;
      ln_mtoPag := nvl(ln_mtoPag, 0) * pn_tca;
    end if;
  
    pn_mtoDes := ln_mtoDes;
    pn_mtoPag := ln_mtoPag;
  
  end SP_Lineas;

  Procedure SP_Lineas_ant(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_tca    in number,
                          pd_Fecpro in date,
                          pn_mtoDes out number,
                          pn_mtoPag out number) is
  
    cursor calendario is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
         and a.d602mo = 116
         and a.d602tr in (50, 60)
       order by a.d602fc desc;
  
    ld_fecUlt date;
    ln_mtoPag number(17, 2);
    ln_sdo    number(17, 2);
    ln_mtoDes number(17, 2);
    ld_fecmax date := pd_Fecpro;
  
  begin
  
    for i in calendario loop
    
      ld_fecUlt := i.ppfpag;
    
      begin
        select sum(a.pp1cap)
          into ln_mtoPag
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d602co = 'S'
           and (a.d602mo, a.d602tr) not in (select 116, 50 from dual)
           and (a.d602mo, a.d602tr) not in (select 116, 60 from dual)
           and a.ppfpag >= ld_fecUlt
           and a.ppfpag <= ld_fecmax;
      exception
        when others then
          null;
      end;
    
      if nvl(ln_mtoPag, 0) <> 0 then
        exit;
      else
        ld_fecmax := ld_fecUlt;
      
      end if;
    
    end loop;
  
    --saldo actual
    begin
      select a.scsdo * -1
        into ln_sdo
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top;
    exception
      when others then
        null;
    end;
  
    if pn_mda = 101 then
      ln_sdo := nvl(ln_sdo, 0) * pn_tca;
    end if;
  
    ln_mtoDes := nvl(ln_sdo, 0) + nvl(ln_mtoPag, 0);
  
    pn_mtoDes := ln_mtoDes;
    pn_mtoPag := ln_mtoPag;
  
  end SP_Lineas_ant;

end pq_cr_TipoSbsRCC;
/

