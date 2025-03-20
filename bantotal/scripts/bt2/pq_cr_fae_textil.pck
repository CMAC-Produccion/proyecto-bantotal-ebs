create or replace package PQ_CR_FAE_TEXTIL is

  -- Author  : MCORDOVA
  -- Created : 14/11/2022 19:05:21
  -- Purpose : Devolver variables para controles FAE TEXTIL

  Procedure SP_CR_VAL_AQPB456(PN_INSTANCIA  IN NUMBER,
                              PN_MONTO      OUT NUMBER,
                              PV_VALMONTO   OUT VARCHAR2,
                              PN_PLAZO      OUT NUMBER,
                              PV_VALPLAZO   OUT VARCHAR2,
                              PN_GRACIAMN   OUT NUMBER,
                              PN_GRACIAMX   OUT NUMBER,
                              PV_VALGRACIA  OUT VARCHAR2,
                              PN_FPPAGO     OUT NUMBER,
                              PV_VALFPPAGO  OUT VARCHAR2,
                              PD_FMAXDES    OUT DATE,
                              PV_VALFMAXDES OUT VARCHAR2,
                              PN_MODULO     OUT NUMBER);

  Procedure SP_CR_CRED_DESEM(PN_PAIS       IN NUMBER,
                             PN_TIPO       IN NUMBER,
                             PV_DOCUMENTO  IN VARCHAR2,
                             PV_DESEMBOLSO OUT VARCHAR2);

  Procedure SP_CR_VERIFICAR_CIIU(PN_PAIS      IN NUMBER,
                                 PN_TIPO      IN NUMBER,
                                 PV_DOCUMENTO IN VARCHAR2,
                                 PV_CIIU      OUT VARCHAR2);

  PROCEDURE SP_CR_FAE_T_ENVUELO(PN_INSTANCIA IN NUMBER,
                                PN_RESPUESTA OUT VARCHAR2);

  FUNCTION FN_FERIADOS_CON_TOLERANCIA(PN_SUCURSAL IN NUMBER,
                                      PD_FECHA    IN DATE) RETURN NUMBER;

  PROCEDURE SP_UPD_FAE_DESEMB(ve_Pgcod  in number,
                              ve_Itsuc  in number,
                              ve_Itmod  in number,
                              ve_Ittran in number,
                              ve_Itnrel in number,
                              --&Pgcod   
                              ve_Itsucd   in number,
                              ve_Modulo   in number,
                              ve_Ctnro    in number,
                              ve_Moneda   in number,
                              ve_Papel    in number,
                              ve_Ittope   in number,
                              ve_Itoper   in number,
                              ve_Itsubo   in number,
                              ve_Ubuser   in varchar,
                              ve_fecha    in date,
                              ve_hora     in varchar,
                              vs_coderr   out number,
                              ve_MsgError out varchar);
   
  Procedure SP_CR_VERPAEMYPE_CIIU(PN_PAIS      IN NUMBER,
                                 PN_TIPO      IN NUMBER,
                                 PV_DOCUMENTO IN VARCHAR2,
                                 PV_CIIU      OUT VARCHAR2);

end PQ_CR_FAE_TEXTIL;
/

create or replace package body PQ_CR_FAE_TEXTIL is

  Procedure SP_CR_VAL_AQPB456(PN_INSTANCIA  IN NUMBER,
                              PN_MONTO      OUT NUMBER,
                              PV_VALMONTO   OUT VARCHAR2,
                              PN_PLAZO      OUT NUMBER,
                              PV_VALPLAZO   OUT VARCHAR2,
                              PN_GRACIAMN   OUT NUMBER,
                              PN_GRACIAMX   OUT NUMBER,
                              PV_VALGRACIA  OUT VARCHAR2,
                              PN_FPPAGO     OUT NUMBER,
                              PV_VALFPPAGO  OUT VARCHAR2,
                              PD_FMAXDES    OUT DATE,
                              PV_VALFMAXDES OUT VARCHAR2,
                              PN_MODULO     OUT NUMBER) IS
  
    /*LN_PAIS      NUMBER;
    LN_TIPO      NUMBER;
    LV_DOCUMENTO VARCHAR2(12);*/ --GCARRANZAS  03.06.2021
  
    LN_pgcod NUMBER;
    LN_mod   NUMBER;
    LN_suc   NUMBER;
    LN_mda   NUMBER;
    LN_pap   NUMBER;
    LN_cta   NUMBER;
    LN_oper  NUMBER;
    LN_sbop  NUMBER;
    LN_tope  NUMBER;
  
    LN_PLAZO    NUMBER;
    LD_FPPAGO   DATE;
    LD_FDESEM   DATE;
    LD_FFINCRED DATE;
  
    LN_FPPAGO NUMBER; --PLAZO PRIMER FECHA PAGO GUIA
  
    LN_FERIADOS NUMBER;
  
    LD_FMAXDES DATE;
  
    --LN_GRACIA      NUMBER;
    LN_FRECUENCIAT NUMBER;
  
    --LD_FECHALIMITE DATE;
    LD_FECHAMAXAQP456 DATE;
    
    lc_coderr varchar2(100);
    lc_msgerr varchar2(100); -- 
    
    PN_PLAZO_MN NUMBER(5);
    PN_PLAZO_MX NUMBER(5);
  BEGIN
  
    PV_VALMONTO   := 'N';
    PV_VALPLAZO   := 'N';
    PV_VALGRACIA  := 'N';
    PV_VALFPPAGO  := 'N';
    PV_VALFMAXDES := 'N';
  
    BEGIN
      SELECT X.XWFEMPRESA,
             X.XWFMODULO,
             X.XWFSUCURSAL,
             X.XWFMONEDA,
             X.XWFPAPEL,
             X.XWFCUENTA,
             X.XWFOPERACION,
             X.XWFSUBOPE,
             X.XWFTIPOPE,
             X.XWFPLAZO1
        INTO LN_pgcod,
             LN_mod,
             LN_suc,
             LN_mda,
             LN_pap,
             LN_cta,
             LN_oper,
             LN_sbop,
             LN_tope,
             PN_PLAZO
        FROM XWF700 X
       WHERE X.XWFPRCINS = PN_INSTANCIA
         AND X.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        LN_pgcod := 0;
        LN_mod   := 0;
        LN_suc   := 0;
        LN_mda   := 0;
        LN_pap   := 0;
        LN_cta   := 0;
        LN_oper  := 0;
        LN_sbop  := 0;
        LN_tope  := 0;
        RETURN;
    END;
  
    --GCARRANZAS  03.06.2021
    BEGIN
      SELECT MAX(A.AQPC274FCAR) INTO LD_FECHAMAXAQP456 FROM AQPC274 A WHERE A.AQPC274CDAP = 1 AND A.AQPC274VGNT =  1;
    EXCEPTION
      WHEN OTHERS THEN
        LD_FECHAMAXAQP456 := NULL;
    END;
    --GCARRANZAS  03.06.2021
  
    --GCARRANZAS  03.06.2021
    IF (LD_FECHAMAXAQP456 IS NOT NULL) THEN
      BEGIN
        SELECT A.AQPC274MNTP,
               A.AQPC274PZMN,
               A.AQPC274PZMX, -- MILTON CORDOVA 19-09-2022
               A.AQPC274PGMN,
               A.AQPC274PGMX,
               A.AQPC274FVIG,
               A.AQPC274FREC,
               A.AQPC274MOD
          INTO PN_MONTO, PN_PLAZO_MN, PN_PLAZO_MX, PN_GRACIAMN, PN_GRACIAMX, LD_FMAXDES, LN_FRECUENCIAT, PN_MODULO
          FROM AQPC274 A
         WHERE
        A.AQPC274CTCL = LN_cta AND
        A.AQPC274FCAR = LD_FECHAMAXAQP456
         AND (A.AQPC274EST <> 'D' OR A.AQPC274EST IS NULL) AND A.AQPC274CDAP = 1 AND A.AQPC274VGNT =  1; -- NO DESEMBOLSADO
      EXCEPTION
        WHEN OTHERS THEN
          PV_VALMONTO   := 'N';
          PV_VALPLAZO   := 'N';
          PV_VALGRACIA  := 'N';
          PV_VALFPPAGO  := 'N';
          PV_VALFMAXDES := 'N';
          lc_coderr := sqlcode;
          lc_msgerr := sqlerrm;
          RETURN;
      END;
    ELSE
      RETURN;
    END IF;
    --GCARRANZAS  03.06.2021
  
    --OBTENER PLAZO PRIMER FECHA DE PAGO
    BEGIN
      SELECT F.TP1NRO1
        INTO PN_FPPAGO
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 6
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PN_FPPAGO := 577;
    END;
  
    --COMPARAR MONTOS
    BEGIN
      SELECT CASE
               WHEN X.XLLCAPITAL = PN_MONTO THEN
                'S'
               ELSE
                'N'
             END MONTO
        INTO PV_VALMONTO
        FROM x054023 x
       WHERE X.XLLPGCOD = LN_pgcod
         AND X.XLLAOMOD = LN_mod
         AND X.XLLAOSUC = LN_suc
         AND X.XLLAOMDA = LN_mda
         AND X.XLLAOPAP = LN_pap
         AND X.XLLAOCTA = LN_cta
         AND X.XLLAOOPER = LN_oper
         AND X.XLLAOSBOP = LN_sbop
         AND X.XLLAOTOP = LN_tope;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          SELECT CASE
                   WHEN X.XWFMONTO1 = PN_MONTO THEN
                    'S'
                   ELSE
                    'N'
                 END MONTO
            INTO PV_VALMONTO
            FROM XWF700 X
           WHERE X.XWFPRCINS = PN_INSTANCIA
             AND X.XWFCAR3 = '1';
        EXCEPTION
          WHEN OTHERS THEN
            PV_VALMONTO := 'N';
        END;
    END;
  
    --PRIMERA FECHA DE PAGO ,FECHA DESEMBOLSO, GRACIA Y PLAZO
    BEGIN
      SELECT MIN(F.PPFPAG),
             MIN(F.PPFVAL),
             MIN(F.PPFPAG) - MIN(F.PPFVAL),
             SUM(F.PPPZO)
        INTO LD_FPPAGO, LD_FDESEM, LN_FPPAGO, LN_PLAZO
        FROM FSD601 F
       WHERE F.PGCOD = LN_pgcod
         AND F.PPMOD = LN_mod
         AND F.PPSUC = LN_suc
         AND F.PPMDA = LN_mda
         AND F.PPPAP = LN_pap
         AND F.PPCTA = LN_cta
         AND F.PPOPER = LN_oper
         AND F.PPSBOP = LN_sbop
         AND F.PPTOPE = LN_tope
         AND F.D601CO IN ('X', 'S');
    EXCEPTION
      WHEN OTHERS THEN
        PV_VALPLAZO  := 'N';
        PV_VALGRACIA := 'N';
        PV_VALFPPAGO := 'N';
    END;
  
    IF LD_FPPAGO IS NULL AND LD_FDESEM IS NULL AND LN_FPPAGO IS NULL THEN
      BEGIN
        SELECT X.XLLFPRIMPA, X.XLLFVALOR, X.XLLFPRIMPA - X.XLLFVALOR
          INTO LD_FPPAGO, LD_FDESEM, LN_FPPAGO
          FROM x054023 x
         WHERE X.XLLPGCOD = LN_pgcod
           AND X.XLLAOMOD = LN_mod
           AND X.XLLAOSUC = LN_suc
           AND X.XLLAOMDA = LN_mda
           AND X.XLLAOPAP = LN_pap
           AND X.XLLAOCTA = LN_cta
           AND X.XLLAOOPER = LN_oper
           AND X.XLLAOSBOP = LN_sbop
           AND X.XLLAOTOP = LN_tope;
      EXCEPTION
        WHEN OTHERS THEN
          PV_VALPLAZO  := 'N';
          PV_VALGRACIA := 'N';
          PV_VALFPPAGO := 'N';
      END;
    END IF;
  
    IF LN_PLAZO IS NULL THEN
      --PLAZO CREDITO ACTUAL
      BEGIN
        SELECT X.XLLOAOPZO
          INTO LN_PLAZO
          FROM X054007 X
         WHERE X.PGCOD = LN_pgcod
           AND X.XLLOAOMOD = LN_mod
           AND X.XLLOAOSUC = LN_suc
           AND X.XLLOAOMDA = LN_mda
           AND X.XLLOAOPAP = LN_pap
           AND X.XLLOAOCTA = LN_cta
           AND X.XLLOAOOPER = LN_oper
           AND X.XLLOAOSBOP = LN_sbop
           AND X.XLLOAOTOPE = LN_tope;
      EXCEPTION
        WHEN OTHERS THEN
          LN_PLAZO := 0;
       END;
    END IF;
  
    --VALIDAR PLAZO
    --ENCONTRAR FECHA FIN PARA VERIFICAR FERIADOS
    SELECT LD_FDESEM + LN_PLAZO INTO LD_FFINCRED FROM DUAL;
  
    LN_FERIADOS := FN_FERIADOS_CON_TOLERANCIA(LN_suc, LD_FFINCRED);
  
    IF LN_FERIADOS > 0 THEN
      PV_VALPLAZO := 'N'; -- NO PUEDE SER FERIADO
    ELSE
      --EN CASO NO SER FERIADO VERIFICO SI HA RETROCEDIDO UN DIA POR TOLERANCIA Y FERIADO
      LN_FERIADOS := FN_FERIADOS_CON_TOLERANCIA(LN_suc, LD_FFINCRED + 1);
      --VALIDAR DIAS 
      IF LN_PLAZO = PN_PLAZO OR (LN_PLAZO >= (PN_PLAZO - LN_FERIADOS) AND LN_PLAZO <= PN_PLAZO) THEN
        IF PN_PLAZO >= PN_PLAZO_MN AND PN_PLAZO <= PN_PLAZO_MX then -- MILTON CORDOVA HERRERA 19-11-2022
           PV_VALPLAZO := 'S';
        ELSE
           PV_VALPLAZO := 'N';
        END IF;
      ELSE
        PV_VALPLAZO := 'N';
      END IF;
    END IF;
  
    --VERIFICAR GRACIA
    --VERIFICAR PRIMER PAGO SI ES FERIADO
    LN_FERIADOS := FN_FERIADOS_CON_TOLERANCIA(LN_suc, LD_FPPAGO);
  
    IF LN_FERIADOS > 0 THEN
      PV_VALFPPAGO := 'N'; -- NO PUEDE SER FERIADO
    ELSE
      --EN CASO NO SER FERIADO VERIFICO SI HA RETROCEDIDO UN DIA POR FERIADO
      LN_FERIADOS := FN_FERIADOS_CON_TOLERANCIA(LN_suc, LD_FPPAGO + 1);
      --VALIDAR DIAS 
      IF LN_FPPAGO = PN_FPPAGO OR
         (LN_FPPAGO >= (PN_FPPAGO - LN_FERIADOS) AND LN_FPPAGO <= PN_FPPAGO) THEN
        PV_VALFPPAGO := 'S';
      ELSE
        PV_VALFPPAGO := 'N';
      END IF;
    END IF;
  
    --VERIFICAR FECHA LIMITE
    --OBTENER FECHA LIMITE -GUIA
    BEGIN
      SELECT TO_DATE(F.TP1DESC, 'DD/MM/YYYY')
        INTO PD_FMAXDES
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 1
         AND F.TP1CORR3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        PD_FMAXDES := TO_DATE('31/12/2022', 'DD/MM/YYYY');
    END;
  
    IF LD_FDESEM <= PD_FMAXDES AND LD_FDESEM <= LD_FMAXDES THEN
      PV_VALFMAXDES := 'S';
    ELSE
      PV_VALFMAXDES := 'N';
    END IF;
  
  END SP_CR_VAL_AQPB456;

  Procedure SP_CR_CRED_DESEM(PN_PAIS       IN NUMBER,
                             PN_TIPO       IN NUMBER,
                             PV_DOCUMENTO  IN VARCHAR2,
                             PV_DESEMBOLSO OUT VARCHAR2) IS
  
    LN_CANT          number(3);
    LN_MODULO        NUMBER;
    LN_TIPOOPERACION NUMBER;
    --- VALIDAR SI TIENE CREDITOS DESEMBOLSADOS O EN PROCESO  
  begin
  
    PV_DESEMBOLSO := 'N';
    /*
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_MODULO
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 2
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1  = ve_Modulo
    EXCEPTION
      WHEN OTHERS THEN
        LN_MODULO := 101;
    END;
  
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_TIPOOPERACION
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 3
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1 = vi_tipope   
    EXCEPTION
      WHEN OTHERS THEN
        LN_TIPOOPERACION := 359;
    END;
    */
    ----GCARRANZAS  03.06.2021
    BEGIN
      SELECT COUNT(*)
        INTO LN_CANT
        FROM FSD010 F
       WHERE F.AOSTAT <> 99
         AND F.AOMOD in (SELECT F.TP1NRO1
                           FROM FST198 F
                          WHERE F.TP1COD = 1
                            AND F.TP1COD1 = 11153
                            AND F.TP1CORR1 = 11
                            AND F.TP1CORR2 = 2
                            AND F.TP1CORR3 > 0)
         AND F.AOTOPE in (
                          SELECT F.TP1NRO1
                            FROM FST198 F
                           WHERE F.TP1COD = 1
                             AND F.TP1COD1 = 11153
                             AND F.TP1CORR1 = 11
                             AND F.TP1CORR2 = 3
                             AND F.TP1CORR3 > 0)
         AND F.AOCTA IN (SELECT F.CTNRO
                           FROM FSR001 S, FSR008 F
                          WHERE F.PEPAIS = S.DOCPAIS
                            AND F.PETDOC = S.DOCTDOC
                            AND F.PENDOC = S.DOCNDOC
                            AND S.DOCPAIS1 = PN_PAIS
                            AND S.DOCNDOC1 = RPAD(PV_DOCUMENTO,12,' ') -- mpostigoc 27.12.2021
                            AND F.PGCOD = 1
                            AND F.CTTFIR = 'T'
                            AND F.TTCOD = 1
                         UNION
                         SELECT F.CTNRO
                           FROM FSR008 F
                          WHERE F.PEPAIS = PN_PAIS
                            AND F.PETDOC = PN_TIPO
                            AND F.PENDOC = RPAD(PV_DOCUMENTO,12,' ')  -- mpostigoc 27.12.2021
                            AND F.PGCOD = 1
                            AND F.CTTFIR = 'T'
                            AND F.TTCOD = 1);
    EXCEPTION
      WHEN OTHERS THEN
        LN_CANT := 0;
    END;
  
    IF (LN_CANT > 0) THEN
      PV_DESEMBOLSO := 'S';
    END IF;
  
    --GCARRANZAS  03.06.2021
 
  END SP_CR_CRED_DESEM;

  Procedure SP_CR_VERIFICAR_CIIU(PN_PAIS      IN NUMBER,
                                 PN_TIPO      IN NUMBER,
                                 PV_DOCUMENTO IN VARCHAR2,
                                 PV_CIIU      OUT VARCHAR2) IS
  
    lv_petipo varchar2(1);
  
  BEGIN
    lv_petipo := pq_client_ciiu.fn_petipo(PN_PAIS, PN_TIPO, PV_DOCUMENTO);
  
    If lv_petipo = 'F' Then
    
      BEGIN
        SELECT 'S'
          INTO PV_CIIU
          FROM SNGC60 S
         WHERE S.SNGC60PAIS = PN_PAIS
           AND S.SNGC60TDOC = PN_TIPO
           AND S.SNGC60NDOC = CAST(PV_DOCUMENTO AS CHARACTER(12))
           AND EXISTS (SELECT *
                  FROM FST198 F
                 WHERE F.TP1COD = 1
                   AND F.TP1COD1 = 11153
                   AND F.TP1CORR1 = 11
                   AND F.TP1CORR2 = 5
                   AND F.TP1CORR3 > 0
                   AND F.TP1IMP1 = S.SNGC60ACTE)
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          PV_CIIU := 'N';
      END;
    
    end if;
  
    ----=============
    If lv_petipo = 'J' Then
      Begin
        SELECT 'S'
          INTO PV_CIIU
          From fse001 e001
         Where e001.d511pais = PN_PAIS
           And e001.d511tdoc = PN_TIPO
           And e001.d511ndoc = CAST(PV_DOCUMENTO AS CHARACTER(12))
           AND EXISTS (SELECT 'x'
                  FROM FST198 F
                 WHERE F.TP1COD = 1
                   AND F.TP1COD1 = 11153
                   AND F.TP1CORR1 = 11
                   AND F.TP1CORR2 = 5
                   AND F.TP1CORR3 > 0
                   AND F.TP1IMP1 = e001.expnins);
      Exception
        when others then
          PV_CIIU := 'N';
      End;
    End If;
    
  
  END SP_CR_VERIFICAR_CIIU;

  PROCEDURE SP_CR_FAE_T_ENVUELO(PN_INSTANCIA IN NUMBER,
                                PN_RESPUESTA OUT VARCHAR2) is
    -- Devuelve cantidad de solicitudes en vuelo de FAE TURISMO 
    LN_CANT          number(3);
    LN_MODULO        NUMBER;
    LN_TIPOOPERACION NUMBER;
    vi_modulo        XWF700.XWFMODULO%TYPE;
    vi_tipope        XWF700.XWFTIPOPE%TYPE;
    --- VALIDAR SI TIENE CREDITOS DESEMBOLSADOS O EN PROCESO  
  begin
  
    PN_RESPUESTA := 'N';
    BEGIN
      SELECT x.xwfmodulo,x.xwftipope
      INTO vi_modulo,vi_tipope
      FROM XWF700 x
      WHERE XWFPRCINS = PN_INSTANCIA
        AND XWFCAR3='1';
    EXCEPTION
      WHEN OTHERS THEN
           vi_modulo := 0;
           vi_tipope := 0;
    END;
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_MODULO
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 2
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1  = vi_modulo;
    EXCEPTION
      WHEN OTHERS THEN
        LN_MODULO := 101;
    END;
  
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_TIPOOPERACION
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 3
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1 = vi_tipope;        
    EXCEPTION
      WHEN OTHERS THEN
        LN_TIPOOPERACION := 359;
    END;
  
    begin
      select count(*)
        into LN_CANT
        from wfwrkitems w, xwf700 x
       where w.wfinsprcid = x.xwfprcins
         and x.xwfmodulo = LN_MODULO
         and x.xwftipope in LN_TIPOOPERACION
         and x.xwfempresa = 1
         and x.xwfcar3 = '1'
         and w.wfitemstsact = 1
         and x.xwfcuenta in
             (select h.ctnro
                from sng001 s, fsr008 h
               where s.sng001pais = h.pepais
                 and s.sng001tdoc = h.petdoc
                 and s.sng001ndoc = h.pendoc
                 and s.sng001inst = PN_INSTANCIA)
         and w.wfinsprcid <> PN_INSTANCIA;
    exception
      when others then
        LN_CANT := 0;
    end;
  
    if LN_CANT > 0 then
      PN_RESPUESTA := 'S';
    end if;
  
  exception
    when others then
      PN_RESPUESTA := 'N';
  end SP_CR_FAE_T_ENVUELO;

  FUNCTION FN_FERIADOS_CON_TOLERANCIA(PN_SUCURSAL IN NUMBER,
                                      PD_FECHA    IN DATE) RETURN NUMBER IS
    LV_FERIADO  VARCHAR2(2);
    LN_FERIADOS NUMBER;
  
    LD_FECHA DATE;
  BEGIN
  
    LD_FECHA    := PD_FECHA;
    LN_FERIADOS := 0;
  
    LOOP
      BEGIN
        SELECT 'S'
          INTO LV_FERIADO
          FROM FST001 F, FST028 S
         WHERE F.CALCOD = S.CALCOD
           AND F.SUCURS = PN_SUCURSAL
           AND S.FFECHA = LD_FECHA
           AND S.FHABIL = 'N';
      EXCEPTION
        WHEN OTHERS THEN
          LV_FERIADO := 'N';
      END;
      EXIT WHEN LV_FERIADO = 'N';
    
      LD_FECHA    := LD_FECHA + 1; --GCS-SE SUMAN HACIA ADELANTE- VER DIAS POSTERIORES SON FERIADOS
      LN_FERIADOS := LN_FERIADOS + 1;
    
    END LOOP;
    RETURN LN_FERIADOS;
  END FN_FERIADOS_CON_TOLERANCIA;
  PROCEDURE SP_UPD_FAE_DESEMB(ve_Pgcod  in number,
                              ve_Itsuc  in number,
                              ve_Itmod  in number,
                              ve_Ittran in number,
                              ve_Itnrel in number,
                              --&Pgcod   
                              ve_Itsucd   in number,
                              ve_Modulo   in number,
                              ve_Ctnro    in number,
                              ve_Moneda   in number,
                              ve_Papel    in number,
                              ve_Ittope   in number,
                              ve_Itoper   in number,
                              ve_Itsubo   in number,
                              ve_Ubuser   in varchar,
                              ve_fecha    in date,
                              ve_hora     in varchar,
                              vs_coderr   out number,
                              ve_MsgError out varchar) IS
  
    vi_importe   NUMBER(17, 2);
    vi_instancia xwf700.xwfprcins%type;  
    no_actualizacion EXCEPTION;
    
    LN_MODULO        NUMBER;
    LN_TIPOOPERACION NUMBER;
  BEGIN
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_MODULO
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 2
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1  = ve_Modulo;
    EXCEPTION
      WHEN OTHERS THEN
        LN_MODULO := 101;
    END;
  
    BEGIN
      SELECT F.TP1NRO1
        INTO LN_TIPOOPERACION
        FROM FST198 F
       WHERE F.TP1COD = 1
         AND F.TP1COD1 = 11153
         AND F.TP1CORR1 = 11
         AND F.TP1CORR2 = 3
         AND F.TP1CORR3 > 0
         AND F.TP1NRO1 = ve_Ittope;        
    EXCEPTION
      WHEN OTHERS THEN
        LN_TIPOOPERACION := 359;
    END;
    if ve_modulo = LN_MODULO  and ve_Ittope = LN_TIPOOPERACION then
      vs_coderr := 0;
      BEGIN
        --OBTENER INSTANCIA
        SELECT x.xwfprcins, x.xwfmonto1
          into vi_instancia, vi_importe
          FROM XWF700 X
         WHERE X.XWFEMPRESA = ve_pgcod
           AND X.XWFSUCURSAL = ve_Itsucd
           AND X.XWFMODULO = ve_Modulo
           AND X.XWFMONEDA = ve_Moneda
           AND X.XWFPAPEL = ve_Papel
           AND X.XWFCUENTA = ve_Ctnro
           AND X.XWFOPERACION = ve_Itoper
           AND X.XWFSUBOPE = ve_Itsubo
           AND X.XWFTIPOPE = ve_Ittope
           AND X.XWFCAR3 = '1';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        --ACTUALIZAR REGISTRO DE FAE TURISMO
        UPDATE AQPC274 A
           SET A.AQPC274TCOD  = ve_Pgcod,
               A.AQPC274TSUC  = ve_Itsuc,
               A.AQPC274TMOD = ve_Itmod,
               A.AQPC274TRAN  = ve_Ittran,
               A.AQPC274TREL  = ve_Itnrel,
               A.AQPC274TFCH  = ve_fecha,
               A.AQPC274MNTD  = vi_importe,
               A.AQPC274INS = vi_instancia,
               A.AQPC274EST    = 'D',
               A.AQPC274USU    = ve_Ubuser,
               A.AQPC274COD    = ve_Pgcod,
               A.AQPC274MOD    = ve_Modulo,
               A.AQPC274SUC    = ve_Itsucd,
               A.AQPC274MDA    = ve_Moneda,
               A.AQPC274PAP    = ve_Papel,
               A.AQPC274CTA    = ve_Ctnro,
               A.AQPC274OPER   = ve_Itoper,
               A.AQPC274SBOP   = ve_Itsubo,
               A.AQPC274TOPE   = ve_Ittope,
               A.AQPC274FPRC   = ve_fecha,
               A.AQPC274HPRC  = ve_hora
         WHERE A.AQPC274CTCL = ve_Ctnro AND A.AQPC274CDAP = 1 AND A.AQPC274VGNT =  1;
        IF SQL%ROWCOUNT = 0 THEN
          RAISE no_actualizacion;
        END IF;
      EXCEPTION
        WHEN no_actualizacion THEN
          ve_MsgError := 'NO HUBO ACTUALIZACION';
        WHEN OTHERS THEN
          NULL;
      END;
    End If;
  END;
  -----------------------------------------------------------------
  Procedure SP_CR_VERPAEMYPE_CIIU(PN_PAIS      IN NUMBER,
                                 PN_TIPO      IN NUMBER,
                                 PV_DOCUMENTO IN VARCHAR2,
                                 PV_CIIU      OUT VARCHAR2) IS
  
    lv_petipo varchar2(1);
    lc_numdoc char(12);
    lc_coderr varchar2(100);
    lc_msgerr varchar2(100);  
    
  BEGIN

   -- lv_petipo := pq_client_ciiu.fn_petipo(PN_PAIS, PN_TIPO, PV_DOCUMENTO);
   
   lc_numdoc :=  rpad(trim(PV_DOCUMENTO),12,' ');
   
   begin
       Select u.petipo
         Into lv_petipo
       from fsd001 u
       where u.pepais = PN_PAIS
         and u.petdoc = PN_TIPO
         and u.pendoc = lc_numdoc ;    
   Exception When Others Then
             lv_petipo :=null;          
             lc_coderr :=sqlcode;
             lc_msgerr :=sqlerrm;        
   end fn_petipo;   
  
    If lv_petipo = 'F' Then
    
      BEGIN
        SELECT distinct 'S'
          INTO PV_CIIU
          FROM SNGC60 S
         WHERE S.SNGC60PAIS = PN_PAIS
           AND S.SNGC60TDOC = PN_TIPO
           AND S.SNGC60NDOC = CAST(PV_DOCUMENTO AS CHARACTER(12))
           and S.SNGC60CORR = 0
           AND EXISTS (SELECT 'x'
                  FROM FST198 F
                 WHERE F.TP1COD = 1
                   AND F.TP1COD1 = 11153
                   AND F.TP1CORR1 = 11
                   AND F.TP1CORR2 = 7
                   AND F.TP1CORR3 > 0
                   AND F.TP1IMP1 = S.SNGC60ACTE);
      EXCEPTION
        WHEN OTHERS THEN
          --PV_CIIU := 'N';
          begin
          
            SELECT distinct 'S'
              INTO PV_CIIU
              FROM SNGC60 S
             WHERE S.SNGC60PAIS = PN_PAIS
               AND S.SNGC60TDOC = PN_TIPO
               AND S.SNGC60NDOC = CAST(PV_DOCUMENTO AS CHARACTER(12))
               AND EXISTS (SELECT 'x'
                      FROM FST198 F
                     WHERE F.TP1COD = 1
                       AND F.TP1COD1 = 11153
                       AND F.TP1CORR1 = 11
                       AND F.TP1CORR2 = 7
                       AND F.TP1CORR3 > 0
                       AND F.TP1IMP1 = S.SNGC60ACTE);
          
          EXCEPTION
            WHEN OTHERS THEN
            
              PV_CIIU := 'N';
          end;
      END;
    
    end if;
  
    ----=============
    If lv_petipo = 'J' Then
      Begin
        SELECT distinct 'S'
          INTO PV_CIIU
          From fse001 e001
         Where e001.d511pais = PN_PAIS
           And e001.d511tdoc = PN_TIPO
           --And e001.d511ndoc = CAST(PV_DOCUMENTO AS CHARACTER(12))
           And e001.d511ndoc = CAST(PV_DOCUMENTO AS CHARACTER(12))
           AND EXISTS (SELECT 'x'
                  FROM FST198 F
                 WHERE F.TP1COD = 1
                   AND F.TP1COD1 = 11153
                   AND F.TP1CORR1 = 11
                   AND F.TP1CORR2 = 7
                   AND F.TP1CORR3 > 0
                   AND F.TP1IMP1 = e001.expnins);
      Exception
        when others then
          PV_CIIU := 'N';
      End;
    End If;
  
  END SP_CR_VERPAEMYPE_CIIU;
  
end PQ_CR_FAE_TEXTIL;
/

