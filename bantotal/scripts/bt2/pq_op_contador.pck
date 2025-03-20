create or replace package PQ_OP_CONTADOR is

  -- Author  : MLOPEZR
  -- Created : 15/07/2014 06:42:13 p.m.
  -- Purpose : CONTADOR DE TRANSACCIONES

  -- Public function and procedure declarations
  PROCEDURE SP_CONTADOR_OPERACIONES(P_ituing in CHAR,
                                    P_ttran  out NUMBER,
                                    P_ttrat  out NUMBER,
                                    P_achor  out CHAR);

  PROCEDURE SP_LIMPIA_CONTADOR;

  PROCEDURE SP_OPERADORES_CONTAR(P_CUR_JAQL670 OUT SYS_REFCURSOR);

  PROCEDURE SP_ACTUALIZA_CONTADOR(P_ituing in CHAR,
                                  P_pgsuc  in NUMBER,
                                  P_pgfape in DATE,
                                  P_ithora in CHAR,
                                  P_ttran  in NUMBER,
                                  P_ttrat  in NUMBER,
                                  P_achor  in CHAR,
                                  P_factc  in NUMBER);

  procedure SP_OBTIENE_DIARIAS(P_ituing     in CHAR,
                               P_ithora     in CHAR,
                               P_pgsuc      OUT NUMBER,
                               P_pgfape     OUT DATE,
                               P_CUR_FSD015 OUT SYS_REFCURSOR,
                               P_CUR_FSD016 OUT SYS_REFCURSOR,
                               P_CUR_FSD011 OUT SYS_REFCURSOR,
                               P_CUR_Z0E483 OUT SYS_REFCURSOR,
                               P_CUR_JAQL420 OUT SYS_REFCURSOR); --20140923 mlopezr
end PQ_OP_CONTADOR;
/

create or replace package body PQ_OP_CONTADOR is

  PROCEDURE SP_CONTADOR_OPERACIONES(P_ituing in CHAR,
                                    P_ttran  out NUMBER,
                                    P_ttrat  out NUMBER,
                                    P_achor  out CHAR) is
  
    l_achor CHAR(8);
  BEGIN
    P_ttran := 0;
    P_ttrat := 0;
    l_achor := '00:00:00';
    P_achor := l_achor;
  
    BEGIN
      SELECT jaql670ttran, ROUND(jaql670ttrat / jaql670factc), jaql670achor
        INTO P_ttran, P_ttrat, P_achor
        FROM jaql670
       WHERE jaql670ituing = P_ituing;
    EXCEPTION
      WHEN no_data_found THEN
        INSERT INTO jaql670
          (jaql670ituing,
           jaql670pgsuc,
           jaql670itfcon,
           jaql670ithora,
           jaql670ttran,
           jaql670ttrat,
           jaql670achor,
           jaql670factc)
        VALUES
          (P_ituing,
           0,
           to_date('01/01/0001', 'dd/MM/yyyy'),
           l_achor,
           P_ttran,
           P_ttrat,
           l_achor,
           1);
        COMMIT;
    END;
  end;

  PROCEDURE SP_ACTUALIZA_CONTADOR(P_ituing in CHAR,
                                  P_pgsuc  in NUMBER,
                                  P_pgfape in DATE,
                                  P_ithora in CHAR,
                                  P_ttran  in NUMBER,
                                  P_ttrat  in NUMBER,
                                  P_achor  in CHAR,
                                  P_factc  in NUMBER) is
    l_pgfape DATE;
  BEGIN
    BEGIN
      SELECT jaql670Itfcon
        INTO l_pgfape
        FROM jaql670
       WHERE jaql670ituing = P_ituing;
    EXCEPTION
      WHEN no_data_found THEN
        RETURN;
    END;
    IF l_pgfape = P_pgfape THEN
      UPDATE jaql670
         SET jaql670Pgsuc  = P_pgsuc,
             jaql670Itfcon = P_pgfape,
             jaql670Ithora = NVL2(P_ithora, P_ithora, jaql670Ithora),
             jaql670ttran  = jaql670ttran + P_ttran,
             jaql670ttrat  = jaql670ttrat + P_ttrat,
             jaql670achor  = P_achor,
             jaql670factc  = P_factc
       WHERE jaql670ituing = P_ituing;
    ELSE
      UPDATE jaql670
         SET jaql670Pgsuc  = P_pgsuc,
             jaql670Itfcon = P_pgfape,
             jaql670Ithora = NVL2(P_ithora, P_ithora, jaql670Ithora),
             jaql670ttran  = P_ttran,
             jaql670ttrat  = P_ttrat,
             jaql670achor  = P_achor,
             jaql670factc  = P_factc
       WHERE jaql670ituing = P_ituing;
    END IF;
    COMMIT;
  END;

  PROCEDURE SP_LIMPIA_CONTADOR is
  BEGIN
  
    INSERT INTO JAQL675(jaql675ituing, jaql675itfcon, jaql675pgsuc, jaql675ithora, jaql675ttran, jaql675ttrat, jaql675achor, jaql675factc)
    SELECT jaql670ituing, jaql670itfcon, jaql670pgsuc, jaql670ithora, jaql670ttran, jaql670ttrat, jaql670achor, jaql670factc 
    FROM JAQL670 WHERE jaql670itfcon <> TO_DATE('01/01/0001', 'dd/mm/yyyy') AND (jaql670ituing, jaql670itfcon) NOT IN
    (SELECT jaql675ituing, jaql675itfcon FROM JAQL675);

    DELETE FROM jaql670;
    COMMIT;
  END;

  PROCEDURE SP_OPERADORES_CONTAR(P_CUR_JAQL670 OUT SYS_REFCURSOR) IS
  
  BEGIN
    OPEN P_CUR_JAQL670 FOR
      SELECT jaql670ituing, jaql670ithora FROM JAQL670;
  END;

  procedure SP_OBTIENE_DIARIAS(P_ituing     in CHAR,
                               P_ithora     in CHAR,
                               P_pgsuc      OUT NUMBER,
                               P_pgfape     OUT DATE,
                               P_CUR_FSD015 OUT SYS_REFCURSOR,
                               P_CUR_FSD016 OUT SYS_REFCURSOR,
                               P_CUR_FSD011 OUT SYS_REFCURSOR,
                               P_CUR_Z0E483 OUT SYS_REFCURSOR,
                               P_CUR_JAQL420 OUT SYS_REFCURSOR) is
    l_pgcod  NUMBER(3);
    l_pgfape DATE;
  begin
    l_pgcod := 1;
    SELECT Ubsuc
      INTO P_pgsuc
      FROM FST046
     WHERE Pgcod = l_pgcod
       AND Ubuser = P_ituing;
    SELECT pgfape INTO l_pgfape FROM fst017 WHERE Pgcod = l_pgcod;
    P_pgfape := l_pgfape;
  
    OPEN P_CUR_FSD015 FOR
      SELECT *
        FROM fsd015
       WHERE Pgcod = l_pgcod
         AND Itsuc = P_pgsuc
         AND itfcon = l_pgfape
         AND (ituing = P_ituing OR ITUCNF = P_ituing)
         AND itcont = 'S'
         AND Ithora > P_ithora
       order by Ithora;
  
    OPEN P_CUR_FSD016 FOR
      SELECT D.*
        FROM Fsd015 C, Fsd016 D
       WHERE C.Pgcod = D.Pgcod
         and C.itsuc = D.itsuc
         and C.itmod = D.itmod
         AND C.ittran = D.ittran
         and C.itnrel = D.itnrel
         AND C.Pgcod = l_pgcod
         AND C.Itsuc = P_pgsuc
         AND C.itfcon = l_pgfape
         AND (C.ituing = P_ituing OR C.ITUCNF = P_ituing)
         and C.itcont = 'S'
         AND C.Ithora > P_ithora;
  
    OPEN P_CUR_FSD011 FOR
      select u.cv1aux6 as ituing, cm.ithora
        from fsd011 c, FSE113 u, FSD016 d, fsd015 cm
       where d.pgcod = cm.pgcod
         and d.itsuc = cm.itsuc
         and d.itmod = cm.itmod
         and d.ittran = cm.ittran
         and d.itnrel = cm.itnrel
         and u.pgcod = c.pgcod
         and u.cv1suc = c.scsuc
         and u.cv1mod = c.scmod
         and u.cv1mda = c.scmda
         and u.cv1pap = c.scpap
         and u.cv1cta = c.sccta
         and u.cv1oper = c.scoper
         and u.cv1sbop = c.scsbop
         and u.cv1tope = c.sctope
         and c.scfcon = cm.itfcon
         and c.pgcod = d.pgcod
         and c.scsuc = d.itsucd
         and c.scrub = d.rubro
         and c.scmda = d.moneda
         and c.scpap = d.papel
         and c.sccta = d.ctnro
         and c.scoper = d.itoper
         and c.scsbop = d.itsubo
         and c.sctope = d.ittope
         and c.scmod = d.modulo
         and cm.pgcod = l_pgcod
         and cm.itsuc = P_pgsuc
         and cm.itmod = 50
         and cm.ittran = 501
            --         and cm.itcont = 'S'
         and cm.ithora > P_ithora
         and c.pgcod = l_pgcod
         and c.scmod = 21
         and c.scfcon = l_pgfape
         and c.scfcon = c.scfval
         and d.itord in (10, 12)
         and u.cv1aux6 = P_ituing
       order by cm.ithora;
  
    OPEN P_CUR_Z0E483 FOR
    -- select * from ( --borrar
      select z0e483umd as ituing, z0e483hor as ithora
        from z0e483
       where z0e483fch = l_pgfape --uncomment
         and z0e468cod <> 'J'
         and z0e483tnv = 'INS'
         and z0e483umd = P_ituing --uncomment
         and z0e483hor > P_ithora --almacenar la hora mayor
       order by z0e483hor; --uncomment
    -- ) WHERE rownum < 5; --borrar
    
    OPEN P_CUR_JAQL420 FOR
      select jaql420usr as ituing, jaql420hrc as ithora 
        from jaql420 
      where jaql420emp = l_pgcod
        and jaql420usr = P_ituing --uncomment
        and jaql420fcr = l_pgfape 
        and jaql420hrc > P_ithora --almacenar la hora mayor
      order by jaql420hrc; --uncomment  
  end;

end PQ_OP_CONTADOR;
/

