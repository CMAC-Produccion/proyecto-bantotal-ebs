create or replace procedure CA_ALT_CF_POR_VENCER(dias     long,
                                                 cusuario varchar2,
                                                 rpta     out sys_refcursor) is
  -- Fecha de Modificación      : 2025.06.30
  -- Autor de la Modificación   : BKLAUER
  -- Descripción de Modificación: Se modificó el procedimiento para que se 
  --                              considere a los trabajadores de RyH para las alertas.
begin
  delete ca_alt_tm_empleados;
  commit;
  insert into ca_alt_tm_empleados
    select * from ca_alt_vs_empleados;

  commit;
  insert into ca_alt_tm_empleados
    select nro_dni,
           nro_dni,
           nombre,
           'N/C',
           'N/C',
           usuario_empl || '@cajaarequipa.pe',
           0,
           cargo,
           depart,
           'X',
           usuario_empl,
           '01/01/2000',
           'N/C',
           'N/C',
           'N/C',
           'N/C',
           0,
           'N/C'
      from ca_alt_mr_ryh;

  commit;
  open rpta for
    select cf.num_carta_fianza "Nro C/F",
           cf.efi_cf Banco,
           cf.num_contrato Contrato,
           ven.VENDOR_NAME Proveedor,
           cf.comments Descripcion,
           hre.full_name Comprador,
           to_char(cf.cf_vigencia_hasta, 'YYYY.MM.DD') Vencimiento
      from ca_alt_cartas_fianza cf
      left outer join po_vendors ven
        on cf.vendor_id = ven.VENDOR_ID
      left outer join ca_alt_tm_empleados hre
        on cf.comprador = hre.employee_id
     where lower(cf.usuario) = lower(cusuario)
       and cf.cf_estado in ('G', 'R')
          --and cf.cf_vigencia_hasta >= sysdate 
       and cf.cf_vigencia_hasta <= sysdate + dias
     order by cf.cf_vigencia_hasta desc;

end CA_ALT_CF_POR_VENCER;
/
