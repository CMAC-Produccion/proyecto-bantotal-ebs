create or replace package pq_cr_fac_electronica is

  -- Author  : CCERPA
  -- Created : 16/02/2018 09:50:23 a.m.
  -- Purpose :

Procedure SP_CR_renderizacion_pdf ( lv_nombre in varchar );

end pq_cr_fac_electronica;
/

create or replace package body pq_cr_fac_electronica is
  -- *****************************************************************
  -- Nombre                     : sp_resultadonetolinea
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : EVALUA EL OTORGAMIENTO DEUN CREDITO HIPOTECARIO cAJA.
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************

-------------------------------------------------------------------------------------
 Procedure SP_CR_renderizacion_pdf ( lv_nombre  in varchar ) is
   l_file     UTL_FILE.FILE_TYPE;
  l_buffer   RAW(32767);
  l_amount   BINARY_INTEGER := 32767;
  l_pos      INTEGER := 1;
  l_blob     BLOB;
  l_blob_len INTEGER;
  lv_nombrepdf varchar(100);
  Begin
    BEGIN

      select aqpa471pdf into l_blob from aqpa471 where aqpa471trxid = 64;

      l_blob_len := DBMS_LOB.getlength(l_blob);
      lv_nombrepdf:=lv_nombre||'.pdf';
      l_file := UTL_FILE.fopen('DTPUMP_PR_EMAIL', lv_nombrepdf, 'wb', 32767); -- se genera archivo.pdf en la ruta: NOMBRE_DIRECTORIO
      -- NOMBRE_DIRECTORIO es un nombre de ruta que se encuentra en "DBA_DIRECTORIES"
       
      WHILE l_pos <= l_blob_len LOOP
        DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
        UTL_FILE.put_raw(l_file, l_buffer, TRUE);
        l_pos := l_pos + l_amount;
      END LOOP;

       
      UTL_FILE.fclose(l_file);

    EXCEPTION
      WHEN OTHERS THEN
         
        IF UTL_FILE.is_open(l_file) THEN
          UTL_FILE.fclose(l_file);
        END IF;
        RAISE;
    END;
  end SP_CR_renderizacion_pdf;


end pq_cr_fac_electronica;
/

