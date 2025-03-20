create or replace package pq_cr_dias_atraso is

   -- Author  : Karen
  -- Created : 19/06/2020 11:47:05
  -- Purpose : calculo de dias de atraso sin considerar los dias de estado de emergencia covid 19
  -- Modificado : KVALENCIAC
  -- Public type declarations
  
   procedure dias_atraso(v_Pgfape  date, --fecha de proceso
                                           v_Pgcod   number,
                                           v_Scmod   number,
                                           v_Scsuc   number,
                                           v_Scmda   number,
                                           v_Scpap   number,
                                           v_Sccta   number,
                                           v_Scoper  number,
                                           v_Scsbop  number,
                                           v_Sctope  number,
                                           v_Scstat  number,
                                           v_fecven  date,
                                           v_diaatr  out number); 

end  pq_cr_dias_atraso;
/

create or replace package body pq_cr_dias_atraso is
procedure dias_atraso(v_Pgfape  date, --fecha de proceso
                                           v_Pgcod   number,
                                           v_Scmod   number,
                                           v_Scsuc   number,
                                           v_Scmda   number,
                                           v_Scpap   number,
                                           v_Sccta   number,
                                           v_Scoper  number,
                                           v_Scsbop  number,
                                           v_Sctope  number,
                                           v_Scstat  number,
                                           v_fecven  date,
                                           v_diaatr out  number) is
 ln_diatr number;
    ln_scstat fsd010.aostat%type;
    
    LN_DIATR_CNGLD number; --2020.04.07
    
  begin
      --If v_Scstat in (64,90) Then 
    If v_Scmod in (200,33) Then 

           ln_diatr := v_Pgfape - v_fecven;
        Else 
          
    --begin

/*    --judicial y castigado, 200 y 33
    select
            (v_Pgfape - jaql166scfvl)
            into ln_diatr
    from
            JAQL166  --JAQL166:Judicial-Castigo
    Where
            jaql166pgcod = v_Pgcod
        and jaql166scmod = v_Scmod
        and jaql166scsuc = v_Scsuc
        and jaql166scmda = v_Scmda
        and jaql166scpap = v_Scpap
        and jaql166sccta = v_Sccta
        and jaql166scope = v_Scoper
        and jaql166scsbo = v_Scsbop
        and jaql166sctop = v_Sctope
        and jaql166nrpag = 0;
        --and jaql166est   = v_Scstat;*/
        

        
/*     select v_Pgfape - c.aofvto--c.aofvto
       into ln_diatr
       from fsd010 c
       where  c.pgcod  = v_Pgcod
          and c.aomod  = v_Scmod
          and c.aosuc  = v_Scsuc
          and c.aomda  = v_Scmda
          and c.aopap  = v_Scpap
          and c.aocta  = v_Sccta
          and c.aooper = v_Scoper
          and c.aosbop = v_Scsbop
          and c.aotope = v_Sctope
          and c.aostat in (64,\*33,*\90); --judicial o castigado    */   

   -- exception
     -- when no_data_found then
        begin
          --vigente y refinanciado
          SELECT (v_Pgfape - min(a.Ppfpag))
                 into ln_diatr 
          FROM FSD601 a left join FSD602 b
          on
                b.Pgcod  = a.Pgcod
            and b.Ppmod  = a.Ppmod
            and b.Ppsuc  = a.Ppsuc
            and b.Ppmda  = a.Ppmda
            and b.Pppap  = a.Pppap
            and b.Ppcta  = a.Ppcta
            and b.Ppoper = a.Ppoper
            and b.Ppsbop = a.Ppsbop
            and b.Pptope = a.Pptope
            and b.Ppfpag = a.Ppfpag
            and b.Pptipo = a.Pptipo
            and b.Pp1stat = 'T'
            and b.D602co  = 'S'
            --and b.pptipo  <> 'K'
            and b.pp1fech<= v_Pgfape
          where
                a.Pgcod  = v_Pgcod
            and a.Ppmod  = v_Scmod
            and a.Ppsuc  = v_Scsuc
            and a.Ppmda  = v_Scmda
            and a.Pppap  = v_Scpap
            and a.Ppcta  = v_Sccta
            and a.Ppoper = v_Scoper
            and a.Ppsbop = v_Scsbop
            and a.Pptope = v_Sctope
            and a.Ppfpag <= v_Pgfape
            and a.D601co = 'S'
            and (a.ppcap + a.ppint ) > 0 --se agrego por cuotas de gracia 2013.09.06
            and b.D602co is null;
      exception
        when no_data_found then
 
          Begin
             select (v_Pgfape - min(d.Ppfpag))
             into ln_diatr
             from fsd601 d
             where     d.Pgcod  = v_Pgcod
            and d.Ppmod  = v_Scmod
            and d.Ppsuc  = v_Scsuc
            and d.Ppmda  = v_Scmda
            and d.Pppap  = v_Scpap
            and d.Ppcta  = v_Sccta
            and d.Ppoper = v_Scoper
            and d.Ppsbop = v_Scsbop
            and d.Pptope = v_Sctope
            and d.Ppfpag <= v_Pgfape
            and (d.ppcap + d.ppint ) > 0;
          exception
              when no_data_found then
                   ln_diatr := null;
          End;
       
      --end;
    end;
    End IF;
    
  v_diaatr:=NVL(ln_diatr,0);
   
 end    dias_atraso;                                       
end  pq_cr_dias_atraso;
/

