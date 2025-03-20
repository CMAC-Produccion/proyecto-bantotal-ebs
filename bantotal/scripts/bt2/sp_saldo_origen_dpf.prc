create or replace procedure SP_SALDO_ORIGEN_DPF(VPGCOD  number,
                                                VSCSUC  number,
                                                VSCMDA  number,
                                                VSCPAP  number,
                                                VSCCTA  number,
                                                VSCOPER number,
                                                VSCSBOP number,
                                                VSCTOPE number,
                                                FECINI  date,
                                                SALDO   out number) is

  mes    number;
  anio   number;
  vsaldo number;

  entidad number;
  fecmig  date;
  periodo varchar2(6);
  ln_salpar number(17,2);
/*
  vsalint number;
  vretint number;
  vtotret number;
  vscmod  number(3) := 22;
  vfecint date;
  vultint date;
  verror  varchar2(100);

  vscfval date;
  cursor salint is
    select y.*
      from fsd602 y, fst198 z
     where y.pgcod = z.tp1cod
       and y.d602mo = z.tp1nro1
       and y.d602tr = z.tp1nro2
       and z.tp1cod1 = 10822
       and z.tp1corr1 = 1
       and z.tp1corr2 = 19
       and y.pgcod = vpgcod
       and ppmod = vscmod
       and ppsuc = vscsuc
       and ppmda = vscmda
       and pppap = vscpap
       and ppcta = vsccta
       and ppoper = vscoper
          --and ppsbop= vscsbop
       and pptope = vsctope
       and d602co = 'S'
       and PP1FECH <= vfecint
       and pp1fech > vscfval
     order by PP1FECH;*/

begin

  entidad := fn_entidad_migrada(vpgcod,
                                vscsuc,
                                vscmda,
                                vscpap,
                                vsccta,
                                vscoper,
                                vscsbop,
                                vsctope,
                                22,
                                'B');

  if entidad <> 0 then
    select to_date(to_char(tpimp), 'yyyymmdd')
      into fecmig
      from fst098
     where pgcod = 1
       and tpcod = 7691
       and tpcorr = entidad;
       
     select jaql54saca/* + jaql54sain*/, JAQL54FECH
        into SALDO, fecmig
        from jaql054
       where jaql54pgco = vpgcod
         and jaql54scsu = vscsuc
         and jaql54scmd = vscmda
         and jaql54scpa = vscpap
         and jaql54scct = vsccta
         and jaql54scop = vscoper
         --and jaql54scsb = vscsbop
         and jaql54scto = vsctope
         and jaql54scmo = 22;
  
    if fecini > last_day(fecmig) then
      SALDO := 0;
    else      
      return;
    end if;
  
  end if;

  mes  := to_number(to_char(fecini, 'mm'));
  anio := to_number(to_char(fecini, 'rrrr'));

  if mes = 1 then
    anio := anio - 1;
  end if;

  select nvl(sum(Case
               When mes = 1 then
                HASD12
               When mes = 2 then
                HASD01
               When mes = 3 then
                HASD02
               When mes = 4 then
                HASD03
               When mes = 5 then
                HASD04
               When mes = 6 then
                HASD05
               When mes = 7 then
                HASD06
               When mes = 8 then
                HASD07
               When mes = 9 then
                HASD08
               When mes = 10 then
                HASD09
               When mes = 11 then
                HASD10
               When mes = 12 then
                HASD11
               else
                0
             end),0)
    into vsaldo
    from fsh014
   where pgcod = VPGCOD
     and hasuc = VSCSUC
     and hamda = VSCMDA
     and hapap = VSCPAP
     and hacta = VSCCTA
     and haoper = VSCOPER
     and hamod in (22, 122, 426)-- SE REGRESO EL 426
     and haanio = anio;

/*  vsalint := 0;

  If mes = 1 then
    vfecint := last_day(to_date('01/' || to_char('12') || '/' ||
                                to_char(anio) || '',
                                'dd/mm/yyyy'));
  else
    vfecint := last_day(to_date('01/' || to_char(mes - 1) || '/' ||
                                to_char(anio) || '',
                                'dd/mm/yyyy'));
  end if;
  --saldo de i
  vtotret := 0;
  begin
  
    select max(aofval)
      into vscfval
      from fsd010
     where pgcod = vpgcod
       and aomod = vscmod
       and aosuc = vscsuc
       and aomda = vscmda
       and aopap = vscpap
       and aocta = vsccta
       and aooper = vscoper
       and aotope = vsctope
       and aofval <= vfecint;
  
    for i in salint loop
      select sum(decode(bb.hcodmo, 1, bb.hcimp1, 0)) -
             sum(decode(bb.hcodmo, 2, bb.hcimp1, 0))
        into vretint
        from fsh016 bb, fsh015 c
       where bb.hsucor = i.d602su
         and bb.hcmod = i.d602mo
         and bb.htran = i.d602tr
         and bb.hnrel = i.d602re
         and bb.hfcon = i.d602fc
         and bb.hmodul = 426
         and bb.hcta = VSCCTA
         and bb.hoper = vscoper
         and bb.hcafgt in ('C', 'P')
            --and Hcmcod = 0
         and bb.pgcod = c.pgcod
         and bb.hcmod = c.hcmod
         and bb.hsucor = c.hsucor
         and bb.htran = c.htran
         and bb.hnrel = c.hnrel
         and bb.hfcon = c.hfcon;
    
      vultint := i.d602fc;
      vtotret := vtotret + vretint;
    
    end loop;
  
    select nvl(sum(decode(bb.hcodmo, 2, bb.hcimp1, 0)) -
               sum(decode(bb.hcodmo, 1, bb.hcimp1, 0)),
               0)
      into vsalint
      from fsh016 bb, fsh015 c
     where bb.hcmod = 99
       and bb.htran = 900
       and bb.hfcon between vscfval and (vultint - 1)
       and bb.hmodul = 426
       and bb.hcta = VSCCTA
       and bb.hoper = vscoper
       and bb.hcafgt in ('C', 'P')
       and Hcmcod = 0
       and bb.pgcod = c.pgcod
       and bb.hcmod = c.hcmod
       and bb.hsucor = c.hsucor
       and bb.htran = c.htran
       and bb.hnrel = c.hnrel
       and bb.hfcon = c.hfcon;
  end;*/
  --
  --SUMAMOS PARCHES AL SALDO ORIGEN CASO DE REGULARIZACIONES YLOZADA 2011.11.29
  --
  periodo := to_char((to_date('01/' || mes || '/' || anio, 'dd/mm/rrrr')-1), 'yyyymm');  
  ln_salpar := 0;
  begin
    select nvl(sum(jaql745impo),0) monto
      into ln_salpar 
      from jaql745
     where jaql745pgco = VPGCOD
       and jaql745scsu = VSCSUC
       and jaql745scmd = VSCMDA
       and jaql745scpa = VSCPAP
       and jaql745scct = VSCCTA
       and jaql745scop = VSCOPER
       and jaql745scto = VSCTOPE
       --and jaql745scsb = VSCSBOP
       and jaql745scmo = 22
       and to_char(jaql745fech, 'yyyymm') = periodo;
  exception
  when others then
    ln_salpar := 0;
  end;
  --saldo := vsaldo /*+ (vsalint - vtotret)*/;
  saldo := vsaldo + ln_salpar;
exception
when no_data_found then
    saldo := 0;  
end SP_SALDO_ORIGEN_DPF;
/

