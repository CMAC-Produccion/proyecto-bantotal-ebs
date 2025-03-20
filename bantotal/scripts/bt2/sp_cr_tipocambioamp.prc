create or replace procedure sp_Cr_TipoCambioAmp( pn_ins in number,
                                                 ln_tic  out number) is

ld_fec date;                                           
begin

  begin
      select trunc(max(a.wfiteminit))
        into ld_fec
        from wfwrkitems a
       where a.wfinsprcid = pn_ins
         and a.wftaskcod  = 3
         ;
  exception 
         when others then null;
  end;
  begin
      select cotcbi
        into ln_tic
        from (select cotcbi
                from fsh005
               where cofdes <= ld_fec
                 and moneda = 101
                 and cotcbi > 0
               order by cofdes desc)
       where rownum = 1;
  exception
         when others then ln_tic :=0;
  end;

end sp_Cr_TipoCambioAmp;
/

