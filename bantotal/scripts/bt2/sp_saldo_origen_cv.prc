create or replace procedure SP_SALDO_ORIGEN_CV(vPgcod  number,
                                               vScsuc  number,
                                               vScmod  number,
                                               vScmda  number,
                                               vScpap  number,
                                               vSccta  number,
                                               vScoper number,
                                               vScsbop number,
                                               vSctope number,
                                               vFecIni date,
                                               vSdoor  out number) is
  mes    varchar2(2);
  anio   varchar2(4);
  inicio date;
  rubro  number(16);
  ModChe number;
  ModVal number;
  TxnVll number;
  TxnMas number;
  ConAcr number;
  ItfChe number;
  CheVll number;

  entidad number;
  fecmig  date;

  periodo varchar2(6);

begin

  entidad := fn_entidad_migrada(vpgcod,
                                vscsuc,
                                vscmda,
                                vscpap,
                                vsccta,
                                vscoper,
                                vscsbop,
                                vsctope,
                                vscmod,
                                'B');

  if entidad <> 0 then
    select to_date(to_char(tpimp), 'yyyymmdd')
      into fecmig
      from fst098
     where pgcod = 1
       and tpcod = 7691
       and tpcorr = entidad;
  
    select jaql54saca, JAQL54FECH
      into vSdoor, fecmig
      from jaql054
     where jaql54pgco = vpgcod
       and jaql54scsu = vscsuc
       and jaql54scmd = vscmda
       and jaql54scpa = vscpap
       and jaql54scct = vsccta
       and jaql54scop = vscoper
       and jaql54scsb = vscsbop
       and jaql54scto = vsctope
       and jaql54scmo = vscmod;
  
    if vfecini > last_day(fecmig) then
      vSdoor := 0;
    else
      return;
    end if;
  
  end if;

  mes     := to_char(vfecini, 'mm');
  anio    := to_char(vfecini, 'rrrr');
  inicio  := to_date('01/' || mes || '/' || anio, 'dd/mm/rrrr');
  periodo := to_char((to_date('01/' || mes || '/' || anio, 'dd/mm/rrrr') - 1),
                     'yyyymm');

  select Tp1nro1,
         Tp1nro2,
         Tp1nro3,
         Tp1imp2,
         Tp1imp3,
         to_number(Tp1desc),
         Tp1corr3
    into ModChe, ModVal, TxnVll, TxnMas, ConAcr, ItfChe, CheVll
    from fst198
   Where Tp1cod = vpgcod
     and Tp1cod1 = 10822
     and Tp1corr1 = 2
     and Tp1corr2 = 4;

  select to_number(Trim(Tpdesc))
    into Rubro
    from FST098
   Where PgCod = vPgcod
     and Tpcod = 7619
     and (Tpcorr = 7 or Tpcorr = 21)
     and tpimp = vScmda;

  select sum(monto)
    into vSdoor
    from (select nvl(sum(Case
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
                     end),0) monto,
                 'saldo_inicio' tipo
            from fsh014
           where pgcod = vPgcod
             and hasuc = vScsuc
             and hamda = vScmda
             and hapap = vScpap
             and hacta = vSccta
             and haoper = vScoper
             and hatope = vSctope
             and hasbop = vScsbop
             and hamod = vScmod
             and haanio = decode(mes, 1, anio - 1, anio));

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
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
                     end),0) monto,
                 'garantia' tipo
            from fsh014
           where pgcod = vPgcod
             and hasuc = vScsuc
             and hamda = vScmda
             and hapap = vScpap
             and hacta = vSccta
             and haoper = vScoper
             and hatope = 0
             and hasbop = vScsbop
             and hamod = 201 --vScmod
             and haanio = decode(mes, 1, anio - 1, anio));

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all          
          -- 20200909 maraujo se resta/suma saldos que no se actualizaron en fsh014 por regularizaciones
          select nvl(sum(jaql745impo),0) monto, 'regulari'
            from jaql745
           where jaql745pgco = vPgcod
             and jaql745scsu = vScsuc
             and jaql745scmd = vScmda
             and jaql745scpa = vScpap
             and jaql745scct = vSccta
             and jaql745scop = vScoper
             and jaql745scto = vSctope
             and jaql745scsb = vScsbop
             and jaql745scmo = vScmod
             and to_char(jaql745fech, 'yyyymm') = periodo);

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
          select nvl(sum(decode(a.hcodmo, 1, (-1) * hcimp1, hcimp1)),0), 'movs'
            from fsh016 a, fsh015 b
           where a.pgcod = b.pgcod
             and a.hcmod = b.hcmod
             and a.hsucor = b.hsucor
             and a.htran = b.htran
             and a.hnrel = b.hnrel
             and a.hfcon = b.hfcon
             and b.hccorr <> 99
             and a.Hcafgt in ('C', 'P')
             and a.pgcod = vPgcod
             and a.HSUCUR = vScsuc
             and a.HMODUL = vScmod
             and a.HMDA = vScmda
             and a.HPAP = vScpap
             and a.Hcta = vSccta
             and a.HOPER = vScoper
             and a.Hsubop = vScsbop
             and a.HTOPER = vSctope
                --and a.hfcon >= inicio and a.hfcon < vfecini
             and b.hfvc >= inicio
             and b.hfvc < vfecini
             and not exists
           (select 1
                    from fst098
                   where PgCod = a.pgcod
                     and Tpcod = 213
                     and Tpnro = a.hcmod
                     and Tpimp = a.htran)
             and not (a.hcmod = modval and a.htran = TxnVll));

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
          select nvl(sum(decode(a.I1mda,
                            a.I2mda,
                            b.hcimp1,
                            (fn_tipo_cambio(R111fc, I1mda, I2mda, 500)) *
                            hcimp1)),0),
                 'cheques_mes'
            from fsr111 a, fsh016 b, fsh015 c
           Where I2cod = vPgcod
             and I2mod = vScmod
             and I2suc = vScsuc
             and I2mda = vScmda
             and I2pap = vScpap
             and I2cta = vSccta
             and I2oper = vScoper
             and I2sbop = vScsbop
             and I2tope = vSctope
             and Inscod = 3
             and I1cod = 1
             and I1mod = Modche
             and R111co = 'S'
             and R111fc >= inicio
             and R111fc < vfecini
             and b.pgcod = vPgcod
             and I1cod = b.pgcod
             and I1mod = b.hmodul
             and I1suc = b.hsucur
             and I1mda = b.hmda
             and I1pap = b.hpap
             and I1cta = b.hcta
             and I1oper = b.hoper
             and I1sbop = b.hsubop
             and I1tope = b.htoper
             and a.r111mo = b.hcmod
             and a.r111su = b.hsucor
             and a.r111tr = b.htran
             and a.r111re = b.hnrel
             and a.R111fc = b.hfcon
             and c.pgcod = b.pgcod
             and c.hcmod = b.hcmod
             and c.hsucor = b.hsucor
             and c.htran = b.htran
             and c.hnrel = b.hnrel
             and c.hfcon = b.hfcon
             and c.hccorr <> 99);

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
          select nvl(sum(decode(a.I1mda,
                            a.I2mda,
                            b.hcimp1,
                            (fn_tipo_cambio(R111fc, I1mda, I2mda, 500)) *
                            b.hcimp1)),0),
                 'cheques_antes_mes'
            from fsr111 a, fsh016 b, fsh015 c, fsh016 d
           Where I2cod = vPgcod
             and I2mod = vScmod
             and I2suc = vScsuc
             and I2mda = vScmda
             and I2pap = vScpap
             and I2cta = vSccta
             and I2oper = vScoper
             and I2sbop = vScsbop
             and I2tope = vSctope
             and Inscod = 3
             and I1cod = 1
             and I1mod = ModChe
             and R111co = 'S'
             and R111fc >= add_months(inicio, -1)
             and R111fc <= last_day(add_months(inicio, -1))
             and b.pgcod = vPgcod
             and I1cod = b.pgcod
             and I1mod = b.hmodul
             and I1suc = b.hsucur
             and I1mda = b.hmda
             and I1pap = b.hpap
             and I1cta = b.hcta
             and I1oper = b.hoper
             and I1sbop = b.hsubop
             and I1tope = b.htoper
             and a.r111mo = b.hcmod
             and a.r111su = b.hsucor
             and a.r111tr = b.htran
             and a.r111re = b.hnrel
             and a.R111fc = b.hfcon
             and c.pgcod = b.pgcod
             and c.hcmod = b.hcmod
             and c.hsucor = b.hsucor
             and c.htran = b.htran
             and c.hnrel = b.hnrel
             and c.hfcon = b.hfcon
             and c.hccorr <> 99
             and d.pgcod = vPgcod
             and d.Hsucur = I1suc
             and d.Hmodul = I1mod
             and d.Hmda = I1mda
             and d.Hpap = I1pap
             and d.Hcta = I1cta
             and d.Hoper = I1oper
             and d.Hsubop = I1sbop
             and d.Htoper = I1tope
             and d.Hcmod = ModVal
             and d.Htran = TxnVll
             and d.Hfcon >= inicio
             and d.Hfcon < vfecini);

  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
          select nvl(sum(decode(a.hcodmo, 1, (-1) * hcimp1, hcimp1)),0),
                 'itf_cheque'
            from fsh016 a, fsh015 b
           where a.pgcod = b.pgcod
             and a.hcmod = b.hcmod
             and a.hsucor = b.hsucor
             and a.htran = b.htran
             and a.hnrel = b.hnrel
             and a.hfcon = b.hfcon
             and b.hccorr <> 99
             and a.Hcafgt in ('C', 'P')
             and a.pgcod = vPgcod
             and a.HSUCUR = vScsuc
             and a.HMODUL = vScmod
             and a.HMDA = vScmda
             and a.HPAP = vScpap
             and a.Hcta = vSccta
             and a.HOPER = vScoper
             and a.Hsubop = vScsbop
             and a.HTOPER = vSctope
             and a.hfcon >= inicio
             and a.hfcon < vfecini
             and a.hcmod = ModVal
             and a.htran = TxnVll
             and a.hcmcod = ItfChe);
             
  select sum(monto)
    into vSdoor
    from (select vSdoor monto, 'todo lo anterior'
            from dual
          union all
          select nvl(sum(Scsdo), 0), 'cheques_masivo'
            from fsd011
           Where PgCod = vPgcod
             and Scsuc = vScsuc
             and Scrub = Rubro
             and Scmda = vScmda
             and Scpap = vScpap
             and Sccta = vSccta
             and Scoper = vScoper
             and Scsbop = vScsbop
             and Scstat <> 99
             and Scfval < vFecIni);             

end SP_SALDO_ORIGEN_CV;
/

