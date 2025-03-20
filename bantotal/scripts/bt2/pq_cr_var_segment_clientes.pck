CREATE OR REPLACE PACKAGE PQ_CR_VAR_SEGMENT_CLIENTES IS

  -- *****************************************************************
  -- NOMBRE                      : PQ_CR_VAR_SEGMENT_CLIENTES
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 22/04/2024
  -- AUTOR DE CREACION           : MILTON CORDOVA
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  --------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  --
  -- *****************************************************************
  PROCEDURE SP_CR_VAR_SEGMENT_CLIENTES(V_PAI           IN NUMBER,
                                       V_TIP_DOC       IN NUMBER,
                                       V_NUM_DOC       IN char,
                                       V_INDEPE_DEPEND OUT VARCHAR2,
                                       V_EST_CIVIL     OUT VARCHAR2,
                                       V_CIIU          OUT VARCHAR2,
                                       V_ACTIVI_ECONOM OUT VARCHAR2,
                                       V_FEC_VAL       OUT DATE,
                                       V_COD_ASESOR    OUT VARCHAR,
                                       V_ASESOR        OUT VARCHAR2,
                                       V_FEC_ANT       OUT DATE,
                                       V_FEC_REC       OUT DATE,
                                       V_AGE_DES       OUT VARCHAR2);
END PQ_CR_VAR_SEGMENT_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_VAR_SEGMENT_CLIENTES IS

  PROCEDURE SP_CR_VAR_SEGMENT_CLIENTES(V_PAI           IN NUMBER,
                                       V_TIP_DOC       IN NUMBER,
                                       V_NUM_DOC       IN char,
                                       V_INDEPE_DEPEND OUT VARCHAR2,
                                       V_EST_CIVIL     OUT VARCHAR2,
                                       V_CIIU          OUT VARCHAR2,
                                       V_ACTIVI_ECONOM OUT VARCHAR2,
                                       V_FEC_VAL       OUT DATE,
                                       V_COD_ASESOR    OUT VARCHAR,
                                       V_ASESOR        OUT VARCHAR2,
                                       V_FEC_ANT       OUT DATE,
                                       V_FEC_REC       OUT DATE,
                                       V_AGE_DES       OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_VAR_SEGMENT_CLIENTES
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 22/04/2024
    -- AUTOR DE CREACION           : MILTON CORDOVA
    -- USO                         : GENERA VARIABLES SEGMENTACION
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- *****************************************************************
    V_COD_EST_CIVIL NUMBER(10);
  BEGIN
    
    -- INDEPENDIENTE / DEPENDIENTE
    BEGIN
      if V_TIP_DOC <> 9 then
        begin
          select DECODE(to_number(trim(b.segcod)),
                        1,
                        'Independiente',
                        2,
                        'Dependiente')
            into V_INDEPE_DEPEND
            from sngc60 a, sngc07 b
           where a.sngc60pais = V_PAI
             and a.sngc60tdoc = V_TIP_DOC
             and a.sngc60ndoc = V_NUM_DOC
             and a.sngc60ocup = b.sngc07cod;
        exception
          when too_many_rows then
            begin
              select DECODE(to_number(trim(b.segcod)),
                            1,
                            'Independiente',
                            2,
                            'Dependiente')
                into V_INDEPE_DEPEND
                from sngc60 a, sngc07 b
               where a.sngc60pais = V_PAI
                 and a.sngc60tdoc = V_TIP_DOC
                 and a.sngc60ndoc = V_NUM_DOC
                 and a.sngc60ocup = b.sngc07cod
                 and a.sngc60corr =
                     (select min(a.sngc60corr)
                        from sngc60 a, sngc07 b
                       where a.sngc60pais = V_PAI
                         and a.sngc60tdoc = V_TIP_DOC
                         and a.sngc60ndoc = V_NUM_DOC
                         and a.sngc60ocup = b.sngc07cod);
            end;
          when others then
            null;
        end;
      else
        if V_TIP_DOC = 9 then
          V_INDEPE_DEPEND := 1;
        end if;
      end if;
    EXCEPTION
      when others then
        null;
    END;
  
    -- ESTADO CIVIL   
    BEGIN
      begin
        select d.pfeciv
          into V_COD_EST_CIVIL
          from fsd002 d
         where d.pfpais = V_PAI
           and d.pftdoc = V_TIP_DOC
           and d.pfndoc = V_NUM_DOC;
      exception
        when no_data_found then
          V_COD_EST_CIVIL := 0;
      end;
      if V_COD_EST_CIVIL = 1 then
        V_EST_CIVIL := 'CASADO'; --  Casado 
      else
        if V_COD_EST_CIVIL = 2 then
          V_EST_CIVIL := 'DIVORCIADO'; -- Divorciado
        else
          if V_COD_EST_CIVIL = 3 then
            V_EST_CIVIL := 'CONVIVIENTE'; -- Conviviente  
          else
            if V_COD_EST_CIVIL = 4 then
              V_EST_CIVIL := 'SOLTERO'; --  Soltero   
            else
              if V_COD_EST_CIVIL = 5 then
                V_EST_CIVIL := 'VIUDO'; -- Viudo          
              else
                if V_COD_EST_CIVIL = 6 then
                  V_EST_CIVIL := 'SEPARADO'; --  Separado                 
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    EXCEPTION
      when others then
        null;
    END;
  
    -- ACTIVIDAD ECONOMICA
    BEGIN
      If V_TIP_DOC <> 9 THEN
        SELECT T2.ActNom1, T2.ActNom1
          INTO V_ACTIVI_ECONOM, V_CIIU
          FROM SNGC60 T1
          JOIN FST750 T2
            ON SNGC60Pais = V_PAI
           AND SNGC60Tdoc = V_TIP_DOC
           AND SNGC60Ndoc = V_NUM_DOC
           AND SNGC60Acte = ActCod1;
      ELSE
        SELECT T2.ActNom1, T2.ActNom1
          INTO V_ACTIVI_ECONOM, V_CIIU
          FROM FSE001 T1
          JOIN FST750 T2
            ON T1.ExpNIns = T2.ActCod1
           AND D511Pais = V_PAI
           AND D511Tdoc = V_TIP_DOC
           AND D511Ndoc = V_NUM_DOC;
      End If;
    EXCEPTION
      when others then
        null;
    END;
  
    -- FECHA DE PRIMER CREDITO
    BEGIN
      SELECT MIN(AOFVAL)
        INTO V_FEC_VAL
        FROM FSR008 T1
        JOIN FSD010 T2
          ON T1.CTNRO = T2.AOCTA
         AND T1.PGCOD = T2.PGCOD
         AND T1.PEPAIS = V_PAI
         AND T1.PETDOC = V_TIP_DOC
         AND T1.PENDOC = V_NUM_DOC
         AND T1.TTCOD = 1
        JOIN FST111 T3
          ON T3.DSCOD = 50
         AND T2.AOMOD = T3.MODULO;
    EXCEPTION
      when others then
        null;
    END;
  
    -- ANALISTA / AGENCIA
    BEGIN 
     SELECT T2.UBUSER, T2.UBNOM, T3.SCNOM
       INTO V_COD_ASESOR, V_ASESOR, V_AGE_DES
       FROM SNG001 T1
       JOIN FST746 T2
          ON T1.SNG001ASE = T2.UBUSER
       JOIN FST001 T3
          ON T1.SNG001AGE = T3.SUCURS
      WHERE T1.SNG001Pais = V_PAI
        AND T1.SNG001Tdoc = V_TIP_DOC
        AND T1.SNG001NDoc = V_NUM_DOC
        AND SNG001INST =
            (SELECT MAX(SNG001INST)
               FROM SNG001 S, XWF700 X, FSD010 F
              WHERE S.SNG001INST = X.XWFPRCINS
                AND X.XWFCAR3 = '1'
                AND F.PGCOD = X.XWFEMPRESA
                AND F.AOSUC = X.XWFSUCURSAL
                AND F.AOMOD = X.XWFMODULO
                AND F.AOMDA = X.XWFMONEDA
                AND F.AOPAP = X.XWFPAPEL
                AND F.AOCTA = X.XWFCUENTA
                AND F.AOOPER = X.XWFOPERACION
                AND F.AOSBOP = X.XWFSUBOPE
                AND F.AOTOPE = X.XWFTIPOPE 
                AND S.SNG001PAIS = V_PAI
                AND S.SNG001TDOC = V_TIP_DOC
                AND S.SNG001NDOC = V_NUM_DOC
                and F.AOSTAT <> 99);
        EXCEPTION
      when others then
        null;
    END;
  
    -- FECHA DE PRIMER CREDITO MAS ANTIGUO
    BEGIN
      SELECT MIN(T2.AOFVAL)
        INTO V_FEC_ANT
        FROM FSR008 T1
        JOIN FSD010 T2
          ON T1.PGCOD = T2.PGCOD
         AND T1.CTNRO = T2.AOCTA
       WHERE T1.PEPAIS = V_PAI
         AND T1.PETDOC = V_TIP_DOC
         AND T1.PENDOC = V_NUM_DOC
         AND CTTFIR = 'T'
         AND TTCOD = 1;
    EXCEPTION
      when others then
        null;
    END;
  
    -- FECHA DE CREDITO MAS RECIENTE
    BEGIN
      SELECT MAX(T2.AOFVAL)
        INTO V_FEC_REC
        FROM FSR008 T1
        JOIN FSD010 T2
          ON T1.PGCOD = T2.PGCOD
         AND T1.CTNRO = T2.AOCTA
       WHERE T1.PEPAIS = V_PAI
         AND T1.PETDOC = V_TIP_DOC
         AND T1.PENDOC = V_NUM_DOC
         AND CTTFIR = 'T'
         AND TTCOD = 1;
    EXCEPTION
      when others then
        null;
    END;
  
    -- AGENCIA A PARTIR DE FECHA DE DESEMBOLSO
    /*BEGIN
      SELECT T2.SCNOM
        INTO V_AGE_DES
        FROM SNG001 T1
        JOIN FST001 T2
          ON T1.SNG001Age = T2.Sucurs
       WHERE SNG001INST = (SELECT MAX(SNG001INST)
                             FROM SNG001
                            WHERE SNG001PAIS = V_PAI
                              AND SNG001TDOC = V_TIP_DOC
                              AND SNG001NDOC = V_NUM_DOC);
    EXCEPTION
      when others then
        null;
    END;*/
  
  END SP_CR_VAR_SEGMENT_CLIENTES;
END PQ_CR_VAR_SEGMENT_CLIENTES;
/

