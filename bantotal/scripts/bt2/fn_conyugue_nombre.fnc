create or replace function fn_conyugue_nombre (pn_instancia in number) return varchar2 is
lc_cony varchar2(200);
begin
  begin
  select ee.penom
    into lc_cony
    from sng003 aa, fsr008 bb,fsr002 dd, fsd001 ee
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
     and bb.cttfir     = 'T';
  exception
      when no_data_found then
         lc_cony := null;
      when too_many_rows then
         lc_cony := null;
     end;

   return lc_cony;
end fn_conyugue_nombre;
/

