CREATE OR REPLACE Procedure SP_cr_tipoCambioFM(pd_fecpro in date,pn_tipcamb out number) is
begin
    select cotcbi
      into pn_tipcamb
      from fsh005 f
     where cofdes in (select max(cofdes)
                       from fsh005 g
                      where g.cofdes <= last_day(add_months(pd_fecpro,-1))
                        and moneda = 101)
       and moneda = 101;
end SP_cr_tipoCambioFM;
/

