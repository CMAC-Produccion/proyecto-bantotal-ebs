create or replace package PQ_CR_CAMP_CONVENIO is

  -- Author  : MPOSTIGOC
  -- Created : 2/01/2020 9:23:02 a. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_inicio(ln_instancia  in number,
                         lc_TipConvnio out varchar2);

end PQ_CR_CAMP_CONVENIO;
/

create or replace package body PQ_CR_CAMP_CONVENIO is

  procedure sp_cr_inicio(ln_instancia  in number,
                         lc_TipConvnio out varchar2) is
  
    ln_sng001ori number;
    ln_cuenta    number;
    ln_nroconv   number;
  
  begin
    lc_TipConvnio := 'OTROS';
  
    begin
      select sng001ori, sng001cta
        into ln_sng001ori, ln_cuenta
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_sng001ori := 9999;
        ln_cuenta    := 99999;
    end;
  
    if ln_sng001ori in (3, 4, 13, 14, 15) then
    
      begin
        select distinct (f.pp102ncart)
          into ln_nroconv
          from fpp102 f
         where f.pp102cta = ln_cuenta
           and f.pp102tfc = (select max(g.pp102tfc)
                               from fpp102 g
                              where g.pp102cta = ln_cuenta);
      exception
        when others then
          null;
      end;
    
    else
      if ln_sng001ori = 10 then
        begin
          select to_number(w.wfattsval)
            into ln_nroconv
            from WFATTSVALUES w
           where w.wfinsprcid = ln_instancia
             and w.wfattsid = 'ID_CONVENIO';
        exception
          when no_data_found then
            ln_nroconv := 0;
        end;
      end if;
    end if;
  
    /*begin
      select a.aqpa371tpinst
        into lc_TipConvnio
        from aqpa371 a
       where a.aqpa371codcart = ln_nroconv;
    exception
      when others then
        lc_TipConvnio := 'OTROS';
    end;*/
  
    begin
      select UPPER(j.jaqa300tip)
        into lc_TipConvnio
        from jaqa300 j
       where j.jaqa300nco = ln_nroconv;
    exception
      when others then
        lc_TipConvnio := 'OTROS';
    end;
  
  end sp_cr_inicio;

end PQ_CR_CAMP_CONVENIO;
/

