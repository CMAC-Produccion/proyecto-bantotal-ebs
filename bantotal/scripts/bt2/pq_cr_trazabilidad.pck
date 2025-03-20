create or replace package PQ_CR_TRAZABILIDAD is

  -- Nombre         : SP_CR_VALIDAR_CRM
  -- Autor          : Maycol Chavez Chuman
  -- Fecha Creacion : 16/05/2022
  ------------------------------------------------------------------------------------------------------
  -- Fecha            Modificacion                                                         Empleado
  ------------------------------------------------------------------------------------------------------
  
  PROCEDURE SP_CR_VALIDAR_CRM(P_InInstance IN NUMBER, P_InPais IN NUMBER, P_InTDoc IN NUMBER, P_InNDoc IN VARCHAR2, P_InPgCod IN NUMBER, P_InMod IN NUMBER, 
                              P_InSuc IN NUMBER, P_InMda IN NUMBER, P_InPap IN NUMBER, P_InCta IN NUMBER, P_InOpe IN NUMBER, P_InSbOpe IN NUMBER, P_InTpOpe IN NUMBER,
                              P_OutPlatf OUT VARCHAR2, P_OutEtapa OUT VARCHAR2, P_OutTarea OUT VARCHAR2, P_OutUsu OUT VARCHAR2, P_OutFchCrea OUT TIMESTAMP, 
                              P_OutFchBT OUT DATE);

end PQ_CR_TRAZABILIDAD;
/

create or replace package body PQ_CR_TRAZABILIDAD is


PROCEDURE SP_CR_VALIDAR_CRM(
  P_InInstance IN NUMBER, 
  P_InPais IN NUMBER, 
  P_InTDoc IN NUMBER, 
  P_InNDoc IN VARCHAR2, 
  P_InPgCod IN NUMBER, 
  P_InMod IN NUMBER, 
  P_InSuc IN NUMBER,
  P_InMda IN NUMBER, 
  P_InPap IN NUMBER, 
  P_InCta IN NUMBER, 
  P_InOpe IN NUMBER, 
  P_InSbOpe IN NUMBER, 
  P_InTpOpe IN NUMBER,
  P_OutPlatf OUT VARCHAR2, 
  P_OutEtapa OUT VARCHAR2, 
  P_OutTarea OUT VARCHAR2, 
  P_OutUsu OUT VARCHAR2, 
  P_OutFchCrea OUT TIMESTAMP, 
  P_OutFchBT OUT DATE) IS
  
  -- VARIABLES DE LA TABLA JAQA400
  vEmp JAQA400.JAQA400EMP%TYPE;
  vMod JAQA400.JAQA400MOD%TYPE;
  vSuc JAQA400.JAQA400SUC%TYPE;
  vMda JAQA400.JAQA400MDA%TYPE;
  vPap JAQA400.JAQA400PAP%TYPE;
  vCta JAQA400.JAQA400CTA%TYPE;
  vOpe JAQA400.JAQA400OPE%TYPE;
  vSbo JAQA400.JAQA400SBO%TYPE;
  vTop JAQA400.JAQA400TOP%TYPE;
  vFec JAQA400.JAQA400FEC%TYPE;
  vEst JAQA400.JAQA400EST%TYPE;
  
  -- VARIABLES DE LA TABLA V_REPROG
  vReprogCodAnl V_REPROG.CODANALISTA%TYPE;
  vReprogEstSol V_REPROG.ESTADOSOLICITUD%TYPE;
  vReprogFecha  TIMESTAMP(6);
  
  -- VARIABLES DE LA TABLA LEY31050
  vLeyCodAnl LEY31050.CODANALISTA%TYPE;
  vLeyEstSol LEY31050.ESTADOSOLICITUD%TYPE;
  vTpFacl    LEY31050.TIPOFACILIDAD%TYPE;
  vLeyFecha  TIMESTAMP(6);
  
  -- VARIABLES DE LA TABLA FONDOS
  vFondosCodAnl FONDOS.CODANALISTA%TYPE;
  vFondosEstSol FONDOS.ESTADOSOLICITUD%TYPE;
  vFondosFecha  TIMESTAMP(6);
  
  -- VARIABLES DEL CRM
  vFechaCRM TIMESTAMP(6);
  vCodAnlCRM VARCHAR2(20);
  
  -- VARIABLES DE LA TABLA AQPB561
  vAQPB561Est   AQPB561.AQPB561EST%TYPE;
  vAQPB561PCarg AQPB561.AQPB561PCARG%TYPE;
  vAQPB561Usrm  AQPB561.AQPB561USRM%TYPE;
  vAQPB561Fecr  AQPB561.AQPB561FECR%TYPE;
  
  vFST811RgCod FST811.REGCOD%TYPE;
  
  vPendAUsu VARCHAR2(10);
 
  BEGIN
    IF P_InInstance IS NOT NULL THEN
      SELECT JAQA400EMP, JAQA400MOD, JAQA400SUC, JAQA400MDA, JAQA400PAP, JAQA400CTA, JAQA400OPE, JAQA400SBO, JAQA400TOP, MAX(JAQA400FEC)
      INTO vEmp, vMod, vSuc, vMda, vPap, vCta, vOpe, vSbo, vTop, vFec
      FROM JAQA400 
      WHERE JAQA400AI1 = P_InInstance
      GROUP BY JAQA400EMP, JAQA400MOD, JAQA400SUC, JAQA400MDA, JAQA400PAP, JAQA400CTA, JAQA400OPE, JAQA400SBO, JAQA400TOP;
    ELSE
      SELECT JAQA400EMP, JAQA400MOD, JAQA400SUC, JAQA400MDA, JAQA400PAP, JAQA400CTA, JAQA400OPE, JAQA400SBO, JAQA400TOP, MAX(JAQA400FEC)
      INTO vEmp, vMod, vSuc, vMda, vPap, vCta, vOpe, vSbo, vTop, vFec
      FROM JAQA400 
      WHERE JAQA400EMP = P_InPgCod AND JAQA400MOD = P_InMod AND JAQA400SUC = P_InSuc AND JAQA400MDA = P_InMda AND 
            JAQA400PAP = P_InPap AND JAQA400CTA = P_InCta || '-' ||P_InOpe AND JAQA400SBO = P_InSbOpe AND JAQA400TOP = P_InTpOpe
      GROUP BY JAQA400EMP, JAQA400MOD, JAQA400SUC, JAQA400MDA, JAQA400PAP, JAQA400CTA, JAQA400OPE, JAQA400SBO, JAQA400TOP;
    END IF;
      
    BEGIN
      SELECT CODANALISTA, ESTADOSOLICITUD,
       CASE ESTADOSOLICITUD
         WHEN 'CU' THEN FECENPROCESO
         WHEN 'BT' THEN MAX(FECPENDBT)
       END  
      INTO vReprogCodAnl, vReprogEstSol, vReprogFecha
      FROM V_REPROG
      WHERE CUENTAOPERACION = vCta || '-' ||vOpe
      GROUP BY CODANALISTA, ESTADOSOLICITUD, FECENPROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        vReprogFecha := TO_TIMESTAMP('01/01/01 01:01:01,000000', 'DD/MM/YY HH:MI:SS,FF'); 
    END;
      
    BEGIN
      SELECT A.CODANALISTA, A.TIPOFACILIDAD, A.ESTADOSOLICITUD, 
       CASE A.ESTADOSOLICITUD 
         WHEN 'BT' THEN A.FECHAENBANTOTAL
         WHEN 'CU' THEN MAX(A.FECHAENCURSO) 
       END
      INTO vLeyCodAnl, vTpFacl, vLeyEstSol, vLeyFecha
      FROM LEY31050 A, LEY31050_CREDITOSFACILIDAD B
      WHERE A.IDLEY31050      = B.IDLEY31050 AND
            B.CUENTAOPERACION = vCta || '-' ||vOpe AND B.EMPRESA = vEmp AND
            B.SUCURSAL        = vSuc    AND B.MODULO        = vMod AND
            B.MONEDA          = vMda    AND B.PAPEL         = vPap AND    
            B.SUBOPERACION    = vSbo    AND B.TIPOOPERACION = vTop
      GROUP BY A.CODANALISTA, A.TIPOFACILIDAD, A.ESTADOSOLICITUD, A.FECHAENBANTOTAL; 
    EXCEPTION
      WHEN OTHERS THEN
        vLeyFecha := TO_TIMESTAMP('01/01/01 01:01:01,000000', 'DD/MM/YY HH:MI:SS,FF'); 
    END;
      
    BEGIN
      SELECT A.CODANALISTA, A.ESTADOSOLICITUD, 
       CASE A.ESTADOSOLICITUD
         WHEN 'BT' THEN A.FECHAENCURSO
         WHEN 'CU' THEN MAX(A.FECHAPENDIENTE)
       END
      INTO vFondosCodAnl, vFondosEstSol, vFondosFecha
      FROM FONDOS A, FONDOS_CREDITOSFACILIDAD B 
      WHERE A.IDFONDO         = B.IDFONDO AND
            B.CUENTAOPERACION = vCta || '-' ||vOpe AND B.EMPRESA = vEmp AND
            B.SUCURSAL        = vSuc    AND B.MODULO          = vMod AND
            B.MONEDA          = vMda    AND B.PAPEL           = vPap AND
            B.SUBOPERACION    = vSbo    AND B.TIPOOPERACION   = vTop
      GROUP BY A.CODANALISTA, A.ESTADOSOLICITUD, A.FECHAENCURSO;
    EXCEPTION
      WHEN OTHERS THEN
        vFondosFecha := TO_TIMESTAMP('01/01/01 01:01:01,000000', 'DD/MM/YY HH:MI:SS,FF'); 
    END;
           
    IF vReprogFecha > vLeyFecha THEN
       vFechaCRM  := vReprogFecha;
       vCodAnlCRM := vReprogCodAnl;
       IF vFechaCRM < vFondosFecha THEN
          vFechaCRM  := vFondosFecha;
          vCodAnlCRM := vFondosCodAnl;
       END IF;
    ELSE
       vFechaCRM  := vLeyFecha; 
       vCodAnlCRM := vLeyCodAnl;
       IF vFechaCRM < vFondosFecha THEN
          vFechaCRM  := vFondosFecha;
          vCodAnlCRM := vFondosCodAnl;
       END IF;
    END IF;

    BEGIN
      SELECT A.TIPOFACILIDAD 
      INTO vTpFacl
      FROM LEY31050 A, LEY31050_CREDITOSFACILIDAD B
      WHERE A.IDLEY31050      = B.IDLEY31050 AND
            B.CUENTAOPERACION = vCta || '-' ||vOpe AND B.EMPRESA       = vEmp AND
            B.SUCURSAL        = vSuc    AND B.MODULO        = vMod AND
            B.MONEDA          = vMda    AND B.PAPEL         = vPap AND    
            B.SUBOPERACION    = vSbo    AND B.TIPOOPERACION = vTop;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END;
        
    IF vFechaCRM > vFec THEN
      IF vTpFacl <> 'CAJA' THEN
        P_OutPlatf   := 'CRM';
        P_OutEtapa   := 'EN GESTION';
        P_OutTarea   := 'EN GESTION';
        P_OutUsu     := vCodAnlCRM;
        P_OutFchCrea := vFechaCRM;
        P_OutFchBT   := NULL;
      ELSE
        BEGIN
          SELECT AQPB561EST, AQPB561PCARG, AQPB561USRM, MAX(AQPB561FECR)
          INTO vAQPB561Est, vAQPB561PCarg, vAQPB561Usrm, vAQPB561Fecr
          FROM AQPB561
          WHERE AQPB561EMP  = vEmp AND AQPB561MOD  = vMod AND AQPB561SUC  = vSuc AND AQPB561MDA = vMda AND AQPB561PAP  = vPap AND
                AQPB561CTA  = vCta AND AQPB561OPER = vOpe AND AQPB561SBOP = vSbo AND AQPB561TOP = vTop AND AQPB561EHAB = 'H' AND
                (AQPB561EST = 'P' OR AQPB561EST = 'A')
          GROUP BY AQPB561EST, AQPB561PCARG, AQPB561USRM;
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END;
            
        IF vAQPB561Est = 'P' THEN
          SELECT REGCOD 
          INTO vFST811RgCod
          FROM FST811
          WHERE OFICOD = vSuc AND REGCOD < 100;
                
          IF vAQPB561PCarg = 202 THEN
            SELECT C.UBUSER
            INTO vPendAUsu
            FROM FST811 A, SNG057 B, FST046 C
            WHERE B.SNG057USR = C.UBUSER      AND C.UBSUC  = A.OFICOD     AND
                  B.SNG055CAR = vAQPB561PCarg AND A.REGCOD = vFST811RgCod AND A.OFICOD = vSuc;
          END IF;
                
          IF vAQPB561PCarg = 220 THEN
            SELECT C.UBUSER
            INTO vPendAUsu
            FROM FST811 A, SNG057 B, FST046 C
            WHERE B.SNG057USR = C.UBUSER      AND C.UBSUC  = A.OFICOD     AND
                  B.SNG055CAR = vAQPB561PCarg AND A.REGCOD = vFST811RgCod AND A.OFICOD = vSuc;
          END IF;
                
          IF vAQPB561PCarg <> 202 AND vAQPB561PCarg <> 220 THEN
            SELECT SNG057USR
            INTO vPendAUsu
            FROM SNG057
            WHERE SNG055CAR = vAQPB561PCarg;
          END IF; 
                
          P_OutPlatf   := 'BANTOTAL';
          P_OutEtapa   := 'APROBACION EN BENEFICIO';
          P_OutTarea   := 'PENDIENTE DE AUTORIZACION';
          P_OutUsu     := vPendAUsu;
          P_OutFchCrea := vAQPB561Fecr;
          P_OutFchBT   := vFec;
        ELSE
          IF vAQPB561Est = 'A' THEN
            BEGIN
              SELECT JAQA400EST
              INTO vEst
              FROM JAQA400 
              WHERE JAQA400EMP = vEmp AND JAQA400MOD = vMod AND JAQA400SUC = vSuc AND JAQA400MDA = vMda AND 
                    JAQA400PAP = vPap AND JAQA400CTA = vCta AND JAQA400OPE = vOpe AND JAQA400SBO = vSbo AND JAQA400TOP = vTop
                    AND JAQA400FEC = vFec;
            EXCEPTION
              WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
            END;
                
            IF vEst = 'S' THEN
              P_OutPlatf   := 'BANTOTAL';
              P_OutEtapa   := 'APROBACION EN BENEFICIO';
              P_OutTarea   := 'AUTORIZADO';
              P_OutUsu     := vAQPB561Usrm;
              P_OutFchCrea := vAQPB561Fecr;
              P_OutFchBT   := vFec;
            ELSE
              P_OutPlatf   := 'BANTOTAL';
              P_OutEtapa   := 'BT';
              P_OutTarea   := 'BT';
              P_OutUsu     := NULL;
              P_OutFchCrea := NULL;
              P_OutFchBT   := vFec;
            END IF;
          END IF;
        END IF;
      END IF;
    ELSE
      P_OutPlatf   := 'BANTOTAL';
      P_OutEtapa   := 'BT';
      P_OutTarea   := 'BT';
      P_OutUsu     := NULL;
      P_OutFchCrea := NULL;
      P_OutFchBT   := vFec;
    END IF;   
  EXCEPTION 
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END SP_CR_VALIDAR_CRM;

end PQ_CR_TRAZABILIDAD;
/

