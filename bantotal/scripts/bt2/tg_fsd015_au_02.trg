CREATE OR REPLACE TRIGGER TG_FSD015_AU_02
  after update on fsd015
  FOR EACH ROW

    -- *****************************************************************
    -- Nombre                     : Enviar correo sms push notificaciones
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.12.22
    -- Autor de Creación          : YLOZADA
    -- Uso                        : Envía notificaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    -- Retorno                    :
    -- Fecha de Modificación      : 22/07/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se agregó validación de estado al obtener la TDV
    -- Fecha de Modificación      : 22/08/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se agregó notificación para cuentas de trabajadores TI
    -- Fecha de Modificación      : 13/09/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se cambio estado a P en ichannel alert
    -- Fecha de Modificación      : 13/02/2025
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se adicionaron nuevos campos a la tabla aqpa147
    -- Fecha de Modificación      : 06/03/2025
    -- Autor de la Modificación   : Renzo Cuadros
    -- Modificación               : Se cambió de donde se obtiene la sucursal
    -- Fecha de Modificación      : 15/04/2025
    -- Autor de la Modificación   : Hernán Laqui
    -- Modificación               : Se agrega logica para cuentas DPF (módulo 22)
    -- Fecha de Modificación      : 23/04/2025
    -- Autor de la Modificación   : Hernán Laqui
    -- Modificación               : Se agrega logica el tipo de operacion DPF (módulo 22)
    -- Fecha de Modificación      : 24/04/2025
    -- Autor de la Modificación   : Hernán Laqui
    -- Modificación               : Se agrega la consulta para la operacion (módulo 22)
    -- Fecha de Modificación      : 02/05/2025
    -- Autor de la Modificación   : Renzo Cuadros
    -- Modificación               : Se agrega beneficiario para envio/abono en transferencias a contacto
    -- Fecha de Modificación      : 23/05/2025
    -- Autor de la Modificación   : Renzo Cuadros
    -- Modificación               : Se agrega trim al campo push token para envitar errores en envios
    -- Fecha de Modificación      : 23/06/2025
    -- Autor de la Modificación   : Renzo Cuadros
    -- Modificación               : Se intercambian los flags de celular y mail
    -- Fecha de Modificación      : 14/07/2025
    -- Autor de la Modificación   : Renzo Cuadros
    -- Modificación               : Se toma en cuenta el flag en 'S' para celular y correo
    -- Fecha de modificación      : 22/09/2025
    -- Autor de la modificación   : Renzo Cuadros
    -- Modificación               : Se obtiene datos del cliente juridico de la FSD001    
    -- *****************************************************************
declare
   cursor c_notifica is
    select e.scnom ubigueo,
           case
             when b.itmod = 99 and b.ittope = 2 then
              upper(trim(c.tp1desc)) || ' CTS'
             when b.itmod = 99 and b.ittope = 6 then
              upper(trim(c.tp1desc)) || ' REM'
             Else
              upper(trim(c.tp1desc))
           End Operacion,
           to_char(:old.itfcon, 'dd/mm/rrrr') fecha,
           :old.ithora hora,
           decode(b.moneda, 0, 'S/.', 'USD.') c_moneda,
           case when b.modulo = 21 then
                lpad(b.ctnro, 9, '0') || lpad(b.modulo, 3, '0') ||
                lpad(b.moneda, 3, '0') || lpad(b.itsubo, 2, '0') ||
                lpad(b.ittope, 3, '0')
           else
                lpad(b.ctnro, 9, '0') || lpad('22',3, '0') ||
                lpad(b.moneda, 3, '0') || lpad(b.itoper, 9, '0') ||
                (select lpad(x.SCTOPE, 3, '0')  from fsd011 x where x.PGCOD=1 and x.SCCTA=b.ctnro and x.SCOPER=itoper and x.SCMOD=22 and x.SCMDA=b.moneda)
           end
            CODIGO,
           b.itimp1 monto,
           case
             when TP1IMP2 = 1 then
              'Agencia'
             else
              ''
           end c1,
           decode(trunc(sysdate),
                  :old.itfcon,
                  ' hoy a las',
                  ' el ' || to_char(:old.itfcon, 'dd/mm')) || ' ' ||
           substr(:old.ithora, 1, 5) c4,
           b.itsuc,
           b.itmod,
           b.ittran,
           b.itnrel,
           b.ctnro,
           --Hlaqui 23/04/2025
           case when b.modulo = 21 then b.modulo else 22 end modulo,
           b.moneda,
           b.papel,
           b.itsubo,
           --Hlaqui 23/04/2025
           case when b.modulo = 21 then
                b.ittope
           else
                (select x.SCTOPE from fsd011 x where x.PGCOD=1 and x.SCCTA=b.ctnro and x.SCOPER=itoper and x.SCMOD=22 and x.SCMDA=b.moneda)
           end ittope,
           b.itoper,
           :old.itfcon itfcon
      from fsd016 b, fst198 c, fst001 e
     where b.itmod  = c.tp1nro1
       and b.ittran = c.tp1nro2
       and b.itord  = c.tp1nro3
       and b.modulo = c.tp1corr3
       and b.pgcod  = e.pgcod
       and e.pgcod  = c.tp1cod
       and b.itsuc  = e.sucurs
       and c.TP1COD = 1
       and c.TP1COD1 = 10825
       and c.TP1CORR1 = 8
       and c.TP1IMP3 = 1 --Hlaqui 04/06/2025 - Se cambia TP1IMP1 por TP1IMP3
       and b.pgcod  = :old.pgcod
       and b.itsuc  = :old.itsuc
       and b.itmod  = :old.itmod
       and b.ittran = :old.ittran
       and b.itnrel = :old.itnrel;

  lv_recipient      VARCHAR2(100);
  lv_nombre_cliente VARCHAR2(25);
  lv_OPERACION      VARCHAR2(50);
  lv_MONEDA         VARCHAR2(5);
  ln_MONTO          NUMBER(17,2);
  lv_c1             VARCHAR2(50);
  lv_c4             VARCHAR2(50);
  lv_ubigueo        VARCHAR2(30);
  lv_codigo         VARCHAR2(30);
  ln_cuenta         number(9);
  lv_PUSH_TOKEN     VARCHAR2(300);
  lv_mensaje        VARCHAR2(4000):='';
  lv_mail           VARCHAR2(400):='';
  ln_celular        number(12);
  ll_mensaje        CLOB;
  lc_mail           char(1):='N';
  lc_cel            char(1):='N';
  ln_pais           number(3);
  ln_tipdoc         number(2);
  lc_numdoc         char(12);
  lc_sex            char(1);
  ln_sucursal       number(3);
begin
  if :new.ITCONT = 'S' and :old.itcorr= 0 then
     for i in c_notifica loop
       lv_codigo    := trim(i.CODIGO);
       ln_cuenta    := to_number(substr(i.CODIGO,1,9));
       lv_OPERACION := trim(i.Operacion);
       lv_MONEDA    := i.c_moneda;
       ln_MONTO     := i.monto;
       lv_ubigueo   := trim(i.ubigueo);
       lv_c1        := trim(i.c1);
       lv_c4        := i.c4;

       --VERIFICAMOS SI ESTA AFILIADO
       BEGIN
         select trim(x.mail_cliente),to_number('51'||trim(x.celular_cliente)),
           case when x.enviar_mail = 'S' then 'P' else x.enviar_mail end enviar_mail,
           case when x.enviar_celular = 'S' then 'P' else x.enviar_celular end enviar_celular -- rcuadros 23/06/2025
           into lv_mail, ln_celular,lc_mail,lc_cel
           from ichannelalert.clientes_afiliados x
          where x.codigo_cliente = lv_codigo
            and (x.enviar_mail in ('P', 'S') or x.enviar_celular in ('P', 'S'));
            /*  and exists(select 1
                         from fst198 z
                        where z.tp1cod   = 1
                          and z.tp1cod1  = 10825
                          and z.tp1corr1 = 130
                          and z.tp1desc = rpad(x.codigo_cliente,30,' ')
                      );
            and exists(select 1
                         from fsr008 z,
                              fsd002 y
                        where z.pepais = y.pfpais
                          and z.petdoc = y.pftdoc
                          and z.pendoc = y.pfndoc
                          and z.ctnro  = substr(x.codigo_cliente,1,9)
                          and y.pfebco = 'S'
                      );
                      */
            /*and x.codigo_cliente in ('00160398602100006001',
                                     '00051099202100001001',
                                     '00051099202100002006',
                                     '00051099202100003002',
                                     '00051099202100011012',
                                     '00051099202110104001',
                                     '00064962802100003006',
                                     '00064962802100022012',
                                     '00064962802100021012'
                                     );   */
       EXCEPTION
       WHEN OTHERS THEN
         lv_mail    := null;
         ln_celular := null;
       END;
       --SOLO SI ESTA AFILIADO HACEMOS ALGO SI NO SALIMOS
       If lv_mail is not null or ln_celular is not null then
           --OBTENEMOS SUCURSAL DE LA CUENTA PARA OBTENER EL TOKEM
           begin
             select z.scsuc
               into ln_sucursal
               from fsd011 z
              where z.pgcod  = 1
                and z.scmda  = i.moneda
                and z.scpap  = 0
                and z.sccta  = ln_cuenta
                and z.scoper = i.itoper --Hlaqui 24/04/2025 se reemplaza 0 por el valor de la Operacion
                and z.scsbop = i.itsubo
                and z.sctope = i.ittope
                and z.scmod  = i.modulo;
           exception
           when others then
             ln_sucursal := null;
           end;
           --OBTENEMOS NOMBRE DEL CLIENTE
           begin
             select trim(upper(a.pfnom1)),a.pfpais,a.pftdoc,a.pfndoc,a.pfcant
               into lv_nombre_cliente,ln_pais,ln_tipdoc,lc_numdoc,lc_sex
              from fsd002 a,
                   fsr008 b
              where a.pfpais = b.pepais
                and a.pftdoc = b.petdoc
                and a.pfndoc = b.pendoc
                and b.ctnro  = ln_cuenta
                and b.pgcod  = 1
                and b.ttcod  = 1
                and b.cttfir = 'T';
           exception
           when others then
              -- rcuadros 22/09/2025
              begin
                  select trim(upper(SUBSTR(a.penom, 1, 25))), a.pepais, a.petdoc, a.pendoc, 'N'
                  into lv_nombre_cliente, ln_pais, ln_tipdoc, lc_numdoc, lc_sex
                  from fsd001 a, fsr008 b
                  where a.pepais = b.pepais
                    and a.petdoc = b.petdoc
                    and a.pendoc = b.pendoc
                    and b.ctnro  = ln_cuenta
                    and b.pgcod  = 1
                    and b.ttcod  = 1
                    and b.cttfir = 'T';
              exception
              when others then
                 lv_nombre_cliente := null;
                 ln_pais           := null;
                 ln_tipdoc         := null;
                 lc_numdoc         := null;
                 lc_sex            := null;
               end;
           end;

           -- VERIFICAMOS SI TIENE PUSH ACTIVO
           begin
            select JAQZ205AUX2
              into lv_PUSH_TOKEN
              from jaqz205
             where jaqz205nutar = (select z0e478nro
                                     from z0e479
                                    where Z0E479SUC = ln_sucursal
                                      and Z0E479CTA = ln_cuenta
                                      and Z0E479SCT = i.itsubo
                                      and Z0E479MOD = i.modulo
                                      and Z0E479MON = i.moneda
                                      and Z0E479PAP = i.papel
                                      and Z0E479TOP = i.ittope
                                      and Z0E479OPE = i.itoper
                                      and Z0E479EST = 'AC'
                                      and rownum = 1
                                  );
           exception
           when others then
             lv_PUSH_TOKEN := null;
           end;

           --OBTENEMOS LA SUCURSAL
            BEGIN
              SELECT TRIM(tp1desc) tp1desc
                INTO lv_ubigueo
                FROM fst198
               WHERE tp1cod1 = 11143
                 AND tp1corr1 = 15
                 AND tp1corr2 = 1
                 AND tp1corr3 > 0
                 AND tp1nro1 = i.itmod
                 AND tp1nro2 = i.ittran;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
            END;

            --OBTENEMOS EL DESTINO / ORIGEN
            -- rcuadros 02/05/2025
            BEGIN
              SELECT COALESCE(
                -- JAQL706: envio
                (SELECT ' para ' || TRIM(JAQL706NOBE)
                 FROM JAQL706
                 WHERE JAQL706ITCD = 1 + UID * 0
                   AND JAQL706ITSU = i.itsuc
                   AND JAQL706ITMO = i.itmod
                   AND JAQL706ITTR = i.ittran
                   AND JAQL706ITRE = i.itnrel
                   AND JAQL706ITFC = i.itfcon
                 FETCH FIRST 1 ROWS ONLY),
                -- JAQL707: abono
                (SELECT ' de ' || TRIM(JAQL707NOOR)
                 FROM JAQL707
                 WHERE JAQL707ITCD = 1 + UID * 0
                   AND JAQL707ITSU = i.itsuc
                   AND JAQL707ITMO = i.itmod
                   AND JAQL707ITTR = i.ittran
                   AND JAQL707ITRE = i.itnrel
                   AND JAQL707ITFC = i.itfcon
                 FETCH FIRST 1 ROWS ONLY)
              )
              INTO lv_recipient
              FROM DUAL;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                lv_recipient := NULL;
              WHEN OTHERS THEN
                lv_recipient := NULL;
            END;

           --SI TIENE PUSH
           if TRIM(lv_PUSH_TOKEN) is not null then -- rcuadros 23/05/2025
              if lc_sex = 'M' then
                 lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
              else
                 if lc_sex = 'N' then -- rcuadros 22/09/2025
                    lv_mensaje := 'Estimado cliente Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                 else
                    lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                 end if;
              end if;
             --REGISTRA NOTIFICACIÓN
             begin
               insert into AQPA147(AQPA147cor,
                                   AQPA147fec,
                                   AQPA147hor,
                                   AQPA147med,
                                   AQPA147ori,
                                   AQPA147msg,
                                   AQPA147des,
                                   AQPA147cta,
                                   AQPA147pai,
                                   AQPA147tpo,
                                   AQPA147num,
                                   AQPA147mon,
                                   AQPA147top,
                                   AQPA147nop,
                                   AQPA147est,
                                   AQPA147SUC,
                                   AQPA147MOD,
                                   AQPA147TRA,
                                   AQPA147REL,
                                   AQPA147FCO
                                   )
                             values(SQ_AH_ID_PUSH.NEXTVAL,
                                   --i.itfcon,
                                   TRUNC(SYSDATE),
                                   i.hora,
                                   'PUSH',
                                   'BANTOTAL',
                                   lv_mensaje,
                                   lv_PUSH_TOKEN,
                                   lv_codigo,
                                   ln_pais,
                                   ln_tipdoc,
                                   lc_numdoc,
                                   ln_MONTO,
                                   lv_OPERACION,
                                   TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0'),
                                   'N',
                                   i.itsuc,
                                   i.itmod,
                                   i.ittran,
                                   i.itnrel,
                                   i.itfcon
                                   );
             exception
             when others then
               null;
             end;

             If lv_mail is not null and lc_mail = 'P' then
               --REGISTRA NOTIFICACIÓN
               dbms_lob.createtemporary(ll_mensaje, TRUE);
                if lc_sex = 'M' then
                   lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                else
                   if lc_sex = 'N' then -- rcuadros 22/09/2025
                      lv_mensaje := 'Estimado cliente Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   else
                      lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   end if;
                end if;
               lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">'||lv_mensaje||'</p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

               lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

               lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
               begin
                 insert into AQPA147(AQPA147cor,
                                     AQPA147fec,
                                     AQPA147hor,
                                     AQPA147med,
                                     AQPA147ori,
                                     AQPA147msg,
                                     AQPA147des,
                                     AQPA147cta,
                                     AQPA147pai,
                                     AQPA147tpo,
                                     AQPA147num,
                                     AQPA147mon,
                                     AQPA147top,
                                     AQPA147nop,
                                     AQPA147est,
                                     AQPA147SUC,
                                     AQPA147MOD,
                                     AQPA147TRA,
                                     AQPA147REL,
                                     AQPA147FCO
                                     )
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     --i.itfcon,
                                     TRUNC(SYSDATE),
                                     i.hora,
                                     'CORREO',
                                     'BANTOTAL',
                                     ll_mensaje,
                                     lv_mail,
                                     lv_codigo,
                                     ln_pais,
                                     ln_tipdoc,
                                     lc_numdoc,
                                     ln_MONTO,
                                     lv_OPERACION,
                                     TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0'),
                                     'N',
                                     i.itsuc,
                                     i.itmod,
                                     i.ittran,
                                     i.itnrel,
                                     i.itfcon
                                     );
               exception
               when others then
                 null;
               end;
               dbms_lob.freetemporary(ll_mensaje);
             end if;
           else
             --REGISTRA NOTIFICACIÓN MAIL
             if lv_mail is not null and lc_mail = 'P' then
               --REGISTRA NOTIFICACIÓN
               dbms_lob.createtemporary(ll_mensaje, TRUE);
                if lc_sex = 'M' then
                   lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                else
                   if lc_sex = 'N' then -- rcuadros 22/09/2025
                      lv_mensaje := 'Estimado cliente Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   else
                      lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   end if;
                end if;
               lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">'||lv_mensaje||'</p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

               lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

               lv_mensaje :='<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>NOTA: NO RESPONDER A ESTE CORREO.</strong></p>';
               dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
               begin
                 insert into AQPA147(AQPA147cor,
                                     AQPA147fec,
                                     AQPA147hor,
                                     AQPA147med,
                                     AQPA147ori,
                                     AQPA147msg,
                                     AQPA147des,
                                     AQPA147cta,
                                     AQPA147pai,
                                     AQPA147tpo,
                                     AQPA147num,
                                     AQPA147mon,
                                     AQPA147top,
                                     AQPA147nop,
                                     AQPA147est,
                                     AQPA147SUC,
                                     AQPA147MOD,
                                     AQPA147TRA,
                                     AQPA147REL,
                                     AQPA147FCO
                                     )
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     --i.itfcon,
                                     TRUNC(SYSDATE),
                                     i.hora,
                                     'CORREO',
                                     'BANTOTAL',
                                     ll_mensaje,
                                     lv_mail,
                                     lv_codigo,
                                     ln_pais,
                                     ln_tipdoc,
                                     lc_numdoc,
                                     ln_MONTO,
                                     lv_OPERACION,
                                     TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0'),
                                     'N',
                                     i.itsuc,
                                     i.itmod,
                                     i.ittran,
                                     i.itnrel,
                                     i.itfcon
                                     );
               exception
               when others then
                 null;
               end;
               dbms_lob.freetemporary(ll_mensaje);
             End If;
             --REGISTRA NOTIFICACIÓN SMS
             if ln_celular is not null and lc_cel = 'P' then
                if lc_sex = 'M' then
                   lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                else
                   if lc_sex = 'N' then -- rcuadros 22/09/2025
                      lv_mensaje := 'Estimado cliente Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   else
                      lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_recipient||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                   end if;
                end if;
                begin
                 insert into AQPA147(AQPA147cor,
                                     AQPA147fec,
                                     AQPA147hor,
                                     AQPA147med,
                                     AQPA147ori,
                                     AQPA147msg,
                                     AQPA147des,
                                     AQPA147cta,
                                     AQPA147pai,
                                     AQPA147tpo,
                                     AQPA147num,
                                     AQPA147mon,
                                     AQPA147top,
                                     AQPA147nop,
                                     AQPA147est,
                                     AQPA147SUC,
                                     AQPA147MOD,
                                     AQPA147TRA,
                                     AQPA147REL,
                                     AQPA147FCO
                                     )
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     --i.itfcon,
                                     TRUNC(SYSDATE),
                                     i.hora,
                                     'CELULAR',
                                     'BANTOTAL',
                                     lv_mensaje,
                                     ln_celular,
                                     lv_codigo,
                                     ln_pais,
                                     ln_tipdoc,
                                     lc_numdoc,
                                     ln_MONTO,
                                     lv_OPERACION,
                                     TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0'),
                                     'N',
                                     i.itsuc,
                                     i.itmod,
                                     i.ittran,
                                     i.itnrel,
                                     i.itfcon
                                     );
                exception
                when others then
                  null;
                end;
             End If;
           End If;
       End if;
     End loop;
  end if;
exception
  when others then
     null;
end TG_FSD015_AU_02;
/
