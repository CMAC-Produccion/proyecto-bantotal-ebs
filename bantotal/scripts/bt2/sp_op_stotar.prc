create or replace procedure SP_OP_STOTAR(PS_CODUSU IN varchar2) IS
begin
   Begin
      delete jaqy253s where jaqy253scodusu = PS_CODUSU;
      commit;
      insert into jaqy253s (jaqy253scodusu,jaqy253scodsuc,jaqy253snomage,jaqy253scodbin,jaqy253ssubbin,jaqy253stiptar,jaqy253snumtar)
      select PS_CODUSU,td10suc,h.scnom,substr(a.td10tar,1,6) as bintar,substr(a.td10tar,7,2) as subbin,a.td10tiptar,count(*)
        from ftd10 a, fst001 h
       where td10est in ('BOVEDA SUC','INACTIVA') 
         and a.td10suc=h.sucurs
      group by td10suc,h.scnom,substr(a.td10tar,1,6),substr(a.td10tar,7,2),a.td10tiptar;
      commit;
   exception
      when no_data_found then
        null;
   End;  
end SP_OP_STOTAR;
/

