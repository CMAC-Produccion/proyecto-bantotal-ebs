create or replace package PQ_CR_RETENCION_CONTENCION is

   PROCEDURE SP_CR_GRABA_RETENCION(pInCodAge IN NUMBER, pInNomAna VARCHAR2, pInDif IN NUMBER,
                                   pInRet IN NUMBER, pInBase IN NUMBER, pOutErr OUT NUMBER, pOutMsg OUT VARCHAR2);
   
   PROCEDURE SP_CR_GRABA_CONTENCION(pInCodAge IN NUMBER, pInNomAna VARCHAR2, pInInd IN NUMBER,
                                   pInCon IN NUMBER, pInBase IN NUMBER, pOutErr OUT NUMBER, pOutMsg OUT VARCHAR2);
                                   
   PROCEDURE SP_CR_REPORTE_ASIGNACION_CARTERA(FECHA_SISTEMA IN DATE, HORA_SISTEMA IN VARCHAR2, USUARIO_SISTEMA IN VARCHAR2, FECHA_INICIO IN DATE, FECHA_FIN IN DATE); 
   
   PROCEDURE SP_CR_REPORTE_ANALISTA_TRASLADO(FECHA_SISTEMA IN DATE, HORA_SISTEMA IN VARCHAR2, USUARIO_SISTEMA IN VARCHAR2);

end PQ_CR_RETENCION_CONTENCION;
/

create or replace package body PQ_CR_RETENCION_CONTENCION is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_RETENCION_CONTENCION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.01.31
  -- Autor de Creación          : MCHAVEZ, MCORDOVA 
  -- Uso                        : OBTENER RETENCION Y CONTENCION
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --                
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


  PROCEDURE SP_CR_GRABA_RETENCION(
    pInCodAge IN NUMBER, 
    pInNomAna IN VARCHAR2,
    pInDif    IN NUMBER,
    pInRet    IN NUMBER, 
    pInBase   IN NUMBER,
    pOutErr   OUT NUMBER,
    pOutMsg   OUT VARCHAR2) IS
  FcSys DATE := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
  BEGIN
    INSERT INTO JAQZ451 VALUES(FcSys, FcSys, pInCodAge, pInNomAna, pInCodAge, pInCodAge, 0, 0, pInDif, 0, pInRet, pInBase);
    COMMIT;
    pOutErr := 0;
    pOutMsg := ' ';
  EXCEPTION
    WHEN OTHERS THEN
      pOutErr := 99;
      pOutMsg := 'Hubo un problema al momento de guardar la retencion.';
  END SP_CR_GRABA_RETENCION;
  
  PROCEDURE SP_CR_GRABA_CONTENCION(
    pInCodAge IN NUMBER, 
    pInNomAna VARCHAR2, 
    pInInd    IN NUMBER,
    pInCon    IN NUMBER, 
    pInBase   IN NUMBER, 
    pOutErr   OUT NUMBER, 
    pOutMsg   OUT VARCHAR2) IS
  FcSys DATE := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
  BEGIN
    INSERT INTO JAQZ452 VALUES(FcSys, FcSys, pInCodAge, pInNomAna, pInCodAge, 0, pInInd, 0, pInCon, pInBase);
    COMMIT;
     pOutErr := 0;
     pOutMsg := ' ';
  EXCEPTION
    WHEN OTHERS THEN
    pOutErr := 99;
    pOutMsg := 'Hubo un problema al momento de guardar la contencion.';
  END SP_CR_GRABA_CONTENCION;
  
  PROCEDURE SP_CR_REPORTE_ASIGNACION_CARTERA(
    FECHA_SISTEMA IN DATE,
    HORA_SISTEMA IN VARCHAR2,
    USUARIO_SISTEMA IN VARCHAR2,
    FECHA_INICIO IN DATE,
    FECHA_FIN IN DATE
    ) IS   
    CURSOR LISTADO_ASIGNACION_CARTERA IS
    select
    j.JAQL600FPRO PERIODO, -- PERIODO
    j.jaql600usu CODIGO_ANALISTA, -- CODIGO ANALISTA
    (select i.ubnom from fst746 i where i.ubuser = j.jaql600usu) NOMBRE_ANALISTA, -- NOMBRRE ANALISTA
    ' ' CARTERA, -- CARTERA
    decode(j.jaql600neo, 'N', 'NUEVAS', 'O', 'OTRAS', 'E', 'ESPECIFICAS') TIPO_AGENCIA, -- TIPO AGENCIA
    ' ' CLASIFICACION, -- CLASIFICACION
    j.jaql600tase CODIGO_TIPO_ANALISTA, -- CODIGO TIPO ANALISTA
    decode(j.jaql600tase, 'P', 'PYMES', 'CONSUMO CONVENIO') DESCRIPCION_TIPO_ANALISTA, -- DESCRIPCION TIPO ANALISTA
    j.jaql600codcat CODIGO_CATEGORIA_ANALISTA, -- CODIGO CATEGORIA ANALISTA / JUNIOR - AVANZADO
    case when j.jaql600codcat > 6 then 'Analista Senior' else 'Analista de Creditos' end CARGO, -- CARGO  

    (select sum(k.jaql114sdmn) SDMN from jaql114 k
    where k.jaql114fech = to_Date('2013.11.30', 'yyyy.mm.dd') and 
    k.jaql114ase = j.jaql600usu and 
    k.jaql114mod not in (33, 141, 108)
    group by k.jaql114ase) SALDO_TOTAL, -- SALDO TOTAL

    j.jaql600age CODIGO_AGENCIA, -- CODIGO SUCURSAL
    (select scnom from fst001 f where f.sucurs = j.jaql600age) DESCRIPCION_AGENCIA, -- DESCRIPCION SUCURSAL
    (j.jaql600sdo - j.jaql600sdca - j.jaql600cave) SALDO, -- SALDO,
    j.jaql600neo AGENCIA_N_NUEVA -- AGENCIA N-NUEVA
    from jaql600 j
    where jaql600fpro >= FECHA_INICIO and jaql600fpro <= FECHA_FIN AND jaql600codcat not in (0 /*,7,8,9*/ );
    
    BEGIN
      FOR X IN LISTADO_ASIGNACION_CARTERA LOOP
        BEGIN
          INSERT INTO AQPC215(AQPC215FEC, AQPC215HOR, AQPC215USU, AQPC215PER, AQPC215COA, AQPC215NOA, AQPC215CAR, AQPC215TIA, AQPC215CLA,
          AQPC215CTA, AQPC215DTA, AQPC215CCA, AQPC215CAG, AQPC215SAT, AQPC215COS, AQPC215DES, AQPC215SAL, AQPC215AGE)
          VALUES(FECHA_SISTEMA, HORA_SISTEMA, USUARIO_SISTEMA, X.PERIODO, X.CODIGO_ANALISTA, X.NOMBRE_ANALISTA, X.CARTERA, X.TIPO_AGENCIA, X.CLASIFICACION,
          X.CODIGO_TIPO_ANALISTA, X.DESCRIPCION_TIPO_ANALISTA, X.CODIGO_CATEGORIA_ANALISTA, X.CARGO, X.SALDO_TOTAL, X.CODIGO_AGENCIA, X.DESCRIPCION_AGENCIA, X.SALDO, 
          X.AGENCIA_N_NUEVA);
        END;
      END LOOP; 
      COMMIT;
  --  EXCEPTION
    -- WHEN OTHERS THEN NULL;
    END SP_CR_REPORTE_ASIGNACION_CARTERA;
    
    PROCEDURE SP_CR_REPORTE_ANALISTA_TRASLADO(
      FECHA_SISTEMA IN DATE,
      HORA_SISTEMA IN varchar2,
      USUARIO_SISTEMA IN varchar2
      )IS
      CURSOR LISTADO_ANALISTA_TRASLADO IS 
      SELECT T2.UBUSER CODIGO_ANALISTA, T2.UBNOM NOMBRE_ANALISTA FROM SNG130 T1 INNER JOIN FST746 T2 ON T1.SNG130USER = T2.UBUSER GROUP BY T2.UBUSER, T2.UBNOM;
    BEGIN
      FOR X IN LISTADO_ANALISTA_TRASLADO LOOP
        BEGIN
          INSERT INTO AQPC216(AQPC216FEC, AQPC216HOR, AQPC216USU, AQPC216COD, AQPC216NOM)
          VALUES(FECHA_SISTEMA, HORA_SISTEMA, USUARIO_SISTEMA, X.CODIGO_ANALISTA, X.NOMBRE_ANALISTA);
        END;
      END LOOP;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN NULL;  
    END SP_CR_REPORTE_ANALISTA_TRASLADO;  
end PQ_CR_RETENCION_CONTENCION;
/

