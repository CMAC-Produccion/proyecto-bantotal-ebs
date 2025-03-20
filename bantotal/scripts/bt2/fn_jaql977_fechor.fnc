create or replace function fn_jaql977_fechor(v_jaql97787507 in number,
                                             v_jaql97787506 in number)
  return date DETERMINISTIC is
  v_fechor date;
begin

  select to_date(to_char(to_date(to_char(v_jaql97787507), 'rrrr/mm/dd'),
                         'dd/mm/rrrr') || ' ' ||
                 (substr(lpad(v_jaql97787506, 6, '0'), 1, 2) || ':' ||
                  substr(lpad(v_jaql97787506, 6, '0'), 3, 2) || ':' ||
                  substr(lpad(v_jaql97787506, 6, '0'), 5, 2)),
                 'DD/MM/RRRR HH24:MI:SS')
    into v_fechor
    from dual;
  return v_fechor;
exception
  when others then
    return null;
end;
/

