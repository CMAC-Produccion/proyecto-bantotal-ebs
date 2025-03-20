create or replace package pq_Cr_CampaniaPers2019 is

  Procedure Sp_cr_UltimoCredito(pn_pai    in number,
                                pn_tdo    in number,
                                pc_ndo    in char,
                                pd_fecpro in date,
                                pn_ins    in number,
                                --pc_nom      in char,
                                --pc_hora     in char,
                                --pc_usr      in char,
                                pc_flg      out char,
                                ln_promedio out number,
                                ln_moramax  out number,
                                pc_flg106   out char,
                                pc_flgTasa  out char);
  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pd_fecpro   in date,
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_diafin   out number);
end pq_Cr_CampaniaPers2019;
/

create or replace package body pq_Cr_CampaniaPers2019 is

  Procedure Sp_cr_UltimoCredito(pn_pai    in number,
                                pn_tdo    in number,
                                pc_ndo    in char,
                                pd_fecpro in date,
                                pn_ins    in number,
                                --pc_nom      in char,
                                --pc_hora     in char,
                                --pc_usr      in char,
                                pc_flg      out char,
                                ln_promedio out number,
                                ln_moramax  out number,
                                pc_flg106   out char,
                                pc_flgTasa  out char) is
  
    ld_fecdes     date;
    ln_emp        number(3);
    ln_mod        number(3);
    ln_suc        number(3);
    ln_mda        number(4);
    ln_pap        number(4);
    ln_cta        number(9);
    ln_ope        number(9);
    ln_sbo        number(3);
    ln_top        number(3);
    ln_ins        number(10);
    ln_tmod       number(4);
    ld_fecEva     date;
    ln_meses      number(10);
    ln_evalVig    number(9);
    ln_contCuotas number(18);
    ln_dia        number(18);
    ln_empO       number(3);
    ln_ctaO       number(9);
    ln_mdaO       number(4);
    ln_papO       number(4);
    ln_modO       number(3);
    ln_topO       number(3);
    ln_defn       number(17, 2);
    --ln_tarea      number(4);
    --lc_var1       char(30) := 'EVALVIG_12';
    --lc_var2       char(30) := 'AVGMORA_VIG';
    --lc_var3       char(30) := 'MAXMORA_VIG';
    --lc_var4       char(30) := 'CREDITO_VIGENTE106';
    --lc_var5       char(30) := 'TASA_NEGOCIADA';
  
  begin
  
    begin
      select max(b.aofval)
        into ld_fecdes
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.ctnro = b.aocta
         AND B.PGCOD = 1
         and (b.aomod in (select modulo from fst111 where dscod = 50) or
             b.aomod = 117)
         and b.aostat <> 99;
    
    exception
      when others then
        null;
    end;
  
    begin
      select b.pgcod,
             b.aomod,
             b.aosuc,
             b.aomda,
             b.aopap,
             b.aocta,
             b.aooper,
             b.aosbop,
             b.aotope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.ctnro = b.aocta
         and b.pgcod = 1
         and (b.aomod in (select modulo from fst111 where dscod = 50) or
             b.aomod = 117)
         and b.aostat <> 99
         and b.aofval = ld_fecdes;
    
    exception
      when too_many_rows then
        begin
          select b.pgcod,
                 b.aomod,
                 b.aosuc,
                 b.aomda,
                 b.aopap,
                 b.aocta,
                 b.aooper,
                 b.aosbop,
                 b.aotope
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsr008 a, fsd010 b
           where a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_ndo
             and a.ctnro = b.aocta
             and b.pgcod = 1
             and (b.aomod in (select modulo from fst111 where dscod = 50) or
                 b.aomod = 117)
             and b.aostat <> 99
             and b.aofval = ld_fecdes
             and rownum = 1;
        
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    --verifica evaluacion
    ln_ins := fn_instancia_credito(v_Scmod  => ln_mod,
                                   v_Scsuc  => ln_suc,
                                   v_Scmda  => ln_mda,
                                   v_Scpap  => ln_pap,
                                   v_Sccta  => ln_cta,
                                   v_Scoper => ln_ope,
                                   v_Scsbop => ln_sbo,
                                   v_Sctope => ln_top);
    begin
      select a.sng021tmod
        into ln_tmod
        from sng021 a
       where a.sng021sol = ln_ins;
    exception
      when others then
        null;
    end;
  
    if ln_tmod = 13 then
    
      begin
        select a.SNG120FPag
          into ld_fecEva
          from sng120 a
         where a.sng120ins = ln_ins
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
    else
      begin
        select a.SNG120FVal
          into ld_fecEva
          from sng120 a
         where a.sng120ins = ln_ins
           and a.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    end if;
  
    ln_meses := months_between(pd_fecpro, ld_fecEva);
  
    Begin
      select a.tp1nro1
        into ln_evalVig
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 7777
         and a.tp1corr2 = 1;
    exception
      when others then
        null;
    end;
    if ln_meses <= ln_evalVig then
      pc_flg := 'S';
    else
      pc_flg := 'N';
    end if;
  
    /*--obtener tarea
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
    
    --insertar log  EVALVIG_12
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom
       and a.jaqz687var = lc_var1
    
    ;
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
       lc_var1,
       pn_ins,
       ln_tarea,
       SUBSTR(pc_flg, 1, 1),
       pd_fecpro,
       pc_hora,
       pc_usr);
    
    commit;*/
  
    --promedio de mora y mora maxima
    pq_Cr_campaniaPers2019.Sp_CalculaCuotas_New(pn_emp      => ln_emp,
                                                pn_mod      => ln_mod,
                                                pn_suc      => ln_suc,
                                                pn_mda      => ln_mda,
                                                pn_pap      => ln_pap,
                                                pn_cta      => ln_cta,
                                                pn_ope      => ln_ope,
                                                pn_sbo      => ln_sbo,
                                                pn_top      => ln_top,
                                                pd_fecpro   => pd_fecpro,
                                                ln_contador => ln_contCuotas,
                                                ln_diasTot  => ln_dia,
                                                ln_diafin   => ln_moramax);
  
    if ln_contCuotas = 0 then
      ln_promedio := 0;
    else
      ln_promedio := round((ln_dia / ln_contCuotas), 2);
    end if;
  
    /*--insertar log  AVGMORA_VIG
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom
       and a.jaqz687var = lc_var2
    
    ;
    commit;
    
    insert into jaqz687
      (jaqz687prg,
       jaqz687var,
       jaqz687ins,
       jaqz687tar,
       JAQZ687VN2,
       jaqz687fec,
       jaqz687hor,
       jaqz687usr)
    values
      (pc_nom,
       lc_var2,
       pn_ins,
       ln_tarea,
       ln_promedio,
       pd_fecpro,
       pc_hora,
       pc_usr);
    
    commit;*/
  
    /* --insertar log  MAXMORA_VIG
      delete from jaqz687 a
       where a.jaqz687ins = pn_ins
         and a.jaqz687tar = ln_tarea
         and a.jaqz687prg = pc_nom
         and a.jaqz687var = lc_var3
      
      ;
      commit;
    
      insert into jaqz687
        (jaqz687prg,
         jaqz687var,
         jaqz687ins,
         jaqz687tar,
         JAQZ687VN1,
         jaqz687fec,
         jaqz687hor,
         jaqz687usr)
      values
        (pc_nom,
         lc_var3,
         pn_ins,
         ln_tarea,
         ln_moramax,
         pd_fecpro,
         pc_hora,
         pc_usr);
    
      commit;
    */
    --validacion credito personal directo 106
  
    begin
      select 'S'
        into pc_flg106
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
                            and a.TP1CORR1 = 7777
                            AND a.TP1CORR2 = 2) --modulos
         and b.aotope in (select a.tp1nro1
                            from fst198 a
                           where a.tp1cod = 1
                             and a.tp1cod1 = 10899
                             and a.TP1CORR1 = 7777
                             AND a.TP1CORR2 = 3) --tipos de operacion
         and b.aostat <> 99
         and rownum = 1;
    
    exception
      when others then
        pc_flg106 := 'N';
    end;
    pc_flg106 := nvl(pc_flg106, 'N');
  
    /* --insertar log  CREDITO_VIGENTE106
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom
       and a.jaqz687var = lc_var4
    
    ;
    commit;
    
    insert into jaqz687
      (jaqz687prg,
       jaqz687var,
       jaqz687ins,
       jaqz687tar,
       JAQZ687VC1,
       jaqz687fec,
       jaqz687hor,
       jaqz687usr)
    values
      (pc_nom,
       lc_var4,
       pn_ins,
       ln_tarea,
       SUBSTR(pc_flg106, 1, 1),
       pd_fecpro,
       pc_hora,
       pc_usr);
    
    commit;*/
  
    --verifica tasa negociada
  
    begin
      select a.xwfempresa,
             a.xwfcuenta,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfmodulo,
             a.xwftipope
        into ln_empO, ln_ctaO, ln_mdaO, ln_papO, ln_modO, ln_topO
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select Pp028DefN
        into ln_defn
        from fpp028 a
       where a.Pp028Emp = ln_empO
         and a.Pp028Mod = ln_modO
         and a.Pp028Top = ln_topO
         and a.Pp028Mda = ln_mdaO
         and a.Pp028Pap = ln_papO
         and a.Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into pc_flgTasa
        from fsd327 a
       where a.VT1Pgcod = ln_empO
         and a.VT1Mod = ln_modO
         and a.VT1Tpiz = ln_defn --17 --ln_defn
         and a.VT1Ctnr = ln_ctaO
         and a.VT1Mon = ln_mdaO
         and a.VT1Pap = ln_papO
         and a.VT1Tpfd <= pd_fecpro
         and a.VT1FchVen >= pd_fecpro
         and rownum = 1;
    exception
      when others then
        pc_flgTasa := 'N';
    end;
    pc_flgTasa := nvl(pc_flgTasa, 'N');
    /*--insertar log
    
    delete from jaqz687 a
     where a.jaqz687ins = pn_ins
       and a.jaqz687tar = ln_tarea
       and a.jaqz687prg = pc_nom --mod@abr 20190911
       and a.jaqz687var = lc_var5 --mod@abr 20190911
    
    ;
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
       lc_var5,
       pn_ins,
       ln_tarea,
       SUBSTR(pc_flgTasa, 1, 1),
       pd_fecpro,
       pc_hora,
       pc_usr);
    
    commit;*/
  
  end Sp_cr_UltimoCredito;

  Procedure Sp_CalculaCuotas_New(pn_emp      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pd_fecpro   in date,
                                 ln_contador out number,
                                 ln_diasTot  out number,
                                 ln_diafin   out number) is
    cursor creditos(ld_fecfin in date) is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag
      
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
         and a.ppfpag < ld_fecfin
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias number(10);
  
    ld_fecantC date;
  
    ld_fecpago date;
    --ld_fectemp date;
    lc_sinM char(1) := 'N';
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
    
      ld_fecantC := to_date('2000.01.01', 'yyyy.mm.dd');
    
      ln_diafin := 0;
      ln_dias   := 0;
    
      --ld_fectemp := last_day(pd_fecpro);
    
      For i in creditos(pd_fecpro) loop
      
        begin
        
          select b.ppfpag
            into ld_fecpago
            from fsd602 b
           where b.pgcod = i.pgcod
             and b.ppmod = i.ppmod
             and b.ppsuc = i.ppsuc
             and b.ppmda = i.ppmda
             and b.pppap = i.pppap
             and b.ppcta = i.ppcta
             and b.ppoper = i.ppoper
             and b.ppsbop = i.ppsbop
             and b.pptope = i.pptope
             and b.ppfpag = i.ppfpag
             and b.pp1stat = 'T'
             and b.d602co = 'S'
             and (b.pp1cap + b.pp1int) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            ld_fecpago := null;
        end;
      
        if ld_fecpago is null then
          if i.ppfpag > pd_fecpro then
            --mod@abr 20170912
            lc_sinM := 'S';
          end if;
        end if;
      
        --if ld_fecpago is null then
      
        if ld_fecantC <> i.ppfpag then
        
          if lc_sinM <> 'S' then
            ln_contador := ln_contador + 1;
          end if;
        
          ln_dias := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,
                                                      i.ppmod,
                                                      i.ppsuc,
                                                      i.ppmda,
                                                      i.pppap,
                                                      i.ppcta,
                                                      i.ppoper,
                                                      i.ppsbop,
                                                      i.pptope,
                                                      i.ppfpag,
                                                      pd_fecpro);
        
          ln_diasTot := ln_diasTot + ln_dias;
        
          --mora maxima
          if ln_dias > ln_diafin then
            ln_diafin := ln_dias;
          end if;
          --mora maxima
        end if;
      
        ld_fecantC := i.ppfpag;
        --end if;
      
      end loop;
    
    end;
  
  end Sp_CalculaCuotas_New;

end pq_Cr_CampaniaPers2019;
/

