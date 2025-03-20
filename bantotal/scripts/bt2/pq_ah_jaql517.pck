create or replace package PQ_AH_JAQL517 is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AH_AHSOMSG
  -- Sistema               : SORFY
  -- Módulo                : TODOS LOS CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 08/08/2011
  -- Autor de Creación     : Jeankharlo Edgard Pinto Espejo
  -- Uso                   : Almacena las tramas de requerimiento y respuesta de las empresas de recaudación
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 08/09/2013
  -- Autor de Creación     : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : Se agregó un rango de fecha para la obtención de la trama (GP_SO_GETTRAMA)
  -- Fecha de Modificación : 11/05/2017
  -- Autor de Creación     : Hernan Laqui Jimenez
  -- Descripción Modific.  : Se crea procedimiento para realizar el pase a historico de la tabla JAQL517
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  procedure SP_TE_INSERTAR(P_N_CODENT IN NUMBER,
                           P_N_CODTSE IN NUMBER,
                           P_C_NRODOC IN VARCHAR2,
                           P_C_NOMCOM IN VARCHAR2,
                           P_N_MONCOB IN NUMBER,
                           P_D_FECVEN IN DATE,
                           P_C_CODMON IN VARCHAR2,
                           P_C_ESTREG IN VARCHAR2,
                           P_C_PERFAC IN VARCHAR2,
                           P_C_NROCON IN VARCHAR2,
                           p_c_coderr out varchar2,
                           p_c_msgerr out VARCHAR2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_INSERTAR(P_C_CODMSG IN VARCHAR2,
                           P_N_CODTRA IN NUMBER,
                           P_D_FECOPE IN DATE,
                           P_C_HOROPE IN VARCHAR2,
                           P_C_CODCAN IN NUMBER,
                           P_C_CODUSU IN VARCHAR2,
                           P_N_CODESV IN NUMBER,
                           P_N_CODTSV IN NUMBER,
                           P_C_NROCON IN VARCHAR2,
                           P_N_NROVTA NUMBER,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_ACTUALIZAR(P_C_CODRES IN VARCHAR2,
                             P_C_CODRST IN VARCHAR2,
                             P_C_CODTRA IN VARCHAR2,
                             P_N_CODOPE IN NUMBER DEFAULT NULL,
                             P_C_CONFIR IN VARCHAR2,
                             P_C_NUMTRA IN VARCHAR2,
                             P_C_TRMREQ IN VARCHAR2,
                             P_C_TRMRES IN VARCHAR2,
                             P_N_TIMOUT IN NUMBER,
                             P_N_MONCOB NUMBER,
                             P_C_CODANU VARCHAR2,
                             P_C_CODMSG IN VARCHAR2,
                             P_N_CODTRA IN NUMBER,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                         
  procedure SP_SO_GETTRAMA(P_N_CODESV IN NUMBER,
                           P_N_CODTSV IN NUMBER,
                           P_C_NROCON IN VARCHAR2,
                           P_C_CODRST IN VARCHAR2,
                           P_C_CODCAN IN VARCHAR2,
                           P_C_CODTRA IN VARCHAR2,
                           P_C_CODUSU IN VARCHAR2,
                           P_C_TRMREQ OUT VARCHAR2,
                           P_C_TRMRES OUT VARCHAR2,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_SO_GETVALORES_ANULACION(P_N_CODOPE IN NUMBER,
                                       P_N_MONCOB OUT VARCHAR2,
                                       P_C_CODCAN OUT VARCHAR2,
                                       P_C_NUMTRA OUT VARCHAR2,
                                       P_C_CODUSU OUT VARCHAR2,
                                       P_C_NROCON OUT VARCHAR2,
                                       P_N_CODESV OUT VARCHAR2,
                                       P_N_CODTSV OUT VARCHAR2,
                                       P_C_CODANU OUT VARCHAR2,
                                       p_c_coderr out varchar2,
                                       p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_SO_UPDATE_NROTRANSACCION(P_N_CODTRA IN NUMBER,
                                        P_N_CODOPE IN NUMBER,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                        
  procedure SP_SO_CONFIRMA_EXTORNO(P_N_CODTRA IN NUMBER,
                                   P_C_CONFIR IN VARCHAR2,
                                   p_c_coderr out varchar2,
                                   p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                        

  procedure SP_SO_GET_NCODTRA(P_N_CODTRA OUT NUMBER);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_RESTART_SEQUENCE(P_N_CODTRA IN NUMBER,
                                   P_N_NROVTA OUT NUMBER);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_MIGRA_HISTORICO;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  
end PQ_AH_JAQL517;
/

create or replace package body PQ_AH_JAQL517 is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  ---------------------------------------
  -- IMPLEMENTACIÓN DE PROCEDIMIENTOS  --
  ---------------------------------------

  procedure SP_TE_INSERTAR(P_N_CODENT IN NUMBER,
                           P_N_CODTSE IN NUMBER,
                           P_C_NRODOC IN VARCHAR2,
                           P_C_NOMCOM IN VARCHAR2,
                           P_N_MONCOB IN NUMBER,
                           P_D_FECVEN IN DATE,
                           P_C_CODMON IN VARCHAR2,
                           P_C_ESTREG IN VARCHAR2,
                           P_C_PERFAC IN VARCHAR2,
                           P_C_NROCON IN VARCHAR2,
                           --
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_TE_INSERTAR
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 08/08/2011
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : Inserción de nuevos contratos de recaudación
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    PRAGMA AUTONOMOUS_TRANSACTION;  
  begin
  
  
    p_c_coderr := '0000';
  
    INSERT INTO jaql506
      (jaql506fepro,
       jaql506hopro,
       jaql506coent,
       jaql506cotse,
       jaql506nrdoc,
       jaql506clien,
       jaql506mocob,
       jaql506feven,
       jaql506comon,
       jaql506esreg,
       jaql506pefac,
       jaql506nrcon,
       jaql506fadoc)
    VALUES
      (trunc(sysdate),
       to_char(sysdate, 'HH24:mi:ss'),
       P_N_CODENT,
       P_N_CODTSE,
       P_C_NRODOC,
       P_C_NOMCOM,
       P_N_MONCOB,
       P_D_FECVEN,
       P_C_CODMON,
       P_C_ESTREG,
       P_C_PERFAC,
       P_C_NROCON,
       trim(P_C_PERFAC)||trim(P_C_NROCON));
    commit;
  exception
    when dup_val_on_index then
      p_c_coderr := '9001';
      p_c_msgerr := 'REGISTRO YA EXISTE. REVISE';
    when others then
      p_c_coderr := sqlcode;
      p_c_msgerr := sqlerrm;
  end SP_TE_INSERTAR;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure SP_SO_INSERTAR(P_C_CODMSG VARCHAR2,
                           P_N_CODTRA NUMBER,
                           P_D_FECOPE DATE,
                           P_C_HOROPE VARCHAR2,
                           P_C_CODCAN NUMBER,
                           P_C_CODUSU VARCHAR2,
                           P_N_CODESV NUMBER,
                           P_N_CODTSV NUMBER,
                           P_C_NROCON VARCHAR2,
                           P_N_NROVTA NUMBER,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_SO_INSERTAR
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : INSERTA DATOS EN EL LOG DE TRAMAS.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_CODMSG ( CODIGO DE MENSAJE )
    --                              P_D_FECOPE ( FECHA DE PROCESO )
    --                              P_C_HOROPE ( HORA DE PROCESO )
    --                              P_C_CODCAN ( CODIGO DEL CANAL)
    --                              P_C_CODUSU ( CODIGO DEL USUARIO )
    --                              P_N_CODESV ( CODIGO DE LA EMPRESA )
    --                              P_N_CODTSV ( CODIG DEL SERVICIO DE LA EMPRESA )
    --                              P_C_NROCON ( NUMERO DE CONTRATO/SUMINISTRO )
    --                              P_N_NROVTA ( NUMERO DE VUELTA DE LA SECUENCIA )
    --
    -- Parámetros de Salida       : p_c_coderr ( Codigo de error )
    --                              p_c_msgerr ( Mensaje de error )
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
  
    -- Inicializamos la variable de retorno
    p_c_coderr := '0000';
  
    begin
      insert into JAQL517
        (JAQL517COMSG,
         JAQL517COTRA,
         JAQL517FEOPE,
         JAQL517HOOPE,
         JAQL517COCAN,
         JAQL517COUSU,
         JAQL517COENT,
         JAQL517COTSV,
         JAQL517NRCON,
         JAQL517NRVTA,
         JAQL517NUOPE,
         JAQL517TMOUT)
      values
        (P_C_CODMSG,
         P_N_CODTRA,
         P_D_FECOPE,
         P_C_HOROPE,
         P_C_CODCAN,
         P_C_CODUSU,
         P_N_CODESV,
         P_N_CODTSV,
         P_C_NROCON,
         P_N_NROVTA,
         0,
         0);
      commit;
    
    exception
      when dup_val_on_index then
        p_c_coderr := '9001';
        p_c_msgerr := 'REGISTRO YA EXISTE. POSIBLEMENTE ESTE DESAFILIADO. REVISE';
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
  
  end SP_SO_INSERTAR;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_ACTUALIZAR(P_C_CODRES VARCHAR2,
                             P_C_CODRST VARCHAR2,
                             P_C_CODTRA VARCHAR2,
                             P_N_CODOPE NUMBER DEFAULT NULL,
                             P_C_CONFIR VARCHAR2,
                             P_C_NUMTRA VARCHAR2,
                             P_C_TRMREQ VARCHAR2,
                             P_C_TRMRES VARCHAR2,
                             P_N_TIMOUT NUMBER,
                             P_N_MONCOB NUMBER,
                             P_C_CODANU VARCHAR2,
                             P_C_CODMSG VARCHAR2,
                             P_N_CODTRA NUMBER,
                             p_c_coderr out varchar2,
                             p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_SO_ACTUALIZAR
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : ACTUALIZA DATOS EN EL LOG DE TRAMAS.
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_C_CODRES ( CODIGO DE RESPUESTA )
    --                              P_C_CODRST ( CODIGO DEL RESOLUTOR DE LA EMPRESA )
    --                              P_C_CODTRA ( CODIGO DE LA OPERACIÓN )
    --                              P_N_CODOPE ( NUMERO DE LA OPERACIÓN EN EL SORFY )
    --                              P_C_CONFIR ( CONFIRMACIÓN DE LA OPERACIÓN (EXTORNO) )
    --                              P_C_NUMTRA ( ID DE AUTORIZACIÓN )
    --                              P_C_TRMREQ ( TRAMA DE REQUERIMIENTO)
    --                              P_C_TRMRES ( TRAMA DE RESPUESTA )
    --                              P_N_TIMOUT ( CONTROL TIME OUT )
    --                              P_C_CODMSG ( CODIGO DEL MENSAJE )
    --                              P_N_CODTRA ( CODIGO DE LA TRANSACCIÓN )
    --
    -- *****************************************************************
   PRAGMA AUTONOMOUS_TRANSACTION;
--   val1 number;
--   val2 varchar2(10);   
  begin
    p_c_coderr := '0000';
    
    /*select JAQL517COMSG, JAQL517COTRA 
      into val1, val2
    from  JAQL517 
    where JAQL517COMSG = P_C_CODMSG
           and JAQL517COTRA = P_N_CODTRA-1;
    insert into   temp_pao (temp1,temp4)      values (val1,val2);
    commit;
   exception
     when others then
        insert into temp_pao (temp1,temp16) values (99999,'JK');
        commit;*/
    
    begin
     /* insert into temp_pao
        (TEMP1,
         TEMP2,
         TEMP3,
         TEMP4,
         TEMP5,
         TEMP6,
         TEMP7,
         TEMP8,
         TEMP9,
         TEMP10,
         TEMP11,
         TEMP12,
         TEMP13,
         TEMP14,
         TEMP15,
         TEMP16)
      values
        (P_N_CODTRA,--ok
         P_N_TIMOUT,--ok
         P_N_CODOPE,--ok
         P_C_CODMSG,--ok
         P_C_CODRES,--ok
         99999,
         P_C_TRMREQ,--ok
         P_C_TRMRES,--ok
         P_C_CODRST,--ok
         'J',
         P_C_CONFIR,--ok
         P_C_NUMTRA,--ok
         P_C_CODTRA,
         P_C_CODANU,
         to_char(P_N_MONCOB),
         'PRUEBAS_JK');
      commit;  
      */
/*        update JAQL517
           set JAQL517CORES = P_C_CODRES,
               JAQL517CORST = P_C_CODRST,
               JAQL517COOPE = P_C_CODTRA,
               JAQL517NUOPE = P_N_CODOPE,
               JAQL517CONFI = P_C_CONFIR,
               JAQL517NUTRA = P_C_NUMTRA,
               JAQL517TRREQ = P_C_TRMREQ,
               JAQL517TRRES = P_C_TRMRES,
               JAQL517TMOUT = P_N_TIMOUT,
               JAQL517MOCOB = P_N_MONCOB,
               JAQL517COANU = P_C_CODANU
               --
         where JAQL517COMSG = P_C_CODMSG
           and JAQL517COTRA = P_N_CODTRA;  */     
           --04.05.2017
           
           update JAQL517
           set JAQL517CORES = P_C_CODRES,
               JAQL517CORST = P_C_CODRST,
               JAQL517COOPE = P_C_CODTRA,
               JAQL517NUOPE = P_N_CODOPE,
               JAQL517CONFI = P_C_CONFIR,
               JAQL517NUTRA = P_C_NUMTRA,
               JAQL517TRREQ = P_C_TRMREQ,
               JAQL517TRRES = P_C_TRMRES,
               JAQL517TMOUT = P_N_TIMOUT,
               JAQL517MOCOB = P_N_MONCOB,
               JAQL517COANU = P_C_CODANU,
               --
               jaql517feres = trunc(sysdate) ,
               jaql517hores = to_char(sysdate , 'HH24:MI:ss')
         where JAQL517COMSG = P_C_CODMSG
           and JAQL517COTRA = P_N_CODTRA;             
       commit;      

    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
  end SP_SO_ACTUALIZAR;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_GETTRAMA(P_N_CODESV IN NUMBER,
                           P_N_CODTSV IN NUMBER,
                           P_C_NROCON IN VARCHAR2,
                           P_C_CODRST IN VARCHAR2,
                           P_C_CODCAN IN VARCHAR2,
                           P_C_CODTRA IN VARCHAR2,
                           P_C_CODUSU IN VARCHAR2,
                           P_C_TRMREQ OUT VARCHAR2,
                           P_C_TRMRES OUT VARCHAR2,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_SP_GETTRAMA
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : OBTIENE LAS TRAMAS DE REQUERIMIENTO Y RESPUESTA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CODESV ( CODIGO DE LA EMPRESA DE SERVICIO )
    --                              P_N_CODTSV ( CODIGO DEL TIPO DE SERVICIO DE LA EMPRESA )
    --                              P_C_NROCON ( CODIGO DE SUMINISTRO/CONTRATO )
    --                              P_C_CODRST ( CODIGO DEL RESOLUTOR DE LA EMPRESA )
    --                              P_C_CODCAN ( CODIGO DEL CANAL (MEDIO POR EL CUAL SE EFECTUA LA OPERACIÓN ) )
    --                              P_C_CODTRA ( CODIGO DE PROCESO )
    --                              P_C_CODUSU ( CODIGO DE USUARIO )
    --                              
    -- Parámetros de Salida       : P_C_TRMREQ ( TRAMA DE REQUERIMIENTO )
    --                            : P_C_TRMRES ( TRAMA DE RESPUESTA )
    --
    -- Fecha de Modificación      : 08/09/2013
    -- Autor de la Modificación   : chernandez
    -- Descripción de Modificación: Se agregó un rango de fecha para la obtención de la trama 
    --
  begin
  
    p_c_coderr := '0000';
    
    IF to_char(sysdate,'HH24') >='00' and to_char(sysdate,'HH24') <='04' THEN
    
      begin
        select a.jaql517trreq, a.jaql517trres
          into P_C_TRMREQ, P_C_TRMRES
          from (select a.jaql517trreq, a.jaql517trres
                  from jaql517 a
                 where jaql517coent = P_N_CODESV
                   and jaql517cotsv = P_N_CODTSV
                   and jaql517nrcon = P_C_NROCON
                   and jaql517corst = P_C_CODRST
                   and jaql517cocan = P_C_CODCAN
                   and jaql517coope = P_C_CODTRA
                   --and jaql517cousu = P_C_CODUSU                             
                   and jaql517feope >= trunc(sysdate)-1
                 order by jaql517cotra desc) a
                 where rownum <= 1;
      exception
        when no_data_found then
          p_c_msgerr := sqlerrm;
        when others then
          P_C_TRMREQ := '';
          P_C_TRMRES := '';
          p_c_coderr := sqlcode;
          p_c_msgerr := sqlerrm;
      end;
      
    else
        begin  
             select a.jaql517trreq, a.jaql517trres
              into P_C_TRMREQ, P_C_TRMRES
              from (select a.jaql517trreq, a.jaql517trres
                      from jaql517 a
                     where jaql517coent = P_N_CODESV
                       and jaql517cotsv = P_N_CODTSV
                       and jaql517nrcon = P_C_NROCON
                       and jaql517corst = P_C_CODRST
                       and jaql517cocan = P_C_CODCAN
                       and jaql517coope = P_C_CODTRA
                     --  and jaql517cousu = P_C_CODUSU                             
                       and jaql517feope = trunc(sysdate)
                     order by jaql517cotra desc) a
                     where rownum <= 1;
                
        exception
          when no_data_found then
            p_c_msgerr := sqlerrm;
          when others then
            P_C_TRMREQ := '';
            P_C_TRMRES := '';
            p_c_coderr := sqlcode;
            p_c_msgerr := sqlerrm;
        end;
      
      end if;
  
  end SP_SO_GETTRAMA;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_GETVALORES_ANULACION(P_N_CODOPE IN NUMBER,
                                       P_N_MONCOB OUT VARCHAR2,
                                       P_C_CODCAN OUT VARCHAR2,
                                       P_C_NUMTRA OUT VARCHAR2,
                                       P_C_CODUSU OUT VARCHAR2,
                                       P_C_NROCON OUT VARCHAR2,
                                       P_N_CODESV OUT VARCHAR2,
                                       P_N_CODTSV OUT VARCHAR2,
                                       P_C_CODANU OUT VARCHAR2,
                                       p_c_coderr out varchar2,
                                       p_c_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : SP_SO_GETVALORES_ANULACION
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : OBTIENE LAS TRAMAS DE REQUERIMIENTO Y RESPUESTA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CODESV ( CODIGO DE LA EMPRESA DE SERVICIO )
    --                              P_N_CODTSV ( CODIGO DEL TIPO DE SERVICIO DE LA EMPRESA )
    --                              P_C_NROCON ( CODIGO DE SUMINISTRO/CONTRATO )
    --                              P_C_CODRST ( CODIGO DEL RESOLUTOR DE LA EMPRESA )
    --                              P_C_CODCAN ( CODIGO DEL CANAL (MEDIO POR EL CUAL SE EFECTUA LA OPERACIÓN ) )
    --                              P_C_CODTRA ( CODIGO DE PROCESO )
    --                              
    -- Parámetros de Salida       : P_C_TRMREQ ( TRAMA DE REQUERIMIENTO )
    --                            : P_C_TRMRES ( TRAMA DE RESPUESTA )
    --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  
  begin
  
    p_c_coderr := '0000';
  
    begin
      --      
      select jaql517mocob,
             jaql517cocan,
             jaql517nutra,
             jaql517cousu,
             jaql517nrcon,
             jaql517coent,
             jaql517cotsv,
             jaql517coanu
        into P_N_MONCOB,
             P_C_CODCAN,
             P_C_NUMTRA,
             P_C_CODUSU,
             P_C_NROCON,
             P_N_CODESV,
             P_N_CODTSV,
             P_C_CODANU
        from jaql517
       where jaql517nuope = P_N_CODOPE;
    
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
  
  end SP_SO_GETVALORES_ANULACION;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure SP_SO_UPDATE_NROTRANSACCION(P_N_CODTRA IN NUMBER,
                                        P_N_CODOPE IN NUMBER,
                                        p_c_coderr out varchar2,
                                        p_c_msgerr out varchar2)
  
    -- *****************************************************************
    -- Nombre                     : SP_SO_UPDATE_NROTRANSACCION
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : ACTUALIZA LA TRAMA DE PAGO CON EL CODIGO GENERADO EN EL SORFY
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CODTRA ( CODIGO ÚNICO DE LA TRANSACCIÓN )
    --                              P_N_CODOPE ( CODIGO DE TRANSACCIÓN EN LA TEDTRAN T TEDTRAD )
    --                              
    -- Parámetros de Salida       : p_c_coderr ( TRAMA DE REQUERIMIENTO )
    --                            : p_c_msgerr ( TRAMA DE RESPUESTA )
    --
    -- Fecha de Modificación      : 04/04/2011
    -- Autor de la Modificación   : jaguilar
    -- Descripción de Modificación: PRAGMA AUTONOMOUS_TRANSACTION;
    --
    -- *****************************************************************
   is
  
    PRAGMA AUTONOMOUS_TRANSACTION;
  
  begin
    p_c_coderr := '0000';
  
    begin
      update jaql517
         set jaql517NUOPE = P_N_CODOPE
       where jaql517COTRA = P_N_CODTRA;
    
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
    commit;
  
  exception
    when others then
      null;
  end SP_SO_UPDATE_NROTRANSACCION;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_CONFIRMA_EXTORNO(P_N_CODTRA IN NUMBER,
                                   P_C_CONFIR IN VARCHAR2,
                                   p_c_coderr out varchar2,
                                   p_c_msgerr out varchar2)
  -- *****************************************************************
    -- Nombre                     : SP_SO_CONFIRMA_EXTORNO
    -- Sistema                    : SORFY
    -- Módulo                     : Servicios ON-LINE
    -- Versión                    : 1.0
    -- Fecha de Creación          : 31/08/2010
    -- Autor de Creación          : Jeankharlo Pinto Espejo
    -- Uso                        : ACTUALIZA LA TRAMA DE PAGO CON EL CODIGO GENERADO EN EL SORFY
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_N_CODTRA ( CODIGO ÚNICO DE LA TRANSACCIÓN )
    --                              P_C_CONFIR ( CODIGO DE CONFIRMACIÓN DE EXTRONO OPOR UNEXOS )
    --                              
    -- Parámetros de Salida       : p_c_coderr ( TRAMA DE REQUERIMIENTO )
    --                            : p_c_msgerr ( TRAMA DE RESPUESTA )
    --
    -- Fecha de Modificación      : 04/04/2011
    -- Autor de la Modificación   : jaguilar 
    -- Descripción de Modificación: PRAGMA AUTONOMOUS_TRANSACTION;
    --
    -- *****************************************************************
   is
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    p_c_coderr := '0000';
  
    begin
      update jaql517
         set jaql517CONFI = P_C_CONFIR
       where jaql517COTRA = P_N_CODTRA;
    
    exception
      when others then
        p_c_coderr := sqlcode;
        p_c_msgerr := sqlerrm;
    end;
    commit;
  
  exception
    when others then
      null;
  end SP_SO_CONFIRMA_EXTORNO;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_GET_NCODTRA(P_N_CODTRA OUT NUMBER) 
    is
     PRAGMA AUTONOMOUS_TRANSACTION;
  begin
  
    -- SORFY
    --select SQ_AH_JAQL517.Nextval into P_N_CODTRA from dual;
    
    -- BANTOTAL
    --select /*+parallel(a,2,1)  choose*/ max(a.JAQL517COTRA) + 1 into P_N_CODTRA from JAQL517 a;
    --//
    select /*+parallel(a,4,1)*/
           a.TP1NRO1 + 1
      into P_N_CODTRA
      from fst198 a
     where a.tp1cod = 1
       and a.tp1cod1 = 10800
       and a.tp1corr1 = 5
       and a.tp1corr2 = 9000
       and a.tp1corr3 = 3;
    --//
    update fst198
       set TP1NRO1 = P_N_CODTRA
     where tp1cod = 1
       and tp1cod1 = 10800
       and tp1corr1 = 5
       and tp1corr2 = 9000
       and tp1corr3 = 3;
       
    commit; 
  
  end SP_SO_GET_NCODTRA;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure SP_SO_RESTART_SEQUENCE(P_N_CODTRA IN NUMBER,
                                   P_N_NROVTA OUT NUMBER) is
  
    ln_codtra number;
  begin
  
    ln_codtra := P_N_CODTRA;
  
    if P_N_CODTRA >= 999998 then
    
      Execute Immediate 'Alter sequence  SQ_AH_JAQL517 increment by - ' ||
                        TO_CHAR(ln_codtra);
      Execute Immediate 'Select SQ_AH_JAQL517.nextval from dual '
        Into ln_codtra;
      Execute Immediate 'Alter sequence SQ_AH_JAQL517 increment by 1';
    
      begin
        --
        select max(jaql517nrvta) + 1 into P_N_NROVTA from jaql517;
      exception
        when others then
          null;
      end;
    else
      --
      begin
        --
        select nvl(max(jaql517nrvta), 1) into P_N_NROVTA from jaql517;
      exception
        when others then
          null;
      end;
      --       
    end if;
  
  end SP_SO_RESTART_SEQUENCE;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  /*Hlaqui 11/05/2017*/
  procedure SP_SO_MIGRA_HISTORICO is
    cursor c_jaql517 is
        select jaql517cotra, jaql517nrvta, jaql517comsg, jaql517cores, 
    jaql517corst, jaql517feope, jaql517hoope, jaql517cocan, jaql517cousu, 
    jaql517coent, jaql517cotsv, jaql517nrcon, jaql517coope, jaql517nuope, 
    jaql517confi, jaql517nutra, jaql517mocob, jaql517coanu, jaql517tmout, 
    jaql517trreq, jaql517trres, jaql517itmod, jaql517ttran, jaql517itsuc,
    jaql517feres, jaql517hores
    from jaql517;
    begin
      begin
        for f in c_jaql517 loop
          insert into jaql517h(
          jaql517hcotra, jaql517hnrvta, jaql517hcomsg, jaql517hcores, 
          jaql517hcorst, jaql517hfeope, jaql517hhoope, jaql517hcocan, jaql517hcousu, 
          jaql517hcoent, jaql517hcotsv, jaql517hnrcon, jaql517hcoope, jaql517hnuope, 
          jaql517hconfi, jaql517hnutra, jaql517hmocob, jaql517hcoanu, jaql517htmout, 
          jaql517htrreq, jaql517htrres, jaql517hitmod, jaql517httran, jaql517hitsuc, 
          jaql517hferes, jaql517hhores
          )
          values(
          f.jaql517cotra, f.jaql517nrvta, f.jaql517comsg, f.jaql517cores, 	
          f.jaql517corst, f.jaql517feope, f.jaql517hoope, f.jaql517cocan, f.jaql517cousu, 
          f.jaql517coent, f.jaql517cotsv, f.jaql517nrcon, f.jaql517coope, f.jaql517nuope,
          f.jaql517confi, f.jaql517nutra, f.jaql517mocob, f.jaql517coanu, f.jaql517tmout, 
          f.jaql517trreq, f.jaql517trres, f.jaql517itmod, f.jaql517ttran, f.jaql517itsuc,
          f.jaql517feres, f.jaql517hores);
        end loop;
        commit;
        
        for f in c_jaql517 loop
          delete from jaql517 a 
          where a.jaql517cotra = f.jaql517cotra and a.jaql517nrvta=f.jaql517nrvta;          
        end loop;
        commit;
      
      end SP_SO_MIGRA_HISTORICO;
    end;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  

END PQ_AH_JAQL517;
/

