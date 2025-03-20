create or replace package PQ_CR_INT_DIFERIDO is

  -- Author  : ABERNEDO
  -- Created : 07/05/2015 07:30:38 p.m.
  -- Purpose : 
  Procedure sp_Carga_data(pd_fecini in date,pd_fecfin in date);
  Procedure sp_Carga_lineas(pd_fecini in date,pd_fecfin in date);
  Procedure SP_Carga_LineasII (pd_fecini in date,pd_fecfin in date );
  Procedure sp_job_CargaII (pd_fecini in date,pd_fecfin in date );
  Procedure SP_CargaII (PN_SUC IN NUMBER,pd_fecini in date,pd_fecfin in date ) ;
  Procedure sp_Interes_Diferido(pn_emp in number,pn_pap in number,pn_cta in number,pn_oper in number,
                          pd_fval in date, pn_tipsol in number,PD_FECPRO in date, ln_intcom out number,
                          ln_intmor out number);
  Procedure sp_Interes_DiferidoII(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                          pn_rel in number, pn_fec in date,pn_cta in number,
                           ln_ord55 out number,ln_ord65 out number);                          
  Procedure sp_Interes_Diferido_Lineas(pn_emp in number,pn_pap in number,pn_cta in number,
                                     pn_oper in number,pd_fval in date, ln_intcom out number) ;     
  Procedure sp_Interes_Diferido_LineasII(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                          pn_rel in number, pn_fec in date,pn_cta in number,
                           ln_ord55 out number) ;
                
  function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;                          
  Procedure SP_Actualizaciones(pd_fecpro in date);
  Procedure SP_ActualizacionesRubro(pd_fecpro in date);
  Procedure SP_ActualizacionesGrupo(pd_fecpro in date);
  Procedure SP_ActualizacionesLineas(pd_fecpro in date);
  Procedure Sp_ActualizaInteresCompe;
  Procedure Sp_ActualizatotcuoLineas(pd_fecpro in date);
  Procedure Sp_ActualizacionRubroLineas(pd_fecpro in date);
  Procedure Sp_ActualizacionGrupoLineas(pd_fecpro in date);
end PQ_CR_INT_DIFERIDO;
/

create or replace package body PQ_CR_INT_DIFERIDO is

Procedure sp_Carga_data(pd_fecini in date,pd_fecfin in date)is


begin

      execute immediate('truncate table jaqz057');
      begin
      
      insert into JAQZ057(JAQZ057EMP,JAQZ057MOD,JAQZ057SUC,JAQZ057MDA,JAQZ057PAP,JAQZ057CTA,
                                      JAQZ057OPE,JAQZ057SBO,JAQZ057TOP,JAQZ057INS,JAQZ057FED,JAQZ057SOL,
                                      JAQZ057EST,JAQZ057FDC,JAQZ057CUO,JAQZ057PZO)
                                      
      select /*+ all_rows*/pgcod,
                   aomod,
                   aosuc,
                   aomda,
                   aopap,
                   aocta,
                   aooper,
                   aosbop,
                   aotope,
                   instancia,
                   aofval,
                   sng001ori,
                   aostat,
                   aofe99,
                   pq_cr_int_diferido.fn_cuotas_pagadas( pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,
                                                        aosbop,aotope,pd_fecfin)cuo_pag,aopzo
              from (select f.pgcod,
                           f.aomod,
                           f.aosuc,
                           f.aomda,
                           f.aopap,
                           f.aocta,
                           f.aooper,
                           f.aosbop,
                           f.aotope,
                           f.aofval,
                           f.aostat,
                           /*bantprod.*/fn_instancia_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper,f.aosbop,f.aotope) instancia,
                           f.aofe99,
                           f.aopzo
                     
                      from /*bantprod.*/fsd010 f
                     where f.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29, 120, 144,200,33,108,116))
                       and f.aofval between pd_fecini and pd_fecfin
                       and f.aostat <> 99) a ,/*bantprod.*/sng001 b
             where b.sng001inst = instancia
               and b.sng001ori in (/*3,*/4,13,14,15,16)
               
           union
           
           select /*+ all_rows*/pgcod,
                   aomod,
                   aosuc,
                   aomda,
                   aopap,
                   aocta,
                   aooper,
                   aosbop,
                   aotope,
                   instancia,
                   aofval,
                   sng001ori,
                   aostat,
                   aofe99,
                   pq_cr_int_diferido.fn_cuotas_pagadas( pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,
                                                        aosbop,aotope,pd_fecfin)cuo_pag,
                   aopzo
              from (select f.pgcod,
                           f.aomod,
                           f.aosuc,
                           f.aomda,
                           f.aopap,
                           f.aocta,
                           f.aooper,
                           f.aosbop,
                           f.aotope,
                           f.aofval,
                           f.aostat,
                           /*bantprod.*/fn_instancia_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper,f.aosbop,f.aotope) instancia,
                           f.aofe99,
                           f.aopzo
                     
                      from /*bantprod.*/fsd010 f
                     where f.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29, 120, 144,200,33,108,116))
                       and f.aofval between pd_fecini and pd_fecfin
                       and (f.aostat = 99 and f.aofe99 > pd_fecfin) )a ,/*bantprod.*/sng001 b
             where b.sng001inst = instancia
               and b.sng001ori in (/*3,*/4,13,14,15,16)
                ;
      
      commit;
      end;
      
end sp_Carga_data;


Procedure sp_Carga_lineas(pd_fecini in date,pd_fecfin in date)is


begin
      execute immediate ('truncate table jaqz059_INT');    
      begin
      
      insert into JAQZ059_INT(JAQZ059EMP,JAQZ059MOD,JAQZ059SUC,JAQZ059MDA,JAQZ059PAP,JAQZ059CTA,
                          JAQZ059OPE,JAQZ059SBO,JAQZ059TOP,JAQZ059INS,JAQZ059FED,JAQZ059SOL,
                          JAQZ059EST,JAQZ059FDC,JAQZ059PZO)
                                      
      select /*+ all_rows*/f.pgcod,
                           f.aomod,
                           f.aosuc,
                           f.aomda,
                           f.aopap,
                           f.aocta,
                           f.aooper,
                           f.aosbop,
                           f.aotope,
                           /*bantprod.*/fn_instancia_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper,f.aosbop,f.aotope) instancia,
                           f.aofval,
                           null,
                           f.aostat,
                           f.aofe99,
                           f.aopzo                         
                     
                      from /*bantprod.*/fsd010 f
                     where f.aomod = 116
                       and f.aofval between pd_fecini and pd_fecfin
                       and f.aostat <> 99
               
           union
           
           select /*+ all_rows*/f.pgcod,
                           f.aomod,
                           f.aosuc,
                           f.aomda,
                           f.aopap,
                           f.aocta,
                           f.aooper,
                           f.aosbop,
                           f.aotope,
                           /*bantprod.*/fn_instancia_credito(f.aomod,f.aosuc,f.aomda,f.aopap,f.aocta,f.aooper,f.aosbop,f.aotope) instancia,
                           f.aofval,
                           null,
                           f.aostat,
                           f.aofe99,
                           f.aopzo 
              from /*bantprod.*/fsd010 f
             where f.aomod = 116
               and f.aofval between pd_fecini and pd_fecfin
               and (f.aostat = 99 and f.aofe99 > pd_fecfin) ;
      
      commit;
      end;
      
end sp_Carga_lineas;

Procedure SP_Carga_LineasII (pd_fecini in date,pd_fecfin in date ) is

ln_intcom number(17,2);
cursor creditos is
  select a.jaqz059emp,
         a.jaqz059mod,
         a.jaqz059suc,
         a.jaqz059mda,
         a.jaqz059pap,
         a.jaqz059cta,
         a.jaqz059ope,
         a.jaqz059sbo,
         a.jaqz059top,
         a.jaqz059ins,
         a.jaqz059fed,
         a.jaqz059sol,
         a.jaqz059est,
         a.jaqz059fdc,
         a.jaqz059cuo,
         a.jaqz059pzo
    from jaqz059_INT a
   where a.jaqz059fed between pd_fecini and pd_fecfin;
begin
   execute immediate ('truncate table jaqz060');   
   
   begin
    
            for i in creditos loop
             begin 
             
                  pq_cr_int_diferido.sp_Interes_Diferido_Lineas(i.jaqz059emp,
                                                      i.jaqz059pap,
                                                      i.jaqz059cta,
                                                      i.jaqz059ope,
                                                      i.jaqz059fed,
                                                      ln_intcom);
             
                 insert into JAQZ060(JAQZ060EMP,JAQZ060MOD,JAQZ060SUC,JAQZ060MDA,JAQZ060PAP,JAQZ060CTA,
                                     JAQZ060OPE,JAQZ060SBO,JAQZ060TOP,JAQZ060INS,JAQZ060FED,JAQZ060SOL,
                                     JAQZ060EST,JAQZ060FDC,JAQZ060CUO,JAQZ060PZO,JAQZ060INC,JAQZ060INM)
                                     
                 values(i.jaqz059emp,i.jaqz059mod,i.jaqz059suc,i.jaqz059mda,i.jaqz059pap,i.jaqz059cta,
                        i.jaqz059ope,i.jaqz059sbo,i.jaqz059top,i.jaqz059ins,i.jaqz059fed,null,
                        i.jaqz059est,i.jaqz059fdc,i.jaqz059cuo,i.jaqz059pzo,ln_intcom,null)
                    
                        ;
                 commit;        
             
             end;       
             commit;
          end loop;
          commit;
    end;
  

end SP_Carga_LineasII;  

Procedure sp_job_CargaII (pd_fecini in date,pd_fecfin in date ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  lc_hostname varchar2(64);
  ln_job number:=0;
  --lc_coderr varchar2(300);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
      begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
     execute immediate('truncate table jaqz058');
--     execute immediate ('truncate table UAI_ACLPROCN');
     delete Tab_jobs where  c_Codage = 'ID';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  PQ_CR_INT_DIFERIDO.SP_CargaII('||ln_ini||','||''''||pd_fecini||'''' ||','||''''||pd_fecfin||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
         DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, 01/01/2024
                      force => false
                      );
else
      DBMS_JOB.SUBMIT(job => ln_job,
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('ID',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ID',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end sp_job_CargaII;

Procedure SP_CargaII (PN_SUC IN NUMBER,pd_fecini in date,pd_fecfin in date )is

ln_intcom number(17,2);
ln_intmor number(17,2);
cursor creditos is
  select a.jaqz057emp,
         a.jaqz057mod,
         a.jaqz057suc,
         a.jaqz057mda,
         a.jaqz057pap,
         a.jaqz057cta,
         a.jaqz057ope,
         a.jaqz057sbo,
         a.jaqz057top,
         a.jaqz057ins,
         a.jaqz057fed,
         a.jaqz057sol,
         a.jaqz057est,
         a.jaqz057fdc,
         a.jaqz057cuo,
         a.jaqz057pzo
    from jaqz057 a
    where A.JAQZ057SUC = PN_SUC
     AND a.jaqz057fed between pd_fecini and pd_fecfin;
begin
    --execute immediate('truncate table jaqz058');
    begin
          for i in creditos loop
           begin 
           
                pq_cr_int_diferido.sp_Interes_Diferido(i.jaqz057emp,
                                                    i.jaqz057pap,
                                                    i.jaqz057cta,
                                                    i.jaqz057ope,
                                                    i.jaqz057fed,
                                                    i.jaqz057sol,
                                                    pd_fecfin,
                                                    ln_intcom,
                                                    ln_intmor);
           
               insert into JAQZ058(JAQZ058EMP,JAQZ058MOD,JAQZ058SUC,JAQZ058MDA,JAQZ058PAP,JAQZ058CTA,
                                   JAQZ058OPE,JAQZ058SBO,JAQZ058TOP,JAQZ058INS,JAQZ058FED,JAQZ058SOL,
                                   JAQZ058EST,JAQZ058FDC,JAQZ058CUO,JAQZ058PZO,JAQZ058INC,JAQZ058INM)
                                   
               values(i.jaqz057emp,i.jaqz057mod,i.jaqz057suc,i.jaqz057mda,i.jaqz057pap,i.jaqz057cta,
                      i.jaqz057ope,i.jaqz057sbo,i.jaqz057top,i.jaqz057ins,i.jaqz057fed,i.jaqz057sol,
                      i.jaqz057est,i.jaqz057fdc,i.jaqz057cuo,i.jaqz057pzo,ln_intcom,ln_intmor)
                  
                      ;
               commit;        

           end;       
           commit;
        end loop;
        commit;
      end;
  

end SP_CargaII;  

Procedure sp_Interes_DiferidoII(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                          pn_rel in number, pn_fec in date,pn_cta in number,
                           ln_ord55 out number,ln_ord65 out number) is
                        
cursor interes is

--02.05.2018
select /*+index(b FSH01600)*/  b.hcta,
--select b.hcta,
       b.hoper,
       b.hcord,
       b.hcimp1
  from /*bantprod.*/fsh016 b
 where b.pgcod = pn_emp
   and b.hcmod = pn_mod
   and b.hsucor = pn_suc
   and b.htran = pn_trn
   and b.hnrel = pn_rel
   and b.hfcon = pn_fec
   and b.hcta   = pn_cta;
   
begin
   ln_ord55 := 0;
   ln_ord65 := 0;
   for i in interes loop
   
       if i.hcord = 55 then
          ln_ord55 := ln_ord55 + nvl(i.hcimp1,0);--mod@abr 20180705 se agrega nvl
          
          else 
               if i.hcord = 65 then
                  ln_ord65 := ln_ord65 + nvl(i.hcimp1,0);--mod@abr 20180705 se agrega nvl
                  
              end if;
       end if;
   end loop;

end sp_Interes_DiferidoII;

Procedure sp_Interes_Diferido(pn_emp in number,pn_pap in number,pn_cta in number,pn_oper in number,
                          pd_fval in date, pn_tipsol in number,PD_FECPRO IN DATE, ln_intcom out number,
                          ln_intmor out number) is

ln_modT number;
ln_trnT number;

ln_emp number;
ln_mod number;
ln_suc number;
ln_trn number;
ln_rel number;
ln_fec date;

begin
       begin
          
     
          --transacciones
          
          begin
                 
              select a.tp1nro2,a.tp1nro3
                into ln_modT,ln_trnT
                from fst198 a
               where a.tp1cod = 1
                 and a.tp1cod1 = 10991
                 and a.tp1corr1 = 1
                 and a.tp1nro1  = pn_tipsol;
           exception
                 when others then null;   
                         
           end;
          
          
          begin
          select b.pgcod,
                 b.hcmod,
                 b.hsucor,
                 b.htran,
                 b.hnrel,
                 b.hfcon
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_trn,
                 ln_rel,
                 ln_fec
            from /*bantprod.*/fsh016 b,/*bantprod.*/fsh015 c
           where b.pgcod = c.pgcod
             and b.hcmod = c.hcmod
             and b.hsucor = c.hsucor
             and b.htran = c.htran
             and b.hnrel = c.hnrel
             and b.hfcon = c.hfcon
             and c.hccorr <> 99
             and b.pgcod = pn_emp
             and b.hcmod = ln_modT
             and b.htran = ln_trnT
             and b.hfcon = pd_fval
             and b.hpap   = pn_pap
             and b.hcta   = pn_cta
             and b.hoper  = pn_oper
             and rownum = 1;
         exception
         
         when others then 
         
	 NULL; 
             --insert into JAQZ058_ERROR values (pn_cta,pn_oper);
             --commit;
             
          end;
          
          
          pq_cr_int_diferido.sp_Interes_DiferidoII(ln_emp,ln_mod,ln_suc,ln_trn,
          ln_rel,ln_fec,pn_cta,ln_intcom,ln_intmor);
          
          
      end;                                                               
          
end sp_Interes_Diferido;

Procedure sp_Interes_Diferido_LineasII(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                          pn_rel in number, pn_fec in date,pn_cta in number,
                           ln_ord55 out number) is
                        
cursor interes is

--02.05.2018
select /*+index(b FSH01600)*/  b.hcta,
--select b.hcta,
       b.hoper,
       b.hcord,
       b.hcimp1
  from /*bantprod.*/fsh016 b
 where b.pgcod = pn_emp
   and b.hcmod = pn_mod
   and b.hsucor = pn_suc
   and b.htran = pn_trn
   and b.hnrel = pn_rel
   and b.hfcon = pn_fec
   and b.hcta   = pn_cta;
   
begin
   ln_ord55 := 0;
   
   for i in interes loop
   
       if i.hcord = 13 then
          ln_ord55 := ln_ord55 + nvl(i.hcimp1,0);--mod@abr 20180705 se agrega nvl

       end if;
   end loop;

end sp_Interes_Diferido_LineasII;

Procedure sp_Interes_Diferido_Lineas(pn_emp in number,pn_pap in number,pn_cta in number,
                                     pn_oper in number,pd_fval in date, ln_intcom out number) is

ln_emp number;
ln_mod number;
ln_suc number;
ln_trn number;
ln_rel number;
ln_fec date;

begin
       begin
                    
          
          --interes compensatorio
         
          begin
              select b.pgcod,
                     b.hcmod,
                     b.hsucor,
                     b.htran,
                     b.hnrel,
                     b.hfcon
                into ln_emp,
                     ln_mod,
                     ln_suc,
                     ln_trn,
                     ln_rel,
                     ln_fec
                from /*bantprod.*/fsh016 b,/*bantprod.*/fsh015 c
               where b.pgcod = c.pgcod
                 and b.hcmod = c.hcmod
                 and b.hsucor = c.hsucor
                 and b.htran = c.htran
                 and b.hnrel = c.hnrel
                 and b.hfcon = c.hfcon
                 and c.hccorr <> 99
                 and b.pgcod = pn_emp
                 and b.hcmod = 116
                 and b.htran = 60
                 and b.hfcon = pd_fval
                 and b.hpap   = pn_pap
                 and b.hcta   = pn_cta
                 and b.hoper  = pn_oper
                 and rownum = 1;
         exception
         
         when others then 
             NULL; 
             --insert into JAQZ058_ERROR values (pn_cta,pn_oper);
             --commit;
             
          end;
          
          pq_cr_int_diferido.sp_Interes_Diferido_LineasII(ln_emp,ln_mod,ln_suc,ln_trn,
          ln_rel,ln_fec,pn_cta,ln_intcom);

      end;
          
end sp_Interes_Diferido_Lineas;



function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_numcuotas number;
begin
  begin
    select --/*+ parallel(o,2,1)*/  
            sum(count(*))
       into ln_numcuotas     
       from fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc 
        and o.ppmda   = pn_mda 
        and o.pppap   = pn_pap 
        and o.ppcta   = pn_cta 
        and o.ppoper  = pn_oper 
        and o.ppsbop  = pn_sbop 
        and o.pptope  = pn_top 
        and o.pp1fech  <= pd_fecpro
        and o.pp1stat = 'T' 
        and o.d602co  = 'S'
        and (o.pp1cap+o.pp1int)<>0
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception 
      when no_data_found then 
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;   
   return ln_numcuotas;
end fn_cuotas_pagadas;

Procedure SP_Actualizaciones(pd_fecpro in date) is

cursor creditos is
 select * from jaqz058;
 
cursor plan
 (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number)
 
 is 
       select *  
         from /*bantprod.*/fsd602 o
        where o.pgcod   = pn_emp
          and o.ppmod   = pn_mod
          and o.ppsuc   = pn_suc 
          and o.ppmda   = pn_mda 
          and o.pppap   = pn_pap 
          and o.ppcta   = pn_cta 
          and o.ppoper  = pn_oper 
          and o.ppsbop  = pn_sbop 
          and o.pptope  = pn_top 
          and o.pp1fech <= pd_fecpro
          and o.d602co  = 'S'
          and o.pp1cap > 0;
   

ln_intdif number;
ln_interes number :=0;
ln_numcuotas number;
ln_rubro number(16);
ln_grupo number(2);
ld_fecven date;
ln_PDI number(17,2); --mod@abr 20180705 se grega excepcion
begin

      --calcula total de cuotas
      begin

        for i in creditos loop

          ln_numcuotas := 0;  

            begin
              select --/*+ parallel(o,2,1)*/  
                  count(*)
                 into ln_numcuotas     
                 from /*bantprod.*/fsd601 o
                where o.pgcod   = i.JAQZ058EMP
                  and o.ppmod   = i.JAQZ058MOD
                  and o.ppsuc   = i.JAQZ058SUC 
                  and o.ppmda   = i.JAQZ058MDA 
                  and o.pppap   = i.JAQZ058PAP 
                  and o.ppcta   = i.JAQZ058CTA 
                  and o.ppoper  = i.JAQZ058OPE 
                  and o.ppsbop  = i.JAQZ058SBO 
                  and o.pptope  = i.JAQZ058TOP 
                  and o.d601co  = 'S';
            exception 
                when no_data_found then 
                   ln_numcuotas := 0;
                when others then null; --mod@abr 20180705 se agrega excepcion
            end;   


            update jaqz058 j
               set JAQZ058TCU = ln_numcuotas
              where JAQZ058EMP =  i.JAQZ058EMP
                and JAQZ058MOD =  i.JAQZ058MOD
                and JAQZ058SUC =  i.JAQZ058SUC
                and JAQZ058MDA =  i.JAQZ058MDA
                and JAQZ058PAP =  i.JAQZ058PAP
                and JAQZ058CTA =  i.JAQZ058CTA
                and JAQZ058OPE =  i.JAQZ058OPE
                and JAQZ058SBO =  i.JAQZ058SBO
                and JAQZ058TOP =  i.JAQZ058TOP;

                commit;
        end loop;    
        
        
      end;

      --calcula porcion de interes
      
      begin

          for i in creditos loop
              --mod@abr 20180705 se agrega excepcion
              if nvl(i.jaqz058tcu,0) = 0 then
                 ln_PDI := 0;
                 else
                     ln_PDI := round((nvl(i.jaqz058inc,0) + nvl(i.jaqz058inm,0)) /i.jaqz058tcu,2);
              end if;
              --mod@abr 20180705 se agrega excepcion
              update jaqz058 
                 set JAQZ058PDI = ln_PDI --mod@abr 20180705 se agrega excepcion
                where JAQZ058EMP =  i.JAQZ058EMP
                  and JAQZ058MOD =  i.JAQZ058MOD
                  and JAQZ058SUC =  i.JAQZ058SUC
                  and JAQZ058MDA =  i.JAQZ058MDA
                  and JAQZ058PAP =  i.JAQZ058PAP
                  and JAQZ058CTA =  i.JAQZ058CTA
                  and JAQZ058OPE =  i.JAQZ058OPE
                  and JAQZ058SBO =  i.JAQZ058SBO
                  and JAQZ058TOP =  i.JAQZ058TOP;
                  commit;
          end loop;
          

        end;
     
        --calcula interes diferido
        
       begin
 
 
           for i in creditos loop 
           
             ln_intdif := 0;
             
              for y in plan
                (i.jaqz058emp,i.jaqz058mod,i.jaqz058suc,i.jaqz058mda,i.jaqz058pap,i.jaqz058cta,i.jaqz058ope,
                 i.jaqz058sbo,i.jaqz058top)  loop
                 
                 if y.pp1cap > i.jaqz058pdi then
                    ln_intdif := ln_intdif + nvl(i.jaqz058pdi,0) ;--mod@abr 20180705 se agrega nvl para excepcion
                 else
                    ln_intdif := ln_intdif + ( nvl(i.jaqz058pdi,0) - nvl(y.pp1cap,0) );--mod@abr 20180705 se agrega nvl para excepcion
                 end if;
                 
           
              end loop;
              
              if (nvl(i.jaqz058inc,0) + nvl(i.jaqz058inm,0) - ln_intdif )<0 then
                 ln_interes := 0;
              else
                 ln_interes := nvl(i.jaqz058inc,0) + nvl(i.jaqz058inm,0) - ln_intdif;
              end if;

              update jaqz058 
                 set JAQZ058IPA = ln_intdif,
                     JAQZ058IDI = ln_interes
                where JAQZ058EMP =  i.JAQZ058EMP
                  and JAQZ058MOD =  i.JAQZ058MOD
                  and JAQZ058SUC =  i.JAQZ058SUC
                  and JAQZ058MDA =  i.JAQZ058MDA
                  and JAQZ058PAP =  i.JAQZ058PAP
                  and JAQZ058CTA =  i.JAQZ058CTA
                  and JAQZ058OPE =  i.JAQZ058OPE
                  and JAQZ058SBO =  i.JAQZ058SBO
                  and JAQZ058TOP =  i.JAQZ058TOP;

              commit;
              
           end loop;
           
          
         end;
         
         --rubro y grupo fsd011
         
         begin

              for i in creditos loop

                ln_rubro := 0;  
                ln_grupo :=0;
                  begin
                    select --/*+ parallel(o,2,1)*/  
                           o.scrub,o.scgru
                       into ln_rubro,ln_grupo
                       from /*bantprod.*/fsd011 o
                      where o.pgcod   = i.JAQZ058EMP
                        and o.scmod   = i.JAQZ058MOD
                        and o.scsuc   = i.JAQZ058SUC 
                        and o.scmda   = i.JAQZ058MDA 
                        and o.scpap   = i.JAQZ058PAP 
                        and o.sccta   = i.JAQZ058CTA 
                        and o.scoper  = i.JAQZ058OPE 
                        and o.scsbop  = i.JAQZ058SBO 
                        and o.sctope  = i.JAQZ058TOP;
                  exception 
                      when no_data_found then 
                         ln_rubro := 0;
                         ln_grupo := 0;
                      when others then null; --mod@abr 20180704
                  end;   


                  update jaqz058 j
                     set JAQZ058RUB = ln_rubro,
                         JAQZ058GRU = ln_grupo
                    where JAQZ058EMP =  i.JAQZ058EMP
                      and JAQZ058MOD =  i.JAQZ058MOD
                      and JAQZ058SUC =  i.JAQZ058SUC
                      and JAQZ058MDA =  i.JAQZ058MDA
                      and JAQZ058PAP =  i.JAQZ058PAP
                      and JAQZ058CTA =  i.JAQZ058CTA
                      and JAQZ058OPE =  i.JAQZ058OPE
                      and JAQZ058SBO =  i.JAQZ058SBO
                      and JAQZ058TOP =  i.JAQZ058TOP;

                      commit;
              end loop;    
              
              
            end;
            
            --fecha de vencimiento
            
            begin

                  for i in creditos loop

                    ld_fecven := null;  

                      begin
                        select --/*+ parallel(o,2,1)*/  
                               o.aofvto
                           into ld_fecven     
                           from /*bantprod.*/fsd010 o
                          where o.pgcod   = i.JAQZ058EMP
                            and o.aomod   = i.JAQZ058MOD
                            and o.aosuc   = i.JAQZ058SUC 
                            and o.aomda   = i.JAQZ058MDA 
                            and o.aopap   = i.JAQZ058PAP 
                            and o.aocta   = i.JAQZ058CTA 
                            and o.aooper  = i.JAQZ058OPE 
                            and o.aosbop  = i.JAQZ058SBO 
                            and o.aotope  = i.JAQZ058TOP;
                      exception 
                          when no_data_found then 
                             ld_fecven := null;
                          when too_many_rows then ld_fecven := null;
                          when others then null; --mod@abr 20180705 se agreo excepcion
                      end;   


                      update jaqz058 j
                         set JAQZ058FDV = ld_fecven
                        where JAQZ058EMP =  i.JAQZ058EMP
                          and JAQZ058MOD =  i.JAQZ058MOD
                          and JAQZ058SUC =  i.JAQZ058SUC
                          and JAQZ058MDA =  i.JAQZ058MDA
                          and JAQZ058PAP =  i.JAQZ058PAP
                          and JAQZ058CTA =  i.JAQZ058CTA
                          and JAQZ058OPE =  i.JAQZ058OPE
                          and JAQZ058SBO =  i.JAQZ058SBO
                          and JAQZ058TOP =  i.JAQZ058TOP;

                      commit;
                  end loop;    
                  
                  
                end;
            pq_cr_int_diferido.SP_ActualizacionesRubro(pd_fecpro);
            pq_cr_int_diferido.SP_ActualizacionesGrupo(pd_fecpro);
end;

Procedure SP_ActualizacionesRubro(pd_fecpro in date) is
cursor creditos is
        select * from jaqz058 a where a.jaqz058sol <> 3 and jaqz058rub = 0;
ln_rubro number(16);

begin

        --rubro fsh012
            
            begin

                  for i in creditos loop

                    ln_rubro := 0;  

                      begin
                        select --/*+ parallel(o,2,1)*/  
                               o.bcrubr
                           into ln_rubro     
                           from /*bantprod.*/fsh012 o
                          where o.bcemp   = i.JAQZ058EMP
                            and o.bcmod   = i.JAQZ058MOD
                            and o.bcsuc   = i.JAQZ058SUC 
                            and o.bcmda   = i.JAQZ058MDA 
                            and o.bcpap   = i.JAQZ058PAP 
                            and o.bccta   = i.JAQZ058CTA 
                            and o.bcoper  = i.JAQZ058OPE 
                            and o.bcsbop  = i.JAQZ058SBO 
                            and o.bctop   = i.JAQZ058TOP
                            and o.bcfech  = pd_fecpro
                            and rownum    = 1;
                      exception 
                          when no_data_found then 
                             ln_rubro := 0;
                          when too_many_rows then ln_rubro := 0;
                          when others then ln_rubro := 0; --mod@abr 20180705 se agreo excepcion
                      end;   


                      update jaqz058 j
                         set JAQZ058RUB = ln_rubro
                        where JAQZ058EMP =  i.JAQZ058EMP
                          and JAQZ058MOD =  i.JAQZ058MOD
                          and JAQZ058SUC =  i.JAQZ058SUC
                          and JAQZ058MDA =  i.JAQZ058MDA
                          and JAQZ058PAP =  i.JAQZ058PAP
                          and JAQZ058CTA =  i.JAQZ058CTA
                          and JAQZ058OPE =  i.JAQZ058OPE
                          and JAQZ058SBO =  i.JAQZ058SBO
                          and JAQZ058TOP =  i.JAQZ058TOP;
                          commit;

                  end loop;    
                    
                    
                end;


end SP_ActualizacionesRubro;

Procedure SP_ActualizacionesGrupo(pd_fecpro in date) is

 cursor creditos is
        select * from jaqz058 a where a.jaqz058sol <> 3
         and a.jaqz058gru = 0;
 ln_grupo number(2);
begin

     begin

        for i in creditos loop

          ln_grupo := 0;  

            begin
              select --/*+ parallel(o,2,1)*/  
                     o.BCGPO
                 into ln_grupo     
                 from /*bantprod.*/fsh012 o
                where o.bcemp   = i.JAQZ058EMP
                  and o.bcmod   = i.JAQZ058MOD
                  and o.bcsuc   = i.JAQZ058SUC 
                  and o.bcmda   = i.JAQZ058MDA 
                  and o.bcpap   = i.JAQZ058PAP 
                  and o.bccta   = i.JAQZ058CTA 
                  and o.bcoper  = i.JAQZ058OPE 
                  and o.bcsbop  = i.JAQZ058SBO 
                  and o.bctop   = i.JAQZ058TOP
                  and o.bcfech  = pd_fecpro;
            exception 
                when no_data_found then 
                   ln_grupo := 0;
                when too_many_rows then null;
                when others then null; --mod@abr 20180705 se agrego excepcion
            end;   


            update jaqz058 j
               set JAQZ058GRU = ln_grupo
              where JAQZ058EMP =  i.JAQZ058EMP
                and JAQZ058MOD =  i.JAQZ058MOD
                and JAQZ058SUC =  i.JAQZ058SUC
                and JAQZ058MDA =  i.JAQZ058MDA
                and JAQZ058PAP =  i.JAQZ058PAP
                and JAQZ058CTA =  i.JAQZ058CTA
                and JAQZ058OPE =  i.JAQZ058OPE
                and JAQZ058SBO =  i.JAQZ058SBO
                and JAQZ058TOP =  i.JAQZ058TOP;
                commit;

        end loop;    
        
        
      end;

end SP_ActualizacionesGrupo;

Procedure SP_ActualizacionesLineas(pd_fecpro in date) is
cursor creditos is 
       select * from jaqz060;


 ld_fec date;
begin
    
    --Fecha de transaccion     
    begin
 
 
         for i in creditos loop 
           
           ld_fec := null;
             
           begin
             
               select max(a.d602fc)
                 into ld_fec
                 from /*bantprod.*/fsd602 a
                where a.pgcod  = i.jaqz060emp
                  and a.ppmod  = i.jaqz060mod
                  and a.ppsuc  = i.jaqz060suc
                  and a.ppmda  = i.jaqz060mda
                  and a.pppap  = i.jaqz060pap
                  and a.ppcta  = i.jaqz060cta
                  and a.ppoper = i.jaqz060ope
                  and a.ppsbop = i.jaqz060sbo
                  and a.pptope = i.jaqz060top
                  and a.d602mo = 116
                  and a.d602tr = 60
                  and a.d602co = 'S'
                  and a.d602fc <= pd_fecpro;
           exception
           when others then null; --mod@abr 20180705 se agrego excepcion  
           end; 
             

            update jaqz060 
               set JAQZ060FDT = ld_fec
              where jaqz060EMP =  i.JAQZ060EMP
                and JAQZ060MOD =  i.JAQZ060MOD
                and JAQZ060SUC =  i.JAQZ060SUC
                and JAQZ060MDA =  i.JAQZ060MDA
                and JAQZ060PAP =  i.JAQZ060PAP
                and JAQZ060CTA =  i.JAQZ060CTA
                and JAQZ060OPE =  i.JAQZ060OPE
                and JAQZ060SBO =  i.JAQZ060SBO
                and JAQZ060TOP =  i.JAQZ060TOP;

            commit;
              
         end loop;
           
          
       end;

       pq_cr_int_diferido.Sp_ActualizaInteresCompe;
       pq_cr_int_diferido.Sp_ActualizatotcuoLineas(pd_fecpro);
end SP_ActualizacionesLineas;

Procedure Sp_ActualizaInteresCompe is

cursor creditos is
        select * from jaqz060 a where a.jaqz060fdt is not null;

ln_intcom number(17,2);
begin
       --calcula el interes compensatorio nuevamente con la nueva fecha de transaccion
       begin
  
            for i in creditos loop

              ln_intcom := 0;
              
              
              pq_cr_int_diferido.sp_Interes_Diferido_Lineas(i.jaqz060emp,
                                                        i.jaqz060pap,
                                                        i.jaqz060cta,
                                                        i.jaqz060ope,
                                                        i.jaqz060fdt,
                                                        ln_intcom);
              --dbms_output.put_line(i.jaqz058emp ||'-'||i.jaqz058cta||'-'||i.jaqz058ope||'-'||
                      --             i.jaqz058fed||'-'||i.jaqz058sol||'-'||ln_intcom||'-'||ln_intmor);
               
                update jaqz060 j
                   set j.jaqz060inc = ln_intcom
                  where JAQZ060EMP =  i.JAQZ060EMP
                    and JAQZ060MOD =  i.JAQZ060MOD
                    and JAQZ060SUC =  i.JAQZ060SUC
                    and JAQZ060MDA =  i.JAQZ060MDA
                    and JAQZ060PAP =  i.JAQZ060PAP
                    and JAQZ060CTA =  i.JAQZ060CTA
                    and JAQZ060OPE =  i.JAQZ060OPE
                    and JAQZ060SBO =  i.JAQZ060SBO
                    and JAQZ060TOP =  i.JAQZ060TOP;
                    commit;
                    
            end loop;    
            
            
          end;


end Sp_ActualizaInteresCompe;

Procedure Sp_ActualizatotcuoLineas (pd_fecpro in date)is
cursor creditos is
        select * from jaqz060 where jaqz060fdt is not null;

cursor plan
 (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number,pd_fec in date)
 
 is 
       select *  
         from /*bantprod.*/fsd602 o
        where o.pgcod   = pn_emp
          and o.ppmod   = pn_mod
          and o.ppsuc   = pn_suc 
          and o.ppmda   = pn_mda 
          and o.pppap   = pn_pap 
          and o.ppcta   = pn_cta 
          and o.ppoper  = pn_oper 
          and o.ppsbop  = pn_sbop 
          and o.pptope  = pn_top 
          and o.pp1fech <= pd_fecpro
          and o.d602co  = 'S'
          and o.pp1cap > 0
          and o.ppfpag  >= pd_fec;
   

 ln_intdif number;
 ln_interes number :=0;
ln_numcuotas number;
ln_numcuota number;
ln_rubro number(16);
ln_grupo number(2);
ld_fecven date;
begin
         --total de cuotas
         begin

              for i in creditos loop

                ln_numcuotas := 0;  

                  begin
                    select --/*+ parallel(o,2,1)*/  
                        count(*)
                       into ln_numcuotas     
                       from /*bantprod.*/fsd601 o
                      where o.pgcod   = i.JAQZ060EMP
                        and o.ppmod   = i.JAQZ060MOD
                        and o.ppsuc   = i.JAQZ060SUC 
                        and o.ppmda   = i.JAQZ060MDA 
                        and o.pppap   = i.JAQZ060PAP 
                        and o.ppcta   = i.JAQZ060CTA 
                        and o.ppoper  = i.JAQZ060OPE 
                        and o.ppsbop  = i.JAQZ060SBO 
                        and o.pptope  = i.JAQZ060TOP 
                        and o.d601co  = 'S'
                        and o.ppfpag  >= i.jaqz060fdt;
                  exception 
                      when no_data_found then 
                         ln_numcuotas := 0;
                      when others then ln_numcuotas := 0; --mod@abr 20180705 se agrego excepcion
                  end;   


                  update jaqz060 j
                     set JAQZ060TCU = ln_numcuotas
                    where JAQZ060EMP =  i.JAQZ060EMP
                      and JAQZ060MOD =  i.JAQZ060MOD
                      and JAQZ060SUC =  i.JAQZ060SUC
                      and JAQZ060MDA =  i.JAQZ060MDA
                      and JAQZ060PAP =  i.JAQZ060PAP
                      and JAQZ060CTA =  i.JAQZ060CTA
                      and JAQZ060OPE =  i.JAQZ060OPE
                      and JAQZ060SBO =  i.JAQZ060SBO
                      and JAQZ060TOP =  i.JAQZ060TOP;
                      commit;

              end loop;    
              
              
            end;
            --numero de cuotas pagadas 
            begin

                    for i in creditos loop

                      ln_numcuota := 0;  

                        begin
                          select --/*+ parallel(o,2,1)*/  
                              sum(count(*))
                         into ln_numcuota     
                         from /*bantprod.*/fsd602 o
                        where o.pgcod   = i.JAQZ060EMP
                          and o.ppmod   = i.JAQZ060MOD
                          and o.ppsuc   = i.JAQZ060SUC
                          and o.ppmda   = i.JAQZ060MDA
                          and o.pppap   = i.JAQZ060PAP
                          and o.ppcta   = i.JAQZ060CTA
                          and o.ppoper  = i.JAQZ060OPE
                          and o.ppsbop  = i.JAQZ060SBO
                          and o.pptope  = i.JAQZ060TOP
                          and o.pp1fech  <= pd_fecpro
                          and o.ppfpag >= i.jaqz060fdt
                          and o.pp1stat = 'T' 
                          and o.d602co  = 'S'
                          and (o.pp1cap+o.pp1int)<>0
                          group by o.PGCOD,
                             o.PPMOD,
                             o.PPSUC,
                             o.PPMDA,
                             o.PPPAP,
                             o.PPCTA,
                             o.PPOPER,
                             o.PPSBOP,
                             o.PPTOPE,
                             o.PPFPAG;
                        exception 
                            when no_data_found then 
                               ln_numcuota := 0;
                            when others then ln_numcuota := 0; --mod@abr 20180705 se agrego excepcion
                        end;   


                        update jaqz060 j
                           set j.jaqz060cuo = ln_numcuota
                          where JAQZ060EMP =  i.JAQZ060EMP
                            and JAQZ060MOD =  i.JAQZ060MOD
                            and JAQZ060SUC =  i.JAQZ060SUC
                            and JAQZ060MDA =  i.JAQZ060MDA
                            and JAQZ060PAP =  i.JAQZ060PAP
                            and JAQZ060CTA =  i.JAQZ060CTA
                            and JAQZ060OPE =  i.JAQZ060OPE
                            and JAQZ060SBO =  i.JAQZ060SBO
                            and JAQZ060TOP =  i.JAQZ060TOP;
                            commit;

                    end loop;    
                    
                    
                  end;
                  
                  
                  --porcion de interes
                  
                  begin

                      for i in creditos loop
                            
                          update jaqz060 
                             set jaqz060PDI = round((nvl(i.jaqz060inc,0) + nvl(i.jaqz060inm,0)) /i.jaqz060tcu,2)
                            where jaqz060EMP =  i.jaqz060EMP
                              and jaqz060MOD =  i.jaqz060MOD
                              and jaqz060SUC =  i.jaqz060SUC
                              and jaqz060MDA =  i.jaqz060MDA
                              and jaqz060PAP =  i.jaqz060PAP
                              and jaqz060CTA =  i.jaqz060CTA
                              and jaqz060OPE =  i.jaqz060OPE
                              and jaqz060SBO =  i.jaqz060SBO
                              and jaqz060TOP =  i.jaqz060TOP;
                              commit;
                      end loop;
                            

                    end;
                    
                    --ineters diferido
                    
                    begin
 
 
                         for i in creditos loop 
                               
                           ln_intdif := 0;
                                 
                            for y in plan
                              (i.jaqz060emp,i.jaqz060mod,i.jaqz060suc,i.jaqz060mda,i.jaqz060pap,i.jaqz060cta,i.jaqz060ope,
                               i.jaqz060sbo,i.jaqz060top,i.JAQZ060FDT)  loop
                                     
                               if nvl(y.pp1cap,0) > nvl(i.jaqz060pdi,0) then  --mod@abr 20180705 se greago nvl por excepcion
                                  ln_intdif := ln_intdif + nvl(i.jaqz060pdi,0) ;--mod@abr 20180705 se greago nvl por excepcion
                               else
                                  ln_intdif := ln_intdif + ( nvl(i.jaqz060pdi,0) - nvl(y.pp1cap,0) );--mod@abr 20180705 se greago nvl por excepcion
                               end if;
                                     
                               
                            end loop;
                                  
                            if (nvl(i.jaqz060inc,0) + nvl(i.jaqz060inm,0) - ln_intdif )<0 then
                               ln_interes := 0;
                            else
                               ln_interes := nvl(i.jaqz060inc,0) + nvl(i.jaqz060inm,0) - ln_intdif;
                            end if;

                            update jaqz060 
                               set jaqz060IPA = ln_intdif,
                                   jaqz060IDI = ln_interes
                              where jaqz060EMP =  i.jaqz060EMP
                                and jaqz060MOD =  i.jaqz060MOD
                                and jaqz060SUC =  i.jaqz060SUC
                                and jaqz060MDA =  i.jaqz060MDA
                                and jaqz060PAP =  i.jaqz060PAP
                                and jaqz060CTA =  i.jaqz060CTA
                                and jaqz060OPE =  i.jaqz060OPE
                                and jaqz060SBO =  i.jaqz060SBO
                                and jaqz060TOP =  i.jaqz060TOP;

                            commit;
                                  
                         end loop;
                               
                              
                       end;
                       
                       
                       ---rubro,grupo fsd011
                       
                       begin

                          for i in creditos loop

                            ln_rubro := 0;  
                            ln_grupo := 0;
                            
                              begin
                                select --/*+ parallel(o,2,1)*/  
                                       o.scrub,o.scgru
                                   into ln_rubro,ln_grupo 
                                   from /*bantprod.*/fsd011 o
                                  where o.pgcod   = i.JAQZ060EMP
                                    and o.scmod   = i.JAQZ060MOD
                                    and o.scsuc   = i.JAQZ060SUC 
                                    and o.scmda   = i.JAQZ060MDA 
                                    and o.scpap   = i.JAQZ060PAP 
                                    and o.sccta   = i.JAQZ060CTA 
                                    and o.scoper  = i.JAQZ060OPE 
                                    and o.scsbop  = i.JAQZ060SBO 
                                    and o.sctope  = i.JAQZ060TOP;
                              exception 
                                  when no_data_found then 
                                     ln_rubro := 0;
                                     ln_grupo := 0;
                                  when others then --mod@abr 20180705 se agrego excepcion
                                       ln_rubro := 0;
                                       ln_grupo := 0;
                              end;   


                              update jaqz060 j
                                 set JAQZ060RUB = ln_rubro,
                                     JAQZ060GRU = ln_grupo
                                where JAQZ060EMP =  i.JAQZ060EMP
                                  and JAQZ060MOD =  i.JAQZ060MOD
                                  and JAQZ060SUC =  i.JAQZ060SUC
                                  and JAQZ060MDA =  i.JAQZ060MDA
                                  and JAQZ060PAP =  i.JAQZ060PAP
                                  and JAQZ060CTA =  i.JAQZ060CTA
                                  and JAQZ060OPE =  i.JAQZ060OPE
                                  and JAQZ060SBO =  i.JAQZ060SBO
                                  and JAQZ060TOP =  i.JAQZ060TOP;

                                  commit;
                          end loop;    
                          
                          
                        end;
                        
                        --fecha de vencimiento
                        
                        begin

                              for i in creditos loop

                                ld_fecven := null;  
                                
                                  begin
                                    select --/*+ parallel(o,2,1)*/  
                                           o.aofvto
                                       into ld_fecven     
                                       from /*bantprod.*/fsd010 o
                                      where o.pgcod   = i.JAQZ060EMP
                                        and o.aomod   = i.JAQZ060MOD
                                        and o.aosuc   = i.JAQZ060SUC 
                                        and o.aomda   = i.JAQZ060MDA 
                                        and o.aopap   = i.JAQZ060PAP 
                                        and o.aocta   = i.JAQZ060CTA 
                                        and o.aooper  = i.JAQZ060OPE 
                                        and o.aosbop  = i.JAQZ060SBO 
                                        and o.aotope  = i.JAQZ060TOP;
                                  exception 
                                      when no_data_found then 
                                         ld_fecven := null;
                                      when too_many_rows then ld_fecven := null;
                                      when others then null;--mod@abr 20180705 se agrego excepcion
                                  end;   


                                  update jaqz060 j
                                     set JAQZ060FDV = ld_fecven
                                    where JAQZ060EMP =  i.JAQZ060EMP
                                      and JAQZ060MOD =  i.JAQZ060MOD
                                      and JAQZ060SUC =  i.JAQZ060SUC
                                      and JAQZ060MDA =  i.JAQZ060MDA
                                      and JAQZ060PAP =  i.JAQZ060PAP
                                      and JAQZ060CTA =  i.JAQZ060CTA
                                      and JAQZ060OPE =  i.JAQZ060OPE
                                      and JAQZ060SBO =  i.JAQZ060SBO
                                      and JAQZ060TOP =  i.JAQZ060TOP;


                              end loop;    
                              
                              
                            end;



                        pq_cr_int_diferido.Sp_ActualizacionRubroLineas(pd_fecpro);
                        pq_cr_int_diferido.Sp_ActualizacionGrupoLineas(pd_fecpro);


end;

Procedure Sp_ActualizacionRubroLineas(pd_fecpro in date)is
cursor creditos is
        select * from jaqz060 where jaqz060fdt is not null and jaqz060rub = 0;

ln_rubro number(16);
begin

         --rubro fsh012
         
         begin

              for i in creditos loop

                ln_rubro := 0;  
                
                  begin
                    select --/*+ parallel(o,2,1)*/  
                           o.bcrubr
                       into ln_rubro     
                       from /*bantprod.*/fsh012 o
                      where o.bcemp   = i.JAQZ060EMP
                        and o.bcmod   = i.JAQZ060MOD
                        and o.bcsuc   = i.JAQZ060SUC 
                        and o.bcmda   = i.JAQZ060MDA 
                        and o.bcpap   = i.JAQZ060PAP 
                        and o.bccta   = i.JAQZ060CTA 
                        and o.bcoper  = i.JAQZ060OPE 
                        and o.bcsbop  = i.JAQZ060SBO 
                        and o.bctop   = i.JAQZ060TOP
                        and o.bcfech  = pd_fecpro;
                  exception 
                      when no_data_found then 
                         ln_rubro := 0;
                      when too_many_rows then ln_rubro := 0;
                      when others then ln_rubro := 0; --mod@abr 20180705 se agrego excepcion
                  end;   


                  update jaqz060 j
                     set JAQZ060RUB = ln_rubro
                    where JAQZ060EMP =  i.JAQZ060EMP
                      and JAQZ060MOD =  i.JAQZ060MOD
                      and JAQZ060SUC =  i.JAQZ060SUC
                      and JAQZ060MDA =  i.JAQZ060MDA
                      and JAQZ060PAP =  i.JAQZ060PAP
                      and JAQZ060CTA =  i.JAQZ060CTA
                      and JAQZ060OPE =  i.JAQZ060OPE
                      and JAQZ060SBO =  i.JAQZ060SBO
                      and JAQZ060TOP =  i.JAQZ060TOP;

            commit;
              end loop;    
              
              
            end;



end Sp_ActualizacionRubroLineas;

Procedure Sp_ActualizacionGrupoLineas(pd_fecpro in date) is
cursor creditos is
        select * from jaqz060 where jaqz060fdt is not null and jaqz060gru =0
        ;

ln_grupo number(16);
begin

         --grupo fsh012
         begin

                for i in creditos loop

                  ln_grupo := 0;  
                  
                    begin
                      select --/*+ parallel(o,2,1)*/  
                             o.bcgpo
                         into ln_grupo     
                         from /*bantprod.*/fsh012 o
                        where o.bcemp   = i.JAQZ060EMP
                          and o.bcmod   = i.JAQZ060MOD
                          and o.bcsuc   = i.JAQZ060SUC 
                          and o.bcmda   = i.JAQZ060MDA 
                          and o.bcpap   = i.JAQZ060PAP 
                          and o.bccta   = i.JAQZ060CTA 
                          and o.bcoper  = i.JAQZ060OPE 
                          and o.bcsbop  = i.JAQZ060SBO 
                          and o.bctop   = i.JAQZ060TOP
                          and o.bcfech  = pd_fecpro;
                    exception 
                        when no_data_found then 
                           ln_grupo := 0;
                        when too_many_rows then null;
                        when others then null; --mod@abr 20180705 se agrego excepcion
                    end;   


                    update jaqz060 j
                       set JAQZ060GRU = ln_grupo
                      where JAQZ060EMP =  i.JAQZ060EMP
                        and JAQZ060MOD =  i.JAQZ060MOD
                        and JAQZ060SUC =  i.JAQZ060SUC
                        and JAQZ060MDA =  i.JAQZ060MDA
                        and JAQZ060PAP =  i.JAQZ060PAP
                        and JAQZ060CTA =  i.JAQZ060CTA
                        and JAQZ060OPE =  i.JAQZ060OPE
                        and JAQZ060SBO =  i.JAQZ060SBO
                        and JAQZ060TOP =  i.JAQZ060TOP;

                        commit;
                end loop;    
                
                
              end;

end Sp_ActualizacionGrupoLineas;

end PQ_CR_INT_DIFERIDO;
/

