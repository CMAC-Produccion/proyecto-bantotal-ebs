create or replace package PQ_CR_BAJA_SOLICITUD is
 
    -- *****************************************************************
    -- Nombre                     : BAJAR SOLICITUDES SUPERIORES A UNA CANTIDAD DE DIAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.05.27
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : FILTRAR, ACTUALIZAR Y ELIMINAR SOLICITUDES PENDIENTES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   :  
    -- Descripción de Modificación: 
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_busca_solicitudes( pd_fecpro in date, pn_digito in number) ;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_cr_job_solicitud(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_BACKUP(pd_fecpro in date);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 end PQ_CR_BAJA_SOLICITUD;
/

create or replace package body PQ_CR_BAJA_SOLICITUD is
    -- *****************************************************************
    -- Nombre                     : PQ_CR_BAJA_SOLICITUD
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.05.27
    -- Autor de Creación          : DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_busca_solicitudes( pd_fecpro in date, pn_digito in number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_busca_solicitudes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2017.05.27
    -- Autor de Creación          : DCASTRO
    -- Uso                        : BUSCA SOLICITUDES 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************


cursor creditos (pd_Fecpro in date) is
select * from wfwrkitems a where a.wfiteminit >= '01/06/2013' --71858
and a.wftaskcod in (3,7,11,55) 
--and ( pd_fecpro/*trunc(sysdate)*/ - trunc(a.wfiteminit) ) 
and a.wfitemstsact=1
and to_number(substr(trim(to_char(a.wfitemid)),length(trim(to_char(a.wfinsprcid)))-1,2)) = pn_digito
;--and a.wfinsprcid in (2715676,2717112,2715602,2715563,2715640,2716817,2716406);

--pd_fecpro date := trunc(sysdate);
lc_flag char(1):= 'N';
ln_num number:=0;
ln_garan number:=0;
ln_dias number:=0;
ln_diasGar number := 0;


BEGIN



 
 ---
 for i in creditos(pd_fecpro) loop
 
 
     if i.wftaskcod in (3,7,11) then-- todos superan 30 dias por lo que debe actualizar
        ln_dias :=  pd_fecpro - trunc(i.wfiteminit) ;
        if ln_dias > 30 then ---POR DEFECTO
            lc_flag := 'S';
        else
            lc_flag := 'N';
        end if;
        
     else
        --los que son DESEMBOLSO 55
        
        --verificar numero de dias por TIPO De GARANTIA
        begin 
               
            select max(Tp1imp1)
               into ln_DiasGar
             from sng122 s , fst198 f 
             where  s.sng122inst = i.wfinsprcid
              and Tp1cod   = 1 
              and Tp1cod1  = 10881 
              and Tp1corr1 = 5 
              and Tp1corr2 = 1
              and Tp1nro1 = s.sng122tope;
       exception when no_data_found then
              ln_DiasGar :=30; --si no tiene garantias reales debe eliminarse porque ya supero los 30 dias.
        end;
        
        ln_DiasGar := nvl(ln_DiasGar,30);
       ----------------   
       
        ln_dias :=  pd_fecpro - trunc(i.wfiteminit) ;
        if ln_dias > ln_DiasGar then
           lc_flag := 'S';
        else   
           lc_flag := 'N';
        end if;
       
       /* --verificar si tiene garantia real o inscrita.
              begin 
                     
                    select count(*)
                       into ln_garan
                     from sng122 s , fst198 f 
                     where  s.sng122inst = i.wfinsprcid
                      and Tp1cod   = 1 
                      and Tp1cod1  = 10881 
                      and Tp1corr1 = 2 
                      and Tp1corr2 = 2;
               exception when no_data_found then
                      ln_garan :=0;
               end;
               
               if ln_garan > 0 then --tiene garantias reales verificar 60 dias
                  ln_dias :=  pd_fecpro - trunc(i.wfiteminit) ;
                  if ln_dias > 60 then
                     lc_flag := 'S';
                  else   
                     lc_flag := 'N';
                  end if;
               else  --si no tiene garantias reales debe eliminarse porque ya supero los 30 dias.
                  lc_flag := 'S';
               end if;*/
               
     end if;
     
     if lc_flag = 'S' then --actualiza
     
      
       
       --1--
       --select * from wfwrkitems a where a.wfinsprcid=2728684 and a.wfitemstsact=1; -- 
       begin
            select count(*) into ln_num from wfwrkitems a where a.wfinsprcid = i.wfinsprcid and a.wfitemstsact = 1;  
       exception when no_data_found then           
                 ln_num := 0;
       end;
       
       if ln_num > 0 then
           begin
              update wfwrkitems a
                set a.WFStsCod = 'B', a.WFItemStsAct = 0 , a.WFItemEnd = pd_fecpro 
              where a.wfinsprcid = i.wfinsprcid and a.wfitemstsact = 1;  
              commit;
           end;
           
           INSERT INTO JAQZ456 (jaqz456fpro, jaqz456itemid, jaqz456insprci, jaqz456init, jaqz456stsact, jaqz456p1, jaqz456dias, jaqz456diagar)
           VALUES(PD_FECPRO, i.wfitemid, i.wfinsprcid, i.wfiteminit,  i.wfitemstsact , 'S' , ln_dias, ln_DiasGar); 
           
           --dbms_output.put_line('1- '||i.wfinsprcid ||' - '||' itemid '|| i.wfitemid ||' num '|| ln_num ||' - '||lc_flag|| ' Tarea ' ||i.wftaskcod|| ' DiasGar '|| ln_DiasGar|| ' ln_dias '||ln_dias);
              
           --2--
           --select * from wfinstprc b where b.wfinsprcid=2728684;--
           
           begin
                select count(*) into ln_num from wfinstprc b where b.wfinsprcid=  i.wfinsprcid;  
           exception when no_data_found then           
                     ln_num := 0;
           end;
        
           if ln_num > 0 then
        
              begin 
                update wfinstprc b
                   set b.WFInsPrcSta = 'B', b.WFInsPrcOSta = 0, b.WFInsPrcEnd = pd_fecpro
                 where b.wfinsprcid = i.wfinsprcid;    
                 commit;         
              end;   
              
               UPDATE JAQZ456
                  SET jaqz456p2 = 'S'
                WHERE JAQZ456FPRO = PD_FECPRO
                  AND JAQZ456INSPRCI = i.wfinsprcid
                  AND JAQZ456ITEMID = i.wfitemid;
                  
              -- dbms_output.put_line('2- ' ||ln_num);
        
              --3--
               --select * from wfworklist c where c.wfwrklstitemid=8229633;--Eliminar
               begin
                    select count(*) into ln_num from wfworklist b where b.wfwrklstitemid =  i.wfitemid; 
               exception when no_data_found then           
                         ln_num := 0;
               end;
                     
               if ln_num > 0 then
                    begin 
                      delete from wfworklist c where c.wfwrklstitemid = i.wfitemid;
                      commit;        
                    end;   
                    
                     UPDATE JAQZ456
                        SET jaqz456p3 = 'S'
                      WHERE JAQZ456FPRO = PD_FECPRO
                        AND JAQZ456INSPRCI = i.wfinsprcid
                        AND JAQZ456ITEMID = i.wfitemid;
                     COMMIT;
                        
                   -- dbms_output.put_line('3- ' ||ln_num);
               end if;
        
           end if;

        end if;  
     
     end if;
     lc_flag := 'N';  
     ln_num  := 0;    
     ln_garan:= 0;
     ln_dias := 0; 
     ln_DiasGar :=0;   
     
 end loop;


END sp_cr_busca_solicitudes;
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_solicitud(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
lc_hostname varchar2(64);
  

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
 
 lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
     
 --ELIMINANDO LA FECHA EXISTENTE
 delete from  JAQZ456 where JAQZ456FPRO = pd_Fecpro;
 commit;
     
    ---carga diaria
    for i in 0..99 loop    
          ln_ini := i;
          lc_variable := 'begin '||'  pq_cr_baja_solicitud.sp_cr_busca_solicitudes( TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD''),'||ln_ini||' );'||' End;';
          ln_job := ln_job +1;
         
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then             
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 1,
                        --instance => 2, 01/01/2024
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          
    
 


end sp_cr_job_solicitud;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_BACKUP(pd_fecpro in date) is


begin
 
 --BK1
INSERT INTO JAQZ456A (jaqz456Afec, jaqz456Aid, jaqz456Ains, jaqz456Ausrcod, jaqz456Arolcod, jaqz456Ataskco, jaqz456Ainit, 
jaqz456Aend, jaqz456Atscod, jaqz456Astsact, jaqz456Awrn, jaqz456Adln, jaqz456Arntime, jaqz456Alntime, jaqz456Aprcurn, 
jaqz456Aprvsta, jaqz456Aprvtas, jaqz456Apty, jaqz456Aprcid)

select PD_FECPRO, wfitemid, wfinsprcid, wfitemusrcod, wfitemrolcod, wftaskcod, wfiteminit, wfitemend, wfstscod, wfitemstsact, 
wfitemwrn, wfitemdln, wfitemwrntime, wfitemdlntime, wfitemprcurn, wfitemprvsta, wfitemprvtask, wfitempty, wfprcid
from wfwrkitems a where a.wfiteminit >= '01/06/2013' --71858
and a.wftaskcod in (3,7,11,55)
and a.wfitemstsact=1;
COMMIT;

 --BK2
INSERT INTO jaqz456B (jaqz456bfec, jaqz456Bins, jaqz456Bprcid, jaqz456Bsubjec, jaqz456Blstdoc, jaqz456Bend, jaqz456Bpty, jaqz456Bown, 
jaqz456Bsta, jaqz456Binit, jaqz456Bosta, jaqz456Bsbp, jaqz456Bparurn, jaqz456Btskurn, jaqz456Bnes, jaqz456Burl, jaqz456Bwarn, jaqz456Bdeadli, 
jaqz456Brntime, jaqz456Blntime, jaqz456Bname, jaqz456Bverid)
select PD_FECPRO, wfinsprcid, wfprcid, wfinsprcsubject, wfinslstdoc, wfinsprcend, wfinsprcpty, wfinsprcown, 
wfinsprcsta, wfinsprcinit, wfinsprcosta, wfinsprcsbp, wfinsprcparurn, wfinsprctskurn, wfinsprcnes, wfinsprcurl, wfinsprcwarn, wfinsprcdeadline, 
wfinsprcwrntime, wfinsprcdlntime, wfprcname, wfprcverid
from wfinstprc b
where b.wfinsprcid in (select w.jaqz456Ains from JAQZ456A w WHERE W.JAQZ456AFEC = PD_FECPRO) ;
COMMIT;

 --BK3
INSERT INTO JAQZ456C (jaqz456cfec, jaqz456Citemid, jaqz456Cusrcod, jaqz456Crolcod)
select PD_FECPRO, wfwrklstitemid, wfwrklstusrcod, wfwrklstrolcod 
from wfworklist c where c.wfwrklstitemid in ( select i.JAQZ456AID from  JAQZ456A i  WHERE I.JAQZ456AFEC = PD_FECPRO) ;         
    
COMMIT; 


end sp_cr_BACKUP;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_BAJA_SOLICITUD;
/

