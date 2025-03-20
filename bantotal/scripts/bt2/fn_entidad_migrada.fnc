create or replace function FN_ENTIDAD_MIGRADA(vpgcod  number,
                                              vscsuc  number,
                                              vscmda  number,
                                              vscpap  number,
                                              vsccta  number,
                                              vscoper number,
                                              vscsbop number,
                                              vsctope number,
                                              vscmod  number,
                                              tipo    varchar2)
  return number is
  codigo number;

begin
  begin
    select jaql54enti
      into codigo
      from jaql054
     where jaql54pgco = vpgcod
       and jaql54scsu = vscsuc
       and jaql54scmd = vscmda
       and jaql54scpa = vscpap
       and jaql54scct = vsccta
       and jaql54scop = vscoper
       and jaql54scsb = decode(vscmod,21,vscsbop,jaql54scsb)
       and jaql54scto = vsctope
       and jaql54scmo = vscmod
       and jaql54timi = tipo;
  exception
    when no_data_found then
      codigo := 0;
  end;

  return(codigo);
end FN_ENTIDAD_MIGRADA;
/

