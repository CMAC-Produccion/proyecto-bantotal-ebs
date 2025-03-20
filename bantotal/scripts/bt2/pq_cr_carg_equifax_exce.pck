create or replace package pq_cr_carg_equifax_exce is

  --*************************************************************************************
  -- Nombre                      : pq_cr_carg_equifax_exce
  -- Sistema                     : bantotal
  -- Modulo                      : creditos - activas
  -- Version                     : 1.0  
  -- Author                      : IGS_RCASTRO
  -- Created                     : 17/04/2024 11:02:08
  -- Purpose                     : Paquete que realiza la carga de datos de excel a tabla
  -- Fecha de Modificación       : 13/05/2024
  -- Autor de la Modificación    : rcastro
  -- Descripción de Modificación : modificación de script insert aqpc839.
  -- Fecha de Modificación       : 21/05/2024
  -- Autor de la Modificación    : rcastro
  -- Descripción de Modificación : Se agrega procedimiento SP_VALIDAR_CARG_ENTID  
  -- Fecha de Modificación       : 03/06/2024
  -- Autor de la Modificación    : rcastro
  -- Descripción de Modificación : Se agrega campo Empresa Consultado en aqpc839
  --*************************************************************************************  
  
 procedure sp_insert_aqpc839 (fechaCarg date, 
                             usuario varchar2, 
                             NomCuent varchar2, 
                             tipoDocumento varchar2,
                             NroDocumento varchar2,
                             GiroEntidad varchar2,                             
                             entidConsu varchar2,
                             xPeriodo   date,
                             CantidadConsu number,
                             EmpreConsultado varchar2);
                             
 PROCEDURE SP_VALIDAR_CARG_ENTID(NOM_ENTIDAD VARCHAR2, FLGVALID OUT VARCHAR2);                             

end pq_cr_carg_equifax_exce;
/

create or replace package body pq_cr_carg_equifax_exce is

 procedure sp_insert_aqpc839(fechaCarg date, 
                             usuario varchar2, 
                             NomCuent varchar2, 
                             tipoDocumento varchar2,
                             NroDocumento varchar2,
                             GiroEntidad varchar2,                             
                             entidConsu varchar2,
                             xPeriodo   date,
                             CantidadConsu number,                             
                             EmpreConsultado varchar2) IS
  -- *****************************************************************
  -- NOMBRE                      : sp_insert_aqpc839
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 22/04/2024
  -- AUTOR DE CREACION           : rcastro
  -- USO                         : inserta aqpc839
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  --------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 13/05/2024
  -- AUTOR DE LA MODIFICACION    : rcastro
  -- DESCRIPCION DE MODIFICACION : modificación de script insert aqpc839.
  -- *****************************************************************                             
                             
                             
 v_correlativo number(10); 
 LC_HORA varchar2(10);
 FLGVALID VARCHAR2(1);
 BEGIN
     --21052024
     FLGVALID := 'N';
     BEGIN
       pq_cr_carg_equifax_exce.SP_VALIDAR_CARG_ENTID(TRIM(entidConsu),
                                                     FLGVALID);
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;                                                                                                                  
     END;  
     
     IF FLGVALID = 'S' THEN         
           begin
             SELECT max(AQPC839CORR) into v_correlativo FROM AQPC839 WHERE AQPC839FECCARG = fechaCarg AND  AQPC839USUCARG = usuario;
           exception
             when others then
               null;
           end;  
           
           BEGIN
            SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') INTO LC_HORA FROM DUAL;
           EXCEPTION
            WHEN OTHERS THEN
              NULL;
           END;
           
           v_correlativo := nvl(v_correlativo, 0);
           
           v_correlativo := v_correlativo + 1;
       
           BEGIN
             INSERT INTO AQPC839(
             AQPC839FECCARG,
             AQPC839USUCARG,
             AQPC839CORR,
             AQPC839NOMCONS,
             AQPC839TIPDOC,
             AQPC839NRODOC,
             AQPC839GIRENT,       
             AQPC839ENTCONS,
             AQPC839PERIOD,
             AQPC839CANTCON,
             AQPC839HORCARG,
             AQPC839FPROCES,
             AQPC839AUX1       
             )VALUES(
             fechaCarg,
             usuario, 
             v_correlativo,
             NomCuent,
             tipoDocumento,
             NroDocumento,
             GiroEntidad,
             entidConsu,
             xPeriodo,
             CantidadConsu,
             LC_HORA,
             'N',
             EmpreConsultado --16052024
             );       
             commit;
           EXCEPTION
             WHEN OTHERS THEN
               NULL;
           END;
     END IF;           
 END;  
 
 PROCEDURE SP_VALIDAR_CARG_ENTID(NOM_ENTIDAD VARCHAR2, FLGVALID OUT VARCHAR2) IS
   FLGEXIST VARCHAR2(1);
   BEGIN
     FLGEXIST := 'N'; 
     BEGIN
       SELECT 'S' INTO FLGEXIST FROM AQPC840 WHERE AQPC840DESCENT = NOM_ENTIDAD;
     EXCEPTION
       WHEN OTHERS THEN
         FLGEXIST := 'N';
     END;
     
     IF FLGEXIST = 'S' THEN
        FLGVALID := 'N';
     ELSE 
        FLGVALID := 'S';
     END IF;     
  END;



end pq_cr_carg_equifax_exce;
/

