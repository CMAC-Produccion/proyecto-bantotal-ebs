CREATE OR REPLACE PROCEDURE SP_CA_DATOSTABLAS(BL_DATOS       IN OUT SYS_REFCURSOR,
                                              P_TABLA        VARCHAR2,
                                              P_NUTAR CHAR,
                                              P_FECHA_INI    DATE,
                                              P_FECHA_FIN    DATE) IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_DATOSTABLAS
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CANALES
  -- VERSIÓN                    : 2.0
  -- FECHA DE CREACIÓN          : 22/03/2022
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : RECUPERACION DE INFORMACION
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      : TABLA, NRO, FECHAS
  -- FECHA DE MODIFICACIÓN      : ERIKA HIDALGO
  -- AUTOR DE MODIFICACIÓN      : 18/06/2025
  -- PARÁMETROS DE ENTRADA      : LIMITE DE CADENA
  -- FECHA DE MODIFICACIÓN      : ERIKA HIDALGO
  -- AUTOR DE MODIFICACIÓN      : 08/09/2025
  -- *****************************************************************

  CURSOR C_COLUMNS(V_COLT1 VARCHAR2) IS
    SELECT *
      FROM DBA_TAB_COLUMNS A
     WHERE A.OWNER = 'BANTPROD'
       AND A.TABLE_NAME = upper(P_TABLA)
       AND A.COLUMN_NAME<>V_COLT1;
  CURSOR C_JAQZ208 IS
    SELECT *
      FROM JAQZ208
     WHERE JAQZ208NUTAR = P_NUTAR AND
           JAQZ208FETRA BETWEEN P_FECHA_INI AND P_FECHA_FIN;
  CURSOR C_JAQL540 IS
    SELECT *
      FROM JAQL540
     WHERE JAQL540NUTAR = trim(P_NUTAR) AND
           JAQL540FETRA BETWEEN P_FECHA_INI AND P_FECHA_FIN;
  V_JAQZ208TRAMA VARCHAR2(32000);
  V_JAQZ208TEXTO VARCHAR2(32000);
  v_JAQZ208NUTAR VARCHAR2(50);
  D_FECMINJAQZ208 date;
  D_FECMINJAQL540 date;
  V_JAQL540TRAMA VARCHAR2(32000);
  V_JAQL540NUTAR VARCHAR2(50);
  V_AQPB885COLT1 VARCHAR2(500);
  V_AQPB885TDCL1 VARCHAR2(500);
  N_AQPB885LDCL1 NUMBER;
  V_AQPB885COLT4 VARCHAR2(500);
  V_COLUMNAS     VARCHAR2(32000) := '';
  v_sql_final    VARCHAR2(32000);

BEGIN
  
  IF (upper(P_TABLA) = 'JAQZ208') THEN
    BEGIN
      EXECUTE IMMEDIATE 'drop table JAQZ208_TEMP_' || USER || ' purge';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'create global temporary table JAQZ208_TEMP_' || USER ||
                        ' on commit preserve rows as ' ||
                        'select  jaqz208seint, jaqz208fetra, jaqz208hotra, jaqz208cores, jaqz208feits, jaqz208hoits, jaqz208nutar, jaqz208cotra,
      jaqz208fefts, jaqz208hofts, jaqz208sefec, jaqz208sehor, jaqz208secre, jaqz208secrs, jaqz208texto, jaqz208texto jaqz208trama,
      jaqz208canal, jaqz208detalle from JAQZ208 where 1=2';
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;

    execute immediate 'delete JAQZ208_TEMP_' || USER;
    commit;
    --validar con fecha mínima donde buscar info
    select min(a.jaqz208fetra) into D_FECMINJAQZ208 from jaqz208 a;--29/10/2021
        --30/11/2021>29/10/2021
    IF (P_FECHA_INI>D_FECMINJAQZ208) THEN
      FOR I IN C_JAQZ208 LOOP

/*        SELECT I.JAQZ208TRAMA INTO V_JAQZ208TRAMA FROM DUAL;
        v_JAQZ208NUTAR:= SUBSTR(I.JAQZ208NUTAR, 0, 6) || '******' || SUBSTR(I.JAQZ208NUTAR, 13, 4);
        select DECODE(TRIM(I.JAQZ208NUTAR),'''', I.JAQZ208TEXTO,FN_CC_REPLACE_TRAMA(I.JAQZ208TEXTO)) into
        V_JAQZ208TEXTO from dual;*/

        BEGIN
          SELECT I.JAQZ208TRAMA INTO V_JAQZ208TRAMA FROM DUAL;
          V_JAQZ208TRAMA := FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA);
        EXCEPTION
          WHEN OTHERS THEN    --01.09.2022
          V_JAQZ208TRAMA := 'DETALLE DE TRAMA MUY GRANDE, SOLICITAR A DBA EL DETALLE DE ESTE REGISTRO';
        END;

        IF (TRIM(I.JAQZ208NUTAR) is null) THEN
           V_JAQZ208TEXTO := I.JAQZ208TEXTO;
        ELSE
           V_JAQZ208TEXTO := FN_CC_REPLACE_TRAMA(I.JAQZ208TEXTO);
        END IF;

        V_JAQZ208TEXTO := replace(V_JAQZ208TEXTO,'''','');
        V_JAQZ208TEXTO := substr(V_JAQZ208TEXTO,1,1150);

        v_JAQZ208NUTAR:= SUBSTR(I.JAQZ208NUTAR, 0, 6) || '******' || SUBSTR(I.JAQZ208NUTAR, 13, 4);

        EXECUTE IMMEDIATE 'INSERT INTO JAQZ208_TEMP_' || USER || '
        VALUES ('||I.JAQZ208SEINT||', to_date(''' ||TO_CHAR(I.JAQZ208FETRA, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOTRA||''', '''||I.JAQZ208CORES||''', to_date(''' ||TO_CHAR(I.JAQZ208FEITS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOITS||''', '''||v_JAQZ208NUTAR||''', '''||I.JAQZ208COTRA||''', to_date(''' ||TO_CHAR(I.JAQZ208FEFTS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOFTS||''', to_date(''' ||TO_CHAR(I.JAQZ208SEFEC, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208SEHOR||''', '||I.JAQZ208SECRE||', '''||I.JAQZ208SECRS||''', '''||V_JAQZ208TEXTO||''', '''||
--        FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA)||''', '''||I.JAQZ208CANAL||''', '''||I.JAQZ208DETALLE||''')';
--        V_JAQZ208TRAMA||''', '''||I.JAQZ208CANAL||''', '''||I.JAQZ208DETALLE||''')';
        V_JAQZ208TRAMA||''', '''||I.JAQZ208CANAL||''', '''||replace(I.JAQZ208DETALLE,'''','')||''')';
        COMMIT;
      END LOOP;
      v_sql_final := 'select * from JAQZ208_TEMP_' || USER||' ORDER BY 2,3';
      open BL_DATOS for v_sql_final;
        --01/10/2021<29/10/2021    and   25/10/2021<29/10/2021
    ELSIF (P_FECHA_INI<D_FECMINJAQZ208 and P_FECHA_FIN<D_FECMINJAQZ208) THEN
      SP_CA_DATOS_JAQZ208H@BTHIST(P_USUARIO => USER,
                                   P_JAQZ208NUTAR => P_NUTAR,
                                   P_FECHA_INI => P_FECHA_INI,
                                   P_FECHA_FIN => P_FECHA_FIN);
      COMMIT;
      v_sql_final := 'select * from JAQZ208_TEMP_' || USER||'@BTHIST ORDER BY 2,3';
      open BL_DATOS for v_sql_final;
      RETURN;
        --29/10/2021<29/10/2021    and   31/10/2021>=29/10/2021
    ELSIF (P_FECHA_INI<=D_FECMINJAQZ208 and P_FECHA_FIN>=D_FECMINJAQZ208) THEN
      FOR I IN C_JAQZ208 LOOP
/*        SELECT I.JAQZ208TRAMA INTO V_JAQZ208TRAMA FROM DUAL;
        v_JAQZ208NUTAR:= SUBSTR(I.JAQZ208NUTAR, 0, 6) || '******' || SUBSTR(I.JAQZ208NUTAR, 13, 4);
        select DECODE(TRIM(I.JAQZ208NUTAR),'''', I.JAQZ208TEXTO,FN_CC_REPLACE_TRAMA(I.JAQZ208TEXTO)) into
        V_JAQZ208TEXTO from dual;*/

        BEGIN
          SELECT I.JAQZ208TRAMA INTO V_JAQZ208TRAMA FROM DUAL;
          V_JAQZ208TRAMA := FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA);
        EXCEPTION
          WHEN OTHERS THEN
          V_JAQZ208TRAMA := 'DETALLE DE TRAMA MUY GRANDE, SOLICITAR A DBA EL DETALLE DE ESTE REGISTRO';
        END;

        IF (TRIM(I.JAQZ208NUTAR) is null) THEN
           V_JAQZ208TEXTO := I.JAQZ208TEXTO;
        ELSE
           V_JAQZ208TEXTO := FN_CC_REPLACE_TRAMA(I.JAQZ208TEXTO);
        END IF;

        V_JAQZ208TEXTO := replace(V_JAQZ208TEXTO,'''','');
        V_JAQZ208TEXTO := substr(V_JAQZ208TEXTO,1,1150);

        v_JAQZ208NUTAR:= SUBSTR(I.JAQZ208NUTAR, 0, 6) || '******' || SUBSTR(I.JAQZ208NUTAR, 13, 4);

        EXECUTE IMMEDIATE 'INSERT INTO JAQZ208_TEMP_' || USER || '
        VALUES ('||I.JAQZ208SEINT||', to_date(''' ||TO_CHAR(I.JAQZ208FETRA, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOTRA||''', '''||I.JAQZ208CORES||''', to_date(''' ||TO_CHAR(I.JAQZ208FEITS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOITS||''', '''||v_JAQZ208NUTAR||''', '''||I.JAQZ208COTRA||''', to_date(''' ||TO_CHAR(I.JAQZ208FEFTS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HOFTS||''', to_date(''' ||TO_CHAR(I.JAQZ208SEFEC, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208SEHOR||''', '||I.JAQZ208SECRE||', '''||I.JAQZ208SECRS||''', '''||V_JAQZ208TEXTO||''', '''||
--        FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA)||''', '''||I.JAQZ208CANAL||''', '''||I.JAQZ208DETALLE||''')';
--        V_JAQZ208TRAMA||''', '''||I.JAQZ208CANAL||''', '''||I.JAQZ208DETALLE||''')';
        V_JAQZ208TRAMA||''', '''||I.JAQZ208CANAL||''', '''||replace(I.JAQZ208DETALLE,'''','')||''')';
        COMMIT;
      END LOOP;
      SP_CA_DATOS_JAQZ208H@BTHIST(P_USUARIO => USER,
                                   P_JAQZ208NUTAR => P_NUTAR,
                                   P_FECHA_INI => P_FECHA_INI,
                                   P_FECHA_FIN => P_FECHA_FIN);
      COMMIT;
      EXECUTE IMMEDIATE 'INSERT INTO JAQZ208_TEMP_' || USER || '
      SELECT * FROM JAQZ208_TEMP_' || USER||'@BTHIST';
      COMMIT;
      v_sql_final := 'select * from JAQZ208_TEMP_' || USER||' ORDER BY 2,3';
      open BL_DATOS for v_sql_final;
    END IF;
  ELSIF (upper(P_TABLA) = 'JAQL540') THEN
    BEGIN
      EXECUTE IMMEDIATE 'drop table JAQL540_TEMP_' || USER || ' purge';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'create global temporary table JAQL540_TEMP_' || USER ||
                        ' on commit preserve rows as ' ||
                        'select  jaql540comsj, jaql540cotra, jaql540coing, jaql540cores, jaql540feini, jaql540hoini, jaql540fefin, jaql540hofin, jaql540coter,
          jaql540cotrx, jaql540nutra, jaql540tmout, jaql540relac, jaql540trans, jaql540modul, jaql540paist, jaql540nutar, jaql540userc,
          jaql540coref, jaql540auxd2, jaql540auxv2, jaql540auxv1, jaql540auxn2, jaql540auxn1, jaql540auxc2, jaql540auxc1, JAQL540AUXV2||JAQL540AUXV2 jaql540trama, jaql540fetra
           from JAQL540 where 1=2';
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;

    execute immediate 'delete JAQL540_TEMP_' || USER;
    commit;
    --jun2022
    --validar con fecha máxima donde buscar info
    select min(a.jaql540feini) into D_FECMINJAQL540 from JAQL540 a;
    IF (P_FECHA_INI>D_FECMINJAQL540) THEN 
      FOR I IN C_JAQL540 LOOP
        --SELECT I.JAQL540TRAMA INTO V_JAQL540TRAMA FROM DUAL;
        BEGIN
          SELECT I.JAQL540TRAMA INTO V_JAQL540TRAMA FROM DUAL;
          V_JAQL540TRAMA := FN_CC_REPLACE_TRAMA_JAQL540(V_JAQL540TRAMA);
        EXCEPTION
          WHEN OTHERS THEN
          V_JAQL540TRAMA := 'DETALLE DE TRAMA MUY GRANDE, SOLICITAR A DBA EL DETALLE DE ESTE REGISTRO';
        END;
        
        v_JAQL540NUTAR:= SUBSTR(I.JAQL540NUTAR, 0, 6) || '******' || SUBSTR(I.JAQL540NUTAR, 13, 4);
        EXECUTE IMMEDIATE 'INSERT INTO JAQL540_TEMP_' || USER || '
        VALUES ('||I.JAQL540COMSJ||', '||I.JAQL540COTRA||', '''||I.JAQL540COING||''', '''||I.JAQL540CORES||''',
        to_date(''' ||TO_CHAR(I.JAQL540FEINI, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQL540HOINI||''', to_date(''' ||TO_CHAR(I.JAQL540FEFIN, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQL540HOFIN||''', '''||I.JAQL540COTER||''', '''||I.JAQL540COTRX||''', '''||I.JAQL540NUTRA||''', '||
        I.JAQL540TMOUT||', '||I.JAQL540RELAC||', '||I.JAQL540TRANS||', '||I.JAQL540MODUL||','''||I.JAQL540PAIST||''', '''||
        v_JAQL540NUTAR||''', '''||I.JAQL540USERC||''', '||I.JAQL540COREF||', to_date(''' ||TO_CHAR(I.JAQL540AUXD2, 'YYYYMMDD')||''',''YYYYMMDD''), '''||
        I.JAQL540AUXV2||''', '''||I.JAQL540AUXV1||''', '||I.JAQL540AUXN2||', '||I.JAQL540AUXN1||', '''||
        I.JAQL540AUXC2||''', '''||I.JAQL540AUXC1||''', '''||--FN_CC_REPLACE_TRAMA_JAQL540(V_JAQL540TRAMA)||''',
        V_JAQL540TRAMA||''',to_date(''' ||TO_CHAR(I.JAQL540FETRA, 'YYYYMMDD')||''',''YYYYMMDD'') )';
        COMMIT;
      END LOOP;
      v_sql_final := 'select * from JAQL540_TEMP_' || USER||' ORDER BY 5,6';
      open BL_DATOS for v_sql_final;      
    ELSIF (P_FECHA_INI<D_FECMINJAQL540 and P_FECHA_FIN<D_FECMINJAQL540) THEN
       SP_CA_DATOS_JAQL540@BTHIST(P_USUARIO => USER,
                                   P_JAQL540NUTAR => P_NUTAR,
                                   P_FECHA_INI => P_FECHA_INI,
                                   P_FECHA_FIN => P_FECHA_FIN);
      COMMIT;
      v_sql_final := 'select * from JAQL540_TEMP_' || USER||'@BTHIST ORDER BY 5,6';
      open BL_DATOS for v_sql_final;
      RETURN; 
    ELSIF (P_FECHA_INI<=D_FECMINJAQL540 and P_FECHA_FIN>=D_FECMINJAQL540) THEN
      FOR I IN C_JAQL540 LOOP

        BEGIN
          SELECT I.JAQL540TRAMA INTO V_JAQL540TRAMA FROM DUAL;
          V_JAQL540TRAMA := FN_CC_REPLACE_TRAMA_JAQL540(V_JAQL540TRAMA);
        EXCEPTION
          WHEN OTHERS THEN
          V_JAQL540TRAMA := 'DETALLE DE TRAMA MUY GRANDE, SOLICITAR A DBA EL DETALLE DE ESTE REGISTRO';
        END;

        v_JAQL540NUTAR:= SUBSTR(I.JAQL540NUTAR, 0, 6) || '******' || SUBSTR(I.JAQL540NUTAR, 13, 4);

        EXECUTE IMMEDIATE 'INSERT INTO JAQL540_TEMP_' || USER || '
        VALUES ('||I.JAQL540COMSJ||', '||I.JAQL540COTRA||', '''||I.JAQL540COING||''', '''||I.JAQL540CORES||''',
        to_date(''' ||TO_CHAR(I.JAQL540FEINI, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQL540HOINI||''', to_date(''' ||TO_CHAR(I.JAQL540FEFIN, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQL540HOFIN||''', '''||I.JAQL540COTER||''', '''||I.JAQL540COTRX||''', '''||I.JAQL540NUTRA||''', '||
        I.JAQL540TMOUT||', '||I.JAQL540RELAC||', '||I.JAQL540TRANS||', '||I.JAQL540MODUL||','''||I.JAQL540PAIST||''', '''||
        v_JAQL540NUTAR||''', '''||I.JAQL540USERC||''', '||I.JAQL540COREF||', to_date(''' ||TO_CHAR(I.JAQL540AUXD2, 'YYYYMMDD')||''',''YYYYMMDD''), '''||
        I.JAQL540AUXV2||''', '''||I.JAQL540AUXV1||''', '||I.JAQL540AUXN2||', '||I.JAQL540AUXN1||', '''||
        I.JAQL540AUXC2||''', '''||I.JAQL540AUXC1||''', '''||--FN_CC_REPLACE_TRAMA_JAQL540(V_JAQL540TRAMA)||''',
        V_JAQL540TRAMA||''',to_date(''' ||TO_CHAR(I.JAQL540FETRA, 'YYYYMMDD')||''',''YYYYMMDD'') )';
        COMMIT;
      END LOOP;
      SP_CA_DATOS_JAQL540@BTHIST(P_USUARIO => USER,
                                   P_JAQL540NUTAR => P_NUTAR,
                                   P_FECHA_INI => P_FECHA_INI,
                                   P_FECHA_FIN => P_FECHA_FIN);
      COMMIT;
      EXECUTE IMMEDIATE 'INSERT INTO JAQL540_TEMP_' || USER || '
      SELECT * FROM JAQL540_TEMP_' || USER||'@BTHIST';
      COMMIT;
      v_sql_final := 'select * from JAQL540_TEMP_' || USER||' ORDER BY 5,6';
      open BL_DATOS for v_sql_final;
    END IF; 
  ELSIF (upper(P_TABLA) = 'NUMDOC') THEN --Para obtener soporte
        v_sql_final := 'select * from Z0E478 a where a.z0e478thd='''||trim(P_NUTAR) ||'''';
        open BL_DATOS for v_sql_final;
  ELSE--OTRAS TABLAS
      SELECT AQPB885COLT1, AQPB885TDCL1, AQPB885LDCL1,AQPB885COLT4
        INTO V_AQPB885COLT1, V_AQPB885TDCL1, N_AQPB885LDCL1,V_AQPB885COLT4
        FROM AQPB885 A
       WHERE A.AQPB885TABLA = upper(P_TABLA)
         and A.AQPB885HABIL='S';
      FOR I IN C_COLUMNS(V_AQPB885COLT1) LOOP
        V_COLUMNAS := V_COLUMNAS || I.COLUMN_NAME || ',';
      END LOOP;
      V_COLUMNAS := SUBSTR(V_COLUMNAS,1,LENGTH(V_COLUMNAS)-1);
      IF V_AQPB885TDCL1 = 'CHAR' and upper(P_TABLA) not in ('X9996D','X9996E') THEN
        v_sql_final := 'select SUBSTR('||V_AQPB885COLT1||', 0, 6) || ''******'' || SUBSTR('||V_AQPB885COLT1||', 13, 4) '||V_AQPB885COLT1||', '||V_COLUMNAS||
        ' from '||upper(P_TABLA)||' A WHERE A.'||V_AQPB885COLT1||'='''||P_NUTAR||''' AND A.'||V_AQPB885COLT4||' between '||
        'to_date(''' ||TO_CHAR(P_FECHA_INI, 'YYYYMMDD')||''',''YYYYMMDD'') AND
        to_date(''' ||TO_CHAR(P_FECHA_FIN, 'YYYYMMDD')||''',''YYYYMMDD'') ORDER BY '||V_AQPB885COLT4;
      ELSIF V_AQPB885TDCL1 = 'NUMBER' and upper(P_TABLA)='JAQL539' THEN
        v_sql_final := 'SELECT JAQL539COTRA,JAQL539NUCAM,JAQL539TIMSJ,
           case when jaql539nucam=2 then substr(jaql539valtr,0,8)||''******''||substr(jaql539valtr,15,4)
                when jaql539nucam=35 then substr(jaql539valtr,0,8)||''******''||substr(jaql539valtr,15,4)||substr(jaql539valtr,17,4)
                else   jaql539valtr 
                end jaql539valtr from '||upper(P_TABLA)||' where JAQL539COTRA='||P_NUTAR;
      ELSIF upper(P_TABLA)='X9996D' THEN
        v_sql_final := 'SELECT A.X9996ACNCO, A.X9996DFESV, A.X9996DHOSV, A.X9996DRQSV, A.X9996DFECL, A.X9996DHOCL,
               CASE
                 WHEN A.X9996DRQCL LIKE ''4261%'' THEN
                  TRIM(SUBSTR(TRIM(A.X9996DRQCL), 0, 6) || ''******'' ||
                 SUBSTR(TRIM(A.X9996DRQCL), 13, 4) ||
                 SUBSTR(TRIM(A.X9996DRQCL), 17, 50))
                 WHEN SUBSTR(A.X9996DRQCL, 14, 4) LIKE ''4261%'' THEN
                  TRIM(SUBSTR(TRIM(A.X9996DRQCL), 0, 20) || ''******'' ||
                 SUBSTR(TRIM(A.X9996DRQCL), 27, 4) ||
                 SUBSTR(TRIM(A.X9996DRQCL), 32, 50))
                 ELSE
                  A.X9996DRQCL
               END X9996DRQCL,
              A.X9996BOPCO, A.X9996CVART, A.X9996DRQUS, A.X9996DRQWS, A.X9996DDPGC, A.X9996DDSUC, A.X9996DDMOD, A.X9996DDMDA, A.X9996DDPAP, A.X9996DDCTA,
              A.X9996DDOPE, A.X9996DDSBO, A.X9996DDTOP, A.X9996DCPGC, A.X9996DCSUC, A.X9996DCMOD, A.X9996DCMDA, A.X9996DCPAP, A.X9996DCCTA, A.X9996DCOPE,
              A.X9996DCSBO, A.X9996DCTOP, A.X9996DIMPO, A.X9996DIMP2, A.X9996DMDAO, A.X9996DCOTZ, A.X9996GRSCO, A.X9996DRPGC, A.X9996DRSUC, A.X9996DRMOD,
              A.X9996DRTRN, A.X9996DRREL, A.X9996DRMNC, A.X9996DRSDO, A.X9996DRSDD
                FROM '||upper(P_TABLA)||' A WHERE A.X9996DRQSV ='||P_NUTAR;
      ELSIF upper(P_TABLA)='X9996E' THEN
        v_sql_final := 'SELECT A.X9996ACNCO, A.X9996DFESV, A.X9996DHOSV, A.X9996DRQSV, A.X9996EDATO, A.X9996ETDAT,
       CASE
         WHEN A.X9996EVALC LIKE ''4261%'' THEN
          SUBSTR(TRIM(A.X9996EVALC), 0, 6) || ''******'' ||
          SUBSTR(TRIM(A.X9996EVALC), 13, 4)
         ELSE
          A.X9996EVALC
       END X9996EVALC, A.X9996EVALL
        FROM '||upper(P_TABLA)||' A WHERE A.X9996DRQSV ='||P_NUTAR;
      ELSIF V_AQPB885TDCL1 = 'VARCHAR2' and upper(P_TABLA)='ITXN' THEN
       v_sql_final := 'SELECT
        STATUS, MSGNO, CAPDATE, DATEIN, TIMEIN, DATEOUT, TIMEOUT, TRACE, SYS_TRACE, MSGTYPE, ABMDATE, ABMTIME, RESPCODE,
        SUBSTR(A.PAN,0,6)||''******''||SUBSTR(A.PAN,13,4) PAN,
        DECODE(B.Z0E478THD,NULL,NULL,''****''||SUBSTR(TRIM(B.Z0E478THD),5,LENGTH(TRIM(B.Z0E478THD))-4)) Z0E478THD,
        PRCODE, FACCTYPE, TACCTYPE, ACCTID1, ACCTID2, REP_FROMACCT, REP_TOACCT, TXNAMT, COMPAMOUNT, COMPCDBAMT, STLAMT, CNVRATE_STL,
        CONVDATE, CUR_TRAN, CUR_STL, REFNUM, STLDATE, TRANSDATE, TRANSTIME, OTRDATE, OTRTIME, REV_FLAG, AUTH_ID, ADDTL_RESP_DATA, MERCHANT,
        PAYEE, POS_COND_CODE, POS_CODE_EXT, POS_ENTRY_MODE, ACC_TERMID, ACC_IDENT, REP_TXNAMT, REP_STLAMT, POA, OPERATOR_NUMBER, DEV_NO,
        RESPONSE, CARD_SEQ_NUM, EXPDATE, MISC1, MISC2, ACQINST, ACQINSTID, ISSINST, ISSINSTID, STLINST, STLINSTID, ORGINST, ORGINSTID,
        REQINST, REVREASON, ORGMSG, OTRACE, OREFNUM, ODATE, OTIME, OACQINST, OISSINST, TERMID, DEVICETYPE, BRANCH, ACCEPTORNAME, ABMLOC, TRACK2,
        TRACK3, OTHER_FEE, ISSPDAGENT_FEE, ISSPDSWITCH_FEE, ISSPDNETWORK_FEE, ACQPDAGENT_FEE, ACQPDSWITCH_FEE, ACQPDNETWORK_FEE, ACQ_FEE, REGION_FEE,
        BITMAP, CDBAMT, CNVRATE_CDB, CUR_CDB, CUSTOMER_RESPONSE, MISC, NII, SYS_BATCH, ISS_FEE, NTWK_PRIVATE_DATA, ISO_ACQINST, ISO_ISSINST,
        ISO_STLINST, ISO_REQINST, DEVICE_DATA, STL_FEE, CNV_FEE, NET_INTL_DATA, SMART_CARD_DATA, ACQ_POSTING_DATE, RETAILER_ID, CARD_SCHEME_ID,
        CARD_SCHEME_INFO, NOTES_GIVEN, SUBSCRIBER_ID, TERMINAL_OWNER, TERMINAL_LOCATION, TERMINAL_CITY, TERMINAL_COUNTRY, POS_TERM_DATA, SETTLEMENT_CODE,
        BATCHID, DEVSETTLED, MERPOSTED, CHD_ID_METHOD, MISC3, ISSDATE, ACQDATE, ACQ_CNTRY_CODE, OTHAMT, ADDTL_DATA, TRAN_FEE
        FROM ITXN@TXNSWT A LEFT OUTER JOIN Z0E478 B
          ON A.PAN=TRIM(B.Z0E478NRO)
        WHERE PAN='||P_NUTAR|| ' AND DATEIN BETWEEN '||
        'to_date(''' ||TO_CHAR(P_FECHA_INI, 'YYYYMMDD')||''',''YYYYMMDD'') AND
        to_date(''' ||TO_CHAR(P_FECHA_FIN, 'YYYYMMDD')||''',''YYYYMMDD'') ';
      ELSE
        v_sql_final := 'select SUBSTR('||V_AQPB885COLT1||', 0, 6) || ''******'' || SUBSTR('||V_AQPB885COLT1||', 13, 4) '||V_AQPB885COLT1||', '||V_COLUMNAS||
        ' from '||upper(P_TABLA)||' A WHERE TRIM(A.'||V_AQPB885COLT1||')='''||P_NUTAR||''' AND A.'||V_AQPB885COLT4||' between '||
        'to_date(''' ||TO_CHAR(P_FECHA_INI, 'YYYYMMDD')||''',''YYYYMMDD'') AND
        to_date(''' ||TO_CHAR(P_FECHA_FIN, 'YYYYMMDD')||''',''YYYYMMDD'') ORDER BY '||V_AQPB885COLT4;
      END IF;
      open BL_DATOS for v_sql_final;
  END IF;

  INSERT INTO AQPB876 VALUES (USER,SYSDATE,'SP_CA_DATOSTABLAS',  P_TABLA||'-'||P_NUTAR||
              '-'||NVL(to_char(P_FECHA_INI,'RRRR/MM/DD'),'')||'-'||NVL(to_char(P_FECHA_FIN,'RRRR/MM/DD'),''));
  COMMIT;

END SP_CA_DATOSTABLAS;
/
