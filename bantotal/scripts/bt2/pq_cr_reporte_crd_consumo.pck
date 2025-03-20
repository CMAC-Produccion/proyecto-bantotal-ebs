create or replace package pq_cr_reporte_crd_consumo is

  -- Author  : HSUAREZ
  -- Created : 21/05/2021 11:37:13
  -- Purpose : Paquete para procesar información historica, al cierre de un determinado mes, se obtiene de ello, todos los creditos que tiene cuota doble
  --           cuota fija, de acuerdo a la Metodología Esquemas de Cronogramas Consumo.
  -- MODIFICADO: 04/01/2024 17:27 
  -- Cambio: 	Paquet modificado se agrego limite a 20 jobs.
  -- MODIFICADO: 05/09/2024 17:27 
  -- Cambio: 	Se agrego una excepcion al Job para evitar error de validación.

   Procedure sp_cr_sch_cred_cons(pd_fecpro in date,pc_usr in varchar);
   Procedure sp_report_esquema_cronog(
                                       pd_fecpro in date,
                                       pc_usr    in varchar
                                       );
   Procedure sp_report_esquema_cronog_s(
                                       pd_fecpro in date,
                                       pc_usr    in varchar,
                                       sucurs    in number
                                       );
   procedure sp_tasa_credito(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_tasa out fsd010.aotasa%type --TASA
     ); 
     
   procedure sp_cuo_my_mn_aj(   
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_cuo_my out fsd010.aoimp%type, --CUOTA MAYOR
                               ve_cuo_mn out fsd010.aoimp%type, --CUOTA MENOR
                               ve_cuo_aj out fsd010.aoimp%type  --CUOTA AJUSTE
                              );
                              
   procedure sp_periodo_crd(   
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_pr_txt out varchar2, --PERIODO TEXTO
                               ve_pr_num out fsd010.aoimp%type --PERIODO NUMERO                               
                              );                              
   procedure sp_esquema_cuota(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_esquema out number,
                               ve_to_cuot out fsd601.ppcap%type,
                               ve_to_cuot_rmn out fsd601.ppcap%type
     );                                    
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2) return number;
  function fn_cr_obtener_cuo_prm(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type
  ) return number;                               
end pq_cr_reporte_crd_consumo;
/

create or replace package body pq_cr_reporte_crd_consumo is

   procedure sp_cr_sch_cred_cons(pd_fecpro in date,pc_usr in varchar) is
    
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    limitar_job number(9) := 0;
    limite number(9) := 0;
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
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
    begin
      execute immediate 'delete from AQPB551 where AQPB551USRR= :pc_usr' using pc_usr;
    exception
      when others then
        null;
    end;
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'CRCNSESQ';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_reporte_crd_consumo.sp_report_esquema_cronog_s( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),'''||pc_usr||''',' || ln_ini ||
                       ' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Cred_consumo_esq');
        
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        exception
          when others then
            null;
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Cred_consumo_esq');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        exception
          when others then
            null;
        end;
      End If;
      commit;
      begin
        INSERT INTO Tab_jobs
          (c_codage, n_Numer1, c_detjob)
        VALUES
          ('CRCNSESQ', ln_ini, lc_variable);
        COMMIT;
      exception
        when others then
          null;
      end;
      --condicion agregada para limitar los jobs.
      limitar_job := limitar_job + 1;
      begin 
          begin select tp1nro1 into limite from fst198 where tp1cod = 1 and tp1cod1 = 11161 and tp1corr2=60 and tp1corr3=1; exception when others then limite:= 20; end;
          if limitar_job >= limite then
             ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
             While ln_numjob > 0 loop
                ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
             End loop;
             limitar_job := 0; 
          end if;
      end;
      --fin de la condicion para ejecutar en cantidad limitada los jobs.   
    end loop;
  
    ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := fn_cr_verifica_tarea(lc_prefjob, lc_hostname);
    End loop;
  
  end sp_cr_sch_cred_cons;
   
   Procedure sp_report_esquema_cronog(
                                       pd_fecpro in date,
                                       pc_usr    in varchar                                       
                                       ) is
   --Cursores
   --CURSOS PARA CREDITOS A EVALUAR
   cursor lista_creditos_cierres is 
    select h.bccta, --CUENTA
           h.bcmod, --MODULO
           h.bcsuc, --SUCURSAL
           h.bcmda, --MONEDA
           h.bcpap, --PAPEL
           h.bcoper, --OPERACION
           h.bcsbop, --SUBOPERACION
           h.bctop, --TIPO DE OPERACION
           h.bcfech, --FECHA DE CIERRE
           h.bcgpo, --TIPO DE CREDITO
           h.bcrubr, --RUBRO
           case
             when h.BCGpo = 3 and substr(h.bcrubr, 11, 3) = '015' then
              'CONSUMO REVOLVENTE'
             when h.BCGpo = 3 and substr(h.bcrubr, 11, 3) <> '015' then
              'CONSUMO NO REVOLVENTE'
           END bcgpodes --TIPO DE CREDITO SBS
      from fsh012 h
     where h.bcemp = 1
       and h.bcfech = to_date(pd_fecpro, 'dd/mm/rrrr')
       and substr(h.bcrubr, 1, 4) in
           (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426) --1411040601012
       --and h.bccta <> 0
       ---and h.bcgpo = 3
       --and h.bcoper <> 0
       --and h.bcmod = 107
       --and rownum <1;
       and h.bcpzo<>5
       and h.bccta =32603;--99085;--232766;--99085;
       --and h.bcoper=8969447;
   --CURSOS PARA OBTENER EL CRONOGRAMA DE PAGOS DEL CREDITO.    
   cursor cronograma_clientes( vipgcod in fsd601.pgcod%TYPE,
                               vippmod in fsd601.ppmod%TYPE,
                               vippsuc in fsd601.ppsuc%TYPE,
                               vippmda in fsd601.ppmda%TYPE,
                               vipppap in fsd601.pppap%TYPE,
                               vippcta in fsd601.ppcta%TYPE,
                               vippoper in fsd601.ppoper%TYPE,
                               vippsbop in fsd601.ppsbop%TYPE,
                               vipptope in fsd601.pptope%TYPE,
                               vippfpag in fsd601.ppfpag%TYPE                          
                             ) is
   select d.*
     from fsd601  d
    where pgcod = vipgcod
      and ppmod = vippmod
      and ppsuc = vippsuc
      and ppmda = vippmda
      and pppap = vipppap
      and ppcta = vippcta
      and ppoper = vippoper
      and ppsbop = vippsbop
      and pptope = vipptope
      and ppfpag >= vippfpag;
       
   --Variables internas      
   ln_emp       number(3);
   ln_mod       number(3);
   ln_suc       number(3);
   ln_mda       number(4);
   ln_pap       number(4);
   ln_cta       number(9);
   ln_ope       number(9);
   ln_sbo       number(3);
   ln_top       number(3);
   vl_tsa       decimal(17,6);
   vl_per_num   number(3);
   vl_per_des   varchar(10);
   vl_fec_ult_pag date;
   ln_ppcap     fsd601.ppcap%type;
   ln_ppint     fsd601.ppint%type;
   
   --TEMPORALES
   tmp_fec_pag date;
   tmp_cuo_liq number(1);
   tmp_ppcap fsd601.ppcap%type;
   tmp_ppint fsd601.ppint%type;
   tmp_cuo_my decimal(17,2);
   tmp_cuo_mn decimal(17,2);
   tmp_cuo_aj decimal(17,2);
   tmp_scsdo decimal(17,2);
   tmp_seguro number(17,2);
   --
   ln_esquema number(3);
   ln_tot_cuo decimal(17,2);
   ln_num_rem decimal(17,2);
   ln_fac_pon decimal(5,2);
   ln_tot_cuoesq number(17,2);
   begin
       execute immediate 'delete from AQPB551 where AQPB551USRR= :pc_usr' using pc_usr;
       commit;
       for l in lista_creditos_cierres loop
           --INICIALIZANDO VARIABLES
           vl_tsa := 0;
           vl_per_num:=0;
           tmp_cuo_my := 0;
           tmp_cuo_mn := 0;
           tmp_cuo_aj := 0;
           --OBTENIENDO TASA
           begin
             pq_cr_reporte_crd_consumo.sp_tasa_credito(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        vl_tsa);--tasa
                                                        
             exception
                 when others then
                   vl_tsa:= 0;  
             end;
                          
             --OBTENIENDO PERIODO
             BEGIN
               pq_cr_reporte_crd_consumo.sp_periodo_crd(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        vl_per_des, --PERIODO TEXTO
                                                        vl_per_num);--PERIODO NUMERO
             
             --FIN CALCULO
             EXCEPTION 
               WHEN OTHERS THEN
                 null;
             END;  
             --OBTENER LA FECHA DE ULTIMO PAGO, FECHA DE ULTIMA CUOTA SEGUN CRONOGRAMA
             BEGIN
               SELECT max(ppfpag)
                  INTO vl_fec_ult_pag  
                      FROM fsd601
                     where pgcod = 1
                       and ppmod = l.bcmod
                       and ppsuc = l.bcsuc
                       and ppmda = l.bcmda
                       and pppap = l.bcpap
                       and ppcta = l.bccta
                       and ppoper = l.bcoper
                       and ppsbop = l.bcsbop
                       and pptope = l.bctop;
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;
               END;  
             --OBTENER ANTES LA FECHA PROGRAMADA  DEL ULTIMO PAGO REALIZADO
             BEGIN
                  SELECT CASE WHEN pp1stat='T' THEN (ppfpag+1) ELSE (ppfpag) END
                  INTO tmp_fec_pag  
                      FROM fsd602
                     where pgcod = 1
                       and ppmod = l.bcmod
                       and ppsuc = l.bcsuc
                       and ppmda = l.bcmda
                       and pppap = l.bcpap
                       and ppcta = l.bccta
                       and ppoper = l.bcoper
                       and ppsbop = l.bcsbop
                       and pptope = l.bctop
                       and ppfpag = (select max(d.ppfpag)
                                       from fsd602  d
                                      where d.pgcod = 1
                                        and d.ppmod = l.bcmod
                                        and d.ppsuc = l.bcsuc
                                        and d.ppmda = l.bcmda
                                        and d.pppap = l.bcpap
                                        and d.ppcta = l.bccta
                                        and d.ppoper = l.bcoper
                                        and d.ppsbop = l.bcsbop
                                        and d.pptope = l.bctop 
                                        AND ROWNUM=1)
                      AND d602fc = (SELECT max(dd.d602fc) 
                                      FROM fsd602 dd 
                                    where dd.pgcod =  1
                                       and dd.ppmod =  l.bcmod
                                       and dd.ppsuc =  l.bcsuc
                                       and dd.ppmda =  l.bcmda
                                       and dd.pppap =  l.bcpap
                                       and dd.ppcta =  l.bccta
                                       and dd.ppoper = l.bcoper
                                       and dd.ppsbop = l.bcsbop
                                       and dd.pptope = l.bctop)
                     AND ROWNUM = 1;                                                      
             EXCEPTION 
               WHEN OTHERS THEN
                  --EN CASO DE NO TENER PAGOS SE TOMA LA FECHA PROGRAMADA DEL PRIMER PAGO A REALIZAR DEL CRONOGRAMA
                  SELECT MIN(ppfpag)
                  into tmp_fec_pag
                    FROM fsd601
                   where pgcod = 1
                     and ppmod = l.bcmod
                     and ppsuc = l.bcsuc
                     and ppmda = l.bcmda
                     and pppap = l.bcpap
                     and ppcta = l.bccta
                     and ppoper = l.bcoper
                     and ppsbop = l.bcsbop
                     and pptope = l.bctop;
             END;  
             --SALDO TOTAL DE CAPITAL PENDIENTE DE PAGO
             BEGIN
                 SELECT f11.scsdo
                   INTO tmp_scsdo
                   FROM FSD011 f11
                  WHERE f11.pgcod  = 1
                    and f11.scmod  = l.bcmod
                    and f11.scsuc  = l.bcsuc
                    and f11.scmda  = l.bcmda
                    and f11.scpap  = l.bcpap
                    and f11.sccta  = l.bccta
                    and f11.scoper = l.bcoper
                    and f11.scsbop = l.bcsbop
                    and f11.sctope = l.bctop;
             EXCEPTION
               WHEN OTHERS THEN
                    null; 
               END;
              --CUOTA MAYOR, CUOTA MENOR, CUOTA AJUSTE,FECHA DE VENCIMIENTO DEL ULTIMO PAGO.
             BEGIN
                 pq_cr_reporte_crd_consumo.sp_cuo_my_mn_aj(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        tmp_cuo_my, --CUOTA MAYOR
                                                        tmp_cuo_mn, --CUOTA MENOR
                                                        tmp_cuo_aj);--CUOTA AJUSTE
                  
               EXCEPTION
                 WHEN OTHERS THEN
                   NULL;    
               END; 
             --TIPO DE ESQUEMA
             pq_cr_reporte_crd_consumo.sp_esquema_cuota(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        ln_esquema, --DEVUELVE ESQUEMA 0 FIJO 1 DISTINTO
                                                        ln_tot_cuo,
                                                        ln_tot_cuoesq);-- TOTAL DE CUOTAS PENDIENTES DE PAGO. 
             
             
             
             --CALCULANDO AÑOS REMANENTES
             BEGIN
               IF ln_esquema = 0 then
                  ln_num_rem:= (ln_tot_cuo/tmp_cuo_mn)/vl_per_num;
               ELSE
                  ln_num_rem:= (ln_tot_cuo/tmp_cuo_mn)/vl_per_num; 
                  --ln_num_rem:= (ln_tot_cuoesq/tmp_cuo_mn)/vl_per_num; 
               END IF;
                  
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;
               END;     
             --CALCULANDO FACTOR DE PONDERACION           
             BEGIN
               SELECT A.AQPB552FPN
                 INTO ln_fac_pon
                 FROM AQPB552 A
                WHERE A.AQPB552MOD = l.bcmod
                  AND A.AQPB552RAI <= ln_num_rem
                  AND A.AQPB552RAF >= ln_num_rem;
               EXCEPTION
                 WHEN OTHERS THEN
                      BEGIN --EN CASO DE NO ENCONTRAR EL MODULO PUSAR DEFAULT
                           SELECT A.AQPB552FPN
                             INTO ln_fac_pon
                             FROM AQPB552 A
                            WHERE A.AQPB552MOD = 0
                              AND A.AQPB552RAI <= ln_num_rem
                              AND A.AQPB552RAF >= ln_num_rem;
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
             END;         
             --OBTENIEDO cronograma_clientes Y SALDOS
             for crn in cronograma_clientes(
                                          1, --pgcod      
                                          l.bcmod,
                                          l.bcsuc,
                                          l.bcmda,
                                          l.bcpap,
                                          l.bccta,
                                          l.bcoper,
                                          l.bcsbop,
                                          l.bctop,
                                          tmp_fec_pag
                                         ) loop
            begin
              tmp_cuo_liq := 0;
              tmp_ppcap := 0;
              tmp_ppint := 0;
              --OBTENGO PAGOS REALIZADOS
              begin
                SELECT 1
                  INTO tmp_cuo_liq
                  FROM fsd602 d2
                 WHERE d2.pgcod = crn.pgcod
                   and d2.ppmod = crn.ppmod
                   and d2.ppsuc = crn.ppsuc
                   and d2.ppmda = crn.ppmda
                   and d2.pppap = crn.pppap
                   and d2.ppcta = crn.ppcta
                   and d2.ppoper = crn.ppoper
                   and d2.ppsbop = crn.ppsbop
                   and d2.pptope = crn.pptope
                   and d2.ppfpag = crn.ppfpag
                   and d2.pp1stat = 'T'; --BUSCO SI YA HA SIDO CANCELADA.
                exception
                  WHEN NO_DATA_FOUND THEN
                     --CASO CONTRARIO SUMO LOS PAGOS PARCIALES PARA RESTALE AL PENDIENTE Y/O RESTO A LA CUOTA ITERADA.
                    BEGIN
                      SELECT 0,
                             sum(d2.pp1cap), --CAPITAL TOTAL PAGADO
                             sum(d2.pp1int) --INTERES TOTAL PAGADO
                        INTO tmp_cuo_liq,
                             tmp_ppcap,
                             tmp_ppint
                        FROM fsd602 d2
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                  when others then
                    --CASO CONTRARIO SUMO LOS PAGOS PARCIALES PARA RESTALE AL PENDIENTE Y/O RESTO A LA CUOTA ITERADA.
                    BEGIN
                      SELECT 0,
                             sum(d2.pp1cap), --CAPITAL TOTAL PAGADO
                             sum(d2.pp1int) --INTERES TOTAL PAGADO
                        INTO tmp_cuo_liq,
                             tmp_ppcap,
                             tmp_ppint
                        FROM fsd602 d2
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                    --Seguro
                    tmp_seguro:=0;
                    BEGIN
                      SELECT (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)
                             - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0)) --SEGUROS
                        INTO tmp_seguro
                        FROM fsd611 d2 left join fsd612 d02 
                          on d02.pgcod =   d2.pgcod
                         and d02.ppmod =   d2.ppmod 
                         and d02.ppsuc =   d2.ppsuc
                         and d02.ppmda =   d2.ppmda 
                         and d02.pppap =   d2.pppap
                         and d02.ppcta =   d2.ppcta
                         and d02.ppoper =  d2.ppoper
                         and d02.ppsbop =  d2.ppsbop
                         and d02.pptope =  d2.pptope
                         and d02.ppfpag =  d2.ppfpag
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                    
                END;
                --FIN DE PAGOS REALIZADOS
                --VALIDO CUOTAS PENDIENTE DE PAGO Y RESTO PAGO PARCIAL. (CAPITAL E INTERES)
                if tmp_cuo_liq=1 then
                  ln_ppcap:=0;
                  ln_ppint:=0;
                else
                  ln_ppcap:= crn.ppcap - nvl(tmp_ppcap,0);
                  ln_ppint:= crn.ppint - nvl(tmp_ppint,0);
                end if;
                --dbms_output.put_line('ln_cap:'||ln_ppcap);
                --dbms_output.put_line('ln_int:'||ln_ppint);
              exception 
                when others then
                  null;                           
              end;
              --INSERTANDO REGISTROS
              /*
              dbms_output.put_line('l.bcsuc:'||l.bcsuc);
              dbms_output.put_line('l.bcmda:'||l.bcmda);
              dbms_output.put_line('l.bccta:'||l.bccta);
              dbms_output.put_line('l.bcoper:'||l.bcoper);
              dbms_output.put_line('l.bcpap:'||l.bcpap);
              dbms_output.put_line('l.bcsbop:'||l.bcsbop);
              dbms_output.put_line('l.bctop:'||l.bctop);
              dbms_output.put_line('l.bcrubr:'||l.bcrubr);
              dbms_output.put_line('l.bcgpodes:'||l.bcgpodes);
              dbms_output.put_line('vl_tsa:'||vl_tsa);
              dbms_output.put_line('vl_fec_ult_pag:'||vl_fec_ult_pag);
              dbms_output.put_line('ln_esquema:'||ln_esquema);
              dbms_output.put_line('vl_per_num:'||vl_per_num);
              dbms_output.put_line('vl_per_des:'||vl_per_des);
              dbms_output.put_line('ln_ppcap:'||ln_ppcap);
              dbms_output.put_line('ln_ppint:'||ln_ppint);
              dbms_output.put_line('tmp_scsdo:'||tmp_scsdo);
              dbms_output.put_line('ln_tot_cuo:'||ln_tot_cuo);
              dbms_output.put_line('tmp_cuo_mn:'||tmp_cuo_mn);
              dbms_output.put_line('tmp_cuo_my:'||tmp_cuo_my);
              dbms_output.put_line('tmp_cuo_aj:'||tmp_cuo_aj);                            
              dbms_output.put_line('ln_num_rem:'||ln_num_rem);
              dbms_output.put_line('ln_fac_pon:'||ln_fac_pon); 
              */  
              BEGIN           
              INSERT INTO 
              AQPB551(
                        AQPB551PGC  , AQPB551MOD,AQPB551SUC,AQPB551MDA,
                        AQPB551CCTA , AQPB551OPER,AQPB551PAP,AQPB551SBOP,AQPB551TOPE,
                        AQPB551RUBR , AQPB551TSBS,AQPB551TEA,AQPB551FECC,AQPB551FECV,
                        AQPB551TESQ , AQPB551PERT,AQPB551PERN,AQPB551SDOC,AQPB551CAPC,
                        AQPB551INTC , AQPB551CAPT,AQPB551SDOT,AQPB551CUOMN,AQPB551CUOMY,
                        AQPB551CUOAJ ,AQPB551NARM,AQPB551FPON,AQPB551USRR,AQPB551FECR,AQPB551FECON,AQPB551FECUO)
                        VALUES (
                        1  , l.bcmod,l.bcsuc,l.bcmda,
                        l.bccta , l.bcoper,l.bcpap,l.bcsbop,l.bctop,
                        l.bcrubr , l.bcgpodes,vl_tsa,pd_fecpro,vl_fec_ult_pag,
                        ln_esquema ,vl_per_des , vl_per_num,(ln_ppcap+ln_ppint+nvl(tmp_seguro,0)),ln_ppcap,
                        ln_ppint , -tmp_scsdo,ln_tot_cuo,tmp_cuo_mn,tmp_cuo_my,
                        tmp_cuo_aj ,ln_num_rem,ln_fac_pon,pc_usr,SYSDATE,pd_fecpro,CRN.PPFPAG
                        );
              EXCEPTION 
                WHEN OTHERS THEN
                  DBMS_OUTPUT.put_line(SQLERRM) ;         
              END;                                                 
              end loop; 
                                          
       end loop;
     end; 
   
   Procedure sp_report_esquema_cronog_s(
                                       pd_fecpro in date,
                                       pc_usr    in varchar,
                                       sucurs    in number
                                       ) is
   --Cursores
   --CURSOS PARA CREDITOS A EVALUAR
   cursor lista_creditos_cierres is 
    select h.bccta, --CUENTA
           h.bcmod, --MODULO
           h.bcsuc, --SUCURSAL
           h.bcmda, --MONEDA
           h.bcpap, --PAPEL
           h.bcoper, --OPERACION
           h.bcsbop, --SUBOPERACION
           h.bctop, --TIPO DE OPERACION
           h.bcfech, --FECHA DE CIERRE
           h.bcgpo, --TIPO DE CREDITO
           h.bcrubr, --RUBRO
           case
             when h.BCGpo = 3 and substr(h.bcrubr, 11, 3) = '015' then
              'CONSUMO REVOLVENTE'
             when h.BCGpo = 3 and substr(h.bcrubr, 11, 3) <> '015' then
              'CONSUMO NO REVOLVENTE'
           END bcgpodes --TIPO DE CREDITO SBS
      from fsh012 h
     where h.bcemp = 1
       and h.bcfech = to_date(pd_fecpro, 'dd/mm/rrrr')
       and substr(h.bcrubr, 1, 4) in
           (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
       and h.bccta <> 0
       and h.bcsuc = sucurs
       and h.bcgpo = 3
       and h.bcpzo<>5
       and h.bcoper <> 0;
       --and h.bccta =232766;   
       --and h.bcmod = 107
       --and rownum <1;
       --and h.bccta =1045705
       --and h.bcoper=8969447;
   --CURSOS PARA OBTENER EL CRONOGRAMA DE PAGOS DEL CREDITO.    
   cursor cronograma_clientes( vipgcod in fsd601.pgcod%TYPE,
                               vippmod in fsd601.ppmod%TYPE,
                               vippsuc in fsd601.ppsuc%TYPE,
                               vippmda in fsd601.ppmda%TYPE,
                               vipppap in fsd601.pppap%TYPE,
                               vippcta in fsd601.ppcta%TYPE,
                               vippoper in fsd601.ppoper%TYPE,
                               vippsbop in fsd601.ppsbop%TYPE,
                               vipptope in fsd601.pptope%TYPE,
                               vippfpag in fsd601.ppfpag%TYPE                          
                             ) is
   select d.*
     from fsd601  d
    where pgcod = vipgcod
      and ppmod = vippmod
      and ppsuc = vippsuc
      and ppmda = vippmda
      and pppap = vipppap
      and ppcta = vippcta
      and ppoper = vippoper
      and ppsbop = vippsbop
      and pptope = vipptope
      and ppfpag >= vippfpag;
       
   --Variables internas      
   ln_emp       number(3);
   ln_mod       number(3);
   ln_suc       number(3);
   ln_mda       number(4);
   ln_pap       number(4);
   ln_cta       number(9);
   ln_ope       number(9);
   ln_sbo       number(3);
   ln_top       number(3);
   vl_tsa       decimal(17,6);
   vl_per_num   number(3);
   vl_per_des   varchar(10);
   vl_fec_ult_pag date;
   ln_ppcap     fsd601.ppcap%type;
   ln_ppint     fsd601.ppint%type;
   
   --TEMPORALES
   tmp_fec_pag date;
   tmp_cuo_liq number(1);
   tmp_ppcap fsd601.ppcap%type;
   tmp_ppint fsd601.ppint%type;
   tmp_cuo_my decimal(17,2);
   tmp_cuo_mn decimal(17,2);
   tmp_cuo_aj decimal(17,2);
   tmp_scsdo decimal(17,2);
   tmp_seguro number(17,2);
   --
   ln_esquema number(3);
   ln_tot_cuo decimal(17,2);
   ln_num_rem decimal(17,2);
   ln_fac_pon decimal(5,2);
   ln_seguro number(17,2);
   ln_tot_cuoesq number(17,2);
   begin
       --execute immediate 'delete from AQPB551 where AQPB551USRR= :pc_usr' using pc_usr;
       commit;
       for l in lista_creditos_cierres loop
           --INICIALIZANDO VARIABLES
           vl_tsa := 0;
           vl_per_num:=0;
           tmp_cuo_my := 0;
           tmp_cuo_mn := 0;
           tmp_cuo_aj := 0;
           --OBTENIENDO TASA
           begin
             pq_cr_reporte_crd_consumo.sp_tasa_credito(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        vl_tsa);--tasa
                                                        
             exception
                 when others then
                   vl_tsa:= 0;  
             end;
                          
             --OBTENIENDO PERIODO
             BEGIN
               pq_cr_reporte_crd_consumo.sp_periodo_crd(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        vl_per_des, --PERIODO TEXTO
                                                        vl_per_num);--PERIODO NUMERO
             
             --FIN CALCULO
             EXCEPTION 
               WHEN OTHERS THEN
                 null;
             END;  
             --OBTENER LA FECHA DE ULTIMO PAGO, FECHA DE ULTIMA CUOTA SEGUN CRONOGRAMA
             BEGIN
               SELECT max(ppfpag)
                  INTO vl_fec_ult_pag  
                      FROM fsd601
                     where pgcod = 1
                       and ppmod = l.bcmod
                       and ppsuc = l.bcsuc
                       and ppmda = l.bcmda
                       and pppap = l.bcpap
                       and ppcta = l.bccta
                       and ppoper = l.bcoper
                       and ppsbop = l.bcsbop
                       and pptope = l.bctop;
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;
               END;  
             --OBTENER ANTES LA FECHA PROGRAMADA  DEL ULTIMO PAGO REALIZADO
             
             BEGIN
                  SELECT CASE WHEN pp1stat='T' THEN (ppfpag+1) ELSE (ppfpag) END
                  INTO tmp_fec_pag  
                      FROM fsd602
                     where pgcod = 1
                       and ppmod = l.bcmod
                       and ppsuc = l.bcsuc
                       and ppmda = l.bcmda
                       and pppap = l.bcpap
                       and ppcta = l.bccta
                       and ppoper = l.bcoper
                       and ppsbop = l.bcsbop
                       and pptope = l.bctop
                       and ppfpag = (select max(d.ppfpag)
                                       from fsd602  d
                                      where d.pgcod = 1
                                        and d.ppmod = l.bcmod
                                        and d.ppsuc = l.bcsuc
                                        and d.ppmda = l.bcmda
                                        and d.pppap = l.bcpap
                                        and d.ppcta = l.bccta
                                        and d.ppoper = l.bcoper
                                        and d.ppsbop = l.bcsbop
                                        and d.pptope = l.bctop 
                                        AND ROWNUM=1)
                      AND d602fc = (SELECT max(dd.d602fc) 
                                      FROM fsd602 dd 
                                    where dd.pgcod =  1
                                       and dd.ppmod =  l.bcmod
                                       and dd.ppsuc =  l.bcsuc
                                       and dd.ppmda =  l.bcmda
                                       and dd.pppap =  l.bcpap
                                       and dd.ppcta =  l.bccta
                                       and dd.ppoper = l.bcoper
                                       and dd.ppsbop = l.bcsbop
                                       and dd.pptope = l.bctop)
                     AND ROWNUM = 1;  
             EXCEPTION 
               WHEN OTHERS THEN
                  --EN CASO DE NO TENER PAGOS SE TOMA LA FECHA PROGRAMADA DEL PRIMER PAGO A REALIZAR DEL CRONOGRAMA
                  SELECT MIN(ppfpag)
                  into tmp_fec_pag
                    FROM fsd601
                   where pgcod = 1
                     and ppmod = l.bcmod
                     and ppsuc = l.bcsuc
                     and ppmda = l.bcmda
                     and pppap = l.bcpap
                     and ppcta = l.bccta
                     and ppoper = l.bcoper
                     and ppsbop = l.bcsbop
                     and pptope = l.bctop;
             END;  
             --SALDO TOTAL DE CAPITAL PENDIENTE DE PAGO
             BEGIN
                 SELECT f11.scsdo
                   INTO tmp_scsdo
                   FROM FSD011 f11
                  WHERE f11.pgcod  = 1
                    and f11.scmod  = l.bcmod
                    and f11.scsuc  = l.bcsuc
                    and f11.scmda  = l.bcmda
                    and f11.scpap  = l.bcpap
                    and f11.sccta  = l.bccta
                    and f11.scoper = l.bcoper
                    and f11.scsbop = l.bcsbop
                    and f11.sctope = l.bctop;
             EXCEPTION
               WHEN OTHERS THEN
                    null; 
               END;
              --CUOTA MAYOR, CUOTA MENOR, CUOTA AJUSTE,FECHA DE VENCIMIENTO DEL ULTIMO PAGO.
             BEGIN
                 pq_cr_reporte_crd_consumo.sp_cuo_my_mn_aj(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        tmp_cuo_my, --CUOTA MAYOR
                                                        tmp_cuo_mn, --CUOTA MENOR
                                                        tmp_cuo_aj);--CUOTA AJUSTE
                  
               EXCEPTION
                 WHEN OTHERS THEN
                   NULL;    
               END; 
             --TIPO DE ESQUEMA
             pq_cr_reporte_crd_consumo.sp_esquema_cuota(1,
                                                        l.bcmod,
                                                        l.bcsuc,
                                                        l.bcmda,
                                                        l.bcpap,
                                                        l.bccta,
                                                        l.bcoper,
                                                        l.bcsbop,
                                                        l.bctop,
                                                        ln_esquema, --DEVUELVE ESQUEMA 0 FIJO 1 DISTINTO
                                                        ln_tot_cuo,
                                                        ln_tot_cuoesq);-- TOTAL DE CUOTAS PENDIENTES DE PAGO. 
             
             
             
             --CALCULANDO AÑOS REMANENTES
             BEGIN
               IF ln_esquema = 0 THEN
                  ln_num_rem:= (ln_tot_cuo/tmp_cuo_mn)/vl_per_num; -- PARA OBTNER PAGOS POR AÑO SE DIVIDE 12 / PERIODO
               ELSE
                  ln_num_rem:= (ln_tot_cuo/tmp_cuo_mn)/vl_per_num; -- PARA OBTNER PAGOS POR AÑO SE DIVIDE 12 / PERIODO
                  --ln_num_rem:= (ln_tot_cuoesq/tmp_cuo_mn)/vl_per_num; -- PARA OBTNER PAGOS POR AÑO SE DIVIDE 12 / PERIODO
               END IF;
               EXCEPTION 
                 WHEN OTHERS THEN
                   NULL;
               END;     
             --CALCULANDO FACTOR DE PONDERACION           
             BEGIN
               SELECT A.AQPB552FPN
                 INTO ln_fac_pon
                 FROM AQPB552 A
                WHERE A.AQPB552MOD = l.bcmod
                  AND A.AQPB552RAI <= ln_num_rem
                  AND A.AQPB552RAF >= ln_num_rem;
               EXCEPTION
                 WHEN OTHERS THEN
                      BEGIN --EN CASO DE NO ENCONTRAR EL MODULO PUSAR DEFAULT
                           SELECT A.AQPB552FPN
                             INTO ln_fac_pon
                             FROM AQPB552 A
                            WHERE A.AQPB552MOD = 0
                              AND A.AQPB552RAI <= ln_num_rem
                              AND A.AQPB552RAF >= ln_num_rem;
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
             END;         
             --OBTENIEDO cronograma_clientes Y SALDOS
             for crn in cronograma_clientes(
                                          1, --pgcod      
                                          l.bcmod,
                                          l.bcsuc,
                                          l.bcmda,
                                          l.bcpap,
                                          l.bccta,
                                          l.bcoper,
                                          l.bcsbop,
                                          l.bctop,
                                          tmp_fec_pag
                                         ) loop
            begin
              tmp_cuo_liq := 0;
              tmp_ppcap := 0;
              tmp_ppint := 0;
              ln_seguro := 0;
              --OBTENGO PAGOS REALIZADOS
              begin
                SELECT 1
                  INTO tmp_cuo_liq
                  FROM fsd602 d2
                 WHERE d2.pgcod = crn.pgcod
                   and d2.ppmod = crn.ppmod
                   and d2.ppsuc = crn.ppsuc
                   and d2.ppmda = crn.ppmda
                   and d2.pppap = crn.pppap
                   and d2.ppcta = crn.ppcta
                   and d2.ppoper = crn.ppoper
                   and d2.ppsbop = crn.ppsbop
                   and d2.pptope = crn.pptope
                   and d2.ppfpag = crn.ppfpag
                   and d2.pp1stat = 'T'; --BUSCO SI YA HA SIDO CANCELADA.
                exception
                  WHEN NO_DATA_FOUND THEN
                    --CASO CONTRARIO SUMO LOS PAGOS PARCIALES PARA RESTALE AL PENDIENTE Y/O RESTO A LA CUOTA ITERADA.
                    BEGIN
                      SELECT 0,
                             sum(d2.pp1cap), --CAPITAL TOTAL PAGADO
                             sum(d2.pp1int) --INTERES TOTAL PAGADO
                        INTO tmp_cuo_liq,
                             tmp_ppcap,
                             tmp_ppint
                        FROM fsd602 d2
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                  when others then
                    --CASO CONTRARIO SUMO LOS PAGOS PARCIALES PARA RESTALE AL PENDIENTE Y/O RESTO A LA CUOTA ITERADA.
                    BEGIN
                      SELECT 0,
                             sum(d2.pp1cap), --CAPITAL TOTAL PAGADO
                             sum(d2.pp1int) --INTERES TOTAL PAGADO
                        INTO tmp_cuo_liq,
                             tmp_ppcap,
                             tmp_ppint
                        FROM fsd602 d2
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                END;
                --Seguro
                    tmp_seguro:=0;
                    BEGIN
                      SELECT (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)
                             - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0)) --SEGUROS
                        INTO tmp_seguro
                        FROM fsd611 d2 left join fsd612 d02 
                          on d02.pgcod =   d2.pgcod
                         and d02.ppmod =   d2.ppmod 
                         and d02.ppsuc =   d2.ppsuc
                         and d02.ppmda =   d2.ppmda 
                         and d02.pppap =   d2.pppap
                         and d02.ppcta =   d2.ppcta
                         and d02.ppoper =  d2.ppoper
                         and d02.ppsbop =  d2.ppsbop
                         and d02.pptope =  d2.pptope
                         and d02.ppfpag =  d2.ppfpag
                       WHERE d2.pgcod = crn.pgcod
                         and d2.ppmod = crn.ppmod
                         and d2.ppsuc = crn.ppsuc
                         and d2.ppmda = crn.ppmda
                         and d2.pppap = crn.pppap
                         and d2.ppcta = crn.ppcta
                         and d2.ppoper = crn.ppoper
                         and d2.ppsbop = crn.ppsbop
                         and d2.pptope = crn.pptope
                         and d2.ppfpag = crn.ppfpag;
                    exception when
                       others then null;
                    END;
                --FIN DE PAGOS REALIZADOS
                --VALIDO CUOTAS PENDIENTE DE PAGO Y RESTO PAGO PARCIAL. (CAPITAL E INTERES)
                if tmp_cuo_liq=1 then
                  ln_ppcap:=0;
                  ln_ppint:=0;
                else
                  ln_ppcap:= crn.ppcap - nvl(tmp_ppcap,0);
                  ln_ppint:= crn.ppint - nvl(tmp_ppint,0);
                end if;
                --dbms_output.put_line('ln_cap:'||ln_ppcap);
                --dbms_output.put_line('ln_int:'||ln_ppint);
              exception 
                when others then
                  null;                           
              end;
              --AGREGANDO SEGUROS A LA CUOTA.
     begin
       SELECT (d1.ppimp10+d1.ppimp11+d1.ppimp12+d1.ppimp13+d1.ppimp14+d1.ppimp15+d1.ppimp16+d1.ppimp17+d1.ppimp18+d1.ppimp19+d1.ppimp20) -
              nvl(d12.pp1imp10+d12.pp1imp11+d12.pp1imp12+d12.pp1imp13+d12.pp1imp14+d12.pp1imp15+d12.pp1imp16+d12.pp1imp17+d12.pp1imp18+d12.pp1imp19+d12.pp1imp20,0)
         INTO ln_seguro
         FROM FSD611 d1
         LEFT JOIN FSD612 d12
           ON d12.pgcod = d1.pgcod
          and d12.ppmod = d1.ppmod
          and d12.ppsuc = d1.ppsuc
          and d12.ppmda = d1.ppmda
          and d12.pppap = d1.pppap
          and d12.ppcta = d1.ppcta
          and d12.ppoper = d1.ppoper
          and d12.ppsbop = d1.ppsbop
          and d12.pptope = d1.pptope
          and d12.ppfpag = d1.ppfpag
        WHERE d1.pgcod = crn.pgcod
          and d1.ppmod = crn.ppmod
          and d1.ppsuc = crn.ppsuc
          and d1.ppmda = crn.ppmda
          and d1.pppap = crn.pppap
          and d1.ppcta = crn.ppcta
          and d1.ppoper = crn.ppoper
          and d1.ppsbop = crn.ppsbop
          and d1.pptope = crn.pptope
          and d1.ppfpag = crn.ppfpag;
       exception
         when others then
              ln_seguro := 0;                        
       end;
       --
              --INSERTANDO REGISTROS
              /*
              dbms_output.put_line('l.bcsuc:'||l.bcsuc);
              dbms_output.put_line('l.bcmda:'||l.bcmda);
              dbms_output.put_line('l.bccta:'||l.bccta);
              dbms_output.put_line('l.bcoper:'||l.bcoper);
              dbms_output.put_line('l.bcpap:'||l.bcpap);
              dbms_output.put_line('l.bcsbop:'||l.bcsbop);
              dbms_output.put_line('l.bctop:'||l.bctop);
              dbms_output.put_line('l.bcrubr:'||l.bcrubr);
              dbms_output.put_line('l.bcgpodes:'||l.bcgpodes);
              dbms_output.put_line('vl_tsa:'||vl_tsa);
              dbms_output.put_line('vl_fec_ult_pag:'||vl_fec_ult_pag);
              dbms_output.put_line('ln_esquema:'||ln_esquema);
              dbms_output.put_line('vl_per_num:'||vl_per_num);
              dbms_output.put_line('vl_per_des:'||vl_per_des);
              dbms_output.put_line('ln_ppcap:'||ln_ppcap);
              dbms_output.put_line('ln_ppint:'||ln_ppint);
              dbms_output.put_line('tmp_scsdo:'||tmp_scsdo);
              dbms_output.put_line('ln_tot_cuo:'||ln_tot_cuo);
              dbms_output.put_line('tmp_cuo_mn:'||tmp_cuo_mn);
              dbms_output.put_line('tmp_cuo_my:'||tmp_cuo_my);
              dbms_output.put_line('tmp_cuo_aj:'||tmp_cuo_aj);                            
              dbms_output.put_line('ln_num_rem:'||ln_num_rem);
              dbms_output.put_line('ln_fac_pon:'||ln_fac_pon); 
              */             
              if ln_ppcap<>0 or ln_ppint<>0 then
              INSERT INTO 
              AQPB551(
                        AQPB551PGC  , AQPB551MOD,AQPB551SUC,AQPB551MDA,
                        AQPB551CCTA , AQPB551OPER,AQPB551PAP,AQPB551SBOP,AQPB551TOPE,
                        AQPB551RUBR , AQPB551TSBS,AQPB551TEA,AQPB551FECC,AQPB551FECV,
                        AQPB551TESQ , AQPB551PERT,AQPB551PERN,AQPB551SDOC,AQPB551CAPC,
                        AQPB551INTC , AQPB551CAPT,AQPB551SDOT,AQPB551CUOMN,AQPB551CUOMY,
                        AQPB551CUOAJ ,AQPB551NARM,AQPB551FPON,AQPB551USRR,AQPB551FECR,AQPB551FECON,AQPB551FECUO)
                        VALUES (
                        1  , l.bcmod,l.bcsuc,l.bcmda,
                        l.bccta , l.bcoper,l.bcpap,l.bcsbop,l.bctop,
                        l.bcrubr , l.bcgpodes,vl_tsa,pd_fecpro,vl_fec_ult_pag,
                        ln_esquema ,vl_per_des , vl_per_num,(ln_ppcap+ln_ppint+ln_seguro),ln_ppcap,
                        ln_ppint , -tmp_scsdo,ln_tot_cuo,tmp_cuo_mn,tmp_cuo_my,
                        tmp_cuo_aj ,ln_num_rem,ln_fac_pon,pc_usr,SYSDATE,pd_fecpro,CRN.PPFPAG
                        );
              end if;
              COMMIT;              
              end loop; 
                                          
       end loop;
     end; 
   
   procedure sp_tasa_credito(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_tasa out fsd010.aotasa%type --TASA
     ) is
   begin
     begin
             select evtasa
               into ve_tasa 
               from fsd012
              where pgcod  = ve_pgcod
                and aomod  = ve_ppmod
                and aosuc  = ve_ppsuc
                and aomda  = ve_ppmda
                and aopap  = ve_pppap
                and aocta  = ve_ppcta
                and aooper = ve_ppoper
                and aosbop = ve_ppsbop
                and aotope = ve_pptope
                and evtipo = 3
                and d012co = 'S';
             exception 
               when others then
                    begin
                      select aotasa
                        into ve_tasa
                        from fsd010
                       where pgcod = ve_pgcod
                         and aomod = ve_ppmod
                         and aosuc = ve_ppsuc
                         and aomda = ve_ppmda
                         and aopap = ve_pppap
                         and aocta = ve_ppcta
                         and aooper = ve_ppoper
                         and aosbop = ve_ppsbop
                         and aotope = ve_pptope;
                      exception
                        when others then
                           ve_tasa:=0;    
                      end;      
             end;
     end;
   
   procedure sp_cuo_my_mn_aj(   
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_cuo_my out fsd010.aoimp%type, --CUOTA MAYOR
                               ve_cuo_mn out fsd010.aoimp%type, --CUOTA MENOR
                               ve_cuo_aj out fsd010.aoimp%type  --CUOTA AJUSTE
                              ) is
   vi_fpagMax date;
   vi_estcuota varchar(1);                         
   begin
     BEGIN
       /*
          select max(d1.ppcap + d1.ppint + nvl(d21.ppimp10+d21.ppimp11+d21.ppimp12+d21.ppimp13+d21.ppimp14+d21.ppimp15+d21.ppimp16+d21.ppimp17+d21.ppimp18+d21.ppimp19+d21.ppimp20,0)), --MAXIMA CUOTA
                 (select min(d2.ppcap + d2.ppint + nvl(d321.ppimp10+d321.ppimp11+d321.ppimp12+d321.ppimp13+d321.ppimp14+d321.ppimp15+d321.ppimp16+d321.ppimp17+d321.ppimp18+d321.ppimp19+d321.ppimp20,0))
                    from fsd601 d2 left join fsd611 d321
                    on d321.pgcod = d2.pgcod
                       and d321.ppmod = d2.ppmod
                       and d321.ppsuc = d2.ppsuc
                       and d321.ppmda = d2.ppmda
                       and d321.pppap = d2.pppap
                       and d321.ppcta = d2.ppcta
                       and d321.ppoper = d2.ppoper
                       and d321.ppsbop = d2.ppsbop
                       and d321.pptope = d2.pptope
                       and d321.ppfpag = d2.ppfpag
                   where d2.pgcod = ve_pgcod
                       and d2.ppmod = ve_ppmod
                       and d2.ppsuc = ve_ppsuc
                       and d2.ppmda = ve_ppmda
                       and d2.pppap = ve_pppap
                       and d2.ppcta = ve_ppcta
                       and d2.ppoper = ve_ppoper
                       and d2.ppsbop = ve_ppsbop
                       and d2.pptope = ve_pptope
                       and d2.ppfpag < (select max(ppfpag) --CONDCION PARA CON CONSIDERAR LA ULTIMA CUOTA DE AJUSTE Y OBTENER LA MENOR CUOTA.
                                          from fsd601 d01
                                         where d01.pgcod = ve_pgcod
                                           and d01.ppmod = ve_ppmod
                                           and d01.ppsuc = ve_ppsuc
                                           and d01.ppmda = ve_ppmda
                                           and d01.pppap = ve_pppap
                                           and d01.ppcta = ve_ppcta
                                           and d01.ppoper = ve_ppoper
                                           and d01.ppsbop = ve_ppsbop
                                           and d01.pptope = ve_pptope)), --MENOR CUOTA
                   (select d3.ppcap + d3.ppint + nvl(d221.ppimp10+d221.ppimp11+d221.ppimp12+d221.ppimp13+d221.ppimp14+d221.ppimp15+d221.ppimp16+d221.ppimp17+d221.ppimp18+d221.ppimp19+d221.ppimp20,0)
                    from fsd601 d3 left join fsd611 d221
                    on d221.pgcod = d3.pgcod
                       and d221.ppmod = d3.ppmod
                       and d221.ppsuc = d3.ppsuc
                       and d221.ppmda = d3.ppmda
                       and d221.pppap = d3.pppap
                       and d221.ppcta = d3.ppcta
                       and d221.ppoper = d3.ppoper
                       and d221.ppsbop = d3.ppsbop
                       and d221.pptope = d3.pptope
                       and d221.ppfpag = d3.ppfpag
                   where d3.pgcod = ve_pgcod
                       and d3.ppmod = ve_ppmod
                       and d3.ppsuc = ve_ppsuc
                       and d3.ppmda = ve_ppmda
                       and d3.pppap = ve_pppap
                       and d3.ppcta = ve_ppcta
                       and d3.ppoper = ve_ppoper
                       and d3.ppsbop = ve_ppsbop
                       and d3.pptope = ve_pptope
                       and d3.ppfpag = (select max(ppfpag) --CONDCION PARA CON CONSIDERAR LA ULTIMA CUOTA.
                                          from fsd601 d01
                                         where d01.pgcod = ve_pgcod
                                           and d01.ppmod = ve_ppmod
                                           and d01.ppsuc = ve_ppsuc
                                           and d01.ppmda = ve_ppmda
                                           and d01.pppap = ve_pppap
                                           and d01.ppcta = ve_ppcta
                                           and d01.ppoper = ve_ppoper
                                           and d01.ppsbop = ve_ppsbop
                                           and d01.pptope = ve_pptope)) --AJUSTE Y/O ULTIMA CUOTA
            into ve_cuo_my,
                 ve_cuo_mn,
                 ve_cuo_aj
            from fsd601 d1 left join fsd611 d21
                    on d21.pgcod = d1.pgcod
                       and d21.ppmod = d1.ppmod
                       and d21.ppsuc = d1.ppsuc
                       and d21.ppmda = d1.ppmda
                       and d21.pppap = d1.pppap
                       and d21.ppcta = d1.ppcta
                       and d21.ppoper = d1.ppoper
                       and d21.ppsbop = d1.ppsbop
                       and d21.pptope = d1.pptope
                       and d21.ppfpag = d1.ppfpag
           where d1.pgcod =  ve_pgcod
             and d1.ppmod =  ve_ppmod
             and d1.ppsuc =  ve_ppsuc
             and d1.ppmda =  ve_ppmda
             and d1.pppap =  ve_pppap
             and d1.ppcta =  ve_ppcta
             and d1.ppoper = ve_ppoper
             and d1.ppsbop = ve_ppsbop
             and d1.pptope = ve_pptope
           group by d1.ppcta;
       */
       -- Fecha de Ultimo Pago
       BEGIN
           select max(ppfpag)
             into vi_fpagMax
            from fsd602 sd2 
           where sd2.pgcod =   ve_pgcod
             and sd2.ppmod =   ve_ppmod
             and sd2.ppsuc =   ve_ppsuc
             and sd2.ppmda =   ve_ppmda
             and sd2.pppap =   ve_pppap
             and sd2.ppcta =   ve_ppcta
             and sd2.ppoper =  ve_ppoper
             and sd2.ppsbop =  ve_ppsbop
             and sd2.pptope =  ve_pptope
             AND ROWNUM=1;
           ---estado del ultimo pago
           select pp1stat
             into vi_estcuota
            from fsd602 sd2 
           where sd2.pgcod =  ve_pgcod
             and sd2.ppmod =  ve_ppmod
             and sd2.ppsuc =  ve_ppsuc
             and sd2.ppmda =  ve_ppmda
             and sd2.pppap =  ve_pppap
             and sd2.ppcta =  ve_ppcta
             and sd2.ppoper = ve_ppoper
             and sd2.ppsbop = ve_ppsbop
             and sd2.pptope = ve_pptope
             and sd2.ppfpag = vi_fpagMax
             and sd2.d602fc = (SELECT max(d602fc) FROM fsd602 dd 
                                                where dd.pgcod =  ve_pgcod
                                                   and dd.ppmod =  ve_ppmod
                                                   and dd.ppsuc =  ve_ppsuc
                                                   and dd.ppmda =  ve_ppmda
                                                   and dd.pppap =  ve_pppap
                                                   and dd.ppcta =  ve_ppcta
                                                   and dd.ppoper = ve_ppoper
                                                   and dd.ppsbop = ve_ppsbop
                                                   and dd.pptope = ve_pptope);
             
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
               vi_fpagMax:= to_date('01/01/1990','dd/mm/yyyy');
               vi_estcuota:='N';
         WHEN OTHERS THEN
               vi_fpagMax:= to_date('01/01/1990','dd/mm/yyyy');
               vi_estcuota:='N';     
       END; 
        
       if vi_estcuota = 'P' then
          vi_fpagMax:= vi_fpagMax-1;
       end if;  
       
       --MAXIMA Y MINIMA CUOTA
       select max(((d1.ppcap+d1.ppint
                  - nvl((d01.pp1icap+d01.pp1int),0)) 
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)
                  - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0))
                  )) maxima_cuota,
              min(( (d1.ppcap+d1.ppint
                  - nvl((d01.pp1icap+d01.pp1int),0)) 
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)
                  - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0))
                  )) minima_cuota
        into ve_cuo_my,
             ve_cuo_mn          
        from fsd601 d1 left join fsd602 d01 
          on d01.pgcod =   d1.pgcod
         and d01.ppmod =   d1.ppmod 
         and d01.ppsuc =   d1.ppsuc
         and d01.ppmda =   d1.ppmda 
         and d01.pppap =   d1.pppap
         and d01.ppcta =   d1.ppcta
         and d01.ppoper =  d1.ppoper
         and d01.ppsbop =  d1.ppsbop
         and d01.pptope =  d1.pptope
         and d01.ppfpag =  d1.ppfpag
        left join fsd611 d2 
          on d1.pgcod =   d2.pgcod
         and d1.ppmod =   d2.ppmod 
         and d1.ppsuc =   d2.ppsuc
         and d1.ppmda =   d2.ppmda 
         and d1.pppap =   d2.pppap
         and d1.ppcta =   d2.ppcta
         and d1.ppoper =  d2.ppoper
         and d1.ppsbop =  d2.ppsbop
         and d1.pptope =  d2.pptope
         and d1.ppfpag =  d2.ppfpag
        left join fsd612 d02 
          on d02.pgcod =   d2.pgcod
         and d02.ppmod =   d2.ppmod 
         and d02.ppsuc =   d2.ppsuc
         and d02.ppmda =   d2.ppmda 
         and d02.pppap =   d2.pppap
         and d02.ppcta =   d2.ppcta
         and d02.ppoper =  d2.ppoper
         and d02.ppsbop =  d2.ppsbop
         and d02.pptope =  d2.pptope
         and d02.ppfpag =  d2.ppfpag 
       where d1.pgcod =   ve_pgcod
         and d1.ppmod =   ve_ppmod
         and d1.ppsuc =   ve_ppsuc
         and d1.ppmda =   ve_ppmda
         and d1.pppap =   ve_pppap
         and d1.ppcta =   ve_ppcta
         and d1.ppoper =  ve_ppoper
         and d1.ppsbop =  ve_ppsbop
         and d1.pptope =  ve_pptope
         and d1.ppfpag > vi_fpagMax
         and d1.ppfpag < (select max(ppfpag) --CONDCION PARA CON CONSIDERAR LA ULTIMA CUOTA.
                                          from fsd601 d01
                                         where d01.pgcod = ve_pgcod
                                           and d01.ppmod = ve_ppmod
                                           and d01.ppsuc = ve_ppsuc
                                           and d01.ppmda = ve_ppmda
                                           and d01.pppap = ve_pppap
                                           and d01.ppcta = ve_ppcta
                                           and d01.ppoper = ve_ppoper
                                           and d01.ppsbop = ve_ppsbop
                                           and d01.pptope = ve_pptope) --AJUSTE Y/O ULTIMA CUOTA  
         and d1.ppstat <> 'P';
       --CUOTA AJUSTE
                select ((d1.ppcap+d1.ppint) 
                        - nvl((d01.pp1icap+d01.pp1int),0)
                       + nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0) 
                       - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0) ) cuota_ajuste
                  into ve_cuo_aj      
                  from fsd601 d1 left join fsd602 d01 
                    on d01.pgcod =   d1.pgcod
                   and d01.ppmod =   d1.ppmod 
                   and d01.ppsuc =   d1.ppsuc
                   and d01.ppmda =   d1.ppmda 
                   and d01.pppap =   d1.pppap
                   and d01.ppcta =   d1.ppcta
                   and d01.ppoper =  d1.ppoper
                   and d01.ppsbop =  d1.ppsbop
                   and d01.pptope =  d1.pptope
                   and d01.ppfpag =  d1.ppfpag
                  left join fsd611 d2 
                    on d1.pgcod =   d2.pgcod
                   and d1.ppmod =   d2.ppmod 
                   and d1.ppsuc =   d2.ppsuc
                   and d1.ppmda =   d2.ppmda 
                   and d1.pppap =   d2.pppap
                   and d1.ppcta =   d2.ppcta
                   and d1.ppoper =  d2.ppoper
                   and d1.ppsbop =  d2.ppsbop
                   and d1.pptope =  d2.pptope
                   and d1.ppfpag =  d2.ppfpag
                  left join fsd612 d02 
                    on d02.pgcod =   d2.pgcod
                   and d02.ppmod =   d2.ppmod 
                   and d02.ppsuc =   d2.ppsuc
                   and d02.ppmda =   d2.ppmda 
                   and d02.pppap =   d2.pppap
                   and d02.ppcta =   d2.ppcta
                   and d02.ppoper =  d2.ppoper
                   and d02.ppsbop =  d2.ppsbop
                   and d02.pptope =  d2.pptope
                   and d02.ppfpag =  d2.ppfpag 
                     where d1.pgcod =   ve_pgcod
                       and d1.ppmod =   ve_ppmod
                       and d1.ppsuc =   ve_ppsuc
                       and d1.ppmda =   ve_ppmda
                       and d1.pppap =   ve_pppap
                       and d1.ppcta =   ve_ppcta
                       and d1.ppoper =  ve_ppoper
                       and d1.ppsbop =  ve_ppsbop
                       and d1.pptope =  ve_pptope
                       and d1.ppfpag = (select max(ppfpag) --CONDCION PARA CON CONSIDERAR LA ULTIMA CUOTA.
                                          from fsd601 d01
                                         where d01.pgcod = ve_pgcod
                                           and d01.ppmod = ve_ppmod
                                           and d01.ppsuc = ve_ppsuc
                                           and d01.ppmda = ve_ppmda
                                           and d01.pppap = ve_pppap
                                           and d01.ppcta = ve_ppcta
                                           and d01.ppoper = ve_ppoper
                                           and d01.ppsbop = ve_ppsbop
                                           and d01.pptope = ve_pptope); --AJUSTE Y/O ULTIMA CUOTA  
       EXCEPTION
         WHEN OTHERS THEN
           NULL;    
       END;
   end;
                         
   procedure sp_periodo_crd(   
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_pr_txt out varchar2, --PERIODO TEXTO
                               ve_pr_num out fsd010.aoimp%type --PERIODO NUMERO                               
                              ) is
   begin
             --OBTENIENDO PERIODO
             BEGIN
             select aoperiod
               into ve_pr_num
               from fsd010
              where pgcod = ve_pgcod
                and aomod = ve_ppmod
                and aosuc = ve_ppsuc
                and aomda = ve_ppmda
                and aopap = ve_pppap
                and aocta = ve_ppcta
                and aooper = ve_ppoper
                and aosbop = ve_ppsbop
                and aotope = ve_pptope;
             ve_pr_num := round(360/ve_pr_num); --el periodo se muestra en dias, se cambia a meses
             --dbms_output.put_line(ve_pr_num);
             --CALCULAR PERIODO DESZCRIPCION
             if ve_pr_num = 12 then
              ve_pr_txt := 'MENSUAL';
             end if; 
             if ve_pr_num = 6 then
              ve_pr_txt := 'BIMENSUAL';
             end if;
             if ve_pr_num = 4 then
              ve_pr_txt := 'TRIMESTRAL';
             end if;
             if ve_pr_num = 2 then
              ve_pr_txt := 'SEMESTRAL';
             end if;
             if ve_pr_num = 1 then
              ve_pr_txt := 'ANUAL';
             end if;
             dbms_output.put_line(ve_pr_num);
             dbms_output.put_line(ve_pr_txt);
             --FIN CALCULO
             EXCEPTION 
               WHEN OTHERS THEN
                 null;
             END;  
     end;                                    
     
   procedure sp_esquema_cuota(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type,
                               ve_esquema out number,
                               ve_to_cuot out fsd601.ppcap%type,
                               ve_to_cuot_rmn out fsd601.ppcap%type
     ) is
   --Cursores
   cursor cronograma_cuotas_pend is
     select *
     from fsd601 d1
     where d1.pgcod  = ve_pgcod 
       and d1.ppmod  = ve_ppmod
       and d1.ppsuc  = ve_ppsuc
       and d1.ppmda  = ve_ppmda
       and d1.pppap  = ve_pppap
       and d1.ppcta  = ve_ppcta
       and d1.ppoper = ve_ppoper
       and d1.ppsbop = ve_ppsbop
       and d1.pptope = ve_pptope
       and d1.ppfpag > (CASE WHEN (select max(ppfpag) from fsd602 d2 
           where d2.pgcod  = ve_pgcod 
             and d2.ppmod  = ve_ppmod
             and d2.ppsuc  = ve_ppsuc
             and d2.ppmda  = ve_ppmda
             and d2.pppap  = ve_pppap
             and d2.ppcta  = ve_ppcta
             and d2.ppoper = ve_ppoper
             and d2.ppsbop = ve_ppsbop
             and d2.pptope = ve_pptope
             and d2.pp1stat = 'T'  --REVISAR EXTORNOS     
        ) IS NULL THEN TO_DATE('01/01/2001','DD/MM/YYYY') ELSE 
           (select max(ppfpag) from fsd602 d2 
               where d2.pgcod  = ve_pgcod 
                 and d2.ppmod  = ve_ppmod
                 and d2.ppsuc  = ve_ppsuc
                 and d2.ppmda  = ve_ppmda
                 and d2.pppap  = ve_pppap
                 and d2.ppcta  = ve_ppcta
                 and d2.ppoper = ve_ppoper
                 and d2.ppsbop = ve_ppsbop
                 and d2.pptope = ve_pptope
                 and d2.pp1stat = 'T')
        END --REVISAR EXTORNOS     
        );
   --Variables internas
   ln_cuota     decimal(17,2);
   ln_tot_cuo   decimal(17,2);
   ln_10_cuo    decimal(17,2);
   ln_cont      number(3);
   ln_ppcap     fsd601.ppcap%type;
   ln_ppint     fsd601.ppint%type;
   ln_prc_f     decimal(17,2);
   ln_esquema   number(3); --0 cuota fija 1 distinto a cuota fija  
   ln_esquema2  number(3);
   ult_cuo      number(3);
   ln_seguro    number(17,2);
   tmp_cuo_liq number(1);
   tmp_ppcap fsd601.ppcap%type;
   tmp_ppint fsd601.ppint%type;
   ln_cuotapr number(17,2);
   --ve_to_cuot_rmn number(17,2);
   begin
     ln_cont    := 1;
     ln_tot_cuo := 0;
     ln_prc_f   := 1.1; --POR EL MOMENTO MONTO FIJO DEBE SER PRAMETRIZADO EN LA GUI ESPECIAL DE PROCESO.
     ln_esquema := 0;
     ult_cuo    := 0;
     --OBTENER NUMERO TOTAL DE CUOTAS PENDIENTES DE PAGO.
     --OBTENER CUOTA PROMEDIO
     ln_cuotapr := fn_cr_obtener_cuo_prm(
                                            ve_pgcod,
                                            ve_ppmod,
                                            ve_ppsuc,
                                            ve_ppmda,
                                            ve_pppap,
                                            ve_ppcta,
                                            ve_ppoper,
                                            ve_ppsbop,
                                            ve_pptope
                                          );
     begin
       select count(*) total_cuot_pend 
         into ult_cuo
         from fsd601 d1
         where d1.pgcod  = ve_pgcod 
           and d1.ppmod  = ve_ppmod
           and d1.ppsuc  = ve_ppsuc
           and d1.ppmda  = ve_ppmda
           and d1.pppap  = ve_pppap
           and d1.ppcta  = ve_ppcta
           and d1.ppoper = ve_ppoper
           and d1.ppsbop = ve_ppsbop
           and d1.pptope = ve_pptope
           and d1.ppfpag > (CASE WHEN (select max(ppfpag) from fsd602 d2 
                                         where d2.pgcod  = ve_pgcod 
                                           and d2.ppmod  = ve_ppmod
                                           and d2.ppsuc  = ve_ppsuc
                                           and d2.ppmda  = ve_ppmda
                                           and d2.pppap  = ve_pppap
                                           and d2.ppcta  = ve_ppcta
                                           and d2.ppoper = ve_ppoper
                                           and d2.ppsbop = ve_ppsbop
                                           and d2.pptope = ve_pptope
                                           and d2.pp1stat = 'T'  --REVISAR EXTORNOS     
                                      ) IS NULL THEN TO_DATE('01/01/2001','DD/MM/YYYY') ELSE 
                                         (select max(ppfpag) from fsd602 d2 
                                             where d2.pgcod  = ve_pgcod 
                                               and d2.ppmod  = ve_ppmod
                                               and d2.ppsuc  = ve_ppsuc
                                               and d2.ppmda  = ve_ppmda
                                               and d2.pppap  = ve_pppap
                                               and d2.ppcta  = ve_ppcta
                                               and d2.ppoper = ve_ppoper
                                               and d2.ppsbop = ve_ppsbop
                                               and d2.pptope = ve_pptope
                                               and d2.pp1stat = 'T')
                                      END --REVISAR EXTORNOS
                                      );
     exception
       when no_data_found then
          begin
            select count(*) total_cuot_pend 
               into ult_cuo
               from fsd601 d1
               where d1.pgcod  = ve_pgcod 
                 and d1.ppmod  = ve_ppmod
                 and d1.ppsuc  = ve_ppsuc
                 and d1.ppmda  = ve_ppmda
                 and d1.pppap  = ve_pppap
                 and d1.ppcta  = ve_ppcta
                 and d1.ppoper = ve_ppoper
                 and d1.ppsbop = ve_ppsbop
                 and d1.pptope = ve_pptope;
            exception 
              when others then 
                ult_cuo:=0;
            end;
          
       when others then
         null;  
       end;
     -- VALIDAR ESQUEMA PARA CUOTA FIJA.  CASO 1 , 2 , 3 , 4, 5
     BEGIN
     for c in cronograma_cuotas_pend loop
       
     --AGREGANDO SEGUROS A LA CUOTA.
     begin
                 begin
                     SELECT NVL(((d1.ppimp10+d1.ppimp11+d1.ppimp12+d1.ppimp13+d1.ppimp14+d1.ppimp15+d1.ppimp16+d1.ppimp17+d1.ppimp18+d1.ppimp19+d1.ppimp20) -
                            (SELECT  nvl(SUM(d12.pp1imp10+d12.pp1imp11+d12.pp1imp12+d12.pp1imp13+d12.pp1imp14+d12.pp1imp15+d12.pp1imp16+d12.pp1imp17+d12.pp1imp18+d12.pp1imp19+d12.pp1imp20),0)
                           FROM FSD612 d12
                         WHERE  d12.pgcod = d1.pgcod
                        and d12.ppmod = d1.ppmod
                        and d12.ppsuc = d1.ppsuc
                        and d12.ppmda = d1.ppmda
                        and d12.pppap = d1.pppap
                        and d12.ppcta = d1.ppcta
                        and d12.ppoper = d1.ppoper
                        and d12.ppsbop = d1.ppsbop
                        and d12.pptope = d1.pptope
                        and d12.ppfpag = d1.ppfpag )),0)
                       INTO ln_seguro
                       FROM FSD611 d1
                       
                      WHERE d1.pgcod = c.pgcod
                        and d1.ppmod = c.ppmod
                        and d1.ppsuc = c.ppsuc
                        and d1.ppmda = c.ppmda
                        and d1.pppap = c.pppap
                        and d1.ppcta =  c.ppcta
                        and d1.ppoper = c.ppoper
                        and d1.ppsbop = c.ppsbop
                        and d1.pptope = c.pptope
                        and d1.ppfpag = c.ppfpag;
                exception 
                  when no_data_found then
                      ln_seguro:=0;
                  when others then
                      ln_seguro:=0;          
                end;        
       end;
     --
       if ln_cont = 2 then --se cambio de cuota 1 a cuota 2 ncluir cuota menor no se menor a ella.
          ln_cuota := c.ppcap + c.ppint + ln_seguro;
       end if;
       
       if (ln_cuota <> (c.ppcap + c.ppint + ln_seguro)) then --SI ALGUNA CUOTA ES DIFERENTE           
          if ln_cuota >(c.ppcap + c.ppint+ ln_seguro) and ult_cuo = ln_cont then --SI LA CUOTA DIFERENTE ES LA ULTIMA CUOTA
             ln_10_cuo :=  ln_cuota*ln_prc_f;
             if (ln_10_cuo>(c.ppcap + c.ppint + ln_seguro))  then --EN CASO QUE LA ULT. CUOTA SEA MAYOR AL 10% SE CONSIDERA DISTINTO A CUOTA FIJA.
                ln_esquema := 0; --CUOTA FIJA   
             else
                ln_esquema :=1; --CUOTA DISTINTA A FIJA.
             end if;  
          else
            if ln_cont < ult_cuo and ln_cont > 1 then
               /*
               if ln_cont = 2 then
                  cuota := c.ppcap + c.ppint+ ln_seguro;
               end if;
               */
               if ln_cuotapr*ln_prc_f < (c.ppcap + c.ppint+ ln_seguro) then
                   ln_esquema2 :=1;
               end if;  
            end if; 
          end if;
       end if;
       tmp_cuo_liq := 0;
       tmp_ppcap := 0;
       tmp_ppint := 0;
       --OBTENGO PAGOS REALIZADOS
         --CASO CONTRARIO SUMO LOS PAGOS PARCIALES PARA RESTALE AL PENDIENTE Y/O RESTO A LA CUOTA ITERADA.
          BEGIN
            SELECT 0,
                   sum(d2.pp1cap), --CAPITAL TOTAL PAGADO
                   sum(d2.pp1int) --INTERES TOTAL PAGADO
              INTO tmp_cuo_liq,
                   tmp_ppcap,
                   tmp_ppint
              FROM fsd602 d2
             WHERE d2.pgcod = c.pgcod
               and d2.ppmod = c.ppmod
               and d2.ppsuc = c.ppsuc
               and d2.ppmda = c.ppmda
               and d2.pppap = c.pppap
               and d2.ppcta = c.ppcta
               and d2.ppoper = c.ppoper
               and d2.ppsbop = c.ppsbop
               and d2.pptope = c.pptope
               and d2.ppfpag = c.ppfpag;
          exception 
            when no_data_found then
              tmp_ppcap :=0;
              tmp_ppint :=0;
            when others then 
              null;
          END;   
       
     ln_tot_cuo := ln_tot_cuo + (c.ppcap + c.ppint) + ln_seguro - (nvl(tmp_ppcap,0)+nvl(tmp_ppint,0)); --SUMNADO CUOTAS PENDIENTES DE PAGO
     ve_to_cuot_rmn := (c.ppcap + c.ppint) + ln_seguro - (nvl(tmp_ppcap,0)+nvl(tmp_ppint,0));
     ve_to_cuot := ln_tot_cuo;
     ln_cont := ln_cont + 1; 
     end loop;
     ve_esquema := ln_esquema;
     if ln_esquema2 = 1 then
       ve_esquema:= ln_esquema2;
       ve_to_cuot_rmn := ve_to_cuot - ve_to_cuot_rmn;
     end if;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;     
   end;

   Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
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
  function fn_cr_obtener_cuo_prm(
                               ve_pgcod  in fsd601.pgcod%type,
                               ve_ppmod  in fsd601.ppmod%type,
                               ve_ppsuc  in fsd601.ppsuc%type,
                               ve_ppmda  in fsd601.ppmda%type,
                               ve_pppap  in fsd601.pppap%type,
                               ve_ppcta  in fsd601.ppcta%type,
                               ve_ppoper in fsd601.ppoper%type,
                               ve_ppsbop in fsd601.ppsbop%type,
                               ve_pptope in fsd601.pptope%type
  ) return number is
  vi_min_fec date;
  vi_max_fec date;
  ve_cuo_mn number(17,2);
  begin
    
    begin
       select max(ppfpag),min(ppfpag) --CONDCION PARA CON CONSIDERAR LA ULTIMA CUOTA.
        into vi_max_fec,vi_min_fec
        from fsd601 d01
       where d01.pgcod = ve_pgcod
         and d01.ppmod = ve_ppmod
         and d01.ppsuc = ve_ppsuc
         and d01.ppmda = ve_ppmda
         and d01.pppap = ve_pppap
         and d01.ppcta = ve_ppcta
         and d01.ppoper = ve_ppoper
         and d01.ppsbop = ve_ppsbop
         and d01.pptope = ve_pptope;
      end;
    begin
       select  min(( (d1.ppcap+d1.ppint
                  - nvl((d01.pp1icap+d01.pp1int),0)) 
                  + (nvl(d2.ppimp11+d2.ppimp12+d2.ppimp13+d2.ppimp14+d2.ppimp15+d2.ppimp16+d2.ppimp17+d2.ppimp18+d2.ppimp19+d2.ppimp20,0)
                  - nvl(d02.pp1imp11+d02.pp1imp12+d02.pp1imp13+d02.pp1imp14+d02.pp1imp15+d02.pp1imp16+d02.pp1imp17+d02.pp1imp18+d02.pp1imp19+d02.pp1imp20,0))
                  )) minima_cuota
        into ve_cuo_mn          
        from fsd601 d1 left join fsd602 d01 
          on d01.pgcod =   d1.pgcod
         and d01.ppmod =   d1.ppmod 
         and d01.ppsuc =   d1.ppsuc
         and d01.ppmda =   d1.ppmda 
         and d01.pppap =   d1.pppap
         and d01.ppcta =   d1.ppcta
         and d01.ppoper =  d1.ppoper
         and d01.ppsbop =  d1.ppsbop
         and d01.pptope =  d1.pptope
         and d01.ppfpag =  d1.ppfpag
        left join fsd611 d2 
          on d1.pgcod =   d2.pgcod
         and d1.ppmod =   d2.ppmod 
         and d1.ppsuc =   d2.ppsuc
         and d1.ppmda =   d2.ppmda 
         and d1.pppap =   d2.pppap
         and d1.ppcta =   d2.ppcta
         and d1.ppoper =  d2.ppoper
         and d1.ppsbop =  d2.ppsbop
         and d1.pptope =  d2.pptope
         and d1.ppfpag =  d2.ppfpag
        left join fsd612 d02 
          on d02.pgcod =   d2.pgcod
         and d02.ppmod =   d2.ppmod 
         and d02.ppsuc =   d2.ppsuc
         and d02.ppmda =   d2.ppmda 
         and d02.pppap =   d2.pppap
         and d02.ppcta =   d2.ppcta
         and d02.ppoper =  d2.ppoper
         and d02.ppsbop =  d2.ppsbop
         and d02.pptope =  d2.pptope
         and d02.ppfpag =  d2.ppfpag 
       where d1.pgcod =   ve_pgcod
         and d1.ppmod =   ve_ppmod
         and d1.ppsuc =   ve_ppsuc
         and d1.ppmda =   ve_ppmda
         and d1.pppap =   ve_pppap
         and d1.ppcta =   ve_ppcta
         and d1.ppoper =  ve_ppoper
         and d1.ppsbop =  ve_ppsbop
         and d1.pptope =  ve_pptope
         and d1.ppfpag < vi_max_fec
         and d1.ppfpag > vi_min_fec
         and d1.ppstat <> 'P';
    exception
      when others then
        null;     
    
    end;
    return ve_cuo_mn;     
  end;  
end pq_cr_reporte_crd_consumo;
/

