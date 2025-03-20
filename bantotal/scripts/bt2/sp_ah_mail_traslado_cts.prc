create or replace procedure sp_ah_mail_traslado_cts(P_D_FECPRO IN DATE,
                                                    P_N_NUMCTA IN NUMBER,
                                                    P_C_CUECON IN VARCHAR2,
                                                    P_N_MONTO  IN NUMBER,
                                                    P_C_CODUSU IN VARCHAR2,
                                                    P_N_CODACC IN NUMBER
                                                    ) is
  lv_mensaje    VARCHAR2(32767);
  ll_mensaje    CLOB;  
  lv_mail       varchar2(30); 
  ld_fecpro     date;    
  lc_hora       char(8);
  lc_sucursal   fst001.scnom%type;     
  ln_ubsuc      fst046.ubsuc%type;  
  lc_ctnom      varchar2(35);     
  lv_texto      varchar2(35);          
  ln_mda        number(4);
  lc_mosig      char(4);
  cursor c_mail is
   select trim(tp1desc) mail
      into lv_mail
      from fst198
     where tp1cod   = 1
       and tp1cod1  = 10825
       and tp1corr1 = 38
       and tp1corr2 = 2;  
begin
    ln_mda     := to_number(substr(P_C_CUECON, 13,3));   
    begin
      select a.ctnom
        into lc_ctnom
        from FSD008 a
       where a.pgcod = 1
         and a.ctnro = P_N_NUMCTA;         
    exception
    when others then     
      lc_ctnom := null;     
    end;
   
  --obtenemos sucursal del usuario
  begin
    select a.ubsuc 
      into ln_ubsuc 
      from fst046 a 
     where a.pgcod  = 1 
       and a.ubuser = RPAD(P_C_CODUSU,10,' ');
  exception
  when others then     
    ln_ubsuc := null;
  end;
  --obtenemos descripccion de la sucursal donde se hizo
  begin
    select a.scnom
      into lc_sucursal
      from fst001 a
     where a.pgcod  = 1
       and a.sucurs = ln_ubsuc;
  exception
  when others then     
    lc_sucursal := null;
  end;
  --obtenemos la moneda de la cuenta
  begin
    select a.mosign
      into lc_mosig
      from fst005 a
     where a.moneda = ln_mda;
  exception
  when others then     
    lc_mosig := null;
  end;  
  
  lc_hora := to_char(sysdate,'HH24:mi:ss');
  ld_fecpro :=  P_D_FECPRO;   
  
  For i in c_mail loop
    lv_mail := i.mail;
    --GENERA MAIL 
    dbms_lob.createtemporary(ll_mensaje, TRUE);    
    lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Estimado Usuario'||' : </p>' ||  
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
          
    If P_N_CODACC = 1 then
      lv_texto := 'CANCELACION DE CTS';
    else
      lv_texto := 'EXTORNO DE CANCELACION DE CTS';
    End If;  
    lv_mensaje := 
    '  <tr>'||
    '    <td align="left">'||'Operación:'||'</td>'||
    '    <td align="left">'||lv_texto||'</td>'||
    '  </tr>                ';       
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      

    lv_mensaje := 
    '  <tr>'||
    '    <td align="left">'||'Cuenta Cliente:'||'</td>'||
    '    <td align="left">'||P_N_NUMCTA||' - '||lc_ctnom||'</td>'||
    '  </tr>                ';       
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
    
    lv_mensaje := 
    '  <tr>'||
    '    <td align="left">'||'Producto CTS:'||'</td>'||
    '    <td align="left">'||P_C_CUECON||'</td>'||
    '  </tr>                ';       
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
  
    lv_mensaje := 
    '  <tr>'||
    '    <td align="left">'||'Monto:'||'</td>'||
    '    <td align="left">'||trim(lc_mosig)||' '||to_char(P_N_MONTO,'999,999,999.90')||'</td>'||
    '  </tr>                ';       
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
    
    
    lv_mensaje := 
    '  <tr>'||
    '    <td align="left">'||'Operador:'||'</td>'||
    '    <td align="left">'||trim(P_C_CODUSU)||'</td>'||
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
    '</table>'||
    '<br/>'||
    '<br/>'||         
    '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">Saludos Cordiales<br/>Caja Arequipa</p>';           
    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);      
     
      begin
            sys.sp_sy_enviamail_html(pc_aquien =>lv_mail,--- sys.sp_sy_enviamail_html
                                     pc_de => 'notificacionesbantotal@cajaarequipa.pe',
                                     pc_motivo => 'AVISO TRASLADO DE CTS',
                                     pc_mensaje => ll_mensaje
                                     );   
      Exception
      when others then                             
        null;
      end;       

    dbms_lob.freetemporary(ll_mensaje);  
  End Loop;
  
end sp_ah_mail_traslado_cts;
/

