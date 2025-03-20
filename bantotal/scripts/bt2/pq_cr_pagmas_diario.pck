create or replace package pq_cr_pagmas_diario is
  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA CARGA DE PAGOS MASIVOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/04/2024
  -- Autor de Creación          : AANGLES
  -- Uso                        : Carga de tabla aqpc862 para panel pagos masivos (HAQPC052)
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Autor de Modificación      : 
  -- Descripción de Modificación: 
  -- Fecha de Modificación      :   
  -- *****************************************************************
  procedure sp_job_diario_carga_aqpc862;

end pq_cr_pagmas_diario;
/

create or replace package body pq_cr_pagmas_diario is

  procedure sp_job_diario_carga_aqpc862 is
    vi_correos VARCHAR2(200);
    p_c_coderr VARCHAR2(1500);
    p_c_deserr VARCHAR2(1500);
    countBase  NUMBER(10);
    countFin   NUMBER(10);
  BEGIN
    DECLARE
      CURSOR PAGO IS
        SELECT DISTINCT d_Det.*,
                        TO_DATE(SUBSTR(d_Det.AQPC865obsaud,
                                       INSTR(d_Det.AQPC865obsaud, ':') + 2),
                                'DD/MM/YYYY') FECHA_PAGO,
                        TO_NUMBER(REPLACE(REGEXP_SUBSTR(REPLACE(d_Det.AQPC865DESAUD,
                                                                ',',
                                                                ''),
                                                        '\d+(\.\d+)?',
                                                        1,
                                                        1),
                                          '.',
                                          ',')) -
                        TO_NUMBER(REPLACE(REGEXP_SUBSTR(REPLACE(d_Det.AQPC865DESAUD,
                                                                ',',
                                                                ''),
                                                        '\d+(\.\d+)?',
                                                        1,
                                                        2),
                                          '.',
                                          ',')) DIFERENCIA
          FROM USRBNDJ.AQPC865 d_Det
         INNER JOIN fsd602 d_602
                    ON d_602.pgcod = d_Det.AQPC865Pgcod
                   AND d_602.ppmod = d_Det.AQPC865Aomod
                   AND d_602.ppsuc = d_Det.AQPC865Aosuc
                   AND d_602.ppmda = d_Det.AQPC865Aomda
                   AND d_602.pppap = d_Det.AQPC865Aopap
                   AND d_602.ppcta = d_Det.AQPC865Aocta
                   AND d_602.ppoper = d_Det.AQPC865Aooper
                   AND d_602.ppsbop = d_Det.AQPC865Aosbop
                   AND d_602.pptope = d_Det.AQPC865Aotope
                   AND d_602.d602fc = d_Det.AQPC865fecpro
                   AND d_602.d602co = 'S'
                 INNER JOIN fst034 t_034
                    ON t_034.pgcod = d_602.pgcod
                   AND t_034.trmod = d_602.d602mo
                   AND t_034.trnro = d_602.d602tr
                 INNER JOIN fsr008 r_008
                    ON r_008.pgcod = d_Det.AQPC865Pgcod
                   AND r_008.ctnro = d_Det.AQPC865Aocta
                 WHERE d_Det.AQPC865fecaud = TRUNC(SYSDATE)
                   AND d_Det.AQPC865CodAud = '002'
                   AND r_008.cttfir = 'T';
    
    BEGIN
      countFin := 0;
      FOR item IN pago LOOP
        BEGIN
          INSERT INTO AQPC862
            (AQPC862FECAUD,
             AQPC862HORAUD,
             AQPC862CODAUD,
             AQPC862FECPRO,
             AQPC862PGCOD,
             AQPC862AOMOD,
             AQPC862AOSUC,
             AQPC862AOMDA,
             AQPC862AOPAP,
             AQPC862AOCTA,
             AQPC862AOOPER,
             AQPC862AOSBOP,
             AQPC862AOTOPE,
             AQPC862DESAUD,
             AQPC862REV,
             AQPC862FECREV,
             AQPC862USRREV,
             AQPC862CORRE,
             AQPC862FECCOR,
             AQPC862USRCOR,
             AQPC862OBSAUD,
             AQPC862FECVENCU,
             AQPC862DIFE)
          VALUES
            (item.AQPC865FECAUD,
             item.AQPC865HORAUD,
             item.AQPC865CODAUD,
             item.AQPC865FECPRO,
             item.AQPC865PGCOD,
             item.AQPC865AOMOD,
             item.AQPC865AOSUC,
             item.AQPC865AOMDA,
             item.AQPC865AOPAP,
             item.AQPC865AOCTA,
             item.AQPC865AOOPER,
             item.AQPC865AOSBOP,
             item.AQPC865AOTOPE,
             item.AQPC865DESAUD,
             item.AQPC865REV,
             item.AQPC865FECREV,
             item.AQPC865USRREV,
             item.AQPC865CORRE,
             item.AQPC865FECCOR,
             item.AQPC865USRCOR,
             item.AQPC865OBSAUD,
             item.FECHA_PAGO,
             item.DIFERENCIA);
          COMMIT;
          countFin := countFin + 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END LOOP;
      BEGIN
        select count(*)
          INTO countBase
          from (SELECT DISTINCT d_Det.*,
                                TO_DATE(SUBSTR(d_Det.AQPC865obsaud,
                                               INSTR(d_Det.AQPC865obsaud, ':') + 2),
                                        'DD/MM/YYYY') FECHA_PAGO,
                                TO_NUMBER(REPLACE(REGEXP_SUBSTR(REPLACE(d_Det.AQPC865DESAUD,
                                                                        ',',
                                                                        ''),
                                                                '\d+(\.\d+)?',
                                                                1,
                                                                1),
                                                  '.',
                                                  ',')) -
                                TO_NUMBER(REPLACE(REGEXP_SUBSTR(REPLACE(d_Det.AQPC865DESAUD,
                                                                        ',',
                                                                        ''),
                                                                '\d+(\.\d+)?',
                                                                1,
                                                                2),
                                                  '.',
                                                  ',')) DIFERENCIA
                  FROM USRBNDJ.AQPC865 d_Det
                 INNER JOIN fsd602 d_602
                    ON d_602.pgcod = d_Det.AQPC865Pgcod
                   AND d_602.ppmod = d_Det.AQPC865Aomod
                   AND d_602.ppsuc = d_Det.AQPC865Aosuc
                   AND d_602.ppmda = d_Det.AQPC865Aomda
                   AND d_602.pppap = d_Det.AQPC865Aopap
                   AND d_602.ppcta = d_Det.AQPC865Aocta
                   AND d_602.ppoper = d_Det.AQPC865Aooper
                   AND d_602.ppsbop = d_Det.AQPC865Aosbop
                   AND d_602.pptope = d_Det.AQPC865Aotope
                   AND d_602.d602fc = d_Det.AQPC865fecpro
                   AND d_602.d602co = 'S'
                 INNER JOIN fst034 t_034
                    ON t_034.pgcod = d_602.pgcod
                   AND t_034.trmod = d_602.d602mo
                   AND t_034.trnro = d_602.d602tr
                 INNER JOIN fsr008 r_008
                    ON r_008.pgcod = d_Det.AQPC865Pgcod
                   AND r_008.ctnro = d_Det.AQPC865Aocta
                 WHERE d_Det.AQPC865fecaud = TRUNC(SYSDATE)
                   AND d_Det.AQPC865CodAud = '002'
                   AND r_008.cttfir = 'T');
     EXCEPTION
          WHEN OTHERS THEN
            NULL;
      END;
      if countBase <> countFin then
        declare
          cursor email is
            select TP1DESC
              from fst198
             where tp1cod1 = 11171
               and tp1corr1 = 40
               and TP1CORR2 = 1
               and TP1CORR3 > 0;
        begin
          FOR X IN EMAIL LOOP
            BEGIN
              vi_correos := vi_correos || trim(X.TP1DESC) || ';';
               EXCEPTION
          WHEN OTHERS THEN
            NULL;
            END;
          END LOOP;
          begin
          pq_ah_planillas.p_sendmailattach(vi_correos, --p_destinatariospara
                                           '', --p_destinatarioscc
                                           '', --p_destinatariosbcc
                                           '<br><br> Falla en SP_CR_PAGMAS_DIARIO', --mensaje a enviar
                                           'notificacionesbantotal@cajaarequipa.pe', --remitente
                                           'Resultados de la Ejecucion', --p_asunto
                                           'HTML', --p_asunto
                                           '', --p_directorio
                                           '', --p_archivosadjuntos
                                           p_c_coderr,
                                           p_c_deserr);
        
          DBMS_OUTPUT.put_line('Error2: ' || p_c_coderr || '-' ||
                               p_c_deserr);
          EXCEPTION
          WHEN OTHERS THEN
            NULL;
            end;
        end;
      END IF;
    END;
  end;
end pq_cr_pagmas_diario;
/

