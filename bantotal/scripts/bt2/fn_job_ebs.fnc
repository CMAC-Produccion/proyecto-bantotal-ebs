create or replace function fn_job_ebs(fecha in date, proceso in varchar2)
  return date is
  mydate date;
begin
  if proceso = 'C' then
    if fecha <= trunc(sysdate) + 10 / 24 then
      mydate := trunc(sysdate) + 10 / 24;
    elsif fecha > trunc(sysdate) + 10 / 24 and fecha <= trunc(sysdate) + 13 / 24 then
      mydate := trunc(sysdate) + 13 / 24;
    elsif fecha > trunc(sysdate) + 13 / 24 and fecha <= trunc(sysdate) + 18 / 24 then
      mydate := trunc(sysdate) + 18 / 24;
    else
      mydate := trunc(sysdate) + 1 + 10 / 24;
    end if;
  elsif proceso = 'P' then
    if fecha <= trunc(sysdate) + 11 / 24 then
      mydate := trunc(sysdate) + 11 / 24;
    elsif fecha > trunc(sysdate) + 10 / 24 and fecha <= trunc(sysdate) + 14 / 24 then
      mydate := trunc(sysdate) + 14 / 24;
    elsif fecha > trunc(sysdate) + 14 / 24 and fecha <= trunc(sysdate) + 19 / 24 then
      mydate := trunc(sysdate) + 19 / 24;
    else
      mydate := trunc(sysdate) + 1 + 11 / 24;
    end if;
  end if;
  return mydate;
end fn_job_ebs;
/

