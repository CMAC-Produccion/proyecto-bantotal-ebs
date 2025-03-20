create or replace procedure SP_CR_VERF_DEBITOAUTOMATICO(ln_pgcod       in number,
                                                        ln_mod         in number,
                                                        ln_suc         in number,
                                                        ln_cta         in number,
                                                        ln_mda         in number,
                                                        ln_pap         in number,
                                                        ln_ope         in number,
                                                        ln_sbop        in number,
                                                        ln_tope        in number,
                                                        lc_TieneDebito out varchar2) is

  ln_DebAutom number;

begin

  lc_TieneDebito := 'NO';

  begin
    select count(*)
      into ln_DebAutom
      from fsr601 f
     where f.pp3cod = ln_pgcod
       and f.pp3mod = ln_mod
       and f.pp3suc = ln_suc
       and f.pp3cta = ln_cta
       and f.pp3mda = ln_mda
       and f.pp3pap = ln_pap
       and f.pp3oper = ln_ope
       and f.pp3sbop = ln_sbop
       and f.pp3tope = ln_tope;
  end;

  if ln_DebAutom > 0 then
    lc_TieneDebito := 'SI';
  else
    lc_TieneDebito := 'NO';
  end if;

end SP_CR_VERF_DEBITOAUTOMATICO;
/

