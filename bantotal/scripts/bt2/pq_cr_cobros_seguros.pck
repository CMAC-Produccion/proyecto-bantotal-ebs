create or replace package Pq_cr_cobros_seguros is
    -- *****************************************************************
    -- Nombre                     : paquete para OBTENER DIRECCIONES COINCIDENTES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2013.09.02
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : 
    -- Fecha de Modificación      : 2013.10.15
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --                              
    --
    -- *****************************************************************
           
----------------------------------------------------------------------- 

  Procedure sp_cr_seguro_vc(pd_fecini in varchar2,
                            pd_fecfin in varchar2
                            );
-----------------------------------------------------------------------             

  Procedure sp_cr_inserta_MV(pd_fecini in varchar2,
                            pd_fecfin in varchar2
                            );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_seguro_MV;                            
-----------------------------------------------------------------------
end Pq_cr_cobros_seguros;
/

create or replace package body Pq_cr_cobros_seguros is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------
  -- COBROS SEGUROS --
  ---------------------------------------
  Procedure sp_cr_seguro_vc(pd_fecini in varchar2,
                            pd_fecfin in varchar2
                            )is
      -- *****************************************************************
      -- Nombre                     : sp_cr_seguro_vc
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Actvias
      -- Versión                    : 1.0
      -- Fecha de Creación          : 
      -- Autor de Creación          : 
      -- Uso                        : COBROS SEGUROS VIDA CAJA
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Parámetros de Entrada      : pc_analista: asesor
      -- Parámetros de Salida       : tipo Analista: Convenio Pyme
      -- Fecha de Modificación      :
      -- Autor de la Modificación   :
      -- Descripción de Modificación:
      -- *****************************************************************
    CURSOR CREDITOS IS
    select  /*+parallel (j,2) */--distinct 
  /*       j.jaql99fepr FechaProceso,
         j.idtitularcta99 TitularCta,*/
         to_number(substr(j.docdeposito99, 1, 9)) cuenta,
         to_number(substr(j.docdeposito99, 10, 3)) modulo,
         to_number(substr(j.docdeposito99, 13, 3)) moneda,
         to_number(substr(j.docdeposito99, 16, 9)) operacion,
         to_number(substr(j.docdeposito99, 25, 3)) tipooper/*,
         j.montoprimacuota99 * 0.01 Monto_Prima,
         j.fecemisioncuota99 Fecha_Cuota,
         j.fecpagocuota99 Fecha_Pago,
         j.docdeposito99 Docdeposito*/
    from jaql099 j
   where j.codproductocobro99 in ('0004', '0005')
     and jaql99fepr >= to_date(pd_fecini, 'yyyymmdd') and jaql99fepr <= to_date(pd_fecfin, 'yyyymmdd')
   group by 
         to_number(substr(j.docdeposito99, 1, 9)),
         to_number(substr(j.docdeposito99, 10, 3)),
         to_number(substr(j.docdeposito99, 13, 3)),
         to_number(substr(j.docdeposito99, 16, 9)),
         to_number(substr(j.docdeposito99, 25, 3)); --108510

  BEGIN

  --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
    FOR I IN CREDITOS LOOP
    
    
        BEGIN
           UPDATE FSD011 F
              SET SCSTAT = 89
            WHERE F.PGCOD = 1
              AND F.SCMOD = 260--I.SCMOD
              AND F.SCMDA = I.moneda
              AND F.SCPAP = 0
              AND F.SCCTA = I.cuenta
             -- AND F.SCSUC = I.SCSUC
              AND F.SCOPER = I.operacion
              AND F.SCSBOP = 0--I.SCSBOP
              AND F.SCTOPE = 0--I.SCTOPE
              AND SUBSTR(F.SCRUB,1,2) = '25' 
              and F.SCRUB in ( '2524020000008','2514020000008','2514020000013','2524020000013')
              and f.scstat  <> 89; 
        END;
         commit; --- 2018.12.12 dcastro
    END LOOP;
   
        
  end sp_cr_seguro_vc;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_inserta_MV(pd_fecini in varchar2,
                            pd_fecfin in varchar2
                            )is
      -- *****************************************************************
      -- Nombre                     : sp_cr_seguro_MV
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Actvias
      -- Versión                    : 1.0
      -- Fecha de Creación          : 
      -- Autor de Creación          : 
      -- Uso                        : COBROS SEGUROS MOVIGAS/SEGURO VEHICULAR
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Parámetros de Entrada      : pc_analista: asesor
      -- Parámetros de Salida       : tipo Analista: Convenio Pyme
      -- Fecha de Modificación      :
      -- Autor de la Modificación   :
      -- Descripción de Modificación:
      -- *****************************************************************
      
      
  --VEHICULAR SOLES

begin

INSERT INTO CRDTCAP  ( C_DESCRI, C_DESCRI1,C_DESCRI2,C_DESCRI3,C_DESCRI4,C_DESCRI5,C_DESCRI6, C_DESCRI7,C_DESCRI8, N_MONTO1 , D_FECHA, D_fECHA1)
SELECT PGCOD, PPCTA,PPOPER,PPSUC, PPMOD,PPMDA, PPPAP, PPSBOP, PPTOPE, PP1IMP_SGCOD_RR ,PPFPAG, PP1FECH
FROM(
  SELECT
  D10.PGCOD, PPCTA,PPOPER,PPSUC, PPMOD,PPMDA, PPPAP, PPSBOP, PPTOPE, (PP1IMP_SGCOD_RR), PPFPAG, PP1FECH
    FROM(
        --STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
        SELECT
        PGCOD,PPMOD,PPSUC,PPMDA,PPPAP,PPCTA,PPOPER,PPSBOP,PPTOPE,PPFPAG,PPTIPO,NUM_CUOTA,--OPERACION + CUOTA
        PP1FECH,--FECHA QUE HIZO EL ULTIMO PAGO
        CASE--IMPORTE A PAGAR SEGURO
        WHEN NUM_IMPORTE = 11 THEN PPIMP11
        WHEN NUM_IMPORTE = 12 THEN PPIMP12
        WHEN NUM_IMPORTE = 13 THEN PPIMP13
        WHEN NUM_IMPORTE = 14 THEN PPIMP14
        WHEN NUM_IMPORTE = 15 THEN PPIMP15
        END AS PPIMP_SGCOD,

        CASE--IMPORTE SEGURO PAGADO HASTA FECHA
        WHEN NUM_IMPORTE = 11 THEN PP1IMP11_HH
        WHEN NUM_IMPORTE = 12 THEN PP1IMP12_HH
        WHEN NUM_IMPORTE = 13 THEN PP1IMP13_HH
        WHEN NUM_IMPORTE = 14 THEN PP1IMP14_HH
        WHEN NUM_IMPORTE = 15 THEN PP1IMP15_HH
        END AS PP1IMP_SGCOD_HH,

        CASE--IMPORTE SEGURO PAGADO EN RANGO
        WHEN NUM_IMPORTE = 11 THEN PP1IMP11_RR
        WHEN NUM_IMPORTE = 12 THEN PP1IMP12_RR
        WHEN NUM_IMPORTE = 13 THEN PP1IMP13_RR
        WHEN NUM_IMPORTE = 14 THEN PP1IMP14_RR
        WHEN NUM_IMPORTE = 15 THEN PP1IMP15_RR
        END AS PP1IMP_SGCOD_RR
        FROM(
            --STRUCT 1, CRONOGRAMA-PAGOS
            SELECT Q1.PGCOD,Q1.PPMOD,Q1.PPSUC,Q1.PPMDA,Q1.PPPAP,Q1.PPCTA,Q1.PPOPER,Q1.PPSBOP,Q1.PPTOPE,
            Q1.PPFPAG,Q1.PPTIPO,Q1.NUM_CUOTA,Q1.NUM_IMPORTE,Q2.PP1FECH,
            Q1.PPIMP11,Q1.PPIMP12,Q1.PPIMP13,Q1.PPIMP14,Q1.PPIMP15,
            NVL(Q2.PP1IMP11_HH,0) AS PP1IMP11_HH,
            NVL(Q2.PP1IMP12_HH,0) AS PP1IMP12_HH,
            NVL(Q2.PP1IMP13_HH,0) AS PP1IMP13_HH,
            NVL(Q2.PP1IMP14_HH,0) AS PP1IMP14_HH,
            NVL(Q2.PP1IMP15_HH,0) AS PP1IMP15_HH,
            NVL(Q2.PP1IMP11_RR,0) AS PP1IMP11_RR,
            NVL(Q2.PP1IMP12_RR,0) AS PP1IMP12_RR,
            NVL(Q2.PP1IMP13_RR,0) AS PP1IMP13_RR,
            NVL(Q2.PP1IMP14_RR,0) AS PP1IMP14_RR,
            NVL(Q2.PP1IMP15_RR,0) AS PP1IMP15_RR
            FROM (
              ---CRONOGRAMA
              SELECT D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO,RANK() OVER (PARTITION BY D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE
              ORDER BY
              D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO
              ) AS NUM_CUOTA,Q33NY.NUM_IMPORTE,
              NVL(D611.PPIMP11,0) AS PPIMP11,
              NVL(D611.PPIMP12,0) AS PPIMP12,
              NVL(D611.PPIMP13,0) AS PPIMP13,
              NVL(D611.PPIMP14,0) AS PPIMP14,
              NVL(D611.PPIMP15,0) AS PPIMP15
              FROM FSD601 D601 LEFT JOIN FSD611 D611 ON
              D601.PGCOD = D611.PGCOD AND
              D601.PPMOD = D611.PPMOD AND
              D601.PPSUC = D611.PPSUC AND
              D601.PPMDA = D611.PPMDA AND
              D601.PPPAP = D611.PPPAP AND
              D601.PPCTA = D611.PPCTA AND
              D601.PPOPER = D611.PPOPER AND
              D601.PPSBOP = D611.PPSBOP AND
              D601.PPTOPE = D611.PPTOPE AND
              D601.PPFPAG = D611.PPFPAG AND
              D601.PPTIPO = D611.PPTIPO
              INNER JOIN(
                  --PRESTAMOS E IMPORTES
                  SELECT PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,NUM_IMPORTE FROM(
                  SELECT PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD,(RANK() OVER (PARTITION BY
                  PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE
                  ORDER BY PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD))+10 AS NUM_IMPORTE FROM FPP001 INNER JOIN DEPE62J ON
                  DEPE62JMOD = AOMOD AND
                  DEPE62JTOP = AOTOPE AND
                  DEPE62JMDA = AOMDA AND
                  DEPE62JPAP = AOPAP
                  ORDER BY PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD)Q1
                  WHERE Q1.SGCOD IN((SELECT TP1NRO1 FROM FST198 WHERE TP1COD1=2036 AND TP1COD=1 AND TP1CORR1=100 AND TP1CORR2=3 AND TP1CORR3=10) UNION SELECT 150 FROM DUAL)
                  --FIN PRESTAMOS E IMPORTES
              )Q33NY ON
              D601.PGCOD = Q33NY.PGCOD AND
              D601.PPMOD = Q33NY.AOMOD AND
              D601.PPSUC = Q33NY.AOSUC AND
              D601.PPMDA = Q33NY.AOMDA AND
              D601.PPPAP = Q33NY.AOPAP AND
              D601.PPCTA = Q33NY.AOCTA AND
              D601.PPOPER = Q33NY.AOOPER AND
              D601.PPSBOP = Q33NY.AOSBOP AND
              D601.PPTOPE = Q33NY.AOTOPE

              WHERE D601CO='S'
              ORDER BY D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO
              --FIN CRONOGRAMA
            )Q1 LEFT JOIN(
              ----PAGOS
              SELECT Q100.PGCOD,Q100.PPMOD,Q100.PPSUC,Q100.PPMDA,Q100.PPPAP,Q100.PPCTA,Q100.PPOPER,Q100.PPSBOP,Q100.PPTOPE,Q100.PPFPAG,Q100.PPTIPO,
              Q100.PP1IMP11_HH,Q100.PP1IMP12_HH,Q100.PP1IMP13_HH,Q100.PP1IMP14_HH,Q100.PP1IMP15_HH,
              NVL(Q101.PP1IMP11_RR,0) AS PP1IMP11_RR,NVL(Q101.PP1IMP12_RR,0)AS PP1IMP12_RR,NVL(Q101.PP1IMP13_RR,0)AS PP1IMP13_RR,
              NVL(Q101.PP1IMP14_RR,0) AS PP1IMP14_RR,NVL(Q101.PP1IMP15_RR,0)PP1IMP15_RR,Q101.PP1FECH
              FROM(
                    ---------------------------HASTA FECHA
                    SELECT D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO,SUM(NVL(D612.PP1IMP11,0)) AS PP1IMP11_HH,
                    SUM(NVL(D612.PP1IMP12,0)) AS PP1IMP12_HH,SUM(NVL(D612.PP1IMP13,0)) AS PP1IMP13_HH,SUM(NVL(D612.PP1IMP14,0)) AS PP1IMP14_HH,
                    SUM(NVL(D612.PP1IMP15,0)) AS PP1IMP15_HH FROM FSD602 D602 LEFT JOIN FSD612 D612 ON
                    D602.PGCOD = D612.PGCOD AND
                    D602.PPMOD = D612.PPMOD AND
                    D602.PPSUC = D612.PPSUC AND
                    D602.PPMDA = D612.PPMDA AND
                    D602.PPPAP = D612.PPPAP AND
                    D602.PPCTA = D612.PPCTA AND
                    D602.PPOPER = D612.PPOPER AND
                    D602.PPSBOP = D612.PPSBOP AND
                    D602.PPTOPE = D612.PPTOPE AND
                    D602.PPFPAG = D612.PPFPAG AND
                    D602.PPTIPO = D612.PPTIPO AND
                    D602.PP1NUMP = D612.PP1NUMP
                    WHERE D602CO='S' AND D602.PP1FECH <= to_date(pd_fecfin, 'yyyymmdd')--FECHA hasta
                    and  (/*d602.d602mo <> 30 and*/ d602.d602tr <> 390) -----------------
                    GROUP BY D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO
                    --------------------------------FIN HASTA FECHA
              )Q100 LEFT JOIN(
                    ---------------------------------------EN RANGO
                    SELECT D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO,SUM(NVL(D612.PP1IMP11,0)) AS PP1IMP11_RR,
                    SUM(NVL(D612.PP1IMP12,0)) AS PP1IMP12_RR,SUM(NVL(D612.PP1IMP13,0)) AS PP1IMP13_RR,SUM(NVL(D612.PP1IMP14,0)) AS PP1IMP14_RR,
                    SUM(NVL(D612.PP1IMP15,0)) AS PP1IMP15_RR,MAX(D602.PP1FECH)AS PP1FECH FROM FSD602 D602 LEFT JOIN FSD612 D612 ON
                    D602.PGCOD = D612.PGCOD AND
                    D602.PPMOD = D612.PPMOD AND
                    D602.PPSUC = D612.PPSUC AND
                    D602.PPMDA = D612.PPMDA AND
                    D602.PPPAP = D612.PPPAP AND
                    D602.PPCTA = D612.PPCTA AND
                    D602.PPOPER = D612.PPOPER AND
                    D602.PPSBOP = D612.PPSBOP AND
                    D602.PPTOPE = D612.PPTOPE AND
                    D602.PPFPAG = D612.PPFPAG AND
                    D602.PPTIPO = D612.PPTIPO AND
                    D602.PP1NUMP = D612.PP1NUMP
                    WHERE D602CO='S' AND D602.PP1FECH BETWEEN to_date(pd_fecini, 'yyyymmdd') AND to_date(pd_fecfin, 'yyyymmdd')--FECHA DESDE Y HASTA
                    GROUP BY D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO
                    --------------------------------------FIN EN RANGO
              )Q101 ON
              Q100.PGCOD = Q101.PGCOD AND
              Q100.PPMOD = Q101.PPMOD AND
              Q100.PPSUC = Q101.PPSUC AND
              Q100.PPMDA = Q101.PPMDA AND
              Q100.PPPAP = Q101.PPPAP AND
              Q100.PPCTA = Q101.PPCTA AND
              Q100.PPOPER = Q101.PPOPER AND
              Q100.PPSBOP = Q101.PPSBOP AND
              Q100.PPTOPE = Q101.PPTOPE AND
              Q100.PPFPAG = Q101.PPFPAG AND
              Q100.PPTIPO = Q101.PPTIPO
              ----FIN PAGOS
            )Q2 ON
            Q1.PGCOD = Q2.PGCOD AND
            Q1.PPMOD = Q2.PPMOD AND
            Q1.PPSUC = Q2.PPSUC AND
            Q1.PPMDA = Q2.PPMDA AND
            Q1.PPPAP = Q2.PPPAP AND
            Q1.PPCTA = Q2.PPCTA AND
            Q1.PPOPER = Q2.PPOPER AND
            Q1.PPSBOP = Q2.PPSBOP AND
            Q1.PPTOPE = Q2.PPTOPE AND
            Q1.PPFPAG = Q2.PPFPAG AND
            Q1.PPTIPO = Q2.PPTIPO
            --FIN STRUCT 1, CRONOGRAMA-PAGOS
        )Q200
        --FIN STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
    )Q201


    left join fst001 t01 on q201.ppsuc = t01.sucurs and q201.pgcod = t01.pgcod
    left join fsd008 D8 on Q201.ppcta = D8.ctnro AND Q201.PGCOD = D8.PGCOD
    LEFT JOIN (
        SELECT XWFEMPRESA,XWFMODULO,XWFSUCURSAL,XWFMONEDA,XWFPAPEL,XWFCUENTA,XWFOPERACION,
        XWFSUBOPE,XWFTIPOPE,MAX(XWFPRCINS)AS INST FROM XWF700
        WHERE XWFCAR3='1'GROUP BY
        XWFEMPRESA,XWFMODULO,XWFSUCURSAL,XWFMONEDA,XWFPAPEL,XWFCUENTA,XWFOPERACION,
        XWFSUBOPE,XWFTIPOPE
    )XWF ON
    Q201.PGCOD = XWF.XWFEMPRESA AND
    PPMOD = XWF.XWFMODULO AND
    --PPSUC = XWF.XWFSUCURSAL AND comentar agencia para el caso de tralsados
    PPMDA = XWF.XWFMONEDA AND
    PPPAP = XWF.XWFPAPEL AND
    PPCTA = XWF.XWFCUENTA AND
    PPOPER = XWF.XWFOPERACION AND
    PPSBOP = XWF.XWFSUBOPE AND
    PPTOPE = XWF.XWFTIPOPE

    left join fsd010 d10 on
    Q201.PGCOD = d10.PGCOD AND
    PPMOD = d10.AOMOD AND
    --PPSUC = d10.AOSUC AND
    PPMDA = d10.AOMDA AND
    PPPAP = d10.AOPAP AND
    PPCTA = d10.AOCTA AND
    PPOPER = d10.AOOPER AND
    PPSBOP = d10.AOSBOP AND
    PPTOPE = d10.AOTOPE
    WHERE
    PP1IMP_SGCOD_RR >0 AND --IMPORTE PAGADO EN RANGO DE FECHAS SEA MAYOR A CERO
    PP1IMP_SGCOD_HH >=PPIMP_SGCOD --IMPORTE PAGADO A LA FECHA SE MAYOR AL IMPORTE DE LA CUOTA(CUOTA DE SEGURO CANCELADO)
    and PPMOD = 112
    and PPMDA = 0
    --FIN PRESENTACION
)QNT
 UNION

--VEHICULAR DOLARES
 --566 REGISTROS  -- 36508.63  JULIO
 --1087 --        total 70362.39
SELECT * FROM(
  SELECT
    D10.PGCOD, PPCTA,PPOPER,PPSUC, PPMOD,PPMDA, PPPAP, PPSBOP, PPTOPE, (PP1IMP_SGCOD_RR),PPFPAG, PP1FECH
    FROM(
        --STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
        SELECT
        PGCOD,PPMOD,PPSUC,PPMDA,PPPAP,PPCTA,PPOPER,PPSBOP,PPTOPE,PPFPAG,PPTIPO,NUM_CUOTA,--OPERACION + CUOTA
        PP1FECH,--FECHA QUE HIZO EL ULTIMO PAGO
        CASE--IMPORTE A PAGAR SEGURO
        WHEN NUM_IMPORTE = 11 THEN PPIMP11
        WHEN NUM_IMPORTE = 12 THEN PPIMP12
        WHEN NUM_IMPORTE = 13 THEN PPIMP13
        WHEN NUM_IMPORTE = 14 THEN PPIMP14
        WHEN NUM_IMPORTE = 15 THEN PPIMP15
        END AS PPIMP_SGCOD,

        CASE--IMPORTE SEGURO PAGADO HASTA FECHA
        WHEN NUM_IMPORTE = 11 THEN PP1IMP11_HH
        WHEN NUM_IMPORTE = 12 THEN PP1IMP12_HH
        WHEN NUM_IMPORTE = 13 THEN PP1IMP13_HH
        WHEN NUM_IMPORTE = 14 THEN PP1IMP14_HH
        WHEN NUM_IMPORTE = 15 THEN PP1IMP15_HH
        END AS PP1IMP_SGCOD_HH,

        CASE--IMPORTE SEGURO PAGADO EN RANGO
        WHEN NUM_IMPORTE = 11 THEN PP1IMP11_RR
        WHEN NUM_IMPORTE = 12 THEN PP1IMP12_RR
        WHEN NUM_IMPORTE = 13 THEN PP1IMP13_RR
        WHEN NUM_IMPORTE = 14 THEN PP1IMP14_RR
        WHEN NUM_IMPORTE = 15 THEN PP1IMP15_RR
        END AS PP1IMP_SGCOD_RR
        FROM(
            --STRUCT 1, CRONOGRAMA-PAGOS
            SELECT Q1.PGCOD,Q1.PPMOD,Q1.PPSUC,Q1.PPMDA,Q1.PPPAP,Q1.PPCTA,Q1.PPOPER,Q1.PPSBOP,Q1.PPTOPE,
            Q1.PPFPAG,Q1.PPTIPO,Q1.NUM_CUOTA,Q1.NUM_IMPORTE,Q2.PP1FECH,
            Q1.PPIMP11,Q1.PPIMP12,Q1.PPIMP13,Q1.PPIMP14,Q1.PPIMP15,
            NVL(Q2.PP1IMP11_HH,0) AS PP1IMP11_HH,
            NVL(Q2.PP1IMP12_HH,0) AS PP1IMP12_HH,
            NVL(Q2.PP1IMP13_HH,0) AS PP1IMP13_HH,
            NVL(Q2.PP1IMP14_HH,0) AS PP1IMP14_HH,
            NVL(Q2.PP1IMP15_HH,0) AS PP1IMP15_HH,
            NVL(Q2.PP1IMP11_RR,0) AS PP1IMP11_RR,
            NVL(Q2.PP1IMP12_RR,0) AS PP1IMP12_RR,
            NVL(Q2.PP1IMP13_RR,0) AS PP1IMP13_RR,
            NVL(Q2.PP1IMP14_RR,0) AS PP1IMP14_RR,
            NVL(Q2.PP1IMP15_RR,0) AS PP1IMP15_RR
            FROM (
              ---CRONOGRAMA
              SELECT D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO,RANK() OVER (PARTITION BY D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE
              ORDER BY
              D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO
              ) AS NUM_CUOTA,Q33NY.NUM_IMPORTE,
              NVL(D611.PPIMP11,0) AS PPIMP11,
              NVL(D611.PPIMP12,0) AS PPIMP12,
              NVL(D611.PPIMP13,0) AS PPIMP13,
              NVL(D611.PPIMP14,0) AS PPIMP14,
              NVL(D611.PPIMP15,0) AS PPIMP15
              FROM FSD601 D601 LEFT JOIN FSD611 D611 ON
              D601.PGCOD = D611.PGCOD AND
              D601.PPMOD = D611.PPMOD AND
              D601.PPSUC = D611.PPSUC AND
              D601.PPMDA = D611.PPMDA AND
              D601.PPPAP = D611.PPPAP AND
              D601.PPCTA = D611.PPCTA AND
              D601.PPOPER = D611.PPOPER AND
              D601.PPSBOP = D611.PPSBOP AND
              D601.PPTOPE = D611.PPTOPE AND
              D601.PPFPAG = D611.PPFPAG AND
              D601.PPTIPO = D611.PPTIPO
              INNER JOIN(
                  --PRESTAMOS E IMPORTES
                  SELECT PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,NUM_IMPORTE FROM(
                  SELECT PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD,(RANK() OVER (PARTITION BY
                  PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE
                  ORDER BY PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD))+10 AS NUM_IMPORTE FROM FPP001 INNER JOIN DEPE62J ON
                  DEPE62JMOD = AOMOD AND
                  DEPE62JTOP = AOTOPE AND
                  DEPE62JMDA = AOMDA AND
                  DEPE62JPAP = AOPAP
                  ORDER BY PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,AOSBOP,AOTOPE,SGCOD)Q1
                  WHERE Q1.SGCOD IN((SELECT TP1NRO1 FROM FST198 WHERE TP1COD1=2036 AND TP1COD=1 AND TP1CORR1=100 AND TP1CORR2=3 AND TP1CORR3=10) UNION SELECT 150 FROM DUAL)
                  --FIN PRESTAMOS E IMPORTES
              )Q33NY ON
              D601.PGCOD = Q33NY.PGCOD AND
              D601.PPMOD = Q33NY.AOMOD AND
              D601.PPSUC = Q33NY.AOSUC AND
              D601.PPMDA = Q33NY.AOMDA AND
              D601.PPPAP = Q33NY.AOPAP AND
              D601.PPCTA = Q33NY.AOCTA AND
              D601.PPOPER = Q33NY.AOOPER AND
              D601.PPSBOP = Q33NY.AOSBOP AND
              D601.PPTOPE = Q33NY.AOTOPE

              WHERE D601CO='S'
              ORDER BY D601.PGCOD,D601.PPMOD,D601.PPSUC,D601.PPMDA,D601.PPPAP,D601.PPCTA,D601.PPOPER,D601.PPSBOP,D601.PPTOPE,
              D601.PPFPAG,D601.PPTIPO
              --FIN CRONOGRAMA
            )Q1 LEFT JOIN(
              ----PAGOS
              SELECT Q100.PGCOD,Q100.PPMOD,Q100.PPSUC,Q100.PPMDA,Q100.PPPAP,Q100.PPCTA,Q100.PPOPER,Q100.PPSBOP,Q100.PPTOPE,Q100.PPFPAG,Q100.PPTIPO,
              Q100.PP1IMP11_HH,Q100.PP1IMP12_HH,Q100.PP1IMP13_HH,Q100.PP1IMP14_HH,Q100.PP1IMP15_HH,
              NVL(Q101.PP1IMP11_RR,0) AS PP1IMP11_RR,NVL(Q101.PP1IMP12_RR,0)AS PP1IMP12_RR,NVL(Q101.PP1IMP13_RR,0)AS PP1IMP13_RR,
              NVL(Q101.PP1IMP14_RR,0) AS PP1IMP14_RR,NVL(Q101.PP1IMP15_RR,0)PP1IMP15_RR,Q101.PP1FECH
              FROM(
                    ---------------------------HASTA FECHA
                    SELECT D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO,SUM(NVL(D612.PP1IMP11,0)) AS PP1IMP11_HH,
                    SUM(NVL(D612.PP1IMP12,0)) AS PP1IMP12_HH,SUM(NVL(D612.PP1IMP13,0)) AS PP1IMP13_HH,SUM(NVL(D612.PP1IMP14,0)) AS PP1IMP14_HH,
                    SUM(NVL(D612.PP1IMP15,0)) AS PP1IMP15_HH FROM FSD602 D602 LEFT JOIN FSD612 D612 ON
                    D602.PGCOD = D612.PGCOD AND
                    D602.PPMOD = D612.PPMOD AND
                    D602.PPSUC = D612.PPSUC AND
                    D602.PPMDA = D612.PPMDA AND
                    D602.PPPAP = D612.PPPAP AND
                    D602.PPCTA = D612.PPCTA AND
                    D602.PPOPER = D612.PPOPER AND
                    D602.PPSBOP = D612.PPSBOP AND
                    D602.PPTOPE = D612.PPTOPE AND
                    D602.PPFPAG = D612.PPFPAG AND
                    D602.PPTIPO = D612.PPTIPO AND
                    D602.PP1NUMP = D612.PP1NUMP
                    WHERE D602CO='S' AND D602.PP1FECH <= to_date(pd_fecfin, 'yyyymmdd')--FECHA hasta
                    and  (/*d602.d602mo <> 30 and*/ d602.d602tr <> 390) -----------------
                    GROUP BY D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO
                    --------------------------------FIN HASTA FECHA
              )Q100 LEFT JOIN(
                    ---------------------------------------EN RANGO
                    SELECT D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO,SUM(NVL(D612.PP1IMP11,0)) AS PP1IMP11_RR,
                    SUM(NVL(D612.PP1IMP12,0)) AS PP1IMP12_RR,SUM(NVL(D612.PP1IMP13,0)) AS PP1IMP13_RR,SUM(NVL(D612.PP1IMP14,0)) AS PP1IMP14_RR,
                    SUM(NVL(D612.PP1IMP15,0)) AS PP1IMP15_RR,MAX(D602.PP1FECH)AS PP1FECH FROM FSD602 D602 LEFT JOIN FSD612 D612 ON
                    D602.PGCOD = D612.PGCOD AND
                    D602.PPMOD = D612.PPMOD AND
                    D602.PPSUC = D612.PPSUC AND
                    D602.PPMDA = D612.PPMDA AND
                    D602.PPPAP = D612.PPPAP AND
                    D602.PPCTA = D612.PPCTA AND
                    D602.PPOPER = D612.PPOPER AND
                    D602.PPSBOP = D612.PPSBOP AND
                    D602.PPTOPE = D612.PPTOPE AND
                    D602.PPFPAG = D612.PPFPAG AND
                    D602.PPTIPO = D612.PPTIPO AND
                    D602.PP1NUMP = D612.PP1NUMP
                    WHERE D602CO='S' AND D602.PP1FECH BETWEEN to_date(pd_fecini, 'yyyymmdd') AND to_date(pd_fecfin, 'yyyymmdd')--FECHA DESDE Y HASTA
                    and  (/*d602.d602mo <> 30 and*/ d602.d602tr <> 390) -----------------
                    GROUP BY D602.PGCOD,D602.PPMOD,D602.PPSUC,D602.PPMDA,D602.PPPAP,D602.PPCTA,D602.PPOPER,D602.PPSBOP,D602.PPTOPE,
                    D602.PPFPAG,D602.PPTIPO
                    --------------------------------------FIN EN RANGO
              )Q101 ON
              Q100.PGCOD = Q101.PGCOD AND
              Q100.PPMOD = Q101.PPMOD AND
              Q100.PPSUC = Q101.PPSUC AND
              Q100.PPMDA = Q101.PPMDA AND
              Q100.PPPAP = Q101.PPPAP AND
              Q100.PPCTA = Q101.PPCTA AND
              Q100.PPOPER = Q101.PPOPER AND
              Q100.PPSBOP = Q101.PPSBOP AND
              Q100.PPTOPE = Q101.PPTOPE AND
              Q100.PPFPAG = Q101.PPFPAG AND
              Q100.PPTIPO = Q101.PPTIPO
              ----FIN PAGOS
            )Q2 ON
            Q1.PGCOD = Q2.PGCOD AND
            Q1.PPMOD = Q2.PPMOD AND
            Q1.PPSUC = Q2.PPSUC AND
            Q1.PPMDA = Q2.PPMDA AND
            Q1.PPPAP = Q2.PPPAP AND
            Q1.PPCTA = Q2.PPCTA AND
            Q1.PPOPER = Q2.PPOPER AND
            Q1.PPSBOP = Q2.PPSBOP AND
            Q1.PPTOPE = Q2.PPTOPE AND
            Q1.PPFPAG = Q2.PPFPAG AND
            Q1.PPTIPO = Q2.PPTIPO
            --FIN STRUCT 1, CRONOGRAMA-PAGOS
        )Q200
        --FIN STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
    )Q201


    left join fst001 t01 on q201.ppsuc = t01.sucurs and q201.pgcod = t01.pgcod
    left join fsd008 D8 on Q201.ppcta = D8.ctnro AND Q201.PGCOD = D8.PGCOD
    LEFT JOIN (
        SELECT XWFEMPRESA,XWFMODULO,XWFSUCURSAL,XWFMONEDA,XWFPAPEL,XWFCUENTA,XWFOPERACION,
        XWFSUBOPE,XWFTIPOPE,MAX(XWFPRCINS)AS INST FROM XWF700
        WHERE XWFCAR3='1'GROUP BY
        XWFEMPRESA,XWFMODULO,XWFSUCURSAL,XWFMONEDA,XWFPAPEL,XWFCUENTA,XWFOPERACION,
        XWFSUBOPE,XWFTIPOPE
    )XWF ON
    Q201.PGCOD = XWF.XWFEMPRESA AND
    PPMOD = XWF.XWFMODULO AND
    --PPSUC = XWF.XWFSUCURSAL AND
    PPMDA = XWF.XWFMONEDA AND
    PPPAP = XWF.XWFPAPEL AND
    PPCTA = XWF.XWFCUENTA AND
    PPOPER = XWF.XWFOPERACION AND
    PPSBOP = XWF.XWFSUBOPE AND
    PPTOPE = XWF.XWFTIPOPE

    left join fsd010 d10 on
    Q201.PGCOD = d10.PGCOD AND
    PPMOD = d10.AOMOD AND
    --PPSUC = d10.AOSUC AND
    PPMDA = d10.AOMDA AND
    PPPAP = d10.AOPAP AND
    PPCTA = d10.AOCTA AND
    PPOPER = d10.AOOPER AND
    PPSBOP = d10.AOSBOP AND
    PPTOPE = d10.AOTOPE
    WHERE
    PP1IMP_SGCOD_RR >0 AND --IMPORTE PAGADO EN RANGO DE FECHAS SEA MAYOR A CERO
    PP1IMP_SGCOD_HH >=PPIMP_SGCOD --IMPORTE PAGADO A LA FECHA SE MAYOR AL IMPORTE DE LA CUOTA(CUOTA DE SEGURO CANCELADO)
    and PPMOD = 112
    and PPMDA = 101
    --FIN PRESENTACION
)QNT
UNION
----MOVIGAS SOLES
--430 REGISTROS -- 104889.33
--TOTAL 763  --- 186125.65
SELECT *
  FROM (
        
        SELECT D10.PGCOD,
                PPCTA,
                PPOPER,
                PPSUC,
                PPMOD,
                PPMDA,
                PPPAP,
                PPSBOP,
                PPTOPE,
                (PP1IMP_SGCOD_RR),
                PPFPAG,
                PP1FECH
          FROM (
                 --STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
                 SELECT PGCOD,
                         PPMOD,
                         PPSUC,
                         PPMDA,
                         PPPAP,
                         PPCTA,
                         PPOPER,
                         PPSBOP,
                         PPTOPE,
                         PPFPAG,
                         PPTIPO,
                         NUM_CUOTA, --OPERACION + CUOTA
                         PP1FECH, --FECHA QUE HIZO EL ULTIMO PAGO
                         CASE --IMPORTE A PAGAR SEGURO
                           WHEN NUM_IMPORTE = 11 THEN PPIMP11
                           WHEN NUM_IMPORTE = 12 THEN PPIMP12
                           WHEN NUM_IMPORTE = 13 THEN PPIMP13
                           WHEN NUM_IMPORTE = 14 THEN PPIMP14
                           WHEN NUM_IMPORTE = 15 THEN PPIMP15
                         END AS PPIMP_SGCOD,
                         
                         CASE --IMPORTE SEGURO PAGADO HASTA FECHA
                           WHEN NUM_IMPORTE = 11 THEN PP1IMP11_HH
                           WHEN NUM_IMPORTE = 12 THEN PP1IMP12_HH
                           WHEN NUM_IMPORTE = 13 THEN PP1IMP13_HH
                           WHEN NUM_IMPORTE = 14 THEN PP1IMP14_HH
                           WHEN NUM_IMPORTE = 15 THEN PP1IMP15_HH
                         END AS PP1IMP_SGCOD_HH,
                         
                         CASE --IMPORTE SEGURO PAGADO EN RANGO
                           WHEN NUM_IMPORTE = 11 THEN PP1IMP11_RR
                           WHEN NUM_IMPORTE = 12 THEN PP1IMP12_RR
                           WHEN NUM_IMPORTE = 13 THEN PP1IMP13_RR
                           WHEN NUM_IMPORTE = 14 THEN PP1IMP14_RR
                           WHEN NUM_IMPORTE = 15 THEN PP1IMP15_RR
                         END AS PP1IMP_SGCOD_RR
                   FROM (
                          --STRUCT 1, CRONOGRAMA-PAGOS
                          SELECT Q1.PGCOD,
                                  Q1.PPMOD,
                                  Q1.PPSUC,
                                  Q1.PPMDA,
                                  Q1.PPPAP,
                                  Q1.PPCTA,
                                  Q1.PPOPER,
                                  Q1.PPSBOP,
                                  Q1.PPTOPE,
                                  Q1.PPFPAG,
                                  Q1.PPTIPO,
                                  Q1.NUM_CUOTA,
                                  Q1.NUM_IMPORTE,
                                  Q2.PP1FECH,
                                  Q1.PPIMP11,
                                  Q1.PPIMP12,
                                  Q1.PPIMP13,
                                  Q1.PPIMP14,
                                  Q1.PPIMP15,
                                  NVL(Q2.PP1IMP11_HH, 0) AS PP1IMP11_HH,
                                  NVL(Q2.PP1IMP12_HH, 0) AS PP1IMP12_HH,
                                  NVL(Q2.PP1IMP13_HH, 0) AS PP1IMP13_HH,
                                  NVL(Q2.PP1IMP14_HH, 0) AS PP1IMP14_HH,
                                  NVL(Q2.PP1IMP15_HH, 0) AS PP1IMP15_HH,
                                  NVL(Q2.PP1IMP11_RR, 0) AS PP1IMP11_RR,
                                  NVL(Q2.PP1IMP12_RR, 0) AS PP1IMP12_RR,
                                  NVL(Q2.PP1IMP13_RR, 0) AS PP1IMP13_RR,
                                  NVL(Q2.PP1IMP14_RR, 0) AS PP1IMP14_RR,
                                  NVL(Q2.PP1IMP15_RR, 0) AS PP1IMP15_RR
                            FROM (
                                   ---CRONOGRAMA
                                   SELECT D601.PGCOD,
                                           D601.PPMOD,
                                           D601.PPSUC,
                                           D601.PPMDA,
                                           D601.PPPAP,
                                           D601.PPCTA,
                                           D601.PPOPER,
                                           D601.PPSBOP,
                                           D601.PPTOPE,
                                           D601.PPFPAG,
                                           D601.PPTIPO,
                                           RANK() OVER(PARTITION BY D601.PGCOD, D601.PPMOD, D601.PPSUC, D601.PPMDA, D601.PPPAP, D601.PPCTA, D601.PPOPER, D601.PPSBOP, D601.PPTOPE ORDER BY D601.PGCOD, D601.PPMOD, D601.PPSUC, D601.PPMDA, D601.PPPAP, D601.PPCTA, D601.PPOPER, D601.PPSBOP, D601.PPTOPE, D601.PPFPAG, D601.PPTIPO) AS NUM_CUOTA,
                                           Q33NY.NUM_IMPORTE,
                                           NVL(D611.PPIMP11, 0) AS PPIMP11,
                                           NVL(D611.PPIMP12, 0) AS PPIMP12,
                                           NVL(D611.PPIMP13, 0) AS PPIMP13,
                                           NVL(D611.PPIMP14, 0) AS PPIMP14,
                                           NVL(D611.PPIMP15, 0) AS PPIMP15
                                     FROM FSD601 D601
                                     LEFT JOIN FSD611 D611 ON D601.PGCOD = D611.PGCOD
                                                          AND D601.PPMOD = D611.PPMOD
                                                          AND D601.PPSUC = D611.PPSUC
                                                          AND D601.PPMDA = D611.PPMDA
                                                          AND D601.PPPAP = D611.PPPAP
                                                          AND D601.PPCTA = D611.PPCTA
                                                          AND D601.PPOPER = D611.PPOPER
                                                          AND D601.PPSBOP = D611.PPSBOP
                                                          AND D601.PPTOPE = D611.PPTOPE
                                                          AND D601.PPFPAG = D611.PPFPAG
                                                          AND D601.PPTIPO = D611.PPTIPO
                                    LEFT JOIN/*INNER JOIN*/ (
                                                --PRESTAMOS E IMPORTES
                                                SELECT PGCOD,
                                                        AOMOD,
                                                        AOSUC,
                                                        AOMDA,
                                                        AOPAP,
                                                        AOCTA,
                                                        AOOPER,
                                                        AOSBOP,
                                                        AOTOPE,
                                                        NUM_IMPORTE
                                                  FROM (SELECT PGCOD,
                                                                AOMOD,
                                                                AOSUC,
                                                                AOMDA,
                                                                AOPAP,
                                                                AOCTA,
                                                                AOOPER,
                                                                AOSBOP,
                                                                AOTOPE,
                                                                SGCOD,
                                                                (RANK()
                                                                 OVER(PARTITION BY PGCOD,
                                                                      AOMOD,
                                                                      AOSUC,
                                                                      AOMDA,
                                                                      AOPAP,
                                                                      AOCTA,
                                                                      AOOPER,
                                                                      AOSBOP,
                                                                      AOTOPE ORDER BY PGCOD,
                                                                      AOMOD,
                                                                      AOSUC,
                                                                      AOMDA,
                                                                      AOPAP,
                                                                      AOCTA,
                                                                      AOOPER,
                                                                      AOSBOP,
                                                                      AOTOPE,
                                                                      SGCOD)) + 10 AS NUM_IMPORTE
                                                           FROM FPP001
                                                          INNER JOIN DEPE62J ON DEPE62JMOD = AOMOD
                                                                            AND DEPE62JTOP = AOTOPE
                                                                            AND DEPE62JMDA = AOMDA
                                                                            AND DEPE62JPAP = AOPAP
                                                          ORDER BY PGCOD,
                                                                   AOMOD,
                                                                   AOSUC,
                                                                   AOMDA,
                                                                   AOPAP,
                                                                   AOCTA,
                                                                   AOOPER,
                                                                   AOSBOP,
                                                                   AOTOPE,
                                                                   SGCOD) Q1
                                                 WHERE Q1.SGCOD IN (108,109,110,111,112,113,114,115, 150 )
                                                                /*(SELECT TP1NRO1
                                                                 FROM FST198
                                                                WHERE TP1COD1 = 2036
                                                                  AND TP1COD = 1
                                                                  AND TP1CORR1 = 100
                                                                  AND TP1CORR2 = 3
                                                                  AND TP1CORR3 = 10 UNION
                                                  SELECT 150
                                                    FROM DUAL)*/
                                                  --FIN PRESTAMOS E IMPORTES
                                                
                                                ) Q33NY ON D601.PGCOD = Q33NY.PGCOD
                                                       AND D601.PPMOD = Q33NY.AOMOD
                                                       AND D601.PPSUC = Q33NY.AOSUC
                                                       AND D601.PPMDA = Q33NY.AOMDA
                                                       AND D601.PPPAP = Q33NY.AOPAP
                                                       AND D601.PPCTA = Q33NY.AOCTA
                                                       AND D601.PPOPER = Q33NY.AOOPER
                                                       AND D601.PPSBOP = Q33NY.AOSBOP
                                                       AND D601.PPTOPE = Q33NY.AOTOPE
                                   
                                    WHERE D601CO = 'S'
                                    ORDER BY D601.PGCOD,
                                              D601.PPMOD,
                                              D601.PPSUC,
                                              D601.PPMDA,
                                              D601.PPPAP,
                                              D601.PPCTA,
                                              D601.PPOPER,
                                              D601.PPSBOP,
                                              D601.PPTOPE,
                                              D601.PPFPAG,
                                              D601.PPTIPO
                                   --FIN CRONOGRAMA
                                   ) Q1
                            LEFT JOIN (
                                       ----PAGOS
                                       SELECT Q100.PGCOD,
                                               Q100.PPMOD,
                                               Q100.PPSUC,
                                               Q100.PPMDA,
                                               Q100.PPPAP,
                                               Q100.PPCTA,
                                               Q100.PPOPER,
                                               Q100.PPSBOP,
                                               Q100.PPTOPE,
                                               Q100.PPFPAG,
                                               Q100.PPTIPO,
                                               Q100.PP1IMP11_HH,
                                               Q100.PP1IMP12_HH,
                                               Q100.PP1IMP13_HH,
                                               Q100.PP1IMP14_HH,
                                               Q100.PP1IMP15_HH,
                                               NVL(Q101.PP1IMP11_RR, 0) AS PP1IMP11_RR,
                                               NVL(Q101.PP1IMP12_RR, 0) AS PP1IMP12_RR,
                                               NVL(Q101.PP1IMP13_RR, 0) AS PP1IMP13_RR,
                                               NVL(Q101.PP1IMP14_RR, 0) AS PP1IMP14_RR,
                                               NVL(Q101.PP1IMP15_RR, 0) PP1IMP15_RR,
                                               Q101.PP1FECH
                                         FROM (
                                                ---------------------------HASTA FECHA
                                                SELECT D602.PGCOD,
                                                        D602.PPMOD,
                                                        D602.PPSUC,
                                                        D602.PPMDA,
                                                        D602.PPPAP,
                                                        D602.PPCTA,
                                                        D602.PPOPER,
                                                        D602.PPSBOP,
                                                        D602.PPTOPE,
                                                        D602.PPFPAG,
                                                        D602.PPTIPO,
                                                        SUM(NVL(D612.PP1IMP11, 0)) AS PP1IMP11_HH,
                                                        SUM(NVL(D612.PP1IMP12, 0)) AS PP1IMP12_HH,
                                                        SUM(NVL(D612.PP1IMP13, 0)) AS PP1IMP13_HH,
                                                        SUM(NVL(D612.PP1IMP14, 0)) AS PP1IMP14_HH,
                                                        SUM(NVL(D612.PP1IMP15, 0)) AS PP1IMP15_HH
                                                  FROM FSD602 D602
                                                  LEFT JOIN FSD612 D612 ON D602.PGCOD = D612.PGCOD
                                                                       AND D602.PPMOD = D612.PPMOD
                                                                       AND D602.PPSUC = D612.PPSUC
                                                                       AND D602.PPMDA = D612.PPMDA
                                                                       AND D602.PPPAP = D612.PPPAP
                                                                       AND D602.PPCTA = D612.PPCTA
                                                                       AND D602.PPOPER = D612.PPOPER
                                                                       AND D602.PPSBOP = D612.PPSBOP
                                                                       AND D602.PPTOPE = D612.PPTOPE
                                                                       AND D602.PPFPAG = D612.PPFPAG
                                                                       AND D602.PPTIPO = D612.PPTIPO
                                                                       AND D602.PP1NUMP = D612.PP1NUMP
                                                 WHERE D602CO = 'S'
                                                   AND D602.PP1FECH <=
                                                       to_date(pd_fecfin, 'yyyymmdd') --FECHA hasta
                                                    and  (/*d602.d602mo <> 30 and*/ d602.d602tr <> 390) -----------------
                                                 GROUP BY D602.PGCOD,
                                                           D602.PPMOD,
                                                           D602.PPSUC,
                                                           D602.PPMDA,
                                                           D602.PPPAP,
                                                           D602.PPCTA,
                                                           D602.PPOPER,
                                                           D602.PPSBOP,
                                                           D602.PPTOPE,
                                                           D602.PPFPAG,
                                                           D602.PPTIPO
                                                --------------------------------FIN HASTA FECHA
                                                ) Q100
                                         LEFT JOIN (
                                                    ---------------------------------------EN RANGO
                                                    SELECT D602.PGCOD,
                                                            D602.PPMOD,
                                                            D602.PPSUC,
                                                            D602.PPMDA,
                                                            D602.PPPAP,
                                                            D602.PPCTA,
                                                            D602.PPOPER,
                                                            D602.PPSBOP,
                                                            D602.PPTOPE,
                                                            D602.PPFPAG,
                                                            D602.PPTIPO,
                                                            SUM(NVL(D612.PP1IMP11, 0)) AS PP1IMP11_RR,
                                                            SUM(NVL(D612.PP1IMP12, 0)) AS PP1IMP12_RR,
                                                            SUM(NVL(D612.PP1IMP13, 0)) AS PP1IMP13_RR,
                                                            SUM(NVL(D612.PP1IMP14, 0)) AS PP1IMP14_RR,
                                                            SUM(NVL(D612.PP1IMP15, 0)) AS PP1IMP15_RR,
                                                            MAX(D602.PP1FECH) AS PP1FECH
                                                      FROM FSD602 D602
                                                      LEFT JOIN FSD612 D612 ON D602.PGCOD = D612.PGCOD
                                                                           AND D602.PPMOD = D612.PPMOD
                                                                           AND D602.PPSUC = D612.PPSUC
                                                                           AND D602.PPMDA = D612.PPMDA
                                                                           AND D602.PPPAP = D612.PPPAP
                                                                           AND D602.PPCTA = D612.PPCTA
                                                                           AND D602.PPOPER = D612.PPOPER
                                                                           AND D602.PPSBOP = D612.PPSBOP
                                                                           AND D602.PPTOPE = D612.PPTOPE
                                                                           AND D602.PPFPAG = D612.PPFPAG
                                                                           AND D602.PPTIPO = D612.PPTIPO
                                                                           AND D602.PP1NUMP = D612.PP1NUMP
                                                     WHERE D602CO = 'S'
                                                       and  (/*d602.d602mo <> 30 and*/ d602.d602tr <> 390) -----------------
                                                       AND D602.PP1FECH BETWEEN to_date(pd_fecini, 'yyyymmdd') AND
                                                                                to_date(pd_fecfin, 'yyyymmdd') --FECHA DESDE Y HASTA
                                                     GROUP BY D602.PGCOD,
                                                               D602.PPMOD,
                                                               D602.PPSUC,
                                                               D602.PPMDA,
                                                               D602.PPPAP,
                                                               D602.PPCTA,
                                                               D602.PPOPER,
                                                               D602.PPSBOP,
                                                               D602.PPTOPE,
                                                               D602.PPFPAG,
                                                               D602.PPTIPO
                                                    --------------------------------------FIN EN RANGO
                                                    ) Q101 ON Q100.PGCOD = Q101.PGCOD
                                                          AND Q100.PPMOD = Q101.PPMOD
                                                          AND Q100.PPSUC = Q101.PPSUC
                                                          AND Q100.PPMDA = Q101.PPMDA
                                                          AND Q100.PPPAP = Q101.PPPAP
                                                          AND Q100.PPCTA = Q101.PPCTA
                                                          AND Q100.PPOPER = Q101.PPOPER
                                                          AND Q100.PPSBOP = Q101.PPSBOP
                                                          AND Q100.PPTOPE = Q101.PPTOPE
                                                          AND Q100.PPFPAG = Q101.PPFPAG
                                                          AND Q100.PPTIPO = Q101.PPTIPO
                                       ----FIN PAGOS
                                       ) Q2 ON Q1.PGCOD = Q2.PGCOD
                                           AND Q1.PPMOD = Q2.PPMOD
                                           AND Q1.PPSUC = Q2.PPSUC
                                           AND Q1.PPMDA = Q2.PPMDA
                                           AND Q1.PPPAP = Q2.PPPAP
                                           AND Q1.PPCTA = Q2.PPCTA
                                           AND Q1.PPOPER = Q2.PPOPER
                                           AND Q1.PPSBOP = Q2.PPSBOP
                                           AND Q1.PPTOPE = Q2.PPTOPE
                                           AND Q1.PPFPAG = Q2.PPFPAG
                                           AND Q1.PPTIPO = Q2.PPTIPO
                          --FIN STRUCT 1, CRONOGRAMA-PAGOS
                          ) Q200
                 --FIN STRUCT 2, CRONOGRAMA-PAGOS , IMPORTE SELECCIONADO
                 ) Q201
        
          left join fst001 t01 on q201.ppsuc = t01.sucurs
                              and q201.pgcod = t01.pgcod
          left join fsd008 D8 on Q201.ppcta = D8.ctnro
                             AND Q201.PGCOD = D8.PGCOD
         /* LEFT JOIN (SELECT XWFEMPRESA,
                            XWFMODULO,
                            XWFSUCURSAL,
                            XWFMONEDA,
                            XWFPAPEL,
                            XWFCUENTA,
                            XWFOPERACION,
                            XWFSUBOPE,
                            XWFTIPOPE,
                            MAX(XWFPRCINS) AS INST
                       FROM XWF700
                      WHERE XWFCAR3 = '1'
                      GROUP BY XWFEMPRESA,
                               XWFMODULO,
                               XWFSUCURSAL,
                               XWFMONEDA,
                               XWFPAPEL,
                               XWFCUENTA,
                               XWFOPERACION,
                               XWFSUBOPE,
                               XWFTIPOPE) XWF ON Q201.PGCOD = XWF.XWFEMPRESA
                                             AND PPMOD = XWF.XWFMODULO
                                             AND
                                                --PPSUC = XWF.XWFSUCURSAL AND
                                                 PPMDA = XWF.XWFMONEDA
                                             AND PPPAP = XWF.XWFPAPEL
                                             AND PPCTA = XWF.XWFCUENTA
                                             AND PPOPER = XWF.XWFOPERACION
                                             AND PPSBOP = XWF.XWFSUBOPE
                                             AND PPTOPE = XWF.XWFTIPOPE*/
        
          left join fsd010 d10 on Q201.PGCOD = d10.PGCOD
                              AND PPMOD = d10.AOMOD
                              AND
                                 --PPSUC = d10.AOSUC AND
                                  PPMDA = d10.AOMDA
                              AND PPPAP = d10.AOPAP
                              AND PPCTA = d10.AOCTA
                              AND PPOPER = d10.AOOPER
                              AND PPSBOP = d10.AOSBOP
                              AND PPTOPE = d10.AOTOPE
         WHERE PP1IMP_SGCOD_RR > 0
           AND --IMPORTE PAGADO EN RANGO DE FECHAS SEA MAYOR A CERO
               PP1IMP_SGCOD_HH >= PPIMP_SGCOD --IMPORTE PAGADO A LA FECHA SE MAYOR AL IMPORTE DE LA CUOTA(CUOTA DE SEGURO CANCELADO)
           and PPMOD = 113
           and PPMDA = 0
          -- and PPCTA in (233752,1213913,271097,1119988)
        --FIN PRESENTACION
        ) QNT;

 commit;

end sp_cr_inserta_mv;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_seguro_MV
  is
      -- *****************************************************************
      -- Nombre                     : sp_cr_seguro_MV
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Actvias
      -- Versión                    : 1.0
      -- Fecha de Creación          : 
      -- Autor de Creación          : 
      -- Uso                        : COBROS SEGUROS MOVIGAS/SEGURO VEHICULAR
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Parámetros de Entrada      : pc_analista: asesor
      -- Parámetros de Salida       : tipo Analista: Convenio Pyme
      -- Fecha de Modificación      :
      -- Autor de la Modificación   :
      -- Descripción de Modificación:
      -- *****************************************************************
      
 CURSOR CREDITOS IS
 SELECT DISTINCT C_DESCRI PGCOD, C_DESCRI1 SCCTA,C_DESCRI2 SCOPER, 
        C_DESCRI3 SCSUC ,C_DESCRI4 SCMOD,C_DESCRI5 SCMDA,C_DESCRI6 SCPAP,C_DESCRI7 SCSBOP, C_DESCRI8 SCTOPE
  FROM CRDTCAP; --895


BEGIN

--PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
  FOR I IN CREDITOS LOOP
      BEGIN
         UPDATE FSD011 F
            SET SCSTAT = 89
          WHERE F.PGCOD = I.PGCOD
            AND F.SCMOD = 260--I.SCMOD
            AND F.SCMDA = I.SCMDA
            AND F.SCPAP = I.SCPAP
            AND F.SCCTA = I.SCCTA
            AND F.SCSUC = I.SCSUC
            AND F.SCOPER = I.SCOPER
            AND F.SCSBOP = 0--I.SCSBOP
            AND F.SCTOPE = 0--I.SCTOPE
            AND SUBSTR(F.SCRUB,1,2) = '25' 
--            and (F.SCRUB not in ( '2524020000008','2514020000008','2514020000013','2524020000013'))
              and (F.SCRUB in ( '2524020000002','2514020000002','2514020000007','2524020000007'))
            and f.scstat  <> 89; 
      END;
      commit; --2018.12.12 dcastro
      
  END LOOP;
 

end sp_cr_seguro_mv;  
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


----------------------------------------------------------------------------------------
end Pq_cr_cobros_seguros;
/

