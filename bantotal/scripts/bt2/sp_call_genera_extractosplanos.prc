create or replace procedure SP_CALL_GENERA_EXTRACTOSPLANOS(p_n_codesv number,
                                                           p_n_codtsv number,
                                                           p_c_user   char,
                                                           p_d_fecha  date,
                                                           p_c_msgerr out varchar2,
                                                           p_c_nombre varchar2) is

  -- *****************************************************************
  -- Nombre                     : sp_call_genera_extractosPlanos
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 02/05/2014
  -- Autor de Creación          : Jorge Cuadros Soto
  -- Uso                        : Call generacion extracto en archivo plano
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************
  cant   number;
  nombre varchar2(50);
begin

  SELECT FILE_NAME
    into nombre
    FROM TABLE(parallel_dump_v2(CURSOR
                                (select a.jaql867cor || chr(9) ||
                                        a.jaql867mov || chr(9) ||
                                        a.jaql867fmv || chr(9) ||
                                        a.jaql867cct || chr(9) ||
                                        a.jaql867fvl || chr(9) ||
                                        a.jaql867dsc || chr(9) ||
                                        a.jaql867doc || chr(9) ||
                                        a.jaql867dep || chr(9) ||
                                        a.jaql867ret || chr(9) ||
                                        a.jaql867sdo || chr(9) ||
                                        (select JAQL515SUMIN
                                           from jaql515
                                          Where JAQL515PGSUC = a.Jaql867suc
                                            and JAQL515SCMOD =
                                                to_number(substr(a.jaql867ndp,
                                                                 1,
                                                                 3))
                                            and JAQL515STRAN =
                                                to_number(substr(a.jaql867ndp,
                                                                 4,
                                                                 3))
                                            and JAQL515SNREL =
                                                to_number(substr(a.jaql867ndp,
                                                                 7,
                                                                 4))
                                            and JAQL515ESREG = 'V'
                                            and JAQL515FEMOV = a.jaql867fmv) ||
                                        chr(9)
                                   from jaql867 a
                                  where TRIM(a.jaql867usu) = p_c_user order by a.jaql867fmv),
                                p_c_nombre,
                                'DTPUMP7')) nt;
end SP_CALL_GENERA_EXTRACTOSPLANOS;
/

