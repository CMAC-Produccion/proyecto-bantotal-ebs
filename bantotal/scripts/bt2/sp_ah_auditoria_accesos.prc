CREATE OR REPLACE PROCEDURE "SP_AH_AUDITORIA_ACCESOS" IS
  -- **********************************************************************************
  -- Nombre                     : SP_AH_AUDITORIA_ACCESOS
  -- Sistema                    : SORFY
  -- Módulo                     : Pasivas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2012.05.24
  -- Autor de Creación          : NPALZA
  -- Uso                        : ACCESOS TEMPORALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación: 2012.06.19 NPALZA ->Se añadió el campo AUD_PRFU00_UT.
  -- **********************************************************************************

  cursor c_auditoria is -- Accesos Temporales
    select AUD_NEW_PRFGCOD,
           AUD_NEW_PGCOD,
           AUD_NEW_PRFUUSER,
           AUD_NEW_UBUSER,
           AUD_NEW_PRFUFECALT,
           AUD_NEW_PRFUTPO,
           to_char(AUD_PRFU00_UT,'DD/MM/YYYY HH24:MI:SS') AUD_PRFU00_UT
      from AUD_PRFU00_AUDIT
     where AUD_NEW_PRFGCOD = 'PRF_AUX';

  ln_numcor number(10) := 0; --Numero Correlativo
  lc_nomsuc char(30);        --Nombre de Sucursal


BEGIN

  execute immediate('TRUNCATE TABLE JAQY203');

  for a in c_auditoria loop

    ln_numcor := ln_numcor + 1;

    select b.scnom
      into lc_nomsuc
      from fst046 a,
           fst001 b
     where a.pgcod = b.pgcod
       and a.ubsuc = b.sucurs
       and a.ubuser = a.AUD_NEW_PRFUUSER;

    begin

          insert into JAQY203
            (JAQY203CORRE,
             JAQY203NPRFG,
             JAQY203NPGCO,
             JAQY203NUUSR,
             JAQY203NUBSR,
             JAQY203NFCAL,
             JAQY203NUTPO,
             JAQY203AUXD1,
             JAQY203AUXC1,
             JAQY203AUXC2)
          values
            (ln_numcor,
             a.AUD_NEW_PRFGCOD,
             a.AUD_NEW_PGCOD,
             a.AUD_NEW_PRFUUSER,
             a.AUD_NEW_UBUSER,
             a.AUD_NEW_PRFUFECALT,
             a.AUD_NEW_PRFUTPO,
             trunc(sysdate),
             lc_nomsuc,
             a.AUD_PRFU00_UT);

    exception
      when others then
        rollback;
        return;

    end;

    commit;

  end loop;

end SP_AH_AUDITORIA_ACCESOS;
/

