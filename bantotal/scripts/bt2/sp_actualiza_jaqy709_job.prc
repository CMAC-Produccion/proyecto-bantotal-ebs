CREATE OR REPLACE PROCEDURE SP_ACTUALIZA_JAQY709_JOB IS
  N_COU710 NUMBER;
  N_COU709 NUMBER;
  N_COU712 number;
  D_FECHA DATE;
BEGIN
  SELECT PGFAPE INTO D_FECHA FROM FST017 WHERE PGCOD = 1;
  BEGIN
    --Verifica proceso 1 (si el proceso ha sido ejecutado debe existir la fecha de proceso) :
    select count(*)
      INTO N_COU710
      from jaqy710
     where jaqy710fpro = d_fecha
     order by jaqy710fpro desc; --PROCESO 1
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
       where jaqy709fpro = d_fecha
       order by jaqy709fpro desc; --Proceso 2
    EXCEPTION
      WHEN OTHERS THEN
        N_COU709 := 0;
    END;

    IF (N_COU709 <> 0) THEN
      BEGIN
        --Verifica proceso 3 (si el proceso ha sido ejecutado debe existir la fecha de proceso):
        select count(*)
          INTO N_COU712
        from jaqy712
        where jaqy712fpro=d_fecha;--Proceso 3
      EXCEPTION
        WHEN OTHERS THEN
          N_COU712 := 0;
      END;

      IF (N_COU712 <> 0) THEN
        begin
          -- Call the procedure
          pq_cr_rep_recuperacion_legal.sp_actualiza_jaqy709_job(pn_pgcod => 1,pd_fecape => d_fecha);
        end;
      ELSE
        sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY712_JOB','FALLO VERIFICACION 3 EN JAQY712 DE RECUPERACION LEGAL'); --ENVIA MAIL
        sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','jflor@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY712_JOB','FALLO VERIFICACION 3 EN JAQY712 DE RECUPERACION LEGAL'); --ENVIA MAIL
        sys.sp_sy_enviamail('bantoem@cajaarequipa.pe','sfernandem@cajaarequipa.pe',sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||'-SP_INSERTA_JAQY712_JOB','FALLO VERIFICACION 3 EN JAQY712 DE RECUPERACION LEGAL'); --ENVIA MAIL
      END IF;
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

