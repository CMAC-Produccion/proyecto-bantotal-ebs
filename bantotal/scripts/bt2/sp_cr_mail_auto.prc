create or replace procedure sp_cr_mail_auto(P_N_CODEXC  IN NUMBER,
                                            p_c_coderr out varchar2,
                                            p_c_msgerr out varchar2           
                                            )
-- *****************************************************************
-- Nombre                     : sp_cr_mail_auto
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 15/01/2022
-- Autor de Creación          : YRVING LOZADA
-- Uso                        : ENVIO DE CORREO
-- Estado                     : ACTIVO
-- Acceso                     : PUBLICO
-- Parámetros de Entrada      : P_N_CODEXC
-- Retorno                    : p_c_coderr, p_c_msgerr
-- *****************************************************************
is

  cursor c_autorizador is
    Select distinct aqpc203uex
    from AQPC203 a 
    where a.aqpc203cor = P_N_CODEXC 
      and a.aqpc203est = 'P';
      
  cursor c_bloqueantesl is    
    Select * 
     from AQPC203 a 
    where a.aqpc203cor = P_N_CODEXC 
      and a.aqpc203est = 'P';
      
  cursor c_bloqueantes(cu_autorizador  varchar) is    
    Select * 
     from AQPC203 a 
    where a.aqpc203cor = P_N_CODEXC 
      and a.aqpc203uex = cu_autorizador
      and a.aqpc203est = 'P';
          
  cursor c_archivos(lv_codblq in varchar2) is     
    Select dbms_lob.getlength(a.aqpc204arc) len,
           a.aqpc204arc,
           trim(a.aqpc204nom) aqpc204nom
      from AQPC204 a
     where a.aqpc204co1 = P_N_CODEXC
       and a.aqpc204vre = lv_codblq;
                  
  vblob BLOB;
  vstart NUMBER := 1;
  bytelen NUMBER := 32000;
  len NUMBER;
  my_vr RAW(32000);
  x NUMBER;
  GUIA VARCHAR2(1);
  lv_nomrep        varchar2(30):=null;
  l_output         utl_file.file_type;   
  lv_nomarc        varchar2(250):=null;
  lv_aqpc203vre    aqpc203.aqpc203vre%type;
  lc_Usuario       varchar2(10):= null;
  lc_Analista      varchar2(10):=null;
  ld_usuario       varchar2(50):=null;
  ld_Analista      varchar2(50):=null;
  lc_Cliente       varchar2(250):=null;
  ln_Cuenta        number(9):=0;
  ln_Operacion     number(9):=0;
  lc_Producto      varchar2(30):=null;
  ln_SaldoCapital  number(17,2):=0;
  lc_sucursal      char(30):=null;
  lc_Bloqueante    varchar2(250):=null;
  lc_Comentario    varchar2(250):=null;
  lv_archxblq      varchar2(4000):=null;  
  lv_archivos      varchar2(4000):=null;  
  ll_mensaje       clob;
  ll_mensaje1      clob;  
  lv_mensaje       varchar2(32767);      
  lc_coderr        varchar2(400):= null;
  lc_deserr        varchar2(400):= null;         
  lv_mailbot       varchar2(50):=null;  
  lv_asunto        varchar2(4000):=null;
  lv_asuntoa       varchar2(4000):=null;
  lv_asuntor       varchar2(4000):=null; 
  lv_body          varchar2(4000):=null;         
  lv_bodya         varchar2(4000):=null; 
  lv_bodyr         varchar2(4000):=null; 
  lv_body2         varchar2(4000):=null;           
  lv_body3         varchar2(4000):=null; 
  lv_body4         varchar2(4000):=null; 
  lv_bloqueantes   varchar2(4000):=null; 
  lv_parar         varchar2(200):=null;
  lv_paraa         varchar2(200):=null;
  lv_remit         varchar2(200):=null;
  lv_body21        varchar2(4000):=null; 
  lv_body22        varchar2(4000):=null;
   
  --08.05.2022 variable
  vi_cargo     number(3);
  vi_suc_crd   number(3);
  vi_rcod_crd  number(3);
  vi_autorizador  varchar(10);
  vi_sautorizador varchar(10);
begin
    begin
       for bc in c_bloqueantesl loop
           begin
             select f.tp1imp1
               into vi_cargo
               from fst198 f
               where f.tp1cod   = 1
                 and f.tp1cod1  = 10899
                 and f.tp1corr1 = 400000
                 and f.tp1corr2 > 99 and f.tp1corr2 < 200
                 and f.tp1corr3 = 0                 
                 and f.tp1desc  = rpad(bc.aqpc203vre,30,' ');
           end;
           begin
                begin
                  select a.aqpc202suc
                    into vi_suc_crd
                    from aqpc202 a
                   where a.aqpc202cor = P_N_CODEXC
                     and rownum = 1;
                end;
                begin
                  select f.regcod
                    into vi_rcod_crd
                    from fst811 f
                   where oficod = vi_suc_crd
                     and regcod < 100;
                end;
                
                if vi_cargo <= 202 then
                    begin
                       select s.sng057usr,s.sng057sup
                         into vi_autorizador,vi_sautorizador
                         from fst811 f, sng057 s, fst046 t
                        where s.sng057usr = t.ubuser
                          and s.sng055car = vi_cargo
                          and t.ubsuc = f.oficod
                          and t.ubsuc = vi_suc_crd
                          and regcod = vi_rcod_crd
                          and rownum= 1;
                    end;     
                end if;
                if vi_cargo = 220 then
                    begin
                       select s.sng057usr,s.sng057sup
                         into vi_autorizador,vi_sautorizador
                         from fst811 f, sng057 s, fst046 t
                        where s.sng057usr = t.ubuser
                          and s.sng055car = vi_cargo
                          and t.ubsuc = f.oficod
                          and regcod = vi_rcod_crd                      
                          and rownum= 1;
                    end;     
                end if;
                if vi_cargo = 230 then
                   begin
                       select s.sng057usr,s.sng057sup
                       into vi_autorizador,vi_sautorizador
                       from sng057 s where s.sng055car= vi_cargo 
                       and rownum = 1;
                   end;
                end if;
                     
                if  length(trim(vi_sautorizador)) > 0 then
                    lc_usuario := vi_sautorizador;
                else
                    lc_usuario := vi_autorizador;      
                end if;
           end;
           begin
                 update aqpc203 a
                    set a.aqpc203uex = lc_usuario
                  where a.aqpc203cor = P_N_CODEXC 
                    and a.aqpc203vre = bc.aqpc203vre
                    and a.aqpc203est = 'P';  
           end;
       end loop;
    end;
    lc_usuario := '';
    --Validar que exista registro  
    begin
      Select a.aqpc202usa, 
             a.AQPC202USU,
             a.AQPC202CLI,
             a.AQPC202CTA,
             a.AQPC202OPE,
             a.AQPC202PRO,
             a.AQPC202SAL,
             'S'
        into lc_Usuario,       
             lc_Analista,     
             lc_Cliente,      
             ln_Cuenta,       
             ln_Operacion,    
             lc_Producto,     
             ln_SaldoCapital,
             GUIA
        from AQPC202 a 
       where a.aqpc202cor =  P_N_CODEXC AND A.AQPC202EST = 'P';
    exception
    when others then
      GUIA := 'N';
    end; 
            
    IF GUIA = 'S' THEN        
    for au in c_autorizador loop
        begin
            lc_Usuario := au.aqpc203uex;
            --obtenemos los datos de la tabla AQPC202  
            begin
              Select au.aqpc203uex, 
                     a.AQPC202USU,
                     a.AQPC202CLI,
                     a.AQPC202CTA,
                     a.AQPC202OPE,
                     a.AQPC202PRO,
                     a.AQPC202SAL,
                     'S'
                into lc_Usuario,       
                     lc_Analista,     
                     lc_Cliente,      
                     ln_Cuenta,       
                     ln_Operacion,    
                     lc_Producto,     
                     ln_SaldoCapital,
                     GUIA
                from AQPC202 a 
               where a.aqpc202cor =  P_N_CODEXC AND A.AQPC202EST = 'P';
            exception
            when others then
             GUIA := 'N';
              
            end;  
            
            --OBTENEMOS SUCURSAL DEL ANALISTA
            begin
              Select upper(b.scnom)
                into lc_sucursal                
                from fst046 a,
                     fst001 b
               where a.pgcod = b.pgcod
                 and a.ubsuc = b.sucurs
                 and a.pgcod = 1
                 and a.ubuser = rpad(lc_Analista,10,' ');
            exception
            when others then
              p_c_coderr := '002';
              p_c_msgerr := 'No Se encontro Sucursal';
              return;
            end;  
            
            lv_mailbot := 'autorizacionesBT';
            lv_parar   := lower(trim(lc_usuario))||'@cajaarequipa.pe';  --06.05.2022 - descomentar solo para pruebas
            lv_paraa   := lower(trim(lc_analista))||'@cajaarequipa.pe'; --06.05.2022 - descomentar solo para pruebas 
            --lv_parar := 'hsuarez@cajaarequipa.pe';
            --lv_paraa := 'carlos.lagones@sesitdigital.com';
            
            lv_remit   := 'notificacionesbantotal@cajaarequipa.pe';
            lv_asunto  := 'Autorización de excepciones reprogramación sin capitalización Cuenta:'||ln_cuenta||' Operación:'||ln_Operacion; 
              
          /*  lc_usuario := 'ylozada';
            lc_analista := 'ylozada';
            ln_cuenta := 649628;
            ln_operacion:= 123456;  
            lc_Producto:= 'Capital de Trabajo';
            ln_SaldoCapital := 1000.98;
            lc_Cliente := 'LOZADA BUSTAMANTE,YRVING RUBEN';
            lc_Comentario := 'CONFORME CON TODO LO SOLICITADO';*/
            
            dbms_lob.createtemporary(ll_mensaje, TRUE);   
            dbms_lob.createtemporary(ll_mensaje1, TRUE); 
            
            select t.ubnom into ld_usuario  from FST746 t WHERE UBUSER =  RPAD(lc_usuario,10,' ');
            select t.ubnom into ld_analista  from FST746 t WHERE UBUSER = RPAD(lc_analista,10,' ');
            
             --               
            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): '||ld_usuario||'</p>' ||  
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene las siguientes excepciones por autorizar que corresponden a las reprogramaciones sin capitalización del Cliente '||lc_Cliente||', con cuenta y operación  '||ln_cuenta||'- '||ln_Operacion||':</p>'||
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Producto: '||lc_Producto||'</p>'||      
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Saldo Capital: '||trim(to_char(ln_SaldoCapital,'99,999,999.99'))||'</p>';                                                                                      
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                  
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 

            lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): '||ld_analista||'</p>' ||  
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Tiene las siguientes excepciones pendientes de ser autorizadas, que corresponden a las reprogramaciones sin capitalización del Cliente '||lc_Cliente||', con cuenta y operación  '||ln_cuenta||'- '||ln_Operacion||':</p>'||
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Producto: '||lc_Producto||'</p>'||      
                          '<p "font-family: Arial, sans-serif; font-size: 14px;">Saldo Capital: '||trim(to_char(ln_SaldoCapital,'99,999,999.99'))||'</p>';   
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);                    
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);                  
                    
            lv_mensaje :=                                              
            '<style  type="text/css">td {font-family: Arial, sans-serif; font-size: 14px;}</style>' ||
            '<table cellspacing=0 cellpadding=3 width=900 border="1">';
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);      
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje); 
              
            lv_mensaje :=         
            '  <tr>'||
            '    <td width="300" style="border-bottom: 1px solid black;"><b>Bloqueante</b></td>'||
            '    <td width="300" style="border-bottom: 1px solid black;"><b>Sustento</b></td>'||
            '    <td width="300" style="border-bottom: 1px solid black;"><b>Archivo Adjunto</b></td>'||              
            '  </tr>          ';   
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);      
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);   
              
            lv_nomrep :='DTPUMP_PR_EMAIL';
            vstart  := 1;
            bytelen := 32000;  
            --armamos el detalle de los bloqueantes
            --Limpiams variable 08.05.2022
            
            lv_bloqueantes := '';
            lv_archivos:='';
            lv_archxblq:='';
            
            For i in c_bloqueantes(au.aqpc203uex) loop
              lc_Bloqueante := TRIM(i.aqpc203dre);
              lv_bloqueantes := lv_bloqueantes||lc_Bloqueante||',';
              lc_Comentario := i.aqpc203com;
              lv_aqpc203vre := i.aqpc203vre;
              
              for j in c_archivos(lv_aqpc203vre) loop
                len := j.len;
                vblob := j.aqpc204arc;         
                lv_nomarc := trim(j.aqpc204nom);
                --
                --extraemos el arvhivo de la tabla y lo descargamos en el repositorio extractos    
                --  
                -- define output directory
                l_output := utl_file.fopen(lv_nomrep, lv_nomarc,'wb', 32760);

             
                -- save blob length
                x := len;

                -- if small enough for a single write
                If len < 32760 then
                  utl_file.put_raw(l_output,vblob);
                  utl_file.fflush(l_output);
                Else -- write in pieces
                    vstart := 1;
                    bytelen := 32000;
                    While vstart < len and bytelen > 0
                    Loop
                       dbms_lob.read(vblob,bytelen,vstart,my_vr);

                       utl_file.put_raw(l_output,my_vr);
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
                --fin descarga
                lv_archxblq := lv_archxblq ||lv_nomarc||';';      
              End loop;     
              lv_archxblq := substr(lv_archxblq,1,length(lv_archxblq)-1); 
                  
              lv_mensaje :=         
              '  <tr>'||
              '    <td width="300" style="border-bottom: 1px solid black;">'||trim(lc_Bloqueante)||'</td>'||
              '    <td width="300" style="border-bottom: 1px solid black;">'||trim(lc_Comentario)||'</td>'||
              '    <td width="300" style="border-bottom: 1px solid black;">'||trim(lv_archxblq)||'</td>'||             
              '  </tr>          ';  
              lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);        
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);    
                 
              if lv_archxblq is not null then   
                 lv_archivos := lv_archivos ||lv_archxblq||';'; 
              End if; 
              lv_archxblq := '';   
            End Loop;
            lv_archivos := substr(lv_archivos,1,length(lv_archivos)-1); 
            lv_bloqueantes := substr(lv_bloqueantes,1,length(lv_bloqueantes)-1);       
            
            lv_mensaje := 
            '</table>'||
            '<br/>';
            lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);      
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);   
            
            lv_mensaje :=                                              
            '<table cellspacing=0 cellpadding=3 width=900>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje); 
            
            --
            -- ARMAMOS CURPO Y ASUNTO DE MAIL DE APROBACION O RECHAZO
            --
            -- 06.05.2022 - SE REALIZO EL CAMBIO DONDE DICE AUTORIZACION/RECHAZO POR ALGO MAS DINAMICO.
            
            lv_body21 := 'Se realizó la autorización de las bloqueantes solicitadas que corresponden a las reprogramaciones sin capitalización del Cliente '||lc_cliente||', con cuenta y operación: '||ln_cuenta||' - '||ln_operacion;
            lv_body21 := replace(lv_body21,' ','%20');
            
            lv_body22 := 'Se realizó el rechazo de las bloqueantes solicitadas que corresponden a las reprogramaciones sin capitalización del Cliente '||lc_cliente||', con cuenta y operación: '||ln_cuenta||' - '||ln_operacion;
            lv_body22 := replace(lv_body22,' ','%20');
            
            lv_body3 :=
                '- ID de Excepcion: '|| P_N_CODEXC ||'%0D%0A'||
                '- Autorizador: '||lc_usuario|| '%0D%0A'||
                '- Analista: '||lc_analista|| '%0D%0A'||
                '- Sucursal: '||lc_sucursal|| '%0D%0A'||      
                '- Producto: '||lc_Producto|| '%0D%0A'||           
                '- Saldo Capital: '||trim(to_char(ln_SaldoCapital,'99,999,999.99'))|| '%0D%0A'||      
                '- Bloqueantes: '||lv_bloqueantes|| '%0D%0A'||                   
                '- Estado: Autorizado';
            lv_body3 := replace(lv_body3,' ','%20');     
            lv_body4 :=
                '- ID de Excepcion: '|| P_N_CODEXC ||'%0D%0A'||
                '- Autorizador: '||lc_usuario|| '%0D%0A'||
                '- Analista: '||lc_analista|| '%0D%0A'|| 
                '- Sucursal: '||lc_sucursal|| '%0D%0A'||         
                '- Producto: '||lc_Producto|| '%0D%0A'||           
                '- Saldo Capital: '||trim(to_char(ln_SaldoCapital,'99,999,999.99'))|| '%0D%0A'||    
                '- Bloqueantes: '||lv_bloqueantes|| '%0D%0A'||                 
                '- Estado: Rechazado';
            lv_body4 := replace(lv_body4,' ','%20');   
               
            lv_asuntoa := 'Se Autoriza la Solicitud de Excepción de las Reglas de Reprogramados para ';
            lv_asuntoa := replace(lv_asuntoa,' ','%20')||ln_cuenta||'-'||ln_operacion;
            lv_asuntor := 'Se Rechaza la Solicitud de Excepción de las Reglas de Reprogramados para ';
            lv_asuntor := replace(lv_asuntor,' ','%20')||ln_cuenta||'-'||ln_operacion;   
            lv_asuntoa := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntoa);    
            lv_asuntor := pq_ah_email_trx.fn_ah_replace_tildes(lv_asuntor);        
            
            lv_body   := 'Comentarios del Autorizador: ';
            lv_bodya   := replace(trim(lv_body),' ','%20')/*||replace(trim(lc_Comentario),' ','%20')*/||'%0D%0A%0D%0A'||lv_body21||'%0D%0A%0D%0A'||lv_body3;
            lv_bodyr   := replace(trim(lv_body),' ','%20')/*||replace(trim(lc_Comentario),' ','%20')*/||'%0D%0A%0D%0A'||lv_body22||'%0D%0A%0D%0A'||lv_body4;  
            lv_bodya := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodya);    
            lv_bodyr := pq_ah_email_trx.fn_ah_replace_tildes(lv_bodyr);   
            
            --FIN ARMADO
            --06.05.2022 - SE CAMBIO EL CC POR QUE SE ESTA ENVIADO AL MISMO AUTORIZADOR, DEBIENDO SER ANALISTA O ASESOR.  
            lv_mensaje :=         
            '  <tr>'||
            '    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc='||lower(lc_analista)||'@cajaarequipa.pe&Subject='||lv_asuntoa||'&body='||lv_bodya||'">AUTORIZAR</a></b></td>'||
            --'    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc=carlos.lagones@sesitdigital.com;hsuarez@cajaarequipa.pe&Subject='||lv_asuntoa||'&body='||lv_bodya||'">AUTORIZAR</a></b></td>'||
            '    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc='||lower(lc_analista)||'@cajaarequipa.pe&Subject='||lv_asuntor||'&body='||lv_bodyr||'">RECHAZAR</a></b></td>'||          
            --'    <td width="300"><b><a href="mailto:'||lv_mailbot||'@cajaarequipa.pe?cc=carlos.lagones@sesitdigital.com;hsuarez@cajaarequipa.pe&Subject='||lv_asuntor||'&body='||lv_bodyr||'">RECHAZAR</a></b></td>'||          
            '  </tr> ';           
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
            
            lv_mensaje := 
            '</table>'||
            '<br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);  
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje); 
                    
            lv_mensaje := 
            '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos cordiales,<br/>Caja Arequipa</strong></p>';                                          
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
            dbms_lob.writeappend(ll_mensaje1, length(lv_mensaje), lv_mensaje);     
            
            --envio correo usuario aprobador
            
            begin           
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_parar,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje,
                                               p_remitente         => lv_remit,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => lv_nomrep,
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => lc_coderr,
                                               p_c_deserr          => lc_deserr
                                               );

            end;   
            
            --Envio correo a analista sin links de aprobaciones
            begin           
              -- Call the procedure
              pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_paraa,
                                               p_destinatarioscc   => '',
                                               p_destinatariosbcc  => '',
                                               p_mensaje           => ll_mensaje1,
                                               p_remitente         => lv_remit,
                                               p_asunto            => lv_asunto,
                                               p_tipomensaje       => 'HTML',
                                               p_directorio        => lv_nomrep,
                                               p_archivosadjuntos  => lv_archivos,
                                               p_c_coderr          => lc_coderr,
                                               p_c_deserr          => lc_deserr
                                               );

            end;   
            
            dbms_lob.freetemporary(ll_mensaje);
            dbms_lob.freetemporary(ll_mensaje1);  
            
            p_c_coderr := lc_coderr;   
            if p_c_coderr = '000' then
               p_c_msgerr := 'Envío Satisfactorio, revise su bandeja de correo electrónico.';   
            Else
               p_c_msgerr := lc_deserr;     
            End if;
            
            --actualizamos la tabla
            begin
              update AQPC202 a
                 set a.aqpc202est = decode(p_c_coderr, '000', 'S', 'N'),
                     A.AQPC202MSG = substr(p_c_msgerr, 1, 100)
               where a.aqpc202cor = P_N_CODEXC;
               if sql%notfound then 
                  p_c_coderr := '004';
                  p_c_msgerr := 'Ocurrio un error al procesar la información, vuelva a intentar.';    
                  return;              
               Else
                 commit;
               End If; 
            End;
         Exception 
         when others then  
            p_c_coderr := sqlcode;
            p_c_msgerr := sqlerrm;  
         end;
    end loop;--FIN DEL CICLO 08.05.2022  
    ELSE 
      p_c_coderr := '001';
              p_c_msgerr := 'No existe(n) registro(s) para autorizar.';
    END IF;
end sp_cr_mail_auto;
/

