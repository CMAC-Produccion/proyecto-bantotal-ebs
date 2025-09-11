create or replace package jc_conc_pkg as
  TYPE t_param_array IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
  procedure main;

  FUNCTION run_concurrent_program(p_app_short_name  IN VARCHAR2,
                                  p_prog_short_name IN VARCHAR2,
                                  p_params          IN t_param_array,
                                  PV_TIPO           IN VARCHAR2)
    RETURN NUMBER;

  procedure EJEC_CONC(PN_ID    NUMBER,
                      PV_TIPO  VARCHAR2,
                      PV_1     VARCHAR2,
                      PV_2     VARCHAR2,
                      PV_3     VARCHAR2,
                      PV_4     VARCHAR2,
                      PV_5     VARCHAR2,
                      PN_RQ_ID OUT NUMBER);

  procedure EJE_JOB_CONC(PN_ID    NUMBER,
                         PV_1     VARCHAR2,
                         PV_2     VARCHAR2,
                         PV_3     VARCHAR2,
                         PV_4     VARCHAR2,
                         PV_5     VARCHAR2,
                         PN_RQ_ID OUT NUMBER);

  procedure pr_ejec_conc_prog(errbuf OUT VARCHAR2, retcode OUT VARCHAR2);

  procedure pr_obtiene_params_value(pn_id number);

  procedure pr_obtiene_params_value_jc(pn_id_config number, pn_id number);

  procedure pr_envia_correo(pn_id number, pn_request_id number);
  -- return varchar2;

  procedure process_recipients(p_mail_conn in out utl_smtp.connection,
                               p_list      in varchar2);

end jc_conc_pkg;
/
create or replace package body jc_conc_pkg as

  procedure main as
  
    cursor c_concurrentes is
      select application_id,
             concurrent_program_id,
             concurrent_program_name,
             display_order,
             is_required,
             count(concurrent_program_id) contar
        from jc_concurrent_parameters -- tu tabla o fuente de datos
       group by application_id,
                concurrent_program_id,
                concurrent_program_name,
                display_order,
                is_required
       order by display_order;
  
    cursor c_parametros is
      select concurrent_program_name,
             attribute_number,
             attribute_name,
             attribute_type,
             attribute_value,
             attribute_lov_query
        from jc_concurrent_parameters -- tu tabla o fuente de datos
       where concurrent_program_name = 'TS_EXCEPT_CORRECT_PERIOD'
       order by attribute_number;
  
    l_request_id number;
    l_phase      varchar2(30);
    l_status     varchar2(30);
    l_dev_phase  varchar2(30);
    l_dev_status varchar2(30);
    l_message    varchar2(2000);
    l_complete   boolean;
  
    vv_type        varchar2(100);
    vv_descripcion varchar2(100);
    vv_phase       varchar2(100);
    vv_status      varchar2(100);
    vv_dev_phase   varchar2(100);
    vv_dev_status  varchar2(100);
  
  begin
    -- Inicializa el contexto si estás fuera de EBS
    fnd_global.apps_initialize(user_id      => 1234,
                               resp_id      => 50605,
                               resp_appl_id => 20003);
  
    for r in c_concurrentes loop
      dbms_output.put_line('Ejecutando programa: ' ||
                           r.concurrent_program_name);
    
      for p in c_parametros loop
      
        if p.attribute_type = 'FECHA' then
          dbms_output.put_line('Ejecutando programa: ' ||
                               r.concurrent_program_name);
        end if;
      
      end loop;
    
      if r.contar = 1 then
        null;
      end if;
    
      -- Ejecutar concurrente
      l_request_id := fnd_request.submit_request(application => r.application_id,
                                                 program     => r.concurrent_program_name,
                                                 description => null,
                                                 start_time  => null,
                                                 sub_request => false
                                                 /*,argument1   => p.attribute_value
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ,argument2   => p.attribute_value*/);
    
      commit;
    
      if l_request_id > 0 then
        l_complete := fnd_concurrent.wait_for_request(request_id => l_request_id,
                                                      interval   => 2,
                                                      max_wait   => 100000,
                                                      phase      => vv_phase,
                                                      status     => vv_status,
                                                      dev_phase  => vv_dev_phase,
                                                      dev_status => vv_dev_status,
                                                      message    => l_message);
        commit;
      
        if upper(vv_dev_phase) in ('COMPLETE', 'COMPLETED') then
          fnd_file.put_line(fnd_file.log,
                            'Concurrent request completed successfully');
          apps.jc_main.pr_print('');
          apps.jc_main.pr_print('------------------------------------------------------------');
          apps.jc_main.pr_print('Verificación de Creación');
          apps.jc_main.pr_print('------------------------------------------------------------');
        end if;
      
      end if;
    
      commit;
    
      if l_request_id = 0 then
        apps.jc_main.pr_print(' Failed to submit Process POXPOPDOI.' ||
                              fnd_message.get);
      else
        null;
      end if;
    
    end loop;
  
  end;

  FUNCTION run_concurrent_program(p_app_short_name  IN VARCHAR2,
                                  p_prog_short_name IN VARCHAR2,
                                  p_params          IN t_param_array,
                                  PV_TIPO           IN VARCHAR2)
    RETURN NUMBER IS
  
    l_user_id    NUMBER;
    l_resp_id    NUMBER;
    l_app_id     NUMBER;
    l_request_id NUMBER;
    l_resp_info  VARCHAR2(100);
  
    l_schedule_date DATE := SYSDATE;
  
  BEGIN
    -- Obtener IDs
    l_user_id   := 0;
    l_resp_info := '50697,200';
  
    l_resp_id := TO_NUMBER(SUBSTR(l_resp_info,
                                  1,
                                  INSTR(l_resp_info, ',') - 1));
    l_app_id  := TO_NUMBER(SUBSTR(l_resp_info, INSTR(l_resp_info, ',') + 1));
  
    -- Inicializar sesión apps
    fnd_global.apps_initialize(l_user_id, l_resp_id, l_app_id);
  
    IF PV_TIPO = 'P' THEN
    
      -- Enviar el concurrente
      l_request_id := fnd_request.submit_request(application => p_app_short_name,
                                                 program     => p_prog_short_name,
                                                 description => 'Transferir Asientos Diarios a GL - Programado vía script',
                                                 start_time  => TO_CHAR(l_schedule_date,
                                                                        'YYYY/MM/DD HH24:MI:SS'),
                                                 sub_request => FALSE,
                                                 argument1   => p_params(1),
                                                 argument2   => p_params(2),
                                                 argument3   => p_params(3),
                                                 argument4   => p_params(4), --
                                                 argument5   => p_params(5), --
                                                 argument6   => TO_CHAR(TO_DATE(p_params(6),
                                                                                'DD/MM/YYYY'),
                                                                        'YYYY/MM/DD HH24:MI:SS'),
                                                 --argument6   => p_params(6),--
                                                 argument7  => p_params(7),
                                                 argument8  => p_params(8),
                                                 argument9  => p_params(9),
                                                 argument10 => p_params(10),
                                                 argument11 => p_params(11),
                                                 argument12 => p_params(12),
                                                 argument13 => p_params(13),
                                                 argument14 => p_params(14),
                                                 argument15 => p_params(15), --
                                                 argument16 => p_params(16), --
                                                 argument17 => p_params(17),
                                                 argument18 => p_params(18),
                                                 argument19 => p_params(19),
                                                 argument20 => p_params(20),
                                                 argument21 => p_params(21),
                                                 argument22 => p_params(22),
                                                 argument23 => p_params(23),
                                                 argument24 => p_params(24),
                                                 argument25 => p_params(25),
                                                 argument26 => p_params(26),
                                                 argument27 => p_params(27),
                                                 argument28 => p_params(28),
                                                 argument29 => p_params(29),
                                                 argument30 => p_params(30),
                                                 argument31 => p_params(31),
                                                 argument32 => p_params(32),
                                                 argument33 => p_params(33),
                                                 argument34 => p_params(34),
                                                 argument35 => p_params(35),
                                                 argument36 => p_params(36),
                                                 argument37 => p_params(37),
                                                 argument38 => p_params(38),
                                                 argument39 => p_params(39));
    
    ELSE
    
      -- Enviar el concurrente
      l_request_id := fnd_request.submit_request(application => p_app_short_name,
                                                 program     => p_prog_short_name,
                                                 description => NULL,
                                                 start_time  => NULL,
                                                 sub_request => FALSE,
                                                 argument1   => p_params(1),
                                                 argument2   => p_params(2),
                                                 argument3   => p_params(3),
                                                 argument4   => p_params(4), --
                                                 argument5   => p_params(5), --
                                                 argument6   => TO_CHAR(TO_DATE(p_params(6),
                                                                                'DD/MM/YYYY'),
                                                                        'YYYY/MM/DD HH24:MI:SS'),
                                                 argument7   => p_params(7),
                                                 argument8   => p_params(8),
                                                 argument9   => p_params(9),
                                                 argument10  => p_params(10),
                                                 argument11  => p_params(11),
                                                 argument12  => p_params(12),
                                                 argument13  => p_params(13),
                                                 argument14  => p_params(14),
                                                 argument15  => p_params(15), --
                                                 argument16  => p_params(16), --
                                                 argument17  => p_params(17),
                                                 argument18  => p_params(18),
                                                 argument19  => p_params(19),
                                                 argument20  => p_params(20),
                                                 argument21  => p_params(21),
                                                 argument22  => p_params(22),
                                                 argument23  => p_params(23),
                                                 argument24  => p_params(24),
                                                 argument25  => p_params(25),
                                                 argument26  => p_params(26),
                                                 argument27  => p_params(27),
                                                 argument28  => p_params(28),
                                                 argument29  => p_params(29),
                                                 argument30  => p_params(30),
                                                 argument31  => p_params(31),
                                                 argument32  => p_params(32),
                                                 argument33  => p_params(33),
                                                 argument34  => p_params(34),
                                                 argument35  => p_params(35),
                                                 argument36  => p_params(36),
                                                 argument37  => p_params(37),
                                                 argument38  => p_params(38),
                                                 argument39  => p_params(39));
    
    END IF;
  
    IF l_request_id = 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Error al ejecutar el concurrente.');
    END IF;
  
    RETURN l_request_id;
  END;

  procedure EJEC_CONC(PN_ID    NUMBER,
                      PV_TIPO  VARCHAR2,
                      PV_1     VARCHAR2,
                      PV_2     VARCHAR2,
                      PV_3     VARCHAR2,
                      PV_4     VARCHAR2,
                      PV_5     VARCHAR2,
                      PN_RQ_ID OUT NUMBER) IS
  
    l_params apps.jc_conc_pkg.t_param_array;
    l_req_id NUMBER;
  BEGIN
  
    IF PV_TIPO = 'U' THEN
    
      l_params(1) := '200';
      l_params(2) := '200';
      l_params(3) := 'Y';
      l_params(4) := PV_1; --'2022';
      l_params(5) := PV_2; --'';
      l_params(6) := PV_3; --'2025/06/05 00:00:00';
      l_params(7) := 'N';
      l_params(8) := '';
      l_params(9) := '';
      l_params(10) := 'Y';
      l_params(11) := '';
      l_params(12) := '';
      l_params(13) := 'Y';
      l_params(14) := 'Y';
      l_params(15) := PV_4; --'N';
      l_params(16) := PV_5; --'';
      l_params(17) := '';
      l_params(18) := '';
      l_params(19) := '';
      l_params(20) := 'Payables';
      l_params(21) := 'Payables';
      l_params(22) := 'CMA FINANCIERO';
      l_params(23) := '';
      l_params(24) := 'No';
      l_params(25) := '';
      l_params(26) := '';
      l_params(27) := '';
      l_params(28) := 'Sí';
      l_params(29) := 'No';
      l_params(30) := '';
      l_params(31) := '';
      l_params(32) := '';
      l_params(33) := '';
      l_params(34) := '';
      l_params(35) := '';
      l_params(36) := '';
      l_params(37) := '';
      l_params(38) := 'N';
      l_params(39) := 'N';
    
      PN_RQ_ID := APPS.jc_conc_pkg.run_concurrent_program(p_app_short_name  => 'XLA',
                                                          p_prog_short_name => 'XLAGLTRN',
                                                          p_params          => l_params,
                                                          PV_TIPO           => PV_TIPO);
    
    ELSE
    
      APPS.jc_conc_pkg.EJE_JOB_CONC(PN_ID,
                                    PV_1,
                                    PV_2,
                                    PV_3,
                                    PV_4,
                                    PV_5,
                                    PN_RQ_ID);
    
    END IF;
  
  END;

  procedure EJE_JOB_CONC(PN_ID    NUMBER,
                         PV_1     VARCHAR2,
                         PV_2     VARCHAR2,
                         PV_3     VARCHAR2,
                         PV_4     VARCHAR2,
                         PV_5     VARCHAR2,
                         PN_RQ_ID OUT NUMBER) IS
  
  begin
  
    DBMS_SCHEDULER.CREATE_JOB(job_name        => 'JC_CONC_PRG_' || PN_ID,
                              job_type        => 'PLSQL_BLOCK',
                              job_action      => q'[
      DECLARE
        l_request_id NUMBER;
      BEGIN
        fnd_global.apps_initialize(
          user_id      => 1234,       -- ID del usuario
          resp_id      => 5678,       -- ID de responsabilidad
          resp_appl_id => 200         -- ID de la aplicación
        );

        l_request_id := fnd_request.submit_request(
          application => 'XX',
          program     => 'XX_CIERRE_DIARIO',
          description => 'Cierre diario automático',
          start_time  => NULL,
          sub_request => FALSE,
          argument1   => '2025/06/05 00:00:00',
          argument2   => '2025/06/05 23:59:59'
        );

        COMMIT;
        
      END;
    ]',
                              start_date      => SYSTIMESTAMP,
                              repeat_interval => 'FREQ=DAILY;BYHOUR=2;BYMINUTE=0;BYSECOND=0',
                              enabled         => TRUE,
                              comments        => 'Lanzar cierre diario automáticamente desde Scheduler');
  
    PN_RQ_ID := 0;
  end;

  procedure pr_ejec_conc_prog(errbuf OUT VARCHAR2, retcode OUT VARCHAR2) is
  
    CURSOR c_requests IS
      SELECT id,
             request_set_id,
             user_request_set_name,
             creation_date,
             id_config
        FROM jc_concurrent_request
       WHERE estado = 'P'
         and id = 27
         and request_id is null
         AND EXISTS
       (SELECT 1
                FROM JC_CONCURRENT_PARAM_CONFIG cfg
               WHERE TO_CHAR(SYSDATE, 'HH24:MI') BETWEEN
                     TO_CHAR(TO_DATE(cfg.attribute1, 'HH:MIAM'), 'HH24:MI') AND
                     TO_CHAR(TO_DATE(cfg.attribute2, 'HH:MIAM'), 'HH24:MI'));
  
    v_request_id             NUMBER;
    vv_dev_phase             varchar2(100);
    vv_phase                 varchar2(100);
    vv_status                varchar2(100);
    vv_dev_status            varchar2(100);
    l_message                varchar2(2000);
    l_complete               boolean;
    vv_dia_ejec              date;
    vn_sec_id                number;
    v_ultimo_dia_ejecucion   DATE;
    v_dias_desde_ultima_ejec NUMBER;
    v_hoy                    DATE := TRUNC(SYSDATE);
  
    vn_request_id_old number;
  
  BEGIN
    fnd_file.put_line(fnd_file.log,
                      'INICIA ' || fnd_global.conc_request_id);
    -- Inicializar sesión apps
    -- fnd_global.apps_initialize(0, 50697, 200);
    fnd_file.put_line(fnd_file.log,
                      'INICIA2 ' || fnd_global.conc_request_id);
  
    FOR r IN c_requests LOOP
    
      -- if r.user_request_set_name = 'J' then
    
      fnd_file.put_line(fnd_file.log, 'X ' || R.ID);
    
      FOR prog IN (SELECT *
                     FROM JC_CONCURRENT_REQUEST_PROGRAM
                    WHERE id = r.id
                      and (fecha_fin >= TRUNC(SYSDATE) or fecha_fin is null)) LOOP
      
        fnd_file.put_line(fnd_file.log, 'X ' || prog.ID);
      
        BEGIN
          SELECT MAX(dia_ejecucion)
            INTO v_ultimo_dia_ejecucion
            FROM JC_CONCURRENT_REQUEST_HIST_ALL
           WHERE id = prog.id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_ultimo_dia_ejecucion := NULL;
        END;
      
        fnd_file.put_line(fnd_file.log, v_ultimo_dia_ejecucion || ' 1');
      
        IF v_ultimo_dia_ejecucion IS NULL THEN
          v_dias_desde_ultima_ejec := NULL;
        ELSE
          v_dias_desde_ultima_ejec := v_hoy - v_ultimo_dia_ejecucion;
        
        END IF;
      
        IF v_ultimo_dia_ejecucion IS NULL THEN
        
          fnd_file.put_line(fnd_file.log, 'X1 ' || prog.ID);
        
          pr_obtiene_params_value_jc(r.id_config, r.id);
        
        ELSIF (prog.frecuencia = 'D' AND ---PROG. DIAS---
              v_dias_desde_ultima_ejec >= prog.intervalo) OR
              (prog.frecuencia = 'S' AND ---PROG. SEMANAS---
              v_dias_desde_ultima_ejec >= (7 * prog.intervalo)) OR
              (prog.frecuencia = 'M' AND ---PROG. MESES---
              ADD_MONTHS(TRUNC(v_ultimo_dia_ejecucion), prog.intervalo) <=
              v_hoy) OR
              (prog.frecuencia = 'H' AND ---PROG. HORAS---
              v_ultimo_dia_ejecucion + (prog.intervalo / 24) <= SYSDATE) THEN
        
          fnd_file.put_line(fnd_file.log,
                            'X ' || prog.frecuencia || ' id:' || prog.ID);
        
          pr_obtiene_params_value_jc(r.id_config, r.id);
        
          if prog.fecha_fin = TRUNC(SYSDATE) then
          
            UPDATE JC_CONCURRENT_REQUEST SET ESTADO = 'T' where id = r.id;
          
          end if;
        
        END IF;
      
      end loop;
    
    /*else
                                                      
                                                        fnd_file.put_line(fnd_file.log, 'R ' || R.ID);
                                                      
                                                        FOR prog IN (SELECT *
                                                                       FROM JC_CONCURRENT_REQUEST_PROGRAM
                                                                      WHERE id = r.id
                                                                        and (fecha_fin >= TRUNC(SYSDATE) or
                                                                            fecha_fin is null)) LOOP
                                                        
                                                          fnd_file.put_line(fnd_file.log, 'R ' || PROG.ID);
                                                        
                                                          BEGIN
                                                            SELECT MAX(dia_ejecucion)
                                                              INTO v_ultimo_dia_ejecucion
                                                              FROM JC_CONCURRENT_REQUEST_HIST_ALL
                                                             WHERE id = prog.id;
                                                          EXCEPTION
                                                            WHEN NO_DATA_FOUND THEN
                                                              v_ultimo_dia_ejecucion := NULL;
                                                          END;
                                                        
                                                          fnd_file.put_line(fnd_file.log, v_ultimo_dia_ejecucion || ' 1');
                                                        
                                                          IF v_ultimo_dia_ejecucion IS NULL THEN
                                                            v_dias_desde_ultima_ejec := NULL;
                                                          ELSE
                                                            v_dias_desde_ultima_ejec := v_hoy -
                                                                                        TRUNC(v_ultimo_dia_ejecucion);
                                                          END IF;
                                                        
                                                          fnd_file.put_line(fnd_file.log,
                                                                            v_dias_desde_ultima_ejec || ' 2 ' || v_hoy);
                                                        
                                                          IF v_ultimo_dia_ejecucion IS NULL THEN
                                                          
                                                            fnd_file.put_line(fnd_file.log, 'R ' || PROG.ID);
                                                          
                                                            --pr_obtiene_params_value(r.id_config, r.id);
                                                          
                                                          ELSIF (prog.frecuencia = 'D' AND ---PROG. DIAS---
                                                                v_dias_desde_ultima_ejec >= prog.intervalo) OR
                                                                (prog.frecuencia = 'S' AND ---PROG. SEMANAS---
                                                                v_dias_desde_ultima_ejec >= (7 * prog.intervalo)) OR
                                                                (prog.frecuencia = 'M' AND ---PROG. MESES---
                                                                ADD_MONTHS(TRUNC(v_ultimo_dia_ejecucion), prog.intervalo) <=
                                                                v_hoy) OR
                                                                (prog.frecuencia = 'H' AND ---PROG. HORAS---
                                                                v_ultimo_dia_ejecucion + (prog.intervalo / 24) <= SYSDATE) THEN
                                                          
                                                            fnd_file.put_line(fnd_file.log, 'R ' || PROG.ID);
                                                          
                                                            --pr_obtiene_params_value(r.id_config, r.id);
                                                          
                                                            if prog.fecha_fin = TRUNC(SYSDATE) then
                                                            
                                                              UPDATE JC_CONCURRENT_REQUEST
                                                                 SET ESTADO = 'T'
                                                               where id = r.id;
                                                            
                                                            end if;
                                                          
                                                          END IF;
                                                        
                                                        end loop;
                                                      
                                                      END IF;*/
    
    END LOOP;
  
  end;

  procedure pr_obtiene_params_value(pn_id number) is
  
    vv_attribute1  varchar2(100);
    vv_attribute2  varchar2(100);
    vv_attribute3  varchar2(100);
    vv_attribute4  varchar2(100);
    vv_attribute5  varchar2(100);
    vv_attribute6  varchar2(100);
    vv_attribute7  varchar2(100);
    vv_attribute8  varchar2(100);
    vv_attribute9  varchar2(100);
    vv_attribute10 varchar2(100);
  
    vv_fecha_ult_ejec date;
    vv_fecha_inicio   date;
    vn_sec_id         number;
  
    v_ultimo_dia_ejecucion   DATE;
    v_dias_desde_ultima_ejec NUMBER;
    v_dias_desde_inicio      NUMBER;
    v_hoy                    DATE := TRUNC(SYSDATE);
  
    vv_Estado    varchar2(50);
    l_request_id number;
    l_phase      varchar2(30);
    l_status     varchar2(30);
    l_dev_phase  varchar2(30);
    l_dev_status varchar2(30);
    l_message    varchar2(2000);
    l_complete   boolean;
  
    vv_type        varchar2(100);
    vv_descripcion varchar2(100);
    vv_phase       varchar2(100);
    vv_status      varchar2(100);
    vv_dev_phase   varchar2(100);
    vv_dev_status  varchar2(100);
  
    vv_dia_ejec date;
  
    v_request_id     NUMBER;
    v_user_id        NUMBER := fnd_global.user_id; --0; --fnd_global.user_id;
    v_resp_id        NUMBER := fnd_global.resp_id; --50697; --fnd_global.resp_id;
    v_resp_appl_id   NUMBER := fnd_global.resp_appl_id; --200; --fnd_global.resp_appl_id;
    v_appl_name      VARCHAR2(100);
    v_program_name   VARCHAR2(100);
    v_description    VARCHAR2(100);
    v_request_set_id NUMBER;
  
    v_dummy   NUMBER;
    v_counter NUMBER;
  
    vn_req_inc number := fnd_global.conc_request_id;
    vv_fecha_p varchar2(50);
  
  begin
  
    begin
    
      begin
        SELECT attribute1
          into vv_fecha_p
          FROM jc_concurrent_params_value
         WHERE id_config =
               (SELECT id_config FROM jc_concurrent_request where id = pn_id)
           and concurrent_short_name =
               'TS Corrige Excepciones de Periodo AP';
      end;
    
    end;
  
    vv_attribute1 := '2022';
  
    vv_attribute3 := TO_CHAR(TO_DATE(LPAD(vv_fecha_p, 2, '0') || '/' ||
                                     TO_CHAR(SYSDATE, 'MM/YYYY'),
                                     'dd/mm/yyyy'),
                             'YYYY/MM/DD HH24:MI:SS');
    vv_attribute4 := 'N';
  
    v_request_id := fnd_request.submit_request(application => 'XLA',
                                               program     => 'XLAGLTRN',
                                               description => 'JC',
                                               start_time  => NULL,
                                               sub_request => false,
                                               argument1   => '200',
                                               argument2   => '200',
                                               argument3   => 'Y',
                                               argument4   => vv_attribute1,
                                               argument5   => NULL,
                                               argument6   => vv_attribute3 /*TO_CHAR(TO_DATE(vv_attribute3,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    'DD/MM/YYYY'),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'YYYY/MM/DD HH24:MI:SS')*/,
                                               argument7   => 'N',
                                               argument8   => '',
                                               argument9   => '',
                                               argument10  => 'Y',
                                               argument11  => '',
                                               argument12  => '',
                                               argument13  => 'Y',
                                               argument14  => 'Y',
                                               argument15  => NULL,
                                               argument16  => vv_attribute5,
                                               argument17  => '',
                                               argument18  => '',
                                               argument19  => '',
                                               argument20  => 'Payables',
                                               argument21  => 'Payables',
                                               argument22  => 'CMA FINANCIERO',
                                               argument23  => '',
                                               argument24  => 'No',
                                               argument25  => '',
                                               argument26  => '',
                                               argument27  => '',
                                               argument28  => 'Sí',
                                               argument29  => 'No',
                                               argument30  => '',
                                               argument31  => '',
                                               argument32  => '',
                                               argument33  => '',
                                               argument34  => '',
                                               argument35  => '',
                                               argument36  => '',
                                               argument37  => '',
                                               argument38  => 'N',
                                               argument39  => 'N');
  
    if v_request_id > 0 then
    
      l_complete := fnd_concurrent.wait_for_request(request_id => v_request_id,
                                                    interval   => 2,
                                                    max_wait   => 15, --300,
                                                    phase      => vv_phase,
                                                    status     => vv_status,
                                                    dev_phase  => vv_dev_phase,
                                                    dev_status => vv_dev_status,
                                                    message    => l_message);
      commit;
    
      if upper(vv_dev_phase) in ('COMPLETE', 'COMPLETED') then
      
        insert into JC_CONCURRENT_REQUEST_HIST_ALL
        values
          (pn_id,
           sysdate,
           v_request_id,
           vv_dev_phase,
           vn_req_inc,
           vv_dev_status);
      
        --  NULL;
      
      else
      
        insert into JC_CONCURRENT_REQUEST_HIST_ALL
        values
          (pn_id,
           sysdate,
           v_request_id,
           vv_dev_phase,
           vn_req_inc,
           vv_dev_status);
        --  NULL;
      
      end if;
    
    end if;
  
  end;

  procedure pr_obtiene_params_value_jc(pn_id_config number, pn_id number) is
  
    vv_attribute1  varchar2(100);
    vv_attribute2  varchar2(100);
    vv_attribute3  varchar2(100);
    vv_attribute4  varchar2(100);
    vv_attribute5  varchar2(100);
    vv_attribute6  varchar2(100);
    vv_attribute7  varchar2(100);
    vv_attribute8  varchar2(100);
    vv_attribute9  varchar2(100);
    vv_attribute10 varchar2(100);
  
    VN_MAX_WAIT NUMBER;
  
    vv_fecha_ult_ejec date;
    vv_fecha_inicio   date;
    vn_sec_id         number;
  
    v_ultimo_dia_ejecucion   DATE;
    v_dias_desde_ultima_ejec NUMBER;
    v_dias_desde_inicio      NUMBER;
    v_hoy                    DATE := TRUNC(SYSDATE);
  
    vv_Estado    varchar2(50);
    l_request_id number;
    l_phase      varchar2(30);
    l_status     varchar2(30);
    l_dev_phase  varchar2(30);
    l_dev_status varchar2(30);
    l_message    varchar2(2000);
    l_complete   boolean;
  
    vv_type        varchar2(100);
    vv_descripcion varchar2(100);
    vv_phase       varchar2(100);
    vv_status      varchar2(100);
    vv_dev_phase   varchar2(100);
    vv_dev_status  varchar2(100);
  
    vv_dia_ejec date;
  
    v_request_id     NUMBER;
    v_user_id        NUMBER := fnd_global.user_id; --0; --fnd_global.user_id;
    v_resp_id        NUMBER := fnd_global.resp_id; --50697; --fnd_global.resp_id;
    v_resp_appl_id   NUMBER := fnd_global.resp_appl_id; --200; --fnd_global.resp_appl_id;
    v_appl_name      VARCHAR2(100);
    v_program_name   VARCHAR2(100);
    v_description    VARCHAR2(100);
    v_request_set_id NUMBER;
  
    v_dummy   NUMBER;
    v_counter NUMBER;
  
    vv_application varchar2(60);
    vv_program     varchar2(80);
  
    VN_COUNT       NUMBER;
    vn_count_param number;
    vv_fecha_p     varchar2(40);
    VN_USER_ID     NUMBER;
  
    vn_req_inc number := fnd_global.conc_request_id;
  begin
  
    insert into JC_CONCURRENT_REQUEST_HIST_ALL
    values
      (pn_id,
       sysdate,
       vn_req_inc,
       'PRINCIPAL JUEGO CONCURRENTE',
       NULL,
       null);
  
    begin
    
      update jc_concurrent_request
         set request_id = vn_req_inc
       WHERE id = pn_id;
      commit;
    
    end;
  
    begin
    
      SELECT count(1)
        into vn_count_param
        FROM jc_concurrent_params_value
       WHERE id_config = pn_id_config;
    
    end;
  
    if vn_count_param > 3 then
    
      FOR p IN (SELECT *
                  FROM jc_concurrent_params_value
                 WHERE id_config = pn_id_config
                 ORDER BY order_sec) LOOP
      
        BEGIN
        
          SELECT application_short_name, concurrent_program_name
            into vv_application, vv_program
            FROM (SELECT ap.application_short_name, concurrent_program_name
                    FROM fnd_concurrent_programs cp, fnd_application ap
                   where cp.application_id = ap.application_id
                     and concurrent_program_id IN
                         (select concurrent_program_id
                            from fnd_concurrent_programs_tl
                           where user_concurrent_program_name =
                                 p.concurrent_short_name
                             and language = 'ESA'
                             and application_short_name = 'XXBOL')
                  UNION ALL
                  SELECT ap.application_short_name, concurrent_program_name
                    FROM fnd_concurrent_programs cp, fnd_application ap
                   where cp.application_id = ap.application_id
                     and concurrent_program_id IN
                         (select concurrent_program_id
                            from fnd_concurrent_programs_tl
                           where user_concurrent_program_name =
                                 p.concurrent_short_name
                             and language = 'ESA'
                             and application_short_name = 'XLA'));
        
        END;
      
        if p.concurrent_short_name in
           ('TS Corrige Excepciones de Periodo AP',
            'TS Corrige Excepciones de Informe de Gastos AP') then
        
          vv_attribute1 := to_char(trunc(TO_DATE('01' || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          vv_attribute2 := to_char(trunc(TO_DATE(p.attribute1 || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE,
                                                     argument1   => vv_attribute1,
                                                     argument2   => vv_attribute2);
          commit;
        elsif p.concurrent_short_name = 'TS Validación Moneda - Dígito' then
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE);
          commit;
        elsif p.concurrent_short_name =
              'TS Restaurar ORG - Validación Dígito' then
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE);
          commit;
        elsif p.concurrent_short_name = 'Crear Contabilidad' then
        
          vv_attribute1  := p.attribute1;
          vv_attribute2  := p.attribute2;
          vv_attribute4  := p.attribute4;
          vv_attribute5  := p.attribute5;
          vv_attribute6  := p.attribute6;
          vv_attribute7  := p.attribute7;
          vv_attribute8  := p.attribute8;
          vv_attribute9  := p.attribute9;
          vv_attribute10 := p.attribute10;
        
          vv_attribute3 := to_char(trunc(TO_DATE(p.attribute3 || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          fnd_file.put_line(fnd_file.log, vv_attribute3);
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     --description => 'P- JC - Automatizacion Concurrentes APEX',
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE,
                                                     argument1   => '200',
                                                     argument2   => '200',
                                                     argument3   => 'Y',
                                                     argument4   => vv_attribute1,
                                                     argument5   => vv_attribute2,
                                                     argument6   => vv_attribute3,
                                                     argument7   => 'Y',
                                                     argument8   => 'Y',
                                                     argument9   => vv_attribute4, --'',
                                                     argument10  => 'Y',
                                                     argument11  => vv_attribute5, --'',
                                                     argument12  => vv_attribute6, --'',
                                                     argument13  => vv_attribute7, --'Y',
                                                     argument14  => 'Y',
                                                     argument15  => vv_attribute8,
                                                     argument16  => vv_attribute9,
                                                     argument17  => '',
                                                     argument18  => 'N',
                                                     argument19  => '',
                                                     argument20  => '',
                                                     argument21  => 'Payables',
                                                     argument22  => 'Payables',
                                                     argument23  => 'CMA FINANCIERO',
                                                     argument24  => '',
                                                     argument25  => 'Sí',
                                                     argument26  => 'Final',
                                                     argument27  => 'No',
                                                     argument28  => 'No hay Informe',
                                                     argument29  => 'Sí',
                                                     argument30  => 'No',
                                                     argument31  => 'No',
                                                     argument32  => '',
                                                     argument33  => '',
                                                     argument34  => vv_attribute10,
                                                     argument35  => '',
                                                     argument36  => '',
                                                     argument37  => '',
                                                     argument38  => '',
                                                     argument39  => '',
                                                     argument40  => 'N',
                                                     argument41  => 'No',
                                                     argument42  => 'N',
                                                     argument43  => VN_USER_ID,
                                                     argument44  => 'N',
                                                     argument45  => 'Y',
                                                     argument46  => 'Sí');
          commit;
        end if;
      
        if v_request_id > 0 then
        
          IF p.concurrent_short_name =
             'TS Corrige Excepciones de Periodo AP' THEN
            VN_MAX_WAIT := 300;
          ELSIF p.concurrent_short_name =
                'TS Corrige Excepciones de Informe de Gastos AP' THEN
            VN_MAX_WAIT := 300;
          ELSIF p.concurrent_short_name = 'TS Validación Moneda - Dígito' THEN
            VN_MAX_WAIT := 50;
          ELSIF p.concurrent_short_name = 'Crear Contabilidad' THEN
            VN_MAX_WAIT := 1800;
          ELSIF p.concurrent_short_name =
                'TS Restaurar ORG - Validación Dígito' THEN
            VN_MAX_WAIT := 50;
          
          END IF;
        
          l_complete := fnd_concurrent.wait_for_request(request_id => v_request_id,
                                                        interval   => 2,
                                                        max_wait   => VN_MAX_WAIT,
                                                        phase      => vv_phase,
                                                        status     => vv_status,
                                                        dev_phase  => vv_dev_phase,
                                                        dev_status => vv_dev_status,
                                                        message    => l_message);
          commit;
        
          if upper(vv_dev_phase) in ('COMPLETE', 'COMPLETED') then
          
            insert into JC_CONCURRENT_REQUEST_HIST_ALL
            values
              (pn_id,
               sysdate,
               v_request_id,
               vv_dev_phase,
               vn_req_inc,
               vv_dev_status);
          
          else
          
            insert into JC_CONCURRENT_REQUEST_HIST_ALL
            values
              (pn_id,
               sysdate,
               v_request_id,
               vv_dev_phase,
               vn_req_inc,
               vv_dev_status);
          
          end if;
        
        end if;
      
        IF p.concurrent_short_name = 'TS Restaurar ORG - Validación Dígito' THEN
        
          BEGIN
            SELECT COUNT(1)
              INTO VN_COUNT
              FROM JC_CONCURRENT_REQUEST_HIST_ALL A
             WHERE A.ID = pn_id
               AND EXISTS (SELECT 1
                      FROM fnd_concurrent_requests R
                     WHERE R.request_id = A.request_id
                       AND R.status_code IN ('E', 'G'));
          
          END;
        
          IF VN_COUNT > 0 THEN
          
            pr_envia_correo(pn_id, vn_req_inc);
          
          else
          
            pr_obtiene_params_value(pn_id);
          
          end if;
        
        END IF;
      
      end loop;
    
    elsif vn_count_param <= 3 then
    
      fnd_file.put_line(fnd_file.log,
                        'INICIAx ' || fnd_global.conc_request_id);
    
      begin
        SELECT attribute1
          into vv_fecha_p
          FROM jc_concurrent_params_value
         WHERE id_config = pn_id_config
           and concurrent_short_name =
               'TS Corrige Excepciones de Periodo AP';
      end;
    
      fnd_file.put_line(fnd_file.log,
                        'INICIAx ' || vv_fecha_p || ' c:' ||
                        fnd_global.conc_request_id);
    
      FOR p IN (SELECT 'TS Corrige Excepciones de Periodo AP' concurrent_short_name
                  FROM DUAL
                UNION ALL
                SELECT 'TS Corrige Excepciones de Informe de Gastos AP'
                  FROM DUAL
                UNION ALL
                SELECT 'TS Validación Moneda - Dígito'
                  FROM DUAL
                UNION ALL
                SELECT 'Crear Contabilidad'
                  FROM DUAL
                UNION ALL
                SELECT 'TS Restaurar ORG - Validación Dígito' FROM DUAL) LOOP
      
        fnd_file.put_line(fnd_file.log,
                          'INICIAx ' || p.concurrent_short_name || ' c:' ||
                          fnd_global.conc_request_id);
      
        BEGIN
        
          SELECT application_short_name, concurrent_program_name
            into vv_application, vv_program
            FROM (SELECT ap.application_short_name, concurrent_program_name
                    FROM fnd_concurrent_programs cp, fnd_application ap
                   where cp.application_id = ap.application_id
                     and concurrent_program_id IN
                         (select concurrent_program_id
                            from fnd_concurrent_programs_tl
                           where user_concurrent_program_name =
                                 p.concurrent_short_name
                             and language = 'ESA'
                             and application_short_name = 'XXBOL')
                  UNION ALL
                  SELECT ap.application_short_name, concurrent_program_name
                    FROM fnd_concurrent_programs cp, fnd_application ap
                   where cp.application_id = ap.application_id
                     and concurrent_program_id IN
                         (select concurrent_program_id
                            from fnd_concurrent_programs_tl
                           where user_concurrent_program_name =
                                 p.concurrent_short_name
                             and language = 'ESA'
                             and application_short_name = 'XLA'));
        
        END;
      
        if p.concurrent_short_name in
           ('TS Corrige Excepciones de Periodo AP',
            'TS Corrige Excepciones de Informe de Gastos AP') then
        
          fnd_file.put_line(fnd_file.log,
                            'INICIAx 1 ' || p.concurrent_short_name ||
                            ' c:' || fnd_global.conc_request_id);
        
          vv_attribute1 := to_char(trunc(TO_DATE('01' || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          vv_attribute2 := to_char(trunc(TO_DATE(vv_fecha_p || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE,
                                                     argument1   => vv_attribute1,
                                                     argument2   => vv_attribute2);
          commit;
        elsif p.concurrent_short_name = 'TS Validación Moneda - Dígito' then
        
          fnd_file.put_line(fnd_file.log,
                            'INICIAx 2 ' || p.concurrent_short_name ||
                            ' c:' || fnd_global.conc_request_id);
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE);
          commit;
        elsif p.concurrent_short_name =
              'TS Restaurar ORG - Validación Dígito' then
        
          fnd_file.put_line(fnd_file.log,
                            'INICIAx 3 ' || p.concurrent_short_name ||
                            ' c:' || fnd_global.conc_request_id);
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE);
          commit;
        elsif p.concurrent_short_name = 'Crear Contabilidad' then
        
          fnd_file.put_line(fnd_file.log,
                            'INICIAx 4 ' || p.concurrent_short_name ||
                            ' c:' || fnd_global.conc_request_id);
        
          vv_attribute1 := '2022';
          vv_attribute4 := 'F';
          vv_attribute5 := 'N';
          vv_attribute6 := 'N';
          vv_attribute7 := 'Y';
          vv_attribute8 := 'N';
        
          vv_attribute3 := to_char(trunc(TO_DATE(vv_fecha_p || '/' ||
                                                 TO_CHAR(SYSDATE, 'MM/YYYY'),
                                                 'dd/mm/yyyy')),
                                   'YYYY/MM/DD HH24:MI:SS');
        
          fnd_file.put_line(fnd_file.log, vv_attribute3);
        
          BEGIN
          
            SELECT CREATED_BY
              INTO VN_USER_ID
              FROM jc_concurrent_request
             WHERE ID = PN_ID;
          
          EXCEPTION
          
            WHEN OTHERS THEN
            
              VN_USER_ID := 0;
            
          END;
        
          v_request_id := fnd_request.submit_request(application => vv_application,
                                                     program     => vv_program,
                                                     --description => 'P- JC - Automatizacion Concurrentes APEX',
                                                     description => 'JC',
                                                     start_time  => NULL,
                                                     sub_request => FALSE,
                                                     argument1   => '200',
                                                     argument2   => '200',
                                                     argument3   => 'Y',
                                                     argument4   => vv_attribute1,
                                                     argument5   => null,
                                                     argument6   => vv_attribute3,
                                                     argument7   => 'Y',
                                                     argument8   => 'Y',
                                                     argument9   => vv_attribute4, --'',
                                                     argument10  => 'Y',
                                                     argument11  => vv_attribute5, --'',
                                                     argument12  => vv_attribute6, --'',
                                                     argument13  => vv_attribute7, --'Y',
                                                     argument14  => 'Y',
                                                     argument15  => vv_attribute8,
                                                     argument16  => NULL,
                                                     argument17  => '',
                                                     argument18  => 'N',
                                                     argument19  => '',
                                                     argument20  => '',
                                                     argument21  => 'Payables',
                                                     argument22  => 'Payables',
                                                     argument23  => 'CMA FINANCIERO',
                                                     argument24  => '',
                                                     argument25  => 'Sí',
                                                     argument26  => 'Final',
                                                     argument27  => 'No',
                                                     argument28  => 'No hay Informe',
                                                     argument29  => 'Sí',
                                                     argument30  => 'No',
                                                     argument31  => 'No',
                                                     argument32  => '',
                                                     argument33  => '',
                                                     argument34  => NULL,
                                                     argument35  => '',
                                                     argument36  => '',
                                                     argument37  => '',
                                                     argument38  => '',
                                                     argument39  => '',
                                                     argument40  => 'Y',
                                                     argument41  => 'Sí',
                                                     argument42  => 'N',
                                                     argument43  => VN_USER_ID,
                                                     argument44  => 'N',
                                                     argument45  => 'Y',
                                                     argument46  => 'Sí');
          commit;
        end if;
      
        if v_request_id > 0 then
        
          IF p.concurrent_short_name =
             'TS Corrige Excepciones de Periodo AP' THEN
            VN_MAX_WAIT :=  /*100; --*/
             300;
          ELSIF p.concurrent_short_name =
                'TS Corrige Excepciones de Informe de Gastos AP' THEN
            VN_MAX_WAIT :=  /*50; --*/
             300;
          ELSIF p.concurrent_short_name = 'TS Validación Moneda - Dígito' THEN
            VN_MAX_WAIT := 40;
          ELSIF p.concurrent_short_name = 'Crear Contabilidad' THEN
            VN_MAX_WAIT :=  /*10; --*/
             1800;
          ELSIF p.concurrent_short_name =
                'TS Restaurar ORG - Validación Dígito' THEN
            VN_MAX_WAIT := 40;
          
          END IF;
        
          l_complete := fnd_concurrent.wait_for_request(request_id => v_request_id,
                                                        interval   => 2,
                                                        max_wait   => VN_MAX_WAIT,
                                                        phase      => vv_phase,
                                                        status     => vv_status,
                                                        dev_phase  => vv_dev_phase,
                                                        dev_status => vv_dev_status,
                                                        message    => l_message);
          commit;
        
          if upper(vv_dev_phase) in ('COMPLETE', 'COMPLETED') AND
             upper(vv_dev_status) in ('NORMAL') then
          
            insert into JC_CONCURRENT_REQUEST_HIST_ALL
            values
              (pn_id,
               sysdate,
               v_request_id,
               vv_dev_phase,
               vn_req_inc,
               vv_dev_status);
          
            IF p.concurrent_short_name =
               'TS Restaurar ORG - Validación Dígito' then
              pr_obtiene_params_value(pn_id);
            end if;
          
          elsif upper(vv_dev_phase) in ('COMPLETE', 'COMPLETED') AND
                upper(vv_dev_status) in ('ERROR') THEN
          
            insert into JC_CONCURRENT_REQUEST_HIST_ALL
            values
              (pn_id,
               sysdate,
               v_request_id,
               vv_dev_phase,
               vn_req_inc,
               vv_dev_status);
          
            COMMIT;
          
            
            IF p.concurrent_short_name <> 'Crear Contabilidad' THEN
            
              pr_envia_correo(pn_id, vn_req_inc);
            
              raise_application_error(-20001,
                                      'Proceso detenido: El concurrente terminó con ERROR.');
            
            END IF;
          end if;
        
        end if;
      
      
      END LOOP;
    
    end if;
  
    begin
    
      update jc_concurrent_request set request_id = null WHERE id = pn_id;
      commit;
    
    end;
  
  end;

  procedure pr_envia_correo(pn_id number, pn_request_id number)
  -- return varchar2 
   as
  
    EmailServer VARCHAR2(80);
    Port        NUMBER;
    conn        UTL_SMTP.CONNECTION;
    crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
    mesg       CLOB;
    vhost_name VARCHAR2(100);
    vc_cc1     VARCHAR2(32000);
  
    vv_from    varchar2(240);
    vv_to      varchar2(240);
    vv_cc      varchar2(240);
    vv_asunto  varchar2(240) := 'JC - AUTOMATIZACION CONCURRENTES AP';
    vv_mensaje varchar2(240) := 'Se identifico un error es la ejecucion de los siguientes concurrentes.';
  
    v_first BOOLEAN := TRUE;
  
    vv_html clob;
  
  BEGIN
  
    BEGIN
    
      SELECT DIRECCION
        INTO vv_from
        FROM JC_CONFIG_CONCURRENT_REQUEST_NOTIF
       WHERE FLAG_TIPO = 'E';
    
    EXCEPTION
    
      WHEN OTHERS THEN
        vv_from := 'ebsusuarios@cajaarequipa.pe';
      
    END;
  
    FOR x IN (SELECT direccion
                FROM JC_CONFIG_CONCURRENT_REQUEST_NOTIF
               WHERE flag_TIPO = 'R') LOOP
    
      IF v_first THEN
        vv_to   := x.direccion;
        v_first := FALSE;
      ELSE
        vv_to := vv_to || ',' || x.direccion;
      END IF;
    
    END LOOP;
  
    BEGIN
      SELECT host_name INTO vhost_name FROM v$instance;
    EXCEPTION
      WHEN OTHERS THEN
        vhost_name := 'T82EBSBD1051';
    END;
  
    IF UPPER(vhost_name) = 'SC02-DBADM0107' THEN
      EmailServer := '10.0.200.68';
      Port        := 25;
    ELSIF UPPER(vhost_name) = 'T82EBSBD1051' THEN
      EmailServer := '10.0.202.233';
      Port        := 25;
      /* ELSE
      RETURN 'Error: Host no reconocido';*/
    END IF;
  
    /* IF vv_to IS NULL THEN
      RETURN 'Error: No hay receptor';
    END IF;*/
    dbms_output.put_line(' x1 x');
    conn := UTL_SMTP.OPEN_CONNECTION(EmailServer, Port);
    dbms_output.put_line(' x2 x');
    UTL_SMTP.HELO(conn, EmailServer);
    dbms_output.put_line(' x3 x');
    UTL_SMTP.MAIL(conn, vv_from);
    dbms_output.put_line(' x4 x');
    --process_recipients(conn, vv_to);
  
    /*FOR x IN (SELECT 'lchumbilla@cajaarequipa.pe' direccion --*
                FROM JC_CONFIG_CONCURRENT_REQUEST_NOTIF
               WHERE flag_TIPO = 'C') LOOP
    
      IF v_first THEN
        vv_cc   := x.direccion;
        v_first := FALSE;
      ELSE
        vv_cc := vv_cc || ';' || x.direccion;
      END IF;
    
    END LOOP;*/
  
    /* IF vv_cc IS NOT NULL THEN
      --UTL_SMTP.RCPT(conn, vv_cc);
      vc_cc1 := 'CC: ' || vv_cc || crlf;
    ELSE
      vc_cc1 := NULL;
    END IF;*/
    vc_cc1 := NULL;
  
    vv_html := '<h3>JC - AUTOMATIZACION DE CONCURRENTES AP</h3>';
    vv_html := vv_html || '<p>Detalle de Ejecucion:</p>' || chr(13);
    vv_html := vv_html || '<table style="height: 152px;" width="620">' ||
               chr(13);
    vv_html := vv_html || '<tbody>' || chr(13);
    vv_html := vv_html || '<tr>' || chr(13);
    vv_html := vv_html ||
               '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Nro Solicitud</strong></span></td>' ||
               chr(13);
    vv_html := vv_html ||
               '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Concurrente</strong></span></td>' ||
               chr(13);
    vv_html := vv_html ||
               '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Estado</strong></span></td>' ||
               chr(13);
    vv_html := vv_html ||
               '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Fecha Inicio Ejecucion</strong></span></td>' ||
               chr(13);
    vv_html := vv_html ||
               '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Fecha Final Ejecucion</strong></span></td>' ||
               chr(13);
  
    vv_html := vv_html || '</tr>' || chr(13);
  
    for r1 in (SELECT request_id,
                      nombre_concurrente,
                      estado,
                      FECHA_INICIO_EJECUCION,
                      FECHA_FIN_EJECUCION
                 FROM (SELECT request_id,
                              exec.user_concurrent_program_name NOMBRE_CONCURRENTE,
                              case
                                when req.status_code = 'C' THEN
                                 'COMPLETE'
                                ELSE
                                 'ERROR'
                              END ESTADO,
                              req.actual_start_date FECHA_INICIO_EJECUCION,
                              req.actual_completion_date FECHA_FIN_EJECUCION
                         FROM APPS.fnd_concurrent_requests req
                         JOIN APPS.fnd_concurrent_programs_tl exec ON req.concurrent_program_id =
                                                                      exec.concurrent_program_id
                                                                  AND exec.language =
                                                                      'ESA'
                        WHERE req.request_id in
                              (SELECT request_id
                                 FROM APPS.JC_CONCURRENT_REQUEST_HIST_ALL
                                where id = pn_id
                                  and ini_request_id = pn_request_id)
                        order by request_id asc)) loop
      vv_html := vv_html || '<tr>' || chr(13);
      vv_html := vv_html || '<td style="width: 302px;">' || r1.request_id ||
                 '</td>' || chr(13);
      vv_html := vv_html || '<td style="width: 302px;">' ||
                 r1.nombre_concurrente || '</td>' || chr(13);
      vv_html := vv_html || '<td style="width: 302px;">' || r1.estado ||
                 '</td>' || chr(13);
      vv_html := vv_html || '<td style="width: 302px;">' ||
                 r1.FECHA_INICIO_EJECUCION || '</td>' || chr(13);
      vv_html := vv_html || '<td style="width: 302px;">' ||
                 r1.FECHA_FIN_EJECUCION || '</td>' || chr(13);
      vv_html := vv_html || '</tr>' || chr(13);
    end loop;
  
    -- dbms_output.put_line(vv_html || '  final');
  
    mesg := 'From: ' || vv_from || crlf || 'To: ' || vv_to || crlf ||
            NVL(vc_cc1, '') || 'Subject: ' || vv_asunto || crlf ||
            'Content-Type: text/html; charset=UTF-8' || crlf || crlf ||
            vv_html || crlf;
  
    dbms_output.put_line(mesg);
  
    fnd_file.put_line(fnd_file.log, mesg || '  final2');
  
    FOR r IN (SELECT TRIM(REGEXP_SUBSTR(vv_to, '[^,]+', 1, LEVEL)) AS correo
                FROM dual
              CONNECT BY REGEXP_SUBSTR(vv_to, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
      UTL_SMTP.RCPT(conn, r.correo);
    END LOOP;
  
    -- dbms_output.put_line(mesg || '  final3');
    --UTL_SMTP.RCPT(conn, vv_to);
    dbms_output.put_line(' x5 x');
    UTL_SMTP.OPEN_DATA(conn);
    dbms_output.put_line(' x6 x');
    UTL_SMTP.WRITE_DATA(conn, mesg);
    dbms_output.put_line(' x7 x');
    UTL_SMTP.CLOSE_DATA(conn);
    dbms_output.put_line(' x8 x');
  
    UTL_SMTP.QUIT(conn);
  
    dbms_output.put_line(' x9 x');
  
    /*INSERT INTO JC_PRUEBA_NOTIF VALUES (1, SYSDATE, mesg);
  
    commit;*/
    fnd_file.put_line(fnd_file.log, 'envios okay');
    dbms_output.put_line('envios okay');
    -- RETURN 'Success';
  EXCEPTION
    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
      --      RETURN 'Error de SMTP: ' || SQLERRM;
      fnd_file.put_line(fnd_file.log, 'envios error1 ' || SQLERRM);
      dbms_output.put_line('envios error1 ' || SQLERRM);
    WHEN OTHERS THEN
      --      RETURN 'Error inesperado: ' || SQLERRM;
      fnd_file.put_line(fnd_file.log, 'envios error2 ' || SQLERRM);
      dbms_output.put_line('envios error2 ' || SQLERRM);
  END pr_envia_correo;

  procedure process_recipients(p_mail_conn in out utl_smtp.connection,
                               p_list      in varchar2) as
    l_tab string_api.t_split_array;
  begin
    if trim(p_list) is not null then
      l_tab := string_api.split_text(p_list);
      for i in 1 .. l_tab.count loop
        utl_smtp.rcpt(p_mail_conn, trim(l_tab(i)));
      end loop;
    end if;
  end;

end jc_conc_pkg;
/
