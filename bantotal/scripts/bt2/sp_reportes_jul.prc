create or replace procedure SP_REPORTES_JUL
 IS
begin
  SP_CHEQUEDIA(trunc(sysdate)-1);
  SP_CHEQUEVAL(trunc(sysdate)-1);
  SP_OPERAGE(trunc(sysdate)-1);
  SP_ATMHIST(trunc(sysdate)-1);
  SP_DESEMB(trunc(sysdate)-1);
  SP_OPERTIEM(trunc(sysdate)-1);
end;
/

