CREATE OR REPLACE PROCEDURE SP_URIE_REP_CREDITOS_FALLIDOS
                            ( PD_FECHA IN DATE,
                              PN_CODRES OUT NUMBER,
                              PC_RESULTADO OUT VARCHAR2 )
IS

  ld_pridiames date := add_months(last_day(PD_FECHA),-1) + 1;
  ld_ultdiames date := last_day(PD_FECHA);
  ln_canreg number;

BEGIN

  ln_canreg := 0;
  
  select count(*)
  into ln_canreg
  from JAQL407
  where jaq407fch = ld_ultdiames;
  
  if ln_canreg = 0 then
  
    insert into JAQL407
    select
    bcfech, 
    bcemp,
    bcmod,
    bcsuc,
    bcmda,
    bcpap,
    bccta,
    bcoper,
    bcsbop,
    bctop,
    (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
    lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
    lpad(to_char(bctop), 3, '0')) numcre,
    bcfval,
    bcfvto,
    pepais,
    petdoc,
    pendoc, 
    tdnom,
    penom,
    aoimp,
    sum(bcsdmo),
    sum(bcsdmn), 
    aoperiod,
    aostat,
    scnom,
    ncuopag,
    ndiaatr,
    tipsbs,
    regnom
    from
    (
      select 
      sal.*,
      cta.pepais,
      cta.petdoc,
      cta.pendoc, 
      doc.tdnom,
      ope.aoimp,
      per.penom,
      ope.aoperiod,
      ope.aostat,
      (
        select count(*)
        from fsd601 c
        inner join fsd602 d 
        on c.pgcod = d.pgcod
        and c.ppmod = d.ppmod
        and c.ppsuc = d.ppsuc
        and c.ppmda = d.ppmda
        and c.pppap = d.pppap
        and c.ppcta = d.ppcta
        and c.ppoper = d.ppoper
        and c.ppsbop = d.ppsbop
        and c.pptope = d.pptope
        and c.ppfpag = d.ppfpag
        and d.pp1fech <= ld_ultdiames
        where c.pgcod = sal.bcemp
        and c.ppmod = sal.bcmod
        and c.ppsuc = sal.bcsuc
        and c.ppmda = sal.bcmda
        and c.pppap = sal.bcpap
        and c.ppcta = sal.bccta
        and c.ppoper = sal.bcoper
        and c.ppsbop = sal.bcsbop
        and c.pptope = sal.bctop
        and d.pp1stat = 'T'
        and d.d602co = 'S'
      ) ncuopag,
      age.scnom,    
      case 
      when sal.bcgpo = 2 then 'MICROEMPRESAS'
      when sal.bcgpo = 3 and substr(sal.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
      when sal.bcgpo = 3 and substr(sal.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
      when sal.bcgpo = 4 then 'HIPOTECARIO'
      when sal.bcgpo = 12 then 'MEDIANA EMPRESA'
      when sal.bcgpo = 13 then 'PEQUEÑA EMPRESA'
      when sal.bcgpo in ( 5,6,7,8,9) then 'CORPORATIVO'
      end tipsbs,  
      (
        select reg.regnom from fst811 regsuc
        left join fst810 reg
        on reg.pgcod = regsuc.pgcod
        and reg.regcod= regsuc.regcod  
        where regsuc.pgcod = sal.bcemp
        and regsuc.oficod = sal.bcsuc
        and regsuc.regcod < 100  
        and rownum = 1  
      ) regnom,
      (
        select 
        case
        when min(c.ppfpag) is null then null
        when ld_ultdiames - min(c.ppfpag) < 0 then 0
        else ld_ultdiames - min(c.ppfpag)
        end    
        from fsd601 c
        left outer join fsd602 d 
        on c.pgcod = d.pgcod
        and c.ppmod = d.ppmod
        and c.ppsuc = d.ppsuc
        and c.ppmda = d.ppmda
        and c.pppap = d.pppap
        and c.ppcta = d.ppcta
        and c.ppoper = d.ppoper
        and c.ppsbop = d.ppsbop
        and c.pptope = d.pptope
        and c.ppfpag = d.ppfpag
        and d.pp1stat = 'T'
        and d.d602co = 'S'
        and d.pp1fech <= ld_ultdiames
        where c.pgcod = sal.bcemp
        and c.ppmod = sal.bcmod
        and c.ppsuc = sal.bcsuc
        and c.ppmda = sal.bcmda
        and c.pppap = sal.bcpap
        and c.ppcta = sal.bccta
        and c.ppoper = sal.bcoper
        and c.ppsbop = sal.bcsbop
        and c.pptope = sal.bctop
        and d.pgcod is null  
      ) ndiaatr
      
      from fsh012 sal 
      
      inner join fsd010 ope
      on sal.bcemp = ope.pgcod
      and sal.bcsuc = ope.aosuc
      and sal.bcmda = ope.aomda
      and sal.bcpap = ope.aomda
      and sal.bccta = ope.aocta
      and sal.bcoper = ope.aooper
      and sal.bcsbop = ope.aosbop
      and sal.bctop = ope.aotope
      and sal.bcmod = ope.aomod
      
      inner join fsd450 cam
      on sal.bcemp = cam.cbieemp
      and sal.bcsuc = cam.cbiesuc
      and sal.bcmda = cam.cbiemda
      and sal.bcpap = cam.cbiepap
      and sal.bccta = cam.cbiecta
      and sal.bcoper = cam.cbieope
      and sal.bcsbop = cam.cbiesub
      and sal.bctop = cam.cbietop
      and sal.bcmod = cam.cbiemod
      
      inner join fsr008 cta
      on cta.pgcod = sal.bcemp
      and cta.ctnro = sal.bccta
      and cta.cttfir = 'T'
      
      inner join fst014 doc
      on doc.tdocum = cta.petdoc
      
      inner join fsd001 per
      on per.pepais = cta.pepais
      and per.petdoc = cta.petdoc
      and per.pendoc = cta.pendoc
      
      inner join fst001 age
      on age.pgcod = sal.bcemp
      and age.sucurs = sal.bcsuc
    
      where sal.bcemp = 1
      and sal.bcfech = ld_ultdiames
      and sal.bcrubr 
      in 
      (
        select rubro
          from fsd014
         where (pcnivc in
               (select modulo
                  from fst111
                 where dscod = 50
                   and modulo not in (29, 120, 144,108)))
           and pcimpu = 'S'
           and pmtit <> 9
      )
      
      and ope.aostat in (21,22,23,25,64,99)
      
      and cam.cbiefec between ld_pridiames and ld_ultdiames
      and ( cam.cbietxt1 = 'Cambio de Estado a PJM' or 
            cam.cbietxt1 = 'Cambio de Estado a PJN' )
    )
    where ncuopag <= 6
    group by 
    bcfech, 
    bcemp,
    bcmod,
    bcsuc,
    bcmda,
    bcpap,
    bccta,
    bcoper,
    bcsbop,
    bctop,
    bcfval,
    bcfvto,
    pepais,
    petdoc,
    pendoc, 
    tdnom,
    penom,
    aoimp,
    aoperiod,
    aostat,
    scnom,
    ncuopag,
    ndiaatr,
    tipsbs,
    regnom;
  
    commit;
    PN_CODRES := 0;
    PC_RESULTADO := 'REPORTE GENERADO CORRECTAMENTE AL ' || to_char(ld_ultdiames,'DD/MM/YYYY' || '.');
  
  else
    PN_CODRES := 1;
    PC_RESULTADO := 'Reporte ya fue generado para esta fecha.';  
  end if;

exception
when others then
  PC_RESULTADO := SQLERRM;
  PN_CODRES := SQLCODE;
END;
/

