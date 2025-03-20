CREATE OR REPLACE TRIGGER tg_delete_JAQL077

  after delete on jaql077
  for each row

begin

  insert into hjaql077
    (hjaql77copi,
     hjaql77corr,
     hjaql77fein,
     hjaql77hoin,
     hjaql77sucu,
     hjaql77tipe,
     hjaql77modu,
     hjaql77tope,
     hjaql77perf,
     hjaql77coef,
     hjaql77mtmi,
     hjaql77mtma,
     hjaql77au01,
     hjaql77fech,
     hjaql77horh)
  values
    (:old.jaql77copi,
:old.jaql77corr,
:old.jaql77fein,
:old.jaql77hoin,
:old.jaql77sucu,
:old.jaql77tipe,
:old.jaql77modu,
:old.jaql77tope,
:old.jaql77perf,
:old.jaql77coef,
:old.jaql77mtmi,
:old.jaql77mtma,
:old.jaql77au01,
trunc(sysdate),
to_char(sysdate,'hh24:mi:ss'))  ;
exception
  when others then
    null;
end;
/

