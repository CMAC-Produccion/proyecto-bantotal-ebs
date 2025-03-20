create or replace package PQ_CR_COBUS is

  -- Author  : IGS_MCORDOVA
  -- Created : 5/10/2022 23:58:34
  -- Purpose : 
  PROCEDURE SP_CR_JOB_MENSUAL_COBUS(D_FECHA IN DATE, V_USUARIO IN CHAR);
  PROCEDURE SP_CR_JOB_DIARIO_COBUS(FECHA IN DATE, USUARIO IN CHAR);--(D_FECHA IN DATE, V_USUARIO IN VARCHAR2);
end PQ_CR_COBUS;
/

create or replace package body PQ_CR_COBUS is

PROCEDURE SP_CR_JOB_MENSUAL_COBUS(D_FECHA IN DATE, V_USUARIO IN CHAR)
IS
D_FECHA_PROCESO VARCHAR2(20);
N_CONTADOR      NUMBER(2) := 1;
N_JOB           NUMBER := 0;
N_CONTADOR2     NUMBER(2):=1;
V_CADENA        VARCHAR2(4000);
LN_NUMJOB       NUMBER(9) := 0;
    
BEGIN 
  N_CONTADOR := TO_NUMBER(TO_CHAR(LAST_DAY(D_FECHA), 'DD'));
  
  WHILE N_CONTADOR2 <= N_CONTADOR loop
    D_FECHA_PROCESO := TO_CHAR(N_CONTADOR2) || '/' || TO_CHAR(TO_DATE(D_FECHA, 'DD/MM/YYYY'), 'MM') || '/' || TO_CHAR(D_FECHA, 'YYYY');
        
    V_CADENA := ' BEGIN ' || ' PQ_CR_COBUS.SP_CR_JOB_DIARIO_COBUS(TO_DATE(''' || D_FECHA_PROCESO || ''',''DD/MM/YYYY''),''' || V_USUARIO || ''');' || ' End; ';    
   

    IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      DBMS_JOB.SUBMIT(job       => N_JOB,
                      what      => V_CADENA,
                      next_date => sysdate + 1 / (24 * 60),
                      interval  => null,
                      no_parse  => false,
                      instance  => 2,
                      force     => false);
    ELSE
      DBMS_JOB.SUBMIT(job       => N_JOB,
                      what      => V_CADENA,
                      next_date => sysdate + 1 / (24 * 60),
                      interval  => null,
                      no_parse  => false,
                      force     => false);
    END IF;
    N_CONTADOR2 := N_CONTADOR2 + 1;
    COMMIT;      
  END LOOP;  
  LN_NUMJOB := 1;
  WHILE LN_NUMJOB > 0 loop
        BEGIN
            SELECT count(*)
                   INTO LN_NUMJOB
            FROM dba_jobs x     
            WHERE upper(x.what) LIKE '%PQ_CR_COBUS.SP_CR_JOB_DIARIO_COBUS%';            
        EXCEPTION WHEN OTHERS THEN
            LN_NUMJOB := 0;
        END;
   END LOOP;   
END SP_CR_JOB_MENSUAL_COBUS;

PROCEDURE SP_CR_JOB_DIARIO_COBUS(FECHA IN DATE, USUARIO IN CHAR)
AS
--EXPERIAN
CURSOR EXPERIAN IS
SELECT
JAQL546SERIAL SERIAL,
1 BURO,
JAQL546FEENV FEENV,
JAQL546HOENV HOENV,
JAQL546USSUC USSUC,
JAQL546USCOD USCOD,
JAQL546TIDOE TIDOE,
JAQL546TIDOB TIDOB,
JAQL546NUDOC NUDOC,
JAQL546NOMBR NOMBR,
JAQL546RASOC RASOC,
JAQL546NUCON NUCON,
JAQL546TIRES TIRES,
JAQL546ESCON ESCON,
JAQL546FEALT FEALT,
'' NROOPE,
'' HORINI,
'' HORFIN,
'' HORDIF,
JAQL546COERR RESCOD,
JAQL546MSERR RESMSG
FROM JAQL546
WHERE JAQL546FEENV = FECHA;

--SENTINEL
CURSOR SENTINEL IS
SELECT
JAQZ236SERIAL SERIAL,
2 BURO,
JAQZ236FEENV FEENV,
JAQZ236HOENV HOENV,
JAQZ236USSUC USSUC,
JAQZ236USCOD USCOD,
JAQZ236TIDOE TIDOE,
JAQZ236TIDOB TIDOB,
JAQZ236NUDOC NUDOC,
JAQZ236NOMBR NOMBR,
JAQZ236RASOC RASOC,
JAQZ236NUCON NUCON,
JAQZ236TIRES TIRES,
JAQZ236ESCON ESCON,
JAQZ236FEALT FEALT,
'' NROOPE,
'' HORINI,
'' HORFIN,
'' HORDIF,
JAQZ236COERR RESCOD,
JAQZ236MSERR RESMSG
FROM JAQZ236
WHERE JAQZ236FEENV = FECHA;

CURSOR EQUIFAX IS
SELECT
AQPB515SERIAL SERIAL,
3 BURO,
AQPB515FEENV FEENV,
AQPB515HOENV HOENV,
AQPB515USSUC USSUC,
AQPB515USCOD USCOD,
AQPB515TIDOE TIDOE,
AQPB515TIDOB TIDOB,
AQPB515NUDOC NUDOC,
AQPB515NOMBR NOMBR,
'' RASOC,
AQPB515NUCON NUCON,
AQPB515TIRES TIRES,
AQPB515ESCON ESCON,
AQPB515FEALT FEALT,
'' NROOPE,
AQPB515HORINI HORINI,
AQPB515HORFIN HORFIN,
AQPB515HORDIF HORDIF,
AQPB515RESCOD RESCOD,
AQPB515RESMSG RESMSG
FROM AQPB515
WHERE AQPB515FEENV = FECHA;

FECHA_INICIO DATE;
FECHA_FIN    DATE;
HORA_INICIO  VARCHAR(8);
HORA_FIN     VARCHAR(8);
LN_CONTADOR_E  NUMBER;
LN_CONTADOR_S  NUMBER;
LN_CONTADOR_X  NUMBER;
LN_MAXREG    NUMBER;
--       
lv_emisor  varchar2(40) := ''; 
lv_destino varchar2(100) := ''; 
lv_descopi varchar2(100) := ''; 
lv_asunto  varchar2(100) := ''; 
ll_mensaje long := '';
p_c_coderr  varchar2(5);
p_c_msgerr  varchar2(200);
 
BEGIN
  FECHA_INICIO     := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
  HORA_INICIO      := TO_CHAR(SYSDATE, 'HH24:MI:SS'); 
  --LIMPIAR TABLA
  BEGIN
    DELETE FROM AQPC572 WHERE aqpc572feenv = FECHA;
    COMMIT;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END; 
  --OBTENER N° MAX DE REGISTROS ERROR
  BEGIN    
    SELECT TP1NRO1 INTO LN_MAXREG
            FROM FST198 WHERE TP1COD1 = 11161 AND TP1CORR1 = 5 AND TP1CORR2 = 7 
            AND TP1CORR3 = 3;
  EXCEPTION WHEN OTHERS THEN
    LN_MAXREG := 5;
  END;
  
  LN_CONTADOR_E := 0;
  FOR A IN EXPERIAN LOOP
    BEGIN
      INSERT INTO AQPC572
      (aqpc572serial, aqpc572buro, aqpc572feenv, aqpc572hoenv, aqpc572ussuc,
      aqpc572uscod, aqpc572tidoe, aqpc572tidob, aqpc572nudoc, aqpc572nombr,
      aqpc572rasoc, aqpc572nucon, aqpc572tires, aqpc572escon, aqpc572fealt,
      aqpc572nroope, aqpc572horini, aqpc572horfin, aqpc572hordif, aqpc572rescod,
      aqpc572resmsg, aqpc572fcari, aqpc572hcari)
      VALUES
      (A.SERIAL, A.BURO, A.FEENV, A.HOENV, A.USSUC,
      A.USCOD, A.TIDOE, A.TIDOB, A.NUDOC, A.NOMBR,
      A.RASOC, A.NUCON, A.TIRES, A.ESCON, A.FEALT,
      A.NROOPE, A.HORINI, A.HORFIN, A.HORDIF, A.RESCOD,
      A.RESMSG, FECHA_INICIO, HORA_INICIO);
    EXCEPTION WHEN OTHERS THEN
      LN_CONTADOR_E := LN_CONTADOR_E + 1;
    END;
  END LOOP;
  COMMIT;
  
  LN_CONTADOR_S := 0;
  FOR B IN SENTINEL LOOP
    BEGIN
      INSERT INTO AQPC572
      (aqpc572serial, aqpc572buro, aqpc572feenv, aqpc572hoenv, aqpc572ussuc,
      aqpc572uscod, aqpc572tidoe, aqpc572tidob, aqpc572nudoc, aqpc572nombr,
      aqpc572rasoc, aqpc572nucon, aqpc572tires, aqpc572escon, aqpc572fealt,
      aqpc572nroope, aqpc572horini, aqpc572horfin, aqpc572hordif, aqpc572rescod,
      aqpc572resmsg, aqpc572fcari, aqpc572hcari)
      VALUES
      (B.SERIAL, B.BURO, B.FEENV, B.HOENV, B.USSUC,
      B.USCOD, B.TIDOE, B.TIDOB, B.NUDOC, B.NOMBR,
      B.RASOC, B.NUCON, B.TIRES, B.ESCON, B.FEALT,
      B.NROOPE, B.HORINI, B.HORFIN, B.HORDIF, B.RESCOD,
      B.RESMSG, FECHA_INICIO, HORA_INICIO);
    EXCEPTION WHEN OTHERS THEN
      LN_CONTADOR_S := LN_CONTADOR_S + 1;
    END;
  END LOOP;
  COMMIT;
  
  LN_CONTADOR_X := 0;
  FOR C IN EQUIFAX LOOP
    BEGIN
      INSERT INTO AQPC572
      (aqpc572serial, aqpc572buro, aqpc572feenv, aqpc572hoenv, aqpc572ussuc,
      aqpc572uscod, aqpc572tidoe, aqpc572tidob, aqpc572nudoc, aqpc572nombr,
      aqpc572rasoc, aqpc572nucon, aqpc572tires, aqpc572escon, aqpc572fealt,
      aqpc572nroope, aqpc572horini, aqpc572horfin, aqpc572hordif, aqpc572rescod,
      aqpc572resmsg, aqpc572fcari, aqpc572hcari)
      VALUES
      (C.SERIAL, C.BURO, C.FEENV, C.HOENV, C.USSUC,
      C.USCOD, C.TIDOE, C.TIDOB, C.NUDOC, C.NOMBR,
      C.RASOC, C.NUCON, C.TIRES, C.ESCON, C.FEALT,
      C.NROOPE, C.HORINI, C.HORFIN, C.HORDIF, C.RESCOD,
      C.RESMSG, FECHA_INICIO, HORA_INICIO);
    EXCEPTION WHEN OTHERS THEN
      LN_CONTADOR_X := LN_CONTADOR_X + 1;
    END;
  END LOOP;
  COMMIT;
  
  --ENVIO DE CORREO
  BEGIN
    SELECT TRIM(TP1DESC) INTO lv_destino
            FROM FST198 WHERE TP1COD1 = 11161 AND TP1CORR1 = 5 AND TP1CORR2 = 7 
            AND TP1CORR3 = 1 AND TP1NRO1 = 1;
  EXCEPTION WHEN OTHERS THEN
    lv_destino := '';
  END;  
  BEGIN    
    SELECT TRIM(TP1DESC) INTO lv_descopi
            FROM FST198 WHERE TP1COD1 = 11161 AND TP1CORR1 = 5 AND TP1CORR2 = 7 
            AND TP1CORR3 = 2 AND TP1NRO1 = 1;
  EXCEPTION WHEN OTHERS THEN
    lv_descopi := '';
  END;  
  IF LN_CONTADOR_E > LN_MAXREG OR LN_CONTADOR_S > LN_MAXREG OR LN_CONTADOR_X > LN_MAXREG THEN
          lv_emisor := 'notificaciones@cajaarequipa.pe';
          lv_asunto := 'ERROR EN CARGA MENSUAL DE REPORTE DE BURO - EQUIFAX';      
          ll_mensaje := 
          '<html><head><style type="text/css"></style>' ||
          '</head><body><br><p>Estimado.</p>' || 
          '<p>Fecha Ejecutada:</p>'|| TO_CHAR(FECHA) ||
          '<p>Revisar el proceso de carga mensual para Experian, hubo: ' || LN_CONTADOR_E ||' errores.'||
          '<p>Revisar el proceso de carga mensual para Sentinel, hubo: ' || LN_CONTADOR_S ||' errores.'||
          '<p>Revisar el proceso de carga mensual para Equifax, hubo: ' || LN_CONTADOR_X ||' errores.'||
          '</p><br><p>' || 'Atte.- <br><br>Equipo MDSI.</p></body></html>';                        
            
          BEGIN
                pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destino,
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
         EXCEPTION WHEN OTHERS THEN
           NULL;
         END;                       
  END IF;
  
  --ACTUALIZAR CARGA DE DATOS
  FECHA_FIN     := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
  HORA_FIN      := TO_CHAR(SYSDATE, 'HH24:MI:SS'); 
  BEGIN
  UPDATE AQPC572 SET aqpc572fcarf = FECHA_FIN, aqpc572hcarf = HORA_FIN, aqpc572uscar = USUARIO 
  WHERE aqpc572feenv = FECHA AND aqpc572fcari = FECHA_INICIO AND aqpc572hcari = HORA_INICIO;
  COMMIT;
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
  
END;
END PQ_CR_COBUS;
/

