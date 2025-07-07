create or replace package pq_cr_regis_visitas_riesg is

  -- *****************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Author                     : IGS_RCASTRO
  -- Created                    : 17/06/2025 16:32:51
  -- Purpose                    : PAQUETE DE GESTION DE CONTROL DE VISITAS DE RIESGOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 27/06/2025
  -- Autor de la Modificación   : rcastro
  -- Detalle:                   : se modifica la obtencion del mes que sea del campo periodo.

  -- *****************************************************************  
 
  PROCEDURE SP_GUARDAR_VISITAS(pe_AQPC845FREG    date, 
                               pe_AQPC845HREG    varchar2,
                               pe_AQPC845USUREG  varchar2,
                               pe_AQPC845AGES    number,
                               pe_AQPC845NOMS    varchar2,
                               -- pe_AQPC845ZON     number,
                               --pe_AQPC845NOMZ    varchar2,
                               --pe_AQPC845REG     number,
                               --pe_AQPC845NOMR    varchar2,
                               pe_AQPC845TIPVIST NUMBER,
                               pe_AQPC845FINIVIS date,
                               pe_AQPC845FFINVIS date,
                               --pe_AQPC845ANIO    number,
                               --pe_AQPC845MES     number, 
                               pe_AQPC845USUVIST varchar2,
                               ps_CODERROR OUT NUMBER,
                               PS_MsgError OUT VARCHAR2);
                               
  ------------------------------------------------------------------------------ 
                                 
  PROCEDURE SP_VAL_MINIM_REG_CONTRL(pe_agencia number,
                                    fecIniVisit date,
                                    fecFinVisit date,
                                    ps_CODERROR OUT NUMBER,
                                    PS_MsgError OUT VARCHAR2);                           
                                    
  ------------------------------------------------------------------------------    
                                   
  function SP_GENRT_CORRELATIVO RETURN VARCHAR2; 
        
  ------------------------------------------------------------------------------    
  PROCEDURE SP_CALCULAR_CALIFICACION_AGENC(pe_agencia  number,
                                           fecIniVisit date,
                                           fecFinVisit date,
                                           calificacion OUT VARCHAR2);  
                   
  
end pq_cr_regis_visitas_riesg;
/
create or replace package body pq_cr_regis_visitas_riesg is

  PROCEDURE SP_GUARDAR_VISITAS(pe_AQPC845FREG    date, 
                               pe_AQPC845HREG    varchar2,
                               pe_AQPC845USUREG  varchar2,
                               pe_AQPC845AGES    number,
                               pe_AQPC845NOMS    varchar2,
                               --pe_AQPC845ZON     number,
                               --pe_AQPC845NOMZ    varchar2,
                               --pe_AQPC845REG     number,
                               --pe_AQPC845NOMR    varchar2,
                               pe_AQPC845TIPVIST NUMBER,
                               pe_AQPC845FINIVIS date,
                               pe_AQPC845FFINVIS date,
                               --pe_AQPC845ANIO    number,
                               --pe_AQPC845MES     number, 
                               pe_AQPC845USUVIST varchar2,
                               ps_CODERROR OUT NUMBER,
                               PS_MsgError OUT VARCHAR2) IS
  pe_AQPC845NOMR varchar2(50);
  pe_AQPC845ZON  number;  
  pe_AQPC845NOMZ varchar2(50);  
  pe_AQPC845REG  number;  
  
  V_DESCRTIPOVISITA VARCHAR2(30);
  v_AQPC845ANIO  number(4);
  v_AQPC845MES   VARCHAR2(20);
  V_CALIFICACION VARCHAR2(30);
  BEGIN
     ps_CODERROR := 0;
     PS_MsgError := '';
     
 --codigo zona
    BEGIN
      SELECT REGCOD
        INTO pe_AQPC845ZON
        FROM FST811
       WHERE PGCOD = 1
         AND OFICOD = pe_AQPC845AGES
         AND REGCOD < 100;
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;
    END;
  
    --NOMBRE ZONA
    BEGIN
      SELECT REGNOM
        INTO pe_AQPC845NOMZ
        FROM FST810
       WHERE PGCOD = 1
         AND REGCOD = pe_AQPC845ZON
         AND REGCOD < 100;
    EXCEPTION
      WHEN OTHERS THEN       
        NULL;
    END;
  
    --CODIGO Y NOMBRE REGION
    BEGIN
      SELECT TP1NRO1, TP1DESC
        INTO pe_AQPC845REG, pe_AQPC845NOMR
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10872
         AND TP1CORR1 = 11
         AND TP1NRO2 = pe_AQPC845ZON;
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;
    END;    
    
    --COLOCAR DESCRP TIPO DE VISTA
    BEGIN      
      select TP1DESC INTO V_DESCRTIPOVISITA   FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11152 AND TP1CORR1
       = 311 and tp1corr2 = 1 and tp1corr3 > 0 AND TP1NRO3 = pe_AQPC845TIPVIST;      
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;      
    END;   
    
    V_DESCRTIPOVISITA := NVL(V_DESCRTIPOVISITA, '');  
    
    --ANIO
    BEGIN
       SELECT EXTRACT(YEAR FROM pe_AQPC845FINIVIS) INTO v_AQPC845ANIO FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;        
    END;
    v_AQPC845ANIO := NVL(v_AQPC845ANIO, 0);
    
    BEGIN
       SELECT RTRIM(INITCAP(TO_CHAR(pe_AQPC845FINIVIS, 'Month', 'NLS_DATE_LANGUAGE = SPANISH'))) INTO v_AQPC845MES FROM DUAL;  
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;            
    END;           
    v_AQPC845MES := TRIM(v_AQPC845MES);
    
    --realiza el calculo de calificacion
    BEGIN
    pq_cr_regis_visitas_riesg.SP_CALCULAR_CALIFICACION_AGENC(pe_agencia   => pe_AQPC845AGES,
                                                             fecIniVisit  => pe_AQPC845FINIVIS,
                                                             fecFinVisit  => pe_AQPC845FFINVIS,
                                                             calificacion => V_CALIFICACION);
    EXCEPTION
      WHEN OTHERS THEN        
        NULL;            
    END;     
     
     BEGIN
       INSERT INTO AQPC845(
       AQPC845cor, 
       AQPC845FREG, 
       AQPC845HREG,
       AQPC845USUREG,
       AQPC845AGES,
       AQPC845NOMS,
       AQPC845ZON,
       AQPC845NOMZ,
       AQPC845REG,
       AQPC845NOMR,
       AQPC845TIPVIST,
       AQPC845FINIVIS,
       AQPC845FFINVIS,
       AQPC845ANIO,
       AQPC845MES, 
       AQPC845USUVIST,
       AQPC845CALIACT
       ) VALUES(
       SP_GENRT_CORRELATIVO(),
       pe_AQPC845FREG    ,
       pe_AQPC845HREG    ,
       pe_AQPC845USUREG  ,
       pe_AQPC845AGES    ,
       pe_AQPC845NOMS    ,
       pe_AQPC845ZON     ,
       pe_AQPC845NOMZ    ,
       pe_AQPC845REG     ,
       pe_AQPC845NOMR    ,
       V_DESCRTIPOVISITA ,
       pe_AQPC845FINIVIS ,
       pe_AQPC845FFINVIS ,
       v_AQPC845ANIO    ,
       v_AQPC845MES     ,
       pe_AQPC845USUVIST,
       V_CALIFICACION );
       COMMIT;
     EXCEPTION
       WHEN OTHERS THEN
         ps_CODERROR:= 1001;
         PS_MsgError := 'Hubo un error al registrar los datos.';
     END;
     
     IF ps_CODERROR = 0 THEN
        PS_MsgError := 'Se registro correctamente.';
     END IF;
  END;    
  
  FUNCTION SP_GENRT_CORRELATIVO RETURN VARCHAR2 IS
   v_num NUMBER;
  BEGIN
    v_num := SQ_CR_AQPC845.NEXTVAL;
    RETURN 'V' || LPAD(v_num, 14, '0');
  END;       
  
  PROCEDURE SP_VAL_MINIM_REG_CONTRL(pe_agencia number,
                                    fecIniVisit date,
                                    fecFinVisit date,
                                    ps_CODERROR OUT NUMBER,
                                    PS_MsgError OUT VARCHAR2) IS 
  xCountRegisContr number;  
  xValGuiaMinPermi number;                                 
  BEGIN
     ps_CODERROR := 0; 
     PS_MsgError := '';
                  
     BEGIN
        SELECT COUNT(1) INTO xCountRegisContr FROM aqpb624 WHERE AQPB624AGES = pe_agencia AND AQPB624FSUP >= fecIniVisit AND AQPB624FSUP <= fecFinVisit AND AQPB624EST <> 'E';
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
     
     xCountRegisContr := nvl(xCountRegisContr, 0);
     
     BEGIN
        select tp1nro3 into xValGuiaMinPermi  FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11152 AND TP1CORR1 = 311 and tp1corr2 = 2 and tp1corr3 = 1;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
     xValGuiaMinPermi := nvl(xValGuiaMinPermi, 0);
     
     IF xCountRegisContr < xValGuiaMinPermi THEN
        ps_CODERROR := 1004;
        PS_MsgError := 'Se requiere un mínimo de ' || trim(to_char(xValGuiaMinPermi)) || ' créditos evaluados en el panel de control de riesgos dentro del rango de fechas ingresado.';
     ELSE
        ps_CODERROR := 0;   
     END IF;
     
     
  END;
  
  PROCEDURE SP_CALCULAR_CALIFICACION_AGENC(pe_agencia  number,
                                           fecIniVisit date,
                                           fecFinVisit date,
                                           calificacion OUT VARCHAR2) IS
  V_SUMPUNTAJE NUMBER(17,2);  
  V_CALIFGUIA  VARCHAR2(30);                                         
  BEGIN
     BEGIN
        SELECT sum(AQPB624AUX3) INTO V_SUMPUNTAJE FROM aqpb624 WHERE AQPB624AGES = pe_agencia AND AQPB624FSUP >= fecIniVisit AND AQPB624FSUP <= fecFinVisit AND AQPB624EST <> 'E';
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;  
     
     V_SUMPUNTAJE := NVL(V_SUMPUNTAJE, 0);  
     
     BEGIN
        select TP1DESC INTO V_CALIFGUIA FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11152 AND TP1CORR1 = 306 and tp1corr2 = 2 AND TP1CORR3 > 0 AND TP1IMP1 < V_SUMPUNTAJE AND TP1IMP2 >= V_SUMPUNTAJE ;      
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END; 
     
     V_CALIFGUIA := NVL(V_CALIFGUIA, '');   
     
     IF V_CALIFGUIA IS NOT NULL THEN
        calificacion := V_CALIFGUIA;
     END IF;    
  END;    
                                                                                                                          
end pq_cr_regis_visitas_riesg;
/
