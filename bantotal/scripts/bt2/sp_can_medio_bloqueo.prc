create or replace procedure sp_can_medio_bloqueo(
                            pn_jaql425tar in jaql425.jaql425tar%type,
                            pn_jaql425med in jaql425.jaql425med%type,
                            pn_jaql425dmc in jaql425.jaql425dmc%type,
                            pn_coderr out varchar2,
                            pn_deserr out varchar2
                                                 ) is
begin

  merge into jaql425 tar
  using 
  (select pn_jaql425tar jaql425tar, pn_jaql425med jaql425med, pn_jaql425dmc jaql425dmc from dual) med
  on (med.jaql425tar = tar.jaql425tar)
  when matched then
  update set tar.jaql425med = pn_jaql425med,
         tar.jaql425dmc = pn_jaql425dmc
  when not matched then
  insert (jaql425tar, jaql425med, jaql425dmc) values(med.jaql425tar, med.jaql425med, med.jaql425dmc);
  commit;

  pn_coderr := '002';
  pn_deserr := 'Medio registrado con éxito';

exception when others then

  pn_coderr := '000';
  pn_deserr := 'Se produjo un error al registrar el medio';

end;
/

