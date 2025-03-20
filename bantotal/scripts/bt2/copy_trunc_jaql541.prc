create or replace procedure copy_trunc_JAQL541 as
begin
  insert into JAQL541
    (cnl021ip, cnl021cnt, cnl021blq, jaql541fec)
    select cnl021ip, cnl021cnt, cnl021blq, sysdate from cnl021;
  delete from cnl021;
  commit;
end;
/

