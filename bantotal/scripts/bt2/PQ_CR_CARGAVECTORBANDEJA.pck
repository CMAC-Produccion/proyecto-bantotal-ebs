create or replace package PQ_CR_CARGAVECTORBANDEJA is
  -- Author  : Milton Cordova
  -- Created : 03/06/2025
  -- Purpose : 

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CARGAVECTORBANDEJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 03/06/2025 
  -- Autor de Creación          : MILTON CORDOVA
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  
  PROCEDURE SP_CR_AQPD051;
  
  PROCEDURE SP_CR_AQPD052;
  
  PROCEDURE SP_CR_AQPD053;
  
  PROCEDURE SP_CR_AQPD054;
  
  PROCEDURE SP_CR_AQPD055;
  
  PROCEDURE SP_CR_AQPD056;
  
  PROCEDURE SP_CR_AQPD057;
  
  PROCEDURE SP_CR_AQPD058;
  
end PQ_CR_CARGAVECTORBANDEJA;
/
create or replace package body PQ_CR_CARGAVECTORBANDEJA is   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD051
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD051
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
  PROCEDURE SP_CR_AQPD051 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM AQPD051 WHERE AQPD051FECIE IN
      (SELECT AQPD051AFECIE FROM USRBNDJ.AQPD051A GROUP BY AQPD051AFECIE);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD051
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD051A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD051A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD051;
    -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD052
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD052
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
  PROCEDURE SP_CR_AQPD052 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM AQPD052 WHERE AQPD052FECIE IN
      (SELECT AQPD052AFECIE FROM USRBNDJ.AQPD052A GROUP BY AQPD052AFECIE);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD052
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD052A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD052A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD052;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD053
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD053
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************   
  PROCEDURE SP_CR_AQPD053 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM AQPD053 WHERE AQPD053FECHA IN
      (SELECT AQPD053AFECHA FROM USRBNDJ.AQPD053A GROUP BY AQPD053AFECHA);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;  
    BEGIN
      INSERT INTO AQPD053
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD053A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD053A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD053;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD054
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD054
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************   
  PROCEDURE SP_CR_AQPD054 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      DELETE FROM AQPD054 WHERE AQPD054FECH IN
      (SELECT AQPD054AFECH FROM USRBNDJ.AQPD054A GROUP BY AQPD054AFECH);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD054
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD054A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD054A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD054;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD055
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD055
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
  PROCEDURE SP_CR_AQPD055 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      DELETE FROM AQPD055 WHERE AQPD055FECHA IN
      (SELECT AQPD055AFECHA FROM USRBNDJ.AQPD055A GROUP BY AQPD055AFECHA);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD055
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD055A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD055A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD055;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD056
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD056
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
  PROCEDURE SP_CR_AQPD056 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      DELETE FROM AQPD056 WHERE AQPD056FECHA IN
      (SELECT AQPD056AFECHA FROM USRBNDJ.AQPD056A GROUP BY AQPD056AFECHA);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD056
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD056A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD056A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD056;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD057
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD057
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************  
  PROCEDURE SP_CR_AQPD057 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      DELETE FROM AQPD057 WHERE AQPD057FENEG IN
      (SELECT AQPD057AFENEG FROM USRBNDJ.AQPD057A GROUP BY AQPD057AFENEG);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD057
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD057A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD057A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD057;
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_AQPD058
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 03/06/2025
   -- AUTOR DE CREACION           : MILTON CORDOVA HERRERA
   -- USO                         : GENERA AQPD058
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- ***************************************************************** 
  PROCEDURE SP_CR_AQPD058 IS
    FECHA_SISTEMA DATE;
    HORA_SISTEMA  VARCHAR2(8);  
  BEGIN
    BEGIN
      SELECT A.PGFAPE, TO_CHAR(SYSDATE, 'HH24:MI:SS')
      INTO FECHA_SISTEMA, HORA_SISTEMA
      FROM FST017 A
      WHERE A.PGCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      DELETE FROM AQPD058 WHERE AQPD058FECHA IN
      (SELECT AQPD058AFECHA FROM USRBNDJ.AQPD058A GROUP BY AQPD058AFECHA);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END; 
    BEGIN
      INSERT INTO AQPD058
      SELECT ROWNUM, FECHA_SISTEMA, HORA_SISTEMA, A.*
      FROM USRBNDJ.AQPD058A A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;
    END;
    BEGIN
      DELETE FROM USRBNDJ.AQPD058A;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
      NULL;   
    END;
  END SP_CR_AQPD058;
end PQ_CR_CARGAVECTORBANDEJA;
/
