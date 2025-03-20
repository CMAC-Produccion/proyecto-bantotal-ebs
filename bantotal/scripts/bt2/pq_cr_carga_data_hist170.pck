create or replace package pq_cr_Carga_Data_Hist170 is

  -- Author  : RMOGROVEJO
  -- Created : 15/05/2018 01:11:39 p.m.
  -- Purpose : 

procedure sp_Insert_fsd170h(pd_fecAno in date,
                            pn_sucursal in number);

procedure sp_Insert_fse170h(pd_fecAno2 in date,
                            pn_sd170doid in number);

PROCEDURE sp_job_llenar(pd_fecAno in date);

                        
end pq_cr_Carga_Data_Hist170;
/

create or replace package body pq_cr_Carga_Data_Hist170 is

procedure sp_Insert_fsd170h(pd_fecAno   in date,
                            pn_sucursal in number) is 
                            
ln_sd170doid number := 0;   
ln_sd170trsuc number;        
                   
cursor fsd170 is

       select *
       from fsd170
       where SD170TRSUC=pn_sucursal;
       
begin
   begin
      for p in fsd170 loop
        ln_sd170trsuc  := p.sd170trsuc;
        ln_sd170doid   := p.sd170doid;                           
          begin
              insert into fsd170h
                (SD170HFECHA,
                 SD170HDOEMP,
                 SD170HDOID,
                 ST170HTDCOD,
                 SD170HTISER,
                 SD170HTINRO,
                 SD170HDOSER,
                 SD170HDONRO,
                 SD170HTRSUC,
                 SD170HTRMOD,
                 SD170HTRTRN,
                 SD170HTRREL,
                 SD170HTRFCH,
                 SD170HDOEST)
                values( 
                       pd_fecAno,             
                       p.SD170DOEMP,
                       p.SD170DOID,
                       p.ST170TDCOD,
                       p.SD170TISER,
                       p.SD170TINRO,
                       p.SD170DOSER,
                       p.SD170DONRO,
                       p.SD170TRSUC,
                       p.SD170TRMOD,
                       p.SD170TRTRN,
                       p.SD170TRREL,
                       p.SD170TRFCH,
                       p.SD170DOEST
                       );
       commit; 
     end;
     
       begin
         pq_cr_carga_data_hist170.sp_insert_fse170h(pd_fecAno,p.SD170DOID);
       end;      
        
  end loop;
end; 

end sp_Insert_fsd170h;
----------------------------------------------------------------------------------
procedure sp_Insert_fse170h(pd_fecAno2 in date,
                            pn_sd170doid in number) is 

begin
  insert into fse170h
        (SD170HFECHA,    
         SD170HDOEMP,
         SD170HDOID,  
         ST171HCPCOD, 
         SE170HVNRO,  
         SE170HVCHR,  
         SE170HVFCH,  
         SE170HVIMP,  
         SE170HVTAS)
      select    pd_fecAno2,    
                SD170DOEMP,
                SD170DOID,  
                ST171CPCOD, 
                SE170VNRO,  
                SE170VCHR,  
                SE170VFCH,  
                SE170VIMP,  
                SE170VTAS
          from fse170 where SD170DOID=pn_sd170doid;
          
       commit;

end sp_Insert_fse170h;
----------------------------------------------------------------------------------------------
PROCEDURE sp_job_llenar(pd_fecAno in date)is

pn_sucursal number:=1;

-- job que permite ejecutar varias instancias en simultaneo.
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     lc_hostname varchar2(64);

     
begin
       
     begin
          select host_name into lc_hostname from v$instance;
     end;
     
      
    while  pn_sucursal <= 130 loop
     
      lc_variable := ' begin ' ||
      'PQ_CR_CARGA_DATA_HIST170.sp_Insert_fsd170h(
      ''' ||pd_fecAno   || ''',
      ''' ||pn_sucursal   || '''
      );' || ' End; ';
                        
      ln_job := ln_job + 1;
        
--     DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
--          if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
IF SYS.FN_BD_ISRAC='TRUE' THEN
            DBMS_JOB.SUBMIT(ln_job,
                            what => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval => null,
                            no_parse => false,
                            instance => 2, --ln_inst,
                            --instance => 1,--Solo por hoy 01.07.2015 hmev
                            force => false);
          else
            DBMS_JOB.SUBMIT(ln_job,
                            what => lc_variable,
                            next_date => sysdate + 1 / (24 * 60),
                            interval => null,
                            no_parse => false,
                            force => false);
          end if;
        
          commit;

         pn_sucursal:=pn_sucursal+1;

        end loop;

End sp_job_llenar;

end pq_cr_Carga_Data_Hist170;
/

