create or replace procedure SP_CR_CARGA_AQPD153_BI is
    -- *****************************************************************
    -- Nombre                       : SP_CR_CARGA_AQPD153_BI
    -- Sistema                      : EBS
    -- Módulo                       : Procedimiento para carga de refinanciados por Job
    -- Versión                      : 1.0
    -- Fecha de Creación            : 2024.04.05
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 
    -- Autor de Modificación        : 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    N_CONT NUMBER(9);
BEGIN
  --1 Verificar la siguiente consulta debe retornar  un valor mayor a cero:
  SELECT COUNT(9)
    INTO N_CONT
    FROM USRREPBI.SYTLORE A 
  WHERE A.C_FEHOIN LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%'
    AND C_MENSAJ = 'OK'
    AND A.C_CODREP  IN ('R143');

  WHILE (N_CONT = 0 AND (TO_CHAR(SYSDATE, 'HH24') BETWEEN 6 AND 12)) LOOP

    DBMS_LOCK.SLEEP(300); --300 SEGUNDOS/5 Minutos
    --1 Verificar la siguiente consulta debe retornar  un valor mayor a cero:
    SELECT COUNT(9)
      INTO N_CONT
      FROM USRREPBI.SYTLORE A 
    WHERE A.C_FEHOIN LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%'
      AND C_MENSAJ = 'OK'
      AND A.C_CODREP  IN ('R143');

  END LOOP;

  IF N_CONT > 0 THEN

    --2 ACTUALIZAR EL ESTADO DE LOS REGISTROS H (HABILITADO) A I (INHABILITADO)
    UPDATE AQPD153
       SET AQPD153ESTCAR = 'I'
     WHERE AQPD153FECCAR = TRUNC(SYSDATE) - 1
       AND AQPD153ESTCAR = 'H';

    --3 APLICAR EL SIGUIENTE SCRIPT SI EL PUNTO 1 RETORNA UN VALOR MAYOR A CERO.

    INSERT INTO AQPD153
    (AQPD153PAIS, AQPD153TIPDOC, AQPD153NUMDOC, AQPD153EMP, AQPD153MOD, AQPD153SUC, AQPD153MDA, AQPD153PAP, 
    AQPD153CTA, AQPD153OPE, AQPD153SBOP, AQPD153TOPE, AQPD153INST, AQPD153MTO, AQPD153SITNEG, AQPD153MTOCAP, 
    AQPD153GRUREP, AQPD153FECCAR, AQPD153HORCAR, AQPD153ESTCAR, AQPD153TIPBEN, AQPD153MEMO
    )
    SELECT 
    AQPD153PAIS, AQPD153TIPDOC, AQPD153NUMDOC, AQPD153EMP, AQPD153MOD, AQPD153SUC, AQPD153MDA, AQPD153PAP, 
    AQPD153CTA, AQPD153OPE, AQPD153SBOP, AQPD153TOPE, AQPD153INST, AQPD153MTO, AQPD153SITNEG, AQPD153MTOCAP, 
    AQPD153GRUREP, AQPD153FECCAR, TO_CHAR(SYSDATE, 'HH24:MM:SS'), AQPD153ESTCAR, UPPER(AQPD153TIPBEN), AQPD153MEMO
    FROM USRBNDJ.AQPD153D;

  END IF;

end SP_CR_CARGA_AQPD153_BI;
/

