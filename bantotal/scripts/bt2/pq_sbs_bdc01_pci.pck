CREATE OR REPLACE PACKAGE pq_sbs_bdc01_pci is
  -- *****************************************************************
  -- Nombre                       : pq_venta
  -- Sistema                      : SORFY
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 18/05/2007
  -- Autor de Creación            : yyampi
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_job_procesa_BDC01P (pd_fecpro in varchar2 );
  Procedure sp_procesa_BDC01P (pn_numsuc in number, pd_fecpro in varchar2 );
   

end pq_sbs_bdc01_pci;
/

CREATE OR REPLACE PACKAGE BODY pq_sbs_bdc01_pci is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure sp_job_procesa_BDC01P (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
     begin
         select host_name
           into lc_hostname
           from v$instance;
     end;

     --execute immediate ('truncate table migra2.BDC02');
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     delete  tab_jobs  where  c_Codage = 'BDC1P';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_sbs_bdc01_pci.sp_procesa_BDC01P('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
--        if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then    
IF SYS.FN_BD_ISRAC='TRUE' THEN
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
        else
            DBMS_JOB.SUBMIT(job => ln_job, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          force => false
                          );
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('BDC1P',ln_ini,lc_variable);
            COMMIT;
        end if;     
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'BDC1P',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
  Procedure sp_procesa_BDC01P (pn_numsuc in number, pd_fecpro in varchar2 ) is

  ld_fecpro date ;
  lc_coderr varchar2(300); 
  cursor prestamo is
  
--select /*+parallel(a,2)*/distinct b.bcemp,b.bcpap,b.bccta,b.bcsbop,a.cal, a.calint,--15.03.2015
select distinct b.bcemp,b.bcpap,b.bccta,b.bcsbop,a.cal, a.calint,--15.03.2015
       b.mon,b.bctop,b.bcmod,b.ccr,b.cage,
       a.ccl,a.ccr ccra
       from  BDC01  a,  JAQL120  b-- ,  fsh012 c
      where a.ccl = b.ccl
        and a.ccr = b.ccr
        AND B.CAGE = pn_numsuc
        --AND A.PCI <> 0
        --and a.kco = 0 
        and a.pci3 is null
--        and b.bcmod not in (117);
          AND B.BCMOD - UID * 0 <>117;
        


ln_pci    number;
ln_cal    varchar2(2);
ln_calint varchar2(2);
begin

  update  tab_jobs  g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'BDC1P';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  for i in prestamo loop
      ln_cal:= pq_datos_sbs.fn_cal(1,i.bccta,ld_fecpro,4);
      ln_calint := pq_datos_sbs.fn_cal(1,i.bccta,ld_fecpro,9);
     
     
     if i.bcmod not in (117) then
         if i.bcmod  = 141 then
            ln_pci  :=  pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'27_1%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'27_1%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'27_1%'/*i.bcrubr */);        
         else
             ln_pci  := pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 35,'14_9%'/*i.bcrubr */) +
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 335,'14_9%'/*i.bcrubr */)+
                        pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                                             i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 635,'14_9%'/*i.bcrubr */)                     ;  
         end if;                                
     else
         ln_pci  := 0 ; /*pq_datos_sbs.fn_Saldo_relacion3(i.bcemp, i.bcmod, i.cage, i.mon,i.bcpap, 
                    i.bccta, i.ccr, i.bcsbop,i.bctop,ld_fecpro, 735,'27_1%'\*i.bcrubr *\);  */ 
        
     end if;                                    
          
                                     
     
     begin 
       UPDATE  BDC01 
          SET PCI3   = ln_pci, 
              cal    = ln_cal,
              calint = ln_calint
        WHERE ccr = i.ccr
--          and trim(ccl) = trim(i.ccl);
          and ccl = trim(i.ccl);
       commit;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO  LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DATABCD1P',lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update  tab_jobs  g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'BDC1P';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update  tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'BDC1P';
    commit;
    return;

end sp_procesa_BDC01P;  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


end pq_sbs_bdc01_pci;

/*
   create public synonym pq_cr_adjudicar for pq_cr_adjudicar;
   grant execute on pq_cr_adjudicar to rol_sorfy,rol_sorfy_consulta;

*/
/

