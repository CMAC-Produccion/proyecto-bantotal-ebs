create or replace package PQ_CR_FAE_MYPE is

  -- Author  : MPOSTIGOC
  -- Created : 13/07/2020 10:44:04 p. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_ValidaFchLimite(ln_Instancia    in number,
                                  ld_FchProceso   in date,
                                  lc_ValFchLimite out varchar2);
  -----------------------------------------------------
  procedure sp_cr_ValidaCofide(ln_Instancia in number,
                               lc_ValCofide out varchar2);

end PQ_CR_FAE_MYPE;
/

create or replace package body PQ_CR_FAE_MYPE is

  procedure sp_cr_ValidaFchLimite(ln_Instancia    in number,
                                  ld_FchProceso   in date,
                                  lc_ValFchLimite out varchar2) is
  
    ln_pais      number;
    ln_tdoc      number;
    lc_ndoc      varchar2(12);
    ln_nroreg    number := 0;
    ld_fchlimite date;
  
  begin
  
    lc_ValFchLimite := 'S';
  
    begin
      select S.SNG001PAIS, S.SNG001TDOC, S.SNG001NDOC
        INTO ln_pais, ln_tdoc, lc_ndoc
        from SNG001 S
       WHERE S.SNG001INST = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_nroreg
        from aqpa381 a
       where a.aqpa381pais = ln_pais
         and a.aqpa381tdoc = ln_tdoc
         and trim(a.aqpa381ndoc) = trim(lc_ndoc);
    end;
  
    if ln_nroreg > 0 then
    
      begin
        select max(a.aqpa381flim)
          into ld_fchlimite
          from aqpa381 a
         where a.aqpa381pais = ln_pais
           and a.aqpa381tdoc = ln_tdoc
           and trim(a.aqpa381ndoc) = trim(lc_ndoc);
      exception
        when others then
          null;
      end;
    
      if ld_fchlimite >= ld_FchProceso then
        lc_ValFchLimite := 'S';
      else
        lc_ValFchLimite := 'N';
      end if;
    else
      lc_ValFchLimite := 'S';
    end if;
  
  end sp_cr_ValidaFchLimite;
  --------------------------------------------------------
  procedure sp_cr_ValidaCofide(ln_Instancia in number,
                               lc_ValCofide out varchar2) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_ndoc   varchar2(12);
    ln_nroreg number := 0;
  
  begin
  
    lc_ValCofide := 'S';
  
    begin
      select S.SNG001PAIS, S.SNG001TDOC, S.SNG001NDOC
        INTO ln_pais, ln_tdoc, lc_ndoc
        from SNG001 S
       WHERE S.SNG001INST = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_nroreg
        from aqpa382 a
       where a.aqpa382pais = ln_pais
         and a.aqpa382tdoc = ln_tdoc
         and trim(a.aqpa382ndoc) = trim(lc_ndoc);
    end;
  
    if ln_nroreg > 0 then
      lc_ValCofide := 'N';
    else
      lc_ValCofide := 'S';
    end if;
  
  end sp_cr_ValidaCofide;

end PQ_CR_FAE_MYPE;
/

