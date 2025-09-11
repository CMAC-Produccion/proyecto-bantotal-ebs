CREATE OR REPLACE PROCEDURE "SP_MIGRAR_JAQL635" AS
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : sp_migrar_jaql635
  -- Sistema               : BANTOTAL
  -- Módulo                : BANTOTAL
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/05/2022
  -- Autor de Creación     : Julio Luna Flores
  -- Uso                   : Enviar monitoreo diario a histórico
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 10/03/2023
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Generación de trama disgregada de monitor en tabla AQPC116
  -- Fecha de Modificación : 18/08/2025
  -- Autor de Modificación : Danny Manrique Callata
  -- Descripción Modific.  : Se añade las transacciones en estado P para que no sean eliminadas
  
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  ln_contad number;
  ln_correl number;
  p_c_msgerr VARCHAR2(1000);
  -- jlunaf 10/03/2023 - INICIO
  ln_AQPC116INDICE15 number;
  ln_AQPC116INDICE16 number;
  ln_AQPC116INDICE17 number;
  ln_AQPC116INDICE19 number;
  ln_AQPC116INDICE50 number;
  -- jlunaf 10/03/2023 - FIN

  cursor c1 is 
  select * from jaql635 where C_AUXVC1 in ('S','P') order by 1 desc;

begin
  --dbms_output.put_line('SP_MIGRAR_JAQL635 1');
  ln_contad := 0;
  For i in c1 loop
	begin
    if ln_contad = 0 then
       ln_correl := i.n_serenv;
    end If;
    
    insert into jaql635H
      (n_serenvh,
       c_canenvh,
       d_fecenvh,
       c_horenvh,
       c_trmenvh,
       c_obsenvh,
       c_auxvc1h,
       c_auxvc2h,
       c_auxvc3h,
       n_auxnu1h,
       n_auxnu2h,
       n_auxnu3h,
       d_auxda1h,
       d_auxda2h,
       d_auxda3h
      )
      values (i.n_serenv,
              i.c_canenv,
              i.d_fecenv,
              i.c_horenv,
              i.c_trmenv,
              i.c_obsenv,
              i.c_auxvc1,
              i.c_auxvc2,
              i.c_auxvc3,
              i.n_auxnu1,
              i.n_auxnu2,
              i.n_auxnu3,
              i.d_auxda1,
              i.d_auxda2,
              i.d_auxda3);
    commit;
    -- jlunaf 10/03/2023 - INICIO - Carga de trama disgregada en tabla AQPC116
    begin
      ln_AQPC116INDICE15 := TO_NUMBER(substr(i.c_trmenv, 64, 14), '99999999999999')/100;
    exception
      when others then
        ln_AQPC116INDICE15 := null;
    end;
    begin
      ln_AQPC116INDICE16 := TO_NUMBER(substr(i.c_trmenv, 78, 14), '99999999999999')/100;
    exception
      when others then
        ln_AQPC116INDICE16 := null;
    end;
    begin
      ln_AQPC116INDICE17 := TO_NUMBER(substr(i.c_trmenv, 92, 14), '99999999999999')/100;
    exception
      when others then
        ln_AQPC116INDICE17 := null;
    end;
    begin
      ln_AQPC116INDICE19 := TO_NUMBER(substr(i.c_trmenv, 120, 11), '99999999999')/1000;
    exception
      when others then
        ln_AQPC116INDICE19 := null;
    end;
    begin
      ln_AQPC116INDICE50 := TO_NUMBER(substr(i.c_trmenv, 442, 14), '99999999999999')/100;
    exception
      when others then
        ln_AQPC116INDICE50 := null;
    end;
    INSERT INTO AQPC116 (AQPC116SERENV, AQPC116CANENV, AQPC116FECENV, AQPC116HORENV,
                         AQPC116INDICE1, AQPC116INDICE2, AQPC116INDICE3, AQPC116INDICE4, AQPC116INDICE5,
                         AQPC116INDICE6, AQPC116INDICE7, AQPC116INDICE8, AQPC116INDICE9, AQPC116INDICE10,
                         AQPC116INDICE11, AQPC116INDICE12, AQPC116INDICE13, AQPC116INDICE14, AQPC116INDICE15,
                         AQPC116INDICE16, AQPC116INDICE17, AQPC116INDICE18, AQPC116INDICE19, AQPC116INDICE20,
                         AQPC116INDICE21, AQPC116INDICE22, AQPC116INDICE23, AQPC116INDICE24, AQPC116INDICE25,
                         AQPC116INDICE26, AQPC116INDICE27, AQPC116INDICE28, AQPC116INDICE29, AQPC116INDICE30,
                         AQPC116INDICE31, AQPC116INDICE32, AQPC116INDICE33, AQPC116INDICE34, AQPC116INDICE35,
                         AQPC116INDICE36, AQPC116INDICE37, AQPC116INDICE38, AQPC116INDICE39, AQPC116INDICE40,
                         AQPC116INDICE41, AQPC116INDICE42, AQPC116INDICE43, AQPC116INDICE44, AQPC116INDICE45,
                         AQPC116INDICE46, AQPC116INDICE47, AQPC116INDICE48, AQPC116INDICE49, AQPC116INDICE50,
                         AQPC116INDICE51, AQPC116INDICE52, AQPC116INDICE53, AQPC116INDICE54, AQPC116INDICE55,
                         AQPC116INDICE56, AQPC116INDICE57, AQPC116INDICE58, AQPC116INDICE59, AQPC116INDICE60,
                         AQPC116INDICE61, AQPC116INDICE62, AQPC116INDICE63, AQPC116INDICE64, AQPC116INDICE65,
                         AQPC116INDICE66, AQPC116INDICE67, AQPC116INDICE68, AQPC116INDICE69, AQPC116INDICE70,
                         AQPC116INDICE71, AQPC116INDICE72, AQPC116INDICE73, AQPC116INDICE74, AQPC116INDICE75,
                         AQPC116INDICE76, AQPC116INDICE77, AQPC116INDICE78, AQPC116INDICE79, AQPC116INDICE80,
                         AQPC116INDICE81, AQPC116INDICE82, AQPC116INDICE83, AQPC116INDICE84, AQPC116INDICE85,
                         AQPC116INDICE86, AQPC116INDICE87, AQPC116INDICE88, AQPC116INDICE89, AQPC116INDICE90,
                         AQPC116INDICE91)
    VALUES (i.n_serenv, i.c_canenv, i.d_fecenv, i.c_horenv, substr(i.c_trmenv, 1, 5),
            substr(i.c_trmenv, 6, 1), substr(i.c_trmenv, 7, 2), substr(i.c_trmenv, 9, 2), substr(i.c_trmenv, 11, 4),
            substr(i.c_trmenv, 15, 2), substr(i.c_trmenv, 17, 2), substr(i.c_trmenv, 19, 5), substr(i.c_trmenv, 24, 10),
            substr(i.c_trmenv, 34, 4), substr(i.c_trmenv, 38, 19), substr(i.c_trmenv, 57, 2), substr(i.c_trmenv, 59, 4),
            substr(i.c_trmenv, 63, 1), ln_AQPC116INDICE15, ln_AQPC116INDICE16, ln_AQPC116INDICE17, substr(i.c_trmenv, 106, 14),
            ln_AQPC116INDICE19, substr(i.c_trmenv, 131, 6), substr(i.c_trmenv, 137, 6), substr(i.c_trmenv, 143, 8),
            substr(i.c_trmenv, 151, 4), substr(i.c_trmenv, 155, 1), substr(i.c_trmenv, 156, 8), substr(i.c_trmenv, 164, 4),
            substr(i.c_trmenv, 168, 3), substr(i.c_trmenv, 171, 3), substr(i.c_trmenv, 174, 3), substr(i.c_trmenv, 177, 4),
            substr(i.c_trmenv, 181, 19), substr(i.c_trmenv, 200, 2), substr(i.c_trmenv, 202, 4), substr(i.c_trmenv, 206, 11),
            substr(i.c_trmenv, 217, 11), substr(i.c_trmenv, 228, 6), substr(i.c_trmenv, 234, 3), substr(i.c_trmenv, 237, 80),
            substr(i.c_trmenv, 317, 3), substr(i.c_trmenv, 320, 8), substr(i.c_trmenv, 328, 15), substr(i.c_trmenv, 343, 25),
            substr(i.c_trmenv, 368, 13), substr(i.c_trmenv, 381, 3), substr(i.c_trmenv, 384, 2), substr(i.c_trmenv, 386, 25),
            substr(i.c_trmenv, 411, 25), substr(i.c_trmenv, 436, 3), substr(i.c_trmenv, 439, 3), ln_AQPC116INDICE50,
            substr(i.c_trmenv, 456, 14), substr(i.c_trmenv, 470, 12), substr(i.c_trmenv, 482, 23), substr(i.c_trmenv, 505, 23),
            substr(i.c_trmenv, 528, 6), substr(i.c_trmenv, 534, 6), substr(i.c_trmenv, 540, 10), substr(i.c_trmenv, 550, 1),
            substr(i.c_trmenv, 551, 1), substr(i.c_trmenv, 552, 12), substr(i.c_trmenv, 564, 12), substr(i.c_trmenv, 576, 6),
            substr(i.c_trmenv, 582, 15), substr(i.c_trmenv, 597, 12), substr(i.c_trmenv, 609, 12), substr(i.c_trmenv, 621, 12),
            substr(i.c_trmenv, 633, 12), substr(i.c_trmenv, 645, 12), substr(i.c_trmenv, 657, 8), substr(i.c_trmenv, 665, 12),
            substr(i.c_trmenv, 677, 35), substr(i.c_trmenv, 712, 35), substr(i.c_trmenv, 747, 12), substr(i.c_trmenv, 759, 12),
            substr(i.c_trmenv, 771, 12), substr(i.c_trmenv, 783, 19), substr(i.c_trmenv, 802, 1), substr(i.c_trmenv, 803, 22),
            substr(i.c_trmenv, 825, 10), substr(i.c_trmenv, 835, 22), substr(i.c_trmenv, 857, 18), substr(i.c_trmenv, 875, 1),
            substr(i.c_trmenv, 876, 15), substr(i.c_trmenv, 891, 9), substr(i.c_trmenv, 900, 9), substr(i.c_trmenv, 909, 1),
            substr(i.c_trmenv, 910, 2), substr(i.c_trmenv, 912, 3), substr(i.c_trmenv, 915, 2), substr(i.c_trmenv, 917, 4),
            substr(i.c_trmenv, 921, 5));
    commit;
    -- jlunaf 10/03/2023 - FIN
    
    ln_contad := ln_contad + 1;
     
    exception
      when others then
        --dbms_output.put_line('ERROR 2 : ' || sqlerrm);
        --dbms_output.put_line('ERROR 2 ln_contad: ' || ln_contad);
        --dbms_output.put_line('ERROR 2 i.n_serenv: ' || i.n_serenv);
        --dbms_output.put_line('ERROR 2 AQPC116INDICE15: ' || TO_NUMBER(substr(i.c_trmenv, 64, 14), '99999999999999')/100);
        --dbms_output.put_line('ERROR 2 AQPC116INDICE16: ' || TO_NUMBER(substr(i.c_trmenv, 78, 14), '99999999999999')/100);
        --dbms_output.put_line('ERROR 2 AQPC116INDICE17: ' || TO_NUMBER(substr(i.c_trmenv, 92, 14), '99999999999999')/100);
        --dbms_output.put_line('ERROR 2 AQPC116INDICE19: ' || TO_NUMBER(substr(i.c_trmenv, 120, 11), '99999999999')/1000);
        --dbms_output.put_line('ERROR 2 AQPC116INDICE50: ' || TO_NUMBER(substr(i.c_trmenv, 442, 14), '99999999999999')/100);
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
   --dbms_output.put_line('SP_MIGRAR_JAQL635 2');
   begin
       delete from jaql635 where n_serenv <= ln_correl;
       commit;
   end;
   --dbms_output.put_line('SP_MIGRAR_JAQL635 3');
exception
 when others then
   --dbms_output.put_line('ERROR 1 : ' || sqlerrm);
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
     
end sp_migrar_jaql635;
 /* GOLDENGATE_DDL_REPLICATION */
/
