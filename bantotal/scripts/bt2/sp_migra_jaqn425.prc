create or replace procedure "SP_MIGRA_JAQN425" is
-- *****************************************************************
    -- Nombre                     : SP_Migra_JAQN425
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Bantotal
    -- Versión                    : 1.0
    -- Fecha de Creación          : 06/06/2024
    -- Autor de Creación          : DANNY MANRIQUE CALLATA
    -- Uso                        : Migracion data TEL.TX
    -- Estado                     : Activo
    -- *****************************************************************
  p_c_msgerr VARCHAR2(1000);
  ln_contad number;
begin
  begin
      Insert into JAQN425H 
                  (JAQN425HFPR, 
                  JAQN425HNCO, 
                  JAQN425HCOD, 
                  JAQN425HLOT, 
                  JAQN425HTIP, 
                  JAQN425HP01, 
                  JAQN425HP02, 
                  JAQN425HP03, 
                  JAQN425HP04, 
                  JAQN425HP05, 
                  JAQN425HP06, 
                  JAQN425HP07, 
                  JAQN425HP08, 
                  JAQN425HP09, 
                  JAQN425HP10, 
                  JAQN425HP11, 
                  JAQN425HP12, 
                  JAQN425HP13, 
                  JAQN425HP14
                  )
                  Select JAQN425FPR, 
                          JAQN425NCO, 
                          JAQN425COD, 
                          JAQN425LOT, 
                          JAQN425TIP, 
                          JAQN425P01, 
                          JAQN425P02, 
                          JAQN425P03, 
                          JAQN425P04, 
                          JAQN425P05, 
                          JAQN425P06, 
                          JAQN425P07, 
                          JAQN425P08, 
                          JAQN425P09, 
                          JAQN425P10, 
                          JAQN425P11, 
                          JAQN425P12, 
                          JAQN425P13, 
                          JAQN425P14 from JAQN425 where JAQN425FPR < TRUNC(SYSDATE)-7;
      Commit;
      ln_contad := 1;
      exception
      when others then
         ln_contad := 0;
         p_c_msgerr:='ERROR : ' || sqlerrm;
         sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                     'ERROR en ejecución del procedimiento sp_migra_jaqn425',
                     'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                     sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                     'ERROR en ejecución del procedimiento sp_migra_jaqn425'||CHR(13)||
                     p_c_msgerr);
         sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                     'ERROR en ejecución del procedimiento sp_migra_jaqn425',
                     'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                     sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                     'ERROR en ejecución del procedimiento sp_migra_jaqn425'||CHR(13)||
                     p_c_msgerr);
  end;
  begin
    Delete from JAQN425 where JAQN425FPR < TRUNC(SYSDATE)-7;
    If ln_contad =1 then
       Commit;
    Else
       Rollback;
    End If;
  end;
exception
 when others then

   p_c_msgerr:='ERROR : ' || sqlerrm;
   sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migra_jaqn425',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migra_jaqn425'||CHR(13)||
               p_c_msgerr);
   sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migra_jaqn425',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migra_jaqn425'||CHR(13)||
               p_c_msgerr);
end SP_Migra_JAQN425;
 /* GOLDENGATE_DDL_REPLICATION */
/

