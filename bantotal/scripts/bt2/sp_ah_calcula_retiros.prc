create or replace procedure sp_ah_calcula_retiros is

  ld_fecpro date;
begin
  begin
       Select a.pgfape into ld_fecpro from fst017 a where a.pgcod = 1;
  exception
  when others then
      ld_fecpro := trunc(sysdate);
  end;
    
     MERGE 
      INTO AQPA121 AA 
     USING(
           select nvl(sum(c.itimp1),0) retiros,
                  c.pgcod, 
                  c.modulo,
                  c.itsucd,
                  c.itsubo,
                  c.ctnro,
                  c.moneda,
                  c.itoper,
                  c.papel, 
                  c.ittope          
             from fsd016 c,
                  fsd015 g,
                  (
                  Select aa.aqpa118apgc,
                         aa.aqpa118amod,
                         aa.aqpa118asuc,
                         aa.aqpa118amda,
                         aa.aqpa118apap,
                         aa.aqpa118acta,
                         aa.aqpa118aope,
                         aa.aqpa118asbo,
                         aa.aqpa118atop,
                         max(aa.aqpa118afde) aqpa118afde                                   
                    from (
                           Select x.aqpa118apgc,
                                  x.aqpa118amod,
                                  x.aqpa118asuc,
                                  x.aqpa118amda,
                                  x.aqpa118apap,
                                  x.aqpa118acta,
                                  x.aqpa118aope,
                                  x.aqpa118asbo,
                                  x.aqpa118atop,
                                  x.aqpa118afde
                             from aqpa118a x 
                            where x.aqpa118apgc = 1
                              and x.aqpa118amod = 21
                              and x.aqpa118amda = 0
                              and x.aqpa118acta >0 
                              and x.aqpa118atde >0 
                              and (x.aqpa118afde + 365) >= ld_fecpro                             
                            union                      
                           Select z.jaql72pgco,   
                                  z.jaql72scmo,
                                  z.jaql72scsu,               
                                  z.jaql72scmd,
                                  z.jaql72scpa,
                                  z.jaql72scct,
                                  z.jaql72scop,
                                  z.jaql72scsb,
                                  z.jaql72scto,
                                  y.jaql71fepr 
                             from jaql071 y, 
                                  jaql072 z,
                                  aqpa124 w
                            where y.jaql71nuim = z.jaql72nuim
                              and z.jaql72nuim = w.aqpa124imp
                              and z.jaql72ax02 > 0
                              and z.jaql72impo > 0
                              and y.jaql71esta = 'P'     
                              and ld_fecpro < case
                                                when z.jaql72ax02 = 1 then
                                                     y.jaql71fepr + 365
                                                when z.jaql72ax02 = 2 then
                                                     y.jaql71fepr + 150                      
                                                Else
                                                     ld_fecpro
                                               end                   
                         ) aa
                         group by aa.aqpa118apgc,
                                  aa.aqpa118amod,
                                  aa.aqpa118asuc,
                                  aa.aqpa118amda,
                                  aa.aqpa118apap,
                                  aa.aqpa118acta,
                                  aa.aqpa118aope,
                                  aa.aqpa118asbo,
                                  aa.aqpa118atop
                  ) h
            where c.pgcod  = g.pgcod
              and c.itmod  = g.itmod
              and c.itsuc  = g.itsuc
              and c.ittran = g.ittran
              and c.itnrel = g.itnrel
              and g.itcont = 'S'
              and g.itcorr <> 99                       
              and c.itdbha = 1      
              and c.pgcod  = 1
              and c.pgcod  = h.aqpa118apgc
              and c.modulo = h.aqpa118amod 
              and c.itsucd = h.aqpa118asuc
              and c.itsubo = h.aqpa118asbo
              and c.ctnro  = h.aqpa118acta
              and c.moneda = h.aqpa118amda
              and c.itoper = h.aqpa118aope
              and c.papel  = h.aqpa118apap
              and c.ittope = h.aqpa118atop  
              --and (h.aqpa118afde + 365) >= ld_fecpro
         group by c.pgcod, 
                  c.modulo,
                  c.itsucd,
                  c.itsubo,
                  c.ctnro,
                  c.moneda,
                  c.itoper,
                  c.papel, 
                  c.ittope   
          ) BB
      ON (      AA.aqpa121fec = ld_fecpro
            and AA.aqpa121pgc = BB.pgcod 
            and AA.aqpa121mod = BB.modulo
            and AA.aqpa121suc = BB.itsucd
            and AA.aqpa121mda = BB.moneda
            and AA.aqpa121pap = BB.papel 
            and AA.aqpa121cta = BB.ctnro
            and AA.aqpa121ope = BB.itoper
            and AA.aqpa121sub = BB.itsubo 
            and AA.aqpa121top = BB.ittope
            and BB.retiros >0
        )   
        WHEN MATCHED THEN   
          UPDATE SET AA.aqpa121tot = BB.RETIROS  
        WHEN NOT MATCHED THEN
          INSERT (aqpa121fec,aqpa121pgc,aqpa121mod,aqpa121suc,aqpa121mda,aqpa121pap,aqpa121cta,aqpa121ope,aqpa121sub,aqpa121top,aqpa121tot
                 )
           VALUES(ld_fecpro,BB.pgcod, BB.modulo,BB.itsucd,BB.moneda,BB.papel,BB.ctnro,BB.itoper,BB.itsubo,BB.ittope,BB.retiros
                 )
        ;
        commit;
exception
  when others then
    null;
end sp_ah_calcula_retiros;
/

