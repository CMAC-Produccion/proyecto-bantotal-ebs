create or replace procedure SP_OP_CONASIUBA(PN_CODPRO IN number) IS
begin
   Begin
      insert into jaql834b (jaql834cpro,jaql834bcmon,jaql834bctac,jaql834btipc,jaql834bmont)
      select jaql834cpro,jaql834acmon,jaql834accar,'C',sum(jaql834amont) 
        from jaql834a 
       where jaql834cpro = PN_CODPRO 
      group by jaql834cpro,jaql834acmon,jaql834accar,'C';
      commit;
   exception
      when no_data_found then
        null;
   End;  
   Begin
      insert into jaql834b (jaql834cpro,jaql834bcmon,jaql834bctac,jaql834btipc,jaql834bmont)
      select jaql834cpro,jaql834acmon,jaql834acabo,'A',sum(jaql834amont) 
        from jaql834a 
       where jaql834cpro = PN_CODPRO 
      group by jaql834cpro,jaql834acmon,jaql834acabo,'A'; 
      commit;
   exception
      when no_data_found then
        null;
   End;   
end SP_OP_CONASIUBA;
/

