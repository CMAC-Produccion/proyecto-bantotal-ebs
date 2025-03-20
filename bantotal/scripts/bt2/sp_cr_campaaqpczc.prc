create or replace procedure sp_cr_campaaqpczc(lc_documento in varchar,
                                                lc_flag      out varchar2,
                                                montosug     out number) is
begin
montosug :=0 ;
  begin
    select 'S', j.jaqz802mnt
      into lc_flag, montosug
      from jaqz802 j
     where j.jaqz802ndoc = lc_documento;
  exception when
  others then lc_flag := 'N';
end;

end sp_cr_campaaqpczc;
/

