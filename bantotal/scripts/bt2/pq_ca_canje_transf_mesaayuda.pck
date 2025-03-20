CREATE OR REPLACE PACKAGE PQ_CA_CANJE_TRANSF_MESAAYUDA IS
  --LUIS CARPIO/ERIKA HIDALGO
  PROCEDURE SP_CANJE_FLAGPROC_FECHA(P_FLAGPROC CHAR, P_FECHA DATE, P_FLAGDELE CHAR);
  PROCEDURE SP_CANJE_FLAGPROC_FECHA_NUMCHEQUE(P_FLAGPROC CHAR, P_FECHA DATE, P_NUMCHEQUE CHAR);
  PROCEDURE SP_TRANSF_COD_ESTTRANSF_COD_RECH_ID_NUMOPE(P_COD_ESTTRANSF NUMBER, P_COD_RECH VARCHAR2, P_ID_NUMOPE VARCHAR2);
  PROCEDURE SP_TRANSF_COD_ESTTRANSF_ID_NUMOPE(P_COD_ESTTRANSF NUMBER, P_ID_NUMOPE VARCHAR2);
  PROCEDURE SP_TRANSF_FCH_PRES_FLAGDELE_ID_NUMOPE(P_FCH_PRES DATE, P_FLAGDELE NUMBER,P_COD_SESION NUMBER, P_ID_NUMOPE VARCHAR2);
END PQ_CA_CANJE_TRANSF_MESAAYUDA;
/

CREATE OR REPLACE PACKAGE BODY PQ_CA_CANJE_TRANSF_MESAAYUDA is
  --LUIS CARPIO/ERIKA HIDALGO
  PROCEDURE SP_CANJE_FLAGPROC_FECHA(P_FLAGPROC CHAR, P_FECHA DATE, P_FLAGDELE CHAR) IS
    N_CONT NUMBER; 
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM CANJEINTBANPR.CANJE
     WHERE TRUNC(FECHAPROC) = P_FECHA
       AND FLAGDELE = P_FLAGDELE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.CANJE_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from CANJEINTBANPR.CANJE where FLAGDELE='||P_FLAGDELE||' 
                          and TRUNC(FECHAPROC) = to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') || ''',''YYYYMMDD'')';
    
      UPDATE CANJEINTBANPR.CANJE
         SET FLAGPROC = P_FLAGPROC
       WHERE TRUNC(FECHAPROC) = P_FECHA
         AND FLAGDELE = P_FLAGDELE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en CANJEINTBANPR.CANJE para FLAGDELE:'||P_FLAGDELE||' y TRUNC(FECHAPROC):' ||
                           to_char(P_FECHA, 'DD/MM/RRRR'));
    ELSE
      DBMS_OUTPUT.PUT_LINE('El resultado devuelve ' || N_CONT ||
                           ' registro(s) en la CANJEINTBANPR.CANJE.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CA_CANJE_TRANSF_MESAAYUDA.SP_CANJE_FLAGPROC',
       P_FLAGPROC||'-'||to_char(P_FECHA, 'DD/MM/RRRR')||'-'||P_FLAGDELE);
    commit;
  END SP_CANJE_FLAGPROC_FECHA;

  PROCEDURE SP_CANJE_FLAGPROC_FECHA_NUMCHEQUE(P_FLAGPROC CHAR, P_FECHA DATE, P_NUMCHEQUE CHAR) IS
    N_CONT NUMBER; 
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM CANJEINTBANPR.CANJE
     WHERE TRUNC(FECHAPROC) >= P_FECHA
       AND NUMCHEQUE = P_NUMCHEQUE
       AND FLAGPROC='3';
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.CANJE_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from CANJEINTBANPR.CANJE where FLAGPROC=''3'' 
                          and TRUNC(FECHAPROC) >= to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') || ''',''YYYYMMDD'') and NUMCHEQUE = '''||P_NUMCHEQUE||'''';
    
      UPDATE CANJEINTBANPR.CANJE
         SET FLAGPROC = P_FLAGPROC
       WHERE TRUNC(FECHAPROC) >= P_FECHA
         and NUMCHEQUE = P_NUMCHEQUE
         AND FLAGPROC=3;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en CANJEINTBANPR.CANJE para FLAGPROC:3, NUMCHEQUE:'||P_NUMCHEQUE||
                           ' y TRUNC(FECHAPROC)>=' || to_char(P_FECHA, 'DD/MM/RRRR'));
    ELSE
      DBMS_OUTPUT.PUT_LINE('El resultado devuelve ' || N_CONT ||
                           ' registro(s) en la CANJEINTBANPR.CANJE.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CA_CANJE_TRANSF_MESAAYUDA.SP_CANJE_FLAGPROC_FECHA_NUMCHEQUE',
       P_FLAGPROC||'-'||to_char(P_FECHA, 'DD/MM/RRRR')||'-'||P_NUMCHEQUE);
    commit;
  END SP_CANJE_FLAGPROC_FECHA_NUMCHEQUE;

  PROCEDURE SP_TRANSF_COD_ESTTRANSF_COD_RECH_ID_NUMOPE(P_COD_ESTTRANSF NUMBER, P_COD_RECH VARCHAR2, P_ID_NUMOPE VARCHAR2) IS
    N_CONT NUMBER; 
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM TRANSFINTBANPR.TRF_TRANSFERENCIAS
     WHERE ID_NUMOPE=P_ID_NUMOPE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.TRF_TRANSFERENCIAS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from TRANSFINTBANPR.TRF_TRANSFERENCIAS
                          WHERE ID_NUMOPE='''||P_ID_NUMOPE||'''';
    
      UPDATE TRANSFINTBANPR.TRF_TRANSFERENCIAS 
         SET COD_ESTTRANSF = P_COD_ESTTRANSF, COD_RECH=P_COD_RECH
       WHERE ID_NUMOPE=P_ID_NUMOPE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en TRANSFINTBANPR.TRF_TRANSFERENCIAS para ID_NUMOPE=:' ||
                           P_ID_NUMOPE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El resultado devuelve ' || N_CONT ||
                           ' registro(s) en la TRANSFINTBANPR.TRF_TRANSFERENCIAS.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CA_CANJE_TRANSF_MESAAYUDA.SP_TRANSF_COD_ESTTRANSF_COD_RECH_ID_NUMOPE',
       P_COD_ESTTRANSF||'-'||P_COD_RECH||'-'||P_ID_NUMOPE);
    commit;
  END SP_TRANSF_COD_ESTTRANSF_COD_RECH_ID_NUMOPE;

  PROCEDURE SP_TRANSF_COD_ESTTRANSF_ID_NUMOPE(P_COD_ESTTRANSF NUMBER, P_ID_NUMOPE VARCHAR2) IS
    N_CONT NUMBER; 
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM TRANSFINTBANPR.TRF_TRANSFERENCIAS
     WHERE ID_NUMOPE=P_ID_NUMOPE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.TRF_TRANSFERENCIAS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from TRANSFINTBANPR.TRF_TRANSFERENCIAS 
                          WHERE ID_NUMOPE='''||P_ID_NUMOPE||'''';
    
      UPDATE TRANSFINTBANPR.TRF_TRANSFERENCIAS 
         SET COD_ESTTRANSF = P_COD_ESTTRANSF
       WHERE ID_NUMOPE=P_ID_NUMOPE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en TRANSFINTBANPR.TRF_TRANSFERENCIAS para ID_NUMOPE=:' ||
                           P_ID_NUMOPE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El resultado devuelve ' || N_CONT ||
                           ' registro(s) en la TRANSFINTBANPR.TRF_TRANSFERENCIAS.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CA_CANJE_TRANSF_MESAAYUDA.SP_TRANSF_COD_ESTTRANSF_ID_NUMOPE',
       P_COD_ESTTRANSF||'-'||P_ID_NUMOPE);
    commit;
  END SP_TRANSF_COD_ESTTRANSF_ID_NUMOPE;
  
  PROCEDURE SP_TRANSF_FCH_PRES_FLAGDELE_ID_NUMOPE(P_FCH_PRES DATE, P_FLAGDELE NUMBER, P_COD_SESION NUMBER, P_ID_NUMOPE VARCHAR2) IS
    N_CONT NUMBER; 
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM TRANSFINTBANPR.TRF_TRANSFERENCIAS
     WHERE ID_NUMOPE=P_ID_NUMOPE;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.TRF_TRANSFERENCIAS_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from TRANSFINTBANPR.TRF_TRANSFERENCIAS
                          WHERE ID_NUMOPE='''||P_ID_NUMOPE||'''';
    
      UPDATE TRANSFINTBANPR.TRF_TRANSFERENCIAS 
         SET FCH_PRES = P_FCH_PRES, FLAGDELE=P_FLAGDELE, COD_SESION= P_COD_SESION
       WHERE ID_NUMOPE=P_ID_NUMOPE;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en TRANSFINTBANPR.TRF_TRANSFERENCIAS para ID_NUMOPE=:' ||
                           P_ID_NUMOPE);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El resultado devuelve ' || N_CONT ||
                           ' registro(s) en la TRANSFINTBANPR.TRF_TRANSFERENCIAS.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CA_CANJE_TRANSF_MESAAYUDA.SP_TRANSF_FCH_PRES_FLAGDELE_ID_NUMOPE',
       to_char(P_FCH_PRES, 'DD/MM/RRRR')||'-'||P_FLAGDELE||'-'||P_COD_SESION||'-'||P_ID_NUMOPE);
    commit;
  END SP_TRANSF_FCH_PRES_FLAGDELE_ID_NUMOPE;
  
END PQ_CA_CANJE_TRANSF_MESAAYUDA;
/

