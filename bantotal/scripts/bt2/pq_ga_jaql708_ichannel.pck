CREATE OR REPLACE PACKAGE PQ_GA_JAQL708_ICHANNEL IS
  --LUIS CARPIO/ERIKA HIDALGO
  PROCEDURE SP_JAQL708_JAQL708USR(P_JAQL708USR CHAR);
  PROCEDURE SP_JAQL708_JAQL708TLF(P_JAQL708TLF NUMBER);
  PROCEDURE SP_CLIENTES_AFILIADOS_CODIGO_CLIENTE(P_CODIGO_CLIENTE VARCHAR2);
  PROCEDURE SP_CLIENTES_AFILIADOS_CELULAR_CLIENTE(P_CELULAR_CLIENTE VARCHAR2);
  PROCEDURE SP_T_TRABCESA_CANCELAR_CESE(P_NU_DOCU_IDEN VARCHAR2);
  PROCEDURE SP_T_JAQN17_TEMPORALES ( entrega_USO CHAR, recibe_USD CHAR);--RONALD MEZA
  PROCEDURE SP_SNGAS2_RETIRA_TEMPORAL_AUTO ( P_SNGAS2USR CHAR, P_SNGAS2COD NUMBER);--RONALD MEZA
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


  PROCEDURE SP_CLIENTES_AFILIADOS_CELULAR_CLIENTE(P_CELULAR_CLIENTE VARCHAR2) IS                           
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM ICHANNELALERT.CLIENTES_AFILIADOS
     WHERE CELULAR_CLIENTE = P_CELULAR_CLIENTE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.CLIENTES_AFILIADOS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from ICHANNELALERT.CLIENTES_AFILIADOS where CELULAR_CLIENTE=''' || P_CELULAR_CLIENTE||'''';
    
      DELETE FROM ICHANNELALERT.CLIENTES_AFILIADOS
         WHERE CELULAR_CLIENTE = P_CELULAR_CLIENTE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se eliminó ' || N_CONT ||
                           ' registro(s) en ICHANNELALERT.CLIENTES_AFILIADOS para CELULAR_CLIENTE:' ||
                           P_CELULAR_CLIENTE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El CELULAR_CLIENTE:' || P_CELULAR_CLIENTE || ' considera ' ||
                           N_CONT || ' registro(s) en la ICHANNELALERT.CLIENTES_AFILIADOS.' ||
                           CHR(13) || 'No se realizó el Delete.');
    END IF;
  
    insert into AQPB876 values (user,sysdate,'PQ_GA_JAQL708_ICHANNEL.SP_CLIENTES_AFILIADOS_CELULAR_CLIENTE',P_CELULAR_CLIENTE);
    commit;
  END SP_CLIENTES_AFILIADOS_CELULAR_CLIENTE;

 
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
END PQ_GA_JAQL708_ICHANNEL;
/

