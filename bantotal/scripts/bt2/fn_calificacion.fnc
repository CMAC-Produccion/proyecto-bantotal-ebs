create or replace function FN_CALIFICACION(PAIS   number,
                                           TIPDOC number,
                                           NUMDOC char) return char is
  CLASI char(30);
begin
  select substr(jaqy067ncal, 1, 30)
    into CLASI
    from (select jaqy067ncal
            from jaqy066 a, jaqy067 b
           where a.jaqy066calf = b.jaqy067ccal
             and jaqy066paic = Pais
             and jaqy066tdoc = Tipdoc
             and jaqy066tndoc = Numdoc
           order by jaqy066fecp desc)
   where rownum = 1;
  return(CLASI);
exception
  when others then
    CLASI := 'NINGUNA';
    return(CLASI);
end FN_CALIFICACION;
/

