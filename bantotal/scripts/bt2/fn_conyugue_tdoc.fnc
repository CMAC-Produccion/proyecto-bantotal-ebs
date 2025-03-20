create or replace function fn_conyugue_tdoc (pn_instancia in number) return varchar2 is
lc_tdoc varchar2(20);
begin
  begin
  select ff.tdnom
    into lc_tdoc
    from sng003 aa, fsr008 bb,fsr002 dd, fsd001 ee,
         fst014 ff
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro
     and aa.sng003pgc  = bb.pgcod
     and bb.pepais     = dd.pepais
     and bb.petdoc     = dd.petdoc
     and bb.pendoc     = dd.pendoc
     and rpccyg        = 66
     and dd.rppais     = ee.pepais
     and dd.rptdoc     = ee.petdoc
     and dd.rpndoc     = ee.pendoc
     and ee.petdoc     = ff.tdocum
     and bb.cttfir     = 'T';
  exception
      when no_data_found then
         lc_tdoc := null;
      when too_many_rows then
         lc_tdoc := null;
     end;

   return lc_tdoc;
end fn_conyugue_tdoc;
/

