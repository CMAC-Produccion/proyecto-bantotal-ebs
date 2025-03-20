create or replace procedure sp_cr_fecdes(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                    pn_pap in number, pn_cta in number, pn_oper in number,
                    pn_sbop in number,pn_top in number, pd_fecdes out date)  is

ld_fecdes date;                    
Begin
   ld_fecdes := null;
   if  pn_mod not in (116,117,200) then 
       if pn_top not in (550)  then 
           Begin
            select a.aofval 
              into ld_fecdes
              from fsd010 a     
             where a.pgcod    = pn_emp
               and a.aomod    = pn_mod
               and a.aosuc    = pn_suc 
               and a.aomda    = pn_mda 
               and a.aopap    = pn_pap 
               and a.aocta    = pn_cta 
               and a.aooper   = pn_oper
               and a.aosbop   = pn_sbop
               and a.aotope   = pn_top;
           exception
              when others then
                   ld_fecdes := null;
           end;       
       else
           begin
             select min(b.aofval)
               into ld_fecdes 
               from fsr011 a, fsd010 b
              where a.relcod = 52
                and a.R2MOD   = pn_mod
                and a.R2CTA  = pn_cta
                and a.R2OPER = pn_oper
                and a.R2SBOP = pn_sbop
                and a.R2COD   = pn_emp
                and a.R2SUC   = pn_suc
                and a.R2MDA   = pn_mda
                and a.R2PAP   = pn_pap
                and a.R2TOPE = pn_top
                and a.R011CO = 'S'
                and a.R1COD   = b.pgcod
                and a.R1MOD  = b.aomod
                and a.R1SUC  = b.aosuc
                and a.R1MDA  = b.aomda
                and a.R1PAP  = b.aopap
                and a.R1CTA  = b.aocta
                and a.R1OPER= b.aooper
                and a.R1SBOP= b.aosbop
                and a.R1TOPE= b.aotope;
           exception
             when others then
                ld_fecdes := null;
           end;  
       end if;
    elsif pn_mod in (117)  then
       begin
         select min(b.aofval)
           into ld_fecdes 
           from fsr011 a, fsd010 b
          where a.relcod = 46 
            and a.R2MOD   = pn_mod
            and a.R2CTA  = pn_cta
            and a.R2OPER = pn_oper
            and a.R2SBOP = pn_sbop
            and a.R2COD   = pn_emp
            and a.R2SUC   = pn_suc
            and a.R2MDA   = pn_mda
            and a.R2PAP   = pn_pap
            and a.R2TOPE = pn_top
            and a.R011CO = 'S'
            and a.R1COD   = b.pgcod
            and a.R1MOD  = b.aomod
            and a.R1SUC  = b.aosuc
            and a.R1MDA  = b.aomda
            and a.R1PAP  = b.aopap
            and a.R1CTA  = b.aocta
            and a.R1OPER= b.aooper
            and a.R1SBOP= b.aosbop
            and a.R1TOPE= b.aotope;
       exception
         when others then
            ld_fecdes := null;
       end;  
     elsif pn_mod in (116)  then
       begin
         select min(b.aofval)
           into ld_fecdes 
           from fsr011 a, fsd010 b, fsr011 p
          where a.relcod = 46 
            and a.R1MOD   = pn_mod
            and a.R1CTA  = pn_cta
            and a.R1OPER = pn_oper
            and a.R1SBOP = pn_sbop
            and a.R1COD   = pn_emp
            and a.R1SUC   = pn_suc
            and a.R1MDA   = pn_mda
            and a.R1PAP   = pn_pap
            and a.R1TOPE = pn_top
            and a.R011CO = 'S'
            and a.R2COD  = p.R2COD  
            and a.R2MOD  = p.R2MOD  
            and a.R2SUC  = p.R2SUC  
            and a.R2MDA  = p.R2MDA  
            and a.R2PAP  = p.R2PAP  
            and a.R2CTA  = p.R2CTA  
            and a.R2OPER = p.R2OPER 
            and a.R2SBOP = p.R2SBOP 
            and a.R2TOPE = p.R2TOPE
            and p.R011CO = 'S'
            and p.relcod = 46
            and p.R1COD  = b.pgcod
            and p.R1MOD  = b.aomod
            and p.R1SUC  = b.aosuc
            and p.R1MDA  = b.aomda
            and p.R1PAP  = b.aopap
            and p.R1CTA  = b.aocta
            and p.R1OPER = b.aooper
            and p.R1SBOP = b.aosbop
            and p.R1TOPE = b.aotope
            
            
            ;
       exception
         when others then
            ld_fecdes := null;
       end;  
      
     elsif pn_mod in (200) or  pn_top  in (550) then
       begin
         select min(b.aofval)
           into ld_fecdes 
           from fsr011 a, fsd010 b
          where a.relcod = 52
            and a.R2MOD   = pn_mod
            and a.R2CTA  = pn_cta
            and a.R2OPER = pn_oper
            and a.R2SBOP = pn_sbop
            and a.R2COD   = pn_emp
            and a.R2SUC   = pn_suc
            and a.R2MDA   = pn_mda
            and a.R2PAP   = pn_pap
            and a.R2TOPE = pn_top
            and a.R011CO = 'S'
            and a.R1COD   = b.pgcod
            and a.R1MOD  = b.aomod
            and a.R1SUC  = b.aosuc
            and a.R1MDA  = b.aomda
            and a.R1PAP  = b.aopap
            and a.R1CTA  = b.aocta
            and a.R1OPER= b.aooper
            and a.R1SBOP= b.aosbop
            and a.R1TOPE= b.aotope;
       exception
         when others then
            ld_fecdes := null;
       end;  
    end if;   
    pd_fecdes := ld_fecdes;
end;
/

