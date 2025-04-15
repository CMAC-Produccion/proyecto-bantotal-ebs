create or replace package PQ_CR_CTROL_OPI_RIE_REPROG_REFIN is

  -- *****************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 3/04/2025 
  -- Autor de Creación          : RCASTRO
  -- Uso                        : Propuesta INFORME PROPUESTA DE OPINIÓN DE RIESGOS EN REPROGRAMADOS Y REFINANCIADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 

  -- *****************************************************************  

  procedure SP_CNTROL_REPROG(V_INSTANCIA     in number,
                             V_USUARIO       in varchar2,
                             V_FLAG          out varchar2,
                             V_CODIGO_ERROR  out varchar2,
                             V_MENSAJE_ERROR out varchar2);

end PQ_CR_CTROL_OPI_RIE_REPROG_REFIN;
/
create or replace package body PQ_CR_CTROL_OPI_RIE_REPROG_REFIN is

  procedure SP_CNTROL_REPROG(V_INSTANCIA     in number,
                             V_USUARIO       in varchar2,
                             V_FLAG          out varchar2,
                             V_CODIGO_ERROR  out varchar2,
                             V_MENSAJE_ERROR out varchar2) IS
    V_CUENTA NUMBER(10);
    V_PEPAIS NUMBER(4);
    V_PETDOC NUMBER(4);
    V_PENDOC VARCHAR2(12);
  
    SEGMENTO         VARCHAR2(10);
    TABLA            VARCHAR2(15);
    NIVEL_RIESGO     VARCHAR2(100);
    V_SCORE_ACTU     VARCHAR2(30);
    PROGRAMA         VARCHAR2(10);
    PROBALIDAD       NUMBER(8, 7);
    PDCAL            NUMBER(8, 7);
    EDAD_CLIENTE     NUMBER(3);
    CANTIDAD_LNG     NUMBER(2);
    NRO_ENTIDADES    NUMBER(10);
    FECHA_SCORE      DATE;
    lc_user          VARCHAR2(10);
    V_SALD_CAPITAL   NUMBER(17, 2);
    V_ANTIGUEDAD     NUMBER(10, 2);
    V_MONTSUP        NUMBER(17, 2);
    V_ANTIG_GUIA     NUMBER(10, 2);
    V_MNTGUIA_ANTIG  NUMBER(17, 2);
    PV_SCORE_CLIENTE varchar2(20);
  
  BEGIN
    V_CODIGO_ERROR := '0000';
    V_FLAG         := 'N';
  
    BEGIN
      SELECT W.XWFCUENTA, W.XWFMONTO1
        INTO V_CUENTA, V_SALD_CAPITAL
        FROM XWF700 W
       WHERE W.XWFPRCINS = V_INSTANCIA
         AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        V_CUENTA := 0;
    END;
    V_CUENTA := NVL(V_CUENTA, 0);
  
    BEGIN
      SELECT PEPAIS, PETDOC, PENDOC
        INTO V_PEPAIS, V_PETDOC, V_PENDOC
        FROM FSR008
       WHERE CTNRO = V_CUENTA
         AND CTTFIR = 'T';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    V_PENDOC := TRIM(V_PENDOC);
  
    --VALIDAR SCORE 
    PROGRAMA         := '';
    SEGMENTO         := NULL;
    TABLA            := NULL;
    NIVEL_RIESGO     := NULL;
    V_SCORE_ACTU     := NULL;
    PROBALIDAD       := 0;
    PDCAL            := 0;
    FECHA_SCORE      := NULL;
    PV_SCORE_CLIENTE := NULL;
    lc_user          := '';
  
    BEGIN
      PQ_CR_SCORE_RCC.SP_CR_SCOREDNI_II(LN_INST       => 0,
                                        LN_TDOC       => V_PETDOC,
                                        LC_NDOC       => V_PENDOC,
                                        LC_PRGM       => PROGRAMA,
                                        LC_USER       => lc_user,
                                        LC_SCORE      => NIVEL_RIESGO,
                                        LN_PROBAL     => PROBALIDAD,
                                        LC_SEGMRIESGO => SEGMENTO,
                                        LN_PDCAL      => PDCAL,
                                        LC_TABLA      => TABLA,
                                        LD_FCHSCORE   => FECHA_SCORE,
                                        LC_SCOREABR   => PV_SCORE_CLIENTE,
                                        LC_NEWSCORE   => V_SCORE_ACTU);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    V_SCORE_ACTU := trim(V_SCORE_ACTU);
  
    BEGIN
      SELECT TP1IMP1
        INTO V_MONTSUP
        FROM FST198 W
       WHERE W.TP1COD = 1
         AND W.TP1COD1 = 11152
         AND W.TP1CORR1 = 240
         AND W.TP1CORR2 = 1
         AND W.TP1CORR3 > 0
         AND W.TP1DESC = RPAD(V_SCORE_ACTU, 30, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    V_MONTSUP := NVL(V_MONTSUP, 0);
  
    IF V_SALD_CAPITAL > V_MONTSUP AND
       (V_SCORE_ACTU <> 'SIN SCORE' AND V_SCORE_ACTU <> ' ') THEN
      V_CODIGO_ERROR  := '2001';
      V_MENSAJE_ERROR := 'Cliente con score ' || V_SCORE_ACTU ||
                         ', monto mayor a S/. ' || to_char(V_MONTSUP) || ' soles.';
      V_FLAG          := 'S';
    ELSE
      --VALIDAR ANTIGUEDAD
      BEGIN
        PQ_CR_SEGMENTACION_PYME_NUEVO.sp_cr_antiguedad_pyme(pn_pgpais => V_PEPAIS,
                                                            pn_tipdoc => V_PETDOC,
                                                            pv_numdoc => V_PENDOC,
                                                            pn_result => V_ANTIGUEDAD);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
      
        SELECT TP1IMP3, TP1IMP1
          INTO V_ANTIG_GUIA, V_MNTGUIA_ANTIG
          FROM FST198 W
         WHERE W.TP1COD = 1
           AND W.TP1COD1 = 11152
           AND W.TP1CORR1 = 240
           AND W.TP1CORR2 = 1
           AND W.TP1CORR3 = 5;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      IF V_ANTIGUEDAD < V_ANTIG_GUIA AND V_SALD_CAPITAL > V_MNTGUIA_ANTIG THEN
        V_CODIGO_ERROR  := '2002';
        V_MENSAJE_ERROR := 'Cliente con menos de ' ||
                           to_char(V_ANTIG_GUIA) || ' años en el SF y monto mayor a S/. ' || to_char(V_MNTGUIA_ANTIG) || ' soles.';
        V_FLAG          := 'S';
      END IF;
    
    END IF;
  END;

end PQ_CR_CTROL_OPI_RIE_REPROG_REFIN;
/
