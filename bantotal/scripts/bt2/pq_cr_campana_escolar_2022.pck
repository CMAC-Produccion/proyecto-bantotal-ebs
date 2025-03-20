create or replace package pq_cr_campana_escolar_2022 is

  -- Author  : RMONTESR
  -- Created : 16/02/2022 08:45:21
  -- Purpose : Paquete para campaña escolar 2022
  -- Modified: 06/11/2023 Ray Montes
  -- DescModi: Se modifico paquete para tomar en cuenta fecha de inicio y finde campaña

  procedure sp_cr_verif_desembolso(pn_pais    in numeric,
                                   pn_tdoc    in numeric,
                                   pc_ndoc    in char,
                                   pv_rpta    out varchar2,
                                   pn_succred out number,
                                   pn_sucdes  out number,
                                   pv_ape1    out varchar2,
                                   pv_ape2    out varchar2,
                                   pv_nom1    out varchar2,
                                   pv_nom2    out varchar2 --,
                                   --pn_cta     out number,
                                   --pn_oper    out number
                                   );

end pq_cr_campana_escolar_2022;
/

create or replace package body pq_cr_campana_escolar_2022 is

  --------------------------------------------------------------------------------------------------------------------------
  procedure sp_cr_verif_desembolso(pn_pais    in numeric,
                                   pn_tdoc    in numeric,
                                   pc_ndoc    in char,
                                   pv_rpta    out varchar2,
                                   pn_succred out number,
                                   pn_sucdes  out number,
                                   pv_ape1    out varchar2,
                                   pv_ape2    out varchar2,
                                   pv_nom1    out varchar2,
                                   pv_nom2    out varchar2 --,
                                   --pn_cta     out number,
                                   --pn_oper    out number
                                   ) is
    lv_tienedes varchar2(1);
    lv_estrab   varchar2(1);
    ld_fecha    date;
    ln_mod      number;
    ln_cta      number;
    ln_oper     number;
    ln_tope     number;
    ln_moneda   number;
    ln_papel    number;
    ln_sbop     number;
    ln_r2mod    number;
    ln_r2cta    number;
    ln_r2oper   number;
    ln_r2tope   number;
    ln_r2moneda number;
    ln_r2sbop   number;
    ln_r2suc    number;
    ld_aofval   date;
    ln_ori      number;
    ln_stat     number;
    lv_razs     varchar2(70);
    FlgIncl     char(1);
    ln_insta    number;
    ln_tcred    number;
    ld_finic    date;
    ld_ffinc    date;
    lc_ftcred   char(1);
    lc_fmod     char(1);
    lc_sng122   char(1);
  begin
    begin
      select a.pgfape into ld_fecha from fst017 a where a.pgcod = 1;
    exception
      when others then
        ld_fecha := to_date('01/01/0001', 'DD/MM/YYYY');
    end;
    --ld_fecha := to_date('18/08/2021', 'DD/MM/YYYY');
    if pn_tdoc = 9 then
      begin
        select 'N', tb.pjrazs
          into lv_estrab, lv_razs
          from fsd003 tb
         where tb.pjpais = pn_pais
           and tb.pjtdoc = pn_tdoc
           and tb.pjndoc = rpad(pc_ndoc, 12)
           and rownum <= 1;
      exception
        when others then
          lv_estrab := 'N';
      end;
    else
      begin
        select tb.pfebco, tb.pfape1, tb.pfape2, tb.pfnom1, tb.pfnom2
          into lv_estrab, pv_ape1, pv_ape2, pv_nom1, pv_nom2
          from fsd002 tb
         where tb.pfpais = pn_pais
           and tb.pftdoc = pn_tdoc
           and tb.pfndoc = rpad(pc_ndoc, 12)
              --and tb.pfebco = 'S'
           and rownum <= 1;
      exception
        when others then
          lv_estrab := 'N';
      end;
    end if;
    begin
      select to_date(trim(tp1desc), 'dd/mm/yyyy')
        into ld_finic --fecha inicio campaña
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 12
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ld_finic := null;
    end;
    begin
      select to_date(trim(tp1desc), 'dd/mm/yyyy')
        into ld_ffinc --fecha fin campaña
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 12
         and tp1corr2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        ld_ffinc := null;
    end;
    lv_estrab := nvl(lv_estrab, 'N');
  
    if lv_estrab <> 'S' then
      lv_estrab := 'N';
    end if;
    if lv_estrab = 'N' then
      begin
        select 'S',
               t2.aomod,
               t2.aocta,
               t2.aooper,
               t2.aotope,
               t2.aofval,
               t3.sng001ori,
               t2.aostat,
               t2.aosuc,
               t2.aomda,
               t2.aopap,
               t2.aosbop,
               t3.sng001inst
          into lv_tienedes,
               ln_mod,
               ln_cta,
               ln_oper,
               ln_tope,
               ld_aofval,
               ln_ori,
               ln_stat,
               pn_succred,
               ln_moneda,
               ln_papel,
               ln_sbop,
               ln_insta
          from fsr008 t1
         inner join fsd010 t2
            on t2.pgcod = 1
           and t2.aocta = t1.ctnro
         inner join sng001 t3
            on t3.sng001emp = 1
           and t3.sng001cta = t1.ctnro
         where t1.pgcod = 1
           and t1.pepais = pn_pais
           and t1.petdoc = pn_tdoc
           and t1.pendoc = rpad(pc_ndoc, 12)
           and t1.cttfir = 'T'
           and (t2.aofval >= ld_finic and t2.aofval <= ld_ffinc)
           and (t2.aomod in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (29, 33, 108, 200)) or
               t2.aomod = 117)
           and t2.aotope <> 550
           and t3.sng001ori not in (3, 13, 14, 16)
           and t2.aostat <> 99
              --and (t3.sng001fin > ld_fecha - 3)
           and rownum <= 1;
      exception
        when others then
          lv_tienedes := 'N';
      end;
    else
      lv_tienedes := 'N';
    end if;
    if lv_tienedes = 'N' then
      begin
        select 'S'
          into lv_tienedes
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11105
           and tp1corr1 = 44
           and tp1corr2 = 1
           and tp1nro1 = 1
           and rpad(tp1desc, 12) = rpad(pc_ndoc, 12);
        if lv_tienedes = 'S' then
          begin
            select 'S',
                   aomod,
                   aocta,
                   aooper,
                   aotope,
                   aofval,
                   sng001ori,
                   aostat,
                   aosuc,
                   aomda,
                   aopap,
                   aosbop,
                   sng001inst
              into lv_tienedes,
                   ln_mod,
                   ln_cta,
                   ln_oper,
                   ln_tope,
                   ld_aofval,
                   ln_ori,
                   ln_stat,
                   pn_succred,
                   ln_moneda,
                   ln_papel,
                   ln_sbop,
                   ln_insta
              from (select t2.aomod,
                           t2.aocta,
                           t2.aooper,
                           t2.aotope,
                           t2.aofval,
                           t3.sng001ori,
                           t2.aostat,
                           t2.aosuc,
                           t2.aomda,
                           t2.aopap,
                           t2.aosbop,
                           t3.sng001inst
                      from fsr008 t1
                     inner join fsd010 t2
                        on t2.pgcod = 1
                       and t2.aocta = t1.ctnro
                     inner join sng001 t3
                        on t3.sng001emp = 1
                       and t3.sng001cta = t1.ctnro
                     where t1.pgcod = 1
                       and t1.pepais = pn_pais
                       and t1.petdoc = pn_tdoc
                       and t1.pendoc = rpad(pc_ndoc, 12)
                       and t1.cttfir = 'T'
                          --and (t2.aofval > ld_fecha - 3)
                       and (t2.aomod in
                           (select modulo
                               from fst111
                              where dscod = 50
                                and modulo not in (29, 33, 108, 200)) or
                           t2.aomod = 117)
                       and t2.aotope <> 550
                       and t3.sng001ori not in (3, 13, 14, 16)
                       and t2.aostat <> 99
                     order by t2.aofval desc)
             where rownum = 1;
          exception
            when others then
              lv_tienedes := 'N';
          end;
        end if;
      exception
        when others then
          lv_tienedes := 'N';
      end;
    end if;
    lv_tienedes := nvl(lv_tienedes, 'N');
    begin
      ln_insta := fn_instancia_credito(ln_mod,
                                       pn_succred,
                                       ln_moneda,
                                       ln_papel,
                                       ln_cta,
                                       ln_oper,
                                       ln_sbop,
                                       ln_tope);
    exception
      when others then
        ln_insta := 0;
    end;
    if lv_tienedes = 'S' then
      begin
        -- Tipo de Credito en el flujo      
        select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                        '([A-Z])',
                                        ''))
          into ln_tcred
          from wfattsvalues w
         where w.wfinsprcid = ln_insta
           and w.wfattsid = 'TIPO_CREDITO';
      exception
        when others then
          null;
      end;
    
      if ln_mod = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_r2mod,
                 ln_r2cta,
                 ln_r2oper,
                 ln_r2sbop,
                 ln_r2suc,
                 ln_r2moneda,
                 ln_r2tope
            from fsr011 f
           where f.r1cod = 1
             and f.r1mod = ln_mod
             and f.r1suc = pn_succred
             and f.r1mda = ln_moneda
             and f.r1pap = 0
             and f.r1cta = ln_cta
             and f.r1oper = ln_oper
             and f.r1sbop = ln_sbop
             and f.r1tope = ln_tope
             and f.relcod = 46;
        exception
          when others then
            null;
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = 1
             and a.r1mod = ln_r2mod
             and a.r1suc = ln_r2suc
             and a.r1mda = ln_r2moneda
             and a.r1pap = 0
             and a.r1cta = ln_r2cta
             and a.r1oper = ln_r2oper
             and a.r1sbop = ln_r2sbop
             and a.r1tope = ln_r2tope
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
      
        begin
          --créditos con garantía de plazo fijo o cts
        
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = 1
             and a.r1mod = ln_mod
             and a.r1suc = pn_succred
             and a.r1mda = ln_moneda
             and a.r1pap = 0
             and a.r1cta = ln_cta
             and a.r1oper = ln_oper
             and a.r1sbop = ln_sbop
             and a.r1tope = ln_tope
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
        end;
      
      end if;
      if FlgIncl = 'S' then
        lc_sng122 := 'N';
        --Verificar si es DPF o garantia CTS
        begin
          select 'S'
            into lc_sng122
            from sng122
           where sng122inst = ln_insta
             and sng122mod = 70
             and sng122tope in (80, 85)
             and rownum = 1;
        exception
          when others then
            lc_sng122 := 'N';
        end;
        if lc_sng122 = 'N' then
          pv_rpta := 'S';
          if ld_aofval = ld_fecha then
            begin
              select ta.itsuc
                into pn_sucdes
                from fsd016 ta
               where ta.pgcod = 1
                 and ta.modulo = ln_mod
                 and ta.itsucd = pn_succred
                 and ta.ittope = ln_tope
                 and ta.moneda = ln_moneda
                 and ta.papel = ln_papel
                 and ta.ctnro = ln_cta
                 and ta.itoper = ln_oper
                 and ta.itsubo = ln_sbop
                 and rownum <= 1;
            exception
              when others then
                pn_sucdes := 0;
              
            end;
          else
            begin
              select tb.hsucor
                into pn_sucdes
                from fsh016 tb
               where tb.pgcod = 1
                 and tb.hmodul = ln_mod
                 and tb.hsucur = pn_succred
                 and tb.htoper = ln_tope
                 and tb.hmda = ln_moneda
                 and tb.hpap = ln_papel
                 and tb.hcta = ln_cta
                 and tb.hoper = ln_oper
                 and tb.hsubop = ln_sbop
                 and tb.hfcon = ld_aofval
                 and rownum <= 1;
            exception
              when others then
                pn_sucdes := 0;
            end;
          end if;
        else
          pv_rpta := 'N';
        end if;
      else
        pv_rpta := 'N';
      end if;
    else
      pv_rpta := 'N';
    end if;
    --Validacion tipo de credito
    lc_ftcred := 'N';
    begin
      select 'S'
        into lc_ftcred
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 12
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = ln_tcred;
    exception
      when others then
        lc_ftcred := 'N';
    end;
    lc_fmod := 'N';
    begin
      select 'S'
        into lc_fmod
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 12
         and tp1corr2 = 3
         and tp1corr3 > 0
         and tp1nro1 = ln_mod;
    exception
      when others then
        lc_fmod := 'N';
    end;
    if lc_ftcred = 'S' or lc_fmod = 'S' then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
    /*if ln_tcred = 2 or ln_tcred = 3 or ln_tcred = 4 or ln_tcred = 11 or
       ln_tcred = 12 or ln_tcred = 13 or ln_mod = 107 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;*/
  
    if pn_tdoc = 9 then
      pv_nom1 := lv_razs;
    end if;
    --pn_cta := ln_cta;
    --pn_oper := ln_oper;
    begin
      insert into aqpb397
        (aqpb397fec,
         aqpb397pais,
         aqpb397tdoc,
         aqpb397ndoc,
         aqpb397fecsis,
         aqpb397mod,
         aqpb397cta,
         aqpb397oper,
         aqpb397tope,
         aqpb397aofval,
         aqpb397stat,
         aqpb397ori,
         aqpb397estrab,
         aqpb397eval,
         aqpb397tcred,
         aqpb397inst,
         aqpb397sucdes,
         aqpb397succred,
         aqpb397ape1,
         aqpb397ape2,
         aqpb397nom1,
         aqpb397nom2,
         aqpb397razs,
         --aqpb397usr,
         aqpb397fcr,
         aqpb397hcr)
      values
        (sysdate,
         pn_pais,
         pn_tdoc,
         pc_ndoc,
         ld_fecha,
         ln_mod,
         ln_cta,
         ln_oper,
         ln_tope,
         ld_aofval,
         ln_stat,
         ln_ori,
         lv_estrab,
         pv_rpta,
         ln_tcred,
         ln_insta,
         pn_sucdes,
         pn_succred,
         pv_ape1,
         pv_ape2,
         pv_nom1,
         pv_nom2,
         lv_razs,
         -- user,
         to_char(sysdate, 'DD/MM/YYYY'),
         to_char(sysdate, 'HH24:MI:SS'));
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_verif_desembolso;
  --------------------------------------------------------------------------------------------------------------------------

end pq_cr_campana_escolar_2022;
/

