create or replace package PQ_CR_AUTOMATIZACION_NEGOCIACION is
  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_AUTOMATIZACION_NEGOCIACION
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Activas
     -- Descripción                : Validaciones, inserciones y envio de correos para el panel Negociacion de TEA
     -- Versión                    : 1.0
     -- Fecha de Creación          : 07/10/2022
     -- Autor de Creación          : ECOLLADO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 2024.03.22 
     -- Autor de la Modificación   : ENINAH
     -- Descripción de Modificación: Se modificó el procedimiento sp_cr_validar_segmento 
     -- Fecha de Modificación      : 2024.06.12 
     -- Autor de la Modificación   : HSUREZ
     -- Descripción de Modificación: Se modificó el procedimiento de envio de correos y se agrego nuevo arbol de autorizaciones.
     -- Fecha de Modificación      : 2024.06.18 
     -- Autor de la Modificación   : ENINAH
     -- Descripción de Modificación: Se modificó el procedimiento donde se llena la tabla log aqpc595 para el reporte del panel de negociacion de tasa
     -- Fecha de Modificación      : 2024.06.24 
     -- Autor de la Modificación   : HSUAREZ
     -- Descripción de Modificación: Se agrego el procedimiento para validar si la instancia del credito vinculado, ha tenido reprogramacion o refinanciacion con beneficio CAJA.
     -- Fecha de Modificación      : 2024.12.06
     -- Autor de la Modificación   : ENINAH
     -- Descripción de Modificación: Se modificó el procedimiento para que cuando se envie correo y el primer caracter sea ; se obvie
     -- Fecha de Modificación      : 2025.02.18 
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se agregaron Excepciones y tambien dbms_lob.freetemporary en todos los envios de correos. 
    -- Fecha de Modificación      : 2025.03.14 
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modificó bloqueante cuando existe un cambio de segmento
    -- Fecha de Modificación      : 2025.03.19
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Optimización de envio de correos
    -- Fecha de Modificación      : 2025.03.28
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se agregó mas exception nulls para que no se muestre el error de status 500 cuando se envían correos
    -- Fecha de Modificación      : 2025.05.29
    -- Autor de la Modificación   : MAYCOL CHAVEZ CHUMAN
    -- Descripción de Modificación: SE MODIFICO EL PROCEDIMIENTO sp_inserta_aqpc501 PARA AGREGAR EL PARAMETRO DE
    --                              PI_NOM_PANEL
    -- Fecha de Modificación      : 2025.06.18
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modificó en todos los SP de envío de correos para que guarde en una tabla log si el proceso se ejecuta bien.
    -- Fecha de Modificación      : 2026.01.12
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se modifico el envio de correos para el rechazo, anteriormente se hacia una validacion para el pre aprobador

    
  *************************************************************************************************************/
  procedure sp_validar_calificacion_normal(instancia       in number,
                                           ln_cuenta       out number,
                                           lc_numdoc       out varchar2,
                                           ln_calificacion out number);
  procedure sp_aprobacion_monto(instancia in number, valor out VARCHAR2);

  procedure sp_insercion_datos(ubuser            in varchar,
                               fecha_cambio      in date,
                               hora_cambio       in varchar2,
                               cliente           in varchar2,
                               cta_cli           in number,
                               operacion         in number,
                               instancia         in number,
                               tea_pizarra       in number,
                               porcentaje_ajuste in number,
                               tea_propuesta     in number,
                               desc_motivo       in varchar2,
                               nomb_archivo      in varchar2,
                               contenido_archivo in varchar2,
                               ve_CTOperacion    in number, --2024.06.12 @HASL
                               ve_respuesta      out varchar2);

  procedure sp_aprobar_rechazar_solicitud(ve_instancia in number,
                                          ve_cuenta    in number,
                                          ve_operacion in number,
                                          ve_accion    in varchar,
                                          ve_opinion   in varchar2,
                                          ve_usuario   in varchar,
                                          ve_fecha     in date,
                                          ve_hora      in varchar2,
                                          ve_prcdesc   in number,
                                          ve_tasa_red  in number,
                                          vs_respuesta out varchar);
  procedure sp_aprobar_rechazar_solicitud_pre(ve_instancia in number,
                                              ve_cuenta    in number,
                                              ve_operacion in number,
                                              ve_accion    in varchar,
                                              ve_opinion   in varchar2,
                                              ve_usuario   in varchar,
                                              ve_fecha     in date,
                                              ve_hora      in varchar2,
                                              ve_prcdesc   in number,
                                              ve_tasa_red  in number,
                                              vs_respuesta out varchar);
  procedure sp_finalizar_solicitud(ve_instancia            in number,
                                   ve_cuenta               in number,
                                   ve_operacion            in number,
                                   ve_accion               in varchar,
                                   ve_opinion              in varchar2,
                                   ve_usuario              in varchar,
                                   ve_fecha                in date,
                                   ve_hora                 in varchar2,
                                   ve_tasa_propuesta       in number,
                                   ve_porcentaje_descuento in number,
                                   vs_respuesta            out varchar);

  procedure sp_obtener_clave_credito(ve_instancia     in number,
                                     ve_cuenta        in number,
                                     ve_operacion     in number,
                                     ve_sucursal      out number,
                                     ve_modulo        out number,
                                     ve_moneda        out number,
                                     ve_papel         out number,
                                     ve_suboperacion  out number,
                                     ve_tipooperacion out number);

  procedure sp_enviar_correo(ve_usuario   in varchar2,
                             ve_cuenta    in number,
                             ve_operacion in number,
                             ve_instancia in number,
                             vs_respuesta out varchar);

  procedure sp_enviar_correo_gerente(ve_usuario   in varchar2, -- RECHAZO
                                     ve_cuenta    in number,
                                     ve_operacion in number,
                                     ve_instancia in number,
                                     ve_panel     in varchar, --HAQPC721 O HAQPC517
                                     vs_respuesta out varchar);

  procedure sp_enviar_correo_aprobacion_gerente(ve_usuario   in varchar2,
                                                ve_cuenta    in number,
                                                ve_operacion in number,
                                                ve_instancia in number,
                                                vs_respuesta out varchar);

  procedure sp_enviar_correo_aprobacion_gerente_creditos(ve_usuario   in varchar2,
                                                         ve_cuenta    in number,
                                                         ve_operacion in number,
                                                         ve_instancia in number,
                                                         vs_respuesta out varchar);
  procedure sp_enviar_correo_paprobacion_gerente(ve_usuario   in varchar2, --APROBACION
                                                 ve_cuenta    in number,
                                                 ve_operacion in number,
                                                 ve_instancia in number,
                                                 vs_respuesta out varchar);

  procedure sp_enviar_correo_finalizacion(ve_usuario   in varchar2,
                                          ve_cuenta    in number,
                                          ve_operacion in number,
                                          ve_instancia in number,
                                          vs_respuesta out varchar);

  procedure sp_inserta_aqpc501(ve_usuario              in varchar2,
                               ve_cargo                in number,
                               ve_delegado             in varchar,
                               ve_fechaVigenciaInicial in date,
                               ve_fechaVigenciaFinal   in date,
                               PI_NOM_PANEL            IN VARCHAR2,
                               vs_respuesta            out varchar);

  procedure sp_actualizar_tasa(ve_instancia            in number,
                               ve_cuenta               in number,
                               ve_operacion            in number,
                               ve_usuario              in varchar2,
                               ve_fecha                in date,
                               ve_hora                 in varchar2,
                               ve_tasa_propuesta       in number,
                               ve_porcentaje_descuento in number,
                               vs_respuesta            out varchar2);
  procedure sp_validacion_regional(ve_usuario   in varchar2,
                                   ve_instancia in number,
                                   vs_respuesta out varchar2);

  procedure sp_validacion_zonal(ve_usuario   in varchar2,
                                ve_instancia in number,
                                vs_respuesta out varchar2);

  procedure sp_cr_obtener_segmento(ve_numero_documento in varchar,
                                   ve_usuario          in varchar,
                                   ve_tipodocumento    in number,
                                   ve_pais             in number,
                                   ve_instancia        in number,
                                   ve_modulo           in number,
                                   ve_segmento         out varchar2);

  procedure sp_quitar_caracteres_especiales(ve_nombre_cliente in character,
                                            vs_nombre_salida  out character);

  PROCEDURE SP_CARGAR_TASA_CUENTA(pn_emp   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_tas   in number,
                                  PN_FEC   in date,
                                  PN_SALDO in number,
                                  PN_PZO   in number,
                                  PN_USER  IN VARCHAR
                                  
                                  );
  PROCEDURE SP_RETIRAR_TASA(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number,
                            pn_fec in DATE);
  procedure SP_CR_SALDO_CAPITAL(P_N_CUENTA    IN number,
                                P_N_OPERACION IN number,
                                P_D_FECHA     IN date,
                                P_N_PGCOD     in number,
                                P_N_AOMOD     in number,
                                P_N_AOSUC     in number,
                                P_N_AOMDA     in number,
                                P_N_AOPAP     in number,
                                P_N_AOSBOP    in number,
                                P_N_AOTOPE    in number,
                                P_F_RESULTADO out number,
                                P_F_PLAZO     out number);
  PROCEDURE sp_cargar_tasa_FSD012(pn_emp   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_tas   in number,
                                  PN_FEC   in date,
                                  PN_SALDO in number,
                                  PN_PZO   in number,
                                  PN_USER  IN VARCHAR
                                  
                                  );
  PROCEDURE SP_CR_OBTENER_TASA_NEG(ve_emp  in number,
                                   ve_mod  in number,
                                   ve_suc  in number,
                                   ve_mda  in number,
                                   ve_pap  in number,
                                   ve_cta  in number,
                                   ve_ope  in number,
                                   ve_sbo  in number,
                                   ve_top  in number,
                                   vo_tsao out number,
                                   vo_tsan out number,
                                   vo_ttsa out number,
                                   vo_code out varchar,
                                   vo_msge out varchar
                                   
                                   );

  procedure sp_cr_obtener_tasa(vINST IN NUMBER, vTASA OUT NUMBER);

  procedure sp_cr_validar_segmento(ve_instancia in number,
                                   vo_segmento  out number,
                                   vo_coderror  out varchar,
                                   vo_msgerror  out varchar);

  procedure SP_VALIDATE_WITH_REGEXP(p_str   IN VARCHAR2,
                                    p_type  IN VARCHAR2,
                                    vo_rpta out varchar);
  PROCEDURE SP_OBTENER_DATOS_RIESGOS(ve_instancia                number,
                                     vo_data_score               out varchar,
                                     vo_data_probabilidad        out number,
                                     vo_data_segmentacion_riesgo out varchar,
                                     vo_cod_error                out varchar,
                                     vo_msg_error                out varchar);
  PROCEDURE SP_OBTENER_SEGMENTO_CRD(VE_INSTANCIA NUMBER,
                                    VI_PEPAIS    NUMBER,
                                    VI_PETDOC    NUMBER,
                                    VI_PENDOC    CHAR,
                                    VIO_SEGMENTO OUT NUMBER);
  PROCEDURE sp_cr_obtener_datos_reporteAQPC519(fechainicio in date,
                                               fechafinal  in date);

  procedure sp_validar_campania(instancia IN NUMBER, rpt out varchar2);

  procedure sp_validar_acceso(ve_ubuser   in varchar,
                              ve_instance in number,
                              vo_acceso   out varchar,
                              vo_cargo    out number,
                              vo_perfil   out varchar);
  PROCEDURE SP_VALIDAR_PAPROBADOR(ve_CTOperacion   IN NUMBER,
                                  ve_instance      IN NUMBER,
                                  ve_ubuser        IN VARCHAR,
                                  ve_Sucursal      IN NUMBER,
                                  vo_CargoPreApro  OUT NUMBER,
                                  vo_PerfilPreApro OUT VARCHAR,
                                  vo_UserPreApro   OUT VARCHAR,
                                  vo_Estado        OUT VARCHAR);
  PROCEDURE SP_VALIDAR_RPG_RFN(VE_INSTANCIA IN NUMBER,
                               VO_RPTA      OUT VARCHAR, -- DEVUELVE S O N, 'N' PARA BLOQUEAR.
                               VO_CODERROR  OUT VARCHAR,
                               VO_MSGERROR  OUT VARCHAR);
  procedure sp_cr_validar_cliente_credinka(ve_instancia in number,
                                           validador    out varchar2);
  procedure sp_cr_verificar_nuevo_bronce(p_cadena    IN VARCHAR2,
                                         p_resultado OUT varchar2);
end PQ_CR_AUTOMATIZACION_NEGOCIACION;
/
create or replace package body PQ_CR_AUTOMATIZACION_NEGOCIACION is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_AUTOMATIZACION_NEGOCIACION 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.10.07
  -- Autor de Creación          : ECOLLADO
  -- Descripcion                : PAQUETE PARA AUTOMATIZAR PANELES DE CAMBIO DE TASA Y DE APROBACIO DE CAMBIO DE TASA
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 2024.03.22 
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento sp_cr_validar_segmento 
  -- Fecha de Modificación      : 2024.06.12 
  -- Autor de la Modificación   : HSUREZ
  -- Descripción de Modificación: Se modificó el procedimiento de envio de correos y se agrego nuevo arbol de autorizaciones.
  -- Fecha de Modificación      : 2024.06.18 
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó el procedimiento donde se llena la tabla log aqpc595 para el reporte del panel de negociacion de tasa
  -- Fecha de Modificación      : 2025.02.19 
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se agregaron Excepciones y tambien dbms_lob.freetemporary en todos los envios de correos y se adicionó procedimiento sp_cr_validar_cliente_credinka.
  -- Fecha de Modificación      : 2025.03.14 
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó bloqueante cuando existe un cambio de segmento
  -- Fecha de Modificación      : 2025.03.19
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Optimización de envio de correos
  -- Fecha de Modificación      : 2025.03.28
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se agregó mas exception nulls para que no se muestre el error de status 500 cuando se envían correos
  -- Fecha de Modificación      : 2025.05.29
  -- Autor de la Modificación   : MAYCOL CHAVEZ CHUMAN
  -- Descripción de Modificación: SE MODIFICO EL PROCEDIMIENTO sp_inserta_aqpc501 PARA AGREGAR EL PARAMETRO DE
  --                              PI_NOM_PANEL
  -- *****************************************************************
  -- Fecha de Modificación      : 2025.06.18
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modificó en todos los SP de envío de correos para que guarde en una tabla log si el proceso se ejecuta bien.
  -- Fecha de Modificación      : 2026.01.12
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se modifico el envio de correos para el rechazo, anteriormente se hacia una validacion para el pre aprobador

  -----------------------------------------------------------------------
  procedure sp_validar_calificacion_normal(instancia       in number,
                                           ln_cuenta       out number,
                                           lc_numdoc       out varchar2,
                                           ln_calificacion out number) is
    lc_numdoc2      varchar2(12);
    lc_petdoc       fsr008.petdoc%type;
    vi_calificacion number(17, 2);
  begin
    begin
      select xwfcuenta
        into ln_cuenta
        from xwf700
       where xwfprcins = instancia
         and xwfcar3 = '1'
         and xwfsubope = (select max(xwfsubope)
                            from xwf700
                           where xwfprcins = instancia
                             and xwfcar3 = '1');
    exception
      when others then
        null;
    end;
  
    begin
      select pendoc, petdoc
        into lc_numdoc, lc_petdoc
        from fsr008 f
       where f.ctnro = ln_cuenta
         AND f.CTTFIR = 'T';
    exception
      when others then
        null;
    end;
    lc_numdoc2 := trim(lc_numdoc);
    if lc_petdoc <> 9 then
      begin
        select n_calif0
          into ln_calificacion
          from cldrcci
         where C_DOCIDE = lc_numdoc2
           and D_FECPRE = (SELECT TO_DATE(TPNRO, 'DDMMRRRR')
                             FROM FST098
                            WHERE TPCOD = 7647
                              AND TPCORR = 12);
        /*(select max(D_FECPRE)
         from cldrcci
        where C_TDOCTR = lc_numdoc2);*/
      exception
        when others then
          ln_calificacion := 100;
      end;
      if ln_calificacion = 0 then
        begin
          select c.n_calif0 + c.n_calif1 + c.n_calif2 + c.n_calif3 +
                 c.n_calif4
            into vi_calificacion
            from cldrcci c
           where C_DOCIDE = lc_numdoc2
             and D_FECPRE = (SELECT TO_DATE(TPNRO, 'DDMMRRRR')
                               FROM FST098
                              WHERE TPCOD = 7647
                                AND TPCORR = 12);
        exception
          when others then
            null;
        end;
        if vi_calificacion = 0 then
          ln_calificacion := 100;
        end if;
      end if;
    else
      begin
        select n_calif0
          into ln_calificacion
          from cldrcci
         where C_DOCTRI = lc_numdoc2
           and D_FECPRE = (SELECT TO_DATE(TPNRO, 'DDMMRRRR')
                             FROM FST098
                            WHERE TPCOD = 7647
                              AND TPCORR = 12);
        /*(select max(D_FECPRE)
         from cldrcci
        where C_DOCIDE = lc_numdoc2);*/
      
      exception
        when others then
          ln_calificacion := 100;
      end;
      if ln_calificacion = 0 then
        begin
          select c.n_calif0 + c.n_calif1 + c.n_calif2 + c.n_calif3 +
                 c.n_calif4
            into vi_calificacion
            from cldrcci c
           where C_DOCTRI = lc_numdoc2
             and D_FECPRE = (SELECT TO_DATE(TPNRO, 'DDMMRRRR')
                               FROM FST098
                              WHERE TPCOD = 7647
                                AND TPCORR = 12);
        exception
          when others then
            null;
        end;
        if vi_calificacion = 0 then
          ln_calificacion := 100;
        end if;
      end if;
    end if;
  end sp_validar_calificacion_normal;

  procedure sp_aprobacion_monto(instancia in number, valor out varchar2) is
  begin
    begin
      select case
               when count(sng120tsk) = 1 then
                'APROBADO'
               ELSE
                'NO APROBADO'
             END
        into valor
        from sng120
       where sng120ins = instancia
         and sng120tsk = 'APROBACION';
    exception
      when others then
        null;
    end;
    ---comentar esto solo por pruebas
    --valor := 'APROBADO'; --@hsuarez
  end sp_aprobacion_monto;

  procedure sp_finalizar_solicitud(ve_instancia            in number,
                                   ve_cuenta               in number,
                                   ve_operacion            in number,
                                   ve_accion               in varchar,
                                   ve_opinion              in varchar2,
                                   ve_usuario              in varchar,
                                   ve_fecha                in date,
                                   ve_hora                 in varchar2,
                                   ve_tasa_propuesta       in number,
                                   ve_porcentaje_descuento in number,
                                   vs_respuesta            out varchar) is
  
  BEGIN
  
    IF ve_accion = 'FINALIZAR' THEN
      begin
        update aqpc564
           set aqpc564est = 'F',
               aqpc564ufi = ve_usuario,
               aqpc564ffi = ve_fecha,
               aqpc564hfi = ve_hora
        
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    End If;
  
  END sp_finalizar_solicitud;

  procedure sp_aprobar_rechazar_solicitud(ve_instancia in number,
                                          ve_cuenta    in number,
                                          ve_operacion in number,
                                          ve_accion    in varchar,
                                          ve_opinion   in varchar2,
                                          ve_usuario   in varchar,
                                          ve_fecha     in date,
                                          ve_hora      in varchar2,
                                          ve_prcdesc   in number,
                                          ve_tasa_red  in number,
                                          vs_respuesta out varchar) is
  
  BEGIN
  
    IF ve_accion = 'APROBAR' then
      begin
        update aqpc564
           set aqpc564est    = 'A',
               AQPC564OPI    = ve_opinion,
               aqpc564uop    = ve_usuario,
               aqpc564fop    = ve_fecha,
               AQPC564U517   = ve_usuario,
               aqpc564hca    = ve_hora,
               aqpc564papro  = ve_prcdesc,
               aqpc564teapro = ve_tasa_red
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    ELSIF ve_accion = 'RECHAZAR' THEN
    
      begin
        update aqpc564
           set aqpc564est   = 'R',
               aqpc564eha   = 'I',
               aqpc564opire = ve_opinion,
               aqpc564uop   = ve_usuario,
               AQPC564U517  = ve_usuario,
               aqpc564fop   = ve_fecha,
               aqpc564hca   = ve_hora
        --aqpc564papro  = ve_prcdesc,
        --aqpc564teapro = ve_tasa_red  cambio 29/08/2023
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    ELSIF ve_accion = 'FINALIZAR' THEN
      begin
        update aqpc564
           set aqpc564est    = 'F',
               aqpc564opi    = ve_opinion,
               aqpc564uop    = ve_usuario,
               AQPC564U517   = ve_usuario,
               aqpc564fop    = ve_fecha,
               aqpc564hca    = ve_hora,
               aqpc564papro  = ve_prcdesc,
               aqpc564teapro = ve_tasa_red
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    End If;
  
  END sp_aprobar_rechazar_solicitud;
  procedure sp_aprobar_rechazar_solicitud_pre(ve_instancia in number,
                                              ve_cuenta    in number,
                                              ve_operacion in number,
                                              ve_accion    in varchar,
                                              ve_opinion   in varchar2,
                                              ve_usuario   in varchar,
                                              ve_fecha     in date,
                                              ve_hora      in varchar2,
                                              ve_prcdesc   in number,
                                              ve_tasa_red  in number,
                                              vs_respuesta out varchar) is
    MENSAJE VARCHAR(150);
  BEGIN
    --10999102-2069149-16885782-APROBAR-PROBADNO-SCRE0204-31-MAR-24-22:26:21-50-10
    /*insert into prueba_log
      (pgcod, msg)
    values
      (110,
       ve_instancia || '-' || ve_cuenta || '-' || ve_operacion || '-' ||
       ve_accion || '-' || ve_opinion || '-' || ve_usuario || '-' ||
       ve_fecha || '-' || ve_hora || '-' || ve_prcdesc || '-' ||
       ve_tasa_red);
    commit;*/
    IF ve_accion = 'APROBAR' then
      begin
        update aqpc564 A
           set aqpc564est     = 'G',
               A.AQPC564CMTPA = ve_opinion,
               A.AQPC564USRPA = ve_usuario,
               A.AQPC564FPAPR = ve_fecha,
               A.AQPC564HPAPR = ve_hora,
               A.AQPC564PPAPR = ve_prcdesc,
               A.AQPC564TPAPR = ve_tasa_red
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          MENSAJE := SUBSTR(SQLERRM, 1, 150);
          /*insert into prueba_log (pgcod, msg) values (50, MENSAJE);
          COMMIT;*/
          vs_respuesta := 'N';
      End;
    
    ELSIF ve_accion = 'RECHAZAR' THEN
    
      begin
        update aqpc564 a
           set aqpc564est     = 'R',
               aqpc564eha     = 'I',
               A.AQPC564CMTPA = ve_opinion,
               A.AQPC564USRPA = ve_usuario,
               A.AQPC564FPAPR = ve_fecha,
               A.AQPC564HPAPR = ve_hora
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    ELSIF ve_accion = 'FINALIZAR' THEN
      begin
        update aqpc564
           set aqpc564est    = 'F',
               aqpc564opi    = ve_opinion,
               aqpc564uop    = ve_usuario,
               AQPC564U517   = ve_usuario,
               aqpc564fop    = ve_fecha,
               aqpc564hca    = ve_hora,
               aqpc564papro  = ve_prcdesc,
               aqpc564teapro = ve_tasa_red
         where aqpc564ins = ve_instancia
           and aqpc564ope = ve_operacion
           and aqpc564cue = ve_cuenta
           and aqpc564eha = 'H';
        commit;
        vs_respuesta := 'S';
      Exception
        when others then
          vs_respuesta := 'N';
      End;
    
    End If;
  
  END sp_aprobar_rechazar_solicitud_pre;
  procedure sp_insercion_datos(ubuser            in varchar,
                               fecha_cambio      in date,
                               hora_cambio       in varchar2,
                               cliente           in varchar2,
                               cta_cli           in number,
                               operacion         in number,
                               instancia         in number,
                               tea_pizarra       in number,
                               porcentaje_ajuste in number,
                               tea_propuesta     in number,
                               desc_motivo       in varchar2,
                               nomb_archivo      in varchar2,
                               contenido_archivo in varchar2,
                               ve_CTOperacion    in number, --2024.06.12 @HASL
                               ve_respuesta      out varchar2) is
  
    analista_responsable       varchar(40);
    vp_modulo                  number;
    vp_sucursal                number;
    vp_moneda                  number;
    vp_papel                   number;
    vp_suboperacion            number;
    vp_tipooperacion           number;
    correlativo                number;
    correlativo_actualizar     number;
    cantidad_antes             number;
    segmento                   varchar2(140);
    agencia                    varchar2(40);
    destino                    varchar2(40);
    existe_garantia            number;
    garantias                  varchar2(40);
    monto_aprobado             number;
    ve_pais                    number;
    ve_tipodocumento           number;
    ve_numerodocumento         char(12);
    ve_numerodocumento_varchar varchar2(12);
    codigo_segmento            number;
    desc_motivo2               varchar2(500);
    VI_MSG                     VARCHAR2(150);
    --
    VI_ANALISTA_CRD CHAR(10);
    VI_GERENTE_CRD  CHAR(10);
  
    --VARIABLES PARA RIESGOS @hsuarez-12.07.2023
    vo_data_score               varchar(10);
    vo_data_probabilidad        number(10, 7);
    vo_data_segmentacion_riesgo varchar(10);
    vo_cod_error                varchar(5);
    vo_msg_error                varchar(150);
    --VARIABLES ADICIONALES @HSUAREZ 13.06.2024
    vo_CargoPreApro  AQPC564.AQPC564CARGO%TYPE;
    vo_PerfilPreApro AQPC564.AQPC564PRFPA%TYPE;
    vo_UserPreApro   AQPC564.AQPC564USRPA%TYPE;
    vo_Estado        AQPC564.AQPC564EST%TYPE;
  begin
  
    begin
      select xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfsubope,
             xwftipope
        into vp_modulo,
             vp_sucursal,
             vp_moneda,
             vp_papel,
             vp_suboperacion,
             vp_tipooperacion
        from xwf700
       where xwfprcins = instancia
         and xwfcuenta = cta_cli
         and xwfoperacion = operacion
         and xwfcar3 = '1'
         and xwfsubope = (select max(xwfsubope)
                            from xwf700
                           where xwfprcins = instancia
                             and xwfcuenta = cta_cli
                             and xwfoperacion = operacion
                             and xwfcar3 = '1');
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto_aprobado
        from X054023
       where xllpgcod = 1
         and xllaomod = vp_modulo
         and xllaosuc = vp_sucursal
         and xllaomda = vp_moneda
         and xllaopap = vp_papel
         and xllaocta = cta_cli
         and xllaooper = operacion
         and xllaosbop = vp_suboperacion
         and xllaotop = vp_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      analista_responsable := fn_analista_credito(vp_modulo,
                                                  vp_sucursal,
                                                  vp_moneda,
                                                  vp_papel,
                                                  cta_cli,
                                                  operacion,
                                                  vp_suboperacion,
                                                  vp_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select scnom
        into agencia
        from sng001 s
       inner join fst001
          on sucurs = SNG001Age
         and pgcod = 1
       where sng001inst = instancia;
    exception
      when others then
        null;
    END;
  
    begin
      select tonom
        into destino
        from fst004
       where modulo = vp_modulo
         and totope = vp_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      select count(*)
        into existe_garantia
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10846
         and tp1corr1 = 80
         and tp1nro1 = vp_modulo
         and tp1nro2 = vp_tipooperacion;
    exception
      when others then
        null;
    END;
  
    If existe_garantia = 0 Then
      garantias := 'No tiene Hipoteca';
    ELse
      garantias := 'Tiene Hipoteca;';
    End if;
  
    ---------
    begin
      select pepais, petdoc, pendoc
        into ve_pais, ve_tipodocumento, ve_numerodocumento
        from fsr008
       where ctnro = cta_cli
         and cttfir = 'T'
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    ve_numerodocumento_varchar := ve_numerodocumento;
    ve_numerodocumento_varchar := trim(ve_numerodocumento_varchar);
  
    begin
      select (select jaqy067ncal
                from jaqy067
               where jaqy067ccal = jaqz086calf)
        into segmento
        from jaqz086
       where jaqz086tndoc = ve_numerodocumento_varchar
         and jaqz086usr = ubuser;
    exception
      when others then
        null;
    END;
  
    begin
      select count(*)
        into cantidad_antes
        from aqpc564
       where aqpc564cue = cta_cli
         and aqpc564ope = operacion
         and aqpc564ins = instancia
         and aqpc564eha = 'H';
    exception
      when others then
        null;
    END;
  
    begin
      select count(*)
        into correlativo_actualizar
        from aqpc564
       where aqpc564cue = cta_cli
         and aqpc564ope = operacion
         and aqpc564ins = instancia
         and aqpc564eha = 'H';
    exception
      when others then
        null;
    END;
  
    If cantidad_antes != 0 then
      begin
        update aqpc564
           set aqpc564eha = 'I'
         where aqpc564cue = cta_cli
           and aqpc564ope = operacion
           and aqpc564ins = instancia;
        commit;
      exception
        when others then
          null;
      END;
    End If;
  
    begin
      select max(aqpc564cor) into correlativo from aqpc564;
    exception
      when others then
        null;
    END;
  
    if correlativo is null then
      correlativo := 0;
    end if;
    correlativo := correlativo + 1;
  
    desc_motivo2 := replace(desc_motivo, 'á', 'a');
    desc_motivo2 := replace(desc_motivo2, 'Á', 'A');
    desc_motivo2 := replace(desc_motivo2, 'é', 'e');
    desc_motivo2 := replace(desc_motivo2, 'É', 'E');
    desc_motivo2 := replace(desc_motivo2, 'í', 'i');
    desc_motivo2 := replace(desc_motivo2, 'Í', 'I');
    desc_motivo2 := replace(desc_motivo2, 'ó', 'o');
    desc_motivo2 := replace(desc_motivo2, 'Ó', 'O');
    desc_motivo2 := replace(desc_motivo2, 'ú', 'u');
    desc_motivo2 := replace(desc_motivo2, 'Ú', 'U');
    desc_motivo2 := trim(desc_motivo2);
  
    --agregando validacion adicional PARA RIESGOS -- HSUAREZ@12.07.2023
    BEGIN
      PQ_CR_AUTOMATIZACION_NEGOCIACION.SP_OBTENER_DATOS_RIESGOS(instancia,
                                                                vo_data_score,
                                                                vo_data_probabilidad,
                                                                vo_data_segmentacion_riesgo,
                                                                vo_cod_error,
                                                                vo_msg_error);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --AGREGANDO VALIDACION ADICIONAL PARA REPORTE -- HSUAREZ@12.07.2023                                                                
    BEGIN
      --IDENTIFICAR ANALISTA ASIGNADO AL CREDITO
      BEGIN
        SELECT SNG001ASE
          INTO VI_ANALISTA_CRD
          FROM SNG001
         WHERE SNG001INST = INSTANCIA;
      EXCEPTION
        WHEN OTHERS THEN
          VI_ANALISTA_CRD := '';
      END;
      --IDENTIFICAR GERENTE DE AGENCIA ASIGNADO AL CREDITO
      BEGIN
        SELECT S.SNG057USR
          INTO VI_GERENTE_CRD
          FROM SNG057 S, FST046 F
         WHERE F.UBUSER = S.SNG057USR
           AND S.SNG055CAR = 202
           AND S.SNG057AUT = 'S'
           AND F.UBSUC = vp_sucursal
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          VI_GERENTE_CRD := '';
      END;
    EXCEPTION
      WHEN OTHERS THEN
        VI_ANALISTA_CRD := '';
        VI_GERENTE_CRD  := '';
    END;
    --OBTENER CARGO Y PERFIL APROBADOR. 2024.06.13 @hsuarez
    BEGIN
    
      PQ_CR_AUTOMATIZACION_NEGOCIACION.SP_VALIDAR_PAPROBADOR(ve_CTOperacion,
                                                             instancia,
                                                             ubuser,
                                                             vp_sucursal,
                                                             vo_CargoPreApro,
                                                             vo_PerfilPreApro,
                                                             vo_UserPreApro,
                                                             vo_Estado);
      /*INSERT INTO PRUEBA_LOG
        (pgcod, MSG)
      VALUES
        (250,
         ve_CTOperacion || '-' || INSTANCIA || '-' || UBUSER || '-' ||
         VP_SUCURSAL || '-' || vo_CargoPreApro || '-' || vo_PerfilPreApro);
      COMMIT;*/
    EXCEPTION
      WHEN OTHERS THEN
        vo_CargoPreApro  := 0;
        vo_PerfilPreApro := '';
        vo_UserPreApro   := '';
        vo_Estado        := 'G';
    END;
    begin
    
      insert into AQPC564 A
        (aqpc564cor, --1
         aqpc564cue, --2
         aqpc564ope, --3
         aqpc564ins, --4
         aqpc564usu, --5
         aqpc564fec, --6
         aqpc564hor, --7
         aqpc564cli, --8
         aqpc564are, --9
         aqpc564seg, --10
         aqpc564age, --11
         aqpc564map, --12
         aqpc564tea, --13
         aqpc564paj, --14
         aqpc564tpr, --15
         aqpc564des, --16
         aqpc564gar, --17
         aqpc564mot, --18
         aqpc564arc, --19
         aqpc564est, --20
         aqpc564opi, --21
         aqpc564uop, --22
         aqpc564fop, --23
         aqpc564eha, --24
         aqpc564hca, --25
         aqpc564car, --26
         aqpc564ufi, --27
         aqpc564ffi, --28
         aqpc564hfi, --29
         --campos adicionales hsuarez@12.07.2023
         AQPC564SCO, --30
         AQPC564PDEF, --31
         AQPC564SRSGO, --32
         AQPC564ANALI, --33
         AQPC564GERAG, --34
         AQPC564U512, --35
         --2024.06.12 @HSUAREZ
         AQPC564TIPOO, --36
         A.AQPC564CARGO, --37
         A.AQPC564PRFPA --38
         --FIN 2024.06.12
         --fin campos adicionales
         
         ) --29
      VALUES
        (correlativo, --1
         cta_cli, --2
         operacion, --3
         instancia, --4
         ubuser, --5
         fecha_cambio, --6
         hora_cambio, --7
         cliente, --8
         analista_responsable, --9
         segmento, --segmento --10
         agencia, --11
         monto_aprobado, --monto aprobado--12
         tea_pizarra, --13
         porcentaje_ajuste, --14
         tea_propuesta, --15
         destino, --16
         garantias, --17
         desc_motivo2, --18
         nomb_archivo, --19
         vo_estado, --20 2024.06.13 @hsuarez
         '', --21
         '', --22
         '', --23
         'H', --24
         '', --25
         BFILENAME('DT_NEGOCIACION_TEA', nomb_archivo), --26 '', -- comentado para pruebas, descomentar 
         '', --27
         '', --28
         '', --29
         --agregando campos adicionales hsuarez@12.07.2023
         vo_data_score, --30
         vo_data_probabilidad, --31
         vo_data_segmentacion_riesgo, --32
         VI_ANALISTA_CRD, --33
         VI_GERENTE_CRD, --34
         ubuser, --35
         -- AGREGADO @HSUAREZ 2024.06.13
         ve_CTOperacion, --36 
         vo_CargoPreApro, --37
         vo_PerfilPreApro); --36
      commit;
    
      ve_respuesta := 'INSERTADO';
    EXCEPTION
      WHEN OTHERS THEN
        VI_MSG := SQLERRM;
        --insert into prueba_log(msg)values(VI_MSG);
        COMMIT;
        ve_respuesta := 'ERROR-' || VI_MSG || nomb_archivo;
      
    end;
  end sp_insercion_datos;

  procedure sp_obtener_clave_credito(ve_instancia     in number,
                                     ve_cuenta        in number,
                                     ve_operacion     in number,
                                     ve_sucursal      out number,
                                     ve_modulo        out number,
                                     ve_moneda        out number,
                                     ve_papel         out number,
                                     ve_suboperacion  out number,
                                     ve_tipooperacion out number) is
  
  BEGIN
    begin
      select xwfsucursal,
             xwfmodulo,
             xwfmoneda,
             xwfpapel,
             xwfsubope,
             xwftipope
        into ve_sucursal,
             ve_modulo,
             ve_moneda,
             ve_papel,
             ve_suboperacion,
             ve_tipooperacion
      
        from xwf700
       where xwfcuenta = ve_cuenta
         and xwfcar3 = '1'
         and xwfempresa = 1
         and xwfoperacion = ve_operacion
         and xwfprcins = ve_instancia
         and xwfsubope = (select max(xwfsubope)
                            from xwf700
                           where xwfcar3 = '1'
                             and xwfempresa = 1
                             and xwfcuenta = ve_cuenta
                             and xwfoperacion = ve_operacion
                             and xwfprcins = ve_instancia);
    exception
      when others then
        null;
    END;
  
  end sp_obtener_clave_credito;

  ----------------------------
  procedure sp_enviar_correo(ve_usuario   in varchar2,
                             ve_cuenta    in number,
                             ve_operacion in number,
                             ve_instancia in number,
                             vs_respuesta out varchar) is
  
    segundos NUMBER;
    contador NUMBER;
    --ve_usuario_in                         varchar2(10);
    descripcion_usuario_4                 varchar2(200);
    descripcion_usuario_3                 varchar2(10);
    gerente_agencia                       varchar2(40);
    gerente_creditos                      varchar2(40);
    suplente_gerente_creditos             varchar2(40);
    vi_correoa                            varchar(40);
    vi_correoa_sup                        varchar2(40);
    vi_correo_del                         varchar(40);
    descripcion_agencia                   varchar(40);
    lv_mensaje                            varchar2(4000); -- varchar2(2000) eninah 18/08/2023
    lv_delegado                           varchar2(2000);
    nombre_cliente                        varchar2(100);
    numero_documento                      number;
    lv_remitente                          varchar2(60);
    lv_DESTINATARIO                       varchar2(60);
    lv_GERENTAG                           varchar2(40);
    lv_DOMINIO                            varchar2(60);
    lv_SUCURSAL                           number;
    cod_error                             varchar2(20);
    cod_des                               varchar2(500);
    l_output                              utl_file.file_type;
    lv_nomrep                             varchar2(30) := null;
    lv_nomarc                             varchar2(250) := null;
    lv_archivos                           varchar2(4000) := null;
    vblob                                 BLOB;
    ll_mensaje                            clob;
    agencia                               varchar2(100);
    tasa_actual                           number(12, 6);
    tasa_propuesta                        number(12, 6);
    porcentaje_ajuste                     number(10, 4);
    motivo_analista                       varchar2(1000);
    fecha_gestion                         date;
    descripcion_usuario                   varchar2(200);
    descripcion_usuario_2                 varchar(10);
    analista                              varchar2(200);
    monto                                 number;
    ve_sucursal                           number;
    ve_modulo                             number;
    ve_moneda                             number;
    ve_papel                              number;
    ve_suboperacion                       number;
    ve_tipooperacion                      number;
    plazo                                 number;
    garantia                              varchar2(40);
    destino                               varchar2(40);
    tiene_garantia                        varchar2(40);
    no_tiene_garantia                     varchar2(40);
    x                                     NUMBER;
    tamanio_archivo                       number;
    len                                   number;
    vstart                                NUMBER := 1;
    bytelen                               NUMBER := 32000;
    my_vr                                 RAW(32000);
    delegado_gerente_creditos             varchar2(40);
    delegado_gerente_creditos_descripcion varchar2(200);
    segmento                              varchar2(140);
    conc_correos_del                      varchar(500);
    contador_delegados                    number;
    conc_correos_gerente_creditos         varchar2(1000);
    DestinatariosBcc                      varchar2(1000);
    lv_ANALISTA                           varchar2(200);
    lv_ASUNTO                             varchar(500);
    lv_ESTADO                             NUMBER;
    lv_COR                                NUMBER;
    lv_CC                                 varchar2(1000);
    --cantidad_finalizado                   number;
    vi_cargo          number(3);
    vi_dcargo         varchar(200);
    vi_ctipooperacion number(9);
    vi_tipooperacion  varchar(50);
    ld_pgfape         date; -- eninah 18/08/2023
    textoaprobacion   varchar2(50);
  
    cursor cursor_delegado_gerente(ve_gerente char, ve_fecha date) is
      select aqpc501del
        from aqpc501
       where aqpc501usr = rpad(ve_gerente, 10, ' ')
         and ve_fecha between AQPC501INI and AQPC501FIN; -- eninah 18/08/2023
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
    vstart            := 1;
    bytelen           := 32000;
  
    begin
      -- se agrego la fecha del sistema eninah 18/08/2023
      select pgfape into ld_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    -- OBTENER DOMINIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DOMINIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 2;
      lv_DOMINIO := lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        lv_DOMINIO := '@cajaarequipa.pe';
    END;
  
    -- OBTENER DESTINATARIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DESTINATARIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 3;
      lv_DESTINATARIO := TRIM(lv_DESTINATARIO) || lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER ANALISTA RESPONSABLE --  
    BEGIN
      SELECT SNG001ASE
        INTO lv_ANALISTA
        FROM SNG001
       WHERE SNG001INST = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT w.wfusremail
        INTO lv_ANALISTA
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(lv_ANALISTA, 30, ' ');
      lv_ANALISTA := TRIM(lv_ANALISTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER SUCURSAL --
    begin
      SELECT XWFSUCURSAL
        INTO lv_SUCURSAL
        FROM XWF700
       WHERE XWFPRCINS = ve_instancia
         AND XWFCAR3 = '1'; -- ENINAH 13/06/2025
    exception
      when others then
        null;
    end;
  
    -- OBTENER GERENTE DE AGENCIA -- 
    begin
      select SNG057USR
        INTO gerente_agencia
        from sng057 s, fst046 f, PRFU00 p
       where s.sng057usr = f.ubuser
         and sng055car = 202
         and sng057aut = 'S'
         and f.ubsuc = lv_SUCURSAL
         and p.ubuser = f.ubuser
         and prfgcod = 'GAGE01'
         and rownum = 1; -- ENINAH 13/06/2025
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      SELECT w.wfusremail
        INTO gerente_agencia
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia, 30, ' ');
      lv_GERENTAG := TRIM(gerente_agencia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER ESTADO --
    BEGIN
      SELECT COUNT(*)
        INTO lv_ESTADO
        FROM AQPC564
       WHERE AQPC564INS = ve_instancia
         AND AQPC564EST = 'R';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      select AQPC564ANALI,
             AQPC564U512,
             x.aqpc564cargo,
             s.sng055dsc,
             x.aqpc564tipoo
        into descripcion_usuario_2,
             descripcion_usuario_3,
             vi_cargo,
             vi_dcargo,
             vi_ctipooperacion
        from AQPC564 x, sng055 s
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'H'
         and aqpc564cargo = sng055car
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'H');
    exception
      when others then
        null;
    END;
  
    textoaprobacion := 'aprobarla'; --'pre-aprobarla';  se cambio a aprobación eninah 07/09/2024
  
    IF lv_ESTADO > 0 THEN
      lv_ASUNTO := 'Reconsideración de Solicitud (Instancia): ';
      Begin
        vi_dcargo       := 'Gerente de Créditos';
        textoaprobacion := 'aprobarla';
        update AQPC564
           SET AQPC564ESTR = 'SI', AQPC564EST = 'G'
         where AQPC564INS = ve_instancia
           and AQPC564EHA = 'H'
           and AQPC564COR = (select max(AQPC564COR)
                               from AQPC564
                              where AQPC564INS = ve_instancia
                                and AQPC564EHA = 'H');
        commit;
      exception
        when others then
          null;
      End;
    ELSE
      lv_ASUNTO := 'Solicitud (Instancia): ';
      Begin
        update AQPC564
           SET AQPC564ESTR = 'NO'
         where AQPC564INS = ve_instancia
           and AQPC564EHA = 'H'
           and AQPC564COR = (select max(AQPC564COR)
                               from AQPC564
                              where AQPC564INS = ve_instancia
                                and AQPC564EHA = 'H');
        commit;
      exception
        when others then
          null;
      End;
    END IF;
  
    -- OBTENER REMITENTE -- 
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    end;
  
    begin
      select sng057sup
        into suplente_gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        suplente_gerente_creditos := '';
        null;
    end;
  
    begin
      select count(*)
        into contador_delegados
        from aqpc501
       where aqpc501usr = rpad(gerente_creditos, 10, ' ')
         and ld_pgfape between AQPC501INI and AQPC501FIN; --eninah 18/08/2023
    exception
      when others then
        null;
    end;
  
    for jj in cursor_delegado_gerente(gerente_creditos, ld_pgfape) loop
      --eninah 18/08/2023
      begin
        select w.wfusremail
          into vi_correo_del
          from WFUSERS W
         WHERE W.WFUSRCOD = rpad(jj.aqpc501del, 30, ' ');
      
        vi_correo_del := trim(vi_correo_del);
        if contador_delegados = 0 then
          conc_correos_del := '';
        elsif contador_delegados = 1 then
          conc_correos_del := vi_correo_del;
        else
          conc_correos_del := vi_correo_del || '; ' || conc_correos_del;
        end if;
      
      exception
        when others then
          conc_correos_del := '';
          vi_correo_del    := '';
      end;
    end loop;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa := '';
    end;
    --suplente_gc
    begin
      select w.wfusremail
        into vi_correoa_sup
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(suplente_gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa_sup := '';
    end;
    if vi_correoa_sup is null then
      vi_correoa_sup := '';
    end if;
  
    begin
      select ubnom
        into gerente_creditos
        from fst746
       where ubuser = rpad(gerente_creditos, 10, ' ');
    exception
      when others then
        null;
    END;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    /*begin
      select scnom
        into agencia
        from fst046 fs
       inner join fst001 f
          on ubsuc = sucurs
         and f.pgcod = 1
       where ubuser = rpad(ve_usuario, 10, ' ')
         and fs.pgcod = 1;
    exception
      when others then
        null;
    END;*/
  
    -- OBTENER NOMBRE/AGENCIA -- 
    BEGIN
      SELECT SCNOM
        INTO agencia
        FROM FST001 a
       INNER JOIN XWF700 b
          ON b.XWFSUCURSAL = a.SUCURS
       WHERE B.XWFPRCINS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             aqpc564tpr,
             aqpc564paj,
             aqpc564mot,
             aqpc564fec,
             aqpc564usu,
             aqpc564des,
             aqpc564gar,
             dbms_lob.getlength(aqpc564car),
             aqpc564seg
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             motivo_analista,
             fecha_gestion,
             analista,
             destino,
             garantia,
             tamanio_archivo,
             segmento
        from aqpc564
       where aqpc564cue = ve_cuenta
         and aqpc564ope = ve_operacion
         and aqpc564ins = ve_instancia
         and aqpc564eha = 'H';
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    END;
  
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    begin
      select UBNOM
        into descripcion_usuario
        from fst746
       where ubuser = descripcion_usuario_2;
    exception
      when others then
        null;
    end;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    if conc_correos_del is not null or
       replace(conc_correos_del, ' ', '') != '' then
      lv_delegado := ' y delegado(s) informarle(s) lo siguiente: ';
    else
      lv_delegado := '';
    End if;
  
    begin
      select UBNOM
        into descripcion_usuario_4
        from fst746
       where ubuser = descripcion_usuario_3;
    exception
      when others then
        null;
    end;
    begin
      select 'Cambio de tasa ' || tp1desc
        into vi_tipooperacion
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11175
         and tp1corr1 = 1
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_ctipooperacion;
    exception
      when others then
        null;
    end;
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) ' ||
                  vi_dcargo ||
                 --gerente_creditos || lv_delegado || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">El usuario ' ||
                  descripcion_usuario_4 ||
                  ' realizó una gestión para la cuenta-operación: ' ||
                  ve_cuenta || '- ' || ve_Operacion || ', deberá ' ||
                  textoaprobacion ||
                  ' o rechazarla en Bantotal, a continuación el detalle de la gestión:</p>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center; background-color:#D1CCCB"> <b>PROPUESTA DE NEGOCIACION DE TASA EFECTIVA ANUAL </b></td> ' ||
                  '</tr>' || '<tr >' || '<td colspan = "4" ></td> ' ||
                  '</tr>' || '<tr><td>Tipo de Operación </td><td>' ||
                  vi_tipooperacion || '</td></tr>' || '<tr>' ||
                  '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' || '<tr>' ||
                  '<td colspan = "4"></td>' || '</tr>' || '<tr>' ||
                  '<td><b>Cliente</b></td>' || '<td colspan ="3">' ||
                  nombre_cliente || '</td>' || '</tr>' || '<tr>' ||
                  '<td><b>Analista Responsable</b></td>' || '<td>' ||
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' || '<tr>' || '<td><b>Segmento</b></td>' || '<td>' ||
                  segmento || '</td>' || '<td><b>Monto</b></td>' || '<td>' ||
                  monto || '</td>' || '</tr>' || '<tr>' ||
                  '<td><b>Cuenta Cliente</b></td>' || '<td>' || ve_cuenta ||
                  '</td>' || '<td><b>Solicitud (Instancia)</b></td>' ||
                  '<td>' || ve_instancia || ' </td>' || '</tr>' || '<tr>' ||
                  '<td><b>TEA Pizarra</b></td>' || '<td>' || tasa_actual ||
                  '%</td>' || '<td><b>% DE AJUSTE</b></td>' || '<td>' ||
                  porcentaje_ajuste || '% </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Plazo</b></td>' || '<td>' || plazo || ' </td>' ||
                  '<td><b>TASA PROPUESTA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Producto</b></td>' || '<td colspan="3">' ||
                  destino || ' </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Garantías</b></td>' || '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' || '<tr>' ||
                  '<td style="width:20%"><b> Motivo por el que se realizó la gestión</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '</table>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    begin
      lv_nomrep := 'DT_NEGOCIACION_TEA';
      l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
    exception
      when others then
        null;
    END;
  
    begin
      select aqpc564car
        into vblob
        from aqpc564
       where aqpc564cue = ve_cuenta
         and aqpc564ope = ve_operacion
         and aqpc564ins = ve_instancia
         and aqpc564eha = 'H';
    exception
      when others then
        null;
    END;
  
    len := tamanio_archivo;
    x   := len;
  
    If len < 32760 then
      begin
        utl_file.put_raw(l_output, vblob);
        utl_file.fflush(l_output);
      exception
        when others then
          null;
      END;
    Else
      -- write in pieces
      vstart := 1;
      While vstart < len and bytelen > 0 Loop
        begin
          dbms_lob.read(vblob, bytelen, vstart, my_vr);
        
          utl_file.put_raw(l_output, my_vr);
          utl_file.fflush(l_output);
        exception
          when others then
            null;
        END;
        -- set the start position for the next cut
        vstart := vstart + bytelen;
      
        -- set the end position if less than 32000 bytes
        x := x - bytelen;
        If x < 32000 Then
          bytelen := x;
        End If;
      End Loop;
      utl_file.fclose(l_output);
    End If;
  
    conc_correos_del := trim(conc_correos_del);
  
    if contador_delegados > 1 then
      conc_correos_del := lpad(conc_correos_del,
                               LENGTH(conc_correos_del) - 1);
    end if;
  
    -- Aqui valido si el gerente no tiene correo    --eninah 06/12/2024
    IF vi_correoa IS NULL OR TRIM(vi_correoa) = '' THEN
      -- Se agrego esta condición para cuando no haya correo de GCRE
      conc_correos_gerente_creditos := vi_correoa_sup;
    ELSE
      IF vi_correoa_sup IS NULL OR TRIM(vi_correoa_sup) = '' THEN
        conc_correos_gerente_creditos := vi_correoa;
      ELSE
        conc_correos_gerente_creditos := vi_correoa || '; ' ||
                                         vi_correoa_sup;
      END IF;
    END IF;
    /*if vi_correoa_sup is null then
      conc_correos_gerente_creditos := vi_correoa;
    else
      conc_correos_gerente_creditos := vi_correoa || '; ' || vi_correoa_sup;
    end if;*/
  
    /*select count(*)
      into cantidad_finalizado
      from aqpc564
     where aqpc564cue = ve_cuenta
       and aqpc564ope = ve_operacion
       and aqpc564ins = ve_instancia
       and aqpc564est in ('A', 'R', 'F');
    
    if cantidad_finalizado >= 1 then
      conc_correos_del := '';
    end if;*/
  
    BEGIN
      IF conc_correos_del IS NOT NULL THEN
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos) || '; ' ||
                            TRIM(conc_correos_del);
      ELSE
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------------------------------------------------------------
    BEGIN
      IF lv_GERENTAG IS NOT NULL THEN
        lv_CC := TRIM(lv_GERENTAG) || '; ' || TRIM(lv_ANALISTA);
      ELSE
        lv_CC := TRIM(lv_ANALISTA);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------------------------------------------------------------
    vs_respuesta := 'No hubo errores';
    --DestinatariosBcc := '; eninah@cajaarequipa.pe';
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => lv_DESTINATARIO, --'eninah@cajaarequipa.pe',
                                       p_DestinatariosCC   => lv_CC, -- 'hsuarez@cajaarequipa.pe',
                                       p_DestinatariosBcc  => LTRIM(DestinatariosBcc,
                                                                    ';'), --DestinatariosBcc, --- 'aangles@cajaarequipa.pe', --
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => 'Gestión para negociación de Tasa - ' ||
                                                              lv_ASUNTO ||
                                                              ve_instancia,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => lv_archivos,
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
      dbms_lob.freetemporary(ll_mensaje);
    exception
      when others then
        cod_error := '1446-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
  
    -- Se agregó modificacion cuando falla el envio de correo eninah 18/03/2025  
    if cod_error <> '000' then
      begin
        PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 1446, --¿DESCRIPCCION DE TU PROCESO¿ colocar el codigo de tu proceso númerico
                                                  P_C_ASUNTO => 'Gestión para negociación de Tasa - ' ||
                                                                lv_ASUNTO ||
                                                                ve_instancia, --ASUNTO
                                                  p_c_despar => lv_DESTINATARIO, --'eninah@cajaarequipa.pe', --PARA
                                                  p_c_descoc => lv_CC, -- 'hsuarez@cajaarequipa.pe', --CC
                                                  p_c_descco => LTRIM(DestinatariosBcc,
                                                                      ';'), --CCO
                                                  p_c_mensaj => ll_mensaje, --MENSAJE EN HTML CLOB
                                                  p_c_remite => lv_remitente, --REMITENTE
                                                  p_c_direct => lv_nomrep, --DIRECTORIO
                                                  p_c_adjunt => lv_archivos, --LISTADO DE ADJUNTOS
                                                  p_n_aux001 => 0,
                                                  p_n_aux002 => 0,
                                                  p_n_aux003 => 0,
                                                  p_n_aux004 => 0,
                                                  p_d_aux005 => ld_pgfape,
                                                  p_d_aux006 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_c_aux007 => 'Intento fallido de emvio de correo',
                                                  p_c_aux008 => '',
                                                  p_c_aux009 => '',
                                                  p_c_coderr => cod_error,
                                                  p_c_msgerr => cod_des);
        dbms_lob.freetemporary(ll_mensaje);
      exception
        when others then
          cod_error := '1986-';
          cod_des   := SUBSTR(sqlerrm, 1, 500);
      end;
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
    end if;
  
    BEGIN
      INSERT INTO AQPC852
        (AQPC852COR,
         AQPC852REM,
         AQPC852DES,
         AQPC852CC,
         AQPC852CCO,
         AQPC852ASU,
         AQPC852MEN,
         AQPC852FEC,
         AQPC852USR,
         AQPC852ERROR)
      VALUES
        (lv_COR,
         lv_remitente,
         lv_DESTINATARIO,
         lv_CC,
         DestinatariosBcc,
         lv_ASUNTO,
         ll_mensaje,
         sysdate,
         ve_usuario,
         vs_respuesta);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  end sp_enviar_correo;

  procedure sp_enviar_correo_gerente(ve_usuario   in varchar2, -- RECHAZO
                                     ve_cuenta    in number,
                                     ve_operacion in number,
                                     ve_instancia in number,
                                     ve_panel     in varchar, --HAQPC721 O HAQPC517
                                     vs_respuesta out varchar) is
  
    segundos                      NUMBER;
    contador                      NUMBER;
    ve_usuario_in                 varchar2(10);
    gerente_agencia               varchar2(40);
    gerente_creditos              varchar2(40);
    gerente_agencia_suplente      varchar2(40);
    vi_correoa                    varchar(100);
    vi_correo_del                 varchar(40);
    vi_correoa_suplente           varchar2(100);
    descripcion_agencia           varchar(40);
    lv_mensaje                    varchar2(4000); -- varchar2(2000); eninah 18/08/2023
    nombre_cliente                varchar2(100);
    numero_documento              number;
    lv_remitente                  varchar2(60);
    lv_SUCURSAL                   number;
    lv_DOMINIO                    varchar2(60);
    lv_GERENTAG                   varchar2(40);
    vi_correoa_sup                varchar2(40);
    cod_error                     varchar2(20);
    cod_des                       varchar2(500);
    l_output                      utl_file.file_type;
    lv_nomrep                     varchar2(30) := null;
    lv_nomarc                     varchar2(250) := null;
    lv_archivos                   varchar2(4000) := null;
    vblob                         BLOB;
    ll_mensaje                    clob;
    agencia                       varchar2(100);
    tasa_actual                   number(12, 6);
    tasa_propuesta                number(12, 6);
    porcentaje_ajuste             number(10, 4);
    analista                      varchar2(100);
    motivo                        varchar2(1000);
    fecha_gestion                 date;
    descripcion_usuario           varchar2(100);
    descripcion_usuario_2         varchar2(10);
    descripcion_usuario_3         varchar2(30);
    descripcion_usuario_4         varchar2(100);
    ve_sucursal                   number;
    ve_modulo                     number;
    ve_moneda                     number;
    ve_papel                      number;
    ve_suboperacion               number;
    ve_tipooperacion              number;
    monto                         number;
    plazo                         number;
    destino                       varchar2(40);
    garantia                      varchar2(40);
    tiene_garantia                varchar2(40);
    no_tiene_garantia             varchar2(40);
    motivo_analista               varchar2(1000);
    ve_usuario_gerente            varchar2(100);
    segmento                      varchar2(140);
    conc_gerente_agencia          varchar2(1000);
    conc_correos_gerente_creditos varchar2(1000);
    DestinatariosBcc              varchar2(1000);
    suplente_gerente_creditos     varchar2(40);
    contador_delegados            number;
    conc_correos_del              varchar(500);
    lv_delegado                   varchar2(2000);
    lv_ANALISTA                   varchar2(200);
    lv_COR                        NUMBER;
    lv_DES                        varchar2(1000);
    lv_ASUNTO                     varchar(500);
    --Datos para el tipo de operacion
    vi_tipooperacion     varchar(150);
    vi_ctipooperacion    number(10);
    motivopapr           varchar(150);
    vi_rechazador        varchar(50);
    vi_motivo_rechazador varchar(150);
  
    --cantidad_finalizado           number;
  
    lv_DESTINATARIO varchar2(60);
    lv_pgfape       date; -- eninah 18/08/2023
  
    cursor cursor_delegado_gerente(ve_gerente char, ve_fecha date) is
      select aqpc501del
        from aqpc501
       where aqpc501usr = rpad(ve_gerente, 10, ' ')
         and ve_fecha between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
  
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
  
    begin
      -- se agrego eninah 18/08/2023
      select pgfape into lv_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    -- OBTENER DOMINIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DOMINIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 2;
      lv_DOMINIO := lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        lv_DOMINIO := '@cajaarequipa.pe';
    END;
  
    -- OBTENER DESTINATARIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DESTINATARIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 3;
      lv_DESTINATARIO := TRIM(lv_DESTINATARIO) || lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER ANALISTA RESPONSABLE -- 
    BEGIN
      SELECT SNG001ASE
        INTO lv_ANALISTA
        FROM SNG001
       WHERE SNG001INST = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT w.wfusremail
        INTO lv_ANALISTA
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(lv_ANALISTA, 30, ' ');
      lv_ANALISTA := TRIM(lv_ANALISTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER SUCURSAL --
    begin
      SELECT XWFSUCURSAL
        INTO lv_SUCURSAL
        FROM XWF700
       WHERE XWFPRCINS = ve_instancia
         AND XWFCAR3 = '1'; -- ENINAH 13/06/2025
    exception
      when others then
        null;
    end;
  
    -- OBTENER GERENTE DE AGENCIA -- 
    begin
      select SNG057USR
        INTO gerente_agencia
        from sng057 s, fst046 f, PRFU00 p
       where s.sng057usr = f.ubuser
         and sng055car = 202
         and sng057aut = 'S'
         and f.ubsuc = lv_SUCURSAL
         and p.ubuser = f.ubuser
         and prfgcod = 'GAGE01'
         and rownum = 1; -- ENINAH 13/06/2025
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      SELECT w.wfusremail
        INTO gerente_agencia
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia, 30, ' ');
      lv_GERENTAG := TRIM(gerente_agencia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER REMITENTE -- 
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into contador_delegados
        from aqpc501
       where aqpc501usr = rpad(gerente_creditos, 10, ' ')
         and lv_pgfape between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
    exception
      when others then
        null;
    end;
  
    for jj in cursor_delegado_gerente(gerente_creditos, lv_pgfape) loop
      begin
        select w.wfusremail
          into vi_correo_del
          from WFUSERS W
         WHERE W.WFUSRCOD = rpad(jj.aqpc501del, 30, ' ');
      
        vi_correo_del := trim(vi_correo_del);
        if contador_delegados = 0 then
          conc_correos_del := '';
        elsif contador_delegados = 1 then
          conc_correos_del := vi_correo_del;
        else
          conc_correos_del := vi_correo_del || '; ' || conc_correos_del;
        end if;
      
      exception
        when others then
          conc_correos_del := '';
          vi_correo_del    := '';
      end;
    end loop;
  
    begin
      select sng057sup
        into suplente_gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        suplente_gerente_creditos := '';
        null;
    end;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select ubnom
        into ve_usuario_gerente
        from fst746
       where ubuser = rpad(ve_usuario, 10, ' ');
    exception
      when others then
        null;
    END;
  
    --suplente_gc
    begin
      select w.wfusremail
        into vi_correoa_sup
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(suplente_gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa_sup := '';
    end;
    if vi_correoa_sup is null then
      vi_correoa_sup := '';
    end if;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             AQPC564TEAPRO, --aqpc564tpr, 08/09/2023 eninah
             AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
             aqpc564usu,
             aqpc564opire,
             aqpc564fec,
             aqpc564des,
             aqpc564gar,
             aqpc564mot,
             AQPC564CMTPA,
             aqpc564seg
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             analista,
             motivo,
             fecha_gestion,
             destino,
             garantia,
             motivo_analista,
             motivopapr,
             segmento
        from (select aqpc564cli,
                     aqpc564arc,
                     aqpc564tea,
                     AQPC564TEAPRO, --aqpc564tpr, 11/09/2023 eninah
                     AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
                     aqpc564usu,
                     aqpc564opire,
                     aqpc564fec,
                     aqpc564des,
                     aqpc564gar,
                     aqpc564mot,
                     AQPC564CMTPA,
                     aqpc564seg
                from aqpc564
               where aqpc564cue = ve_cuenta
                 and aqpc564ope = ve_operacion
                 and aqpc564ins = ve_instancia
              --and aqpc564est = 'A'
               order by aqpc564cor desc)
       where rownum = 1;
    exception
      when others then
        null;
    END;
    --Aqui se envia correo al Gerente de crédito
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa := '';
    end;
  
    begin
      select sng057sup
        into gerente_agencia_suplente
        from sng057
       where sng057usr = rpad(analista, 10, ' ');
    exception
      when others then
        null;
    end;
  
    begin
      select w.wfusremail
        into vi_correoa_suplente
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia_suplente, 30, ' ');
    exception
      when others then
        vi_correoa_suplente := '';
    end;
  
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    -- OBTENER NOMBRE/AGENCIA -- 
    BEGIN
      SELECT SCNOM
        INTO agencia
        FROM FST001 a
       INNER JOIN XWF700 b
          ON b.XWFSUCURSAL = a.SUCURS
       WHERE B.XWFPRCINS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    if conc_correos_del is not null or
       replace(conc_correos_del, ' ', '') != '' then
      lv_delegado := ' y delegado(s) informarle(s) lo siguiente: ';
    else
      lv_delegado := '';
    End if;
  
    begin
      select AQPC564ANALI, AQPC564U512, x.aqpc564tipoo
        into descripcion_usuario_2,
             descripcion_usuario_3,
             vi_ctipooperacion
        from AQPC564 x
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'I'
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'I')
         and AQPC564EST = 'R';
    exception
      when others then
        null;
    END;
  
    begin
      --descripcion_usuario := '';
      select UBNOM
        into descripcion_usuario
        from fst746
       where ubuser = descripcion_usuario_2;
    exception
      when others then
        null;
    end;
  
    begin
      select UBNOM
        into descripcion_usuario_4
        from fst746
       where ubuser = RPAD(descripcion_usuario_3, 10, ' ');
    exception
      when others then
        null;
    end;
    --TIPO DE OPERACION
    begin
      select 'Cambio de tasa ' || tp1desc
        into vi_tipooperacion
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11175
         and tp1corr1 = 1
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_ctipooperacion;
    exception
      when others then
        null;
    end;
    ---
    -- AGREGANDO CONDICION PARA VALIDAR SI ES RECHAZO DE PRE-APROBACION O APROBACION
    begin
      --vi_motivo_rechazador := '';
      -- Se está modificando esta parte para que solo sea para gerencia de creditos ya que no existe 
      -- el panel de preaprobador eninah 09/01/206      
      --IF trim(ve_panel) = 'HAQPC721' THEN
      --vi_rechazador        := 'Jefe Zonal/Gerente Regional';
      --vi_motivo_rechazador := motivopapr;
      --ELSE
      vi_rechazador        := 'Gerencia de Créditos';
      vi_motivo_rechazador := motivo;
      --END IF;
    exception
      -- Se agregó exception eninah 18/02/2025
      when others then
        null;
    end;
    ---------------------------
    --eninah 17/02/2025--------
    begin
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    end;
    ------------------------------------
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) : ' ||
                  descripcion_usuario_4 || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">' ||
                  vi_rechazador ||
                  ' rechazó su gestión para la cuenta-operación ' ||
                  ve_cuenta || '- ' || ve_Operacion ||
                  ', a continuación el detalle de la gestión:</p>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center; background-color:#D1CCCB;"> <b>PROPUESTA DE NEGOCIACION DE TASA EFECTIVA ANUAL - ' ||
                  vi_tipooperacion || '</b> </td> ' || '</tr>' || '<tr>' ||
                  '<td colspan = "4"></td> ' || '</tr>' ||
                  '<tr><td>Tipo de Operación </td><td>' || vi_tipooperacion ||
                  '</td></tr>' || '<tr>' || '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "4"></td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cliente</b></td>' ||
                  '<td colspan ="3">' || nombre_cliente || '</td>' ||
                  '</tr>' || '<tr>' ||
                  '<td><b>Analista Responsable</b></td>' || '<td>' ||
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td><b>Segmento</b></td>' || '<td>' ||
                  segmento || '</td>' || '<td><b>Monto</b></td>' || '<td>' ||
                  monto || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cuenta Cliente</b></td>' || '<td>' ||
                  ve_cuenta || '</td>' ||
                  '<td><b>Solicitud(Instancia)</b></td>' || '<td>' ||
                  ve_instancia || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>TEA Pizarra</b></td>' || '<td>' ||
                  tasa_actual || '%</td>' || '<td><b>% DE AJUSTE</b></td>' ||
                  '<td>' || porcentaje_ajuste || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Plazo</b></td>' || '<td>' || plazo ||
                  ' </td>' || '<td><b>TASA APROBADA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Producto</b></td>' ||
                  '<td colspan="3">' || destino || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Garantías</b></td>' ||
                  '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' ||
                 
                  '<tr>' ||
                  '<td style="width:20%"><b> Motivo del usuario que realizó la gestión</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td style="width:20%">' ||
                  '      <b>Motivo para rechazar la gestión</b>' || '</td>' ||
                  '<td colspan="3">' || vi_motivo_rechazador || ' </td>' ||
                  '</tr>';
  
    lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  
    lv_mensaje := '</table>';
  
    begin
      lv_nomrep := 'DT_NEGOCIACION_TEA';
      l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
    exception
      when others then
        null;
    END;
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
    -- Aqui valido si el gerente no tiene correo    --eninah 06/12/2024
    IF vi_correoa IS NULL OR TRIM(vi_correoa) = '' THEN
      -- Se agrego esta condición para cuando no haya correo de GCRE
      conc_correos_gerente_creditos := vi_correoa_sup;
    ELSE
      IF vi_correoa_sup IS NULL OR TRIM(vi_correoa_sup) = '' THEN
        conc_correos_gerente_creditos := vi_correoa;
      ELSE
        conc_correos_gerente_creditos := vi_correoa || '; ' ||
                                         vi_correoa_sup;
      END IF;
    END IF;
  
    conc_correos_del := trim(conc_correos_del);
  
    if contador_delegados > 1 then
      conc_correos_del := lpad(conc_correos_del,
                               LENGTH(conc_correos_del) - 1);
    end if;
  
    BEGIN
      IF conc_correos_del IS NOT NULL THEN
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos) || '; ' ||
                            TRIM(conc_correos_del);
      ELSE
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------------------------------------------------------------
    BEGIN
      IF lv_GERENTAG IS NOT NULL THEN
        lv_DES := TRIM(lv_GERENTAG) || '; ' || TRIM(lv_ANALISTA);
      ELSE
        lv_DES := TRIM(lv_ANALISTA);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      lv_ASUNTO := 'Rechazo de Gestión para cambio de Tasa - Solicitud(Instancia): ';
    END;
    --------------------------------------------------------------------------
    vs_respuesta := 'No hubo errores';
  
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => lv_DES, --'eninah@cajaarequipa.pe', 
                                       p_DestinatariosCC   => lv_DESTINATARIO, --'hsuarez@cajaarequipa.pe', 
                                       p_DestinatariosBcc  => LTRIM(DestinatariosBcc,
                                                                    ';'), -- 'aangles@cajaarequipa.pe', -- 
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => lv_ASUNTO ||
                                                              ve_instancia,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => '',
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
      dbms_lob.freetemporary(ll_mensaje);
    exception
      when others then
        cod_error := '2285-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
    -- Se agregó modificacion cuando falla el envio de correo eninah 18/03/2025  
    if cod_error <> '000' then
      begin
        PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 1446, --¿DESCRIPCCION DE TU PROCESO¿ colocar el codigo de tu proceso númerico
                                                  P_C_ASUNTO => lv_ASUNTO ||
                                                                ve_instancia, --ASUNTO
                                                  p_c_despar => lv_DES, --'eninah@cajaarequipa.pe', --PARA
                                                  p_c_descoc => lv_DESTINATARIO, -- 'hsuarez@cajaarequipa.pe', --CC
                                                  p_c_descco => LTRIM(DestinatariosBcc,
                                                                      ';'), --CCO
                                                  p_c_mensaj => ll_mensaje, --MENSAJE EN HTML CLOB
                                                  p_c_remite => lv_remitente, --REMITENTE
                                                  p_c_direct => lv_nomrep, --DIRECTORIO
                                                  p_c_adjunt => lv_archivos, --LISTADO DE ADJUNTOS
                                                  p_n_aux001 => 0,
                                                  p_n_aux002 => 0,
                                                  p_n_aux003 => 0,
                                                  p_n_aux004 => 0,
                                                  p_d_aux005 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_d_aux006 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_c_aux007 => '',
                                                  p_c_aux008 => 'Intento fallido de envio de correo',
                                                  p_c_aux009 => '',
                                                  p_c_coderr => cod_error,
                                                  p_c_msgerr => cod_des);
        dbms_lob.freetemporary(ll_mensaje);
      exception
        when others then
          null;
      end;
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
    end if;
  
    BEGIN
      INSERT INTO AQPC852
        (AQPC852COR,
         AQPC852REM,
         AQPC852DES,
         AQPC852CC,
         AQPC852CCO,
         AQPC852ASU,
         AQPC852MEN,
         AQPC852FEC,
         AQPC852USR,
         AQPC852ERROR)
      VALUES
        (lv_COR,
         lv_remitente,
         lv_DES,
         lv_DESTINATARIO,
         DestinatariosBcc,
         lv_ASUNTO,
         ll_mensaje,
         sysdate,
         ve_usuario,
         vs_respuesta);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end sp_enviar_correo_gerente;
  ---------------------------------------------------------------------------------------------------------

  procedure sp_enviar_correo_aprobacion_gerente(ve_usuario   in varchar2, --APROBACION
                                                ve_cuenta    in number,
                                                ve_operacion in number,
                                                ve_instancia in number,
                                                vs_respuesta out varchar) is
  
    segundos                      NUMBER;
    contador                      NUMBER;
    descripcion_usuario_3         varchar2(200);
    gerente_agencia_nuevo         varchar2(10);
    gerente_agencia               varchar2(40);
    gerente_agencia_suplente      varchar2(40);
    vi_correoa_suplente           varchar(100);
    vi_correoa                    varchar(100);
    vi_correoa_aprobador          varchar2(600);
    descripcion_agencia           varchar(40);
    lv_mensaje                    varchar2(4000); -- varchar2(2000); eninah 18/08/2023
    nombre_cliente                varchar2(100);
    numero_documento              number;
    lv_remitente                  varchar2(60);
    lv_DOMINIO                    varchar2(60);
    lv_GERENTAG                   varchar2(40);
    lv_SUCURSAL                   number;
    vi_correoa_sup                varchar2(40);
    cod_error                     varchar2(20);
    cod_des                       varchar2(500);
    l_output                      utl_file.file_type;
    lv_nomrep                     varchar2(30) := null;
    lv_nomarc                     varchar2(250) := null;
    lv_archivos                   varchar2(4000) := null;
    vblob                         BLOB;
    ll_mensaje                    clob;
    agencia                       varchar2(100);
    tasa_actual                   number(12, 6);
    tasa_propuesta                number(12, 6);
    porcentaje_ajuste             number(10, 4);
    analista                      varchar2(100);
    motivo                        varchar2(1000);
    fecha_gestion                 date;
    descripcion_usuario           varchar2(1000);
    descripcion_usuario_2         varchar2(10);
    monto                         number;
    ve_sucursal                   number;
    ve_modulo                     number;
    ve_moneda                     number;
    ve_papel                      number;
    ve_suboperacion               number;
    ve_tipooperacion              number;
    plazo                         number;
    destino                       varchar2(400);
    garantia                      varchar2(40);
    tiene_garantia                varchar2(40);
    no_tiene_garantia             varchar2(40);
    motivo_analista               varchar2(400);
    descripcion_usuario_gerente   varchar2(400);
    asesor_instancia              varchar2(50);
    segmento                      varchar2(140);
    conc_gerente_agencia          varchar2(1000);
    usuario_aprobador             varchar2(100);
    conc_correos_gerente_creditos varchar2(1000);
    DestinatariosBcc              varchar2(1000);
    cantidad_finalizado           number;
    gerente_creditos              varchar2(40);
    vi_correo_del                 varchar(40);
    contador_delegados            number;
    conc_correos_del              varchar(500);
    lv_delegado                   varchar2(2000);
    lv_DESTINATARIO               varchar2(60);
    lv_ANALISTA                   varchar2(200);
    lv_COR                        NUMBER;
    lv_DES                        varchar2(1000);
    lv_ASUNTO                     varchar(500);
    suplente_gerente_creditos     varchar2(40);
    lv_pgfape                     date; --eninah 18/08/2023
    vi_ctipooperacion             number(9);
    vi_tipooperacion              varchar(50);
    vi_pre_aprobador              char(10);
    vi_cod_cargopapr              number(3);
    vi_cmt_papr                   varchar(500);
    descripcion_pre_aprobador     varchar(50);
  
    cursor cursor_delegado_gerente(ve_gerente char, ve_fecha date) is
      select aqpc501del
        from aqpc501
       where aqpc501usr = rpad(ve_gerente, 10, ' ')
         and ve_fecha between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
  
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
  
    begin
      -- se agregó eninah 18/08/2023
      select pgfape into lv_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    -- OBTENER DOMINIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DOMINIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 2;
      lv_DOMINIO := lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        lv_DOMINIO := '@cajaarequipa.pe';
    END;
  
    -- OBTENER DESTINATARIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DESTINATARIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 3;
      lv_DESTINATARIO := TRIM(lv_DESTINATARIO) || lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER ANALISTA RESPONSABLE -- 
    BEGIN
      SELECT SNG001ASE
        INTO lv_ANALISTA
        FROM SNG001
       WHERE SNG001INST = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT w.wfusremail
        INTO lv_ANALISTA
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(lv_ANALISTA, 30, ' ');
      lv_ANALISTA := TRIM(lv_ANALISTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER SUCURSAL --
    begin
      SELECT XWFSUCURSAL
        INTO lv_SUCURSAL
        FROM XWF700
       WHERE XWFPRCINS = ve_instancia;
    exception
      when others then
        null;
    end;
  
    -- OBTENER GERENTE DE AGENCIA -- 
    begin
      select SNG057USR
        INTO gerente_agencia
        from sng057 s, fst046 f, PRFU00 p
       where s.sng057usr = f.ubuser
         and sng055car = 202
         and sng057aut = 'S'
         and f.ubsuc = lv_SUCURSAL
         and p.ubuser = f.ubuser
         and prfgcod = 'GAGE01';
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      SELECT w.wfusremail
        INTO gerente_agencia
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia, 30, ' ');
      lv_GERENTAG := TRIM(gerente_agencia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER REMITENTE -- 
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    end;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    begin
      select count(*)
        into contador_delegados
        from aqpc501
       where aqpc501usr = rpad(gerente_creditos, 10, ' ')
         and lv_pgfape between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
    exception
      when others then
        null;
    end;
  
    for jj in cursor_delegado_gerente(gerente_creditos, lv_pgfape) loop
      -- eninah 18/08/2023
      begin
        select w.wfusremail
          into vi_correo_del
          from WFUSERS W
         WHERE W.WFUSRCOD = rpad(jj.aqpc501del, 30, ' ');
      
        vi_correo_del := trim(vi_correo_del);
        if contador_delegados = 0 then
          conc_correos_del := '';
        elsif contador_delegados = 1 then
          conc_correos_del := vi_correo_del;
        else
          conc_correos_del := vi_correo_del || '; ' || conc_correos_del;
        end if;
      exception
        when others then
          conc_correos_del := '';
          vi_correo_del    := '';
      end;
    end loop;
  
    begin
      select sng057sup
        into suplente_gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        suplente_gerente_creditos := '';
        null;
    end;
  
    /*begin
      select scnom
        into agencia
        from fst046 fs
       inner join fst001 f
          on ubsuc = sucurs
         and f.pgcod = 1
       where ubuser = rpad(ve_usuario, 10, ' ')
         and fs.pgcod = 1;
    exception
      when others then
        null;
    END;*/
  
    -- OBTENER NOMBRE/AGENCIA -- 
    BEGIN
      SELECT SCNOM
        INTO agencia
        FROM FST001 a
       INNER JOIN XWF700 b
          ON b.XWFSUCURSAL = a.SUCURS
       WHERE B.XWFPRCINS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --suplente_gc
    begin
      select w.wfusremail
        into vi_correoa_sup
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(suplente_gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa_sup := '';
    end;
    if vi_correoa_sup is null then
      vi_correoa_sup := '';
    end if;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             AQPC564TEAPRO, --aqpc564tpr, 08/09/2023 eninah
             AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
             aqpc564usu,
             aqpc564opi,
             aqpc564fec,
             aqpc564des,
             aqpc564gar,
             aqpc564mot,
             aqpc564seg,
             aqpc564uop
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             analista,
             motivo,
             fecha_gestion,
             destino,
             garantia,
             motivo_analista,
             segmento,
             usuario_aprobador
        from (select aqpc564cli,
                     aqpc564arc,
                     aqpc564tea,
                     AQPC564TEAPRO, --aqpc564tpr, 11/09/2023 eninah
                     AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
                     aqpc564usu,
                     aqpc564opi,
                     aqpc564fec,
                     aqpc564des,
                     aqpc564gar,
                     aqpc564mot,
                     aqpc564seg,
                     aqpc564uop
                from aqpc564
               where aqpc564cue = ve_cuenta
                 and aqpc564ope = ve_operacion
                 and aqpc564ins = ve_instancia
                 and aqpc564est = 'A'
               order by aqpc564cor desc)
       where rownum = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select sng001ase
        into asesor_instancia
        from sng001
       where sng001inst = ve_instancia;
    exception
      when others then
        null;
    END;
  
    /*begin
      select sng057usr
        into gerente_agencia
        from (select (select ubsuc
                        from fst046
                       where ubuser = sng057usr
                         and pgcod = 1) as sucursal,
                     s.*
                from sng057 s
               where sng055car = 202
                 and sng055emp = 1)
       where sucursal = (select ubsuc
                           from fst046
                          where ubuser = rpad(asesor_instancia, 10, ' ')
                            AND PGCOD = 1);
    exception
      when others then
        null;
    END;*/
  
    begin
      select sng057sup
        into gerente_agencia_suplente
        from sng057
       where sng057usr = rpad(gerente_agencia, 10, ' ');
    exception
      when others then
        null;
    end;
  
    begin
      select w.wfusremail
        into vi_correoa_aprobador
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(usuario_aprobador, 30, ' ');
    exception
      when others then
        vi_correoa_aprobador := '';
    end;
  
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa := '';
    end;
  
    begin
      select w.wfusremail
        into vi_correoa_suplente
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia_suplente, 30, ' ');
    exception
      when others then
        vi_correoa_suplente := '';
    end;
  
    begin
      select ubnom
        into descripcion_usuario_gerente
        from fst746
       where ubuser = rpad(gerente_agencia, 10, ' ');
    exception
      when others then
        null;
    END;
  
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    
    exception
      when others then
        BEGIN
          SELECT XWFPLAZO1
            into plazo
            from XWF700
           WHERE XWFPRCINS = ve_instancia
             AND XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            null;
        END;
    END;
    ------eninah 17/02/2025
    begin
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    end;
    if conc_correos_del is not null or
       replace(conc_correos_del, ' ', '') != '' then
      lv_delegado := ' y delegado(s) informarle(s) lo siguiente: ';
    else
      lv_delegado := '';
    End if;
  
    begin
      select x.AQPC564ANALI,
             x.AQPC564GERAG,
             x.aqpc564usrpa,
             x.aqpc564cmtpa,
             x.aqpc564cargo,
             x.aqpc564tipoo
        into descripcion_usuario_2,
             gerente_agencia_nuevo,
             vi_pre_aprobador,
             vi_cmt_papr,
             vi_cod_cargopapr,
             vi_ctipooperacion
        from AQPC564 x
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'H'
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'H');
    exception
      when others then
        null;
    END;
  
    begin
      select UBNOM
        into descripcion_usuario
        from fst746
       where ubuser = descripcion_usuario_2;
    exception
      when others then
        null;
    end;
  
    begin
      select UBNOM
        into descripcion_usuario_3
        from fst746
       where ubuser = gerente_agencia_nuevo;
    exception
      when others then
        null;
    end;
    begin
      select 'Cambio de tasa ' || tp1desc
        into vi_tipooperacion
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11175
         and tp1corr1 = 1
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_ctipooperacion;
    exception
      when others then
        null;
    end;
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) Gerente de Agencia ' ||
                 /*descripcion_usuario_gerente*/
                  descripcion_usuario_3 || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">Se  ' ||
                 --'GERENCIA DE CRÉDITOS' ||--descripcion_usuario ||
                  ' aprobó la gestión para la cuenta-operación ' ||
                  ve_cuenta || '- ' || ve_Operacion ||
                  ', a continuación el detalle de la gestión:</p>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center;background-color:#D1CCCB"> <b>PROPUESTA DE NEGOCIACIÓN DE TASA EFECTIVA ANUAL </b></td> ' ||
                  '</tr>' || '<tr>' || '<td colspan = "4"></td> ' ||
                  '</tr>' || '<tr><td>Tipo de Operación </td><td>' ||
                  vi_tipooperacion || '</td></tr>' || '<tr>' ||
                  '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "4"></td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cliente</b></td>' ||
                  '<td colspan ="3">' || nombre_cliente || '</td>' ||
                  '</tr>' || '<tr>' || '<td><b>Responsable:</b></td>' ||
                  '<td>' ||
                 /*descripcion_usuario*/
                 /*aqui se modifico 'Gerencia de Créditos'*/
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td><b>Segmento</b></td>' || '<td> ' ||
                  segmento || '</td>' || '<td><b>Monto</b></td>' || '<td>' ||
                  monto || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cuenta Cliente</b></td>' || '<td>' ||
                  ve_cuenta || '</td>' ||
                  '<td><b>Solicitud(Instancia)</b></td>' || '<td>' ||
                  ve_instancia || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>TEA Pizarra</b></td>' || '<td>' ||
                  tasa_actual || '%</td>' || '<td><b>% DE AJUSTE</b></td>' ||
                  '<td>' || porcentaje_ajuste || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Plazo</b></td>' || '<td>' || plazo ||
                  ' </td>' || '<td><b>TASA APROBADA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Producto</b></td>' ||
                  '<td colspan="3">' || destino || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Garantías</b></td>' ||
                  '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' ||
                 
                  '<tr>' ||
                  '<td style="width:20%"><b> Motivo del usuario que realizó la gestión</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td style="width:20%">' ||
                  '      <b>Comentario de la Resolución</b>' || '</td>' ||
                  '<td colspan="3">' || motivo || ' </td>' || '</tr>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '</table>';
  
    begin
      lv_nomrep := 'DT_NEGOCIACION_TEA';
      l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
    exception
      when others then
        null;
    END;
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    conc_correos_del := trim(conc_correos_del);
  
    if contador_delegados > 1 then
      conc_correos_del := lpad(conc_correos_del,
                               LENGTH(conc_correos_del) - 1);
    end if;
  
    -- Aqui valido si el gerente no tiene correo    --eninah 06/12/2024
    IF vi_correoa IS NULL OR TRIM(vi_correoa) = '' THEN
      -- Se agrego esta condición para cuando no haya correo de GCRE
      conc_correos_gerente_creditos := vi_correoa_sup;
    ELSE
      IF vi_correoa_sup IS NULL OR TRIM(vi_correoa_sup) = '' THEN
        conc_correos_gerente_creditos := vi_correoa;
      ELSE
        conc_correos_gerente_creditos := vi_correoa || '; ' ||
                                         vi_correoa_sup;
      END IF;
    END IF;
  
    /*if vi_correoa_sup is null then
      conc_correos_gerente_creditos := vi_correoa;
    else
      conc_correos_gerente_creditos := vi_correoa || '; ' || vi_correoa_sup;
    end if;*/
  
    /*if cantidad_finalizado >= 1 then
      conc_correos_del := '';
    end if;*/
  
    BEGIN
      IF conc_correos_del IS NOT NULL THEN
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos) || '; ' ||
                            TRIM(conc_correos_del);
      ELSE
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------------------------------------------------------------
    BEGIN
      IF lv_GERENTAG IS NOT NULL THEN
        lv_DES := TRIM(lv_GERENTAG) || '; ' || TRIM(lv_ANALISTA);
      ELSE
        lv_DES := TRIM(lv_ANALISTA);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    lv_ASUNTO := 'Aprobación de Gestión para cambio de Tasa - Solicitud(Instancia): ';
    --------------------------------------------------------------------------
    vs_respuesta := 'No hubo errores';
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => lv_DES, --'eninah@cajaarequipa.pe', 
                                       p_DestinatariosCC   => lv_DESTINATARIO, --'hsuarez@cajaarequipa.pe', 
                                       p_DestinatariosBcc  => LTRIM(DestinatariosBcc,
                                                                    ';'), --'aangles@cajaarequipa.pe', --
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => lv_ASUNTO ||
                                                              ve_instancia,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => '',
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
      dbms_lob.freetemporary(ll_mensaje);
    exception
      when others then
        cod_error := '3123-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
  
    -- Se agregó modificacion cuando falla el envio de correo eninah 18/03/2025  
    if cod_error <> '000' then
      begin
        PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 1446, --¿DESCRIPCCION DE TU PROCESO¿ colocar el codigo de tu proceso númerico
                                                  P_C_ASUNTO => lv_ASUNTO ||
                                                                ve_instancia, --ASUNTO
                                                  p_c_despar => lv_DES, --'eninah@cajaarequipa.pe', --PARA
                                                  p_c_descoc => lv_DESTINATARIO, --'hsuarez@cajaarequipa.pe', --CC
                                                  p_c_descco => LTRIM(DestinatariosBcc,
                                                                      ';'), --CCO
                                                  p_c_mensaj => ll_mensaje, --MENSAJE EN HTML CLOB
                                                  p_c_remite => lv_remitente, --REMITENTE
                                                  p_c_direct => lv_nomrep, --DIRECTORIO
                                                  p_c_adjunt => lv_archivos, --LISTADO DE ADJUNTOS
                                                  p_n_aux001 => 0,
                                                  p_n_aux002 => 0,
                                                  p_n_aux003 => 0,
                                                  p_n_aux004 => 0,
                                                  p_d_aux005 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_d_aux006 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_c_aux007 => '',
                                                  p_c_aux008 => 'Intento fallido de envio de correo',
                                                  p_c_aux009 => '',
                                                  p_c_coderr => cod_error,
                                                  p_c_msgerr => cod_des);
        dbms_lob.freetemporary(ll_mensaje);
      exception
        when others then
          null;
      end;
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
    end if;
  
    BEGIN
      INSERT INTO AQPC852
        (AQPC852COR,
         AQPC852REM,
         AQPC852DES,
         AQPC852CC,
         AQPC852CCO,
         AQPC852ASU,
         AQPC852MEN,
         AQPC852FEC,
         AQPC852USR,
         AQPC852ERROR)
      VALUES
        (lv_COR,
         lv_remitente,
         lv_DES,
         lv_DESTINATARIO,
         DestinatariosBcc,
         lv_ASUNTO,
         ll_mensaje,
         sysdate,
         ve_usuario,
         vs_respuesta);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end sp_enviar_correo_aprobacion_gerente;

  --------------------------------------------------------------------
  procedure sp_enviar_correo_paprobacion_gerente(ve_usuario   in varchar2, --APROBACION
                                                 ve_cuenta    in number,
                                                 ve_operacion in number,
                                                 ve_instancia in number,
                                                 vs_respuesta out varchar) is
  
    segundos                      NUMBER;
    contador                      NUMBER;
    descripcion_usuario_3         varchar2(200);
    gerente_agencia_nuevo         varchar2(10);
    gerente_agencia               varchar2(40);
    gerente_agencia_suplente      varchar2(40);
    vi_correoa_suplente           varchar(100);
    vi_correoa                    varchar(100);
    vi_correoa_aprobador          varchar2(600);
    descripcion_agencia           varchar(40);
    lv_mensaje                    varchar2(4000); -- varchar2(2000); eninah 18/08/2023
    nombre_cliente                varchar2(100);
    numero_documento              number;
    lv_remitente                  varchar2(60);
    lv_DOMINIO                    varchar2(60);
    lv_GERENTAG                   varchar2(40);
    lv_SUCURSAL                   number;
    vi_correoa_sup                varchar2(40);
    cod_error                     varchar2(20);
    cod_des                       varchar2(500);
    l_output                      utl_file.file_type;
    lv_nomrep                     varchar2(30) := null;
    lv_nomarc                     varchar2(250) := null;
    lv_archivos                   varchar2(4000) := null;
    vblob                         BLOB;
    ll_mensaje                    clob;
    agencia                       varchar2(100);
    tasa_actual                   number;
    tasa_propuesta                number;
    porcentaje_ajuste             number;
    analista                      varchar2(100);
    motivo                        varchar2(1000);
    fecha_gestion                 date;
    descripcion_usuario           varchar2(1000);
    descripcion_usuario_2         varchar2(10);
    monto                         number;
    ve_sucursal                   number;
    ve_modulo                     number;
    ve_moneda                     number;
    ve_papel                      number;
    ve_suboperacion               number;
    ve_tipooperacion              number;
    plazo                         number;
    destino                       varchar2(400);
    garantia                      varchar2(40);
    tiene_garantia                varchar2(40);
    no_tiene_garantia             varchar2(40);
    motivo_analista               varchar2(400);
    descripcion_usuario_gerente   varchar2(400);
    asesor_instancia              varchar2(50);
    segmento                      varchar2(140);
    conc_gerente_agencia          varchar2(1000);
    usuario_aprobador             varchar2(100);
    conc_correos_gerente_creditos varchar2(1000);
    DestinatariosBcc              varchar2(1000);
    cantidad_finalizado           number;
    gerente_creditos              varchar2(40);
    vi_correo_del                 varchar(40);
    contador_delegados            number;
    conc_correos_del              varchar(500);
    lv_delegado                   varchar2(2000);
    lv_DESTINATARIO               varchar2(60);
    lv_ANALISTA                   varchar2(200);
    lv_COR                        NUMBER;
    lv_DES                        varchar2(1000);
    lv_ASUNTO                     varchar(500);
    suplente_gerente_creditos     varchar2(40);
    lv_pgfape                     date; --eninah 18/08/2023
    -----
    vi_pre_aprobador          char(10);
    vi_cod_cargopapr          number(3);
    vi_cmt_papr               varchar(500);
    descripcion_pre_aprobador varchar(50);
    vi_ctipooperacion         number(9);
    vi_tipooperacion          varchar(50);
    vi_desc_cargo             varchar(50);
    cursor cursor_delegado_gerente(ve_gerente char, ve_fecha date) is
      select aqpc501del
        from aqpc501
       where aqpc501usr = rpad(ve_gerente, 10, ' ')
         and ve_fecha between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
  
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
  
    begin
      -- se agregó eninah 18/08/2023
      select pgfape into lv_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    -- OBTENER DOMINIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DOMINIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 2;
      lv_DOMINIO := lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        lv_DOMINIO := '@cajaarequipa.pe';
    END;
  
    -- OBTENER DESTINATARIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DESTINATARIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 3;
      lv_DESTINATARIO := TRIM(lv_DESTINATARIO) || lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER ANALISTA RESPONSABLE -- 
    BEGIN
      SELECT SNG001ASE
        INTO lv_ANALISTA
        FROM SNG001
       WHERE SNG001INST = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT w.wfusremail
        INTO lv_ANALISTA
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(lv_ANALISTA, 30, ' ');
      lv_ANALISTA := TRIM(lv_ANALISTA);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER SUCURSAL --
    begin
      SELECT XWFSUCURSAL
        INTO lv_SUCURSAL
        FROM XWF700
       WHERE XWFPRCINS = ve_instancia;
    exception
      when others then
        null;
    end;
  
    -- OBTENER GERENTE DE AGENCIA -- 
    begin
      select SNG057USR
        INTO gerente_agencia
        from sng057 s, fst046 f, PRFU00 p
       where s.sng057usr = f.ubuser
         and sng055car = 202
         and sng057aut = 'S'
         and f.ubsuc = lv_SUCURSAL
         and p.ubuser = f.ubuser
         and prfgcod = 'GAGE01';
    exception
      when others then
        NULL;
    end;
  
    BEGIN
      SELECT w.wfusremail
        INTO gerente_agencia
        FROM WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia, 30, ' ');
      lv_GERENTAG := TRIM(gerente_agencia);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- OBTENER REMITENTE -- 
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := TRIM(lv_remitente) || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    end;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    begin
      select count(*)
        into contador_delegados
        from aqpc501
       where aqpc501usr = rpad(gerente_creditos, 10, ' ')
         and lv_pgfape between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
    exception
      when others then
        null;
    end;
  
    for jj in cursor_delegado_gerente(gerente_creditos, lv_pgfape) loop
      -- eninah 18/08/2023
      begin
        select w.wfusremail
          into vi_correo_del
          from WFUSERS W
         WHERE W.WFUSRCOD = rpad(jj.aqpc501del, 30, ' ');
      
        vi_correo_del := trim(vi_correo_del);
        if contador_delegados = 0 then
          conc_correos_del := '';
        elsif contador_delegados = 1 then
          conc_correos_del := vi_correo_del;
        else
          conc_correos_del := vi_correo_del || '; ' || conc_correos_del;
        end if;
      exception
        when others then
          conc_correos_del := '';
          vi_correo_del    := '';
      end;
    end loop;
  
    begin
      select sng057sup
        into suplente_gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        suplente_gerente_creditos := '';
        null;
    end;
  
    -- OBTENER NOMBRE/AGENCIA -- 
    BEGIN
      SELECT SCNOM
        INTO agencia
        FROM FST001 a
       INNER JOIN XWF700 b
          ON b.XWFSUCURSAL = a.SUCURS
       WHERE B.XWFPRCINS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --suplente_gc
    begin
      select w.wfusremail
        into vi_correoa_sup
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(suplente_gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa_sup := '';
    end;
    if vi_correoa_sup is null then
      vi_correoa_sup := '';
    end if;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             AQPC564TPR, -- 24/07/2024  eninah   AQPC564TEAPRO, --aqpc564tpr, 08/09/2023 eninah
             AQPC564PAJ, -- 24/07/2024  eninah   AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
             aqpc564usu,
             aqpc564opi,
             aqpc564fec,
             aqpc564des,
             aqpc564gar,
             aqpc564mot,
             aqpc564seg,
             aqpc564uop,
             aqpc564tipoo
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             analista,
             motivo,
             fecha_gestion,
             destino,
             garantia,
             motivo_analista,
             segmento,
             usuario_aprobador,
             vi_ctipooperacion
        from (select aqpc564cli,
                     aqpc564arc,
                     aqpc564tea,
                     AQPC564TPR, -- 24/07/2024  eninah AQPC564TEAPRO, --aqpc564tpr, 11/09/2023 eninah
                     AQPC564PAJ, -- 24/07/2024  eninah AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
                     aqpc564usu,
                     aqpc564opi,
                     aqpc564fec,
                     aqpc564des,
                     aqpc564gar,
                     aqpc564mot,
                     aqpc564seg,
                     aqpc564uop,
                     aqpc564tipoo
                from aqpc564 s
               where aqpc564cue = ve_cuenta
                 and aqpc564ope = ve_operacion
                 and aqpc564ins = ve_instancia
                 and aqpc564est = 'G'
               order by aqpc564cor desc)
       where rownum = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select sng001ase
        into asesor_instancia
        from sng001
       where sng001inst = ve_instancia;
    exception
      when others then
        null;
    END;
  
    begin
      select sng057sup
        into gerente_agencia_suplente
        from sng057
       where sng057usr = rpad(gerente_agencia, 10, ' ');
    exception
      when others then
        null;
    end;
  
    begin
      select w.wfusremail
        into vi_correoa_aprobador
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(usuario_aprobador, 30, ' ');
    exception
      when others then
        vi_correoa_aprobador := '';
    end;
  
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa := '';
    end;
  
    begin
      select w.wfusremail
        into vi_correoa_suplente
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia_suplente, 30, ' ');
    exception
      when others then
        vi_correoa_suplente := '';
    end;
  
    begin
      select ubnom
        into descripcion_usuario_gerente
        from fst746
       where ubuser = rpad(gerente_agencia, 10, ' ');
    exception
      when others then
        null;
    END;
  
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    
    exception
      when others then
        BEGIN
          SELECT XWFPLAZO1
            into plazo
            from XWF700
           WHERE XWFPRCINS = ve_instancia
             AND XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            null;
        END;
    END;
    ----eninah 17/02/2025
    begin
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    end;
    ---------------
    if conc_correos_del is not null or
       replace(conc_correos_del, ' ', '') != '' then
      lv_delegado := ' y delegado(s) informarle(s) lo siguiente: ';
    else
      lv_delegado := '';
    End if;
  
    begin
      /*select ubnom
       into descripcion_usuario
       from fst746
      where ubuser = rpad(analista, 10, ' ');*/
      select x.AQPC564ANALI,
             x.AQPC564GERAG,
             x.aqpc564usrpa,
             x.aqpc564cmtpa,
             x.aqpc564cargo,
             x.aqpc564tipoo
        into descripcion_usuario_2,
             gerente_agencia_nuevo,
             vi_pre_aprobador,
             vi_cmt_papr,
             vi_cod_cargopapr,
             vi_ctipooperacion
        from AQPC564 x
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'H'
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'H');
    exception
      when others then
        null;
    END;
  
    begin
      select UBNOM
        into descripcion_usuario
        from fst746
       where ubuser = descripcion_usuario_2;
    exception
      when others then
        null;
    end;
  
    begin
      select UBNOM
        into descripcion_usuario_3
        from fst746
       where ubuser = gerente_agencia_nuevo;
    exception
      when others then
        null;
    end;
    begin
      select UBNOM
        into descripcion_pre_aprobador
        from fst746
       where ubuser = vi_pre_aprobador;
    exception
      when others then
        null;
    end;
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) Gerente de créditos ' ||
                 --gerente_creditos || lv_delegado || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">El usuario ' ||
                  descripcion_pre_aprobador ||
                  ' realizó una gestión de Pre-Aprobacion para la cuenta-operación: ' ||
                  ve_cuenta || '- ' || ve_Operacion || 'del Analista ' ||
                  descripcion_usuario ||
                  ', deberá aprobarla o rechazarla en Bantotal, a continuación el detalle de la gestión:</p>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
    begin
      select sng055dsc
        into vi_desc_cargo
        from sng055
       where sng055emp = 1
         and sng055car = vi_cod_cargopapr;
    exception
      when others then
        vi_desc_cargo := '';
    end;
    begin
      select 'Cambio de tasa ' || tp1desc
        into vi_tipooperacion
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11175
         and tp1corr1 = 1
         and tp1corr2 = 2
         and tp1corr3 > 0
         and tp1nro1 = vi_ctipooperacion;
    exception
      when others then
        null;
    end;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center;background-color:#D1CCCB"> <b>PROPUESTA DE NEGOCIACIÓN DE TASA EFECTIVA ANUAL ' ||
                  vi_tipooperacion || '</b></td> ' || '</tr>' || '<tr>' ||
                  '<td colspan = "4"></td> ' || '</tr>' ||
                  '<tr><td>Tipo de Operación </td><td>' || vi_tipooperacion ||
                  '</td></tr>' || '<tr>' || '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' || '<tr>' ||
                  '<td colspan = "4"></td>' || '</tr>' || '<tr>' ||
                  '<td><b>Cliente</b></td>' || '<td colspan ="3">' ||
                  nombre_cliente || '</td>' || '</tr>' || '<tr>' ||
                  '<td><b>Responsable:</b></td>' || '<td>' ||
                 /*descripcion_usuario*/
                 /*aqui se modifico 'Gerencia de Créditos'*/
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' || '<tr>' || '<td><b>Segmento</b></td>' ||
                  '<td> ' || segmento || '</td>' || '<td><b>Monto</b></td>' ||
                  '<td>' || monto || '</td>' || '</tr>' || '<tr>' ||
                  '<td><b>Cuenta Cliente</b></td>' || '<td>' || ve_cuenta ||
                  '</td>' || '<td><b>Solicitud(Instancia)</b></td>' ||
                  '<td>' || ve_instancia || ' </td>' || '</tr>' || '<tr>' ||
                  '<td><b>TEA Pizarra</b></td>' || '<td>' || tasa_actual ||
                  '%</td>' || '<td><b>% DE AJUSTE</b></td>' || '<td>' ||
                  porcentaje_ajuste || '% </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Plazo</b></td>' || '<td>' || plazo || ' </td>' ||
                  '<td><b>TASA APROBADA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Producto</b></td>' || '<td colspan="3">' ||
                  destino || ' </td>' || '</tr>' || '<tr>' ||
                  '<td><b>Garantías</b></td>' || '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' || '<tr>' ||
                  '<td style="width:20%"><b> Motivo del usuario que realizó la gestión</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>' || '<tr>' ||
                  '<td style="width:20%">' ||
                  '      <b>Comentario de la Resolución</b>' || '</td>' ||
                  '<td colspan="3">' || motivo || ' </td>' || '</tr>' ||
                  '<tr>' || '<td><b>Pre-Aprobador</b></td><td>' ||
                  vi_pre_aprobador || '</td><td><b>Cargo</b></td><td>' ||
                  vi_desc_cargo || '</td>' || '</tr><tr>' ||
                  '<td style="width: 20%;"><b> Comentarios del Pre-Aprobador</b>' ||
                  '</td><td>' || vi_cmt_papr || '</td>' || '</tr>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '</table>';
  
    begin
      lv_nomrep := 'DT_NEGOCIACION_TEA';
      l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
    exception
      when others then
        null;
    END;
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    conc_correos_del := trim(conc_correos_del);
  
    if contador_delegados > 1 then
      conc_correos_del := lpad(conc_correos_del,
                               LENGTH(conc_correos_del) - 1);
    end if;
  
    if vi_correoa_sup is null then
      conc_correos_gerente_creditos := vi_correoa;
    else
      conc_correos_gerente_creditos := vi_correoa || '; ' || vi_correoa_sup;
    end if;
  
    BEGIN
      IF conc_correos_del IS NOT NULL THEN
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos) || '; ' ||
                            TRIM(conc_correos_del);
      ELSE
        DestinatariosBcc := TRIM(conc_correos_gerente_creditos);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------------------------------------------------------------
    BEGIN
      IF lv_GERENTAG IS NOT NULL THEN
        lv_DES := TRIM(lv_GERENTAG) || '; ' || TRIM(lv_ANALISTA);
      ELSE
        lv_DES := TRIM(lv_ANALISTA);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    lv_ASUNTO := 'Aprobación de Gestión para cambio de Tasa - Solicitud(Instancia): ';
    --------------------------------------------------------------------------
  
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => lv_DES, --'eninah@cajaarequipa.pe', 
                                       p_DestinatariosCC   => lv_DESTINATARIO, -- 'hsuarez@cajaarequipa.pe',
                                       p_DestinatariosBcc  => LTRIM(DestinatariosBcc,
                                                                    ';'), --'aangles@cajaarequipa.pe', --
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => lv_ASUNTO ||
                                                              ve_instancia,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => '',
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
    exception
      when others then
        cod_error := '3123-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
    -------eninah 17/02/2025----------
    dbms_lob.freetemporary(ll_mensaje);
    -----------------------------------
    -- cambios en el if eninah 03/08/2023
    if cod_error != '' or cod_error != '000' then
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
      contador     := 1;
      segundos     := 5;
      LOOP
        BEGIN
          INSERT INTO AQPC852
            (AQPC852COR,
             AQPC852REM,
             AQPC852DES,
             AQPC852CC,
             AQPC852CCO,
             AQPC852ASU,
             AQPC852MEN,
             AQPC852FEC,
             AQPC852USR,
             AQPC852ERROR)
          VALUES
            (lv_COR,
             lv_remitente,
             lv_DES,
             lv_DESTINATARIO,
             DestinatariosBcc,
             lv_ASUNTO,
             ll_mensaje,
             sysdate,
             ve_usuario,
             vs_respuesta);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        DBMS_LOCK.SLEEP(segundos); -- continua el proceso en el intervalo de segundos.
        --Hace de nuevo el llamado al programa que envía correos.
        begin
          pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => lv_DES, -- 'eninah@cajaarequipa.pe', 
                                           p_DestinatariosCC   => lv_DESTINATARIO, --'hsuarez@cajaarequipa.pe',
                                           p_DestinatariosBcc  => LTRIM(DestinatariosBcc,
                                                                        ';'), --'aangles@cajaarequipa.pe', --
                                           p_Mensaje           => ll_mensaje,
                                           p_Remitente         => lv_remitente,
                                           p_Asunto            => lv_ASUNTO ||
                                                                  ve_instancia,
                                           p_TipoMensaje       => 'HTML',
                                           p_Directorio        => lv_nomrep,
                                           p_ArchivosAdjuntos  => '',
                                           p_c_coderr          => cod_error, --000
                                           p_c_deserr          => cod_des); --riesgo
        exception
          when others then
            cod_error := '3178-';
            cod_des   := SUBSTR(sqlerrm, 1, 500);
        END;
        -------eninah 17/02/2025----------
        dbms_lob.freetemporary(ll_mensaje);
        -----------------------------------
        IF contador > 4 or cod_error = '000' THEN
          EXIT; -- Salir del bucle cuando se cumpla la condición
        END IF;
        contador := contador + 1;
      END LOOP;
    Else
      vs_respuesta := 'No hubo errores';
      BEGIN
        INSERT INTO AQPC852
          (AQPC852COR,
           AQPC852REM,
           AQPC852DES,
           AQPC852CC,
           AQPC852CCO,
           AQPC852ASU,
           AQPC852MEN,
           AQPC852FEC,
           AQPC852USR,
           AQPC852ERROR)
        VALUES
          (lv_COR,
           lv_remitente,
           lv_DES,
           lv_DESTINATARIO,
           DestinatariosBcc,
           lv_ASUNTO,
           ll_mensaje,
           sysdate,
           ve_usuario,
           vs_respuesta);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    End if;
  
  end sp_enviar_correo_paprobacion_gerente;

  --------------------------------------------------------------------

  procedure sp_enviar_correo_aprobacion_gerente_creditos(ve_usuario   in varchar2,
                                                         ve_cuenta    in number,
                                                         ve_operacion in number,
                                                         ve_instancia in number,
                                                         vs_respuesta out varchar) is
  
    segundos NUMBER;
    contador NUMBER;
    --gerente_agencia     varchar2(40);
    lv_COR                       NUMBER;
    lv_ASUNTO                    varchar(500);
    descripcion_gerente_agencia  varchar2(100);
    vi_correoa                   varchar(40);
    descripcion_agencia          varchar(40);
    lv_mensaje                   varchar2(4000); --varchar2(2000) eninah 18/08/2023
    nombre_cliente               varchar2(100);
    numero_documento             number;
    lv_remitente                 varchar2(60);
    lv_DOMINIO                   varchar2(60);
    cod_error                    varchar2(20);
    cod_des                      varchar2(500);
    l_output                     utl_file.file_type;
    lv_nomrep                    varchar2(30) := null;
    lv_nomarc                    varchar2(250) := null;
    lv_archivos                  varchar2(4000) := null;
    vblob                        BLOB;
    ll_mensaje                   clob;
    agencia                      varchar2(100);
    tasa_actual                  number;
    tasa_propuesta               number;
    porcentaje_ajuste            number;
    analista                     varchar2(100);
    motivo                       varchar2(1000);
    gerente_creditos             varchar2(100);
    gerente_agencia              varchar2(100);
    fecha_gestion                date;
    descripcion_usuario          varchar2(100);
    descripcion_usuario_2        varchar2(10);
    descripcion_gerente_creditos varchar2(100);
    monto                        number;
    ve_sucursal                  number;
    ve_modulo                    number;
    ve_moneda                    number;
    ve_papel                     number;
    ve_suboperacion              number;
    ve_tipooperacion             number;
    plazo                        number;
    destino                      varchar2(40);
    garantia                     varchar2(40);
    tiene_garantia               varchar2(40);
    no_tiene_garantia            varchar2(40);
    motivo_analista              varchar2(1000);
    ---------------------------------------
    suplente_gerente_creditos     varchar(40);
    vi_correoa_sup                varchar(40);
    conc_correos_gerente_creditos varchar(40);
    ---------------------------------------
  
    x               NUMBER;
    tamanio_archivo number;
    len             number;
    vstart          NUMBER := 1;
    bytelen         NUMBER := 32000;
    my_vr           RAW(32000);
  
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
  
    -- OBTENER DOMINIO -- 
    BEGIN
      SELECT REPLACE(tp1desc, ' ', '')
        INTO lv_DOMINIO
        FROM fst198
       WHERE tp1cod = 1
         AND tp1cod1 = 11105
         AND tp1corr1 = 28
         AND tp1corr2 = 4
         AND tp1corr3 = 2;
      lv_DOMINIO := lv_DOMINIO;
    EXCEPTION
      WHEN OTHERS THEN
        lv_DOMINIO := '@cajaarequipa.pe';
    END;
  
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := lv_remitente || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    begin
      select scnom
        into agencia
        from fst046 fs
       inner join fst001 f
          on ubsuc = sucurs
         and f.pgcod = 1
       where ubuser = rpad(ve_usuario, 10, ' ')
         and fs.pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    END;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             AQPC564TEAPRO, --aqpc564tpr, 08/09/2023 eninah
             AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
             aqpc564usu,
             aqpc564opi,
             aqpc564uop,
             aqpc564fec,
             aqpc564des,
             aqpc564gar,
             aqpc564mot,
             dbms_lob.getlength(aqpc564car)
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             analista,
             motivo,
             gerente_agencia,
             fecha_gestion,
             destino,
             garantia,
             motivo_analista,
             tamanio_archivo
        from (select aqpc564cli,
                     aqpc564arc,
                     aqpc564tea,
                     AQPC564TEAPRO, --aqpc564tpr, 11/09/2023 eninah
                     AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
                     aqpc564usu,
                     aqpc564opi,
                     aqpc564uop,
                     aqpc564fec,
                     aqpc564des,
                     aqpc564gar,
                     aqpc564mot,
                     aqpc564car
                from aqpc564
               where aqpc564cue = ve_cuenta
                 and aqpc564ope = ve_operacion
                 and aqpc564ins = ve_instancia
                 and aqpc564est = 'A'
               order by aqpc564cor desc)
       where rownum = 1;
    exception
      when others then
        null;
    END;
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      /*select ubnom
       into descripcion_usuario
       from fst746
      where ubuser = analista;*/
      select AQPC564ANALI
        into descripcion_usuario_2
        from AQPC564
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'H'
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'H');
      --and AQPC564EST = 'A';
    exception
      when others then
        null;
    END;
  
    begin
      select UBNOM
        into descripcion_usuario
        from fst746
       where ubuser = descripcion_usuario_2;
    exception
      when others then
        null;
    end;
  
    begin
      /*select ubnom
       into descripcion_usuario
       from fst746
      where ubuser = rpad(analista, 10, ' ');*/
      /*
      select x.AQPC564ANALI, x.AQPC564GERAG,x.aqpc564usrpa,x.aqpc564cmtpa,x.aqpc564cargo,x.aqpc564tipoo
        into descripcion_usuario_2, gerente_agencia_nuevo, vi_pre_aprobador,vi_cmt_papr,vi_cod_cargopapr,vi_ctipooperacion
        from AQPC564 x
       where AQPC564INS = ve_instancia
         and AQPC564EHA = 'H'
         and AQPC564COR = (select max(AQPC564COR)
                             from AQPC564
                            where AQPC564INS = ve_instancia
                              and AQPC564EHA = 'H');
      */
      null;
    exception
      when others then
        null;
    END;
  
    begin
      select ubnom
        into descripcion_gerente_agencia
        from fst746
       where ubuser = rpad(gerente_agencia, 10, ' ');
    exception
      when others then
        null;
    END;
  
    begin
      select ubnom
        into descripcion_gerente_creditos
        from fst746
       where ubuser = gerente_creditos;
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_agencia, 30, ' ');
    
    exception
      when others then
        vi_correoa := '';
    end;
  
    ----------------------------------------------------------------------------
    ------eninah 06/12/2024 
    begin
      select sng057sup
        into suplente_gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        suplente_gerente_creditos := '';
        null;
    end;
  
    --suplente_gc
    begin
      select w.wfusremail
        into vi_correoa_sup
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(suplente_gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa_sup := '';
    end;
    ----------------------------------------------------------------------------
  
    IF vi_correoa IS NULL OR TRIM(vi_correoa) = '' THEN
      conc_correos_gerente_creditos := vi_correoa_sup;
    ELSE
      conc_correos_gerente_creditos := vi_correoa;
    END IF;
    ---eninah 17/02/2025
    begin
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    end;
    ------------
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) Gerente de créditos: ' ||
                  descripcion_gerente_creditos || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">El Gerente de agencia ' ||
                  descripcion_gerente_agencia ||
                  ' aceptó la gestión del analista' || descripcion_usuario ||
                  'para la cuenta-operación ' || ve_cuenta || '- ' ||
                  ve_Operacion ||
                  ', a continuación el detalle de la gestión:</p>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center;background-color:#D1CCCB;"> <b>PROPUESTA DE NEGOCIACION DE TASA EFECTIVA ANUAL HASTA -10% </b></td> ' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td colspan = "4"></td> ' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "4"></td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cliente</b></td>' ||
                  '<td colspan ="3">' || nombre_cliente || '</td>' ||
                  '</tr>' || '<tr>' ||
                  '<td><b>Analista Responsable</b></td>' || '<td>' ||
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td><b>Segmento</b></td>' || '<td></td>' ||
                  '<td><b>Monto</b></td>' || '<td>' || monto || '</td>' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td><b>Cuenta Cliente</b></td>' || '<td>' ||
                  ve_cuenta || '</td>' || '<td><b>Instancia</b></td>' ||
                  '<td>' || ve_instancia || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>TEA Pizarra</b></td>' || '<td>' ||
                  tasa_actual || '%</td>' || '<td><b>% DE AJUSTE</b></td>' ||
                  '<td>' || porcentaje_ajuste || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Plazo</b></td>' || '<td>' || plazo ||
                  ' </td>' || '<td><b>TASA APROBADA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Producto</b></td>' ||
                  '<td colspan="3">' || destino || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Garantías</b></td>' ||
                  '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' ||
                 
                  '<tr>' ||
                  '<td style="width:20%"><b> Motivo del ANALISTA de créditos por el cual se solicita tasa negociada</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td style="width:20%">' ||
                  '      <b>Motivo del GERENTE DE AGENCIA para aprobar la gestión del Analista</b>' ||
                  '</td>' || '<td colspan="3">' || motivo || ' </td>' ||
                  '</tr>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '</table>' || '<div style="margin-top:100px">' || '<hr>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 >' ||
                  '<tr >' ||
                  '<td colsspan="2" style="text-align:center"><b>FIRMA Y SELLO ANALISTA DE CREDITO</b> </td>' ||
                  '<td colspan="2" style="text-align:center"><b>FIRMA Y SELLO GERENTE DE AGENCIA</b> </td>' ||
                  '</tr>' || '</table>' || '</div>' ||
                  '<div style="margin-top:20px">' ||
                  '* El formato debe ser enviado vía PDF debidamente firmado por el AC y GA <br>' ||
                  '** La aprobación de NEGOCIACIÓN DE TASA ACTIVA será vía correo electrónico sin necesidad de aprobarlo en el formato <br>' ||
                  '*** Para solicitar Negociación de TEA el Cliente deberá estar calificado 100% en el último periodo' ||
                  '</div>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_nomrep := 'DT_NEGOCIACION_TEA';
    l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
  
    begin
      select aqpc564car
        into vblob
        from aqpc564
       where aqpc564cue = ve_cuenta
         and aqpc564ope = ve_operacion
         and aqpc564ins = ve_instancia
         and aqpc564eha = 'H';
    exception
      when others then
        null;
    END;
    len := tamanio_archivo;
    x   := len;
  
    If len < 32760 then
      utl_file.put_raw(l_output, vblob);
      utl_file.fflush(l_output);
    Else
      -- write in pieces
      vstart := 1;
      While vstart < len and bytelen > 0 Loop
        dbms_lob.read(vblob, bytelen, vstart, my_vr);
      
        utl_file.put_raw(l_output, my_vr);
        utl_file.fflush(l_output);
      
        -- set the start position for the next cut
        vstart := vstart + bytelen;
      
        -- set the end position if less than 32000 bytes
        x := x - bytelen;
        If x < 32000 Then
          bytelen := x;
        End If;
      End Loop;
      utl_file.fclose(l_output);
    End If;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    lv_ASUNTO := 'Aprobación de Gestión para cambio de Tasa - Instancia: ' ||
                 ve_instancia;
  
    vs_respuesta := 'No hubo errores';
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => conc_correos_gerente_creditos, -- 'eninah@cajaarequipa.pe',
                                       p_DestinatariosCC   => '', --'hsuarez@cajaarequipa.pe;eninah@cajaarequipa.pe', --
                                       p_DestinatariosBcc  => '', --'aangles@cajaarequipa.pe', --
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => lv_ASUNTO,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => lv_archivos,
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
      dbms_lob.freetemporary(ll_mensaje);
    exception
      when others then
        cod_error := '3717-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
  
    -- Se agregó modificacion cuando falla el envio de correo eninah 18/03/2025  
    if cod_error <> '000' then
      begin
        PQ_CR_ENVIAR_CORREOS.sp_ah_reprocesa_mail(P_N_CODPRO => 1446, --¿DESCRIPCCION DE TU PROCESO¿ colocar el codigo de tu proceso númerico
                                                  P_C_ASUNTO => lv_ASUNTO, --ASUNTO
                                                  p_c_despar => conc_correos_gerente_creditos, -- 'eninah@cajaarequipa.pe', --PARA
                                                  p_c_descoc => '', --CC
                                                  p_c_descco => '', --CCO
                                                  p_c_mensaj => ll_mensaje, --MENSAJE EN HTML CLOB
                                                  p_c_remite => lv_remitente, --REMITENTE
                                                  p_c_direct => lv_nomrep, --DIRECTORIO
                                                  p_c_adjunt => lv_archivos, --LISTADO DE ADJUNTOS
                                                  p_n_aux001 => 0,
                                                  p_n_aux002 => 0,
                                                  p_n_aux003 => 0,
                                                  p_n_aux004 => 0,
                                                  p_d_aux005 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_d_aux006 => TO_DATE('01/01/0001',
                                                                        'DD/MM/YYYY'),
                                                  p_c_aux007 => '',
                                                  p_c_aux008 => 'Intento fallido de envio de correo',
                                                  p_c_aux009 => '',
                                                  p_c_coderr => cod_error,
                                                  p_c_msgerr => cod_des);
        dbms_lob.freetemporary(ll_mensaje);
      exception
        when others then
          null;
      end;
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
    end if;
  
    BEGIN
      INSERT INTO AQPC852
        (AQPC852COR,
         AQPC852REM,
         AQPC852DES,
         AQPC852CC,
         AQPC852CCO,
         AQPC852ASU,
         AQPC852MEN,
         AQPC852FEC,
         AQPC852USR,
         AQPC852ERROR)
      VALUES
        (lv_COR,
         lv_remitente,
         conc_correos_gerente_creditos,
         '',
         '',
         lv_ASUNTO,
         ll_mensaje,
         sysdate,
         ve_usuario,
         vs_respuesta);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end sp_enviar_correo_aprobacion_gerente_creditos;

  -----------------------------------------------------------------------------
  procedure sp_inserta_aqpc501(ve_usuario              in varchar2,
                               ve_cargo                in number,
                               ve_delegado             in varchar,
                               ve_fechaVigenciaInicial in date,
                               ve_fechaVigenciaFinal   in date,
                               PI_NOM_PANEL            IN VARCHAR2,
                               vs_respuesta            out varchar) is
  
    validacion_usuario number;
  Begin
    begin
      select count(*)
        into validacion_usuario
        from aqpc501
       where aqpc501usr = rpad(ve_usuario, 10, ' ')
         and aqpc501del = rpad(ve_delegado, 10, ' ');
    exception
      when others then
        null;
    END;
  
    if validacion_usuario = 0 then
      Begin
        insert into aqpc501
          (aqpc501emp,
           aqpc501usr,
           aqpc501car,
           aqpc501del,
           aqpc501ini,
           aqpc501fin,
           aqpc501panel)
        values
          (1,
           ve_usuario,
           ve_cargo,
           ve_delegado,
           ve_fechaVigenciaInicial,
           ve_fechaVigenciaFinal,
           PI_NOM_PANEL);
        commit;
        vs_respuesta := 'INSERTO';
      Exception
        when others then
          vs_respuesta := 'NO INSERTO';
      End;
    Else
      begin
        update aqpc501
           set aqpc501ini   = ve_fechaVigenciaInicial,
               aqpc501fin   = ve_fechaVigenciaFinal,
               aqpc501panel = PI_NOM_PANEL
         where aqpc501usr = rpad(ve_usuario, 10, ' ')
           and aqpc501del = rpad(ve_delegado, 10, ' ');
        commit;
        vs_respuesta := 'ACTUALIZO';
      exception
        when others then
          vs_respuesta := 'NO SE ACTUALIZO';
      end;
    end if;
  
  End sp_inserta_aqpc501;

  ----------------------------------
  procedure sp_actualizar_tasa(ve_instancia            in number,
                               ve_cuenta               in number,
                               ve_operacion            in number,
                               ve_usuario              in varchar2,
                               ve_fecha                in date,
                               ve_hora                 in varchar2,
                               ve_tasa_propuesta       in number,
                               ve_porcentaje_descuento in number,
                               vs_respuesta            out varchar2) is
    correlativo_maximo number;
  begin
  
    update aqpc564
       set aqpc564est = 'R', --, aqpc564eha = 'I',
           aqpc564opi = 'Rechazo Cambio de Tasa',
           aqpc564usu = ve_usuario,
           aqpc564fec = ve_fecha,
           aqpc564hor = ve_hora,
           aqpc564eha = 'I'
    --aqpc564tpr = ve_tasa_propuesta,
    --aqpc564paj = ve_porcentaje_descuento
    
     where aqpc564ins = ve_instancia
       and aqpc564ope = ve_operacion
       and aqpc564cue = ve_cuenta
       and aqpc564eha = 'H';
    commit;
  
    select max(aqpc564cor) into correlativo_maximo from aqpc564;
    correlativo_maximo := correlativo_maximo + 1;
  
    insert into aqpc564
      select correlativo_maximo,
             AQPC564CUE,
             AQPC564OPE,
             AQPC564USU,
             AQPC564INS,
             AQPC564FEC,
             AQPC564HOR,
             AQPC564CLI,
             AQPC564ARE,
             AQPC564SEG,
             AQPC564AGE,
             AQPC564MAP,
             AQPC564TEA,
             AQPC564PAJ,
             AQPC564TPR,
             AQPC564DES,
             AQPC564GAR,
             AQPC564MOT,
             AQPC564ARC,
             AQPC564EST,
             AQPC564OPI,
             AQPC564UOP,
             AQPC564FOP,
             'H',
             AQPC564HCA,
             AQPC564CAR,
             AQPC564UFI,
             AQPC564FFI,
             AQPC564HFI,
             AQPC564SCO,
             AQPC564PDEF,
             AQPC564SRSGO,
             AQPC564ANALI,
             AQPC564GERAG, --@HSUAREZ 12.07.2023 CAMPOS ADICIONALES.
             AQPC564ESTR,
             AQPC564U512,
             AQPC564U517,
             0, --ENINAH 21/08/2023 CAMPOS ADICIONALES
             0,
             ' ',
             AQPC564TIPOO,
             AQPC564PRFPA,
             AQPC564CARGO,
             AQPC564USRPA,
             AQPC564CMTPA, --@HSUAREZ 2024.06.12
             AQPC564FPAPR,
             AQPC564HPAPR,
             AQPC564TPAPR,
             AQPC564PPAPR --@HSUAREZ 2024.06.12
        from aqpc564
       where aqpc564ins = ve_instancia
         and aqpc564ope = ve_operacion
         and aqpc564cue = ve_cuenta
         and aqpc564eha = 'I'
         and rownum = 1;
    commit;
  
    begin
      update aqpc564
         set aqpc564est = 'G', --, aqpc564eha = 'I',
             aqpc564opi = 'Aprobacion Cambio de Tasa',
             aqpc564usu = ve_usuario,
             aqpc564fec = ve_fecha,
             aqpc564hor = ve_hora,
             aqpc564tpr = ve_tasa_propuesta,
             aqpc564paj = ve_porcentaje_descuento
      
       where aqpc564ins = ve_instancia
         and aqpc564ope = ve_operacion
         and aqpc564cue = ve_cuenta
         and aqpc564eha = 'H';
      commit;
      vs_respuesta := 'S';
    Exception
      when others then
        vs_respuesta := 'N';
    End;
  
  end sp_actualizar_tasa;

  procedure sp_validacion_regional(ve_usuario   in varchar2,
                                   ve_instancia in number,
                                   vs_respuesta out varchar2) is
  
    sucursal_instancia number;
    region_instancia   number;
    sucursal_regional  number;
    region_regional    number;
  begin
  
    begin
      select xwfsucursal
        into sucursal_instancia
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1'
         and xwfsubope = (select max(xwfsubope)
                            from xwf700
                           where xwfprcins = ve_instancia
                             and xwfcar3 = '1');
    exception
      when others then
        null;
    End;
  
    begin
      select (select tp1nro1
                from fst198 f
               where tp1cod = 1
                 and tp1cod1 = 10872
                 and tp1corr1 = 11 --and tp1nro1 = 1
                 and tp1nro2 in
                     (select regcod from fst811 where oficod = sucurs)) --as region
        into region_instancia
        from fst001 f
       where sucurs = sucursal_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select (select ubsuc from fst046 f where f.ubuser = pr.ubuser)
        into sucursal_regional
        from prfu00 pr
       where ubuser = rpad(ve_usuario, 10, ' ') --replace(ve_usuario,' ','')
         and prfgcod = 'GREG01';
    exception
      when others then
        null;
    End;
  
    begin
      select (select tp1nro1
                from fst198 f
               where tp1cod = 1
                 and tp1cod1 = 10872
                 and tp1corr1 = 11 --and tp1nro1 = 1
                 and tp1nro2 in
                     (select regcod from fst811 where oficod = sucurs))
        into region_regional
        from fst001 f
       where sucurs = sucursal_regional;
    exception
      when others then
        null;
    end;
  
    if region_instancia = region_regional then
      vs_respuesta := 'S';
    Else
      vs_respuesta := 'N';
    end if;
  end sp_validacion_regional;

  procedure sp_validacion_zonal(ve_usuario   in varchar2,
                                ve_instancia in number,
                                vs_respuesta out varchar2) is
  
    sucursal_instancia number;
    zona_instancia     number;
    sucursal_zonal     number;
    zona_zonal         number;
    --ve_usuario2 varchar2(100);
  begin
  
    begin
      select xwfsucursal
        into sucursal_instancia
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1'
         and xwfsubope = (select max(xwfsubope)
                            from xwf700
                           where xwfprcins = ve_instancia
                             and xwfcar3 = '1');
    exception
      when others then
        null;
    End;
  
    begin
      select tp1nro2
        into zona_instancia
        from fst198 f
       where tp1cod = 1
         and tp1cod1 = 10872
         and tp1corr1 = 11
         and tp1nro2 in
             (select regcod from fst811 where oficod = sucursal_instancia);
    exception
      when others then
        null;
    end;
  
    begin
      --ve_usuario2 := trim(ve_usuario);
      select (select ubsuc from fst046 f where f.ubuser = pr.ubuser)
        into sucursal_zonal
        from prfu00 pr
       where ubuser = rpad(ve_usuario, 10, ' ') --ve_usuario2
         and prfgcod = 'JZON01';
    exception
      when others then
        null;
    End;
  
    begin
      select tp1nro2
        into zona_zonal
        from fst198 f
       where tp1cod = 1
         and tp1cod1 = 10872
         and tp1corr1 = 11
         and tp1nro2 in
             (select regcod from fst811 where oficod = sucursal_zonal);
    exception
      when others then
        null;
    end;
  
    if zona_instancia = zona_zonal then
      vs_respuesta := 'S';
    Else
      vs_respuesta := 'N';
    end if;
  
  end sp_validacion_zonal;

  ---------correo_finalizacion
  procedure sp_enviar_correo_finalizacion(ve_usuario   in varchar2,
                                          ve_cuenta    in number,
                                          ve_operacion in number,
                                          ve_instancia in number,
                                          vs_respuesta out varchar) is
  
    segundos                              NUMBER;
    contador                              NUMBER;
    lv_COR                                number;
    lv_ASUNTO                             varchar2(500);
    gerente_agencia                       varchar2(140);
    gerente_creditos                      varchar2(140);
    vi_correoa                            varchar(140);
    vi_correo_del                         varchar(140);
    descripcion_agencia                   varchar(140);
    lv_mensaje                            varchar2(2000);
    lv_delegado                           varchar2(2000);
    nombre_cliente                        varchar2(100);
    numero_documento                      number;
    lv_remitente                          varchar2(60);
    cod_error                             varchar2(20);
    cod_des                               varchar2(500);
    l_output                              utl_file.file_type;
    lv_nomrep                             varchar2(30) := null;
    lv_nomarc                             varchar2(250) := null;
    lv_archivos                           varchar2(4000) := null;
    vblob                                 BLOB;
    ll_mensaje                            clob;
    agencia                               varchar2(100);
    tasa_actual                           number;
    tasa_propuesta                        number;
    porcentaje_ajuste                     number;
    motivo_analista                       varchar2(1000);
    fecha_gestion                         date;
    descripcion_usuario                   varchar2(200);
    analista                              varchar2(200);
    monto                                 number;
    ve_sucursal                           number;
    ve_modulo                             number;
    ve_moneda                             number;
    ve_papel                              number;
    ve_suboperacion                       number;
    ve_tipooperacion                      number;
    plazo                                 number;
    garantia                              varchar2(40);
    destino                               varchar2(40);
    tiene_garantia                        varchar2(40);
    no_tiene_garantia                     varchar2(40);
    x                                     NUMBER;
    tamanio_archivo                       number;
    len                                   number;
    vstart                                NUMBER := 1;
    bytelen                               NUMBER := 32000;
    my_vr                                 RAW(32000);
    delegado_gerente_creditos             varchar2(40);
    delegado_gerente_creditos_descripcion varchar2(200);
    segmento                              varchar2(140);
    conc_correos_del                      varchar(500);
    contador_delegados                    number;
    usuario_aprobo                        varchar(100);
    usuario_finalizo                      varchar2(200);
    descripcion_usuario_finalizo          varchar(200);
    vi_correo_analista                    varchar(100);
    vi_correo_finalizo                    varchar2(100);
    lv_pgfape                             date; --eninah 18/08/2023
  
    cursor cursor_delegado_gerente(ve_gerente char, ve_fecha date) is
      select aqpc501del
        from aqpc501
       where aqpc501usr = rpad(ve_gerente, 10, ' ')
         and ve_fecha between aqpc501ini and aqpc501fin; -- eninah 18/08/2023
  
  BEGIN
    cod_error         := '';
    tiene_garantia    := '';
    no_tiene_garantia := '';
    vstart            := 1;
    bytelen           := 32000;
  
    begin
      select pgfape into lv_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select replace(tp1desc, ' ', '')
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := lv_remitente || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
  
    begin
      select sng057usr
        into gerente_creditos
        from sng057
       where sng055car = 230;
    exception
      when others then
        null;
    end;
  
    begin
      select (select scnom
                from fst001 f
               where f. sucurs = ubsuc
                 and f.pgcod = 1)
        into descripcion_agencia
        from fst046
       where ubuser = rpad(ve_usuario, 10, ' ')
         and pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correoa
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(gerente_creditos, 30, ' ');
    exception
      when others then
        vi_correoa := '';
    end;
  
    begin
      select ubnom
        into gerente_creditos
        from fst746
       where ubuser = rpad(gerente_creditos, 10, ' ');
    exception
      when others then
        null;
    END;
  
    begin
      select pendoc
        into numero_documento
        from fsr008
       where ctnro = ve_cuenta
         and pgcod = 1
         and cttfir = 'T';
    exception
      when others then
        null;
    END;
  
    begin
      select scnom
        into agencia
        from fst046 fs
       inner join fst001 f
          on ubsuc = sucurs
         and f.pgcod = 1
       where ubuser = rpad(ve_usuario, 10, ' ')
         and fs.pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      select aqpc564cli,
             aqpc564arc,
             aqpc564tea,
             AQPC564TEAPRO, --aqpc564tpr, 08/09/2023 eninah
             AQPC564PAPRO, --aqpc564paj, 13/09/2023 eninah
             aqpc564mot,
             aqpc564fec,
             aqpc564usu,
             aqpc564des,
             aqpc564gar,
             dbms_lob.getlength(aqpc564car),
             aqpc564seg,
             aqpc564uop,
             aqpc564ufi
        into nombre_cliente,
             lv_archivos,
             tasa_actual,
             tasa_propuesta,
             porcentaje_ajuste,
             motivo_analista,
             fecha_gestion,
             analista,
             destino,
             garantia,
             tamanio_archivo,
             segmento,
             usuario_aprobo,
             usuario_finalizo
        from aqpc564
       where aqpc564cue = ve_cuenta
         and aqpc564ope = ve_operacion
         and aqpc564ins = ve_instancia
         and aqpc564eha = 'H';
      dbms_lob.createtemporary(ll_mensaje, TRUE);
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correo_del
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(usuario_aprobo, 30, ' ');
    exception
      when others then
        vi_correo_del := '';
    end;
  
    --Descripcion delegado que aprobo gestion
    begin
      select ubnom
        into delegado_gerente_creditos_descripcion
        from fst746
       where ubuser = rpad(usuario_aprobo, 10, ' ');
    exception
      when others then
        null;
    end;
  
    If garantia = 'No tiene Hipoteca' then
      no_tiene_garantia := 'X';
    Else
      tiene_garantia := 'X';
    End if;
  
    begin
      select ubnom
        into descripcion_usuario
        from fst746
       where ubuser = analista;
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correo_analista
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(analista, 30, ' ');
    exception
      when others then
        vi_correo_analista := '';
    end;
  
    begin
      select ubnom
        into descripcion_usuario_finalizo
        from fst746
       where ubuser = rpad(usuario_finalizo, 10, ' ');
    exception
      when others then
        null;
    END;
  
    begin
      select w.wfusremail
        into vi_correo_finalizo
        from WFUSERS W
       WHERE W.WFUSRCOD = rpad(usuario_finalizo, 30, ' ');
    exception
      when others then
        vi_correo_finalizo := '';
    end;
  
    begin
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_obtener_clave_credito(ve_instancia,
                                                                ve_cuenta,
                                                                ve_operacion,
                                                                ve_sucursal,
                                                                ve_modulo,
                                                                ve_moneda,
                                                                ve_papel,
                                                                ve_suboperacion,
                                                                ve_tipooperacion);
    exception
      when others then
        null;
    END;
  
    begin
      select XllCapital
        into monto
        from X054023
       Where XllPgcod = 1
         and XllAomod = ve_modulo
         and XllAosuc = ve_sucursal
         and XllAomda = ve_moneda
         and XllAopap = ve_papel
         and XllAocta = ve_cuenta
         and XllAooper = ve_operacion
         and XllAosbop = ve_suboperacion
         and XllAotop = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    begin
      select Aopzo
        into plazo
        from FSD010
       Where Pgcod = 1
         and Aomod = ve_modulo
         and Aosuc = ve_sucursal
         and Aomda = ve_moneda
         and Aopap = ve_papel
         and Aocta = ve_cuenta
         and Aooper = ve_operacion
         and Aosbop = ve_suboperacion
         and Aotope = ve_tipooperacion;
    exception
      when others then
        null;
    END;
  
    if usuario_aprobo is not null or replace(usuario_aprobo, ' ', '') != '' then
      lv_delegado := ' y delegado ' ||
                     delegado_gerente_creditos_descripcion ||
                     ' informarle lo siguiente: ';
    else
      lv_delegado := '';
    End if;
  
    lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 13px;">Estimado(a) gerente de creditos ' ||
                  gerente_creditos || ' usuario que realizo la gestion ' ||
                  descripcion_usuario || lv_delegado || '</p>' ||
                  '<p "font-family: Arial, sans-serif; font-size: 13px;">El usuario ' ||
                  descripcion_usuario_finalizo ||
                  ' finalizo la gestion de la cuenta-operacion: ' ||
                  ve_cuenta || '- ' || ve_Operacion;
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 13px;}</style>' ||
                  '<table cellspacing=0 cellpadding=3 width=900 border="1">';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '<tr>' ||
                  '<td colspan="4" style="text-align:center; background-color:#D1CCCB"> <b>PROPUESTA DE NEGOCIACION DE TASA EFECTIVA ANUAL HASTA -10% </b></td> ' ||
                  '</tr>' ||
                 
                  '<tr >' || '<td colspan = "4" ></td> ' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "2"></td>' ||
                  '<td><b>FECHA DE SOLICITUD</b></td>' || '<td>' ||
                  fecha_gestion || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td colspan = "4"></td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cliente</b></td>' ||
                  '<td colspan ="3">' || nombre_cliente || '</td>' ||
                  '</tr>' || '<tr>' ||
                  '<td><b>Analista Responsable</b></td>' || '<td>' ||
                  descripcion_usuario || '</td>' ||
                  '<td><b>Agencia</b></td>' || '<td>' || agencia || '</td>' ||
                  '</tr>' ||
                 
                  '<tr>' || '<td><b>Segmento</b></td>' || '<td>' ||
                  segmento || '</td>' || '<td><b>Monto</b></td>' || '<td>' ||
                  monto || '</td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Cuenta Cliente</b></td>' || '<td>' ||
                  ve_cuenta || '</td>' ||
                  '<td><b>Solicitud (Instancia)</b></td>' || '<td>' ||
                  ve_instancia || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>TEA Pizarra</b></td>' || '<td>' ||
                  tasa_actual || '%</td>' || '<td><b>% DE AJUSTE</b></td>' ||
                  '<td>' || porcentaje_ajuste || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Plazo</b></td>' || '<td>' || plazo ||
                  ' </td>' || '<td><b>TASA APROBADA</b></td>' || '<td>' ||
                  tasa_propuesta || '% </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Producto</b></td>' ||
                  '<td colspan="3">' || destino || ' </td>' || '</tr>' ||
                 
                  '<tr>' || '<td><b>Garantias</b></td>' ||
                  '<td><b>Hipoteca</b></td>' ||
                  '<td style="width:20%"> Si (' || tiene_garantia ||
                  ')</td>' || '<td> No (' || no_tiene_garantia || ')</td>' ||
                  '</tr>' ||
                 
                  '<tr>' ||
                  '<td style="width:20%"><b> Motivo por el que se realizo la gestion</b>' ||
                  '</td>' || '<td>' || motivo_analista || ' </td> ' ||
                  '<td><b>Documentos sustentarios que se adjutan</b></td>' ||
                  '<td>' || lv_archivos || '</td>' || '</tr>';
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    lv_mensaje := '</table>';
  
    begin
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    exception
      when others then
        null;
    END;
  
    begin
      lv_nomrep := 'DT_NEGOCIACION_TEA';
      l_output  := utl_file.fopen(lv_nomrep, lv_archivos, 'wb', 32767);
    exception
      when others then
        null;
    END;
    begin
      select aqpc564car
        into vblob
        from aqpc564
       where aqpc564cue = ve_cuenta
         and aqpc564ope = ve_operacion
         and aqpc564ins = ve_instancia
         and aqpc564eha = 'H';
    exception
      when others then
        null;
    END;
  
    len := tamanio_archivo;
    x   := len;
  
    If len < 32760 then
      utl_file.put_raw(l_output, vblob);
      utl_file.fflush(l_output);
    Else
      -- write in pieces
      vstart := 1;
      While vstart < len and bytelen > 0 Loop
        dbms_lob.read(vblob, bytelen, vstart, my_vr);
      
        utl_file.put_raw(l_output, my_vr);
        utl_file.fflush(l_output);
      
        -- set the start position for the next cut
        vstart := vstart + bytelen;
      
        -- set the end position if less than 32000 bytes
        x := x - bytelen;
        If x < 32000 Then
          bytelen := x;
        End If;
      End Loop;
      utl_file.fclose(l_output);
    End If;
  
    conc_correos_del := trim(conc_correos_del);
  
    if contador_delegados > 1 then
      conc_correos_del := lpad(conc_correos_del,
                               LENGTH(conc_correos_del) - 1);
    end if;
  
    BEGIN
      SELECT MAX(AQPC564COR)
        INTO lv_COR
        FROM aqpc564
       WHERE AQPC564INS = ve_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    lv_ASUNTO := 'Finalizacion de negociacion para cambio de Tasa - Solcitud (Instancia): ' ||
                 ve_instancia;
  
    begin
      pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => vi_correoa, --'apachecoh@cajaarequipa.pe; katherine.perez@sesitdigital.com;', --
                                       p_DestinatariosCC   => vi_correo_del || '; ' ||
                                                              vi_correo_analista, --'hsuarez@cajaarequipa.pe; eninah@cajaarequipa.pe', --
                                       p_DestinatariosBcc  => '', --'aangles@cajaarequipa.pe', --
                                       p_Mensaje           => ll_mensaje,
                                       p_Remitente         => lv_remitente,
                                       p_Asunto            => lv_ASUNTO,
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => lv_nomrep,
                                       p_ArchivosAdjuntos  => lv_archivos,
                                       p_c_coderr          => cod_error, --000
                                       p_c_deserr          => cod_des); --riesgo
    exception
      when others then
        cod_error := '4624-';
        cod_des   := SUBSTR(sqlerrm, 1, 500);
    END;
  
    -- cambios en el if eninah 03/08/2023
    if cod_error != '' or cod_error != '000' then
      vs_respuesta := 'Si hubo errores - ' || cod_error || cod_des;
      contador     := 1;
      segundos     := 5;
    
      LOOP
        BEGIN
          INSERT INTO AQPC852
            (AQPC852COR,
             AQPC852REM,
             AQPC852DES,
             AQPC852CC,
             AQPC852CCO,
             AQPC852ASU,
             AQPC852MEN,
             AQPC852FEC,
             AQPC852USR,
             AQPC852ERROR)
          VALUES
            (lv_COR,
             lv_remitente,
             vi_correoa,
             '',
             '',
             lv_ASUNTO,
             ll_mensaje,
             sysdate,
             ve_usuario,
             vs_respuesta);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        DBMS_LOCK.SLEEP(segundos); -- continua el proceso en el intervalo de segundos.
        --Hace de nuevo el llamado al programa que envía correos.
        begin
          pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => vi_correoa, --'apachecoh@cajaarequipa.pe; katherine.perez@sesitdigital.com;', --
                                           p_DestinatariosCC   => vi_correo_del || '; ' ||
                                                                  vi_correo_analista, --'hsuarez@cajaarequipa.pe; eninah@cajaarequipa.pe', --
                                           p_DestinatariosBcc  => '', --'aangles@cajaarequipa.pe', --
                                           p_Mensaje           => ll_mensaje,
                                           p_Remitente         => lv_remitente,
                                           p_Asunto            => lv_ASUNTO,
                                           p_TipoMensaje       => 'HTML',
                                           p_Directorio        => lv_nomrep,
                                           p_ArchivosAdjuntos  => lv_archivos,
                                           p_c_coderr          => cod_error, --000
                                           p_c_deserr          => cod_des); --riesgo
        exception
          when others then
            cod_error := '4681-';
            cod_des   := SUBSTR(sqlerrm, 1, 500);
        END;
        IF contador > 4 or cod_error = '000' THEN
          EXIT; -- Salir del bucle cuando se cumpla la condición
        END IF;
        contador := contador + 1;
      END LOOP;
    Else
      vs_respuesta := 'No hubo errores';
      BEGIN
        INSERT INTO AQPC852
          (AQPC852COR,
           AQPC852REM,
           AQPC852DES,
           AQPC852CC,
           AQPC852CCO,
           AQPC852ASU,
           AQPC852MEN,
           AQPC852FEC,
           AQPC852USR,
           AQPC852ERROR)
        VALUES
          (lv_COR,
           lv_remitente,
           vi_correoa,
           '',
           '',
           lv_ASUNTO,
           ll_mensaje,
           sysdate,
           ve_usuario,
           vs_respuesta);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    End if;
  
  end sp_enviar_correo_finalizacion;

  procedure sp_cr_obtener_segmento(ve_numero_documento in varchar,
                                   ve_usuario          in varchar,
                                   ve_tipodocumento    in number,
                                   ve_pais             in number,
                                   ve_instancia        in number,
                                   ve_modulo           in number,
                                   ve_segmento         out varchar2) is
  
    vi_segmentoActual number(10);
    vi_segmento_pol   varchar2(60);
  
  begin
    begin
      pQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(ve_instancia,
                                                 vi_segmentoActual);
    exception
      when others then
        null;
    end;
  
    begin
      pQ_CR_SEG_EXCEP.SP_CR_SEGMENTACION(ve_instancia,
                                         ve_modulo,
                                         vi_segmentoActual,
                                         vi_segmento_pol);
    exception
      when others then
        null;
    end;
  
    if vi_segmento_pol = 'NO DEFINIDO' then
      begin
        select (select jaqy067ncal
                  from jaqy067
                 where jaqy067ccal = jaqz086calf)
          into ve_segmento
          from jaqz086
         where jaqz086tndoc = ve_numero_documento
           and jaqz086usr = ve_usuario
           and jaqz086tdoc = ve_tipodocumento
           and jaqz086paic = ve_pais;
      exception
        when others then
          null;
      END;
      --comentar para produccion
      --ve_segmento := 'NUEVO ORO';
    else
      ve_segmento := vi_segmento_pol;
    end if;
  end sp_cr_obtener_segmento;

  procedure sp_quitar_caracteres_especiales(ve_nombre_cliente in character,
                                            vs_nombre_salida  out character) is
  
  begin
    begin
    
      select replace(penom, 'Ñ', 'N')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
      select replace(vs_nombre_salida, 'Á', 'A')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
      select replace(vs_nombre_salida, 'É', 'E')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
      select replace(vs_nombre_salida, 'Í', 'I')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
      select replace(vs_nombre_salida, 'Ó', 'O')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
      select replace(vs_nombre_salida, 'Ú', 'U')
        into vs_nombre_salida
        from fsd001
       where pendoc = ve_nombre_cliente;
    
    exception
      when others then
        vs_nombre_salida := ve_nombre_cliente;
    end;
  
  end sp_quitar_caracteres_especiales;

  PROCEDURE sp_cargar_tasa_FSD012(pn_emp   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_tas   in number,
                                  PN_FEC   in date,
                                  PN_SALDO in number,
                                  PN_PZO   in number,
                                  PN_USER  IN VARCHAR
                                  
                                  ) IS
    VI_FECV          DATE;
    VI_PIZARRA       NUMBER(5);
    VI_DIAS_VIGENCIA NUMBER(3);
    vi_fec_invertida NUMBER(8);
    ln_FlagTasa      NUMBER(3);
    ln_cor012        number := 0;
    ln_corr          number := 0;
    lc_flag          char := 'N';
    lc_cerr          varchar2(150) := 0;
    lc_merr          varchar2(150) := 0;
  BEGIN
    --OBTENER PIZARRA
    /*
    INSERT INTO PRUEBA_LOG(pgcod, 
                               aomod ,
                               aosuc ,
                               aomda ,
                               aopap ,
                               aocta ,
                               aooper,
                               aosbop,
                               aotope,
                               fecha,
                               IMPORTE,
                               INSTANCIA,
                               TASANOMINAL,
                               msg
        ) values (PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,PN_FEC,PN_SALDO,PN_PZO,pn_tas,'PRUEBA_HAQPC517_1');
    --149 PIZARRA DEFINIDA A UTILIZAR, SE PUEDE OBTENER DE LA FPP028
    */
  
    begin
      select /*+index(F FSD01204)*/
       max(f.evcorr)
        into ln_cor012
        from fsd012 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top
      /*and f.d012co = 'S'*/
      ; --2022.03.07 se comento para que obtenga maximo correlativo 
    exception
      when others then
        ln_cor012 := 0;
    end;
  
    ln_cor012 := nvl(ln_cor012, 0);
    ln_corr   := ln_cor012 + 1;
    /* comentado hasta que se solucione lo de cambio de tasa postdesembolso.
    begin
        insert into fsd012
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
           d012co)
        
        values
          (pn_emp,
           pn_mod,
           pn_suc,
           pn_mda,
           pn_pap,
           pn_cta,
           pn_ope,
           pn_sbo,
           pn_top,
           ln_corr, --correlativo
           3, --NUEVA tasa moratoria NOMINAL #10.03.2023 cambiando de evtipo 4 a 3
           PN_FEC,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0.00,
           2, -- TIPO TASA LINEAL
           pn_tas,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0.00,
           0,
           null,
           0,
           0,
           0.00000000,
           0.00000000,
           0.00000000,
           0.00000000,
           null,
           null,
           0.00000000,
           0.00000000,
           0,
           0,
           0,
           0,
           0,
           to_date('01/01/0001', 'DD/MM/YYYY'),
           0,
           0,
           'S');      
        lc_flag := 'S';
        commit;
      exception
        when others then
          lc_flag := 'N';
          lc_cerr := sqlcode;
          lc_merr := sqlerrm;
      end;
      */
    begin
      INSERT INTO AQPB954 C
        (C.AQPB954EMP,
         C.AQPB954MOD,
         C.AQPB954SUC,
         C.AQPB954MDA,
         C.AQPB954PAP,
         C.AQPB954CTA,
         C.AQPB954OPE,
         C.AQPB954SBO,
         C.AQPB954TOP,
         C.AQPB954TCOD,
         C.AQPB954TMOD,
         C.AQPB954TPIZ,
         C.AQPB954TCTA,
         C.AQPB954TMDA,
         C.AQPB954TPAP,
         C.AQPB954TFDE,
         C.AQPB954TMTO,
         C.AQPB954TTAS,
         C.AQPB954TPFI,
         C.AQPB954TPVI,
         C.AQPB954FECR,
         C.AQPB954USUR,
         C.AQPB954TIPR,
         C.AQPB954TIPI)
      VALUES
        (PN_EMP,
         PN_MOD,
         PN_SUC,
         PN_MDA,
         PN_PAP,
         PN_CTA,
         PN_OPE,
         PN_SBO,
         PN_TOP,
         PN_EMP,
         pn_mod,
         0,
         PN_CTA,
         PN_MDA,
         PN_PAP,
         PN_FEC,
         PN_SALDO,
         1,
         0,
         'S',
         SYSDATE,
         PN_USER,
         0,
         'NT');
    exception
      when others then
        null;
    end;
    commit;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE SP_CARGAR_TASA_CUENTA(pn_emp   in number,
                                  pn_mod   in number,
                                  pn_suc   in number,
                                  pn_mda   in number,
                                  pn_pap   in number,
                                  pn_cta   in number,
                                  pn_ope   in number,
                                  pn_sbo   in number,
                                  pn_top   in number,
                                  pn_tas   in number,
                                  PN_FEC   in date,
                                  PN_SALDO in number,
                                  PN_PZO   in number,
                                  PN_USER  IN VARCHAR
                                  
                                  ) IS
    VI_FECV          DATE;
    VI_PIZARRA       NUMBER(5);
    VI_DIAS_VIGENCIA NUMBER(3);
    vi_fec_invertida NUMBER(8);
    ln_FlagTasa      NUMBER(3);
  BEGIN
    --OBTENER PIZARRA
    /*INSERT INTO PRUEBA_LOG(pgcod, 
                           aomod ,
                           aosuc ,
                           aomda ,
                           aopap ,
                           aocta ,
                           aooper,
                           aosbop,
                           aotope,
                           fecha,
                           IMPORTE,
                           INSTANCIA,
                           TASANOMINAL,
                           msg
    ) values (PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,PN_FEC,PN_SALDO,PN_PZO,pn_tas,'PRUEBA_HAQPC517_1');*/
    --149 PIZARRA DEFINIDA A UTILIZAR, SE PUEDE OBTENER DE LA FPP028
    BEGIN
      SELECT pp028defn
        INTO VI_PIZARRA
        FROM FPP028 F
       WHERE F.PP028MOD = pn_mod --FIJO
         AND F.PP028TOP = pn_top --FIJO
         AND F.PP028MDA = pn_mda
         AND F.PP028PAP = pn_pap
         AND F.PP017PAR = 17 --ES FIJO
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          VI_PIZARRA := 0;
        END;
    END;
  
    vi_fec_invertida := 99999999 - to_number(to_char(pn_fec, 'YYYYMMDD'));
    --grabar log
  
    --AGREGAR LOG DE REGISTRO, PARA VER LAS TASAS INGRESADAS DESDE ESTE MEDIO.
    BEGIN
      PQ_CR_AUTOMATIZACION_NEGOCIACION.SP_RETIRAR_TASA(PN_EMP,
                                                       PN_MOD,
                                                       PN_SUC,
                                                       PN_MDA,
                                                       PN_PAP,
                                                       PN_CTA,
                                                       PN_OPE,
                                                       PN_SBO,
                                                       pn_top,
                                                       pn_fec);
      commit;
    END;
  
    BEGIN
      INSERT INTO AQPB954 C
        (C.AQPB954EMP,
         C.AQPB954MOD,
         C.AQPB954SUC,
         C.AQPB954MDA,
         C.AQPB954PAP,
         C.AQPB954CTA,
         C.AQPB954OPE,
         C.AQPB954SBO,
         C.AQPB954TOP,
         C.AQPB954TCOD,
         C.AQPB954TMOD,
         C.AQPB954TPIZ,
         C.AQPB954TCTA,
         C.AQPB954TMDA,
         C.AQPB954TPAP,
         C.AQPB954TFDE,
         C.AQPB954TMTO,
         C.AQPB954TTAS,
         C.AQPB954TPFI,
         C.AQPB954TPVI,
         C.AQPB954FECR,
         C.AQPB954USUR,
         C.AQPB954TIPR,
         C.AQPB954TIPI)
      VALUES
        (PN_EMP,
         PN_MOD,
         PN_SUC,
         PN_MDA,
         PN_PAP,
         PN_CTA,
         PN_OPE,
         PN_SBO,
         PN_TOP,
         PN_EMP,
         pn_mod,
         VI_PIZARRA,
         PN_CTA,
         PN_MDA,
         PN_PAP,
         PN_FEC,
         PN_SALDO,
         1,
         vi_fec_invertida,
         'S',
         SYSDATE,
         PN_USER,
         0,
         'NT');
      --commit;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    ln_FlagTasa := 0;
    --GRABAR PRIMERA PIZARRA
    --FSD027
    --COLOCAR EL SALDO CAPITAL DEL CREDITO A OTORGAR LA TASA, LA FECHA DE INICIO DE VIGENCIA Y LA FECHA INVERTIDA
    --PROBAR CON FECHA 03/12/2021
    SELECT COUNT(*)
      INTO ln_FlagTasa
      FROM FSD027
     WHERE MODULO = pn_mod
       AND CTNRO = PN_CTA
       AND TPIZAR = VI_PIZARRA
       AND TPFDES = PN_FEC;
    IF ln_FlagTasa = 0 THEN
      BEGIN
        INSERT INTO FSD027 A
          (A.PGCOD,
           A.MODULO,
           A.TPIZAR,
           A.CTNRO,
           A.MONEDA,
           A.PAPEL,
           A.TPFDES,
           A.TPMTO,
           A.TPTTAS,
           A.TPFINV,
           A.TPVIG)
        VALUES
          (PN_EMP,
           pn_mod,
           VI_PIZARRA,
           PN_CTA,
           PN_MDA,
           PN_PAP,
           PN_FEC,
           PN_SALDO,
           1,
           vi_fec_invertida,
           'S');
        --commit;               
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            UPDATE FSD027 A
               SET TPVIG = 'S', TPMTO = PN_SALDO --NUEVO
             WHERE A.PGCOD = pn_emp
               AND A.MODULO = pn_mod
               AND A.TPIZAR = VI_PIZARRA
               AND A.CTNRO = pn_cta
               AND A.MONEDA = pn_mda
               AND A.PAPEL = pn_pap
               AND A.TPFDES = PN_FEC;
            --AND  A.TPVIG = 'N';               
          END;
      END;
    ELSE
      BEGIN
        UPDATE FSD027 A
           SET TPVIG = 'S', TPMTO = PN_SALDO --NUEVO
         WHERE A.PGCOD = pn_emp
           AND A.MODULO = pn_mod
           AND A.TPIZAR = VI_PIZARRA
           AND A.CTNRO = pn_cta
           AND A.MONEDA = pn_mda
           AND A.PAPEL = pn_pap
           AND A.TPFDES = PN_FEC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    --FSR027
    ln_FlagTasa := 0;
    SELECT COUNT(*)
      INTO ln_FlagTasa
      FROM FSR027
     WHERE MODULO = pn_mod
       AND CTNRO = PN_CTA
       AND TPIZAR = VI_PIZARRA
       AND TPFDES = PN_FEC;
    IF ln_FlagTasa = 0 THEN
      BEGIN
        INSERT INTO FSR027 B
          (B.PGCOD,
           B.MODULO,
           B.TPIZAR,
           B.CTNRO,
           B.MONEDA,
           B.PAPEL,
           B.TPFDES,
           B.TPMTO,
           B.TPPZO,
           B.TPTASA)
        VALUES
          (PN_EMP,
           pn_mod,
           VI_PIZARRA,
           PN_CTA,
           PN_MDA,
           PN_PAP,
           PN_FEC,
           PN_SALDO,
           99999,
           PN_TAS);
        --commit;  
      exception
        when others then
          null;
      END;
    ELSE
      BEGIN
        UPDATE FSR027 A
           SET TPMTO = PN_SALDO, TPTASA = PN_TAS --NUEVO
         WHERE A.PGCOD = pn_emp
           AND A.MODULO = pn_mod
           AND A.TPIZAR = VI_PIZARRA
           AND A.CTNRO = pn_cta
           AND A.MONEDA = pn_mda
           AND A.PAPEL = pn_pap
           AND A.TPFDES = PN_FEC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    --FSD327
    BEGIN
      SELECT tp1imp1
        INTO VI_DIAS_VIGENCIA
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11161
         AND TP1CORR1 = 100
         AND TP1CORR2 = 0
         AND TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_DIAS_VIGENCIA := 30;
    END;
    VI_FECV := PN_FEC + VI_DIAS_VIGENCIA;
    BEGIN
      INSERT INTO FSD327 B
        (B.VT1PGCOD,
         B.VT1MOD,
         B.VT1TPIZ,
         B.VT1CTNR,
         B.VT1MON,
         B.VT1PAP,
         B.VT1TPFD,
         B.VT1FCHVEN)
      VALUES
        (PN_EMP,
         pn_mod,
         VI_PIZARRA,
         PN_CTA,
         PN_MDA,
         PN_PAP,
         PN_FEC,
         VI_FECV);
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        UPDATE FSD327 B
           SET B.VT1FCHVEN = VI_FECV
         WHERE B.VT1PGCOD = pn_emp
           AND B.VT1MOD = pn_mod
           AND B.VT1TPIZ = VI_PIZARRA
           AND B.VT1CTNR = pn_cta
           AND B.VT1MON = pn_mda
           AND B.VT1PAP = pn_pap
           AND B.VT1TPFD = PN_FEC;
        commit;
    END;
    commit;
  
  END;
  PROCEDURE SP_RETIRAR_TASA(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number,
                            pn_fec in DATE) IS
    VI_FLAG       NUMBER(3);
    VI_FEC        DATE;
    VI_TIPOUPDREG NUMBER(3);
    VI_PIZARRA    NUMBER(3);
    VI_FECHAB     DATE;
    FLAG          CHAR(1);
  BEGIN
    begin
      SELECT PGFAPE INTO VI_FECHAB FROM FST017 WHERE PGCOD = 1;
    end;
    --OBTENER LA FECHA DE REGISTRO DE DESEMBOLSO
    FLAG := 'S';
    BEGIN
      SELECT MAX(AQPB954TFDE)
        INTO VI_FEC
        FROM AQPB954 A
       WHERE A.AQPB954TCOD = pn_emp
         AND A.AQPB954TMOD = pn_mod
         AND A.AQPB954TCTA = pn_cta
         AND A.AQPB954TMDA = pn_mda
         AND A.AQPB954TPAP = pn_pap
            --AND A.AQPB954TFDE = VI_FEC 
         AND A.AQPB954TPVI = 'S';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        FLAG := 'N';
    END;
    IF FLAG = 'S' THEN
      BEGIN
        SELECT a.aqpb954tpiz
          INTO VI_PIZARRA
          FROM AQPB954 A
         WHERE A.AQPB954TCOD = pn_emp
           AND A.AQPB954TMOD = pn_mod
           AND A.AQPB954TCTA = pn_cta
           AND A.AQPB954TMDA = pn_mda
           AND A.AQPB954TPAP = pn_pap
           AND A.AQPB954TFDE = VI_FEC
           AND A.AQPB954TPVI = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT A.PGCOD
          INTO VI_FLAG
          FROM FSD027 a
         WHERE A.PGCOD = pn_emp
           AND A.MODULO = pn_mod
           AND A.TPIZAR = VI_PIZARRA
           AND A.CTNRO = pn_cta
           AND A.MONEDA = pn_mda
           AND A.PAPEL = pn_pap
           AND A.TPFDES = VI_FEC
           AND A.TPVIG = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          VI_FLAG := 0;
      END;
    
    END IF;
    BEGIN
      IF VI_FLAG = 1 THEN
        update AQPB954 A
           SET A.AQPB954TPVI = 'N'
         WHERE A.AQPB954TCOD = pn_emp
           AND A.AQPB954TMOD = pn_mod
           AND A.AQPB954TCTA = pn_cta
           AND A.AQPB954TMDA = pn_mda
           AND A.AQPB954TPAP = pn_pap
           AND A.AQPB954TFDE = VI_FEC
           AND A.AQPB954TPVI = 'S';
        commit;
      
        UPDATE FSD027 A
           SET TPVIG = 'N'
         WHERE A.PGCOD = pn_emp
           AND A.MODULO = pn_mod
           AND A.TPIZAR = VI_PIZARRA
           AND A.CTNRO = pn_cta
           AND A.MONEDA = pn_mda
           AND A.PAPEL = pn_pap
           AND A.TPFDES = VI_FEC
           AND A.TPVIG = 'S';
        VI_TIPOUPDREG := 1;
      
        UPDATE FSD327 B
           SET B.VT1FCHVEN = VI_FECHAB - 1
         WHERE B.VT1PGCOD = pn_emp
           AND B.VT1MOD = pn_mod
           AND B.VT1TPIZ = VI_PIZARRA
           AND B.VT1CTNR = pn_cta
           AND B.VT1MON = pn_mda
           AND B.VT1PAP = pn_pap
           AND B.VT1TPFD = VI_FEC;
        commit;
      
        /*
        ELSE
          UPDATE FSD027 A
             SET TPVIG = 'N'
           WHERE  A.PGCOD =  pn_emp
             AND  A.MODULO=  pn_mod
             AND  A.TPIZAR=  VI_PIZARRA
             AND  A.CTNRO =  pn_cta
             AND  A.MONEDA=  pn_mda
             AND  A.PAPEL =  pn_pap
             AND  A.TPVIG = 'S';
             VI_TIPOUPDREG := 2;
        */
      END IF;
    END;
    --COLOCAR LOG DE RETIRO. DE LA TRANSACCION DE RETIRO
    BEGIN
      BEGIN
        UPDATE AQPB954 AB
           SET AB.AQPB954FECM = SYSDATE, AB.AQPB954TPVI = 'N'
         WHERE AB.AQPB954TCOD = pn_emp
           AND AB.AQPB954TMOD = pn_mod
           AND AB.AQPB954TCTA = pn_cta
           AND AB.AQPB954TMDA = pn_mda
           AND AB.AQPB954TPAP = pn_pap
           AND AB.AQPB954TFDE = VI_FEC
           AND AB.AQPB954TIPI = 'S';
      END;
      /*
        INSERT INTO
              AQPB954 C ( C.AQPB954EMP,C.AQPB954MOD,C.AQPB954SUC,
                          C.AQPB954MDA,C.AQPB954PAP,C.AQPB954CTA,
                          C.AQPB954OPE,C.AQPB954SBO,C.AQPB954TOP,
                          C.AQPB954TCOD,C.AQPB954TMOD,C.AQPB954TPIZ,
                          C.AQPB954TCTA,C.AQPB954TMDA,C.AQPB954TPAP,
                          C.AQPB954TFDE,C.AQPB954TMTO,C.AQPB954TTAS,
                          C.AQPB954TPFI,C.AQPB954TPVI,
                          C.AQPB954FECR,C.AQPB954USUR,C.AQPB954TIPR,C.AQPB954TIPI) 
              VALUES (
                       PN_EMP,PN_MOD,PN_SUC,PN_MDA,PN_PAP,PN_CTA,PN_OPE,PN_SBO,PN_TOP,
                       PN_EMP,PN_MOD,VI_PIZARRA,PN_CTA,PN_MDA,PN_PAP,PN_FEC,PN_SALDO,1,vi_fec_invertida,'N',
                       SYSDATE,PN_USER,VI_TIPOUPDREG,'R'
                     );
      */
      commit;
    END;
  
  END;

  procedure SP_CR_SALDO_CAPITAL(P_N_CUENTA    IN number,
                                P_N_OPERACION IN number,
                                P_D_FECHA     IN date,
                                P_N_PGCOD     in number,
                                P_N_AOMOD     in number,
                                P_N_AOSUC     in number,
                                P_N_AOMDA     in number,
                                P_N_AOPAP     in number,
                                P_N_AOSBOP    in number,
                                P_N_AOTOPE    in number,
                                P_F_RESULTADO out number,
                                P_F_PLAZO     out number) as
    ln_salcap number(18, 2) := 0;
    ln_cappag number(18, 2) := 0;
  
  begin
    P_F_RESULTADO := 0;
    P_F_PLAZO     := 0;
    --Credito Vigente
    BEGIN
      SELECT F.SCSDO * -1
        INTO P_F_RESULTADO
        FROM FSD011 F
       WHERE F.PGCOD = P_N_PGCOD
         AND F.SCMOD = P_N_AOMOD
         AND F.SCSUC = P_N_AOSUC
         AND F.SCMDA = P_N_AOMDA
         AND F.SCPAP = P_N_AOPAP
         AND F.SCCTA = P_N_CUENTA
         AND F.SCOPER = P_N_OPERACION
         AND F.SCSBOP = P_N_AOSBOP
         AND F.SCTOPE = P_N_AOTOPE;
    
      SELECT D.AOPZO
        INTO P_F_PLAZO
        FROM FSD010 D
       WHERE D.PGCOD = P_N_PGCOD
         AND D.AOMOD = P_N_AOMOD
         AND D.AOSUC = P_N_AOSUC
         AND D.AOMDA = P_N_AOMDA
         AND D.AOPAP = P_N_AOPAP
         AND D.AOCTA = P_N_CUENTA
         AND D.AOOPER = P_N_OPERACION
         AND D.AOSBOP = P_N_AOSBOP
         AND D.AOTOPE = P_N_AOTOPE;
    EXCEPTION
      WHEN OTHERS THEN
        P_F_RESULTADO := 0;
        P_F_PLAZO     := 0;
    END;
    --Credito en vuelo.
    BEGIN
      IF P_F_RESULTADO = 0 AND P_F_PLAZO = 0 THEN
        select XWFMONTO1, XWFPLAZO1
          into P_F_RESULTADO, P_F_PLAZO
          from xwf700 x
         where x.xwfempresa = P_N_PGCOD
           and x.xwfsucursal = P_N_AOSUC
           and x.xwfmodulo = P_N_AOMOD
           and x.xwfmoneda = P_N_AOMDA
           and x.xwfpapel = P_N_AOPAP
           and x.xwfcuenta = P_N_CUENTA
           and x.xwfoperacion = P_N_OPERACION
           and x.xwfsubope = P_N_AOSBOP
           and x.xwftipope = P_N_AOTOPE
           and xwfcar3 = '1';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  end SP_CR_SALDO_CAPITAL;
  PROCEDURE SP_CR_OBTENER_TASA_NEG(ve_emp  in number,
                                   ve_mod  in number,
                                   ve_suc  in number,
                                   ve_mda  in number,
                                   ve_pap  in number,
                                   ve_cta  in number,
                                   ve_ope  in number,
                                   ve_sbo  in number,
                                   ve_top  in number,
                                   vo_tsao out number,
                                   vo_tsan out number,
                                   vo_ttsa out number,
                                   vo_code out varchar,
                                   vo_msge out varchar
                                   
                                   ) IS
    vi_instancia XWF700.XWFPRCINS%type;
  BEGIN
    --devuelve los siguiente códigos  si hay tasa '0000' si no hay tasa '0001', si hay error '0002'
    vo_code := '0001';
    vo_msge := '';
    --OBTENGO LA INSTANCIA       
    BEGIN
      SELECT x.xwfprcins
        INTO vi_instancia
        FROM XWF700 X
       WHERE X.XWFEMPRESA = ve_emp
         AND X.XWFSUCURSAL = ve_suc
         AND X.XWFMODULO = ve_mod
         AND X.XWFMONEDA = ve_mda
         AND X.XWFPAPEL = ve_pap
         AND X.XWFCUENTA = ve_cta
         AND X.XWFOPERACION = ve_ope
         AND X.XWFSUBOPE = ve_sbo
         AND X.XWFTIPOPE = ve_top
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        vo_code := '0002';
        vo_msge := 'No se encontro el crédito';
    END;
    --BUSCO EN LA TABLA AQPC564
    BEGIN
      SELECT A.AQPC564TEA, A.AQPC564TPR, 3
        INTO vo_tsao, vo_tsan, vo_ttsa
        FROM AQPC564 A
       WHERE A.AQPC564INS = VI_INSTANCIA
         AND A.AQPC564EST = 'A'
         AND A.AQPC564EHA = 'H';
      vo_code := '0001';
      vo_msge := '';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  procedure SP_CR_OBTENER_TASA(vINST IN NUMBER, vTASA OUT NUMBER) is
    VI_EMP XWF700.XWFEMPRESA%TYPE;
    VI_SUC XWF700.XWFSUCURSAL%TYPE;
    VI_MOD XWF700.XWFMODULO%TYPE;
    VI_MDA XWF700.XWFMONEDA%TYPE;
    VI_PAP XWF700.XWFPAPEL%TYPE;
    VI_CTA XWF700.XWFCUENTA%TYPE;
    VI_OPE XWF700.XWFOPERACION%TYPE;
    VI_SBO XWF700.XWFSUBOPE%TYPE;
    VI_TOP XWF700.XWFTIPOPE%TYPE;
  
    -- OBTENER CLAVE DEL CRÉDITO --
  BEGIN
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = vINST
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- OBTENER TASA -- 
    BEGIN
      SELECT XLLTASAP
        INTO vTASA
        FROM X054023 X
       WHERE X.XLLPGCOD = VI_EMP
         AND X.XLLAOSUC = VI_SUC
         AND X.XLLAOMOD = VI_MOD
         AND X.XLLAOMDA = VI_MDA
         AND X.XLLAOPAP = VI_PAP
         AND X.XLLAOCTA = VI_CTA
         AND X.XLLAOOPER = VI_OPE
         AND X.XLLAOSBOP = VI_SBO
         AND X.XLLAOTOP = VI_TOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --INSERT INTO PRUEBA_LOG(MSG)VALUES('TASA'||VTASA||'-'||vINST);
    COMMIT;
  end SP_CR_OBTENER_TASA;

  procedure sp_cr_validar_segmento(ve_instancia in number,
                                   vo_segmento  out number,
                                   vo_coderror  out varchar,
                                   vo_msgerror  out varchar) is
    -- vo_segmento : devuelve 1 si es independiente osea PYME y 2 si es CONSUMO o dependiente.
    vi_tarea  number(4);
    VI_EXISTE number(4);
  begin
    vo_coderror := '0000';
    vo_msgerror := '';
    --VALIDAR EL ESTADO ACTUAL DEL CREDITO
    BEGIN
      SELECT W.WFTASKCOD
        INTO vi_tarea
        FROM WFWRKITEMS W
       WHERE W.WFINSPRCID = ve_instancia
         AND W.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_tarea    := 0;
        vo_coderror := '0001';
        vo_msgerror := 'Credito no esta en ninguna tarea del flujo o ya fue desembolsado.';
    END;
    BEGIN
      SELECT COUNT(*)
        INTO VI_EXISTE
        FROM SNG021
       WHERE SNG021SOL = ve_instancia
         AND SNG021TMOD = 13;
    EXCEPTION
      WHEN OTHERS THEN
        VI_EXISTE := 'N';
    END;
    IF VI_EXISTE > 0 then
      vo_segmento := 1; --DECLARAMOS QUE ES MYPE.
    END IF;
    IF vi_tarea = 3 THEN
      --OBTENER SEGMENTO DE LA SOLICITUD POR CLIENTE
      begin
        select to_number(trim(g.pae71val))
          into vo_segmento
          from fpae70 f, fpae71 g
         where f.pae51eva = g.pae51eva
           and f.pae70nro = g.pae70nro
           and f.pae70ins = ve_instancia
           and f.pae51eva in (1, 6)
           and g.pae71ite = 43;
      exception
        when too_many_rows then
          begin
            select TO_NUMBER(trim(g.pae71val))
              into vo_segmento
              from fpae70 f, fpae71 g
             where f.pae51eva = g.pae51eva
               and f.pae70nro = g.pae70nro
               and f.pae70ins = ve_instancia
               and f.pae51eva in (1, 6)
               and g.pae71ite = 43
               and f.pae70nro = (select max(f.pae70nro)
                                   from fpae70 f
                                  where f.pae70ins = ve_instancia
                                    and f.pae51eva in (1, 6));
          end;
        when others then
          pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ve_instancia,
                                                         vo_segmento);
      end;
    END IF;
    IF vi_tarea = 7 THEN
      begin
        select to_number(trim(g.pae71val))
          into vo_segmento
          from fpae70 f, fpae71 g
         where f.pae51eva = g.pae51eva
           and f.pae70nro = g.pae70nro
           and f.pae70ins = ve_instancia
           and f.pae51eva in (2, 6)
           and g.pae71ite = 43;
      exception
        when too_many_rows then
          begin
            select TO_NUMBER(trim(g.pae71val))
              into vo_segmento
              from fpae70 f, fpae71 g
             where f.pae51eva = g.pae51eva
               and f.pae70nro = g.pae70nro
               and f.pae70ins = ve_instancia
               and f.pae51eva in (2, 6)
               and g.pae71ite = 43
               and f.pae70nro = (select max(f.pae70nro)
                                   from fpae70 f
                                  where f.pae70ins = ve_instancia
                                    and f.pae51eva in (2, 6));
          end;
        when others then
          null;
      end;
    
    END IF;
    IF NVL(vo_segmento, 0) = 0 then
      pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia     => ve_instancia,
                                                     lc_SegmntoActual => vo_segmento);
    END IF;
  
    --BORRAR COLOCADO PARA PRUEBAS HSUAREZ@12.07.2023
    --vo_segmento := 1;
  exception
    when others then
      null;
  end sp_cr_validar_segmento;
  procedure SP_VALIDATE_WITH_REGEXP(p_str   IN VARCHAR2,
                                    p_type  IN VARCHAR2,
                                    vo_rpta out varchar) IS
    v_regexp VARCHAR2(1000) := '^([\w\s]*?)+';
    v_result NUMBER := 0;
  
  BEGIN
    CASE p_type
      WHEN 'archivos' THEN
        v_regexp := '^[a-zA-Z0-9_ ]+\.[a-zA-Z0-9]+$';
      WHEN 'alphanumeric' THEN
        v_regexp := '^([\w\s]*?)+';
      WHEN 'date_dd/mm/yyy' THEN
        v_regexp := '^([0-9]{2})\/([0-9]{2})\/([0-9]{4})';
      WHEN 'date_mm-dd-yyyy' THEN
        v_regexp := '^([0-9]{2})-([0-9]{2})-([0-9]{4})';
      WHEN 'date_yyyy-mm-dd' THEN
        v_regexp := '^([0-9]{4})-([0-9]{2})-([0-9]{2})';
      WHEN 'date_yyyy-mm' THEN
        v_regexp := '^([0-9]{4})-([0-9]{2})';
      WHEN 'date_yyyy' THEN
        v_regexp := '^[0-9]{4}';
      WHEN 'datetime_yyyy-mm-dd_hh:mm:ss' THEN
        v_regexp := '^([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})';
      WHEN 'decimal' THEN
        v_regexp := '^[-]?[0-9]+(\.[0-9]{0,2})';
      WHEN 'domain' THEN
        v_regexp := '(^(https:|http:)\/\/(www\.)?([a-zA-Z0-9\_\-\/]+\.)(com|net|org|biz|info|xyz|online|club|dev|live|space|app|site|shop|life|io|store|tech|news|media|design|guru|photography|global|rocks|today|movie|[a-z]{2,15})?(\.)?([a-z]{2,5}))';
      WHEN 'email' THEN
        v_regexp := '^(\w+)(\w\-\.+)?@(\w+)\.([a-z]{2,6}|es|aero|asia|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|movie|net|org|com\.ve|com\.ar|com\.co|com\.br|com\.cl|com\.mx|com\.pe|com\.uy|com\.py)';
      WHEN 'http' THEN
        v_regexp := '^(https:|http:)';
      WHEN 'images' THEN
        v_regexp := '([^\s]+(\.(jpe?g|png|gif|jpg)))';
      WHEN 'ipaddr' THEN
        v_regexp := '^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})';
      WHEN 'numeric' THEN
        v_regexp := '^[-]?[0-9]+';
      WHEN 'md5' THEN
        v_regexp := '[a-zA-Z0-9]{32}';
      WHEN 'sha1' THEN
        v_regexp := '[a-zA-Z0-9]{40}';
      WHEN 'sha256' THEN
        v_regexp := '[a-zA-Z0-9]{64}';
      WHEN 'onechar' THEN
        v_regexp := '^([a-zA-Z]){1}';
      WHEN 'phone' THEN
        v_regexp := '^\([0-9]{1,4}\)\s([0-9]{3}\s[0-9\-]{4})';
      WHEN 'taxinfo' THEN
        v_regexp := '^[a-zA-Z0-9\-]{1,}[a-z0-9\s\.\-]';
      WHEN 'url' THEN
        v_regexp := '(^(https:|http:)\/\/(www\.)?([a-zA-Z0-9\_\-]+\.)(com|net|org|biz|info|xyz|online|club|dev|live|space|app|site|shop|life|io|store|tech|news|media|design|guru|photography|global|rocks|today|movie|[a-z]{2,15})?(\.)?([a-z]{2,5})([a-zA-Z0-9\%\/\?\+\-\_\=\&\#]+))';
      ELSE
        v_regexp := '^([\w\s]*?)+';
    END CASE;
    SELECT REGEXP_INSTR(p_str, v_regexp) INTO v_result FROM DUAL;
    IF v_result < 0 OR v_result = 0 THEN
      vo_rpta := 'N';
    ELSE
      vo_rpta := 'S';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      --DBMS_OUTPUT.PUT_LINE('ERROR:' || ' (' || sqlcode || ') ' || sqlerrm);
      vo_rpta := null;
  END SP_VALIDATE_WITH_REGEXP;

  PROCEDURE SP_OBTENER_DATOS_RIESGOS(ve_instancia                number,
                                     vo_data_score               out varchar,
                                     vo_data_probabilidad        out number,
                                     vo_data_segmentacion_riesgo out varchar,
                                     vo_cod_error                out varchar,
                                     vo_msg_error                out varchar) IS
    vi_cuenta               number(9); --
    vi_score                varchar(50); --vo_data_score
    vi_cant                 number(9);
    vi_PRDEF                number(10, 8); --vo_data_segmentacion_riesgo
    vi_fecha_consulta_tabla date;
    vi_riesgo_letra         varchar(50);
    VI_FECHA_PROCESO        DATE;
    --
    VI_PEPAIS          FSR008.PEPAIS%TYPE;
    VI_PETDOC          FSR008.PETDOC%TYPE;
    VI_PENDOC          FSR008.PENDOC%TYPE;
    VIO_SEGMENTO       NUMBER(9);
    VI_SEGMENTO_RIESGO varchar(10);
    VI_SCORE_MYPE      varchar(100);
    VI_SCORE_CNS       varchar(100);
    VI_SEGCNS          varchar(10);
    VI_SEGMYPE         varchar(10);
    VI_PDCNS           number(10, 7);
    VI_PDMYPE          number(10, 7);
    -- LISTADO CURSOR.
    CURSOR LISTA_JAQL639_RUC(VI_FEC_PROC DATE, VI_DNI VARCHAR) IS
      SELECT *
        FROM JAQL639
       WHERE JAQL639FEPRE = VI_FEC_PROC
         AND JAQL639NURUC = trim(VI_PENDOC); --apachecoh 2023.08.03
    CURSOR LISTA_JAQL639_PERS(VI_FEC_PROC DATE, VI_DNI VARCHAR) IS
      SELECT *
        FROM JAQL639
       WHERE JAQL639FEPRE = VI_FEC_PROC
         AND JAQL639NUIDE = trim(VI_PENDOC); --apachecoh 2023.08.03
    CURSOR LISTA_JAQL640(VI_FEC_PROC DATE, VI_DNI VARCHAR) IS
      SELECT *
        FROM JAQL640
       WHERE JAQL640PTDOC = VI_PETDOC
         AND JAQL640PNDOC = VI_PENDOC
         AND JAQL640FEPRE = VI_FEC_PROC;
    --
  BEGIN
  
    -- OBTENER CUENTA
    BEGIN
      SELECT XWFCUENTA
        INTO vi_cuenta
        FROM XWF700 X
       WHERE X.XWFPRCINS = ve_instancia
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        vi_cuenta := 0;
    END;
    -- OBTENER DNI
    BEGIN
      SELECT pepais, petdoc, pendoc
        INTO VI_PEPAIS, VI_PETDOC, VI_PENDOC
        FROM FSR008
       WHERE ctnro = vi_cuenta
         AND cttfir = 'T'
         and TTCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_PEPAIS := 0;
        VI_PETDOC := 0;
        VI_PENDOC := '';
    END;
    --VALIDAR SEGMENTO DEL CLIENTE
    BEGIN
      PQ_CR_AUTOMATIZACION_NEGOCIACION.SP_OBTENER_SEGMENTO_CRD(VE_INSTANCIA,
                                                               VI_PEPAIS,
                                                               VI_PETDOC,
                                                               VI_PENDOC,
                                                               VIO_SEGMENTO);
    END;
    -- VALIDAR LOS DATOS PARA SCORING.
    BEGIN
      --VALIDAR LA INFOMACION SI EXISTE EN LA JAQL640
    
      --OBTENER LA FECHA DE ULTIMA CARGA JAQL640
      begin
        SELECT to_date(TP1DESC, 'dd/mm/rrrr')
          into VI_FECHA_PROCESO
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 2; --JAQL640
      exception
        when others then
          VI_FECHA_PROCESO := to_date('01/01/2000', 'dd/mm/rrrr');
      end;
      --OBTENER LOS VALORES Y VALIDAR SI EXISTE REGISTRO EN LA JAQL640.         
      BEGIN
        SELECT COUNT(*),
               MAX(JAQL640RIESG),
               max(JAQL640PRDEF),
               MAX(substr(JAQL640RIESG, 8, 1)),
               MAX(JAQL640SEGMEN)
          into vi_cant,
               vi_score,
               vi_PRDEF,
               vi_riesgo_letra,
               VI_SEGMENTO_RIESGO
          FROM JAQL640
         WHERE JAQL640PTDOC = VI_PETDOC
           AND JAQL640PNDOC = VI_PENDOC
           AND JAQL640FEPRE = VI_FECHA_PROCESO
           AND JAQL640SEGMEN =
               (SELECT MAX(JAQL640SEGMEN)
                  FROM JAQL640
                 WHERE JAQL640PTDOC = VI_PETDOC
                   AND JAQL640PNDOC = VI_PENDOC
                   AND JAQL640FEPRE = VI_FECHA_PROCESO);
      EXCEPTION
        WHEN OTHERS THEN
          vo_data_score               := 'SIN SCORE';
          vo_data_probabilidad        := 0;
          vo_data_segmentacion_riesgo := '';
          vi_cant                     := 0; --apachaeco 2023.08.07
      END;
      --FIN VALIDAR JAQL640 SEGMENTO Y FECHA DE PROCESO.
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --FIN VALIDACION EXISTE JAQL640
    --EN CASO DE NO EXISTIR EN LA JAQL640 VALIDAR EN LA JAQL639
    IF vi_cant = 0 THEN
      --OBTENER LA FECHA DE ULTIMA CARGA JAQL639
      begin
        SELECT to_date(TP1DESC, 'dd/mm/rrrr')
          into VI_FECHA_PROCESO
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 1; --JAQL639
      exception
        when others then
          VI_FECHA_PROCESO := to_date('01/01/2000', 'dd/mm/rrrr');
      end;
      -- VALIDAR TIPO DOCUMENTO
      VI_SCORE_MYPE := 'SIN SCORE';
      VI_SCORE_CNS  := 'SIN SCORE';
      VI_SEGCNS     := '0.'; --apachecoh 2023.08.03
      VI_SEGMYPE    := '0.'; --apachecoh 2023.08.03
      VI_PDCNS      := 0;
      VI_PDMYPE     := 0;
      --VALIDANDO EN JAQL639 PERSONA
      IF VI_PETDOC IN (21, 2, 5) THEN
        BEGIN
          FOR X IN LISTA_JAQL639_PERS(VI_FECHA_PROCESO, VI_PENDOC) LOOP
          
            IF X.JAQL639SEGMYP > VI_SEGMYPE THEN
              VI_SCORE_MYPE := X.JAQL639RIMY;
              VI_SEGMYPE    := X.JAQL639SEGMYP;
              VI_PDCNS      := X.JAQL639PDCNS;
            END IF;
          
            IF X.JAQL639SEGCON > VI_SEGCNS THEN
              VI_SCORE_CNS := X.JAQL639RICNS;
              VI_SEGCNS    := X.JAQL639SEGCON;
              VI_PDMYPE    := X.JAQL639PDMY;
            END IF;
          END LOOP;
        EXCEPTION
          WHEN OTHERS THEN
            VI_SCORE_MYPE := 'SIN SCORE';
            VI_SCORE_CNS  := 'SIN SCORE';
            VI_SEGCNS     := '0.'; --apachecoh 2023.08.03
            VI_SEGMYPE    := '0.'; --apachecoh 2023.08.03
            VI_PDCNS      := 0;
            VI_PDMYPE     := 0;
        END;
        --FIN VALIDAR TIPO DOCUMENTO  21,2,5
        -- INICIO OTROS DOCUMENTOS RUC 9 
      ELSE
        BEGIN
          FOR X IN LISTA_JAQL639_RUC(VI_FECHA_PROCESO, VI_PENDOC) LOOP
            BEGIN
            
              IF X.JAQL639SEGMYP > VI_SEGMYPE THEN
                VI_SCORE_MYPE := X.JAQL639RIMY;
                VI_SEGMYPE    := X.JAQL639SEGMYP;
                VI_PDCNS      := X.JAQL639PDCNS;
              END IF;
            
              IF X.JAQL639SEGCON > VI_SEGCNS THEN
                VI_SCORE_CNS := X.JAQL639RICNS;
                VI_SEGCNS    := X.JAQL639SEGCON;
                VI_PDMYPE    := X.JAQL639PDMY;
              END IF;
            END;
          END LOOP;
        EXCEPTION
          WHEN OTHERS THEN
            VI_SCORE_MYPE := 'SIN SCORE';
            VI_SCORE_CNS  := 'SIN SCORE';
            VI_SEGCNS     := '';
            VI_SEGMYPE    := '';
            VI_PDCNS      := 0;
            VI_PDMYPE     := 0;
        END;
      END IF;
      -- VALIDAMOS SEGMENTO DEL CLIENTE.
      IF VIO_SEGMENTO = 13 THEN
        vo_data_score               := VI_SCORE_MYPE;
        vo_data_probabilidad        := VI_PDMYPE;
        vo_data_segmentacion_riesgo := VI_SEGMYPE;
        vo_cod_error                := '0000';
        vo_msg_error                := '';
      END IF;
      IF VIO_SEGMENTO = 14 THEN
        vo_data_score               := VI_SCORE_CNS;
        vo_data_probabilidad        := VI_PDCNS;
        vo_data_segmentacion_riesgo := VI_SEGCNS;
        vo_cod_error                := '0000';
        vo_msg_error                := '';
      END IF;
      --FIN VALIDACION EN JAQL639
      -- CASO QUE EXISTA EN LA JAQL640  
    ELSE
      vo_data_score               := vi_score;
      vo_data_probabilidad        := vi_PRDEF;
      vo_data_segmentacion_riesgo := VI_SEGMENTO_RIESGO;
      vo_cod_error                := '0000';
      vo_msg_error                := '';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END SP_OBTENER_DATOS_RIESGOS;

  PROCEDURE SP_OBTENER_SEGMENTO_CRD(VE_INSTANCIA NUMBER,
                                    VI_PEPAIS    NUMBER,
                                    VI_PETDOC    NUMBER,
                                    VI_PENDOC    CHAR,
                                    VIO_SEGMENTO OUT NUMBER) IS
    VI_CODSEGMENTO NUMBER(9);
  BEGIN
    BEGIN
      SELECT SNG021TMOD
        INTO VI_CODSEGMENTO
        FROM SNG021
       WHERE SNG021SOL = VE_INSTANCIA;
      VIO_SEGMENTO := VI_CODSEGMENTO;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          PQ_CR_RTE_VERIFICASEGMENTO.sp_cr_SegmntoActual(VE_INSTANCIA,
                                                         VI_CODSEGMENTO);
          IF VI_CODSEGMENTO = 1 THEN
            VIO_SEGMENTO := 13;
          ELSE
            VIO_SEGMENTO := 14;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            VI_CODSEGMENTO := 0;
        END;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      VI_CODSEGMENTO := 0;
  END SP_OBTENER_SEGMENTO_CRD;
  ---------------------

  procedure sp_cr_obtener_datos_reporteAQPC519(fechainicio in date,
                                               fechafinal  in date) is
  
  begin
  
    begin
      delete from aqpc595;
      commit;
    exception
      when others then
        null;
    end;
  
    DECLARE
      CURSOR mi_cursor IS
        select aqpc564cor,
               aqpc564fec,
               aqpc564hor,
               aqpc564u512,
               aqpc564est,
               aqpc564estr,
               aqpc564fop,
               aqpc564hca,
               aqpc564opi,
               aqpc564u517,
               aqpc564cli,
               aqpc564age,
               aqpc564map,
               aqpc564seg,
               aqpc564cue,
               aqpc564ope,
               aqpc564ins,
               aqpc564tea,
               aqpc564paj,
               aqpc564tpr,
               aqpc564des,
               aqpc564gar,
               aqpc564mot,
               aqpc564arc,
               aqpc564eha,
               aqpc564anali,
               aqpc564gerag,
               aqpc564sco,
               aqpc564pdef,
               aqpc564srsgo,
               AQPC564UFI,
               AQPC564FFI,
               AQPC564HFI,
               AQPC564PAPRO,
               AQPC564TEAPRO,
               AQPC564OPIRE,
               AQPC564TIPOO,
               AQPC564PRFPA,
               AQPC564CARGO,
               AQPC564USRPA,
               AQPC564CMTPA,
               AQPC564FPAPR,
               AQPC564HPAPR,
               AQPC564TPAPR,
               AQPC564PPAPR
          from AQPC564
         where aqpc564fec >= fechainicio
           and aqpc564fec <= fechafinal;
    
    begin
      FOR V_FILA_1 in mi_cursor LOOP
        --inserta en la tabla temporal
        begin
          insert into AQPC595
            (aqpc595cor,
             aqpc595fec,
             aqpc595hor,
             aqpc595u512,
             aqpc595est,
             aqpc595estr,
             aqpc595fop,
             aqpc595hca,
             aqpc595opi,
             aqpc595u517,
             aqpc595cli,
             aqpc595age,
             aqpc595map,
             aqpc595seg,
             aqpc595cue,
             aqpc595ope,
             aqpc595ins,
             aqpc595tea,
             aqpc595paj,
             aqpc595tpr,
             aqpc595des,
             aqpc595gar,
             aqpc595mot,
             aqpc595arc,
             aqpc595eha,
             aqpc595anali,
             aqpc595gerag,
             aqpc595sco,
             aqpc595pdef,
             aqpc595srsgo,
             AQPC595UFI,
             AQPC595FFI,
             AQPC595HFI,
             AQPC595PAPRO,
             AQPC595TEAPRO,
             AQPC595OPIRE,
             AQPC595TIPOO,
             AQPC595PRFPA,
             AQPC595CARGO,
             AQPC595USRPA,
             AQPC595CMTPA,
             AQPC595FPAPR,
             AQPC595HPAPR,
             AQPC595TPAPR,
             AQPC595PPAPR)
          values
            (V_FILA_1.aqpc564cor,
             V_FILA_1.aqpc564fec,
             V_FILA_1.aqpc564hor,
             V_FILA_1.aqpc564u512,
             V_FILA_1.aqpc564est,
             V_FILA_1.aqpc564estr,
             V_FILA_1.aqpc564fop,
             V_FILA_1.aqpc564hca,
             V_FILA_1.aqpc564opi,
             V_FILA_1.aqpc564u517,
             V_FILA_1.aqpc564cli,
             V_FILA_1.aqpc564age,
             V_FILA_1.aqpc564map,
             V_FILA_1.aqpc564seg,
             V_FILA_1.aqpc564cue,
             V_FILA_1.aqpc564ope,
             V_FILA_1.aqpc564ins,
             V_FILA_1.aqpc564tea,
             V_FILA_1.aqpc564paj,
             V_FILA_1.aqpc564tpr,
             V_FILA_1.aqpc564des,
             V_FILA_1.aqpc564gar,
             V_FILA_1.aqpc564mot,
             V_FILA_1.aqpc564arc,
             V_FILA_1.aqpc564eha,
             V_FILA_1.aqpc564anali,
             V_FILA_1.aqpc564gerag,
             V_FILA_1.aqpc564sco,
             V_FILA_1.aqpc564pdef,
             V_FILA_1.aqpc564srsgo,
             V_FILA_1.AQPC564UFI,
             V_FILA_1.AQPC564FFI,
             V_FILA_1.AQPC564HFI,
             V_FILA_1.AQPC564PAPRO,
             V_FILA_1.AQPC564TEAPRO,
             V_FILA_1.AQPC564OPIRE,
             V_FILA_1.AQPC564TIPOO,
             V_FILA_1.AQPC564PRFPA,
             V_FILA_1.AQPC564CARGO,
             V_FILA_1.AQPC564USRPA,
             V_FILA_1.AQPC564CMTPA,
             V_FILA_1.AQPC564FPAPR,
             V_FILA_1.AQPC564HPAPR,
             V_FILA_1.AQPC564TPAPR,
             V_FILA_1.AQPC564PPAPR);
          commit;
        exception
          when others then
            null;
        end;
      END LOOP;
    End;
  end sp_cr_obtener_datos_reporteAQPC519;

  procedure sp_validar_campania(instancia IN NUMBER, rpt out varchar2) is
    cont_jaqm750 number;
    cont_jaqm80  number;
  begin
    begin
      select count(*)
        into cont_jaqm750
        from jaqm750
       where JAQM750INS = instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into cont_jaqm80
        from jaqm80
       where JAQM80SO = instancia;
    exception
      when others then
        null;
    end;
  
    If cont_jaqm750 > 1 or cont_jaqm80 > 1 then
      rpt := 'N';
    else
      rpt := 'S';
    End If;
  
  end;

  procedure sp_validar_acceso(ve_ubuser   in varchar,
                              ve_instance in number,
                              vo_acceso   out varchar,
                              vo_cargo    out number,
                              vo_perfil   out varchar) is
    --VARIABLES
    VO_USUARIO         CHAR(10);
    VO_USUARIOSUP      CHAR(10);
    VI_SUCURSAL        XWF700.XWFSUCURSAL%TYPE;
    VI_CARGO           SNG057.SNG055CAR%TYPE;
    VI_CARGOAPRTB      SNG057.SNG055CAR%TYPE;
    VI_ESTADOSOLICITUD VARCHAR(1);
    VI_FECHA           DATE;
  
    --CURSORES
    CURSOR VALIDAR_CARGO_GUIA(VX_CARGO IN NUMBER, VX_PERFIL IN VARCHAR) IS
      SELECT TP1NRO1 VXI_COD_CARGO, TRIM(TP1DESC) VXI_PERFIL
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11175
         AND TP1CORR1 = 1
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND TP1NRO1 = VX_CARGO
         AND TP1NRO2 = 1
         AND TP1DESC = RPAD(VX_PERFIL, 30, ' ');
  
    CURSOR LISTA_PERFIL(VX_UBUSER IN VARCHAR) IS
      SELECT *
        FROM PRFU00 P
       WHERE P.PGCOD = 1
         AND P.UBUSER = RPAD(VX_UBUSER, 10, ' ');
  
  BEGIN
    --INICIALIZAMOS VARIABLES.
    vo_acceso          := 'N';
    VI_ESTADOSOLICITUD := NULL;
    VO_USUARIOSUP      := '';
    VI_CARGOAPRTB      := NULL;
    --OBTENER FECHA DEL SISTEMA
    BEGIN
      SELECT PGFAPE INTO VI_FECHA FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR CARGO PRE-APROBADOR
    BEGIN
    
      SELECT A.AQPC564CARGO, A.AQPC564EST
        INTO VI_CARGOAPRTB, VI_ESTADOSOLICITUD
        FROM AQPC564 A
       WHERE A.AQPC564INS = ve_instance
         AND A.AQPC564EST = 'P'
         AND A.AQPC564EHA = 'H';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER SUCURSAL DEL CREDITO
    BEGIN
      SELECT W.XWFSUCURSAL
        INTO VI_SUCURSAL
        FROM XWF700 W
       WHERE W.XWFPRCINS = VE_INSTANCE
         AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --OBTENER CARGO
    --VALIDAR EL CARGO DEL USUARIO
    BEGIN
      SELECT S.SNG055CAR
        INTO VI_CARGO
        FROM SNG057 S
       WHERE S.SNG055EMP = 1
         AND S.SNG057USR = RPAD(VE_UBUSER, 10, ' ');
      --AND S.SNG057AUT = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        VI_CARGO := 0;
    END;
  
    --VALIDAR GUIA PARA VER QUE PERFILES PUEDEN REALIZAR GESTION DE CAMBIO DE TASA.
    BEGIN
    
      FOR J IN LISTA_PERFIL(VE_UBUSER) LOOP
      
        FOR X IN VALIDAR_CARGO_GUIA(VI_CARGO, J.PRFGCOD) LOOP
          VO_USUARIO := '';
          --VALIDAMOS CARGO HASTA GERENTE DE AGENCIA QUE SOLO CORRESPONDEN A UNA AGENCIA
          IF VI_CARGO IN (200, 201, 202) AND VI_CARGOAPRTB IS NULL AND
             VI_ESTADOSOLICITUD IS NULL THEN
            BEGIN
              SELECT S.SNG057USR
                INTO VO_USUARIO
                FROM FST046 F4, SNG057 S, FST811 F, PRFU00 p
               WHERE F4.PGCOD = S.SNG055EMP
                 AND F4.UBUSER = S.SNG057USR
                 AND F4.UBSUC = F.OFICOD
                 AND S.SNG057USR = RPAD(VE_UBUSER, 10, ' ')
                 AND S.SNG055CAR = VI_CARGO
                 AND S.SNG057AUT = 'S'
                 AND F.PGCOD = S.SNG055EMP
                 AND F.OFICOD = VI_SUCURSAL
                 AND P.PGCOD = F4.PGCOD
                 AND P.UBUSER = F4.UBUSER
                 AND P.PRFGCOD <> rpad('CESADO', 10, ' ')
                 AND ROWNUM = 1;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
          --VALIDAMOS CARGOS SUPERIORES A GERENTE DE AGENCIA
          IF VI_CARGO > 202 THEN
            BEGIN
              PQ_CR_APROBACION_REPROG_HS.SP_VALIDAR_APROB_PERFIL(VI_CARGO,
                                                                 X.VXI_PERFIL,
                                                                 VI_SUCURSAL,
                                                                 VO_USUARIO);
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
          --VALIDAMOS SI ENCONTRAMOS USUARIO QUE CUMPLE CON EL PERFIL REQUERIDO.
          IF TRIM(VO_USUARIO) IS NOT NULL THEN
            --VALIDAMOS SI EL USUARIO A GESTIONAR ES ELMISMO QUE ESTA GESTIONANDO EL PANEL.
            IF VO_USUARIO = RPAD(VE_UBUSER, 10, ' ') THEN
              vo_acceso := 'S';
              VO_CARGO  := VI_CARGO;
              VO_PERFIL := X.VXI_PERFIL;
            ELSE
              BEGIN
                SELECT S.SNG057SUP
                  INTO VO_USUARIO
                  FROM SNG057 S
                 WHERE S.SNG055EMP = 1
                   AND S.SNG057USR = VO_USUARIO
                   AND S.SNG057INI <= VI_FECHA
                   AND S.SNG057FIN >= VI_FECHA;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              IF VO_USUARIO = RPAD(VE_UBUSER, 10, ' ') THEN
                VO_ACCESO := 'S';
                VO_CARGO  := VI_CARGO;
                VO_PERFIL := X.VXI_PERFIL;
                RETURN;
              END IF;
            END IF;
          END IF; --FIN DE VALIDACION DE USUARIO             
        END LOOP;
      END LOOP;
      --EN CASO DE NO ENCONTRAR BUSCAR SI HAY SUPLENCIA Y VALIDAR CON LA SUPLENCIA.
      IF VO_ACCESO != 'S' THEN
        BEGIN
          SELECT S.SNG057USR
            INTO VO_USUARIOSUP
            FROM SNG057 S
           WHERE S.SNG055EMP = 1
             AND S.sng057sup = RPAD(VE_UBUSER, 10, ' ')
             AND S.SNG057INI <= VI_FECHA
             AND S.SNG057FIN >= VI_FECHA
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        if TRIM(vo_usuariosup) is not null then
          PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_validar_acceso(VO_USUARIOSUP,
                                                             VE_INSTANCE,
                                                             VO_ACCESO,
                                                             vo_cargo,
                                                             vo_perfil);
        end if;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;
  PROCEDURE SP_VALIDAR_PAPROBADOR(ve_CTOperacion   IN NUMBER,
                                  ve_instance      IN NUMBER,
                                  ve_ubuser        IN VARCHAR,
                                  ve_Sucursal      IN NUMBER,
                                  vo_CargoPreApro  OUT NUMBER,
                                  vo_PerfilPreApro OUT VARCHAR,
                                  vo_UserPreApro   OUT VARCHAR,
                                  vo_Estado        OUT VARCHAR) IS
    vi_habilitado number(9);
    vi_Perfiles   varchar(30);
    vi_estado     NUMBER(17, 2);
    vo_acceso     varchar(10);
    vo_cargo      number(3);
    vo_perfil     varchar(10);
    lv_estado     number(3);
  BEGIN
    vo_estado := 'G';
  
    -- OBTENER ESTADO --
    BEGIN
      SELECT COUNT(*)
        INTO lv_ESTADO
        FROM AQPC564
       WHERE AQPC564INS = ve_instance
         AND AQPC564EST = 'R';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF lv_ESTADO < 1 THEN
      BEGIN
        SELECT TP1NRO2, TP1NRO3, TP1DESC, TP1IMP3
          INTO vo_CargoPreApro, vi_habilitado, vi_Perfiles, vi_estado
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11175
           AND TP1CORR1 = 1
           AND TP1CORR2 = 4
           AND TP1CORR3 > 0
           AND TP1NRO1 = ve_CTOperacion
           AND TP1NRO3 = 1
           AND ROWNUM = 1;
        /*INSERT INTO PRUEBA_LOG
          (PGCOD, MSG)
        VALUES
          (150, VI_PERFILES || '-' || vo_CargoPreApro);
        COMMIT;*/
        vo_PerfilPreApro := SUBSTR(TRIM(vi_Perfiles),
                                   INSTR(TRIM(vi_Perfiles), '|', -1) + 1);
      
      EXCEPTION
        WHEN OTHERS THEN
          vo_CargoPreApro := 230;
          vi_habilitado   := 1;
          vi_Perfiles     := 'GCRE01';
          vi_estado       := 0;
      END;
    ELSE
      vo_CargoPreApro := 230;
      vi_habilitado   := 1;
      vi_Perfiles     := 'GCRE01';
      vi_estado       := 0;
    END IF;
    --VALIDAMOS PERFIL DEL USUARIO
    BEGIN
      PQ_CR_AUTOMATIZACION_NEGOCIACION.sp_validar_acceso(ve_ubuser,
                                                         VE_INSTANCE,
                                                         VO_ACCESO,
                                                         vo_cargo,
                                                         vo_perfil);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAMOS EL ESTADO PARA ELLO
    if vi_estado > 0 then
      vo_Estado := 'P';
    end if;
    if vo_CargoPreApro = vo_cargo then
      if trim(vo_PerfilPreApro) = vo_perfil then
        vo_estado := 'G';
      end if;
    end if;
    --INSERT INTO PRUEBA_LOG(PGCOD,MSG)VALUES(120,vo_PerfilPreApro||'-'||vo_CargoPreApro);COMMIT; 
  END;
  PROCEDURE SP_VALIDAR_RPG_RFN(VE_INSTANCIA IN NUMBER,
                               VO_RPTA      OUT VARCHAR, -- DEVUELVE S O N, 'N' PARA BLOQUEAR.
                               VO_CODERROR  OUT VARCHAR,
                               VO_MSGERROR  OUT VARCHAR) IS
    VI_EMP        XWF700.XWFEMPRESA%TYPE;
    VI_MOD        XWF700.XWFMODULO%TYPE;
    VI_SUC        XWF700.XWFSUCURSAL%TYPE;
    VI_MDA        XWF700.XWFMONEDA%TYPE;
    VI_PAP        XWF700.XWFPAPEL%TYPE;
    VI_CTA        XWF700.XWFCUENTA%TYPE;
    VI_OPE        XWF700.XWFOPERACION%TYPE;
    VI_SBO        XWF700.XWFSUBOPE%TYPE;
    VI_TOP        XWF700.XWFTIPOPE%TYPE;
    VI_EXISTE_RFN NUMBER(3);
    VI_EXISTE_RPG NUMBER(3);
  BEGIN
    --INICIALIZO VARIABLES
    VI_EMP        := 0;
    VI_MOD        := 0;
    VI_SUC        := 0;
    VI_MDA        := 0;
    VI_PAP        := 0;
    VI_CTA        := 0;
    VI_OPE        := 0;
    VI_SBO        := 0;
    VI_TOP        := 0;
    VI_EXISTE_RFN := 0;
    VI_EXISTE_RPG := 0;
    VO_CODERROR   := '00000';
    VO_MSGERROR   := '';
    VO_RPTA       := 'S';
    BEGIN
      --OBTENER LA CLAVE DEL CREDITO ANTERIOR AL FLUJO, QUE FALTE VALIDAR.
      BEGIN
        SELECT X.XWFEMPRESA,
               X.XWFSUCURSAL,
               X.XWFMODULO,
               X.XWFMONEDA,
               X.XWFPAPEL,
               X.XWFCUENTA,
               X.XWFOPERACION,
               X.XWFSUBOPE,
               X.XWFTIPOPE
          INTO VI_EMP,
               VI_MOD,
               VI_SUC,
               VI_MDA,
               VI_PAP,
               VI_CTA,
               VI_OPE,
               VI_SBO,
               VI_TOP
          FROM XWF700 X
         WHERE X.XWFPRCINS = VE_INSTANCIA
           AND X.XWFCAR3 <> '1';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --VALIDAR SI EXISTE CASO PARA REPROGRAMADOS
      BEGIN
        select COUNT(*)
          INTO VI_EXISTE_RPG
          from fsd010 f, AQPB561 A
         where a.aqpb561emp = f.pgcod
           and a.aqpb561mod = f.aomod
           and a.aqpb561suc = f.aosuc
           and a.aqpb561mda = f.aomda
           and a.aqpb561pap = f.aopap
           and a.aqpb561cta = f.aocta
           and a.aqpb561oper = f.aooper
           and a.aqpb561sbop = f.aosbop
           and a.aqpb561top = f.aotope
           and a.aqpb561est = 'A'
           and a.aqpb561ehab = 'H'
           AND F.PGCOD = VI_EMP
           AND F.AOMOD = VI_MOD
           AND F.AOSUC = VI_SUC
           AND F.AOMDA = VI_MDA
           AND F.AOPAP = VI_PAP
           AND F.AOCTA = VI_CTA
           AND F.AOOPER = VI_OPE
           AND F.AOSBOP = VI_SBO
           AND F.AOTOPE = VI_TOP
           and f.aostat = 0;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --VALIDAR CASO PARA REFINANCIADOS
      BEGIN
        select COUNT(*)
          INTO VI_EXISTE_RFN
          from fsd010 f, AQPD154 B
         where B.AQPD154EMP = f.pgcod
           and B.aqpD154mod = f.aomod
           and B.aqpD154suc = f.aosuc
           and B.aqpD154mda = f.aomda
           and B.aqpD154pap = f.aopap
           and B.aqpD154cta = f.aocta
           and B.aqpD154ope = f.aooper
           and B.aqpD154sbop = f.aosbop
           and B.aqpD154topE = f.aotope
           and B.AQPD154ESTREG = 'C'
           AND F.PGCOD = VI_EMP
           AND F.AOMOD = VI_MOD
           AND F.AOSUC = VI_SUC
           AND F.AOMDA = VI_MDA
           AND F.AOPAP = VI_PAP
           AND F.AOCTA = VI_CTA
           AND F.AOOPER = VI_OPE
           AND F.AOSBOP = VI_SBO
           AND F.AOTOPE = VI_TOP
           and f.aostat = 0;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR VARIABLES PARA INDICAR BLOQUEO O NO.
    IF VI_EXISTE_RFN > 0 OR VI_EXISTE_RPG > 0 THEN
      VO_RPTA     := 'N';
      VO_CODERROR := '00001';
      VO_MSGERROR := 'El credito ya cuenta con una refinanciacion / Reprogramacion CAJA con beneficio';
    ELSE
      VO_RPTA := 'S';
    END IF;
  END;

  --eninah 19/02/2025
  procedure sp_cr_validar_cliente_credinka(ve_instancia in number,
                                           validador    out varchar2) is
    contador number;
  begin
    begin
      select count(*)
        into contador
        from FSR008 f, AQPB837 a, fst198 g, sng001 s
       where f.pgcod = 1
         and f.pendoc = a.aqpb837ndoc
         and s.sng001inst = ve_instancia
         and f.ctnro = s.sng001cta
         and a.AQPB837EST = 'S'
         and g.tp1cod = 1
         and g.tp1cod1 = 10847
         and g.tp1corr1 = 906
         and g.tp1corr2 = 1
         and a.aqpb837fec = to_date(g.TP1DESC, 'DD/MM/YYYY') --ld_fecha
         and a.aqpb837mto2 = 2 --no compartido
         and not exists (select 1
                from aqpd402 g, aqpd403 h
               where g.aqpd402freg = h.aqpd403freg
                 and g.aqpd402ureg = h.aqpd403ureg
                 and g.aqpd402hreg = h.aqpd403hreg
                 and g.aqpd402est = 'S'
                 and h.aqpd403ncrd = a.aqpb837var5);
    exception
      when others then
        null;
    end;
  
    if contador > 0 then
      validador := 'N';
    else
      validador := 'S';
    end if;
  end;

  procedure sp_cr_verificar_nuevo_bronce(p_cadena    IN VARCHAR2,
                                         p_resultado OUT varchar2) is
  BEGIN
    -- Convertimos la cadena a mayúsculas para evitar problemas de mayúsculas/minúsculas
    IF INSTR(UPPER(p_cadena), 'NUEVO') > 0 OR UPPER(p_cadena) = 'BRONCE' THEN
      p_resultado := 'S';
    ELSE
      p_resultado := 'N';
    END IF;
  END sp_cr_verificar_nuevo_bronce;

end PQ_CR_AUTOMATIZACION_NEGOCIACION;
/
