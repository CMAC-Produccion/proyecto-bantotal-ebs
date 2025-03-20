CREATE OR REPLACE PROCEDURE "SP_AH_INSERCION_TEMPTRAZA" IS
  -- ***************************************************************************************
  -- Nombre                      : SP_AH_INSERCION_TEMPTRAZA
  -- Sistema                     : BANTOTAL
  -- Módulo                      : Ahorros - Pasivas
  -- Versión                     : 1.0
  -- Fecha de Creación           : 19/04/2023
  -- Autor de Creación           : Tania Apaza
  -- Uso                         : 
  -- Estado                      : Activo
  -- Acceso                      : Público
  -- Parámetros de Entrada       : 
  -- ***
  -- Fecha de Modificación       : 2025.01.17
  -- Modificado                  : CVILLON
  -- Descripción de Modificación : Reporte Multiusuario
  -- ***************************************************************************************
  -- ***************************************************************************************

  ld_FecApe      DATE;
  v_horaActual   VARCHAR2(8);
  v_horaAnterior VARCHAR2(8);
  v_coderr       CHAR(5);
  ld_FecRCC      DATE;
  v_pgcod        NUMBER;
  v_empresa      fsd015.pgcod%TYPE;
  v_sucursal     fsd015.itsuc%TYPE;
  v_modulo       fsd015.itmod%TYPE;
  v_transaccion  fsd015.ittran%TYPE;
  v_relacion     fsd015.itnrel%TYPE;
  v_fechacont    fsd015.itfcon%TYPE;
  v_hora         fsd015.ithora%TYPE;
  v_count        number;
  lv_USRCRM      VARCHAR(10);
BEGIN
  v_pgcod        := 1;
  v_horaActual   := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  v_horaAnterior := TO_CHAR(SYSDATE - INTERVAL '2' HOUR, 'HH24:MI:SS');
  --DBMS_OUTPUT.PUT_LINE('La hora actual es: ' || v_horaActual);
  --DBMS_OUTPUT.PUT_LINE('La hora anterior es: ' || v_horaAnterior);

  ---***
  lv_USRCRM := 'JOBEXPCLI';
  ---***

  SELECT PGFAPE INTO ld_FecApe FROM FST017 WHERE PGCOD = 1;
  ---***
  DELETE FROM JAQY255 WHERE JAQY255CREUSU = lv_USRCRM;
  ---***
  DELETE FROM JAQN74;
  ---***
  SELECT TO_DATE(tpnro, 'DDMMYYYY')
    INTO ld_FecRCC
    FROM Fst098
   WHERE pgcod = 1
     AND Tpcod = 7647
     AND Tpcorr = 12;

  FOR c IN (SELECT Pgcod, Itsuc, Itmod, Ittran, Itnrel, Itfcon, Ithora
              FROM FSD015
             WHERE Itfcon = ld_FecApe
               AND ITSUC not in (901, 902, 903, 904, 905)
               and ithora > v_horaAnterior
               AND ithora <= v_horaActual
               AND itcont = 'S')
  
   LOOP
    v_empresa     := c.Pgcod;
    v_sucursal    := c.Itsuc;
    v_modulo      := c.Itmod;
    v_transaccion := c.Ittran;
    v_relacion    := c.Itnrel;
    v_fechacont   := c.Itfcon;
    v_hora        := c.Ithora;
  
    SELECT COUNT(*)
      INTO v_count
      FROM JAQN73
     WHERE JAQN73EMPR = v_empresa
       AND JAQN73SUCU = v_sucursal
       AND JAQN73MODU = v_modulo
       AND JAQN73TRAN = v_transaccion
       AND JAQN73RELA = v_relacion
       AND JAQN73ITFC = v_fechacont
       AND JAQN73ITHO = v_hora;
  
    IF v_count = 0 THEN
      INSERT INTO JAQN73
        (JAQN73EMPR,
         JAQN73SUCU,
         JAQN73MODU,
         JAQN73TRAN,
         JAQN73RELA,
         JAQN73ITFC,
         JAQN73ITHO)
      VALUES
        (v_empresa,
         v_sucursal,
         v_modulo,
         v_transaccion,
         v_relacion,
         v_fechacont,
         v_hora);
    
      ---***
      SP_AH_INSERCION_JAQY255_DIARIO(ld_FecApe,
                                     v_horaActual,
                                     v_horaAnterior,
                                     ld_FecRCC,
                                     v_empresa,
                                     v_sucursal,
                                     v_modulo,
                                     v_transaccion,
                                     v_relacion,
                                     v_coderr);
    
    END IF;
  END LOOP;
  commit;

  SP_AH_INSERT_REP_DATAUBICACION();
  SP_AH_INSERCION_EXPERIENCIACLIENTE(v_pgcod);
  SP_AH_INSERCION_GESTORPROCESO();

  ---***
exception
  when others then
    dbms_output.put_line(sqlerrm);
    ---*** 

END;
/

