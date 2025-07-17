create or replace package PQ_CR_TIPSBS_REPORTE25 is
    -- *****************************************************************
    -- Nombre                     : SP_tipSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/07/2025
    -- Autor de Creación          : MHUAMANIA
    -- Uso                        : devuelve el tipo SBS número
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************  
    
  FUNCTION fn_cr_reporte25_rubro(VARSUC IN NUMBER,
                                 VARMDA IN NUMBER,
                                 VARPAP IN NUMBER,
                                 VARCTA IN NUMBER,
                                 VAROPE IN NUMBER,
                                 VARSUB IN NUMBER,
                                 VARMOD IN NUMBER,
                                 VARTOP IN NUMBER) RETURN NUMBER;

  /*FUNCTION fn_cr_reporte25_desc(VARSUC IN NUMBER,
                                VARMDA IN NUMBER,
                                VARPAP IN NUMBER,
                                VARCTA IN NUMBER,
                                VAROPE IN NUMBER,
                                VARSUB IN NUMBER,
                                VARMOD IN NUMBER,
                                VARTOP IN NUMBER) RETURN VARCHAR2;*/
end PQ_CR_TIPSBS_REPORTE25;
/
create or replace package body PQ_CR_TIPSBS_REPORTE25 is

  FUNCTION fn_cr_reporte25_rubro(VARSUC IN NUMBER,
                                 VARMDA IN NUMBER,
                                 VARPAP IN NUMBER,
                                 VARCTA IN NUMBER,
                                 VAROPE IN NUMBER,
                                 VARSUB IN NUMBER,
                                 VARMOD IN NUMBER,
                                 VARTOP IN NUMBER) RETURN NUMBER IS
  
    -- *****************************************************************
    -- Nombre                     : SP_tipSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/07/2025
    -- Autor de Creación          : MHUAMANIA
    -- Uso                        : devuelve el tipo SBS número
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    --tip_sbs    VARCHAR2(40);
    p_gpo   number(2);
    P_N_GPO VARCHAR2(2);
    --ld_fecrcc  date;
    --lc_ndoc    varchar2(12);
    --lc_codsbs  varchar2(15);
    --cod_tipsbs varchar2(2);
  BEGIN
    --DEVUELVE CODIGO SBS SI NO HAY EXCEPCIONES
    begin
      -- DEVUELVE DIGITOS DE PLAN DE CUENTAS
      
      SELECT SUBSTR(f.hrubro, 5, 2)
        INTO P_N_GPO
        FROM JAQL175 j
       INNER JOIN FSH016 f
          ON f.PGCOD = j.JAQL175EMP
         AND f.HCMOD = j.JAQL175ITM
         AND f.HSUCOR = j.JAQL175ITS
         AND f.HCTA = j.JAQL175CTA
         AND f.HOPER = j.JAQL175OPE
         AND f.HTRAN = j.JAQL175ITT
         AND f.HSUCUR = j.JAQL175SUC
         AND f.HSUBOP = j.JAQL175SBO
         AND f.HNREL = j.JAQL175ITR
         AND f.hfcon = J.JAQL175FCA
         AND f.HCORD = 10
       INNER JOIN FSH015 c
          ON c.PGCOD = f.PGCOD
         AND c.HCMOD = f.HCMOD
         AND c.HSUCOR = f.HSUCOR
         AND c.HTRAN = f.HTRAN
         AND c.HNREL = f.HNREL
         AND c.HFCON = f.HFCON
       WHERE j.JAQL175ITC = 'S'
         AND j.JAQL175EMP = 1
         AND j.JAQL175CTA = VARCTA
         AND j.JAQL175OPE = VAROPE;
         
      p_gpo := to_number(P_N_GPO);

    exception
      when others then
        p_gpo := 00;
    end;
    return p_gpo;
  
  EXCEPTION
    WHEN OTHERS THEN
      p_gpo := 00;
  end fn_cr_reporte25_rubro;

  /*FUNCTION fn_cr_reporte25_desc(VARSUC IN NUMBER,
                                VARMDA IN NUMBER,
                                VARPAP IN NUMBER,
                                VARCTA IN NUMBER,
                                VAROPE IN NUMBER,
                                VARSUB IN NUMBER,
                                VARMOD IN NUMBER,
                                VARTOP IN NUMBER) RETURN varchar2 IS
  
    -- *****************************************************************
    -- Nombre                     : SP_tipSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/07/2025
    -- Autor de Creación          : 
    -- Uso                        : devuelve el tipo SBS descripción texto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
    tip_sbs2 varchar2(20);
    tip_sbs  VARchar2(30);
    p_gpo    number;
    P_N_GPO  VARCHAR2(2);
  
  BEGIN
    begin
      -- DEVUELVE DIGITOS DE PLAN DE CUENTAS
      SELECT SUBSTR(f.hrubro, 5, 2)
        INTO P_N_GPO
        FROM JAQL175 j
       INNER JOIN FSH016 f
          ON f.PGCOD = j.JAQL175EMP
         AND f.HCMOD = j.JAQL175ITM
         AND f.HSUCOR = j.JAQL175ITS
         AND f.HCTA = j.JAQL175CTA
         AND f.HOPER = j.JAQL175OPE
         AND f.HTRAN = j.JAQL175ITT
         AND f.HSUCUR = j.JAQL175SUC
         AND f.HNREL = j.JAQL175ITR
         AND f.HCORD = 10
       INNER JOIN FSH015 c
          ON c.PGCOD = f.PGCOD
         AND c.HCMOD = f.HCMOD
         AND c.HSUCOR = f.HSUCOR
         AND c.HTRAN = f.HTRAN
         AND c.HNREL = f.HNREL
         AND c.HFCON = f.HFCON
       WHERE j.JAQL175ITC = 'S'
         AND j.JAQL175EMP = 1
         AND j.JAQL175CTA = VARCTA
         AND j.JAQL175OPE = VAROPE;
      -- CAMBIAR A NUMÉRICO LOS DIGITOS DE PLAN
      p_gpo := to_number(P_N_GPO);
    
      BEGIN
        -- GUÍA PARA CÓDIGOS DE RUBROS
        select TP1DESC
          into tip_sbs
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11181
           and TP1CORR1 = 10
           and TP1CORR2 = 1
           and tp1nro1 = p_gpo;
        tip_sbs2 := TRIM(tip_sbs);
      EXCEPTION
        WHEN OTHERS THEN
          select TP1DESC
            into tip_sbs
            from fst198
           where tp1cod = 1
             and tp1cod1 = 11181
             and TP1CORR1 = 10
             and TP1CORR2 = 1
             and TP1CORR3 = 99;
          tip_sbs2 := TRIM(tip_sbs);
      END;
    exception
      when others then
        select TP1DESC
          into tip_sbs
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11181
           and TP1CORR1 = 10
           and TP1CORR2 = 1
           and TP1CORR3 = 98;
        tip_sbs2 := TRIM(tip_sbs);
    end;
    return tip_sbs2;
  
  EXCEPTION
    WHEN OTHERS THEN
      tip_sbs2 := 0;
  end fn_cr_reporte25_desc;
  */
end PQ_CR_TIPSBS_REPORTE25;
/
