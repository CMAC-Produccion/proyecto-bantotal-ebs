create or replace package PQ_CR_REPORTE_DESEMBOLSO_AQPC593 is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA AUTOMATIZAR REPORTE DE DESEMBOLSO BANTOTAL - CRM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.11.29
  -- Autor de Creación          : EDEHILTON NINA
  -- Uso                        : LIMPIAR LA DATA DE TABLAS CRM
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 2024.03.11
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_reporte_desembolso para que se inserte la secuencia SEQ_CRM_NPS_DESEMBOLSOS_Q en el campo IDNPSDESEMBOLSOSQ
  --
  --
  -- *****************************************************************
  -----------------------------------------------------------------------

  procedure sp_cr_reporte_desembolso;
  procedure sp_cr_cursor_tabla_log;
  procedure sp_cr_ejecutar_reporte_desembolso;
  procedure sp_cr_insertar_gestor_proceso;

end PQ_CR_REPORTE_DESEMBOLSO_AQPC593;
/

create or replace package body PQ_CR_REPORTE_DESEMBOLSO_AQPC593 is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA AUTOMATIZAR REPORTE DE DESEMBOLSO BANTOTAL - CRM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.11.29
  -- Autor de Creación          : EDEHILTON NINA
  -- Uso                        : LIMPIAR LA DATA DE TABLAS CRM
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 2024.01.30
  -- Fecha de Modificación      : 2024.03.11
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_reporte_desembolso para que se inserte la secuencia SEQ_CRM_NPS_DESEMBOLSOS_Q en el campo IDNPSDESEMBOLSOSQ
  --
  --
  -- *****************************************************************
  -----------------------------------------------------------------------

  procedure sp_cr_reporte_desembolso is
    -- *****************************************************************
    -- Nombre                     : sp_cr_reporte_desembolso
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.29
    -- Autor de Creación          : EDEHILTON NINA
    -- Uso                        : Extraye informacion de la tabla AQPC594
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 2024.03.11
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modificó el procedimiento sp_cr_reporte_desembolso para que se inserte la secuencia sp_cr_reporte_desembolso en el campo IDNPSDESEMBOLSOSQ 
    --
    -- *****************************************************************
  
    dni_analis varchar2(100);
    --pues_traba   varchar2(100);
    AQPC594NOMPE VARCHAR2(100);
    cont_cliente number;
    AQPC594codpe varchar2(20);
  
  begin
  
    PQ_CR_REPORTE_DESEMBOLSO_AQPC593.sp_cr_cursor_tabla_log;
    -- Comentado para produccion, Gian Pierre tiene un programa para borrar la data de esta tabla
    /*begin
      delete from USRWEBCRM.CRM_NPS_DESEMBOLSOS_Q;
      commit;
    end;*/
  
    DECLARE
      v_contador NUMBER := 0;
      CURSOR mi_cursor IS
        select * from AQPC594;
    
    begin
      FOR V_FILA_1 in mi_cursor LOOP
        v_contador   := v_contador + 1;
        AQPC594NOMPE := V_FILA_1.AQPC594NOMPE;
        AQPC594codpe := V_FILA_1.AQPC594codpe;
        dni_analis   := TRIM(V_FILA_1.AQPC594DNIUS);
      
        --1ERA REGLA
        If V_FILA_1.AQPC594prosbs IN
           ('03 - CONSUMO REVOLVENTE', '04 - HIPOTECARIO') then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'El campo "Producto_sbs_cliente" contiene los valores "Consumo revolvente", "Hipotecario"',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --2DA REGLA
        If V_FILA_1.aqpc594edad < 18 and V_FILA_1.aqpc594edad > 80 then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'El registro contiene clientes que sean menores a 18 años o mayores a 80 años.',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --3ERA REGLA
        If V_FILA_1.aqpc594gecli IS NULL then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'El campo GENERO del Registro se encuentra con NULL',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --4TA REGLA
        If V_FILA_1.aqpc594codrs like '%NSBTUSER%' then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'El campo del codigo de representante de servicio contiene NSBTUSER ',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --5TA REGLA
        if V_FILA_1.aqpc594prosbs in
           ('13 - PEQUEÑA EMPRESA', '02 - MICROEMPRESAS') and
           V_FILA_1.aqpc594secli = 'NO EXISTE 999' then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'Eliminar si cumple las 2 condiciones a la vez: Si el campo "Segmento" tiene el valor "No existe 999" y en el campo "Producto_sbs_cliente" "micro empresa" o "Pequeña empresa',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --3RA REGLA
        /*begin
          --pues_traba := '';
          select --i.nu_docu_iden, 
           c.de_pues_trab
            into --dni_analista, 
                 pues_traba
            from tdiden_trab@ofiplan i
            left outer join tmtrab_empr@ofiplan e
              on i.co_trab = e.co_trab
            left outer join ttpues_trab@ofiplan c
              on e.co_pues_trab = c.co_pues_trab
           where i.nu_docu_iden = trim(dni_analis);
          commit;
        exception
          when others then
            null;
            pues_traba := '';
        end;*/
      
        if V_FILA_1.AQPC594CARGO not like '%ANALISTA%' OR
           V_FILA_1.AQPC594CARGO is null
        --(cargo cumple todas laws condiciones) no cumple 
         then
          --poner update
          begin
            update AQPC594
               set AQPC594MOT    = 'Si el campo "cargo" no contiene  la palabra analista, debe eliminarse.',
                   AQPC594USER   = USER,
                   AQPC594FECHOR = SYSDATE()
             where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
            --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
            commit;
          exception
            when others then
              null;
          end;
          continue;
        end if;
      
        --5TA REGLA
        begin
          /*select count(*)
              into cont_jaqn002
              from jaqn002 j
             where j.jaqn002ndo = V_FILA_1.aqpc594codpe;
          exception
            when others then
              null;*/
          select COUNT(NU_DOCU_IDEN)
            into cont_cliente
            from tdiden_trab@ofiplan
           where nu_docu_iden = V_FILA_1.aqpc594codpe;
        exception
          when others then
            null;
        end;
      
        if cont_cliente > 0 then
          update AQPC594
             set AQPC594MOT    = 'Eliminar los registros donde el campo "DNI_CLIENTE" pertenezca a un colaborar o ex colaborador de Caja Arequipa.',
                 AQPC594USER   = USER,
                 AQPC594FECHOR = SYSDATE()
           where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
          --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
          commit;
          continue;
        end if;
      
        --CUMPLEN TODAS LAS REGLAS
        begin
          INSERT INTO CRM_NPS_DESEMBOLSOS_Q --AQPC593
            (IDNPSDESEMBOLSOSQ,
             FECHAOPERACION, --AQPC593MES, -- 1
             DNICLIENTE, -- AQPC593CODPE, -- 2
             NOMBRECLIENTE, -- AQPC593NOMPE, -- 3
             PRODUCTOSBSCLIENTE, -- AQPC593PROSBS, -- 4
             SEGMENTO, -- AQPC593SECLI, -- 5
             GENERO, -- AQPC593GECLI, -- 6
             FECNACIM, -- AQPC593FENAC, -- 7
             EDAD, -- AQPC593EDAD, -- 8
             CELULAR1, -- AQPC593TELPE, -- 9
             CELULAR2, -- AQPC593TELP2, -- 10 
             CELULAR3, -- AQPC593TELP3, -- 11
             CODAG, -- AQPC593CODAG, -- 12
             AGENCIA, -- AQPC593DESAG, -- 13
             DEPARTAMENTO, -- AQPC593DEPAG, -- 14
             PROVINCIA, -- AQPC593PROAG, -- 15
             REGION, -- AQPC593DEREG, -- 16
             ZONA, -- AQPC593DEZON, -- 17
             PRODUCTO, -- AQPC593DEPRO, -- 18
             DNIANALISTA, -- AQPC593DNIUS, -- 19
             CODANALISTA, -- AQPC593CODAN, -- 20
             ANALISTA, -- AQPC593NOMAN, -- 21
             CARTERA, -- AQPC593TIPCA, -- 22
             CODRS, -- AQPC593CODRS, -- 23
             RS, -- AQPC593NOMRS, -- 24
             CARGO, -- AQPC593CARGO,
             PRIMERNOMBRE, --AQPC593NOM1,
             CORREO) --AQPC593CORR) --25
          VALUES
            (SEQ_CRM_NPS_DESEMBOLSOS_Q.NEXTVAL,--v_contador,  eninah 2024.03.11
             V_FILA_1.aqpc594mes, --1 
             V_FILA_1.aqpc594codpe, -- 2 
             replace(V_FILA_1.aqpc594nompe,',',''), --3 
             V_FILA_1.aqpc594prosbs, --4 
             V_FILA_1.aqpc594secli, --5
             V_FILA_1.aqpc594gecli, --6
             V_FILA_1.aqpc594fenac, --7
             V_FILA_1.aqpc594edad, --8
             V_FILA_1.aqpc594telpe, --9
             V_FILA_1.aqpc594telp2, --10
             V_FILA_1.aqpc594telp3, --11
             V_FILA_1.aqpc594codag, --12
             V_FILA_1.aqpc594desag, --13
             V_FILA_1.aqpc594depag, --14
             V_FILA_1.aqpc594proag, --15
             V_FILA_1.aqpc594dereg, --16
             V_FILA_1.aqpc594dezon, --17
             V_FILA_1.aqpc594depro, --18
             V_FILA_1.aqpc594dnius, --19
             V_FILA_1.aqpc594codan, --20
             replace(V_FILA_1.aqpc594noman,',',''), --21
             V_FILA_1.aqpc594tipca, --22
             V_FILA_1.aqpc594CODRS, --23
             V_FILA_1.aqpc594NOMRS, --24
             V_FILA_1.AQPC594CARGO,
             V_FILA_1.AQPC594NOM1,
             V_FILA_1.AQPC594CORR); --25
          commit;
        exception
          when others then
            null;
        end;
      
        BEGIN
          update AQPC594
             set AQPC594MOT    = 'CUMPLE CON TODO',
                 AQPC594USER   = USER,
                 AQPC594FECHOR = SYSDATE()
           where AQPC594CODPE = V_FILA_1.AQPC594CODPE;
          --and AQPC594DNIUS = V_FILA_1.AQPC594DNIUS;
          commit;
        exception
          when others then
            null;
        END;
      END LOOP;
    end;
  
    PQ_CR_REPORTE_DESEMBOLSO_AQPC593.sp_cr_insertar_gestor_proceso;
  
  end sp_cr_reporte_desembolso;

  procedure sp_cr_cursor_tabla_log is
    -- *****************************************************************
    -- Nombre                     : sp_cr_cursor_tabla_log
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : EDEHILTON NINA HURTADO
    -- Uso                        : Proceso que extraye información de la tabla JAQY256 del panel de desembolso
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
    pues_traba      varchar2(50);
    posicion_coma   number;
    primer_nombre   varchar2(50);
    nombre_completo varchar2(100);
    correo          varchar2(65);
    lc_correo       varchar2(100);
    dni_analis      varchar2(20); --31035762
    first_nom       VARCHAR2(50);
  begin
    begin
      delete from aqpc594;
      commit;
    end;
    DECLARE
      CURSOR mi_cursor IS
        select * from jaqy256 j;
    begin
      FOR V_FILA in mi_cursor LOOP
        dni_analis := TRIM(V_FILA.JAQY256DNIUS);
        begin
          --Obtener cargo
          select trim(c.de_pues_trab) cargo_empl --,
          --trim(p.no_trab) first_name,
          --lower(trim(p.no_dire_mai1)) email_address
            into pues_traba --, primer_nombre, lc_correo --correo
            from tmtrab_pers@ofiplan p
            left outer join tmtrab_empr@ofiplan e
              on p.co_trab = e.co_trab
            left outer join tdiden_trab@ofiplan i
              on p.co_trab = i.co_trab
          --and ti_docu_iden = 'DNI'
            left outer join ttpues_trab@ofiplan c
              on e.co_pues_trab = c.co_pues_trab
           where e.ti_situ = 'ACT'
             and i.nu_docu_iden = dni_analis; --'71000730';
          --commit;
        
        exception
          when others then
            null;
            pues_traba := 'No data';
            --primer_nombre := 'No data';
          --lc_correo     := 'No data';
        end;
        -- Obtener primer nombre 
        begin
          nombre_completo := V_FILA.JAQY256NOMPE;
          posicion_coma   := INSTR(nombre_completo, ',');
        
          -- Verificar si hay una coma y extraer los caracteres después de la coma
          IF posicion_coma > 0 THEN
            primer_nombre := TRIM(SUBSTR(nombre_completo, posicion_coma + 2));
          END IF;
        
        end;
        begin
          IF INSTR(primer_nombre, ' ') > 0 THEN
            -- Extrae los caracteres antes del primer espacio
            first_nom := SUBSTR(primer_nombre,
                                1,
                                INSTR(primer_nombre, ' ') - 1);
          ELSE
            -- Si no hay espacios, muestra toda la cadena
            first_nom := primer_nombre;
          END IF;
        end;
      
        --Obtener correo 
      
        begin
          select pextxt
            into correo
            from fsx001
           where txcod = 0
             and pendoc = V_FILA.jaqy256codpe;
        exception
          when others then
            null;
        end;
      
        --Esta funcion devuelve el ultimo correo
        lc_correo := ObtenerUltimoCorreo(correo);
      
        begin
          --Aqui se inserta todos los datos de la jaqy256
          insert into AQPC594
            (AQPC594MES, --1
             AQPC594CODPE, --2
             AQPC594NOMPE, --3
             AQPC594PROSBS, --4
             AQPC594SECLI, --5
             AQPC594GECLI, --6
             AQPC594FENAC, --7
             AQPC594EDAD, --8
             AQPC594TELPE, --9
             AQPC594TELP2, --10
             AQPC594TELP3, --11
             AQPC594CODAG, --12
             AQPC594DESAG, --13
             AQPC594DEPAG, --14
             AQPC594PROAG, --15
             AQPC594DEREG, --16
             AQPC594DEZON, --17
             AQPC594DEPRO, --18
             AQPC594DNIUS, --19
             AQPC594CODAN, --20
             AQPC594NOMAN, --21
             AQPC594TIPCA, --22
             AQPC594CODRS, --23
             AQPC594NOMRS, --24
             AQPC594CARGO, --25
             AQPC594NOM1, --26
             AQPC594CORR) --27
          values
            (V_FILA.jaqy256fedes, --1 ((to_number(substr(to_char(V_FILA.jaqy256fedes, 'ddmmyyyy'),3,2))), 
             TRIM(V_FILA.jaqy256codpe), --2
             TRIM(V_FILA.jaqy256nompe), --3
             TRIM(V_FILA.jaqy256prosbs), --4
             TRIM(V_FILA.jaqy256secli), --5
             TRIM(V_FILA.jaqy256gecli), --6
             V_FILA.jaqy256fenac, --7
             V_FILA.jaqy256edad, --8
             TRIM(V_FILA.jaqy256telpe), --9
             TRIM(V_FILA.jaqy256telp2), --10
             TRIM(V_FILA.jaqy256telp3), --11
             TRIM(V_FILA.jaqy256codag), --12
             TRIM(V_FILA.jaqy256desag), --13
             TRIM(V_FILA.jaqy256depag), --14
             TRIM(V_FILA.jaqy256proag), --15
             TRIM(V_FILA.jaqy256dereg), --16
             TRIM(V_FILA.jaqy256dezon), --17
             TRIM(V_FILA.jaqy256depro), --18
             TRIM(V_FILA.jaqy256dnius), --19
             TRIM(V_FILA.jaqy256codan), --20
             TRIM(V_FILA.jaqy256noman), --21
             TRIM(V_FILA.jaqy256tipca), --22
             TRIM(V_FILA.JAQY256CODRS), --23
             TRIM(V_FILA.JAQY256NOMRS), --24
             TRIM(pues_traba), --25
             INITCAP(TRIM(first_nom)), --26
             TRIM(lc_correo)); --27
          commit;
        exception
          when others then
            null;
        end;
      end loop;
    end;
  
  end sp_cr_cursor_tabla_log;

  procedure sp_cr_ejecutar_reporte_desembolso is
    -- *****************************************************************
    -- Nombre                     : sp_cr_ejecutar_reporte_desembolso
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : EDEHILTON NINA
    -- Uso                        : Programa que se ejecuta desde un job que llena la tabla CRM_NPS_DESEMBOLSOS_Q
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    fecha_inicio date;
    fecha_fin    char(10);
    error        varchar(200);
    fecha_input  DATE; -- := TO_DATE(sysdate(), 'DD/MM/RRRR');--TO_DATE(sysdate(), 'DD/MM/RRRR');
  begin
    begin
      select pgfape into fecha_input from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
    begin
      --fecha_inicio := TRUNC(fecha_input, 'MM'); -- Obtiene el primer día del mes
      --fecha_fin := LAST_DAY(fecha_input); -- Obtiene el último día del mes
      fecha_inicio := fecha_input;
      fecha_fin    := to_char(fecha_inicio, 'DDMMYYYY');
    end;
  
    pq_enc_calidad.fn_insercion_jaqy592(fecha_fin, fecha_fin, error);
    PQ_CR_REPORTE_DESEMBOLSO_AQPC593.sp_cr_reporte_desembolso;
  
  end sp_cr_ejecutar_reporte_desembolso;

  procedure sp_cr_insertar_gestor_proceso is
    -- *****************************************************************
    -- Nombre                     : sp_cr_insertar_gestor_proceso
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : EDEHILTON NINA
    -- Uso                        : Proceso que indica que se ejecuto el procedimiento sp_cr_reporte_desembolso correctamente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
    cantidad number;
  begin
    begin
      select count(DNICLIENTE) into cantidad from CRM_NPS_DESEMBOLSOS_Q; --USRWEBCRMD.CRM_NPS_DESEMBOLSOS_Q;
    exception
      when others then
        null;
    end;
  
    --Inserccion a la tabla USRWEBCRMD.CRM_GESTORPROCESO despues de procesar los 
    --datos de la tabla USRWEBCRMD.CRM_NPS_DESEMBOLSOS_Q
    -- Trigger --> TG_CRM_GESTORPROCESO_BI01
    begin
      insert into CRM_GESTORPROCESO --USRWEBCRMD.CRM_GESTORPROCESO
        (TIPO, INBI_FECHA, INBI_REGISTROS, RESULTADO)
      values
        ('NPS_DESEMBOLSOS', sysdate(), cantidad, null);
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_insertar_gestor_proceso;

end PQ_CR_REPORTE_DESEMBOLSO_AQPC593;
/

