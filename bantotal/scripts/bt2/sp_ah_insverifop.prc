CREATE OR REPLACE PROCEDURE SP_AH_INSVERIFOP(V_cuenta  IN varchar2,
                                             V_CONT   OUT number,
                                             v_msg    out varchar2) IS

     ld_pgfape date;
     ld_fecfin date;
     ld_fecini date;
     lc_mes character(2);
     ln_cont number;
     vano char(4);
  begin
      ln_cont:= 0;
      select extract(year from sysdate) 
         into vano
        from dual;
      
      
      SELECT PGFAPE,
             last_day(PGFAPE) ,
             to_char(PGFAPE,'MM')
        INTO ld_pgfape,
             ld_fecfin,
             lc_mes
        FROM FST017
       WHERE PGCOD = 1;
      select to_date('01/'||lc_mes||'/'||vano,'dd/mm/rrrr')
         into ld_fecini
         from dual;
      Begin         
        INSERT INTO JAQY655 (JAQY655COD,JAQY655CTA,JAQY655FCH,JAQY655VAL)
                      VALUES(SEQ_JAQY655.NEXTVAL, trim(V_CUENTA), ld_pgfape,0);
        COMMIT;
     exception
       when others then
          v_msg := sqlerrm ;
     end;   
                                                  
      begin
        select count(*)
          into ln_cont
         from  jaqy655
        where  jaqy655cta = rpad(v_cuenta,27,' ')
          and jaqy655fch >= to_date(ld_fecini,'dd/mm/rrrr')
           and jaqy655fch <= to_Date(ld_fecfin,'dd/mm/rrrr');
      end;
      V_CONT := ln_cont;
end;
/

