create or replace package jc_ba_pkg as
  /*========================================================================================+
  |                      Copyright (c) 2023 Jogzar Consulting S.A.C                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION :                                                                           |
  |                                                                                         |
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 09-12-23      Carlos Cornejo      Creacion                                              |
  | 23-12-24      Jose Zavala         Control de Cambios 20.12.2024                         |
  |========================================================================================*/

  function fu_insert_tmp(ba_tmp apps.jc_ba_tmp%ROWTYPE) return varchar2;
  function fu_insert_main(v_nro_carga number) return varchar2;
  function fu_concurrente_oc(pn_numero_carga      in number,
                             pd_fecha_contable    in varchar2,
                             pd_fecha_tipo_cambio in varchar2,
                             pn_vendor_id         in number,
                             pv_error             out varchar2)
    return varchar2;
  procedure pr_create_oc_api(errbuf              out varchar2,
                             retcode             out varchar2,
                             p_nro_carga         number,
                             p_fecha_contable    varchar2,
                             p_fecha_tipo_cambio varchar2);
  function fu_concurrente_receipt(pn_numero_carga      in number,
                                  pd_fecha_contable    in varchar2,
                                  pd_fecha_tipo_cambio in varchar2,
                                  pv_error             out varchar2)
    return varchar2;
  procedure pr_create_receipt_api(errbuf              out varchar2,
                                  retcode             out varchar2,
                                  p_nro_carga         number,
                                  p_fecha_contable    varchar2,
                                  p_fecha_tipo_cambio varchar2);
  function fu_concurrente_invoice(pn_numero_carga   in number,
                                  pd_fecha_contable in varchar2,
                                  pd_fecha_cambio   in varchar2,
                                  pv_error          out varchar2)
    return varchar2;
  procedure pr_create_invoice(errbuf           out varchar,
                              retcode          out number,
                              p_nro_carga      number,
                              p_fecha_contable varchar2,
                              pd_fecha_cambio  varchar2);
  procedure pr_anexo_pdf(pn_po_header_id in number, pn_file_id in number);
  procedure pr_ts_formato_oc(vn_po_Header_id number, vn_email varchar2);
  PROCEDURE pr_ts_formato_recepciones(shipment_header_id number,
                                      vn_email           varchar2);
  procedure pr_concurrent_ts(errbuf out varchar2, retcode out varchar2);
  procedure pr_invoice_ap(p_cabera_id number);
  function fu_validacion(v_nro_carga number) return varchar2;
end;
/
create or replace package body jc_ba_pkg as
  /*========================================================================================+
  |                      Copyright (c) 2023 Jogzar Consulting S.A.C                         |
  |                        ORACLE Applications Comun Customizing                            |
  +=========================================================================================+
  |                                                                                         |
  | DESCRIPTION :                                                                           |
  |                                                                                         |
  | HISTORY                                                                                 |
  | WHEN          WHO                 WHAT                                                  |
  | ----------    ------------------- ------------------------------------------------------|
  | 09-12-23      Carlos Cornejo      Creacion                                              |
  | 23-12-24      Jose Zavala         Control de Cambios 20.12.2024                         |
  | 20-07-25      Jose Zavala         Cambios a la Plantilla                                |
  |========================================================================================*/
  /*
  NOTAS:
    - ESTADO: C = CARGADO ETAPA ORDEN DE COMPRA
              V = VALIDADO ETAPA ORDEN DE COMPRA
              T = PROCESANDO ETAPA ORDEN DE COMPRA
              E = ERROR ETAPA ORDEN DE COMPRA
              P = PROCESADO ETAPA ORDEN DE COMPRA
              W = PROCENSANDO ETAPA RECEPCIONES
              X = ERROR ETAPA RECEPCIONES
              Y = PROCESADO ETAPA RECEPCIONES
  */
  p_id_aplicacion number := 3;

  function fu_insert_tmp(ba_tmp apps.jc_ba_tmp%ROWTYPE) return varchar2 is
    ba_main       apps.jc_ba_cabecera%ROWTYPE;
    observaciones varchar2(4000);
    v_count       number;
  begin
    /*
    insert into jc_log_tmp_jz
    values
      (ba_tmp.DNI || '-' || ba_tmp.pasajes_aereos);
    */
    --FECHA EMISION-----------------------------------------------------------------------------
    /*if ba_tmp.FECHA_HORA_EMISION is null then
      observaciones := observaciones || '| FECHA DE EMISION OBLIGATORIA ';
    else
      ba_main.FECHA_HORA_EMISION := jc_main.fu_format_date(ba_tmp.FECHA_HORA_EMISION);
      if ba_main.FECHA_HORA_EMISION is null then
        observaciones := observaciones || '| FECHA DE EMISION INVALIDA ';
      end if;
    end if;*/
    --TICKET------------------------------------------------------------------------------------
    if ba_tmp.NRO_TICKET is null then
      observaciones := observaciones || '| TICKET ES OBLIGATORIO ';
    elsif not regexp_like(ba_tmp.NRO_TICKET, '^[0-9.,\s-]+$') then
      observaciones := observaciones || '| TICKET NO DEBE TENER LETRAS ';
    else
      if instr(ba_tmp.NRO_TICKET, '-') = 0 then
        ba_main.NRO_TICKET := substr(ba_tmp.nro_ticket, 1, 3) || '-' ||
                              substr(ba_tmp.nro_ticket, 4);
      else
        ba_main.NRO_TICKET := ba_tmp.NRO_TICKET;
      end if;
      --ba_main.NRO_TICKET := ba_tmp.NRO_TICKET;
    end if;
    --FECHA EMISION TICKET ----------------------------------------------------------------------
    if ba_tmp.FECHA_EMISION_TICKET is null then
      observaciones := observaciones ||
                       '| FECHA DE EMISION TICKET OBLIGATORIA ';
    else
      ba_main.FECHA_EMISION_TICKET := jc_main.fu_format_date(ba_tmp.FECHA_EMISION_TICKET);
      if ba_main.FECHA_EMISION_TICKET is null then
        observaciones := observaciones ||
                         '| FECHA DE EMISION TICKET INVALIDA ';
      end if;
    end if;
    /*--RESERVA------------------------------------------------------------------------------------
    ba_main.RESERVA := ba_tmp.RESERVA;
    --RUC AEREOLINEA-----------------------------------------------------------------------------
    if ba_tmp.RUC_AEREOLINEA is null then
      observaciones := observaciones || '| RUC AEREOLINEA ES OBLIGATORIO ';
    elsif length(ba_tmp.RUC_AEREOLINEA) > 11 then
      observaciones := observaciones ||
                       '| RUC AEREOLINEA DEBE TENER MAX 11 DIGITOS ';
    elsif not regexp_like(ba_tmp.RUC_AEREOLINEA, '^[0-9.,\s-]+$') then
      observaciones := observaciones ||
                       '| RUC AEREOLINEA NO DEBE TENER LETRAS ';
    else
      begin
        select count(*)
          into v_count
          from apps.po_vendors
         where segment1 = ba_tmp.RUC_AEREOLINEA;
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        ba_main.RUC_AEREOLINEA := ba_tmp.RUC_AEREOLINEA;
      else
        observaciones := observaciones || '| RUC AEREOLINEA NO EXISTE ';
      end if;
    end if;*/
    --NOMBRE AEREOLINEA--------------------------------------------------------------------------
  
    if ba_tmp.NOMBRE_AEREOLINEA is not null then
      begin
        select count(*)
          into v_count
          from apps.jc_ba_aero
         where upper(AEROLINEA) = upper(ba_tmp.NOMBRE_AEREOLINEA);
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        ba_main.NOMBRE_AEREOLINEA := ba_tmp.NOMBRE_AEREOLINEA;
      else
        observaciones := observaciones || '| NOMBRE AEREOLINEA NO EXISTE ';
      end if;
    end if;
    --RUC PROVEEDOR-----------------------------------------------------------------------------
    /*if ba_tmp.RUC_PROVEEDOR is null then
      observaciones := observaciones || '| RUC PROVEEDOR ES OBLIGATORIO ';
    elsif length(ba_tmp.RUC_PROVEEDOR) > 11 then
      observaciones := observaciones ||
                       '| RUC PROVEEDOR DEBE TENER MAX 11 DIGITOS ';
    elsif not regexp_like(ba_tmp.RUC_PROVEEDOR, '^[0-9.,\s-]+$') then
      observaciones := observaciones ||
                       '| RUC PROVEEDOR NO DEBE TENER LETRAS ';
    else
      begin
        select count(*)
          into v_count
          from apps.po_vendors
         where segment1 = ba_tmp.RUC_PROVEEDOR;
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        ba_main.RUC_PROVEEDOR := ba_tmp.RUC_PROVEEDOR;
      else
        observaciones := observaciones || '| RUC PROVEEDOR NO EXISTE ';
      end if;
    end if;*/
    --SOCIO COMERCIAL--------------------------------------------------------------------------
    if ba_tmp.SOCIO_COMERCIAL is not null then
      begin
        select count(*)
          into v_count
          from apps.po_vendors
         where upper(replace(vendor_name, ' ', '')) =
               upper(replace(ba_tmp.SOCIO_COMERCIAL, ' ', ''));
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        ba_main.SOCIO_COMERCIAL := ba_tmp.SOCIO_COMERCIAL;
      else
        observaciones := observaciones || '| SOCIO COMERCIAL NO EXISTE ';
      end if;
      begin
        select count(*)
          into v_count
          from apps.po_vendors
         where upper(replace(vendor_name, ' ', '')) =
               upper(replace(ba_tmp.SOCIO_COMERCIAL, ' ', ''))
           and segment1 = ba_tmp.RUC_PROVEEDOR;
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        ba_main.SOCIO_COMERCIAL := ba_tmp.SOCIO_COMERCIAL;
      else
        observaciones := observaciones ||
                         '| SOCIO COMERCIAL NO COINCIDE CON RUC PROVEEDOR ';
      end if;
    end if;
    --FACTURA------------------------------------------------------------------------------------
    if ba_tmp.NRO_FACTURA is null then
      observaciones := observaciones || '| NRO DE FATURA ES OBLIGATORIO ';
    else
      begin
        select count(*)
          into v_count
          from ap_invoices_all
         where invoice_num = ba_tmp.NRO_FACTURA
           and vendor_id =
               (select vendor_id
                  from apps.po_vendors
                 where segment1 = ba_tmp.RUC_PROVEEDOR);
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        observaciones := observaciones || '| NRO DE FATURA YA EXISTE ';
      else
        ba_main.NRO_FACTURA := ba_tmp.NRO_FACTURA;
      end if;
    end if;
    --FECHA EMISION FACTURA----------------------------------------------------------------------
    if ba_tmp.FECHA_EMISION_FACTURA is null then
      observaciones := observaciones ||
                       '| LA FECHA EMISION FACTURA ES OBLIGATORIO ';
    else
      ba_main.FECHA_EMISION_FACTURA := jc_main.fu_format_date(ba_tmp.FECHA_EMISION_FACTURA);
      if ba_main.FECHA_EMISION_FACTURA is null then
        observaciones := observaciones ||
                         '| FECHA DE EMISION FACTURA INVALIDA ';
      end if;
    end if;
    --DOCUMENTO COBRANZA------------------------------------------------------------------------------------
    if ba_tmp.NRO_DOCUMENTO_COBRANZA is null then
      observaciones := observaciones ||
                       '| NRO DE DOCUMENTO ES OBLIGATORIO ';
    else
      begin
        select count(*)
          into v_count
          from ap_invoices_all
         where invoice_num = ba_tmp.NRO_DOCUMENTO_COBRANZA
           and vendor_id =
               (select vendor_id
                  from apps.po_vendors
                 where segment1 = ba_tmp.RUC_PROVEEDOR);
      exception
        when others then
          v_count := 0;
      end;
      if v_count = 1 then
        observaciones := observaciones || '| NRO DE DOCUMENTO YA EXISTE ';
      else
        ba_main.NRO_DOCUMENTO_COBRANZA := ba_tmp.NRO_DOCUMENTO_COBRANZA;
      end if;
    end if;
    --FECHA DOCUMENTO COBRANZA----------------------------------------------------------------------
    if ba_tmp.FECHA_DOCUMENTO_COBRANZA is null then
      observaciones := observaciones ||
                       '| LA FECHA EMISION DOCUMENTO ES OBLIGATORIO ';
    else
      ba_main.FECHA_DOCUMENTO_COBRANZA := jc_main.fu_format_date(ba_tmp.FECHA_DOCUMENTO_COBRANZA);
      if ba_main.FECHA_DOCUMENTO_COBRANZA is null then
        observaciones := observaciones ||
                         '| FECHA DE EMISION DOCUMENTO INVALIDA ';
      end if;
    end if;
    --DNI-------------------------------------------------------------------------------------------
    /*if length(ba_tmp.DNI) > 8 then
      observaciones := observaciones || '| DNI DEBE TENER MAX 8 DIGITOS ';
    elsif not regexp_like(ba_tmp.DNI, '^[0-9.,\s-]+$') then
      observaciones := observaciones || '| DNI NO DEBE TENER LETRAS ';
    else
      ba_main.DNI := ba_tmp.DNI;
    end if;
    --PASAJES_AEREOS--------------------------------------------------------------------------------
    if ba_tmp.PASAJES_AEREOS is null then
      observaciones := observaciones ||
                       '| PASAJES AEREOS NO DEBE ESTAR VACIO ';
    else
      ba_main.PASAJES_AEREOS := ba_tmp.PASAJES_AEREOS;
    end if;
    --PASAJERO--------------------------------------------------------------------------------------
    if ba_tmp.PASAJERO is null then
      observaciones := observaciones || '| PASAJERO NO DEBE ESTAR VACIO ';
    else
      ba_main.pasajero := ba_tmp.pasajero;
    end if;*/
    --DETALLE DE VIAJE--------------------------------------------------------------------
    if ba_tmp.DETALLE_VIAJE is null then
      observaciones := observaciones ||
                       '| DETALLE VIAJE NO DEBE ESTAR VACIO ';
    else
      ba_main.DETALLE_VIAJE := ba_tmp.DETALLE_VIAJE;
    end if;
    --CENTRO COSTOS-----------------------------------------------------------------
    begin
      if ba_tmp.CENTRO_COSTO is null then
        --observaciones := observaciones ||
        --                 '| CENTRO COSTO NO DEBE ESTAR VACIO ';
        null;
      else
        select count(*)
          into v_count
          from apps.fnd_flex_values_vl fv
         where fv.value_category = 'TS_GL_CMA_CENTRO_COSTOS'
           and flex_value_set_id = 1014847
           and replace(upper(fv.description), ' ', '') =
               replace(upper(ba_tmp.CENTRO_COSTO), ' ', '')
           and fv.enabled_flag = 'Y'
           and summary_flag = 'N';
        if v_count = 0 then
          observaciones := observaciones || '| CENTRO DE COSTOS NO EXISTE ';
        else
          ba_main.CENTRO_COSTO := ba_tmp.CENTRO_COSTO;
        end if;
      end if;
    exception
      when others then
        observaciones := observaciones || '| CENTRO DE COSTOS INVÁLIDO ';
    end;
    --MOTIVO DE VIAJE---------------------------------------------------------------------
    if ba_tmp.MOTIVO_VIAJE is null then
      observaciones := observaciones ||
                       '| CAMPO MOTIVO DE VIAJE OBLIGATORIO ';
    elsif ba_tmp.MOTIVO_VIAJE not in
          ('Comisión Servicios - Personal Ag. Cobranzas',
           'Comisión Servicios - Personal Adm.',
           'Capacitación - Personal Ag. Cobranzas',
           'Capacitación - Personal Adm.', 'Comisión Servicios - Directores',
           'Capacitación - Directores', 'Gastos de Representación JGA') then
      observaciones        := observaciones ||
                              '| MOTIVO DE VIAJE INVALIDO ';
      ba_main.motivo_viaje := ba_tmp.motivo_viaje;
    end if;
    --FECHA SALIDA------------------------------------------------------------------------
    if ba_tmp.FECHA_SALIDA is null then
      observaciones := observaciones || '| FECHA DE SALIDA OBLIGATORIA ';
    else
      ba_main.FECHA_SALIDA := jc_main.fu_format_date(ba_tmp.FECHA_SALIDA);
      if ba_main.FECHA_SALIDA is null then
        observaciones := observaciones || '| FECHA DE SALIDA INVALIDA ';
      end if;
    end if;
    --FECHA LLEGADA-----------------------------------------------------------------------
    /*if ba_tmp.FECHA_LLEGADA is not null then
      ba_main.FECHA_LLEGADA := jc_main.fu_format_date(ba_tmp.FECHA_LLEGADA);
      if ba_main.FECHA_LLEGADA is null then
        observaciones := observaciones || '| FECHA DE LLEGADA INVALIDA ';
      end if;
    end if;*/
    --TARIFA NETA-------------------------------------------------------------------------
    begin
      if ba_tmp.TARIFA_NETA is null then
        observaciones := observaciones || '| TARIFA NETA OBLIGATORIO ';
      elsif not regexp_like(ba_tmp.TARIFA_NETA, '^[0-9.,\s-]+$') then
        observaciones := observaciones ||
                         '| LA TARIFA NETA NO DEBE TENER LETRAS';
      else
        begin
          ba_main.tarifa_neta := round(to_number(replace(trim(ba_tmp.tarifa_neta),
                                                         '.',
                                                         ','),
                                                 '9999999990D99',
                                                 'NLS_NUMERIC_CHARACTERS=,.'),
                                       2);
        exception
          when others then
            observaciones := observaciones || '| TARIFA NETA INVÁLIDA ';
        end;
      end if;
    end;
    --IMPUESTOS-----------------------------------------------------------------
    begin
      if not regexp_like(ba_tmp.IMPUESTO, '^[0-9.,\s-]+$') then
        observaciones := observaciones || '| IMPUESTO NO DEBE TENER LETRAS';
      else
        begin
          ba_main.IMPUESTO := round(to_number(replace(trim(ba_tmp.IMPUESTO),
                                                      '.',
                                                      ','),
                                              '9999999990D99',
                                              'NLS_NUMERIC_CHARACTERS=,.'),
                                    2);
        exception
          when others then
            observaciones := observaciones || '| IMPUESTOS INVÁLIDO ';
        end;
      end if;
    end;
    --OTROS IMPUESTOS----------------------------------------------------------------
    begin
      if ba_tmp.OTROS_IMPUESTOS is null then
        observaciones := observaciones || '| OTROS IMPUESTOS OBLIGATORIO ';
      elsif not regexp_like(ba_tmp.OTROS_IMPUESTOS, '^[0-9.,\s-]+$') then
        observaciones := observaciones ||
                         '| OTROS IMPUESTOS NO DEBE TENER LETRAS';
      else
        begin
          ba_main.OTROS_IMPUESTOS := round(to_number(replace(trim(ba_tmp.OTROS_IMPUESTOS),
                                                             '.',
                                                             ','),
                                                     '9999999990D99',
                                                     'NLS_NUMERIC_CHARACTERS=,.'),
                                           2);
        exception
          when others then
            observaciones := observaciones || '| OTROS IMPUESTOS INVÁLIDO ' ||
                             sqlerrm;
        end;
      end if;
    end;
    --FEE--------------------------------------------------------------------------
    begin
      if ba_tmp.FEE is null then
        observaciones := observaciones || '| FEE OBLIGATORIO ';
      elsif not regexp_like(ba_tmp.FEE, '^[0-9.,\s-]+$') then
        observaciones := observaciones || '| FEE NO DEBE TENER LETRAS';
      else
        begin
          ba_main.fee := round(to_number(replace(trim(ba_tmp.fee), '.', ','),
                                         '9999999990D99',
                                         'NLS_NUMERIC_CHARACTERS=,.'),
                               2);
        exception
          when others then
            observaciones := observaciones || '| FEE INVÁLIDO ';
        end;
      end if;
    end;
    --TOTAL------------------------------------------------------------------------
    begin
      if not regexp_like(ba_tmp.TOTAL, '^[0-9.,\s-]+$') then
        observaciones := observaciones || '| TOTAL NO DEBE TENER LETRAS';
      else
        begin
          ba_main.TOTAL := round(to_number(replace(trim(ba_tmp.TOTAL),
                                                   '.',
                                                   ','),
                                           '9999999990D99',
                                           'NLS_NUMERIC_CHARACTERS=,.'),
                                 2);
        exception
          when others then
            observaciones := observaciones || '| TOTAL INVÁLIDO ';
        end;
      end if;
    end;
    --MONEDA-----------------------------------------------------------------------
    if ba_tmp.MONEDA in ('PEN', 'USD') then
      ba_main.MONEDA := ba_tmp.MONEDA;
    else
      observaciones := observaciones || '| MONEDA INVÁLIDO ';
    end if;
    -------------------------------------------------------------------------------
    INSERT INTO JC_BA_TMP
      (ID,
       NRO_CARGA,
       --FECHA_HORA_EMISION,
       NRO_TICKET,
       FECHA_EMISION_TICKET,
       --RESERVA,
       --RUC_AEREOLINEA,
       NOMBRE_AEREOLINEA,
       --RUC_PROVEEDOR,
       --SOCIO_COMERCIAL,
       NRO_FACTURA,
       FECHA_EMISION_FACTURA,
       NRO_DOCUMENTO_COBRANZA,
       FECHA_DOCUMENTO_COBRANZA,
       --DNI,
       --PASAJES_AEREOS,
       PASAJERO,
       DETALLE_VIAJE,
       CENTRO_COSTO,
       --AGENCIA_SEDE,
       --REGION_SEDE,
       MOTIVO_VIAJE,
       --TIPO_VUELO,
       --RUTA,
       --ORIGEN_TICKET,
       --HORA_SALIDA,
       --HORA_LLEGADA,
       FECHA_SALIDA,
       --FECHA_LLEGADA,
       --DESTINO_TICKET,
       --MILLAS,
       TARIFA_NETA,
       IMPUESTO,
       OTROS_IMPUESTOS,
       FEE,
       TOTAL,
       MONEDA,
       OBSERVACIONES,
       USER_ID,
       CREATE_DATE)
    VALUES
      (jc_ba_id.nextval,
       ba_tmp.NRO_CARGA,
       --ba_tmp.FECHA_HORA_EMISION,
       ba_main.NRO_TICKET,
       ba_tmp.FECHA_EMISION_TICKET,
       --ba_tmp.RESERVA,
       --ba_tmp.RUC_AEREOLINEA,
       ba_tmp.NOMBRE_AEREOLINEA,
       --ba_tmp.RUC_PROVEEDOR,
       --ba_tmp.SOCIO_COMERCIAL,
       ba_tmp.NRO_FACTURA,
       ba_tmp.FECHA_EMISION_FACTURA,
       ba_tmp.NRO_DOCUMENTO_COBRANZA,
       ba_tmp.FECHA_DOCUMENTO_COBRANZA,
       --ba_tmp.DNI,
       --ba_tmp.PASAJES_AEREOS,
       ba_tmp.PASAJERO,
       ba_tmp.DETALLE_VIAJE,
       ba_tmp.CENTRO_COSTO,
       --ba_tmp.AGENCIA_SEDE,
       --ba_tmp.REGION_SEDE,
       ba_tmp.MOTIVO_VIAJE,
       --ba_tmp.TIPO_VUELO,
       --ba_tmp.RUTA,
       --ba_tmp.ORIGEN_TICKET,
       --ba_tmp.HORA_SALIDA,
       --ba_tmp.HORA_LLEGADA,
       ba_tmp.FECHA_SALIDA,
       --ba_tmp.FECHA_LLEGADA,
       --ba_tmp.DESTINO_TICKET,
       --ba_tmp.MILLAS,
       ba_tmp.TARIFA_NETA,
       ba_tmp.IMPUESTO,
       ba_tmp.OTROS_IMPUESTOS,
       ba_tmp.FEE,
       ba_tmp.TOTAL,
       ba_tmp.MONEDA,
       OBSERVACIONES,
       ba_tmp.USER_ID,
       ba_tmp.CREATE_DATE);
  
    return 'SUCCESS';
  exception
    when others then
      return sqlerrm;
  end;
  function fu_insert_main(v_nro_carga number) return varchar2 is
    ba_cabecera apps.jc_ba_cabecera%ROWTYPE;
    ba_oc       apps.jc_ba_oc%ROWTYPE;
    ba_oc_lines apps.jc_ba_oc_lineas%ROWTYPE;
    ba_receipt  apps.jc_ba_recepcion%ROWTYPE;
  begin
    for x in (select *
                from jc_ba_tmp
               where nro_carga = v_nro_carga
                 and observaciones is null) loop
      ba_cabecera.id        := x.id;
      ba_cabecera.nro_carga := x.nro_carga;
      --ba_cabecera.fecha_hora_emision       := jc_main.fu_format_date(x.fecha_hora_emision);
      ba_cabecera.nro_ticket           := x.nro_ticket;
      ba_cabecera.fecha_emision_ticket := jc_main.fu_format_date(x.fecha_emision_ticket);
      --ba_cabecera.reserva                  := x.reserva;
      --ba_cabecera.ruc_aereolinea           := x.ruc_aereolinea;
      --ba_cabecera.nombre_aereolinea        := x.nombre_aereolinea;
      ba_cabecera.ruc_proveedor            := x.ruc_proveedor;
      ba_cabecera.socio_comercial          := x.socio_comercial;
      ba_cabecera.nro_factura              := x.nro_factura;
      ba_cabecera.fecha_emision_factura    := jc_main.fu_format_date(x.fecha_emision_factura);
      ba_cabecera.nro_documento_cobranza   := x.nro_documento_cobranza;
      ba_cabecera.fecha_documento_cobranza := jc_main.fu_format_date(x.fecha_documento_cobranza);
      --ba_cabecera.dni                      := x.dni;
      --ba_cabecera.pasajes_aereos           := x.pasajes_aereos;
      ba_cabecera.pasajero      := x.pasajero;
      ba_cabecera.detalle_viaje := x.detalle_viaje;
      ba_cabecera.centro_costo  := x.centro_costo;
      --ba_cabecera.agencia_sede             := x.agencia_sede;
      --ba_cabecera.region_sede              := x.region_sede;
      ba_cabecera.motivo_viaje := x.motivo_viaje;
      --ba_cabecera.tipo_vuelo               := x.tipo_vuelo;
      --ba_cabecera.ruta                     := x.ruta;
      --ba_cabecera.origen_ticket            := x.origen_ticket;
      --ba_cabecera.hora_salida              := x.hora_salida;
      --ba_cabecera.hora_llegada             := x.hora_llegada;
      ba_cabecera.fecha_salida := jc_main.fu_format_date(x.fecha_salida);
      --ba_cabecera.fecha_llegada            := jc_main.fu_format_date(x.fecha_llegada);
      --ba_cabecera.destino_ticket           := x.destino_ticket;
      --ba_cabecera.millas                   := x.millas;
      ba_cabecera.tarifa_neta      := round(to_number(replace(trim(x.tarifa_neta),
                                                              '.',
                                                              ','),
                                                      '9999999990D99',
                                                      'NLS_NUMERIC_CHARACTERS=,.'),
                                            2);
      ba_cabecera.impuesto         := round(to_number(replace(trim(x.impuesto),
                                                              '.',
                                                              ','),
                                                      '9999999990D99',
                                                      'NLS_NUMERIC_CHARACTERS=,.'),
                                            2);
      ba_cabecera.otros_impuestos  := round(to_number(replace(trim(x.otros_impuestos),
                                                              '.',
                                                              ','),
                                                      '9999999990D99',
                                                      'NLS_NUMERIC_CHARACTERS=,.'),
                                            2);
      ba_cabecera.fee              := round(to_number(replace(trim(x.fee),
                                                              '.',
                                                              ','),
                                                      '9999999990D99',
                                                      'NLS_NUMERIC_CHARACTERS=,.'),
                                            2);
      ba_cabecera.total            := round(to_number(replace(trim(x.total),
                                                              '.',
                                                              ','),
                                                      '9999999990D99',
                                                      'NLS_NUMERIC_CHARACTERS=,.'),
                                            2);
      ba_cabecera.moneda           := x.moneda;
      ba_cabecera.create_date      := SYSDATE;
      ba_cabecera.created_by       := x.user_id;
      ba_cabecera.last_update_date := SYSDATE;
      ba_cabecera.last_update_by   := x.user_id;
      ba_cabecera.estado           := 'C';
      ba_cabecera.observacion      := '';
      begin
        select razon_social, ruc
          into ba_cabecera.nombre_aereolinea, ba_cabecera.ruc_aereolinea
          from jc_ba_aero
         where aerolinea = x.nombre_aereolinea;
      end;
      INSERT INTO jc_ba_cabecera
        (id,
         nro_carga,
         --fecha_hora_emision,
         nro_ticket,
         fecha_emision_ticket,
         --reserva,
         ruc_aereolinea,
         nombre_aereolinea,
         ruc_proveedor,
         socio_comercial,
         nro_factura,
         fecha_emision_factura,
         nro_documento_cobranza,
         fecha_documento_cobranza,
         --dni,
         --pasajes_aereos,
         pasajero,
         detalle_viaje,
         centro_costo,
         --agencia_sede,
         --region_sede,
         motivo_viaje,
         --tipo_vuelo,
         --ruta,
         --origen_ticket,
         --hora_salida,
         --hora_llegada,
         fecha_salida,
         --fecha_llegada,
         --destino_ticket,
         --millas,
         tarifa_neta,
         impuesto,
         otros_impuestos,
         fee,
         total,
         moneda,
         create_date,
         created_by,
         last_update_date,
         last_update_by,
         estado,
         observacion)
      VALUES
        (ba_cabecera.id,
         ba_cabecera.nro_carga,
         --ba_cabecera.fecha_hora_emision,
         ba_cabecera.nro_ticket,
         ba_cabecera.fecha_emision_ticket,
         --ba_cabecera.reserva,
         ba_cabecera.ruc_aereolinea,
         ba_cabecera.nombre_aereolinea,
         ba_cabecera.ruc_proveedor,
         ba_cabecera.socio_comercial,
         ba_cabecera.nro_factura,
         ba_cabecera.fecha_emision_factura,
         ba_cabecera.nro_documento_cobranza,
         ba_cabecera.fecha_documento_cobranza,
         --ba_cabecera.dni,
         --ba_cabecera.pasajes_aereos,
         ba_cabecera.pasajero,
         ba_cabecera.detalle_viaje,
         ba_cabecera.centro_costo,
         --ba_cabecera.agencia_sede,
         --ba_cabecera.region_sede,
         ba_cabecera.motivo_viaje,
         --ba_cabecera.tipo_vuelo,
         --ba_cabecera.ruta,
         --ba_cabecera.origen_ticket,
         --ba_cabecera.hora_salida,
         --ba_cabecera.hora_llegada,
         ba_cabecera.fecha_salida,
         --ba_cabecera.fecha_llegada,
         --ba_cabecera.destino_ticket,
         --ba_cabecera.millas,
         ba_cabecera.tarifa_neta,
         ba_cabecera.impuesto,
         ba_cabecera.otros_impuestos,
         ba_cabecera.fee,
         ba_cabecera.total,
         ba_cabecera.moneda,
         ba_cabecera.create_date,
         ba_cabecera.created_by,
         ba_cabecera.last_update_date,
         ba_cabecera.last_update_by,
         ba_cabecera.estado,
         ba_cabecera.observacion);
      ba_oc.id                  := ba_cabecera.id;
      ba_oc.cabecera_id         := ba_cabecera.id;
      ba_oc.document_type_code  := 'STANDARD';
      ba_oc.currency_code       := ba_cabecera.moneda;
      ba_oc.ship_to_location_id := 16267;
      ba_oc.estado              := ba_cabecera.estado;
      ba_oc.observacion         := ba_cabecera.observacion;
      /*begin
        select vendor_id
          into ba_oc.vendor_id
          from apps.po_vendors
         where segment1 = ba_cabecera.ruc_proveedor;
      exception
        when others then
          rollback;
          return 'RUC PROVEEDOR NO ENCONTRADO';
      end;*/
      /*begin
        select vendor_site_id
          into ba_oc.vendor_site_id
          from ap_supplier_sites_all
         where vendor_id = ba_oc.vendor_id
           and vendor_site_code = ba_cabecera.moneda;
      exception
        when others then
          rollback;
          return 'SUCURSAL PROVEEDOR NO ENCONTRADA';
      end;*/
      INSERT INTO jc_ba_oc
        (id,
         cabecera_id,
         po_header_interface,
         po_header_id,
         document_type_code,
         currency_code,
         vendor_id,
         vendor_site_id,
         rate,
         rate_date,
         rate_type,
         ship_to_location_id,
         estado,
         observacion)
      VALUES
        (ba_oc.id,
         ba_oc.cabecera_id,
         ba_oc.po_header_interface,
         ba_oc.po_header_id,
         ba_oc.document_type_code,
         ba_oc.currency_code,
         ba_oc.vendor_id,
         ba_oc.vendor_site_id,
         ba_oc.rate,
         ba_oc.rate_date,
         ba_oc.rate_type,
         ba_oc.ship_to_location_id,
         ba_oc.estado,
         ba_oc.observacion);
      for x in 1 .. 3 loop
        ba_oc_lines.id                          := jc_ba_oc_lin_seq.NEXTVAL;
        ba_oc_lines.oc_id                       := ba_oc.id;
        ba_oc_lines.line_num                    := x;
        ba_oc_lines.shipment_num                := x;
        ba_oc_lines.line_type_id                := 1;
        ba_oc_lines.uom_code                    := 'UN';
        ba_oc_lines.quantity                    := 1;
        ba_oc_lines.ship_to_organization_code   := 'ASV';
        ba_oc_lines.ship_to_location            := '';
        ba_oc_lines.line_loc_populated_flag     := 'Y';
        ba_oc_lines.negotiated_by_preparer_flag := 'N';
        ba_oc_lines.unit_price                  := CASE x WHEN 1 THEN ba_cabecera.tarifa_neta WHEN 2 THEN ba_cabecera.otros_impuestos WHEN 3 THEN ba_cabecera.fee END;
        ba_oc_lines.tax_name                    := CASE x WHEN 1 THEN 'IGV GASTO USD' WHEN 2 THEN 'NO AFECTO USD' WHEN 3 THEN 'IGV GASTO USD' END;
        ba_oc_lines.tax_code_id                 := CASE x WHEN 1 THEN 10067 WHEN 2 THEN 10068 WHEN 3 THEN 10067 END;
        ba_oc_lines.estado                      := 'C';
        ba_oc_lines.observacion                 := '';
        begin
          select mtli.category_id,
                 mtls.inventory_item_id,
                 mtls.expense_account
            into ba_oc_lines.category_id,
                 ba_oc_lines.item_id,
                 ba_oc_lines.charge_account_id
            from mtl_system_items_b mtls, mtl_item_categories mtli
           where mtls.inventory_item_id = mtli.inventory_item_id
             and mtli.organization_id = mtls.organization_id
             and (segment1 || '.' || segment2 || '.' || segment3) =
                 (select articulo_linea
                    from apps.jc_ba_articulos
                   where motivo_viaje = ba_cabecera.motivo_viaje
                     and linea_numero = ba_oc_lines.line_num)
             and mtli.organization_id = 144;
        end;
        begin
          select ship_to_location_id
            into ba_oc_lines.ship_to_location_id
            from hr_locations_all
           where description = 'ASV - Oficina Central La Merced';
        end;
        INSERT INTO JC_BA_OC_LINEAS
          (ID,
           OC_ID,
           INTERFACE_LINE_ID,
           INTERFACE_HEADER_ID,
           LINE_NUM,
           SHIPMENT_NUM,
           LINE_TYPE_ID,
           ITEM_ID,
           CATEGORY_ID,
           UOM_CODE,
           QUANTITY,
           UNIT_PRICE,
           SHIP_TO_ORGANIZATION_CODE,
           TAX_NAME,
           TAX_CODE_ID,
           SHIP_TO_LOCATION,
           SHIP_TO_LOCATION_ID,
           LINE_LOC_POPULATED_FLAG,
           NEGOTIATED_BY_PREPARER_FLAG,
           CHARGE_ACCOUNT_ID,
           ESTADO,
           OBSERVACION)
        VALUES
          (ba_oc_lines.ID,
           ba_oc_lines.OC_ID,
           ba_oc_lines.INTERFACE_LINE_ID,
           ba_oc_lines.INTERFACE_HEADER_ID,
           ba_oc_lines.LINE_NUM,
           ba_oc_lines.SHIPMENT_NUM,
           ba_oc_lines.LINE_TYPE_ID,
           ba_oc_lines.ITEM_ID,
           ba_oc_lines.CATEGORY_ID,
           ba_oc_lines.UOM_CODE,
           ba_oc_lines.QUANTITY,
           ba_oc_lines.UNIT_PRICE,
           ba_oc_lines.SHIP_TO_ORGANIZATION_CODE,
           ba_oc_lines.TAX_NAME,
           ba_oc_lines.TAX_CODE_ID,
           ba_oc_lines.SHIP_TO_LOCATION,
           ba_oc_lines.SHIP_TO_LOCATION_ID,
           ba_oc_lines.LINE_LOC_POPULATED_FLAG,
           ba_oc_lines.NEGOTIATED_BY_PREPARER_FLAG,
           ba_oc_lines.CHARGE_ACCOUNT_ID,
           ba_oc_lines.ESTADO,
           ba_oc_lines.OBSERVACION);
      end loop;
      for x in 1 .. 2 loop
        ba_receipt.id                     := JC_BA_RECEIP_SEQ.NEXTVAL;
        ba_receipt.cabecera_id            := ba_cabecera.ID;
        ba_receipt.numero_recepcion       := x;
        ba_receipt.processing_status_code := 'PENDING';
        ba_receipt.receipt_source_code    := 'VENDOR';
        ba_receipt.transaction_type       := 'NEW';
        --ba_receipt.vendor_id              := ba_oc.vendor_id;
        ba_receipt.expected_receipt_date := sysdate;
        ba_receipt.validation_flag       := 'Y';
        ba_receipt.org_id                := 81;
        ba_receipt.estado                := 'C';
        ba_receipt.observacion           := '';
        INSERT INTO JC_BA_RECEPCION
          (ID,
           CABECERA_ID,
           NUMERO_RECEPCION,
           SHIPMENT_HEADER_ID,
           HEADER_INTERFACE_ID,
           GROUP_ID,
           PROCESSING_STATUS_CODE,
           RECEIPT_SOURCE_CODE,
           TRANSACTION_TYPE,
           VENDOR_ID,
           EXPECTED_RECEIPT_DATE,
           VALIDATION_FLAG,
           ORG_ID,
           ESTADO,
           OBSERVACION)
        VALUES
          (ba_receipt.ID,
           ba_receipt.CABECERA_ID,
           ba_receipt.NUMERO_RECEPCION,
           ba_receipt.SHIPMENT_HEADER_ID,
           ba_receipt.HEADER_INTERFACE_ID,
           ba_receipt.GROUP_ID,
           ba_receipt.PROCESSING_STATUS_CODE,
           ba_receipt.RECEIPT_SOURCE_CODE,
           ba_receipt.TRANSACTION_TYPE,
           ba_receipt.VENDOR_ID,
           ba_receipt.EXPECTED_RECEIPT_DATE,
           ba_receipt.VALIDATION_FLAG,
           ba_receipt.ORG_ID,
           ba_receipt.ESTADO,
           ba_receipt.OBSERVACION);
      end loop;
    end loop;
    return 'SUCCESS';
  exception
    when others then
      return sqlerrm;
  end;
  function fu_concurrente_oc(pn_numero_carga      in number,
                             pd_fecha_contable    in varchar2,
                             pd_fecha_tipo_cambio in varchar2,
                             pn_vendor_id         in number,
                             pv_error             out varchar2)
    return varchar2 is
    pragma autonomous_transaction;
    ba_cabecera          jc_ba_cabecera%ROWTYPE;
    ba_oc                jc_ba_oc%ROWTYPE;
    vn_request_id        number;
    v_user_id            number;
    vn_application_id    number;
    vn_responsibility_id number;
  begin
    pv_error := null;
    begin
      select valor
        into vn_application_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'APPLICATION_ID_PO';
    exception
      when others then
        return 0;
    end;
    begin
      select valor
        into vn_responsibility_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'RESPONSIBILITY_ID_PO';
    exception
      when others then
        return 0;
    end;
    begin
      select created_by
        into v_user_id
        from jc_ba_cabecera
       where nro_carga = pn_numero_carga
         and rownum = 1;
    exception
      when others then
        v_user_id := 0;
    end;
    begin
      select vendor_name, segment1
        into ba_cabecera.socio_comercial, ba_cabecera.ruc_proveedor
        from po_vendors
       where vendor_id = pn_vendor_id;
      select vendor_site_id
        into ba_oc.vendor_site_id
        from ap_supplier_sites_all
       where vendor_id = pn_vendor_id
         and vendor_site_code = 'USD';
    end;
    begin
      update jc_ba_cabecera
         set estado          = 'T',
             observacion     = '',
             socio_comercial = ba_cabecera.socio_comercial,
             ruc_proveedor   = ba_cabecera.ruc_proveedor
       where nro_carga = pn_numero_carga
         and estado = 'V';
      update jc_ba_oc o
         set vendor_id      = pn_vendor_id,
             vendor_site_id = ba_oc.vendor_site_id
       where exists
       (select 1 from jc_ba_cabecera c where c.id = o.cabecera_id);
      update jc_ba_recepcion r
         set vendor_id = pn_vendor_id
       where exists
       (select 1 from jc_ba_cabecera c where c.id = r.cabecera_id);
    exception
      when others then
        return sqlerrm;
    end;
    fnd_global.apps_initialize(user_id      => v_user_id,
                               resp_id      => vn_responsibility_id,
                               resp_appl_id => vn_application_id);
  
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    vn_request_id := fnd_request.submit_request(application => 'JC',
                                                program     => 'JC_BA_OC',
                                                description => 'JC - BoletosAereos - OC',
                                                start_time  => sysdate,
                                                sub_request => false,
                                                argument1   => pn_numero_carga,
                                                argument2   => pd_fecha_contable,
                                                argument3   => pd_fecha_tipo_cambio);
    commit;
    if vn_request_id = 0 or vn_request_id is null then
      pv_error := fnd_message.get;
    end if;
    return vn_request_id;
  exception
    when others then
      pv_error := sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      return 0;
  end;
  procedure pr_create_oc_api(errbuf              out varchar2,
                             retcode             out varchar2,
                             p_nro_carga         number,
                             p_fecha_contable    varchar2,
                             p_fecha_tipo_cambio varchar2) is
    po_header         po_headers_interface%ROWTYPE;
    po_lines          po_lines_interface%ROWTYPE;
    po_locations      po_line_locations_interface%ROWTYPE;
    po_distributions  po_distributions_interface%ROWTYPE;
    application_id    fnd_responsibility.application_id%TYPE;
    responsibility_id fnd_responsibility.responsibility_id%TYPE;
    ba_oc             jc_ba_oc%ROWTYPE;
    email             jc_main.email;
    phase             varchar2(100);
    status            varchar2(100);
    dev_phase         varchar2(100);
    dev_status        varchar2(100);
    message           varchar2(255);
    valida            varchar2(100);
    complete          boolean;
    request_id        number;
  
    vv_segment1 varchar2(30);
    vv_segment2 varchar2(30);
    vv_segment3 varchar2(30);
    vv_segment4 varchar2(30);
  
    VN_CCID number;
  
    cursor main is
      SELECT cab.ID AS CAB_ID,
             cab.NRO_CARGA,
             --cab.FECHA_HORA_EMISION,
             cab.NRO_TICKET,
             cab.FECHA_EMISION_TICKET,
             --cab.RESERVA,
             cab.RUC_AEREOLINEA,
             cab.NOMBRE_AEREOLINEA,
             cab.RUC_PROVEEDOR,
             cab.SOCIO_COMERCIAL,
             cab.NRO_FACTURA,
             cab.FECHA_EMISION_FACTURA,
             cab.NRO_DOCUMENTO_COBRANZA,
             cab.FECHA_DOCUMENTO_COBRANZA,
             --cab.DNI,
             --cab.PASAJES_AEREOS,
             cab.PASAJERO,
             cab.DETALLE_VIAJE,
             cab.CENTRO_COSTO,
             --cab.AGENCIA_SEDE,
             --cab.REGION_SEDE,
             cab.MOTIVO_VIAJE,
             --cab.TIPO_VUELO,
             --cab.RUTA,
             --cab.ORIGEN_TICKET,
             --cab.HORA_SALIDA,
             --cab.HORA_LLEGADA,
             cab.FECHA_SALIDA,
             --cab.FECHA_LLEGADA,
             --cab.DESTINO_TICKET,
             --cab.MILLAS,
             cab.TARIFA_NETA,
             cab.IMPUESTO,
             cab.OTROS_IMPUESTOS,
             cab.FEE,
             cab.TOTAL,
             cab.MONEDA,
             cab.CREATE_DATE,
             cab.CREATED_BY,
             cab.LAST_UPDATE_DATE,
             cab.LAST_UPDATE_BY,
             cab.ESTADO AS CAB_ESTADO,
             cab.OBSERVACION AS CAB_OBSERVACION,
             oc.ID AS OC_ID,
             oc.PO_HEADER_INTERFACE,
             oc.PO_HEADER_ID,
             oc.DOCUMENT_TYPE_CODE,
             oc.CURRENCY_CODE,
             oc.VENDOR_ID,
             oc.VENDOR_SITE_ID,
             oc.RATE,
             oc.RATE_DATE,
             oc.RATE_TYPE,
             oc.SHIP_TO_LOCATION_ID,
             oc.ESTADO AS OC_ESTADO,
             oc.OBSERVACION AS OC_OBSERVACION
        FROM JC_BA_CABECERA cab
        JOIN JC_BA_OC oc ON oc.CABECERA_ID = cab.ID
       where cab.nro_carga = p_nro_carga
         and cab.estado = 'T'
       order by cab.id asc, cab.nro_carga asc;
  begin
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS=''. ''';
    execute immediate 'alter session set nls_language = "latin american spanish"';
    apps.jc_main.pr_print('alter session set nls_language = latin american spanish');
    apps.jc_main.pr_print('---------------------------------------------------------------------');
    apps.jc_main.pr_print('Inicio Proceso');
    apps.jc_main.pr_print('---------------------------------------------------------------------');
    po_header.batch_id := apps.jc_ba_batch_id_s.nextval;
    for x in main loop
      po_header.interface_header_id := po_headers_interface_s.nextval;
      po_header.process_code        := 'PENDING';
      po_header.action              := 'ORIGINAL';
      po_header.org_id              := 81;
      po_header.document_type_code  := x.document_type_code;
      po_header.currency_code       := x.currency_code;
      po_header.vendor_id           := x.vendor_id;
      po_header.vendor_site_id      := x.vendor_site_id;
      po_header.vendor_site_code    := x.currency_code;
      po_header.rate_type           := '1005';
      po_header.rate_type_code      := '1005';
      po_header.rate_date           := jc_main.fu_format_date(p_fecha_tipo_cambio);
      po_header.rate                := x.rate;
      po_header.ship_to_location_id := x.ship_to_location_id;
      po_header.bill_to_location_id := x.ship_to_location_id;
      po_header.comments            := 'CONSUMO_' || nvl(x.pasajero, ' ') || ' ' ||
                                       nvl(x.motivo_viaje, ' ');
      begin
        select fnd.employee_id
          into po_header.agent_id
          from fnd_user fnd
         where fnd.user_id = x.created_by;
      exception
        when no_data_found then
          retcode := 2;
          errbuf  := errbuf || 'No se encontro el ID del Empleado ||';
          apps.jc_main.pr_print('No se encontro el ID del Empleado');
          continue;
      end;
      begin
        select conversion_rate
          into po_header.rate
          from gl_daily_rates
         where conversion_date = po_header.rate_date
           and conversion_type = po_header.rate_type
           and from_currency = po_header.currency_code;
      exception
        when no_data_found then
          retcode := 2;
          errbuf  := errbuf || 'No se encontro el Tipo de Cambio ||';
          apps.jc_main.pr_print('No se encontro el Tipo de Cambio');
          continue;
      end;
      apps.jc_main.pr_print('');
      apps.jc_main.pr_print('---------------------------------------------------------');
      apps.jc_main.pr_print('Insert PO_HEADERS_INTERFACE');
      apps.jc_main.pr_print('---------------------------------------------------------');
      insert into po.po_headers_interface
        (interface_header_id,
         batch_id,
         process_code,
         action,
         org_id,
         document_type_code,
         currency_code,
         agent_id,
         vendor_id,
         vendor_site_id,
         vendor_site_code,
         rate_type,
         rate_type_code,
         rate_date,
         rate,
         ship_to_location_id,
         bill_to_location_id,
         payment_terms,
         comments)
      values
        (po_header.interface_header_id,
         po_header.batch_id,
         po_header.process_code,
         po_header.action,
         po_header.org_id,
         po_header.document_type_code,
         po_header.currency_code,
         po_header.agent_id,
         po_header.vendor_id,
         po_header.vendor_site_id,
         po_header.vendor_site_code,
         po_header.rate_type,
         po_header.rate_type_code,
         po_header.rate_date,
         po_header.rate,
         po_header.ship_to_location_id,
         po_header.bill_to_location_id,
         po_header.payment_terms,
         po_header.comments);
      begin
        update jc_ba_oc
           set po_header_interface = po_header.interface_header_id,
               rate                = po_header.rate,
               rate_date           = po_header.rate_date,
               rate_type           = po_header.rate_type,
               ship_to_location_id = po_header.ship_to_location_id
         where id = x.oc_id;
      end;
      for y in (select * from jc_ba_oc_lineas where oc_id = x.cab_id) loop
        po_lines.interface_line_id           := po_lines_interface_s.nextval;
        po_lines.interface_header_id         := po_header.interface_header_id;
        po_lines.line_num                    := y.line_num;
        po_lines.shipment_num                := y.shipment_num;
        po_lines.line_type_id                := y.line_type_id;
        po_lines.item_id                     := y.item_id;
        po_lines.category_id                 := y.category_id;
        po_lines.uom_code                    := y.uom_code;
        po_lines.quantity                    := y.quantity;
        po_lines.unit_price                  := y.unit_price;
        po_lines.ship_to_organization_code   := y.ship_to_organization_code;
        po_lines.tax_name                    := y.tax_name;
        po_lines.tax_code_id                 := y.tax_code_id;
        po_lines.ship_to_location            := y.ship_to_location;
        po_lines.ship_to_location_id         := y.ship_to_location_id;
        po_lines.line_loc_populated_flag     := y.line_loc_populated_flag;
        po_lines.negotiated_by_preparer_flag := y.negotiated_by_preparer_flag;
      
        apps.jc_main.pr_print('INSERT PO_LINES_INTERFACE');
        insert into po.po_lines_interface
          (interface_line_id,
           interface_header_id,
           line_num,
           shipment_num,
           line_type_id,
           item_id,
           category_id,
           uom_code,
           quantity,
           unit_price,
           ship_to_organization_code,
           tax_name,
           tax_code_id,
           ship_to_location,
           ship_to_location_id,
           line_loc_populated_flag,
           negotiated_by_preparer_flag)
        values
          (po_lines.interface_line_id,
           po_lines.interface_header_id,
           po_lines.line_num,
           po_lines.shipment_num,
           po_lines.line_type_id,
           po_lines.item_id,
           po_lines.category_id,
           po_lines.uom_code,
           po_lines.quantity,
           po_lines.unit_price,
           po_lines.ship_to_organization_code,
           po_lines.tax_name,
           po_lines.tax_code_id,
           po_lines.ship_to_location,
           po_lines.ship_to_location_id,
           po_lines.line_loc_populated_flag,
           po_lines.negotiated_by_preparer_flag);
      
        po_locations.interface_line_location_id := po_line_locations_interface_s.nextval;
        po_locations.interface_header_id        := po_lines.interface_header_id;
        po_locations.interface_line_id          := po_lines.interface_line_id;
        po_locations.shipment_type              := x.document_type_code;
        po_locations.shipment_num               := y.shipment_num;
        po_locations.ship_to_organization_id    := 144;
        po_locations.ship_to_location_id        := 16267;
        po_locations.quantity                   := y.quantity;
        po_locations.tax_name                   := y.tax_name;
        po_locations.creation_date              := sysdate;
        insert into po.po_line_locations_interface
          (interface_line_location_id,
           interface_header_id,
           interface_line_id,
           shipment_type,
           shipment_num,
           ship_to_organization_id,
           ship_to_location_id,
           quantity,
           tax_name,
           creation_date)
        values
          (po_locations.interface_line_location_id,
           po_locations.interface_header_id,
           po_locations.interface_line_id,
           po_locations.shipment_type,
           po_locations.shipment_num,
           po_locations.ship_to_organization_id,
           po_locations.ship_to_location_id,
           po_locations.quantity,
           po_locations.tax_name,
           po_locations.creation_date);
      
        po_distributions.interface_header_id         := po_lines.interface_header_id;
        po_distributions.interface_line_id           := po_lines.interface_line_id;
        po_distributions.interface_line_location_id  := po_locations.interface_line_location_id;
        po_distributions.interface_distribution_id   := po_distributions_interface_s.nextval;
        po_distributions.distribution_num            := 1;
        po_distributions.quantity_ordered            := po_lines.quantity;
        po_distributions.destination_type_code       := 'EXPENSE';
        po_distributions.destination_organization_id := 144;
        po_distributions.deliver_to_location_id      := 16267;
        po_distributions.gl_encumbered_period_name   := to_char(jc_main.fu_format_date(p_fecha_contable),
                                                                'MON-YY');
        po_distributions.gl_encumbered_date          := jc_main.fu_format_date(p_fecha_contable);
        po_distributions.org_id                      := po_header.org_id;
        po_distributions.charge_account_id           := y.charge_account_id;
      
        ----CVEAS INI 111125----
      
        BEGIN
        
          select segment1, segment2
            INTO VV_SEGMENT1, VV_SEGMENT2
            from gl_code_combinations
           where code_combination_id = po_distributions.charge_account_id;
        
        exception
          when others then
            apps.jc_main.pr_print(x.currency_code);
            apps.jc_main.pr_print(sqlerrm || ' -1 ' ||
                                  dbms_utility.format_error_backtrace);
          
        END;
      
        IF x.currency_code = 'USD' THEN
        
          VV_SEGMENT3 := '2';
        
        ELSE
        
          VV_SEGMENT3 := '1';
        
        END IF;
      
        begin
        
          SELECT FLEX_VALUE
            into vv_segment4
            FROM apps.FND_FLEX_VALUES_VL
           where value_category = 'TS_GL_CMA_CENTRO_COSTOS'
             and summary_flag = 'N'
             and flex_value_set_id = 1014847
             and enabled_flag = 'Y'
             and summary_flag = 'N'
             AND DESCRIPTION =
                 (select centro_costo
                    from JC_BA_CABECERA
                   where id in (SELECT cabecera_id
                                  FROM JC_BA_OC
                                 WHERE ID in (select oc_id
                                                from jc_ba_oc_lineas
                                               where oc_id = y.oc_id)));
        exception
          when others then
            apps.jc_main.pr_print(sqlerrm || ' -2 ' ||
                                  dbms_utility.format_error_backtrace);
          
        end;
      
        BEGIN
        
          select CODE_COMBINATION_ID
            INTO VN_CCID
            from gl_code_combinations
           where /*segment1 = VV_SEGMENT1
                                                                                   and */
           segment2 = VV_SEGMENT2
           and segment3 = VV_SEGMENT3
           and segment4 = vv_segment4; --999999999
        EXCEPTION
          WHEN OTHERS THEN
            VN_CCID := po_distributions.charge_account_id;
            apps.jc_main.pr_print(sqlerrm || ' -3 ' ||
                                  dbms_utility.format_error_backtrace);
        END;
      
        apps.jc_main.pr_print(po_distributions.charge_account_id || ' - ' ||
                              VV_SEGMENT1 || ' - ' || VV_SEGMENT2 || ' - ' ||
                              VV_SEGMENT3 || ' - ' || vv_segment4 || ' - ' ||
                              VN_CCID);
        ----CVEAS FIN 111125----
      
        insert into po.po_distributions_interface
          (interface_header_id,
           interface_line_id,
           interface_line_location_id,
           interface_distribution_id,
           distribution_num,
           quantity_ordered,
           destination_type_code,
           destination_organization_id,
           deliver_to_location_id,
           gl_encumbered_period_name,
           gl_encumbered_date,
           org_id,
           charge_account_id,
           creation_date)
        values
          (po_distributions.interface_header_id,
           po_distributions.interface_line_id,
           po_distributions.interface_line_location_id,
           po_distributions.interface_distribution_id,
           po_distributions.distribution_num,
           po_distributions.quantity_ordered,
           po_distributions.destination_type_code,
           po_distributions.destination_organization_id,
           po_distributions.deliver_to_location_id,
           po_distributions.gl_encumbered_period_name,
           po_distributions.gl_encumbered_date,
           po_distributions.org_id,
           VN_CCID, --po_distributions.charge_account_id,
           po_distributions.creation_date);
        update jc_ba_oc_lineas
           set interface_line_id   = po_lines.interface_line_id,
               interface_header_id = po_lines.interface_header_id
         where id = y.id;
      end loop;
    end loop;
    commit;
    begin
      begin
        select application_id, responsibility_id
          into application_id, responsibility_id
          from fnd_responsibility
         where responsibility_key = 'CMA PO MANAGER';
      exception
        when no_data_found then
          application_id    := 201;
          responsibility_id := 50678;
      end;
      execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
      mo_global.init('PO');
      mo_global.set_policy_context('S', po_header.org_id);
      fnd_global.apps_initialize(user_id      => po_header.CREATED_BY,
                                 resp_id      => responsibility_id,
                                 resp_appl_id => application_id);
      request_id := fnd_request.submit_request(application => 'PO',
                                               program     => 'POXPOPDOI',
                                               description => null,
                                               start_time  => null,
                                               sub_request => null,
                                               argument1   => po_header.agent_id,
                                               argument2   => 'STANDARD',
                                               argument3   => null,
                                               argument4   => 'N',
                                               argument5   => 'N',
                                               argument6   => 'INITIATE APPROVAL',
                                               argument7   => null,
                                               argument8   => po_header.batch_id,
                                               argument9   => po_header.org_id,
                                               argument10  => null,
                                               argument11  => null,
                                               argument12  => null,
                                               argument13  => null,
                                               argument14  => null);
      commit;
      if request_id > 0 then
        complete := fnd_concurrent.wait_for_request(request_id => request_id,
                                                    interval   => 2,
                                                    max_wait   => 100000,
                                                    phase      => phase,
                                                    status     => status,
                                                    dev_phase  => dev_phase,
                                                    dev_status => dev_status,
                                                    message    => message);
        commit;
        if complete then
          null; --shh
        end if;
        if upper(dev_phase) in ('COMPLETE', 'COMPLETED') then
          apps.jc_main.pr_print('');
          apps.jc_main.pr_print('------------------------------------------------------------');
          apps.jc_main.pr_print('Verificación de Creación');
          apps.jc_main.pr_print('------------------------------------------------------------');
          for x in main loop
            begin
              ba_oc.po_header_id := jc_main.fu_get_purchase_order(x.po_header_interface,
                                                                  ba_oc.observacion);
            exception
              when others then
                ba_oc.po_header_id := 0;
            end;
            if ba_oc.po_header_id != 0 then
              update apps.jc_ba_cabecera
                 set estado = 'P'
               where id = x.cab_id;
              update apps.jc_ba_oc
                 set estado = 'P', po_header_id = ba_oc.po_header_id
               where id = x.oc_id;
              update apps.jc_ba_oc_lineas
                 set estado = 'P'
               where oc_id = x.oc_id;
              --Incorporacion ANEXOS --<INI> - JZavala 23/06/2025
              for o in (select *
                          from jc_repositorio_documentos
                         where id = x.cab_id) loop
                pr_anexo_pdf(ba_oc.po_header_id, o.file_id);
              end loop;
              --Incorporacion ANEXOS --<FIN> - JZavala 23/06/2025
              --APROBACION AUTOMATICA OC -- <INI> - JZAVALA 23/06/2025
              jc_main.launch_workflow(p_po_header_id => ba_oc.po_header_id);
              commit;
              --APROBACION AUTOMATICA OC -- <FIN> - JZAVALA 23/06/2025
            else
              update apps.jc_ba_cabecera
                 set estado = 'E', observacion = ba_oc.observacion
               where id = x.cab_id;
              update apps.jc_ba_oc
                 set estado = 'E', observacion = ba_oc.observacion
               where id = x.oc_id;
              update apps.jc_ba_oc_lineas
                 set estado = 'E', observacion = ba_oc.observacion
               where oc_id = x.oc_id;
              commit;
            end if;
          end loop;
        end if;
      end if;
      commit;
      if request_id = 0 then
        apps.jc_main.pr_print('Failed to submit Process POXPOPDOI.' ||
                              fnd_message.get);
      else
        apps.jc_main.pr_print(request_id);
      end if;
    end;
    commit;
    begin
      email.de := 'ebsusuarios@cajaarequipa.pe';
      select email_address
        into email.para
        from apps.fnd_user
       where user_id = (select created_by
                          from jc_ba_cabecera
                         where nro_carga = p_nro_carga
                           and rownum = 1);
      email.cc      := '';
      email.asunto  := 'JC - Registro Boletos Aereos - Orden de Compra';
      email.mensaje := '<h3>Registro Masivo - Ordenes de Compra Boletos Aereos</h3>';
      email.mensaje := email.mensaje || '<p>Detalle de Carga:</p>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<table style="height: 152px;" width="620">' ||
                       chr(13);
      email.mensaje := email.mensaje || '<tbody>' || chr(13);
      email.mensaje := email.mensaje || '<tr>' || chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>OC</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>RUC</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>PROVEEDOR</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>DIVISA</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>MONTO</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>PASAJERO</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>ESTADO</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje || '</tr>' || chr(13);
      for r1 in (select po.segment1 oc,
                        pv.segment1 ruc,
                        pv.vendor_name proveedor,
                        po.currency_code divisa,
                        sum(pl.unit_price * pl.quantity) monto,
                        case
                          when jc.estado = 'P' then
                           'PROCESADO'
                          when jc.estado = 'E' then
                           'ERROR'
                        end estado,
                        fu.user_name username,
                        jc.pasajero
                   from jc_ba_cabecera jc
                   join jc_ba_oc oc on jc.id = oc.cabecera_id
                   left join po_headers_all po on po.po_header_id =
                                                  oc.po_header_id
                   join po_lines_all pl on pl.po_header_id = po.po_header_id
                   join po_vendors pv on pv.vendor_id = po.vendor_id
                   join fnd_user fu on fu.user_id = jc.created_by
                  where jc.nro_carga = p_nro_carga
                    and jc.estado in ('P', 'E')
                  group by po.segment1,
                           pv.segment1,
                           pv.vendor_name,
                           po.currency_code,
                           jc.estado,
                           fu.user_name,
                           jc.pasajero) loop
        email.mensaje := email.mensaje || '<tr>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.oc || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.ruc || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.proveedor || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.divisa || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.monto || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.pasajero || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.estado || '</td>' || chr(13);
        email.mensaje := email.mensaje || '</tr>' || chr(13);
      end loop;
      valida := apps.jc_main.fu_envia_correo(email.de,
                                             email.para,
                                             email.cc,
                                             email.asunto,
                                             email.mensaje);
      if valida != 'Success' then
        apps.jc_main.pr_print('Error al enviar el correo 3: ' || valida ||
                              ' | ' || sqlerrm);
      else
        apps.jc_main.pr_print('Correo enviado correctamente a: ' ||
                              email.para);
      end if;
    end;
  end;
  function fu_concurrente_receipt(pn_numero_carga      in number,
                                  pd_fecha_contable    in varchar2,
                                  pd_fecha_tipo_cambio in varchar2,
                                  pv_error             out varchar2)
    return varchar2 is
    pragma autonomous_transaction;
    vn_request_id        number;
    v_user_id            number;
    vn_application_id    number;
    vn_responsibility_id number;
  begin
    pv_error := null;
    begin
      select valor
        into vn_application_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'APPLICATION_ID_PO';
    exception
      when others then
        return 0;
    end;
    begin
      select valor
        into vn_responsibility_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'RESPONSIBILITY_ID_PO';
    exception
      when others then
        return 0;
    end;
    begin
      select created_by
        into v_user_id
        from jc_ba_cabecera
       where nro_carga = pn_numero_carga
         and rownum = 1;
    exception
      when others then
        v_user_id := 0;
    end;
    begin
      UPDATE jc_ba_recepcion r
         SET estado = 'T', observacion = ''
       WHERE r.estado IN ('C', 'E')
         AND EXISTS (SELECT 1
                FROM jc_ba_oc o
               WHERE o.cabecera_id = r.cabecera_id
                 AND o.po_header_id IS NOT NULL)
         AND r.cabecera_id IN
             (SELECT id
                FROM jc_ba_cabecera
               WHERE nro_carga = pn_numero_carga);
    exception
      when others then
        return sqlerrm;
    end;
    fnd_global.apps_initialize(user_id      => v_user_id,
                               resp_id      => vn_responsibility_id,
                               resp_appl_id => vn_application_id);
  
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    vn_request_id := fnd_request.submit_request(application => 'JC',
                                                program     => 'JC_BA_RC',
                                                description => 'JC - BoletosAereos - RC',
                                                start_time  => sysdate,
                                                sub_request => false,
                                                argument1   => pn_numero_carga,
                                                argument2   => pd_fecha_contable,
                                                argument3   => pd_fecha_tipo_cambio);
    commit;
    if vn_request_id = 0 or vn_request_id is null then
      pv_error := fnd_message.get;
    end if;
    return vn_request_id;
  exception
    when others then
      pv_error := sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      return 0;
  end;
  procedure pr_create_receipt_api(errbuf              out varchar2,
                                  retcode             out varchar2,
                                  p_nro_carga         number,
                                  p_fecha_contable    varchar2,
                                  p_fecha_tipo_cambio varchar2) as
    application_id       fnd_responsibility.application_id%TYPE;
    responsibility_id    fnd_responsibility.responsibility_id%TYPE;
    authorization_status po_headers_all.authorization_status%TYPE;
    rcv_transactions     rcv_transactions_interface%ROWTYPE;
    rcv_header           rcv_headers_interface%ROWTYPE;
    ba_receipt           jc_ba_recepcion%ROWTYPE;
    email                jc_main.email;
    phase                varchar2(100);
    status               varchar2(100);
    dev_phase            varchar2(100);
    dev_status           varchar2(100);
    message              varchar2(255);
    valida               varchar2(100);
    responsibility_name  varchar2(20);
    complete             boolean;
    request_id           number;
    v_count              number;
    v_number             number;
    cursor main is
      SELECT r.ID AS ID,
             r.CABECERA_ID,
             r.NUMERO_RECEPCION,
             r.SHIPMENT_HEADER_ID,
             r.HEADER_INTERFACE_ID,
             r.GROUP_ID,
             r.PROCESSING_STATUS_CODE,
             r.RECEIPT_SOURCE_CODE,
             r.TRANSACTION_TYPE,
             r.VENDOR_ID AS VENDOR_ID,
             r.EXPECTED_RECEIPT_DATE,
             r.VALIDATION_FLAG,
             r.ORG_ID,
             r.ESTADO AS ESTADO,
             r.OBSERVACION AS OBSERVACION,
             c.ID as CAB_ID,
             c.NRO_CARGA,
             --c.FECHA_HORA_EMISION,
             c.NRO_TICKET,
             c.FECHA_EMISION_TICKET,
             --c.RESERVA,
             c.RUC_AEREOLINEA,
             c.NOMBRE_AEREOLINEA,
             c.RUC_PROVEEDOR,
             c.SOCIO_COMERCIAL,
             c.NRO_FACTURA,
             c.FECHA_EMISION_FACTURA,
             c.NRO_DOCUMENTO_COBRANZA,
             c.FECHA_DOCUMENTO_COBRANZA,
             --c.DNI,
             --c.PASAJES_AEREOS,
             c.PASAJERO,
             c.DETALLE_VIAJE,
             c.CENTRO_COSTO,
             --c.AGENCIA_SEDE,
             --c.REGION_SEDE,
             c.MOTIVO_VIAJE,
             --c.TIPO_VUELO,
             --c.RUTA,
             --c.ORIGEN_TICKET,
             --c.HORA_SALIDA,
             --c.HORA_LLEGADA,
             c.FECHA_SALIDA,
             --c.FECHA_LLEGADA,
             --c.DESTINO_TICKET,
             --c.MILLAS,
             c.TARIFA_NETA,
             c.IMPUESTO,
             c.OTROS_IMPUESTOS,
             c.FEE,
             c.TOTAL,
             c.MONEDA,
             c.CREATE_DATE,
             c.CREATED_BY,
             c.LAST_UPDATE_DATE,
             c.LAST_UPDATE_BY,
             c.ESTADO AS CABECERA_ESTADO,
             c.OBSERVACION AS CABECERA_OBSERVACION,
             o.ID AS OC_ID,
             o.PO_HEADER_INTERFACE,
             o.PO_HEADER_ID,
             o.DOCUMENT_TYPE_CODE,
             o.CURRENCY_CODE,
             o.VENDOR_ID AS OC_VENDOR_ID,
             o.VENDOR_SITE_ID,
             o.RATE,
             o.RATE_DATE,
             o.RATE_TYPE,
             o.SHIP_TO_LOCATION_ID,
             o.ESTADO AS OC_ESTADO,
             o.OBSERVACION AS OC_OBSERVACION
        FROM JC_BA_RECEPCION r
        LEFT JOIN JC_BA_CABECERA c ON r.CABECERA_ID = c.ID
        LEFT JOIN JC_BA_OC o ON r.CABECERA_ID = o.CABECERA_ID
       where c.nro_carga = p_nro_carga
         and r.estado = 'T'
       order by r.id desc;
    cursor po_line(pv_header_id number) is
      select pl.item_id,
             pl.po_line_id,
             pl.line_num,
             pd.quantity_ordered quantity,
             pd.po_distribution_id,
             pl.unit_meas_lookup_code,
             mp.organization_code,
             pll.line_location_id,
             pll.closed_code,
             pll.quantity_received,
             pll.cancel_flag,
             pll.shipment_num
        from po_lines_all          pl,
             po_line_locations_all pll,
             po_distributions_all  pd,
             mtl_parameters        mp
       where pl.po_header_id = pv_header_id
         and pl.po_line_id = pll.po_line_id
         and pd.line_location_id = pll.line_location_id
         and pd.po_line_id = pl.po_line_id
         and pll.ship_to_organization_id = mp.organization_id;
  begin
    execute immediate 'alter session set NLS_NUMERIC_CHARACTERS=''. ''';
    execute immediate 'alter session set nls_language = "latin american spanish"';
    apps.jc_main.pr_print('alter session set nls_language = latin american spanish');
    apps.jc_main.pr_print('---------------------------------------------------------------------');
    apps.jc_main.pr_print('Inicio API Creación Receipt');
    apps.jc_main.pr_print('---------------------------------------------------------------------');
    begin
      select valor
        into responsibility_name
        from apps.jc_global_params
       where variable = 'RESPONSIBILITY_NAME_PO';
      select application_id, responsibility_id
        into application_id, responsibility_id
        from fnd_responsibility
       where responsibility_key = responsibility_name;
    end;
    rcv_header.group_id := rcv_interface_groups_s.nextval;
    for x in main loop
      begin
        select authorization_status
          into authorization_status
          from apps.po_headers_all
         where po_header_id = x.po_header_id;
      exception
        when others then
          retcode := 2;
          errbuf  := errbuf || 'No se encontro authorization_status || ';
          apps.jc_main.pr_print('No se encontro authorization_status');
      end;
      if authorization_status = 'APPROVED' then
        rcv_header.header_interface_id    := rcv_headers_interface_s.nextval;
        rcv_header.group_id               := x.group_id;
        rcv_header.processing_status_code := x.processing_status_code;
        rcv_header.receipt_source_code    := x.receipt_source_code;
        rcv_header.transaction_type       := x.transaction_type;
        rcv_header.vendor_id              := x.vendor_id;
        rcv_header.expected_receipt_date  := x.expected_receipt_date;
        rcv_header.validation_flag        := x.validation_flag;
        rcv_header.org_id                 := x.org_id;
        rcv_header.last_update_date       := sysdate;
        rcv_header.last_updated_by        := x.created_by;
        rcv_header.last_update_login      := 0;
        insert into rcv_headers_interface
          (header_interface_id,
           group_id,
           processing_status_code,
           receipt_source_code,
           transaction_type,
           vendor_id,
           expected_receipt_date,
           validation_flag,
           org_id,
           last_update_date,
           last_updated_by,
           last_update_login)
        values
          (rcv_header.header_interface_id,
           rcv_header.group_id,
           rcv_header.processing_status_code,
           rcv_header.receipt_source_code,
           rcv_header.transaction_type,
           rcv_header.vendor_id,
           rcv_header.expected_receipt_date,
           rcv_header.validation_flag,
           rcv_header.org_id,
           rcv_header.last_update_date,
           rcv_header.last_updated_by,
           rcv_header.last_update_login);
        if x.numero_recepcion = 1 then
          for i in 1 .. 2 loop
            for po in po_line(x.po_header_id) loop
              if po.closed_code in ('APPROVED', 'OPEN') and
                 po.quantity_received < po.quantity and
                 nvl(po.cancel_flag, 'N') = 'N' and po.line_num = i then
                for j in 1 .. 2 loop
                  rcv_transactions.parent_interface_txn_id  := CASE j WHEN 1 THEN '' WHEN 2 THEN rcv_transactions_interface_s.currval END;
                  rcv_transactions.interface_transaction_id := rcv_transactions_interface_s.nextval;
                  rcv_transactions.group_id                 := rcv_header.group_id;
                  rcv_transactions.transaction_type         := CASE j WHEN 1 THEN 'RECEIVE' WHEN 2 THEN 'DELIVER' END;
                  rcv_transactions.transaction_date         := jc_main.fu_format_date(p_fecha_contable);
                  rcv_transactions.processing_status_code   := 'PENDING';
                  rcv_transactions.processing_mode_code     := 'BATCH';
                  rcv_transactions.transaction_status_code  := 'PENDING';
                  rcv_transactions.po_header_id             := x.po_header_id;
                  rcv_transactions.po_line_id               := po.po_line_id;
                  rcv_transactions.item_id                  := po.item_id;
                  rcv_transactions.quantity                 := 1;
                  rcv_transactions.unit_of_measure          := po.unit_meas_lookup_code;
                  rcv_transactions.po_line_location_id      := po.line_location_id;
                  rcv_transactions.po_distribution_id       := po.po_distribution_id;
                  rcv_transactions.auto_transact_code       := CASE j WHEN 1 THEN 'RECEIVE' WHEN 2 THEN '' END;
                  rcv_transactions.receipt_source_code      := 'VENDOR';
                  rcv_transactions.to_organization_code     := po.organization_code;
                  rcv_transactions.source_document_code     := 'PO';
                  rcv_transactions.header_interface_id      := rcv_header.header_interface_id;
                  rcv_transactions.validation_flag          := 'Y';
                  rcv_transactions.currency_conversion_date := jc_main.fu_format_date(p_fecha_tipo_cambio);
                  rcv_transactions.org_id                   := 81;
                  rcv_transactions.destination_type_code    := CASE j WHEN 1 THEN 'RECEIVING' WHEN 2 THEN 'EXPENSE' END;
                  rcv_transactions.country_of_origin_code   := 'PE';
                  rcv_transactions.last_update_date         := sysdate;
                  rcv_transactions.last_updated_by          := x.created_by;
                  rcv_transactions.creation_date            := sysdate;
                  rcv_transactions.created_by               := x.created_by;
                  rcv_transactions.last_update_login        := 0;
                  insert into rcv_transactions_interface
                    (parent_interface_txn_id,
                     interface_transaction_id,
                     group_id,
                     transaction_type,
                     transaction_date,
                     processing_status_code,
                     processing_mode_code,
                     transaction_status_code,
                     po_header_id,
                     po_line_id,
                     item_id,
                     quantity,
                     unit_of_measure,
                     po_line_location_id,
                     po_distribution_id,
                     auto_transact_code,
                     receipt_source_code,
                     to_organization_code,
                     source_document_code,
                     header_interface_id,
                     validation_flag,
                     currency_conversion_date,
                     org_id,
                     destination_type_code,
                     country_of_origin_code,
                     last_update_date,
                     last_updated_by,
                     creation_date,
                     created_by,
                     last_update_login)
                  values
                    (rcv_transactions.parent_interface_txn_id,
                     rcv_transactions.interface_transaction_id,
                     rcv_transactions.group_id,
                     rcv_transactions.transaction_type,
                     rcv_transactions.transaction_date,
                     rcv_transactions.processing_status_code,
                     rcv_transactions.processing_mode_code,
                     rcv_transactions.transaction_status_code,
                     rcv_transactions.po_header_id,
                     rcv_transactions.po_line_id,
                     rcv_transactions.item_id,
                     rcv_transactions.quantity,
                     rcv_transactions.unit_of_measure,
                     rcv_transactions.po_line_location_id,
                     rcv_transactions.po_distribution_id,
                     rcv_transactions.auto_transact_code,
                     rcv_transactions.receipt_source_code,
                     rcv_transactions.to_organization_code,
                     rcv_transactions.source_document_code,
                     rcv_transactions.header_interface_id,
                     rcv_transactions.validation_flag,
                     rcv_transactions.currency_conversion_date,
                     rcv_transactions.org_id,
                     rcv_transactions.destination_type_code,
                     rcv_transactions.country_of_origin_code,
                     rcv_transactions.last_update_date,
                     rcv_transactions.last_updated_by,
                     rcv_transactions.creation_date,
                     rcv_transactions.created_by,
                     rcv_transactions.last_update_login);
                end loop;
              end if;
            end loop;
          end loop;
        elsif x.numero_recepcion = 2 then
          for po in po_line(x.po_header_id) loop
            if po.line_num = 3 then
              for j in 1 .. 2 loop
                rcv_transactions.parent_interface_txn_id  := CASE j WHEN 1 THEN '' WHEN 2 THEN rcv_transactions_interface_s.currval END;
                rcv_transactions.interface_transaction_id := rcv_transactions_interface_s.nextval;
                rcv_transactions.group_id                 := rcv_header.group_id;
                rcv_transactions.transaction_type         := CASE j WHEN 1 THEN 'RECEIVE' WHEN 2 THEN 'DELIVER' END;
                rcv_transactions.transaction_date         := jc_main.fu_format_date(p_fecha_contable);
                rcv_transactions.processing_status_code   := 'PENDING';
                rcv_transactions.processing_mode_code     := 'BATCH';
                rcv_transactions.transaction_status_code  := 'PENDING';
                rcv_transactions.po_header_id             := x.po_header_id;
                rcv_transactions.po_line_id               := po.po_line_id;
                rcv_transactions.item_id                  := po.item_id;
                rcv_transactions.quantity                 := 1;
                rcv_transactions.unit_of_measure          := po.unit_meas_lookup_code;
                rcv_transactions.po_line_location_id      := po.line_location_id;
                rcv_transactions.po_distribution_id       := po.po_distribution_id;
                rcv_transactions.auto_transact_code       := CASE j WHEN 1 THEN 'RECEIVE' WHEN 2 THEN '' END;
                rcv_transactions.receipt_source_code      := 'VENDOR';
                rcv_transactions.to_organization_code     := po.organization_code;
                rcv_transactions.source_document_code     := 'PO';
                rcv_transactions.header_interface_id      := rcv_header.header_interface_id;
                rcv_transactions.validation_flag          := 'Y';
                rcv_transactions.currency_conversion_date := jc_main.fu_format_date(p_fecha_tipo_cambio);
                rcv_transactions.org_id                   := 81;
                rcv_transactions.destination_type_code    := CASE j WHEN 1 THEN 'RECEIVING' WHEN 2 THEN 'EXPENSE' END;
                rcv_transactions.country_of_origin_code   := 'PE';
                rcv_transactions.last_update_date         := sysdate;
                rcv_transactions.last_updated_by          := x.created_by;
                rcv_transactions.creation_date            := sysdate;
                rcv_transactions.created_by               := x.created_by;
                rcv_transactions.last_update_login        := 0;
                insert into rcv_transactions_interface
                  (parent_interface_txn_id,
                   interface_transaction_id,
                   group_id,
                   transaction_type,
                   transaction_date,
                   processing_status_code,
                   processing_mode_code,
                   transaction_status_code,
                   po_header_id,
                   po_line_id,
                   item_id,
                   quantity,
                   unit_of_measure,
                   po_line_location_id,
                   po_distribution_id,
                   auto_transact_code,
                   receipt_source_code,
                   to_organization_code,
                   source_document_code,
                   header_interface_id,
                   validation_flag,
                   currency_conversion_date,
                   org_id,
                   destination_type_code,
                   country_of_origin_code,
                   last_update_date,
                   last_updated_by,
                   creation_date,
                   created_by,
                   last_update_login)
                values
                  (rcv_transactions.parent_interface_txn_id,
                   rcv_transactions.interface_transaction_id,
                   rcv_transactions.group_id,
                   rcv_transactions.transaction_type,
                   rcv_transactions.transaction_date,
                   rcv_transactions.processing_status_code,
                   rcv_transactions.processing_mode_code,
                   rcv_transactions.transaction_status_code,
                   rcv_transactions.po_header_id,
                   rcv_transactions.po_line_id,
                   rcv_transactions.item_id,
                   rcv_transactions.quantity,
                   rcv_transactions.unit_of_measure,
                   rcv_transactions.po_line_location_id,
                   rcv_transactions.po_distribution_id,
                   rcv_transactions.auto_transact_code,
                   rcv_transactions.receipt_source_code,
                   rcv_transactions.to_organization_code,
                   rcv_transactions.source_document_code,
                   rcv_transactions.header_interface_id,
                   rcv_transactions.validation_flag,
                   rcv_transactions.currency_conversion_date,
                   rcv_transactions.org_id,
                   rcv_transactions.destination_type_code,
                   rcv_transactions.country_of_origin_code,
                   rcv_transactions.last_update_date,
                   rcv_transactions.last_updated_by,
                   rcv_transactions.creation_date,
                   rcv_transactions.created_by,
                   rcv_transactions.last_update_login);
              end loop;
            end if;
          end loop;
        end if;
        update jc_ba_recepcion
           set header_interface_id = rcv_header.HEADER_INTERFACE_ID,
               group_id            = rcv_header.group_id
         where id = x.id;
      elsif authorization_status = 'INCOMPLETE' then
        update jc_ba_recepcion
           set estado = 'C', observacion = 'ORDEN DE COMPRA NO APROBADA'
         where id = x.id;
      elsif authorization_status = 'IN PROCESS' then
        update jc_ba_recepcion
           set estado = 'C', observacion = 'PENDIENTE DE APROBAR'
         where id = x.id;
      elsif authorization_status = 'REJECTED' then
        update jc_ba_recepcion
           set estado = 'E', observacion = 'ORDEN DE COMPRA RECHAZADA'
         where id = x.id;
      end if;
    end loop;
    mo_global.init('PO');
    mo_global.set_policy_context('S', rcv_header.org_id);
    fnd_global.apps_initialize(user_id      => rcv_transactions.created_by,
                               resp_id      => responsibility_id,
                               resp_appl_id => application_id);
    request_id := fnd_request.submit_request(application => 'PO',
                                             program     => 'RVCTP',
                                             description => null,
                                             start_time  => null,
                                             sub_request => null,
                                             argument1   => 'BATCH',
                                             argument2   => rcv_transactions.group_id,
                                             argument3   => rcv_transactions.org_id);
    apps.jc_main.pr_print('PROCESO 1');
    commit;
  
    if request_id > 0 then
      complete := fnd_concurrent.wait_for_request(request_id => request_id,
                                                  interval   => 2,
                                                  max_wait   => 100000,
                                                  phase      => phase,
                                                  status     => status,
                                                  dev_phase  => dev_phase,
                                                  dev_status => dev_status,
                                                  message    => message);
      commit;
      if complete then
        null; --shh
      end if;
      if upper(dev_phase) in ('COMPLETE', 'COMPLETED') then
        for x in main loop
          begin
            select count(1)
              into v_count
              from rcv_transactions
             where po_header_id = x.po_header_id;
          exception
            when others then
              v_count := 0;
          end;
          if v_count != 0 then
            begin
              v_number := 0;
              for k in (select distinct shipment_header_id
                          from rcv_transactions
                         where po_header_id = x.po_header_id
                           and shipment_header_id is not null) loop
                v_number := v_number + 1;
                update jc_ba_recepcion
                   set shipment_header_id = k.shipment_header_id,
                       group_id           = rcv_header.group_id
                 where cabecera_id = x.cabecera_id
                   and numero_recepcion = v_number;
                ba_receipt.estado      := 'P';
                ba_receipt.observacion := '';
              end loop;
            exception
              when others then
                ba_receipt.estado      := 'E';
                ba_receipt.observacion := 'ERROR AL ENCONTRAR EL ID DE LAS RECEPCIONES';
            end;
          else
            ba_receipt.estado      := 'E';
            ba_receipt.observacion := 'ERROR NO SE CREARON LAS RECEPCIONES';
          end if;
          update jc_ba_recepcion
             set estado      = ba_receipt.estado,
                 observacion = ba_receipt.observacion,
                 group_id    = rcv_header.group_id
           where id = x.id;
        end loop;
      end if;
    end if;
    apps.jc_main.pr_print('PROCESO 2');
    commit;
    begin
      --pr_invoice_ap(cabecera_id);
      for x in (select distinct (cab.id)
                  from jc_ba_recepcion rec
                  join jc_ba_cabecera cab on rec.cabecera_id = cab.id
                 where nro_carga = p_nro_carga
                   and rec.estado = 'P') loop
        pr_invoice_ap(x.id);
      end loop;
    end;
    begin
      apps.jc_main.pr_print('CREANDO CORREO');
      v_count       := 0;
      email.mensaje := '<h3>Registro Masivo - Recepciones Boletos Aereos</h3>';
      email.mensaje := email.mensaje || '<p>Detalle de Carga:</p>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<table style="height: 152px;" width="620">' ||
                       chr(13);
      email.mensaje := email.mensaje || '<tbody>' || chr(13);
      email.mensaje := email.mensaje || '<tr>' || chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>RECEPCIONES</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>OC</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>RUC</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>PROVEEDOR</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>DIVISA</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>MONTO</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje ||
                       '<td style="background-color: #87cefa;"><span style="background-color: #99ccff;"><strong>ESTADO</strong></span></td>' ||
                       chr(13);
      email.mensaje := email.mensaje || '</tr>' || chr(13);
      for r1 in (SELECT recibos,
                        oc,
                        ruc,
                        proveedor,
                        divisa,
                        monto,
                        CASE
                          WHEN estado = 'P' THEN
                           'PROCESADO'
                          WHEN estado = 'E' THEN
                           'ERROR'
                        END AS estado,
                        username
                   FROM (SELECT LISTAGG(DISTINCT(rsh.receipt_num), ' | ') WITHIN
                          GROUP(
                          ORDER BY rsh.receipt_num) AS recibos, po.segment1 AS oc, pv.segment1 AS ruc, pv.vendor_name AS proveedor, po.currency_code AS divisa, SUM(pl.unit_price * pl.quantity) AS monto, jbr.estado, fu.user_name AS username
                           FROM jc_ba_oc jc
                           JOIN jc_ba_cabecera cab ON jc.cabecera_id = cab.id
                           LEFT JOIN po_headers_all po ON po.po_header_id =
                                                          jc.po_header_id
                           JOIN po_lines_all pl ON pl.po_header_id =
                                                   po.po_header_id
                           JOIN po_vendors pv ON pv.vendor_id = po.vendor_id
                           JOIN fnd_user fu ON fu.user_id = cab.created_by
                           LEFT JOIN jc_ba_recepcion jbr ON jbr.cabecera_id =
                                                            cab.id
                           LEFT JOIN rcv_shipment_headers rsh ON rsh.shipment_header_id =
                                                                 jbr.shipment_header_id
                          WHERE cab.nro_carga = p_nro_carga
                            AND jbr.estado IN ('P', 'E')
                          GROUP BY po.segment1,
                                   pv.segment1,
                                   pv.vendor_name,
                                   po.currency_code,
                                   fu.user_name,
                                   jc.id,
                                   jbr.estado)) loop
        email.mensaje := email.mensaje || '<tr>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.recibos || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.oc || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.ruc || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.proveedor || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.divisa || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.monto || '</td>' || chr(13);
        email.mensaje := email.mensaje || '<td style="width: 302px;">' ||
                         r1.estado || '</td>' || chr(13);
        email.mensaje := email.mensaje || '</tr>' || chr(13);
        v_count       := v_count + 1;
      end loop;
      if v_count = 0 then
        email.mensaje := '<h3>Registro Masivo - Recepciones Boletos Aereos</h3>';
        email.mensaje := email.mensaje ||
                         '<p>No se ha creado correctamente las Recepciones. Comunicarse al Soporte EBS.</p>' ||
                         chr(13);
      end if;
      apps.jc_main.pr_print('ENVIANDO CORREO');
      begin
        email.de := 'ebsusuarios@cajaarequipa.pe';
        select email_address
          into email.para
          from apps.fnd_user
         where user_id = (select created_by
                            from jc_ba_cabecera
                           where nro_carga = p_nro_carga
                             and rownum = 1);
        valida := apps.jc_main.fu_envia_correo(email.de,
                                               email.para,
                                               email.cc,
                                               email.asunto,
                                               email.mensaje);
      exception
        when others then
          apps.jc_main.pr_print('Error al enviar el correo 2.1: ' ||
                                sqlerrm);
      end;
      if valida != 'Success' then
        apps.jc_main.pr_print('Error al enviar el correo 3: ' || valida ||
                              ' | ' || sqlerrm);
      else
        apps.jc_main.pr_print('Correo enviado correctamente a: ' ||
                              email.para);
      end if;
    end;
  end;
  function fu_concurrente_invoice(pn_numero_carga   in number,
                                  pd_fecha_contable in varchar2,
                                  pd_fecha_cambio   in varchar2,
                                  pv_error          out varchar2)
    return varchar2 as
    pragma autonomous_transaction;
    vn_request_id        number;
    v_user_id            number;
    vn_application_id    number;
    vn_responsibility_id number;
  begin
    pv_error := null;
    begin
      select valor
        into vn_application_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'APPLICATION_ID_AP';
    exception
      when others then
        return 0;
    end;
    begin
      select valor
        into vn_responsibility_id
        from jc_global_params
       where proyecto_id = p_id_aplicacion
         and variable = 'RESPONSIBILITY_ID_AP';
    exception
      when others then
        return 0;
    end;
    begin
      select created_by
        into v_user_id
        from jc_ba_cabecera
       where nro_carga = pn_numero_carga
         and rownum = 1;
    exception
      when others then
        v_user_id := 0;
    end;
    begin
      update jc_ba_ap
         set estado = 'T', observacion = '' --,
      --fecha_contable = pd_fecha_contable
       where nro_carga = pn_numero_carga
         and estado in ('C', 'E');
    exception
      when others then
        return sqlerrm;
    end;
    commit;
    fnd_global.apps_initialize(user_id      => v_user_id,
                               resp_id      => vn_responsibility_id,
                               resp_appl_id => vn_application_id);
  
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    vn_request_id := fnd_request.submit_request(application => 'JC',
                                                program     => 'JC_BA_AP',
                                                description => 'JC - BoletosAereos - AP',
                                                start_time  => sysdate,
                                                sub_request => false,
                                                argument1   => pn_numero_carga,
                                                argument2   => pd_fecha_contable,
                                                argument3   => pd_fecha_cambio);
    commit;
    if vn_request_id = 0 or vn_request_id is null then
      pv_error := fnd_message.get;
    end if;
    return vn_request_id;
  exception
    when others then
      pv_error := sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      return 0;
  end;
  procedure pr_create_invoice(errbuf           out varchar,
                              retcode          out number,
                              p_nro_carga      number,
                              p_fecha_contable varchar2,
                              pd_fecha_cambio  varchar2) as
    --l_reject_lookup_code ap_interface_rejections.reject_lookup_code%type;
    ap_invoices          ap_invoices_all%ROWTYPE;
    ap_interface         ap_invoices_interface%ROWTYPE;
    ap_lines             ap_invoice_lines_interface%ROWTYPE;
    ts_invoice           ts_ap_invoices_all%ROWTYPE;
    rcv_headers          rcv_shipment_headers%ROWTYPE;
    l_reject_lookup_code varchar2(32767);
    vc_observacion       varchar2(4000);
    phase                varchar2(100);
    status               varchar2(100);
    dev_phase            varchar2(100);
    dev_status           varchar2(100);
    message              varchar2(255);
    v_parte              VARCHAR2(50);
    v_guardar            VARCHAR2(50);
    complete             boolean;
    v_boolean            boolean;
    request_id           number;
    cursor main is
      SELECT ba_ap.id                       AS id,
             ba_ap.nro_carga                AS nro_carga,
             ba_ap.cabecera_id              AS cabecera_id,
             ba_ap.recepcion_id             AS recepcion_id,
             ba_ap.shipment_header_id       AS shipment_header_id,
             ba_ap.po_header_id             AS po_header_id,
             ba_ap.interface_id             AS interface_id,
             ba_ap.invoice_id               AS invoice_id,
             ba_ap.invoice_num              AS invoice_num,
             ba_ap.invoice_amount           AS invoice_amount,
             ba_ap.invoice_date             AS invoice_date,
             ba_ap.invoice_type_lookup_code AS invoice_type_lookup_code,
             ba_ap.invoice_currency_code    AS invoice_currency_code,
             ba_ap.party_id                 AS party_id,
             ba_ap.vendor_id                AS vendor_id,
             ba_ap.vendor_site_id           AS vendor_site_id,
             ba_ap.external_bank_account_id AS external_bank_account_id,
             ba_ap.exchange_rate_type       AS exchange_rate_type,
             ba_ap.exchange_date            AS exchange_date,
             ba_ap.exchange_rate            AS exchange_rate,
             ba_ap.doc_sunat                AS doc_sunat,
             ba_ap.aplica_retencion         AS aplica_retencion,
             ba_ap.id_servicio              AS id_servicio,
             ba_ap.igv_no_dom               AS igv_no_dom,
             ba_ap.clase_servicio_adq       AS clase_servicio_adq,
             ba_ap.motivo_excepcion         AS motivo_excepcion,
             ba_ap.det_tipo_operacion       AS det_tipo_operacion,
             ba_ap.enabled_flag             AS enabled_flag,
             ba_ap.estado                   AS estado,
             ba_ap.observacion              AS observacion,
             ba_ap.created_by               AS created_by,
             ba_ap.creation_date            AS creation_date,
             ba_ap.last_update_by           AS last_update_by,
             ba_ap.last_update_date         AS last_update_date,
             --ba_cab.fecha_hora_emision      AS cab_fecha_hora_emision,
             ba_cab.nro_ticket           AS cab_nro_ticket,
             ba_cab.fecha_emision_ticket AS cab_fecha_emision_ticket,
             ba_cab.ruc_aereolinea       AS cab_ruc_aereolinea,
             ba_cab.nombre_aereolinea    AS cab_nombre_aereolinea,
             --ba_cab.pasajes_aereos          as pasajes_aereos,
             ba_cab.pasajero      as pasajero,
             ba_cab.detalle_viaje as detalle_viaje,
             ba_cab.fecha_salida  as fecha_salida,
             ba_rec.org_id        AS org_id
        FROM jc_ba_ap ba_ap
        JOIN jc_ba_cabecera ba_cab ON ba_cab.id = ba_ap.cabecera_id
        JOIN jc_ba_oc ba_oc ON ba_oc.cabecera_id = ba_ap.cabecera_id
        JOIN jc_ba_recepcion ba_rec ON ba_rec.id = ba_ap.recepcion_id
       WHERE ba_ap.nro_carga = p_nro_carga
         AND ba_ap.estado = 'T'
         AND ba_ap.enabled_flag = 'Y'
       ORDER BY ba_ap.id desc;
  begin
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    ap_interface.group_id            := jc_po_s.nextval;
    ap_interface.payment_method_code := 'EFT';
    ap_interface.org_id              := 81;
    ap_interface.source              := 'JC_CARGA_PROV';
    begin
      for x in main loop
        begin
          select segment1
            into ap_interface.po_number
            from po_headers_all
           where po_header_id = x.po_header_id;
          select receipt_num
            into rcv_headers.receipt_num
            from APPS.rcv_shipment_headers
           where shipment_header_id = x.shipment_header_id;
        end;
        ap_interface.invoice_id               := ap_invoices_interface_s.nextval;
        ap_interface.invoice_num              := x.invoice_num;
        ap_interface.invoice_type_lookup_code := x.invoice_type_lookup_code;
        ap_interface.invoice_date             := x.invoice_date;
        ap_interface.invoice_amount           := x.invoice_amount;
        ap_interface.terms_name               := 'CONT';
        ap_interface.terms_date               := sysdate;
        ap_interface.gl_date                  := jc_main.fu_format_date(p_fecha_contable);
        ap_interface.party_id                 := x.party_id;
        ap_interface.attribute1               := 3;
        ap_interface.vendor_id                := x.vendor_id;
        ap_interface.vendor_site_id           := x.vendor_site_id;
        ap_interface.invoice_currency_code    := x.invoice_currency_code;
        ap_interface.external_bank_account_id := x.external_bank_account_id;
        ap_interface.party_id                 := x.party_id;
        ap_interface.exchange_rate_type       := x.exchange_rate_type;
        ap_interface.exchange_date            := jc_main.fu_format_date(pd_fecha_cambio); --x.exchange_date;
        --ap_interface.exchange_rate            := x.exchange_rate;
        ap_interface.created_by  := x.created_by;
        ap_interface.description := ap_interface.po_number ||
                                    ' | PASAJES AEREOS | ' || x.pasajero ||
                                    ' | ' || x.detalle_viaje || ' | ' ||
                                    to_char(x.fecha_salida, 'MON-YYYY');
        begin
          update jc_ba_ap
             set interface_id     = ap_interface.invoice_id,
                 last_update_by   = fnd_global.user_id,
                 last_update_date = sysdate
           where id = x.id;
          insert into ap_invoices_interface
            (invoice_id,
             invoice_num,
             invoice_type_lookup_code,
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
             terms_name,
             terms_date,
             group_id,
             gl_date,
             party_id,
             attribute1,
             exchange_rate_type,
             exchange_date,
             exchange_rate)
          values
            (ap_interface.invoice_id,
             ap_interface.invoice_num,
             ap_interface.invoice_type_lookup_code,
             ap_interface.po_number,
             ap_interface.vendor_id,
             ap_interface.vendor_site_id,
             ap_interface.invoice_amount,
             ap_interface.invoice_currency_code,
             ap_interface.invoice_date,
             ap_interface.description,
             ap_interface.source,
             ap_interface.org_id,
             ap_interface.payment_method_code,
             ap_interface.terms_name,
             ap_interface.terms_date,
             ap_interface.group_id,
             ap_interface.gl_date,
             ap_interface.party_id,
             ap_interface.attribute1,
             ap_interface.exchange_rate_type,
             ap_interface.exchange_date,
             ap_interface.exchange_rate);
        end;
        -----------------------------------------------------------------------
        begin
          ap_lines.line_number := 0;
          for i in (select rt.po_line_location_id as c1,
                           rt.transaction_id      as c2,
                           rt.po_unit_price       as c3,
                           rt.quantity            as c4
                      from po_headers_all       pha,
                           rcv_shipment_headers rsh,
                           rcv_transactions     rt
                     where pha.segment1 = ap_interface.po_number
                       and pha.vendor_id = rsh.vendor_id
                       and rsh.receipt_num = rcv_headers.receipt_num --??
                       and rt.po_header_id = pha.po_header_id
                       and rt.shipment_header_id = rsh.shipment_header_id
                       and rt.transaction_type = 'RECEIVE') loop
            --correccion 18/12/2025
            v_parte   := REGEXP_SUBSTR(x.cab_nro_ticket, '[^-]+$'); -- todo después del guion (o todo si no hay guion)
            v_guardar := '3-' || CASE WHEN LENGTH(v_parte) > 11 THEN SUBSTR(v_parte, -11) ELSE v_parte END;
            --fin correccion
            ap_lines.invoice_id            := ap_interface.invoice_id;
            ap_lines.line_number           := ap_lines.line_number + 1;
            ap_lines.line_type_lookup_code := 'ITEM';
            ap_lines.amount                := round(i.c3 * i.c4, 2);
            ap_lines.po_line_location_id   := i.c1;
            ap_lines.rcv_transaction_id    := i.c2;
            ap_lines.unit_price            := i.c3;
            ap_lines.quantity_invoiced     := i.c4;
            ap_lines.attribute_category    := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN 'PE' WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute5            := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN to_char(x.cab_fecha_emision_ticket, 'YYYY/MM/DD HH:mm:ss') WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute6            := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN '6' WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute10           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN '02' WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute11           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN '4' WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute12           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN x.cab_ruc_aereolinea WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute13           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN v_guardar /*x.cab_nro_ticket*/
             WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute14           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN x.cab_nombre_aereolinea WHEN 'STANDARD' THEN '' END;
            ap_lines.attribute15           := CASE
                                              ap_interface.invoice_type_lookup_code WHEN 'EXPENSE REPORT' THEN '05' WHEN 'STANDARD' THEN '' END;
            insert into ap_invoice_lines_interface
              (invoice_id,
               line_number,
               line_type_lookup_code,
               amount,
               po_line_location_id,
               rcv_transaction_id,
               unit_price,
               quantity_invoiced,
               attribute_category,
               attribute5,
               attribute6,
               attribute10,
               attribute11,
               attribute12,
               attribute13,
               attribute14,
               attribute15)
            values
              (ap_lines.invoice_id,
               ap_lines.line_number,
               ap_lines.line_type_lookup_code,
               ap_lines.amount,
               ap_lines.po_line_location_id,
               ap_lines.rcv_transaction_id,
               ap_lines.unit_price,
               ap_lines.quantity_invoiced,
               ap_lines.attribute_category,
               ap_lines.attribute5,
               ap_lines.attribute6,
               ap_lines.attribute10,
               ap_lines.attribute11,
               ap_lines.attribute12,
               ap_lines.attribute13,
               ap_lines.attribute14,
               ap_lines.attribute15);
          end loop;
        end;
      end loop;
      commit;
    end;
    begin
      mo_global.init('SQLAP');
      fnd_global.apps_initialize(user_id      => ap_interface.created_by,
                                 resp_id      => 50697,
                                 resp_appl_id => 200);
    
      request_id := fnd_request.submit_request(application => 'SQLAP',
                                               program     => 'APXIIMPT',
                                               description => '',
                                               start_time  => null,
                                               sub_request => false,
                                               argument1   => 81,
                                               argument2   => ap_interface.source,
                                               argument3   => ap_interface.group_id,
                                               argument4   => null,
                                               argument5   => null,
                                               argument6   => null,
                                               argument7   => null,
                                               argument8   => 'N',
                                               argument9   => 'Y');
      commit;
      jc_main.pr_print(request_id);
    end;
    begin
      if request_id > 0 then
        complete := fnd_concurrent.wait_for_request(request_id => request_id,
                                                    interval   => 2,
                                                    max_wait   => 1800,
                                                    phase      => phase,
                                                    status     => status,
                                                    dev_phase  => dev_phase,
                                                    dev_status => dev_status,
                                                    message    => message);
        commit;
        if complete then
          null; --shhh
        end if;
        if upper(dev_phase) in ('COMPLETE', 'COMPLETED') then
          jc_main.pr_print('Concurrent request completed successfully');
          for x in (select *
                      from jc_ba_ap
                     where nro_carga = p_nro_carga
                       and estado = 'T'
                       and enabled_flag = 'Y') loop
            begin
              select status
                into ap_interface.status
                from ap_invoices_interface
               where invoice_id = x.interface_id;
            exception
              when others then
                ap_interface.status := null;
                update jc_ba_ap
                   set estado      = 'E',
                       observacion = 'ERROR INESPERADO, AVISAR AL AREA DE SISTEMA'
                 where estado = 'T'
                   and id = x.ID;
            end;
            begin
              if ap_interface.status = 'PROCESSED' then
                begin
                  select invoice_id
                    into ap_invoices.invoice_id
                    from ap_invoices_all aia
                   where exists
                   (select 1
                            from ap_invoices_interface aii
                           where aia.invoice_num = aii.invoice_num
                             and aia.vendor_id = aii.vendor_id
                             and aii.source = ap_interface.source
                             and aii.group_id = ap_interface.group_id
                             and aii.invoice_id = x.interface_id);
                exception
                  when others then
                    update jc_ba_ap
                       set estado = 'E', observacion = 'FACTURA NO CREADA'
                     where estado = 'T'
                       and id = x.ID;
                end;
                update jc_ba_ap
                   set invoice_id = ap_invoices.invoice_id, estado = 'J'
                 where id = x.id;
                ------------------------------------------
                ts_invoice.invoice_id         := ap_invoices.invoice_id;
                ts_invoice.doc_sunat          := x.doc_sunat;
                ts_invoice.motivo_excepcion   := x.motivo_excepcion;
                ts_invoice.aplica_retencion   := x.aplica_retencion;
                ts_invoice.id_servicio        := x.id_servicio;
                ts_invoice.det_tipo_operacion := x.det_tipo_operacion;
                ts_invoice.igv_no_dom         := x.igv_no_dom;
                ts_invoice.clase_servicio_adq := x.clase_servicio_adq;
                ts_invoice.org_id             := '81';
                ts_invoice.created_by         := fnd_global.user_id;
                ts_invoice.creation_date      := sysdate;
                ts_invoice.last_updated_by    := fnd_global.user_id;
                ts_invoice.last_update_date   := sysdate;
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
                  (ts_invoice.invoice_id,
                   ts_invoice.doc_sunat,
                   ts_invoice.motivo_excepcion,
                   ts_invoice.aplica_retencion,
                   ts_invoice.id_servicio,
                   ts_invoice.det_tipo_operacion,
                   ts_invoice.igv_no_dom,
                   ts_invoice.clase_servicio_adq,
                   ts_invoice.org_id,
                   ts_invoice.created_by,
                   ts_invoice.creation_date,
                   ts_invoice.last_updated_by,
                   ts_invoice.last_update_date);
              else
                ------------------------------------------
                begin
                  select REJECT_LOOKUP_CODE
                    into l_REJECT_LOOKUP_CODE
                    from AP_INTERFACE_REJECTIONS
                   where parent_id = x.interface_id
                     and parent_table in ('AP_INVOICES_INTERFACE',
                          'AP_INVOICE_LINES_INTERFACE');
                  begin
                    select description
                      into l_REJECT_LOOKUP_CODE
                      from FND_LOOKUP_VALUES_VL
                     where lookup_type = 'REJECT CODE'
                       and (LOOKUP_CODE = l_REJECT_LOOKUP_CODE);
                  exception
                    when others then
                      null;
                  end;
                  update jc_ba_ap
                     set estado      = 'E',
                         observacion = 'FACTURA NO CREADA' || ' | ' ||
                                       l_REJECT_LOOKUP_CODE
                   where estado = 'T'
                     and id = x.ID;
                exception
                  when others then
                    FOR C in (select invoice_line_id
                                from AP_INVOICE_LINES_INTERFACE
                               where invoice_id = x.interface_id) loop
                      begin
                        for b in (select REJECT_LOOKUP_CODE
                                    from AP_INTERFACE_REJECTIONS
                                   where parent_id = c.invoice_line_id
                                     and parent_table in
                                         ('AP_INVOICES_INTERFACE',
                                          'AP_INVOICE_LINES_INTERFACE')) loop
                          begin
                            select description
                              into l_REJECT_LOOKUP_CODE
                              from FND_LOOKUP_VALUES_VL
                             where lookup_type = 'REJECT CODE'
                               and (LOOKUP_CODE = b.REJECT_LOOKUP_CODE);
                            update jc_ba_ap
                               set estado      = 'E',
                                   observacion = 'FACTURA NO CREADA' ||
                                                 ' | ' ||
                                                 l_REJECT_LOOKUP_CODE
                             where estado = 'T'
                               and id = x.ID;
                          exception
                            when others then
                              vc_observacion := SQLERRM;
                              update jc_ba_ap
                                 set estado      = 'E',
                                     observacion = 'FACTURA NO CREADA' ||
                                                   ' | ' || vc_observacion
                               where estado = 'T'
                                 and id = x.ID;
                          end;
                        end loop;
                      exception
                        when others then
                          vc_observacion := SQLERRM;
                          update jc_ba_ap
                             set estado      = 'E',
                                 observacion = 'FACTURA NO CREADA' || ' | ' ||
                                               vc_observacion
                           where estado = 'T'
                             and id = x.ID;
                      end;
                    end loop;
                end;
              end if;
              commit;
            end;
          end loop;
        end if;
      end if;
      for u in (select *
                  from jc_ba_ap
                 where estado = 'J'
                   and nro_carga = p_nro_carga
                   and enabled_flag = 'Y') loop
        begin
          jc_main.pr_print('antes del fu_validate');
          v_boolean := apps.jc_main.fu_validate_invoices(u.invoice_id);
          jc_main.pr_print('despues del fu_validate');
          ap_invoices.invoice_amount := 0;
          update jc_ba_ap
             set invoice_id = ap_invoices.invoice_id, estado = 'P'
           where id = u.id;
        exception
          when others then
            jc_main.pr_print('excepcion 3: ' || sqlerrm);
            errbuf := errbuf || 'Error en el proceso 3 : ' || sqlerrm;
        end;
        for k in (select *
                    from apps.ap_invoice_lines_all
                   where invoice_id = u.invoice_id) loop
          ap_invoices.invoice_amount := ap_invoices.invoice_amount +
                                        k.amount;
        end loop;
        if u.invoice_amount != ap_invoices.invoice_amount then
          begin
            update ap_invoices_all
               set invoice_amount = ap_invoices.invoice_amount
             where invoice_id = u.invoice_id;
            commit;
            v_boolean := apps.jc_main.fu_validate_invoices(u.invoice_id);
          exception
            when others then
              jc_main.pr_print('excepcion 4: ' || sqlerrm);
              errbuf := errbuf || 'Error en el proceso 4 : ' || sqlerrm;
          end;
        end if;
      end loop;
    exception
      when others then
        retcode := 2;
        errbuf  := errbuf || 'Error en el proceso 1 : ' || sqlerrm;
        apps.jc_main.pr_print('Error en el proceso 2 : ' || sqlerrm);
    end;
  end;

  procedure pr_anexo_pdf(pn_po_header_id in number, pn_file_id in number) is
    l_rowid                rowid;
    l_attached_document_id number;
    l_document_id          number;
    l_media_id             number;
    l_category_id          number;
    l_pk1_value            fnd_attached_documents.pk1_value%type := pn_po_header_id;
    l_description          fnd_documents_tl.description%type := 'Adjunto - Origen APEX';
    l_filename             varchar2(240);
    l_file_path            varchar2(240) := 'TS_AR_SUNAT_PLE_LIB_CTA16';
    l_seq_num              number;
    l_fnd_user_id          number;
    l_short_datatype_id    number;
    x_blob                 blob;
    fils                   bfile;
    blob_length            integer;
    l_entity_name          varchar2(100) := 'PO_HEADERS';
    l_category_name        varchar2(100) := 'Varios';
    l_error_pro            number := 0;
  begin
    fnd_global.apps_initialize(user_id      => 0,
                               resp_id      => 50678,
                               resp_appl_id => 201);
  
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
  
    for r in (select nombre_archivo    filename,
                     contenido_archivo archivo,
                     mimetype          file_content_type
                from jc_repositorio_documentos
               where file_id = pn_file_id) loop
    
      l_filename  := r.filename;
      l_error_pro := 0;
      -- Bajar blob a archivo
      declare
        l_file      utl_file.file_type;
        l_buffer    raw(32767);
        l_amount    binary_integer := 32767;
        l_pos       integer := 1;
        l_blob_len  integer;
        i_blob      blob;
        i_file_name varchar2(150);
      begin
      
        i_blob     := r.archivo;
        l_blob_len := dbms_lob.getlength(i_blob);
      
        --
        i_file_name := l_filename;
      
        l_file := utl_file.fopen(l_file_path, i_file_name, 'WB', 32767); -- CORREGIR, probar archivo mas grande
      
        while l_pos < l_blob_len loop
          dbms_lob.read(i_blob, l_amount, l_pos, l_buffer);
          utl_file.put_raw(l_file, l_buffer, true);
          l_pos := l_pos + l_amount;
        end loop;
      
        utl_file.fclose(l_file);
      
      exception
        when others then
          if utl_file.is_open(l_file) then
            utl_file.fclose(l_file);
          end if;
          l_error_pro := 1;
        
          dbms_output.put_line('FND_LOBS File Id Created is ' || sqlerrm);
        
      end;
      --
      if l_error_pro = 0 then
        select fnd_documents_s.nextval into l_document_id from dual;
      
        select fnd_attached_documents_s.nextval
          into l_attached_document_id
          from dual;
      
        select nvl(max(seq_num), 0) + 10
          into l_seq_num
          from fnd_attached_documents
         where pk1_value = l_pk1_value
           and entity_name = l_entity_name;
      
        select user_id
          into l_fnd_user_id
          from apps.fnd_user
         where user_name = 'SYSADMIN';
      
        select datatype_id
          into l_short_datatype_id
          from apps.fnd_document_datatypes
         where name = 'FILE'
           and language = 'ESA';
      
        select category_id
          into l_category_id
          from apps.fnd_document_categories_vl
         where user_name = l_category_name;
      
        select apps.fnd_documents_s.nextval,
               apps.fnd_attached_documents_s.nextval
          into l_document_id, l_attached_document_id
          from dual;
      
        select fnd_lobs_s.nextval into l_media_id from dual;
      
        fils := bfilename(l_file_path, l_filename);
      
        dbms_lob.fileopen(fils, dbms_lob.file_readonly);
      
        blob_length := dbms_lob.getlength(fils);
      
        dbms_lob.fileclose(fils);
      
        insert into fnd_lobs
          (file_id,
           file_name,
           file_content_type,
           upload_date,
           expiration_date,
           program_name,
           program_tag,
           file_data,
           language,
           oracle_charset,
           file_format)
        values
          (l_media_id,
           l_filename,
           r.file_content_type --'application/pdf'
          ,
           sysdate,
           null,
           'FNDATTCH',
           null,
           empty_blob(),
           'ESA',
           'UTF8',
           'binary')
        returning file_data into x_blob;
      
        dbms_lob.open(fils, dbms_lob.lob_readonly);
        dbms_lob.open(x_blob, dbms_lob.lob_readwrite);
        dbms_lob.loadfromfile(x_blob, fils, blob_length);
      
        dbms_lob.close(x_blob);
        dbms_lob.close(fils);
      
        commit;
      
        fnd_documents_pkg.insert_row(x_rowid             => l_rowid,
                                     x_document_id       => l_document_id,
                                     x_creation_date     => sysdate,
                                     x_created_by        => l_fnd_user_id,
                                     x_last_update_date  => sysdate,
                                     x_last_updated_by   => l_fnd_user_id,
                                     x_last_update_login => fnd_profile.value('LOGIN_ID'),
                                     x_datatype_id       => l_short_datatype_id,
                                     x_security_id       => null,
                                     x_publish_flag      => 'N',
                                     x_category_id       => l_category_id,
                                     x_security_type     => 4,
                                     x_usage_type        => 'S',
                                     x_language          => 'ESA',
                                     x_description       => l_description,
                                     x_file_name         => l_filename,
                                     x_media_id          => l_media_id);
      
        fnd_documents_pkg.insert_tl_row(x_document_id       => l_document_id,
                                        x_creation_date     => sysdate,
                                        x_created_by        => l_fnd_user_id,
                                        x_last_update_date  => sysdate,
                                        x_last_updated_by   => l_fnd_user_id,
                                        x_last_update_login => fnd_profile.value('LOGIN_ID'),
                                        x_language          => 'ESA',
                                        x_description       => l_description);
        commit;
      
        fnd_attached_documents_pkg.insert_row(x_rowid                    => l_rowid,
                                              x_attached_document_id     => l_attached_document_id,
                                              x_document_id              => l_document_id,
                                              x_creation_date            => sysdate,
                                              x_created_by               => l_fnd_user_id,
                                              x_last_update_date         => sysdate,
                                              x_last_updated_by          => l_fnd_user_id,
                                              x_last_update_login        => fnd_profile.value('LOGIN_ID'),
                                              x_seq_num                  => l_seq_num,
                                              x_entity_name              => l_entity_name,
                                              x_column1                  => null,
                                              x_pk1_value                => l_pk1_value,
                                              x_pk2_value                => null,
                                              x_pk3_value                => null,
                                              x_pk4_value                => null,
                                              x_pk5_value                => null,
                                              x_automatically_added_flag => 'N',
                                              x_datatype_id              => 6,
                                              x_category_id              => l_category_id,
                                              x_security_type            => 4,
                                              x_security_id              => null,
                                              x_publish_flag             => 'Y',
                                              x_language                 => 'ESA',
                                              x_description              => l_description,
                                              x_file_name                => l_filename,
                                              x_media_id                 => l_media_id);
        commit;
      end if;
      --
    end loop;
  
    commit;
  EXCEPTION
    WHEN OTHERS THEN
      apps.jc_main.pr_print('ERROR EN ADJUNTAR ANEXO');
  end;

  PROCEDURE pr_ts_formato_oc(vn_po_Header_id number, vn_email varchar2) as
    vn_request_id  number;
    l_bol_delivery BOOLEAN;
    vn_ruc         varchar2(100);
    vn_oc          varchar2(10);
    vn_user        number;
  begin
    select segment1
      into vn_oc
      from po_Headers_all
     where po_header_id = vn_po_header_id;
    select segment1
      into vn_ruc
      from po_vendors
     where vendor_id = (select vendor_id
                          from po_headers_all
                         where po_header_id = vn_po_header_id);
    select created_by
      into vn_user
      from jc_ba_main
     where po_header_id = vn_po_header_id;
    fnd_global.apps_initialize(user_id      => vn_user,
                               resp_id      => 50678,
                               resp_appl_id => 201);
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    l_bol_delivery := fnd_request.add_delivery_option(TYPE        => 'E',
                                                      p_argument1 => 'OC - ' ||
                                                                     vn_oc ||
                                                                     ' - ' ||
                                                                     vn_ruc,
                                                      p_argument2 => 'bklauer@cajaarequipa.pe',
                                                      p_argument3 => vn_email, --'lchumbilla@cajaarequipa.pe',
                                                      p_argument4 => '');
    vn_request_id  := fnd_request.submit_request(application => 'XXBOL',
                                                 program     => 'TS_PO_CMA_XFORMATO_OC',
                                                 description => 'TS Formato de Orden de Compra',
                                                 start_time  => sysdate,
                                                 sub_request => false,
                                                 argument1   => '81', --org_id,
                                                 argument2   => vn_po_Header_id,
                                                 argument3   => vn_po_Header_id,
                                                 argument4   => '',
                                                 argument5   => '',
                                                 argument6   => '',
                                                 argument7   => '');
    commit;
    apps.jc_main.pr_print('TS FORMATO CONCURRENTE  : ' || vn_request_id);
    if l_bol_delivery then
      apps.jc_main.pr_print('l_bol_delivery : true');
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      apps.jc_main.pr_print('ERROR EN TS FORMATO OC ');
  end;
  PROCEDURE pr_ts_formato_recepciones(shipment_header_id number,
                                      vn_email           varchar2) as
    receipt        varchar2(10);
    l_bol_delivery BOOLEAN;
    vn_request_id  number;
  begin
    select receipt_num
      into receipt
      from apps.rcv_shipment_headers
     where shipment_header_id = shipment_header_id;
    fnd_global.apps_initialize(user_id      => 0,
                               resp_id      => 50678,
                               resp_appl_id => 201);
    execute immediate 'ALTER SESSION SET NLS_LANGUAGE = ''LATIN AMERICAN SPANISH''';
    l_bol_delivery := fnd_request.add_delivery_option(TYPE        => 'E',
                                                      p_argument1 => 'BOletos Aereos - RECEPCIONES - ' ||
                                                                     receipt,
                                                      p_argument2 => 'bklauer@cajaarequipa.pe',
                                                      p_argument3 => vn_email, --'lchumbilla@cajaarequipa.pe',
                                                      p_argument4 => '');
    vn_request_id  := fnd_request.submit_request(application => 'XXBOL',
                                                 program     => 'TS_PO_CMA_FORM_RECEP_CONF',
                                                 description => 'TS Formato de Recepción y Conformidad',
                                                 start_time  => sysdate,
                                                 sub_request => false,
                                                 argument1   => '81', --org_id,
                                                 argument2   => '',
                                                 argument3   => receipt,
                                                 argument4   => receipt,
                                                 argument5   => '',
                                                 argument6   => '',
                                                 argument7   => '',
                                                 argument8   => '',
                                                 argument9   => '',
                                                 argument10  => '');
    commit;
    apps.jc_main.pr_print('TS FORMATO CONCURRENTE  : ' || vn_request_id);
    if l_bol_delivery then
      apps.jc_main.pr_print('l_bol_delivery : true');
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      apps.jc_main.pr_print('ERROR EN TS FORMATO OC ');
  end;
  procedure pr_concurrent_ts(errbuf out varchar2, retcode out varchar2) as
    destinatarios varchar2(200);
  begin
    for x in (select a.*
                from jc_ba_oc a
                join po_Headers_all b on a.po_header_id = b.po_Header_id
               where b.authorization_status = 'APPROVED'
                 and NOT EXISTS
               (SELECT 1
                        FROM JC_BA_TS t
                       WHERE a.po_Header_id = t.po_header_id)) loop
      select email_address
        into destinatarios
        from apps.fnd_user
       where user_id =
             (select created_by from jc_ba_cabecera where id = x.id);
      insert into jc_ba_ts values (x.id, x.po_header_id, 'P', '');
      pr_ts_formato_oc(X.po_header_id, destinatarios);
      commit;
    end loop;
    for x in (select *
                from Jc_Ba_Recepcion
               where shipment_header_id is not null
                 and (noti is null or noti = 'N')) loop
      select email_address
        into destinatarios
        from apps.fnd_user
       where user_id =
             (select created_by from jc_ba_cabecera where id = x.id);
      pr_ts_formato_recepciones(x.shipment_header_id, destinatarios);
      update jc_ba_recepcion set noti = 'Y' where id = x.id;
      commit;
    end loop;
  exception
    when others then
      errbuf  := 2;
      retcode := 'ERROR AL ENVIAR CORREO';
  end;
  procedure pr_invoice_ap(p_cabera_id number) is
    ba_ap jc_ba_ap%ROWTYPE;
    ap    number;
    CURSOR c_ba_data IS
      SELECT cab.ID AS cabecera_id,
             cab.NRO_CARGA,
             --cab.FECHA_HORA_EMISION,
             cab.NRO_TICKET,
             cab.FECHA_EMISION_TICKET,
             --cab.RESERVA,
             cab.RUC_AEREOLINEA,
             cab.NOMBRE_AEREOLINEA,
             cab.RUC_PROVEEDOR,
             cab.SOCIO_COMERCIAL,
             cab.NRO_FACTURA,
             cab.FECHA_EMISION_FACTURA,
             cab.NRO_DOCUMENTO_COBRANZA,
             cab.FECHA_DOCUMENTO_COBRANZA,
             --cab.DNI,
             --cab.PASAJES_AEREOS,
             cab.PASAJERO,
             cab.DETALLE_VIAJE,
             cab.CENTRO_COSTO,
             --cab.AGENCIA_SEDE,
             --cab.REGION_SEDE,
             cab.MOTIVO_VIAJE,
             --cab.TIPO_VUELO,
             --cab.RUTA,
             --cab.ORIGEN_TICKET,
             --cab.HORA_SALIDA,
             --cab.HORA_LLEGADA,
             cab.FECHA_SALIDA,
             --cab.FECHA_LLEGADA,
             --cab.DESTINO_TICKET,
             --cab.MILLAS,
             cab.TARIFA_NETA,
             cab.IMPUESTO,
             cab.OTROS_IMPUESTOS,
             cab.FEE,
             cab.TOTAL,
             cab.MONEDA,
             cab.CREATE_DATE,
             cab.CREATED_BY,
             cab.LAST_UPDATE_DATE,
             cab.LAST_UPDATE_BY,
             cab.ESTADO AS estado_cabecera,
             cab.OBSERVACION AS obs_cabecera,
             oc.ID AS oc_id,
             oc.PO_HEADER_INTERFACE,
             oc.PO_HEADER_ID,
             oc.DOCUMENT_TYPE_CODE,
             oc.CURRENCY_CODE,
             oc.VENDOR_ID AS vendor_id,
             oc.VENDOR_SITE_ID,
             oc.RATE,
             oc.RATE_DATE,
             oc.RATE_TYPE,
             oc.SHIP_TO_LOCATION_ID,
             oc.ESTADO AS estado_oc,
             oc.OBSERVACION AS obs_oc,
             rec.ID AS recepcion_id,
             rec.NUMERO_RECEPCION,
             rec.SHIPMENT_HEADER_ID,
             rec.HEADER_INTERFACE_ID,
             rec.GROUP_ID,
             rec.PROCESSING_STATUS_CODE,
             rec.RECEIPT_SOURCE_CODE,
             rec.TRANSACTION_TYPE,
             rec.VENDOR_ID AS rec_vendor_id,
             rec.EXPECTED_RECEIPT_DATE,
             rec.VALIDATION_FLAG,
             rec.ORG_ID,
             rec.ESTADO AS estado_rec,
             rec.OBSERVACION AS obs_rec
        FROM JC_BA_CABECERA cab
        LEFT JOIN JC_BA_OC oc ON oc.CABECERA_ID = cab.ID
        LEFT JOIN JC_BA_RECEPCION rec ON rec.CABECERA_ID = cab.ID
       where cab.id = p_cabera_id;
  begin
    for x in c_ba_data loop
      ba_ap.ID                       := jc_ba_ap_id.NEXTVAL;
      ba_ap.NRO_CARGA                := x.nro_carga;
      ba_ap.CABECERA_ID              := x.cabecera_id;
      ba_ap.RECEPCION_ID             := x.recepcion_id;
      ba_ap.SHIPMENT_HEADER_ID       := x.shipment_header_id;
      ba_ap.PO_HEADER_ID             := x.po_header_id;
      ba_ap.INTERFACE_ID             := '';
      ba_ap.INVOICE_ID               := '';
      ba_ap.INVOICE_NUM              := CASE x.numero_recepcion WHEN 1 THEN x.nro_factura WHEN 2 THEN x.nro_documento_cobranza END;
      ba_ap.INVOICE_AMOUNT           := 0;
      ba_ap.INVOICE_DATE             := CASE x.numero_recepcion WHEN 1 THEN x.fecha_emision_factura WHEN 2 THEN x.fecha_documento_cobranza END;
      ba_ap.INVOICE_TYPE_LOOKUP_CODE := CASE x.numero_recepcion WHEN 1 THEN 'STANDARD' WHEN 2 THEN 'EXPENSE REPORT' END;
      ba_ap.INVOICE_CURRENCY_CODE    := x.currency_code;
      ba_ap.VENDOR_ID                := x.vendor_id;
      ba_ap.VENDOR_SITE_ID           := x.vendor_site_id;
      ba_ap.EXCHANGE_RATE_TYPE       := '1004';
      ba_ap.EXCHANGE_DATE            := x.rate_date;
      ba_ap.DOC_SUNAT                := CASE x.numero_recepcion WHEN 1 THEN '01' WHEN 2 THEN '00' END;
      ba_ap.APLICA_RETENCION         := CASE x.numero_recepcion WHEN 1 THEN 'N' WHEN 2 THEN 'N' END;
      ba_ap.IGV_NO_DOM               := CASE x.numero_recepcion WHEN 1 THEN 'N' WHEN 2 THEN 'N' END;
      ba_ap.CLASE_SERVICIO_ADQ       := CASE x.numero_recepcion WHEN 1 THEN '4' WHEN 2 THEN '4' END;
      ba_ap.MOTIVO_EXCEPCION         := CASE x.numero_recepcion WHEN 1 THEN 'Z' WHEN 2 THEN 'Z' END;
      ba_ap.DET_TIPO_OPERACION       := CASE x.numero_recepcion WHEN 1 THEN '' WHEN 2 THEN '' END;
      ba_ap.ENABLED_FLAG             := 'Y';
      ba_ap.ESTADO                   := 'C';
      ba_ap.OBSERVACION              := '';
      ba_ap.CREATED_BY               := x.created_by;
      ba_ap.CREATION_DATE            := sysdate;
      ba_ap.LAST_UPDATE_BY           := x.last_update_by;
      ba_ap.LAST_UPDATE_DATE         := sysdate;
      begin
        SELECT CONVERSION_RATE
          INTO ba_ap.EXCHANGE_RATE
          FROM gl_daily_rates
         WHERE CONVERSION_TYPE = ba_ap.EXCHANGE_RATE_TYPE
           and conversion_Date = ba_ap.EXCHANGE_DATE
           AND FROM_CURRENCY = 'USD'
           AND TO_CURRENCY = 'PEN';
      exception
        when others then
          ba_ap.EXCHANGE_RATE := '';
          ba_ap.OBSERVACION   := 'NO SE ENCONTRÓ TIPO DE CAMBIO';
      end;
      begin
        select c.ext_bank_account_id, a.party_id
          into ba_ap.external_bank_account_id, ba_ap.party_id
          from hz_parties a
         inner join po_vendors b on a.party_id = b.party_id
         inner join iby_account_owners c on c.account_owner_party_id =
                                            a.party_id
         inner join iby_ext_bank_accounts d on c.ext_bank_account_id =
                                               d.ext_bank_account_id
         where b.vendor_id = ba_ap.vendor_id
           and d.currency_code = ba_ap.INVOICE_CURRENCY_CODE;
      exception
        when others then
          ba_ap.external_bank_account_id := '';
          ba_ap.party_id                 := '';
          ba_ap.OBSERVACION              := 'NO SE ENCONTRÓ BANK ID Y/O PARTY ID';
      end;
      begin
        select id_servicio
          into ba_ap.ID_SERVICIO
          from xxbol.ts_ap_servicios ts
         where 1 = 1
           and to_number(ts.tipo_servicio) = to_number('9999')
         order by 1;
      end;
      begin
        for i in (select rt.po_unit_price as c1,
                         rt.quantity      as c2,
                         plla.tax_name    as c3
                    from po_headers_all pha
                    join po_lines_all pla on pla.po_header_id =
                                             pha.po_header_id
                    join po_line_locations_all plla ON plla.po_line_id =
                                                       pla.po_line_id
                    join rcv_shipment_headers rsh ON pha.vendor_id =
                                                     rsh.vendor_id
                    join rcv_transactions rt ON rt.po_header_id =
                                                pha.po_header_id
                                            AND rt.shipment_header_id =
                                                rsh.shipment_header_id
                                            and rt.po_line_id =
                                                pla.po_line_id
                   WHERE pha.po_header_id = x.po_header_id
                     AND rsh.receipt_num =
                         (SELECT receipt_num
                            FROM rcv_shipment_headers
                           WHERE shipment_header_id = x.shipment_header_id)
                     AND rt.transaction_type = 'RECEIVE') loop
          ap := i.c1 * i.c2;
          if i.c3 = 'IGV GASTO USD' then
            ap := ap * 1.18;
            jc_main.pr_print('RONDA : ' || ap);
            jc_main.pr_print('valor: ' || i.c1);
          end if;
          ba_ap.invoice_amount := ba_ap.invoice_amount + ap;
          jc_main.pr_print('valor: ' || ba_ap.invoice_amount);
        end loop;
        ba_ap.invoice_amount := round(ba_ap.invoice_amount, 2);
      end;
      INSERT INTO JC_BA_AP
        (ID,
         NRO_CARGA,
         CABECERA_ID,
         RECEPCION_ID,
         SHIPMENT_HEADER_ID,
         PO_HEADER_ID,
         INTERFACE_ID,
         INVOICE_ID,
         INVOICE_NUM,
         INVOICE_AMOUNT,
         INVOICE_DATE,
         INVOICE_TYPE_LOOKUP_CODE,
         INVOICE_CURRENCY_CODE,
         PARTY_ID,
         VENDOR_ID,
         VENDOR_SITE_ID,
         EXTERNAL_BANK_ACCOUNT_ID,
         EXCHANGE_RATE_TYPE,
         EXCHANGE_DATE,
         EXCHANGE_RATE,
         DOC_SUNAT,
         APLICA_RETENCION,
         ID_SERVICIO,
         IGV_NO_DOM,
         CLASE_SERVICIO_ADQ,
         MOTIVO_EXCEPCION,
         DET_TIPO_OPERACION,
         ENABLED_FLAG,
         ESTADO,
         OBSERVACION,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATE_BY,
         LAST_UPDATE_DATE)
      VALUES
        (ba_ap.ID,
         ba_ap.NRO_CARGA,
         ba_ap.CABECERA_ID,
         ba_ap.RECEPCION_ID,
         ba_ap.SHIPMENT_HEADER_ID,
         ba_ap.PO_HEADER_ID,
         ba_ap.INTERFACE_ID,
         ba_ap.INVOICE_ID,
         ba_ap.INVOICE_NUM,
         ba_ap.INVOICE_AMOUNT,
         ba_ap.INVOICE_DATE,
         ba_ap.INVOICE_TYPE_LOOKUP_CODE,
         ba_ap.INVOICE_CURRENCY_CODE,
         ba_ap.PARTY_ID,
         ba_ap.VENDOR_ID,
         ba_ap.VENDOR_SITE_ID,
         ba_ap.EXTERNAL_BANK_ACCOUNT_ID,
         ba_ap.EXCHANGE_RATE_TYPE,
         ba_ap.EXCHANGE_DATE,
         ba_ap.EXCHANGE_RATE,
         ba_ap.DOC_SUNAT,
         ba_ap.APLICA_RETENCION,
         ba_ap.ID_SERVICIO,
         ba_ap.IGV_NO_DOM,
         ba_ap.CLASE_SERVICIO_ADQ,
         ba_ap.MOTIVO_EXCEPCION,
         ba_ap.DET_TIPO_OPERACION,
         ba_ap.ENABLED_FLAG,
         ba_ap.ESTADO,
         ba_ap.OBSERVACION,
         ba_ap.CREATED_BY,
         ba_ap.CREATION_DATE,
         ba_ap.LAST_UPDATE_BY,
         ba_ap.LAST_UPDATE_DATE);
      commit;
    end loop;
    --select receipt_num, SHIPMENT_HEADER_ID FROM APPS.rcv_shipment_headers@EBS;
  end;
  function fu_validacion(v_nro_carga number) return varchar2 is
    flex_value_meaning apps.fnd_flex_values_vl.flex_value_meaning%TYPE;
    ba_oc_lines        jc_ba_oc_lineas%ROWTYPE;
    l_error_msg        varchar2(4000);
    l_error_loc        varchar2(4000);
    msg                varchar2(4000);
    divisa             number;
    segment2           varchar2(20);
    l_ccid             number;
    /*msg      varchar2(4000);
    vv_segment2 varchar2(20);
    
    
    */
    cursor main is
      select *
        from apps.jc_ba_cabecera
       where nro_carga = v_nro_carga
         and estado in ('C', 'V', 'E')
       order by id desc, nro_carga desc;
  begin
    for x in main loop
      msg := '';
      begin
        if /*x.FECHA_HORA_EMISION is null then
                                                                                                                                                                                                  msg := msg || 'El campo FECHA Y HORA EMISION es Obligatorio ||';
                                                                                                                                                                                                elsif*/
         x.NRO_TICKET is null then
          msg := msg || 'El Campo TICKET es Obligatorio ||';
        elsif x.FECHA_EMISION_TICKET is null then
          msg := msg || 'El Campo FECHA EMISION TICKET es Obligatorio ||';
        elsif x.RUC_AEREOLINEA is null then
          msg := msg || 'El Campo RUC AEREOLINEA es Obligatorio||';
          --elsif x.RUC_PROVEEDOR is null then
          --  msg := msg || 'El Campo NRO PROVEEDOR es Obligatorio||';
        elsif x.NRO_FACTURA is null then
          msg := msg || 'El Campo NRO FACTURA es Obligatorio||';
        elsif x.FECHA_EMISION_FACTURA is null then
          msg := msg || 'El Campo FECHA EMISION FACTURA es Obligatorio||';
        elsif x.NRO_DOCUMENTO_COBRANZA is null then
          msg := msg || 'El Campo NRO DOCUMENTO COBRANZA es Obligatorio||';
        elsif x.FECHA_DOCUMENTO_COBRANZA is null then
          msg := msg || 'El Campo NRO DOCUMENTO COBRANZA es Obligatorio||';
          /*elsif x.PASAJES_AEREOS is null then
          msg := msg || 'El Campo PASAJES AEREOS es Obligatorio||';*/
        elsif x.FECHA_SALIDA is null then
          msg := msg || 'El Campo FECHA SALIDA es Obligatorio||';
        end if;
        if x.PASAJERO is null then
          msg := msg || 'El Campo PASAJERO es Obligatorio||';
        else
          /*if instr(x.pasajero, ' ') = 0 then
            msg := msg ||
                   'Debe añadir " " entre el PRIMER NOMBRE y PRIMER APELLIDO del pasajero||';
          else*/
          declare
            nombre   varchar2(100);
            apellido varchar2(100);
          begin
            nombre   := substr(x.PASAJERO, 1, instr(x.PASAJERO, ' ') - 1);
            apellido := substr(x.PASAJERO, instr(x.PASAJERO, ' ') + 1);
            if nombre is null or apellido is null then
              msg := msg ||
                     'Se requiere el PRIMER NOMBRE y PRIMER APELLIDO del pasajero||';
            end if;
          end;
          --end if;
        end if;
        if x.motivo_viaje is null then
          msg := msg || 'El Campo MOTIVO VIAJE es Obligatorio||';
        else
          for k in 1 .. 3 loop
            select articulo_linea
              into ba_oc_lines.observacion
              from apps.jc_ba_articulos
             where linea_numero = k
               and motivo_viaje = x.motivo_viaje;
            begin
              begin
                select mtli.category_id,
                       mtls.inventory_item_id,
                       mtls.expense_account
                  into ba_oc_lines.category_id,
                       ba_oc_lines.item_id,
                       ba_oc_lines.charge_account_id
                  from mtl_system_items_b mtls, mtl_item_categories mtli
                 where mtls.inventory_item_id = mtli.inventory_item_id
                   and mtli.organization_id = mtls.organization_id
                   and (segment1 || '.' || segment2 || '.' || segment3) =
                       (ba_oc_lines.observacion)
                   and mtli.organization_id = 144;
              exception
                when others then
                  return 'E03 | ' || sqlerrm;
              end;
            end;
            update jc_ba_oc_lineas
               set item_id           = ba_oc_lines.item_id,
                   category_id       = ba_oc_lines.category_id,
                   charge_account_id = ba_oc_lines.charge_account_id
             where oc_id = x.id
               and line_num = k;
          end loop;
        
          if x.motivo_viaje = 'Comisión Servicios - Personal Ag. Cobranzas' then
            segment2 := '450301200100100000';
          elsif x.motivo_viaje = 'Comisión Servicios - Personal Adm.' then
            segment2 := '450301200100200000';
          elsif x.motivo_viaje = 'Capacitación - Personal Ag. Cobranzas' then
            segment2 := '450301200200100000';
          elsif x.motivo_viaje = 'Capacitación - Personal Adm.' then
            segment2 := '450301200200200000';
          elsif x.motivo_viaje = 'Comisión Servicios - Directores' then
            segment2 := '450209000000300000';
          elsif x.motivo_viaje = 'Capacitación - Directores' then
            segment2 := '450209000000400000';
          elsif x.motivo_viaje = 'Gastos de Representación JGA' then
            segment2 := '450301120000100000';
          end if;
        end if;
        if x.tarifa_neta is null then
          msg := msg || 'El Campo TARIFA NETA es Obligatorio||';
        else
          if not regexp_like(x.tarifa_neta, '^\d+(\.\d{1,2})?$') then
            null;
            /* msg := msg ||
            'El Campo TARIFA NETA debe ser un número entero o con 1 o 2 decimales||';*/
          end if;
        end if;
        if x.IMPUESTO is not null then
          if not regexp_like(x.IMPUESTO, '^\d+(\.\d{1,2})?$') then
            null;
            /*msg := msg ||
            'El Campo IMPUESTO debe ser un número entero o con 1 o 2 decimales||';*/
          end if;
        end if;
        if x.otros_impuestos is null then
          msg := msg || 'El Campo OTROS IMPUESTOS es Obligatorio||';
        else
          null;
          /*if not regexp_like(x.otros_impuestos, '^\d+(\.\d{1,2})?$') then
            msg := msg ||
                   'El Campo OTROS IMPUESTOS debe ser un número entero o con 1 o 2 decimales||';
          end if;*/
        end if;
      
        if x.fee is null then
          msg := msg || 'El Campo FEE es Obligatorio||';
        else
          null;
          /*if not regexp_like(x.fee, '^\d+(\.\d{1,2})?$') then
            msg := msg ||
                   'El Campo FEE debe ser un número entero o con 1 o 2 decimales||';
          end if;*/
        end if;
      
        if x.MONEDA is null then
          msg := msg || 'El Campo MONEDA es Obligatorio||';
        elsif length(x.MONEDA) <> 3 or x.MONEDA not in ('USD', 'PEN') then
          msg := msg ||
                 'El Campo MONEDA debe tener 3 caracteres y ser ''USD'' o ''PEN''||';
        else
          select case
                   when x.MONEDA = 'PEN' then
                    '1'
                   when x.MONEDA = 'USD' then
                    '2'
                 end
            into divisa
            from dual;
        end if;
      
        if x.centro_costo is null then
          msg := msg || 'El Campo Centro de Costo es Obligatorio||';
        else
          begin
            select fv.flex_value_meaning
              into flex_value_meaning
              from apps.fnd_flex_values_vl fv
             where fv.value_category = 'TS_GL_CMA_CENTRO_COSTOS'
               and summary_flag = 'N'
               and flex_value_set_id = 1014847
               and upper(fv.description) = upper(x.centro_costo)
               and fv.enabled_flag = 'Y'
               and summary_flag = 'N';
          exception
            when others then
              return 'E04 | ' || sqlerrm;
          end;
          begin
            l_ccid := jc_main.get_code_combination(p_segment1          => '01',
                                                   p_segment2          => segment2,
                                                   p_segment3          => divisa,
                                                   p_segment4          => flex_value_meaning,
                                                   p_segment5          => '0',
                                                   p_segment6          => '0',
                                                   p_segment7          => '0',
                                                   p_segment8          => '0',
                                                   p_segment9          => '0',
                                                   p_set_of_books_name => 'CMA FINANCIERO', -- Usa el valor de la columna NAME
                                                   p_error_msg         => l_error_msg,
                                                   p_error_loc         => l_error_loc);
            jc_main.pr_print('COMBINACION CONTABLE');
            jc_main.pr_print('CCID: ' || l_ccid);
            if l_error_msg is not null then
            
              jc_main.pr_print('Error: ' || l_error_msg);
              msg := msg || 'ERROR COMBINACION CONTABLE : ' || '01.' ||
                     segment2 || '.' || divisa || '.' || flex_value_meaning || '||';
            end if;
          end;
        end if;
      
        if msg is null then
          update apps.jc_ba_cabecera
             set estado = 'V', observacion = null
           where id = x.id;
          update apps.jc_ba_oc
             set estado = 'V', observacion = null
           where id = x.id;
        else
          update apps.jc_ba_cabecera
             set estado = 'E', observacion = msg
           where id = x.id;
          update apps.jc_ba_oc
             set estado = 'E', observacion = msg
           where id = x.id;
        end if;
        msg := null;
      exception
        when others then
          return 'E02 | ' || sqlerrm;
      end;
    end loop;
    return 'SUCCESS';
  exception
    when others then
      return 'E01 | ' || sqlerrm;
  end;
end;
/
