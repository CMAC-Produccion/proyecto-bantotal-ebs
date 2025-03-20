create or replace package "PQ_CR_REPRO_PROCDIARIO" is

  -- Author  : CHERNANDEZ
  -- Created : 22/04/2020 10:25:05
  -- Purpose : proceso diario de reprogramaciones
  -- Modificado : KVALENCIAC
  -- Fecha : 04/06/2020 
  -- Modificación : Se adicionaronnuevas tablas de reprogramaciones y se adicionó scheduler
  -- Modificado : KVALENCIAC
  -- Fecha : 02/09/2020 
  -- Modificación : Incidencia por nodo incorrecto
  -- Modificado : KVALENCIAC  
  -- Fecha : 04/09/2020 
  -- Modificación : Incidencia por doble registro
  -- Modificado : KVALENCIAC  
  -- Fecha :07/10/2020 
  -- Modificación : Se adicionaron filtro de que créditos les corrreponde generar las cuentas de orden según memo
  -- Public type declarations
  -- Fecha :31/12/2020 
  -- Modificación : Se adicionaron todos los créditos ya no hay filtro por suboperacion enla busqueda de la FSD011 porque puee haber cambiaod
  -- Fecha :04/01/2021 
  -- Modificación : Se adicionaron todos los créditos ya no hay filtro por suboperacion enla busqueda de la FSD011 porque puee haber cambiaod
  -- Fecha :30/03/2021 
  -- Modificación : Se ha adicionado un HInt en la FSH012 para que agarre el índice y se modificó para que no contabilice si no hay relación de rubro
  -- Public type declarations
  --Fecha:27/05/2021
  --MOdifiación: Se ha adiconado la transacción 30/97 y se ha modifcado el cálculo del conteo de las cuotas pagadas
 --Fecha:28/01/2022
  --MOdifiación: Se ha modificado para que se considere las cuotas mayores a la fecha de reprogramación 
  --Fecha:28/06/2022
  --MOdifiación: Se agregó función de número de cuotas de Riesgos
  --Fecha:30/06/2022
  --MOdifiación: Se modificó función de número de cuotas de Riesgos  
  --Fecha:13/01/2023
  --MOdifiación: Se modificó función de pago de capital 
  --Fecha:10/02/2023
  --MOdifiación: Se ha adicionado procesos para los reprogramados OM54961
  --Fecha:15/05/2023 kvalenciac
  --MOdifiación: Se ha modificado el llamado a la función de jobs 2 ya que no estaba considerando el filtro correactamente
  --Fecha:09/11/2023 kvalenciac
  --MOdifiación: Se ha adicionado neuvo proceso para las reprogramaciones individuales oficio 63223-2023
    --Fecha:21/08/2024 kvalenciac
  --MOdifiación: Cambio de las 3 funciones de pagos de la tabla de la norma 19109 (aqpa830 y aqpa830b)
     --Fecha:17/12/2024 kvalenciac
  --MOdifiación: Optimización de paquete

  procedure inicio_graba(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure graba_AQPA830(pd_fechaProg date, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
   procedure inicio_GrabaControl(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure control_AQPA830(pn_sucursal number, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  Function fn_TieneReduccionCuota(pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number, 
                                  pd_fecha in date) return character;                                                                                              
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  Function fn_PagoCuotas(pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number, 
                                  pd_fechaRepro in date,
                                  pd_fecha in date) return number;                                                                                               
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    Function fn_PagoCuotasAtras(pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number, 
                                  pd_fechaRepro in date,
                                  pd_fecha in date) return number;                                                                                               
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Function fn_PagoCapital         (pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number,                                   
                                  pn_scsdo in number,
                                  pd_fechaProg in date) return character;                                                                                                                              
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  Function fn_periocidad         (pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number) return number; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
  procedure inicio(pd_fecha date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                            
  procedure proceso_flujo1(pn_SUC   number, pd_fecha date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure proceso_diario(pn_EMP   number,--pn_EMP   number,
--                           pn_MOD number,--pn_MDA   number,                           pn_SUC number,--pn_PAP   number,
                           pn_MDA   number,--pn_CTA   number,
                           pn_PAP   number,--pn_OPE   number,
                           pn_CTA   number,--pn_SBO   number,
                           pn_OPE   number,--pd_fecha date);
                           pn_SBO   number,
                           pd_fecha date); 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                       
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_codigo(pd_fecha in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                              
 Function fn_CuotaActual(pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number, 
                                  pd_fecha in date) return number;
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                              
 Function fn_CuotaAnterior(pn_EMP in number, 
                                  pn_SUC in number, 
                                  pn_MDA in number, 
                                  pn_PAP in number,
                                  pn_SBO in number,
                                  pn_TOP in number, 
                                  pn_MOD in number,
                                  pn_CTA in number, 
                                  pn_Oper in number, 
                                  pd_fecha in date) return number; 
  procedure inicio_graba2(pd_fecha date, pd_usuario char);
  procedure inicio_GrabaControl2(pd_fecha date, pd_usuario char);
  -------------Riesgos  cambios 28/06/2022 kvalenciac
  function fn_num_cuopa_redcuo_N(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number;
   function fn_num_cuopa_redcuo_S(
                                           v_Pgfape in date, --fecha de proceso
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number ; 

  --inicio 21/08/2024 kvalenciac versión 3 de las funciones de Riesgos pero solo para el proceso de la AQPA830 y AQPA830B
  function fn_num_cuopa_redcuo_N_v3(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number;
  function fn_num_cuopa_redcuo_S_v3(
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number;
  function fn_num_cuopa_peri_may_30(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number;
  --fin 21/08/2024 kvalenciac 
    --inicio 10/02/2023 kvalenciac
  procedure inicio_grabaRE(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure graba_AQPC434(pd_fechaProg date, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure inicio_GrabaControlRE(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure control_AQPC434(pn_sucursal number, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------  
  procedure inicio_grabaRE2(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure inicio_GrabaControlRE2(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
   procedure carga_tabla(pd_fecha date, pd_usuario char);
  
--fin 10/02/2023 kvalenciac  

   --inicio 09/11/2023 kvalenciac
  procedure inicio_grabaRI(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure graba_AQPD204(pd_fechaProg date, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure inicio_GrabaControlRI(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure control_AQPD204(pn_sucursal number, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------  
  procedure inicio_grabaRI2(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure inicio_GrabaControlRI2(pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure carga_tablaRI(pd_fecha date, pd_usuario char);
  
--fin 09/11/2023 kvalenciac                                                                                                            
end pq_cr_repro_procdiario;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_CR_REPRO_PROCDIARIO" is
procedure inicio_graba(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number;      
    cursor fecha (ld_fecha in date) is
    select fecha_reprogramacion as fec
        --from USRREPBI.REP_TOT_REPRO_2020
        from AQPA833
        where (extorno like 'NO'
        or FEC_EXTORNO=ld_fecha)
        group by fecha_reprogramacion;              
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete aqpa830;
    commit; 
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job1        := 0;
    for a in fecha (pd_fecha) loop         
      lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
      ln_job1        := ln_job1 + 1;
      lc_prefjob1    := 'AQPA830';   --  prefijo del nombre
      pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                   'N' || to_char(ln_job1); ---  nombre del job
                  
      lc_variable1 := 'begin ' ||
                   ' pq_cr_repro_procdiario.graba_AQPA830(' 
                   || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable1,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Carga_AQPA830');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
             exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
          end;
       Else         
          dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable1,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Carga_AQPA830');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
         /* begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/  --  02/09/2020 kdvc
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('AQPA830', lc_fec, lc_variable1);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);  
     While ln_numjob1 > 0 loop
        ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);
     End loop;

      DELETE FROM AQPA830
      WHERE rowid not in
      (SELECT MAX(rowid)--MIN
      FROM AQPA830
      GROUP BY aqpa830cta,aqpa830ope);--aqpa830sbo
      commit;
      begin
         pq_cr_repro_procdiario.inicio_GrabaControl(pd_fecha, pd_usuario);
      end;
      delete aqpa830b where aqpa830bfecact=pd_fecha;
      commit;
      insert into aqpa830b select * from aqpa830 where aqpa830est='N';
      commit;
end inicio_graba;
-----------------------------------------------------------------------------------------------------------

procedure graba_AQPA830 (  pd_fechaProg date, pd_fecha date, pd_usuario char ) is
    cursor listado (ld_fechaProg in date) is
      select *
       -- from USRREPBI.REP_TOT_REPRO_2020
        from AQPA833
        where fecha_reprogramacion=ld_fechaProg and 
            ( extorno='NO' --FEC_EXTORNO is null
              or FEC_EXTORNO=pd_fecha );
        --order by fecha_reprogramacion,bccta,bcoper,bcsbop;
        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
Begin  
    pn_emp := 1;  
    select pgfape into ld_pgfape from fst017 where pgcod=1;
    for a in listado(pd_fechaProg) loop
           ln_CTA:= a.bccta;
           ln_OPE:= a.bcoper;
           
           ln_SBO:= a.bcsbop;
           ln_fecha := a.fecha_reprogramacion;
           ln_esta :=0; 
           begin             
           select count(*) into ln_esta from aqpa830 where aqpa830cta=ln_CTA and aqpa830ope=ln_OPE and aqpa830sbo=ln_SBO;
           exception 
             when no_data_found then
               ln_esta := 0;
           end;
            if ln_esta = 0 then             
              if ( pd_fecha = ld_pgfape ) then
                 begin
                  select f.pgcod,--aqui esta devolviendo doble registro
                         f.scsuc,
                         f.scmda,
                         f.scpap,
                         --sccta,                
                        -- scoper,
                         f.scsbop,
                         f.sctope,
                         f.scmod,
                         f.scsdo
                    into ln_EMP,
                         ln_SUC,
                         ln_MDA,
                         ln_PAP,                                                                                                   
                         ln_SBO,
                         ln_TOP,
                         ln_MOD,
                         ln_scsdo
                    from fsd011 f
                   where f.pgcod =  pn_emp
                     and f.sccta =  ln_CTA
                     and f.scoper = ln_OPE
                     --and a.scsbop = ln_SBO --  31/12/2020 que no valide suboperacion porque puede haber cambiado
                     and ( f.scmod in (select modulo from fst111 where dscod=50)
                     and f.scmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300))--en la uía esta los módulos qeu no se debenconsiderar
                     and f.scsdo < 0
                     and f.scstat not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                     and rownum=1; --kdvc 04/09/2020
                    exception 
                    when  no_data_found then
                      ln_CTA:=0;
                      ln_OPE:=0;            
                    end ;
                else
                   begin
                    select f.bcemp,
                         f.bcsuc,
                         f.bcmda,
                         f.bcpap,
                         --sccta,                
                        -- scoper,
                         f.bcsbop,
                         f.bctop,
                         f.bcmod,
                         f.bcsdmo
                    into ln_EMP,
                         ln_SUC,
                         ln_MDA,
                         ln_PAP,                                                                                                   
                         ln_SBO,
                         ln_TOP,
                         ln_MOD,
                         ln_scsdo
                    from fsh012 f                  
                    where f.BCEMP  = pn_EMP
                     and f.BCFECH = pd_fecha                 
                     and f.BCRUBR in (select rubro
                                      from fsd014
                                     where pcnivc in (select MODULO
                                                        from fst111
                                                       Where Dscod = 50
                                                         and Modulo <> 29
                                                         and Modulo <> 120
                                                         and Modulo <> 144)
                                     and substr(rubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426))
                     and f.BCCTA  = ln_CTA             
                     and f.BCOPER = ln_OPE 
                     and f.bcmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300)--en la uía esta los módulos qeu no se debenconsiderar
                     and f.bcsdmo < 0
                     and f.bcprod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                     and rownum = 1; 

                    exception 
                    when  no_data_found then
                      ln_CTA:=0;
                      ln_OPE:=0;            
                    end ;
                 end if;
         
                
                if (ln_CTA<>0 ) then -- solo aquellos que están activos procederá a calcular sus controles
                  ---07/10/2020 kdvc
                  --DBMS_OUTPUT.PUT_LINE(ln_CTA||'-'||ln_OPE);
                  lc_Contabilizar := 'S';                                 
              /*    lc_TieneReduccion := fn_TieneReduccionCuota(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, pd_fechaProg);
                  
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotas :=   fn_PagoCuotas(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, pd_fechaProg, pd_fecha);   
                  else
                      ln_NunCuotas :=   fn_PagoCuotasAtras(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, pd_fechaProg, pd_fecha); 
                  end if;
                  lc_PagoCapital :=   fn_PagoCapital(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ln_scsdo, pd_fechaProg);
                  ln_Periocidad :=   fn_periocidad(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE); 
                  if ( ln_Periocidad <= 30 ) then --si tienen periocidad mensual entonces
                      if ( lc_TieneReduccion ='N' ) then
                        if ( ln_NunCuotas >=6 ) then -- si no tienen reduccion de cuota y si pagó mas de 6 cuotas consecutivas
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      else --si tiene reduccion de cuota
                        if ( ln_NunCuotas >=6  and lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      end if;
                   else
                     if ( ln_NunCuotas >=6 or  lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital  --and  12012020
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                     end if;
                   end if;
                   if (ln_MOD =108) then --si es crédito prendario
                       lc_Contabilizar := 'S';                
                   end if;
                   */                                                                                                                
                  ---07/10/2020 kdvc 
                   begin
                     ln_esta := 0;             
                   select count(*) into ln_esta from aqpa830 where aqpa830cta=ln_CTA and aqpa830ope=ln_OPE and aqpa830sbo=ln_SBO;
                   exception 
                     when no_data_found then
                       ln_esta := 0;
                   end;
                   if( ln_esta = 0) then
                    insert into aqpa830
                      (AQPA830FEP, 
                       AQPA830EMP,
                       AQPA830MOD, 
                       AQPA830SUC, 
                       AQPA830MDA, 
                       AQPA830PAP, 
                       AQPA830CTA, 
                       AQPA830OPE, 
                       AQPA830SBO, 
                       AQPA830TPO, 
                       AQPA830TDOC,
                       AQPA830NDOC,
                       AQPA830MTO, 
                       AQPA830TIP, 
                       AQPA830PDI, 
                       AQPA830SOL, 
                       AQPA830RER, 
                       AQPA830EXT, 
                       AQPA830CON, 
                       AQPA830FECE,
                       AQPA830TABO,
                       AQPA830FECACT,
                       AQPA830USUACT,
                       AQPA830est,
                       AQPA830SAlACT--,--estado  07/10/2020
                      -- AQPA830REDCUO, --'s' si tiene reducción de cuota 07/10/2020
                      -- AQPA830NUMCUOP, --número de cuotas pagadas puntualmente desde la fecha reprogramada x covid  07/10/2020
                      -- AQPA830PAGCAP, --'s' si pago el 20% de capital  07/10/2020
                      -- AQPA830PERIO --periocidad del crédito  07/10/2020
                      -- AQPA830CUOACT,
                      -- AQPA830CUOANT,
                      -- AQPA830SALACT
                       )           
                    VALUES
                      ( ln_fecha,           
                       ln_EMP,
                       ln_MOD,
                       ln_SUC,
                       ln_MDA,
                       ln_PAP,
                       ln_CTA,
                       ln_OPE,
                       ln_SBO,
                       ln_TOP,
                       a.petdoc,
                       a.pendoc,
                       a.monto,
                       a.tipo, 
                       a.pdi, 
                       a.solicito, 
                       a.rere, 
                       a.extorno, 
                       a.con_cptlzcn, 
                       a.fec_extorno,
                       a.tabla_origen,
                       pd_fecha,
                       pd_usuario,
                       lc_Contabilizar,
                       ln_scsdo --kvalenciac  13/01/2023
                       --lc_TieneReduccion,
                      -- ln_NunCuotas,  
                      --- lc_PagoCapital,
                      -- ln_Periocidad--,
                      -- fn_CuotaActual(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, pd_fechaProg),
                      -- fn_CuotaAnterior(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, pd_fechaProg),
                      -- ln_scsdo
                       );
                       commit;
                  end if;
                end if;
          end if;
      end loop;    
  end graba_AQPA830;
procedure inicio_GrabaControl(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number;      
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPA830';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPA830(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPA830');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
             exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
          end;
       Else         
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPA830');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
         /* begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/  --  02/09/2020 kdvc
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPA830', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);  
     While ln_numjob2 > 0 loop
        ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControl;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure control_AQPA830 ( pn_sucursal number, pd_fecha date, pd_usuario char ) is
    cursor listado (ln_suc in number) is
      select *
        from AQPA830
        where 
        aqpa830suc=ln_suc
        and aqpa830est='S'; --los que están en 'N' son los que ya no se deben considerar son los extornados                        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
    ld_fechaProg date;
    ln_NunCuotasTI number;--inicio 28/06/2022 kdvc
Begin  
    pn_emp := 1;  
    
    for b in listado(pn_sucursal) loop
           ln_EMP:= b.aqpa830emp;
           ln_SUC:= b.aqpa830suc;
           ln_MDA:= b.aqpa830mda;
           ln_PAP:= b.aqpa830pap;
           ln_SBO:= b.aqpa830sbo;
           ln_TOP:= b.aqpa830tpo;
           ln_MOD:= b.aqpa830mod;
           ln_CTA:= b.aqpa830cta;
           ln_OPE:= b.aqpa830ope;
           ld_fechaProg:=b.aqpa830fep;
           ln_scsdo:=b.aqpa830salact;  --kvalenciac  13/01/2023
           lc_Contabilizar := 'S';        
                  lc_TieneReduccion := fn_TieneReduccionCuota(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg);
                 /* 
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotasTI :=   fn_PagoCuotas(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha);  --antes era ln_NunCuotas 28/06/2022 kdvc  
                  else
                      ln_NunCuotasTI :=   fn_PagoCuotasAtras(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha); --antes era ln_NunCuotas 28/06/2022 kdvc
                  end if;*/
                  --inicio 28/06/2022 kvalenciac
                  /*if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_N(ld_fechaProg,pd_fecha, ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                             
                  else
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_S(pd_fecha,ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                           
                  end if;*/ --comentado el  21/08/2024 kvalenciac
                  --fin 28/06/2022 kvalenciac
                  --inicio 21/08/2024 kvalenciac
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_N_v3(ld_fechaProg,pd_fecha, ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                             
                  else
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_S_v3(pd_fecha,ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                           
                  end if;
                  --fin 21/08/2024 kvalenciac                 
                  lc_PagoCapital :=   fn_PagoCapital(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ln_scsdo, ld_fechaProg);
                  ln_Periocidad :=   fn_periocidad(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE); 
                  --inicio 21/08/2024 kvalenciac
                  if ( ln_Periocidad > 30 ) then                     
                   ln_NunCuotas :=  fn_num_cuopa_peri_may_30(ld_fechaProg,pd_fecha, ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                             
                  end if;
                  --fin 21/08/2024 kvalenciac
                  if ( ln_Periocidad <= 30 ) then --si tienen periocidad mensual entonces
                      if ( lc_TieneReduccion ='N' ) then
                        if ( ln_NunCuotas >=6 ) then -- si no tienen reduccion de cuota y si pagó mas de 6 cuotas consecutivas
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      else --si tiene reduccion de cuota
                        if ( ln_NunCuotas >=6  and lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      end if;
                   else
                     if ( ln_NunCuotas >=6 or  lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital  --and  12012020
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                     end if;
                   end if;
                   if (ln_MOD =108) then --si es crédito prendario
                       lc_Contabilizar := 'S';                
                   end if;
                                   
                   update aqpa830 set                                            
                       AQPA830est = lc_Contabilizar,--estado  07/10/2020
                       AQPA830REDCUO = lc_TieneReduccion, --'s' si tiene reducción de cuota 07/10/2020
                       AQPA830NUMCUOP = ln_NunCuotas, --número de cuotas pagadas puntualmente desde la fecha reprogramada x covid  07/10/2020
                       AQPA830PAGCAP = lc_PagoCapital, --'s' si pago el 20% de capital  07/10/2020
                       AQPA830PERIO = ln_Periocidad, --periocidad del crédito  07/10/2020  
                       AQPA830NUMCUOPTI = ln_NunCuotasTI -- 28/06/2022 kdvc                               
                   where AQPA830EMP = ln_EMP
                       and AQPA830MOD = ln_MOD 
                       and AQPA830SUC = ln_SUC 
                       and AQPA830MDA = ln_MDA 
                       and AQPA830PAP = ln_PAP 
                       and AQPA830CTA = ln_CTA 
                       and AQPA830OPE = ln_OPE
                       and AQPA830SBO = ln_SBO 
                       and AQPA830TPO = ln_TOP;
                   commit;
                  
      end loop;    
  end control_AQPA830;

 ------------------------------------------------------ función si tiene reducción de cuota comparandola con la cuota del crédito antes de refinanciar
 Function fn_TieneReduccionCuota(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pd_fecha in date) return character is                                                                                               
    ln_contador char(1) ; 
    ln_cuotaactual number(17,2) := 0;
    ln_cuotaanterior number(17,2) := 0; 
    ld_fecmin date; 
    ln_monto1 number;
    ln_monto2 number;
    ld_fecmin2 date; 
    ln_monto12 number;
    ln_monto22 number;
    ln_sbo  number;
  begin  
    --inicio kdvc 04/01/2021
      begin
        select min(f.ppfpag) into ld_fecmin from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP 
          and f.ppfpag > pd_fecha 
          and pptipo<>'K'
          and ppcap+ppint <> 0;--costo 4
      exception
      when no_data_found then 
            ld_fecmin := null;
      end;
      begin
        select ppcap+ppint into ln_monto1 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA
          and f.ppoper=pn_Oper
          and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP
          and f.ppfpag=ld_fecmin
          and pptipo<>'K'
          and ppcap+ppint <> 0 ;--costo5 
       exception
      when others then 
            ln_monto1 := 0;
      end;
      begin    
        select ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 into  ln_monto2 from fsd611 s 
          where s.pgcod =pn_EMP
            and s.ppmod =pn_MOD
            and s.ppsuc =pn_SUC
            and s.ppmda =pn_MDA
            and s.pppap =pn_PAP
            and s.ppcta =pn_CTA
            and s.ppoper=pn_Oper
            and s.ppsbop=pn_SBO
            and s.pptope=pn_TOP
            and s.ppfpag=ld_fecmin
            and pptipo<>'K'
            and rownum = 1;--costo 5
       exception
       when others then 
            ln_monto2 := 0;
       end;
       ln_cuotaactual := ln_monto1 + ln_monto2;
       --fin kdvc 04/01/2021
    /*
       --costo18 --bajo a 9
       begin      
      select ppcap+ppint+ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 into ln_cuotaactual
      from fsd601 f
      inner join fsd611 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.ppmda and s.ppcta=f.ppcta and s.ppoper=f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag and s.pptipo =f.pptipo
      where f.PGCOD =  pn_EMP
       and  f.PPMOD =  pn_MOD
       and  f.PPSUC =  pn_SUC
       and  f.PPMDA =  pn_MDA
       and  f.PPPAP =  pn_PAP
       and  f.PPCTA  = pn_CTA
       and  f.PPOPER = pn_Oper
       and  f.PPSBOP = pn_SBO
       and  f.PPTOPE = pn_TOP
       and ppcap+ppint <> 0
       and rownum=1
       order by f.ppfpag;
    exception
      when no_data_found then 
            ln_cuotaactual := 0;
    end;
    */
    --inicio kdvc 04/01/2021
     begin
        select /*+index(F FSD60103)*/ min(f.ppsbop) into ln_sbo from fsd601 f --04.08.2021
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          --and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          --and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP 
          and f.ppfpag >= to_date('01/02/2020','dd/mm/yyyy')
          and f.pptipo<>'K'
          and f.ppcap+f.ppint <> 0; --costo 5                         
      exception
      when no_data_found then 
            ln_sbo := 0;
      end;
      begin
        select min(f.ppfpag) into ld_fecmin2 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          and f.ppsbop=ln_sbo
          and f.pptope=pn_TOP 
          and f.ppfpag >=  to_date('01/02/2020','dd/mm/yyyy')--'01/02/2020'
          and f.pptipo<>'K'
          and ppcap+ppint <> 0;--costo 5
      exception
      when no_data_found then 
            ld_fecmin2 := null;
      end;
      begin
        select ppcap+ppint into ln_monto12 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA
          and f.ppoper=pn_Oper
          and f.ppsbop=ln_sbo
          and f.pptope=pn_TOP
          and f.ppfpag=ld_fecmin2
          and f.pptipo<>'K'
          and ppcap+ppint <> 0;--costo4 
       exception
      when no_data_found then 
            ln_monto12 := 0;
      end;
      begin    
        select ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 into  ln_monto22 from fsd611 s 
        where s.pgcod =pn_EMP
          and s.ppmod =pn_MOD
          and s.ppsuc =pn_SUC
          and s.ppmda =pn_MDA
          and s.pppap =pn_PAP
          and s.ppcta =pn_CTA
          and s.ppoper=pn_Oper
          and s.ppsbop=ln_sbo
          and s.pptope=pn_TOP
          and s.ppfpag=ld_fecmin2
          and s.pptipo<>'K'
           and rownum = 1;--costo 5
       exception
       when no_data_found then 
            ln_monto22 := 0;
       end;
       ln_cuotaanterior := ln_monto12 + ln_monto22;
       --fin kdvc 04/01/2021
  /*   begin
     --costo es 27  bajo a 10
      select importe into ln_cuotaanterior
       from (
      select ppcap+ppint+ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 as importe, f.*  
              from fsd601 f
              inner join fsd611 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.ppmda and s.ppcta=f.ppcta and s.ppoper=f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag
              where f.PGCOD =  pn_EMP
               and  f.PPMOD =  pn_MOD
               and  f.PPSUC =  pn_SUC
               and  f.PPMDA =  pn_MDA
               and  f.PPPAP =  pn_PAP
               and  f.PPCTA  = pn_CTA
               and  f.PPOPER = pn_Oper
               --and  f.PPSBOP = pn_SBO --se comentó para obtener la primera cuota desde la primera reprogramación que tuvo desde depués del 1 de febrero
               and  f.PPTOPE = pn_TOP
               and  f.ppcap+f.ppint <> 0
               and  f.ppfpag >= TO_DATE('01012020','DDMMYYYY')                
               order by f.ppfpag)
               where rownum=1;
    exception
      when no_data_found then 
           ln_cuotaanterior := ln_cuotaactual;
    end;  */
    if ( ln_cuotaactual < ln_cuotaanterior ) then  --si es si entonces si hay disminución de cuota
      ln_contador := 'S';
    else
      ln_contador := 'N';
    end if; 
    return ln_contador;
  end fn_TieneReduccionCuota;
   --como pago puntual: se considera el pago realizado hasta con 8 días de atraso
 Function fn_PagoCuotas(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pd_fechaRepro in date, pd_fecha in date) return number is                                                                                               
    ln_cuotas number(3) := 0; 
    ln_encontro number(1) := 0;
    ld_ppfpag_ant date;
    ln_contador number(2):=0;
    ld_minimafec date;
    ld_diasatraso number(3):=0;
    cursor cuotas (ld_fec in date) is
     select s.*  --costo 24  --bajo a 8
      from fsd601 f
      inner join fsd602 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.pppap and s.ppcta=f.ppcta and s.ppoper= f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag and s.pptipo=f.pptipo
              where f.PGCOD =  pn_EMP
               and  f.PPMOD =  pn_MOD
               and  f.PPSUC =  pn_SUC
               and  f.PPMDA =  pn_MDA
               and  f.PPPAP =  pn_PAP
               and  f.PPCTA  = pn_CTA
               and  f.PPOPER = pn_Oper
               and  f.PPSBOP = pn_SBO
               and  f.PPTOPE = pn_TOP              
               and s.d602fc > ld_fec and f.ppfpag <= pd_fecha--ld_fec ->fecha del primer dia del mes de su cuota; pd_fecha=fecha de ejecución   
               and f.pptipo <>'K'
               and  f.ppcap+f.ppint <> 0
               and s.pp1stat ='T'                                                                    
              and s.d602co='S'
              order by f.ppfpag ;     
  begin
    begin
     select min(f.ppfpag) into ld_minimafec --costo 24  --bajo a 8
      from fsd601 f
      inner join fsd602 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.pppap and s.ppcta=f.ppcta and s.ppoper= f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag and s.pptipo=f.pptipo
              where f.PGCOD =  pn_EMP
               and  f.PPMOD =  pn_MOD
               and  f.PPSUC =  pn_SUC
               and  f.PPMDA =  pn_MDA
               and  f.PPPAP =  pn_PAP
               and  f.PPCTA  = pn_CTA
               and  f.PPOPER = pn_Oper
               and  f.PPSBOP = pn_SBO
               and  f.PPTOPE = pn_TOP
               and f.ppfpag >= pd_fechaRepro             
               and f.pptipo <>'K'
               and  f.ppcap+f.ppint <> 0
               and s.pp1stat ='T'                                                                    
               and s.d602co='S'            
              order by f.ppfpag;
    end; 
    select last_day(add_months(trunc(ld_minimafec), -1))
      into ld_minimafec
      from dual;
    for a in cuotas(pd_fechaRepro) loop --ld_minimafec) loop  28/01/2022  kdvc
      ln_encontro:=0;
      begin 
        select 1 into ln_encontro
               from fst098 
               where pgcod=1 
                 and tpcod=7746 
                 and tpcorr >801
                 and tpnro = a.d602mo
                 and tpimp = a.d602tr;
       exception
       when no_data_found then 
           ln_encontro := 0;
       end;
       if ( ld_ppfpag_ant <> a.ppfpag  or ln_contador=0 ) then 
         /*if ( ln_encontro = 0 ) then
           if (to_char(a.ppfpag, 'MMYYYY') = to_Char(a.d602fc,'MMYYYY')) then
             if ( a.ppfpag +8 > a.d602fc ) then -- a.d602fc- pp1fech(fsd602) es la fecha de pago y ppfpag(fsd602) es la fecha que se debe pagar la cuota --  antes estaba así <  -- kdvc 04/01/2021
                 ln_cuotas := ln_cuotas +1;
             else
                 ln_cuotas := 0;
             end if;
           end if;
         else
           ln_cuotas := 0;
           --  DBMS_OUTPUT.PUT_LINE(a.d602mo||'-'||a.d602tr);
         end if;*/
         --inicio modificación   27/05/2021
           if ( ln_encontro = 0 ) then --aunque en la guía ya no va a ver registro de ninguna transacción a exonerar por eso toadas las cuotas ingresaran
               if ( a.d602fc < a.ppfpag   ) then --si es cuota adelantada. Ya en el cursor de arriba solo filtra las cuotas cuya fecha de cuota sea menor a la fecha de ejecución
                   ln_cuotas := ln_cuotas +1;
               else                 
                 if (to_char(a.ppfpag, 'MMYYYY') = to_Char(a.d602fc,'MMYYYY')) then --si se hizo el pago en el mismo mes de la fecha de cuota entonces también es pago puntual porque los días de atraso solo se considera cuando no pago en el mes
                   ln_cuotas := ln_cuotas +1;
                 else
                   ld_diasatraso:=0;
                   --verificar que tenga solo 8 días de atraso al cierre de periodo del mes de la cuota
                   select last_day(trunc(a.ppfpag))- a.ppfpag --last_day(trunc(a.ppfpag))=> último dia del mes menos la fecha de la cuota
                   into ld_diasatraso
                   from dual;--obtengo los días del atraso al mes
                   if (ld_diasatraso<=8) then
                     ln_cuotas := ln_cuotas +1;
                   else
                     ln_cuotas := 0;
                   end if;
                 end if;
               end if;
           else
             ln_cuotas := 0;
           --  DBMS_OUTPUT.PUT_LINE(a.d602mo||'-'||a.d602tr);
           end if;
           --fin modificación   27/05/2021
        end if;
        ld_ppfpag_ant := a.ppfpag;     
        ln_contador := ln_contador+1;
        if (ln_cuotas = 6 ) then
          exit;
        end if; 
    end loop;     
    return ln_cuotas;
  end fn_PagoCuotas;
------------------------------------------------------------
Function fn_PagoCuotasAtras(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pd_fechaRepro in date, pd_fecha in date) return number is                                                                                               
        ln_cuotas number(3) := 0; 
    ln_encontro number(1) := 0;
    ld_ppfpag_ant date;
    ln_contador number(2):=0;
    ld_minimafec date;
    ld_fec date;
    ld_diasatraso number(3):=0;
    cursor cuotas (ld_fec in date) is
     select s.*  --costo 24  --bajo a 8
      from fsd601 f
      inner join fsd602 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.pppap and s.ppcta=f.ppcta and s.ppoper= f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag and s.pptipo=f.pptipo
              where f.PGCOD =  pn_EMP
               and  f.PPMOD =  pn_MOD
               and  f.PPSUC =  pn_SUC
               and  f.PPMDA =  pn_MDA
               and  f.PPPAP =  pn_PAP
               and  f.PPCTA  = pn_CTA
               and  f.PPOPER = pn_Oper
               and  f.PPSBOP = pn_SBO
               and  f.PPTOPE = pn_TOP              
               and s.d602fc > ld_fec and f.ppfpag <= pd_fecha-- pd_fecha--> fecha ejecución ld_fec-->fecha tope desde donde se considerará pd_fecha-6 meses 
               and f.pptipo <>'K'
               and  f.ppcap+f.ppint <> 0
               and s.pp1stat ='T'                                                                    
              and s.d602co='S'
              order by f.ppfpag desc;     
  begin
    begin
     select min(f.ppfpag) into ld_minimafec --costo 24  --bajo a 8
      from fsd601 f
      inner join fsd602 s on s.pgcod=f.pgcod and s.ppmod=f.ppmod and s.ppsuc=f.ppsuc and s.ppmda=f.ppmda and s.pppap=f.pppap and s.ppcta=f.ppcta and s.ppoper= f.ppoper and s.ppsbop=f.ppsbop and s.pptope=f.pptope and s.ppfpag=f.ppfpag and s.pptipo=f.pptipo
              where f.PGCOD =  pn_EMP
               and  f.PPMOD =  pn_MOD
               and  f.PPSUC =  pn_SUC
               and  f.PPMDA =  pn_MDA
               and  f.PPPAP =  pn_PAP
               and  f.PPCTA  = pn_CTA
               and  f.PPOPER = pn_Oper
               and  f.PPSBOP = pn_SBO
               and  f.PPTOPE = pn_TOP
               and f.ppfpag >= pd_fechaRepro             
               and f.pptipo <>'K'
               and  f.ppcap+f.ppint <> 0
               and s.pp1stat ='T'                                                                    
              and s.d602co='S'
              order by f.ppfpag;
    end;
    select last_day(add_months(trunc(ld_minimafec), -1))
      into ld_minimafec
      from dual;     

    for a in cuotas(pd_fechaRepro) loop --  ld_minimafec) loop  --28/01/2022  kdvc
      select last_day(add_months(trunc(pd_fecha,'MM'),-6)) into ld_fec  from dual;--30/06
      if  ( a.ppfpag > ld_fec ) then
          ln_encontro:=0;
          begin 
            select 1 into ln_encontro
                   from fst098 
                   where pgcod=1 
                     and tpcod=7746 
                     and tpcorr >801
                     and tpnro = a.d602mo
                     and tpimp = a.d602tr;
           exception
           when no_data_found then 
               ln_encontro := 0;
           end;
           if ( ld_ppfpag_ant <> a.ppfpag  or ln_contador=0 ) then 
             /*if ( ln_encontro = 0 ) then
               if (to_char(a.ppfpag, 'MMYYYY') = to_Char(a.d602fc,'MMYYYY')) then
                 if ( a.ppfpag +8 > a.d602fc ) then -- a.d602fc- pp1fech(fsd602) es la fecha de pago y ppfpag(fsd602) es la fecha que se debe pagar la cuota --  antes estaba así <  -- kdvc 04/01/2021
                     ln_cuotas := ln_cuotas +1;
                 else
                     ln_cuotas := 0;
                 end if;
                end if;*/
              if ( ln_encontro = 0 ) then --aunque en la guía ya no va a ver registro de ninguna transacción a exonerar por eso toadas las cuotas ingresaran
               if ( a.d602fc < a.ppfpag   ) then --si es cuota adelantada siempre se considera pero la fecha de la cuota debe ser menor a la fecha de ejecución. Ya en el cursor de arriba solo filtra las cuotas cuya fecha de cuota sea menor a la fecha de ejecución
                   ln_cuotas := ln_cuotas +1;
               else                 
                 if (to_char(a.ppfpag, 'MMYYYY') = to_Char(a.d602fc,'MMYYYY')) then --si se hizo el pago en el mismo mes de la fecha de cuota entonces también es pago puntual porque los días de atraso solo se considera cuando no pago en el mes
                   ln_cuotas := ln_cuotas +1;
                 else
                   ld_diasatraso:=0;
                   --verificar que tenga solo 8 días de atraso al cierre de periodo del mes de la cuota
                   select last_day(trunc(a.ppfpag))- a.ppfpag --last_day(trunc(a.ppfpag))=> último dia del mes menos la fecha de la cuota
                   into ld_diasatraso
                   from dual;--obtengo los días del atraso al mes
                   if (ld_diasatraso<=8) then
                     ln_cuotas := ln_cuotas +1;
                   else
                     ln_cuotas := 0;
                   end if;
                 end if;
               end if;
             else
                ln_cuotas := 0;
               --  DBMS_OUTPUT.PUT_LINE(a.d602mo||'-'||a.d602tr);
              end if;
            end if;
            ld_ppfpag_ant := a.ppfpag;     
            ln_contador := ln_contador+1;
       end if;
       if (ln_cuotas = 6 ) then
          exit;
        end if; 
    end loop;     
    return ln_cuotas;
  end fn_PagoCuotasAtras;

 ------------------------------------------------------función que devuelve 'S' si ya pagó el 20% de capital
   Function fn_PagoCapital(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pn_scsdo in number, pd_fechaProg in date) return character is                                                                                               
    ln_pago char(1);
    ln_porcentaje number(17,2); 
    ln_montoi number(17,2); 
    ln_montop number(17,2); 
    ln_scsdo number(17,2);
    ln_monto20 number(17,2); 
    ld_fechaProg date;
  begin
    ln_pago :='N'; 
    if ( pn_scsdo < 0 ) then   -- inicio 07/01/2020 
      ln_scsdo := pn_scsdo * -1;
    else
      ln_scsdo := pn_scsdo;
    end if;  -- fin 07/01/2020 
    ln_monto20 :=0;
    ld_fechaProg := last_day(pd_fechaProg);
    begin
      select tpimp into ln_porcentaje 
      from fst098 
      where pgcod=1 
      and tpcod=7746 
      and tpcorr =601;
     exception
     when no_data_found then
       ln_porcentaje :=0;
     end;
     begin
   /*  select f.saldo into ln_montoi
       from  jaql114RES--operador.jaql114_12012021 f
       where f.jaql114cta  = pn_CTA
         and f.jaql114oper = pn_Oper         
         and f.jaql114fech  = ld_fechaProg
         and rownum = 1; */
         ----------
       select /*+ ALL_ROWS index(F FSH01204)*/ f.bcsdmo into ln_montoi  --kdvc 30/03/2021 
       from fsh012 f
       where f.BCEMP  = pn_EMP
         and f.BCSUC  = pn_SUC
         and f.BCRUBR in (select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144)
                         and substr(rubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426))
         and f.BCMDA  = pn_MDA
         and f.BCPAP  = pn_PAP 
         and f.BCCTA  = pn_CTA
         and f.BCOPER = pn_Oper 
         and f.BCSBOP = pn_SBO
         and f.BCTOP  = pn_TOP
         and f.BCFECH = ld_fechaProg
         and rownum = 1;      
      exception
        when no_data_found then           
                 ln_montoi := 0;            
      end;
      if (ln_montoi<0) then
          ln_montoi := ln_montoi * -1;
      end if;
      ln_montop := ln_montoi - ln_scsdo; -- obtengo el monto pagado resto el monto de la solicitud menos el saldo actual      
      ln_monto20 := (ln_montoi * ln_porcentaje) / 100;--obtengo el 20% del monto de la  solicitud de la reprorgramacion   -- 07/01/2020 
      
      if ( ln_montop > ln_monto20) then --si el monto pagado es mayor al 20% del total
        ln_pago:= 'S';        
      end if;
    return ln_pago;
  end fn_PagoCapital;  
  ------------------------------------------------------función que devuelve 1 si su periocidad es mensual si no lo es entonces devuleve 07
  Function fn_periocidad(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number) return number is                                                                                                   
    ln_periodo number(5) := 0;   
   begin 
    ln_periodo := 0;
     begin  
       --costo 3
       /* select xllperiodo into ln_periodo
        from x054023
        where  xllpgcod  =  pn_EMP
           and xllaomod  =  pn_MOD
           and xllaosuc  =  pn_SUC
           and xllaomda  =  pn_MDA
           and xllaopap  =  pn_PAP
           and xllaocta  =  pn_CTA
           and xllaooper =  pn_Oper
           and xllaosbop =  pn_SBO
           and xllaotop  =  pn_TOP;*/
         select  d.aoperiod into ln_periodo
         from fsd010 d
                  where   d.pgcod=pn_EMP
                      and d.aomod=pn_MOD
                      and d.aosuc=pn_SUC
                      and d.aomda=pn_MDA
                      and d.aopap=pn_PAP
                      and d.aocta=pn_CTA
                      and d.aooper=pn_Oper
                      and d.aosbop=pn_SBO
                      and d.aotope=pn_TOP ;
      exception
      when no_data_found then 
           ln_periodo := 0;
      end;
     /*if ( ln_periodo = 30 ) then  -- si es mensual
       ln_mensual := 1;
     else
       ln_mensual := 0;
     end if;*/
    return ln_periodo; --devuelve 1 si es de periocidad mensual y 0 si no lo es
   end fn_periocidad;
 ------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------
  procedure inicio(pd_fecha date) is
    ln_cta     number(9);
    lc_variable   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number;      
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
        
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete aqpb005 where aqpb005fep = pd_fecha;
    commit;
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');
    ----------------------------------------------
    ln_job1        := 0;
    for a in sucursal loop   
      ln_cta :=  a.sucurs;       
      ln_job1        := ln_job1 + 1;
      lc_prefjob1    := 'CTAORD';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                   'AQPB' || to_char(ln_job1); ---  nombre del job
                  
      lc_variable := 'begin ' ||
                   ' pq_cr_repro_procdiario.proceso_flujo1(' ||
                   a.sucurs 
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD'') ); ' || ' End;';
      
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Cuentas_Orden');
          begin
            --dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
             exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
          end;
       Else
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Cuentas_Orden');
          /*begin
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, n_Numer1, c_detjob)
      VALUES
          ('CTAORD', ln_cta, lc_variable);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);  
     While ln_numjob1 > 0 loop
        ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);
     End loop;

 end inicio;
 
procedure proceso_flujo1(pn_SUC  number, pd_fecha date) is
  lc_estado   varchar2(1); 
  cursor creditos (ln_sucur in number) is
      select *
        from aqpa830 a
       where a.aqpa830suc = ln_sucur;
      -- and AQPA830est = 'S' ; -- 31/12/2020-- solo a los que tienen el indicador de contabiizar se le debe busccar sus movimientos de incrementos y decrementos si tienen N no se debe contabilizar porque no cumple con los cirterios
 begin 
   for a  in creditos(pn_Suc)  loop
       lc_estado:=a.aqpa830est;
       if (lc_estado='S') then
           pq_cr_repro_procdiario.proceso_diario(a.aqpa830emp,
                                                a.aqpa830mda,
                                                a.aqpa830pap,
                                                a.aqpa830cta,
                                                a.aqpa830ope,
                                                a.aqpa830sbo,
                                                pd_fecha);
        end if;
   end loop;
   
end proceso_flujo1; 

procedure proceso_diario(pn_EMP   number,                          
                           pn_MDA   number,
                           pn_PAP   number,
                           pn_CTA   number,
                           pn_OPE   number,
                           pn_SBO   number,
                           pd_fecha date) is
                          
    cursor pagos(pln_EMP number,
                 pln_MOD number,
                 pln_SUC number,
                 pln_MDA number,
                 pln_PAP number,
                 pln_CTA number,
                 pln_OPE number,
                 pln_SBO number,
                 pln_TOP number,
                 pln_rub number) is
      select b.*
        from fsd015 a, fsd016 b
       where a.pgcod = b.pgcod
         and a.itsuc = b.itsuc
         and a.itmod = b.itmod
         and a.ittran = b.ittran
         and a.itnrel = b.itnrel
--         and a.itcorr = 0
         and a.itcont in ('S', 'P')
         and b.pgcod =  pln_EMP
         and b.MODULO = pln_MOD
         and b.ITSUCD = pln_SUC
         and b.MONEDA = pln_MDA
         and b.PAPEL =  pln_PAP
         and b.CTNRO =  pln_CTA
         and b.ITOPER = pln_OPE
         and b.ITSUBO = pln_SBO
         and b.ITTOPE = pln_TOP
         and b.RUBRO =  pln_rub 
         and b.itafgt in ('C', 'P')  --kdvc solo los contabilizados
         and a.itfcon = a.itfvc; --este es para solo considerar los contabilizados con fecha valor de la fecha del sistema no otros de otros días
  
    cursor pagosInt(pln_EMP number,
                    pln_MDA number,
                    pln_PAP number,
                    pln_CTA number,
                    pln_OPE number,
                    pln_SBO number) is
      select b.*
        from fsd015 a, fsd016 b
       where a.pgcod = b.pgcod
         and a.itsuc = b.itsuc
         and a.itmod = b.itmod
         and a.ittran = b.ittran
         and a.itnrel = b.itnrel
--         and a.itcorr = 0
         and a.itcont in ('S', 'P')
         and b.pgcod =  pln_EMP
         and b.MONEDA = pln_MDA
         and b.PAPEL =  pln_PAP
         and b.CTNRO =  pln_CTA
         and b.ITOPER = pln_OPE
         and b.ITSUBO = pln_SBO
         and b.RUBRO like '14_8%'
         and b.itafgt in ('C', 'P') --kdvc solo los contabilizados
         and a.itfcon = a.itfvc; --este es para solo considerar los contabilizados con fecha valor de la fecha del sistema no otros de otros días
         
    cursor pagosSus(pln_EMP number,
                    pln_MDA number,
                    pln_PAP number,
                    pln_CTA number,
                    pln_OPE number,
                    pln_SBO number) is
      select b.*
        from fsd015 a, fsd016 b
       where a.pgcod = b.pgcod
         and a.itsuc = b.itsuc
         and a.itmod = b.itmod
         and a.ittran = b.ittran
         and a.itnrel = b.itnrel
--         and a.itcorr = 0
         and a.itcont in ('S', 'P')
         and b.pgcod =  pln_EMP
         and b.MONEDA = pln_MDA
         and b.PAPEL =  pln_PAP
         and b.CTNRO =  pln_CTA
         and b.ITOPER = pln_OPE
         and b.ITSUBO = pln_SBO
         and b.RUBRO like '81_4%'
         and b.itafgt in ('C', 'P')--kdvc solo los contabilizados
         and a.itfcon = a.itfvc; --este es para solo considerar los contabilizados con fecha valor de la fecha del sistema no otros de otros días
  
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);
    ln_rubro   number(16);
    ln_saldo   number(17, 2);
    ln_flag    number(5);
    ln_rubctak number(16);
    ln_rubctaI number(16);
    ln_rubctaS number(16);    
    lv_esta    varchar(1);
  begin
    -- saldo capital    
    ln_flag := 1;
  
    begin
      select pgcod,
             scmod,
             scsuc,
             scmda,
             scpap,
             sccta,
             scoper,
             scsbop,
             sctope,
             scrub,
             scsdo
        into ln_EMP,
             ln_MOD,
             ln_SUC,
             ln_MDA,
             ln_PAP,
             ln_CTA,
             ln_OPE,
             ln_SBO,
             ln_TOP,
             ln_rubro,
             ln_saldo
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scmda = pn_MDA
         and a.scpap = pn_PAP
         and a.sccta = pn_CTA
         and a.scoper = pn_OPE
         and a.scsbop = pn_SBO
         and sctit = 1
         and sccap = 4
         and scplzo in (1, 4, 5, 6)
         and rownum=1; --kdvc 04/09/2020;
    exception
      when others then
        ln_flag := 0;
    end;
    if ln_flag = 1 then
      lv_esta := 'A';
      begin
        select rrrubr
          into ln_rubctaK
          from fsr014
         where rubro = ln_rubro --1411130602005
           and rrcod = 345;
        select rrrubr
          into ln_rubctaI
          from fsr014
         where rubro = ln_rubro --1411130602005 
           and rrcod = 346;
        select rrrubr
          into ln_rubctaS
          from fsr014
         where rubro = ln_rubro --1411130602005
           and rrcod = 347;
      exception
        when others then
          ln_flag := 0;
      end;
      for a in pagos(ln_EMP,
                     ln_MOD,
                     ln_SUC,
                     ln_MDA,
                     ln_PAP,
                     ln_CTA,
                     ln_OPE,
                     ln_SBO,
                     ln_TOP,
                     ln_rubro) loop
       if ( ln_rubctaK<>0 or ln_rubctaK is not null ) then   --kdvc 30/03/2021                  
        Begin
            insert into aqpb005
              (aqpb005fep,
               aqpb005cor,
               aqpb005est,
               aqpb005emp,
               aqpb005mod,
               aqpb005suc,
               aqpb005mda,
               aqpb005pap,
               aqpb005cta,
               aqpb005ope,
               aqpb005sbo,
               aqpb005top,
               aqpb005ruo,
               aqpb005rud,
               aqpb005mto,
               aqpb005bha,
               aqpb005tip)
            VALUES
              (pd_fecha,
               fn_codigo(pd_fecha),
               lv_esta,
               ln_EMP,
               ln_MOD,
               ln_SUC,
               ln_MDA,
               ln_PAP,
               ln_CTA,
               ln_OPE,
               ln_SBO,
               ln_TOP,
               ln_rubro,
               ln_rubctaK,
               a.itimp1,
               a.itdbha,
               'K');
         exception
             when DUP_VAL_ON_INDEX THEN
                 NULL;
         END;
         commit;
        end if ;--kdvc 30/03/2021
      end loop;
      for b in pagosInt(ln_EMP, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO) loop  
       if ( ln_rubctaI<>0 or ln_rubctaI is not null ) then   --kdvc 30/03/2021    
       BEGIN
            insert into aqpb005  --revisar cuando se quiere duplicar el registro verificar la clave de la tabla
              (aqpb005fep,
               aqpb005cor,
               aqpb005est,
               aqpb005emp,
               aqpb005mod,
               aqpb005suc,
               aqpb005mda,
               aqpb005pap,
               aqpb005cta,
               aqpb005ope,
               aqpb005sbo,
               aqpb005top,
               aqpb005ruo,
               aqpb005rud,
               aqpb005mto,
               aqpb005bha,
               aqpb005tip)
            VALUES
              (pd_fecha,
               fn_codigo(pd_fecha), --ln_cont,
               lv_esta,
               ln_EMP,
               ln_MOD,
               ln_SUC,
               ln_MDA,
               ln_PAP,
               ln_CTA,
               ln_OPE,
               ln_SBO,
               ln_TOP,
               b.rubro,
               ln_rubctaI,
               b.itimp1,
               b.itdbha,
               'I');
         exception
             when DUP_VAL_ON_INDEX THEN
                 NULL;
         END;
         commit;
         end if ;--kdvc 30/03/2021
      end loop;
      for c in pagosSus(ln_EMP, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO) loop
       if ( ln_rubctaS<>0 or ln_rubctaS is not null ) then   --kdvc 30/03/2021 
       BEGIN
        insert into aqpb005
          (aqpb005fep,
           aqpb005cor,
           aqpb005est,
           aqpb005emp,
           aqpb005mod,
           aqpb005suc,
           aqpb005mda,
           aqpb005pap,
           aqpb005cta,
           aqpb005ope,
           aqpb005sbo,
           aqpb005top,
           aqpb005ruo,
           aqpb005rud,
           aqpb005mto,
           aqpb005bha,
           aqpb005tip)
        VALUES
          (pd_fecha,
           fn_codigo(pd_fecha),
           lv_esta,
           ln_EMP,
           ln_MOD,
           ln_SUC,
           ln_MDA,
           ln_PAP,
           ln_CTA,
           ln_OPE,
           ln_SBO,
           ln_TOP,
           c.rubro,
           ln_rubctaS,
           c.itimp1,
           c.itdbha,
           'S');
         exception
             when DUP_VAL_ON_INDEX THEN
                 NULL;
         END;
         commit;
         end if ;--kdvc 30/03/2021
      end loop;     
    end if;    
  end proceso_diario;
 ------------------------------------------------------
 Function fn_codigo(pd_fecha in date) return number is                                
    ln_contador number(9) := 0;   
  begin  
    begin
      select nvl(max(aqpb005cor), 0)
      into ln_contador
      from aqpb005
      where aqpb005fep = pd_fecha;
    exception
      when no_data_found then
        ln_contador := 0;
    end;  
    ln_contador := ln_contador + 1;
    return ln_contador;
  end fn_codigo;
  -------------------------------------------------------------------------------------------------
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number is
                                --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    ln_numjob number(9) := 0;
    lc_nomusr varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    begin
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea;
-------------------------------------------------------------------------------------------------
  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number is
                                
    ln_numjob number(9) := 0;
    lc_nomusr varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; 
    end;
  
    begin
    select count(1) 
    into ln_numjob
    from dba_jobs
    where schema_user=lc_nomusr 
    AND upper(what) LIKE P_C_NOMJOB || '%'; --kvalenciac  15/05/2023       se cambio a para que coloque el nombre enviado al proceso     

    end;
  
    return ln_numjob;
end fn_cr_verifica_tarea2; 
  
  
 Function fn_CuotaActual(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pd_fecha in date) return number is                                                                                               
    ln_contador char(1) ; 
    ln_cuotaactual number(17,2) := 0;
    ln_cuotaanterior number(17,2) := 0; 
    ld_fecmin date; 
    ln_monto1 number;
    ln_monto2 number;
    ld_fecmin2 date; 
    ln_monto12 number;
    ln_monto22 number;
    ln_sbo  number;
  begin  
    --inicio kdvc 04/01/2021
      begin
        select min(f.ppfpag) into ld_fecmin from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP 
          and pptipo<>'K'
          and ppcap+ppint <> 0;--costo 4
      exception
      when no_data_found then 
            ld_fecmin := null;
      end;
      begin
        select ppcap+ppint into ln_monto1 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA
          and f.ppoper=pn_Oper
          and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP
          and f.ppfpag=ld_fecmin
          and pptipo<>'K'
          and ppcap+ppint <> 0 ;--costo5 
       exception
      when no_data_found then 
            ln_monto1 := 0;
      end;
      begin    
      select ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 into  ln_monto2 from fsd611 s 
        where s.pgcod =pn_EMP
          and s.ppmod =pn_MOD
          and s.ppsuc =pn_SUC
          and s.ppmda =pn_MDA
          and s.pppap =pn_PAP
          and s.ppcta =pn_CTA
          and s.ppoper=pn_Oper
          and s.ppsbop=pn_SBO
          and s.pptope=pn_TOP
          and s.ppfpag=ld_fecmin
          and pptipo<>'K';--costo 5
       exception
       when no_data_found then 
            ln_monto2 := 0;
       end;
       ln_cuotaactual := ln_monto1 + ln_monto2;
       return ln_cuotaactual;
 end fn_CuotaActual; 
 Function fn_CuotaAnterior(pn_EMP in number, pn_SUC in number, pn_MDA in number, pn_PAP in number,pn_SBO in number,pn_TOP in number, pn_MOD in number,pn_CTA in number, pn_Oper in number, pd_fecha in date) return number is                                                                                               
    ln_contador char(1) ; 
    ln_cuotaactual number(17,2) := 0;
    ln_cuotaanterior number(17,2) := 0; 
    ld_fecmin date; 
    ln_monto1 number;
    ln_monto2 number;
    ld_fecmin2 date; 
    ln_monto12 number;
    ln_monto22 number;
    ln_sbo  number;
  begin  
   begin
        select min(f.ppsbop) into ln_sbo from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          --and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          --and f.ppsbop=pn_SBO
          and f.pptope=pn_TOP 
          and f.ppfpag > '01/02/2020'
          and f.pptipo<>'K'
          and f.ppcap+f.ppint <> 0; --costo 5                         
      exception
      when no_data_found then 
            ln_sbo := 0;
      end;
      begin
        select min(f.ppfpag) into ld_fecmin2 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA 
          and f.ppoper=pn_Oper 
          and f.ppsbop=ln_sbo
          and f.pptope=pn_TOP 
          and f.ppfpag > '01/02/2020'
          and f.pptipo<>'K'
          and ppcap+ppint <> 0;--costo 5
      exception
      when no_data_found then 
            ld_fecmin2 := null;
      end;
      begin
        select ppcap+ppint into ln_monto12 from fsd601 f 
        where f.pgcod =pn_EMP
          and f.ppmod =pn_MOD
          and f.ppsuc =pn_SUC
          and f.ppmda =pn_MDA
          and f.pppap =pn_PAP
          and f.ppcta =pn_CTA
          and f.ppoper=pn_Oper
          and f.ppsbop=ln_sbo
          and f.pptope=pn_TOP
          and f.ppfpag=ld_fecmin2
          and f.pptipo<>'K'
          and ppcap+ppint <> 0;--costo4 
       exception
      when no_data_found then 
            ln_monto12 := 0;
      end;
      begin    
        select ppimp11+ppimp12+ppimp13+ppimp14+s.ppimp15 into  ln_monto22 from fsd611 s 
        where s.pgcod =pn_EMP
          and s.ppmod =pn_MOD
          and s.ppsuc =pn_SUC
          and s.ppmda =pn_MDA
          and s.pppap =pn_PAP
          and s.ppcta =pn_CTA
          and s.ppoper=pn_Oper
          and s.ppsbop=ln_sbo
          and s.pptope=pn_TOP
          and s.ppfpag=ld_fecmin2
          and s.pptipo<>'K';--costo 5
       exception
       when no_data_found then 
            ln_monto22 := 0;
       end;
       ln_cuotaanterior := ln_monto12 + ln_monto22;
       return ln_cuotaanterior;
 end fn_CuotaAnterior; 
 
  
procedure inicio_graba2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number; 
     x number;     
job_id        number;     
    cursor fecha (ld_fecha in date) is
    select fecha_reprogramacion as fec
        --from USRREPBI.REP_TOT_REPRO_2020
        from AQPA833
        where (extorno like 'NO'
        or FEC_EXTORNO=ld_fecha)
        group by fecha_reprogramacion;              
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete aqpa830;
    commit; 
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job1        := 0;
    for a in fecha (pd_fecha) loop         
      lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
      ln_job1        := ln_job1 + 1;
      lc_prefjob1    := 'AQPA830';   --  prefijo del nombre
      pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                   'N' || to_char(ln_job1); ---  nombre del job
                  
      lc_variable1 := 'begin ' ||
                   ' pq_cr_repro_procdiario.graba_AQPA830(' 
                   || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
        if SYS.FN_BD_ISRAC = 'TRUE' THEN
--      if n_inst in (1,2) then   --02/09/2020 kdvc
/*          dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable1,
                                    start_date => \*SYSTIMESTAMP,*\sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Carga_AQPA830');*/
dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              instance  => 2,
                              force     => false);
                                                
/*          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
          end;*/
       Else         
/*          dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable1,
                                    start_date => \*SYSTIMESTAMP,*\sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Carga_AQPA830');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
          begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;  --  02/09/2020 kdvc*/
dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);
      End If;
      commit;
       select count(*) 
              into x
--              from dba_scheduler_jobs 
from dba_jobs
--              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPA83%';
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPA83%';              
            end loop;
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('AQPA830', lc_fec, lc_variable1);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);  
     While ln_numjob1 > 0 loop
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);
     End loop;

      DELETE FROM AQPA830
      WHERE rowid not in
      (SELECT MAX(rowid)--MIN
      FROM AQPA830
      GROUP BY aqpa830cta,aqpa830ope);--aqpa830sbo
      commit;
      begin
         pq_cr_repro_procdiario.inicio_GrabaControl2(pd_fecha, pd_usuario);
      end;
      delete aqpa830b where aqpa830bfecact=pd_fecha;
      commit;
      insert into aqpa830b select * from aqpa830 where aqpa830est='N';
      commit;
end inicio_graba2;
procedure inicio_GrabaControl2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number; 
     x number;     
job_id number;     
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPA830';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPA830(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
--      if n_inst in (1,2) then   --02/09/2020 kdvc
         IF SYS.FN_BD_ISRAC = 'TRUE' THEN
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPA830');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
          end;*/
dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              instance  => 2,
                              force     => false);          
       Else         
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPA830');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
          begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;  --  02/09/2020 kdvc*/

dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);          
      End If;
      commit;
      select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPA83%';                            
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPA83%';                            
            end loop;
            
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPA830', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);  
     While ln_numjob2 > 0 loop
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControl2;
-----------------------Riesgos  inicio cambios 28/06/2022 kvalenciac
function fn_num_cuopa_redcuo_N(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number is

     ln_num_cuop number;
    ln_fecha_min_cupta date;
    Count_CUOP number;
    Local_CUOP number;

     --*********************************************************
      -- Modificacion el 30/06 se agrego cuotas puntuales
      -- and last_day(pp1fech) <= last_day(b.ppfpag)
    --*********************************************************

begin
   begin

       SELECT min(ppfpag)
          into ln_fecha_min_cupta
        from FSD601 b
        where b.Pgcod = v_Pgcod
          and b.Ppmod = v_Scmod
          and b.Ppsuc = v_Scsuc
          and b.Ppmda = v_Scmda
          and b.Pppap = v_Scpap
          and b.Ppcta = v_Sccta
          and b.Ppoper = v_Scoper
          and b.Ppsbop = v_Scsbop
          and b.Pptope = v_Sctope
          --- El pago tiene que ser despues de la reprogramacion
          and b.ppfpag  > v_PgFecha_REprog
          ;

        exception
             when no_data_found then
                  ln_fecha_min_cupta := v_PgFecha_REprog;
              End;

---------------------------------------------------------------------------------

    begin

    Count_CUOP := 0;
    Local_CUOP := 0;

     FOR Pago_Hist IN (
       select
       ppfpag,
       case
         when last_day(pp1fech) <= last_day(ppfpag) then 1
        when  last_day(pp1fech) > last_day(ppfpag)
          and last_day(ppfpag) = last_day(add_months(pp1fech,-1))
           and last_day(ppfpag) - ppfpag  <=8  then 1
         else 0 end flag,
         (select max(q.ri105aux2) from AQPB880 q
          where q.ri105cta=v_Sccta
          and q.ri105oper=v_Scoper
          and q.aqpb880fpr=ppfpag) aux_atra,
       LAG(ppfpag, 1,add_months(ppfpag,-1)) OVER (ORDER BY ppfpag) AS prev_ppfpag
       from (
                     SELECT last_day(ppfpag) ppfpag ,max(pp1fech) pp1fech
                      from FSD602 b
                      where b.Pgcod = v_Pgcod
                        and b.Ppmod = v_Scmod
                        and b.Ppsuc = v_Scsuc
                        and b.Ppmda = v_Scmda
                        and b.Pppap = v_Scpap
                        and b.Ppcta = v_Sccta
                        and b.Ppoper = v_Scoper
                        and b.Ppsbop = v_Scsbop
                        and b.Pptope = v_Sctope
                        and b.Pp1stat = 'T'
                        and b.D602co = 'S'
                        --- El pago tiene que ser despues de la reprogramacion
                       -- and b.pp1fech  <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- La cuota programada tiene que ser despues de la reprogramacion
                        and b.ppfpag   >= ln_fecha_min_cupta
                        and b.ppfpag  <= v_Pgfape
                        --and b.ppfpag   <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- agrego cuotas puntuales
                        -- and last_day(pp1fech) <= last_day(b.ppfpag)
                        group by last_day(ppfpag)
                        ) w
          order by ppfpag
          ) LOOP

         if     ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) and add_months(Pago_Hist.ppfpag,-1)=Pago_Hist.prev_ppfpag)
             or ( Pago_Hist.aux_atra<=8 and add_months(Pago_Hist.ppfpag,-1)=Pago_Hist.prev_ppfpag) then

             Count_CUOP := Count_CUOP + 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);
             
         elsif  ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) )
             or ( Pago_Hist.aux_atra<=8 ) then
             Count_CUOP := 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);  
             
        else
             Count_CUOP := 0;

          end if;

          


     END LOOP;
     end ;
     ln_num_cuop := Local_CUOP;



return ln_num_cuop;

end fn_num_cuopa_redcuo_N;

function fn_num_cuopa_redcuo_S(
                                           v_Pgfape in date, --fecha de proceso
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number is

    ln_num_cuop number;
    Count_CUOP number;
    Local_CUOP number;

     --*********************************************************
      -- Modificacion el 30/06 se agrego cuotas puntuales
      -- and last_day(pp1fech) <= last_day(b.ppfpag)
    --*********************************************************
    

    
begin

    begin

    Count_CUOP := 0;
    Local_CUOP := 0;

     FOR Pago_Hist IN (
       select
       ppfpag,
       case
         when last_day(pp1fech) <= last_day(ppfpag) then 1
        when  last_day(pp1fech) > last_day(ppfpag)
          and last_day(ppfpag) = last_day(add_months(pp1fech,-1))
           and last_day(ppfpag) - ppfpag  <=8  then 1
         else 0 end flag,
         (select max(q.ri105aux2) from AQPB880 q
          where q.ri105cta=v_Sccta
          and q.ri105oper=v_Scoper
          and q.aqpb880fpr=ppfpag) aux_atra
                 from (
                     SELECT last_day(ppfpag) ppfpag ,max(pp1fech) pp1fech
                      from FSD602 b
                      where b.Pgcod = v_Pgcod
                        and b.Ppmod = v_Scmod
                        and b.Ppsuc = v_Scsuc
                        and b.Ppmda = v_Scmda
                        and b.Pppap = v_Scpap
                        and b.Ppcta = v_Sccta
                        and b.Ppoper = v_Scoper
                        and b.Ppsbop = v_Scsbop
                        and b.Pptope = v_Sctope
                        and b.Pp1stat = 'T'
                        and b.D602co = 'S'
                        --- El pago tiene que ser despues de la reprogramacion
                       -- and b.pp1fech  <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- La cuota programada tiene que ser despues de la reprogramacion
                        and b.ppfpag  >= add_months(v_Pgfape,-6)+1
                        and b.ppfpag  <= v_Pgfape
                        --and b.ppfpag   <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- agrego cuotas puntuales
                        -- and last_day(pp1fech) <= last_day(b.ppfpag)
                        group by last_day(ppfpag)
                        ) w
          order by ppfpag
          ) LOOP

         if     ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) ) then

             Count_CUOP := Count_CUOP + 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);

        else
             Count_CUOP := 0;
          end if;

     END LOOP;
     end ;
     ln_num_cuop := Local_CUOP;



return ln_num_cuop;
end fn_num_cuopa_redcuo_S;
---------------fin cambios 28/06/2022 kvalenciac
--inicio 21/08/2024 kvalenciac versión 3 de las funciones de Riesgos pero solo para el proceso de la AQPA830 y AQPA830B
function fn_num_cuopa_redcuo_N_v3(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number is

    ln_num_cuop number;
    ln_fecha_min_cupta date;
    Count_CUOP number;
    Local_CUOP number;

     --*********************************************************
      -- Modificacion el 30/06 se agrego cuotas puntuales
      -- and last_day(pp1fech) <= last_day(b.ppfpag)
    --*********************************************************

   begin
     begin

       SELECT min(ppfpag)
          into ln_fecha_min_cupta
        from FSD601 b
        where b.Pgcod = v_Pgcod
          and b.Ppmod = v_Scmod
          and b.Ppsuc = v_Scsuc
          and b.Ppmda = v_Scmda
          and b.Pppap = v_Scpap
          and b.Ppcta = v_Sccta
          and b.Ppoper = v_Scoper
          and b.Ppsbop = v_Scsbop
          and b.Pptope = v_Sctope
          --- El pago tiene que ser despues de la reprogramacion
          and b.ppfpag  > v_PgFecha_REprog
          ;

        exception
             when no_data_found then
                  ln_fecha_min_cupta := v_PgFecha_REprog;
              End;

---------------------------------------------------------------------------------

    begin

    Count_CUOP := 0;
    Local_CUOP := 0;

     FOR Pago_Hist IN (
       select
       ppfpag,
       case
         when /*last_day(pp1fech) <= last_day(ppfpag) then 1
        when  last_day(pp1fech) > last_day(ppfpag)
          and last_day(ppfpag) = last_day(add_months(pp1fech,-1))
           and*/ pp1fech - ppfpag_ori  <=8  then 1
         else 0 end flag,
         (select max(q.ri105aux2) from AQPB880 q
          where q.ri105cta=v_Sccta
          and q.ri105oper=v_Scoper
          and q.aqpb880fpr=ppfpag) aux_atra,
       LAG(ppfpag, 1,add_months(ppfpag,-1)) OVER (ORDER BY ppfpag) AS prev_ppfpag
       from (
                     SELECT ppfpag ppfpag_ori,last_day(ppfpag) ppfpag ,max(pp1fech) pp1fech
                      from FSD602 b
                      where b.Pgcod = v_Pgcod
                        and b.Ppmod = v_Scmod
                        and b.Ppsuc = v_Scsuc
                        and b.Ppmda = v_Scmda
                        and b.Pppap = v_Scpap
                        and b.Ppcta = v_Sccta
                        and b.Ppoper = v_Scoper
                        and b.Ppsbop = v_Scsbop
                        and b.Pptope = v_Sctope
                        and b.Pp1stat = 'T'
                        and b.D602co = 'S'
                        --- El pago tiene que ser despues de la reprogramacion
                       -- and b.pp1fech  <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- La cuota programada tiene que ser despues de la reprogramacion
                        and b.ppfpag   >= ln_fecha_min_cupta
                        and b.ppfpag  <= v_Pgfape
                        --and b.ppfpag   <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- agrego cuotas puntuales
                        -- and last_day(pp1fech) <= last_day(b.ppfpag)
                        group by last_day(ppfpag), ppfpag
                        ) w
          order by ppfpag
          ) LOOP

         if     ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) and add_months(Pago_Hist.ppfpag,-1)=Pago_Hist.prev_ppfpag)
             or ( Pago_Hist.aux_atra<=8 and add_months(Pago_Hist.ppfpag,-1)=Pago_Hist.prev_ppfpag) then

             Count_CUOP := Count_CUOP + 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);
             
         elsif  ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) )
             or ( Pago_Hist.aux_atra<=8 ) then
             Count_CUOP := 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);               
        else
             Count_CUOP := 0;
          end if;
     END LOOP;
     end ;
     ln_num_cuop := Local_CUOP;
return ln_num_cuop;
end fn_num_cuopa_redcuo_N_v3;
function fn_num_cuopa_redcuo_S_v3(
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number is
    ln_num_cuop number;
    Count_CUOP number;
    Local_CUOP number;
     --*********************************************************
      -- Modificacion el 30/06 se agrego cuotas puntuales
      -- and last_day(pp1fech) <= last_day(b.ppfpag)
    --*********************************************************
begin
---------------------------------------------------------------------------------
    begin
    Count_CUOP := 0;
    Local_CUOP := 0;

     FOR Pago_Hist IN (
       select
       ppfpag,
       case
        when /*last_day(pp1fech) <= last_day(ppfpag) then 1
        when  last_day(pp1fech) > last_day(ppfpag)
          and last_day(ppfpag) = last_day(add_months(pp1fech,-1))
           and*/ pp1fech - ppfpag_ori  <=8  then 1
         else 0 end flag,
         (select max(q.ri105aux2) from AQPB880 q
          where q.ri105cta=v_Sccta
          and q.ri105oper=v_Scoper
          and q.aqpb880fpr=ppfpag) aux_atra
                 from (
                     SELECT ppfpag ppfpag_ori,last_day(ppfpag) ppfpag ,max(pp1fech) pp1fech
                      from FSD602 b
                      where b.Pgcod = v_Pgcod
                        and b.Ppmod = v_Scmod
                        and b.Ppsuc = v_Scsuc
                        and b.Ppmda = v_Scmda
                        and b.Pppap = v_Scpap
                        and b.Ppcta = v_Sccta
                        and b.Ppoper = v_Scoper
                        and b.Ppsbop = v_Scsbop
                        and b.Pptope = v_Sctope
                        and b.Pp1stat = 'T'
                        and b.D602co = 'S'
                        --- El pago tiene que ser despues de la reprogramacion
                       -- and b.pp1fech  <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- La cuota programada tiene que ser despues de la reprogramacion
                        and b.ppfpag  >= add_months(v_Pgfape,-6)+1
                        and b.ppfpag  <= v_Pgfape
                        --and b.ppfpag   <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- agrego cuotas puntuales
                        -- and last_day(pp1fech) <= last_day(b.ppfpag)
                        group by last_day(ppfpag),ppfpag
                        ) w
          order by ppfpag
          ) LOOP

         if     ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) ) then

             Count_CUOP := Count_CUOP + 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);

        else
             Count_CUOP := 0;
          end if;

     END LOOP;
     end ;
     ln_num_cuop := Local_CUOP;
return ln_num_cuop;
end fn_num_cuopa_redcuo_S_v3;
function fn_num_cuopa_peri_may_30(
                                           v_PgFecha_REprog in date, --fecha de reprogramacion
                                           v_Pgfape in date,
                                           v_Pgcod  in number, -- codigo
                                           v_Scmod  in number, -- modulo
                                           v_Scsuc  in number, -- sucursal
                                           v_Scmda  in number, -- moneda
                                           v_Scpap  in number, -- papel
                                           v_Sccta  in number, -- cuenta
                                           v_Scoper in number, -- oper
                                           v_Scsbop in number, -- sub oper
                                           v_Sctope in number  -- tipo oper
                                           ) return number is

    ln_num_cuop number;
    ln_fecha_min_cupta date;
    Count_CUOP number;
    Local_CUOP number;

     --*********************************************************
      -- Modificacion el 30/06 se agrego cuotas puntuales
      -- and last_day(pp1fech) <= last_day(b.ppfpag)
    --*********************************************************

begin
   begin

       SELECT min(ppfpag)
          into ln_fecha_min_cupta
        from FSD601 b
        where b.Pgcod = v_Pgcod
          and b.Ppmod = v_Scmod
          and b.Ppsuc = v_Scsuc
          and b.Ppmda = v_Scmda
          and b.Pppap = v_Scpap
          and b.Ppcta = v_Sccta
          and b.Ppoper = v_Scoper
          and b.Ppsbop = v_Scsbop
          and b.Pptope = v_Sctope
          --- El pago tiene que ser despues de la reprogramacion
          and b.ppfpag  > v_PgFecha_REprog
          ;

        exception
             when no_data_found then
                  ln_fecha_min_cupta := v_PgFecha_REprog;
              End;

---------------------------------------------------------------------------------

    begin

    Count_CUOP := 0;
    Local_CUOP := 0;

     FOR Pago_Hist IN (
       select
       ppfpag,
       case
         when /*last_day(pp1fech) <= last_day(ppfpag) then 1
        when  last_day(pp1fech) > last_day(ppfpag)
          and last_day(ppfpag) = last_day(add_months(pp1fech,-1))
           and*/ pp1fech - ppfpag_ori <=8  then 1
         else 0 end flag,
         (select max(q.ri105aux2) from AQPB880 q
          where q.ri105cta=v_Sccta
          and q.ri105oper=v_Scoper
          and q.aqpb880fpr=ppfpag) aux_atra
                 from (
                     SELECT ppfpag ppfpag_ori ,last_day(ppfpag) ppfpag ,max(pp1fech) pp1fech
                      from FSD602 b
                      where b.Pgcod = v_Pgcod
                        and b.Ppmod = v_Scmod
                        and b.Ppsuc = v_Scsuc
                        and b.Ppmda = v_Scmda
                        and b.Pppap = v_Scpap
                        and b.Ppcta = v_Sccta
                        and b.Ppoper = v_Scoper
                        and b.Ppsbop = v_Scsbop
                        and b.Pptope = v_Sctope
                        and b.Pp1stat = 'T'
                        and b.D602co = 'S'
                        --- El pago tiene que ser despues de la reprogramacion
                       -- and b.pp1fech  <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- La cuota programada tiene que ser despues de la reprogramacion
                        and b.ppfpag   >= ln_fecha_min_cupta
                        and b.ppfpag  <= v_Pgfape
                        --and b.ppfpag   <= add_months(last_day(ln_fecha_min_cupta),6)
                        --- agrego cuotas puntuales
                        -- and last_day(pp1fech) <= last_day(b.ppfpag)
                        group by last_day(ppfpag),ppfpag
                        ) w
          order by ppfpag
          ) LOOP

         if     ( Pago_Hist.flag = 1 and ( Pago_Hist.aux_atra<=8 or Pago_Hist.aux_atra is null) ) then

             Count_CUOP := Count_CUOP + 1;
             Local_CUOP := GREATEST(Count_CUOP,Local_CUOP);
        else
             Count_CUOP := 0;

          end if;




     END LOOP;
     end ;
     ln_num_cuop := Local_CUOP;



return ln_num_cuop;

end fn_num_cuopa_peri_may_30;
--fin 21/08/2024 kvalenciac versión 3 de las funciones de Riesgos pero solo para el proceso de la AQPA830 y AQPA830B
  
----inicio 10/02/2023 kvalenciac
procedure inicio_grabaRE(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number;  
    ln_contador number;    
    cursor fecha (ld_fecha in date) is
    select AQPC433fec as fec
        --from AQPB836
        from AQPC433
        group by AQPC433fec;              
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    ln_contador:=0;
    select count(*) into ln_contador
        --from AQPB836
        from AQPC433;
    if (ln_contador>0) then 
        delete AQPC434;
        commit; 
        lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
        ----------------------------------------------
        ln_job1        := 0;
        for a in fecha (pd_fecha) loop         
          lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
          ln_job1        := ln_job1 + 1;
          lc_prefjob1    := 'AQPC434';   --  prefijo del nombre
          pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                       'N' || to_char(ln_job1); ---  nombre del job
                      
          lc_variable1 := 'begin ' ||
                       ' pq_cr_repro_procdiario.graba_AQPC434(' 
                       || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                       || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
             
          --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
    --    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
          select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
          if n_inst in (1,2) then   --02/09/2020 kdvc
              dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                        job_type   => 'PLSQL_BLOCK',
                                        job_action => lc_variable1,
                                        start_date => sysdate, -- + 1 / (24 * 180),
                                        enabled    => true,
                                        auto_drop  => TRUE,
                                        comments   => 'Carga_AQPC434');
              begin
               -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
                dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
              exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
              end;
           Else         
              dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                        job_type   => 'PLSQL_BLOCK',
                                        job_action => lc_variable1,
                                        start_date => sysdate, -- + 1 / (24 * 180),
                                        enabled    => true,
                                        auto_drop  => TRUE,
                                        comments   => 'Carga_AQPC434');
             --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
             /* begin --  02/09/2020 kdvc
                dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
              end;*/  --  02/09/2020 kdvc
          End If;
          commit;
          
          INSERT INTO Tab_jobs
              (c_codage, c_dato1, c_detjob)
          VALUES
              ('AQPC434', lc_fec, lc_variable1);
          COMMIT;
          
          end loop;
        ------------------Verificaciones que se haya terminado de ejecutar los jobs.
         ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);  
         While ln_numjob1 > 0 loop
            ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname); 
         End loop;

          DELETE FROM AQPC434
          WHERE rowid not in
          (SELECT MAX(rowid)--MIN
          FROM AQPC434
          GROUP BY AQPC434cta,AQPC434ope);--AQPC434sbo
          commit;
          begin
             pq_cr_repro_procdiario.inicio_GrabaControlRE(pd_fecha, pd_usuario);
          end;
          delete AQPC434b where AQPC434bfecact=pd_fecha;
          commit;
          insert into AQPC434b select * from AQPC434 where AQPC434est='N';
          commit;
   end if;
end inicio_grabaRE;
-----------------------------------------------------------------------------------------------------------

procedure graba_AQPC434 (  pd_fechaProg date, pd_fecha date, pd_usuario char ) is
    cursor listado (ld_fechaProg in date) is
      select *
       -- from USRREPBI.REP_TOT_REPRO_2020
        from AQPC433
        where AQPC433fec=ld_fechaProg;        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
    ln_contador number(18);
Begin  
    pn_emp := 1;  
    select pgfape into ld_pgfape from fst017 where pgcod=1;
    ln_contador:=0;
    select count(*) into ln_contador
    from AQPC433;  
    if (ln_contador > 0 ) then
        for a in listado(pd_fechaProg) loop
               ln_CTA:= a.AQPC433cta;
               ln_OPE:= a.AQPC433oper;
               
               ln_SBO:= a.AQPC433sbop;
               ln_fecha := a.AQPC433fec;
               ln_esta :=0; 
               begin             
               select count(*) into ln_esta from AQPC434 where AQPC434cta=ln_CTA and AQPC434ope=ln_OPE and AQPC434sbo=ln_SBO;
               exception 
                 when no_data_found then
                   ln_esta := 0;
               end;
                if ln_esta = 0 then             
                  if ( pd_fecha = ld_pgfape ) then
                     begin
                      select f.pgcod,--aqui esta devolviendo doble registro
                             f.scsuc,
                             f.scmda,
                             f.scpap,
                             --sccta,                
                             --scoper,
                             f.scsbop,
                             f.sctope,
                             f.scmod,
                             f.scsdo
                        into ln_EMP,
                             ln_SUC,
                             ln_MDA,
                             ln_PAP,                                                                                                   
                             ln_SBO,
                             ln_TOP,
                             ln_MOD,
                             ln_scsdo
                        from fsd011 f
                       where f.pgcod =  pn_emp
                         and f.sccta =  ln_CTA
                         and f.scoper = ln_OPE
                         --and a.scsbop = ln_SBO --  31/12/2020 que no valide suboperacion porque puede haber cambiado
                         and ( f.scmod in (select modulo from fst111 where dscod=50)
                         and f.scmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300))--en la uía esta los módulos qeu no se debenconsiderar
                         and f.scsdo < 0
                         and f.scstat not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                         and rownum=1; --kdvc 04/09/2020
                        exception 
                        when  no_data_found then
                          ln_CTA:=0;
                          ln_OPE:=0;            
                        end ;
                    else
                       begin
                        select f.bcemp,
                             f.bcsuc,
                             f.bcmda,
                             f.bcpap,
                             --sccta,                
                            -- scoper,
                             f.bcsbop,
                             f.bctop,
                             f.bcmod,
                             f.bcsdmo
                        into ln_EMP,
                             ln_SUC,
                             ln_MDA,
                             ln_PAP,                                                                                                   
                             ln_SBO,
                             ln_TOP,
                             ln_MOD,
                             ln_scsdo
                        from fsh012 f                  
                        where f.BCEMP  = pn_EMP
                         and f.BCFECH = pd_fecha                 
                         and f.BCRUBR in (select rubro
                                          from fsd014
                                         where pcnivc in (select MODULO
                                                            from fst111
                                                           Where Dscod = 50
                                                             and Modulo <> 29
                                                             and Modulo <> 120
                                                             and Modulo <> 144)
                                         and substr(rubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426))
                         and f.BCCTA  = ln_CTA             
                         and f.BCOPER = ln_OPE 
                         and f.bcmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300)--en la uía esta los módulos qeu no se debenconsiderar
                         and f.bcsdmo < 0
                         and f.bcprod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                         and rownum = 1; 

                        exception 
                        when  no_data_found then
                          ln_CTA:=0;
                          ln_OPE:=0;            
                        end ;
                     end if;
             
                    
                    if (ln_CTA<>0 ) then -- solo aquellos que están activos procederá a calcular sus controles            
                      lc_Contabilizar := 'S';                                 
                       begin
                         ln_esta := 0;             
                       select count(*) into ln_esta from AQPC434 where AQPC434cta=ln_CTA and AQPC434ope=ln_OPE and AQPC434sbo=ln_SBO;
                       exception 
                         when no_data_found then
                           ln_esta := 0;
                       end;
                       if( ln_esta = 0) then
                        insert into AQPC434
                          (AQPC434FEP, 
                           AQPC434EMP,
                           AQPC434MOD, 
                           AQPC434SUC, 
                           AQPC434MDA, 
                           AQPC434PAP, 
                           AQPC434CTA, 
                           AQPC434OPE, 
                           AQPC434SBO, 
                           AQPC434TPO, 
                           AQPC434TDOC,
                           AQPC434NDOC,
                           AQPC434MTO, 
                           AQPC434TIP, 
                           AQPC434PDI, 
                           AQPC434SOL, 
                           AQPC434RER, 
                           AQPC434EXT, 
                           AQPC434CON, 
                          -- AQPC434FECE,
                           AQPC434TABO,
                           AQPC434FECACT,
                           AQPC434USUACT,
                           AQPC434est,
                           AQPC434SAlACT
                           )           
                        VALUES
                          ( ln_fecha,           
                           ln_EMP,
                           ln_MOD,
                           ln_SUC,
                           ln_MDA,
                           ln_PAP,
                           ln_CTA,
                           ln_OPE,
                           ln_SBO,
                           ln_TOP,
                           '',
                           '',
                           a.AQPC433SDMO,
                           a.AQPC433TIP, 
                           0, 
                           '', 
                           '', 
                           'NO', 
                           '', 
                           --a.fec_extorno,
                           a.AQPC433SBTIP,
                           pd_fecha,
                           pd_usuario,
                           lc_Contabilizar,
                           ln_scsdo 
                           );
                           commit;
                      end if;
                    end if;
              end if;
          end loop;  
      end if;  
  end graba_AQPC434;

procedure inicio_GrabaControlRE(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number;      
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPC434';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPC434(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPC434');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
           exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
          end;
       Else         
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPC434');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
         /* begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/  --  02/09/2020 kdvc
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPC434', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     While ln_numjob2 > 0 loop
        ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControlRE;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure control_AQPC434 ( pn_sucursal number, pd_fecha date, pd_usuario char ) is
    cursor listado (ln_suc in number) is
      select *
        from AQPC434
        where 
        AQPC434suc=ln_suc
        and AQPC434est='S'; --los que están en 'N' son los que ya no se deben considerar son los extornados                        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
    ld_fechaProg date;
    ln_NunCuotasTI number;--inicio 28/06/2022 kdvc
Begin  
    pn_emp := 1;  
    
    for b in listado(pn_sucursal) loop
           ln_EMP:= b.AQPC434emp;
           ln_SUC:= b.AQPC434suc;
           ln_MDA:= b.AQPC434mda;
           ln_PAP:= b.AQPC434pap;
           ln_SBO:= b.AQPC434sbo;
           ln_TOP:= b.AQPC434tpo;
           ln_MOD:= b.AQPC434mod;
           ln_CTA:= b.AQPC434cta;
           ln_OPE:= b.AQPC434ope;
           ld_fechaProg:=b.AQPC434fep;
           ln_scsdo:=b.AQPC434salact;  --kvalenciac  13/01/2023
           lc_Contabilizar := 'S';        
                  lc_TieneReduccion := fn_TieneReduccionCuota(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg);
                  
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotasTI :=   fn_PagoCuotas(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha);  --antes era ln_NunCuotas 28/06/2022 kdvc  
                  else
                      ln_NunCuotasTI :=   fn_PagoCuotasAtras(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha); --antes era ln_NunCuotas 28/06/2022 kdvc
                  end if;
                  --inicio 28/06/2022 kdvc
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_N(ld_fechaProg,pd_fecha, ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                                                     
                  else
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_S(pd_fecha,ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                           
                  end if;
                  --fin 28/06/2022 kdvc
                  lc_PagoCapital :=   fn_PagoCapital(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ln_scsdo, ld_fechaProg);
                  ln_Periocidad :=   fn_periocidad(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE); 
                  if ( ln_Periocidad <= 30 ) then --si tienen periocidad mensual entonces
                      if ( lc_TieneReduccion ='N' ) then
                        if ( ln_NunCuotas >=6 ) then -- si no tienen reduccion de cuota y si pagó mas de 6 cuotas consecutivas
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      else --si tiene reduccion de cuota
                        if ( ln_NunCuotas >=6  and lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      end if;
                   else
                     if ( ln_NunCuotas >=6 or  lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital  --and  12012020
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                     end if;
                   end if;
                   if (ln_MOD =108) then --si es crédito prendario
                       lc_Contabilizar := 'S';                
                   end if;
                                   
                   update AQPC434 set                                            
                       AQPC434est = lc_Contabilizar,--estado  07/10/2020
                       AQPC434REDCUO = lc_TieneReduccion, --'s' si tiene reducción de cuota 07/10/2020
                       AQPC434NUMCUOP = ln_NunCuotas, --número de cuotas pagadas puntualmente desde la fecha reprogramada x covid  07/10/2020
                       AQPC434PAGCAP = lc_PagoCapital, --'s' si pago el 20% de capital  07/10/2020
                       AQPC434PERIO = ln_Periocidad, --periocidad del crédito  07/10/2020  
                       AQPC434NUMCUOPTI = ln_NunCuotasTI -- 28/06/2022 kdvc                               
                   where AQPC434EMP = ln_EMP
                       and AQPC434MOD = ln_MOD 
                       and AQPC434SUC = ln_SUC 
                       and AQPC434MDA = ln_MDA 
                       and AQPC434PAP = ln_PAP 
                       and AQPC434CTA = ln_CTA 
                       and AQPC434OPE = ln_OPE
                       and AQPC434SBO = ln_SBO 
                       and AQPC434TPO = ln_TOP;
                   commit;
                  
      end loop;    
  end control_AQPC434;
------------------------------------------------------------------------------------------------------------------------------
procedure inicio_grabaRE2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number; 
     x number;     
job_id        number;     

    cursor fecha (ld_fecha in date) is
    select AQPC433fec as fec
        --from AQPB836
        from AQPC433
        group by AQPC433fec;               
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete AQPC434;
    commit; 
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job1        := 0;
    for a in fecha (pd_fecha) loop         
      lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
      ln_job1        := ln_job1 + 1;
      lc_prefjob1    := 'AQPC434';   --  prefijo del nombre
      pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                   'N' || to_char(ln_job1); ---  nombre del job
                  
      lc_variable1 := 'begin ' ||
                   ' pq_cr_repro_procdiario.graba_AQPC434(' 
                   || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
        if SYS.FN_BD_ISRAC = 'TRUE' THEN

                  dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              instance  => 2,
                              force     => false);
                                               
       Else         
                       dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);
      End If;
      commit;
       select count(*) 
              into x
--              from dba_scheduler_jobs 
from dba_jobs
--              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPC434%';
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPC434%';              
            end loop;
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('AQPC434', lc_fec, lc_variable1);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);  
     While ln_numjob1 > 0 loop
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);
     End loop;

      DELETE FROM AQPC434
      WHERE rowid not in
      (SELECT MAX(rowid)--MIN
      FROM AQPC434
      GROUP BY AQPC434cta,AQPC434ope);--AQPC434sbo
      commit;
      begin
         pq_cr_repro_procdiario.inicio_GrabaControlRE2(pd_fecha, pd_usuario);
      end;
      delete AQPC434b where AQPC434bfecact=pd_fecha;
      commit;
      insert into AQPC434b select * from AQPC434 where AQPC434est='N';
      commit;
end inicio_grabaRE2;
procedure inicio_GrabaControlRE2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number; 
     x number;     
job_id number;     
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPC434';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPC434(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
--      if n_inst in (1,2) then   --02/09/2020 kdvc
         IF SYS.FN_BD_ISRAC = 'TRUE' THEN
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPC434');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
          end;*/
dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              instance  => 2,
                              force     => false);          
       Else         
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPC434');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
          begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;  --  02/09/2020 kdvc*/

dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);          
      End If;
      commit;
      select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPC434%';                            
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPC434%';                            
            end loop;
            
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPC434', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);  
     While ln_numjob2 > 0 loop
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControlRE2;

procedure carga_tabla(pd_fecha date, pd_usuario char) is
    ln_indicador  number:=0;
begin  
      delete aqpc433;
      commit;
       insert into aqpc433(AQPC433emp,
                            AQPC433mod ,  
                            AQPC433suc ,  
                            AQPC433mda ,  
                            AQPC433pap ,  
                            AQPC433cta ,  
                            AQPC433oper,  
                            AQPC433sbop,  
                            AQPC433top ,  
                            AQPC433fec ,  
                            AQPC433tip ,  
                            AQPC433sbtip, 
                            AQPC433sdmo,  
                            AQPC433aplext,
                            AQPC433fecbi )
        select  AQPB836EMP,
                AQPB836MOD,
                AQPB836SUC,
                AQPB836MDA,
                AQPB836PAP,
                AQPB836CTA,
                AQPB836OPER,
                AQPB836SBOP,
                AQPB836TOP,
                AQPB836FEC,
                AQPB836TIP,
                AQPB836SBTIP,
                AQPB836SDMO,
                AQPB836APLEXT,
                AQPB836FECBI
        from aqpb836
        where  AQPB836FECBI=pd_fecha
        and aqpb836aplext='S';
        commit;
end carga_tabla; 
---fin kvalenciac 10/02/2023
--------------------------------------reprogramaciones individuales

----inicio 09/11/2023 kvalenciac
procedure inicio_grabaRI(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number;  
    ln_contador number;    
    cursor fecha (ld_fecha in date) is
    select aqpd203fec as fec
        --from AQPB836
        from aqpd203
        group by aqpd203fec;              
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    ln_contador:=0;
    select count(*) into ln_contador
        --from AQPB836
        from aqpd203;
    if (ln_contador>0) then 
        delete AQPD204;
        commit; 
        lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
        ----------------------------------------------
        ln_job1        := 0;
        for a in fecha (pd_fecha) loop         
          lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
          ln_job1        := ln_job1 + 1;
          lc_prefjob1    := 'AQPD204';   --  prefijo del nombre
          pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                       'N' || to_char(ln_job1); ---  nombre del job
                      
          lc_variable1 := 'begin ' ||
                       ' pq_cr_repro_procdiario.graba_AQPD204(' 
                       || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                       || ',TO_DATE(''' || lc_fecpro ||
                       ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
             
          --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
    --    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
          select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
          if n_inst in (1,2) then   --02/09/2020 kdvc
              dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                        job_type   => 'PLSQL_BLOCK',
                                        job_action => lc_variable1,
                                        start_date => sysdate, -- + 1 / (24 * 180),
                                        enabled    => true,
                                        auto_drop  => TRUE,
                                        comments   => 'Carga_AQPD204');
              begin
               -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
                dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
                 exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
              end;
           Else         
              dbms_scheduler.create_job(job_name   => pi_vc1_nomjob,
                                        job_type   => 'PLSQL_BLOCK',
                                        job_action => lc_variable1,
                                        start_date => sysdate, -- + 1 / (24 * 180),
                                        enabled    => true,
                                        auto_drop  => TRUE,
                                        comments   => 'Carga_AQPD204');
             --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
             /* begin --  02/09/2020 kdvc
                dbms_scheduler.set_attribute(pi_vc1_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
              end;*/  --  02/09/2020 kdvc
          End If;
          commit;
          
          INSERT INTO Tab_jobs
              (c_codage, c_dato1, c_detjob)
          VALUES
              ('AQPD204', lc_fec, lc_variable1);
          COMMIT;
          
          end loop;
        ------------------Verificaciones que se haya terminado de ejecutar los jobs.
         ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname);  
         While ln_numjob1 > 0 loop
            ln_numjob1 := fn_cr_verifica_tarea(lc_prefjob1, lc_hostname); 
         End loop;

          DELETE FROM AQPD204
          WHERE rowid not in
          (SELECT MAX(rowid)--MIN
          FROM AQPD204
          GROUP BY AQPD204cta,AQPD204ope);--AQPD204sbo
          commit;
          begin
             pq_cr_repro_procdiario.inicio_GrabaControlRI(pd_fecha, pd_usuario);
          end;
          delete AQPD204b where AQPD204bfecact=pd_fecha;
          commit;
          insert into AQPD204b select * from AQPD204 where AQPD204est='N';
          commit;
   end if;
end inicio_grabaRI;
-----------------------------------------------------------------------------------------------------------

procedure graba_AQPD204 (  pd_fechaProg date, pd_fecha date, pd_usuario char ) is
    cursor listado (ld_fechaProg in date) is
      select *
       -- from USRREPBI.REP_TOT_REPRO_2020
        from aqpd203
        where aqpd203fec=ld_fechaProg;        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
    ln_contador number(18);
Begin  
    pn_emp := 1;  
    select pgfape into ld_pgfape from fst017 where pgcod=1;
    ln_contador:=0;
    select count(*) into ln_contador
    from aqpd203;  
    if (ln_contador > 0 ) then
        for a in listado(pd_fechaProg) loop
               ln_CTA:= a.aqpd203cta;
               ln_OPE:= a.aqpd203oper;
               
               ln_SBO:= a.aqpd203sbop;
               ln_fecha := a.aqpd203fec;
               ln_esta :=0; 
               begin             
               select count(*) into ln_esta from AQPD204 where AQPD204cta=ln_CTA and AQPD204ope=ln_OPE and AQPD204sbo=ln_SBO;
               exception 
                 when no_data_found then
                   ln_esta := 0;
               end;
                if ln_esta = 0 then             
                  if ( pd_fecha = ld_pgfape ) then
                     begin
                      select f.pgcod,--aqui esta devolviendo doble registro
                             f.scsuc,
                             f.scmda,
                             f.scpap,
                             --sccta,                
                             --scoper,
                             f.scsbop,
                             f.sctope,
                             f.scmod,
                             f.scsdo
                        into ln_EMP,
                             ln_SUC,
                             ln_MDA,
                             ln_PAP,                                                                                                   
                             ln_SBO,
                             ln_TOP,
                             ln_MOD,
                             ln_scsdo
                        from fsd011 f
                       where f.pgcod =  pn_emp
                         and f.sccta =  ln_CTA
                         and f.scoper = ln_OPE
                         --and a.scsbop = ln_SBO --  31/12/2020 que no valide suboperacion porque puede haber cambiado
                         and ( f.scmod in (select modulo from fst111 where dscod=50)
                         and f.scmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300))--en la uía esta los módulos qeu no se debenconsiderar
                         and f.scsdo < 0
                         and f.scstat not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                         and rownum=1; --kdvc 04/09/2020
                        exception 
                        when  no_data_found then
                          ln_CTA:=0;
                          ln_OPE:=0;            
                        end ;
                    else
                       begin
                        select f.bcemp,
                             f.bcsuc,
                             f.bcmda,
                             f.bcpap,
                             --sccta,                
                            -- scoper,
                             f.bcsbop,
                             f.bctop,
                             f.bcmod,
                             f.bcsdmo
                        into ln_EMP,
                             ln_SUC,
                             ln_MDA,
                             ln_PAP,                                                                                                   
                             ln_SBO,
                             ln_TOP,
                             ln_MOD,
                             ln_scsdo
                        from fsh012 f                  
                        where f.BCEMP  = pn_EMP
                         and f.BCFECH = pd_fecha                 
                         and f.BCRUBR in (select rubro
                                          from fsd014
                                         where pcnivc in (select MODULO
                                                            from fst111
                                                           Where Dscod = 50
                                                             and Modulo <> 29
                                                             and Modulo <> 120
                                                             and Modulo <> 144)
                                         and substr(rubro,1,4) in (1411,1421,1414,1424,1415,1425,1416,1426))
                         and f.BCCTA  = ln_CTA             
                         and f.BCOPER = ln_OPE 
                         and f.bcmod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >0 and tpcorr <300)--en la uía esta los módulos qeu no se debenconsiderar
                         and f.bcsdmo < 0
                         and f.bcprod not in (select tpnro from fst098 where pgcod=1 and tpcod=7746 and tpcorr >299 and tpcorr <600)--en la guía esta los estados que no se deben considerar
                         and rownum = 1; 

                        exception 
                        when  no_data_found then
                          ln_CTA:=0;
                          ln_OPE:=0;            
                        end ;
                     end if;
             
                    
                    if (ln_CTA<>0 ) then -- solo aquellos que están activos procederá a calcular sus controles            
                      lc_Contabilizar := 'S';                                 
                       begin
                         ln_esta := 0;             
                       select count(*) into ln_esta from AQPD204 where AQPD204cta=ln_CTA and AQPD204ope=ln_OPE and AQPD204sbo=ln_SBO;
                       exception 
                         when no_data_found then
                           ln_esta := 0;
                       end;
                       if( ln_esta = 0) then
                        insert into AQPD204
                          (AQPD204FEP, 
                           AQPD204EMP,
                           AQPD204MOD, 
                           AQPD204SUC, 
                           AQPD204MDA, 
                           AQPD204PAP, 
                           AQPD204CTA, 
                           AQPD204OPE, 
                           AQPD204SBO, 
                           AQPD204TPO, 
                           AQPD204TDOC,
                           AQPD204NDOC,
                           AQPD204MTO, 
                           AQPD204TIP, 
                           AQPD204PDI, 
                           AQPD204SOL, 
                           AQPD204RER, 
                           AQPD204EXT, 
                           AQPD204CON, 
                          -- AQPD204FECE,
                           AQPD204TABO,
                           AQPD204FECACT,
                           AQPD204USUACT,
                           AQPD204est,
                           AQPD204SAlACT
                           )           
                        VALUES
                          ( ln_fecha,           
                           ln_EMP,
                           ln_MOD,
                           ln_SUC,
                           ln_MDA,
                           ln_PAP,
                           ln_CTA,
                           ln_OPE,
                           ln_SBO,
                           ln_TOP,
                           '',
                           '',
                           a.aqpd203SDMO,
                           a.aqpd203TIP, 
                           0, 
                           '', 
                           '', 
                           'NO', 
                           '', 
                           --a.fec_extorno,
                           a.aqpd203SBTIP,
                           pd_fecha,
                           pd_usuario,
                           lc_Contabilizar,
                           ln_scsdo 
                           );
                           commit;
                      end if;
                    end if;
              end if;
          end loop;  
      end if;  
  end graba_AQPD204;

procedure inicio_GrabaControlRI(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number;      
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPD204';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPD204(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPD204');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
             exception  --inicio 17/12/2024 kvalenciac
                	 when others then 
                   null;  --fin 17/12/2024 kvalenciac
          end;
       Else         
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPD204');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
         /* begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/  --  02/09/2020 kdvc
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPD204', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     While ln_numjob2 > 0 loop
        ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControlRI;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure control_AQPD204 ( pn_sucursal number, pd_fecha date, pd_usuario char ) is
    cursor listado (ln_suc in number) is
      select *
        from AQPD204
        where 
        AQPD204suc=ln_suc
        and AQPD204est='S'; --los que están en 'N' son los que ya no se deben considerar son los extornados                        
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);    
    ln_fecha date; 
    ln_esta     number(1);
    lc_TieneReduccion char(1); 
    ln_NunCuotas number(3);
    lc_PagoCapital char(1);
    ln_Periocidad number(5);
    lc_Contabilizar char(1);
    ln_scsdo number(17,2);
    ld_pgfape date;
    ld_fechaProg date;
    ln_NunCuotasTI number;--inicio 28/06/2022 kdvc
Begin  
    pn_emp := 1;  
    
    for b in listado(pn_sucursal) loop
           ln_EMP:= b.AQPD204emp;
           ln_SUC:= b.AQPD204suc;
           ln_MDA:= b.AQPD204mda;
           ln_PAP:= b.AQPD204pap;
           ln_SBO:= b.AQPD204sbo;
           ln_TOP:= b.AQPD204tpo;
           ln_MOD:= b.AQPD204mod;
           ln_CTA:= b.AQPD204cta;
           ln_OPE:= b.AQPD204ope;
           ld_fechaProg:=b.AQPD204fep;
           ln_scsdo:=b.AQPD204salact;  --kvalenciac  13/01/2023
           lc_Contabilizar := 'S';        
                  lc_TieneReduccion := fn_TieneReduccionCuota(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg);
                  
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotasTI :=   fn_PagoCuotas(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha);  --antes era ln_NunCuotas 28/06/2022 kdvc  
                  else
                      ln_NunCuotasTI :=   fn_PagoCuotasAtras(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ld_fechaProg, pd_fecha); --antes era ln_NunCuotas 28/06/2022 kdvc
                  end if;
                  --inicio 28/06/2022 kdvc
                  if ( lc_TieneReduccion ='N' ) then
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_N(ld_fechaProg,pd_fecha, ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                                                     
                  else
                      ln_NunCuotas :=  fn_num_cuopa_redcuo_S(pd_fecha,ln_EMP, ln_MOD, ln_SUC, ln_MDA, ln_PAP, ln_CTA, ln_OPE, ln_SBO, ln_TOP);                                           
                  end if;
                  --fin 28/06/2022 kdvc
                  lc_PagoCapital :=   fn_PagoCapital(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE, ln_scsdo, ld_fechaProg);
                  ln_Periocidad :=   fn_periocidad(ln_EMP, ln_SUC, ln_MDA, ln_PAP, ln_SBO, ln_TOP, ln_MOD, ln_CTA, ln_OPE); 
                  if ( ln_Periocidad <= 30 ) then --si tienen periocidad mensual entonces
                      if ( lc_TieneReduccion ='N' ) then
                        if ( ln_NunCuotas >=6 ) then -- si no tienen reduccion de cuota y si pagó mas de 6 cuotas consecutivas
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      else --si tiene reduccion de cuota
                        if ( ln_NunCuotas >=6  and lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                        end if;
                      end if;
                   else
                     if ( ln_NunCuotas >=6 or  lc_PagoCapital='S') then --si pago 6 cuotas consecutivas y si pagó el 20% de capital  --and  12012020
                          lc_Contabilizar := 'N'; -- ya no se debe contabilizar cuentas de orden
                     end if;
                   end if;
                   if (ln_MOD =108) then --si es crédito prendario
                       lc_Contabilizar := 'S';                
                   end if;
                                   
                   update AQPD204 set                                            
                       AQPD204est = lc_Contabilizar,--estado  07/10/2020
                       AQPD204REDCUO = lc_TieneReduccion, --'s' si tiene reducción de cuota 07/10/2020
                       AQPD204NUMCUOP = ln_NunCuotas, --número de cuotas pagadas puntualmente desde la fecha reprogramada x covid  07/10/2020
                       AQPD204PAGCAP = lc_PagoCapital, --'s' si pago el 20% de capital  07/10/2020
                       AQPD204PERIO = ln_Periocidad, --periocidad del crédito  07/10/2020  
                       AQPD204NUMCUOPTI = ln_NunCuotasTI -- 28/06/2022 kdvc                               
                   where AQPD204EMP = ln_EMP
                       and AQPD204MOD = ln_MOD 
                       and AQPD204SUC = ln_SUC 
                       and AQPD204MDA = ln_MDA 
                       and AQPD204PAP = ln_PAP 
                       and AQPD204CTA = ln_CTA 
                       and AQPD204OPE = ln_OPE
                       and AQPD204SBO = ln_SBO 
                       and AQPD204TPO = ln_TOP;
                   commit;
                  
      end loop;    
  end control_AQPD204;
------------------------------------------------------------------------------------------------------------------------------
procedure inicio_grabaRI2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable1   varchar2(1000);
    ln_job1        number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc1_nomjob varchar2(65);
    lc_prefjob1    varchar2(64);   
    ln_numjob1     number(9) := 0;
    n_inst number; 
     x number;     
job_id        number;     

    cursor fecha (ld_fecha in date) is
    select aqpd203fec as fec
        --from AQPB836
        from aqpd203
        group by aqpd203fec;               
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete AQPD204;
    commit; 
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job1        := 0;
    for a in fecha (pd_fecha) loop         
      lc_fec := to_char( a.fec, 'RRRR.MM.DD'); 
      ln_job1        := ln_job1 + 1;
      lc_prefjob1    := 'AQPD204';   --  prefijo del nombre
      pi_vc1_nomjob := lc_prefjob1 || to_char(pd_fecha, 'ddmmrrrr') ||
                   'N' || to_char(ln_job1); ---  nombre del job
                  
      lc_variable1 := 'begin ' ||
                   ' pq_cr_repro_procdiario.graba_AQPD204(' 
                   || 'TO_DATE(''' || lc_fec || ''',''RRRR.MM.DD'')'
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
        if SYS.FN_BD_ISRAC = 'TRUE' THEN

                  dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
--                              instance  => 2,
instance  => 1,
                              force     => false);
                                               
       Else         
                       dbms_job.submit(job_id,
                              what      => lc_variable1,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);
      End If;
      commit;
       select count(*) 
              into x
--              from dba_scheduler_jobs 
from dba_jobs
--              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPD204%';
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%AQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPD204%';              
            end loop;
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('AQPD204', lc_fec, lc_variable1);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);  
     While ln_numjob1 > 0 loop
ln_numjob1 := fn_cr_verifica_tarea2(lc_prefjob1, lc_hostname);
     End loop;

      DELETE FROM AQPD204
      WHERE rowid not in
      (SELECT MAX(rowid)--MIN
      FROM AQPD204
      GROUP BY AQPD204cta,AQPD204ope);--AQPD204sbo
      commit;
      begin
         pq_cr_repro_procdiario.inicio_GrabaControlRI2(pd_fecha, pd_usuario);
      end;
      delete AQPD204b where AQPD204bfecact=pd_fecha;
      commit;
      insert into AQPD204b select * from AQPD204 where AQPD204est='N';
      commit;
end inicio_grabaRI2;
procedure inicio_GrabaControlRI2(pd_fecha date, pd_usuario char) is
    lc_fec    char(10);
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number; 
     x number;     
job_id number;     
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPD204';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_repro_procdiario.control_AQPD204(' 
                   || ln_suc
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
--      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
--      if n_inst in (1,2) then   --02/09/2020 kdvc
         IF SYS.FN_BD_ISRAC = 'TRUE' THEN
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPD204');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
          end;*/
dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              instance  => 2,
                              force     => false);          
       Else         
/*          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Control_AQPD204');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
          begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;  --  02/09/2020 kdvc*/

dbms_job.submit(job_id,
                              what      => lc_variable2,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);          
      End If;
      commit;
      select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPD204%';                            
            while x = 40 loop
              select count(*) 
              into x
/*              from dba_scheduler_jobs 
              where owner='BANTPROD' AND JOB_NAME LIKE '%CAQPA83%';*/
from dba_jobs
where schema_user='BANTPROD' AND upper(what) LIKE '%AQPD204%';                            
            end loop;
            
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPD204', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);  
     While ln_numjob2 > 0 loop
ln_numjob2 := fn_cr_verifica_tarea2(lc_prefjob2, lc_hostname);
     End loop;
     
end inicio_GrabaControlRI2;

procedure carga_tablaRI(pd_fecha date, pd_usuario char) is
    ln_indicador  number:=0;
begin  
      delete aqpd203;
      commit;
       insert into aqpd203(aqpd203emp,
                            aqpd203mod ,  
                            aqpd203suc ,  
                            aqpd203mda ,  
                            aqpd203pap ,  
                            aqpd203cta ,  
                            aqpd203oper,  
                            aqpd203sbop,  
                            aqpd203top ,  
                            aqpd203fec ,  
                            aqpd203tip ,  
                            aqpd203sbtip, 
                            aqpd203sdmo,  
                            aqpd203aplext,
                            aqpd203fecbi )
        select  AQPB836EMP,
                AQPB836MOD,
                AQPB836SUC,
                AQPB836MDA,
                AQPB836PAP,
                AQPB836CTA,
                AQPB836OPER,
                AQPB836SBOP,
                AQPB836TOP,
                AQPB836FEC,
                AQPB836TIP,
                AQPB836SBTIP,
                AQPB836SDMO,
                AQPB836APLEXT,
                AQPB836FECBI
        from aqpb836
        where  AQPB836FECBI=pd_fecha
        and  AQPB836TIP like 'CTA. 81_927%';
        commit;
end carga_tablaRI; 
---fin kvalenciac 09/11/2023
end pq_cr_repro_procdiario;
 /* GOLDENGATE_DDL_REPLICATION */
/

