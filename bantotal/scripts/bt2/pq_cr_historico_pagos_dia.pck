create or replace package pq_cr_historico_pagos_dia is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_dia
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 30/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones individuales
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación 
  -- *****************************************************************

PROCEDURE sp_verificar_cronograma(pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number,
                                    pn_estado in char);
                                                              
 PROCEDURE sp_insertar_FSD601(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              
 PROCEDURE sp_insertar_FSD602(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number); 
                              
 PROCEDURE sp_insertar_FSD611(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);    
                              
 PROCEDURE sp_insertar_FPP001(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number);     
                              
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
                           
                              
PROCEDURE sp_insertar_JAQZ698(pn_fecha in date,
                              pn_corr in number,
                               pn_pgcod in number,
                               pn_aomod in number, 
                               pn_aosuc in number, 
                               pn_aomda in number, 
                               pn_aopap in number, 
                               pn_aocta in number, 
                               pn_aooper in number, 
                               pn_aosbop in number, 
                               pn_aotope in number,
                               pn_estado in char,
                               pn_salida out number);                                                                                                                                                                                                                                      
                                
PROCEDURE sp_insertar_AQPB002(pn_fecha in date, 
                              pn_corr in number, 
    
                              pn_pgcod in number,
                              pn_aomod in number, 
                              pn_aosuc in number, 
                              pn_aomda in number, 
                              pn_aopap in number, 
                              pn_aocta in number, 
                              pn_aooper in number, 
                              pn_aosbop in number, 
                              pn_aotope in number,
                              pn_estado in char,
                              pn_salida out number
                              );   
                                   
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
                                    pn_revr in char,
                                    pn_estado in char,
                                    pn_salida out number
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
                                pn_aotope in number,
                                pn_estado in char,
                                pn_salida out number
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
                                      
PROCEDURE sp_insertar_repro_agencia(pn_fecha in date,
                                    pn_corr in number,
                                    pn_pgcod in number,
                                    pn_aomod in number, 
                                    pn_aosuc in number, 
                                    pn_aomda in number, 
                                    pn_aopap in number, 
                                    pn_aocta in number, 
                                    pn_aooper in number, 
                                    pn_aosbop in number, 
                                    pn_aotope in number,
                                    pn_estado in char,
                                    pn_salida out number);  
                                    
PROCEDURE sp_insertar_JAQA255(pn_fecha in date,

                              pn_pgcod  in number,
                              pn_aomod  in number,
                              pn_aosuc  in number,
                              pn_aomda  in number,
                              pn_aopap  in number,
                              pn_aocta  in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number,
                              pn_estado in char,
                              pn_salida out number);                                         
                         
PROCEDURE sp_actualizar_datos(pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number);                         
                                                                                                                                                        
procedure sp_ultfeccalen(pn_emp    in number,
                         pn_mod    in number,
                         pn_suc    in number,
                         pn_mda    in number,
                         pn_pap    in number,
                         pn_cta    in number,
                         pn_ope    in number,
                         pn_sbo    in number,
                         pn_top    in number,
                         pd_fec    out date,
                         pn_cuotas out number,
                         pn_flag   out number);
                         
 Procedure sp_backup_ini(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_usu in varchar2);         
                          
procedure sp_verifica_refinanciado(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_flag out number);  
                                     
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
                              
PROCEDURE sp_eliminar_registros(pn_pgcod  in number,
                                    pn_aomod  in number,
                                    pn_aosuc  in number,
                                    pn_aomda  in number,
                                    pn_aopap  in number,
                                    pn_aocta  in number,
                                    pn_aooper in number,
                                    pn_aosbop in number,
                                    pn_aotope in number);                                                                                                             

end pq_cr_historico_pagos_dia;
/

create or replace package body pq_cr_historico_pagos_dia is

  -- *****************************************************************
  -- Nombre                       : pq_cr_historico_pagos_dia
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 30/07/2020
  -- Autor de Creación            : jjrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar y registrar el histórico de reprogramaciones individuales
  -- Fecha de Modificación        : 25/08/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del tipo de operación 
  -- *****************************************************************

PROCEDURE sp_verificar_cronograma(pn_pgcod in number,
                                  pn_aomod in number,
                                  pn_aosuc in number,
                                  pn_aomda in number,
                                  pn_aopap in number,
                                  pn_aocta in number,
                                  pn_aooper in number,
                                  pn_aosbop in number,
                                  pn_aotope in number,
                                  pn_estado in char) is

    lc_flag char(1);
    lc_aqpb002 number;
    lc_jaqz698 number;
    lc_jaqa255 number;  
    lc_aqpb012 number;
    --lc_tabla char(10);
    
    lx_fecha date;
    lx_corr number;
    lx_emp number;
    lx_mod number;
    --lx_suc number;
    lx_mda number;
    lx_pap number;
    lx_cta number;
    lx_oper number;
    --lx_sbop number;
    lx_tope number;
    lx_tabla char(10);
    
    ln_fecha date;
    ln_corr number;
    ln_emp number;
    ln_mod number;
    ln_suc number;
    ln_mda number;
    ln_pap number;
    ln_cta number;
    ln_oper number;
    ln_sbop number;
    ln_tope number;  
    ln_salida number;  

begin

--1. Verificar existencia de reprogramación
    lc_aqpb002 := 0;
    lc_jaqz698 := 0;
    lc_jaqa255 := 0;
    lc_aqpb012 := 0;

    begin
      
        select 
              count(*) into lc_aqpb002
        from 
              aqpb002 x
        where 
              x.aqpb002emp = pn_pgcod and
              x.aqpb002mod = pn_aomod and
              --x.aqpb002suc = pn_aosuc and
              x.aqpb002mda = pn_aomda and
              x.aqpb002pap = pn_aopap and
              x.aqpb002cta = pn_aocta and
              x.aqpb002ope = pn_aooper and
              --x.aqpb002sbo = pn_aosbop and
              --x.aqpb002top = pn_aotope and
              x.aqpb002est = 'C';
              
              
        if lc_aqpb002 = 0 then
          
              select 
                    count(*) into lc_jaqz698
              from 
                    jaqz698 x
              where 
                    x.jaqz698emp = pn_pgcod and
                    x.jaqz698mod = pn_aomod and
                    --x.jaqz698suc = pn_aosuc and
                    x.jaqz698mda = pn_aomda and
                    x.jaqz698pap = pn_aopap and
                    x.jaqz698cta = pn_aocta and
                    x.jaqz698ope = pn_aooper and
                    --x.jaqz698sbo = pn_aosbop and
                    --x.jaqz698top = pn_aotope and
                    x.jaqz698est in ('C','V');

              if lc_jaqz698 = 0 then
                
                    select 
                          count(*) into lc_jaqa255
                    from 
                          jaqa255 x
                    where 
                          x.jaqa255emp = pn_pgcod and
                          x.jaqa255mod = pn_aomod and
                          --x.jaqa255suc = pn_aosuc and
                          x.jaqa255mda = pn_aomda and
                          x.jaqa255pap = pn_aopap and
                          x.jaqa255cta = pn_aocta and
                          x.jaqa255ope = pn_aooper and
                          --x.jaqa255sbo = pn_aosbop and
                          --x.jaqa255tpo = pn_aotope and
                          x.jaqa255est = 'L';   
                     
 
                     if lc_jaqa255 = 0 then
                       
                          select 
                                count(*) into lc_aqpb012
                          from 
                                aqpb012 x
                          where 
                                x.aqpb012pgcod = pn_pgcod and
                                x.aqpb012mod = pn_aomod and
                                --x.aqpb012suc = pn_aosuc and
                                x.aqpb012mda = pn_aomda and
                                x.aqpb012pap = pn_aopap and
                                x.aqpb012cta = pn_aocta and
                                x.aqpb012oper = pn_aooper --and
                                --x.aqpb012sbop = pn_aosbop and
                                --x.aqpb012tope = pn_aotope 
                                ;
                     
                     end if;
              
              end if;        
        
        end if;
    
    end;


--2. Verificar existencia en las tablas de reprogramaciones
     if (lc_aqpb002 + lc_jaqz698 + lc_jaqa255 + lc_aqpb012)>0 then
     
        --dbms_output.put_line('2. CRÉDITO REPROGRAMADO');
        
        --2.1 Verificar que no exista el crédito en la tabla AQPB009 con la clave completa
        begin
            select 'S'
                   into lc_flag
            from
                 aqpb009 t
            where
               t.aqpb009emp = pn_pgcod and
               t.aqpb009mod = pn_aomod and
               t.aqpb009suc = pn_aosuc and
               t.aqpb009mda = pn_aomda and
               t.aqpb009pap = pn_aopap and
               t.aqpb009cta = pn_aocta and
               t.aqpb009ope = pn_aooper and
               t.aqpb009sbo = pn_aosbop and
               t.aqpb009top = pn_aotope ;
        exception
          when others then
            lc_flag := 'N';
        end;

        
        if lc_flag = 'N' then
           
           --dbms_output.put_line('2.2 CRÉDITO REPROGRAMADO NO EXISTENTE EN AQPB009');
            -- 2.2 Verificar la existencia del crédito en la tabla AQPB009 sin considerar suc y sbop
            begin
              select 'S'
                     into lc_flag
              from
                   aqpb009 t
               where
                   t.aqpb009emp = pn_pgcod and
                   t.aqpb009mod = pn_aomod and
                   --t.aqpb009suc = pn_aosuc and
                   t.aqpb009mda = pn_aomda and
                   t.aqpb009pap = pn_aopap and
                   t.aqpb009cta = pn_aocta and
                   t.aqpb009ope = pn_aooper --and
                   --t.aqpb009sbo = pn_aosbop and
                   --t.aqpb009top = pn_aotope 
                   ;
            exception
              when others then
                lc_flag := 'N';
            end;

            if lc_flag = 'S' then
              -- 2.3 Si el crédito existe, actualizar suc y sbop
              begin
                  --dbms_output.put_line('2.3 ACTUALIZAR SUC Y SBOP');

                  pq_cr_historico_pagos_dia.sp_actualizar_datos(pn_pgcod,
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
              -- 2.4 si el crédito no existe, registrar datos
              begin
                  --dbms_output.put_line('2.4 REGISTRAR DATOS');

                  -- 2.5 Obtener primera clave del crédito
                  select 
                    f.fep,
                    f.cor,
                    f.emp,
                    f.modu,
                    f.mda,
                    f.pap,
                    f.cta,
                    f.ope,
                    --f.top,
                    f.tablaref
                    into lx_fecha,
                         lx_corr,
                         lx_emp,
                         lx_mod,
                         lx_mda,
                         lx_pap,
                         lx_cta,
                         lx_oper,
                         --lx_tope,
                         lx_tabla
                  from
                  (
                  select 
                      y.fep,
                      y.cor,
                      y.emp,
                      y.modu,
                      y.mda,
                      y.pap,
                      y.cta,
                      y.ope,
                      --y.top,
                      y.tablaref
                  from (
                        select 
                               t.jaqz698fep fep,
                               t.jaqz698cor cor,
                               t.jaqz698emp emp,
                               t.jaqz698mod modu,
                               --t.jaqz698suc,
                               t.jaqz698mda mda,
                               t.jaqz698pap pap,
                               t.jaqz698cta cta,
                               t.jaqz698ope ope,
                               --t.jaqz698sbo,
                               --t.jaqz698top top,
                               'JAQZ698' tablaref
                        from 
                               jaqz698 t 
                        where 
                               t.jaqz698emp = pn_pgcod and
                               t.jaqz698mod = pn_aomod and
                               --t.jaqz698suc = and
                               t.jaqz698mda = pn_aomda and
                               t.jaqz698pap = pn_aopap and
                               t.jaqz698cta = pn_aocta and
                               t.jaqz698ope = pn_aooper and
                               --t.jaqz698sbo = and
                               --t.jaqz698top = pn_aotope and
                               t.jaqz698est in ('C','V')
                               
                        union   
                            
                        select 
                               t.aqpb002fep fep,
                               t.aqpb002cor cor,
                               t.aqpb002emp emp,
                               t.aqpb002mod modu,
                               --t.aqpb002suc,
                               t.aqpb002mda mda,
                               t.aqpb002pap pap,
                               t.aqpb002cta cta,
                               t.aqpb002ope ope,
                               --t.aqpb002sbo,
                               --t.aqpb002top top,
                               'AQPB002'  tablaref
                        from 
                               aqpb002 t 
                        where 
                               t.aqpb002emp = pn_pgcod and
                               t.aqpb002mod = pn_aomod and
                               --t.aqpb002suc = and
                               t.aqpb002mda = pn_aomda and
                               t.aqpb002pap = pn_aopap and
                               t.aqpb002cta = pn_aocta and
                               t.aqpb002ope = pn_aooper and
                               --t.aqpb002sbo = and
                               --t.aqpb002top = pn_aotope and
                               t.aqpb002est='C'
                        union 
                        select
                              t.jaqa255fec fep,
                              1 cor, 
                              t.jaqa255emp emp,
                              t.jaqa255mod modu,
                              --t.jaqa255suc,
                              t.jaqa255mda mda,
                              t.jaqa255pap pap,
                              t.jaqa255cta cta,
                              t.jaqa255ope ope,
                              --t.jaqa255sbo,
                              --t.jaqa255tpo  top,
                              'JAQA255'  tablaref
                        from 
                              jaqa255 t 
                        where 
                              t.jaqa255emp = pn_pgcod and
                              t.jaqa255mod = pn_aomod and
                              --t.jaqa255suc = and
                              t.jaqa255mda = pn_aomda and
                              t.jaqa255pap = pn_aopap and
                              t.jaqa255cta = pn_aocta and
                              t.jaqa255ope = pn_aooper and
                              --t.jaqa255sbo = and
                              --t.jaqa255tpo = pn_aotope and
                              t.jaqa255est = 'L'
                        union
                        select 
                              t.aqpb012fec fep,
                              t.aqpb012cor cor,
                              t.aqpb012pgcod emp,
                               t.aqpb012mod modu,
                               ---t.aqpb012suc,
                               t.aqpb012mda mda,
                               t.aqpb012pap pap,
                               t.aqpb012cta cta,
                               t.aqpb012oper ope,
                               --t.aqpb012sbop,
                               --t.aqpb012tope top,
                               'AQPB012'  tablaref
                        from 
                               aqpb012 t 
                         where 
                               t.aqpb012pgcod = pn_pgcod and
                               t.aqpb012mod = pn_aomod and
                               --t.aqpb012suc = and
                               t.aqpb012mda = pn_aomda and
                               t.aqpb012pap = pn_aopap and
                               t.aqpb012cta = pn_aocta and
                               t.aqpb012oper = pn_aooper --and
                               --t.aqpb012sbop = and
                               --t.aqpb012tope = pn_aotope 

                  ) y
                  order by 
                        y.fep,y.cor asc
                  ) f
                  where
                        rownum = 1
                  ;

                  --Obtener clave del crédito completa 
                  --dbms_output.put_line('2.5 TABLA ' || lx_tabla);
                  if trim(lx_tabla)='JAQZ698' then
                    
                        select x.jaqz698fep,
                               x.jaqz698cor,
                               x.jaqz698emp,
                               x.jaqz698mod,
                               x.jaqz698suc,
                               x.jaqz698mda,
                               x.jaqz698pap,
                               x.jaqz698cta,
                               x.jaqz698ope,
                               x.jaqz698sbo,
                               x.jaqz698top 
                        into
                              ln_fecha,
                              ln_corr,
                              ln_emp,
                              ln_mod,
                              ln_suc,
                              ln_mda,
                              ln_pap,
                              ln_cta,
                              ln_oper,
                              ln_sbop,
                              ln_tope
                        from jaqz698 x
                        where
                           x.jaqz698fep = lx_fecha and
                           x.jaqz698cor = lx_corr and
                           x.jaqz698emp = lx_emp and
                           x.jaqz698mod = lx_mod and
                           --x.jaqz698suc = and
                           x.jaqz698mda = lx_mda and
                           x.jaqz698pap = lx_pap and
                           x.jaqz698cta = lx_cta and
                           x.jaqz698ope = lx_oper and
                           --x.jaqz698sbo = and
                           --x.jaqz698top = lx_tope and
                           x.jaqz698est in ('C','V');
                  
                  elsif trim(lx_tabla)='AQPB002' then
                    
                        select 
                               x.aqpb002fep,
                               x.aqpb002cor,
                               x.aqpb002emp,
                               x.aqpb002mod,
                               x.aqpb002suc,
                               x.aqpb002mda,
                               x.aqpb002pap,
                               x.aqpb002cta,
                               x.aqpb002ope,
                               x.aqpb002sbo,
                               x.aqpb002top
                        into
                              ln_fecha,
                              ln_corr,
                              ln_emp,
                              ln_mod,
                              ln_suc,
                              ln_mda,
                              ln_pap,
                              ln_cta,
                              ln_oper,
                              ln_sbop,
                              ln_tope
                        from aqpb002 x
                        where
                           x.aqpb002fep = lx_fecha and
                           x.aqpb002cor = lx_corr and
                           x.aqpb002emp = lx_emp and
                           x.aqpb002mod = lx_mod and
                           --x.jaqz698suc = and
                           x.aqpb002mda = lx_mda and
                           x.aqpb002pap = lx_pap and
                           x.aqpb002cta = lx_cta and
                           x.aqpb002ope = lx_oper and
                           --x.jaqz698sbo = and
                           --x.aqpb002top = lx_tope and
                           x.aqpb002est in ('C');                  
                  
                  elsif trim(lx_tabla)='JAQA255' then
                    
                        select 
                               x.jaqa255fec,
                               1,
                               x.jaqa255emp,
                               x.jaqa255mod,
                               x.jaqa255suc,
                               x.jaqa255mda,
                               x.jaqa255pap,
                               x.jaqa255cta,
                               x.jaqa255ope,
                               x.jaqa255sbo,
                               x.jaqa255tpo
                        into
                              ln_fecha,
                              ln_corr,
                              ln_emp,
                              ln_mod,
                              ln_suc,
                              ln_mda,
                              ln_pap,
                              ln_cta,
                              ln_oper,
                              ln_sbop,
                              ln_tope
                        from jaqa255 x
                        where
                           x.jaqa255fec = lx_fecha and
                           x.jaqa255emp = lx_emp and
                           x.jaqa255mod = lx_mod and
                           --x.jaqz698suc = and
                           x.jaqa255mda = lx_mda and
                           x.jaqa255pap = lx_pap and
                           x.jaqa255cta = lx_cta and
                           x.jaqa255ope = lx_oper and
                           --x.jaqz698sbo = and
                           --x.jaqa255tpo = lx_tope and
                           x.jaqa255est in ('L');                   
                  
                  elsif trim(lx_tabla)='AQPB012' then
                  
                        select 
                               x.aqpb012fec, 
                               x.aqpb012cor,
                               x.aqpb012pgcod,
                               x.aqpb012mod,
                               x.aqpb012suc,
                               x.aqpb012mda,
                               x.aqpb012pap,
                               x.aqpb012cta,
                               x.aqpb012oper,
                               x.aqpb012sbop,
                               x.aqpb012tope
                        into
                              ln_fecha,
                              ln_corr,
                              ln_emp,
                              ln_mod,
                              ln_suc,
                              ln_mda,
                              ln_pap,
                              ln_cta,
                              ln_oper,
                              ln_sbop,
                              ln_tope
                        from aqpb012 x
                        where
                           x.aqpb012fec = lx_fecha and
                           x.aqpb012cor = lx_corr and
                           x.aqpb012pgcod = lx_emp and
                           x.aqpb012mod = lx_mod and
                           --x.jaqz698suc = and
                           x.aqpb012mda = lx_mda and
                           x.aqpb012pap = lx_pap and
                           x.aqpb012cta = lx_cta and
                           x.aqpb012oper = lx_oper --and
                           --x.jaqz698sbo = and
                           --x.aqpb012tope = lx_tope
                           ;                   
                  
                  end if;

                  --Procesar registro de históricos
                  if trim(lx_tabla)='JAQZ698' then
                  
                       pq_cr_historico_pagos_dia.sp_insertar_JAQZ698(ln_fecha,
                                                                     ln_corr,
                                                                     ln_emp,
                                                                     ln_mod,
                                                                     ln_suc,
                                                                     ln_mda,
                                                                     ln_pap,
                                                                     ln_cta,
                                                                     ln_oper,
                                                                     ln_sbop,
                                                                     ln_tope,
                                                                     pn_estado,
                                                                     ln_salida);                    
                  
                  elsif trim(lx_tabla)='AQPB002' then
                    
                       pq_cr_historico_pagos_dia.sp_insertar_AQPB002(ln_fecha,
                                                                     ln_corr,
                                                                     ln_emp,
                                                                     ln_mod,
                                                                     ln_suc,
                                                                     ln_mda,
                                                                     ln_pap,
                                                                     ln_cta,
                                                                     ln_oper,
                                                                     ln_sbop,
                                                                     ln_tope,
                                                                     pn_estado,
                                                                     ln_salida);
                  
                  elsif trim(lx_tabla)='JAQA255' then
                  
                       pq_cr_historico_pagos_dia.sp_insertar_JAQA255(ln_fecha,
                                                                     --ln_corr,
                                                                     ln_emp,
                                                                     ln_mod,
                                                                     ln_suc,
                                                                     ln_mda,
                                                                     ln_pap,
                                                                     ln_cta,
                                                                     ln_oper,
                                                                     ln_sbop,
                                                                     ln_tope,
                                                                     pn_estado,
                                                                     ln_salida);                    
                  
                  elsif trim(lx_tabla)='AQPB012' then
                  
                       pq_cr_historico_pagos_dia.sp_insertar_repro_agencia(ln_fecha,
                                                                           ln_corr,
                                                                           ln_emp,
                                                                           ln_mod,
                                                                           ln_suc,
                                                                           ln_mda,
                                                                           ln_pap,
                                                                           ln_cta,
                                                                           ln_oper,
                                                                           ln_sbop,
                                                                           ln_tope,
                                                                           pn_estado,
                                                                           ln_salida);                    
                  
                  end if;
                  
                  
                  --Actualización de suboperacion y sucursal
                  
                  if ln_salida = 1 then
                    
                      --dbms_output.put_line('3. ACTUALIZAR SUC Y SBOP DESPUES DE INSERTAR');
                      pq_cr_historico_pagos_dia.sp_actualizar_datos(pn_pgcod,
                                                                    pn_aomod,
                                                                    pn_aosuc,
                                                                    pn_aomda,
                                                                    pn_aopap,
                                                                    pn_aocta,
                                                                    pn_aooper,
                                                                    pn_aosbop,
                                                                    pn_aotope);  
                  
                  end if;
                  
              end;
              
            end if;

        end if;

     --- 2.1 Fin     
     end if;

end sp_verificar_cronograma;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 PROCEDURE sp_insertar_FSD601(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);    
      
    ---ACTUAL
    cursor jaqz520_fsd601 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
             *
      from 
             FSD601 t
      where 
             t.pgcod = cr_pgcod
             and t.ppmod = cr_aomod
             and t.ppsuc = cr_aosuc
             and t.ppmda = cr_aomda
             and t.pppap = cr_aopap
             and t.ppcta = cr_aocta
             and t.ppoper = cr_aooper
             and t.ppsbop = cr_aosbop
             and t.pptope = cr_aotope
       order by t.ppfpag asc
       ;                    
                  
begin
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
     
     --Evaluar MARZO
     select 
            count(*) into lx_cont
      from 
            FSD601 t 
      where 
           t.pgcod = pn_pgcod and
           t.ppmod = pn_aomod and
           t.ppsuc = pn_aosuc and
           t.ppmda = pn_aomda and
           t.pppap = pn_aopap and
           t.ppcta = pn_aocta and
           t.ppoper = pn_aooper and
           t.ppsbop = 0 and
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
               k.ppsbop
               );
          exception
            when others then
              --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   501,
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
                   'D',
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
               k.ppsbop
               );
          exception
            when others then
              --lc_flag := 'N';
              
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   501,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit; 
              
          end;
        end loop;
        commit;       
            
     end if;
                                             
                                  
end sp_insertar_FSD601;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        

 PROCEDURE sp_insertar_FSD602(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);     
 
    ---ACTUAL
    cursor jaqz520_fsd602 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
            *
      from 
             FSD602 t
      where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc
       ;                   
                  
      
begin
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
     
     --Actual
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
       and t.pptope = pn_aotope;

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
               502,
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
               'D',
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
               502,
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
               'D',
               lc_coderr,
               lc_msgerr);
            commit;
          
        end;
      end loop;
      commit;

    end if;
                                             
                                  
end sp_insertar_FSD602;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

 PROCEDURE sp_insertar_FSD611(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
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
      from 
           FSD611 t
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
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;          

     --Evaluar MARZO
     select 
            count(*) into lx_cont
      from 
            FSD611 t 
      where 
           t.pgcod = pn_pgcod and
           t.ppmod = pn_aomod and
           t.ppsuc = pn_aosuc and
           t.ppmda = pn_aomda and
           t.pppap = pn_aopap and
           t.ppcta = pn_aocta and
           t.ppoper = pn_aooper and
           t.ppsbop = 0 and
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
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   503,
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
                   'D',
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
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   503,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;    
                           
              
          end;
        end loop;
        commit;       
                    
     end if;
                                             
                                  
end sp_insertar_FSD611;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  
 PROCEDURE sp_insertar_FPP001(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
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
      select 
             *
      from 
             FPP001 t
       where 
             t.pgcod = cr_pgcod
             and t.aomod = cr_aomod
             and t.aosuc = cr_aosuc
             and t.aomda = cr_aomda
             and t.aopap = cr_aopap
             and t.aocta = cr_aocta
             and t.aooper = cr_aooper
             and t.aosbop = cr_aosbop
             and t.aotope = cr_aotope;
      
begin
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;     

     --Evaluar MARZO
     select 
            count(*) into lx_cont
      from 
            FPP001 t 
      where 
            t.pgcod = pn_pgcod
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
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   504,
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
                   'D',
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
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   504,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;               
              
          end;
        end loop;
        commit;       
                 
     end if;
                                             
                                  
end sp_insertar_FPP001;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  
 PROCEDURE sp_insertar_FPP002(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);     
                              
    ---ACTUAL
    cursor jaqz520_fpp002 ( cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
      select 
            * 
      from 
            FPP002 t 
      where 
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope
      ;                      
                  
      
begin
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;     
     
     --ACTUAL
     select 
            count(*) into lx_cont
      from 
            FPP002 t 
      where 
           t.pgcod = pn_pgcod and
           t.ppmod = pn_aomod and
           t.ppsuc = pn_aosuc and
           t.ppmda = pn_aomda and
           t.pppap = pn_aopap and
           t.ppcta = pn_aocta and
           t.ppoper = pn_aooper and
           t.ppsbop = 0 and --pn_aosbop
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
                (
                  aqpa973cod,
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
                  aqpa973obop
                )
                values
                (
                    r.pgcod,
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
                    r.ppsbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   505,
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
                   'D',
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
                (
                  aqpa973cod,
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
                  aqpa973obop
                )
                values
                (
                    r.pgcod,
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
                    r.ppsbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   505,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;                      
                     
             end;
       end loop;
       commit;    

     end if;
                                             
                                  
end sp_insertar_FPP002;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  
PROCEDURE sp_insertar_X054023(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);     
                              
    ---ACTUAL   
    cursor jaqz520_x054023 ( cr_pgcod number,
                      cr_aomod number, 
                      cr_aosuc number, 
                      cr_aomda number, 
                      cr_aopap number, 
                      cr_aocta number, 
                      cr_aooper number, 
                      cr_aosbop number, 
                      cr_aotope number) is    
      select 
            * 
       from 
            X054023 t 
       where 
             t.xllpgcod = cr_pgcod and
             t.xllaomod = cr_aomod and
             t.xllaosuc = cr_aosuc and
             t.xllaomda = cr_aomda and
             t.xllaopap = cr_aopap and
             t.xllaocta = cr_aocta and
             t.xllaooper = cr_aooper and
             t.xllaosbop = cr_aosbop and
             t.xllaotop = cr_aotope 
          ;                     
                  
      
begin
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;     
     
     --ACTUAL
     select 
            count(*) into lx_cont
      from 
            X054023 t 
      where 
           t.xllpgcod = pn_pgcod and
           t.xllaomod = pn_aomod and
           t.xllaosuc = pn_aosuc and
           t.xllaomda = pn_aomda and
           t.xllaopap = pn_aopap and
           t.xllaocta = pn_aocta and
           t.xllaooper = pn_aooper and
           t.xllaosbop = 0 and --pn_aosbop
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
                 (
                  aqpb060pgcod,
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
                  aqpb060aoobop 
                )
                values
                (
                  s.xllpgcod,
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
                  s.xllaosbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   506,
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
                   'D',
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
                 (
                  aqpb060pgcod,
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
                  aqpb060aoobop 
                )
                values
                (
                  s.xllpgcod,
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
                  s.xllaosbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   506,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;                      
                     
             end;
          end loop;
       commit;     
           
     end if;
                                             
                                  
end sp_insertar_X054023;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 
 PROCEDURE sp_insertar_FSD012(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);     
                                 
    ---ACTUAL  
    cursor jaqz520_fsd012 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
    select 
          * 
    from 
          FSD012 t 
    where 
         t.pgcod = cr_pgcod and
         t.aomod = cr_aomod and
         t.aosuc = cr_aosuc and
         t.aomda = cr_aomda and
         t.aopap = cr_aopap and
         t.aocta = cr_aocta and
         t.aooper = cr_aooper and
         t.aosbop = cr_aosbop and
         t.aotope =  cr_aotope
    ;               
                                
      
begin
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;     
     
     --Evaluar MARZO
     select 
            count(*) into lx_cont
      from 
            FSD012 t 
      where 
           t.pgcod = pn_pgcod and
           t.aomod = pn_aomod and
           t.aosuc = pn_aosuc and
           t.aomda = pn_aomda and
           t.aopap = pn_aopap and
           t.aocta = pn_aocta and
           t.aooper = pn_aooper and
           t.aosbop = 0 and --pn_aosbop
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
                (
                  aqpa975cod,
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
                  aqpa975obop
                )                           
                values
                (
                    u.pgcod,
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
                    u.aosbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   507,
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
                   'D',
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
                (
                  aqpa975cod,
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
                  aqpa975obop
                )                           
                values
                (
                    u.pgcod,
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
                    u.aosbop
                );
             exception
                when others then
                     --lc_flag := 'N';
                     
                lc_coderr := sqlcode;
                lc_msgerr := substr(trim(sqlerrm),1,90);
                      
                insert into aqpb066
                (  
                    aqpb066fep,
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
                    aqpb066eamsge
                 )
                values
                (  
                   lc_fecha,
                   507,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;                      
                     
             end;
          end loop;
       commit;      
       
     end if;
                                             
                                  
end sp_insertar_FSD012;                                 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

PROCEDURE sp_insertar_JAQZ698(pn_fecha in date, 
                             pn_corr in number,
                             pn_pgcod in number,
                             pn_aomod in number, 
                             pn_aosuc in number, 
                             pn_aomda in number, 
                             pn_aopap in number, 
                             pn_aocta in number, 
                             pn_aooper in number, 
                             pn_aosbop in number, 
                             pn_aotope in number,
                             pn_estado in char,
                             pn_salida out number)
is
    lc_flag char(1) ;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_estado varchar2(100);
    lx_scsdo number(17,2);
    lx_orden number;   
    lc_coderr char(100);
    lc_msgerr char(100);      
    lx_cont number;
    
    -- Detalle
    cursor jaqz520_601c (cr_fecha date, 
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           jaqz520_601c t
      where
           t.fec = cr_fecha and 
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;
      
    cursor jaqz520_602c (cr_fecha date, 
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           jaqz520_602c t
      where
           t.fec = cr_fecha and 
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;      
    
    cursor jaqz520_611c (cr_fecha date, 
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           jaqz520_611c t
      where
           t.fec = cr_fecha and 
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;    
    
    cursor jaqz520_001c (cr_fecha date, 
                      cr_corr number,
                      cr_pgcod number,
                      cr_aomod number, 
                      cr_aosuc number, 
                      cr_aomda number, 
                      cr_aopap number, 
                      cr_aocta number, 
                      cr_aooper number, 
                      cr_aosbop number, 
                      cr_aotope number) is    
      select 
           *
      from 
           aqpa004v1 t
      where
           t.aqpa4cfep = cr_fecha and 
           t.aqpa4ccor = cr_corr and
           t.aqpa4cpgcod = cr_pgcod and
           t.aqpa4caomod = cr_aomod and
           t.aqpa4caosuc = cr_aosuc and
           t.aqpa4caomda = cr_aomda and
           t.aqpa4caopap = cr_aopap and
           t.aqpa4caocta = cr_aocta and
           t.aqpa4caooper = cr_aooper and
           t.aqpa4caosbop = cr_aosbop and
           t.aqpa4caotope = cr_aotope  
      ;    
    
    cursor jaqz520_002c (cr_fecha date, 
                      cr_corr number,
                      cr_pgcod number,
                      cr_aomod number, 
                      cr_aosuc number, 
                      cr_aomda number, 
                      cr_aopap number, 
                      cr_aocta number, 
                      cr_aooper number, 
                      cr_aosbop number, 
                      cr_aotope number) is    
      select 
           *
      from 
           JAQZ520_002C t
      where
           t.fecha = cr_fecha and 
           t.corre = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope 
      ;    
     
    cursor jaqz520_012c (cr_fecha date, 
                      cr_corr number,
                      cr_pgcod number,
                      cr_aomod number, 
                      cr_aosuc number, 
                      cr_aomda number, 
                      cr_aopap number, 
                      cr_aocta number, 
                      cr_aooper number, 
                      cr_aosbop number, 
                      cr_aotope number) is    
      select 
           *
      from 
           JAQZ520_012C t
      where
           t.fec = cr_fecha and 
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.aomod = cr_aomod and
           t.aosuc = cr_aosuc and
           t.aomda = cr_aomda and
           t.aopap = cr_aopap and
           t.aocta = cr_aocta and
           t.aooper = cr_aooper and
           t.aosbop = cr_aosbop and
           t.aotope = cr_aotope 
      ;   
      
    cursor jaqz520_x054023 (cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
           *
      from 
           X054023 t
      where
           t.xllpgcod = cr_pgcod and
           t.xllaomod = cr_aomod and
           t.xllaosuc = cr_aosuc and
           t.xllaomda = cr_aomda and
           t.xllaopap = cr_aopap and
           t.xllaocta = cr_aocta and
           t.xllaooper = cr_aooper and
           t.xllaosbop = cr_aosbop and
           t.xllaotop = cr_aotope
      ; 
       
begin
  
     pn_salida := 0;
     begin
       
      
        select 
            'S' into lc_flag
        from 
            jaqz520_010c q 
        where
            q.fec = pn_fecha and 
            q.cor = pn_corr and
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
     
     if  lc_flag = 'S' then
       begin
           
           /************************/  
           begin
              select 
                  nvl(max(x.aqpb064orden),0) +1 into lx_orden 
              from aqpb064 x
              where
                  x.aqpb064pgcod = pn_pgcod and
                  x.aqpb064aomod = pn_aomod and
                  --x.aqpb064aosuc = pn_aosuc and
                  x.aqpb064aomda = pn_aomda and
                  x.aqpb064aopap = pn_aopap and
                  x.aqpb064aocta = pn_aocta and
                  x.aqpb064aooper = pn_aooper --and
                  --x.aqpb064aosbop = pn_aosbop and
                  --x.aqpb064aotope = pn_aotope
                  ;
           exception
                when others then
                  lx_orden := 1;  
           end;              
           /****************************/              
                
           lx_proceso := 'C'; ---CAPITALIZACION
           lx_fcierre := pn_fecha; --lc_fecha_prv;
           lx_estado := 'C'; 
           /****************************/

            insert into AQPB064
            (
                aqpb064frepro,
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
                
                aqpb064proceso,
                aqpb064fcierre,
                aqpb064estado,
                aqpb064scsdo,
                aqpb064tablaref,
                aqpb064orden
           )
                values 
           (
                pn_fecha,
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
                0,--lx_scsdo,
                'DIARIO698',
                lx_orden
           );
                
            commit;
           
           -- registrar solo si es la primera reprogramación
           if lx_orden = 1 then
             
              pn_salida := 1;
              
              ---Insertar aqpb009
              insert into aqpb009
              (
                      aqpb009fep,
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
                      aqpb009tref
               ) 
               values
               (
                  pn_fecha,
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
                  pn_estado,
                  0, --lx_scsdo,
                  'DIARIO698'
               );
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
                             511,
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
                             'D',
                             lc_coderr,
                             lc_msgerr);
                          commit;
                        
                      end;
                    end loop;
                    commit;
                  
                  else
                  
                    pq_cr_historico_pagos_dia.sp_insertar_FSD601_b(pn_pgcod,
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
                          (pn_fecha,
                           512,
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
                           'D',
                           lc_coderr,
                           lc_msgerr);
                        commit;
                      
                    end;
                  end loop;
                  commit;
                
                else
                
                  pq_cr_historico_pagos_dia.sp_insertar_FSD602_b(pn_pgcod,
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
                          (pn_fecha,
                           513,
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
                           'D',
                           lc_coderr,
                           lc_msgerr);
                        commit;
                      
                    end;
                  end loop;
                  commit;
                
                else
                
                  pq_cr_historico_pagos_dia.sp_insertar_FSD611_b(pn_pgcod,
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
                  
                    for q in jaqz520_001c(pn_fecha,
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
                            (pn_fecha,
                             514,
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
                             'D',
                             lc_coderr,
                             lc_msgerr);
                          commit;
                        
                      end;
                    end loop;
                    commit;
                  
                  else
                  
                    pq_cr_historico_pagos_dia.sp_insertar_FPP001_b(pn_pgcod,
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
                 select count(*)
                   into lx_cont
                   from JAQZ520_002C t
                  where t.fecha = pn_fecha
                    and t.corre = pn_corr
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
                 
                   for r in jaqz520_002c(pn_fecha,
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
                          r.ppsbop,
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
                            515,
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
                            'D',
                            lc_coderr,
                            lc_msgerr);
                         commit;
                       
                     end;
                   end loop;
                   commit;
                 
                 else
                   pq_cr_historico_pagos_dia.sp_insertar_FPP002_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
                 
                 end if;
                       
             
                             
                   /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/          
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
                         (
                          aqpb060pgcod,
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
                          aqpb060aoobop 
                        )
                        values
                        (
                          s.xllpgcod,
                          s.xllaomod,
                          s.xllaosuc,
                          s.xllaomda,
                          s.xllaopap,
                          s.xllaocta,
                          s.xllaooper,
                          s.xllaosbop,
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
                          s.xllaosbop
                        );
                     exception
                        when others then
                             --lc_flag := 'N';
                             
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                  
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
                               516,
                               pn_pgcod,
                               pn_aomod,
                               pn_aosuc,
                               pn_aomda,
                               pn_aopap,
                               pn_aocta,
                               pn_aooper,
                               pn_aosbop,
                               pn_aotope,
                               'XN054023',
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                 
                             
                     end;
                  end loop;
                  commit; 
                              
                   /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/ 
                 select count(*)
                   into lx_cont
                   from JAQZ520_012C t
                  where t.fec = pn_fecha
                    and t.cor = pn_corr
                    and t.pgcod = pn_pgcod
                    and t.aomod = pn_aomod
                    and t.aosuc = pn_aosuc
                    and t.aomda = pn_aomda
                    and t.aopap = pn_aopap
                    and t.aocta = pn_aocta
                    and t.aooper = pn_aooper
                    and t.aosbop = pn_aosbop
                    and t.aotope = pn_aotope;
                 
                 if lx_cont > 0 then
                   for u in jaqz520_012c(pn_fecha,
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
                          u.aosbop,
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
                           (pn_fecha,
                            517,
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
                            'D',
                            lc_coderr,
                            lc_msgerr);
                         commit;
                       
                     end;
                   end loop;
                   commit;
                 else
                   pq_cr_historico_pagos_dia.sp_insertar_FSD012_b(pn_pgcod,
                                                                  pn_aomod,
                                                                  pn_aosuc,
                                                                  pn_aomda,
                                                                  pn_aopap,
                                                                  pn_aocta,
                                                                  pn_aooper,
                                                                  pn_aosbop,
                                                                  pn_aotope);
                 
                 end if;
                
                end;
              else
              
                begin
                  
                  /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/                
                  pq_cr_historico_pagos_dia.sp_insertar_FSD601(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope); 
                  
                  /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_FSD602(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);         
                  
                  /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_FSD611(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);       
                
                  /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_FPP001(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);       
                
                  /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_FPP002(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);       
                
                  /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_X054023(pn_pgcod,
                                                               pn_aomod,
                                                               pn_aosuc,
                                                               pn_aomda,
                                                               pn_aopap,
                                                               pn_aocta,
                                                               pn_aooper,
                                                               pn_aosbop,
                                                               pn_aotope);         
                  
                  /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
                  pq_cr_historico_pagos_dia.sp_insertar_FSD012(pn_pgcod,
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
           

                        
         exception when others then
               null;    
         end;
     end if;
         
end sp_insertar_JAQZ698;  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
    
PROCEDURE sp_insertar_AQPB002(pn_fecha in date, 
                              pn_corr in number,
                                     
                              pn_pgcod in number,
                              pn_aomod in number, 
                              pn_aosuc in number, 
                              pn_aomda in number, 
                              pn_aopap in number, 
                              pn_aocta in number, 
                              pn_aooper in number, 
                              pn_aosbop in number, 
                              pn_aotope in number,
                              
                              pn_estado in char,
                              pn_salida out number
                              ) 
  is
    --lc_flag char(1) ;
    lc_desp number;
    lc_fecha_desp date;
    lc_corr_desp number;
    lc_inst_desp number;
    
    pn_inst number; 
    pn_feca date; 
    pn_revr char(1);
    pn_fecha_prev date;

  begin
    
      ---2. Verificar si la clave tiene un registro en el futuro cercano
      begin
        
          select 
                count(*) into lc_desp
          from 
                 aqpb002 t
          where
            t.aqpb002emp = pn_pgcod and
            t.aqpb002mod = pn_aomod and 
            t.aqpb002suc = pn_aosuc and
            t.aqpb002mda = pn_aomda and
            t.aqpb002pap = pn_aopap and
            t.aqpb002cta = pn_aocta and
            t.aqpb002ope = pn_aooper and
            t.aqpb002sbo = pn_aosbop and
            t.aqpb002top = pn_aotope and
            t.aqpb002est = 'C' and
            t.aqpb002fep > pn_fecha;
            
      exception
          when others then
               lc_desp := 0;                                      
      end;  
           
    /**-----------------------*/
    
     select 
            t.aqpb002ins,t.aqpb002feca,t.aqpb002revr, t.aqpb002fep
            into pn_inst, pn_feca, pn_revr, pn_fecha_prev
      from 
             aqpb002 t
      where
        t.aqpb002fep = pn_fecha and
        t.aqpb002cor = pn_corr and
        t.aqpb002emp = pn_pgcod and
        t.aqpb002mod = pn_aomod and 
        t.aqpb002suc = pn_aosuc and
        t.aqpb002mda = pn_aomda and
        t.aqpb002pap = pn_aopap and
        t.aqpb002cta = pn_aocta and
        t.aqpb002ope = pn_aooper and
        t.aqpb002sbo = pn_aosbop and
        t.aqpb002top = pn_aotope and
        t.aqpb002est = 'C';
    
    
         
    if (lc_desp = 0) then
      
       /************ GRUPO 1 ****************/  
       begin
           --dbms_output.put_line(to_char(pn_fecha) || ' ' || to_char(pn_corr) ||  '***** PRIMER CAMINO *****');           
           --1. Inserci+on desde JAQZ520_XXX
           pq_cr_historico_pagos_dia.sp_insertar_JAQZ520_010(pn_fecha, 
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
                                                               pn_revr,
                                                               pn_estado,
                                                               pn_salida);                           
      
       end;

    else
      /************ GRUPO 2 ****************/     
      begin
           --dbms_output.put_line(to_char(pn_fecha) || ' ' || to_char(pn_corr) ||  '***** SEGUNDO CAMINO *****');                   

           
           --2. Inserci+on desde AQPAXXX   
           select 
                  f.aqpb002fep,
                  f.aqpb002cor,
                  f.aqpb002ins
            into
                  lc_fecha_desp,
                  lc_corr_desp,
                  lc_inst_desp
            from (
                  select 
                       t.aqpb002fep,
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
                  from 
                         aqpb002 t
                  where
                    t.aqpb002emp = pn_pgcod and
                    t.aqpb002mod = pn_aomod and 
                    t.aqpb002suc = pn_aosuc and
                    t.aqpb002mda = pn_aomda and
                    t.aqpb002pap = pn_aopap and
                    t.aqpb002cta = pn_aocta and
                    t.aqpb002ope = pn_aooper and
                    t.aqpb002sbo = pn_aosbop and
                    t.aqpb002top = pn_aotope and
                    t.aqpb002est = 'C' and
                    t.aqpb002fep > pn_fecha 
                order by t.aqpb002fep asc) f
                where
                rownum=1 ;
                                                            
           pq_cr_historico_pagos_dia.sp_insertar_AQPA004(lc_fecha_desp, 
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
                                                           pn_aotope,
                                                           pn_estado,
                                                           pn_salida);                                                                    

      
      end;
    end if;

 
  end sp_insertar_AQPB002;  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

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
                                    pn_revr in char,
                                    pn_estado in char,
                                    pn_salida out number
                                   ) is
                                   
    
    
    lx_frepro date;
    lx_ncorre number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado varchar2(100);
    lx_fecest date;
    
    lx_scsdo number(17,2);
    
    lx_orden number;  
    lx_flac char;  
                                       
  begin
    
  begin
          pn_salida := 0;
    

          /****************************/
           begin
              select 
                  nvl(max(x.aqpb064orden),0) +1 into lx_orden 
              from aqpb064 x
              where
                  x.aqpb064pgcod = pn_pgcod and
                  x.aqpb064aomod = pn_aomod and
                  --x.aqpb064aosuc = pn_aosuc and
                  x.aqpb064aomda = pn_aomda and
                  x.aqpb064aopap = pn_aopap and
                  x.aqpb064aocta = pn_aocta and
                  x.aqpb064aooper = pn_aooper --and
                  --x.aqpb064aosbop = pn_aosbop and
                  --x.aqpb064aotope = pn_aotope
                  ;
           exception
                when others then
                  lx_orden := 1;  
           end;   

          /****************************/                
                
          lx_frepro := pn_fecha;
          lx_ncorre := pn_corr;
          lx_proceso := 'R'; ---REPROGRAMADO
          lx_fcierre := pn_fecha_prev; 
          lx_instanc := pn_inst;
          
          if (pn_revr='S') then
               --lx_estado := 'X';
               lx_fecest := pn_feca;
          else
               --lx_estado := 'R';
               lx_fecest := pn_fecha;
          end if;
          
          lx_estado := 'C'; 
                
         /*-------------------------*/                
            insert into AQPB064
            (
                aqpb064frepro,
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
                aqpb064fecest,
                --aqpb064diaatr,
                --aqpb064diagra,
                --aqpb064fepvep,
                aqpb064scsdo,
                --aqpb064freproref,
                --aqpb064ncorreref,
                aqpb064tablaref,
                aqpb064orden
           ) 
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
                --lx_instanc,
                lx_estado,
                lx_fecest,
                0,--lx_scsdo,
                'DIARIO002',
                lx_orden
           );
           commit;
         
         if lx_orden = 1 then
                     
                 pn_salida := 1;
                     
                 ---Insertar aqpb009
                 insert into aqpb009
                 (
                        aqpb009fep,
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
                        aqpb009tref
                 )
                 values 
                 (
                        pn_fecha,
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
                        pn_estado, 
                        0,
                        'DIARIO002'
                 );
                 commit;
                 
    
                /*-------------------------*/
                 ---Detalle GRUPO1
                 /*-------------------------*/
                 pq_cr_historico_pagos_dia.sp_insertar_detalle_grupo1(
                   pn_fecha, --lx_frepro,
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
                                pn_aotope in number,
                                pn_estado in char,
                                
                                pn_salida out number
                                ) is
                                
    
    lx_frepro date;
    lx_ncorre number;
    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_instanc number;
    lx_estado varchar2(100);
    lx_fecest date;

    lx_scsdo number(17,2);
    lx_orden number;
    lx_flac char(1);
                                    
  begin
    
  
  begin
  ---1. Inicio
  
         pn_salida := 0;
              
          /****************************/ 
             begin
                select 
                    nvl(max(x.aqpb064orden),0) +1 into lx_orden 
                from aqpb064 x
                where
                    x.aqpb064pgcod = pn_pgcod and
                    x.aqpb064aomod = pn_aomod and
                    --x.aqpb064aosuc = pn_aosuc and
                    x.aqpb064aomda = pn_aomda and
                    x.aqpb064aopap = pn_aopap and
                    x.aqpb064aocta = pn_aocta and
                    x.aqpb064aooper = pn_aooper --and
                    ---x.aqpb064aosbop = pn_aosbop and
                    --x.aqpb064aotope = pn_aotope
                    ;
             exception
                  when others then
                    lx_orden := 1;  
             end;   

          /****************************/                         
                
          lx_frepro := pn_fecha_inst;
          lx_ncorre := pn_corr_inst;
          lx_proceso := 'R'; ---REPROGRAMADO
          lx_fcierre := pn_fecha_prev; 
          lx_instanc := pn_inst;
          
          if (pn_revr='S') then
               --lx_estado := 'X';
               lx_fecest := pn_feca;
          else
               --lx_estado := 'R';
               lx_fecest := pn_fecha;
          end if;
          
          lx_estado := 'C';
 
                
         /*-------------------------*/
         insert into AQPB064
            (
                aqpb064frepro,
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
                aqpb064proceso,
                aqpb064fcierre,
                aqpb064estado,
                aqpb064fecest,
                aqpb064scsdo,
                aqpb064tablaref,
                aqpb064orden
           )
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
                lx_estado,
                lx_fecest,
                0, --lx_scsdo,
                'AQPB002',
                lx_orden
           );
           commit;
         
         if lx_orden = 1 then
             
            pn_salida := 1;   
         
             ---Insertar aqpb009
             insert into aqpb009
             (
                    aqpb009fep,
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
                    aqpb009tref
             )
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
                    pn_estado, 
                    0,--lx_scsdo,
                    'AQPB002'
                    
             );
             commit;
      
             ---Detalle
             /*-------------------------*/
             pq_cr_historico_pagos_dia.sp_insertar_detalle_grupo2(
               pn_fecha, --lx_frepro,
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
           pn_aotope in number) is
             
  lc_flag char(1);       
  lc_coderr char(100);
  lc_msgerr char(100);   
  lx_cont number;        
                                          
  --- grupo 1
  cursor grupo1_jaqz520_601 (cr_PGCOD number,
                             cr_PPMOD number,
                             cr_PPSUC number,
                             cr_PPMDA number,
                             cr_PPPAP number,
                             cr_PPCTA number,
                             cr_PPOPER number,
                             cr_PPSBOP number,
                             cr_PPTOPE number) is
             
  select 
       *
  from 
       jaqz520_601 t
  where
       t.PGCOD = cr_PGCOD and 
       t.PPMOD = cr_PPMOD and 
       t.PPSUC = cr_PPSUC and 
       t.PPMDA = cr_PPMDA and  
       t.PPPAP = cr_PPPAP and 
       t.PPCTA = cr_PPCTA and  
       t.PPOPER = cr_PPOPER and 
       t.PPSBOP = cr_PPSBOP and  
       t.PPTOPE = cr_PPTOPE     
  order by
        t.ppfpag asc
  ;
    
  cursor grupo1_jaqz520_602 (cr_pgcod number,
                             cr_aomod number, 
                             cr_aosuc number, 
                             cr_aomda number, 
                             cr_aopap number, 
                             cr_aocta number, 
                             cr_aooper number, 
                             cr_aosbop number, 
                             cr_aotope number) is    
    select 
         *
    from 
         jaqz520_602 t
    where
         t.pgcod = cr_pgcod and
         t.ppmod = cr_aomod and
         t.ppsuc = cr_aosuc and
         t.ppmda = cr_aomda and
         t.pppap = cr_aopap and
         t.ppcta = cr_aocta and
         t.ppoper = cr_aooper and
         t.ppsbop = cr_aosbop and
         t.pptope = cr_aotope  
    order by
          t.ppfpag asc
    ;      
    
  cursor grupo1_jaqz520_611 (cr_pgcod number,
                             cr_aomod number, 
                             cr_aosuc number, 
                             cr_aomda number, 
                             cr_aopap number, 
                             cr_aocta number, 
                             cr_aooper number, 
                             cr_aosbop number, 
                             cr_aotope number) is    
    select 
         *
    from 
         jaqz520_611 t
    where
         t.pgcod = cr_pgcod and
         t.ppmod = cr_aomod and
         t.ppsuc = cr_aosuc and
         t.ppmda = cr_aomda and
         t.pppap = cr_aopap and
         t.ppcta = cr_aocta and
         t.ppoper = cr_aooper and
         t.ppsbop = cr_aosbop and
         t.pptope = cr_aotope  
    order by
          t.ppfpag asc
    ;    
    
  cursor grupo1_jaqz520_fpp001 (cr_fecha date, 
                                cr_corr number,
                                cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
    select 
         *
    from 
         aqpa004c t
    where
         t.aqpa4cfpro = cr_fecha and
         t.aqpa4ccor = cr_corr and
         t.aqpa4cpgcod = cr_pgcod and
         t.aqpa4caomod = cr_aomod and
         t.aqpa4caosuc = cr_aosuc and
         t.aqpa4caomda = cr_aomda and
         t.aqpa4caopap = cr_aopap and
         t.aqpa4caocta = cr_aocta and
         t.aqpa4caooper = cr_aooper and
         t.aqpa4caosbop = cr_aosbop and
         t.aqpa4caotope = cr_aotope  
    ;    

  cursor grupo1_jaqz520_fpp002 (cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
    select 
         *
    from 
         JAQZ520_002 t
    where
         t.pgcod = cr_pgcod and
         t.ppmod = cr_aomod and
         t.ppsuc = cr_aosuc and
         t.ppmda = cr_aomda and
         t.pppap = cr_aopap and
         t.ppcta = cr_aocta and
         t.ppoper = cr_aooper and
         t.ppsbop = cr_aosbop and
         t.pptope = cr_aotope         
    ;    
   
  cursor grupo1_jaqz520_fsd012 (cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
    select 
         *
    from 
         JAQZ520_012 t
    where
         t.pgcod = cr_pgcod and
         t.aomod = cr_aomod and
         t.aosuc = cr_aosuc and
         t.aomda = cr_aomda and
         t.aopap = cr_aopap and
         t.aocta = cr_aocta and
         t.aooper = cr_aooper and
         t.aosbop = cr_aosbop and
         t.aotope = cr_aotope  
         
    ;     
       
  cursor grupo1_jaqz520_x054023 (cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
    select 
         *
    from 
         x054023 t
    where
         t.xllpgcod = cr_pgcod and
         t.xllaomod = cr_aomod and
         t.xllaosuc = cr_aosuc and
         t.xllaomda = cr_aomda and
         t.xllaopap = cr_aopap and
         t.xllaocta = cr_aocta and
         t.xllaooper = cr_aooper and
         t.xllaosbop = cr_aosbop and
         t.xllaotop = cr_aotope  
         
    ;     


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
                    'FSD601',
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FSD601_b(pn_pgcod,
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
                     'D',
                     lc_coderr,
                     lc_msgerr);
                  commit;
                
              end;
            end loop;
            commit;
          
          else
          
            pq_cr_historico_pagos_dia.sp_insertar_FSD602_b(pn_pgcod,
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
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FSD611_b(pn_pgcod,
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
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FPP001_b(pn_pgcod,
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
         select count(*)
           into lx_cont
           from JAQZ520_002 t
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
         
           for r in grupo1_jaqz520_fpp002(pn_pgcod,
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
                  r.ppsbop,
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
                    'FPP002',
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FPP002_b(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
           
             end if;               
         /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/            
         for s in grupo1_jaqz520_x054023(pn_pgcod,
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
               (
                aqpb060pgcod,
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
                aqpb060aoobop 
              )
              values
              (
                s.xllpgcod,
                s.xllaomod,
                s.xllaosuc,
                s.xllaomda,
                s.xllaopap,
                s.xllaocta,
                s.xllaooper,
                s.xllaosbop,
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
                s.xllaosbop
              );
           exception
              when others then
                  -- lc_flag := 'N';
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm),1,90);
                                  
                      insert into aqpb066
                      (  
                          aqpb066fep,
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
                          aqpb066eamsge
                       )
                      values
                      (  
                         pn_fecha,
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
                         'X054023',
                         'D',
                         lc_coderr,
                         lc_msgerr);
                      commit;                   
                  
           end;
        end loop;
        commit; 
                        
         /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/ 
         select count(*)
           into lx_cont
           from JAQZ520_012 t
          where t.pgcod = pn_pgcod
            and t.aomod = pn_aomod
            and t.aosuc = pn_aosuc
            and t.aomda = pn_aomda
            and t.aopap = pn_aopap
            and t.aocta = pn_aocta
            and t.aooper = pn_aooper
            and t.aosbop = pn_aosbop
            and t.aotope = pn_aotope;
         
         if lx_cont > 0 then
         
           for u in grupo1_jaqz520_fsd012(pn_pgcod,
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
                  u.aosbop,
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
                    'FSD012',
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FSD012_b(pn_pgcod,
                                                          pn_aomod,
                                                          pn_aosuc,
                                                          pn_aomda,
                                                          pn_aopap,
                                                          pn_aocta,
                                                          pn_aooper,
                                                          pn_aosbop,
                                                          pn_aotope);
         
         end if;

      end;
   else
     
      begin
                  
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD601(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope); 
                  
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD602(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);         
                  
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD611(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FPP001(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FPP002(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_X054023(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);         
                  
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD012(pn_pgcod,
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
                                pn_aotope in number) is
 
/*---------------*/
lc_flag char(1);
lc_coderr char(100);
lc_msgerr char(100);
lx_cont number;

  --- grupo 2
cursor grupo2_jaqz520_601 (cr_fecha date, 
                           cr_corr number,
                           cr_PGCOD number,
                           cr_PPMOD number,
                           cr_PPSUC number,
                           cr_PPMDA number,
                           cr_PPPAP number,
                           cr_PPCTA number,
                           cr_PPOPER number,
                           cr_PPSBOP number,
                           cr_PPTOPE number) is
           
select 
     *
from 
     aqpa006 t
where
     t.aqpa006fecpro = cr_fecha and
     t.aqpa006cor = cr_corr and
     t.aqpa006cod = cr_PGCOD and
     t.aqpa006mod = cr_PPMOD and
     t.aqpa006suc = cr_PPSUC and
     t.aqpa006mda = cr_PPMDA and 
     t.aqpa006pap = cr_PPPAP and
     t.aqpa006cta = cr_PPCTA and
     t.aqpa006oper = cr_PPOPER and
     t.aqpa006sbop = cr_PPSBOP and
     t.aqpa006tope = cr_PPTOPE      
order by
      t.aqpa006fpag asc
;
         
cursor grupo2_jaqz520_602 (cr_fecha date, 
                           cr_corr number,
                           cr_pgcod number,
                           cr_aomod number, 
                           cr_aosuc number, 
                           cr_aomda number, 
                           cr_aopap number, 
                           cr_aocta number, 
                           cr_aooper number, 
                           cr_aosbop number, 
                           cr_aotope number) is    
  select 
       *
  from 
       aqpa008 t
  where
       t.aqpa008fecpro = cr_fecha and
       t.aqpa008cor = cr_corr and
       t.aqpa008cod = cr_pgcod and
       t.aqpa008mod = cr_aomod and
       t.aqpa008suc = cr_aosuc and
       t.aqpa008mda = cr_aomda and
       t.aqpa008pap = cr_aopap and
       t.aqpa008cta = cr_aocta and
       t.aqpa008oper = cr_aooper and
       t.aqpa008sbop = cr_aosbop and
       t.aqpa008tope = cr_aotope 
  order by 
        t.aqpa008fpag asc
 ;      
    
cursor grupo2_jaqz520_611 (cr_fecha date, 
                           cr_corr number,
                           cr_pgcod number,
                           cr_aomod number, 
                           cr_aosuc number, 
                           cr_aomda number, 
                           cr_aopap number, 
                           cr_aocta number, 
                           cr_aooper number, 
                           cr_aosbop number, 
                           cr_aotope number) is    
  select 
       *
  from 
       aqpa007 t
  where
       t.aqpa007fecpro = cr_fecha and
       t.aqpa007cor = cr_corr and
       t.aqpa007cod = cr_pgcod and
       t.aqpa007mod = cr_aomod and
       t.aqpa007suc = cr_aosuc and
       t.aqpa007mda = cr_aomda and
       t.aqpa007pap = cr_aopap and
       t.aqpa007cta = cr_aocta and
       t.aqpa007oper = cr_aooper and
       t.aqpa007sbop = cr_aosbop and
       t.aqpa007tope = cr_aotope 
  order by 
        t.aqpa007fpag asc
  ;    
    
cursor grupo2_jaqz520_fpp001 (cr_fecha date, 
                              cr_corr number,
                              cr_pgcod number,
                              cr_aomod number, 
                              cr_aosuc number, 
                              cr_aomda number, 
                              cr_aopap number, 
                              cr_aocta number, 
                              cr_aooper number, 
                              cr_aosbop number, 
                              cr_aotope number) is    
  select 
       *
  from 
       aqpa004c t
  where
       t.aqpa4cfpro = cr_fecha and
       t.aqpa4ccor = cr_corr and
       t.aqpa4cpgcod = cr_pgcod and
       t.aqpa4caomod = cr_aomod and
       t.aqpa4caosuc = cr_aosuc and
       t.aqpa4caomda = cr_aomda and
       t.aqpa4caopap = cr_aopap and
       t.aqpa4caocta = cr_aocta and
       t.aqpa4caooper = cr_aooper and
       t.aqpa4caosbop = cr_aosbop and
       t.aqpa4caotope = cr_aotope  
  ;    
   
cursor grupo2_jaqz520_fpp002 (cr_fecha date, 
                              cr_corr number,
                              cr_pgcod number,
                              cr_aomod number, 
                              cr_aosuc number, 
                              cr_aomda number, 
                              cr_aopap number, 
                              cr_aocta number, 
                              cr_aooper number, 
                              cr_aosbop number, 
                              cr_aotope number) is    
  select 
       *
  from 
       aqpa004e t
  where
       t.fecha = cr_fecha and
       t.corre = cr_corr and
       t.pgcod = cr_pgcod and
       t.ppmod = cr_aomod and
       t.ppsuc = cr_aosuc and
       t.ppmda = cr_aomda and
       t.pppap = cr_aopap and
       t.ppcta = cr_aocta and
       t.ppoper = cr_aooper and
       t.ppsbop = cr_aosbop and
       t.pptope = cr_aotope         
  ;    
   
cursor grupo2_jaqz520_fsd012 (cr_fecha date, 
                              cr_corr number,
                              cr_pgcod number,
                              cr_aomod number, 
                              cr_aosuc number, 
                              cr_aomda number, 
                              cr_aopap number, 
                              cr_aocta number, 
                              cr_aooper number, 
                              cr_aosbop number, 
                              cr_aotope number) is    
  select 
       *
  from 
       aqpa004f t
  where
       t.fecha = cr_fecha and
       t.corre = cr_corr and
       t.pgcod = cr_pgcod and
       t.aomod = cr_aomod and
       t.aosuc = cr_aosuc and
       t.aomda = cr_aomda and
       t.aopap = cr_aopap and
       t.aocta = cr_aocta and
       t.aooper = cr_aooper and
       t.aosbop = cr_aosbop and
       t.aotope = cr_aotope  
       
  ;     
     
cursor grupo2_jaqz520_x054023 (cr_pgcod number,
                              cr_aomod number, 
                              cr_aosuc number, 
                              cr_aomda number, 
                              cr_aopap number, 
                              cr_aocta number, 
                              cr_aooper number, 
                              cr_aosbop number, 
                              cr_aotope number) is    
  select 
       *
  from 
       x054023 t
  where
       t.xllpgcod = cr_pgcod and
       t.xllaomod = cr_aomod and
       t.xllaosuc = cr_aosuc and
       t.xllaomda = cr_aomda and
       t.xllaopap = cr_aopap and
       t.xllaocta = cr_aocta and
       t.xllaooper = cr_aooper and
       t.xllaosbop = cr_aosbop and
       t.xllaotop = cr_aotope  
       
  ;     

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
                    'D',
                    lc_coderr,
                    lc_msgerr);
                 commit;
               
             end;
           end loop;
           commit;
         
         else
         
           pq_cr_historico_pagos_dia.sp_insertar_FSD601_b(pn_pgcod,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_dia.sp_insertar_FSD602_b(pn_pgcod,
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
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_dia.sp_insertar_FSD611_b(pn_pgcod,
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
                   'FPP001',
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_dia.sp_insertar_FPP001_b(pn_pgcod,
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
        select count(*)
          into lx_cont
          from aqpa004e t
         where t.fecha = pn_fecpro
           and t.corre = pn_corr
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
        
          for r in grupo2_jaqz520_fpp002(pn_fecpro,
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
                 r.ppsbop,
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
                   'FPP002',
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;
              
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_dia.sp_insertar_FPP002_b(pn_pgcod,
                                                         pn_aomod,
                                                         pn_aosuc,
                                                         pn_aomda,
                                                         pn_aopap,
                                                         pn_aocta,
                                                         pn_aooper,
                                                         pn_aosbop,
                                                         pn_aotope);
        
        end if;
                       
         /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/            
         for s in grupo2_jaqz520_x054023(pn_pgcod,
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
               (
                aqpb060pgcod,
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
                aqpb060aoobop 
              )
              values
              (
                s.xllpgcod,
                s.xllaomod,
                s.xllaosuc,
                s.xllaomda,
                s.xllaopap,
                s.xllaocta,
                s.xllaooper,
                s.xllaosbop,
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
                s.xllaosbop
              );
           exception
              when others then
                   --lc_flag := 'N';
                      lc_coderr := sqlcode;
                      lc_msgerr := substr(trim(sqlerrm),1,90);
                                  
                      insert into aqpb066
                      (  
                          aqpb066fep,
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
                          aqpb066eamsge
                       )
                      values
                      (  
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
                         pn_aotope,
                         'X054023',
                         'D',
                         lc_coderr,
                         lc_msgerr);
                      commit;                    
           end;
        end loop;
        commit; 
                        
         /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        select count(*)
          into lx_cont
          from aqpa004f t
         where t.fecha = pn_fecpro
           and t.corre = pn_corr
           and t.pgcod = pn_pgcod
           and t.aomod = pn_aomod
           and t.aosuc = pn_aosuc
           and t.aomda = pn_aomda
           and t.aopap = pn_aopap
           and t.aocta = pn_aocta
           and t.aooper = pn_aooper
           and t.aosbop = pn_aosbop
           and t.aotope = pn_aotope;
        
        if lx_cont > 0 then
        
          for u in grupo2_jaqz520_fsd012(pn_fecpro,
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
                 u.aosbop,
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
                   'FSD012',
                   'D',
                   lc_coderr,
                   lc_msgerr);
                commit;
            end;
          end loop;
          commit;
        
        else
        
          pq_cr_historico_pagos_dia.sp_insertar_FSD012_b(pn_pgcod,
                                                         pn_aomod,
                                                         pn_aosuc,
                                                         pn_aomda,
                                                         pn_aopap,
                                                         pn_aocta,
                                                         pn_aooper,
                                                         pn_aosbop,
                                                         pn_aotope);
        
        end if;
      
      end;
    else

      begin
                  
        /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD601(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope); 
                  
        /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD602(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);         
                  
        /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD611(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FPP001(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FPP002(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);       
                
        /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_X054023(pn_pgcod,
                                                     pn_aomod,
                                                     pn_aosuc,
                                                     pn_aomda,
                                                     pn_aopap,
                                                     pn_aocta,
                                                     pn_aooper,
                                                     pn_aosbop,
                                                     pn_aotope);         
                  
        /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
        pq_cr_historico_pagos_dia.sp_insertar_FSD012(pn_pgcod,
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

PROCEDURE sp_insertar_repro_agencia(pn_fecha in date, 
                             pn_corr in number,
                             pn_pgcod in number,
                             pn_aomod in number, 
                             pn_aosuc in number, 
                             pn_aomda in number, 
                             pn_aopap in number, 
                             pn_aocta in number, 
                             pn_aooper in number, 
                             pn_aosbop in number, 
                             pn_aotope in number,
                             pn_estado in char,
                             pn_salida out number)
is
    lc_flag char(1) ;
     

    lx_proceso varchar2(100);
    lx_fcierre date;
    lx_estado varchar2(100);
    lx_scsdo number(17,2);
    lx_orden number;   
    lc_coderr char(100);
    lc_msgerr char(100);    
    
    -- Detalle
    cursor jaqz520_601 ( cr_fecha date,
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           aqpb012_601 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;
      
    cursor jaqz520_602 ( cr_fecha date,
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           aqpb012_602 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;      
    
    cursor jaqz520_611 (cr_fecha date,
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           aqpb012_611 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope  
      order by
            t.ppfpag asc
      ;    
    
    cursor jaqz520_001 (cr_fecha date,
                         cr_corr number,
                         cr_pgcod number,
                         cr_aomod number, 
                         cr_aosuc number, 
                         cr_aomda number, 
                         cr_aopap number, 
                         cr_aocta number, 
                         cr_aooper number, 
                         cr_aosbop number, 
                         cr_aotope number) is    
      select 
           *
      from 
           aqpb012_001 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.aomod = cr_aomod and
           t.aosuc = cr_aosuc and
           t.aomda = cr_aomda and
           t.aopap = cr_aopap and
           t.aocta = cr_aocta and
           t.aooper = cr_aooper and
           t.aosbop = cr_aosbop and
           t.aotope = cr_aotope 
      ;    
    
    cursor jaqz520_002 (cr_fecha date,
                        cr_corr number,
                        cr_pgcod number,
                        cr_aomod number, 
                        cr_aosuc number, 
                        cr_aomda number, 
                        cr_aopap number, 
                        cr_aocta number, 
                        cr_aooper number, 
                        cr_aosbop number, 
                        cr_aotope number) is    
      select 
           *
      from 
           aqpb012_002 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope 
      ;    
     
    cursor jaqz520_012 (cr_fecha date,
                        cr_corr number,
                        cr_pgcod number,
                        cr_aomod number, 
                        cr_aosuc number, 
                        cr_aomda number, 
                        cr_aopap number, 
                        cr_aocta number, 
                        cr_aooper number, 
                        cr_aosbop number, 
                        cr_aotope number) is    
      select 
           *
      from 
           aqpb012_012 t
      where
           t.fec = cr_fecha and
           t.cor = cr_corr and
           t.pgcod = cr_pgcod and
           t.aomod = cr_aomod and
           t.aosuc = cr_aosuc and
           t.aomda = cr_aomda and
           t.aopap = cr_aopap and
           t.aocta = cr_aocta and
           t.aooper = cr_aooper and
           t.aosbop = cr_aosbop and
           t.aotope = cr_aotope 
      ;   
      
    cursor jaqz520_x054023 (cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
           *
      from 
           X054023 t
      where
           t.xllpgcod = cr_pgcod and
           t.xllaomod = cr_aomod and
           t.xllaosuc = cr_aosuc and
           t.xllaomda = cr_aomda and
           t.xllaopap = cr_aopap and
           t.xllaocta = cr_aocta and
           t.xllaooper = cr_aooper and
           t.xllaosbop = cr_aosbop and
           t.xllaotop = cr_aotope
      ; 

begin
     
     pn_salida := 0;

     begin
        select 
            'S' into lc_flag
        from 
            aqpb012 q 
        where
            q.aqpb012fec = pn_fecha and 
            q.aqpb012cor = pn_corr and
            q.aqpb012pgcod = pn_pgcod and
            q.aqpb012mod = pn_aomod and
            q.aqpb012suc = pn_aosuc and
            q.aqpb012mda = pn_aomda and
            q.aqpb012pap = pn_aopap and
            q.aqpb012cta = pn_aocta and
            q.aqpb012oper = pn_aooper and
            q.aqpb012sbop = pn_aosbop and
            q.aqpb012tope = pn_aotope ;

     exception
        when others then
             lc_flag := 'N';
     end; 
     
     if  lc_flag = 'S' then
       begin
       /************************/  

           begin
              select 
                  nvl(max(x.aqpb064orden),0) +1 into lx_orden 
              from 
                  aqpb064 x
              where
                  x.aqpb064pgcod = pn_pgcod and
                  x.aqpb064aomod = pn_aomod and
                  --x.aqpb064aosuc = pn_aosuc and
                  x.aqpb064aomda = pn_aomda and
                  x.aqpb064aopap = pn_aopap and
                  x.aqpb064aocta = pn_aocta and
                  x.aqpb064aooper = pn_aooper --and
                  --x.aqpb064aosbop = pn_aosbop and
                  --x.aqpb064aotope = pn_aotope
                  ;
           exception
                when others then
                  lx_orden := 1;  
           end;   
                            
           /****************************/              
            lx_proceso := 'C'; ---CAPITALIZACION
            lx_fcierre := pn_fecha; --lc_fecha_prv;
            lx_estado := 'C';       
              
            /****************************/
            insert into AQPB064
            (
                aqpb064frepro,
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
                
                aqpb064proceso,
                aqpb064fcierre,
                aqpb064estado,
                aqpb064scsdo,
                aqpb064tablaref,
                aqpb064orden
           )
                values 
           (
                pn_fecha,
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
                0,--lx_scsdo,
                'AGENCIA',
                lx_orden
           );  
            commit;
           
           -- registrar solo si es la primera reprogramación
           if lx_orden = 1 then
             
              pn_salida := 1;
             
              ---Insertar aqpb009
              insert into aqpb009
              (
                      aqpb009fep,
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
                      aqpb009tref
               ) 
               values
               (
                      pn_fecha,
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
                      pn_estado,
                      0, --lx_scsdo,
                      'AGENCIA'
               );
              commit;           
           
               begin
                 
                     /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
                     for k in jaqz520_601( pn_fecha,
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
                             (
                                  aqpb061pgcod,
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
                                  aqpb061obop
                             )
                            values
                            (
                                  k.pgcod,
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
                            );
                         exception
                            when others then
                                 --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                  
                                 
                         end;
                      end loop; 
                      commit;    
                        
                     /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/ 
                      for m in jaqz520_602(pn_fecha,
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
                              (
                                    aqpb062pgcod,
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
                                    aqpb062obop
                              )
                              values
                              (
                                    m.pgcod,
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
                                    m.ppsbop
                              );
                           exception
                              when others then
                                   --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                    
                           end;
                        end loop;
                      commit;
                  
                     /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/           
                     for p in jaqz520_611(pn_fecha,
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
                              (
                                aqpb063pgcod,
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
                                aqpb063obop
                              )
                              values
                              (
                                p.pgcod,
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
                                p.ppsbop
                              );
                           exception
                              when others then
                                   --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                    
                           end;
                        end loop;
                     commit;                    
                            
                     /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/                  
                     for q in jaqz520_001(pn_fecha,
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
                            (
                              aqpa974pgcod,
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
                              aqpa974obop
                            )
                            values
                            (
                                  q.pgcod,
                                  q.aomod,
                                  q.aosuc,
                                  q.aomda,
                                  q.aopap,
                                  q.aocta,
                                  q.aooper,
                                  q.aosbop,
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
                                  q.aosbop
                            );
                         exception
                            when others then
                                 --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                  
                         end;
                      end loop;
                      commit;                  
                       
                     /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/     
                    for r in jaqz520_002(pn_fecha,
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
                          
                          insert into aqpa973 
                          (
                            aqpa973cod,
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
                            aqpa973obop
                          )
                          values
                          (
                              r.pgcod,
                              r.ppmod,
                              r.ppsuc,
                              r.ppmda,
                              r.pppap,
                              r.ppcta,
                              r.ppoper,
                              r.ppsbop,
                              r.pptope,
                              r.ppfpag,
                              r.pptipo,
                              r.prestconc,
                              r.pp002imp,
                              r.pp002stat,
                              r.pp002aux1,
                              r.pp002aux2,
                              r.pp002aux3,
                              r.ppsbop
                          );
                         exception
                            when others then
                                 --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'FPP002',
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                  
                         end;
                      end loop;
                      commit;               
                       
                     /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/            
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
                           (
                            aqpb060pgcod,
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
                            aqpb060aoobop 
                          )
                          values
                          (
                            s.xllpgcod,
                            s.xllaomod,
                            s.xllaosuc,
                            s.xllaomda,
                            s.xllaopap,
                            s.xllaocta,
                            s.xllaooper,
                            s.xllaosbop,
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
                            s.xllaosbop
                          );
                       exception
                          when others then
                               --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'X054023',
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                
                       end;
                    end loop;
                    commit; 
                        
                     /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/ 
                     for u in jaqz520_012(pn_fecha,
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
                                  
                            insert into AQPA975 
                            (
                              aqpa975cod,
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
                              aqpa975obop
                            )                           
                            values
                            (
                                u.pgcod,
                                u.aomod,
                                u.aosuc,
                                u.aomda,
                                u.aopap,
                                u.aocta,
                                u.aooper,
                                u.aosbop,
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
                                u.aosbop
                            );
                         exception
                            when others then
                                 --lc_flag := 'N';
                            lc_coderr := sqlcode;
                            lc_msgerr := substr(trim(sqlerrm),1,90);
                                        
                            insert into aqpb066
                            (  
                                aqpb066fep,
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
                                aqpb066eamsge
                             )
                            values
                            (  
                               pn_fecha,
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
                               'FSD012',
                               'D',
                               lc_coderr,
                               lc_msgerr);
                            commit;                                  
                         end;
                      end loop;
                     commit;  
                       
               end;

          
           --- Final: validación  
           end if;
           
         end;
     end if;
         
end sp_insertar_repro_agencia;  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  PROCEDURE sp_insertar_JAQA255(pn_fecha in date,
                                --pn_corr  in number,
                                pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number,
                                pn_estado in char,
                                pn_salida out number) is
    lc_flag char(1);
    lc_corr number;

    lx_pgcod  number;
    lx_aomod  number;
    lx_aosuc  number;
    lx_aomda  number;
    lx_aopap  number;
    lx_aocta  number;
    lx_aooper number;
    lx_aosbop number;
    lx_aotope number;
    lx_aoobop number;
    
    lx_orden number;
  
  begin
  
    pn_salida := 0;
    
    begin
      select 'S'
        into lc_flag
        from fsd010 q
       where q.pgcod = pn_pgcod
         and q.aomod = pn_aomod
         --and q.aosuc = pn_aosuc
         and q.aomda = pn_aomda
         and q.aopap = pn_aopap
         and q.aocta = pn_aocta
         and q.aooper = pn_aooper
         and q.aosbop = 0 --q.aosbop = pn_aosbop and
         --and q.aotope = pn_aotope
         and q.aomod in (select h.modulo from fst111 h where h.dscod = 50);
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
               q.aooper, ----lx_aooper,
               pn_aosbop, --lx_aosbop,  <--Suboperación actual
               q.aotope, --lx_aotope,
               q.aosbop --lx_aoobop
        
          into lx_pgcod, --
               lx_aomod, --
               lx_aosuc, -- <--Obtener sucursal
               lx_aomda, --
               lx_aopap, --
               lx_aocta, --
               lx_aooper, --
               lx_aosbop, -- <--Suboperación actual
               lx_aotope,
               lx_aoobop -- es 0
          from fsd010 q
         where 
           q.pgcod = pn_pgcod and
           q.aomod = pn_aomod and
           --q.aosuc = pn_aosuc and
           q.aomda = pn_aomda and
           q.aopap = pn_aopap and
           q.aocta = pn_aocta and 
           q.aooper = pn_aooper and 
           q.aosbop = 0 and 
           --q.aotope = pn_aotope and
           q.aomod in (select h.modulo from fst111 h where h.dscod = 50);
           
        
         begin
            select 
                count(*) +1 into lx_orden 
            from aqpb009 x
            where
                x.aqpb009emp = pn_pgcod and
                x.aqpb009mod = pn_aomod and
                --x.aqpb009suc = pn_aosuc and
                x.aqpb009mda = pn_aomda and
                x.aqpb009pap = pn_aopap and
                x.aqpb009cta = pn_aocta and
                x.aqpb009ope = pn_aooper --and
                --x.aqpb009sbo = pn_aosbop and
                --x.aqpb009top = pn_aotope
                ;
         exception
              when others then
                lx_orden := 1;  
         end;
         
          -- Obtención correlativo
          select 
              nvl(max(x.aqpb009cor),0) +1 into lc_corr 
          from aqpb009 x
          where
              x.aqpb009fep = pn_fecha and
              trim(x.aqpb009tref) = 'JAQA255';   
        
          insert into AQPB064
          (
              aqpb064frepro,
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
                
              aqpb064proceso,
              aqpb064fcierre,
              aqpb064estado,
              aqpb064scsdo,
              aqpb064tablaref,
              aqpb064orden
         )
              values 
         (
              pn_fecha,
              lc_corr,
              pn_pgcod,
              pn_aomod,
              pn_aosuc,
              pn_aomda,
              pn_aopap,
              pn_aocta,
              pn_aooper,
              pn_aosbop,
              pn_aotope,
              'C',
              pn_fecha,
              'C',
              0,
              'DIARIO255',
              lx_orden
         );
          commit;
        
          
        if lx_orden = 1 then
          begin
          
              pn_salida := 1;    

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
                 aqpb009tref)
              values
                (pn_fecha,
                 lc_corr,
                 lx_pgcod, --pn_pgcod,
                 lx_aomod, --pn_aomod,
                 lx_aosuc, --pn_aosuc,
                 lx_aomda, --pn_aomda,
                 lx_aopap, --pn_aopap,
                 lx_aocta, --pn_aocta,
                 lx_aooper, --pn_aooper,
                 lx_aosbop, --pn_aosbop,
                 lx_aotope, --pn_aotope,
                 pn_estado, --'C',
                 'DIARIO255');
              commit;
            
              /*********** 1: INSERTAR AQPB061: FSD0601 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FSD601(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope); 
              
              /*********** 2: INSERTAR aqpb062: FSD0602 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FSD602(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);         
              
              /*********** 3: INSERTAR aqpb063: FSD0611 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FSD611(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);       
            
              /*********** 4: INSERTAR aqpa974: FPP001 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FPP001(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);       
            
              /*********** 5: INSERTAR aqpa973: FPP002 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FPP002(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);       
            
              /*********** 6: INSERTAR aqpb060: X054023 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_X054023(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);         
              
              /*********** 7: INSERTAR aqpa975: FSD012 - BACKUP *****************/
              pq_cr_historico_pagos_dia.sp_insertar_FSD012(lx_pgcod, --
                                                           lx_aomod, --
                                                           lx_aosuc, --
                                                           lx_aomda, --
                                                           lx_aopap, --
                                                           lx_aocta, --
                                                           lx_aooper, --
                                                           lx_aosbop, --
                                                           lx_aotope);       
            
              --- Final: validación          
          
          
          end;
        end if;
        
        
        
      
  
      
      end;
    end if;
  
  end sp_insertar_JAQA255;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                                                                                                                                

PROCEDURE sp_actualizar_datos(pn_pgcod  in number,
                              pn_aomod  in number,
                              pn_aosuc  in number,
                              pn_aomda  in number,
                              pn_aopap  in number,
                              pn_aocta  in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
begin
 
      update aqpb060 t
         set t.aqpb060aosuc = pn_aosuc,
             t.aqpb060aosbop = pn_aosbop,
             t.aqpb060aotop = pn_aotope
       where
             t.aqpb060pgcod = pn_pgcod
             and t.aqpb060aomod = pn_aomod
             --and t.aqpb060aosuc = i.aqpb066suc
             and t.aqpb060aomda = pn_aomda
             and t.aqpb060aopap = pn_aopap
             and t.aqpb060aocta = pn_aocta
             and t.aqpb060aooper = pn_aooper
             --and t.aqpb060aosbop = i.aqpb066sbo
             --and t.aqpb060aotop = pn_aotope
             ;
      commit;

      update aqpb061 t
         set t.aqpb061suc = pn_aosuc,
             t.aqpb061sbop = pn_aosbop,
             t.aqpb061tope = pn_aotope
       where
             t.aqpb061pgcod = pn_pgcod
             and t.aqpb061mod = pn_aomod
             --and t.aqpb061suc = i.aqpb066suc
             and t.aqpb061mda = pn_aomda
             and t.aqpb061pap = pn_aopap
             and t.aqpb061cta = pn_aocta
             and t.aqpb061oper = pn_aooper
             --and t.aqpb061sbop = i.aqpb066sbo
             --and t.aqpb061tope = pn_aotope
             ;
      commit;

      update aqpb062 t
         set t.aqpb062suc = pn_aosuc,
             t.aqpb062sbop = pn_aosbop,
             t.aqpb062tope = pn_aotope
       where
             t.aqpb062pgcod = pn_pgcod
             and t.aqpb062mod = pn_aomod
             --and t.aqpb062suc = i.aqpb066suc
             and t.aqpb062mda = pn_aomda
             and t.aqpb062pap = pn_aopap
             and t.aqpb062cta = pn_aocta
             and t.aqpb062oper = pn_aooper
             --and t.aqpb062sbop = i.aqpb066sbo
             --and t.aqpb062tope = pn_aotope
             ;
      commit;

      update aqpb063 t
         set t.aqpb063suc = pn_aosuc,
             t.aqpb063sbop = pn_aosbop,
             t.aqpb063tope = pn_aotope
       where
             t.aqpb063pgcod = pn_pgcod
             and t.aqpb063mod = pn_aomod
             --and t.aqpb063suc = i.aqpb066suc
             and t.aqpb063mda = pn_aomda
             and t.aqpb063pap = pn_aopap
             and t.aqpb063cta = pn_aocta
             and t.aqpb063oper = pn_aooper
             --and t.aqpb063sbop = i.aqpb066sbo
             --and t.aqpb063tope = pn_aotope
             ;
      commit;

      update aqpa973 t
         set t.aqpa973suc = pn_aosuc,
             t.aqpa973sbop = pn_aosbop,
             t.aqpa973tope = pn_aotope
       where
             t.aqpa973cod = pn_pgcod
             and t.aqpa973mod = pn_aomod
             --and t.aqpa973suc = i.aqpb066suc
             and t.aqpa973mda = pn_aomda
             and t.aqpa973pap = pn_aopap
             and t.aqpa973cta = pn_aocta
             and t.aqpa973oper = pn_aooper
             --and t.aqpa973sbop = i.aqpb066sbo
             --and t.aqpa973tope = pn_aotope
             ;
      commit;

      update aqpa974 t
         set t.aqpa974suc = pn_aosuc,
             t.aqpa974sbop = pn_aosbop,
             t.aqpa974tope = pn_aotope
       where
             t.aqpa974pgcod = pn_pgcod
             and t.aqpa974mod = pn_aomod
             --and t.aqpa974suc = i.aqpb066suc
             and t.aqpa974mda = pn_aomda
             and t.aqpa974pap = pn_aopap
             and t.aqpa974cta = pn_aocta
             and t.aqpa974oper = pn_aooper
             --and t.aqpa974sbop = i.aqpb066sbo
             --and t.aqpa974tope = pn_aotope
             ;
      commit;

      update aqpa975 t
         set t.aqpa975suc = pn_aosuc,
             t.aqpa975sbop = pn_aosbop,
             t.aqpa975tope = pn_aotope
       where
             t.aqpa975cod = pn_pgcod
             and t.aqpa975mod = pn_aomod
             --and t.aqpa975suc = i.aqpb066suc
             and t.aqpa975mda = pn_aomda
             and t.aqpa975pap = pn_aopap
             and t.aqpa975cta = pn_aocta
             and t.aqpa975oper = pn_aooper
             --and t.aqpa975sbop = i.aqpb066sbo
             --and t.aqpa975tope = pn_aotope
             ;
      commit;
      
      update aqpb064 t
         set t.aqpb064aosuc = pn_aosuc,
             t.aqpb064aosbop = pn_aosbop,
             t.aqpb064aotope = pn_aotope
       where
             t.aqpb064pgcod = pn_pgcod
             and t.aqpb064aomod = pn_aomod
             --and t.aqpb064aosuc = i.aqpb066suc
             and t.aqpb064aomda = pn_aomda
             and t.aqpb064aopap = pn_aopap
             and t.aqpb064aocta = pn_aocta
             and t.aqpb064aooper = pn_aooper
             --and t.aqpb064aosbop = i.aqpb066sbo
             --and t.aqpb064aotope = pn_aotope
             and t.aqpb064orden = 1;
      commit;      

      update aqpb009 t
         set t.aqpb009suc = pn_aosuc,
             t.aqpb009sbo = pn_aosbop,
             t.aqpb009top = pn_aotope
       where
             --t.aqpb009fep = i.aqpb066fep
             --and t.aqpb009cor = i.aqpb066cor
             t.aqpb009emp = pn_pgcod
             and t.aqpb009mod = pn_aomod
             --and t.aqpb009suc = i.aqpb066suc
             and t.aqpb009mda = pn_aomda
             and t.aqpb009pap = pn_aopap
             and t.aqpb009cta = pn_aocta
             and t.aqpb009ope = pn_aooper
             --and t.aqpb009sbo = i.aqpb066sbo
             --and t.aqpb009top = pn_aotope
             ;
      commit; 


end sp_actualizar_datos;    

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

procedure sp_ultfeccalen(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    out date,
                           pn_cuotas out number,
                           pn_flag   out number) is
    lc_stat character(1);
    ln_tipo number(1);
  
  begin
    ln_tipo := 0;
    begin
    
      select max(a.ppfpag)
        into pd_fec
        from fsd601 a
       where pgcod = pn_emp
         and ppmod = pn_mod
         and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = pn_sbo
         and pptope = pn_top
         and exists (select *
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.d602co = 'S'
                 and (b.d602mo, b.d602tr) not in
                     (select tp1nro1, tp1nro2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 11105
                         and tp1corr1 = 40
                         and tp1corr2 in (1, 3)));
    
    exception
      when others then
        ln_tipo := 1;
        begin
          select aofval
            into pd_fec
            from fsd010
           where pgcod = pn_emp
             and aomod = pn_mod
             and aosuc = pn_suc
             and aomda = pn_mda
             and aopap = pn_pap
             and aocta = pn_cta
             and aooper = pn_ope
             and aosbop = pn_sbo
             and aotope = pn_top;
        exception
          when others then
            pd_fec := null;
        end;
    end;
    If pd_fec is null then
      ln_tipo := 1;
      begin
        select aofval
          into pd_fec
          from fsd010
         where pgcod = pn_emp
           and aomod = pn_mod
           and aosuc = pn_suc
           and aomda = pn_mda
           and aopap = pn_pap
           and aocta = pn_cta
           and aooper = pn_ope
           and aosbop = pn_sbo
           and aotope = pn_top;
      exception
        when others then
          pd_fec := null;
      end;
    
    end if;
  
    if pd_fec is not null then
      begin
        select nvl(count(*), 0)
          into pn_cuotas
          from fsd601 a
         where pgcod = pn_emp
           and ppmod = pn_mod
           and ppsuc = pn_suc
           and ppmda = pn_mda
           and pppap = pn_pap
           and ppcta = pn_cta
           and ppoper = pn_ope
           and ppsbop = pn_sbo
           and pptope = pn_top
           and ppfpag > pd_fec;
      exception
        when others then
          pn_cuotas := 0;
      end;
    end if;
  
    begin
      select pp1stat
        into lc_stat
        from (select *
                from fsd602 b
               where b.pgcod = pn_emp
                 and b.ppmod = pn_mod
                 and b.ppsuc = pn_suc
                 and b.ppmda = pn_mda
                 and b.pppap = pn_pap
                 and b.ppcta = pn_cta
                 and b.ppoper = pn_ope
                 and b.ppsbop = pn_sbo
                 and b.pptope = pn_top
                 and b.ppfpag = pd_fec
                 and b.d602co = 'S'
                 and (b.d602mo, b.d602tr) not in
                     (select tp1nro1, tp1nro2
                        from fst198
                       where tp1cod = 1
                         and tp1cod1 = 11105
                         and tp1corr1 = 40
                         and tp1corr2 in (1, 3))
               order by pp1nump desc)
       where rownum = 1;
    exception
      when others then
        lc_stat := null;
    end;
  
    if ln_tipo = 0 then
      if lc_stat = 'T' then
        pn_flag := 0;
      else
        pn_flag := 1;
      end if;
    else
      pn_flag := 2;
    end if;
  end sp_ultfeccalen;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

Procedure sp_backup_ini(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pc_usu in varchar2) is
    pc_usuChar Character(10);
    pn_cor     numeric(10);
    pc_hor     varchar2(8);
  
    lc_codi varchar2(100);
  
  begin
  
    pc_usuChar := pc_usu;
    begin
      select nvl(max(aqpb012cor), 0)
        into pn_cor
        from aqpb012
       where aqpb012fec = pd_fec;
    exception
      when others then
        pn_cor := 0;
    end;
  
    pn_cor := nvl(pn_cor, 0) + 1;
  
    select to_char(sysdate, 'HH24:MI:SS') into pc_hor from dual;
  
    insert into aqpb012
      (aqpb012fec,
       aqpb012cor,
       aqpb012pgcod,
       aqpb012mod,
       aqpb012suc,
       aqpb012mda,
       aqpb012pap,
       aqpb012cta,
       aqpb012oper,
       aqpb012sbop,
       aqpb012tope,
       aqpb012hor,
       aqpb012usu,
       aqpb012tipo,
       aqpb012est)
    VALUES
      (pd_fec,
       pn_cor,
       pn_emp,
       pn_mod,
       pn_suc,
       pn_mda,
       pn_pap,
       pn_cta,
       pn_ope,
       pn_sbo,
       pn_top,
       pc_hor,
       pc_usuChar,
       'IND',
       'C');
  
    -------------
    delete from aqpb012_010 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
  
    delete from aqpb012_011 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.scmod = pn_mod
       and a.scsuc = pn_suc
       and a.scmda = pn_mda
       and a.scpap = pn_pap
       and a.sccta = pn_cta
       and a.scoper = pn_ope
       and a.scsbop = pn_sbo
       and a.sctope = pn_top;
  
    delete from aqpb012_601 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from aqpb012_611 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from aqpb012_602 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from aqpb012_612 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from aqpb012_002 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top;
  
    delete from aqpb012_012 a
     where a.fec = pd_fec
       and a.cor = pn_cor
       and a.pgcod = pn_emp
       and a.aomod = pn_mod
       and a.aosuc = pn_suc
       and a.aomda = pn_mda
       and a.aopap = pn_pap
       and a.aocta = pn_cta
       and a.aooper = pn_ope
       and a.aosbop = pn_sbo
       and a.aotope = pn_top;
    ----------------
  
    insert into aqpb012_010
      (fec,
       cor,
       pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       aofval,
       aofvto,
       aopzo,
       aottas,
       aotasa,
       aotmor,
       aottac,
       aotasc,
       aotdia,
       aotvto,
       aotano,
       aotint,
       aodrev,
       aoimp,
       aopre,
       aopre1,
       aotcbi,
       aotcbi1,
       aoarb,
       aoarb1,
       aomd,
       aomd1,
       aonume,
       aofnum,
       aoafiv,
       aocbcu,
       aostat,
       aoavis,
       aoplus,
       aoeven,
       aofe99,
       aocltcod,
       aoperiod)
      select pd_fec,
             pn_cor,
             pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             pn_sbo,
             aotope,
             aofval,
             aofvto,
             aopzo,
             aottas,
             aotasa,
             aotmor,
             aottac,
             aotasc,
             aotdia,
             aotvto,
             aotano,
             aotint,
             aodrev,
             aoimp,
             aopre,
             aopre1,
             aotcbi,
             aotcbi1,
             aoarb,
             aoarb1,
             aomd,
             aomd1,
             aonume,
             aofnum,
             aoafiv,
             aocbcu,
             aostat,
             aoavis,
             aoplus,
             aoeven,
             aofe99,
             aocltcod,
             aoperiod
      
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
            --and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = 0 --pn_sbo
         --and a.aotope = pn_top
         ;
  
    insert into aqpb012_011
      (fec,
       cor,
       pgcod,
       scsuc,
       scrub,
       scmda,
       scpap,
       sccta,
       scoper,
       scsbop,
       sctope,
       scmod,
       scfcon,
       scfval,
       scfvto,
       scfulm,
       scpzo,
       scsdo,
       scsdoh,
       scsegm,
       scfunc,
       scstat,
       sccc,
       sctit,
       sccap,
       scplzo,
       scgru)
      select pd_fec,
             pn_cor,
             pgcod,
             scsuc,
             scrub,
             scmda,
             scpap,
             sccta,
             scoper,
             pn_sbo,
             sctope,
             scmod,
             scfcon,
             scfval,
             scfvto,
             scfulm,
             scpzo,
             scsdo,
             scsdoh,
             scsegm,
             scfunc,
             scstat,
             sccc,
             sctit,
             sccap,
             scplzo,
             scgru
      
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
            --and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = 0 --pn_sbo
         --and a.sctope = pn_top
         ;
  
    insert into aqpb012_601
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppfval,
       ppfvto,
       pppzo,
       ppcap,
       ppint,
       ppintmex,
       ppicap,
       ppiint,
       ppstat,
       ppnume,
       ppfinv,
       d601cd,
       d601mo,
       d601su,
       d601tr,
       d601re,
       d601fc,
       d601or,
       d601sb,
       d601co)
    
      select pd_fec,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             ppfval,
             ppfvto,
             pppzo,
             ppcap,
             ppint,
             ppintmex,
             ppicap,
             ppiint,
             ppstat,
             ppnume,
             ppfinv,
             d601cd,
             d601mo,
             d601su,
             d601tr,
             d601re,
             d601fc,
             d601or,
             d601sb,
             d601co
      
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
            --and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = 0 --pn_sbo
         --and a.pptope = pn_top
         ;
  
    insert into aqpb012_611
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       ppexte,
       ppimp1,
       ppimp2,
       ppimp3,
       ppimp4,
       ppimp5,
       ppimp6,
       ppimp7,
       ppimp8,
       ppimp9,
       ppimp10,
       ppimp11,
       ppimp12,
       ppimp13,
       ppimp14,
       ppimp15,
       ppimp16,
       ppimp17,
       ppimp18,
       ppimp19,
       ppimp20)
      select pd_fec,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             ppexte,
             ppimp1,
             ppimp2,
             ppimp3,
             ppimp4,
             ppimp5,
             ppimp6,
             ppimp7,
             ppimp8,
             ppimp9,
             ppimp10,
             ppimp11,
             ppimp12,
             ppimp13,
             ppimp14,
             ppimp15,
             ppimp16,
             ppimp17,
             ppimp18,
             ppimp19,
             ppimp20
      
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
            --and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = 0 --pn_sbo
         --and a.pptope = pn_top
         ;
  
    insert into aqpb012_602
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1fech,
       pp1cap,
       pp1int,
       pp1intmex,
       pp1intm,
       pp1intmmex,
       pp1icap,
       pp1iint,
       pp1iintm,
       pp1salcap,
       pp1salint,
       pp1salade,
       pp1salmor,
       pp1stat,
       pp1salintm,
       pp1salmorm,
       pp1saladem,
       d602cd,
       d602mo,
       d602su,
       d602tr,
       d602re,
       d602fc,
       d602or,
       d602sb,
       d602co)
      select pd_fec,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             pp1nump,
             pp1fech,
             pp1cap,
             pp1int,
             pp1intmex,
             pp1intm,
             pp1intmmex,
             pp1icap,
             pp1iint,
             pp1iintm,
             pp1salcap,
             pp1salint,
             pp1salade,
             pp1salmor,
             pp1stat,
             pp1salintm,
             pp1salmorm,
             pp1saladem,
             d602cd,
             d602mo,
             d602su,
             d602tr,
             d602re,
             d602fc,
             d602or,
             d602sb,
             d602co
      
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
            --and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = 0 --pn_sbo
         --and a.pptope = pn_top
         ;
  
    insert into aqpb012_612
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp1nump,
       pp1exte,
       pp1imp1,
       pp1imp2,
       pp1imp3,
       pp1imp4,
       pp1imp5,
       pp1imp6,
       pp1imp7,
       pp1imp8,
       pp1imp9,
       pp1imp10,
       pp1imp11,
       pp1imp12,
       pp1imp13,
       pp1imp14,
       pp1imp15,
       pp1imp16,
       pp1imp17,
       pp1imp18,
       pp1imp19,
       pp1imp20,
       pp1sal1,
       pp1sal2,
       pp1sal3,
       pp1sal4,
       pp1sal5,
       pp1sal6,
       pp1sal7,
       pp1sal8,
       pp1sal9,
       pp1sal10,
       pp1sal11,
       pp1sal12,
       pp1sal13,
       pp1sal14,
       pp1sal15,
       pp1sal16,
       pp1sal17,
       pp1sal18,
       pp1sal19,
       pp1sal20)
    
      select pd_fec,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             pp1nump,
             pp1exte,
             pp1imp1,
             pp1imp2,
             pp1imp3,
             pp1imp4,
             pp1imp5,
             pp1imp6,
             pp1imp7,
             pp1imp8,
             pp1imp9,
             pp1imp10,
             pp1imp11,
             pp1imp12,
             pp1imp13,
             pp1imp14,
             pp1imp15,
             pp1imp16,
             pp1imp17,
             pp1imp18,
             pp1imp19,
             pp1imp20,
             pp1sal1,
             pp1sal2,
             pp1sal3,
             pp1sal4,
             pp1sal5,
             pp1sal6,
             pp1sal7,
             pp1sal8,
             pp1sal9,
             pp1sal10,
             pp1sal11,
             pp1sal12,
             pp1sal13,
             pp1sal14,
             pp1sal15,
             pp1sal16,
             pp1sal17,
             pp1sal18,
             pp1sal19,
             pp1sal20
      
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
            --and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = 0 --pn_sbo
         --and a.pptope = pn_top
         ;
  
    insert into aqpb012_001
      (fec,
       cor,
       pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       sgcod,
       pp001vc,
       pp001imp,
       pp001porc,
       pp001plus,
       pp001part,
       pp001veh,
       pp001inm,
       pp001end,
       pp001stat,
       pp001co,
       pp001aux1,
       pp001aux2,
       pp001aux3,
       pp001aux4,
       pp001aux5,
       pp001aux6,
       pp001aux7)
      select pd_fec,
             pn_cor,
             pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             pn_sbo,
             aotope,
             sgcod,
             pp001vc,
             pp001imp,
             pp001porc,
             pp001plus,
             pp001part,
             pp001veh,
             pp001inm,
             pp001end,
             pp001stat,
             pp001co,
             pp001aux1,
             pp001aux2,
             pp001aux3,
             pp001aux4,
             pp001aux5,
             pp001aux6,
             pp001aux7
        from fpp001
       where pgcod = pn_emp
         and aomod = pn_mod
            --and aosuc = pn_suc
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = 0 --pn_sbo
         --and aotope = pn_top
         ;
  
    insert into aqpb012_003
      (fec,
       cor,
       pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       pp003nump,
       prestconc,
       pp003imp,
       pp003stat,
       pp003aux1,
       pp003aux2,
       pp003aux3)
      select pd_fec,
             pn_cor,
             pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             pp003nump,
             prestconc,
             pp003imp,
             pp003stat,
             pp003aux1,
            pp003aux2,
             pp003aux3
        from fpp003
       where pgcod = pn_emp
         and ppmod = pn_mod
            --and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = 0 --pn_sbo
         --and pptope = pn_top
         ;
  
    insert into aqpb012_002
      (pgcod,
       ppmod,
       ppsuc,
       ppmda,
       pppap,
       ppcta,
       ppoper,
       ppsbop,
       pptope,
       ppfpag,
       pptipo,
       prestconc,
       pp002imp,
       pp002stat,
       pp002aux1,
       pp002aux2,
       pp002aux3,
       fec,
       cor)
      select pgcod,
             ppmod,
             ppsuc,
             ppmda,
             pppap,
             ppcta,
             ppoper,
             pn_sbo,
             pptope,
             ppfpag,
             pptipo,
             prestconc,
             pp002imp,
             pp002stat,
             pp002aux1,
             pp002aux2,
             pp002aux3,
             pd_fec,
             pn_cor
        from fpp002
       where pgcod = pn_emp
         and ppmod = pn_mod
            --and ppsuc = pn_suc
         and ppmda = pn_mda
         and pppap = pn_pap
         and ppcta = pn_cta
         and ppoper = pn_ope
         and ppsbop = 0 --pn_sbo
         --and pptope = pn_top
         ;
  
    insert into aqpb012_012
      (pgcod,
       aomod,
       aosuc,
       aomda,
       aopap,
       aocta,
       aooper,
       aosbop,
       aotope,
       evcorr,
       evtipo,
       evfval,
       evfvto,
       evimp,
       evttas,
       evtasa,
       evcap,
       evint,
       evmor,
       evscap,
       evsint,
       evsmor,
       evintc,
       evmorc,
       evcd01,
       evcd02,
       evinv,
       evper,
       evtcbi,
       evtcbi1,
       evarb,
       evarb1,
       evmd,
       evmd1,
       evpre,
       evpre1,
       d012cd,
       d012mo,
       d012su,
       d012tr,
       d012re,
       d012fc,
       d012or,
       d012sb,
       d012co,
       fec,
       cor)
      select pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             pn_sbo,
             aotope,
             evcorr,
             evtipo,
             evfval,
             evfvto,
             evimp,
             evttas,
             evtasa,
             evcap,
             evint,
             evmor,
             evscap,
             evsint,
             evsmor,
             evintc,
             evmorc,
             evcd01,
             evcd02,
             evinv,
             evper,
             evtcbi,
             evtcbi1,
             evarb,
             evarb1,
             evmd,
             evmd1,
             evpre,
             evpre1,
             d012cd,
             d012mo,
             d012su,
             d012tr,
             d012re,
             d012fc,
             d012or,
             d012sb,
             d012co,
             pd_fec,
             pn_cor
        from fsd012 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
            --and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = 0 --pn_sbo
         --and a.aotope = pn_top
         ;
  
    -- commit;
  
  exception
    when others then
      null;
      --rollback;
    /*    lc_codi := sqlcode;
        insert into aqpb012_1(aocta,codigo, aotime)
         values (99,lc_codi, sysdate);
    */
  end Sp_backup_ini;


  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    
procedure sp_verifica_refinanciado(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_flag out number) is
    ln_cont number(5);
  
  Begin
    pn_flag := 0;
    select nvl(count(*),0)
      into ln_cont
      from fsd601 a
     where pgcod = pn_emp
       and ppmod = pn_mod
       and ppsuc = pn_suc
       and ppmda = pn_mda
       and pppap = pn_pap
       and ppcta = pn_cta
       and ppoper = pn_ope
       and ppsbop = pn_sbo
       and pptope = pn_top
       and ppfpag = (select min(b.ppfpag)
                       from fsd601 b
                      where b.pgcod = pn_emp
                        and b.ppmod = pn_mod
                        and b.ppsuc = pn_suc
                        and b.ppmda = pn_mda
                        and b.pppap = pn_pap
                        and b.ppcta = pn_cta
                        and b.ppoper = pn_ope
                        and b.ppsbop = pn_sbo
                        and b.pptope = pn_top)
       and (d601mo, d601tr) in
           (select tp1nro1, tp1nro2
              from fst198
             where tp1cod = 1
               and tp1cod1 = 11105
               and tp1corr1 = 40
               and tp1corr2 = 3);
    if ln_cont > 0 then
      pn_flag := 1;
    end if;
  end sp_verifica_refinanciado;
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   

 PROCEDURE sp_insertar_FSD601_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);
                              
    ---ACTUAL
    cursor jaqz520_fsd601 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
             *
      from 
             FSD601 t
      where 
             t.pgcod = cr_pgcod
             and t.ppmod = cr_aomod
             and t.ppsuc = cr_aosuc
             and t.ppmda = cr_aomda
             and t.pppap = cr_aopap
             and t.ppcta = cr_aocta
             and t.ppoper = cr_aooper
             and t.ppsbop = cr_aosbop
             and t.pptope = cr_aotope
       order by t.ppfpag asc
       ;                    
                  
      
begin
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;   


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
             k.ppsbop
             );
        exception
          when others then
            --lc_flag := 'N';
                                    
        lc_coderr := sqlcode;
        lc_msgerr := substr(trim(sqlerrm),1,90);
                                  
        insert into aqpb066
        (  
            aqpb066fep,
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
            aqpb066eamsge
         )
        values
        (  
           lc_fecha,
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

 PROCEDURE sp_insertar_FSD602_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);
                              
    ---ACTUAL
    cursor jaqz520_fsd602 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
      select 
            *
      from 
             FSD602 t
      where t.pgcod = cr_pgcod
         and t.ppmod = cr_aomod
         and t.ppsuc = cr_aosuc
         and t.ppmda = cr_aomda
         and t.pppap = cr_aopap
         and t.ppcta = cr_aocta
         and t.ppoper = cr_aooper
         and t.ppsbop = cr_aosbop
         and t.pptope = cr_aotope
       order by t.ppfpag asc
       ;                   
                  
      
begin
     
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;      

            
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
            lc_msgerr := substr(trim(sqlerrm),1,90);
                                
            insert into aqpb066
            (  
                aqpb066fep,
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
                aqpb066eamsge
             )
            values
            (  
               lc_fecha,
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


 PROCEDURE sp_insertar_FSD611_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
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
      from 
           FSD611 t
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
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1; 
     
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
          lc_msgerr := substr(trim(sqlerrm),1,90);
                            
          insert into aqpb066
          (  
              aqpb066fep,
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
              aqpb066eamsge
           )
          values
          (  
             lc_fecha,
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

  
 PROCEDURE sp_insertar_FPP001_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
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
      select 
             *
      from 
             FPP001 t
       where 
             t.pgcod = cr_pgcod
             and t.aomod = cr_aomod
             and t.aosuc = cr_aosuc
             and t.aomda = cr_aomda
             and t.aopap = cr_aopap
             and t.aocta = cr_aocta
             and t.aooper = cr_aooper
             and t.aosbop = cr_aosbop
             and t.aotope = cr_aotope;
      
begin
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;      
     
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
          lc_msgerr := substr(trim(sqlerrm),1,90);
                              
          insert into aqpb066
          (  
              aqpb066fep,
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
              aqpb066eamsge
           )
          values
          (  
             lc_fecha,
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

 PROCEDURE sp_insertar_FPP002_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);
                              
    ---ACTUAL
    cursor jaqz520_fpp002 ( cr_pgcod number,
                                cr_aomod number, 
                                cr_aosuc number, 
                                cr_aomda number, 
                                cr_aopap number, 
                                cr_aocta number, 
                                cr_aooper number, 
                                cr_aosbop number, 
                                cr_aotope number) is    
      select 
            * 
      from 
            FPP002 t 
      where 
           t.pgcod = cr_pgcod and
           t.ppmod = cr_aomod and
           t.ppsuc = cr_aosuc and
           t.ppmda = cr_aomda and
           t.pppap = cr_aopap and
           t.ppcta = cr_aocta and
           t.ppoper = cr_aooper and
           t.ppsbop = cr_aosbop and
           t.pptope = cr_aotope
      ;                      
                  
      
begin

     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;   

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
              (
                aqpa973cod,
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
                aqpa973obop
              )
              values
              (
                  r.pgcod,
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
                  r.ppsbop
              );
           exception
              when others then
                  -- lc_flag := 'N';
                                    
              lc_coderr := sqlcode;
              lc_msgerr := substr(trim(sqlerrm),1,90);
                                  
              insert into aqpb066
              (  
                  aqpb066fep,
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
                  aqpb066eamsge
               )
              values
              (  
                 lc_fecha,
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

PROCEDURE sp_insertar_X054023_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);
                              
    ---ACTUAL   
    cursor jaqz520_x054023 ( cr_pgcod number,
                      cr_aomod number, 
                      cr_aosuc number, 
                      cr_aomda number, 
                      cr_aopap number, 
                      cr_aocta number, 
                      cr_aooper number, 
                      cr_aosbop number, 
                      cr_aotope number) is    
      select 
            * 
       from 
            X054023 t 
       where 
             t.xllpgcod = cr_pgcod and
             t.xllaomod = cr_aomod and
             t.xllaosuc = cr_aosuc and
             t.xllaomda = cr_aomda and
             t.xllaopap = cr_aopap and
             t.xllaocta = cr_aocta and
             t.xllaooper = cr_aooper and
             t.xllaosbop = cr_aosbop and
             t.xllaotop = cr_aotope 
          ;                     
                  
      
begin
  
     select t.pgfape into lc_fecha from fst017 t where t.pgcod=1; 

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
               (
                aqpb060pgcod,
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
                aqpb060aoobop 
              )
              values
              (
                s.xllpgcod,
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
                s.xllaosbop
              );
           exception
              when others then
                  -- lc_flag := 'N';
                                        
              lc_coderr := sqlcode;
              lc_msgerr := substr(trim(sqlerrm),1,90);
                                      
              insert into aqpb066
              (  
                  aqpb066fep,
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
                  aqpb066eamsge
               )
              values
              (  
                 lc_fecha,
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

 PROCEDURE sp_insertar_FSD012_b(pn_pgcod in number,
                              pn_aomod in number,
                              pn_aosuc in number,
                              pn_aomda in number,
                              pn_aopap in number,
                              pn_aocta in number,
                              pn_aooper in number,
                              pn_aosbop in number,
                              pn_aotope in number) is
                              
    lx_cont number;  
    lc_flag char(1);
    lc_fecha date;
    lc_coderr char(100);
    lc_msgerr char(100);

    ---ACTUAL: FSD012   
    cursor jaqz520_fsd012 ( cr_pgcod number,
                            cr_aomod number, 
                            cr_aosuc number, 
                            cr_aomda number, 
                            cr_aopap number, 
                            cr_aocta number, 
                            cr_aooper number, 
                            cr_aosbop number, 
                            cr_aotope number) is    
    select 
          * 
    from 
          FSD012 t 
    where 
         t.pgcod = cr_pgcod and
         t.aomod = cr_aomod and
         t.aosuc = cr_aosuc and
         t.aomda = cr_aomda and
         t.aopap = cr_aopap and
         t.aocta = cr_aocta and
         t.aooper = cr_aooper and
         t.aosbop = cr_aosbop and
         t.aotope =  cr_aotope
    ;               
                                
      
begin
  
    select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;      

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
              (
                aqpa975cod,
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
                aqpa975obop
              )                           
              values
              (
                  u.pgcod,
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
                  u.aosbop
              );
           exception
              when others then
                  -- lc_flag := 'N';
                                      
              lc_coderr := sqlcode;
              lc_msgerr := substr(trim(sqlerrm),1,90);
                                    
              insert into aqpb066
              (  
                  aqpb066fep,
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
                  aqpb066eamsge
               )
              values
              (  
                 lc_fecha,
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
  
PROCEDURE sp_eliminar_registros(pn_pgcod  in number,
                                pn_aomod  in number,
                                pn_aosuc  in number,
                                pn_aomda  in number,
                                pn_aopap  in number,
                                pn_aocta  in number,
                                pn_aooper in number,
                                pn_aosbop in number,
                                pn_aotope in number) is
begin

      delete from aqpb060 t
      where  t.aqpb060pgcod = pn_pgcod and
             t.aqpb060aomod = pn_aomod and
             --t.aqpb060aosuc = pn_aosuc and
             t.aqpb060aomda = pn_aomda and
             t.aqpb060aopap = pn_aopap and
             t.aqpb060aocta = pn_aocta and
             t.aqpb060aooper = pn_aooper --and
             --t.aqpb060aosbop = pn_aosbop and
             --t.aqpb060aotop  = pn_aotope 
             ;
             
      delete from aqpb061 t
      where  t.aqpb061pgcod = pn_pgcod and
             t.aqpb061mod = pn_aomod and
             --t.aqpb061suc = pn_aosuc and
             t.aqpb061mda = pn_aomda and
             t.aqpb061pap = pn_aopap and
             t.aqpb061cta = pn_aocta and
             t.aqpb061oper = pn_aooper --and
             --t.aqpb061sbop = pn_aosbop and
             --t.aqpb061tope  = pn_aotope 
             ;
             
      delete from aqpb062 t
      where  t.aqpb062pgcod = pn_pgcod and
             t.aqpb062mod = pn_aomod and
             --t.aqpb062suc = pn_aosuc and
             t.aqpb062mda = pn_aomda and
             t.aqpb062pap = pn_aopap and
             t.aqpb062cta = pn_aocta and
             t.aqpb062oper = pn_aooper --and
             --t.aqpb062sbop = pn_aosbop and
             --t.aqpb062tope  = pn_aotope 
             ;  
             
      delete from aqpb063 t
      where  t.aqpb063pgcod = pn_pgcod and
             t.aqpb063mod = pn_aomod and
             --t.aqpb063suc = pn_aosuc and
             t.aqpb063mda = pn_aomda and
             t.aqpb063pap = pn_aopap and
             t.aqpb063cta = pn_aocta and
             t.aqpb063oper = pn_aooper --and
             --t.aqpb063sbop = pn_aosbop and
             --t.aqpb063tope  = pn_aotope 
             ;    
             
      delete from aqpa973 t
      where  t.aqpa973cod = pn_pgcod and
             t.aqpa973mod = pn_aomod and
             --t.aqpa973suc = pn_aosuc and
             t.aqpa973mda = pn_aomda and
             t.aqpa973pap = pn_aopap and
             t.aqpa973cta = pn_aocta and
             t.aqpa973oper = pn_aooper --and
             --t.aqpa973sbop = pn_aosbop and
             --t.aqpa973tope  = pn_aotope 
             ;
             
      delete from aqpa974 t
      where  t.aqpa974pgcod = pn_pgcod and
             t.aqpa974mod = pn_aomod and
             --t.aqpa974suc = pn_aosuc and
             t.aqpa974mda = pn_aomda and
             t.aqpa974pap = pn_aopap and
             t.aqpa974cta = pn_aocta and
             t.aqpa974oper = pn_aooper --and
             --t.aqpa974sbop = pn_aosbop and
             --t.aqpa974tope  = pn_aotope 
             ;  
             
      delete from aqpa975 t
      where  t.aqpa975cod = pn_pgcod and
             t.aqpa975mod = pn_aomod and
             --t.aqpa975suc = pn_aosuc and
             t.aqpa975mda = pn_aomda and
             t.aqpa975pap = pn_aopap and
             t.aqpa975cta = pn_aocta and
             t.aqpa975oper = pn_aooper --and
             --t.aqpa975sbop = pn_aosbop and
             --t.aqpa975tope  = pn_aotope 
             ; 
             
      delete from aqpb064 t
      where  t.aqpb064pgcod = pn_pgcod and
             t.aqpb064aomod = pn_aomod and
            -- t.aqpb064aosuc = pn_aosuc and
             t.aqpb064aomda = pn_aomda and
             t.aqpb064aopap = pn_aopap and
             t.aqpb064aocta = pn_aocta and
             t.aqpb064aooper = pn_aooper --and
             --t.aqpb064aosbop = pn_aosbop and
             --t.aqpb064aotope  = pn_aotope 
             ;  
             
      delete from aqpb009 t
      where  t.aqpb009emp = pn_pgcod and
             t.aqpb009mod = pn_aomod and
             --t.aqpb009suc = pn_aosuc and
             t.aqpb009mda = pn_aomda and
             t.aqpb009pap = pn_aopap and
             t.aqpb009cta = pn_aocta and
             t.aqpb009ope = pn_aooper --and
             --t.aqpb009sbo = pn_aosbop and
             --t.aqpb009top  = pn_aotope 
             ;                                                                    
  
         commit;

  
end sp_eliminar_registros;                                   
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     

                             
end pq_cr_historico_pagos_dia;
/

