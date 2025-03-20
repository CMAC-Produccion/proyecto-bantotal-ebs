create or replace package PQ_Ext_parches is

  -- Author  : MPOSTIGOC
  -- Created : 17/05/2016 11:39:25 a.m.
  -- Purpose : 
PROCEDURE sp_act_fsh012(pd_fecpro in VARCHAR2, pn_suc in number) ;
  Procedure sp_job_act_fsh012 (pc_fecpro in varchar2);
end PQ_Ext_parches;
/

create or replace package body PQ_Ext_parches is
  ---------------------------------------------------------------

  ---
  PROCEDURE sp_act_fsh012(pd_fecpro in VARCHAR2, pn_suc in number)  is
  
    cursor rubro is 
    select rubro
      from fsd014
     where pcimpu = 'S'
       --and rubro = 8129370402001
       /*and substr(rubro,1,1) <> 9*/ ; 
       
    cursor listado (ld_fecpro in date, ln_rubro in number) is
      select b.*
        from fsh012 b
       where b.bcsuc  = pn_suc 
         and b.bcfech = ld_fecpro --to_date('20200629','yyyymmdd')
         --and b.bcsdmo <> 0
         and b.bcrubr = ln_rubro;
         
    cursor lista31 (ld_fecpro in date, ln_rubro in number) is
     select b.*
        from fsh031 b
       where b.drsuc = pn_suc 
         and b.drfch = ld_fecpro --to_date('20200629','yyyymmdd')
         --and b.drsdor <> 0
         and b.drrub = ln_rubro;
          
                             
                        
    ln_tipcan number;
    ln_sdomn number;
    ln_sdomd number;
    ld_fecpro date;
    
  begin
     ld_fecpro := TO_DATE(PD_FECPRO,'YYYYMMDD');
     update  tab_jobs  g
         set g.d_fecini = sysdate
       where g.n_numer1 = nvl(trim(pn_suc),0)
         and g.c_codage = 'SALDOH';
      commit;
    
      begin 
       select cotcbi 
         into ln_tipcan
         from fsh005 
        where cofdes  = ld_fecpro
          and moneda = 101;
       exception
          when others then
            begin
              select cotcbi 
                into ln_tipcan
                from fsh005 
               where cofdes between ld_fecpro and last_day(ld_fecpro)
                 and moneda = 101
                 and rownum = 1
               order by  cofdes desc;
            exception
               when others then
                  ln_tipcan := 3.844;
            end;
       end; 
      
    for j in rubro loop 
      for i in listado (ld_fecpro,j.rubro ) loop
         ln_sdomn  := 0;
         ln_sdomd  := 0;
         if i.bcsdmo <> 0 then 
             if i.bcmda = 0 and i.bctit not in (4,5) then 
                ln_sdomn  := i.bcsdmo;
                ln_sdomd  := round(i.bcsdmo / ln_tipcan,2); 
             elsif i.bcmda = 101 and i.bctit not in (4,5)  then    
                ln_sdomn  := round(i.bcsdmo * ln_tipcan,2); 
                ln_sdomd  := i.bcsdmo; 
             elsif i.bcmda = 0 and i.bctit in (4,5)  then  -- clase 4 y    
                ln_sdomn  := i.bcsdmo;
                ln_sdomd  := round(i.bcsdmo / ln_tipcan,2); 
             elsif i.bcmda = 101 and i.bctit in (4,5)  then
                ln_sdomn  := round(i.bcsdmo * ln_tipcan,2);
                ln_sdomd  := i.bcsdmo;
             else 
               null;   
             end if; 
          else 
             ln_sdomn  := 0;
             ln_sdomd  := 0;
          end if;    
         if  ln_sdomn <> i.bcsdmn or  ln_sdomd <> i.BCSDUS then 
         update fsh012
            set bcsdmn = ln_sdomn,
                BCSDUS = ln_sdomd
          where bcemp = i.bcemp
            and bcmod = i.bcmod
            and bcsuc = i.bcsuc
            and bcmda = i.bcmda
            and bcrubr = i.bcrubr
            and bcpap = i.bcpap
            and bccta = i.bccta
            and bcoper = i.bcoper
            and bcsbop = i.bcsbop
            and bctop  = i.bctop
            and bcfech = ld_fecpro;
            commit;
        end if;    
          
    end loop;
     for k in lista31 (ld_fecpro,j.rubro ) loop
         ln_sdomn  := 0;
         ln_sdomd  := 0;
         if k.drsdor <> 0 then 
           if k.drmda = 0 and k.drtit not in (4,5) then 
              ln_sdomn  := k.drsdor;
              ln_sdomd  := round(k.drsdor / ln_tipcan,2); 
           elsif k.drmda = 101 and k.drtit not in (4,5)  then    
              ln_sdomn  := round(k.drsdor * ln_tipcan,2); 
              ln_sdomd  := k.drsdor; 
           elsif k.drmda = 0 and k.drtit in (4,5)  then  -- clase 4 y    
              ln_sdomn  := k.drsdor;
              ln_sdomd  := round(k.drsdor / ln_tipcan,2); 
           elsif k.drmda = 101 and k.drtit in (4,5)  then
              ln_sdomn  := round(k.drsdor * ln_tipcan,2);
              ln_sdomd  := k.drsdor;
           else 
             null;   
           end if;   
         else 
           ln_sdomn  := 0;
           ln_sdomd  := 0;
         end if;  
         if ln_sdomn <> k.drsdmn or ln_sdomd <> k.drSDUS then 
         update fsh031
            set drsdmn = ln_sdomn,
                drSDUS = ln_sdomd
          where DRFCH = ld_fecpro
            and PGCOD = k.PGCOD
            and DRSUC = k.DRSUC
            and DRRUB = k.DRRUB
            and DRMDA = k.DRMDA
            and DRPAP = k.DRPAP ;
            commit;
          end if;    
      
    end loop;
    end loop;
    update  tab_jobs  g
         set g.d_fecfin = sysdate
       where g.n_numer1 = nvl(trim(pn_suc),0)
         and g.c_codage = 'SALDOH';
      commit;
  
    ----
  end sp_act_fsh012;
  Procedure sp_job_act_fsh012 (pc_fecpro in varchar2)is
  ln_inc number;
  
  ln_ini varchar2(200);
  ln_fin varchar2(200);
  x      number;
  xx number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(500);
  ln_max number;
  ln_rango number;
        
   cursor sucursal is
  select sucurs from  fst001 where pgcod =1;
  ln_existe number;
  Begin
     execute immediate ('alter session set parallel_force_local=TRUE');--jflor 2014.01.16
     
     execute immediate ('alter session set "_optimizer_batch_table_access_by_rowid" =false');
     execute immediate ('ALTER SESSION SET "_optimizer_gather_stats_on_load" = FALSE');
     execute immediate ('ALTER session SET PARALLEL_DEGREE_POLICY = LIMITED');
     execute immediate ('ALTER session SET OPTIMIZER_ADAPTIVE_STATISTICS = TRUE');
     execute immediate ('ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE');

     delete  tab_jobs  where  c_Codage = 'SALDOH';
     commit;
     begin
       for j in sucursal loop
    
       lc_variable := ' begin '|| '  PQ_Ext_parches.sp_act_fsh012('||''''||pc_fecpro||''''||',' ||j.sucurs||');'|| ' End; ';
           ln_job := ln_job +1;
             DBMS_JOB.SUBMIT(job => ln_job, 
                          what => lc_variable,
                          next_date => sysdate+1/(24*180),
                          interval => null,
                          no_parse => false,
                          instance => 2,
                          force => false);
            INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
            VALUES('SALDOH',nvl(trim(j.sucurs),0),lc_variable);
            COMMIT;
       --end if;
       Commit;
         select count(*) 
              into xx
              from user_jobs;
            while xx = 20 loop
              select count(*) 
              into xx
              from user_jobs; 
            end loop;
    End loop;
  end loop;  
  end;

end PQ_Ext_parches;
/

