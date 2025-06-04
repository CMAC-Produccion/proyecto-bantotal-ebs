create or replace package jc_invoice_arrendamiento_pkg as
  type tp_jc_inv_tmp is record(
    id                    jc_arrendamiento_tmp.id%type,
    nro_carga             jc_arrendamiento_tmp.nro_carga%type,
    tipo                  jc_arrendamiento_tmp.tipo%type,
    ag                    jc_arrendamiento_tmp.ag%type,
    proveedor             jc_arrendamiento_tmp.proveedor%type,
    periodo               jc_arrendamiento_tmp.periodo%type,
    invoice_amount        jc_arrendamiento_tmp.invoice_amount%type,
    invoice_tax_amount    jc_arrendamiento_tmp.invoice_tax_amount%type,
    oc                    jc_arrendamiento_tmp.oc%type,
    invoice_currency_code jc_arrendamiento_tmp.invoice_currency_code%type,
    acta                  jc_arrendamiento_tmp.acta%type,
    tipo_documento        jc_arrendamiento_tmp.tipo_documento%type,
    invoice_date          jc_arrendamiento_tmp.invoice_date%type,
    invoice_num           jc_arrendamiento_tmp.invoice_num%type,
    oc_amount             jc_arrendamiento_tmp.oc_amount%type,
    oc_tax_amount         jc_arrendamiento_tmp.oc_tax_amount%type,
    cuenta_contable       jc_arrendamiento_tmp.cuenta_contable%type,
    centro_costo          jc_arrendamiento_tmp.centro_costo%type,
    detraccion            jc_arrendamiento_tmp.detraccion%type,
    tipo_servicio         jc_arrendamiento_tmp.tipo_servicio%type,
    codigo_impuesto       jc_arrendamiento_tmp.codigo_impuesto%type,
    motivo_excepcion      jc_arrendamiento_tmp.motivo_excepcion%type,
    observacion           jc_arrendamiento_tmp.observacion%type,
    enabled_flag          jc_arrendamiento_tmp.enabled_flag%type,
    created_by            jc_arrendamiento_tmp.created_by%type,
    creation_date         jc_arrendamiento_tmp.creation_date%type,
    last_update_by        jc_arrendamiento_tmp.last_update_by%type,
    last_update_date      jc_arrendamiento_tmp.last_update_date%type);
  type tp_jc_inv_main is record(
    id                       jc_arrendamiento_main.id%type,
    nro_carga                jc_arrendamiento_main.nro_carga%type,
    id_interface             jc_arrendamiento_main.id_interface%type,
    id_invoice               jc_arrendamiento_main.id_invoice%type,
    last_update_date         jc_arrendamiento_main.last_update_date%type,
    last_update_by           jc_arrendamiento_main.last_update_by%type,
    creation_date            jc_arrendamiento_main.creation_date%type,
    created_by               jc_arrendamiento_main.created_by%type,
    estado                   jc_arrendamiento_main.estado%type,
    tipo                     jc_arrendamiento_main.tipo%type,
    ag                       jc_arrendamiento_main.ag%type,
    proveedor                jc_arrendamiento_main.proveedor%type,
    periodo                  jc_arrendamiento_main.periodo%type,
    invoice_amount           jc_arrendamiento_main.invoice_amount%type,
    invoice_tax_amount       jc_arrendamiento_main.invoice_tax_amount%type,
    oc                       jc_arrendamiento_main.oc%type,
    invoice_currency_code    jc_arrendamiento_main.invoice_currency_code%type,
    acta                     jc_arrendamiento_main.acta%type,
    tipo_documento           jc_arrendamiento_main.tipo_documento%type,
    invoice_date             jc_arrendamiento_main.invoice_date%type,
    invoice_num              jc_arrendamiento_main.invoice_num%type,
    oc_amount                jc_arrendamiento_main.oc_amount%type,
    oc_tax_amount            jc_arrendamiento_main.oc_tax_amount%type,
    cuenta_contable          jc_arrendamiento_main.cuenta_contable%type,
    centro_costo             jc_arrendamiento_main.centro_costo%type,
    detraccion               jc_arrendamiento_main.detraccion%type,
    tipo_servicio            jc_arrendamiento_main.tipo_servicio%type,
    codigo_impuesto          jc_arrendamiento_main.codigo_impuesto%type,
    motivo_excepcion         jc_arrendamiento_main.motivo_excepcion%type,
    fecha_contable           jc_arrendamiento_main.fecha_contable%type,
    observacion              jc_arrendamiento_main.observacion%type,
    enabled_flag             jc_arrendamiento_main.enabled_flag%type,
    terms_name               ap_invoices_interface.terms_name%type,
    group_id                 ap_invoices_interface.group_id%type,
    total_amount             ap_invoices_all.invoice_amount%type,
    source                   ap_invoices_all.source%type,
    invoice_type_lookup_code ap_invoices_all.invoice_type_lookup_code%type,
    payment_method_code      ap_invoices_all.payment_method_code%type,
    terms_date               ap_invoices_all.terms_date%type,
    attribute1               ap_invoices_all.attribute1%type,
    line_number              ap_invoice_lines_all.line_number%type,
    line_amount              ap_invoice_lines_all.amount%type,
    line_type_lookup_code    ap_invoice_lines_all.line_type_lookup_code%type,
    dist_code_combination_id ap_invoice_lines_interface.dist_code_combination_id%type,
    po_header_id             po_headers_all.po_header_id%type,
    po_line_location_id      rcv_transactions.po_line_location_id%type,
    transaction_id           rcv_transactions.transaction_id%type,
    vendor_id                po_vendors.vendor_id%type,
    vendor_site_id           po_vendor_sites_all.vendor_site_id%type,
    aplica_retencion         ts_ap_invoices_all.aplica_retencion%type,
    igv_no_dom               ts_ap_invoices_all.igv_no_dom%type,
    clase_servicio_adq       ts_ap_invoices_all.clase_servicio_adq%type,
    description              varchar2(100),
    org_id                   number);
  function fu_insert_jc_tmp(jc_cma_tmp tp_jc_inv_tmp) return varchar2;
  function fu_insert_jc_main(v_nro_carga number) return varchar2;
  procedure pr_validar(jc_tmp tp_jc_inv_tmp, p_tipo number);
  function fu_call_request(v_nro_carga number, fecha_contable varchar2)
    return number;
  procedure pr_main(errbuf           out varchar,
                    retcode          out number,
                    p_nro_carga      number,
                    p_fecha_contable varchar2);
  function fu_validate_invoice(id_interface number,
                               invoice_id   out number,
                               msg          out varchar2) return boolean;
  procedure pr_validate_invoices(l_invoice_id number);
end;
/
create or replace package body jc_invoice_arrendamiento_pkg as
  /*========================================================================================+
  |                      Copyright (c) 2025 Jogzar Consulting S.A.C                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION : Paquete para registro masivo Facturas-Arrendamiento                       |
  |                                                                                         |
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 24/11/2023    Jose Zavala         Creacion                                              |
  | 24/02/2024    Jose Zavala         Mejora Arrendamientos                                 |
  |========================================================================================*/
  p_id_aplicacion number := 2;
  function fu_insert_jc_tmp(jc_cma_tmp tp_jc_inv_tmp) return varchar2 is
    v_id                    jc_arrendamiento_tmp.id%type;
    v_nro_carga             jc_arrendamiento_tmp.nro_carga%type;
    v_tipo                  jc_arrendamiento_tmp.tipo%type;
    v_ag                    jc_arrendamiento_tmp.ag%type;
    v_proveedor             jc_arrendamiento_tmp.proveedor%type;
    v_periodo               jc_arrendamiento_tmp.periodo%type;
    v_invoice_amount        jc_arrendamiento_tmp.invoice_amount%type;
    v_invoice_tax_amount    jc_arrendamiento_tmp.invoice_tax_amount%type;
    v_oc                    jc_arrendamiento_tmp.oc%type;
    v_invoice_currency_code jc_arrendamiento_tmp.invoice_currency_code%type;
    v_acta                  jc_arrendamiento_tmp.acta%type;
    v_tipo_documento        jc_arrendamiento_tmp.tipo_documento%type;
    v_invoice_date          jc_arrendamiento_tmp.invoice_date%type;
    v_invoice_num           jc_arrendamiento_tmp.invoice_num%type;
    v_oc_amount             jc_arrendamiento_tmp.oc_amount%type;
    v_oc_tax_amount         jc_arrendamiento_tmp.oc_tax_amount%type;
    v_cuenta_contable       jc_arrendamiento_tmp.cuenta_contable%type;
    v_centro_costo          jc_arrendamiento_tmp.centro_costo%type;
    v_detraccion            jc_arrendamiento_tmp.detraccion%type;
    v_tipo_servicio         jc_arrendamiento_tmp.tipo_servicio%type;
    v_codigo_impuesto       jc_arrendamiento_tmp.codigo_impuesto%type;
    v_motivo_excepcion      jc_arrendamiento_tmp.motivo_excepcion%type;
    v_observacion           jc_arrendamiento_tmp.observacion%type;
    v_enabled_flag          jc_arrendamiento_tmp.enabled_flag%type;
    v_created_by            jc_arrendamiento_tmp.created_by%type;
    v_creation_date         jc_arrendamiento_tmp.creation_date%type;
    v_last_update_by        jc_arrendamiento_tmp.last_update_by%type;
    v_last_update_date      jc_arrendamiento_tmp.last_update_date%type;
    v_tipo_servicio2        jc_arrendamiento_tmp.tipo_servicio%type;
    v_currency_code         po_headers_all.currency_code%type;
    v_existe                number;
    v_fecha                 date;
    v_monto_num             number;
  begin
    v_id                    := jc_cma_tmp.id;
    v_nro_carga             := jc_cma_tmp.nro_carga;
    v_tipo                  := jc_cma_tmp.tipo;
    v_ag                    := jc_cma_tmp.ag;
    v_proveedor             := jc_cma_tmp.proveedor;
    v_periodo               := jc_cma_tmp.periodo;
    v_invoice_amount        := jc_cma_tmp.invoice_amount;
    v_invoice_tax_amount    := jc_cma_tmp.invoice_tax_amount;
    v_oc                    := jc_cma_tmp.oc;
    v_invoice_currency_code := jc_cma_tmp.invoice_currency_code;
    v_acta                  := jc_cma_tmp.acta;
    v_tipo_documento        := jc_cma_tmp.tipo_documento;
    v_invoice_date          := jc_cma_tmp.invoice_date;
    v_invoice_num           := jc_cma_tmp.invoice_num;
    v_oc_amount             := jc_cma_tmp.oc_amount;
    v_oc_tax_amount         := jc_cma_tmp.oc_tax_amount;
    v_cuenta_contable       := jc_cma_tmp.cuenta_contable;
    v_centro_costo          := jc_cma_tmp.centro_costo;
    v_detraccion            := jc_cma_tmp.detraccion;
    v_tipo_servicio         := jc_cma_tmp.tipo_servicio;
    v_codigo_impuesto       := jc_cma_tmp.codigo_impuesto;
    v_motivo_excepcion      := jc_cma_tmp.motivo_excepcion;
    v_enabled_flag          := jc_cma_tmp.enabled_flag;
    v_created_by            := jc_cma_tmp.created_by;
    v_creation_date         := jc_cma_tmp.creation_date;
    v_last_update_by        := jc_cma_tmp.last_update_by;
    v_last_update_date      := jc_cma_tmp.last_update_date;
  
    begin
      --PROVEEDOR-----------------------------------------------------------------
      if v_proveedor is null then
        v_observacion := v_observacion ||
                         '| EL CAMPO PROVEEDOR ES OBLIGATORIO ';
      else
        begin
          select count(*)
            into v_existe
            from po_vendors
           where replace(upper(vendor_name), ' ', '') =
                 replace(upper(v_proveedor), ' ', '');
        exception
          when others then
            v_existe := 0;
        end;
        if v_existe = 0 then
          v_observacion := v_observacion || '| ESTE PROVEEDOR NO EXISTE ';
        
        end if;
      end if;
      --PERIODO----------------------------------------------------------------------
      begin
        begin
          v_fecha := to_date('1900-01-01', 'YYYY-MM-DD') +
                     (to_number(v_periodo) - 2);
        exception
          when others then
            begin
              v_fecha := to_date(v_periodo, 'DD/MM/YYYY');
            exception
              when others then
                begin
                  v_fecha := to_date(v_periodo, 'MONTH-YYYY');
                exception
                  when others then
                    begin
                      v_fecha := to_date(v_periodo, 'YYYY-MM-DD');
                    exception
                      when others then
                        v_fecha := null;
                    end;
                end;
            end;
        end;
        if v_fecha is null then
          v_observacion := v_observacion || '| PERIODO INVÁLIDO ';
        else
          v_periodo := rtrim(to_char(v_fecha, 'MONTH'), ' ') || '-' ||
                       extract(year from v_fecha);
        end if;
      end;
      --BASE IMPONIBLE---------------------------------------------------------------------------
      begin
        if not regexp_like(v_invoice_amount, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| LA BASE IMPONIBLE NO DEBE TENER LETRAS';
        else
          begin
            v_invoice_amount := replace(trim(v_invoice_amount), '.', ',');
            v_monto_num      := to_number(v_invoice_amount,
                                          '9999999990D99',
                                          'NLS_NUMERIC_CHARACTERS=,.');
          
            dbms_output.put_line('Monto convertido: ' || v_monto_num);
          exception
            when others then
              v_observacion := v_observacion ||
                               '| BASE IMPONIBLE INVÁLIDA ';
          end;
        end if;
      end;
      --IGV---------------------------------------------------------------------------
      begin
        if not regexp_like(v_invoice_tax_amount, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| EL MONTO IGV NO DEBE TENER LETRAS';
        else
          begin
            v_invoice_tax_amount := replace(trim(v_invoice_tax_amount),
                                            '.',
                                            ',');
            v_monto_num          := to_number(v_invoice_tax_amount,
                                              '9999999990D99',
                                              'NLS_NUMERIC_CHARACTERS=,.');
          
            dbms_output.put_line('Monto convertido: ' || v_monto_num);
          exception
            when others then
              v_observacion := v_observacion || '| MONTO IGV INVÁLIDO ';
          end;
        end if;
      end;
      --OC----------------------------------------------------------------
      begin
        if not regexp_like(v_oc, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| LA ORDEN DE COMPRA NO DEBE TENER LETRAS ';
        else
          begin
            select count(*)
              into v_existe
              from po_headers_all
             where segment1 = v_oc;
          exception
            when others then
              v_existe := 0;
          end;
          if v_existe = 0 then
            v_observacion := v_observacion ||
                             '| LA ORDEN DE COMPRA NO EXISTE ';
          end if;
        end if;
      end;
      --DIVISA------------------
      begin
        if v_invoice_currency_code not in ('PEN', 'USD') then
          v_observacion := v_observacion || '| LA DIVISA INCORRECTA';
        else
          if v_observacion is null then
            select currency_code
              into v_currency_code
              from po_headers_all
             where segment1 = v_oc;
            if v_currency_code != v_invoice_currency_code then
              v_observacion := v_observacion ||
                               '| LA DIVISA SELECCIONADA NO ES IGUAL A LA DIVISA DE LA OC.';
            end if;
          end if;
        end if;
      exception
        when others then
          v_observacion := v_observacion || '| LA DIVISA ERRONEA';
      end;
      --ACTA------------------------------------------------------------------------
      begin
        if not regexp_like(v_acta, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| EL ACTA NO DEBE TENER LETRAS ';
        else
          begin
            select count(*)
              into v_existe
              from po_headers_all       pha,
                   rcv_shipment_headers rsh,
                   rcv_transactions     rt
             where pha.segment1 = v_oc
               and pha.vendor_id = rsh.vendor_id
               and rsh.receipt_num = v_acta
               and rt.po_header_id = pha.po_header_id
               and rt.shipment_header_id = rsh.shipment_header_id
               and rt.transaction_type = 'RECEIVE';
          exception
            when others then
              v_existe      := 0;
              v_observacion := v_observacion || '| ERROR ACTA';
          end;
          if v_existe = 0 then
            v_observacion := v_observacion || '| EL ACTA NO EXISTE ';
          end if;
        end if;
      end;
      --TIPO DOCUMENTO----------------------------------------------------------------------------
      begin
        if regexp_like(v_tipo_documento, '^(01|03|10|91)') then
          dbms_output.put_line('Tipo de documento válido.');
        else
          dbms_output.put_line('Tipo de documento inválido.');
          v_observacion := v_observacion || '| TIPO DE DOCUMENTO INVALIDO';
        end if;
      end;
      --FECHA DOCUMENTO---------------------------------------------------------------------------
      begin
        begin
          v_fecha := to_date('1900-01-01', 'YYYY-MM-DD') +
                     (to_number(v_invoice_date) - 2);
        exception
          when others then
            begin
              v_fecha := to_date(v_invoice_date, 'DD/MM/YYYY');
            exception
              when others then
                begin
                  v_fecha := to_date(v_invoice_date, 'MONTH-YYYY');
                exception
                  when others then
                    begin
                      v_fecha := to_date(v_invoice_date, 'YYYY-MM-DD');
                    exception
                      when others then
                        v_fecha := null;
                    end;
                end;
            end;
        end;
        if v_fecha is null then
          /*V_INVOICE_DATE := TO_CHAR(v_fecha,'DD/MM/YYYY');*/
          v_observacion := v_observacion || '| FECHA DE FACTURA INVALIDA ';
        else
          v_invoice_date := to_char(v_fecha, 'DD/MM/YYYY');
        end if;
      end;
      --INVOICE_NUM---------------------------------------------------------------------------------------
      begin
        begin
          select count(*)
            into v_existe
            from apps.ap_invoices_all
           where invoice_num = v_invoice_num
             and vendor_id =
                 (select vendor_id
                    from po_vendors
                   where upper(vendor_name) = upper(v_proveedor));
        exception
          when others then
            v_existe := 0;
        end;
        if v_existe > 0 then
          v_observacion := v_observacion ||
                           '| Este Nro de FACTURA ya existe con este proveedor ';
        end if;
      end;
      --DETRACCION----------------------------------------------------------------------------------
      begin
        if v_detraccion is not null then
          begin
            select count(*)
              into v_existe
              from apps.fnd_flex_values fvs
              join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                  fvt.flex_value_id
             where 1 = 1
               and fvs.flex_value_set_id = 1014930 -- Reemplaza con tu flex_value_set_id
               and fvs.enabled_flag = 'Y'
               and fvt.language = 'ESA'
               and to_number(fvs.flex_value) = to_number(v_detraccion);
          exception
            when others then
              v_existe := 0;
          end;
          if v_existe = 0 then
            v_observacion := v_observacion ||
                             '| CODIGO DETRACCION INVALIDO ';
          end if;
        end if;
      end;
      --TIPO SERVICIO------------------------------------------------------------------------------
      begin
        if v_tipo_servicio is not null then
          begin
            select count(ts.tipo_servicio)
              into v_existe
              from xxbol.ts_ap_servicios ts
             where 1 = 1
               and to_number(ts.tipo_servicio) = to_number(v_tipo_servicio)
             order by 1;
          exception
            when others then
              v_existe := 0;
          end;
          if v_existe = 0 then
            v_observacion := v_observacion ||
                             '| CODIGO TIPO SERVICIO INVALIDO ';
          else
            select id_servicio
              into v_tipo_servicio2
              from xxbol.ts_ap_servicios ts
             where 1 = 1
               and to_number(ts.tipo_servicio) = to_number(v_tipo_servicio)
             order by 1;
          end if;
        end if;
      end;
      --CODIGO IMPUESTO-----------------------------------------------------------------------------
      begin
        if v_codigo_impuesto is not null then
          begin
            select count(*)
              into v_existe
              from zx_id_tcc_mapping_all
             where 1 = 1
               and active_flag = 'Y'
               and tax_classification_code in (v_codigo_impuesto);
          exception
            when others then
              v_existe := 0;
          end;
          if v_existe = 0 then
            v_observacion := v_observacion || '| CODIGO IMPUESTO INVALIDO ';
          end if;
          begin
            begin
              if v_codigo_impuesto like '%USD%' and
                 v_invoice_currency_code != 'USD' then
                v_observacion := v_observacion ||
                                 '| LA DIVISA DEL CODIGO IMPUESTO DEBE SER IGUAL A LA DIVISA SELECCIONADA';
              elsif v_codigo_impuesto like '%PEN%' and
                    v_invoice_currency_code != 'PEN' then
                v_observacion := v_observacion ||
                                 '| LA DIVISA DEL CODIGO IMPUESTO DEBE SER IGUAL A LA DIVISA SELECCIONADA';
              else
                null;
              end if;
            end;
          end;
        else
          select codigo_impuesto || ' ' || v_invoice_currency_code
            into v_codigo_impuesto
            from jc_arrendamiento_jv
           where documento_sunat = substr(v_tipo_documento, 1, 2);
        end if;
      end;
      --MOTIVO EXCEPCION-----------------------------------------------------------------------------
      begin
        if v_motivo_excepcion is not null then
          begin
            select count(*)
              into v_existe
              from apps.fnd_flex_values fvs
              join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                  fvt.flex_value_id
             where 1 = 1
               and fvs.flex_value_set_id = 1014895
               and fvs.enabled_flag = 'Y'
               and fvt.language = 'ESA'
               and fvs.flex_value = v_motivo_excepcion;
          exception
            when others then
              v_existe := 0;
          end;
          if v_existe = 0 then
            v_observacion := v_observacion ||
                             '| CODIGO MOTIVO EXCEPCION INVALIDO ';
          end if;
        end if;
      end;
      --CODIGO IMPUESTO CON DIVISA----------------------------------------------
    
    exception
      when others then
        v_observacion := sqlerrm;
        return sqlerrm;
    end;
    insert into jc_arrendamiento_tmp
      (id,
       nro_carga,
       tipo,
       ag,
       proveedor,
       periodo,
       invoice_amount,
       invoice_tax_amount,
       oc,
       invoice_currency_code,
       acta,
       tipo_documento,
       invoice_date,
       invoice_num,
       oc_amount,
       oc_tax_amount,
       cuenta_contable,
       centro_costo,
       detraccion,
       tipo_servicio,
       codigo_impuesto,
       motivo_excepcion,
       observacion,
       enabled_flag,
       created_by,
       creation_date,
       last_update_by,
       last_update_date)
    values
      (v_id,
       v_nro_carga,
       upper(v_tipo),
       upper(v_ag),
       upper(v_proveedor),
       v_periodo,
       v_invoice_amount,
       v_invoice_tax_amount,
       v_oc,
       v_invoice_currency_code,
       v_acta,
       v_tipo_documento,
       v_invoice_date,
       v_invoice_num,
       v_oc_amount,
       v_oc_tax_amount,
       v_cuenta_contable,
       v_centro_costo,
       v_detraccion,
       v_tipo_servicio2,
       upper(v_codigo_impuesto),
       upper(v_motivo_excepcion),
       v_observacion,
       v_enabled_flag,
       v_created_by,
       v_creation_date,
       v_last_update_by,
       v_last_update_date);
    commit;
    return 'SUCCESS';
  exception
    when others then
      return sqlerrm;
  end;
  function fu_insert_jc_main(v_nro_carga number) return varchar2 as
    v_jc_main        tp_jc_inv_main;
    v_tipo_documento varchar2(50);
  begin
    execute immediate q'[alter session set nls_numeric_characters = ',.']';
    v_jc_main.enabled_flag := 'Y';
    v_jc_main.estado       := 'C';
    for x in (select *
                from jc_arrendamiento_tmp
               where nro_carga = v_nro_carga
                 and observacion is null) loop
      begin
        select id,
               nro_carga,
               tipo,
               ag,
               proveedor,
               periodo,
               to_number(invoice_amount),
               to_number(invoice_tax_amount),
               oc,
               invoice_currency_code,
               acta,
               tipo_documento,
               invoice_date,
               invoice_num,
               oc_amount,
               oc_tax_amount,
               cuenta_contable,
               centro_costo,
               detraccion,
               tipo_servicio,
               codigo_impuesto,
               motivo_excepcion,
               observacion,
               enabled_flag,
               created_by,
               creation_date,
               last_update_by,
               last_update_date
          into v_jc_main.id,
               v_jc_main.nro_carga,
               v_jc_main.tipo,
               v_jc_main.ag,
               v_jc_main.proveedor,
               v_jc_main.periodo,
               v_jc_main.invoice_amount,
               v_jc_main.invoice_tax_amount,
               v_jc_main.oc,
               v_jc_main.invoice_currency_code,
               v_jc_main.acta,
               v_tipo_documento,
               v_jc_main.invoice_date,
               v_jc_main.invoice_num,
               v_jc_main.oc_amount,
               v_jc_main.oc_tax_amount,
               v_jc_main.cuenta_contable,
               v_jc_main.centro_costo,
               v_jc_main.detraccion,
               v_jc_main.tipo_servicio,
               v_jc_main.codigo_impuesto,
               v_jc_main.motivo_excepcion,
               v_jc_main.observacion,
               v_jc_main.enabled_flag,
               v_jc_main.created_by,
               v_jc_main.creation_date,
               v_jc_main.last_update_by,
               v_jc_main.last_update_date
          from jc_arrendamiento_tmp
         where nro_carga = v_nro_carga
           and observacion is null
           and id = x.id;
        v_jc_main.tipo_documento := substr(v_tipo_documento, 1, 2);
      exception
        when others then
          return 'ERROR 1: ' || x.id || '|' || v_nro_carga || '|' || sqlerrm;
      end;
      begin
        select sum(unit_price * quantity)
          into v_jc_main.oc_amount
          from po_lines_all
         where po_header_id =
               (select po_header_id
                  from po_headers_all
                 where segment1 = v_jc_main.oc);
      exception
        when others then
          v_jc_main.oc_amount   := null;
          v_jc_main.estado      := 'E';
          v_jc_main.observacion := 'ERROR AL OBTENER OC AMOUNT';
      end;
      begin
        select sum(tax_amt)
          into v_jc_main.oc_tax_amount
          from zx_lines
         where trx_id = (select po_header_id
                           from po_headers_all
                          where segment1 = v_jc_main.oc)
           and entity_code = 'PURCHASE_ORDER';
      exception
        when no_data_found then
          v_jc_main.oc_tax_amount := 0;
        when others then
          v_jc_main.oc_tax_amount := 0;
      end;
      begin
        select segment2
          into v_jc_main.cuenta_contable
          from gl_code_combinations
         where code_combination_id =
               (select code_combination_id
                  from po_distributions_all
                 where po_header_id =
                       (select po_header_id
                          from po_headers_all
                         where segment1 = v_jc_main.oc)
                   and rownum = 1);
      exception
        when others then
          v_jc_main.cuenta_contable := null;
          v_jc_main.estado          := 'E';
          v_jc_main.observacion     := 'ERROR AL OBTENER CUENTA CONTABLE';
      end;
      begin
        select segment4
          into v_jc_main.centro_costo
          from gl_code_combinations
         where code_combination_id =
               (select code_combination_id
                  from po_distributions_all
                 where po_header_id =
                       (select po_header_id
                          from po_headers_all
                         where segment1 = v_jc_main.oc)
                   and rownum = 1);
      exception
        when others then
          v_jc_main.cuenta_contable := null;
          v_jc_main.estado          := 'E';
          v_jc_main.observacion     := 'ERROR AL OBTENER EL CENTRO DE COSTO';
      end;
      begin
        if v_jc_main.detraccion is null then
          select tipo_operacion_detraccion
            into v_jc_main.detraccion
            from jc_arrendamiento_jv
           where documento_sunat = v_jc_main.tipo_documento;
        end if;
        if v_jc_main.tipo_servicio is null then
          select tipo_servicio
            into v_jc_main.tipo_servicio
            from jc_arrendamiento_jv
           where documento_sunat = v_jc_main.tipo_documento;
        end if;
        if v_jc_main.motivo_excepcion is null then
          select motivo_excepcion
            into v_jc_main.motivo_excepcion
            from jc_arrendamiento_jv
           where documento_sunat = v_jc_main.tipo_documento;
        end if;
      exception
        when others then
          v_jc_main.observacion := 'ERROR RELLENAR';
      end;
    
      begin
      
        if NVL(v_jc_main.oc_tax_amount, 0) = 0 then
          if v_jc_main.INVOICE_CURRENCY_CODE = 'PEN' THEN
            v_jc_main.codigo_impuesto := 'NO AFECTO PEN';
          else
            v_jc_main.codigo_impuesto := 'NO AFECTO USD';
          end if;
        else
          if v_jc_main.INVOICE_CURRENCY_CODE = 'PEN' THEN
            v_jc_main.codigo_impuesto := 'IGV GASTO PEN';
          else
            v_jc_main.codigo_impuesto := 'IGV GASTO USD';
          end if;
        end if;
      end;
    
      insert into jc_arrendamiento_main
        (id,
         nro_carga,
         id_interface,
         id_invoice,
         last_update_date,
         last_update_by,
         creation_date,
         created_by,
         estado,
         tipo,
         ag,
         proveedor,
         periodo,
         invoice_amount,
         invoice_tax_amount,
         oc,
         invoice_currency_code,
         acta,
         tipo_documento,
         invoice_date,
         invoice_num,
         oc_amount,
         oc_tax_amount,
         cuenta_contable,
         centro_costo,
         detraccion,
         tipo_servicio,
         codigo_impuesto,
         motivo_excepcion,
         fecha_contable,
         observacion,
         enabled_flag)
      values
        (v_jc_main.id,
         v_jc_main.nro_carga,
         v_jc_main.id_interface,
         v_jc_main.id_invoice,
         v_jc_main.last_update_date,
         v_jc_main.last_update_by,
         v_jc_main.creation_date,
         v_jc_main.created_by,
         v_jc_main.estado,
         v_jc_main.tipo,
         v_jc_main.ag,
         v_jc_main.proveedor,
         v_jc_main.periodo,
         v_jc_main.invoice_amount,
         v_jc_main.invoice_tax_amount,
         v_jc_main.oc,
         v_jc_main.invoice_currency_code,
         v_jc_main.acta,
         v_jc_main.tipo_documento,
         v_jc_main.invoice_date,
         v_jc_main.invoice_num,
         round(v_jc_main.oc_amount, 2),
         round(v_jc_main.oc_tax_amount, 2),
         v_jc_main.cuenta_contable,
         v_jc_main.centro_costo,
         v_jc_main.detraccion,
         v_jc_main.tipo_servicio,
         v_jc_main.codigo_impuesto,
         v_jc_main.motivo_excepcion,
         v_jc_main.fecha_contable,
         v_jc_main.observacion,
         v_jc_main.enabled_flag);
    end loop;
    return 'SUCCESS';
  exception
    when others then
      return sqlerrm;
  end;
  procedure pr_validar(jc_tmp tp_jc_inv_tmp, p_tipo number) as
    v_observacion jc_arrendamiento_main.observacion%type;
    jc_main       tp_jc_inv_main;
    v_count       number;
    v_fecha       date;
  begin
    /*insert into jc_log_tmp_jz values (JC_TMP.CUENTA_CONTABLE || '-' || V_COUNT);
    commit;*/
    begin
      jc_main.tipo             := jc_tmp.tipo;
      jc_main.ag               := jc_tmp.ag;
      jc_main.last_update_by   := jc_tmp.last_update_by;
      jc_main.last_update_date := sysdate;
      jc_main.enabled_flag     := jc_tmp.enabled_flag;
      begin
        select count(*)
          into v_count
          from jc_arrendamiento_main
         where id = jc_tmp.id;
        if v_count = 0 then
          v_observacion := v_observacion || '| EL ID NO EXISTE.';
        else
          jc_main.id := jc_tmp.id;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 1:' || sqlerrm;
      end;
      begin
        select count(*)
          into v_count
          from ap_invoices_all
         where invoice_num = jc_tmp.invoice_num
           and vendor_id =
               (select vendor_id
                  from po_vendors
                 where replace(upper(vendor_name), ' ', '') =
                       replace(upper(jc_tmp.proveedor), ' ', ''));
        if v_count = 1 then
          v_observacion := v_observacion ||
                           '| EL NRO DE FACTURA YA EXISTE.';
        else
          jc_main.invoice_num := jc_tmp.invoice_num;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 2:' || sqlerrm;
      end;
      begin
        if not regexp_like(jc_tmp.oc, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| LA ORDEN DE COMPRA NO DEBE TENER LETRAS ';
        else
          begin
            select count(*)
              into v_count
              from po_headers_all
             where segment1 = jc_tmp.oc;
          exception
            when others then
              v_count := 0;
          end;
          if v_count = 0 then
            v_observacion := v_observacion ||
                             '| LA ORDEN DE COMPRA NO EXISTE ';
          else
            jc_main.oc := jc_tmp.oc;
          end if;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 3:' || sqlerrm;
      end;
      begin
        if jc_tmp.proveedor is null then
          v_observacion := v_observacion ||
                           '| EL CAMPO PROVEEDOR ES OBLIGATORIO ';
        else
          begin
          
            select count(*)
              into v_count
              from po_vendors
             where replace(upper(vendor_name), ' ', '') =
                   replace(upper(jc_tmp.proveedor), ' ', '');
          
          exception
            when others then
              v_count := 0;
          end;
          if v_count = 0 then
            v_observacion := v_observacion || '| ESTE PROVEEDOR NO EXISTE ';
          else
            jc_main.proveedor := jc_tmp.proveedor;
          end if;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 4:' || sqlerrm;
      end;
      begin
        begin
          v_fecha := to_date('1900-01-01', 'YYYY-MM-DD') +
                     (to_number(jc_tmp.periodo) - 2);
        exception
          when others then
            begin
              v_fecha := to_date(jc_tmp.periodo, 'DD/MM/YYYY');
            exception
              when others then
                begin
                  v_fecha := to_date(jc_tmp.periodo, 'MONTH-YYYY');
                exception
                  when others then
                    begin
                      v_fecha := to_date(jc_tmp.periodo, 'YYYY-MM-DD');
                    exception
                      when others then
                        v_fecha := null;
                    end;
                end;
            end;
        end;
        if v_fecha is null then
          v_observacion := v_observacion || '| PERIODO INVÁLIDO ';
        else
          jc_main.periodo := rtrim(to_char(v_fecha, 'MONTH'), ' ') || '-' ||
                             extract(year from v_fecha);
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 5:' || sqlerrm;
      end;
      begin
        if not regexp_like(jc_tmp.invoice_amount, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| LA BASE IMPONIBLE NO DEBE TENER LETRAS';
        else
          begin
            jc_main.invoice_amount := to_number(replace(jc_tmp.invoice_amount,
                                                        ',',
                                                        ''),
                                                '9999999.99');
          exception
            when others then
              v_observacion := v_observacion ||
                               '| BASE IMPONIBLE INVÁLIDA ';
          end;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 6:' || sqlerrm;
      end;
      begin
        if not regexp_like(jc_tmp.invoice_tax_amount, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion || '| EL IGV NO DEBE TENER LETRAS';
        else
          begin
            jc_main.invoice_tax_amount := to_number(replace(jc_tmp.invoice_tax_amount,
                                                            ',',
                                                            ''),
                                                    '9999999.99');
          exception
            when others then
              v_observacion := v_observacion || '| IGV INVÁLIDO ';
          end;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 7:' || sqlerrm;
      end;
      begin
        if jc_tmp.invoice_currency_code in ('PEN', 'USD') then
          jc_main.invoice_currency_code := jc_tmp.invoice_currency_code;
        else
          v_observacion := v_observacion || '| DIVISA INCORRECTA ';
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 8:' || sqlerrm;
      end;
      begin
        if not regexp_like(jc_tmp.acta, '^[0-9.,\s-]+$') then
          v_observacion := v_observacion ||
                           '| EL ACTA NO DEBE TENER LETRAS ';
        else
          begin
            select count(*)
              into v_count
              from po_headers_all       pha,
                   rcv_shipment_headers rsh,
                   rcv_transactions     rt
             where pha.segment1 = jc_tmp.oc
               and pha.vendor_id = rsh.vendor_id
               and rsh.receipt_num = jc_tmp.acta
               and rt.po_header_id = pha.po_header_id
               and rt.shipment_header_id = rsh.shipment_header_id
               and rt.transaction_type = 'RECEIVE';
          exception
            when others then
              v_count := 0;
          end;
          if v_count = 0 then
            v_observacion := v_observacion || '| EL ACTA NO EXISTE ';
          else
            jc_main.acta := jc_tmp.acta;
          end if;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 9:' || sqlerrm;
      end;
      begin
        if regexp_like(jc_tmp.tipo_documento, '^(01|03|10|91)') then
          dbms_output.put_line('Tipo de documento válido.');
          jc_main.tipo_documento := substr(jc_tmp.tipo_documento, 1, 2);
        else
          dbms_output.put_line('Tipo de documento inválido.');
          v_observacion := v_observacion || '| TIPO DE DOCUMENTO INVALIDO';
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 10:' || sqlerrm;
      end;
      begin
        begin
          v_fecha := to_date('1900-01-01', 'YYYY-MM-DD') +
                     (to_number(jc_tmp.invoice_date) - 2);
        exception
          when others then
            begin
              v_fecha := to_date(jc_tmp.invoice_date, 'DD/MM/YYYY');
            exception
              when others then
                begin
                  v_fecha := to_date(jc_tmp.invoice_date, 'MONTH-YYYY'); -- No se pudo convertir
                exception
                  when others then
                    begin
                      v_fecha := to_date(jc_tmp.invoice_date, 'YYYY-MM-DD'); -- No se pudo convertir
                    exception
                      when others then
                        v_fecha := null;
                    end;
                end;
            end;
        end;
        if v_fecha is null then
          v_observacion := v_observacion || '| FECHA DE FACTURA INVALIDA ';
        else
          jc_main.invoice_date := to_char(v_fecha, 'DD/MM/YYYY');
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 11:' || sqlerrm;
      end;
      begin
        select count(*)
          into v_count
          from gl_code_combinations
         where segment2 = replace(jc_tmp.cuenta_contable, '-', '')
           and rownum = 1;
        if v_count = 0 then
          v_observacion := v_observacion ||
                           '| NO EXISTE ESTA CUENTA CONTABLE';
        else
          jc_main.cuenta_contable := replace(jc_tmp.cuenta_contable,
                                             '-',
                                             '');
        end if;
      exception
        when others then
          jc_main.cuenta_contable := null;
          jc_main.estado          := 'E';
          v_observacion           := v_observacion ||
                                     '| ERROR AL OBTENER CUENTA CONTABLE';
      end;
      if p_tipo = 1 then
        begin
          select count(*)
            into v_count
            from gl_code_combinations
           where segment4 = jc_tmp.centro_costo;
          if v_count = 0 then
            v_observacion := v_observacion ||
                             '| NO EXISTE ESTE CENTRO COSTO';
          else
            jc_main.centro_costo := jc_tmp.centro_costo;
          end if;
        exception
          when others then
            jc_main.cuenta_contable := null;
            jc_main.estado          := 'E';
            v_observacion           := v_observacion ||
                                       'ERROR AL OBTENER EL CENTRO DE COSTO';
        end;
        begin
          if jc_tmp.detraccion is not null then
            begin
              select count(*)
                into v_count
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014930
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and to_number(fvs.flex_value) =
                     to_number(jc_tmp.detraccion);
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO DETRACCION INVALIDO ';
            else
              select fvs.flex_value
                into jc_main.detraccion
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014930
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and to_number(fvs.flex_value) =
                     to_number(jc_tmp.detraccion);
            end if;
          end if;
        exception
          when others then
            v_observacion := v_observacion || 'ERROR 12:' || sqlerrm;
        end;
        --TIPO SERVICIO------------------------------------------------------------------------------
        begin
          if jc_tmp.tipo_servicio is not null then
            begin
              select count(ts.tipo_servicio)
                into v_count
                from xxbol.ts_ap_servicios ts
               where 1 = 1
                 and id_servicio = jc_tmp.tipo_servicio
               order by 1;
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO TIPO SERVICIO INVALIDO ';
            else
              begin
                select tipo_servicio
                  into jc_main.tipo_servicio
                  from jc_arrendamiento_jv ts
                 where 1 = 1
                   and documento_sunat = jc_main.tipo_documento;
              end;
            end if;
          end if;
        exception
          when no_data_found then
            v_observacion := v_observacion || 'ERROR 13.1:' || sqlerrm;
          when others then
            v_observacion := v_observacion || 'ERROR 13:' || sqlerrm;
        end;
        --MOTIVO EXCEPCION-----------------------------------------------------------------------------
        begin
          if jc_tmp.motivo_excepcion is not null then
            begin
              select count(*)
                into v_count
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014895
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and fvs.flex_value =
                     upper(regexp_substr(trim(jc_tmp.motivo_excepcion),
                                         '^[[:space:]]*([A-Z])',
                                         1,
                                         1,
                                         null,
                                         1));
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO MOTIVO EXCEPCION INVALIDO ';
            else
              jc_main.motivo_excepcion := jc_tmp.motivo_excepcion;
            end if;
          end if;
        exception
          when others then
            v_observacion := v_observacion || 'ERROR 15:' || sqlerrm;
        end;
      elsif p_tipo = 2 then
        begin
          select count(*)
            into v_count
            from fnd_flex_values fv, fnd_flex_value_sets fvs
           where fvs.flex_value_set_id = fv.flex_value_set_id
             and fvs.flex_value_set_name = 'TS_GL_CMA_CENTRO_COSTOS'
             and fv.flex_value =
                 (trim(substr(jc_tmp.centro_costo,
                              1,
                              decode(instr(jc_tmp.centro_costo, '-'),
                                     0,
                                     length(jc_tmp.centro_costo),
                                     instr(jc_tmp.centro_costo, '-') - 1))));
        
          if v_count = 0 then
            v_observacion := v_observacion ||
                             '| NO EXISTE ESTE CENTRO COSTO';
          else
            select (trim(substr(jc_tmp.centro_costo,
                                1,
                                decode(instr(jc_tmp.centro_costo, '-'),
                                       0,
                                       length(jc_tmp.centro_costo),
                                       instr(jc_tmp.centro_costo, '-') - 1))))
              into jc_main.centro_costo
              from dual;
          end if;
        exception
          when others then
            jc_main.cuenta_contable := null;
            jc_main.estado          := 'E';
            v_observacion           := v_observacion ||
                                       'ERROR AL OBTENER EL CENTRO DE COSTO';
        end;
        begin
          if jc_tmp.detraccion is not null then
            begin
              select count(*)
                into v_count
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014930 -- Reemplaza con tu flex_value_set_id
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and (fvs.flex_value) =
                     (trim(substr(jc_tmp.detraccion,
                                  1,
                                  decode(instr(jc_tmp.detraccion, '-'),
                                         0,
                                         length(jc_tmp.detraccion),
                                         instr(jc_tmp.detraccion, '-') - 1))));
            
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO DETRACCION INVALIDO ';
            else
              select fvs.flex_value
                into jc_main.detraccion
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014930 -- Reemplaza con tu flex_value_set_id
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and (fvs.flex_value) =
                     (trim(substr(jc_tmp.detraccion,
                                  1,
                                  decode(instr(jc_tmp.detraccion, '-'),
                                         0,
                                         length(jc_tmp.detraccion),
                                         instr(jc_tmp.detraccion, '-') - 1))));
            end if;
          end if;
        exception
          when others then
            v_observacion := v_observacion || 'ERROR 16:' || sqlerrm;
        end;
        --TIPO SERVICIO------------------------------------------------------------------------------
        begin
          if jc_tmp.tipo_servicio is not null then
            begin
              select count(ts.tipo_servicio)
                into v_count
                from xxbol.ts_ap_servicios ts
               where 1 = 1
                 and (ts.tipo_servicio) =
                     (trim(substr(jc_tmp.tipo_servicio,
                                  1,
                                  decode(instr(jc_tmp.tipo_servicio, '-'),
                                         0,
                                         length(jc_tmp.tipo_servicio),
                                         instr(jc_tmp.tipo_servicio, '-') - 1))));
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO TIPO SERVICIO INVALIDO ';
            else
              select id_servicio
                into jc_main.tipo_servicio
                from xxbol.ts_ap_servicios ts
               where 1 = 1
                    /*and to_number(ts.tipo_servicio) =
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 to_number(trim(substr(jc_tmp.tipo_servicio, 1, instr(jc_tmp.tipo_servicio, '-') - 1)))*/
                 and (ts.tipo_servicio) =
                     (trim(substr(jc_tmp.tipo_servicio,
                                  1,
                                  decode(instr(jc_tmp.tipo_servicio, '-'),
                                         0,
                                         length(jc_tmp.tipo_servicio),
                                         instr(jc_tmp.tipo_servicio, '-') - 1))));
            
            end if;
          end if;
        exception
          when others then
            v_observacion := v_observacion || 'ERROR 17:' || sqlerrm;
        end;
        --MOTIVO EXCEPCION-----------------------------------------------------------------------------
        begin
          if jc_tmp.motivo_excepcion is not null then
            begin
              select count(*)
                into v_count
                from apps.fnd_flex_values fvs
                join apps.fnd_flex_values_tl fvt on fvs.flex_value_id =
                                                    fvt.flex_value_id
               where 1 = 1
                 and fvs.flex_value_set_id = 1014895 -- Reemplaza con tu flex_value_set_id
                 and fvs.enabled_flag = 'Y'
                 and fvt.language = 'ESA'
                 and fvs.flex_value =
                     upper(regexp_substr(trim(jc_tmp.motivo_excepcion),
                                         '^[[:space:]]*([A-Z])',
                                         1,
                                         1,
                                         null,
                                         1));
            exception
              when others then
                v_count := 0;
            end;
            if v_count = 0 then
              v_observacion := v_observacion ||
                               '| CODIGO MOTIVO EXCEPCION INVALIDO ';
            else
              jc_main.motivo_excepcion := upper(regexp_substr(trim(jc_tmp.motivo_excepcion),
                                                              '^[[:space:]]*([A-Z])',
                                                              1,
                                                              1,
                                                              null,
                                                              1));
            end if;
          end if;
        exception
          when others then
            v_observacion := v_observacion || 'ERROR 18:' || sqlerrm;
        end;
      end if;
    
      --CODIGO IMPUESTO-----------------------------------------------------------------------------
      begin
        if jc_tmp.codigo_impuesto is not null then
          begin
            select count(*)
              into v_count
              from zx_id_tcc_mapping_all
             where 1 = 1
               and active_flag = 'Y'
               and tax_classification_code = upper(jc_tmp.codigo_impuesto);
          exception
            when others then
              v_count := 0;
          end;
          if v_count = 0 then
            v_observacion := v_observacion || '| CODIGO IMPUESTO INVALIDO ';
          else
            jc_main.codigo_impuesto := jc_tmp.codigo_impuesto;
          end if;
        end if;
      exception
        when others then
          v_observacion := v_observacion || 'ERROR 19:' || sqlerrm;
      end;
    
      jc_main.observacion := v_observacion;
    exception
      when others then
        jc_main.observacion := 'ERROR AL VALIDAR';
        jc_main.estado      := 'E';
    end;
    if v_observacion is null then
      begin
        update jc_arrendamiento_main
           set tipo        = jc_main.tipo,
               ag          = jc_main.ag,
               proveedor   = jc_main.proveedor,
               invoice_num = jc_main.invoice_num,
               --PERIODO               = JC_MAIN.PERIODO,
               invoice_amount        = jc_main.invoice_amount,
               invoice_tax_amount    = jc_main.invoice_tax_amount,
               invoice_currency_code = jc_main.invoice_currency_code,
               acta                  = jc_main.acta,
               tipo_documento        = jc_main.tipo_documento,
               invoice_date          = jc_main.invoice_date,
               --OC_AMOUNT             = JC_MAIN.OC_AMOUNT,
               --OC_TAX_AMOUNT         = JC_MAIN.OC_TAX_AMOUNT,
               cuenta_contable  = jc_main.cuenta_contable,
               centro_costo     = jc_main.centro_costo,
               detraccion       = jc_main.detraccion,
               tipo_servicio    = jc_main.tipo_servicio,
               codigo_impuesto  = jc_main.codigo_impuesto,
               motivo_excepcion = jc_main.motivo_excepcion,
               last_update_date = jc_main.last_update_date,
               last_update_by   = jc_main.last_update_by,
               enabled_flag     = jc_main.enabled_flag,
               observacion      = jc_main.observacion,
               estado           = 'V'
         where id = jc_main.id;
        commit;
      exception
        when others then
          v_observacion := sqlerrm;
          update jc_arrendamiento_main
             set observacion = v_observacion, estado = 'E'
           where id = jc_main.id;
      end;
    else
      update jc_arrendamiento_main
         set observacion = v_observacion, estado = 'E'
       where id = jc_main.id;
    end if;
  end;
  function fu_call_request(v_nro_carga number, fecha_contable varchar2)
    return number as
    pragma autonomous_transaction;
    v_id                 jc_arrendamiento_main.id%type;
    vn_request_id        number;
    vn_application_id    number;
    vn_responsibility_id number;
  begin
    begin
      select created_by
        into v_id
        from jc_arrendamiento_main
       where nro_carga = v_nro_carga
         and rownum = 1;
    exception
      when others then
        v_id := 0;
    end;
    begin
      select valor
        into vn_responsibility_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'RESPONSIBILITY_ID';
    exception
      when others then
        return - 1;
    end;
    begin
      select valor
        into vn_application_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'APPLICATION_ID';
    exception
      when others then
        return - 1;
    end;
  
    update jc_arrendamiento_main
       set estado = 'T', observacion = ''
     where nro_carga = v_nro_carga
       and estado in ('V');
  
    fnd_global.apps_initialize(user_id      => v_id,
                               resp_id      => vn_responsibility_id,
                               resp_appl_id => vn_application_id);
  
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    vn_request_id := fnd_request.submit_request(application => 'JC',
                                                program     => 'JC_AP_CREATE_INVOICE_APEX',
                                                description => 'JC - Registro Facturas de Arrendamiento - APEX',
                                                start_time  => sysdate,
                                                sub_request => false,
                                                argument1   => v_nro_carga,
                                                argument2   => fecha_contable);
    commit;
    return vn_request_id;
  exception
    when others then
      rollback;
      return 0;
  end;
  procedure pr_main(errbuf           out varchar,
                    retcode          out number,
                    p_nro_carga      number,
                    p_fecha_contable varchar2) as
    l_motivo_excepcion   ts_ap_invoices_all.motivo_excepcion%type;
    l_aplica_retencion   ts_ap_invoices_all.aplica_retencion%type;
    l_id_servicio        ts_ap_invoices_all.id_servicio%type;
    l_det_tipo_operacion ts_ap_invoices_all.det_tipo_operacion%type;
    l_igv_no_dom         ts_ap_invoices_all.igv_no_dom%type;
    l_clase_servicio_adq ts_ap_invoices_all.clase_servicio_adq%type;
    jc_main              tp_jc_inv_main;
    lc_phase             varchar2(100);
    lc_status            varchar2(100);
    lc_dev_phase         varchar2(100);
    lc_dev_status        varchar2(100);
    lc_message           varchar2(100);
    lb_complete          boolean;
    v_validar            boolean;
    v_id                 number;
    vn_application_id    number;
    vn_responsibility_id number;
    v_request_id         number;
    v_exchange_rate_type number;
    v_count              number;
    v_line_price         number;
    v_currency_rate      number;
    v_tax_base           number;
    remitente            varchar2(100) := 'ebsusuarios@cajaarequipa.pe';
    asunto               varchar2(200) := 'Correcto - Tipo de Cambio';
    destinatarios        varchar2(4000);
    cc                   varchar2(4000) := '';
    vv_html              clob;
    valida               varchar2(100);
  begin
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    jc_main.fecha_contable := to_date(p_fecha_contable, 'DD/MM/YYYY');
    jc_main.group_id       := jc_arrendamiento_group_id.nextval;
    for x in (select *
                from jc_arrendamiento_main
               where nro_carga = p_nro_carga
                 and estado = 'T'
                 and enabled_flag = 'Y') loop
      apps.jc_main.pr_print('--' || x.id ||
                            '--------------------------------------------------------');
      jc_main.id_interface             := apps.ap_invoices_interface_s.nextval;
      jc_main.org_id                   := 81;
      jc_main.source                   := 'JC_CARGA_PROV';
      jc_main.payment_method_code      := 'EFT';
      jc_main.invoice_type_lookup_code := 'STANDARD';
      jc_main.terms_name               := 'CONT';
      jc_main.attribute1               := 3;
      jc_main.terms_date               := sysdate;
      jc_main.creation_date            := sysdate;
      jc_main.created_by               := x.created_by;
      jc_main.last_update_date         := sysdate;
      jc_main.last_update_by           := x.last_update_by;
      jc_main.oc                       := x.oc;
      jc_main.acta                     := x.acta;
      jc_main.invoice_amount           := x.invoice_amount;
      jc_main.invoice_tax_amount       := nvl(x.invoice_tax_amount, 0);
      jc_main.total_amount             := x.invoice_amount +
                                          nvl(x.invoice_tax_amount, 0);
      jc_main.tipo                     := x.tipo;
      jc_main.ag                       := x.ag;
      jc_main.invoice_currency_code    := x.invoice_currency_code;
      jc_main.invoice_num              := x.invoice_num;
      jc_main.invoice_date             := x.invoice_date;
      jc_main.periodo                  := x.periodo;
      jc_main.codigo_impuesto          := x.codigo_impuesto;
      jc_main.description              := x.oc || ' | ' || 'ALQUILER ' ||
                                          x.tipo || ' | AG. ' || x.ag ||
                                          ' | ' || upper(x.periodo);
      begin
        select po_header_id, vendor_id, vendor_site_id
          into jc_main.po_header_id,
               jc_main.vendor_id,
               jc_main.vendor_site_id
          from po_headers_all
         where segment1 = jc_main.oc;
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| NO SE ENCONTRO EL PO_HEADER_ID, VENDOR_ID Y VENDOR_SITE_ID';
          apps.jc_main.pr_print('NO SE ENCONTRO EL PO_HEADER_ID, VENDOR_ID Y VENDOR_SITE_ID');
      end;
      begin
        select count(*)
          into v_count
          from jc_arrendamiento_supplier
         where vendor_id = jc_main.vendor_id;
        if v_count != 0 then
          jc_main.payment_method_code := 'CHECK';
          apps.jc_main.pr_print('CHECK');
        end if;
        apps.jc_main.pr_print('TERMINO IF CHECK');
      end;
      begin
        select rt.po_line_location_id, rt.transaction_id
          into jc_main.po_line_location_id, jc_main.transaction_id
          from po_headers_all       pha,
               rcv_shipment_headers rsh,
               rcv_transactions     rt
         where pha.vendor_id = rsh.vendor_id
           and rt.po_header_id = pha.po_header_id
           and rt.shipment_header_id = rsh.shipment_header_id
           and pha.po_header_id = jc_main.po_header_id
           and rsh.receipt_num = jc_main.acta
           and rt.transaction_type = 'RECEIVE'
           and rownum = 1;
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| NO SE ENCONTRO EL PO_LINE_LOCATION_ID Y TRANSACTION_ID';
          apps.jc_main.pr_print('NO SE ENCONTRO EL PO_LINE_LOCATION_ID Y TRANSACTION_ID');
      end;
      begin
        if jc_main.invoice_currency_code = 'USD' then
          v_exchange_rate_type := 1004; --VENTA SBS 1004 -- VENTA SUNAT 1005
        end if;
      end;
      begin
        insert into apps.ap_invoices_interface
          (invoice_id,
           invoice_num,
           po_number,
           vendor_id,
           vendor_site_id,
           invoice_amount,
           invoice_currency_code,
           invoice_date,
           description,
           source,
           org_id,
           payment_method_code,
           invoice_type_lookup_code,
           terms_name,
           terms_date,
           group_id,
           gl_date,
           exchange_rate_type,
           exchange_date,
           attribute1,
           creation_date,
           last_update_date)
        values
          (jc_main.id_interface,
           jc_main.invoice_num,
           jc_main.oc,
           jc_main.vendor_id,
           jc_main.vendor_site_id,
           jc_main.total_amount,
           jc_main.invoice_currency_code,
           jc_main.invoice_date,
           jc_main.description,
           jc_main.source,
           jc_main.org_id,
           jc_main.payment_method_code,
           jc_main.invoice_type_lookup_code,
           jc_main.terms_name,
           jc_main.terms_date,
           jc_main.group_id,
           jc_main.fecha_contable,
           v_exchange_rate_type,
           jc_main.fecha_contable,
           jc_main.attribute1,
           jc_main.creation_date,
           jc_main.last_update_date);
        apps.jc_main.pr_print('INSERT INTERFACE CORRECTO');
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| ERROR INSERT INTERFACE: ' || sqlerrm;
          apps.jc_main.pr_print('| ERROR INSERT INTERFACE: ' || sqlerrm);
          retcode := 2;
          errbuf  := errbuf || 'ERROR INSERT INTERFACE: ' || sqlerrm;
      end;
      begin
        jc_main.line_number := 0;
        for k in (select rt.po_line_location_id,
                         rt.transaction_id,
                         rt.quantity
                    from po_headers_all       pha,
                         rcv_shipment_headers rsh,
                         rcv_transactions     rt
                   where pha.vendor_id = rsh.vendor_id
                     and rt.po_header_id = pha.po_header_id
                     and rt.shipment_header_id = rsh.shipment_header_id
                     and pha.po_header_id = jc_main.po_header_id
                     and rsh.receipt_num = jc_main.acta
                     and rt.transaction_type = 'RECEIVE') loop
        
          jc_main.line_number := jc_main.line_number + 1;
          v_line_price        := round(jc_main.invoice_amount * k.quantity,
                                       2);
          apps.jc_main.pr_print(jc_main.invoice_amount || ' | ' ||
                                k.quantity || ' | ' || v_line_price);
          jc_main.line_type_lookup_code := 'ITEM';
          --JC_MAIN.DIST_CODE_COMBINATION_ID := '01.' || x.CUENTA_CONTABLE || '.' || (CASE x.INVOICE_CURRENCY_CODE WHEN 'PEN' THEN '1' WHEN 'USD' THEN '2' ELSE '0' END) || x.CENTRO_COSTO || '.0.0.0.0.0';
          begin
            /*if replace(x.cuenta_contable, '-', '') like '19%' then
              select code_combination_id
                into jc_main.dist_code_combination_id
                from gl_code_combinations
               where segment1 = '01'
                 and segment2 = replace(x.cuenta_contable, '-', '')
                 and segment3 = (case x.invoice_currency_code when 'PEN' then '1' when
                      'USD' then '2' else '0' end)
                 and segment4 = '0'
                 and segment5 = '0'
                 and segment6 = '0'
                 and segment7 = '0'
                 and rownum = 1;
            else*/
            select code_combination_id
              into jc_main.dist_code_combination_id
              from gl_code_combinations
             where segment1 = '01'
               and segment2 = replace(x.cuenta_contable, '-', '')
               and segment3 = (case x.invoice_currency_code when 'PEN' then '1' when
                    'USD' then '2' else '0' end)
               and segment4 = x.centro_costo
               and segment5 = '0'
               and segment6 = '0'
               and segment7 = '0'
               and rownum = 1;
            --end if;--por confirmar
          
          exception
            when no_data_found then
              jc_main.observacion := jc_main.observacion ||
                                     '| NO SE ENCONTRÓ COMBINACION CONTABLE: ' ||
                                     x.cuenta_contable || '.' || (case x.invoice_currency_code when 'PEN' then '1' when 'USD' then '2' else '0' end) || '.' || x.centro_costo;
              apps.jc_main.pr_print('| ERROR CODE_COMBINATION_ID: ' ||
                                    sqlerrm);
            when others then
              jc_main.observacion := jc_main.observacion ||
                                     '| ERROR CODE_COMBINATION_ID: ' ||
                                     sqlerrm;
              apps.jc_main.pr_print('| ERROR CODE_COMBINATION_ID: ' ||
                                    sqlerrm);
              retcode := 2;
              errbuf  := errbuf || 'ERROR CODE_COMBINATION_ID: ' || sqlerrm;
          end;
          if jc_main.observacion is null then
            begin
              insert into apps.ap_invoice_lines_interface
                (invoice_id,
                 line_number,
                 line_type_lookup_code,
                 amount,
                 po_line_location_id,
                 rcv_transaction_id,
                 dist_code_combination_id,
                 tax_classification_code,
                 last_update_date)
              values
                (jc_main.id_interface,
                 jc_main.line_number,
                 jc_main.line_type_lookup_code,
                 v_line_price, --jc_main.invoice_amount,
                 k.po_line_location_id,
                 k.transaction_id,
                 jc_main.dist_code_combination_id,
                 jc_main.codigo_impuesto,
                 jc_main.last_update_date);
              apps.jc_main.pr_print('INSERT INTERFACE LINES CORRECTO');
            exception
              when others then
                jc_main.observacion := jc_main.observacion ||
                                       '| ERROR INSERT LINES INTERFACE: ' ||
                                       sqlerrm;
                apps.jc_main.pr_print('| ERROR INSERT LINES INTERFACE: ' ||
                                      sqlerrm);
                retcode := 2;
                errbuf  := errbuf || 'ERROR INSERT LINES INTERFACE: ' ||
                           sqlerrm;
            end;
          end if;
        end loop;
        /*BEGIN
          IF JC_MAIN.OBSERVACION IS NULL THEN
            IF JC_MAIN.INVOICE_TAX_AMOUNT != 0 THEN
              JC_MAIN.LINE_NUMBER           := JC_MAIN.LINE_NUMBER + 1;
              JC_MAIN.LINE_TYPE_LOOKUP_CODE := 'TAX';
            
              BEGIN
                INSERT INTO APPS.AP_INVOICE_LINES_INTERFACE
                  (invoice_id,
                   line_number,
                   line_type_lookup_code,
                   amount,
                   tax_classification_code,
                   last_update_date)
                VALUES
                  (JC_MAIN.ID_INTERFACE,
                   JC_MAIN.LINE_NUMBER,
                   JC_MAIN.LINE_TYPE_LOOKUP_CODE,
                   JC_MAIN.INVOICE_TAX_AMOUNT,
                   JC_MAIN.CODIGO_IMPUESTO,
                   JC_MAIN.LAST_UPDATE_DATE);
                APPS.JC_MAIN.PR_PRINT('INSERT INTERFACE LINES TAX CORRECTO');
              EXCEPTION
                WHEN OTHERS THEN
                  JC_MAIN.OBSERVACION := JC_MAIN.OBSERVACION ||
                                         '| ERROR INSERT LINES TAX INTERFACE: ' ||
                                         SQLERRM;
                  APPS.JC_MAIN.PR_PRINT('| ERROR INSERT LINES TAX INTERFACE: ' ||
                                        SQLERRM);
                  retcode := 2;
                  errbuf  := errbuf || 'ERROR INSERT LINES TAX INTERFACE: ' ||
                             SQLERRM;
              END;
            END IF;
          END IF;
        END;*/
      end;
      if jc_main.observacion is null then
        update jc_arrendamiento_main
           set fecha_contable = jc_main.fecha_contable,
               id_interface   = jc_main.id_interface
         where id = x.id;
        apps.jc_main.pr_print('PRIMER UPDATE CORRECTO');
      else
        update jc_arrendamiento_main
           set fecha_contable = jc_main.fecha_contable,
               id_interface   = jc_main.id_interface,
               id_invoice     = jc_main.id_invoice,
               estado         = 'E',
               observacion    = jc_main.observacion
         where id = x.id;
        apps.jc_main.pr_print('PRIMER UPDATE INCORRECTO');
      end if;
    end loop;
    commit;
    begin
      begin
        select created_by
          into v_id
          from jc_arrendamiento_main
         where nro_carga = nro_carga
           and rownum = 1;
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| ERROR AL CONSEGUIR ID: ' || sqlerrm;
          apps.jc_main.pr_print('| ERROR AL CONSEGUIR ID: ' || sqlerrm);
      end;
      begin
        select valor
          into vn_responsibility_id
          from jc_global_params
         where proyecto_id = p_id_aplicacion
           and variable = 'RESPONSIBILITY_ID';
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| ERROR AL CONSEGUIR RESPONSIBILITY_ID: ' ||
                                 sqlerrm;
          apps.jc_main.pr_print('| ERROR AL CONSEGUIR RESPONSIBILITY_ID: ' ||
                                sqlerrm);
      end;
      begin
        select valor
          into vn_application_id
          from jc_global_params
         where proyecto_id = p_id_aplicacion
           and variable = 'APPLICATION_ID';
      exception
        when others then
          jc_main.observacion := jc_main.observacion ||
                                 '| ERROR AL CONSEGUIR APPLICATION_ID: ' ||
                                 sqlerrm;
          apps.jc_main.pr_print('| ERROR AL CONSEGUIR APPLICATION_ID: ' ||
                                sqlerrm);
      end;
      mo_global.init('SQLAP');
      fnd_global.apps_initialize(user_id      => v_id,
                                 resp_id      => vn_responsibility_id,
                                 resp_appl_id => vn_application_id);
    
      v_request_id := fnd_request.submit_request(application => 'SQLAP',
                                                 program     => 'APXIIMPT',
                                                 description => '',
                                                 start_time  => null,
                                                 sub_request => false,
                                                 argument1   => 81,
                                                 argument2   => jc_main.source,
                                                 argument3   => jc_main.group_id,
                                                 argument4   => null,
                                                 argument5   => null,
                                                 argument6   => null,
                                                 argument7   => null,
                                                 argument8   => 'N',
                                                 argument9   => 'Y');
      commit;
      apps.jc_main.pr_print('------------------------------------------------------------');
      apps.jc_main.pr_print('LANZANDO CONCURRENTE AP');
      apps.jc_main.pr_print(v_request_id);
      if v_request_id > 0 then
        lb_complete := fnd_concurrent.wait_for_request(request_id => v_request_id,
                                                       interval   => 2,
                                                       max_wait   => 1800,
                                                       phase      => lc_phase,
                                                       status     => lc_status,
                                                       dev_phase  => lc_dev_phase,
                                                       dev_status => lc_dev_status,
                                                       message    => lc_message);
        if lb_complete then
          commit;
        end if;
        if upper(lc_dev_phase) in ('COMPLETE', 'COMPLETED') then
          for x in (select *
                      from jc_arrendamiento_main
                     where nro_carga = p_nro_carga
                       and estado = 'T'
                       and enabled_flag = 'Y') loop
            v_validar := fu_validate_invoice(x.id_interface,
                                             jc_main.id_invoice,
                                             jc_main.observacion);
            if not v_validar then
              apps.jc_main.pr_print('VALIDAR FALSE: ' || x.id_interface ||
                                    ' | ' || jc_main.observacion);
              update jc_arrendamiento_main
                 set estado = 'E', observacion = jc_main.observacion
               where id = x.id;
              commit;
            else
              apps.jc_main.pr_print('VALIDAR TRUE');
              begin
                select motivo_excepcion,
                       forzar_retencion,
                       tipo_servicio,
                       igv_no_domiciliado,
                       tipo_operacion_detraccion,
                       clas_bienes_servicio_adq
                  into l_motivo_excepcion,
                       l_aplica_retencion,
                       l_id_servicio,
                       l_igv_no_dom,
                       l_det_tipo_operacion,
                       l_clase_servicio_adq
                  from apps.jc_arrendamiento_jv
                 where documento_sunat = x.tipo_documento;
                jc_main.motivo_excepcion   := nvl(x.motivo_excepcion,
                                                  l_motivo_excepcion);
                jc_main.aplica_retencion   := l_aplica_retencion;
                jc_main.tipo_servicio      := nvl(x.tipo_servicio,
                                                  l_id_servicio);
                jc_main.detraccion         := nvl(x.detraccion,
                                                  l_det_tipo_operacion);
                jc_main.igv_no_dom         := l_igv_no_dom;
                jc_main.clase_servicio_adq := l_clase_servicio_adq;
                insert into ts_ap_invoices_all
                  (invoice_id,
                   doc_sunat,
                   motivo_excepcion,
                   aplica_retencion,
                   id_servicio,
                   det_tipo_operacion,
                   igv_no_dom,
                   clase_servicio_adq,
                   org_id,
                   created_by,
                   creation_date,
                   last_updated_by,
                   last_update_date)
                values
                  (jc_main.id_invoice,
                   x.tipo_documento,
                   jc_main.motivo_excepcion,
                   jc_main.aplica_retencion,
                   jc_main.tipo_servicio,
                   jc_main.detraccion,
                   jc_main.igv_no_dom,
                   jc_main.clase_servicio_adq,
                   jc_main.org_id,
                   jc_main.created_by,
                   jc_main.creation_date,
                   jc_main.last_update_by,
                   jc_main.last_update_date);
                jc_main.estado      := 'P';
                jc_main.observacion := '';
                apps.jc_main.pr_print('INSET TABLA TS CORRECTO');
              exception
                when others then
                  apps.jc_main.pr_print('INSER TABLA TS INCORRECTO');
                  jc_main.estado      := 'E';
                  jc_main.observacion := 'ERROR INSERT TABLE ZOOM INVOICES';
                  apps.jc_main.pr_print('ERROR INSERT TABLE ZOOM INVOICES: ' ||
                                        sqlerrm);
              end;
              update jc_arrendamiento_main
                 set id_invoice  = jc_main.id_invoice,
                     estado      = jc_main.estado,
                     observacion = jc_main.observacion
               where id = x.id;
              apps.jc_main.pr_print('UPDATE FINAL CORRECTO');
            end if;
          end loop;
        end if;
      end if;
    end;
    begin
      for x in (select *
                  from apps.jc_arrendamiento_main
                 where nro_carga = p_nro_carga
                   and estado = 'P'
                   and id_invoice is not null) loop
        pr_validate_invoices(x.id_invoice);
        begin
          select code_combination_id
            into jc_main.dist_code_combination_id
            from gl_code_combinations
           where segment1 = '01'
             and segment2 = x.cuenta_contable
             and segment3 = (case x.invoice_currency_code when 'PEN' then '1' when
                  'USD' then '2' else '0' end)
             and segment4 = x.centro_costo
             and segment5 = '0'
             and segment6 = '0'
             and segment7 = '0'
             and rownum = 1;
          update ap_invoice_distributions_all
             set dist_code_combination_id = jc_main.dist_code_combination_id
           where match_status_flag = 'T'
             and invoice_id = x.id_invoice;
          commit;
        exception
          when others then
            apps.jc_main.pr_print('ERROR DESPUES DIST CODE');
            jc_main.estado      := 'E';
            jc_main.observacion := 'ERROR DESPUES DIST CODE';
            apps.jc_main.pr_print('ERROR DESPUES DIST CODE: ' || sqlerrm);
        end;
        begin
          if nvl(x.invoice_tax_amount, 0) > 0 then
            select currency_conversion_rate
              into v_currency_rate
              from ZX_LINES_SUMMARY
             where trx_id = x.id_invoice;
            v_tax_base := round(x.invoice_tax_amount * v_currency_rate, 2);
            update ZX_LINES_SUMMARY
               set tax_amt            = x.invoice_tax_amount,
                   tax_amt_funcl_curr = v_tax_base
             where trx_id = x.id_invoice;
            update ap_invoice_lines_all
               set amount                        = x.invoice_tax_amount,
                   base_amount                   = v_tax_base,
                   total_nrec_tax_amount         = x.invoice_tax_amount,
                   total_nrec_tax_amt_funcl_curr = v_tax_base
             where line_type_lookup_code = 'TAX'
               and invoice_id = x.id_invoice;
            apps.jc_main.pr_print('UPDATE TAX');
            commit;
          end if;
        end;
        commit;
        pr_validate_invoices(x.id_invoice);
      end loop;
      begin
        vv_html := '<h3>Registro Masivo - Facturas Arrendamiento</h3>';
        vv_html := vv_html || '<p>Detalle de Carga:</p>' || chr(13);
        vv_html := vv_html || '<table style="height: 152px;" width="620">' ||
                   chr(13);
        vv_html := vv_html || '<tbody>' || chr(13);
        vv_html := vv_html || '<tr>' || chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Nro Factura</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Base Imponible</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Orden de Compra</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Acta</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Fecha</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html ||
                   '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>Estado</strong></span></td>' ||
                   chr(13);
        vv_html := vv_html || '</tr>' || chr(13);
      
        for r1 in (select invoice_num,
                          invoice_amount,
                          oc,
                          acta,
                          invoice_date,
                          case
                            when estado = 'P' then
                             'PROCESADO'
                          end as estado
                     from jc_arrendamiento_main
                    where nro_carga = p_nro_carga
                      and estado = 'P') loop
          vv_html := vv_html || '<tr>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' ||
                     r1.invoice_num || '</td>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' ||
                     r1.invoice_amount || '</td>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' || r1.oc ||
                     '</td>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' || r1.acta ||
                     '</td>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' ||
                     r1.invoice_date || '</td>' || chr(13);
          vv_html := vv_html || '<td style="width: 302px;">' || r1.estado ||
                     '</td>' || chr(13);
          vv_html := vv_html || '</tr>' || chr(13);
        end loop;
        select email_address
          into destinatarios
          from apps.fnd_user
         where user_id = jc_main.created_by;
        valida := apps.jc_main.fu_envia_correo(remitente,
                                               destinatarios,
                                               cc,
                                               asunto,
                                               vv_html);
        if valida != 'Success' then
          apps.jc_main.pr_print('Error al enviar el correo 3: ' || valida ||
                                ' | ' || sqlerrm);
        end if;
      end;
    end;
  end;
  function fu_validate_invoice(id_interface number,
                               invoice_id   out number,
                               msg          out varchar2) return boolean as
    v_status      varchar2(20);
    v_invoice_num varchar2(20);
    v_vendor_id   number;
  begin
    select status, invoice_num, vendor_id
      into v_status, v_invoice_num, v_vendor_id
      from apps.ap_invoices_interface
     where invoice_id = id_interface;
    if v_status = 'PROCESSED' then
      select invoice_id
        into invoice_id
        from apps.ap_invoices_all
       where invoice_num = v_invoice_num
         and vendor_id = v_vendor_id;
      return true;
    else
      begin
        for k in (select *
                    from ap_invoice_lines_interface
                   where invoice_id = id_interface) loop
          for x in (select *
                      from ap_interface_rejections
                     where parent_id in (id_interface, k.invoice_line_id)
                       and parent_table in ('AP_INVOICES_INTERFACE',
                            'AP_INVOICE_LINES_INTERFACE')) loop
            msg := msg || ' | ' || x.reject_lookup_code;
          end loop;
        end loop;
      end;
      return false;
    end if;
  end;
  procedure pr_validate_invoices(l_invoice_id number) is
    nrequestid    number;
    v_org_id      number := 81; -- ID de la unidad operativa
    v_option      varchar2(50) := 'All'; -- Opción de coincidencia ("All" para todos los tipos de coincidencia)
    lc_phase      varchar2(100);
    lc_status     varchar2(100);
    lc_dev_phase  varchar2(100);
    lc_dev_status varchar2(100);
    lc_message    varchar2(100);
    lb_complete   boolean;
  begin
    mo_global.set_policy_context('S', 81);
    fnd_global.apps_initialize(0, 50697, 200);
    --execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    nrequestid := fnd_request.submit_request(application => 'SQLAP', -- Aplicación: AP (Cuentas por pagar)
                                             program     => 'APPRVL', -- Programa de validación de facturas
                                             description => 'Invoice Validation', -- Descripción opcional
                                             start_time  => sysdate, -- Fecha de inicio para la ejecución del proceso
                                             sub_request => false, -- Indica si es una solicitud subordinada
                                             argument1   => v_org_id, -- Unidad operativa (p_org_id)
                                             argument2   => v_option, -- Opción de coincidencia (p_option)
                                             argument3   => '', -- Nombre del lote (p_inv_batch_id) NULL para factura única
                                             argument4   => '', -- Fecha de inicio (p_inv_start_date)
                                             argument5   => '', -- Fecha de fin (p_inv_end_date)
                                             argument6   => '', -- ID del proveedor (p_vendor_id)
                                             argument7   => 'ALQUILER INMUEBLES', -- Grupo de pago (p_pay_group)
                                             argument8   => l_invoice_id, -- ID de la factura específica (p_invoice_id)
                                             argument9   => '', -- ID de usuario (p_entered_by)
                                             argument10  => 'N',
                                             argument11  => 1000,
                                             argument12  => 1,
                                             argument13  => 'N');
  
    commit;
    if nrequestid > 0 then
      lb_complete := fnd_concurrent.wait_for_request(request_id => nrequestid,
                                                     interval   => 2,
                                                     max_wait   => 5000,
                                                     phase      => lc_phase,
                                                     status     => lc_status,
                                                     dev_phase  => lc_dev_phase,
                                                     dev_status => lc_dev_status,
                                                     message    => lc_message);
      if lb_complete then
        commit;
      end if;
      if upper(lc_dev_phase) in ('COMPLETE', 'COMPLETED') then
        fnd_file.put_line(fnd_file.log,
                          'Concurrent request completed successfully');
      end if;
    end if;
  exception
    when others then
      dbms_output.put_line('Error al enviar la solicitud: ' || sqlerrm);
  end;
end;
/
