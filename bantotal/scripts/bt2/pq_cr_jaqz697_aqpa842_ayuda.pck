CREATE OR REPLACE PACKAGE PQ_CR_JAQZ697_AQPA842_AYUDA IS
  --LUIS CARPIO/ERIKA HIDALGO

  -- *****************************************************************
  -- Nombre                     : PQ_CR_JAQZ697_AQPA842_AYUDA
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : Creditos - Activas
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 18.12.2020
  -- Autor de Creaci¿n          : --LUIS CARPIO/ERIKA HIDALGO
  -- Uso                        : Realiza Actualizaciones
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificación      : 2025.01.20
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se modifico en el procedimiento SP_HABILITA_CAMPANA para que considere el au5 original de la oferta y demas
  --                              condiciones
  -- Fecha de Modificación      : 2025.10.22
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se modifico en el procedimiento SP_ASESOR para que considere el au5 desde una guia de procesos                         
  -- *****************************************************************

  PROCEDURE SP_MONTO_PLAZO(P_JAQZ697COR NUMBER,
                           P_FECHA      DATE,
                           P_JAQZ697MTO number,
                           --                           P_JAQZ697PZO number);
                           P_JAQZ697CUO NUMBER);

  /*PROCEDURE SP_JAQZ697AU5(P_JAQZ697PAI NUMBER,
  P_JAQZ697TDO NUMBER,
  P_JAQZ697NDO CHAR,
  P_FECHA      DATE);*/

  PROCEDURE SP_ASESOR(P_JAQZ697ASE_OLD CHAR,
                      P_JAQZ697ASE_NEW CHAR,
                      P_FECHA          DATE,
                      P_CTA            NUMBER);

  PROCEDURE SP_HABILITA_CAMPANA(P_JAQZ697PAI NUMBER,
                                P_JAQZ697TDO NUMBER,
                                P_JAQZ697NDO CHAR,
                                P_FECHA      DATE,
                                P_JAQZ697AU5 CHAR);
  PROCEDURE SP_CR_ELIMINA_NOVACION(CTA NUMBER, OPER NUMBER);

  PROCEDURE SP_CR_UPD_SUBOPE_NOVACION(CTA        NUMBER,
                                      OPER       NUMBER,
                                      SUBOPE_ORI NUMBER,
                                      SUBOPE_NEW NUMBER);

  PROCEDURE SP_APROB_GERENTE(V_JAQZ697COR NUMBER, V_JAQZ697FEP date);

END PQ_CR_JAQZ697_AQPA842_AYUDA;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_JAQZ697_AQPA842_AYUDA is
  --LUIS CARPIO/ERIKA HIDALGO
  PROCEDURE SP_MONTO_PLAZO(P_JAQZ697COR NUMBER,
                           P_FECHA      DATE,
                           P_JAQZ697MTO NUMBER,
                           --                           P_JAQZ697PZO NUMBER) IS
                           P_JAQZ697CUO NUMBER) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697COR = P_JAQZ697COR
       AND JAQZ697FEP = P_FECHA;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 where JAQZ697COR=' ||
                        P_JAQZ697COR || ' and jaqz697fep = to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') || ''',''YYYYMMDD'')';
    
      UPDATE JAQZ697
      --         SET JAQZ697MTO = P_JAQZ697MTO, JAQZ697PZO = P_JAQZ697PZO
         SET JAQZ697MTO = P_JAQZ697MTO, JAQZ697CUO = P_JAQZ697CUO --18.12.2020
       WHERE JAQZ697COR = P_JAQZ697COR
         AND JAQZ697FEP = P_FECHA;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en jaqz697 para JAQZ697COR:' ||
                           P_JAQZ697COR || ' y JAQZ697FEP:' || P_FECHA);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQZ697COR:' || P_JAQZ697COR ||
                           ' y JAQZ697FEP:' || P_FECHA || ' considera ' ||
                           N_CONT || ' registro(s) en la JAQZ697.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_MONTO_PLAZO',
       P_JAQZ697COR || '-' || to_char(P_FECHA, 'DD/MM/RRRR') || '-' ||
       P_JAQZ697MTO || '-' || P_JAQZ697CUO);
    commit;
  END SP_MONTO_PLAZO;

  /*PROCEDURE SP_JAQZ697AU5(P_JAQZ697PAI NUMBER,
                          P_JAQZ697TDO NUMBER,
                          P_JAQZ697NDO CHAR,
                          P_FECHA      DATE) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697PAI = P_JAQZ697PAI
       AND JAQZ697TDO = P_JAQZ697TDO
       AND JAQZ697NDO = P_JAQZ697NDO
       AND JAQZ697FEP = P_FECHA;
  
    IF N_CONT = 1 THEN
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 where JAQZ697PAI=' ||
                        P_JAQZ697PAI || ' AND JAQZ697TDO=' || P_JAQZ697TDO ||
                        'AND JAQZ697NDO=' || P_JAQZ697NDO ||
                        ' and jaqz697fep = to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') || ''',''YYYYMMDD'')';
    
      UPDATE JAQZ697
         SET JAQZ697AU5 = 'N'
       WHERE JAQZ697PAI = P_JAQZ697PAI
         AND JAQZ697TDO = P_JAQZ697TDO
         AND JAQZ697NDO = P_JAQZ697NDO
         AND JAQZ697FEP = P_FECHA; -- 1 REGISTRO
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se actualizó 1 registro en jaqz697 para JAQZ697PAI:' ||
                           P_JAQZ697PAI || ', JAQZ697TDO:' || P_JAQZ697TDO ||
                           ', JAQZ697NDO:' || P_JAQZ697NDO ||
                           ' y JAQZ697FEP:' || P_FECHA);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQZ697PAI:' || P_JAQZ697PAI ||
                           ', JAQZ697TDO:' || P_JAQZ697TDO ||
                           ', JAQZ697NDO:' || P_JAQZ697NDO ||
                           ' y JAQZ697FEP:' || P_FECHA || ' considera ' ||
                           N_CONT || ' registro(s) en la JAQZ697.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  END SP_JAQZ697AU5;*/

  PROCEDURE SP_ASESOR(P_JAQZ697ASE_OLD CHAR,
                      P_JAQZ697ASE_NEW CHAR,
                      P_FECHA          DATE,
                      P_CTA            NUMBER) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697ASE = P_JAQZ697ASE_OLD
       AND JAQZ697FEP = P_FECHA
       AND JAQZ697AU5 IN (select trim(f.tp1desc)
                            from fst198 f
                           where f.tp1cod = 1
                             and f.tp1cod1 = 10899
                             and f.tp1corr1 = 154
                             and f.tp1corr3 > 0)
       AND JAQZ697CTA = P_CTA; --26.04.2021
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 where jaqz697ase=''' ||
                        P_JAQZ697ASE_OLD ||
                        ''' and jaqz697fep = to_date(''' ||
                        TO_CHAR(P_FECHA, 'YYYYMMDD') ||
                        ''',''YYYYMMDD'') AND jaqz697au5 in(''N'',''F'') and JAQZ697CTA=' ||
                        P_CTA; --26.04.2021
    
      UPDATE JAQZ697
         SET JAQZ697ASE = P_JAQZ697ASE_NEW
       WHERE JAQZ697ASE = P_JAQZ697ASE_OLD
         AND JAQZ697FEP = P_FECHA
         AND JAQZ697AU5 IN (select trim(f.tp1desc)
                              from fst198 f
                             where f.tp1cod = 1
                               and f.tp1cod1 = 10899
                               and f.tp1corr1 = 154
                               and f.tp1corr3 > 0)
         AND JAQZ697CTA = P_CTA; --26.04.2021
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se ACTUALIZÓ ' || N_CONT ||
                           ' registro(s) en jaqz697 para jaqz697ase:' ||
                           P_JAQZ697ASE_OLD || ',  JAQZ697FEP:' || P_FECHA ||
                           ' y JAQZ697CTA:' || P_CTA); --26.04.2021
    ELSE
      DBMS_OUTPUT.PUT_LINE('El jaqz697ase:' || P_JAQZ697ASE_OLD ||
                           ', JAQZ697FEP:' || P_FECHA || ' y JAQZ697CTA:' ||
                           P_CTA || --26.04.2021
                           ' considera ' || N_CONT ||
                           ' registro(s) en la JAQZ697.' || CHR(13) ||
                           'No se realizó el UPDATE.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_ASESOR',
       P_JAQZ697ASE_OLD || '-' || P_JAQZ697ASE_NEW || '-' ||
       to_char(P_FECHA, 'DD/MM/RRRR') || '-' || P_CTA);
    commit;
  
  END SP_ASESOR;

  PROCEDURE SP_HABILITA_CAMPANA(P_JAQZ697PAI NUMBER,
                                P_JAQZ697TDO NUMBER,
                                P_JAQZ697NDO CHAR,
                                --                                P_FECHA      DATE) IS
                                P_FECHA      DATE,
                                P_JAQZ697AU5 CHAR) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697FEP = (select max(j.jaqz697fep) from jaqz697 j)
       AND JAQZ697PAI = P_JAQZ697PAI
       AND JAQZ697TDO = P_JAQZ697TDO
       AND JAQZ697NDO = P_JAQZ697NDO
       AND JAQZ697AU5 <> 'H'; --29.11 indicado por Cinthya Liz Hernandez 
  
    IF (P_JAQZ697AU5 IN ('N', 'F')) THEN
      IF N_CONT > 0 THEN
      
        EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                          TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) ||
                          ' as select * from jaqz697 where JAQZ697PAI=' ||
                          P_JAQZ697PAI || ' and JAQZ697TDO=' ||
                          P_JAQZ697TDO || ' and JAQZ697NDO=' ||
                          P_JAQZ697NDO || ' and jaqz697fep = to_date(''' ||
                          TO_CHAR(P_FECHA, 'YYYYMMDD') ||
                          ''',''YYYYMMDD'')';
      
        UPDATE JAQZ697 j
        --           SET JAQZ697AU5 = 'N', JAQZ697FAN = NULL
           SET JAQZ697AU5   = j.jaqz697est,
               JAQZ697FAN   = NULL,
               J.JAQZ697MTO = J.JAQZ697MON,
               J.JAQZ697CUO = J.JAQZ697NCU
         WHERE JAQZ697FEP = (select max(j.jaqz697fep) from jaqz697 j)
           AND JAQZ697PAI = P_JAQZ697PAI
           AND JAQZ697TDO = P_JAQZ697TDO
           AND JAQZ697NDO = P_JAQZ697NDO
           AND JAQZ697AU5 <> 'H'; --29.11 indicado por Cinthya Liz Hernandez 
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se ACTUALIZÓ ' || N_CONT ||
                             ' registro(s) en jaqz697 para JAQZ697PAI:' ||
                             P_JAQZ697PAI || ', JAQZ697TDO:' ||
                             P_JAQZ697TDO || ', JAQZ697NDO:' ||
                             P_JAQZ697NDO || ' y JAQZ697FEP:' || P_FECHA);
      ELSE
        DBMS_OUTPUT.PUT_LINE('El JAQZ697PAI:' || P_JAQZ697PAI ||
                             ', JAQZ697TDO:' || P_JAQZ697TDO ||
                             ', JAQZ697NDO:' || P_JAQZ697NDO ||
                             ' y JAQZ697FEP:' || P_FECHA || ' considera ' ||
                             N_CONT || ' registro(s) en la JAQZ697.' ||
                             CHR(13) || 'No se realizó el UPDATE.');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('El valor ingresado para el nuevo P_JAQZ697AU5 no es ni N ni F');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_HABILITA_CAMPANA',
       P_JAQZ697PAI || '-' || P_JAQZ697TDO || '-' || P_JAQZ697NDO || '-' ||
       to_char(P_FECHA, 'DD/MM/RRRR') || '-' || P_JAQZ697AU5);
    commit;
  
  END SP_HABILITA_CAMPANA;

  PROCEDURE SP_CR_ELIMINA_NOVACION(CTA NUMBER, OPER NUMBER) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM AQPA842
     WHERE AQPA842EMP = 1
       AND AQPA842CTA = CTA
       AND AQPA842OPE = OPER;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.aqpa842_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from aqpa842 where aqpa842emp = 1 and aqpa842cta=' || CTA ||
                        'AND aqpa842ope=' || OPER;
    
      DELETE AQPA842
       WHERE AQPA842EMP = 1
         AND AQPA842CTA = CTA
         AND AQPA842OPE = OPER;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se ELIMINÓ ' || N_CONT ||
                           ' registro(s) de aqpa842 para aqpa842cta:' || CTA ||
                           ' y aqpa842ope:' || OPER);
    ELSE
      DBMS_OUTPUT.PUT_LINE('La aqpa842cta:' || CTA || ' y aqpa842ope:' || OPER ||
                           ' considera ' || N_CONT ||
                           ' registro(s) en aqpa842' || CHR(13) ||
                           'No se realizó el DELETE.');
    END IF;
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_CR_ELIMINA_NOVACION',
       CTA || '-' || OPER);
    commit;
  END SP_CR_ELIMINA_NOVACION;

  PROCEDURE SP_CR_UPD_SUBOPE_NOVACION(CTA        NUMBER,
                                      OPER       NUMBER,
                                      SUBOPE_ORI NUMBER,
                                      SUBOPE_NEW NUMBER) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM AQPA842
     WHERE AQPA842EMP = 1
       AND AQPA842CTA = CTA
       AND AQPA842OPE = OPER
       AND AQPA842SBO = SUBOPE_ORI;
  
    IF N_CONT = 1 THEN
    
      EXECUTE IMMEDIATE 'create table operador.aqpa842_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from aqpa842 where aqpa842emp = 1 and aqpa842cta=' || CTA ||
                        'AND aqpa842ope=' || OPER || 'AND AQPA842SBO=' ||
                        SUBOPE_ORI;
    
      UPDATE AQPA842
         SET AQPA842SBO = SUBOPE_NEW
       WHERE AQPA842EMP = 1
         AND AQPA842CTA = CTA
         AND AQPA842OPE = OPER
         AND AQPA842SBO = SUBOPE_ORI;
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('Se ACTUALIZÓ ' || N_CONT ||
                           ' registro(s) de aqpa842 para aqpa842cta:' || CTA ||
                           ' , aqpa842ope:' || OPER || ' Y AQPA842SBO:' ||
                           SUBOPE_ORI);
    ELSE
      DBMS_OUTPUT.PUT_LINE('La aqpa842cta:' || CTA || ', aqpa842ope:' || OPER ||
                           ' Y AQPA842SBO:' || SUBOPE_ORI || ' considera ' ||
                           N_CONT || ' registro(s) en aqpa842' || CHR(13) ||
                           'No se realizó el UPDATE.');
    END IF;
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_CR_UPD_SUBOPE_NOVACION',
       CTA || '-' || OPER || '-' || SUBOPE_ORI || '-' || SUBOPE_NEW);
    commit;
  END SP_CR_UPD_SUBOPE_NOVACION;

  PROCEDURE SP_APROB_GERENTE(V_JAQZ697COR NUMBER, V_JAQZ697FEP DATE) IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM JAQZ697
     WHERE JAQZ697COR = V_JAQZ697COR
       AND JAQZ697FEP = V_JAQZ697FEP;
  
    IF N_CONT > 0 THEN
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 where JAQZ697COR=' ||
                        V_JAQZ697COR || ' and jaqz697fep = to_date(''' ||
                        TO_CHAR(V_JAQZ697FEP, 'YYYYMMDD') ||
                        ''',''YYYYMMDD'')';
    
      UPDATE JAQZ697
         SET JAQZ697APR = 'N' --27.01.2022
       WHERE JAQZ697COR = V_JAQZ697COR
         AND JAQZ697FEP = V_JAQZ697FEP;
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                           ' registro(s) en jaqz697 para JAQZ697COR:' ||
                           V_JAQZ697COR || ' y JAQZ697FEP:' ||
                           V_JAQZ697FEP);
    ELSE
      DBMS_OUTPUT.PUT_LINE('El JAQZ697COR:' || V_JAQZ697COR ||
                           ' y JAQZ697FEP:' || V_JAQZ697FEP ||
                           ' considera ' || N_CONT ||
                           ' registro(s) en la JAQZ697.' || CHR(13) ||
                           'No se realizó el Update.');
    END IF;
  
    insert into AQPB876
    values
      (user,
       sysdate,
       'PQ_CR_JAQZ697_AQPA842_AYUDA.SP_APROB_GERENTE',
       V_JAQZ697COR || '-' || to_char(V_JAQZ697FEP, 'DD/MM/RRRR'));
    commit;
  END SP_APROB_GERENTE;

END PQ_CR_JAQZ697_AQPA842_AYUDA;
/
