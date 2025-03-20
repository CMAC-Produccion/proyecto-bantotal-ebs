create or replace package PQ_CR_CNTRLSARAS_BEBTAB is

  -- Author  : MPOSTIGOC
  -- Created : 22/10/2024 15:52:17
  -- Purpose : Control de Saras para Bebidas y Tabaco

  procedure sp_cr_PorcExpscn(ln_Instancia   in number,
                             ln_PorcExp     out number,
                             ln_MaxPorcSara out number,
                             ln_ciiu        out number,
                             lc_EnLista     out varchar2);

end PQ_CR_CNTRLSARAS_BEBTAB;
/

create or replace package body PQ_CR_CNTRLSARAS_BEBTAB is

  procedure sp_cr_PorcExpscn(ln_Instancia   in number,
                             ln_PorcExp     out number,
                             ln_MaxPorcSara out number,
                             ln_ciiu        out number,
                             lc_EnLista     out varchar2) is
  
    ld_fchsist     date;
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_CIIUListado number;
  
  begin
  
    lc_EnLista := 'N';
  
    begin
      select max(j.jaql964fec) into ld_fchsist from jaql964 j;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aqpb183porctj
        into ln_PorcExp
        from aqpb183 a
       where a.aqpb183fecha = ld_fchsist;
    exception
      when others then
        ln_PorcExp := 0;
    end;
  
    begin
      select f.tp1imp1
        into ln_MaxPorcSara
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 138
         and f.tp1corr2 = 2
         and f.tp1corr3 = 1;
    exception
      when others then
        ln_MaxPorcSara := 0;
    end;
  
    begin
    
      begin
        select s.sng001pais, s.sng001tdoc, s.sng001ndoc
          into ln_pais, ln_tdoc, lc_ndoc
          from sng001 s
         where s.sng001inst = ln_instancia;
      exception
        when others then
          null;
      end;
    
      begin
        Pq_Cr_Modulo_Campanias.sp_cr_ciuu(ln_pais => ln_pais,
                                          ln_tdoc => ln_tdoc,
                                          lc_ndoc => lc_ndoc,
                                          ln_ciiu => ln_ciiu);
      end;
    
      begin
        select count(*)
          into ln_CIIUListado
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 138
           and f.tp1corr2 = 1
           and f.tp1corr3 > 0
           and f.tp1nro3 = ln_ciiu;
      exception
        when others then
          null;
      end;
    
      if ln_CIIUListado > 0 then
        lc_EnLista := 'S';
      else
        lc_EnLista := 'N';
      end if;
    
    end;
  
  end sp_cr_PorcExpscn;
end PQ_CR_CNTRLSARAS_BEBTAB;
/

