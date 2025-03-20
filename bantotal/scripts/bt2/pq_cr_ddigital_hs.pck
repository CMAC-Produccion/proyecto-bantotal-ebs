create or replace package pq_cr_DDigital_HS is

  -- Author  : HSUAREZ
  -- Created : 11/01/2022 16:55:58
  -- Purpose : Paquete para obtener la TEA y la TEA Moratorioa datos de desembolso digital documentos
  
procedure sp_obtener_tasa_TEA_MOR(vi_Instancia number,
                                  vo_TEAI out number,
                                  vo_TEAF out number,
                                  vo_TEAMOR out number                             
                                 );

end pq_cr_DDigital_HS;
/

create or replace package body pq_cr_DDigital_HS is


procedure sp_obtener_tasa_TEA_MOR(vi_Instancia number,
                                  vo_TEAI out number,
                                  vo_TEAF out number,
                                  vo_TEAMOR out number                             
                                 ) is
                                
BEGIN
  --OBTENER LA TASA EFECTIVA ANUAL.
  BEGIN
    SELECT case when  TASA_FIN  is null then
         TASA_INI
         else TASA_FIN end
           into  vo_TEAI
    FROM
    (
    SELECT
     (  SELECT C.EVTASA
        FROM XWF700 d left join  FSD012 C on C.AOCTA=d.XWFCUENTA    and  C.AOOPER = d.XWFOPERACION
                                                              and C.PGCOD = d.XWFEMPRESA
                                                              AND C.AOMOD = d.XWFMODULO
                                                              AND C.AOSUC = d.XWFSUCURSAL
                                                              AND C.AOMDA =  d.XWFMONEDA
                                                              AND C.AOPAP = d.XWFPAPEL
                                                              AND C.AOSBOP = d.XWFSUBOPE
                                                              AND C.AOTOPE = d.XWFTIPOPE
                              WHERE d.XWFPRCINS = vi_Instancia
                              AND ROWNUM = 1
                              AND C.EVTIPO = 3
                              AND C.D012CO = 'S'
                              AND XWFCAR3  = '1')TASA_FIN,
     B.AOTASA  TASA_INI     
   FROM FSD010 B, XWF700 A
         WHERE A.XWFPRCINS  = vi_Instancia
         AND B.PGCOD  = A.XWFEMPRESA
         AND ROWNUM   = 1
         AND B.AOMOD  = A.XWFMODULO
         AND B.AOSUC  = A.XWFSUCURSAL
         AND B.AOMDA  = A.XWFMONEDA
         AND B.AOPAP  = A.XWFPAPEL
         AND B.AOCTA  = A.XWFCUENTA
         AND B.AOOPER = A.XWFOPERACION
         AND B.AOSBOP = A.XWFSUBOPE
         AND B.AOTOPE = A.XWFTIPOPE
         AND XWFCAR3  = '1');         
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
  END;
  --obtener la tasa moratoria
  BEGIN
     SELECT F.TP1IMP1 TEAMOR
      INTO vo_TEAMOR
          FROM FST198 F, XWF700 X, X054021 XX
         WHERE F.TP1COD = 1
           AND F.TP1COD1 = 11138
           AND F.TP1CORR1 = 19
           AND F.TP1CORR2 = 1
           AND F.TP1CORR3 > 0
           AND F.TP1NRO1 = X.XWFMONEDA
           AND X.XWFCAR3 = '1'
           AND X.XWFPRCINS = vi_Instancia
           AND X.XWFEMPRESA = XX.PGCOD
           AND X.XWFSUCURSAL = XX.XLLOAOSUC
           AND X.XWFMODULO = XX.XLLOAOMOD
           AND X.XWFMONEDA = XX.XLLOAOMDA
           AND X.XWFPAPEL = XX.XLLOAOPAP
           AND X.XWFCUENTA = XX.XLLOAOCTA
           AND X.XWFOPERACION = XX.XLLOAOOPER
           AND X.XWFSUBOPE = XX.XLLOAOSBOP
           AND X.XWFTIPOPE = XX.XLLOAOTOPE
           AND XX.XLLOTXTCOD = 250
           AND XX.XLLOTEXTO = 'I';
  EXCEPTION
    WHEN OTHERS THEN
      NULL;             
  END;
END;                                 

end pq_cr_DDigital_HS;
/

