CREATE OR REPLACE PROCEDURE SP_AH_INSJAQY678(P_CODIGO    IN NUMBER,
                                             P_AGENCIA   IN VARCHAR2,
                                             P_FECHA     IN DATE,
                                             P_CUENTA    IN VARCHAR2,
                                             P_MONEDA    IN VARCHAR2,
                                             P_SOLICITA  IN VARCHAR2,
                                             P_AUTORIZA  IN VARCHAR2,
                                             P_TEXTO1    IN VARCHAR2,
                                             p_ESTADO    IN VARCHAR2,
                                             P_TEXTO2    IN VARCHAR2,
                                             P_TEXTO3    IN VARCHAR2,
                                             p_USUARIO   IN VARCHAR2,
                                             p_HORA      IN VARCHAR2,
                                             P_ACCION    IN NUMBER
                                             ) IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_INSJAQY678
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Silvia Marquez
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 18/12/2023
    -- Autor de la Modificación   : Tania Apaza
    -- Descripción de Modificación: Borrado de tabla
    --
    -- *****************************************************************                                             
Begin
 CASE P_ACCION
 WHEN 1 THEN
      insert into jaqy658
                (jaqy658cod,
                 jaqy658fec,
                 jaqy658aux1,
                 jaqy658auxa,
                 jaqy658auxb,
                 jaqy658auxc,
                 jaqy658auxd,
                 jaqy658auxe,
                 jaqy658auxf,
                 jaqy658auxg,
                 jaqy658auxh,
                 jaqy658auxi,
                 JAQY658auxj, --se guarda hora
                 jaqy658auxk)
          values
                (SQ_AH_JAQY658.NEXTVAL,
                 P_FECHA,
                 P_CODIGO,
                 P_AGENCIA,
                 P_CUENTA,
                 P_MONEDA,
                 P_SOLICITA,
                 P_AUTORIZA,
                 P_TEXTO1,
                 p_ESTADO,
                 P_TEXTO2,
                 P_TEXTO3,
                 p_HORA,
                 p_USUARIO);
           COMMIT;
  WHEN 2 THEN

      DELETE JAQY658
      where jaqy658auxk  = p_USUARIO;
      COMMIT;

  END CASE;
END SP_AH_INSJAQY678;
/

