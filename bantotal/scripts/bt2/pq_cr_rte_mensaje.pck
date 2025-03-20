CREATE OR REPLACE PACKAGE PQ_CR_RTE_MENSAJE IS

  -- *****************************************************************
   -- NOMBRE                      : PQ_CR_RTE_MENSAJE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/06/2023
   -- AUTOR DE CREACION           : HENRY ANGEL SUAREZ LAZARTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
  
  PROCEDURE SP_CR_VALIDAR_MENSAJE(VE_COD  IN NUMBER,
                                  VE_SUC  IN NUMBER,
                                  VE_MOD  IN NUMBER,
                                  VE_TRAN IN NUMBER,
                                  VE_NREL IN NUMBER,
                                  VE_ORD  IN NUMBER,
                                  VE_UING IN VARCHAR2,
                                  VO_RES OUT VARCHAR2);

END PQ_CR_RTE_MENSAJE;
/

create or replace package body PQ_CR_RTE_MENSAJE is

  -- Initialization
  PROCEDURE SP_CR_VALIDAR_MENSAJE(ve_Cod  IN NUMBER,
                                  ve_Suc  IN NUMBER,
                                  ve_Mod  IN NUMBER,
                                  ve_Tran IN NUMBER,
                                  ve_Nrel IN NUMBER,
                                  ve_Ord  IN NUMBER,
                                  ve_Uing IN VARCHAR2,
                                  vo_Res OUT VARCHAR2)
   is
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_MENSAJE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 16/06/2023
   -- AUTOR DE CREACION           : HENRY ANGEL SUAREZ LAZARTE
   -- USO                         : VALIDA EL MENSAJE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
   CURSOR LISTAS_MSG_HABILITADOS IS
   SELECT * FROM AQPC714 WHERE AQPC714EHAB='H';
   VO_COD_ERROR VARCHAR(8);
   VO_MSG_ERROR VARCHAR(200);
   VS_CONSULTA VARCHAR(200);
   VI_VARIABLE VARCHAR(150); -- Variable de salida
   begin
        VO_RES:= '-';
        --TABLA DE VALIDACION PARA VER QUE MENSAJES ESTAN HABILITADOS
        FOR X IN LISTAS_MSG_HABILITADOS LOOP
            BEGIN
              --VS_CONSULTA := 'BEGIN ' || VS_CONSULTA || ' END';
              --EXECUTE IMMEDIATE VS_CONSULTA; regresar a cmo estaba antes HSUAREZ
              /*
              VS_CONSULTA:= 'BEGIN '||X.AQPC714PQT||'.'||X.AQPC714PRD||'(' ||
                           VE_COD||','||VE_SUC||','||VE_MOD||','||VE_TRAN||','||VE_NREL||','||VE_ORD||',':1'); END;' ;
              EXECUTE IMMEDIATE DECLARE VI_VARIABLE VARCHAR(150) VS_CONSULTA USING OUT VI_VARIABLE;
              */
              -- Construir la consulta dinámica
              
              VS_CONSULTA := 'BEGIN ' || X.AQPC714PQT || '.' || X.AQPC714PRD || '(' || VE_COD || ',' || VE_SUC || ',' || VE_MOD || ',' || VE_TRAN || ',' || VE_NREL || ',' || VE_ORD || ',''' || ve_Uing ||''', :1); END;';
              -- Ejecutar la consulta dinámica
              EXECUTE IMMEDIATE VS_CONSULTA USING OUT VI_VARIABLE;
              COMMIT;
              dbms_output.put_line(VS_CONSULTA);
              BEGIN
                INSERT INTO AQPC715 VALUES(ve_Cod,ve_Suc,ve_Mod,ve_TraN,ve_Nrel,ve_Ord,X.AQPC714PQT,X.AQPC714PRD,VS_CONSULTA,'0000',VI_VARIABLE,SYSDATE);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN
                VO_COD_ERROR := '0006';
                VO_MSG_ERROR := 'Ocurrio un problema al trata de ejecutar la consulta : ' ||
                                VS_CONSULTA;
                --VO_MSG_ERROR := 'Ocurrio un problema al Ejecutar el proceso de Eliminacion de Tasa'; --Borrar
                BEGIN
                  INSERT INTO AQPC715 VALUES(ve_Cod,ve_Suc,ve_Mod,ve_TraN,ve_Nrel,ve_Ord,X.AQPC714PQT,X.AQPC714PRD,VS_CONSULTA,VO_COD_ERROR,VO_MSG_ERROR,SYSDATE);
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
                END;
               
            END;
            COMMIT;
        END LOOP;
        VO_RES := VO_MSG_ERROR;
   exception
     when others then
       null;
   end;
end PQ_CR_RTE_MENSAJE;
/

