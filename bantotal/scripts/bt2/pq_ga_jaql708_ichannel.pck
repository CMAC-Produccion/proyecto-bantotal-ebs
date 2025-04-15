CREATE OR REPLACE PACKAGE PQ_GA_JAQL708_ICHANNEL IS
  --LUIS CARPIO/ERIKA HIDALGO
  PROCEDURE SP_JAQL708_JAQL708USR(P_JAQL708USR CHAR);
  PROCEDURE SP_JAQL708_JAQL708TLF(P_JAQL708TLF NUMBER);
  PROCEDURE SP_CLIENTES_AFILIADOS_CODIGO_CLIENTE(P_CODIGO_CLIENTE VARCHAR2);
  PROCEDURE SP_CLIENTES_AFILIADOS_ELIMINA_CELULAR_CLIENTE(P_CODIGO_CLIENTE VARCHAR2, P_CELULAR_CLIENTE VARCHAR2);
  PROCEDURE SP_T_TRABCESA_CANCELAR_CESE(P_NU_DOCU_IDEN VARCHAR2);
  PROCEDURE SP_T_JAQN17_TEMPORALES ( entrega_USO CHAR, recibe_USD CHAR);--RONALD MEZA
  PROCEDURE SP_SNGAS2_RETIRA_TEMPORAL_AUTO ( P_SNGAS2USR CHAR, P_SNGAS2COD NUMBER);--RONALD MEZA
  PROCEDURE SP_UPD_JAQM41_T(P_JAQM41FEF DATE);--RONALD MEZA
  PROCEDURE SP_UPD_JAQM2E_T(P_JAQM2EFEF DATE);--RONALD MEZA
END PQ_GA_JAQL708_ICHANNEL;
/
CREATE OR REPLACE PACKAGE BODY PQ_GA_JAQL708_ICHANNEL is
  -- *****************************************************************
  -- Nombre                     : PQ_GA_JAQL708_ICHANNEL
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Gestion Accesos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 25/09/2023
  -- Autor de Creación          : ERIKA HIDALGO
  -- Uso                        : Control de Celulares de usuarios y cancelación de ceses
  -- Estado                     : Activo
  -- Parámetros de Entrada      : 
  -- Fecha de Modificación      : 20/11/2023
  -- Autor de Modificación      : ERIKA HIDALGO
  -- Fecha de Modificación      : 03/10/2024
  -- Autor de Modificación      : RONALD MEZA
  -- Fecha de Modificación      : 09/04/2025
  -- Autor de Modificación      : ERIKA HIDALGO 
  PROCEDURE SP_JAQL708_JAQL708USR(P_JAQL708USR CHAR) IS                           
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQL708
     WHERE JAQL708USR = P_JAQL708USR;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.JAQL708_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from JAQL708 where JAQL708USR=''' ||P_JAQL708USR||'''';
    
      DELETE FROM JAQL708
         WHERE JAQL708USR = P_JAQL708USR;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en JAQL708 para JAQL708USR:' ||
                           P_JAQL708USR);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQL708USR:' || P_JAQL708USR || ' considera ' ||
                           N_CONT || ' registro(s) en la JAQL708.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_JAQL708_JAQL708USR',P_JAQL708USR);
    commit;
  END SP_JAQL708_JAQL708USR;


  PROCEDURE SP_JAQL708_JAQL708TLF(P_JAQL708TLF NUMBER) IS                           
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQL708
     WHERE JAQL708TLF = P_JAQL708TLF;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.JAQL708_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from JAQL708 where JAQL708TLF=' || P_JAQL708TLF;
    
      DELETE FROM JAQL708
         WHERE JAQL708TLF = P_JAQL708TLF;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en JAQL708 para JAQL708TLF:' ||
                           P_JAQL708TLF);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQL708TLF:' || P_JAQL708TLF || ' considera ' ||
                           N_CONT || ' registro(s) en la JAQL708.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_JAQL708_JAQL708TLF',P_JAQL708TLF);
    commit;
  END SP_JAQL708_JAQL708TLF;


  PROCEDURE SP_CLIENTES_AFILIADOS_CODIGO_CLIENTE(P_CODIGO_CLIENTE VARCHAR2) IS                           
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM ICHANNELALERT.CLIENTES_AFILIADOS
     WHERE CODIGO_CLIENTE = P_CODIGO_CLIENTE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.CLIENTES_AFILIADOS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from ICHANNELALERT.CLIENTES_AFILIADOS where CODIGO_CLIENTE=''' || P_CODIGO_CLIENTE||'''';
    
      DELETE FROM ICHANNELALERT.CLIENTES_AFILIADOS
         WHERE CODIGO_CLIENTE = P_CODIGO_CLIENTE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en ICHANNELALERT.CLIENTES_AFILIADOS para CODIGO_CLIENTE:' ||
                           P_CODIGO_CLIENTE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El CODIGO_CLIENTE:' || P_CODIGO_CLIENTE || ' considera ' ||
                           N_CONT || ' registro(s) en la ICHANNELALERT.CLIENTES_AFILIADOS.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_CLIENTES_AFILIADOS_CODIGO_CLIENTE',P_CODIGO_CLIENTE);
    commit;
  END SP_CLIENTES_AFILIADOS_CODIGO_CLIENTE;

--09/04/2025 actualizado
  PROCEDURE SP_CLIENTES_AFILIADOS_ELIMINA_CELULAR_CLIENTE(P_CODIGO_CLIENTE VARCHAR2, P_CELULAR_CLIENTE VARCHAR2) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM ICHANNELALERT.CLIENTES_AFILIADOS
     WHERE CELULAR_CLIENTE = P_CELULAR_CLIENTE AND CODIGO_CLIENTE = P_CODIGO_CLIENTE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.CLIENTES_AFILIADOS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from ICHANNELALERT.CLIENTES_AFILIADOS where CELULAR_CLIENTE=''' || P_CELULAR_CLIENTE||''' 
                         AND CODIGO_CLIENTE='''||P_CODIGO_CLIENTE||'''';
    
      DELETE FROM ICHANNELALERT.CLIENTES_AFILIADOS
         WHERE CELULAR_CLIENTE = P_CELULAR_CLIENTE AND CODIGO_CLIENTE = P_CODIGO_CLIENTE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en ICHANNELALERT.CLIENTES_AFILIADOS para CODIGO_CLIENTE:'||P_CODIGO_CLIENTE||' y CELULAR_CLIENTE:' ||
                           P_CELULAR_CLIENTE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El CODIGO_CLIENTE '||P_CODIGO_CLIENTE||' y CELULAR_CLIENTE:' || P_CELULAR_CLIENTE || ' considera ' ||
                           N_CONT || ' registro(s) en la ICHANNELALERT.CLIENTES_AFILIADOS.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_CLIENTES_AFILIADOS_CELULAR_CLIENTE',P_CODIGO_CLIENTE||'-'||P_CELULAR_CLIENTE);
    commit;
  END SP_CLIENTES_AFILIADOS_ELIMINA_CELULAR_CLIENTE;

 
  PROCEDURE SP_T_TRABCESA_CANCELAR_CESE(P_NU_DOCU_IDEN VARCHAR2) IS                           
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
     FROM T_TRABCESA@EMPCES A WHERE A."nu_docu_iden"=P_NU_DOCU_IDEN;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.T_TRABCESA_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from T_TRABCESA@EMPCES A WHERE A."nu_docu_iden"=''' ||P_NU_DOCU_IDEN||'''';
    
      DELETE FROM T_TRABCESA@EMPCES
         WHERE "nu_docu_iden"= P_NU_DOCU_IDEN;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en T_TRABCESA@EMPCES para NRO DE DOCUMENTO:' ||
                           P_NU_DOCU_IDEN);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El Nro de Documento:' || P_NU_DOCU_IDEN || ' considera ' ||
                           N_CONT || ' registro(s) en la T_TRABCESA@EMPCES.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_T_TRABCESA_CANCELAR_CESE',P_NU_DOCU_IDEN);
    commit;
  END SP_T_TRABCESA_CANCELAR_CESE;

  PROCEDURE SP_T_JAQN17_TEMPORALES ( ENTREGA_USO CHAR, RECIBE_USD CHAR) IS
    N_CONT NUMBER;    
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
     FROM JAQN17 
    WHERE JAQN17EST<>'T' AND JAQN17FIN<=TRUNC(SYSDATE) AND JAQN17USO=ENTREGA_USO AND JAQN17USD=RECIBE_USD;
  
    IF N_CONT > 0 THEN    
        EXECUTE IMMEDIATE 'create table operador.JAQN17_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from JAQN17 A WHERE A.JAQN17EST<>''T'' AND JAQN17FIN<=TRUNC(SYSDATE) AND ' ||
                        'JAQN17USO='''||ENTREGA_USO||''' AND JAQN17USD='''||RECIBE_USD||'''';
  
        UPDATE JAQN17 
        SET JAQN17EST='T',JAQN17FDV=JAQN17FVT , JAQN17HDV=JAQN17HVT, JAQN17UDV='PROCSER', JAQN17WDV='.'
        WHERE JAQN17EST<>'T' AND JAQN17FIN<=TRUNC(SYSDATE) AND JAQN17USO=ENTREGA_USO AND JAQN17USD=RECIBE_USD;
        commit;
        DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en JAQN17 para JAQN17USO:' || entrega_USO || 'y JAQN17USD:'|| RECIBE_USD);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQN17USO:' || entrega_USO || 'y JAQN17USD:'|| RECIBE_USD||' considera ' ||
                           N_CONT || ' registro(s) en la JAQN17.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_T_JAQN17_TEMPORALES',ENTREGA_USO||'-'||RECIBE_USD);
    commit;
  END;

  PROCEDURE SP_SNGAS2_RETIRA_TEMPORAL_AUTO ( P_SNGAS2USR CHAR, P_SNGAS2COD NUMBER) IS
    N_CONT NUMBER;    
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM SNGAS2 
     WHERE SNGAS2USR = P_SNGAS2USR AND SNGAS2COD = P_SNGAS2COD; 
  
    IF N_CONT > 0 THEN    
        EXECUTE IMMEDIATE 'create table operador.SNGAS2_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from SNGAS2 A WHERE A.SNGAS2USR='''||P_SNGAS2USR||''' AND SNGAS2COD='||P_SNGAS2COD;
  
        DELETE FROM SNGAS2 WHERE SNGAS2USR = P_SNGAS2USR AND SNGAS2COD = P_SNGAS2COD;
        commit;
        DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en SNGAS2 para SNGAS2USR:' || P_SNGAS2USR || 'y SNGAS2COD:'|| P_SNGAS2COD);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El SNGAS2USR:' || P_SNGAS2USR || 'y SNGAS2COD:'|| P_SNGAS2COD||' considera ' ||
                           N_CONT || ' registro(s) en la SNGAS2.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_SNGAS2_RETIRA_TEMPORAL_AUTO',P_SNGAS2USR||'-'||P_SNGAS2COD);
    commit;
  END;

--09/04/2025 nuevos procedimientos
  PROCEDURE SP_UPD_JAQM41_T(P_JAQM41FEF DATE) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQM41 A
     WHERE A.JAQM41EST = 'P'
       AND A.JAQM41FEF <= P_JAQM41FEF;

    IF N_CONT > 0 THEN
      --------TRASLADO TEMPORAL
      EXECUTE IMMEDIATE 'create table operador.JAQM41_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from JAQM41 A WHERE A.JAQM41EST=''P'' AND A.JAQM41FEF<=TO_DATE(''' ||
                        TO_CHAR(P_JAQM41FEF,'DD/MM/YYYY')||''',''DD/MM/YYYY'')';  
      UPDATE JAQM41 A
         SET A.JAQM41EST = 'B'
       WHERE A.JAQM41EST = 'P'
         AND A.JAQM41FEF <= /*TRUNC(SYSDATE-1)*/ P_JAQM41FEF;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en JAQM41 para JAQM41EST=P y JAQM41FEF:' || TO_CHAR(P_JAQM41FEF,'DD/MM/YYYY'));
      insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_UPD_JAQM41_T',to_char(P_JAQM41FEF,'DD/MM/YYYY'));
      commit;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO se actualizaron registro(s) en JAQM41 para JAQM41EST=P y JAQM41FEF:' || TO_CHAR(P_JAQM41FEF,'DD/MM/YYYY'));
    END IF;
  END SP_UPD_JAQM41_T;

  PROCEDURE SP_UPD_JAQM2E_T(P_JAQM2EFEF DATE) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQM2E A
     WHERE A.JAQM2EEST = 'P'
       AND A.JAQM2EFEF <= P_JAQM2EFEF;

    IF N_CONT > 0 THEN
      --------TRASLADO TEMPORAL
      EXECUTE IMMEDIATE 'create table operador.JAQM2E_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from JAQM2E A WHERE A.JAQM2EEST=''P'' AND A.JAQM2EFEF<=TO_DATE(''' ||
                        TO_CHAR(P_JAQM2EFEF,'DD/MM/YYYY')||''',''DD/MM/YYYY'')';    
      UPDATE JAQM2E A
         SET A.JAQM2EEST = 'B'
       WHERE A.JAQM2EEST = 'P'
         AND A.JAQM2EFEF <= /*TRUNC(SYSDATE-1)*/ P_JAQM2EFEF;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en JAQM2E para JAQM2EEST=P y JAQM2EFEF:' || TO_CHAR(P_JAQM2EFEF,'DD/MM/YYYY'));
      insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_UPD_JAQM2E_T',to_char(P_JAQM2EFEF,'DD/MM/RRRR'));
      commit;
    ELSE
      DBMS_OUTPUT.PUT_LINE('NO se actualizaron registro(s) en JAQM2E para JAQM2EEST=P y JAQM2EFEF:' || TO_CHAR(P_JAQM2EFEF,'DD/MM/YYYY'));
    END IF;
  END SP_UPD_JAQM2E_T;

END PQ_GA_JAQL708_ICHANNEL;
/
