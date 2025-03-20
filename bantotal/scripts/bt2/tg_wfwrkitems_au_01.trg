CREATE OR REPLACE TRIGGER TG_WFWRKITEMS_AU_01
  after UPDATE on WFWRKITEMS
  for each row

  -- *******************************************************************************************************
  -- Nombre                     : TG_WFWRKITEMS_AU_01
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2021.12.01
  -- Autor de Creación          : Henry Angel Suarez Lazarte - CAJA AREQUIPA
  -- Uso                        : Envío de alertas via correo electrónco a usuarios con creditos pendientes
  --                              de aprobacion desde Administradores en adelante.
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.11.26
  -- Autor de Modificación      : CALARCONAP
  -- Descripción de Modificación: Se quita TRIM y UPPER, se agrega RPAD
  -- Fecha de Modificación      : 2025.03.07
  -- Autor de Modificación      : ENINAH
  -- Descripción de Modificación: Se agregó validación para el envio de correos cuando se trata tipo de solicitud 1 y 4
  -- ********************************************************************************************************
DECLARE

  ln_numins number := 0;
  ln_carapr number := 0;
  lv_usrapr varchar2(50) := null;
  lv_emailu varchar2(50) := null;
  lv_numdoc varchar2(50) := null;
  lv_nomcli varchar2(50) := null;
  lv_mtoapr varchar2(50) := null;
  lv_placre varchar2(50) := null;
  lv_codmda varchar2(50) := null;
  lv_produc varchar2(50) := null;
  lv_modulo varchar2(50) := null;
  lv_mensaj varchar2(1000) := null;
  lv_motivo varchar2(1000) := null;
  lv_remite varchar2(1000) := null;
  lv_usrins varchar2(10) := null;
  ln_usrsuc number := 0;
  ld_fecins date;
  lv_horins varchar2(10) := null;
  lv_nomana varchar2(100) := null;
  lv_origin number(2) := 0;

  vi_empresa   XWF700.XWFEMPRESA%type;
  vi_sucursal  XWF700.XWFSUCURSAL%type;
  vi_modulo    XWF700.XWFMODULO%type;
  vi_moneda    xWF700.Xwfmoneda%type;
  vi_papel     XWF700.XWFPAPEL%type;
  vi_cuenta    XWF700.XWFCUENTA%type;
  vi_operacion XWF700.XWFOPERACION%type;
  vi_subope    XWF700.XWFSUBOPE%type;
  vi_tipope    XWF700.Xwftipope%type;
  --vi_aprobador VARCHAR(40);
  lv_fecapr date;
BEGIN
  --//
  if :new.wftaskcod = '11' /*and :old.wfitemusrcod <> :new.wfitemusrcod*/
     and :new.wfstscod = 'C' then
    --//
    ld_fecins := trunc(sysdate);
    lv_horins := to_char(sysdate, 'HH24:MI:ss');
    lv_remite := 'workflow@cajaarequipa.pe';
    lv_usrins := '';
    ln_carapr := 0;
    lv_usrapr := trim(:new.wfitemusrcod);
    lv_fecapr := :new.wfitemend;
    --//
    ln_numins := :new.wfinsprcid;
  
    --//
    begin
      select sng001ase, sng001ori
        into lv_usrins, lv_origin
        from sng001
       where sng001.sng001inst = ln_numins;
    exception
      when others then
        lv_usrins := '';
    end;
  
    --//
    begin
      select ubsuc
        into ln_usrsuc
        from fst046
       where ubuser = rpad(lv_usrins, 10, ' ');
    exception
      when others then
        ln_usrsuc := 0;
    end;
  
    --//
    begin
      select sng055car
        into ln_carapr
        from sng057
       where sng057usr = rpad(lv_usrins, 10, ' ');
    exception
      when others then
        ln_carapr := 0;
    end;
  
    --//
    begin
      select trim(sng001ndoc)
        into lv_numdoc
        from sng001
       where sng001inst = :new.wfinsprcid;
    exception
      when others then
        lv_numdoc := '';
    end;
  
    --//
    begin
      select ubnom into lv_nomana from fst746 where ubuser = lv_usrins;
    exception
      when others then
        lv_nomana := lv_usrins;
    end;
  
    --OBTENER LA CLAVE DEL CREDITO
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into vi_empresa,
             vi_sucursal,
             vi_modulo,
             vi_moneda,
             vi_papel,
             vi_cuenta,
             vi_operacion,
             vi_subope,
             vi_tipope
        from xwf700 x
       where x.xwfprcins = ln_numins
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    --OBTENER QUIEN APROBO LA SOLICITUD.
    --vi_aprobador:='JPLA0201';
    /*
    begin
        select TRIM(wfitemusrcod)
          into vi_aprobador
          from wfwrkitems where wfinsprcid=ln_numins and wftaskcod=11 and wfstscod='C'
           and wfitemid = (select max(wfitemid) from wfwrkitems where wfinsprcid=ln_numins and wftaskcod=11 and wfstscod='C'
           )
           AND ROWNUM=1;
    exception
       when others then
          vi_aprobador := 'APLA0203';
    end;
    */
    ----------------------
    --enviar los correos
    ----------------------
    BEGIN
      if lv_origin = 0 or lv_origin = 4 then
        pq_cr_correos_desembolso_digital.sp_cr_envioanalista(vi_empresa,
                                                             vi_modulo,
                                                             vi_sucursal,
                                                             vi_moneda,
                                                             vi_papel,
                                                             vi_cuenta,
                                                             vi_operacion,
                                                             vi_subope,
                                                             vi_tipope,
                                                             ln_numins,
                                                             lv_usrapr,
                                                             lv_fecapr);
      
        pq_cr_correos_desembolso_digital.sp_cr_envioaprobador(vi_empresa,
                                                              vi_modulo,
                                                              vi_sucursal,
                                                              vi_moneda,
                                                              vi_papel,
                                                              vi_cuenta,
                                                              vi_operacion,
                                                              vi_subope,
                                                              vi_tipope,
                                                              ln_numins,
                                                              lv_usrapr,
                                                              lv_fecapr);
      
        insert into AQPB902A
          (AQPB902ACOD,
           AQPB902AMOD,
           AQPB902ASUC,
           AQPB902AMDA,
           AQPB902APAP,
           AQPB902ACTA,
           AQPB902AOPER,
           AQPB902ASBOP,
           AQPB902ATOPE,
           AQPB902AINST,
           AQPB902AEMIS,
           AQPB902ADEST,
           AQPB902ACOPI,
           AQPB902AMESG,
           AQPB902AASUN,
           AQPB902ADDIG,
           AQPB902AERRO,
           AQPB902AERMG,
           AQPB902AUSUR,
           AQPB902AFECR,
           AQPB902AHORA)
        values
          (vi_empresa,
           vi_modulo,
           vi_sucursal,
           vi_moneda,
           vi_papel,
           vi_cuenta,
           vi_operacion,
           vi_subope,
           vi_tipope,
           ln_numins,
           '',
           '',
           'datos del trigger',
           '',
           '',
           1,
           0,
           '',
           lv_usrapr,
           TRUNC(SYSDATE),
           to_char(sysdate, 'HH24:MI:SS'));
      else
        insert into AQPB902A
          (AQPB902ACOD,
           AQPB902AMOD,
           AQPB902ASUC,
           AQPB902AMDA,
           AQPB902APAP,
           AQPB902ACTA,
           AQPB902AOPER,
           AQPB902ASBOP,
           AQPB902ATOPE,
           AQPB902AINST,
           AQPB902AEMIS,
           AQPB902ADEST,
           AQPB902ACOPI,
           AQPB902AMESG,
           AQPB902AASUN,
           AQPB902ADDIG,
           AQPB902AERRO,
           AQPB902AERMG,
           AQPB902AUSUR,
           AQPB902AFECR,
           AQPB902AHORA)
        values
          (vi_empresa,
           vi_modulo,
           vi_sucursal,
           vi_moneda,
           vi_papel,
           vi_cuenta,
           vi_operacion,
           vi_subope,
           vi_tipope,
           ln_numins,
           '',
           '',
           'Tipo de Solicitud no admitido',
           '',
           '',
           1,
           0,
           '',
           lv_usrapr,
           TRUNC(SYSDATE),
           to_char(sysdate, 'HH24:MI:SS'));
      end if;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end if;
  --//

  -------------------------------
exception
  when others then
    --lv_mensaj := sqlerrm;
    --insert into JAQL015(instancia, ingreso, mensaje, fecha, hora,  cargo) values(ln_numins, '99 ERROR', lv_mensaj, ld_fecins,  lv_horins, lv_usrapr);
    null;
END TG_WFWRKITEMS_AU_01;
/

