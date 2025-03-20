create or replace package PQ_CR_CAMPANAVERANO is

  -- Author  : ABERNEDO
  -- Created : 04/01/2017 11:27:38 a.m.
  -- Purpose : 

  Procedure Sp_MontoParalelo(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in char,
                             pd_fecpro in date,
                             pn_ins    in number,
                             pn_mto    out number);
  Procedure Sp_Garantia(pn_pai  in number,
                        pn_tdo  in number,
                        pc_ndo  in char,
                        pn_cont out number);
  Procedure Sp_Adicionales(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pc_flg out varchar2);
  Procedure Sp_CapPagoParalelo(pn_ins in number, pn_flg out varchar2);
  Procedure sp_monto2_3(pn_ins in number, pc_flg out varchar2);
  Procedure sp_nro_desemb(pn_ins in number, pn_cont out number);
  Procedure Sp_RNGParciales(pn_ins    in number,
                            pd_fecpro in date,
                            pc_flg    out varchar2,
                            pc_flgC   out varchar2,
                            pc_flgS   out varchar2,
                            pc_flgA   out varchar2,
                            pc_flgR   out varchar2);
  Procedure Sp_CalculaCuotas(pn_emp      in number,
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
                             ln_diasTot  out number);
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number;
  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               lc_tiper_FN in char) return number;
  Procedure Sp_EsParalelo(pn_pai in number,
                          pn_tdo in number,
                          pc_ndo in char,
                          pc_flg out varchar2);
----------------------------------------------------
Procedure pq_cr_Sp_AmplCapPag(pn_emp in number,
                               pn_mod in number,
															 pn_suc in number,
															 pn_mda in number,
															 pn_pap in number,
															 pn_cta in number,
															 pn_ope in number,
															 pn_sbo in number,
															 pn_top in number,
															 pd_fecpro in date,
															 pc_flag out varchar2);
-----------------------------------------------------
procedure sp_ncrd_bgarantia(pn_pai  in number,
                            pn_tdo  in number,
                            pc_ndo  in char,
                            pn_cont out number);
-----------------------------------------------------
end PQ_CR_CAMPANAVERANO;
/

create or replace package body PQ_CR_CAMPANAVERANO is

  Procedure Sp_MontoParalelo(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in char,
                             pd_fecpro in date,
                             pn_ins    in number,
                             pn_mto    out number) is
    ln_PrimPor   number(3);
    ln_SeguPor   number(3);
    ln_Meses     number(3);
    ld_fecini    date;
    ln_mtoMax    number(17, 2);
    ln_instancia number(10);
    ln_mtoPar    number(17, 2);
    ln_SNG001Ori number(2);
    ln_mtoConv   number(17, 2);
    ln_mdaPar    number(4);
    ln_tipcam    number(14, 8);
    lc_flgHipo   char(1);
  
    Cursor CapitalTrabajo is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aoimp
        from fsd010 a, fst198 b, fsr008 c
       where a.pgcod = 1
         and a.aocta = c.ctnro
         and a.aomod = b.tp1nro1
         and a.aotope = b.tp1nro2
         and b.tp1cod = 1
         and b.tp1cod1 = 11005
         and b.tp1corr1 = 2
         and b.tp1corr2 = 1
         and a.aofval between ld_fecini and pd_fecpro
         and c.pepais = pn_pai
         and c.petdoc = pn_tdo
         and c.pendoc = pc_ndo
         and c.cttfir = 'T';
  
    Cursor creditos_otros is
      select d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aosbop,
             d.aotope,
             d.aoimp
        from fsd010 d, fst198 e, fsr008 f
       where d.pgcod = 1
         and d.aocta = f.ctnro
         and d.aomod = e.tp1nro1
         and d.aotope = e.tp1nro2
         and e.tp1cod = 1
         and e.tp1cod1 = 11005
         and e.tp1corr1 = 2
         and e.tp1corr2 = 2
         and d.aomod not in (106, 107, 108)
         and d.aofval between ld_fecini and pd_fecpro
         and f.pepais = pn_pai
         and f.petdoc = pn_tdo
         and f.pendoc = pc_ndo
         and f.cttfir = 'T';
  
  begin
    --obtiene primer porcentaje
    begin
      select a.tp1nro1
        into ln_PrimPor
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 3
         and a.tp1corr3 = 1;
    exception
      when others then
        ln_PrimPor := 0;
    end;
  
    --obtiene segundo porcentaje
    begin
      select a.tp1nro1
        into ln_SeguPor
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 3
         and a.tp1corr3 = 2;
    exception
      when others then
        ln_SeguPor := 0;
    end;
  
    --obtiene meses para validacion
    begin
      select a.tp1nro1
        into ln_Meses
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 3
         and a.tp1corr3 = 3;
    exception
      when others then
        ln_Meses := 0;
    end;
  
    --fecha de corte
    ld_fecini := add_months(pd_fecpro, -ln_Meses);
  
    --moneda del credito
    begin
      select distinct a.xwfmoneda
        into ln_mdaPar
        from xwf700 a
       where a.xwfprcins = pn_ins;
    exception
      when others then
        null;
    end;
  
    --tipo de cambio
    begin
      select cotcbi
        into ln_tipcam
        from fsh005 f
       where cofdes in (select max(cofdes)
                          from fsh005 g
                         where g.cofdes <=pd_fecpro
                           and moneda = 101)
         and moneda = 101;
    exception
      when no_data_found then
        ln_tipcam := 0;
    end;
  
    for j in CapitalTrabajo loop
      lc_flgHipo := 'N';
      if j.aomod = 110 then
        begin
          select 'S'
            into lc_flgHipo
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11005
             and a.tp1corr1 = 2
             and a.tp1corr2 = 5
             and a.tp1nro1 <> j.aotope;
        exception
          when others then
            lc_flgHipo := 'N';
        end;
      
      end if;
    
      if lc_flgHipo = 'N' then
      
        if ln_mdaPar <> j.aomda then
          if ln_mdaPar = 0 then
            ln_mtoConv := j.aoimp / ln_tipcam;
          else
            ln_mtoConv := j.aoimp * ln_tipcam;
          end if;
        else
          ln_mtoConv := j.aoimp;
        end if;
      
        if ln_mtoMax is null then
          ln_mtoMax := ln_mtoConv;
        end if;
        ln_instancia := fn_instancia_credito(j.aomod,
                                             j.aosuc,
                                             j.aomda,
                                             j.aopap,
                                             j.aocta,
                                             j.aooper,
                                             j.aosbop,
                                             j.aotope);
      
        begin
          select SNG001Ori
            into ln_SNG001Ori
            from sng001 s01
           where s01.sng001inst = ln_instancia;
        exception
          when too_many_rows then
            begin
              select SNG001Ori
                into ln_SNG001Ori
                from sng001 s01
               where s01.sng001inst = ln_instancia
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          when others then
            null;
        end;
      
        if ln_SNG001Ori = 7 then
        
          begin
            select a.sng120mto
              into ln_mtoPar
              from sng120 a
             where a.sng120ins = ln_instancia
               and a.sng120tsk like 'APROBAC%'
               and rownum = 1;
          exception
            when others then
              null;
          end;
        
          if ln_mtoMax is null then
            ln_mtoMax := ln_mtoPar;
          else
            if ln_mtoPar > ln_mtoMax then
              ln_mtoMax := ln_mtoPar;
            end if;
          
          end if;
        
        else
          if ln_mtoConv > ln_mtoMax then
            ln_mtoMax := ln_mtoConv;
          end if;
        
        end if;
      
      end if;
    
    end loop;
  
    if ln_mtoMax is null then
    
      for i in creditos_otros loop
      
        lc_flgHipo := 'N';
        if i.aomod = 110 then
          begin
            select 'S'
              into lc_flgHipo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11005
               and a.tp1corr1 = 2
               and a.tp1corr2 = 5
               and a.tp1nro1 <> i.aotope;
          exception
            when others then
              lc_flgHipo := 'N';
          end;
        
        end if;
      
        if lc_flgHipo = 'N' then
          if ln_mdaPar <> i.aomda then
            if ln_mdaPar = 0 then
              ln_mtoConv := i.aoimp / ln_tipcam;
            else
              ln_mtoConv := i.aoimp * ln_tipcam;
            end if;
          else
            ln_mtoConv := i.aoimp;
          end if;
        
          if ln_mtoMax is null then
            ln_mtoMax := ln_mtoConv;
          end if;
          ln_instancia := fn_instancia_credito(i.aomod,
                                               i.aosuc,
                                               i.aomda,
                                               i.aopap,
                                               i.aocta,
                                               i.aooper,
                                               i.aosbop,
                                               i.aotope);
        
          begin
            select SNG001Ori
              into ln_SNG001Ori
              from sng001 s01
             where s01.sng001inst = ln_instancia;
          exception
            when too_many_rows then
              begin
                select SNG001Ori
                  into ln_SNG001Ori
                  from sng001 s01
                 where s01.sng001inst = ln_instancia
                   and rownum = 1;
              exception
                when others then
                  null;
              end;
            when others then
              null;
          end;
        
          if ln_SNG001Ori = 7 then
          
            begin
              select a.sng120mto
                into ln_mtoPar
                from sng120 a
               where a.sng120ins = ln_instancia
                 and a.sng120tsk like 'APROBAC%'
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
            if ln_mtoMax is null then
              ln_mtoMax := ln_mtoPar;
            else
              if ln_mtoPar > ln_mtoMax then
                ln_mtoMax := ln_mtoPar;
              end if;
            
            end if;
          
          else
            if ln_mtoConv > ln_mtoMax then
              ln_mtoMax := ln_mtoConv;
            end if;
          
          end if;
        end if;
      end loop;
    
      pn_mto := (ln_mtoMax * ln_SeguPor ) / 100;
    else
      pn_mto := (ln_mtoMax * ln_PrimPor  ) / 100;
    
    end if;
  
  end Sp_MontoParalelo;
  -------------------------------------------------------------------------------------------
  Procedure Sp_Garantia(pn_pai  in number,
                        pn_tdo  in number,
                        pc_ndo  in char,
                        pn_cont out number) is
  
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
         and a.cttfir = 'T'
         and a.pgcod= b.pgcod
         and a.ctnro = b.aocta
         and b.aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (108, 141, 106, 107))
         and b.aostat <> 99
				 and b.pgcod=1;
    lc_flagPri char(1);
    lc_flagLiq char(1);
    lc_flag    char(1);
    lc_flgHipo char(1);
  
  begin
    pn_cont := 0;
    for i in creditos loop
      lc_flgHipo := 'N';
      if i.aomod = 110 then
        begin
          select 'N'
            into lc_flgHipo
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11005
             and a.tp1corr1 = 2
             and a.tp1corr2 = 5
             and a.tp1nro1 = i.aotope
             and rownum= 1;
        exception
          when others then
            lc_flgHipo := 'S';
        end;
      
      end if;
    
      if lc_flgHipo = 'N' then
        begin
          select 'S', 'S'
            into lc_flagPri, lc_flag
            from fsr011 a
           where a.r1cod = i.pgcod
             and a.r1suc = i.aosuc
             and a.r1mod = i.aomod
             and a.r1mda = i.aomda
             and a.r1pap = i.aopap
             and a.r1cta = i.aocta
             and a.r1oper = i.aooper
             and a.r1sbop = i.aosbop
             and a.r1tope = i.aotope
             and a.relcod = 50
             and a.r2tope not in (80, 85)
             and rownum = 1;
        exception
          when others then
            lc_flagPri := 'N';
            lc_flag    := 'N';
        end;
      
        begin
          select 'S'
            into lc_flagLiq
            from fsr011 a
           where a.r1cod = i.pgcod
             and a.r1suc = i.aosuc
             and a.r1mod = i.aomod
             and a.r1mda = i.aomda
             and a.r1pap = i.aopap
             and a.r1cta = i.aocta
             and a.r1oper = i.aooper
             and a.r1sbop = i.aosbop
             and a.r1tope = i.aotope
             and a.relcod = 50
             and a.r2tope in (80, 85)
             and rownum = 1;
        exception
          when others then
            lc_flagLiq := 'N';
        end;
      
        if lc_flagPri = 'S' and lc_flagLiq = 'S' then
          lc_flag := 'N';
        end if;
      
        if lc_flag = 'S' then
          pn_cont := pn_cont + 1;
        end if;
      end if;
    end loop;
  end Sp_Garantia;
  ---------------------------------------------------------------------------------
  Procedure Sp_Adicionales(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pc_flg out varchar2) is
  begin
    pc_flg := 'N';
    begin
      select 'S'
        into pc_flg
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.cttfir = 'T'
         and b.pgcod  = 1
         and a.ctnro = b.aocta
         and b.aostat <> 99
         and (aomod,aotope) in (select tp1nro1,tp1nro2
                            from fst198
                           where tp1cod = 1
                             and tp1cod1 = 11005
                             and tp1corr1 = 2
                             and tp1corr2 = 11
                             and tp1nro1 <> 116)  
         and rownum = 1;
    
    exception
      when others then
        pc_flg := 'N';
    end;
  
  end Sp_Adicionales;
  --------------------------------------------------------------------------------------------
  Procedure Sp_CapPagoParalelo(pn_ins in number, pn_flg out varchar2) is
  
    ln_mto     number(17, 2);
    ln_mda     number(4);
    ln_eval    number(10);
    ln_mtoSol  number(17, 2);
    ln_mtoDol  number(17, 2);
    ln_ventas  number(17, 2);
    ln_tipcamb NUMBER(14, 8);
  begin
    --tipo de cambio
    begin
      select A.SNG120TCBI
        into ln_tipcamb
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk like 'EVALUACION%';
    exception
      when others then
        null;
    end;
    begin
      select a.xwfmonto1, a.xwfmoneda
        into ln_mto, ln_mda
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng021eval
        into ln_eval
        from sng021 a
       where a.sng021sol = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into ln_mtoSol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into ln_mtoDol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 573;
    exception
      when others then
        null;
    end;
  
    if ln_mda = 0 then
      ln_ventas := ((ln_mtoDol * ln_tipcamb) + ln_mtoSol);
    else
      ln_ventas := ((ln_mtoSol / ln_tipcamb) + ln_mtoDol);
    end if;
  
    if ln_mto > ln_ventas then
      pn_flg := 'S';
    else
      pn_flg := 'N';
    
    end if;
  
  end Sp_CapPagoParalelo;
  ------------------------------------------------------------------------------
  Procedure sp_monto2_3(pn_ins in number, pc_flg out varchar2) is
  
    ln_mto1        number(17, 2);
    ln_numerador   number(3);
    ln_denominador number(3);
    ln_mtoPar      number(17, 2);
    ln_mtoCorr     number(17, 2);
  begin
    begin
      select a.sng002mon
        into ln_mto1
        from sng002 a
       where a.sng001inst = pn_ins
         and a.sng002cor = 1;
    exception
      when others then
        ln_mto1 := 0;
    end;
  
    --partes del monto aprobado
    begin
      select a.tp1nro1, a.tp1nro2
        into ln_numerador, ln_denominador
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 3
         and a.tp1corr3 = 4;
    exception
      when others then
        ln_numerador   := 0;
        ln_denominador := 0;
    end;
  
    begin
      select a.sng120mto
        into ln_mtoPar
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk like 'SOLIC%'
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if ln_denominador > 0 then
      ln_mtoCorr := (nvl(ln_mtoPar, 0) * nvl(ln_numerador, 0)) /
                    nvl(ln_denominador, 0);
    
      if ln_mto1 <= ln_mtoCorr then
        pc_flg := 'S';
      else
        pc_flg := 'N';
      end if;
    
    end if;
  
  end sp_monto2_3;
  ---------------------------------------------------------------------------------------------
  Procedure sp_nro_desemb(pn_ins in number, pn_cont out number) is
  
  begin
    begin
      select count(*)
        into pn_cont
        from sng002 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        pn_cont := 0;
    end;
  
  end sp_nro_desemb;
---------------------------------------------------------
  Procedure Sp_RNGParciales(pn_ins    in number,
                            pd_fecpro in date,
                            pc_flg    out varchar2,
                            pc_flgC   out varchar2,
                            pc_flgS   out varchar2,
                            pc_flgA   out varchar2,
                            pc_flgR   out varchar2) is
  
    ln_emp        number(3);
    ln_suc        number(3);
    ln_mod        number(3);
    ln_mda        number(3);
    ln_pap        number(3);
    ln_cta        number(9);
    ln_ope        number(9);
    ln_sbo        number(3);
    ln_top        number(3);
    ln_contCuotas number(18);
    ln_dia        number(18);
    ln_diaGuia    number(2);
    ln_promedio   number(18, 2);
    ln_contCuo    number(5);
    ln_mtoDes     number(17, 2);
    ln_mtoPag     number(17, 2);
    ln_mtoCor     number(17, 2);
    ld_fecpxv     date;
    DocSbsTit     char(1);
    DocSbs        number(10);
    ln_pai        number(3);
    ln_tdo        number(2);
    lc_ndo        char(12);
    fecNum_rcc    number(9);
    fec_rcc       date;
    lc_tiper      char(1);
    ln_cal        number(10,5);
  
  begin
  
    begin
      select a.xwfempresa,
             a.xwfsucursal,
             a.xwfmodulo,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a, xwf070 b
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.xwfprcin
         and b.xwfcont = 'S';
    
    exception
      when others then
        null;
    end;
  
    pq_cr_campanaverano.sp_calculaCuotas(ln_emp,
                                         ln_mod,
                                         ln_suc,
                                         ln_mda,
                                         ln_pap,
                                         ln_cta,
                                         ln_ope,
                                         ln_sbo,
                                         ln_top,
                                         pd_fecpro,
                                         ln_contCuotas,
                                         ln_dia);
    if ln_contCuotas = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round((ln_dia / ln_contCuotas), 2);
    end if;
  
    --dias de atraso parametrizados                  
    begin
      select a.tp1nro1
        into ln_diaGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 4
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    if ln_promedio > ln_diaGuia then
      pc_flg := 'S';
    else
      pc_flg := 'N';
    
    end if;
  
    --Nro de cuotas
  
    begin
      select count(*)
        into ln_contCuo
        from fsd602 o
       where o.pgcod = ln_emp
         and o.ppmod = ln_mod
         and o.ppsuc = ln_suc
         and o.ppmda = ln_mda
         and o.pppap = ln_pap
         and o.ppcta = ln_cta
         and o.ppoper = ln_ope
         and o.ppsbop = ln_sbo
         and o.pptope = ln_top
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0
         and o.ppfpag <= pd_fecpro
       group by o.pgcod,
                o.ppmod,
                o.ppsuc,
                o.ppmda,
                o.pppap,
                o.ppcta,
                o.ppoper,
                o.ppsbop,
                o.pptope;
    
    exception
      when no_data_found then
        ln_contCuo := 0;
      
    end;
  
    --nro de cuotas parametrizadas                  
    begin
      select a.tp1nro1
        into ln_diaGuia
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 4
         and a.tp1corr3 = 2;
    exception
      when others then
        null;
    end;
  
    if ln_contCuo < ln_diaGuia then
      pc_flgC := 'S';
    else
      pc_flgC := 'N';
    end if;
  
    --control por saldo capital pagado
    begin
      select a.aoimp
        into ln_mtoDes
        from fsd010 a
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;
         exception when others then null;
    end;
  
    begin
      select -a.scsdo
        into ln_mtoPag
        from fsd011 a
       where a.pgcod = ln_emp
         and a.scmod = ln_mod
         and a.scsuc = ln_suc
         and a.scmda = ln_mda
         and a.scpap = ln_pap
         and a.sccta = ln_cta
         and a.scoper = ln_ope
         and a.scsbop = ln_sbo
         and a.sctope = ln_top;
         
         exception when others then null;
    end;
    ln_mtoCor := (ln_mtoDes * 30) / 100;
  
    if ln_mtoPag < ln_mtoCor then
      pc_flgS := 'S';
    else
      pc_flgS := 'N';
    end if;
  
    --Verifica si se encuentra al dia
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = ln_emp
         and n.ppcta = ln_cta
         and n.ppmda = ln_mda
         and n.ppsuc = ln_suc
         and n.pppap = ln_pap
         and n.ppoper = ln_ope
         and n.ppsbop = ln_sbo
         and n.pptope = ln_top
         and n.ppmod = ln_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
  
    if ld_fecpxv < pd_fecpro then
      pc_flgA := 'S';
    else
      pc_flgA := 'N';
    end if;
  
    --Calificacion RCC
    begin
      select a.pepais, a.petdoc, a.pendoc
        into ln_pai, ln_tdo, lc_ndo
        from fsr008 a
       where ctnro = ln_cta
         and a.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    begin
      select tpnro
        into fecNum_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fecNum_rcc := null;
    end;
    fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = ln_pai
         and a.petdoc = ln_tdo
         and a.pendoc = lc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
  
    ln_cal := pq_cr_campanaverano.Fn_calificacion_RCC(DocSbsTit,
                                                      lc_ndo,
                                                      fec_rcc,
                                                      lc_tiper);
  
    if ln_cal <> 100.00 then
      pc_flgR := 'S';
    else
      pc_flgR := 'N';
    end if;
  
  end Sp_RNGParciales;
  ----------------------------------------------------------------------------------------------------
  Procedure Sp_CalculaCuotas(pn_emp      in number,
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
                             ln_diasTot  out number) is
    cursor creditos is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag --,modificado 20151022 porque no esta tomando la ultima cuota pendiente de pago
      --b.ppfpag pag602,modificado 20151022
      --b.pp1fech modificado 20151022
        from /*bantprod.*/ fsd601 a --,fsd602 b modificado 20151022
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
            --and a.ppfpag between pd_fecor and pd_fec
            --and a.ppfpag >= pd_fecor
         and a.ppfpag <= pd_fecpro
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) > 0;
  
    --ln_contador number(5);
    ln_dias number(10);
    --ln_diasTot number(5);
  
    --ld_fecpag date;
    --ln_mpag number(2);
    --ln_mdpa number(2);
    --ln_apag number(4);
    --ln_adpa number(4);
  
    ld_fecantC date;
  
    ld_fecpago date; --modificado 20151022
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
    
      ld_fecantC := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        begin
        
          select b.pp1fech
            into ld_fecpago
            from /*bantprod.*/ fsd602 b
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
             and rownum = 1;
        exception
          when no_data_found then
            ld_fecpago := null;
        end;
      
        --if ld_fecpago is null then
      
        if ld_fecantC <> i.ppfpag then
          ln_contador := ln_contador + 1;
        
          ln_dias    := pq_cr_campanaverano.fn_cuotasPag(i.pgcod,
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
        end if;
      
        ld_fecantC := i.ppfpag;
        --end if;
      
      end loop;
    
    end;
  
  end Sp_CalculaCuotas;

  -----------------------------------------------------------------------------------------------
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number is
    ln_dias number(10);
  begin
  
    begin
    
      select (a.pp1fech - a.ppfpag)
        into ln_dias
        from /*bantprod.*/ fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.d602co = 'S'
         and a.pp1stat = 'T'
         and rownum = 1;
    
    exception
      when no_data_found then
        ln_dias := pd_fecpro - pd_fec;
      When others then
        null;
      
    end;
    if ln_dias < 0 then
      ln_dias := 0;
    end if;
  
    return ln_dias;
  
  end Fn_CuotasPag;
  ---------------------------------------------------------------------
  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               lc_tiper_FN in char) return number is
  
    CodSbs    char(10);
    LN_CALIF0 number(5, 2);
    LN_CALIF1 number(5, 2);
    LN_CALIF2 number(5, 2);
    LN_CALIF3 number(5, 2);
    LN_CALIF4 number(5, 2);
    pn_cal    number(10, 5);
  
  begin
  
    pn_cal := 100.00;
    begin
    
      case
        when lc_tiper_FN = 'F' then
          begin
            select c_CodSbs,
                   N_CALIF0,
                   N_CALIF1,
                   N_CALIF2,
                   N_CALIF3,
                   N_CALIF4
              into CodSbs,
                   LN_CALIF0,
                   LN_CALIF1,
                   LN_CALIF2,
                   LN_CALIF3,
                   LN_CALIF4
              from cldrcci a
             where D_FECPRE = pd_fecRcc
               and C_TDOCID = TipDocSbs
               and C_DOCIDE = trim(pc_ndo_FN)
               and rownum = 1;
          exception
            when no_data_found then
              CodSbs    := null;
              LN_CALIF0 := null;
              LN_CALIF1 := null;
              LN_CALIF2 := null;
              LN_CALIF3 := null;
              LN_CALIF4 := null;
          end;
        
          If LN_CALIF0 = 100.00 or CodSbs is null then
            pn_cal := 100.00;
          Else
            If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
              pn_cal := 100.00;
            Else
              pn_cal := 0.00;
            
            End If;
          End If;
        when lc_tiper_FN = 'J' then
          begin
            select c_CodSbs,
                   N_CALIF0,
                   N_CALIF1,
                   N_CALIF2,
                   N_CALIF3,
                   N_CALIF4
              into CodSbs,
                   LN_CALIF0,
                   LN_CALIF1,
                   LN_CALIF2,
                   LN_CALIF3,
                   LN_CALIF4
              from cldrcci a
             where D_FECPRE = pd_fecRcc
               and C_TDOCTR = TipDocSbs
               and C_DOCTRI = trim(pc_ndo_FN)
               and rownum = 1;
          exception
            when no_data_found then
              CodSbs    := null;
              LN_CALIF0 := null;
              LN_CALIF1 := null;
              LN_CALIF2 := null;
              LN_CALIF3 := null;
              LN_CALIF4 := null;
          end;
          If LN_CALIF0 = 100.00 or CodSbs is null then
            pn_cal := 100.00;
          Else
            If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
              pn_cal := 100.00;
            Else
              pn_cal := 0.00;
            
            End If;
          End If;
        else
          null;
        
      end case;
    
    end;
    return pn_cal;
  end Fn_calificacion_RCC;
  -----------------------------------------------------------------------------------
  Procedure Sp_EsParalelo(pn_pai in number,
                          pn_tdo in number,
                          pc_ndo in char,
                          pc_flg out varchar2) is
  
  begin
  
    pc_flg := 'N';
  
    begin
      select 'S'
        into pc_flg
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.cttfir = 'T'
         and a.ctnro = b.aocta
         and b.aomod = 105
         and b.aostat <> 99
				 and b.pgcod = 1
         and rownum = 1;
    exception
      when others then
        pc_flg := 'N';
    end;
  
  end Sp_EsParalelo;
---------------------------------------------------------------
 Procedure pq_cr_Sp_AmplCapPag(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_fecpro in date,
                                pc_flag   out varchar2) is
  
    ln_saldo  number(17, 2);
    ln_capag  number(17, 2);
    ln_50     number(17, 2);
    ln_prctje number(17, 2);
  begin
  
    --monto aprobado
    begin
      select a.xwfmonto1
        into ln_saldo
        from xwf700 a, xwf070 b
       where a.xwfempresa = pn_emp
         and a.xwfsucursal = pn_suc
         and a.xwfmodulo = pn_mod
         and a.xwfmoneda = pn_mda
         and a.xwfpapel = pn_pap
         and a.xwfcuenta = pn_cta
         and a.xwfoperacion = pn_ope
         and a.xwfsubope = pn_sbo
         and a.xwftipope = pn_top
         and a.xwfcar3 = '1'
         and a.xwfprcins = b.xwfprcin
         and b.xwfcont = 'S';
    
    exception
      when no_data_found then
        ln_saldo := null;
      when too_many_rows then
        begin
          select a.xwfmonto1
            into ln_saldo
            from xwf700 a, xwf070 b
           where a.xwfempresa = pn_emp
             and a.xwfsucursal = pn_suc
             and a.xwfmodulo = pn_mod
             and a.xwfmoneda = pn_mda
             and a.xwfpapel = pn_pap
             and a.xwfcuenta = pn_cta
             and a.xwfoperacion = pn_ope
             and a.xwfsubope = pn_sbo
             and a.xwftipope = pn_top
             and a.xwfcar3 = '1'
             and a.xwfprcins = b.xwfprcin
             and b.xwfcont = 'S'
             and rownum = 1;
        
        exception
          when no_data_found then
            ln_saldo := null;
          when others then
            null;
          
        end;
      when others then
        null;
    end;
  
    --% de capital
    begin
      select tp1nro1 -- porcentaje 30 porciento.
        into ln_prctje
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11005
         and a.tp1corr1 = 2
         and a.tp1corr2 = 6
         and a.tp1corr3 = 1;
    end;
    ln_50 := ln_saldo * (ln_prctje / 100);
  
    --capital pagado
    begin
      select sum(a.pp1cap)
        into ln_capag
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
            -- and a.pp1stat = 'T'
         and a.pp1stat in ('T', 'P')
         and a.d602co = 'S'
         and a.ppfpag <= pd_fecpro;
    
    exception
      when no_data_found then
        ln_capag := 0;
      when too_many_rows then
        begin
          select sum(a.pp1cap)
            into ln_capag
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
                -- and a.pp1stat = 'T'
             and a.pp1stat in ('T', 'P')
             and a.d602co = 'S'
             and a.ppfpag <= pd_fecpro;
        
        exception
          when no_data_found then
            ln_capag := 0;
          when others then
            null;
          
        end;
      when others then
        null;
    end;
  
    if ln_capag > ln_50 then
      pc_flag := 'S';
    else
      pc_flag := 'N';
    end if;
  
  end pq_cr_Sp_AmplCapPag;
  --------------------------------------------------------------------
  procedure sp_ncrd_bgarantia(pn_pai  in number,
                              pn_tdo  in number,
                              pc_ndo  in char,
                              pn_cont out number) is
  
    cursor inst_vuelo is
      select g1.sng001inst instancia
        from sng001 g1
       inner join wfwrkitems wf on wf.wfinsprcid = g1.sng001inst
                               and wf.wfitemstsact = 1
      -- and wf.wftaskcod in (11,55)
       where sng001pais = pn_pai
         and sng001tdoc = pn_tdo
         and sng001ndoc = pc_ndo;
    --and sng001inst<>2498305;
  
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
         and a.cttfir = 'T'
         and a.ctnro = b.aocta
         and b.aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (108, 141, 106, 107))
         and b.aostat <> 99
				 and b.pgcod=1;
  
    --lc_flagPri char(1);
    --lc_flagLiq char(1);
    lc_flag    char(1);
    lc_flgHipo char(1);
    --variable temporales para los de vuelo.
    v_pgcod  number(3);
    v_aosuc  number(3);
    v_aomod  number(3);
    v_aomda  number(3);
    v_aopap  number(3);
    v_aocta  number(9);
    v_aooper number(9);
    v_aosbop number(3);
    v_aotope number(3);
    v_aoimp  number(17, 2);
    --pn_cont number;
    lc_amplia char(1);
  
  begin
    pn_cont := 0;
    for i in creditos loop
    
      --dbms_output.put_line('cta '||i.aocta||' oper '||i.aooper);
    
      lc_flgHipo := 'N';
      if i.aomod = 110 then
        begin
          select 'S'
            into lc_flgHipo
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11005
             and a.tp1corr1 = 2
             and a.tp1corr2 = 5
             and a.tp1nro1 <> i.aotope;
        exception
          when others then
            lc_flgHipo := 'N';
        end;
      
      end if;
      -- PARA VERIFICAR GARANTIAS REALES Y AUTOLIQUIDABLES.
    
      if lc_flgHipo = 'N' then
        begin
          select /*'S',*/
           'S'
            into /*lc_flagPri,*/ lc_flag
            from fsr011 a
           where a.r1cod = i.pgcod
             and a.r1suc = i.aosuc
             and a.r1mod = i.aomod
             and a.r1mda = i.aomda
             and a.r1pap = i.aopap
             and a.r1cta = i.aocta
             and a.r1oper = i.aooper
             and a.r1sbop = i.aosbop
             and a.r1tope = i.aotope
             and a.relcod = 50
             and a.r2tope not in (select tp1nro1
                                    from fst198 a
                                   where a.tp1cod = 1
                                     and a.tp1cod1 = 11005
                                     and a.tp1corr1 = 2
                                     and a.tp1corr2 = 7
                                     and a.tp1corr3 > 1)
             and rownum = 1;
        exception
          when others then
            --lc_flagPri := 'N';
            lc_flag := 'N';
        end;
        --dbms_output.put_line('verifico si tiene garantia real y autoliquidable si es s se suma');    
        --dbms_output.put_line('lc_flag '||lc_flag);
        if lc_flag = 'S' then
          pn_cont := pn_cont + 1;
          -- dbms_output.put_line('cta '||i.aocta||' oper '||i.aooper|| ' cont1 '||pn_cont);
        end if;
      end if;
    end loop;
    ---------------------------------
    --PARA AGREGAR CREDITOS EN VUELO
    ---------------------------------
    begin
      for i in inst_vuelo loop
      
        --  dbms_output.put_line('instancia '||i.instancia );
      
        lc_flgHipo := 'N';
        --INICIALIZAMOS LAS VARIBLES en cero.
        v_pgcod  := 0;
        v_aomod  := 0;
        v_aosuc  := 0;
        v_aomda  := 0;
        v_aopap  := 0;
        v_aocta  := 0;
        v_aooper := 0;
        v_aosbop := 0;
        v_aotope := 0;
        v_aoimp  := 0;
        begin
          select x7.xwfempresa,
                 x7.xwfmodulo,
                 x7.xwfsucursal,
                 x7.xwfmoneda,
                 x7.xwfpapel,
                 x7.xwfcuenta,
                 x7.xwfoperacion,
                 x7.xwfsubope,
                 x7.xwftipope
            into v_pgcod,
                 v_aomod,
                 v_aosuc,
                 v_aomda,
                 v_aopap,
                 v_aocta,
                 v_aooper,
                 v_aosbop,
                 v_aotope
            from xwf700 x7
          
           where x7.xwfprcins = i.instancia
             and x7.xwfmodulo in
                 (select modulo
                    from fst111
                   where dscod = 50
                     and modulo not in (108, 141, 106, 107))
             and x7.xwfcar3 = '1'
          /*   and not exists  (select 1
                                  from xwf700 x7
                                 where x7.xwfprcins = i.instancia
                                   and x7.xwfmodulo in
                                       (select modulo
                                          from fst111
                                         where dscod = 50
                                           and modulo not in (108, 141, 106, 107))
                                   and x7.xwfcar3 = 'G')*/
          ;
        exception
          when others then
            v_pgcod  := 0;
            v_aomod  := 0;
            v_aosuc  := 0;
            v_aomda  := 0;
            v_aopap  := 0;
            v_aocta  := 0;
            v_aooper := 0;
            v_aosbop := 0;
            v_aotope := 0;
            v_aoimp  := 0;
            --  dbms_output.put_line('instancia -- '||i.instancia ||' v_aomod ' ||v_aomod );            
        end;
      
        begin
          select 'S'
            into lc_amplia
            from xwf700 x7
           where x7.xwfprcins = i.instancia
             and x7.xwfmodulo in
                 (select modulo
                    from fst111
                   where dscod = 50
                     and modulo not in (108, 141, 106, 107))
             and x7.xwfcar3 in ('G', 'R','S'); --ampliacion , refinanciacion
        exception
          when others then
            lc_amplia := 'N';
        end;
      
        -- dbms_output.put_line('instancia '||i.instancia ||' lc_amplia ' ||lc_amplia|| ' lc_flgHipo' ||lc_flgHipo  );   
      
        if v_aomod = 110 then
          begin
            select 'S'
              into lc_flgHipo
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 11005
               and a.tp1corr1 = 2
               and a.tp1corr2 = 5
               and a.tp1nro1 <> v_aotope;
          exception
            when others then
              lc_flgHipo := 'N';
          end;
        
        end if;
        -- PARA VERIFICAR GARANTIAS REALES Y AUTOLIQUIDABLES.
      
        if lc_flgHipo = 'N' and lc_amplia = 'N' then
          begin
          
            select 'S'
              into lc_flag
              from sng122 a
             where a.sng122inst = i.instancia
               and a.sng122tope not in
                   (select tp1nro1
                      from fst198 a
                     where a.tp1cod = 1
                       and a.tp1cod1 = 11005
                       and a.tp1corr1 = 2
                       and a.tp1corr2 = 7
                       and a.tp1corr3 > 1)
               and rownum = 1;
          exception
            when others then
              --lc_flagPri := 'N';
              lc_flag := 'N';
          end;
        
          if lc_flag = 'S' then
            pn_cont := pn_cont + 1;
            -- dbms_output.put_line('instancia '||i.instancia ||' conta ' ||pn_cont );
          end if;
        end if;
      end loop;
    end;
  end sp_ncrd_bgarantia;


end PQ_CR_CAMPANAVERANO;
/

