create or replace package pq_cr_historico_pagos_repro is

  -- *****************************************************************
  -- Nombre                       : PQ_CR_HISTORICO_PAGOS_REPRO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización de nomenclatura de tablas
  -- *****************************************************************

  PROCEDURE sp_insertar_AQPB074(pn_fecha in date);
  
  PROCEDURE sp_insertar_AQPB074_JAQZ698(pn_fecha in date,
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
                                        
  PROCEDURE sp_insertar_AQPB074_AQPB088(pn_fecha in date,
                                        pn_corr in number, 
                                        --pn_inst in number, 
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
  
  PROCEDURE sp_insertar_AQPB074_AQPB002(pn_fecha in date, 
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
                                     
  PROCEDURE sp_insertar_AQPB075_grupo1(pn_fecha in date, 
                                       pn_corr in number, 
                                       pn_fecha_prev in date,
                                       
                                       PGCOD number,
                                       PPMOD number,
                                       PPSUC number,
                                       PPMDA number,
                                       PPPAP number,
                                       PPCTA number,
                                       PPOPER number,
                                       PPSBOP number,
                                       PPTOPE number);  
           
 PROCEDURE sp_insertar_AQPB075_grupo2(pn_fecpro date, 
                                      pn_corr number, 
                                      pn_fecha_prev in date, 
                                      pn_fecha_inst in date,
                                      pn_corr_inst in number,
                                      
                                      PGCOD number,
                                      PPMOD number,
                                      PPSUC number,
                                      PPMDA number,
                                      PPPAP number,
                                      PPCTA number,
                                      PPOPER number,
                                      PPSBOP number,
                                      PPTOPE number);  
 
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
                                
 PROCEDURE sp_insertar_AQPB074_ini(pn_fecha_ini in date,
                                   pn_fecha_fin in date,
                                   pn_digito    in number);
                                
 procedure sp_cr_job_carga(pn_fecha_ini in date,pn_fecha_fin in date); 
 
   PROCEDURE sp_eliminar_AQPB074(pn_fecha in date);
 
 PROCEDURE sp_insertar_HSD010_a(pn_suc in number, pn_fecha in date);
  
  PROCEDURE sp_insertar_HSD010_JAQZ698_a(pn_fecha in date,
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
  
  PROCEDURE sp_insertar_HSD010_AQPB002_a( pn_fecha in date, 
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
                                      --,pn_aosdo in aqpb002.aqpb002sdo%type
                                     );  
                                     
  PROCEDURE sp_insertar_HSD601_grupo1_a(
           pn_fecha in date, 
           pn_corr in number, 
           pn_fecha_prev in date,
           
           PGCOD number,
           PPMOD number,
           PPSUC number,
           PPMDA number,
           PPPAP number,
           PPCTA number,
           PPOPER number,
           PPSBOP number,
           PPTOPE number);  
           
 PROCEDURE sp_insertar_HSD601_grupo2_a(pn_fecpro date, 
                                pn_corr number, 
                                pn_fecha_prev in date, 
                                pn_fecha_inst in date,
                                pn_corr_inst in number,
                                
                                PGCOD number,
                                PPMOD number,
                                PPSUC number,
                                PPMDA number,
                                PPPAP number,
                                PPCTA number,
                                PPOPER number,
                                PPSBOP number,
                                PPTOPE number);  
 
 PROCEDURE sp_insertar_JAQZ520_010_a( pn_fecha in date, 
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
                                   
 PROCEDURE sp_insertar_AQPA004_a( pn_fecha in date, 
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
                                
  
  
 procedure sn_dias_atraso_h(
                                           v_Pgfape in date, --fecha de proceso
                                           v_Pgcod  in number,
                                           v_Scmod  in number,
                                           v_Scsuc  in number,
                                           v_Scmda  in number,
                                           v_Scpap  in number,
                                           v_Sccta  in number,
                                           v_Scoper in number,
                                           v_Scsbop in number,
                                           v_Sctope in number,
                                           v_Scstat in number,
                                           v_fecven in date,
                                           v_fecval in date,
                                           v_period in number,
                                           pn_diaatr out number,
                                           pn_diagra out  number,
                                           pd_fepvep  out date,
                                           pd_feppk  out  date,
                                           pn_ncpr out  number,
                                           pn_ncpa  out number,
                                           pn_diatrc out number
                                         ) ; 
Procedure sp_job_procesa_HSD010_a(pd_fecpro in date ) ;  
PROCEDURE sp_insertar_AQPB074_AQPB088_a(pn_fecha      in date,
                                        pn_corr       in number,
                                        --pn_inst       in number,
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
                                        pn_aotope in number);                                                                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
Procedure sp_job_procesa_HSD010_088(pd_fecpro in date ) ;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
PROCEDURE sp_insertar_HSD010_088(pn_suc in number, pn_fecha in date);                                                                                  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 procedure sp_cr_job_carga_088(pn_fecha_ini in date,pn_fecha_fin in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
 PROCEDURE sp_insertar_AQPB074_088(pn_fecha_ini in date,
                                   pn_fecha_fin in date,
                                   pn_digito    in number);  
  

end pq_cr_historico_pagos_repro;
/

create or replace package body pq_cr_historico_pagos_repro is

  -- *****************************************************************
  -- Nombre                       : PQ_CR_HISTORICO_PAGOS_REPRO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización de nomenclatura de tablas
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB074(pn_fecha in date) is
  
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
       
     -- Cursor AQPB088
    cursor cur_aqpb088(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb088 j, jaqa400 t
       where j.aqpb088est = 'C'
         and j.aqpb088fep >= cr_fecha_ini
         and j.aqpb088fep <= cr_fecha_fin
         and t.jaqa400est = 'C'
         and j.aqpb088cor = (
                 select min(x.aqpb088cor) from aqpb088 x
                 where
                 x.aqpb088fep = j.aqpb088fep and
                 x.aqpb088emp = j.aqpb088emp and
                 x.aqpb088mod = j.aqpb088mod and
                 x.aqpb088suc = j.aqpb088suc and
                 x.aqpb088mda = j.aqpb088mda and
                 x.aqpb088pap = j.aqpb088pap and
                 x.aqpb088cta = j.aqpb088cta and
                 x.aqpb088ope = j.aqpb088ope and
                 x.aqpb088sbo = j.aqpb088sbo and
                 x.aqpb088top = j.aqpb088top
             ) and
                 j.aqpb088fep = t.jaqa400fec and
                 j.aqpb088emp = t.jaqa400emp and
                 j.aqpb088mod = t.jaqa400mod and
                 j.aqpb088suc = t.jaqa400suc and
                 j.aqpb088mda = t.jaqa400mda and
                 j.aqpb088pap = t.jaqa400pap and
                 j.aqpb088cta = t.jaqa400cta and
                 j.aqpb088ope = t.jaqa400ope and
                 j.aqpb088sbo = t.jaqa400sbo and
                 j.aqpb088top = t.jaqa400top
       order by j.aqpb088fep, j.aqpb088cor asc;        
  
  Begin
  
    lc_fecha_fin := pn_fecha;
    lc_fecha_ini := trunc(lc_fecha_fin) -
                    (to_number(to_char(lc_fecha_fin, 'DD')) - 1);
    lc_fecha_prv := lc_fecha_ini - 1;
    --lc_fecha_ini := '02/05/2020';
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Recurrido cursor JAQZ698
      
      for i in cur_jaqz698(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_JAQZ698(i.jaqz698fep,
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
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB002(j.aqpb002fep,
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
      
      ---Recurrido cursor AQPB088
      for i in cur_aqpb088(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB088(i.aqpb088fep,
                                                                i.aqpb088cor,
                                                                --i.jaqz698inst,
                                                                lc_fecha_prv,
                                                                i.aqpb088est,
                                                                
                                                                i.aqpb088emp,
                                                                i.aqpb088mod,
                                                                i.aqpb088suc,
                                                                i.aqpb088mda,
                                                                i.aqpb088pap,
                                                                i.aqpb088cta,
                                                                i.aqpb088ope,
                                                                i.aqpb088sbo,
                                                                i.aqpb088top);
      
      end loop;    
        
    
    end;
  
  end sp_insertar_AQPB074;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB074_JAQZ698(pn_fecha      in date,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    lx_orden number;
  
    -- Detalle
    cursor jaqz520_601c(cr_fecha  date,
                        cr_corr   number,
                        cr_pgcod  in number,
                        cr_aomod  in number,
                        cr_aosuc  in number,
                        cr_aomda  in number,
                        cr_aopap  in number,
                        cr_aocta  in number,
                        cr_aooper in number,
                        cr_aosbop in number,
                        cr_aotope in number) is
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
      
        select q.pgcod, --lx_pgcod,
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
               q.aoperiod --lx_aoperiod
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, --
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, --
               lx_aotope, --
               lx_aofval, --
               lx_aofvto, --
               
               lx_aopzo, --
               lx_aotasa, --
               lx_aoimp, --
               lx_aostat, --
               lx_aofe99, --
               lx_aoperiod --
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
      
        /****************************/
      
        begin
          select nvl(max(x.AQPB074orde), 0) + 1
            into lx_orden
            from AQPB074 x
           where x.AQPB074cod = pn_pgcod
             and x.AQPB074mod = pn_aomod
             and x.AQPB074suc = pn_aosuc
             and x.AQPB074mda = pn_aomda
             and x.AQPB074pap = pn_aopap
             and x.AQPB074cta = pn_aocta
             and x.AQPB074oper = pn_aooper
             and x.AQPB074sbop = pn_aosbop
             and x.AQPB074tope = pn_aotope
             and x.AQPB074fppk is null;
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
        ---lx_estado := 'R'; ---REPROGRAMADO ---en abril puede cambiar
        if (pn_revr = 'V') then
          lx_estado := 'X';
        else
          lx_estado := 'R';
        end if;
      
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
        insert into AQPB074
          (AQPB074cod, --pgcod, 
           AQPB074mod, --aomod,
           AQPB074suc, --aosuc,
           AQPB074mda, --aomda,
           AQPB074pap, --aopap,
           AQPB074cta, --aocta,
           AQPB074oper, --aooper,
           AQPB074sbop, --aosbop,
           AQPB074tope, --aotope,
           AQPB074fval, --aofval,
           AQPB074fvto, --aofvto,
           AQPB074pzo, --aopzo,
           AQPB074tasa, --aotasa,
           AQPB074imp, --aoimp,
           AQPB074stat, --aostat,
           AQPB074fe99, --aofe99,
           AQPB074peri, --aoperiod,  
           AQPB074frep, --frepro,  
           AQPB074ncor, --ncorre, 
           AQPB074proc, --proceso, 
           AQPB074fcie, --fcierre, 
           AQPB074inst, --instanc,  
           AQPB074est, --estado,  
           AQPB074fece, --fecest,  
           AQPB074sdo, --scsdo,
           AQPB074tabr, --tablaref,
           AQPB074orde --orden 
           )
        values
          (lx_pgcod,
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope,
           lx_aofval,
           lx_aofvto,
           lx_aopzo,
           lx_aotasa,
           lx_aoimp,
           lx_aostat,
           lx_aofe99,
           lx_aoperiod,
           lx_frepro,
           lx_ncorre,
           lx_proceso,
           lx_fcierre,
           lx_instanc,
           lx_estado,
           lx_fecest,
           lx_scsdo,
           'JAQZ698',
           lx_orden);
      
        commit;
      
        /*********** INSERTAR DETALLE *****************/
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
            insert into AQPB075
              (AQPB075cod, --pgcod,  ---jjaqz520_601c
               AQPB075mod, --ppmod,
               AQPB075suc, --ppsuc,
               AQPB075mda, --ppmda,
               AQPB075pap, --pppap,
               AQPB075cta, --ppcta,
               AQPB075oper, --ppoper,
               AQPB075sbop, --ppsbop,
               AQPB075tope, --pptope,  
               AQPB075fpag, --ppfpag,
               AQPB075tipo, --pptipo,
               AQPB075fval, --ppfval,
               AQPB075fvto, --ppfvto,
               AQPB075pzo, --pppzo,
               AQPB075cap, --ppcap,
               AQPB075int, --ppint,
               AQPB075intmex, --ppintmex,
               AQPB075icap, --ppicap,
               AQPB075iint, --ppiint,
               AQPB075stat, --ppstat,
               AQPB075nume, --ppnume,
               AQPB075finv, --ppfinv,  
               AQPB075frep, --frepro,  
               AQPB075ncor, --ncorre,
               AQPB075fecc, --feccie, 
               AQPB075proc, --proceso, 
               AQPB075tabr --tablaref
               )
            
            values
              (k.pgcod, -- lx_pgcod, 
               k.ppmod, --lx_ppmod,
               k.ppsuc, --lx_ppsuc,
               k.ppmda, --lx_ppmda,
               k.pppap, --lx_pppap,
               k.ppcta, -- lx_ppcta,
               k.ppoper, --lx_ppoper,
               k.ppsbop, --lx_ppsbop,
               k.pptope, --lx_pptope,
               k.ppfpag, --lx_ppfpag,
               k.pptipo, --lx_pptipo,
               k.ppfval, --lx_ppfval,
               k.ppfvto, --lx_ppfvto,
               k.pppzo, --lx_pppzo,
               k.ppcap, --lx_ppcap,
               k.ppint, --lx_ppint,
               k.ppintmex, --lx_ppintmex,
               k.ppicap, --lx_ppicap,
               k.ppiint, --lx_ppiint,
               k.ppstat, --lx_ppstat,
               k.ppnume, --lx_ppnume,
               k.ppfinv, --lx_ppfinv,
               
               pn_fecha, --lx_frepro,
               pn_corr, --lx_ncorre,
               pn_fecha_prev, --lx_feccie,
               'C', --lx_proceso  
               'JAQZ698');
            commit;
          
          exception
            when others then
              lc_flag := 'N';
          end;
        end loop;
      
      end;
    end if;
  
  end sp_insertar_AQPB074_JAQZ698;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  PROCEDURE sp_insertar_AQPB074_AQPB088(pn_fecha      in date,
                                        pn_corr       in number,
                                        --pn_inst       in number,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    lx_orden number;
  
    -- Detalle
    cursor jaqz520_601c(cr_fecha  date,
                        cr_corr   number,
                        cr_pgcod  in number,
                        cr_aomod  in number,
                        cr_aosuc  in number,
                        cr_aomda  in number,
                        cr_aopap  in number,
                        cr_aocta  in number,
                        cr_aooper in number,
                        cr_aosbop in number,
                        cr_aotope in number) is
      select *
        from aqpb088_601c t
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
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from aqpb088_010c q
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
      
        select q.pgcod, --lx_pgcod,
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
               q.aoperiod --lx_aoperiod
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, --
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, --
               lx_aotope, --
               lx_aofval, --
               lx_aofvto, --
               
               lx_aopzo, --
               lx_aotasa, --
               lx_aoimp, --
               lx_aostat, --
               lx_aofe99, --
               lx_aoperiod --
          from aqpb088_010c q
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
      
        /****************************/
      
        begin
          select nvl(max(x.AQPB074orde), 0) + 1
            into lx_orden
            from AQPB074 x
           where x.AQPB074cod = pn_pgcod
             and x.AQPB074mod = pn_aomod
             and x.AQPB074suc = pn_aosuc
             and x.AQPB074mda = pn_aomda
             and x.AQPB074pap = pn_aopap
             and x.AQPB074cta = pn_aocta
             and x.AQPB074oper = pn_aooper
             and x.AQPB074sbop = pn_aosbop
             and x.AQPB074tope = pn_aotope
             and x.AQPB074fppk is null;
        exception
          when others then
            lx_orden := 1;
        end;
      
        /****************************/
      
        lx_frepro  := pn_fecha;
        lx_ncorre  := pn_corr;
        lx_proceso := 'C'; ---CAPITALIZACION
        lx_fcierre := pn_fecha_prev; --lc_fecha_prv;
        --lx_instanc := pn_inst;

        if (pn_revr = 'V') then
          lx_estado := 'X';
        else
          lx_estado := 'R';
        end if;
      
        lx_fecest := pn_fecha;
      
        /****************************/
      
        select nvl(sum(r.scsdo), 0)
          into lx_scsdo
          from aqpb088_011c r
         where r.fec = pn_fecha
           and r.cor = pn_corr
           
           and r.pgcod = pn_pgcod
           and r.scmod = pn_aomod
           and r.scsuc = pn_aosuc
           and r.scmda = pn_aomda
           and r.scpap = pn_aopap
           and r.sccta = pn_aocta
           and r.scoper = pn_aooper
           and r.scsbop = pn_aosbop
           and r.sctope = pn_aotope;
      
        /****************************/
        insert into AQPB074
          (AQPB074cod, --pgcod, 
           AQPB074mod, --aomod,
           AQPB074suc, --aosuc,
           AQPB074mda, --aomda,
           AQPB074pap, --aopap,
           AQPB074cta, --aocta,
           AQPB074oper, --aooper,
           AQPB074sbop, --aosbop,
           AQPB074tope, --aotope,
           AQPB074fval, --aofval,
           AQPB074fvto, --aofvto,
           AQPB074pzo, --aopzo,
           AQPB074tasa, --aotasa,
           AQPB074imp, --aoimp,
           AQPB074stat, --aostat,
           AQPB074fe99, --aofe99,
           AQPB074peri, --aoperiod,  
           AQPB074frep, --frepro,  
           AQPB074ncor, --ncorre, 
           AQPB074proc, --proceso, 
           AQPB074fcie, --fcierre, 
           --AQPB074inst, --instanc,  
           AQPB074est, --estado,  
           AQPB074fece, --fecest,  
           AQPB074sdo, --scsdo,
           AQPB074tabr, --tablaref,
           AQPB074orde --orden 
           )
        values
          (lx_pgcod,
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope,
           lx_aofval,
           lx_aofvto,
           lx_aopzo,
           lx_aotasa,
           lx_aoimp,
           lx_aostat,
           lx_aofe99,
           lx_aoperiod,
           lx_frepro,
           lx_ncorre,
           lx_proceso,
           lx_fcierre,
           --lx_instanc,
           lx_estado,
           lx_fecest,
           lx_scsdo,
           'JAQA400',
           lx_orden);
      
        commit;
      
        /*********** INSERTAR DETALLE *****************/
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
            insert into AQPB075
              (AQPB075cod, --pgcod,  ---jjaqz520_601c
               AQPB075mod, --ppmod,
               AQPB075suc, --ppsuc,
               AQPB075mda, --ppmda,
               AQPB075pap, --pppap,
               AQPB075cta, --ppcta,
               AQPB075oper, --ppoper,
               AQPB075sbop, --ppsbop,
               AQPB075tope, --pptope,  
               AQPB075fpag, --ppfpag,
               AQPB075tipo, --pptipo,
               AQPB075fval, --ppfval,
               AQPB075fvto, --ppfvto,
               AQPB075pzo, --pppzo,
               AQPB075cap, --ppcap,
               AQPB075int, --ppint,
               AQPB075intmex, --ppintmex,
               AQPB075icap, --ppicap,
               AQPB075iint, --ppiint,
               AQPB075stat, --ppstat,
               AQPB075nume, --ppnume,
               AQPB075finv, --ppfinv,  
               AQPB075frep, --frepro,  
               AQPB075ncor, --ncorre,
               AQPB075fecc, --feccie, 
               AQPB075proc, --proceso, 
               AQPB075tabr --tablaref
               )
            
            values
              (k.pgcod, -- lx_pgcod, 
               k.ppmod, --lx_ppmod,
               k.ppsuc, --lx_ppsuc,
               k.ppmda, --lx_ppmda,
               k.pppap, --lx_pppap,
               k.ppcta, -- lx_ppcta,
               k.ppoper, --lx_ppoper,
               k.ppsbop, --lx_ppsbop,
               k.pptope, --lx_pptope,
               k.ppfpag, --lx_ppfpag,
               k.pptipo, --lx_pptipo,
               k.ppfval, --lx_ppfval,
               k.ppfvto, --lx_ppfvto,
               k.pppzo, --lx_pppzo,
               k.ppcap, --lx_ppcap,
               k.ppint, --lx_ppint,
               k.ppintmex, --lx_ppintmex,
               k.ppicap, --lx_ppicap,
               k.ppiint, --lx_ppiint,
               k.ppstat, --lx_ppstat,
               k.ppnume, --lx_ppnume,
               k.ppfinv, --lx_ppfinv,
               
               pn_fecha, --lx_frepro,
               pn_corr, --lx_ncorre,
               pn_fecha_prev, --lx_feccie,
               'C', --lx_proceso  
               'JAQA400');
            commit;
          
          exception
            when others then
              lc_flag := 'N';
          end;
        end loop;
      
      end;
    end if;
  
  end sp_insertar_AQPB074_AQPB088;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB074_AQPB002(pn_fecha      in date,
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
        pq_cr_historico_pagos_repro.sp_insertar_JAQZ520_010(pn_fecha,
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
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPA004(lc_fecha_desp,
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
  
  end sp_insertar_AQPB074_AQPB002;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB075_grupo1(pn_fecha      in date,
                                       pn_corr       in number,
                                       pn_fecha_prev in date,
                                       PGCOD         number,
                                       PPMOD         number,
                                       PPSUC         number,
                                       PPMDA         number,
                                       PPPAP         number,
                                       PPCTA         number,
                                       PPOPER        number,
                                       PPSBOP        number,
                                       PPTOPE        number) is
  
    --- grupo 1
    cursor grupo1_jaqz520_601(pn_PGCOD  number,
                              pn_PPMOD  number,
                              pn_PPSUC  number,
                              pn_PPMDA  number,
                              pn_PPPAP  number,
                              pn_PPCTA  number,
                              pn_PPOPER number,
                              pn_PPSBOP number,
                              pn_PPTOPE number) is
    
      select *
        from jaqz520_601 t
       where t.PGCOD = pn_PGCOD
         and t.PPMOD = pn_PPMOD
         and t.PPSUC = pn_PPSUC
         and t.PPMDA = pn_PPMDA
         and t.PPPAP = pn_PPPAP
         and t.PPCTA = pn_PPCTA
         and t.PPOPER = pn_PPOPER
         and t.PPSBOP = pn_PPSBOP
         and t.PPTOPE = pn_PPTOPE
       order by t.ppfpag asc;
  
  begin
  
    for p in grupo1_jaqz520_601(PGCOD,
                                PPMOD,
                                PPSUC,
                                PPMDA,
                                PPPAP,
                                PPCTA,
                                PPOPER,
                                PPSBOP,
                                PPTOPE) loop
    
      begin
      
        insert into AQPB075
          (AQPB075cod, --pgcod,  ---jjaqz520_601c
           AQPB075mod, --ppmod,
           AQPB075suc, --ppsuc,
           AQPB075mda, --ppmda,
           AQPB075pap, --pppap,
           AQPB075cta, --ppcta,
           AQPB075oper, --ppoper,
           AQPB075sbop, --ppsbop,
           AQPB075tope, --pptope,  
           AQPB075fpag, --ppfpag,
           AQPB075tipo, --pptipo,
           AQPB075fval, --ppfval,
           AQPB075fvto, --ppfvto,
           AQPB075pzo, --pppzo,
           AQPB075cap, --ppcap,
           AQPB075int, --ppint,
           AQPB075intmex, --ppintmex,
           AQPB075icap, --ppicap,
           AQPB075iint, --ppiint,
           AQPB075stat, --ppstat,
           AQPB075nume, --ppnume,
           AQPB075finv, --ppfinv,  ---jaqz520_601c
           AQPB075frep, --frepro,  
           AQPB075ncor, --ncorre,
           AQPB075fecc, --feccie, 
           AQPB075proc, --proceso,  
           AQPB075tabr --tablaref
           )
        
        values
          (p.pgcod, -- lx_pgcod, 
           p.ppmod, --lx_ppmod,
           p.ppsuc, --lx_ppsuc,
           p.ppmda, --lx_ppmda,
           p.pppap, --lx_pppap,
           p.ppcta, -- lx_ppcta,
           p.ppoper, --lx_ppoper,
           p.ppsbop, --lx_ppsbop,
           p.pptope, --lx_pptope,
           p.ppfpag, --lx_ppfpag,
           p.pptipo, --lx_pptipo,
           p.ppfval, --lx_ppfval,
           p.ppfvto, --lx_ppfvto,
           p.pppzo, --lx_pppzo,
           p.ppcap, --lx_ppcap,
           p.ppint, --lx_ppint,
           p.ppintmex, --lx_ppintmex,
           p.ppicap, --lx_ppicap,
           p.ppiint, --lx_ppiint,
           p.ppstat, --lx_ppstat,
           p.ppnume, --lx_ppnume,
           p.ppfinv, --lx_ppfinv,
           pn_fecha, --lx_frepro,
           pn_corr, --lx_ncorre,
           pn_fecha_prev, --lx_feccie,
           'R', --lx_proceso  
           'AQPB002');
      
      end;
    
    end loop;
    commit;
  
  end sp_insertar_AQPB075_grupo1;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB075_grupo2(pn_fecpro     date,
                                       pn_corr       number,
                                       pn_fecha_prev in date,
                                       pn_fecha_inst in date,
                                       pn_corr_inst  in number,
                                       
                                       PGCOD  number,
                                       PPMOD  number,
                                       PPSUC  number,
                                       PPMDA  number,
                                       PPPAP  number,
                                       PPCTA  number,
                                       PPOPER number,
                                       PPSBOP number,
                                       PPTOPE number) is
  
    cursor grupo2_aqpa006(fecpro    date,
                          corr      number,
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
       where t.aqpa006fecpro = fecpro
         and t.aqpa006cor = corr
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
  
  begin
  
    for g in grupo2_aqpa006(pn_fecpro,
                            pn_corr,
                            PGCOD,
                            PPMOD,
                            PPSUC,
                            PPMDA,
                            PPPAP,
                            PPCTA,
                            PPOPER,
                            PPSBOP,
                            PPTOPE) loop
    
      begin
      
        insert into AQPB075
          (AQPB075cod, --pgcod,  ---jjaqz520_601c
           AQPB075mod, --ppmod,
           AQPB075suc, --ppsuc,
           AQPB075mda, --ppmda,
           AQPB075pap, --pppap,
           AQPB075cta, --ppcta,
           AQPB075oper, --ppoper,
           AQPB075sbop, --ppsbop,
           AQPB075tope, --pptope,  
           AQPB075fpag, --ppfpag,
           AQPB075tipo, --pptipo,
           AQPB075fval, --ppfval,
           AQPB075fvto, --ppfvto,
           AQPB075pzo, --pppzo,
           AQPB075cap, --ppcap,
           AQPB075int, --ppint,
           AQPB075intmex, --ppintmex,
           AQPB075icap, --ppicap,
           AQPB075iint, --ppiint,
           AQPB075stat, --ppstat,
           AQPB075nume, --ppnume,
           AQPB075finv, --ppfinv,  
           AQPB075frep, --frepro, 
           AQPB075ncor, --ncorre,
           AQPB075fecc, --feccie, 
           AQPB075proc, --proceso,  
           AQPB075tabr --tablaref
           )
        values
          (g.aqpa006cod, -- lx_pgcod, 
           g.aqpa006mod, --lx_ppmod,
           g.aqpa006suc, --lx_ppsuc,
           g.aqpa006mda, --lx_ppmda,
           g.aqpa006pap, --lx_pppap,
           g.aqpa006cta, -- lx_ppcta,
           g.aqpa006oper, --lx_ppoper,
           g.aqpa006sbop, --lx_ppsbop,
           g.aqpa006tope, --lx_pptope,
           g.aqpa006fpag, --lx_ppfpag,
           g.aqpa006tipo, --lx_pptipo,
           g.aqpa006fval, --lx_ppfval,
           g.aqpa006fvto, --lx_ppfvto,
           g.aqpa006pzo, --lx_pppzo,
           g.aqpa006cap, --lx_ppcap,
           g.aqpa006int, --lx_ppint,
           g.aqpa006intmex, --lx_ppintmex,
           g.aqpa006icap, --lx_ppicap,
           g.aqpa006iint, --lx_ppiint,
           g.aqpa006stat, --lx_ppstat,
           g.aqpa006nume, --lx_ppnume,
           g.aqpa006finv, --lx_ppfinv,
           pn_fecha_inst, --lx_frepro,
           pn_corr_inst, --lx_ncorre,
           pn_fecha_prev, --lx_feccie,
           'R', --lx_proceso  
           'AQPB002');
      
      end;
    
    end loop;
    commit;
  
  end sp_insertar_AQPB075_grupo2;

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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    lx_orden number;
  
  begin
  
    begin
      ---1. Inicio
    
      select q.pgcod, --lx_pgcod,
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
             q.aoperiod --lx_aoperiod
        into lx_pgcod, --
             lx_aomod, --
             lx_aosuc, --
             lx_aomda, --
             lx_aopap, --
             lx_aocta, --
             lx_aooper, --
             lx_aosbop, --
             lx_aotope, --
             lx_aofval, --
             lx_aofvto, --
             
             lx_aopzo, --
             lx_aotasa, --
             lx_aoimp, --
             lx_aostat, --
             lx_aofe99, --
             lx_aoperiod --
        from JAQZ520_010 q ----FSD010
       where q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
         and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = pn_aosbop
         and q.aotope = pn_aotope;
    
      /****************************/
      begin
        select nvl(max(x.AQPB074orde), 0) + 1
          into lx_orden
          from AQPB074 x
         where x.AQPB074cod = pn_pgcod
           and x.AQPB074mod = pn_aomod
           and x.AQPB074suc = pn_aosuc
           and x.AQPB074mda = pn_aomda
           and x.AQPB074pap = pn_aopap
           and x.AQPB074cta = pn_aocta
           and x.AQPB074oper = pn_aooper
           and x.AQPB074sbop = pn_aosbop
           and x.AQPB074tope = pn_aotope
           and x.AQPB074fppk is null;
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
      insert into AQPB074
        (AQPB074cod, --pgcod, 
         AQPB074mod, --aomod,
         AQPB074suc, --aosuc,
         AQPB074mda, --aomda,
         AQPB074pap, --aopap,
         AQPB074cta, --aocta,
         AQPB074oper, --aooper,
         AQPB074sbop, --aosbop,
         AQPB074tope, --aotope,
         AQPB074fval, --aofval,
         AQPB074fvto, --aofvto,
         AQPB074pzo, --aopzo,
         AQPB074tasa, --aotasa,
         AQPB074imp, --aoimp,
         AQPB074stat, --aostat,
         AQPB074fe99, --aofe99,
         AQPB074peri, --aoperiod,
         AQPB074frep, --frepro, 
         AQPB074ncor, --ncorre, 
         AQPB074proc, --proceso, 
         AQPB074fcie, --fcierre, 
         AQPB074inst, --instanc, 
         AQPB074est, --estado,  
         AQPB074fece, --fecest,   
         AQPB074sdo, --scsdo,
         AQPB074tabr, --tablaref,
         AQPB074orde --orden  
         )
      values
        (lx_pgcod, --
         lx_aomod, --
         lx_aosuc, --
         lx_aomda, --
         lx_aopap, --
         lx_aocta, --
         lx_aooper, --
         lx_aosbop, --
         lx_aotope, --
         lx_aofval, --
         lx_aofvto, --
         lx_aopzo, --
         lx_aotasa, --
         lx_aoimp, --
         lx_aostat, --
         lx_aofe99, --
         lx_aoperiod, --
         lx_frepro,
         lx_ncorre,
         lx_proceso,
         lx_fcierre,
         lx_instanc,
         lx_estado,
         lx_fecest,
         lx_scsdo,
         'AQPB002',
         lx_orden);
    
      commit;
    
      /*-------------------------*/
      ---Detalle GRUPO1
      /*-------------------------*/
      pq_cr_historico_pagos_repro.sp_insertar_AQPB075_grupo1(pn_fecha, --lx_frepro,
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
    
      ---2. Fin
    exception
      when others then
        lx_orden := 1;
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    lx_orden number;
  
  begin
  
    begin
      ---1. Inicio
    
      select q.aqpa004cod, --lx_pgcod,
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
             q.aqpa004period --lx_aoperiod
        into lx_pgcod, --
             lx_aomod, --
             lx_aosuc, --
             lx_aomda, --
             lx_aopap, --
             lx_aocta, --
             lx_aooper, --
             lx_aosbop, --
             lx_aotope, --
             lx_aofval, --
             lx_aofvto, --
             lx_aopzo, --
             lx_aotasa, --
             lx_aoimp, --
             lx_aostat, --
             lx_aofe99, --
             lx_aoperiod --
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
    
      /****************************/
      begin
        select nvl(max(x.AQPB074orde), 0) + 1
          into lx_orden
          from AQPB074 x
         where x.AQPB074cod = pn_pgcod
           and x.AQPB074mod = pn_aomod
           and x.AQPB074suc = pn_aosuc
           and x.AQPB074mda = pn_aomda
           and x.AQPB074pap = pn_aopap
           and x.AQPB074cta = pn_aocta
           and x.AQPB074oper = pn_aooper
           and x.AQPB074sbop = pn_aosbop
           and x.AQPB074tope = pn_aotope
           and x.AQPB074fppk is null;
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
        lx_estado := 'X';
        lx_fecest := pn_feca;
      else
        lx_estado := 'R';
        lx_fecest := pn_fecha;
      end if;
    
      /****************************/
    
      select nvl(sum(r.aqpa005sdo), 0)
        into lx_scsdo
        from AQPA005 r
       where r.aqpa005fecpro = pn_fecha
         and r.aqpa005cor = pn_corr;
    
      /*-------------------------*/
      insert into AQPB074 ---HSD010
        (AQPB074cod, --pgcod,  ---jaqz520_010c      
         AQPB074mod, --aomod,
         AQPB074suc, --aosuc,
         AQPB074mda, --aomda,
         AQPB074pap, --aopap,
         AQPB074cta, --aocta,
         AQPB074oper, --aooper,
         AQPB074sbop, --aosbop,
         AQPB074tope, --aotope,
         AQPB074fval, --aofval,
         AQPB074fvto, --aofvto,
         AQPB074pzo, --aopzo,
         AQPB074tasa, --aotasa,
         AQPB074imp, --aoimp,
         AQPB074stat, --aostat,
         AQPB074fe99, --aofe99,
         AQPB074peri, --aoperiod,
         AQPB074frep, --frepro, 
         AQPB074ncor, --ncorre, 
         AQPB074proc, --proceso, 
         AQPB074fcie, --fcierre, 
         AQPB074inst, --instanc, 
         AQPB074est, --estado,  
         AQPB074fece, --fecest,   
         AQPB074sdo, --scsdo,
         AQPB074tabr, --tablaref,
         AQPB074orde --orden  
         )
      values
        (lx_pgcod,
         lx_aomod,
         lx_aosuc,
         lx_aomda,
         lx_aopap,
         lx_aocta,
         lx_aooper,
         lx_aosbop,
         lx_aotope,
         lx_aofval,
         lx_aofvto,
         lx_aopzo,
         lx_aotasa,
         lx_aoimp,
         lx_aostat,
         lx_aofe99,
         lx_aoperiod,
         lx_frepro,
         lx_ncorre,
         lx_proceso,
         lx_fcierre,
         lx_instanc,
         lx_estado,
         lx_fecest,
         lx_scsdo,
         'AQPB002',
         lx_orden);
    
      commit;
    
      /*-------------------------*/
      ---Detalle
      /*-------------------------*/
      pq_cr_historico_pagos_repro.sp_insertar_AQPB075_grupo2(pn_fecha, --lx_frepro,
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
    
      ---1. Fin
    exception
      when others then
        lx_orden := 1;
    end;
  
  end sp_insertar_AQPA004;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPB074_ini(pn_fecha_ini in date,
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
  
     -- Cursor AQPB088
    cursor cur_aqpb088(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb088 j, jaqa400 t
       where j.aqpb088est = 'C'
         and j.aqpb088fep >= cr_fecha_ini
         and j.aqpb088fep <= cr_fecha_fin
         and substr(trim(to_char(j.aqpb088ope)), -1) = pn_digito
         and t.jaqa400est = 'C'
         and j.aqpb088cor = (
                 select min(x.aqpb088cor) from aqpb088 x
                 where
                 x.aqpb088fep = j.aqpb088fep and
                 x.aqpb088emp = j.aqpb088emp and
                 x.aqpb088mod = j.aqpb088mod and
                 x.aqpb088suc = j.aqpb088suc and
                 x.aqpb088mda = j.aqpb088mda and
                 x.aqpb088pap = j.aqpb088pap and
                 x.aqpb088cta = j.aqpb088cta and
                 x.aqpb088ope = j.aqpb088ope and
                 x.aqpb088sbo = j.aqpb088sbo and
                 x.aqpb088top = j.aqpb088top
             ) and
                 j.aqpb088fep = t.jaqa400fec and
                 j.aqpb088emp = t.jaqa400emp and
                 j.aqpb088mod = t.jaqa400mod and
                 j.aqpb088suc = t.jaqa400suc and
                 j.aqpb088mda = t.jaqa400mda and
                 j.aqpb088pap = t.jaqa400pap and
                 j.aqpb088cta = t.jaqa400cta and
                 j.aqpb088ope = t.jaqa400ope and
                 j.aqpb088sbo = t.jaqa400sbo and
                 j.aqpb088top = t.jaqa400top
       order by j.aqpb088fep, j.aqpb088cor asc;     
  
  Begin
  
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_prv := lc_fecha_ini - 1;
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      ---Recurrido cursor JAQZ698
      
      for i in cur_jaqz698(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_JAQZ698(i.jaqz698fep,
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
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB002(j.aqpb002fep,
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
      
      
      ---Recurrido cursor AQPB088
      for i in cur_aqpb088(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB088(i.aqpb088fep,
                                                                i.aqpb088cor,
                                                                --i.jaqz698inst,
                                                                lc_fecha_prv,
                                                                i.aqpb088est,
                                                                
                                                                i.aqpb088emp,
                                                                i.aqpb088mod,
                                                                i.aqpb088suc,
                                                                i.aqpb088mda,
                                                                i.aqpb088pap,
                                                                i.aqpb088cta,
                                                                i.aqpb088ope,
                                                                i.aqpb088sbo,
                                                                i.aqpb088top);
      
      end loop;       
    
    end;
  
  end sp_insertar_AQPB074_ini;

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
    
      lc_variable := 'begin ' || '  pq_cr_historico_pagos_repro.sp_insertar_AQPB074_ini(
                        ' || '''' || pn_fecha_ini || '''' || ',
                        ' || '''' || pn_fecha_fin || '''' || ',
                        ' || ln_ini || ');' || ' End;';
    
      ln_job := ln_job + 1;
      dbms_output.put_line(lc_variable);
    
      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate,
                      interval  => null,
                      no_parse  => false,
                      instance  => 1, --- 04042024
                      force     => false);
    
      ln_ini := ln_ini + 1;
      commit;
    
    END LOOP;
  
  end sp_cr_job_carga;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
  PROCEDURE sp_eliminar_AQPB074(pn_fecha in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
  
  begin
  
    lc_fecha_fin := pn_fecha;  
    lc_fecha_ini := trunc(lc_fecha_fin) -
                    (to_number(to_char(lc_fecha_fin, 'DD')) - 1);

    
    dbms_output.put_line('FECHA INICIO: ' || to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line('FECHA FIN: ' || to_char(lc_fecha_fin, 'YYYY-MM-DD'));                      
  
    ---Eliminado de data   
    delete from AQPB074 t
     where t.aqpb074frep >= lc_fecha_ini
       and t.aqpb074frep <= lc_fecha_fin;
    commit;
  
    delete from AQPB075 t
     where t.aqpb075frep >= lc_fecha_ini
       and t.aqpb075frep <= lc_fecha_fin;
    commit;
    
  
  end sp_eliminar_AQPB074;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_HSD010_a(pn_suc in number, pn_fecha in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
    lc_fecha_prv date;
    lc_coderr    varchar2(300);
  
    --Cursor JAQZ698
    cursor cur_jaqz698(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from jaqz698 j
       where j.jaqz698est in ('C', 'V')
         and j.jaqz698fep >= cr_fecha_ini
         and j.jaqz698fep <= cr_fecha_fin
         and j.JAQZ698SUC = pn_suc;
  
    --Cursor AQPB002
    cursor cur_aqpb002(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb002 j
       where j.aqpb002est = 'C'
         and j.aqpb002fep >= cr_fecha_ini
         and j.aqpb002fep <= cr_fecha_fin
         and j.aqpb002suc = pn_suc;
  
    -- Cursor AQPB088 24/03/2021
    cursor cur_aqpb088(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb088 j, jaqa400 t
       where j.aqpb088est = 'C'
         and j.aqpb088fep >= cr_fecha_ini
         and j.aqpb088fep <= cr_fecha_fin
         and j.aqpb088suc = pn_suc
         --and substr(trim(to_char(j.aqpb088ope)), -1) = pn_digito
         and t.jaqa400est = 'C'
         and j.aqpb088cor = (
                 select min(x.aqpb088cor) from aqpb088 x
                 where
                 x.aqpb088fep = j.aqpb088fep and
                 x.aqpb088emp = j.aqpb088emp and
                 x.aqpb088mod = j.aqpb088mod and
                 x.aqpb088suc = j.aqpb088suc and
                 x.aqpb088mda = j.aqpb088mda and
                 x.aqpb088pap = j.aqpb088pap and
                 x.aqpb088cta = j.aqpb088cta and
                 x.aqpb088ope = j.aqpb088ope and
                 x.aqpb088sbo = j.aqpb088sbo and
                 x.aqpb088top = j.aqpb088top
             ) and
                 j.aqpb088fep = t.jaqa400fec and
                 j.aqpb088emp = t.jaqa400emp and
                 j.aqpb088mod = t.jaqa400mod and
                 j.aqpb088suc = t.jaqa400suc and
                 j.aqpb088mda = t.jaqa400mda and
                 j.aqpb088pap = t.jaqa400pap and
                 j.aqpb088cta = t.jaqa400cta and
                 j.aqpb088ope = t.jaqa400ope and
                 j.aqpb088sbo = t.jaqa400sbo and
                 j.aqpb088top = t.jaqa400top
       order by j.aqpb088fep, j.aqpb088cor asc;   
  
  Begin
  
    lc_fecha_fin := pn_fecha;
    lc_fecha_ini := trunc(lc_fecha_fin) -
                    (to_number(to_char(lc_fecha_fin, 'DD')) - 1);
    lc_fecha_prv := pn_fecha;
    --lc_fecha_ini := '02/05/2020';
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'HSD10';
      commit;
      ---Eliminado de data
      --delete from AQPB074 t where t.frepro >= lc_fecha_ini and t.frepro <= lc_fecha_fin ;
      --commit;
    
      --delete from AQPB075  t where t.frepro >= lc_fecha_ini and t.frepro <= lc_fecha_fin ;
      --commit;
    
      ---Recurrido cursor JAQZ698
      
      for i in cur_jaqz698(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_HSD010_JAQZ698_a(i.jaqz698fep,
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
      
        pq_cr_historico_pagos_repro.sp_insertar_HSD010_AQPB002_a(j.aqpb002fep,
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
      
       ---Recurrido cursor AQPB088
      for i in cur_aqpb088(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB088_a(i.aqpb088fep,
                                                                i.aqpb088cor,
                                                                --i.jaqz698inst,
                                                                lc_fecha_prv,
                                                                i.aqpb088est,
                                                                
                                                                i.aqpb088emp,
                                                                i.aqpb088mod,
                                                                i.aqpb088suc,
                                                                i.aqpb088mda,
                                                                i.aqpb088pap,
                                                                i.aqpb088cta,
                                                                i.aqpb088ope,
                                                                i.aqpb088sbo,
                                                                i.aqpb088top);
      
      end loop;    
      
      update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'HSD10';
      commit;
    EXCEPTION
      when others then
        lc_coderr := substr(sqlerrm, 1, 200);
        update tab_jobs g
           set g.c_inderr = 'S', g.c_deserr = lc_coderr
         where g.n_numer1 = pn_suc
           and g.c_codage = 'HSD10';
        commit;
        return;
      
    end;
  
  end sp_insertar_HSD010_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_HSD010_JAQZ698_a(pn_fecha      in date,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    ln_diaatr  number;
    ln_diagra  number;
    ld_fepvep  date;
    ld_feppk   date;
    ln_ncpr    number;
    ln_ncpa    number;
    ln_diaatrc number;
  
    -- Detalle
    cursor jaqz520_601c(cr_fecha date,
                        cr_corr  number,
                        ln_emp   in number,
                        ln_mod   in number,
                        ln_suc   in number,
                        ln_mda   in number,
                        ln_pap   in number,
                        ln_cta   in number,
                        ln_oper  in number,
                        ln_sbop  in number,
                        ln_tope  in number) is
      select d601.PGCOD,
             d601.PPMOD,
             d601.PPSUC,
             d601.PPMDA,
             d601.PPPAP,
             d601.PPCTA,
             d601.PPOPER,
             d601.PPSBOP,
             d601.PPTOPE,
             d601.PPFPAG,
             d601.PPTIPO,
             d601.PPFVAL,
             d601.PPFVTO,
             d601.PPPZO,
             d601.PPCAP,
             d601.PPINT,
             sum(pp1intm) pp1intm,
             sum(PPINTMEX) PPINTMEX,
             sum(PPICAP) PPICAP,
             sum(PPIINT) PPIINT,
             max(PPSTAT) PPSTAT,
             /*PPFINV,*/
             max(D602CD || '-' || D602MO || '-' || D602SU || '-' || D602TR || '-' ||
                 D602RE || '-' || D602FC || '-' || D602OR || '-' || D602SB || '-' ||
                 D602CO) transa,
             /*FREPRO,
             NCORRE,
             FECCIE,
             PROCESO,*/
             max(PP1NUMP) PP1NUMP,
             max(PP1FECH) PP1FECH,
             sum(PP1CAP) PP1CAP,
             sum(PP1INT) PP1INT,
             max(PP1STAT) PP1STAT
        from fsd602 d602, fsd601 d601
       where d602.pgcod(+) = d601.pgcod
         and d602.ppmod(+) = d601.ppmod
         and d602.ppsuc(+) = d601.ppsuc
         and d602.ppmda(+) = d601.ppmda
         and d602.pppap(+) = d601.pppap
         and d602.ppcta(+) = d601.ppcta
         and d602.ppoper(+) = d601.ppoper
         and d602.ppsbop(+) = d601.ppsbop
         and d602.pptope(+) = d601.pptope
         and d602.ppfpag(+) = d601.ppfpag
            --and d602.pp1fech (+) <= ld_fecpro
            --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
            --and d601.ppfvto <=  ld_fecpro
            --and d602.pp1stat (+) = 'T'
         and d602.d602co(+) = 'S'
         and d602.pp1salmor(+) = 0
         and d601.d601co = 'S'
         and d601.pgcod = ln_emp
         and d601.ppmod = ln_mod --
         and d601.ppsuc = ln_suc --
         and d601.ppmda = ln_mda
         and d601.pppap = ln_pap
         and d601.ppcta = ln_cta
         and d601.ppoper = ln_oper
         and d601.ppsbop = ln_sbop --
         and d601.pptope = ln_tope --
         and d601.ppcap + d601.ppint <> 0
       group by d601.PGCOD,
                d601.PPMOD,
                d601.PPSUC,
                d601.PPMDA,
                d601.PPPAP,
                d601.PPCTA,
                d601.PPOPER,
                d601.PPSBOP,
                d601.PPTOPE,
                d601.PPFPAG,
                d601.PPTIPO,
                d601.PPFVAL,
                d601.PPFVTO,
                d601.PPPZO,
                d601.PPCAP,
                d601.PPINT
       order by d601.ppfvto;
  
  begin
  
    begin
      select distinct 'S'
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
          select distinct b.pgcod, --lx_pgcod,
                          b.aomod, --lx_aomod,
                          b.aosuc, --lx_aosuc,
                          b.aomda, --lx_aomda,
                          b.aopap, --lx_aopap,
                          b.aocta, --lx_aocta,
                          b.aooper, --lx_aooper,
                          b.aosbop, --lx_aosbop,
                          b.aotope, --lx_aotope,
                          b.aofval, --lx_aofval,
                          b.aofvto, --lx_aofvto
                          
                          b.aopzo, --lx_aopzo
                          b.aotasa, --lx_aotasa
                          b.aoimp, --lx_aoimp
                          b.aostat, --lx_aostat
                          b.aofe99, --lx_aofe99
                          b.aoperiod --lx_aoperiod
            into lx_pgcod,
                 lx_aomod,
                 lx_aosuc,
                 lx_aomda,
                 lx_aopap,
                 lx_aocta,
                 lx_aooper,
                 lx_aosbop,
                 lx_aotope,
                 lx_aofval,
                 lx_aofvto,
                 
                 lx_aopzo,
                 lx_aotasa,
                 lx_aoimp,
                 lx_aostat,
                 lx_aofe99,
                 lx_aoperiod
            from jaqz520_010c q, fsd010 b
           where q.fec = pn_fecha
             and q.cor = pn_corr
             and b.pgcod = q.pgcod
             and b.aomod = q.aomod
             and b.aosuc = q.aosuc
             and b.aomda = q.aomda
             and b.aopap = q.aopap
             and b.aocta = q.aocta
             and b.aooper = q.aooper
             and b.aosbop = q.aosbop
             and b.aotope = q.aotope;
        exception
          when too_many_rows then
            select distinct b.pgcod, --lx_pgcod,
                            b.aomod, --lx_aomod,
                            b.aosuc, --lx_aosuc,
                            b.aomda, --lx_aomda,
                            b.aopap, --lx_aopap,
                            b.aocta, --lx_aocta,
                            b.aooper, --lx_aooper,
                            b.aosbop, --lx_aosbop,
                            b.aotope, --lx_aotope,
                            b.aofval, --lx_aofval,
                            b.aofvto, --lx_aofvto
                            
                            b.aopzo, --lx_aopzo
                            b.aotasa, --lx_aotasa
                            b.aoimp, --lx_aoimp
                            b.aostat, --lx_aostat
                            b.aofe99, --lx_aofe99
                            b.aoperiod --lx_aoperiod
              into lx_pgcod,
                   lx_aomod,
                   lx_aosuc,
                   lx_aomda,
                   lx_aopap,
                   lx_aocta,
                   lx_aooper,
                   lx_aosbop,
                   lx_aotope,
                   lx_aofval,
                   lx_aofvto,
                   
                   lx_aopzo,
                   lx_aotasa,
                   lx_aoimp,
                   lx_aostat,
                   lx_aofe99,
                   lx_aoperiod
              from jaqz520_010c q, fsd010 b
             where q.fec = pn_fecha
               and q.cor = pn_corr
               and b.pgcod = q.pgcod
               and b.aomod = q.aomod
               and b.aosuc = q.aosuc
               and b.aomda = q.aomda
               and b.aopap = q.aopap
               and b.aocta = q.aocta
               and b.aooper = q.aooper
               and b.aosbop = q.aosbop
               and b.aotope = q.aotope
               and rownum = 1;
          when others then
            null;
        end;
        /****************************/
      
        pq_cr_historico_pagos_repro.sn_dias_atraso_h(v_pgfape  => lx_frepro,
                                                     v_pgcod   => lx_pgcod,
                                                     v_scmod   => lx_aomod,
                                                     v_scsuc   => lx_aosuc,
                                                     v_scmda   => lx_aomda,
                                                     v_scpap   => lx_aopap,
                                                     v_sccta   => lx_aocta,
                                                     v_scoper  => lx_aooper,
                                                     v_scsbop  => lx_aosbop,
                                                     v_sctope  => lx_aotope,
                                                     v_scstat  => lx_aostat,
                                                     v_fecven  => lx_aofvto,
                                                     v_fecval  => lx_aofval,
                                                     v_period  => lx_aoperiod,
                                                     pn_diaatr => ln_diaatr,
                                                     pn_diagra => ln_diagra,
                                                     pd_fepvep => ld_fepvep,
                                                     pd_feppk  => ld_feppk,
                                                     pn_ncpr   => ln_ncpr,
                                                     pn_ncpa   => ln_ncpa,
                                                     pn_diatrc => ln_diaatrc);
        /****************************/
        lx_frepro  := pn_fecha;
        lx_ncorre  := pn_corr;
        lx_proceso := 'C'; ---CAPITALIZACION
        lx_fcierre := pn_fecha_prev; --lc_fecha_prv;
        lx_instanc := pn_inst;
        ---lx_estado := 'R'; ---REPROGRAMADO ---en abril puede cambiar
        if (pn_revr = 'V') then
          lx_estado := 'X';
        else
          lx_estado := 'R';
        end if;
      
        lx_fecest := pn_fecha;
      
        /****************************/
      
        begin
          select sum(r.scsdo)
            into lx_scsdo
            from JAQZ520_011c r
           where r.fec = pn_fecha
             and r.cor = pn_corr
             and r.pgcod = pn_pgcod
             and r.scmod = pn_aomod
             and r.scsuc = pn_aosuc
             and r.scmda = pn_aomda
             and r.scpap = pn_aopap
             and r.sccta = pn_aocta
             and r.scoper = pn_aooper
             and r.scsbop = pn_aosbop
             and r.sctope = pn_aotope;
        exception
          when others then
            lx_scsdo := 0;
        end;
      
        /****************************/
        insert into AQPB074
          (aqpb074cod,
           aqpb074mod,
           aqpb074suc,
           aqpb074mda,
           aqpb074pap,
           aqpb074cta,
           aqpb074oper,
           aqpb074sbop,
           aqpb074tope,
           aqpb074fval,
           aqpb074fvto,
           aqpb074pzo,
           aqpb074tasa,
           aqpb074imp,
           aqpb074stat,
           aqpb074fe99,
           aqpb074peri,
           aqpb074frep,
           aqpb074ncor,
           aqpb074proc,
           aqpb074fcie,
           aqpb074inst,
           aqpb074est,
           aqpb074fece,
           aqpb074diat,
           aqpb074diag,
           aqpb074fepv,
           aqpb074fppk,
           aqpb074ncpr,
           aqpb074ncpa,
           aqpb074sdo,
           aqpb074tabr,
           aqpb074dakr)
        values
          (nvl(lx_pgcod, 1),
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope,
           lx_aofval,
           lx_aofvto,
           lx_aopzo,
           lx_aotasa,
           lx_aoimp,
           lx_aostat,
           lx_aofe99,
           lx_aoperiod,
           lx_frepro,
           lx_ncorre,
           lx_proceso,
           lx_fcierre,
           lx_instanc,
           lx_estado,
           lx_fecest,
           ln_diaatr,
           ln_diagra,
           ld_fepvep,
           ld_feppk,
           ln_ncpr,
           ln_ncpa,
           lx_scsdo,
           'JAQZ698',
           ln_diaatrc);
      
        commit;
      
        /*********** INSERTAR DETALLE *****************/
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
            insert into AQPB075
              (aqpb075cod,
               aqpb075mod,
               aqpb075suc,
               aqpb075mda,
               aqpb075pap,
               aqpb075cta,
               aqpb075oper,
               aqpb075sbop,
               aqpb075tope,
               aqpb075fpag,
               aqpb075tipo,
               aqpb075fval,
               aqpb075fvto,
               aqpb075pzo,
               aqpb075cap,
               aqpb075int,
               aqpb075intmex,
               aqpb075icap,
               aqpb075iint,
               aqpb075stat,
               aqpb075frep,
               aqpb075ncor,
               aqpb075fecc,
               aqpb075proc,
               aqpb0751nump,
               aqpb0751fech,
               aqpb0751cap,
               aqpb0751int,
               aqpb0751stat,
               aqpb0751intm,
               aqpb075tabr)
            
            values
              (k.pgcod, -- lx_pgcod, 
               k.ppmod, --lx_ppmod,
               k.ppsuc, --lx_ppsuc,
               k.ppmda, --lx_ppmda,
               k.pppap, --lx_pppap,
               k.ppcta, -- lx_ppcta,
               k.ppoper, --lx_ppoper,
               k.ppsbop, --lx_ppsbop,
               k.pptope, --lx_pptope,
               k.ppfpag, --lx_ppfpag,
               k.pptipo, --lx_pptipo,
               k.ppfval, --lx_ppfval,
               k.ppfvto, --lx_ppfvto,
               k.pppzo, --lx_pppzo,
               k.ppcap, --lx_ppcap,
               k.ppint, --lx_ppint,
               k.ppintmex, --lx_ppintmex,
               k.ppicap, --lx_ppicap,
               k.ppiint, --lx_ppiint,
               k.ppstat, --lx_ppstat,               
               pn_fecha, --lx_frepro,
               pn_corr, --lx_ncorre,
               pn_fecha_prev, --lx_feccie,
               'C', --lx_proceso  
               k.pp1nump, ---jaqz520_602c  -----?
               k.pp1fech,
               k.pp1cap,
               k.pp1int,
               k.pp1stat,
               k.pp1intm,
               'JAQZ698');
            commit;
          
          exception
            when others then
              lc_flag := 'N';
          end;
        end loop;
      
      end;
    end if;
  
  end sp_insertar_HSD010_JAQZ698_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_HSD010_AQPB002_a(pn_fecha      in date,
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
        pq_cr_historico_pagos_repro.sp_insertar_JAQZ520_010_a(pn_fecha,
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
        begin
        
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
        exception
          when others then
          
            null;
        end;
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPA004_a(lc_fecha_desp,
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
  
  end sp_insertar_HSD010_AQPB002_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_HSD601_grupo1_a(pn_fecha      in date,
                                        pn_corr       in number,
                                        pn_fecha_prev in date,
                                        PGCOD         number,
                                        PPMOD         number,
                                        PPSUC         number,
                                        PPMDA         number,
                                        PPPAP         number,
                                        PPCTA         number,
                                        PPOPER        number,
                                        PPSBOP        number,
                                        PPTOPE        number) is
    
    cursor grupo1_jaqz520_601(ln_emp  in number,
                              ln_mod  in number,
                              ln_suc  in number,
                              ln_pap  in number,
                              ln_mda  in number,
                              ln_cta  in number,
                              ln_oper in number,
                              ln_sbop in number,
                              ln_tope in number) is
      select d601.PGCOD,
             d601.PPMOD,
             d601.PPSUC,
             d601.PPMDA,
             d601.PPPAP,
             d601.PPCTA,
             d601.PPOPER,
             d601.PPSBOP,
             d601.PPTOPE,
             d601.PPFPAG,
             d601.PPTIPO,
             d601.PPFVAL,
             d601.PPFVTO,
             d601.PPPZO,
             d601.PPCAP,
             d601.PPINT,
             sum(pp1intm) pp1intm,
             sum(PPINTMEX) PPINTMEX,
             sum(PPICAP) PPICAP,
             sum(PPIINT) PPIINT,
             max(PPSTAT) PPSTAT,
             /*PPFINV,*/
             max(D602CD || '-' || D602MO || '-' || D602SU || '-' || D602TR || '-' ||
                 D602RE || '-' || D602FC || '-' || D602OR || '-' || D602SB || '-' ||
                 D602CO) transa,
             /*FREPRO,
             NCORRE,
             FECCIE,
             PROCESO,*/
             max(PP1NUMP) PP1NUMP,
             max(PP1FECH) PP1FECH,
             sum(PP1CAP) PP1CAP,
             sum(PP1INT) PP1INT,
             max(PP1STAT) PP1STAT
        from fsd602 d602, fsd601 d601
       where d602.pgcod(+) = d601.pgcod
         and d602.ppmod(+) = d601.ppmod
         and d602.ppsuc(+) = d601.ppsuc
         and d602.ppmda(+) = d601.ppmda
         and d602.pppap(+) = d601.pppap
         and d602.ppcta(+) = d601.ppcta
         and d602.ppoper(+) = d601.ppoper
         and d602.ppsbop(+) = d601.ppsbop
         and d602.pptope(+) = d601.pptope
         and d602.ppfpag(+) = d601.ppfpag
            --and d602.pp1fech (+) <= ld_fecpro
            --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
            --and d601.ppfvto <=  ld_fecpro
            --and d602.pp1stat (+) = 'T'
         and d602.d602co(+) = 'S'
         and d602.pp1salmor(+) = 0
         and d601.d601co = 'S'
         and d601.pgcod = ln_emp
         and d601.ppmod = ln_mod --
         and d601.ppsuc = ln_suc --
         and d601.ppmda = ln_mda
         and d601.pppap = ln_pap
         and d601.ppcta = ln_cta
         and d601.ppoper = ln_oper
         and d601.ppsbop = ln_sbop --
         and d601.pptope = ln_tope --
         and d601.ppcap + d601.ppint <> 0
       group by d601.PGCOD,
                d601.PPMOD,
                d601.PPSUC,
                d601.PPMDA,
                d601.PPPAP,
                d601.PPCTA,
                d601.PPOPER,
                d601.PPSBOP,
                d601.PPTOPE,
                d601.PPFPAG,
                d601.PPTIPO,
                d601.PPFVAL,
                d601.PPFVTO,
                d601.PPPZO,
                d601.PPCAP,
                d601.PPINT
       order by d601.ppfvto;
  
  begin
  
    for p in grupo1_jaqz520_601(PGCOD,
                                PPMOD,
                                PPSUC,
                                PPMDA,
                                PPPAP,
                                PPCTA,
                                PPOPER,
                                PPSBOP,
                                PPTOPE) loop
    
      begin
      
        insert into AQPB075
          (aqpb075cod,
           aqpb075mod,
           aqpb075suc,
           aqpb075mda,
           aqpb075pap,
           aqpb075cta,
           aqpb075oper,
           aqpb075sbop,
           aqpb075tope,
           aqpb075fpag,
           aqpb075tipo,
           aqpb075fval,
           aqpb075fvto,
           aqpb075pzo,
           aqpb075cap,
           aqpb075int,
           aqpb075intmex,
           aqpb075icap,
           aqpb075iint,
           aqpb075stat,
           aqpb075frep,
           aqpb075ncor,
           aqpb075fecc,
           aqpb075proc,
           aqpb0751nump,
           aqpb0751fech,
           aqpb0751cap,
           aqpb0751int,
           aqpb0751stat,
           aqpb0751intm,
           aqpb075tabr)
        
        values
          (p.pgcod, -- lx_pgcod, 
           p.ppmod, --lx_ppmod,
           p.ppsuc, --lx_ppsuc,
           p.ppmda, --lx_ppmda,
           p.pppap, --lx_pppap,
           p.ppcta, -- lx_ppcta,
           p.ppoper, --lx_ppoper,
           p.ppsbop, --lx_ppsbop,
           p.pptope, --lx_pptope,
           p.ppfpag, --lx_ppfpag,
           p.pptipo, --lx_pptipo,
           p.ppfval, --lx_ppfval,
           p.ppfvto, --lx_ppfvto,
           p.pppzo, --lx_pppzo,
           p.ppcap, --lx_ppcap,
           p.ppint, --lx_ppint,
           p.ppintmex, --lx_ppintmex,
           p.ppicap, --lx_ppicap,
           p.ppiint, --lx_ppiint,
           p.ppstat, --lx_ppstat,
           pn_fecha, --lx_frepro,
           pn_corr, --lx_ncorre,
           pn_fecha_prev, --lx_feccie,
           'R', --lx_proceso  
           p.pp1nump, ---jaqz520_602c  -----?
           p.pp1fech,
           p.pp1cap,
           p.pp1int,
           p.pp1stat,
           p.pp1intm,
           'AQPB002');
      
      end;
    
    end loop;
    commit;
  
  end sp_insertar_HSD601_grupo1_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_HSD601_grupo2_a(pn_fecpro     date,
                                        pn_corr       number,
                                        pn_fecha_prev in date,
                                        pn_fecha_inst in date,
                                        pn_corr_inst  in number,
                                        
                                        PGCOD  number,
                                        PPMOD  number,
                                        PPSUC  number,
                                        PPMDA  number,
                                        PPPAP  number,
                                        PPCTA  number,
                                        PPOPER number,
                                        PPSBOP number,
                                        PPTOPE number) is
  
    cursor grupo2_aqpa006(ld_fecpro in date,
                          ln_emp    in number,
                          ln_suc    in number,
                          ln_mod    in number,
                          ln_pap    in number,
                          ln_mda    in number,
                          ln_cta    in number,
                          ln_oper   in number,
                          ln_sbop   in number,
                          ln_tope   in number) is
      select d601.PGCOD,
             d601.PPMOD,
             d601.PPSUC,
             d601.PPMDA,
             d601.PPPAP,
             d601.PPCTA,
             d601.PPOPER,
             d601.PPSBOP,
             d601.PPTOPE,
             d601.PPFPAG,
             d601.PPTIPO,
             d601.PPFVAL,
             d601.PPFVTO,
             d601.PPPZO,
             d601.PPCAP,
             d601.PPINT,
             sum(pp1intm) pp1intm,
             sum(PPINTMEX) PPINTMEX,
             sum(PPICAP) PPICAP,
             sum(PPIINT) PPIINT,
             max(PPSTAT) PPSTAT,
             /*PPFINV,*/
             max(D602CD || '-' || D602MO || '-' || D602SU || '-' || D602TR || '-' ||
                 D602RE || '-' || D602FC || '-' || D602OR || '-' || D602SB || '-' ||
                 D602CO) transa,
             /*FREPRO,
             NCORRE,
             FECCIE,
             PROCESO,*/
             
             max(PP1NUMP) PP1NUMP,
             max(PP1FECH) PP1FECH,
             sum(PP1CAP) PP1CAP,
             sum(PP1INT) PP1INT,
             max(PP1STAT) PP1STAT
        from fsd602 d602, fsd601 d601
       where d602.pgcod(+) = d601.pgcod
         and d602.ppmod(+) = d601.ppmod
         and d602.ppsuc(+) = d601.ppsuc
         and d602.ppmda(+) = d601.ppmda
         and d602.pppap(+) = d601.pppap
         and d602.ppcta(+) = d601.ppcta
         and d602.ppoper(+) = d601.ppoper
         and d602.ppsbop(+) = d601.ppsbop
         and d602.pptope(+) = d601.pptope
         and d602.ppfpag(+) = d601.ppfpag
            --and d602.pp1fech (+) <= ld_fecpro
            --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
            --and d601.ppfvto <=  ld_fecpro
            --and d602.pp1stat (+) = 'T'
         and d602.d602co(+) = 'S'
         and d602.pp1salmor(+) = 0
         and d601.d601co = 'S'
         and d601.pgcod = ln_emp
         and d601.ppmod = ln_mod --
         and d601.ppsuc = ln_suc --
         and d601.ppmda = ln_mda
         and d601.pppap = ln_pap
         and d601.ppcta = ln_cta
         and d601.ppoper = ln_oper
         and d601.ppsbop = ln_sbop --
         and d601.pptope = ln_tope --
         and d601.ppcap + d601.ppint <> 0
       group by d601.PGCOD,
                d601.PPMOD,
                d601.PPSUC,
                d601.PPMDA,
                d601.PPPAP,
                d601.PPCTA,
                d601.PPOPER,
                d601.PPSBOP,
                d601.PPTOPE,
                d601.PPFPAG,
                d601.PPTIPO,
                d601.PPFVAL,
                d601.PPFVTO,
                d601.PPPZO,
                d601.PPCAP,
                d601.PPINT
       order by d601.ppfvto;
  
  begin
  
    for g in grupo2_aqpa006(pn_fecha_prev,
                            pgcod,
                            ppsuc,
                            ppmod,
                            pppap,
                            ppmda,
                            ppcta,
                            ppoper,
                            PPSBOP,
                            PPTOPE)
    
     loop
    
      begin
      
        insert into AQPB075
          (aqpb075cod,
           aqpb075mod,
           aqpb075suc,
           aqpb075mda,
           aqpb075pap,
           aqpb075cta,
           aqpb075oper,
           aqpb075sbop,
           aqpb075tope,
           aqpb075fpag,
           aqpb075tipo,
           aqpb075fval,
           aqpb075fvto,
           aqpb075pzo,
           aqpb075cap,
           aqpb075int,
           aqpb075intmex,
           aqpb075icap,
           aqpb075iint,
           aqpb075stat,
           
           aqpb075frep,
           aqpb075ncor,
           aqpb075fecc,
           aqpb075proc,
           aqpb0751nump,
           aqpb0751fech,
           aqpb0751cap,
           aqpb0751int,
           aqpb0751stat,
           aqpb0751intm,
           aqpb075tabr)
        values
          (g.pgcod, -- lx_pgcod, 
           g.ppmod, --lx_ppmod,
           g.ppsuc, --lx_ppsuc,
           g.ppmda, --lx_ppmda,
           g.pppap, --lx_pppap,
           g.ppcta, -- lx_ppcta,
           g.ppoper, --lx_ppoper,
           g.ppsbop, --lx_ppsbop,
           g.pptope, --lx_pptope,
           g.ppfpag, --lx_ppfpag,
           g.pptipo, --lx_pptipo,
           g.ppfval, --lx_ppfval,
           g.ppfvto, --lx_ppfvto,
           g.pppzo, --lx_pppzo,
           g.ppcap, --lx_ppcap,
           g.ppint, --lx_ppint,
           g.ppintmex,
           g.ppicap,
           g.ppiint,
           g.ppstat, --lx_ppstat,
           pn_fecha_inst, --lx_frepro,
           pn_corr_inst, --lx_ncorre,
           pn_fecha_prev, --lx_feccie,
           'R', --lx_proceso  
           g.pp1nump, ---jaqz520_602c  -----?
           g.pp1fech,
           g.pp1cap,
           g.pp1int,
           g.pp1stat,
           g.pp1intm,
           'AQPB002');
      
      end;
    
    end loop;
    commit;
  
  end sp_insertar_HSD601_grupo2_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_JAQZ520_010_a(pn_fecha      in date,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
    ln_diaatr  number;
    ln_diagra  number;
    ld_fepvep  date;
    ld_feppk   date;
    ln_ncpr    number;
    ln_ncpa    number;
    ln_diaatrc number;
  
  begin
    begin
      select distinct q.pgcod, --lx_pgcod,
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
                      q.aoperiod --lx_aoperiod
        into lx_pgcod,
             lx_aomod, 
             lx_aosuc, 
             lx_aomda, 
             lx_aopap, 
             lx_aocta, 
             lx_aooper, 
             lx_aosbop, 
             lx_aotope, 
             lx_aofval, 
             lx_aofvto, 
             lx_aopzo, 
             lx_aotasa, 
             lx_aoimp,
             lx_aostat,
             lx_aofe99, 
             lx_aoperiod 
        from fsd010 q --JAQZ520_010 q 
       where q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
         and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = pn_aosbop
         and q.aotope = pn_aotope;
    exception
      when too_many_rows then
        select distinct q.pgcod, --lx_pgcod,
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
                        q.aoperiod --lx_aoperiod
          into lx_pgcod, 
               lx_aomod, 
               lx_aosuc,
               lx_aomda, 
               lx_aopap, 
               lx_aocta, 
               lx_aooper, 
               lx_aosbop, 
               lx_aotope, 
               lx_aofval, 
               lx_aofvto, 
               lx_aopzo, 
               lx_aotasa, 
               lx_aoimp, 
               lx_aostat, 
               lx_aofe99, 
               lx_aoperiod 
          from fsd010 q --JAQZ520_010 q ----FSD010
         where q.pgcod = pn_pgcod
           and q.aomod = pn_aomod
           and q.aosuc = pn_aosuc
           and q.aomda = pn_aomda
           and q.aopap = pn_aopap
           and q.aocta = pn_aocta
           and q.aooper = pn_aooper
           and q.aosbop = pn_aosbop
           and q.aotope = pn_aotope
           and rownum = 1;
      when others then
        null;
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
      lx_estado := 'X';
      lx_fecest := pn_feca;
    else
      lx_estado := 'R';
      lx_fecest := pn_fecha;
    end if;
  
    /****************************/
    begin
      select r.scsdo
        into lx_scsdo
        from JAQZ520_011 r
       where r.pgcod = pn_pgcod
         and r.scsuc = pn_aosuc
         and r.scmda = pn_aomda
         and r.scpap = pn_aopap
         and r.sccta = pn_aocta
         and r.scoper = pn_aooper
         and r.scsbop = pn_aosbop
         and r.sctope = pn_aotope
         and r.scmod = pn_aomod;
    exception
      when others then
        lx_scsdo := 0;
    end;
  
    /*-------------------------*/
    -- otrso datos 
    pq_cr_historico_pagos_repro.sn_dias_atraso_h(v_pgfape  => lx_frepro,
                                                 v_pgcod   => lx_pgcod,
                                                 v_scmod   => lx_aomod,
                                                 v_scsuc   => lx_aosuc,
                                                 v_scmda   => lx_aomda,
                                                 v_scpap   => lx_aopap,
                                                 v_sccta   => lx_aocta,
                                                 v_scoper  => lx_aooper,
                                                 v_scsbop  => lx_aosbop,
                                                 v_sctope  => lx_aotope,
                                                 v_scstat  => lx_aostat,
                                                 v_fecven  => lx_aofvto,
                                                 v_fecval  => lx_aofval,
                                                 v_period  => lx_aoperiod,
                                                 pn_diaatr => ln_diaatr,
                                                 pn_diagra => ln_diagra,
                                                 pd_fepvep => ld_fepvep,
                                                 pd_feppk  => ld_feppk,
                                                 pn_ncpr   => ln_ncpr,
                                                 pn_ncpa   => ln_ncpa,
                                                 pn_diatrc => ln_diaatrc);
  
    insert into AQPB074
      (aqpb074cod,
       aqpb074mod,
       aqpb074suc,
       aqpb074mda,
       aqpb074pap,
       aqpb074cta,
       aqpb074oper,
       aqpb074sbop,
       aqpb074tope,
       aqpb074fval,
       aqpb074fvto,
       aqpb074pzo,
       aqpb074tasa,
       aqpb074imp,  
       aqpb074stat,
       aqpb074fe99,
       aqpb074peri,
       aqpb074frep,
       aqpb074ncor,
       aqpb074proc,
       aqpb074fcie,
       aqpb074inst,
       aqpb074est,
       aqpb074fece,
       aqpb074diat,
       aqpb074diag,
       aqpb074fepv,
       aqpb074fppk,
       aqpb074ncpr,
       aqpb074ncpa,
       aqpb074sdo,
       aqpb074tabr,
       aqpb074dakr 
       )
    values
      (nvl(lx_pgcod, 1), 
       lx_aomod, 
       lx_aosuc, 
       lx_aomda, 
       lx_aopap, 
       lx_aocta, 
       lx_aooper, 
       lx_aosbop, 
       lx_aotope, 
       lx_aofval, 
       lx_aofvto, 
       lx_aopzo, 
       lx_aotasa, 
       lx_aoimp, 
       lx_aostat, 
       lx_aofe99, 
       lx_aoperiod, 
       lx_frepro,
       lx_ncorre,
       lx_proceso,
       lx_fcierre,
       lx_instanc,
       lx_estado,
       lx_fecest,
       ln_diaatr,
       ln_diagra,
       ld_fepvep,
       ld_feppk,
       ln_ncpr,
       ln_ncpa,
       lx_scsdo,
       'AQPB002',
       ln_diaatrc);
  
    commit;
  
    /*-------------------------*/
    ---Detalle GRUPO1
    /*-------------------------*/
    pq_cr_historico_pagos_repro.sp_insertar_HSD601_grupo1_a(pn_fecha, --lx_frepro,
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
  
    ---2. Fin
  exception
    when others then
      --lx_orden := 1; 
      null;
      --end;
  
  end sp_insertar_JAQZ520_010_a;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  PROCEDURE sp_insertar_AQPA004_a(pn_fecha      in date,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; 
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    ln_diaatr  number;
    ln_diagra  number;
    ld_fepvep  date;
    ld_feppk   date;
    lx_scsdo   number(17, 2);
    ln_ncpr    number;
    ln_ncpa    number;
  
    ln_diaatrc number;
  
  begin
  
    begin
      ---1. Inicio
    
      select b.pgcod, --lx_pgcod,
             b.aomod, --lx_aomod,
             b.aosuc, --lx_aosuc,
             b.aomda, --lx_aomda,
             b.aopap, --lx_aopap,
             b.aocta, --lx_aocta,
             b.aooper, --lx_aooper,
             b.aosbop, --lx_aosbop,
             b.aotope, --lx_aotope,
             b.aofval, --lx_aofval,
             b.aofvto, --lx_aofvto
             b.aopzo, --lx_aopzo
             b.aotasa, --lx_aotasa
             b.aoimp, --lx_aoimp
             b.aostat, --lx_aostat
             b.aofe99, --lx_aofe99
             b.aoperiod --lx_aoperiod
        into lx_pgcod, 
             lx_aomod, 
             lx_aosuc, 
             lx_aomda, 
             lx_aopap, 
             lx_aocta, 
             lx_aooper, 
             lx_aosbop, 
             lx_aotope, 
             lx_aofval, 
             lx_aofvto, 
             lx_aopzo, 
             lx_aotasa, 
             lx_aoimp, 
             lx_aostat, 
             lx_aofe99, 
             lx_aoperiod 
        from AQPA004 q, fsd010 b
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
         and q.aqpa004tope = pn_aotope 
         and b.pgcod = q.aqpa004cod
         and b.aomod = q.aqpa004mod
         and b.aosuc = q.aqpa004suc
         and b.aomda = q.aqpa004mda
         and b.aopap = q.aqpa004pap
         and b.aocta = q.aqpa004cta
         and b.aooper = q.aqpa004oper
         and b.aosbop = q.aqpa004sbop
         and b.aotope = q.aqpa004tope;
    exception
      when too_many_rows then
        select b.pgcod, --lx_pgcod,
               b.aomod, --lx_aomod,
               b.aosuc, --lx_aosuc,
               b.aomda, --lx_aomda,
               b.aopap, --lx_aopap,
               b.aocta, --lx_aocta,
               b.aooper, --lx_aooper,
               b.aosbop, --lx_aosbop,
               b.aotope, --lx_aotope,
               b.aofval, --lx_aofval,
               b.aofvto, --lx_aofvto
               b.aopzo, --lx_aopzo
               b.aotasa, --lx_aotasa
               b.aoimp, --lx_aoimp
               b.aostat, --lx_aostat
               b.aofe99, --lx_aofe99
               b.aoperiod --lx_aoperiod
          into lx_pgcod,
               lx_aomod,
               lx_aosuc,
               lx_aomda,
               lx_aopap,
               lx_aocta,
               lx_aooper,
               lx_aosbop,
               lx_aotope,
               lx_aofval,
               lx_aofvto,
               lx_aopzo, 
               lx_aotasa,
               lx_aoimp, 
               lx_aostat,
               lx_aofe99,
               lx_aoperiod
          from AQPA004 q, fsd010 b
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
           and q.aqpa004tope = pn_aotope
           and b.pgcod = q.aqpa004cod
           and b.aomod = q.aqpa004mod
           and b.aosuc = q.aqpa004suc
           and b.aomda = q.aqpa004mda
           and b.aopap = q.aqpa004pap
           and b.aocta = q.aqpa004cta
           and b.aooper = q.aqpa004oper
           and b.aosbop = q.aqpa004sbop
           and b.aotope = q.aqpa004tope
           and rownum = 1;
      when others then
        null;
    end;
    /****************************/
  
    lx_frepro  := pn_fecha_inst;
    lx_ncorre  := pn_corr_inst;
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
      select r.aqpa005sdo
        into lx_scsdo
        from AQPA005 r
       where r.aqpa005fecpro = pn_fecha
         and r.aqpa005cor = pn_corr
         and r.aqpa005cod = pn_pgcod
         and r.aqpa005mod = pn_aomod
         and r.aqpa005suc = pn_aosuc
         and r.aqpa005mda = pn_aomda
         and r.aqpa005pap = pn_aopap
         and r.aqpa005cta = pn_aocta
         and r.aqpa005oper = pn_aooper
         and r.aqpa005sbop = pn_aosbop
         and r.aqpa005tope = pn_aotope;
    
    exception
      when others then
        lx_scsdo := 0;
    end;
  
    /*-------------------------*/
    -- otrso datos 
  
    pq_cr_historico_pagos_repro.sn_dias_atraso_h(v_pgfape  => lx_frepro,
                                                 v_pgcod   => lx_pgcod,
                                                 v_scmod   => lx_aomod,
                                                 v_scsuc   => lx_aosuc,
                                                 v_scmda   => lx_aomda,
                                                 v_scpap   => lx_aopap,
                                                 v_sccta   => lx_aocta,
                                                 v_scoper  => lx_aooper,
                                                 v_scsbop  => lx_aosbop,
                                                 v_sctope  => lx_aotope,
                                                 v_scstat  => lx_aostat,
                                                 v_fecven  => lx_aofvto,
                                                 v_fecval  => lx_aofval,
                                                 v_period  => lx_aoperiod,
                                                 pn_diaatr => ln_diaatr,
                                                 pn_diagra => ln_diagra,
                                                 pd_fepvep => ld_fepvep,
                                                 pd_feppk  => ld_feppk,
                                                 pn_ncpr   => ln_ncpr,
                                                 pn_ncpa   => ln_ncpa,
                                                 pn_diatrc => ln_diaatrc);
    -------------
  
    insert into AQPB074
      (aqpb074cod,
       aqpb074mod,
       aqpb074suc,
       aqpb074mda,
       aqpb074pap,
       aqpb074cta,
       aqpb074oper,
       aqpb074sbop,
       aqpb074tope,
       aqpb074fval,
       aqpb074fvto,
       aqpb074pzo,
       aqpb074tasa,
       aqpb074imp,   
       aqpb074stat,
       aqpb074fe99,
       aqpb074peri,
       aqpb074frep,
       aqpb074ncor,
       aqpb074proc,
       aqpb074fcie,
       aqpb074inst,
       aqpb074est,
       aqpb074fece,
       aqpb074diat,
       aqpb074diag,
       aqpb074fepv,
       aqpb074fppk,
       aqpb074ncpr,
       aqpb074ncpa,
       aqpb074sdo,
       aqpb074tabr,
       aqpb074dakr)
    values
      (nvl(lx_pgcod, 1), 
       lx_aomod, 
       lx_aosuc, 
       lx_aomda, 
       lx_aopap, 
       lx_aocta, 
       lx_aooper, 
       lx_aosbop, 
       lx_aotope, 
       lx_aofval, 
       lx_aofvto, 
       lx_aopzo, 
       lx_aotasa, 
       lx_aoimp, 
       lx_aostat, 
       lx_aofe99, 
       lx_aoperiod,
       lx_frepro,
       lx_ncorre,
       lx_proceso,
       lx_fcierre,
       lx_instanc,
       lx_estado,
       lx_fecest,
       ln_diaatr,
       ln_diagra,
       ld_fepvep,
       ld_feppk,
       ln_ncpr,
       ln_ncpa,
       lx_scsdo,
       'AQPB002',
       ln_diaatrc);
  
    commit;
  
    /*-------------------------*/
    ---Detalle
    /*-------------------------*/
    pq_cr_historico_pagos_repro.sp_insertar_HSD601_grupo2_a(pn_fecha, --lx_frepro,
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
  
    ---1. Fin
  exception
    when others then
      --lx_orden := 1;   
      null;
      --end;
  
  end sp_insertar_AQPA004_a;

  procedure sn_dias_atraso_h(v_Pgfape  in date, --fecha de proceso
                             v_Pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Scstat  in number,
                             v_fecven  in date,
                             v_fecval  in date,
                             v_period  in number,
                             pn_diaatr out number,
                             pn_diagra out number,
                             pd_fepvep out date,
                             pd_feppk  out date,
                             pn_ncpr   out number,
                             pn_ncpa   out number,
                             pn_diatrc out number) is
  
    -- *****************************************************************
    -- Nombre                     : fn_analista_credito
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013
    -- Autor de Creación          : LLLOSA
    -- Uso                        : Retorna dias de atraso
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 2014.11.11 DCASTRO - se agrego condicion para calcular dias atraso carta fianza.
    -- *****************************************************************
  
    ln_diatr  number;
    ln_scstat fsd010.aostat%type;
    lc_covi   varchar2(1);
    ln_artcov number;
  
    ln_diagra number;
    ld_fepvep date;
    ld_feppk  date;
    ln_ncpr   number;
    ln_ncpa   number;
    ln_diatrc number;
  
  begin
  
    --If v_Scstat in (64,90) Then
    If v_Scmod in (200, 33, 141, 144) Then
      --se agrego carta fianza
    
      ln_diatr := v_Pgfape - v_fecven;
    
      If ln_diatr < 0 then
        ln_diatr := 0;
      End if;
    
    Else
    
      --begin
    
      begin
        --vigente y refinanciado
        SELECT (v_Pgfape - min(a.Ppfpag))
          into ln_diatr
          FROM fsd601 a
          left join fsd602 b
            on b.Pgcod = a.Pgcod
           and b.Ppmod = a.Ppmod
           and b.Ppsuc = a.Ppsuc
           and b.Ppmda = a.Ppmda
           and b.Pppap = a.Pppap
           and b.Ppcta = a.Ppcta
           and b.Ppoper = a.Ppoper
           and b.Ppsbop = a.Ppsbop
           and b.Pptope = a.Pptope
           and b.Ppfpag = a.Ppfpag
           and b.Pptipo = a.Pptipo
           and b.Pp1stat = 'T'
           and b.D602co = 'S'
           and b.pp1fech <= v_Pgfape
         where a.Pgcod = v_Pgcod
           and a.Ppmod = v_Scmod
           and a.Ppsuc = v_Scsuc
           and a.Ppmda = v_Scmda
           and a.Pppap = v_Scpap
           and a.Ppcta = v_Sccta
           and a.Ppoper = v_Scoper
           and a.Ppsbop = v_Scsbop
           and a.Pptope = v_Sctope
           and a.Ppfpag <= v_Pgfape
           and a.D601co = 'S'
           and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
           and b.D602co is null;
        if ln_diatr is null then
          Begin
            select (v_Pgfape - min(d.Ppfpag))
              into ln_diatr
              from fsd601 d
             where d.Pgcod = v_Pgcod
               and d.Ppmod = v_Scmod
               and d.Ppsuc = v_Scsuc
               and d.Ppmda = v_Scmda
               and d.Pppap = v_Scpap
               and d.Ppcta = v_Sccta
               and d.Ppoper = v_Scoper
               and d.Ppsbop = v_Scsbop
               and d.Pptope = v_Sctope
               and d.Ppfpag <= v_Pgfape
               and (d.ppcap + d.ppint) > 0;
          exception
            when no_data_found then
              ln_diatr := null;
            When others then
              null;
          End;
        end if;
      exception
        when no_data_found then
        
          Begin
            select (v_Pgfape - min(d.Ppfpag))
              into ln_diatr
              from fsd601 d
             where d.Pgcod = v_Pgcod
               and d.Ppmod = v_Scmod
               and d.Ppsuc = v_Scsuc
               and d.Ppmda = v_Scmda
               and d.Pppap = v_Scpap
               and d.Ppcta = v_Sccta
               and d.Ppoper = v_Scoper
               and d.Ppsbop = v_Scsbop
               and d.Pptope = v_Sctope
               and d.Ppfpag <= v_Pgfape
               and (d.ppcap + d.ppint) > 0;
          exception
            when no_data_found then
              ln_diatr := null;
            When others then
              null;
            
          End;
        
        --end;
      end;
      if ln_diatr is null then
        begin
          --vigente y refinanciado
          SELECT (v_Pgfape - min(a.Ppfpag))
            into ln_diatr
            FROM fsd601 a
            left join fsd602 b
              on b.Pgcod = a.Pgcod
             and b.Ppmod = a.Ppmod
             and b.Ppsuc = a.Ppsuc
             and b.Ppmda = a.Ppmda
             and b.Pppap = a.Pppap
             and b.Ppcta = a.Ppcta
             and b.Ppoper = a.Ppoper
             and b.Ppsbop = a.Ppsbop
             and b.Pptope = a.Pptope
             and b.Ppfpag = a.Ppfpag
             and b.Pptipo = a.Pptipo
             and b.Pp1stat = 'T'
             and b.D602co = 'S'
             and b.pp1fech <= v_Pgfape
           where a.Pgcod = v_Pgcod
             and a.Ppmod = v_Scmod
             and a.Ppmda = v_Scmda
             and a.Pppap = v_Scpap
             and a.Ppcta = v_Sccta
             and a.Ppoper = v_Scoper
             and a.Ppsbop = v_Scsbop
             and a.Pptope = v_Sctope
             and a.Ppfpag <= v_Pgfape
             and a.D601co = 'S'
             and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
             and b.D602co is null;
        exception
          when no_data_found then
          
            Begin
              select (v_Pgfape - min(d.Ppfpag))
                into ln_diatr
                from fsd601 d
               where d.Pgcod = v_Pgcod
                 and d.Ppmod = v_Scmod
                    --and d.Ppsuc = v_Scsuc
                 and d.Ppmda = v_Scmda
                 and d.Pppap = v_Scpap
                 and d.Ppcta = v_Sccta
                 and d.Ppoper = v_Scoper
                 and d.Ppsbop = v_Scsbop
                 and d.Pptope = v_Sctope
                 and d.Ppfpag <= v_Pgfape
                 and (d.ppcap + d.ppint) > 0;
            exception
              when no_data_found then
                ln_diatr := null;
            End;
          When others then
            null;
            --end;
        end;
      end if;
    End IF;
    -- Verifica si considera congelamiento.
    begin
      select t.opgval into lc_covi from fst200 t where opgcod = 6701;
    exception
      when others then
        lc_covi := 'N';
    end;
    if lc_covi = 'S' then
      -- Verifica si fue congelado.
      begin
        select ri000num01
          into ln_artcov
          from fri000
         where RI000USU = 'COVID19'
           and RI000EST = 'COVID19'
           and RI000INF = 'COVID19'
           and RI000EMP = v_Pgcod
           and RI000SUC = v_Scsuc
           and RI000MOD = v_Scmod
           and RI000MDA = v_Scmda
           and RI000PAP = v_Scpap
           and RI000CTA = v_Sccta
           and RI000OPER = v_Scoper
           and RI000SBOP = v_Scsbop
           and RI000TOPE = v_Sctope /*
                             and ri000num01 between 15 and 30*/
        ;
      exception
        when no_data_found then
          ln_artcov := null;
        When others then
          null;
      end;
      if ln_artcov < (NVL(ln_diatr, 0)) then
        ln_diatr := ln_artcov;
      end if;
    end if;
    /*********************/
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag), count(n.ppfpag)
        into ld_feppk, ln_ncpr
        from fsd601 n
       where n.pgcod = v_Pgcod
         and n.ppcta = v_Sccta
         and n.ppmda = v_Scmda
         and n.ppsuc = v_Scsuc
         and n.pppap = v_Scpap
         and n.ppoper = v_Scoper
         and n.ppsbop = v_Scsbop
         and n.pptope = v_Sctope
         and n.ppmod = v_Scmod
         and n.d601co = 'S'
         and n.ppcap > 0;
    exception
      when no_data_found then
        ld_feppk := null;
        ln_ncpr  := null;
      when too_many_rows then
        ld_feppk := null;
        ln_ncpr  := null;
      When others then
        null;
    end;
    /*************************************/
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fepvep
        from fsd601 n
       where n.pgcod = v_Pgcod
         and n.ppcta = v_Sccta
         and n.ppmda = v_Scmda
         and n.ppsuc = v_Scsuc
         and n.pppap = v_Scpap
         and n.ppoper = v_Scoper
         and n.ppsbop = v_Scsbop
         and n.pptope = v_Sctope
         and n.ppmod = v_Scmod
         and n.ppcap + n.ppint <> 0 -- se agrego 08/2018
            -- se modifico 20150401
            --and n.ppfpag > pd_fecpro
         and n.d601co = 'S'
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                 and o.pp1fech <= v_Pgfape
                 and o.pp1stat = 'T'
                 and o.d602co = 'S');
    exception
      when others then
        ld_fepvep := null;
    end;
  
    begin
      select /*+ parallel(n,2,1)*/
       count(n.ppfpag)
        into ln_ncpa
        from fsd601 n
       where n.pgcod = v_Pgcod
         and n.ppcta = v_Sccta
         and n.ppmda = v_Scmda
         and n.ppsuc = v_Scsuc
         and n.pppap = v_Scpap
         and n.ppoper = v_Scoper
         and n.ppsbop = v_Scsbop
         and n.pptope = v_Sctope
         and n.ppmod = v_Scmod
            -- Se agrego como control visita SBS 2017 x observacion en calendarios
         and n.ppcap + n.ppint <> 0
         and n.d601co = 'S'
         and exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= v_Pgfape
                 and o.pp1stat = 'T'
                 and o.d602co = 'S');
    exception
      when no_data_found then
        ln_ncpa := 0;
      when too_many_rows then
        ln_ncpa := null;
      When others then
        null;
    end;
  
    /********************************/
  
    begin
      select /*+ parallel(n,2,1)*/
       (min(n.ppfpag) - v_fecval) - v_period
        into ln_diagra
        from fsd601 n
       where n.pgcod = v_Pgcod
         and n.ppcta = v_Sccta
         and n.ppmda = v_Scmda
         and n.ppsuc = v_Scsuc
         and n.pppap = v_Scpap
         and n.ppoper = v_Scoper
         and n.ppsbop = v_Scsbop
         and n.pptope = v_Sctope
         and n.ppmod = v_Scmod
         and n.d601co = 'S'
         AND n.ppcap + n.ppint <> 0;
    
    exception
      when others then
        ln_diagra := 0;
    end;
  
    /**************************/
    begin
      --vigente y refinanciado
      SELECT (max(b.pp1fech) - max(a.Ppfpag))
        into ln_diatrc
        FROM fsd601 a
        left join fsd602 b
          on b.Pgcod = a.Pgcod
         and b.Ppmod = a.Ppmod
         and b.Ppsuc = a.Ppsuc
         and b.Ppmda = a.Ppmda
         and b.Pppap = a.Pppap
         and b.Ppcta = a.Ppcta
         and b.Ppoper = a.Ppoper
         and b.Ppsbop = a.Ppsbop
         and b.Pptope = a.Pptope
         and b.Ppfpag = a.Ppfpag
         and b.Pptipo = a.Pptipo
         and b.Pp1stat = 'T'
         and b.D602co = 'S'
            --and b.pptipo  <> 'K'
         and b.pp1fech <= v_Pgfape
       where a.Pgcod = v_Pgcod
         and a.Ppmod = v_Scmod
         and a.Ppsuc = v_Scsuc
         and a.Ppmda = v_Scmda
         and a.Pppap = v_Scpap
         and a.Ppcta = v_Sccta
         and a.Ppoper = v_Scoper
         and a.Ppsbop = v_Scsbop
         and a.Pptope = v_Sctope
         and a.Ppfpag <= v_Pgfape
         and a.D601co = 'S'
         and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
         and b.D602co = 'S';
    exception
      when no_data_found then
      
        Begin
          select (v_Pgfape - max(d.Ppfpag))
            into ln_diatrc
            from fsd601 d
           where d.Pgcod = v_Pgcod
             and d.Ppmod = v_Scmod
             and d.Ppsuc = v_Scsuc
             and d.Ppmda = v_Scmda
             and d.Pppap = v_Scpap
             and d.Ppcta = v_Sccta
             and d.Ppoper = v_Scoper
             and d.Ppsbop = v_Scsbop
             and d.Pptope = v_Sctope
             and d.Ppfpag <= v_Pgfape
             and (d.ppcap + d.ppint) > 0
             and d.d601co = 'S';
        exception
          when no_data_found then
            ln_diatrc := 0;
        End;
      When others then
        null;
        --end;
    end;
    if ln_diagra < 0 then
      ln_diagra := 0;
    end if;
    if ln_diatrc < 0 then
      ln_diatrc := 0;
    end if;
  
    pn_diagra := ln_diagra;
    pd_fepvep := ld_fepvep;
    pd_feppk  := ld_feppk;
    pn_ncpr   := ln_ncpr;
    pn_ncpa   := ln_ncpa;
    pn_diaatr := (NVL(ln_diatr, 0));
    pn_diatrc := (NVL(ln_diatrc, 0));
  end sn_dias_atraso_h;

  Procedure sp_job_procesa_HSD010_a(pd_fecpro in date) is
    ln_max      number;
    ln_inc      number;
    ln_ini      number;
    ln_fin      number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_coderr   varchar2(300);
    lc_hostname varchar2(64);
    x           number;
    cursor sucursal is
      select sucurs
        from fst001
       where pgcod = 1
         and sucurs < 800;
  begin
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    /*begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL120',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;*/
    /*begin
         select host_name
           into lc_hostname
           from v$instance;
    end;*/
    lc_hostname := 'SC01ZDBADM010101';
  
    ---Eliminado de data
    delete from AQPB074 t
     where t.aqpb074fcie = pd_fecpro 
    ;
    commit;
  
    delete from AQPB075 t
     where t.AQPB075FECC = pd_fecpro 
    ;
    commit;
    
  
    execute immediate ('alter session set parallel_force_local=TRUE'); --jflor 2014.01.16
    --delete  tab_jobs  where  c_Codage = 'BDC1';
    --commit;
    --x:= 0; 
    for i in sucursal loop
      ln_ini := i.sucurs;
    
      lc_variable := ' begin ' ||
                     '  pq_cr_historico_pagos_repro.sp_insertar_hsd010_a(' ||
                     ln_ini || ',' || '''' || Pd_FECpro || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      /*
      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
            --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
            DBMS_JOB.SUBMIT(job => ln_job,
                         what => lc_variable,
                         next_date => sysdate,
                         interval => null,
                         no_parse => false,
                         instance => 2,
                         force => false
                         );
           INSERT INTO  tab_jobs  (c_Codage,n_Numer1,c_detjob)
           VALUES('HSD10',ln_ini,lc_variable);
           COMMIT;
      else*/
      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate,
                      interval  => null,
                      no_parse  => false,
                      instance  => 1, --- 04042024
                      force     => false);
      INSERT INTO tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('HSD10', ln_ini, lc_variable);
      COMMIT;
      -- end if;
    /*select count(*) 
                      into x
                      from user_jobs;
                    while x = 8 loop
                      select count(*) 
                      into x
                      from user_jobs; 
                    end loop;*/
    
    end loop;
  exception
    when others then
      lc_coderr := sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'HSD10', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

PROCEDURE sp_insertar_AQPB074_AQPB088_a(pn_fecha      in date,
                                        pn_corr       in number,
                                        --pn_inst       in number,
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
  
    lx_pgcod    number;
    lx_aomod    number;
    lx_aosuc    number;
    lx_aomda    number;
    lx_aopap    number;
    lx_aocta    number;
    lx_aooper   number;
    lx_aosbop   number;
    lx_aotope   number;
    lx_aofval   date;
    lx_aofvto   date; --
    lx_aopzo    number;
    lx_aotasa   number(10, 6);
    lx_aoimp    number(17, 2);
    lx_aomd     char(1);
    lx_aostat   number;
    lx_aofe99   date;
    lx_aoperiod number;
  
    lx_frepro  date;
    lx_ncorre  number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado  varchar2(100);
    lx_fecest  date;
    lx_diaatr  number;
    lx_diagra  number;
    lx_fepvep  date;
    lx_scsdo   number(17, 2);
  
    lx_orden number;
    
    ln_diaatr  number;
    ln_diagra  number;
    ld_fepvep  date;
    ld_feppk   date;
    ln_ncpr    number;
    ln_ncpa    number;
    ln_diaatrc number;
  
  
    -- Detalle
    cursor jaqz520_601c(cr_fecha  date,
                        cr_corr   number,
                        /*
                        cr_pgcod  in number,
                        cr_aomod  in number,
                        cr_aosuc  in number,
                        cr_aomda  in number,
                        cr_aopap  in number,
                        cr_aocta  in number,
                        cr_aooper in number,
                        cr_aosbop in number,
                        cr_aotope in number
                        */
                        ln_emp   in number,
                        ln_mod   in number,
                        ln_suc   in number,
                        ln_mda   in number,
                        ln_pap   in number,
                        ln_cta   in number,
                        ln_oper  in number,
                        ln_sbop  in number,
                        ln_tope  in number) is
        select d601.PGCOD,
             d601.PPMOD,
             d601.PPSUC,
             d601.PPMDA,
             d601.PPPAP,
             d601.PPCTA,
             d601.PPOPER,
             d601.PPSBOP,
             d601.PPTOPE,
             d601.PPFPAG,
             d601.PPTIPO,
             d601.PPFVAL,
             d601.PPFVTO,
             d601.PPPZO,
             d601.PPCAP,
             d601.PPINT,
             sum(pp1intm) pp1intm,
             sum(PPINTMEX) PPINTMEX,
             sum(PPICAP) PPICAP,
             sum(PPIINT) PPIINT,
             max(PPSTAT) PPSTAT,
             /*PPFINV,*/
             max(D602CD || '-' || D602MO || '-' || D602SU || '-' || D602TR || '-' ||
                 D602RE || '-' || D602FC || '-' || D602OR || '-' || D602SB || '-' ||
                 D602CO) transa,
             /*FREPRO,
             NCORRE,
             FECCIE,
             PROCESO,*/
             max(PP1NUMP) PP1NUMP,
             max(PP1FECH) PP1FECH,
             sum(PP1CAP) PP1CAP,
             sum(PP1INT) PP1INT,
             max(PP1STAT) PP1STAT
        from fsd602 d602, fsd601 d601
       where d602.pgcod(+) = d601.pgcod
         and d602.ppmod(+) = d601.ppmod
         and d602.ppsuc(+) = d601.ppsuc
         and d602.ppmda(+) = d601.ppmda
         and d602.pppap(+) = d601.pppap
         and d602.ppcta(+) = d601.ppcta
         and d602.ppoper(+) = d601.ppoper
         and d602.ppsbop(+) = d601.ppsbop
         and d602.pptope(+) = d601.pptope
         and d602.ppfpag(+) = d601.ppfpag
            --and d602.pp1fech (+) <= ld_fecpro
            --and d601.ppfpag <=  ld_fecpro --between add_months( to_date('20140531','yyyymmdd'), -6) and  to_date('20140531','yyyymmdd')  -- add_months(trunc(sysdate),-6) and trunc(sysdate)
            --and d601.ppfvto <=  ld_fecpro
            --and d602.pp1stat (+) = 'T'
         and d602.d602co(+) = 'S'
         and d602.pp1salmor(+) = 0
         and d601.d601co = 'S'
         and d601.pgcod = ln_emp
         and d601.ppmod = ln_mod --
         and d601.ppsuc = ln_suc --
         and d601.ppmda = ln_mda
         and d601.pppap = ln_pap
         and d601.ppcta = ln_cta
         and d601.ppoper = ln_oper
         and d601.ppsbop = ln_sbop --
         and d601.pptope = ln_tope --
         and d601.ppcap + d601.ppint <> 0
       group by d601.PGCOD,
                d601.PPMOD,
                d601.PPSUC,
                d601.PPMDA,
                d601.PPPAP,
                d601.PPCTA,
                d601.PPOPER,
                d601.PPSBOP,
                d601.PPTOPE,
                d601.PPFPAG,
                d601.PPTIPO,
                d601.PPFVAL,
                d601.PPFVTO,
                d601.PPPZO,
                d601.PPCAP,
                d601.PPINT
       order by d601.ppfvto;
  
  begin
  
    begin
      select 'S'
        into lc_flag
        from aqpb088_010c q
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
      
        select q.pgcod, --lx_pgcod,
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
               q.aoperiod --lx_aoperiod
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, --
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, --
               lx_aotope, --
               lx_aofval, --
               lx_aofvto, --
               
               lx_aopzo, --
               lx_aotasa, --
               lx_aoimp, --
               lx_aostat, --
               lx_aofe99, --
               lx_aoperiod --
          from fsd010 q
         where /*q.fec = pn_fecha
           and q.cor = pn_corr
           and*/ q.pgcod = pn_pgcod
           and q.aomod = pn_aomod
           and q.aosuc = pn_aosuc
           and q.aomda = pn_aomda
           and q.aopap = pn_aopap
           and q.aocta = pn_aocta
           and q.aooper = pn_aooper
           and q.aosbop = pn_aosbop
           and q.aotope = pn_aotope;
      
        /****************************/
      
        begin
          select nvl(max(x.AQPB074orde), 0) + 1
            into lx_orden
            from AQPB074 x
           where x.AQPB074cod = pn_pgcod
             and x.AQPB074mod = pn_aomod
             and x.AQPB074suc = pn_aosuc
             and x.AQPB074mda = pn_aomda
             and x.AQPB074pap = pn_aopap
             and x.AQPB074cta = pn_aocta
             and x.AQPB074oper = pn_aooper
             and x.AQPB074sbop = pn_aosbop
             and x.AQPB074tope = pn_aotope
             and x.AQPB074fppk is null;
        exception
          when others then
            lx_orden := 1;
        end;
          /****************************/
      
        pq_cr_historico_pagos_repro.sn_dias_atraso_h(v_pgfape  => lx_frepro,
                                                     v_pgcod   => lx_pgcod,
                                                     v_scmod   => lx_aomod,
                                                     v_scsuc   => lx_aosuc,
                                                     v_scmda   => lx_aomda,
                                                     v_scpap   => lx_aopap,
                                                     v_sccta   => lx_aocta,
                                                     v_scoper  => lx_aooper,
                                                     v_scsbop  => lx_aosbop,
                                                     v_sctope  => lx_aotope,
                                                     v_scstat  => lx_aostat,
                                                     v_fecven  => lx_aofvto,
                                                     v_fecval  => lx_aofval,
                                                     v_period  => lx_aoperiod,
                                                     pn_diaatr => ln_diaatr,
                                                     pn_diagra => ln_diagra,
                                                     pd_fepvep => ld_fepvep,
                                                     pd_feppk  => ld_feppk,
                                                     pn_ncpr   => ln_ncpr,
                                                     pn_ncpa   => ln_ncpa,
                                                     pn_diatrc => ln_diaatrc);
        /****************************/
        lx_frepro  := pn_fecha;
        lx_ncorre  := pn_corr;
        lx_proceso := 'C'; ---CAPITALIZACION
        lx_fcierre := pn_fecha_prev; --lc_fecha_prv;
        --lx_instanc := pn_inst;
        ---lx_estado := 'R'; ---REPROGRAMADO ---en abril puede cambiar
        if (pn_revr = 'V') then
          lx_estado := 'X';
        else
          lx_estado := 'R';
        end if;
      
        lx_fecest := pn_fecha;
      
        /****************************/
      
            
        select nvl(sum(r.scsdo), 0)
          into lx_scsdo
          from aqpb088_011c r
         where r.fec = pn_fecha
           and r.cor = pn_corr
           
           and r.pgcod = pn_pgcod
           and r.scmod = pn_aomod
           and r.scsuc = pn_aosuc
           and r.scmda = pn_aomda
           and r.scpap = pn_aopap
           and r.sccta = pn_aocta
           and r.scoper = pn_aooper
           and r.scsbop = pn_aosbop
           and r.sctope = pn_aotope;
      
        /****************************/
        insert into AQPB074
          (aqpb074cod,
           aqpb074mod,
           aqpb074suc,
           aqpb074mda,
           aqpb074pap,
           aqpb074cta,
           aqpb074oper,
           aqpb074sbop,
           aqpb074tope,
           aqpb074fval,
           aqpb074fvto,
           aqpb074pzo,
           aqpb074tasa,
           aqpb074imp,
           aqpb074stat,
           aqpb074fe99,
           aqpb074peri,
           aqpb074frep,
           aqpb074ncor,
           aqpb074proc,
           aqpb074fcie,
           --aqpb074inst,
           aqpb074est,
           aqpb074fece,
           aqpb074diat,
           aqpb074diag,
           aqpb074fepv,
           aqpb074fppk,
           aqpb074ncpr,
           aqpb074ncpa,
           aqpb074sdo,
           aqpb074tabr,
           aqpb074dakr)
        values
          
           
          (nvl(lx_pgcod, 1),
           lx_aomod,
           lx_aosuc,
           lx_aomda,
           lx_aopap,
           lx_aocta,
           lx_aooper,
           lx_aosbop,
           lx_aotope,
           lx_aofval,
           lx_aofvto,
           lx_aopzo,
           lx_aotasa,
           lx_aoimp,
           lx_aostat,
           lx_aofe99,
           lx_aoperiod,
           lx_frepro,
           lx_ncorre,
           lx_proceso,
           lx_fcierre,
           --lx_instanc,
           lx_estado,
           lx_fecest,
           ln_diaatr,
           ln_diagra,
           ld_fepvep,
           ld_feppk,
           ln_ncpr,
           ln_ncpa,
           lx_scsdo,
           'JAQA400',
           ln_diaatrc);
      
      
        commit;
      
        /*********** INSERTAR DETALLE *****************/
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
            insert into AQPB075
              (aqpb075cod,
               aqpb075mod,
               aqpb075suc,
               aqpb075mda,
               aqpb075pap,
               aqpb075cta,
               aqpb075oper,
               aqpb075sbop,
               aqpb075tope,
               aqpb075fpag,
               aqpb075tipo,
               aqpb075fval,
               aqpb075fvto,
               aqpb075pzo,
               aqpb075cap,
               aqpb075int,
               aqpb075intmex,
               aqpb075icap,
               aqpb075iint,
               aqpb075stat,
               aqpb075frep,
               aqpb075ncor,
               aqpb075fecc,
               aqpb075proc,
               aqpb0751nump,
               aqpb0751fech,
               aqpb0751cap,
               aqpb0751int,
               aqpb0751stat,
               aqpb0751intm,
               aqpb075tabr)
            
            values
              (k.pgcod, -- lx_pgcod, 
               k.ppmod, --lx_ppmod,
               k.ppsuc, --lx_ppsuc,
               k.ppmda, --lx_ppmda,
               k.pppap, --lx_pppap,
               k.ppcta, -- lx_ppcta,
               k.ppoper, --lx_ppoper,
               k.ppsbop, --lx_ppsbop,
               k.pptope, --lx_pptope,
               k.ppfpag, --lx_ppfpag,
               k.pptipo, --lx_pptipo,
               k.ppfval, --lx_ppfval,
               k.ppfvto, --lx_ppfvto,
               k.pppzo, --lx_pppzo,
               k.ppcap, --lx_ppcap,
               k.ppint, --lx_ppint,
               k.ppintmex, --lx_ppintmex,
               k.ppicap, --lx_ppicap,
               k.ppiint, --lx_ppiint,
               k.ppstat, --lx_ppstat,               
               pn_fecha, --lx_frepro,
               pn_corr, --lx_ncorre,
               pn_fecha_prev, --lx_feccie,
               'C', --lx_proceso  
               k.pp1nump, ---jaqz520_602c  -----?
               k.pp1fech,
               k.pp1cap,
               k.pp1int,
               k.pp1stat,
               k.pp1intm,
               'JAQA400');
            commit;
          
          exception
            when others then
              lc_flag := 'N';
          end;
        end loop;
      
      end;
    end if;
  
  end sp_insertar_AQPB074_AQPB088_a;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  Procedure sp_job_procesa_HSD010_088(pd_fecpro in date) is
    ln_max      number;
    ln_inc      number;
    ln_ini      number;
    ln_fin      number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_coderr   varchar2(300);
    lc_hostname varchar2(64);
    x           number;
    cursor sucursal is
      select sucurs
        from fst001
       where pgcod = 1
         and sucurs < 800;
  begin
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';

    lc_hostname := 'SC01ZDBADM010101';
  
    ---Eliminado de data
    --- comentado 26.03.2021
    /*
    delete from AQPB074 t
     where t.aqpb074fcie = pd_fecpro 
    ;
    commit;
  
    delete from AQPB075 t
     where t.AQPB075FECC = pd_fecpro 
    ;
    commit;
    */
  
    execute immediate ('alter session set parallel_force_local=TRUE');

    for i in sucursal loop
      ln_ini := i.sucurs;
    
      lc_variable := ' begin ' ||
                     '  pq_cr_historico_pagos_repro.sp_insertar_HSD010_088(' ||
                     ln_ini || ',' || '''' || Pd_FECpro || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;

      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate,
                      interval  => null,
                      no_parse  => false,
                      instance  => 1, --- 04042024
                      force     => false);
      INSERT INTO tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('HSD10', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  exception
    when others then
      lc_coderr := sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'HSD10', lc_variable, TRUNC(SYSDATE));
      COMMIT;

  
  end sp_job_procesa_HSD010_088;  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  PROCEDURE sp_insertar_HSD010_088(pn_suc in number, pn_fecha in date) is
  
    lc_fecha_ini date;
    lc_fecha_fin date;
    lc_fecha_prv date;
    lc_coderr    varchar2(300);
  
    --Cursor JAQZ698
    cursor cur_jaqz698(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from jaqz698 j
       where j.jaqz698est in ('C', 'V')
         and j.jaqz698fep >= cr_fecha_ini
         and j.jaqz698fep <= cr_fecha_fin
         and j.JAQZ698SUC = pn_suc;
  
    --Cursor AQPB002
    cursor cur_aqpb002(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb002 j
       where j.aqpb002est = 'C'
         and j.aqpb002fep >= cr_fecha_ini
         and j.aqpb002fep <= cr_fecha_fin
         and j.aqpb002suc = pn_suc;
  
    -- Cursor AQPB088 24/03/2021
    cursor cur_aqpb088(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb088 j, jaqa400 t
       where j.aqpb088est = 'C'
         and j.aqpb088fep >= cr_fecha_ini
         and j.aqpb088fep <= cr_fecha_fin
         and j.aqpb088suc = pn_suc
         --and substr(trim(to_char(j.aqpb088ope)), -1) = pn_digito
         and t.jaqa400est = 'C'
         and j.aqpb088cor = (
                 select min(x.aqpb088cor) from aqpb088 x
                 where
                 x.aqpb088fep = j.aqpb088fep and
                 x.aqpb088emp = j.aqpb088emp and
                 x.aqpb088mod = j.aqpb088mod and
                 x.aqpb088suc = j.aqpb088suc and
                 x.aqpb088mda = j.aqpb088mda and
                 x.aqpb088pap = j.aqpb088pap and
                 x.aqpb088cta = j.aqpb088cta and
                 x.aqpb088ope = j.aqpb088ope and
                 x.aqpb088sbo = j.aqpb088sbo and
                 x.aqpb088top = j.aqpb088top
             ) and
                 j.aqpb088fep = t.jaqa400fec and
                 j.aqpb088emp = t.jaqa400emp and
                 j.aqpb088mod = t.jaqa400mod and
                 j.aqpb088suc = t.jaqa400suc and
                 j.aqpb088mda = t.jaqa400mda and
                 j.aqpb088pap = t.jaqa400pap and
                 j.aqpb088cta = t.jaqa400cta and
                 j.aqpb088ope = t.jaqa400ope and
                 j.aqpb088sbo = t.jaqa400sbo and
                 j.aqpb088top = t.jaqa400top
       order by j.aqpb088fep, j.aqpb088cor asc;   
  
  Begin
  
    lc_fecha_fin := pn_fecha;
    lc_fecha_ini := trunc(lc_fecha_fin) -
                    (to_number(to_char(lc_fecha_fin, 'DD')) - 1);
    lc_fecha_prv := pn_fecha;
    --lc_fecha_ini := '02/05/2020';
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
      update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'HSD10';
      commit;

      ---Recurrido cursor JAQZ698
      ---Recorrido cursor AQPB002

       ---Recurrido cursor AQPB088
      for i in cur_aqpb088(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB088_a(i.aqpb088fep,
                                                                i.aqpb088cor,
                                                                --i.jaqz698inst,
                                                                lc_fecha_prv,
                                                                i.aqpb088est,
                                                                
                                                                i.aqpb088emp,
                                                                i.aqpb088mod,
                                                                i.aqpb088suc,
                                                                i.aqpb088mda,
                                                                i.aqpb088pap,
                                                                i.aqpb088cta,
                                                                i.aqpb088ope,
                                                                i.aqpb088sbo,
                                                                i.aqpb088top);
      
      end loop;    
      
      update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 = pn_suc
         and g.c_codage = 'HSD10';
      commit;
    EXCEPTION
      when others then
        lc_coderr := substr(sqlerrm, 1, 200);
        update tab_jobs g
           set g.c_inderr = 'S', g.c_deserr = lc_coderr
         where g.n_numer1 = pn_suc
           and g.c_codage = 'HSD10';
        commit;
        return;
      
    end;
  
  end sp_insertar_HSD010_088;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_job_carga_088(pn_fecha_ini in date, pn_fecha_fin in date) is
  
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
    
      lc_variable := 'begin ' || '  pq_cr_historico_pagos_repro.sp_insertar_AQPB074_088(
                        ' || '''' || pn_fecha_ini || '''' || ',
                        ' || '''' || pn_fecha_fin || '''' || ',
                        ' || ln_ini || ');' || ' End;';
    
      ln_job := ln_job + 1;
      dbms_output.put_line(lc_variable);
    
      DBMS_JOB.SUBMIT(job       => ln_job,
                      what      => lc_variable,
                      next_date => sysdate,
                      interval  => null,
                      no_parse  => false,
                      instance  => 1, --- 04042024
                      force     => false);
    
      ln_ini := ln_ini + 1;
      commit;
    
    END LOOP;
  
  end sp_cr_job_carga_088;     
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  PROCEDURE sp_insertar_AQPB074_088(pn_fecha_ini in date,
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
  
     -- Cursor AQPB088
    cursor cur_aqpb088(cr_fecha_ini date, cr_fecha_fin date) is
      select *
        from aqpb088 j, jaqa400 t
       where j.aqpb088est = 'C'
         and j.aqpb088fep >= cr_fecha_ini
         and j.aqpb088fep <= cr_fecha_fin
         and substr(trim(to_char(j.aqpb088ope)), -1) = pn_digito
         and t.jaqa400est = 'C'
         and j.aqpb088cor = (
                 select min(x.aqpb088cor) from aqpb088 x
                 where
                 x.aqpb088fep = j.aqpb088fep and
                 x.aqpb088emp = j.aqpb088emp and
                 x.aqpb088mod = j.aqpb088mod and
                 x.aqpb088suc = j.aqpb088suc and
                 x.aqpb088mda = j.aqpb088mda and
                 x.aqpb088pap = j.aqpb088pap and
                 x.aqpb088cta = j.aqpb088cta and
                 x.aqpb088ope = j.aqpb088ope and
                 x.aqpb088sbo = j.aqpb088sbo and
                 x.aqpb088top = j.aqpb088top
             ) and
                 j.aqpb088fep = t.jaqa400fec and
                 j.aqpb088emp = t.jaqa400emp and
                 j.aqpb088mod = t.jaqa400mod and
                 j.aqpb088suc = t.jaqa400suc and
                 j.aqpb088mda = t.jaqa400mda and
                 j.aqpb088pap = t.jaqa400pap and
                 j.aqpb088cta = t.jaqa400cta and
                 j.aqpb088ope = t.jaqa400ope and
                 j.aqpb088sbo = t.jaqa400sbo and
                 j.aqpb088top = t.jaqa400top
       order by j.aqpb088fep, j.aqpb088cor asc;     
  
  Begin
  
    lc_fecha_fin := pn_fecha_fin;
    --lc_fecha_ini:= trunc(lc_fecha_fin) - (to_number(to_char(lc_fecha_fin,'DD')) - 1);
    lc_fecha_ini := pn_fecha_ini;
    lc_fecha_prv := lc_fecha_ini - 1;
  
    dbms_output.put_line(to_char(lc_fecha_ini, 'YYYY-MM-DD'));
    dbms_output.put_line(to_char(lc_fecha_fin, 'YYYY-MM-DD'));
  
    begin
    
      --Recurrido cursor JAQZ698
      --Recorrido cursor AQPB002

      ---Recurrido cursor AQPB088
      for i in cur_aqpb088(lc_fecha_ini, lc_fecha_fin) loop
      
        pq_cr_historico_pagos_repro.sp_insertar_AQPB074_AQPB088(i.aqpb088fep,
                                                                i.aqpb088cor,
                                                                --i.jaqz698inst,
                                                                lc_fecha_prv,
                                                                i.aqpb088est,
                                                                
                                                                i.aqpb088emp,
                                                                i.aqpb088mod,
                                                                i.aqpb088suc,
                                                                i.aqpb088mda,
                                                                i.aqpb088pap,
                                                                i.aqpb088cta,
                                                                i.aqpb088ope,
                                                                i.aqpb088sbo,
                                                                i.aqpb088top);
      
      end loop;       
    
    end;
  
  end sp_insertar_AQPB074_088;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
end pq_cr_historico_pagos_repro;

-- HSD010 -> AQPB074
-- HSD601  -> AQPB075
/

