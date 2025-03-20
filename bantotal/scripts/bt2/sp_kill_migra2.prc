create or replace procedure sp_kill_migra2 is
  cursor c1 is
    select sid, serial#, username, inst_id
      from gv$session
     where username = 'DBAEXTERNO';
begin
  for i in c1 loop
      execute immediate ' alter system kill session '' ' || to_char(i.sid) || ',' ||
                        to_char(i.serial#) || ',@' || to_char(i.inst_id) || '''';
  end loop;
end;
/

