create or replace package pq_cr_envio_notifi_canc_amortiz is

  -- Author  : IGS_RCASTRO
  -- Created : 3/05/2023 15:33:05
  -- Purpose : 

  procedure sp_insert_aqpc809(p_AQPC809ITPGCOD IN NUMBER,
                              p_AQPC809ITSUC   IN NUMBER,
                              p_AQPC809ITMOD   IN NUMBER,
                              p_AQPC809ITTRAN  IN NUMBER,
                              p_AQPC809ITNREL  IN NUMBER,
                              p_AQPC809ITFCON  IN DATE,
                              p_AQPC809HORAT   IN VARCHAR2,
                              p_AQPC809AGENCIT IN VARCHAR2,
                              p_AQPC809OPERADT IN VARCHAR2,
                              p_AQPC809PRODUCT IN VARCHAR2,
                              p_AQPC809EMP     IN NUMBER,
                              p_AQPC809MODU    IN NUMBER,
                              p_AQPC809SUC     IN NUMBER,
                              p_AQPC809MDA     IN NUMBER,
                              p_AQPC809PAP     IN NUMBER,
                              p_AQPC809CTA     IN NUMBER,
                              p_AQPC809OPER    IN NUMBER,
                              p_AQPC809SBOP    IN NUMBER,
                              p_AQPC809TOPE    IN NUMBER,
                              p_AQPC809NOMCLI  IN VARCHAR2,
                              p_AQPC809MONTO   IN NUMBER,
                              p_AQPC809SUCCLI  IN VARCHAR2,
                              p_AQPC809FECSIS  IN DATE,
                              p_AQPC809HORSIS  IN VARCHAR2,
                              p_AQPC809CODCLI  IN VARCHAR2,
                              p_TipoPago       IN VARCHAR2);

  PROCEDURE sp_cr_envio_correo(p_AQPC809EMP  IN NUMBER,
                               p_AQPC809MODU IN NUMBER,
                               p_AQPC809SUC  IN NUMBER,
                               p_AQPC809MDA  IN NUMBER,
                               p_AQPC809PAP  IN NUMBER,
                               cuenta        in number,
                               p_AQPC809OPER IN NUMBER,
                               p_AQPC809SBOP IN NUMBER,
                               p_AQPC809TOPE IN NUMBER,
                               p_Usuario     IN VARCHAR2,
                               cliente       in varchar2,
                               AgenciaCli    in varchar2,
                               Product       in varchar2,
                               hora          in varchar2,
                               MontoTrx      in number,
                               tipoMoneda    in varchar2,
                               TipoPago      in varchar2,
                               fechatrx      in date,
                               AgenciaPag    in varchar2);
end pq_cr_envio_notifi_canc_amortiz;
/

create or replace package body pq_cr_envio_notifi_canc_amortiz is

  procedure sp_insert_aqpc809(p_AQPC809ITPGCOD IN NUMBER,
                              p_AQPC809ITSUC   IN NUMBER,
                              p_AQPC809ITMOD   IN NUMBER,
                              p_AQPC809ITTRAN  IN NUMBER,
                              p_AQPC809ITNREL  IN NUMBER,
                              p_AQPC809ITFCON  IN DATE,
                              p_AQPC809HORAT   IN VARCHAR2,
                              p_AQPC809AGENCIT IN VARCHAR2,
                              p_AQPC809OPERADT IN VARCHAR2,
                              p_AQPC809PRODUCT IN VARCHAR2,
                              p_AQPC809EMP     IN NUMBER,
                              p_AQPC809MODU    IN NUMBER,
                              p_AQPC809SUC     IN NUMBER,
                              p_AQPC809MDA     IN NUMBER,
                              p_AQPC809PAP     IN NUMBER,
                              p_AQPC809CTA     IN NUMBER,
                              p_AQPC809OPER    IN NUMBER,
                              p_AQPC809SBOP    IN NUMBER,
                              p_AQPC809TOPE    IN NUMBER,
                              p_AQPC809NOMCLI  IN VARCHAR2,
                              p_AQPC809MONTO   IN NUMBER,
                              p_AQPC809SUCCLI  IN VARCHAR2,
                              p_AQPC809FECSIS  IN DATE,
                              p_AQPC809HORSIS  IN VARCHAR2,
                              p_AQPC809CODCLI  IN VARCHAR2,
                              p_TipoPago       IN VARCHAR2) IS
    p_AQPC809FECHOR date;
    Descmoned       varchar2(10);
    tipoPag         varchar2(30);
    flgOk           varchar2(1);
    xInstancia      number(10);
    xAnalista       varchar2(10);
    xGerentAgencia   varchar2(10);

    xAQPC809EMP   NUMBER(3);
    xAQPC809MODU  NUMBER(4);
    xAQPC809SUC   NUMBER(4);
    xAQPC809MDA   NUMBER(4);    
    xAQPC809PAP   NUMBER(4);    
    xcuenta       number(9);    
    xAQPC809OPER  NUMBER(9);    
    xAQPC809SBOP  NUMBER(4);    
    xAQPC809TOPE  NUMBER(4); 
    xMensajeSMS   VARCHAR2(400);
    xFechaTrx     VARCHAR2(10);
    lc_hora       varchar(10);
  BEGIN      
    IF p_AQPC809MDA = 0 THEN
      Descmoned := 'soles';
    END IF;
  
    IF p_AQPC809MDA = 101 THEN
      Descmoned := 'dólares';
    END IF;
  
    IF p_TipoPago = 'C' THEN
      tipoPag := 'cancelación';
    ELSE      
      tipoPag := 'amortización';
    END IF;
    
    --Buscar correo Analista créditos y Gerente de Agencia
      xAQPC809EMP  := p_AQPC809EMP;        
      xAQPC809SUC  := p_AQPC809SUC;
      xAQPC809MODU := p_AQPC809MODU;  
      xAQPC809MDA  := p_AQPC809MDA; 
      xAQPC809PAP  := p_AQPC809PAP;     
      xcuenta      := p_AQPC809CTA;                                                
      xAQPC809OPER := p_AQPC809OPER;     
      xAQPC809SBOP := p_AQPC809SBOP;                                
      xAQPC809TOPE := p_AQPC809TOPE;          
    
    IF p_AQPC809MODU = 116 OR p_AQPC809MODU = 117 THEN
    BEGIN
       SELECT 
       A.R2COD,
       A.R2MOD,
       A.R2CTA,
       A.R2OPER,
       A.R2MDA,
       A.R2PAP,
       A.R2SUC,
       A.R2SBOP,
       A.R2TOPE    
       INTO    
        xAQPC809EMP,        
        xAQPC809MODU, 
        xcuenta,  
        xAQPC809OPER,
        xAQPC809MDA,     
        xAQPC809PAP,                                           
        xAQPC809SUC,        
        xAQPC809SBOP,                                 
        xAQPC809TOPE       
       FROM FSR011 A WHERE
       A.R1COD = p_AQPC809EMP  AND
       A.R1MOD = p_AQPC809MODU AND
       A.R1SUC = p_AQPC809SUC  AND 
       A.R1MDA = p_AQPC809MDA  AND
       A.R1PAP = p_AQPC809PAP  AND
       A.R1CTA = p_AQPC809CTA   AND
       A.R1OPER = p_AQPC809OPER AND
       A.R1SBOP = p_AQPC809SBOP AND
       A.R1TOPE = p_AQPC809TOPE AND
       A.relcod = 46 AND ROWNUM < 2;   
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;                                           
    END IF;     
                
    
    BEGIN
        SELECT E.XWFPRCINS 
          INTO xInstancia
          FROM XWF700 E
         WHERE E.XWFEMPRESA    = xAQPC809EMP 
           AND E.XWFSUCURSAL   = xAQPC809SUC 
           AND E.XWFMODULO     = xAQPC809MODU  
           AND E.XWFMONEDA     = xAQPC809MDA 
           AND E.XWFPAPEL      = xAQPC809PAP 
           AND E.XWFCUENTA     = xcuenta     
           AND E.XWFOPERACION  = xAQPC809OPER
           AND E.XWFSUBOPE     = xAQPC809SBOP
           AND E.XWFTIPOPE     = xAQPC809TOPE
           AND E.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        xInstancia := 0;
    END;         
    
    BEGIN
       SELECT D.SNG001ASE INTO xAnalista FROM SNG001 D WHERE D.SNG001INST = xInstancia and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN 
        xAnalista := '';      
    END;
    
    --gerente de agencia
    BEGIN
      select SNG057USR into xGerentAgencia from sng057 s,fst046 f where s.sng055car=202 and s.sng057aut='S' and f.ubuser=s.sng057usr and f.ubsuc = p_AQPC809SUC and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN       
        xGerentAgencia := '';
    END;       
    
    ---Se arma el msg del SMS
    lc_hora         := to_char(SYSDATE, 'HH24:MI:SS');      
    xFechaTrx := to_char(p_AQPC809FECSIS, 'dd/mm/rrrr');
    xMensajeSMS := 'El Cliente ' || p_AQPC809NOMCLI ||', con cuenta cliente ' || p_AQPC809CTA ||' de la agencia ' || p_AQPC809SUCCLI||'; ha realizado la ' || tipoPag  || ' de su crédito '|| p_AQPC809PRODUCT ||' por '|| p_AQPC809MONTO || ' ' || Descmoned || ' a las '|| lc_hora ||' el '|| xFechaTrx || ' en la Ag. ' || p_AQPC809AGENCIT || '.';
    xMensajeSMS := replace(xMensajeSMS, '&', 'Y');  
    
    flgOk := 'N';  
    BEGIN
      SELECT fn_jaql977_fechor(to_char(p_AQPC809ITFCON, 'rrrrmmdd'),
                               replace(lc_hora, ':', ''))
        INTO p_AQPC809FECHOR
        FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;    
    
    BEGIN
      INSERT INTO AQPC809
        (AQPC809ITPGCOD,
         AQPC809ITSUC,
         AQPC809ITMOD,
         AQPC809ITTRAN,
         AQPC809ITNREL,
         AQPC809ITFCON,
         AQPC809HORAT,
         AQPC809AGENCIT,
         AQPC809OPERADT,
         AQPC809PRODUCT,
         AQPC809EMP,
         AQPC809MODU,
         AQPC809SUC,
         AQPC809MDA,
         AQPC809PAP,
         AQPC809CTA,
         AQPC809OPER,
         AQPC809SBOP,
         AQPC809TOPE,
         AQPC809NOMCLI,
         AQPC809MONTO,
         AQPC809SUCCLI,
         AQPC809TIPPGO,
         AQPC809DESMDA,
         AQPC809FECSIS,
         AQPC809HORSIS,
         AQPC809FECHOR,
         AQPC809CODCLI,
         AQPC809ANALI,
         AQPC809GAGEN,
         AQPC809C1)
      VALUES
        (p_AQPC809ITPGCOD,
         p_AQPC809ITSUC,
         p_AQPC809ITMOD,
         p_AQPC809ITTRAN,
         p_AQPC809ITNREL,
         p_AQPC809ITFCON,
         p_AQPC809HORAT,
         p_AQPC809AGENCIT,
         p_AQPC809OPERADT,
         p_AQPC809PRODUCT,
         p_AQPC809EMP,
         p_AQPC809MODU,
         p_AQPC809SUC,
         p_AQPC809MDA,
         p_AQPC809PAP,
         p_AQPC809CTA,
         p_AQPC809OPER,
         p_AQPC809SBOP,
         p_AQPC809TOPE,
         p_AQPC809NOMCLI,
         p_AQPC809MONTO,
         p_AQPC809SUCCLI,
         tipoPag,
         Descmoned,
         p_AQPC809ITFCON,
         to_char(SYSDATE, 'HH24:MI:SS'),
         p_AQPC809FECHOR,
         p_AQPC809CODCLI,
         TRIM(xAnalista),
         TRIM(xGerentAgencia),
         xMensajeSMS); 
      COMMIT;
      flgOk := 'S';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Hay un error al insertar en AQPC809');
    END;
  
  END;

  PROCEDURE sp_cr_envio_correo(p_AQPC809EMP  IN NUMBER,
                               p_AQPC809MODU IN NUMBER,
                               p_AQPC809SUC  IN NUMBER,
                               p_AQPC809MDA  IN NUMBER,
                               p_AQPC809PAP  IN NUMBER,
                               cuenta        in number,
                               p_AQPC809OPER IN NUMBER,
                               p_AQPC809SBOP IN NUMBER,
                               p_AQPC809TOPE IN NUMBER,
                               p_Usuario     IN VARCHAR2,
                               cliente       in varchar2,
                               AgenciaCli    in varchar2,
                               Product       in varchar2,
                               hora          in varchar2,
                               MontoTrx      in number,
                               tipoMoneda    in varchar2,
                               TipoPago      in varchar2,
                               fechatrx      in date,
                               AgenciaPag    in varchar2) is
  
   /*CURSOR CORREOS is
      SELECT *
        FROM FST198
       WHERE TP1COD1 = 11152
         AND TP1CORR1 = 19
         AND TP1CORR2 > 0; */-- AND TP1NRO1 = 2;
    flag_data char(1);
    ln_pago   number(17, 6);
    flg_hdata char(1);
  
    subject varchar2(1000);
  
    v_header  varchar2(10000); -- Cabecera
    v_wstring clob;
    data      varchar2(32000);
    rawdata   long raw;
  
    fechaApertura date;
    remitente     varchar(100);
    receptor      varchar(80);
    textSubtotal  varchar(30);
  
    lv_destinos varchar2(300);
  
    lv_emisor  varchar2(200) := '';
    lv_destino varchar2(100) := '';
    lv_descopi varchar2(300) := '';
    lv_asunto  varchar2(70) := '';
    ll_mensaje long := '';
    p_c_coderr varchar2(5);
    p_c_msgerr varchar2(200);
  
    nrodoc varchar2(12);
    --cliente varchar2(100);
    Nomcliente  VARCHAR(400);
    v_descrubro varchar2(50);
    auxFecha    varchar2(10);
    
    xInstancia number(10);
    xAnalista varchar2(10);
    xCorreoAnalista varchar2(50);
    xGerentAgencia varchar2(10);
    xCorreoGerentAge varchar2(50);
    

    xAQPC809EMP   NUMBER(3);
    xAQPC809MODU  NUMBER(4);
    xAQPC809SUC   NUMBER(4);
    xAQPC809MDA   NUMBER(4);    
    xAQPC809PAP   NUMBER(4);    
    xcuenta       number(9);    
    xAQPC809OPER  NUMBER(9);    
    xAQPC809SBOP  NUMBER(4);    
    xAQPC809TOPE  NUMBER(4);    
  
  BEGIN
    BEGIN
      SELECT Pgfape into fechaApertura from FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN others THEN
        fechaApertura := sysdate;
    END;
  
    lv_emisor := 'notificaciones@cajaarequipa.pe';
  
    --Buscar correo Analista créditos y Gerente de Agencia
    --
      xAQPC809EMP  := p_AQPC809EMP;        
      xAQPC809SUC  := p_AQPC809SUC;
      xAQPC809MODU := p_AQPC809MODU;  
      xAQPC809MDA  := p_AQPC809MDA; 
      xAQPC809PAP  := p_AQPC809PAP;     
      xcuenta      := cuenta;                                                
      xAQPC809OPER := p_AQPC809OPER;     
      xAQPC809SBOP := p_AQPC809SBOP;                                
      xAQPC809TOPE := p_AQPC809TOPE;          
    
    IF p_AQPC809MODU = 116 OR p_AQPC809MODU = 117 THEN
    BEGIN
       SELECT 
       A.R2COD,
       A.R2MOD,
       A.R2CTA,
       A.R2OPER,
       A.R2MDA,
       A.R2PAP,
       A.R2SUC,
       A.R2SBOP,
       A.R2TOPE    
       INTO    
        xAQPC809EMP,        
        xAQPC809MODU, 
        xcuenta,  
        xAQPC809OPER,
        xAQPC809MDA,     
        xAQPC809PAP,                                           
        xAQPC809SUC,        
        xAQPC809SBOP,                                 
        xAQPC809TOPE       
       FROM FSR011 A WHERE
       A.R1COD = p_AQPC809EMP  AND
       A.R1MOD = p_AQPC809MODU AND
       A.R1SUC = p_AQPC809SUC  AND 
       A.R1MDA = p_AQPC809MDA  AND
       A.R1PAP = p_AQPC809PAP  AND
       A.R1CTA = cuenta        AND
       A.R1OPER = p_AQPC809OPER AND
       A.R1SBOP = p_AQPC809SBOP AND
       A.R1TOPE = p_AQPC809TOPE AND
       A.relcod = 46 AND ROWNUM < 2;   
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;                                           
    END IF;     
                
    
    BEGIN
        SELECT E.XWFPRCINS 
          INTO xInstancia
          FROM XWF700 E
         WHERE E.XWFEMPRESA    = xAQPC809EMP 
           AND E.XWFSUCURSAL   = xAQPC809SUC 
           AND E.XWFMODULO     = xAQPC809MODU  
           AND E.XWFMONEDA     = xAQPC809MDA 
           AND E.XWFPAPEL      = xAQPC809PAP 
           AND E.XWFCUENTA     = xcuenta     
           AND E.XWFOPERACION  = xAQPC809OPER
           AND E.XWFSUBOPE     = xAQPC809SBOP
           AND E.XWFTIPOPE     = xAQPC809TOPE
           AND E.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        xInstancia := 0;
    END;
      
    
    BEGIN
       SELECT D.SNG001ASE INTO xAnalista FROM SNG001 D WHERE D.SNG001INST = xInstancia;
    EXCEPTION
      WHEN OTHERS THEN 
        xAnalista := '';   
    END;
    
    --correo
    BEGIN
      select WFUSREMAIL INTO xCorreoAnalista from wFusers WHERE trim(WFUSRCOD) = trim(xAnalista);
    EXCEPTION
      WHEN OTHERS THEN       
        xCorreoAnalista := '';
    END;
    --gerente de agencia
    BEGIN
      select SNG057USR into xGerentAgencia from sng057 s,fst046 f where s.sng055car=202 and s.sng057aut='S' and f.ubuser=s.sng057usr and f.ubsuc = p_AQPC809SUC and rownum < 2 ;
    EXCEPTION
      WHEN OTHERS THEN       
        xGerentAgencia := '';
    END;   
    
    BEGIN
      select WFUSREMAIL INTO xCorreoGerentAge from wFusers WHERE trim(WFUSRCOD) = trim(xGerentAgencia);
    EXCEPTION
      WHEN OTHERS THEN       
        xCorreoGerentAge := '';
    END;                           
    
    receptor   := trim(xCorreoAnalista); 
    lv_descopi := trim(xCorreoGerentAge);
  
          textSubtotal := replace(to_char(MontoTrx), ',', '.');
        
          Nomcliente := upper(replace(cliente, 'Ñ', 'N'));
          Nomcliente := upper(replace(cliente, '&', 'Y'));
          auxFecha   := to_char(fechatrx, 'dd/MM/YYYY');
        
          --lv_emisor := 'notificaciones@cajaarequipa.pe';
          lv_asunto  := 'ALERTA: INFORMACIÓN DE PAGO';
          ll_mensaje := '<html><head><style type="text/css"></style>' ||
                        '</head><body>' ||
                        '<br/>
                          <p>' || 'El cliente ' ||
                        trim(Nomcliente) || ', con cuenta cliente ' ||
                        trim(to_char(cuenta)) || ', de la agencia ' ||
                        trim(AgenciaCli) || '.</p>' || '<p> Ha realizado la ' ||
                        trim(TipoPago) || ' de su crédito ' || trim(Product) ||
                        ' por ' || trim(to_char(MontoTrx)) || ' ' ||
                        trim(tipoMoneda) || ' a las ' || trim(hora) || ' el ' ||
                        trim(auxFecha) || ' en la Ag. ' || trim(AgenciaPag) || '.' ||
                        '</p>' ||
                        '<br><p>Atte.- <br><br>Caja Arequipa.</p></body></html>';
        
          begin
            pq_ah_planillas.p_sendmailattach(p_destinatariospara => receptor,
                                             p_destinatarioscc   => lv_descopi,
                                             p_destinatariosbcc  => '',
                                             p_mensaje           => ll_mensaje,
                                             p_remitente         => lv_emisor,
                                             p_asunto            => lv_asunto,
                                             p_tipomensaje       => 'HTML',
                                             p_directorio        => '',
                                             p_archivosadjuntos  => '',
                                             p_c_coderr          => p_c_coderr,
                                             p_c_deserr          => p_c_msgerr);
            --Grabar log de datos enviados en tabla  
            insert into AQPC810
              (AQPC810COD,
               AQPC810MOD,
               AQPC810SUC,
               AQPC810MDA,
               AQPC810PAP,
               AQPC810CTA,
               AQPC810OPER,
               AQPC810SBOP,
               AQPC810TOPE,
               AQPC810EMIS,
               AQPC810DEST,
               AQPC810COPI,
               AQPC810MESG,
               AQPC810ASUN,
               AQPC810ERRO,
               AQPC810ERMG,
               AQPC810USUR,
               AQPC810FECR,
               AQPC810HORA)
            values
              (p_AQPC809EMP,
               p_AQPC809MODU,
               p_AQPC809SUC,
               p_AQPC809MDA,
               p_AQPC809PAP,
               cuenta,
               p_AQPC809OPER,
               p_AQPC809SBOP,
               p_AQPC809TOPE,
               lv_emisor,
               receptor,
               lv_descopi,
               ll_mensaje,
               lv_asunto,
               p_c_coderr,
               p_c_msgerr,
               p_Usuario,
               TRUNC(SYSDATE),
               to_char(sysdate, 'HH24:MI:SS'));
               --COMMIT;
          EXCEPTION
            when others then
              p_c_coderr := '92';
              p_c_msgerr := sqlerrm;
            
              begin
                insert into AQPC810
                  (AQPC810COD,
                   AQPC810MOD,
                   AQPC810SUC,
                   AQPC810MDA,
                   AQPC810PAP,
                   AQPC810CTA,
                   AQPC810OPER,
                   AQPC810SBOP,
                   AQPC810TOPE,
                   AQPC810EMIS,
                   AQPC810DEST,
                   AQPC810COPI,
                   AQPC810MESG,
                   AQPC810ASUN,
                   AQPC810ERRO,
                   AQPC810ERMG,
                   AQPC810USUR,
                   AQPC810FECR,
                   AQPC810HORA)
                values
                  (p_AQPC809EMP,
                   p_AQPC809MODU,
                   p_AQPC809SUC,
                   p_AQPC809MDA,
                   p_AQPC809PAP,
                   cuenta,
                   p_AQPC809OPER,
                   p_AQPC809SBOP,
                   p_AQPC809TOPE,
                   lv_emisor,
                   receptor,
                   lv_descopi,
                   ll_mensaje,
                   lv_asunto,
                   p_c_coderr,
                   p_c_msgerr,
                   p_Usuario,
                   TRUNC(SYSDATE),
                   to_char(sysdate, 'HH24:MI:SS'));
                   --COMMIT;
              exception
                when others then
                  DBMS_OUTPUT.put_line('Error ' || sqlerrm);
              end;
          END;
  
  END sp_cr_envio_correo;

end pq_cr_envio_notifi_canc_amortiz;
/

