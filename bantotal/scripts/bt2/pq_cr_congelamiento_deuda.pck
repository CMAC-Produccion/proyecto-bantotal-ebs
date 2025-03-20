create or replace package pq_cr_congelamiento_deuda is

  -- Author  : HSUAREZ
  -- Created : 7/01/2021 16:28:16
  -- Purpose : Se implementa un paquete para incluir dentro de congelamiento de deuda los registros de las tablas de registradas por BI y Web por Analista o Cliente.
  procedure sp_registrar_web(ve_fecha in date);
  procedure sp_cr_validar_registro(
                                  ve_emp  in number,
                                  ve_mod  in number,
                                  ve_suc  in number,
                                  ve_mda  in number,
                                  ve_pap  in number,
                                  ve_cta  in number,
                                  ve_ope  in number,
                                  ve_sbop in number, 
                                  ve_tope in number,
                                  ve_feci in date,
                                  ve_fecf in date,
                                  ve_est  out varchar2,
                                  ve_flag out varchar2,
                                  ve_ind  out varchar2,
                                  vl_fecfin out date
                                );
  procedure sp_registrar_logs(
                            ve_emp  in number,
                            ve_mod  in number,
                            ve_suc  in number,
                            ve_mda  in number,
                            ve_pap  in number,
                            ve_cta  in number,
                            ve_ope  in number,
                            ve_sbop in number, 
                            ve_tope in number,
                            ve_feci in date,
                            ve_fecf in date,
                            ve_est  in varchar2,
                            ve_ind  in varchar2,
                            ve_prg  in varchar2,
                            ve_sta  in number,
                            ve_err  in varchar2,
                            ve_fecr in timestamp
                           );
  procedure sp_registrar_bi(ve_fecha date);
  procedure sp_cr_registrar_x_rango(ve_fecini date,ve_fecfin date);
end pq_cr_congelamiento_deuda;
/

create or replace package body pq_cr_congelamiento_deuda is

procedure sp_registrar_web(ve_fecha in date) is
  --Cursores
  cursor lista_creditos_18070 is
   SELECT TRUNC(L.fecenproceso) FECHAENCURSO,
          L.DNICLIENTE,
          L.SOLICITUD,
          SUBSTR(L.CUENTAOPERACION,0,INSTR(L.CUENTAOPERACION,'-')-1) CUENTA,--ln_cta
          SUBSTR(L.CUENTAOPERACION,INSTR(L.CUENTAOPERACION,'-')+1,99) OPERACION--ln_ope
          FROM REPROG L
          WHERE L.ESTADOSOLICITUD = 'CU'     
          AND TRUNC(L.FECENPROCESO)=ve_fecha;

  --CURSOS PARA CREDITOS A EVALUAR
  cursor lista_creditos_ley31050 is
  SELECT TO_DATE(TO_CHAR(L.FECHAPENDIENTE,'DD/MM/YYYY')) FECHAENCURSO,
          F.EMPRESA,
          F.MODULO,
          F.SUCURSAL,
          F.MONEDA,
          F.PAPEL,
          SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1) CUENTA,--ln_cta
          SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) OPERACION,--ln_ope
          F.suboperacion,
          F.TIPOOPERACION
          --L.FECHAENCURSO
          --,F.*,l.*
        FROM LEY31050 L
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE L.ESTADOSOLICITUD = 'CU'  
        AND TRUNC(L.FECHAPENDIENTE)=ve_fecha;    
          --AND SUBSTR(L.FECHAPENDIENTE,1,8)=TO_DATE(to_char(ve_fecha,'DD/MM/YYYY'),'DD/MM/YYYY'); 
  
   --VARIABLES LOCALES
   vi_dias number(3);
   err_msg varchar2(150);
   vl_fecini DATE;
   vl_fecfin DATE;
   vl_flag char(1);
   vl_ind char(1);
   vl_stat char(3);
   --local variable clave crd.
   lv_pgcod fsd010.pgcod%type;
   lv_aomod fsd010.aomod%type;
   lv_aosuc fsd010.aosuc%type;
   lv_aomda fsd010.aomda%type;
   lv_aopap fsd010.aopap%type;
   lv_aocta fsd010.aocta%type;
   lv_aooper fsd010.aooper%type;
   lv_aosbop fsd010.aosbop%type;
   lv_aotope fsd010.aotope%type;
begin
     --DIAS PARA A FECHA FIN
     BEGIN
       SELECT t.tp1imp1
       INTO vi_dias
       FROM FST198 t
       WHERE t.tp1cod1= 11127
         and t.tp1corr1= 8
         and t.tp1corr2= 1
         and t.tp1corr3= 1;
       END;
     
     --RECORRE CREDITOS LEY18070
          BEGIN
          for m in lista_creditos_18070 loop
            BEGIN              
              --OBTENER CLAVE DEL CREDITO DE LA CUENTA Y OPERACION PROPORCIONADA
              BEGIN                
                SELECT  d.pgcod,d.aomod,d.aosuc,d.aomda,d.aopap,
                        d.aocta,d.aooper,d.aosbop,d.aotope
                INTO    lv_pgcod,lv_aomod,lv_aosuc,lv_aomda,lv_aopap,
                        lv_aocta,lv_aooper,lv_aosbop,lv_aotope
                FROM FSD010 d
                where d.pgcod = 1
                  and d.aocta = m.CUENTA
                  and d.aooper = m.OPERACION
                  and d.aostat <> 99 --CREDITO VIGENTE
                  and d.aomod <> 419; --MODULO DIFERNTE A DIFERIDOS
                exception
                  when others then
                    null;
              end;
              --VALIDAR SI EXISTE REGISTRO
              vl_flag:= 'N';
              vl_stat := 'INS';
              BEGIN
                 pq_cr_congelamiento_deuda.sp_cr_validar_registro(lv_pgcod,lv_aomod,lv_aosuc,lv_aomda,
                                                                      lv_aopap,lv_aocta,lv_aooper,lv_aosbop,
                                                                      lv_aotope,m.fechaencurso,(m.fechaencurso+vi_dias),
                                                                      vl_stat,vl_flag,vl_ind,vl_fecfin);
              EXCEPTION 
                WHEN OTHERS THEN
                  vl_flag := 'S';
                  vl_stat := 'INS';
                  vl_ind  := 0; 
              END;
              IF vl_flag = 'N' then      
                INSERT INTO AQPB252(
                     AQPB252EMP,
                     AQPB252MOD,
                     AQPB252SUC,
                     AQPB252MDA,
                     AQPB252PAP,
                     AQPB252CTA,
                     AQPB252OPER,
                     AQPB252SBOP,
                     AQPB252TOP,
                     AQPB252FINI,
                     AQPB252FFIN,
                     AQPB252EST,
                     AQPB252IND) VALUES (
                     
                     lv_pgcod,
                     lv_aomod,
                     lv_aosuc,
                     lv_aomda,
                     lv_aopap,
                     lv_aocta,--ln_cta
                     lv_aooper,--ln_ope
                     lv_aosbop,--L.SUBOPERACION,
                     lv_aotope,--L.TIPOOPERACION,
                     to_char(m.fechaencurso,'DD/MM/YYYY'),
                     to_char((m.FECHAENCURSO+vi_dias),'DD/MM/YYYY'),--FECHA FIN
                     'S',
                     '1'
                     );
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
              ELSE
                IF vl_stat = 'UPD' THEN
                   UPDATE AQPB252 SET AQPB252FFIN = to_char((m.fechaencurso+vi_dias),'DD/MM/YYYY'), AQPB252IND = '1' --SE ACTUALIZA IND A 3 QUE SIGNIFICA 
                   WHERE AQPB252EMP = lv_pgcod
                   AND AQPB252MOD = lv_aomod
                   AND AQPB252SUC = lv_aosuc
                   AND AQPB252MDA = lv_aomda
                   AND AQPB252PAP = lv_aopap
                   AND AQPB252CTA = lv_aocta
                   AND AQPB252OPER= lv_aooper
                   AND AQPB252SBOP= lv_aosbop
                   AND AQPB252TOP = lv_aotope;
                    --SI TODO ES OK     
                    err_msg := 'UPD LEY31050 '||vl_fecfin ||' A '|| (m.fechaencurso+vi_dias) ||' '||vl_ind||' a 1';
                    sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
                ELSE
                err_msg := 'NO SE REALIZAN CAMBIOS DE '||vl_fecfin ||' A '|| (m.fechaencurso+vi_dias);
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
                END IF;
                
             END IF; 
             COMMIT; ----                          
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);   
                COMMIT; ----                  
            END;
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;       

     --RECORRE CREDITOS LEY31050
     BEGIN
          for l in lista_creditos_ley31050 loop
          vl_flag:= 'N';          
          --VALIDAR SI EXISTE REGISTRO
          BEGIN
               pq_cr_congelamiento_deuda.sp_cr_validar_registro(l.empresa,l.modulo,l.sucursal,l.moneda,
                                                                    l.papel,l.cuenta,l.operacion,l.suboperacion,
                                                                    l.tipooperacion,l.fechaencurso,(l.fechaencurso+vi_dias),
                                                                    vl_stat,vl_flag,vl_ind,vl_fecfin);
          EXCEPTION 
              WHEN OTHERS THEN
                vl_flag := 'S';
                vl_stat := 'INS';
                vl_ind  := 0; 
          END;               
          BEGIN
            IF vl_flag = 'N' then
                INSERT INTO AQPB252(AQPB252EMP,AQPB252MOD,AQPB252SUC,
                     AQPB252MDA,AQPB252PAP,AQPB252CTA,
                     AQPB252OPER,AQPB252SBOP,AQPB252TOP,
                     AQPB252FINI,AQPB252FFIN,AQPB252EST,
                     AQPB252IND) VALUES (
                     L.EMPRESA,L.MODULO,L.SUCURSAL,
                     L.MONEDA,L.PAPEL,L.CUENTA,L.OPERACION,L.SUBOPERACION,
                     L.TIPOOPERACION,TO_CHAR(L.FECHAENCURSO,'DD/MM/YYYY'),TO_CHAR((l.fechaencurso+vi_dias),'DD/MM/YYYY'),--FECHA FIN
                     'S','2');
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate); 
                                               COMMIT; ----                          
            ELSE
              IF vl_stat = 'UPD' THEN
               UPDATE AQPB252 SET AQPB252FFIN = to_char((l.fechaencurso+vi_dias),'DD/MM/YYYY'), AQPB252IND = '2' --SE ACTUALIZA IND A 2 QUE SIGNIFICA 
               WHERE AQPB252EMP = L.EMPRESA
               AND AQPB252MOD = L.MODULO
               AND AQPB252SUC = L.SUCURSAL
               AND AQPB252MDA = L.MONEDA
               AND AQPB252PAP = L.PAPEL
               AND AQPB252CTA = L.CUENTA
               AND AQPB252OPER= L.OPERACION
               AND AQPB252SBOP= L.SUBOPERACION
               AND AQPB252TOP = L.TIPOOPERACION;
                --SI TODO ES OK     
                err_msg := 'UPD LEY31050 '||vl_fecfin ||' A '|| (l.fechaencurso+vi_dias) ||' '||vl_ind||' a 2';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate); 
                                               COMMIT; ----                           
             END IF;                                   
            END IF; 
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate);    
                                               COMMIT; ----                          
          END;
          
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;       

end sp_registrar_web;

procedure sp_cr_validar_registro(
                                  ve_emp  in number,
                                  ve_mod  in number,
                                  ve_suc  in number,
                                  ve_mda  in number,
                                  ve_pap  in number,
                                  ve_cta  in number,
                                  ve_ope  in number,
                                  ve_sbop in number, 
                                  ve_tope in number,
                                  ve_feci in date,
                                  ve_fecf in date,
                                  ve_est  out varchar2,
                                  ve_flag out varchar2,
                                  ve_ind  out varchar2,
                                  vl_fecfin out date
                                )is
   vl_fecini DATE;
   --vl_fecfin DATE;
begin
     --VALIDAR SI EXISTE REGISTRO
     BEGIN
        SELECT 'S',A.AQPB252FINI, A.AQPB252FFIN, A.AQPB252IND
          INTO ve_flag,vl_fecini,vl_fecfin,ve_ind
        FROM AQPB252 A
        WHERE A.AQPB252EMP = ve_emp
          AND A.AQPB252MOD = ve_mod
          AND A.AQPB252SUC = ve_suc
          AND A.AQPB252MDA = ve_mda
          AND A.AQPB252PAP = ve_pap
          AND A.AQPB252CTA = ve_cta
          AND A.AQPB252OPER= ve_ope
          AND A.AQPB252SBOP= ve_sbop
          AND A.AQPB252TOP = ve_tope
          AND A.AQPB252EST = 'S';
        --validar si la fecha de vencimiento es menor que la fecha de registro se actualiza el registro 
        ve_flag := 'N';
        ve_est := 'INS';
        if vl_fecfin < ve_fecf then
           ve_est := 'UPD';               
        end if;
      --validar si la fecha de vencimiento es mayor se mantiene la fecha inicial (no se realizan cambios)
      if vl_fecfin > ve_fecf then
         ve_est := 'NAN';               
      end if;  
     EXCEPTION 
        WHEN OTHERS THEN
          ve_flag := 'N';
          ve_est := 'INS'; 
     END; 
end;  
procedure sp_registrar_logs(
                            ve_emp  in number,
                            ve_mod  in number,
                            ve_suc  in number,
                            ve_mda  in number,
                            ve_pap  in number,
                            ve_cta  in number,
                            ve_ope  in number,
                            ve_sbop in number, 
                            ve_tope in number,
                            ve_feci in date,
                            ve_fecf in date,
                            ve_est  in varchar2,
                            ve_ind  in varchar2,
                            ve_prg  in varchar2,
                            ve_sta  in number,
                            ve_err  in varchar2,
                            ve_fecr in timestamp
                           ) is
begin
     begin
       INSERT INTO AQPB554 (aqpb554emp, aqpb554mod, aqpb554suc, aqpb554mda, aqpb554pap, aqpb554cta, aqpb554oper, 
                            aqpb554sbop, aqpb554top, aqpb554fini, aqpb554ffin, aqpb554est, aqpb554ind, aqpb554prg, 
                            aqpb554stt, aqpb554err, aqpb554fecr) VALUES
                            (ve_emp, ve_mod, ve_suc, ve_mda, ve_pap, ve_cta, ve_ope,
                             ve_sbop, ve_tope, ve_feci, ve_fecf, ve_est, ve_ind, ve_prg,
                             ve_sta, ve_err, ve_fecr);
       
     exception
        when others then
          null;
     end;     
  end sp_registrar_logs;

procedure sp_registrar_bi(ve_fecha date) is  
  
cursor lista_creditos_BI is 
   SELECT TO_DATE(TO_CHAR(F.AQPB555FINI,'DD/MM/YYYY')) FECHAENCURSO,
          TO_DATE(TO_CHAR(F.AQPB555FFIN,'DD/MM/YYYY')) FECHAFIN,
          F.AQPB555EMP EMPRESA,
          F.AQPB555MOD MODULO,
          F.AQPB555SUC SUCURSAL,
          F.AQPB555MDA MONEDA,
          F.AQPB555PAP PAPEL,
          F.AQPB555CTA CUENTA,--ln_cta
          F.AQPB555OPER OPERACION,--ln_ope
          F.AQPB555SBOP SUBOPERACION,
          F.AQPB555TOP TIPOOPERACION
        FROM AQPB555 F
        --WHERE TO_CHAR(F.AQPB555FINI,'DD/MM/YYYY')>=TO_DATE(ve_fecha,'DD/MM/YYYY');
--        WHERE SUBSTR(F.AQPB555FINI,1,8)=TO_DATE(ve_fecha,'DD/MM/YYYY');
         WHERE F.AQPB555FINI = ve_fecha;
--variables locales
vl_fecini date;
vl_fecfin date;   
vl_flag char(1);
vl_ind char(1);
vl_stat varchar2(3);      
err_msg varchar2(150); 
begin
     --RECORRE CREDITOS DE BI
     BEGIN
          for l in lista_creditos_BI loop
            --VALIDAR SI EXISTE REGISTRO
            vl_flag:= 'N';
          BEGIN
               pq_cr_congelamiento_deuda.sp_cr_validar_registro(l.empresa,l.modulo,l.sucursal,l.moneda,
                                                                    l.papel,l.cuenta,l.operacion,l.suboperacion,
                                                                    l.tipooperacion,l.fechaencurso,l.fechafin,
                                                                    vl_stat,vl_flag,vl_ind,vl_fecfin);
          EXCEPTION 
              WHEN OTHERS THEN
                vl_flag := 'S';
                vl_stat := 'INS';
                vl_ind  := 0; 
          END;
          BEGIN
            IF vl_stat ='INS' THEN
                INSERT INTO AQPB252(
                     AQPB252EMP,AQPB252MOD,AQPB252SUC,
                     AQPB252MDA,AQPB252PAP,AQPB252CTA,
                     AQPB252OPER,AQPB252SBOP,AQPB252TOP,
                     AQPB252FINI,AQPB252FFIN,AQPB252EST, AQPB252IND) VALUES (
                     L.EMPRESA,L.MODULO,L.SUCURSAL,L.MONEDA,L.PAPEL,
                     L.CUENTA,L.OPERACION,L.SUBOPERACION,L.TIPOOPERACION,
                     L.FECHAENCURSO,l.FECHAFIN,'S','3'); --IND -> 3 BI 
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);  
            
            END IF;
            IF vl_stat = 'UPD' THEN
               UPDATE AQPB252 SET AQPB252FFIN = L.FECHAFIN, AQPB252IND = '3' --SE ACTUALIZA IND A 3 QUE SIGNIFICA 
               WHERE AQPB252EMP = L.EMPRESA
               AND AQPB252MOD = L.MODULO
               AND AQPB252SUC = L.SUCURSAL
               AND AQPB252MDA = L.MONEDA
               AND AQPB252PAP = L.PAPEL
               AND AQPB252CTA = L.CUENTA
               AND AQPB252OPER= L.OPERACION
               AND AQPB252SBOP= L.SUBOPERACION
               AND AQPB252TOP = L.TIPOOPERACION;
                --SI TODO ES OK     
                err_msg := 'UPD BI '||vl_fecfin ||' A '|| L.FECHAFIN ||' '||vl_ind||' a 3';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);
            END IF;                     
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);    
            END;
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;
  end;

procedure sp_cr_registrar_x_rango(ve_fecini date,ve_fecfin date)is
  --CURSOR PARA REPROGRAMADOS
  cursor lista_creditos_18070 is
   SELECT TRUNC(L.fecenproceso) FECHAENCURSO,
          L.DNICLIENTE,
          L.SOLICITUD,
          SUBSTR(L.CUENTAOPERACION,0,INSTR(L.CUENTAOPERACION,'-')-1) CUENTA,--ln_cta
          SUBSTR(L.CUENTAOPERACION,INSTR(L.CUENTAOPERACION,'-')+1,99) OPERACION--ln_ope
          FROM REPROG L
          WHERE L.ESTADOSOLICITUD IN (SELECT trim(TP1DESC) FROM FST198 WHERE TP1COD=1 AND TP1COD1=11127 AND TP1CORR1=8 AND TP1CORR2=2 AND TP1CORR3>0)
          AND (SUBSTR(L.FECENPROCESO,1,8)>=TO_DATE(to_char(ve_fecini,'DD/MM/YYYY'),'DD/MM/YYYY') AND SUBSTR(L.FECENPROCESO,1,8)<=TO_DATE(TO_CHAR(ve_fecfin,'DD/MM/YYYY'),'DD/MM/YYYY'));         
  --CURSOR PARA LEY 31050
  cursor lista_creditos_ley31050 is 
   SELECT TO_DATE(TO_CHAR(L.FECHAPENDIENTE,'DD/MM/YYYY')) FECHAENCURSO,
          F.EMPRESA,
          F.MODULO,
          F.SUCURSAL,
          F.MONEDA,
          F.PAPEL,
          SUBSTR(F.CUENTAOPERACION,0,INSTR(F.CUENTAOPERACION,'-')-1) CUENTA,--ln_cta
          SUBSTR(F.CUENTAOPERACION,INSTR(F.CUENTAOPERACION,'-')+1,99) OPERACION,--ln_ope
          F.suboperacion,
          F.TIPOOPERACION
          --L.FECHAENCURSO
          --,F.*,l.*
        FROM LEY31050 L
        INNER JOIN LEY31050_CREDITOSFACILIDAD F ON L.IDLEY31050 = F.IDLEY31050
        WHERE L.ESTADOSOLICITUD IN (SELECT trim(TP1DESC) FROM FST198 WHERE TP1COD=1 AND TP1COD1=11127 AND TP1CORR1=8 AND TP1CORR2=2 AND TP1CORR3>0)
           AND (SUBSTR(L.FECHAPENDIENTE,1,8)>=TO_DATE(to_char(ve_fecini,'DD/MM/YYYY'),'DD/MM/YYYY') AND SUBSTR(L.FECHAPENDIENTE,1,8)<=TO_DATE(TO_CHAR(ve_fecfin,'DD/MM/YYYY'),'DD/MM/YYYY'));

   --CURSOR PARA BI
   cursor lista_creditos_BI is 
   SELECT TO_DATE(TO_CHAR(F.AQPB555FINI,'DD/MM/YYYY')) FECHAENCURSO,
          TO_DATE(TO_CHAR(F.AQPB555FFIN,'DD/MM/YYYY')) FECHAFIN,
          F.AQPB555EMP EMPRESA,
          F.AQPB555MOD MODULO,
          F.AQPB555SUC SUCURSAL,
          F.AQPB555MDA MONEDA,
          F.AQPB555PAP PAPEL,
          F.AQPB555CTA CUENTA,--ln_cta
          F.AQPB555OPER OPERACION,--ln_ope
          F.AQPB555SBOP SUBOPERACION,
          F.AQPB555TOP TIPOOPERACION
        FROM AQPB555 F
        WHERE 
        --( TO_CHAR(F.AQPB555FINI,'DD/MM/YYYY')>=TO_DATE(ve_fecini,'DD/MM/YYYY')
        --      AND TO_CHAR(F.AQPB555FINI,'DD/MM/YYYY')<=TO_DATE(ve_fecfin,'DD/MM/YYYY'));
--          (SUBSTR(F.AQPB555FINI,1,8)>=TO_DATE(ve_fecini,'DD/MM/YYYY') AND SUBSTR(F.AQPB555FINI,1,8)<=TO_DATE(ve_fecfin,'DD/MM/YYYY'));
         F.AQPB555FINI >= ve_fecini  AND F.AQPB555FINI <= ve_fecfin;
   --VARIABLES LOCALES
   vi_dias number(3);
   err_msg varchar2(150);
   vl_fecini DATE;
   vl_fecfin DATE;
   vl_flag char(1);
   vl_ind char(1);
   vl_stat char(3);
   --local variable clave crd.
   lv_pgcod fsd010.pgcod%type;
   lv_aomod fsd010.aomod%type;
   lv_aosuc fsd010.aosuc%type;
   lv_aomda fsd010.aomda%type;
   lv_aopap fsd010.aopap%type;
   lv_aocta fsd010.aocta%type;
   lv_aooper fsd010.aooper%type;
   lv_aosbop fsd010.aosbop%type;
   lv_aotope fsd010.aotope%type;
begin
   --DIAS PARA A FECHA FIN
     BEGIN
       SELECT t.tp1imp1
       INTO vi_dias
       FROM FST198 t
       WHERE t.tp1cod1= 11127
         and t.tp1corr1= 8
         and t.tp1corr2= 1
         and t.tp1corr3= 1;
       END;     
     --RECORRE CREDITOS LEY18070
          BEGIN
          for m in lista_creditos_18070 loop
            BEGIN              
              --OBTENER CLAVE DEL CREDITO DE LA CUENTA Y OPERACION PROPORCIONADA
              BEGIN                
                SELECT  d.pgcod,d.aomod,d.aosuc,d.aomda,d.aopap,
                        d.aocta,d.aooper,d.aosbop,d.aotope
                INTO    lv_pgcod,lv_aomod,lv_aosuc,lv_aomda,lv_aopap,
                        lv_aocta,lv_aooper,lv_aosbop,lv_aotope
                FROM FSD010 d
                where d.pgcod = 1
                  and d.aocta = m.CUENTA
                  and d.aooper = m.OPERACION
                  and d.aostat <> 99 --CREDITO VIGENTE
                  and d.aomod <> 419; --MODULO DIFERNTE A DIFERIDOS
                exception
                  when others then
                    null;
              end;
              --VALIDAR SI EXISTE REGISTRO
              BEGIN
                 pq_cr_congelamiento_deuda.sp_cr_validar_registro(lv_pgcod,lv_aomod,lv_aosuc,lv_aomda,
                                                                      lv_aopap,lv_aocta,lv_aooper,lv_aosbop,
                                                                      lv_aotope,m.fechaencurso,(m.fechaencurso+vi_dias),
                                                                      vl_stat,vl_flag,vl_ind,vl_fecfin);
              EXCEPTION 
                WHEN OTHERS THEN
                  vl_flag := 'S';
                  vl_stat := 'INS';
                  vl_ind  := 0; 
              END;
              IF vl_flag = 'N' then      
                INSERT INTO AQPB252(
                     AQPB252EMP,
                     AQPB252MOD,
                     AQPB252SUC,
                     AQPB252MDA,
                     AQPB252PAP,
                     AQPB252CTA,
                     AQPB252OPER,
                     AQPB252SBOP,
                     AQPB252TOP,
                     AQPB252FINI,
                     AQPB252FFIN,
                     AQPB252EST,
                     AQPB252IND) VALUES (
                     
                     lv_pgcod,
                     lv_aomod,
                     lv_aosuc,
                     lv_aomda,
                     lv_aopap,
                     lv_aocta,--ln_cta
                     lv_aooper,--ln_ope
                     lv_aosbop,--L.SUBOPERACION,
                     lv_aotope,--L.TIPOOPERACION,
                     m.FECHAENCURSO,
                     (m.FECHAENCURSO+vi_dias),--FECHA FIN
                     'S',
                     '1'
                     );
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
              ELSE
                IF vl_stat = 'UPD' THEN
                   UPDATE AQPB252 SET AQPB252FFIN = (m.fechaencurso+vi_dias), AQPB252IND = '1' --SE ACTUALIZA IND A 3 QUE SIGNIFICA 
                   WHERE AQPB252EMP = lv_pgcod
                   AND AQPB252MOD = lv_aomod
                   AND AQPB252SUC = lv_aosuc
                   AND AQPB252MDA = lv_aomda
                   AND AQPB252PAP = lv_aopap
                   AND AQPB252CTA = lv_aocta
                   AND AQPB252OPER= lv_aooper
                   AND AQPB252SBOP= lv_aosbop
                   AND AQPB252TOP = lv_aotope;
                    --SI TODO ES OK     
                    err_msg := 'UPD LEY31050 '||vl_fecfin ||' A '|| (m.fechaencurso+vi_dias) ||' '||vl_ind||' a 1';
                    sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
                ELSE
                err_msg := 'NO SE REALIZAN CAMBIOS DE '||vl_fecfin ||' A '|| (m.fechaencurso+vi_dias);
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);
                END IF;
             END IF;                           
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(lv_pgcod,lv_aomod,lv_aosuc,lv_aosuc,lv_aopap,
                                  lv_aocta,lv_aooper,lv_aosbop,lv_aotope,m.fechaencurso,
                                  (m.fechaencurso+vi_dias),'S','1','LEY18070',1,err_msg,sysdate);   
            END; 
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;
     --RECORRE CREDITOS LEY31050
     BEGIN
          for l in lista_creditos_ley31050 loop
          --VALIDAR SI EXISTE REGISTRO
          vl_flag:= 'N';
          BEGIN
               pq_cr_congelamiento_deuda.sp_cr_validar_registro(l.empresa,l.modulo,l.sucursal,l.moneda,
                                                                    l.papel,l.cuenta,l.operacion,l.suboperacion,
                                                                    l.tipooperacion,l.fechaencurso,(l.fechaencurso+vi_dias),
                                                                    vl_stat,vl_flag,vl_ind,vl_fecfin);
          EXCEPTION 
              WHEN OTHERS THEN
                vl_flag := 'S';
                vl_stat := 'INS';
                vl_ind  := 0; 
          END;               
          BEGIN
            IF vl_flag = 'N' then
                INSERT INTO AQPB252(AQPB252EMP,AQPB252MOD,AQPB252SUC,
                     AQPB252MDA,AQPB252PAP,AQPB252CTA,
                     AQPB252OPER,AQPB252SBOP,AQPB252TOP,
                     AQPB252FINI,AQPB252FFIN,AQPB252EST,
                     AQPB252IND) VALUES (
                     L.EMPRESA,L.MODULO,L.SUCURSAL,
                     L.MONEDA,L.PAPEL,L.CUENTA,L.OPERACION,L.SUBOPERACION,
                     L.TIPOOPERACION,L.FECHAENCURSO,(l.fechaencurso+vi_dias),--FECHA FIN
                     'S','2');
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate); 
                                  COMMIT; --                                  
            ELSE
              IF vl_stat = 'UPD' THEN
               UPDATE AQPB252 SET AQPB252FFIN = (l.fechaencurso+vi_dias), AQPB252IND = '2' --SE ACTUALIZA IND A 2 QUE SIGNIFICA 
               WHERE AQPB252EMP = L.EMPRESA
               AND AQPB252MOD = L.MODULO
               AND AQPB252SUC = L.SUCURSAL
               AND AQPB252MDA = L.MONEDA
               AND AQPB252PAP = L.PAPEL
               AND AQPB252CTA = L.CUENTA
               AND AQPB252OPER= L.OPERACION
               AND AQPB252SBOP= L.SUBOPERACION
               AND AQPB252TOP = L.TIPOOPERACION;
                --SI TODO ES OK     
                err_msg := 'UPD LEY31050 '||vl_fecfin ||' A '|| (l.fechaencurso+vi_dias) ||' '||vl_ind||' a 2';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate); 
                                  COMMIT; --
              END IF;                                   
            END IF; 
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  (l.fechaencurso+vi_dias),'S','2','LEY31050',1,err_msg,sysdate);    
                                  COMMIT; --

          END;
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;     
     
     --RECORRE CREDITOS DE BI
     BEGIN
          for l in lista_creditos_BI loop
            --VALIDAR SI EXISTE REGISTRO
            vl_flag:= 'N';
          BEGIN
               pq_cr_congelamiento_deuda.sp_cr_validar_registro(l.empresa,l.modulo,l.sucursal,l.moneda,
                                                                    l.papel,l.cuenta,l.operacion,l.suboperacion,
                                                                    l.tipooperacion,l.fechaencurso,l.fechafin,
                                                                    vl_stat,vl_flag,vl_ind,vl_fecfin);
          EXCEPTION 
              WHEN OTHERS THEN
                vl_flag := 'S';
                vl_stat := 'INS';
                vl_ind  := 0; 
          END;
          BEGIN
            IF vl_stat ='INS' THEN
                INSERT INTO AQPB252(
                     AQPB252EMP,AQPB252MOD,AQPB252SUC,
                     AQPB252MDA,AQPB252PAP,AQPB252CTA,
                     AQPB252OPER,AQPB252SBOP,AQPB252TOP,
                     AQPB252FINI,AQPB252FFIN,AQPB252EST, AQPB252IND) VALUES (
                     L.EMPRESA,L.MODULO,L.SUCURSAL,L.MONEDA,L.PAPEL,
                     L.CUENTA,L.OPERACION,L.SUBOPERACION,L.TIPOOPERACION,
                     L.FECHAENCURSO,l.FECHAFIN,'S','3'); --IND -> 3 BI 
                --SI TODO ES OK     
                err_msg := 'OK';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);  
            
                                                  COMMIT; --
            END IF;
            IF vl_stat = 'UPD' THEN
               UPDATE AQPB252 SET AQPB252FFIN = L.FECHAFIN, AQPB252IND = '3' --SE ACTUALIZA IND A 3 QUE SIGNIFICA 
               WHERE AQPB252EMP = L.EMPRESA
               AND AQPB252MOD = L.MODULO
               AND AQPB252SUC = L.SUCURSAL
               AND AQPB252MDA = L.MONEDA
               AND AQPB252PAP = L.PAPEL
               AND AQPB252CTA = L.CUENTA
               AND AQPB252OPER= L.OPERACION
               AND AQPB252SBOP= L.SUBOPERACION
               AND AQPB252TOP = L.TIPOOPERACION;
                --SI TODO ES OK     
                err_msg := 'UPD BI '||vl_fecfin ||' A '|| L.FECHAFIN ||' '||vl_ind||' a 3';
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);
                                  
                                                  COMMIT; --
            END IF;                     
            EXCEPTION 
              WHEN OTHERS THEN
                err_msg := substr(SQLERRM,1,150);
                sp_registrar_logs(l.empresa,l.modulo,l.sucursal,l.moneda,l.papel,
                                  l.cuenta,l.operacion,l.suboperacion,l.tipooperacion,l.fechaencurso,
                                  l.fechafin,'S','3','BI',1,err_msg,sysdate);    
                COMMIT; --
            END;
        END LOOP;    
     EXCEPTION
            WHEN OTHERS THEN
              NULL;
     END;
end;

end pq_cr_congelamiento_deuda;
/

