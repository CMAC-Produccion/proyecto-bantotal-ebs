create or replace package pq_migra_ibanking is

  -- *****************************************************************
  -- Nombre                     : pq_migra_ibanking
  -- Sistema                    : SORFY
  -- Módulo                     : Personas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19/05/2011
  -- Autor de Creación          : ylozada
  -- Uso                        : PAQUETE DE MIGRACION DE DATOS USUARIOS- TARJETAS IBANKING.
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
  -- Descripción de Modificación: 
  -- *****************************************************************
  procedure sp_ibanking_BnjCnl1;
  procedure sp_ibanking_BnjCnl2;
  procedure sp_ibanking_BnjCnl3;

end pq_migra_ibanking;
/

