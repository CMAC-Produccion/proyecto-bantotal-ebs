create or replace package PQ_CR_CONVENIOESSALUD is

  -- Author  : MPOSTIGOC
  -- Created : 27/01/2020 4:07:54 p. m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_nroconvenio(ln_instancia in number,
                              ln_nroconv   out number);

end PQ_CR_CONVENIOESSALUD;
/

create or replace package body PQ_CR_CONVENIOESSALUD is

  procedure sp_cr_nroconvenio(ln_instancia in number,
                              ln_nroconv   out number) is
  
    ln_cuenta    number;
    ln_sng001ori number;
  
  begin
  
    begin
      select sng001ori, sng001cta
        into ln_sng001ori, ln_cuenta
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_sng001ori := 0;
        ln_cuenta    := 0;
      
    end;
  
    if ln_sng001ori in (3, 4, 13, 14, 15) then
    
      begin
        select distinct (f.pp102ncart)
          into ln_nroconv
          from fpp102 f
         where f.pp102cta = ln_cuenta
           and f.pp102tfc = (select max(g.pp102tfc)
                               from fpp102 g
                              where g.pp102cta = ln_cuenta)
           and f.pp102hab = 'S' -- Habilitado MPOSTIGOC 22.06.2023
           and f.pp102tco = 'S'; -- Contabilizado
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
  
  end sp_cr_nroconvenio;
  ------------------------------------------------------  
end PQ_CR_CONVENIOESSALUD;
/

