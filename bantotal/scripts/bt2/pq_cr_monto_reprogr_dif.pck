create or replace package PQ_CR_MONTO_REPROGR_DIF is

Procedure Sp_valida (pn_ins in number,
                     pn_mto out number);

end PQ_CR_MONTO_REPROGR_DIF ;
/

create or replace package body PQ_CR_MONTO_REPROGR_DIF is

Procedure Sp_valida (pn_ins in number,
                     pn_mto out number)is

ln_mtoAnt number(17,2) := 0;

begin
      begin
          select a.xwfmonto1
            into ln_mtoAnt
            from xwf700 a
           where a.xwfprcins = pn_ins
             and a.xwfcar3   = '1';
      exception
             when others then 
                  ln_mtoAnt := 0;
      end;
      
      pn_mto := ln_mtoAnt;

end Sp_valida;

end PQ_CR_MONTO_REPROGR_DIF ;
/

