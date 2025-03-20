create or replace procedure sp_ah_mail_asignacion_tasa_pos(P_N_PGCOD   IN NUMBER,
                                                           P_N_HCMOD   IN NUMBER,
                                                           P_N_HSUCOR  IN NUMBER,
                                                           P_N_HTRAN   IN NUMBER,
                                                           P_N_HNREL   IN NUMBER,
                                                           P_D_HFCON   IN DATE,
                                                           P_N_TXOREN  IN NUMBER,
                                                           P_N_TXTSUC  IN NUMBER,
                                                           P_N_TXTMDA  IN NUMBER,
                                                           P_N_TXTPAP  IN NUMBER,
                                                           P_N_TXTCTA  IN NUMBER,
                                                           P_N_TXTOPE  IN NUMBER,
                                                           P_N_TXTSBO  IN NUMBER,
                                                           P_N_TXTTOP  IN NUMBER,
                                                           P_N_TXTMOD  IN NUMBER,
                                                           P_N_INDITR  IN NUMBER,
                                                           P_N_TASA    IN NUMBER,
                                                           P_N_TAST    IN NUMBER,
                                                           P_D_FECVAL  IN DATE,
                                                           P_C_USUARIO IN VARCHAR2
                                                           ) is
  lv_mensaje    VARCHAR2(32767);
  ll_mensaje    CLOB;  
  lv_mail       varchar2(30); 
  lv_maeje      varchar2(30); 
  ln_tasa       fsd010.aotasa%type; 
  ln_monto      fsd010.aoimp%type; 
  ln_plazo      fsd010.aopzo%type; 
  ld_fecvig     date;
  ld_fecpro     date;  
  lc_usuario    char(10);
  lc_hora       char(8);
  lc_tiptas     varchar2(30);
  ln_pais       fsd002.pfpais%type;
  ln_tipo       fsd002.pftdoc%type;      
  ln_numdoc     fsd002.pfndoc%type;     
  ln_pais2      fsd002.pfpais%type;
  ln_tipo2      fsd002.pftdoc%type;   
  ln_numdoc2    fsd002.pfndoc%type;     
  lc_apepat     fsd002.pfape1%type;     
  lc_prinom     fsd002.pfnom1%type;     
  lc_sucursal   fst001.scnom%type;     
  ln_ubsuc      fst046.ubsuc%type;  
  lc_valor      char(5);   
  lc_agente     char(10);   
  lc_sucage     number(3);
  ld_pgfape     date;
  lc_coderr     varchar2(4000);
  lc_deserr     varchar2(4000);
  ln_ejec       number(9):=0;
  lc_iswork     char(2):='NO';
  ld_fecpla     date;
  ld_moneda     number(3);
  ln_tgcod      number(2);
  ln_grnro      number(7);
  lv_motivo     varchar2(4000):='';
  lv_estado     varchar2(1):='N';
  ln_cont       number(9):=0;
  
  cursor c_mail is
   select lower(trim(tp1desc)) mail,
          tp1nro1
      into lv_mail,
           ln_ejec
      from fst198
     where tp1cod   = 1
       and tp1cod1  = 10825
       and tp1corr1 = 23
       and tp1corr2 = 2;  

begin
    begin
      select a.aotasa, 
             a.aoimp, 
             a.aopzo,
             a.aofval,
             a.aomda
        into ln_tasa, 
             ln_monto, 
             ln_plazo,
             ld_fecpla,
             ld_moneda
        from fsd010 a
       where a.pgcod  = P_N_PGCOD
         and a.aomod  = P_N_TXTMOD
         and a.aosuc  = P_N_TXTSUC
         and a.aomda  = P_N_TXTMDA
         and a.aopap  = P_N_TXTPAP
         and a.aocta  = P_N_TXTCTA
         and a.aooper = P_N_TXTOPE
         and a.aosbop = P_N_TXTSBO
         and a.aotope = P_N_TXTTOP;
    exception
    when others then     
      ln_tasa   := 0; 
      ln_monto  := 0; 
      ln_plazo  := 0;      
    end;
  
  if P_N_INDITR = 0 then --si es por mantenimiento obtenemos la tasa de fsd012

    ln_tasa    := P_N_TASA;     
    ld_fecvig  := P_D_FECVAL;  
    lc_valor   := substr(P_C_USUARIO,-5,5);
    lc_usuario := SUBSTR(P_C_USUARIO,1,10); 
    lc_hora    := to_char(sysdate,'HH24:mi:ss');  
    ld_fecpro  := P_D_HFCON; 
       
  Else --si es iteractiva obtener usuario fecha y hora de la fsd015
       begin
        select a.ituing, 
               a.ithora, 
               a.itfcon
          into lc_usuario, 
               lc_hora, 
               ld_fecpro
          from fsd015 a
         where a.pgcod  = P_N_PGCOD
           and a.itsuc  = P_N_HSUCOR
           and a.itmod  = P_N_HCMOD
           and a.ittran = P_N_HTRAN
           and a.itnrel = P_N_HNREL;
      exception
      when others then     
        lc_usuario := ''; 
        lc_hora    := '';  
        ld_fecpro  := '';    
      end;    
      ld_fecvig := P_D_HFCON; 
      lc_valor  := 'APE-1';  
  End if;
  
  
  Case 
    When P_N_TXOREN = 1 then
         lc_tiptas := 'POSICION';
    When P_N_TXOREN = 2 then
         lc_tiptas := 'POLITICA';
    When P_N_TXOREN = 3 then  
         lc_tiptas := 'POSIC/POLIT';
    Else
         lc_tiptas := 'ESPECIAL';
  End Case;
  
  --obtenemos sucursal del usuario
  begin
    select a.ubsuc 
      into ln_ubsuc 
      from fst046 a 
     where a.pgcod  = P_N_PGCOD 
       and a.ubuser = lc_usuario;
  exception
  when others then     
    ln_ubsuc := null;
  end;
  --obtenemos descripccion de la sucursal donde se hizo
  begin
    select a.scnom
      into lc_sucursal
      from fst001 a
     where a.pgcod  = P_N_PGCOD
       and a.sucurs = ln_ubsuc;
  exception
  when others then     
    lc_sucursal := null;
  end;
  --obtenemos datos del cliente
  begin
    select a.pepais,
           a.petdoc,
           a.pendoc 
      into ln_pais2,
           ln_tipo2,
           ln_numdoc2         
      from fsr008 a 
     where a.pgcod  = P_N_PGCOD 
       and a.ctnro  = P_N_TXTCTA
       and a.ttcod  = 1 
       and a.cttfir = 'T';
  exception 
  when others then
       ln_pais2   := 0;
       ln_tipo2   := 0;
       ln_numdoc2 := '';      
  end;
  
  begin
    select a.pgfape
      into ld_pgfape
      from fst017 a 
     where a.pgcod = P_N_PGCOD;
  exception 
  when others then
      ld_pgfape := null;
  end;  
  
  --verificamos si es trabajador
  ln_tgcod := 4;
  ln_grnro := 22001;
  begin
    select 'SI'
      into lc_iswork
      from fsd009 a 
     where a.tgcod = ln_tgcod 
       and a.grnro = ln_grnro
       and a.pgcod = P_N_PGCOD
       and a.ctnro = P_N_TXTCTA;
  exception 
  when others then
      lc_iswork := 'NO';
  end; 

      For i in c_mail loop
        LN_CONT := LN_CONT + 1;
        lv_mail := i.mail;
        ln_ejec := i.tp1nro1;
        
        -- obtenemos nombre y apellido del mail
        begin
          select a.pepais,
                 a.petdoc,
                 a.pendoc
            into ln_pais,
                 ln_tipo,
                 ln_numdoc         
            from fsx001 a 
           where a.txcod = 0 
             and instr(upper(a.pextxt),upper(lv_mail)) > 0 
             and rownum  = 1;
        exception
        when others then
             ln_pais   := 0;
             ln_tipo   := 0;
             ln_numdoc := '';                      
        end;
        if ln_pais <> 0 then
           begin
             select a.pfape1, 
                    a.pfnom1 
               into lc_apepat,
                    lc_prinom
               from fsd002 a 
              where a.pfpais = ln_pais
                and a.pftdoc = ln_tipo
                and a.pfndoc = ln_numdoc;
           exception
           when others then  
              lc_apepat := ''; 
              lc_prinom := 'Usuario';         
           end;
        else
          lc_apepat := ''; 
          lc_prinom := 'Usuario';               
        End if;
        
        if ln_ejec > 0 then
          --OBTENEMOS EL EJECUTIVO DEL PLAZO FIJO
          begin
            -- Call the procedure
            productividad_pasiva.ejecutivo(vpgcod      => P_N_PGCOD,
                                           vpepais     => ln_pais2,
                                           vpetdoc     => ln_tipo2,
                                           vpendoc     => ln_numdoc2,
                                           pd_fecini   => ld_pgfape,
                                           pd_fecfin   => ld_pgfape,
                                           vjaql61user => lc_agente,
                                           vubsuc      => lc_sucage
                                           );
          end;   
           
          if trim(lc_agente) is not null then
          --obtenemos el mail del ejecutivo
            lv_maeje := lower(trim(lc_agente))||'@cajaarequipa.pe';
          else
            lv_maeje := '';         
          End If;
        End If;
        
        --GENERA MAIL 
        dbms_lob.createtemporary(ll_mensaje, TRUE);    
        lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado '||trim(lc_prinom)||' '||trim(lc_apepat) ||' : </p>' ||  
                      '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Se informa sobre el siguiente cambio realizado en el Sistema Bantotal.</p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);                           
                            
              lv_mensaje := --ll_mensaje ||                                                
              '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
              '<table cellspacing=0 cellpadding=2 width=450>'||
              '  <tr>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b>Datos:</b></td>'||
              '    <td width="200" style="border-bottom: 1px solid black;"><b></b></td>'||
              '  </tr>          ';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);       
              

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Cuenta Cliente:'||'</td>'||
        '    <td align="left">'||to_char(P_N_TXTCTA)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Num. Operaci&oacute;n:'||'</td>'||
        '    <td align="left">'||to_char(P_N_TXTOPE)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Tasa Asignada:'||'</td>'||
        '    <td align="left">'||to_char(ln_tasa,'999.90')||'%'||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Tipo de tasa:'||'</td>'||
        '    <td align="left">'||trim(lc_tiptas)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Monto:'||'</td>'||
        '    <td align="left">'||to_char(ln_monto,'999,999,999.90')||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Plazo:'||'</td>'||
        '    <td align="left">'||to_char(ln_plazo)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Operador:'||'</td>'||
        '    <td align="left">'||trim(lc_usuario)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Sucursal:'||'</td>'||
        '    <td align="left">'||trim(lc_sucursal)||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
            
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Fecha-Hora:'||'</td>'||
        '    <td align="left">'||to_char(ld_fecpro,'dd/mm/rrrr')||' '||lc_hora||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Fecha en que procede:'||'</td>'||
        '    <td align="left">'||to_char(ld_fecvig,'dd/mm/rrrr')||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'Trabajador:'||'</td>'||
        '    <td align="left">'||lc_iswork||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
        
        lv_mensaje := 
        '  <tr>'||
        '    <td align="left">'||'C&oacute;digo env&iacute;o:'||'</td>'||
        '    <td align="left">'||lc_valor||'</td>'||
        '  </tr>                ';       
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
         
          
        lv_mensaje := 
        '</table>'||
        '<br/>'||
        '<br/>'||         
        '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';           
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_mail,
                                           p_destinatarioscc   => lv_maeje,
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                           p_asunto            => 'ASIGNACION DE TASA POR POSICION - POLITICA - ESPECIAL',
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => lc_coderr,
                                           p_c_deserr          => lc_deserr
                                           );
        exception
        when others then  
             lc_coderr := '00x';
             lc_deserr := sqlerrm;                                                   
        end;
        
        IF lc_coderr = '000' then
           lv_estado := 'S';
           lv_motivo := 'ENVIO CORRECTO'; 
        ELSE
           lv_estado := 'N';
           lv_motivo := lc_deserr;
        END IF;
        --REGISTRAMOS LOG DE ENVIO DE CORREO
        BEGIN
           INSERT INTO AQPA136(AQPA136PGO,
                               AQPA136ITM,
                               AQPA136ITS,
                               AQPA136ITT,
                               AQPA136ITR,
                               AQPA136FEC,
                               AQPA136COR,
                               AQPA136TXO,
                               AQPA136PGC,
                               AQPA136MOD,
                               AQPA136SUC,
                               AQPA136MDA,
                               AQPA136PAP,
                               AQPA136CTA,
                               AQPA136OPE,
                               AQPA136SUB,
                               AQPA136TPO,
                               AQPA136INR,
                               AQPA136TAT,
                               AQPA136TAP,
                               AQPA136FEA,
                               AQPA136USU,
                               AQPA136DES,
                               AQPA136CUE,
                               AQPA136EST,
                               AQPA136MSG
                               )
                            VALUES
                              (P_N_PGCOD,
                               P_N_HCMOD,
                               P_N_HSUCOR,
                               P_N_HTRAN,
                               P_N_HNREL,
                               P_D_HFCON,
                               LN_CONT,
                               P_N_TXOREN,
                               P_N_PGCOD,
                               P_N_TXTMOD,
                               P_N_TXTSUC,
                               P_N_TXTMDA,
                               P_N_TXTPAP,
                               P_N_TXTCTA,
                               P_N_TXTOPE,
                               P_N_TXTSBO,
                               P_N_TXTTOP,
                               P_N_INDITR,
                               P_N_TAST,
                               P_N_TASA,
                               P_D_FECVAL,
                               P_C_USUARIO,
                               lv_mail,
                               ll_mensaje,
                               LV_ESTADO,
                               LV_MOTIVO
                               );
                               commit;
        EXCEPTION
        WHEN OTHERS THEN
          null;
        END;

        dbms_lob.freetemporary(ll_mensaje);  
      End Loop;
  --End If;
    
end sp_ah_mail_asignacion_tasa_pos;
/

