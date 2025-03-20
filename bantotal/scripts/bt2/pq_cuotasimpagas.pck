create or replace package pq_cuotasimpagas is

  -- Author  : RMOGROVEJO
  -- Created : 24/04/2018 11:13:39 a.m.
  -- Purpose : 

  procedure fn_cuotas(pn_emp    in number,
                      pn_mod    in number,
                      pn_suc    in number,
                      pn_mda    in number,
                      pn_pap    in number,
                      pn_cta    in number,
                      pn_oper   in number,
                      pn_sbop   in number,
                      pn_top    in number,
                      pd_fecpro in date,
                      ln_count  out number);

  procedure fn_Fec_Proximo_vto(pn_emp    in number,
                               pn_mod    in number,
                               pn_suc    in number,
                               pn_mda    in number,
                               pn_pap    in number,
                               pn_cta    in number,
                               pn_oper   in number,
                               pn_sbop   in number,
                               pn_top    in number,
                               pd_fecpro in date,
                               ln_count  out number);
 
procedure fn_ultclave_cred2 ( pv_user in character);

--procedure fn_ultclave_cred3(pv_user in varchar2,pn_cuenta in number,pn_oper in number );

procedure fn_ultclave_cred3(pv_user in character);

procedure fn_ultclave_cred4(pv_user in char,pd_fechaproceso in date);

procedure fn_ultclave_cred5 ( pv_user in char,pd_fechaproceso in date);

procedure fn_impr_convenio ( pc_user in character,pd_fechaproceso in date/*, MOSTRAR OUT CHAR*/);

procedure fn_impr_convenio_avales ( pc_user in character,pd_fechaproceso in date/*,MOSTRAR OUT CHAR*/);

end pq_cuotasimpagas;
/

create or replace package body pq_cuotasimpagas is

procedure fn_cuotas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                     pn_pap in number, pn_cta in number, pn_oper in number,
                     pn_sbop in number,pn_top in number, pd_fecpro in date, 
                     ln_count out number) is

begin

  begin
    select /*+ parallel(n,2,1)*/
           count(*)
      into ln_count
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       ;
  exception
      when no_data_found then
         ln_count := null;
      when too_many_rows then
         ln_count := null;
  end;
  -- return ln_count;
end fn_cuotas;

--nro de cuotas impagas
procedure fn_Fec_Proximo_vto (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date,
                             ln_count out number) is
                           
begin
  begin
    select /*+ parallel(n,2,1)*/
           count(*)
      into ln_count
      from fsd601 n
     where n.pgcod  = pn_emp
       and n.ppcta  = pn_cta
       and n.ppmda  = pn_mda
       and n.ppsuc  = pn_suc
       and n.pppap  = pn_pap
       and n.ppoper = pn_oper
       and n.ppsbop = pn_sbop
       and n.pptope = pn_top
       and n.ppmod  = pn_mod
       and n.d601co = 'S'
       and (n.ppcap+n.ppint)<>0
       and not exists
                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S'
                    and (o.pp1cap+o.pp1int)<>0);
  exception
      when no_data_found then
         ln_count := null;
      when too_many_rows then
         ln_count := null;
  end;
   --return ln_count;
end fn_Fec_Proximo_vto;
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
procedure fn_ultclave_cred2 ( pv_user in character) is

pn_emp1  number;
pn_mod1  number;
pn_mda1  number;
pn_suc1  number;
pn_pap1  number;
pn_cta1  number;
pn_oper1 number;
pn_subo number;
pn_aof99 number;
flag character (1);

pn_R1COD number;
pn_R1MOD number;
pn_R1SUC number;
pn_R1MDA number;
pn_R1PAP number;
pn_R1CTA number;
pn_R1OPER number;
pn_R1SBOP number;
pn_R1TOPE number;
pn_estad number;

pn_aqpa455emp number;
pn_aqpa455mod number;
pn_aqpa455suc number;
pn_aqpa455mda number;
pn_aqpa455pap number;
pn_aqpa455cta number;
pn_aqpa455oper number;
pv_aqpa455flag character (1):= 'N';
pv_aqpa455usr character(20);

pn_emp3  number;
pn_mod3  number;
pn_suc3  number;
pn_mda3  number;
pn_pap3  number;
pn_cta3  number;
pn_oper3 number;
pn_cuenta number;
pn_oper   number;


Cursor fsd010_a is 

select n.pgcod,
       n.aomod,
       n.aosuc,
       n.aomda,
       n.aopap,
       n.aocta,
       n.aooper,
       n.aosbop,
       n.aotope,
       n.aostat
  from fsd010 n
where n.pgcod = 1
   and n.AOCTA not in (select j.jaqy953cta from jaqy953 j)
   and n.AOSBOP in
       (select max(a.AOSBOP)
          from fsd010 a
         where a.AOCTA = n.AOCTA
           and a.AOOPER = n.AOOPER
           and a.AOMOD in (select modulo from fst111 where dscod = 50)
           and a.aomod in (33, 200)
           and a.AOSTAT <> 99)
   and n.AOMOD in (select modulo from fst111 where dscod = 50)
   and n.aomod in (33, 200)
--   and n.aocta = 15934--pn_cuenta
--   and n.aooper =551739--pn_oper
   and n.AOSTAT <> 99
order by n.AOCTA;
       
    
begin
  Begin  
    delete from aqpa455 where aqpa455usr=pv_user;
  commit;
         
for p in fsd010_a loop
     pn_emp1  := p.pgcod;
     pn_mod1  := p.aomod;
     pn_suc1  := p.aosuc;
     pn_mda1  := p.aomda;
     pn_pap1  := p.aopap;
     pn_cta1  := p.aocta;
     pn_oper1 := p.aooper;
     pn_estad := p.aostat;
 
          begin

            select a.aqpa455emp,
                   a.aqpa455mod,
                   a.aqpa455suc,
                   a.aqpa455mda,
                   a.aqpa455pap,
                   a.aqpa455cta,
                   a.aqpa455oper,
                   a.aqpa455flag,
                   a.aqpa455usr
              INTO pn_aqpa455emp,
                   pn_aqpa455mod,
                   pn_aqpa455suc,
                   pn_aqpa455mda,
                   pn_aqpa455pap,
                   pn_aqpa455cta,
                   pn_aqpa455oper,
                   pv_aqpa455flag,
                   pv_aqpa455usr
              from aqpa455 a
             where a.aqpa455emp = pn_emp1
                  --  and a.aqpa455mod = pn_mod1
               and a.aqpa455suc = pn_suc1
               and a.aqpa455mda = pn_mda1
               and a.aqpa455pap = pn_pap1
               and a.aqpa455cta = pn_cta1
               and a.aqpa455oper = pn_oper1
               and rownum = 1;
          exception
            when no_data_found then
              flag          := 'R';
              pv_aqpa455usr := 'usr';
          end;
-----castigado
if pn_mod1 = 33 then --si es 200 valido que sea anterior mente un 109 
begin
  select d.R1COD,d.R1MOD,d.R1SUC,d.R1MDA,d.R1PAP,d.R1CTA,d.R1OPER,d.R1SBOP,d.R1TOPE 
            into  pn_R1COD, 
                  pn_R1MOD,
                  pn_R1SUC,
                  pn_R1MDA,
                  pn_R1PAP,
                  pn_R1CTA,
                  pn_R1OPER,
                  pn_R1SBOP,
                  pn_R1TOPE
            from fsr011 d
                    where R2cod = pn_emp1 
                    and R2mod =   pn_mod1 
                    and R2suc =   pn_suc1 
                    and R2mda =   pn_mda1 
                    and R2pap =   pn_pap1 
                    and R2cta =   pn_cta1 
                    and R2oper =  pn_oper1
                    and Relcod = 34 --guia de proceso   CAMBIAR
                    and rownum=1;
           exception
              when no_data_found then
                flag := 'T';               
end;

begin
 if  pn_R1MOD = 109 and pn_estad <> 99  and pv_aqpa455usr <> pv_user then        
            insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;    
  end if;   
end;

begin
         
if  pv_aqpa455flag <> 'S' and flag='R'  and pn_mod1 =109 and pn_estad = 99  and pv_aqpa455usr <> pv_user then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1 
                                and s.aosuc  = pn_suc1  
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
 end if;
end;
--------------------------------------termina mod 33------- -----------------------------------------
end if;
-------------------------------------------------------
if pn_mod1 = 200  and pv_aqpa455usr <> pv_user then --si es 200 valido que sea anterior mente un 109 
begin
  select d.R1COD,d.R1MOD,d.R1SUC,d.R1MDA,d.R1PAP,d.R1CTA,d.R1OPER,d.R1SBOP,d.R1TOPE 
            into  pn_R1COD, 
                  pn_R1MOD,
                  pn_R1SUC,
                  pn_R1MDA,
                  pn_R1PAP,
                  pn_R1CTA,
                  pn_R1OPER,
                  pn_R1SBOP,
                  pn_R1TOPE
            from fsr011 d
                    where R2cod = pn_emp1 
                    and R2mod =   pn_mod1 
                    and R2suc =   pn_suc1 
                    and R2mda =   pn_mda1 
                    and R2pap =   pn_pap1 
                    and R2cta =   pn_cta1 
                    and R2oper =  pn_oper1
                    and Relcod = 52 --guia de proceso   CAMBIAR
                    and rownum=1;
           exception
              when no_data_found then
                flag := 'T';               
end;

begin
 if  pn_R1MOD = 109 and pn_estad <> 99  and pv_aqpa455usr <> pv_user then        
            insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;    
  end if;   
end;

begin
         
if  pv_aqpa455flag <> 'S' and flag='R'  and pn_mod1 =109 and pn_estad = 99  and pv_aqpa455usr <> pv_user then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1 
                                and s.aosuc  = pn_suc1  
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
 end if;
end;
---------------------------------------------------------------------------------------------------termina mod 200------- 
end if;

begin 
 if pn_mod1 = 109 and pv_aqpa455flag <> 'S'  and pn_estad <> 99   and pv_aqpa455usr <> pv_user then 
         insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;                
   end if;   
  
if  pv_aqpa455flag <> 'S' and flag='R'  and pn_mod1 =109 and pn_estad = 99  and pv_aqpa455usr <> pv_user then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1  
                                and s.aosuc  = pn_suc1 
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
  end if;
end; 

  pn_cuenta:= pn_cta1;
  pn_oper  := pn_oper1;
  

end loop;

end;

end fn_ultclave_cred2;
--------*******************************************************************-----------------------------
procedure fn_ultclave_cred3(pv_user in character ) is

  pn_emp1  number;
  pn_mod1  number;
  pn_mda1  number;
  pn_suc1  number;
  pn_pap1  number;
  pn_cta1  number;
  pn_oper1 number;
  pn_subo  number;
  pn_aof99 number;
  flag     character(1);
  flag2    character(1):='T';

  pn_R1COD  number;
  pn_R1MOD  number;
  pn_R1SUC  number;
  pn_R1MDA  number;
  pn_R1PAP  number;
  pn_R1CTA  number;
  pn_R1OPER number;
  pn_R1SBOP number;
  pn_R1TOPE number;
  pn_estad  number;

  pn_aqpa455emp  number;
  pn_aqpa455mod  number;
  pn_aqpa455suc  number;
  pn_aqpa455mda  number;
  pn_aqpa455pap  number;
  pn_aqpa455cta  number;
  pn_aqpa455oper number;
  pv_aqpa455flag character(1) := 'N';
  pv_aqpa455usr  character(20);

  pn_emp3  number;
  pn_mod3  number;
  pn_suc3  number;
  pn_mda3  number;
  pn_pap3  number;
  pn_cta3  number;
  pn_oper3 number;
  pv_Resultado character(1);

  Cursor fsd010_b is
  
    select n.pgcod,
           n.aomod,
           n.aosuc,
           n.aomda,
           n.aopap,
           n.aocta,
           n.aooper,
           n.aosbop,
           n.aotope,
           n.aostat
      from fsd010 n
     where n.pgcod = 1
       and n.AOCTA not in (select j.jaqy953cta from jaqy953 j)
       and n.AOSBOP in
           (select max(a.AOSBOP)
              from fsd010 a
             where a.AOCTA = n.AOCTA
               and a.AOOPER = n.AOOPER
               and a.AOMOD in (select modulo from fst111 where dscod = 50)
               and a.aomod = 109)
       and n.AOMOD in (select modulo from fst111 where dscod = 50)
       and n.aomod = 109
   --    and n.aocta = 15934--pn_cuenta
   --   and n.aooper = 551739--pn_oper
     order by n.AOCTA;

begin
  Begin
    delete from aqpa455 where aqpa455usr = pv_user;
    commit;
  
    for p in fsd010_b loop
      pn_emp1  := p.pgcod;
      pn_mod1  := p.aomod;
      pn_suc1  := p.aosuc;
      pn_mda1  := p.aomda;
      pn_pap1  := p.aopap;
      pn_cta1  := p.aocta;
      pn_oper1 := p.aooper;
      pn_estad := p.aostat;
    
      begin
      
        select a.aqpa455emp,
               a.aqpa455mod,
               a.aqpa455suc,
               a.aqpa455mda,
               a.aqpa455pap,
               a.aqpa455cta,
               a.aqpa455oper,
               a.aqpa455flag,
               a.aqpa455usr
          INTO pn_aqpa455emp,
               pn_aqpa455mod,
               pn_aqpa455suc,
               pn_aqpa455mda,
               pn_aqpa455pap,
               pn_aqpa455cta,
               pn_aqpa455oper,
               pv_aqpa455flag,
               pv_aqpa455usr
          from aqpa455 a
         where a.aqpa455emp = pn_emp1
       --  and a.aqpa455mod = pn_mod1
           and a.aqpa455suc = pn_suc1
           and a.aqpa455mda = pn_mda1
           and a.aqpa455pap = pn_pap1
           and a.aqpa455cta = pn_cta1
           and a.aqpa455oper = pn_oper1
           and rownum = 1;
      exception
        when no_data_found then
          flag := 'R';
          pv_aqpa455usr:= 'usr';
      end;

      Begin

        select o.Res
         into pv_Resultado     
          from ((select (case
                          when a.AOMOD in (33, 200) then
                           'S'
                          else
                           'N'
                        end) as Res
                
                   from fsd010 a
                  where a.aocta = pn_cta1
                    and a.aooper = pn_oper1
                    and a.aostat <> 555
                    and a.AOMOD in (109, 33, 200)
                  order by aosbop desc, aostat asc))o
         where rownum = 1;
        
         exception when no_data_found then flag2 := 'N';

      End;
    
      begin
        if pn_mod1 = 109 and pv_aqpa455flag <> 'S' and pn_estad <> 99 and pv_Resultado <> 'S' and flag2 <>'N' 
        and pv_aqpa455usr <> pv_user then
          insert into aqpa455
            (aqpa455emp,
             aqpa455mod,
             aqpa455suc,
             aqpa455mda,
             aqpa455pap,
             aqpa455cta,
             aqpa455oper,
             aqpa455sbop,
             aqpa455tope,
             aqpa455imp,
             aqpa455fval,
             aqpa455fe99,
             aqpa455period,
             aqpa455estd2,
             aqpa455flag,
             aqpa455usr)
            select o.pgcod,
                   o.aomod,
                   o.aosuc,
                   o.aomda,
                   o.aopap,
                   o.aocta,
                   o.aooper,
                   o.aosbop,
                   o.aotope,
                   o.aoimp,
                   o.aofval,
                   o.aofe99,
                   o.aoperiod,
                   o.aostat,
                   'S',
                   pv_user
              from (select s.pgcod,
                           s.aomod,
                           s.aosuc,
                           s.aomda,
                           s.aopap,
                           s.aocta,
                           s.aooper,
                           s.aosbop,
                           s.aotope,
                           s.aoimp,
                           s.aofval,
                           s.aofe99,
                           s.aoperiod,
                           s.aostat
                      from fsd010 s
                     where s.pgcod = pn_emp1
                       and s.aomod = pn_mod1 --pn_R1MOD-- in (200,33,109)--= pn_mod1
                       and s.aomda = pn_mda1
                       and s.aosuc = pn_suc1
                       and s.aopap = pn_pap1
                       and s.aocta = pn_cta1
                       and s.aooper = pn_oper1
                       and s.aostat <> 99
                     order by s.aofe99 asc, s.aosbop desc) o
             where rownum = 1;
        
          commit;
        end if;
      
        if pv_aqpa455flag <> 'S' and flag = 'R' or flag = null and pn_mod1 = 109 and pn_estad = 99 and pv_Resultado <> 'S' and flag2 <>'N'
         and pv_aqpa455usr <> pv_user then
          insert into aqpa455
            (aqpa455emp,
             aqpa455mod,
             aqpa455suc,
             aqpa455mda,
             aqpa455pap,
             aqpa455cta,
             aqpa455oper,
             aqpa455sbop,
             aqpa455tope,
             aqpa455imp,
             aqpa455fval,
             aqpa455fe99,
             aqpa455period,
             aqpa455estd2,
             aqpa455flag,
             aqpa455usr)
            SELECT o.pgcod,
                   o.aomod,
                   o.aosuc,
                   o.aomda,
                   o.aopap,
                   o.aocta,
                   o.aooper,
                   o.aosbop,
                   o.aotope,
                   o.aoimp,
                   o.aofval,
                   o.aofe99,
                   o.aoperiod,
                   o.aostat,
                   'S',
                   pv_user
              FROM (select s.pgcod,
                           s.aomod,
                           s.aosuc,
                           s.aomda,
                           s.aopap,
                           s.aocta,
                           s.aooper,
                           s.aosbop,
                           s.aotope,
                           s.aoimp,
                           s.aofval,
                           s.aofe99,
                           s.aoperiod,
                           s.aostat
                      from fsd010 s
                     where s.pgcod = pn_emp1
                       and s.aomod = pn_mod1
                       and s.aomda = pn_mda1
                       and s.aosuc = pn_suc1
                       and s.aopap = pn_pap1
                       and s.aocta = pn_cta1
                       and s.aooper = pn_oper1
                       and s.aostat = 99
                       and s.aofe99 = (select max(s.aofe99)
                                         from fsd010 s
                                        where s.pgcod = pn_emp1
                                          and s.aomod = pn_mod1
                                          and s.aomda = pn_mda1
                                          and s.aosuc = pn_suc1
                                          and s.aopap = pn_pap1
                                          and s.aocta = pn_cta1
                                          and s.aooper = pn_oper1
                                          and s.aostat = 99
                                        group by s.aocta)
                    --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                     order by s.aofe99 desc) o
             WHERE rownum = 1;
          commit;
        end if;
      end;
    end loop;
  end;
  
begin
  -- Call the procedure
  pq_cuotasimpagas.fn_ultclave_cred2(pv_user);
end;

end fn_ultclave_cred3;

procedure fn_ultclave_cred4(pv_user in char, pd_fechaproceso in date ) is
  pn_emp1  number;
  pn_mod1  number;
  pn_mda1  number;
  pn_suc1  number;
  pn_pap1  number;
  pn_cta1  number;
  pn_oper1 number;
  pn_subo  number;
  pn_aof99 number;
  flag     character(1);
  flag2    character(1):='T';

  pn_R1COD  number;
  pn_R1MOD  number;
  pn_R1SUC  number;
  pn_R1MDA  number;
  pn_R1PAP  number;
  pn_R1CTA  number;
  pn_R1OPER number;
  pn_R1SBOP number;
  pn_R1TOPE number;
  pn_estad  number;

  pn_aqpa455emp  number;
  pn_aqpa455mod  number;
  pn_aqpa455suc  number;
  pn_aqpa455mda  number;
  pn_aqpa455pap  number;
  pn_aqpa455cta  number;
  pn_aqpa455oper number;
  pv_aqpa455flag character(1) := 'N';
  pv_aqpa455usr  character(20);

  pn_emp3  number;
  pn_mod3  number;
  pn_suc3  number;
  pn_mda3  number;
  pn_pap3  number;
  pn_cta3  number;
  pn_oper3 number;
  pv_Resultado character(1);

Cursor fsd010_b is
  
    select n.pgcod,
           n.aomod,
           n.aosuc,
           n.aomda,
           n.aopap,
           n.aocta,
           n.aooper,
           n.aosbop,
           n.aotope,
           n.aostat
      from fsd010 n
     where n.pgcod = 1
       and n.AOCTA not in (select j.jaqy953cta from jaqy953 j)
       and n.AOSBOP in
           (select max(a.AOSBOP)
              from fsd010 a
             where a.AOCTA = n.AOCTA
               and a.AOOPER = n.AOOPER
               and a.AOMOD in (select modulo from fst111 where dscod = 50)
               and a.aomod = 109)
       and n.AOMOD in (select modulo from fst111 where dscod = 50)
       and n.aomod = 109
     order by n.AOCTA;

begin
  Begin
    delete from aqpa455 a where a.aqpa455usr = pv_user and a.aqpa455fepro=pd_fechaproceso;
    commit;
  
    for p in fsd010_b loop
      pn_emp1  := p.pgcod;
      pn_mod1  := p.aomod;
      pn_suc1  := p.aosuc;
      pn_mda1  := p.aomda;
      pn_pap1  := p.aopap;
      pn_cta1  := p.aocta;
      pn_oper1 := p.aooper;
      pn_estad := p.aostat;
    
      begin
        select a.aqpa455emp,
               a.aqpa455mod,
               a.aqpa455suc,
               a.aqpa455mda,
               a.aqpa455pap,
               a.aqpa455cta,
               a.aqpa455oper,
               a.aqpa455flag,
               a.aqpa455usr
          INTO pn_aqpa455emp,
               pn_aqpa455mod,
               pn_aqpa455suc,
               pn_aqpa455mda,
               pn_aqpa455pap,
               pn_aqpa455cta,
               pn_aqpa455oper,
               pv_aqpa455flag,
               pv_aqpa455usr
          from aqpa455 a
         where a.aqpa455emp = pn_emp1
           and a.aqpa455mod = pn_mod1  --estaba comentado 06082018
           and a.aqpa455suc = pn_suc1
           and a.aqpa455mda = pn_mda1
           and a.aqpa455pap = pn_pap1
           and a.aqpa455cta = pn_cta1
           and a.aqpa455oper = pn_oper1
           AND A.AQPA455USR = pv_user--agregado 12-06-2018 rmogrovejo  --estaba comentado 06082018
           and rownum = 1;
      exception
        when no_data_found then
          flag := 'R';
          pv_aqpa455usr:= 'usr';
      end;

      Begin

        select o.Res
         into pv_Resultado     
          from ((select (case
                          when a.AOMOD in (33, 200) then
                           'S'
                          else
                           'N'
                        end) as Res
                
                   from fsd010 a
                  where a.aocta = pn_cta1
                    and a.aooper = pn_oper1
                    and a.aostat <> 555
                    and a.AOMOD in (109, 33, 200)
                  order by aosbop desc, aostat asc))o
         where rownum = 1;
        
         exception when no_data_found then flag2 := 'N';

      End;
    
      begin
        if pn_mod1 = 109 /*and pv_aqpa455flag <> 'S'*/ and pn_estad <> 99 and pv_Resultado <> 'S' and flag2 <>'N' 
      /*  and pv_aqpa455usr <> pv_user */then
          insert into aqpa455
            (aqpa455emp,
             aqpa455mod,
             aqpa455suc,
             aqpa455mda,
             aqpa455pap,
             aqpa455cta,
             aqpa455oper,
             aqpa455sbop,
             aqpa455tope,
             aqpa455imp,
             aqpa455fval,
             aqpa455fe99,
             aqpa455period,
             aqpa455estd2,
             aqpa455flag,
             aqpa455usr,
             aqpa455fepro)
            select o.pgcod,
                   o.aomod,
                   o.aosuc,
                   o.aomda,
                   o.aopap,
                   o.aocta,
                   o.aooper,
                   o.aosbop,
                   o.aotope,
                   o.aoimp,
                   o.aofval,
                   o.aofe99,
                   o.aoperiod,
                   o.aostat,
                   'S',
                   pv_user,
                   pd_fechaproceso
              from (select s.pgcod,
                           s.aomod,
                           s.aosuc,
                           s.aomda,
                           s.aopap,
                           s.aocta,
                           s.aooper,
                           s.aosbop,
                           s.aotope,
                           s.aoimp,
                           s.aofval,
                           s.aofe99,
                           s.aoperiod,
                           s.aostat
                      from fsd010 s
                     where s.pgcod = pn_emp1
                       and s.aomod = pn_mod1 --pn_R1MOD-- in (200,33,109)--= pn_mod1
                       and s.aomda = pn_mda1
                       and s.aosuc = pn_suc1
                       and s.aopap = pn_pap1
                       and s.aocta = pn_cta1
                       and s.aooper = pn_oper1
                       and s.aostat <> 99
                     order by s.aofe99 asc, s.aosbop desc) o
             where rownum = 1;
        
          commit;
        end if;
      --validar que grabe todo
        if /*pv_aqpa455flag <> 'S' flag = 'R'  and*/ pn_mod1 = 109 and pn_estad = 99 and pv_Resultado <> 'S' and flag2 <>'N'
        /* and pv_aqpa455usr <> pv_user */then
          insert into aqpa455
            (aqpa455emp,
             aqpa455mod,
             aqpa455suc,
             aqpa455mda,
             aqpa455pap,
             aqpa455cta,
             aqpa455oper,
             aqpa455sbop,
             aqpa455tope,
             aqpa455imp,
             aqpa455fval,
             aqpa455fe99,
             aqpa455period,
             aqpa455estd2,
             aqpa455flag,
             aqpa455usr,
             aqpa455fepro)
            SELECT o.pgcod,
                   o.aomod,
                   o.aosuc,
                   o.aomda,
                   o.aopap,
                   o.aocta,
                   o.aooper,
                   o.aosbop,
                   o.aotope,
                   o.aoimp,
                   o.aofval,
                   o.aofe99,
                   o.aoperiod,
                   o.aostat,
                   'S',
                   pv_user,
                   pd_fechaproceso
              FROM (select s.pgcod,
                           s.aomod,
                           s.aosuc,
                           s.aomda,
                           s.aopap,
                           s.aocta,
                           s.aooper,
                           s.aosbop,
                           s.aotope,
                           s.aoimp,
                           s.aofval,
                           s.aofe99,
                           s.aoperiod,
                           s.aostat
                      from fsd010 s
                     where s.pgcod = pn_emp1
                       and s.aomod = pn_mod1
                       and s.aomda = pn_mda1
                       and s.aosuc = pn_suc1
                       and s.aopap = pn_pap1
                       and s.aocta = pn_cta1
                       and s.aooper = pn_oper1
                       and s.aostat = 99
                       and s.aofe99 = (select max(s.aofe99)
                                         from fsd010 s
                                        where s.pgcod = pn_emp1
                                          and s.aomod = pn_mod1
                                          and s.aomda = pn_mda1
                                          and s.aosuc = pn_suc1
                                          and s.aopap = pn_pap1
                                          and s.aocta = pn_cta1
                                          and s.aooper = pn_oper1
                                          and s.aostat = 99
                                        group by s.aocta)
                    --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                     order by s.aofe99 desc) o
             WHERE rownum = 1;
          commit;
        end if;
      end;
    end loop;
  end;

begin
  -- Call the procedure
  pq_cuotasimpagas.fn_ultclave_cred5(pv_user,pd_fechaproceso);
end;

end fn_ultclave_cred4;

procedure fn_ultclave_cred5 ( pv_user in char,pd_fechaproceso in date) is

pn_emp1  number;
pn_mod1  number;
pn_mda1  number;
pn_suc1  number;
pn_pap1  number;
pn_cta1  number;
pn_oper1 number;
pn_subo number;
pn_aof99 number;
flag character (1);

pn_R1COD number;
pn_R1MOD number;
pn_R1SUC number;
pn_R1MDA number;
pn_R1PAP number;
pn_R1CTA number;
pn_R1OPER number;
pn_R1SBOP number;
pn_R1TOPE number;
pn_estad number;

pn_aqpa455emp number;
pn_aqpa455mod number;
pn_aqpa455suc number;
pn_aqpa455mda number;
pn_aqpa455pap number;
pn_aqpa455cta number;
pn_aqpa455oper number;
pv_aqpa455flag character (1):= 'N';
pv_aqpa455usr character(20);

pn_emp3  number;
pn_mod3  number;
pn_suc3  number;
pn_mda3  number;
pn_pap3  number;
pn_cta3  number;
pn_oper3 number;
pn_cuenta number;
pn_oper   number;
pn_tpnro number;
pn_tpnro2 number;

Cursor fsd010_a is 

select n.pgcod,
       n.aomod,
       n.aosuc,
       n.aomda,
       n.aopap,
       n.aocta,
       n.aooper,
       n.aosbop,
       n.aotope,
       n.aostat
  from fsd010 n
where n.pgcod = 1
   and n.AOCTA not in (select j.jaqy953cta from jaqy953 j)
   and n.AOSBOP in
       (select max(a.AOSBOP)
          from fsd010 a
         where a.AOCTA = n.AOCTA
           and a.AOOPER = n.AOOPER
           and a.AOMOD in (select modulo from fst111 where dscod = 50)
           and a.aomod in (33, 200)
           and a.AOSTAT <> 99)
   and n.AOMOD in (select modulo from fst111 where dscod = 50)
   and n.aomod in (33, 200)
--   and n.aocta = 15934--pn_cuenta
--   and n.aooper =551739--pn_oper
   and n.AOSTAT <> 99
order by n.AOCTA;
       
    
begin
  Begin  
        
for p in fsd010_a loop
     pn_emp1  := p.pgcod;
     pn_mod1  := p.aomod;
     pn_suc1  := p.aosuc;
     pn_mda1  := p.aomda;
     pn_pap1  := p.aopap;
     pn_cta1  := p.aocta;
     pn_oper1 := p.aooper;
     pn_estad := p.aostat;
 
          begin

            select a.aqpa455emp,
                   a.aqpa455mod,
                   a.aqpa455suc,
                   a.aqpa455mda,
                   a.aqpa455pap,
                   a.aqpa455cta,
                   a.aqpa455oper,
                   a.aqpa455flag,
                   a.aqpa455usr
              INTO pn_aqpa455emp,
                   pn_aqpa455mod,
                   pn_aqpa455suc,
                   pn_aqpa455mda,
                   pn_aqpa455pap,
                   pn_aqpa455cta,
                   pn_aqpa455oper,
                   pv_aqpa455flag,
                   pv_aqpa455usr
              from aqpa455 a
             where a.aqpa455emp = pn_emp1
                  --  and a.aqpa455mod = pn_mod1
               and a.aqpa455suc = pn_suc1
               and a.aqpa455mda = pn_mda1
               and a.aqpa455pap = pn_pap1
               and a.aqpa455cta = pn_cta1
               and a.aqpa455oper = pn_oper1
               and rownum = 1;
          exception
            when no_data_found then
              flag          := 'R';
           --   pv_aqpa455usr := 'usr';
          end;
-----castigado
begin

select tpnro
  into pn_tpnro
  from fst098
 where tpcod = 7728
   and tpcorr = 5; ---guia de proceso castigados
end;

if pn_mod1 = 33 then --si es 200 valido que sea anterior mente un 109 
begin
  select d.R1COD,d.R1MOD,d.R1SUC,d.R1MDA,d.R1PAP,d.R1CTA,d.R1OPER,d.R1SBOP,d.R1TOPE 
            into  pn_R1COD, 
                  pn_R1MOD,
                  pn_R1SUC,
                  pn_R1MDA,
                  pn_R1PAP,
                  pn_R1CTA,
                  pn_R1OPER,
                  pn_R1SBOP,
                  pn_R1TOPE
            from fsr011 d
                    where R2cod = pn_emp1 
                    and R2mod =   pn_mod1 
                    and R2suc =   pn_suc1 
                    and R2mda =   pn_mda1 
                    and R2pap =   pn_pap1 
                    and R2cta =   pn_cta1 
                    and R2oper =  pn_oper1
                    and Relcod = pn_tpnro --34 --guia de proceso   CAMBIAR
                    and rownum=1;
           exception
              when no_data_found then
                flag := 'T';               
end;

begin
 if  pn_R1MOD = 109 and pn_estad <> 99 /* and pv_aqpa455usr <> pv_user*/ then        
            insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr,
                 aqpa455fepro
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user,pd_fechaproceso
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;    
  end if;   
end;

begin
         
if  /* pv_aqpa455flag <> 'S' andflag='R'  and */pn_mod1 =109 and pn_estad = 99  /*and pv_aqpa455usr <> pv_user */
then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr,
            aqpa455fepro)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user, pd_fechaproceso
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1 
                                and s.aosuc  = pn_suc1  
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
 end if;
end;
--------------------------------------termina mod 33------- -----------------------------------------
end if;
-------------------------------------------------------
begin
select tpnro
  into pn_tpnro2
  from fst098
 where tpcod = 7728
   and tpcorr = 6; ---guia de proceso castigados
end;

if pn_mod1 = 200  /*and pv_aqpa455usr <> pv_user */then --si es 200 valido que sea anterior mente un 109 
begin
  select d.R1COD,d.R1MOD,d.R1SUC,d.R1MDA,d.R1PAP,d.R1CTA,d.R1OPER,d.R1SBOP,d.R1TOPE 
            into  pn_R1COD, 
                  pn_R1MOD,
                  pn_R1SUC,
                  pn_R1MDA,
                  pn_R1PAP,
                  pn_R1CTA,
                  pn_R1OPER,
                  pn_R1SBOP,
                  pn_R1TOPE
            from fsr011 d
                    where R2cod = pn_emp1 
                    and R2mod =   pn_mod1 
                    and R2suc =   pn_suc1 
                    and R2mda =   pn_mda1 
                    and R2pap =   pn_pap1 
                    and R2cta =   pn_cta1 
                    and R2oper =  pn_oper1
                    and Relcod = pn_tpnro2--52 --guia de proceso   CAMBIAR
                    and rownum=1;
           exception
              when no_data_found then
                flag := 'T';               
end;

begin
 if  pn_R1MOD = 109 and pn_estad <> 99  /*and pv_aqpa455usr <> pv_user*/ then        
            insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr,
                 aqpa455fepro
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user,pd_fechaproceso
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;    
  end if;   
end;

begin
         
if /* pv_aqpa455flag <> 'S' and flag='R'  and*/ pn_mod1 =109 and pn_estad = 99 /* and pv_aqpa455usr <> pv_user */
then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr,
            aqpa455fepro)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user, pd_fechaproceso
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1 
                                and s.aosuc  = pn_suc1  
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
 end if;
end;
---------------------------------------------------------------------------------------------------termina mod 200------- 
end if;

begin 
 if pn_mod1 = 109 /*and pv_aqpa455flag <> 'S' */ and pn_estad <> 99  /* and pv_aqpa455usr <> pv_user */
 then 
         insert into aqpa455
                (aqpa455emp,
                 aqpa455mod,
                 aqpa455suc, 
                 aqpa455mda, 
                 aqpa455pap,
                 aqpa455cta, 
                 aqpa455oper, 
                 aqpa455sbop,
                 aqpa455tope, 
                 aqpa455imp, 
                 aqpa455fval, 
                 aqpa455fe99,
                 aqpa455period,
                 aqpa455estd2,
                 aqpa455flag,
                 aqpa455usr,
                 aqpa455fepro
                 )
               select o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user, pd_fechaproceso
               from( select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                       from fsd010 s
                              where s.pgcod  = pn_emp1
                               and s.aomod =  pn_mod1--pn_R1MOD-- in (200,33,109)--= pn_mod1
                               and s.aomda  = pn_mda1 
                               and s.aosuc  = pn_suc1
                               and s.aopap  = pn_pap1
                               and s.aocta  = pn_cta1
                               and s.aooper = pn_oper1
                               and s.aostat <> 99
                               order by s.aofe99 asc, s.aosbop desc
                               )o where rownum = 1;

               commit;                
   end if;   
  
if /* pv_aqpa455flag <> 'S' and flag='R' and*/  pn_mod1 =109 and pn_estad = 99  /*and pv_aqpa455usr <> pv_user */
then
   insert into aqpa455
           (aqpa455emp,
            aqpa455mod,
            aqpa455suc, 
            aqpa455mda, 
            aqpa455pap,
            aqpa455cta, 
            aqpa455oper, 
            aqpa455sbop,
            aqpa455tope, 
            aqpa455imp, 
            aqpa455fval, 
            aqpa455fe99,
            aqpa455period,
            aqpa455estd2,
            aqpa455flag,
            aqpa455usr,
            aqpa455fepro)
            SELECT o.pgcod,o.aomod,o.aosuc,o.aomda,o.aopap,o.aocta,o.aooper,o.aosbop,o.aotope,o.aoimp,o.aofval,o.aofe99,o.aoperiod,o.aostat,'S',pv_user, pd_fechaproceso
                 FROM (
                     select s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                              from fsd010 s
                               where s.pgcod  =  pn_emp1 
                                and s.aomod  =   pn_mod1
                                and s.aomda  =   pn_mda1 
                                and s.aosuc  =   pn_suc1  
                                and s.aopap  =   pn_pap1 
                                and s.aocta  =   pn_cta1 
                                and s.aooper =   pn_oper1
                                and s.aostat = 99
                               and s.aofe99 = (select max(s.aofe99)                                                  from fsd010 s
                               where s.pgcod = pn_emp1 
                                and s.aomod  = pn_mod1 
                                and s.aomda  = pn_mda1  
                                and s.aosuc  = pn_suc1 
                                and s.aopap  = pn_pap1 
                                and s.aocta  = pn_cta1 
                                and s.aooper = pn_oper1
                                and s.aostat = 99
                                group by s.aocta
                              )              
                               --s.pgcod,s.aomod,s.aosuc,s.aomda,s.aopap,s.aocta,s.aooper,s.aosbop,s.aotope,s.aoimp,s.aofval,s.aofe99,s.aoperiod,s.aostat
                               order by s.aofe99 desc  
                             ) o
                      WHERE rownum = 1; 
                 commit;
  end if;
end; 

  pn_cuenta:= pn_cta1;
  pn_oper  := pn_oper1;
 
end loop;

end;

end fn_ultclave_cred5;
--/////////---------------******************--------------------*****//////////////////
/*select * from fsd010 ss where ss.aocta=1355074 and ss.aomod=109;
select * from aqpa455  where aqpa455cta=1355074 and aqpa455mod=109 and aqpa455usr='RMOGROVEJO';
select * from fpp028 d where d.pp017par=17 and d.pp028mod=109 and d.pp028top=60;---defn=35
select * from fsr027 z where z.tpizar=35 and z.modulo=609; --and z.ctnro=500000003;  
select * from fsd009 ss where ss.tgcod=50 and ss.ctnro=1355074;--ss.grnro=8 ss.ctnro and ss.ctnro=1355074 ;

SELECT  to_number(SUBSTR(ctnro, INSTR(ctnro, ',')-2))FROM fsr027 z
where z.tpizar=35 and z.modulo=609; 
*/

procedure fn_impr_convenio ( pc_user in character,pd_fechaproceso in date
                            /*, MOSTRAR OUT CHAR*/) is
 
pn_cuenta NUMBER;
pn_modulo NUMBER;
pn_tipope NUMBER;
pn_pp028defn NUMBER;
pn_ctnro NUMBER;
pn_resultado number;
pn_grnro number;
pn_moneda number;
pn_resul027 number;
pn_resul009 number;
pn_operacion number;
pn_campana varchar2(60);
pn_rcontador number:=0;
pn_rcontador2 number:=0;
--pn_campana char(50);

cursor aqpa455 is
                
      select * from aqpa455 
      where aqpa455usr=pc_user;
    --  and aqpa455cta=1480120 and aqpa455tope=60;           

cursor fsr027 is

      SELECT distinct(to_number(SUBSTR(z.ctnro, INSTR(z.ctnro, ',')-2))) as resultado
       into pn_resultado
      FROM fsr027 z
       where z.tpizar=pn_pp028defn and z.modulo=609; 
  
cursor fsd009 is

      select ss.grnro
             into pn_grnro
             from fsd009 ss
             where ss.tgcod=50 and ss.ctnro=pn_cuenta;
                             
begin 
  begin
      
  for p in aqpa455 loop
     pn_cuenta := p.aqpa455cta;
     pn_operacion := p.aqpa455oper;
     pn_modulo := p.aqpa455mod;
     pn_tipope := p.aqpa455tope;
     pn_moneda := p.aqpa455mda;
     pn_rcontador :=0;
     pn_rcontador2 :=0;     
         
    begin
       
       select d.pp028defn 
       into pn_pp028defn
       from fpp028 d 
       where d.pp017par=17 
       and d.pp028mod=pn_modulo and d.pp028top=pn_tipope and d.pp028mda=pn_moneda;---defn=35
      
     exception
       when no_data_found then null;
     
     
     end;
        
 for a in fsr027 loop
        pn_resul027 := a.resultado;
        pn_rcontador2 :=1;
       for b in fsd009 loop                                                 
            pn_resul009:= b.grnro;
            
     
   if  pn_resul027 = pn_resul009 then 
       
    pn_rcontador:=1;
    
     select j.grnom
     into pn_campana
     from fst031 j where j.tgcod=50 and j.grnro=a.resultado;
     
     --MOSTRAR:=pn_campana;
          
      update aqpa455 tab 
        set tab.aqpa455ccamp = a.resultado,
            tab.aqpa455nomca = pn_campana,
            tab.aqpa455fepro = pd_fechaproceso
        where tab.aqpa455cta = pn_cuenta
        and tab.aqpa455oper = pn_operacion
        and tab.aqpa455fepro = pd_fechaproceso 
        and tab.aqpa455usr=pc_user;
        commit;
        
        
    end if; 
    
  end loop;   
  
           if pn_rcontador = 0 then
              
               update aqpa455 tab 
                        set tab.aqpa455ccamp = -1,
                            tab.aqpa455nomca = 'Cuenta no tiene un convenio',
                            tab.aqpa455fepro = pd_fechaproceso
                        where tab.aqpa455cta = pn_cuenta
                        and tab.aqpa455oper = pn_operacion
                        and tab.aqpa455fepro = pd_fechaproceso 
                        and tab.aqpa455usr=pc_user;
                        commit;     
                        
            end if;
           
 end loop;
 
             if pn_rcontador2 = 0 then ----sgeund0
                  
                   update aqpa455 tab 
                            set tab.aqpa455ccamp = -1,
                                tab.aqpa455nomca = 'Cuenta no tiene un convenio',
                                tab.aqpa455fepro = pd_fechaproceso
                            where tab.aqpa455cta = pn_cuenta
                            and tab.aqpa455oper = pn_operacion
                            and tab.aqpa455fepro = pd_fechaproceso 
                            and tab.aqpa455usr=pc_user;
                            commit;     
                            
              end if;
 
end loop; 

end;

begin
  -- Call the procedure
  pq_cuotasimpagas.fn_impr_convenio_avales(pc_user,
                                           pd_fechaproceso);
end;

end fn_impr_convenio;

procedure fn_impr_convenio_avales ( pc_user in character,pd_fechaproceso in date
                                    /*, MOSTRAR OUT CHAR*/) is
  
pn_instancia number(10);
pn_cuenta_inst number(9);
pn_cuenta  number(9);
pn_instanciasng number(10);
pn_nro_grupo number;
pn_cod_grupo number;
pv_nom_convenio char(30);
cuenta number;
pn_operation number(9);

cursor aqpa455 is

      select *
        from aqpa455
       where aqpa455ccamp is null
         and aqpa455usr = pc_user
      --  and aqpa455cta = 1480120
     --   and aqpa455oper= 1017112
         and aqpa455fepro = pd_fechaproceso; 

cursor sng003 is 

 select *
         from sng003 
         where sng003cta=pn_cuenta_inst;
         
begin
  begin
    
     for a in aqpa455 loop
            
      begin
         select b.xwfprcins
           into pn_instancia --obtengo instancia 
           from xwf700 b
          where b.xwfempresa = a.aqpa455emp
            and b.xwfsucursal = a.aqpa455suc
            and b.xwfmodulo = a.aqpa455mod
            and b.xwfmoneda = a.aqpa455mda
            and b.xwfpapel = a.aqpa455pap
            and b.xwfcuenta = a.aqpa455cta
            and b.xwfoperacion = a.aqpa455oper
            and b.xwfsubope = a.aqpa455sbop
            and b.xwftipope = a.aqpa455tope
            and b.xwfcar3 ='1'
            and rownum=1;
            
            exception
              when no_data_found then
                pn_instancia:=0;
       end;
       
       begin
         select s.sng003cta
         into pn_cuenta_inst --obtengo la cuenta que avala
         from sng003 s 
         where s.sng001inst=pn_instancia
         and rownum=1; ---verificar
       exception
            when no_data_found then
               pn_cuenta_inst:=0;
        end;
       
       
    for b in sng003 loop
      pn_instanciasng := b.sng001inst;
           
  --/////////////////////////////////////////////////////////////////////////////      
       begin
         
            select aa.aocta ,aa.aooper --b.aqpa455nomca, aa.*, a.*
              into pn_cuenta, pn_operation
              from xwf700 a
             inner join fsd010 aa
                on a.xwfempresa = aa.pgcod
               and a.xwfsucursal = aa.aosuc
               and a.xwfmodulo = aa.aomod
               and a.xwfmoneda = aa.aomda
               and a.xwfpapel = aa.aopap
               and a.xwfcuenta = aa.aocta
               and a.xwfoperacion = aa.aooper
               and a.xwfsubope = aa.aosbop
               and a.xwftipope = aa.aotope
             inner join aqpa455 b
                on aa.pgcod = b.aqpa455emp
               and aa.aomod = b.aqpa455mod
               and aa.aosuc = b.aqpa455suc
               and aa.aomda = b.aqpa455mda
               and aa.aopap = b.aqpa455pap
               and aa.aocta = b.aqpa455cta
               and aa.aooper = b.aqpa455oper
               and aa.aosbop = b.aqpa455sbop
               and aa.aotope = b.aqpa455tope
             where aa.aomod = 109
               and b.aqpa455fepro = pd_fechaproceso --to_date('25/12/2018', 'dd/mm/yyyy')
               and b.aqpa455usr = pc_user
               and b.aqpa455ccamp is null
               and a.xwfprcins = pn_instanciasng;
               
            exception
              when no_data_found then
                pn_cuenta:=0;

       end;
       
       begin
         
         select ss.grnro 
         into pn_nro_grupo
         from fsd009 ss         
             where ss.tgcod=50 and ss.ctnro=pn_cuenta;
         exception
              when no_data_found then
                pn_nro_grupo:=0;
       
       end;
       
       
       if pn_cuenta <> 0 then   
               
             begin       
                 select dd.grnro, dd.grnom
                 into pn_cod_grupo,pv_nom_convenio
                 from fst031 dd 
                 where  dd.tgcod=50 and dd.grnro=pn_nro_grupo;
             end;
             --MOSTRAR:=pv_nom_convenio;
             
             begin
           ----update a la tabla para acutualizar el convenio
                  update aqpa455 tab
                     set tab.aqpa455ccamp = pn_cod_grupo,
                         tab.aqpa455nomca = pv_nom_convenio,
                         tab.aqpa455fepro = pd_fechaproceso
                   where tab.aqpa455cta = pn_cuenta
                     and tab.aqpa455oper = pn_operation
                     and tab.aqpa455fepro = pd_fechaproceso
                     and tab.aqpa455usr = pc_user;
                  commit;
        
             end;
        
       end if;        
      
      
      end loop;
      
    end loop;  
  end;
  
end fn_impr_convenio_avales;

end pq_cuotasimpagas;
/

