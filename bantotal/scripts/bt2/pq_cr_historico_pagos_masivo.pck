create or replace package pq_cr_historico_pagos_masivo is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_masivo
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones masivas
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación 
  -- *****************************************************************
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB064(pn_fecha_ini in date,pn_fecha_fin in date);
  
  PROCEDURE sp_insertar_AQPB064_JAQZ698(pn_fecha in date,
                                       pn_corr in number, 
                                       pn_inst in number, 
                                       pn_fecha_prev in date,
                                       pn_revr in char,
                                       
                                       pn_pgcod in number,
                                       pn_aomod in number, 
                                       pn_aosuc in number, 
                                       pn_aomda in number, 
                                       pn_aopap in number, 
                                       pn_aocta in number, 
                                       pn_aooper in number, 
                                       pn_aosbop in number, 
                                       pn_aotope in number);  
  
  PROCEDURE sp_insertar_AQPB064_AQPB002( pn_fecha in date, 
                                        pn_corr in number, 
                                        pn_inst in number, 
                                        pn_fecha_prev in date,
    
                                      pn_pgcod in number,
                                      pn_aomod in number, 
                                      pn_aosuc in number, 
                                      pn_aomda in number, 
                                      pn_aopap in number, 
                                      pn_aocta in number, 
                                      pn_aooper in number, 
                                      pn_aosbop in number, 
                                      pn_aotope in number,
                                      pn_feca in date,
                                      pn_revr in char
                                     );  
                                     
  PROCEDURE sp_insertar_detalle_grupo1(
           pn_fecha in date, 
           pn_corr in number, 
           pn_fecha_prev in date,
           
           pn_pgcod in number,
           pn_aomod in number,
           pn_aosuc in number,
           pn_aomda in number,
           pn_aopap in number,
           pn_aocta in number,
           pn_aooper in number,
           pn_aosbop in number,
           pn_aotope in number);  
           
 PROCEDURE sp_insertar_detalle_grupo2(pn_fecpro in date, 
                                pn_corr in number, 
                                pn_fecha_prev in date, 
                                pn_fecha_inst in date,
                                pn_corr_inst in number,
                                
                                pn_pgcod in number,
                                pn_aomod in number,
                                pn_aosuc in number,
                                pn_aomda in number,
                                pn_aopap in number,
                                pn_aocta in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number);  
 
 PROCEDURE sp_insertar_JAQZ520_010( pn_fecha in date, 
                                    pn_corr in number, 
                                    pn_inst in number, 
                                    pn_fecha_prev in date,
    
                                    pn_pgcod in number,
                                    pn_aomod in number, 
                                    pn_aosuc in number, 
                                    pn_aomda in number, 
                                    pn_aopap in number, 
                                    pn_aocta in number, 
                                    pn_aooper in number, 
                                    pn_aosbop in number, 
                                    pn_aotope in number,
                                    
                                    pn_feca in date,
                                    pn_revr in char
                                   );     
                                   
 PROCEDURE sp_insertar_AQPA004( pn_fecha in date, 
                                pn_corr in number, 
                                pn_inst in number, 
                                pn_fecha_prev in date,
                                pn_fecha_inst in date,
                                pn_corr_inst in number,
                                pn_feca in date,
                                pn_revr in char,
                                
                                pn_pgcod in number,
                                pn_aomod in number, 
                                pn_aosuc in number, 
                                pn_aomda in number, 
                                pn_aopap in number, 
                                pn_aocta in number, 
                                pn_aooper in number, 
                                pn_aosbop in number, 
                                pn_aotope in number
                                );      
                                

 PROCEDURE sp_insertar_FPP002(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);      

                              
 PROCEDURE sp_insertar_X054023(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);        
                              
 PROCEDURE sp_insertar_FSD012(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);   
                               
 PROCEDURE sp_insertar_FSD601_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              
 PROCEDURE sp_insertar_FSD602_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              
 PROCEDURE sp_insertar_FSD611_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);    
                              
 PROCEDURE sp_insertar_FPP001_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);   
                              
 PROCEDURE sp_insertar_FPP002_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);     
                              
 PROCEDURE sp_insertar_X054023_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              
 PROCEDURE sp_insertar_FSD012_a(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);   
                              
  PROCEDURE sp_insertar_AQPB064_ini(pn_fecha_ini in date,pn_fecha_fin in date, pn_digito in number);   
  
    procedure sp_cr_job_carga(pn_fecha_ini in date,pn_fecha_fin in date);                                
   
                          
 PROCEDURE sp_repro_marzo;                            
 
  PROCEDURE sp_insertar_AQPB064_JAQZ698_a(pn_fecha in date,
                                         pn_corr in number, 
                                         pn_inst in number, 
                                         pn_fecha_prev in date,
                                         pn_revr in char,
                                         
                                         pn_pgcod in number,
                                         pn_aomod in number, 
                                         pn_aosuc in number, 
                                         pn_aomda in number, 
                                         pn_aopap in number, 
                                         pn_aocta in number, 
                                         pn_aooper in number, 
                                         pn_aosbop in number, 
                                         pn_aotope in number);    
                                         
  PROCEDURE sp_insertar_AQPB064_AQPB002_a( pn_fecha in date, 
                                        pn_corr in number, 
                                        pn_inst in number, 
                                        pn_fecha_prev in date,
    
                                      pn_pgcod in number,
                                      pn_aomod in number, 
                                      pn_aosuc in number, 
                                      pn_aomda in number, 
                                      pn_aopap in number, 
                                      pn_aocta in number, 
                                      pn_aooper in number, 
                                      pn_aosbop in number, 
                                      pn_aotope in number,
                                      pn_feca in date,
                                      pn_revr in char
                                     );   
                                     
procedure sp_repro_marzo_a ; 

 PROCEDURE sp_insertar_FSD601_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              

 PROCEDURE sp_insertar_FSD602_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);
                              
 PROCEDURE sp_insertar_FSD611_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);  
                               
                              
 PROCEDURE sp_insertar_FPP001_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                         
 PROCEDURE sp_insertar_FPP002_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);     
         
 PROCEDURE sp_insertar_X054023_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                                
                              
 PROCEDURE sp_insertar_FSD012_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);    
                              
                                                                                                                                                                                                                                                                                                                   
    
end pq_cr_historico_pagos_masivo;
/

create or replace package body pq_cr_historico_pagos_masivo is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_masivo
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones masivas
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB064(pn_fecha_ini in date, pn_fecha_fin in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
    lc_fecha_prv date;
  
    --Cursor JAQZ698
    cursor cur_jaqz698(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from jaqz698 j
       where j.jaqz698est in ('C', 'V')
         and j.jaqz698fep >= cr_fecha_ini
         and j.jaqz698fep <= cr_fecha_fin
       order by j.jaqz698fep, j.jaqz698cor asc;
  
    --Cursor AQPB002
    cursor cur_aqpb002(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb002 j
       where j.aqpb002est = 'C'
         and j.aqpb002fep >= cr_fecha_ini
         and j.aqpb002fep <= cr_fecha_fin
       order by j.aqpb002fep, j.aqpb002cor asc;
  
  Begin
  
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_prv := lc_fecha_ini - 1;
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Eliminado de data
      --delete from aqpb064 t where t.aqpb064frepro >= lc_fecha_ini and t.aqpb064frepro <= lc_fecha_fin ;
      --commit;
    
      ---Recurrido cursor JAQZ698
      for i in cur_jaqz698(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_JAQZ698(i.jaqz698fep,
                                                                 i.jaqz698cor,
                                                                 i.jaqz698inst,
                                                                 lc_fecha_prv,
                                                                 i.jaqz698est,
                                                                 
                                                                 i.jaqz698emp,
                                                                 i.jaqz698mod,
                                                                 i.jaqz698suc,
                                                                 i.jaqz698mda,
                                                                 i.jaqz698pap,
                                                                 i.jaqz698cta,
                                                                 i.jaqz698ope,
                                                                 i.jaqz698sbo,
                                                                 i.jaqz698top);
      
      end loop;
    
      --Recorrido cursor AQPB002
      for j in cur_aqpb002(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_AQPB002(j.aqpb002fep,
                                                                 j.aqpb002cor,
                                                                 j.aqpb002ins,
                                                                 lc_fecha_prv,
                                                                 
                                                                 j.aqpb002emp,
                                                                 j.aqpb002mod,
                                                                 j.aqpb002suc,
                                                                 j.aqpb002mda,
                                                                 j.aqpb002pap,
                                                                 j.aqpb002cta,
                                                                 j.aqpb002ope,
                                                                 j.aqpb002sbo,
                                                                 j.aqpb002top,
                                                                 
                                                                 j.aqpb002feca,
                                                                 j.aqpb002revr);
      
      end loop;
    
    end;
  
  end sp_insertar_AQPB064;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB064_JAQZ698(pn_fecha      in date,
                                        pn_corr       in number,
                                        pn_inst       in number,
                                        pn_fecha_prev in date,
                                        pn_revr       in char,
                                        
                                        pn_pgcod  in number,
                                        pn_aomod  in number,
                                        pn_aosuc  in number,
                                        pn_aomda  in number,
                                        pn_aopap  in number,
                                        pn_aocta  in number,
                                        pn_aooper in number,
                                        pn_aosbop in number,
                                        pn_aotope in number) is
    lc_flag char(1);
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
  
    lx_scsdo  number(17, 2);
    lx_orden  number;
    lc_coderr char(100);
    lc_msgerr char(100);
    lx_cont   number;
  
    -- Detalle
    cursor jaqz520_601c(cr_fecha  date,
                        cr_corr   number,
                        cr_pgcod  number,
                        cr_aomod  number,
                        cr_aosuc  number,
                        cr_aomda  number,
                        cr_aopap  number,
                        cr_aocta  number,
                        cr_aooper number,
                        cr_aosbop number,
                        cr_aotope number) is
      select *
        from jaqz520_601c t
       where t.fec = cr_fecha
         and t.cor = cr_corr
         and t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    cursor jaqz520_602c(cr_fecha  date,
                        cr_corr   number,
                        cr_pgcod  number,
                        cr_aomod  number,
                        cr_aosuc  number,
                        cr_aomda  number,
                        cr_aopap  number,
                        cr_aocta  number,
                        cr_aooper number,
                        cr_aosbop number,
                        cr_aotope number) is
      select *
        from jaqz520_602c t
       where t.fec = cr_fecha
         and t.cor = cr_corr
         and t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    cursor jaqz520_611c(cr_fecha  date,
                        cr_corr   number,
                        cr_pgcod  number,
                        cr_aomod  number,
                        cr_aosuc  number,
                        cr_aomda  number,
                        cr_aopap  number,
                        cr_aocta  number,
                        cr_aooper number,
                        cr_aosbop number,
                        cr_aotope number) is
      select *
        from jaqz520_611c t
       where t.fec = cr_fecha
         and t.cor = cr_corr
         and t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    cursor aqpa004v1(cr_fecha  date,
                     cr_corr   number,
                     cr_pgcod  number,
                     cr_aomod  number,
                     cr_aosuc  number,
                     cr_aomda  number,
                     cr_aopap  number,
                     cr_aocta  number,
                     cr_aooper number,
                     cr_aosbop number,
                     cr_aotope number) is
      select *
        from aqpa004v1 t
       where t.aqpa4cfep = cr_fecha
         and t.aqpa4ccor = cr_corr
         and t.aqpa4cpgcod = cr_pgcod
         and t.aqpa4caomod = cr_aomod
         and t.aqpa4caosuc = cr_aosuc
         and t.aqpa4caomda = cr_aomda
         and t.aqpa4caopap = cr_aopap
         and t.aqpa4caocta = cr_aocta
         and t.aqpa4caooper = cr_aooper
         and t.aqpa4caosbop = cr_aosbop
         and t.aqpa4caotope = cr_aotope;
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from jaqz520_010c q
       where q.fec = pn_fecha
         and q.cor = pn_corr
         and q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
         and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = pn_aosbop
         and q.aotope = pn_aotope;
    exception
      when others then
        lc_flag := 'N';
    end;
  
    if lc_flag = 'S' then
      begin
        /************************/
      
        begin
          select nvl(max(x.aqpb064orden), 0) + 1
            into lx_orden
            from aqpb064 x
           where x.aqpb064pgcod = pn_pgcod
             and x.aqpb064aomod = pn_aomod
             and
                --x.aqpb064aosuc = pn_aosuc and
                 x.aqpb064aomda = pn_aomda
             and x.aqpb064aopap = pn_aopap
             and x.aqpb064aocta = pn_aocta
             and x.aqpb064aooper = pn_aooper -- and
          --x.aqpb064aosbop = pn_aosbop and
          --x.aqpb064aotope = pn_aotope
          ;
        exception
          when others then
            lx_orden := 1;
        end;
      
        /****************************/
      
        lx_frepro  := pn_fecha;
        lx_ncorre  := pn_corr;
        lx_proceso := 'C'; ---CAPITALIZACION
        lx_fcierre := pn_fecha_prev; --lc_fecha_prv;
        lx_instanc := pn_inst;
        --if (pn_revr = 'V') then
        --  lx_estado := 'X'; 
        --else
        --  lx_estado := 'R'; 
        --end if;
        lx_estado := 'C';
      
        lx_fecest := pn_fecha;
      
        /****************************/
      
        select nvl(sum(r.scsdo), 0)
          into lx_scsdo
          from jaqz520_011c r
         where r.fec = pn_fecha
           and r.cor = pn_corr
           and
              
               r.pgcod = pn_pgcod
           and r.scmod = pn_aomod
           and r.scsuc = pn_aosuc
           and r.scmda = pn_aomda
           and r.scpap = pn_aopap
           and r.sccta = pn_aocta
           and r.scoper = pn_aooper
           and r.scsbop = pn_aosbop
           and r.sctope = pn_aotope;
      
        /****************************/
        insert into AQPB064
          (aqpb064frepro,
           aqpb064ncorre,
           aqpb064pgcod,
           aqpb064aomod,
           aqpb064aosuc,
           aqpb064aomda,
           aqpb064aopap,
           aqpb064aocta,
           aqpb064aooper,
           aqpb064aosbop,
           aqpb064aotope,
           aqpb064aofval,
           aqpb064aofvto,
           aqpb064aopzo,
           aqpb064aotasa,
           aqpb064aoimp,
           --aqpb064aomd,
           aqpb064aostat,
           aqpb064aofe99,
           aqpb064aoperiod,
           aqpb064proceso,
           aqpb064fcierre,
           aqpb064instanc,
           aqpb064estado,
           aqpb064fecest,
           --aqpb064diaatr,
           --aqpb064diagra,
           --aqpb064fepvep,
           aqpb064scsdo,
           --aqpb064freproref,
           --aqpb064ncorreref,
           aqpb064tablaref,
           aqpb064orden)
          select lx_frepro,
                 lx_ncorre,
                 q.pgcod, --lx_pgcod,
                 q.aomod, --lx_aomod,
                 q.aosuc, --lx_aosuc,
                 q.aomda, --lx_aomda,
                 q.aopap, --lx_aopap,
                 q.aocta, --lx_aocta,
                 q.aooper, --lx_aooper,
                 q.aosbop, --lx_aosbop,
                 q.aotope, --lx_aotope,
                 
                 q.aofval, --lx_aofval,
                 q.aofvto, --lx_aofvto
                 q.aopzo, --lx_aopzo
                 q.aotasa, --lx_aotasa
                 q.aoimp, --lx_aoimp
                 q.aostat, --lx_aostat
                 q.aofe99, --lx_aofe99
                 q.aoperiod, --lx_aoperiod
                 
                 lx_proceso,
                 lx_fcierre,
                 lx_instanc,
                 lx_estado,
                 lx_fecest,
                 lx_scsdo,
                 'JAQZ698',
                 lx_orden
          
            from jaqz520_010c q
           where q.fec = pn_fecha
             and q.cor = pn_corr
             and q.pgcod = pn_pgcod
             and q.aomod = pn_aomod
             and q.aosuc = pn_aosuc
             and q.aomda = pn_aomda
             and q.aopap = pn_aopap
             and q.aocta = pn_aocta
             and q.aooper = pn_aooper
             and q.aosbop = pn_aosbop
             and q.aotope = pn_aotope;
      
        commit;
      
        -- registrar solo si es la primera reprogramación
        if lx_orden = 1 then
        
          ---Insertar aqpb009
          insert into aqpb009
            (aqpb009fep,
             aqpb009cor,
             aqpb009emp,
             aqpb009mod,
             aqpb009suc,
             aqpb009mda,
             aqpb009pap,
             aqpb009cta,
             aqpb009ope,
             aqpb009sbo,
             aqpb009top,
             aqpb009est,
             aqpb009sdo,
             --aqpb009tea1,
             --aqpb009tea2,
             --aqpb009tcea1,
             --aqpb009tcea2,
             --aqpb009usr,
             --aqpb009hoi,
             --aqpb009hof,
             --aqpb009narc,
             aqpb009ins,
             --aqpb009fmail,
             --aqpb009mail,
             --aqpb009ase,
             --aqpb009tpo,
             --aqpb009estcr,
             --aqpb009rub,
             aqpb009tref)
            select t.jaqz698fep,
                   t.jaqz698cor,
                   t.jaqz698emp,
                   t.jaqz698mod,
                   t.jaqz698suc,
                   t.jaqz698mda,
                   t.jaqz698pap,
                   t.jaqz698cta,
                   t.jaqz698ope,
                   t.jaqz698sbo,
                   t.jaqz698top,
                   lx_estado, --t.jaqz698est,
                   lx_scsdo,
                   lx_instanc,
                   'JAQZ698'
              from jaqz698 t
             where t.jaqz698fep = pn_fecha
               and t.jaqz698cor = pn_corr
               and t.jaqz698emp = pn_pgcod
               and t.jaqz698mod = pn_aomod
               and t.jaqz698suc = pn_aosuc
               and t.jaqz698mda = pn_aomda
               and t.jaqz698pap = pn_aopap
               and t.jaqz698cta = pn_aocta
               and t.jaqz698ope = pn_aooper
               and t.jaqz698sbo = pn_aosbop
               and t.jaqz698top = pn_aotope;
          commit;
        
          if pn_aosbop = 0 then
            begin
            
              /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
              select count(*)
                into lx_cont
                from jaqz520_601c t
               where t.fec = pn_fecha
                 and t.cor = pn_corr
                 and t.pgcod = pn_pgcod
                 and t.ppmod = pn_aomod
                 and t.ppsuc = pn_aosuc
                 and t.ppmda = pn_aomda
                 and t.pppap = pn_aopap
                 and t.ppcta = pn_aocta
                 and t.ppoper = pn_aooper
                 and t.ppsbop = pn_aosbop
                 and t.pptope = pn_aotope;
            
              if lx_cont > 0 then
              
                for k in jaqz520_601c(pn_fecha,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
                  begin
                    --Inserción aqpb061
                    insert into AQPB061
                      (aqpb061pgcod,
                       aqpb061mod,
                       aqpb061suc,
                       aqpb061mda,
                       aqpb061pap,
                       aqpb061cta,
                       aqpb061oper,
                       aqpb061sbop,
                       aqpb061tope,
                       aqpb061fpag,
                       aqpb061tipo,
                       aqpb061fval,
                       aqpb061fvto,
                       aqpb061pzo,
                       aqpb061cap,
                       aqpb061int,
                       aqpb061intmex,
                       aqpb061icap,
                       aqpb061iint,
                       aqpb061stat,
                       aqpb061nume,
                       aqpb061finv,
                       aqpb061cd,
                       aqpb061mo,
                       aqpb061su,
                       aqpb061tr,
                       aqpb061re,
                       aqpb061fc,
                       aqpb061or,
                       aqpb061sb,
                       aqpb061co,
                       aqpb061obop)
                    
                    values
                      (k.pgcod,
                       k.ppmod,
                       k.ppsuc,
                       k.ppmda,
                       k.pppap,
                       k.ppcta,
                       k.ppoper,
                       k.ppsbop,
                       k.pptope,
                       k.ppfpag,
                       k.pptipo,
                       k.ppfval,
                       k.ppfvto,
                       k.pppzo,
                       k.ppcap,
                       k.ppint,
                       k.ppintmex,
                       k.ppicap,
                       k.ppiint,
                       k.ppstat,
                       k.ppnume,
                       k.ppfinv,
                       k.d601cd,
                       k.d601mo,
                       k.d601su,
                       k.d601tr,
                       k.d601re,
                       k.d601fc,
                       k.d601or,
                       k.d601sb,
                       k.d601co,
                       k.ppsbop
                       --,fec ,
                       --cor
                       );
                  exception
                    when others then
                      -- lc_flag := 'N';
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm), 1, 90);
                    
                      insert into aqpb066
                        (aqpb066fep,
                         aqpb066cor,
                         aqpb066emp,
                         aqpb066mod,
                         aqpb066suc,
                         aqpb066mda,
                         aqpb066pap,
                         aqpb066cta,
                         aqpb066ope,
                         aqpb066sbo,
                         aqpb066top,
                         aqpb066tref,
                         aqpb066etip,
                         aqpb066eacoe,
                         aqpb066eamsge)
                      values
                        (lx_frepro,
                         lx_ncorre,
                         pn_pgcod,
                         pn_aomod,
                         pn_aosuc,
                         pn_aomda,
                         pn_aopap,
                         pn_aocta,
                         pn_aooper,
                         pn_aosbop,
                         pn_aotope,
                         'FSD601',
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                    
                  end;
                end loop;
                commit;
              
              else
              
                pq_cr_historico_pagos_masivo.sp_insertar_FSD601_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
              
              end if;
            
              /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
              select count(*)
                into lx_cont
                from jaqz520_602c t
               where t.fec = pn_fecha
                 and t.cor = pn_corr
                 and t.pgcod = pn_pgcod
                 and t.ppmod = pn_aomod
                 and t.ppsuc = pn_aosuc
                 and t.ppmda = pn_aomda
                 and t.pppap = pn_aopap
                 and t.ppcta = pn_aocta
                 and t.ppoper = pn_aooper
                 and t.ppsbop = pn_aosbop
                 and t.pptope = pn_aotope;
            
              if lx_cont > 0 then
              
                for m in jaqz520_602c(pn_fecha,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
                  begin
                    insert into AQPB062
                      (aqpb062pgcod,
                       aqpb062mod,
                       aqpb062suc,
                       aqpb062mda,
                       aqpb062pap,
                       aqpb062cta,
                       aqpb062oper,
                       aqpb062sbop,
                       aqpb062tope,
                       aqpb062fpag,
                       aqpb062tipo,
                       aqpb062nump,
                       aqpb062fech,
                       aqpb062cap,
                       aqpb062int,
                       aqpb062intmex,
                       aqpb062intm,
                       aqpb062intmmex,
                       aqpb062icap,
                       aqpb062iint,
                       aqpb062iintm,
                       aqpb062salcap,
                       aqpb062salint,
                       aqpb062salade,
                       aqpb062salmor,
                       aqpb062stat,
                       aqpb062salintm,
                       aqpb062salmorm,
                       aqpb062saladem,
                       aqpb062cd,
                       aqpb062mo,
                       aqpb062su,
                       aqpb062tr,
                       aqpb062re,
                       aqpb062fc,
                       aqpb062or,
                       aqpb062sb,
                       aqpb062co,
                       aqpb062obop)
                    values
                      (m.pgcod,
                       m.ppmod,
                       m.ppsuc,
                       m.ppmda,
                       m.pppap,
                       m.ppcta,
                       m.ppoper,
                       m.ppsbop,
                       m.pptope,
                       m.ppfpag,
                       m.pptipo,
                       m.pp1nump,
                       m.pp1fech,
                       m.pp1cap,
                       m.pp1int,
                       m.pp1intmex,
                       m.pp1intm,
                       m.pp1intmmex,
                       m.pp1icap,
                       m.pp1iint,
                       m.pp1iintm,
                       m.pp1salcap,
                       m.pp1salint,
                       m.pp1salade,
                       m.pp1salmor,
                       m.pp1stat,
                       m.pp1salintm,
                       m.pp1salmorm,
                       m.pp1saladem,
                       m.d602cd,
                       m.d602mo,
                       m.d602su,
                       m.d602tr,
                       m.d602re,
                       m.d602fc,
                       m.d602or,
                       m.d602sb,
                       m.d602co,
                       m.ppsbop);
                  exception
                    when others then
                      --lc_flag := 'N';
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm), 1, 90);
                    
                      insert into aqpb066
                        (aqpb066fep,
                         aqpb066cor,
                         aqpb066emp,
                         aqpb066mod,
                         aqpb066suc,
                         aqpb066mda,
                         aqpb066pap,
                         aqpb066cta,
                         aqpb066ope,
                         aqpb066sbo,
                         aqpb066top,
                         aqpb066tref,
                         aqpb066etip,
                         aqpb066eacoe,
                         aqpb066eamsge)
                      values
                        (lx_frepro,
                         lx_ncorre,
                         pn_pgcod,
                         pn_aomod,
                         pn_aosuc,
                         pn_aomda,
                         pn_aopap,
                         pn_aocta,
                         pn_aooper,
                         pn_aosbop,
                         pn_aotope,
                         'FSD602',
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                    
                  end;
                end loop;
                commit;
              
              else
              
                pq_cr_historico_pagos_masivo.sp_insertar_FSD602_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
              
              end if;
            
              /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
              select count(*)
                into lx_cont
                from jaqz520_611c t
               where t.fec = pn_fecha
                 and t.cor = pn_corr
                 and t.pgcod = pn_pgcod
                 and t.ppmod = pn_aomod
                 and t.ppsuc = pn_aosuc
                 and t.ppmda = pn_aomda
                 and t.pppap = pn_aopap
                 and t.ppcta = pn_aocta
                 and t.ppoper = pn_aooper
                 and t.ppsbop = pn_aosbop
                 and t.pptope = pn_aotope;
            
              if lx_cont > 0 then
              
                for p in jaqz520_611c(pn_fecha,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
                  begin
                  
                    insert into AQPB063
                      (aqpb063pgcod,
                       aqpb063mod,
                       aqpb063suc,
                       aqpb063mda,
                       aqpb063pap,
                       aqpb063cta,
                       aqpb063oper,
                       aqpb063sbop,
                       aqpb063tope,
                       aqpb063fpag,
                       aqpb063tipo,
                       aqpb063exte,
                       aqpb063imp1,
                       aqpb063imp2,
                       aqpb063imp3,
                       aqpb063imp4,
                       aqpb063imp5,
                       aqpb063imp6,
                       aqpb063imp7,
                       aqpb063imp8,
                       aqpb063imp9,
                       aqpb063imp10,
                       aqpb063imp11,
                       aqpb063imp12,
                       aqpb063imp13,
                       aqpb063imp14,
                       aqpb063imp15,
                       aqpb063imp16,
                       aqpb063imp17,
                       aqpb063imp18,
                       aqpb063imp19,
                       aqpb063imp20,
                       aqpb063obop)
                    values
                      (p.pgcod,
                       p.ppmod,
                       p.ppsuc,
                       p.ppmda,
                       p.pppap,
                       p.ppcta,
                       p.ppoper,
                       p.ppsbop,
                       p.pptope,
                       p.ppfpag,
                       p.pptipo,
                       p.ppexte,
                       p.ppimp1,
                       p.ppimp2,
                       p.ppimp3,
                       p.ppimp4,
                       p.ppimp5,
                       p.ppimp6,
                       p.ppimp7,
                       p.ppimp8,
                       p.ppimp9,
                       p.ppimp10,
                       p.ppimp11,
                       p.ppimp12,
                       p.ppimp13,
                       p.ppimp14,
                       p.ppimp15,
                       p.ppimp16,
                       p.ppimp17,
                       p.ppimp18,
                       p.ppimp19,
                       p.ppimp20,
                       p.ppsbop);
                  exception
                    when others then
                      --lc_flag := 'N';
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm), 1, 90);
                    
                      insert into aqpb066
                        (aqpb066fep,
                         aqpb066cor,
                         aqpb066emp,
                         aqpb066mod,
                         aqpb066suc,
                         aqpb066mda,
                         aqpb066pap,
                         aqpb066cta,
                         aqpb066ope,
                         aqpb066sbo,
                         aqpb066top,
                         aqpb066tref,
                         aqpb066etip,
                         aqpb066eacoe,
                         aqpb066eamsge)
                      values
                        (lx_frepro,
                         lx_ncorre,
                         pn_pgcod,
                         pn_aomod,
                         pn_aosuc,
                         pn_aomda,
                         pn_aopap,
                         pn_aocta,
                         pn_aooper,
                         pn_aosbop,
                         pn_aotope,
                         'FSD611',
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                    
                  end;
                end loop;
                commit;
              
              else
              
                pq_cr_historico_pagos_masivo.sp_insertar_FSD611_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
              
              end if;
            
              /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
              select count(*)
                into lx_cont
                from aqpa004v1 t
               where t.aqpa4cfep = pn_fecha
                 and t.aqpa4ccor = pn_corr
                 and t.aqpa4cpgcod = pn_pgcod
                 and t.aqpa4caomod = pn_aomod
                 and t.aqpa4caosuc = pn_aosuc
                 and t.aqpa4caomda = pn_aomda
                 and t.aqpa4caopap = pn_aopap
                 and t.aqpa4caocta = pn_aocta
                 and t.aqpa4caooper = pn_aooper
                 and t.aqpa4caosbop = pn_aosbop
                 and t.aqpa4caotope = pn_aotope;
            
              if lx_cont > 0 then
              
                for q in aqpa004v1(pn_fecha,
                                   pn_corr,
                                   pn_pgcod,
                                   pn_aomod,
                                   pn_aosuc,
                                   pn_aomda,
                                   pn_aopap,
                                   pn_aocta,
                                   pn_aooper,
                                   pn_aosbop,
                                   pn_aotope) loop
                  begin
                  
                    insert into aqpa974
                      (aqpa974pgcod,
                       aqpa974mod,
                       aqpa974suc,
                       aqpa974mda,
                       aqpa974pap,
                       aqpa974cta,
                       aqpa974oper,
                       aqpa974sbop,
                       aqpa974tope,
                       aqpa974sgcod,
                       aqpa974vc,
                       aqpa974imp,
                       aqpa974porc,
                       aqpa974plus,
                       aqpa974part,
                       aqpa974veh,
                       aqpa974inm,
                       aqpa974end,
                       aqpa974stat,
                       aqpa974co,
                       aqpa974aux1,
                       aqpa974aux2,
                       aqpa974aux3,
                       aqpa974aux4,
                       aqpa974aux5,
                       aqpa974aux6,
                       aqpa974aux7,
                       aqpa974obop)
                    values
                      (q.aqpa4cpgcod,
                       q.aqpa4caomod,
                       q.aqpa4caosuc,
                       q.aqpa4caomda,
                       q.aqpa4caopap,
                       q.aqpa4caocta,
                       q.aqpa4caooper,
                       q.aqpa4caosbop,
                       q.aqpa4caotope,
                       q.aqpa4csgcod,
                       --q.aqpa4cfpro,
                       q.aqpa4cvc,
                       q.aqpa4cimp,
                       q.aqpa4cporc,
                       q.aqpa4cplus,
                       q.aqpa4cpart,
                       q.aqpa4cveh,
                       q.aqpa4cinm,
                       q.aqpa4cend,
                       q.aqpa4cstat,
                       q.aqpa4cco,
                       q.aqpa4caux1,
                       q.aqpa4caux2,
                       q.aqpa4caux3,
                       q.aqpa4caux4,
                       q.aqpa4caux5,
                       q.aqpa4caux6,
                       q.aqpa4caux7,
                       q.aqpa4caosbop
                       --pn_fecha, --frepro,
                       ---pn_corr, --ncorre,
                       --'JAQZ698' --tablaref
                       );
                  exception
                    when others then
                      --lc_flag := 'N';
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm), 1, 90);
                    
                      insert into aqpb066
                        (aqpb066fep,
                         aqpb066cor,
                         aqpb066emp,
                         aqpb066mod,
                         aqpb066suc,
                         aqpb066mda,
                         aqpb066pap,
                         aqpb066cta,
                         aqpb066ope,
                         aqpb066sbo,
                         aqpb066top,
                         aqpb066tref,
                         aqpb066etip,
                         aqpb066eacoe,
                         aqpb066eamsge)
                      values
                        (lx_frepro,
                         lx_ncorre,
                         pn_pgcod,
                         pn_aomod,
                         pn_aosuc,
                         pn_aomda,
                         pn_aopap,
                         pn_aocta,
                         pn_aooper,
                         pn_aosbop,
                         pn_aotope,
                         'FPP001',
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                    
                  end;
                end loop;
                commit;
              
              else
              
                pq_cr_historico_pagos_masivo.sp_insertar_FPP001_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
              
              end if;
            
              /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FPP002(pn_pgcod,
                                                              pn_aomod,
                                                              pn_aosuc,
                                                              pn_aomda,
                                                              pn_aopap,
                                                              pn_aocta,
                                                              pn_aooper,
                                                              pn_aosbop,
                                                              pn_aotope);
            
              /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_X054023(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);
            
              /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FSD012(pn_pgcod,
                                                              pn_aomod,
                                                              pn_aosuc,
                                                              pn_aomda,
                                                              pn_aopap,
                                                              pn_aocta,
                                                              pn_aooper,
                                                              pn_aosbop,
                                                              pn_aotope);
            
            end;
          
          else
            -- SI LA SUBOPERACIÓN ES MAYOR A 0  
            begin
            
              --lx_orden := 99;
              /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FSD601_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
              /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FSD602_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
              /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FSD611_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
              /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FPP001_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
              /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FPP002_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
              /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_X054023_a(pn_pgcod,
                                                                 pn_aomod,
                                                                 pn_aosuc,
                                                                 pn_aomda,
                                                                 pn_aopap,
                                                                 pn_aocta,
                                                                 pn_aooper,
                                                                 pn_aosbop,
                                                                 pn_aotope);
            
              /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
              pq_cr_historico_pagos_masivo.sp_insertar_FSD012_a(pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
            
            end;
          
          end if;
        
          --- Final: validación  
        end if;
      
      end;
    end if;
  
  end sp_insertar_AQPB064_JAQZ698;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB064_AQPB002(pn_fecha      in date,
                                        pn_corr       in number,
                                        pn_inst       in number,
                                        pn_fecha_prev in date,
                                        
                                        pn_pgcod  in number,
                                        pn_aomod  in number,
                                        pn_aosuc  in number,
                                        pn_aomda  in number,
                                        pn_aopap  in number,
                                        pn_aocta  in number,
                                        pn_aooper in number,
                                        pn_aosbop in number,
                                        pn_aotope in number,
                                        pn_feca   in date,
                                        pn_revr   in char) is
    --lc_flag char(1) ;
    lc_desp       number;
    lc_fecha_desp date;
    lc_corr_desp  number;
    lc_inst_desp  number;
  
  begin
  
    ---2. Verificar si la clave tiene un registro en el futuro cercano
    begin
    
      select count(*)
        into lc_desp
        from aqpb002 t
       where t.aqpb002emp = pn_pgcod
         and t.aqpb002mod = pn_aomod
         and t.aqpb002suc = pn_aosuc
         and t.aqpb002mda = pn_aomda
         and t.aqpb002pap = pn_aopap
         and t.aqpb002cta = pn_aocta
         and t.aqpb002ope = pn_aooper
         and t.aqpb002sbo = pn_aosbop
         and t.aqpb002top = pn_aotope
         and t.aqpb002est = 'C'
         and t.aqpb002fep > pn_fecha;
    exception
      when others then
        lc_desp := 0;
    end;
  
    /**-----------------------*/
  
    if (lc_desp = 0) then
    
      /************ GRUPO 1 ****************/
      begin
        --dbms_output.put_line(to_char(pn_fecha) || ' ' || to_char(pn_corr) ||  '***** PRIMER CAMINO *****');           
        --1. Inserci+on desde JAQZ520_XXX
        pq_cr_historico_pagos_masivo.sp_insertar_JAQZ520_010(pn_fecha,
                                                             pn_corr,
                                                             pn_inst,
                                                             pn_fecha_prev,
                                                             
                                                             pn_pgcod,
                                                             pn_aomod,
                                                             pn_aosuc,
                                                             pn_aomda,
                                                             pn_aopap,
                                                             pn_aocta,
                                                             pn_aooper,
                                                             pn_aosbop,
                                                             pn_aotope,
                                                             
                                                             pn_feca,
                                                             pn_revr);
      
      end;
    
    else
      /************ GRUPO 2 ****************/
      begin
        --dbms_output.put_line(to_char(pn_fecha) || ' ' || to_char(pn_corr) ||  '***** SEGUNDO CAMINO *****');                   
      
        --2. Inserci+on desde AQPAXXX   
        select f.aqpb002fep, f.aqpb002cor, f.aqpb002ins
          into lc_fecha_desp, lc_corr_desp, lc_inst_desp
          from (select t.aqpb002fep,
                       t.aqpb002cor,
                       t.aqpb002emp,
                       t.aqpb002mod,
                       t.aqpb002suc,
                       t.aqpb002mda,
                       t.aqpb002pap,
                       t.aqpb002cta,
                       t.aqpb002ope,
                       t.aqpb002sbo,
                       t.aqpb002top,
                       t.aqpb002ins
                  from aqpb002 t
                 where t.aqpb002emp = pn_pgcod
                   and t.aqpb002mod = pn_aomod
                   and t.aqpb002suc = pn_aosuc
                   and t.aqpb002mda = pn_aomda
                   and t.aqpb002pap = pn_aopap
                   and t.aqpb002cta = pn_aocta
                   and t.aqpb002ope = pn_aooper
                   and t.aqpb002sbo = pn_aosbop
                   and t.aqpb002top = pn_aotope
                   and t.aqpb002est = 'C'
                   and t.aqpb002fep > pn_fecha
                 order by t.aqpb002fep asc) f
         where rownum = 1;
      
        pq_cr_historico_pagos_masivo.sp_insertar_AQPA004(lc_fecha_desp,
                                                         lc_corr_desp,
                                                         lc_inst_desp,
                                                         pn_fecha_prev,
                                                         pn_fecha,
                                                         pn_corr,
                                                         pn_feca,
                                                         pn_revr,
                                                         
                                                         pn_pgcod,
                                                         pn_aomod,
                                                         pn_aosuc,
                                                         pn_aomda,
                                                         pn_aopap,
                                                         pn_aocta,
                                                         pn_aooper,
                                                         pn_aosbop,
                                                         pn_aotope);
      
      end;
    end if;
  
  end sp_insertar_AQPB064_AQPB002;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_detalle_grupo1(pn_fecha      in date,
                                       pn_corr       in number,
                                       pn_fecha_prev in date,
                                       
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number) is
  
    lc_flag   char(1);
    lc_coderr char(100);
    lc_msgerr char(1000);
    lx_cont   number;
  
    --- grupo 1
    cursor grupo1_jaqz520_601(cr_PGCOD  number,
                              cr_PPMOD  number,
                              cr_PPSUC  number,
                              cr_PPMDA  number,
                              cr_PPPAP  number,
                              cr_PPCTA  number,
                              cr_PPOPER number,
                              cr_PPSBOP number,
                              cr_PPTOPE number) is
    
      select *
        from jaqz520_601 t
       where t.PGCOD = cr_PGCOD
         and t.PPMOD = cr_PPMOD
         and t.PPSUC = cr_PPSUC
         and t.PPMDA = cr_PPMDA
         and t.PPPAP = cr_PPPAP
         and t.PPCTA = cr_PPCTA
         and t.PPOPER = cr_PPOPER
         and t.PPSBOP = cr_PPSBOP
         and t.PPTOPE = cr_PPTOPE
       order by t.ppfpag asc;
  
    cursor grupo1_jaqz520_602(cr_pgcod  number,
                              cr_aomod  number,
                              cr_aosuc  number,
                              cr_aomda  number,
                              cr_aopap  number,
                              cr_aocta  number,
                              cr_aooper number,
                              cr_aosbop number,
                              cr_aotope number) is
      select *
        from jaqz520_602 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    cursor grupo1_jaqz520_611(cr_pgcod  number,
                              cr_aomod  number,
                              cr_aosuc  number,
                              cr_aomda  number,
                              cr_aopap  number,
                              cr_aocta  number,
                              cr_aooper number,
                              cr_aosbop number,
                              cr_aotope number) is
      select *
        from jaqz520_611 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
    cursor grupo1_jaqz520_fpp001(cr_fecha  date,
                                 cr_corr   number,
                                 cr_pgcod  number,
                                 cr_aomod  number,
                                 cr_aosuc  number,
                                 cr_aomda  number,
                                 cr_aopap  number,
                                 cr_aocta  number,
                                 cr_aooper number,
                                 cr_aosbop number,
                                 cr_aotope number) is
      select *
        from aqpa004c t
       where t.aqpa4cfpro = cr_fecha
         and t.aqpa4ccor = cr_corr
         and t.aqpa4cpgcod = cr_pgcod
         and t.aqpa4caomod = cr_aomod
         and t.aqpa4caosuc = cr_aosuc
         and t.aqpa4caomda = cr_aomda
         and t.aqpa4caopap = cr_aopap
         and t.aqpa4caocta = cr_aocta
         and t.aqpa4caooper = cr_aooper
         and t.aqpa4caosbop = cr_aosbop
         and t.aqpa4caotope = cr_aotope;
  
  begin
  
    if pn_aosbop = 0 then
    
      begin
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        select count(*)
          into lx_cont
          from jaqz520_601 t
         where t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        if lx_cont > 0 then
        
          for k in grupo1_jaqz520_601(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
              --Inserción aqpb061
              insert into AQPB061
                (aqpb061pgcod,
                 aqpb061mod,
                 aqpb061suc,
                 aqpb061mda,
                 aqpb061pap,
                 aqpb061cta,
                 aqpb061oper,
                 aqpb061sbop,
                 aqpb061tope,
                 aqpb061fpag,
                 aqpb061tipo,
                 aqpb061fval,
                 aqpb061fvto,
                 aqpb061pzo,
                 aqpb061cap,
                 aqpb061int,
                 aqpb061intmex,
                 aqpb061icap,
                 aqpb061iint,
                 aqpb061stat,
                 aqpb061nume,
                 aqpb061finv,
                 aqpb061cd,
                 aqpb061mo,
                 aqpb061su,
                 aqpb061tr,
                 aqpb061re,
                 aqpb061fc,
                 aqpb061or,
                 aqpb061sb,
                 aqpb061co,
                 aqpb061obop)
              
              values
                (k.pgcod,
                 k.ppmod,
                 k.ppsuc,
                 k.ppmda,
                 k.pppap,
                 k.ppcta,
                 k.ppoper,
                 k.ppsbop,
                 k.pptope,
                 k.ppfpag,
                 k.pptipo,
                 k.ppfval,
                 k.ppfvto,
                 k.pppzo,
                 k.ppcap,
                 k.ppint,
                 k.ppintmex,
                 k.ppicap,
                 k.ppiint,
                 k.ppstat,
                 k.ppnume,
                 k.ppfinv,
                 k.d601cd,
                 k.d601mo,
                 k.d601su,
                 k.d601tr,
                 k.d601re,
                 k.d601fc,
                 k.d601or,
                 k.d601sb,
                 k.d601co,
                 k.ppsbop);
            exception
              when others then
                lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha,
                   pn_corr,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD601',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD601_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        select count(*)
          into lx_cont
          from jaqz520_602 t
         where t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        if lx_cont > 0 then
        
          for m in grupo1_jaqz520_602(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
              insert into AQPB062
                (aqpb062pgcod,
                 aqpb062mod,
                 aqpb062suc,
                 aqpb062mda,
                 aqpb062pap,
                 aqpb062cta,
                 aqpb062oper,
                 aqpb062sbop,
                 aqpb062tope,
                 aqpb062fpag,
                 aqpb062tipo,
                 aqpb062nump,
                 aqpb062fech,
                 aqpb062cap,
                 aqpb062int,
                 aqpb062intmex,
                 aqpb062intm,
                 aqpb062intmmex,
                 aqpb062icap,
                 aqpb062iint,
                 aqpb062iintm,
                 aqpb062salcap,
                 aqpb062salint,
                 aqpb062salade,
                 aqpb062salmor,
                 aqpb062stat,
                 aqpb062salintm,
                 aqpb062salmorm,
                 aqpb062saladem,
                 aqpb062cd,
                 aqpb062mo,
                 aqpb062su,
                 aqpb062tr,
                 aqpb062re,
                 aqpb062fc,
                 aqpb062or,
                 aqpb062sb,
                 aqpb062co,
                 aqpb062obop)
              values
                (m.pgcod,
                 m.ppmod,
                 m.ppsuc,
                 m.ppmda,
                 m.pppap,
                 m.ppcta,
                 m.ppoper,
                 m.ppsbop,
                 m.pptope,
                 m.ppfpag,
                 m.pptipo,
                 m.pp1nump,
                 m.pp1fech,
                 m.pp1cap,
                 m.pp1int,
                 m.pp1intmex,
                 m.pp1intm,
                 m.pp1intmmex,
                 m.pp1icap,
                 m.pp1iint,
                 m.pp1iintm,
                 m.pp1salcap,
                 m.pp1salint,
                 m.pp1salade,
                 m.pp1salmor,
                 m.pp1stat,
                 m.pp1salintm,
                 m.pp1salmorm,
                 m.pp1saladem,
                 m.d602cd,
                 m.d602mo,
                 m.d602su,
                 m.d602tr,
                 m.d602re,
                 m.d602fc,
                 m.d602or,
                 m.d602sb,
                 m.d602co,
                 m.ppsbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha,
                   pn_corr,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD602',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD602_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        select count(*)
          into lx_cont
          from jaqz520_611 t
         where t.pgcod = pn_pgcod
           and t.ppmod = pn_aomod
           and t.ppsuc = pn_aosuc
           and t.ppmda = pn_aomda
           and t.pppap = pn_aopap
           and t.ppcta = pn_aocta
           and t.ppoper = pn_aooper
           and t.ppsbop = pn_aosbop
           and t.pptope = pn_aotope;
      
        if lx_cont > 0 then
        
          for p in grupo1_jaqz520_611(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
            
              insert into AQPB063
                (aqpb063pgcod,
                 aqpb063mod,
                 aqpb063suc,
                 aqpb063mda,
                 aqpb063pap,
                 aqpb063cta,
                 aqpb063oper,
                 aqpb063sbop,
                 aqpb063tope,
                 aqpb063fpag,
                 aqpb063tipo,
                 aqpb063exte,
                 aqpb063imp1,
                 aqpb063imp2,
                 aqpb063imp3,
                 aqpb063imp4,
                 aqpb063imp5,
                 aqpb063imp6,
                 aqpb063imp7,
                 aqpb063imp8,
                 aqpb063imp9,
                 aqpb063imp10,
                 aqpb063imp11,
                 aqpb063imp12,
                 aqpb063imp13,
                 aqpb063imp14,
                 aqpb063imp15,
                 aqpb063imp16,
                 aqpb063imp17,
                 aqpb063imp18,
                 aqpb063imp19,
                 aqpb063imp20,
                 aqpb063obop)
              values
                (p.pgcod,
                 p.ppmod,
                 p.ppsuc,
                 p.ppmda,
                 p.pppap,
                 p.ppcta,
                 p.ppoper,
                 p.ppsbop,
                 p.pptope,
                 p.ppfpag,
                 p.pptipo,
                 p.ppexte,
                 p.ppimp1,
                 p.ppimp2,
                 p.ppimp3,
                 p.ppimp4,
                 p.ppimp5,
                 p.ppimp6,
                 p.ppimp7,
                 p.ppimp8,
                 p.ppimp9,
                 p.ppimp10,
                 p.ppimp11,
                 p.ppimp12,
                 p.ppimp13,
                 p.ppimp14,
                 p.ppimp15,
                 p.ppimp16,
                 p.ppimp17,
                 p.ppimp18,
                 p.ppimp19,
                 p.ppimp20,
                 p.ppsbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha,
                   pn_corr,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD611',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD611_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa004c t
         where t.aqpa4cfpro = pn_fecha
           and t.aqpa4ccor = pn_corr
           and t.aqpa4cpgcod = pn_pgcod
           and t.aqpa4caomod = pn_aomod
           and t.aqpa4caosuc = pn_aosuc
           and t.aqpa4caomda = pn_aomda
           and t.aqpa4caopap = pn_aopap
           and t.aqpa4caocta = pn_aocta
           and t.aqpa4caooper = pn_aooper
           and t.aqpa4caosbop = pn_aosbop
           and t.aqpa4caotope = pn_aotope;
      
        if lx_cont > 0 then
        
          for q in grupo1_jaqz520_fpp001(pn_fecha,
                                         pn_corr,
                                         pn_pgcod,
                                         pn_aomod,
                                         pn_aosuc,
                                         pn_aomda,
                                         pn_aopap,
                                         pn_aocta,
                                         pn_aooper,
                                         pn_aosbop,
                                         pn_aotope) loop
            begin
            
              insert into aqpa974
                (aqpa974pgcod,
                 aqpa974mod,
                 aqpa974suc,
                 aqpa974mda,
                 aqpa974pap,
                 aqpa974cta,
                 aqpa974oper,
                 aqpa974sbop,
                 aqpa974tope,
                 aqpa974sgcod,
                 aqpa974vc,
                 aqpa974imp,
                 aqpa974porc,
                 aqpa974plus,
                 aqpa974part,
                 aqpa974veh,
                 aqpa974inm,
                 aqpa974end,
                 aqpa974stat,
                 aqpa974co,
                 aqpa974aux1,
                 aqpa974aux2,
                 aqpa974aux3,
                 aqpa974aux4,
                 aqpa974aux5,
                 aqpa974aux6,
                 aqpa974aux7,
                 aqpa974obop)
              values
                (q.aqpa4cpgcod,
                 q.aqpa4caomod,
                 q.aqpa4caosuc,
                 q.aqpa4caomda,
                 q.aqpa4caopap,
                 q.aqpa4caocta,
                 q.aqpa4caooper,
                 q.aqpa4caosbop,
                 q.aqpa4caotope,
                 q.aqpa4csgcod,
                 --q.aqpa4cfpro,
                 q.aqpa4cvc,
                 q.aqpa4cimp,
                 q.aqpa4cporc,
                 q.aqpa4cplus,
                 q.aqpa4cpart,
                 q.aqpa4cveh,
                 q.aqpa4cinm,
                 q.aqpa4cend,
                 q.aqpa4cstat,
                 q.aqpa4cco,
                 q.aqpa4caux1,
                 q.aqpa4caux2,
                 q.aqpa4caux3,
                 q.aqpa4caux4,
                 q.aqpa4caux5,
                 q.aqpa4caux6,
                 q.aqpa4caux7,
                 q.aqpa4caosbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha,
                   pn_corr,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FPP001',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FPP001_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP002(pn_pgcod,
                                                        pn_aomod,
                                                        pn_aosuc,
                                                        pn_aomda,
                                                        pn_aopap,
                                                        pn_aocta,
                                                        pn_aooper,
                                                        pn_aosbop,
                                                        pn_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_X054023(pn_pgcod,
                                                         pn_aomod,
                                                         pn_aosuc,
                                                         pn_aomda,
                                                         pn_aopap,
                                                         pn_aocta,
                                                         pn_aooper,
                                                         pn_aosbop,
                                                         pn_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD012(pn_pgcod,
                                                        pn_aomod,
                                                        pn_aosuc,
                                                        pn_aomda,
                                                        pn_aopap,
                                                        pn_aocta,
                                                        pn_aooper,
                                                        pn_aosbop,
                                                        pn_aotope);
      end;
    
    else
    
      -- SI LA SUBOPERACIÓN ES MAYOR A 0  
      begin
        --lc_flag := 'S';
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD601_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD602_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD611_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP001_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP002_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_X054023_a(pn_pgcod,
                                                           pn_aomod,
                                                           pn_aosuc,
                                                           pn_aomda,
                                                           pn_aopap,
                                                           pn_aocta,
                                                           pn_aooper,
                                                           pn_aosbop,
                                                           pn_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD012_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
      end;
    
    end if;
  
  end sp_insertar_detalle_grupo1;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_detalle_grupo2(pn_fecpro     in date,
                                       pn_corr       in number,
                                       pn_fecha_prev in date,
                                       pn_fecha_inst in date,
                                       pn_corr_inst  in number,
                                       
                                       pn_pgcod  in number,
                                       pn_aomod  in number,
                                       pn_aosuc  in number,
                                       pn_aomda  in number,
                                       pn_aopap  in number,
                                       pn_aocta  in number,
                                       pn_aooper in number,
                                       pn_aosbop in number,
                                       pn_aotope in number) is
  
    /*---------------*/
    lc_flag   char(1);
    lc_coderr char(100);
    lc_msgerr char(100);
    lx_cont   number;
    --- grupo 2
    cursor grupo2_jaqz520_601(cr_fecha  date,
                              cr_corr   number,
                              cr_PGCOD  number,
                              cr_PPMOD  number,
                              cr_PPSUC  number,
                              cr_PPMDA  number,
                              cr_PPPAP  number,
                              cr_PPCTA  number,
                              cr_PPOPER number,
                              cr_PPSBOP number,
                              cr_PPTOPE number) is
    
      select *
        from aqpa006 t
       where t.aqpa006fecpro = cr_fecha
         and t.aqpa006cor = cr_corr
         and t.aqpa006cod = cr_PGCOD
         and t.aqpa006mod = cr_PPMOD
         and t.aqpa006suc = cr_PPSUC
         and t.aqpa006mda = cr_PPMDA
         and t.aqpa006pap = cr_PPPAP
         and t.aqpa006cta = cr_PPCTA
         and t.aqpa006oper = cr_PPOPER
         and t.aqpa006sbop = cr_PPSBOP
         and t.aqpa006tope = cr_PPTOPE
       order by t.aqpa006fpag asc;
  
    cursor grupo2_jaqz520_602(cr_fecha  date,
                              cr_corr   number,
                              cr_pgcod  number,
                              cr_aomod  number,
                              cr_aosuc  number,
                              cr_aomda  number,
                              cr_aopap  number,
                              cr_aocta  number,
                              cr_aooper number,
                              cr_aosbop number,
                              cr_aotope number) is
      select *
        from aqpa008 t
       where t.aqpa008fecpro = cr_fecha
         and t.aqpa008cor = cr_corr
         and t.aqpa008cod = cr_pgcod
         and t.aqpa008mod = cr_aomod
         and t.aqpa008suc = cr_aosuc
         and t.aqpa008mda = cr_aomda
         and t.aqpa008pap = cr_aopap
         and t.aqpa008cta = cr_aocta
         and t.aqpa008oper = cr_aooper
         and t.aqpa008sbop = cr_aosbop
         and t.aqpa008tope = cr_aotope
       order by t.aqpa008fpag asc;
  
    cursor grupo2_jaqz520_611(cr_fecha  date,
                              cr_corr   number,
                              cr_pgcod  number,
                              cr_aomod  number,
                              cr_aosuc  number,
                              cr_aomda  number,
                              cr_aopap  number,
                              cr_aocta  number,
                              cr_aooper number,
                              cr_aosbop number,
                              cr_aotope number) is
      select *
        from aqpa007 t
       where t.aqpa007fecpro = cr_fecha
         and t.aqpa007cor = cr_corr
         and t.aqpa007cod = cr_pgcod
         and t.aqpa007mod = cr_aomod
         and t.aqpa007suc = cr_aosuc
         and t.aqpa007mda = cr_aomda
         and t.aqpa007pap = cr_aopap
         and t.aqpa007cta = cr_aocta
         and t.aqpa007oper = cr_aooper
         and t.aqpa007sbop = cr_aosbop
         and t.aqpa007tope = cr_aotope
       order by t.aqpa007fpag asc;
  
    cursor grupo2_jaqz520_fpp001(cr_fecha  date,
                                 cr_corr   number,
                                 cr_pgcod  number,
                                 cr_aomod  number,
                                 cr_aosuc  number,
                                 cr_aomda  number,
                                 cr_aopap  number,
                                 cr_aocta  number,
                                 cr_aooper number,
                                 cr_aosbop number,
                                 cr_aotope number) is
      select *
        from aqpa004c t
       where t.aqpa4cfpro = cr_fecha
         and t.aqpa4ccor = cr_corr
         and t.aqpa4cpgcod = cr_pgcod
         and t.aqpa4caomod = cr_aomod
         and t.aqpa4caosuc = cr_aosuc
         and t.aqpa4caomda = cr_aomda
         and t.aqpa4caopap = cr_aopap
         and t.aqpa4caocta = cr_aocta
         and t.aqpa4caooper = cr_aooper
         and t.aqpa4caosbop = cr_aosbop
         and t.aqpa4caotope = cr_aotope;
  
  begin
  
    if pn_aosbop = 0 then
    
      begin
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa006 t
         where t.aqpa006fecpro = pn_fecpro
           and t.aqpa006cor = pn_corr
           and t.aqpa006cod = pn_pgcod
           and t.aqpa006mod = pn_aomod
           and t.aqpa006suc = pn_aosuc
           and t.aqpa006mda = pn_aomda
           and t.aqpa006pap = pn_aopap
           and t.aqpa006cta = pn_aocta
           and t.aqpa006oper = pn_aooper
           and t.aqpa006sbop = pn_aosbop
           and t.aqpa006tope = pn_aotope;
      
        if lx_cont > 0 then
        
          for k in grupo2_jaqz520_601(pn_fecpro,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
              --Inserción aqpb061
              insert into AQPB061
                (aqpb061pgcod,
                 aqpb061mod,
                 aqpb061suc,
                 aqpb061mda,
                 aqpb061pap,
                 aqpb061cta,
                 aqpb061oper,
                 aqpb061sbop,
                 aqpb061tope,
                 aqpb061fpag,
                 aqpb061tipo,
                 aqpb061fval,
                 aqpb061fvto,
                 aqpb061pzo,
                 aqpb061cap,
                 aqpb061int,
                 aqpb061intmex,
                 aqpb061icap,
                 aqpb061iint,
                 aqpb061stat,
                 aqpb061nume,
                 aqpb061finv,
                 aqpb061cd,
                 aqpb061mo,
                 aqpb061su,
                 aqpb061tr,
                 aqpb061re,
                 aqpb061fc,
                 aqpb061or,
                 aqpb061sb,
                 aqpb061co,
                 aqpb061obop)
              values
                (k.aqpa006cod,
                 k.aqpa006mod,
                 k.aqpa006suc,
                 k.aqpa006mda,
                 k.aqpa006pap,
                 k.aqpa006cta,
                 k.aqpa006oper,
                 k.aqpa006sbop,
                 k.aqpa006tope,
                 k.aqpa006fpag,
                 k.aqpa006tipo,
                 k.aqpa006fval,
                 k.aqpa006fvto,
                 k.aqpa006pzo,
                 k.aqpa006cap,
                 k.aqpa006int,
                 k.aqpa006intmex,
                 k.aqpa006icap,
                 k.aqpa006iint,
                 k.aqpa006stat,
                 k.aqpa006nume,
                 k.aqpa006finv,
                 k.aqpa006cd,
                 k.aqpa006mo,
                 k.aqpa006su,
                 k.aqpa006tr,
                 k.aqpa006re,
                 k.aqpa006fc,
                 k.aqpa006or,
                 k.aqpa006sb,
                 k.aqpa006co,
                 k.aqpa006sbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha_inst,
                   pn_corr_inst,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD601',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD601_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa008 t
         where t.aqpa008fecpro = pn_fecpro
           and t.aqpa008cor = pn_corr
           and t.aqpa008cod = pn_pgcod
           and t.aqpa008mod = pn_aomod
           and t.aqpa008suc = pn_aosuc
           and t.aqpa008mda = pn_aomda
           and t.aqpa008pap = pn_aopap
           and t.aqpa008cta = pn_aocta
           and t.aqpa008oper = pn_aooper
           and t.aqpa008sbop = pn_aosbop
           and t.aqpa008tope = pn_aotope;
      
        if lx_cont > 0 then
        
          for m in grupo2_jaqz520_602(pn_fecpro,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
              insert into AQPB062
                (aqpb062pgcod,
                 aqpb062mod,
                 aqpb062suc,
                 aqpb062mda,
                 aqpb062pap,
                 aqpb062cta,
                 aqpb062oper,
                 aqpb062sbop,
                 aqpb062tope,
                 aqpb062fpag,
                 aqpb062tipo,
                 aqpb062nump,
                 aqpb062fech,
                 aqpb062cap,
                 aqpb062int,
                 aqpb062intmex,
                 aqpb062intm,
                 aqpb062intmmex,
                 aqpb062icap,
                 aqpb062iint,
                 aqpb062iintm,
                 aqpb062salcap,
                 aqpb062salint,
                 aqpb062salade,
                 aqpb062salmor,
                 aqpb062stat,
                 aqpb062salintm,
                 aqpb062salmorm,
                 aqpb062saladem,
                 aqpb062cd,
                 aqpb062mo,
                 aqpb062su,
                 aqpb062tr,
                 aqpb062re,
                 aqpb062fc,
                 aqpb062or,
                 aqpb062sb,
                 aqpb062co,
                 aqpb062obop)
              values
                (m.aqpa008cod,
                 m.aqpa008mod,
                 m.aqpa008suc,
                 m.aqpa008mda,
                 m.aqpa008pap,
                 m.aqpa008cta,
                 m.aqpa008oper,
                 m.aqpa008sbop,
                 m.aqpa008tope,
                 m.aqpa008fpag,
                 m.aqpa008tipo,
                 m.aqpa0081nump,
                 m.aqpa0081fech,
                 m.aqpa0081cap,
                 m.aqpa0081int,
                 m.aqpa0081intmex,
                 m.aqpa0081intm,
                 m.aqpa0081intmmex,
                 m.aqpa0081icap,
                 m.aqpa0081iint,
                 m.aqpa0081iintm,
                 m.aqpa0081salcap,
                 m.aqpa0081salint,
                 m.aqpa0081salade,
                 m.aqpa0081salmor,
                 m.aqpa0081stat,
                 m.aqpa0081salintm,
                 m.aqpa0081salmorm,
                 m.aqpa0081saladem,
                 m.aqpa008cd,
                 m.aqpa008mo,
                 m.aqpa008su,
                 m.aqpa008tr,
                 m.aqpa008re,
                 m.aqpa008fc,
                 m.aqpa008or,
                 m.aqpa008sb,
                 m.aqpa008co,
                 m.aqpa008sbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha_inst,
                   pn_corr_inst,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD602',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD602_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa007 t
         where t.aqpa007fecpro = pn_fecpro
           and t.aqpa007cor = pn_corr
           and t.aqpa007cod = pn_pgcod
           and t.aqpa007mod = pn_aomod
           and t.aqpa007suc = pn_aosuc
           and t.aqpa007mda = pn_aomda
           and t.aqpa007pap = pn_aopap
           and t.aqpa007cta = pn_aocta
           and t.aqpa007oper = pn_aooper
           and t.aqpa007sbop = pn_aosbop
           and t.aqpa007tope = pn_aotope;
      
        if lx_cont > 0 then
        
          for p in grupo2_jaqz520_611(pn_fecpro,
                                      pn_corr,
                                      pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope) loop
            begin
            
              insert into AQPB063
                (aqpb063pgcod,
                 aqpb063mod,
                 aqpb063suc,
                 aqpb063mda,
                 aqpb063pap,
                 aqpb063cta,
                 aqpb063oper,
                 aqpb063sbop,
                 aqpb063tope,
                 aqpb063fpag,
                 aqpb063tipo,
                 aqpb063exte,
                 aqpb063imp1,
                 aqpb063imp2,
                 aqpb063imp3,
                 aqpb063imp4,
                 aqpb063imp5,
                 aqpb063imp6,
                 aqpb063imp7,
                 aqpb063imp8,
                 aqpb063imp9,
                 aqpb063imp10,
                 aqpb063imp11,
                 aqpb063imp12,
                 aqpb063imp13,
                 aqpb063imp14,
                 aqpb063imp15,
                 aqpb063imp16,
                 aqpb063imp17,
                 aqpb063imp18,
                 aqpb063imp19,
                 aqpb063imp20,
                 aqpb063obop)
              values
                (p.aqpa007cod,
                 p.aqpa007mod,
                 p.aqpa007suc,
                 p.aqpa007mda,
                 p.aqpa007pap,
                 p.aqpa007cta,
                 p.aqpa007oper,
                 p.aqpa007sbop,
                 p.aqpa007tope,
                 p.aqpa007fpag,
                 p.aqpa007tipo,
                 p.aqpa007exte,
                 p.aqpa007imp1,
                 p.aqpa007imp2,
                 p.aqpa007imp3,
                 p.aqpa007imp4,
                 p.aqpa007imp5,
                 p.aqpa007imp6,
                 p.aqpa007imp7,
                 p.aqpa007imp8,
                 p.aqpa007imp9,
                 p.aqpa007imp10,
                 p.aqpa007imp11,
                 p.aqpa007imp12,
                 p.aqpa007imp13,
                 p.aqpa007imp14,
                 p.aqpa007imp15,
                 p.aqpa007imp16,
                 p.aqpa007imp17,
                 p.aqpa007imp18,
                 p.aqpa007imp19,
                 p.aqpa007imp20,
                 p.aqpa007sbop);
            exception
              when others then
                --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha_inst,
                   pn_corr_inst,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FSD611',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FSD611_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa004c t
         where t.aqpa4cfpro = pn_fecpro
           and t.aqpa4ccor = pn_corr
           and t.aqpa4cpgcod = pn_pgcod
           and t.aqpa4caomod = pn_aomod
           and t.aqpa4caosuc = pn_aosuc
           and t.aqpa4caomda = pn_aomda
           and t.aqpa4caopap = pn_aopap
           and t.aqpa4caocta = pn_aocta
           and t.aqpa4caooper = pn_aooper
           and t.aqpa4caosbop = pn_aosbop
           and t.aqpa4caotope = pn_aotope;
      
        if lx_cont > 0 then
        
          for q in grupo2_jaqz520_fpp001(pn_fecpro,
                                         pn_corr,
                                         pn_pgcod,
                                         pn_aomod,
                                         pn_aosuc,
                                         pn_aomda,
                                         pn_aopap,
                                         pn_aocta,
                                         pn_aooper,
                                         pn_aosbop,
                                         pn_aotope) loop
            begin
            
              insert into aqpa974
                (aqpa974pgcod,
                 aqpa974mod,
                 aqpa974suc,
                 aqpa974mda,
                 aqpa974pap,
                 aqpa974cta,
                 aqpa974oper,
                 aqpa974sbop,
                 aqpa974tope,
                 aqpa974sgcod,
                 aqpa974vc,
                 aqpa974imp,
                 aqpa974porc,
                 aqpa974plus,
                 aqpa974part,
                 aqpa974veh,
                 aqpa974inm,
                 aqpa974end,
                 aqpa974stat,
                 aqpa974co,
                 aqpa974aux1,
                 aqpa974aux2,
                 aqpa974aux3,
                 aqpa974aux4,
                 aqpa974aux5,
                 aqpa974aux6,
                 aqpa974aux7,
                 aqpa974obop)
              values
                (q.aqpa4cpgcod,
                 q.aqpa4caomod,
                 q.aqpa4caosuc,
                 q.aqpa4caomda,
                 q.aqpa4caopap,
                 q.aqpa4caocta,
                 q.aqpa4caooper,
                 q.aqpa4caosbop,
                 q.aqpa4caotope,
                 q.aqpa4csgcod,
                 --q.aqpa4cfpro,
                 q.aqpa4cvc,
                 q.aqpa4cimp,
                 q.aqpa4cporc,
                 q.aqpa4cplus,
                 q.aqpa4cpart,
                 q.aqpa4cveh,
                 q.aqpa4cinm,
                 q.aqpa4cend,
                 q.aqpa4cstat,
                 q.aqpa4cco,
                 q.aqpa4caux1,
                 q.aqpa4caux2,
                 q.aqpa4caux3,
                 q.aqpa4caux4,
                 q.aqpa4caux5,
                 q.aqpa4caux6,
                 q.aqpa4caux7,
                 q.aqpa4caosbop);
            exception
              when others then
                ---lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm), 1, 90);
              
                insert into aqpb066
                  (aqpb066fep,
                   aqpb066cor,
                   aqpb066emp,
                   aqpb066mod,
                   aqpb066suc,
                   aqpb066mda,
                   aqpb066pap,
                   aqpb066cta,
                   aqpb066ope,
                   aqpb066sbo,
                   aqpb066top,
                   aqpb066tref,
                   aqpb066etip,
                   aqpb066eacoe,
                   aqpb066eamsge)
                values
                  (pn_fecha_inst,
                   pn_corr_inst,
                   pn_pgcod,
                   pn_aomod,
                   pn_aosuc,
                   pn_aomda,
                   pn_aopap,
                   pn_aocta,
                   pn_aooper,
                   pn_aosbop,
                   pn_aotope,
                   'FPP001',
                   'S',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_masivo.sp_insertar_FPP001_b(pn_pgcod,
                                                            pn_aomod,
                                                            pn_aosuc,
                                                            pn_aomda,
                                                            pn_aopap,
                                                            pn_aocta,
                                                            pn_aooper,
                                                            pn_aosbop,
                                                            pn_aotope);
        
        end if;
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP002(pn_pgcod,
                                                        pn_aomod,
                                                        pn_aosuc,
                                                        pn_aomda,
                                                        pn_aopap,
                                                        pn_aocta,
                                                        pn_aooper,
                                                        pn_aosbop,
                                                        pn_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_X054023(pn_pgcod,
                                                         pn_aomod,
                                                         pn_aosuc,
                                                         pn_aomda,
                                                         pn_aopap,
                                                         pn_aocta,
                                                         pn_aooper,
                                                         pn_aosbop,
                                                         pn_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD012(pn_pgcod,
                                                        pn_aomod,
                                                        pn_aosuc,
                                                        pn_aomda,
                                                        pn_aopap,
                                                        pn_aocta,
                                                        pn_aooper,
                                                        pn_aosbop,
                                                        pn_aotope);
      
      end;
    
    else
    
      -- SI LA SUBOPERACIÓN ES MAYOR A 0  
      begin
      
        --lc_flag := 'N';                   
      
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD601_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD602_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD611_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP001_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FPP002_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_X054023_a(pn_pgcod,
                                                           pn_aomod,
                                                           pn_aosuc,
                                                           pn_aomda,
                                                           pn_aopap,
                                                           pn_aocta,
                                                           pn_aooper,
                                                           pn_aosbop,
                                                           pn_aotope);
      
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_masivo.sp_insertar_FSD012_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
      
      end;
    
    end if;
  
  end sp_insertar_detalle_grupo2;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_JAQZ520_010(pn_fecha      in date,
                                    pn_corr       in number,
                                    pn_inst       in number,
                                    pn_fecha_prev in date,
                                    
                                    pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number,
                                    
                                    pn_feca in date,
                                    pn_revr in char) is
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
  
    lx_scsdo number(17, 2);
  
    lx_orden number;
    lx_flac  char;
  
  begin
  
    begin
    
      /****************************/
      begin
        select nvl(max(x.aqpb064orden), 0) + 1
          into lx_orden
          from aqpb064 x
         where x.aqpb064pgcod = pn_pgcod
           and x.aqpb064aomod = pn_aomod
           and
              --x.aqpb064aosuc = pn_aosuc and
               x.aqpb064aomda = pn_aomda
           and x.aqpb064aopap = pn_aopap
           and x.aqpb064aocta = pn_aocta
           and x.aqpb064aooper = pn_aooper --and
        --x.aqpb064aosbop = pn_aosbop and
        --x.aqpb064aotope = pn_aotope
        ;
      exception
        when others then
          lx_orden := 1;
      end;
    
      /****************************/
    
      lx_frepro  := pn_fecha;
      lx_ncorre  := pn_corr;
      lx_proceso := 'R'; ---REPROGRAMADO
      lx_fcierre := pn_fecha_prev;
      lx_instanc := pn_inst;
      --lx_estado := 'R';
      --lx_fecest := pn_fecha;
    
      if (pn_revr = 'S') then
        --lx_estado := 'X';
        lx_fecest := pn_feca;
      else
        --lx_estado := 'R';
        lx_fecest := pn_fecha;
      end if;
    
      lx_estado := 'C';
    
      /****************************/
    
      select nvl(sum(r.scsdo), 0)
        into lx_scsdo
        from jaqz520_011 r
       where r.pgcod = pn_pgcod
         and r.scsuc = pn_aosuc
         and r.scmda = pn_aomda
         and r.scpap = pn_aopap
         and r.sccta = pn_aocta
         and r.scoper = pn_aooper
         and r.scsbop = pn_aosbop
         and r.sctope = pn_aotope
         and r.scmod = pn_aomod;
    
      /*-------------------------*/
      insert into AQPB064
        (aqpb064frepro,
         aqpb064ncorre,
         aqpb064pgcod,
         aqpb064aomod,
         aqpb064aosuc,
         aqpb064aomda,
         aqpb064aopap,
         aqpb064aocta,
         aqpb064aooper,
         aqpb064aosbop,
         aqpb064aotope,
         aqpb064aofval,
         aqpb064aofvto,
         aqpb064aopzo,
         aqpb064aotasa,
         aqpb064aoimp,
         --aqpb064aomd,
         aqpb064aostat,
         aqpb064aofe99,
         aqpb064aoperiod,
         aqpb064proceso,
         aqpb064fcierre,
         aqpb064instanc,
         aqpb064estado,
         aqpb064fecest,
         --aqpb064diaatr,
         --aqpb064diagra,
         --aqpb064fepvep,
         aqpb064scsdo,
         --aqpb064freproref,
         --aqpb064ncorreref,
         aqpb064tablaref,
         aqpb064orden)
        select lx_frepro,
               lx_ncorre,
               q.pgcod, --lx_pgcod,
               q.aomod, --lx_aomod,
               q.aosuc, --lx_aosuc,
               q.aomda, --lx_aomda,
               q.aopap, --lx_aopap,
               q.aocta, --lx_aocta,
               q.aooper, --lx_aooper,
               q.aosbop, --lx_aosbop,
               q.aotope, --lx_aotope,
               
               q.aofval, --lx_aofval,
               q.aofvto, --lx_aofvto
               q.aopzo, --lx_aopzo
               q.aotasa, --lx_aotasa
               q.aoimp, --lx_aoimp
               q.aostat, --lx_aostat
               q.aofe99, --lx_aofe99
               q.aoperiod, --lx_aoperiod
               
               lx_proceso,
               lx_fcierre,
               lx_instanc,
               lx_estado,
               lx_fecest,
               lx_scsdo,
               'AQPB002',
               lx_orden
          from jaqz520_010 q
         where q.pgcod = pn_pgcod
           and q.aomod = pn_aomod
           and q.aosuc = pn_aosuc
           and q.aomda = pn_aomda
           and q.aopap = pn_aopap
           and q.aocta = pn_aocta
           and q.aooper = pn_aooper
           and q.aosbop = pn_aosbop
           and q.aotope = pn_aotope;
    
      commit;
    
      if lx_orden = 1 then
      
        ---Insertar aqpb009
        insert into aqpb009
          (aqpb009fep,
           aqpb009cor,
           aqpb009emp,
           aqpb009mod,
           aqpb009suc,
           aqpb009mda,
           aqpb009pap,
           aqpb009cta,
           aqpb009ope,
           aqpb009sbo,
           aqpb009top,
           aqpb009est,
           aqpb009sdo,
           --aqpb009tea1,
           --aqpb009tea2,
           --aqpb009tcea1,
           --aqpb009tcea2,
           aqpb009usr,
           aqpb009hoi,
           aqpb009hof,
           aqpb009narc,
           aqpb009ins,
           aqpb009fmail,
           aqpb009mail,
           aqpb009ase,
           aqpb009tpo,
           aqpb009estcr,
           aqpb009rub,
           aqpb009tref)
          select t.aqpb002fep,
                 t.aqpb002cor,
                 t.aqpb002emp,
                 t.aqpb002mod,
                 t.aqpb002suc,
                 t.aqpb002mda,
                 t.aqpb002pap,
                 t.aqpb002cta,
                 t.aqpb002ope,
                 t.aqpb002sbo,
                 t.aqpb002top,
                 lx_estado, --t.aqpb002est,
                 lx_scsdo,
                 t.aqpb002usrr,
                 t.aqpb002hoi,
                 t.aqpb002hof,
                 t.aqpb002narc,
                 lx_instanc,
                 t.aqpb002fmail,
                 t.aqpb002mail,
                 t.aqpb002ase,
                 t.aqpb002tipo,
                 t.aqpb002estcr,
                 t.aqpb002rub,
                 'AQPB002'
            from aqpb002 t
           where t.aqpb002fep = pn_fecha
             and t.aqpb002cor = pn_corr
             and t.aqpb002emp = pn_pgcod
             and t.aqpb002mod = pn_aomod
             and t.aqpb002suc = pn_aosuc
             and t.aqpb002mda = pn_aomda
             and t.aqpb002pap = pn_aopap
             and t.aqpb002cta = pn_aocta
             and t.aqpb002ope = pn_aooper
             and t.aqpb002sbo = pn_aosbop
             and t.aqpb002top = pn_aotope;
        commit;
      
        /*-------------------------*/
        ---Detalle GRUPO1
        /*-------------------------*/
        pq_cr_historico_pagos_masivo.sp_insertar_detalle_grupo1(pn_fecha, --lx_frepro,
                                                                pn_corr, --lx_ncorre,
                                                                pn_fecha_prev,
                                                                
                                                                pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
      
      end if;
    
      ---2. Fin
    exception
      when others then
        lx_flac := 'N';
    end;
  
  end sp_insertar_JAQZ520_010;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPA004(pn_fecha      in date,
                                pn_corr       in number,
                                pn_inst       in number,
                                pn_fecha_prev in date,
                                pn_fecha_inst in date,
                                pn_corr_inst  in number,
                                pn_feca       in date,
                                pn_revr       in char,
                                
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number) is
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
  
    lx_scsdo number(17, 2);
    lx_orden number;
    lx_flac  char(1);
  
  begin
  
    begin
      ---1. Inicio
    
      /****************************/
      begin
        select nvl(max(x.aqpb064orden), 0) + 1
          into lx_orden
          from aqpb064 x
         where x.aqpb064pgcod = pn_pgcod
           and x.aqpb064aomod = pn_aomod
           and
              --x.aqpb064aosuc = pn_aosuc and
               x.aqpb064aomda = pn_aomda
           and x.aqpb064aopap = pn_aopap
           and x.aqpb064aocta = pn_aocta
           and x.aqpb064aooper = pn_aooper --and
        ---x.aqpb064aosbop = pn_aosbop and
        --x.aqpb064aotope = pn_aotope
        ;
      exception
        when others then
          lx_orden := 1;
      end;
    
      /****************************/
    
      lx_frepro  := pn_fecha_inst;
      lx_ncorre  := pn_corr_inst;
      lx_proceso := 'R'; ---REPROGRAMADO
      lx_fcierre := pn_fecha_prev;
      lx_instanc := pn_inst;
    
      if (pn_revr = 'S') then
        --lx_estado := 'X';
        lx_fecest := pn_feca;
      else
        --lx_estado := 'R';
        lx_fecest := pn_fecha;
      end if;
    
      lx_estado := 'C';
    
      /****************************/
    
      select nvl(sum(r.aqpa005sdo), 0)
        into lx_scsdo
        from AQPA005 r
       where r.aqpa005fecpro = pn_fecha
         and r.aqpa005cor = pn_corr;
    
      /*-------------------------*/
      insert into AQPB064
        (aqpb064frepro,
         aqpb064ncorre,
         aqpb064pgcod,
         aqpb064aomod,
         aqpb064aosuc,
         aqpb064aomda,
         aqpb064aopap,
         aqpb064aocta,
         aqpb064aooper,
         aqpb064aosbop,
         aqpb064aotope,
         aqpb064aofval,
         aqpb064aofvto,
         aqpb064aopzo,
         aqpb064aotasa,
         aqpb064aoimp,
         --aqpb064aomd,
         aqpb064aostat,
         aqpb064aofe99,
         aqpb064aoperiod,
         aqpb064proceso,
         aqpb064fcierre,
         aqpb064instanc,
         aqpb064estado,
         aqpb064fecest,
         aqpb064scsdo,
         aqpb064tablaref,
         aqpb064orden)
        select lx_frepro,
               lx_ncorre,
               q.aqpa004cod, --lx_pgcod,
               q.aqpa004mod, --lx_aomod,
               q.aqpa004suc, --lx_aosuc,
               q.aqpa004mda, --lx_aomda,
               q.aqpa004pap, --lx_aopap,
               q.aqpa004cta, --lx_aocta,
               q.aqpa004oper, --lx_aooper,
               q.aqpa004sbop, --lx_aosbop,
               q.aqpa004tope, --lx_aotope,
               q.aqpa004fval, --lx_aofval,
               q.aqpa004fvto, --lx_aofvto
               
               q.aqpa004pzo, --lx_aopzo
               q.aqpa004tasa, --lx_aotasa
               q.aqpa004imp, --lx_aoimp
               q.aqpa004stat, --lx_aostat
               q.aqpa004fe99, --lx_aofe99
               q.aqpa004period, --lx_aoperiod
               lx_proceso,
               lx_fcierre,
               lx_instanc,
               lx_estado,
               lx_fecest,
               lx_scsdo,
               'AQPB002',
               lx_orden
          from AQPA004 q
         where q.aqpa004fecpro = pn_fecha
           and q.aqpa004cor = pn_corr
           and q.aqpa004cod = pn_pgcod
           and q.aqpa004mod = pn_aomod
           and q.aqpa004suc = pn_aosuc
           and q.aqpa004mda = pn_aomda
           and q.aqpa004pap = pn_aopap
           and q.aqpa004cta = pn_aocta
           and q.aqpa004oper = pn_aooper
           and q.aqpa004sbop = pn_aosbop
           and q.aqpa004tope = pn_aotope;
      commit;
    
      if lx_orden = 1 then
      
        ---Insertar aqpb009
        insert into aqpb009
          (aqpb009fep,
           aqpb009cor,
           aqpb009emp,
           aqpb009mod,
           aqpb009suc,
           aqpb009mda,
           aqpb009pap,
           aqpb009cta,
           aqpb009ope,
           aqpb009sbo,
           aqpb009top,
           aqpb009est,
           aqpb009sdo,
           --aqpb009tea1,
           --aqpb009tea2,
           --aqpb009tcea1,
           --aqpb009tcea2,
           aqpb009usr,
           aqpb009hoi,
           aqpb009hof,
           aqpb009narc,
           aqpb009ins,
           aqpb009fmail,
           aqpb009mail,
           aqpb009ase,
           aqpb009tpo,
           aqpb009estcr,
           aqpb009rub,
           aqpb009tref)
          select t.aqpb002fep,
                 t.aqpb002cor,
                 t.aqpb002emp,
                 t.aqpb002mod,
                 t.aqpb002suc,
                 t.aqpb002mda,
                 t.aqpb002pap,
                 t.aqpb002cta,
                 t.aqpb002ope,
                 t.aqpb002sbo,
                 t.aqpb002top,
                 lx_estado, --t.aqpb002est,
                 lx_scsdo,
                 t.aqpb002usrr,
                 t.aqpb002hoi,
                 t.aqpb002hof,
                 t.aqpb002narc,
                 lx_instanc,
                 t.aqpb002fmail,
                 t.aqpb002mail,
                 t.aqpb002ase,
                 t.aqpb002tipo,
                 t.aqpb002estcr,
                 t.aqpb002rub,
                 'AQPB002'
            from aqpb002 t
           where
          --t.aqpb002fep = pn_fecha and
          --t.aqpb002cor = pn_corr and
           t.aqpb002fep = lx_frepro
           and t.aqpb002cor = lx_ncorre
           and t.aqpb002emp = pn_pgcod
           and t.aqpb002mod = pn_aomod
           and t.aqpb002suc = pn_aosuc
           and t.aqpb002mda = pn_aomda
           and t.aqpb002pap = pn_aopap
           and t.aqpb002cta = pn_aocta
           and t.aqpb002ope = pn_aooper
           and t.aqpb002sbo = pn_aosbop
           and t.aqpb002top = pn_aotope;
        commit;
        ---Detalle
        /*-------------------------*/
        pq_cr_historico_pagos_masivo.sp_insertar_detalle_grupo2(pn_fecha, --lx_frepro,
                                                                pn_corr, --lx_ncorre,
                                                                pn_fecha_prev,
                                                                pn_fecha_inst,
                                                                pn_corr_inst,
                                                                pn_pgcod,
                                                                pn_aomod,
                                                                pn_aosuc,
                                                                pn_aomda,
                                                                pn_aopap,
                                                                pn_aocta,
                                                                pn_aooper,
                                                                pn_aosbop,
                                                                pn_aotope);
      
      end if;
    
      ---1. Fin
    exception
      when others then
        lx_flac := 'N';
    end;
  
  end sp_insertar_AQPA004;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FPP002(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fpp002c(cr_pgcod  number,
                           cr_aomod  number,
                           cr_aosuc  number,
                           cr_aomda  number,
                           cr_aopap  number,
                           cr_aocta  number,
                           cr_aooper number,
                           cr_aosbop number,
                           cr_aotope number) is
      select *
        from FPP002 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for r in jaqz520_fpp002c(pn_pgcod,
                             pn_aomod,
                             pn_aosuc,
                             pn_aomda,
                             pn_aopap,
                             pn_aocta,
                             pn_aooper,
                             0, --pn_aosbop,
                             pn_aotope) loop
      begin
      
        insert into aqpa973
          (aqpa973cod,
           aqpa973mod,
           aqpa973suc,
           aqpa973mda,
           aqpa973pap,
           aqpa973cta,
           aqpa973oper,
           aqpa973sbop,
           aqpa973tope,
           aqpa973fpag,
           aqpa973tipo,
           aqpa973estconc,
           aqpa973imp,
           aqpa973stat,
           aqpa973aux1,
           aqpa973aux2,
           aqpa973aux3,
           aqpa973obop)
        values
          (r.pgcod,
           r.ppmod,
           r.ppsuc,
           r.ppmda,
           r.pppap,
           r.ppcta,
           r.ppoper,
           pn_aosbop, --r.ppsbop,
           r.pptope,
           r.ppfpag,
           r.pptipo,
           r.prestconc,
           r.pp002imp,
           r.pp002stat,
           r.pp002aux1,
           r.pp002aux2,
           r.pp002aux3,
           r.ppsbop);
      exception
        when others then
          -- lc_flag := 'N';
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             100,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FPP002',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FPP002;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_X054023(pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL   
    cursor jaqz520_x054023c(cr_pgcod  number,
                            cr_aomod  number,
                            cr_aosuc  number,
                            cr_aomda  number,
                            cr_aopap  number,
                            cr_aocta  number,
                            cr_aooper number,
                            cr_aosbop number,
                            cr_aotope number) is
      select *
        from X054023 t
       where t.xllpgcod = cr_pgcod
         and t.xllaomod = cr_aomod
         and t.xllaosuc = cr_aosuc
         and t.xllaomda = cr_aomda
         and t.xllaopap = cr_aopap
         and t.xllaocta = cr_aocta
         and t.xllaooper = cr_aooper
         and t.xllaosbop = cr_aosbop
         and t.xllaotop = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for s in jaqz520_x054023c(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop,
                              pn_aotope) loop
      begin
      
        insert into aqpb060
          (aqpb060pgcod,
           aqpb060aomod,
           aqpb060aosuc,
           aqpb060aomda,
           aqpb060aopap,
           aqpb060aocta,
           aqpb060aooper,
           aqpb060aosbop,
           aqpb060aotop,
           aqpb060fvalor,
           aqpb060capital,
           aqpb060fprimpa,
           aqpb060cantcuo,
           aqpb060periodo,
           aqpb060tipopre,
           aqpb060tipodia,
           aqpb060tipotas,
           aqpb060tasap,
           aqpb060gradper,
           aqpb060gradpor,
           aqpb060gradimp,
           aqpb060tipoano,
           aqpb060tipdiap,
           aqpb060pcltcod,
           aqpb060pclplus,
           aqpb060pcldrev,
           aqpb060tferp,
           aqpb060cntcuoi,
           aqpb060fpripag,
           aqpb060plazo,
           aqpb060fvto,
           aqpb060modocal,
           aqpb060gracfij,
           aqpb060ciud,
           aqpb060capliq,
           aqpb060medico,
           aqpb060financ,
           aqpb060tasaej,
           aqpb060valcan,
           aqpb060valcuo,
           aqpb060capfin,
           aqpb060impu,
           aqpb060aux1,
           aqpb060aux2,
           aqpb060aux3,
           aqpb060aux4,
           aqpb060aux5,
           aqpb060redon,
           aqpb060aux6,
           aqpb060precio,
           aqpb060aoobop)
        values
          (s.xllpgcod,
           s.xllaomod,
           s.xllaosuc,
           s.xllaomda,
           s.xllaopap,
           s.xllaocta,
           s.xllaooper,
           pn_aosbop, --s.xllaosbop,
           s.xllaotop,
           s.xllfvalor,
           s.xllcapital,
           s.xllfprimpa,
           s.xllcantcuo,
           s.xllperiodo,
           s.xlltipopre,
           s.xlltipodia,
           s.xlltipotas,
           s.xlltasap,
           s.xllgradper,
           s.xllgradpor,
           s.xllgradimp,
           s.xlltipoano,
           s.xlltipdiap,
           s.xllpcltcod,
           s.xllpclplus,
           s.xllpcldrev,
           s.xlltferp,
           s.xllcntcuoi,
           s.xllfpripag,
           s.xllplazo,
           s.xllfvto,
           s.xllmodocal,
           s.xllgracfij,
           s.xllciud,
           s.xllcapliq,
           s.xllmedico,
           s.xllfinanc,
           s.xlltasaej,
           s.xllvalcan,
           s.xllvalcuo,
           s.xllcapfin,
           s.xllimpu,
           s.xllaux1,
           s.xllaux2,
           s.xllaux3,
           s.xllaux4,
           s.xllaux5,
           s.xllredon,
           s.xllaux6,
           s.xllprecio,
           s.xllaosbop);
      exception
        when others then
          -- lc_flag := 'N';
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             101,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'X054023',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_X054023;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FSD012(pn_pgcod  in number,
                               pn_aomod  in number,
                               pn_aosuc  in number,
                               pn_aomda  in number,
                               pn_aopap  in number,
                               pn_aocta  in number,
                               pn_aooper in number,
                               pn_aosbop in number,
                               pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL: FSD012   
    cursor jaqz520_012c(cr_pgcod  number,
                        cr_aomod  number,
                        cr_aosuc  number,
                        cr_aomda  number,
                        cr_aopap  number,
                        cr_aocta  number,
                        cr_aooper number,
                        cr_aosbop number,
                        cr_aotope number) is
      select *
        from FSD012 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for u in jaqz520_012c(pn_pgcod,
                          pn_aomod,
                          pn_aosuc,
                          pn_aomda,
                          pn_aopap,
                          pn_aocta,
                          pn_aooper,
                          0, --pn_aosbop,
                          pn_aotope) loop
      begin
      
        insert into AQPA975
          (aqpa975cod,
           aqpa975mod,
           aqpa975suc,
           aqpa975mda,
           aqpa975pap,
           aqpa975cta,
           aqpa975oper,
           aqpa975sbop,
           aqpa975tope,
           aqpa975corr,
           aqpa975tipo,
           aqpa975fval,
           aqpa975fvto,
           aqpa975imp,
           aqpa975ttas,
           aqpa975tasa,
           aqpa975cap,
           aqpa975int,
           aqpa975mor,
           aqpa975scap,
           aqpa975sint,
           aqpa975smor,
           aqpa975intc,
           aqpa975morc,
           aqpa975cd01,
           aqpa975cd02,
           aqpa975inv,
           aqpa975per,
           aqpa975tcbi,
           aqpa975tcbi1,
           aqpa975arb,
           aqpa975arb1,
           aqpa975md,
           aqpa975md1,
           aqpa975pre,
           aqpa975pre1,
           aqpa975cd,
           aqpa975mo,
           aqpa975su,
           aqpa975tr,
           aqpa975re,
           aqpa975fc,
           aqpa975or,
           aqpa975sb,
           aqpa975co,
           aqpa975obop)
        values
          (u.pgcod,
           u.aomod,
           u.aosuc,
           u.aomda,
           u.aopap,
           u.aocta,
           u.aooper,
           pn_aosbop, --u.aosbop,
           u.aotope,
           u.evcorr,
           u.evtipo,
           u.evfval,
           u.evfvto,
           u.evimp,
           u.evttas,
           u.evtasa,
           u.evcap,
           u.evint,
           u.evmor,
           u.evscap,
           u.evsint,
           u.evsmor,
           u.evintc,
           u.evmorc,
           u.evcd01,
           u.evcd02,
           u.evinv,
           u.evper,
           u.evtcbi,
           u.evtcbi1,
           u.evarb,
           u.evarb1,
           u.evmd,
           u.evmd1,
           u.evpre,
           u.evpre1,
           u.d012cd,
           u.d012mo,
           u.d012su,
           u.d012tr,
           u.d012re,
           u.d012fc,
           u.d012or,
           u.d012sb,
           u.d012co,
           u.aosbop);
      exception
        when others then
          --lc_flag := 'N';
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             102,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FSD012',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FSD012;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FSD601_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd601(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD601 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD601 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for k in jaqz520_fsd601(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop, 
                              pn_aotope) loop
        begin
          --Inserción aqpb061
          insert into AQPB061
            (aqpb061pgcod,
             aqpb061mod,
             aqpb061suc,
             aqpb061mda,
             aqpb061pap,
             aqpb061cta,
             aqpb061oper,
             aqpb061sbop,
             aqpb061tope,
             aqpb061fpag,
             aqpb061tipo,
             aqpb061fval,
             aqpb061fvto,
             aqpb061pzo,
             aqpb061cap,
             aqpb061int,
             aqpb061intmex,
             aqpb061icap,
             aqpb061iint,
             aqpb061stat,
             aqpb061nume,
             aqpb061finv,
             aqpb061cd,
             aqpb061mo,
             aqpb061su,
             aqpb061tr,
             aqpb061re,
             aqpb061fc,
             aqpb061or,
             aqpb061sb,
             aqpb061co,
             aqpb061obop)
          
          values
            (k.pgcod,
             k.ppmod,
             k.ppsuc,
             k.ppmda,
             k.pppap,
             k.ppcta,
             k.ppoper,
             pn_aosbop, --k.ppsbop,
             k.pptope,
             k.ppfpag,
             k.pptipo,
             k.ppfval,
             k.ppfvto,
             k.pppzo,
             k.ppcap,
             k.ppint,
             k.ppintmex,
             k.ppicap,
             k.ppiint,
             k.ppstat,
             k.ppnume,
             k.ppfinv,
             k.d601cd,
             k.d601mo,
             k.d601su,
             k.d601tr,
             k.d601re,
             k.d601fc,
             k.d601or,
             k.d601sb,
             k.d601co,
             k.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               103,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD601_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for k in jaqz520_fsd601(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
          --Inserción aqpb061
          insert into AQPB061
            (aqpb061pgcod,
             aqpb061mod,
             aqpb061suc,
             aqpb061mda,
             aqpb061pap,
             aqpb061cta,
             aqpb061oper,
             aqpb061sbop,
             aqpb061tope,
             aqpb061fpag,
             aqpb061tipo,
             aqpb061fval,
             aqpb061fvto,
             aqpb061pzo,
             aqpb061cap,
             aqpb061int,
             aqpb061intmex,
             aqpb061icap,
             aqpb061iint,
             aqpb061stat,
             aqpb061nume,
             aqpb061finv,
             aqpb061cd,
             aqpb061mo,
             aqpb061su,
             aqpb061tr,
             aqpb061re,
             aqpb061fc,
             aqpb061or,
             aqpb061sb,
             aqpb061co,
             aqpb061obop)
          
          values
            (k.pgcod,
             k.ppmod,
             k.ppsuc,
             k.ppmda,
             k.pppap,
             k.ppcta,
             k.ppoper,
             pn_aosbop, --k.ppsbop,
             k.pptope,
             k.ppfpag,
             k.pptipo,
             k.ppfval,
             k.ppfvto,
             k.pppzo,
             k.ppcap,
             k.ppint,
             k.ppintmex,
             k.ppicap,
             k.ppiint,
             k.ppstat,
             k.ppnume,
             k.ppfinv,
             k.d601cd,
             k.d601mo,
             k.d601su,
             k.d601tr,
             k.d601re,
             k.d601fc,
             k.d601or,
             k.d601sb,
             k.d601co,
             k.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               103,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD601_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD601_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        

  PROCEDURE sp_insertar_FSD602_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd602(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD602 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD602 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for m in jaqz520_fsd602(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
          insert into AQPB062
            (aqpb062pgcod,
             aqpb062mod,
             aqpb062suc,
             aqpb062mda,
             aqpb062pap,
             aqpb062cta,
             aqpb062oper,
             aqpb062sbop,
             aqpb062tope,
             aqpb062fpag,
             aqpb062tipo,
             aqpb062nump,
             aqpb062fech,
             aqpb062cap,
             aqpb062int,
             aqpb062intmex,
             aqpb062intm,
             aqpb062intmmex,
             aqpb062icap,
             aqpb062iint,
             aqpb062iintm,
             aqpb062salcap,
             aqpb062salint,
             aqpb062salade,
             aqpb062salmor,
             aqpb062stat,
             aqpb062salintm,
             aqpb062salmorm,
             aqpb062saladem,
             aqpb062cd,
             aqpb062mo,
             aqpb062su,
             aqpb062tr,
             aqpb062re,
             aqpb062fc,
             aqpb062or,
             aqpb062sb,
             aqpb062co,
             aqpb062obop)
          values
            (m.pgcod,
             m.ppmod,
             m.ppsuc,
             m.ppmda,
             m.pppap,
             m.ppcta,
             m.ppoper,
             pn_aosbop, --m.ppsbop,
             m.pptope,
             m.ppfpag,
             m.pptipo,
             m.pp1nump,
             m.pp1fech,
             m.pp1cap,
             m.pp1int,
             m.pp1intmex,
             m.pp1intm,
             m.pp1intmmex,
             m.pp1icap,
             m.pp1iint,
             m.pp1iintm,
             m.pp1salcap,
             m.pp1salint,
             m.pp1salade,
             m.pp1salmor,
             m.pp1stat,
             m.pp1salintm,
             m.pp1salmorm,
             m.pp1saladem,
             m.d602cd,
             m.d602mo,
             m.d602su,
             m.d602tr,
             m.d602re,
             m.d602fc,
             m.d602or,
             m.d602sb,
             m.d602co,
             m.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               104,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD602_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for m in jaqz520_fsd602(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
          insert into AQPB062
            (aqpb062pgcod,
             aqpb062mod,
             aqpb062suc,
             aqpb062mda,
             aqpb062pap,
             aqpb062cta,
             aqpb062oper,
             aqpb062sbop,
             aqpb062tope,
             aqpb062fpag,
             aqpb062tipo,
             aqpb062nump,
             aqpb062fech,
             aqpb062cap,
             aqpb062int,
             aqpb062intmex,
             aqpb062intm,
             aqpb062intmmex,
             aqpb062icap,
             aqpb062iint,
             aqpb062iintm,
             aqpb062salcap,
             aqpb062salint,
             aqpb062salade,
             aqpb062salmor,
             aqpb062stat,
             aqpb062salintm,
             aqpb062salmorm,
             aqpb062saladem,
             aqpb062cd,
             aqpb062mo,
             aqpb062su,
             aqpb062tr,
             aqpb062re,
             aqpb062fc,
             aqpb062or,
             aqpb062sb,
             aqpb062co,
             aqpb062obop)
          values
            (m.pgcod,
             m.ppmod,
             m.ppsuc,
             m.ppmda,
             m.pppap,
             m.ppcta,
             m.ppoper,
             pn_aosbop, --m.ppsbop,
             m.pptope,
             m.ppfpag,
             m.pptipo,
             m.pp1nump,
             m.pp1fech,
             m.pp1cap,
             m.pp1int,
             m.pp1intmex,
             m.pp1intm,
             m.pp1intmmex,
             m.pp1icap,
             m.pp1iint,
             m.pp1iintm,
             m.pp1salcap,
             m.pp1salint,
             m.pp1salade,
             m.pp1salmor,
             m.pp1stat,
             m.pp1salintm,
             m.pp1salmorm,
             m.pp1saladem,
             m.d602cd,
             m.d602mo,
             m.d602su,
             m.d602tr,
             m.d602re,
             m.d602fc,
             m.d602or,
             m.d602sb,
             m.d602co,
             m.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               104,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD602_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD602_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FSD611_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd611(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD611 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD611 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop and
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for p in jaqz520_fsd611(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into AQPB063
            (aqpb063pgcod,
             aqpb063mod,
             aqpb063suc,
             aqpb063mda,
             aqpb063pap,
             aqpb063cta,
             aqpb063oper,
             aqpb063sbop,
             aqpb063tope,
             aqpb063fpag,
             aqpb063tipo,
             aqpb063exte,
             aqpb063imp1,
             aqpb063imp2,
             aqpb063imp3,
             aqpb063imp4,
             aqpb063imp5,
             aqpb063imp6,
             aqpb063imp7,
             aqpb063imp8,
             aqpb063imp9,
             aqpb063imp10,
             aqpb063imp11,
             aqpb063imp12,
             aqpb063imp13,
             aqpb063imp14,
             aqpb063imp15,
             aqpb063imp16,
             aqpb063imp17,
             aqpb063imp18,
             aqpb063imp19,
             aqpb063imp20,
             aqpb063obop)
          values
            (p.pgcod,
             p.ppmod,
             p.ppsuc,
             p.ppmda,
             p.pppap,
             p.ppcta,
             p.ppoper,
             pn_aosbop, -- p.ppsbop,
             p.pptope,
             p.ppfpag,
             p.pptipo,
             p.ppexte,
             p.ppimp1,
             p.ppimp2,
             p.ppimp3,
             p.ppimp4,
             p.ppimp5,
             p.ppimp6,
             p.ppimp7,
             p.ppimp8,
             p.ppimp9,
             p.ppimp10,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15,
             p.ppimp16,
             p.ppimp17,
             p.ppimp18,
             p.ppimp19,
             p.ppimp20,
             p.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               105,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD611_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for p in jaqz520_fsd611(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPB063
            (aqpb063pgcod,
             aqpb063mod,
             aqpb063suc,
             aqpb063mda,
             aqpb063pap,
             aqpb063cta,
             aqpb063oper,
             aqpb063sbop,
             aqpb063tope,
             aqpb063fpag,
             aqpb063tipo,
             aqpb063exte,
             aqpb063imp1,
             aqpb063imp2,
             aqpb063imp3,
             aqpb063imp4,
             aqpb063imp5,
             aqpb063imp6,
             aqpb063imp7,
             aqpb063imp8,
             aqpb063imp9,
             aqpb063imp10,
             aqpb063imp11,
             aqpb063imp12,
             aqpb063imp13,
             aqpb063imp14,
             aqpb063imp15,
             aqpb063imp16,
             aqpb063imp17,
             aqpb063imp18,
             aqpb063imp19,
             aqpb063imp20,
             aqpb063obop)
          values
            (p.pgcod,
             p.ppmod,
             p.ppsuc,
             p.ppmda,
             p.pppap,
             p.ppcta,
             p.ppoper,
             pn_aosbop, -- p.ppsbop,
             p.pptope,
             p.ppfpag,
             p.pptipo,
             p.ppexte,
             p.ppimp1,
             p.ppimp2,
             p.ppimp3,
             p.ppimp4,
             p.ppimp5,
             p.ppimp6,
             p.ppimp7,
             p.ppimp8,
             p.ppimp9,
             p.ppimp10,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15,
             p.ppimp16,
             p.ppimp17,
             p.ppimp18,
             p.ppimp19,
             p.ppimp20,
             p.ppsbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               105,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD611_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD611_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FPP001_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL           
    cursor jaqz520_fpp001(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP001 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FPP001 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aosuc = pn_aosuc
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
       and t.aosbop = 0 --pn_aosbop and
       and t.aotope = pn_aotope;
  
    if lx_cont > 0 then
    
      for q in jaqz520_fpp001(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into aqpa974
            (aqpa974pgcod,
             aqpa974mod,
             aqpa974suc,
             aqpa974mda,
             aqpa974pap,
             aqpa974cta,
             aqpa974oper,
             aqpa974sbop,
             aqpa974tope,
             aqpa974sgcod,
             aqpa974vc,
             aqpa974imp,
             aqpa974porc,
             aqpa974plus,
             aqpa974part,
             aqpa974veh,
             aqpa974inm,
             aqpa974end,
             aqpa974stat,
             aqpa974co,
             aqpa974aux1,
             aqpa974aux2,
             aqpa974aux3,
             aqpa974aux4,
             aqpa974aux5,
             aqpa974aux6,
             aqpa974aux7,
             aqpa974obop)
          values
            (q.pgcod,
             q.aomod,
             q.aosuc,
             q.aomda,
             q.aopap,
             q.aocta,
             q.aooper,
             pn_aosbop, --q.aosbop,
             q.aotope,
             q.sgcod,
             q.pp001vc,
             q.pp001imp,
             q.pp001porc,
             q.pp001plus,
             q.pp001part,
             q.pp001veh,
             q.pp001inm,
             q.pp001end,
             q.pp001stat,
             q.pp001co,
             q.pp001aux1,
             q.pp001aux2,
             q.pp001aux3,
             q.pp001aux4,
             q.pp001aux5,
             q.pp001aux6,
             q.pp001aux7,
             q.aosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               106,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP001_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for q in jaqz520_fpp001(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into aqpa974
            (aqpa974pgcod,
             aqpa974mod,
             aqpa974suc,
             aqpa974mda,
             aqpa974pap,
             aqpa974cta,
             aqpa974oper,
             aqpa974sbop,
             aqpa974tope,
             aqpa974sgcod,
             aqpa974vc,
             aqpa974imp,
             aqpa974porc,
             aqpa974plus,
             aqpa974part,
             aqpa974veh,
             aqpa974inm,
             aqpa974end,
             aqpa974stat,
             aqpa974co,
             aqpa974aux1,
             aqpa974aux2,
             aqpa974aux3,
             aqpa974aux4,
             aqpa974aux5,
             aqpa974aux6,
             aqpa974aux7,
             aqpa974obop)
          values
            (q.pgcod,
             q.aomod,
             q.aosuc,
             q.aomda,
             q.aopap,
             q.aocta,
             q.aooper,
             pn_aosbop, --q.aosbop,
             q.aotope,
             q.sgcod,
             q.pp001vc,
             q.pp001imp,
             q.pp001porc,
             q.pp001plus,
             q.pp001part,
             q.pp001veh,
             q.pp001inm,
             q.pp001end,
             q.pp001stat,
             q.pp001co,
             q.pp001aux1,
             q.pp001aux2,
             q.pp001aux3,
             q.pp001aux4,
             q.pp001aux5,
             q.pp001aux6,
             q.pp001aux7,
             q.aosbop);
        exception
          when others then
            --lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               106,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP001_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FPP001_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FPP002_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fpp002(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP002 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FPP002 t
     where t.pgcod = pn_pgcod
       and t.ppmod = pn_aomod
       and t.ppsuc = pn_aosuc
       and t.ppmda = pn_aomda
       and t.pppap = pn_aopap
       and t.ppcta = pn_aocta
       and t.ppoper = pn_aooper
       and t.ppsbop = 0
       and --pn_aosbop
           t.pptope = pn_aotope;
  
    if lx_cont > 0 then
    
      for r in jaqz520_fpp002(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop
                              pn_aotope) loop
        begin
        
          insert into aqpa973
            (aqpa973cod,
             aqpa973mod,
             aqpa973suc,
             aqpa973mda,
             aqpa973pap,
             aqpa973cta,
             aqpa973oper,
             aqpa973sbop,
             aqpa973tope,
             aqpa973fpag,
             aqpa973tipo,
             aqpa973estconc,
             aqpa973imp,
             aqpa973stat,
             aqpa973aux1,
             aqpa973aux2,
             aqpa973aux3,
             aqpa973obop)
          values
            (r.pgcod,
             r.ppmod,
             r.ppsuc,
             r.ppmda,
             r.pppap,
             r.ppcta,
             r.ppoper,
             pn_aosbop, --r.ppsbop,
             r.pptope,
             r.ppfpag,
             r.pptipo,
             r.prestconc,
             r.pp002imp,
             r.pp002stat,
             r.pp002aux1,
             r.pp002aux2,
             r.pp002aux3,
             r.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               107,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP002_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for r in jaqz520_fpp002(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into aqpa973
            (aqpa973cod,
             aqpa973mod,
             aqpa973suc,
             aqpa973mda,
             aqpa973pap,
             aqpa973cta,
             aqpa973oper,
             aqpa973sbop,
             aqpa973tope,
             aqpa973fpag,
             aqpa973tipo,
             aqpa973estconc,
             aqpa973imp,
             aqpa973stat,
             aqpa973aux1,
             aqpa973aux2,
             aqpa973aux3,
             aqpa973obop)
          values
            (r.pgcod,
             r.ppmod,
             r.ppsuc,
             r.ppmda,
             r.pppap,
             r.ppcta,
             r.ppoper,
             pn_aosbop, --r.ppsbop,
             r.pptope,
             r.ppfpag,
             r.pptipo,
             r.prestconc,
             r.pp002imp,
             r.pp002stat,
             r.pp002aux1,
             r.pp002aux2,
             r.pp002aux3,
             r.ppsbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               107,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FPP002_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FPP002_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  PROCEDURE sp_insertar_X054023_a(pn_pgcod  in number,
                                  pn_aomod  in number,
                                  pn_aosuc  in number,
                                  pn_aomda  in number,
                                  pn_aopap  in number,
                                  pn_aocta  in number,
                                  pn_aooper in number,
                                  pn_aosbop in number,
                                  pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL   
    cursor jaqz520_x054023(cr_pgcod  number,
                           cr_aomod  number,
                           cr_aosuc  number,
                           cr_aomda  number,
                           cr_aopap  number,
                           cr_aocta  number,
                           cr_aooper number,
                           cr_aosbop number,
                           cr_aotope number) is
      select *
        from X054023 t
       where t.xllpgcod = cr_pgcod
         and t.xllaomod = cr_aomod
         and t.xllaosuc = cr_aosuc
         and t.xllaomda = cr_aomda
         and t.xllaopap = cr_aopap
         and t.xllaocta = cr_aocta
         and t.xllaooper = cr_aooper
         and t.xllaosbop = cr_aosbop
         and t.xllaotop = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from X054023 t
     where t.xllpgcod = pn_pgcod
       and t.xllaomod = pn_aomod
       and t.xllaosuc = pn_aosuc
       and t.xllaomda = pn_aomda
       and t.xllaopap = pn_aopap
       and t.xllaocta = pn_aocta
       and t.xllaooper = pn_aooper
       and t.xllaosbop = 0
       and --pn_aosbop
           t.xllaotop = pn_aotope;
  
    if lx_cont > 0 then
    
      for s in jaqz520_x054023(pn_pgcod,
                               pn_aomod,
                               pn_aosuc,
                               pn_aomda,
                               pn_aopap,
                               pn_aocta,
                               pn_aooper,
                               0, --pn_aosbop,
                               pn_aotope) loop
        begin
        
          insert into aqpb060
            (aqpb060pgcod,
             aqpb060aomod,
             aqpb060aosuc,
             aqpb060aomda,
             aqpb060aopap,
             aqpb060aocta,
             aqpb060aooper,
             aqpb060aosbop,
             aqpb060aotop,
             aqpb060fvalor,
             aqpb060capital,
             aqpb060fprimpa,
             aqpb060cantcuo,
             aqpb060periodo,
             aqpb060tipopre,
             aqpb060tipodia,
             aqpb060tipotas,
             aqpb060tasap,
             aqpb060gradper,
             aqpb060gradpor,
             aqpb060gradimp,
             aqpb060tipoano,
             aqpb060tipdiap,
             aqpb060pcltcod,
             aqpb060pclplus,
             aqpb060pcldrev,
             aqpb060tferp,
             aqpb060cntcuoi,
             aqpb060fpripag,
             aqpb060plazo,
             aqpb060fvto,
             aqpb060modocal,
             aqpb060gracfij,
             aqpb060ciud,
             aqpb060capliq,
             aqpb060medico,
             aqpb060financ,
             aqpb060tasaej,
             aqpb060valcan,
             aqpb060valcuo,
             aqpb060capfin,
             aqpb060impu,
             aqpb060aux1,
             aqpb060aux2,
             aqpb060aux3,
             aqpb060aux4,
             aqpb060aux5,
             aqpb060redon,
             aqpb060aux6,
             aqpb060precio,
             aqpb060aoobop)
          values
            (s.xllpgcod,
             s.xllaomod,
             s.xllaosuc,
             s.xllaomda,
             s.xllaopap,
             s.xllaocta,
             s.xllaooper,
             pn_aosbop, --s.xllaosbop,
             s.xllaotop,
             s.xllfvalor,
             s.xllcapital,
             s.xllfprimpa,
             s.xllcantcuo,
             s.xllperiodo,
             s.xlltipopre,
             s.xlltipodia,
             s.xlltipotas,
             s.xlltasap,
             s.xllgradper,
             s.xllgradpor,
             s.xllgradimp,
             s.xlltipoano,
             s.xlltipdiap,
             s.xllpcltcod,
             s.xllpclplus,
             s.xllpcldrev,
             s.xlltferp,
             s.xllcntcuoi,
             s.xllfpripag,
             s.xllplazo,
             s.xllfvto,
             s.xllmodocal,
             s.xllgracfij,
             s.xllciud,
             s.xllcapliq,
             s.xllmedico,
             s.xllfinanc,
             s.xlltasaej,
             s.xllvalcan,
             s.xllvalcuo,
             s.xllcapfin,
             s.xllimpu,
             s.xllaux1,
             s.xllaux2,
             s.xllaux3,
             s.xllaux4,
             s.xllaux5,
             s.xllredon,
             s.xllaux6,
             s.xllprecio,
             s.xllaosbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               108,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'X054023_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
        end;
      end loop;
      commit;
    
    else
    
      for s in jaqz520_x054023(pn_pgcod,
                               pn_aomod,
                               pn_aosuc,
                               pn_aomda,
                               pn_aopap,
                               pn_aocta,
                               pn_aooper,
                               pn_aosbop,
                               pn_aotope) loop
        begin
        
          insert into aqpb060
            (aqpb060pgcod,
             aqpb060aomod,
             aqpb060aosuc,
             aqpb060aomda,
             aqpb060aopap,
             aqpb060aocta,
             aqpb060aooper,
             aqpb060aosbop,
             aqpb060aotop,
             aqpb060fvalor,
             aqpb060capital,
             aqpb060fprimpa,
             aqpb060cantcuo,
             aqpb060periodo,
             aqpb060tipopre,
             aqpb060tipodia,
             aqpb060tipotas,
             aqpb060tasap,
             aqpb060gradper,
             aqpb060gradpor,
             aqpb060gradimp,
             aqpb060tipoano,
             aqpb060tipdiap,
             aqpb060pcltcod,
             aqpb060pclplus,
             aqpb060pcldrev,
             aqpb060tferp,
             aqpb060cntcuoi,
             aqpb060fpripag,
             aqpb060plazo,
             aqpb060fvto,
             aqpb060modocal,
             aqpb060gracfij,
             aqpb060ciud,
             aqpb060capliq,
             aqpb060medico,
             aqpb060financ,
             aqpb060tasaej,
             aqpb060valcan,
             aqpb060valcuo,
             aqpb060capfin,
             aqpb060impu,
             aqpb060aux1,
             aqpb060aux2,
             aqpb060aux3,
             aqpb060aux4,
             aqpb060aux5,
             aqpb060redon,
             aqpb060aux6,
             aqpb060precio,
             aqpb060aoobop)
          values
            (s.xllpgcod,
             s.xllaomod,
             s.xllaosuc,
             s.xllaomda,
             s.xllaopap,
             s.xllaocta,
             s.xllaooper,
             pn_aosbop, --s.xllaosbop,
             s.xllaotop,
             s.xllfvalor,
             s.xllcapital,
             s.xllfprimpa,
             s.xllcantcuo,
             s.xllperiodo,
             s.xlltipopre,
             s.xlltipodia,
             s.xlltipotas,
             s.xlltasap,
             s.xllgradper,
             s.xllgradpor,
             s.xllgradimp,
             s.xlltipoano,
             s.xlltipdiap,
             s.xllpcltcod,
             s.xllpclplus,
             s.xllpcldrev,
             s.xlltferp,
             s.xllcntcuoi,
             s.xllfpripag,
             s.xllplazo,
             s.xllfvto,
             s.xllmodocal,
             s.xllgracfij,
             s.xllciud,
             s.xllcapliq,
             s.xllmedico,
             s.xllfinanc,
             s.xlltasaej,
             s.xllvalcan,
             s.xllvalcuo,
             s.xllcapfin,
             s.xllimpu,
             s.xllaux1,
             s.xllaux2,
             s.xllaux3,
             s.xllaux4,
             s.xllaux5,
             s.xllredon,
             s.xllaux6,
             s.xllprecio,
             s.xllaosbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               108,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'X054023_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_X054023_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FSD012_a(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---MARZO: FSD012   
    cursor jaqz520_fsd012(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD012 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    --Evaluar ACTUAL
    select count(*)
      into lx_cont
      from FSD012 t
     where t.pgcod = pn_pgcod
       and t.aomod = pn_aomod
       and t.aosuc = pn_aosuc
       and t.aomda = pn_aomda
       and t.aopap = pn_aopap
       and t.aocta = pn_aocta
       and t.aooper = pn_aooper
       and t.aosbop = 0
       and --pn_aosbop
           t.aotope = pn_aotope;
  
    if lx_cont > 0 then
    
      for u in jaqz520_fsd012(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              0, --pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPA975
            (aqpa975cod,
             aqpa975mod,
             aqpa975suc,
             aqpa975mda,
             aqpa975pap,
             aqpa975cta,
             aqpa975oper,
             aqpa975sbop,
             aqpa975tope,
             aqpa975corr,
             aqpa975tipo,
             aqpa975fval,
             aqpa975fvto,
             aqpa975imp,
             aqpa975ttas,
             aqpa975tasa,
             aqpa975cap,
             aqpa975int,
             aqpa975mor,
             aqpa975scap,
             aqpa975sint,
             aqpa975smor,
             aqpa975intc,
             aqpa975morc,
             aqpa975cd01,
             aqpa975cd02,
             aqpa975inv,
             aqpa975per,
             aqpa975tcbi,
             aqpa975tcbi1,
             aqpa975arb,
             aqpa975arb1,
             aqpa975md,
             aqpa975md1,
             aqpa975pre,
             aqpa975pre1,
             aqpa975cd,
             aqpa975mo,
             aqpa975su,
             aqpa975tr,
             aqpa975re,
             aqpa975fc,
             aqpa975or,
             aqpa975sb,
             aqpa975co,
             aqpa975obop)
          values
            (u.pgcod,
             u.aomod,
             u.aosuc,
             u.aomda,
             u.aopap,
             u.aocta,
             u.aooper,
             pn_aosbop, --u.aosbop,
             u.aotope,
             u.evcorr,
             u.evtipo,
             u.evfval,
             u.evfvto,
             u.evimp,
             u.evttas,
             u.evtasa,
             u.evcap,
             u.evint,
             u.evmor,
             u.evscap,
             u.evsint,
             u.evsmor,
             u.evintc,
             u.evmorc,
             u.evcd01,
             u.evcd02,
             u.evinv,
             u.evper,
             u.evtcbi,
             u.evtcbi1,
             u.evarb,
             u.evarb1,
             u.evmd,
             u.evmd1,
             u.evpre,
             u.evpre1,
             u.d012cd,
             u.d012mo,
             u.d012su,
             u.d012tr,
             u.d012re,
             u.d012fc,
             u.d012or,
             u.d012sb,
             u.d012co,
             u.aosbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               109,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD012_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    else
    
      for u in jaqz520_fsd012(pn_pgcod,
                              pn_aomod,
                              pn_aosuc,
                              pn_aomda,
                              pn_aopap,
                              pn_aocta,
                              pn_aooper,
                              pn_aosbop,
                              pn_aotope) loop
        begin
        
          insert into AQPA975
            (aqpa975cod,
             aqpa975mod,
             aqpa975suc,
             aqpa975mda,
             aqpa975pap,
             aqpa975cta,
             aqpa975oper,
             aqpa975sbop,
             aqpa975tope,
             aqpa975corr,
             aqpa975tipo,
             aqpa975fval,
             aqpa975fvto,
             aqpa975imp,
             aqpa975ttas,
             aqpa975tasa,
             aqpa975cap,
             aqpa975int,
             aqpa975mor,
             aqpa975scap,
             aqpa975sint,
             aqpa975smor,
             aqpa975intc,
             aqpa975morc,
             aqpa975cd01,
             aqpa975cd02,
             aqpa975inv,
             aqpa975per,
             aqpa975tcbi,
             aqpa975tcbi1,
             aqpa975arb,
             aqpa975arb1,
             aqpa975md,
             aqpa975md1,
             aqpa975pre,
             aqpa975pre1,
             aqpa975cd,
             aqpa975mo,
             aqpa975su,
             aqpa975tr,
             aqpa975re,
             aqpa975fc,
             aqpa975or,
             aqpa975sb,
             aqpa975co,
             aqpa975obop)
          values
            (u.pgcod,
             u.aomod,
             u.aosuc,
             u.aomda,
             u.aopap,
             u.aocta,
             u.aooper,
             pn_aosbop, --u.aosbop,
             u.aotope,
             u.evcorr,
             u.evtipo,
             u.evfval,
             u.evfvto,
             u.evimp,
             u.evttas,
             u.evtasa,
             u.evcap,
             u.evint,
             u.evmor,
             u.evscap,
             u.evsint,
             u.evsmor,
             u.evintc,
             u.evmorc,
             u.evcd01,
             u.evcd02,
             u.evinv,
             u.evper,
             u.evtcbi,
             u.evtcbi1,
             u.evarb,
             u.evarb1,
             u.evmd,
             u.evmd1,
             u.evpre,
             u.evpre1,
             u.d012cd,
             u.d012mo,
             u.d012su,
             u.d012tr,
             u.d012re,
             u.d012fc,
             u.d012or,
             u.d012sb,
             u.d012co,
             u.aosbop);
        exception
          when others then
            -- lc_flag := 'N';
          
            lc_coderr := sqlcode;
            lc_msgerr := substr(trim(sqlerrm), 1, 90);
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref,
               aqpb066etip,
               aqpb066eacoe,
               aqpb066eamsge)
            values
              (lc_fecha,
               109,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'FSD012_a',
               'P',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;
    
    end if;
  
  end sp_insertar_FSD012_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  PROCEDURE sp_insertar_AQPB064_ini(pn_fecha_ini in date,
                                    pn_fecha_fin in date,
                                    pn_digito    in number) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
    lc_fecha_prv date;
  
    --Cursor JAQZ698
    cursor cur_jaqz698(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from jaqz698 s
       where s.jaqz698est in ('C', 'V')
         and s.jaqz698fep >= cr_fecha_ini
         and s.jaqz698fep <= cr_fecha_fin
         and substr(trim(to_char(s.jaqz698ope)), -1) = pn_digito
       order by s.jaqz698fep, s.jaqz698cor asc;
  
    --Cursor AQPB002
    cursor cur_aqpb002(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb002 j
       where j.aqpb002est = 'C'
         and j.aqpb002fep >= cr_fecha_ini
         and j.aqpb002fep <= cr_fecha_fin
         and substr(trim(to_char(j.aqpb002ope)), -1) = pn_digito
       order by j.aqpb002fep, j.aqpb002cor asc;
  
  Begin
  
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_prv := lc_fecha_ini - 1;
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Eliminado de data
      --delete from aqpb064 t where t.aqpb064frepro >= lc_fecha_ini and t.aqpb064frepro <= lc_fecha_fin ;
      --commit;
    
      ---Recurrido cursor JAQZ698
      for i in cur_jaqz698(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_JAQZ698(i.jaqz698fep,
                                                                 i.jaqz698cor,
                                                                 i.jaqz698inst,
                                                                 lc_fecha_prv,
                                                                 i.jaqz698est,
                                                                 
                                                                 i.jaqz698emp,
                                                                 i.jaqz698mod,
                                                                 i.jaqz698suc,
                                                                 i.jaqz698mda,
                                                                 i.jaqz698pap,
                                                                 i.jaqz698cta,
                                                                 i.jaqz698ope,
                                                                 i.jaqz698sbo,
                                                                 i.jaqz698top);
      
      end loop;
    
      --Recorrido cursor AQPB002
      for j in cur_aqpb002(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_AQPB002(j.aqpb002fep,
                                                                 j.aqpb002cor,
                                                                 j.aqpb002ins,
                                                                 lc_fecha_prv,
                                                                 
                                                                 j.aqpb002emp,
                                                                 j.aqpb002mod,
                                                                 j.aqpb002suc,
                                                                 j.aqpb002mda,
                                                                 j.aqpb002pap,
                                                                 j.aqpb002cta,
                                                                 j.aqpb002ope,
                                                                 j.aqpb002sbo,
                                                                 j.aqpb002top,
                                                                 
                                                                 j.aqpb002feca,
                                                                 j.aqpb002revr);
      
      end loop;
    
    end;
  
  end sp_insertar_AQPB064_ini;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  procedure sp_cr_job_carga(pn_fecha_ini in date, pn_fecha_fin in date) is
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 5000;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
    --ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
  
    lc_hostname varchar2(64);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    ln_ini := 0;
    ln_fin := 9;
    WHILE ln_ini <= ln_fin LOOP
    
      lc_variable := 'begin ' || '  pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_ini(
                        ' || '''' || pn_fecha_ini || '''' || ',
                        ' || '''' || pn_fecha_fin || '''' || ',
                        ' || ln_ini || ');' || ' End;';
    
      ln_job := ln_job + 1;
      dbms_output.put_line(lc_variable);
    
      /*
      IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      */
    
      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate,
                      interval  => null,
                      no_parse  => false,
                      force     => false);
    
      ln_ini := ln_ini + 1;
      commit;
    
    END LOOP;
  
  end sp_cr_job_carga;

  PROCEDURE sp_repro_marzo is
    lc_flag char(1);
    lc_corr number;
  
    lx_pgcod     number;
    lx_aomod     number;
    lx_aosuc     number;
    lx_aomda     number;
    lx_aopap     number;
    lx_aocta     number;
    lx_aooper    number;
    lx_aosbop    number;
    lx_aotope    number;
    lx_aoobop    number;
    lc_fecha_prv date;
  
    --Cursor JAQZ698
    cursor cur_jaqz698 is
      select *
        from jaqz698 j
       where j.jaqz698est in ('C', 'V')
         and j.JAQZ698SBO > 0
         and j.jaqz698fep >= to_date('2020.03.01', 'yyyy.mm.dd')
         and j.jaqz698fep <= to_date('2020.03.31', 'yyyy.mm.dd');
  
    --Cursor AQPB002
    cursor cur_aqpb002 is
      select *
        from aqpb002 j
       where j.aqpb002est = 'C'
         and j.AQPB002SBO > 0
         and j.aqpb002fep >= to_date('2020.03.01', 'yyyy.mm.dd')
         and j.aqpb002fep <= to_date('2020.03.31', 'yyyy.mm.dd');
  
  begin
  
    lc_fecha_prv := to_date('2020.02.29', 'yyyy.mm.dd');
  
    -- 1: Borrar AQPB060
    delete from aqpb060 x
     where (x.aqpb060pgcod, x.aqpb060aomod, x.aqpb060aosuc, x.aqpb060aomda,
            x.aqpb060aopap, x.aqpb060aocta, x.aqpb060aooper, x.aqpb060aosbop,
            x.aqpb060aotop) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 2: Borrar AQPB061
    delete from aqpb061 x
     where (x.aqpb061pgcod, x.aqpb061mod, x.aqpb061suc, x.aqpb061mda,
            x.aqpb061pap, x.aqpb061cta, x.aqpb061oper, x.aqpb061sbop,
            x.aqpb061tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 3: Borrar AQPB062
    delete from aqpb062 x
     where (x.aqpb062pgcod, x.aqpb062mod, x.aqpb062suc, x.aqpb062mda,
            x.aqpb062pap, x.aqpb062cta, x.aqpb062oper, x.aqpb062sbop,
            x.aqpb062tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 4: Borrar AQPB063
    delete from aqpb063 x
     where (x.aqpb063pgcod, x.aqpb063mod, x.aqpb063suc, x.aqpb063mda,
            x.aqpb063pap, x.aqpb063cta, x.aqpb063oper, x.aqpb063sbop,
            x.aqpb063tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 5: Borrar AQPA973
    delete from aqpa973 x
     where (x.aqpa973cod, x.aqpa973mod, x.aqpa973suc, x.aqpa973mda,
            x.aqpa973pap, x.aqpa973cta, x.aqpa973oper, x.aqpa973sbop,
            x.aqpa973tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 6: Borrar AQPA974
    delete from aqpa974 x
     where (x.aqpa974pgcod, x.aqpa974mod, x.aqpa974suc, x.aqpa974mda,
            x.aqpa974pap, x.aqpa974cta, x.aqpa974oper, x.aqpa974sbop,
            x.aqpa974tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- 7:Borrar AQPA975
    delete from aqpa975 x
     where (x.aqpa975cod, x.aqpa975mod, x.aqpa975suc, x.aqpa975mda,
            x.aqpa975pap, x.aqpa975cta, x.aqpa975oper, x.aqpa975sbop,
            x.aqpa975tope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and
                  --t.aqpb009sbo > 0 and 
                   trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- Borrar AQPB064
    delete from aqpb064 x
     where (x.aqpb064pgcod, x.aqpb064aomod, x.aqpb064aosuc, x.aqpb064aomda,
            x.aqpb064aopap, x.aqpb064aocta, x.aqpb064aooper, x.aqpb064aosbop,
            x.aqpb064aotope) in
           (select t.aqpb009emp,
                   t.aqpb009mod,
                   t.aqpb009suc,
                   t.aqpb009mda,
                   t.aqpb009pap,
                   t.aqpb009cta,
                   t.aqpb009ope,
                   t.aqpb009sbo,
                   t.aqpb009top
              from aqpb009 t
             where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and trim(t.aqpb009tref) in
                   ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
               and (t.aqpb009emp, t.aqpb009mod,
                   --t.aqpb009suc,
                    t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
                   --t.aqpb009sbo,
                    t.aqpb009top) in
                   (select j.jaqz698emp,
                           j.jaqz698mod,
                           --j.jaqz698suc,
                           j.jaqz698mda,
                           j.jaqz698pap,
                           j.jaqz698cta,
                           j.jaqz698ope,
                           --j.jaqz698sbo,
                           j.jaqz698top
                      from jaqz698 j
                     where j.jaqz698fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and j.jaqz698fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and j.jaqz698est in ('C', 'V')
                       and j.jaqz698sbo > 0
                    union
                    
                    select g.aqpb002emp,
                           g.aqpb002mod,
                           --g.aqpb002suc,
                           g.aqpb002mda,
                           g.aqpb002pap,
                           g.aqpb002cta,
                           g.aqpb002ope,
                           --g.aqpb002sbo,
                           g.aqpb002top
                      from aqpb002 g
                     where g.aqpb002fep >=
                           to_date('2020.03.01', 'yyyy.mm.dd')
                       and g.aqpb002fep <=
                           to_date('2020.03.31', 'yyyy.mm.dd')
                       and g.aqpb002est in ('C')
                       and g.aqpb002sbo > 0
                    
                    ));
    commit;
  
    -- Borrar AQPB009
    delete from aqpb009 t
     where t.aqpb009fep >= to_date('2020.03.01', 'yyyy.mm.dd')
       and t.aqpb009fep <= to_date('2020.03.31', 'yyyy.mm.dd')
       and trim(t.aqpb009tref) in
           ('JAQZ698', 'AQPB002', 'JAQZ698C', 'AQPB002C')
       and (t.aqpb009emp, t.aqpb009mod,
           --t.aqpb009suc,
            t.aqpb009mda, t.aqpb009pap, t.aqpb009cta, t.aqpb009ope,
           --t.aqpb009sbo,
            t.aqpb009top) in
           (select j.jaqz698emp,
                   j.jaqz698mod,
                   --j.jaqz698suc,
                   j.jaqz698mda,
                   j.jaqz698pap,
                   j.jaqz698cta,
                   j.jaqz698ope,
                   --j.jaqz698sbo,
                   j.jaqz698top
              from jaqz698 j
             where j.jaqz698fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and j.jaqz698fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and j.jaqz698est in ('C', 'V')
               and j.jaqz698sbo > 0
            union
            
            select g.aqpb002emp,
                   g.aqpb002mod,
                   --g.aqpb002suc,
                   g.aqpb002mda,
                   g.aqpb002pap,
                   g.aqpb002cta,
                   g.aqpb002ope,
                   --g.aqpb002sbo,
                   g.aqpb002top
              from aqpb002 g
             where g.aqpb002fep >= to_date('2020.03.01', 'yyyy.mm.dd')
               and g.aqpb002fep <= to_date('2020.03.31', 'yyyy.mm.dd')
               and g.aqpb002est in ('C')
               and g.aqpb002sbo > 0
            
            );
    commit;
  
    -- Inicio cursor
    ---Recurrido cursor JAQZ698
    for i in cur_jaqz698 loop
    
      pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_JAQZ698_a(i.jaqz698fep,
                                                                 i.jaqz698cor,
                                                                 i.jaqz698inst,
                                                                 lc_fecha_prv,
                                                                 i.jaqz698est,
                                                                 
                                                                 i.jaqz698emp,
                                                                 i.jaqz698mod,
                                                                 i.jaqz698suc,
                                                                 i.jaqz698mda,
                                                                 i.jaqz698pap,
                                                                 i.jaqz698cta,
                                                                 i.jaqz698ope,
                                                                 i.jaqz698sbo,
                                                                 i.jaqz698top);
    
    end loop;
  
    --Recorrido cursor AQPB002
    for j in cur_aqpb002 loop
    
      pq_cr_historico_pagos_masivo.sp_insertar_AQPB064_AQPB002_a(j.aqpb002fep,
                                                                 j.aqpb002cor,
                                                                 j.aqpb002ins,
                                                                 lc_fecha_prv,
                                                                 
                                                                 j.aqpb002emp,
                                                                 j.aqpb002mod,
                                                                 j.aqpb002suc,
                                                                 j.aqpb002mda,
                                                                 j.aqpb002pap,
                                                                 j.aqpb002cta,
                                                                 j.aqpb002ope,
                                                                 j.aqpb002sbo,
                                                                 j.aqpb002top,
                                                                 
                                                                 j.aqpb002feca,
                                                                 j.aqpb002revr);
    
    end loop;
  
  end sp_repro_marzo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_AQPB064_JAQZ698_a(pn_fecha      in date,
                                          pn_corr       in number,
                                          pn_inst       in number,
                                          pn_fecha_prev in date,
                                          pn_revr       in char,
                                          
                                          pn_pgcod  in number,
                                          pn_aomod  in number,
                                          pn_aosuc  in number,
                                          pn_aomda  in number,
                                          pn_aopap  in number,
                                          pn_aocta  in number,
                                          pn_aooper in number,
                                          pn_aosbop in number,
                                          pn_aotope in number) is
    lc_flag char(1);
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
  
    lx_scsdo number(17, 2);
    lx_orden number;
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from jaqz520_010c q
       where q.fec = pn_fecha
         and q.cor = pn_corr
         and q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
         and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = pn_aosbop
         and q.aotope = pn_aotope;
    exception
      when others then
        lc_flag := 'N';
    end;
  
    if lc_flag = 'S' then
      begin
        /************************/
      
        begin
          select nvl(max(x.aqpb064orden), 0) + 1
            into lx_orden
            from aqpb064 x
           where x.aqpb064pgcod = pn_pgcod
             and x.aqpb064aomod = pn_aomod
             and
                --x.aqpb064aosuc = pn_aosuc and
                 x.aqpb064aomda = pn_aomda
             and x.aqpb064aopap = pn_aopap
             and x.aqpb064aocta = pn_aocta
             and x.aqpb064aooper = pn_aooper
             and
                --x.aqpb064aosbop = pn_aosbop and
                 x.aqpb064aotope = pn_aotope;
        exception
          when others then
            lx_orden := 1;
        end;
      
        /****************************/
      
        lx_frepro  := pn_fecha;
        lx_ncorre  := pn_corr;
        lx_proceso := 'C'; ---CAPITALIZACION
        lx_fcierre := pn_fecha_prev; --lc_fecha_prv;
        lx_instanc := pn_inst;
        if (pn_revr = 'V') then
          lx_estado := 'X';
        else
          lx_estado := 'R';
        end if;
      
        lx_fecest := pn_fecha;
      
        /****************************/
      
        select sum(r.scsdo)
          into lx_scsdo
          from jaqz520_011c r
         where r.fec = pn_fecha
           and r.cor = pn_corr
           and
              
               r.pgcod = pn_pgcod
           and r.scmod = pn_aomod
           and r.scsuc = pn_aosuc
           and r.scmda = pn_aomda
           and r.scpap = pn_aopap
           and r.sccta = pn_aocta
           and r.scoper = pn_aooper
           and r.scsbop = pn_aosbop
           and r.sctope = pn_aotope;
      
        /****************************/
        begin
        
          insert into AQPB064
            (aqpb064frepro,
             aqpb064ncorre,
             aqpb064pgcod,
             aqpb064aomod,
             aqpb064aosuc,
             aqpb064aomda,
             aqpb064aopap,
             aqpb064aocta,
             aqpb064aooper,
             aqpb064aosbop,
             aqpb064aotope,
             
             --aqpb064aofval,
             --aqpb064aofvto,
             --aqpb064aopzo,
             --aqpb064aotasa,
             --aqpb064aoimp,
             --aqpb064aomd,
             --aqpb064aostat,
             --aqpb064aofe99,
             --aqpb064aoperiod,
             
             aqpb064proceso,
             aqpb064fcierre,
             aqpb064instanc,
             aqpb064estado,
             aqpb064fecest,
             --aqpb064diaatr,
             --aqpb064diagra,
             --aqpb064fepvep,
             aqpb064scsdo,
             --aqpb064freproref,
             --aqpb064ncorreref,
             aqpb064tablaref,
             aqpb064orden)
          values
            (
             
             lx_frepro,
             lx_ncorre,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             
             lx_proceso,
             lx_fcierre,
             lx_instanc,
             lx_estado,
             lx_fecest,
             lx_scsdo,
             'JAQZ698C',
             lx_orden
             
             );
          commit;
        
        exception
          when others then
          
            insert into aqpb066
              (aqpb066fep,
               aqpb066cor,
               aqpb066emp,
               aqpb066mod,
               aqpb066suc,
               aqpb066mda,
               aqpb066pap,
               aqpb066cta,
               aqpb066ope,
               aqpb066sbo,
               aqpb066top,
               aqpb066tref)
            values
              (pn_fecha,
               pn_corr,
               pn_pgcod,
               pn_aomod,
               pn_aosuc,
               pn_aomda,
               pn_aopap,
               pn_aocta,
               pn_aooper,
               pn_aosbop,
               pn_aotope,
               'JAQZ698');
            commit;
          
            lx_orden := 99;
        end;
        -- registrar solo si es la primera reprogramación
        if lx_orden = 1 then
        
          ---Insertar aqpb009
          insert into aqpb009
            (aqpb009fep,
             aqpb009cor,
             aqpb009emp,
             aqpb009mod,
             aqpb009suc,
             aqpb009mda,
             aqpb009pap,
             aqpb009cta,
             aqpb009ope,
             aqpb009sbo,
             aqpb009top,
             aqpb009est,
             aqpb009sdo,
             --aqpb009tea1,
             --aqpb009tea2,
             --aqpb009tcea1,
             --aqpb009tcea2,
             --aqpb009usr,
             --aqpb009hoi,
             --aqpb009hof,
             --aqpb009narc,
             aqpb009ins,
             --aqpb009fmail,
             --aqpb009mail,
             --aqpb009ase,
             --aqpb009tpo,
             --aqpb009estcr,
             --aqpb009rub,
             aqpb009tref)
            select t.jaqz698fep,
                   t.jaqz698cor,
                   t.jaqz698emp,
                   t.jaqz698mod,
                   t.jaqz698suc,
                   t.jaqz698mda,
                   t.jaqz698pap,
                   t.jaqz698cta,
                   t.jaqz698ope,
                   t.jaqz698sbo,
                   t.jaqz698top,
                   t.jaqz698est,
                   lx_scsdo,
                   lx_instanc,
                   'JAQZ698C'
              from jaqz698 t
             where t.jaqz698fep = pn_fecha
               and t.jaqz698cor = pn_corr
               and t.jaqz698emp = pn_pgcod
               and t.jaqz698mod = pn_aomod
               and t.jaqz698suc = pn_aosuc
               and t.jaqz698mda = pn_aomda
               and t.jaqz698pap = pn_aopap
               and t.jaqz698cta = pn_aocta
               and t.jaqz698ope = pn_aooper
               and t.jaqz698sbo = pn_aosbop
               and t.jaqz698top = pn_aotope;
          commit;
        
          --begin
        
          /*********** 1: INSERTAR AQPB061: FSD601 - BACKUP *****************/
          /*
          pq_cr_historico_pagos_masivo.sp_insertar_FSD601_a(pn_pgcod,
                                          pn_aomod,
                                          pn_aosuc,
                                          pn_aomda,
                                          pn_aopap,
                                          pn_aocta,
                                          pn_aooper,
                                          pn_aosbop,
                                          pn_aotope);
          */
        
          /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
          /*
           pq_cr_historico_pagos_masivo.sp_insertar_FSD602_a(pn_pgcod,
                                           pn_aomod,
                                           pn_aosuc,
                                           pn_aomda,
                                           pn_aopap,
                                           pn_aocta,
                                           pn_aooper,
                                           pn_aosbop,
                                           pn_aotope);
          */
        
          /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
          /*
          pq_cr_historico_pagos_masivo.sp_insertar_FSD611_a(pn_pgcod,
                                          pn_aomod,
                                          pn_aosuc,
                                          pn_aomda,
                                          pn_aopap,
                                          pn_aocta,
                                          pn_aooper,
                                          pn_aosbop,
                                          pn_aotope);
          */
        
          /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
          /*              
          pq_cr_historico_pagos_masivo.sp_insertar_FPP001_a(pn_pgcod,
                                          pn_aomod,
                                          pn_aosuc,
                                          pn_aomda,
                                          pn_aopap,
                                          pn_aocta,
                                          pn_aooper,
                                          pn_aosbop,
                                          pn_aotope);   
          */
        
          /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
          /*             
          pq_cr_historico_pagos_masivo.sp_insertar_FPP002_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
          */
        
          /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
          /*          
           pq_cr_historico_pagos_masivo.sp_insertar_X054023_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
          */
        
          /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
          /*
          pq_cr_historico_pagos_masivo.sp_insertar_FSD012_a(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);   
          */
        
          --end;
        
          --- Final: validación  
        end if;
      
      end;
    end if;
  
  end sp_insertar_AQPB064_JAQZ698_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_AQPB064_AQPB002_a(pn_fecha      in date,
                                          pn_corr       in number,
                                          pn_inst       in number,
                                          pn_fecha_prev in date,
                                          
                                          pn_pgcod  in number,
                                          pn_aomod  in number,
                                          pn_aosuc  in number,
                                          pn_aomda  in number,
                                          pn_aopap  in number,
                                          pn_aocta  in number,
                                          pn_aooper in number,
                                          pn_aosbop in number,
                                          pn_aotope in number,
                                          
                                          pn_feca in date,
                                          pn_revr in char) is
    lc_flag char(1);
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
  
    lx_scsdo number(17, 2);
    lx_orden number;
  
  begin
    /*
    begin
       select 
           'S' into lc_flag
       from 
           jaqz520_010 q 
       where
           q.pgcod = pn_pgcod and
           q.aomod = pn_aomod and
           q.aosuc = pn_aosuc and
           q.aomda = pn_aomda and
           q.aopap = pn_aopap and
           q.aocta = pn_aocta and
           q.aooper = pn_aooper and
           q.aosbop = pn_aosbop and
           q.aotope = pn_aotope ;
    exception
       when others then
            lc_flag := 'N';
    end;
    */
  
    --if  lc_flag = 'S' then
    -- begin
    /************************/
  
    begin
      select nvl(max(x.aqpb064orden), 0) + 1
        into lx_orden
        from aqpb064 x
       where x.aqpb064pgcod = pn_pgcod
         and x.aqpb064aomod = pn_aomod
         and
            --x.aqpb064aosuc = pn_aosuc and
             x.aqpb064aomda = pn_aomda
         and x.aqpb064aopap = pn_aopap
         and x.aqpb064aocta = pn_aocta
         and x.aqpb064aooper = pn_aooper
         and
            --x.aqpb064aosbop = pn_aosbop and
             x.aqpb064aotope = pn_aotope;
    exception
      when others then
        lx_orden := 1;
    end;
  
    /****************************/
  
    lx_frepro  := pn_fecha;
    lx_ncorre  := pn_corr;
    lx_proceso := 'R'; ---REPROGRAMADO
    lx_fcierre := pn_fecha_prev;
    lx_instanc := pn_inst;
  
    if (pn_revr = 'S') then
      lx_estado := 'X';
      lx_fecest := pn_feca;
    else
      lx_estado := 'R';
      lx_fecest := pn_fecha;
    end if;
  
    /****************************/
    begin
      insert into AQPB064
        (aqpb064frepro,
         aqpb064ncorre,
         aqpb064pgcod,
         aqpb064aomod,
         aqpb064aosuc,
         aqpb064aomda,
         aqpb064aopap,
         aqpb064aocta,
         aqpb064aooper,
         aqpb064aosbop,
         aqpb064aotope,
         --aqpb064aofval,
         --aqpb064aofvto,
         --aqpb064aopzo,
         --aqpb064aotasa,
         --aqpb064aoimp,
         --aqpb064aomd,
         --aqpb064aostat,
         --aqpb064aofe99,
         --aqpb064aoperiod,
         aqpb064proceso,
         aqpb064fcierre,
         --aqpb064instanc,
         aqpb064estado,
         -- aqpb064fecest,
         --aqpb064diaatr,
         --aqpb064diagra,
         --aqpb064fepvep,
         --aqpb064scsdo,
         --aqpb064freproref,
         --aqpb064ncorreref,
         aqpb064tablaref,
         aqpb064orden)
      values
        (pn_fecha,
         pn_corr,
         pn_pgcod,
         pn_aomod,
         pn_aosuc,
         pn_aomda,
         pn_aopap,
         pn_aocta,
         pn_aooper,
         pn_aosbop,
         pn_aotope,
         lx_proceso,
         lx_fcierre,
         lx_estado,
         'AQPB002C',
         lx_orden);
    
      commit;
    exception
      when others then
      
        insert into aqpb066
          (aqpb066fep,
           aqpb066cor,
           aqpb066emp,
           aqpb066mod,
           aqpb066suc,
           aqpb066mda,
           aqpb066pap,
           aqpb066cta,
           aqpb066ope,
           aqpb066sbo,
           aqpb066top,
           aqpb066tref)
        values
          (pn_fecha,
           pn_corr,
           pn_pgcod,
           pn_aomod,
           pn_aosuc,
           pn_aomda,
           pn_aopap,
           pn_aocta,
           pn_aooper,
           pn_aosbop,
           pn_aotope,
           'AQPB002');
        commit;
      
        lx_orden := 99;
    end;
  
    -- registrar solo si es la primera reprogramación
    if lx_orden = 1 then
    
      ---Insertar aqpb009
      insert into aqpb009
        (aqpb009fep,
         aqpb009cor,
         aqpb009emp,
         aqpb009mod,
         aqpb009suc,
         aqpb009mda,
         aqpb009pap,
         aqpb009cta,
         aqpb009ope,
         aqpb009sbo,
         aqpb009top,
         aqpb009est,
         --aqpb009sdo,
         --aqpb009tea1,
         --aqpb009tea2,
         --aqpb009tcea1,
         --aqpb009tcea2,
         aqpb009usr,
         aqpb009hoi,
         aqpb009hof,
         aqpb009narc,
         aqpb009ins,
         aqpb009fmail,
         aqpb009mail,
         aqpb009ase,
         aqpb009tpo,
         aqpb009estcr,
         aqpb009rub,
         aqpb009tref)
        select t.aqpb002fep,
               t.aqpb002cor,
               t.aqpb002emp,
               t.aqpb002mod,
               t.aqpb002suc,
               t.aqpb002mda,
               t.aqpb002pap,
               t.aqpb002cta,
               t.aqpb002ope,
               t.aqpb002sbo,
               t.aqpb002top,
               t.aqpb002est,
               --lx_scsdo,
               t.aqpb002usrr,
               t.aqpb002hoi,
               t.aqpb002hof,
               t.aqpb002narc,
               lx_instanc,
               t.aqpb002fmail,
               t.aqpb002mail,
               t.aqpb002ase,
               t.aqpb002tipo,
               t.aqpb002estcr,
               t.aqpb002rub,
               'AQPB002C'
          from aqpb002 t
         where t.aqpb002fep = pn_fecha
           and t.aqpb002cor = pn_corr
           and t.aqpb002emp = pn_pgcod
           and t.aqpb002mod = pn_aomod
           and t.aqpb002suc = pn_aosuc
           and t.aqpb002mda = pn_aomda
           and t.aqpb002pap = pn_aopap
           and t.aqpb002cta = pn_aocta
           and t.aqpb002ope = pn_aooper
           and t.aqpb002sbo = pn_aosbop
           and t.aqpb002top = pn_aotope;
      commit;
    
      ---begin
    
      /*********** 1: INSERTAR AQPB061: FSD601 - BACKUP *****************/
      /*
      pq_cr_historico_pagos_masivo.sp_insertar_FSD601_a(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope);
      */
    
      /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
      /*
      pq_cr_historico_pagos_masivo.sp_insertar_FSD602_a(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope);
      */
    
      /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
      /*    
      pq_cr_historico_pagos_masivo.sp_insertar_FSD611_a(pn_pgcod,
                                      pn_aomod,
                                      pn_aosuc,
                                      pn_aomda,
                                      pn_aopap,
                                      pn_aocta,
                                      pn_aooper,
                                      pn_aosbop,
                                      pn_aotope);
      */
    
      /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
      /*              
       pq_cr_historico_pagos_masivo.sp_insertar_FPP001_a(pn_pgcod,
                                       pn_aomod,
                                       pn_aosuc,
                                       pn_aomda,
                                       pn_aopap,
                                       pn_aocta,
                                       pn_aooper,
                                       pn_aosbop,
                                       pn_aotope); 
      */
    
      /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
      /*               
      pq_cr_historico_pagos_masivo.sp_insertar_FPP002_a(pn_pgcod,
                                                      pn_aomod,
                                                      pn_aosuc,
                                                      pn_aomda,
                                                      pn_aopap,
                                                      pn_aocta,
                                                      pn_aooper,
                                                      pn_aosbop,
                                                      pn_aotope);
      */
    
      /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
      /*         
       pq_cr_historico_pagos_masivo.sp_insertar_X054023_a(pn_pgcod,
                                                      pn_aomod,
                                                      pn_aosuc,
                                                      pn_aomda,
                                                      pn_aopap,
                                                      pn_aocta,
                                                      pn_aooper,
                                                      pn_aosbop,
                                                      pn_aotope);
      */
    
      /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
      /*
      pq_cr_historico_pagos_masivo.sp_insertar_FSD012_a(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);      
      */
    
      --end;
    
      --- Final: validación  
    end if;
  
    --end;
    --end if;
  
  end sp_insertar_AQPB064_AQPB002_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_repro_marzo_a is
    lc_flag char(1);
    lc_corr number;
  
    lx_pgcod     number;
    lx_aomod     number;
    lx_aosuc     number;
    lx_aomda     number;
    lx_aopap     number;
    lx_aocta     number;
    lx_aooper    number;
    lx_aosbop    number;
    lx_aotope    number;
    lx_aoobop    number;
    lc_fecha_prv date;
  
    --Cursor AQPB064
    cursor cur_aqpb064 is
      select *
        from aqpb066
      
      ;
  
  begin
  
    lc_fecha_prv := to_date('2020.02.29', 'yyyy.mm.dd');
  
    delete from aqpb066;
    commit;
  
    begin
      insert into aqpb066
        (aqpb066fep,
         aqpb066cor,
         aqpb066emp,
         aqpb066mod,
         aqpb066suc,
         aqpb066mda,
         aqpb066pap,
         aqpb066cta,
         aqpb066ope,
         aqpb066sbo,
         aqpb066top,
         aqpb066tref
         
         )
        select x.aqpb064frepro,
               x.aqpb064ncorre,
               x.aqpb064pgcod,
               x.aqpb064aomod,
               x.aqpb064aosuc,
               x.aqpb064aomda,
               x.aqpb064aopap,
               x.aqpb064aocta,
               x.aqpb064aooper,
               x.aqpb064aosbop,
               x.aqpb064aotope,
               x.aqpb064tablaref
          from aqpb064 x
         where (x.aqpb064pgcod, x.aqpb064aomod,
               --x.aqpb064aosuc,
                x.aqpb064aomda, x.aqpb064aopap, x.aqpb064aocta,
                x.aqpb064aooper,
               --x.aqpb064aosbop,
                x.aqpb064aotope) in
               (select t.aqpb009emp,
                       t.aqpb009mod,
                       --t.aqpb009suc,
                       t.aqpb009mda,
                       t.aqpb009pap,
                       t.aqpb009cta,
                       t.aqpb009ope,
                       --t.aqpb009sbo,
                       t.aqpb009top
                  from aqpb009 t
                 where t.aqpb009fep >= to_date('2020.04.01', 'yyyy.mm.dd'))
           and x.aqpb064orden = 1;
      commit;
    end;
  
    -- Inicio cursor
    ---Recurrido cursor AQPB064
    for i in cur_aqpb064 loop
    
      update aqpb009 y
         set y.aqpb009fep = i.aqpb066fep, y.aqpb009cor = i.aqpb066cor
       where y.aqpb009emp = i.aqpb066emp
         and y.aqpb009mod = i.aqpb066mod
         and
            --suc
             y.aqpb009mda = i.aqpb066mda
         and y.aqpb009pap = i.aqpb066pap
         and y.aqpb009cta = i.aqpb066cta
         and y.aqpb009ope = i.aqpb066ope
         and
            --sub 
             y.aqpb009top = i.aqpb066top
         and y.aqpb009fep > to_date('2020.04.01', 'yyyy.mm.dd');
    
      commit;
    
    end loop;
  
    delete from aqpb066;
    commit;
  
  end sp_repro_marzo_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      

  PROCEDURE sp_insertar_FSD601_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd601(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD601 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for k in jaqz520_fsd601(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
        --Inserción aqpb061
        insert into AQPB061
          (aqpb061pgcod,
           aqpb061mod,
           aqpb061suc,
           aqpb061mda,
           aqpb061pap,
           aqpb061cta,
           aqpb061oper,
           aqpb061sbop,
           aqpb061tope,
           aqpb061fpag,
           aqpb061tipo,
           aqpb061fval,
           aqpb061fvto,
           aqpb061pzo,
           aqpb061cap,
           aqpb061int,
           aqpb061intmex,
           aqpb061icap,
           aqpb061iint,
           aqpb061stat,
           aqpb061nume,
           aqpb061finv,
           aqpb061cd,
           aqpb061mo,
           aqpb061su,
           aqpb061tr,
           aqpb061re,
           aqpb061fc,
           aqpb061or,
           aqpb061sb,
           aqpb061co,
           aqpb061obop)
        
        values
          (k.pgcod,
           k.ppmod,
           k.ppsuc,
           k.ppmda,
           k.pppap,
           k.ppcta,
           k.ppoper,
           pn_aosbop, --k.ppsbop,
           k.pptope,
           k.ppfpag,
           k.pptipo,
           k.ppfval,
           k.ppfvto,
           k.pppzo,
           k.ppcap,
           k.ppint,
           k.ppintmex,
           k.ppicap,
           k.ppiint,
           k.ppstat,
           k.ppnume,
           k.ppfinv,
           k.d601cd,
           k.d601mo,
           k.d601su,
           k.d601tr,
           k.d601re,
           k.d601fc,
           k.d601or,
           k.d601sb,
           k.d601co,
           k.ppsbop);
      exception
        when others then
          --lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             103,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FSD601_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FSD601_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        

  PROCEDURE sp_insertar_FSD602_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd602(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD602 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for m in jaqz520_fsd602(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
        insert into AQPB062
          (aqpb062pgcod,
           aqpb062mod,
           aqpb062suc,
           aqpb062mda,
           aqpb062pap,
           aqpb062cta,
           aqpb062oper,
           aqpb062sbop,
           aqpb062tope,
           aqpb062fpag,
           aqpb062tipo,
           aqpb062nump,
           aqpb062fech,
           aqpb062cap,
           aqpb062int,
           aqpb062intmex,
           aqpb062intm,
           aqpb062intmmex,
           aqpb062icap,
           aqpb062iint,
           aqpb062iintm,
           aqpb062salcap,
           aqpb062salint,
           aqpb062salade,
           aqpb062salmor,
           aqpb062stat,
           aqpb062salintm,
           aqpb062salmorm,
           aqpb062saladem,
           aqpb062cd,
           aqpb062mo,
           aqpb062su,
           aqpb062tr,
           aqpb062re,
           aqpb062fc,
           aqpb062or,
           aqpb062sb,
           aqpb062co,
           aqpb062obop)
        values
          (m.pgcod,
           m.ppmod,
           m.ppsuc,
           m.ppmda,
           m.pppap,
           m.ppcta,
           m.ppoper,
           pn_aosbop, --m.ppsbop,
           m.pptope,
           m.ppfpag,
           m.pptipo,
           m.pp1nump,
           m.pp1fech,
           m.pp1cap,
           m.pp1int,
           m.pp1intmex,
           m.pp1intm,
           m.pp1intmmex,
           m.pp1icap,
           m.pp1iint,
           m.pp1iintm,
           m.pp1salcap,
           m.pp1salint,
           m.pp1salade,
           m.pp1salmor,
           m.pp1stat,
           m.pp1salintm,
           m.pp1salmorm,
           m.pp1saladem,
           m.d602cd,
           m.d602mo,
           m.d602su,
           m.d602tr,
           m.d602re,
           m.d602fc,
           m.d602or,
           m.d602sb,
           m.d602co,
           m.ppsbop);
      exception
        when others then
          --lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             104,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FSD602_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FSD602_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FSD611_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fsd611(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD611 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for p in jaqz520_fsd611(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
      
        insert into AQPB063
          (aqpb063pgcod,
           aqpb063mod,
           aqpb063suc,
           aqpb063mda,
           aqpb063pap,
           aqpb063cta,
           aqpb063oper,
           aqpb063sbop,
           aqpb063tope,
           aqpb063fpag,
           aqpb063tipo,
           aqpb063exte,
           aqpb063imp1,
           aqpb063imp2,
           aqpb063imp3,
           aqpb063imp4,
           aqpb063imp5,
           aqpb063imp6,
           aqpb063imp7,
           aqpb063imp8,
           aqpb063imp9,
           aqpb063imp10,
           aqpb063imp11,
           aqpb063imp12,
           aqpb063imp13,
           aqpb063imp14,
           aqpb063imp15,
           aqpb063imp16,
           aqpb063imp17,
           aqpb063imp18,
           aqpb063imp19,
           aqpb063imp20,
           aqpb063obop)
        values
          (p.pgcod,
           p.ppmod,
           p.ppsuc,
           p.ppmda,
           p.pppap,
           p.ppcta,
           p.ppoper,
           pn_aosbop, -- p.ppsbop,
           p.pptope,
           p.ppfpag,
           p.pptipo,
           p.ppexte,
           p.ppimp1,
           p.ppimp2,
           p.ppimp3,
           p.ppimp4,
           p.ppimp5,
           p.ppimp6,
           p.ppimp7,
           p.ppimp8,
           p.ppimp9,
           p.ppimp10,
           p.ppimp11,
           p.ppimp12,
           p.ppimp13,
           p.ppimp14,
           p.ppimp15,
           p.ppimp16,
           p.ppimp17,
           p.ppimp18,
           p.ppimp19,
           p.ppimp20,
           p.ppsbop);
      exception
        when others then
          --lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             105,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FSD611_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FSD611_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  PROCEDURE sp_insertar_FPP001_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL           
    cursor jaqz520_fpp001(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP001 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for q in jaqz520_fpp001(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
      
        insert into aqpa974
          (aqpa974pgcod,
           aqpa974mod,
           aqpa974suc,
           aqpa974mda,
           aqpa974pap,
           aqpa974cta,
           aqpa974oper,
           aqpa974sbop,
           aqpa974tope,
           aqpa974sgcod,
           aqpa974vc,
           aqpa974imp,
           aqpa974porc,
           aqpa974plus,
           aqpa974part,
           aqpa974veh,
           aqpa974inm,
           aqpa974end,
           aqpa974stat,
           aqpa974co,
           aqpa974aux1,
           aqpa974aux2,
           aqpa974aux3,
           aqpa974aux4,
           aqpa974aux5,
           aqpa974aux6,
           aqpa974aux7,
           aqpa974obop)
        values
          (q.pgcod,
           q.aomod,
           q.aosuc,
           q.aomda,
           q.aopap,
           q.aocta,
           q.aooper,
           pn_aosbop, --q.aosbop,
           q.aotope,
           q.sgcod,
           q.pp001vc,
           q.pp001imp,
           q.pp001porc,
           q.pp001plus,
           q.pp001part,
           q.pp001veh,
           q.pp001inm,
           q.pp001end,
           q.pp001stat,
           q.pp001co,
           q.pp001aux1,
           q.pp001aux2,
           q.pp001aux3,
           q.pp001aux4,
           q.pp001aux5,
           q.pp001aux6,
           q.pp001aux7,
           q.aosbop);
      exception
        when others then
          --lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             106,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FPP001_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FPP001_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_FPP002_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL
    cursor jaqz520_fpp002(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FPP002 t
       where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for r in jaqz520_fpp002(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
      
        insert into aqpa973
          (aqpa973cod,
           aqpa973mod,
           aqpa973suc,
           aqpa973mda,
           aqpa973pap,
           aqpa973cta,
           aqpa973oper,
           aqpa973sbop,
           aqpa973tope,
           aqpa973fpag,
           aqpa973tipo,
           aqpa973estconc,
           aqpa973imp,
           aqpa973stat,
           aqpa973aux1,
           aqpa973aux2,
           aqpa973aux3,
           aqpa973obop)
        values
          (r.pgcod,
           r.ppmod,
           r.ppsuc,
           r.ppmda,
           r.pppap,
           r.ppcta,
           r.ppoper,
           pn_aosbop, --r.ppsbop,
           r.pptope,
           r.ppfpag,
           r.pptipo,
           r.prestconc,
           r.pp002imp,
           r.pp002stat,
           r.pp002aux1,
           r.pp002aux2,
           r.pp002aux3,
           r.ppsbop);
      exception
        when others then
          -- lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             107,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FPP002_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FPP002_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

  PROCEDURE sp_insertar_X054023_b(pn_pgcod  in number,
                                  pn_aomod  in number,
                                  pn_aosuc  in number,
                                  pn_aomda  in number,
                                  pn_aopap  in number,
                                  pn_aocta  in number,
                                  pn_aooper in number,
                                  pn_aosbop in number,
                                  pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL   
    cursor jaqz520_x054023(cr_pgcod  number,
                           cr_aomod  number,
                           cr_aosuc  number,
                           cr_aomda  number,
                           cr_aopap  number,
                           cr_aocta  number,
                           cr_aooper number,
                           cr_aosbop number,
                           cr_aotope number) is
      select *
        from X054023 t
       where t.xllpgcod = cr_pgcod
         and t.xllaomod = cr_aomod
         and t.xllaosuc = cr_aosuc
         and t.xllaomda = cr_aomda
         and t.xllaopap = cr_aopap
         and t.xllaocta = cr_aocta
         and t.xllaooper = cr_aooper
         and t.xllaosbop = cr_aosbop
         and t.xllaotop = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for s in jaqz520_x054023(pn_pgcod,
                             pn_aomod,
                             pn_aosuc,
                             pn_aomda,
                             pn_aopap,
                             pn_aocta,
                             pn_aooper,
                             pn_aosbop,
                             pn_aotope) loop
      begin
      
        insert into aqpb060
          (aqpb060pgcod,
           aqpb060aomod,
           aqpb060aosuc,
           aqpb060aomda,
           aqpb060aopap,
           aqpb060aocta,
           aqpb060aooper,
           aqpb060aosbop,
           aqpb060aotop,
           aqpb060fvalor,
           aqpb060capital,
           aqpb060fprimpa,
           aqpb060cantcuo,
           aqpb060periodo,
           aqpb060tipopre,
           aqpb060tipodia,
           aqpb060tipotas,
           aqpb060tasap,
           aqpb060gradper,
           aqpb060gradpor,
           aqpb060gradimp,
           aqpb060tipoano,
           aqpb060tipdiap,
           aqpb060pcltcod,
           aqpb060pclplus,
           aqpb060pcldrev,
           aqpb060tferp,
           aqpb060cntcuoi,
           aqpb060fpripag,
           aqpb060plazo,
           aqpb060fvto,
           aqpb060modocal,
           aqpb060gracfij,
           aqpb060ciud,
           aqpb060capliq,
           aqpb060medico,
           aqpb060financ,
           aqpb060tasaej,
           aqpb060valcan,
           aqpb060valcuo,
           aqpb060capfin,
           aqpb060impu,
           aqpb060aux1,
           aqpb060aux2,
           aqpb060aux3,
           aqpb060aux4,
           aqpb060aux5,
           aqpb060redon,
           aqpb060aux6,
           aqpb060precio,
           aqpb060aoobop)
        values
          (s.xllpgcod,
           s.xllaomod,
           s.xllaosuc,
           s.xllaomda,
           s.xllaopap,
           s.xllaocta,
           s.xllaooper,
           pn_aosbop, --s.xllaosbop,
           s.xllaotop,
           s.xllfvalor,
           s.xllcapital,
           s.xllfprimpa,
           s.xllcantcuo,
           s.xllperiodo,
           s.xlltipopre,
           s.xlltipodia,
           s.xlltipotas,
           s.xlltasap,
           s.xllgradper,
           s.xllgradpor,
           s.xllgradimp,
           s.xlltipoano,
           s.xlltipdiap,
           s.xllpcltcod,
           s.xllpclplus,
           s.xllpcldrev,
           s.xlltferp,
           s.xllcntcuoi,
           s.xllfpripag,
           s.xllplazo,
           s.xllfvto,
           s.xllmodocal,
           s.xllgracfij,
           s.xllciud,
           s.xllcapliq,
           s.xllmedico,
           s.xllfinanc,
           s.xlltasaej,
           s.xllvalcan,
           s.xllvalcuo,
           s.xllcapfin,
           s.xllimpu,
           s.xllaux1,
           s.xllaux2,
           s.xllaux3,
           s.xllaux4,
           s.xllaux5,
           s.xllredon,
           s.xllaux6,
           s.xllprecio,
           s.xllaosbop);
      exception
        when others then
          -- lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             108,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'X054023_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
      end;
    end loop;
    commit;
  
  end sp_insertar_X054023_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_FSD012_b(pn_pgcod  in number,
                                 pn_aomod  in number,
                                 pn_aosuc  in number,
                                 pn_aomda  in number,
                                 pn_aopap  in number,
                                 pn_aocta  in number,
                                 pn_aooper in number,
                                 pn_aosbop in number,
                                 pn_aotope in number) is
  
    lx_cont   number;
    lc_flag   char(1);
    lc_fecha  date;
    lc_coderr char(100);
    lc_msgerr char(100);
  
    ---ACTUAL: FSD012   
    cursor jaqz520_fsd012(cr_pgcod  number,
                          cr_aomod  number,
                          cr_aosuc  number,
                          cr_aomda  number,
                          cr_aopap  number,
                          cr_aocta  number,
                          cr_aooper number,
                          cr_aosbop number,
                          cr_aotope number) is
      select *
        from FSD012 t
       where t.pgcod = cr_pgcod
         and t.aomod = cr_aomod
         and t.aosuc = cr_aosuc
         and t.aomda = cr_aomda
         and t.aopap = cr_aopap
         and t.aocta = cr_aocta
         and t.aooper = cr_aooper
         and t.aosbop = cr_aosbop
         and t.aotope = cr_aotope;
  
  begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    for u in jaqz520_fsd012(pn_pgcod,
                            pn_aomod,
                            pn_aosuc,
                            pn_aomda,
                            pn_aopap,
                            pn_aocta,
                            pn_aooper,
                            pn_aosbop,
                            pn_aotope) loop
      begin
      
        insert into AQPA975
          (aqpa975cod,
           aqpa975mod,
           aqpa975suc,
           aqpa975mda,
           aqpa975pap,
           aqpa975cta,
           aqpa975oper,
           aqpa975sbop,
           aqpa975tope,
           aqpa975corr,
           aqpa975tipo,
           aqpa975fval,
           aqpa975fvto,
           aqpa975imp,
           aqpa975ttas,
           aqpa975tasa,
           aqpa975cap,
           aqpa975int,
           aqpa975mor,
           aqpa975scap,
           aqpa975sint,
           aqpa975smor,
           aqpa975intc,
           aqpa975morc,
           aqpa975cd01,
           aqpa975cd02,
           aqpa975inv,
           aqpa975per,
           aqpa975tcbi,
           aqpa975tcbi1,
           aqpa975arb,
           aqpa975arb1,
           aqpa975md,
           aqpa975md1,
           aqpa975pre,
           aqpa975pre1,
           aqpa975cd,
           aqpa975mo,
           aqpa975su,
           aqpa975tr,
           aqpa975re,
           aqpa975fc,
           aqpa975or,
           aqpa975sb,
           aqpa975co,
           aqpa975obop)
        values
          (u.pgcod,
           u.aomod,
           u.aosuc,
           u.aomda,
           u.aopap,
           u.aocta,
           u.aooper,
           pn_aosbop, --u.aosbop,
           u.aotope,
           u.evcorr,
           u.evtipo,
           u.evfval,
           u.evfvto,
           u.evimp,
           u.evttas,
           u.evtasa,
           u.evcap,
           u.evint,
           u.evmor,
           u.evscap,
           u.evsint,
           u.evsmor,
           u.evintc,
           u.evmorc,
           u.evcd01,
           u.evcd02,
           u.evinv,
           u.evper,
           u.evtcbi,
           u.evtcbi1,
           u.evarb,
           u.evarb1,
           u.evmd,
           u.evmd1,
           u.evpre,
           u.evpre1,
           u.d012cd,
           u.d012mo,
           u.d012su,
           u.d012tr,
           u.d012re,
           u.d012fc,
           u.d012or,
           u.d012sb,
           u.d012co,
           u.aosbop);
      exception
        when others then
          -- lc_flag := 'N';
        
          lc_coderr := sqlcode;
          lc_msgerr := substr(trim(sqlerrm), 1, 90);
        
          insert into aqpb066
            (aqpb066fep,
             aqpb066cor,
             aqpb066emp,
             aqpb066mod,
             aqpb066suc,
             aqpb066mda,
             aqpb066pap,
             aqpb066cta,
             aqpb066ope,
             aqpb066sbo,
             aqpb066top,
             aqpb066tref,
             aqpb066etip,
             aqpb066eacoe,
             aqpb066eamsge)
          values
            (lc_fecha,
             109,
             pn_pgcod,
             pn_aomod,
             pn_aosuc,
             pn_aomda,
             pn_aopap,
             pn_aocta,
             pn_aooper,
             pn_aosbop,
             pn_aotope,
             'FSD012_b',
             'P',
             lc_coderr,
             lc_msgerr);
          commit;
        
      end;
    end loop;
    commit;
  
  end sp_insertar_FSD012_b;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

end pq_cr_historico_pagos_masivo;

/*sp_insertar_hsd010
    cursor jaqa698
   sp_insertar_jaqz698
      insertar de los backups a hsd010
      cursor de fsd601 (backup)
             insertar en hsd601
      
    cursor aqpb002  
   sp_insertar_aqpb002
      insertar de los backups a hsd010



cursor de fsd601 (backup)
             insertar en hsd601*/
/

