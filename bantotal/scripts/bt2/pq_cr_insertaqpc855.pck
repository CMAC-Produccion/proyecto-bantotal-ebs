create or replace package pq_cr_insertaqpc855 is

  -- Author  : AANGLES
  -- Created : 7/07/2023 11:56:27
  -- Purpose : insertar datos en la tabla aqpc855
  procedure sp_cr_insert_aqpc855(instance in number,
                                 tdoc     in varchar2,
                                 usur     in varchar2);
end pq_cr_insertaqpc855;
/

create or replace package body pq_cr_insertaqpc855 is

  procedure sp_cr_insert_aqpc855(instance in number,
                                 tdoc     in varchar2,
                                 usur     in varchar2) is
    lsdesc varchar(30);
  begin
    begin
      select tp1desc
        into lsdesc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11171
         and tp1corr1 = 1
         and tp1corr2 = 1
         and tp1corr3 > 0
         and substr(tp1desc, 1, 2) = tdoc;
    exception
      when others then
        null;
    end;
    begin
      insert into aqpc855
        (aqpc855inst,
         aqpc855usur,
         aqpc855tdoc,
         aqpc855fech,
         aqpc855hora,
         aqpc855est,
         aqpc855tdesc)
      values
        (instance, usur, tdoc, to_Date(SYSDATE, 'dd/mm/rrrr'),TO_CHAR(SYSDATE, 'hh:mi:ss'), 'S', lsdesc);
      commit;
    exception
      when others then
        null;
    end;          
  
  end sp_cr_insert_aqpc855;
end pq_cr_insertaqpc855;
/

