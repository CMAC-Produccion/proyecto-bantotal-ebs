create or replace package pq_migra_ibanking is

  -- *****************************************************************
  -- Nombre                     : pq_migra_ibanking
  -- Sistema                    : SORFY
  -- M�dulo                     : Personas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 19/05/2011
  -- Autor de Creaci�n          : ylozada
  -- Uso                        : PAQUETE DE MIGRACION DE DATOS USUARIOS- TARJETAS IBANKING.
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      :
  -- Autor de Modificaci�n      :
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************
  procedure sp_ibanking_BnjCnl1;
  procedure sp_ibanking_BnjCnl2;
  procedure sp_ibanking_BnjCnl3;

end pq_migra_ibanking;
/

