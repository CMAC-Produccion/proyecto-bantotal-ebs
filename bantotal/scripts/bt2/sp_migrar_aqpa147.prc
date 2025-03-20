CREATE OR REPLACE PROCEDURE "SP_MIGRAR_AQPA147" AS
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : Procedimiento para el pase a historicos de la tabla aqpa147
  -- Sistema               : BANTOTAL
  -- Módulo                : BANTOTAL
  -- Versión               : 1.0
  -- Fecha de Creación     : 29/12/2023
  -- Autor de Creación     : Hernan Laqui
  -- Uso                   : Enviar notificaciones a histotico
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Modificación : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  ln_contad number;
  ln_correl number;
  p_c_msgerr VARCHAR2(1000);

  cursor c1 is 
  select * from aqpa147 where aqpa147EST IN ('S','E') order by 1 desc;

begin
  --dbms_output.put_line('SP_MIGRAR_JAQL635 1');
  ln_contad := 0;
  For i in c1 loop
	begin
    if ln_contad = 0 then
       ln_correl := i.aqpa147COR;
    end If;
    
    insert into aqpa147H 
    (aqpa147HCOR, aqpa147HFEC, aqpa147HHOR, aqpa147HMED, aqpa147HORI, 
     aqpa147HMSG, aqpa147HDES, aqpa147HCTA, aqpa147HPAI, aqpa147HTPO, 
     aqpa147HNUM, aqpa147HMON, aqpa147HTOP, aqpa147HNOP, aqpa147HEST, 
     aqpa147HFPR, aqpa147HHPR, aqpa147HRPT)
    values (

     i.aqpa147COR, i.aqpa147FEC, i.aqpa147HOR, i.aqpa147MED, i.aqpa147ORI, 
     i.aqpa147MSG, i.aqpa147DES, i.aqpa147CTA, i.aqpa147PAI, i.aqpa147TPO, 
     i.aqpa147NUM, i.aqpa147MON, i.aqpa147TOP, i.aqpa147NOP, i.aqpa147EST, 
     i.aqpa147FPR, i.aqpa147HPR, i.aqpa147RPT);

    commit;
    ln_contad := ln_contad + 1;
     
    exception
      when others then        
        p_c_msgerr:='ERROR : ' || sqlerrm;
        sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migrar_jaql635',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migrar_jaql635'||CHR(13)||
               p_c_msgerr);
        sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migrar_jaql635',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migrar_jaql635'||CHR(13)||
               p_c_msgerr);
   End;
   end loop;

   begin
       delete from aqpa147 where aqpa147EST IN ('S','E') and aqpa147COR <= ln_correl;
       commit;
   end;

exception
 when others then
   --dbms_output.put_line('ERROR 1 : ' || sqlerrm);
   p_c_msgerr:='ERROR : ' || sqlerrm;
   sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migrar_aqpa147',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migrar_aqpa147'||CHR(13)||
               p_c_msgerr);
   sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
               'ERROR en ejecución del procedimiento sp_migrar_aqpa147',
               'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
               sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
               'ERROR en ejecución del procedimiento sp_migrar_aqpa147'||CHR(13)||
               p_c_msgerr);
     
end sp_migrar_aqpa147;
 /* GOLDENGATE_DDL_REPLICATION */
/

