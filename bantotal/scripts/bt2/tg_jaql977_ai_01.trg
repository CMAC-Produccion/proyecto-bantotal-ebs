CREATE OR REPLACE TRIGGER TG_JAQL977_AI_01
  after insert on JAQL977  
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
    -- Fecha de Modificación      : 26/08/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se agregó tamaño de la variable lv_ubigueo
    -- Fecha de Modificación      : 13/09/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Modificación               : Se cambio estado a P en ichannel alert    
    -- *****************************************************************      
declare
   cursor c_notifica is
     select decode(:new.jaql97787502, 'S', 'REVERSO ' || upper(tp1desc), upper(tp1desc)) Operacion,          
            case
             when TP1IMP2 = 1 then
              'Agencia'
             when TP1IMP2 = 2 then
              'ATM'
             when TP1IMP2 = 3 then
              'Agente'
             when TP1IMP2 = 4 then
              'Internet'
             when TP1IMP2 = 5 then
              ''
           end c1        
       from fst198 x
      where TP1COD   = 1
        and TP1COD1  = 10864
        and TP1CORR1 = 2 
        and tp1nro1  = trim(substr(:new.jaql97787550, 1, 3)) 
        and tp1nro2  = trim(substr(:new.jaql97787550, 4, 3));     
       
  lv_nombre_cliente VARCHAR2(25);       
  lv_OPERACION      VARCHAR2(50);
  lv_MONEDA         VARCHAR2(5);
  ln_MONTO          NUMBER(17,2);
  lv_c1             VARCHAR2(50);
  lv_c4             VARCHAR2(50);
  lv_ubigueo        VARCHAR2(40);
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
  ln_modulo         number(3);
  ln_moneda         number(4);
  ln_subope         number(3);
  ln_tipope         number(3);
  ln_sucursal       number(3);
  lc_sex            char(1);  
  lv_hora           char(8);
begin

     for i in c_notifica loop      
       lv_codigo    := TRIM(:new.JAQL97787716);
       ln_cuenta    := to_number(substr(trim(:new.JAQL97787716),1,9));
       ln_modulo    := to_number(substr(trim(:new.JAQL97787716),10,3));
       ln_moneda    := to_number(substr(trim(:new.JAQL97787716),13,3));       
       ln_subope    := to_number(substr(trim(:new.JAQL97787716),16,2));
       ln_tipope    := to_number(substr(trim(:new.JAQL97787716),18,3));
       lv_OPERACION := trim(i.Operacion);
       if :new.jaql97787547= 604 then
          lv_MONEDA := 'S/.'; 
       Else
          lv_MONEDA := 'USD.';
       End If;
       ln_MONTO     := :new.jaql97787504;
       if trim(:new.jaql97787518) is null then
         lv_ubigueo := trim(:new.jaql97787528);
       Else
         lv_ubigueo := trim(:new.jaql97787518);
       End If;
       lv_c1        := i.c1;
       if trunc(sysdate) = to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd') then
		 lv_c4 := ' hoy a las '||substr(lpad(:new.jaql97787506, 6, '0'), 1, 2) || ':' ||substr(lpad(:new.jaql97787506, 6, '0'), 3, 2);
       Else
         lv_c4:= ' el '||to_char(to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd'), 'dd/mm') || ' ' ||substr(lpad(:new.jaql97787506, 6, '0'), 1, 2) || ':' ||substr(lpad(:new.jaql97787506, 6, '0'), 3, 2); 
       End If;
       lv_hora      := substr(lpad(:new.jaql97787506, 6, '0'), 1, 2) || ':' ||substr(lpad(:new.jaql97787506, 6, '0'), 3, 2) || ':' ||substr(lpad(:new.jaql97787506, 6, '0'), 5, 2);
       --VERIFICAMOS SI ESTA AFILIADO
       BEGIN
         select trim(x.mail_cliente),to_number('51'||trim(x.celular_cliente)),x.enviar_celular,x.enviar_mail
           into lv_mail, ln_celular,lc_mail,lc_cel 
           from ichannelalert.clientes_afiliados x 
          where x.codigo_cliente = lv_codigo 
            and (x.enviar_mail = 'P' or x.enviar_celular = 'P');
            /*and exists(select 1 
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
                                     );*/
            
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
                and z.scmda  = ln_moneda 
                and z.scpap  = 0 
                and z.sccta  = ln_cuenta
                and z.scoper = 0
                and z.scsbop = ln_subope
                and z.sctope = ln_tipope
                and z.scmod  = ln_modulo;
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
             lv_nombre_cliente := null;
             ln_pais           := null;
             ln_tipdoc         := null;
             lc_numdoc         := null;
             lc_sex            := null;
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
                                      and Z0E479SCT = ln_subope
                                      and Z0E479MOD = ln_modulo
                                      and Z0E479MON = ln_moneda
                                      and Z0E479PAP = 0
                                      and Z0E479TOP = ln_tipope
                                      and Z0E479OPE = 0
                                      and Z0E479EST = 'AC'
                                      and rownum = 1                                      
                                  );
           exception
           when others then 
             lv_PUSH_TOKEN := null; 
           end;
           --SI TIENE PUSH
           if lv_PUSH_TOKEN is not null then
               if lc_sex = 'M' then
                  lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
               else
                  lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;                 
               End If;                                  
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
                                   AQPA147est
                                   )                               
                             values(SQ_AH_ID_PUSH.NEXTVAL,
                                   to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd'),
                                   lv_hora,
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
                                   null,--TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')
                                   'N'
                                   );
             exception
             when others then  
               null;
             end;
                          
             If lv_mail is not null and lc_mail = 'P' then
               lv_mensaje :='';
               --REGISTRA NOTIFICACIÓN
               dbms_lob.createtemporary(ll_mensaje, TRUE);               
               if lc_sex = 'M' then
                  lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
               else
                  lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;                 
               End If;                                  
               
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
                                     AQPA147est
                                     )                               
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd'),
                                     lv_hora,
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
                                     null,
                                     'N'--TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0')                              
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
                  lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
               else
                  lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;                 
               End If;                                  
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
                                     AQPA147est
                                     )                               
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd'),
                                     lv_hora,
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
                                     null,--TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0')                              
                                     'N'
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
                   lv_mensaje := 'Estimado '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;
                else
                   lv_mensaje := 'Estimada '||lv_nombre_cliente||' Caja Arequipa le informa sobre la operación '||lv_OPERACION||' por '||lv_MONEDA||trim(to_char(ln_MONTO,'9,999,999.90'))||lv_c4||' realizada en '||lv_c1||': '||lv_ubigueo;                 
                End If;                                  

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
                                     AQPA147est
                                     )                               
                               values(SQ_AH_ID_PUSH.NEXTVAL,
                                     to_date(to_char(:new.jaql97787507), 'rrrr/mm/dd'),
                                     lv_hora,
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
                                     null,--TO_CHAR(i.itfcon,'RRRRMMDD')||lpad(trim(to_char(i.itsuc)),3,'0')||lpad(trim(to_char(i.itmod)),3,'0')||lpad(trim(to_char(i.ittran)),3,'0')||lpad(trim(to_char(i.itnrel)),4,'0')                              
                                     'N'
                                     );
                exception
                when others then  
                  null;
                end;              
             End If;         
           End If;
       End if;
     End loop;
exception
  when others then
     null;    
end TG_JAQL977_AI_01;
/

