create or replace package PQ_CR_RELANZAMNT_LINEAS is

  -- Author  : MPOSTIGOC
  -- Created : 15/11/2022 09:05:15
  -- Purpose : 

  procedure sp_cr_VerPagoInt(ln_pgcodtx in number,
                             ln_modtx   in number,
                             ln_suctx   in number,
                             ln_trantx  in number,
                             ln_reltx   in number,
                             ln_ordtx   in number,
                             ln_Interes in number,
                             pcancel    out varchar2);

end PQ_CR_RELANZAMNT_LINEAS;
/

create or replace package body PQ_CR_RELANZAMNT_LINEAS is

  procedure sp_cr_VerPagoInt(ln_pgcodtx in number,
                             ln_modtx   in number,
                             ln_suctx   in number,
                             ln_trantx  in number,
                             ln_reltx   in number,
                             ln_ordtx   in number,
                             ln_Interes in number,
                             pcancel    out varchar2) is
  
    ln_mod           number;
    ln_tope          number;
    ln_suc           number;
    ln_mda           number;
    ln_pap           number;
    ln_cta           number;
    ln_oper          number;
    ln_subop         number;
    ln_CuotasPagadas number;
    ln_fchpago       date;
    -- ln_interes       number(17, 2) := 0.00;
    ln_interespag number(17, 2) := 0.00;
  
  begin
  
    pcancel := 'N';
  
    begin
      select f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_mod,
             ln_tope,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_oper,
             ln_subop
        from fsd016 f
       where f.pgcod = ln_pgcodtx
         and f.itmod = ln_modtx
         and f.ittran = ln_trantx
         and f.itord = ln_ordtx
         and f.itsuc = ln_suctx
         and f.itnrel = ln_reltx;
    exception
      when others then
        null;
    end;
  
    --if 
    begin
      select count(*)
        into ln_CuotasPagadas
        from fsd602 f
       where f.pgcod = 1
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_oper
         and f.ppsbop = ln_subop
         and f.pptope = ln_tope
         and f.pp1stat = 'T'
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_CuotasPagadas = 0 then
    
      /*begin
        select min(f.ppfpag)
          into ln_fchpago
          from fsd601 f
         where f.pgcod = 1
           and f.ppmod = ln_mod
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_oper
           and f.ppsbop = ln_subop
           and f.pptope = ln_tope;
      exception
        when others then
          null;
      end;
      
      begin
        select f.ppint
          into ln_interes
          from fsd601 f
         where f.pgcod = 1
           and f.ppmod = ln_mod
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_oper
           and f.ppsbop = ln_subop
           and f.pptope = ln_tope
           and f.ppfpag = ln_fchpago;
      exception
        when others then
          null;
      end;*/
    
      --ln_interes := nvl(ln_interes, 0); -- mpostigoc 04.04.2023 INC5090
    
      begin
        select sum(f.pp1int)
          into ln_interespag
          from fsd602 f
         where f.pgcod = 1
           and f.ppmod = ln_mod
           and f.ppsuc = ln_suc
           and f.ppmda = ln_mda
           and f.pppap = ln_pap
           and f.ppcta = ln_cta
           and f.ppoper = ln_oper
           and f.ppsbop = ln_subop
           and f.pptope = ln_tope
           and f.ppfpag = ln_fchpago
           and f.d602co = 'S';
      exception
        when others then
          ln_interespag := 0.00;
      end;
      ln_interespag := nvl(ln_interespag, 0);
    
      if ln_interespag < ln_interes then
        pcancel := 'S';
      
      else
        pcancel := 'N';
      
      end if;
    end if;
  end;
end PQ_CR_RELANZAMNT_LINEAS;
/

