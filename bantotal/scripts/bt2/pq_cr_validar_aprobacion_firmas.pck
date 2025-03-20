create or replace package pq_cr_validar_aprobacion_firmas is

  -- Author  : ECOLLADO
  -- Created : 12/07/2022 15:52:15
  -- Purpose : Paquete encargado de mostrar bot?n 'Continuar' en el panel HAQPC504
  
  -- Public type declarations
  procedure sp_validar_aprobacion_firmas(ve_cuenta in number, vr_respuesta out varchar);

end pq_cr_validar_aprobacion_firmas;
/

create or replace package body pq_cr_validar_aprobacion_firmas is
--  *****************************************************************
--       Sistema                    : BANTOTAL
--       M?dulo                     : Cr?ditos - Activas
--       Versi?n                    : 1.0
--       Fecha de Creaci?n          : 2022.07.12
--       Autor de Creaci?n          : Eduardo Collado Rafael
--       Uso                        : Procedimiento para habilitar bot?n 'Continuar' en el panel HAQPC504
--       Estado                     : Activo
--       Acceso                     : P?blico
--       Par?metros de Entrada      : ve_cuenta ( Numero de Cuenta )
--       Par?metros de Salida       : vr_respuesta ( Respuesta S = 'Permite mostrar' o N = 'No permite Mostrar')
--       ******************************************************************

procedure sp_validar_aprobacion_firmas (ve_cuenta in number, vr_respuesta out varchar)
is
cantidad_titulares number;
cantidad_titulares_aprobados number;
BEGIN
 BEGIN
 SELECT COUNT(*) into cantidad_titulares from fsr008 where ctnro = ve_cuenta;   
 exception
   when others then
     cantidad_titulares := 0;
 end;
 
 BEGIN
   SELECT count(*) into cantidad_titulares_aprobados from aqpa106 where aqpa106num in 
                      (select pendoc from fsr008 where ctnro = ve_cuenta) and aqpa106est = 'A';
   exception
     when others then
       cantidad_titulares_aprobados := 1;
  end;
 
 IF cantidad_titulares = cantidad_titulares_aprobados  then
    vr_respuesta := 'S';
 ELSE
    vr_respuesta := 'N';
 END IF;
exception
  when others then
    vr_respuesta := 'N';

end sp_validar_aprobacion_firmas;

end pq_cr_validar_aprobacion_firmas;
/

