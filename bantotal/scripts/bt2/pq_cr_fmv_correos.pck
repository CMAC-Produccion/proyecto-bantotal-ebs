create or replace package pq_cr_fmv_correos is
  -- *****************************************************************
  -- Nombre                     : MAIL DE PAGOS EN MIVIVENDA
  -- Sistema                    : BANTOTAL
  -- Modulo                     : Creditos - Activas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2017.11.10
  -- Autor de Creacion          : HSUAREZ
  -- Uso                        : PROCESO QUE PERMITE GENERAR INFORMACION PARA EL ENVIO DE CORREOS. 
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : Instancia, tipo de pago y monto del pago de la transaccion.
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 
  -- Descripción                : 
  -- Fecha de Modificación      : 2019.08.16
  -- Autor de Modificación      : Cinthya Liz Hernandez Ortega
  -- Descripción                : Se creó procedimiento sp_mail_pagos_tp para envio de correos para techo propio
  -- Fecha de Modificación      : 2019.08.21
  -- Autor de Modificación      : Cinthya Liz Hernandez Ortega
  -- Descripción                : Se modificó procedimiento sp_mail_bath para envio de correos para techo propio en batch
   -- Fecha de Modificación      : 2019.11.18
  -- Autor de Modificación      : Karen Valencia Cornejo
  -- Descripción                : Se modificó procedimiento fn_monto_cuota para que devuelve el monto correcto de seguros
  
  -- *****************************************************************
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_pagos(p_instancia sng001.sng001inst%type,
                          tipo_pago   number,
                          mnto_pago   number /*,nrel  in number*/,
                          nSalBMS     number,
                          nIntBMS     number);
  -----------------------------------------------------------------------
  -- *****************************************************************
  -- Nombre                     : MAIL DE CREDITOS IRRECUPERABLES EN MI VIVIENDA.
  -- Sistema                    : BANTOTAL
  -- Modulo                     : Creditos - Activas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2017.11.10
  -- Autor de Creacion          : HSUAREZ
  -- Uso                        : PROCESO QUE PERMITE GENERAR INFORMACION PARA EL ENVIO DE CORREOS
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : Instancia, tipo de pago y monto del pago de la transaccion.
  --
  -- *****************************************************************
  -----------------------------------------------------------------------   
  PROCEDURE sp_mail_irrecuperable(p_instancia sng001.sng001inst%type,
                                  PItsuc1     fsd016.itsuc%type,
                                  PItmod1     fsd016.itmod%type,
                                  PIttran1    fsd016.ittran%type,
                                  PItnrel1    fsd016.itnrel%type,
                                  Pitord1     fsd016.itord%type,
                                  tipo_pago   number,
                                  mnto_pago   number /*,nrel in number*/);
  -----------------------------------------------------------------------
  -- *****************************************************************
  -- Nombre                     : MAIL DE CREDITOS DE APROBACION DE CREDITOS EN MI VIVIENDA.
  -- Sistema                    : BANTOTAL
  -- Modulo                     : Creditos - Activas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2017.07.04
  -- Autor de Creacion          : HSUAREZ
  -- Uso                        : Realiza Calculos
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : Instancia del credito.
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_aprobacion(p_instancia sng001.sng001inst%type);
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bbp_pbp(tipo in depe301.depe301tip%type,
                                   --forma in depe301.depe301for%type,
                                   fecha in depe301.depe301fec%type,
                                   hora  in depe301.depe301hor%type);
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bms(fecha in depe152.depe152fec%type,
                               hora  in depe152.depe152hor%type);
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bfh(fecha in depe291.depe291fec%type,
                               hora  in depe291.depe291hor%type);                               
  -----------------------------------------------------------------------
  PROCEDURE sp_mail_aprobacion_cofide(p_instancia sng001.sng001inst%type,
                                      p_cuenta    xwf700.xwfcuenta%type,
                                      p_operacion xwf700.xwfoperacion%type,
                                      p_moneda    xwf700.xwfmoneda%type);
  -----------------------------------------------------------------------
  PROCEDURE sp_aprobacion_msg(flag_msg    varchar2,
                              p_instancia sng001.sng001inst%type);
  -----------------------------------------------------------------------
  -- *****************************************************************
  -- Nombre                     : PROCESO PARA EL ENVIO DE CORREOS.
  -- Sistema                    : BANTOTAL
  -- Modulo                     : Creditos - Activas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 2017.07.04
  -- Autor de Creacion          : HSUAREZ
  -- Uso                        : envia correos con los parametros recibidos de los procesos anteriores
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : 
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  procedure sp_concatena_mail(PC_ORIGEN  VARCHAR2,
                              PC_DESTINO VARCHAR2,
                              PC_TITULO  VARCHAR2,
                              --PC_MENSAJE      VARCHAR2
                              pc_mensaje clob);
  procedure sp_enviamail(PC_DE      VARCHAR2,
                         PC_AQUIEN  VARCHAR2,
                         PC_MOTIVO  VARCHAR2,
                         PC_MENSAJE VARCHAR2);
  -----------------------------------------------------------------------
  procedure sp_mail_bath(fecha date);
  -----------------------------------------------------------------------
  procedure sp_pagos_bbp_pbp(v_empresa   in xwf700.xwfempresa%type,
                             v_sucursal  in xwf700.xwfsucursal%type,
                             v_modulo    in xwf700.xwfmodulo%type,
                             v_moneda    in xwf700.xwfmoneda%type,
                             v_papel     in xwf700.xwfpapel%type,
                             v_cuenta    in xwf700.xwfcuenta%type,
                             v_operacion in xwf700.xwfoperacion%type,
                             v_subope    in xwf700.xwfsubope%type,
                             v_tipope    in xwf700.xwftipope%type,
                             v_fecha     in date,
                             --nrel        in number,
                             ln_monto_bono out xwf700.xwfmonto1%type,
                             ln_int_bono   out xwf700.xwfmonto1%type,
                             ln_total      out xwf700.xwfmonto1%type);
  ------------------------------------------------------------------------
  ------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  --ENVIO DE CORREOS CONFIG.
  ----------------------------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              );
  ----------------------------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2,
                            p_c_recipiente in varchar2,
                            subject        in varchar2,
                            fecha_proceso  in date,
                            --------------------
                            c_smtp_server in VARCHAR2,
                            port          in NUMBER,
                            host          in varchar2,
                            --------------------                            
                            v_header  in varchar2, -- Cabecera
                            c_mensaje in clob -- Detalle Excel
                            );
  Function fn_monto_cuota(PN_PGCOD in Number,
                          PN_MOD   in Number,
                          PN_SUC   in Number,
                          PN_MDA   in Number,
                          PN_PAP   in Number,
                          PN_CTA   in Number,
                          PN_OPE   in Number,
                          PN_SBO   in Number,
                          PN_TOP   in Number,
                          PD_FEC   in Date) Return Number;

  PROCEDURE sp_mail_pagos_tp(p_instancia sng001.sng001inst%type,
                             tipo_pago   number,
                             mnto_pago   number,
                             nSalBMS     number,
                             nIntBMS     number);
  PROCEDURE sp_mail_aprobacion_TP(p_instancia  sng001.sng001inst%type,
                                p_cuenta     xwf700.xwfcuenta%type,
                                p_operacion  xwf700.xwfoperacion%type,
                                p_moneda     xwf700.xwfmoneda%type                                      
                                );                               
end pq_cr_fmv_correos;
/

create or replace package body pq_cr_fmv_correos is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_mail_pagos(p_instancia sng001.sng001inst%type,
                          tipo_pago   number,
                          mnto_pago   number,
                          nSalBMS     number,
                          nIntBMS     number)
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 2.2
    -- Fecha de Creacion          : 24/09/2017
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Correos de envio en aprobacion de credito FMV.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificacion      : 16/08/2019
    -- Autor de la Modificacion   : DRODRIGUEE
    -- Descripcion de Modificacion: Correción de plazo en amortización.
    --
    -- *****************************************************************
   is
    cursor correo_destinatario is
      select tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 22
         and tp1corr2 = 1
         and tp1corr3 > 0;
    cursor modulos_mivivienda is
      select tp1nro1 modulo, tp1nro2 transaccion, tp1nro3
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11104
         and t.tp1corr1 = 1
         and t.tp1corr2 = 1
         and t.tp1corr3 > 0;
  
    titulo       varchar2(100);
    mensaje      varchar2(2500);
    li_remitente varchar2(30);
  
    flag_fmv      char;
    fecha_sistema fst017.pgfape%type;
    v_empresa     xwf700.xwfempresa%type;
    v_sucursal    xwf700.xwfsucursal%type;
    v_modulo      xwf700.xwfmodulo%type;
    v_moneda      xwf700.xwfmoneda%type;
    v_papel       xwf700.xwfpapel%type;
    v_cuenta      xwf700.xwfcuenta%type;
    v_operacion   xwf700.xwfoperacion%type;
    v_subope      xwf700.xwfsubope%type;
    v_tipope      xwf700.xwftipope%type;
    v_monto       xwf700.xwfmonto1%type;
    v_plazo       xwf700.xwfplazo1%type;
    v_plazo_amr   xwf700.xwfplazo1%type;
    ln_mtocuo     number(12, 2);
  
    v_tasa         x054023.xlltasap%type;
    v_saldo        fsd011.scsdo%type;
    v_fech_des     fsd010.aofval%type;
    v_fecha_ades   number;
    v_fecha_actual number;
  
    v_fec_ult_cuota date;
    ln_cuenta       varchar2(9);
    ln_moneda       varchar2(3);
    ln_operacion    varchar2(9);
    flag_msg        char(3);
  
    ln_bbp number;
    ln_pbp number;
  
    ln_monto_bono    xwf700.xwfmonto1%type;
    ln_int_bono      xwf700.xwfmonto1%type;
    ln_total         xwf700.xwfmonto1%type;
    ln_meses_sinbbp  number;
    vp_meses_bbp_pbp number;
    ln_dias_sinbbp   number;
    vp_dias_bbp_pbp  number;
  
    ctipo_pago number;
    lv_mensaje  varchar2(20);
  
  begin
    ctipo_pago := tipo_pago;
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope,
             x.xwfmonto1,
             x.xwfplazo1
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope,
             v_monto,
             v_plazo
        from xwf700 x
       where x.xwfprcins = p_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_empresa   := 0;
        v_sucursal  := 0;
        v_modulo    := 0;
        v_moneda    := 0;
        v_papel     := 0;
        v_cuenta    := 0;
        v_operacion := 0;
        v_subope    := 0;
        v_tipope    := 0;
        v_monto     := 0;
        v_plazo     := 0;
    end;
    begin
      select x.xlltasap
        into v_tasa
        from x054023 x
       where x.xllpgcod = v_empresa
         and x.xllaomod = v_modulo
         and x.xllaosuc = v_sucursal
         and x.xllaomda = v_moneda
         and x.xllaopap = v_papel
         and x.xllaocta = v_cuenta
         and x.xllaooper = v_operacion
         and x.xllaosbop = v_subope
         and x.xllaotop = v_tipope
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_tasa := 0;
    end;
    --SALDO DEUDOR
    begin
      select x.scsdo
        into v_saldo
        from fsd011 x
       where x.pgcod = v_empresa
         and x.scmod = v_modulo
         and x.scsuc = v_sucursal
         and x.scmda = v_moneda
         and x.scpap = v_papel
         and x.sccta = v_cuenta
         and x.scoper = v_operacion
         and x.scsbop = v_subope
         and x.sctope = v_tipope --;
         and rownum = 1; --agregado borrar
    exception
      when NO_DATA_FOUND then
        v_saldo := 0;
    end;
    --FECHA DE DESEMBOLSO
    begin
      select x.aofval, x.aopzo, x.aopzo
        into v_fech_des, v_plazo, v_plazo_amr
        from fsd010 x
       where x.pgcod = v_empresa
         and x.aomod = v_modulo
         and x.aosuc = v_sucursal
         and x.aomda = v_moneda
         and x.aopap = v_papel
         and x.aocta = v_cuenta
         and x.aooper = v_operacion
         and x.aosbop = v_subope
         and x.aotope = v_tipope
            --and x.aostat <> 99
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_fech_des := null;
    end;
  
    begin
      select pgfape into fecha_sistema from fst017 where pgcod = 1;
    end;
  
    begin
      ln_mtocuo := fn_monto_cuota(pn_pgcod => v_empresa,
                                  pn_mod   => v_modulo,
                                  pn_suc   => v_sucursal,
                                  pn_mda   => v_moneda,
                                  pn_pap   => v_papel,
                                  pn_cta   => v_cuenta,
                                  pn_ope   => v_operacion,
                                  pn_sbo   => v_subope,
                                  pn_top   => v_tipope,
                                  pd_fec   => fecha_sistema);
    exception
      when others then
        ln_mtocuo := null;
    end;
  
    --OBTENER EL NUMERO DE DIAS QUE QUEDAN DESDE LA AMORTIZACION HASTA EL FIN DEL PAGO.
    select max(d.ppfpag)
      into v_fec_ult_cuota
      from fsd601 d
     where d.pgcod = v_empresa
       and d.ppmod = v_modulo
       and d.ppsuc = v_sucursal
       and d.ppmda = v_moneda
       and d.pppap = v_papel
       and d.ppcta = v_cuenta
       and d.ppoper = v_operacion
       and d.ppsbop = v_subope
       and d.pptope = v_tipope;
    -- OBTENER PLAZO SEGUN FSD601.
    SELECT trunc(TO_DATE(v_fec_ult_cuota, 'DD/MM/YY')) -
           trunc(to_date(fecha_sistema, 'DD/MM/YY'))
      into v_plazo
      FROM DUAL;
    --
  
    --CONVERSION EN MESES DE LA FECHA DE DESEMBOLSO MENOS LA FECHA ACTUAL.
    SELECT trunc(TO_DATE(fecha_sistema, 'DD/MM/YY')) -
           trunc(to_date(v_fech_des, 'DD/MM/YY'))
      into ln_dias_sinbbp
      FROM DUAL;
    ---ADQUISISCION POR GUIA DE PROCESO DE MESES PARA NO CONSIDERAR BBP Y PBP.
    begin
      select tp1nro1
        into vp_dias_bbp_pbp
        from fst198 f8
       where f8.tp1cod = 1
         and f8.tp1cod1 = 11104
         and f8.tp1corr1 = 4
         and f8.tp1corr2 = 1
         and f8.tp1corr3 = 1;
    exception
      when NO_DATA_FOUND then
        vp_dias_bbp_pbp := 1825;
    end;
    vp_dias_bbp_pbp := 1825; --temporal hasta que se habilite la guia. //se cambio de meses a dias.
    ------------------------------
  
    ------------------------------
    --ctipo_pago:=5; -- para probar. 
    if v_saldo = 0 then
      if vp_dias_bbp_pbp > ln_dias_sinbbp then
        --CONSULTAR_PAGOS DE BPP Y PBP.
      
        pq_cr_fmv_correos.sp_pagos_bbp_pbp(v_empresa,
                                           v_sucursal,
                                           v_modulo,
                                           v_moneda,
                                           v_papel,
                                           v_cuenta,
                                           v_operacion,
                                           v_subope,
                                           v_tipope,
                                           fecha_sistema,
                                           ln_monto_bono,
                                           ln_int_bono,
                                           ln_total);
      
        begin
          select de.depe302bbp, de.depe302pbp
            into ln_bbp, ln_pbp
            from depe302 de
           where de.depe302ins = p_instancia;
        
          if ln_bbp > ln_pbp then
            ln_monto_bono := ln_bbp;
          else
            ln_monto_bono := ln_pbp;
          end if;
        
        exception
          when NO_DATA_FOUND then
            ln_bbp := 0;
            ln_pbp := 0;
        end;
      
        ctipo_pago := 3;
      else
        ctipo_pago := 2;
      end if;
    end if;
  
    ln_cuenta    := LPAD(v_cuenta, 9, 0);
    ln_moneda    := lpad(v_moneda, 3, 0);
    ln_operacion := lpad(v_operacion, 9, 0);
  
    --adicional verificar si es mi vivienda.
    flag_fmv := 'N';
    for x in modulos_mivivienda loop
      if v_modulo = x.modulo then
        flag_fmv := 'S';
      end if;
    end loop;
    if flag_fmv = 'S' then
      
      if v_tipope in (40,41) then
        lv_mensaje := 'Techo Propio';
      Else
        lv_mensaje := 'MiVivienda';
      End If;
            
      if ctipo_pago = 0 then
        titulo  := 'Credito '||lv_mensaje||' Pre pago Parcial N? ' || ln_cuenta ||
                   ln_moneda || ln_operacion;
        mensaje := 'Pre Pago Parcial efectuado al cr&#233;dito N&#176; ' ||
                   ln_cuenta || ln_moneda || ln_operacion ||
                   ', monto del Prepago ' || mnto_pago ||
                   ', nuevo saldo deudor S/' || -v_saldo ||
                   ', Segun corresponda y procedimientos vigentes, sirvase remitir a COFIDE/FMV la Carta de Solicitud';
      end if;
      if ctipo_pago = 1 then
        titulo  := 'Credito '||lv_mensaje||' Amortizado N? Credito ' || ln_cuenta ||  
                   ln_moneda || ln_operacion;
        mensaje := 'Cr&#233;dito '||lv_mensaje||' Amortizado N&#176; ' ||
                   ln_cuenta || ln_moneda || ln_operacion ||
                   ', nuevo monto de cr&#233;dito S/.' || -v_saldo ||
                   ', a plazo ' || v_plazo_amr || ' dias,con cuota de S/.' ||
                   ln_mtocuo || ' y con tasa ' || v_tasa ||
                   '%. Segun corresponda y procedimientos vigentes, sirvase remitir a COFIDE/FMV el nuevo cronograma de pagos generado por la amortizacion del cliente';
      end if;
      if ctipo_pago = 2 then
        if nSalBMS > 0 then
          titulo  := 'Pre Pago Total con BMS';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Prepago S/' || mnto_pago ||
                     ', nuevo saldo deudor S/' || -v_saldo ||
                     ', sirvase remitir segun corresponda a COFIDE/FMV la carta de Solicitud, Contrato de Compra Venta, Fecha de Cancelacion e Hipoteca. Ademas, contaba con BMS de S/' ||
                     nSalBMS || '';
        else
          titulo  := 'Pre Pago Total sin BBP';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Prepago S/' || mnto_pago ||
                     ', nuevo saldo deudor S/' || -v_saldo ||
                     ', sirvase remitir segun corresponda a COFIDE/FMV la carta de Solicitud, Contrato de Compra Venta, Fecha de Cancelacion e Hipoteca. ';
        end if;
      end if;
      if ctipo_pago = 3 then
        if nSalBMS > 0 then
          titulo  := 'Pre Pago Total con BBP y BMS';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Prepago S/' || mnto_pago ||
                     ', nuevo saldo deudor S/' || -v_saldo ||
                     ', s&#237;rvase remitir seg&#250;n corresponda a COFIDE/FMV la carta de Solicitud, Contrato de Compra Venta, Fecha de Cancelaci&#243;n e Hipoteca. Adem&#225;s, contaba con BBP de S/' ||
                     ln_monto_bono || ' y BMS de S/' || nSalBMS ||
                     ', se recuper&#243; este por S/' || ln_total ||
                     ' incluido intereses del FMV';
        else
          titulo  := 'Pre Pago Total con BBP';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Prepago S/' || mnto_pago ||
                     ', nuevo saldo deudor S/' || -v_saldo ||
                     ', s&#237;rvase remitir seg&#250;n corresponda a COFIDE/FMV la carta de Solicitud, Contrato de Compra Venta, Fecha de Cancelaci&#243;n e Hipoteca. Adem&#225;s, contaba con BBP de S/' ||
                     ln_monto_bono || ' y se recuper&#243; este por S/' ||
                     ln_total || ' incluido intereses del FMV';
        end if;
      end if;
    end if;
  
    --Se llama un proceso que envia el mensaje segun el tipo de credito aprobado sea.
    if flag_fmv = 'S' then
      if ctipo_pago < 4 then
        -- Se envia correo a traves de este proceso.
        begin
          begin
            select tp1desc
              into li_remitente
              from fst198
             where tp1cod = 1
               and tp1cod1 = 11104
               and tp1corr1 = 21
               and tp1corr2 = 1
               and tp1corr3 = 1;
          end;
          for ce in correo_destinatario loop
            pq_cr_fmv_correos.sp_concatena_mail(trim(li_remitente), --pc_origen => :pc_origen,
                                                trim(ce.tp1desc), --pc_destino => :pc_destino,
                                                titulo, --pc_titulo => :pc_titulo,
                                                mensaje --pc_mensaje => :pc_mensaje);
                                                );
          end loop;
        end;
      
        /*
        -- Se envia correo a traves de este proceso.
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'hsuarez',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        */
        --solo para pruebas
        /*
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'cjurado',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'drodriguee',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'eluna',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'bsanchez',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'rarma',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'tmaldonado',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
        
        */
      end if;
    end if;
  end sp_mail_pagos;
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_irrecuperable(p_instancia sng001.sng001inst%type,
                                  PItsuc1     fsd016.itsuc%type,
                                  PItmod1     fsd016.itmod%type,
                                  PIttran1    fsd016.ittran%type,
                                  PItnrel1    fsd016.itnrel%type,
                                  Pitord1     fsd016.itord%type,
                                  
                                  tipo_pago number,
                                  mnto_pago number /*,nrel in number*/)
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 24/09/2017
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Correos de envio en aprobacion de credito FMV.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificacion      :
    -- Autor de la Modificacion   :
    -- Descripcion de Modificacion:
    --
    -- *****************************************************************
   is
    cursor correo_destinatario is
      select tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 22
         and tp1corr2 = 1
         and tp1corr3 > 0;
    cursor montos_prejudicial(vi_rubro in fsr014.rubro%type) is
      select rrcod, rrrubr from fsr014 where rubro = vi_rubro;
  
    titulo       varchar2(100);
    mensaje      varchar2(2500);
    li_remitente varchar2(30);
  
    v_empresa   xwf700.xwfempresa%type;
    v_sucursal  xwf700.xwfsucursal%type;
    v_modulo    xwf700.xwfmodulo%type;
    v_modord    xwf700.xwfmodulo%type;
    v_moneda    xwf700.xwfmoneda%type;
    v_papel     xwf700.xwfpapel%type;
    v_cuenta    xwf700.xwfcuenta%type;
    v_operacion xwf700.xwfoperacion%type;
    v_subope    xwf700.xwfsubope%type;
    v_tipope    xwf700.xwftipope%type;
    v_monto     xwf700.xwfmonto1%type;
    v_plazo     xwf700.xwfplazo1%type;
    v_tipopeord xwf700.xwftipope%type;
  
    v_tasa         x054023.xlltasap%type;
    v_saldo        fsd011.scsdo%type;
    v_fech_des     fsd010.aofval%type;
    v_fecha_ades   number;
    v_fecha_actual number;
    fecha_sistema  date;
  
    ln_cuenta    varchar2(9);
    ln_moneda    varchar2(3);
    ln_operacion varchar2(9);
    flag_msg     char(3);
  
    ln_monto_bono    xwf700.xwfmonto1%type;
    ln_int_bono      xwf700.xwfmonto1%type;
    ln_total         xwf700.xwfmonto1%type;
    ln_meses_sinbbp  number;
    vp_meses_bbp_pbp number;
    ctipo_pago       number;
    v_rubro          fsr014.rubro%type;
    --interes
    v_penalidad       number(17, 2);
    v_int_morat       number(17, 2);
    v_int_comp_normal number(17, 2);
    v_int_comp_venc   number(17, 2);
    v_TotalInt        number(17, 2);
    --seguros
    v_seguros number(17, 2);
  
  begin
    ctipo_pago := tipo_pago;
    begin
      select d16.pgcod,
             d16.itsucd,
             d16.modulo,
             d16.moneda,
             d16.papel,
             d16.ctnro,
             d16.itoper,
             d16.itsubo,
             d16.ittope,
             d16.rubro
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope,
             v_rubro
        from fsd016 d16
       where d16.pgcod = 1
         and d16.itsuc = PItsuc1
         and d16.itmod = PItmod1
         and d16.ittran = PIttran1
         and d16.itnrel = PItnrel1
         and d16.itord = Pitord1;
    exception
      when others then
        null;
    end;
    --módulo ordinal 10 arc prl
    begin
      select d16.modulo, d16.ittope
        into v_modord, v_tipopeord
        from fsd016 d16
       where d16.pgcod = 1
         and d16.itsuc = PItsuc1
         and d16.itmod = PItmod1
         and d16.ittran = PIttran1
         and d16.itnrel = PItnrel1
         and d16.itord = 10;
    exception
      when others then
        null;
    end;
  
    --INTERES
    -- En caso se transaccion 300/390 -  este for llena los montos. //      scamos de la fsd016 //prejudicial
    if PIttran1 = 390 then
      for i in montos_prejudicial(v_rubro) loop
      
        if i.rrcod = 130 then
          --RELACION - SEGUROS SALDO
          begin
            select d.itimp1
              into v_seguros
              from fsd016 d
             where d.pgcod = 1
               and d.itsuc = PItsuc1
               and d.itmod = PItmod1
               and d.ittran = PIttran1
               and d.itnrel = PItnrel1
               and d.rubro = i.rrrubr;
          exception
            when others then
              v_seguros := 0;
          end;
        end if;
        if i.rrcod = 140 then
          --RELACION - penalidad mora
          begin
            select d.itimp1
              into v_penalidad
              from fsd016 d
             where d.pgcod = 1
               and d.itsuc = PItsuc1
               and d.itmod = PItmod1
               and d.ittran = PIttran1
               and d.itnrel = PItnrel1
               and d.rubro = i.rrrubr;
          exception
            when others then
              v_penalidad := 0;
          end;
        end if;
        if i.rrcod = 145 then
          --Interes Moratorio
          begin
            select d.itimp1
              into v_int_morat
              from fsd016 d
             where d.pgcod = 1
               and d.itsuc = PItsuc1
               and d.itmod = PItmod1
               and d.ittran = PIttran1
               and d.itnrel = PItnrel1
               and d.rubro = i.rrrubr;
          exception
            when others then
              v_int_morat := 0;
          end;
        end if;
        if i.rrcod = 147 then
          --RELACION - Interes compensatorio vencido
          begin
            select d.itimp1
              into v_int_comp_venc
              from fsd016 d
             where d.pgcod = 1
               and d.itsuc = PItsuc1
               and d.itmod = PItmod1
               and d.ittran = PIttran1
               and d.itnrel = PItnrel1
               and d.rubro = i.rrrubr;
          exception
            when others then
              v_int_comp_venc := 0;
          end;
        end if;
        if i.rrcod = 148 then
          --RELACION - Interes compensatorio normal.
          begin
            select d.itimp1
              into v_int_comp_normal
              from fsd016 d
             where d.pgcod = 1
               and d.itsuc = PItsuc1
               and d.itmod = PItmod1
               and d.ittran = PIttran1
               and d.itnrel = PItnrel1
               and d.rubro = i.rrrubr;
          exception
            when others then
              v_int_comp_normal := 0;
          end;
        end if;
      
      end loop;
    end if;
    --FIN DE TRANSACCION 30-390
  
    --En caso se transaccion 300/400 -  este for llena los montos.  //sacamos de la fsd011 --judicial
    if PIttran1 = 400 then
      for i in montos_prejudicial(v_rubro) loop
      
        if i.rrcod = 130 then
          --RELACION - SEGUROS SALDO
          begin
            select d.scsdo
              into v_seguros
              from fsd011 d
             where d.pgcod = 1
               and d.scsuc = v_sucursal
               and d.scrub = i.rrrubr
               and d.scmda = v_moneda
               and d.scpap = v_papel
               and d.sccta = v_cuenta
               and d.scoper = v_operacion
               and d.scsbop = v_subope
               and d.sctope = 0; --v_tipope
            --and d.scmod = v_modulo;
          exception
            when others then
              v_seguros := 0;
          end;
        end if;
        if i.rrcod = 140 then
          --RELACION - penalidad mora
          begin
            select d.scsdo
              into v_penalidad
              from fsd011 d
             where d.pgcod = 1
               and d.scsuc = v_sucursal
               and d.scrub = i.rrrubr
               and d.scmda = v_moneda
               and d.scpap = v_papel
               and d.sccta = v_cuenta
               and d.scoper = v_operacion
               and d.scsbop = v_subope
               and d.sctope = 0; --v_tipope
            --and d.scmod = v_modulo;
          exception
            when others then
              v_penalidad := 0;
          end;
        end if;
        if i.rrcod = 145 then
          --Interes Moratorio
          begin
            select d.scsdo
              into v_int_morat
              from fsd011 d
             where d.pgcod = 1
               and d.scsuc = v_sucursal
               and d.scrub = i.rrrubr
               and d.scmda = v_moneda
               and d.scpap = v_papel
               and d.sccta = v_cuenta
               and d.scoper = v_operacion
               and d.scsbop = v_subope
               and d.sctope = 0; --v_tipope
            --and d.scmod = v_modulo;               
          exception
            when others then
              v_int_morat := 0;
          end;
        end if;
        if i.rrcod = 147 then
          --RELACION - Interes compensatorio vencido
          begin
            select d.scsdo
              into v_int_comp_venc
              from fsd011 d
             where d.pgcod = 1
               and d.scsuc = v_sucursal
               and d.scrub = i.rrrubr
               and d.scmda = v_moneda
               and d.scpap = v_papel
               and d.sccta = v_cuenta
               and d.scoper = v_operacion
               and d.scsbop = v_subope
               and d.sctope = 0; --v_tipope
            --and d.scmod = v_modulo;
          exception
            when others then
              v_int_comp_venc := 0;
          end;
        end if;
        if i.rrcod = 148 then
          --RELACION - Interes compensatorio normal.
          begin
            select d.scsdo
              into v_int_comp_normal
              from fsd011 d
             where d.pgcod = 1
               and d.scsuc = v_sucursal
               and d.scrub = i.rrrubr
               and d.scmda = v_moneda
               and d.scpap = v_papel
               and d.sccta = v_cuenta
               and d.scoper = v_operacion
               and d.scsbop = v_subope
               and d.sctope = 0; --v_tipope
            --and d.scmod = v_modulo;
          exception
            when others then
              v_int_comp_normal := 0;
          end;
        end if;
      
      end loop;
    end if;
    --FIN  300/400
  
    --SALDO DEUDOR
    begin
      select x.scsdo
        into v_saldo
        from fsd011 x
       where x.pgcod = v_empresa
         and x.scmod = v_modulo
         and x.scsuc = v_sucursal
         and x.scmda = v_moneda
         and x.scpap = v_papel
         and x.sccta = v_cuenta
         and x.scoper = v_operacion
         and x.scsbop = v_subope
         and x.sctope = v_tipope;
    exception
      when NO_DATA_FOUND then
        v_saldo := 0;
    end;
  
    ln_cuenta    := LPAD(v_cuenta, 9, 0);
    ln_moneda    := lpad(v_moneda, 3, 0);
    ln_operacion := lpad(v_operacion, 9, 0);
    --modificar en caso se requiera: 2018.08.14 rodirgo solo modificas esto. para los intereses.
    v_TotalInt := v_int_comp_normal /*+ v_int_comp_venc + v_int_morat + v_penalidad*/
     ;
    -- fin de la modificacion.
  
    if ctipo_pago = 0 and v_modord = 111 then
      titulo  := 'Credito Mivivienda Nro. ' || ln_cuenta || ln_moneda ||
                 ln_operacion || ' estado Irrecuperable';
      mensaje := '<html>Para el cr&#233;dito N&#176; ' || ln_cuenta ||
                 ln_moneda || ln_operacion || ', con saldo deudor de  S/.' ||
                 abs(-v_saldo) || ',';
      mensaje := mensaje || ' con interes Compensatorio S/' ||
                 abs(-v_int_comp_normal) || ',';
      mensaje := mensaje || ' con interes Moratorio de S/' ||
                 abs(-v_int_morat) || ',';
      mensaje := mensaje || ' con interes Compensatorio vencido de S/' ||
                 abs(-v_int_comp_venc) || ',';
      mensaje := mensaje || ' Penalidad de Mora de S/' || abs(-v_penalidad) || ',';
    
      mensaje := mensaje || ' y seguros pendientes de S/.' ||
                 abs(-v_seguros) ||
                 ', Segun corresponda y procedimientos vigentes, se recomienda activar la Cobertura de Riesgo Crediticio, para lo cual deber&#225; preparar la siguiente documentaci&#243;n: ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Tasaci&#243;n actualizada del inmueble. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia del contrato de pr&#233;stamo hipotecario. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Liquidaci&#243;n de la Deuda. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Carta Notarial donde se indique el saldo vencido.';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia de Cargo de Demanda judicial de ejecuci&#243;n de garantia presentada al juzgado.';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia del Auto Admisorio del Juzgado.</html>';
    
    end if;

    if ctipo_pago = 1 and v_modord = 111 then
      titulo  := 'Credito Techo Propio Nro. ' || ln_cuenta || ln_moneda ||
                 ln_operacion || ' estado Irrecuperable';
      mensaje := '<html>Para el Cr&#233;dito N&#176; ' || ln_cuenta ||
                 ln_moneda || ln_operacion || ', con saldo deudor de  S/.' ||
                 abs(-v_saldo) || ',';
      mensaje := mensaje || ' con interes Compensatorio S/' ||
                 abs(-v_int_comp_normal) || ',';
      mensaje := mensaje || ' con interes Moratorio de S/' ||
                 abs(-v_int_morat) || ',';
      mensaje := mensaje || ' con interes Compensatorio vencido de S/' ||
                 abs(-v_int_comp_venc) || ',';
      mensaje := mensaje || ' Penalidad de Mora de S/' || abs(-v_penalidad) || ',';
    
      mensaje := mensaje || ' y seguros pendientes de S/.' ||
                 abs(-v_seguros) ||
                 ', Segun corresponda y procedimientos vigentes, se recomienda activar la Cobertura de Riesgo Crediticio, para lo cual deber&#225; preparar la siguiente documentaci&#243;n: ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Tasaci&#243;n actualizada del inmueble. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia del contrato de pr&#233;stamo hipotecario. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Liquidaci&#243;n de la Deuda. ';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Carta Notarial donde se indique el saldo vencido.';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia de Cargo de Demanda judicial de ejecuci&#243;n de garantia presentada al juzgado.';
      mensaje := mensaje ||
                 '<br/> &nbsp;&nbsp;&nbsp;&nbsp;&#9679;&nbsp;Copia del Auto Admisorio del Juzgado.</html>';
    
    end if;
  
    --Se llama un proceso que envia el mensaje segun el tipo de credito aprobado sea.
    -- Se envia correo a traves de este proceso.
    begin
      begin
        select tp1desc
          into li_remitente
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11104
           and tp1corr1 = 21
           and tp1corr2 = 1
           and tp1corr3 = 1;
      end;
      for ce in correo_destinatario loop
        pq_cr_fmv_correos.sp_concatena_mail(trim(li_remitente), --pc_origen => :pc_origen,
                                            trim(ce.tp1desc), --pc_destino => :pc_destino,
                                            titulo, --pc_titulo => :pc_titulo,
                                            mensaje --pc_mensaje => :pc_mensaje);
                                            );
      end loop;
    end;
    /*
    -- Se envia correo a traves de este proceso.
    pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                         'hsuarez',--pc_destino => :pc_destino,
                         titulo,--pc_titulo => :pc_titulo,
                         mensaje--pc_mensaje => :pc_mensaje);
                       );
    */
    --solo para pruebas
    /*
    pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                         'cjurado',--pc_destino => :pc_destino,
                         titulo,--pc_titulo => :pc_titulo,
                         mensaje--pc_mensaje => :pc_mensaje);
                       );
                       
                       
    pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                         'drodriguee',--pc_destino => :pc_destino,
                         titulo,--pc_titulo => :pc_titulo,
                         mensaje--pc_mensaje => :pc_mensaje);
                       );
                       
                       
    pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                         'eluna',--pc_destino => :pc_destino,
                         titulo,--pc_titulo => :pc_titulo,
                         mensaje--pc_mensaje => :pc_mensaje);
                           ); 
    pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                         'tmaldonado',--pc_destino => :pc_destino,
                         titulo,--pc_titulo => :pc_titulo,
                         mensaje--pc_mensaje => :pc_mensaje);
                           ); 
                           */
  
  end sp_mail_irrecuperable;
  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bbp_pbp(tipo in depe301.depe301tip%type,
                                   --forma in depe301.depe301for%type,
                                   fecha in depe301.depe301fec%type,
                                   hora  in depe301.depe301hor%type)
  -- *****************************************************************
    -- Nombre                     : sp_mail_factor_bbp_pbp
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 07/08/2018
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Correos de envio por modificacion del factor del BBP o PBP en FMV.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : depe301tip,depe301for,depe301fec,depe301hor,
    --
    -- Retorno                    : Envio de Correo segun guia de proceso 11004 correlativo 20
    -- Fecha de Modificacion      : 
    -- Autor de la Modificacion   : 
    -- Descripcion de Modificacion: 
    --
    -- *****************************************************************
   IS
    flag_reprog char(1);
    flag_refina char(1);
    flag_msg    char(3);
    titulo      varchar2(100);
    mensaje     varchar2(500);
    cursor correos is
      select tp1desc mail
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 20
         and tp1corr2 = 1
         and tp1corr3 > 0;
  begin
    begin
      for j in correos loop
        titulo  := 'Credito MiVivienda - Modificacion de Factores';
        mensaje := 'Buenas tardes,<br /> Se modificaron Factores o BBP/PBP para cr&#233;ditos MiViVienda. con fecha : ' ||
                   fecha || '.';
      
        -- Se envia correo a traves de este proceso.          
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv' /*notificacionesmv*/, --pc_origen => :pc_origen,
                                            trim(j.mail), --pc_destino => :pc_destino,
                                            titulo, --pc_titulo => :pc_titulo,
                                            mensaje --pc_mensaje => :pc_mensaje);
                                            );
      end loop;
    end loop;
  end sp_mail_factor_bbp_pbp;
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bms(fecha in depe152.depe152fec%type,
                               hora  in depe152.depe152hor%type) is
    titulo  varchar2(100);
    mensaje varchar2(500);
  
    cursor correos is
      select tp1desc mail
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 20
         and tp1corr2 = 1
         and tp1corr3 > 0;
  
  begin
    begin
      for j in correos loop
        titulo  := 'Credito MiVivienda - Modificacion de Factores BMS';
        mensaje := 'Buenas tardes,<br /><br /> Se modificaron los Factores BMS para cr&#233;ditos MiViVienda, con fecha ' ||
                   fecha || ', ' || hora || ' h.';
      
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',
                                            trim(j.mail),
                                            titulo,
                                            mensaje);
      end loop;
    end loop;
  end sp_mail_factor_bms;
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_factor_bfh(fecha in depe291.depe291fec%type,
                               hora  in depe291.depe291hor%type) is
    titulo  varchar2(100);
    mensaje varchar2(500);
  
    cursor correos is
      select tp1desc mail
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 20
         and tp1corr2 = 1
         and tp1corr3 > 0;
  
  begin
    begin
      for j in correos loop
        titulo  := 'Credito Techo Propio - Modificacion de Factores BFH';
        mensaje := 'Buenas tardes,<br /><br /> Se modificaron los Factores BFH para cr&#233;ditos Techo Propio, con fecha ' ||
                   fecha || ', ' || hora || ' h.';
      
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',
                                            trim(j.mail),
                                            titulo,
                                            mensaje);
      end loop;
    end loop;
  end sp_mail_factor_bfh;  
  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_aprobacion_cofide(p_instancia sng001.sng001inst%type,
                                      p_cuenta    xwf700.xwfcuenta%type,
                                      p_operacion xwf700.xwfoperacion%type,
                                      p_moneda    xwf700.xwfmoneda%type)
  -- *****************************************************************
    -- Nombre                     : sp_mail_aprobacion_cofide
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 08/08/2018
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Envio de correos por aprobacion de credito FMV por Cofide.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : Envio de Correo al analista que genero la solicitud.
    -- Fecha de Modificacion      : 
    -- Autor de la Modificacion   : 
    -- Descripcion de Modificacion: 
    --
    -- *****************************************************************
   IS
  
    titulo       varchar2(100);
    mensaje      varchar2(500);
    ln_monto     number;
    vi_monto     number;
    vi_cuota     number;
    vi_bbp       number;
    vi_pbp       number;
    vi_asesor    char(10);
    vi_origen    number;
    suplente     char(10);
    ln_cuenta    varchar2(9);
    ln_moneda    varchar2(3);
    ln_operacion varchar2(9);
  
  begin
    --ASESOR DEL CREDITO.
  
    begin
      select
       s.sng001ase, --descomentar en produccion.
       --'rarma', --solo para pruebas, comentar en produccion.
       s.sng017mto,
       s.sng001ori
        into vi_asesor, vi_monto, vi_origen
        from sng001 s
       where s.sng001inst = p_instancia;
    exception
      when no_data_found then
        vi_asesor := null;
    end;
  
    -- Script para verificar suplentes.
    if vi_asesor is not null then
      begin
        select sng057sup
          into suplente
          from sng057
         where sng057usr = vi_asesor;
      EXCEPTION
        when no_data_found then
          suplente := '';
      end;
    end if;
  
    --vi_asesor:='rarma';--solo para pruebas, comentar en produccion.
    --MONTO DEL PRESTAMO.
    if vi_origen = 0 then
      begin
        select d.depe302val, d.depe302cuo, d.depe302bbp, d.depe302pbp
          into vi_monto, vi_cuota, vi_bbp, vi_pbp
          from depe302 d
         where depe302ins = p_instancia;
      exception
        when no_data_found then
          vi_monto := null;
          vi_cuota := null;
          vi_bbp   := null;
          vi_pbp   := null;
      end;
    end if;
    begin
    
      ln_cuenta    := LPAD(p_cuenta, 9, 0);
      ln_moneda    := lpad(p_moneda, 3, 0);
      ln_operacion := lpad(p_operacion, 9, 0);
    
      titulo  := 'FMV/Cofice - Credito Aprobado';
      mensaje := '<html>El FMV/Cofide aprob&#243; el cr&#233;dito MiVivienda N&#176; ' ||
                 ln_cuenta || ln_moneda || ln_operacion || ' por S/. ' ||
                 vi_monto ||
                 ', coordine con su cliente el desembolso.</html>';
    
      -- Se envia correo a traves de este proceso.          
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv' /*notificacionesmv*/, --pc_origen => :pc_origen,
                                          trim(vi_asesor), --pc_destino => :pc_destino,
                                          titulo, --pc_titulo => :pc_titulo,
                                          mensaje --pc_mensaje => :pc_mensaje);
                                          );
      --si tubiera suplente se envia correo al suplente
      if suplente is not null then
        pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv' /*notificacionesmv*/, --pc_origen => :pc_origen,
                                            trim(suplente), --pc_destino => :pc_destino,
                                            titulo, --pc_titulo => :pc_titulo,
                                            mensaje --pc_mensaje => :pc_mensaje);
                                            );
      end if;
      /*
      --Solo para probar
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                              trim('rarma'),--pc_destino => :pc_destino,
                              titulo,--pc_titulo => :pc_titulo,
                              mensaje--pc_mensaje => :pc_mensaje);
                            );
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                              trim('hsuarez'),--pc_destino => :pc_destino,
                              titulo,--pc_titulo => :pc_titulo,
                              mensaje--pc_mensaje => :pc_mensaje);
                            );   
      */
      --Fin prueba                                                                                                          
    
    end;
  end sp_mail_aprobacion_cofide;
  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------

  ----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------
  PROCEDURE sp_mail_aprobacion(p_instancia sng001.sng001inst%type)
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 24/09/2017
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Correos de envio en aprobacion de credito FMV.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificacion      :
    -- Autor de la Modificacion   :
    -- Descripcion de Modificacion:
    --
    -- *****************************************************************
   IS
    flag_reprog char(1);
    flag_refina char(1);
    flag_msg    char(3);
  begin
    flag_reprog := 'N';
    -- Verificamos si el credito aprobado es una reprogramacion.
    begin
      select 'S'
        into flag_reprog
        from sng001
       where sng001inst = p_instancia
         and sng001ori in (13, 14, 16);
    exception
      when NO_DATA_FOUND then
        flag_reprog := 'N';
    end;
  
    --verificamos si el credito aprobado es una refinanciacion
    begin
      select 'S'
        into flag_refina
        from sng001
       where sng001inst = p_instancia
         and sng001ori in (3);
    exception
      when NO_DATA_FOUND then
        flag_refina := 'N';
    end;
    --Se almacena en un flag el tipo de credito aprobado
    if flag_reprog = 'S' then
      flag_msg := 'REP';
    else
      if flag_refina = 'S' then
        flag_msg := 'REF';
      else
        flag_msg := 'APR';
      end if;
    end if;
    --Se llama un proceso que envia el mensaje segun el tipo de credito aprobado sea.
    sp_aprobacion_msg(flag_msg, p_instancia);
  
  end sp_mail_aprobacion;
  PROCEDURE sp_aprobacion_msg(flag_msg    varchar2,
                              p_instancia sng001.sng001inst%type) is
    titulo       varchar2(100);
    mensaje      varchar2(500);
    li_remitente varchar2(30);
  
    v_empresa   xwf700.xwfempresa%type;
    v_sucursal  xwf700.xwfsucursal%type;
    v_modulo    xwf700.xwfmodulo%type;
    v_moneda    xwf700.xwfmoneda%type;
    v_papel     xwf700.xwfpapel%type;
    v_cuenta    xwf700.xwfcuenta%type;
    v_operacion xwf700.xwfoperacion%type;
    v_subope    xwf700.xwfsubope%type;
    v_tipope    xwf700.xwftipope%type;
    v_monto     xwf700.xwfmonto1%type;
    v_plazo     xwf700.xwfplazo1%type;
  
    v_tasa x054023.xlltasap%type;
  
    ln_cuenta    varchar2(9);
    ln_moneda    varchar2(3);
    ln_operacion varchar2(9);
  
    flag_enviar char(1);
    lv_mensaje  varchar2(20);
  
    cursor correo_destinatario is
      select tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11104
         and tp1corr1 = 22
         and tp1corr2 = 1
         and tp1corr3 > 0;
  
    cursor modulos_mivivienda is
      select tp1nro1 modulo, tp1nro2 transaccion, tp1nro3
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11104
         and t.tp1corr1 = 1
         and t.tp1corr2 = 1
         and t.tp1corr3 > 0;
  
  begin
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope,
             x.xwfmonto1,
             x.xwfplazo1
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope,
             v_monto,
             v_plazo
        from xwf700 x
       where x.xwfprcins = p_instancia
         and x.xwfcar3 = '1';
    exception
      when NO_DATA_FOUND then
        v_empresa   := 0;
        v_sucursal  := 0;
        v_modulo    := 0;
        v_moneda    := 0;
        v_papel     := 0;
        v_cuenta    := 0;
        v_operacion := 0;
        v_subope    := 0;
        v_tipope    := 0;
        v_monto     := 0;
        v_plazo     := 0;
      
    end;
  
    begin
      --verificamos si esta dentro de los modulos permitidos para enviar correo.
      for y in modulos_mivivienda loop
        if y.modulo = v_modulo then
          flag_enviar := 'S';
          exit;
        else
          flag_enviar := 'N';
        end if;
      end loop;
    end;
  
    if flag_enviar = 'S' then
      begin
        select x.xlltasap
          into v_tasa
          from x054023 x
         where x.xllpgcod = v_empresa
           and x.xllaomod = v_modulo
           and x.xllaosuc = v_sucursal
           and x.xllaomda = v_moneda
           and x.xllaopap = v_papel
           and x.xllaocta = v_cuenta
           and x.xllaooper = v_operacion
           and x.xllaosbop = v_subope
           and x.xllaotop = v_tipope;
      exception
        when NO_DATA_FOUND then
          v_tasa := 0;
      end;
    
      ln_cuenta    := LPAD(v_cuenta, 9, 0);
      ln_moneda    := lpad(v_moneda, 3, 0);
      ln_operacion := lpad(v_operacion, 9, 0);
      
      if v_tipope in (40,41) then
        lv_mensaje := 'Techo Propio';
      Else
        lv_mensaje := 'MiVivienda';
      End If;
        
      --Si es reprogramacion, enviar el siguiente mensaje.
      if flag_msg = 'REP' then
        titulo  := 'Credito '||lv_mensaje||' Reprogramado Nro. ' || ln_cuenta ||
                   ln_moneda || ln_operacion;
        mensaje := 'Cr&#233;dito '||lv_mensaje||' Reprogramado N&#176; ' ||
                   ln_cuenta || ln_moneda || ln_operacion ||
                   ', monto Reprogramado requiere S/. ' || v_monto ||
                   ', a plazo ' || v_plazo || ' con tasa ' || v_tasa ||
                   '%. Segun corresponda y procedimiento vigentes, sirvase remitir a COFIDE/FMV la Copia de la Solicitud firmada por el cliente con las nuevas condiciones del cr&#233;dito y formato informe de Cr&#233;dito actualizado';
      end if;
      --Si es refinanciacion, enviar el siguiente mensaje.
      if flag_msg = 'REF' then
        titulo  := 'Credito '||lv_mensaje||' Refinanciado Nro. ' || ln_cuenta ||
                   ln_moneda || ln_operacion;
        mensaje := 'Cr&#233;dito '||lv_mensaje||' Refinanciado N&#176; ' ||
                   ln_cuenta || ln_moneda || ln_operacion ||
                   ' ,monto Refinanciado requiere S/. ' || v_monto ||
                   ', a plazo ' || v_plazo || ' con tasa ' || v_tasa ||
                   '%. Segun corresponda y procedimiento vigentes, sirvase remitir a COFIDE/FMV la Copia de la Solicitud firmada por el Cliente con las nuevas condiciones del cr&#233;dito, formato informe de Cr&#233;dito actualizado, hoja resumen  de tasacion actualizado y documento con ratificacion de garantias.';
      end if;
      --Si solo es aprobacion credito normal.
      if flag_msg = 'APR' then
        titulo  := 'Credito '||lv_mensaje||' Aprobado Nro. Credito ' || ln_cuenta ||
                   ln_moneda || ln_operacion;
        mensaje := 'Cr&#233;dito '||lv_mensaje||' Aprobado N&#176; ' || ln_cuenta ||
                   ln_moneda || ln_operacion ||
                   ' , monto desembolso requiere S/. ' || v_monto ||
                   ', a plazo ' || v_plazo || ' con tasa ' || v_tasa ||
                   '%. Segun corresponda y procedimiento vigentes,, sirvase remitir a COFIDE/FMV la Carta de Solicitud Desembolso y Pagare emitido por el monto que se solicita en expediente de Cr&#233;dito';
      end if;
        
      -- Se envia correo a traves de este proceso.
      begin
        begin
          select tp1desc
            into li_remitente
            from fst198
           where tp1cod = 1
             and tp1cod1 = 11104
             and tp1corr1 = 21
             and tp1corr2 = 1
             and tp1corr3 = 1;
        end;
        for ce in correo_destinatario loop
          pq_cr_fmv_correos.sp_concatena_mail(trim(li_remitente), --pc_origen => :pc_origen,
                                              trim(ce.tp1desc), --pc_destino => :pc_destino,
                                              titulo, --pc_titulo => :pc_titulo,
                                              mensaje --pc_mensaje => :pc_mensaje);
                                              );
        end loop;
      end;

      /*
      -- Se envia correo a traves de este proceso.          
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                             'hsuarez',--pc_destino => :pc_destino,
                             titulo,--pc_titulo => :pc_titulo,
                             mensaje--pc_mensaje => :pc_mensaje);
                           );
      */
      --solo para pruebas
      /*
       pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                       'cjurado',--pc_destino => :pc_destino,
                       titulo,--pc_titulo => :pc_titulo,
                       mensaje--pc_mensaje => :pc_mensaje);
                     ); 
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                           'drodriguee',--pc_destino => :pc_destino,
                           titulo,--pc_titulo => :pc_titulo,
                           mensaje--pc_mensaje => :pc_mensaje);
                         );
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                       'eluna',--pc_destino => :pc_destino,
                       titulo,--pc_titulo => :pc_titulo,
                       mensaje--pc_mensaje => :pc_mensaje);
                         ); 
      
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                       'tmaldonado',--pc_destino => :pc_destino,
                       titulo,--pc_titulo => :pc_titulo,
                       mensaje
                       );
      pq_cr_fmv_correos.sp_concatena_mail('notificacionesmv',--pc_origen => :pc_origen,
                       'rarma',--pc_destino => :pc_destino,
                       titulo,--pc_titulo => :pc_titulo,
                       mensaje
                       );
      */
    end if;
  END sp_aprobacion_msg;

  PROCEDURE SP_CONCATENA_MAIL(PC_ORIGEN  VARCHAR2,
                              PC_DESTINO VARCHAR2,
                              PC_TITULO  VARCHAR2,
                              --PC_MENSAJE      VARCHAR2
                              pc_mensaje in clob) as
    Dominio       VARCHAR2(20) := '@cajaarequipa.pe';
    OrigenCorreo  VARCHAR2(50);
    DestinoCorreo VARCHAR2(50);
    fecha_proceso date;
  BEGIN
    BEGIN
      Select pgfape into fecha_proceso from fst017 where pgcod = 1;
    END;
    OrigenCorreo  := PC_ORIGEN || Dominio;
    DestinoCorreo := PC_DESTINO || Dominio;
    --fecha_proceso := to_char(sysdate,'dd/mm/yyyy');
    BEGIN
      --
      --pq_cr_fmv_correos.sp_enviamail(OrigenCorreo,
      --                    DestinoCorreo,
      --                    PC_TITULO,
      --                    PC_MENSAJE);
    
      pq_cr_fmv_correos.sp_cr_config_mail(OrigenCorreo, -- De    
                                          DestinoCorreo, -- Para
                                          PC_TITULO, -- Subject
                                          -------------------------                            
                                          fecha_proceso, -- Fecha de proceso
                                          --------------------                           
                                          PC_TITULO, -- Cabecera
                                          pc_mensaje -- Detalle
                                          );
    exception
      when others then
        dbms_output.put_line(sqlerrm);
    END;
  
  END;
  /*
  procedure sp_enviamail
  (
  PC_DE      VARCHAR2,
  PC_AQUIEN  VARCHAR2,
  PC_MOTIVO  VARCHAR2,
  PC_MENSAJE VARCHAR2
  )
  as
   EmailServer     VARCHAR2(80) := '10.0.200.68';
  -- EmailServer     VARCHAR2(80) := '172.18.100.13';--12.02.2015
   Port            NUMBER := 2530;
   conn            UTL_SMTP.CONNECTION;
   crlf            VARCHAR2( 2 ):= CHR( 10 ) ;
   mesg            VARCHAR2( 32000 );
   vhost_name      VARCHAR2( 100 );
   vardata raw(5000);
  BEGIN
  
    select host_name
      into vhost_name
      from v$instance;
  
  if  UPPER(vhost_name) in ('DWHBD1051') then
  --if  UPPER(vhost_name) in ('DWHBD1051xxxx') then
  --if UPPER(vhost_name) in ('BTRAC1051','BTRAC1052','DSBD1051') then
  
      conn:= utl_smtp.OPEN_CONNECTION( EmailServer, Port );
      utl_smtp.HELO( conn, EmailServer );
      utl_smtp.MAIL( conn, PC_DE);
      utl_smtp.RCPT( conn, PC_AQUIEN );
      mesg:= 'From: '    || PC_DE                                            || crlf ||
             'To: '      || PC_AQUIEN                                        || crlf ||
             'Subject: ' || PC_MOTIVO                                        || crlf ||
             ''          || crlf || PC_MENSAJE ||crlf||crlf ||'.'||crlf ;
  
      utl_smtp.OPEN_DATA(conn);
      
      UTL_smtp.write_data(conn, 'MIME-Version: ' || '1.0' || UTL_TCP.CRLF);
      UTL_smtp.write_data(conn, 'Content-Type: ' || 'text/plain; charset=iso-8859-15' || UTL_TCP.CRLF);
      UTL_smtp.write_data(conn, 'Content-Transfer-Encoding: ' || '8bit' || UTL_TCP.CRLF);
      varData := utl_raw.cast_to_raw(mesg);
      UTL_smtp.write_raw_data(conn, varData);
      --utl_smtp.WRITE_DATA(conn, mesg);
      utl_smtp.CLOSE_DATA(conn);
      UTL_SMTP.QUIT(conn);
  end if;
  
  END;
  
  procedure sp_mail_bath(fecha date)
      -- *****************************************************************
      -- Nombre                     : SP_CR_INSERT_JAQL406
      -- Sistema                    : BANTOTAL
      -- Modulo                     : Creditos - Activas
      -- Version                    : 1.0
      -- Fecha de Creacion          : 15/11/2017
      -- Autor de Creacion          : HSUAREZ
      -- Uso                        : Correos de envio en aprobacion de credito FMV.
      -- Estado                     : Activo
      -- Acceso                     : Publico
      -- Parametros de Entrada      : 
      --
      -- Retorno                    : 
      -- Fecha de Modificacion      :
      -- Autor de la Modificacion   :
      -- Descripcion de Modificacion:
      --
      -- *****************************************************************
     is
     cursor ctransacciones is
     select tp1nro1 modulo,tp1nro2 transaccion,tp1nro3 
     from fst198 t 
     where t.tp1cod   = 1
     and   t.tp1cod1  = 11104
     and   t.tp1corr1 = 3
     and   t.tp1corr2 = 1
     and   t.tp1corr3 > 0;
     cursor transaccionh(modulo in number, transaccion in number) is
      select 
            h5.pgcod,
            h5.hcmod,
            h5.hsucor,
            h5.htran,
            h5.hnrel,
            h5.hfcon              
       from fsh015 h5 
      where h5.pgcod = 1
        and h5.hcmod = modulo
        and h5.htran = transaccion
        and h5.hfcon = fecha;
     
     titulo varchar2(100);
     mensaje varchar2(500);
     v_empresa xwf700.xwfempresa%type;
     v_sucursal xwf700.xwfsucursal%type;
     v_modulo xwf700.xwfmodulo%type;
     v_moneda xwf700.xwfmoneda%type;
     v_papel xwf700.xwfpapel%type;
     v_cuenta xwf700.xwfcuenta%type;
     v_operacion xwf700.xwfoperacion%type;
     v_subope xwf700.xwfsubope%type;
     v_tipope xwf700.xwftipope%type;
     v_monto xwf700.xwfmonto1%type;
     v_plazo xwf700.xwfplazo1%type;
     v_tasa x054023.xlltasap%type;
     vn_flag_trn char(1);
     
     lv_pgcod fsd016.pgcod%type;
     lv_hcmod fsh015.hcmod%type;
     lv_hsucor fsh015.hsucor%type;
     lv_htran fsh015.htran%type;
     lv_hnrel fsh015.hnrel%type;
     lv_hfcon fsh015.hfcon%type;
     lv_pren01 fsh015.hcmod%type;
     flag_cancelado char(1);
     
     lv_hmodul fsh016.hmodul%type;
     lv_hsucur fsh016.hsucur%type;
     lv_hmda fsh016.hmda%type;
     lv_hpap fsh016.hpap%type;
     lv_hcta fsh016.hcta%type;
     lv_hoper fsh016.hoper%type;
     lv_hsubop fsh016.hsubop%type;
     lv_htoper fsh016.htoper%type;
     lv_monto_pag fsh016.hcimp6%type;
     
     ln_instancia xwf700.xwfprcins%type;
     tipo_pago number(3);                  
                       
     begin
            for l in ctransacciones loop
                for ll in transaccionh(l.modulo,l.transaccion) loop
                   
                   lv_pgcod := ll.pgcod;
                   lv_hcmod := ll.hcmod;
                   lv_hsucor:= ll.hsucor;
                   lv_htran := ll.htran;
                   lv_hnrel := ll.hnrel;
                   lv_hfcon := ll.hfcon;
                 
                    begin
                     select 
                           h6.hmodul,                    
                           h6.hsucur,
                           h6.hmda,
                           h6.hpap,
                           h6.hcta,
                           h6.hoper,
                           h6.hsubop,
                           h6.htoper,
                           h6.hcimp6
                     into 
                           lv_hmodul,
                           lv_hsucur,
                           lv_hmda,
                           lv_hpap,
                           lv_hcta,
                           lv_hoper,
                           lv_hsubop,
                           lv_htoper,
                           lv_monto_pag
                     from fsh016 h6
                     where h6.pgcod = lv_pgcod
                       and h6.hcmod = lv_hcmod
                       and h6.hsucor= lv_hsucor
                       and h6.htran = lv_htran
                       and h6.hnrel = lv_hnrel
                       and h6.hfcon = lv_hfcon
                       and h6.hcord = 10
                       and rownum=1;
                    exception
                    WHEN NO_DATA_FOUND then
                         lv_hmodul     := 0;
                         lv_hsucur     := 0;
                         lv_hmda       := 0;
                         lv_hpap       := 0;
                         lv_hcta       := 0;
                         lv_hoper      := 0;
                         lv_hsubop     := 0;
                         lv_htoper     := 0;
                         lv_monto_pag  := 0;
                    end;
                
                    begin
                       select 'S'
                       into flag_cancelado
                       from
                       fsd010 d10
                       where d10.pgcod = lv_pgcod
                       and d10.aomod   = lv_hmodul
                       and d10.aosuc   = lv_hsucur
                       and d10.aomda   = lv_hmda
                       and d10.aopap   = lv_hpap
                       and d10.aocta   = lv_hcta
                       and d10.aooper  = lv_hoper
                       and d10.aosbop  = lv_hsubop
                       and d10.aotope  = lv_htoper
                       and d10.aostat  = 99
                       and rownum=1;
                    exception 
                       WHEN NO_DATA_FOUND then
                            flag_cancelado:='N';     
                    end;              
                
                    if flag_cancelado='S' then
                       begin
                         select 
                             x.xwfprcins,
                             3
                         into
                             ln_instancia,
                             tipo_pago
                         from 
                         xwf700 x
                         where x.xwfempresa = lv_pgcod
                         and x.xwfsucursal  = lv_hsucur
                         and x.xwfmodulo    = lv_hmodul
                         and x.xwfmoneda    = lv_hmda
                         and x.xwfpapel     = lv_hpap
                         and x.xwfcuenta    = lv_hcta
                         and x.xwfoperacion = lv_hoper
                         and x.xwfsubope    = lv_hsubop
                         and x.xwftipope    = lv_htoper
                         and x.xwfcar3      = '1';
                       exception
                       WHEN NO_DATA_FOUND then
                             tipo_pago     := 0;
                             ln_instancia  := 0;
                        end;
                    
                        pq_cr_fmv_correos.sp_mail_pagos(ln_instancia,tipo_pago,lv_monto_pag);                   
                    end if;
            end loop;
          end loop;
          
  end sp_mail_bath;
  */
  /*
  PROCEDURE SP_CONCATENA_MAIL
  (
  PC_ORIGEN       VARCHAR2,
  PC_DESTINO      VARCHAR2,
  PC_TITULO       VARCHAR2,
  --PC_MENSAJE      VARCHAR2
  pc_mensaje    in clob
  )
  as
   Dominio               VARCHAR2(20) := '@cajaarequipa.pe';
   OrigenCorreo          VARCHAR2(50);
   DestinoCorreo         VARCHAR2(50);
  BEGIN
  
    OrigenCorreo  := PC_ORIGEN||Dominio;
    DestinoCorreo := PC_DESTINO||Dominio;
  
    BEGIN
      pq_cr_fmv_correos.sp_enviamail(OrigenCorreo,
                          DestinoCorreo,
                          PC_TITULO,
                          PC_MENSAJE);
     
      --sys.sp_sy_enviamail_html(origencorreo,
      --                         DestinoCorreo,
      --                         PC_TITULO,
      --                         PC_MENSAJE);
                                     
     exception
       when others then     
         dbms_output.put_line(sqlerrm);                       
    END;
  
    
  END;
  */
  procedure sp_enviamail(PC_DE      VARCHAR2,
                         PC_AQUIEN  VARCHAR2,
                         PC_MOTIVO  VARCHAR2,
                         PC_MENSAJE VARCHAR2) as
    EmailServer VARCHAR2(80) := '10.0.200.68';
    -- EmailServer     VARCHAR2(80) := '172.18.100.13';--12.02.2015
    Port       NUMBER := 2530;
    conn       UTL_SMTP.CONNECTION;
    crlf       VARCHAR2(2) := CHR(10);
    mesg       VARCHAR2(32000);
    vhost_name VARCHAR2(100);
    vardata    raw(5000);
  BEGIN
  
    select host_name into vhost_name from v$instance;
  
    if UPPER(vhost_name) in ('DWHBD1051') then
      --if  UPPER(vhost_name) in ('DWHBD1051xxxx') then
      --if UPPER(vhost_name) in ('BTRAC1051','BTRAC1052','DSBD1051') then
    
      conn := utl_smtp.OPEN_CONNECTION(EmailServer, Port);
      utl_smtp.HELO(conn, EmailServer);
      utl_smtp.MAIL(conn, PC_DE);
      utl_smtp.RCPT(conn, PC_AQUIEN);
      mesg := 'From: ' || PC_DE || crlf || 'To: ' || PC_AQUIEN || crlf ||
              'Subject: ' || PC_MOTIVO || crlf || '' || crlf || PC_MENSAJE || crlf || crlf || '.' || crlf;
    
      utl_smtp.OPEN_DATA(conn);
    
      UTL_smtp.write_data(conn, 'MIME-Version: ' || '1.0' || UTL_TCP.CRLF);
      UTL_smtp.write_data(conn,
                          'Content-Type: ' ||
                          'text/plain; charset=iso-8859-15' || UTL_TCP.CRLF);
      UTL_smtp.write_data(conn,
                          'Content-Transfer-Encoding: ' || '8bit' ||
                          UTL_TCP.CRLF);
      varData := utl_raw.cast_to_raw(mesg);
      UTL_smtp.write_raw_data(conn, varData);
      --utl_smtp.WRITE_DATA(conn, mesg);
      utl_smtp.CLOSE_DATA(conn);
      UTL_SMTP.QUIT(conn);
    end if;
  
  END;

  procedure sp_mail_bath(fecha date)
  -- *****************************************************************
    -- Nombre                     : SP_CR_INSERT_JAQL406
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 15/11/2017
    -- Autor de Creacion          : HSUAREZ
    -- Uso                        : Correos de envio en aprobacion de credito FMV.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificacion      : 21/08/2019
    -- Autor de la Modificacion   : Cinthya Liz Hernandez Ortega
    -- Descripcion de Modificacion: Se agregó llamado al envio de correos de techo propio.
    --
    -- *****************************************************************
   is
    cursor ctransacciones is
      select tp1nro1 modulo, tp1nro2 transaccion, tp1nro3
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11104
         and t.tp1corr1 = 3
         and t.tp1corr2 = 1
         and t.tp1corr3 > 0;
    cursor transaccionh(modulo in number, transaccion in number) is
      select h5.pgcod, h5.hcmod, h5.hsucor, h5.htran, h5.hnrel, h5.hfcon
        from fsh015 h5
       where h5.pgcod = 1
         and h5.hcmod = modulo
         and h5.htran = transaccion
         and h5.hfcon = fecha;
  
    titulo      varchar2(100);
    mensaje     varchar2(500);
    v_empresa   xwf700.xwfempresa%type;
    v_sucursal  xwf700.xwfsucursal%type;
    v_modulo    xwf700.xwfmodulo%type;
    v_moneda    xwf700.xwfmoneda%type;
    v_papel     xwf700.xwfpapel%type;
    v_cuenta    xwf700.xwfcuenta%type;
    v_operacion xwf700.xwfoperacion%type;
    v_subope    xwf700.xwfsubope%type;
    v_tipope    xwf700.xwftipope%type;
    v_monto     xwf700.xwfmonto1%type;
    v_plazo     xwf700.xwfplazo1%type;
    v_tasa      x054023.xlltasap%type;
    vn_flag_trn char(1);
  
    lv_pgcod       fsd016.pgcod%type;
    lv_hcmod       fsh015.hcmod%type;
    lv_hsucor      fsh015.hsucor%type;
    lv_htran       fsh015.htran%type;
    lv_hnrel       fsh015.hnrel%type;
    lv_hfcon       fsh015.hfcon%type;
    lv_pren01      fsh015.hcmod%type;
    flag_cancelado char(1);
  
    lv_hmodul    fsh016.hmodul%type;
    lv_hsucur    fsh016.hsucur%type;
    lv_hmda      fsh016.hmda%type;
    lv_hpap      fsh016.hpap%type;
    lv_hcta      fsh016.hcta%type;
    lv_hoper     fsh016.hoper%type;
    lv_hsubop    fsh016.hsubop%type;
    lv_htoper    fsh016.htoper%type;
    lv_monto_pag fsh016.hcimp6%type;
  
    ln_instancia xwf700.xwfprcins%type;
    tipo_pago    number(3);
    ln_salbms    fsh016.hcimp1%type;
    ln_tipoOper  number(5);
  
  begin
    for l in ctransacciones loop
      for ll in transaccionh(l.modulo, l.transaccion) loop
      
        lv_pgcod  := ll.pgcod;
        lv_hcmod  := ll.hcmod;
        lv_hsucor := ll.hsucor;
        lv_htran  := ll.htran;
        lv_hnrel  := ll.hnrel;
        lv_hfcon  := ll.hfcon;
      
        begin
          select h6.hmodul,
                 h6.hsucur,
                 h6.hmda,
                 h6.hpap,
                 h6.hcta,
                 h6.hoper,
                 h6.hsubop,
                 h6.htoper,
                 h6.hcimp6
            into lv_hmodul,
                 lv_hsucur,
                 lv_hmda,
                 lv_hpap,
                 lv_hcta,
                 lv_hoper,
                 lv_hsubop,
                 lv_htoper,
                 lv_monto_pag
            from fsh016 h6
           where h6.pgcod = lv_pgcod
             and h6.hcmod = lv_hcmod
             and h6.hsucor = lv_hsucor
             and h6.htran = lv_htran
             and h6.hnrel = lv_hnrel
             and h6.hfcon = lv_hfcon
             and h6.hcord = 10
             and rownum = 1;
        exception
          WHEN NO_DATA_FOUND then
            lv_hmodul    := 0;
            lv_hsucur    := 0;
            lv_hmda      := 0;
            lv_hpap      := 0;
            lv_hcta      := 0;
            lv_hoper     := 0;
            lv_hsubop    := 0;
            lv_htoper    := 0;
            lv_monto_pag := 0;
        end;
      
        begin
          select 'S'
            into flag_cancelado
            from fsd010 d10
           where d10.pgcod = lv_pgcod
             and d10.aomod = lv_hmodul
             and d10.aosuc = lv_hsucur
             and d10.aomda = lv_hmda
             and d10.aopap = lv_hpap
             and d10.aocta = lv_hcta
             and d10.aooper = lv_hoper
             and d10.aosbop = lv_hsubop
             and d10.aotope = lv_htoper
             and d10.aostat = 99
             and rownum = 1;
        exception
          WHEN NO_DATA_FOUND then
            flag_cancelado := 'N';
        end;
      
        if flag_cancelado = 'S' then
          begin
            select x.xwfprcins, 3
              into ln_instancia, tipo_pago
              from xwf700 x
             where x.xwfempresa = lv_pgcod
               and x.xwfsucursal = lv_hsucur
               and x.xwfmodulo = lv_hmodul
               and x.xwfmoneda = lv_hmda
               and x.xwfpapel = lv_hpap
               and x.xwfcuenta = lv_hcta
               and x.xwfoperacion = lv_hoper
               and x.xwfsubope = lv_hsubop
               and x.xwftipope = lv_htoper
               and x.xwfcar3 = '1';
          exception
            WHEN NO_DATA_FOUND then
              tipo_pago    := 0;
              ln_instancia := 0;
          end;
        
          begin
            select h6.hcimp1
              into ln_salbms
              from fsh016 h6
             where h6.pgcod = lv_pgcod
               and h6.hcmod = lv_hcmod
               and h6.hsucor = lv_hsucor
               and h6.htran = lv_htran
               and h6.hnrel = lv_hnrel
               and h6.hfcon = lv_hfcon
               and exists (select 1
                      from fsr014
                     where rrcod = 246
                       and rrrubr = h6.hrubro
                       and rownum = 1)
               and rownum = 1;
          exception
            when others then
              ln_salbms := 0;
          end;
          --21/08/2019 chernandez
          begin
            select tp1nro3
              into ln_tipoOper
              from fst198
             where tp1cod = 1
               and tp1cod1 = 11105
               and tp1corr1 = 26
               and tp1corr2 = 1
               and tp1corr3 > 0
               and tp1nro1 = lv_hmodul
               and tp1nro2 = lv_htoper;
          Exception
            When others then
              ln_tipoOper := 1;
          end;
          If ln_tipoOper = 1 then
            pq_cr_fmv_correos.sp_mail_pagos(ln_instancia,
                                            tipo_pago,
                                            lv_monto_pag,
                                            ln_salbms,
                                            0);
          end if;
          If ln_tipoOper = 2 then
            tipo_pago := 2;
            pq_cr_fmv_correos.sp_mail_pagos_tp(ln_instancia,
                                               tipo_pago,
                                               lv_monto_pag,
                                               ln_salbms,
                                               0);
          end if;
          --21/08/2019 chernandez
        end if;
      end loop;
    end loop;
  
  end sp_mail_bath;

  procedure sp_pagos_bbp_pbp(v_empresa   in xwf700.xwfempresa%type,
                             v_sucursal  in xwf700.xwfsucursal%type,
                             v_modulo    in xwf700.xwfmodulo%type,
                             v_moneda    in xwf700.xwfmoneda%type,
                             v_papel     in xwf700.xwfpapel%type,
                             v_cuenta    in xwf700.xwfcuenta%type,
                             v_operacion in xwf700.xwfoperacion%type,
                             v_subope    in xwf700.xwfsubope%type,
                             v_tipope    in xwf700.xwftipope%type,
                             v_fecha     in date,
                             --nrel        in number,
                             ln_monto_bono out xwf700.xwfmonto1%type,
                             ln_int_bono   out xwf700.xwfmonto1%type,
                             ln_total      out xwf700.xwfmonto1%type) is
    cursor pagos_bbp_pbp(lc_pgcod in number, lc_hcmod in number, lc_hsucor in number, lc_htran in number, lc_hnrel in number, lc_hfcon in date) is
      select *
        from fsh016 h
       where h.pgcod = lc_pgcod
         and h.hcmod = lc_hcmod
         and h.hsucor = lc_hsucor
         and h.htran = lc_htran
         and h.hnrel = lc_hnrel
         and h.hfcon = lc_hfcon;
  
    cursor pagos_bbp_pbp_(v_empresa in xwf700.xwfempresa%type, v_sucursal in xwf700.xwfsucursal%type, v_modulo in xwf700.xwfmodulo%type, v_transaccion in fsd016.ittran%type, v_relacion in fsd016.itnrel%type, v_fecha in fsd015.itfcon%type) is
      select *
        from aqpa071 A
       where a.aqpa071cod = v_empresa
         and a.aqpa071suc = v_sucursal
         and a.aqpa071mod = v_modulo
         and a.aqpa071trn = v_transaccion
         and a.aqpa071nrl = v_relacion
         and a.aqpa071fcon = v_fecha;
  
    ln_pgcod  fsd016.pgcod%type;
    ln_hcmod  fsd016.itmod%type;
    ln_hsucor fsd016.itsuc%type;
    ln_htran  fsd016.ittran%type;
    ln_hnrel  fsd016.itnrel%type;
    ln_hfcon  fsd016.itfval%type;
  
    lnv_monto_bbp   fsd016.itimp1%type;
    lnv_monto_ibbp  fsd016.itimp1%type;
    lnv_monto_pbp   fsd016.itimp1%type;
    lnv_monto_ipbp  fsd016.itimp1%type;
    lnv_monto_total fsd016.itimp1%type;
  
  begin
    ln_hfcon := v_fecha;
    begin
      begin
        select a.aqpa071cod,
               a.aqpa071suc,
               a.aqpa071mod,
               a.aqpa071trn,
               a.aqpa071nrl,
               a.aqpa071fcon
          into ln_pgcod, ln_hsucor, ln_hcmod, ln_htran, ln_hnrel, ln_hfcon
          from aqpa071 A
         where a.aqpa071cod = v_empresa
           and a.aqpa071modu = v_modulo
           and a.aqpa071mda = v_moneda
           and a.aqpa071pap = v_papel
           and a.aqpa071cta = v_cuenta
           and a.aqpa071ope = v_operacion
           and a.aqpa071subo = v_subope
           and a.aqpa071tope = v_tipope
           and a.aqpa071sucd = v_sucursal
           and a.aqpa071ord = 10
           and rownum = 1;
      exception
        WHEN NO_DATA_FOUND then
          ln_pgcod  := 0;
          ln_hsucor := 0;
          ln_hcmod  := 0;
          ln_htran  := 0;
          ln_hnrel  := 0;
          ln_hfcon  := null;
      end;
    
      for i in pagos_bbp_pbp_(ln_pgcod,
                              ln_hsucor,
                              ln_hcmod,
                              ln_htran,
                              ln_hnrel,
                              ln_hfcon) loop
        if i.aqpa071ord = 15 then
          lnv_monto_bbp := i.aqpa071imp1;
          ln_monto_bono := lnv_monto_bbp;
          if i.aqpa071ord = 17 then
            lnv_monto_ibbp := i.aqpa071imp1;
            ln_int_bono    := lnv_monto_ibbp;
          end if;
        end if;
        if i.aqpa071ord = 20 then
          lnv_monto_pbp := i.aqpa071imp1;
          ln_monto_bono := lnv_monto_pbp;
          if i.aqpa071ord = 22 then
            lnv_monto_ipbp := i.aqpa071imp1;
            ln_int_bono    := lnv_monto_ipbp;
          end if;
        end if;
        if i.aqpa071ord = 25 then
          lnv_monto_total := i.aqpa071imp3;
          ln_total        := lnv_monto_total;
        end if;
      end loop;
    end;
  
  end;
  ----------------------------------------------------------------------------------------
  --ENVIO DE CORREOS CONFIG.
  ----------------------------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              ) is
    --Cursor
    cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;
    -- Variables
    c_smtp_server VARCHAR2(30);
    port          number;
    host          VARCHAR2(100);
    --BORRAR TEMPO
    --MENSAJE CLOB;
  
    -- 
    lc_hostname varchar2(64);
    lv_smtp     varchar2(30);
    lv_host     varchar2(30);
    ln_port     number(9);
  begin
    --MENSAJE := '<HTML> PRUEBA <BR/> PRUEBE <BR/> Pre Pago Total sin BBP<HTML>';
    begin
      select host_name into lc_hostname from v$instance;
    exception
      WHEN NO_DATA_FOUND then
        lc_hostname := '';
    end;
  
    For i in c_host loop
      lv_host := upper(TRIM(substr(i.tp1desc, 1, instr(i.tp1desc, '/') - 1)));
      lv_smtp := TRIM(substr(i.tp1desc,
                             instr(i.tp1desc, '/') + 1,
                             length(trim(i.tp1desc))));
      ln_port := i.tp1nro3;
    
      if upper(lc_hostname) = lv_host then
      
        Exit;
      End if;
    End loop;
  
    c_smtp_server := lv_smtp; -- '10.0.200.68'; 
    port          := ln_port; -- 2530;           
    host          := lv_host; -- 'DWHBD1051';
  
    sp_cr_mail_root(p_c_de, --de
                    p_c_recipiente, --para
                    subject, --subject
                    fecha_proceso, --fecha de procesamiento
                    -------------------------
                    c_smtp_server, -- ip del servidor
                    port, -- puerto del servidor
                    host, -- host del servidor
                    -------------------------                            
                    v_header, -- Cabecera
                    rawdata -- Detalle Mensaje (HTML)
                    );
  end;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2,
                            p_c_recipiente in varchar2,
                            subject        in varchar2,
                            fecha_proceso  in date,
                            --------------------
                            c_smtp_server in VARCHAR2,
                            port          in NUMBER,
                            host          in varchar2,
                            --------------------                            
                            v_header  in varchar2, -- Cabecera
                            c_mensaje in clob -- Detalle 
                            ) is
  
    l_boundary   varchar2(255) default 'a1b2c3d4e3f2g1';
    l_connection utl_smtp.connection;
    l_body_html  clob := empty_clob; --This LOB will be the email message
    l_offset     number;
    l_ammount    number;
    l_temp       varchar2(32767) default null;
    l_text       varchar2(10) := 'TEXT';
    v_clob       CLOB;
    vhost_name   VARCHAR2(100);
  
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(80);
    p_c_msgerr  VARCHAR2(1000);
 v_found NUMBER := 0;
    /*
    v_wstring varchar2 (32000);
    auxiliar varchar2 (32000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(80);
    V_Conexion    utl_smtp.Connection;
    v_clob                     CLOB;
    msg           varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2( 100 );
    c_dni VARCHAR2(100);
    datas long raw;
    c_mime_boundary   CONSTANT VARCHAR2 (256)      := '--AAAAA000956--';
    l_n_offset NUMBER:=630;
    */
  begin
    v_clob := 'Number' || ',' || 'Name' || UTL_TCP.crlf;
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  
  SELECT count(*) into v_found
  FROM systabrep.hostnames
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);


    -- IF UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052',host) then 
--    IF UPPER(VHOST_NAME) IN ('SC01ZDBADM010101', 'SC01ZDBADM020101', host) then
  if v_found =1 then
      -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') then
      v_From      := p_c_de;
      v_Recipient := P_C_RECIPIENTE;
      v_Subject   := subject;
    
      l_connection := utl_smtp.open_connection(C_SMTP_SERVER, Port);
      utl_smtp.helo(l_connection, C_SMTP_SERVER);
      utl_smtp.mail(l_connection, v_From);
      utl_smtp.rcpt(l_connection, v_Recipient);
    
      l_temp := l_temp || 'MIME-Version: 1.0' || chr(13) || chr(10);
      l_temp := l_temp || 'To: ' || v_Recipient || chr(13) || chr(10);
      l_temp := l_temp || 'From: ' || v_From || chr(13) || chr(10);
      l_temp := l_temp || 'Subject: ' || v_Subject || chr(13) || chr(10);
      l_temp := l_temp || 'Reply-To: ' || v_From || chr(13) || chr(10);
      l_temp := l_temp || 'Content-Type: multipart/alternative; boundary=' ||
                chr(34) || l_boundary || chr(34) || chr(13) || chr(10);
    
      ----------------------------------------------------
      -- Write the headers
      dbms_lob.createtemporary(l_body_html, false, 10);
      dbms_lob.write(l_body_html, length(l_temp), 1, l_temp);
    
      ----------------------------------------------------
      -- Write the text boundary
      l_offset := dbms_lob.getlength(l_body_html) + 1;
      l_temp   := '--' || l_boundary || chr(13) || chr(10);
      l_temp   := l_temp || 'content-type: text/plain; charset=us-ascii' ||
                  chr(13) || chr(10) || chr(13) || chr(10);
      dbms_lob.write(l_body_html, length(l_temp), l_offset, l_temp);
    
      ----------------------------------------------------
      -- Write the plain text portion of the email
      l_offset := dbms_lob.getlength(l_body_html) + 1;
      dbms_lob.write(l_body_html, length(l_text), l_offset, l_text);
    
      ----------------------------------------------------
      -- Write the HTML boundary
      l_temp   := chr(13) || chr(10) || chr(13) || chr(10) || '--' ||
                  l_boundary || chr(13) || chr(10);
      l_temp   := l_temp || 'content-type: text/html;' || chr(13) ||
                  chr(10) || chr(13) || chr(10);
      l_offset := dbms_lob.getlength(l_body_html) + 1;
      dbms_lob.write(l_body_html, length(l_temp), l_offset, l_temp);
    
      ----------------------------------------------------
      -- Write the HTML portion of the message
      l_offset := dbms_lob.getlength(l_body_html) + 1;
      --  dbms_lob.write(l_body_html, length(PC_MENSAJE), l_offset, PC_MENSAJE);
      dbms_lob.copy(l_body_html,
                    c_mensaje,
                    dbms_lob.getlength(c_mensaje),
                    l_offset,
                    1);
    
      ----------------------------------------------------
      -- Write the final html boundary
      l_temp   := chr(13) || chr(10) || '--' || l_boundary || '--' ||
                  chr(13);
      l_offset := dbms_lob.getlength(l_body_html) + 1;
      dbms_lob.write(l_body_html, length(l_temp), l_offset, l_temp);
    
      ----------------------------------------------------
      -- Send the email in 1900 byte chunks to UTL_SMTP
      l_offset  := 1;
      l_ammount := 1900;
      utl_smtp.open_data(l_connection);
      while l_offset < dbms_lob.getlength(l_body_html) loop
        utl_smtp.write_data(l_connection,
                            dbms_lob.substr(l_body_html,
                                            l_ammount,
                                            l_offset));
        l_offset  := l_offset + l_ammount;
        l_ammount := least(1900,
                           dbms_lob.getlength(l_body_html) - l_ammount);
      end loop;
      utl_smtp.close_data(l_connection);
      utl_smtp.quit(l_connection);
      dbms_lob.freetemporary(l_body_html);
    end if;
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000,
                              'Unable to send mail: ' || p_c_msgerr);
  end;
  ----------------------------------------------------------------------------------------

  Function fn_monto_cuota(PN_PGCOD in Number,
                          PN_MOD   in Number,
                          PN_SUC   in Number,
                          PN_MDA   in Number,
                          PN_PAP   in Number,
                          PN_CTA   in Number,
                          PN_OPE   in Number,
                          PN_SBO   in Number,
                          PN_TOP   in Number,
                          PD_FEC   in Date) Return Number Is
    ln_mtocuo number(12, 2);
    ln_mtoseg number(12, 2);
    ln_suc    number(3);
    ld_fecpag date;
  Begin
    Begin
      Select ppfpag, mtocuo
        Into ld_fecpag, ln_mtocuo
        From (select p.ppfpag, nvl(p.ppcap, 0) + nvl(p.ppint, 0) mtocuo
                from fsd601 p
               where p.pgcod = PN_PGCOD
                 and p.ppmod = PN_MOD
                 and p.ppsuc = PN_SUC
                 and p.ppmda = PN_MDA
                 and p.pppap = PN_PAP
                 and p.ppcta = PN_CTA
                 and p.ppoper = PN_OPE
                 and p.ppsbop = PN_SBO
                 and p.pptope = PN_TOP
                 and p.d601co = 'S'
                 and (p.ppcap + p.ppint) > 0
                 and not exists (Select 1
                        From fsd602 c
                       Where c.pgcod = p.pgcod
                         and c.ppmod = p.ppmod
                         and c.ppsuc = p.ppsuc
                         and c.ppmda = p.ppmda
                         and c.pppap = p.pppap
                         and c.ppcta = p.ppcta
                         and c.ppoper = p.ppoper
                         and c.ppsbop = p.ppsbop
                         and c.pptope = p.pptope
                         and c.ppfpag = p.ppfpag
                         and c.pptipo = p.pptipo
                         and c.pp1stat = 'T'
                         and c.d602co = 'S'
                         and c.d602fc <= PD_FEC)
               Order by p.ppfpag)
       Where Rownum = 1;
      ln_suc := PN_SUC;
    Exception
      When No_Data_Found Then
        Begin
          Select ppfpag, mtocuo
            Into ld_fecpag, ln_mtocuo
            From (select /*+index(p FSD60103)*/p.ppfpag, nvl(p.ppcap, 0) + nvl(p.ppint, 0) mtocuo
                    from fsd601 p
                   where p.pgcod = PN_PGCOD
                     and p.ppmod = PN_MOD
                     and p.ppmda = PN_MDA
                     and p.pppap = PN_PAP
                     and p.ppcta = PN_CTA
                     and p.ppoper = PN_OPE
                     and p.ppsbop = PN_SBO
                     and p.pptope = PN_TOP
                     and p.d601co = 'S'
                     and (p.ppcap + p.ppint) > 0
                     and not exists (Select /*+index(c SYS_C00978743)*/1--19.07.2021
                            From fsd602 c
                           Where c.pgcod = p.pgcod
                             and c.ppmod = p.ppmod
                             and c.ppsuc = p.ppsuc
                             and c.ppmda = p.ppmda
                             and c.pppap = p.pppap
                             and c.ppcta = p.ppcta
                             and c.ppoper = p.ppoper
                             and c.ppsbop = p.ppsbop
                             and c.pptope = p.pptope
                             and c.ppfpag = p.ppfpag
                             and c.pptipo = p.pptipo
                             and c.pp1stat = 'T'
                             and c.d602co = 'S'
                             and c.d602fc <= PD_FEC)
                   Order by p.ppfpag);
        Exception
          When Others Then
            ln_mtocuo := 0;
        End;
      When Others Then
        ln_mtocuo := 0;
    End;
  
    Begin
      select ( nvl(s.ppimp11, 0) + nvl(s.ppimp12, 0) + nvl(s.ppimp13, 0) + nvl(s.ppimp14, 0) + nvl(s.ppimp15, 0) ) --kdvc 18/11/2019
        into ln_mtoseg
        from fsd611 s
       where s.pgcod = PN_PGCOD
         and s.ppmod = PN_MOD
         and s.ppsuc = ln_suc
         and s.ppmda = PN_MDA
         and s.pppap = PN_PAP
         and s.ppcta = PN_CTA
         and s.ppoper = PN_OPE
         and s.ppsbop = PN_SBO
         and s.pptope = PN_TOP
         and s.ppfpag = ld_fecpag;
    Exception
      When Others Then
        ln_mtoseg := 0;
    End;
  
    Return(nvl(ln_mtocuo, 0) + nvl(ln_mtoseg, 0));
  
  End fn_monto_cuota;
  PROCEDURE sp_mail_pagos_tp(p_instancia sng001.sng001inst%type,
                             tipo_pago   number,
                             mnto_pago   number,
                             nSalBMS     number,
                             nIntBMS     number)
  -- *****************************************************************
    -- Nombre                     : sp_mail_pagos_tp
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 16/08/2019
    -- Autor de Creacion          : CHERNANDEZ
    -- Uso                        : Correos de envío en amortizacion Techo propio.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificacion      :
    -- Autor de la Modificacion   :
    -- Descripcion de Modificacion:
    --
    -- *****************************************************************
   is
    cursor correo_destinatario is
      select tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 26
         and tp1corr2 = 3
         and tp1corr3 > 0;
  
    cursor modulos_mivivienda is
      select tp1nro1 modulo, tp1nro2 transaccion, tp1nro3
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11104
         and t.tp1corr1 = 1
         and t.tp1corr2 = 1
         and t.tp1corr3 > 0;
  
    cursor pago_bono(p_empresa number, p_sucursal number, p_modulo number, p_moneda number, p_papel number, p_cuenta number, p_operacion number, p_subope number, p_tipope number) is
      select *
        from aqpa070 b, aqpa071 a
       where a.aqpa071cod = p_empresa
         and a.aqpa071mod = 30
         and a.aqpa071trn = 113
         and a.aqpa071cta = p_cuenta
         and a.aqpa071ope = p_operacion
         and a.aqpa071mda = p_moneda
         and a.aqpa071modu = p_modulo
         and a.aqpa071tope = p_tipope
         and a.aqpa071sucd = p_sucursal
         and a.aqpa071subo = p_subope
         and a.aqpa071pap = p_papel
         and a.aqpa071cod = b.aqpa070cod
         and a.aqpa071suc = b.aqpa070suc
         and a.aqpa071mod = b.aqpa070mod
         and a.aqpa071trn = b.aqpa070trn
         and a.aqpa071nrl = b.aqpa070nrel
         and a.aqpa071fcon = b.aqpa070fcon
         and b.aqpa070corr = 0
         and b.aqpa070cont = 'S';
  
    cursor monto_bono(p_empresa number, p_sucurs number, p_modulo number, p_transaccion number, p_relacion number, p_fecha date) is
      select aqpa071imp1
        from aqpa071 a
       where a.aqpa071cod = p_empresa
         and a.aqpa071suc = p_sucurs
         and a.aqpa071mod = p_modulo
         and a.aqpa071trn = p_transaccion
         and a.aqpa071nrl = p_relacion
         and a.aqpa071fcon = p_fecha
         and a.aqpa071ord in (15, 22, 23);
  
    titulo       varchar2(100);
    mensaje      varchar2(2500);
    li_remitente varchar2(30);
  
    flag_fmv      char;
    fecha_sistema fst017.pgfape%type;
    v_empresa     xwf700.xwfempresa%type;
    v_sucursal    xwf700.xwfsucursal%type;
    v_modulo      xwf700.xwfmodulo%type;
    v_moneda      xwf700.xwfmoneda%type;
    v_papel       xwf700.xwfpapel%type;
    v_cuenta      xwf700.xwfcuenta%type;
    v_operacion   xwf700.xwfoperacion%type;
    v_subope      xwf700.xwfsubope%type;
    v_tipope      xwf700.xwftipope%type;
    v_monto       xwf700.xwfmonto1%type;
    v_plazo       xwf700.xwfplazo1%type;
    v_plazo_amr   xwf700.xwfplazo1%type;
    ln_mtocuo     number(18, 2);
  
    v_tasa         x054023.xlltasap%type;
    v_saldo        fsd011.scsdo%type;
    v_fech_des     fsd010.aofval%type;
    v_fecha_ades   number;
    v_fecha_actual number;
  
    v_fec_ult_cuota date;
    ln_cuenta       varchar2(9);
    ln_moneda       varchar2(3);
    ln_operacion    varchar2(9);
    flag_msg        char(3);
  
    ln_bbp number;
    ln_pbp number;
  
    ln_monto_bono    xwf700.xwfmonto1%type;
    ln_int_bono      xwf700.xwfmonto1%type;
    ln_total         xwf700.xwfmonto1%type;
    ln_meses_sinbbp  number;
    vp_meses_bbp_pbp number;
    ln_dias_sinbbp   number;
    vp_dias_bbp_pbp  number;
  
    ctipo_pago  number;
    v_simon     varchar2(4);
    tiene_pago  number;
    n_montoBono number(18, 2);
  
  begin
    ctipo_pago := tipo_pago;
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope,
             x.xwfmonto1,
             x.xwfplazo1
        into v_empresa,
             v_sucursal,
             v_modulo,
             v_moneda,
             v_papel,
             v_cuenta,
             v_operacion,
             v_subope,
             v_tipope,
             v_monto,
             v_plazo
        from xwf700 x
       where x.xwfprcins = p_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_empresa   := 0;
        v_sucursal  := 0;
        v_modulo    := 0;
        v_moneda    := 0;
        v_papel     := 0;
        v_cuenta    := 0;
        v_operacion := 0;
        v_subope    := 0;
        v_tipope    := 0;
        v_monto     := 0;
        v_plazo     := 0;
    end;
    begin
      select x.xlltasap
        into v_tasa
        from x054023 x
       where x.xllpgcod = v_empresa
         and x.xllaomod = v_modulo
         and x.xllaosuc = v_sucursal
         and x.xllaomda = v_moneda
         and x.xllaopap = v_papel
         and x.xllaocta = v_cuenta
         and x.xllaooper = v_operacion
         and x.xllaosbop = v_subope
         and x.xllaotop = v_tipope
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_tasa := 0;
    end;
    --SALDO DEUDOR
    begin
      select x.scsdo
        into v_saldo
        from fsd011 x
       where x.pgcod = v_empresa
         and x.scmod = v_modulo
         and x.scsuc = v_sucursal
         and x.scmda = v_moneda
         and x.scpap = v_papel
         and x.sccta = v_cuenta
         and x.scoper = v_operacion
         and x.scsbop = v_subope
         and x.sctope = v_tipope --;
         and rownum = 1; --agregado borrar
    exception
      when NO_DATA_FOUND then
        v_saldo := 0;
    end;
    --FECHA DE DESEMBOLSO
    begin
      select x.aofval, x.aopzo, x.aopzo
        into v_fech_des, v_plazo, v_plazo_amr
        from fsd010 x
       where x.pgcod = v_empresa
         and x.aomod = v_modulo
         and x.aosuc = v_sucursal
         and x.aomda = v_moneda
         and x.aopap = v_papel
         and x.aocta = v_cuenta
         and x.aooper = v_operacion
         and x.aosbop = v_subope
         and x.aotope = v_tipope
            --and x.aostat <> 99
         and rownum = 1;
    exception
      when NO_DATA_FOUND then
        v_fech_des := null;
    end;
  
    begin
      select pgfape into fecha_sistema from fst017 where pgcod = 1;
    end;
  
    begin
      ln_mtocuo := fn_monto_cuota(pn_pgcod => v_empresa,
                                  pn_mod   => v_modulo,
                                  pn_suc   => v_sucursal,
                                  pn_mda   => v_moneda,
                                  pn_pap   => v_papel,
                                  pn_cta   => v_cuenta,
                                  pn_ope   => v_operacion,
                                  pn_sbo   => v_subope,
                                  pn_top   => v_tipope,
                                  pd_fec   => fecha_sistema);
    exception
      when others then
        ln_mtocuo := null;
    end;
  
    --OBTENER EL NUMERO DE DIAS QUE QUEDAN DESDE LA AMORTIZACION HASTA EL FIN DEL PAGO.
    select max(d.ppfpag)
      into v_fec_ult_cuota
      from fsd601 d
     where d.pgcod = v_empresa
       and d.ppmod = v_modulo
       and d.ppsuc = v_sucursal
       and d.ppmda = v_moneda
       and d.pppap = v_papel
       and d.ppcta = v_cuenta
       and d.ppoper = v_operacion
       and d.ppsbop = v_subope
       and d.pptope = v_tipope;
    -- OBTENER PLAZO SEGUN FSD601.
    SELECT trunc(TO_DATE(v_fec_ult_cuota, 'DD/MM/YY')) -
           trunc(to_date(fecha_sistema, 'DD/MM/YY'))
      into v_plazo
      FROM DUAL;
    --
    --CONVERSION EN MESES DE LA FECHA DE DESEMBOLSO MENOS LA FECHA ACTUAL.
    SELECT trunc(TO_DATE(fecha_sistema, 'DD/MM/YY')) -
           trunc(to_date(v_fech_des, 'DD/MM/YY'))
      into ln_dias_sinbbp
      FROM DUAL;
  
    ------------------------------
  
    if v_saldo = 0 then
      ctipo_pago := 2;
    End if;
  
    ln_cuenta    := LPAD(v_cuenta, 9, 0);
    ln_moneda    := lpad(v_moneda, 3, 0);
    ln_operacion := lpad(v_operacion, 9, 0);
    begin
      select mosign into v_simon from fst005 where moneda = v_moneda;
    Exception
      when others then
        v_simon := '';
    end;
  
    --adicional verificar si es techo propio
    flag_fmv := 'N';
    for x in modulos_mivivienda loop
      if v_modulo = x.modulo then
        flag_fmv := 'S';
      end if;
    end loop;
    if flag_fmv = 'S' then
    
      if ctipo_pago = 1 then
        if nSalBMS > 0 then
          titulo  := 'Amortización del Cr&#233;dito con BMS ';
          mensaje := 'Pre Pago Parcial efectuado al cr&#233;dito Techo Propio N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', nuevo monto de cr&#233;dito ' || v_simon || ' ' ||
                     -v_saldo || ', a plazo ' || v_plazo_amr ||
                     ' ,con cuota de ' || v_simon || ' ' || ln_mtocuo ||
                     ' y con tasa ' || v_tasa ||
                     '%. Segun corresponda y procedimientos vigentes, sirvase remitir ' ||
                     'a COFIDE/FMV el nuevo cronograma de pagos generado por la ' ||
                     'amortizacion del cliente';
        else
          titulo  := 'Amortización del Cr&#233;dito sin BMS ';
          mensaje := 'Pre Pago Parcial efectuado al cr&#233;dito Techo Propio N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', nuevo monto de cr&#233;dito ' || v_simon || ' ' ||
                     -v_saldo || ', a plazo ' || v_plazo_amr ||
                     ' ,con cuota de ' || v_simon || ' ' || ln_mtocuo ||
                     ' y con tasa ' || v_tasa ||
                     '%. Segun corresponda y procedimientos vigentes, sirvase remitir ' ||
                     'a COFIDE/FMV el nuevo cronograma de pagos generado por la ' ||
                     'amortizacion del cliente';
        end if;
      end if;
      if ctipo_pago = 2 then
        if nSalBMS > 0 then
          tiene_pago  := 0;
          n_montoBono := 0;
          for g in pago_bono(v_empresa,
                             v_sucursal,
                             v_modulo,
                             v_moneda,
                             v_papel,
                             v_cuenta,
                             v_operacion,
                             v_subope,
                             v_tipope) loop
            tiene_pago := 1;
            for h in monto_bono(g.aqpa070cod,
                                g.aqpa070suc,
                                g.aqpa070mod,
                                g.aqpa070trn,
                                g.aqpa070nrel,
                                g.aqpa070fcon) loop
              n_montoBono := n_montoBono + h.aqpa071imp1;
            end loop;
          end loop;
        
          titulo  := 'Cancelación del crédito con BMS';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito Techo Propio N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Pago ' || v_simon || ' ' || mnto_pago ||
                     ', sirvase remitir segun corresponda a COFIDE/FMV la carta de Solicitud,' ||
                     ' Contrato de Compra Venta, Fecha de Cancelacion e Hipoteca. ' ||
                     'Ademas, contaba con BMS de ' || v_simon || ' ' ||
                     nSalBMS || ' se recuperó este por ' || v_simon || ' ' ||
                     n_montoBono || ' incluido intereses del BMS.';
        else
          titulo  := 'Cancelación del crédito sin BMS';
          mensaje := 'Pre Pago Total efectuado al cr&#233;dito Techo Propio N&#176; ' ||
                     ln_cuenta || ln_moneda || ln_operacion ||
                     ', monto del Pago ' || v_simon || ' ' || mnto_pago ||
                     ', sirvase remitir segun corresponda a COFIDE/FMV la carta de Solicitud,' ||
                     ' Contrato de Compra Venta, Fecha de Cancelacion e Hipoteca.';
        end if;
      end if;
    
    end if;
  
    --Se llama un proceso que envia el mensaje segun el tipo de credito aprobado sea.
    if flag_fmv = 'S' then
      if ctipo_pago < 4 then
        -- Se envia correo a traves de este proceso.
        begin
          begin
            select tp1desc
              into li_remitente
              from fst198
             where tp1cod = 1
               and tp1cod1 = 11105
               and tp1corr1 = 26
               and tp1corr2 = 4
               and tp1corr3 = 1;
          end;
          for ce in correo_destinatario loop
            pq_cr_fmv_correos.sp_concatena_mail(trim(li_remitente), --pc_origen => :pc_origen,
                                                trim(ce.tp1desc), --pc_destino => :pc_destino,
                                                titulo, --pc_titulo => :pc_titulo,
                                                mensaje --pc_mensaje => :pc_mensaje);
                                                );
          end loop;
        end;
      end if;
    end if;
  end sp_mail_pagos_tp;
PROCEDURE sp_mail_aprobacion_TP(p_instancia  sng001.sng001inst%type,
                                p_cuenta     xwf700.xwfcuenta%type,
                                p_operacion  xwf700.xwfoperacion%type,
                                p_moneda     xwf700.xwfmoneda%type                                      
                               )
 -- *****************************************************************
    -- Nombre                     : sp_mail_aprobacion_techo_propio
    -- Sistema                    : BANTOTAL
    -- Modulo                     : Creditos - Activas
    -- Version                    : 1.0
    -- Fecha de Creacion          : 28/08/2018
    -- Autor de Creacion          : YLOZADA
    -- Uso                        : Envio de correos por aprobacion de credito Techo Propio.
    -- Estado                     : Activo
    -- Acceso                     : Publico
    -- Parametros de Entrada      : 
    --
    -- Retorno                    : Envio de Correo al analista que genero la solicitud.
    -- Fecha de Modificacion      : 
    -- Autor de la Modificacion   : 
    -- Descripcion de Modificacion: 
    --
    -- *****************************************************************
     IS
     
     titulo varchar2(100);
     mensaje varchar2(500);
     vi_monto      number;
     vi_asesor     char(10);
     vi_origen     number;
     suplente      char(10);
     ln_cuenta varchar2(9);
		 ln_moneda varchar2(3);
		 ln_operacion varchar2(9);
     lc_coderr    varchar2(400);
     lc_deserr    varchar2(400);
     
     begin
       --ASESOR DEL CREDITO.
       
        begin
            select 
                   s.sng001ase, --descomentar en produccion.                   
                   s.sng017mto,
                   s.sng001ori
              into
                   vi_asesor,
                   vi_monto,
                   vi_origen
            from sng001 s
            where s.sng001inst=p_instancia;  
        exception
          when no_data_found then
               vi_asesor:=null;     
          end;
        
        -- Script para verificar suplentes.
        if vi_asesor is not null then
          begin
            select sng057sup
            into suplente
            from sng057 where sng057usr=vi_asesor;
          EXCEPTION
            when no_data_found then
                 suplente := '';
              end;
        end if;
        
        vi_asesor := 'RARMA'; --eliminar línea en pase a producción
       
        begin
            
          ln_cuenta := LPAD(p_cuenta,9,0);
          ln_moneda := lpad(p_moneda,3,0);
          ln_operacion := lpad(p_operacion,9,0);
                
          titulo  := 'Techo Propio - Credito Aprobado';
          mensaje := '<html>El cr&eacute;dito Techo Propio '||ln_cuenta||ln_moneda||ln_operacion||', ya fue aprobado por Back Office, coordine su desembolso con su cliente.</html>';
                                 
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => CASE
                                                                  WHEN trim(vi_asesor) is null THEN
                                                                   trim(suplente)
                                                                  ELSE
                                                                    trim(vi_asesor)
                                                                  END||'@CAJAAREQUIPA.PE',
                                           p_destinatarioscc   => CASE
                                                                  WHEN trim(suplente) is not null THEN
                                                                   trim(suplente)||'@CAJAAREQUIPA.PE'
                                                                  ELSE
                                                                    ''
                                                                  END,
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => mensaje,
                                           p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                           p_asunto            => titulo,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr => lc_coderr,
                                           p_c_deserr => lc_deserr
                                           );
            
                          
       end;  
Exception        
when others then
  null;                  
end sp_mail_aprobacion_TP;	

end;
/

