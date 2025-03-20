create or replace package pq_cr_aprobacion_reprog_hs is

  -- Author  : HSUAREZ
  -- Created : 18/09/2021 18:48:47
  -- Purpose :
  -- MOdificacion: Hsuarez
  -- Fecha Modificacion: 27/09/2023 12:52
  -- Contenido: Se agrego una validacion para considerar los de BI sin consultar a CRM.
  -- MODIFICACION: MCHAVEZ
  -- FECHA MODIFICACION: 04/01/2024
  -- CONTENIDO: SE MODIFICO LA VALIDACION QUE VALIDA SI HAY UN PAGO POSTERIOR ANTES DE 
  --            LA APROBACION DEL CRONOGRAMA PROPUESTO.
  -- FECHA MODIFICACION: 26/01/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE AGREGO VALIDACION DE ARBOL DE APROBACION PARA REPROGRAMADOS GENERAL.
  -- FECHA MODIFICACION: 29/01/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE AGREGO VALOR ABSOLUTO AL RANGO DE APROBACION.
  -- FECHA MODIFICACION: 15/03/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE MODIFICO LOS PROCEDIMIENTOS
  -- FECHA MODIFICACION: 09/05/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE MODIFICO EL PROCEDIMIENTO DE ARBOL DE APROBACION, SE QUITO LA VALIDACION DE AUTONOMIA.
  -- FECHA MODIFICACION: 12/06/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE MODIFICO EL PROCEDIMIENTO DE ARBOL DE APROBACION, SE AGREGO ARBOL MULTINIVEL, 
  -- SE MEJORR EL PERFIL DE APROBACIONES
  -- FECHA MODIFICACION: 17/09/2024
  -- MODIFICACION : HSUAREZ
  -- CONTENIDO: SE MODIFICO EL PROCEDIMIENTO DARA AGREGAR EXCEPCION A LA REGLA DE CONTROL DE DIAS, 
  -- SE MEJORR EL PERFIL DE APROBACIONES
  PROCEDURE sp_validar_reprog(VE_COD  IN NUMBER,
                              VE_INST IN NUMBER,
                              VE_PAIS IN NUMBER,
                              VE_PTDC IN NUMBER,
                              VE_DNI  IN VARCHAR2,
                              
                              VE_EMP  IN NUMBER,
                              VE_MOD  IN NUMBER,
                              VE_SUC  IN NUMBER,
                              VE_MDA  IN NUMBER,
                              VE_PAP  IN NUMBER,
                              VE_CTA  IN NUMBER,
                              VE_OPER IN NUMBER,
                              VE_SBOP IN NUMBER,
                              VE_TOPE IN NUMBER,
                              
                              VE_USUARIO   IN VARCHAR,
                              VE_FLAG_RPTA OUT VARCHAR2,
                              VE_RPTA_MSJ  OUT VARCHAR2);
  PROCEDURE SP_BLOQ_INST_CONT(vINST IN NUMBER, SC_RUB OUT VARCHAR);
  PROCEDURE SP_INST_CONT_CRE_EST(vINST IN NUMBER, SC_RUB OUT VARCHAR);
  procedure SP_INST_CONT_CRE_OPE(vINST in number, SC_RUB out varchar);
  procedure SP_INST_CONT_CRE_MOD(vINST in number, SC_RUB out varchar);
  PROCEDURE sp_validar_reprog_pagosMismoDia(VE_EMP       IN NUMBER,
                                            VE_MOD       IN NUMBER,
                                            VE_SUC       IN NUMBER,
                                            VE_MDA       IN NUMBER,
                                            VE_PAP       IN NUMBER,
                                            VE_CTA       IN NUMBER,
                                            VE_OPER      IN NUMBER,
                                            VE_SBOP      IN NUMBER,
                                            VE_TOPE      IN NUMBER,
                                            VE_FLAG_RPTA OUT VARCHAR2,
                                            VE_RPTA_MSJ  OUT VARCHAR2);
  PROCEDURE sp_validar_reprog_aprobada(VE_EMPRESA      NUMBER,
                                       VE_MODULO       NUMBER,
                                       VE_SUCURSAL     NUMBER,
                                       VE_MONEDA       NUMBER,
                                       VE_PAPEL        NUMBER,
                                       VE_CUENTA       NUMBER,
                                       VE_OPERACION    NUMBER,
                                       VE_SUBOPERACION NUMBER,
                                       VE_TIPODEOPERAC NUMBER,
                                       VE_INSTANCIA    NUMBER,
                                       VE_FECHAREPRG   DATE,
                                       
                                       VO_TAREA     OUT VARCHAR,
                                       VO_ESTADO    OUT VARCHAR,
                                       VO_APROBADOR OUT VARCHAR,
                                       VO_FHASIG    OUT TIMESTAMP,
                                       VO_FHAPR     OUT TIMESTAMP);
  PROCEDURE sp_validar_reprog_ab(VE_INSTANCIA  NUMBER,
                                 VE_FECHAREPRG DATE,
                                 VO_ABENEFICIO OUT VARCHAR,
                                 VO_TAREA      OUT VARCHAR,
                                 VO_ESTADO     OUT VARCHAR,
                                 VO_APROBADOR  OUT VARCHAR,
                                 VO_FHASIG     OUT TIMESTAMP,
                                 VO_FHAPR      OUT TIMESTAMP);
  PROCEDURE SP_VALIDAR_APROBADOR_RPG(VE_CODIGO    IN NUMBER,
                                     VE_INSTANCIA IN NUMBER,
                                     ve_sucur     in number,
                                     VE_UBUSER    IN VARCHAR,
                                     VO_RPTA      OUT VARCHAR,
                                     VO_COD_MSG   OUT NUMBER,
                                     VO_MSG       OUT VARCHAR);
                                
  PROCEDURE SP_VALIDAR_APROBADOR_RPGM(VE_CODIGO     IN NUMBER,
                                      VE_VISUALIZAR IN VARCHAR,
                                      VE_INSTANCIA  IN NUMBER,                                      
                                      ve_sucur      IN number,
                                      VE_UBUSER     IN VARCHAR,
                                      VO_RPTA       OUT VARCHAR,
                                      VO_COD_MSG    OUT NUMBER,
                                      VO_MSG        OUT VARCHAR);
                                     
  PROCEDURE SP_VALIDAR_APROB_PERFIL(
                                     vi_cargo in number,
                                     vi_perfilc in varchar,
                                     ve_suc in number,
                                     vo_aprobador out varchar
                                   );                                    
end pq_cr_aprobacion_reprog_hs;
/

create or replace package body pq_cr_aprobacion_reprog_hs is
  PROCEDURE sp_validar_reprog(VE_COD  IN NUMBER,
                              VE_INST IN NUMBER,
                              VE_PAIS IN NUMBER,
                              VE_PTDC IN NUMBER,
                              VE_DNI  IN VARCHAR2,
                              
                              VE_EMP  IN NUMBER,
                              VE_MOD  IN NUMBER,
                              VE_SUC  IN NUMBER,
                              VE_MDA  IN NUMBER,
                              VE_PAP  IN NUMBER,
                              VE_CTA  IN NUMBER,
                              VE_OPER IN NUMBER,
                              VE_SBOP IN NUMBER,
                              VE_TOPE IN NUMBER,
                              
                              VE_USUARIO   IN VARCHAR,
                              VE_FLAG_RPTA OUT VARCHAR2,
                              VE_RPTA_MSJ  OUT VARCHAR2) IS
    FECHA_SISTEMA DATE;
    FECHA_AQPB556 DATE;
    VI_JAQA400FEC DATE;
  
    VI_VAL_FECHA    VARCHAR(1);
    VI_VAL_PERM_TRS VARCHAR(1);
    VI_FLAG_TRN     NUMBER(10);
    VI_TIPO_RPG     NUMBER(3);
  
    VI_CONTROLAR_TRN        number(10);
    FLAG_CONTROLAR_TRN_TPRG NUMBER(3);
    FLAG_CONTROLAR_CRM      number(3);
    vi_permiso_trn          varchar(1);
    VE_RPTAC                VARCHAR(10);
    ------
    vi_cant_bi     NUMBER(9);
    VE_NRO_RPG     NUMBER(9);
    VE_CARGO_APROB NUMBER(9);
    VE_APROBADOR   VARCHAR(20);
    VE_RPTA        VARCHAR(10);
    ------
    
    EXCEPCION_G VARCHAR2(1);
    EXCEPCION_U VARCHAR2(1);
    VI_EXCEPCION_D VARCHAR2(1);
    VIO_RPTA_DESACTIVA_REG VARCHAR(4);
    VIO_EXCEPCION          VARCHAR(4);
    
  BEGIN
  
    --VALIDAR QUE LA REPROGRAMACION SEA DEL MISMO DIA
    BEGIN
      --FECHA SISTEMA
      BEGIN
        SELECT PGFAPE INTO FECHA_SISTEMA FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          FECHA_SISTEMA := NULL;
      END;
      BEGIN
        SELECT TRUNC(AQPB556FECR)
          INTO FECHA_AQPB556
          FROM AQPB556
         WHERE AQPB556COD = VE_COD
           AND AQPB556INST = VE_INST
           AND AQPB556EST = 'P';
      EXCEPTION
        WHEN OTHERS THEN
          FECHA_AQPB556 := NULL;
      END;
      --GUIA PARA EXCEPTUAR CONTROL DE REPROGRAMACION EL MISMO DIA.
      BEGIN
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(1,
                                                         VE_INST,
                                                         'DIFERENTEDIA',
                                                         '-',
                                                         94,
                                                         VIO_RPTA_DESACTIVA_REG,
                                                         VIO_EXCEPCION);            
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --
      BEGIN
        VI_JAQA400FEC := NULL;
      
        SELECT JAQA400FEC
          INTO VI_JAQA400FEC
          FROM JAQA400
         WHERE JAQA400AI1 = VE_INST
           AND JAQA400EMP = VE_EMP
           AND JAQA400MOD = VE_MOD
           AND JAQA400SUC = VE_SUC
           AND JAQA400CTA = VE_CTA
           AND JAQA400OPE = VE_OPER
           AND JAQA400SBO = VE_SBOP
           AND JAQA400TOP = VE_TOPE
           AND JAQA400EST = 'A'
           AND JAQA400FEC = FECHA_SISTEMA;
      EXCEPTION
        WHEN OTHERS THEN
          VI_JAQA400FEC := NULL;
      END;
      VI_VAL_FECHA := 'N';
      IF VI_JAQA400FEC = FECHA_SISTEMA OR VIO_EXCEPCION = 'S' OR VIO_EXCEPCION = 'S' THEN
        VI_VAL_FECHA := 'S';
      ELSE
        VI_VAL_FECHA := 'N';
        VE_RPTA_MSJ  := 'SOLO SE PUEDE REPROGRAMAR EL MISMO DIA, QUE SE GENERO LA EVALUACION';
      END IF;
    END;
    --VALIDAR QUE EL USUARIO CUENTE CON PERFIL PARA EJECUTAR
    --TRANSACCIONES
    --REVISAR  TIPO DE REPROGRAMACION
    BEGIN
      SELECT AQPB556TPRG
        INTO VI_TIPO_RPG
        FROM AQPB556
       WHERE AQPB556COD = VE_COD
         AND AQPB556INST = VE_INST
         AND TRUNC(AQPB556FECR) = FECHA_SISTEMA;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          SELECT AQPB556TPRG
            INTO VI_TIPO_RPG
            FROM AQPB556
           WHERE AQPB556COD = VE_COD
             AND AQPB556INST = VE_INST;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
    END;
    --VALIDAR USUARIO TENGA PERMISO
    BEGIN
      VI_FLAG_TRN := 0;
    
      SELECT PT.MODULO
        INTO VI_FLAG_TRN
        FROM PRFU00 P, PRFT00 PT
       WHERE P.PGCOD = PT.PGCOD
         AND P.PRFGCOD = PT.PRFGCOD
         AND PT.MODULO = 98
         AND PT.TRNRO = 579
         AND P.UBUSER = RPAD(TRIM(VE_USUARIO), 10, ' ')
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        VI_FLAG_TRN := 0;
    END;
    BEGIN
      --VALIDAR GUIA ESPECIAL SI DEBO CONTROLAR 
      VI_CONTROLAR_TRN := 0;
      BEGIN
        SELECT TP1NRO1
          INTO VI_CONTROLAR_TRN --SI ES 1 CONTROLA CASO CONTRARIO NO.
          FROM FST198 T
         WHERE T.TP1COD = 1
           AND T.TP1COD1 = 10899
           AND T.TP1CORR1 = 400000
           AND T.TP1CORR2 = 200
           AND T.TP1CORR3 = 1;
      EXCEPTION
        WHEN OTHERS THEN
          VI_CONTROLAR_TRN := 0;
      END;
      IF VI_CONTROLAR_TRN = 1 THEN
        vi_permiso_trn := 'N';
        begin
          SELECT f.ubting
            INTO vi_permiso_trn
            FROM fst048 F
           WHERE F.PGCOD = 1
             AND F.UBUSER = RPAD(TRIM(VE_USUARIO), 10, ' ')
             AND F.MODULO = 98
             AND F.TRNRO = 579
             AND F.UBTING = 'S'
             AND F.UBTCON = 'S'
             AND ROWNUM = 1;
        exception
          when others then
            vi_permiso_trn := 'N';
        end;
        IF vi_permiso_trn = 'S' THEN
          VI_FLAG_TRN := 1;
        ELSE
          VI_FLAG_TRN := 0;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
    --VALIDAR SI DEBE CONTROLAR TRN POR TIPO DE REPROGRAMACION
    FLAG_CONTROLAR_TRN_TPRG := 0;
    BEGIN
      SELECT TP1NRO2
        INTO FLAG_CONTROLAR_TRN_TPRG --SI ES 1 CONTROLA CASO CONTRARIO NO.
        FROM FST198 T
       WHERE T.TP1COD = 1
         AND T.TP1COD1 = 10899
         AND T.TP1CORR1 = 400000
         AND T.TP1CORR2 = 201
         AND T.TP1CORR3 > 0
         AND T.TP1NRO1 = VI_TIPO_RPG;
    EXCEPTION
      WHEN OTHERS THEN
        FLAG_CONTROLAR_TRN_TPRG := 0;
    END;
    VI_VAL_PERM_TRS := 'S';
    IF FLAG_CONTROLAR_TRN_TPRG > 0 THEN
      IF VI_FLAG_TRN > 0 THEN
        VI_VAL_PERM_TRS := 'S';
      ELSE
        VI_VAL_PERM_TRS := 'N';
        VE_RPTA_MSJ     := 'NO TIENE PERMISOS PARA EJECUTAR LA TRANSACCION 98-579 PARA EL DEVENGAMIENTO DEL INTERES';
      END IF;
    END IF;
    ---VALIDAR REPROGRAMADOS QUE ESTEN VIGENTES Y EN BT 
    --Cambio agregado 01/10/2021
    PQ_CR_RT_REPROGRAMACION.sp_cr_existe_credito_crm(VE_INST, VE_RPTAC);
    PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(1,
                                               'REPRO_IND_CRM', --variable
                                               VE_RPTAC, --valor
                                               92, --regla
                                               VE_INST --instancia                                                   
                                               );
    --AGREGADO CONTROL PARA VALIDAR SI ESTA EN BI.  HSUAREZ@2023.09.27
    IF VE_RPTAC = 'N' THEN
      BEGIN
        --COLOCAR PAQUETE.
        --AGREGAR PAQUETE PARA VALIDAR.
        pq_cr_validar_rng_reprog.SP_VALIDAR_LISTA_BI(VE_INST,
                                                     VE_NRO_RPG,
                                                     VE_CARGO_APROB,
                                                     VE_APROBADOR,
                                                     VE_RPTA);
        IF VE_CARGO_APROB > 201 THEN
          VE_RPTAC := 'S';
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    --FIN DE AGREGADO PARA VALIDAR SI ESTA EN BI.
    BEGIN
      SELECT TP1NRO2
        INTO FLAG_CONTROLAR_CRM --SI ES 1 CONTROLA CASO CONTRARIO NO.
        FROM FST198 T
       WHERE T.TP1COD = 1
         AND T.TP1COD1 = 10899
         AND T.TP1CORR1 = 400000
         AND T.TP1CORR2 = 202
         AND T.TP1CORR3 > 0
         AND T.TP1NRO1 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        FLAG_CONTROLAR_CRM := 0;
    END;
    IF trim(ve_rptac) <> 'N' THEN
      --VE_MENSAJE:= '';
      NULL;
    ELSE
      IF FLAG_CONTROLAR_CRM = 1 and VI_TIPO_RPG <>10 THEN
        VE_RPTA_MSJ := 'RNG: No tiene CRM gestionado, o el cliente cancelo la gestión en CRM';
      END IF;
      --DESCOMENTAR 19092021 
    
    END IF;
    ----------controles adicionales----------------
    BEGIN
      ---VALIDAR REPROGRAMADOS QUE ESTEN VIGENTES Y EN BT 
      --Cambio agregado 01/10/2021
      PQ_CR_APROBACION_REPROG_HS.SP_BLOQ_INST_CONT(VE_INST, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(1,
                                                 'BLOQ_PAGO_POST', --variable
                                                 VE_RPTAC, --valor
                                                 92, --regla
                                                 VE_INST --instancia                                                   
                                                 );
      
      EXCEPCION_G := NULL;
      EXCEPCION_U := NULL;
      BEGIN
         PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO         => 1,
                                                        VE_INSTANCIA   => VE_INST,
                                                        VE_VARIABLE    => 'BLOQ_PAGO_POST',
                                                        VE_RPTAC       => VE_RPTAC,
                                                        VE_COD_REGLA   => 92,
                                                        VE_EXCEPCION_G => EXCEPCION_G,
                                                        VE_EXCEPTION_U => EXCEPCION_U);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      IF trim(ve_rptac) <> 'N' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF FLAG_CONTROLAR_CRM = 1 AND EXCEPCION_G = 'N' AND EXCEPCION_U = 'N' THEN
          VE_RPTA_MSJ := 'RNG: Existen pagos posteriores a la aprobación del credito reprogramado, debe volver a reprogramar';
        END IF;
        --DESCOMENTAR 19092021 
      
      END IF;
    END;
  
    BEGIN
      PQ_CR_APROBACION_REPROG_HS.SP_INST_CONT_CRE_EST(VE_INST, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(1,
                                                 'BLOQ_ESTADO_CRD', --variable
                                                 VE_RPTAC, --valor
                                                 92, --regla
                                                 VE_INST --instancia                                                   
                                                 );
    
      IF trim(ve_rptac) <> 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF FLAG_CONTROLAR_CRM = 1 THEN
          VE_RPTA_MSJ := 'RNG: Este crédito no se puede reprogramar, tiene un estado no permitido para reprogramados';
        END IF;
        --DESCOMENTAR 19092021           
      END IF;
    END;
    BEGIN
      PQ_CR_APROBACION_REPROG_HS.SP_INST_CONT_CRE_MOD(VE_INST, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(1,
                                                 'BLOQ_MOD_CRD', --variable
                                                 VE_RPTAC, --valor
                                                 92, --regla
                                                 VE_INST --instancia                                                   
                                                 );
    
      IF trim(ve_rptac) <> 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF FLAG_CONTROLAR_CRM = 1 THEN
          VE_RPTA_MSJ := 'RNG: Este crédito no se puede reprogramar, tiene un modulo no permitido para reprogramados';
        END IF;
        --DESCOMENTAR 19092021           
      END IF;
    END;
    BEGIN
      PQ_CR_APROBACION_REPROG_HS.SP_INST_CONT_CRE_OPE(VE_INST, VE_RPTAC);
      PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LOG_RNG(1,
                                                 'BLOQ_MOD_TOPE', --variable
                                                 VE_RPTAC, --valor
                                                 92, --regla
                                                 VE_INST --instancia                                                   
                                                 );
    
      IF trim(ve_rptac) <> 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF FLAG_CONTROLAR_CRM = 1 THEN
          VE_RPTA_MSJ := 'RNG: Este crédito no se puede reprogramar, tiene un tipo de operacion no permitido para reprogramados';
        END IF;
        --DESCOMENTAR 19092021           
      END IF;
    END;
    -----------------------------------------------
    IF VI_VAL_FECHA = 'S' AND VI_VAL_PERM_TRS = 'S' and VE_RPTA_MSJ IS NULL THEN
      VE_FLAG_RPTA := 'S';
    ELSE
      VE_FLAG_RPTA := 'N';
    END IF;
  
  END;

  PROCEDURE SP_BLOQ_INST_CONT(vINST IN NUMBER, SC_RUB OUT VARCHAR) IS
    VI_EMP XWF700.XWFEMPRESA%TYPE;
    VI_SUC XWF700.XWFSUCURSAL%TYPE;
    VI_MOD XWF700.XWFMODULO%TYPE;
    VI_MDA XWF700.XWFMONEDA%TYPE;
    VI_PAP XWF700.XWFPAPEL%TYPE;
    VI_CTA XWF700.XWFCUENTA%TYPE;
    VI_OPE XWF700.XWFOPERACION%TYPE;
    VI_SBO XWF700.XWFSUBOPE%TYPE;
    VI_TOP XWF700.XWFTIPOPE%TYPE;
  
    CONTA                NUMBER;
    FECHP                VARCHAR(20);
    EMPRESA              NUMBER(3);
    SUCURSAL_TRANSACCION NUMBER(3);
    MODULO_TRANSACCION   NUMBER(3);
    TRANSACCION          NUMBER(3);
    RELACION             NUMBER(4);
    FECHA_MAXIMA         DATE;
    CONTADOR             NUMBER(9);
  
    --OBTENER CLAVE DEL CRÉDITO --
  BEGIN
    --INSERT INTO PRUEBA_LOG(Msg)values('inst:'||vINST);
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = vINST
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- OBTENER FECHA/HORA/PAGO --
    BEGIN
       SELECT D602CD, D602SU, D602MO, D602TR, D602RE
         INTO EMPRESA,
              SUCURSAL_TRANSACCION,
              MODULO_TRANSACCION,
              TRANSACCION,
              RELACION
         FROM FSD602
        WHERE PGCOD  = VI_EMP
          AND PPSUC  = VI_SUC
          AND PPMOD  = VI_MOD
          AND PPPAP  = VI_PAP
          AND PPMDA  = VI_MDA
          AND PPCTA  = VI_CTA
          AND PPOPER = VI_OPE
          AND PPSBOP = VI_SBO
          AND PPTOPE = VI_TOP
          AND D602CO = 'S'
          AND D602FC = (SELECT PGFAPE 
                          FROM FST017 
                         WHERE PGCOD = 1)
          AND ROWNUM = 1;
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
    BEGIN
      SELECT TO_CHAR(ITFCON, 'DD/MM/RR') || ' ' || ITHORA
        INTO FECHP
        FROM FSD015 A
       WHERE A.PGCOD  = EMPRESA
         AND A.ITSUC  = SUCURSAL_TRANSACCION
         AND A.ITMOD  = MODULO_TRANSACCION
         AND A.ITTRAN = TRANSACCION
         AND A.ITNREL = RELACION
         AND A.ITFCON = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)
         AND A.ITHORA = (SELECT MAX(ITHORA)
                           FROM FSD015 B
                          WHERE B.PGCOD  = EMPRESA
                            AND B.ITSUC  = SUCURSAL_TRANSACCION
                            AND B.ITMOD  = MODULO_TRANSACCION
                            AND B.ITTRAN = TRANSACCION
                            AND B.ITNREL = RELACION
                            AND B.ITFCON = A.ITFCON);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- COMPARAR FECHA/HORA/APROBACION CON FECHA/HORA/PAGO --
    CONTA := 0;
    BEGIN
      SELECT COUNT(*)
        INTO CONTA
        FROM AQPB556 A
       WHERE A.AQPB556INST = vINST
         AND A.AQPB556FECC < TO_TIMESTAMP(FECHP, 'DD/MM/RR HH24:MI:SS,FF')
         AND A.AQPB556EHAB = 'H'
         AND A.AQPB556EST  = 'P';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      IF CONTA > 0 THEN
        SC_RUB := 'N';
      ELSE
        SC_RUB := 'S';
      END IF;
    END;
    IF SC_RUB = 'S' THEN
      BEGIN
        SELECT MAX(PPFPAG)
          INTO FECHA_MAXIMA
          FROM FSD602
         WHERE PGCOD  = VI_EMP
           AND PPSUC  = VI_SUC
           AND PPMOD  = VI_MOD
           AND PPPAP  = VI_PAP
           AND PPMDA  = VI_MDA
           AND PPCTA  = VI_CTA
           AND PPOPER = VI_OPE
           AND PPSBOP = VI_SBO
           AND PPTOPE = VI_TOP
           AND D602CO = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      CONTADOR := 0;
      BEGIN
        SELECT COUNT(*)
          INTO CONTADOR
          FROM FSD601
         WHERE PGCOD  = VI_EMP
           AND PPSUC  = VI_SUC
           AND PPMOD  = VI_MOD
           AND PPPAP  = VI_PAP
           AND PPMDA  = VI_MDA
           AND PPCTA  = VI_CTA
           AND PPOPER = VI_OPE
           AND PPSBOP = 609
           AND PPTOPE = VI_TOP
           AND PPFPAG = (SELECT MIN(PPFPAG)
                           FROM FSD601
                          WHERE PGCOD  = VI_EMP
                            AND PPSUC  = VI_SUC
                            AND PPMOD  = VI_MOD
                            AND PPPAP  = VI_PAP
                            AND PPMDA  = VI_MDA
                            AND PPCTA  = VI_CTA
                            AND PPOPER = VI_OPE
                            AND PPSBOP = 609
                            AND PPTOPE = VI_TOP
                            AND PPFVAL < FECHA_MAXIMA
                            AND PPFPAG > FECHA_MAXIMA);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF CONTADOR > 0 THEN
        SC_RUB := 'N';
      ELSE
        SC_RUB := 'S';
      END IF;
    END IF;
  END SP_BLOQ_INST_CONT;

  PROCEDURE SP_INST_CONT_CRE_EST(vINST IN NUMBER, SC_RUB OUT VARCHAR) IS
    VI_EMP XWF700.XWFEMPRESA%TYPE;
    VI_SUC XWF700.XWFSUCURSAL%TYPE;
    VI_MOD XWF700.XWFMODULO%TYPE;
    VI_MDA XWF700.XWFMONEDA%TYPE;
    VI_PAP XWF700.XWFPAPEL%TYPE;
    VI_CTA XWF700.XWFCUENTA%TYPE;
    VI_OPE XWF700.XWFOPERACION%TYPE;
    VI_SBO XWF700.XWFSUBOPE%TYPE;
    VI_TOP XWF700.XWFTIPOPE%TYPE;
  
    CONTA   NUMBER;
    CRE_EST NUMBER;
  
    -- OBTENER CLAVE DEL CRÉDITO --
  BEGIN
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = vINST
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- OBTENER AOSTAT -- 
    BEGIN
      SELECT AOSTAT
        INTO CRE_EST
        FROM FSD010
       WHERE FSD010.PGCOD = VI_EMP
         AND FSD010.AOSUC = VI_SUC
         AND FSD010.AOMOD = VI_MOD
         AND FSD010.AOMDA = VI_MDA
         AND FSD010.AOPAP = VI_PAP
         AND FSD010.AOCTA = VI_CTA
         AND FSD010.AOOPER = VI_OPE
         AND FSD010.AOSBOP = VI_SBO
         AND FSD010.AOTOPE = VI_TOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT COUNT(*)
        INTO CONTA
        FROM FST198
       WHERE FST198.TP1COD = VI_EMP
         AND FST198.TP1COD1 = 11161
         AND FST198.TP1CORR1 = 101
         AND FST198.TP1CORR2 = 0
         AND FST198.TP1CORR3 > 0
         AND FST198.TP1NRO3 = CRE_EST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      IF CONTA > 0 then
        SC_RUB := 'S';
      else
        SC_RUB := 'N';
      end if;
    END;
  end SP_INST_CONT_CRE_EST;

  procedure SP_INST_CONT_CRE_MOD(vINST in number, SC_RUB out varchar) is
    VI_EMP XWF700.XWFEMPRESA%TYPE;
    VI_SUC XWF700.XWFSUCURSAL%TYPE;
    VI_MOD XWF700.XWFMODULO%TYPE;
    VI_MDA XWF700.XWFMONEDA%TYPE;
    VI_PAP XWF700.XWFPAPEL%TYPE;
    VI_CTA XWF700.XWFCUENTA%TYPE;
    VI_OPE XWF700.XWFOPERACION%TYPE;
    VI_SBO XWF700.XWFSUBOPE%TYPE;
    VI_TOP XWF700.XWFTIPOPE%TYPE;
  
    CONTA   NUMBER;
    CRE_EST NUMBER;
  
    --OBTENER CLAVE DEL CRÉDITO -- 
  BEGIN
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = vINST
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- OBTENER AOMOD -- 
    BEGIN
      SELECT AOMOD
        INTO CRE_EST
        FROM FSD010
       WHERE FSD010.PGCOD = VI_EMP
         AND FSD010.AOSUC = VI_SUC
         AND FSD010.AOMOD = VI_MOD
         AND FSD010.AOMDA = VI_MDA
         AND FSD010.AOPAP = VI_PAP
         AND FSD010.AOCTA = VI_CTA
         AND FSD010.AOOPER = VI_OPE
         AND FSD010.AOSBOP = VI_SBO
         AND FSD010.AOTOPE = VI_TOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT COUNT(*)
        INTO CONTA
        FROM FST198
       WHERE FST198.TP1COD = VI_EMP
         AND FST198.TP1COD1 = 11161
         AND FST198.TP1CORR1 = 101
         AND FST198.TP1CORR2 = 1
         AND FST198.TP1CORR3 > 0
         AND FST198.TP1NRO3 = CRE_EST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      IF CONTA > 0 then
        SC_RUB := 'S';
      else
        SC_RUB := 'N';
      end if;
    END;
  end SP_INST_CONT_CRE_MOD;

  procedure SP_INST_CONT_CRE_OPE(vINST in number, SC_RUB out varchar) is
    VI_EMP XWF700.XWFEMPRESA%TYPE;
    VI_SUC XWF700.XWFSUCURSAL%TYPE;
    VI_MOD XWF700.XWFMODULO%TYPE;
    VI_MDA XWF700.XWFMONEDA%TYPE;
    VI_PAP XWF700.XWFPAPEL%TYPE;
    VI_CTA XWF700.XWFCUENTA%TYPE;
    VI_OPE XWF700.XWFOPERACION%TYPE;
    VI_SBO XWF700.XWFSUBOPE%TYPE;
    VI_TOP XWF700.XWFTIPOPE%TYPE;
  
    CONTA   NUMBER;
    CRE_EST NUMBER;
  
    --OBTENER CLAVE DEL CRÉDITO -- 
  BEGIN
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFSUCURSAL,
             X.XWFMODULO,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE
        INTO VI_EMP,
             VI_SUC,
             VI_MOD,
             VI_MDA,
             VI_PAP,
             VI_CTA,
             VI_OPE,
             VI_SBO,
             VI_TOP
        FROM XWF700 X
       WHERE X.XWFPRCINS = vINST
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    -- OBTENER AOMOD -- 
    BEGIN
      SELECT AOTOPE
        INTO CRE_EST
        FROM FSD010
       WHERE FSD010.PGCOD = VI_EMP
         AND FSD010.AOSUC = VI_SUC
         AND FSD010.AOMOD = VI_MOD
         AND FSD010.AOMDA = VI_MDA
         AND FSD010.AOPAP = VI_PAP
         AND FSD010.AOCTA = VI_CTA
         AND FSD010.AOOPER = VI_OPE
         AND FSD010.AOSBOP = VI_SBO
         AND FSD010.AOTOPE = VI_TOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT COUNT(*)
        INTO CONTA
        FROM FST198
       WHERE FST198.TP1COD = VI_EMP
         AND FST198.TP1COD1 = 11161
         AND FST198.TP1CORR1 = 101
         AND FST198.TP1CORR2 = 2
         AND FST198.TP1CORR3 > 0
         AND FST198.TP1NRO3 = CRE_EST;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      IF CONTA > 0 then
        SC_RUB := 'S';
      else
        SC_RUB := 'N';
      end if;
    END;
  end SP_INST_CONT_CRE_OPE;

  PROCEDURE sp_validar_reprog_pagosMismoDia(VE_EMP       IN NUMBER,
                                            VE_MOD       IN NUMBER,
                                            VE_SUC       IN NUMBER,
                                            VE_MDA       IN NUMBER,
                                            VE_PAP       IN NUMBER,
                                            VE_CTA       IN NUMBER,
                                            VE_OPER      IN NUMBER,
                                            VE_SBOP      IN NUMBER,
                                            VE_TOPE      IN NUMBER,
                                            VE_FLAG_RPTA OUT VARCHAR2,
                                            VE_RPTA_MSJ  OUT VARCHAR2) IS
  
    fecha_desembolso_609          DATE;
    ultimaFechaCronogramada_pagos DATE;
  BEGIN
  
    BEGIN
      SELECT min(ppfval)
        INTO fecha_desembolso_609
        from fsd601
       where pgcod = VE_EMP
         and ppmod = VE_MOD
         and ppsuc = VE_SUC
         and ppmda = VE_MDA
         and pppap = VE_PAP
         and ppcta = VE_CTA
         and ppoper = VE_OPER
         and ppsbop = 609
         and pptope = VE_TOPE;
    EXCEPTION
      WHEN OTHERS THEN
        fecha_desembolso_609 := '';
    END;
  
    BEGIN
      SELECT max(ppfpag)
        INTO ultimaFechaCronogramada_pagos
        from fsd602
       where pgcod = VE_EMP
         and ppmod = VE_MOD
         and ppsuc = VE_SUC
         and ppmda = VE_MDA
         and pppap = VE_PAP
         and ppcta = VE_CTA
         and ppoper = VE_OPER
         and d602co = 'S'
         and pp1stat in ('P', 'T')
         and ppsbop = 3
         and pptope = VE_TOPE;
    
    EXCEPTION
      WHEN OTHERS THEN
        ultimaFechaCronogramada_pagos := '';
    END;
  
    IF fecha_desembolso_609 = ultimaFechaCronogramada_pagos THEN
      VE_FLAG_RPTA := 'S';
    ELSE
      VE_FLAG_RPTA := 'N';
      VE_RPTA_MSJ  := 'La fecha cronogramada de la ultima cuota pagada no coincide con la fecha de desembolso del nuevo cronograma';
    END IF;
  END;

  PROCEDURE sp_validar_reprog_aprobada(VE_EMPRESA      NUMBER,
                                       VE_MODULO       NUMBER,
                                       VE_SUCURSAL     NUMBER,
                                       VE_MONEDA       NUMBER,
                                       VE_PAPEL        NUMBER,
                                       VE_CUENTA       NUMBER,
                                       VE_OPERACION    NUMBER,
                                       VE_SUBOPERACION NUMBER,
                                       VE_TIPODEOPERAC NUMBER,
                                       VE_INSTANCIA    NUMBER,
                                       VE_FECHAREPRG   DATE,
                                       
                                       VO_TAREA     OUT VARCHAR,
                                       VO_ESTADO    OUT VARCHAR,
                                       VO_APROBADOR OUT VARCHAR,
                                       VO_FHASIG    OUT TIMESTAMP,
                                       VO_FHAPR     OUT TIMESTAMP) is
  BEGIN
    IF VE_INSTANCIA > 0 THEN
      BEGIN
        SELECT 'Aprobación',
               CASE A.AQPB556EST
                 WHEN 'P' THEN
                  'Pendiente de Aprobación'
                 WHEN 'A' THEN
                  'Reprogramado'
               END,
               A.AQPB556USRM,
               A.AQPB556FECC,
               A.AQPB556FECM
          INTO VO_TAREA, VO_ESTADO, VO_APROBADOR, VO_FHASIG, VO_FHAPR
          FROM AQPB556 A
         WHERE A.AQPB556INST = VE_INSTANCIA
           AND A.AQPB556EHAB = 'H'
           AND A.AQPB556FECR = TO_DATE(VE_FECHAREPRG, 'DD/MM/RRRR');
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      BEGIN
        SELECT 'Aprobación',
               CASE A.AQPB556EST
                 WHEN 'P' THEN
                  'Pendiente de Aprobación'
                 WHEN 'A' THEN
                  'Reprogramado'
               END,
               A.AQPB556USRM,
               A.AQPB556FECC,
               A.AQPB556FECM
          INTO VO_TAREA, VO_ESTADO, VO_APROBADOR, VO_FHASIG, VO_FHAPR
          FROM AQPB556 A
         WHERE A.AQPB556EMP = VE_EMPRESA
           AND A.AQPB556MOD = VE_MODULO
           AND A.AQPB556SUC = VE_SUCURSAL
           AND A.AQPB556MDA = VE_MONEDA
           AND A.AQPB556PAP = VE_PAPEL
           AND A.AQPB556CTA = VE_CUENTA
           AND A.AQPB556OPER = VE_OPERACION
           AND A.AQPB556SBOP = VE_SUBOPERACION
           AND A.AQPB556TOP = VE_TIPODEOPERAC
           AND A.AQPB556FECR = TO_DATE(VE_FECHAREPRG, 'DD/MM/RRRR')
           AND A.AQPB556EHAB = 'H';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE sp_validar_reprog_ab(VE_INSTANCIA  NUMBER,
                                 VE_FECHAREPRG DATE,
                                 VO_ABENEFICIO OUT VARCHAR,
                                 VO_TAREA      OUT VARCHAR,
                                 VO_ESTADO     OUT VARCHAR,
                                 VO_APROBADOR  OUT VARCHAR,
                                 VO_FHASIG     OUT TIMESTAMP,
                                 VO_FHAPR      OUT TIMESTAMP) is
    VI_CANT NUMBER(9);
  BEGIN
    IF VE_INSTANCIA > 0 THEN
      BEGIN
        SELECT count(*),
               'Aprobación con Beneficio',
               CASE A.AQPB561EST
                 WHEN 'P' THEN
                  'Pendiente de Aprobación'
                 WHEN 'A' THEN
                  'Aprobado con Beneficio'
               END,
               A.AQPB561USRM,
               A.AQPB561FECR,
               A.AQPB561FECM
          INTO VI_CANT,
               VO_TAREA,
               VO_ESTADO,
               VO_APROBADOR,
               VO_FHASIG,
               VO_FHAPR
          FROM AQPB561 A
         WHERE A.AQPB561INST = VE_INSTANCIA
           AND A.AQPB561EHAB = 'H'
           AND trunc(A.AQPB561FECR) = TO_DATE(VE_FECHAREPRG, 'DD/MM/RRRR')
         GROUP BY AQPB561EST, AQPB561USRM, AQPB561FECR, AQPB561FECM;
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      if VI_CANT > 0 then
        VO_ABENEFICIO := 'S';
      else
        VO_ABENEFICIO := 'N';
      end if;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  PROCEDURE SP_VALIDAR_APROBADOR_RPG(VE_CODIGO    IN NUMBER,
                                     VE_INSTANCIA IN NUMBER,
                                     ve_sucur     in number,
                                     VE_UBUSER    IN VARCHAR,
                                     VO_RPTA      OUT VARCHAR,
                                     VO_COD_MSG   OUT NUMBER,
                                     VO_MSG       OUT VARCHAR) IS
    vi_cant_bi      NUMBER(9);
    VE_NRO_RPG      NUMBER(9);
    VE_CARGO_APROB  NUMBER(9);
    VE_APROBADOR    VARCHAR(20);
    vo_usu_aprobador VARCHAR(12);
    VE_RPTA         VARCHAR(10);
    VI_CARGO        NUMBER(3);
    VI_USUARIO      CHAR(10);
    VE_FECHA        DATE;
    VI_TIPO_REPROG  NUMBER(9);
    VI_PREFIL_APROB VARCHAR(10);
    VI_SCAPITAL     NUMBER(17, 2);
    VI_EXISTE       NUMBER(17, 2);
  BEGIN
    --COMENTAR SOLO HANILITA PARA PRUEBA EL PRUEBA_LOG
    --insert into prueba_log(msg)values(''||VE_CODIGO||'-'||VE_INSTANCIA||'-'||ve_sucur||'-'||VE_UBUSER);
    --commit;
  
    BEGIN
      SELECT A.AQPB556TPRG, A.AQPB556SCAP
        INTO VI_TIPO_REPROG, VI_SCAPITAL
        FROM AQPB556 A
       WHERE AQPB556COD = VE_CODIGO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      IF VI_TIPO_REPROG = 6 THEN
        pq_cr_validar_rng_reprog.SP_VALIDAR_LISTA_BI(VE_INSTANCIA,
                                                     VE_NRO_RPG,
                                                     VE_CARGO_APROB,
                                                     VE_APROBADOR,
                                                     VE_RPTA);
      
      END IF;
      IF VI_TIPO_REPROG = 7 THEN
        BEGIN
          SELECT TP1NRO1, TRIM(TP1DESC)
            INTO VE_CARGO_APROB, VI_PREFIL_APROB
            FROM FST198
           WHERE TP1COD = 1
             AND TP1COD1 = 10899
             AND TP1CORR1 = 400000
             AND TP1CORR2 = 65
             AND TP1CORR3 > 0
             AND TP1IMP1 <= ABS(VI_SCAPITAL)
             AND TP1IMP2 >= ABS(VI_SCAPITAL);
        
        EXCEPTION
          WHEN OTHERS THEN
            VE_CARGO_APROB := 202;
        END;
      END IF;
      --VALIDAR EL CARGO DEL USUARIO
      BEGIN
        SELECT S.SNG055CAR
          INTO VI_CARGO
          FROM SNG057 S
         WHERE S.SNG057USR = RPAD(VE_UBUSER, 10, ' ');
           --AND S.SNG057AUT = 'S'; 2024.05.09 - Comentado a Solicitud de Luis Carpio, para no validar autonomia.
      EXCEPTION
        WHEN OTHERS THEN
          VI_CARGO := 0;
      END;
      VI_USUARIO := RPAD(VE_UBUSER, 10, ' ');
      --VALIDAR SI EL CARGO ES DEL APROBADO
      IF VI_CARGO = VE_CARGO_APROB THEN
        BEGIN
          --VALIDAR SI LA INSTANCIA DE SU AGENCIA ES DE LOS QUE TIENE A CARGO DEPENDIENDO DEL CARGO
          PQ_CR_CREDITOS_CAP_HS.SP_GESTIONAR_ACCESO_IND3(ve_instancia,
                                                         ve_codigo,
                                                         VI_USUARIO,
                                                         ve_sucur,
                                                         VI_CARGO,
                                                         vo_rpta);
            IF VO_RPTA = 'N' THEN
                PQ_CR_APROBACION_REPROG_HS.SP_VALIDAR_APROB_PERFIL(
                                                                    VE_CARGO_APROB,
                                                                    VI_PREFIL_APROB,
                                                                    ve_sucur,
                                                                    vo_usu_aprobador
                                                                );
                
                IF trim(vo_usu_aprobador) = trim(VE_UBUSER) THEN
                    VO_RPTA := 'S'; 
                END IF;
            END IF;        
        EXCEPTION
          WHEN OTHERS THEN
            VO_RPTA := 'N';
        END;
        IF VO_RPTA = 'N' THEN
          BEGIN
            SELECT COUNT(*)
              INTO VI_EXISTE
              FROM AQPB556
             WHERE AQPB556INST = ve_instancia
               AND AQPB556EST = 'P'
               AND AQPB556EHAB = 'H'
               AND AQPB556USRA = RPAD(VE_UBUSER, 10, ' ')
               AND AQPB556COD = (SELECT MAX(AQPB556COD)
                                   FROM AQPB556
                                  WHERE AQPB556INST = ve_instancia
                                    AND AQPB556EST = 'P'
                                    AND AQPB556EHAB = 'H');
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          IF VI_EXISTE > 0 THEN
            VO_RPTA := 'S';
          ELSE
            --apachecoh 2024.02.07 Valida suplencia
            BEGIN
              SELECT PGFAPE INTO VE_FECHA FROM FST017 WHERE PGCOD = 1;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
            BEGIN
              SELECT S.SNG055CAR, S.SNG057USR
                INTO VI_CARGO, VI_USUARIO
                FROM SNG057 S
               WHERE S.SNG055EMP = 1
                 AND S.SNG057SUP = RPAD(VE_UBUSER, 10, ' ')
                 AND S.SNG057FIN > VE_FECHA
                 AND ROWNUM = 1; --apachecoh 2024.02.08
            EXCEPTION
              WHEN OTHERS THEN
                VI_CARGO := 0;
            END;
            IF VI_CARGO = VE_CARGO_APROB THEN
              BEGIN
                --VALIDAR SI LA INSTANCIA DE SU AGENCIA ES DE LOS QUE TIENE A CARGO DEPENDIENDO DEL CARGO
                PQ_CR_CREDITOS_CAP_HS.SP_GESTIONAR_ACCESO_IND3(ve_instancia,
                                                               ve_codigo,
                                                               VI_USUARIO,
                                                               ve_sucur,
                                                               VI_CARGO,
                                                               vO_rpta);
                IF VO_RPTA = 'N' THEN
                    PQ_CR_APROBACION_REPROG_HS.SP_VALIDAR_APROB_PERFIL(
                                                                        VE_CARGO_APROB,
                                                                        VI_PREFIL_APROB,
                                                                        ve_sucur,
                                                                        vo_usu_aprobador
                                                                    );
                    
                    IF trim(vo_usu_aprobador) = trim(VI_USUARIO) THEN
                        VO_RPTA := 'S'; 
                    END IF;
                END IF;              
              EXCEPTION
                WHEN OTHERS THEN
                  VO_RPTA := 'N';
              END;
            END IF;
            --apachecoh 2024.02.07 Valida suplencia
          END IF;        
        END IF;
      ELSE
        BEGIN
          SELECT PGFAPE INTO VE_FECHA FROM FST017 WHERE PGCOD = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          SELECT S.SNG055CAR, S.SNG057USR
            INTO VI_CARGO, VI_USUARIO
            FROM SNG057 S
           WHERE S.SNG055EMP = 1
             AND S.SNG057SUP = RPAD(VE_UBUSER, 10, ' ')
             AND S.SNG057FIN > VE_FECHA
             AND ROWNUM = 1; --apachecoh 2024.02.08
        EXCEPTION
          WHEN OTHERS THEN
            VI_CARGO := 0;
        END;
        IF VI_CARGO = VE_CARGO_APROB THEN
          BEGIN
            --VALIDAR SI LA INSTANCIA DE SU AGENCIA ES DE LOS QUE TIENE A CARGO DEPENDIENDO DEL CARGO
            PQ_CR_CREDITOS_CAP_HS.SP_GESTIONAR_ACCESO_IND3(ve_instancia,
                                                           ve_codigo,
                                                           VI_USUARIO,
                                                           ve_sucur,
                                                           VI_CARGO,
                                                           vO_rpta);
            IF VO_RPTA = 'N' THEN
                PQ_CR_APROBACION_REPROG_HS.SP_VALIDAR_APROB_PERFIL(
                                                                    VE_CARGO_APROB,
                                                                    VI_PREFIL_APROB,
                                                                    ve_sucur,
                                                                    vo_usu_aprobador
                                                                );
                
                IF trim(vo_usu_aprobador) = trim(VI_USUARIO) THEN
                    VO_RPTA := 'S'; 
                END IF;
            END IF;
          
          EXCEPTION
            WHEN OTHERS THEN
              VO_RPTA := 'N';
          END;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        VO_RPTA := 'N';
    END;
  END;

  PROCEDURE SP_VALIDAR_APROB_PERFIL(
                                     vi_cargo in number,
                                     vi_perfilc in varchar,
                                     ve_suc in number,
                                     vo_aprobador out varchar
                                   )IS
  vgerentec varchar(12);
  VI_REGCOD number(3);
  --vo_aprobador varchar(12);
  BEGIN
      --OBTENER CODIGO DE REGION
      BEGIN
        SELECT F.REGCOD
          INTO VI_REGCOD
          FROM FST811 F
         WHERE F.OFICOD = ve_suc
           AND F.REGCOD <= 100
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF vi_cargo = 202 THEN
         SELECT S.SNG057USR
             INTO vgerentec
             FROM SNG057 S,FST046 F,PRFU00 P
            WHERE S.SNG055EMP =1
              AND S.SNG055CAR =VI_CARGO /*AND SNG057AUT='S'*/
              AND P.PGCOD   = S.SNG055EMP
              AND P.UBUSER  = S.SNG057USR
              AND P.PRFGCOD <> rpad('CESADO',10,' ')
              AND F.PGCOD  = 1
              AND F.UBUSER = S.SNG057USR
              AND F.UBSUC  = ve_suc
              AND ROWNUM    = 1;
            vo_aprobador := vgerentec; 
      END IF;
      IF vi_cargo = 220 THEN
        IF TRIM(vi_perfilc) = 'JZON01' THEN
          BEGIN
            select sng057usr
              INTO vgerentec
              from fst811 f, sng057 s, fst046 t
             where f.regcod = VI_REGCOD
               and s.sng055car = 220
               and t.ubuser = s.sng057usr
               --and s.sng057aut = 'S'
               and f.oficod = t.ubsuc
               AND ROWNUM = 1;
            vo_aprobador := vgerentec;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
        IF TRIM(vi_perfilc) = 'GREG01' THEN
          BEGIN
            SELECT F.REGCOD
              INTO VI_REGCOD
              FROM REGSUC F
             WHERE F.SUCURS = ve_suc;
                    
            SELECT F.UBUSER
              INTO vgerentec
              FROM REGSUC R, FST046 F, PRFU00 P, SNG057 S
             WHERE R.REGCOD = VI_REGCOD
               AND R.SUCURS = F.UBSUC
               AND F.UBUSER = P.UBUSER
               AND P.PRFGCOD = 'GREG01'
               AND S.SNG055EMP = F.PGCOD
               AND S.SNG057USR = P.UBUSER
               AND S.SNG055CAR = 220
               AND ROWNUM = 1;
               --AND S.SNG057AUT = 'S';
            vo_aprobador := vgerentec;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      END IF;  
      IF vi_cargo in (223,230,240) THEN
         SELECT S.SNG057USR
           INTO vgerentec
           FROM SNG057 S,PRFU00 P
          WHERE S.SNG055EMP =1
            AND S.SNG055CAR =VI_CARGO AND SNG057AUT='S'
            AND P.PGCOD   = S.SNG055EMP
            AND P.UBUSER  = S.SNG057USR
            AND P.PRFGCOD <> rpad('CESADO',10,' ')
            AND ROWNUM    = 1;
          vo_aprobador := vgerentec;  
      END IF;
  END;
  PROCEDURE SP_VALIDAR_APROBADOR_RPGM(VE_CODIGO     IN NUMBER,
                                      VE_VISUALIZAR IN VARCHAR,
                                      VE_INSTANCIA  IN NUMBER,                                      
                                      ve_sucur      IN number,
                                      VE_UBUSER     IN VARCHAR,
                                      VO_RPTA       OUT VARCHAR,
                                      VO_COD_MSG    OUT NUMBER,
                                      VO_MSG        OUT VARCHAR) IS
   --CURSORES NCESARIOS
   CURSOR LISTA_PERFIL_APR(VXI_CODIGO IN NUMBER, VXI_INSTANCIA IN NUMBER)IS
      select D.* from aqpd157 D where D.AQPD157CODREP = VXI_CODIGO AND D.AQPD157INST = VXI_INSTANCIA AND D.AQPD157EST=VE_VISUALIZAR;
   --DATOS ADICIONALES.
   VI_FECHA_REPROG DATE;
   VI_FECHA DATE;
   VI_UBUSER CHAR(10);
   BEGIN
      VO_RPTA :='N';
      BEGIN   
        --OBTENER DATOS ADICIONALES DEL CREDITO.
        BEGIN
          SELECT A.AQPB556FECRPG
            INTO VI_FECHA_REPROG
            FROM AQPB556 A
           WHERE A.AQPB556COD  = VE_CODIGO
             AND A.AQPB556INST = VE_INSTANCIA
             AND A.AQPB556EST  = VE_VISUALIZAR
             AND A.AQPB556EHAB = 'H'
			 AND ROWNUM=1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          SELECT PGFAPE INTO VI_FECHA FROM FST017 WHERE PGCOD=1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;  
        END;    
        FOR X IN LISTA_PERFIL_APR(ve_codigo,ve_instancia) LOOP
          --VALIDAR SI USUARIO ESTA EN EL LISTADO
          IF X.AQPD157UAPRO = RPAD(VE_UBUSER, 10, ' ') THEN
             VO_RPTA := 'S';
          ELSE
             --VALIDAR SUPLENCIA
             BEGIN
               SELECT S.SNG057USR
                 INTO VI_UBUSER
                 FROM SNG057 S
                WHERE S.SNG055EMP = 1
                  AND S.SNG057SUP = RPAD(VE_UBUSER, 10, ' ')
                  AND S.SNG057INI <= VI_FECHA
                  AND S.SNG057FIN >= VI_FECHA;
             EXCEPTION
               WHEN OTHERS THEN
                 NULL;  
             END;
             IF VI_UBUSER = X.AQPD157UAPRO THEN
                VO_RPTA := 'S';
             END IF;
          END IF;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
   END;
END pq_cr_aprobacion_reprog_hs;
/

