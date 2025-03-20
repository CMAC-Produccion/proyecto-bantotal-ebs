create or replace function fn_ciiu2 (pn_cta in number ) return number is
ln_activi number;
begin
  begin
  select /*+parallel(aa,2)*/xx.actcod1--15.03.2013
    into ln_activi
    from sngc60 aa, fst750 xx, fsr008 pp
   where pp.pgcod = 1
     and pp.ctnro = pn_cta
     and pp.cttfir ='T'
     and aa.sngc60pais = pp.pepais
     and aa.sngc60tdoc = pp.petdoc
     and aa.sngc60ndoc = pp.pendoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception
      when no_data_found then
         ln_activi := null;
      when too_many_rows then
         ln_activi := null;
  end;
   return ln_activi;
end ;
/

