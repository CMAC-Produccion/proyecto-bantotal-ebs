CREATE OR REPLACE PROCEDURE SP_CA_DATOSTABLAS_FRAUDE(BL_DATOS       IN OUT SYS_REFCURSOR,
                                              P_TABLA        VARCHAR2,
                                              P_NUTAR CHAR,
                                              P_FECHA_INI    DATE,
                                              P_FECHA_FIN    DATE) IS
   
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_DATOSTABLAS_FRAUDE
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CANALES
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 08/11/2024
  -- Autor de Creación          : ERIKA HIDALGO
  -- USO                        : EXTRACCION DATA PARA USUARIOS DEL AREA DE FRAUDE
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- PARÁMETROS DE ENTRADA      : BL_DATOS : RESULTADO, P_TABLA : TABLA, P_NUTAR : PAN, P_FECHA_INI : FECHA INICIO, P_FECHA_FIN : FECHAFIN
  -- Fecha de Modifición        : 04/08/2025
  -- Autor de Modifición        : ERIKA HIDALGO
  -- Fecha de Modifición        : 03/12/2025
  -- Autor de Modifición        : ERIKA HIDALGO  
  CURSOR C_COLUMNS(V_COLT1 VARCHAR2) IS
    SELECT *
      FROM DBA_TAB_COLUMNS A
     WHERE A.OWNER = 'BANTPROD'
       AND A.TABLE_NAME = upper(P_TABLA)
       AND A.COLUMN_NAME<>V_COLT1;
  CURSOR C_JAQZ208 IS
    SELECT /*+ALL_ROWS parallel(a,10) parallel(b,10)*/ 
           a.*, '****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4) z0e478thd
      FROM JAQZ208HI a left outer join Z0E478 b
           on a.jaqz208hinutar=b.Z0E478NRO
     WHERE JAQZ208HINUTAR = P_NUTAR AND
           JAQZ208HIFETRA BETWEEN P_FECHA_INI AND P_FECHA_FIN;
  CURSOR C_JAQL540 IS
    SELECT a.*, '****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4) z0e478thd
      FROM JAQL540 a left outer join Z0E478 b
           on a.jaql540nutar=trim(b.Z0E478NRO)
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
  execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; 
  IF (upper(P_TABLA) = 'JAQZ208HI') THEN
    BEGIN
      EXECUTE IMMEDIATE 'drop table JAQZ208_TEMP_' || USER || ' purge';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      EXECUTE IMMEDIATE 'create global temporary table JAQZ208_TEMP_' || USER ||
                        ' on commit preserve rows as ' ||
                        'select  jaqz208hiseint, jaqz208hifetra, jaqz208hihotra, jaqz208hicores, jaqz208hifeits, jaqz208hihoits, jaqz208hinutar,
                        z0e478thd,
                        jaqz208hicotra,
      jaqz208hifefts, jaqz208hihofts, jaqz208hisefec, jaqz208hisehor, jaqz208hisecre, jaqz208hisecrs, jaqz208hitexto, jaqz208hitexto jaqz208hitrama,
      jaqz208hicanal, jaqz208hidetalle from JAQZ208HI left outer join Z0E478
  on jaqz208hinutar=Z0E478NRO where 1=2';
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;

    execute immediate 'delete JAQZ208_TEMP_' || USER;
    commit;
    --validar con fecha mínima donde buscar info
--    select min(a.jaqz208fetra) into D_FECMINJAQZ208 from jaqz208 a;--29/10/2021
        --30/11/2021>29/10/2021
--    IF (P_FECHA_INI>=D_FECMINJAQZ208) THEN
      FOR I IN C_JAQZ208 LOOP

        BEGIN
          SELECT I.JAQZ208HITRAMA INTO V_JAQZ208TRAMA FROM DUAL;
          V_JAQZ208TRAMA := FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA);
        EXCEPTION
          WHEN OTHERS THEN    --01.09.2022
          V_JAQZ208TRAMA := 'DETALLE DE TRAMA MUY GRANDE, SOLICITAR A DBA EL DETALLE DE ESTE REGISTRO';
        END;

        IF (TRIM(I.JAQZ208HINUTAR) is null) THEN
           V_JAQZ208TEXTO := I.JAQZ208HITEXTO;
        ELSE
           V_JAQZ208TEXTO := FN_CC_REPLACE_TRAMA(I.JAQZ208HITEXTO);
        END IF;

        V_JAQZ208TEXTO := replace(V_JAQZ208TEXTO,'''','');

        v_JAQZ208NUTAR:= SUBSTR(I.JAQZ208HINUTAR, 0, 6) || '******' || SUBSTR(I.JAQZ208HINUTAR, 13, 4);

        EXECUTE IMMEDIATE 'INSERT INTO JAQZ208_TEMP_' || USER || '
        VALUES ('||I.JAQZ208HISEINT||', to_date(''' ||TO_CHAR(I.JAQZ208HIFETRA, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HIHOTRA||''', '''||I.JAQZ208HICORES||''', to_date(''' ||TO_CHAR(I.JAQZ208HIFEITS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HIHOITS||''', '''||v_JAQZ208NUTAR||''', '''||I.z0e478thd||''', '''||I.JAQZ208HICOTRA||''', to_date(''' ||TO_CHAR(I.JAQZ208HIFEFTS, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HIHOFTS||''', to_date(''' ||TO_CHAR(I.JAQZ208HISEFEC, 'YYYYMMDD')||''',''YYYYMMDD'') , '''||
        I.JAQZ208HISEHOR||''', '||I.JAQZ208HISECRE||', '''||I.JAQZ208HISECRS||''', '''||V_JAQZ208TEXTO||''', '''||
--        FN_CC_REPLACE_TRAMA_JAQZ208(V_JAQZ208TRAMA)||''', '''||I.JAQZ208HICANAL||''', '''||I.JAQZ208HIDETALLE||''')';
--        V_JAQZ208TRAMA||''', '''||I.JAQZ208HICANAL||''', '''||I.JAQZ208HIDETALLE||''')';
        V_JAQZ208TRAMA||''', '''||I.JAQZ208HICANAL||''', '''||replace(I.JAQZ208HIDETALLE,'''','')||''')';
        COMMIT;
      END LOOP;
      v_sql_final := 'select * from JAQZ208_TEMP_' || USER||' ORDER BY 2,3';
      open BL_DATOS for v_sql_final;
--    END IF;
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
          jaql540cotrx, jaql540nutra, jaql540tmout, jaql540relac, jaql540trans, jaql540modul, jaql540paist, jaql540nutar,
          z0e478thd,
          jaql540userc,
          jaql540coref, jaql540auxd2, jaql540auxv2, jaql540auxv1, jaql540auxn2, jaql540auxn1, jaql540auxc2, jaql540auxc1, JAQL540AUXV2||JAQL540AUXV2 jaql540trama, jaql540fetra
           from JAQL540 left outer join Z0E478
             on jaql540nutar=trim(Z0E478NRO) where 1=2';
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;

    execute immediate 'delete JAQL540_TEMP_' || USER;
    commit;
    --jun2022
    --validar con fecha máxima donde buscar info
--    select min(a.jaql540feini) into D_FECMINJAQL540 from JAQL540 a;
--    IF (P_FECHA_INI>=D_FECMINJAQL540) THEN
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
        v_JAQL540NUTAR||''', '''||I.z0e478thd||''', '''||I.JAQL540USERC||''', '||I.JAQL540COREF||', to_date(''' ||TO_CHAR(I.JAQL540AUXD2, 'YYYYMMDD')||''',''YYYYMMDD''), '''||
        I.JAQL540AUXV2||''', '''||I.JAQL540AUXV1||''', '||I.JAQL540AUXN2||', '||I.JAQL540AUXN1||', '''||
        I.JAQL540AUXC2||''', '''||I.JAQL540AUXC1||''', '''||--FN_CC_REPLACE_TRAMA_JAQL540(V_JAQL540TRAMA)||''',
        V_JAQL540TRAMA||''',to_date(''' ||TO_CHAR(I.JAQL540FETRA, 'YYYYMMDD')||''',''YYYYMMDD'') )';
        COMMIT;
      END LOOP;
      v_sql_final := 'select * from JAQL540_TEMP_' || USER||' ORDER BY 5,6';
      open BL_DATOS for v_sql_final;
--    END IF;
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
      IF V_AQPB885TDCL1 = 'CHAR' THEN
        v_sql_final := 'select SUBSTR('||V_AQPB885COLT1||', 0, 6) || ''******'' || SUBSTR('||V_AQPB885COLT1||', 13, 4) '||V_AQPB885COLT1||',
                       ''****''||substr(trim(b.Z0E478THD),5,length(trim(b.Z0E478THD))-4) Z0E478THD,
                       '||V_COLUMNAS||
        ' from '||upper(P_TABLA)||' A
          LEFT OUTER JOIN Z0E478 B ON A.'||V_AQPB885COLT1||'=B.Z0E478NRO
    WHERE A.'||V_AQPB885COLT1||'='''||P_NUTAR||''' AND A.'||V_AQPB885COLT4||' between '||
        'to_date(''' ||TO_CHAR(P_FECHA_INI, 'YYYYMMDD')||''',''YYYYMMDD'') AND
        to_date(''' ||TO_CHAR(P_FECHA_FIN, 'YYYYMMDD')||''',''YYYYMMDD'') ORDER BY '||V_AQPB885COLT4;
      ELSE
        v_sql_final := 'select SUBSTR('||V_AQPB885COLT1||', 0, 6) || ''******'' || SUBSTR('||V_AQPB885COLT1||', 13, 4) '||V_AQPB885COLT1||',
                       ''****''||substr(trim(b.Z0E478THD),5,length(trim(b.Z0E478THD))-4) Z0E478THD,
                     '||V_COLUMNAS||
        ' from '||upper(P_TABLA)||' A
        LEFT OUTER JOIN Z0E478 B ON TRIM(A.'||V_AQPB885COLT1||')=B.Z0E478NRO
    WHERE TRIM(A.'||V_AQPB885COLT1||')='''||P_NUTAR||''' AND A.'||V_AQPB885COLT4||' between '||
        'to_date(''' ||TO_CHAR(P_FECHA_INI, 'YYYYMMDD')||''',''YYYYMMDD'') AND
        to_date(''' ||TO_CHAR(P_FECHA_FIN, 'YYYYMMDD')||''',''YYYYMMDD'') ORDER BY '||V_AQPB885COLT4;
      END IF;
      open BL_DATOS for v_sql_final;
  END IF;

  INSERT INTO AQPB876 VALUES (USER,SYSDATE,'SP_CA_DATOSTABLAS_FRAUDE',  P_TABLA||'-'||P_NUTAR||
              '-'||NVL(to_char(P_FECHA_INI,'RRRR/MM/DD'),'')||'-'||NVL(to_char(P_FECHA_FIN,'RRRR/MM/DD'),''));
  COMMIT;
END SP_CA_DATOSTABLAS_FRAUDE;
/
