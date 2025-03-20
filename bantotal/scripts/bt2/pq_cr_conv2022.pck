create or replace package PQ_CR_CONV2022 is

  -- Author  : MPOSTIGOC
  -- Created : 10/02/2022 22:07:54
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_inicio(ln_instancia in number,
                         lc_sector    out varchar2,
                         lc_tipentd   out varchar2,
                         ln_carte     out number);

end PQ_CR_CONV2022;
/

create or replace package body PQ_CR_CONV2022 is

  procedure sp_cr_inicio(ln_instancia in number,
                         lc_sector    out varchar2,
                         lc_tipentd   out varchar2,
                         ln_carte     out number) is
  
    lc_sectoraux varchar2(30);
  
  begin
  
    lc_sector := 'NE';
  
    Pq_Cr_Convenioessalud.sp_cr_nroconvenio(ln_instancia => ln_instancia,
                                            ln_nroconv   => ln_carte);
  
    begin
      select a.aqpa390sect, a.aqpa390tent
        into lc_sectoraux, lc_tipentd
        from aqpa390 a
       where a.aqpa390cart = ln_carte;
    exception
      when others then
        lc_sectoraux := 'NE';
        lc_tipentd   := 'NULO';
    end;
  
    if lc_sectoraux = 'Educación' then
      lc_sector := 'ED';
    else
      if lc_sectoraux = 'Salud y Ministerios' then
        lc_sector := 'SM';
      else
        if lc_sectoraux = 'Otros' then
          lc_sector := 'OT';
        end if;
      end if;
    end if;
  
  end sp_cr_inicio;
  
end PQ_CR_CONV2022;
/

