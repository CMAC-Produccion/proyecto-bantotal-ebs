create or replace package PQ_CR_CONTADOREXP is
  procedure sp_cr_obtenerCont(pn_fechaIn  in date,
                              pn_fechaFin in date,
                              pn_fechaApe in date,
                              pn_cont     out number);
  procedure sp_cr_incremCont(pn_fechaApe in date);
  procedure sp_cr_insertarContad;
end PQ_CR_CONTADOREXP;
/

create or replace package body PQ_CR_CONTADOREXP is

  procedure sp_cr_obtenerCont(pn_fechaIn  in date,
                              pn_fechaFin in date,
                              pn_fechaApe in date,
                              pn_cont     out number) is
  begin
    select count(*)
      into pn_cont
      from jaql546
     where jaql546feenv >= pn_fechaIn
       and jaql546feenv <= pn_fechaFin
       and jaql546coerr = '00000'
       and jaql546aux10 <> 'SENTINEL';
    Begin
      insert into AQPA025
        (AQPA025FECH, AQPA025CONT)
      values
        (pn_fechaApe, pn_cont);
    Exception
      when others then
        null;
    end;
    commit;
  end sp_cr_obtenerCont;

  procedure sp_cr_incremCont(pn_fechaApe in date) is
  begin
    Begin
      update AQPA025
         set AQPA025CONT = AQPA025CONT + 1
       where AQPA025FECH = pn_fechaApe;
    Exception
      when others then
        null;
    end;
    commit;
  end sp_cr_incremCont;

  procedure sp_cr_insertarContad is
    ld_fecIni date;
    ld_fecFin date;
    ld_fecape date;
    ln_contad numeric(10);
    ln_conaux number(5);
  begin
    select pgfape into ld_fecape from fst017 where pgcod = 1;
    ld_fecIni := TRUNC(ld_fecape, 'MM');
    ld_fecfin := TRUNC(LAST_DAY(ld_fecape));
  
    select count(*)
      into ln_conaux
      from AQPA025
     where AQPA025FECH = ld_fecape;
    if ln_conaux = 0 then
    
      select count(*)
        into ln_contad
        from jaql546
       where jaql546feenv >= ld_fecIni
         and jaql546feenv <= ld_fecfin
         and jaql546coerr = '00000'
         and jaql546aux10 <> 'SENTINEL';
      Begin
        insert into AQPA025
          (AQPA025FECH, AQPA025CONT)
        values
          (ld_fecape, ln_contad);
      Exception
        when others then
          null;
      end;
    end if;
    commit;
  end sp_cr_insertarContad;
end PQ_CR_CONTADOREXP;
/

