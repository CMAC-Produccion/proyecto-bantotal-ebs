create or replace package PQ_CR_RATIOEXCMENSUAL is

  -- Author  : MPOSTIGOC
  -- Created : 22/08/2017 01:10:57 p.m.
  -- Purpose : 

  procedure sp_RatExcMensual(pn_instancia in number,
                             ln_mtoexc    out number,
                             pn_porcuo    out number);

end PQ_CR_RATIOEXCMENSUAL;
/

create or replace package body PQ_CR_RATIOEXCMENSUAL is

  procedure sp_RatExcMensual(pn_instancia in number,
                             ln_mtoexc    out number,
                             pn_porcuo    out number) is
  
    -- ln_mtoexc  number(17, 2);
    ln_capcaja number(17, 2);
  
  begin
  
    begin
      select j.jaqy140capcaja
        into ln_capcaja
        from jaqy140 j
       where j.jaqy140inst = pn_instancia
         and j.jaqy140est = 'R'
         /*and j.jaqy140fec = (select max(q.jaqy140fec)
                               from jaqy140 q
                              where q.jaqy140inst = pn_instancia
                                and q.jaqy140est = 'R')*/;
    
    exception
      when others then
        null;
    end;
  
    begin
      pq_cr_hipotecario_vehicular.sp_cr_eva_excedente(pn_instancia => pn_instancia,
                                                      pn_mtoexc    => ln_mtoexc);
    end;
  
    if nvl(ln_mtoexc, 0) = 0 then
      pn_porcuo := 0;
    else
      pn_porcuo := round((nvl(ln_capcaja, 0) / nvl(ln_mtoexc, 0)), 2);
    end if;
  
  end sp_RatExcMensual;

end PQ_CR_RATIOEXCMENSUAL;
/

