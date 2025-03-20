create or replace package PQ_CR_REPROG_SINCAP is

  -- Author  : DCASTRO
  -- Created : 05/02/2021
  -- Modified : 

  -- Public type declarations
  
  
 procedure sp_pago_parcial_seg(pn_emp    in number,
                     pn_mod    in number,
                     pn_suc    in number,
                     pn_mda    in number,
                     pn_pap    in number,
                     pn_cta    in number,
                     pn_ope    in number,
                     pn_sbo    in number,
                     pn_top    in number,
                     pd_fec    in date) ;
                     

procedure sp_retorna_parcial_seg(pn_emp    in number,
                     pn_mod    in number,
                     pn_suc    in number,
                     pn_mda    in number,
                     pn_pap    in number,
                     pn_cta    in number,
                     pn_ope    in number,
                     pn_sbo    in number,
                     pn_top    in number,
                     pd_fec    in date);
  
procedure sp_pago_parcial_cap(pn_instancia    in number,
                              pc_flag   out varchar2 ) ;  

procedure sp_activo_pasivo(pn_instancia in number,
                           pd_fecha     in date,
                           pc_flag      out varchar2);


procedure sp_cr_SegmntoActual(ln_cuenta  in number,
                              ln_segmento out number);  
  --------------------------------------------
end PQ_CR_REPROG_SINCAP;
/

create or replace package body PQ_CR_REPROG_SINCAP is
 
 --------------------------

 procedure sp_pago_parcial_seg(pn_emp    in number,
                               pn_mod    in number,
                               pn_suc    in number,
                               pn_mda    in number,
                               pn_pap    in number,
                               pn_cta    in number,
                               pn_ope    in number,
                               pn_sbo    in number,
                               pn_top    in number,
                               pd_fec    in date) is

  ld_maxpag date;
  lc_stat   char(1);
  lc_flg    char(1);
  ln_cap    number(17, 2);
  ln_int    number(17, 2);
  lc_flgCap char(1);
  lc_flgInt char(1);  
  lc_est    char(1);
  ln_cont   number;

  cursor cuotas_parc(pp_emp    in number,
                     pp_mod    in number,
                     pp_suc    in number,
                     pp_mda    in number,
                     pp_pap    in number,
                     pp_cta    in number,
                     pp_ope    in number,
                     pp_sbo    in number,
                     pp_top    in number,
                     ld_maxpag in date) is
    select *
      from fsd602 a
     where a.pgcod = pp_emp
       and a.ppmod = pp_mod
       and a.ppsuc = pp_suc
       and a.ppmda = pp_mda
       and a.pppap = pp_pap
       and a.ppcta = pp_cta
       and a.ppoper = pp_ope
       and a.ppsbop = pp_sbo
       and a.pptope = pp_top
       and a.ppfpag = ld_maxpag
       and a.pp1stat = 'P'
       and a.d602co = 'S';
BEGIN

    --verifica si es parcial
    begin
      select max(a.ppfpag)
        into ld_maxpag
        from fsd602 a
       where a.pgcod =  pn_emp 
         and a.ppmod =  pn_mod 
         and a.ppsuc =  pn_suc 
         and a.ppmda =  pn_mda 
         and a.pppap =  pn_pap 
         and a.ppcta =  pn_cta 
         and a.ppoper = pn_ope 
         and a.ppsbop = pn_sbo 
         and a.pptope = pn_top 
         and a.d602co = 'S';
    exception
      when too_many_rows then
        begin
          select max(a.ppfpag)
            into ld_maxpag
            from fsd602 a
           where a.pgcod =  pn_emp 
             and a.ppmod =  pn_mod 
             and a.ppsuc =  pn_suc 
             and a.ppmda =  pn_mda 
             and a.pppap =  pn_pap 
             and a.ppcta =  pn_cta 
             and a.ppoper = pn_ope 
             and a.ppsbop = pn_sbo 
             and a.pptope = pn_top 
             and a.d602co = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    if ld_maxpag is not null then
      begin
        select 'T'
          into lc_stat
          from fsd602 a
         where a.pgcod =  pn_emp 
           and a.ppmod =  pn_mod 
           and a.ppsuc =  pn_suc 
           and a.ppmda =  pn_mda 
           and a.pppap =  pn_pap 
           and a.ppcta =  pn_cta 
           and a.ppoper = pn_ope 
           and a.ppsbop = pn_sbo 
           and a.pptope = pn_top 
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'T'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      if lc_stat = 'T' then
        lc_flg := 'S';
      else
        lc_flg := 'P';
      end if;
    else
      lc_flg := 'S';
    end if;
  
    ---valida si el pago parcial es de capital
    if lc_flg = 'P' then
    
      begin
        select sum(a.pp1cap), sum(a.pp1int)
          into ln_cap, ln_int
          from fsd602 a
         where a.pgcod =  pn_emp 
           and a.ppmod =  pn_mod 
           and a.ppsuc =  pn_suc 
           and a.ppmda =  pn_mda 
           and a.pppap =  pn_pap 
           and a.ppcta =  pn_cta 
           and a.ppoper = pn_ope 
           and a.ppsbop = pn_sbo 
           and a.pptope = pn_top 
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          ln_cap := 0;
          ln_int := 0;
      end;
    
      if nvl(ln_cap, 0) <> 0 then
        lc_flgCap := 'S';
      else
        lc_flgCap := 'N';
      end if;
      
      if nvl(ln_int, 0) <> 0 then
        lc_flgInt := 'S';
      else
        lc_flgInt := 'N';
      end if;

    end if;
  
  
    if  nvl(lc_flgCap, 'N') = 'N' and nvl(lc_flgInt, 'N') = 'N' and lc_flg = 'P' then
      --- pago parcial sin pago de capital ni interes con pago de seguro
    
      insert into FPP725B
        (FPP725Bemp,
         FPP725Bmod,
         FPP725Bsuc,
         FPP725Bmda,
         FPP725Bpap,
         FPP725Bcta,
         FPP725Bope,
         FPP725Bsop,
         FPP725Btop,
         FPP725Bfep,
         FPP725Best)
      values
        (pn_emp,
         pn_mod,
         pn_suc,
         pn_mda,
         pn_pap,
         pn_cta,
         pn_ope,
         pn_sbo,
         pn_top,
         pd_fec,
         'P');
      commit;
  
    --actualizo calendario de pago
    delete from JAQZ699B a
     where a.jaqz699_fec  = pd_fec
       and a.jaqz699pgcod = pn_emp
       and a.jaqz699mod =   pn_mod
       and a.jaqz699suc =   pn_suc
       and a.jaqz699mda =   pn_mda
       and a.jaqz699pap =   pn_pap
       and a.jaqz699cta =   pn_cta
       and a.jaqz699oper =  pn_ope
       and a.jaqz699sbop =  pn_sbo
       and a.jaqz699tope =  pn_top;
    commit;
    
    begin
     select count(*) into ln_cont 
     from jaqz699b j where j.jaqz699_fec =  pd_fec;
    exception when others then
       ln_cont := 0;
    end;
    
    ln_cont := ln_cont + 1;
    
    begin
      insert into JAQZ699B
        select pd_fec, ln_cont, a.*
          from fsd602 a
         where a.pgcod =  pn_emp
           and a.ppmod =  pn_mod
           and a.ppsuc =  pn_suc
           and a.ppmda =  pn_mda
           and a.pppap =  pn_pap
           and a.ppcta =  pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
    end;
    commit;
  
  
    for x in cuotas_parc(pn_emp,
                         pn_mod,
                         pn_suc,
                         pn_mda,
                         pn_pap,
                         pn_cta,
                         pn_ope,
                         pn_sbo,
                         pn_top,
                         ld_maxpag) loop
    
      update fsd602 a
         set a.d602co = 'E'
       where a.pgcod = x.pgcod
         and a.ppmod = x.ppmod
         and a.ppsuc = x.ppsuc
         and a.ppmda = x.ppmda
         and a.pppap = x.pppap
         and a.ppcta = x.ppcta
         and a.ppoper = x.ppoper
         and a.ppsbop = x.ppsbop
         and a.pptope = x.pptope
         and a.pp1nump = x.pp1nump
         and a.ppfpag = ld_maxpag
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    
      commit;


    end loop;

    end if;  
   
 end sp_pago_parcial_seg;


procedure sp_retorna_parcial_seg(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_ope    in number,
                                 pn_sbo    in number,
                                 pn_top    in number,
                                 pd_fec    in date) is
  
   cursor bk is
      select *
        from JAQZ699B a
       where a.jaqz699_fec = pd_fec
          and a.jaqz699pgcod = pn_emp
             and a.jaqz699mod = pn_mod
             and a.jaqz699suc = pn_suc
             and a.jaqz699mda = pn_mda
             and a.jaqz699pap = pn_pap
             and a.jaqz699cta = pn_cta
             and a.jaqz699oper = pn_ope
             and a.jaqz699sbop = pn_sbo
             and a.jaqz699tope = pn_top
             ; 
        
  
    lc_err char(1) := 'N';
    pd_fecIn date;
    
  begin
  
      for i in bk loop

        begin
          select min(a.ppfpag) 
          into pd_fecIn
          from fsd601 a
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.ppfpag >= i.jaqz699fpag;
       exception when others then
           pd_fecIn := null;    
       end;      

      
        begin
          update fsd612 a
             set a.ppfpag = pd_fecIn
           where a.pgcod =  i.jaqz699pgcod
             and a.ppmod =  i.jaqz699mod
             and a.ppsuc =  i.jaqz699suc
             and a.ppmda =  i.jaqz699mda
             and a.pppap =  i.jaqz699pap
             and a.ppcta =  i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump;
        
          commit;
        exception
          when others then
            lc_err := 'S';
          
            update FPP725B a
               set a.fpp725best = 'E' --no se puedo actualizar fsd612
             where a.fpp725bemp = i.jaqz699pgcod
               and a.fpp725bmod = i.jaqz699mod
               and a.fpp725bsuc = i.jaqz699suc
               and a.fpp725bmda = i.jaqz699mda
               and a.fpp725bpap = i.jaqz699pap
               and a.fpp725bcta = i.jaqz699cta
               and a.fpp725bope = i.jaqz699oper
               and a.fpp725bsop = i.jaqz699sbop
               and a.fpp725btop = i.jaqz699tope
               and a.fpp725bfep = i.jaqz699_fec;

            commit;
        end;
        begin
          update fsd602 a
             set a.ppfpag = pd_fecIn, a.d602co = 'S'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump
             and a.d602co = 'E';
        
          commit;
        exception
          when others then
            lc_err := 'S';
          
            update FPP725B a
               set a.fpp725best = 'F' --no se puedo actualizar fsd602
             where a.fpp725bemp = i.jaqz699pgcod
               and a.fpp725bmod = i.jaqz699mod
               and a.fpp725bsuc = i.jaqz699suc
               and a.fpp725bmda = i.jaqz699mda
               and a.fpp725bpap = i.jaqz699pap
               and a.fpp725bcta = i.jaqz699cta
               and a.fpp725bope = i.jaqz699oper
               and a.fpp725bsop = i.jaqz699sbop
               and a.fpp725btop = i.jaqz699tope
               and a.fpp725bfep = i.jaqz699_fec;
           commit;
        end;
      end loop;
    commit;


end sp_retorna_parcial_seg;

procedure sp_pago_parcial_cap(pn_instancia    in number,
                              pc_flag   out varchar2 ) is


  ld_maxpag date;
  lc_stat   char(1);
  lc_flg    char(1);
  ln_cap    number(17, 2);
  ln_int    number(17, 2);
  lc_flgCap char(1);
  lc_flgInt char(1);  
  lc_est    char(1);
  ln_cont   number;
  pn_emp    number;
  pn_mod    number;
  pn_suc    number;
  pn_mda    number;
  pn_pap    number;
  pn_cta    number;
  pn_ope    number;
  pn_sbo    number;
  pn_top    number;
  


BEGIN

    begin   
       select a.xwfempresa, a.xwfmodulo, a.xwfsucursal, a.xwfmoneda, a.xwfpapel, a.xwfcuenta, a.xwfoperacion, a.xwfsubope, a.xwftipope
         into pn_emp ,pn_mod ,pn_suc, pn_mda, pn_pap ,pn_cta ,pn_ope ,pn_sbo ,pn_top 
         from xwf700 a
        where a.xwfprcins = pn_instancia
          and a.xwfcar3 = '1';
    exception when others then
         pn_emp := null;     
    end;      

    --verifica si es parcial
    begin
      select max(a.ppfpag)
        into ld_maxpag
        from fsd602 a
       where a.pgcod =  pn_emp 
         and a.ppmod =  pn_mod 
         and a.ppsuc =  pn_suc 
         and a.ppmda =  pn_mda 
         and a.pppap =  pn_pap 
         and a.ppcta =  pn_cta 
         and a.ppoper = pn_ope 
         and a.ppsbop = pn_sbo 
         and a.pptope = pn_top 
         and a.d602co = 'S';
    exception
      when too_many_rows then
        begin
          select max(a.ppfpag)
            into ld_maxpag
            from fsd602 a
           where a.pgcod =  pn_emp 
             and a.ppmod =  pn_mod 
             and a.ppsuc =  pn_suc 
             and a.ppmda =  pn_mda 
             and a.pppap =  pn_pap 
             and a.ppcta =  pn_cta 
             and a.ppoper = pn_ope 
             and a.ppsbop = pn_sbo 
             and a.pptope = pn_top 
             and a.d602co = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    if ld_maxpag is not null then
      begin
        select 'T'
          into lc_stat
          from fsd602 a
         where a.pgcod =  pn_emp 
           and a.ppmod =  pn_mod 
           and a.ppsuc =  pn_suc 
           and a.ppmda =  pn_mda 
           and a.pppap =  pn_pap 
           and a.ppcta =  pn_cta 
           and a.ppoper = pn_ope 
           and a.ppsbop = pn_sbo 
           and a.pptope = pn_top 
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'T'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      if lc_stat = 'T' then
        lc_flg := 'S';
      else
        lc_flg := 'P';
      end if;
    else
      lc_flg := 'S';
    end if;
  
    ---valida si el pago parcial es de capital
    if lc_flg = 'P' then
    
      begin
        select sum(a.pp1cap), sum(a.pp1int)
          into ln_cap, ln_int
          from fsd602 a
         where a.pgcod =  pn_emp 
           and a.ppmod =  pn_mod 
           and a.ppsuc =  pn_suc 
           and a.ppmda =  pn_mda 
           and a.pppap =  pn_pap 
           and a.ppcta =  pn_cta 
           and a.ppoper = pn_ope 
           and a.ppsbop = pn_sbo 
           and a.pptope = pn_top 
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          ln_cap := 0;
          ln_int := 0;
      end;
    
      if nvl(ln_cap, 0) <> 0 then
        lc_flgCap := 'S';
      else
        lc_flgCap := 'N';
      end if;
      
      if nvl(ln_int, 0) <> 0 then
        lc_flgInt := 'S';
      else
        lc_flgInt := 'N';
      end if;

    end if;
  
  
    if  ( nvl(lc_flgCap, 'N') = 'S' or nvl(lc_flgInt, 'N') = 'S' ) and lc_flg = 'P' then
        pc_flag := 'S';
    else
        pc_flag := 'N';   
    end if;  
   
 end sp_pago_parcial_cap;

procedure sp_activo_pasivo(pn_instancia in number,
                           pd_fecha     in date,
                           pc_flag      out varchar2) is

  ln_pas number;
  ln_act number;

begin

  begin
    --pasivo/patrimonio
    select case
             when k.jaqz517cod = 71 then
              nvl(sum(k.jaqz517mto), 0)
             else
              nvl(sum(k.jaqz517mto), 0) * fn_tipo_cambio_fijo(pd_fecha)
           end case
      into ln_pas
      from jaqz516 j, jaqz517 k
     where k.jaqz517eval = j.jaqz516eval
       and j.jaqz516sol = pn_instancia
       and k.jaqz517cod in (71, 571)
     group by k.jaqz517cod;
  exception
    when others then
      ln_pas := 0;
  end;

  begin
    --activo
    select case
             when k.jaqz517cod = 52 then
              nvl(sum(k.jaqz517mto), 0)
             else
              nvl(sum(k.jaqz517mto), 0) * fn_tipo_cambio_fijo(pd_fecha)
           end case
    
      into ln_act
      from jaqz516 j, jaqz517 k
     where k.jaqz517eval = j.jaqz516eval
       and j.jaqz516sol = pn_instancia
       and k.jaqz517cod in (52, 562)
     group by k.jaqz517cod;
  exception
    when others then
      ln_act := 0;
  end;

  if ln_pas <> ln_act then
    pc_flag := 'S';
  else
    pc_flag := 'N';
  end if;

end sp_activo_pasivo;


  --------------------------------------------
  procedure sp_cr_SegmntoActual(ln_cuenta  in number,
                                ln_segmento out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select f.PEPAIS, f.petdoc, f.PENDOC
        into ln_pais, ln_tdoc, lc_nrodoc
        from fsr008 f
       where f.CTNRO = ln_cuenta
         and f.TTCOD = 1
         and f.CTTFIR = 'T';
    exception when others then
       ln_tdoc := 0;  ---22072021
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into ln_segmento
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into ln_segmento
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        ln_segmento := 1;
      end if;
    end if;
  
  end sp_cr_SegmntoActual;


end PQ_CR_REPROG_SINCAP;
/

