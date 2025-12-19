create or replace package PQ_CR_DESASTRE_NATURAL_M is
-- *****************************************************************
-- Nombre   : PQ_CR_DESASTRE_NATURAL_M
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 06/11/2025
-- Autor de Creación  : Milton Cordova
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************
  PROCEDURE SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO (PI_INSTANCIA IN NUMBER,
                                                   PI_USUARIO   IN VARCHAR2,
                                                   PO_RESULTADO OUT VARCHAR2,
                                                   PO_COD_ERROR OUT VARCHAR2,
                                                   PO_MSG_ERROR OUT VARCHAR2);
  

  PROCEDURE sp_cr_control_periodio_gracia_sin_CRM (PI_INSTANCIA IN NUMBER,
                                                   PI_USUARIO   IN VARCHAR2,
                                                   PO_RESULTADO OUT VARCHAR2,
                                                   PO_COD_ERROR OUT VARCHAR2,
                                                   PO_MSG_ERROR OUT VARCHAR2);
    
  PROCEDURE SP_CR_VALIDA_REFINANCIADO (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
      
  PROCEDURE sp_cr_valid_plazo_maximo (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
     
  PROCEDURE sp_cr_control_productos_permitidos (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
         
  PROCEDURE SP_CR_CALIFIC_RCC (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
         
  PROCEDURE SP_CR_RP_GRADIENTE_CAJ_REPRGSINCAP (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
     
  PROCEDURE SP_CR_GRDNT_CRONOGR2 (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
             
  PROCEDURE SP_CR_VALIDA_ACTA_CERRADA2 (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);     
                                       
  PROCEDURE SP_BLOQUEO_CREDINKA (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
                                       
  PROCEDURE SP_CR_RATIOS_REPROGRAMADOS (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
                                       
  PROCEDURE sp_Cr_LimiteAgencia (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);
  
  PROCEDURE sp_Cr_LimtNacional (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2);                                                                                                                              
end PQ_CR_DESASTRE_NATURAL_M;
/
create or replace package body PQ_CR_DESASTRE_NATURAL_M is
  -- *****************************************************************
  -- Nombre                       : SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : VALIDA DIAS DE ATRASO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************
  PROCEDURE SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO (PI_INSTANCIA IN NUMBER,
                                                   PI_USUARIO   IN VARCHAR2,
                                                   PO_RESULTADO OUT VARCHAR2,
                                                   PO_COD_ERROR OUT VARCHAR2,
                                                   PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_VALIDAR_RNG_REPROG.SP_CR_VALIDA_REPROGRAMADO_DIAS_ATRASO(PI_INSTANCIA,
                                                                     ESTADO,
                                                                     PO_COD_ERROR,
                                                                    PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF;
    
  END;
     
  -- *****************************************************************
  -- Nombre                       : sp_cr_control_periodio_gracia_sin_CRM
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : VALIDA DIAS GRACIA
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************
  PROCEDURE sp_cr_control_periodio_gracia_sin_CRM (PI_INSTANCIA IN NUMBER,
                                                   PI_USUARIO   IN VARCHAR2,
                                                   PO_RESULTADO OUT VARCHAR2,
                                                   PO_COD_ERROR OUT VARCHAR2,
                                                   PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_control_periodio_gracia_sin_CRM(PI_INSTANCIA,
                                                                                ESTADO,
                                                                                PO_COD_ERROR,
                                                                                PO_MSG_ERROR); 
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF;
    
  END;
  
  -- *****************************************************************
  -- Nombre                       : SP_CR_VALIDA_REFINANCIADO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : REFINANCIADO
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************    
  PROCEDURE SP_CR_VALIDA_REFINANCIADO (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    ESTADO := 'S';
    BEGIN
        SELECT 'N'
          INTO ESTADO
          FROM SNG001
         WHERE SNG001INST = PI_INSTANCIA
           AND SNG001ORI = 3;
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := 'S';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END; 
 
  -- *****************************************************************
  -- Nombre                       : sp_cr_valid_plazo_maximo
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : PLAZO RESIDUAL
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- ***************************************************************** 
  PROCEDURE sp_cr_valid_plazo_maximo (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_valid_plazo_maximo(PI_INSTANCIA,
                                                                   ESTADO,
                                                                   PO_COD_ERROR,
                                                                   PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END; 
  
  -- *****************************************************************
  -- Nombre                       : sp_cr_control_productos_permitidos
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : PRODUCTOS NO PERMITIDOS
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************     
  PROCEDURE sp_cr_control_productos_permitidos (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL.sp_cr_control_productos_permitidos(PI_INSTANCIA,
                                                                             ESTADO,
                                                                             PO_COD_ERROR,
                                                                             PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;        
  
  -- *****************************************************************
  -- Nombre                       : SP_CR_CALIFIC_RCC
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : CALIFICACION NORMAL O CPP
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************  
  PROCEDURE SP_CR_CALIFIC_RCC (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      pq_cr_calificac_reprg_desas_natural.SP_CR_CALIFIC_RCC(PI_INSTANCIA,
                                                            ESTADO);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;  
  
  -- *****************************************************************
  -- Nombre                       : SP_CR_RP_GRADIENTE_CAJ_REPRGSINCAP
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : VALIDAR CUENTA GRADIENTE MENOS DEL 30%
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************      
  PROCEDURE SP_CR_RP_GRADIENTE_CAJ_REPRGSINCAP (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      pq_cr_contrl_reprog_refin25.SP_CR_RP_GRADIENTE_CAJ_REPRGSINCAP(PI_INSTANCIA,
                                                                     '',
                                                                     ESTADO,
                                                                     PO_COD_ERROR,
                                                                     PO_MSG_ERROR);   
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;   
  
      
  -- *****************************************************************
  -- Nombre                       : SP_CR_GRDNT_CRONOGR2
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : VALIDAR GRADIENTES NO PUEDEN SER MAS DE 25% 
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- ***************************************************************** 
  PROCEDURE SP_CR_GRDNT_CRONOGR2 (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_GRADIENTE.SP_CR_GRDNT_CRONOGR2(PI_INSTANCIA,
                                           '',
                                           ESTADO,
                                           PO_COD_ERROR,
                                           PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;  
          
  -- *****************************************************************
  -- Nombre                       : SP_CR_VALIDA_ACTA_CERRADA2
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : VALIDAR ESTADO DE ACTA DIGITAL 
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************      
  PROCEDURE SP_CR_VALIDA_ACTA_CERRADA2 (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_REGISTRO_ACTA_DIGITAL.SP_CR_VALIDA_ACTA_CERRADA2(PI_INSTANCIA,
                                           '',
                                           ESTADO,
                                           PO_COD_ERROR,
                                           PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END; 
  
  -- *****************************************************************
  -- Nombre                       : SP_BLOQUEO_CREDINKA
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : BLOQUEO CREDINKA
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************           
  PROCEDURE SP_BLOQUEO_CREDINKA (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_VALIDAR_RNG_REPROG.SP_BLOQUEO_CREDINKA(PI_INSTANCIA,
                                                         '',
                                                         ESTADO,
                                                         PO_COD_ERROR,
                                                         PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;      
  
  -- *****************************************************************
  -- Nombre                       : SP_CR_RATIOS_REPROGRAMADOS
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : RATIOS REPROGRAMADOS
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************     
  PROCEDURE SP_CR_RATIOS_REPROGRAMADOS (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      pq_cr_validar_rng_reprog.SP_CR_RATIOS_REPROGRAMADOS(PI_INSTANCIA,
                                                          PI_USUARIO,
                                                          ESTADO,
                                                          PO_COD_ERROR,
                                                          PO_MSG_ERROR);
    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'S' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END; 
    
  -- *****************************************************************
  -- Nombre                       : sp_Cr_LimiteAgencia
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : LIMITES POR AGENCIA
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************     
  PROCEDURE sp_Cr_LimiteAgencia (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_CNTRL_LIMITREPRO.sp_Cr_LimiteAgencia(PI_INSTANCIA,
                                             2,
                                             ESTADO);

    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;  
    
  -- *****************************************************************
  -- Nombre                       : sp_Cr_LimtNacional
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Activas
  -- Versión                      : 1.0
  -- Fecha de Creación            : 06/11/2025
  -- Autor de Creación            : Milton Cordova
  -- Uso                          : LIMITES NACIONAL
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Parámetros de Entrada        : PI_INSTANCIA, PI_USUARIO, PO_RESULTADO 
  -- Retorno                      : PO_COD_ERROR, PO_MSG_ERROR
  --------------------------------------------------------------------
  -- Fecha de Modificación  : 
  -- Autor de la Modificación : 
  -- Descripción de Modificación  : 
  -- *****************************************************************  
  PROCEDURE sp_Cr_LimtNacional (PI_INSTANCIA IN NUMBER,
                                       PI_USUARIO   IN VARCHAR2,
                                       PO_RESULTADO OUT VARCHAR2,
                                       PO_COD_ERROR OUT VARCHAR2,
                                       PO_MSG_ERROR OUT VARCHAR2)
  IS
    ESTADO VARCHAR2(1);
  BEGIN
    BEGIN
      PQ_CR_CNTRL_LIMITREPRO.sp_Cr_LimtNacional(PI_INSTANCIA,
                                             2,
                                             ESTADO);

    EXCEPTION
      WHEN OTHERS THEN NULL;
      ESTADO := '';
    END;
    IF ESTADO = 'N' THEN -- MOSTRAR BLOQUEANTE
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF; 
  END;                                               
end PQ_CR_DESASTRE_NATURAL_M;
/
