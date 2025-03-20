CREATE OR REPLACE PACKAGE PQ_CR_CARGA_EXCEL_BUR IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_CARGA_EXCEL_BUR
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/04/2024
   -- AUTOR DE CREACION           : MILTON CORDOVA
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 21/05/2024
   -- AUTOR DE LA MODIFICACION    : RCASTRO
   -- DESCRIPCION DE MODIFICACION : Ajuste de variable p_mensaje
   -- Fecha de Modificación       : 03/06/2024
   -- Autor de la Modificación    : rcastro
   -- Descripción de Modificación : Se agrega actualización campo AQPC227PRO en aqpc227
   -- *****************************************************************
   PROCEDURE SP_CR_VAL_INFO_CARGA(V_FEC_CAR IN DATE
                                           );
END PQ_CR_CARGA_EXCEL_BUR;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CARGA_EXCEL_BUR IS
   
   PROCEDURE SP_CR_VAL_INFO_CARGA(V_FEC_CAR IN DATE
                                           ) IS
      
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_VAR_SEGMENT_CLIENTES
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 22/04/2024
      -- AUTOR DE CREACION           : MILTON CORDOVA
      -- USO                         : GENERA VARIABLES SEGMENTACION
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      -- *****************************************************************
      SNG001PAIS NUMBER(4);
      SNG001TDOC NUMBER(4);
      SNG001NDOC VARCHAR(12);
      CORRELATIVO NUMBER(17);
      p_destinatariospara VARCHAR2(250);
      p_destinatarioscc VARCHAR2(250);
      p_destinatariosbcc VARCHAR2(250);
      p_mensaje VARCHAR2(5000);
      p_remitente VARCHAR2(100);
      p_asunto VARCHAR2(100);
      p_tipomensaje VARCHAR2(20);
      p_directorio VARCHAR2(100);
      p_archivosadjuntos VARCHAR2(100);
      p_c_coderr varchar2(30);
      p_c_deserr VARCHAR2(1500);
      v_gerente varchar2(10);    
      V_TELEFONO1 NUMBER(17);
      V_TELEFONO2 NUMBER(17);
      NomAnalista VARCHAR2(30);  
      VI_CONTADOR NUMBER(5);
      V_FEC_CAR_X DATE;
      V_AsesorAux VARCHAR2(10);
      v_Error number(5);
   CURSOR LISTA_ANALISTAS(V_FEC_CAR_X DATE) IS
    SELECT DISTINCT AQPC227ASE FROM AQPC227 A WHERE A.AQPC227FEC=V_FEC_CAR_X AND A.AQPC227PRO = 'N';
    
   CURSOR LISTAS_PROCESADAS(VI_ASESOR VARCHAR, V_FEC_CAR_X DATE) IS
    SELECT * FROM AQPC227 B WHERE B.AQPC227FEC=V_FEC_CAR_X AND B.AQPC227ASE=VI_ASESOR AND B.AQPC227PRO = 'N';
   
            
   CURSOR CARGA_EXCEL(V_FEC_CAR_X DATE)IS
   SELECT * FROM AQPC839 WHERE AQPC839FECCARG = V_FEC_CAR_X AND AQPC839FPROCES = 'N';
   
   CURSOR VALIDA_INFORMACION(PAIS NUMBER, TIPODOC NUMBER, DOCUMENTO CHAR) IS
  SELECT A.SNG001INST, A.SNG001Ase, B.XWfEmpresa, B.XWfModulo, B.XWfSucursal, B.XWfMoneda, B.XWfPapel, B.XWfCuenta,
        B.XWfOperacion, B.XWfSubope, B.XWfTipOpe
        FROM SNG001 A, XWF700 B, FSD010 C 
        WHERE A.SNG001Inst = B.XWFPRCINS
        AND C.Pgcod  = B.XWfEmpresa
        AND C.Aomod  = B.XWfModulo
        AND C.Aosuc  = B.XWfSucursal
        AND C.Aomda  = B.XWfMoneda
        AND C.Aopap  = B.XWfPapel 
        AND C.Aocta  = B.XWfCuenta
        AND C.Aooper = B.XWfOperacion
        AND C.Aosbop = B.XWfSubope
        AND C.Aotope = B.XWfTipOpe
        AND C.Aostat <> 99
        AND A.SNG001Pais = PAIS
        AND A.SNG001Tdoc = TIPODOC
        AND A.SNG001NDoc = DOCUMENTO
        AND B.XWFCAR3 = '1'
        AND A.SNG001INST = (
            SELECT MAX(A.SNG001INST)
            FROM SNG001 A, XWF700 B, FSD010 C 
        WHERE A.SNG001Inst = B.XWFPRCINS
        AND C.Pgcod  = B.XWfEmpresa
        AND C.Aomod  = B.XWfModulo
        AND C.Aosuc  = B.XWfSucursal
        AND C.Aomda  = B.XWfMoneda
        AND C.Aopap  = B.XWfPapel 
        AND C.Aocta  = B.XWfCuenta
        AND C.Aooper = B.XWfOperacion
        AND C.Aosbop = B.XWfSubope
        AND C.Aotope = B.XWfTipOpe
        AND C.Aostat <> 99
        AND A.SNG001Pais = PAIS
        AND A.SNG001Tdoc = TIPODOC
        AND A.SNG001NDoc = DOCUMENTO
        AND B.XWFCAR3 = '1');
    
    CURSOR CredPropuestoVuelo(PAIS NUMBER, TIPODOC NUMBER, DOCUMENTO CHAR) IS
    SELECT 
        S.SNG001INST, S.SNG001Ase, B.XWfEmpresa, B.XWfModulo, B.XWfSucursal, B.XWfMoneda, B.XWfPapel, B.XWfCuenta,
        B.XWfOperacion, B.XWfSubope, B.XWfTipOpe
   FROM SNG001 S, WFWRKITEMS W, XWF700 B
  WHERE S.SNG001INST = W.WFINSPRCID
  AND B.XWFPRCINS = S.SNG001INST
  AND (S.SNG001PAIS, S.SNG001TDOC, S.SNG001NDOC) IN
  (SELECT D.SNG001PAIS, D.SNG001TDOC, D.SNG001NDOC
  FROM SNG001 D
  WHERE D.SNG001NDOC = DOCUMENTO AND D.SNG001TDOC = TIPODOC AND D.SNG001PAIS = PAIS)
  AND W.WFITEMSTSACT = 1;
     
  
    BEGIN
      
      p_remitente         := 'notificaciones@cajaarequipa.pe';
      p_asunto            := 'Alerta de consulta en otra Entidad Financiera';
      p_tipomensaje       := 'HTML';    
      BEGIN
        
        begin
          IF V_FEC_CAR IS NULL OR (TO_DATE(V_FEC_CAR) = TO_DATE('01/01/01','DD/MM/RR')) THEN
             select PGFAPE INTO V_FEC_CAR_X from fst017 WHERE PGCOD = 1;
           ELSE
             V_FEC_CAR_X := V_FEC_CAR;
           END IF; 
        exception
           WHEN OTHERS THEN
             null;
        end;
        --insert into prueba_log(pgcod,msg)values(100,V_FEC_CAR||'-'||V_FEC_CAR_X);commit;
        
        --
        FOR X IN CARGA_EXCEL(V_FEC_CAR_X) LOOP 
                       
        SNG001PAIS := 604;
        SNG001NDOC := SUBSTR(X.AQPC839NRODOC, 4, 8);             
        if trim(X.AQPC839TIPDOC) = '3' then
        SNG001TDOC := 2; --  Carne Extranjeria 
        else
         if trim(X.AQPC839TIPDOC) = '4' then
          SNG001TDOC := 4; -- Pasaporte
         else
           if trim(X.AQPC839TIPDOC) = '6' then
            SNG001TDOC := 9; -- RUC  
           else
             if trim(X.AQPC839TIPDOC) = '1' then
              SNG001TDOC := 21; --  DNI    
             end if;
           end if;
          end if;
        end if;
            
            FOR Y IN CredPropuestoVuelo(SNG001PAIS,SNG001TDOC,SNG001NDOC) LOOP
            -- ASESOR
            begin
            SELECT WFUSREMAIL
            INTO p_destinatariospara
            FROM WFUSERS WHERE WFUSRCOD = Y.SNG001Ase AND ROWNUM = 1;
            exception
              WHEN NO_DATA_FOUND THEN
              p_destinatariospara := '';
            end;
            p_destinatariospara := TRIM(p_destinatariospara);
            -- GERENTE AGENCIA
            begin
            SELECT T2.UBUSER, T3.WFUSREMAIL 
            INTO v_gerente, p_destinatarioscc
            FROM SNG057 T1 JOIN FST046 T2 ON 
            T1.SNG057USR = T2.UBUSER JOIN WFUSERS T3 ON
            T3.WFUSRCOD = T2.UBUSER
            WHERE T1.SNG055CAR = 202
            AND T2.UBSUC = Y.XWfSucursal AND ROWNUM = 1;
            exception
               WHEN NO_DATA_FOUND THEN
                 v_gerente:= '';
                 p_destinatarioscc := '';
            end;
            p_destinatarioscc :=TRIM(p_destinatarioscc);
            
            BEGIN
            SELECT JAQL708TLF 
            INTO V_TELEFONO1
            FROM JAQL708 WHERE JAQL708USR = Y.SNG001Ase;
            exception
               WHEN NO_DATA_FOUND THEN
               V_TELEFONO1:=0;
            END;
            
            BEGIN
            SELECT JAQL708TLF 
            INTO V_TELEFONO2
            FROM JAQL708 WHERE JAQL708USR = v_gerente;
            exception
               WHEN NO_DATA_FOUND THEN
               V_TELEFONO2:=0;
            END;
            
            BEGIN
            SELECT UBNOM INTO NomAnalista FROM FST746;
            exception
               WHEN OTHERS THEN
               NomAnalista:= '';            
            END;
            NomAnalista := TRIM(NomAnalista);
            
            p_destinatariosbcc  := '';
            p_mensaje           := --'Estimado analista ' || NomAnalista || 
                                   ' se ha detectado que se ha realizado una consulta desde otro banco '||x.aqpc839entcons||' al cliente con DNI ' || trim(SNG001NDOC) || ' de su crédito '
                                   || TRIM(to_char(Y.XWFCUENTA)) || ' - ' || TRIM(to_char(Y.xwfoperacion)) || ' en fecha '||to_char(x.aqpc839period,'DD/MM/RRRR')||'.</br>';
                                   --<br>--Usuario Analista:' || trim(Y.SNG001Ase) || ' Usuario GA: ' || trim(v_gerente);
                                                                      
            --p_remitente         := 'notificaciones@cajaarequipa.pe';
            --p_asunto            := 'Alerta de consulta en otra Entidad Financiera';
            --p_tipomensaje       := 'HTML';
            p_directorio        := '';
            p_archivosadjuntos  := '';
            
            --p_destinatariospara := 'juan.bautista@SESITDIGITAL.COM'; --PRUEBA 
            --p_destinatarioscc   := 'romario.castro@igs.com.pe';--'hsuarez@cajaarequipa.pe';--PRUEBA

           /*BEGIN
            pq_ah_planillas.p_sendmailattach(p_destinatariospara,p_destinatarioscc,p_destinatariosbcc,p_mensaje, 
    p_remitente,p_asunto,p_tipomensaje,p_directorio,p_archivosadjuntos,p_c_coderr,p_c_deserr);
            EXCEPTION
              WHEN OTHERS THEN
                null;
                --DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 150));
            END;*/
            begin
            SELECT NVL(MAX(AQPC227COR), 0) + 1 INTO CORRELATIVO FROM AQPC227 WHERE AQPC227FEC = V_FEC_CAR_X;    
            EXCEPTION
            WHEN OTHERS THEN
            null;
            end;
            INSERT INTO AQPC227 (
            AQPC227FEC, AQPC227USU, AQPC227COR, AQPC227INS,
            AQPC227PAI, AQPC227TIP, AQPC227DOC, AQPC227EMP, AQPC227MOD,
            AQPC227SUC, AQPC227MDA, AQPC227PAP, AQPC227CTA, AQPC227OPE, 
            AQPC227SOP, AQPC227TOP, AQPC227ASE, AQPC227PAR, AQPC227GER, 
            AQPC227CCC, AQPC227MEN, AQPC227COD, AQPC227ERR, AQPC227PRO,
            AQPC227TE1, AQPC227TE2, AQPC227AU1, AQPC227AU2, AQPC227AU3) VALUES(
            V_FEC_CAR_x, 'BANTOTAL', CORRELATIVO, Y.SNG001INST,
            SNG001PAIS, SNG001TDOC, SNG001NDOC, Y.XWfEmpresa, Y.XWfModulo,
            Y.XWfSucursal, Y.XWfMoneda, Y.XWfPapel, Y.XWfCuenta, Y.XWfOperacion, 
            Y.XWfSubope, Y.XWfTipOpe, TRIM(Y.SNG001Ase), p_destinatariospara, v_gerente, 
            p_destinatarioscc, p_mensaje, '', '', 'N', V_TELEFONO1, V_TELEFONO2, '',
            '', '');
            COMMIT;
          END LOOP; 
        
            FOR Y IN VALIDA_INFORMACION(SNG001PAIS,SNG001TDOC,SNG001NDOC) LOOP
            -- ASESOR
            begin
            SELECT WFUSREMAIL
            INTO p_destinatariospara
            FROM WFUSERS WHERE WFUSRCOD = Y.SNG001Ase AND ROWNUM = 1;
            exception
              WHEN NO_DATA_FOUND THEN
              p_destinatariospara := '';
            end;
            p_destinatariospara := TRIM(p_destinatariospara);
            -- GERENTE AGENCIA
            begin
            SELECT T2.UBUSER, T3.WFUSREMAIL 
            INTO v_gerente, p_destinatarioscc
            FROM SNG057 T1 JOIN FST046 T2 ON 
            T1.SNG057USR = T2.UBUSER JOIN WFUSERS T3 ON
            T3.WFUSRCOD = T2.UBUSER
            WHERE T1.SNG055CAR = 202
            AND T2.UBSUC = Y.XWfSucursal AND ROWNUM = 1;
            exception
               WHEN NO_DATA_FOUND THEN
                 v_gerente:= '';
                 p_destinatarioscc := '';
            end;
            p_destinatarioscc :=TRIM(p_destinatarioscc);
            
            BEGIN
            SELECT JAQL708TLF 
            INTO V_TELEFONO1
            FROM JAQL708 WHERE JAQL708USR = Y.SNG001Ase;
            exception
               WHEN NO_DATA_FOUND THEN
               V_TELEFONO1:=0;
            END;
            
            BEGIN
            SELECT JAQL708TLF 
            INTO V_TELEFONO2
            FROM JAQL708 WHERE JAQL708USR = v_gerente;
            exception
               WHEN NO_DATA_FOUND THEN
               V_TELEFONO2:=0;
            END;
            
            BEGIN
            SELECT UBNOM INTO NomAnalista FROM FST746;
            exception
               WHEN OTHERS THEN
               NomAnalista:= '';            
            END;
            NomAnalista := TRIM(NomAnalista);
            
            p_destinatariosbcc  := '';
            p_mensaje           := --'Estimado analista ' || NomAnalista || 
                                   ' se ha detectado que se ha realizado una consulta desde otro banco '||x.aqpc839entcons||' al cliente con DNI ' || trim(SNG001NDOC) || ' de su crédito '
                                   || TRIM(to_char(Y.XWFCUENTA)) || ' - ' || TRIM(to_char(Y.xwfoperacion))  || ' en fecha '||to_char(x.aqpc839period,'DD/MM/RRRR')||'.</br>';
                                   --<br>--Usuario Analista:' || trim(Y.SNG001Ase) || ' Usuario GA: ' || trim(v_gerente);
                                                                      
            --p_remitente         := 'notificaciones@cajaarequipa.pe';
            --p_asunto            := 'Alerta de consulta en otra Entidad Financiera';
            --p_tipomensaje       := 'HTML';
            p_directorio        := '';
            p_archivosadjuntos  := '';
            
            --p_destinatariospara := 'juan.bautista@SESITDIGITAL.COM';--PRUEBA 
            --p_destinatarioscc   := 'romario.castro@igs.com.pe';--'hsuarez@cajaarequipa.pe';--PRUEBA 

           /*BEGIN
            pq_ah_planillas.p_sendmailattach(p_destinatariospara,p_destinatarioscc,p_destinatariosbcc,p_mensaje, 
    p_remitente,p_asunto,p_tipomensaje,p_directorio,p_archivosadjuntos,p_c_coderr,p_c_deserr);
            EXCEPTION
              WHEN OTHERS THEN
                null;
                --DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 150));
            END;*/
            begin
            SELECT NVL(MAX(AQPC227COR), 0) + 1 INTO CORRELATIVO FROM AQPC227 WHERE AQPC227FEC = V_FEC_CAR_X;    
            EXCEPTION
            WHEN OTHERS THEN
            null;
            end;
            INSERT INTO AQPC227 (
            AQPC227FEC, AQPC227USU, AQPC227COR, AQPC227INS,
            AQPC227PAI, AQPC227TIP, AQPC227DOC, AQPC227EMP, AQPC227MOD,
            AQPC227SUC, AQPC227MDA, AQPC227PAP, AQPC227CTA, AQPC227OPE, 
            AQPC227SOP, AQPC227TOP, AQPC227ASE, AQPC227PAR, AQPC227GER, 
            AQPC227CCC, AQPC227MEN, AQPC227COD, AQPC227ERR, AQPC227PRO,
            AQPC227TE1, AQPC227TE2, AQPC227AU1, AQPC227AU2, AQPC227AU3) VALUES(
            V_FEC_CAR_X, 'BANTOTAL', CORRELATIVO, Y.SNG001INST,
            SNG001PAIS, SNG001TDOC, SNG001NDOC, Y.XWfEmpresa, Y.XWfModulo,
            Y.XWfSucursal, Y.XWfMoneda, Y.XWfPapel, Y.XWfCuenta, Y.XWfOperacion, 
            Y.XWfSubope, Y.XWfTipOpe, TRIM(Y.SNG001Ase), p_destinatariospara, v_gerente, 
            p_destinatarioscc, p_mensaje, '', '', 'N', V_TELEFONO1, V_TELEFONO2, '',
            '', '');
            COMMIT;
          END LOOP;      
          
          
          
          -- ACTUALIZA ESTADO A PROCESADO
          begin
          UPDATE AQPC839 SET AQPC839FPROCES = 'P'
          WHERE AQPC839FECCARG = V_FEC_CAR_X AND AQPC839NRODOC = X.AQPC839NRODOC;
          COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
        null;
        end;

        END LOOP;
        
        --RECIEN ENVIAR CORREO POR ANALISTA.
          BEGIN
              FOR J IN LISTA_ANALISTAS(V_FEC_CAR_X) LOOP
                VI_CONTADOR := 0;
                p_mensaje:='';
                V_AsesorAux := TRIM(J.AQPC227ASE);
                
                FOR K IN LISTAS_PROCESADAS(J.AQPC227ASE,V_FEC_CAR_X) LOOP                     
                     IF VI_CONTADOR = 0 THEN
                        p_mensaje:= 'Estimado analista ' || NomAnalista || ',</br>'||K.AQPC227MEN;
                     ELSE   
                        p_mensaje:= p_mensaje||' '||K.AQPC227MEN;
                     END IF;
                     VI_CONTADOR := VI_CONTADOR + 1;                    
                     p_destinatariospara := k.aqpc227par;
                     p_destinatarioscc   := k.aqpc227ccc;
                     p_destinatariosbcc  := '';
                     p_remitente         := p_remitente;
                     p_asunto            := p_asunto;
                     p_tipomensaje       := p_tipomensaje;
                END LOOP;
                --AQUI COLOCAR EL ENVIO DEL CORREO.
               BEGIN
                pq_ah_planillas.p_sendmailattach(p_destinatariospara,p_destinatarioscc,p_destinatariosbcc,p_mensaje, 
                p_remitente,p_asunto,p_tipomensaje,p_directorio,p_archivosadjuntos,p_c_coderr,p_c_deserr);
                EXCEPTION
                  WHEN OTHERS THEN
                    null;
               END;
                              
               IF p_c_coderr = '000'  THEN
                 BEGIN
                    UPDATE AQPC227 C SET C.AQPC227PRO = 'P'
                    WHERE C.AQPC227FEC = V_FEC_CAR_X AND C.AQPC227ASE = V_AsesorAux AND C.AQPC227PRO = 'N';
                    COMMIT;
                EXCEPTION
                  WHEN OTHERS THEN
                    null;                    
                 END;  
               ELSE
                 v_Error :=  to_number(trim(p_c_coderr));
                 BEGIN                    
                    UPDATE AQPC227 C SET C.AQPC227COD = v_Error
                    WHERE C.AQPC227FEC = V_FEC_CAR_X AND C.AQPC227ASE = V_AsesorAux AND C.AQPC227PRO = 'N';
                    COMMIT;
                 EXCEPTION
                  WHEN OTHERS THEN
                    null;                    
                 END;                                   
               END IF;
                --
              END LOOP;
          END;
        
      END;  
    END SP_CR_VAL_INFO_CARGA;
END PQ_CR_CARGA_EXCEL_BUR;
/

