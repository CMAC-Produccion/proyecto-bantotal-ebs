create or replace package pq_cr_LimitanteLinea is
  /*
  procedure sp_resultadonetolinea( ln_instancia     in number,
                                    --ln_captotcaja    in number,
                                    ln_pepais        in number,
                                    ln_petdoc        in number,
                                    lv_pendoc        in varchar2,
                                    ln_capcaja       out number,
                                    ln_resultadorcc  out number,
                                    ln_resultadoneto out number,
                                    ln_resultado     out number);*/

  --CREATE OR REPLACE TYPE cupo IS REF CURSOR

  --Procedure Sp_Procesa;

  Procedure Sp_Procesa(pn_emp       in number,
                       pn_mod       in number,
                       pn_suc       in number,
                       pn_mda       in number,
                       pn_pap       in number,
                       pn_cta       in number,
                       pn_ope       in number,
                       pn_sbo       in number,
                       pn_top       in number,
                       pn_resultado out number,
                       pc_flag      out varchar2,
                       --          ln_mtoDisTot1 out number,
                       pc_flag2_result out number);

  Procedure Sp_VerifPrinAdicional(pn_mod  in number,
                                  pn_top  in number,
                                  Pc_flag out varchar2);

  /* procedure sp_cuentas_ratio(ln_Pepais     in number,
                               ln_Petdoc     in number,
                               ln_Pendoc     in char,
                               tipocambio    in number,
                               Instancia     in number,
                               pd_fecpro     in date,
                               lc_prgm       in varchar2,
                               pn_emp        in number,
                               pn_mod        in number,
                               pn_suc        in number,
                               pn_mda        in number,
                               pn_pap        in number,
                               pn_cta        in number,
                               pn_ope        in number,
                               pn_sbo        in number,
                               pn_top        in number,
                               pn_emp116     in number,
                               pn_mod116     in number,
                               pn_suc116     in number,
                               pn_mda116     in number,
                               pn_pap116     in number,
                               pn_cta116     in number,
                               pn_ope116     in number,
                               pn_sbo116     in number,
                               pn_top116     in number,
                               pn_trn        in number,
                               ln_captotcaja out number,
                               saldo_externo out number,
                               ResultNeto    out number,
                               ln_captotal   out number);
  */
  /*  procedure sp_resultadonetolinea(ln_instancia in number,
  --ln_captotcaja    in number,
  ln_pepais        in number,
  ln_petdoc        in number,
  lv_pendoc        in varchar2,
  ln_capcaja       out number,
  ln_resultadorcc  out number,
  ln_resultadoneto out number,
  ln_resultado     out number);*/

  /*      pq_cr_reporte_caplineas.sp_cuentas(ln_pepais   ,
  ln_Petdoc   ,
  lc_pendoc    ,
  tipodecambio   ,
  ln_instancia ,
  ld_fechaactual  ,
  lv_prgm        ,                                          
  ln_captotcaja ,
  saldo_externo ,
  ResultNeto    ,
  ln_captotal   );*/

  /*procedure sp_cuentas(ln_Pepais  in number,
                         ln_Petdoc  in number,
                         ln_Pendoc  in char,
                         tipocambio in number,
                         Instancia  in number,
                         pd_fecpro  in date,
                         lc_prgm    in varchar2,
                         
                         ln_captotcaja out number,
                         saldo_externo out number,
                         ResultNeto    out number,
                         ln_captotal   out number);
  */
  procedure sp_resultadonetolinea(ln_instancia in number,
                                  --ln_captotcaja    in number,
                                  ln_pepais in number,
                                  ln_petdoc in number,
                                  lv_pendoc in varchar2,
                                  
                                  ln_capcaja       out number,
                                  ln_resultadorcc  out number,
                                  ln_resultadoneto out number,
                                  ln_resultado     out number);
  procedure sp_insert_jaqy140(ln_instancia in number,
                              --ln_captotcaja    in number,
                              ln_pepais in number,
                              ln_petdoc in number,
                              lv_pendoc in varchar2,
                              -- ln_capcaja       out number,
                              ln_resultadorcc  in number,
                              ln_resultadoneto in number,
                              ln_resultado     in number);

  procedure sp_validar_segmento_linea(P_N_PAIS    in number,
                                      p_n_tipdoc  in number,
                                      p_c_numdoc  in VARCHAR2,
                                      pn_retornar out NUMBER);
  procedure sp_segmento_cliente(pn_ins                 in number,
                                lc_segmentacion out varchar);
end pq_cr_LimitanteLinea;
/

create or replace package body pq_cr_LimitanteLinea is
  -- Author  : RMOGROVEJO
  -- Created : 26/10/2017 13:30:20
  -- Purpose : 
  Procedure Sp_Procesa(pn_emp       in number,
                       pn_mod       in number,
                       pn_suc       in number,
                       pn_mda       in number,
                       pn_pap       in number,
                       pn_cta       in number,
                       pn_ope       in number,
                       pn_sbo       in number,
                       pn_top       in number,
                       pn_resultado out number,
                       pc_flag      out varchar2,
                       --       ln_mtoDisTot1 out number,
                       pc_flag2_result out number) is
  
    cursor cupo is
    
      select *
        from jaqz505
       where jaqz505mod = pn_mod
         and jaqz505cta = pn_cta
         and jaqz505ope = pn_ope;
  
    /* select jaqz505emp,jaqz505mod,jaqz505suc,jaqz505mda,jaqz505pap,jaqz505cta,jaqz505ope,jaqz505sbo,jaqz505top,jaqz505lto,jaqz505ldi
    into 
    jaqz505emp,
    jaqz505mod,
    jaqz505suc,
    jaqz505mda,
    jaqz505pap,
    jaqz505cta,
    jaqz505ope,
    jaqz505sbo,
    jaqz505top,
    jaqz505lto,
    prueba
      from jaqz505
     where jaqz505mod = pn_mod
       and jaqz505cta = pn_cta
       and jaqz505ope = pn_ope;*/
  
    cursor linea(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number, pn_pap in number, pn_cta in number, pn_ope in number, pn_sbo in number, pn_top in number) is
    
      select a.r1cod,
             a.r1mod,
             a.r1suc,
             a.r1mda,
             a.r1pap,
             a.r1cta,
             a.r1oper,
             a.r1sbop,
             a.r1tope
        from fsr011 a
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top;
  
    ln_mtoUtTot  number(18, 2);
    ln_mtoUt     number(18, 2);
    ln_mtoDisTot number(18, 2);
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    ln_dis       number(9);
    ln_provin    number(5);
    ln_dpto      number(5);
    pc_flag1     varchar2(1);
    -- ln_contar number;
  
  begin
    begin
      --- ln_contar :=0;
      for i in cupo loop
        ln_mtoUtTot := 0;
        ln_dis      := null;
        ln_provin   := null;
        ln_dpto     := null;
        for j in linea(i.jaqz505emp,
                       i.jaqz505mod,
                       i.jaqz505suc,
                       i.jaqz505mda,
                       i.jaqz505pap,
                       i.jaqz505cta,
                       i.jaqz505ope,
                       i.jaqz505sbo,
                       i.jaqz505top) loop
        
          begin
            --    ln_contar:=1;
            select sum(-b.scsdo)
              into ln_mtoUt
              from fsd011 b
             where b.pgcod = j.r1cod
               and b.scmod = j.r1mod
               and b.scsuc = j.r1suc
               and b.scmda = j.r1mda
               and b.scpap = j.r1pap
               and b.sccta = j.r1cta
               and b.scoper = j.r1oper
               and b.scsbop = j.r1sbop
               and b.sctope = j.r1tope
               and b.scstat = 0;
          exception
            when others then
              ln_mtoUt := 0;
          end;
        
          ln_mtoUtTot  := ln_mtoUtTot + nvl(ln_mtoUt, 0);
          pn_resultado := ln_mtoUtTot;
        
          ------rms
          begin
            -- Call the procedure
            pq_cr_limitantelinea.sp_verifprinadicional(pn_mod  => pn_mod,
                                                       pn_top  => pn_top,
                                                       pc_flag => pc_flag);
          end;
        
          if pc_flag = 'S' then
          
            pc_flag2_result := i.jaqz505lto - pn_resultado; --agregado
          
          else
            if pc_flag = 'N' and pn_resultado is not null then
            
              pc_flag2_result := i.jaqz505lto - pn_resultado;
            
            else
              pc_flag2_result := 0;
            end if;
          end if;
        
        ---------------------------rms-----------------------------
        end loop;
      
        ln_mtoDisTot := i.jaqz505lto - ln_mtoUtTot;
        --ln_mtoDisTot1:= ln_mtoDisTot;
      
        --rmogrovejo 30112017
        pc_flag2_result := ln_mtoDisTot;
        --+--------
      
      end loop;
    
      commit;
    end;
  
  end Sp_Procesa;

  Procedure Sp_VerifPrinAdicional(pn_mod  in number,
                                  pn_top  in number,
                                  Pc_flag out varchar2) is --mod 2016.04.12
  
  begin
    if pn_mod = 117 then
      begin
        select 'S'
          into Pc_flag
          from fst198 a
         where a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;
      
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_VerifPrinAdicional;
  ---------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------

  procedure sp_resultadonetolinea(ln_instancia in number,
                                  --ln_captotcaja    in number,
                                  ln_pepais in number,
                                  ln_petdoc in number,
                                  lv_pendoc in varchar2,
                                  
                                  ln_capcaja       out number,
                                  ln_resultadorcc  out number,
                                  ln_resultadoneto out number,
                                  ln_resultado     out number) is
  
    ln_codeva      number(10, 0);
    lc_pendoc      char(12);
    ld_fecha       date;
    ld_fechaactual date;
    -- ld_fechalimite        date;
    sng023montosoles      number(17, 2);
    sng023montodolares    number(17, 2);
    sng023montorccsoles   number(17, 2);
    sng023montorccdolares number(17, 2);
    tipodecambio          number(17, 2);
    --  ln_resultadoneto         number(17, 2);
    --  ln_resultadorcc          number(17, 2);
    ln_numerador             number(17, 2);
    ln_denominador           number(17, 2);
    ln_contar                number(17);
    ln_contarelse            number(17);
    ln_contarsng021          number(17);
    jaqz515instancia         number(10);
    jaqz516evapis            number(10);
    ln_resultrccdolareselse  number(17, 2);
    ln_resultrccsoleselse    number(17, 2);
    ln_resultnetosoleselse   number(17, 2);
    ln_resultnetodolareselse number(17, 2);
    ln_numeradorelse         number(17, 2);
    ln_denominadorelse       number(17, 2);
    ln_resultadonetoelse     number(17, 2);
    ln_resultadorccelse      number(17, 2);
    jaqz515fecha             date;
    ln_captotcaja            number;
    ld_fechaactualmenosundia date;
    lv_prgm                  varchar2(8);
    saldo_externo            number;
    ResultNeto               number;
    ln_captotal              number;
    sng023montorcc2soles     number(17, 2);
    sng023montorcc2dolares   number(17, 2);
    ln_resultrcc2soleselse   number(17, 2);
    ln_resultrcc2dolareselse number(17, 2);
  Begin
    lc_pendoc       := RPAD(trim(lv_pendoc), 12, ' ');
    ln_contar       := 0;
    ln_contarelse   := 0;
    tipodecambio    := 0;
    ln_resultado    := 0;
    ln_contarsng021 := 0;
    lv_prgm         := 'RODRIGO'; --quitar y poner cualquier name 
    Begin
    
      begin
        select pgfape
          into ld_fechaactual
          from fst017
         where fst017.pgcod = 1;
      
      end;
    
      /* begin
        select j.jaqy140capcaja
          into ln_captotcaja
          from jaqy140 j
         where j.jaqy140inst = ln_instancia 
         and j.jaqy140pais = ln_pepais
           and j.jaqy140tdoc = ln_petdoc
           and j.jaqy140ndoc = lv_pendoc
           and j.jaqy140est = 'L';
      exception
        when others then
          ln_captotcaja := 0;
      end;*/
    
      ln_capcaja := ln_captotcaja;
      --   ld_fechalimite           := ADD_MONTHS(ld_fechaactual, -18);
      ld_fechaactualmenosundia := ld_fechaactual - 1;
      begin
        select count(cotcbi)
          into ln_contar
          from (select cotcbi
                  from fsh005
                 where cofdes <= ld_fechaactualmenosundia
                   and moneda = 101
                   and cotcbi > 0
                 order by cofdes desc)
         where rownum = 1;
      
      end;
      /* select count(SNG120TCbi) into ln_contar from sng120
      where SNG120Ins = ln_instancia
      and SNG120Tsk  ='EVALUACION';*/
      if ln_contar <> 0 then
      
        begin
          select cotcbi
            into tipodecambio
            from (select cotcbi
                    from fsh005
                   where cofdes <= ld_fechaactualmenosundia
                     and moneda = 101
                     and cotcbi > 0
                   order by cofdes desc)
           where rownum = 1;
        
        end;
      
      end if;
      begin
      
        pq_cr_reporte_caplineas.sp_cuentas(ln_pepais,
                                           ln_Petdoc,
                                           lc_pendoc,
                                           tipodecambio,
                                           ln_instancia,
                                           ld_fechaactual,
                                           lv_prgm,
                                           
                                           ln_captotcaja,
                                           saldo_externo,
                                           ResultNeto,
                                           ln_captotal);
      
      end;
      ----------------------------------------------------------------------------
      ln_capcaja := ln_captotcaja;
      begin
        select count(*)
          into ln_contarsng021
          from sng021 a
         inner join xwf070 x on a.sng021sol = x.xwfprcin
         where x.xwfcont = 'S'
           and a.sng021pdoc = ln_pepais ---604
           and a.sng021tdoc = ln_petdoc --- 21
           and a.sng021ndoc = lc_pendoc --- '40969090'
           and a.sng021fec =
               (select max(a.sng021fec)
                  from sng021 a
                 inner join xwf070 x on a.sng021sol = x.xwfprcin
                 where x.xwfcont = 'S'
                   and a.sng021pdoc = ln_pepais ---604
                   and a.sng021tdoc = ln_petdoc --- 21
                   and a.sng021ndoc = lc_pendoc --- '40969090' 
                
                );
        /*select count(*)
         into ln_contarsng021
         from sng021 a
        where a.sng021pdoc = ln_pepais ---604
          and a.sng021tdoc = ln_petdoc --- 21
          and a.sng021ndoc = lc_pendoc --- '40969090'
          and a.sng021fec =
              (select max(d.sng021fec)
                 from sng021 d
                where d.sng021pdoc = ln_pepais
                  and d.sng021tdoc = ln_petdoc
                  and d.sng021ndoc = lc_pendoc);*/
      end;
    
      if ln_contarsng021 > 0 then
      
        begin
        
          select a.sng021eval, a.sng021fec
            into ln_codeva, ld_fecha
            from sng021 a
           inner join xwf070 x on a.sng021sol = x.xwfprcin
           where x.xwfcont = 'S'
             and a.sng021pdoc = ln_pepais ---604
             and a.sng021tdoc = ln_petdoc --- 21
             and a.sng021ndoc = lc_pendoc --- '40969090'
             and a.sng021fec =
                 (select max(a.sng021fec)
                    from sng021 a
                   inner join xwf070 x on a.sng021sol = x.xwfprcin
                   where x.xwfcont = 'S'
                     and a.sng021pdoc = ln_pepais ---604
                     and a.sng021tdoc = ln_petdoc --- 21
                     and a.sng021ndoc = lc_pendoc --- '40969090' 
                  
                  )
             AND rownum = 1;
        
          /*
            select a.sng021eval, a.sng021fec
              into ln_codeva, ld_fecha
              from sng021 a
             where a.sng021pdoc = ln_pepais ---604
               and a.sng021tdoc = ln_petdoc --- 21
               and a.sng021ndoc = lc_pendoc --- '40969090'
               and a.sng021fec =
                   (select max(d.sng021fec)
                      from sng021 d
                     where d.sng021pdoc = ln_pepais
                       and d.sng021tdoc = ln_petdoc
                       and d.sng021ndoc = lc_pendoc)
               AND rownum = 1;
          */
        end;
      
      end if;
    
      begin
        select count(*)
          into ln_contarelse
          from jaqz515
         inner join xwf070 x on jaqz515.jaqz515ins = x.xwfprcin
         where x.xwfcont = 'S'
           and jaqz515.jaqz515pai = ln_pepais
           and jaqz515.jaqz515tdo = ln_petdoc
           and jaqz515.jaqz515ndo = lc_pendoc
           and jaqz515.jaqz515fee =
               (select max(jaqz515.jaqz515fee)
                  from jaqz515
                 inner join xwf070 x on jaqz515.jaqz515ins = x.xwfprcin
                 where x.xwfcont = 'S'
                   and jaqz515.jaqz515pai = ln_pepais
                   and jaqz515.jaqz515tdo = ln_petdoc
                   and jaqz515.jaqz515ndo = lc_pendoc)
           AND rownum = 1;
        /*select count(*)
         into ln_contarelse
         from jaqz515
        where jaqz515.jaqz515pai = ln_pepais
          and jaqz515.jaqz515tdo = ln_petdoc
          and jaqz515.jaqz515ndo = lc_pendoc
          and jaqz515.jaqz515fee =
              (select max(jaqz515.jaqz515fee)
                 from jaqz515
                where jaqz515.jaqz515pai = ln_pepais
                  and jaqz515.jaqz515tdo = ln_petdoc
                  and jaqz515.jaqz515ndo = lc_pendoc);*/
      end;
    
      if ln_contarelse > 0 then
      
        begin
          select jaqz515.jaqz515ins, jaqz515.jaqz515fee
            into jaqz515instancia, jaqz515fecha
            from jaqz515
           inner join xwf070 x on jaqz515.jaqz515ins = x.xwfprcin
           where x.xwfcont = 'S'
             and jaqz515.jaqz515pai = ln_pepais
             and jaqz515.jaqz515tdo = ln_petdoc
             and jaqz515.jaqz515ndo = lc_pendoc
             and jaqz515.jaqz515fee =
                 (select max(jaqz515.jaqz515fee)
                    from jaqz515
                   inner join xwf070 x on jaqz515.jaqz515ins = x.xwfprcin
                   where x.xwfcont = 'S'
                     and jaqz515.jaqz515pai = ln_pepais
                     and jaqz515.jaqz515tdo = ln_petdoc
                     and jaqz515.jaqz515ndo = lc_pendoc)
             AND rownum = 1;
        
          /* select jaqz515.jaqz515ins, jaqz515.jaqz515fee
              into jaqz515instancia, jaqz515fecha
              from jaqz515
             where jaqz515.jaqz515pai = ln_pepais
               and jaqz515.jaqz515tdo = ln_petdoc
               and jaqz515.jaqz515ndo = lc_pendoc
               and jaqz515.jaqz515fee =
                   (select max(jaqz515.jaqz515fee)
                      from jaqz515
                     where jaqz515.jaqz515pai = ln_pepais
                       and jaqz515.jaqz515tdo = ln_petdoc
                       and jaqz515.jaqz515ndo = lc_pendoc)
               AND rownum = 1;
          */
        end;
      end if;
      -----------------------------------------------------------------------------
      if ln_contarelse > 0 and ln_contarsng021 > 0 then
        if ld_fecha > jaqz515fecha then
          --     if ld_fechalimite <= ld_fecha and ld_fecha <= ld_fechaactual then
          ----resultados
          begin
            select sng023Mto
              into sng023montosoles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 40;
          exception
            when others then
              null;
              sng023montosoles := 0;
          end;
          begin
            select sng023Mto
              into sng023montodolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 540;
          exception
            when others then
              null;
              sng023montodolares := 0;
          end;
          ----rcc
          begin
            select sng023Mto
              into sng023montorccsoles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 19;
          exception
            when others then
              null;
              sng023montorccsoles := 0;
          end;
          begin
            select sng023Mto
              into sng023montorccdolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 519;
          exception
            when others then
              null;
              sng023montorccdolares := 0;
          end;
          -- rcc caso2
          begin
            select sng023Mto
              into sng023montorcc2soles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 79;
          exception
            when others then
              null;
              sng023montorcc2soles := 0;
          end;
          begin
            select sng023Mto
              into sng023montorcc2dolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 579;
          exception
            when others then
              null;
              sng023montorcc2dolares := 0;
          end;
          --
        
          ln_resultadoneto := (sng023montosoles +
                              (sng023montodolares * tipodecambio));
        
          ln_resultadoneto := nvl(ln_resultadoneto, 0);
        
          ln_resultadorcc := ((sng023montorccsoles + sng023montorcc2soles) +
                             ((sng023montorccdolares +
                             sng023montorcc2dolares) * tipodecambio));
        
          ln_resultadorcc := nvl(ln_resultadorcc, 0);
        
          ln_numerador   := (ln_captotcaja + ln_resultadorcc);
          ln_denominador := (ln_resultadoneto + ln_resultadorcc);
        
          if ln_denominador <> 0 then
            ln_resultado := ln_numerador / ln_denominador;
          else
            ln_resultado := 0;
          end if;
          --end if;
        else
        
          /* select jaqz515.jaqz515ins,jaqz515.jaqz515fee into jaqz515instancia,jaqz515fecha from jaqz515 
          where jaqz515.jaqz515pai=ln_pepais
                and jaqz515.jaqz515tdo=ln_petdoc
                and jaqz515.jaqz515ndo=lc_pendoc 
                and jaqz515.jaqz515fee=( select max(jaqz515.jaqz515fee) from jaqz515
                                                where jaqz515.jaqz515pai=ln_pepais 
                                                and jaqz515.jaqz515tdo=ln_petdoc 
                                                and jaqz515.jaqz515ndo=lc_pendoc);*/
        
          /*  select count(SNG120TCbi) into ln_contar from sng120
                        where SNG120Ins = jaqz515instancia
                        and SNG120Tsk  ='EVALUACION';
          if ln_contar<>0 then 
                    select SNG120TCbi into tipodecambio from sng120
                        where SNG120Ins = jaqz515instancia
                        and SNG120Tsk  ='EVALUACION';
            end if ; */
        
          /*     if ld_fechalimite <= jaqz515fecha and
          jaqz515fecha <= ld_fechaactual then*/
          begin
            select jaqz516.jaqz516eval
              INTO jaqz516evapis
              from jaqz516
             WHERE jaqz516.jaqz516sol = jaqz515instancia;
          exception
            when others then
              null;
              jaqz516evapis := 0;
          end;
          ---Resultado Neto
          begin
            select jaqz517.jaqz517mto
              into ln_resultnetosoleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 40;
          exception
            when others then
              null;
              ln_resultnetosoleselse := 0;
          end;
          begin
            select jaqz517.jaqz517mto
              into ln_resultnetodolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 540;
          exception
            when others then
              null;
              ln_resultnetodolareselse := 0;
          end;
        
          ---RCC
          begin
            select nvl(jaqz517.jaqz517mto, 0)
              into ln_resultrccsoleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 19;
          exception
            when others then
              null;
              ln_resultrccsoleselse := 0;
          end;
          begin
            select nvl(jaqz517.jaqz517mto, 0)
              into ln_resultrccdolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 519;
          exception
            when others then
              null;
              ln_resultrccdolareselse := 0;
          end;
          --RCC2  
          begin
            select nvl(jaqz517.jaqz517mto, 0)
              into ln_resultrcc2soleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 79;
          exception
            when others then
              null;
              ln_resultrcc2soleselse := 0;
          end;
          begin
            select nvl(jaqz517.jaqz517mto, 0)
              into ln_resultrcc2dolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 579;
          exception
            when others then
              null;
              ln_resultrcc2dolareselse := 0;
          end;
        
          ln_resultadonetoelse := (ln_resultnetosoleselse +
                                  (ln_resultnetodolareselse * tipodecambio)); --ojisto el tipo de cambio
        
          ln_resultadoneto    := nvl(ln_resultadonetoelse, 0);
          ln_resultadorccelse := ((ln_resultrccsoleselse +
                                 ln_resultrcc2soleselse) +
                                 ((ln_resultrccdolareselse +
                                 ln_resultrcc2dolareselse) * tipodecambio)); --ojisto el tipo de cambio
        
          ln_resultadorcc := nvl(ln_resultadorccelse, 0);
        
          ln_numeradorelse   := (ln_captotcaja + ln_resultadorccelse);
          ln_denominadorelse := (ln_resultadonetoelse + ln_resultadorccelse);
          if ln_denominadorelse <> 0 then
            ln_resultado := ln_numeradorelse / ln_denominadorelse;
          else
            ln_resultado := 0;
          end if;
          --   end if;
        
        end if;
      else
        if ln_contarsng021 > 0 then
          --    if ld_fechalimite <= ld_fecha and ld_fecha <= ld_fechaactual then 
          ----resultados
          Begin
            select sng023Mto
              into sng023montosoles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 40;
          exception
            when others then
              null;
              sng023montosoles := 0;
          end;
          begin
            select sng023Mto
              into sng023montodolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 540;
          exception
            when others then
              null;
              sng023montodolares := 0;
          end;
          ----rcc
          begin
            select sng023Mto
              into sng023montorccsoles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 19;
          exception
            when others then
              null;
              sng023montorccsoles := 0;
          end;
          begin
            select sng023Mto
              into sng023montorccdolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 519;
          exception
            when others then
              null;
              sng023montorccdolares := 0;
          end;
          ---rcc2
          begin
            select sng023Mto
              into sng023montorcc2soles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 79;
          exception
            when others then
              null;
              sng023montorccsoles := 0;
          end;
          begin
            select sng023Mto
              into sng023montorcc2dolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 579;
          exception
            when others then
              null;
              sng023montorccdolares := 0;
          end;
        
          ln_resultadoneto := (sng023montosoles +
                              (sng023montodolares * tipodecambio));
        
          ln_resultadorcc := ((sng023montorccsoles + sng023montorcc2soles) +
                             ((sng023montorccdolares +
                             sng023montorcc2dolares) * tipodecambio));
        
          ln_numerador   := (ln_captotcaja + ln_resultadorcc);
          ln_denominador := (ln_resultadoneto + ln_resultadorcc);
        
          if ln_denominador <> 0 then
            ln_resultado := ln_numerador / ln_denominador;
          else
            ln_resultado := 0;
          end if;
          --end if;
        else
          /*   if ld_fechalimite <= jaqz515fecha and 
          jaqz515fecha <= ld_fechaactual then*/
          begin
            select jaqz516.jaqz516eval
              INTO jaqz516evapis
              from jaqz516
             WHERE jaqz516.jaqz516sol = jaqz515instancia;
          exception
            when others then
              null;
              jaqz516evapis := 0;
          end;
          ---Resultado Neto
          begin
            select jaqz517.jaqz517mto
              into ln_resultnetosoleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 40;
          exception
            when others then
              null;
              ln_resultnetosoleselse := 0;
          end;
          begin
            select jaqz517.jaqz517mto
              into ln_resultnetodolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 540;
          exception
            when others then
              null;
              ln_resultnetodolareselse := 0;
          end;
          ---RCC
          begin
            select jaqz517.jaqz517mto
              into ln_resultrccsoleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 19;
          exception
            when others then
              null;
              ln_resultrccsoleselse := 0;
          end;
          begin
            select jaqz517.jaqz517mto
              into ln_resultrccdolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 519;
          exception
            when others then
              null;
              ln_resultrccdolareselse := 0;
          end;
          --rcc2
          begin
            select jaqz517.jaqz517mto
              into ln_resultrcc2soleselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 79;
          exception
            when others then
              null;
              ln_resultrcc2soleselse := 0;
          end;
          begin
            select jaqz517.jaqz517mto
              into ln_resultrcc2dolareselse
              from jaqz517
             where jaqz517.jaqz517eval = jaqz516evapis
               and jaqz517.jaqz517cod = 579;
          exception
            when others then
              null;
              ln_resultrcc2dolareselse := 0;
          end;
        
          ln_resultadoneto   := (ln_resultnetosoleselse +
                                (ln_resultnetodolareselse * tipodecambio)); --ojisto el tipo de cambio
          ln_resultadorcc    := ((ln_resultrccsoleselse +
                                ln_resultrcc2soleselse) +
                                ((ln_resultrccdolareselse +
                                ln_resultrcc2dolareselse) * tipodecambio)); --ojisto el tipo de cambio
          ln_numeradorelse   := (ln_captotcaja + ln_resultadorcc);
          ln_denominadorelse := (ln_resultadoneto + ln_resultadorcc);
          if ln_denominadorelse <> 0 then
            ln_resultado := ln_numeradorelse / ln_denominadorelse;
          else
            ln_resultado := 0;
          end if;
          --end if;
        
        end if;
      
      end if;
      ----------------------------------------------------------------------------                                         
    
      /*else
       
           select count(*) into ln_contarelse from jaqz515 
          where jaqz515.jaqz515pai=ln_pepais
                and jaqz515.jaqz515tdo=ln_petdoc
                and jaqz515.jaqz515ndo=lc_pendoc 
                and jaqz515.jaqz515fee=( select max(jaqz515.jaqz515fee) from jaqz515
                                                where jaqz515.jaqz515pai=ln_pepais 
                                                and jaqz515.jaqz515tdo=ln_petdoc 
                                                and jaqz515.jaqz515ndo=lc_pendoc);
         
       
      end if;*/
    
      pq_cr_limitantelinea.sp_insert_jaqy140(ln_instancia     => ln_instancia,
                                             ln_pepais        => ln_pepais,
                                             ln_petdoc        => ln_petdoc,
                                             lv_pendoc        => lv_pendoc,
                                             ln_resultadorcc  => ln_resultadorcc,
                                             ln_resultadoneto => ln_resultadoneto,
                                             ln_resultado     => ln_resultado);
    
    End;
  End sp_resultadonetolinea;

  procedure sp_insert_jaqy140(ln_instancia in number,
                              --ln_captotcaja    in number,
                              ln_pepais in number,
                              ln_petdoc in number,
                              lv_pendoc in varchar2,
                              -- ln_capcaja       out number,
                              ln_resultadorcc  in number,
                              ln_resultadoneto in number,
                              ln_resultado     in number) is
    lc_pendoc char(12);
  Begin
  
    lc_pendoc := RPAD(trim(lv_pendoc), 12, ' ');
    begin
      update jaqy140
         set jaqy140.jaqy140sldext = ln_resultadorcc,
             jaqy140.jaqy140resnet = ln_resultadoneto,
             jaqy140.jaqy140ratio  = ln_resultado
       where jaqy140.jaqy140inst = ln_instancia
         and jaqy140.jaqy140pais = ln_pepais
         and jaqy140.jaqy140tdoc = ln_petdoc
         and jaqy140.jaqy140ndoc = lc_pendoc
         and jaqy140.jaqy140est = 'L';
      commit;
    end;
  
  End sp_insert_jaqy140;

  procedure sp_validar_segmento_linea(P_N_PAIS    in number,
                                      p_n_tipdoc  in number,
                                      p_c_numdoc  in VARCHAR2,
                                      pn_retornar out NUMBER) is
    lc_pendoc   char(12);
    ln_SegLinea number(5);
  begin
    ln_SegLinea := 0;
    lc_pendoc   := RPAD(trim(p_c_numdoc), 12, ' ');
    begin
      select b.segcod
        into ln_SegLinea
        from sngc60 a, sngc07 b
       where a.sngc60pais = P_N_PAIS
         and a.sngc60tdoc = p_n_tipdoc
         and a.sngc60ndoc = lc_pendoc
         and a.sngc60ocup = b.sngc07cod;
    exception
      when too_many_rows then
        begin
          select b.segcod
            into ln_SegLinea
            from sngc60 a, sngc07 b
           where a.sngc60pais = P_N_PAIS
             and a.sngc60tdoc = p_n_tipdoc
             and a.sngc60ndoc = lc_pendoc
             and a.sngc60ocup = b.sngc07cod
             and a.sngc60corr =
                 (select max(a.sngc60corr)
                    from sngc60 a, sngc07 b
                   where a.sngc60pais = P_N_PAIS
                     and a.sngc60tdoc = p_n_tipdoc
                     and a.sngc60ndoc = lc_pendoc
                     and a.sngc60ocup = b.sngc07cod);
        
        end;
      when no_data_found then
        null;
    end;
    pn_retornar := ln_SegLinea;
  
  End sp_validar_segmento_linea;
  ---------------------------
  procedure sp_segmento_cliente(pn_ins                 in number,
                                lc_segmentacion out varchar) is
    lc_pendoc       char(12);
    ln_SegLinea     number(5);
    pn_pai          number(5);
    pn_tdo          number(5);
    pc_ndo          number(8);
    pd_fec          date;
   -- lc_segmentacion char(36);
  
  begin
    
    begin
      select /*n.pae70pdoc, n.pae70tdoc, n.pae70ndoc, n.pae70time,*/ pae71val
        into /*pn_pai, pn_tdo, pc_ndo, pd_fec,*/ lc_segmentacion
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 380
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select /*n.pae70pdoc,
                 n.pae70tdoc,
                 n.pae70ndoc,
                 n.pae70time,*/
                 pae71val
            into /*pn_pai, pn_tdo, pc_ndo, pd_fec, */lc_segmentacion
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 380
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 1
             and n.pae70nro =
                 (select max(pae70nro) from fpae70 where pae70ins = pn_ins)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
        lc_segmentacion := lc_segmentacion;
    end;
  
    --   pn_retornar := ln_SegLinea;
  
  End sp_segmento_cliente;

end pq_cr_LimitanteLinea;
/

