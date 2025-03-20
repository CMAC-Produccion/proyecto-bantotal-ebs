create or replace package PQ_CR_RN_REPROG_CAJA_ENH is

  -- Author  : ENINAH
  -- Created : 5/12/2022 16:31:13
  -- Purpose : 
  procedure sp_cr_control_mismo_dia(instancia in number,
                                    control   out varchar2);
  procedure sp_cr_control_cuo_mayor(instancia in number,
                                    control   out varchar2);
  procedure sp_cr_control_cuota_impaga(instancia in number,
                                       control   out varchar2);
  procedure sp_cr_control_negativo(instancia in number,
                                   control   out varchar2);
end PQ_CR_RN_REPROG_CAJA_ENH;
/

create or replace package body PQ_CR_RN_REPROG_CAJA_ENH is

  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  ---------------------------------------------Control 1 del requerimiento--------------------------------
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --tienen que ser el mismo dia de pago qu el nuevo credito reprogramado
  procedure sp_cr_control_mismo_dia(instancia in number,
                                    control   out varchar2) is
    ln_pgcod       number;
    ln_lcmod       number;
    ln_lcsuc       number;
    ln_lcmda       number;
    ln_lcpap       number;
    ln_lccta       number;
    ln_lcoper      number;
    ln_lcsbop      number;
    ln_lctope      number;
    ld_feult_cuota date;
    --ld_feult_cuota2 date;
    fecha         date;
    primer_fecha  varchar2(2);
    segunda_fecha varchar2(2);
  begin
    PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(instancia,
                                           ln_pgcod,
                                           ln_lcmod,
                                           ln_lcsuc,
                                           ln_lcmda,
                                           ln_lcpap,
                                           ln_lccta,
                                           ln_lcoper,
                                           ln_lcsbop,
                                           ln_lctope);
  
    begin
      select max(ppfpag)
        into ld_feult_cuota
        from fsd602
       where pgcod = ln_pgcod
         and ppmod = ln_lcmod
         and ppsuc = ln_lcsuc
         and ppmda = ln_lcmda
         and pppap = ln_lcpap
         and ppcta = ln_lccta
         and ppoper = ln_lcoper
         and ppsbop = ln_lcsbop
         and pptope = ln_lctope
         and PP1STAT = 'T'
         and D602CO = 'S';
    exception
      when others then
        null;
    end;
    if ld_feult_cuota is null then
      begin
        select min(ppfpag)
          into ld_feult_cuota
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope;
      exception
        when others then
          null;
      end;
    end if;
  
    begin
      select min(ppfpag)
        into fecha
        from fsd601
       where pgcod = ln_pgcod
         and ppmod = ln_lcmod
         and ppsuc = ln_lcsuc
         and ppmda = ln_lcmda
         and pppap = ln_lcpap
         and ppcta = ln_lccta
         and ppoper = ln_lcoper
         and ppsbop = 609
         and pptope = ln_lctope;
    exception
      when others then
        fecha := null;
    end;
    begin
      select to_char(to_date(ld_feult_cuota, 'DD/MM/RRRR'), 'DD')
        into primer_fecha
        from dual;
    exception
      when others then
        null;
    end;
    begin
      select to_char(to_date(fecha, 'DD/MM/RRRR'), 'DD')
        into segunda_fecha
        from dual;
    exception
      when others then
        null;
    end;
    if (primer_fecha = segunda_fecha) then
      control := 'N';
    else
      control := 'S';
    end if;
  
  end sp_cr_control_mismo_dia;

  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  -------------------------------------------------Control 2----------------------------------------------
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  procedure sp_cr_control_cuo_mayor(instancia in number,
                                    control   out varchar2) is
    ld_feult_cuota  date;
    ld_feult_cuota2 date;
    ld_feult_cuota3 date;
    ln_monto        number;
    ln_segur        number;
    ln_monto2       number;
    ln_segur2       number;
    ln_monto_total  number;
    ln_monto_total2 number;
    ln_pgcod        number;
    ln_lcmod        number;
    ln_lcsuc        number;
    ln_lcmda        number;
    ln_lcpap        number;
    ln_lccta        number;
    ln_lcoper       number;
    ln_lcsbop       number;
    ln_lctope       number;
    porcentaje      number;
    porcentaje2     number;
  begin
    ln_pgcod  := 0;
    ln_lcmod  := 0;
    ln_lcsuc  := 0;
    ln_lcmda  := 0;
    ln_lcpap  := 0;
    ln_lccta  := 0;
    ln_lcoper := 0;
    ln_lcsbop := 0;
    ln_lctope := 0;
    begin
      PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(instancia,
                                             ln_pgcod,
                                             ln_lcmod,
                                             ln_lcsuc,
                                             ln_lcmda,
                                             ln_lcpap,
                                             ln_lccta,
                                             ln_lcoper,
                                             ln_lcsbop,
                                             ln_lctope);
      begin
        select max(ppfpag)
          into ld_feult_cuota
          from fsd602
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope
           and PP1STAT = 'T'
           and D602CO = 'S';
      exception
        when others then
          ld_feult_cuota := null;
      end;
      begin
        select min(ppfpag)
          into ld_feult_cuota2
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope
           and ppfpag > ld_feult_cuota;
      exception
        when others then
          null;
      end;
      if ld_feult_cuota is null then
        begin
          select min(ppfpag)
            into ld_feult_cuota2
            from fsd601
           where pgcod = ln_pgcod
             and ppmod = ln_lcmod
             and ppsuc = ln_lcsuc
             and ppmda = ln_lcmda
             and pppap = ln_lcpap
             and ppcta = ln_lccta
             and ppoper = ln_lcoper
             and ppsbop = ln_lcsbop
             and pptope = ln_lctope;
        exception
          when others then
            null;
        end;
      end if;
      begin
        select NVL(sum(ppcap + ppint), 0)
          into ln_monto
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope
           and ppfpag = ld_feult_cuota2;
      exception
        when others then
          ln_monto := 0;
        
      end;
      begin
        select NVL(sum(ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15 +
                       ppimp16 + ppimp17 + ppimp18 + ppimp19 + ppimp20),
                   0)
          into ln_segur
          from fsd611
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope
           and ppfpag = ld_feult_cuota2;
      exception
        when others then
          ln_segur := 0;
      end;
      ln_monto_total := ln_monto + ln_segur;
      ------------------------------------------------------------------
      begin
        select min(ppfpag)
          into ld_feult_cuota3
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = 609
           and pptope = ln_lctope;
      exception
        when others then
          ld_feult_cuota3 := null;
      end;
      begin
        select NVL(sum(ppcap + ppint), 0)
          into ln_monto2
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = 609
           and pptope = ln_lctope
           and ppfpag = ld_feult_cuota3;
      exception
        when others then
          ln_monto2 := 0;
      end;
      begin
        select NVL(sum(ppimp11 + ppimp12 + ppimp13 + ppimp14 + ppimp15 +
                       ppimp16 + ppimp17 + ppimp18 + ppimp19 + ppimp20),
                   0)
          into ln_segur2
          from fsd611
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = 609
           and pptope = ln_lctope
           and ppfpag = ld_feult_cuota3;
      exception
        when others then
          ln_segur2 := 0;
      end;
      ln_monto_total2 := ln_monto2 + ln_segur2;
    
      begin
        select tp1imp1, tp1imp2
          into porcentaje, porcentaje2
          from fst198
         where tp1cod1 = 11161
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 1;
      exception
        when others then
          porcentaje  := 85;
          porcentaje2 := 100;
      end;
      control := 'S';
      if ln_monto_total2 >= (ln_monto_total * porcentaje) / 100 and
         (ln_monto_total * porcentaje2) / 100 >= ln_monto_total2 then
        control := 'N';
      end if;
    end;
  end sp_cr_control_cuo_mayor;

  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  ---------------------------------------------Control 3 del requerimiento--------------------------------
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  procedure sp_cr_control_cuota_impaga(instancia in number,
                                       control   out varchar2) is
  
    ld_fecpag date;
    fecha1    date;
    fecha2    date;
    --days           number;
    --ld_feult_cuota date;
    ln_pgcod  number;
    ln_lcmod  number;
    ln_lcsuc  number;
    ln_lcmda  number;
    ln_lcpap  number;
    ln_lccta  number;
    ln_lcoper number;
    ln_lcsbop number;
    ln_lctope number;
    mes       number;
    dif_fech  number;
  
  begin
    ln_pgcod  := 0;
    ln_lcmod  := 0;
    ln_lcsuc  := 0;
    ln_lcmda  := 0;
    ln_lcpap  := 0;
    ln_lccta  := 0;
    ln_lcoper := 0;
    ln_lcsbop := 0;
    ln_lctope := 0;
    PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(instancia,
                                           ln_pgcod,
                                           ln_lcmod,
                                           ln_lcsuc,
                                           ln_lcmda,
                                           ln_lcpap,
                                           ln_lccta,
                                           ln_lcoper,
                                           ln_lcsbop,
                                           ln_lctope);
    begin
      select max(ppfpag)
        into ld_fecpag
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_lcmod
         and f.ppsuc = ln_lcsuc
         and f.ppmda = ln_lcmda
         and f.pppap = ln_lcpap
         and f.ppcta = ln_lccta
         and f.ppoper = ln_lcoper
         and f.ppsbop = ln_lcsbop
         and f.pptope = ln_lctope
         and f.PP1STAT = 'T'
         and f.D602CO = 'S';
    exception
      when others then
        ld_fecpag := null;
    end;
    begin
      select min(ppfpag)
        into fecha1
        from fsd601
       where pgcod = ln_pgcod
         and ppmod = ln_lcmod
         and ppsuc = ln_lcsuc
         and ppmda = ln_lcmda
         and pppap = ln_lcpap
         and ppcta = ln_lccta
         and ppoper = ln_lcoper
         and ppsbop = ln_lcsbop
         and pptope = ln_lctope
         and ppfpag > ld_fecpag;
    exception
      when others then
        null;
    end;
    if ld_fecpag is null then
      begin
        select min(ppfpag)
          into fecha1
          from fsd601
         where pgcod = ln_pgcod
           and ppmod = ln_lcmod
           and ppsuc = ln_lcsuc
           and ppmda = ln_lcmda
           and pppap = ln_lcpap
           and ppcta = ln_lccta
           and ppoper = ln_lcoper
           and ppsbop = ln_lcsbop
           and pptope = ln_lctope;
      exception
        when others then
          fecha1 := null;
      end;
    end if;
    begin
      select min(ppfpag)
        into fecha2
        from fsd601
       where pgcod = ln_pgcod
         and ppmod = ln_lcmod
         and ppsuc = ln_lcsuc
         and ppmda = ln_lcmda
         and pppap = ln_lcpap
         and ppcta = ln_lccta
         and ppoper = ln_lcoper
         and ppsbop = 609
         and pptope = ln_lctope;
    exception
      when others then
        fecha2 := null;
    end;
  
    begin
      select TP1IMP1
        into mes
        from fst198
       where tp1cod1 = 11161
         and tp1corr1 = 2
         and tp1corr2 = 2
         and tp1corr3 = 1;
    exception
      when others then
        mes := 0;
    end;
  
    select months_between(to_date(fecha2, 'dd/mm/yyyy'),
                          to_date(fecha1, 'dd/mm/yyyy'))
      into dif_fech
      from dual;
    if dif_fech > mes then
      control := 'S';
    else
      control := 'N';
    end if;
  end sp_cr_control_cuota_impaga;

  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  ---------------------------------------------Control 4 del requerimiento--------------------------------
  --////////////////////////////////////////////////////////////////////////////////////////////////////--
  --////////////////////////////////////////////////////////////////////////////////////////////////////--

  procedure sp_cr_control_negativo(instancia in number,
                                   control   out varchar2) is
  
    --fecha1    date;
    ln_pgcod         number;
    ln_lcmod         number;
    ln_lcsuc         number;
    ln_lcmda         number;
    ln_lcpap         number;
    ln_lccta         number;
    ln_lcoper        number;
    ln_lcsbop        number;
    ln_lctope        number;
    capital_negativo number;
  
  begin
    ln_pgcod  := 0;
    ln_lcmod  := 0;
    ln_lcsuc  := 0;
    ln_lcmda  := 0;
    ln_lcpap  := 0;
    ln_lccta  := 0;
    ln_lcoper := 0;
    ln_lcsbop := 0;
    ln_lctope := 0;
  
    PQ_CR_RN_REPROG_CAJA.sp_buscar_credito(instancia,
                                           ln_pgcod,
                                           ln_lcmod,
                                           ln_lcsuc,
                                           ln_lcmda,
                                           ln_lcpap,
                                           ln_lccta,
                                           ln_lcoper,
                                           ln_lcsbop,
                                           ln_lctope);
    begin
      select count(*)
        into capital_negativo
        from fsd601
       where pgcod = ln_pgcod
         and ppmod = ln_lcmod
         and ppsuc = ln_lcsuc
         and ppmda = ln_lcmda
         and pppap = ln_lcpap
         and ppcta = ln_lccta
         and ppoper = ln_lcoper
         and ppsbop = 609
         and pptope = ln_lctope
         and ppcap < 0;
    exception
      when others then
        null;
    end;
  
    if (capital_negativo > 0) then
      control := 'S';
    else
      control := 'N';
    end if;
  
  end sp_cr_control_negativo;

end PQ_CR_RN_REPROG_CAJA_ENH;
/

