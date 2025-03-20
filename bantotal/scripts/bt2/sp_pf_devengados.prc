create or replace procedure SP_PF_DEVENGADOS(P_Pgcod   in number,
                                             P_Scsuc   in number,
                                             P_ScMod   in number,
                                             P_Scmda   in number,
                                             P_Scpap   in number,
                                             P_Sccta   in number,
                                             P_Scoper  in number,
                                             P_Scsbop  in number,
                                             P_Sctope  in number,
                                             P_Fecini  in date,
                                             P_Fecfin  in date,
                                             P_Usuario in varchar2,
                                             P_Trace   in varchar2,
                                             P_Correl  in out number,
                                             P_msgerr  out varchar2) is

  vJAQY220USU char(10) := P_Usuario;

  vJAQY220FMV date;
  vJAQY220CCT char(30);
  vJAQY220DEP number(18, 2);
  vJAQY220RET number(18, 2);
  vJAQY220OPE char(10);
  vJAQY220AGE char(30);
  vtipoa      char(1);
  vJAQY220TSU number(3);
  vJAQY220TMO number(3);
  vJAQY220TTR number(3);
  vJAQY220TRE number(4);
  vJAQY220TOR number(2);
  vJAQY220TSB number(4);
  vscfval     date;
  vcorrel     number(4) := P_Correl;
  
  ld_fecmax date;

  cursor dev is
  
    Select hora,
           fecha,
           concepto,
           sum(egreso) egreso,
           sum(ingreso) ingreso,
           itsuc,
           itmod,
           ittran,
           max(itnrel) itnrel,
           itfval,
           modulo,
           max(usuario) usuario,
           max(ordinal) ordinal,
           max(sbord) sbord
      from (
            
            Select '23:59:59' hora,
                    aa.fecfin fecha,
                    'Devengamiento Plazo' concepto,
                    sum(decode(bb.hcodmo, 1, bb.hcimp1, 0)) egreso,
                    sum(decode(bb.hcodmo, 2, bb.hcimp1, 0)) ingreso,
                    904 itsuc,
                    99 itmod,
                    900 ittran,
                    max(c.hnrel) itnrel,
                    aa.fecfin itfval,
                    426 modulo,
                    max(husing) usuario,
                    max(hcord) ordinal,
                    max(hcsubo) sbord
            
              from (Select b.pgcod,
                            b.ppcta,
                            b.ppoper,
                            b.pp1fech fecini,
                            a.pp1fech fecfin
                       from (select pgcod,
                                    ppmod,
                                    ppcta,
                                    ppoper,
                                    pp1fech,
                                    rownum Pp1nump
                               from (select *
                                       from (Select x.pgcod, -- todos los retiros y renovaciones -1
                                                    x.ppmod,
                                                    x.ppcta,
                                                    x.ppoper,
                                                    x.pp1fech - 1 pp1fech
                                               from fsd602 x
                                              where pgcod = p_pgcod
                                                and ppmod = p_scmod
                                                and ppsuc = p_scsuc
                                                and ppmda = p_scmda
                                                and pppap = p_scpap
                                                and ppcta = p_sccta
                                                and ppoper = p_scoper
                                                   --and ppsbop= p_scsbop
                                                and pptope = p_sctope
                                                and D602CO = 'S'
                                                and x.pp1fech <> vscfval
                                              order by Pp1nump)
                                     union
                                     
                                     Select p_pgcod, --el último día de devengado
                                            p_scmod,
                                            p_sccta,
                                            p_scoper,
                                            ld_fecmax -- se comentó //p_fecfin --- 1 -- -se comento el  -1 para que tome el devengado hasta el mismo dia
                                       from dual
                                     
                                     union
                                     
                                     SELECT distinct p_pgcod,
                                                     p_scmod,
                                                     p_sccta,
                                                     p_scoper,
                                                     (last_day((vscfval + rownum - 1))) AS dias_del_mes
                                       FROM DUAL --where 1=2
                                     CONNECT BY LEVEL <=
                                                (SELECT TRUNC(sysdate - vscfval)
                                                   FROM DUAL)
                                     
                                     )) a,
                            (select pgcod,
                                    ppmod,
                                    ppcta,
                                    ppoper,
                                    pp1fech,
                                    rownum - 1 Pp1nump
                               from (Select y.pgcod,
                                            y.aomod  ppmod,
                                            y.aocta  ppcta,
                                            y.aooper ppoper,
                                            y.aofval pp1fech
                                       from fsd010 y
                                      where pgcod = p_pgcod
                                        and aomod = p_scmod
                                        and aosuc = p_scsuc
                                        and aomda = p_scmda
                                        and aopap = p_scpap
                                        and aocta = p_sccta
                                        and aooper = p_scoper
                                           --and aosbop= p_scsbop
                                        and aotope = p_sctope
                                     union
                                     
                                     select *
                                       from (Select x.pgcod,
                                                    x.ppmod,
                                                    x.ppcta,
                                                    x.ppoper,
                                                    x.pp1fech pp1fech
                                               from fsd602 x
                                              where pgcod = p_pgcod
                                                and ppmod = p_scmod
                                                and ppsuc = p_scsuc
                                                and ppmda = p_scmda
                                                and pppap = p_scpap
                                                and ppcta = p_sccta
                                                and ppoper = p_scoper
                                                   --and ppsbop= p_scsbop
                                                and pptope = p_sctope
                                                and D602CO = 'S'
                                                and x.pp1fech <> vscfval
                                              order by Pp1nump)
                                     union
                                     
                                     Select x.pgcod,
                                            x.ppmod,
                                            x.ppcta,
                                            x.ppoper,
                                            max(x.pp1fech) pp1fech
                                       from fsd602 x
                                      where pgcod = p_pgcod
                                        and ppmod = p_scmod
                                        and ppsuc = p_scsuc
                                        and ppmda = p_scmda
                                        and pppap = p_scpap
                                        and ppcta = p_sccta
                                        and ppoper = p_scoper
                                           --and ppsbop= p_scsbop
                                        and pptope = p_sctope
                                        and D602CO = 'S'
                                        and x.pp1fech <> vscfval
                                      group by pgcod,
                                               ppmod,
                                               ppsuc,
                                               ppmda,
                                               pppap,
                                               ppcta,
                                               ppoper,
                                               --ppsbop,
                                               pptope
                                     
                                     union
                                     
                                     SELECT distinct p_pgcod,
                                                     p_scmod,
                                                     p_sccta,
                                                     p_scoper,
                                                     (last_day((vscfval + rownum - 1))) + 1 AS dias_del_mes
                                       FROM DUAL --where 1=2
                                     CONNECT BY LEVEL <=
                                                (SELECT TRUNC(sysdate - vscfval)
                                                   FROM DUAL)
                                     
                                     --and y.aostat <> 99    
                                     )) b
                      where a.pgcod = b.pgcod
                        and a.ppmod = b.ppmod
                        and a.ppcta = b.ppcta
                        and a.ppoper = b.ppoper
                        and a.pp1nump = (b.Pp1nump + 1)) aa,
                    fsh016 bb,
                    fsh015 c
             where aa.pgcod = bb.pgcod
               and aa.ppcta = bb.hcta
               and aa.ppoper = bb.hoper
               and bb.hcmod = 99
               and bb.htran = 900
                  --and bb.hfcon between aa.fecini and aa.fecfin
               and bb.hfval between aa.fecini and aa.fecfin
               and bb.hmodul = 426
               and bb.hcta = p_sccta
               and bb.hoper = p_scoper
               and bb.hcafgt in ('C', 'P')
               and Hcmcod = 0
               and bb.pgcod = c.pgcod
               and bb.hcmod = c.hcmod
               and bb.hsucor = c.hsucor
               and bb.htran = c.htran
               and bb.hnrel = c.hnrel
               and bb.hfcon = c.hfcon
             group by aa.pgcod, aa.ppcta, aa.ppoper, aa.fecini, aa.fecfin
            
            UNION
            
            Select '23:59:59' hora,
                    aa.fecfin fecha,
                    'Devengamiento Plazo' concepto,
                    sum(decode(bb.ITDBHA, 1, bb.itimp1, 0)) egreso,
                    sum(decode(bb.ITDBHA, 2, bb.itimp1, 0)) ingreso,
                    904 itsuc,
                    99 itmod,
                    900 ittran,
                    max(c.itnrel) itnrel,
                    aa.fecfin itfval,
                    426 modulo,
                    max(ituing) usuario,
                    max(itord) ordinal,
                    max(itsbor) sbord
            
              from (Select b.pgcod,
                            b.ppcta,
                            b.ppoper,
                            b.pp1fech fecini,
                            a.pp1fech fecfin
                       from (select pgcod,
                                    ppmod,
                                    ppcta,
                                    ppoper,
                                    pp1fech,
                                    rownum Pp1nump
                               from (select *
                                       from (Select x.pgcod, -- todos los retiros y renovaciones -1
                                                    x.ppmod,
                                                    x.ppcta,
                                                    x.ppoper,
                                                    x.pp1fech - 1 pp1fech
                                               from fsd602 x
                                              where pgcod = p_pgcod
                                                and ppmod = p_scmod
                                                and ppsuc = p_scsuc
                                                and ppmda = p_scmda
                                                and pppap = p_scpap
                                                and ppcta = p_sccta
                                                and ppoper = p_scoper
                                                   --and ppsbop= p_scsbop
                                                and pptope = p_sctope
                                                and D602CO = 'S'
                                                and x.pp1fech <> vscfval
                                              order by Pp1nump)
                                     union
                                     
                                     Select p_pgcod, --el último día de devengado
                                            p_scmod,
                                            p_sccta,
                                            p_scoper,
                                            ld_fecmax -- se comentó //p_fecfin --- 1 -- -se comento el  -1 para que tome el devengado hasta el mismo dia
                                       from dual
                                     
                                     union
                                     
                                     SELECT distinct p_pgcod,
                                                     p_scmod,
                                                     p_sccta,
                                                     p_scoper,
                                                     (last_day((vscfval + rownum - 1))) AS dias_del_mes
                                       FROM DUAL --where 1=2
                                     CONNECT BY LEVEL <=
                                                (SELECT TRUNC(sysdate - vscfval)
                                                   FROM DUAL)
                                     
                                     )) a,
                            (select pgcod,
                                    ppmod,
                                    ppcta,
                                    ppoper,
                                    pp1fech,
                                    rownum - 1 Pp1nump
                               from (Select y.pgcod,
                                            y.aomod  ppmod,
                                            y.aocta  ppcta,
                                            y.aooper ppoper,
                                            y.aofval pp1fech
                                       from fsd010 y
                                      where pgcod = p_pgcod
                                        and aomod = p_scmod
                                        and aosuc = p_scsuc
                                        and aomda = p_scmda
                                        and aopap = p_scpap
                                        and aocta = p_sccta
                                        and aooper = p_scoper
                                           --and aosbop= p_scsbop
                                        and aotope = p_sctope
                                     union
                                     
                                     select *
                                       from (Select x.pgcod,
                                                    x.ppmod,
                                                    x.ppcta,
                                                    x.ppoper,
                                                    x.pp1fech pp1fech
                                               from fsd602 x
                                              where pgcod = p_pgcod
                                                and ppmod = p_scmod
                                                and ppsuc = p_scsuc
                                                and ppmda = p_scmda
                                                and pppap = p_scpap
                                                and ppcta = p_sccta
                                                and ppoper = p_scoper
                                                   --and ppsbop= p_scsbop
                                                and pptope = p_sctope
                                                and D602CO = 'S'
                                                and x.pp1fech <> vscfval
                                              order by Pp1nump)
                                     union
                                     
                                     Select x.pgcod,
                                            x.ppmod,
                                            x.ppcta,
                                            x.ppoper,
                                            max(x.pp1fech) pp1fech
                                       from fsd602 x
                                      where pgcod = p_pgcod
                                        and ppmod = p_scmod
                                        and ppsuc = p_scsuc
                                        and ppmda = p_scmda
                                        and pppap = p_scpap
                                        and ppcta = p_sccta
                                        and ppoper = p_scoper
                                           --and ppsbop= p_scsbop
                                        and pptope = p_sctope
                                        and D602CO = 'S'
                                        and x.pp1fech <> vscfval
                                      group by pgcod,
                                               ppmod,
                                               ppsuc,
                                               ppmda,
                                               pppap,
                                               ppcta,
                                               ppoper,
                                               --ppsbop,
                                               pptope
                                     
                                     union
                                     
                                     SELECT distinct p_pgcod,
                                                     p_scmod,
                                                     p_sccta,
                                                     p_scoper,
                                                     (last_day((vscfval + rownum - 1))) + 1 AS dias_del_mes
                                       FROM DUAL --where 1=2
                                     CONNECT BY LEVEL <=
                                                (SELECT TRUNC(sysdate - vscfval)
                                                   FROM DUAL)
                                     
                                     --and y.aostat <> 99    
                                     )) b
                      where a.pgcod = b.pgcod
                        and a.ppmod = b.ppmod
                        and a.ppcta = b.ppcta
                        and a.ppoper = b.ppoper
                        and a.pp1nump = (b.Pp1nump + 1)) aa,
                    fsd016 bb,
                    fsd015 c
             where aa.pgcod = bb.pgcod
               and aa.ppcta = bb.ctnro
               and aa.ppoper = bb.itoper
               and bb.itmod = 99
               and bb.ittran = 900
               and c.itfvc between aa.fecini and aa.fecfin
               and bb.modulo = 426
               and bb.ctnro = p_sccta
               and bb.itoper = p_scoper
               and bb.ITAFGT in ('C', 'P')
               and ITCODM = 0
               and ITCONT in ('S', 'P')
               and itcorr = 0
               and bb.pgcod = c.pgcod
               and bb.itmod = c.itmod
               and bb.itsuc = c.itsuc
               and bb.ittran = c.ittran
               and bb.itnrel = c.itnrel
             group by aa.pgcod, aa.ppcta, aa.ppoper, aa.fecini, aa.fecfin)
     group by hora, fecha, concepto, itsuc, itmod, ittran, itfval, modulo
     order by fecha, hora;

  v_fecpri  date;
  ld_fecape date;

begin
  P_msgerr := '';

  begin
    select pgfape into ld_fecape from fst017 where pgcod = P_Pgcod;
  exception
    when others then
      ld_fecape := trunc(sysdate);
  end;
  
  if p_fecfin < ld_fecape then
    ld_fecmax := p_fecfin;
  else    
    ld_fecmax := ld_fecape - 1;  
  end if;  

  v_fecpri := to_date('01/' || to_char(p_fecini, 'mm') || '/' ||
                      to_char(p_fecini, 'yyyy'),
                      'dd/mm/yyyy');

  select min(aofval)
    into vscfval
    from fsd010
   where pgcod = p_pgcod
     and aomod = p_scmod
     and aosuc = p_scsuc
     and aomda = p_scmda
     and aopap = p_scpap
     and aocta = p_sccta
     and aooper = p_scoper
        -- and aosbop = p_scsbop
     and aotope = p_sctope;

  for i in dev loop
    vJAQY220FMV := i.fecha;
    vJAQY220CCT := i.concepto;
    vJAQY220DEP := i.ingreso;
    vJAQY220RET := i.egreso;
    vJAQY220OPE := i.usuario;
  
    select lpad(trim(to_char(i.itsuc)), 3, '0') || '-' || Scnomr
      into vJAQY220AGE
      from FST001
     Where PgCod = P_Pgcod
       and Sucurs = i.itsuc;
  
    vtipoa := 'H';
  
    vJAQY220TSU := i.itsuc;
    vJAQY220TMO := i.itmod;
    vJAQY220TTR := i.ittran;
    vJAQY220TRE := i.itnrel;
    vJAQY220TOR := i.ordinal;
    vJAQY220TSB := i.sbord;
  
    if vJAQY220FMV >= v_fecpri and vJAQY220FMV <= p_fecfin then
      -- p_fecini-1
    
      vcorrel := vcorrel + 1;
    
      insert into jaqy220
        (JAQY220COR,
         JAQY220USU,
         JAQY220MOV,
         JAQY220FMV,
         JAQY220CCT,
         JAQY220DSC,
         JAQY220DEP,
         JAQY220RET,
         JAQY220OPE,
         JAQY220AGE,
         JAQY220HOR,
         JAQY220OMD,
         JAQY220CH1,
         JAQY220CH2,
         JAQY220NU1,
         JAQY220TSU,
         JAQY220TMO,
         JAQY220TTR,
         JAQY220TRE,
         JAQY220TOR,
         JAQY220TSB)
      values
        (vCorrel,
         vJAQY220USU,
         '99-900',
         vJAQY220FMV,
         vJAQY220CCT,
         'Devengamiento Plazo',
         vJAQY220DEP,
         vJAQY220RET,
         vJAQY220OPE,
         vJAQY220AGE,
         '23:59:59',
         '1',
         vtipoa,
         P_Trace,
         426,
         vJAQY220TSU,
         vJAQY220TMO,
         vJAQY220TTR,
         vJAQY220TRE,
         vJAQY220TOR,
         vJAQY220TSB);
    
    end if;
  end loop;

  P_Correl := vCorrel;
  commit;

exception
  when others then
    P_msgerr := sqlerrm;
end SP_PF_DEVENGADOS;
/

