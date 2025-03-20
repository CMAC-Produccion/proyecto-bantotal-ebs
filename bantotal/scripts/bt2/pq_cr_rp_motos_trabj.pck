create or replace package PQ_CR_RP_MOTOS_TRABJ is

  -- Author  : IGS_RCASTRO
  -- Created : 18/10/2022 12:58:13
  -- Purpose : Resolutor política para créditos de Motos de trabajadores.
  
  procedure sp_validarTieneCredMoto(pn_instancia in number, flgTieneCreMotoVig out varchar2);
  
  procedure sp_pend_transf_propied_venta_unidad(pn_instancia in number, flgTienePendiVentUnidad out varchar2);
  
  PROCEDURE SP_CR_CRED_MOTO_ANTIGUEDAD(P_INSTAN IN NUMBER, P_RESCOD OUT VARCHAR);
  
  PROCEDURE SP_CR_VALIDAR_SALARIO_TITULAR(pINSTANCIA IN NUMBER, pFLAG OUT VARCHAR2);
  
  PROCEDURE SP_CR_VALIDAR_CARGO_TRABJ(pINSTANCIA IN NUMBER, pFLAG OUT VARCHAR2);

end PQ_CR_RP_MOTOS_TRABJ;
/

create or replace package body PQ_CR_RP_MOTOS_TRABJ is


   procedure sp_validarTieneCredMoto(pn_instancia in number, flgTieneCreMotoVig out varchar2) 
   AS  
   flgEsTrabajdor Varchar2(1);
   NroDocCliente varchar2(12);
   TipDoc number;
   Pais number;
   BEGIN
       --VALIDAR SI ES TRABAJADOR
       flgTieneCreMotoVig := 'N';

      BEGIN 
          SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC INTO Pais, TipDoc,NroDocCliente FROM SNG001 WHERE SNG001INST = pn_instancia;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
          Pais  := '';
          TipDoc := '';
          NroDocCliente := '';
      END;
  
                     
       BEGIN
             select 'S' into flgEsTrabajdor  from fsd002 where PFPAIS = Pais and PFTDOC = TipDoc and  PFNDOC = NroDocCliente and pfebco='S';     
       EXCEPTION 
       WHEN NO_DATA_FOUND THEN
          flgEsTrabajdor := 'N';
       END;
       
       IF flgEsTrabajdor = 'S' THEN          
          BEGIN
              SELECT 'S' INTO flgTieneCreMotoVig                            
              FROM FSR008 R, FST198 G, FSD010 C   
              WHERE G.TP1COD = 1
              AND   G.TP1COD1 = 11165                                                
              AND   G.TP1CORR1 = 0
              AND   G.TP1CORR2 = 1
              AND   G.TP1CORR3 > 0
              
              AND   C.PGCOD = 1
              AND   C.AOCTA = R.CTNRO
              AND   C.AOMOD = G.TP1NRO1
              AND   C.AOTOPE = G.TP1NRO2
              AND   C.AOSTAT = 0
                    
              AND   R.PEPAIS = Pais
              AND   R.PETDOC = TipDoc
              AND   R.PENDOC = NroDocCliente
              AND   R.CTTFIR = 'T';

          EXCEPTION 
          WHEN NO_DATA_FOUND THEN
             flgTieneCreMotoVig := 'N';  
          END;     
       ELSE
           flgTieneCreMotoVig := 'N';                    
       END IF;            
       
   END sp_validarTieneCredMoto;
   
   PROCEDURE sp_pend_transf_propied_venta_unidad(pn_instancia in number, flgTienePendiVentUnidad out varchar2) AS
     Pais NUMBER;
     TipDoc NUMBER;
     NroDocCliente VARCHAR2(12);
     flgEsTrabajdor VARCHAR2(1);
     BEGIN 
        flgTienePendiVentUnidad := 'N';
        BEGIN 
             SELECT SNG001PAIS, SNG001TDOC, SNG001NDOC INTO Pais, TipDoc,NroDocCliente FROM SNG001 WHERE SNG001INST = pn_instancia;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
              Pais  := '';
              TipDoc := '';
              NroDocCliente := '';
        END;
                     
        BEGIN
              select 'S' into flgEsTrabajdor  from fsd002 where PFPAIS = Pais and PFTDOC = TipDoc and  PFNDOC = NroDocCliente and pfebco='S';     
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
              flgEsTrabajdor := 'N';
        END;
               
        IF flgEsTrabajdor = 'S' THEN  
             BEGIN
                SELECT 'S' INTO flgTienePendiVentUnidad FROM AQPC199 J 
                WHERE J.AQPC199PAIS = Pais
                AND J.AQPC199TIPDOC = TipDoc
                AND J.AQPC199NRODOC = TRIM(NroDocCliente)
                AND J.AQPC199ESTADO = 'S';                                
             EXCEPTION 
             WHEN NO_DATA_FOUND THEN
                  flgTienePendiVentUnidad := 'N';
             END;  
        END IF;
        
     END sp_pend_transf_propied_venta_unidad; 
     
     
PROCEDURE SP_CR_CRED_MOTO_ANTIGUEDAD(P_INSTAN IN NUMBER, P_RESCOD OUT VARCHAR) IS

ln_XWFCUENTA NUMBER(9);
ln_PEPAIS NUMBER(3);
ln_PETDOC NUMBER(2);
lc_PENDOC CHAR(12);
ld_MAXAOFVAL DATE;
ld_PGFAPE DATE;
lc_VALIDA VARCHAR(1);
ln_VIGENCIA NUMBER(2);

BEGIN
---***
--DBMS_OUTPUT.PUT_LINE('### SP_CR_CRED_MOTO_ANTIGUEDAD ...');
---***
P_RESCOD := 'N';
---*** FECHA DEL SISTEMA
SELECT PGFAPE INTO ld_PGFAPE FROM FST017 WHERE PGCOD = 1;
---*** AÑOS VIGENCIA
SELECT TP1IMP1 INTO ln_VIGENCIA FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11165 
AND TP1CORR1 = 0 AND TP1CORR2 = 3 AND TP1CORR3 > 0;
---***
---*** INSTANCIA - OBTENER CUENTA
SELECT XWFCUENTA INTO ln_XWFCUENTA
FROM XWF700 WHERE XWFPRCINS = P_INSTAN AND XWFCAR3 = '1';
--XWFCUENTA (CON LA CTA OBTENER DOI)
SELECT PEPAIS, PETDOC, PENDOC INTO ln_PEPAIS, ln_PETDOC, lc_PENDOC
FROM FSR008 WHERE CTNRO = ln_XWFCUENTA AND CTTFIR = 'T';
-- CON EL DOI REVISAR LAS CUENTAS
FOR XROW IN (
SELECT * FROM FSR008 WHERE PGCOD = 1 AND PEPAIS = ln_PEPAIS AND PETDOC = ln_PETDOC AND PENDOC = lc_PENDOC AND CTTFIR = 'T')
LOOP
---*** PRODUCTOS
FOR YROW IN (
SELECT * FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11165 AND TP1CORR1 = 0 AND TP1CORR2 = 1 AND TP1CORR3 > 0)
       LOOP
       BEGIN
       SELECT MAX(AOFVAL) INTO ld_MAXAOFVAL FROM FSD010
       WHERE PGCOD = 1 AND AOMOD = YROW.TP1NRO1 AND AOTOPE = YROW.TP1NRO2 AND AOCTA = XROW.CTNRO;
       EXCEPTION ---*** SI NO HAY PASA AL SGTE
          WHEN OTHERS THEN
               P_RESCOD := 'N';
               CONTINUE;
       END;
       --- CALC ANTIGUEDAD
       pq_ah_new_comision.sp_valida_edad_junior(0, ln_VIGENCIA, ld_MAXAOFVAL, ld_PGFAPE, lc_VALIDA);
       IF(lc_VALIDA = 'S') THEN
          P_RESCOD := 'S';
          ---***
          --DBMS_OUTPUT.PUT_LINE('P_INSTAN: '||P_INSTAN);
          --DBMS_OUTPUT.PUT_LINE('XROW.CTNRO: '||XROW.CTNRO);
          --DBMS_OUTPUT.PUT_LINE('ln_VIGENCIA: '||ln_VIGENCIA);
          --DBMS_OUTPUT.PUT_LINE('ld_MAXAOFVAL: '||ld_MAXAOFVAL);
          --DBMS_OUTPUT.PUT_LINE('ld_PGFAPE: '||ld_PGFAPE);
          --DBMS_OUTPUT.PUT_LINE('P_RESCOD: '||P_RESCOD);
          ---***
          RETURN;
       END IF;
       END LOOP;
END LOOP;
---***
EXCEPTION
    WHEN OTHERS THEN
         P_RESCOD := 'N';
---***             
END SP_CR_CRED_MOTO_ANTIGUEDAD;

  PROCEDURE SP_CR_VALIDAR_SALARIO_TITULAR(
  pINSTANCIA IN  NUMBER, 
  pFLAG      OUT VARCHAR2) IS
  -- VARIABLES --
  FLAG VARCHAR2(1) := '0';
  -- CURSOR --
  CURSOR LST_SNG023 IS SELECT * FROM SNG023 WHERE 
  SNG021EVAL IN (SELECT MAX(SNG021EVAL) FROM SNG021 WHERE SNG021SOL = pINSTANCIA) AND
  SNG026COD IN (SELECT TP1NRO3 FROM FST198 WHERE TP1COD = 1 AND TP1COD1 = 11165 AND TP1CORR1 = 0 AND TP1CORR2 = 4 AND TP1CORR3 > 0);
  BEGIN
    -- VALIDA MONTO --
    FOR X IN LST_SNG023 LOOP
      IF X.SNG023MTO <> 0 THEN
        FLAG := '1';
        EXIT;
      END IF;
    END LOOP;
    -- RETORNA FLAG --
    CASE 
      WHEN FLAG = '0' THEN pFLAG := 'N';
      WHEN FLAG = '1' THEN pFLAG := 'S';
      ELSE pFLAG := ' ';
    END CASE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
  END SP_CR_VALIDAR_SALARIO_TITULAR;
  
  PROCEDURE SP_CR_VALIDAR_CARGO_TRABJ(
  pINSTANCIA IN NUMBER, 
  pFLAG OUT VARCHAR2) IS
  -- VARIABLES --
  CTA    NUMBER(9);
  PAIS   NUMBER(3);
  TDOC   NUMBER(2);
  NDOC   VARCHAR2(12);
  CAJA   VARCHAR2(1);
  USU    VARCHAR2(10);
  CARGO  NUMBER(3);
  FLAG   VARCHAR2(1);
  BEGIN
    -- OBTENER CUENTA --
    BEGIN
      SELECT XWFCUENTA
      INTO CTA
      FROM XWF700
      WHERE XWFPRCINS = pINSTANCIA AND XWFCAR3 = '1';
      -- OBTENER PAIS - TP. DOCUMENTO - NRO. DOCUMENTO --
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
        INTO PAIS, TDOC, NDOC
        FROM FSR008
        WHERE PGCOD = 1 AND CTNRO = CTA AND CTTFIR = 'T';
        -- OBTENER VALOR DE CAJA --
        BEGIN
          SELECT PFEBCO
          INTO CAJA
          FROM FSD002
          WHERE PFPAIS = PAIS AND PFTDOC = TDOC AND PFNDOC = NDOC;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        -- OBTENER USUARIO --
        IF CAJA = 'S' THEN
          BEGIN
            SELECT JAQN002USR
            INTO USU
            FROM JAQN002
            WHERE JAQN002PGC = 1 AND JAQN002PAI = PAIS AND JAQN002TDO = TDOC AND JAQN002NDO = NDOC;
            -- OBTENER CARGO --
            BEGIN
              SELECT SNG055CAR
              INTO CARGO
              FROM SNG057
              WHERE SNG055EMP = 1 AND SNG057USR = USU;
              -- VALIDAR SI EL CARGO EXISTE EN LA GUIA --
              BEGIN
                SELECT 'N'
                INTO FLAG
                FROM FST198
                WHERE TP1COD = 1 AND TP1COD1 = 11165 AND TP1CORR2 = 2 AND TP1CORR3 > 0 AND TP1NRO1 = CARGO;
                pFLAG := FLAG;
              EXCEPTION
                WHEN OTHERS THEN
                  pFLAG := 'S';
              END;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_VALIDAR_CARGO_TRABJ;

end PQ_CR_RP_MOTOS_TRABJ;
/

