CREATE OR REPLACE PROCEDURE CTS_REMUNERACION(p_usuario  in varchar2,
                                             p_sucursal in number,
                                             p_verifica in number) AS
 -- **********************************************************************************
  -- Nombre                     : CTS_REMUNERACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Pasivas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 31/01/2014
  -- Autor de Creación          : SMARQUEZ
  -- Uso                        : ACCESOS TEMPORALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :USUARIO,SUCURSAL,VERIFIACION DE CTS O REMUNERACION
  -- Descripción de Modificación: USO DE TABLA TEMPORALE PARA ALMACENAR DATOS
  -- Y LUEGO IMPRIMIR DESDE GENEXUS
  -- **********************************************************************************

  CURSOR CUENTAS (SUCURSAL NUMBER ,OPERACION NUMBER )is
      SELECT distinct R1CTa as CUENTA 
        FROM FSR011
       WHERE Relcod = 45
         AND R2tope = OPERACION
         AND R2SUC  = SUCURSAL;
        
  CURSOR TELF (PAIS NUMBER, TIPODOC NUMBER, NRODOC VARCHAR2)IS
     SELECT DOTELFP
       FROM FSR005
      WHERE PEPAIS = PAIS
        AND PETDOC = TIPODOC
        AND PENDOC = NRODOC;
          
  CURSOR C1  (USUARIO1 CHAR)IS
     SELECT JAQL62SUCU 
       FROM JAQL062
      WHERE JAQL62USER = USUARIO1
        AND JAQL62ESTA = 'S';
   


  VSUC NUMBER;
  VOPE NUMBER;
  VUSU CHAR(10);
  NUMCTA NUMBER;
  NOM1 VARCHAR2(30);
  DIR1 VARCHAR2(140);
  DIS1 VARCHAR2(30);
  PROV VARCHAR2(30);
  DEP1 VARCHAR2(20);
  PAI NUMBER;
  DOC NUMBER;
  NDOC VARCHAR2(12);
  TELEFONO VARCHAR2(60);
  C NUMBER;
  SUCU NUMBER;
  NOMSUC VARCHAR2(30);
BEGIN

  VSUC := P_SUCURSAL;
  VOPE := P_VERIFICA;
  VUSU := TRIM(P_USUARIO);

IF VSUC = 0 THEN
   
    FOR NUM_SUCURSAL IN C1 (VUSU) LOOP
      BEGIN
        SUCU := NUM_SUCURSAL.JAQL62SUCU;   
        SELECT SCNOM 
          INTO NOMSUC 
          FROM FST001 
         WHERE SUCURS = SUCU;
        FOR REG IN CUENTAS (SUCU,VOPE) LOOP
            BEGIN
              SELECT COUNT(*) INTO NUMCTA
                FROM FSR011
               WHERE RELCOD = 45
                 AND R2TOPE = VOPE
                 AND R2SUC = SUCU
                 AND R1CTA = REG.CUENTA;          
            END;
            BEGIN
              SELECT Y.PENOM N1,     --NOMBRE,
                     S.SNGC13DIR N2, --DIRECCION,
                     D.FST071DSC N3, --DISTRITO,
                     E.LOCNOM N4,    --PROVINCIA,
                     T.DEPNOM N5,    --DEPARTAMENTOTO,
                     X.PEPAIS N6,
                     X.PETDOC N7,
                     X.PENDOC N8
                 INTO NOM1,
                     DIR1,
                     DIS1,
                     PROV,
                     DEP1,
                     PAI,
                     DOC,
                     NDOC
                FROM FSR008 X,
                     FSD001 Y, --NOMBRE
                     SNGC13 S, --DIRECCION
                     FST071 D, --DISTRITO
                     FST070 E, --PROVINCIA
                     FST068 T --DEPARTAMENTO
               WHERE X.PEPAIS = Y.PEPAIS
                 AND X.PETDOC = Y.PETDOC
                 AND X.PENDOC = Y.PENDOC
                 AND X.CTNRO = REG.CUENTA
                 AND X.PGCOD = 1
                 AND X.TTCOD = 1
                 AND X.CTTFIR = 'T'
                 AND S.SNGC13PAIS = X.PEPAIS
                 AND S.SNGC13TDOC = X.PETDOC
                 AND S.SNGC13NDOC = X.PENDOC
                 AND S.DOCOD = 1
                 AND S.SNGC13EST = 'H'
                 AND D.FST071PAI = X.PEPAIS
                 AND D.FST071DPT = S.SNGC13DPTO
                 AND D.FST071LOC = S.SNGC13PROV
                 AND D.FST071COL = S.SNGC13DIST
                 AND E.PAIS = D.FST071PAI
                 AND E.DEPCOD = S.SNGC13DPTO
                 AND E.LOCCOD = S.SNGC13PROV
                 AND T.PAIS = E.PAIS
                 AND T.DEPCOD = S.SNGC13DPTO
                 AND ROWNUM < 2 ;
             EXCEPTION
                 WHEN TOO_MANY_ROWS THEN
                   dbms_output.put_line('MUCHAS FILAS');                                 
                 WHEN OTHERS THEN
                    dbms_output.PUT_LINE('error enconRADO - '||SQLCODE||' -ERROR- '||SQLERRM||REG.CUENTA);    
             END;
             C := 0;
             TELEFONO := NULL;
             FOR T IN TELF (PAI,DOC,NDOC) LOOP
                 C := C + 1;
                 IF C = 1 THEN
                   TELEFONO := TRIM(T.DOTELFP);
                 ELSE
                   TELEFONO := TELEFONO ||','||TRIM(T.DOTELFP);
                 END IF;
             END LOOP;
             BEGIN
                INSERT INTO JAQY652
                 (JAQY652COD,
                  JAQY652USU,
                  JAQY652AGE,
                  JAQY652CLI,
                  JAQY652DIR,
                  JAQY652DIS,
                  JAQY652PRO,
                  JAQY652DEP,
                  JAQY652TEL,
                  JAQY652NCT,                  
                  JAQY652TIP )
               VALUES
                 (SEQ_PR_CTSREM.NEXTVAL,
                  TRIM(VUSU),
                  NOMSUC,
                  NOM1,
                  DIR1,
                  DIS1,
                  PROV,
                  DEP1,
                  TELEFONO,
                  NUMCTA,
                  VOPE);
                  COMMIT;
             END;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.PUT_LINE('error enconRADO - '||SQLCODE||' -ERROR- '||SQLERRM);  
      END;  
   END LOOP;
ELSE
   SELECT SCNOM 
     INTO NOMSUC 
     FROM FST001 
    WHERE SUCURS = VSUC;
        FOR REG IN CUENTAS (VSUC,VOPE) LOOP
            BEGIN

              SELECT COUNT(*) INTO NUMCTA
                FROM FSR011
               WHERE RELCOD = 45
                 AND R2TOPE = VOPE
                 AND R2SUC = VSUC
                 AND R1CTA = REG.CUENTA;
            END;
            BEGIN
              SELECT Y.PENOM,     --NOMBRE,
                     S.SNGC13DIR, --DIRECCION,
                     D.FST071DSC, --DISTRITO,
                     E.LOCNOM,    --PROVINCIA,
                     T.DEPNOM,    --DEPARTAMENTOTO,
                     X.PEPAIS,
                     X.PETDOC,
                     X.PENDOC
                INTO NOM1,
                     DIR1,
                     DIS1,
                     PROV,
                     DEP1,
                     PAI,
                     DOC,
                     NDOC
                FROM FSR008 X,
                     FSD001 Y, --NOMBRE
                     SNGC13 S, --DIRECCION
                     FST071 D, --DISTRITO
                     FST070 E, --PROVINCIA
                     FST068 T --DEPARTAMENTO
               WHERE X.PEPAIS = Y.PEPAIS
                 AND X.PETDOC = Y.PETDOC
                 AND X.PENDOC = Y.PENDOC
                 AND X.CTNRO = REG.CUENTA
                 AND X.PGCOD = 1
                 AND X.TTCOD = 1
                 AND X.CTTFIR = 'T'
                 AND S.SNGC13PAIS = X.PEPAIS
                 AND S.SNGC13TDOC = X.PETDOC
                 AND S.SNGC13NDOC = X.PENDOC
                 AND S.DOCOD = 1
                 AND S.SNGC13EST = 'H'
                 AND D.FST071PAI = X.PEPAIS
                 AND D.FST071DPT = S.SNGC13DPTO
                 AND D.FST071LOC = S.SNGC13PROV
                 AND D.FST071COL = S.SNGC13DIST
                 AND E.PAIS = D.FST071PAI
                 AND E.DEPCOD = S.SNGC13DPTO
                 AND E.LOCCOD = S.SNGC13PROV
                 AND T.PAIS = E.PAIS
                 AND T.DEPCOD = S.SNGC13DPTO
                 AND ROWNUM < 2 ;
             EXCEPTION
                 WHEN TOO_MANY_ROWS THEN
                   dbms_output.put_line('MUCHAS FILAS');                                 
                 WHEN OTHERS THEN
                    dbms_output.PUT_LINE('error enconRADO - '||SQLCODE||' -ERROR- '||SQLERRM||REG.CUENTA);   
             END;
             C := 0;
             TELEFONO := NULL;
             FOR T IN TELF (PAI,DOC,NDOC) LOOP
                 C := C + 1;
                 IF C = 1 THEN
                   TELEFONO := TRIM(T.DOTELFP);
                 ELSE
                   TELEFONO := TELEFONO ||','||TRIM(T.DOTELFP);
                 END IF;
             END LOOP;
             BEGIN
                INSERT INTO JAQY652
                 (JAQY652COD,
                  JAQY652USU,
                  JAQY652AGE,
                  JAQY652CLI,
                  JAQY652DIR,
                  JAQY652DIS,
                  JAQY652PRO,
                  JAQY652DEP,
                  JAQY652TEL,
                  JAQY652NCT,
                  JAQY652TIP)
               VALUES
                 (SEQ_PR_CTSREM.NEXTVAL,
                  TRIM(VUSU),
                  NOMSUC,
                  NOM1,
                  DIR1,
                  DIS1,
                  PROV,
                  DEP1,
                  TELEFONO,
                  NUMCTA,
                  VOPE);
                  COMMIT;
             END;
        END LOOP;
END IF;
END;
/

