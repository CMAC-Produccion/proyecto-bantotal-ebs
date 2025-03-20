create or replace package Pq_Cr_ControlesAmpliados is

Procedure Sp_monto_pagado(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_mto out number);
Procedure Sp_saldo (pn_ins in number,
                    pn_mtoOtor out number,
                    pn_mtoPaga out number,
                    pn_porcent out number);

end Pq_Cr_ControlesAmpliados;
/

create or replace package body Pq_Cr_ControlesAmpliados is



Procedure Sp_monto_pagado(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_mto out number)is


ln_salcap number(17,2) := 0;
ld_fecpro date;
ld_fectran date;
begin
  
    begin
        select a.pgfape
          into ld_fecpro
          from fst017 a
         where a.pgcod = 1;
    exception 
         when others then null;
    end;
    
    if pn_mod = 116 then 
          --capital pagado
          
          begin
               
            select max(a.d602fc)
              into ld_fectran
              from fsd602 a
             where a.pgcod   = pn_emp
               and a.ppmod   = pn_mod
               and a.ppsuc   = pn_suc
               and a.ppmda   = pn_mda
               and a.pppap   = pn_pap
               and a.ppcta   = pn_cta
               and a.ppoper  = pn_ope
               and a.ppsbop  = pn_sbo
               and a.pptope  = pn_top
               and a.d602co  = 'S'
               and (a.d602mo,a.d602tr) = (select 116,60 from dual)
               --and a.pp1cap  > 0
               and a.ppfpag  <= ld_fecpro;
          
          exception
            when others then
              ld_fectran := null;
          end;
          
          if ld_fectran is null then 
          
          begin
          select sum(a.pp1cap)
              into ln_salcap
              from fsd602 a
             where a.pgcod   = pn_emp
               and a.ppmod   = pn_mod
               and a.ppsuc   = pn_suc
               and a.ppmda   = pn_mda
               and a.pppap   = pn_pap
               and a.ppcta   = pn_cta
               and a.ppoper  = pn_ope
               and a.ppsbop  = pn_sbo
               and a.pptope  = pn_top
               and a.d602co  = 'S'
               and a.ppfpag  <= ld_fecpro;
          end;
          
          else 
          
          begin
               
            select sum(a.pp1cap)
              into ln_salcap
              from fsd602 a
             where a.pgcod   = pn_emp
               and a.ppmod   = pn_mod
               and a.ppsuc   = pn_suc
               and a.ppmda   = pn_mda
               and a.pppap   = pn_pap
               and a.ppcta   = pn_cta
               and a.ppoper  = pn_ope
               and a.ppsbop  = pn_sbo
               and a.pptope  = pn_top
               and a.d602co  = 'S'
               and (a.d602mo,a.d602tr) not in  (select 116,60 from dual)
               --and a.pp1cap  > 0
               and a.ppfpag  <= ld_fecpro
               and a.d602fc  >= ld_fectran;
          
          exception
            when others then
              ln_salcap := 0;
          end;
          
          end if;
          
          else
                   --capital pagado
                    begin
                         
                      select sum(a.pp1cap)
                        into ln_salcap
                        from fsd602 a
                       where a.pgcod   = pn_emp
                         and a.ppmod   = pn_mod
                         and a.ppsuc   = pn_suc
                         and a.ppmda   = pn_mda
                         and a.pppap   = pn_pap
                         and a.ppcta   = pn_cta
                         and a.ppoper  = pn_ope
                         and a.ppsbop  = pn_sbo
                         and a.pptope  = pn_top
                         --and a.pp1stat = 'T'
                         and a.d602co  = 'S'
                         --and a.pp1cap  > 0
                         and a.ppfpag  <= ld_fecpro;
                    
                    exception
                      when others then
                        ln_salcap := 0;
                    end;     
    end if;
    pn_mto := ln_salcap;

end Sp_monto_pagado;

Procedure Sp_saldo (pn_ins in number,
                    pn_mtoOtor out number,
                    pn_mtoPaga out number,
                    pn_porcent out number)is

cursor lineas is
select a.jaqy800pgcd ln_empL,
       a.jaqy800mod  ln_modL,
       a.jaqy800suc  ln_sucL,
       a.jaqy800mda  ln_mdaL, 
       a.jaqy800pap  ln_papL,
       a.jaqy800cta  ln_ctaL,
       a.jaqy800ope  ln_opeL,
       a.jaqy800sbop ln_sboL,
       a.jaqy800tope ln_topL
  from jaqy800 a
 where a.jaqy800pgcd = 1 
 and a.jaqy800ins = pn_ins
   and a.jaqy800vinc = 'S';

cursor utilizacion(cn_empL in number,
                   cn_modL in number,
                   cn_sucL in number,
                   cn_mdaL in number,
                   cn_papL in number,
                   cn_ctaL in number,
                   cn_opeL in number,
                   cn_sboL in number,
                   cn_topL in number) is

select a.r1cod,
       a.r1mod,
       a.r1suc,
       a.r1mda,
       a.r1pap,
       a.r1cta,
       a.r1oper,
       a.r1sbop,
       a.r1tope
  from fsr011 a, fsd011 b 
 where a.r2cod  = cn_empL
   and a.r2mod  = cn_modL
   and a.r2suc  = cn_sucL
   and a.r2mda  = cn_mdaL
   and a.r2pap  = cn_papL
   and a.r2cta  = cn_ctaL
   and a.r2oper = cn_opeL
   and a.r2sbop = cn_sboL
   and a.r2tope = cn_topL
   and a.relcod = 46 
   and a.r1cod  = b.pgcod
   and a.r1mod  = b.scmod
   and a.r1suc  = b.scsuc
   and a.r1mda  = b.scmda
   and a.r1pap  = b.scpap
   and a.r1cta  = b.sccta
   and a.r1oper = b.scoper
   and a.r1sbop = b.scsbop
   and a.r1tope = b.sctope
   and b.scstat <> 99 ;
   
               
lc_flgLinea char(1)   := 'N';
ln_mod      number(3);
ln_mto      number(17,2) := 0;
ln_mtoTot   number(17,2) := 0;
ln_mtoOtor  number(17,2) := 0;
ln_mtoOtorT number(17,2) := 0;
ln_empA     number(3);
ln_modA     number(3);
ln_sucA     number(3);
ln_mdaA     number(4);
ln_papA     number(4);
ln_ctaA     number(9);
ln_opeA     number(9);
ln_sboA     number(3);
ln_topA     number(3);
ln_porcentaje number(10);
ln_ori        number(2);
ln_instancia number(10);

begin
              
     --verificacion si es linea
     begin
         select a.xwfmodulo
           into ln_mod
           from xwf700 a
          where a.xwfprcins = pn_ins
            and a.xwfcar3   = '1' ;
     
     exception
         when others then null;
     end;
     
     
     
     if ln_mod = 117 then
         --verifica si tiene vinculacion de linea
         begin
          select 'S'
            into lc_flgLinea
            from jaqy800 a
           where a.jaqy800pgcd = 1  
           and a.jaqy800ins  = pn_ins
             and a.jaqy800vinc = 'S'
             and rownum        = 1;
         exception
             when others then 
                  lc_flgLinea := 'N';
         end;
         
         
         if lc_flgLinea = 'S' then
         
             for i in lineas loop
                 ln_mto := 0;
                 
                 -----obtener monto otorgado
                 begin
                    select a.scsdo
                      into ln_mtoOtor
                      from fsd011 a
                     where a.pgcod  = i.ln_empL
                       and a.scmod  = i.ln_modL
                       and a.scsuc  = i.ln_sucL
                       and a.scmda  = i.ln_mdaL
                       and a.scpap  = i.ln_papL
                       and a.sccta  = i.ln_ctaL
                       and a.scoper = i.ln_opeL
                       and a.scsbop = i.ln_sboL
                       and a.sctope = i.ln_topL;
                 exception
                       when others then ln_mtoOtor := 0;         
                 end;
                 
                 ln_mtoOtorT := ln_mtoOtorT + nvl(ln_mtoOtor,0) ;
                 
                 ---obtner monto utilizado
                 for j in utilizacion(i.ln_empL,
                                      i.ln_modL,
                                      i.ln_sucL,
                                      i.ln_mdaL,
                                      i.ln_papL,
                                      i.ln_ctaL,
                                      i.ln_opeL,
                                      i.ln_sboL,
                                      i.ln_topL) loop
                     ln_mto := 0;                 
                     Pq_cr_controlesAmpliados.Sp_monto_pagado(j.r1cod,
                                                           j.r1mod,
                                                           j.r1suc,
                                                           j.r1mda,
                                                           j.r1pap,
                                                           j.r1cta,
                                                           j.r1oper,
                                                           j.r1sbop,
                                                           j.r1tope,
                                                           ln_mto);
                     ln_mtoTot := ln_mtoTot + nvl(ln_mto,0);
                 
                 end loop;
                 
             
             end loop;
         
             pn_mtoOtor := ln_mtoOtorT;
             pn_mtoPaga := ln_mtoTot;
            
         end if;
         
         else
         
         --obtiene credito a cancelar
         begin
             select a.xwfempresa,
                    a.xwfmodulo,
                    a.xwfsucursal,
                    a.xwfmoneda,
                    a.xwfpapel,
                    a.xwfcuenta,
                    a.xwfoperacion,
                    a.xwfsubope,
                    a.xwftipope 
               into ln_empA,
                    ln_modA,
                    ln_sucA,
                    ln_mdaA,
                    ln_papA,
                    ln_ctaA,
                    ln_opeA,
                    ln_sboA,
                    ln_topA
               from xwf700 a
              where a.xwfprcins = pn_ins
                and a.xwfcar3   <> '1';
         exception
            when others then null;      
         end;
         
         ln_instancia := fn_instancia_credito(ln_modA,
                                              ln_sucA,
                                              ln_mdaA,
                                              ln_papA,
                                              ln_ctaA,
                                              ln_opeA,
                                              ln_sboA,
                                              ln_topA);
                                              
        --tipo de solicitud
         begin
            select a.sng001ori
              into ln_ori
              from sng001 a
             where a.sng001inst = ln_instancia;
         exception
             when others then null;
         end;
                                                   
                                              
         
         if ln_ori = 7 then
         
            begin
                select sum(a.sng002mon)
                  into ln_mtoOtor
                  from sng002 a
                 where a.sng001inst = ln_instancia;
            exception
                 when others then null;
            end;
            
            ln_mtoOtorT := ln_mtoOtorT + nvl(ln_mtoOtor,0) ;
            
            Pq_cr_controlesAmpliados.Sp_monto_pagado(ln_empA,
                                                       ln_modA,
                                                       ln_sucA,
                                                       ln_mdaA,
                                                       ln_papA,
                                                       ln_ctaA,
                                                       ln_opeA,
                                                       ln_sboA,
                                                       ln_topA,
                                                       ln_mto);
                 
                 
                 ln_mtoTot := ln_mtoTot + nvl(ln_mto,0);
                 
                 
                 pn_mtoOtor := ln_mtoOtorT;
                 pn_mtoPaga := ln_mtoTot;    
                 
         
             else
                 
                 
                 ln_mto := 0; 
                 
                 -----obtener monto otorgado
                 begin
                    select a.aoimp
                      into ln_mtoOtor
                      from fsd010 a
                     where a.pgcod  = ln_empA
                       and a.aomod  = ln_modA
                       and a.aosuc  = ln_sucA
                       and a.aomda  = ln_mdaA
                       and a.aopap  = ln_papA
                       and a.aocta  = ln_ctaA
                       and a.aooper = ln_opeA
                       and a.aosbop = ln_sboA
                       and a.aotope = ln_topA;
                 exception
                       when others then ln_mtoOtor := 0;         
                 end;
                         
                 ln_mtoOtorT := ln_mtoOtorT + nvl(ln_mtoOtor,0) ;
                 
                 Pq_cr_controlesAmpliados.Sp_monto_pagado(ln_empA,
                                                       ln_modA,
                                                       ln_sucA,
                                                       ln_mdaA,
                                                       ln_papA,
                                                       ln_ctaA,
                                                       ln_opeA,
                                                       ln_sboA,
                                                       ln_topA,
                                                       ln_mto);
                 
                 
                 ln_mtoTot := ln_mtoTot + nvl(ln_mto,0);
                 
                 
                 pn_mtoOtor := ln_mtoOtorT;
                 pn_mtoPaga := ln_mtoTot;    
         end if;
     end if;
     
     begin
     if pn_mtoOtor > 0 then
        ln_porcentaje := (pn_mtoPaga * 100)/pn_mtoOtor;
        
        else
             ln_porcentaje := 0;
     end if;
     
     pn_porcent := ln_porcentaje ;
     
     end;
end Sp_saldo;

end Pq_Cr_ControlesAmpliados;
/

