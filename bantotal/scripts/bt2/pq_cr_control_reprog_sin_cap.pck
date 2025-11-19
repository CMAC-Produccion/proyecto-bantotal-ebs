create or replace package pq_cr_control_reprog_sin_cap is
  -- *****************************************************************
  -- Nombre                     : PAQUETE CONTROLES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/09/2025 
  -- Autor de Creación          : IGS_RCASTRO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 14/10/2025
  -- Autor de Modificación      : rcastro
  -- Descripción de Modificación: se agrega validacion de estados de aprobacion
  -- *****************************************************************
  
  Procedure sp_validar_autorizante(VE_FECHAREG IN DATE,
                                   VE_CODREPROG IN NUMBER,
                                   VE_INSTANCIA IN NUMBER,
                                    --
                                   VE_UBUSER IN VARCHAR,
                                   --VE_COMENTARIO IN VARCHAR,
                                   --VE_ESTADO IN VARCHAR,
                                    --
                                   VO_CODERROR OUT VARCHAR,
                                   VO_MSGERROR OUT VARCHAR
                                   );
  
  

end pq_cr_control_reprog_sin_cap;
/
create or replace package body pq_cr_control_reprog_sin_cap is

  Procedure sp_validar_autorizante(VE_FECHAREG IN DATE,
                                   VE_CODREPROG IN NUMBER,
                                   VE_INSTANCIA IN NUMBER,
                                    --
                                   VE_UBUSER IN VARCHAR,
                                   --VE_COMENTARIO IN VARCHAR,
                                   --VE_ESTADO IN VARCHAR,
                                    --
                                   VO_CODERROR OUT VARCHAR,
                                   VO_MSGERROR OUT VARCHAR
                                   ) IS
                                   
 VI_NIVEL_APROB AQPD157.AQPD157NIAP%TYPE;
  VI_NIVEL_DEPEND AQPD157.AQPD157NIDP%TYPE;
  VI_USR_APROB AQPD157.AQPD157UAPRO%TYPE;
  VI_USR_APROBR AQPD157.AQPD157UAPRO%TYPE;
  VI_USR_COD_CARGO AQPD157.AQPD157CODCAR%TYPE;
  VI_USR_ESTADO AQPD157.AQPD157EST%TYPE;
                                
BEGIN
     VO_CODERROR := '';   
     VO_MSGERROR := '';        
     --VALIDAMOS QUE EXISTA REGISTRO 
      BEGIN
          SELECT A.AQPD157NIAP,A.AQPD157NIDP,A.AQPD157UAPRO
            INTO VI_NIVEL_APROB,VI_NIVEL_DEPEND,VI_USR_APROBR
            FROM AQPD157 A
           WHERE A.AQPD157FECAPRO = VE_FECHAREG
             AND A.AQPD157CODREP  = VE_CODREPROG
             AND A.AQPD157INST    = VE_INSTANCIA
             AND A.AQPD157UAPRO   = RPAD(TRIM(VE_UBUSER),10,' ')
             and A.AQPD157EST     = 'P';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           BEGIN
                SELECT A.AQPD157NIAP,A.AQPD157NIDP,A.AQPD157UAPRO
                INTO VI_NIVEL_APROB,VI_NIVEL_DEPEND,VI_USR_APROBR
                FROM AQPD157 A
               WHERE A.AQPD157FECAPRO = VE_FECHAREG
                 AND A.AQPD157CODREP  = VE_CODREPROG
                 AND A.AQPD157INST    = VE_INSTANCIA
                 AND A.AQPD157UAPRO   = (SELECT SNG057USR FROM SNG057 WHERE SNG057SUP = RPAD(TRIM(VE_UBUSER),10,' ') AND SNG057FIN>=(SELECT PGFAPE FROM FST017 WHERE PGCOD=1) AND ROWNUM=1)
                 AND A.AQPD157EST     = 'P';
           EXCEPTION
            WHEN OTHERS THEN
              null;                        
           END;
        WHEN OTHERS THEN
           NULL;
      END;
      
      IF VI_NIVEL_APROB > 0 THEN
        --VALIDAMOS SI TENEMOS DEPENDENCIA EN CASO SEA VALIDAMOS SI YA AUTORIZO EL ANTERIOR 
        IF VI_NIVEL_DEPEND > 0 THEN
          --OBTENER LOS DATOS DE LOS ANTERIORES AUTORIZADORES.
          
           BEGIN
              SELECT A.AQPD157UAPRO,A.AQPD157CODCAR, A.AQPD157EST
                INTO VI_USR_APROB,VI_USR_COD_CARGO, VI_USR_ESTADO
                FROM AQPD157 A
               WHERE A.AQPD157FECAPRO = VE_FECHAREG
                 AND A.AQPD157CODREP  = VE_CODREPROG
                 AND A.AQPD157INST    = VE_INSTANCIA
                 AND A.AQPD157NIAP    = VI_NIVEL_DEPEND
                 AND A.AQPD157EST     IN ('A','P','R')
                 AND ROWNUM=1;
          EXCEPTION
            WHEN OTHERS THEN
                BEGIN
                   SELECT B.AQPD157UAPRO,B.AQPD157CODCAR, B.AQPD157EST
                     INTO VI_USR_APROB,VI_USR_COD_CARGO, VI_USR_ESTADO
                     FROM AQPD157 B
                    WHERE B.AQPD157FECAPRO = VE_FECHAREG
                      AND B.AQPD157CODREP  = VE_CODREPROG
                      AND B.AQPD157INST    = VE_INSTANCIA
                      AND B.AQPD157NIAP    < VI_NIVEL_DEPEND
                      AND B.AQPD157EST     IN ('P','A','R')
                      AND ROWNUM = 1;
                EXCEPTION
                  WHEN OTHERS THEN
                       null;
                END;          
          END;
          
          -- SI SE ENCUENTRA EL AUTORIZANTE VALIDAR SI LO AUTORIZO
          IF ((TRIM(VI_USR_APROB)) IS NOT NULL OR  VI_USR_COD_CARGO > 0 ) AND trim(VI_USR_ESTADO) <> 'A'  THEN
              VO_CODERROR := '1001';
              IF VI_USR_COD_CARGO = 202 THEN
                VO_MSGERROR := 'No se puede gestionar, esta pendiente la autorización del Gerente de Agencia.';
              ELSE             
                VO_MSGERROR := 'No se puede gestionar, esta pendiente la autorización del usuario ' || VI_USR_APROB || '.';
              END IF;
          ELSE
              VO_CODERROR := '';   
              VO_MSGERROR := '';    
          END IF;     
        END IF;
      END IF;               
END;      

end pq_cr_control_reprog_sin_cap;
/
