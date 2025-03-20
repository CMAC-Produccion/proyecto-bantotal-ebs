create or replace package pq_cr_controluai is

procedure sp_cr_control (pn_ins in number,
                         pn_cant out number);
                         
end pq_cr_controluai;
/

create or replace package body pq_cr_controluai is

procedure sp_cr_control (pn_ins in number,
                         pn_cant out number) is

ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
lc_flg char(1) := 'N';

cursor calendarios(cn_emp in number,
                   cn_mod in number,
                   cn_suc in number,
                   cn_mda in number,
                   cn_pap in number,
                   cn_cta in number,
                   cn_ope in number,
                   cn_sbo in number,
                   cn_top in number
                      ) is
select *
  from fsd601 f
 where f.pgcod  = cn_emp
   and f.ppmod  = cn_mod
   and f.ppsuc  = cn_suc
   and f.ppmda  = cn_mda
   and f.pppap  = cn_pap
   and f.ppcta  = cn_cta
   and f.ppoper = cn_ope
   and f.ppsbop = cn_sbo
   and f.pptope = cn_top
   and f.ppcap+f.ppint=0
   and f.pptipo<>'K';
   
cursor calendarios_seg(cn_emp in number,
                   cn_mod in number,
                   cn_suc in number,
                   cn_mda in number,
                   cn_pap in number,
                   cn_cta in number,
                   cn_ope in number,
                   cn_sbo in number,
                   cn_top in number
                      ) is
select f.pgcod ,
       f.ppmod ,
       f.ppsuc ,
       f.ppmda ,
       f.pppap ,
       f.ppcta ,
       f.ppoper,
       f.ppsbop,
       f.pptope
  from fsd601 f, fsd611 g
 where f.pgcod  = cn_emp
   and f.ppmod  = cn_mod
   and f.ppsuc  = cn_suc
   and f.ppmda  = cn_mda
   and f.pppap  = cn_pap
   and f.ppcta  = cn_cta
   and f.ppoper = cn_ope
   and f.ppsbop = cn_sbo
   and f.pptope = cn_top
   and f.pgcod  = g.pgcod  
   and f.ppmod  = g.ppmod  
   and f.ppsuc  = g.ppsuc  
   and f.ppmda  = g.ppmda  
   and f.pppap  = g.pppap  
   and f.ppcta  = g.ppcta  
   and f.ppoper = g.ppoper 
   and f.ppsbop = g.ppsbop 
   and f.pptope = g.pptope 
   and f.ppfpag = g.ppfpag
   and f.ppcap+f.ppint+g.ppimp11+g.ppimp12+g.ppimp13+g.ppimp14+g.ppimp15=0
   and f.pptipo<>'K';   


begin
   pn_cant := 0;
   
   begin
        select a.xwfempresa  ,
               a.xwfsucursal ,
               a.xwfmodulo   ,
               a.xwfmoneda   ,
               a.xwfpapel    ,
               a.xwfcuenta   ,
               a.xwfoperacion,
               a.xwfsubope   ,
               a.xwftipope     
          into ln_emp,
               ln_suc,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top
          from xwf700 a
         where a.xwfprcins = pn_ins
           and a.xwfcar3   = '1';
   exception
           when others then null;
   end;
   
   begin
       select 'S'
         into lc_flg
         from fsd611 g
       where g.pgcod  = ln_emp
         and g.ppmod  = ln_mod
         and g.ppsuc  = ln_suc
         and g.ppmda  = ln_mda
         and g.pppap  = ln_pap
         and g.ppcta  = ln_cta
         and g.ppoper = ln_ope
         and g.ppsbop = ln_sbo
         and g.pptope = ln_top
         and rownum   = 1;
    exception
         when others then 
              lc_flg := 'N';
    end;
    
    if lc_flg = 'S' then
       for i in calendarios_seg(ln_emp,
                            ln_mod,
                            ln_suc,
                            ln_mda,
                            ln_pap,
                            ln_cta,
                            ln_ope,
                            ln_sbo,
                            ln_top) loop
           pn_cant := pn_cant + 1;
       end loop;
       else
           for j in calendarios(ln_emp,
                            ln_mod,
                            ln_suc,
                            ln_mda,
                            ln_pap,
                            ln_cta,
                            ln_ope,
                            ln_sbo,
                            ln_top) loop
               pn_cant := pn_cant + 1;
           end loop;
    end if;

end sp_cr_control;

end pq_cr_controluai;
/

