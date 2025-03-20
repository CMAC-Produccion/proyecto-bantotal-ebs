create or replace procedure SP_AH_TC_REFER(tran in number,
                                           tipo out number) is
tccpa1 number(10,6):=0;                                           
tcvta1 number(10,6):=0;                                           
begin
 Select tccpa, tcvta
   into tccpa1,tcvta1
   from fsd120
  where TCCOD = 500
    and tcfch = (select max(tcfch) from fsd120 where tccod = 500)
    and tchor =
        (select max(tchor)
           from fsd120
          where tccod = 500
            and tcfch = (select max(tcfch) from fsd120 where tccod = 500));
   if tran = 535 or tran = 131 then --Compra adicion nueva tran 180220
     tipo := tccpa1;
   elsif tran = 536 or tran = 130 then -- Venta adicion nueva tran 180220
     tipo := tcvta1;
   end if;      
exception
  when others then
    null;
end SP_AH_TC_REFER;
/

