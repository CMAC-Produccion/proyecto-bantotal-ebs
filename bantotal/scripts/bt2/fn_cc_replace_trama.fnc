create or replace function FN_CC_REPLACE_TRAMA (trama varchar2) return varchar2
is
posi1 number;
c_card1 varchar2(100);
c_card2 varchar2(100);
v_trama varchar2(2000) :='';
begin
   posi1 :=  instr(trama,'<NUMTAR>',1,1)+8;
   if posi1 <>8 then
      c_card1 := substr(trama,posi1,6)||'******'||substr(trama,posi1+12,4);
      c_card2 := substr(trama,posi1,16);
      v_trama := replace(trama,c_card2,c_card1);
   else
      v_trama :=  trama;--may2022
   end if;
   
   return v_trama;
end;
/

