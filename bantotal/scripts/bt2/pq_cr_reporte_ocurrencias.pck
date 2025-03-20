create or replace package PQ_CR_REPORTE_OCURRENCIAS is

  -- Author  : ABERNEDO
  -- Created : 13/05/2015 09:23:40 a.m.
  -- Purpose : 
  
  Procedure SP_CR_CALCULA_CUOTA (PN_EMP IN NUMBER,PN_MOD IN NUMBER,PN_SUC IN NUMBER,
                              PN_MDA IN NUMBER,PN_PAP IN NUMBER,PN_CTA IN NUMBER,
                              PN_OPE IN NUMBER,PN_SBO IN NUMBER,PN_TOP IN NUMBER,
                              PN_CUOTA OUT NUMBER);
  Procedure SP_CR_CALCULA_CUOTAII (PN_EMP IN NUMBER,PN_MOD IN NUMBER,PN_SUC IN NUMBER,
                              PN_MDA IN NUMBER,PN_PAP IN NUMBER,PN_CTA IN NUMBER,
                              PN_OPE IN NUMBER,PN_SBO IN NUMBER,PN_TOP IN NUMBER,
                              PD_FEC IN DATE,PD_FECMIN IN DATE,PN_CUOTA OUT NUMBER)  ;                               

end PQ_CR_REPORTE_OCURRENCIAS;
/

create or replace package body PQ_CR_REPORTE_OCURRENCIAS is

Procedure SP_CR_CALCULA_CUOTA (PN_EMP IN NUMBER,PN_MOD IN NUMBER,PN_SUC IN NUMBER,
                              PN_MDA IN NUMBER,PN_PAP IN NUMBER,PN_CTA IN NUMBER,
                              PN_OPE IN NUMBER,PN_SBO IN NUMBER,PN_TOP IN NUMBER,
                              PN_CUOTA OUT NUMBER) IS

ld_fec date;
ld_fecmin date;
ln_totcu number(5);
ln_cuo number(17,2);
begin
     
     begin
           select max(a.ppfpag)
             into ld_fec
             from fsd601 a
            where a.pgcod  = PN_EMP
              and a.ppmod  = PN_MOD
              and a.ppsuc  = PN_SUC
              and a.ppmda  = PN_MDA
              and a.pppap  = PN_PAP
              and a.ppcta  = PN_CTA
              and a.ppoper = PN_OPE
              and a.ppsbop = PN_SBO
              and a.pptope = PN_TOP
              and a.d601co = 'S';
     exception
     when no_data_found then null;                         
     end;
     
     begin
           select min(a.ppfpag)
             into ld_fecmin
             from fsd601 a
            where a.pgcod  = PN_EMP
              and a.ppmod  = PN_MOD
              and a.ppsuc  = PN_SUC
              and a.ppmda  = PN_MDA
              and a.pppap  = PN_PAP
              and a.ppcta  = PN_CTA
              and a.ppoper = PN_OPE
              and a.ppsbop = PN_SBO
              and a.pptope = PN_TOP
              and a.d601co = 'S';
     exception
     when no_data_found then null;                         
     end;
     
     begin
           select count(a.ppfpag)
             into ln_totcu
             from fsd601 a
            where a.pgcod  = PN_EMP
              and a.ppmod  = PN_MOD
              and a.ppsuc  = PN_SUC
              and a.ppmda  = PN_MDA
              and a.pppap  = PN_PAP
              and a.ppcta  = PN_CTA
              and a.ppoper = PN_OPE
              and a.ppsbop = PN_SBO
              and a.pptope = PN_TOP
              and a.d601co = 'S';
     exception
     when no_data_found then null;                         
     end;
     
     begin
   
       select (a.ppcap+a.ppint)cuota
          into ln_cuo
          from fsd601 a
         where a.pgcod  = PN_EMP
           and a.ppmod  = PN_MOD
           and a.ppsuc  = PN_SUC
           and a.ppmda  = PN_MDA
           and a.pppap  = PN_PAP
           and a.ppcta  = PN_CTA
           and a.ppoper = PN_OPE
           and a.ppsbop = PN_SBO
           and a.pptope = PN_TOP
           and a.d601co = 'S'
           and rownum   = 1
           ;
    exception
    when no_data_found then null;
    end;
     
     if ln_totcu > 1 then
         PQ_CR_REPORTE_OCURRENCIAS.SP_CR_CALCULA_CUOTAII(PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,
                                                         PN_CTA,PN_OPE,PN_SBO,PN_TOP,LD_FEC,
                                                         ld_fecmin,PN_CUOTA);
                                                         
         else
              PN_CUOTA:=ln_cuo;
         
     end if;
     
end SP_CR_CALCULA_CUOTA;


Procedure SP_CR_CALCULA_CUOTAII (PN_EMP IN NUMBER,PN_MOD IN NUMBER,PN_SUC IN NUMBER,
                              PN_MDA IN NUMBER,PN_PAP IN NUMBER,PN_CTA IN NUMBER,
                              PN_OPE IN NUMBER,PN_SBO IN NUMBER,PN_TOP IN NUMBER,
                              PD_FEC IN DATE,PD_FECMIN IN DATE,PN_CUOTA OUT NUMBER) IS

cursor credito is

select (a.ppcap+a.ppint)cuota
  from fsd601 a
 where a.pgcod  = PN_EMP
   and a.ppmod  = PN_MOD
   and a.ppsuc  = PN_SUC
   and a.ppmda  = PN_MDA
   and a.pppap  = PN_PAP
   and a.ppcta  = PN_CTA
   and a.ppoper = PN_OPE
   and a.ppsbop = PN_SBO
   and a.pptope = PN_TOP
   and a.ppfpag < PD_FEC
   and a.ppfpag > PD_FECMIN
   and a.d601co = 'S';


ln_cuoten number(17,2);

begin
   begin
   
       select (a.ppcap+a.ppint)cuota
          into ln_cuoten
          from fsd601 a
         where a.pgcod  = PN_EMP
           and a.ppmod  = PN_MOD
           and a.ppsuc  = PN_SUC
           and a.ppmda  = PN_MDA
           and a.pppap  = PN_PAP
           and a.ppcta  = PN_CTA
           and a.ppoper = PN_OPE
           and a.ppsbop = PN_SBO
           and a.pptope = PN_TOP
           and a.ppfpag > PD_FECMIN
           and a.ppfpag < PD_FEC
           and a.d601co = 'S'
           and rownum   = 1;
    exception
    when no_data_found then null;
    end;
    
    begin
       For i in credito loop
           if i.cuota =  ln_cuoten then
              PN_CUOTA := i.cuota;
                        
              else
                  PN_CUOTA := 0;
                  exit;
           end if;  
           
       
       end loop;
    end;
     
end SP_CR_CALCULA_CUOTAII;
                              
end PQ_CR_REPORTE_OCURRENCIAS;
/

