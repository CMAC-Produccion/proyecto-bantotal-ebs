create or replace package PQ_CR_CNORMALIZACION is

  -- Author  : ABERNEDO
  -- Created : 24/08/2017 05:17:23 p.m.
  -- Purpose : 
  
  -- Public type declarations
Procedure Sp_Fec_Proximo_vto (pn_ins in number,pn_dia out number);

end PQ_CR_CNORMALIZACION;
/

create or replace package body PQ_CR_CNORMALIZACION is

Procedure Sp_Fec_Proximo_vto (pn_ins in number,pn_dia out number)is

ln_emp number(3)  ;
ln_suc number(3)  ;
ln_mod number(3)  ;
ln_mda number(4)  ;
ln_pap number(4)  ;
ln_cta number(9)  ;
ln_ope number(9)  ;
ln_sbo number(3)  ;
ln_top number(3)  ;
ld_fecpag date;
ln_empR number(3)  ;
ln_modR number(3)  ;
ln_sucR number(3)  ;
ln_mdaR number(4)  ;
ln_papR number(4)  ;
ln_ctaR number(9)  ;
ln_opeR number(9)  ;
ln_sboR number(3)  ;
ln_topR number(3)  ;
ld_fecrep date;
begin
  begin
      select a.xwfempresa,
             a.xwfsucursal,
             a.xwfmodulo,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
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
         and a.xwfcar3   <> '1';
  exception
    when no_data_found then
         begin
              select a.xwfempresa,
                     a.xwfsucursal,
                     a.xwfmodulo,
                     a.xwfmoneda,
                     a.xwfpapel,
                     a.xwfcuenta,
                     a.xwfoperacion,
                     a.xwfsubope,
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
                 and a.xwfcar3   <> '1'
                 and rownum = 1;
          exception
            when others then null;
          end;
    when others then null;
  end;
  
  --obtiene fecha impaga
  begin
--    select min(n.ppfpag) 
    select /*+index(n FSD60107)*/min(n.ppfpag)
      into ld_fecpag
      from fsd601 n
     where n.pgcod  = ln_emp
       and n.ppcta  = ln_cta
       and n.ppmda  = ln_mda
       and n.ppsuc  = ln_suc
       and n.pppap  = ln_pap
       and n.ppoper = ln_ope
       and n.ppsbop = ln_sbo
       and n.pptope = ln_top
       and n.ppmod  = ln_mod
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists
                (select ppmod, ppcta,ppoper, pptope,ppfpag
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  exception
      when others then null;
  end;
  
  --clave del credito reprogramado
  begin
    select a.xwfempresa,
           a.xwfsucursal,
           a.xwfmodulo,
           a.xwfmoneda,
           a.xwfpapel,
           a.xwfcuenta,
           a.xwfoperacion,
           a.xwfsubope,
           a.xwftipope
      into ln_empR,
           ln_sucR,
           ln_modR,
           ln_mdaR,
           ln_papR,
           ln_ctaR,
           ln_opeR,
           ln_sboR,
           ln_topR 
      from xwf700 a
     where a.xwfprcins = pn_ins
       and a.xwfcar3 = '1';
  exception
    when others then null;
  end;
  
  --fecha de primer pago del credito reprogramado
    begin
    select a.xllfprimpa
      into ld_fecrep
      from x054023 a
     where a.xllpgcod  = ln_empR
       and a.xllaomod  = ln_modR
       and a.xllaosuc  = ln_sucR
       and a.xllaomda  = ln_mdaR
       and a.xllaopap  = ln_papR 
       and a.xllaocta  = ln_ctaR
       and a.xllaooper = ln_opeR
       and a.xllaosbop = ln_sboR
       and a.xllaotop  = ln_topR;
  exception when others then null;
  end;
  
  pn_dia := ld_fecrep - ld_fecpag;
  
end Sp_Fec_Proximo_vto;
  
  
end PQ_CR_CNORMALIZACION;
/

