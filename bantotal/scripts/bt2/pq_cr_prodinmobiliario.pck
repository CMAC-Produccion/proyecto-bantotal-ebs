create or replace package PQ_CR_PRODINMOBILIARIO is

  -- Author  : MPOSTIGOC
  -- Created : 21/04/2021 11:30:56 p. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_cargo(lc_usuario in varchar2, ln_cargo out number);
  -------------------------------------------------------------
  procedure sp_cr_mntutilizacion(ln_pgcod       in number,
                                 ln_itsuc       in number,
                                 ln_itmod       in number,
                                 ln_ittran      in number,
                                 ln_itnrel      in number,
                                 ln_itord       in number,
                                 ln_itsbor      in number,
                                 lc_mntdiferent out varchar2);
  ---------------------------------------------------------------
  procedure sp_cr_CompVencLinea(ln_pgcod     in number,
                                ln_itsuc     in number,
                                ln_itmod     in number,
                                ln_ittran    in number,
                                ln_itnrel    in number,
                                ln_itord     in number,
                                ln_itsbor    in number,
                                lc_Difrntfch out varchar2);

end PQ_CR_PRODINMOBILIARIO;
/

create or replace package body PQ_CR_PRODINMOBILIARIO is

  procedure sp_cr_cargo(lc_usuario in varchar2, ln_cargo out number) is
  
    lc_usuario2 CHAR(10);
  
  begin
  
    lc_usuario2 := lc_usuario;
  
    begin
      select s.sng055car
        into ln_cargo
        from sng057 s
       where s.sng057usr = lc_usuario2;
    exception
      when others then
        null;
    end;
  end sp_cr_cargo;
  ------------------------------------------------------------------
  procedure sp_cr_mntutilizacion(ln_pgcod       in number,
                                 ln_itsuc       in number,
                                 ln_itmod       in number,
                                 ln_ittran      in number,
                                 ln_itnrel      in number,
                                 ln_itord       in number,
                                 ln_itsbor      in number,
                                 lc_mntdiferent out varchar2) is
  
    cursor disposiciones(ln_pgcod117   number,
                         ln_modulo117  number,
                         ln_cuenta117  number,
                         ln_operac117  number,
                         ln_sucur117   number,
                         ln_moneda117  number,
                         ln_sboper117  number,
                         ln_papel117   number,
                         ln_tipoper117 number) is
    
      select f.r1cod,
             f.r1mod,
             f.r1suc,
             f.r1mda,
             f.r1pap,
             f.r1cta,
             f.r1oper,
             f.r1sbop,
             f.r1tope
        from fsr011 f
       where f.relcod = 46
         and f.r2mod = ln_modulo117
         and f.r2cta = ln_cuenta117
         and f.r2oper = ln_operac117
         and f.r2sbop = ln_sboper117
         and f.r2cod = ln_pgcod117
         and f.r2suc = ln_sucur117
         and f.r2mda = ln_moneda117
         and f.r2pap = ln_papel117
         and f.r2tope = ln_tipoper117;
  
    ln_emp         number;
    ln_mod         number;
    ln_suc         number;
    ln_mda         number;
    ln_pap         number;
    ln_cta         number;
    ln_ope         number;
    ln_subop       number;
    ln_tope        number;
    ln_pgcod117    number;
    ln_modulo117   number;
    ln_sucur117    number;
    ln_moneda117   number;
    ln_papel117    number;
    ln_cuenta117   number;
    ln_operac117   number;
    ln_sboper117   number;
    ln_tipoper117  number;
    ln_mntdesemb   number(17, 2) := 0.00;
    ln_mntdisposc  number(17, 2) := 0.00;
    ln_MntUtilAuxD number(17, 2) := 0.00;
    ln_MntUtil     number(17, 2) := 0.00;
    ln_MntUtilF    number(17, 2) := 0.00;
    ln_MntUtilAuxH number(17, 2) := 0.00;
  
  begin
  
    lc_mntdiferent := 'N';
  
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subop,
             ln_tope
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        null;
    end;
  
    if ln_tope = 31 then
    
      begin
        -- clave del credito principal
        select r2cod,
               r2mod,
               r2suc,
               r2mda,
               r2pap,
               r2cta,
               r2oper,
               r2sbop,
               r2tope
          into ln_pgcod117,
               ln_modulo117,
               ln_sucur117,
               ln_moneda117,
               ln_papel117,
               ln_cuenta117,
               ln_operac117,
               ln_sboper117,
               ln_tipoper117
          from fsr011
         where relcod = 46
           and r1cod = ln_emp
           and r1mod = ln_mod
           and r1suc = ln_suc
           and r1mda = ln_mda
           and r1pap = ln_pap
           and r1cta = ln_cta
           and r1oper = ln_ope
           and r1sbop = ln_subop
           and r1tope = ln_tope;
      exception
        when no_data_found then
          begin
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_pgcod117,
                   ln_modulo117,
                   ln_sucur117,
                   ln_moneda117,
                   ln_papel117,
                   ln_cuenta117,
                   ln_operac117,
                   ln_sboper117,
                   ln_tipoper117
              from fsr011
             where relcod = 46
               and r1cod = ln_emp
               and r1mod = ln_mod
               and r1suc = ln_suc
               and r1mda = ln_mda
               and r1pap = ln_pap
               and r1cta = ln_cta
               and r1oper = ln_ope
                  -- and r1sbop = ln_Itsubo116
               and r1tope = ln_tope;
          exception
            when others then
              null;
          end;
      end;
    
      if ln_pgcod117 is not null then
      
        begin
          select f.aoimp
            into ln_mntdesemb
            from fsd010 f
           where f.pgcod = ln_pgcod117
             and f.aomod = ln_modulo117
             and f.aosuc = ln_sucur117
             and f.aomda = ln_moneda117
             and f.aopap = ln_papel117
             and f.aocta = ln_cuenta117
             and f.aooper = ln_operac117
             and f.aosbop = ln_sboper117
             and f.aotope = ln_tipoper117;
        end;
      
        for d in disposiciones(ln_pgcod117,
                               ln_modulo117,
                               ln_cuenta117,
                               ln_operac117,
                               ln_sucur117,
                               ln_moneda117,
                               ln_sboper117,
                               ln_papel117,
                               ln_tipoper117) loop
        
          begin
            select sum(f.itimp1)
              into ln_MntUtilAuxD
              from fsd015 g, fsd016 f
             where g.pgcod = f.pgcod
               and g.itsuc = f.itsuc
               and g.itmod = f.itmod
               and g.ittran = f.ittran
               and g.itnrel = f.itnrel
               and g.itcorr <> 99
               and f.itord = 10
               and f.itmod = 116
               and f.ittran in (50, 60)
               and g.itcont = 'S'
               and f.modulo = d.r1mod
               and f.ittope = d.r1tope
               and f.itsucd = d.r1suc
               and f.moneda = d.r1mda
               and f.papel = d.r1pap
               and f.ctnro = d.r1cta
               and f.itoper = d.r1oper
               and f.itsubo = d.r1sbop;
          exception
            when others then
              ln_MntUtilAuxD := 0;
          end;
        
          begin
            select sum(g.hcimp1)
              into ln_MntUtilAuxH
              from fsh016 g, fsh015 f
             where g.pgcod = f.pgcod
               and g.hcmod = f.hcmod
               and g.hsucor = f.hsucor
               and g.htran = f.htran
               and g.hnrel = f.hnrel
               and g.hfcon = f.hfcon
               and f.hccorr <> 99
               and g.hcmod = 116
               and g.htran in (50, 60)
               and g.hcord = 10
               and g.hmodul = d.r1mod
               and g.htoper = d.r1tope
               and g.hsucur = d.r1suc
               and g.hmda = d.r1mda
               and g.hpap = d.r1pap
               and g.hcta = d.r1cta
               and g.hoper = d.r1oper
               and g.hsubop = d.r1sbop;
          exception
            when others then
              ln_MntUtilAuxH := 0;
          end;
        
          begin
            select f.itimp1
              into ln_mntdisposc
              from fsd016 f
             where f.pgcod = ln_pgcod
               and f.itsuc = ln_itsuc
               and f.itmod = ln_itmod
               and f.ittran = ln_ittran
               and f.itnrel = ln_itnrel
               and f.itord = ln_itord
               and f.itsbor = ln_itsbor;
          exception
            when others then
              ln_mntdisposc := 0;
          end;
        
          ln_MntUtil := nvl(ln_MntUtilAuxD, 0) + nvl(ln_MntUtilAuxH, 0) +
                        nvl(ln_mntdisposc, 0);
        
          ln_MntUtilF := ln_MntUtilF + ln_MntUtil;
        
          if ln_MntUtilF > ln_mntdesemb then
            lc_mntdiferent := 'S';
          end if;
        end loop;
      end if;
    end if;
  
  end sp_cr_mntutilizacion;
  --------------------------------------------------------------
  procedure sp_cr_CompVencLinea(ln_pgcod     in number,
                                ln_itsuc     in number,
                                ln_itmod     in number,
                                ln_ittran    in number,
                                ln_itnrel    in number,
                                ln_itord     in number,
                                ln_itsbor    in number,
                                lc_Difrntfch out varchar2) is
  
    ln_emp         number;
    ln_mod         number;
    ln_suc         number;
    ln_mda         number;
    ln_pap         number;
    ln_cta         number;
    ln_ope         number;
    ln_subop       number;
    ln_tope        number;
    ln_pgcod117    number;
    ln_modulo117   number;
    ln_sucur117    number;
    ln_moneda117   number;
    ln_papel117    number;
    ln_cuenta117   number;
    ln_operac117   number;
    ln_sboper117   number;
    ln_tipoper117  number;
    lc_VencDisp    date;
    lc_VencLnPrinc date;
  
  begin
  
    lc_Difrntfch := 'N';
  
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subop,
             ln_tope
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        null;
    end;
  
    if ln_mod = 116 then
    
      begin
        -- clave del credito principal
        select r2cod,
               r2mod,
               r2suc,
               r2mda,
               r2pap,
               r2cta,
               r2oper,
               r2sbop,
               r2tope
          into ln_pgcod117,
               ln_modulo117,
               ln_sucur117,
               ln_moneda117,
               ln_papel117,
               ln_cuenta117,
               ln_operac117,
               ln_sboper117,
               ln_tipoper117
          from fsr011
         where relcod = 46
           and r1cod = ln_emp
           and r1mod = ln_mod
           and r1suc = ln_suc
           and r1mda = ln_mda
           and r1pap = ln_pap
           and r1cta = ln_cta
           and r1oper = ln_ope
           and r1sbop = ln_subop
           and r1tope = ln_tope;
      exception
        when no_data_found then
          begin
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_pgcod117,
                   ln_modulo117,
                   ln_sucur117,
                   ln_moneda117,
                   ln_papel117,
                   ln_cuenta117,
                   ln_operac117,
                   ln_sboper117,
                   ln_tipoper117
              from fsr011
             where relcod = 46
               and r1cod = ln_emp
               and r1mod = ln_mod
               and r1suc = ln_suc
               and r1mda = ln_mda
               and r1pap = ln_pap
               and r1cta = ln_cta
               and r1oper = ln_ope
                  -- and r1sbop = ln_Itsubo116
               and r1tope = ln_tope;
          exception
            when others then
              null;
          end;
      end;
    
    else
      if ln_mod = 117 then
      
        ln_pgcod117   := ln_emp;
        ln_modulo117  := ln_mod;
        ln_sucur117   := ln_suc;
        ln_moneda117  := ln_mda;
        ln_papel117   := ln_pap;
        ln_cuenta117  := ln_cta;
        ln_operac117  := ln_ope;
        ln_sboper117  := ln_subop;
        ln_tipoper117 := ln_tope;
      
      end if;
    end if;
  
    if ln_tipoper117 = 31 then
      
      if ln_pgcod117 is not null then
      
        begin
          select f.aofvto
            into lc_VencLnPrinc
            from fsd010 f
           where f.pgcod = ln_pgcod117
             and f.aomod = ln_modulo117
             and f.aosuc = ln_sucur117
             and f.aomda = ln_moneda117
             and f.aopap = ln_papel117
             and f.aocta = ln_cuenta117
             and f.aooper = ln_operac117
             and f.aosbop = ln_sboper117
             and f.aotope = ln_tipoper117;
        exception
          when others then
            null;
        end;
      
        lc_VencLnPrinc := lc_VencLnPrinc + 180;
      
        if ln_ittran = 50 then
          begin
            select max(f.ppfpag)
              into lc_VencDisp
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_suc
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_ope
               and f.ppsbop = ln_subop
               and f.pptope = ln_tope
               and f.ppcap > 0;
          exception
            when others then
              null;
          end;
        
        else
          if ln_ittran = 60 then
          
            begin
              select max(f.ppfpag)
                into lc_VencDisp
                from fsd601 f
               where f.pgcod = ln_emp
                 and f.ppmod = ln_mod
                 and f.ppsuc = ln_suc
                 and f.ppmda = ln_mda
                 and f.pppap = ln_pap
                 and f.ppcta = 999999999 --ln_cta
                 and f.ppoper = ln_ope
                 and f.ppsbop = ln_subop
                 and f.pptope = ln_tope
                 and f.ppcap > 0;
            exception
              when others then
                null;
            end;
          
          end if;
        end if;
      
      end if;
    
      if lc_VencDisp > lc_VencLnPrinc then
        lc_Difrntfch := 'S';
      end if;
    end if;
  end sp_cr_CompVencLinea;

end PQ_CR_PRODINMOBILIARIO;
/

