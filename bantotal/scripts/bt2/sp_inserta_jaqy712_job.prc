CREATE OR REPLACE PROCEDURE SP_INSERTA_JAQY712_JOB IS
  N_COU710 NUMBER;
  N_COU709 NUMBER;
  N_COU712 NUMBER;
  D_FECHA DATE;
BEGIN
  SELECT PGFAPE INTO D_FECHA FROM FST017 WHERE PGCOD = 1;
  BEGIN
    --Verifica proceso 1 (si el proceso ha sido ejecutado debe existir la fecha de proceso) :
    select count(*)
      INTO N_COU710
      from jaqy710
     where jaqy710fpro = d_fecha; --PROCESO 1
  EXCEPTION
    WHEN OTHERS THEN
      N_COU710 := 0;
  END;

  IF (N_COU710 <> 0) THEN
    BEGIN
      --Verifica proceso 2 (si el proceso ha sido ejecutado debe existir la fecha de proceso):
      select count(*)
        INTO N_COU709
        from jaqy709
       where jaqy709fpro = d_fecha; --Proceso 2
    EXCEPTION
      WHEN OTHERS THEN
        N_COU709 := 0;
    END;

    IF (N_COU709 <> 0) THEN
      BEGIN
        -- CALL THE PROCEDURE
        PQ_CR_REP_RECUPERACION_LEGAL.SP_INSERTA_JAQY712_JOB(PN_PGCOD  => 1, PD_FECAPE => D_FECHA);
      END;
    ELSE
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY709_JOB','FALLO VERIFICACION 2 EN JAQY709 DE RECUPERACION LEGAL'); --ENVIA MAIL
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','jflor@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY709_JOB','FALLO VERIFICACION 2 EN JAQY709 DE RECUPERACION LEGAL'); --ENVIA MAIL
      sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','sfernandem@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY709_JOB','FALLO VERIFICACION 2 EN JAQY709 DE RECUPERACION LEGAL'); --ENVIA MAIL
    END IF;
  ELSE
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY710_JOB','FALLO VERIFICACION 1 EN JAQY710 DE RECUPERACION LEGAL'); --ENVIA MAIL
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','jflor@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY710_JOB','FALLO VERIFICACION 1 EN JAQY710 DE RECUPERACION LEGAL'); --ENVIA MAIL
    sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','sfernandem@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY710_JOB','FALLO VERIFICACION 1 EN JAQY710 DE RECUPERACION LEGAL'); --ENVIA MAIL
  END IF;
END;
/

