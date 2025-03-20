create or replace procedure SP_AH_ABONO_AFP(P_NUMCCI varchar2,
                                            P_MTODEP number,
                                            P_FECDEP date) is

  -- Author  : MARAUJO
  -- Created : 25/05/2018 05:06:42 p.m.
  -- Purpose : Registro de abonos de AFP

  P_CODRPT number;

  cursor cci is
    select *
      from (select aqpa118aseq,
                   aqpa118acor,
                   aqpa118apgc,
                   aqpa118amod,
                   aqpa118asuc,
                   aqpa118amda,
                   aqpa118apap,
                   aqpa118acta,
                   aqpa118aope,
                   aqpa118asbo,
                   aqpa118atop
              from aqpa118a
             where AQPA118ACCI = P_NUMCCI
               and aqpa118acta <> 0
             order by aqpa118aseq desc, aqpa118acor desc)
     where rownum = 1;

begin
  begin
  
    P_CODRPT := 1; -- no hay datos;
  
    for i in cci loop
      update aqpa118a
         set aqpa118aacu = nvl(aqpa118atde, 0) + P_MTODEP,
             aqpa118atde = P_MTODEP,
             aqpa118afde = decode(aqpa118afde,to_date('01/01/0001','dd/mm/rrrr'),P_FECDEP,aqpa118afde),
             aqpa118aax1 = 0
       where aqpa118aseq = i.aqpa118aseq
         and aqpa118acor = i.aqpa118acor;
      /*    
      begin
        insert into iar001
          (iarspgcod,
           iarsmod,
           iarssuc,
           iarsmda,
           iarspap,
           iarscta,
           iarssope,
           iarsscta,
           iarstope,
           iarssaldo)
        values
          (i.aqpa118apgc,
           i.aqpa118amod,
           i.aqpa118asuc,
           i.aqpa118amda,
           i.aqpa118apap,
           i.aqpa118acta,
           i.aqpa118aope,
           i.aqpa118asbo,
           i.aqpa118atop,
           P_MTODEP);
      
      exception
        when too_many_rows then
          update iar001
             set iarssaldo = nvl(iarssaldo, 0) + P_MTODEP
           where iarspgcod = i.aqpa118apgc
             and iarsmod = i.aqpa118amod
             and iarssuc = i.aqpa118asuc
             and iarsmda = i.aqpa118amda
             and iarspap = i.aqpa118apap
             and iarscta = i.aqpa118acta
             and iarssope = i.aqpa118aope
             and iarsscta = i.aqpa118asbo
             and iarstope = i.aqpa118atop;
      end;*/
      P_CODRPT := 0;
    End Loop;
  exception
    when others then
      P_CODRPT := 2; -- error no controlado
  end;
  if P_CODRPT <> 0 then
    insert into jaqz687
      (JAQZ687PRG, JAQZ687VAR, JAQZ687INS, JAQZ687FEC)
    values
      ('ABONO_AFP', P_NUMCCI, P_CODRPT, P_FECDEP);
  end if;
end SP_AH_ABONO_AFP;
/

