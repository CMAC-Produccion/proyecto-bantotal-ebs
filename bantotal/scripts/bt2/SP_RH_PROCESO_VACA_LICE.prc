CREATE OR REPLACE PROCEDURE SP_RH_PROCESO_VACA_LICE

  -- *****************************************************************
  -- NOMBRE                     : SP_RH_PROCESO_VACA_LICE
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- Fecha de Creación          : 12/01/2026
  -- Autor de Creación          : Luigui Lupacca
  -- USO                        : Ejecuta procedimientos SP_RH_REACTIVA_VACA_LICE y SP_RH_DESACTIVA_VACA_LICE en secuencia.  
  -- ESTADO                     : ACTIVO
  -- Acceso                     : Público
  -- *****************************************************************
  
IS
BEGIN
  -- Primero reactiva los que ya terminaron
  SP_RH_REACTIVA_VACA_LICE;

  -- Luego desactiva los nuevos
  SP_RH_DESACTIVA_VACA_LICE;

EXCEPTION
  WHEN OTHERS THEN
    SYS.SP_SY_ENVIAMAIL_HTML(
      'igs_llupacca@cajaarequipa.pe',
      'igs_llupacca@cajaarequipa.pe',
      'ERROR SP_RH_PROCESO_VACA_LICE',
      'Error: ' || SQLERRM
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'ehidalgom@cajaarequipa.pe',
      'ehidalgom@cajaarequipa.pe',
      'ERROR SP_RH_PROCESO_VACA_LICE',
      'Error: ' || SQLERRM
    );
    
    SYS.SP_SY_ENVIAMAIL_HTML(
      'kcabrerac@cajaarequipa.pe',
      'kcabrerac@cajaarequipa.pe',
      'ERROR SP_RH_PROCESO_VACA_LICE',
      'Error: ' || SQLERRM
    );
    
END SP_RH_PROCESO_VACA_LICE;
/
