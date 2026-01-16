CREATE OR REPLACE PACKAGE JC_MAIN IS
  /*========================================================================================+
  |                      Copyright (c) 2025 Jogzar Consulting S.A.C                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION :                                                                           |
  | function fu_envia_correo: Envia correos unicamente a usuarios de Caja Arequipa, devuelve|
  |                           'Success' en caso haya enviado satisfactoriamente.            |
  | procedure pr_print: Es un DBMS_OUTPUT + FND_FILE.PUT_LINE para anotación en el OUTPUT   |
  |                     de una solicitud y consola.                                         |
  | function fu_create_proyecto: Funcion para crear un registro en la tabla JC_PROYECTOS    |
  | function fu_create_objects: Función para crear un registro en la tabla JC_OBJECTS       |
  | function fu_create_params: Función para crear un registro en la tabla JC_GLOBAL_PARAMS  |
  | function fu_validate_invoices: Función para validar una factura, retorna un booleano.   |
  | function fu_format_date: Función para convertir un varchar2 en date.                    |
  | function fu_get_purchase_order: Función devuelve el po_header_id.                       |
  | function create_a_combination: Función para crear una combinacion contable, retorna el  |
  |                                code_combination_id.                                     |
  | function get_code_combination: Función que retorna el code_combination_id de una        |
  |                                combinación contable. Si esta no existe, la crea y te    |
  |                                devuelve la nueva conbinación contable.                  |
  | procedure process_recipients: Complemento de la función fu_envia_correo, permite        |
  |                               agregar una gran cantidad de receptores.                  |
  | procedure launch_workflow: Proceso a cargo de lanzar workflow de una OC.                |
  |========================================================================================*/
  type email is record(
    de      varchar2(4000),
    para    varchar2(32767),
    cc      varchar2(32767),
    asunto  varchar2(4000),
    mensaje clob);
  FUNCTION fu_envia_correo(pc_de      VARCHAR2,
                           pc_aquien  VARCHAR2,
                           pc_cc1     VARCHAR2,
                           pc_asunto  VARCHAR2,
                           pc_mensaje CLOB) RETURN VARCHAR2;
  PROCEDURE pr_print(msg       VARCHAR2,
                     file_type NUMBER DEFAULT FND_FILE.OUTPUT);
  FUNCTION fu_create_proyecto(v_nombre      VARCHAR2,
                              v_descripcion VARCHAR2,
                              v_id          OUT NUMBER) return boolean;
  FUNCTION fu_create_objects(v_name        VARCHAR2,
                             v_tipo        VARCHAR2,
                             v_origen      VARCHAR2 DEFAULT 'EBS',
                             v_proyecto    NUMBER,
                             v_descripcion VARCHAR2,
                             v_consultor   VARCHAR2,
                             v_estado      VARCHAR2 DEFAULT 'ACTIVO',
                             x_msg         OUT VARCHAR2) return boolean;
  FUNCTION fu_create_params(v_id          number,
                            v_variable    varchar2,
                            v_valor       varchar2,
                            v_descripcion varchar2,
                            v_language    varchar2,
                            v_tipo        varchar2,
                            x_msg         OUT VARCHAR2) RETURN BOOLEAN;

  FUNCTION fu_validate_invoices(l_invoice_id number) RETURN BOOLEAN;
  FUNCTION fu_format_date(l_date varchar2) RETURN DATE;
  function fu_get_purchase_order(p_interface_header_id number,
                                 msg                   out varchar2)
    return number;
  FUNCTION create_a_combination(p_segment1             in varchar2,
                                p_segment2             in varchar2,
                                p_segment3             in varchar2,
                                p_segment4             in varchar2,
                                p_segment5             in varchar2,
                                p_segment6             in varchar2,
                                p_segment7             in varchar2,
                                p_segment8             in varchar2,
                                p_segment9             in varchar2,
                                p_flex_delimiter       in varchar2,
                                p_chart_of_accounts_id in number,
                                p_ccid                 out number)
    return varchar2;
  FUNCTION get_code_combination(p_segment1          in gl_code_combinations.segment1%type,
                                p_segment2          in gl_code_combinations.segment2%type,
                                p_segment3          in gl_code_combinations.segment3%type,
                                p_segment4          in gl_code_combinations.segment4%type,
                                p_segment5          in gl_code_combinations.segment5%type,
                                p_segment6          in gl_code_combinations.segment6%type,
                                p_segment7          in gl_code_combinations.segment7%type,
                                p_segment8          in gl_code_combinations.segment8%type,
                                p_segment9          in gl_code_combinations.segment9%type,
                                p_set_of_books_name in gl_ledgers.name%type,
                                p_error_msg         out varchar2,
                                p_error_loc         out varchar2)
    return gl_code_combinations.code_combination_id%type;
  PROCEDURE process_recipients(p_mail_conn in out utl_smtp.connection,
                               p_list      in varchar2);
  PROCEDURE launch_workflow(p_po_header_id number);
END JC_MAIN;
/
CREATE OR REPLACE PACKAGE BODY JC_MAIN IS
  -----------------------------------------------------------------------
  FUNCTION fu_envia_correo(pc_de      VARCHAR2,
                           pc_aquien  VARCHAR2,
                           pc_cc1     VARCHAR2,
                           pc_asunto  VARCHAR2,
                           pc_mensaje CLOB) return varchar2 as
    EmailServer VARCHAR2(80);
    Port        NUMBER;
    conn        UTL_SMTP.CONNECTION;
    crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
    mesg       CLOB;
    vhost_name VARCHAR2(100);
    vc_cc1     VARCHAR2(32000);
  BEGIN
    BEGIN
      SELECT host_name INTO vhost_name FROM v$instance;
    EXCEPTION
      WHEN OTHERS THEN
        vhost_name := 'SC02-DBADM0107';
    END;
    IF UPPER(vhost_name) = 'SC02-DBADM0107' THEN
      EmailServer := '10.0.200.68';
      Port        := 25;
    ELSIF UPPER(vhost_name) = 'T82EBSBD1051' THEN
      EmailServer := '10.0.202.233';
      Port        := 25;
    ELSE
      RETURN 'Error: Host no reconocido';
    END IF;
  
    IF pc_aquien IS NULL THEN
      RETURN 'Error: No hay receptor';
    END IF;
  
    conn := UTL_SMTP.OPEN_CONNECTION(EmailServer, Port);
    UTL_SMTP.HELO(conn, EmailServer);
    UTL_SMTP.MAIL(conn, pc_de);
    process_recipients(conn, pc_aquien);
  
    IF pc_cc1 IS NOT NULL THEN
      UTL_SMTP.RCPT(conn, pc_cc1);
      vc_cc1 := 'CC: ' || pc_cc1 || crlf;
    ELSE
      vc_cc1 := NULL;
    END IF;
  
    mesg := 'From: ' || pc_de || crlf || 'To: ' || pc_aquien || crlf ||
            NVL(vc_cc1, '') || 'Subject: ' || pc_asunto || crlf ||
            'Content-Type: text/html; charset=UTF-8' || crlf || crlf ||
            pc_mensaje || crlf;
  
    UTL_SMTP.OPEN_DATA(conn);
    UTL_SMTP.WRITE_DATA(conn, mesg);
    UTL_SMTP.CLOSE_DATA(conn);
  
    UTL_SMTP.QUIT(conn);
  
    RETURN 'Success';
  EXCEPTION
    WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
      RETURN 'Error de SMTP: ' || SQLERRM;
    WHEN OTHERS THEN
      RETURN 'Error inesperado: ' || SQLERRM;
  END fu_envia_correo;
  PROCEDURE pr_print(msg       VARCHAR2,
                     file_type NUMBER DEFAULT FND_FILE.OUTPUT) IS
  BEGIN
    IF msg IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(msg);
      BEGIN
        FND_FILE.PUT_LINE(file_type, msg || CHR(10));
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Advertencia: No se pudo escribir en FND_FILE.' ||
                               SQLERRM);
      END;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Advertencia: Mensaje vacío recibido.');
    END IF;
  END pr_print;
  FUNCTION fu_create_proyecto(v_nombre      varchar2,
                              v_descripcion varchar2,
                              v_id          out number) return boolean as
    v_count NUMBER;
  BEGIN
    BEGIN
      SELECT count(*)
        INTO v_count
        FROM jc_proyectos
       WHERE upper(nombre) = upper(v_nombre);
    EXCEPTION
      WHEN OTHERS THEN
        v_count := 0;
    END;
    IF v_count = 0 THEN
      v_id := SEQ_JC_PROYECTOS.NEXTVAL;
      INSERT INTO jc_proyectos
      VALUES
        (v_id, v_nombre, v_descripcion, 0, SYSDATE, 0, SYSDATE);
      commit;
      RETURN true;
    ELSE
      SELECT ID
        INTO V_ID
        FROM JC_PROYECTOS
       WHERE upper(nombre) = upper(v_nombre);
      RETURN false;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      v_id := 0;
      ROLLBACK;
      RETURN false;
  END;
  FUNCTION fu_create_objects(v_name        VARCHAR2,
                             v_tipo        VARCHAR2,
                             v_origen      VARCHAR2 DEFAULT 'EBS',
                             v_proyecto    NUMBER,
                             v_descripcion VARCHAR2,
                             v_consultor   VARCHAR2,
                             v_estado      VARCHAR2 DEFAULT 'ACTIVO',
                             x_msg         OUT VARCHAR2) return boolean as
    v_count number;
    v_id    number;
  BEGIN
    BEGIN
      SELECT count(*) INTO v_count FROM jc_proyectos WHERE id = v_proyecto;
    EXCEPTION
      WHEN OTHERS THEN
        v_count := 0;
    END;
    BEGIN
      IF v_tipo NOT IN
         ('TABLA', 'VISTA', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE') THEN
        x_msg := 'Tipo de Objeto no es correcto.';
        RETURN false;
      END IF;
      IF v_origen NOT IN ('APEX', 'EBS') THEN
        x_msg := 'Origen no válido.';
        RETURN false;
      END IF;
      IF v_count = 0 THEN
        x_msg := 'ID de Proyecto Invalido';
        RETURN false;
      END IF;
      IF v_estado NOT IN ('ACTIVO', 'INACTIVO', 'OBSOLETO') THEN
        x_msg := 'Estado Invalido.';
        RETURN false;
      END IF;
    END;
    BEGIN
      SELECT count(*)
        INTO v_count
        FROM jc_objects
       WHERE id = v_proyecto
         AND name = v_name;
    EXCEPTION
      WHEN OTHERS THEN
        v_count := 0;
    END;
    BEGIN
      IF v_count != 0 THEN
        x_msg := 'Este Objeto ya Existe';
        RETURN false;
      END IF;
    END;
    v_id := SEQ_JC_OBJECTS.NEXTVAL;
    INSERT INTO jc_objects
    VALUES
      (v_id,
       v_name,
       v_tipo,
       v_origen,
       v_proyecto,
       v_descripcion,
       sysdate,
       v_consultor,
       sysdate,
       v_consultor,
       v_estado);
    commit;
    RETURN true;
  EXCEPTION
    WHEN OTHERS THEN
      x_msg := SQLERRM;
      RETURN false;
  END;
  FUNCTION fu_create_params(v_id          number,
                            v_variable    varchar2,
                            v_valor       varchar2,
                            v_descripcion varchar2,
                            v_language    varchar2,
                            v_tipo        varchar2,
                            x_msg         OUT VARCHAR2) RETURN BOOLEAN AS
    v_count NUMBER;
    id      NUMBER;
  BEGIN
    BEGIN
      SELECT count(*) INTO v_count FROM jc_proyectos WHERE id = v_id;
    EXCEPTION
      WHEN OTHERS THEN
        v_count := 0;
    END;
    BEGIN
      IF v_count = 0 THEN
        x_msg := 'ID de Proyecto Invalido.';
        RETURN false;
      END IF;
      IF v_language NOT IN ('ESA', 'US') THEN
        x_msg := 'Lenguaje Invalido.';
        RETURN false;
      END IF;
      IF v_tipo NOT IN ('NUMBER', 'VARCHAR2', 'DATE') THEN
        x_msg := 'Tipo de Dato Invalido.';
        RETURN false;
      END IF;
    END;
    BEGIN
      SELECT count(*)
        INTO v_count
        FROM jc_global_params
       WHERE PROYECTO_ID = v_id
         AND VARIABLE = v_variable;
    EXCEPTION
      WHEN OTHERS THEN
        v_count := 0;
    END;
    BEGIN
      IF v_count != 0 THEN
        x_msg := 'Variable ya existe.';
        RETURN false;
      END IF;
    END;
    id := SEQ_JC_GLOBAL_PARAMS.NEXTVAL;
    INSERT INTO jc_global_params
    values
      (id,
       v_id,
       v_variable,
       v_valor,
       v_descripcion,
       v_language,
       v_tipo,
       0,
       sysdate,
       0,
       sysdate);
    commit;
    RETURN true;
  EXCEPTION
    WHEN OTHERS THEN
      x_msg := SQLERRM;
      RETURN false;
  END;
  FUNCTION fu_validate_invoices(l_invoice_id number) RETURN BOOLEAN is
    nRequestId    NUMBER;
    v_org_id      NUMBER := 81; -- ID de la unidad operativa
    v_option      VARCHAR2(50) := 'All'; -- Opción de coincidencia ("All" para todos los tipos de coincidencia)
    lc_phase      varchar2(100);
    lc_status     varchar2(100);
    lc_dev_phase  varchar2(100);
    lc_dev_status varchar2(100);
    lc_message    varchar2(100);
    lb_complete   boolean;
  BEGIN
    pr_print('------------------------------------------------------------');
    pr_print('Inicio FU_VALIDATE_INVOICES: ' || l_invoice_id);
    pr_print('------------------------------------------------------------');
    pr_print('Set Variable: S , 81 , 0 , 50697, 200');
    mo_global.set_policy_context('S', 81);
    fnd_global.apps_initialize(0, 50697, 200);
    --execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    nRequestId := FND_REQUEST.submit_request(application => 'SQLAP', -- Aplicación: AP (Cuentas por pagar)
                                             program     => 'APPRVL', -- Programa de validación de facturas
                                             description => 'Invoice Validation', -- Descripción opcional
                                             start_time  => SYSDATE, -- Fecha de inicio para la ejecución del proceso
                                             sub_request => FALSE, -- Indica si es una solicitud subordinada
                                             argument1   => v_org_id, -- Unidad operativa (p_org_id)
                                             argument2   => v_option, -- Opción de coincidencia (p_option)
                                             argument3   => '', -- Nombre del lote (p_inv_batch_id) NULL para factura única
                                             argument4   => '', -- Fecha de inicio (p_inv_start_date)
                                             argument5   => '', -- Fecha de fin (p_inv_end_date)
                                             argument6   => '', -- ID del proveedor (p_vendor_id)
                                             argument7   => 'AGENCIA DE VIAJES', -- Grupo de pago (p_pay_group)
                                             argument8   => l_invoice_id, -- ID de la factura específica (p_invoice_id)
                                             argument9   => '', -- ID de usuario (p_entered_by)
                                             argument10  => 'N',
                                             argument11  => 1000,
                                             argument12  => 1,
                                             argument13  => 'N');
  
    COMMIT;
    pr_print('Solicitud enviada con Request ID: ' || nRequestId);
    if nRequestId > 0 then
      lb_complete := fnd_concurrent.wait_for_request(request_id => nRequestId,
                                                     interval   => 2,
                                                     max_wait   => 5000,
                                                     phase      => lc_phase,
                                                     status     => lc_status,
                                                     dev_phase  => lc_dev_phase,
                                                     dev_status => lc_dev_status,
                                                     message    => lc_message);
      if upper(lc_dev_phase) in ('COMPLETE', 'COMPLETED') then
        pr_print('Concurrent request completed successfully');
        return true;
      end if;
      if lb_complete then
        null;
      end if;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      pr_print('Error al enviar la solicitud: ' || SQLERRM);
      return false;
  END;
  FUNCTION fu_format_date(l_date VARCHAR2) RETURN DATE IS
    v_date DATE;
  BEGIN
    -- Intento 1: DD/MM/YYYY
    BEGIN
      RETURN TO_DATE(l_date, 'DD/MM/YYYY');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- Intento 2: YYYY-MM-DD (formato ISO)
    BEGIN
      RETURN TO_DATE(l_date, 'YYYY-MM-DD');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- Intento 3: DD-MON-YY con idioma en inglés
    BEGIN
      v_date := TO_DATE(l_date, 'DD-MON-YY', 'NLS_DATE_LANGUAGE=ENGLISH');
      -- Ajuste siglo si está mal interpretado
      IF TO_NUMBER(TO_CHAR(v_date, 'YYYY')) < 100 THEN
        IF TO_NUMBER(TO_CHAR(v_date, 'YY')) < 50 THEN
          v_date := ADD_MONTHS(v_date,
                               (2000 - TO_NUMBER(TO_CHAR(v_date, 'YYYY'))) * 12);
        ELSE
          v_date := ADD_MONTHS(v_date,
                               (1900 - TO_NUMBER(TO_CHAR(v_date, 'YYYY'))) * 12);
        END IF;
      END IF;
      RETURN v_date;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- Intento 4: Número serial de Excel (base 1900-01-01 con desfase)
    BEGIN
      RETURN TO_DATE('1900-01-01', 'YYYY-MM-DD') + TO_NUMBER(l_date) - 2;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN NULL;
    END;
  END;
  function fu_get_purchase_order(p_interface_header_id number,
                                 msg                   out varchar2)
    return number is
    error        varchar2(4000);
    process_code varchar2(20);
    po_header_id number;
  begin
    select process_code
      into process_code
      from po.po_headers_interface
     where interface_header_id = p_interface_header_id;
    if process_code = 'ACCEPTED' then
      select po_header_id
        into po_header_id
        from po.po_headers_interface
       where interface_header_id = p_interface_header_id;
      return po_header_id;
    elsif process_code = 'REJECTED' then
      begin
        select error_message
          into error
          from po_interface_errors
         where interface_header_id = p_interface_header_id
           and table_name = 'PO_HEADERS_INTERFACE';
        msg := msg || '|' || error;
        return 0;
      exception
        when NO_DATA_FOUND then
          begin
            for x in (select pli.interface_line_id,
                             pli.line_num,
                             pdi.interface_distribution_id
                        from po_lines_interface         pli,
                             po_distributions_interface pdi
                       where pli.interface_line_id = pdi.interface_line_id
                         and pli.interface_header_id = p_interface_header_id) loop
              begin
                select error_message
                  into error
                  from po_interface_errors
                 where interface_header_id = x.interface_line_id
                   and table_name = 'PO_LINES_INTERFACE';
                msg := msg || '|' || error || '| Linea: ' || x.line_num;
                return 0;
              exception
                when NO_DATA_FOUND then
                  select error_message
                    into error
                    from po_interface_errors
                   where interface_header_id = x.interface_distribution_id
                     and table_name = 'PO_LINE_LOCATIONS_INTERFACE';
                  msg := msg || '|' || error || '| Linea: ' || x.line_num;
                  return 0;
              end;
            end loop;
          end;
        when OTHERS then
          msg := msg || '| Error Desconocido.';
          return 0;
      end;
    end if;
  exception
    when others then
      return 0;
  end;
  function create_a_combination(p_segment1             in varchar2,
                                p_segment2             in varchar2,
                                p_segment3             in varchar2,
                                p_segment4             in varchar2,
                                p_segment5             in varchar2,
                                p_segment6             in varchar2,
                                p_segment7             in varchar2,
                                p_segment8             in varchar2,
                                p_segment9             in varchar2,
                                p_flex_delimiter       in varchar2,
                                p_chart_of_accounts_id in number,
                                p_ccid                 out number)
    return varchar2 is
    ccid        number := 0;
    allsegments varchar2(256) := null;
    flexerror   varchar2(2560) := null;
  begin
    --p_error_loc := 'Create CCID';
    allsegments := p_segment1 || p_flex_delimiter || p_segment2 ||
                   p_flex_delimiter || p_segment3 || p_flex_delimiter ||
                   p_segment4 || p_flex_delimiter || p_segment5 ||
                   p_flex_delimiter || p_segment6 || p_flex_delimiter ||
                   p_segment7 || p_flex_delimiter || p_segment8 ||
                   p_flex_delimiter || p_segment9;
    dbms_output.put_line('Inside create_a_combination-' || allsegments);
    ccid   := fnd_flex_ext.get_ccid(application_short_name => 'SQLGL',
                                    key_flex_code          => 'GL#',
                                    structure_number       => p_chart_of_accounts_id,
                                    validation_date        => to_char(sysdate,
                                                                      fnd_flex_ext.date_format),
                                    concatenated_segments  => allsegments);
    p_ccid := ccid;
  
    if ccid <= 0 then
      flexerror := fnd_message.get;
    end if;
  
    return flexerror;
  exception
    when others then
      p_ccid    := 0;
      flexerror := sqlerrm || ' ' || fnd_message.get;
      return flexerror;
  end create_a_combination;
  function get_code_combination(p_segment1          in gl_code_combinations.segment1%type,
                                p_segment2          in gl_code_combinations.segment2%type,
                                p_segment3          in gl_code_combinations.segment3%type,
                                p_segment4          in gl_code_combinations.segment4%type,
                                p_segment5          in gl_code_combinations.segment5%type,
                                p_segment6          in gl_code_combinations.segment6%type,
                                p_segment7          in gl_code_combinations.segment7%type,
                                p_segment8          in gl_code_combinations.segment8%type,
                                p_segment9          in gl_code_combinations.segment9%type,
                                p_set_of_books_name in gl_ledgers.name%type,
                                p_error_msg         out varchar2,
                                p_error_loc         out varchar2)
    return gl_code_combinations.code_combination_id%type is
    cursor c_ccid_validate(p_segment1 in gl_code_combinations.segment1%type, p_segment2 in gl_code_combinations.segment2%type, p_segment3 in gl_code_combinations.segment3%type, p_segment4 in gl_code_combinations.segment4%type, p_segment5 in gl_code_combinations.segment5%type, p_segment6 in gl_code_combinations.segment6%type, p_segment7 in gl_code_combinations.segment7%type, p_segment8 in gl_code_combinations.segment8%type, p_segment9 in gl_code_combinations.segment9%type) is
      select code_combination_id
        from gl_code_combinations
       where segment1 = p_segment1
         and segment2 = p_segment2
         and segment3 = p_segment3
         and segment4 = p_segment4
         and segment5 = p_segment5
         and segment6 = p_segment6
         and segment7 = p_segment7
         and segment8 = p_segment8
         and segment9 = p_segment9;
  
    cursor c_flex_details is
      select id_flex_num
        from fnd_id_flex_segments
       where id_flex_num =
             (select chart_of_accounts_id
                from gl_ledgers
               where ledger_id =
                     (select ledger_id
                        from gl_ledgers
                       where name = p_set_of_books_name))
         and application_id =
             (select application_id
                from fnd_application
               where application_short_name = 'SQLGL')
         and enabled_flag = 'Y'
         and rownum = 1;
  
    l_flex_details c_flex_details%rowtype;
    l_flexerror    varchar2(2560) := null;
    /*l_acc_segment1 gl_code_combinations.segment1%TYPE;
    l_acc_segment2 gl_code_combinations.segment2%TYPE;
    l_acc_segment3 gl_code_combinations.segment3%TYPE;
    l_acc_segment4 gl_code_combinations.segment4%TYPE;
    l_acc_segment5 gl_code_combinations.segment5%TYPE;
    l_acc_segment6 gl_code_combinations.segment6%TYPE;
    l_acc_segment7 gl_code_combinations.segment7%TYPE;
    l_acc_segment8 gl_code_combinations.segment8%TYPE;
    l_acc_segment9 gl_code_combinations.segment9%TYPE;*/
    l_ccid gl_code_combinations.code_combination_id%type := null;
    --l_user_name    fnd_user.user_name%TYPE := fnd_profile.VALUE('USERNAME');
    x_delimiter varchar2(10);
  begin
    p_error_loc := 'Validate CCID';
  
    for c_ccid_validate_rec in c_ccid_validate(p_segment1,
                                               p_segment2,
                                               p_segment3,
                                               p_segment4,
                                               p_segment5,
                                               p_segment6,
                                               p_segment7,
                                               p_segment8,
                                               p_segment9) loop
      l_ccid := c_ccid_validate_rec.code_combination_id;
      return(l_ccid);
    end loop;
  
    if l_ccid is null then
      fnd_file.put_line(fnd_file.log,
                        'CCID Not Found in gl_code_combinations');
      fnd_file.put_line(fnd_file.log,
                        'CCID Not Found..Creating New CCID...');
    
      -------- Cursor for getting the SOB details---------------------------
      open c_flex_details;
    
      fetch c_flex_details
        into l_flex_details;
    
      close c_flex_details;
    
      fnd_file.put_line(fnd_file.log,
                        'chart of account :-' || l_flex_details.id_flex_num);
      x_delimiter := fnd_flex_ext.get_delimiter(application_short_name => 'SQLGL',
                                                key_flex_code          => 'GL#',
                                                structure_number       => l_flex_details.id_flex_num);
      --Create CCID
      l_flexerror := create_a_combination(p_segment1,
                                          p_segment2,
                                          p_segment3,
                                          p_segment4,
                                          p_segment5,
                                          p_segment6,
                                          p_segment7,
                                          p_segment8,
                                          p_segment9,
                                          x_delimiter,
                                          l_flex_details.id_flex_num,
                                          l_ccid);
      fnd_file.put_line(fnd_file.log, 'Newly Created CCID-' || l_ccid);
    
      if l_ccid <= 0 then
        fnd_file.put_line(fnd_file.log, 'l_flexerror' || l_flexerror);
        p_error_msg := l_flexerror;
        return(0);
      else
        p_error_msg := null;
        return(l_ccid);
      end if;
    end if;
  exception
    when no_data_found then
      l_flexerror := sqlerrm;
      p_error_msg := l_flexerror;
      return 0;
    when others then
      l_flexerror := sqlerrm;
      p_error_msg := l_flexerror;
      return 0;
  end get_code_combination;
  PROCEDURE process_recipients(p_mail_conn in out utl_smtp.connection,
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
  PROCEDURE launch_workflow(p_po_header_id number) is
  
    l_itemtype             varchar2(30) := 'POAPPRV';
    l_itemkey              varchar2(300);
    l_item_key_seq         number;
    l_po_header_id         number;
    l_type_lookup_code     varchar2(300);
    l_document_number      varchar2(300);
    l_approver_user_name   varchar2(3000);
    l_preparer_id          number;
    l_forward_from_id      number;
    l_forward_from_name    varchar2(3000);
    l_printer              varchar2(3000);
    l_conc_copies          number;
    l_conc_save_output     varchar2(3000);
    l_open_form            varchar2(3000);
    l_ame_approval_id      number;
    l_vendor               varchar2(3000);
    l_vendor_site_code     varchar2(3000);
    l_org_id               number;
    l_user_id              number;
    l_responsibility_id    number;
    l_application_id       number;
    x_username             varchar2(100);
    x_user_display_name    varchar2(240);
    x_ff_username          varchar2(100);
    x_ff_user_display_name varchar2(240);
  
    cursor main is
      select poh.type_lookup_code,
             poh.po_header_id,
             poh.segment1,
             papf1.full_name,
             poh.agent_id,
             ame_approval_id
        from po_headers_all poh,
             (select distinct person_id, full_name from per_all_people_f) papf1
       where 1 = 1
         and rownum = 1
         and poh.agent_id = papf1.person_id
         and poh.po_header_id = p_po_header_id
         and poh.wf_item_type is null;
  
  begin
  
    l_org_id            := nvl(fnd_profile.value('ORG_ID'), 81);
    l_user_id           := nvl(fnd_profile.value('USER_ID'), 0);
    l_responsibility_id := nvl(fnd_profile.value('RESP_ID'), 50678);
    l_application_id    := nvl(fnd_profile.value('RESP_APPL_ID'), 201);
  
    l_printer          := fnd_profile.value('PRINTER');
    l_conc_copies      := to_number(fnd_profile.value('CONC_COPIES'));
    l_conc_save_output := fnd_profile.value('CONC_SAVE_OUTPUT');
  
    fnd_global.apps_initialize(l_user_id,
                               l_responsibility_id,
                               l_application_id,
                               null,
                               null);
  
    for x in main loop
    
      l_type_lookup_code   := x.type_lookup_code;
      l_po_header_id       := x.po_header_id;
      l_document_number    := x.segment1;
      l_approver_user_name := x.full_name;
      l_preparer_id        := x.agent_id;
      l_ame_approval_id    := x.ame_approval_id;
    
      select pov.vendor_name, pvs.vendor_site_code
        into l_vendor, l_vendor_site_code
        from po_vendors          pov,
             po_headers_merge_v  poh,
             po_vendor_sites_all pvs
       where 1 = 1
         and rownum = 1
         and pov.vendor_id = poh.vendor_id
         and poh.po_header_id = l_po_header_id
         and poh.draft_id = -1
         and poh.vendor_site_id = pvs.vendor_site_id;
    
      select distinct a.person_id, a.full_name
        into l_forward_from_id, l_forward_from_name
        from per_all_people_f a, fnd_user b
       where 1 = 1
         and rownum = 1
         and a.person_id = b.employee_id
         and b.user_id = l_user_id;
    
      select po_wf_itemkey_s.nextval into l_item_key_seq from dual;
    
      l_itemkey := l_po_header_id || '-' || l_item_key_seq;
    
      dbms_output.put_line('STARTED    ' || l_itemkey);
    
      wf_engine.createprocess(l_itemtype, l_itemkey, 'PO_AME_APPRV_TOP');
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'ORG_ID',
                                avalue   => l_org_id);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'USER_ID',
                                avalue   => l_user_id);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'RESPONSIBILITY_ID',
                                avalue   => l_responsibility_id);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'APPLICATION_ID',
                                avalue   => l_application_id);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'DOCUMENT_NUMBER',
                                avalue   => l_document_number);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'DOCUMENT_NUM_REL',
                                avalue   => l_document_number);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'DOCUMENT_TYPE',
                                avalue   => 'PO');
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'DOCUMENT_SUBTYPE',
                                avalue   => l_type_lookup_code);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'PREPARER_ID',
                                avalue   => l_preparer_id);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'APPROVER_EMPID',
                                avalue   => l_preparer_id);
    
      po_reqapproval_init1.get_user_name(l_preparer_id,
                                         x_username,
                                         x_user_display_name);
    
      wf_engine.setitemowner(itemtype => l_itemtype,
                             itemkey  => l_itemkey,
                             owner    => x_username);
    
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PREPARER_USER_NAME',
                                     avalue   => x_username);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PREPARER_DISPLAY_NAME',
                                     avalue   => x_user_display_name);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'APPROVER_USER_NAME',
                                     avalue   => x_username);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'APPROVER_DISPLAY_NAME',
                                     avalue   => x_user_display_name);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PREPARER_PRINTER',
                                     avalue   => l_printer);
      po_wf_util_pkg.setitemattrnumber(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'PREPARER_CONC_COPIES',
                                       avalue   => l_conc_copies);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PREPARER_CONC_SAVE_OUTPUT',
                                     avalue   => l_conc_save_output);
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'FORWARD_FROM_ID',
                                avalue   => l_forward_from_id);
    
      if (l_forward_from_id <> l_preparer_id) then
        po_reqapproval_init1.get_user_name(l_forward_from_id,
                                           x_ff_username,
                                           x_ff_user_display_name);
        po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'FORWARD_FROM_USER_NAME',
                                       avalue   => x_ff_username);
        po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'FORWARD_FROM_DISP_NAME',
                                       avalue   => x_ff_user_display_name);
      else
        po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'FORWARD_FROM_USER_NAME',
                                       avalue   => x_username);
        po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'FORWARD_FROM_DISP_NAME',
                                       avalue   => x_user_display_name);
      end if;
    
      wf_engine.setitemattrtext(itemtype => l_itemtype,
                                itemkey  => l_itemkey,
                                aname    => 'DOCUMENT_ID',
                                avalue   => l_po_header_id);
    
      l_open_form := 'PO_POXPOEPO:PO_HEADER_ID=' || l_po_header_id ||
                     ' ACCESS_LEVEL_CODE=MODIFY' ||
                     ' POXPOEPO_CALLING_FORM=POXSTNOT';
    
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'OPEN_FORM_COMMAND',
                                     avalue   => l_open_form);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PO_EMAIL_HEADER',
                                     avalue   => 'PLSQL:PO_EMAIL_GENERATE.GENERATE_HEADER/' ||
                                                 l_itemtype || ':' ||
                                                 l_itemkey);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PO_EMAIL_BODY',
                                     avalue   => 'PLSQLCLOB:PO_EMAIL_GENERATE.GENERATE_HTML/' ||
                                                 l_itemtype || ':' ||
                                                 l_itemkey);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'PO_TERMS_CONDITIONS',
                                     avalue   => 'PLSQLCLOB:PO_EMAIL_GENERATE.GENERATE_TERMS/' ||
                                                 l_itemtype || ':' ||
                                                 l_itemkey);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'SUPPLIER',
                                     avalue   => l_vendor);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'SUPPLIER_SITE',
                                     avalue   => l_vendor_site_code);
      po_wf_util_pkg.setitemattrnumber(itemtype => l_itemtype,
                                       itemkey  => l_itemkey,
                                       aname    => 'AME_TRANSACTION_ID',
                                       avalue   => l_ame_approval_id);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'AME_TRANSACTION_TYPE',
                                     avalue   => 'PURCHASE_ORDER');
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => 'NOTIFICATION_REGION',
                                     avalue   => 'JSP:/OA_HTML/OA.jsp?OAFunc=PO_APPRV_NOTIF&poHeaderId=' ||
                                                 l_po_header_id);
      po_wf_util_pkg.setitemattrtext(itemtype => l_itemtype,
                                     itemkey  => l_itemkey,
                                     aname    => '#HISTORY',
                                     avalue   => 'JSP:/OA_HTML/OA.jsp?OAFunc=PO_APPRV_NTF_ACTION_DETAILS&poHeaderId=' ||
                                                 l_po_header_id ||
                                                 '&ameTransactionType=PURCHASE_ORDER&ameTransactionId=' ||
                                                 l_ame_approval_id ||
                                                 '&showActions=Y');
    
      update wf_items
         set user_key = l_document_number
       where item_type = l_itemtype
         and item_key = l_itemkey
         and user_key is null;
    
      wf_engine.startprocess(l_itemtype, l_itemkey);
    
      commit;
    
    end loop;
    if l_po_header_id is null then
      dbms_output.put_line('Procesos con WF Activo, limpiar los valores del WF y vuelve a ejecutar!');
      commit;
    end if;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
  end;
END JC_MAIN;
/
