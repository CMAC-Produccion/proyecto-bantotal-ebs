CREATE OR REPLACE Procedure sp_ah_CorreoERCDev(P_DNI      IN VARCHAR2,
                                               p_nombre   in varchar2,
                                               p_nroERC   in varchar2,
                                               p_fecha    in date,
                                               p_hora     in varchar2,
                                               p_cuenta   in varchar2,
                                               p_agencia  in Varchar2,
                                               p_moneda   in number,
                                               p_monto    in number,
                                               p_motivo   in varchar2,
                                               p_numoper  in varchar2,
                                               p_c_coderr out varchar2,
                                               p_c_deserr out varchar2) is

  CURSOR GUIA10884 IS
    select *
      from fst198 a
     Where Tp1cod   = 1
       and Tp1cod1  = 10884
       and Tp1corr1 = 33
       and Tp1corr2 = 0;
 --  pq_ah_enviodigital.fn_ah_valida_mail(trim(y.jaqz172mai)) = 'S';

    ll_mensaje    CLOB;
    lv_mensaje    VARCHAR2(32767);
    lv_remitente  VARCHAR2(30);
    lv_asunto     VARCHAR2(30);
    lv_asunto1    VARCHAR2(30);
    lv_directorio VARCHAR2(30);
    lv_archivos   VARCHAR2(30);
    fecha         date;
    correo        varchar2(60);
    moneda        char(20);
    MONTO1        CHAR(20);
  begin
    fecha := sysdate;
    p_c_coderr := '000';
    
    MONTO1 :=  TRIM(TO_CHAR(p_monto));
    IF INSTR(MONTO1,',') = 0 And INSTR(MONTO1,'.') = 0 THEN
      MONTO1 := TRIM(MONTO1) ||'.00'  ;      
    END IF; 
    if p_moneda = 0 then
      moneda:= 'SOLES';
    ELSE
      MONEDA  :='DOLARES';
    END IF;
      
    --Obtenemos datos para el envio
    For i in GUIA10884 loop
      Case
         When i.tp1nro1 = 1 then
           lv_remitente  := trim(i.tp1desc);
         When i.tp1nro1 = 2 then
           lv_asunto     := trim(i.tp1desc);
         When i.tp1nro1 = 3 then
           lv_directorio := trim(i.tp1desc);
         When i.tp1nro1 = 4 then
           lv_asunto1    := trim(i.tp1desc);
         Else
           null;
      End Case;
    End Loop;
    --Obtenemos el correo del Usuario
    bEGIN
      select trim(w.wfusremail) --, f2.JAQN002NDO W.WFUSRSH,F2.JAQN002USR,
        into correo
        from WFUSERS w, JAQN002 f2
       where f2.jaqn002pgc = 1
         AND f2.JAQN002PAI = 604
         and f2.JAQN002TDO = 21
         and TRIM(f2.JAQN002NDO) = TRIM(P_DNI)
         AND W.WFUSRCOD = f2.JAQN002USR;
    Exception
      when no_data_found then
        correo:= null;
    end;
    -- cuerpo del Mensaje

        dbms_lob.createtemporary(ll_mensaje, TRUE);
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Estimado(a): </p>' ||
                      '<p "font-family: Arial, sans-serif; font-size: 28px;">'|| trim(p_nombre) || '</p>' ||
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">Se realiz&oacute; la Devoluci&oacute;n de la ERC en el sistema.</p>';

        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

        lv_mensaje := '
                      <table width="830" height="54" border="0">
                        <tbody>
                          <tr>
                          <td "font-family: Arial, sans-serif; font-size: 14px;" width="15" colspan="2" height="23"><p><strong>Devoluci&oacute;n ERC</strong></p></td>
                          </tr>
                           <tr></tr>
                           <tr> 
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Nro de Anticipo : '||p_nroERC||'</td>
                            <tr> </tr>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> (Considere este c&oacute;digo c&oacute;mo n&uacute;mero de documento para el ingreso al EBS)</td>
                            <tr> </tr>
                            <td width="520" height="23"><strong></strong></td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Fecha : '||p_fecha||' Hora : '||p_hora||'.</td>
                            <tr> </tr>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> N&uacute;mero de Operaci&oacute;n : '||p_numoper||'.</td>
                            <tr> </tr>
                            <td width="15" height="23"><strong></strong></td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Cuenta Cargo : '||p_cuenta||'.</td>
                            <tr> </tr>
                            <td width="15" height="23"><strong></strong></td>                            
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Nombre Trabajador : '||p_nombre||'.</td>
                            <tr> </tr>
                            <td width="15" height="23"><strong></strong></td> 
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Moneda : '||moneda||'.</td>
                            <tr> </tr>
                            <td width="15" height="23"><strong></strong></td>                            
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Monto : '||monto1||'.</td>
                            <tr> </tr>
                            <td width="15" height="23"><strong></strong></td>
                            <td width="784" "font-family: Arial, sans-serif; font-size: 14px;"> Motivo : '||p_motivo||'.</td>
                          </tr>
                        </tbody>
                      </table>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

        lv_mensaje :=
        '<p "font-family: Arial, sans-serif; font-size: 14px;"><strong>Saludos Cordiales, <BR> Caja Arequipa</strong></p>';
        dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

        lv_archivos := '';

        begin
        -- Call the procedure
        pq_ah_planillas.p_sendmailattach(p_destinatariospara => correo,
                                         p_destinatarioscc   => '',
                                         p_destinatariosbcc  => '',
                                         p_mensaje           => ll_mensaje,
                                         p_remitente         => lv_remitente,
                                         p_asunto            => lv_asunto,
                                         p_tipomensaje       => 'HTML',
                                         p_directorio        => lv_directorio,
                                         p_archivosadjuntos  => lv_archivos,
                                         p_c_coderr          => p_c_coderr,
                                         p_c_deserr          => p_c_deserr
                                         );
        exception
        when others then
             p_c_coderr := '00x';
             p_c_deserr := sqlerrm;
        end;
        dbms_lob.freetemporary(ll_mensaje);
end sp_ah_CorreoERCDev;
/

