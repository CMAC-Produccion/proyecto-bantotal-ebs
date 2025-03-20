create or replace function FN_TIPO_CAMBIO(FECHA  date,
                                          MONORI number,
                                          MONDES number,
                                          TIPO   number) return number is
  TC number;
begin
  if TIPO <> 0 then
    select TCV
      into TC
      from (select decode(MONORI, 101, TCCPA, TCVTA) TCV
              from fsd120
             Where TcCod = TIPO
               and TcMda = decode(MONORI, 101, MONORI, MONDES)
               and TcFch <= FECHA
               and tccpa > 0
               and tcvta > 0
             order by TcFch desc, TCHOR desc, tcimp desc)
     where rownum = 1;
  else
    select cotcbi
      into TC
      from (select cotcbi
              from fsh005
             where cofdes <= FECHA
               and moneda = 101
               and cotcbi > 0
             order by cofdes desc)
     where rownum = 1;
  end if;
  return(TC);
exception
  when others then
    return(0);
end FN_TIPO_CAMBIO;
/

