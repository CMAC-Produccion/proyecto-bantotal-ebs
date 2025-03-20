create or replace procedure SP_AH_SENDMAILATTACH_BASE64(p_DestinatariosPara VARCHAR2,
                                                        p_DestinatariosCC   VARCHAR2,
                                                        p_DestinatariosBcc  VARCHAR2,
                                                        p_Mensaje           CLOB,
                                                        p_Remitente         VARCHAR2,
                                                        p_Asunto            VARCHAR2,
                                                        p_TipoMensaje       VARCHAR2,
                                                        p_Directorio        VARCHAR2,
                                                        p_ArchivosAdjuntos  VARCHAR2,
                                                        p_Guia              NUMBER,
                                                        p_Correlativo       NUMBER,
                                                        p_Tag               VARCHAR2,
                                                        p_c_coderr          out varchar2,
                                                        p_c_deserr          out varchar2) IS

  -- *****************************************************************
  -- Nombre                     : SP_AH_SENDMAILATTACH_BASE64
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 21/03/2024
  -- Autor de Creación          : DYLA
  -- Uso                        :
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

  v_imagen_temp     CLOB := TO_CLOB('NO_HAY_IMAGEN');
  v_tamano          NUMBER;
  v_result          CLOB := TO_CLOB('');
  v_temporal        CLOB;
  v_patron          VARCHAR2(250) := '#IMAGEN_'; --SEGERENCIA
  v_posicion        NUMBER;
  v_exite_reemplazo varchar2(1) := 'N';
  v_indice_str      varchar2(2) := '00';
  v_indice_int      NUMBER := 0;
  v_patron_int      NUMBER := 0;
begin
  v_temporal   := p_Mensaje;
  v_patron     := p_Tag;
  v_patron_int := DBMS_LOB.GETLENGTH(v_patron);
  v_posicion   := INSTR(v_temporal, v_patron);

  WHILE v_posicion > 0 LOOP
    v_tamano   := DBMS_LOB.GETLENGTH(v_temporal);
    v_posicion := v_posicion - 1;
    -- OBTENER EL CORRELATIVO PARA OBTENER IMAGEN
    v_indice_str := DBMS_LOB.SUBSTR(v_temporal,
                                    2,
                                    v_posicion + v_patron_int + 1);
    v_indice_int := TO_NUMBER(v_indice_str);
    -- OBTENER LA IMAGEN
    BEGIN
      SELECT AQPC757CLOB
        INTO v_imagen_temp
        FROM AQPC757
       WHERE AQPC757GUIA = p_Guia
         AND AQPC757CORR1 = p_Correlativo
         AND AQPC757CORR2 = v_indice_int
         AND AQPC757CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- FIN

    -- DAR ERROR SI NO MANEJA ASI
    IF v_exite_reemplazo = 'N' THEN
      v_result := DBMS_LOB.SUBSTR(v_temporal, v_posicion, 1);
    ELSE
      DBMS_LOB.APPEND(v_result, DBMS_LOB.SUBSTR(v_temporal, v_posicion, 1));
    END IF;
    -- PARA SALTAR #IMAGEN_XX#
    v_posicion := v_posicion + v_patron_int + 4;
    -- OBTENER TEXTO ANTES #IMAGEN_XX#
    v_temporal := DBMS_LOB.SUBSTR(v_temporal, v_tamano, v_posicion);
    -- AGREGAR AL RESULTADO FINAL LA IMAGEN
    DBMS_LOB.APPEND(v_result, v_imagen_temp);
    -- BUSCAR NUEVAMENTE EL PANTRON
    v_posicion := INSTR(v_temporal, v_patron, 1);
    -- SI NO HAY MAS, AGREGA AL RESULTADO FINAL EL RESTO DEL CONTENIDO
    IF v_posicion = 0 THEN
      DBMS_LOB.APPEND(v_result, v_temporal);
    END IF;
    -- FLAG PARA SABER QUE HABIA AL MENOS UN TAG
    v_exite_reemplazo := 'S';
  END LOOP;
  -- SI NO ENCONTRO TAGS SE ENVIA TAL CUAL EL MENSAJE
  IF v_exite_reemplazo = 'N' THEN
    v_result := p_Mensaje;
  END IF;

  pq_ah_planillas.p_sendmailattach(p_destinatariospara => p_destinatariospara,
                                   p_destinatarioscc   => p_destinatarioscc,
                                   p_destinatariosbcc  => p_destinatariosbcc,
                                   p_mensaje           => v_result,
                                   p_remitente         => p_remitente,
                                   p_asunto            => p_Asunto,
                                   p_tipomensaje       => p_tipomensaje,
                                   p_directorio        => p_directorio,
                                   p_archivosadjuntos  => p_archivosadjuntos,
                                   p_c_coderr          => p_c_coderr,
                                   p_c_deserr          => p_c_deserr);
end;
/

