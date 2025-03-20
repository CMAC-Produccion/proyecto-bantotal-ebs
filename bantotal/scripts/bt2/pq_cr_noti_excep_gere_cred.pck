create or replace package pq_cr_noti_excep_gere_cred is

  -- *****************************************************************
  -- NOMBRE                      : pq_cr_noti_excep_gere_cred
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 9/06/2024
  -- AUTOR DE CREACION           : RCASTRO 
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  --------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 28/06/2024
  -- AUTOR DE LA MODIFICACION    : Rcastro - igs
  -- DESCRIPCION DE MODIFICACION : Se agrega procedimiento sp_validar_etpa y ajuste de formato de correo.
  -- FECHA DE MODIFICACION       : 09/07/2024
  -- AUTOR DE LA MODIFICACION    : Rcastro - igs
  -- DESCRIPCION DE MODIFICACION : Se ajuste de optimización de consultas.
  -- FECHA DE MODIFICACION       : 16/07/2024
  -- AUTOR DE LA MODIFICACION    : Rcastro - igs
  -- DESCRIPCION DE MODIFICACION : excepción de politicas condicionales
  -- *****************************************************************

  procedure sp_genr_notif_polit(p_instancia  number,
                                p_X_WFITEMID number,
                                p_usuario    varchar2,
                                p_response   out varchar2);
  procedure sp_obtener_correos(xusuario varchar2, xcorreo OUT varchar2);
  procedure sp_validar_etpa(instancia number, taskcod out number);
  procedure sp_Correos_por_Cargo(fechaActual     date,
                                 xcodGrpHabil    number,
                                 correosDestinat OUT VARCHAR2,
                                 ln_Correo_copia OUT VARCHAR2);

end pq_cr_noti_excep_gere_cred;
/

create or replace package body pq_cr_noti_excep_gere_cred is

  procedure sp_genr_notif_polit(p_instancia  number,
                                p_X_WFITEMID number,
                                p_usuario    varchar2,
                                p_response   out varchar2) is
    PRAGMA AUTONOMOUS_TRANSACTION;
  
    CURSOR list_CargoHabilit is
      select TP1NRO3 AS CodigoCarg
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 179
         AND TP1CORR2 = 3
         AND TP1CORR3 > 0;
  
    CURSOR List_Politicas(auxSolc       number,
                          p_etapa       number,
                          codCargHabili number) is
      SELECT YY.PAE73TIP, YY.PAE73POL, YY.PAE73MNS AS AUXDESCPOLI
        FROM FPAE70 XX, FPAE73 YY
       WHERE XX.PAE51EVA = YY.PAE51EVA
         AND XX.PAE70NRO = YY.PAE70NRO
         AND XX.PAE51EVA = p_etapa --2 
         AND XX.PAE70INS = auxSolc
         AND XX.PAE70NRO = (SELECT MAX(W.PAE70NRO)
                              FROM FPAE70 W
                             WHERE W.PAE70INS = auxSolc
                               AND W.PAE51EVA = p_etapa) --2)
         AND YY.PAE73TIP IN ('E', 'B')
         AND EXISTS
       (SELECT DISTINCT TO_NUMBER(RNG67VAL) POLITICAS,
                              T4.RNG50RET,
                              T6.SNG064NOM
                FROM (FRNG51 T1 LEFT JOIN FRNG68 T2 ON
                      T2.RNG49COD = T1.RNG49COD AND T2.RNG68COD = T1.RNG68COD),
                     FRNG67 T3,
                     FRNG50 T4,
                     SNG066 T5,
                     SNG064 T6
               WHERE T1.RNG49COD = 200
                 AND T1.RNG50GRP IN ( SELECT A.RNG50GRP
                                       FROM FRNG50 A     
                                      WHERE A.RNG49COD = 200 AND
                                      A.RNG50RET = codCargHabili AND   /*A QUI COLOCAR LOS PERFILES A VALIDAR EN ESTE CASO SOLO 2 Y 21 GC Y MC*/
                                      NOT EXISTS (
                                      select TP1NRO3
                                        from fst198
                                       where tp1cod = 1
                                         and tp1cod1 = 11152
                                         and tp1corr1 = 179
                                         AND TP1CORR2 = 4 
                                         AND TP1CORR3 > 0
                                         AND TP1NRO1 = codCargHabili 
                                         AND TP1NRO3 = A.RNG50GRP)
                                     )
                 AND T3.RNG49COD = T1.RNG49COD
                 AND T3.RNG50GRP = T1.RNG50GRP
                 AND T3.RNG51COD = T1.RNG51COD
                 AND T1.RNG68COD = 3 --CODIGO DE POLITICAS PARA LA REGLA 200 (DE LA TABLA FRNG49)
                 AND T4.RNG50GRP = T1.RNG50GRP
                 AND T4.RNG49COD = T1.RNG49COD
                 AND T5.SNG052TEM = 3
                 AND T5.SNG066RET = T4.RNG50RET
                 AND T5.SNG064COD = T6.SNG064COD
                 AND TO_NUMBER(RNG67VAL) = YY.PAE73POL);
  
    fechaActual     DATE;
    correosDestinat VARCHAR2(500);
  
    p_destinatariospara VARCHAR2(250);
    p_destinatarioscc   VARCHAR2(250);
    p_destinatariosbcc  VARCHAR2(250);
    p_mensaje           VARCHAR2(5000);
    p_msgAux            VARCHAR2(5000);
    p_remitente         VARCHAR2(100);
    p_asunto            VARCHAR2(100);
    p_tipomensaje       VARCHAR2(20);
    p_directorio        VARCHAR2(100);
    p_archivosadjuntos  VARCHAR2(100);
    p_c_coderr          varchar2(30);
    p_c_deserr          VARCHAR2(1500);
  
    p_correlativo number(9);
    p_corr_Actual number(9);
    XASESOR       VARCHAR2(10);
    XSUCURS       NUMBER(4);
    DESCZONA      VARCHAR2(50);
    DESREG        VARCHAR2(50);
    DESSUCU       VARCHAR2(50);
    XPAIS         NUMBER(4);
    XTIPDOC       NUMBER(4);
    XNDOC         VARCHAR2(12);
    XNOMCLI       VARCHAR2(30);
  
    ln_pgcod         number(3) := 0;
    ln_scmod         number(4) := 0;
    ln_scsuc         number(4) := 0;
    ln_scmda         number(3) := 0;
    ln_scpap         number(3) := 0;
    ln_sccta         number(9) := 0;
    ln_scoper        number(9) := 0;
    ln_scsbop        number(3) := 0;
    ln_sctope        number(4) := 0;
    v_mnto_Otorg     number(17, 2) := 0;
    p_PERIODO        number(5) := 0;
    XSUSTENTO        VARCHAR2(500);
    xusuario         VARCHAR2(10);
    XTipoPoliti      VARCHAR2(30);
    ln_SustentoComen VARCHAR2(400);
    ln_flgExisPol    VARCHAR2(1);
    ln_Correo_copia  varchar2(100);
    X_taskcod        NUMBER(5);
    X_etapaCod       number(4);
    v_totCuotas      number(5);
    NOM_ANALIST      VARCHAR2(30);
    V_SNGEP1ITE      NUMBER(10);
    V_X_WFITEMID     NUMBER(10);
    codCargHabili    NUMBER(5);
    v_Hora           VARCHAR2(10);
  
  BEGIN
    ln_flgExisPol := 'N';
    BEGIN
      SELECT PGFAPE INTO fechaActual FROM FST017 WHERE PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
    v_hora := TO_CHAR(SYSDATE, 'HH24:MI:SS'); 
    EXCEPTION
      WHEN OTHERS THEN
        NULL;    
    END;
  
    -- validar etapa de solicitud
    X_taskcod := 0;
    BEGIN
      pq_cr_noti_excep_gere_cred.sp_validar_etpa(p_instancia, X_taskcod);
    EXCEPTION
      WHEN OTHERS THEN
        X_taskcod := 0;
    END;
  
    --armar correo
    --if correosDestinat is not null then
    p_remitente        := 'notificaciones@cajaarequipa.pe';
    p_asunto           := 'Alerta de politicas con excepcion';
    p_tipomensaje      := 'HTML';
    p_directorio       := '';
    p_archivosadjuntos := '';
    p_destinatariosbcc := '';
  
    BEGIN
      SELECT SNG001ASE, SNG001AGE, SNG001PAIS, SNG001TDOC, SNG001NDOC
        INTO XASESOR, XSUCURS, XPAIS, XTIPDOC, XNDOC
        FROM SNG001
       WHERE SNG001INST = p_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        XASESOR := '';
        XSUCURS := 0;
        XPAIS   := 0;
        XTIPDOC := 0;
        XNDOC   := '';
    END;
    XASESOR := TRIM(XASESOR);
    XSUCURS := NVL(XSUCURS, 0);
    XNDOC   := TRIM(XNDOC);
  
    BEGIN
      SELECT DESZON, REGNOM, SCNOM
        INTO DESCZONA, DESREG, DESSUCU
        FROM REGSUC
       WHERE SUCURS = XSUCURS;
    EXCEPTION
      WHEN OTHERS THEN
        DESCZONA := '';
        DESREG   := '';
        DESSUCU  := '';
    END;
    DESREG   := TRIM(DESREG);
    DESCZONA := TRIM(DESCZONA);
    DESSUCU  := TRIM(DESSUCU);
  
    BEGIN
      SELECT XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE
        INTO LN_PGCOD,
             LN_SCSUC,
             LN_SCMOD,
             LN_SCMDA,
             LN_SCPAP,
             LN_SCCTA,
             LN_SCOPER,
             LN_SCSBOP,
             LN_SCTOPE
        FROM XWF700
       WHERE XWFPRCINS = P_INSTANCIA
         AND XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        LN_PGCOD  := 0;
        LN_SCSUC  := 0;
        LN_SCMOD  := 0;
        LN_SCMDA  := 0;
        LN_SCPAP  := 0;
        LN_SCCTA  := 0;
        LN_SCOPER := 0;
        LN_SCSBOP := 0;
        LN_SCTOPE := 0;
    END;
  
    v_mnto_Otorg := 0;
    v_totCuotas  := 0;
    BEGIN
      SELECT XLLCAPITAL, XLLPERIODO, XLLCANTCUO
        INTO v_mnto_Otorg, p_PERIODO, v_totCuotas
        FROM x054023
       WHERE XLLPGCOD = ln_pgcod
         AND XLLAOMOD = ln_scmod
         AND XLLAOSUC = ln_scsuc
         AND XLLAOMDA = ln_scmda
         AND XLLAOPAP = ln_scpap
         AND XLLAOCTA = ln_sccta
         AND XLLAOOPER = ln_scoper
         AND XLLAOSBOP = ln_scsbop
         AND XLLAOTOP = ln_sctope;
    EXCEPTION
      WHEN OTHERS THEN
        v_mnto_Otorg := 0;
        p_PERIODO    := 0;
        v_totCuotas  := 0;
    END;
  
    begin
      SELECT UBNOM
        INTO NOM_ANALIST
        FROM fst746
       where ubuser = RPAD(XASESOR, 10, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NOM_ANALIST := '';
    END;
    NOM_ANALIST := TRIM(NOM_ANALIST);
  
   /* p_mensaje := '<html><head>
        <meta http-equiv="Content-Type" content="text/html; charset = utf-8" ||   
        <style type="text/css"></style>' ||
                 '</head><body><p>Estimado.</p>' ||
                 '<p>Tiene asignada las siguientes políticas con excepción para su revisión:' || -- '</br>' ||
                 '<ul><li>  Región: ' || DESREG || '
        </li><li> Zona: ' || DESCZONA || '
        </li><li> Agencia: ' || DESSUCU || '
        </li><li> Nombre de Analista: ' || NOM_ANALIST ||
                 '</li>
        </br>'; */
  
    --validar etapa
    CASE X_taskcod
      WHEN 3 THEN
        X_etapaCod := 1;
      WHEN 7 THEN
        X_etapaCod := 2;
      WHEN 11 THEN
        X_etapaCod := 3;--3 PRUEBA;
      ELSE
        X_etapaCod := 0;
    END CASE;
  
    FOR guiaCargHabili in list_CargoHabilit LOOP
      codCargHabili := guiaCargHabili.Codigocarg;
      ln_flgExisPol := 'N';
      p_msgAux := '';

      p_mensaje := '<html><head>
      <meta http-equiv="Content-Type" content="text/html; charset = utf-8" ||   
      <style type="text/css"></style>' ||
               '</head><body><p>Estimado.</p>' ||
               '<p>Tiene asignada las siguientes políticas con excepción para su revisión:' || -- '</br>' ||
               '<ul><li>  Región: ' || DESREG || '
      </li><li> Zona: ' || DESCZONA || '
      </li><li> Agencia: ' || DESSUCU || '
      </li><li> Nombre de Analista: ' || NOM_ANALIST ||
               '</li>
      </br>';    
    
    
        FOR row_poli in List_Politicas(p_instancia,
                                       X_etapaCod,
                                       codCargHabili) LOOP
          ln_flgExisPol := 'S';
          XTipoPoliti   := '';
          CASE row_poli.PAE73TIP
            WHEN 'A' THEN
              XTipoPoliti := 'Alerta';
            WHEN 'I' THEN
              XTipoPoliti := 'Informativa';
            WHEN 'B' THEN
              XTipoPoliti := 'Bloqueante';
            WHEN 'E' THEN
              XTipoPoliti := 'Excepción';
            ELSE
              XTipoPoliti := '';
          END CASE;
        
          ln_SustentoComen := '';
        
          V_X_WFITEMID := 0;
          IF p_X_WFITEMID = 0 THEN
            BEGIN
              select WFITEMID
                INTO V_X_WFITEMID
                from wfwrkitems
               where wfinsprcid = p_instancia
                 and WFITEMSTSACT = 1;
            exception
              when others then
                V_X_WFITEMID := 0;
            END;
            V_X_WFITEMID := NVL(V_X_WFITEMID, 0);
          ELSE
            V_X_WFITEMID := p_X_WFITEMID;
          END IF;
        
          BEGIN
            select sngep1ite
              INTO V_SNGEP1ITE
              from sngep1
             where SNGEP1ITE = V_X_WFITEMID
               and sngep1ins = p_instancia
               and sngep1tsk = X_taskcod
               AND rownum = 1;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        
          V_SNGEP1ITE := NVL(V_SNGEP1ITE, 0);
        
          BEGIN
            select SNGEP3COM
              INTO ln_SustentoComen
              from sngep3
             where sngep1ite = V_SNGEP1ITE
               AND SNGEP2COR = 1
               AND SNGEP3POL = row_poli.pae73pol;
          EXCEPTION
            WHEN OTHERS THEN
              ln_SustentoComen := '';
          END;
        
          p_msgAux := p_msgAux || '
                <li> Tipo de Política: ' ||
                       XTipoPoliti || '
                </li><li> Nro. De Política: ' ||
                       trim(to_char(row_poli.pae73pol)) || '
                </li><li> Nombre de la Política: ' ||
                       trim(row_poli.auxdescpoli) ||
                       '</li><li> Sustento : ' || trim(ln_SustentoComen);
        END LOOP;
      
        IF ln_flgExisPol = 'S' THEN   
           --OBTENR CORREOS SEGUN GRUPO
          correosDestinat := null;
          ln_Correo_copia := null;
          BEGIN
            pq_cr_noti_excep_gere_cred.sp_Correos_por_Cargo(fechaActual,
                                                            codCargHabili,
                                                            correosDestinat,
                                                            ln_Correo_copia);
          EXCEPTION
            WHEN OTHERS THEN
              correosDestinat := null;
              ln_Correo_copia := null;
          END;            
        
               
          BEGIN
            SELECT PENOM
              INTO XNOMCLI
              FROM FSD001
             WHERE PEPAIS = XPAIS
               AND PETDOC = XTIPDOC
               AND PENDOC = RPAD(XNDOC, 12, ' ');
          EXCEPTION
            WHEN OTHERS THEN
              XNOMCLI := '';
          END;
          XNOMCLI := TRIM(XNOMCLI);
          
          P_mensaje := P_mensaje || trim(p_msgAux);
          P_mensaje := P_mensaje || '</li></br>
              <li> Nombre del cliente: ' || XNOMCLI ||
                       '</li><li> Cuenta Cliente: ' ||
                       TRIM(TO_CHAR(LN_SCCTA)) ||
                       '</li><li> Nro. De solicitud: ' ||
                       TRIM(TO_CHAR(P_INSTANCIA)) ||
                       '</li><li> Monto del Crédito: ' ||
                       TRIM(TO_CHAR(v_mnto_Otorg)) || '</li><li> Plazo: ' ||
                       TRIM(TO_CHAR(v_totCuotas)) || ' cuotas' ||
                       '</li><li> Frecuencia: ' || trim(TO_CHAR(p_PERIODO)) ||
                       '</li>' || '</ul>' ||
                       'Atte.- <br><br>Caja Arequipa.</p></body></html>';
        
          P_mensaje := replace(P_mensaje, 'ñ', 'n');
          P_mensaje := replace(P_mensaje, 'Ñ', 'N');
        
          p_destinatariospara := TRIM(correosDestinat); -- --PRUEBA 
          p_destinatarioscc   := trim(ln_Correo_copia); --'hsuarez@cajaarequipa.pe';--PRUEBA 
        
          --p_mensaje := REPLACE(p_mensaje, 'Ñ', 'N');
          IF correosDestinat IS NOT NULL THEN
              BEGIN
                pq_ah_planillas.p_sendmailattach(p_destinatariospara,
                                                 p_destinatarioscc,
                                                 p_destinatariosbcc,
                                                 p_mensaje,
                                                 p_remitente,
                                                 p_asunto,
                                                 p_tipomensaje,
                                                 p_directorio,
                                                 p_archivosadjuntos,
                                                 p_c_coderr,
                                                 p_c_deserr);
              EXCEPTION
                WHEN OTHERS THEN
                  null;
              END;
              
              IF p_c_coderr = '000' OR p_c_deserr IS NULL  THEN
                xusuario := trim(p_usuario);
                BEGIN
                  SELECT MAX(AQPC841COR)
                    INTO p_corr_Actual
                    FROM AQPC841 A
                   WHERE A.AQPC841FEC = fechaActual
                     AND A.AQPC841INS = p_instancia
                     AND A.AQPC841USU = xusuario;
                EXCEPTION
                  WHEN OTHERS THEN
                    p_corr_Actual := 0;
                END;
              
                p_corr_Actual := NVL(p_corr_Actual, 0);
              
                p_correlativo := p_corr_Actual + 1;
              
                BEGIN
                  INSERT INTO AQPC841
                    (AQPC841FEC,
                     AQPC841INS,
                     AQPC841COR,
                     AQPC841USU,
                     
                     AQPC841ASES,
                     AQPC841REGI,
                     AQPC841ZONA,
                     AQPC841AGEN,
                     AQPC841NOMCLI,
                     AQPC841CTACLI,
                     AQPC841MONTCRE,
                     AQPC841PLAZO,
                     AQPC841SUSTENT,
                     
                     AQPC841PAR,
                     AQPC841CCC,
                     
                     AQPC841MEN,
                     AQPC841HORA)
                  VALUES
                    (fechaActual,
                     p_instancia,
                     p_correlativo,
                     p_usuario,
                     XASESOR,
                     DESREG,
                     DESCZONA,
                     DESSUCU,
                     XNOMCLI,
                     LN_SCCTA,
                     v_mnto_Otorg,
                     p_PERIODO,
                     XSUSTENTO,
                     p_destinatariospara,
                     p_destinatarioscc,
                     p_mensaje,
                     v_hora);
                  COMMIT;
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
                END;
              END IF;
              
              p_mensaje := null;
           END IF;
      END IF;
    END LOOP;
    --end if; 
  
    p_response := ln_flgExisPol;
  end;

  procedure sp_obtener_correos(xusuario varchar2, xcorreo OUT varchar2) is
  begin
    BEGIN
      SELECT WFUSREMAIL
        INTO xcorreo
        FROM WFUSERS
       WHERE WFUSRCOD = RPAD(xusuario, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        xcorreo := ' ';
    END;
  end;

  procedure sp_validar_etpa(instancia number, taskcod out number) is
  
  BEGIN
    taskcod := 0;
    BEGIN
      select WFTASKCOD
        INTO taskcod
        FROM wfwrkitems b
       where b.wfiteminit =
             (select max(bx.wfiteminit)
                from wfwrkitems bx
               WHERE bx.wfinsprcid = b.wfinsprcid)
         and b.wfinsprcid = instancia
         and b.WFITEMSTSACT = 1;
    EXCEPTION
      WHEN OTHERS THEN
        taskcod := 0;
    END;
  
    taskcod := nvl(taskcod, 0);
  END;

  procedure sp_Correos_por_Cargo(fechaActual     date,
                                 xcodGrpHabil    number,
                                 correosDestinat OUT VARCHAR2,
                                 ln_Correo_copia OUT VARCHAR2) is
    CURSOR list_Usu_correo(codGrpHabil number) is
      select TP1DESC AS usuario
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 179
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND TP1NRO3 = codGrpHabil;
         
    CURSOR list_guiaCorreo(codGrpHabil number) is
      select *
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 179 
         AND TP1CORR2 = 2
         AND TP1CORR3 > 0 
         and TP1NRO3 = codGrpHabil;    
  
    correo1       VARCHAR2(200);
    x_Usuario     varchar2(10);
    v_corrCopia   varchar2(40);
    usuarioSuplen VARCHAR2(10);
  BEGIN
    BEGIN
      correosDestinat := null;
      ln_Correo_copia := null;
      FOR xrow IN list_Usu_correo(xcodGrpHabil) LOOP
        correo1   := '';
        x_Usuario := trim(xrow.usuario);
        begin
          pq_cr_noti_excep_gere_cred.sp_obtener_correos(x_Usuario, correo1);
        exception
          when others then
            null;
        end;
        correo1 := trim(correo1);
        if (correo1 is not null and correo1 <> ' ') then
          if (correosDestinat is not null and correosDestinat <> ' ') then
            correosDestinat := correosDestinat || ';' || correo1;
          else
            correosDestinat := correo1;
          End if;
        end if;
      
        v_corrCopia   := '';
        usuarioSuplen := '';
        begin
          SELECT SNG057Sup
            INTO usuarioSuplen
            FROM SNG057
           WHERE SNG055Emp = 1
             AND SNG057Usr = RPAD(xrow.usuario, 10, ' ')
             AND SNG057Ini <= fechaActual
             And SNG057Fin >= fechaActual
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        end;
      
        usuarioSuplen := trim(usuarioSuplen);
      
        begin
          pq_cr_noti_excep_gere_cred.sp_obtener_correos(usuarioSuplen,
                                                        v_corrCopia);
        exception
          when others then
            null;
        end;
      
        v_corrCopia := trim(v_corrCopia);
        if (v_corrCopia is not null and v_corrCopia <> ' ') then
          if (ln_Correo_copia is not null and ln_Correo_copia <> ' ') then
            ln_Correo_copia := ln_Correo_copia || ';' || v_corrCopia; -- correosDestinat || ';' ||  correo1;     
          else
            ln_Correo_copia := v_corrCopia;
          end if;
        end if;
      END LOOP;
      
      IF correosDestinat IS NULL OR correosDestinat = ' ' THEN
         FOR xrow IN list_guiaCorreo(xcodGrpHabil) LOOP
             correosDestinat := correosDestinat || trim(xrow.tp1desc);
         END LOOP;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

end pq_cr_noti_excep_gere_cred;
/

