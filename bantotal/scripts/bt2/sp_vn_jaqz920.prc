create or replace procedure SP_VN_jaqz920(NUMDOC varchar2,
                               CORREO varchar2,
                               IMEI   varchar2,
                               coderr out varchar2,
                               msgerr out varchar2)
-- *****************************************************************
  -- Nombre                     : SP_VN_jaqz920
  -- Sistema                    : CAJA MOVIL
  -- Módulo                     : VISA NET
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/06/2017
  -- Autor de Creación          : BDEG
  -- Uso                        : Registro en el log de visanet
  -- Estado                     : Activo
  -- *****************************************************************

as
begin
   /*commit;
   
  insert into jaqz920 (JAQZ920NUMDNI,JAQZ920CORREO,JAQZ920IPREG)
       values (NUMDOC,CORREO,IMEI);

    commit;
    */
    coderr := '00000';
    msgerr := 'CORRECTO';
    exception
      when others then
         coderr := '00099';
         msgerr := SQLERRM;
end;
/

