create or replace procedure sp_ah_saldos_encaje(P_C_USUARIO IN VARCHAR2, P_D_FECPRO IN DATE) is

  cursor c_ahor is
  select rubro
    from fsd014 x, fst111 y
   where x.pcnivc = y.modulo
     and y.modulo in (21,22)
     and y.dscod in (2,3);

  cursor c_cred is
  select rubro
    from fsd014 x, fst111 y
   where x.pcnivc = y.modulo
     and y.dscod = 50;

  cursor c_totales(ln_moneda in number) is
    select /*+ Parallel(a,2,1)  +*/
           a.bccta, sum(a.bcsdmo) saldo
      from fsh012 a
     where a.bcemp = 1
       and a.bcfech = P_D_FECPRO
       and a.bcsist in (2, 3)
       and a.bcmod  in (21,22)
       and a.bcmda = ln_moneda
     group by a.bccta
     order by saldo desc;

 ln_saldo  number(18,2):=0; 
 ln_moneda number(18,2);     
 contot    number:=0;
 lc_moneda varchar2(50);
 ln_cont   number:=0;
 
  
begin   

  delete from JAQL063 where JAQL63NU05 = 82 and JAQL63CH01 = RPAD(P_C_USUARIO,50,' ');
  commit;

  for i in c_cred loop
      begin
        select sum(ABS(a.bcsdmo)), a.bcmda
          into ln_saldo, ln_moneda
          from fsh012 a
         where a.bcemp = 1
           and a.bcrubr = i.rubro
           and a.bcfech = P_D_FECPRO                       
           and a.bcsist = 50
         group by a.bcmda; 
     exception
     when no_data_found then
          ln_saldo  := 0;
          ln_moneda := 0;      
     end;
     begin
     contot := contot + 1;
     
       begin
         select monom into lc_moneda from fst005 where moneda = ln_moneda;
       end;
     
         insert into JAQL063(JAQL63NU01,
                             JAQL63NU02,
                             JAQL63NU03,
                             JAQL63NU04,
                             JAQL63CH01,
                             JAQL63NU05,
                             JAQL63DA01,
                             JAQL63CH02,
                             JAQL63CH03,
                             JAQL63CH04,
                             JAQL63CH05,
                             JAQL63DE01,
                             JAQL63DE02,
                             JAQL63DE03,
                             JAQL63DE04,
                             JAQL63DE05,
                             JAQL63DA02,
                             JAQL63DA03,
                             JAQL63DA04,
                             JAQL63DA05         
                             )
                       values(ln_moneda,0,0,0,
                              P_C_USUARIO,
                              82,
                              P_D_FECPRO,
                              'C',
                              upper(lc_moneda),'CREDITOS',' ',
                              ln_saldo,
                              contot,0,0,0,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO
                             );
         commit; 
     end;
  end loop;  
  ln_saldo := 0;
  ln_moneda := 0;
  
  for i in c_ahor loop
      begin
      select sum(bcsdmo), bcmda
        into ln_saldo, ln_moneda        
        from fsh012
       where bcemp = 1
         and bcrubr = i.rubro
         and bcfech = P_D_FECPRO         
         and bcmod in (21, 22)
         and bcsist in (2,3)
       group by bcmda;
     exception
     when no_data_found then
          ln_saldo  := 0;
          ln_moneda := 0;      
     end;
     begin
     contot := contot + 1;
     
       begin
         select monom into lc_moneda  from fst005 where moneda = ln_moneda;
       end;
       
         insert into JAQL063(JAQL63NU01,
                             JAQL63NU02,
                             JAQL63NU03,
                             JAQL63NU04,
                             JAQL63CH01,
                             JAQL63NU05,
                             JAQL63DA01,
                             JAQL63CH02,
                             JAQL63CH03,
                             JAQL63CH04,
                             JAQL63CH05,
                             JAQL63DE01,
                             JAQL63DE02,
                             JAQL63DE03,
                             JAQL63DE04,
                             JAQL63DE05,
                             JAQL63DA02,
                             JAQL63DA03,
                             JAQL63DA04,
                             JAQL63DA05         
                             )
                       values(ln_moneda,0,0,0,
                              P_C_USUARIO,
                              82,
                              P_D_FECPRO,
                              'A',
                              upper(lc_moneda),'AHORROS',' ',
                              ln_saldo,
                              contot,0,0,0,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO
                             );
         commit; 
     end;
  end loop;

  begin
    select monom into lc_moneda  from fst005 where moneda = 0;
  end;
  --AGRUPAMOS POR MONEDA
  ln_cont := 0;
  for i in c_totales(0) loop
     begin
     contot := contot + 1;
     ln_cont := ln_cont + 1;
     
     If ln_cont > 20 then
        exit;
     end if;
     
         insert into JAQL063(JAQL63NU01,
                             JAQL63NU02,
                             JAQL63NU03,
                             JAQL63NU04,
                             JAQL63CH01,
                             JAQL63NU05,
                             JAQL63DA01,
                             JAQL63CH02,
                             JAQL63CH03,
                             JAQL63CH04,
                             JAQL63CH05,
                             JAQL63DE01,
                             JAQL63DE02,
                             JAQL63DE03,
                             JAQL63DE04,
                             JAQL63DE05,
                             JAQL63DA02,
                             JAQL63DA03,
                             JAQL63DA04,
                             JAQL63DA05         
                             )
                       values(0,i.bccta,0,0,
                              P_C_USUARIO,
                              82,
                              P_D_FECPRO,
                              'S',
                              upper(lc_moneda),'AHORROS',' ',
                              i.saldo,
                              contot,0,0,0,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO
                             );
         commit; 
     end;
  end loop;    
  
  begin
    select monom into lc_moneda  from fst005 where moneda = 101;
  end;
  
  ln_cont := 0;  
  for i in c_totales(101) loop
     begin
     contot := contot + 1;
     ln_cont := ln_cont + 1;
          
     If ln_cont > 20 then
        exit;
     end if;
          
         insert into JAQL063(JAQL63NU01,
                             JAQL63NU02,
                             JAQL63NU03,
                             JAQL63NU04,
                             JAQL63CH01,
                             JAQL63NU05,
                             JAQL63DA01,
                             JAQL63CH02,
                             JAQL63CH03,
                             JAQL63CH04,
                             JAQL63CH05,
                             JAQL63DE01,
                             JAQL63DE02,
                             JAQL63DE03,
                             JAQL63DE04,
                             JAQL63DE05,
                             JAQL63DA02,
                             JAQL63DA03,
                             JAQL63DA04,
                             JAQL63DA05         
                             )
                       values(101,i.bccta,0,0,
                              P_C_USUARIO,
                              82,
                              P_D_FECPRO,
                              'S',
                              upper(lc_moneda),'AHORROS',' ',
                              i.saldo,
                              contot,0,0,0,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO,
                              P_D_FECPRO
                             );
         commit; 
     end;
  end loop;      
end sp_ah_saldos_encaje;
/

