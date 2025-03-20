create or replace package pq_cr_calculo_calif is

  -- Author  : CHERNANDEZ
  -- Created : 28/09/2017 09:49:51 a.m.
  -- Purpose : 

  -- Public function and procedure declarations  
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
  function fn_Calif_Nor_SBS24(lc_docsbs in char,
                              lc_tndoc  in char,
                              ld_fecrcc in date) return character;
  procedure sp_calif_nor_sbs24(p_instancia in number,
                               p_respuesta out varchar2);

end pq_cr_calculo_calif;
/

create or replace package body pq_cr_calculo_calif is

  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
    C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
    
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
    
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
    
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
    
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
    End;
    return C_TDOCID;
  end fn_Tipo_Doc_SBS;

  function fn_Calif_Nor_SBS24(lc_docsbs in char,
                              lc_tndoc  in char,
                              ld_fecrcc in date) return character is
    rpt      char(1);
    ln_cal0  number(5, 2);
    PNDOC1   varchar2(12);
    fechastr varchar2(10);
  
  Begin
    Begin
      Begin
        fechastr := to_date(ld_fecrcc, 'dd/mm/yyyy');
        PNDOC1   := trim(lc_tndoc);
      
        select N_CALIF0
          into ln_cal0
          from CLDRCCI
         where D_FECPRE = fechastr
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = PNDOC1; --trim(PNDOC); --lc_tndoc;
      exception
        when too_many_rows then
          begin
            select N_CALIF0
              into ln_cal0
              from CLDRCCI
             where D_FECPRE = ld_fecrcc
               and C_TDOCID = lc_docsbs
               and C_DOCIDE = PNDOC1
               and C_PERSON = 1
               and N_CALIF0 <> 0
               and rownum = 1;
          
          exception
          
            when no_data_found then
              ln_cal0 := 100;
          end;
        
        when no_data_found then
          ln_cal0 := 100;
      end;
    End;
    if ln_cal0 = 100 then
      rpt := 'S';
    else
      rpt := 'N';
    end if;
  
    return rpt;
  
  end fn_Calif_Nor_SBS24;

  procedure sp_calif_nor_sbs24(p_instancia in number,
                               p_respuesta out varchar2) is
    /*ln_tdoc    number(5);
    lc_ndoc    char(12);
    lv_ndoc    varchar2(12);
    ln_tdocsbs number(5);
    ln_FchSBS  number(8);
    D_FECPRE   varchar2(15);
    D_FECPRE1  date;
    ln_dia     number(2);
    ln_Mes     number(2);
    ln_Anio    number(4);
    
    --lc_codsbs  varchar2(10);
    i          number(5);
    rptFun     char(1);*/
    pn_correl  number(12); --se cambio de 9 a 12
  begin
    p_respuesta := 'S';
    
    PQ_CR_REGLAS.sp_busca_rcc(p_instancia,38,'T','',p_respuesta,pn_correl);
    
    /*select Tpnro
      into ln_FchSBS
      from FST098
     Where Pgcod = 1
       and Tpcod = 7647
       and Tpcorr = 12;
  
    ln_dia  := SubStr(ln_FchSBS, 1, 2);
    ln_Mes  := SubStr(ln_FchSBS, 3, 2);
    ln_Anio := SubStr(ln_FchSBS, 5, 4);
  
    D_FECPRE  := lpad(ln_dia, 2, '0') || '/' || lpad(ln_Mes, 2, '0') || '/' ||
                 ln_Anio;
    D_FECPRE1 := to_date(D_FECPRE, 'DD/MM/YYYY');
  
    select sng001tdoc, sng001ndoc
      into ln_tdoc, lc_ndoc
      from sng001
     where sng001inst = p_instancia;
  
    lv_ndoc := trim(lc_ndoc);
  
    ln_tdocsbs := pq_cr_calculo_calif.fn_Tipo_Doc_SBS(ln_tdoc, lv_ndoc);
  
    begin
      FOR i IN 1 .. 24 LOOP
        rptFun    := pq_cr_calculo_calif.fn_Calif_Nor_SBS24(ln_tdocsbs,
                                                            lc_ndoc,
                                                            D_FECPRE1);
        D_FECPRE1 := last_day(add_months(D_FECPRE1, -1));
        DBMS_OUTPUT.PUT_LINE(rptFun);
      
        if (rptFun = 'N') then
          p_respuesta := 'N';
          exit;
        end if;
      
      END LOOP;
    exception
      when no_data_found then
        p_respuesta := 'S';
    end;*/
  
  end sp_calif_nor_sbs24;

end pq_cr_calculo_calif;
/

