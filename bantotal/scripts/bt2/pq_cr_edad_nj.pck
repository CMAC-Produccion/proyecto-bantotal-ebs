create or replace package PQ_CR_EDAD_NJ is

  -- Author  : ABERNEDO
  -- Created : 02/07/2019 09:12:08 a.m.
  -- Purpose : Devuelve la edad de persona natural y juridica

  Procedure Sp_cr_edad(pn_pai    in number,
                       pn_tdo    in number,
                       pc_doc    in char,
                       pd_fecpro in date,
                       pn_edad   out number);
end PQ_CR_EDAD_NJ;
/

create or replace package body PQ_CR_EDAD_NJ is
  -- Author  : ABERNEDO
  -- Created : 02/07/2019 09:12:08 a.m.
  -- Purpose : Devuelve la edad de persona natural y juridica

  Procedure Sp_cr_edad(pn_pai    in number,
                       pn_tdo    in number,
                       pc_doc    in char,
                       pd_fecpro in date,
                       pn_edad   out number) is
    ld_fec date;
  
    ln_paij number(3);
    ln_tdoj number(2);
    lc_ndoj char(12);
  
  begin
    begin
      select a.pffnac
        into ld_fec
        from fsd002 a
       where a.pfpais = pn_pai
         and a.pftdoc = pn_tdo
         and a.pfndoc = pc_doc;
    exception
      when others then
        null;
    end;
    if ld_fec is null then
      begin
        select a.pfpai1, a.pftdo1, a.pfndo1
          into ln_paij, ln_tdoj, lc_ndoj
          from fsr003 a
         where a.pjpais = pn_pai
           and a.pjtdoc = pn_tdo
           and a.pjndoc = pc_doc;
      exception
        when too_many_rows then
        
          begin
            select a.pfpai1, a.pftdo1, a.pfndo1
              into ln_paij, ln_tdoj, lc_ndoj
              from fsr003 a
             where a.pjpais = pn_pai
               and a.pjtdoc = pn_tdo
               and a.pjndoc = pc_doc
               and a.vicod <> 1
               and rownum = 1;
          exception
            when no_data_found then
              null;
            
          end;
        when no_data_found then
          null;
      end;
    
      begin
        select a.pffnac
          into ld_fec
          from fsd002 a
         where a.pfpais = ln_paij
           and a.pftdoc = ln_tdoj
           and a.pfndoc = lc_ndoj;
      exception
        when others then
          null;
      end;
    
    end if;
  
    pn_edad := floor(MONTHS_BETWEEN(pd_fecpro, ld_fec) / 12);
  
  end Sp_cr_edad;

end PQ_CR_EDAD_NJ;
/

